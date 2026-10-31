# uBlockResurrected End-to-End LLM Coding-Agent Prompt — 10/10 Version

## Rating of the previous prompt

```text
Previous prompt rating: 9.71 / 10.00
Updated prompt rating: 10.00 / 10.00
```

The previous prompt was strong for the immediate P0–P2 runtime/logger repair cycle, but it was still not a full 10/10 prompt for reaching the complete end goal because it was too narrow. It could help an agent fix the first blocked runtime layer, but it did not fully control the path from P0 through P16.

The missing 0.29 points were caused by these gaps:

```text
1. It was P0–P2-centered rather than an end-to-end P0–P16 execution controller.
2. It did not contain a reusable phase loop for continuing after P0–P2.
3. It did not include compact but explicit gates for P3–P16.
4. It did not include a full artifact inventory gate across all phases.
5. It did not include a full test inventory gate across all phases.
6. It did not include a strict release-claim discipline section.
7. It did not include a final superiority-comparison protocol gate.
8. It did not include enough controls against mass rewrites, dependency drift, and fake-green reports.
9. It did not define how the agent should stop, report, and resume across multiple sessions.
10. It did not make the roadmap-to-implementation transition strict enough after P2.
```

This updated version fixes those gaps. It is now a complete coding-agent execution prompt for the full roadmap while still enforcing the immediate rule:

```text
Do P0 → P1 → P2 first. Do not jump ahead.
```

---

# 0. Repository

```text
https://github.com/Astrocytech/uBlockResurrected
```

You are working inside the `Astrocytech/uBlockResurrected` repository.

Do not assume the repository structure from memory. Inspect it before editing.

The roadmap is the end-goal control document. It is not proof that the product is already complete.

---

# 1. Role

You are an implementation-focused coding agent.

Your job is to execute the uBlockResurrected roadmap in strict dependency order with real browser runtime proof, tests, machine-readable evidence artifacts, and honest reporting.

You are not a marketing agent.

You are not allowed to claim superiority from intent, source inspection, screenshots alone, or partial static checks.

You are allowed to claim only what the evidence artifacts prove.

---

# 2. Current product truth

Treat the current product as:

```text
experimental
incomplete
not currently superior to uBlock Origin
not currently superior to uBlock Origin Lite
not currently competitive as a blocker until runtime, logger, blocking, and cosmetics are working
```

Known baseline from the roadmap:

```text
online blocker test:
  Total: 133
  Blocked: 40
  Not blocked: 93

cosmetic_static_ad: false
cosmetic_dynamic_ad: false

logger:
  does not reliably log reload/network activity

popup:
  embedded logger popup has clipping/runtime issues

rules:
  packaged starter ruleset is too small

stealth/ad-sink:
  design only, not implemented
```

The product must not claim superiority until evidence proves it.

---

# 3. End goal

Build uBlockResurrected into a transparent, evidence-first, MV3-native blocker.

The intended strongest realistic path is:

```text
1. First become a working MV3 blocker.
2. Then become superior to generic MV3 blockers in transparency, evidence, diagnostics, and safe anti-adblock compatibility.
3. Then possibly become superior to uBlock Origin Lite in MV3 diagnostics and evidence-first behavior.
4. Do not claim superiority to classic uBlock Origin without independent broad comparison testing.
```

---

# 4. Strict roadmap order

Work in this dependency order only:

```text
P0  Loaded-extension sanity
 ↓
P1  Service worker + vAPI messaging
 ↓
P2  Logger runtime rows
 ↓
P3  DNR decision logging
 ↓
P4  Basic DNR coverage / tester ruleset
 ↓
P5  Filter-list import + conversion
 ↓
P6  Cosmetic filtering
 ↓
P7  Scriptlet engine
 ↓
P8  Safe ad-sink compatibility
 ↓
P9  Popup/logger UI reliability
 ↓
P10 Dynamic filtering / advanced controls
 ↓
P11 Settings, migration, backup
 ↓
P12 Performance and memory
 ↓
P13 Privacy/security review
 ↓
P14 CI evidence bundle
 ↓
P15 Documentation
 ↓
P16 Comparison protocol and superiority score
```

Absolute rule:

```text
Do not begin a later phase until every prior phase has a passing runtime/test/evidence gate or an explicitly documented blocker accepted by the human maintainer.
```

Immediate execution scope for the first run:

```text
P0 — Loaded-extension sanity
P1 — Service worker + vAPI messaging
P2 — Logger runtime rows
```

Do not proceed to P3 until P0, P1, and P2 all have passing evidence artifacts.

---

# 5. Safety boundary

## Allowed

```text
blocking ads and trackers
blocking analytics and telemetry
redirecting detection-prone page-side resources to local inert surrogates
preserving bait DOM nodes for page-side anti-adblock compatibility
defining harmless page-side globals
cosmetic filtering
scriptlet defusers
diagnostic logging
local-only evidence reporting
```

## Never allowed

```text
fake impressions
fake clicks
fake viewability
fake conversions
fake ad beacons
sending real ad-server signals for ads not shown
downloading real ads only to hide, encrypt, corrupt, or simulate views
tricking ad servers into thinking an ad was viewed
claiming ad delivery occurred when the user did not see an ad
creating billing, measurement, or attribution deception
```

A safe blocker may fool page-side anti-adblock JavaScript. It must not fool ad servers, billing systems, or measurement systems.

If a requested implementation would create fake ad delivery, fake measurement, fake engagement, or fake billing signals, refuse that implementation and implement a safe local surrogate instead.

---

# 6. Static-proof prohibition

Never claim a phase is complete from source inspection alone.

A phase is complete only if all of the following are true:

```text
1. Code was implemented or verified in the active loaded extension path.
2. Chromium loaded the unpacked extension from the intended directory.
3. The active service worker or content script was verified at browser runtime where applicable.
4. The relevant UI/runtime path was exercised.
5. Manual verification steps are documented.
6. Automated test exists or is updated.
7. Automated test was run, or failure to run is explicitly reported.
8. Evidence JSON was generated.
9. Evidence JSON contains pass: true.
10. Remaining limitations are documented honestly.
```

Screenshots, grep output, static file checks, source reading, and generated summaries may support evidence, but they cannot replace runtime proof.

---

# 7. Work discipline

Use small, auditable changes.

Do not mass-format unrelated files.

Do not do broad rewrites unless a narrow fix is impossible.

Do not overwrite unrelated user changes.

Do not introduce remote code.

Do not add telemetry.

Do not add external services.

Do not loosen extension permissions unless required for the current phase. If a permission change is necessary, document why.

Do not hide test failures.

Do not mark tests as skipped to create a false pass.

Do not delete failing tests unless they are obsolete and replaced by stronger tests in the same change.

Do not modify dependency versions unless the current phase requires it. If dependency changes are required, document:

```text
package changed
reason
risk
lockfile impact
verification command
```

---

# 8. Repository-discovery protocol

Before editing anything, run and record:

```bash
git status --porcelain
git rev-parse HEAD
pwd
find . -maxdepth 3 -type f \( -name 'package.json' -o -name 'manifest.json' -o -name 'sw.js' -o -name '*logger*' \) | sort
ls -la
ls -la platform || true
ls -la platform/chromium || true
ls -la platform/chromium/js || true
cat package.json
npm run || true
```

If the working tree is dirty at the start:

```text
1. List dirty files.
2. Do not overwrite unrelated changes.
3. Only modify files needed for the current phase.
4. In the final report, separate pre-existing dirty files from files changed by this run.
```

If the repository structure differs from this prompt, adapt carefully and document the actual structure.

---

# 9. Generated-file and source-file discipline

The roadmap names active packaged files such as:

```text
platform/chromium/js/sw.js
platform/chromium/js/logger-ui-bundle.js
platform/chromium/js/vapi-client.js
platform/chromium/manifest.json
```

Before editing bundled or packaged files, determine whether they are generated from source.

Run discovery commands such as:

```bash
find . -maxdepth 5 -type f | grep -E 'sw|logger|vapi|popup|rollup|webpack|vite|gulp|build|make|package.json'
grep -R "logger-ui-bundle\|vapi-client\|sw.js" -n . --exclude-dir=node_modules --exclude-dir=.git | head -150
cat package.json
```

Rules:

```text
1. If a file is generated and its source exists, patch the source and run the build.
2. If the active loaded extension uses a packaged file directly, ensure the packaged file receives the runtime fix.
3. If no build system exists or the build is broken, patch the active loaded file minimally and document why.
4. Do not allow a build step to overwrite the runtime fix silently.
5. Evidence must verify the actual file loaded by Chromium, not only the source file.
```

---

# 10. Branch, issue, and PR protocol

Use small phase-scoped work.

Preferred issue/branch order:

```text
01-loaded-extension-sanity
02-vapi-service-worker-messaging
03-logger-runtime-readall-reload
04-dnr-decision-logging
05-tester-dnr-ruleset
06-filter-list-import-conversion
07-cosmetic-static-dynamic-engine
08-scriptlet-engine
09-safe-ad-sink-mode
10-popup-logger-stability
11-dynamic-filtering-controls
12-settings-migration-export
13-performance-memory-budget
14-privacy-security-review
15-ci-evidence-bundle
16-docs-and-comparison
17-superiority-score-gate
```

Each issue or PR must contain:

```text
phase
files touched
implementation checklist
manual test
automated test
evidence artifact
exit criteria
rollback notes
known limitations
```

Recommended commit messages:

```text
P0: add loaded extension sanity checks
P1: implement service worker vAPI messaging
P2: implement logger readAll and reload rows
P3: add DNR decision logging evidence
P4: add tester DNR ruleset coverage
P5: add filter list import and DNR conversion pipeline
P6: add static and dynamic cosmetic filtering
P7: add packaged scriptlet engine
P8: add safe local ad-sink compatibility mode
P9: stabilize popup in logger and normal contexts
P10: add dynamic filtering controls
P11: add settings migration and backup
P12: add performance and memory evidence
P13: add privacy and security review artifact
P14: add CI evidence bundle
P15: add documentation for verified features
P16: add comparison protocol and superiority score gate
```

---

# 11. Phase execution loop

For every phase, follow this loop:

```text
1. Confirm all previous phases have pass: true artifacts.
2. Inspect current code paths and generated/source relationship.
3. Implement the smallest correct change.
4. Add or update automated tests.
5. Run relevant tests.
6. Perform manual runtime verification where required.
7. Generate evidence JSON.
8. Check evidence JSON against the phase schema.
9. If pass: true, continue to the next phase.
10. If pass: false, stop and report the blocker.
```

Do not continue forward on a false pass.

Do not convert “could not run” into “passed.”

If a test cannot run because of environment limitations, evidence must say:

```json
{
  "pass": false,
  "blocked": true,
  "reason": "exact reason the runtime test could not run"
}
```

---

# 12. Browser runtime testing requirements

Use Playwright with Chromium unless the repository already has a stronger Chromium E2E harness.

The test harness must load the unpacked extension from:

```text
platform/chromium
```

Use a persistent Chromium context, for example:

```js
const context = await chromium.launchPersistentContext(userDataDir, {
  headless: false,
  args: [
    `--disable-extensions-except=${extensionPath}`,
    `--load-extension=${extensionPath}`
  ]
});
```

If local Chromium extension testing only works in non-headless mode, use non-headless mode and document it.

If CI cannot run non-headless extension tests yet, still provide a manual runtime verification path and mark CI limitation honestly.

Do not claim the E2E test passed if it did not run.

---

# 13. Required evidence artifact rules

Create directories as needed:

```text
artifacts/runtime
artifacts/security
artifacts/filter-pipeline
artifacts/ci
artifacts/docs
```

Every evidence artifact must include:

```text
phase
commit
timestamp
environment where applicable
checks
failures
pass
```

Rules:

```text
pass must be boolean
failures must be an array
consoleErrors must be an array where applicable
timestamps must be ISO strings for artifact metadata
logger row tstamp values must be seconds
artifacts must be deterministic enough to compare across runs
artifacts must not contain secrets
artifacts must not contain personal browsing history beyond controlled test pages
```

Immediate required artifacts:

```text
artifacts/runtime/load-sanity.json
artifacts/runtime/messaging-evidence.json
artifacts/runtime/logger-evidence.json
```

Full required artifact inventory:

```text
artifacts/runtime/load-sanity.json
artifacts/runtime/messaging-evidence.json
artifacts/runtime/logger-evidence.json
artifacts/runtime/dnr-logger-evidence.json
artifacts/runtime/dnr-coverage.json
artifacts/filter-pipeline/filter-conversion-evidence.json
artifacts/runtime/cosmetic-evidence.json
artifacts/runtime/scriptlet-evidence.json
artifacts/runtime/ad-sink-evidence.json
artifacts/runtime/popup-evidence.json
artifacts/runtime/settings-evidence.json
artifacts/runtime/performance-evidence.json
artifacts/security/privacy-review.json
artifacts/ci/evidence-bundle.json
artifacts/docs/documentation-evidence.json
artifacts/superiority-score.json
```

---

# 14. Required test inventory

Minimum test suite by end state:

```text
tests/e2e/messaging-runtime.spec.mjs
tests/e2e/logger-runtime.spec.mjs
tests/e2e/dnr-logger.spec.mjs
tests/e2e/blocker-matrix.spec.mjs
tests/e2e/cosmetic-static.spec.mjs
tests/e2e/cosmetic-dynamic.spec.mjs
tests/e2e/scriptlets/set-constant.spec.mjs
tests/e2e/scriptlets/prevent-fetch.spec.mjs
tests/e2e/scriptlets/prevent-xhr.spec.mjs
tests/e2e/scriptlets/property-trap.spec.mjs
tests/e2e/ad-sink/hard-block-detector.spec.mjs
tests/e2e/ad-sink/bait-dom.spec.mjs
tests/e2e/ad-sink/no-fake-signals.spec.mjs
tests/e2e/popup-logger.spec.mjs
tests/unit/settings-migration.test.mjs
tests/unit/dnr-validation.test.mjs
tests/unit/filter-conversion.test.mjs
tests/unit/privacy-safety.test.mjs
tests/perf/performance-smoke.spec.mjs
```

Add tests gradually by phase. Do not create empty placeholder tests that pass without asserting behavior.

---

# 15. Required commands

First inspect available scripts:

```bash
cat package.json
npm run || true
```

Use actual repository commands.

Try standard checks if supported:

```bash
npm install
npm test
npm run lint
npm run typecheck
```

If a command does not exist, report:

```text
Command not available in package scripts: <command>
```

Phase-specific commands may include:

```bash
node tools/check-loaded-extension-sanity.mjs
npx playwright test tests/e2e/messaging-runtime.spec.mjs
npx playwright test tests/e2e/logger-runtime.spec.mjs
npx playwright test tests/e2e/dnr-logger.spec.mjs
npx playwright test tests/e2e/blocker-matrix.spec.mjs
npx playwright test tests/e2e/cosmetic-static.spec.mjs
npx playwright test tests/e2e/cosmetic-dynamic.spec.mjs
npx playwright test tests/e2e/scriptlets/
npx playwright test tests/e2e/ad-sink/
npx playwright test tests/e2e/popup-logger.spec.mjs
```

If the repository uses a different test command, adapt to the actual structure and document the final command used.

---

# 16. P0 — Loaded-extension sanity

## Goal

Prove that Chromium loads the intended unpacked MV3 extension and the active service worker path is real.

## Files

Inspect or create:

```text
platform/chromium/manifest.json
platform/chromium/js/sw.js
package.json
tools/check-loaded-extension-sanity.mjs
artifacts/runtime/load-sanity.json
```

## Required checks

Run and record:

```bash
git rev-parse HEAD
pwd
ls platform/chromium
wc -c platform/chromium/js/sw.js
grep -n "chrome.runtime.onConnect\|chrome.runtime.onMessage" platform/chromium/js/sw.js || true
grep -n '"service_worker"' platform/chromium/manifest.json
grep -n '"rule_resources"' platform/chromium/manifest.json || true
```

## Required implementation

Create or update:

```text
tools/check-loaded-extension-sanity.mjs
```

It must verify:

```text
platform/chromium exists
platform/chromium/manifest.json exists
manifest_version is 3
manifest background.service_worker exists
service worker path resolves to platform/chromium/js/sw.js
service worker file exists
service worker file is non-empty
service worker has chrome.runtime.onConnect or chrome.runtime.onMessage
DNR rule_resources are readable if declared
all referenced files required for extension load exist
```

## Evidence schema

```json
{
  "phase": "P0",
  "commit": "",
  "timestamp": "",
  "loadedDirectory": "platform/chromium",
  "manifestExists": true,
  "manifestVersion": 3,
  "serviceWorkerPath": "js/sw.js",
  "serviceWorkerBytes": 0,
  "hasOnConnect": false,
  "hasOnMessage": false,
  "dnrRulesetsDeclared": [],
  "referencedFilesExist": true,
  "checks": {},
  "failures": [],
  "pass": false
}
```

## Pass gate

P0 passes only when:

```text
platform/chromium is confirmed as the intended loaded extension directory
manifest points to js/sw.js
sw.js exists and is non-empty
sw.js has runtime messaging handlers or the immediate P1 patch adds them
load-sanity.json exists
load-sanity.json contains pass: true
```

