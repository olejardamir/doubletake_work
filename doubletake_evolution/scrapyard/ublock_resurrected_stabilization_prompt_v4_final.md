# LLM Implementation Prompt v4 FINAL: Stabilize uBlockResurrected for AI-Safe Coding

Repository:

```text
https://github.com/Astrocytech/uBlockResurrected
```

## Rating of the previous prompt

Previous prompt version: **10/10 for static-instruction completeness after re-audit**

No additional mandatory stabilization category was found beyond the v3 coverage. This v4 file keeps the full v3 implementation prompt and updates the rating statement.

Earlier reason v2 was not a full 10/10:

- It covered the main architectural instability, but it did not fully force the coding agent to audit all gate blind spots.
- It did not explicitly require source ownership checks for every browser-loaded entrypoint.
- It did not fully separate checked-in source, generated artifacts, release artifacts, and legacy upstream artifacts.
- It did not require a browser-extension lifecycle audit.
- It did not require a strict check that audit tools are not excluding the exact files that need to be audited.
- It did not fully require packaging/release reproducibility.
- It did not explicitly require privacy/compliance/profile separation for dev, strict-store, and release.
- It did not require a final “AI agent friendliness score” with objective criteria.

This v4 prompt is rated **10/10 for static-instruction completeness** based on the available repository inspection and follow-up audit.  
The actual repository cannot be declared fixed until the coding agent runs the required local commands and reports the results.

---

# Mission

Your task is not to add a new blocker feature.

Your task is to make this repository structurally stable, auditable, and safe for future LLM coding agents.

The current failure mode is architectural, not merely local bugs. One improvement breaks another because the repo has unclear ownership, duplicate runtime paths, loose validation, misleading gates, mixed generated/source files, and documentation that claims more certainty than the code proves.

The final result must make the repository boring:

- one canonical runtime path,
- one canonical service-worker source,
- honest build failures,
- real type/lint coverage,
- runtime smoke tests,
- documented source ownership,
- documented generated artifacts,
- consistent docs/certificate/CI claims,
- safe future workflow for LLM coding agents.

---

# 0. Non-negotiable working rules

Follow these rules throughout the task:

1. Do not add new ad-blocking features.
2. Do not add new filter heuristics.
3. Do not redesign UI.
4. Do not rewrite large files only for style.
5. Do not delete files until their role is classified.
6. Do not leave two active implementations for the same behavior.
7. Do not leave production-looking stubs.
8. Do not leave fake dependency-injection exports.
9. Do not let build scripts print success after failed bundles.
10. Do not make docs more optimistic than the checks.
11. Do not weaken gates just to pass CI.
12. Do not hide failures under broad `catch {}` blocks.
13. Do not claim Chrome Web Store readiness without a strict-store profile.
14. Do not claim Gold unless release certificate checks actually produce Gold.
15. Do not treat checked-in generated artifacts as source unless documented.
16. Do not let future LLM agents guess which file to edit.
17. Prefer small commits and clear phase boundaries.
18. Add guardrails before risky refactors.
19. Preserve user data compatibility unless migration tests prove otherwise.
20. If something cannot be fixed in this pass, document it with exact file paths and exact failing checks.

---

# 1. Create the stabilization control files first

Before behavior refactoring, create these files:

```text
AGENTS.md
docs/STABILIZATION_LOG.md
docs/STABILIZATION_MIGRATION_PLAN.md
docs/ARCHITECTURE_RUNTIME_MAP.md
docs/GENERATED_ARTIFACTS.md
docs/DNR_RULE_OWNERSHIP.md
docs/STORAGE_SCHEMA.md
docs/EXTENSION_PROFILES.md
docs/CI_GATE_MATRIX.md
docs/RELEASE_REPRODUCIBILITY.md
```

These files are not optional.

They are the first guardrails that stop future LLM agents from repeating the current failure pattern.

---

# 2. AGENTS.md: future LLM editing contract

Create:

```text
AGENTS.md
```

It must be short, strict, and practical.

It must tell future LLM coding agents:

- canonical browser target,
- canonical manifest path,
- canonical service-worker source,
- manifest-loaded service-worker output,
- generated files,
- legacy/quarantined files,
- source files that can be edited,
- files that must not be edited directly,
- checks required before claiming success,
- forbidden shortcuts,
- safe feature-change workflow,
- how to add tests,
- where to document architectural decisions.

Minimum required structure:

```md
# AGENTS.md

## Canonical runtime

## Canonical source files

## Generated files

## Legacy/quarantined files

## Required checks before completion

## Forbidden shortcuts

## Safe feature-change workflow

## How to add tests

## How to update docs and gates
```

Required rule:

```text
Future agents must be able to identify the canonical runtime path in under one minute.
```

If `AGENTS.md` cannot make that true, the task is not complete.

---

# 3. Stabilization log

Create:

```text
docs/STABILIZATION_LOG.md
```

Every phase must record:

- date,
- branch,
- files inspected,
- files changed,
- commands run,
- command results,
- failures,
- decisions,
- remaining risks,
- next safe task.

Do not rely on memory or chat context. The repo itself must contain the record.

---

# 4. Runtime architecture map

Create:

```text
docs/ARCHITECTURE_RUNTIME_MAP.md
```

It must map the real runtime graph.

Inspect at least:

```text
package.json
package-lock.json
build.mjs
Makefile
tsconfig.json
eslint.config.mjs
.github/workflows/ci.yml
README.md
BENCHMARK.md
CONTRIBUTING.md
MISSING.md
platform/chrome/manifest.json
platform/chrome/js/sw.js
platform/chromium/manifest.json
platform/chromium/js/sw.js
platform/chromium/js/*-bundle.js
src/js/mv3/sw-entry.ts
src/js/mv3/sw-policies.ts
src/js/mv3/sw-firewall.ts
src/js/mv3/sw-storage.ts
src/js/mv3/sw-toggle-handlers.ts
src/js/mv3/sw-message-router.ts
tools/check-no-remote-rule-fetch.mjs
tools/audit-mv3-manifest.mjs
tools/check-store-compliance.mjs
tools/check-certificate-aggregation.mjs
```

The map must state:

- all manifest files,
- which manifest is canonical,
- which manifest is legacy,
- which service worker each manifest loads,
- whether each service worker is source or generated,
- which source produces the generated service worker,
- all content scripts listed in each manifest,
- all web-accessible resources listed in each manifest,
- DNR rulesets listed in each manifest,
- popup/options pages listed in each manifest,
- build scripts that generate each artifact,
- validation scripts that check each artifact,
- tests that exercise each artifact,
- files future agents must not edit directly.

Do not assume docs are accurate. Verify from code.

---

# 5. Generated artifacts inventory

Create:

```text
docs/GENERATED_ARTIFACTS.md
```

For each generated or possibly generated file, document:

- path,
- source,
- command that generates it,
- whether it is committed,
- whether it is ignored,
- whether it is release artifact,
- how to verify it is current,
- whether future agents may edit it directly.

Audit at least:

```text
dist/
.cache/
node_modules/
platform/chrome/dnr/
platform/chromium/dnr/
platform/chrome/js/sw.js
platform/chromium/js/sw.js
platform/chromium/js/*-bundle.js
platform/chrome/js/*-bundle.js
package-lock.json
```

Required outcome:

- no dependency directories committed,
- generated files either not committed or reproducibly checked,
- generated service-worker output clearly marked,
- generated bundle output clearly marked or documented,
- `.gitignore` matches actual policy.

---

# 6. Extension profiles

Create:

```text
docs/EXTENSION_PROFILES.md
```

Document at least these profiles:

## 6.1 Development/full-permission profile

Can allow broader permissions only if explicitly documented.

May include:

```text
<all_urls>
webRequest
declarativeNetRequestFeedback
debug/logging behavior
test-only rulesets
```

Must not claim strict-store readiness.

## 6.2 Strict-store/release profile

Must pass store compliance.

Must not include forbidden permissions unless the compliance policy explicitly allows them.

Must not claim unsupported MV3 behavior.

Must not rely on dev-only test rulesets.

## 6.3 CI profile

Must say which profile CI checks by default.

## 6.4 Release profile

Must say which profile is used for public release.

Required outcome:

- manifest policy,
- audit tools,
- README,
- BENCHMARK,
- certificate gate,
- CI,
- release script

must all agree about which profile is being evaluated.

---

# 7. CI gate matrix

Create:

```text
docs/CI_GATE_MATRIX.md
```

For every package script and CI gate, document:

- script name,
- command,
- files it checks,
- files it intentionally excludes,
- whether it checks source or generated output,
- whether it checks canonical target,
- whether it blocks CI,
- whether it blocks release,
- known blind spots.

This must expose dangerous blind spots, such as audit tools excluding the service-worker files or validating `platform/chrome` while the actual canonical target is `platform/chromium`.

---

# 8. Release reproducibility

Create:

```text
docs/RELEASE_REPRODUCIBILITY.md
```

It must define:

- clean checkout requirements,
- Node/npm versions,
- install command,
- build command,
- package command,
- artifact output path,
- checksum generation,
- certificate generation,
- store-profile validation,
- release-profile validation,
- required CI jobs,
- how to reproduce release locally,
- how to prove generated artifacts are up to date.

Required commands or equivalents:

```bash
npm ci
npm run build
npm run package:dev
npm run package:release
npm run check:release-reproducibility
npm run check:certificate-release
npm run check:store-profile
```

If some commands do not exist yet, create them or document why a staged replacement exists.

---

# 9. Add no-change audit checks before risky refactors

Before large implementation edits, add checks that reveal current truth.

Required scripts or equivalents:

```json
"check:json-integrity": "node tools/check-json-integrity.mjs",
"check:runtime-map": "node tools/check-runtime-map.mjs",
"check:entrypoints": "node tools/check-entrypoints.mjs",
"check:no-fake-exports": "node tools/check-no-fake-exports.mjs",
"check:generated-artifacts": "node tools/check-generated-artifacts.mjs",
"check:source-ownership": "node tools/check-source-ownership.mjs",
"check:audit-coverage": "node tools/check-audit-coverage.mjs",
"check:docs-consistency": "node tools/check-docs-consistency.mjs",
"check:package-integrity": "node tools/check-package-integrity.mjs",
"check:release-reproducibility": "node tools/check-release-reproducibility.mjs"
```

