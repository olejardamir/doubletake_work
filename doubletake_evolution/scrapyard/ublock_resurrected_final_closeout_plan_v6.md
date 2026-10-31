# uBlock Resurrected — Final End-to-End Closeout Plan v6

Baseline reviewed: `54b1cfb6572a8544af056ee59913b00b31328e40`

Verification result: v5 was effectively complete for engineering closeout. The remaining gap was repository/product compliance: privacy-policy alignment, licensing/third-party notices, GitHub Actions hardening, vulnerability disclosure, versioning/changelog discipline, and long-term maintenance ownership. This v6 adds those final operational controls.

This document is the final coding-LLM instruction for closing the remaining architecture gap. The goal is to stop whack-a-mole patching. Do not fix one local symptom and call the system done. The extension is done only when every high-risk runtime operation is inventoried, action-authorized, lease-checked, rollback-safe, source-checked, and proven in browser fixtures.

Repository:

```text
https://github.com/Astrocytech/uBlockResurrected
```

## Core rule

Do not solve breakage by adding more host-specific exclusions.

Host exceptions are allowed only as temporary compatibility metadata with:

- reason
- expiry date
- owner
- affected feature
- linked regression test or fixture
- automatic check failure after expiry

The main solution must remain policy-driven, capability-driven, and general.


---

# 0. Why this v2 exists

The previous document covered the major architecture: inventory, authorization, lease checks, rollback, ownership, static checks, policy profiles, DNR, and e2e fixtures.

However, it still left several ways to accidentally “close the gap” only locally:

1. A coding agent could patch generated `platform/chromium/js/*.js` files directly while leaving `src/` stale.
2. A source-contract regex test could pass while runtime behavior is still broken.
3. MAIN-world message bridge and token exposure could remain too permissive.
4. Runtime hooks could be rollback-safe in one path but unsafe during SPA navigation, iframe changes, MV3 service-worker restart, or concurrent invalidation.
5. A layer could be action-authorized but not performance-bounded.
6. A layer could be safe on simple fixtures but still break app-shell/auth/payment pages under DOM churn.
7. CI could pass a dev profile while release proof remains incomplete or undocumented.
8. Deactivation could be implemented as a message but not verified end to end from SW invalidation to runtime cleanup.
9. Some tests could inspect generated code only and miss source/build drift.
10. Policy and compatibility metadata could remain correct in JSON but not actually drive runtime behavior.


Additional gaps closed by v3:

11. A layer could be locally safe but not governed by a single runtime state machine.
12. A fix could work in the top frame but fail in same-origin/cross-origin iframes.
13. Safety gates could neuter ad blocking without any effectiveness proof.
14. Remote filter/list updates, parser behavior, and list syntax compatibility could remain unproven.
15. Storage migrations could break existing users or fail to roll back.
16. Feature flags and kill switches could exist but not actually deactivate active runtime effects.
17. Release evidence could be scattered across logs instead of packaged into a reproducible artifact.
18. Privacy-sensitive reads could slip through even when mutations are governed.


Additional gaps closed by v4:

19. A coding agent could harden runtime mutation while leaving extension permissions too broad.
20. CSP, remote code, dynamic imports, and web-accessible resources could remain under-specified.
21. The project could pass runtime checks while failing store policy, supply-chain, or dependency-integrity expectations.
22. Diagnostics or logs could expose sensitive page data even when mutation reads are bounded.
23. User-facing controls could fail to reflect policy/runtime state, causing confusing or unsafe overrides.
24. Accessibility, localization, and UI safety could regress while runtime internals improve.
25. Browser/version compatibility could be assumed from Chrome only and fail on Edge or other Chromium profiles.
26. Tests could be self-referential source checks that pass even when they are not testing real behavior.
27. Release evidence could remain scattered instead of packaged as a reproducible artifact.


Additional gaps closed by v5:

28. A coding agent could implement many checks but not map them back to each requirement.
29. A gap could be declared “not applicable” without written justification.
30. A risky residual behavior could remain without an accepted-risk record.
31. A PR could merge without a structured review checklist.
32. A release could ship without a rollback/incident plan.
33. A future maintainer could not tell which commit satisfied which requirement.
34. Final evidence could exist but not be assembled into a signoff bundle.
35. The project could pass technical checks but lack a clear “stop condition” for this closeout effort.


Additional gaps closed by v6:

36. The code could be technically safe but the privacy policy/store disclosures could be stale.
37. Bundled resources, filter lists, dependencies, or copied code could lack license/notice tracking.
38. GitHub Actions could have excessive permissions or unpinned third-party actions.
39. Users/security researchers could lack a vulnerability disclosure path.
40. Releases could lack versioning/changelog/upgrade compatibility discipline.
41. Maintenance ownership, stale debt, and recurring review cadence could remain undefined.
42. A coding agent could create new tools/checks without documenting ownership and expiry.

This v6 closes those gaps explicitly.



---

# 0A. Requirement traceability matrix

This closeout is not complete until every requirement maps to implementation and evidence.

## Required artifact

Create:

```text
docs/CLOSEOUT_TRACEABILITY.md
```

or machine-readable equivalent:

```text
artifacts/closeout/traceability.json
```

Every requirement in this document must have an entry:

```json
{
  "id": "SMART-RUNTIME-ROLLBACK-001",
  "section": "5.5 Smart runtime rollback",
  "requirement": "SmartRuntime.destroy() restores history.pushState, history.replaceState, attachShadow wrapper, observers, timers, markers, and style state.",
  "implementation": [
    "src/js/smart-content.ts",
    "src/core/smart-cosmetic/runtime.ts"
  ],
  "commits": ["..."],
  "staticChecks": ["check:mutation-wrappers"],
  "runtimeTests": ["tests/runtime/smart-runtime-rollback.spec.ts"],
  "browserTests": ["tests/e2e/shadow-dom-app.spec.ts"],
  "evidence": ["artifacts/release-evidence/smart-runtime-rollback.json"],
  "status": "complete",
  "risk": "none",
  "reviewer": "...",
  "reviewedAt": "YYYY-MM-DD"
}
```

Allowed statuses:

- `not-started`
- `in-progress`
- `blocked`
- `complete`
- `not-applicable`
- `accepted-risk`

Rules:

- `not-applicable` requires a reason.
- `accepted-risk` requires a risk record.
- `complete` requires implementation plus evidence.
- No high-risk runtime requirement may be `complete` with source checks only.
- No release requirement may be `complete` without release evidence.

## Required generated table

Generate a human-readable summary:

```text
requirement id | status | implementation | static | runtime | e2e | release evidence | risk
```

## Acceptance

A reviewer can trace every line of this closeout plan to code, tests, evidence, and residual risk.


---

# 1. Final definition of done

The project is not done when a source-contract test passes. It is done when all of these are true:

1. Broad manifest injection is minimal.
2. `bootstrap.js` is the broad entrypoint.
3. Bootstrap uses `getPageActivation` for normal startup.
4. The service worker resolves page policy once per activation.
5. One activation creates exactly one `PolicySnapshot`.
6. Runtime policy, tokens, and revision are seeded into MAIN world before runtime files load.
7. Runtime files are injected only by the service worker.
8. Every active runtime layer has a policy permission, a token, an action allowlist, and a file mapping or explicit fileless declaration.
9. Every high-risk runtime operation has action-specific authorization, awaited validation, checked result, lease check, rollback/cleanup path when applicable, and ownership tracking when it changes page/global state.
10. Every long-lived hook/timer/observer/listener/prototype override has owner reference, original reference, restore method, idempotent cleanup, and no clobbering of later page/extension wrappers.
11. If token, policy revision, document identity, or safe mode changes, runtime effects are revoked or stop mutating.
12. App-shell, contenteditable, auth, payment, and unknown app-like pages are safe by default.
13. Video pages can still activate video blocking through policy, not through permanent host hacks.
14. `npm run check:all:dev` passes.
15. `npm run check:all:release` passes for a release profile.
16. Browser/e2e fixtures pass, not only regex/source tests.


---

# 1A. Threat model and abuse-case closeout

The closeout plan must start from a clear threat model. Without this, the project can pass many checks while still missing what it is defending against.

## Assets

Protect:

- user browsing integrity
- page functionality
- form input and contenteditable safety
- password/payment/auth fields
- extension permissions
- user filter lists and settings
- browsing metadata in logs/storage
- extension update and release artifact integrity
- runtime policy integrity
- capability token integrity
- browser store compliance

## Adversaries and failure sources

Model at least:

1. hostile page script
2. anti-adblock script
3. malformed or hostile filter list
4. compromised or buggy remote filter update
5. accidental coding-agent regression
6. stale generated build artifact
7. user misconfiguration
8. extension update/migration failure
9. browser API behavior differences
10. race conditions from tabs/frames/navigation/service-worker restarts

## Abuse cases

Add tests/checks or explicit mitigations for:

- page script tries to forge `postMessage` bridge request
- page script tries to reuse token from another layer/action/frame
- page script installs wrappers after extension and extension restore clobbers them
- hostile list creates overbroad cosmetic selector
- hostile list creates expensive procedural selector
- hostile list targets auth/payment/contenteditable UI
- remote list update injects unsafe behavior
- stale generated bundle bypasses source fix
- extension update migrates storage incorrectly
- user disables a feature while hooks are active
- service worker restarts while runtime callback is pending
- iframe navigation reuses stale token
- diagnostics log sensitive page text

## Required artifact

Create:

```text
docs/THREAT_MODEL.md
```

with:

- assets
- adversaries
- abuse cases
- mitigations
- test mapping
- remaining accepted risks

## Acceptance

No runtime or release claim is accepted unless it maps back to the threat model.



---

# 1B. Residual risk and not-applicable process

The project can only be closed if remaining risks are explicitly accepted or eliminated.

## Required artifact

Create:

```text
docs/ACCEPTED_RISKS.md
```

and optionally:

```text
artifacts/closeout/accepted-risks.json
```

Each accepted risk must include:

```json
{
  "id": "RISK-001",
  "title": "Firefox unsupported",
  "description": "The extension is MV3 Chromium-only in this release.",
  "affectedRequirements": ["BROWSER-COMPAT-004"],
  "severity": "low|medium|high|critical",
  "likelihood": "low|medium|high",
  "reasonAccepted": "...",
  "mitigation": "...",
  "expiryOrReviewDate": "YYYY-MM-DD",
  "owner": "...",
  "userVisible": true,
  "documentedInReleaseNotes": true
}
```

## Rules

- Critical risks cannot be accepted without explicit release-blocker override.
- Accepted risks must have an owner and review date.
- Accepted risks affecting users must appear in release notes or documentation.
- `not-applicable` must be justified, not silently omitted.
- Expired accepted risks fail release checks.
- Accepted risk cannot be used to bypass app/auth/payment/contenteditable safety.

## Acceptance

No remaining gap is hidden. It is either fixed, not applicable with reason, or accepted with a review date.


---

# 2. Non-negotiable safety invariants

