# DoubleTake Multi-Session Application Tabs
## Implementation Specification + Execution Prompt for an Autonomous Coding LLM

**Target repository:** `olejardamir/DoubleTake`  
**Target behavior:** one browser page containing multiple independent DoubleTake session tabs in the existing chat-header row, with concurrent background execution and one intentionally shared live repository/workspace.  
**Specification status:** SPECIFICATION COMPLETE — DONE. This is a complete, normative implementation specification ready for execution. The Definition of Done checkboxes in Section 33 represent implementation requirements to be verified when code is built, not incomplete sections of this document.

---

# 0. Mission

Implement first-class **application tabs** for DoubleTake.

Today, the main UI presents one current session in the chat header, including the current session name and the text `click to rename`. Replace that single-session presentation with a tab strip in the **same header row**. Every newly created session must appear as another application tab inside the same browser page. The user must be able to switch between those tabs instantly while each session continues to run independently.

The crucial design is:

> **Session/runtime isolation + shared live workspace.**

Session A and Session B MUST have separate conversations, run state, cancellation, event routing, UI drafts, errors, pending questions/permissions, tool displays, and other session-specific state. They MUST nevertheless operate on the same actual DoubleTake repository/workspace, so Session B can inspect and repair code or failures produced or discovered by Session A.

This is **not** a browser-native-tabs feature. It is an internal DoubleTake multi-session UI and runtime feature.

Do not implement cosmetic tabs on top of a single global session. Do not create per-session git worktrees/clones as the default architecture. Do not globally stop existing work when creating, opening, selecting, or closing an application tab.

---

# 1. How to use this document

You are the implementing coding LLM. Execute this specification against the current repository, not against assumptions frozen in this document.

Before changing code:

1. Inspect the current repository at `olejardamir/DoubleTake`.
2. Locate the current implementation by symbol/API behavior, not only by filenames in this document.
3. Characterize current behavior with tests where practical.
4. Preserve unrelated DoubleTake behavior.
5. Adapt names and module boundaries to the current codebase if the repository has changed.

The semantic contracts in this document are mandatory. Pseudocode, proposed type names, and proposed module names are illustrative unless explicitly described as existing code.

If this document and the live repository disagree about a filename or internal symbol, follow the live repository while preserving the required behavior and invariants.

---

# 2. Verified current-code anchors

The following facts were verified against the repository while preparing this specification and are useful starting points. Re-verify them before implementation because `main` can change.

## 2.1 Main UI is currently single-session oriented

`ui/src/App.jsx` currently owns substantial session/UI behavior in one large component. It imports `apiRequest`, run-status contracts, loop control, and subagent helpers.

The current chat header contains a `chat-name-display` element that renders approximately:

```jsx
<div className="chat-name-display" onClick={() => setEditingName(true)}>
  <span className="chat-name-text">{statusInfo.session_name || "Session"}</span>
  <span className="chat-name-hint">click to rename</span>
</div>
```

This header row is the required visual location for the new application tab strip.

## 2.2 New Session currently contains a multi-session blocker

The current `New Session` path calls:

```text
POST /api/session/new
```

and then invokes `stopActiveWorkEverywhere()` before clearing/loading UI state.

That behavior is incompatible with concurrent application tabs.

**Mandatory change:** normal creation of a new application tab MUST NOT call `stopActiveWorkEverywhere()` and MUST NOT cancel, pause, disable, or mutate another session's active run or loop.

`stopActiveWorkEverywhere()` may remain only for a deliberately global control such as an explicit **Stop All** action, if DoubleTake intentionally exposes such an action. It MUST NOT be used for create/open/switch/close semantics.

## 2.3 Existing run APIs already expose useful identity

The current UI references run-aware endpoints such as active-run lookup and run cancellation and tracks run IDs in status information. Preserve compatible behavior while tightening the ownership rules in this specification.

Do not assume that the current presence of a `run_id` automatically makes concurrency correct. Every callback, reducer, stream event, cancel action, and reconnect path must be audited for ownership.

## 2.4 Existing session API exists

`api_server.py` currently exposes `POST /api/session/new` and session-related API behavior. Extend/refactor existing routes rather than creating a parallel incompatible session system.

## 2.5 Existing CSS anchor

`ui/src/App.css` contains styles for the current application UI. Add the tab-strip visual treatment there or in the existing styling architecture rather than introducing an unrelated styling system solely for this feature.

## 2.6 Current unscoped interactive endpoints are concurrency hazards

The current frontend contains interactive paths that were acceptable under a single-active-session mental model but are unsafe once sessions run independently:

- the UI can call `POST /api/chat/pause` without explicit session/run ownership in the request;
- cancellation can fall back to `POST /api/chat/cancel` when a concrete run ID is unavailable;
- the question reply path can call `POST /api/chat/reply` with an answer without enough explicit owner/request identity.

These MUST NOT survive as implicit "act on whatever is current" operations. Pause, resume, cancel, question reply, permission reply, and similar delayed controls must all resolve to an exact owner and must reject stale/mismatched identity.

Do not merely hide these legacy endpoints behind the new tab UI. Fix the server contracts and every caller.

## 2.7 Current browser chat cache is single-session shaped

The current UI uses `localStorage` for an `doubletake_chat_state`-style chat cache/state in addition to genuinely global UI preferences. A single unqualified chat-state key is unsafe for multiple independent application tabs because whichever session writes last can become the apparent state of another session after refresh.

Mandatory migration rule:

- server session/history data remains authoritative;
- retire the single-session chat cache as an authoritative source, or make any still-needed non-authoritative cache explicitly session-keyed and schema-versioned;
- do not erase unrelated global preferences such as theme/key-sound/activity-display settings merely because they also live in `localStorage`.

## 2.8 Extend the existing run-management architecture

`api_server.py` already imports/uses DoubleTake run-management infrastructure (`doubletake_evolve.run_manager`). Inspect and extend the live implementation rather than inventing a second independent run registry with competing truth.

The existing run manager may need substantial refactoring, but there must be one coherent authoritative lifecycle for run creation, ownership, status, cancellation, recovery, and cleanup.

---

# 3. Product behavior: exact user-visible contract

## 3.1 Application tab strip

Replace the single session-name presentation in the normal main-session chat header with a horizontal tab strip.

Each open application tab MUST show at least:

- the session display name;
- active/selected visual state;
- close control;
- a run/activity status signal when applicable;
- an unread/new-activity signal when applicable.

The tab strip MUST remain in the same logical row where the current session title and `click to rename` are displayed.

The selected tab's session becomes the session rendered in the main chat panel.

## 3.2 Creating a new session

When the user invokes **New Session**:

1. Generate a client request/idempotency key for this create attempt.
2. Send the new-session request.
3. Do **not** cancel any existing session or run.
4. Do not insert a permanent real tab until the backend successfully returns a real `session_id`.
5. On success, add that session ID to the open application-tab list exactly once.
6. Select the new tab.
7. Initialize that session's own UI state.
8. Leave every other session unchanged and still running.
9. On failure, show a scoped creation error and do not leave a fake/ghost session tab.

The create action MUST be protected from accidental duplicate activation and network retry duplication. See the idempotency contract below.

## 3.3 Opening an existing session

When the user chooses **Open Session**:

- if that `session_id` is already open in this browser page, focus the existing application tab;
- otherwise add it to `openSessionIds` and select it;
- never create two application tabs in the same page that point to the same backend session by default;
- do not cancel the previously selected session;
- load/reconcile authoritative history and run state for the selected session.

## 3.4 Switching tabs

Switching application tabs MUST be a presentation-state operation, not a runtime-control operation.

On switch:

- update `activeSessionId`;
- render the target session's state;
- restore its draft, scroll position, attachments, expanded UI elements, and other per-session presentation state where applicable;
- reconcile with the backend if local state may be stale;
- mark rendered new activity as viewed at the appropriate point;
- do not stop or restart any session;
- do not swap backend global state to a concept of "the active session".

## 3.5 Closing an application tab

Closing an application tab means **close/hide this view**, not delete the session and not cancel the run.

Therefore:

- remove the session ID from the browser page's `openSessionIds`;
- if the closed tab was selected, choose a deterministic neighboring tab if one remains;
- if no tabs remain, show an intentional empty state with the existing/new-session affordance;
- an active backend run for the closed session MUST continue;
- the session remains persisted server-side;
- reopening the session later MUST show the latest history/run result via reconciliation/replay;
- closing a tab MUST NOT invoke session deletion;
- closing a tab MUST NOT invoke cancellation.

A destructive session-delete action, if supported, remains separate and explicit.

## 3.6 Renaming

Rename belongs to one backend `session_id`.

- Renaming a tab changes only that session's name.
- Rename can be inline in the selected tab or use the existing interaction pattern.
- Optimistic rename is allowed, but MUST roll back or reconcile if server persistence fails.
- A close-button click MUST stop propagation so it cannot accidentally select or enter rename mode.

## 3.7 Independent execution

Two or more application tabs MUST be capable of having active runs at the same time, subject only to deliberate resource limits.

The default run invariant is:

> **At most one active run per backend session, but many different sessions may each have one active run concurrently.**

If DoubleTake intentionally supports queued/multiple runs within one session in the future, that requires a separate design. Do not accidentally implement it as part of this feature.

## 3.8 Shared repair behavior

A required scenario is:

1. Session A starts a run and changes shared workspace files.
2. Session B is also open and can run concurrently.
3. Session B reads the current shared workspace and notices an error introduced or revealed by Session A.
4. Session B repairs the affected code.
5. Session A's chat/context does not become Session B's chat/context.
6. Session A can see Session B's filesystem changes on its next fresh workspace read.
7. Neither session's events, output, cancellation, pending permissions, or responses leak into the other.

This scenario is a release-blocking acceptance test.

---

# 4. Core invariants

Implement these invariants explicitly in code and tests.

| Area | Invariant |
|---|---|
| Session identity | One backend `session_id` is the canonical identity of one DoubleTake session. |
| Application tab identity | By default, one open application tab in a browser page maps 1:1 to one `session_id`. Do not invent a second durable `tabId` unless a real product requirement needs multiple views of one session. |
| Run identity | Every execution has a unique server-generated `run_id`. |
| Same-session execution | A session has at most one nonterminal active run unless intentionally redesigned. |
| Cross-session execution | Different sessions may run concurrently. |
| Backend selection | The backend has no process-global concept of "currently selected UI tab". |
| Event ownership | Every asynchronous run event is attributable to `session_id` + `run_id` and ordered within the run. |
| Cancellation | A cancel operation targets an expected `session_id` + `run_id`; stale cancellation cannot kill a newer run. |
| UI updates | Async completions update their captured owner session, never whichever tab is selected when the callback resolves. |
| Close | Closing a UI tab does not delete/cancel the backend session/run. |
| Workspace | All sessions intentionally share the same live checkout/workspace. |
| Workspace edits | Same-file DoubleTake writes cannot silently overwrite each other. |
| Browser persistence | Open-tab layout is page-local browser state; chat/history/run state is server-authoritative. |
| Refresh | Refresh restores open-page layout and reconciles running sessions without duplicate messages/events. |
| Restart | Runs lost during a backend crash/restart are marked/reconciled as `interrupted`, not left permanently `running`. |

---

# 5. Canonical identity model

There are three separate identity scopes. Do not collapse them.

## 5.1 `session_id`

Durable DoubleTake conversation/session identity.

Owns or scopes:

- message history;
- session name;
- agent/session configuration that is intentionally session-specific;
- pending questions/permissions;
- subagent relationships where applicable;
- authoritative current/last run association;
- session metadata and persisted history.

## 5.2 `run_id`

Unique identity for one execution inside one session.

Owns or scopes:

- run lifecycle/status;
- cancellation token;
- child process/process group handles;
- ordered event sequence;
- replay buffer/cursor;
- run-local temporary resources;
- tool progress;
- terminal result/error.

A `run_id` MUST never be reassigned to another session.

## 5.3 Browser-page tab layout

Browser presentation state such as:

```ts
type TabLayout = {
  schemaVersion: number;
  openSessionIds: string[];
  activeSessionId: string | null;
};
```

This is not the backend source of truth for sessions. It is a projection of persisted server sessions into the current browser page.

Tab ordering is a browser-page concern by default and SHOULD NOT mutate backend session metadata.

---

# 6. Frontend state architecture

The current `App.jsx` is heavily single-session oriented. Do not solve multi-session behavior by cloning an ever-growing set of top-level globals such as `messages`, `activities`, `streaming`, and `loadedSessionId` and then swapping them manually.

Introduce a session-keyed state architecture.

## 6.1 Required state shape

Exact names may differ, but the semantics should resemble:

```ts
type SessionUiState = {
  sessionId: string;
  sessionName: string;

  messages: Message[];
  activities: Activity[];
  statusInfo: SessionStatus | null;

  activeRunId: string | null;
  activeRunStatus: RunStatus | null;
  lastAppliedRunSeqByRun: Record<string, number>;

  streaming: boolean;
  error: UiError | null;

  draft: string;
  attachments: UiAttachment[];
  scrollState: ScrollState;

  pendingQuestions: Question[];
  pendingPermissions: Permission[];

  subagents: SubagentSummary[];
  activeSubagentId: string | null;
  subagentMessages: Message[] | null;

  mode: string | null;
  model: string | null;

  loopState: SessionLoopState;

  unreadCount: number;
  lastViewedEventSeqByRun: Record<string, number>;

  expandedPanels: Record<string, boolean>;
  selectedArtifactId: string | null;

  hydrated: boolean;
};

type MultiSessionUiState = {
  openSessionIds: string[];
  activeSessionId: string | null;
  bySession: Record<string, SessionUiState>;
};
```

Do not blindly copy these fields. Audit every current React state/ref and classify it as:

- application-global;
- browser-page layout;
- session-specific;
- run-specific;
- subagent-specific;
- transient request-specific.

Anything that can differ between simultaneous sessions MUST NOT remain an unqualified singleton.

## 6.2 State that is commonly session-specific

Audit at minimum:

- messages/history currently rendered;
- activities/tool logs;
- streaming/in-progress state;
- current run ID/status;
- input draft;
- attachments/files staged for the prompt;
- selected model if it can differ per session;
- mode if it can differ per session;
- Auto-Borg/loop state, including enabled, paused, pending, infinite, counters, watchdog state;
- pending questions;
- pending permissions;
- subagent state;
- error messages;
- buffer-trim state;
- timestamps/display state if session-local by current semantics;
- copied-message transient state if it can visually overlap;
- scroll position;
- expanded activity/tool panels;
- selected artifact/output;
- unread/new-activity state.

## 6.3 State that may remain global

Only keep state global if semantics are genuinely application-global, for example:

- theme;
- backend base URL;
- application-wide menu visibility;
- global system settings;
- a stateless/thread-safe API client;
- deliberate shared workspace epoch/notifications;
- an explicit global Stop All operation, if product-supported.

A model client/tool registry MAY be shared only if it is stateless or thread-safe and receives all session/run context explicitly.

## 6.4 Reducer/store ownership rule

Every asynchronous or persisted action that changes session state MUST carry/capture an owner `sessionId`; run-scoped actions MUST also carry the exact `runId` and ordering identity where applicable. Pure synchronous UI-selection actions may derive the selected session at the user gesture boundary, but must capture that identity before any asynchronous work begins.

Illustrative reducer action:

```ts
{
  type: "RUN_EVENT_RECEIVED",
  sessionId,
  runId,
  seq,
  event
}
```

Never write reducer logic equivalent to:

```ts
state.bySession[state.activeSessionId].messages.push(event.message)
```

for an asynchronous event. The selected tab is not ownership metadata.

## 6.5 Async callback capture rule

Before any `await`, promise, timer, stream callback, polling callback, tool callback, or modal continuation that is session-scoped, capture the owning session ID.

Bad:

```js
await sendPrompt();
setMessages(...); // whichever tab is active now
```

Required pattern:

```js
const ownerSessionId = sessionId;
const result = await sendPrompt(ownerSessionId);
dispatch({ type: "...", sessionId: ownerSessionId, result });
```

The same principle applies to `run_id`.

---

# 7. Tab-strip component and UI behavior

## 7.1 Component boundary

Extract a focused tab-strip component instead of making `App.jsx` more monolithic.

Suggested component responsibility:

```text
SessionTabBar
  receives open sessions + activeSessionId
  emits select(sessionId)
  emits close(sessionId)
  emits rename(sessionId, name)
  emits createNew()
```

Exact file/component names are flexible.

## 7.2 Visual placement

Use the current `.chat-header` row and current session-title area as the integration point.

Do not move sessions into a disconnected sidebar unless the existing header cannot technically support a usable strip. The user's required location is the current session-name row.

## 7.3 Overflow

The tab strip MUST remain usable with many open sessions.