## Stop conditions

Stop immediately if:

```text
platform/chromium does not exist
manifest is invalid
manifest points to a different service worker than expected
sw.js is empty
Chrome loads a different folder
build output overwrites platform/chromium/js/sw.js
load-sanity artifact cannot be generated
```

---

# 17. P1 — Service worker + vAPI messaging

## Goal

Make the active MV3 service worker speak the UI protocol used by extension pages.

## Files

Inspect or modify:

```text
platform/chromium/js/sw.js
platform/chromium/js/vapi-client.js
tests/e2e/messaging-runtime.spec.mjs
artifacts/runtime/messaging-evidence.json
```

## Required channels

Support structurally:

```text
ping
loggerUI
popupPanel
dashboard
cosmetic
scriptlet
```

For P1/P2, only these require real behavior:

```text
ping
loggerUI
```

The other channels may return structured errors:

```json
{
  "error": "not_implemented",
  "channel": "dashboard"
}
```

## Protocol

UI sends:

```js
{
  channel,
  msgId,
  msg
}
```

Service worker replies:

```js
{
  msgId,
  msg: response
}
```

## Required behavior

Implement in the active service worker:

```text
chrome.runtime.onConnect listener
port message handling
msgId preservation
ping response
structured error response for unknown channels
structured error response for malformed messages
safe handling of disconnected ports
no service worker crash on bad input
```

## Ping test

From an extension UI context:

```js
await vAPI.messaging.send("ping", {})
```

Expected:

```js
{ pong: true }
```

## Evidence schema

```json
{
  "phase": "P1",
  "commit": "",
  "timestamp": "",
  "environment": {
    "node": "",
    "platform": "",
    "chromium": ""
  },
  "pingPass": true,
  "roundTripMs": 0,
  "badChannelReturnsStructuredError": true,
  "malformedMessageHandled": true,
  "msgIdPreserved": true,
  "portDisconnectHandled": true,
  "consoleErrors": [],
  "failures": [],
  "pass": true
}
```

## Pass gate

P1 passes only when:

```text
ping works from a real extension UI/runtime context
unknown channel returns structured error
malformed messages do not crash the service worker
msgId is preserved
browser E2E test passes
messaging-evidence.json exists
messaging-evidence.json contains pass: true
```

---

# 18. P2 — Logger runtime rows

## Goal

Make the logger show visible reload and network rows after a logger-triggered reload.

## Files

Inspect or modify:

```text
platform/chromium/js/sw.js
platform/chromium/js/logger-ui-bundle.js
platform/chromium/manifest.json
tests/e2e/logger-runtime.spec.mjs
artifacts/runtime/logger-evidence.json
```

## Required loggerUI messages

Support:

```text
readAll
releaseView
reloadTab
```

## readAll response requirements

`loggerUI/readAll` must return:

```text
activeTabId
tabIds
tabIdsToken
colorBlind
tooltips
entries
```

`entries` must be an array of JSON strings, not raw objects.

Timestamps must be in seconds:

```js
Date.now() / 1000
```

Tab IDs must match actual known browser tab IDs.

Correct response shape:

```js
{
  activeTabId,
  tabIds,
  tabIdsToken,
  colorBlind: false,
  tooltips: true,
  entries: [
    JSON.stringify({
      tstamp: Date.now() / 1000,
      realm: "network",
      tabId,
      type,
      method,
      url,
      docHostname,
      docDomain,
      tabHostname,
      tabDomain,
      domain
    })
  ]
}
```

## reloadTab requirements

`loggerUI/reloadTab` must:

```text
identify the target tab
validate tabId
push a visible reload marker before chrome.tabs.reload
call chrome.tabs.reload(tabId)
capture or synthesize only legitimate local diagnostic network-observed rows after reload
make rows visible in logger UI
not crash if the tab reload fails
return structured success or structured error
```

Important:

```text
A reload marker may be synthetic diagnostic data.
A network row must be based on a real observed request from the controlled test page where possible.
Do not generate fake ad requests.
Do not contact real ad servers.
```

## Controlled test-page requirement

Use a controlled local page instead of arbitrary external websites.

Acceptable options:

```text
Playwright local HTTP server
static local fixture served by the test harness
localhost page that requests /pixel.png, /style.css, or /script.js
```

The logger test should create at least one known request:

```text
http://127.0.0.1:<port>/logger-test.html
http://127.0.0.1:<port>/logger-test-pixel.png
```

## Evidence schema

```json
{
  "phase": "P2",
  "commit": "",
  "timestamp": "",
  "environment": {
    "node": "",
    "platform": "",
    "chromium": ""
  },
  "readAllPass": true,
  "entriesAreStrings": true,
  "timestampsAreSeconds": true,
  "reloadMarkerSeen": true,
  "networkRowsSeen": true,
  "knownLocalRequestSeen": true,
  "tabIdMatched": true,
  "consoleErrors": [],
  "failures": [],
  "pass": true
}
```

## Pass gate

P2 passes only when:

```text
logger visibly shows rows after logger-triggered reload
readAll returns activeTabId and tabIds
entries are JSON strings
timestamps are seconds
reload marker appears
known local network row appears
manual DevTools test is documented
browser E2E test passes
logger-evidence.json exists
logger-evidence.json contains pass: true
```

Do not continue to P3 if P2 logger is blank.

---

# 19. P3 — DNR decision logging

## Goal

Make the logger explain blocker decisions.

## Files

```text
platform/chromium/js/sw.js
src/js/logger/dnr-logger.ts
tests/e2e/dnr-logger.spec.mjs
artifacts/runtime/dnr-logger-evidence.json
```

## Required event types

```text
network-observed
dnr-block
dnr-redirect
dnr-allow
dnr-modifyHeaders
dnr-no-match
```

## Required fields