These invariants must become checks. Do not rely on developer discipline.

## 2.1 Authorization invariant

Every high-risk mutation must be behind this shape:

```ts
const ok = await authorizeLayerAction(layer, action);
if (!ok) return;
```

or an equivalent wrapper that is statically recognized.

Reject these patterns:

```ts
__ubrCapability.validate("smart", "smart-style");
element.remove();
```

```ts
await __ubrCapability.validate("video", "remove");
element.remove();
```

if the result is ignored.

```ts
if (__ubrCapability.check("cosmetic")) {
  style.textContent = css;
}
```

Generic `check(layer)` is only a cheap freshness hint. It is not sufficient for actual mutation.

## 2.2 Lease invariant

Before any mutation caused by async callbacks, timers, observers, wrapped APIs, or delayed tasks, check the lease.

A lease must confirm:

- capability object exists
- token exists for layer
- token is not expired
- policy revision matches installed runtime revision
- sender/document identity is valid where available
- safe mode is not active
- layer is still allowed by current policy

## 2.3 Rollback invariant

Anything that changes global/page state must have a paired rollback.

Examples:

- `self.fetch = wrapper` -> restore original fetch only if current fetch is this wrapper
- `XMLHttpRequest.prototype.send = wrapper` -> restore only if current send is this wrapper
- `Element.prototype.attachShadow = wrapper` -> restore only if current function is this wrapper
- `history.pushState = wrapper` -> restore only if current function is this wrapper
- `MutationObserver.observe()` -> disconnect observer
- `setInterval()` / `setTimeout()` loops -> clear timer
- `addEventListener()` capture/prevent/neutralize handlers -> remove listener
- inserted style element -> remove only if extension-owned
- modified inline style -> restore previous value only if still safe and owned
- extension marker attributes -> remove on teardown

## 2.4 Ownership invariant

Never clobber page or other-extension state.

Restore only if the current value is the wrapper/node/listener installed by this runtime.

Track ownership with wrapper refs, WeakMaps, extension-owned attributes, unique IDs, inserted-node registry, listener registry, policy revision, and activation ID.

## 2.5 No source-only completion invariant

Regex/source-contract tests are useful, but they are not sufficient. Every major runtime class must have at least one actual runtime or browser/e2e proof.


## 2.6 Source-of-truth invariant

Generated files are not the source of truth.

Do not patch only:

```text
platform/chromium/js/contentscript.js
platform/chromium/js/smart-content.js
platform/chromium/js/video-adblock-generic.js
platform/chromium/js/sw.js
```

unless the repository intentionally treats that file as source.

For bundled/generated files, the change must be made in `src/` and rebuilt.

Required checks:

- Generated files must match build output.
- Source files must contain the same authorization/lease/rollback logic as generated files.
- Tests must prefer source modules when possible.
- If a test inspects generated files, it must also verify source/build parity.

Acceptance:

- No “fix” exists only in generated output.
- `npm run build` does not erase the fix.
- `check:generated-artifacts` or equivalent fails on source/generated drift.

## 2.7 MAIN-world bridge and token exposure invariant

The MAIN-world bridge is a security boundary.

The page must not be able to forge privileged actions merely by posting messages that look like extension messages.

Required:

- Validate `event.source === window`.
- Validate exact message schema.
- Validate request IDs/nonces where practical.
- Allow only known message types.
- Never expose full token objects if token IDs are sufficient.
- Prefer seeding MAIN world with minimal opaque token handles, not full token metadata.
- Do not expose policy fields that are not needed by runtime code.
- Do not allow arbitrary page scripts to ask the SW to validate unrelated token/action/layer combinations.
- Validation must bind token to tab/frame/document/layer/action/current revision.

Acceptance:

- A page script cannot mint or reuse capability for another layer/action.
- A page script cannot infer unnecessary token metadata.
- Malformed postMessage payloads fail closed.
- Bridge tests include hostile page messages.

## 2.8 Browser lifecycle and race invariant

Runtime safety must survive browser lifecycle events and races.

Cover:

- MV3 service-worker restart
- tab close during injection
- frame disappearance during injection
- iframe navigation
- SPA route change
- `history.pushState` / `replaceState`
- `popstate`
- `hashchange`
- BFCache / `pagehide` / `pageshow`
- documentId changes
- same tab, new document
- policy invalidation while a callback is pending
- token expiry while timer/observer callback is queued
- extension disable/reload if testable

Acceptance:

- No queued callback mutates after stale token/policy revision.
- No runtime layer survives document replacement.
- No injection error leaves partial unrecoverable state.
- No restore path calls nulled originals or clobbers newer wrappers.

## 2.9 Privacy and performance invariant

The extension must not become safe by being too invasive.

Every observer, scanner, bridge, and heuristic layer must have:

- bounded scan size
- bounded observer count
- bounded timer frequency
- bounded memory registry size
- no unnecessary storage of page text
- no logging of sensitive form/payment/auth content
- no cross-origin data leakage
- no persistent storage of DOM snapshots unless explicitly justified

Acceptance:

- App-shell/auth/payment fixtures prove no sensitive fields are read or logged.
- Performance budgets fail checks when observers/timers/scans exceed limits.
- Runtime registries are cleared on deactivation.


---

# 2A. Runtime state machine invariant

The architecture must have an explicit runtime state machine. Without this, a coding agent can make each local method look safe while the whole lifecycle still leaks hooks, observers, styles, or tokens.

## Required states

Define the same state model for each high-risk layer:

```text
unloaded
policy-requested
policy-denied
activating
active
deactivating
deactivated
revoked
failed-safe
```

## Required transitions

Allowed transitions:

```text
unloaded -> policy-requested
policy-requested -> policy-denied
policy-requested -> activating
activating -> active
activating -> failed-safe
active -> deactivating
active -> revoked
active -> failed-safe
deactivating -> deactivated
revoked -> deactivated
failed-safe -> deactivated
deactivated -> policy-requested
```

Everything else is invalid.

## Required per-layer state fields

Each runtime registry must track:

```ts
{
  layer: "cosmetic" | "smart" | "video" | "interceptors",
  state: RuntimeState,
  activationId: string,
  policyRevision: string,
  tabId?: number,
  frameId?: number,
  documentId?: string,
  installedAt: number,
  lastLeaseCheckAt: number,
  ownedResources: Set | Map,
  pendingTasks: Set | Map
}
```

## Required behavior

- Mutations are allowed only in `active`.
- Activation must be atomic enough that partial installs either complete or rollback.
- Deactivation must be idempotent.
- Revocation must transition to cleanup.
- Failed activation must leave no hooks/styles/observers/timers behind.
- Pending async callbacks must verify state is still `active` and activation ID still matches.
- No state transition may be implicit only in comments.

## Required tests

- invalid transition fails
- failed activation rolls back partial install
- deactivation from each state is safe
- duplicate activation does not stack resources
- pending callback after `revoked` does not mutate
- pending callback after document change does not mutate
- layer can reactivate cleanly after deactivation

## Acceptance

Every high-risk layer has a visible state machine and tests for invalid transitions.


---

# 3. Create a high-risk operation inventory first

Before writing more feature patches, create an inventory and make it fail CI if incomplete.

## Required file

Create:

```text
tools/runtime-mutation-inventory.mjs
```

or a JSON artifact generated by it:

```text
config/runtime-mutation-inventory.json
```

## Inventory every operation in generated and source runtime files

Scan at minimum:

```text
src/js/contentscript/**
src/js/smart-content.ts
src/js/video-adblock/**
platform/chromium/js/contentscript.js
platform/chromium/js/smart-content.js
platform/chromium/js/video-adblock-generic.js
platform/chromium/js/capability-enforcer.js
platform/chromium/js/bootstrap.js
platform/chromium/js/sw.js
```

Detect:

- `append`, `appendChild`, `prepend`, `insertBefore`, `replaceChild`
- `remove`, `removeChild`
- `innerHTML`, `outerHTML`
- `textContent`, `innerText`, `nodeValue`, `data`
- `style.*`, `style.setProperty`, `cssText`
- `classList.add/remove/toggle`
- `setAttribute`, `removeAttribute`
- `CSSStyleSheet.insertRule/deleteRule`
- style element creation/insertion/removal
- `MutationObserver`
- `ResizeObserver`, `IntersectionObserver` if used for mutation decisions
- `addEventListener` with capture or event suppression
- `preventDefault`, `stopPropagation`, `stopImmediatePropagation`
- `.click()`
- `setTimeout`, `setInterval`, `requestAnimationFrame` used for delayed mutation
- `self.fetch = ...`
- `window.fetch = ...`
- `XMLHttpRequest.prototype.open/send = ...`
- `Object.defineProperty(..., "responseText" | "response", ...)`
- `history.pushState/replaceState = ...`
- `Element.prototype.attachShadow = ...`
- `postMessage` bridges that trigger mutation
- `chrome.scripting.executeScript`
- DNR dynamic/session rule updates

For each operation, record:

```json
{
  "file": "...",
  "line": 123,
  "operation": "style.textContent",
  "layer": "cosmetic",
  "action": "inject-css",
  "authorization": "authorizeCosmetic('inject-css')",
  "lease": "checkCosmeticLease",
  "rollback": "CosmeticMutationRegistry.removeOwnedStyle",
  "ownership": "data-ubr-cosmetic + registry",
  "tests": ["..."],
  "status": "covered"
}
```

Allowed statuses:

- `covered`
- `safe-detached-probe`
- `safe-cleanup`
- `legacy-temporary`
- `blocked`

The check must fail on `legacy-temporary` after expiry.

## Acceptance

- No high-risk operation exists outside the inventory.
- Inventory is generated or validated in `check:all:dev`.
- Inventory is stricter than current source-contract tests.

---

# 4. Centralize runtime authorization helpers

Stop duplicating slightly different helpers in each file.

## Required module

Create a small shared runtime helper, or equivalent per-bundle source module that builds into generated files:

```text
src/js/runtime/runtime-authority.ts
```

It should provide layer-specific wrappers:

```ts
async function authorizeCosmetic(action: CosmeticAction): Promise<boolean>
async function authorizeSmart(action: SmartAction): Promise<boolean>
async function authorizeVideo(action: VideoAction): Promise<boolean>
async function authorizeInterceptors(action: InterceptorAction): Promise<boolean>
```

Each must:

1. fail closed when `__ubrCapability` is missing
2. call `check(layer)` only as a cheap precheck
3. call `validate(layer, action)`
4. require validation result to be true
5. optionally log denied action in debug mode
6. never throw on missing capability

## Add lease helpers

```ts
function checkLayerLease(layer: RuntimeLayer, installedRevision: string): boolean
```

Must check:

- `__ubrCapability` exists
- `hasStaleTokens()` is false
- `__uborPolicyRevision` matches installed revision
- token exists
- token has not expired
- layer still exists in `__uborTokens`

## Acceptance