Implement at least one robust behavior:

- horizontal scrolling with selected-tab `scrollIntoView`;
- overflow menu plus visible recent tabs;
- another accessible equivalent.

Do not allow tabs to compress until labels/close controls become unusable.

## 7.4 Status indicators

Each tab SHOULD surface compact state:

- running;
- completed/new activity;
- error;
- waiting for question/permission;
- optionally paused loop.

A selected tab does not need an unread badge for content already rendered as viewed.

## 7.5 Unread semantics

Unread state MUST be tied to event/message progress, not a fragile timeout.

Recommended model:

```text
unread = latestMeaningfulSeq > lastViewedMeaningfulSeq
```

Clear unread only after the tab is selected and the corresponding new content has actually been incorporated/rendered, not merely on pointer-down.

## 7.6 Accessibility

Use accessible tabs rather than clickable `<div>` elements only.

Required semantics:

- container `role="tablist"`;
- each session selector `role="tab"`;
- `aria-selected`;
- roving `tabIndex`;
- associated panel semantics (`role="tabpanel"` / IDs) where appropriate;
- Left/Right arrow navigation;
- Home/End navigation;
- Enter/Space activation as appropriate;
- close button has an accessible label such as `Close <session name>`;
- close control is not nested in an invalid interactive element hierarchy;
- focus moves deterministically after close;
- selected tab is scrolled into view.

## 7.7 Keyboard shortcuts

Preserve existing shortcuts such as New Session/Open Session. Their semantics change to new/open **application tab**, not replace-and-stop-current-session.

---

# 8. Session lifecycle algorithms

## 8.1 Create new session: idempotent flow

A network retry or rapid double-click MUST NOT create multiple unintended backend sessions.

Client:

```text
createNewSession():
  if an unresolved create operation already represents this logical gesture:
      reconcile/retry THAT operation with its existing requestKey
      return

  requestKey = UUID()
  fingerprint = canonicalCreateFingerprint(desiredMode, otherImmutableInputs)
  persist pendingOperations[requestKey] BEFORE network send
  mark create pending

  try:
      result = POST /api/session/new {
          mode: desiredMode,
          client_request_id: requestKey
      }

      sid = result.session_id
      ensureSessionUiState(sid, result.metadata)
      add sid to openSessionIds if absent
      activeSessionId = sid
      persist page layout
      remove pendingOperations[requestKey]
  catch definiteRejectedRequest:
      remove/resolve pendingOperations[requestKey]
      show scoped create error
  catch ambiguousNetworkOutcome:
      keep pendingOperations[requestKey]
      reconcile/lookup by SAME requestKey before any retry
      do not manufacture another logical create automatically
  finally:
      clear transient spinner only; unresolved outbox identity remains durable
```

Backend MUST make `client_request_id` durably idempotent for the entire supported ambiguous-retry window, including browser refresh, backend restart, and every supported worker/process routing path. Repeating a request with the same key and same canonical create-request fingerprint MUST return/reconcile to the same created session (or its retained deleted/tombstoned outcome) instead of creating another.

The idempotency relationship MUST be created atomically with session creation through the authoritative persistence/coordinator. A process-local bounded cache is not sufficient for a correctness guarantee. Reuse of the same key with materially different create inputs (for example a different requested mode/template/import identity) MUST return a structured idempotency-key-reuse conflict rather than silently return/create an unrelated session. Retain the mapping/tombstone for at least as long as any client outbox/request may legally retry it.

Return at least:

```json
{
  "session_id": "...",
  "session_name": "..."
}
```

Do not rely on a process-global newly active session to tell the client what was created.

## 8.2 Open existing session

```text
openSession(sid):
  validate/fetch metadata
  if sid already in openSessionIds:
      select sid
  else:
      create/hydrate UiState if absent
      append sid
      select sid
  reconcile history + current run
  persist layout
```

## 8.3 Select session

```text
selectSession(sid):
  assert sid in openSessionIds
  activeSessionId = sid
  render from bySession[sid]
  reconcile if stale/needed
  restore draft + view state
  update viewed cursor once latest content is rendered
  persist layout
```

No cancellation is part of this operation.

## 8.4 Close view

```text
closeSessionTab(sid):
  remove sid from openSessionIds
  if activeSessionId == sid:
      select deterministic neighbor if any
      else activeSessionId = null
  release UI-only subscriptions/resources not needed while closed
  DO NOT cancel backend run
  DO NOT delete backend session
  persist layout
```

If a closed running session is unsubscribed to save client resources, reopening it MUST reconcile/replay from server state.

## 8.5 Rename

```text
renameSession(sid, newName):
  keep previousName
  optimistically update bySession[sid].sessionName
  PATCH/POST existing rename endpoint with sid
  on failure:
      restore previousName or refetch authoritative metadata
      show error scoped to sid
```

---

# 9. Run lifecycle and concurrency

## 9.1 Run creation

Whichever existing API starts a run MUST establish a server-generated `run_id` before asynchronous work can produce unowned events.

The client must learn the `run_id` deterministically, via one of:

- start response before stream consumption;
- first mandatory stream frame/header before any content frame;
- another race-free equivalent.

Do not allow events to arrive before the frontend can associate them with a run.

## 9.2 Runtime registry

The backend needs an ownership structure equivalent to:

```py
runtime_registry: dict[session_id, SessionRuntime]

class SessionRuntime:
    lock
    active_run: RunRuntime | None
    subscribers

class RunRuntime:
    run_id
    session_id
    status
    cancel_token
    owned_processes_or_process_group
    next_seq
    replay_buffer
    started_at
    terminal_at
```

This is conceptual. Integrate with current backend classes/managers rather than duplicating them.

The registry MUST NOT have a singleton "current run" used by all sessions.

## 9.3 Start guard and idempotent admission

Starting a run:

1. resolve and authorize exact `session_id`;
2. require the logical action's stable `client_run_request_id` and canonical request fingerprint;
3. in the authoritative admission transaction/coordinator, check `(session_id, client_run_request_id)` **before** the distinct-run busy guard;
4. if the same key + fingerprint already maps to a run/outcome, return/reconcile that same run even if it is terminal; if the fingerprint differs, return idempotency-key-reuse conflict;
5. otherwise enforce at most one nonterminal top-level run for that session; a distinct start while one is active returns structured conflict/queue semantics;
6. atomically create the unique `run_id`, immutable run-config snapshot, user-message/idempotency records, initial run state, and session active-run reservation as specified later;
7. commit admission before publishing `run.accepted`/ordinary run events;
8. schedule execution asynchronously without holding a global session/workspace lock for the entire LLM/network run.

The admission primitive MUST have the scope required by the supported worker/process topology; a process-local session lock alone is insufficient when another worker can admit the same session. Different `session_id` values MUST not serialize merely because another session is running, except for deliberate global capacity/resource limits.

## 9.4 Terminal state exactly once

Run terminal states include at least semantics equivalent to:

- `completed`;
- `failed`;
- `cancelled`;
- `interrupted`.

Terminal transition MUST be compare/set or otherwise protected so cleanup, cancel, disconnect, and worker completion cannot each write contradictory final states.

## 9.5 Background execution

Closing/switching a UI tab does not own the backend worker lifetime.

Backend execution continues independently of whether:

- its tab is selected;
- its tab is open;
- the client stream temporarily disconnects;
- the browser page is refreshed.

If the existing architecture currently binds run lifetime to the HTTP connection, refactor this. A client disconnect must detach a subscriber, not necessarily terminate the run.

---

# 10. Cancellation: compare-and-cancel, never global guessing

Cancellation is one of the highest-risk concurrency paths.

## 10.1 Required cancel identity

A normal Stop action MUST carry:

```text
session_id
expected run_id
```

If the existing route encodes `run_id` in the path, it still must validate that the run belongs to the supplied/resolved session.

## 10.2 Stale-cancel protection

Consider:

1. Run A1 is active.
2. User clicks Stop.
3. The request is delayed.
4. A1 terminates naturally.
5. Run A2 starts in the same session.
6. Delayed cancellation arrives.

The cancellation MUST NOT cancel A2.

Backend logic must be equivalent to:

```py
if runtime.active_run is None:
    return already_terminal_or_noop
if runtime.active_run.run_id != expected_run_id:
    return 409 STALE_RUN
cancel(runtime.active_run)
```

A request with an old run ID must be a no-op/conflict, never "cancel whichever run is active now".

## 10.3 Cancellation resources

Each run owns its own cancellation token/controller and process handles.

Cancelling Session A MUST NOT:

- flip a global `cancelledRef` that Session B depends on;
- terminate Session B child processes;
- clear Session B loop flags;
- remove Session B subscribers;
- mark Session B messages stopped;
- clear Session B questions/permissions.

## 10.4 Child process termination

If tools/subprocesses are spawned, track ownership by `run_id` and terminate only the process/process group belonging to that run. Avoid broad process-name killing.

## 10.5 Stop All

If DoubleTake retains a deliberate Stop All feature, implement it as an explicit enumeration of active runs followed by individually owned cancellation operations. Do not reuse a hidden global kill side effect for ordinary session controls.

## 10.6 Pause/resume have the same ownership requirements

Pause/resume is not safer than cancellation merely because it is reversible. A delayed pause intended for R1 must never pause R2.

Normal pause/resume requests MUST carry or unambiguously encode:

```text
session_id
expected run_id
requested transition
```

The backend must verify both ownership and current state before applying the transition. If the run has changed, return a structured stale-run/state conflict.

The current bare `POST /api/chat/pause` behavior MUST therefore be replaced/extended so it cannot mean "pause whichever chat is active now".

## 10.7 No unsafe generic cancel fallback

The current UI may fall back to `POST /api/chat/cancel` when it cannot resolve a concrete run ID. That is unsafe in a multi-session implementation.

After this feature:

- ordinary cancellation MUST NOT fall back to an unqualified "current chat/current run" cancel operation;
- if `/api/chat/cancel` is retained for compatibility, require explicit `session_id` + expected `run_id` and perform the same compare-and-cancel validation;
- if the caller cannot identify the target run, it must reconcile/fetch the owning session's active run first or report that there is no target;
- never broaden an ambiguous stop request into Stop All.

---

# 11. Ordered event envelope and stale-event rejection

Tab concurrency is unsafe unless stream events have explicit ownership and ordering.

## 11.1 Event contract

Every asynchronous event that can mutate run/session UI MUST be representable with:

```json
{
  "event_id": "stable-event-id-or-run-sequence-derived-id",
  "seq": 42,
  "session_id": "session-uuid",
  "run_id": "run-uuid",
  "type": "assistant.delta",
  "emitted_at": "2026-08-31T...Z",
  "payload": {}
}
```

Requirements:

- `session_id` is mandatory for session/run events;
- `run_id` is mandatory for run-scoped events;
- `seq` is monotonic within a run;
- `event_id` is stable enough for reconnect deduplication;
- terminal events follow the same identity model;
- questions/permissions/tool progress carry enough identity to route safely.

If the transport is currently line-based/chunked rather than named events, introduce an equivalent envelope at the application protocol layer.

## 11.2 Frontend validation

Before applying an event:

1. locate owner session by `event.session_id`;
2. reject if session is unknown and the event is not from an intentionally subscribable known session;
3. if `event.run_id` is already known, verify it belongs to this session and apply only to that exact run;
4. if the run is not yet known because Start admission may have beaten its HTTP response, establish it **only** through an authoritative `run.accepted`/snapshot/active-run record that is correlated to this session and, for a client-started run, the pending `client_run_request_id`; never adopt an arbitrary unknown run merely because an event arrived first;
5. compare `seq` against `lastAppliedRunSeqByRun[run_id]` and the gap/replay rules;
6. reject duplicate/older events;
7. update the owning session/run only.

Late events from Run N MUST NOT mutate Run N+1 merely because the latter is now active in the same session. A legitimate Run N+1 event that races ahead of the Start HTTP response must still be recoverable through the authoritative admission-correlation path rather than being permanently discarded.

## 11.3 Event transport choices

The exact transport may remain the current one. Safe choices include:

- one multiplexed stream/WebSocket for several sessions, **only if every event is fully owner-tagged**;
- one stream per active/open session, with ownership still validated.

Prefer a multiplexed transport if opening many per-session SSE connections would hit browser connection limits, but do not rewrite transport solely for aesthetic reasons if the current design can safely support the expected scale.

---

# 12. Reconnect, replay, and reconciliation

Refresh/network loss MUST not produce duplicate messages or missing background activity.

## 12.1 Authoritative sources

The server owns:

- session history;
- current run status;
- persisted terminal results;
- pending questions/permissions as appropriate;
- recent replayable run events or an equivalent snapshot/cursor.

The browser does not become the only copy of streamed output.

## 12.2 Reconnect cursor

For SSE, support `Last-Event-ID` or an equivalent explicit cursor. For WebSocket/other transports, send an equivalent `(run_id, last_seq)` resume cursor.

The server MUST either:

A. keep a bounded per-run replay buffer and replay events after the cursor; **or**

B. return an authoritative current snapshot plus a sequence boundary from which live events continue.

Do not blindly replay the entire run into an existing transcript.

## 12.3 Deduplication

The client applies events idempotently by `(run_id, seq/event_id)`.

A reconnect MUST NOT create:

- duplicate assistant messages;
- duplicate tool cards;
- duplicated partial text;
- duplicate questions/permissions;
- duplicate terminal notifications.

## 12.4 Refresh during active run

On page refresh:

1. recover page tab layout from browser page storage;
2. fetch authoritative metadata/history for each restored/open session, at least lazily for inactive tabs;
3. query current active run for each needed session;
4. attach/resume streams with an appropriate cursor;
5. reconcile local vs server state;
6. do not start a replacement run;
7. do not mark a real active run stopped merely because React remounted.

## 12.5 Bounded replay/resources

Replay buffers MUST be bounded by count/bytes/time or persisted appropriately. Subscriber collections MUST remove disconnected clients. Do not introduce an unbounded memory leak per run/tab.

---

# 13. Backend restart/crash semantics

The in-memory runtime registry is ephemeral. Persisted session history and durable run metadata are authoritative across restart to the extent supported by the current architecture.

On backend startup/recovery:

- identify runs persisted as nonterminal for which no live owned worker exists;
- mark/reconcile them as `interrupted` (or equivalent explicit terminal state);
- never leave them forever `running`;
- do not claim resumability unless the execution engine can actually resume safely;
- preserve completed history already persisted.

The frontend must render `interrupted` as distinct from a successful completion.

---

# 14. Shared live workspace: exact concurrency model

The workspace is intentionally shared. This gives Session B the ability to repair Session A's work, but it creates file-write races that must be addressed explicitly.

## 14.1 Do not isolate repositories per session

Do NOT automatically create:

- one clone per session;
- one git worktree per session;
- one branch checkout per tab.

Those designs would make cross-tab live repair invisible and violate the requested behavior.

## 14.2 Fresh-read rule

Conversation context is not a filesystem snapshot.

Before making a mutation based on file contents, tools/agents MUST re-read or revalidate the actual current file state. A session may have reasoned about an older version while another session modified the workspace.

Do not let a stale LLM context silently overwrite a newer file.

## 14.3 Canonical paths

Before coordination/security checks:

- normalize/canonicalize target paths;
- resolve the workspace root;
- reject path traversal outside the permitted workspace;
- account for symlink escape according to DoubleTake's security model;
- define whether writes through symlinks are forbidden or deliberately supported;
- if supported, coordinate both the logical path identity and resolved target as needed, then re-resolve/revalidate after acquiring ownership immediately before commit so a symlink retarget cannot redirect a validated write;
- use canonical resource identities consistently as lock/conflict keys.

## 14.4 Per-file optimistic revision

Every DoubleTake edit primitive MUST use an expected base revision/content hash, or a provably equivalent atomic compare/write mechanism that rejects stale bases. A direct edit path may not opt out merely because callers are expected to re-read correctly.

Conceptual contract:

```text
read file F -> content + base_hash
LLM computes edit relative to that content
acquire canonical per-file lock for F
re-read/re-hash F
if current_hash != base_hash:
    release lock
    return WORKSPACE_CONFLICT
    re-read and replan/reapply
else:
    write safely
    release lock
```

The edit API/tool result MUST expose or otherwise durably associate the resulting new revision/hash needed by subsequent cooperating edits; callers must not guess the post-write base.

The exact hash algorithm is not important; collision-resistant content hashing is suitable.

## 14.5 Same-file DoubleTake write guarantee

Two DoubleTake sessions attempting conflicting writes to the same canonical file MUST NOT resolve as silent last-write-wins.

Within DoubleTake, guarantee this using:

- a canonical per-path lock (or equivalent serialized compare/write primitive);
- expected-base hash/revision verification after acquiring the lock;
- conflict response/re-read/replan when the base changed.