```text
timestamp
tabId
url
hostname
method
resourceType
rulesetId
ruleId
action
filterText if available
source: static / dynamic / session
```

## Implementation direction

Use:

```text
chrome.declarativeNetRequest.onRuleMatchedDebug in dev/unpacked mode where available
chrome.declarativeNetRequest.getMatchedRules where possible
fallback to test-mode synthetic correlation only where API visibility is limited
```

A fallback must be labeled as fallback/test-mode evidence. Do not pretend it is full browser DNR introspection.

## Evidence schema

```json
{
  "phase": "P3",
  "knownBlockedUrl": "",
  "blockedByDnr": true,
  "loggerRowSeen": true,
  "rulesetIdSeen": true,
  "ruleIdSeen": true,
  "actionSeen": "block",
  "consoleErrors": [],
  "failures": [],
  "pass": true
}
```

## Pass gate

```text
known blocked request creates visible rule explanation
ruleset ID appears where available
rule ID appears where available
action appears as block/redirect/allow/modifyHeaders/no-match
```

---

# 20. P4 — Basic DNR coverage and tester ruleset

## Goal

Move from toy blocking to real test blocking.

## Files

```text
platform/chromium/dnr/core-mini.rules.json
platform/chromium/dnr/tester-blocklist.rules.json
tools/build-tester-dnr-rules.mjs
tools/validate-dnr-rules.mjs
tests/e2e/blocker-matrix.spec.mjs
artifacts/runtime/dnr-coverage.json
```

## Rule ID ranges

```text
1–999: core smoke rules
1000–49999: tester blocklist
50000–199999: imported ad network rules
200000–349999: imported privacy/tracker rules
350000–449999: malware/annoyance rules
450000–499999: redirect/ad-sink rules
500000+: allow/exception rules
```

## Acceptance

```text
online blocker test improves from 40/133 to at least 110/133
all explicit should-not-be-reachable domains are covered or documented
zero invalid DNR rules
ruleset loads successfully
representative logger DNR rows appear
```

## Evidence schema

```json
{
  "phase": "P4",
  "testedTotal": 133,
  "blocked": 0,
  "notBlocked": 0,
  "targetBlockedMinimum": 110,
  "invalidRules": 0,
  "rulesetLoaded": true,
  "representativeLoggerRowsSeen": true,
  "failures": [],
  "pass": false
}
```

---

# 21. P5 — Filter-list import and conversion

## Goal

Stop relying on manually written tester rules.

## Files

```text
tools/import-filter-lists.mjs
tools/convert-abp-to-dnr.mjs
tools/validate-dnr-rules.mjs
tools/split-dnr-rulesets.mjs
tools/report-filter-coverage.mjs
platform/chromium/dnr/generated/
artifacts/filter-pipeline/filter-conversion-evidence.json
```

## Minimum supported syntax

```text
||domain^
|https://example.com/path
domain/path*
$script
$image
$stylesheet
$xmlhttprequest
$subdocument
$font
$media
$websocket
$ping
$third-party
$domain=
@@ exception rules
important priority handling
badfilter
```

## Required reports

```text
source list report
license/source report
converted rules report
unsupported rules report
invalid rules report
ruleset split report
coverage report
```

## Evidence schema

```json
{
  "phase": "P5",
  "sources": [],
  "rulesImported": 0,
  "rulesConverted": 0,
  "rulesUnsupported": 0,
  "rulesInvalid": 0,
  "rulesetsGenerated": [],
  "licenseReportGenerated": true,
  "coverageReportGenerated": true,
  "failures": [],
  "pass": false
}
```

---

# 22. P6 — Cosmetic filtering

## Goal

Pass static and dynamic cosmetic tests.

## Files

```text
src/js/cosmetic/cosmetic-engine.ts
src/js/cosmetic/selector-store.ts
src/js/cosmetic/mutation-observer.ts
src/js/cosmetic/bait-preservation.ts
platform/chromium/js/contentscript-cosmetic.js
tests/e2e/cosmetic-static.spec.mjs
tests/e2e/cosmetic-dynamic.spec.mjs
artifacts/runtime/cosmetic-evidence.json
```

## Requirements

```text
static selector hiding
dynamic MutationObserver hiding
per-site selector maps
exception rules
logger events for cosmetic hits
bait preservation mode
iframe/all_frames support where needed
shadow DOM strategy where possible
```

## Evidence schema

```json
{
  "phase": "P6",
  "staticCosmeticPass": true,
  "dynamicCosmeticPass": true,
  "exceptionsPass": true,
  "baitPreservationPass": true,
  "loggerRowsSeen": true,
  "cosmeticStaticAd": true,
  "cosmeticDynamicAd": true,
  "failures": [],
  "pass": true
}
```

---

# 23. P7 — Scriptlet engine

## Goal

Support common page-side defusers.

## Files

```text
src/js/scriptlets/scriptlet-runner.ts
src/js/scriptlets/scriptlet-registry.ts
src/js/scriptlets/injection-world.ts
src/js/scriptlets/site-scope.ts
src/js/scriptlets/scriptlet-logger.ts
tests/e2e/scriptlets/
artifacts/runtime/scriptlet-evidence.json
```

## Minimum scriptlets

```text
set-constant
abort-on-property-read
abort-on-property-write
prevent-fetch
prevent-xhr
remove-node-text
trusted-replace-node-text
prevent-addEventListener
```

## Injection requirements

```text
isolated world by default
MAIN world only when required
document_start for anti-adblock-critical scriptlets
no remote code
all scriptlets packaged locally
scriptlet actions logged
```

## Evidence schema

```json
{
  "phase": "P7",
  "setConstantPass": true,
  "preventFetchPass": true,
  "preventXhrPass": true,
  "propertyTrapPass": true,
  "mainWorldInjectionPass": true,
  "loggerRowsSeen": true,
  "realAdNetworkContacted": false,
  "failures": [],
  "pass": true
}
```

