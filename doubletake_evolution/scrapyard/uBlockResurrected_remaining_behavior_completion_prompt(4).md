# uBlock Resurrected — Remaining Behavior Completion Master Prompt

Repository: `Astrocytech/uBlockResurrected`

## ROLE

You are finishing the remaining **real user-facing behavior** of uBlock Resurrected.

This is NOT a CI project.
This is NOT a GitHub Actions project.
This is NOT a documentation-polishing project.
This is NOT a test-suite beautification project.
This is NOT a refactor-for-refactor's-sake project.

The extension's actual behavior in Chromium is the priority.

Work through this entire prompt in order. For every phase:

1. inspect the **current full repository**, not only the latest commit;
2. trace the **manifest-loaded/runtime-used** code path;
3. determine whether the behavior is already genuinely working;
4. if it is already working, mark it `VERIFIED — NO CHANGE` and move on;
5. if it is broken, partial, silently ignored, or only represented by tests/stubs, fix the runtime;
6. perform a small targeted regression check only after the behavior is fixed;
7. continue to the next phase.

Do not stop merely because unit tests pass.

The definition of done is the actual unpacked Chromium extension behaving correctly.

---

# NON-NEGOTIABLE RULES

## DO NOT TOUCH GITHUB ACTIONS

Do not edit:

```text
.github/
.github/workflows/
```

Do not add workflows.

Do not change workflow matrices, release jobs, CI caches, badges, certificates, provenance jobs, benchmark publishing, or GitHub automation.

If a GitHub Action fails for an unrelated reason, ignore it for this task.

---

## DO NOT WASTE TIME ON TESTS DURING IMPLEMENTATION

Tests are secondary while the remaining functionality is being implemented.

During Phases 0 through 24, **DO NOT run the full repository test suite, `check:all`, certificate aggregation, broad browser matrices, or unrelated legacy tests after each change.** We will do the complete test pass once, independently, at the very end after implementation is frozen.

Acceptable during implementation:

- one small targeted regression test for the exact real bug you just fixed;
- a new focused test required to protect newly implemented behavior;
- a small browser fixture needed to prove the changed runtime behavior;
- adapting an existing directly related test whose expectation became incorrect because the runtime was legitimately fixed;
- the minimum build/typecheck needed to know the files you changed still compile.

Not acceptable during implementation:

- repeatedly running the full test suite after every phase;
- rewriting large test suites;
- increasing coverage for its own sake;
- renaming hundreds of tests;
- chasing coverage percentages;
- fixing unrelated failing tests merely because they exist;
- fixing lint-only test issues unrelated to runtime;
- adding certificate/evidence tests;
- spending a long time making synthetic tests prettier.

If an existing unrelated test fails while you are doing a targeted check, record it and continue unless it proves that your runtime change caused a real regression.

A passing test is not proof that the extension works. During implementation, actual browser behavior is the primary proof.

The focused examples later in this prompt (PSL cases, conditional directives, asset validation, restricted URLs, lifecycle edges) are **not** permission to run the whole suite after those phases. Run only narrow checks directly required by the implementation being changed.

Only after every implementation phase is complete should the project enter the separate **FINAL INDEPENDENT TEST PASS** described near the end of this prompt.

---

## DO NOT TRUST OLD GAP DOCUMENTS AS CURRENT TRUTH

The repository contains historical/archive material.

Examples include old `MISSING.md` / archived gap notes and older syntax documentation.

Do not blindly implement anything from an old document.

Before calling something missing, trace the CURRENT runtime.

The active code has changed substantially and some historical documents contradict current behavior.

Use this priority for truth:

1. `platform/chromium/manifest.json`
2. manifest-loaded files
3. canonical source files that generate manifest-loaded bundles
4. current service worker/runtime modules
5. current filter/compiler pipeline
6. actual browser behavior
7. current README only as an intended-behavior hint
8. tests
9. old docs/archive files LAST

---

# IMPORTANT CURRENT ARCHITECTURE FACTS

Verify these before editing, but treat them as the current architectural baseline.

## Canonical service worker

The active manifest uses:

```text
platform/chromium/js/sw.js
```

as the service worker.

`src/js/mv3/sw-entry.ts` / its generated bundle is a migration/prototype/validation path and is NOT the manifest-selected canonical service worker.

Do not "fix" runtime behavior only in `sw-entry.ts` while leaving `platform/chromium/js/sw.js` unchanged.

Do not migrate the whole service worker to TypeScript as part of this task unless an actual behavior bug makes that unavoidable.

---

## Main content script

The normal Chromium content-script chain is:

```text
/js/vapi.js
/js/vapi-client.js
/js/contentscript.js
```

with the source entry in:

```text
src/js/contentscript/contentscript-entry.ts
```

**The previously observed hardcoded ChatGPT manifest exclusion is already removed in the current audited `main`. Do not redo that fix.**

The current active manifest's normal content script matches all HTTP/HTTPS pages and has no ChatGPT-specific `exclude_matches`.

Treat this as a **regression invariant**:

- keep the normal content-script/page-policy path enabled on ChatGPT;
- search any manifest template/generator/canonical source before release to make sure a hardcoded exclusion cannot be reintroduced;
- do not replace the removed manifest exclusion with a JavaScript hardcoded bypass such as:

```ts
if (hostname === "chatgpt.com") return;
```

If ChatGPT or another complex application needs conservative behavior, route it through the existing generic page-policy/profile/safety system used for SPAs, contenteditable roots, authentication forms, and application shells.

The normal HTTP/HTTPS content-script chain must reach `getPageActivation` there while the editor and SPA remain usable.

---

## Existing major systems are real

Do not rewrite working systems merely because they are complicated.

The current runtime already contains substantial implementations for:

- DNR static/dynamic/session rules;
- filter-list transactions;
- mutation journaling and rollback;
- static ruleset planning;
- dynamic rule budgets;
- overflow/adaptive rules;
- IndexedDB-backed overflow data;
- custom cosmetics;
- page policies;
- popup power switch;
- hostname switches;
- dynamic firewall rules;
- dynamic URL filtering;
- popup request accounting;
- logger runtime;
- scriptlet execution/registration;
- redirect resources;
- YouTube-specific handling;
- element picker/zapper frontend helpers;
- persistence/restart reconciliation;
- Trusted Sites / whitelist editor plumbing;
- the dashboard Dynamic Rules editor;
- browser command handlers and context menus;
- browser privacy-setting integration;
- backup/restore/reset handlers;
- cloud storage handlers;
- custom new-tab handling;
- managed enterprise policy handling.

Preserve working implementations, but do not assume that the existence of plumbing means the user-visible feature is complete.

---

# KNOWN CURRENT AUDIT FLAGS — VERIFY THESE FIRST

These are not guesses from historical documents. They were observed in the current shipped UI/runtime during the audit that produced this prompt. Re-check current `main` before editing because a later commit may already have fixed one.

1. **Regression check: the old hardcoded ChatGPT `exclude_matches` is already gone from the current active manifest.** Verify it stays gone and that no generator/template/JavaScript bypass reintroduces the same behavior. Do not spend implementation time removing an exclusion that no longer exists.
2. **`collapseBlocked` is a visible Settings control, while the current DOM-collapser path appears to collapse blocked resources without consulting that setting.** Treat this as a suspected real placebo/behavior bug and trace it end-to-end.
3. **`cnameUncloakEnabled` is visible in Settings, but the canonical service worker audit found no obvious runtime action beyond the setting/default itself.** Determine whether real CNAME uncloaking is feasible in the supported Chromium MV3 architecture. If it is not, do not leave a working-looking placebo toggle: disable/hide it honestly or provide a clearly defined supported approximation only if it is semantically valid.
4. The dashboard has full **Trusted Sites**, **Dynamic Rules**, **backup/restore/reset**, and **cloud** surfaces. These must be included in completion, not treated as cosmetic UI.
5. The Filter Lists page exposes **auto-update**, **suspend until lists are loaded**, and **ignore generic cosmetic filters**. Each must have real behavior.
6. The manifest exposes keyboard commands for picker, zapper, logger, dashboard, relaxing blocking mode, cosmetic filtering, JavaScript, and custom new-tab mode. Every command must work.
7. The extension exposes context-menu actions and a custom new-tab/search page. These are real product features and must not be left as side paths.
8. The manifest declares `storage.managed` schema behavior and `incognito: split`. Managed policy precedence and incognito runtime separation must be checked.
9. The popup exposes more than a single blocked count: domains connected, blocked-since-install, badge state, an unprocessed-request warning, Save/Revert, and the advanced firewall matrix. These must agree with runtime truth.
10. **`matched-rules.html` is a shipped user-facing support page, but the current canonical service worker's `getMatchedRuleInfo` handler returns `{ ok: true, matches: [] }` unconditionally.** The page therefore cannot show actual matched rules. It must be wired to the existing authoritative matched-rule ledger/reverse-index state rather than a new parallel logger.
11. **The Matched Rules page currently calls `getMatchedRuleInfo` without a concrete target tab ID, and its Clear button only clears the rendered DOM.** Fix target-tab semantics and make Clear mean what the UI says: if it is intended to clear the underlying recent-rule view, clear the authoritative per-tab entries; otherwise relabel the UI honestly.
12. **`platform/chromium/matched-rules.html` loads `js/matched-rules.js`, but the current `build.mjs` does not build `src/js/matched-rules.ts` into that live file.** Resolve this source/runtime ownership gap so the live page is generated from the maintained source or has one clearly declared canonical source. Do not leave divergent `.ts` and live `.js` implementations.
13. **`asset-viewer.html` exposes a Subscribe action, but the current source only hides the Subscribe notice instead of actually adding/subscribing the list.** The viewer also guesses several remote CDN URLs before consulting the extension runtime. Make it display the authoritative list/source and make Subscribe use the real validated custom-list path, or remove/disable the subscription affordance if the product does not support it.
14. The logger exposes more than request rows: selected-tab controls, pause/clear/filter/export, a DOM inspector, static/cosmetic filter creation, filter-finder/list attribution, embedded popup, and Code Viewer links. These are real user-reachable tools and must be included in completion.
15. The dashboard shell has explicit unsaved-change protection across panes. Switching away from My Filters, Dynamic Rules, or Trusted Sites must not silently discard edits.
16. Several support pages perform privileged operations through messaging, including new-tab navigation, Code Viewer temporary fetch rules, picker/zapper, restore/filter management, and web-accessible documents. Complete the project with a least-privilege sender/message audit so a hostile page cannot invoke dashboard-level or cross-tab actions merely because a broad channel is reachable.
17. **The normal content script runs at `document_start`, but the current page classifier treats absence of auth/payment/video/app-shell signals as `default-web` (full-capability profile).** At `document_start`, much of the DOM usually does not exist yet, so absence of those signals is not reliable evidence. A page can therefore start with a more permissive content-side policy and only be downgraded at DOM-ready after observers/styles/wrappers have already begun. Make the initial classification explicitly provisional/conservative until the DOM can supply reliable negative evidence, then promote ordinary pages without duplicating runtimes or leaving stale mutations.
18. **Cloud UI has a live source/build ownership gap similar to Matched Rules.** User-facing panes load `platform/chromium/js/cloud-ui.js`; maintained source exists at `src/js/cloud-ui.js`; current `build.mjs` does not regenerate/copy that live file. Make cloud UI reproducible from one canonical source before changing/finalizing cloud behavior. Also audit the same ownership issue for other live helper modules such as `theme.js` rather than assuming every file under `platform/chromium/js/` is generated by the current build.

If any item above is already fixed, mark it `VERIFIED — NO CHANGE` and continue.

---

## Newly confirmed completion blockers from the latest current-runtime audit

19. **Packaged/local filter-list fallbacks are currently not production data.** Multiple catalog-referenced local list files in current `main` contain only the literal text `stub` (5 bytes), including local uBlock list fallbacks and the local EasyList/EasyPrivacy fallbacks. Other advertised local data paths are empty or absent. Ordinary startup/recompile has a packaged-first path, so this is a runtime integrity issue rather than repository tidiness.

20. **The shipped request-context authority currently relies on a finite built-in Public Suffix fallback.** Registrable-domain and first/third-party decisions therefore are not guaranteed to use the complete PSL, even though the repository contains a proper publicsuffixlist implementation and the asset catalog advertises a full PSL asset. The expected packaged PSL data file is absent in current `main`.

21. **Filter-list conditional preprocessing is not clearly authoritative in the active runtime compile path.** The active network line parser drops all `!`-prefixed lines. The repository already contains preparser logic for `!#if`, `!#else`, `!#endif`, and `!#include`. Verify preprocessing happens before filter-family classification; otherwise conditional branches can be silently lost or incorrectly compiled.

These are P1 correctness/completeness items. Re-check current `main` before modifying them. If one is already fixed, mark `VERIFIED — NO CHANGE`.

---

# GLOBAL COMPLETION PRINCIPLE

Do not aim for "every historical uBlock Origin feature."

Aim for this:

> Every feature exposed by uBlock Resurrected's current UI and every high-value syntax form actually present in its active filter corpus must either work correctly in Chromium MV3 or be explicitly and safely rejected/quarantined. Nothing important should be silently miscompiled, silently ignored, or represented as working when it is not.

For syntax that Chromium MV3 cannot faithfully implement:

- do not fake semantics;
- do not turn a `noop` into an `allow`;
- do not silently remove an unsupported modifier and compile the rest;
- do not use dangerous arbitrary page code execution;
- quarantine/reject it explicitly;
- surface useful diagnostics where the product already has diagnostics.

---

# PRIORITY ORDER

Use this order unless a newly discovered P0 regression blocks all later work.

```text
P0  Browser-visible startup / catastrophic regressions
P1  My Filters / user-created rules
P1  Network filter correctness and syntax coverage
P1  Scriptlet compatibility
P1  Cosmetic/procedural compatibility
P1  Filter-list selection/update/startup lifecycle
P1  Trusted Sites / whitelist correctness
P1  DNR capacity/overflow correctness
P2  Dynamic firewall / URL filtering / Dynamic Rules editor / per-site switches
P2  Picker / zapper / document blocker
P2  Logger / attribution / popup counts and warnings
P2  SPA / iframe / navigation lifecycle
P2  YouTube / video / first-party interception
P2  Browser restart / service-worker suspension / migration
P2  Backup / restore / reset / cloud correctness
P2  Commands / context menus / custom new tab
P2  Managed policies / incognito behavior
P3  Appearance-only and low-risk presentation settings
```

