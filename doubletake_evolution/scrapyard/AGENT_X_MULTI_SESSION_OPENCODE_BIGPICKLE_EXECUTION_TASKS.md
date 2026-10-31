# Agent_X Multi-Session Application Tabs
## OpenCode BigPickle Execution Task Plan

**Target repository:** `Astrocytech/Agent_X`  
**Goal:** implement multiple independent Agent_X sessions as application tabs inside one browser page, while every session deliberately shares the same live Agent_X workspace.  
**Execution style:** sequential, evidence-driven, no skipped gates.  
**Source specification:** this task plan is an execution-oriented reorganization of the full `AGENT_X_MULTI_SESSION_APPLICATION_TABS_IMPLEMENTATION_SPEC`. It does not weaken any MUST/MUST NOT requirement from that specification.

---

# 0. Operating Contract for the Coding LLM

You are not being asked to produce a design proposal. You are being asked to modify the live Agent_X repository until the feature is implemented and verified.

Follow these rules throughout the task:

1. **Inspect the live repository before changing anything.** Resolve current filenames, symbols, APIs, deployment topology, persistence mechanisms, tests, and launch commands from the repository itself.
2. **Do not implement from filenames or pseudocode alone.** If the live code differs from this document, preserve the semantics and adapt the implementation to the current architecture.
3. **Execute tasks in the order given below.** Later tasks depend on guarantees established by earlier tasks.
4. **Do not skip a gate.** A task is not complete until its targeted tests pass and its required evidence is recorded.
5. **Do not hide failures behind TODOs, comments, disabled tests, mocks that bypass the real invariant, or "future work".** Any release-blocking requirement must be implemented now.
6. **Preserve unrelated Agent_X behavior.** Refactor only as much as necessary for correct multi-session concurrency.
7. **Do not create fake tabs over singleton session state.** Session/runtime isolation must be real end to end.
8. **Do not create one clone/worktree per application tab.** All sessions intentionally share one live workspace.
9. **Do not solve concurrency by locking the entire repository for an entire LLM run.** Coordination applies only to actual mutation/resource windows.
10. **Do not use process-global "current session", "current run", "current model", "current question", "current cancel token", or equivalent mutable semantics across concurrent runs.** Singleton services may exist only as keyed coordinators.
11. **Never let an asynchronous completion update whichever tab happens to be selected when it resolves.** Every async operation captures and applies to its owner identity.
12. **Never let Stop/Pause/Resume/Reply mean "whatever is current now".** Exact identity is mandatory.
13. **Never let a stale file write silently overwrite another session's newer change.**
14. **Run tests for real.** Do not report a test as passed unless it was executed successfully.
15. **If a task exposes a prerequisite defect, fix the prerequisite before continuing.** Then rerun the affected gates.
16. **Do not declare completion after the UI looks correct.** Completion requires the backend, persistence, replay, workspace, process ownership, browser recovery, and adversarial race guarantees below.

## 0.1 Progress ledger

Create or update a repository-local implementation ledger, for example:

`MULTI_SESSION_IMPLEMENTATION_PROGRESS.md`

For every task record:

- status: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `PASSED`;
- files changed;
- invariant(s) established;
- test commands actually executed;
- exact pass/fail result;
- any discovered follow-up defect;
- whether the task gate is satisfied.

Do not use the ledger as a substitute for code or tests. It is an evidence log.

## 0.2 Canonical identities

Keep these scopes separate everywhere:

- `session_id`: durable Agent_X conversation/session identity.
- `run_id`: unique server-generated identity for one execution inside a session.
- `request_id`: exact pending question/permission/approval identity where applicable.
- `client_request_id`: stable client idempotency identity for session creation/import-style creation.
- `client_run_request_id`: stable client idempotency identity for one logical Send/Start.
- browser page layout: `openSessionIds`, `activeSessionId`, ordering, per-session view state.

Default execution invariant:

> One nonterminal top-level run per backend session; many different sessions may each have a run concurrently.

Default workspace invariant:

> All sessions share the same live checkout, but stale/coincident mutations must never become silent last-write-wins.

---

# TASK 00 — Baseline, Source Audit, and Ownership Inventory

**Purpose:** establish what the current code actually does before refactoring it.

**Prerequisites:** none.

## Steps

1. Run the current frontend, backend, and repository test suites using commands discovered from the live repository.
2. Record baseline failures separately from failures introduced later.
3. Inspect current session lifecycle APIs and frontend callers.
4. Inspect current run lifecycle APIs and frontend callers.
5. Inspect streaming/event transport: SSE, WebSocket, chunked HTTP, polling, or combinations.
6. Inspect persistence for sessions, messages, run state, names, activities, questions, approvals, idempotency, and indexes/catalogs.
7. Inspect deployment/process topology:
   - single ASGI/server process;
   - multiple workers;
   - background workers;
   - subprocess workers;
   - more than one Agent_X server instance sharing one checkout.
8. Inventory every relevant `App.jsx` `useState`, `useRef`, timer, AbortController, stream object, polling callback, loop/watchdog callback, and modal continuation.
9. Classify every mutable item as exactly one of:
   - `GLOBAL`;
   - `PAGE_LAYOUT`;
   - `SESSION(session_id)`;
   - `RUN(session_id, run_id)`;
   - `REQUEST(session_id, run_id, request_id)`;
   - `SUBAGENT(parent_session_id, parent_run_id, subagent_id)`.
10. Search for and inventory all uses of at least:
   - `stopActiveWorkEverywhere`;
   - `activeSession`, `currentSession`, `loadedSessionId`;
   - `activeRun`, `currentRun`;
   - global cancel flags/controllers;
   - `/api/chat/pause`;
   - `/api/chat/cancel`;
   - `/api/chat/reply`;
   - `agentx_chat_state`;
   - `localStorage`, `sessionStorage`;
   - WebSocket/SSE registries and broadcast helpers;
   - current model/mode fields;
   - question/permission manager state;
   - loop/Auto-Borg state;
   - `os.chdir`, `os.environ`, global stdio/signal manipulation;
   - filesystem edit/write primitives;
   - shell/package/git/schema/codegen/formatter mutation paths;
   - subprocess launch/kill/cleanup;
   - ports, temp dirs, containers, sockets, browser profiles, service names.
11. Add characterization tests where practical for existing single-session behavior before changing architecture.
12. Locate the current chat header row containing the session name / rename interaction. This is the required application-tab-strip integration point.

## Mandatory findings to confirm or refute against live code

- New Session currently must no longer stop unrelated work.
- Existing unqualified pause/cancel/reply semantics are unsafe for concurrency and must be eliminated from normal paths.
- Browser chat cache is currently single-session shaped and cannot remain authoritative.
- Existing run-manager/session infrastructure should be extended rather than duplicated.

## Gate 00

Do not proceed until:

- baseline commands and results are recorded;
- ownership inventory is complete;
- all global/current/singleton hazards are listed;
- process topology is understood well enough to choose the coordination model in Task 01;
- all mutation-capable tools/resources are at least identified for later classification.

---

# TASK 01 — Choose and Enforce the Supported Backend Process Topology

**Purpose:** ensure every later lock, idempotency guarantee, event sequence, cancellation, and workspace guarantee has the correct scope.

**Prerequisites:** Task 00 passed.

## Decision

Choose exactly one supported model based on the live architecture.

### Model A — deliberately single backend worker/instance per shared workspace

If this is the intended production model:

1. Encode it as a correctness requirement in code/configuration/docs.
2. Reject or unmistakably fail unsupported multi-worker launch for the same workspace.
3. Acquire one workspace-scoped server-instance owner lock/lease so two independently launched Agent_X servers cannot both coordinate the same live checkout.
4. Make acquisition/release crash-safe.
5. Ensure ownership cannot be stolen while an old instance or mutation-capable child process can still write.
6. Add tests proving worker-count enforcement and second-instance exclusion.

### Model B — multiple backend workers/processes supported

If production genuinely supports multiple workers/processes:

Use shared/durable coordination for all cross-worker correctness primitives, including:

- same-session active-run admission;
- session-create idempotency;
- run-submit idempotency;
- terminal compare-and-set;
- question/permission reply compare-and-set;
- event sequence allocation and replay authority;
- event fan-out/pub-sub/replay between producer worker and socket worker;
- workspace/resource leases;
- deletion state;
- loop generation and next-iteration scheduling;
- global capacity/queue admission;
- worker ownership/heartbeats/fencing/recovery.