- Runtime code uses shared helpers or a single generated copy of the same logic.
- Static checker recognizes only approved wrappers.
- Direct raw `__ubrCapability.validate(...)` calls outside helpers are rejected unless explicitly whitelisted.


---

# 4A. Source/build parity closeout

This section is mandatory because prior review has repeatedly inspected generated files under `platform/chromium/js/`. A coding LLM must not patch generated output and leave source files stale.

## Required work

1. Identify which files are source and which are generated.
2. Add or update a manifest such as:

```json
{
  "generated": [
    {
      "output": "platform/chromium/js/smart-content.js",
      "sources": ["src/js/smart-content.ts", "src/core/smart-cosmetic/**"],
      "build": "npm run build"
    }
  ]
}
```

3. Ensure every runtime hardening change is made in source.
4. Run the build.
5. Verify generated files reflect the source changes.
6. Add a check that fails if generated files are stale.

## Required tests/checks

- `npm run build` reproduces generated runtime files.
- `check:generated-artifacts` fails if `src/` and generated output diverge.
- Tests that inspect generated runtime files also verify source snippets exist.
- No source-contract test may pass by reading only stale generated output.

## Acceptance

A future coding agent cannot “fix” the built artifact while leaving the next build broken.


---

# 5. Finish smart runtime completely

Recent commits fixed smart observer callback authorization, but smart runtime still has path, shadow, wrapper, timer, and rollback risks.

## 5.1 Fix history wrapper binding

Current risk pattern:

```js
history.replaceState = function(...args) {
  const result = self.originalReplaceState.apply(history, args);
  self.onPathChange();
  return result;
};
```

This can refer to global `self`, not the `SmartRuntime` instance.

## Required fix

Use an explicit runtime reference:

```ts
const runtime = this;
history.replaceState = function(...args) {
  const result = runtime.originalReplaceState.apply(history, args);
  void runtime.handlePathChange();
  return result;
};
```

or use an arrow function when safe.

## 5.2 Add path-change authorization

Every path-change-triggered re-evaluation must require:

```ts
await authorizeSmart("smart-selector-update")
```

Before any style mutation, still require:

```ts
await authorizeSmart("smart-style")
```

## 5.3 Harden `startShadowScan`

Current risk: interval scans shadow hosts, sets attributes, and calls shadow traversal. This must be governed.

Required:

- before each scan cycle: check smart lease and `authorizeSmart("smart-selector-update")`
- before setting `data-ubr-shadow-scanned`: authorize a smart marker action, either `smart-selector-update` or a new `smart-mark`
- if lease fails: clear interval, stop scan, rollback owned markers where safe
- shadow traversal that updates selectors must require `smart-selector-update`

## 5.4 Harden `hookAttachShadow`

Prototype wrapping must be treated like fetch/XHR.

Required registry fields:

```ts
originalAttachShadow
attachShadowWrapper
```

Rules:

- validate before installing wrapper
- store original and wrapper refs
- restore only if `Element.prototype.attachShadow === attachShadowWrapper`
- do not clobber later wrappers
- do not stack wrappers on repeated activation
- wrapper callback must lease-check before smart work
- destroy must restore it

## 5.5 Smart runtime rollback

`SmartRuntime.destroy()` must:

- disconnect mutation observer
- disconnect iframe observer
- clear debounce timer
- clear shadow scan timer
- restore `history.pushState`
- restore `history.replaceState`
- restore `Element.prototype.attachShadow`
- remove owned shadow-scan markers where safe
- clear smart style element
- clear hidden element registry
- remove self-mutation markers
- reset active/initialized flags

## Required tests

Add tests for:

- `replaceState` uses runtime instance, not global `self`
- path-change re-evaluation requires `smart-selector-update`
- shadow scan requires `smart-selector-update`
- `data-ubr-shadow-scanned` marker requires smart authorization
- attachShadow wrapper is ownership-aware
- destroy restores attachShadow only if still our wrapper
- destroy restores history only if still our wrappers
- stale smart token stops shadow scan
- repeated smart activation/destroy does not stack wrappers
- smart runtime leaves no observer/timer/prototype hook after destroy

## Acceptance

Smart observer, shadow, iframe, history, path-change, and selector-update paths all obey action-level authorization and rollback.

---

# 6. Finish cosmetic runtime completely

Recent work made some cosmetic paths fail closed, but this is not enough. The entire cosmetic pipeline must be governed, not only selected helper functions.

## Required registry

Create:

```text
src/js/contentscript/cosmetic-mutation-registry.ts
```

or equivalent.

Track:

- inserted style elements
- style text changes
- CSS rules inserted
- elements hidden by extension
- previous inline style values
- marker attributes
- picker iframe
- picker port
- event listeners
- policy revision
- activation ID

## Required wrappers

All cosmetic mutations must go through wrappers such as:

```ts
async function injectOwnedStyle(id, css, reason)
async function removeOwnedStyle(id, reason)
async function hideElementCosmetic(element, reason)
async function unhideElementCosmetic(element, reason)
async function removeElementCosmetic(element, reason)
async function markElementCosmetic(element, reason)
async function createPickerIframe(...)
async function createPickerFilter(...)
```

Each wrapper must authorize the exact action, check lease, record ownership, support rollback or safe cleanup, and fail closed.

## Cover all cosmetic entrypoints

Do not only cover stored user filters.

Cover:

- stored user filters
- compiled cosmetic filters
- procedural cosmetic filters
- `vAPI.userStylesheet.add/remove/apply`
- `vAPI.domFilterer.addCSS`
- `vAPI.domFilterer.addProceduralSelectors`
- `vAPI.domFilterer.exceptCSSRules`
- picker launch
- picker create-filter
- picker quit
- context menu targeting if it mutates state
- YouTube masthead cleanup
- hostname switch styles
- immediate power switch state
- any style element insertion/removal

## Picker rules

- `picker-launch` must fail closed.
- `picker-create-filter` must fail closed.
- `pickerQuit` and cleanup must always be allowed once picker exists.
- Cleanup must not require valid token.
- Creation and mutation must require valid token.

## Required static checker rules

Reject:

- `style.textContent = ...` without `inject-css`
- `style.remove()` without `remove-style`, unless cleanup exception
- `append(style)` without `inject-css`
- `element.style.* = ...` without exact cosmetic action
- `element.remove()` without `dom-remove`
- picker filter mutation without `picker-create-filter`
- picker launch without `picker-launch`
- generic `check("cosmetic")` near mutation

## Required tests

- missing capability blocks all cosmetic mutation
- stale token blocks all cosmetic mutation
- CSS injection blocked without `inject-css`
- style removal blocked without `remove-style`
- element hide blocked without `hide-element`
- element removal blocked without `dom-remove`
- picker launch blocked without `picker-launch`
- picker create-filter blocked without `picker-create-filter`
- picker quit works without token
- policy revision change rolls back owned cosmetic styles
- repeated cosmetic activation does not duplicate style nodes
- cleanup does not remove page-owned style elements

## Acceptance

The cosmetic layer is fully governed, not partially gated.

---

# 7. Finish video runtime completely

Video runtime has action-level helpers, but it still needs a full lifecycle/rollback model.

## Normalize action names

Current SW actions include:

```text
observe
hide
remove
neutralize-click
skip-click
mark
```

This is acceptable if consistent. Do not mix these with `video-hide`, `video-remove`, etc., unless all code and tests are migrated.

Make one canonical action table:

```text
video.observe
video.hide
video.remove
video.neutralize-click
video.skip-click
video.mark
video.restore
```

or keep current names, but document them.

## Required video registry

Track:

- observers
- hidden elements
- prior inline styles
- removed elements and parent/next sibling where restorable
- neutralized click handlers
- skip-click targets and timestamps
- extension markers
- policy revision
- activation ID
- timers

## Required rollback

On deactivation, stale token, policy revision change, pagehide, or safe mode:

- disconnect observers
- remove click-neutralization handlers
- remove extension-owned markers
- restore hidden elements where safe
- restore inline styles where safe
- clear timers
- clear skip-click state
- do not reinsert removed ad nodes unless parent/position is safe and explicitly tracked

## Specific issue: neutralized click handlers

When adding:

```ts
element.addEventListener("pointerdown", handler, true)
element.addEventListener("mousedown", handler, true)
element.addEventListener("click", handler, true)
```

You must record a cleanup entry:

```ts
element.removeEventListener("pointerdown", handler, true)
element.removeEventListener("mousedown", handler, true)
element.removeEventListener("click", handler, true)
```

## Required lease checks

Check lease before:

- observer creation
- observer callback mutation
- skip click
- overlay neutralization
- element hiding
- element removal
- mark attribute mutation
- delayed rescans
- repeated scan loop
- route/video-source changes

## Required tests

- video observer blocked without `observe`
- skip click blocked without `skip-click`
- neutralize click blocked without `neutralize-click`
- neutralized click handlers removed on destroy
- element hide blocked without `hide`
- element remove blocked without `remove`
- mark blocked without `mark`
- stale token disconnects observers
- stale token clears click handlers
- repeated activation does not stack observers/listeners
- auth/payment/app-shell fixture does not activate video runtime
- video fixture activates video runtime through policy, not host exception

## Acceptance

Video runtime has the same ownership and rollback discipline as interceptors.

---

# 8. Finish interceptor runtime verification

The interceptor layer is closest to done. Keep it as the model, but verify it through tests and fix remaining edge cases.

## Required checks

Verify:

- fallback never calls wrapper recursively
- native/baseline fallback is never null-called
- restore only restores if current function is our wrapper
- later page/extension wrapper is not clobbered
- fetch response mutation revalidates at mutation time
- XHR mutation revalidates at mutation time
- XHR open/send wrappers lease-check before acting
- observer disconnects on stale token/deactivation
- `pagehide` restores all hooks
- `ubor:deactivate` restores all hooks
- repeated activate/restore does not stack wrappers

## Required tests

Use actual runtime tests, not only text matching:

- install fetch wrapper, expire token, call fetch, ensure original is called and no recursion
- install XHR wrappers, expire token, ensure original open/send are called
- install another wrapper after ours, call restore, ensure newer wrapper remains
- deactivation message restores fetch/XHR/observer
- mutation denied when `mutate-fetch-response` fails
- mutation denied when `mutate-xhr-response` fails

## Acceptance

Interceptor layer is runtime-proven, not only source-proven.

---

# 9. Service worker activation and deactivation closeout

## Activation requirements

`getPageActivation` must:

1. resolve policy once
2. apply expiry/safe-mode gates
3. create one `PolicySnapshot`
4. compute active layers
5. validate each active layer has a file mapping or explicit fileless declaration
6. issue tokens
7. seed MAIN world:
   - `__uborTokens`
   - `__uborPolicyRevision`
   - `__uborPagePolicy`
8. inject `capability-enforcer.js`
9. inject approved runtime files
10. return:
    - `ok`
    - `activeLayers`
    - `approvedFiles`
    - `approvedFileCount`
    - `policyRevision`
    - `policy`
    - errors if any

## Deactivation requirements