Exact names may differ, but the responsibilities must exist.

---

# 10. JSON and lockfile integrity

Create:

```text
tools/check-json-integrity.mjs
```

It must parse and validate at least:

```text
package.json
package-lock.json
platform/chrome/manifest.json
platform/chromium/manifest.json
platform/chrome/dnr/**/*.json
platform/chromium/dnr/**/*.json
src/_locales/**/*.json
assets/**/*.json
platform/**/assets/**/*.json
```

It must fail on:

- invalid JSON,
- truncated JSON,
- missing required manifest fields,
- manifest pointing to missing files,
- DNR ruleset JSON not array/object as expected,
- package-lock missing root package,
- package-lock inconsistent with package.json,
- localization JSON missing required message structure.

If duplicate-key detection is feasible, add it.

---

# 11. Package and dependency integrity

Create:

```text
tools/check-package-integrity.mjs
```

It must fail if:

- `package.json` package name still points to upstream identity,
- repository URL points to upstream instead of this repo,
- bugs URL points to upstream instead of this repo,
- homepage points to upstream instead of this repo,
- `package-lock.json` root name/version differs from `package.json`,
- `package-lock.json` is missing dependency entries,
- `node_modules/` is committed,
- dependency directories appear outside ignored paths,
- scripts referenced in docs do not exist,
- CI references package scripts that do not exist.

Required package metadata cleanup:

```json
"name": "ublock-resurrected",
"repository": {
  "type": "git",
  "url": "git+https://github.com/Astrocytech/uBlockResurrected.git"
},
"bugs": {
  "url": "https://github.com/Astrocytech/uBlockResurrected/issues"
},
"homepage": "https://github.com/Astrocytech/uBlockResurrected#readme"
```

Use accurate author/contributor metadata. Do not erase upstream attribution if license history requires it; move it to acknowledgements if appropriate.

---

# 12. Audit coverage check

Create:

```text
tools/check-audit-coverage.mjs
```

This is critical.

It must inspect audit tools and fail if an audit gate excludes the files it claims to protect.

Known risk to check:

- remote-fetch audit excluding `sw.js`,
- remote-fetch audit excluding `sw-*.ts`,
- store compliance checking `platform/chrome` while canonical target is `platform/chromium`,
- lint ignoring TypeScript service-worker files,
- CI running gates on one profile while README claims another,
- manifest audit checking one manifest while users load another,
- source scans skipping generated output when generated output is the browser-loaded artifact.

Required output:

- list every audit tool,
- list files scanned,
- list files excluded,
- list whether canonical runtime is included,
- fail if canonical runtime is excluded without explicit documented reason.

No gate should be allowed to claim runtime safety while excluding the runtime.

---

# 13. Entrypoint verification

Create:

```text
tools/check-entrypoints.mjs
```

It must check the canonical manifest and fail if any referenced runtime file is missing or empty.

Check:

- background service worker,
- content scripts,
- web-accessible resources,
- popup HTML,
- options HTML,
- scripts referenced by those HTML files if practical,
- DNR rule resources,
- icons,
- localized message files,
- assets loaded by service worker through `chrome.runtime.getURL`.

It must also warn or fail when a manifest references development/test-only rulesets in a release profile.

---

# 14. Source ownership check

Create:

```text
tools/check-source-ownership.mjs
```

It must fail if:

- two service workers are marked canonical,
- two platform targets are marked canonical,
- manifest points to a service worker not listed in runtime map,
- generated file lacks generated header,
- generated file is edited directly without source update,
- source imports from quarantined paths,
- active runtime imports fake standalone exports,
- active runtime imports stub compiler functions,
- canonical runtime imports a module marked legacy,
- docs disagree with source ownership metadata.

Use comments/headers where needed:

```js
// GENERATED FILE. Do not edit directly.
// Source: ...
// Build command: ...
```

or

```js
// CANONICAL SOURCE FILE.
// Runtime owner: ...
```

or

```js
// LEGACY / QUARANTINED.
// Do not import from active runtime.
```

---

# 15. No fake exports check

Create:

```text
tools/check-no-fake-exports.mjs
```

It must fail on patterns like:

```ts
createToggleHandlers({} as ToggleHandlersDeps)
```

and equivalent fake dependency-injection exports.

It must also fail on active production exports that are empty stubs under real names, for example:

```ts
export const compileFirewallRulesToDnr = (...) => [];
```

A test fixture may contain those patterns only if the checker explicitly treats it as a fixture.

---

# 16. Docs consistency check

Create:

```text
tools/check-docs-consistency.mjs
```

It must fail if:

- README claims Gold while certificate or benchmark says Bronze,
- README claims all gates pass while benchmark lists failures,
- BENCHMARK badge differs from generated certificate,
- CONTRIBUTING lists gates CI does not run,
- CI runs gates not listed in CONTRIBUTING,
- MISSING.md claims implementation completeness inconsistent with runtime checks,
- README claims strict-store compliance while dev/full-permission manifest is used,
- README links upstream repo/bugs/homepage for this project,
- package scripts documented in README/CONTRIBUTING do not exist.