Process-local dicts, sets, async locks, and WebSocket subscriber lists may remain only for local bookkeeping, never as cross-worker truth.

## Gate 01

Do not proceed until the supported topology is encoded and tested. A later test that only passes in one process is not enough if multi-worker mode remains advertised/supported.

---

# TASK 02 — Durable Session Creation and Browser Ambiguous-Operation Outbox

**Purpose:** make New Session safe under double-clicks, lost responses, refresh, restart, and supported worker routing.

**Prerequisites:** Tasks 00-01 passed.

## Backend requirements

1. Extend the existing session creation path rather than creating a parallel session system.
2. `POST /api/session/new` must accept a stable client idempotency key, e.g. `client_request_id`.
3. Define a deterministic canonical create fingerprint covering immutable create inputs such as mode/template/import identity as applicable.
4. Atomically create the session and durable idempotency mapping in the authoritative persistence/coordinator.
5. Same key + same fingerprint returns/reconciles to the same session even after response loss, refresh, backend restart, or worker rerouting within the supported window.
6. Same key + materially different fingerprint returns a structured idempotency-key-reuse conflict.
7. Retain mapping/tombstone long enough for any legal client retry/reconciliation window.
8. Return explicit `session_id` and `session_name`; never depend on a global newly active/current session.

## Frontend requirements

1. Before dispatching the create request, generate the stable request key.
2. Persist a small schema-versioned `pendingOperations` record in `sessionStorage` **before network dispatch**.
3. Persist only safe reconciliation metadata: operation kind, key, safe fingerprint, safe owner/optimistic IDs as applicable.
4. Do not store prompt contents/secrets/raw attachment data merely for idempotency.
5. On definite rejection, clear/resolve the outbox record and show a creation-scoped error.
6. On ambiguous network outcome, keep the same key and reconcile using it. Never manufacture a new logical create key automatically.
7. Do not insert a permanent real application tab until the server returns/reconciles a real `session_id`.
8. Ensure rapid duplicate activation maps to one logical create attempt.
9. New Session must **not** call `stopActiveWorkEverywhere()` or any equivalent global cancellation/loop-clearing path.

## Tests

At minimum implement/execute the source-spec equivalents of:

- B8 — duplicate create idempotency;
- E9 — ambiguous duplicate New Session retry;
- C2 — ambiguous create across refresh/restart where supported;
- T38-N create-side equivalent — pre-dispatch outbox exists before request dispatch.

## Gate 02

Proceed only when duplicate/retried New Session cannot create multiple unintended sessions and unrelated active runs remain untouched.

---

# TASK 03 — Concurrency-Safe Persistence and Stable Entity Identity

**Purpose:** prevent different sessions or overlapping metadata/history changes from clobbering durable state.

**Prerequisites:** Tasks 00-02 passed.

## Requirements

1. Audit the existing persistence layer; do not create a second truth.
2. Replace stale whole-session-object overwrite patterns where they can lose concurrent updates.
3. Persist transcript/history entities with stable IDs (`message_id`).
4. Persist activities/tool calls with stable IDs.
5. Persist questions/permissions with stable `request_id`.
6. Persist artifacts/attachments with stable IDs as applicable.
7. Update run entities by exact `run_id`, with state/version CAS where needed.
8. Update session metadata/settings with field-level or explicit version semantics so rename/model/mode metadata does not overwrite newer transcript/run state.
9. Protect shared indexes/catalogs/JSON stores from stale read-modify-write using a lock/revision/transaction appropriate to Task 01 topology.
10. Make schema migrations versioned, repeatable/idempotent, existing-session preserving, and unavailable to concurrent readers in a partially migrated state.
11. Atomic file replace by itself does not count as concurrency safety if two stale readers can each replace the file.
12. Add snapshot/history revision or watermark semantics needed by later hydration/replay work.

## Tests

Implement/execute at least:

- C4 — persistence lost-update resistance;
- T38-M — transcript append + rename/settings + terminal persistence race;
- C20/T38 export-related persistence snapshot prerequisites where applicable.

## Gate 03

Proceed only when simultaneous S1/S2 persistence and overlapping same-session metadata/history changes cannot erase one another.

---

# TASK 04 — Atomic Run Admission and Durable Run Submission Idempotency

**Purpose:** ensure one logical Send/Start becomes exactly one durable run and one user message.

**Prerequisites:** Tasks 01-03 passed.

## Backend admission transaction

For every logical Send/Start require a stable `client_run_request_id` and canonical fingerprint.

The authoritative admission transaction/coordinator must atomically establish:

- `(session_id, client_run_request_id)` idempotency mapping;
- canonical request fingerprint;
- stable persisted user `message_id` where applicable;
- immutable effective run configuration/context snapshot;
- unique new `run_id` and initial run row/state;
- session active-top-level-run reservation/guard;
- queue/capacity metadata if the capacity policy uses admission queues.

Admission order:

1. resolve/authorize exact `session_id`;
2. check same `(session_id, client_run_request_id)` first;
3. same key + same fingerprint returns the same existing run/outcome even if terminal;
4. same key + different fingerprint returns structured `IDEMPOTENCY_KEY_REUSE`;
5. only for a new idempotency key enforce one nonterminal top-level run for that session;
6. a distinct request while another run is nonterminal returns structured `SESSION_BUSY` or explicit queued semantics;
7. commit admission before worker execution requires ordinary run events to be consumed.

## Canonical fingerprint

Include every immutable input whose change would make the action semantically different, as applicable:

- normalized prompt/message content;
- immutable attachment IDs + hashes;
- selected model/provider/config snapshot identity;
- mode/tool/feature flags;
- governance/permission policy selection/version;
- workspace/base revision when semantically significant;
- other immutable execution options.

Exclude retry counters, transport timestamps, connection IDs, and pure presentation state.

## Frontend ambiguous Send/Start outbox

1. Capture owner `session_id` at the user gesture boundary.
2. Generate one `client_run_request_id` for the logical send.
3. Persist the safe outbox identity to `sessionStorage` **before network dispatch**.
4. Reuse the same key for every retry/reconciliation of that logical operation.
5. Reconcile optimistic user message by stable message/idempotency identity; never append duplicates because the response was lost.
6. If server proves the request was never admitted and exact payload is not safely available under existing privacy policy, restore an unsent/failed state rather than reconstructing a different request under the old key.

## Tests

Implement/execute at least:

- B2 — same-session start conflict;
- C1 — retry after terminal resolves same run;
- C2 — lost response + refresh/restart where supported;
- T38-N — browser ambiguous Send across reload and pre-dispatch outbox proof;
- T38-P — attachment identity retry/idempotency conflict.

## Gate 04

Proceed only when one logical Send/Start cannot execute twice under ambiguity and one session cannot have two active top-level runs accidentally.

---

# TASK 05 — Immutable RunContext Through the Full Backend Stack

**Purpose:** eliminate semantic bleed caused by shared mutable agent/model/tool/current state.

**Prerequisites:** Task 04 passed.

## Required execution context

Create or adapt an explicit run-owned context with semantics equivalent to:

```text
RunContext(
  session_id,
  run_id,
  workspace_root,
  cancel_token,
  event_sink,
  run_config_snapshot,
  resource_owner,
  request_correlation_id,
  worker_generation_or_fencing_identity
)
```

`session_id` and `run_id` are immutable for the run lifetime.

## Propagate it through

- orchestration;
- model invocation;
- tool execution;
- event emission;
- subprocess launch;
- question/permission requests;
- subagents/child tasks;
- loop iteration execution;
- timers/background callbacks;
- cancellation/cleanup/finalizers;
- artifact/attachment ownership;
- resource manager operations.

## Remove unsafe shared mutable semantics

No concurrently reused object may hold mutable unkeyed:

- current conversation/history;
- current session;
- current run;
- current model/mode;
- current cancel token;
- current event sink;
- current question/approval;
- current loop state;
- run-specific cwd/environment.

Singleton services are acceptable only as identity-keyed coordinators or immutable/thread-safe registries.

Use explicit child `cwd` and per-child environment copies. Do not use process-global `os.chdir()` or mutate process-global environment for run-specific settings.

## Run config snapshot