When any of these change:

- policy revision
- hostname switch
- whitelist/trust state
- net filtering state
- cosmetic filtering state
- safe mode
- tab/frame/document lifecycle

The SW must send a deactivation/revocation event to the affected runtime:

```js
postMessage({ type: "ubor:deactivate", reason })
```

or equivalent.

Every runtime must listen and rollback.

## Token validation hardening

`validateToken` must fail closed on:

- missing sender tab
- missing sender frame
- missing token
- wrong tab
- wrong frame
- wrong document where document ID is available
- wrong layer
- missing action
- action not in allowlist
- stale revision
- expired token
- invalidated snapshot

Document ID rule:

- If token has document ID, sender must match it.
- If sender lacks document ID but token has one, fail closed unless browser API does not provide document ID and this case is explicitly profiled/tested.

## Required tests

- zero active layers returns safely
- missing tab/frame returns safely
- missing layer file mapping fails check
- active layers dedupe approved files
- cosmetic + interceptors both mapping to `contentscript.js` still issue separate tokens
- denied layer does not inject file
- runtime receives deactivation on invalidation
- token validation rejects wrong action/layer/tab/frame/document
- token expiry rejects action

## Acceptance

Activation/deactivation is deterministic and reversible.


---

# 9A. MAIN-world bridge and capability-token minimization

The current architecture seeds MAIN world and uses a postMessage bridge for validation. That bridge must be treated as hostile-facing.

## Required work

1. Create a formal bridge protocol:

```ts
type UborBridgeRequest =
  | { type: "ubor:validateToken"; requestId: string; tokenId: string; layer: string; action: string }
  | { type: "ubor:deactivateAck"; requestId: string; reason: string };
```

2. Reject anything outside the protocol.
3. Validate:
   - `event.source === window`
   - message is a plain object
   - type is allowlisted
   - requestId format is valid
   - layer/action pair is allowlisted
   - tokenId belongs to seeded runtime token handles
4. Return only minimal responses:

```ts
{ type: "ubor:validateTokenResult", requestId, valid: boolean, reason?: string }
```

5. Do not expose full token objects to page code if opaque token IDs are enough.
6. If full token metadata must remain temporarily, mark it as compatibility debt with expiry.
7. Ensure page scripts cannot enumerate tokens for inactive layers.
8. Ensure validation cannot be used as an oracle for unrelated layers/actions.

## Required hostile bridge tests

Add a fixture page that sends:

- wrong message type
- missing requestId
- wrong layer/action pair
- forged tokenId
- stale tokenId
- token for wrong layer
- token for right layer but wrong action
- message from wrong source if testable
- prototype-polluted payload
- oversized payload
- repeated spam payloads

All must fail closed without runtime mutation.

## Acceptance

The bridge is a narrow validation pipe, not a general privileged API.

---

# 9B. MV3 lifecycle, SPA navigation, and runtime reactivation

The extension must survive MV3 and modern web lifecycle behavior.

## Required work

1. Model runtime state by activation ID:

```ts
activationId = `${tabId}:${frameId}:${documentId}:${policyRevision}`
```

2. Store activation ID in every runtime registry.
3. Every callback/timer/observer checks activation ID before mutating.
4. On SPA navigation:
   - recompute page signals
   - ask SW for policy if profile may have changed
   - deactivate old runtime if policy changed
   - activate new runtime only after new snapshot
5. On `pageshow` from BFCache:
   - revalidate lease before resuming
6. On `pagehide`:
   - rollback or pause runtime effects
7. On service-worker restart:
   - content runtime must fail closed until it can revalidate
8. On frame/document change:
   - old tokens must not validate for new document

## Required tests

- SPA route change from article to app-shell disables smart/video/interceptors.
- SPA route change from app-shell to article can enable cosmetic only after new activation.
- BFCache pageshow revalidates before mutation.
- documentId change invalidates old tokens.
- service-worker restart causes runtime to fail closed until revalidated.
- queued observer callback from old activation does not mutate new page.

## Acceptance

Runtime behavior is tied to document/policy activation, not just tab lifetime.



---

# 9C. Frame, iframe, and execution-world topology

A fix is incomplete if it only works in the top frame. Modern ad behavior often lives in nested frames, and page breakage often occurs in app-shell frames or editor frames.

## Required topology model

Create a frame model that tracks:

```ts
{
  tabId,
  frameId,
  parentFrameId,
  documentId,
  url,
  origin,
  isTopFrame,
  isSameOriginWithTop,
  isAboutBlank,
  isSrcdoc,
  sandboxFlags,
  policyProfile,
  activeLayers
}
```

## Required rules

1. Policy resolution must happen per frame/document, not only per tab.
2. Top-frame policy must not automatically grant high-risk mutation to child frames.
3. Cross-origin iframes must fail closed unless explicitly classified.
4. `about:blank` and `srcdoc` frames must inherit carefully:
   - inherit only when creator/parent identity is known
   - otherwise safe profile
5. MAIN-world injection must be deliberate per frame.
6. ISOLATED-world scripts must not assume MAIN-world globals exist.
7. MAIN-world scripts must not assume `vAPI` exists unless seeded.
8. Tokens must bind to the exact frame/document where possible.
9. Deactivation must target all active frames for a tab when host policy changes.
10. Frame removal must invalidate tokens and cleanup owned state.

## Required tests

- top frame article + child app-shell iframe
- top frame app-shell + child video iframe
- cross-origin iframe denied by default
- same-origin iframe gets separate activation ID
- about:blank child inherits only when safe
- frame removal invalidates tokens
- child frame cannot reuse parent token
- parent frame cannot validate child token
- MAIN-world bridge in child frame cannot affect parent frame

## Acceptance

Runtime safety and ad blocking are correct per frame, not only per tab.



---

# 9D. Manifest permissions, CSP, and web-accessible resource closeout

Runtime safety is incomplete if the extension keeps unnecessarily broad permissions or exposes unnecessary files.

## Required manifest inventory

Inventory and justify:

- `permissions`
- `optional_permissions`
- `host_permissions`
- `content_scripts`
- `web_accessible_resources`
- `externally_connectable`
- `declarative_net_request` rule resources
- background service worker
- commands
- side panel/popup/options pages
- CSP
- remote code constraints

For each item:

```json
{
  "manifestPath": "permissions[0]",
  "value": "scripting",
  "reason": "SW-controlled runtime layer injection",
  "risk": "executes extension code in tabs",
  "scope": "needed for getPageActivation only",
  "tests": ["check-manifest-permissions"],
  "owner": "runtime-policy"
}
```

## Required permission rules

- No permission without a written reason.
- No host permission broader than necessary without justification.
- Broad host access must be tied to ad-blocking function and store policy.
- High-risk runtime files must not be broadly injected by manifest.
- Web-accessible resources must be minimal.
- Runtime files injected with `chrome.scripting.executeScript` should not be web-accessible unless strictly required.
- No externally connectable surface unless explicitly needed.
- No remote code execution.
- No dynamic eval/new Function.
- Dynamic imports must be local extension resources only.
- CSP must prevent remote script execution.

## Required checks

Create or extend:

```text
tools/check-manifest-permissions.mjs
tools/check-csp-and-remote-code.mjs
tools/check-web-accessible-surface.mjs
```

They must fail on:

- unjustified permission
- unexpected host permission
- high-risk runtime in broad `content_scripts`
- high-risk runtime in `web_accessible_resources` without reason
- remote script source in CSP
- `eval`, `new Function`, string-based timers
- remote dynamic import
- externally connectable without explicit profile

## Acceptance

The extension has least-privilege manifest posture, not only runtime guards.


---

# 10. Policy schema and profile matrix

The policy file must be the source of truth.

## Required profile matrix

Create a readable table in docs and machine-readable config.

Profiles:

- unknown
- article
- video
- app-shell
- contenteditable-app
- auth
- payment
- checkout
- document/editor
- trusted
- hostile/anti-adblock
- iframe/embedded video
- safe-mode

For each profile, define:

- cosmetic runtime allowed?
- smart runtime allowed?
- video runtime allowed?
- interceptors allowed?
- DNR session rules allowed?
- scriptlets allowed?
- element picker allowed?
- CSS injection allowed?
- DOM removal allowed?
- click simulation allowed?
- prototype wrapping allowed?
- response mutation allowed?

## Default rule

Unknown app-like pages must be safe.

App-shell/auth/payment/contenteditable profiles should deny:

- smart runtime
- video runtime
- interceptors
- DOM removal
- click simulation
- prototype wrapping
- response mutation

unless a very specific policy grants them.

## Required schema checks

Validate:

- allowed profile IDs only
- no duplicate/mixed legacy policy fields
- every profile has explicit layer decisions
- every layer action exists in SW action allowlist
- every compatibility exception has expiry
- no expired exception
- manifest host exclusions match compatibility metadata
- no hardcoded permanent support host list outside policy/config

## Acceptance

Policy config, not scattered code, decides runtime activation.

---

# 11. DNR lifecycle hardening

DNR must follow the same governance principles.

## Required

All dynamic/session DNR updates must go through a transaction module.

The transaction must:

- validate operation token
- check quota
- record decision
- install rules
- verify installed rules by content, not count only
- rollback on failure
- record audit state

## Required audit record

For each DNR operation:

```json
{
  "operation": "install-session-rules",
  "rules": ["..."],
  "source": "filter-list/user-rule/runtime",
  "policyProfile": "video",
  "reason": "...",
  "tabId": 123,
  "frameId": 0,
  "documentId": "...",
  "startedAt": "...",
  "completedAt": "...",
  "status": "ok|rolled-back|failed"
}
```

## Required tests

- failed DNR install rolls back
- partial install rolls back
- content mismatch fails
- quota exceeded fails before mutation
- app-shell/auth/payment profiles suppress unsafe dynamic/session rules
- no code path calls `chrome.declarativeNetRequest.updateDynamicRules` directly outside transaction module
- no code path calls `updateSessionRules` directly outside transaction module

## Acceptance

Network rule lifecycle is bounded, auditable, and rollback-safe.


---

# 11A. Storage, migrations, and user-state rollback

The extension has persistent user settings, filter lists, host switches, compatibility metadata, and generated caches. A runtime architecture is incomplete if storage migration can break users.

## Required storage inventory

Inventory all persistent keys:

- filter lists
- selected lists
- user filters
- per-site switches
- hostname switches
- compatibility exceptions
- runtime caches
- cosmetic cache
- DNR audit records
- policy cache
- release/certificate artifacts if stored
- feature flags
- safe-mode flags

For each key, define:

```json
{
  "key": "hostnameSwitches",
  "schemaVersion": 2,
  "owner": "policy-runtime",
  "privacy": "hostnames-only",
  "migration": "migrateHostnameSwitchesV2",
  "rollback": "rollbackHostnameSwitchesV2",
  "maxSizeBytes": 100000,
  "clearOnDisable": false
}
```

## Required migration rules