The loser must see an explicit conflict, not success.

## 14.6 External-editor limitation: be accurate

An arbitrary external editor may ignore DoubleTake's in-process locks. A portable filesystem does not universally provide atomic compare-and-swap by content hash.

Therefore:

- DoubleTake MUST guarantee conflict prevention between its own cooperating writers;
- DoubleTake MUST detect external changes that occurred before its final pre-write validation;
- perform the final validation as close as possible to commit;
- use safe temporary-file + atomic replace where appropriate for file integrity;
- do not claim mathematically perfect exclusion against an uncooperative external process that can race after validation unless OS/file-locking support actually enforces it.

This limitation must be documented rather than hidden.

## 14.7 Multi-file edit bundles

For a logically grouped multi-file edit:

1. canonicalize all paths;
2. sort lock keys deterministically to prevent deadlocks;
3. acquire the relevant per-file locks in that order;
4. validate expected hashes for **all** target files before the first write where practical;
5. if any preflight fails, release all locks and make zero changes;
6. write each file safely;
7. if a write fails after partial commit, attempt a verified rollback from captured originals where safe;
8. if full rollback cannot be guaranteed, return an explicit partial-failure result listing exactly which files changed/restored/failed;
9. never label the operation "transactional" unless true atomic/rollback semantics are implemented.

Prefer allowing unrelated bounded different-file edits to overlap when the hierarchical workspace-mutation barrier and per-file revision/lock protocol are implemented and proven safe. For a correctness-first implementation, it is acceptable to serialize the **mutation windows** of such edits under the workspace mutation barrier; never serialize the entire LLM run merely because sessions share a checkout.

## 14.8 Workspace-wide revision

A global workspace epoch/revision MAY be kept for notifications, cache invalidation, diagnostics, or broad staleness signals.

It MUST NOT be the sole edit-conflict mechanism if that would make every change to any file conflict with every unrelated edit. Per-file expected revision is the primary precision mechanism.

---

# 15. Coordination for checkout-global side effects

Some operations cannot safely run concurrently even when files differ. Use a narrow shared workspace coordinator/resource manager for these operations.

Examples include:

- `git checkout` / `git switch`;
- `git reset` / `git clean`;
- branch changes;
- shared git index/staging operations where concurrent mutation is unsafe;
- package installation and lockfile generation;
- database/schema migrations;
- mass formatters touching unknown/broad file sets;
- destructive workspace cleanup;
- fixed-port development-server launch;
- commands that mutate shared caches/config in a known non-concurrent-safe way.

Rules:

1. Coordinate only the resource/operation that needs exclusion.
2. Do not hold a global workspace lock for an entire LLM run.
3. Expose waiting/blocked status as tool activity if delay is meaningful.
4. Release locks on cancellation/failure in `finally`/equivalent cleanup.
5. Define lock ordering if an operation needs multiple resource locks.
6. Add timeout/dead-owner recovery if locks can outlive workers.

A simple conceptual resource key model may use keys such as:

```text
workspace:git-head
workspace:git-index
workspace:package-manager
workspace:schema
port:5173
file:/canonical/path/to/file
```

Use the repository's existing coordination abstractions if present.

## 15.1 Undo/Revert is a shared-workspace mutation

Do not model Undo/Revert as though it only changes the selected session's private state. If it changes repository files, git state, generated artifacts, or other shared workspace data, every application tab can observe the result.

Therefore a revert/restore operation MUST:

1. identify the exact checkpoint/revision/files it intends to restore;
2. revalidate the workspace against the checkpoint before mutation;
3. coordinate all affected files/resources using the same canonical lock/conflict rules as ordinary writes;
4. refuse or explicitly resolve conflicts when another session has modified affected content since the checkpoint;
5. never silently erase another session's newer changes;
6. avoid `stopActiveWorkEverywhere()` merely to perform a selected-session revert;
7. if the requested operation is inherently workspace-wide/destructive, make that scope explicit to the user and run it through the global workspace coordinator.

A "revert Session A" command cannot truthfully promise to revert only A's filesystem effects if later Session B changes overlap those files. Conflict/revision semantics are required.

## 15.2 Coordination must match the real process topology

Do not assume a Python/JavaScript in-memory dictionary, mutex, or event bus is globally authoritative unless DoubleTake is guaranteed to run exactly one process that owns that resource.

Before implementation, determine the actual deployment topology:

- single backend process/worker;
- multiple ASGI workers;
- subprocess workers;
- distributed/background workers;
- multiple DoubleTake server instances sharing one workspace.

If more than one process can create/cancel runs or mutate the same workspace, process-local state alone is insufficient. Use a mechanism whose scope spans every competing process, for example an existing durable run store/coordinator, OS/file locks for workspace resources, database transactions/advisory locks, Redis/distributed coordination, or an explicit single-owner coordinator process. Choose the mechanism that matches DoubleTake's architecture rather than adding infrastructure unnecessarily.

The following invariants must hold across that topology, not merely inside one process:

- at most one active run per `session_id`;
- idempotent `client_request_id` session creation;
- exact run ownership and compare-and-cancel/pause;
- event ordering/replay authority;
- same-file edit exclusion/conflict detection;
- checkout-global resource locking;
- startup orphan/interrupted-run recovery.

If DoubleTake intentionally supports only one backend worker for the shared workspace, encode/assert that deployment constraint so a future multi-worker launch cannot silently invalidate these guarantees.

---

# 16. Ports, subprocesses, caches, and other runtime resources

Concurrent sessions can collide outside the chat state.

Audit all tools that allocate shared resources.

## 16.1 Ports

If two sessions can start development servers:

- allocate dynamic/per-run ports when possible; or
- acquire a named port lease;
- return the actual assigned port to the owning run;
- release the lease on terminal cleanup.

Do not let Session B accidentally kill or reuse Session A's server by assuming a fixed port belongs to "the current run".

## 16.2 Subprocesses

Associate child processes/process groups with `run_id`. Keep handles in run-owned state. Cancellation and cleanup must target only those handles.

A mutation-capable command MUST NOT escape ownership by daemonizing/detaching a background descendant whose lifetime is no longer tracked. Either forbid that launch pattern for mutating tools, or explicitly register/transfer ownership of every surviving descendant/service and retain the required workspace/resource lease until its mutation capability is ended. Parent-process exit alone is not proof that a broad mutator is finished. Use explicit `cwd` and per-child environment copies; never rely on process-global `chdir`/environment mutation.

## 16.3 Temp files/directories

Use run-scoped names/paths for temporary artifacts when concurrent collision is possible. Clean only resources owned by the terminating run.

## 16.4 Caches

Audit shared mutable caches for thread/process safety. A cache key that currently assumes one session may need `session_id`, `run_id`, workspace revision, or another owner dimension.

---

# 17. Browser persistence and page isolation

## 17.1 Use `sessionStorage` for the application-tab layout

The open application tabs/order/selected tab are browser-page presentation state. Persist them in `sessionStorage` by default, not `localStorage`.

Why:

- refresh of the same browser page can restore the layout;
- separate browser windows/tabs do not continuously fight over one shared layout key;
- server remains the source of truth for durable sessions.

Browser implementations may copy initial `sessionStorage` into a newly duplicated/opener-created tab, but those stores then evolve independently. Do not build cross-window synchronization through `localStorage` for this feature.

## 17.2 Persist only safe layout/UI data

Example:

```json
{
  "schemaVersion": 2,
  "openSessionIds": ["s1", "s2"],
  "activeSessionId": "s2",
  "uiBySession": {
    "s1": { "draft": "...", "scrollAnchor": "..." },
    "s2": { "draft": "...", "scrollAnchor": "..." }
  }
}
```

Be conservative with `uiBySession`.

Do NOT store in browser storage merely for convenience:

- canonical transcript/history;
- API secrets/tokens;
- permission secrets;
- large attachment blobs;
- authoritative run state;
- sensitive tool output unless the existing product explicitly permits it.

Draft persistence should respect current privacy behavior. If drafts were not previously persisted, it is acceptable to keep them in memory while still making them per-session.

## 17.3 Migrate legacy browser state

The current `doubletake_chat_state`-style `localStorage` cache is single-session shaped and must not remain an unqualified source of current chat truth. Write a deliberate one-time migration/retirement path that:

- reads only known legacy keys;
- treats their transcript/status data as non-authoritative compared with the server;
- validates any referenced server `session_id`;
- uses a valid legacy session only to seed the initial new `sessionStorage` tab layout where appropriate;
- does not copy one legacy transcript into every tab;
- does not overwrite newer schema state;
- handles malformed/expired state safely;
- removes or stops writing the obsolete single-chat cache after successful migration, unless it has been explicitly redesigned as a session-keyed, schema-versioned non-authoritative cache.

Do not erase unrelated `localStorage` data. Preserve genuinely global preference keys/behavior (for example theme or other UI preferences) unless there is an independent reason to migrate them.

## 17.4 Missing/deleted sessions during restore

If a restored session ID no longer exists:

- remove it from open layout;
- preserve the remaining tab order;
- choose another selected tab deterministically;
- if none remains, show the intentional empty state;
- do not recreate a deleted session silently.

---

# 18. Server/API semantic contracts

Preserve current route names where possible. If exact current endpoints differ, implement these semantics through the existing API rather than needlessly breaking clients.

## 18.1 Session creation

`POST /api/session/new`

Request MUST support a stable client-generated idempotency key (field name may follow existing conventions), for example:

```json
{
  "mode": "...",
  "client_request_id": "uuid"
}
```

Response MUST identify the created session explicitly.

## 18.2 Session list/metadata/history

Existing session list/open APIs must support loading metadata/history by explicit `session_id`. No route should depend on "whatever session was most recently opened globally".

## 18.3 Start run/chat

Existing start/chat endpoint MUST:

- accept/resolve explicit `session_id`;
- require/accept a stable client-generated `client_run_request_id` for each logical Send/Start and preserve the Section 32/38 durable idempotency contract;
- create/return `run_id` race-free through the atomic admission transaction;
- reject a distinct second active run for the same session with structured `409` unless intentional queue semantics exist;
- return the existing run/outcome for an idempotent retry even if that run is already terminal, rather than treating the retry as a new start;
- allow a different session to start concurrently.

## 18.4 Active run

Active-run query by `session_id` returns either no active run or a run object including at least:

```json
{
  "session_id": "...",
  "run_id": "...",
  "status": "running"
}
```

## 18.5 Cancel

Normal cancel MUST target expected run identity, for example:

```text
POST /api/runs/{run_id}/cancel
body/query includes or server resolves + verifies session_id
```

or an equivalent existing contract.

The semantic requirement is compare-and-cancel, not the exact URL.

## 18.6 Pause/resume

Any pause/resume endpoint MUST target an explicit `session_id` + expected `run_id` (whether in path/body/query) and validate ownership/state before transition. The current unqualified `/api/chat/pause` contract must not remain an implicit-current-run operation.

## 18.7 Question/permission replies

Interactive reply endpoints MUST target the exact outstanding request, not merely the currently selected chat. A suitable semantic payload is:

```json
{
  "session_id": "...",
  "run_id": "...",
  "request_id": "question-or-permission-id",
  "answer": "..."
}
```

Use the repository's existing field names where available. The exact URL is flexible, but the current bare `/api/chat/reply` + `{answer}` semantics are not sufficient for concurrent sessions.

The server MUST reject replies when the request ID does not belong to the supplied session/run or is no longer pending. Resolution MUST use one atomic compare-and-set/transactional transition such as `pending -> answered/rejected/cancelled/expired`: exactly one contender wins, and a second browser/window or delayed duplicate cannot resolve the same request again. Replaying the same semantic reply may return the already-resolved result; a conflicting second answer returns a structured already-resolved conflict. It must never answer a newer prompt.

## 18.8 Stream/replay

Stream/replay endpoints must provide event ownership and ordering plus a reconnect cursor.

## 18.9 Structured errors

Return machine-readable errors. Recommended mapping:

- `404`: session/run not found;
- `409`: session already has active run, stale cancel, expected-file revision conflict, or other state conflict;
- `422`: invalid request fields where framework conventions use it;
- `5xx`: unexpected server failure.

Example:

```json
{
  "code": "WORKSPACE_REVISION_CONFLICT",
  "message": "File changed since it was read",
  "session_id": "...",
  "run_id": "...",
  "path": "src/example.py",
  "expected_revision": "...",
  "current_revision": "..."
}
```

Do not force the frontend to parse human prose to understand a conflict.

---

# 19. Questions, permissions, subagents, and governance

Multi-session support is incomplete if only chat text is isolated.

Audit all asynchronous interactive flows.

## 19.1 Questions

A pending question MUST carry/resolve to its owning `session_id`, `run_id` (or equivalent owner if not run-scoped), and a unique `request_id`/`question_id`.

The current frontend behavior that can POST `/api/chat/reply` with only `{answer}` MUST be upgraded so a delayed reply identifies the exact outstanding request.

Answering a question displayed in Session B MUST NOT resolve a question belonging to Session A, and a delayed answer for B/R1 must not answer a later question from B/R2.

Question terminal state (answered/cancelled/expired/run-ended) must be persisted/reconciled sufficiently that refresh or duplicate delivery cannot resurrect or double-answer it. The pending-to-terminal transition is atomic across every supported backend worker/process; run terminalization also resolves/cancels any still-pending owned request so a late browser reply cannot revive it.

Inactive tabs waiting for user input SHOULD show a waiting indicator.

## 19.2 Permissions/governance approvals

Permission requests MUST be scoped by owner identity. Approval/rejection must include enough ID data that delayed UI action cannot approve a newer/different request accidentally.

Use request IDs in addition to session/run identity when several prompts can exist serially.

## 19.3 Subagents

Current `subagentSessions.js` is already session-oriented in parts of the UI. Audit it for hidden assumptions that the parent/current main session is globally singular.

Subagent display state must belong to the owning main `session_id`. Switching Session A -> Session B must not leave Session A's selected subagent/messages rendered under Session B.

## 19.4 Automated governance

Any governance decision cache/approval queue must be keyed so one session cannot consume another session's decision.

---

# 20. Loop / Auto-Borg / watchdog isolation

The current UI has loop/infinite-loop state and stuck-run handling. This is especially vulnerable to global refs.

For each session independently track all loop control state, including semantics equivalent to:

- enabled;
- paused;
- infinite;
- pending next iteration;
- cancellation;
- iteration counters;
- last-progress timestamp;
- watchdog timers;
- completion detection;
- retry state.

A watchdog for Session A MUST query/cancel only Session A's expected `run_id`.

Switching tabs MUST NOT disable a running loop.

Creating Session B MUST NOT clear Session A's loop refs.

A stale Session A watchdog timer MUST NOT cancel a newer A run without verifying expected `run_id`.

Timers must be cleaned up on true loop termination/unmount as appropriate, not merely on tab selection change.

---

# 21. Attachments and artifacts

Audit attachment/artifact ownership.

- A draft attachment selected in Session A must not appear in Session B.
- Temporary upload IDs must be scoped/associated with the owning session/request.
- Closing the UI view should clean only browser-local unused handles when safe; it must not delete backend resources still needed by an active run.
- Artifact completion events must route to the correct session/run.
- Selecting an artifact in one tab must not change another tab's selected artifact.

---

# 22. Observability

Concurrency defects are difficult to diagnose without ownership IDs.

Add/retain structured logging fields for relevant operations:

```text
session_id
run_id
request_id / correlation_id
client_request_id where applicable
event_seq
tool/action name
workspace resource key where applicable
```

Useful metrics/counters include:

- number of active sessions with runs;
- number of active runs;
- stream subscribers;
- replay-buffer sizes;
- stale cancel attempts;
- same-file workspace conflicts;
- workspace-global resource lock waits;
- interrupted runs recovered on startup.

Do not log secrets, full prompt contents, credentials, or sensitive file contents merely to gain observability.

---

# 23. Security boundaries

New concurrency features MUST NOT broaden filesystem or API permissions.

Audit:

- validation of `session_id` and `run_id`;
- authorization/ownership if DoubleTake supports multiple users/tenants now or later;
- workspace containment for file operations;
- canonical path checks;
- `..` traversal;
- symlink escape;
- attachment paths;
- command/tool resource ownership;
- replay endpoint leakage between sessions/users.

Never accept arbitrary client-supplied `session_id` + `run_id` and route data without validating that the run actually belongs to that session.

---

# 24. Failure and race handling

## 24.1 Tab switched while request is in flight

Response updates captured owner session only.

## 24.2 Tab closed while request is in flight

Backend work continues if already started. UI completion either:

- updates retained session cache safely; or
- is discarded from closed-view memory and recovered by reconciliation when reopened.

It must not update the newly selected tab.

## 24.3 Tab reopened while run is active