Snapshot enough configuration at admission to reproduce effective semantics for that run, including model/provider, system/persona config, mode/tool flags, governance policy, workspace identity/base metadata, immutable attachment references, loop settings for the iteration, and session-specific execution options read by tools/subagents.

## Tests

Implement/execute:

- C3 — immutable run context isolation with intentionally different A/B model/mode/config;
- T38-R — stale manager/global-state adversarial audit;
- subagent and tool instrumentation proving captured context.

## Gate 05

Proceed only when interleaved callbacks/tools/subagents from two sessions always observe their own immutable context.

---

# TASK 06 — Run Lifecycle State Machine, Exactly-Once Terminalization, and Global Capacity

**Purpose:** make run ownership/lifecycle canonical before implementing UI concurrency.

**Prerequisites:** Tasks 04-05 passed.

## Required run states

Use existing names if compatible, but support semantics equivalent to:

- admitted/queued if applicable;
- running;
- pausing;
- paused;
- cancelling;
- completed;
- failed;
- cancelled;
- interrupted.

## Exactly-once terminalization

1. Implement one canonical compare-and-set/transactional terminal transition.
2. Terminal states are immutable.
3. Completion/failure/timeout/cancellation races use the same primitive.
4. Exactly one terminal outcome wins.
5. Final canonical transcript/result persistence occurs before or atomically with terminal visibility.
6. Persist/emit one canonical terminal event.
7. Cleanup/finalizers are idempotent.
8. Late callbacks cannot change terminal state or publish newer nonterminal state.

## Capacity/backpressure policy

Define a bounded global execution policy appropriate to Agent_X:

- bounded worker/task/tool/subprocess capacity;
- explicit queued/waiting state or structured capacity rejection;
- exact queue ownership;
- exact cancellation of queued entries;
- reasonably fair scheduling;
- loop sessions cannot permanently starve unrelated sessions;
- limits are never enforced by silently cancelling another active session.

## Tests

Implement/execute:

- B1 — true simultaneous nonterminal runs in distinct sessions;
- B2 — same-session conflict;
- T38-D — terminal CAS race;
- T38-J — cancel/complete race;
- C8 — terminal durability fault injection;
- T38-Q — bounded/fair capacity behavior.

## Gate 06

Proceed only when many sessions may run concurrently, each session still has at most one nonterminal top-level run, and terminal state cannot split into contradictory outcomes.

---

# TASK 07 — Exact Cancel, Pause, Resume, Question, Permission, and Approval Ownership

**Purpose:** eliminate every implicit-current control path.

**Prerequisites:** Task 06 passed.

## Cancel

Normal Stop/Cancel targets exact `(session_id, expected run_id)`.

Required behavior:

1. stale old-run cancel cannot affect a newer run;
2. repeat cancel of the exact run is idempotent;
3. accepted cancel transitions to `cancelling`, not immediately `cancelled`;
4. cancellation fences the run from beginning new mutating work;
5. signal/cancel exact owned tasks/process tree;
6. complete/abort owned cleanup safely;
7. release leases/resources by owner-checked idempotent cleanup;
8. only then terminalize `cancelled` if cancellation won;
9. no ordinary fallback to unqualified `/api/chat/cancel` or "current run";
10. Stop All, if retained, must explicitly enumerate exact active runs and cancel each by identity.

## Pause/Resume

Target exact `(session_id, expected run_id)`.

Cooperative semantics unless true safe OS suspension is deliberately implemented:

- accepted pause -> `pausing`;
- current atomic/tool step reaches a defined safe point;
- then -> `paused`;
- resume only same resumable run/generation;
- stale old-run pause/resume is rejected/no-op;
- cancellation while paused still uses exact cancellation semantics.

## Questions/permissions/approvals

Every request carries exact owner identity:

- `session_id`;
- `run_id` where run-scoped;
- unique `request_id`.

Reply resolution is atomic `pending -> terminal` (answered/rejected/cancelled/expired). Exactly one contender wins across the supported topology. A delayed duplicate or stale answer can never resolve a later request.

Run terminalization resolves/cancels still-pending owned interactions so they cannot resurrect.

## Structured errors

Return machine-readable codes such as:

- `STALE_RUN`;
- `REQUEST_ALREADY_RESOLVED`;
- `SESSION_BUSY`;
- `SESSION_DELETING`/`SESSION_DELETED`;
- other state conflicts.

## Tests

Implement/execute at least:

- B3 — run ownership mismatch rejected;
- B4 — stale cancel race;
- B5 — cancellation isolation;
- B10a — stale pause/resume;
- B10b — question/reply isolation;
- B10c — no generic cancellation fallback;
- T38-E — cancellation fencing;
- T38-K — pause safe-point behavior.

## Gate 07

Proceed only when no delayed control/reply can ever retarget a newer run/request or another session.

---

# TASK 08 — Canonical Event Log, Server-Side Subscription Isolation, Replay, Gaps, and Backpressure

**Purpose:** make asynchronous output owner-explicit, ordered, replayable, and safe under multiple tabs/windows/workers.

**Prerequisites:** Tasks 03-07 passed.

## Canonical event envelope

Every run-scoped persisted/live event includes at least:

```json
{
  "schema_version": 1,
  "event_id": "stable-unique-id",
  "session_id": "...",
  "run_id": "...",
  "seq": 123,
  "kind": "...",
  "timestamp": "...",
  "payload": {}
}
```

Also include stable entity IDs whenever mutating a message/activity/request/artifact/tool entity.

Rules:

- missing owner IDs are protocol errors;
- per-run `seq` allocation is durable and monotonic;
- allocate seq + append event atomically, or persist an explicit durable skip/compaction marker so crashes cannot create unexplained permanent gaps;
- terminal events follow the same ordering contract.

## Start/event race correlation

After durable run admission:

1. persist/publish authoritative `run.accepted` or equivalent before ordinary deltas are required;
2. include `session_id`, `run_id`, and originating `client_run_request_id`;
3. Start HTTP response returns the same identities;
4. frontend may establish an unresolved run only from matching authoritative correlation or snapshot/idempotency lookup;
5. arbitrary unknown run events cannot hijack the session's active run.

## Server-side WebSocket/SSE isolation

1. Connections have explicit authorized subscription sets.
2. Subscribe/unsubscribe exact sessions idempotently.
3. Route private events only to connections authorized and subscribed to that session.
4. Do not broadcast all private session data and rely on React filtering.
5. Client owner filtering remains defense in depth.

## Replay and resync

1. Support resume by `(run_id,last_seq)` for dedicated streams or a correct multiplexed global cursor/resume map.
2. Multiplexed transport must never use one run's max seq as the sole global cursor.
3. Replay retention is bounded.
4. Server knows the retained-floor boundary.
5. Resume from older-than-floor triggers structured `RESYNC_REQUIRED` / authoritative snapshot + watermark.
6. Snapshot + replay/live handoff must be gap-free.
7. Client deduplicates by stable IDs and `(run_id, seq/event_id)`.
8. If seq jumps from N to N+2, do not advance durable cursor past the gap; bounded-buffer and recover N+1 by replay/snapshot.
9. Timeout/overflow falls back to authoritative reconciliation, never silent skip.

## Backpressure

- subscriber queues bounded;
- slow client cannot block event persistence/run execution/unrelated sessions;
- do not hold lifecycle/workspace locks while waiting on socket writes;
- lagging clients beyond replay window resync rather than consume unbounded memory;
- zero healthy subscribers must not affect canonical completion/history persistence.

## Tests

Implement/execute at least:

- B6 — event ownership and per-run sequence;
- B7 — disconnect/replay exactly once;
- B10 — subscriber cleanup;
- C6 — event gap recovery;
- C7 — concurrent event sequence allocation;
- C9 — multiplexed replay if applicable;
- C10 — slow subscriber isolation;
- T38-A — server-side socket isolation;
- T38-B — two windows same session converge;
- T38-C — replay retention floor;
- T38-S — event beats Start HTTP response;
- T38-W — crash at seq allocation/append boundary.

## Gate 08

Proceed only when streams are safe even if multiple sessions, multiple browser windows, and the supported worker topology interleave events arbitrarily.

---

# TASK 09 — Worker Ownership, Heartbeats/Fencing, Crash Recovery, and Mutation-Capable Process Death Proof

**Purpose:** ensure stale/crashed workers or child processes cannot keep writing after ownership changes.

