# uBlock Resurrected — Remaining Actual-Behavior Work

## Master execution prompt for a lower-capability coding LLM

Repository:

`Astrocytech/uBlockResurrected`

Current default-branch head observed during the final audit:

`4a7d5ffabb4297597bdca9d63646373b1a2ece41`

Previously inspected advanced development head:

`acfddc4ab967ec19d409172fe9b2acf0162072f5`

These two heads are not on one simple fast-forward line: the observed default branch diverged from the advanced development head and was substantially behind it. Therefore, the first task is to establish the intended repository lineage and recover any completed production work before implementing new changes.

The repository may move after this prompt is created. Before changing code, inspect the current working tree, all relevant local/remote branches, tags, reflogs if available, and recent commits. If a task below is already implemented, do not implement it again. Prove that the behavior works in a real Chromium extension session, record the evidence, and continue to the next task.

---

# 1. Mission

Finish the remaining important work required for uBlock Resurrected to behave like a dependable Chromium MV3 content blocker.

Prioritize what affects users:

- ads and trackers actually being blocked;
- selected filter lists actually being enforced;
- manual filter-list updates actually activating fresher rules;
- user filters and per-site switches surviving restarts;
- sensitive pages receiving the network behavior claimed by the policy system;
- important representable filter syntax working correctly;
- ordinary websites, SPAs, login pages, payment pages, video pages, iframes, and service-worker-controlled sites behaving correctly;
- the packaged release behaving like the development extension.

Do not spend the project on test formatting, assertion rewrites, documentation polishing, release-gate cosmetics, or GitHub automation.

---

# 2. Non-negotiable constraints

## 2.1 Do not touch GitHub Actions

Do not create, modify, delete, rename, or “fix” anything under:

```text
.github/workflows/
```

Do not add a new workflow.

Do not spend time diagnosing GitHub Actions.

All verification in this prompt is local and behavior-focused.

## 2.2 The loaded service worker is canonical

The manifest loads:

```text
platform/chromium/js/sw.js
```

That is the production service worker.

Do not replace it with:

```text
src/js/mv3/sw-entry.ts
platform/chromium/js/sw-entry-bundle.js
```

Those are not the manifest-selected runtime.

## 2.3 Do not rewrite the extension

Do not:

- replace the existing DNR transaction architecture;
- replace the popup;
- replace the cosmetic engine;
- replace the scriptlet pipeline;
- replace IndexedDB persistence;
- replace the current service worker with a new framework;
- perform a broad TypeScript migration;
- rename unrelated files;
- reformat the repository;
- remove existing functional features because they are difficult to understand.

Make focused changes through the current architecture.

## 2.4 Do not hand-edit generated DNR files

Files under:

```text
platform/chromium/dnr/
```

are generated artifacts unless clearly documented otherwise.

Change the compiler or build tool, then regenerate.

Do not manually patch thousands of generated rules.

When generated files change, inspect the change for plausibility. Do not commit timestamp-only or accidental massive output churn unless the source/compiler change genuinely requires it.

## 2.5 Preserve last-known-good browser behavior

Any operation involving filter lists or DNR must be transactional.

A failed operation must not leave users with:

- zero blocking rules;
- half of a new ruleset;
- new static rules combined with old dynamic rules;
- an empty cosmetic generation;
- deleted user filters;
- deleted firewall rules;
- deleted per-site switches;
- a false “updated successfully” timestamp;
- a commit-state record that does not match browser DNR state.

Reuse the existing transaction and rollback facilities.

## 2.6 Defer broad testing until all implementation work is complete

During Phases 0–6, run only:

- syntax checks for files directly changed;
- the smallest build command needed to produce the changed artifact;
- focused tests that exercise the exact code path being changed;
- one direct Chromium fixture proving the changed behavior when browser enforcement is involved.

Do not repeatedly run the full repository test suite after each phase.

Do not:

- repair unrelated historical test failures;
- rewrite broad suites because wording or snapshots are stale;
- modify hundreds of expectations;
- create a new gate for every helper;
- add tests for code that was not changed;
- turn implementation phases into a test-cleanup campaign;
- claim completion because focused tests pass.

The broad independent behavior matrix and full test run happen once, after all implementation phases are complete. A directly related live fixture is not optional when the change affects browser behavior.

## 2.7 Do not chase impossible MV3 parity

Some uBlock Origin behavior cannot be represented in Chrome MV3.

Do not invent unsafe approximations for:

- response-body replacement;
- arbitrary CSP injection where DNR cannot express it;
- arbitrary executable remote code;
- unrestricted MAIN-world code;
- unsupported regular-expression query-parameter removal;
- browser APIs Chrome does not provide.

Implement representable behavior correctly and report unavoidable limitations honestly.

## 2.8 Remote filter data must remain data

Chrome MV3 permits remotely fetched filtering configuration, but the extension package must contain all executable logic.

Remote list handling must never:

- evaluate JavaScript, WebAssembly, or arbitrary command text downloaded from a list server;
- use `eval`, `Function`, dynamic module import, remotely supplied script URLs, or remotely supplied extension paths;
- treat a remote scriptlet body as executable code;
- allow a remote list to select an arbitrary packaged script by path;
- turn complex remotely supplied commands into a general-purpose interpreter.

Remote cosmetic selectors and network rules may be treated as configuration data. Remote scriptlet entries may reference only an explicit allowlist of scriptlets already packaged with the extension, with bounded validated arguments. Unknown scriptlets, redirect tokens, actions, and directives must be counted and ignored.

Validate remote URL schemes, final redirect URLs, response size, content type/shape, and body content. Never persist credentials embedded in a source URL into logs, diagnostics, or exported backups.

## 2.9 Respect all separate DNR quotas and ownership ranges

Do not treat “30,000 dynamic rules” as one unrestricted bucket.

The implementation must account separately for:

- safe dynamic rules;
- unsafe dynamic rules such as redirects and header modification;
- session rules;
- regular-expression rules;
- enabled static rulesets;
- available static-rule count;
- every existing subsystem’s reserved ID range.

Safe dynamic actions are `block`, `allow`, `allowAllRequests`, and `upgradeScheme`. Unsafe dynamic actions have a lower quota and also count toward the total dynamic quota. Capability-detect constants because the manifest currently permits Chrome 120 while the enlarged safe-dynamic quota begins in newer Chrome versions.

Never borrow another subsystem’s DNR IDs. Preserve headroom for user filters, policy/session allows, firewall rules, URL rules, power switches, remote refresh generations, and rollback.

## 2.10 Do not implement on a regressed or superseded repository line

Before editing production code, determine whether the checked-out branch contains the most advanced valid production work.

Do not assume that `main`, the newest timestamp, a version label, or a large squash commit is automatically the correct continuation point.

Required checks:

```bash
git status --short
git branch -avv
git log --graph --decorate --oneline --all --date-order -n 200
git merge-base <candidate-head-A> <candidate-head-B>
git rev-list --left-right --count <candidate-head-A>...<candidate-head-B>
git diff --stat <candidate-head-A>..<candidate-head-B>
```

Also inspect any available:

```text
tags;
release branches;
local unpushed branches;
remote-tracking branches;
reflogs;
stashes;
worktrees;
open pull-request branches;
artifact/progress ledgers that name a tested commit.
```

Choose the continuation base by production behavior and verified work, not by commit-message wording.

If the current branch has lost completed behavior from a more advanced line:

- create a safety branch before changing anything;
- preserve both histories;
- recover/cherry-pick/merge the missing production commits in a reviewable order;
- resolve generated-artifact conflicts by rebuilding from source;
- do not silently overwrite the advanced line with the regressed line;
- do not resurrect or modify GitHub workflow changes merely because they are present in one branch;
- record the chosen base commit and why it is authoritative.

If histories contain conflicting implementations of the same feature, compare actual browser behavior and retain the safer, more complete implementation. Do not combine two competing state authorities.

No implementation phase may begin until repository lineage is resolved and the chosen base includes all valid completed work.

## 2.11 Security, privacy, legal, and user trust are completion requirements

The project is not complete merely because blocking works.

Before release it must also have:

- a minimal and justified permission surface;
- explicit incognito behavior with no regular/incognito data leakage;
- hardened extension-page, content-script, MAIN-world, message, and web-accessible-resource boundaries;
- accurate Chrome Web Store privacy disclosures;
- no hidden telemetry or browsing-history transmission;
- valid third-party licensing and attribution for inherited code, filter lists, redirect resources, libraries, icons, and other packaged assets;
- accessible and localizable user-facing controls;
- a stable release/update identity and migration path.

Do not turn this into a broad documentation project. Fix concrete production, manifest, package, disclosure, and attribution gaps only.

## 2.12 Crash recovery, storage cleanup, and bounded resource use are product behavior

A Chromium MV3 service worker may be suspended between any two awaited operations. A browser or extension update may also interrupt a DNR/static-ruleset transaction.

Do not rely on one in-memory promise, boolean, or operation token as the only recovery mechanism for a multi-step state swap.

For operations that change both browser DNR state and persisted generation/static state:

- retain the last committed state until the new state is verified;
- use a bounded pending-operation journal or another durable reconciliation marker;
- make startup able to detect and recover an interrupted operation;
- prefer browser DNR truth plus the last committed record over an uncommitted candidate;
- never delete the previous generation before the replacement is committed;
- garbage-collect orphaned generations only after determining that no committed or pending state references them.

All persisted rule, cosmetic, scriptlet, cache, source-map, and IndexedDB generations must have explicit size/count bounds and lifecycle cleanup. Repeated updates, failed updates, list selection changes, restores, and schema upgrades must not cause unbounded storage or memory growth.

Do not add a broad performance test campaign during implementation. For code that processes large lists or generations, add only a directly related boundedness check or measurement proving that the changed path does not load or retain the entire catalog unnecessarily.

---

# 3. Current architecture facts to preserve

Before editing, read these files:

```text
platform/chromium/manifest.json
platform/chromium/manifest.release.json
platform/chromium/js/sw.js
platform/chromium/js/filter-list-runtime-core.js
platform/chromium/js/filter-list-streaming.js
platform/chromium/js/filter-list-dnr-transaction.js
platform/chromium/js/filter-list-refresh-overlay.js
platform/chromium/js/filter-list-selection-core.js
platform/chromium/js/filter-overflow-index.js
platform/chromium/js/filter-overflow-runtime-core.js
platform/chromium/js/filter-overflow-work-queue.js
platform/chromium/js/static-ruleset-planner.js
platform/chromium/js/custom-cosmetic-index.js
platform/chromium/js/cosmetic-artifact-runtime.js
platform/chromium/js/policy-resolver.js
platform/chromium/js/page-signal-classifier.js
platform/chromium/js/policy-snapshot.js
platform/chromium/config/page-policy.json
platform/chromium/assets/assets.json
platform/chromium/dnr/runtime-ruleset-registry.json
src/core/compiler/filter-classifier.ts
src/core/compiler/safe-network-rule-compiler.ts
src/core/compiler/static-ruleset-compiler.ts
src/core/compiler/unsupported-syntax-report.ts
src/js/3p-filters.ts
docs/mv3-filter-syntax-coverage.md
```

Important current design:

1. Stock network lists are primarily precompiled into packaged static DNR rulesets.
2. Chrome may not allow all packaged static rulesets to be enabled simultaneously.
3. The runtime has a separate dynamic-rule budget.
4. User filters and runtime/imported lists use the dynamic-rule transaction path.
5. Overflow rules are stored in IndexedDB and activated into session rules.
6. Cosmetic and scriptlet data have separate artifact/runtime pipelines.
7. The popup and dashboard communicate with the canonical service worker.
8. The policy resolver can return `network: "off"` for trusted, authentication-sensitive, and payment-sensitive pages.
9. The existing page power switch already has DNR allow-rule machinery. Reuse its concepts rather than inventing a second incompatible system.
10. Current head `acfddc4a` added `filter-list-refresh-overlay.js` and a user-triggered remote-fetch path. That implementation is additive: it can add remotely discovered rules but intentionally leaves packaged rules active when the remote list removes or changes them. Treat it as partial work to audit and correct, not as completed update semantics.
11. The default policy fallback is `app-shell`; ordinary non-article pages without known support can therefore remain in a reduced cosmetic/scriptlet profile. This must be audited as a real under-filtering risk.
12. Every user-visible list or switch must map to actual runtime behavior. A selectable list that has neither a static ruleset nor a usable runtime asset is a product defect, not merely a catalog issue.
13. Static, dynamic, and session DNR quotas are distinct. Unsafe dynamic actions and regex rules have lower independent limits.
14. The release must keep remote lists declarative. Only packaged, allowlisted scriptlets and redirect resources may be referenced by remotely fetched data.
15. The repository exposes more user surfaces than the popup list alone: manifest commands, context-menu actions, dashboard panes, cloud/privacy controls, trusted-site state, logger attribution, picker/zapper, backup/restore, managed settings, and possibly custom new-tab or strict-block pages. Enumerate actual current surfaces from the manifest, HTML/JS entry points, message handlers, and storage settings rather than assuming the examples in this prompt are exhaustive.
16. Remote replacement, static complement, overflow, cosmetic, and scriptlet generations are derived state. They need crash reconciliation and orphan cleanup; they must not be treated as irreplaceable user data.
17. A complete syntax audit must be generated from current compiler classifications and real list sources. The four known modifiers in Phase 5 are mandatory review points, not the complete universe of remaining representable syntax.
18. The current manifest requests broad host access and multiple sensitive APIs. Every permission and every web-accessible resource must map to active shipped behavior. Development-only permissions must not leak into the store package.
19. Incognito mode is a separate privacy boundary. The extension must deliberately choose `spanning`, `split`, or `not_allowed`; relying on an accidental default is not acceptable for a blocker that handles URLs, request metadata, logs, rules, and site state.
20. Hard-coded excluded sites, compatibility exceptions, domain allowlists, and browser-version branches are product policy. Each must have an owner, reason, scope, expiry/review rule where appropriate, and truthful UI behavior.
21. The extension must coexist with pages and other extensions: it may not assume sole ownership of MAIN-world globals, wrappers, styles, available DNR capacity, context menus, or browser privacy settings.
22. Third-party code and filter assets carry licenses and attribution obligations. Generated packages must include the required notices/source references and must not claim authorship over upstream work.