- Migrations must be versioned.
- Migrations must be idempotent.
- Migrations must validate before writing.
- Failed migration must not erase old data.
- Rollback must exist for risky migrations.
- Corrupt storage must fail safe.
- Oversized storage must be handled gracefully.
- Sensitive data must not be stored unless necessary.

## Required tests

- migrate from old schema to new schema
- migration idempotency
- corrupt value fallback
- rollback after failed migration
- user filters preserved
- hostname switches preserved
- compatibility exception expiry preserved
- storage quota exceeded path
- clear runtime cache without clearing user rules

## Acceptance

Existing users can upgrade/downgrade without losing user filters or getting unsafe runtime activation.

---

# 11B. Filter/list/parser correctness and effectiveness

Safety hardening must not silently remove ad-blocking effectiveness.

## Required parser/list coverage

Verify:

- static filter list loading
- remote list update path if dev profile allows it
- user filters
- cosmetic filters
- procedural cosmetic filters
- exception filters
- scriptlet filters if supported
- redirect resources
- DNR rule generation
- dynamic/session rules
- list deduplication
- list priority semantics
- invalid filter syntax handling
- oversized list handling
- malicious list entry handling

## Required effectiveness corpus

Create a small but representative corpus:

```text
tests/corpus/effectiveness/
```

Include:

- common display ad URL
- Google ad-like URL
- video VAST/VMAP URL
- Yandex/Rutube-style VAS/VAST patterns
- iframe ad container
- first-party sponsored block
- cosmetic-only ad block
- procedural cosmetic block
- exception rule case
- user rule override case

## Required assertions

- expected network rules are generated
- expected cosmetic selectors apply on article fixture
- expected video policy activates on video fixture
- expected exception rules prevent overblocking
- expected user rules override defaults
- app/auth/payment profiles still deny unsafe mutation
- effectiveness does not depend on permanent host hacks

## Acceptance

After safety gates, the extension still blocks representative ads.


---

# 12. Browser/e2e proof

This is now the major remaining piece.

Source-level tests cannot prove extension safety on real pages. Add browser fixtures and run them with Playwright or equivalent Chrome extension test harness.

## Required fixtures

Create fixtures under:

```text
tests/e2e/fixtures/
```

Minimum pages:

1. `app-shell-contenteditable.html`
   - root app shell
   - contenteditable editor
   - dynamic DOM churn
   - buttons/forms
2. `auth-form.html`
   - login form
   - password field
   - OAuth-like buttons
3. `payment-form.html`
   - card input placeholders
   - checkout/cart/payment classnames
4. `article-page.html`
   - normal article with obvious ad containers
5. `video-page.html`
   - primary video element
   - ad-like overlay
   - skip button
6. `unknown-app-like.html`
   - app shell without known hostname
   - dynamic route changes
7. `iframe-video.html`
   - embedded video frame
8. `shadow-dom-app.html`
   - open shadow roots
   - attachShadow usage
9. `fetch-xhr-ad-response.html`
   - controlled fetch/XHR JSON/text responses containing ad fields
10. `wrapper-conflict.html`
   - page installs its own fetch/XHR/history/attachShadow wrappers before and after extension activation

## Required e2e assertions

### App shell

- smart runtime not loaded by default
- video runtime not loaded by default
- interceptors not loaded by default
- contenteditable remains editable
- buttons remain clickable
- route changes do not trigger unsafe mutation

### Auth/payment

- no DOM removal
- no click simulation
- no prototype wrapping
- forms remain usable
- focus is preserved
- inputs are not hidden/removed

### Article

- cosmetic CSS can apply when policy permits
- no app-shell protections accidentally disable normal article filtering

### Video

- video runtime activates through policy
- skip click only happens with `skip-click`
- overlay neutralization only with `neutralize-click`
- observers disconnect on deactivation

### Unknown app-like

- safe behavior by default
- no smart/video/interceptor layer unless policy explicitly allows

### Shadow DOM

- attachShadow wrapper is authorized and restored
- shadow scan stops on stale token
- markers are removed on destroy

### Fetch/XHR

- wrappers install only with valid actions
- mutation requires mutate action at mutation time
- stale token restores wrappers
- later page wrappers are not clobbered

## Acceptance

At least one CI or local command runs these fixtures:

```bash
npm run test:playwright
```

or:

```bash
npm run check:e2e:local
```

If full e2e cannot run in CI, add a documented smoke subset that does run in CI.


---

# 12A. Evidence quality matrix

Every claim needs the right type of evidence.

## Evidence levels

1. `source-contract`
   - AST/static/source check.
   - Useful for preventing obvious bypasses.
   - Not enough for runtime lifecycle behavior.
2. `runtime-unit`
   - Executes functions/classes with mocked DOM/browser APIs.
   - Required for wrappers, registries, rollback, token expiry, and lease behavior.
3. `browser-fixture`
   - Runs the actual extension or bundled runtime in a browser-like environment.
   - Required for DOM mutation, page forms, contenteditable, video, shadow DOM, bridge, and SPA behavior.
4. `release-profile`
   - Full release build/profile/certificate/store constraints.
   - Required before public claims.

## Required mapping

For every item in `runtime-mutation-inventory`, require at least:

- static source coverage
- runtime-unit test if the operation has rollback or async behavior
- browser-fixture test if the operation affects real DOM/browser APIs

## Forbidden completion claim

Do not write “done” or “all gaps closed” when evidence is only:

- regex tests
- source string tests
- generated-file inspection
- unverified commit message
- local claim without command output
- code review without runtime/browser proof

## Acceptance

The repository can generate a table:

```text
operation | static | runtime-unit | browser-fixture | release-profile | status
```

No high-risk operation is marked complete without the required evidence level.

---

# 12B. Browser fixture instrumentation requirements

Fixtures must not only load pages. They must measure outcomes.

Each fixture should expose a result object such as:

```js
window.__fixtureResults = {
  editableWorked: true,
  focusedElementPreserved: true,
  formsUsable: true,
  removedProtectedNodes: 0,
  hiddenInputs: 0,
  clickSimulations: 0,
  prototypeWrappersRestored: true,
  observerCountAfterDeactivate: 0,
  styleNodesAfterDeactivate: 0,
  bridgeRejectedForgedMessages: true
};
```

Required instrumentation:

- count removed nodes by protected category
- count hidden form/input/contenteditable elements
- count synthetic clicks
- count event listeners added/removed where possible
- count observer/timer cleanup
- verify prototype wrappers before/after
- verify focus and text input still work
- verify bridge rejects hostile messages
- verify runtime activation layer list matches expected policy

Acceptance:

Browser fixtures prove page behavior, not merely absence of thrown errors.


---

# 13. CI/check split

Keep dev and release profiles separate.

## Required scripts

```json
{
  "check:source-contracts": "...",
  "check:runtime-inventory": "...",
  "check:e2e:smoke": "...",
  "check:e2e:local": "...",
  "check:all:dev": "...",
  "check:all:release": "..."
}
```

## Dev profile

Must pass during normal development:

```bash
npm run check:all:dev
```

Should include:

- build
- typecheck
- unit tests
- runtime inventory
- mutation wrapper checker
- policy schema
- manifest policy entrypoint
- cross-layer integration
- dev security checks
- e2e smoke if practical

Must not include release-only blockers such as no remote rule fetch if dev intentionally permits remote updates.

## Release profile

Must pass before release:

```bash
npm run check:all:release
```

Should include everything in dev plus:

- no remote rule fetch
- strict store profile
- release manifest
- release ruleset profile
- release certificate
- package provenance
- browser/e2e corpus or documented release evidence

## Acceptance

- `check:all` aliases to dev profile.
- `check:all:release` is stricter.
- Docs clearly state which command is required when.


---

# 13A. Feature flags, safe mode, and kill switches

Feature flags and safe mode are not complete unless they actively revoke already-installed runtime effects.

## Required feature flag model

Every risky feature must have:

```json
{
  "id": "smartCosmetics",
  "default": false,
  "scope": "global|profile|host|tab|frame",
  "expiry": "YYYY-MM-DD",
  "owner": "...",
  "risk": "dom-mutation|prototype-hook|network-rule|response-mutation",
  "deactivation": "rollback-smart-runtime"
}
```

Risky features include:

- smart cosmetics
- generic video mutation
- skip-click
- click neutralization
- interceptors
- response mutation
- prototype wrapping
- scriptlets
- dynamic/session DNR
- remote filter updates
- anti-adblock countermeasures

## Required behavior

When a feature flag is disabled or expires:

1. policy resolver denies it
2. SW invalidates affected snapshots
3. runtime receives deactivation
4. owned resources are rolled back
5. future activation denies the layer/action
6. audit record is written

## Required safe mode

Safe mode must disable:

- smart runtime
- video runtime
- interceptors
- scriptlets
- response mutation
- prototype hooks
- DOM removal
- click simulation
- dynamic/session DNR unless explicitly safe

Safe mode may allow:

- static DNR
- simple cosmetic hiding only if policy permits
- user UI and diagnostics

## Required tests

- disabling feature flag revokes active runtime
- expired feature flag fails policy schema/check
- safe mode deactivates all active risky layers
- safe mode blocks new risky activation
- host-level kill switch invalidates only affected host/frame
- global kill switch invalidates all active snapshots

## Acceptance

Feature flags and kill switches change live runtime behavior, not only future policy resolution.



---

# 13B. Supply-chain, dependency, and build reproducibility closeout

A release can be runtime-safe but still unsafe if build inputs or dependencies are not controlled.

## Required dependency policy

Inventory:

- npm dependencies
- dev dependencies
- build tools
- browser test tools
- generated artifacts
- downloaded resources
- filter-list sources
- release packaging scripts

For each dependency:

```json
{
  "name": "esbuild",
  "type": "devDependency",
  "versionPolicy": "pinned or locked",
  "purpose": "bundle runtime scripts",
  "risk": "build-time code execution",
  "audit": "npm audit / lockfile integrity",
  "owner": "build"
}
```

## Required checks

- lockfile present and enforced
- no dependency without lockfile integrity
- no install script surprises unless allowlisted
- no remote build-time downloads unless allowlisted
- reproducible build from clean checkout
- generated artifacts match source
- release package contains expected files only
- release package excludes tests/secrets/dev artifacts
- release package includes correct manifest profile
- dependency vulnerability check has documented policy
- abandoned or high-risk packages are flagged

## Required release artifact

Generate:

```text
artifacts/release-evidence/
```

containing:

- commit SHA
- build command
- test commands
- manifest diff dev vs release
- package file list
- checksums
- policy schema result
- inventory result
- e2e result summary
- dependency audit summary
- known limitations

## Acceptance

A reviewer can reproduce the build and verify the package from evidence.

---

# 13C. Browser compatibility matrix

Do not assume one Chromium runtime covers all supported browsers.

## Required browser profiles

At minimum define:

- Chrome stable
- Chrome beta/dev if used for testing
- Microsoft Edge stable if supported
- Chromium ungoogled or Brave only if explicitly supported
- Firefox only if there is an actual supported manifest path, otherwise mark unsupported