Fetch active run, hydrate history/snapshot, resume events from cursor, show running state.

## 24.4 Same session opened in another browser window

Server remains authoritative. Multiple subscribers may observe the session. The one-active-run-per-session guard is enforced server-side, so simultaneous start attempts cannot both succeed.

A cancel from either view still requires expected `run_id`.

## 24.5 Run finishes exactly during switch/reconnect

Terminal state and last events reconcile idempotently by run identity/sequence. No double terminal toast/message.

## 24.6 Rename races

Server-authoritative latest rename wins according to existing persistence semantics. A failed optimistic rename reconciles.

## 24.7 Session deletion while open elsewhere

The other view receives 404/reconciliation result, marks/removes the unavailable session gracefully, and never silently creates a replacement under the old ID.

## 24.8 Backend restart while tabs are open

Tabs survive as page layout; each restored session refetches authoritative state; orphan nonterminal runs become `interrupted`.

## 24.9 Workspace conflict during LLM edit

Return a specific conflict to the owning run. Re-read the affected file and re-plan/reapply. Do not silently force overwrite unless the user/tool explicitly invokes a deliberate force operation with appropriate safeguards.

## 24.10 Global resource contention

Show/wait/retry according to resource coordinator policy. Never fake success while operation did not execute.

## 24.11 Delayed pause/resume

A pause/resume request formed for an old run must fail/no-op by expected `run_id`; it must never transition the newer run in that session.

## 24.12 Delayed question/permission reply

A reply formed for a request that has already been answered, expired, or superseded must resolve only against its original `request_id`. It must never be consumed by the next prompt merely because that prompt is now "current".

## 24.13 Explicit application-global actions

Some controls are genuinely application/global by nature (for example an explicit backend shutdown/restart, destructive checkout reset, or Stop All). Do not pretend those effects are session-local. Make scope explicit, coordinate them, persist/reconcile affected runs, and cause every open tab to refresh/recover its authoritative status after the global action.

Frontend/page refresh alone should detach/reconnect subscribers and must not be treated as intentional run cancellation.

---

# 25. Refactoring strategy for `App.jsx`

Do not attempt to keep every current mutable variable as one singleton and copy values on selection. That architecture is vulnerable to stale closures and asynchronous leakage.

Use incremental refactoring:

## Phase A: classify state

Create an inventory of all current `useState`, `useRef`, timers, abort controllers, stream controllers, and callback-owned mutable values in `App.jsx`.

For every item mark:

```text
GLOBAL
PAGE_LAYOUT
SESSION(session_id)
RUN(session_id, run_id)
REQUEST(request_id)
SUBAGENT(parent_session_id, subagent_id)
```

Do not proceed until ambiguous ownership is resolved.

## Phase B: introduce session-keyed store/reducer

Move the session-specific state into `bySession[session_id]` or equivalent. Keep selectors for active-session rendering.

## Phase C: extract tab UI

Replace the current normal `chat-name-display` title with `SessionTabBar` while preserving subagent-specific header behavior deliberately. Decide how the tab strip and subagent "Back" affordance coexist; do not accidentally hide the parent session identity.

A sensible behavior is:

- main application tab strip remains available;
- selected application's content may show a secondary subagent context/back affordance;
- switching application tabs restores that session's own subagent view state.

## Phase D: make callbacks owner-explicit

Rewrite send/stream/cancel/loop/question/permission/rename/load callbacks to receive/capture session identity. Remove reliance on selected global session after an async boundary.

## Phase E: backend hardening

Only after UI ownership is explicit, verify backend concurrency, run registry, cancel, replay, and persistence semantics.

## Phase F: shared workspace coordination

Add per-file optimistic conflict handling and narrow global-resource coordination around tool mutations.

---

# 26. Migration/backward compatibility

The feature must preserve existing sessions.

On first load after upgrade:

1. read new `sessionStorage` layout if valid;
2. otherwise inspect legacy current-session browser state if it exists;
3. if the legacy session exists server-side, open it as the initial application tab;
4. otherwise load the current/default server session only if current product startup semantics require it;
5. if no valid session is available, show the intentional empty state with New Session/Open Session;
6. do not destroy server history.

Existing Session menu actions remain available, with semantics adjusted:

- New Session -> create and select another app tab;
- Open Session -> open/focus app tab;
- rename -> target selected session;
- export/import -> target explicit selected/session ID and not a process-global current session;
- delete -> explicit destructive operation, separate from tab close.

Audit undo/revert as well: current source invokes broad stop behavior around revert. Removing the broad stop is necessary but not sufficient. Revert is a shared-workspace mutation: it must target an explicit checkpoint/files, revalidate revisions, coordinate affected resources, and refuse/resolve overlap with newer changes from another session rather than silently erasing them. It must not stop unrelated sessions merely to make the operation convenient.

---

# 27. Required automated tests

Do not consider the feature complete with manual clicking alone.

Tests should use barriers/delays/fake streams where needed so concurrency genuinely overlaps; sequential tests named "concurrent" are insufficient.

## 27.1 Frontend unit/component tests

### F1 — tab registry

- open S1, S2, S3;
- active selection changes independently;
- no duplicate session ID in `openSessionIds`;
- close selected/nonselected tabs chooses correct state;
- last close gives intentional empty state.

### F2 — per-session drafts

- type draft in S1;
- switch S2, type different draft;
- switch back;
- each draft remains correct.

### F3 — per-session attachments

Attachments selected in S1 never render/send in S2.

### F4 — late async callback

- start async operation in S1;
- switch to S2 before resolution;
- resolve S1 operation;
- only S1 state changes.

### F5 — stale run event

- apply Run S1/R1 events;
- finish R1/start R2;
- deliver delayed R1 event;
- delayed event cannot mutate R2 current transcript/progress.

### F6 — duplicate sequence

Replay same `(run_id, seq)` twice; state changes once.

### F7 — rename rollback

Failed rename returns tab to authoritative/prior name and displays scoped error.

### F8 — close does not cancel

Closing S1 invokes no cancel endpoint.

### F9 — New Session does not call broad stop

Assert the New Session path does not call `stopActiveWorkEverywhere()` or equivalent global cancellation/loop-clearing routine.

### F10 — accessibility

Assert tablist/tab roles, selection, roving tab index, keyboard navigation, and close accessible label.

### F11 — sessionStorage

Tab layout restoration uses `sessionStorage`; no tab-layout synchronization through `localStorage`.

### F12 — subagent isolation

Selected subagent in S1 does not render in S2 and is restored when returning to S1 if that is intended UI behavior.

### F13 — loop isolation

Loop state/timers in S1 are unaffected by creating/selecting/stopping S2.

### F14 — pause ownership in UI

Pause/resume initiated while viewing S1 sends S1's captured expected `run_id`; switching to S2 before request resolution cannot retarget the action.

### F15 — interactive reply ownership

A visible question/permission reply includes the exact owning session/run/request identity. Switching tabs before the response completes cannot resolve another tab's prompt.

### F16 — no unqualified legacy chat cache

Exercise S1 and S2, refresh/restore, and assert that an unqualified legacy `doubletake_chat_state` value cannot overwrite one session with the other's messages/status. Global preference storage remains unaffected.

## 27.2 Backend/API tests

### B1 — true cross-session concurrency

Use a barrier so S1/R1 and S2/R2 are both nonterminal simultaneously. Assert neither start blocks merely on the other session.

### B2 — same-session start conflict

Start S1/R1 and attempt S1/R2 before R1 terminates. Exactly one active run; second start returns structured conflict.

### B3 — run ownership

Lookup/cancel with a run ID that belongs to another session is rejected.

### B4 — stale cancel

- start R1;
- form cancel for R1 but delay delivery;
- finish R1;
- start R2;
- deliver R1 cancel;
- R2 remains active.

### B5 — cancellation isolation

Cancel S1/R1 while S2/R2 is active. R2 and its processes remain alive.

### B6 — event ownership

Events from simultaneous runs always contain correct `session_id`, `run_id`, and monotonically increasing per-run sequence.

### B7 — replay

Disconnect after seq N, produce N+1..N+k, reconnect with cursor N. Receive/apply missing events exactly once.

### B8 — idempotent new session

Send two identical `client_request_id` create requests. Exactly one session is created; both responses identify it.

### B9 — server restart recovery

Persist a run as active, simulate process restart without its worker, recover state. Run becomes `interrupted`, not permanently running.

### B10 — subscriber cleanup

Connect/disconnect streams repeatedly. Subscriber/replay structures remain bounded/no leaked listeners.

### B10a — stale pause/resume

- start S1/R1;
- delay a pause/resume command carrying R1;
- terminate R1 and start R2;
- deliver the delayed transition;
- R2's state is unchanged and server returns stale-run/no-op semantics.

### B10b — question/reply isolation

Create outstanding prompts in S1/R1 and S2/R2. Reply to one by request ID and prove only that request resolves. Then deliver a duplicate/stale reply after the next prompt is created and prove it cannot resolve the newer prompt.

### B10c — no generic cancellation fallback

Exercise the UI/API cancellation path without a known run ID. It must reconcile/fetch or report no target; it must never invoke an unqualified cancel that can stop another/current run.

### B11 — same-file conflict

Two DoubleTake writers read same base F. Writer A commits. Writer B attempts commit with old hash. B gets conflict and A's content is not silently overwritten.

### B12 — different-file coordination

If fine-grained bounded-writer concurrency is implemented, writers for unrelated F1 and F2 can overlap safely. If the correctness-first exclusive mutation barrier is used, their **mutation windows** may serialize while their LLM/network/read-only work remains concurrent. In either model, no whole-run repository mutex is allowed.

### B13 — multi-file preflight

One target file changed before commit. Preflight fails and zero bundle files are written.

### B14 — global resource lock

Two conflicting git-head/package-manager/global operations serialize safely while unrelated nonconflicting work can proceed.

### B15 — canonical path security

Equivalent/escaping paths cannot bypass lock keys or workspace containment.

### B16 — coordination/process-topology proof

If more than one backend process/worker is supported, run the same-session start guard, idempotent create, stale cancel/pause, and same-file conflict tests across different workers/processes. Process-local-only success is insufficient.

If production is intentionally single-worker, add/configure a test/assertion/documented startup constraint proving that unsupported multi-worker mode cannot silently bypass invariants.

## 27.3 End-to-end browser tests

Use Playwright or the repository's E2E framework.

### E1 — core simultaneous sessions

1. Load DoubleTake.
2. Create S1 and start a deliberately delayed run.
3. Create S2 while S1 is still visibly running.
4. Assert S1 was not cancelled.
5. Start delayed run in S2.
6. Assert both are active simultaneously.
7. Switch back/forth repeatedly while output arrives.
8. Verify each transcript/activity belongs to the correct tab.

### E2 — inactive completion/unread

1. Start S1.
2. switch S2;
3. let S1 complete;
4. S1 tab shows completion/new-activity state;
5. S2 content remains untouched;
6. select S1 and verify final output.

### E3 — close/reopen running session

1. start S1;
2. close S1 tab while run is active;
3. verify backend run continues;
4. reopen S1 from sessions list;
5. reconcile/replay and show correct latest state.

### E4 — shared workspace repair

1. S1 writes a known change/error in shared file;
2. S2 re-reads current file and sees it;
3. S2 repairs it;
4. S1 later re-reads and sees S2's repair;
5. chats/events stay isolated.

### E5 — same-file collision

Force S1/S2 to read same base then race conflicting edits. One succeeds first; the other gets a conflict/re-read path. Assert no silent lost update.

### E6 — refresh during run

Start S1, refresh page mid-run, restore tabs, reconnect, verify no duplicate output and run remains/finishes correctly.

### E7 — two real browser tabs/windows

Open two browser top-level contexts and verify page tab-layout changes in one do not continuously rewrite the other's layout through `localStorage`. Server session state may be shared deliberately.

### E8 — stale cancel after newer run

Exercise delayed cancellation over the real API/UI timing and prove newer run survives.

### E9 — duplicate New Session retry

Intercept first successful create response, simulate retry/network ambiguity, replay same idempotency key. UI/backend contain one created session.

### E10 — async response after tab switch

Delay an S1 metadata/history/rename/request response, switch S2, then release response. Only S1 changes.

### E11 — global resource coordination

Run two sessions that request conflicting shared global operations and verify clear serialization rather than corruption.

### E12 — pending permission/question in inactive tab

S1 becomes blocked waiting. Switch S2. S1 shows waiting indicator. Answering S1 request affects only S1/R1.

---

## 27.4 Adversarial completion tests

Add these tests unless the relevant feature is provably inapplicable; mark inapplicability explicitly rather than silently skipping it.

### C1 — run submission retry after terminal

Start S1/R1 with client request key K, let R1 finish, retry identical request K. Exactly one execution exists; retry resolves to R1/result. Reusing K with different immutable content returns conflict.

### C2 — ambiguous create/send across refresh and restart

Let server create/start successfully but suppress the client response. Refresh before reconciliation; where supported, also route retry after backend restart/another worker. The preserved original key resolves to the same session/run and no duplicate is created/executed.

### C3 — immutable run context isolation

Run S1 and S2 concurrently with intentionally different model/mode/config values. Instrument model/tool/event/cancel/subagent paths. Every invocation sees its owning immutable context; changing B cannot mutate A's in-flight configuration.

### C4 — persistence lost-update resistance

Persist simultaneous S1/S2 history plus an overlapping rename/status update. Both histories survive; metadata changes cannot replace transcript/run state from a stale read-modify-write.

### C5 — stale history versus live stream

Delay an S1 history fetch, deliver newer S1 events, then release the older response. Newer content remains and canonical messages/tools are not duplicated.

### C6 — event gap recovery

Apply seq N then N+2. Client does not advance its durable cursor past the gap. Replay/snapshot fills N+1 and canonical state is applied once.

### C7 — concurrent event sequence allocation

Several async producers inside one run emit concurrently. Sequence/event IDs remain unique and ordered according to the run log contract.

### C8 — terminal durability

Inject failures between final-result persistence and terminal-state publication. No client can observe durable successful completion while required final transcript/result is absent.

### C9 — multiplexed replay

If multiplexing is used, interleave S1/R1 and S2/R2, disconnect, resume. Cursor/resume map recovers unseen events from both exactly once; advancing one run cannot skip the other.

### C10 — slow subscriber isolation

Make one subscriber stop reading while heavy output continues. Memory remains bounded; event/run persistence and another session/client continue; slow client eventually reconciles by snapshot/replay.

### C11 — cancel convergence

Delay S1/R1 cleanup after Stop is accepted. R1 remains nonterminal, new S1 run is rejected until terminal, and S2 remains unaffected.

### C12 — unload/unmount is not cancel

Abort/unmount the UI stream through page/component lifecycle without explicit Stop. Backend run continues and can be reopened/reconciled.

### C13 — indirect broad writer coordination

Run a mutating shell/formatter/generator command concurrently with another overlapping writer. It cannot bypass the workspace coordinator or silently clobber.

### C14 — stale validation result

Start test/build at workspace W, mutate a relevant input before it completes, and assert result is marked stale/revalidated rather than accepted as proof of final W+1.

### C15 — bounded workspace conflict retries

Force repeated invalidation beyond retry budget. Run surfaces explicit conflict after bounded retry/backoff; no infinite loop and no force overwrite.

### C16 — external resource ownership

Have two runs allocate same-class private external resources. Names/ownership differ; cleanup of A cannot destroy B.

### C17 — delete active session safety

Attempt delete while R1 is active. Assert configured safe policy and prove no orphan worker can emit into deleted state.

### C18 — loop survives in-app close/reopen

Enable S1 loop, close only its in-app application tab, keep browser page alive, and verify scheduler/current/next iteration continues according to session semantics. Reopen and reconcile.

### C19 — subagent parent isolation

Run subagents under A and B concurrently. Events/questions/cancellation/cleanup stay under the correct parent session/run.

### C20 — consistent export snapshot

Export/copy A while its history is appended and B is selected. Output corresponds to one A revision and cannot be retargeted/cross-contaminated.

### C21 — process topology proof

If multiple workers/processes are supported, repeat same-session start guard, idempotent create/run, stale cancel/pause, persistence, and same-file conflict across distinct workers. If production is intentionally single-worker, assert/document startup constraint in code/config/tests.

# 28. Stress and race tests

Add at least one automated stress test that performs many repetitions with randomized short delays:

- create/open/select tabs;
- start runs in several sessions;
- switch active tab rapidly;
- inject stream events;
- finish/cancel runs;
- close/reopen views;
- perform nonconflicting and conflicting file operations.

At the end assert:

- no event appears under the wrong session;
- no more than one active run exists per session;
- no stale cancel affected a new run;
- no leaked subscriber/controllers remain beyond expected bounds;
- session histories remain distinct;
- shared workspace matches one valid serialized/conflict-resolved outcome.