---

# 4. Required work order

Execute the phases in this exact order.

Do not run the broad repository test suite or full real-site matrix before Phases 1–6 are complete. During implementation, use only directly related checks and fixtures.

1. Resolve repository lineage and recover the authoritative production base.
2. Establish a truthful runtime baseline and determine which items are already implemented at the recovered current head.
3. Use remaining DNR capacity to cover selected packaged rules that Chrome could not enable, while respecting safe/unsafe/session/regex quotas.
4. Finish manual filter-list refresh semantics, including removals, replacements, imported lists, rollback, and remote-data safety.
5. Connect page policy decisions to real DNR network enforcement.
6. Correct ordinary-page classification so normal websites do not remain permanently under-filtered.
7. Implement the remaining high-impact MV3-representable filter syntax.
8. Eliminate user-visible no-op controls, security/privacy/release-surface gaps, catalog inconsistencies, and state-mutation races.
9. Run one independent final behavior campaign and fix reproducible P0/P1 defects.
10. Perform final release and store-readiness closure.

---

# Phase -1 — Resolve repository lineage and recover the authoritative base

## Goal

Prevent new work from being applied to an older, diverged, or partially reverted branch.

## Required procedure

1. Create immutable safety references for every candidate head.
2. Compare the current default branch to the previously advanced development head and any newer branches.
3. Inventory production files and behavior present on only one side.
4. Identify generated-only changes separately from source changes.
5. Identify workflow/test/documentation-only changes separately from production behavior.
6. Recover all valid production changes onto one continuation branch without discarding either history.
7. Rebuild generated artifacts from the recovered source.
8. Record the authoritative base SHA in the progress ledger and in the final report.

At minimum compare:

```text
4a7d5ffabb4297597bdca9d63646373b1a2ece41
acfddc4ab967ec19d409172fe9b2acf0162072f5
```

Do not assume those remain the latest heads; discover current refs first.

## Conflict rules

When resolving divergent implementations:

- canonical manifest-selected runtime wins over prototype-only code;
- browser-proven behavior wins over documentation claims;
- transactional last-known-good behavior wins over destructive clearing;
- bounded streaming code wins over whole-catalog memory loading;
- packaged executable logic wins over remote executable behavior;
- current user-authored state compatibility wins over schema-reset convenience;
- production behavior changes win over test/gate-only changes;
- do not restore or modify GitHub Actions.

## Directly related verification

Do not run the full suite.

After lineage recovery, run only:

- service-worker syntax;
- the smallest build required to regenerate affected artifacts;
- one load sanity check confirming the manifest-selected worker starts;
- focused checks for any production conflicts actually resolved.

## Definition of done

Phase -1 is complete only when:

- one continuation branch contains all valid advanced production behavior;
- no known completed feature exists only on an abandoned divergent head;
- generated artifacts match recovered source;
- the chosen base SHA and lineage decision are recorded;
- the working tree is clean before Phase 0 begins.

---

# Phase 0 — Establish a truthful baseline

## Goal

Record how the current extension behaves before changing it.

This phase is diagnostic only. Do not begin by editing tests.

## Required inspection

Determine:

- current Git commit;
- whether the working tree is clean;
- manifest-selected service worker;
- development and release manifest permissions;
- currently enabled static rulesets in a clean Chromium profile;
- selected filter lists;
- total packaged rules for each selected stock list;
- actual enabled static-rule count;
- actual dynamic-rule count;
- actual session-rule count;
- current committed filter-list state;
- whether static coverage is complete or partial;
- whether the dashboard Update button performs a remote request;
- whether `autoUpdate` is real or only a UI value;
- whether the auth/payment policy’s `network: "off"` corresponds to installed DNR allow rules;
- current unsupported filter syntax counts from generated reports;
- every required/optional permission and the production call sites that use it;
- every host permission and content-script match/exclusion;
- declared or effective incognito mode and whether access is currently allowed;
- web-accessible-resource exposure and extension CSP;
- externally connectable/message/port/postMessage surfaces;
- hard-coded compatibility/excluded-site rules and their reasons;
- local, session, sync, managed, IndexedDB, logger, and cloud data flows;
- third-party code/filter/resource licenses and packaged attribution files;
- unresolved localization keys and keyboard/accessibility-critical UI defects.

## Minimal commands

Run only useful checks such as:

```bash
git status --short
git rev-parse HEAD
node --check platform/chromium/js/sw.js
npm run build
npm run verify:extension
```

If a broad test suite has unrelated historical failures, record them and continue. Do not spend this phase polishing tests.

## Live baseline script

Use a temporary Chromium profile and load:

```text
platform/chromium/
```

Read extension state from the service worker using Chrome extension APIs.

Record at least:

```js
await chrome.declarativeNetRequest.getEnabledRulesets();
await chrome.declarativeNetRequest.getDynamicRules();
await chrome.declarativeNetRequest.getSessionRules();
await chrome.storage.local.get([
    "selectedFilterLists",
    "filterListCommitState",
    "ubrRemoteFilterOverlay",
]);
```

Do not keep a temporary script in the repository unless it becomes a focused reusable behavior test.

## Definition of done

Phase 0 is done when a concise baseline record exists containing actual browser counts and confirming which tasks below remain.

---

# Phase 1 — Fill static-list coverage gaps with the available dynamic quota

## Why this is required

The extension ships many static DNR shards for EasyList, EasyPrivacy, and uBlock lists.

Chrome may allow only part of those static rules to be enabled. The static planner reports partial coverage and leaves some selected static shards disabled.

At the same time, the dynamic-rule budget can be mostly unused in a default configuration because stock lists are classified as static-backed and skipped by runtime compilation.

This means the extension can possess applicable packaged rules but fail to enforce them despite having unused dynamic capacity.

That is a direct blocking-coverage problem.

## Desired behavior

For selected static-backed lists:

1. Enable as many packaged static rulesets as Chrome permits.
2. Find the selected ruleset shards that could not be enabled.
3. Load rules from those disabled packaged JSON files.
4. Use remaining filter-list dynamic-rule capacity to install a prioritized complement.
5. Never displace user filters with lower-value static-complement rules.
6. Rebuild the complement when list selection or available quota changes.
7. Persist truthful complement metadata in the existing commit state.
8. Restore or validate it after service-worker restart.
9. Keep the previous committed rules if the new complement cannot be installed.

## Quota model that must be implemented first

Before selecting complement candidates, read browser truth and compute separate budgets:

```js
const dnr = chrome.declarativeNetRequest;

const maxDynamic = Number(
    dnr.MAX_NUMBER_OF_DYNAMIC_RULES || 5_000,
);
const maxUnsafeDynamic = Number(
    dnr.MAX_NUMBER_OF_UNSAFE_DYNAMIC_RULES || 5_000,
);
const maxSession = Number(
    dnr.MAX_NUMBER_OF_SESSION_RULES || 5_000,
);
const maxRegex = Number(
    dnr.MAX_NUMBER_OF_REGEX_RULES || 1_000,
);
```

Do not assume the larger safe-dynamic quota exists merely because the source is running on a modern development browser. The release manifest currently permits Chrome 120, so either preserve a correct 5,000-rule fallback or raise the minimum supported Chrome version deliberately and consistently.

Classify every candidate:

```text
safe dynamic:
  block, allow, allowAllRequests, upgradeScheme

unsafe dynamic:
  redirect, modifyHeaders and any other action Chrome does not classify as safe
```

Reserve quota before filling it. At minimum preserve room for:

- existing user-filter rules;
- firewall and URL filtering ownership ranges;
- power-switch and hostname-switch rules;
- remote refreshed stock lists;
- policy-owned session allow rules;
- transaction rollback/readback differences;
- regex-rule limits.

Prefer safe block/allow complement rules. Install unsafe complement rules only when their separate quota has been measured and sufficient headroom remains. Report deferred safe and unsafe counts separately.

## Files to change

Expected primary files:

```text
platform/chromium/js/sw.js
platform/chromium/js/static-ruleset-planner.js
platform/chromium/js/filter-list-runtime-core.js
platform/chromium/js/filter-list-dnr-transaction.js
platform/chromium/js/filter-overflow-runtime-core.js
platform/chromium/dnr/runtime-ruleset-registry.json
```

Change compiler/build files only if metadata required by the runtime is missing:

```text
tools/build-static-rulesets.mjs
src/core/compiler/static-ruleset-compiler.ts
```

## Implementation steps

### 1. Expose exact unavailable selected rulesets

`syncStaticRulesets()` already has planning data such as:

- requested ruleset IDs;
- active ruleset IDs;
- unavailable ruleset IDs;
- over-budget ruleset IDs;
- per-list coverage.

Return and preserve enough information for the dynamic complement.

Do not recompute a different plan elsewhere.

Suggested result fields:

```js
{
    ok: true,
    status: "complete" | "partial",
    requestedRulesetIds: [],
    activeRulesetIds: [],
    unavailableRulesetIds: [],
    coverage: {},
}
```

### 2. Resolve ruleset IDs to packaged files

Use:

```js
chrome.runtime.getManifest()
    .declarative_net_request
    .rule_resources
```

Build one map:

```js
function buildRulesetPathMap() {
    const entries =
        chrome.runtime.getManifest()
            .declarative_net_request
            ?.rule_resources || [];

    return new Map(
        entries.map(entry => [
            entry.id,
            entry.path,
        ]),
    );
}
```

### 3. Stream or bounded-load disabled packaged shards

Do not load every disabled shard into memory simultaneously.

A static shard is usually at most about 5,000 rules, but there can be many shards.

Process one shard at a time.

Validate every rule object before considering it.

Required fields:

```js
{
    action: object,
    condition: object,
    priority?: number
}
```

Ignore the packaged ID and assign a dynamic owned ID only during final installation.

### 4. Deduplicate against active static and dynamic rules

Use:

```js
dnrRuleFingerprint(rule)
```

from:

```text
platform/chromium/js/filter-overflow-runtime-core.js
```

Do not invent another fingerprint format.

Build fingerprints for:

- rules in currently active static shards;
- user/runtime dynamic candidates already retained;
- static-complement candidates already retained.

Do not install a dynamic duplicate of a rule already enforced statically.

### 5. Use one explicit quota priority policy

The final dynamic quota order must be:

1. user filters;
2. explicit user-created dynamic firewall/URL behavior where it shares relevant capacity;
3. full remote Quick Fixes replacement generation from Phase 2;
4. explicitly user-imported/custom list generations;
5. other full remote uBlock replacement generations from Phase 2;
6. packaged uBlock complement rules;
7. EasyPrivacy complement;
8. EasyList complement;
9. low-value deferred fallback candidates.

Do not let source-file order decide which rules survive.

Suggested scoring components:

```js
function sourceClassScore(source) {
    switch (source.kind) {
    case "user-filter":
        return 10_000_000;
    case "remote-quick-fixes":
        return 9_000_000;
    case "runtime-imported":
        return 8_500_000;
    case "remote-ublock":
        return 8_000_000;
    case "packaged-ublock-complement":
        return 7_000_000;
    case "packaged-easyprivacy-complement":
        return 6_000_000;
    case "packaged-easylist-complement":
        return 5_000_000;
    default:
        return 0;
    }
}
```

Add existing rule priority and domain-importance scoring only to the candidate-retention score. Do not rewrite the rule’s actual DNR `priority`; that priority carries allow/block/redirect semantics and must remain compiler-defined.

A list operating in Phase 2 `runtime-replacement` mode must not also receive a Phase 1 packaged complement. Its packaged rulesets are intentionally disabled and its complete runtime generation owns that list.

Use round-robin selection across lists or shards when scores are equal so one giant list cannot consume the whole budget merely because it was read first.

### 6. Integrate with the existing DNR transaction

Do not install complement rules in a separate uncontrolled call.

The final filter-list dynamic rule set must be installed through the existing filter-list transaction.

The transaction must see one complete candidate state containing:

- user/runtime rules;
- committed remote replacement-generation rules;
- static complement rules for packaged-mode lists only.

On transaction failure:

- retain previous dynamic rules;
- retain previous static selection when necessary;
- retain previous commit state;
- delete pending generation data;
- do not enter empty allow mode when rollback succeeds.

### 7. Persist truthful commit metadata

Add fields similar to:

```js
{
    staticStatus: "partial",
    activeStaticRulesets: [],
    unavailableStaticRulesets: [],
    staticComplementRuleCount: 0,
    staticComplementSources: {
        easylist: 0,
        easyprivacy: 0,
        "ublock-filters": 0
    }
}
```

If the commit-state schema changes, increment:

```js
CURRENT_DNR_SCHEMA_VERSION
```

The schema upgrade may clear filter-list-owned DNR and generated indexes, but it must not delete user settings, user filters, whitelist, firewall rules, or hostname switches.

### 8. Avoid startup recompilation loops

Restart validation must accept a committed partial-static-plus-dynamic-complement state when browser DNR truth matches the committed state.

Do not trigger a full recompilation on every service-worker wake.

## Focused live proof

Create a deterministic fixture that selects a rule known to exist in a packaged static shard that is not enabled under the simulated static budget.

Verification:

1. Start with a clean profile.
2. Force or simulate a limited static budget.
3. Confirm the shard containing the probe is unavailable statically.
4. Confirm the probe rule is selected into the dynamic complement.
5. Load a page requesting the probe resource.
6. Confirm `net::ERR_BLOCKED_BY_CLIENT`.
7. Restart the extension service worker.
8. Confirm the probe remains blocked.
9. Add enough user filters to consume part of the dynamic quota.
10. Confirm user filters survive and lower-priority complement rules yield first.
11. Deselect the source list.
12. Confirm its complement rules are removed.

## Definition of done

Phase 1 is complete only when:

- the default selected stock lists use available dynamic capacity beyond the enabled static budget;
- an omitted static-shard probe is actually blocked;
- user filters outrank complement rules;
- list deselection removes its complement;
- restart does not erase it;
- browser-reported counts match committed counts;
- no unrelated DNR ownership range is modified.

---

# Phase 2 — Finish real filter-list refresh semantics

## Current-head warning

Current head `acfddc4a` already adds:

```text
platform/chromium/js/filter-list-refresh-overlay.js
```

and modifies the dashboard update path in `sw.js`.

Do not create a second refresh subsystem.

Audit that implementation first. Its documented behavior is strictly additive: a packaged filter removed upstream remains active until the next extension release. That is not a complete update for a small stock list and must not be reported as one.

## Required semantic model

Use two truthful list classes.

### Class A — Runtime-replaceable lists

These include:

- `ublock-quick-fixes`;
- other small uBlock stock lists whose complete supported behavior fits within measured dynamic and unsafe quotas;
- imported/custom remote lists;
- any other list already owned entirely by the runtime compiler.

A successful refresh of a Class A list must replace the previously active generation for that list. It must support:

- newly added rules;
- removed rules;
- modified rules;
- newly added and removed cosmetic entries;
- scriptlet additions, removals, and exceptions using packaged allowlisted scriptlets only;
- redirect changes using packaged allowlisted redirect resources only.

### Class B — Packaged-only large lists

EasyList and EasyPrivacy may remain packaged-static when a complete runtime replacement cannot fit safely.

For Class B lists:

- do not download a huge list merely to discard most of it;
- do not claim it was fully updated;
- report `sourceMode: "packaged-static"` and `runtimeRefreshSupported: false`;
- update them through an extension package/static-ruleset release;
- keep their packaged cosmetics and network artifacts internally consistent.

The UI must distinguish “packaged list” from “runtime-refreshable list.”

## Full replacement for small static-backed stock lists

For an eligible Class A stock list, do not leave the packaged ruleset active forever underneath an additive overlay.

Required strategy:

1. Resolve all packaged ruleset IDs belonging to the list.
2. Fetch the remote list only because the user initiated an update.
3. Stream and compile the complete remote list through the existing bounded parser.
4. Confirm that every currently supported packaged behavior needed by the list can be represented by the runtime compiler.
5. Build a pending full replacement generation containing network, cosmetic, and scriptlet state.
6. Preserve all other lists and user-owned rules.
7. Install the new dynamic generation while the packaged baseline still protects the user whenever quota permits.
8. Disable only that list’s packaged ruleset IDs after the replacement generation is installed and browser readback succeeds.
9. Verify the packaged rulesets are disabled and the replacement generation is active.
10. Commit the new list generation and filter-list commit state.
11. Delete the previous list generation only after commit.

If duplicate temporary installation cannot fit, use a guarded swap:

1. retain a complete snapshot of previous dynamic rules and enabled static rulesets;
2. keep the packaged baseline active while removing only the old runtime generation;
3. install and verify the new runtime generation;
4. disable the packaged rulesets;
5. on any failure, re-enable the packaged rulesets and restore the previous runtime snapshot before returning.

Never leave both the packaged ruleset disabled and the replacement generation absent.

## Runtime compiler parity gate

Do not disable a packaged list’s ruleset if the runtime compiler would silently lose meaningful rules.

For each refreshable stock list, compare:

- packaged source-map entries;
- packaged compiled DNR fingerprints;
- remote compilation results;
- unsupported recognized lines;
- cosmetic/scriptlet counts.

If the current runtime parser lacks a static-compiler feature that is materially used by the list:

1. add that safe representable feature to the shared/runtime compiler; or
2. keep the list packaged-only and report that runtime refresh is unsupported.

Do not call a partial additive delta a full update.

Also audit list preprocessing parity. A runtime replacement must not be committed if the remote source relies on directives that the runtime path does not reproduce, including where present:

```text
!#include
!#if
!#else
!#endif
list-specific preprocessing/macros
```

Use an already flattened authoritative endpoint when one is packaged in the catalog, or implement a narrow bounded preprocessor with the same semantics. Do not follow arbitrary nested include URLs from remote content. Any permitted stock-list include must resolve only through packaged source metadata and an explicit origin/path allowlist. Imported-list includes must remain unsupported unless the user explicitly configured every source and the implementation is bounded and non-recursive.

## Fetch modes

Keep explicit source modes:

```js
const FILTER_FETCH_MODE = Object.freeze({
    PACKAGED_FIRST: "packaged-first",
    REMOTE_REQUIRED: "remote-required",
});
```

Use:

```text
startup, service-worker wake, ordinary rebuild:
  PACKAGED_FIRST, with no unexpected remote request

manual update:
  REMOTE_REQUIRED
```

A manual update must not silently fall back to the packaged file and return success.

## Remote request safety

Accept only explicit `http:` or `https:` source URLs.

For stock lists, the initial URL must come from packaged catalog metadata, not from a remotely downloaded catalog or list directive. Maintain an explicit allowed-origin policy for each stock list. After redirects, validate the final URL again and require it to remain on an allowed HTTPS origin unless a deliberate packaged migration rule permits otherwise.

For imported lists, use only the URL explicitly stored from the user’s configuration. Do not let downloaded content rewrite its own future source URL.

After redirects, validate the final URL again.

Reject:

- `file:`, `data:`, `blob:`, `javascript:`, `chrome:`, and `chrome-extension:` sources;
- URLs containing credentials for stock lists;
- non-success HTTP responses except `304 Not Modified`;
- bodies exceeding existing streaming bounds;
- clearly HTML login/error pages;
- empty or comment-only bodies;
- content that attempts to supply executable JavaScript or arbitrary packaged paths.

A `304 Not Modified` response is an unchanged successful check. Preserve the active generation and do not rebuild DNR unnecessarily.

Conditional requests may use persisted `ETag` and `Last-Modified` values. Persist only bounded metadata and never leak credential-bearing URLs into logs or backup exports.

## Remote content must remain declarative

Network and cosmetic filters are data.

Scriptlet filters from a remote list may only select a scriptlet name in the extension’s packaged allowlist. Validate and bound every argument. Unknown scriptlets are unsupported, not executable text.

Because Manifest V3 store policy also prohibits turning remotely fetched “data” into a general-purpose command interpreter, perform a narrow compliance review of the scriptlet grammar. If the remote directive can choose complex behavior that is not clearly fixed and discernible from packaged code, keep remote scriptlet updates disabled and use packaged scriptlet artifacts only. Do not risk store compliance merely to claim live scriptlet updating.

Redirect rules may only select a packaged redirect token already present in the extension catalog and declared as a web-accessible resource where required.

Never execute code downloaded from a filter server.

## Per-list generation persistence

Do not model the entire remote state as one all-or-nothing object that can accidentally erase untouched lists during a single-list refresh.

Persist a generation per list, or use one record with explicit immutable per-list entries and merge semantics.

Suggested logical shape:

```js
{
    schemaVersion: 2,
    committedAt: 0,
    lists: {
        "ublock-quick-fixes": {
            generation: "uuid",
            compilerSchemaVersion: 1,
            extensionVersion: "",
            mode: "runtime-replacement",
            sourceURL: "",
            finalURL: "",
            etag: null,
            lastModified: null,
            fetchedAt: 0,
            checkedAt: 0,
            networkRules: [],
            unsafeRuleCount: 0,
            safeRuleCount: 0,
            regexRuleCount: 0,
            customCosmeticGeneration: null,
            unsupportedCount: 0,
            disabledPackagedRulesetIds: []
        }
    }
}
```

Validate stored records before use and bound all arrays and serialized size.

A per-list update must:

- retain entries for untouched lists;
- retain the old entry for a failed list;
- replace only successful targeted entries;
- avoid advancing `fetchedAt` on failure;
- allow `checkedAt` to advance for a valid `304` check;
- preserve disabled/enabled static state consistently with the committed generation.

## Extension-update and schema reconciliation

Dynamic rules persist across browser sessions and extension upgrades, while enabled static-ruleset choices may be reset by an extension update. This creates a specific mixed-state risk.

On `runtime.onInstalled` with reason `update`, and on every startup reconciliation:

1. read the committed per-list generation;
2. compare its compiler schema and extension compatibility version;
3. inspect actual dynamic rules and enabled static rulesets;
4. for a compatible runtime replacement, re-disable that list’s packaged rulesets if Chrome re-enabled them;
5. for an incompatible or corrupt replacement, re-enable the packaged baseline first, remove the stale runtime generation second, and rebuild commit state;
6. never retain an old dynamic generation under a newly changed compiler/schema without validation;
7. never leave both stale packaged and stale dynamic behavior active while reporting a fresh state.

A new extension package may contain newer static Quick Fixes than the saved remote generation. Define a deterministic precedence policy and expose it in state. A safe default is:

```text
incompatible generation:
  packaged baseline wins

compatible generation with newer successful fetchedAt than packaged build metadata:
  committed runtime replacement wins
```

Do not compare timestamps from unrelated clocks without stable packaged build metadata.

## Imported/custom lists

Imported lists are Class A runtime lists.

A successful refresh must fully replace the prior imported-list generation, including removals.

If the source is temporarily unavailable, retain the previous list behavior.

Deleting or deselecting an imported list must remove:

- its dynamic DNR rules;
- its overflow/index entries;
- its cosmetic/scriptlet generation;
- its cache metadata;
- its list-specific commit-state entry.

Do not fetch an imported list at startup unless existing product settings explicitly promise automatic updating and the user enabled it.

## Purge, reload, update, and auto-update semantics

### Reload all filters

- performs no remote request;
- rebuilds from the committed packaged/runtime generations;
- does not advance remote freshness timestamps;
- does not erase a successful remote replacement.

### Update now

- refreshes all selected Class A lists;
- waits for all targeted results and the final transaction;
- serializes against list selection, My Filters saves, and another update;
- returns a truthful per-list summary.

### Update selected

- refreshes only requested Class A keys;
- merges successful per-list generations;
- leaves untouched and failed entries unchanged.

### Purge

Purge must not immediately remove active last-known-good blocking.

It may clear download metadata or mark a list obsolete, but active rules stay until:

- a replacement successfully commits;
- the user disables/deletes the list; or
- the user explicitly chooses a destructive reset and receives a clear warning.

### Auto-update

This project does not require automatic background updating.

If no real bounded scheduler exists, hide or disable the Auto-update control and report manual updates only. Do not store `autoUpdate: true` while doing nothing.

If automatic updating is retained, it must use the same transaction, conditional requests, last-known-good behavior, remote-data restrictions, and no-more-than-necessary cadence as manual updating.

## Concurrency and stale completion

Use the existing queue/operation-token architecture.

The following operations must not race:

- manual update;
- per-list update;
- list selection change;
- My Filters save;
- imported-list edit;
- service-worker startup reconciliation;
- managed-policy list changes;
- reset/restore.

A slower old update must not overwrite a newer selection or generation.

Before commit, re-check the operation token, selected-list revision, and relevant generation IDs.

## Messaging authorization

Only extension-owned dashboard/options pages may trigger privileged refresh, purge, reset, or imported-list mutation messages.

A normal content script or arbitrary webpage must not be able to cause remote downloads, mutate filter-list selection, install rules, or purge list state through either `runtime.sendMessage` or a connected port.

Reuse the existing sender/channel authorization.

## Directly related verification only

During implementation, do not run the full suite. Add or run only the focused refresh tests and one local Chromium fixture.

