# uBlock Resurrected — Remaining Behavior Work Execution Prompt

**Completeness-audit revision:** 2026-08-01 — final cold-start/coexistence/closure audit  
**Repository baseline:** `main` at `6bf75d518043d01faf0f1d2c5163f7fe70cf08dd`

## Mission

Work directly on the complete current source tree of:

- Repository: `Astrocytech/uBlockResurrected`
- Baseline reviewed: `main` at commit `6bf75d518043d01faf0f1d2c5163f7fe70cf08dd`
- Product: Chromium Manifest V3 content blocker

Complete the remaining major behavior work needed for a dependable release of the extension **within its currently claimed scope**.

This is not a request for uBlock Origin feature parity. The project openly supports only partial filter syntax and an MV3-compatible feature set. The goal is to make the implemented and claimed behavior reliable, persistent, and honest.

The tasks below represent the estimated remaining meaningful release work. Execute them in order. Do not merely produce recommendations. Inspect the current implementation, reproduce failures, modify the code, run focused verification, and report the result.

---

# Non-negotiable rules

1. **Prioritize actual extension behavior.**
   - Fix failures visible in Chromium or observable through Chrome extension APIs.
   - Do not spend substantial time polishing tests, reorganizing files, renaming symbols, formatting code, or expanding documentation.

2. **No GitHub Actions.**
   - Do not create, edit, enable, disable, or troubleshoot GitHub Actions workflows.
   - Run all checks locally.
   - Do not add workflow YAML files.

3. **Use the full current codebase.**
   - Do not inspect only the last commit.
   - Trace each behavior through the service worker, build tools, generated artifacts, popup/options UI, content scripts, and storage state as applicable.

4. **Do not perform a broad rewrite.**
   - Preserve working subsystems.
   - Make the smallest coherent architectural change that actually fixes the defect.
   - Do not replace the extension framework, DNR pipeline, storage format, or build system without conclusive evidence that the existing design cannot be repaired.

5. **Tests serve behavior, not the reverse.**
   - Add or update only focused regression tests needed to prove a real defect is fixed.
   - Never change an expectation merely to make a failing test pass.
   - A mocked unit test is not sufficient when the defect concerns real Chrome DNR, service-worker restart, navigation timing, content-script injection, or packaged-extension behavior.

6. **Do not claim unsupported behavior.**
   - When MV3 cannot guarantee a behavior, document the exact unsupported case and ensure the UI/status does not imply success.
   - First try to provide the strongest reliable behavior allowed by Chrome APIs.

7. **Preserve priority and ID ownership.**
   - Before allocating DNR rule IDs, inspect `id-authority.js` and every current rule producer.
   - Do not create overlaps between static-list dynamic rules, adaptive overflow, firewall rules, URL filtering, whitelist rules, CSP rules, redirects, or stealth/surrogate rules.

8. **Do not silently lose user configuration.**
   - User filters, custom lists, trusted-site rules, firewall rules, per-site switches, and selected built-in lists must survive extension restart and service-worker termination.
   - A failed update must leave the previous known-good configuration operational.

9. **Work phase by phase.**
   - Do not begin lower-priority UI or release work while a higher-priority runtime phase is still broken.
   - At the end of each phase, run its focused checks and manually verify the behavior.

10. **Do not treat repository certificates, evidence JSON, string-search checks, file-existence checks, or mocked Chrome APIs as proof of behavior.**
   - Existing `check:*` scripts are useful leads and regression gates, but many are structural rather than browser-behavior tests.
   - Never hardcode a pass value, create a placeholder evidence file, weaken a gate, or update documentation merely to make the project appear complete.
   - A claimed runtime capability passes only when the production manifest loads the tested code and Chromium demonstrates the behavior.

---


# Execution protocol for a lower-capability coding LLM

This prompt is intentionally comprehensive. **Do not attempt the entire project in one context window or one undifferentiated patch.** Work through one phase or one tightly related subphase at a time.

## Persistent progress state

Create a local progress file at:

```text
artifacts/remaining-work-progress.json
```

Do not include this file in the packaged extension. Do not commit it unless the user explicitly asks.

Use this structure:

```json
{
  "schemaVersion": 1,
  "repositoryCommit": "",
  "productionManifestHash": "",
  "currentPhase": "0",
  "currentSubtask": "",
  "completed": [],
  "inProgress": [],
  "blocked": [],
  "deferred": [],
  "lastKnownGoodCommands": [],
  "lastBrowserProfile": "",
  "lastBehaviorMatrixPath": "",
  "lastUpdatedAt": ""
}
```

For every completed item, store:

```json
{
  "id": "phase-subtask",
  "status": "PASS|LIMITED|DISABLED",
  "rootCause": "",
  "filesChanged": [],
  "tests": [],
  "browserEvidence": "",
  "commitOrWorkingTreeRevision": ""
}
```

Never write `PASS` based only on source inspection or a mocked test.

## Per-run procedure

At the start of every run:

1. Read this entire prompt section for the current phase.
2. Read `artifacts/remaining-work-progress.json`.
3. Confirm the repository commit and working-tree state.
4. Re-open every production file needed for the current subtask. Do not rely on memory from an earlier run.
5. Verify that previous completed behavior still passes its shortest relevant smoke check.
6. Work only on the current subtask until it reaches `PASS`, precise `LIMITED`, or a demonstrated blocker.

At the end of every run:

1. Save all code changes.
2. Run syntax/build checks for touched production files.
3. Run focused regression tests.
4. Run the required Chromium behavior fixture when the task concerns runtime behavior.
5. Update the progress file.
6. Write a short handoff containing:
   - exact current subtask;
   - root cause found;
   - files changed;
   - commands run;
   - browser result;
   - next exact action;
   - any uncommitted changes.

## Context-safety rules

- Do not reread or rewrite unrelated files to fill context.
- Do not start a second major defect while the first is half-fixed.
- Do not replace a detailed unfinished task with a vague TODO.
- Do not mark a phase complete when one required browser check was unavailable.
- When Chromium cannot be launched, complete only source-level preparation and leave the runtime item `blocked`; never convert it to `PASS`.
- Before context exhaustion, stop modifying code at a coherent point, update the progress state, and provide the handoff.
- Re-run the repository baseline check whenever `main` changes. Do not apply a diagnosis from an old commit blindly.

## Patch discipline

For each patch:

1. State the invariant being repaired.
2. Identify the production entrypoint that uses the code.
3. Make the smallest coherent fix.
4. Avoid temporary duplicate implementations.
5. Delete obsolete code only after all production callers have moved.
6. Update generated artifacts through their generator.
7. Add focused tests that fail before the fix and pass after it.
8. Verify the actual loaded extension.

Do not create a chain of local patches that only works for one fixture hostname, one rule ID, one list order, or one browser profile.

## Completion discipline

The project can be declared complete only after:

- all phases have a terminal status;
- no Blocker or Major item is `FAIL`, `inProgress`, or unexplained;
- two consecutive clean-room release sweeps pass without production-code changes between them;
- the final packaged artifact is the artifact used in the final browser sweep;
- the exposed behavior ledger contains no unaccounted surface.


# Scope-completeness mechanism

The repository can contain user-facing behavior that is not obvious from the README. Before fixing anything, create an **exposed behavior ledger** from the current source. This ledger is mandatory and prevents an apparently complete repair from overlooking an existing subsystem.

Inventory all of the following:

- every `manifest.json` action, command, permission, host permission, content script, options page, managed-storage schema, DNR ruleset, and web-accessible resource;
- every context-menu item;
- every `chrome.runtime`, `chrome.tabs`, `chrome.webNavigation`, `chrome.webRequest`, `chrome.commands`, `chrome.contextMenus`, `chrome.storage`, `chrome.idle`, `chrome.privacy`, and DNR event listener;
- every runtime message topic/name accepted by the service worker and every corresponding sender;
- every visible popup, dashboard, logger, picker, zapper, settings, import/export, backup/restore, and list-management control;
- every persisted setting and storage schema;
- every generated rule/artifact producer and its runtime consumer;
- every canonical production entrypoint and every parallel prototype, generated bundle, copied legacy file, or inactive implementation that could be tested by mistake;
- every accepted network-filter syntax family, lowering path, priority band, source-attribution path, and unsupported-syntax reporting path;
- every hostname/domain canonicalization path, Public Suffix List consumer, entity-scope matcher, and first-party/third-party decision;
- every special-site engine, including YouTube/video handling, stealth/surrogate handling, smart policies, and heuristic interception;
- every install, update, migration, refresh, cleanup, restart, extension reload, disable/re-enable, browser sleep/wake, and interrupted-operation path;
- every long-lived runtime connection, message request/response contract, timeout, reconnect, and stale-response path.
- every difference between developer/unpacked operation and the actual release/store profile, especially APIs gated by `declarativeNetRequestFeedback`;
- every exact-count, badge, logger, and attribution claim, with its production-capable source of truth;
- every Chrome host-access state: all sites, selected sites, on-click/not granted, access revoked while open, `file://` permission, and incognito permission;
- every browser-network path that can bypass or differ from ordinary DNR evaluation, including page service workers, CacheStorage, HTTP cache, prerendered pages, and restored/discarded tabs;
- every DNR quota dimension: static ruleset count, enabled-ruleset count, available static-rule count, dynamic safe/unsafe limits, session limits, regex-rule limits, and per-regex compiled-size rejection.
- every explicit `content_scripts.exclude_matches`, special-host exclusion, network-only host, and feature disabled for a named site;
- every behavior that can occur before `runtime.onStartup` or before the service worker hydrates, including restored tabs and immediate startup traffic;
- every behavior affected by another installed DNR/content-blocking extension, without assuming this extension wins cross-extension arbitration;
- every deterministic fixture's negative control, proving that the fixture fails when the corresponding extension feature is disabled.

For every ledger item, record:

```text
surface | production manifest entry | source owner/generator | expected user behavior | persistence | enforcement API | browser fixture | status
```

Allowed final statuses are:

- `PASS`: works in Chromium and is covered by a deterministic behavior check;
- `LIMITED`: works within a precise, documented MV3 or browser limitation;
- `DISABLED`: intentionally unavailable and visibly disabled or removed from the UI/manifest;
- `FAIL`: still broken.

The project is not complete while any exposed item is unaccounted for or remains `FAIL`. An item must not remain in the manifest or UI while doing nothing. Either make it work, accurately limit it, or remove/disable the exposure.

## Severity gate

Fix work in this order:

1. **Blocker** — filtering disabled, data loss, user rules lost, unsafe rollback, security/privacy failure, extension cannot load, or false success while enforcement is absent.
2. **Major** — an exposed feature is nonfunctional, restart changes behavior, rule precedence is wrong, a common page is broken, or a subsystem leaks/loops materially.
3. **Minor** — bounded user-visible defect that does not compromise filtering or state.
4. **Cosmetic/cleanup** — formatting, naming, test refactors, code-style cleanup, documentation polish, or speculative optimization.

Complete all Blocker and Major items. Fix Minor items only when they share the same root cause or are necessary for a coherent release. Defer Cosmetic/cleanup work.

---

# General defect workflow

For every defect encountered:

1. Write a minimal reproduction.
2. Identify the exact runtime path and root cause.
3. Record the expected behavior.
4. Patch the production code.
5. Add one or more focused regression tests.
6. Test the unpacked extension in Chromium.
7. Terminate/restart the service worker and retest.
8. Test the packaged extension if packaging can affect the behavior.
9. Confirm that adjacent rule producers and state are unchanged.
10. Record:
   - files changed;
   - root cause;
   - behavior before;
   - behavior after;
   - tests run;
   - manual browser result;
   - remaining limitation, if any.

Do not turn the defect workflow into a large reporting project. Keep the notes concise and evidence-based.

---

# Phase 0 — Establish the actual baseline

## Objective

Create a trustworthy starting point before modifying behavior.

## Required work

1. Install dependencies using the repository's intended package manager.
2. Inspect:
   - `package.json`;
   - `platform/chromium/manifest.json`;
   - `platform/chromium/js/sw.js`;
   - all files imported by or loaded beside `sw.js`;
   - `platform/chromium/js/id-authority.js`;
   - filter-list build/runtime files;
   - popup, dashboard, options, logger, picker, and content-script entry points;
   - generated ruleset registries and build scripts.
3. Build the extension.
4. Load `platform/chromium` as an unpacked extension in a clean Chromium profile.
5. Capture the initial state:
   - enabled static rulesets;
   - current dynamic rules;
   - current session rules;
   - extension storage keys relevant to filtering;
   - service-worker console errors;
   - default selected filter lists;
   - current runtime health/degraded status.
6. Run only the baseline commands needed to detect immediate breakage. Do not start by running every test in the repository.

7. Build the exposed behavior ledger described above before declaring the baseline complete.
8. Trace every manifest command to a command handler. Trace every context menu and UI control to a real runtime action.
9. Identify every generated file and record its source generator. Never repair a generated file without repairing its generator.
10. Record which capabilities differ between the minimum supported Chrome version and the current stable Chromium release.
11. Identify the exact files loaded by the production manifest. Mark prototype or inactive bundles as non-production and ensure no behavior test accidentally substitutes them.
12. Build a compiler/runtime syntax inventory from source and generated rules, not from documentation alone.
13. Record the canonical hostname/domain utilities and every subsystem that bypasses them.
14. Record every build-time external input, cache, generated timestamp, and unpinned download that can change the packaged extension.

## Minimum commands

```bash
npm install
npm run build:static-rulesets
npm run build:static-cosmetics
npm run check:sw-syntax
npm run verify:extension
```

If one of these fails, determine whether it is a real product/build defect or an unrelated stale check. Fix real build/runtime blockers before Phase 1.

## Phase 0 definition of done