Do not spend P1 time on P3 polish.

---

# PHASE 0 — ESTABLISH THE REAL RUNTIME BASELINE

Before changing anything, map the active runtime.

Inspect at minimum:

```text
platform/chromium/manifest.json
platform/chromium/js/sw.js
build.mjs
package.json
src/js/contentscript/contentscript-entry.ts
src/js/contentscript/07-bootstrap.ts
src/js/contentscript/04-dom-filterer.ts
src/js/1p-filters.ts
src/js/3p-filters.ts
platform/chromium/js/filter-list-runtime-core.js
src/core/compiler/
src/js/mv3/
```

Also identify which files are generated and which are canonical.

### Required output from this phase

Create a short working note for yourself:

```text
Manifest service worker:
Main content-script source:
Popup source:
My Filters UI source:
Active network filter compiler(s):
Active cosmetic compiler/runtime:
Active scriptlet compiler/runtime:
Active redirect catalog/runtime:
Dynamic firewall runtime:
Filter update/runtime transaction path:
Generated files that must not be hand-edited:
```

Do not spend more time documenting the architecture than needed to make correct changes.

## Shipped surface inventory

Before declaring the project complete, inventory the actual production pages and support entrypoints under `platform/chromium/`, including current equivalents of:

```text
popup-fenix.html
dashboard.html
settings.html
3p-filters.html
1p-filters.html
dyna-rules.html
whitelist.html
logger-ui.html
matched-rules.html
asset-viewer.html
code-viewer.html
advanced-settings.html
document-blocked.html
picker-ui.html
zapper-ui.html
pages/newtab.html
cloud-ui.html
about.html
no-dashboard.html
devtools.html
background.html
blank.html
```

`cloud-ui.html`/`js/cloud-ui.js` are part of real pane-level cloud controls and must be traced when cloud is enabled.

`background.html` and `blank.html` currently exist in the package even though the MV3 manifest uses `js/sw.js`. Classify them by actual reachability; do **not** resurrect or polish legacy pages merely because the files still exist.

Also inspect any additional HTML page added later.

Classify each as exactly one of:

```text
A. manifest entrypoint
B. user-reachable production/support page
C. developer-only/internal page
D. obsolete/unreachable page
```

Then trace the link/message path for every A/B page.

Rules:

- Every A/B page must have a working backend for every visible functional control.
- C pages such as developer tools are **not** a reason to waste time polishing internal diagnostics unless they are linked/advertised in the production UI or required to debug/fix actual runtime behavior.
- D pages should not remain accidentally reachable from production UI.
- If an HTML page loads a JS file, determine the canonical source and whether `build.mjs` actually produces/copies that live file.
- If a TypeScript source exists but the shipped JS is maintained separately, resolve the ambiguity for user-facing paths rather than allowing silent drift.

This inventory is a completeness net: it prevents a shipped support page with a stubbed backend from being missed merely because it is not a dashboard tab.

### Definition of done

- You know which code actually ships.
- You are not about to edit an obsolete or generated-only path.
- The active manifest contains no hardcoded ChatGPT `exclude_matches` entry and no source/generator re-adds it.
- ChatGPT reaches the normal content-script/page-policy path without breaking its editor/SPA.
- Extension loads unpacked without a manifest/startup failure.

---

# PHASE 1 — REMOVE GLOBAL PAGE-BLANKING / STARTUP CLOAK RISK

## Why this is high priority

The current content-script bootstrap contains a cosmetic startup cloak that can apply roughly:

```css
html[data-ubr-cosmetic-startup-cloak="1"] {
    opacity: 0 !important;
    pointer-events: none !important;
    transition: none !important;
}
```

with a safety release timer around 1500 ms.

This can make every supported page temporarily blank and non-interactive while the service worker/page policy responds.

That is a direct user-visible failure mode, especially on:

- cold service-worker startup;
- slower machines;
- pages opened immediately after browser startup;
- service-worker suspension/resume;
- messaging failure;
- heavy SPA pages.

## Task

Measure the actual behavior first.

Then eliminate the possibility that a normal page is globally hidden/non-interactive for a noticeable period merely because policy/cosmetic data is not ready.

Preferred behavior:

- do not hide the entire document;
- do not disable pointer events for the entire document;
- inject known cosmetic selectors as early as safely possible;
- if an anti-flicker mechanism is truly necessary, scope it narrowly to elements/selectors that are actually known, not `html { opacity:0 }`;
- failure to obtain page activation must leave the page fully usable;
- a suspended/cold service worker must never cause a long blank page.

Do NOT "fix" this merely by changing `1500` to another arbitrary large number.

### Likely files

```text
src/js/contentscript/contentscript-entry.ts
src/js/contentscript/07-bootstrap.ts
src/js/contentscript/contentscript-modules.ts
```

and any policy/bootstrap helpers they use.

### Behavioral check

Using the unpacked extension:

1. fully terminate/restart Chromium;
2. immediately open several normal sites;
3. open a complex SPA;
4. reload with the service worker cold/suspended if possible;
5. throttle CPU briefly if useful;
6. verify the page is never globally blank/non-interactive because uBR is waiting for policy;
7. verify cosmetic filtering still starts early enough to be useful.

### Definition of done

- No normal page is globally made invisible for up to 1.5 seconds.
- Policy failure cannot leave a blank page.
- Cosmetic filtering still works.
- No broad website-specific bypass is introduced.

---

# PHASE 2 — MAKE "MY FILTERS" A REAL FIRST-CLASS FILTER PATH

This is one of the most important remaining areas.

The repository contains multiple compiler/classifier paths with different capabilities.

For example, current source contains a classifier path that describes some forms such as cosmetic user syntax or regex network syntax as unsupported, while other runtime parsing code has support for cosmetics and/or regex.

Do NOT assume either side is correct.

Trace what `Dashboard -> My filters -> Apply changes` actually does in the active extension.

## Required behavior

When a user enters a supported filter in My Filters and presses Apply:

- it becomes active promptly;
- it persists;
- it survives service-worker restart/browser restart;
- disabling My Filters disables its effects;
- re-enabling restores its effects;
- deleting the filter removes its effect;
- invalid/unsupported lines are diagnosed rather than silently altered.

Cover all filter families that the extension can faithfully support:

### Network filters

Examples of categories, not literal hardcoded special cases:

```text
||host^
@@||host^
plain URL filters
resource-type filters
domain/from/to constraints
1p/3p constraints
important
match-case
supported regex filters
known redirect / redirect-rule
supported removeparam
badfilter where the canonical pipeline supports it
document exceptions
```

### Cosmetic filters

At minimum, if the normal filter-list path supports these, My Filters must not arbitrarily lose them:

```text
example.test##.ad
example.test#@#.ad
domain-specific selectors
generic selectors
procedural selectors that are actually supported
style filters that are actually supported
exceptions
```

### Scriptlets

If user-created scriptlet filters are supported by the current safety/trust model:

```text
example.test##+js(...)
```

must go through the same token validation, trust model, domain scoping, and safe executor as packaged-list scriptlets.

Do not introduce arbitrary JavaScript execution.

## Important compiler rule

Do not maintain several contradictory definitions of "supported filter."

Create or use a canonical decision path.

A good model is:

```ts
type CompileDisposition =
    | { kind: "dnr"; rules: DnrRule[] }
    | { kind: "cosmetic"; artifact: CosmeticArtifact }
    | { kind: "scriptlet"; artifact: ScriptletArtifact }
    | { kind: "special"; artifact: SpecializedArtifact }
    | { kind: "unsupported"; reason: string }
    | { kind: "comment" };
```

This is an example structure, not a requirement to refactor everything to this exact type.

The important point is that a line must not be:

- accepted by diagnostics but ignored by runtime;
- rejected by diagnostics while another active path supports it;
- compiled differently in My Filters vs normal selected lists without a real MV3 reason.

### Files to trace

```text
src/js/1p-filters.ts
platform/chromium/js/sw.js
src/core/compiler/filter-classifier.ts
src/core/compiler/safe-network-rule-compiler.ts
src/core/compiler/*
platform/chromium/js/filter-list-runtime-core.js
custom cosmetic / scriptlet artifact paths
```

### Atomicity

Applying My Filters must be transactional enough that:

- a single unsupported line does not erase all existing working user rules;
- a failed DNR update does not leave half-old/half-new state;
- diagnostics correspond to the state that was actually committed.

Reuse the repository's existing transaction/journal machinery where appropriate.

Do not build a second transaction system.

### Definition of done

- My Filters is not a decorative editor.
- Supported network filters work.
- Supported cosmetics work where technically supported.
- Supported scriptlets work only through the safe scriptlet path.
- unsupported syntax is clearly diagnosed;
- Apply/disable/re-enable/delete all alter actual behavior;
- state survives restart;
- no silent semantic downgrade occurs.

---

# PHASE 3 — CLOSE HIGH-VALUE NETWORK FILTER SYNTAX GAPS

Do this **corpus-first**, not feature-list-first.

The code already has multiple specialized compilers, so an option rejected by one generic parser may still be supported elsewhere.

Never implement a modifier solely because an old document says it is missing.

## Step 1: measure the ACTIVE corpus

Use the actual filter sources/artifacts that ship or are selected by default.

Build a frequency inventory of:

- network modifiers/options;
- exception forms;
- resource types;
- regex patterns;
- redirect tokens;
- removeparam forms;
- document exceptions;
- badfilter;
- important;
- domain/from/to;
- unsupported lines and their rejection reasons.

A small local analysis script is appropriate.

Pseudo-example:

```js
const counts = new Map();

for (const line of activeFilterLines) {
    if (isCommentOrCosmetic(line)) continue;

    for (const option of extractNetworkOptions(line)) {
        const key = normalizeOptionName(option);
        counts.set(key, (counts.get(key) || 0) + 1);
    }
}

console.table(
    [...counts.entries()]
        .sort((a, b) => b[1] - a[1])
        .slice(0, 100)
);
```

Use real active lists, not a tiny synthetic test fixture.

## Step 2: trace current implementation

Check all relevant paths, including:

```text
src/core/compiler/safe-network-rule-compiler.ts
src/core/compiler/filter-classifier.ts
src/core/compiler/badfilter-resolver.ts
src/core/compiler/dnr-compiler*.ts
src/core/compiler/dnr-priority.ts
platform/chromium/js/filter-list-runtime-core.js
platform/chromium/js/sw.js
redirect compiler/catalog paths
CSP/specialized compiler paths
```

## Step 3: fix highest-impact gaps

Prioritize syntax that:

1. appears frequently in active default lists;
2. changes blocking results materially;
3. can be faithfully represented in MV3.

Candidate families that require explicit verification include:

```text
regex filters
negated resource types
domain=
from=
to=
denyallow=
important
badfilter
document/doc
redirect
redirect-rule
removeparam
csp
header
urltransform / uritransform
replace
urlskip
method
permissions
popup
inline-script
inline-font
```

THIS LIST DOES NOT MEAN THEY ARE ALL CURRENTLY BROKEN.

Some already have specialized support.
Some may be impossible to implement faithfully.
Trace before modifying.

## MV3 rule

If Chrome DNR provides a faithful primitive, use it.

Examples of potentially relevant DNR primitives include:

```text
block
allow
allowAllRequests
redirect.extensionPath
redirect.transform
modifyHeaders
regexFilter
initiatorDomains
excludedInitiatorDomains
requestDomains
excludedRequestDomains
resourceTypes
excludedResourceTypes
domainType
```

Do not approximate unsupported semantics with the wrong primitive.

For example:

```text
noop != allow
```

and:

```text
unsupported modifier + valid base pattern
```

must NOT become:

```text
compile the base pattern and silently drop the modifier
```

unless that is genuinely the defined semantics.

## Regex

Where regex filters are supported:

- validate RE2 compatibility;
- enforce DNR regex quota;
- reject unsupported lookbehind/backreference/etc. safely;
- never let one invalid regex poison an entire rule transaction;
- preserve case semantics.

## Priority/exception semantics

Verify real conflicts:

```text
plain block vs plain allow
important block vs plain allow
important allow vs important block
redirect vs block
redirect-rule vs block
document allowAllRequests
dynamic firewall vs static list
power-switch allow vs all lower filtering
```

Do not guess priority numbers independently in multiple files.

Use the central priority policy.

## Filter source preprocessing must happen before classification

Trace the **active production list pipeline** before adding more individual operators.

The repository already contains preparser semantics for:

```text
!#if
!#else
!#endif
!#include
```

The active network line parser currently ignores comment-prefixed lines. That is correct only after preprocessing has selected/expanded the intended logical source.

Requirements:

- evaluate supported `!#if` / `!#else` / `!#endif` conditions before network, cosmetic, scriptlet, redirect, or other filter-family compilation;
- use the real shipped environment, including Chromium/MV3 capability tokens where applicable;
- never advertise a capability token the installed runtime does not provide;
- nested conditionals must be deterministic;
- unknown/malformed conditions must have an explicit conservative outcome and diagnostics;
- inactive branches must never leak into any generated/runtime artifact;
- `!#include` resolution must be constrained to trusted list/source boundaries;
- reject path traversal and arbitrary filesystem access;
- add include cycle detection plus nesting/recursion/aggregate-byte limits;
- validate included material as filter-list text;
- preserve source/include provenance sufficiently for diagnostics and attribution;
- feed **one preprocessed logical stream** into network, cosmetic, scriptlet, redirect, and related compilers;
- reuse/port the preparser grammar already in the repository instead of creating a second incompatible grammar;
- if My Filters supports directives, use the same semantics;
- if My Filters intentionally does not support them, diagnose them explicitly rather than silently discarding them.

### Hosts-style and alternate custom-list inputs

Because custom-list URLs are exposed, explicitly define which common source formats are supported.