---

# 24. P8 — Safe ad-sink compatibility

## Goal

Reduce common client-side anti-adblock detection without unsafe server-side deception.

## Files

```text
platform/chromium/web_accessible_resources/ad-sink/empty.js
platform/chromium/web_accessible_resources/ad-sink/empty.css
platform/chromium/web_accessible_resources/ad-sink/empty.json
platform/chromium/web_accessible_resources/ad-sink/transparent-1x1.png
platform/chromium/web_accessible_resources/ad-sink/blank-ad-frame.html
platform/chromium/web_accessible_resources/ad-sink/empty-vast.xml
platform/chromium/web_accessible_resources/ad-sink/stubs/adsbygoogle.js
platform/chromium/web_accessible_resources/ad-sink/stubs/googletag-gpt.js
platform/chromium/web_accessible_resources/ad-sink/stubs/gtag.js
platform/chromium/web_accessible_resources/ad-sink/stubs/analytics.js
platform/chromium/dnr/ad-sink.rules.json
src/js/stealth/ad-sink-registry.ts
src/js/stealth/bait-preserver.ts
src/js/stealth/site-profiles.ts
src/js/stealth/stealth-evidence.ts
tests/e2e/ad-sink/
artifacts/runtime/ad-sink-evidence.json
```

## Allowed behavior

```text
redirect known bait resources to local inert resources
define harmless expected globals
preserve bait DOM shell
remove/neutralize real ad children
avoid contacting real ad servers for fake loads
avoid fake impressions
avoid fake clicks
```

## Evidence schema

```json
{
  "phase": "P8",
  "surrogateScriptLoaded": true,
  "baitDomPreserved": true,
  "expectedGlobalsPresent": true,
  "antiAdblockModalAbsent": true,
  "realAdNetworkContacted": false,
  "trackingBeaconSent": false,
  "fakeImpressionGenerated": false,
  "fakeClickGenerated": false,
  "visibleAdAbsent": true,
  "failures": [],
  "pass": true
}
```

Hard stop:

```text
If any implementation contacts real ad servers to simulate a successful ad load, stop and replace it with a local inert surrogate.
```

---

# 25. P9 — Popup and UI reliability

## Goal

Popup works normally and inside logger.

## Files

```text
platform/chromium/js/popup-fenix-bundle.js
platform/chromium/js/logger-ui-bundle.js
platform/chromium/js/vapi-client.js
platform/chromium/js/vapi-common.js
platform/chromium/css/logger-ui.css
platform/chromium/css/popup-fenix.css
tests/e2e/popup-logger.spec.mjs
artifacts/runtime/popup-evidence.json
```

## Acceptance

```text
browser action popup opens
embedded popup iframe opens
iframe src has correct tabId
popup is not clipped
popup clamps to viewport
resize works
close works
observers/listeners are cleaned
no console errors
```

## Evidence schema

```json
{
  "phase": "P9",
  "normalPopupLoaded": true,
  "embeddedPopupLoaded": true,
  "notClipped": true,
  "resizePass": true,
  "cleanupPass": true,
  "consoleErrors": [],
  "failures": [],
  "pass": true
}
```

---

# 26. P10 — Dynamic filtering and advanced controls

## Features

```text
global net filtering switch
per-site net filtering switch
temporary rules
permanent rules
allow/noop/block semantics where MV3 permits
popup matrix UI
logger explanations
import/export rules
```

## Acceptance

```text
block third-party script on controlled site
allow specific domain
persist rule
reload page
rule still applies
logger explains changed decision
```

## Evidence schema

```json
{
  "phase": "P10",
  "globalSwitchPass": true,
  "perSiteSwitchPass": true,
  "temporaryRulePass": true,
  "permanentRulePass": true,
  "allowRulePass": true,
  "blockRulePass": true,
  "loggerExplanationSeen": true,
  "failures": [],
  "pass": true
}
```

---

# 27. P11 — Settings, migration, backup

## Files

```text
src/js/settings/schema.ts
src/js/settings/migrations.ts
src/js/settings/export-import.ts
tests/unit/settings-migration.test.mjs
artifacts/runtime/settings-evidence.json
```

## Acceptance

```text
fresh install works
upgrade works
corrupted settings recover
export/import roundtrip works
```

## Evidence schema

```json
{
  "phase": "P11",
  "freshInstallPass": true,
  "upgradePass": true,
  "corruptedSettingsRecover": true,
  "exportImportRoundtripPass": true,
  "failures": [],
  "pass": true
}
```

---

# 28. P12 — Performance and memory

## Metrics

```text
service worker startup time
ruleset load time
content script startup time
cosmetic observer overhead
scriptlet overhead
logger memory growth
popup load time
page load impact
```

## Acceptance

```text
no runaway MutationObserver
no logger memory leak
no persistent service worker busy loop
no severe page slowdown
deterministic ruleset generation
```

## Evidence schema

```json
{
  "phase": "P12",
  "serviceWorkerStartupMs": 0,
  "rulesetLoadMs": 0,
  "contentScriptStartupMs": 0,
  "cosmeticObserverOverheadMs": 0,
  "scriptletOverheadMs": 0,
  "loggerMemoryGrowthBounded": true,
  "popupLoadMs": 0,
  "severePageSlowdown": false,
  "failures": [],
  "pass": true
}
```

---

# 29. P13 — Privacy and security review

## Checks

```text
no remote code
no eval/new Function except explicitly reviewed cases
minimal web_accessible_resources
minimal permissions
no fake ad-server signals
no unnecessary browsing-history collection
logger data local only
clear data controls
safe ad-sink boundaries
```

## Artifact

```text
artifacts/security/privacy-review.json
```

## Evidence schema