- The extension loads in a clean Chromium profile.
- The service worker starts without an uncaught exception.
- The baseline DNR and storage state has been recorded.
- The exposed behavior ledger exists and has an implementation entry point for every manifest/UI/runtime surface.
- Generated artifacts have identified generators and consumers.
- Minimum-version versus current-Chromium capability differences are recorded.
- Any inability to load the extension is fixed before continuing.

---

# Phase 1 — Fix static filter-list reconciliation and stable partial activation

## Severity

Critical. Complete this first.

## Existing failure to verify

The project intentionally supports partial default activation of large built-in lists. EasyList and EasyPrivacy are split into shards, and all desired shards may not fit inside the browser's available static-rule capacity.

The current runtime computes a feasible subset but can treat any unavailable desired ruleset as a fatal result. This can preserve an obsolete static selection, abort the rest of the filter synchronization transaction, prevent My Filters or custom-list rules from committing, mark valid partial capacity as degraded, and trigger repeated recompilation after service-worker restart.

A lack of capacity is not an API failure. It is an expected operational state.

## Primary files

Inspect and modify the exact current paths, including at least:

- `platform/chromium/js/sw.js`
- `platform/chromium/js/static-ruleset-planner.js`
- `platform/chromium/js/filter-list-runtime-core.js`
- `platform/chromium/js/filter-list-streaming.js`
- `platform/chromium/js/filter-list-dnr-transaction.js`
- `tools/build-static-rulesets.mjs`
- `assets/default-filter-sources.json`
- generated `platform/chromium/dnr/runtime-ruleset-registry.json`
- directly relevant tests under `tests/mv3/`

Do not hand-edit a generated registry when the source generator can produce it.

## Required design

### 1. Preserve activation intent in generated metadata

The build output must retain enough information to distinguish:

- always-enabled rulesets;
- preferred default shards for partially activated lists;
- remaining optional shards;
- user-selected lists;
- list ownership and per-shard rule counts.

Generate a deterministic structure similar to:

```js
{
  alwaysEnabledRulesetIds: [/* ... */],
  rulesetIdsByList: {
    easylist: [/* all EasyList shard IDs */],
    easyprivacy: [/* all EasyPrivacy shard IDs */]
  },
  preferredRulesetIdsByList: {
    easylist: [
      "easylist-00",
      "easylist-01",
      "easylist-02"
    ],
    easyprivacy: [
      "easyprivacy-00",
      "easyprivacy-01"
    ]
  },
  ruleCountByRulesetId: {
    /* exact generated counts */
  }
}
```

Use the repository's actual data structures and naming conventions rather than copying this blindly.

### 2. Plan fairly and deterministically

Capacity planning must prioritize in this order:

1. mandatory/always-enabled project rulesets;
2. preferred shards for every selected partial list;
3. remaining shards from selected lists;
4. any lower-priority optional rulesets.

Do not fill all remaining capacity with EasyList before giving EasyPrivacy its preferred allocation.

Use round-robin or another deterministic fair allocation when multiple selected lists compete for remaining capacity.

Example planning shape:

```js
function planStaticRulesets({
  selectedListIds,
  currentlyEnabledIds,
  availableRuleCount,
  registry,
}) {
  const enableRulesetIds = [];
  const unavailableRulesetIds = [];
  const coverage = {};

  // 1. Add mandatory rulesets.
  // 2. Add preferred shards across all selected lists.
  // 3. Fairly add remaining shards while capacity permits.
  // 4. Return the exact feasible active set and coverage.
}
```

### 3. Treat partial capacity as successful operation

Return a result that clearly separates operational partial state from actual failure:

```js
{
  ok: true,
  applied: true,
  status: "partial", // "complete", "partial", or "failed"
  enableRulesetIds,
  disableRulesetIds,
  retainedRulesetIds,
  activeRulesetIds,
  unavailableRulesetIds,
  coverage: {
    easylist: {
      requestedRules: 0,
      activeRules: 0,
      requestedShards: 0,
      activeShards: 0,
      status: "partial"
    }
  }
}
```

Rules:

- `complete`: every requested shard is active.
- `partial`: the feasible planned subset is active and verified.
- `failed`: Chrome API update failed, post-update verification failed, generated metadata is invalid, or another real transaction failure occurred.

Remove logic equivalent to:

```js
if (unavailableRulesetIds.length > 0) {
  return { ok: false, status: "partial-preserved" };
}
```

### 4. Apply the feasible plan

Call `chrome.declarativeNetRequest.updateEnabledRulesets()` with the feasible enable/disable sets.

After it resolves:

1. read enabled rulesets again;
2. verify the exact managed active set;
3. commit only after successful verification.

Do not preserve an obsolete selection merely because the new requested selection is partial.

### 5. Continue the whole filtering transaction after partial static success

The main synchronization path must abort only on a real static failure.

A valid partial static result must still allow all of these to commit:

- dynamic filter-list rules;
- My Filters;
- custom/runtime lists;
- cosmetic artifacts;
- scriptlet artifacts;
- selected-list state;
- filter-list commit state;
- runtime health state.

Replace logic shaped like:

```js
if (!staticResult.ok) {
  return failed;
}
```

with logic based on explicit status:

```js
if (staticResult.status === "failed") {
  return failed;
}

// "complete" and "partial" continue.
```

### 6. Commit sufficient state

Persist at least the equivalent of:

```js
{
  staticStatus: "partial",
  requestedStaticRulesets: [/* requested managed IDs */],
  activeStaticRulesets: [/* verified active managed IDs */],
  unavailableStaticRulesets: [/* requested but not active */],
  staticCoverage: {/* per-list coverage */},
  sourceRevision: "...",
  committedAt: 0
}
```

Use existing storage schemas where possible. Add migration/default handling for old commits.

### 7. Make startup validation accept stable partial state

On service-worker startup:

- `complete` commits are valid when the requested managed set equals the active managed set.
- `partial` commits are valid when the **committed active managed set** equals the browser's actual enabled managed set and the source/configuration revision still matches.
- Do not require all originally requested rulesets to be enabled for a partial commit.
- Do not rebuild merely because `unavailableStaticRulesets` is non-empty.
- Rebuild only when the selection, generated registry, source revision, available capability, or actual browser state has changed.

Pseudocode:

```js
function isStaticCommitValid(commit, actualEnabledIds, currentRevision) {
  if (!commit || commit.sourceRevision !== currentRevision) {
    return false;
  }

  const expected = commit.staticStatus === "partial"
    ? commit.activeStaticRulesets
    : commit.requestedStaticRulesets;

  return sameManagedRulesetSet(expected, actualEnabledIds);
}
```

### 8. Report partial state honestly without degrading the extension

A valid partial activation should result in behavior equivalent to:

```js
runtimeHealth.dnrStaticRulesReady = true;
runtimeHealth.degradedMode = false;
runtimeHealth.lastError = "";
runtimeHealth.staticCoveragePartial = true;
```

Do not show a generic failure banner when the browser simply lacks capacity for every optional shard.

The filter-list UI or existing state surface should minimally show:

- complete, partial, or inactive per selected list;
- active shard count versus requested shard count;
- active rule count versus requested rule count.

Do not redesign the dashboard.

### 9. Preserve rollback on real failure

If the Chrome update or verification fails:

- restore or retain the previous known-good enabled set;
- do not write a new successful commit;
- preserve user filtering state;
- expose a real actionable error.

## Focused tests

Add or update only directly relevant tests:

1. A low-capacity plan returns `partial` with `ok: true`.
2. Preferred shards from both EasyList and EasyPrivacy are represented.
3. Allocation is deterministic.
4. A high-capacity plan returns `complete`.
5. Partial static success does not abort My Filters or custom-list dynamic commit.
6. A partial commit survives service-worker restart without recompilation.
7. A changed selection invalidates the commit and produces a new feasible plan.
8. A real DNR update failure preserves the previous active set and does not write a new commit.
9. ID ranges remain non-overlapping.

## Manual verification

In a clean profile:

1. Simulate or use a browser capacity insufficient for all desired shards.
2. Confirm a filter-list commit is created with `staticStatus: "partial"`.
3. Confirm preferred EasyList and EasyPrivacy shards are both enabled.
4. Terminate and restart the service worker.
5. Confirm no full list rebuild occurs.
6. Add a My Filters blocking rule.
7. Confirm its dynamic DNR rule exists and blocks a fixture request.
8. Restart the worker and confirm the rule persists.
9. Toggle EasyPrivacy off and on.
10. Confirm the new feasible static set applies and My Filters still commits.

## Phase 1 definition of done

- Partial capacity is a stable, successful runtime state.
- Default selected lists receive fair preferred coverage.
- My Filters and custom lists commit even when static coverage is partial.
- Service-worker restart does not cause a rebuild loop.
- Real API failure still rolls back safely.
- The UI/status distinguishes partial coverage from failure.

---

# Phase 2 — Fix adaptive overflow so it is not reactive-only and silently ineffective

## Severity

High. Complete after Phase 1.

## Existing failure to verify

The adaptive overflow path appears to install some session rules only after observing a matching request or navigation. DNR updates are asynchronous, so the request that caused installation may already have escaped. An observation-triggered rule is not a reliable blocker for that triggering request.

The overflow path also needs verification for filter semantics beyond exact request-hostname entries. Unsupported entries must not be counted as protected.

## Primary files

Inspect at least:

- `platform/chromium/js/filter-overflow-index.js`
- `platform/chromium/js/filter-overflow-runtime-core.js`
- `platform/chromium/js/filter-overflow-work-queue.js`
- `platform/chromium/js/filter-list-streaming.js`
- `platform/chromium/js/filter-list-runtime-core.js`
- `platform/chromium/js/sw.js`
- `platform/chromium/js/id-authority.js`
- all directly relevant overflow tests

## Required outcome

Replace a purely reactive overflow design with a layered design that provides reliable coverage before ordinary subresource requests occur.

### Layer A — Global prioritized overflow baseline

Use currently available dynamic-rule capacity, after reserving capacity for higher-priority user-controlled rules, to install a bounded global baseline of high-value overflow rules.

Priority order must be explicit:

1. user-created My Filters;
2. trusted-site/allow rules and explicit user exceptions;
3. dynamic firewall and URL-filtering rules;
4. required runtime safety/redirect/CSP rules;
5. selected custom-list rules according to existing product policy;
6. global high-value built-in overflow baseline;
7. adaptive per-tab/session overflow.

Do not evict a user rule to make room for an adaptive built-in rule.

The global baseline should favor:

- common tracker/ad host rules;
- high-confidence supported rules;
- rules with broad value;
- rules that are safe independent of current tab context;
- rules excluded from static activation only because of capacity.

Generate priority metadata during compilation rather than guessing from runtime order where possible.

### Layer B — Prewarm rules from known tab/site state

When a tab's target site is known, prepare relevant rules before normal subresource traffic as early as Chrome APIs reliably allow.

Use appropriate signals such as:

- existing tabs at service-worker startup;
- `tabs.onActivated`;
- URL changes exposed by `tabs.onUpdated`;
- committed/top-level navigation state;
- restored session state.

Do not rely only on `webRequest.onBeforeRequest` to discover the need for a rule.

Because event ordering and asynchronous DNR updates cannot guarantee interception of every new main-frame request, do not falsely claim that they do. The fix must maximize reliable subresource coverage and clearly identify any unavoidable first-navigation limitation.

### Layer C — Reactive learning only as a supplement

Observed request/navigation events may improve future rule selection, update frequency scores, or fill a later session cache. They must not be the sole enforcement path for rules that the product reports as active.

## Preserve complete supported rule semantics

Do not reduce every overflow entry to an exact request hostname.

The overflow index should retain enough compiled information to reconstruct the original supported DNR rule, including where applicable:

- `urlFilter` or `regexFilter`;
- resource types;
- initiator/request domains;
- domain exclusions;
- case sensitivity;
- action type;
- redirect resource;
- priority;
- list ownership and source rule identity.

Use a compact generated representation if memory is a concern.

Example:

```js
{
  sourceRuleId: "easyprivacy:12345",
  candidateHosts: ["tracker.example"],
  dnrRule: {
    priority: 1,
    action: { type: "block" },
    condition: {
      urlFilter: "||tracker.example/path^",
      resourceTypes: ["script", "xmlhttprequest"]
    }
  },
  listId: "easyprivacy",
  valueScore: 0
}
```

Do not blindly use this schema if the repository already has an appropriate compact format.

## Capacity and eviction

Implement deterministic capacity accounting.

Rules:

- Reserve fixed or calculated space for user-controlled and required runtime rules.
- Adaptive rules may evict only other adaptive rules of lower value.
- Global overflow baseline rules may be replaced only by a clearly better baseline selection or a change in selected lists.
- Rules needed by currently open tabs should outrank stale rules for closed tabs.
- Avoid frequent DNR updates caused by every request.
- Batch updates through the existing work queue.
- Respect Chrome quotas and update-rate limits.
- Verify installed session/dynamic rules after update when practical.

Example eviction score:

```js
function scoreOverflowEntry(entry, state) {
  return (
    entry.baseValue +
    entry.openTabMatches * OPEN_TAB_WEIGHT +
    entry.recentHitCount * RECENCY_WEIGHT -
    entry.agePenalty
  );
}
```

Keep the implementation simpler if a deterministic LRU plus explicit priority tiers is sufficient.

## State and restart behavior

- Rebuild the baseline from committed filter artifacts, not from untrusted old session state.
- Reconcile adaptive session rules on service-worker startup.
- Remove orphaned rules from deselected lists.
- Clear rules when a list is removed or filter data revision changes.
- Do not leave rules referring to missing redirect resources.
- Do not write unbounded request histories to storage.

## Honest coverage reporting

Track, at minimum:

- overflow rules eligible;
- installed globally;
- installed adaptively;
- omitted due to capacity;
- unsupported during compilation;
- last successful reconciliation;
- last real error.