For each profile:

```json
{
  "browser": "Chrome",
  "channel": "stable",
  "minimumVersion": "...",
  "mv3Support": true,
  "documentIdSupport": true,
  "scriptingWorldSupport": true,
  "dnrLimits": "...",
  "testCommand": "npm run test:e2e:chrome"
}
```

## Required compatibility checks

- `chrome.scripting.executeScript` MAIN world behavior
- `documentId` availability and fallback
- DNR limits
- service-worker lifecycle behavior
- extension storage quota
- declarativeNetRequest behavior
- host permissions UX
- web accessible resources behavior
- CSP enforcement
- content script iframe behavior

## Acceptance

Supported browsers are tested or explicitly scoped. Unsupported browsers are not implied.



---

# 13D. Privacy policy, store disclosure, and user-facing claims

Runtime privacy is not enough. User-facing claims must match actual behavior and store disclosures.

## Required artifacts

Create or update:

```text
docs/PRIVACY_REVIEW.md
docs/STORE_DISCLOSURE_MATRIX.md
```

If publishing to a browser store, also maintain the store-facing privacy answers.

## Required disclosure matrix

For every data category, state whether the extension:

```json
{
  "category": "browsing history / visited URLs",
  "collected": "no|local-only|transmitted",
  "stored": "no|local-only|sync|remote",
  "transmittedToDeveloper": false,
  "usedFor": ["ad blocking", "per-site settings"],
  "retention": "local until user clears extension data",
  "userControl": "clear settings / disable feature",
  "evidence": ["diagnostics-redaction-results", "storage-inventory"],
  "storeDisclosure": "matches"
}
```

Cover:

- URLs and hostnames
- filter lists
- user filters
- per-site switches
- diagnostics
- logs
- remote filter update requests
- DNR audit records
- page text reads
- response-body inspection
- extension errors/crashes
- telemetry, if any
- browser sync, if used

## Required rules

- No telemetry unless explicitly documented and user-controlled.
- No sensitive page text in diagnostics or logs.
- No privacy claim without evidence.
- Store disclosures must match implementation.
- README/marketing claims must match evidence.
- If data is local-only, verify no code transmits it.
- If remote filter updates reveal IP/request metadata, document it.
- If browser sync is used, document what syncs.

## Required tests/checks

- check README/store claims against disclosure matrix
- check no telemetry endpoint exists unless declared
- check diagnostics export redaction
- check no sensitive fixture text appears in logs
- check remote update URLs are allowlisted and documented

## Acceptance

Privacy behavior, code, docs, and store disclosures are consistent.

---

# 13E. Licensing and third-party notice closeout

The extension may include dependencies, filter lists, redirect resources, icons, CSS, copied snippets, or generated code. These must be tracked.

## Required artifacts

Create:

```text
docs/THIRD_PARTY_NOTICES.md
artifacts/release-evidence/license-inventory.json
```

## Required inventory

For each third-party item:

```json
{
  "name": "...",
  "type": "npm dependency | filter list | icon | redirect resource | code snippet | build tool",
  "source": "...",
  "license": "...",
  "includedInPackage": true,
  "requiresNotice": true,
  "noticeLocation": "docs/THIRD_PARTY_NOTICES.md",
  "updatePolicy": "...",
  "owner": "..."
}
```

Cover:

- npm packages
- bundled JS/CSS/assets
- redirect resources
- static rulesets
- filter lists
- generated code sources
- copied uBlock/uBO-like logic if any
- icons/images/fonts
- test fixtures copied from external sources

## Required checks

- every packaged third-party file has license provenance
- notices generated for licenses requiring notice
- incompatible licenses fail release check
- unknown license fails release check
- filter-list license/terms documented
- assets/icons/fonts have provenance
- package excludes unnecessary third-party dev files

## Acceptance

The release package is legally traceable.

---

# 13F. GitHub Actions and CI security hardening

CI can become a supply-chain attack surface.

## Required checks

Create or extend:

```text
tools/check-github-actions-security.mjs
```

Check:

- third-party actions pinned to SHA or justified
- workflow permissions are least-privilege
- `pull_request_target` not used unsafely
- secrets unavailable to untrusted PR code
- artifact upload/download paths are controlled
- no script curls remote code into shell
- no untrusted checkout used with privileged token
- release workflow requires protected branch/tag
- package publishing requires explicit release profile
- caches do not store secrets
- workflow dispatch inputs validated

## Required workflow inventory

For each workflow:

```json
{
  "workflow": ".github/workflows/ci.yml",
  "triggers": ["push", "pull_request"],
  "permissions": {"contents": "read"},
  "thirdPartyActions": ["actions/checkout@<sha>"],
  "secrets": [],
  "artifacts": ["test-results"],
  "risk": "low",
  "owner": "..."
}
```

## Acceptance

CI is not a hidden privileged bypass.

---

# 13G. Versioning, changelog, and upgrade/downgrade compatibility

A safe release must be versioned and explain behavior changes.

## Required artifacts

Create or update:

```text
CHANGELOG.md
docs/UPGRADE_COMPATIBILITY.md
```

## Required rules

- Every release increments version consistently.
- Manifest version matches package/build metadata.
- Changelog includes:
  - runtime policy changes
  - permission changes
  - privacy/disclosure changes
  - compatibility exceptions added/removed
  - filter-list behavior changes
  - migration notes
  - known limitations
- Upgrade path preserves user filters and switches.
- Downgrade behavior is documented where feasible.
- Feature removals have migration or fallback notes.
- Compatibility exceptions removed by expiry are documented.

## Required tests/checks

- manifest/package version consistency
- changelog entry exists for release
- migration tests cover previous supported version
- release notes include accepted user-visible risks
- known limitations file matches accepted-risk records

## Acceptance

Users and reviewers can understand what changed and what risk remains.

---

# 13H. Vulnerability disclosure and security response

Security issues need an intake and response path.

## Required artifacts

Create:

```text
SECURITY.md
docs/SECURITY_TRIAGE.md
```

## Required contents

`SECURITY.md` must include:

- supported versions
- how to report a vulnerability
- expected response process
- what information to include
- safe-harbor language if desired
- disclosure timeline policy
- security contact or issue process

`SECURITY_TRIAGE.md` must define severity for:

- arbitrary code execution
- remote code execution
- token/capability bypass
- hostile page bridge bypass
- unsafe mutation on auth/payment pages
- privacy leakage
- supply-chain compromise
- DNR unsafe rule injection
- extension permission escalation
- update/migration data loss

## Required tests/checks

- `SECURITY.md` exists
- supported versions match release docs
- vulnerability categories map to threat model
- critical categories are release blockers unless accepted risk explicitly overrides

## Acceptance

Security reports are actionable and tied to the threat model.

---

# 13I. Maintenance ownership and recurring review cadence

Closeout must not become stale immediately after release.

## Required artifacts

Create:

```text
docs/MAINTENANCE_OWNERSHIP.md
docs/REVIEW_CADENCE.md
```

## Required ownership table

For each area:

```json
{
  "area": "smart runtime",
  "owner": "...",
  "backupOwner": "...",
  "reviewCadence": "monthly|per-release|quarterly",
  "requiredChecks": ["..."],
  "staleAfterDays": 90
}
```

Cover:

- policy schema
- runtime inventory
- sensitive-read inventory
- cosmetic runtime
- smart runtime
- video runtime
- interceptors
- DNR
- browser fixtures
- filter/parser corpus
- release evidence
- privacy disclosures
- dependencies
- accepted risks
- compatibility exceptions
- feature flags
- GitHub Actions
- store listing

## Required expiry checks

Fail release when any of these are stale:

- compatibility exceptions
- accepted risks
- feature flags with expiry
- unsupported-browser assumptions
- privacy disclosure review
- dependency audit
- filter-list source review
- store disclosure review
- release evidence template

## Acceptance

The closeout plan remains alive and reviewable after the first release.


---

# 14. Static checker upgrades

Current checker must become stricter and less regex-dependent.

## Required capabilities

The checker must reject:

- validation not awaited
- validation result ignored
- validation after mutation
- wrong action for mutation
- generic check used for mutation
- cached permission boolean used for future mutation
- observer callback mutation without callback-local auth
- timer callback mutation without callback-local auth
- prototype hook without ownership-aware restore
- wrapper without restore path
- inserted element without ownership marker
- event listener without cleanup
- DNR update outside transaction module

## Required callback rule

Authorization must occur in the same async callback or in a directly called awaited function.

This is not sufficient:

```ts
await authorizeSmart("smart-observe");
new MutationObserver(() => {
  executePlan();
});
```

This is acceptable:

```ts
new MutationObserver((mutations) => {
  queueMicrotask(() => void this.handleObservedMutations(mutations));
});

async handleObservedMutations(mutations) {
  if (!await authorizeSmart("smart-selector-update")) return;
  await this.executePlan();
}
```

## Acceptance

Checker enforces action-specific control flow, not just text presence.


---

# 14A. Sensitive-read inventory

The mutation inventory is not enough. Some breakage and privacy risk comes from reading sensitive page content, not only mutating it.

## Required read inventory

Inventory reads from:

- `input.value`
- `textarea.value`
- contenteditable text
- form fields
- payment fields
- password fields
- selection text
- full `textContent` of large containers
- ARIA labels in auth/payment forms
- URLs with query parameters
- cookies if ever accessed
- localStorage/sessionStorage if ever accessed
- response bodies
- XHR/fetch text
- DOM snapshots
- clipboard if ever accessed

For each read, record:

```json
{
  "operation": "element.textContent",
  "purpose": "ad-like text classification",
  "scopeLimit": "max 4096 chars, excluded on auth/payment/contenteditable",
  "storage": "not persisted",
  "logging": "not logged",
  "profileDenied": ["auth", "payment", "contenteditable-app"],
  "tests": ["..."]
}
```

## Required rules

- Never read password/payment field values.
- Do not inspect contenteditable text unless profile explicitly allows it.
- Do not persist raw page text.
- Do not log sensitive text.
- Response mutation code may parse response body only when interceptor policy allows and content type/URL budget allows.
- Sensitive profiles must deny response-body inspection unless explicitly safe.

## Required tests

- auth fixture proves password value is not read/logged
- payment fixture proves card-like fields are not read/logged
- contenteditable fixture proves editor text is not read/logged
- response-body parser denied on auth/payment
- logs contain no sensitive fixture text

## Acceptance

Privacy-sensitive reads are governed with the same seriousness as mutations.



---

# 14B. Diagnostics, logging, telemetry, and user-control closeout

Safety hardening must be visible and controllable without leaking sensitive data.

## Diagnostics requirements

Add a diagnostics model that can answer:

- which policy profile applied?
- which layers activated?
- which layers were denied?
- which actions were denied?
- which feature flag or safe-mode rule caused denial?
- which runtime resources are currently installed?
- which hooks/observers/timers are active?
- which DNR transaction ran?
- what was rolled back?
- why did a page enter fail-safe?