**Prerequisites:** Tasks 01, 06-08 passed.

## Worker ownership

Where more than one process can participate or execution survives process failure, maintain durable owner generation/lease semantics:

- owner identity/generation;
- heartbeat/lease renewal by compare-owner;
- release by compare-owner;
- reassignment increments generation/fencing token;
- cooperating in-process mutation commits validate current fencing generation;
- stale owner cannot terminalize/release/write after supersession.

## Mutation-capable external processes

Fencing rows alone are insufficient because shell/git/package/formatter processes can write directly.

For every mutation-capable external process:

1. launch in an owned containment unit: process group/session, Windows Job Object, container/cgroup/supervisor, or equivalent available mechanism;
2. track exact ownership by `run_id`/resource owner;
3. retain conflicting workspace/resource ownership while the process tree can still write;
4. on cancel/shutdown/owner loss/backend crash, do not release/reassign mutation ownership only because heartbeat expired;
5. first prove exact process tree is dead/unable to mutate;
6. if death cannot be safely proven, quarantine affected workspace/resource and block conflicting mutation;
7. never kill by generic executable/process name;
8. detached/background mutating children are forbidden unless ownership/containment is explicitly transferred.

## Backend shutdown/restart

1. stop admitting new work before controlled teardown;
2. durably reconcile active process-owned runs;
3. signal/reap exact child groups where feasible;
4. on startup find nonterminal runs without valid live ownership;
5. resume/requeue only if explicitly safe/resumable;
6. otherwise mark `interrupted` honestly;
7. never leave zombie `running` forever;
8. stale leases are recovered only through owner/generation/death-proof rules.

## Self-hosted autoreload

Audit launch modes because Agent_X edits its own repository.

- frontend HMR teardown is not Stop;
- backend autoreloader is a global lifecycle boundary affecting all process-owned runs;
- production/execution mode must disable uncoordinated backend reload while active runs exist or route restart through explicit global restart policy;
- after actual backend restart, runs reconcile to valid resumed/interrupted state, never falsely "still running";
- watcher/dev-server ports/resources follow ownership rules.

## Tests

Implement/execute:

- B9 — restart -> orphan nonterminal becomes interrupted;
- T38-F — stale lease owner after reassignment;
- T38-G — topology proof;
- T38-O — admitted-but-not-started and actively-running crash cases;
- T38-T — backend dies while mutating child survives;
- T38-V — backend autoreload lifecycle behavior where applicable.

## Gate 09

Proceed only when a stale worker or orphan mutation-capable process cannot retain hidden authority after recovery/reassignment.

---

# TASK 10 — Shared Workspace Coordination and Conflict-Safe Mutation

**Purpose:** allow sessions to collaborate through one live checkout without silent stale overwrites.

**Prerequisites:** Tasks 01, 05, 09 passed.

## Workspace model

- One live checkout/workspace for all sessions.
- No per-session clone/worktree by default.
- Conversation context is never treated as a filesystem snapshot.

## Canonical path/resource identity

Before security/coordination checks:

- normalize separators/dot segments;
- resolve workspace root;
- reject traversal outside root;
- handle symlinks according to the security policy;
- account for case-folding where applicable;
- ensure aliases/symlink/case variants map to one conflict domain;
- rename/move locks source + destination + required parent/global metadata resources;
- acquire multiple keys in deterministic total order.

## Direct bounded file edits

Every Agent_X direct edit primitive must use expected base revision/content hash or equivalent atomic compare-write:

1. read current content + base hash;
2. compute edit against that content;
3. enter workspace mutation coordination;
4. acquire canonical per-file lock(s);
5. re-read/re-hash after lock;
6. if expected != current -> structured `WORKSPACE_CONFLICT`;
7. loser re-reads/replans/reapplies with finite retry/backoff;
8. never silently force-overwrite;
9. return resulting new revision/hash after successful write;
10. safe temp-file + atomic replace may protect file integrity but does not replace expected-revision concurrency logic.

## Hierarchical mutation barrier

Classify every mutation-capable invocation:

1. declared read-only;
2. bounded writer with known path/resource footprint;
3. broad/unknown writer.

Use one hierarchy or equivalent:

- bounded writer participates in shared workspace-mutation barrier + precise locks/revisions;
- broad/unknown writer takes barrier exclusively for the lifetime of the mutating process tree;
- therefore a broad writer conflicts with every bounded writer;
- disjoint bounded writers may overlap if proven safe;
- correctness-first implementation may serialize all mutation **windows**, but never entire LLM/network runs.

Unknown shell commands are not read-only by default merely to preserve concurrency.

## Multi-file edits

1. canonicalize/sort all paths;
2. acquire locks in total order;
3. validate all expected revisions before first write where practical;
4. preflight failure -> zero changes;
5. safe writes;
6. if partial failure after commit, attempt verified rollback where safe;
7. otherwise return explicit partial-failure listing changed/restored/failed files;
8. do not call it transactional unless it truly is.

## Structural workspace generation

Maintain a monotonic `workspace_structural_generation` or equivalent for checkout-wide semantic changes such as checkout/switch/reset/clean/merge/rebase, workspace remapping, broad destructive revert/restore, and other classified semantic changes.

- capture structural generation when a plan/read depends on checkout identity;
- increment as part of successful structural mutation/finalization;
- before committing an old planned write validate target revisions **and** relevant structural generation;
- branch/HEAD switch can invalidate a plan even if target file bytes are identical;
- do not use structural generation to make unrelated ordinary file edits conflict globally.

## Snapshot-sensitive reads/tests/builds

- fresh write-preparation reads capture revisions;
- coherent multi-file read/search/index captures structural/mutation generation before/after and retries/reconciles if changed;
- tests/build/static analysis capture relevant workspace/input revision at start and revalidate at completion;
- changed relevant inputs -> result is stale and must rerun/revalidate before being presented as validation of final workspace;
- long-lived dev servers intentionally observe evolving files and are different.

## Checkout-global resources

Coordinate narrow resource keys for:

- git HEAD/branch/index operations;
- package manager/lockfile generation;
- schema/database migrations;
- broad formatters/codegen;
- destructive cleanup;
- fixed ports;
- other non-concurrent-safe shared state.

Do not hold a global lock for the entire run.

## Undo/Revert

Treat as shared workspace mutation:

- exact checkpoint/files;
- revalidate against checkpoint;
- acquire affected locks/resources;
- conflict if newer overlapping changes exist;
- never silently erase another session's newer work;
- do not call `stopActiveWorkEverywhere()` just to revert one selected session;
- if inherently global/destructive, expose that scope explicitly.

## Tests

Implement/execute at least:

- B11 — same-file conflict;
- B12 — different-file mutation-window behavior;
- B13 — multi-file preflight zero-change failure;
- B14 — global resource serialization;
- B15 — canonical path containment/security;
- E4 — shared workspace repair A -> B -> A;
- E5 — same-file collision;
- E11 — global resource coordination;
- C13 — indirect broad writer coordination;
- C14 — stale validation result;
- C15 — bounded conflict retry termination;
- T38-H — broad vs bounded writer barrier;
- T38-I — path alias collision;
- T38-U — same file hash across branch switch still invalidates old plan.

## Gate 10

Proceed only when Session B can safely repair Session A's work in the same checkout and stale/coincident mutations cannot silently clobber each other.

---

# TASK 11 — External Resource Ownership: Processes, Ports, Temps, Containers, Sockets, Services

**Purpose:** prevent cleanup/cancellation from destroying another session's resources.

**Prerequisites:** Tasks 05, 07, 09-10 passed.

## Requirements

Audit all tools/resources outside ordinary file writes:

- child processes/process groups;
- ports;
- temp files/dirs;
- Docker/container/compose names;
- sockets/pipes;
- local DB/schema names;
- browser automation profiles/debug ports;
- dev servers;
- tool-created local/cloud/dev resources;
- shared mutable caches.

Rules:

1. private ephemeral resources use run/session-derived unique names;
2. intentionally shared resources use canonical resource keys;
3. destructive cleanup validates exact ownership;
4. cancellation cleans only the exact run's process/resource tree;
5. no process-name kill;
6. temp cleanup never deletes another run's similarly named artifact;
7. shared caches include every semantic owner/config/revision dimension needed for correctness or are removed from concurrent paths;
8. actual assigned ports/resources are returned to the owner.