---

# 17. Generated artifact check

Create:

```text
tools/check-generated-artifacts.mjs
```

It must enforce the policy in `docs/GENERATED_ARTIFACTS.md`.

It must fail if:

- generated artifact is stale,
- generated artifact lacks source/build command documentation,
- generated artifact is committed despite policy saying it is not,
- generated artifact is missing despite policy saying it is committed,
- service-worker output does not match source build,
- DNR rulesets are stale relative to their source inputs,
- bundle files are stale relative to their source inputs.

If full stale detection is too expensive, use hashes, timestamps, or a generated manifest.

---

# 18. Choose one canonical browser target

Resolve ambiguity between:

```text
platform/chrome
platform/chromium
```

Recommended default unless evidence proves otherwise:

```text
Canonical active target: platform/chromium
Legacy/quarantined target: platform/chrome
```

Required outcome:

- `AGENTS.md` names canonical target,
- runtime map names canonical target,
- CI checks canonical target,
- release scripts build canonical target,
- manifest audit checks canonical target,
- store compliance checks canonical target or clearly named release target,
- non-canonical target is removed, generated, or marked legacy.

Do not leave two browser targets that appear equally active but behave differently.

---

# 19. Choose one canonical service-worker source

Resolve ambiguity between:

```text
platform/chromium/js/sw.js
src/js/mv3/sw-entry.ts
platform/chrome/js/sw.js
```

Preferred final strategy:

```text
Canonical source: src/js/mv3/sw-entry.ts
Generated output: platform/chromium/js/sw.js
Manifest loads: platform/chromium/js/sw.js
```

Safer intermediate strategy if bundling is too risky in one pass:

```text
Canonical source for now: platform/chromium/js/sw.js
Migration candidate: src/js/mv3/sw-entry.ts
Manifest loads: platform/chromium/js/sw.js
```

Either is acceptable. Ambiguity is not.

Required outcome:

- manifest-loaded service worker is non-empty,
- source/generated status is clear,
- future agents know what to edit,
- non-canonical service-worker paths are marked legacy/quarantined/generated,
- CI tests the manifest-loaded service worker,
- audit tools include the manifest-loaded service worker.

---

# 20. Fix build honesty

Update:

```text
build.mjs
package.json
.github/workflows/ci.yml
```

Required:

```json
"build": "node build.mjs"
```

or equivalent.

`build.mjs` must:

- fail non-zero if any bundle fails,
- not print success after failure,
- include canonical service-worker build if generated,
- output files matching manifest paths,
- verify output files exist,
- verify output files are non-empty,
- optionally produce a build manifest with hashes.

Remove anti-pattern:

```js
try {
  await esbuild.build(...)
} catch (e) {
  console.error(...)
}
console.log("Build complete!")
```

Replace with fail-fast or collect failures and exit non-zero.

---

# 21. TypeScript validation

Required scripts:

```json
"typecheck": "tsc --noEmit",
"typecheck:runtime": "tsc --noEmit -p tsconfig.runtime.json"
```

If full typecheck fails too much, CI must still run `typecheck:runtime`.

Runtime typecheck must include:

```text
src/js/mv3/**/*.ts
src/js/contentscript/**/*.ts
src/js/messaging.ts
src/types/**/*.ts
```

It must catch:

- duplicate declarations,
- missing imports,
- missing exports,
- invalid module syntax,
- unresolved modules,
- obvious type mismatches,
- fake dependencies where possible.

Do not leave TypeScript installed but unused by CI.

---

# 22. ESLint TypeScript coverage

Update ESLint so it covers TypeScript.

Required:

- install/configure TypeScript ESLint support if needed,
- lint `.ts` files,
- lint canonical service-worker source,
- keep style rules practical,
- add targeted runtime-safety rules/checks.

Must detect or be complemented by custom checks for:

- fake dependency exports,
- empty catches,
- direct DOM globals in service-worker modules,
- duplicate active implementations,
- production stubs,
- imports from quarantined paths.

Do not keep lint limited to JavaScript/JSON if runtime source is TypeScript.

---

# 23. Remove duplicate declarations

Inspect:

```text
src/js/mv3/sw-entry.ts
src/js/mv3/sw-messaging.ts
src/js/mv3/sw-types.ts
src/js/mv3/sw-helpers.ts
```

Known pattern to remove:

```ts
import { epickerArgs, getLegacyMessaging } from "./sw-messaging.js";

const epickerArgs = ...
const getLegacyMessaging = ...
```

Required:

- each shared symbol has one owner,
- local-only versions are renamed clearly,
- imported symbols are not redeclared,
- shared types live in one owner module,
- typecheck catches future reintroduction.

---

# 24. Remove fake dependency-injected exports

Inspect:

```text
src/js/mv3/sw-toggle-handlers.ts
```

Remove patterns like:

```ts
export const toggleHostnameSwitch = createToggleHandlers(
  {} as ToggleHandlersDeps,
).toggleHostnameSwitch;
```

Required:

- export the factory only,
- or export a real wired instance from the canonical composition root,
- or delete unused standalone exports,
- active imports must use the safe path,
- tests must fail if fake exports reappear.

---