Do not count a rule as active merely because it exists in an index.

## Focused tests

1. A high-value overflow rule is installed in the global baseline before a matching request.
2. A known-tab prewarm installs site-relevant rules without waiting for a matching subresource request.
3. The reactive path is supplementary rather than the only installation path.
4. Path-specific and resource-type conditions survive index serialization and installation.
5. User rules are never evicted by overflow rules.
6. Adaptive eviction is deterministic.
7. Closed-tab rules can be evicted before open-tab rules.
8. Deselected-list overflow rules are removed.
9. Restart reconciliation does not duplicate IDs or leak stale rules.
10. Capacity exhaustion is reported as partial coverage, not success.
11. A failed DNR update preserves the previous known-good overflow set.
12. Rule IDs remain inside their owned ranges.

## Manual verification

Create local fixture pages with deterministic requests:

- an immediately requested ad script;
- a delayed ad script;
- an XHR/fetch tracker;
- an image tracker;
- a path-specific blocked URL;
- a rule with a resource-type restriction;
- two tabs needing different overflow rules.

Verify:

1. A global-baseline request is blocked on the first load.
2. A known-tab prewarmed request is blocked without a prior matching request.
3. Delayed and SPA-created requests remain blocked.
4. Opening many tabs does not remove user-created rules.
5. Closing tabs allows stale adaptive rules to be reclaimed.
6. Restarting the worker does not create duplicate rules.
7. Deselecting the source list removes its overflow rules.
8. The reported active count matches actual Chrome session/dynamic rules.

## Phase 2 definition of done

- Overflow enforcement is not dependent solely on observing the request it should block.
- High-value rules have first-load coverage through a global baseline.
- Site-relevant rules are prewarmed when tab state is known.
- Supported rule conditions are preserved.
- User rules cannot be displaced by adaptive rules.
- Capacity omissions and unavoidable MV3 timing limitations are reported honestly.

---

# Phase 3 — Execute a behavior-first release sweep and fix significant failures

## Objective

Test the extension as a user would use it. Fix every significant broken behavior discovered within the currently claimed feature set.

Do not interpret this as a demand to write a giant test suite. Use a small deterministic local fixture site plus a limited number of real sites only where a local fixture cannot exercise the behavior.

## Build a deterministic fixture environment

Use or extend existing browser fixtures. Prefer a local HTTP server with pages that can generate:

- first-party and third-party scripts;
- images, fonts, media, frames, XHR, fetch, WebSocket if supported;
- popup attempts;
- redirects;
- inline and external cosmetic targets;
- dynamically added DOM nodes;
- shadow DOM targets if currently claimed;
- scriptlet-triggering JavaScript;
- SPA navigation;
- same-tab and new-tab navigation;
- CSP scenarios;
- allowlisted/trusted-site scenarios.

Each fixture should display a simple pass/fail signal or expose a deterministic value to Playwright.

Do not build a general website-testing framework.

---

## Phase 3A — Fresh install, startup, and restart

Verify and fix:

1. Clean installation produces a usable default configuration.
2. Static, dynamic, and session rules are reconciled once.
3. No uncaught worker errors occur.
4. Worker termination and restart do not:
   - lose selected lists;
   - lose My Filters;
   - lose custom lists;
   - lose trusted sites;
   - lose firewall rules;
   - cause duplicate DNR rules;
   - trigger an unnecessary full rebuild;
   - leave filtering disabled while state claims readiness.
5. Browser restart restores operational filtering.
6. Multiple simultaneous startup triggers are serialized.
7. A startup transaction cannot commit stale results after a newer selection change.

Use revision tokens, transaction IDs, or existing locks where needed.

Definition of done:

- Ten forced service-worker restarts produce the same effective rule state.
- No repeated full compile occurs without a real state/revision change.
- The extension never reports ready before required reconciliation finishes.

---

## Phase 3B — Default network blocking

Verify actual request cancellation through Chromium DNR for:

- scripts;
- images;
- subframes;
- stylesheets;
- fonts;
- media where supported;
- XHR/fetch;
- ping/beacon where supported;
- websocket rules if claimed;
- first-party and third-party contexts;
- domain include/exclude conditions;
- resource-type restrictions;
- case-sensitive rules if supported;
- exception/allow rules;
- redirect rules.

For every rule class reported as supported by the compiler:

1. compile a fixture rule;
2. verify the resulting DNR rule;
3. verify browser behavior;
4. verify logger attribution if claimed.

If a compiler class is accepted but produces ineffective DNR, fix it or reclassify it as unsupported. Never silently accept and drop semantics.

Definition of done:

- Every advertised supported network-rule class has a real browser fixture.
- The fixture passes on first load and after worker restart.
- Unsupported syntax is quarantined/reported, not counted as active.

---

## Phase 3C — My Filters and custom lists

Verify and fix:

1. Adding, editing, and deleting a My Filters rule changes actual blocking behavior.
2. Syntax errors do not erase the previously working compiled rules.
3. A partial compile reports rejected lines while applying valid lines according to current intended policy.
4. Custom list:
   - addition;
   - enable/disable;
   - update;
   - removal;
   - duplicate URL handling;
   - failed fetch or invalid content;
   - large-list streaming;
   - restart persistence.
5. Updating a list is transactional:
   - build new artifacts;
   - validate;
   - apply DNR/cosmetic/scriptlet changes;
   - verify;
   - commit;
   - retain old state on failure.
6. List toggles remove all owned artifacts:
   - static/dynamic/session network rules;
   - cosmetics;
   - scriptlets;
   - redirects;
   - overflow index entries.

Do not introduce remote-code behavior. Filter-list data handling must remain compatible with store policy.

Definition of done:

- A My Filters rule can be added and observed blocking without reinstalling the extension.
- A custom-list update failure leaves the old list operational.
- Removing a list leaves no owned runtime artifacts.

---

## Phase 3D — Trusted sites, per-site switches, dynamic firewall, and URL filtering

Verify each existing control end to end:

- trusted-site/allowlist toggle;
- global and per-site switches exposed by the UI;
- dynamic firewall cells/rules;
- temporary versus permanent rule behavior if present;
- URL filtering;
- CSP-related switches/rules;
- popup blocking switch if present;
- cosmetic filtering switch;
- scripting/large-media/font switches if claimed.

For each control:

1. use the UI or messaging path a user uses;
2. inspect persisted state;
3. inspect actual DNR/content-script behavior;
4. reload the page;
5. restart the worker;
6. reopen the browser;
7. revert the control and confirm normal filtering returns.

Check precedence explicitly. User allow rules must override lower-priority block rules where intended. User block rules must not be shadowed by unrelated allow rules.

Do not alter priority numbers without tracing all rule producers.

Definition of done:

- Every visible control either changes real behavior or is removed/disabled as unsupported.
- UI state, storage state, and actual enforcement remain synchronized after restart.
- Rule precedence matches the product's documented/intended behavior.

---

## Phase 3E — Cosmetic filtering and DOM behavior

Verify and fix:

- generic cosmetic selectors;
- specific/domain cosmetic selectors;
- cosmetic exceptions;
- dynamically inserted elements;
- SPA route changes;
- frames where supported;
- procedural cosmetic operators currently claimed;
- shadow DOM behavior only if claimed;
- cosmetic disable switch;
- DOM collapse behavior for blocked resources;
- generated cosmetic artifacts and runtime lookup.

Requirements:

1. Apply selectors only to eligible pages/domains.
2. Do not inject disabled-list cosmetics.
3. Do not leave duplicate observers after SPA navigation or worker messages.
4. Bound mutation-observer work.
5. Prevent obvious page breakage from malformed generated selectors.
6. Ensure list updates invalidate stale cosmetic artifacts.
7. Ensure partial static network activation does not prevent cosmetics from committing.

Use real DOM fixtures. A test that only inspects a generated JSON artifact is insufficient.

Definition of done:

- Static and dynamically added fixture elements are hidden correctly.
- Exceptions restore the element.
- Per-site cosmetic disable works immediately and after reload.
- Repeated SPA navigation does not multiply observers or processing.

---

## Phase 3F — Scriptlets and MAIN-world injection

The README claims a tested subset of scriptlets. Verify every currently claimed token through actual page behavior, including aliases.

At minimum inspect the claimed support for:

- `set-constant`;
- `prevent-fetch`;
- `prevent-xhr`;
- `noeval`;
- `abort-on-property-read`;
- `abort-on-property-write`;
- `abort-current-script`;
- `prevent-addEventListener`;
- aliases such as `aeld` and `addEventListener-defuser`.

Requirements:

1. Correct domain targeting and exceptions.
2. Correct argument parsing/escaping.
3. Injection at the required timing.
4. No use of `eval`, `new Function`, or remote JavaScript.
5. Unsupported tokens remain quarantined and visibly counted as unsupported.
6. Scriptlets from deselected lists stop executing.
7. Scriptlets do not execute on trusted/disabled sites when policy says they should not.
8. Prevent duplicate wrapping/hooking after SPA navigation or reinjection.
9. Restore patched APIs where the implementation promises restoration.
10. Fail closed only where safe; do not break the page when a scriptlet cannot be installed.

Definition of done:

- Each advertised token has a deterministic browser behavior fixture.
- Aliases map to the same implementation.
- Restart and SPA navigation do not duplicate hooks.
- Unsupported scriptlets are not reported as active.

---

## Phase 3G — Redirect resources, surrogates, CSP, and special runtime rules

Verify and fix:

- every redirect resource referenced by generated/runtime DNR;
- web-accessible resource declarations;
- MIME/type correctness;
- redirect rule ownership and removal;
- surrogate eligibility;
- CSP rule creation/removal;
- interaction with trusted sites and user exceptions;
- ID/priority collisions with other runtime producers.

A missing packaged resource must fail the build or verification rather than becoming a runtime redirect to nowhere.

Definition of done:

- Every referenced redirect target exists in both source and packaged extension.
- Redirect fixtures load the expected local resource.
- Disabling/removing the source rule removes the redirect.
- CSP and redirect rules respect user exceptions.

---

## Phase 3H — Popup, options/dashboard, logger, picker, and zapper

Do not spend time redesigning appearance. Verify that exposed tools work.

### Popup/options/dashboard

- displayed power state matches actual filtering;
- list selection changes commit successfully;
- partial list coverage is visible but not shown as generic failure;
- settings save and survive restart;
- import/export, backup/restore, or reset works if exposed;
- failed operations show an error rather than false success.

### Logger

- opens without exceptions;
- receives current tab events;
- distinguishes blocked, allowed, redirected, cosmetic, and scriptlet events where claimed;
- attribution identifies the correct source list/user rule;
- does not report an indexed-but-not-installed overflow rule as an actual block;
- survives tab changes and worker restart without uncontrolled duplicate listeners.

### Element picker/zapper

- launches on eligible pages;
- identifies the selected element;
- preview works;
- creating a permanent filter writes a valid My Filters rule;
- the new filter applies;
- cancel leaves no rule;
- zapper remains temporary;
- tools fail gracefully on restricted pages such as the Chrome Web Store.

Definition of done:

- Every visible user tool performs its primary action.
- Any exposed but fundamentally nonfunctional tool is fixed or clearly disabled, not left as a false control.
- No visual redesign is required.

---

## Phase 3I — Navigation, tabs, frames, and concurrency

Verify and fix behavior under:

- normal reload;
- hard reload;
- same-document SPA navigation;
- cross-origin navigation;
- back/forward cache where observable;
- duplicated tabs;
- multiple active windows;
- incognito only if manifest/policy supports it;
- nested frames;
- rapid list toggles;
- simultaneous My Filters save and list update;
- service-worker termination during a transaction.

Requirements:

- stale async work must not overwrite newer state;
- tab-specific policy must not leak to another tab;
- closing a tab cleans bounded tab/session state;
- listeners must not be registered repeatedly;
- transactions need cancellation/revision checks where appropriate.

Definition of done:

- Stress fixtures do not produce duplicate rules, stale commits, cross-tab policy leakage, or uncaught errors.
- Latest user action wins.

---

## Phase 3J — Storage, migration, rollback, and bounded resource use

Verify:

1. Every persisted schema has a version or safe default handling.
2. Old/missing fields do not crash startup.
3. A failed migration preserves recoverable user data.
4. DNR and storage commits cannot disagree indefinitely.
5. Temporary caches are bounded.
6. Overflow history, logger buffers, cosmetic caches, and tab state do not grow without limit.
7. Extension storage quota errors are handled as real failures.
8. Reset removes extension-owned state and rules without touching unrelated browser data.
9. A failed rule update leaves the previous known-good state.

Do not optimize microseconds. Fix only meaningful unbounded growth, restart instability, and transactional inconsistency.

Definition of done:

- A profile upgraded from the immediately preceding schema starts and filters correctly.
- Simulated write/update failure retains the last good state.
- Repeated browsing and tab churn do not cause clearly unbounded extension state.

---


## Phase 3K — Dedicated YouTube and video-ad subsystem

## Why this is mandatory

The extension contains a dedicated YouTube content script running in the MAIN world at `document_start`, YouTube-specific CSS, a YouTube engine in the service worker, video-ad DNR rules, sanitizer logic, stealth/surrogate behavior, and many dedicated runtime checks. This is a separate major product subsystem, not a small special case of ordinary filtering.

## Inspect at least

- `src/js/contentscript/youtube-adblock-main.ts` and its generated Chromium bundle;
- `platform/chromium/js/youtube-engine.js`;
- YouTube CSS and cosmetic artifacts;
- static video-ad rulesets;
- stealth/surrogate code;
- service-worker YouTube tab/session state;
- YouTube-specific DNR aggregation, priorities, redirect resources, and storage;
- all existing YouTube-focused tests and local verification scripts.