Use deterministic seeded randomness in CI so failures can be reproduced.

---

# 29. Regression requirements

All existing behavior unrelated to application tabs must continue to work unless a change is explicitly necessary for concurrency.

Audit at minimum:

- New Session;
- Open Session;
- rename;
- import/export;
- copy transcript;
- undo/revert;
- model switch;
- mode switch;
- Auto-Borg / Balancer / Gap Filling behaviors;
- questions;
- permissions/governance;
- subagents;
- activity panel;
- metrics;
- restart backend/frontend actions;
- VPN/system controls;
- theme;
- Jira integration;
- session deletion;
- run cancellation;
- reconnect/status polling;
- mobile/narrow-width layout if supported.

Pay special attention to any current action that calls `stopActiveWorkEverywhere()`. Classify whether it is truly global or should become session-scoped. New Session and normal session loading/switching MUST no longer use it as a global reset.

---

# 30. Explicit anti-patterns: reject these implementations

The implementation fails if it does any of the following.

## 30.1 Fake tabs

Tabs visually switch labels but reuse one global message/run/stream state.

## 30.2 Global backend active session

A backend variable such as `current_session` is changed when the user selects a UI tab and later used to route requests/events.

## 30.3 Global current run

One global run handle means starting S2 replaces/stops S1.

## 30.4 Untagged global event queue

Events are read from one queue without explicit session/run owner metadata and routed using the selected UI tab.

## 30.5 Global stop on create/switch/close

Calling `stopActiveWorkEverywhere()` or equivalent during New/Open/Switch/Close.

## 30.6 Stale cancellation

A cancel request meaning "cancel whatever is active now" without expected run identity.

## 30.7 Async selected-tab mutation

A request starts under S1 but completion calls generic setters that now target S2.

## 30.8 Duplicate views of one session by accident

Open Session creates a second application tab for a `session_id` already open in the same page.

## 30.9 Browser localStorage as authoritative chat/session runtime

A page refresh depends on browser-stored transcripts rather than reconciling with backend state.

## 30.10 Per-session repository clones/worktrees

This would defeat requested live cross-tab repair.

## 30.11 Silent last-write-wins

Two sessions edit the same file and the second blindly overwrites the first from stale context.

## 30.12 Whole-run workspace mutex

One session locks the repository for its entire LLM run and prevents useful cross-session concurrency.

## 30.13 Process-name kill

Canceling one run kills generic process names and can terminate another run's tool/server.

## 30.14 Unbounded stream replay/listeners

Every closed/reconnected tab leaves subscriptions or unlimited events in memory.

## 30.15 Pretend crash resume

UI says a pre-crash run is still running without an actual surviving/resumable worker.

---

# 31. Recommended implementation sequence

Implement in this order to reduce regressions.

## Phase 0 — baseline and source audit

- run current frontend/backend tests;
- map existing session/run/stream endpoints;
- inventory `App.jsx` state/refs/controllers/timers;
- locate all `stopActiveWorkEverywhere()` callers;
- locate all backend singleton/current-session/current-run state;
- locate all filesystem write primitives and global workspace mutations;
- add characterization tests for single-session behavior before refactor.

## Phase 1 — identity and backend contracts

- ensure explicit `session_id` on all relevant APIs;
- ensure unique `run_id` creation/ownership;
- implement compare-and-cancel;
- structured conflicts;
- idempotent new-session creation;
- formal event envelope/sequence.

Do this before relying on UI tabs for correctness.

## Phase 2 — frontend session store

- introduce `openSessionIds` + `activeSessionId` + `bySession`;
- migrate session-specific state/refs;
- make async actions owner-explicit;
- keep compatibility selectors to reduce a giant one-shot rewrite where useful.

## Phase 3 — visible tab bar

- insert tab strip in current chat-header/title row;
- implement create/open/select/rename/close;
- accessibility/overflow/status/unread;
- preserve subagent navigation coherently.

## Phase 4 — concurrent streaming and lifecycle

- allow different sessions to run simultaneously;
- stream owner routing;
- reconnect/replay;
- background close/switch behavior;
- run terminal/cancel cleanup;
- loop/watchdog isolation.

## Phase 5 — persistence/recovery

- `sessionStorage` layout;
- legacy migration;
- refresh hydration;
- server-restart `interrupted` reconciliation;
- duplicate/404 handling.

## Phase 6 — workspace concurrency

- canonical per-file locks;
- expected content revisions;
- safe multi-file edit path;
- narrow global resource coordinator;
- port/process/temp ownership.

## Phase 7 — adversarial tests

- frontend ownership tests;
- backend barriers/race tests;
- E2E simultaneous runs;
- shared repair/conflict scenario;
- reconnect/restart/idempotency;
- stress test.

## Phase 8 — remove compatibility hazards

After tests pass, remove obsolete single-session/global-reset code paths rather than leaving two architectures that can diverge.

---

# 32. Required code-quality properties

- Prefer explicit ownership over implicit globals.
- Prefer small state transitions over mutable cross-cutting refs.
- Centralize tab/session reducers instead of scattered per-tab setter maps.
- Centralize run terminal cleanup.
- Centralize event ownership validation.
- Centralize workspace path canonicalization/conflict checks for DoubleTake write primitives.
- Keep lock scopes narrow and documented.
- Never swallow concurrency conflicts as generic success.
- Add comments explaining invariants where future maintainers might reintroduce a global shortcut.
- Keep APIs backward-compatible where practical, but do not preserve unsafe implicit-current-session semantics just to avoid necessary migration.

---

## 32.1 Adversarial completeness requirements

The following requirements are release-blocking. They close concurrency holes that can remain even after the visible tab UI and basic `session_id`/`run_id` routing are correct.

### 32.1.1 Run/prompt submission idempotency, including ambiguous outcomes

Session creation idempotency is not enough. Every logical user Send/Start action MUST have a stable client-generated run-request idempotency key, scoped by `session_id`, that is reused for all retries of that same logical action.

The server MUST atomically/durably associate:

```text
(session_id, client_run_request_id)
    -> request_fingerprint + run_id + outcome
```

Required behavior:

- the first request creates R1;
- an identical retry with the same key returns/reconnects to R1 or its persisted terminal result;
- the retry MUST NOT create R2 even if R1 already completed before the retry arrives;
- reuse of the same key with materially different immutable request content returns a structured idempotency conflict;
- uniqueness/idempotency must remain true across every supported backend worker/process and backend restart, not merely one process-local dictionary.

A timeout, disconnect, or lost HTTP response is an **ambiguous outcome**, not proof that the server did not act. The frontend MUST preserve the original request key and captured owner long enough to reconcile or retry the same operation. It MUST NOT silently generate a new key and repeat the logical action.

For New Session and Send/Start, the client MUST preserve unresolved request identity across refresh for the supported ambiguous-retry window. The default mechanism is schema-versioned `sessionStorage` with a small `pendingOperations` record containing only non-sensitive request IDs, owner IDs, operation kind, and safe fingerprints/metadata; a provably equivalent window-local reconciliation store is acceptable. Do not store secrets, full prompts, or attachment contents solely for this purpose. Remove the pending record once the outcome is known.

The backend MUST expose enough lookup/retry semantics to reconcile an ambiguous create/run request by its idempotency key after refresh.

### 32.1.2 Immutable run execution context through the full backend stack

Correct API routing is insufficient if shared agent/model/tool objects contain mutable "current" state. Create/adapt one explicit run-owned execution context and propagate it through orchestration, model invocation, tool execution, event emission, subprocess launch, questions/permissions, subagents, and cleanup.

Semantics should resemble:

```py
RunContext(
    session_id=...,
    run_id=...,
    workspace_root=SHARED_WORKSPACE_ROOT,
    cancel_token=...,
    event_sink=...,
    run_config=...,
    resource_owner=...,
    request_correlation_id=...,
)
```

Rules:

- `session_id` and `run_id` are immutable for the lifetime of the run;
- context originates from the explicit request/session, never from whichever UI tab is selected later;
- model/mode/loop/tool configuration that is session-visible is session-owned by default unless explicitly application-global;
- effective run configuration is snapshotted at run start unless a feature deliberately supports owner-validated live reconfiguration;
- a shared client/tool registry is safe only if it is stateless/thread-safe or receives mutable state through the run context;
- no shared agent/client object may hold mutable conversation history, current model, current event sink, current cancellation token, or current session in fields reused concurrently by another run;
- background tasks, timers, callbacks, and subagents capture/derive the correct context before scheduling;
- task-local context helpers may reduce plumbing but must never become an implicit process-global fallback when context is missing.

### 32.1.3 Session/run persistence is itself concurrency-safe

Independent runs can persist history, activities, run state, names, idempotency records, and metadata simultaneously. Audit the persistence layer, not only runtime memory.

MUST guarantee:

- concurrent S1/S2 writes cannot clobber a shared index/catalog/JSON document through stale read-modify-write;
- rename/metadata updates overlapping an active run cannot overwrite newer transcript/run fields;
- message/activity/request entities persisted through both history and events have stable IDs (`message_id`, `activity_id`/tool-call ID, `request_id`, artifact ID where applicable);
- idempotency creation has an atomic/unique constraint across supported workers;
- storage schema changes are versioned, repeatable/idempotent, preserve existing sessions, and never expose a partially migrated store to concurrent runs;
- atomic file replacement alone is not treated as protection against concurrent stale read-modify-write unless an appropriate lock/revision protocol surrounds it.

Do not create a second persistence truth beside the existing DoubleTake session/run store.

### 32.1.4 History hydration, event gaps, and durable terminal ordering

Live events and history fetches can race. A delayed old history response MUST NOT destructively replace state after newer stream events have already arrived.

Canonical history/snapshot responses used during live execution MUST provide stable entity IDs and an ordering boundary: a monotonic session/history revision, included run/event sequence watermark, or another provably ordered equivalent.

Frontend rules:

- merge/reconcile by stable entity IDs; never deduplicate by displayed text, timestamp alone, or array position;
- an optimistic user message must reconcile to its persisted identity/idempotency request rather than appear twice;
- a history request captures its owner and request generation/revision;
- stale snapshots are rejected/merged and cannot erase newer live output;
- if event `seq` jumps from N to N+2, do not advance the durable cursor past the gap; buffer within a strict bound and recover N+1 by replay/snapshot/reconciliation;
- out-of-order buffers are bounded and fall back to authoritative reconciliation on overflow/timeout;
- server sequence allocation remains atomic/serialized within a run even when several async producers emit concurrently.

Do not expose a run as durably `completed` before the final canonical transcript/result needed to render that completion is committed. Prefer one transaction; otherwise enforce ordering equivalent to:

1. persist final message/result/activity state;
2. commit its revision/watermark;
3. publish terminal run status;
4. emit terminal event.

Recovery after failure between these steps must converge to an explicit valid state, never fabricated success.

### 32.1.5 Multiplexed versus dedicated replay cursors

Per-run `seq` is mandatory for ownership/order but is not necessarily a valid transport-global replay cursor.

- dedicated run/session stream: `(run_id, last_seq)` or equivalent is sufficient;
- multiplexed stream carrying several runs: use a stream-global monotonic replay/event cursor **in addition to** per-run `seq`, or an explicit resume map such as `{run_id: last_seq}` for every subscribed run;
- never use one run's highest `seq` as the sole cursor for a multiplexed stream, because it can skip unseen events from another run.

### 32.1.6 Slow-subscriber/backpressure isolation

One inactive/slow/disconnected browser subscriber MUST NOT stall a run, event persistence, or unrelated sessions.

- subscriber/connection queues are bounded;
- do not hold lifecycle/session/workspace locks while awaiting an arbitrarily slow client;
- if a subscriber falls behind the retained replay window, disconnect/reconcile it from an authoritative snapshot rather than grow memory forever;
- terminal/history persistence remains authoritative even with zero healthy subscribers.

### 32.1.7 Cancellation acknowledgement is not terminal completion

Treat Stop as an idempotent state-transition request. A server acknowledgement may mean `cancelling`, not `cancelled`.

- keep the old run nonterminal/active until owned worker/process cleanup is actually terminal;
- block a new same-session run until that terminal state is observed server-side;
- repeated cancel for the same exact run is safe;
- cancellation timeout/failure is explicit and does not cause the UI to pretend the worker disappeared;
- page refresh, React unmount, stream abort, `beforeunload`, `pagehide`, `visibilitychange`, or development StrictMode cleanup MUST NOT be interpreted as user intent to cancel. Only an explicit Stop/Cancel operation requests cancellation.

### 32.1.8 Direct **and indirect** workspace mutators participate in coordination

Protecting only a direct file-edit primitive is insufficient. Audit every tool that can mutate the checkout indirectly, including shell commands, `sed`, generators, codemods, formatters in write mode, package managers, build/codegen tools, git operations, schema tools, IDE/tool-server actions, and plugins/MCP tools.

Classify each invocation before execution:

1. **declared read-only** — no intended shared mutation;
2. **bounded writer** — known canonical file/resource footprint; use the precise locks + expected revisions;
3. **broad/unknown writer** — footprint cannot be bounded safely; acquire a `workspace:broad-mutation` or equivalent exclusive resource for that mutating command.

Unknown shell commands MUST NOT be called read-only merely to preserve concurrency.

All cooperating mutators update/invalidate a lightweight workspace mutation epoch/revision. Per-file expected hashes remain the primary write-conflict mechanism; the global epoch is for invalidation/diagnostics, not a whole-workspace write conflict.

For snapshot-sensitive validation such as tests/build/static analysis:

- capture relevant workspace/input revision at start;
- revalidate at completion;
- if relevant state changed during execution, mark the result stale and rerun/revalidate instead of treating it as proof about the final workspace;
- do not hold a global read lock for every long command by default;
- long-lived live dev servers are intentionally observing evolving files and are not snapshot validation.

Conflict auto-recovery must be bounded with finite retries/backoff. Never livelock forever or escalate silently to force-overwrite.

### 32.1.9 Process-global runtime context is forbidden for per-run state

Concurrent runs MUST NOT use process-global mutation as per-run context:

- no `os.chdir()`/equivalent for one run; pass explicit `cwd`;
- no mutation of process-global `os.environ`/equivalent for run-specific model keys, ports, modes, credentials, or flags; pass explicit child environment copies;
- no run-specific global stdout/stderr redirection or signal-handler mutation unless globally coordinated and semantically necessary;
- no broad process-name killing.

Audit helper/tool wrappers too, not only direct subprocess calls.

### 32.1.10 External named resources need ownership

Audit resources outside ordinary files/process handles: ports, Docker/container/compose names, sockets/pipes, local DB/schema names, browser automation profiles/debug ports, temp service names, and tool-created cloud/dev resources.

Private ephemeral resources use run/session-derived unique names. Intentionally shared resources use canonical resource keys and owner-validated destructive cleanup. Session A cleanup MUST NOT delete Session B's resource because both used a default name.

### 32.1.11 Session deletion while active is explicit and safe

Close-tab remains non-destructive. Delete targets an exact `session_id`.

If the session has a nonterminal run, implement one explicit safe policy:

- preferred: structured `409 SESSION_HAS_ACTIVE_RUN`, requiring Stop + terminal convergence before delete; or
- an explicitly named cancel-and-delete operation that targets the exact run, waits/verifies terminal cleanup, and then deletes consistently.

Never delete durable session/history state while an owned worker can still emit into it. Pending questions/permissions and subscribers must reconcile/close when deletion completes.

### 32.1.12 Loop/Auto-Borg iteration ownership survives in-app tab close

If a session loop schedules multiple executions:

- give the loop a stable session-owned generation/`loop_id` where useful;
- each iteration gets its own unique `run_id` and run-submission idempotency identity;
- N+1 starts only after N is truly terminal;
- stale timers from an older loop generation cannot schedule after disable/restart;
- closing an **in-app application tab** only hides the view and MUST NOT disable an enabled loop or cancel its active iteration;
- move scheduler/state out of a rendered-tab component if unmount would otherwise stop it.

Full browser-page shutdown may preserve existing product loop-resume policy; do not confuse that with in-app tab close/switch.

### 32.1.13 Subagent execution ownership, not just subagent UI ownership

Every subagent/child task carries parent `session_id` + parent `run_id` and its own unique child/subagent identity where needed. Its events, questions, tool calls, cancellation, and cleanup remain under that parent. Concurrent children inside one top-level run do not violate the one-top-level-active-run-per-session invariant. Parent cancellation cannot cancel child work belonging to another session/run.

### 32.1.14 Import/export/copy snapshot consistency

Import/export/copy operations target an explicitly captured `session_id`; switching tabs while the operation is in flight cannot retarget it.