# 25. Remove production-looking stubs

Inspect:

```text
src/js/mv3/sw-policies.ts
src/js/mv3/sw-firewall.ts
src/js/mv3/sw-whitelist*
src/js/mv3/sw-rules*
```

Remove or quarantine stubs like:

```ts
export const compileFirewallRulesToDnr = (...) => [];
export const compileWhitelistRulesToDnr = (...) => [];
export const compilePowerSwitchDnrRules = (...) => [];
export const compileHostnameSwitchDnrRules = (...) => [];
```

If real implementations exist elsewhere:

- import from real owner,
- re-export from one barrel if needed,
- update callers.

If unsupported:

- rename clearly as unsupported,
- make callers handle unsupported status explicitly,
- document in migration plan.

---

# 26. DNR rule ownership

Create:

```text
docs/DNR_RULE_OWNERSHIP.md
```

Document:

- static rulesets,
- user filter rules,
- dynamic filter-list rules,
- fallback rules,
- firewall rules,
- hostname switch rules,
- power switch rules,
- whitelist rules,
- temporary/session rules,
- source-map/attribution rules,
- test-only rulesets.

For each lane:

- owner module,
- rule ID range,
- dynamic vs session rules,
- storage key,
- compile function,
- sync function,
- tests,
- whether release profile includes it.

Required code outcome:

- one constants module owns rule ID ranges,
- no overlaps,
- tests enforce non-overlap,
- filter-list sync cannot wipe firewall/switch/whitelist rules,
- fallback rules cannot collide with real rules,
- test-only rulesets cannot ship in release profile unless explicitly allowed.

---

# 27. Filter-list/catalog policy

Audit filter-list loading.

Required:

- dev vs strict-store behavior documented,
- bundled lists source documented,
- remote/CDN fallback policy documented,
- no unexpected remote rule/config fetch in strict-store profile,
- audit tool covers active runtime files,
- `assets.dev.json` vs `assets.json` ownership clarified,
- user filters path/key compatibility documented,
- fallback rules documented and tested.

If runtime fetches extension-packaged assets with `chrome.runtime.getURL`, the audit should distinguish that from remote network fetch.

If runtime can fetch CDN or external lists, strict-store profile must fail unless policy allows it.

---

# 28. Storage schema and migration

Create:

```text
src/js/mv3/sw-storage-schema.ts
docs/STORAGE_SCHEMA.md
```

Include storage keys such as:

```text
userSettings
dynamicFilteringString
permanentSwitches
whitelist
netWhitelist
selectedFilterLists
availableFilterLists
filterLists
userFilters
user-filters
perSiteFiltering
cosmeticFiltersData
globalAllowedRequestCount
globalBlockedRequestCount
ubrURLFilteringRules
popupPanelSections
popupPanelOrientation
popupPanelDisabledSections
popupPanelLockedSections
firewallPaneMinimized
localData
dynamicRules
```

Required:

- canonical key for each concept,
- compatibility aliases,
- read migration,
- write migration if needed,
- tests for preserving old user data,
- no blind deletion of old keys,
- reset/backup/restore behavior documented.

Do not remove compatibility keys without tests.

---

# 29. Service-worker-safe module boundaries

Service-worker modules must not use DOM-only APIs unguarded.

Audit for:

```text
document
window
URL.createObjectURL
HTMLAnchorElement
localStorage
sessionStorage
matchMedia
navigator.clipboard
```

Known area:

```text
src/js/mv3/sw-storage.ts
```

Backup/download code that creates a `Blob`, object URL, or `<a>` element belongs in UI/dashboard code, not service worker.

Required:

- service worker prepares data,
- UI performs download,
- static check prevents DOM-only globals in service-worker modules,
- tests cover backup/restore separation.

---

# 30. Extension lifecycle audit

Audit and document service-worker lifecycle behavior.

Create or include in runtime map:

```text
docs/SERVICE_WORKER_LIFECYCLE.md
```

Cover:

- top-level initialization,
- `chrome.runtime.onInstalled`,
- `chrome.runtime.onStartup`,
- message listener registration,
- port listener registration,
- DNR setup,
- storage initialization,
- popup state initialization,
- tab/request tracking initialization,
- logger lifecycle,
- timer usage,
- behavior after service-worker restart.

Required tests:

- cold start,
- restart/reload,
- message before initialization completes,
- DNR sync idempotency,
- storage initialization idempotency,
- duplicate listener prevention.

Do not allow initialization to depend on hidden global ordering.

---

# 31. Messaging protocol ownership

Audit:

```text
src/js/mv3/sw-message-router.ts
src/js/mv3/sw-message-handlers.ts
src/js/mv3/sw-messaging-handlers.ts
src/js/mv3/sw-entry.ts
platform/chromium/js/sw.js
src/js/messaging.ts
src/js/contentscript.ts
```

Create:

```text
docs/MESSAGING_PROTOCOLS.md
```

Document:

- legacy message format,
- new message format,
- popup messages,
- content-script messages,
- dashboard messages,
- logger messages,
- picker/zapper messages,
- expected response shape,
- error response shape,
- owner module for each handler.

Required:

- no duplicate handler ownership,
- router tests for each supported protocol,
- unknown messages fail safely,
- active runtime uses documented router path,
- content scripts and popup agree with service worker.

---

# 32. Popup/UI contract tests

The popup must not silently depend on unstable service-worker shapes.

Add tests for:

- `getPopupData` response shape,
- required popup fields,
- firewall rule fields,
- hostname switch fields,
- blocked/allowed count fields,
- app name/version,
- unsupported URL behavior,
- page hostname/domain behavior.

If exact values are environment-dependent, assert shape and invariants.

---

# 33. Content-script contract tests

Add tests for:

- `retrieveContentScriptParameters`,
- cosmetic filtering fields,
- scriptlet fields,
- userCSS flow if used,
- frame/all_frames behavior if feasible,
- unsupported URL behavior,
- no crash when service worker returns partial data.

---

# 34. Runtime smoke tests

Use Playwright if feasible.

Create:

```text
tests/extension/extension-load.spec.ts
```

The test should:

1. Build canonical target.
2. Launch Chromium with extension loaded.
3. Verify extension ID exists.
4. Verify service worker starts.
5. Fail on service-worker console errors.
6. Open popup or call runtime messaging if feasible.
7. Verify `getPopupData`.
8. Verify content-script parameter request.
9. Verify no missing file errors in extension console.

If Playwright extension loading is not feasible in this pass, create a mocked Chrome runtime smoke test that imports/parses the manifest-loaded service-worker artifact.

Do not claim runtime safety with only isolated unit tests.

---

# 35. Manifest/profile policy

Resolve contradictions between:

```text
tools/audit-mv3-manifest.mjs
tools/check-store-compliance.mjs
platform/chrome/manifest.json
platform/chromium/manifest.json
README.md
BENCHMARK.md
```

Known risks:

- manifest may contain `<all_urls>`,
- manifest may contain `webRequest`,
- audit may forbid those,
- store compliance may read `platform/chrome` while canonical target is `platform/chromium`,
- dev profile and release profile may be conflated.

Required:

- explicit profile argument for manifest/store checks,
- canonical target/profile passed from package scripts,
- dev profile can be permissive if documented,
- release profile strictness enforced if release docs claim compliance,
- no profile can silently check the wrong manifest.

Recommended commands:

```json
"check:mv3-manifest:dev": "node tools/audit-mv3-manifest.mjs --profile=dev --manifest=platform/chromium/manifest.json",
"check:mv3-manifest:release": "node tools/audit-mv3-manifest.mjs --profile=strict-store --manifest=platform/chromium/manifest.json",
"check:store-profile": "node tools/check-store-compliance.mjs --profile=strict-store --manifest=platform/chromium/manifest.json"
```

Exact CLI may differ.

---

# 36. Remote fetch audit fix

Audit:

```text
tools/check-no-remote-rule-fetch.mjs
```

Required:

- active runtime service worker must be scanned,
- active `sw-*.ts` modules must be scanned unless explicitly documented,
- generated runtime output must be scanned if browser loads generated output,
- local extension asset fetches must be distinguished from remote network fetches,
- strict-store profile must fail on remote rule/config fetching,
- dev profile must document allowed fetches if any.

Do not let the remote-fetch gate pass by excluding the files where remote fetch would actually occur.

---

# 37. Store compliance target fix

Audit:

```text
tools/check-store-compliance.mjs
```

Required:

- it must not hardcode a non-canonical manifest unless documented,
- profile/manifest path must be explicit,
- canonical target must be checked by CI,
- release target must be checked by release workflow,
- source file walker must include canonical runtime source,
- generated artifact checks must include manifest-loaded files,
- privacy policy check must be accurate,
- icons/assets check must cover manifest-loaded target.

---

# 38. CI alignment

Update:

```text
.github/workflows/ci.yml
package.json
```

Required CI sequence:

```bash
npm ci
npm run check:package-integrity
npm run check:json-integrity
npm run check:audit-coverage
npm run build
npm run check:entrypoints
npm run check:generated-artifacts
npm run check:source-ownership
npm run typecheck
npm run lint
npm run test
npm run test:mv3-engine
npm run test:extension-smoke
npm run check:runtime-map
npm run check:mv3-manifest:dev
npm run check:no-fake-exports
npm run check:docs-consistency
npm run check:certificate-dev
```

Release workflow additionally:

```bash
npm run check:mv3-manifest:release
npm run check:store-profile
npm run check:certificate-release
npm run check:release-reproducibility
npm run package:release
```

If not all checks can pass immediately:

- keep staged commands,
- document failing commands,
- run strongest reliable subset,
- do not claim complete stabilization.

CI summary must not say “All checks green” unless build, typecheck, lint, tests, runtime smoke, entrypoint checks, docs consistency, and profile checks all passed.

---

# 39. Certificate and benchmark consistency

Update:

```text
README.md
BENCHMARK.md
CONTRIBUTING.md
CHANGELOG.md
MISSING.md
tools/check-certificate-aggregation.mjs
```

Required:

- README badge equals generated certificate badge,
- BENCHMARK equals generated certificate,
- CONTRIBUTING gate list equals CI gate list,
- MISSING.md cannot claim complete implementation if runtime checks fail,
- certificate aggregation comments match actual gates,
- dev and release thresholds are separate.