## Tests

Implement/execute:

- C16 — external resource ownership;
- port/process/temp collision tests;
- cancellation isolation proving A cleanup leaves B resources alive.

## Gate 11

Proceed only when no session can accidentally reuse, kill, delete, or clean another session's private external resource.

---

# TASK 12 — Frontend Session-Keyed Store and Owner-Explicit Async Architecture

**Purpose:** remove the single-session React state model before rendering multiple tabs.

**Prerequisites:** backend identity/lifecycle foundations Tasks 02-08 passed.

## State architecture

Introduce semantics equivalent to:

```text
MultiSessionUiState = {
  openSessionIds,
  activeSessionId,
  bySession: {
    [session_id]: SessionUiState
  }
}
```

Each `SessionUiState` must own every state dimension that may differ concurrently, including at least:

- session name/metadata;
- messages/history;
- activities/tool output;
- active run ID/status;
- per-run last-applied sequence/cursor;
- streaming/in-progress state;
- errors;
- draft;
- attachments;
- scroll state;
- pending questions;
- pending permissions;
- subagent list/selected subagent/subagent messages;
- model/mode if session-specific;
- loop/Auto-Borg/watchdog state;
- unread/viewed progress;
- expanded tool/panel state;
- selected artifact/output;
- hydration/request generations.

Keep state global only when semantics are genuinely global, e.g. theme, backend URL, application-wide settings, immutable/stateless registries, deliberate Stop All, global workspace notifications.

## Reducer/action ownership

All async/persisted state mutations carry/capture explicit owner IDs.

Run events carry at least:

```text
sessionId, runId, seq/eventId
```

Never route async events through `activeSessionId`.

## Async boundary rule

Before every `await`, promise continuation, timer, subscription, polling callback, stream callback, tool callback, modal continuation, or delayed history/rename response:

1. capture owner `sessionId`;
2. capture `runId`/`requestId`/request-generation as applicable;
3. apply by captured identity;
4. reject stale identities/generations.

## Required migration from singleton `App.jsx`

Refactor incrementally:

1. inventory complete from Task 00;
2. move session/run/request state into keyed store/reducer;
3. retain active-session selectors only for synchronous rendering/gesture initiation;
4. make callbacks owner-explicit;
5. remove obsolete duplicated singleton state once compatibility is no longer needed.

## Tests

Implement/execute frontend tests:

- F2 — per-session drafts;
- F3 — attachments;
- F4 — late async callback only updates original owner;
- F5 — delayed old-run event cannot mutate new run state;
- F6 — duplicate seq applied once;
- F12 — subagent view isolation;
- F13 — loop isolation;
- F14 — pause owner captured across switch;
- F15 — reply owner identity captured across switch.

## Gate 12

Do not add the visible multi-tab UI until the underlying React state can represent two simultaneously active sessions without swapping singleton state.

---

# TASK 13 — Application Tab Strip UI in the Existing Chat Header

**Purpose:** add the requested in-page application tabs after state/runtime isolation exists.

**Prerequisites:** Task 12 passed.

## Component

Extract a focused `SessionTabBar` or equivalent rather than making `App.jsx` more monolithic.

Inputs/actions should semantically include:

- open sessions;
- `activeSessionId`;
- select session;
- close view;
- rename session;
- create new session.

## Placement

Replace the normal current session-name / `click to rename` presentation in the existing chat-header row with the application tab strip. Do not move the primary session tabs into an unrelated sidebar.

## Each tab must show

- session display name;
- selected/active visual state;
- close control;
- running/activity signal where applicable;
- waiting/error signal where applicable;
- unread/new-activity signal where applicable.

## Tab semantics

### New Session

- uses Task 02 idempotent flow;
- no global stop;
- insert session exactly once after real `session_id` known;
- select it;
- leave all others running.

### Open Session

- explicit existing `session_id`;
- if already open in this page: focus existing tab;
- otherwise append once and select;
- no cancellation;
- hydrate/reconcile authority.

### Switch

- presentation state only;
- set `activeSessionId`;
- render `bySession[sid]`;
- restore that session's draft/scroll/attachments/panels/artifact/subagent state;
- reconcile if stale;
- never stop/restart backend work;
- backend never changes a global selected-session concept.

### Close

- remove from `openSessionIds` only;
- no delete;
- no cancel;
- no loop disable;
- choose deterministic neighbor if selected tab closes;
- last close -> intentional empty state with New/Open affordance;
- backend run may continue while view closed;
- reopening reconciles current history/run.

### Rename

- exact `session_id`;
- optimistic allowed;
- persistence failure rolls back or refetches authoritative name;
- close-button click must not bubble into select/rename.

## Overflow

Implement robust many-tab behavior: horizontal scroll + selected `scrollIntoView`, overflow menu, or accessible equivalent. Do not compress labels/close controls into unusability.

## Accessibility

- `role="tablist"`;
- each selector `role="tab"`;
- `aria-selected`;
- roving `tabIndex`;
- associated panel semantics where appropriate;
- Left/Right arrows;
- Home/End;
- Enter/Space as appropriate;
- accessible close label;
- valid interactive hierarchy;
- deterministic focus after close;
- selected tab scrolled into view.

## Unread semantics

Use event/message progress, not timeouts. Clear unread only after selected tab has actually incorporated/rendered the new meaningful content.

## Subagent coexistence

Keep main application tabs available while showing a session-local secondary subagent context/back affordance. Switching application tabs restores that session's own subagent view.

## Tests

Implement/execute:

- F1 — tab registry/open/close/empty state;
- F7 — rename rollback;
- F8 — close invokes no cancel;
- F9 — New Session invokes no broad stop;
- F10 — accessibility/keyboard;
- E1 — two sessions both running while switching;
- E2 — inactive completion/unread;
- E3 — close/reopen running session.

## Gate 13

Proceed only when the visible tabs are a projection of already-isolated real sessions, not a cosmetic selector over singleton state.

---

# TASK 14 — Frontend Hydration, History Merge, Reconnect, Refresh, and Page-Local Persistence

**Purpose:** make tabs survive refresh/disconnect without duplicates or cross-session cache contamination.

**Prerequisites:** Tasks 03, 08, 12-13 passed.

## Browser page layout persistence

Use `sessionStorage` by default for application-tab layout:

```text
schemaVersion
openSessionIds
activeSessionId
safe uiBySession fields where approved
pendingOperations
```

Do not use `localStorage` to synchronize page tab layout across browser windows.

Server remains authoritative for transcript/history/run state.

## Legacy cache migration

Retire or redesign the old unqualified `agentx_chat_state`-style browser chat cache.

Migration must:

- read only known legacy keys;
- treat legacy transcript/status as non-authoritative;
- validate referenced server session ID;
- use a valid legacy session only to seed initial page layout where appropriate;
- never copy one legacy transcript into every tab;
- not overwrite newer schema state;
- handle malformed/expired data safely;
- stop writing obsolete unqualified chat cache;
- preserve unrelated global preferences such as theme/key-sound/activity settings.

## Hydration/history merge

1. History/snapshot response includes stable entity IDs + ordering revision/watermark.
2. Request captures owner session + request generation/revision.
3. Merge by stable IDs; never by text/timestamp/array position alone.
4. Delayed stale history response cannot erase newer live events.
5. Optimistic user messages reconcile to persisted stable identity/idempotency key.
6. Active-run/snapshot lookup can establish the run after refresh or event-before-HTTP race.

## Refresh during active run

1. restore page layout from `sessionStorage`;
2. validate restored sessions; remove deleted/missing ones without silently recreating;
3. fetch authoritative metadata/history at least lazily;
4. query exact active run per needed session;
5. re-subscribe/replay using cursor/watermark;
6. do not start replacement runs;
7. React remount/page lifecycle never means Stop.

## Multiple browser windows

Page layouts remain independent; server session state is shared deliberately. Two windows on the same session converge through server-authoritative ordered state.

## Tests

Implement/execute:

- F11 — tab layout uses sessionStorage;
- F16 — legacy unqualified cache cannot cross-contaminate S1/S2;
- C5 — stale history vs newer live stream;
- E6 — refresh mid-run no duplicate output;
- E7 — two real top-level browser contexts have independent tab layout;
- E10 — delayed S1 response after switch only changes S1;
- T38-B — same-session two-window convergence;
- browser lifecycle/unmount C12 — unmount/stream abort is not cancel.