Export/copy while history is changing MUST correspond to one consistent history revision/snapshot or clearly identified watermark. Never iterate a mutable transcript into a torn export that corresponds to no actual revision.

Import that creates a session uses the same concurrency-safe/idempotent persistence path as normal session creation and MUST NOT stop unrelated sessions.

### 32.1.15 Explicit capacity/backpressure policy

Real independence does not require unbounded execution. If provider/system limits exist, expose a deterministic capacity/queue policy:

- structured capacity response or explicit queued/waiting state;
- never enforce capacity by silently cancelling another active session;
- queued work retains exact session/run/request ownership and can be cancelled only by that identity;
- use fair scheduling where practical to avoid starvation.

### 32.1.16 Consistent lock scope and process topology

In-process async coordination must use primitives appropriate to the server runtime and MUST NOT hold lifecycle/workspace locks across long LLM/network/tool awaits. Lock scopes remain narrow. Multi-resource operations use a documented total ordering to avoid deadlock.

Every guarantee above must hold across the **actual supported process topology**. If DoubleTake is deliberately single-worker for one shared workspace, encode/assert that constraint so launching unsupported multiple workers cannot silently bypass in-memory run/idempotency/workspace locks.

# 33. Definition of Done — release gate

Do not claim completion until **every applicable item below is true**.

## UI/application tabs

- [ ] The current session-name row is a usable application tab strip.
- [ ] New Session creates another in-page application tab.
- [ ] Open Session focuses an already-open session rather than duplicating it.
- [ ] Switching is immediate and does not stop background work.
- [ ] Closing a tab does not cancel/delete its backend session.
- [ ] Rename is isolated and handles persistence failure.
- [ ] Overflow is usable.
- [ ] Tab accessibility/keyboard behavior is implemented.
- [ ] Running/waiting/error/unread states are visible enough to manage background sessions.

## Frontend isolation

- [ ] Messages are session-keyed.
- [ ] Activities/tool output are session-keyed.
- [ ] Run state is session/run-keyed.
- [ ] Drafts are session-keyed.
- [ ] Attachments are session-keyed.
- [ ] Questions/permissions are session/run/request-keyed.
- [ ] Subagent view state is parent-session-keyed.
- [ ] Loop/watchdog state is session/run-keyed.
- [ ] Errors/artifact/view state do not leak.
- [ ] Async completions update captured owners, not selected tab.

## Backend/run isolation

- [ ] Unique `run_id` per run.
- [ ] At most one active run per session.
- [ ] Multiple sessions can genuinely run concurrently.
- [ ] No process-global selected UI session drives backend behavior.
- [ ] No process-global current run drives all sessions.
- [ ] No ordinary process-global cancellation flag/controller drives all runs.
- [ ] Run-owned child processes/resources are isolated.
- [ ] Terminal state is set exactly once.

## Events/reconnect

- [ ] Events contain `session_id`, `run_id`, ordering identity.
- [ ] Duplicate/stale events are rejected.
- [ ] Late old-run events cannot mutate new run state.
- [ ] Reconnect resumes/reconciles without duplicate transcript/tool output.
- [ ] Replay/subscriber resources are bounded/cleaned.

## Cancellation / run controls

- [ ] Cancel targets expected run identity.
- [ ] Stale cancel cannot cancel a newer run.
- [ ] Canceling S1 does not affect S2.
- [ ] Pause/resume targets exact session + expected run and stale transitions cannot affect a newer run.
- [ ] No ordinary cancellation path falls back to an unqualified `/api/chat/cancel`/current-run action.
- [ ] `stopActiveWorkEverywhere()` is not called by normal New Session/Open/Switch/Close.

## Shared workspace

- [ ] Sessions use the same live checkout.
- [ ] Sessions re-read/revalidate current files before mutation.
- [ ] Canonical per-file ownership/conflict checks exist.
- [ ] Same-file cooperating DoubleTake writes cannot silently clobber.
- [ ] Different-file edits are never serialized by a **whole-run** repository lock; mutation windows may serialize under the correctness-first workspace mutation barrier, or safely overlap under the proven hierarchical bounded-writer protocol.
- [ ] Multi-file edit preflight/partial-failure semantics are explicit.
- [ ] Git/package/schema/destructive global operations are narrowly coordinated.
- [ ] Undo/Revert cannot silently erase newer overlapping changes made by another session.
- [ ] Ports/processes/temp resources cannot accidentally collide/kill another run.

## Persistence/recovery

- [ ] Browser tab layout uses `sessionStorage` by default.
- [ ] Server remains authoritative for history/run state.
- [ ] The legacy unqualified `doubletake_chat_state`-style cache cannot overwrite/cross-contaminate sessions.
- [ ] Global preference storage remains preserved unless intentionally migrated.
- [ ] Legacy state migrates safely.
- [ ] Refresh during active run works.
- [ ] Missing/deleted restored sessions are handled.
- [ ] Pre-crash orphan running states become `interrupted` after restart.

## API/diagnostics/security

- [ ] New-session creation is idempotent for duplicate/retry request keys.
- [ ] Question/permission replies target exact session/run/request identity and stale replies cannot resolve a newer request.
- [ ] Coordination guarantees remain valid for the supported backend process/worker topology.
- [ ] State conflicts return machine-readable errors.
- [ ] Logs include session/run/correlation identity without leaking secrets.
- [ ] Run-session ownership is validated server-side.
- [ ] Workspace path containment/canonicalization remains secure.

## Adversarial correctness

- [ ] Run/prompt submission is idempotent across retry-after-terminal, lost response, refresh, supported worker routing, and backend restart.
- [ ] Ambiguous create/send outcomes preserve and reconcile the original request identity instead of generating a blind fresh request.
- [ ] Every model/tool/subagent/background path receives the correct immutable run context; no mutable shared agent/current-model/current-session fields cross runs.
- [ ] Concurrent history/session/run persistence cannot lose updates through stale shared read-modify-write.
- [ ] Stable IDs and snapshot/event watermarks prevent stale history from erasing or duplicating newer live output.
- [ ] Event sequence gaps trigger replay/reconciliation; they are never silently skipped.
- [ ] Successful terminal state is durably ordered after required final transcript/result persistence.
- [ ] Multiplexed transport, if used, has an unambiguous global cursor or per-run resume map in addition to per-run sequence.
- [ ] Slow subscribers cannot block run execution/persistence or unrelated sessions, and buffers are bounded.
- [ ] Stop acknowledgement does not free a session for a new run before old worker cleanup reaches terminal.
- [ ] React unmount/page lifecycle/stream abort does not implicitly cancel backend work.
- [ ] Indirect mutating tools cannot bypass workspace coordination.
- [ ] Snapshot-sensitive validation detects relevant concurrent workspace changes and reruns/revalidates.
- [ ] Workspace conflict auto-retry is finite/backed off and never silently force-overwrites.
- [ ] Per-run CWD/environment/stdio/signal context does not mutate process-global state unsafely.
- [ ] Ports/temp/processes/containers/sockets/services and other named resources cannot collide or be cleaned up by another run.
- [ ] Active session deletion cannot leave a live orphan worker.
- [ ] Enabled loop scheduling is session-owned and survives in-app application-tab close/reopen.
- [ ] Subagent execution/cancellation carries explicit parent session/run ownership.
- [ ] Import/export/copy targets explicit sessions and active exports are consistent snapshots/revisions.
- [ ] Capacity/backpressure never enforces limits by silently cancelling unrelated sessions.
- [ ] All guarantees hold for the actually supported process/worker topology.

## Automated evidence

- [ ] Frontend tests cover ownership and stale async behavior.
- [ ] Backend tests prove true overlapping cross-session runs.
- [ ] E2E tests prove switching while both sessions stream.
- [ ] E2E close/reopen running session passes.
- [ ] Shared workspace repair scenario passes.
- [ ] Same-file race test proves no silent lost update.
- [ ] Stale-cancel race test passes.
- [ ] Duplicate-create idempotency test passes.
- [ ] Refresh/reconnect test passes without duplicate events.
- [ ] Restart/interrupted test passes.
- [ ] Existing regression suite passes.

---

# 34. Final acceptance scenario

This exact scenario must work end to end before declaring the feature done:

1. Open DoubleTake in one browser page.
2. Session A is visible as application tab A in the current title/header row.
3. Start a long-running task in A.
4. While A remains running, invoke **New Session**.
5. Application tab B appears in the same row and becomes selected.
6. A remains visibly marked as running and its backend work is still active.
7. Start a task in B.
8. Backend proves A and B are simultaneously nonterminal.
9. Switch A -> B -> A repeatedly while both emit events.
10. Every message/tool/activity remains under its owning session.
11. Stop B; A continues.
12. Start a new B run; a delayed old B cancel/event cannot affect it.
13. Let A modify a shared repository file.
14. B freshly reads that same live file and sees A's change.
15. B repairs the code.
16. A freshly reads the file and sees B's repair.
17. If A and B race a stale write to the same file, one receives an explicit conflict/re-read path rather than silently overwriting the other.
18. Close A's application tab while A has another active run; its backend run continues.
19. Reopen A from Open Session; its history/status catches up without duplicate events.
20. Refresh the browser; open application tabs restore from page storage and reconcile with server state.
21. Pause A while B runs; only A pauses. Deliver a stale old pause after A starts a newer run; the newer run is unaffected.
22. Put A and B into independent waiting-for-input states; answering A's exact request cannot answer B's, and a delayed old answer cannot answer A's next request.
23. Exercise Undo/Revert against content another session has since changed; the operation must conflict/revalidate rather than silently erase the newer work.
24. Verify the concurrency guarantees under the actual supported backend worker/process topology, not just one in-memory test process.
25. Lose a successful create/send response, refresh before outcome is known, and reconcile using the original request key; no duplicate session/run appears.
26. Run A/B with different model/mode settings and prove immutable run context/configuration isolation through tools/subagents.
27. Release an older delayed A history response after newer A events; newer output remains. Introduce an event sequence gap and prove it is recovered before cursor advancement.
28. Make one subscriber arbitrarily slow; A/B execution and persistence remain live and bounded.
29. Accept Stop for A while delaying cleanup; A cannot start a new run until the old run is truly terminal, while B continues.
30. Execute an indirect mutating shell/formatter/generator command overlapping another writer and prove it cannot bypass conflict/coordination.
31. Change a relevant file while a test/build is running; its result is treated as stale/revalidated. Force repeated edit conflicts and prove bounded retry termination.
32. Attempt deletion of a running session and verify the safe active-run policy leaves no orphan worker.
33. Close/reopen an in-app tab with an enabled loop and prove loop ownership survives the view lifecycle.
34. Export/copy A while A is changing and B is selected; result is one consistent A revision.
35. If multiplexed streaming is used, reconnect with interleaved A/B events and prove the cursor cannot skip either run.
36. No chat context, event output, question, permission, cancellation, pause state, loop state, model/configuration, artifact/resource ownership, or error crosses session boundaries.

If any item fails, the implementation is not complete.

---

# 35. Self-audit loop for the implementing LLM

After implementation, repeatedly run the following audit. The loop terminates only when **two consecutive complete passes** each produce zero new material defects or uncovered requirements and all required tests pass. Any material finding resets the consecutive-clean-pass count to zero.

This is a convergence loop, not a literal unbounded process.

## Audit Pass A — ownership search

Search the codebase for:

```text
activeSession
currentSession
loadedSessionId
currentRun
activeRun
cancelled
AbortController
stream
EventSource
WebSocket
setMessages
setActivities
questions
permissions
loopEnabled
loopInfinite
stopActiveWorkEverywhere
/api/chat/pause
/api/chat/cancel
/api/chat/reply
doubletake_chat_state
client_run_request_id
pendingOperations
RunContext
current_model
current_mode
beforeunload
pagehide
visibilitychange
os.chdir
os.environ
subscriber
backpressure
message_id
activity_id
lastAppliedRunSeq
localStorage
sessionStorage
```

For every hit, prove ownership is correct for multiple simultaneous sessions.

## Audit Pass B — API identity

For every session/run-affecting endpoint, answer:

- What `session_id` does this request target?
- What `run_id` does it target if run-scoped?
- What `request_id` does it target for question/permission/approval interactions?
- Can a delayed request target a newer run or newer prompt accidentally?
- Can it read/mutate another session?
- Does the ownership guarantee remain true across every supported backend worker/process?
- Is conflict/error response structured?

Any unclear answer is a defect.

## Audit Pass C — asynchronous callbacks

For every promise/`await`/timer/subscription/poll/controller:

- capture owner before async boundary;
- apply result by owner;
- reject stale run identity/sequence;
- clean resources by owner.

## Audit Pass D — execution context and persistence

For every orchestration/model/tool/subagent invocation, prove immutable session/run context is explicit or safely task-local. Search shared clients/agents for mutable current conversation/model/session/cancel/event state.

For every session/history/run/idempotency persistence mutation, prove concurrent different-session writes cannot clobber shared catalogs, same-session metadata cannot overwrite transcript/run fields from stale state, and uniqueness/idempotency is atomic across supported workers.

## Audit Pass E — history/replay/backpressure

Exercise stale history responses, event gaps, reconnect, terminal ordering, multiplex cursors where applicable, and slow subscribers. Prove bounded buffers and no lost/duplicate state.

## Audit Pass F — workspace mutation

For every file/write/git/package/schema/global-operation tool:

- canonicalize path/resource;
- fresh-read/revision check;
- correct lock scope;
- no stale overwrite;
- explicit partial-failure behavior;
- run/session attribution.

## Audit Pass G — recovery

Exercise:

- refresh;
- stream disconnect;
- backend restart;
- tab close/reopen;
- session deleted elsewhere;
- create response lost/retried.

## Audit Pass H — adversarial races

Run or reason with tests for:

- switch exactly as event arrives;
- close exactly as event arrives;
- lost create/run response + refresh/retry after server success;
- stale history response exactly after newer live events;
- out-of-order/gapped events around reconnect;
- cancel acknowledgement while old worker cleanup is still running;
- delete request while run is active;
- old cancel exactly as new run starts;
- old pause/resume exactly as new run starts;
- old question/permission reply exactly as a new prompt becomes current;
- two starts in same session;
- two starts in different sessions;
- two same-file edits;
- Undo/Revert overlapping another session's newer edit;
- multi-file preflight conflict;
- global workspace resource conflict;
- indirect broad mutator overlapping direct writer;
- snapshot validation while relevant input changes;
- repeated workspace conflicts to retry exhaustion;
- slow subscriber/backpressure while unrelated runs emit;
- external named-resource collision/cleanup ownership;
- the same races across distinct backend workers/processes when that topology is supported.

## Stopping condition

Stop the audit loop only when:

1. all mandatory tests pass;
2. all Definition of Done items are satisfied or explicitly proven inapplicable;
3. two consecutive fresh full audit passes discover no new material flaw, with no intervening specification/code change;
4. there are no known correctness gaps hidden behind TODOs or "future work" for requirements in this document.

Do not declare 10/10 merely because the UI looks correct.

---

# 36. Required implementation report

When the coding task is finished, return a concise report containing:

1. files changed;
2. architecture implemented;
3. how per-session/per-run ownership is enforced;
4. how cancel/reconnect/stale events are handled;
5. how shared-workspace edits avoid silent conflicts;
6. tests added and exact test commands/results;
7. any requirement proven inapplicable and why;
8. final self-audit result.

Do not claim success if tests were not actually run. Distinguish `passed`, `not run`, and `blocked` clearly.

---

# 37. Final implementation mandate

Implement **real concurrent DoubleTake sessions as application tabs inside one browser page**, located in the current session-title row.

The final architecture must satisfy both halves simultaneously:

> **Isolation:** each session/run has its own conversation, execution, event routing, cancellation, loop state, questions, permissions, UI state, and lifecycle.

> **Collaboration through shared reality:** every session sees and can modify the same live DoubleTake workspace, with fresh-read and conflict controls strong enough that one session can repair another session's code without silent stale overwrites.

The implementation is complete only when Session A and Session B can run at the same time, switch without interference, survive close/reopen/refresh, safely target cancellation and events by run identity, and deliberately collaborate through the same shared repository.

---

# 38. Source-informed final convergence hardening

This section is **normative and release-blocking**. It was added after auditing the current DoubleTake frontend/backend wiring, including the existing UI chat controls and the process-wide manager/WebSocket structures in `api_server.py`.

Where an earlier section is less strict or ambiguous, **this section takes precedence**.

## 38.1 Service singletons may coordinate; they may not mean "current session/current run"

DoubleTake may keep process-wide service objects such as chat/run managers, model registries, approval managers, or WebSocket registries. A singleton object is not itself a defect. The defect is mutable implicit ownership.

Required rule:

> A singleton service may be a keyed coordinator, but every mutable run/session datum it owns MUST be indexed by explicit stable identity and every operation MUST receive or derive the exact identity it acts on.