For hosts rows such as:

```text
0.0.0.0 ads.example.test
127.0.0.1 tracker.example.test
```

either parse them faithfully into intended hostname blocking or clearly reject/diagnose the format.

Never accidentally compile an entire hosts row as a generic substring URL filter.

Do not add broad grammars simply for completeness; support only formats the product claims or deliberately chooses to support.

### Definition of done

- The top high-frequency active-corpus network syntax is supported when MV3 can faithfully represent it.
- Conditional preprocessing happens before filter-family classification and inactive branches cannot leak into runtime artifacts.
- Includes are bounded, trusted, cycle-safe, and provenance-aware.
- Unsupported syntax is explicit.
- No important filter is silently weakened.
- Exception/important/redirect priorities behave correctly.
- My Filters and normal list compilation do not contradict each other without a deliberate reason.

---

# PHASE 4 — EXPAND SCRIPTLET COMPATIBILITY BASED ON REAL FILTER USAGE

The current README explicitly says scriptlet support is a **subset**, so this is a known remaining feature area.

Current documented supported tokens include a subset such as:

```text
set-constant
prevent-fetch
prevent-xhr
noeval
abort-on-property-read
abort-on-property-write
abort-current-script
prevent-addEventListener
aeld
addEventListener-defuser
```

Verify the exact current token registry/executor rather than relying only on this list.

## Do not attempt all uBO scriptlets blindly

First scan active filter lists and produce:

```text
token -> occurrence count
token -> number of domains
token -> trusted/untrusted classification if applicable
token -> already supported?
```

Then implement the highest-value unsupported tokens first.

## Prioritization

High priority:

- tokens used often in active default lists;
- anti-ad/anti-popup/anti-overlay tokens;
- deterministic low-risk hooks;
- tokens needed by common video/ad sites;
- tokens whose absence causes obvious ads or anti-adblock overlays.

Lower priority:

- rare trusted-only tokens;
- highly site-specific one-off tokens;
- tokens requiring unsafe arbitrary page code;
- tokens impossible to emulate safely in MV3.

## Safety rules

MAIN-world scriptlets are powerful.

Do NOT:

```text
eval(...)
new Function(...)
execute arbitrary filter-provided JS
fetch remote JS and execute it
```

Use a fixed token -> fixed implementation registry.

Parse arguments as data.

Example design:

```ts
const SCRIPTLETS = new Map([
    ["set-constant", runSetConstant],
    ["prevent-fetch", runPreventFetch],
    // ...
]);

const handler = SCRIPTLETS.get(token);
if (!handler) {
    return { status: "quarantined", reason: "unsupported-token" };
}

handler(validatedArgs);
```

## Wrapper hygiene

For hooks that wrap browser/page APIs:

- preserve `this`;
- preserve arguments;
- preserve normal return types;
- preserve native behavior for non-matching calls;
- avoid double-wrapping;
- support cleanup/restore when the runtime already has teardown mechanics;
- do not leak extension objects into page world;
- do not expose extension URLs/tokens unnecessarily;
- do not break page code merely because a scriptlet is present.

## Domain scoping

A scriptlet intended for:

```text
example.com
```

must not execute on unrelated sites.

Honor:

- include domains;
- excluded domains;
- subdomains;
- exceptions;
- trusted token restrictions;
- frame scope where applicable.

## Document-start timing

For scriptlets whose purpose requires document start, verify that they are actually present before the page's target script runs.

A scriptlet that executes after the site already created the ad/anti-adblock hook is behaviorally broken even if the code itself works.

### Definition of done

- Active-list unsupported scriptlet frequency is known.
- The highest-impact feasible tokens are implemented.
- Unknown tokens remain safely quarantined.
- No arbitrary JS execution was added.
- Domain/exclusion scope is correct.
- document-start tokens really execute at document start.
- failures do not break the page.

---

# PHASE 5 — EXPAND PROCEDURAL / EXTENDED COSMETIC FILTER SUPPORT

The current content-side procedural compiler visibly recognizes a limited operator set including forms such as:

```text
:has-text(...)
:upward(...)
:has(...)
:if(...)
:if-not(...)
:not(...)
:min-text-length(...)
```

That is not the full uBO procedural/extended cosmetic language.

Again, do this corpus-first.

## Step 1: inventory active cosmetic syntax

Count real active-list usage of:

```text
##
#@#
#?#
#@?#
#$#
#@$#
#%#
#@%#
##+js(
```

and procedural operators.

Identify the most frequent unsupported operators.

Potential operator families to VERIFY include:

```text
matches-css
matches-css-before
matches-css-after
matches-attr
matches-media
xpath
watch-attr
remove
style
upward
has-text
min-text-length
others present in the real corpus
```

Do not implement names that are not actually needed merely to make a long feature list.

## Correctness requirements

Procedural filters must:

- observe dynamically added DOM;
- avoid full-document rescans on every mutation;
- correctly handle nested procedural conditions;
- respect domain scoping;
- respect cosmetic exceptions;
- stop when cosmetic filtering is disabled;
- restart/reconcile when filtering is re-enabled;
- not mutate protected/critical UI because of an over-broad selector;
- avoid runaway MutationObserver loops;
- avoid retaining removed DOM nodes indefinitely.

## Exception semantics

Verify combinations such as:

```text
example.com##.ad
example.com#@#.ad
example.com#?#div:has-text(Ad)
example.com#@?#div:has-text(Ad)
```

If style/html filter forms are supported elsewhere, verify their exception equivalents too.

## Generic cosmetics

Verify:

- generic selectors;
- domain-specific selectors;
- high-generic buckets;
- hash/bucket retrieval;
- late DOM additions;
- iframes;
- disable/enable switch;
- My Filters integration.

## No broad "safety" bypass

Do not solve false positives by disabling cosmetics on entire categories of sites.

Use selector-risk/page-policy mechanisms only where justified.

### Definition of done

- The common procedural syntax in active lists works.
- Exceptions work.
- Dynamic DOM updates work.
- no-cosmetic-filtering actually stops cosmetic effects.
- disabling/re-enabling does not require corrupt state.
- memory/observer behavior is bounded.
- unsupported operators are diagnosable rather than silently misparsed.

---

# PHASE 6 — REDIRECT RESOURCE AND SURROGATE COMPLETENESS

The extension already has redirect/redirect-rule machinery and a redirect token catalog.

The remaining job is to make sure filters that reference redirect resources actually have a valid, correctly mapped runtime resource.

## Audit

For the active corpus:

1. list every `$redirect=` token;
2. list every `$redirect-rule=` token;
3. compare with the current redirect-token catalog;
4. compare with actual packaged files;
5. identify aliases;
6. identify missing MIME/type behavior;
7. identify tokens that are intentionally unsupported.

## Behavior

Known resources must:

- resolve to an extension-packaged resource;
- be web-accessible if the execution mechanism requires it;
- return content appropriate for the requested resource type;
- not redirect scripts to image content or vice versa;
- preserve redirect vs redirect-rule priority semantics;
- work in subframes where intended;
- not expose arbitrary filesystem paths.

Unknown tokens must fail closed and be diagnosed.

Do not redirect to arbitrary external URLs merely because a filter string contains one.

## Stealth surrogates

Verify surrogate eligibility and scope in actual browsing.

Do not deploy a surrogate globally when the filter intended it only for a narrow domain/request.

### Definition of done

- Every commonly used redirect token in active lists is either correctly mapped or explicitly unsupported.
- No common token silently becomes a plain block by accident unless that is the deliberate safe fallback.
- redirect-rule priority is correct.
- no unsafe arbitrary redirect target is accepted.

---

# PHASE 7 — FILTER LIST SELECTION, UPDATES, CUSTOM LISTS, AND ATOMICITY

The repository already contains sophisticated filter-list sync, commit state, mutation journal, static ruleset planning, overflow storage, and reconciliation.

Do not rewrite it.

Prove it works in the scenarios users actually create.

## Default lists

Verify:

- fresh install gets the intended default lists;
- selecting a list changes blocking;
- deselecting it removes its behavior;
- changes persist across restart;
- static/dynamic/cosmetic/scriptlet artifacts agree on the same committed selection;
- list statistics/status in the Filter Lists page reflect the committed browser state rather than optimistic storage state;
- the "view content" action opens the content actually associated with that list/generation rather than stale or unrelated text.

## Filter-list startup controls

The shipped Filter Lists page exposes these controls and they must be real:

```text
autoUpdate
suspendUntilListsAreLoaded
ignoreGenericCosmeticFilters
```

### autoUpdate

Verify:

- enabling it schedules the existing alarm/update mechanism;
- disabling it prevents automatic list refreshes while preserving manual Update Now;
- service-worker suspension/restart does not lose the intended schedule;
- repeated startup does not create duplicate alarms or concurrent list transactions;
- a failed automatic update preserves the last good committed generation.

### suspendUntilListsAreLoaded

This is startup behavior, not a checkbox-only preference.

When enabled:

- the browser/extension must avoid an unintended initial unfiltered window according to the feature's intended semantics;
- failure to load/update a remote list must not leave browsing permanently suspended or the extension permanently "not ready";
- the last good cached/committed lists should be used where available rather than waiting indefinitely for the network;
- the setting must survive restart.

Do not implement this with a global blank-page cloak or whole-browser deadlock.

### ignoreGenericCosmeticFilters

Verify:

- generic cosmetic selectors are omitted/disabled when enabled;
- domain-specific cosmetics continue to work;
- exceptions remain correct;
- turning the option off restores generic cosmetics without requiring state corruption or a clean install;
- the option applies consistently to selected lists and My Filters only where its intended semantics say it should.

## Update behavior

Verify:

- manual Update Now actually fetches/uses new content where remote refresh is supported;
- automatic update uses the same safe commit semantics rather than a weaker side path;
- successful update atomically replaces old state;
- failed fetch preserves the last working committed state;
- HTTP errors do not erase a list;
- corrupt content does not destroy all blocking;
- stale cache handling is coherent;
- list metadata/version/status shown to the user corresponds to real state.

## Custom lists

If the UI supports user-added custom list URLs:

- adding a valid list must actually compile/apply it;
- removing it must remove its artifacts;
- disabling it must stop its effects;
- malformed URL must be rejected;
- failed remote fetch must not destroy unrelated lists;
- custom-list cosmetics/scriptlets must follow the same safety rules as built-ins;
- redirect/scriptlet privileges must not become unsafe merely because the list is custom.

## Asset Viewer and subscription links

The Filter Lists page and logger can open `asset-viewer.html`. Treat it as part of filter-list behavior.

Verify:

- opening "View content" for a built-in/default list displays content belonging to that exact list/current source rather than a guessed unrelated CDN file;
- opening a custom-list viewer displays the custom list URL/content or a clear cached/offline status;
- the viewer identifies the real source URL/generation where the product exposes it;
- it does not silently substitute EasyPrivacy or another fallback merely because the requested asset could not be resolved;
- list content retrieval uses the authoritative asset catalog/cache/list record before any generic remote fetch;
- remote fetches are constrained to the intended list URL/source and respect normal URL validation/timeouts/size limits;
- a failed viewer fetch does not alter selected lists or committed filtering state.

### Subscribe action — known current gap

If the viewer is opened with a subscription affordance such as `?subscribe`:

- clicking **Subscribe** must actually add the intended custom list through the same validated custom-list/imported-list path used by the Filter Lists page;
- the list must then appear in Filter Lists, be selectable/enabled according to the intended subscription flow, compile through the normal transaction path, and survive restart;
- duplicate subscription must not create duplicate list records;
- invalid/non-HTTP(S) URLs must be rejected;
- the page must not gain arbitrary dashboard privileges merely to subscribe;
- if subscription from Asset Viewer is not a supported product feature, remove/disable the Subscribe control rather than leaving a button that only hides itself.

Do not implement a separate list database inside Asset Viewer.

## Selection atomicity

Network, cosmetic, scriptlet, and overflow artifacts must represent one committed list selection.

Avoid states like:

```text
new network rules + old cosmetic rules
```

or:

```text
new cosmetic generation + failed network transaction
```

If commit fails, roll back to the previous coherent state.

Reuse existing:

```text
filter-list-dnr-transaction
mutation journal
commit state
generation IDs
```

rather than inventing parallel mechanisms.

## Packaged/local asset integrity — known current gap

Do not assume an `assets.json` entry pointing to `assets/...` means a usable packaged fallback exists.

The latest audit found catalog-referenced local sources whose entire content is literally:

```text
stub
```

and other advertised local paths that are empty or absent.

This matters because startup and ordinary recompiles currently have a packaged-first path.

Audit every production catalog entry and classify each local source as:

```text
valid production fallback
valid generated artifact/source sufficient for its role
intentionally remote-only with truthful metadata
intentionally empty with real empty semantics
invalid placeholder/stub/accidental empty/missing asset
```

Requirements:

- placeholder text such as `stub` must never be accepted as a valid list;
- do not compile the literal word `stub` into a blocking rule;
- packaged HTTP 200 is not sufficient validation of list content;
- placeholder/tiny bogus sources must not become a successful committed generation;
- intentionally empty assets are allowed only when empty content is truly their intended semantics;
- the catalog must not advertise a local fallback path that does not exist;
- fresh-install/offline startup must use valid packaged/cached last-good data/artifacts where offline behavior is expected, or report a truthful remote-required/unavailable state;
- if runtime complements, cosmetics, scriptlets, redirects, overflow, diagnostics, or Asset Viewer require source text, ship/cache the real source or a semantically complete artifact;
- packaged static DNR artifacts and runtime-derived artifacts must not silently represent incompatible list generations;
- remote failure preserves the prior committed last-good generation;
- Asset Viewer/list status/statistics must not show a placeholder as valid production content;
- `suspendUntilListsAreLoaded` must neither hang forever nor treat invalid placeholder content as loaded;
- do not replace legitimate small seed/generated assets merely because they are small; validate by declared role and actual content.

If the architecture intentionally avoids shipping raw full lists, that is acceptable only when all runtime features have equivalent valid packaged artifacts and the catalog/runtime stops treating placeholder raw sources as usable fallbacks.