## Gate 14

Proceed only when refresh/reconnect/window duplication cannot duplicate messages, lose live output, cross-contaminate sessions, or cancel runs.

---

# TASK 15 — Loop/Auto-Borg, Subagents, Attachments, Artifacts, Import/Export/Copy, and Delete

**Purpose:** complete isolation beyond plain chat text.

**Prerequisites:** Tasks 05-14 passed.

## Loop / Auto-Borg / watchdog

Per session track all loop state:

- enabled;
- paused;
- infinite;
- pending next iteration;
- counters;
- retry state;
- watchdog timestamps/timers;
- stable loop generation/`loop_id` where useful.

Rules:

- each iteration has unique `run_id` + run idempotency identity;
- N+1 only after N is truly terminal and required mutation/resource cleanup is complete;
- stale timers from old loop generation cannot schedule work after disable/restart;
- tab switch/close does not disable the loop;
- scheduler/state must not live only in a rendered component if unmount would stop it;
- watchdog exact run identity prevents stale timer cancelling a newer run.

## Subagents

Every child task carries:

- parent `session_id`;
- parent `run_id`;
- child/subagent identity.

Child events/questions/tools/cancel/cleanup stay under exact parent. Parent cancellation never affects another session's children.

## Attachments/artifacts

- stable IDs and exact owner metadata;
- run snapshot uses immutable attachment identity/hash;
- temp paths namespaced by owner;
- cleanup validates ownership;
- same run retry reuses immutable references;
- different attachment content under same idempotency key -> conflict;
- selected artifact is session-local.

## Import/export/copy

- capture explicit `session_id` before async work;
- switching tabs cannot retarget;
- export/copy while history changes corresponds to one consistent snapshot/revision/watermark;
- import-created session uses the same concurrency-safe/idempotent creation path;
- import never stops unrelated sessions.

## Session deletion

Close-view remains non-destructive.

Actual delete is a state machine:

1. exact `session_id`;
2. atomically mark deleting/tombstone and block new admission;
3. choose explicit active-run policy:
   - preferred structured `SESSION_HAS_ACTIVE_RUN`, requiring exact Stop + terminal convergence; or
   - explicit exact cancel-and-delete that waits/verifies terminal cleanup;
4. close/reconcile subscriptions, pending interactions, loops, ephemeral resources;
5. delete/tombstone durable data only after no worker retains authority to emit/mutate it;
6. stale clients cannot resurrect by saving old state.

## Tests

Implement/execute:

- C17 — delete active session safety;
- C18 — loop survives in-app close/reopen;
- C19 — subagent parent isolation;
- C20 — consistent export snapshot;
- T38-L — delete/start race;
- T38-P — attachment retry identity;
- loop fairness under capacity policy.

## Gate 15

Proceed only when these secondary asynchronous systems have the same ownership rigor as chat/run state.

---

# TASK 16 — Explicit Global Actions and Regression Audit

**Purpose:** preserve legitimate application-global operations without pretending they are session-local.

**Prerequisites:** Tasks 00-15 passed.

## Requirements

Audit every action that currently calls broad stop/reset/restart behavior.

Classify each as either:

### Session-scoped

Must target explicit session/run/resource identity and must not affect other sessions.

Examples commonly expected to become session-scoped:

- New Session;
- Open Session;
- normal select/switch;
- close application tab;
- rename;
- selected-session Stop/Pause/Resume;
- question/permission replies;
- selected-session loop controls;
- selected-session export/copy.

### Intentionally global

Examples may include:

- Stop All;
- backend restart/shutdown;
- destructive checkout reset;
- workspace-wide structural operation;
- application-wide system/VPN control if truly global.

For global actions:

- make scope explicit;
- coordinate resources;
- reconcile every affected open tab after completion/restart;
- do not fake session-locality.

## Regression areas

Verify existing behavior for at least:

- New/Open/Rename/Delete Session;
- import/export/copy transcript;
- undo/revert;
- model switch;
- mode switch;
- Auto-Borg/Balancer/Gap Filling;
- questions;
- permissions/governance;
- subagents;
- activity panel;
- metrics;
- backend/frontend restart actions;
- VPN/system controls;
- theme;
- Jira integration;
- run cancellation;
- reconnect/status polling;
- supported narrow/mobile layout.

## Gate 16

All existing unrelated features pass or have a documented deliberate compatibility change required by the concurrency architecture.

---

# TASK 17 — Mandatory Automated Test Matrix

**Purpose:** convert the specification into executable proof.

**Prerequisites:** implementation Tasks 00-16 passed locally at targeted-test level.

Do not mark a scenario complete based on sequential execution when concurrency is required. Use barriers, delayed responses, fake/intercepted streams, separate processes where applicable, and real browser contexts.

## 17.1 Frontend component/unit coverage

Must cover the source-spec behaviors equivalent to:

- F1 tab registry;
- F2 per-session drafts;
- F3 per-session attachments;
- F4 late async callback;
- F5 stale old-run event;
- F6 duplicate sequence;
- F7 rename rollback;
- F8 close does not cancel;
- F9 New Session no broad stop;
- F10 tab accessibility;
- F11 sessionStorage layout;
- F12 subagent isolation;
- F13 loop isolation;
- F14 pause exact owner;
- F15 question/permission reply exact owner;
- F16 legacy unqualified cache cannot cross-contaminate sessions.

## 17.2 Backend/API coverage

Must cover the source-spec behaviors equivalent to:

- B1 true cross-session overlapping runs;
- B2 same-session start conflict;
- B3 run/session ownership validation;
- B4 stale cancel;
- B5 cancellation isolation;
- B6 event ownership/order;
- B7 replay;
- B8 idempotent new session;
- B9 restart -> interrupted;
- B10 subscriber cleanup;
- B10a stale pause/resume;
- B10b question/reply isolation;
- B10c no generic cancellation fallback;
- B11 same-file conflict;
- B12 different-file mutation-window model;
- B13 multi-file preflight;
- B14 global resource lock;
- B15 canonical path security;
- B16/process-topology proof.

## 17.3 End-to-end browser coverage

Must cover:

- E1 simultaneous sessions streaming while switching;
- E2 inactive completion/unread;
- E3 close/reopen running session;
- E4 shared workspace repair;
- E5 same-file collision;
- E6 refresh mid-run;
- E7 two real browser windows/page-layout isolation;
- E8 stale cancel after newer run;
- E9 duplicate New Session ambiguity;
- E10 async S1 response after switch;
- E11 global resource coordination;
- E12 inactive-tab pending question/permission isolation.

## 17.4 Adversarial correctness coverage

Must cover every applicable source-spec C/T38 scenario, including at least:

- retry-after-terminal idempotency;
- ambiguous create/send across refresh/restart;
- immutable run config isolation;
- persistence lost-update races;
- stale history vs live stream;
- event gaps;
- concurrent seq producers;
- terminal durability;
- multiplex replay if used;
- slow subscriber;
- cancel convergence;
- unload/unmount not cancel;
- indirect broad writer;
- stale validation;
- bounded conflict retries;
- external resource ownership;
- delete-active-session policy;
- loop close/reopen;
- subagent parent isolation;
- consistent export;
- topology proof;
- server-side socket isolation;
- replay floor/resync;
- terminal CAS race;
- cancellation fencing;
- stale lease owner;
- broad vs bounded writer;
- path alias collision;
- cancel/complete race;
- pause safe point;
- delete/start race;
- browser ambiguous send reload;
- admitted/running crash recovery;
- attachment identity retry;
- capacity fairness;
- global-manager context bleed;
- event-before-Start-response;
- surviving mutating child after backend crash;
- identical target file hash across structural checkout generation change;
- crash between event sequence allocation and append;
- self-edit backend autoreload behavior where supported.

If any scenario is truly inapplicable, record **why** in the implementation report and prove the relevant feature/path does not exist or the supported topology excludes it.

## 17.5 Seeded stress test

Add a reproducible randomized stress test that repeatedly performs combinations of:

- create/open/select/close/reopen tabs;
- simultaneous starts across sessions;
- same-session conflict attempts;
- rapid switching;
- stream event injection;
- finish/cancel/pause/resume;
- pending question/permission replies;
- conflicting and nonconflicting file operations;
- replay/disconnect/reconnect;
- loops/subagents where practical.