Therefore:

- no manager field such as `current_session`, `current_run`, `current_cancel_token`, `current_event_sink`, `current_question`, `current_model`, or equivalent may be shared by concurrent runs;
- `chat_mgr`, `run_mgr`, `fic_mm`, governance/approval state, loop state, and any other mutable manager state MUST be keyed by `session_id` and, when run-scoped, `run_id`;
- async callbacks/subagents capture the owner IDs at creation time and never look up "whatever run is active now";
- read-only immutable registries/caches may remain global;
- any mutable cache that can affect semantics MUST either be keyed by all relevant ownership/configuration dimensions or be removed from the concurrent path.

## 38.2 WebSocket isolation is enforced server-side, not merely filtered by React

The current backend contains process-wide WebSocket connection structures. That is acceptable only as a transport registry. It MUST NOT imply broadcast-all behavior for session-private data.

Each live connection has an authenticated/authorized client identity where authentication exists and an explicit subscription set. The protocol MUST support idempotent subscribe/unsubscribe semantics for exact sessions, and optionally exact runs when the transport design benefits from it.

For every session/run event, the server MUST:

1. persist/canonicalize the event first according to the event durability rules;
2. identify its exact `session_id` and `run_id`;
3. route it only to connections authorized for and subscribed to that session;
4. never depend on the browser to discard another session's private payload as the security boundary.

Client-side owner filtering remains mandatory as defense in depth against stale/out-of-order delivery.

Reconnect sequence:

1. reconnect transport;
2. re-authenticate/re-establish client identity as applicable;
3. re-subscribe to the page's open/restored sessions;
4. obtain an authoritative snapshot/status and its `snapshot_seq`/revision watermark;
5. replay strictly after that watermark, or use the documented equivalent gap-free resume protocol;
6. merge by stable entity IDs;
7. resume live delivery only without leaving a gap between replay and live events.

Deleted/unauthorized sessions are removed from the connection's subscription set. An unsubscribed socket MUST receive no further private events for that session.

## 38.3 Canonical event envelope and schema version

Every run-scoped persisted/live event MUST include at least:

```json
{
  "schema_version": 1,
  "event_id": "stable-unique-id",
  "session_id": "...",
  "run_id": "...",
  "seq": 123,
  "kind": "...",
  "timestamp": "..."
}
```

Additionally include stable entity IDs (`message_id`, `activity_id`, `request_id`, artifact/tool-call ID, etc.) whenever the event mutates such an entity.

Rules:

- `event_id` is globally unique or otherwise collision-safe for replay deduplication;
- `seq` is monotonically allocated and durably ordered within the exact run;
- a deliberately session-level event MAY use `run_id: null`, but a run-scoped event MUST NOT omit/guess its run identity;
- missing owner IDs are protocol errors, not a request to route to a current/default run;
- schema evolution is explicit and backward-compatible or migrated deliberately.

## 38.4 Replay retention has an explicit floor and resync path

Bounded replay retention creates a lower retained cursor/sequence boundary. The server MUST expose or internally detect when a client asks to resume from data older than that boundary.

In that case it MUST return/trigger a structured `resync_required` path rather than silently replay an incomplete suffix. Recovery obtains an authoritative snapshot plus watermark and resumes after that watermark.

Compaction/retention MUST never make the canonical current transcript/run state unreconstructable.

## 38.5 Run admission is one atomic ownership transaction

For one logical Send/Start, the authoritative admission transaction MUST atomically establish all state needed to prove exactly what was accepted:

- `(session_id, client_run_request_id)` idempotency mapping;
- request fingerprint;
- stable user `message_id`/persisted user message where applicable;
- immutable run configuration/context snapshot;
- newly allocated `run_id` and initial run row/state;
- session's active-top-level-run pointer/guard;
- any queue/admission metadata required by the capacity policy.

If the transaction fails, none of these may be left half-created as an apparently valid accepted run. If the server crashes after durable admission but before worker start, startup/reconciliation handles it as specified rather than accepting the same logical request again.

## 38.6 Request idempotency fingerprint is canonical and complete

The immutable request fingerprint bound to `client_run_request_id` MUST cover every input whose difference would make a retry semantically different, using deterministic canonical serialization.

At minimum, as applicable:

- normalized prompt/message content;
- immutable attachment IDs plus content hashes;
- selected run mode/model/provider or the stable configuration snapshot identity;
- relevant permissions/governance mode chosen for this run;
- explicit workspace/base revision if the request contract makes it semantically significant;
- other immutable user-supplied execution options.

Exclude transport-only values such as timestamps, retry counters, connection IDs, or UI presentation fields.

Same idempotency key + same fingerprint returns the same logical run/outcome. Same key + different fingerprint returns structured `409 IDEMPOTENCY_KEY_REUSE` or equivalent and never executes the second payload.

## 38.7 Browser ambiguous-send outbox prevents duplicate execution

Generating a stable idempotency key is insufficient if the browser forgets it after a lost response.

For unresolved New Session and Send/Start operations, maintain a small window-local, schema-versioned `pendingOperations` outbox in `sessionStorage` containing only safe reconciliation metadata such as:

- operation type;
- owner `session_id` if already known;
- `client_request_id` / `client_run_request_id`;
- safe request fingerprint;
- optimistic entity ID if applicable.

The client MUST successfully persist this request identity/outbox record **before dispatching** the mutating Create/Send network request. If the chosen storage mechanism is unavailable/fails, do not silently send with a crash-recovery guarantee that cannot be honored; use another approved durable window-local mechanism or surface a scoped failure. This closes the crash window between network dispatch and idempotency-key persistence.

On network uncertainty or reload:

- first reconcile/query using the original key;
- never silently manufacture a new key for the same logical operation;
- reconcile the optimistic user message by stable ID/key instead of appending another copy;
- if the authoritative lookup proves the server never admitted the request, retry automatically only when the exact original retry payload is still safely available under existing privacy policy; otherwise restore/retain a clearly unsent/failed draft state where possible and require a new deliberate Send rather than reconstructing or partially replaying the request;
- remove the outbox record only after the server outcome is known or the operation is explicitly abandoned.

Do not persist secrets, full prompts, or raw attachment contents in this outbox solely for retry support unless the existing product's approved draft/security model explicitly permits that storage. Correctness must not be purchased by silently broadening persistence of sensitive input.

## 38.8 Exactly-once terminalization is an atomic state transition

A run reaches terminal state through one canonical compare-and-set/transactional transition from a permitted nonterminal state to one immutable terminal state.

Required semantics:

- terminal states are immutable;
- completion, failure, timeout, and cancellation races compete through the same terminalization primitive;
- exactly one transition wins;
- final transcript/result persistence occurs before or atomically with terminal visibility, as required by Section 32;
- exactly one canonical terminal event is persisted/emitted for the run;
- cleanup/finalizers are idempotent and cannot double-release a lease, double-delete resources, or append duplicate final output;
- a late worker callback after terminalization cannot change terminal status or publish newer nonterminal state.

The implementation MUST define the deterministic result of cancel-vs-complete races. It is acceptable for completion to win if it committed terminally before cancellation acquired the transition; it is acceptable for cancellation to win if cancellation fenced the worker first. It is not acceptable for two terminal outcomes to be observable.

## 38.9 Cancellation is fenced; `cancelling` is not `cancelled`

All Stop/Cancel operations target exact `(session_id, run_id)` and use compare-by-expected-run ownership. Bare/global/current-run fallbacks are forbidden.

When cancellation is accepted:

1. atomically transition the exact run to `cancelling` or equivalent if still cancellable;
2. revoke/fence its authority to begin new mutating work;
3. signal/cancel owned async tasks and the entire owned subprocess/process group/tree where applicable;
4. finish or safely abort tool/resource cleanup;
5. release owned leases/resources by owner-checked idempotent cleanup;
6. only then terminalize as `cancelled` if cancellation won the terminal race.

The UI may show **Stopping/Cancelling** during steps 2-5. It MUST NOT show the run as fully stopped while an owned process can still mutate the workspace.

A stale cancel for an older run returns a structured stale/no-op result and cannot affect the session's newer run.

## 38.10 Pause/resume is cooperative, exact, and has a safe-point contract

Pause/Resume MUST target exact `(session_id, run_id)` and MUST NOT use an implicit current run.

Unless DoubleTake deliberately implements and proves safe OS/process suspension, pause is **cooperative**:

- accepted pause transitions to `pausing`;
- the currently executing atomic/tool operation may reach a defined safe point first;
- only after no new unsafe step will begin is the run `paused`;
- Resume applies only to the same resumable run and generation;
- stale pause/resume for an older run is rejected/no-op;
- cancellation while paused still follows exact run cancellation semantics.

The UI distinguishes `pausing` from `paused` where this distinction is observable.

## 38.11 Worker ownership, heartbeat, fencing token, and stale-worker rejection

Any execution/lease model that can survive process failure MUST prevent a stale worker from writing after ownership has moved elsewhere.

Each active worker/run ownership record has an owner identity/generation and, for mutation-capable workspace ownership, a monotonic fencing token or equivalent non-reusable generation.

Required semantics:

- worker ownership is durably leased/heartbeated when more than one process can participate;
- lease renewal is compare-by-owner/generation;
- lease release is compare-by-owner/generation and idempotent;
- expiry/recovery/reassignment increments ownership generation/fencing token;
- every cooperating mutation commit validates that its fencing token/generation is still current;
- a stale process that wakes after lease expiry/reassignment MUST fail its commit even if it still has an old in-memory lock object.

A timeout alone is not enough if the stale owner can still write without a fencing check.

## 38.12 Graceful shutdown and crashed-running reconciliation

The server has an explicit shutdown/restart protocol for active runs:

- stop admitting new work before teardown;
- mark/reconcile process-owned active runs durably as shutting-down/interrupted/recovering as appropriate;
- signal and reap owned child process groups where feasible;
- do not leave durable `running` forever merely because the process disappeared;
- on startup, reconcile any run whose worker ownership heartbeat/generation is no longer valid;
- recover/requeue only if the run type is explicitly safe/resumable; otherwise mark `interrupted` with an honest reason;
- clean/recover stale leases through owner/fencing rules, never by blindly unlocking resources that a newer owner acquired.

## 38.13 Supported process topology is a hard deployment contract

Process-local `asyncio.Lock`, dict/set registries, and in-memory idempotency maps provide no cross-process exclusion.

Choose and enforce exactly one supported model:

### Model A — deliberately single backend worker/instance per shared workspace

- document this as a correctness requirement;
- startup/deployment configuration MUST reject or unmistakably fail an unsupported multi-worker configuration for the same live workspace;
- the running server MUST also obtain a workspace-scoped singleton owner lock/lease (OS/file lock, durable owner record with safe fencing, or equivalent deployment-enforced exclusivity) so two independently launched DoubleTake server instances cannot both believe they are the one process coordinating the same checkout;
- owner acquisition/release is crash-safe and does not steal ownership while an old instance or its unfenceable mutating children can still write;
- CI/deployment tests prove the production launch path respects both configured worker count and workspace-instance exclusivity;
- browser/session concurrency still works because several runs can be async/concurrent within that one worker process.

### Model B — multiple backend workers/processes supported

All cross-run correctness primitives that may be touched from separate workers MUST use a shared durable/coordinated mechanism (database transaction/unique constraint, Redis/DB lock with fencing, equivalent), including:

- same-session active-run admission;
- idempotency records;
- terminal CAS;
- request/reply CAS;
- event sequence/cursor allocation;
- live event distribution/fan-out or a provably equivalent routing design so a socket connected to worker A still receives/reconciles events produced by worker B;
- workspace/resource leases;
- deletion state;
- loop/Auto-Borg generation and exactly-once next-iteration scheduling;
- global capacity/queue admission if the capacity limit is intended to span workers;
- worker ownership/recovery.

A process-local WebSocket subscriber set is acceptable only as the local connection registry; cross-worker event delivery must use shared pub/sub/event storage plus wakeup/replay, deterministic sticky ownership that is preserved for all relevant operations, or another proven mechanism. Do not claim multi-worker support because tests pass in one process.

## 38.14 Hierarchical workspace mutation barrier closes indirect-writer bypasses

Section 32 classifies bounded and broad writers. The missing invariant is that a broad writer MUST conflict with every bounded writer, not only with other broad writers.

Implement one hierarchical coordination model or a provably equivalent one:

- every **bounded writer** acquires shared participation in a canonical workspace-mutation barrier plus its deterministic canonical path/resource write locks and expected revisions;
- a **broad/unknown writer** acquires the workspace-mutation barrier exclusively for the lifetime of the mutating command/process tree;
- therefore disjoint bounded writers MAY still overlap, but no bounded writer can overlap an unknown broad writer that might touch it;
- broad writer scope ends only after the owned process tree has exited and all mutation/cleanup side effects are complete;
- locks/leases are owner-checked, cancellation-safe, and released in `finally`/idempotent finalization;
- lock acquisition has a documented total order and bounded wait/cancellation behavior.

This preserves useful different-file concurrency while eliminating the false safety of a standalone `workspace:broad-mutation` lock that bounded writers never participate in.

For a correctness-first implementation, it is also valid to serialize **all mutation-capable workspace operations** under the exclusive workspace mutation barrier initially. Fine-grained bounded-writer parallelism is an optimization, not a release requirement. What is forbidden is a **whole-run** repository mutex spanning LLM/network thinking time rather than the actual mutation window.

## 38.15 Canonical paths defeat alias/symlink/case bypass

All file/resource lock keys and containment checks use canonical workspace-relative identities derived safely from the real target:

- normalize separators and dot segments;
- resolve/validate symlinks according to the product's allowed policy;
- account for filesystem case-folding where applicable;
- reject escape outside the configured workspace root;
- rename/move locks both source and destination and any required parent/global metadata resources;
- acquire multiple keys in one deterministic order.

A textual path alias MUST NOT let two runs obtain separate locks for the same underlying file.

## 38.16 Workspace reads and snapshot-sensitive validation have defined consistency

Not every read must block every writer, but the semantics MUST be explicit.

- ordinary fresh reads used to prepare a write capture the relevant file revision/hash and commit through expected-revision checks;
- multi-file read/search/index operations whose result is expected to represent one coherent checkout capture the relevant structural generation/revision before and after the operation; if it changes, retry/reconcile rather than treating a hybrid cross-generation view as authoritative;
- tests/builds/static analysis/snapshot-sensitive commands capture the relevant workspace mutation epoch/input revisions and revalidate at completion;
- if relevant inputs changed, the result is stale and cannot be presented as validation of the final workspace without rerun/revalidation;
- if stronger point-in-time reads are required for a feature, use a read-side lease/snapshot mechanism rather than assuming filesystem reads are atomic across many files.

## 38.17 Session/transcript updates avoid whole-object last-write-wins

The durable store MUST NOT treat one stale in-memory session object as the authoritative blob to overwrite after another run changed it.

- append/upsert transcript entities by stable identity;
- update run entities by exact `run_id` and state/version CAS where needed;
- update mutable session metadata/settings with explicit field-level/versioned semantics;
- use transactions/locks/revisions for any shared catalog/index read-modify-write;
- a delayed rename/history save cannot erase newer messages/run state;
- server-side state is authoritative; browser state never wins a persistence race merely because it is newer locally.

## 38.18 Session deletion is a state machine, not an immediate row/file disappearance

Close application tab is view-only and remains non-destructive.

For actual Delete Session:

1. atomically mark exact session `deleting`/tombstoned or otherwise prevent new admission;
2. reject new Send/Start/interactive requests for it;
3. if a run is active, follow the chosen policy (`409 SESSION_HAS_ACTIVE_RUN` or explicit exact cancel-and-delete);
4. resolve/close subscriptions, pending questions/approvals, loop schedulers, and session-owned ephemeral resources safely;
5. delete/tombstone durable data only after no worker retains authority to emit/mutate it;
6. stale clients receive structured deleted/not-found semantics and cannot resurrect the session by saving old state.

## 38.19 Session IDs are identity, not authorization

If DoubleTake can be exposed to more than one authenticated user/principal, every HTTP and WebSocket session/run operation MUST verify that the principal/tenant is authorized for the target session. Guess-resistant IDs are not access control.

- authorization applies to history, stream subscription, run start/control, interactive replies, rename/delete/export, attachments/artifacts, and reconnect/replay;
- server-side WebSocket subscription authorization is checked at subscribe time and when permissions/session ownership change;
- choose consistent `403` versus non-enumerating `404` behavior.

If the supported product is deliberately local single-user only, state that deployment/security assumption explicitly and keep the server bound/configured accordingly; do not accidentally advertise multi-user isolation that is not implemented.

## 38.20 Attachments, artifacts, and temp files have immutable ownership

Where attachments/artifacts exist:

- persisted attachment/artifact records have stable IDs and owner session/run metadata as appropriate;
- a run snapshot references immutable attachment identity/content hash rather than a mutable UI slot;
- temp working paths are unique/namespaced by session/run/resource identity;
- cleanup validates ownership and cannot delete another run's similarly named temp artifact;
- authorization follows the owning session where multi-user access exists;
- retries reuse immutable references rather than silently uploading/attaching different content under the same run request key.

## 38.21 Global execution capacity is bounded and fair

"One active top-level run per session" MUST NOT create an unbounded number of simultaneously resource-consuming runs across hundreds of sessions.

Define a global capacity policy:

- bounded worker/task/tool/subprocess capacity appropriate to DoubleTake;
- explicit queued/waiting state or structured capacity rejection;
- queue entries carry exact session/run/request identity;
- exact queued run can be cancelled without touching another entry;
- scheduling is reasonably fair and prevents one looping session from starving others;
- Auto-Borg/loop iteration N+1 is admitted only after N is truly terminal **and** its mutation/resource cleanup required for safe succession is complete.

## 38.22 Run configuration snapshot is exhaustive enough to reproduce semantics

The immutable effective run snapshot MUST include, as applicable:

- model and provider selection;
- system/persona prompt/config;
- mode and tool/feature flags;
- governance/permission policy version;
- workspace root and relevant base/workspace revision metadata;
- immutable attachment/artifact references;
- loop/Auto-Borg settings that govern this iteration;
- any session-specific execution option read by tools/subagents.

A running job MUST NOT change behavior because another tab edits a mutable global preference unless live reconfiguration is an intentional owner-validated feature.

## 38.23 Structured stale/conflict API contract

Mutating endpoints MUST return machine-distinguishable results so the UI can reconcile instead of guessing from text.

Use stable error/result codes equivalent to:

- `SESSION_BUSY`;
- `STALE_RUN`;
- `IDEMPOTENCY_KEY_REUSE`;
- `SESSION_DELETING` / `SESSION_DELETED`;
- `WORKSPACE_CONFLICT`;
- `REQUEST_ALREADY_RESOLVED`;
- `RESYNC_REQUIRED`;
- `CAPACITY_QUEUED` / `CAPACITY_EXCEEDED` where applicable.

The exact HTTP codes may follow existing DoubleTake conventions, but stale identity MUST never silently retarget an operation.

## 38.24 Additional mandatory adversarial tests

Add tests that directly prove these invariants rather than only exercising the happy path.

### T38-A — server-side WebSocket isolation

Open two clients/subscriptions for distinct sessions. Emit private events concurrently. Neither client receives the other's event payload. Repeat after unsubscribe/delete/reconnect.

### T38-B — two windows, same session

Two browser windows subscribe to the same session. Both converge to the same canonical ordered state without creating duplicate server messages/events.

### T38-C — replay retention floor

Request replay from before the retained floor. Server returns/resolves through authoritative resync; no missing suffix is treated as complete.

### T38-D — terminal CAS race

Race completion, failure/cancellation callbacks, and duplicate finalizers. Exactly one terminal state/event survives and cleanup remains idempotent.

### T38-E — cancellation fencing

Accept cancel while a mutating worker is delayed. After authority is fenced, release the delayed worker. Its attempted late mutation/event is rejected and the new run/session state is untouched.

### T38-F — stale lease owner after expiry/reassignment

Expire/recover a worker/lease, assign a newer fencing generation, then wake the old owner. Old owner cannot write, release the new owner's lease, or terminalize the run.

### T38-G — supported process topology

If multi-worker is supported, run admission/idempotency/terminal/request/workspace races from separate workers, connect a WebSocket/subscriber to a different worker than the event producer, and prove loop/capacity coordination across workers. If not supported, prove configured multi-worker launch is rejected **and** a second independent server instance cannot acquire ownership of the same live workspace.

### T38-H — broad writer versus bounded writer

A broad/unknown shell mutator and a bounded file writer that could overlap MUST serialize through the hierarchical mutation barrier. Two declared disjoint bounded writers MAY overlap if fine-grained concurrency is implemented.

### T38-I — path alias collision

Use path aliases/symlink/case variants that refer to the same file. They resolve to one ownership/conflict domain; no silent clobber occurs.

### T38-J — cancel/complete race

Race exact Stop with natural completion repeatedly. Only one deterministic terminal result becomes canonical and no run remains falsely active/cancelling forever.

### T38-K — pause safe point

Pause during a tool step. Verify `pausing` until a safe point, `paused` afterward, exact resume, and stale old-run pause/resume rejection.

### T38-L — delete/start race

Race Delete Session and Send/Start. Either admission wins before delete state and is then handled by the active-run deletion policy, or delete wins and new admission is rejected. No orphan worker or resurrected session is possible.

### T38-M — persistence lost-update race

Race transcript append, rename/settings update, and terminal run persistence. All intended changes survive according to explicit field/entity version semantics.

### T38-N — browser ambiguous send across reload

Server accepts Send/Start but response is lost. Reload. Browser reuses/reconciles the original `client_run_request_id`; exactly one user message and one run exist. Also crash/terminate the page immediately after network dispatch and prove the pre-dispatch outbox record already exists and can reconcile the accepted request.

### T38-O — crash with admitted and running work

Test separately: admitted-but-not-started crash and actively-running-worker crash. Neither duplicates, remains zombie-running forever, nor leaves reusable stale workspace authority.

### T38-P — attachment identity retry

Retry the same logical run with the same key/immutable attachment identity: same run. Reuse the key with different attachment hash/config: idempotency conflict.

### T38-Q — capacity fairness

Saturate global capacity with several sessions and an enabled loop. Queue/capacity behavior is bounded; another session is not silently cancelled or permanently starved.

### T38-R — stale manager/global-state audit

Run two sessions with deliberately different model/mode/governance settings while forcing interleaved callbacks/subagents. Every callback observes its captured `RunContext`; no process-global "current" value bleeds across.


## 38.25 Run admission/event race is explicitly correlated

A successful Start transaction can commit and publish before the initiating HTTP response reaches the browser. The protocol MUST make this race lossless without weakening stale-run rejection.

Required contract:

- after atomic admission commits, publish/persist an authoritative run-accepted/start record before ordinary run deltas can be required by the client;
- that record includes `session_id`, new `run_id`, and the originating `client_run_request_id` (or an equivalent unambiguous correlation ID);
- the Start HTTP response returns the same identities;
- while a Start is unresolved, the frontend may establish the new run from this authoritative record only when its correlation matches the pending operation for that session;
- if the browser reconnects and missed the accepted record, the active-run/snapshot/idempotency lookup establishes the same run before replay;
- an arbitrary unknown `run_id` event cannot replace the current run merely because the client has a pending Start;
- once established, all ordinary stale/sequence checks apply.

This guarantees both properties simultaneously: no legitimate first events are lost when events beat HTTP, and a delayed/foreign old run cannot hijack the session's active-run pointer.

### T38-S — event beats Start response

Delay the successful Start HTTP response after durable admission. Deliver `run.accepted` plus early run events first. The browser correlates them through the original `client_run_request_id`, establishes exactly that `run_id`, and applies each event once. Then deliver the HTTP response; it reconciles without duplication. Repeat with an unrelated/stale run event and prove it is rejected.


## 38.26 Unfenceable direct-filesystem subprocesses require death proof or workspace quarantine

A fencing token protects only code paths that validate the token before committing. An already-running shell command, formatter, package manager, git process, generator, compiler, or other external process may write the checkout directly and cannot be retroactively fenced by changing a database lease row.

Therefore, for any mutation-capable external process:

- retain its broad/bounded mutation ownership for as long as that process tree can still write;
- launch it in a platform-appropriate owned containment/lifecycle unit (process group/session, Windows Job Object, container/cgroup/supervisor, or equivalent) that lets DoubleTake identify and terminate the whole owned tree without process-name matching;
- on cancellation, shutdown, owner loss, or backend crash recovery, do not reassign/release the conflicting mutation lease solely because a heartbeat timed out;
- first prove the old process tree is dead/contained and unable to mutate, then release/recover the lease;
- if death cannot be proven safely, mark the affected workspace/resource **recovery-required/quarantined** and block conflicting mutation rather than letting a new writer race an orphan;
- never kill by generic executable/process name; ownership identity must be run/resource specific;
- detached/background mutation-capable children are forbidden unless ownership and containment are explicitly transferred as required by Section 16.2.

For ordinary in-process cooperating file writers, fencing-generation validation remains sufficient at the final commit boundary. For direct external writers, process-liveness containment is part of the correctness proof.

### T38-T — backend dies while mutating child survives

Start a broad mutating subprocess, simulate loss/crash of the owning backend while the child remains alive, then restart/recover. DoubleTake MUST either identify/terminate and reap the exact old process tree before releasing its mutation ownership, or quarantine the workspace and reject conflicting writers. A new run must never begin conflicting mutation while the orphan can still write.


## 38.27 Checkout-wide semantic changes use a structural workspace generation

Per-file content hashes are precise for same-file stale writes, but they cannot detect every semantic workspace change. Example: a git checkout/switch/reset can move the checkout to a different branch/HEAD while a target file happens to retain identical bytes. A plan produced against the old checkout must not silently commit merely because that one hash still matches.

Maintain a monotonic `workspace_structural_generation` (or equivalent authoritative checkout-context identity) for operations that can change the semantic identity/topology of the shared workspace, including as applicable:

- git checkout/switch/reset/clean/merge/rebase operations that materially change checkout state;
- workspace-root/project remapping;
- destructive restore/revert operations with broad semantic scope;
- other explicitly classified operations whose effect can invalidate a run's assumptions without necessarily changing one target file's hash.

Rules:

- capture the relevant structural generation with workspace-sensitive read/plan/tool context;
- increment it atomically as part of successful classified structural mutation/finalization;
- before a stale planned bounded write is committed, validate both its expected target revisions and any structural generation on which the plan depends;
- after waiting behind a broad structural mutator, force fresh read/revalidation/replan when the captured generation changed;
- do not use this structural generation as a reason to conflict on every unrelated ordinary file edit; per-file revisions remain the precise ordinary-write mechanism;
- snapshot-sensitive tests/builds include the relevant structural generation in their completion revalidation.

### T38-U — identical file hash across branch switch

Session A reads/plans against checkout generation G and target file hash H. Session B changes branch/HEAD through an exclusive structural mutation to generation G+1 while the target file still has hash H. A's old planned commit MUST revalidate/replan because G is stale; matching H alone is insufficient.


## 38.28 Event sequence allocation cannot create unexplained permanent gaps

A monotonic counter increment performed separately from durable event append can crash between those operations and permanently reserve sequence N without an event. A client that correctly refuses to advance over gaps would then wait forever.

Use one of these proven semantics:

1. allocate the next per-run `seq` and append the canonical event in one atomic transaction/log operation; or
2. if reservation must be separate, durably record an explicit skipped/tombstone entry or authoritative snapshot/compaction boundary that certifies the missing sequence can be advanced past.

Rules:

- clients never infer that a missing sequence is harmless merely because a timeout elapsed;
- replay can distinguish "event not delivered yet" from "sequence intentionally superseded/compacted";
- crash recovery cannot leave an unexplained gap that blocks replay forever;
- terminalization uses the same event-log ordering guarantee.

### T38-W — crash between sequence allocation and event append

Force failure at the sequence-allocation/event-persistence boundary. After restart/reconnect, the client either receives the missing event or an authoritative durable gap/snapshot boundary and continues without data loss, duplication, or permanent cursor stall.

## 38.29 Self-hosted code changes and auto-reload are explicit global lifecycle boundaries

DoubleTake can modify the same repository that contains its own frontend/backend. Development reloaders/watchers can therefore convert a normal shared-workspace edit into runtime lifecycle change. Audit the actual launch mode.

- frontend HMR/reload MUST preserve/reconcile server-authoritative session/run state and must not interpret component/page teardown as Stop;
- a backend auto-reloader that restarts the process is **not** session-local: it affects every run owned by that process and must enter the normal graceful-shutdown/crash-recovery protocol;
- multi-session production/execution mode MUST either disable uncoordinated backend autoreload while active runs exist or route code-triggered restart through an explicit global restart operation with a clear active-run policy;
- a session editing backend source MUST NOT cause the UI to report unrelated runs as successfully continuing if the process actually restarted; they reconcile to resumed/interrupted state according to the supported recovery model;
- watcher/dev-server ownership and fixed ports follow the same external-resource rules as other long-lived services.

### T38-V — self-edit triggers backend reload

When the supported development mode includes backend autoreload, modify a watched backend file while two runs are active. Prove the restart enters the documented global lifecycle/recovery path, no run is silently lost or falsely shown running, browser tabs reconcile after reconnect, and no stale pre-restart worker/process retains workspace authority. If production mode forbids autoreload, prove the production launch configuration does not enable it.

## 38.30 Final source-informed no-go gate

The implementation is **not releasable** if any of the following remains true:

- a run/session endpoint can operate without exact owner identity and fall back to "current" state;
- WebSocket private events are broadcast globally and merely discarded by clients;
- a singleton manager stores mutable unkeyed current-run/current-session semantics;
- retry after an ambiguous Send/Create can execute the same logical operation twice;
- two terminal outcomes for one run can become observable;
- `cancelled` can be shown while an owned process still has mutation authority;
- a stale/recovered worker can commit after its lease/generation was superseded;
- a direct mutation-capable subprocess can outlive its owner and the conflicting workspace lease can be reassigned before that process tree is proven unable to write;
- broad/unknown workspace mutation can overlap a bounded writer without a shared hierarchical barrier;
- a stale planned write can cross a checkout-wide structural-generation change merely because its target file bytes still match;
- multi-worker deployment can bypass process-local correctness primitives;
- stale transcript/session object saves can overwrite newer entities wholesale;
- Delete Session can race new admission or leave an orphan worker;
- replay truncation can silently omit events without authoritative resync;
- event sequence allocation can leave an unexplained permanent gap after a crash;
- session IDs are used as authorization in a multi-user deployment;
- a global mutable model/mode/cancel/event/question setting can be observed by two concurrent runs;
- there is no bounded global capacity/backpressure policy.

---

# 39. Convergence audit record

The implementing LLM MUST perform the complete self-audit in Section 35 after applying Section 38. A "10/10" declaration is permitted only after **two consecutive full source-informed audit passes** produce zero new material correctness defects and all applicable automated/manual release gates have evidence.

A clean audit pass means more than "no new TODOs were noticed": it must explicitly challenge identity routing, retries, replay, persistence, terminal races, cancellation/pause, deletion, worker crash/restart, process topology, shared-workspace mutation, browser lifecycle, authorization assumptions, and global mutable state.

If either clean pass finds a new material defect, patch it and restart the two-clean-pass convergence count from zero.

---

# 40. Specification convergence result

This implementation specification has completed its source-informed adversarial design audit against the current DoubleTake multi-session risk surface examined during preparation, including the current frontend chat/session controls and backend process-wide manager/WebSocket wiring.

The iterative audit found and incorporated material hardening for, among other issues:

- durable idempotency for both session creation and run submission, including ambiguous network outcomes and pre-dispatch browser outbox persistence;
- exact `(session_id, run_id)` targeting for Stop/Cancel/Pause/Resume and exact request identity for questions/permissions;
- atomic run admission, one-shot interactive request resolution, and exactly-once terminalization;
- server-side WebSocket subscription isolation, replay retention floors, sequence-gap recovery, slow-subscriber isolation, and event-before-HTTP admission correlation;
- immutable run context/configuration and prohibition of implicit global current-session/current-run state in singleton managers;
- crash/restart recovery, worker ownership generations, fencing, single-instance enforcement when applicable, and multi-worker fan-out/coordination requirements when supported;
- direct and indirect shared-workspace mutation coordination, hierarchical broad-writer exclusion, same-file expected-revision conflicts, symlink/path canonicalization, structural checkout generations, and stale validation detection;
- ownership and death-proof/quarantine rules for mutation-capable external subprocess trees that cannot enforce fencing tokens themselves;
- deletion/start races, loop ownership, external resources, attachments/artifacts, global capacity/fairness, authorization assumptions, and self-hosted backend auto-reload behavior.

After the final specification change, two consecutive independent full audit passes found **zero new material correctness defects, uncovered requirements, contradictory legacy rules, unresolved placeholder/unfinished-work gaps, or missing acceptance-scenario coverage**.

**Specification-level rating: 10/10 for the audited scope.**

This rating applies to the design/specification, not to code that has not yet been implemented and tested. The resulting DoubleTake implementation may claim completion only after satisfying the Definition of Done, mandatory adversarial tests, actual supported deployment-topology tests, and the two-clean-pass implementation audit defined above.