### Definition of done

- List toggles alter real behavior.
- every production packaged fallback is valid for its declared role, or the catalog truthfully marks it unavailable/remote-only;
- placeholder/stub/accidentally empty list content cannot become a committed successful generation;
- updates are real and atomic;
- failed update leaves last good state operational;
- custom lists, if exposed in UI, are real;
- restart preserves the committed selection;
- no partial cross-layer commit remains after failure.

---

# PHASE 8 — DNR CAPACITY, STATIC SHARDS, AND ADAPTIVE OVERFLOW

This is core MV3 behavior.

The extension can select more filter material than Chrome allows in one rule scope, so graceful capacity handling matters more than perfect synthetic counts.

## Verify actual browser limits

Use runtime-reported constants where available:

```text
MAX_NUMBER_OF_DYNAMIC_RULES
MAX_NUMBER_OF_SESSION_RULES
MAX_NUMBER_OF_REGEX_RULES
MAX_NUMBER_OF_ENABLED_STATIC_RULESETS
available static rule count APIs where supported
```

Keep safe fallbacks for older supported Chromium versions.

## Real behavior under pressure

Create a configuration that approaches/exceeds each relevant budget.

Verify:

- the extension does not wipe all blocking;
- priority lists/rules remain active;
- overflow rules are stored consistently;
- overflow rules are materialized for relevant/current hostnames;
- eviction does not remove base rules;
- ID allocation cannot collide across subsystems;
- browser restart restores/rebuilds the intended adaptive coverage;
- the user is not falsely told "all lists active" when only partial coverage is possible;
- quota errors do not leave half-applied DNR state.

## Hot-host behavior

When a request/site needs an overflow rule:

- lookup must be bounded;
- installation must be prompt enough to matter;
- repeated requests should not install duplicates;
- hostname LRU must be correct;
- eviction should remove the proper overflow candidate only;
- navigating between sites must not corrupt other sites' coverage.

## Regex quota

A regex-heavy list must not cause a whole DNR transaction to fail because one more regex exceeded quota.

Select/overflow/skip safely and honestly.

### Definition of done

- Extension remains operational at realistic DNR limits.
- No catastrophic all-rules loss.
- No ID collisions.
- Adaptive overflow survives restart/reconciliation.
- Partial coverage is truthful and useful.
- quota failure rolls back cleanly.

---

# PHASE 8A — REQUEST CONTEXT, DOMAIN NORMALIZATION, AND PUBLIC SUFFIX ACCURACY

This is a P1 correctness dependency for:

```text
first-party / third-party filtering
$domain= / $from= / $to=
dynamic firewall
popup domain grouping
Trusted Sites/per-site inheritance
logger attribution
request ledgers
page-policy domain resolution
initiator/redirect decisions
```

The current shipped request-context authority performs useful normalization, but its registrable-domain logic uses a finite embedded suffix set. The asset catalog advertises a complete Public Suffix List while the expected packaged PSL data file is absent. The repository also ships a proper `publicsuffixlist` implementation.

Do not leave parallel contradictory domain authorities.

## One canonical production domain authority

Use one production source of truth for hostname normalization, registrable-domain extraction, and party classification.

It must correctly handle:

- the complete PSL dataset required by the product;
- normal ICANN suffixes;
- private suffixes where uBlock-compatible party semantics require them;
- wildcard PSL rules;
- PSL exception (`!`) rules;
- Unicode IDN and equivalent punycode;
- trailing FQDN dots;
- IPv4 and IPv6;
- localhost and other single-label names;
- invalid/empty hostnames without turning them into a global scope.

Do not maintain independent incomplete domain algorithms in the service worker, compiler, popup, logger, policy resolver, firewall, or request ledger. Thin adapters over one canonical authority are fine.

## Make the complete PSL actually available to the installed runtime

Reuse the repository's existing publicsuffixlist infrastructure where practical.

The production runtime needs:

- a valid packaged baseline and/or cached last-known-good complete dataset;
- atomic PSL update/replacement through the asset lifecycle;
- no remote fetch on the per-request critical path;
- no silent fallback from complete PSL data to a small popularity table simply because an update is temporarily unavailable;
- enough revision/version state to invalidate dependent caches safely when PSL data changes.

If complete PSL initialization fails:

- do not crash filtering;
- retain last-known-good complete data when available;
- expose a truthful degraded state if only an emergency limited fallback remains;
- do not claim precise first/third-party classification when available data cannot provide it.

## Canonical request context

Party decisions must not be guessed from active-tab hostname alone.

Trace the correct semantics for:

```text
top-level origin
frame origin
initiator origin
request origin/URL
resource type
main-frame vs sub-frame
redirect chain/depth
tab/frame identity
policy revision
```

Pay special attention to:

- cross-origin/nested iframes;
- opaque or missing initiators;
- redirects across registrable domains;
- worker/worklet/service-worker-originated requests where Chromium supplies different context;
- top-level navigations;
- extension-owned documents;
- requests with no normal tab.

Where context is genuinely unknown, keep it `unknown` rather than silently coercing it to first-party.

## Focused implementation checks only

While changing this authority, add/run only narrow tests for the code changed, with representative cases such as:

```text
multi-label ICANN suffix
one wildcard PSL rule from canonical data
one PSL exception rule from canonical data
private suffix
IDN <-> punycode equivalence
IPv4
IPv6
localhost/single-label
cross-origin iframe
cross-domain redirect
```

Do not run the broad final matrix here.

### Definition of done

- production registrable-domain and first/third-party decisions use one complete canonical authority;
- full required PSL data is actually available to installed runtime or as valid last-known-good cache;
- wildcard and exception rules work;
- IDN/IP/single-label normalization is consistent everywhere;
- active-tab hostname is not substituted for missing frame/initiator context when that changes semantics;
- major consumers agree on domain/party classification;
- PSL update failure cannot erase/corrupt the previous working authority.

---

# PHASE 9 — DYNAMIC FIREWALL AND DYNAMIC URL FILTERING

These controls must affect actual DNR behavior, not only popup colors.

## Popup firewall matrix

Verify actual runtime behavior for:

```text
global vs site scope
destination host
*
image
3p
inline-script
1p-script
3p-script
3p-frame
block
allow
noop
temporary/session
permanent/save
revert
```

The exact UI rows may differ; use the rows actually shipped.

## Critical semantic rule

`noop` is not the same as `allow`.

If MV3 cannot represent a uBO noop as a direct rule, use the current canonical approach that carves/excludes broader dynamic blocks so lower static filtering remains active.

Never compile noop into unconditional allow.

## Priority interaction

Verify firewall rules against:

- static filter-list block;
- static allow;
- important;
- power-switch OFF;
- whitelist/trusted site;
- URL filtering;
- hostname switches.

## URL filtering

Logger/UI URL rules must:

- compile to real runtime rules;
- support session vs persisted behavior;
- save/revert correctly;
- survive service-worker suspension;
- not collide with firewall rule IDs.

## Dashboard Dynamic Rules editor (`dyna-rules.html`)

This is a separate user-facing path from clicking popup firewall cells. It must operate on the same authoritative rule state.

Verify end-to-end:

- permanent rules load in the permanent pane;
- temporary/session rules load in the temporary pane;
- editing temporary rules changes actual runtime behavior after Save/Apply;
- Commit copies the intended temporary changes to permanent state;
- Revert restores temporary state from the permanent state;
- importing text validates rules and does not silently convert invalid syntax into different semantics;
- exporting contains the actual permanent rules;
- filter/sort/collapse presentation never mutates the underlying rule set;
- cloud push/pull for the rules pane, when enabled, updates the editor and requires an explicit valid commit before changing runtime state if that is the UI contract;
- popup firewall edits and dashboard edits reconcile instead of overwriting each other with stale snapshots;
- service-worker suspension/restart preserves permanent rules and reconstructs intended session state correctly.

Use the same dynamic-firewall/URL-filter/hostname-switch parsers and DNR ownership ranges already used by the canonical worker. Do not invent a second rules language.

### Definition of done

- Popup color/state corresponds to actual request behavior.
- Save/Revert works.
- noop preserves lower filtering.
- URL filtering rules affect requests.
- the Dynamic Rules dashboard is a real editor, not a disconnected clone of state.
- import/export/commit/revert behave correctly.
- priorities are deterministic.

---

# PHASE 10 — PER-SITE SWITCHES

Audit every user-facing switch.

At minimum verify the currently shipped equivalents of:

```text
power / net filtering
no-popups
no-large-media
no-cosmetic-filtering
no-remote-fonts
no-scripting
```

The power switch already appears to have a real DNR allow-rule implementation. Do not rewrite it unless actual testing finds a defect.

## Required behavior

For each switch:

1. toggle temporary/session state;
2. observe actual page behavior;
3. Save/persist;
4. restart browser;
5. verify persisted state;
6. Revert;
7. verify behavior returns to permanent/default state.

## Specific expectations

### no-popups

Must actually block created navigation targets/popups according to intended scope.

Do not block legitimate same-tab navigation.

### no-large-media

Must enforce the intended media-size policy using the best available MV3/browser mechanism.

If exact uBO semantics are impossible, use an explicit documented approximation and do not pretend exact parity.

### no-cosmetic-filtering

Must stop/remove uBR cosmetic effects and prevent newly loaded cosmetics for that site.

It must not merely change the popup icon.

### no-remote-fonts

Must actually stop remote font requests under the intended scope.

### no-scripting

Must implement the currently intended script restriction safely and reversibly.

Do not break extension scripts themselves.

### Definition of done

- Every visible switch has observable behavior.
- state in popup equals runtime state;
- persistence works;
- revert works;
- switches do not leave orphan DNR/CSS/script state.

---

# PHASE 10A — TRUSTED SITES / WHITELIST EDITOR END-TO-END

The dashboard exposes `whitelist.html` as a first-class Trusted Sites/whitelist editor. This path is not fully covered by merely testing the popup power switch.

Trace:

```text
platform/chromium/whitelist.html
src/js/whitelist.ts
platform/chromium/js/sw.js dashboard getWhitelist/setWhitelist handlers
power-switch / policy-allow DNR synchronization
managed whitelist/blocklist policy
```

## Required behavior

Verify:

- hostname directives disable filtering only for the intended hostname/scope;
- supported URL/regex whitelist directives retain their intended matching semantics;
- invalid directives are rejected/highlighted and cannot be committed as silently different rules;
- Apply updates real browser behavior;
- Revert restores the last committed editor state;
- import merges text safely and does not erase existing directives unless the UI explicitly asks to replace;
- export reflects the actual committed whitelist text;
- cloud push/pull works when cloud storage is enabled;
- removing a trusted-site directive restores filtering;
- a popup power-switch persistent OFF state and the Trusted Sites editor reconcile to one authoritative persistent state or have a clearly defined precedence;
- temporary/page-scoped power-switch OFF state does not accidentally become a permanent whitelist entry;
- network, cosmetic, scriptlet, redirect, firewall, URL-filter, CSP-report, and other lower filtering layers all obey the trusted-site bypass according to intended semantics;
- managed `blocklist` policy can force filtering even when a user whitelist entry exists;
- managed `whitelist` policy cannot be silently removed by the user;
- changes invalidate/recompute page policy and toolbar/popup state for affected tabs.

Do not implement whitelist behavior by sprinkling independent `if (hostname...) return` checks through each subsystem. Use the existing allow-rule authority/page-policy/state synchronization.

### Definition of done

- Trusted Sites editor changes actual filtering.
- imports/exports/cloud are coherent.
- temporary and permanent OFF states are not confused.
- managed policy precedence is correct.
- removing trust reliably restores filtering.

---

# PHASE 11 — ELEMENT PICKER AND ZAPPER END-TO-END

There are service-worker compatibility handlers that may return an "unsupported/use frontend helper" response. That is NOT automatically a bug if the active popup frontend launches the MV3 picker/zapper directly.

Trace the real click path before editing.

## Element picker

End-to-end behavior:

1. user clicks picker;
2. picker opens on current normal web page;
3. hovering/highlighting works;
4. preview works;
5. created filter is sensible and scoped;
6. Create saves the filter;
7. the filter becomes effective immediately or after the expected reload;
8. it appears in My Filters;
9. restart preserves it;
10. deleting the filter restores the element.

Support ordinary elements first.

Then verify:

- dynamically inserted elements;
- iframes where permitted;
- shadow DOM only where the current architecture intends to support it.

Do not turn this into a huge selector-generation optimization project.

## Zapper

Zapper is temporary.

It should:

- remove the selected element immediately;
- not persist a permanent filter;
- exit cleanly;
- not leave page-wide click interception after closing.

### Definition of done

- Picker actually produces a working persistent filter.
- Zapper actually removes an element temporarily.
- No invisible overlay remains.
- No service-worker "unsupported" fallback breaks the active frontend path.

---

# PHASE 12 — DOCUMENT / STRICT BLOCKING

If the extension exposes a blocked-document/interstitial page, verify it using real main-frame blocking.

## Behavior

A main-frame rule intended for strict blocking should:

- stop the navigation according to supported MV3 semantics;
- present the correct blocked-page information if the product implements an interstitial;
- display the target URL safely;
- allow the intended temporary/permanent proceed path;
- not create a redirect loop;
- not permanently whitelist a site when the user only requested one-time proceed;
- preserve query/fragment behavior as intended when returning to the destination.

## Document exceptions

Verify:

```text
@@...$document
@@...$doc
```

and any current aliases compile to the correct `allowAllRequests` behavior when required.

Do not miscompile document exceptions as a main-frame-only plain allow if that changes semantics.

### Definition of done

- Strict/document blocking is observable.
- Proceed paths work.
- no loops;
- document exceptions work correctly.

---

# PHASE 13 — LOGGER, REQUEST COUNTS, AND FILTER ATTRIBUTION

The logger must describe actual browser decisions, not simulated decisions.

## Verify event sources

Use actual DNR match feedback and the existing request/navigation accounting.

Verify logger entries for:

```text
static block
dynamic block
session block
allow
allowAllRequests where visible
redirect
redirect-rule
removeparam/transform where supported
firewall
URL filtering
cosmetic filter
scriptlet where the UI represents it
```