The fixture must prove both additions and removals:

1. Start with a remote list containing rule A and cosmetic A.
2. Refresh through the real dashboard message.
3. Confirm rule A blocks and cosmetic A hides.
4. Change the remote list so rule A and cosmetic A are removed and rule B/cosmetic B are added.
5. Refresh again.
6. Confirm A no longer applies and B now applies.
7. Confirm the small list’s packaged ruleset is disabled only after the replacement is active.
8. Serve `304`; confirm unchanged success without churn.
9. Serve HTTP 500, empty content, oversized content, and HTML; confirm last-good behavior remains.
10. Refresh one list; confirm other list generations are unchanged.
11. Edit My Filters and restart the service worker; confirm the replacement survives.
12. Deselect the list; confirm its runtime generation is removed and packaged ruleset state follows the chosen deselection semantics.
13. Reselect without a new download; confirm the committed replacement or packaged fallback activates consistently.
14. Confirm startup performs no remote request.
15. Confirm a content-script sender cannot trigger refresh.
16. Simulate an extension update where static rulesets return to manifest defaults; confirm startup either restores the compatible runtime replacement or safely falls back to packaged behavior.

## Definition of done

Phase 2 is complete only when:

- Class A updates apply additions, removals, and modifications;
- small stock lists no longer remain under an always-active stale packaged baseline after a successful full refresh;
- failed swaps restore or retain the last-known-good state;
- targeted refreshes cannot erase unrelated list generations;
- imported lists are fully replaceable;
- EasyList/EasyPrivacy are truthfully identified as packaged-only unless a safe complete design is implemented;
- safe, unsafe, regex, and total quotas are respected;
- remote content cannot introduce executable logic;
- timestamps and update summaries are truthful;
- no unexpected startup download occurs;
- no unauthorized sender can invoke update state changes.

---

# Phase 3 — Connect page policy to actual DNR network enforcement

## Why this is required

The policy system can return:

```text
network: "off"
```

for:

- trusted pages;
- authentication-sensitive pages;
- payment-sensitive pages.

DNR rules are browser-global unless explicitly scoped.

A policy object saying “network off” is not enough. Existing static, dynamic, firewall, URL, surrogate, and other DNR rules continue to enforce unless high-priority allow rules actually neutralize them for the intended tab/page.

The policy system must never claim a network mode that is not enforced.

## Existing code to reuse

Inspect and reuse:

- `makeNetFilterAllowRules()`;
- `syncNetFilteringDnrRules()`;
- permanent and session net-filtering state;
- page-scoped net-filtering state;
- tab-scoped session rules;
- policy snapshots;
- `getPageActivation`;
- navigation and tab cleanup;
- dedicated DNR rule-ID ranges;
- `AllowRuleAuthority`, if applicable.

Do not create incompatible allow-rule semantics.

## Desired behavior

When the resolved policy requires network off:

1. Install high-priority, tab-scoped session allow rules.
2. Allow the current sensitive page’s subresources.
3. Avoid globally disabling filtering for every page on that hostname.
4. Remove the automatic allow rules when the tab navigates to a non-sensitive page.
5. Remove them when the tab closes.
6. Restore/reconcile them after service-worker restart when the browser still has the tab.
7. Ensure the policy response reports enforcement truthfully.
8. Preserve explicit trusted-site and user power-switch behavior.

## Decide and enforce the intended sensitive-page privacy mode

Do not blindly install a broad allow rule merely because the JSON currently says `network: "off"`.

Audit the intended product behavior and choose one truthful model:

```text
Model A — true network off:
  install tab-scoped allow enforcement and accept that third-party resources,
  including trackers, may load on that sensitive page.

Model B — safe sensitive mode:
  change the profile to a precisely defined safe/first-party model and enforce
  only the permitted subset through scoped rules.
```

Do not keep `network: "off"` in diagnostics while actually applying ordinary blocking. Do not silently allow all third-party tracking if the intended product promise is merely “avoid breaking authentication/payment.”

Whichever model is chosen must be represented consistently in:

- `page-policy.json`;
- `resolvePagePolicy()`;
- DNR rule installation;
- activation responses;
- popup/logger diagnostics;
- focused fixtures.

## Dedicated automatic-policy rule range

Allocate a dedicated range through the repository’s ID authority if possible.

Example only:

```js
const POLICY_ALLOW_RULE_MIN =
    9_300_000;
const POLICY_ALLOW_RULE_MAX =
    9_349_999;
const POLICY_ALLOW_PRIORITY =
    3_000_000;
```

Do not overlap another ownership range.

Add an ownership predicate:

```js
function isPolicyAllowRuleId(id) {
    return (
        Number.isInteger(id) &&
        id >= POLICY_ALLOW_RULE_MIN &&
        id <= POLICY_ALLOW_RULE_MAX
    );
}
```

## Rule shape

Use tab-scoped rules.

A practical pair is:

1. `allowAllRequests` for main-frame/sub-frame navigation where valid.
2. `allow` for all subresource types in the current tab.

Example concept:

```js
function makePolicyTabAllowRules(
    tabId,
    hostname,
) {
    return [
        {
            action: {
                type: "allowAllRequests",
            },
            condition: {
                tabIds: [tabId],
                requestDomains: [hostname],
                resourceTypes: [
                    "main_frame",
                    "sub_frame",
                ],
            },
        },
        {
            action: {
                type: "allow",
            },
            condition: {
                tabIds: [tabId],
                initiatorDomains: [hostname],
                resourceTypes:
                    SUBRESOURCE_TYPES,
            },
        },
    ];
}
```

Validate actual Chrome DNR requirements against the extension’s existing working allow-rule code.

Do not blindly copy this shape if the current API contract requires a different condition.

## Classification timing

Authentication/payment classification may occur after document start because the DOM signals are discovered by the content script.

Therefore:

- install/update automatic policy rules as part of `getPageActivation` before returning the final activation response;
- install URL-evident sensitive-page rules before navigation where safely detectable;
- use conservative URL-path signals only when strongly indicative, such as exact login/auth/checkout/payment paths;
- do not globally whitelist a whole domain because one page contains a form;
- do not claim enforcement existed before it did.

Add a truthful field to the returned policy/activation diagnostics:

```js
networkEnforcement: {
    requestedMode: "off",
    active: true,
    source: "policy-tab-allow",
}
```

If rule installation fails:

- return `active: false`;
- do not report effective network off;
- fall back to a truthful safe/full policy mode;
- record the error in runtime health.

## Policy-state storage

Keep a map such as:

```js
Map<tabId, {
    hostname,
    profileId,
    ruleIds,
    documentId,
    revision
}>
```

Persist only what is needed to reconcile service-worker restarts, preferably in `chrome.storage.session`.

Do not persist stale automatic auth/payment decisions permanently.

## Navigation cleanup

On:

- `webNavigation.onBeforeNavigate`;
- `webNavigation.onCommitted`;
- `webNavigation.onHistoryStateUpdated`;
- `tabs.onRemoved`;

remove or replace policy-owned allow rules as appropriate.

Use tab URL/document identity checks to avoid removing a newer decision because an older async task finished late.

## User intent and precedence

Preserve these precedence rules:

1. Enterprise managed filtering-disabled policy wins globally.
2. Explicit trusted/power-off state remains off.
3. Automatic auth/payment safety applies per tab.
4. Ordinary pages continue normal filtering.
5. A policy allow rule must not leak to another tab or hostname.
6. Navigating from sensitive to ordinary content on the same domain must restore normal blocking.

If the existing product design provides a deliberate user override for automatic safety, preserve it. Do not invent a hidden override.

## Live fixture

Use one local origin with three routes:

```text
/ordinary
/login
/checkout
```

All routes request the same tracker-like resource.

Expected:

- `/ordinary`: resource blocked;
- `/login`: auth signal detected, policy allow active, resource allowed after enforcement;
- `/checkout`: payment signal detected, policy allow active, resource allowed after enforcement;
- navigate from `/login` back to `/ordinary`: resource blocked again;
- second tab on `/ordinary` remains blocked while first tab is on `/login`;
- service-worker restart does not leave the sensitive tab in a falsely reported state;
- closing the tab removes its rules.

Also verify that cosmetic/scriptlet/video restrictions from the profile continue to behave as designed.

## Definition of done

Phase 3 is done only when:

- every reported effective `network: "off"` policy has corresponding browser DNR enforcement;
- policy allow rules are tab-scoped;
- ordinary pages on the same hostname remain filtered;
- navigation and tab cleanup work;
- failure is reported truthfully;
- no stale allow rule survives and disables unrelated blocking.

---

# Phase 4 — Correct ordinary-page classification and filtering activation

## Why this is required

The current policy resolver uses `app-shell` as the default profile.

The classifier promotes a page to `default-web` when there is positive evidence such as:

- article signals;
- known filter support;
- established matched domains.

An ordinary website that is not classified as an article, auth page, payment page, video page, or known app can therefore remain in `app-shell`, where generic and procedural cosmetics are reduced or disabled.

This can cause broad under-filtering on search pages, forums, directories, ecommerce category pages, simple static websites, and other normal pages.

## Required classification model

Classification must be evidence-based in both directions.

Use positive signals for special reduced profiles:

```text
auth-sensitive:
  actual authentication/password/login form signals

payment-sensitive:
  actual payment/card/checkout signals

video-site:
  a primary video/player signal

app-shell:
  strong SPA/application signals such as a large app root, sustained route
  mutation, content editing, or other explicit complex-app evidence
```

After DOM signals are available, a normal page with no special-profile evidence must become `default-web`, not remain `app-shell` merely because it is not an article.

Do not make LinkedIn or any other single hardcoded domain the effective definition of ordinary web filtering.

## Two-stage activation

At `document_start`, before DOM evidence exists, a conservative temporary policy is acceptable.

After the first reliable signal collection:

1. classify the page;
2. obtain a new policy revision/document token;
3. promote an ordinary page to `default-web`;
4. activate generic/procedural cosmetics and other permitted runtimes;
5. reconcile any temporary CSS or observers;
6. ensure stale initial-policy work cannot overwrite the final policy.

Do not wait indefinitely for `DOMContentLoaded` on pages where the content script can establish ordinary-page status earlier.

Do not inject candidate-wide procedural prehide CSS while waiting.

## Special transitions

Handle transitions explicitly:

- ordinary product/category page → checkout/payment route;
- login route → ordinary account/home route;
- ordinary page → SPA route after history navigation;
- video route → ordinary route;
- bfcache restore;
- same-document history navigation;
- dynamically inserted password/payment form.

A later sensitive signal may reduce capabilities for the current document/tab. A stale sensitive classification must not persist after navigation to ordinary content.

## Files to inspect/change

Expected:

```text
platform/chromium/js/page-signal-classifier.js
platform/chromium/js/policy-resolver.js
platform/chromium/config/page-policy.json
platform/chromium/js/policy-snapshot.js
platform/chromium/js/sw.js
src/js/contentscript/contentscript-entry.ts
platform/chromium/js/contentscript.js
```

Edit the canonical generated/manual source path actually loaded by the manifest; do not fix only a prototype source that is not packaged.

## Directly related fixture

Use one local origin with routes:

```text
/plain
/article
/app
/login
/checkout
/video
```

`/plain` must deliberately avoid an article signal and include:

- one generic cosmetic target;
- one specific cosmetic target;
- one procedural target;
- one allowed control element.

Prove:

1. `/plain` ends as `default-web` and hides the intended generic/specific/procedural targets.
2. `/app` remains `app-shell` because of positive app evidence, not because it is unknown.
3. `/login` and `/checkout` receive their intended sensitive policy and matching DNR enforcement from Phase 3.
4. `/article` and `/video` receive their intended profiles.
5. route transitions update the policy without stale work or observer leaks.
6. the control element remains visible and functional.

Do not run unrelated suites.

## Definition of done

Phase 4 is complete only when:

- ordinary non-article pages no longer default permanently to reduced app-shell filtering;
- special profiles require positive evidence;
- initial conservative activation promotes correctly;
- SPA/auth/payment/video transitions are reversible and document-scoped;
- generic/procedural cosmetics work on a plain ordinary fixture without over-hiding.

---

# Phase 5 — Implement remaining high-impact MV3-representable syntax

## Goal

Close important syntax holes that Chrome DNR can represent.

Do not attempt every obscure uBO feature.

Use actual frequency in current selected stock lists and generated unsupported reports to prioritize work.

## First step — Generate a complete syntax-gap inventory

Do not assume the remaining work is limited to four modifiers.

From current raw list sources, generated source maps, unsupported reports, the static compiler, the runtime/user-filter compiler, cosmetic/scriptlet classifiers, and preprocessing path, produce one deduplicated inventory grouped by actual behavior lane:

```text
network filters;
document/navigation exceptions;
redirect/removeparam/header/cookie actions;
resource/domain/method constraints;
regex URL filters;
cosmetic filters and cosmetic exceptions;
procedural cosmetics;
scriptlets and scriptlet exceptions;
preprocessor/include directives;
invalid syntax;
recognized but impossible MV3 behavior.
```

For every unsupported or partial token/reason, record:

- normalized syntax/modifier;
- count in default selected stock lists;
- count in optional stock lists;
- count in refreshable small lists;
- count in imported/runtime lists where measurable;
- whether the static compiler supports it;
- whether the runtime/My Filters compiler supports it;
- whether Chromium DNR or the existing DOM/scriptlet runtime can represent it safely;
- required Chrome version/API;
- safe/unsafe/regex quota impact;
- current user-visible behavior when encountered;
- decision: implement, keep packaged-only, or explicitly unsupported.

At minimum audit these known gaps:

```text
$document / $doc
$redirect-rule
$cookie
$header
regex network filters
request-method constraints
upgrade-scheme-capable rules
document cosmetic exceptions such as generichide/specifichide/elemhide
preprocessor/include directives
any option responsible for a material share of current unsupported selected-list lines
```

Do not count ordinary cosmetic or scriptlet lines as missing DNR network coverage when they are correctly handled by their own runtime lane.

Implement every high-impact, safely representable gap that materially affects the default selected lists or claimed My Filters behavior. A practical prioritization trigger is either:

- at least 100 occurrences in selected stock sources;
- at least 0.1% of a selected list’s meaningful lines;
- required for correct semantics of a default list;
- directly exposed as supported in the UI/README/docs.

A lower-frequency item may remain unsupported only when the report records the exact reason and the extension does not silently claim it worked.

## Mandatory item A — Document exceptions

Support important exception forms such as:

```text
@@||example.com^$document
@@||example.com^$doc
```

Expected DNR behavior:

- compile to an `allowAllRequests` action when representable;
- scope to the intended main-frame document/domain;
- use a priority that correctly overrides ordinary block rules;
- preserve additional domain/from/to constraints when representable;
- reject unsupported mixed forms explicitly rather than silently compiling the wrong behavior.

Update both:

- static compiler path;
- runtime/user-filter path, if Chrome permits the same action dynamically.

Likely files:

```text
src/core/compiler/safe-network-rule-compiler.ts
src/core/compiler/static-ruleset-compiler.ts
src/core/compiler/filter-classifier.ts
platform/chromium/js/filter-list-runtime-core.js
platform/chromium/js/filter-list-streaming.js
```

Extend rule action types safely:

```ts
| { type: 'allowAllRequests' }
```

Do not compile a document exception as a plain subresource `allow` if that changes semantics.

### Live proof

- Add a block rule for a page and its resources.
- Add a higher-priority document exception.
- Confirm the main document and subsequent resources load.
- Remove the exception.
- Confirm blocking returns.

## Mandatory item B — Correct `$redirect-rule` priority semantics

The current code must distinguish:

```text
$redirect=
```

from:

```text
$redirect-rule=
```

Do not parse both with one indistinguishable regex and identical priority.

Create explicit parsed modifier kind:

```ts
type RedirectKind =
    | 'redirect'
    | 'redirect-rule';
```

Centralize priority bands.

Example concept:

```ts
const PRIORITY = {
    block: 400_000,
    redirect: 410_000,
    redirectRule: 450_000,
    importantBlock: 500_000,
    allow: 600_000,
};
```

Use values consistent with existing project precedence and Chrome DNR action precedence.

Required behavior:

- ordinary redirect follows documented project semantics;
- redirect-rule can override the block case it is intended to override;
- `$important` still has the correct precedence;
- exceptions still win when they should;
- static and runtime compilers agree;
- source maps/reporting identify the correct modifier.

### Live proof

Create one request matching:

- plain block;
- redirect;
- redirect-rule;
- exception;
- important block.

Verify the winning browser action for each intended combination.

Do not rely only on the produced JSON.

## Mandatory evaluation C — Safe DNR regex-filter subset

Chrome DNR can represent some URL regular expressions through `regexFilter`, subject to RE2 syntax, memory limits, and a separate regex-rule quota.

Audit real frequency before implementing. If regex filters materially affect selected-list coverage, implement a conservative subset in both static and runtime paths.

Requirements:

- accept only a complete `/pattern/` network-filter form that can be unambiguously separated from options;
- support only flags/semantics that Chrome DNR can reproduce;
- call `chrome.declarativeNetRequest.isRegexSupported()` where available before installation, or use the project’s build-time equivalent for packaged rules;
- enforce strict source-length and compiled-memory bounds;
- reject unsupported lookbehind, backreferences, and non-RE2 constructs;
- preserve resource, domain/from/to, party, method, and case constraints when representable;
- count every regex rule against the separate regex quota;
- rank user regex filters above stock complement/refresh regex rules;
- never allow one list to consume the entire regex quota;
- expose deferred/unsupported regex counts truthfully;
- do not fall back to a broader `urlFilter` that changes matching semantics.

If current selected-list frequency is negligible or safe parity cannot be achieved, retain explicit recognized-and-unsupported behavior with measured evidence. Do not leave all regex filters silently classified as generic invalid lines.

### Direct proof

Use a small local fixture with:

- one supported RE2 regex that should block;
- one nonmatching control;
- one unsupported expression that must be rejected without affecting other rules;
- enough synthetic candidates to prove quota accounting and user-rule priority.

## Conditional item D — `$cookie` safe subset

Implement only if:

- the current Chromium DNR API can represent the desired semantics;
- current lists use it enough to matter;
- it can be implemented without broad cookie breakage.

Safe initial subset:

```text
||tracker.example^$cookie
```

Possible DNR mapping:

```js
{
    action: {
        type: "modifyHeaders",
        requestHeaders: [
            {
                header: "cookie",
                operation: "remove",
            },
        ],
        responseHeaders: [
            {
                header: "set-cookie",
                operation: "remove",
            },
        ],
    },
    condition: {
        urlFilter:
            "||tracker.example^",
    },
}
```

Before implementing, verify Chrome’s supported header names and action constraints.

Requirements:

- host/domain scope must be explicit;
- do not install a global cookie-stripping rule from an ambiguous pattern;
- preserve first-party/third-party constraints;
- reject unsupported exception semantics explicitly;
- do not claim support for forms not implemented;
- add live request/response cookie proof.

If safe semantics cannot be guaranteed, leave it unsupported and explain the exact Chrome limitation.

## Conditional item E — `$header` safe matching subset

Implement only the DNR-representable subset.

Inspect whether current Chrome supports:

```js
condition.responseHeaders
condition.excludedResponseHeaders
```

and which actions are valid with them.

Possible supported forms:

```text
||example.com^$header=content-type
||example.com^$header=content-type:text/html
```

Do not confuse header matching with header modification.

Requirements:

- parse header name/value safely;
- reject regular-expression or negated forms not implemented;
- preserve request URL/domain/resource constraints;
- compile the same way in static and runtime paths where supported;
- prove the rule against a local server that returns controlled headers.

If current DNR cannot enforce the intended uBO semantics, keep the syntax recognized-and-unsupported.

## Claimed syntax and My Filters reconciliation

For every syntax marked supported after this phase, verify all applicable entry paths:

```text
static packaged compiler;
runtime remote/imported compiler;
My Filters compiler;
source-map/unsupported reporting;
logger/source attribution;
dashboard or editor feedback.
```

Static and runtime support may legitimately differ because of MV3 quotas or action restrictions, but the difference must be explicit.

My Filters must not silently save a line and report success while dropping its behavior. Preserve unsupported user text in the editor, but return bounded per-line or summarized diagnostics identifying:

- installed;
- ignored comment;
- invalid;
- recognized but unsupported;
- deferred because of quota;
- superseded by `badfilter` or exception semantics.

Audit the full set the project already claims, including ordinary host/block/allow rules, party/domain/resource constraints, case sensitivity, important priority, badfilter behavior, static-key removeparam, packaged redirects, cosmetics, procedural cosmetics, and packaged-allowlisted scriptlets.

## Explicitly out of scope unless Chrome now supports them

Do not implement fake versions of:

```text
$replace=/.../.../
$csp=...
$removeparam=/regex/
arbitrary external $redirect URLs
response-body rewriting
```

Keep these counted and documented as unsupported.

`$popup` should remain handled through the existing popup-blocking runtime behavior rather than pretending DNR has a popup action.

## Update coverage documentation truthfully

After behavior is proven, update:

```text
docs/mv3-filter-syntax-coverage.md
```

Do not mark a feature “supported” merely because the parser recognizes it.

A feature is supported only when:

- compiler output is correct;
- browser accepts the rule;
- a live fixture proves the intended outcome.

## Definition of done

Phase 5 is done when:

- document exceptions work in real Chromium;
- redirect-rule precedence works in real Chromium;
- regex filters and every other material representable syntax found by the complete inventory are either implemented safely or explicitly deferred with measured evidence;
- cookie/header subsets are either safely implemented with proof or explicitly left unsupported with a precise reason;
- static/runtime/My Filters classification and diagnostics are consistent;
- preprocessor/include-dependent lists cannot enter an incomplete runtime-replacement mode;
- no important syntax is silently dropped.

---

# Phase 6 — Eliminate user-visible no-op controls, catalog gaps, and mutation races

## Goal

Before broad final testing, ensure every visible feature has a real production path and concurrent state changes cannot corrupt enforcement.

## Permission, host-access, and capability minimization

Build a permission-to-production-call-site ledger for both development and packaged release manifests.

For every item in:

```text
permissions;
optional_permissions;
host_permissions;
optional_host_permissions;
content_scripts.matches;
content_scripts.exclude_matches;
web_accessible_resources.matches;
```

record:

- exact shipped feature requiring it;
- production file/function using it;
- whether it is core or optional behavior;
- user-visible consequence when denied/unavailable;
- whether a narrower API, host pattern, or optional permission can work;
- whether it exists only for development diagnostics.

Remove permissions that have no active shipped call site.

Do not retain permissions for future use.

Where an optional feature alone needs a sensitive permission, use a user-initiated optional permission only when the resulting behavior remains understandable and reliable.

Audit particularly:

```text
<all_urls>;
tabs versus activeTab;
webRequest;
declarativeNetRequestFeedback;
privacy;
idle;
unlimitedStorage;
scripting;
contextMenus;
webNavigation.
```

Do not blindly remove a permission required by the blocker’s core function. Prove the production path before changing it.

Permission-denied or API-unavailable branches must report an honest reduced capability rather than throw, hang, or claim success.

## Incognito and file-scheme behavior

Choose and declare one intentional incognito policy:

```text
"spanning"
"split"
"not_allowed"
```

If incognito is supported:

- detect whether the user granted incognito access;
- never expose incognito URLs, request logs, popup counters, temporary site states, or derived rules to regular extension pages or persistent storage unless Chrome’s intended mode and the product’s disclosed behavior explicitly require it;
- keep incognito session policy/allow rules/tab state isolated;
- do not sync incognito browsing-derived data;
- ensure dashboard/logger behavior is unavailable or safely isolated where extension pages cannot operate;
- clear incognito-derived session state when the incognito context ends.

If safe isolation is not implemented, declare `not_allowed` and document that limitation truthfully.

Likewise, either support `file://` access deliberately and safely or treat it as unavailable. Do not claim blocking on file URLs without access.

## Extension security and trust-boundary closure

Audit production boundaries, not test scaffolding:

```text
runtime.onMessage;
runtime.onConnect and long-lived ports;
content-script sender authorization;
extension-page authorization;
MAIN-world postMessage/bridge traffic;
chrome.scripting.executeScript arguments;
web-accessible resources;
extension HTML rendering;
external links and URL opening;
backup/restore parsing;
remote list/catalog data;
logger and code-viewer rendering;
context-menu and command inputs.
```

Required properties:

- privileged messages validate sender origin, extension identity, tab/frame/document identity, channel, action, and payload bounds;
- no privileged operation trusts caller-supplied policy, hostname, tab ID, document ID, rule ID, file path, or generation ID without re-deriving/validating it;
- port paths enforce the same authorization as one-shot messages;
- MAIN-world bridges use non-forgeable, document-bound capability state and fail closed;
- stale async replies cannot mutate a newer document;
- no untrusted value reaches `innerHTML`, script text, style text, `eval`, `Function`, dynamic import, arbitrary extension resource paths, or unsafe URL schemes;
- web-accessible resources are the minimum needed and narrowly matched where possible;
- the manifest has an explicit extension CSP appropriate for packaged-only code when needed;
- external navigation permits only validated `https:`/documented safe schemes;
- errors and diagnostics redact credentials, tokens, query secrets, form data, and private URLs where not needed.

Add only focused checks for a production boundary changed during remediation.

## Hard-coded exception and compatibility-policy audit

Enumerate every:

```text
content-script exclude_match;
hard-coded domain exception;
compatibility-sites entry;
special-case site adapter;
browser-version exception;
temporary feature flag;
expiry-based compatibility entry.
```

For each, record:

- reason;
- exact behavior disabled or changed;
- whether the site remains protected by network DNR;
- whether the user can understand the limitation;
- owner/source of truth;
- expiry or review condition where temporary.

Remove accidental or obsolete exclusions.

Do not silently exempt a popular site from all content-script protection merely because one feature once caused breakage. Narrow exceptions to the affected layer and path.

## Multi-extension and page coexistence

Do not assume exclusive ownership of the browser or page.

Required behavior:

- recalculate available static capacity when browser truth changes rather than assuming a fixed private pool;
- never touch another subsystem’s DNR ownership ranges;
- MAIN-world wrappers restore only when the currently installed wrapper is still owned by this extension;
- do not overwrite page or other-extension globals, styles, event handlers, history methods, fetch/XHR methods, or observers without ownership-aware installation and restoration;
- browser privacy settings respect `levelOfControl` and do not claim success when controlled elsewhere;
- context-menu IDs, commands, BroadcastChannels, DOM attributes, CSS classes, custom events, and storage keys are extension-namespaced;
- coexistence with another blocker must not cause rule-sync thrashing, repeated static-plan rebuilds, or false exact counters.

## URL, domain, frame, and request-context fidelity

A blocker can appear functional while making incorrect decisions because hostnames, initiators, frames, redirects, and request types were normalized differently in different subsystems.

Create one canonical request-context model used or consistently adapted by:

```text
static compilation;
runtime/My Filters compilation;
dynamic firewall and URL rules;
popup/site power state;
policy resolution;
logger attribution;
overflow lookup;
cosmetic/scriptlet domain matching;
trusted-site and compatibility matching.
```

Audit and correct at least:

- lowercase and trailing-dot normalization;
- internationalized domains and ASCII/Unicode representation;
- IPv4, IPv6 literals, localhost, single-label hosts, and non-host URLs;
- registrable-domain/entity matching without naive “last two labels” logic;
- exact-host versus subdomain matching;
- `requestDomains`, `initiatorDomains`, excluded-domain fields, and party semantics;
- top-frame, parent-frame, initiator, request, and target URL distinctions;
- main-frame, sub-frame, `about:blank`, `about:srcdoc`, sandboxed and nested-frame attribution;
- server redirects, client redirects, history-state navigation, fragment changes, tab replacement, discarded/restored tabs, prerender activation, and back-forward-cache restoration;
- opaque initiators and browser/internal pages where normal matching is unavailable;
- request methods and all resource types exposed by the minimum-supported and current Chromium versions;
- websocket, ping/beacon, media, object, font, XHR/fetch, service-worker fetch, and any current DNR resource type such as WebTransport where supported;
- `data:`, `blob:`, `filesystem:`, extension, browser, and file schemes so non-network activity is not falsely counted as blocked network traffic.

Do not invent CNAME uncloaking, DNS visibility, response-body inspection, or other browser information the MV3 APIs do not expose. Record such gaps as explicit platform limitations.

Use feature detection and the minimum-version capability matrix for resource types or condition fields added after the project’s minimum Chrome version.

Cross-engine precedence must also be explicit for combinations of:

```text
allowAllRequests;
allow;
block;
upgradeScheme;
redirect;
modifyHeaders;
important rules;
document exceptions;
dynamic firewall/URL rules;
policy/power-switch allows.
```

Do not depend on source order or accidental DNR action precedence where the intended product policy can be encoded through priorities and ownership.

During implementation, add only a focused fixture for a normalization, attribution, protocol, or precedence defect that is actually changed.

## Low-end runtime performance and lifecycle budgets

Completion requires acceptable behavior on a modest desktop, not only correctness on a fast development machine.

Measure the current baseline before optimizing and define practical budgets for:

```text
service-worker cold start and rehydration;
popup first usable render;
dashboard/filter-list view opening;
valid-state startup reconciliation;
filter-list refresh and compilation;
static-complement planning;
dynamic/session DNR transactions;
cosmetic index lookup and CSS injection;
procedural-cosmetic mutation processing;
scriptlet registration/injection;
logger buffering/rendering;
picker/zapper startup;
storage and IndexedDB reads/writes.
```

Required properties:

- a valid committed state uses a fast reconciliation path and does not recompile every list or read every packaged shard on each service-worker wake;
- large list and generated-artifact processing remains streamed, paged, or shard-bounded;
- DNR updates are batched within API limits rather than issued one rule at a time;
- cosmetic/procedural observers have node, time, queue, and retry/backoff budgets;
- SPA mutations cannot create an unbounded rescan loop;
- video/adaptation code cannot busy-loop or repeatedly click/control playback;
- popup/logger counters do not trigger high-frequency full storage writes;
- update checks and alarms use reasonable cadence and backoff and do not wake the worker continuously;
- temporary maps, arrays, decoded list text, and source maps are released after use;
- long-lived ports, listeners, observers, object URLs, timers, and pending promises are closed or cancelled when their owner disappears;
- slow, offline, captive-portal, aborted, and suspended-network cases terminate cleanly without holding a transaction or marking data fresh;
- performance safeguards do not silently skip high-priority user rules or produce incomplete committed behavior.

Do not optimize based only on source-file size or synthetic gate scores. Use browser-observed timing, memory/storage counts, and operation counts.

During implementation, measure only the changed path before and after. The single broad low-end/performance campaign runs in Phase 7.

## Accessibility and localization closure

Audit every shipped popup, dashboard pane, logger, picker/zapper UI, strict-block page, new-tab page, and first-run/permission disclosure.

Required minimum:

- all controls work by keyboard;
- focus is visible and moves predictably;
- dialogs and overlays trap/restore focus correctly;
- icon-only controls have accessible names;
- switches expose checked/disabled state;
- status changes needed for operation are announced appropriately;
- color is not the only signal;
- zoom and long translated strings do not hide critical controls;
- destructive actions are distinguishable and confirm where necessary;
- every `__MSG_*__` and runtime localization key resolves in the default locale;
- missing translations fall back safely;
- hard-coded user-visible English is moved to localization where the surrounding surface is localized;
- locale files do not contain stale keys for removed features.

During implementation, test only the UI directly changed. The comprehensive keyboard/localization sweep belongs to the final campaign.

## Complete manifest and UI surface inventory

Before checking individual controls, enumerate the actual current product surface from:

```text
platform/chromium/manifest.json
platform/chromium/manifest.release.json
extension HTML entry pages
popup/dashboard pane registration
context-menu creation
commands/keyboard shortcuts
runtime message and port channels
storage/default-settings schemas
managed policy schema
web-accessible resources
localization message references
```

Build a compact ledger mapping each exposed surface to its production handler and availability status.

This inventory must include any currently present:

- trusted-site/whitelist editor and strict-block/interstitial page;
- basic versus advanced popup modes;
- context-menu actions;
- keyboard commands;
- cloud sync/local-only mode;
- browser privacy controls and `levelOfControl` handling;
- custom new-tab control;
- logger/DOM inspector/code viewer;
- settings panes and reset/import/export actions;
- managed enterprise settings;
- development-only versus release-only capabilities.

For a surface that exists in files but is not intended to ship, remove its reachable UI/manifest entry or mark it unavailable truthfully. Do not leave abandoned pages, commands, menu items, or storage settings that imply functioning behavior.

## Filter-list catalog integrity

Enumerate every list shown in the dashboard.

Each visible selectable list must resolve to at least one real behavior source:

```text
packaged static DNR ruleset;
runtime/bundled network source;
imported remote source;
packaged or runtime cosmetic/scriptlet artifact.
```

For each list record:

- list key;
- title/group;
- selected state;
- source mode;
- static ruleset IDs;
- runtime source URL/path;
- network rule count;
- cosmetic/scriptlet availability;
- runtime refresh support;
- last successful update/check;
- partial/deferred coverage.

If a visible list has no usable source:

1. wire it to the correct packaged/runtime asset; or
2. hide/disable it with an honest reason.

Do not leave a selectable no-op list.

Selecting or deselecting a list must atomically affect all of that list’s network, cosmetic, scriptlet, overflow, remote-generation, and cache state.

## Popup and dashboard control integrity

Audit every visible control, including:

- master/page/site power switch;
- cosmetic filtering switch;
- JavaScript switch;
- popup switch;
- remote-font switch;
- large-media switch;
- dynamic firewall cells and save/revert;
- URL filtering;
- list selection/apply;
- Update, update-selected, purge, and auto-update;
- My Filters save/apply;
- imported-list add/remove;
- backup, restore, and reset;
- logger, picker, and zapper launch controls.

For each control, trace:

```text
UI event → message contract → authorized handler → persisted state → DNR/DOM effect → UI response
```

A control must not return `{ ok: true }` when no state or behavior changed.

If a feature is intentionally unavailable in the release manifest, disable it or label the limitation rather than simulating success.

## Counts and diagnostics

Ensure the UI distinguishes:

- packaged rule count;
- enabled static count;
- dynamic replacement/complement count;
- overflow population versus active session subset;
- exact versus observed/approximate blocked counts;
- selected versus actually enforced lists;
- last checked versus last successfully updated;
- complete versus partial coverage.

Do not display source-map totals as active browser rule counts.

Logger and diagnostics must attribute an enforced decision to the correct ownership source when that information is available:

```text
packaged static ruleset/source-map;
static-complement generation;
remote replacement generation;
imported list;
My Filters;
dynamic firewall/URL rule;
power/hostname switch;
policy-owned allow rule;
surrogate/redirect rule.
```

A dynamic rule ID reused in a later generation must not inherit stale attribution. In release mode without feedback permission, mark attribution/counting as observed or approximate rather than fabricating exact source matches.

## Atomic mutation serialization

All operations that rebuild or mutate filtering state must pass through one coherent serialization/operation-token model:

- startup reconciliation;
- list selection;
- My Filters save;
- remote refresh;
- imported-list edit;
- firewall/URL rule changes where shared DNR state is touched;
- managed-policy changes;
- backup restore;
- reset;
- schema migration.

Required guarantees:

- old async work cannot commit after a newer revision;
- one operation cannot delete another subsystem’s IDs;
- storage commit happens only after browser-state verification;
- UI receives the result of its own operation, not a later unrelated one;
- service-worker suspension/restart leaves either old committed state or new committed state, never an uncommitted mixture.

## Durable interrupted-operation recovery

For every multi-step operation that changes static rulesets, dynamic rules, session rules, or generated IndexedDB state, ensure startup can distinguish:

```text
last committed state;
new pending candidate;
browser state partially changed before service-worker termination.
```

Use the smallest durable mechanism compatible with the existing transaction system, for example a bounded pending-operation record containing:

- operation ID/type;
- base commit revision;
- selected-list revision;
- old/new enabled static ruleset IDs;
- old/new generation IDs;
- expected owned DNR fingerprints/counts;
- stage reached;
- creation time.

Write it before the first irreversible browser mutation and clear it only after the new committed state is persisted.

Startup reconciliation must either finish a provably complete candidate or restore the last committed state. It must never guess based only on counts.

Add one directly related interruption fixture that terminates/reloads the service worker at a controlled transaction boundary and proves recovery.

## Derived-generation garbage collection and resource bounds

After successful commits and during bounded startup maintenance:

- retain the current committed generation and any explicitly referenced pending/rollback generation;
- delete orphaned remote replacement, static-complement, overflow, cosmetic, and scriptlet generations;
- remove stale cache metadata for deleted lists;
- cap retained rollback history;
- validate serialized storage sizes before writing;
- avoid reading every packaged shard or every source map into memory at once;
- release large arrays/maps after compilation;
- prevent duplicate listeners, observers, alarms, ports, or timers after service-worker rehydration.

Use `chrome.storage.local.getBytesInUse()` and IndexedDB counts where useful, but do not add a broad benchmark suite. Add only focused checks for the generation or large-list path being changed.

## Managed-policy precedence

Managed forced/blocked list policy must apply to every ownership layer:

- static rulesets;
- runtime replacement generations;
- static complements;
- imported lists;
- cosmetics/scriptlets;
- selection UI.

A managed-blocked list must not remain active through an old remote generation. A managed-forced list must not be silently removed by a user selection or failed update. Reuse the existing managed-policy authority and transaction queue.

## Backup, restore, reset, and derived state

Backups should contain user-authored configuration, not trusted-looking compiled browser state.

Do not export or restore as authoritative:

- compiled DNR rule arrays;
- remote replacement rule generations;
- static-complement snapshots;
- session allow rules;
- browser rule IDs;
- source-map-derived active counts.

A restore may include selected lists, imported source URLs, user filters, firewall/URL rules, switches, and other user settings after existing sanitization. After restore, rebuild all derived DNR/cosmetic/scriptlet state through the normal compiler and transaction path.

Reset must remove all extension-owned dynamic/session generations and return static rulesets, settings, and UI to one documented default state without touching another extension’s data.

## Minimum supported Chrome compatibility

The manifest currently declares Chrome 120.

Audit every newly used API, constant, condition field, and rule action against that minimum.

For features introduced after Chrome 120:

- capability-detect and use a correct fallback; or
- intentionally raise `minimum_chrome_version` in both development/release manifests and user-facing release information.

Do not silently rely on a current-development-browser-only API.

## Directly related verification

Do not run the full suite yet.

Use a small control/catalog harness that proves:

1. every visible list has a resolvable behavior source;
2. selecting a probe list changes actual DNR or cosmetic state;
3. deselecting it removes that state;
4. each update-related button returns truthful results;
5. two deliberately overlapping mutations serialize and the newer revision wins;
6. an unauthorized content script cannot invoke privileged dashboard mutations;
7. current and minimum-supported capability branches return truthful health fields;
8. every manifest command/context-menu/page entry resolves to a real handler or an intentionally unavailable state;
9. a controlled service-worker interruption during a multi-step mutation recovers to old or new committed state;
10. repeated failed/successful updates do not accumulate unreferenced generations;
11. logger attribution changes with the active generation and never reuses stale source metadata.