## Logging/privacy rules

- No password/payment/contenteditable text in logs.
- No raw response body in logs.
- No full URL query string in logs unless redacted.
- No persistent logs of sensitive page data.
- Debug logs off by default.
- User can export diagnostics with redaction.
- Redaction must be tested.

## User controls

UI/popup/options must accurately reflect:

- global on/off
- per-site net filtering
- per-site cosmetic filtering
- no-remote-fonts/no-large-media
- smart cosmetics flag
- video runtime flag
- interceptors flag
- safe mode
- feature flags/expiry if exposed
- current page profile
- current active layers

Changing a user control must:

1. update storage
2. invalidate policy snapshot
3. deactivate affected runtime
4. update UI state
5. write audit/diagnostic event without sensitive data

## Required tests

- UI toggle deactivates active runtime
- UI state matches policy state
- diagnostics show active layers
- diagnostics redacts URLs/form data
- denied actions are visible in diagnostics
- safe mode UI disables risky layers
- export diagnostics contains no sensitive fixture text

## Acceptance

Users can understand and control runtime behavior without exposing private data.

---

# 14C. Accessibility, localization, and UI-safety closeout

Extension UI and injected UI must not regress accessibility or localization.

## Required checks

Cover:

- popup/options keyboard navigation
- picker/zapper keyboard escape/close behavior
- focus return after picker close
- ARIA labels for extension UI
- no trapping focus on page
- high-contrast/forced-colors behavior
- reduced motion where relevant
- localization key completeness
- no missing i18n strings
- no raw placeholder text in generated pages
- RTL layout if supported
- screen-reader-friendly status messages

## Required tests

- picker open/quit preserves page focus
- picker quit works without token
- popup controls have accessible names
- options controls have accessible names
- missing i18n key check
- generated HTML has no untranslated `data-i18n` critical text
- extension UI does not hide page accessibility landmarks

## Acceptance

Runtime hardening does not create inaccessible or untranslated extension UI.


---

# 15. Commit order

Use this exact order to avoid chasing gaps.

## Commit 1 — Runtime mutation/read inventory, state machine, and source/build parity

- add mutation inventory tool
- add sensitive-read inventory tool
- inventory all high-risk operations and sensitive reads
- add per-layer runtime state machine
- fail on unclassified operations/read paths
- add generated/source parity manifest
- verify fixes exist in source and generated output
- wire into `check:all:dev`

## Commit 2 — Smart runtime closeout

- fix history wrapper binding
- authorize path-change work
- authorize shadow scan cycles
- ownership-aware attachShadow wrapper
- full smart rollback
- tests

## Commit 3 — Cosmetic registry and wrappers

- add cosmetic mutation registry
- route all cosmetic mutations through wrappers
- cover vAPI/domFilterer/userStylesheet/picker
- rollback and tests

## Commit 4 — Video registry and rollback

- add video mutation registry
- cleanup click neutralization handlers
- observer/timer cleanup
- rollback hidden/marked elements
- tests

## Commit 5 — Interceptor runtime tests

- add actual runtime tests for fetch/XHR/observer ownership and fallback
- prove no recursion/no clobber/no stale mutation

## Commit 6 — SW activation/deactivation and bridge tests

- zero active layers
- missing tab/frame
- deduped file mapping
- deactivation event
- token validation matrix
- hostile postMessage bridge payloads
- minimal token exposure
- document/activation ID invalidation

## Commit 7 — Policy profile matrix, feature flags, and safe mode

- machine-readable profile matrix
- schema validation
- app/auth/payment defaults
- compatibility expiry checks
- feature flag metadata and expiry
- safe mode live revocation
- kill-switch deactivation tests

## Commit 8 — DNR transaction, parser/list, and effectiveness proof

- direct DNR call ban
- transaction rollback tests
- audit records
- parser/list correctness corpus
- representative effectiveness corpus
- prove safety gates did not neuter blocking

## Commit 9 — Browser fixtures with instrumentation and frame topology

- app-shell
- auth
- payment
- article
- video
- unknown app
- iframe
- cross-origin frame where practical
- about:blank/srcdoc frame
- shadow DOM
- fetch/XHR
- wrapper conflict
- hostile bridge messages
- SPA navigation
- BFCache/pagehide/pageshow
- service-worker restart/fail-closed scenario where practical

## Commit 10 — Manifest, permissions, CSP, and browser compatibility

- manifest permission inventory
- CSP/remote-code checks
- web-accessible resource minimization
- browser compatibility matrix
- Chrome/Edge e2e smoke where supported

## Commit 11 — Diagnostics, user controls, accessibility, and localization

- redacted diagnostics
- UI toggles deactivate runtime
- popup/options state reflects policy
- picker focus/quit accessibility
- i18n completeness checks

## Commit 12 — Supply chain, release evidence, and test-quality closeout

- dependency/build reproducibility checks
- release evidence artifact
- test-quality negative fixtures
- dev/release checks
- final acceptance checklist
- no source-only claim of completion

## Commit 13 — Privacy, licensing, CI security, and operational closeout

- privacy/store disclosure matrix
- third-party notices and license inventory
- GitHub Actions security checks
- SECURITY.md and triage model
- changelog/version consistency
- maintenance ownership and review cadence


---

# 15A. Test-quality and anti-self-certification rules

Source-contract tests are easy for a coding LLM to satisfy without proving behavior. Add rules that prevent self-certification.

## Required rules

1. A test must fail before the implementation fix.
2. Regex/source tests must not be the only evidence for async/runtime behavior.
3. Tests must not merely check that a function name exists.
4. Tests must check behavior or checker rejection.
5. Checker tests must include negative fixtures.
6. Browser tests must assert page behavior, not just no console errors.
7. If a test reads generated files, it must also verify source/build parity.
8. Commit messages cannot be evidence.
9. CI status or local command output must be named.
10. Any skipped test must have reason and expiry.

## Required negative fixtures

For each checker, include intentionally bad fixtures:

- unawaited validation
- ignored validation result
- wrong action
- generic check used for mutation
- mutation after stale token
- observer callback without callback-local auth
- timer callback without callback-local auth
- wrapper without restore
- restore that clobbers later wrapper
- sensitive read in auth/payment profile
- direct DNR update outside transaction
- manifest high-risk broad injection

## Acceptance

The test suite proves it can catch the exact regressions this project keeps encountering.



---

# 15B. PR review, branch protection, and merge gates

A closeout plan is incomplete if changes can merge without proving they satisfy it.

## Required PR template

Create or update:

```text
.github/pull_request_template.md
```

Required sections:

```md
## Closeout requirement IDs

List requirement IDs from docs/CLOSEOUT_TRACEABILITY.md.

## Changed runtime layers

- [ ] bootstrap
- [ ] service worker
- [ ] cosmetic
- [ ] smart
- [ ] video
- [ ] interceptors
- [ ] DNR/rules
- [ ] UI/options/popup
- [ ] release/build

## Evidence

Commands run:

```bash
...
```

Artifacts produced:

```text
...
```

## Safety checklist

- [ ] Source and generated files are in parity.
- [ ] High-risk operations are inventoried.
- [ ] Sensitive reads are inventoried.
- [ ] Authorization is action-specific.
- [ ] Async callbacks have callback-local authorization.
- [ ] Lease checks cover stale token/revision/document.
- [ ] Rollback is ownership-aware.
- [ ] Tests include negative fixtures.
- [ ] Browser/e2e evidence exists when DOM/browser behavior changed.
- [ ] No host-specific exception was used as the main fix.
- [ ] Manifest permissions/CSP/WAR surface unchanged or justified.
- [ ] Privacy/logging impact reviewed.
- [ ] User-facing controls/docs updated if behavior changed.
```

## Required branch protection expectations

If GitHub branch protection is used, require:

- build
- unit tests
- runtime inventory
- sensitive-read inventory
- generated/source parity
- mutation checker
- policy schema
- manifest permission/CSP checks
- e2e smoke
- release evidence for release branches

## Acceptance

No future closeout-related PR can merge without mapping to requirements and evidence.


---

# 16. Final closeout checklist

Before saying the project is done, answer yes to every item.

## Product/repository governance

- [ ] Requirement traceability matrix exists.
- [ ] Accepted-risk process exists.
- [ ] Privacy/store disclosure matrix matches implementation.
- [ ] Third-party/license inventory exists.
- [ ] SECURITY.md and vulnerability triage exist.
- [ ] Maintenance ownership and review cadence exist.
- [ ] Changelog/version consistency checks pass.

## Threat model and permissions

- [ ] Threat model exists and maps assets/adversaries/abuse cases to tests.
- [ ] Manifest permissions are inventoried and justified.
- [ ] CSP forbids remote code and eval-like execution.
- [ ] Web-accessible resources are minimal and justified.
- [ ] Browser compatibility matrix exists for supported browsers.

## Architecture

- [ ] Broad manifest injection loads only low-risk bootstrap/client files.
- [ ] High-risk runtimes are injected only by SW after policy activation.
- [ ] `getPageActivation` is the normal startup path.
- [ ] `getPagePolicy` is diagnostic-only.
- [ ] One activation creates one snapshot.
- [ ] MAIN world gets minimal policy/token handles/revision before runtime files.
- [ ] MAIN-world bridge validates schema/source/layer/action/request IDs.
- [ ] Full token metadata is not exposed unless explicitly temporary and expiring.

## Runtime layers

- [ ] Interceptors are action-authorized and rollback-safe.
- [ ] Cosmetic runtime is action-authorized and rollback-safe.
- [ ] Smart runtime is action-authorized and rollback-safe.
- [ ] Video runtime is action-authorized and rollback-safe.
- [ ] No high-risk operation is outside inventory.
- [ ] No sensitive read path is outside inventory.
- [ ] Runtime state machine exists for each high-risk layer.
- [ ] Inventory maps each operation to static/runtime/browser evidence.
- [ ] Source and generated runtime files are in parity.

## Lifecycle

- [ ] Token expiry stops mutation.
- [ ] Policy revision change stops mutation.
- [ ] Deactivation rolls back runtime state.
- [ ] Pagehide/unload cleans up.
- [ ] Repeated activation does not stack wrappers/observers/styles.
- [ ] SPA navigation revalidates or deactivates runtime.
- [ ] BFCache/pagehide/pageshow lifecycle is handled.
- [ ] MV3 service-worker restart fails closed until revalidation.
- [ ] Restore does not clobber later wrappers.

## Safety profiles

- [ ] App shell safe by default.
- [ ] Contenteditable safe by default.
- [ ] Auth safe by default.
- [ ] Payment safe by default.
- [ ] Unknown app-like safe by default.
- [ ] Cross-origin iframe safe by default.
- [ ] about:blank/srcdoc inheritance is explicitly tested.
- [ ] Video page still works through policy.

## Tests