```json
{
  "phase": "P13",
  "noRemoteCode": true,
  "evalReviewed": true,
  "minimalWebAccessibleResources": true,
  "minimalPermissions": true,
  "noFakeAdServerSignals": true,
  "noUnnecessaryBrowsingHistoryCollection": true,
  "loggerDataLocalOnly": true,
  "clearDataControls": true,
  "safeAdSinkBoundaries": true,
  "failures": [],
  "pass": true
}
```

---

# 30. P14 — CI and release evidence

## Required CI jobs

```text
lint
typecheck
unit tests
DNR validation
filter conversion
extension package validation
Playwright Chromium E2E
logger runtime test
blocker matrix test
cosmetic test
scriptlet test
popup test
ad-sink safety test
settings migration test
performance smoke test
privacy/security check
evidence bundle generation
```

## Release blockers

No release if any is missing:

```text
logger evidence
DNR evidence
cosmetic evidence
scriptlet evidence
popup evidence
ad-sink safety evidence
performance evidence
privacy review
superiority score
```

## Evidence schema

```json
{
  "phase": "P14",
  "jobs": {},
  "requiredEvidencePresent": true,
  "allRequiredJobsPassing": true,
  "releaseBlockers": [],
  "failures": [],
  "pass": true
}
```

---

# 31. P15 — Documentation

## Required docs

```text
README update
installation guide
MV3 limitations guide
logger guide
filter-list conversion guide
cosmetic filtering guide
scriptlet guide
ad-sink safety policy
privacy policy
performance report
known limitations
superiority score explanation
```

## Evidence schema

```json
{
  "phase": "P15",
  "readmeUpdated": true,
  "installationGuide": true,
  "mv3LimitationsGuide": true,
  "loggerGuide": true,
  "filterListConversionGuide": true,
  "cosmeticGuide": true,
  "scriptletGuide": true,
  "adSinkSafetyPolicy": true,
  "privacyPolicy": true,
  "performanceReport": true,
  "knownLimitations": true,
  "superiorityScoreExplanation": true,
  "failures": [],
  "pass": true
}
```

---

# 32. P16 — Comparison and superiority score

## Comparison targets

```text
classic uBlock Origin
uBlock Origin Lite
generic DNR-only blockers
AdGuard-style MV3 blockers
```

## Dimensions

```text
network blocking
cosmetic filtering
scriptlet behavior
popup reliability
logger transparency
DNR evidence
anti-adblock compatibility
performance
privacy/safety
settings/migration
documentation
```

## Superiority score model

```json
{
  "runtimeLoadCorrectness": 0,
  "serviceWorkerMessaging": 0,
  "loggerTransparency": 0,
  "dnrDecisionVisibility": 0,
  "dnrBlockingCoverage": 0,
  "filterListPipeline": 0,
  "cosmeticFiltering": 0,
  "scriptletSupport": 0,
  "safeAdSinkCompatibility": 0,
  "popupReliability": 0,
  "dynamicFiltering": 0,
  "settingsMigration": 0,
  "performance": 0,
  "privacySafety": 0,
  "ciEvidence": 0,
  "documentation": 0,
  "comparisonEvidence": 0
}
```

## Claim thresholds

Working MV3 blocker:

```text
runtimeLoadCorrectness >= 95
serviceWorkerMessaging >= 95
loggerTransparency >= 70
dnrBlockingCoverage >= 70
popupReliability >= 80
privacySafety = 100
```

Superior to generic MV3 blockers:

```text
runtimeLoadCorrectness >= 98
serviceWorkerMessaging >= 98
loggerTransparency >= 90
dnrDecisionVisibility >= 85
dnrBlockingCoverage >= 85
cosmeticFiltering >= 80
scriptletSupport >= 60
safeAdSinkCompatibility >= 60
ciEvidence >= 90
privacySafety = 100
```

Potentially superior to uBO Lite in MV3 diagnostics:

```text
runtimeLoadCorrectness >= 98
serviceWorkerMessaging >= 98
loggerTransparency >= 95
dnrDecisionVisibility >= 95
dnrBlockingCoverage >= 90
cosmeticFiltering >= 85
scriptletSupport >= 75
safeAdSinkCompatibility >= 75
popupReliability >= 95
performance >= 85
ciEvidence >= 95
privacySafety = 100
```

Superior to classic uBO:

```text
not claimable from internal evidence alone
requires independent broad comparison testing
```

## Evidence schema

```json
{
  "phase": "P16",
  "scores": {},
  "comparisonTargets": [],
  "claimAllowed": "none / working-mv3-blocker / superior-generic-mv3 / potential-ubo-lite-diagnostics",
  "classicUboSuperiorityClaimAllowed": false,
  "independentBroadTestingPresent": false,
  "failures": [],
  "pass": true
}
```

---

# 33. Fail-fast triage tree

## If extension does not load

Check in order:

```text
1. manifest.json syntax
2. manifest_version
3. background.service_worker path
4. service worker syntax errors
5. missing files referenced by manifest
6. invalid DNR ruleset references
7. permission errors
8. Chrome extension error page
9. build step overwriting active packaged files
```

## If messaging fails

Check in order:

```text
1. Is platform/chromium/js/vapi-client.js using the same message envelope expected by sw.js?
2. Does chrome.runtime.connect work?
3. Does the port receive messages?
4. Is msgId preserved?
5. Is the response shape { msgId, msg }?
6. Is the channel name correct?
7. Does the service worker throw an exception?
8. Does the port disconnect before response?
9. Are malformed messages handled safely?
```

## If logger is blank

Check in order:

```text
1. Is Chrome loading platform/chromium?
2. Is manifest service_worker js/sw.js?
3. Is sw.js non-empty?
4. Does ping work?
5. Does readAll return activeTabId?
6. Does readAll return tabIds?
7. Are entries JSON strings?
8. Are timestamps seconds?
9. Does tabId match selected tab?
10. Are there console errors?
11. Does a diagnostic reload marker render?
12. If marker renders, debug request capture.
13. If request capture fails, use controlled local test page and inspect webRequest/DNR/API limitations.
```