At completion assert:

- no event/message/activity crosses session boundaries;
- <= 1 nonterminal top-level run per session;
- stale controls do not affect new runs;
- subscriber/controllers/resources remain within bounds;
- histories remain distinct;
- workspace equals a valid serialized/conflict-resolved outcome.

Use deterministic seeded randomness in CI.

## Gate 17

All mandatory automated tests pass. Do not continue to final audit with known failing mandatory tests.

---

# TASK 18 — Exact End-to-End Final Acceptance Scenario

**Purpose:** manually/automatically prove the product behavior users actually need.

**Prerequisites:** Task 17 passed.

Execute this scenario end to end against the real integrated application:

1. Open Agent_X in one browser page.
2. Session A appears as an application tab in the existing title/header row.
3. Start a long-running task in A.
4. While A remains active, invoke New Session.
5. B appears in the same header row and becomes selected.
6. A remains marked running and its backend run is still active.
7. Start a task in B.
8. Prove A and B are simultaneously nonterminal.
9. Switch A -> B -> A repeatedly while both emit output.
10. Prove every message/tool/activity remains under its owner.
11. Stop B; A continues.
12. Start a new B run; delayed old B cancel/event cannot affect it.
13. Let A modify a shared repository file.
14. B freshly reads the live file and sees A's change.
15. B repairs it.
16. A freshly reads and sees B's repair.
17. Race stale same-file writes; one must receive explicit conflict/re-read path.
18. Close A's application tab while A runs; backend run continues.
19. Reopen A from Open Session; reconcile without duplicate events.
20. Refresh browser; page tabs restore and reconcile server authority.
21. Pause A while B runs; only A pauses. Deliver stale old pause after newer A run; newer run unaffected.
22. Put A and B into independent waiting-for-input states; exact replies cannot cross or hit later prompts.
23. Undo/Revert against content another session changed; operation conflicts/revalidates rather than silently erasing.
24. Verify all guarantees under the actual supported process topology.
25. Lose successful create/send response, refresh, reconcile original request key; no duplicate session/run.
26. Run A/B with different model/mode settings; prove immutable configuration through tools/subagents.
27. Release delayed old A history after newer A events; newer state remains. Create sequence gap and recover it before cursor advancement.
28. Make one subscriber arbitrarily slow; A/B execution/persistence remain live and bounded.
29. Accept Stop for A but delay cleanup; A cannot start new run until old run terminal; B continues.
30. Run indirect mutating shell/formatter/generator overlapping another writer; coordination prevents silent clobber.
31. Change relevant file while test/build runs; result becomes stale/revalidated. Force repeated edit conflicts and prove bounded retry termination.
32. Attempt delete of running session; safe active-run policy leaves no orphan worker.
33. Close/reopen in-app tab with enabled loop; loop ownership survives view lifecycle.
34. Export/copy A while A changes and B is selected; output is one consistent A revision.
35. If stream is multiplexed, reconnect with interleaved A/B events; cursor cannot skip either.
36. Confirm no chat context, event output, question, permission, cancellation, pause, loop state, model/configuration, artifact/resource ownership, or error crosses session boundaries.

## Gate 18

Every applicable step passes. Any failure returns implementation to the responsible earlier task; fix, rerun targeted tests, rerun Task 17 affected coverage, then rerun Task 18.

---

# TASK 19 — Two-Clean-Pass Convergence Audit

**Purpose:** prevent a superficially complete implementation from shipping hidden singleton/race regressions.

**Prerequisites:** Tasks 17-18 passed.

Run the complete audit below repeatedly. The stopping condition is **two consecutive complete clean passes** with zero new material defects and no intervening code/specification change.

If any pass finds a material issue:

1. reset consecutive-clean count to zero;
2. fix the defect;
3. add/strengthen regression test;
4. rerun affected tests;
5. rerun full required suites;
6. begin the two-clean-pass count again.

## Pass A — ownership search

Search for at least:

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
agentx_chat_state
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

For every hit prove correct ownership under simultaneous sessions.

## Pass B — API identity

For every session/run-affecting endpoint prove:

- exact target session;
- exact target run if applicable;
- exact request ID for interactive prompts;
- no stale request can retarget newer state;
- server-side run/session relationship validation;
- authorization assumption is explicit;
- supported topology preserves the guarantee;
- conflicts are machine-readable.

## Pass C — asynchronous callbacks

For every promise/await/timer/subscription/poll/controller:

- owner captured before boundary;
- result applied by owner;
- stale generation/run/seq rejected;
- cleanup by owner.

## Pass D — execution context and persistence

Prove:

- model/tool/subagent path gets immutable RunContext;
- no shared mutable current configuration bleeds across runs;
- concurrent persistence cannot clobber history/index/run/metadata/idempotency state;
- stable IDs and revisions are present where required.

## Pass E — history/replay/backpressure

Challenge:

- stale history response;
- event gap;
- reconnect;
- terminal ordering;
- replay floor;
- multiplex cursor if applicable;
- slow subscriber;
- bounded buffers/listeners.

## Pass F — workspace mutation

For every file/shell/git/package/schema/codegen/formatter/global mutation path prove:

- correct classification;
- canonical path/resource;
- fresh-read/revision check where bounded;
- barrier/lock scope correct;
- structural generation respected where relevant;
- no silent stale overwrite;
- process tree ownership if external;
- finite conflict recovery;
- exact run/session attribution.

## Pass G — recovery

Exercise/reason with tests for:

- refresh;
- transport disconnect;
- backend restart;
- tab close/reopen;
- session deleted elsewhere;
- create/send response lost;
- admitted-but-not-started crash;
- running-worker crash;
- surviving mutating child;
- backend autoreload where applicable.

## Pass H — adversarial races

Challenge at least:

- switch exactly as event arrives;
- close exactly as event arrives;
- lost create/send response + refresh;
- old history response after new live events;
- out-of-order/gapped events;
- event before Start HTTP response;
- cancel acknowledgement while worker cleanup continues;
- cancel vs natural completion;
- delete vs new admission;
- old cancel/pause/resume after new run starts;
- old question/permission answer when next prompt is current;
- two starts same session;
- two starts different sessions;
- two same-file edits;
- broad writer vs bounded writer;
- structural checkout change with identical target bytes;
- undo/revert overlapping newer changes;
- multi-file preflight conflict;
- stale validation result;
- repeated conflict retry exhaustion;
- slow subscriber while unrelated sessions emit;
- resource collision/cleanup ownership;
- same races across separate workers/processes if supported.

## Gate 19

Stop only after:

- all mandatory tests pass;
- all Definition-of-Done requirements below are satisfied or explicitly proven inapplicable;
- two consecutive full audits find zero new material defects;
- there are no release-blocking TODOs/future-work gaps.

---

# 20. Definition of Done Checklist

All applicable items must be true.

## Application tabs

- [ ] Current session-title row is a usable application tab strip.
- [ ] New Session adds/selects another in-page tab without stopping existing work.
- [ ] Open Session focuses an already-open session instead of duplicating it.
- [ ] Switching is presentation-only and immediate.
- [ ] Closing a tab does not cancel/delete backend session/run.
- [ ] Rename is exact-session scoped and failure-safe.
- [ ] Overflow works.
- [ ] Accessibility/keyboard semantics work.
- [ ] Running/waiting/error/unread signals make background sessions manageable.

## Frontend isolation

- [ ] Messages/history session-keyed.
- [ ] Activities/tools session-keyed.
- [ ] Run state keyed by session/run.
- [ ] Drafts/attachments/scroll/panels/artifact selection session-keyed.
- [ ] Questions/permissions exact session/run/request keyed.
- [ ] Subagent state parent-session/run keyed.
- [ ] Loop/watchdog state session/run/generation keyed.
- [ ] Async completions target captured owner, never selected tab.
- [ ] Stale history/events cannot erase or mutate newer state.

## Backend lifecycle

- [ ] Unique `run_id` per run.
- [ ] At most one nonterminal top-level run per session.
- [ ] Different sessions genuinely run concurrently.
- [ ] Atomic admission and durable run idempotency.
- [ ] Immutable RunContext through orchestration/model/tools/subagents/callbacks.
- [ ] No mutable unkeyed current-session/current-run/current-model/current-question/current-cancel semantics.
- [ ] Exactly-one terminal state/event.
- [ ] Capacity bounded and fair.