## Logger control plane

The shipped logger is more than a passive event table. Verify the current user-reachable controls end-to-end:

```text
page selector: all / current tab / selected tab / behind-the-scenes where supported
refresh selected tab
pause / unpause
clear / clean
row filtering and built-in filter expressions
export/copy
logger settings
embedded popup for selected tab
DOM inspector
entry details
dynamic URL-rule editing
static filter creation
cosmetic filter creation
filter finder / list source lookup
Code Viewer links
```

Requirements:

- selecting a tab changes the logger/inspector context without leaking actions to another tab;
- pause stops presentation/collection according to the intended product contract and resumes without duplicated rows;
- Clear/Clean operate on the intended logger state, not only the visible DOM;
- export reflects the currently intended entries/selection and does not leak unrelated private-tab data;
- opening the embedded popup uses the selected tab context and cannot mutate another arbitrary tab through spoofed IDs;
- creating a static network filter from a logger row goes through the canonical My Filters compiler/transaction path;
- creating a cosmetic filter from the logger/DOM inspector goes through the canonical user-cosmetic path;
- created filters become effective and persist exactly as if created in My Filters;
- filter-finder/list attribution uses the same reverse index as logger attribution and Asset Viewer.

## DOM inspector

Verify:

- inspector injection targets only the selected eligible web tab;
- full and incremental DOM updates work without accumulating duplicate connections/observers;
- changing/reloading/closing the selected tab disconnects stale ports cleanly;
- preview toggles are temporary until the user commits/creates a filter;
- Revert/close restores temporary DOM/cosmetic preview state;
- creating cosmetic filters writes valid user filters and leaves no orphan preview mutations;
- the inspector does not expose privileged extension messaging to page scripts.

## Code Viewer

Logger request URLs can open `code-viewer.html`. Verify this path as a real product tool.

The viewer may need a temporary uBR-owned DNR allow/fetch rule so it can inspect a resource that uBR itself would otherwise block. That exception must be narrowly scoped.

Required behavior:

- only valid `http:`/`https:` resources are accepted;
- temporary allow rules are scoped to the exact viewer fetch as tightly as the current DNR design permits;
- only the actual extension Code Viewer page can acquire/release those privileged temporary rules;
- a website/content script cannot spoof the message and obtain an arbitrary allow rule;
- the temporary rule uses the central ID authority/range and cannot collide with filtering, firewall, whitelist, or other rule families;
- the rule is released in `finally` on success, HTTP error, read failure, navigation, and abort;
- orphaned viewer rules are bounded/cleaned after viewer close or service-worker lifecycle interruption;
- opening a blocked script in Code Viewer does **not** permanently weaken normal page filtering;
- fetches use no unnecessary referrer/credentials and enforce the existing size bound;
- cached viewer documents/history remain bounded;
- following discovered `href`/`src` links keeps the same URL/safety restrictions.

## Matched Rules page — known current backend stub

`matched-rules.html` is shipped and promises recent DNR attribution evidence. Complete it.

Current audit flags to verify/fix:

- `getMatchedRuleInfo` in the canonical service worker currently returns an empty `matches` array unconditionally;
- the UI's API accepts a `tabId`, but current refresh logic calls it without one;
- the page's Clear button currently clears only rendered rows;
- the service worker already maintains a bounded `matchedRuleLogByTab` / matched-rule log and reverse attribution state, so do not create a second event ledger.

Required behavior:

1. resolve a concrete target tab from URL/query context or the active normal page according to the page's intended launch path;
2. retrieve recent entries for that tab and `sinceMs`;
3. enrich entries using the existing DNR reverse index/source-map ownership data;
4. display truthful:
   - time;
   - source list/user/dynamic owner;
   - source line when known;
   - original filter when known;
   - ruleset/rule ID;
   - compiled action;
5. dynamic/session/user rules that do not have a static source-map entry must be labeled truthfully rather than attributed to the wrong list;
6. unknown IDs must remain `unknown`/unattributed, not guessed;
7. Clear must either clear the authoritative per-tab recent matched-rule log or be relabeled to mean "clear view" if that is genuinely intended;
8. tab close must clean the corresponding log;
9. retained history stays bounded.

### Build ownership — known current gap

The current live page loads:

```text
platform/chromium/js/matched-rules.js
```

while `src/js/matched-rules.ts` exists but is not currently listed in `build.mjs`.

Resolve that before considering the feature fixed. Preferred outcome:

```js
'src/js/matched-rules.ts': `${OUT_DIR}/matched-rules.js`,
```

or an equivalent explicit canonical build mapping.

Do not patch only the TypeScript source while leaving the live JS stale.
Do not manually maintain two divergent implementations.

## Attribution

When the UI says a rule came from a particular list:

- the list must actually contain/own that compiled rule;
- reverse lookup must handle static sharding;
- dynamic/user rules must not be misattributed to EasyList;
- rule-ID ranges must be interpreted using the actual ownership map.

## Popup counts, domains, badge, and warnings

The shipped popup exposes multiple pieces of runtime information. Treat all of them as browser truth, not decoration.

Verify:

- blocked/allowed counts update during navigation;
- the same DNR event is not counted twice;
- counts reset/roll over at the intended page boundary;
- SPA navigation follows the current intended page-count semantics;
- the popup does not claim blocks that never happened;
- **Domains connected** is derived from actual observed request domains and is not stale from a previous page;
- **Blocked since install** uses a clearly defined persistent counter and does not jump due to duplicate logger/accounting events;
- `showIconBadge` actually controls toolbar badge visibility;
- when badge display is enabled, badge count agrees with the popup's authoritative page blocked count within the intended timing model;
- toolbar icon/title reflect whether filtering is ON/OFF for the active site and do not remain stale after navigation;
- the toolbar action is handled safely on non-filterable pages such as browser-internal URLs;
- the **unprocessed request warning** appears only when the runtime genuinely could not process/attribute a request according to its intended condition;
- dismissing the warning clears the intended current-tab warning state without globally hiding future real warnings;
- tab close/navigation cleans up popup ledger/warning state without leaking it to reused tab IDs.

Do not polish logger CSS unless it prevents use.

### Definition of done

- Logger matches real DNR outcomes.
- Logger controls and DOM inspector act on the intended tab and clean up correctly.
- Static/cosmetic filters created from logger tools use the canonical user-filter path.
- Code Viewer cannot leave a persistent filtering bypass.
- Matched Rules shows actual recent per-tab DNR matches instead of a permanent empty stub.
- Attribution is credible.
- Popup counts/domains/badge/warnings are not inflated, duplicated, or stale.
- toolbar state tracks the active tab correctly.
- opening/closing logger does not alter blocking behavior.

---

# PHASE 14 — SPA NAVIGATION, IFRAMES, ABOUT:BLANK, AND PAGE POLICY LIFECYCLE

After removing hardcoded site exclusions, generic lifecycle correctness matters.

Test multiple complex SPAs, not only ChatGPT.

## SPA navigation

For `pushState`, `replaceState`, history navigation, and framework route changes:

- per-page policy must remain coherent;
- cosmetic filtering must continue on new DOM;
- page-scoped temporary state must not leak incorrectly to unrelated routes;
- popup must show the current page state;
- logger/popup counts should follow intended navigation boundaries;
- first-party/video detectors must not duplicate themselves every route change.

Do not add a hardcoded domain list to solve generic SPA lifecycle bugs.

## Frames

Verify:

- same-origin iframe;
- cross-origin iframe;
- about:blank child frame;
- srcdoc frame where supported;
- frame hostname/effective origin scoping.

Cosmetic/scriptlet/network scope must not incorrectly inherit a domain when it should not.

## Page-policy reconciliation

The current content script gathers page signals and requests activation policy.

### Document-start policy must be provisional

The main content script runs at `document_start`. At that time, queries such as:

```text
password/auth form present?
payment/card form present?
contenteditable present?
large app root present?
primary video present?
```

can all be false simply because the DOM has not been parsed yet.

The current classifier maps an ordinary no-signal page to `default-web`, while `default-web` enables substantially more content-side capability than `app-shell`/auth/payment profiles.

Do **not** treat "signal not found at document_start" as strong negative evidence.

Implement/verify a two-stage policy contract:

1. **provisional early policy** — safe enough to run before the DOM is reliable;
2. **resolved DOM-ready policy** — promotes a genuinely ordinary page to normal/full behavior or keeps/downgrades a sensitive/complex page appropriately.

Requirements:

- global DNR/network blocking must not be accidentally disabled merely because content-side policy is provisional;
- safe early specific cosmetic work may run if the architecture supports it;
- do not start invasive generic/procedural/smart/video/wrapper/mutation layers solely from missing early DOM signals;
- promotion at DOM-ready must start newly allowed layers exactly once;
- downgrade/reclassification must stop or undo owned temporary content-side effects where possible;
- no irreversible wrapper/hook should be installed under a provisional policy unless it is also valid under every possible resolved policy;
- page-policy diagnostics must distinguish provisional from resolved state so a lower layer cannot mistake one for the other;
- policy request failure must fail usable/conservative rather than blanking the page.

Then make sure ongoing policy reconciliation:

- happens at useful times;
- can handle DOM becoming more app-like after initial document start;
- does not instantiate duplicate observers/hooks;
- can deactivate layers cleanly when policy changes;
- does not leave stale CSS or wrappers.

## Special, restricted, and non-filterable URL schemes

Define one truthful eligibility policy instead of letting each popup/tool/command guess.

Audit at least:

```text
http:
https:
chrome://
chrome-extension://
devtools://
view-source:
file:
data:
blob:
about:/about:blank where child-frame inheritance is relevant
browser new-tab URL
```

Requirements:

- normal site controls operate only where Chromium can actually enforce them;
- unsupported pages expose disabled/non-applicable controls rather than writing state against an empty hostname;
- no site toggle may become global because hostname extraction returned `""`;
- picker, zapper, logger, context-menu, and keyboard actions fail safely on restricted pages;
- strict/document blocking never hijacks browser-internal or extension-owned documents;
- extension pages are not treated as ordinary web content for site-policy inheritance;
- custom new-tab handling remains limited to intended new-tab flow;
- if `file:` filtering is intentionally supported, account for Chrome's user-controlled file-URL access and make availability truthful;
- if `file:` is unsupported, do not expose a placebo site-filtering state.

### Definition of done

- common SPA route changes retain blocking;
- document-start absence of DOM signals never grants an unjustified permissive content-side policy;
- normal ordinary pages are promoted to full intended behavior once classification is reliable;
- auth/payment/contenteditable/app-shell pages do not briefly receive invasive layers before downgrade;
- no duplicate engines/observers;
- frame scoping is correct;
- no broad domain bypasses;
- policy failure leaves page usable.

---

# PHASE 15 — YOUTUBE / VIDEO AD-BLOCKING REAL-BEHAVIOR PASS

The repository already has extensive YouTube/video-specific code.

Do not rewrite it simply because it is large.

Test it as a user.

## YouTube matrix

Verify at least:

```text
normal watch page
SPA navigation between videos
home -> watch
search -> watch
Shorts
embedded player if supported
live stream if accessible
logged-out behavior
logged-in behavior if available
player controls
captions
quality selector
fullscreen
theater mode
comments
search box / masthead
```

## Blocking behavior

Look for:

- video ads;
- masthead ads;
- companion ads;
- promoted panels;
- anti-adblock overlays;
- blank player;
- infinite spinner;
- video skipping incorrectly;
- audio continuing while video is hidden;
- player API wrappers that remain after navigation;
- multiple wrappers being installed on every SPA route.

## Safety

Do not achieve "no ads" by breaking the player.

Do not hide broad YouTube containers such as masthead/player application roots.

Keep protected UI safeguards.

## Generic video / other players

Verify the generic video interception and any Fluid Player hardening on at least a small number of representative fixture/player cases.

Do not hardcode a dozen random piracy sites.

Fix generic mechanics or existing targeted engines.

### Definition of done

- YouTube remains usable.
- blocking survives SPA navigation.
- no persistent blank/spinner state introduced by uBR.
- wrappers/observers are not duplicated.
- generic video functionality does not regress unrelated pages.

---

# PHASE 16 — FIRST-PARTY / HEURISTIC AD DETECTION SAFETY

The extension includes first-party DOM/ad detection and smart/policy-based behavior.

These heuristics can create severe false positives if over-aggressive.

## Verify

On representative pages containing:

```text
article layouts
large SPA roots
contenteditable editors
login forms
payment forms
video pages
normal first-party promotional content
```

ensure heuristic layers do not:

- delete login controls;
- delete payment controls;
- hide editors;
- hide entire app roots;
- remove navigation;
- classify every sponsored-looking word as an ad;
- repeatedly mutate the same node.

## Smart cosmetic/runtime path

The canonical worker and build include a smart rule engine and `smart-content.js`, and page policy can request `loadSmartRuntime`.

Do not invent a new user UI for this if none is shipped. Instead verify the production path that already exists:

- when page policy says `loadSmartRuntime = true`, the worker injects the intended smart content runtime into the correct frame/world;
- the injected runtime obtains only the rules/plan relevant to the page;
- selectors/mutations go through the same safety/risk constraints as other cosmetic layers;
- policy reconciliation does not inject duplicate smart runtimes after SPA navigation or DOM-ready reconciliation;
- disabling/deactivating the layer tears down or stops future mutations as intended;
- stored/subscribed smart-rule collections are used only if some current production path actually exposes/enables them;
- if smart-rule management endpoints are unreachable/dead in the shipped UI, do not spend time polishing them—either keep them internal and safe or remove clearly dead production wiring if it creates risk.

## Positive behavior

Use controlled fixtures containing first-party ad-like markup and verify that the detector can still remove/neutralize content it is supposed to detect.

### Definition of done

- useful first-party detection still exists;
- false positives on critical UI are controlled;
- policy/risk guards are generic;
- no whole-site bypass is used as a shortcut.

---

# PHASE 17 — SERVICE-WORKER SUSPENSION, BROWSER RESTART, EXTENSION UPDATE