- [ ] Source contracts pass.
- [ ] Runtime unit tests pass.
- [ ] Browser/e2e fixtures pass.
- [ ] Negative checker fixtures prove bad patterns fail.
- [ ] UI/accessibility/i18n checks pass.
- [ ] Diagnostics redaction tests pass.
- [ ] Fixtures assert behavior, not merely no-crash.
- [ ] Effectiveness corpus proves representative ads still block.
- [ ] Parser/list corpus proves filter syntax behavior.
- [ ] Dev check passes.
- [ ] Release check passes under release profile.
- [ ] Release package evidence is generated and reproducible.
- [ ] Dependency/supply-chain checks pass.
- [ ] GitHub Actions security checks pass.
- [ ] License/third-party notice checks pass.
- [ ] Privacy/store disclosure checks pass.

## Evidence

- [ ] Commands and outputs are documented.
- [ ] CI or local evidence exists.
- [ ] Evidence level is documented per high-risk operation.
- [ ] No “done” claim relies only on regex tests.
- [ ] No permanent host exception is used as the main solution.


---

# 16A. Release rollout, rollback, and incident response

The technical closeout must include what happens if a release breaks pages or weakens blocking after deployment.

## Required artifact

Create:

```text
docs/RELEASE_ROLLOUT_AND_ROLLBACK.md
```

## Required release stages

Define:

1. local verification
2. CI verification
3. packaged extension smoke test
4. manual smoke test on representative pages
5. limited rollout / pre-release tag if applicable
6. full release
7. post-release monitoring window

## Required rollback paths

Document:

- how to disable risky feature flags remotely or via update
- how to enable safe mode
- how to revert release
- how to publish hotfix
- how to invalidate unsafe compatibility exception
- how to disable remote filter updates if compromised
- how to remove bad DNR rules
- how to clear corrupt runtime caches while preserving user filters

## Incident categories

At minimum:

- app-shell breakage
- auth/payment breakage
- contenteditable/editor breakage
- video site breakage
- ad-blocking effectiveness regression
- remote filter/list issue
- privacy/logging issue
- performance/memory issue
- browser compatibility issue
- store compliance issue

## Required incident checklist

For each incident:

```text
symptom
affected version
affected profile/layer
safe-mode mitigation
feature flag mitigation
data/privacy exposure yes/no
rollback required yes/no
hotfix required yes/no
test to prevent recurrence
release note required yes/no
```

## Acceptance

A bad release has a documented rollback path that preserves user settings and minimizes page breakage.


---

# 17. Minimal command set

At the end, these commands should be valid:

```bash
npm run build
npm run typecheck
npm run test
npm run check:mutation-wrappers
npm run check:runtime-inventory
npm run check:sensitive-read-inventory
npm run check:runtime-state-machine
npm run check:generated-artifacts
npm run check:manifest-permissions
npm run check:csp-and-remote-code
npm run check:web-accessible-surface
npm run check:page-policy-schema
npm run check:manifest-policy-entrypoint
npm run check:cross-layer-integration
npm run check:all:dev
npm run test:playwright
npm run check:e2e:smoke
npm run check:effectiveness-corpus
npm run check:parser-corpus
npm run check:traceability
npm run check:accepted-risks
npm run check:diagnostics-redaction
npm run check:i18n
npm run check:a11y
npm run check:release-evidence
npm run check:privacy-disclosures
npm run check:third-party-notices
npm run check:github-actions-security
npm run check:version-changelog
npm run check:security-policy
npm run check:maintenance-cadence
npm run check:final-closeout-package
npm run check:all:release
```

If any command is intentionally local-only or release-only, document that clearly.


---

# 17A. Final signoff package

Before declaring the closeout complete, generate a single signoff package.

## Required directory

```text
artifacts/final-closeout/
```

Required contents:

```text
README.md
traceability.json
traceability.md
accepted-risks.md
commands-run.txt
command-results/
release-evidence/
runtime-inventory.json
sensitive-read-inventory.json
state-machine-report.json
policy-profile-matrix.json
manifest-permission-inventory.json
csp-remote-code-report.json
web-accessible-surface-report.json
browser-compatibility-matrix.json
e2e-results/
effectiveness-corpus-results/
parser-corpus-results/
diagnostics-redaction-results/
a11y-i18n-results/
dependency-audit-results/
package-checksums.txt
known-limitations.md
rollback-plan.md
privacy-disclosure-matrix.json
third-party-notices.md
github-actions-security-report.json
security-policy-review.md
version-changelog-report.json
maintenance-ownership.md
```

## Required README summary

The package README must answer:

1. What commit is being signed off?
2. What commands were run?
3. Which browser/profile was tested?
4. Which requirements remain accepted risk?
5. Which requirements are not applicable?
6. What release profile was used?
7. What package/checksum was produced?
8. What rollback plan applies?

## Acceptance

The final state is reproducible from one artifact directory, not reconstructed from scattered chat messages or commit claims.


---

# 18. Practical guidance for the coding LLM

Do not submit a commit that only says “tests pass” unless the relevant commands are named.

Do not submit a commit that only adds regex tests for a runtime behavior. Pair source tests with runtime tests when behavior involves:

- callbacks
- timers
- observers
- wrapper installation
- wrapper restoration
- page lifecycle
- browser APIs
- DOM mutation
- DNR updates

Do not add new broad host exclusions. If a site breaks, classify the page and fix policy/runtime behavior.

Do not consider a runtime layer complete until it has:

- action table
- authorization helper
- lease helper
- registry
- rollback
- source checker
- runtime tests
- e2e fixture where applicable

This is the end-to-end closeout plan. Follow it in order.


---

# 19. Anti-whack-a-mole gate

Before accepting any future commit, ask these questions:

1. Did it fix the source, not only generated output?
2. Did it inventory the affected operation?
3. Did it add exact action authorization?
4. Did it add lease checks for async paths?
5. Did it add ownership-aware rollback?
6. Did it add static and runtime tests?
7. Did it add browser fixture coverage if real DOM/browser behavior is involved?
8. Did it avoid host-specific exceptions?
9. Did it preserve app-shell/auth/payment safety?
10. Did it prove dev/release checks still make sense?

If any answer is “no,” the commit is not a closeout commit. It is only another local patch.


---

# 20. Final remaining-gap audit

Before accepting the final implementation, perform this audit as a table.

```text
gap category | covered by design | source check | runtime test | browser/e2e test | release evidence | remaining risk
```

Rows must include:

- traceability matrix
- accepted risks
- privacy/store disclosures
- third-party notices/licensing
- GitHub Actions security
- vulnerability disclosure
- versioning/changelog
- maintenance ownership
- threat model
- manifest permissions
- CSP/remote-code policy
- web-accessible resource surface
- browser compatibility
- runtime state machine
- mutation inventory
- sensitive-read inventory
- source/generated parity
- authorization wrappers
- lease checks
- ownership-aware rollback
- MAIN-world bridge security
- token minimization
- service-worker restart
- SPA navigation
- BFCache/pagehide/pageshow
- iframe/cross-origin topology
- policy profile matrix
- feature flags and safe mode
- cosmetic runtime
- smart runtime
- video runtime
- interceptors
- DNR transaction lifecycle
- storage migrations
- parser/list correctness
- ad-blocking effectiveness
- privacy logging
- diagnostics redaction
- accessibility
- localization
- user controls
- performance budgets
- dependency/supply-chain integrity
- release evidence artifact
- rollback/incident plan
- PR review/merge gates
- final signoff package
- dev CI
- release CI

The final accepted state must have no blank cells except where a row is explicitly marked not applicable with a reason.


---

# 21. Final implementation review protocol

When reviewing future commits against this document, use this protocol.

## Step 1 — Classify the commit

Classify it as one of:

- architecture
- runtime layer
- policy/profile
- DNR/rules
- test/check
- UI/diagnostics
- release/build
- compatibility
- documentation-only

A commit cannot claim closeout for a category it does not touch.

## Step 2 — Identify affected invariants

For each changed file, identify affected invariants:

- authorization
- lease
- rollback
- ownership
- state machine
- source/build parity
- frame/document identity
- bridge security
- privacy reads/logging
- permissions/CSP
- effectiveness
- release evidence

## Step 3 — Demand the right evidence

- Source-only change needs source check.
- Runtime behavior needs runtime test.
- Browser behavior needs browser fixture.
- Release claim needs release evidence.
- Security boundary needs hostile/negative tests.

## Step 4 — Reject local patch claims

Reject the commit as incomplete if it:

- fixes generated output only
- adds source regex tests only for runtime behavior
- lacks negative fixtures
- lacks rollback
- lacks frame/document identity
- adds host-specific exception as main fix
- increases permissions without justification
- hides an issue under dev/release profile confusion
- claims tests passed without naming commands
- reduces ad-blocking effectiveness without corpus proof

## Step 5 — Update traceability

Every accepted commit must update:

- traceability matrix
- affected inventory records
- accepted-risk records if any
- release evidence if release-facing
- rollback plan if runtime behavior changed

## Acceptance

A future reviewer can use this protocol and this document to prevent another loop of “fixed one thing, found another unclosed path.”


---

# 22. Stop condition

This closeout effort stops only when all of the following are true:

1. Every requirement has a traceability entry.
2. Every high-risk operation is inventoried.
3. Every sensitive read is inventoried.
4. Every high-risk layer has a state machine.
5. Every runtime layer has action authorization, lease checks, rollback, and ownership tracking.
6. Every async callback path is callback-local authorized.
7. Every frame/document path is tested or explicitly out of scope.
8. Manifest permissions, CSP, WAR, and remote-code checks pass.
9. Storage migration and rollback checks pass.
10. Parser/list/effectiveness corpora pass.
11. App-shell/auth/payment/contenteditable/video/unknown fixtures pass.
12. Diagnostics/logging redaction checks pass.
13. Accessibility/localization checks pass.
14. Dev checks pass.
15. Release checks pass under release profile.
16. Release evidence package exists.
17. Accepted risks are documented with owners and review dates.
18. Rollback/incident plan exists.
19. PR template and merge gates exist.
20. A reviewer can reproduce the result from the final signoff package.
21. Privacy/store disclosures match implementation.
22. Third-party notices and license inventory are complete.
23. GitHub Actions security checks pass.
24. SECURITY.md and triage docs exist.
25. Version/changelog checks pass.
26. Maintenance ownership and review cadence are documented.

If any item is missing, the project is not done. It may be improved, but it is not closed.


---

# 23. Boundary of this document

This document is now intended to cover the end-to-end closeout for:

- runtime safety
- page compatibility
- ad-blocking effectiveness
- extension security
- privacy
- release readiness
- repository governance
- maintenance continuity

It does not attempt to guarantee:

- that every ad on every site is blocked
- that every browser outside the declared compatibility matrix works
- that every future web platform change is anticipated
- that accepted risks are zero

Those are handled through the effectiveness corpus, compatibility matrix, accepted-risk process, and maintenance cadence.

A future update should add content only when it identifies a concrete ungoverned risk category, not merely another way to restate authorization, rollback, testing, or release evidence.