## Run controls/interactions

- [ ] Cancel exact session + expected run.
- [ ] `cancelling` remains nonterminal until cleanup/death proof.
- [ ] stale cancel cannot affect newer run.
- [ ] Pause/Resume exact session + expected run with safe-point semantics.
- [ ] Questions/permissions exact request identity and atomic resolution.
- [ ] No normal unqualified current-run/current-chat fallback.
- [ ] Stop All, if present, explicitly enumerates owned runs.

## Events/reconnect

- [ ] Canonical schema-versioned event envelope with session/run/seq/event ID.
- [ ] Server-side subscription isolation.
- [ ] Event-before-HTTP start race correlated by client run request identity.
- [ ] Replay bounded and gap-free.
- [ ] Replay retention floor triggers authoritative resync.
- [ ] Event seq allocation cannot leave unexplained permanent gaps.
- [ ] Slow subscribers do not block execution/persistence/unrelated sessions.
- [ ] Refresh/reconnect deduplicates canonical entities/events.

## Persistence/recovery

- [ ] Session/history/run persistence cannot lose updates through stale whole-object saves.
- [ ] Stable IDs and revisions/watermarks exist.
- [ ] Browser tab layout uses page-local `sessionStorage`.
- [ ] Legacy unqualified chat cache cannot cross-contaminate sessions.
- [ ] Global preferences remain preserved.
- [ ] Pending ambiguous Create/Send identity is persisted before network dispatch.
- [ ] Backend restart reconciles orphan nonterminal runs honestly.
- [ ] Supported process topology is explicitly enforced/proven.

## Shared workspace

- [ ] All sessions use one live checkout.
- [ ] Fresh read/revalidation before mutation.
- [ ] Canonical path containment/alias handling.
- [ ] Expected per-file revision conflict detection.
- [ ] Same-file writes cannot silently clobber.
- [ ] Broad/unknown writers conflict with bounded writers through hierarchical barrier.
- [ ] No whole-run repository mutex.
- [ ] Multi-file preflight/partial-failure semantics explicit.
- [ ] Structural workspace generation protects stale plans across semantic checkout changes.
- [ ] Snapshot-sensitive validation detects relevant concurrent changes.
- [ ] Conflict retries finite/backed off.
- [ ] Undo/Revert cannot silently erase another session's newer overlapping work.

## Worker/external resources

- [ ] Processes/process groups exact-run owned.
- [ ] No process-name kill.
- [ ] Stale worker fencing/reassignment safe.
- [ ] Direct mutating subprocess cannot outlive ownership without death proof/quarantine.
- [ ] Ports/temp/containers/sockets/services/resources owner-safe.
- [ ] Backend autoreload/global lifecycle behavior honest and reconciled.

## Secondary systems

- [ ] Loops survive in-app tab close/reopen and use generation-safe scheduling.
- [ ] Subagent execution ownership explicit.
- [ ] Attachments/artifacts immutable owner identities.
- [ ] Import uses safe idempotent creation path and stops no unrelated work.
- [ ] Export/copy is exact-session consistent snapshot.
- [ ] Delete is state-machine safe and cannot race admission into orphan/resurrection.

## Security/diagnostics

- [ ] Run belongs to supplied session verified server-side.
- [ ] Session IDs are not treated as authorization if multi-user exposure exists.
- [ ] Local single-user deployment assumption explicitly stated/configured if that is the supported model.
- [ ] Workspace containment/symlink/path security preserved.
- [ ] Logs contain session/run/request/correlation/resource IDs without secrets/file contents.
- [ ] Structured state/conflict codes used instead of prose parsing.

## Evidence

- [ ] Frontend ownership tests pass.
- [ ] Backend real-overlap tests pass.
- [ ] E2E two-running-sessions switching test passes.
- [ ] Close/reopen active session passes.
- [ ] Shared repair passes.
- [ ] Same-file conflict passes.
- [ ] Stale cancel/pause/reply races pass.
- [ ] Duplicate Create/Send idempotency passes.
- [ ] Refresh/replay passes without duplicates.
- [ ] Restart/interrupted passes.
- [ ] Topology/second-instance or cross-worker tests pass.
- [ ] Seeded stress test passes.
- [ ] Existing regression suite passes.
- [ ] Two consecutive full audits are clean.

---

# 21. Forbidden Shortcuts / Automatic Failure Conditions

The implementation is not complete if any of these remain:

1. Visual tabs backed by one global messages/run/stream state.
2. Backend selected-session global changed when UI tab changes.
3. One global current run handle/controller for all sessions.
4. Private session WebSocket events broadcast to everyone and filtered only in React.
5. New/Open/Switch/Close invokes `stopActiveWorkEverywhere()` or equivalent.
6. Cancel/Pause/Resume without exact expected run identity.
7. Question/permission reply without exact request identity.
8. Async completion mutating active/selected tab rather than captured owner.
9. Duplicate in-page tabs for same backend session by default.
10. `localStorage` transcript/runtime cache treated as authoritative multi-session state.
11. Per-session git clone/worktree used as default isolation.
12. Same-file stale write allowed to silently win last.
13. Whole LLM run holds repository-wide mutex.
14. Broad/unknown writer can overlap bounded writer without shared barrier.
15. Process-name kill or cleanup that can affect another run.
16. Replay/listener buffers unbounded.
17. Crash/restart UI claims a dead run is still running without real resumability.
18. Ambiguous Create/Send can execute twice because original idempotency key was forgotten.
19. Two terminal outcomes for one run can both become observable.
20. UI shows `cancelled` while owned mutation-capable process can still write.
21. Stale worker can commit/release/terminalize after ownership generation changed.
22. Mutating external process can survive backend loss while conflicting lease is reassigned without death proof/quarantine.
23. Structural checkout change can be crossed by stale plan merely because target file hash stayed equal.
24. Event sequence allocation can leave an unexplained permanent gap after crash.
25. Multi-worker/second-instance launch can bypass process-local correctness primitives.
26. Stale session object save can replace newer transcript/run entities wholesale.
27. Delete can race new admission into orphan worker or resurrected session.
28. Replay truncation silently omits events without authoritative resync.
29. Global mutable model/mode/question/event/cancel setting can be observed by two runs.
30. No bounded global capacity/backpressure policy exists.

Any one of these is release-blocking.

---

# 22. Required Final Implementation Report

After Task 19 passes, return a concise evidence-based report containing:

1. **Files changed** — exact paths.
2. **Architecture implemented** — session store, run manager, event/replay, workspace coordinator, process topology model.
3. **Ownership enforcement** — how `session_id`, `run_id`, request IDs, and RunContext are propagated/validated.
4. **Run controls** — cancel/pause/resume/reply stale protection and terminal convergence.
5. **Reconnect/replay** — event envelope, ordering, gap recovery, replay floor, slow-subscriber behavior.
6. **Shared workspace safety** — canonical paths, expected revisions, hierarchical barrier, structural generation, external mutator containment.
7. **Browser persistence** — `sessionStorage`, pendingOperations outbox, legacy cache migration.
8. **Recovery/topology** — worker/instance model, crash handling, interrupted runs, fencing/death proof.
9. **Tests added** — exact test files and scenarios.
10. **Commands/results** — exact commands actually run and whether each `PASSED`, `FAILED`, `NOT RUN`, or `BLOCKED`.
11. **Inapplicable requirements** — exact requirement + concrete proof/reason.
12. **Final acceptance scenario result**.
13. **Audit result** — Pass 1 clean, Pass 2 clean, with no intervening code change.

Do not claim success for tests that were not run.

---

# 23. Final Execution Mandate

The task is complete only when Agent_X supports **real concurrent in-page application tabs** with both of these properties at the same time:

> **Isolation:** each session/run owns its conversation, runtime, events, controls, questions, permissions, loop state, configuration, UI state, resources, and lifecycle.

> **Shared reality:** each session sees and can modify the same live Agent_X checkout, with enough fresh-read, revision, coordination, structural-generation, process-ownership, and conflict protection that one session can safely inspect and repair another session's work without silent stale overwrites.

Do not stop after implementing visible tabs. Continue until the full test matrix, exact acceptance scenario, Definition of Done, and two-clean-pass convergence audit all pass.