MV3 service workers are ephemeral.

A blocker that works only until the service worker sleeps is broken.

## Install/startup/update lifecycle

Trace the actual handlers for:

```text
chrome.runtime.onInstalled
chrome.runtime.onStartup
alarms
storage change listeners
registered content-script/scriptlet reconciliation
any uBR deactivation/shutdown path that is user-reachable
```

Verify:

- fresh install initializes defaults exactly once;
- startup does not repeatedly overwrite user settings with defaults;
- update migrations run once per required schema transition;
- startup reconciliation is idempotent;
- registered document-start scriptlet content scripts are synchronized without accumulating duplicate registrations;
- context menus and update alarms are restored according to saved settings;
- a startup failure enters a recoverable/degraded state rather than silently declaring readiness with no filtering.

## Suspension/resume

Exercise the extension after the service worker has been idle/suspended.

Verify:

- popup opens with correct state;
- selected lists still apply;
- dynamic firewall still applies;
- per-site permanent switches still apply;
- session state behaves according to Chrome session semantics;
- logger can restart cleanly;
- content scripts can reconnect;
- no duplicate DNR rules are created;
- scheduled list updates still fire after normal MV3 suspension/resume;
- long-lived pages survive page-activation/capability-token expiry and can obtain a fresh valid policy/token without losing filtering or duplicating observers/hooks.

## Full browser restart

Verify:

- dynamic rules persist as Chrome promises;
- session rules that do not survive restart are rebuilt/reconciled when required;
- adaptive overflow baseline is rebuilt;
- committed filter state is validated;
- user filters remain active;
- filter list selection remains active;
- permanent hostname switches/firewall/URL rules are restored;
- stale page-scoped tab entries are not resurrected for unrelated tabs.

## Extension update/schema change

Use the existing schema/version/migration mechanisms.

Verify:

- old owned rule ranges are removed when schema requires it;
- rules belonging to unrelated subsystems are not deleted;
- IndexedDB generations are reconciled;
- interrupted migration does not permanently disable blocking;
- rollback/degraded mode is safe and recoverable.

Do not create destructive "clear all DNR rules" logic that can remove rules owned by other current uBR subsystems.

## Tab lifetime, replacement, BFCache, discard, and prerender

The runtime owns tab/frame-scoped ledgers, counters, policy snapshots, session rules, and temporary controls. Their lifetime must remain correct independently of service-worker lifetime.

Audit:

```text
tab close
tab replacement
tab ID reuse
top-level navigation
frame navigation/removal
discard -> restore
BFCache pagehide/pageshow
prerender -> activation where Chromium exposes it
```

Requirements:

- tab removal clears tab-scoped request ledgers, counters, page-policy snapshots, page-scoped power state, temporary firewall state, and owned tab-specific session DNR rules where applicable;
- a reused tab ID must never inherit page-specific state from an unrelated prior tab/page;
- top-level navigation clears only old page/document-scoped state while preserving legitimate permanent hostname rules;
- stale frame IDs are discarded after navigation;
- BFCache restore must not duplicate content observers/engines;
- restored pages revalidate policy/state that may have changed while cached;
- prerendered pages must not prematurely mutate visible-tab state;
- prerender activation reconciles exactly once;
- a tab closing during async DNR/storage/message work must not leave orphaned state/rules.

Only add/run focused lifecycle checks for state changed here. Leave the broad matrix to the final pass.

### Definition of done

- Sleeping the SW does not break the extension.
- Browser restart restores intended behavior.
- update/migration cannot leave a permanently half-initialized blocker.
- no duplicate/colliding rule state accumulates.

---

# PHASE 18 — SETTINGS, PRIVACY CONTROLS, ADVANCED SETTINGS, AND PLACEBO AUDIT

Only do this after the core blocking paths above are solid.

The shipped `settings.html` exposes real functional settings. Audit them explicitly rather than using a generic "settings" pass.

## Functional settings currently exposed

Trace and verify the exact current list, including at minimum:

```text
showCustomNewTab
collapseBlocked
showIconBadge
contextMenuEnabled
cloudStorageEnabled
prefetchingDisabled
hyperlinkAuditingDisabled
webrtcIPAddressHidden (when Chromium reports the capability)
stealthModeEnabled
noCSPReports
cnameUncloakEnabled
noCosmeticFiltering
noLargeMedia
largeMediaSize
noRemoteFonts
noScripting
advancedUserEnabled
autoUpdate
suspendUntilListsAreLoaded
ignoreGenericCosmeticFilters
popup section / firewall-pane settings if still exposed
```

Appearance-only settings such as theme/accent/color-blind mode/tooltips should persist and render correctly, but do not spend P1/P2 engineering time polishing their visual details.

## Generic functional-setting contract

For every non-appearance setting:

1. load the authoritative value;
2. change it in UI;
3. verify the runtime operation actually succeeds;
4. if runtime application fails, roll the UI back rather than displaying a value that was not applied;
5. verify persistence/restart behavior;
6. verify service-worker cold-start reconciliation;
7. verify the setting does not require a clean install to take effect;
8. ensure external/managed control is represented honestly.

A control must not exist as a placebo.

## `collapseBlocked` — specific suspected gap

The current DOM-collapser implementation appears to hide blocked `img`, `iframe`, `video`, `object`, etc. after receiving the blocked-resource ledger without obviously checking `collapseBlocked`.

Trace the full path and fix it if confirmed.

Required semantics:

- `collapseBlocked = true`: blocked resource elements are collapsed/hidden according to current product behavior;
- `collapseBlocked = false`: uBR must not hide/collapse the DOM element merely because its resource was network-blocked;
- changing the setting affects new decisions promptly and does not leave stale collapse CSS/tokens indefinitely;
- this setting must not accidentally disable network blocking itself.

Do not fake this by hiding the Settings checkbox.

## Browser privacy settings

For:

```text
prefetchingDisabled
hyperlinkAuditingDisabled
webrtcIPAddressHidden
```

verify actual `chrome.privacy` behavior where Chromium supports it.

Handle browser policy / another extension controlling a privacy setting. If `chrome.privacy.*.set()` cannot take control, return failure and restore/disable the UI appropriately rather than storing a false successful value.

Do not claim WebRTC IP hiding on a browser configuration where the required privacy control is unavailable.

## Stealth mode

Verify `stealthModeEnabled` controls the actual stealth-surrogate/session-rule path and survives restart. Turning it off must remove only uBR-owned stealth rules; turning it on must reinstall the intended current rules without duplicates or ID collisions.

## CSP-report control

Verify the Settings-level `noCSPReports` default and per-site hostname switch interaction use the same precedence model and actual DNR/session rules.

## `cnameUncloakEnabled` — specific suspected placebo

Do not leave this as a stored boolean with no behavior.

First determine whether the current supported Chromium MV3 APIs and architecture provide enough information to implement the intended CNAME-uncloaking semantics faithfully.

If faithful implementation is feasible, implement it with bounded caching, correct request-domain attribution, and no remote executable code.

If it is **not** feasible in the supported Chromium MV3 target:

- disable/hide the control or mark it explicitly unsupported in Chromium;
- preserve old stored values safely but do not present them as active protection;
- do not invent fake DNS answers;
- do not send user browsing hostnames to an external DNS service merely to make the toggle appear functional.

## Dashboard shell and unsaved-change protection

The production dashboard is an iframe/tab shell around Settings, Filter Lists, My Filters, Dynamic Rules, Trusted Sites, and About.

Verify:

- every production dashboard tab loads the intended current page/bundle;
- switching tabs does not leave stale loading/disabled state;
- unsaved edits in My Filters, Dynamic Rules, and Trusted Sites trigger the existing unsaved-warning flow before the iframe/pane is discarded;
- **Stay** keeps the current pane and edits intact;
- **Ignore/Discard** changes pane without accidentally committing the edits;
- saving/reverting removes the unsaved warning condition;
- direct dashboard navigation/hash/query handling, where supported, selects the right pane;
- opening Advanced Settings or other dashboard subpages does not bypass unsaved protection unexpectedly;
- managed/no-dashboard state, if current policy can invoke it, prevents dashboard access through the same authoritative policy rather than only hiding one tab button.

Do not spend time redesigning the dashboard UI.

## Advanced Settings page

The dashboard exposes `advanced-settings.html`.

Verify:

- current hidden/advanced settings load;
- valid edits persist;
- invalid key/value syntax is rejected safely;
- changing a setting that is consumed at runtime actually updates/reconciles the relevant subsystem or clearly states reload requirement;
- unknown keys do not silently create dead settings;
- reset/default behavior is coherent;
- advanced settings cannot bypass scriptlet/remote-code safety guarantees.

### Definition of done

- no functional Settings control is a placebo;
- `collapseBlocked` behavior is real;
- CNAME control is either real or honestly unavailable;
- privacy settings report/apply authoritative browser state;
- advanced settings are connected to runtime;
- appearance settings persist without consuming disproportionate engineering time.

---

# PHASE 19 — BACKUP, RESTORE, RESET, IMPORT/EXPORT, AND CLOUD STATE

The Settings page exposes full local-data backup, restore, and reset. Multiple dashboard panes also expose import/export and cloud widgets. These are functional state-management paths, not convenience polish.

## Full backup

Trace `backupUserData` and verify the exported data represents all important **user-owned persistent configuration**, including the currently supported equivalents of:

```text
user settings
selected/imported filter lists
My Filters
Trusted Sites / whitelist
permanent firewall rules
permanent hostname switches
permanent URL-filtering rules
advanced/hidden settings where intended
custom new-tab preference/default search where intended
other user-created blocker state
```

Do not blindly export transient tab/session state, stale transaction journals, replaceable caches, or private browsing history merely because `chrome.storage.local.get(null)` can see them.

If the current backup format intentionally contains cache data for speed, ensure restore validation treats it as untrusted/rebuildable and never lets stale cache metadata become authoritative over committed rule state.

## Restore

A backup file is semi-trusted input.

Verify:

- structural validation and total-size limits;
- unknown/dangerous keys are rejected;
- restore handles older supported backup schemas through explicit migration;
- restore is transactional enough that malformed data or a DNR failure cannot destroy the current working configuration;
- after a successful restore, all dependent runtime layers are reconciled: static rulesets, dynamic/session DNR, filter-list commit state, cosmetics, scriptlets, redirects, firewall, URL filtering, Trusted Sites, hostname switches, update alarms, context menu/new-tab/privacy settings as applicable;
- restart after restore yields the same effective state;
- restore does not execute arbitrary scriptlet/JavaScript content from the backup.

## Reset user data

Verify Reset:

- clears all user-owned persistent configuration according to the product contract;
- removes/rebuilds uBR-owned DNR rules to clean defaults;
- clears obsolete IndexedDB generations/caches/journals that must not survive reset;
- clears user cosmetics/scriptlets/rules/whitelist/firewall state;
- restores default list selection/settings;
- removes stale context/new-tab/stealth/session effects as required;
- leaves the extension immediately usable without reinstalling it;
- never deletes data belonging to other extensions or unrelated browser storage.

## Per-pane import/export

Verify import/export for:

```text
My Filters
Trusted Sites
Dynamic Rules
third-party/custom list URLs where exposed
```

Imported text must be validated by the same authoritative parser used for direct editing. Export must contain committed data, not a stale UI buffer.

## Cloud storage

Before changing cloud behavior, establish source ownership for the actual widget code.

Current audit shows:

```text
maintained source: src/js/cloud-ui.js
live user-facing file: platform/chromium/js/cloud-ui.js
template/fragment: platform/chromium/cloud-ui.html
current build.mjs: does not explicitly regenerate/copy js/cloud-ui.js
```

Fix that reproducibility gap first or as part of the first cloud change. Prefer a single canonical source plus a deterministic build/copy step; do not maintain two independent cloud implementations.

When `cloudStorageEnabled` is on, verify cloud widgets for the panes that expose them, including at least:

```text
My Filters
Trusted Sites
Dynamic Rules
Filter Lists
```

Verify:

- `chrome.storage.sync` is used only when available/appropriate;
- quota errors are handled without losing local data;
- any local fallback mode is clearly intentional and not falsely described as cross-device sync;
- push/pull timestamps/data keys are coherent;
- append vs replace semantics are correct for each pane;
- pulling data does not silently activate invalid rules;
- cloud disabled means no background cloud writes;
- service-worker restart does not corrupt pending cloud state.

### Definition of done

- backup/restore/reset are safe and complete;
- per-pane import/export is authoritative;
- cloud behavior is real and honest;
- no restore/reset path leaves Chrome DNR state disagreeing with storage/UI.

---

# PHASE 20 — KEYBOARD COMMANDS, CONTEXT MENUS, CUSTOM NEW TAB, AND TOOLBAR INTEGRATION

The manifest advertises these keyboard commands. Verify every current command end-to-end:

```text
launch-element-zapper
launch-element-picker
launch-logger
open-dashboard
relax-blocking-mode
toggle-cosmetic-filtering
toggle-javascript
toggle-newtab
```

For each command:

- operate on the active eligible tab only;
- fail safely on browser-internal/non-filterable tabs;
- use the same authoritative state transition as the equivalent popup/dashboard control;
- update popup/icon state;
- persist only when the command's intended semantics are persistent;
- do not create duplicate picker/zapper overlays;
- do not throw if the active tab closes mid-command.

## `relax-blocking-mode`

Verify each relaxation level uses the existing power/hostname-switch/firewall semantics rather than a parallel fake state. Repeated use should progress exactly as intended and page reload should reflect the new effective blocking mode.

## Context menus

The Settings page exposes `contextMenuEnabled`, and the canonical worker creates user actions including element blocking and logger access.

Verify:

- enabled state installs the expected current items exactly once;
- disabled state removes only uBR's context menu items;
- service-worker restart restores the intended menu state;
- Block element launches the real picker on the correct tab/context;
- logger action opens the logger with the appropriate tab context;
- stale/closed tabs fail safely;
- no duplicate menu items accumulate across install/update/startup.

## Custom new tab

The project ships `platform/chromium/pages/newtab.html` and `platform/chromium/js/newtab.js` and exposes both a Settings toggle and `toggle-newtab` command.