Do not edit a generated bundle directly when a TypeScript/source file owns it.

## Required behavior sweep

Verify and repair, within the current claimed scope:

1. normal watch pages;
2. preroll and midroll handling;
3. Shorts;
4. playlists and autoplay transitions;
5. SPA navigation between videos without full page reload;
6. embedded players, including `youtube-nocookie.com`;
7. live streams and premieres without breaking playback;
8. signed-out behavior and behavior that does not depend on an authenticated test account;
9. theater, fullscreen, mini-player, picture-in-picture, and background-tab transitions where relevant;
10. masthead/promoted feed cosmetics;
11. player response sanitization;
12. fetch, XHR, `Response.json`, `Response.text`, and `JSON.parse` interception paths currently implemented;
13. DNR video-ad rules and their interaction with sanitizer logic;
14. trusted-site/global-disable/cosmetic-disable behavior;
15. stealth or anti-detection mode if exposed;
16. service-worker restart and tab-state reconciliation;
17. multiple simultaneous YouTube tabs.

## Wrapper and sanitizer safety

The subsystem must not break ordinary page APIs.

Verify that wrappers:

- are installed once per JavaScript realm;
- retain correct `this`, arguments, return type, promise behavior, and thrown errors;
- preserve non-ad response data;
- do not recursively wrap themselves;
- do not affect non-YouTube hosts or unrelated endpoints;
- do not leak page data to the extension or another origin;
- expose native-looking function metadata only where safe;
- restore originals when the subsystem is disabled if the implementation promises restoration;
- do not leave stale hooks after navigation or extension update.

For synthetic `Response` objects, verify all observable behavior that the page relies on: status, status text, headers, body consumption, cloning, content type, and error behavior. Do not silently replace a response in a way that breaks playback.

## Failure policy

A YouTube-specific optional component must fail safely. If sanitizer installation, a surrogate, CSS injection, or an optional DNR rule fails, normal video playback must remain usable. Do not convert an ad-blocking failure into a broken player, reload loop, blank page, or repeated pause/seek loop.

## Focused browser checks

Use both deterministic local fixtures for wrapper/sanitizer behavior and a concise real YouTube manual sweep. Do not attempt a giant unstable scraping suite.

At minimum verify:

- no ad payload field remains in a fixture player response while required playback fields remain;
- unrelated JSON is unchanged;
- repeated SPA navigation does not multiply wrappers or observers;
- two tabs retain independent state;
- disabling filtering for YouTube stops all YouTube-specific enforcement promised by that switch;
- restoring filtering re-enables it without browser restart;
- failure of an optional rule does not prevent playback;
- memory and listener counts remain stable across repeated video navigation.

## Phase 3K definition of done

- The dedicated YouTube subsystem has its own completed behavior matrix.
- Video playback remains functional under every tested success and failure path.
- Sanitizers remove only intended ad structures.
- Wrappers are idempotent, scoped, and bounded.
- YouTube-specific DNR, CSS, sanitizer, stealth, and tab state do not conflict.
- Any unavoidable limitation is precise and not described as complete blocking.

---

## Phase 3L — Policy resolver, smart engine, heuristic interceptor, and site profiles

## Objective

Verify the policy layer that decides what filtering should occur on a page. This includes page signals, policy profiles, smart rules, heuristic interception, allow authorities, snapshots, and any automatic per-site mode selection.

## Required work

1. Inventory all policy inputs:
   - global power state;
   - trusted/blocklisted sites;
   - managed enterprise policy;
   - per-site switches;
   - dynamic firewall and URL-filtering rules;
   - page/site profile;
   - heuristic signals;
   - YouTube/special-site state;
   - temporary versus permanent rules.
2. Define one explicit precedence order in production code and tests.
3. Ensure the same inputs always produce the same effective policy.
4. Ensure lower-confidence heuristics cannot override explicit user or enterprise choices.
5. Ensure allow and exception authorities apply to all relevant rule producers, not only one DNR path.
6. Ensure a policy snapshot is scoped to the correct tab/frame/navigation revision.
7. Reject stale policy work after navigation or a newer user action.
8. Prevent tab A's profile or signal from influencing tab B.
9. Bound signal histories and classifier state.
10. Expose a concise explanation of the effective policy where the current UI/logger claims to explain decisions.

## Heuristic-interceptor safety

- Do not block or rewrite requests solely from an unvalidated weak signal.
- Require the confidence/evidence rules intended by the project.
- Prefer a safe non-blocking fallback when classification fails.
- Never let a heuristic rule outrank a direct user allow rule.
- Record actual heuristic enforcement separately from suggested or observed classifications.
- Do not create feedback loops where the extension's own block changes the signal and repeatedly escalates policy.

## Fixtures

Create deterministic pages representing:

- a normal site with no special profile;
- a site that matches a known profile;
- a false-positive lookalike;
- a user-trusted site that also matches a heuristic;
- two tabs with conflicting policies;
- rapid navigation from one profile to another;
- stale asynchronous classification finishing after navigation.

## Phase 3L definition of done

- Policy precedence is explicit, deterministic, and enforced across all subsystems.
- Explicit user and managed choices beat heuristics.
- Stale and cross-tab decisions cannot apply.
- Automatic profiles improve behavior without creating unexplained blocking.
- The logger/UI explanation matches the effective enforcement policy.

---

## Phase 3M — Manifest commands, context menus, action badge, icons, and custom new tab

## Objective

Every interaction exposed by the manifest or browser UI must execute a real action. The current manifest exposes multiple commands; an unhandled command is a broken feature even if the rest of the extension filters correctly.

## Commands to account for

Trace and behavior-test every current manifest command, including:

- launch element zapper;
- launch element picker;
- launch logger;
- open dashboard;
- relax blocking mode;
- toggle cosmetic filtering;
- toggle JavaScript;
- toggle custom new tab.

If a command cannot be supported reliably, remove it from the manifest or visibly disable its configuration path. Do not leave dead commands.

For every command verify:

1. active-tab resolution;
2. restricted-page handling;
3. behavior with no normal active tab;
4. behavior after service-worker restart;
5. correct temporary/permanent persistence;
6. UI and badge refresh;
7. no duplicate listeners or duplicate tool overlays.

## Context menus

Verify all current context-menu items and the setting that enables/disables them:

- creation is idempotent after install, update, and worker restart;
- disabling removes only extension-owned menu items;
- Block element launches the correct picker path;
- Open logger opens the correct context;
- stale/closed tabs fail quietly without masking real errors;
- menu state matches managed policy and user settings.

## Action button, badge, icon, and title

Verify:

- power state changes icon/title immediately;
- blocked-count badge is based on actual enforcement events, not planned rules;
- badge counts reset at the intended navigation boundary;
- counts do not leak between tabs;
- rapid tab switching cannot apply the wrong icon/count;
- disabled/restricted pages use a truthful state;
- worker restart reconstructs the correct visible state.

## Custom new tab

Inspect the actual mechanism rather than assuming a manifest override can be changed dynamically.

Verify:

- enabling produces the promised new-tab behavior;
- disabling restores browser-default behavior;
- the setting survives restart;
- failure or lack of browser support is reported, not silently accepted;
- the feature does not hijack existing tabs or unrelated URLs;
- enterprise policy and browser control restrictions are respected.

If Chromium cannot support the current design reliably, remove/disable the command and setting instead of presenting false success.

## Phase 3M definition of done

- Every manifest command has a working handler or is removed.
- Context menus are idempotent and functional.
- Badge/icon/title reflect actual tab state.
- Custom new-tab behavior works as advertised or is explicitly disabled.

---

## Phase 3N — Managed enterprise policy, browser privacy settings, sync, and idle lifecycle

## Managed enterprise policy

Behavior-test every field in `managed_schema.json`, including:

- forced filter lists;
- blocked filter lists;
- disable all filtering;
- disable cosmetic filtering;
- disable logger;
- managed whitelist;
- managed blocklist.

Requirements:

1. Managed values have explicit precedence over user choices.
2. User UI shows when a value is managed and cannot falsely report that a forbidden change succeeded.
3. Forced lists cannot be disabled by a user transaction.
4. Blocked lists cannot be enabled or remain active through stale artifacts.
5. Managed whitelist/blocklist entries affect every relevant enforcement layer.
6. Policy changes delivered through managed storage are reconciled without reinstalling the extension.
7. Removing policy restores normal user control without erasing the user's previous configuration unnecessarily.
8. Invalid managed values are rejected safely and reported.

## Browser privacy settings

The extension exposes or handles browser-level privacy controls such as:

- network prediction/prefetching;
- hyperlink auditing;
- WebRTC IP handling.

For each setting:

1. Read `levelOfControl` or equivalent before attempting a change.
2. Do not claim success when another extension or enterprise policy controls it.
3. Remember whether the extension changed the value.
4. When the user turns the feature off, restore only the prior value owned by this extension; do not overwrite a change made later by the user, policy, or another controller.
5. Reconcile the displayed state after browser restart.
6. Treat API failure as a visible setting failure, not a successful save.

## Storage sync/cloud behavior

If cloud/sync controls are exposed:

- verify upload/download and merge behavior;
- handle sync quota and unavailable sync storage;
- prevent old sync data from overwriting a newer local transaction silently;
- version synced schemas;
- never sync transient tab state, request logs, or browsing history;
- provide deterministic conflict handling;
- disable the controls when sync is unavailable.

If the UI only reports capability and does not implement sync, do not imply that backup synchronization occurs.

## Idle lifecycle

If idle/locked state disables the logger or other expensive processing:

- confirm it actually stops the intended work;
- confirm activity resumes it when appropriate;
- do not disable filtering itself unless explicitly configured;
- do not register duplicate idle listeners;
- ensure state remains correct after worker restart.

## Phase 3N definition of done

- Every managed policy field works and has correct precedence.
- Browser privacy settings are changed and restored safely.
- Sync controls are functional or truthfully unavailable.
- Idle lifecycle reduces optional work without disabling protection or becoming stuck.

---

## Phase 3O — Install, update, schema migration, list refresh, offline, and interrupted transactions

## Install and extension-update lifecycle

Verify `runtime.onInstalled` and all startup hydration paths for:

- first installation;
- extension version update;
- browser restart after update;
- extension update while ordinary, framed, dashboard, logger, picker, and YouTube tabs from the previous version remain open;
- service-worker termination during installation/update work;
- repeated invocation or overlapping startup triggers;
- migration from the immediately preceding shipped schema;
- missing or partially written old state.

Requirements:

1. Install/update work is idempotent.
2. Initial context menus, policy profiles, rulesets, cosmetics, scriptlets, surrogates, and settings reach one coherent committed revision.
3. An update preserves user filters, custom lists, trusted sites, firewall rules, settings, and backups.
4. Schema cleanup removes only state owned by the obsolete schema.
5. A failed migration leaves recoverable data and a usable previous rule state where possible.
6. An interrupted transaction resumes or rolls back; it must not remain permanently half-committed.
7. Cleanup routines cannot remove current valid filters or user-created entries.
8. Version changes invalidate only artifacts whose source/schema actually changed.
9. Old content scripts and extension pages cannot speak an incompatible message protocol to a new service worker without a finite, graceful version-mismatch response. Reload affected tabs or negotiate compatibility explicitly.
10. Existing tabs do not remain falsely shown as protected when the updated extension cannot safely reinject or reconcile them until reload.

## Built-in and custom list refresh

Inspect how built-in data is updated or packaged and how user-added custom lists are fetched.

Verify:

- refresh scheduling, if present;
- freshness timestamps;
- conditional HTTP behavior if implemented;
- redirect limits and accepted URL schemes;
- compressed/large response handling;
- content type and size limits;
- offline startup;
- DNS/network timeout;
- HTTP errors;
- truncated or malformed list content;
- unchanged content;
- source revision change;
- browser shutdown during compile/apply;
- removal of a source while refresh is running.

A failed or empty download must never replace a previously working list. Build, validate, apply, verify, and then commit.

Do not introduce automatic executable remote code. Filter lists are data and must remain constrained to the supported parser/compiler.

## Phase 3O definition of done

- Fresh install and version update reach one coherent state.
- User configuration survives update.
- Interrupted work recovers safely.
- Offline use retains the last good protection.
- Failed list refresh never replaces the last good list.
- Refresh artifacts and timestamps accurately describe the committed version.

---

## Phase 3P — Security, privacy, message boundaries, and hostile input

## Objective

Close release-blocking security and privacy defects in the actual extension runtime. Do not turn this into generic security paperwork.

## Runtime messaging

Inventory every message receiver and sender. Verify:

- sender identity, tab, frame, and URL are validated where required;
- a normal web page cannot invoke privileged service-worker operations directly;
- MAIN-world bridges accept only the minimum structured messages required;
- messages are schema-validated and size-bounded;
- stale responses cannot mutate a newer tab/navigation state;
- externally supplied object keys cannot cause prototype pollution;
- errors do not return sensitive extension state to page scripts;
- ports/listeners are disconnected and cleaned up.

## Web-accessible resources and injection

- Confirm every web-accessible resource is needed and packaged.
- Ensure resources do not expose private state or privileged APIs.
- Ensure picker/logger/tool overlays cannot be impersonated to obtain privileged actions.
- Keep MAIN-world code scoped to intended hosts and frames.
- Verify all-frame/about-blank behavior does not cross an unintended origin boundary.

## Hostile data inputs

Exercise:

- malicious or huge custom filter lines;
- pathological regular expressions within supported syntax;
- malformed imported backups;
- HTML/script-like list titles and URLs displayed in the dashboard/logger;
- internationalized domains, punycode, IPv6, credentials in URLs, ports, trailing dots, and mixed case;
- invalid redirect resource names;
- duplicate/colliding rule IDs supplied through imported state;
- storage objects with unexpected types or prototype keys.