Recommended scripts:

```json
"check:certificate-dev": "CERTIFICATE_MIN_BADGE=Bronze node tools/check-certificate-aggregation.mjs",
"check:certificate-release": "CERTIFICATE_MIN_BADGE=Gold node tools/check-certificate-aggregation.mjs"
```

Do not allow Bronze to satisfy a release claim of Gold.

---

# 40. Upstream attribution and identity

Fix project identity without erasing upstream attribution.

Required:

- package metadata points to Astrocytech/uBlockResurrected,
- README identifies this project accurately,
- upstream uBlock/uBO attribution preserved where license/history requires,
- author/contributor fields accurate,
- bugs/homepage point to this repo,
- Makefile release/upload references do not point to upstream owner/store IDs unless legacy/quarantined,
- old upstream docs are either updated or marked legacy.

Create or update:

```text
docs/UPSTREAM_ATTRIBUTION.md
```

if needed.

---

# 41. Makefile and release scripts

Audit:

```text
Makefile
tools/*
package.json
.github/workflows/*
```

Required:

- Makefile targets do not publish/upload using upstream IDs,
- release scripts use canonical target,
- legacy release targets marked legacy,
- package scripts and Makefile do not contradict each other,
- release artifacts are generated from clean checkout,
- release packaging excludes dev/test-only files if appropriate.

---

# 42. Security and privacy review

Create:

```text
docs/SECURITY_PRIVACY_REVIEW.md
```

Audit:

- permissions,
- host permissions,
- remote fetches,
- logging data,
- stored user data,
- backup/restore data,
- content script injection,
- web accessible resources,
- CSP if present,
- external connections,
- privacy policy presence,
- dev vs release behavior.

Required:

- no misleading privacy/store claims,
- logger data lifecycle documented,
- backup/export behavior documented,
- permissions justified by profile,
- release profile does not contain dev-only logging/test behavior unless justified.

---

# 43. Web accessible resources audit

Audit manifest `web_accessible_resources`.

Required:

- every resource exists,
- resource exposure is justified,
- dev-only resources not exposed in release profile,
- script resources not exposed unnecessarily,
- matches are as narrow as practical per profile,
- tests/checks fail on missing resources.

---

# 44. Localization and asset integrity

Audit:

```text
src/_locales/**
platform/**/_locales/**
assets/**
platform/**/assets/**
```

Required:

- manifest message placeholders resolve,
- default locale exists,
- required messages exist,
- asset files referenced by runtime exist,
- `assets.dev.json` vs `assets.json` policy documented,
- release profile does not accidentally use dev asset catalog unless intentional.

---

# 45. Error handling policy

Create:

```text
docs/ERROR_HANDLING_POLICY.md
```

Audit all active runtime broad catches.

Required:

- no empty catches in active runtime unless explicitly documented as expected non-fatal,
- all non-fatal catches have reason comments or telemetry/logging where appropriate,
- tests cover expected failure paths,
- service-worker startup failures are not swallowed,
- DNR sync failures are visible,
- storage migration failures are visible.

---

# 46. Global mutable state reduction

Audit:

```text
src/js/mv3/sw-entry.ts
platform/chromium/js/sw.js
src/js/mv3/sw-storage.ts
src/js/mv3/sw-request-tracking.ts
```

Required:

- identify global mutable state,
- document owner,
- initialize idempotently,
- avoid duplicate state copies for same concept,
- tests for restart/reinitialization,
- no hidden order dependencies.

If reduction is too large, document in migration plan with exact state owners.

---

# 47. Versioning and migration version

Create or document:

```text
src/js/mv3/sw-version.ts
```

or equivalent.

Required:

- extension version source of truth,
- storage schema version if migrations exist,
- migration runner idempotent,
- migration tests,
- release notes update policy.

Do not have manifest/package/runtime version drift silently.

---

# 48. Test organization

Create or update:

```text
docs/TEST_STRATEGY.md
```

Document:

- unit tests,
- engine/corpus tests,
- runtime smoke tests,
- extension-load tests,
- profile/gate tests,
- generated artifact tests,
- migration tests,
- docs consistency tests,
- release tests.

Required:

- tests must make clear whether they check source or browser-loaded output,
- CI must run at least one test that touches the browser-loaded artifact,
- test fixtures must be separated from production scans.

---

# 49. Branch protection recommendation

Create:

```text
docs/BRANCH_PROTECTION.md
```

Recommend required checks for `main`:

- package integrity,
- JSON integrity,
- build,
- entrypoints,
- generated artifacts,
- source ownership,
- typecheck,
- lint,
- tests,
- runtime smoke,
- docs consistency,
- certificate dev,
- release gates for release branches.

This is documentation only unless repository settings are accessible.

---

# 50. Practical phase order

Use this order.

## Phase 1 — Static truth and guardrails

- Create `AGENTS.md`.
- Create stabilization docs.
- Add no-change checks:
  - package integrity,
  - JSON integrity,
  - entrypoints,
  - audit coverage,
  - source ownership,
  - no fake exports,
  - docs consistency.
- Do not refactor behavior yet.

## Phase 2 — Install/package health