Verify:

- enabling the feature redirects newly created Chrome new-tab pages to the extension new-tab page using the intended current mechanism;
- ordinary tabs/navigations are never hijacked;
- disabling the feature stops interception and an already-open uBR new-tab page can return to normal Chrome new tab according to current behavior;
- cold service-worker startup does not produce redirect loops or flicker loops;
- the new-tab page checks the authoritative enabled setting before remaining active;
- choosing a search provider works;
- setting a default provider persists;
- queries are URL-encoded correctly;
- submit navigation opens only the selected provider URL built from packaged data;
- the runtime message used to navigate a search validates that the sender is the packaged new-tab page so arbitrary websites cannot use it as a privileged open-redirect/navigation primitive;
- no remote scripts or tracking code are introduced into the extension new-tab page;
- links/tool dropdowns remain functional without requiring unsafe page permissions.

### Definition of done

- every manifest-advertised command works;
- context menu enablement is real;
- custom new-tab toggle/search/default-provider behavior works without hijacking unrelated tabs;
- equivalent controls share authoritative state.

---

# PHASE 21 — MANAGED ENTERPRISE POLICIES AND INCOGNITO/SPLIT-MODE BEHAVIOR

The active manifest declares a managed-storage schema and `incognito: "split"`. Treat these as shipped behavior.

## Managed policy

Verify every current `managed_schema.json` key:

```text
blockedLists
forcedLists
disableFiltering
disableCosmeticFiltering
disableLogger
whitelist
blocklist
```

Required behavior:

- forced lists remain selected/effective even when the user tries to disable them;
- blocked lists cannot be enabled by the user;
- managed list entries resolve consistently whether policy specifies the supported URL/key form;
- `disableFiltering` actually disables the relevant filtering layers and restores the previous user configuration when policy is removed;
- `disableCosmeticFiltering` disables cosmetics without silently disabling unrelated network filtering;
- `disableLogger` makes logger availability honest and does not merely hide UI while still collecting prohibited data;
- managed whitelist forces trust according to policy;
- managed blocklist forces filtering even against user trust/power-switch state;
- policy precedence is deterministic and centralized;
- live managed-storage changes reconcile current DNR/CSS/scriptlet state without reinstall;
- removal of policy restores the user's prior persistent configuration instead of defaults or stale managed state;
- UI indicates/locks managed values where a user control cannot take effect.

## Incognito split mode

When the user enables the extension for incognito, verify the actual Chromium split-mode behavior:

- filtering works in incognito tabs;
- regular and incognito service-worker/tab/session ledgers do not confuse tab IDs or page state;
- session-only power/firewall/URL-filter state from an incognito tab does not unexpectedly appear on a regular tab;
- persistent configuration sharing follows Chromium extension-storage semantics intentionally rather than accidentally duplicating/corrupting state;
- logger/popup do not retain private tab URLs/history into regular long-lived accounting beyond the product's intended privacy contract;
- closing the incognito session cleans its ephemeral tab/session state;
- managed policy applies consistently in incognito where Chromium exposes it;
- scriptlet/content-script registration remains correct in the split context.

Do not attempt to bypass Chrome's incognito permission model.

### Definition of done

- managed policy cannot be overridden accidentally by user UI;
- policy removal restores user state;
- incognito filtering works without cross-context session leakage.

---

# PHASE 22 — FINAL PRODUCTION BUILD / PACKAGE RUNTIME SANITY

This is not a CI/certificate exercise. It is a last check that the product you would actually install contains the code you just fixed.

After implementation is complete but **before** the independent full test pass:

1. perform the normal production build from source;
2. verify generated bundles that should change were regenerated from their canonical source;
3. verify manually maintained canonical files such as `platform/chromium/js/sw.js` were not accidentally overwritten by prototype output;
4. verify every manifest-referenced JS/CSS/HTML/ruleset/resource exists in the built package;
5. for every user-reachable HTML/support page, verify every loaded live JS file has one known canonical source and is either generated/copied by `build.mjs` or explicitly documented as manually canonical;
6. specifically verify the known Matched Rules ownership gap is resolved: `src/js/matched-rules.ts` must actually produce the live `platform/chromium/js/matched-rules.js` (or the duplicate source must be eliminated with a single clear owner);
7. specifically verify the live Cloud UI has deterministic ownership: `src/js/cloud-ui.js` must produce/copy the live `platform/chromium/js/cloud-ui.js`, or one clearly documented canonical implementation must replace the duplication;
8. inspect other live helper modules loaded directly by user pages (for example `js/theme.js`) for the same source/live/build drift pattern; fix ownership where real, but do not rewrite a working helper merely to change file style;
9. verify web-accessible-resource paths used by picker/zapper/logger/redirects exist;
10. load the final built `platform/chromium` extension fresh in Chromium;
11. confirm no manifest errors, missing-module errors, failed imports, or immediate service-worker exceptions;
12. verify no development-only/test-only blocking rules, fixtures, debug permissions, or localhost bypasses were accidentally shipped;
13. verify About/runtime version display agrees with the installed manifest version;
14. verify the default English locale contains the i18n keys required by active user-facing production pages so controls do not render as `_`, blank labels, or raw key names;
15. do **not** turn this into a translation-completeness project for every locale unless a locale change is directly required by functionality being fixed;
16. perform one short fresh-profile smoke of the highest-value functionality only. Do not start the broad final test suite here.

Do not turn this phase into release-badge work or GitHub Actions work.

### Definition of done

- the final installable artifact contains all implementation fixes;
- no source/generated drift causes the shipped extension to differ from what was fixed;
- final package loads cleanly on a fresh profile.

---

# PHASE 23 — FINAL REAL-WORLD FILTER-CORPUS DIFFERENTIAL AUDIT

This is the final behavior gap finder.

Do not make it a certificate/benchmark exercise.

Use it to discover actual blocking misses.

## Corpus comparison

For a representative set of network requests/filter lines from the active lists:

Classify each as:

```text
correctly compiled
correctly quarantined as impossible/unsupported
incorrectly compiled
silently ignored
supported by one path but rejected by another
```

Priority is the last three categories.

## Browser behavior sample

Use a modest but diverse set of real sites/pages:

```text
news/article site
video site
SPA
shopping/content-heavy site
site with third-party trackers
site with consent/overlay advertising
site with many iframes
simple static page
```

Do not spend days building a giant benchmark.

Look for:

- obvious ads;
- trackers visible in logger;
- empty ad containers not cosmetically hidden;
- page breakage caused by uBR;
- filter-list exceptions not honored;
- site OFF switch not honored;
- duplicate blocking/accounting;
- filters shown as compiled but ineffective.

## Fix ranking

If new gaps are found, rank:

```text
P0 page broken / blocker disabled
P1 common ads or filtering syntax missed
P1 user control does nothing
P1 state lost after restart/update
P2 cosmetic miss / uncommon syntax
P3 rare edge case
```

Fix P0/P1 before touching P3.

### Definition of done

- no known P0/P1 behavior failure remains from the sampled real-world pass;
- common active-list syntax is either working or explicitly unsupported for a valid MV3 reason;
- no common user control is a placebo.

---

# PHASE 24 — FINAL COMPLETION SWEEP FOR SILENT STUBS / BYPASSES

Search the current active runtime for behavioral red flags:

```text
unsupported: true
not implemented
TODO
FIXME
return false
return null
catch {}
catch (_) {}
disabled
bypass
skip
fallback
quarantine
stub
placeholder
setting stored but never read
UI control with no message handler
message handler returning ok without state change
backend handler that always returns an empty success result
Clear/Apply/Subscribe button that changes only the DOM but not authoritative state
user-facing support page launched by production UI whose backend is stubbed
live HTML loading a JS file that the build does not generate/copy from its maintained source
live cloud/theme/helper UI whose source can drift from the installed file
parallel .ts/.js or src/platform implementations that can drift on a live path
document-start policy granting full/invasive content capability only because DOM evidence is not available yet
catalog-referenced production asset containing `stub`, placeholder text, accidental zero-byte content, or a missing advertised local path
production party/domain classification still using only a partial suffix table while a full PSL is advertised
filter preparser directives discarded as comments before conditional/include evaluation
manifest command with no working handler
context-menu item with no working action
privileged handler reachable by an overly broad content-script/WAR message channel
caller-supplied tabId or sender URL trusted without authorization
```

Do NOT mechanically "fix" every match.

For each match ask:

```text
Is this on a manifest-loaded/user-reachable path?
Does it make a visible feature fail?
Is it a legitimate safe failure path?
Is another frontend/runtime path the real implementation?
```

Examples:

- a compatibility message handler returning `unsupported` is fine if the active frontend uses a working direct MV3 helper;
- an unsupported scriptlet quarantine is correct if the token truly has no safe implementation;
- an empty catch around expected "no prior content-script registration" may be fine;
- a TODO in an archived file is irrelevant.

Fix only real reachable behavior holes.

### Definition of done

- no known reachable placeholder prevents an advertised/UI-exposed feature from working.
- no hardcoded site bypass is hiding a generic runtime problem.
- no important feature silently returns success without doing anything.

---

# REQUIRED CROSS-CUTTING RULES

## A. NO SITE-SPECIFIC BAND-AIDS UNLESS THE FEATURE IS INTENTIONALLY SITE-SPECIFIC

YouTube-specific code is reasonable because there is an explicit YouTube engine.

This is NOT reasonable for generic bugs:

```ts
if (hostname === "problem-site.com") {
    disableEverything();
}
```

Fix the generic page-policy, selector, request, lifecycle, or compiler issue.

---

## B. DO NOT EDIT GENERATED OUTPUT INSTEAD OF SOURCE

If a file contains a generated-file header, identify its canonical source.

Edit source and rebuild.

Exception:

`platform/chromium/js/sw.js` is currently the manifest-selected manually maintained canonical service worker, despite the existence of the TypeScript prototype bundle.

Do not accidentally treat it as disposable generated output.

---

## C. KEEP STORAGE COMPATIBLE

Do not casually rename storage keys.

If a schema change is necessary:

- version it;
- migrate old state;
- preserve user filters/list selection/permanent rules;
- handle interrupted migration;
- avoid clearing unrelated state.

---

## D. KEEP RULE-ID OWNERSHIP DISJOINT

Before adding a new DNR rule family, inspect the central ID ownership/ranges.

Never choose arbitrary IDs.

No subsystem may collide with:

```text
filter-list dynamic
base session
overflow session
firewall
URL filtering
power switch
hostname switches
policy allows
whitelist
stealth surrogate
YouTube-specific
other existing owned ranges
```

---

## E. USE TRANSACTIONS FOR MULTI-RULE REPLACEMENTS

Bad:

```js
remove old rules;
add half of new rules;
Chrome rejects batch;
leave extension half-broken;
```

Good:

- snapshot old owned state;
- compute/validate full new set;
- journal if the existing system uses journaling;
- perform update;
- verify browser truth;
- commit metadata/generation;
- roll back on failure.

Reuse existing utilities.

---

## F. BROWSER TRUTH WINS

After a DNR update, where correctness matters, use:

```text
chrome.declarativeNetRequest.getDynamicRules()
chrome.declarativeNetRequest.getSessionRules()
chrome.declarativeNetRequest.getEnabledRulesets()
```

as appropriate.

Do not assume a storage object means Chrome successfully installed the rules.

---

## G. NO SILENT DOWNGRADE

If a filter says:

```text
some-pattern$unsupported-important-modifier
```

do not compile:

```text
some-pattern
```

and pretend success unless ignoring that modifier is semantically correct.

Return an unsupported diagnostic.

---

## H. NO ARBITRARY REMOTE CODE

Never execute JavaScript downloaded from filter lists or websites.

Remote lists may provide DATA:

- filter syntax;
- selectors;
- known scriptlet token + arguments;
- known redirect token.

Executable behavior must come from packaged extension code.

---

## I. PRIVILEGED MESSAGING MUST BE LEAST-PRIVILEGE

This is a production security requirement, not a test-polish task.

The extension has several sender classes:

```text
extension pages
ordinary content scripts
MAIN/ISOLATED injected code
web-accessible extension documents/resources
ports / long-lived connections
```

Audit both one-shot and port messaging for sensitive actions.

Sensitive examples include:

```text
restore/reset/backup
filter-list selection/update/import
write My Filters
write Trusted Sites
modify firewall/URL rules
acquire temporary Code Viewer DNR rules
navigate custom new-tab searches
launch tools into arbitrary tabs
rollback mutations
managed/policy-sensitive changes
```

Rules:

- derive sender identity from `chrome.runtime.MessageSender` / port sender, not from a caller-controlled `msg._senderURL`, `msg.tabId`, or similar field;
- content scripts may invoke only the channels/actions they actually need;
- a web-accessible document must not receive the entire dashboard privilege surface merely because one feature needs one dashboard-like action;
- minimize `web_accessible_resources`: expose only files that genuinely must be embedded/reached from web pages; top-level extension tools should not be WAR merely for convenience;
- a WAR document framed by an arbitrary website must never acquire dashboard/extension-page privilege, and reducing unnecessary WAR exposure must not break legitimate picker/zapper/redirect flows;
- if a WAR page needs `createUserFilter`, expose/allow only that narrow contract rather than backup/restore/reset/list-management access;
- an action targeting a tab must validate that the sender is permitted to control that tab, or that the sender is a trusted extension page explicitly designed for cross-tab operation;
- URL-bearing privileged messages must validate scheme/shape and the specific operation's allowed destination;
- sender checks must apply equivalently to one-shot messages and ports;
- unknown channel/actions fail closed;
- service-worker logs may diagnose rejection but must not expose secrets/tokens to web pages;
- do not break legitimate content-script/bootstrap messaging while tightening privileged actions.

Reuse the existing sender-policy/message-contract infrastructure where possible instead of creating scattered ad hoc checks.

---

# FINAL ACCEPTANCE MATRIX — RUN ONCE, AFTER IMPLEMENTATION IS FROZEN

Do **not** run this whole matrix after each phase.