Reject, quarantine, escape, or bound hostile inputs. Do not render untrusted content as HTML.

## Privacy and permissions

- No browsing history, request log, page content, or filter data may be transmitted externally unless an explicit existing user action requires the network request.
- No remote JavaScript, `eval`, or `new Function`.
- Verify each requested permission is actually used by a current feature. Remove a truly unused high-risk permission only when doing so does not break a supported behavior.
- Logger and telemetry-like diagnostics remain local, bounded, and user-controlled.
- Backup/export excludes transient browsing records unless explicitly promised and selected.

## Phase 3P definition of done

- Web pages cannot trigger privileged extension operations outside the intended bridge.
- Untrusted list/import/UI data cannot execute script or corrupt state.
- No remote code path exists.
- Sensitive browsing data remains local and bounded.
- Permission usage matches actual shipped behavior.

---

## Phase 3Q — Chromium-version compatibility, restricted pages, frames, and anti-breakage

## Browser versions

The manifest declares a minimum Chrome version. Test at least:

- the minimum supported major version or the closest reproducible environment;
- current stable Chromium/Chrome.

Verify capability fallbacks for:

- dynamic/session/static DNR limits;
- DNR API constants that may be absent;
- MAIN-world scripting;
- privacy API availability and control state;
- storage/session APIs;
- offscreen or other optional APIs if used;
- browser-specific error behavior.

Do not use a newer API without a guard when the declared minimum version lacks it. Alternatively, raise the minimum version deliberately and update all release metadata; do not leave a false compatibility claim.

## Restricted and unusual pages

Verify graceful behavior on:

- `chrome://` pages;
- Chrome Web Store;
- extension pages;
- `view-source:`;
- PDFs;
- `file://` only if the user grants access;
- `data:` and `blob:` descendants where applicable;
- sandboxed frames;
- `about:blank` and `about:srcdoc` frames;
- fenced or inaccessible frames where applicable;
- pages closed during asynchronous work.

No tool, command, or popup action should remain in a loading state or generate uncontrolled errors when injection is forbidden.

## Anti-breakage verification

Use a concise representative set, not a huge crawl:

- a news/content site fixture;
- login/form fixture;
- media player fixture;
- SPA fixture;
- nested-frame fixture;
- site requiring an exception/unbreak rule;
- site with aggressive script mutation;
- a page with no ads or trackers.

Verify that default blocking does not break core navigation, form submission, authentication redirects, media controls, or page rendering in the fixtures. Ensure quick-fix/unbreak rules and exceptions have higher intended priority and correct ownership.

## Phase 3Q definition of done

- Declared minimum and current Chromium versions behave consistently within documented capability limits.
- Restricted pages fail gracefully.
- Frame/origin handling is correct.
- Default protection does not cause reproducible severe breakage in the representative fixtures.

---

## Phase 3R — Practical performance, memory, wakeups, and cross-subsystem quota stability

## Objective

Fix material performance problems that make the extension unreliable. Do not pursue benchmark marketing or micro-optimizations.

## Required measurements

Measure before and after the changes using repeatable local scenarios:

- service-worker startup/hydration duration;
- full filter-list reconciliation duration;
- DNR update count and batch sizes;
- content-script initialization on a normal page and nested frames;
- mutation-observer activity on a dynamic page;
- YouTube wrapper/observer stability across repeated navigation;
- logger memory while open and after closing;
- IndexedDB/storage growth;
- tab/session map growth;
- CPU/wakeups while pages are idle;
- behavior near dynamic, session, static, and storage quotas.

## Required invariants

1. Do not call DNR update APIs once per request.
2. Batch and serialize updates through owned queues.
3. No more than one instance of each intended listener/observer/wrapper per context.
4. Closed tabs release tab-owned state.
5. Logger buffers, request ledgers, overflow histories, cosmetic caches, and diagnostic data have explicit limits.
6. A capacity manager accounts for all DNR producers before allocation.
7. Optional subsystems reduce coverage gracefully rather than evicting user rules or failing the whole extension.
8. Repeated worker wakeups with no state change do not trigger full rebuilds.
9. Storage compaction/cleanup cannot block page filtering for an excessive period.
10. Performance instrumentation itself is disabled or bounded in normal use.

## Stress scenarios

At minimum run:

- ten forced service-worker restarts;
- one hundred SPA route changes in a fixture;
- repeated enable/disable/list-toggle operations;
- at least twenty-five ordinary tabs and several YouTube tabs;
- a large supported custom list;
- near-capacity dynamic and session rules;
- logger open during sustained fixture traffic and then closed;
- browser idle/active transitions.

Use practical pass criteria:

- no monotonic unbounded growth after cleanup opportunities;
- no duplicate listeners/rules;
- no user-rule eviction;
- no update storm;
- no multi-second repeated freeze caused by unchanged state;
- filtering remains operational under quota pressure.

## Phase 3R definition of done

- Runtime state and buffers are bounded.
- DNR updates are batched and quota-aware across all producers.
- Restart and navigation loops do not multiply work.
- Near-capacity operation degrades optional coverage rather than losing user protection.
- No measured material regression is introduced by the fixes.

---


## Phase 3S — Network-filter compiler/runtime truth, priority, domains, and attribution

## Why this is mandatory

The repository contains compiler checks and documentation for filter syntax, but those artifacts are not necessarily synchronized with the code actually loaded by the Chromium extension. Some checks prove that files or strings exist rather than proving Chrome enforcement. The completion task must establish one truthful compiler-to-browser contract.

## Inspect at least

- `src/core/compiler/filter-classifier.ts`;
- `src/core/compiler/safe-network-rule-compiler.ts`;
- `src/core/compiler/rule-lowering-planner.ts`;
- `src/core/compiler/badfilter-resolver.ts`;
- the central DNR-priority modules;
- source-map and attribution builders;
- `docs/mv3-filter-syntax-coverage.md` and any generated coverage evidence;
- static, dynamic, session, overflow, user-rule, firewall, URL-filtering, trusted-site, redirect, CSP, and surrogate rule producers;
- logger/diagnostic consumers of rule source information;
- all hostname, domain, entity, and Public Suffix List utilities.

Do not assume the coverage document or certificate is current. Source behavior and Chromium behavior are the truth; then update the coverage statement to match.

## Build one authoritative syntax matrix

For every syntax family the classifier accepts, record:

```text
syntax | classifier result | compiler result | DNR/runtime representation | owner/range | browser result | public status
```

Explicitly account for at least:

- plain host and `||host^` blocking;
- allow/exception rules;
- `$third-party` and `$~third-party`/first-party semantics;
- `$domain=` inclusion and exclusion;
- `$denyallow` if accepted or exposed anywhere;
- `$match-case` and its negation;
- `$important` and conflicts with normal allows/blocks;
- resource types: `script`, `image`, `stylesheet`, `font`, `media`, `xmlhttprequest`, `websocket`, `ping`, `sub_frame`, and `main_frame`;
- negated resource types if the parser accepts them;
- `$removeparam=key`, multiple keys, exceptions, and unsupported regex forms;
- `$badfilter`, including exact identity and option-order normalization;
- regex filters if accepted, including Chrome regex-support validation and quota accounting;
- `$document`/`allowAllRequests` only if implemented or claimed;
- redirects and redirect-rule behavior only if implemented or claimed;
- request/response header modification, cookie stripping, and header matching only if implemented or claimed;
- CSP behavior and any runtime CSP subsystem;
- popup rules and the separate popup-blocking subsystem;
- unsupported response-body transformations such as `$replace`;
- cosmetic and scriptlet syntax classification versus their non-DNR runtime pipelines.

A syntax can finish only as:

- `SUPPORTED`: correct compiled/runtime behavior is proven in Chromium;
- `PARTIAL`: exact supported subset and rejected subset are proven and reported;
- `UNSUPPORTED`: rejected/quarantined without silent semantic loss;
- `REMOVED`: no longer accepted or claimed.

Do not leave accepted syntax that silently drops an option.

## Runtime priority and conflict semantics

Test real Chrome conflict outcomes rather than only comparing numeric constants.

At minimum cover:

1. normal block versus normal allow;
2. important block versus normal allow;
3. important allow versus important block;
4. trusted-site allow versus user/static/overflow blocks;
5. user block and user allow conflicts;
6. temporary/session URL-filtering versus permanent rules;
7. dynamic firewall versus selected-list rules;
8. redirect/removeparam/modify-header action conflicts;
9. allowAllRequests/document behavior if supported;
10. static, dynamic, and session rules at equal and unequal priorities;
11. list exception/unbreak rules against video, heuristic, surrogate, and overflow rules.

Use one central policy or clearly coordinated priority bands. No rule producer may invent an undocumented priority that reverses user intent.

## Hostname and registrable-domain correctness

Use a shared canonicalization contract across trusted sites, blocklists, dynamic firewall, URL filtering, policy profiles, cosmetics, scriptlets, overflow lookup, logger attribution, and managed policy.

Verify:

- lowercase normalization;
- trailing-dot handling;
- default and non-default ports;
- credentials in URLs;
- IPv4 and bracketed IPv6 literals;
- `localhost` and single-label intranet names;
- Unicode IDNs and punycode equivalence;
- malformed hostnames;
- public suffix versus registrable domain;
- private suffix handling according to the project's intended policy;
- entity scopes such as `google.*` if supported;
- wildcard and exception rules in the Public Suffix List;
- first-party/third-party decisions for multi-part suffixes such as `co.uk`;
- `about:blank`/`about:srcdoc` frame inheritance from the correct ancestor.

The PSL generator and runtime must not approximate away wildcard or exception semantics and then claim entity/domain correctness. Use a pinned, versioned local PSL input for release builds. A build without network access must produce the same functional PSL artifact as the release build.

## Rule provenance and attribution

Every installed rule must retain sufficient ownership information to answer:

- which subsystem owns the ID;
- which list or user setting produced it;
- which original filter/source line produced it when available;
- whether it is actually installed or merely eligible/indexed;
- which generation/commit it belongs to.

Verify attribution for static, dynamic, session, overflow, user, firewall, URL-filtering, trusted-site, redirect, CSP, surrogate, and YouTube rules. Logger output must not guess ownership from an overlapping numeric range or report an uninstalled candidate as an enforced rule.

## Focused tests

Add deterministic compiler tests plus browser fixtures for every `SUPPORTED` and `PARTIAL` family. Include conflict fixtures and domain/PSL fixtures. Do not create dozens of duplicative snapshot tests; one precise fixture per semantic family is sufficient.

## Phase 3S definition of done

- The syntax matrix exactly matches classifier, compiler, runtime, and Chromium behavior.
- No accepted option is silently discarded.
- Unsupported syntax is quarantined and counted honestly.
- Priority conflicts produce the intended result in Chromium.
- All domain-sensitive subsystems use equivalent canonical host/domain decisions.
- PSL wildcard, exception, IDN, and offline behavior are correct.
- Installed-rule provenance is accurate across every rule producer.
- Public claims and coverage artifacts are corrected only after behavior is proven.

---

## Phase 3T — Canonical production entrypoints, generated artifacts, and deterministic builds

## Why this is mandatory

The repository has a manually maintained canonical service worker loaded by the manifest and a separate TypeScript prototype/generated service-worker bundle that is not loaded. A lower-capability model can easily fix or test the wrong implementation. Build caches and generated external data can also make a clean checkout behave differently from the developer tree.

## Canonical-runtime rules

1. Treat `platform/chromium/manifest.json` as the entrypoint authority.
2. Treat `platform/chromium/js/sw.js` as the service worker only while the manifest points to it.
3. Mark `src/js/mv3/sw-entry.ts` and `platform/chromium/js/sw-entry-bundle.js` as prototype/inactive unless the project deliberately completes a migration and changes the manifest.
4. Do not port a fix only into an inactive prototype.
5. Every browser behavior test must load the production manifest and verify the production service-worker URL.
6. Every UI/content-script test must verify the loaded script path, not merely import a similarly named source module.
7. Remove or isolate stale copied implementations that can be packaged or tested accidentally, but do not perform a broad rewrite merely for tidiness.

## Generated-artifact ownership

Create an ownership table:

```text
artifact | source files | generator | production consumer | rebuild command | freshness check
```

Include:

- static DNR shards and registry;
- static and custom cosmetic artifacts;
- scriptlet bundles/registrations;
- YouTube MAIN-world bundle;
- logger/picker/zapper bundles;
- PSL data;
- release manifest and packaged extension;
- source maps and rule-attribution artifacts.

A generated file must never be hand-patched without updating its owner. A build must fail when a production artifact is stale relative to its source.

## Build cache correctness

Inspect caches that decide whether to rebuild generated code. Cache fingerprints must be content-based and include all transitive inputs that materially affect output. File modification time alone is not sufficient because checkout, archive extraction, rebasing, and file-copy operations can preserve or rewrite mtimes without matching content.

Verify:

- changing any compiler dependency invalidates the static-ruleset compiler cache;
- changing scriptlet/YouTube/logger source regenerates the loaded bundle;
- deleting the cache and rebuilding produces identical functional output;
- a stale cache cannot survive branch switching or source restoration;
- failed/partial builds do not leave mixed old/new artifacts that pass packaging.

## External build inputs and reproducibility

Inventory every build-time network input, including PSL and filter-source acquisition.

Requirements:

1. Release builds use pinned/versioned inputs with recorded hashes.
2. The local fallback is complete enough to reproduce release output offline.
3. A transient network response cannot silently change packaged behavior.
4. PSL parsing preserves the semantics required by the runtime, including wildcard and exception rules.
5. Default-filter source hashes are verified before compilation.
6. Generated timestamps do not make otherwise identical release builds differ when `SOURCE_DATE_EPOCH` or the repository's reproducible-build mode is used.
7. Build order and filesystem enumeration are deterministic.
8. Two clean builds from the same commit and pinned inputs produce byte-identical or explicitly normalized packaged artifacts.
9. The working tree does not contain unexplained generated changes after a verified clean build.