- Fix package metadata.
- Regenerate lockfile.
- Remove committed dependency folders.
- Ensure clean `npm ci`.
- Align `.gitignore`.

## Phase 3 — Build honesty

- Add top-level build script.
- Make build fail on any bundle failure.
- Make build outputs match manifest.
- Add generated-artifact verification.

## Phase 4 — Canonical runtime

- Choose canonical browser target.
- Choose canonical service-worker source.
- Mark source/generated/legacy files.
- Update AGENTS/runtime map.
- Ensure audit tools scan canonical runtime.

## Phase 5 — Runtime cleanup

- Remove duplicate declarations.
- Remove fake exports.
- Remove or reroute stubs.
- Fix service-worker-safe boundaries.
- Clarify messaging ownership.

## Phase 6 — DNR/storage/lifecycle

- Define DNR ownership.
- Centralize rule ID ranges.
- Centralize storage schema.
- Add migration tests.
- Add lifecycle tests.

## Phase 7 — Type/lint/test

- Add typecheck.
- Add TS lint.
- Add runtime smoke test.
- Add popup/content-script contract tests.

## Phase 8 — Profile/CI/docs/certificate

- Separate dev/release profiles.
- Align CI with canonical target.
- Align docs, benchmark, certificate.
- Add release reproducibility.

## Phase 9 — Final validation

- Run all required commands.
- Update stabilization log.
- State remaining debt honestly.

---

# 51. Required final acceptance commands

At the end, run and report:

```bash
npm ci
npm run check:package-integrity
npm run check:json-integrity
npm run check:audit-coverage
npm run build
npm run check:entrypoints
npm run check:generated-artifacts
npm run check:source-ownership
npm run check:no-fake-exports
npm run typecheck
npm run lint
npm run test
npm run test:mv3-engine
npm run test:extension-smoke
npm run check:runtime-map
npm run check:mv3-manifest:dev
npm run check:docs-consistency
npm run check:certificate-dev
```

For release readiness, additionally:

```bash
npm run check:mv3-manifest:release
npm run check:store-profile
npm run check:certificate-release
npm run check:release-reproducibility
npm run package:release
```

If a command does not exist, create it or explain why the staged equivalent exists.

If a command fails:

1. Do not claim completion.
2. Record exact failure in `docs/STABILIZATION_LOG.md`.
3. Add or update `docs/STABILIZATION_MIGRATION_PLAN.md`.
4. Add strongest narrower check that can pass now.
5. Clearly state remaining unsafe areas.

---

# 52. Expected final response from coding agent

When finished, respond with:

1. Previous stability rating.
2. New stability rating.
3. Canonical browser target.
4. Canonical manifest.
5. Canonical service-worker source.
6. Manifest-loaded service-worker artifact.
7. Generated artifact policy.
8. Legacy/quarantined paths.
9. Package/dependency changes.
10. Build changes.
11. Typecheck/lint changes.
12. CI changes.
13. Audit coverage changes.
14. Removed duplicate declarations.
15. Removed fake exports.
16. Removed/rerouted stubs.
17. DNR ownership changes.
18. Storage schema/migration changes.
19. Lifecycle/messaging changes.
20. Runtime smoke test coverage.
21. Docs/certificate consistency changes.
22. Release reproducibility status.
23. Exact command results.
24. Remaining debt.
25. Exact next safe task.

Do not say “complete” unless all required acceptance commands pass.

---

# 53. Definition of done

This task is done only when:

- future LLM agents can identify the canonical runtime path in under one minute,
- AGENTS.md clearly says what to edit and what not to edit,
- exactly one canonical browser target exists,
- exactly one canonical service-worker source exists,
- manifest-loaded service worker is source/generated clearly,
- audit tools scan the canonical runtime,
- build failure cannot look like success,
- package metadata points to this project,
- package-lock is valid,
- `npm ci` works from clean checkout,
- committed dependency folders are gone,
- generated artifacts are documented and checked,
- no active fake dependency exports remain,
- no active production stubs remain under real names,
- no imported symbols are redeclared locally,
- TypeScript validates canonical runtime,
- lint covers TypeScript runtime files,
- CI tests browser-loaded artifact,
- DNR rule ownership is documented and tested,
- storage schema is documented and migration-safe,
- service-worker lifecycle is documented and tested,
- dev/release profiles are separated,
- docs and certificate status agree,
- release reproducibility is documented,
- remaining debt is exact and file-specific.

If only part is achieved, say “partially stabilized” and point to the migration plan.

---

# 54. Non-goals

Do not do these in this task:

- do not add new blocker features,
- do not add new filter-list subscriptions,
- do not add AI features,
- do not redesign popup/dashboard UI,
- do not claim superiority over uBO/uBOL without pinned comparator evidence,
- do not claim strict-store readiness without strict-store checks,
- do not remove user-data compatibility keys without tests,
- do not loosen gates to pass,
- do not create a new architecture beside the old one,
- do not publish or upload anything.

---

# 55. Final instruction

Your primary job is not to make the extension “better.”

Your primary job is to make the repository honest.

After this task, when a future LLM coding agent changes one feature, it should be difficult for that agent to accidentally break another feature silently.