## Definition of done

Phase 6 is complete only when:

- no visible filter list is a no-op;
- no visible switch falsely reports success;
- counts distinguish packaged, active, deferred, and approximate state;
- state-mutating operations cannot race into mixed ownership or stale commits;
- interrupted operations are durably recoverable;
- derived generations and runtime listeners remain bounded;
- logger attribution follows actual active ownership;
- every manifest/UI/settings surface is functional or honestly unavailable;
- minimum-browser compatibility is intentional and truthful.

---

# Phase 7 — Final independent behavior campaign and defect fixing

## Goal

This is the first and only broad behavior campaign. Begin it only after Phases 1–6 are implemented and their directly related fixtures pass.

Find and fix actual extension defects after the known architecture gaps are closed.

Do not use this phase to polish tests. Do not change production code merely to satisfy an assertion unless the browser behavior is actually wrong.

## Required behavior matrix

Use a clean Chromium profile and the packaged extension.

Test both development and release manifests where applicable.

## Scenario 1 — Basic network blocking

Page includes:

- first-party script;
- third-party script;
- image;
- stylesheet;
- iframe;
- XHR/fetch;
- websocket if practical;
- ping/beacon;
- allowed control resources.

Verify:

- expected blocked requests fail with `ERR_BLOCKED_BY_CLIENT`;
- allowed resources load;
- no broad false-positive blocking;
- popup power switch changes enforcement;
- page-scoped and site-scoped power behavior remain separate.

## Scenario 2 — Static plus dynamic coverage

Verify:

- static selected lists are enabled according to capacity;
- Phase 1 complement is installed;
- user filters outrank complement;
- no duplicates waste large parts of the quota;
- list selection changes remove the correct source rules;
- unrelated firewall and switch rules remain.

## Scenario 3 — Filter update

Verify all Phase 2 behaviors using the real dashboard.

Do not call internal helpers directly for the primary proof.

## Scenario 4 — Ordinary plain page plus article/news page

Test both a non-article ordinary page and an article/news page.

Fixture should include:

- generic ad containers;
- domain-specific cosmetic rules;
- procedural cosmetic matches;
- cosmetic exceptions;
- dynamic DOM insertion;
- late-loading ads.

Verify:

- no candidate-wide procedural prehide;
- only matching elements are hidden;
- malformed selector does not poison the whole stylesheet;
- generic/specific switch behavior is immediate or truthfully requires reload;
- layout is not destroyed.

## Scenario 5 — SPA

Fixture should use:

- history API navigation;
- large app root;
- dynamic route changes;
- repeated DOM mutations;
- content-editable element;
- delayed ads.

Verify:

- policy snapshots update;
- old document tokens cannot mutate the new route/document;
- cosmetic rules continue after route changes;
- no unbounded observer growth;
- power/switch changes apply to the current route;
- no stale automatic allow rules.

## Scenario 6 — Authentication page

Verify Phase 3 and also:

- password field remains usable;
- submit event is not intercepted;
- required auth scripts load when policy says network off;
- no generic cosmetic hiding of form controls;
- no scriptlets run when profile says off.

## Scenario 7 — Payment page

Verify:

- payment fields remain usable;
- required payment XHR/script resources load;
- ordinary tracker blocking resumes after leaving the sensitive page;
- another tab on the same hostname remains filtered.

## Scenario 8 — Video site

Use deterministic local video fixtures plus YouTube only when feasible.

Verify:

- packaged network rules work;
- video-specific code does not run on unrelated sites;
- mutation and skip behavior obey policy;
- no infinite mutation loop;
- no accidental playback control clicks;
- backoff works;
- navigation between video and non-video routes cleans state.

Do not attempt to defeat server-side ad insertion that the browser cannot distinguish.

## Scenario 9 — Iframes

Use:

- same-origin iframe;
- cross-origin iframe;
- nested iframe;
- about:blank child where supported.

Verify:

- per-frame policy tokens;
- cosmetic rules in correct frames;
- document identity checks;
- no token reuse across frames;
- network exceptions do not leak to unrelated frames.

## Scenario 10 — Service-worker-controlled PWA

Use a page service worker that:

- serves one cached resource;
- fetches one allowed network resource;
- fetches one blocked network resource.

Verify:

- DNR still blocks network requests;
- popup counts remain truthfully labeled exact or approximate;
- no claim that cached requests were network-blocked;
- extension restart does not break the PWA.

## Scenario 11 — User controls

Verify real UI actions:

- enable/disable filtering;
- page versus site scope;
- cosmetic switch;
- JavaScript/no-scripting switch;
- popup switch;
- remote-font switch;
- large-media switch;
- dynamic firewall cell;
- save/revert firewall rules;
- URL filtering;
- element picker;
- element zapper;
- logger opening;
- dashboard list selection;
- My Filters save;
- backup;
- restore;
- reset user data;
- trusted-site/whitelist changes;
- basic/advanced popup mode where present;
- context-menu actions;
- keyboard commands;
- cloud sync or truthful local-only fallback;
- browser privacy controls and `levelOfControl`;
- custom new-tab behavior where present;
- strict-block/interstitial proceed/back behavior where present;
- logger rows/source attribution for static, dynamic, redirect, exception, and policy decisions.

Fix only reproducible broken behavior.

## Scenario 12 — Restart and crash resilience

For each important persisted feature:

- kill/restart the service worker;
- close/reopen Chromium with same profile;
- simulate an extension-version update with the same profile;
- reopen popup/dashboard;
- verify enforcement and state.

Include:

- static selection;
- dynamic complement;
- remote replacement generations;
- My Filters;
- overflow generation;
- cosmetics;
- site power switch;
- hostname switches;
- firewall rules;
- URL rules;
- policy-owned session allow rules;
- pending-operation recovery journal;
- extension-update static/runtime reconciliation.

## Scenario 13 — Resource lifecycle and derived-state cleanup

Exercise repeated cycles of:

```text
refresh success;
refresh failure;
selection off/on;
My Filters save;
backup restore;
schema/extension update;
service-worker restart.
```

Verify:

- active behavior remains correct;
- storage/IndexedDB generation counts return to a bounded steady state;
- no obsolete DNR IDs or attribution records remain;
- startup does not reload all packaged shards without need;
- no duplicate event listeners, alarms, observers, or timers accumulate;
- one list cannot permanently starve user rules or another selected list;
- large-list processing remains streaming/bounded rather than retaining the whole catalog.

This is part of the single final campaign, not a separate repeated performance suite.

## Scenario 14 — Security, permissions, privacy, incognito, and accessibility

As part of the single final campaign:

- invoke privileged messages from an ordinary webpage/content-script context and confirm rejection;
- try malformed/oversized message, backup, imported-list, and remote-list payloads;
- verify logger/code-viewer/UI rendering does not execute supplied HTML/script;
- verify denied/absent optional capabilities produce truthful disabled states;
- inspect the packaged permission warnings and map them to documented behavior;
- verify the chosen incognito policy: isolated behavior when supported, or explicit unavailability when not;
- verify regular extension pages do not expose incognito-derived URL/log state;
- inspect hard-coded excluded sites and confirm the remaining filtering behavior is intentional;
- run a keyboard-only pass over all shipped extension pages;
- verify all default-locale message keys resolve and critical controls survive long strings/zoom;
- load alongside another blocker or a controlled page wrapper and confirm ownership-aware coexistence;
- verify privacy reset/delete operations remove all declared extension data stores.

Do not create a separate broad test suite for this scenario. Use the final campaign and add only regression coverage for concrete defects found.

## Scenario 15 — URL/domain/protocol and request-context fidelity

Use deterministic local fixtures and controlled host mappings for:

- exact host and subdomain;
- trailing-dot hostname;
- internationalized/ASCII domain representation;
- IPv4 and IPv6 literal;
- top frame, same-origin iframe, cross-origin iframe, nested iframe, `about:blank`, and `srcdoc`;
- first-party and third-party requests;
- main-frame redirect and subresource redirect;
- websocket, ping/beacon, fetch/XHR, media, font, image, script, stylesheet, and every additional resource type supported by the current capability matrix;
- service-worker-originated fetch;
- SPA history navigation, BFCache restore, discarded/restored tab, and prerender activation where Chromium permits deterministic exercise;
- overlapping allow, block, redirect, header-modification, firewall, policy, and document-exception rules.

Verify that compilation, enforcement, popup state, counters, logger attribution, overflow lookup, and cosmetic/scriptlet scope agree on the same canonical host/frame context.

Unsupported browser-internal, DNS/CNAME, opaque-origin, or non-network cases must remain truthful and must not be misreported as ordinary blocked requests.

## Scenario 16 — Low-end performance and lifecycle behavior

Run this once in the final independent campaign using a modest CPU/memory profile or Chromium throttling where practical.

Record before/after values for:

- service-worker cold start;
- valid-state wake/reconciliation;
- popup first usable render;
- dashboard opening;
- refresh of the largest supported runtime list;
- static-complement planning;
- large selected-list cosmetic lookup;
- mutation-heavy SPA processing;
- logger with a full bounded buffer;
- picker/zapper launch;
- browser and service-worker restart.

Verify:

- no startup full recompilation when the commit is valid;
- no whole-catalog memory retention;
- no unbounded mutation/rescan loop;
- no continuous worker wakeups, timer churn, or storage-write storm;
- no duplicate listeners/observers after repeated navigation and worker restart;
- cancellation/timeout releases pending operations;
- the UI remains responsive while background work runs;
- rule correctness and user-rule priority remain unchanged under constrained resources.

Fix measured bottlenecks that cause unusable UI, repeated worker termination, transaction failure, or runaway resource use. Do not pursue tiny benchmark improvements or rewrite working code solely to improve a score.

## Defect handling rules

When a failure is found:

1. Reproduce it twice.
2. Identify the production code path.
3. Fix production behavior.
4. Add one focused regression test or live fixture.
5. Re-run the failing scenario.
6. Check adjacent scenarios for regression.
7. Do not rewrite unrelated tests.

Classify findings:

```text
P0 — extension loses blocking or corrupts state
P1 — common blocking/control behavior broken
P2 — meaningful but limited behavior defect
P3 — cosmetic/polish issue
```

Fix all P0 and P1 defects.

Fix P2 defects when the change is contained and low risk.

Do not delay release for P3 polish unless it makes the UI misleading.

## Definition of done

Phase 7 is done when:

- no reproducible P0 or P1 behavior defects remain in the matrix;
- all fixed defects have direct behavior proof;
- no test-only “fix” is counted as a product fix;
- known limitations are written plainly.

---

# Phase 8 — Final release and store-readiness closure

## Goal

Produce a release candidate whose packaged behavior matches the verified development behavior.

## One-time full test pass

Only now run the complete relevant local test inventory once.

Use the current `package.json` scripts and record exact results. Include:

- compiler and MV3 suites;
- compliance/store-safety suites;
- popup/logger/cosmetic/scriptlet suites;
- retained live Chromium fixtures;
- packaging verification.

Do not repair unrelated flaky or stale assertions without first proving a product defect. Record pre-existing independent failures separately.

## Required build

Run the repository’s real release packaging path.

Typical commands may include:

```bash
npm run build
npm run package:release
npm run verify:extension
npm run check:packaged-extension
npm run check:release-identity
npm run check:release-manifest-parity
npm run check:package-integrity
```

Use current script names from `package.json`.

Do not add or edit GitHub Actions.

## Required packaged behavior proof

Load the staged/release extension into Chromium.

Verify at least:

1. service worker loads;
2. selected static rulesets are active;
3. dynamic complement is active;
4. user filter blocks;
5. manual remote update activates a new rule;
6. failed update preserves last-good rules;
7. cosmetic rule hides the intended element;
8. procedural rule hides only matching elements;
9. scriptlet proof still works where permitted;
10. auth/payment policy enforcement is truthful;
11. power switch works;
12. list deselection removes its behavior;
13. service-worker restart preserves committed state;
14. browser restart preserves persistent state;
15. release popup counts are labeled according to available feedback capability;
16. no unexpected remote list request occurs at startup;
17. extension-update reconciliation does not reactivate stale packaged rules beneath a compatible runtime replacement or retain an incompatible old generation;
18. a simulated interrupted transaction recovers to a valid committed state;
19. repeated update/selection cycles do not leave orphaned generations;
20. manifest commands, context menus, cloud/privacy modes, trusted-site state, and any shipped new-tab/strict-block surface are functional or visibly unavailable;
21. logger attribution identifies the active source where exact feedback exists and remains explicitly approximate otherwise;
22. the packaged permission set has a production call-site justification and contains no development-only permission;
23. the declared incognito mode behaves as documented without regular/incognito state leakage;
24. unauthorized messages/ports/MAIN-world bridge attempts are rejected;
25. web-accessible resources and extension CSP match the minimal packaged attack surface;
26. all shipped localization keys resolve and primary UIs are keyboard operable;
27. upgrade from the last published version preserves user-authored state;
28. required licenses and third-party notices are present in the staged package/repository;
29. coexistence does not clobber page/other-extension wrappers or browser-controlled privacy settings;
30. canonical domain/frame/request context agrees across DNR, policy, popup, logger, overflow, cosmetics, and scriptlets;
31. IDN, IP literals, redirects, nested/blank frames, service-worker requests, and supported modern resource types behave truthfully;
32. valid-state worker startup does not recompile or reload the full catalog;
33. the staged extension remains responsive and bounded under the final modest-resource performance run.