## Production/package identity

Verify consistency among:

- package version;
- source manifest version;
- release manifest version;
- packaged manifest version;
- extension name and IDs/paths where applicable;
- minimum Chrome version;
- locale keys and substituted `__MSG_...__` fields.

Ensure development-only prototypes, caches, tests, secrets, source-only fixtures, and unrelated evidence artifacts are not exposed as production web-accessible resources or packaged executable entrypoints.

## Anti-false-pass rule

The following do not prove this phase complete:

- a check that only verifies a file exists;
- a generated JSON field set to `pass: true`;
- a test importing the prototype instead of loading the manifest;
- a build run on a dirty tree containing already-generated output;
- a reproducibility comparison that reuses the same cache/output directory.

Use clean directories and inspect the loaded packaged extension.

## Phase 3T definition of done

- Every tested implementation is the implementation loaded by the production manifest.
- Prototype and generated copies cannot be mistaken for production sources.
- Every production artifact has a source owner and freshness check.
- Build caches invalidate on actual content changes.
- Offline and online release builds use the same pinned functional inputs.
- Two clean reproducible builds match.
- The packaged manifest, version, locale substitutions, and runtime files are coherent.

---

## Phase 3U — Runtime messaging resilience, extension lifecycle, and primary-control usability

## Objective

Close operational failures that appear only when the MV3 worker sleeps, the extension reloads, a port disconnects, or a user operates the popup/dashboard without a warm background context. These are real extension behaviors, not UI polish.

## Message and port reliability

For every request/response message and long-lived port:

- define a finite timeout;
- return a structured success or error result;
- handle `runtime.lastError` and disconnected ports;
- reconnect or retry only when the operation is idempotent and still current;
- reject stale responses using tab/navigation/operation revisions;
- ensure one failed recipient/frame does not leave the caller waiting forever;
- remove listeners and pending promises when a page, popup, logger, or tab closes;
- avoid multiple responses from duplicate listeners;
- distinguish “unsupported/restricted page” from worker failure;
- prevent repeated retries from waking the worker indefinitely.

Test opening the popup, dashboard, logger, picker, and zapper while the service worker is stopped. Each must either wake and complete correctly or show a finite actionable failure. No primary surface may remain on an indefinite spinner.

## Extension lifecycle beyond worker restart

Verify actual behavior across:

1. developer-mode extension reload;
2. extension disable and re-enable;
3. browser shutdown during an in-flight transaction;
4. browser/system sleep followed by wake;
5. large forward/backward system-clock changes where timestamps, TTLs, or refresh schedules are used;
6. profile restore with storage present but DNR state missing;
7. DNR state present but commit/storage state missing;
8. permission/control unavailability or loss where Chrome exposes it;
9. incognito normal/split behavior only if the extension exposes or supports it;
10. tab discard/freeze and later restoration;
11. an old-version content script attempting to communicate with a newly updated worker;
12. rapid open/close of popup, logger, picker, and dashboard.

Extension reload/disable/re-enable must not duplicate menus, listeners, registered content scripts, session rules, or generated state. Re-enable must reconcile from browser truth and the last valid user configuration.

## Browser-setting ownership and removal

For privacy settings or other Chrome-controlled settings:

- inspect `levelOfControl` before changing;
- do not overwrite a value controlled by policy or another extension;
- remember enough prior state to restore only changes owned by this extension;
- verify disable/re-enable behavior;
- verify removal/uninstall behavior in a temporary test profile where practical;
- never leave the browser in a weaker privacy state because the extension crashed or was removed.

Do not attempt to delete normal extension storage after uninstall; Chrome owns that lifecycle. Focus on browser-global settings the extension changed.

## Primary-control keyboard and accessibility behavior

Do not redesign the UI. Verify functional access to the primary controls:

- popup power switch;
- dashboard navigation and save/apply controls;
- list checkboxes/toggles;
- My Filters editor save/revert;
- logger tab/request selection;
- picker/zapper confirm/cancel;
- import/export/restore controls;
- error dialogs and status banners.

Requirements:

- controls are reachable by keyboard in a logical order;
- activation works with appropriate keyboard input;
- focus is not lost when asynchronous state refreshes;
- dialogs/overlays trap and restore focus correctly where applicable;
- visible labels or accessible names describe the action;
- disabled/loading state is exposed truthfully;
- primary status changes are not communicated only by color;
- localization does not leave raw message keys, empty labels, or broken layout that prevents operation.

This is a functional smoke test, not a visual-accessibility redesign.

## Phase 3U definition of done

- No primary UI operation can hang forever because the worker slept or a port disconnected.
- Messages time out, clean up, and reject stale work correctly.
- Reload, disable/re-enable, sleep/wake, and partial-state recovery preserve one coherent configuration.
- Extension-owned browser setting changes respect control ownership and revert safely.
- Primary controls remain operable by keyboard and after asynchronous refresh.
- Missing localization or accessible names do not make a shipped feature unusable.

---


## Phase 3V — Release-mode DNR observability, host-access restrictions, and browser network bypasses

## Why this is mandatory

Developer-mode behavior is not the same as released-extension behavior.

The current production service worker registers `chrome.declarativeNetRequest.onRuleMatchedDebug`, uses matched-rule data for attribution and badge updates, and uses `getMatchedRules()` for popup counts. Chrome exposes `onRuleMatchedDebug` only to unpacked extensions with `declarativeNetRequestFeedback`. The feedback permission is ignored for Chrome Web Store installations. A project can therefore appear complete while loaded unpacked but lose exact rule events, logger attribution, or badge counts when released.

Chrome can also let users restrict host access to all sites, selected sites, or on-click access. Network blocking, content scripts, `webRequest`, scripted injection, cosmetics, scriptlets, picker/zapper, and logging may not all retain the same capability under those states.

Finally, DNR applies only to requests that reach the browser network stack. Responses generated by a page's service worker or returned directly from CacheStorage may not pass through the same DNR path. This must be tested and reported honestly.

## Inspect at least

- every use of:
  - `declarativeNetRequestFeedback`;
  - `onRuleMatchedDebug`;
  - `getMatchedRules`;
  - `getEnabledRulesets`;
  - `getAvailableStaticRuleCount`;
  - action badge/count state;
  - logger attribution and source-rule lookup;
- development, canonical, release, and generated manifests;
- release/store manifest generation;
- `logger-runtime.js`, popup count handlers, badge handlers, and DNR decision/attribution stores;
- host-permission and content-script injection failure paths;
- page service-worker and CacheStorage interactions;
- all DNR limit calculations and Chrome-version fallbacks.

## A. Separate developer diagnostics from release behavior

1. Define two explicit capability modes:
   - `developerFeedbackAvailable`;
   - `releaseFeedbackUnavailable`.

2. Feature-detect the API and permission. Do not assume that listener registration succeeding in source means events will occur in the released extension.

3. The release must not require `onRuleMatchedDebug` for:
   - blocking;
   - startup readiness;
   - ruleset reconciliation;
   - user-rule persistence;
   - trusted-site operation;
   - popup availability;
   - logger opening;
   - service-worker health.

4. Decide whether `declarativeNetRequestFeedback` belongs only in a development manifest. Remove it from the release manifest if it has no valid production function. Do not retain an ignored permission that adds a misleading warning.

5. Run the critical suite with feedback capability deliberately absent, even when loading the source unpacked. This prevents developer-only APIs from creating a false pass.

## B. Make badge, popup counts, logger, and attribution truthful in release mode

### Badge and popup

An exact continuously updated per-tab blocked count may not be available in a normal store installation.

Implement one truthful release behavior:

- an exact count based on a production-supported source;
- a user-triggered recent count obtained through a permitted `getMatchedRules()` call;
- an explicitly approximate count with a clearly defined source;
- no count, with the badge disabled, when accuracy cannot be guaranteed.

Do not:

- silently retain the last developer-mode count;
- display zero as if it proves no rules matched;
- infer an exact DNR count from planned/indexed rules;
- attribute every `ERR_BLOCKED_BY_CLIENT` event to this extension;
- poll `getMatchedRules()` beyond Chrome quotas or without the required permission/user gesture.

The popup and badge must distinguish:

```text
exact | recent snapshot | approximate | unavailable
```

### Logger and rule attribution

1. Exact matched-rule attribution must be enabled only when a production-capable data source proves it.
2. In release mode, the logger may show observable requests and extension actions that the extension itself directly initiated or recorded, but it must not invent the matching DNR rule.
3. If exact DNR attribution is developer-only, label that mode and provide a truthful limited production logger.
4. An indexed, planned, compiled, or installed rule is not evidence that it matched a particular request.
5. Logger export must preserve the distinction between observed request, inferred outcome, exact extension action, and exact matched rule.
6. Badge and logger state must survive worker suspension without presenting stale information as current.

## C. Test actual release-like capability

Use at least these profiles:

1. canonical unpacked development manifest with feedback available;
2. release manifest with feedback permission removed or unavailable;
3. packaged/store-like artifact, where feasible;
4. release artifact after service-worker restart and browser restart.

For each profile verify:

- default blocking;
- popup opening;
- blocked-count presentation;
- logger opening and event truthfulness;
- source attribution;
- badge reset;
- trusted-site toggle;
- My Filters;
- list toggle;
- no uncaught error from unavailable feedback APIs.

Invalid static rules can be silently ignored in a packed extension. Therefore:

- validate every rule before packaging;
- query actual enabled rulesets after installation;
- run browser fixtures against each critical packaged ruleset;
- do not rely on unpacked-console warnings as the release validator.

## D. Host-access restriction matrix

Test Chrome's user-controlled site access in these states:

1. all requested sites allowed;
2. access limited to selected sites;
3. access set to on-click and not yet granted;
4. access granted for the active tab after user action;
5. access revoked while the page remains open;
6. a previously injected page after permission revocation;
7. `file://` access disabled and enabled;
8. incognito access disabled and enabled, when tested/supported.

For every state separately record whether these work:

- static/dynamic/session network block and allow rules;
- redirects and header modification;
- `webRequest` observation;
- manifest content scripts;
- `chrome.scripting` injection;
- cosmetics;
- scriptlets;
- YouTube MAIN-world logic;
- popup power state;
- logger;
- picker and zapper;
- per-site controls.

Requirements:

- Do not assume all layers lose or retain access together.
- The UI must report the actual level of protection: network-only, network plus page-level, user-grant required, restricted, or unsupported.
- Granting access must reconcile the current page after the required reload.
- Revoking access must remove or disable page-level behavior as far as Chrome permits and must not corrupt global configuration.
- Restricted access must not be mistaken for a filter-engine failure or degraded global state.
- Commands and context menus must fail finitely and explain that site access is required.

## E. Page service workers, CacheStorage, and nonstandard request paths

Build a deterministic local PWA fixture containing:

- a registering page service worker;
- a network-first request;
- a cache-first request served directly from CacheStorage;
- a service-worker `fetch()` that reaches the network;
- an offline cached response;
- cache invalidation and service-worker update;
- navigation preload if supported by the fixture.

Verify and document:

1. which requests reach DNR and are blocked;
2. which cached/generated responses do not reach DNR;
3. whether page-level cosmetics/scriptlets still mitigate visible content;
4. behavior on first visit versus controlled reload;
5. behavior after clearing/updating the page service worker;
6. worker restart and browser restart;
7. logger and badge truthfulness for cache-served responses.

Do not claim that DNR blocks a response produced entirely by the site's service worker or CacheStorage when it does not.

Also test:

- ordinary HTTP cache;
- back/forward cache restoration;
- prerender activation where reproducible;
- tab discard and restoration;
- redirects that transition into a controlled service-worker scope.

## F. Complete DNR quota and rejection coverage

The planner must account for all independent limits, not only total rules:

- maximum declared static rulesets;
- maximum simultaneously enabled static rulesets;
- available static-rule count shared with other installed extensions;
- dynamic safe-rule capacity;
- dynamic unsafe-rule capacity;
- session-rule capacity;
- regex-rule count for each rule type;
- compiled regex size/complexity rejection;
- disabled-static-rule limits if `updateStaticRules()` is used.

Required tests:

1. capacity limited by rule count;
2. capacity limited by number of enabled rulesets;
3. capacity reduced by another test extension;
4. capacity changed after disable and re-enable;
5. regex count at, below, and above the supported limit;
6. an over-complex regex rejected without invalidating unrelated rules;
7. safe and unsafe dynamic rules competing for their correct quotas;
8. session rules cleared on browser shutdown or extension update and rebuilt correctly;
9. dynamic rules persisting across update without duplication;
10. capability constants absent on the declared minimum Chrome version.

A rejected rule must be counted as rejected and associated with its source. It must never be reported as installed or active.

## Focused tests

Add focused tests proving:

- startup and filtering work with DNR feedback unavailable;
- release logger never invents exact attribution;
- badge/count state is marked exact, recent, approximate, or unavailable;
- release manifest does not depend on an ignored feedback permission;
- host-access restriction produces a truthful partial-protection state;
- permission grant/revocation does not damage persisted rules;
- cache-served fixture responses are not falsely logged as DNR blocks;
- the static planner respects both rule-count and enabled-ruleset-count limits;
- regex rejection and reduced shared capacity produce stable partial operation;
- session-rule loss across extension update is reconciled.

## Phase 3V definition of done

- The released extension does not depend on developer-only DNR feedback.
- Badge, popup counts, logger, and attribution are truthful in both development and release modes.
- Release behavior is tested with feedback unavailable.
- Host-access restriction and permission changes produce accurate UI state and finite failures.
- PWA/service-worker/CacheStorage limitations are measured and documented precisely.
- Every DNR quota and rejection path is represented in planning, status, and tests.
- Packed/static-rule validity is proven by installed behavior rather than developer-console output.