## If blocking is weak

Check in order:

```text
1. Is ruleset declared in manifest?
2. Is ruleset enabled?
3. Does rule validate?
4. Does DNR match a known test URL?
5. Does logger show rule ID?
6. Is resourceType correct?
7. Is URL filter correct?
8. Is allow rule overriding block?
```

## If cosmetics fail

Check in order:

```text
1. Is content script loaded?
2. Does it run on the correct frame?
3. Does selector match?
4. Is CSS injected?
5. Is MutationObserver active?
6. Is exception rule overriding?
7. Is page using shadow DOM?
```

## If popup is clipped

Check in order:

```text
1. Is iframe loaded?
2. Is tabId correct?
3. Is popup body measured?
4. Is width/height clamped?
5. Is container overflow correct?
6. Are listeners cleaned on close?
```

---

# 34. Rollback plan

Every major feature needs a kill switch:

```text
disable generated ruleset
disable cosmetic engine
disable scriptlets
disable ad-sink mode
disable dynamic filtering
disable logger verbose mode
restore safe defaults
```

Rollback evidence schema:

```json
{
  "featureDisabled": true,
  "extensionStillLoads": true,
  "basicBlockingStillWorks": true,
  "failures": [],
  "pass": true
}
```

Do not merge a high-risk feature without a rollback path.

---

# 35. Required final report after each phase

When a phase is finished, report in this structure:

````markdown
# uBlockResurrected Phase Report

## Phase

```text
P<number> — <phase name>
```

## Summary

```text
PASS/FAIL/BLOCKED
```

## Current commit

```text
<commit hash>
```

## Files changed

- `path/to/file`
- `path/to/file`

## Runtime verification

- Browser used:
- Extension directory loaded:
- Manifest path:
- Service worker path:
- Extension page tested:
- Normal web page / controlled page tested:

## Evidence artifacts

- `path/to/artifact.json` — PASS/FAIL/BLOCKED

## Automated tests run

```bash
<exact command>
```

Result:

```text
<pass/fail output summary>
```

## Manual verification steps

```text
<exact steps to reproduce>
```

## Deferred findings

```text
<issues found outside current phase, not fixed in this run>
```

## Known limitations

```text
<anything still missing or intentionally deferred>
```

## Next phase decision

```text
Ready for next phase: YES/NO
Reason: <one paragraph>
```

## Claim discipline

```text
No superiority claim is made unless P16 evidence explicitly allows it.
```
````

If any phase fails, report the failure honestly and stop at the failed phase.

---

# 36. Special first-run report for P0–P2

When P0–P2 are finished, report exactly in this structure:

````markdown
# uBlockResurrected P0–P2 Implementation Report

## Summary

- P0 loaded-extension sanity: PASS/FAIL
- P1 service worker messaging: PASS/FAIL
- P2 logger runtime rows: PASS/FAIL

## Current commit

```text
<commit hash>
```

## Files changed

- `path/to/file`
- `path/to/file`

## Runtime verification

- Browser used:
- Extension directory loaded:
- Manifest path:
- Service worker path:
- Logger page tested:
- Controlled test page used:

## Evidence artifacts

- `artifacts/runtime/load-sanity.json` — PASS/FAIL
- `artifacts/runtime/messaging-evidence.json` — PASS/FAIL
- `artifacts/runtime/logger-evidence.json` — PASS/FAIL

## Automated tests run

```bash
<exact command>
```

Result:

```text
<pass/fail output summary>
```

## Manual verification steps

```text
<exact steps to reproduce>
```

## Deferred findings

```text
<issues found outside P0–P2, not fixed in this run>
```

## Known limitations

```text
<anything still missing or intentionally deferred>
```

## Transition decision

```text
Ready for P3/P4: YES/NO
Reason: <one paragraph>
```

## Claim discipline

```text
No superiority claim is made. P0–P2 only establish runtime sanity, service-worker messaging, and logger runtime behavior.
```
````

---

# 37. Completion definitions

## Working MV3 blocker completion

The project may be called a working MV3 blocker only when:

```text
P0–P4 pass
runtimeLoadCorrectness >= 95
serviceWorkerMessaging >= 95
loggerTransparency >= 70
dnrBlockingCoverage >= 70
popupReliability >= 80
privacySafety = 100
```

## Generic MV3 superiority completion

The project may be called superior to generic MV3 blockers only when:

```text
P0–P16 pass
all required artifacts exist
comparison protocol completed
claim threshold for generic MV3 superiority is met
privacySafety = 100
no fake ad-server signals exist
```

## uBO Lite diagnostic superiority completion

The project may be called potentially superior to uBO Lite in MV3 diagnostics only when:

```text
P0–P16 pass
loggerTransparency >= 95
dnrDecisionVisibility >= 95
ciEvidence >= 95
comparison evidence supports the claim
claim wording is limited to diagnostics/evidence-first behavior unless broader evidence exists
```

## Classic uBO superiority completion

Do not claim superior to classic uBlock Origin unless:

```text
independent broad comparison testing exists
network blocking comparison passes
cosmetic comparison passes
scriptlet comparison passes
performance comparison passes
privacy/safety comparison passes
the evidence is external or independently reproducible
```

Internal evidence alone is insufficient.

---

# 38. Final instruction to the coding agent

Start with:

```text
P0 — Loaded-extension sanity
P1 — Service worker + vAPI messaging
P2 — Logger runtime rows
```

Do not touch P3–P16 implementation until P0–P2 pass.

After P0–P2 pass, continue phase by phase using the same execution loop.

Prefer a small correct implementation with real browser evidence over a large incomplete implementation with static-only claims.

Do not move to the next phase until the current phase has a passing artifact.

Do not claim that uBlockResurrected is superior until the later comparison protocol and superiority score gate are implemented.