During implementation, run only the small targeted checks/tests needed for the change being made. Once Phases 0 through 24 are complete and no more code changes are planned, use this matrix as the single broad browser acceptance pass, followed by the repository-wide automated tests in Phase 25.

Do not build a huge new test framework around this. Reuse existing tests/fixtures and add only the new focused tests that are genuinely needed for functionality added in this project.

## A. Fresh install

```text
extension loads
default lists active
normal page works
ad/tracker fixture blocked
cosmetic fixture hidden
popup opens
```

## B. Power/site switch

```text
ON -> request blocked
OFF -> request allowed
reload -> OFF remains as intended
ON -> blocking restored
```

## C. My Filters

```text
add block filter -> works
add allow exception -> works
add cosmetic -> works if supported
add supported scriptlet -> works
unsupported line -> diagnostic
delete filter -> effect removed
restart -> persisted filters still work
```

## D. Filter list selection

```text
enable list -> unique rule works
disable list -> unique rule stops
restart -> selection retained
failed update -> prior good list retained
```

## E. Dynamic firewall

```text
block
allow
noop
save
revert
restart permanent state
```

## F. Cosmetics

```text
declarative
exception
procedural
dynamic DOM
no-cosmetic switch
```

## G. Scriptlets

```text
supported token
domain scope
excluded domain
unsupported token quarantined
document-start timing
```

## H. Redirect

```text
known token
unknown token
redirect-rule precedence
```

## I. Lifecycle

```text
SW suspend/resume
browser restart
tab close -> tab ID reuse
top-level navigation with page-scoped state
discard -> restore
BFCache pagehide/pageshow
prerender -> activation where supported
document-start provisional policy -> ordinary DOM-ready promotion
document-start provisional policy -> app-shell/auth/payment DOM-ready restriction
ChatGPT through normal content-script/page-policy path with no hardcoded exclusion
SPA navigation
same-origin iframe
cross-origin iframe
```

## I-A. Domain / party authority

```text
multi-label ICANN suffix
one canonical PSL wildcard case
one canonical PSL exception case
private suffix
Unicode IDN vs punycode
IPv4
IPv6
localhost/single-label
cross-origin iframe request
cross-domain redirect
unknown/opaque initiator
```

## I-B. Filter source / asset integrity

```text
valid packaged fallback
catalog fallback containing literal placeholder/stub -> rejected
missing advertised local fallback -> truthful unavailable/remote state
remote update succeeds
remote update fails -> last-good retained
conditional !#if active branch
conditional !#if inactive branch
nested conditional
bounded trusted !#include
invalid/cyclic include
```

## I-C. Restricted URL behavior

```text
chrome://
extension-owned page
devtools/internal page
view-source:
file: in intended support/unsupported state
browser new-tab
data:/blob:/about:blank child context where relevant
```

## J. Tools

```text
picker
zapper
logger
blocked counts
document blocker
```

## K. Video

```text
YouTube initial load
YouTube SPA navigation
player controls
no blank player
generic video fixture
```

## L. Trusted Sites / Dynamic Rules

```text
Trusted Sites Apply/Revert/import/export
trusted site actually bypasses intended layers
remove trust -> filtering restored
managed blocklist overrides user trust
Dynamic Rules temporary edit
Commit/Revert
import/export
popup and editor state reconcile
```

## M. Settings / privacy / commands

```text
collapseBlocked on/off
badge on/off
context menu on/off
prefetch privacy control
hyperlink auditing control
WebRTC privacy control when available
stealth mode on/off
CSP-report control
CNAME toggle is real or honestly unavailable
all manifest keyboard commands
```

## N. Backup / restore / reset / cloud

```text
backup
restore into fresh profile
post-restore filtering state matches
invalid restore rejected
reset returns clean defaults
cloud push/pull for exposed panes
```

## O. Custom new tab

```text
enable
new Chrome tab redirects only when enabled
provider selection
default provider persistence
search navigation
disable -> normal Chrome new tab
no redirect loop
```

## P. Managed policy / incognito

```text
forced list
blocked list
disable filtering
disable cosmetics
disable logger
managed whitelist/blocklist precedence
policy removal restores user state
incognito filtering
no regular/incognito session-state confusion
```

## Q. Logger supporting tools / shipped support pages

```text
Matched Rules targets the intended tab
real matched entries appear after actual DNR matches
Matched Rules source-list attribution is truthful
Matched Rules Clear has real authoritative semantics
logger pause / clear / filter / export
logger DOM inspector connects and disconnects cleanly
logger static filter creation -> My Filters -> active
logger cosmetic filter creation -> My Filters -> active
filter finder opens the correct Asset Viewer/list
Asset Viewer shows the authoritative list content
Asset Viewer Subscribe actually adds the intended list, or is honestly unavailable
Code Viewer opens a blocked resource
temporary Code Viewer allow rule is released afterward
dashboard unsaved warning: Stay / Ignore
```

## R. Privileged message boundaries

```text
ordinary content script cannot call backup/restore/reset
WAR/support page cannot call unrelated dashboard mutations
Code Viewer temporary-rule acquisition rejects untrusted sender
new-tab privileged navigation rejects untrusted sender
cross-tab actions reject unauthorized tab IDs
port and one-shot restrictions agree
```

---

# WHAT NOT TO DO

Do NOT:

- touch GitHub Actions;
- chase certificate badge levels;
- rewrite BENCHMARK.md for appearance;
- spend days on synthetic evidence tooling;
- rewrite all tests;
- run the full test suite repeatedly during implementation;
- spend time fixing unrelated historical test failures before all functionality is complete;
- port the whole service worker just for architecture purity;
- mass-rename files;
- replace working DNR systems with a new framework;
- add React/Vue/etc. to the UI;
- redesign the popup;
- rewrite CSS because it looks old;
- add telemetry;
- add remote code;
- add arbitrary external dependencies;
- fix archived code;
- resurrect source-only/legacy features that are not manifest-referenced, linked, messaged, or otherwise reachable in the current shipped product merely because old files remain;
- treat old MISSING documents as a to-do list;
- claim a feature works because a mocked unit test says so.

---

# PROJECT-WIDE DEFINITION OF DONE

The remaining behavior work is complete only when all of the following are true.

## Core loading

- The unpacked production Chromium extension loads without startup errors.
- The main content script runs on normal HTTP/HTTPS pages without arbitrary site exclusions.
- No global blank-page startup behavior remains.

## Network blocking

- Common active-list network syntax compiles correctly.
- Conditional list preprocessing happens before network/cosmetic/scriptlet classification, so inactive branches cannot leak into runtime artifacts.
- Common exceptions work.
- priorities are correct;
- regex handling is safe;
- redirects work;
- transform/removeparam features work where supported;
- unsupported syntax is explicit, not silently weakened.

## Filter lists

- no production catalog entry is treated as successfully loaded from a placeholder `stub`, accidental empty file, or missing advertised local fallback;
- default lists work;
- list toggles work;
- updates are atomic;
- failed updates preserve last good state;
- custom lists work if exposed;
- selection survives restart.

## User filters

- My Filters actually changes blocking;
- supported cosmetics work;
- supported scriptlets work;
- diagnostics correspond to real compile state;
- state survives restart.

## Cosmetics

- declarative hiding works;
- exceptions work;
- common procedural operators work;
- dynamic DOM works;
- disabling cosmetics actually disables them;
- observers are bounded.

## Scriptlets

- high-value active-corpus tokens are supported;
- document-start tokens run early enough;
- scope/exceptions work;
- unsupported tokens remain quarantined;
- no arbitrary JS execution.

## Dynamic controls

- power switch works;
- Trusted Sites editor works;
- firewall works;
- Dynamic Rules editor works;
- noop semantics are correct;
- URL filtering works;
- per-site switches actually change behavior;
- save/revert/import/export/persistence work.

## Domain / request context

- one complete canonical PSL/domain authority drives registrable-domain and first/third-party semantics;
- wildcard/exception/private-suffix/IDN/IP cases are correct;
- frame/initiator/request context is not replaced by active-tab hostname when that changes semantics.

## Capacity

- extension stays functional near DNR limits;
- overflow/adaptive coverage works;
- no rule-ID collision;
- no catastrophic loss on quota error;
- restart reconciles session/overflow state.

## Browser lifecycle

- install/startup initialization is idempotent;
- service-worker suspension does not break the blocker;
- browser restart restores intended state;
- extension update/migration is recoverable;
- long-lived pages survive activation-token refresh;
- SPA navigation remains filtered;
- frames are scoped correctly.

## User tools

- element picker creates a real persistent filter;
- zapper works temporarily;
- logger reports actual outcomes;
- logger DOM inspector and filter-creation tools work on the intended tab;
- Matched Rules displays actual recent DNR matches and truthful ownership;
- Asset Viewer displays the requested authoritative list and its Subscribe affordance is real or removed;
- Code Viewer can inspect blocked resources without leaving a persistent bypass;
- popup counts/domains/badge/warnings are credible;
- document blocker/proceed path works if exposed;
- every manifest keyboard command works;
- context-menu actions work;
- custom new-tab behavior works when enabled and never hijacks unrelated tabs.

## Settings and user data

- no functional Settings control is a placebo;
- `collapseBlocked` has real semantics;
- CNAME control is real or honestly unavailable;
- browser privacy controls reflect authoritative browser state;
- backup/restore/reset are safe and complete;
- cloud sync is real where exposed;
- advanced settings are connected to runtime.

## Managed / private contexts

- managed policy precedence works for every schema key;
- removing managed policy restores user state;
- incognito split mode filters correctly without cross-context session leakage.

## Final built artifact

- production build contains the fixes made in source;
- every user-reachable shipped page has a working backend for its functional controls;
- live support-page JS has a single canonical source/build owner;
- the Matched Rules `.ts` / live `.js` build-ownership gap is resolved;
- all manifest-referenced assets exist;
- active English UI keys resolve;
- no test/debug-only behavior is accidentally shipped.

## Video

- YouTube remains usable;
- blocking survives SPA navigation;
- no persistent blank player/spinner caused by uBR;
- protected UI is not cosmetically destroyed;
- generic video handling does not broadly break pages.

## Final quality bar

There must be no known P0/P1 issue where:

```text
a major UI control does nothing
a common active filter is silently ignored despite feasible MV3 support
filtering disappears after restart
a page is broken by startup logic
a broad hardcoded domain bypass masks a generic bug
a Settings/dashboard control stores state but has no runtime effect
backup/restore/reset leaves storage and DNR out of sync
a keyboard command or context-menu action is advertised but broken
a shipped support page has a permanent-empty/stubbed backend
a Subscribe/Clear/Apply control only changes the screen and not authoritative state
a live JS file can drift from its maintained TypeScript source
a privileged support page/content script can invoke unrelated dashboard mutations
managed policy can be overridden by ordinary user state
the extension claims successful state that Chrome did not commit
```

---

# PHASE 25 — FINAL INDEPENDENT TEST PASS — ONLY AFTER ALL IMPLEMENTATION IS DONE

This is intentionally last.

Do not begin this phase while implementation is still changing.

At this point:

- all functionality phases must already be complete;
- all known P0/P1 runtime defects found during implementation must already be fixed;
- the production build/package sanity phase must already pass.

Now run the repository's existing broad automated test/check suites **once** as the independent final validation, along with the final browser acceptance matrix above.

Rules:

1. Do not redesign tests for coverage/style.
2. New tests should exist only for functionality added/fixed where a focused regression test is genuinely useful.
3. If an old unrelated test fails because it is stale but browser/runtime behavior is correct, diagnose it separately; do not distort production behavior merely to satisfy the stale test.
4. If a failure exposes a real runtime regression, fix the runtime, rerun the directly affected test, and then rerun the final broad suite once more because implementation changed.
5. Do not touch GitHub Actions.
6. Do not chase certificate/badge/evidence-only failures that do not indicate a product defect; report them separately.

The purpose of this phase is to catch regressions after the project is functionally complete, not to consume the implementation process.

### Definition of done

- final browser acceptance matrix is complete;
- broad existing automated tests/checks have been run after implementation freeze;
- any remaining failures are classified as real product defect vs stale/unrelated test/infrastructure issue;
- no production behavior was weakened merely to make a test green.

---

# FINAL REPORT FORMAT

When all phases are complete, produce ONE concise final engineering report.

Use this structure:

```markdown
# uBlock Resurrected Behavior Completion Report

## Fixed
- [behavior]
  - files:
  - old behavior:
  - new behavior:
  - browser verification:

## Verified Already Working — No Change
- [behavior]
  - runtime path checked:
  - verification:

## User-Reachable Surface Audit
- page/control:
  - canonical source/live artifact:
  - backend:
  - status: fixed / verified / intentionally unavailable

## Intentionally Unsupported Due to MV3 / Safety
- [syntax or feature]
  - reason exact semantics cannot be represented safely:
  - current safe behavior (reject/quarantine/diagnostic):

## Remaining Known Limitations
- only genuine limitations that still exist
- do not list CI/test/documentation polish

## Files Changed
- path — reason

## Functional Browser Checks Performed
- check — result

## Final Independent Test Pass
- suite/check — result
- any failure classified as runtime defect / stale test / infrastructure
```

Do not fill the report with test counts.

Do not claim "complete" if a known P0/P1 behavior failure remains.

---

# EXECUTION STRATEGY FOR A LOWER-CAPABILITY LLM

Work slowly and locally.

For every bug:

```text
1. Find the UI/runtime entry point.
2. Trace the message/call to the active implementation.
3. Find the exact point behavior diverges from intention.
4. Make the smallest coherent runtime fix.
5. Build/typecheck only what is needed for this change.
6. Load unpacked extension.
7. Reproduce the behavior.
8. Add/run one small directly related regression check only if useful or necessary.
9. DO NOT run the whole repository test suite here.
10. Move on.
```

If several files contain similar logic:

DO NOT immediately refactor them.

First identify which path is active.

Only unify logic when contradictory active paths are causing real behavior differences.

If a phase is already complete:

```text
VERIFIED — NO CHANGE
```

and continue.

Do not invent work just because this prompt contains a phase for it.

The objective is to finish the extension, not maximize the number of changed files.