---


## Phase 3W — Cold browser startup, explicit host exclusions, extension coexistence, and clean-room closure

## Why this is mandatory

A normal browser start can restore pages and issue requests before the extension service worker has hydrated. Persistent static and dynamic DNR rules may already exist, while session rules, adaptive overflow state, tab policy, badges, and page-level injection may not.

The manifest also contains explicit content-script exclusions. Every excluded hostname creates a potentially different product mode: network filtering may continue while cosmetics, scriptlets, logger details, picker/zapper, or special-site handling do not.

Finally, Chrome resolves competing DNR actions across extensions independently of this project's internal priorities. The extension must coexist safely and report its own state honestly without pretending it controls the final result.

## A. True cold-start and restored-tab race

Use a fresh persistent Chromium profile, not only a Playwright context that starts after the extension is ready.

Test:

1. browser starts with the extension installed and the service worker stopped;
2. one or more ad/tracker fixture tabs are configured for session restore;
3. restored tabs issue immediate parser-started script/image/frame requests;
4. another tab opens immediately from the browser command line or startup URL;
5. the service worker wakes only after some network activity has begun;
6. the browser is started offline and then brought online;
7. the browser is killed during startup reconciliation and restarted;
8. the extension updates, then the browser starts with old tabs restored.

Record separately:

- static-rule enforcement before worker hydration;
- persistent dynamic-rule enforcement before worker hydration;
- missing/rebuilt session rules;
- adaptive overflow availability;
- trusted-site and user-rule precedence;
- content-script and document-start injection timing;
- cosmetic first-paint behavior;
- scriptlet timing;
- badge/logger accuracy;
- final committed state after hydration.

Requirements:

- Do not require `runtime.onStartup` to run before persistent DNR protection works.
- Do not clear valid persistent rules during hydration and create an avoidable unprotected window.
- Session/adaptive coverage that cannot exist before worker wake must be reported precisely.
- Restored-tab policy must be recomputed from tab URL/browser truth.
- Hydration must be idempotent when several startup events arrive together.
- A page loaded before page-level injection becomes ready must not be reported as fully protected until reload/reconciliation if one is required.

## B. Explicit host exclusions and network-only modes

Inventory every:

- `content_scripts.exclude_matches`;
- special-host skip in production JavaScript;
- hostname hardcoded as disabled, neutral, or protected from injection;
- restricted scheme;
- site where only a subset of engines operates.

The current manifest's explicit exclusions, including `chatgpt.com` and subdomains, must be handled as deliberate product behavior rather than silently ignored.

For each excluded host determine:

1. Why is it excluded?
2. Does DNR network filtering still operate?
3. Are cosmetics unavailable?
4. Are scriptlets unavailable?
5. Is special-site code unavailable?
6. Does the popup accurately show network-only or limited protection?
7. Do picker, zapper, logger, commands, and context menus fail finitely?
8. Can the exclusion be narrowed or removed without breaking the site?
9. Is the same exclusion present in source and packaged manifests?
10. Does a user-created My Filters network rule still work there?

Allowed outcomes:

- remove an obsolete exclusion after behavior verification;
- retain a necessary exclusion and present the exact limited mode;
- disable controls that cannot work;
- implement a safe site-specific path.

Do not leave an exclusion that makes visible controls silently do nothing.

## C. Coexistence with another DNR/content-blocking extension

Create a small deterministic companion test extension with configurable DNR actions. Do not use a real third-party extension as the only fixture.

Exercise:

1. both extensions block the same request;
2. this extension blocks while the companion redirects;
3. this extension allows while the companion blocks;
4. both redirect differently;
5. both modify the same request or response header;
6. install order is reversed;
7. one extension is disabled and re-enabled;
8. shared static capacity is reduced;
9. one extension updates while both are active;
10. this extension's logger/badge sees only evidence it can legitimately attribute.

Requirements:

- Internal rule priorities must remain correct within this extension.
- Do not attempt to defeat other extensions by artificial reinstall/update behavior.
- Do not claim that this extension's allow rule overrides another extension's block rule.
- Do not attribute another extension's block, redirect, or header modification to this extension.
- Coexistence must not corrupt stored configuration, trigger rebuild loops, or produce rule-ID assumptions.
- The UI may report “another extension may also affect this page” only when there is real evidence or a general clearly worded limitation; do not fingerprint installed extensions unnecessarily.
- Disabling the companion extension must return this extension to its independently expected behavior.

## D. Fixture negative controls and false-pass prevention

Every critical browser fixture must include at least one negative control.

Examples:

- disable the tested ruleset and confirm the request succeeds;
- remove the My Filters rule and confirm the request succeeds;
- disable cosmetic filtering and confirm the element remains;
- disable the scriptlet source and confirm the page behavior returns;
- disable trusted-site mode and confirm blocking resumes;
- run the release logger without feedback and confirm it does not invent attribution;
- run the packaged artifact without the required generated resource and confirm verification fails before release.

A test that passes identically with the extension disabled is invalid.

Store fixture results with:

```text
feature enabled result | feature disabled result | expected difference | actual difference
```

## E. Two-pass clean-room closure

After all fixes:

### Pass 1 — Fresh-install release sweep

1. Delete build output and relevant caches.
2. Produce the final packaged artifact.
3. Create a new Chromium profile.
4. Install only the packaged artifact.
5. Run the complete critical behavior matrix.
6. Run negative controls.
7. Record console errors, DNR state, storage state, and artifact hashes.

Fix any Blocker or Major defect found. If production code changes, Pass 1 must restart from the beginning.

### Pass 2 — Independent repeat

1. Do not change production code, generated output, manifests, or fixtures after Pass 1.
2. Build again from a clean checkout/cache state using the same pinned inputs.
3. Confirm artifact equivalence or explain only deterministic allowed metadata differences.
4. Use another new Chromium profile.
5. Repeat the critical matrix and negative controls.
6. Also run the immediately preceding-version upgrade profile.
7. Compare effective DNR rules, storage schemas, settings, and behavior with Pass 1.

Any unexplained difference or new Blocker/Major result fails closure.

## Focused tests

Add focused verification for:

- immediate cold-start fixture requests before worker hydration;
- restored-tab reconciliation;
- no unnecessary clearing of valid persistent DNR rules at startup;
- session/adaptive rule rebuilding after cold start;
- every explicit manifest host exclusion;
- network-only state on an excluded host;
- My Filters network behavior on an excluded host;
- deterministic cross-extension block/allow/redirect/header conflicts;
- logger and badge non-attribution of companion-extension actions;
- fixture negative controls;
- two clean builds and two clean browser profiles with matching results.

## Phase 3W definition of done

- Persistent protection is measured before service-worker hydration.
- Restored tabs reach one coherent policy state without avoidable protection gaps.
- Every explicit host exclusion has a justified, tested, and truthful product mode.
- Coexistence with another DNR extension does not corrupt state or create false attribution.
- Every critical fixture has a working negative control.
- Two consecutive clean-room release sweeps pass without production-code changes between them.
- The second sweep includes a preceding-version upgrade path.
- No Blocker or Major result remains.

---

# Phase 4 — Packaged-extension parity and release verification

## Objective

Prove that the artifact users install behaves like the source version.

## Required work

1. Build/package using the repository's release commands.
2. Load the packaged output in a new clean Chromium profile.
3. Repeat the critical fixture suite:
   - startup and version-update migration;
   - default network blocking;
   - partial static activation;
   - adaptive/global overflow;
   - My Filters;
   - trusted site;
   - custom list and failed refresh rollback;
   - dynamic firewall/URL filtering;
   - cosmetic rule;
   - every claimed scriptlet family through representative fixtures;
   - redirect and CSP rule;
   - YouTube/video-ad subsystem smoke test;
   - heuristic/site-profile precedence;
   - popup power switch and badge;
   - one keyboard command and every command-handler mapping check;
   - context menu;
   - managed policy smoke test;
   - privacy-setting control-state handling;
   - worker restart and browser restart;
   - restricted-page graceful failure;
   - minimum-version/current-version compatibility smoke tests;
   - full supported/partial network-syntax matrix and priority conflicts;
   - IDN/PSL/registrable-domain fixtures;
   - actual production entrypoint identity;
   - clean deterministic/offline build comparison;
   - worker-cold message timeout and reconnect behavior;
   - extension reload and disable/re-enable reconciliation;
   - primary keyboard/focus/localization smoke checks.
   - release mode with `declarativeNetRequestFeedback` unavailable;
   - badge, popup counts, logger, and attribution truthfulness in release mode;
   - Chrome host access restricted, granted, and revoked;
   - PWA/page-service-worker and CacheStorage fixture;
   - static enabled-ruleset count, shared available capacity, safe/unsafe dynamic quota, session quota, and regex rejection.
   - true cold browser startup with restored fixture tabs before worker hydration;
   - every explicit manifest host exclusion and network-only/limited mode;
   - coexistence with the deterministic companion DNR extension;
   - negative controls for every critical fixture;
   - two consecutive clean-room packaged sweeps with no production-code changes between them.
4. Compare:
   - manifest and declared minimum Chrome version;
   - command handlers and context-menu behavior;
   - included generated artifacts and their source revisions;
   - redirect resources and web-accessible resources;
   - ordinary and YouTube MAIN-world/content-script bundles;
   - static rulesets and runtime registries;
   - managed policy schema;
   - default settings and migrations;
   - security/remote-code properties;
   - behavior and practical performance results.
   - development versus release feedback capability and permission set;
   - production badge/logger/count behavior;
   - host-access restriction behavior;
   - PWA/CacheStorage limitation behavior;
   - actual installed rules after packed-rule validation and quota pressure.
5. Fix source/package omissions.
6. Confirm no remote code or missing runtime asset.
7. Do not touch GitHub Actions.

## Required local checks

Use the current repository scripts that directly validate modified areas. At minimum, after all phases:

```bash
npm run build
npm run build:static-rulesets
npm run build:static-cosmetics
npm run check:static-rulesets
npm run check:production-rulesets
npm run check:dnr-budget
npm run check:sw-syntax
npm run check:filter-list-memory
npm run check:user-rules-pipeline
npm run check:dynamic-filtering
npm run check:per-site-switches
npm run check:redirect-resources
npm run check:cosmetic
npm run check:scriptlet
npm run check:main-world
npm run check:heuristic-interceptor
npm run check:page-policy-schema
npm run check:site-profile-fixtures
npm run check:resource-type-mapping
npm run check:filter-syntax-coverage
npm run check:dnr-priority-semantics
npm run check:attribution
npm run check:entrypoints
npm run check:source-ownership
npm run check:generated-artifacts
npm run check:package-integrity
npm run check:json-integrity
npm run check:release-reproducibility
npm run check:no-remote-rule-fetch
npm run check:command-consistency
npm run check:cross-layer-integration
npm run check:privacy-safety
npm run check:storage-lifecycle
npm run check:migration-rollback
npm run check:extension-attack-surface
npm run check:remote-code
npm run check:no-fake-exports
npm run check:no-hardcoded-certificate-passes
npm run check:packaged-extension
npm run check:release-determinism
# Also run any existing repository checks specifically covering:
# - release manifest permissions / store profile
# - DNR feedback capability
# - host-access restriction
# - packed static-rule loading
# - DNR regex and ruleset-count quotas
npm run typecheck:runtime
npm run typecheck:ui
npm run test:youtube-unit
npm run test:youtube-functional
npm run verify:extension
```

Run only relevant focused Vitest/Playwright files during development. At final signoff, run the broader existing suite that is relevant and feasible locally:

```bash
npm test
npm run test:e2e
npm run test:youtube-browser
npm run verify:full
```

Also perform two builds from separate clean directories with caches removed and pinned inputs. Use the repository's reproducible-build environment, including `SOURCE_DATE_EPOCH` where supported, then compare package hashes and extracted file hashes. Run one of the builds without network access.

Do not spend the project rewriting unrelated failing legacy tests. If an unrelated check fails:

1. prove it is unrelated;
2. record it;
3. do not alter production behavior to satisfy it.

## Phase 4 definition of done

- Source and packaged extension pass the critical fixture suite.
- No required generated file or redirect resource is missing.
- The packaged worker starts cleanly.
- Critical state survives restart.
- Local release verification succeeds or any genuinely unrelated failure is documented with evidence.

---

# Required final behavior matrix

Before declaring completion, produce a concise matrix with these rows:

| Area | Clean install | First load | Reload | Worker restart | Browser restart | Packaged build | Min/current Chrome | Result |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| Default network blocking | | | | | | | | |
| Filter syntax/compiler-runtime contract | | | | | | | | |
| DNR priority and conflict semantics | | | | | | | | |
| Domain/IDN/PSL/party matching | | | | | | | | |
| Rule provenance and logger attribution | | | | | | | | |
| Partial static lists | | | | | | | | |
| Adaptive/global overflow | | | | | | | | |
| My Filters | | | | | | | | |
| Custom list and refresh rollback | | | | | | | | |
| Trusted site | | | | | | | | |
| Dynamic firewall/URL filtering | | | | | | | | |
| Smart policy/heuristic profiles | | | | | | | | |
| Cosmetic filtering | | | | | | | | |
| Scriptlet injection | | | | | | | | |
| Redirect/CSP/surrogate resource | | | | | | | | |
| YouTube/video-ad subsystem | | | | | | | | |
| Popup/per-site switch | | | | | | | | |
| Badge/icon/title | | | | | | | | |
| Logger attribution | | | | | | | | |
| Picker-created filter | | | | | | | | |
| Zapper temporary action | | | | | | | | |
| Manifest keyboard commands | | | | | | | | |
| Context menus | | | | | | | | |
| Custom new tab | | | | | | | | |
| Managed enterprise policy | | | | | | | | |
| Browser privacy controls | | | | | | | | |
| Sync/cloud controls, if exposed | | | | | | | | |
| Install/update migration | | | | | | | | |
| Existing tabs across extension update | | | | | | | | |
| Developer reload/disable/re-enable | | | | | | | | |
| Worker-cold messaging/timeouts | | | | | | | | |
| Offline/filter-refresh recovery | | | | | | | | |
| Canonical production entrypoints | | | | | | | | |
| Deterministic/offline clean build | | | | | | | | |
| Primary keyboard/focus/localization | | | | | | | | |
| Restricted pages/frames | | | | | | | | |
| Message and MAIN-world security | | | | | | | | |
| Quota/performance stability | | | | | | | | |
| Release-mode DNR feedback unavailable | | | | | | | | |
| Badge/count truthfulness | | | | | | | | |
| Production logger/attribution | | | | | | | | |
| Restricted/selected/on-click host access | | | | | | | | |
| Page service worker/CacheStorage behavior | | | | | | | | |
| Static ruleset-count and shared-capacity limits | | | | | | | | |
| Regex and safe/unsafe dynamic-rule quotas | | | | | | | | |
| Cold startup before worker hydration | | | | | | | | |
| Restored-tab immediate requests | | | | | | | | |
| Explicit host exclusions/network-only mode | | | | | | | | |
| Coexistence with another DNR blocker | | | | | | | | |
| Fixture negative controls | | | | | | | | |
| Clean-room release sweep 1 | | | | | | | | |
| Clean-room release sweep 2 | | | | | | | | |

Use `PASS`, `FAIL`, `LIMITED`, or `DISABLED`. Every `LIMITED` or `DISABLED` entry must state the precise reason and must match the UI/manifest exposure. Do not use vague phrases such as “mostly works.”

Also attach the complete exposed behavior ledger. The matrix is a summary and does not replace the ledger.

---

# Global release definition of done

The remaining work is complete only when all of the following are true:

1. The exposed behavior ledger contains every manifest, UI, event, message, storage, generated-artifact, and special-site surface.
2. No ledger item remains unaccounted for or `FAIL`.
3. Every feature still exposed to users is either working, precisely limited, or visibly disabled.
4. The extension loads and filters in a clean Chromium profile.
5. Partial static capacity is a stable operational state, not a failed transaction.
6. EasyList and EasyPrivacy receive fair preferred shard coverage under constrained capacity.
7. My Filters and custom/runtime rules commit even when static activation is partial.
8. Service-worker restart does not cause repeated full recompilation.
9. Adaptive overflow is not solely installed after observing the request it was supposed to block.
10. A prioritized global overflow baseline provides first-load coverage for high-value overflow rules.
11. Known-tab/site rules are prewarmed as early as reliably possible.
12. User-created rules cannot be evicted by adaptive built-in rules.
13. Supported overflow rule conditions are preserved rather than reduced to exact hostnames.
14. Every supported network rule class has at least one real browser behavior fixture.
15. Unsupported filter syntax is quarantined and not counted as active.
16. Every visible per-site control changes actual behavior and persists correctly.
17. Policy precedence is explicit and user/managed choices override heuristics correctly.
18. Heuristic/site-profile state is navigation- and tab-scoped with no stale cross-tab application.
19. My Filters works end to end without reinstalling the extension.
20. Failed list updates retain the previous working version.
21. Offline use retains the last committed filter state.
22. Deselected/removed lists leave no owned network, cosmetic, scriptlet, redirect, or overflow artifacts.
23. Cosmetic filtering works for initial and dynamically inserted DOM.
24. Every publicly claimed scriptlet token has a real behavior fixture.
25. Redirect resources exist and work in the packaged extension.
26. The dedicated YouTube subsystem blocks/sanitizes within its claimed scope without breaking video playback.
27. YouTube wrappers, observers, DNR rules, and tab state remain idempotent and bounded across SPA navigation.
28. Popup state matches actual filtering state.
29. Badge, icon, and title match the correct tab and actual enforcement state.
30. Logger events describe actual enforcement, not merely intended/indexed rules.
31. Picker-created permanent filters are written to My Filters and take effect.
32. Zapper remains temporary and leaves no persistent filter.
33. Every manifest keyboard command has a working handler or is removed.
34. Context-menu items are idempotent and functional.
35. Custom new-tab behavior works as advertised or is removed/disabled.
36. Every managed enterprise-policy field has correct enforcement and UI precedence.
37. Browser privacy settings respect control ownership and restore safely.
38. Sync/cloud controls work safely or are truthfully unavailable.
39. Idle lifecycle cannot leave the logger or another subsystem permanently stuck and never disables filtering unintentionally.
40. Fresh install and extension update are idempotent and preserve user configuration.
41. Failed/interrupted migrations and filter refreshes recover or roll back safely.
42. Rapid navigation and concurrent updates do not allow stale work to overwrite newer user actions.
43. Ten forced service-worker restarts preserve the same effective configuration.
44. Browser restart preserves user configuration and operational filtering.
45. Real DNR/storage failures roll back or preserve the prior known-good state.
46. Web pages cannot invoke privileged extension operations outside intended validated bridges.
47. Hostile list/import/UI input cannot execute code or corrupt state.
48. No remote JavaScript, `eval`, `new Function`, or browsing-data exfiltration path exists.
49. Runtime caches, ledgers, histories, observers, wrappers, and tab state are bounded.
50. DNR quota allocation accounts for every producer and never sacrifices user rules for optional coverage.
51. Declared minimum Chrome and current stable Chromium both pass the critical behavior suite or the minimum version is deliberately corrected.
52. Restricted pages and forbidden injection targets fail gracefully.
53. Representative anti-breakage fixtures retain navigation, forms, media, and page usability.
54. Source and packaged builds behave the same on the critical fixture suite.
55. Every generated runtime artifact matches its source generator and revision.
56. No required packaged file, redirect target, localization key, or web-accessible resource is missing.
57. No GitHub Actions files are added or changed.
58. No broad unrelated refactor is included.
59. Tests added are focused regressions for actual behavior defects.
60. All Blocker and Major issues discovered during the behavior sweep are fixed; deferred items are genuinely lower severity or outside the declared product scope.
61. The filter-syntax matrix agrees with classifier, compiler, installed rules, Chromium behavior, and public status.
62. No accepted filter option is silently discarded or weakened.
63. Real-browser conflict tests prove priority semantics across static, dynamic, session, user, trusted-site, firewall, URL-filtering, overflow, redirect, CSP, surrogate, and special-site rules.
64. Hostname and registrable-domain decisions are consistent across all subsystems, including IDN, punycode, IPv6, trailing dots, ports, localhost, and multi-part public suffixes.
65. PSL wildcard and exception behavior is correct, pinned, versioned, and reproducible offline.
66. Rule ownership and source attribution are correct for every installed rule class; indexed-but-uninstalled rules are never logged as enforcement.
67. Browser tests load the canonical production manifest and service worker, never an inactive prototype or similarly named bundle.
68. Every generated production artifact has one identified source owner, generator, consumer, and freshness check.
69. Build-cache invalidation is content-correct and cannot preserve stale compiler or bundle output after source changes.
70. Two separate clean builds with pinned inputs are reproducible, and an offline build produces the same functional extension.
71. No completion claim relies on hardcoded evidence, placeholder certificates, string-presence checks, or tests of inactive code.
72. Popup, dashboard, logger, picker, zapper, and other primary message flows have finite timeouts and cannot hang indefinitely when the worker is cold or a port disconnects.
73. Extension reload and disable/re-enable reconcile one coherent state without duplicate rules, listeners, menus, content-script registrations, or overlays.
74. Sleep/wake, clock changes, and partial storage/DNR recovery do not apply stale work or lose the last good configuration.
75. Extension-owned browser privacy-setting changes respect `levelOfControl` and revert safely on disable/removal where Chrome permits verification.
76. Primary controls remain keyboard-operable, retain sensible focus through asynchronous updates, and expose truthful disabled/loading/error states.
77. No missing localization key, raw `__MSG_...__` token, empty accessible name, or focus failure makes an exposed feature unusable.
78. Existing tabs and extension pages from a prior version either negotiate a compatible message contract or receive a finite reload-required state; they never remain falsely marked protected.
79. Tab discard/freeze and restoration do not duplicate injection, lose policy, or strand stale tab-owned runtime state.
80. The release/store profile works when `declarativeNetRequestFeedback` and `onRuleMatchedDebug` are unavailable.
81. No release-critical path depends on developer-only matched-rule events.
82. Badge and popup counts are explicitly classified as exact, recent snapshot, approximate, or unavailable; no stale or inferred value is presented as exact.
83. Production logger output distinguishes observed requests, inferred outcomes, exact extension actions, and exact matched-rule attribution.
84. The release manifest removes or justifies permissions that are ignored or unavailable in store installations.
85. Chrome host-access restriction, grant, and revocation are tested separately for network, content-script, cosmetic, scriptlet, YouTube, logger, picker, and control layers.
86. The UI reports partial protection accurately when browser host permissions prevent page-level enforcement.
87. Page service-worker and CacheStorage responses are not falsely claimed or logged as DNR-blocked.
88. PWA, HTTP-cache, back/forward-cache, prerender, and discarded-tab behavior is measured where reproducible and any browser limitation is precise.
89. Static planning respects both available rule count and maximum enabled ruleset count, including reduced capacity caused by another extension.
90. Safe dynamic, unsafe dynamic, session, regex-count, regex-complexity, and disabled-static-rule limits are independently handled.
91. Rules rejected by Chrome are source-attributed, counted as rejected, and never represented as installed.
92. Session rules cleared by browser shutdown or extension update are rebuilt without duplicating persistent dynamic rules.
93. Packed static-rule validity is proven through actual installed behavior because packed invalid rules may not produce developer warnings.
94. Persistent static and dynamic rules are proven effective for immediate startup traffic before the service worker hydrates.
95. Startup hydration does not unnecessarily remove valid rules and create an avoidable unprotected interval.
96. Restored tabs, cold-start tabs, and offline-to-online startup reach one coherent current policy state.
97. Every explicit content-script or special-host exclusion has a tested reason and a truthful limited/network-only UI state.
98. My Filters network rules and applicable DNR protection are tested on explicitly excluded content-script hosts.
99. Coexistence with a deterministic second DNR extension is tested for block, allow, redirect, header modification, install order, disable/re-enable, and shared capacity.
100. The extension never attributes another extension's network action to itself.
101. Every critical browser fixture includes a negative control that fails when the corresponding extension feature is disabled.
102. Two consecutive fresh-profile packaged release sweeps pass without production-code changes between them.
103. The second clean-room sweep includes an upgrade from the immediately preceding supported version.
104. The persistent progress state contains terminal evidence for every phase and no unaccounted exposed behavior.

---

# Explicitly out of scope

Do not spend this assignment on:

- full uBlock Origin parity;
- support for every filter-list syntax token;
- Firefox support;
- Safari support;
- mobile-browser support;
- a UI redesign;
- cosmetic visual polish;
- broad TypeScript conversion;
- renaming/reformatting the whole project;
- increasing code coverage for its own sake;
- rewriting all tests;
- benchmark marketing claims;
- badges/certificates unrelated to real runtime behavior;
- GitHub Actions;
- speculative performance optimization without a measured user-visible problem.

A newly discovered issue may be deferred only when it is outside the currently claimed scope, blocked by a demonstrated MV3 limitation, or materially lower severity than the release behaviors above. State the exact reason.

---

# Final response required from the executing LLM

Return:

1. **Completed phases**
2. **Complete exposed behavior ledger**
3. **Significant defects fixed, ordered by severity**
4. **Files changed, separating source files from generated artifacts**
5. **Behavior matrix**
6. **Commands and focused tests run**
7. **Manual Chromium verification performed**
8. **Minimum-version and current-Chromium results**
9. **YouTube-specific verification**
10. **Managed-policy, privacy-setting, command, and context-menu verification**
11. **Security/privacy and hostile-input verification**
12. **Performance/quota stress results**
13. **Packaged-extension verification**
14. **Network-syntax, priority-conflict, domain/PSL, and attribution results**
15. **Canonical-entrypoint and generated-artifact ownership report**
16. **Two-clean-build reproducibility and offline-build comparison**
17. **Worker-cold messaging, reload, disable/re-enable, and setting-ownership results**
18. **Primary keyboard/focus/localization smoke results**
19. **Known remaining limitations with exact reason and exposure status**
20. **Confirmation that no GitHub Actions were changed**
21. **Development-versus-release DNR feedback capability results**
22. **Badge, popup count, logger, and attribution truthfulness results**
23. **Host-access restriction/grant/revocation matrix**
24. **PWA, page-service-worker, CacheStorage, and browser-cache results**
25. **Complete DNR quota, regex rejection, and packed-rule validation results**
26. **Cold-start and restored-tab results before worker hydration**
27. **Explicit host-exclusion and network-only behavior matrix**
28. **Companion-extension coexistence results**
29. **Fixture negative-control results**
30. **Two clean-room release-sweep reports and artifact hashes**
31. **Final persistent progress-state summary**

Do not claim completion based only on unit tests, generated evidence, or structural release checks. Completion requires observable behavior from the production manifest in Chromium, including cold startup before worker hydration, a release-like profile with developer-only DNR feedback unavailable, explicit-host-exclusion verification, deterministic cross-extension coexistence checks, working negative controls, and two consecutive clean-room packaged sweeps; plus a fully accounted exposed behavior ledger, truthful badge/logger/attribution states, host-access and browser-cache limitation coverage, a truthful compiler/runtime syntax contract, packaged-build parity, clean-build reproducibility, lifecycle resilience, and no remaining Blocker or Major defect within the declared product scope.