## Generated-file sanity

After the final build:

```bash
git status --short
```

Inspect generated changes.

Do not accept:

- timestamp-only churn;
- duplicated unsupported-report content copied into every shard by mistake;
- missing manifest rule resources;
- registry paths that do not exist;
- rule-count metadata inconsistent with actual JSON;
- source-map indexes pointing to absent files;
- rule IDs outside valid ranges;
- release manifest missing required production files.

## Chrome Web Store and distribution readiness

Because the completed extension fetches remote filter data, perform a narrow policy/readiness audit:

- all executable logic is packaged;
- remote lists are declarative data, not remotely hosted code;
- remote scriptlets can only reference packaged allowlisted implementations;
- release permissions are the minimum actually required by the shipped behavior;
- development-only feedback permissions are absent from the release manifest where intended;
- privacy disclosures accurately describe remote list requests, local storage, browsing-data processing, and whether any data leaves the device;
- no telemetry or remote logging was introduced;
- stock-list refresh URLs originate only from packaged metadata and remain within the approved source policy after redirects;
- remote/preprocessor directives cannot initiate arbitrary nested downloads;
- web-accessible resources, extension pages, CSP, commands, context menus, and localization references point only to packaged existing files;
- version is incremented once for the release candidate;
- release notes list material behavior changes and unavoidable MV3 limitations;
- README/capability documentation no longer says cosmetics or Chrome scriptlets are unsupported if live production behavior proves they are supported;
- experimental/not-feature-complete wording is updated only if all final acceptance conditions are actually met.

Do not spend time creating marketing material. Correct only metadata and documentation required to avoid misleading users or store review.

## Privacy, data handling, and store declarations

Create one truthful data-flow inventory covering:

```text
page URLs and hostnames;
request metadata and blocked/allowed counters;
logger entries;
user filters and imported-list URLs;
whitelist/trusted-site entries;
firewall/URL rules;
filter-list fetch requests;
cloud/sync data;
managed policy;
backup files;
diagnostic/error data.
```

For each data class record:

- where it is created;
- where it is processed;
- storage area and retention;
- whether it leaves the device;
- destination and purpose if transmitted;
- deletion/reset behavior;
- incognito behavior;
- whether it is required for the extension’s single purpose.

Chrome Web Store disclosures, privacy policy, in-product disclosures, and actual behavior must agree.

Local-only processing still must be described accurately.

If no browsing data is transmitted, say so plainly and ensure the code proves it.

If remote filter updates reveal only the extension version/list request to approved list hosts, disclose that accurately without claiming that no network communication occurs.

Cloud sync must be opt-in or otherwise accurately represented and must never advertise remote sync when operating local-only.

Do not invent legal language. Produce a factual implementation-backed privacy statement and flag any legal review still required.

## Licensing, provenance, and distribution rights

Inventory every packaged or redistributed source:

```text
upstream uBlock/uBlock Origin code;
EasyList/EasyPrivacy and other filter lists;
uBlock filter lists;
redirect resources;
scriptlet implementations;
third-party JavaScript/CSS libraries;
PSL data;
icons/images/fonts;
copied documentation;
generated artifacts derived from licensed sources.
```

For each record:

- source project/URL;
- version or source commit/date;
- license;
- required attribution/notice/source-offer obligations;
- whether modification notices are required;
- whether redistribution in the Chrome Web Store package is permitted;
- corresponding packaged notice file.

Requirements:

- preserve required copyright and license headers;
- include the project license and all required third-party notices in the repository and package where required;
- do not relabel upstream authorship as original work;
- ensure generated bundles do not erase required notices without a separate retained notice;
- ensure downloaded build inputs are pinned or reproducibly captured with license metadata;
- remove or replace any asset whose license or redistribution right cannot be established;
- do not claim clean-room or independent implementation where inherited code remains.

This is an inventory/remediation task, not a request for legal advice.

## Release identity, update continuity, and migration closure

Ensure one coherent version and identity across:

```text
package.json;
development manifest;
release/staged manifest or generated release manifest;
release notes;
package name;
Chrome Web Store item/update identity;
backup schema version;
DNR/storage schema versions.
```

The absence of a checked-in `manifest.release.json` is not automatically a defect if the release manifest is generated. Locate the real package-generation source of truth and verify the staged manifest.

Required behavior:

- store updates preserve the installed extension identity;
- version increases monotonically;
- adding required warning permissions is deliberate and documented;
- upgrade from the last published version migrates user-authored state without destructive reset;
- downgrade/rollback either works safely or fails with a clear compatibility state;
- disabled/re-enabled extension state reconciles correctly;
- browser restart during upgrade recovers through the durable transaction journal;
- old generated rules/generations are invalidated by schema/content identity, not merely timestamps;
- backups from supported older versions restore through explicit migrations;
- newer unsupported backup schemas are rejected without partial import.

## Package attack-surface and supply-chain sanity

Before release:

- package only files needed at runtime or required notices;
- exclude test fixtures, private debug logs, secrets, local paths, source credentials, temporary profiles, and unnecessary source maps;
- verify lockfile integrity and reproducible dependency installation;
- inventory runtime-bundled dependencies and licenses;
- ensure build-time downloads use HTTPS, pinned source/version/hash where feasible, bounded content, and deterministic fallback;
- do not let an offline build silently emit empty security-critical data while still reporting a successful production package;
- scan the staged package for private keys, tokens, credentials, absolute local paths, and unexpected remote endpoints;
- verify every web-accessible resource is intentional.

Do not add a broad dependency-test framework. Use the existing package/build checks plus focused remediation for concrete findings.

## Final report

Create one concise final report with:

- final commit;
- exact static/dynamic/session counts;
- selected list coverage;
- dynamic complement counts by source;
- remote replacement-generation counts by source and disabled packaged rulesets;
- unsupported syntax counts;
- real Chromium scenarios passed;
- release package verified;
- remaining unavoidable MV3 limitations.

Do not claim “full uBlock Origin parity.”

Do not claim superiority without an external, reproducible comparator corpus.

## Final definition of done

The remaining project work is complete only when all of the following are true:

### Blocking coverage

- selected static rules are enabled up to Chrome capacity;
- unused dynamic capacity complements disabled selected static shards;
- a real omitted-shard probe is blocked;
- user filters retain priority;
- list deselection removes associated complement behavior.

### Updating

- Update Now performs a real remote request;
- new Quick Fixes behavior can activate without extension rebuild;
- remote network, cosmetic, and scriptlet replacement generations persist;
- removed and modified remote rules take effect, while failed/empty/malformed updates preserve last-good behavior;
- update timestamps are truthful;
- automatic update is either real or not presented as real.

### Policy

- every reported sensitive-page network mode matches real DNR enforcement;
- auth/payment allow behavior is tab-scoped;
- ordinary pages on the same domain remain filtered;
- navigation and tab cleanup remove stale allowances;
- policy installation failures are reported truthfully.

### Ordinary-page activation

- normal non-article pages resolve to full default-web filtering after signal collection;
- app/auth/payment/video profiles require positive evidence and transition cleanly;
- ordinary generic/procedural cosmetics are active without candidate-wide over-hide.

### Syntax

- document exception behavior works;
- redirect-rule precedence works;
- regex and every other material safely representable syntax found by the complete inventory are implemented or explicitly deferred with measured evidence;
- cookie/header support is either safely implemented or explicitly unsupported;
- preprocessor/include-dependent refresh cannot silently lose list behavior;
- My Filters reports installed, invalid, unsupported, and quota-deferred lines truthfully;
- impossible MV3 features are not faked;
- unsupported substantive syntax is counted by behavior lane.

### User-visible integrity

- every visible list resolves to real behavior or is honestly disabled;
- no visible control returns success without an effect;
- update/check/active/partial counts are distinct and truthful;
- concurrent state mutations cannot commit stale mixed state;
- interrupted transactions recover durably;
- orphaned generations and stale attribution are cleaned;
- commands, menus, pages, cloud/privacy modes, trusted sites, and any shipped new-tab/strict-block surfaces are functional or explicitly unavailable;
- permissions, host access, incognito mode, excluded sites, and compatibility exceptions are intentional and truthful;
- extension pages and message/bridge boundaries reject untrusted or stale callers;
- primary UIs are keyboard accessible and default-locale complete.

### Network-context fidelity and performance

- hostname, IDN, IP, registrable-domain, frame, initiator, redirect, and party semantics are canonical across all engines;
- supported request methods and resource types enforce correctly at both the minimum and current capability levels;
- unsupported DNS/CNAME, opaque-origin, internal-page, and non-network cases are reported as limitations rather than fabricated matches;
- allow/block/redirect/upgrade/header/firewall/policy precedence follows the documented authority policy;
- valid-state startup and service-worker wakes use bounded fast reconciliation;
- list compilation, DNR installation, cosmetic/procedural processing, logger, picker/zapper, and UI surfaces remain responsive on the final modest-resource run;
- no busy loop, storage-write storm, continuous wakeup, whole-catalog retention, or uncancelled lifecycle resource remains.

### Runtime behavior

- no P0/P1 failures remain in the behavior matrix;
- popup/site switches, firewall, URL rules, My Filters, picker/zapper, cosmetics, scriptlets, and restarts work;
- release behavior matches development behavior where permissions permit;
- counts and diagnostics do not claim capabilities unavailable in the release manifest.

### Scope compliance

- no GitHub Actions files changed;
- no broad test-polishing campaign;
- no canonical service-worker replacement;
- no hand-edited generated DNR rules;
- no user data loss;
- no false completion claim based only on tests;
- no remotely hosted executable logic;
- no broad test campaign was repeated during implementation phases;
- no unbounded derived-state, listener, observer, timer, or cache growth remains;
- no unresolved repository-lineage regression remains;
- no unnecessary release permission or web-accessible resource remains;
- no regular/incognito data leak remains;
- required privacy disclosures, licenses, attribution, and package provenance are complete;
- update identity and supported-state migrations are verified;
- no unresolved domain/frame/request-context disagreement remains;
- final low-end timing/resource results are recorded without substituting benchmark scores for behavior correctness.

---

# 5. Execution discipline for the lower LLM

For Phase -1 and implementation Phases 0–6, use this loop:

```text
1. Read the current production path and current HEAD changes.
2. Determine whether the task is already fully implemented or only partially implemented.
3. State the concrete browser behavior defect.
4. Identify the smallest coherent production-code change.
5. Implement through existing ownership, quota, and transaction systems.
6. Run syntax checks and only the directly affected build step.
7. Run only focused tests for the changed path.
8. Run one direct Chromium fixture when browser enforcement changed.
9. Inspect browser DNR/storage/DOM truth.
10. Record exact results and continue.
```

Do not run full suites between implementation phases. Phase 7 performs the broad independent behavior campaign once; Phase 8 performs the one-time complete test/package pass.

When uncertain:

- inspect existing working patterns first;
- prefer reuse over invention;
- prefer browser truth over comments;
- prefer last-known-good rollback over clearing;
- prefer a truthful limitation over fake support;
- prefer one real behavior proof over ten new assertion-only tests.

Do not stop after generating a plan.

Do not mark the project complete while any of these remain knowingly true:

- stock-list refresh is additive-only and stale removed rules remain active;
- ordinary unknown pages remain permanently in `app-shell` without positive app evidence;
- a sensitive-page policy reports a network mode that DNR does not enforce;
- a visible list or switch is a no-op;
- safe and unsafe DNR quotas are conflated;
- remote list content can select or execute arbitrary code;
- current behavior documentation materially contradicts the packaged extension;
- material safely representable syntax remains silently dropped without measured classification;
- My Filters reports success for rules it did not install;
- an interrupted transaction can leave mixed static/dynamic/generation state;
- repeated operations leak orphaned generations or duplicate runtime listeners;
- a manifest-exposed command, page, context menu, or setting is a no-op;
- logger attribution can refer to a stale generation;
- the checked-out branch omits valid completed production work from a divergent head;
- a required permission or web-accessible resource has no shipped production use;
- incognito behavior is accidental or leaks state;
- privileged messages or MAIN-world bridges trust forgeable caller data;
- a hard-coded site exclusion has no current scoped justification;
- required third-party licensing or privacy disclosure is missing;
- domain, frame, initiator, redirect, or resource-type normalization differs across enforcement and UI/diagnostics;
- valid-state startup repeatedly recompiles the full catalog or a runtime loop causes unbounded CPU, memory, wakeups, or writes;
- a shipped UI is unusable by keyboard or contains unresolved default-locale keys;
- a P0/P1 defect is reproducible in the final independent campaign.

Implement the tasks in order until the final definition of done is satisfied.
