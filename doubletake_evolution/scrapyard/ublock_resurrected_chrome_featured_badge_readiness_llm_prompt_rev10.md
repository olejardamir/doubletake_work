# uBlockResurrected — Chrome Web Store Featured Badge Readiness LLM Coder Prompt Pack

Version: 1.9  
Purpose: give an LLM coding agent a complete, phase-by-phase implementation prompt for making `Astrocytech/uBlockResurrected` as eligible as possible for the Chrome Web Store **Featured** badge.

Important truth:

```text
No coding agent can guarantee the Featured badge.
Chrome team members manually evaluate extensions.
This prompt can only make the project badge-ready, policy-ready, review-ready, and evidence-ready.
```

This document is a **coding-agent execution prompt**, not marketing copy.

Revision 1.3 coverage additions:

```text
Retained B0-B28, added B26 and B27. B26 covers negative-policy traps that were not explicit enough in rev3: Chrome settings/search/homepage/new-tab overrides, notification abuse, sending messages on behalf of users, redirection/launch-only extensions, minimum functionality, broken/dead-server functionality, unauthorized access/paywall/login/DRM/copyright-media circumvention, prohibited/mature/violent/hate/crypto-mining content, and deceptive security/antivirus-style claims. B27 is now the true final expanded gate for all B0-B28 phases.
```


Revision 1.5 coverage additions:

```text
Retained B0-B28 and added B28. B28 covers a remaining Chrome-extension-specific readiness gap that was not explicit enough in rev5: Declarative Net Request rule limits/quotas, enabled-ruleset count, regex rule constraints, getMatchedRules feedback permissions, DNR redirect-to-web-accessible-resource constraints, minimum_chrome_version/API compatibility matrix, incognito mode behavior, file:// access behavior, match-pattern scope, and user-facing disclosure for optional incognito/file URL access. This matters especially for a Manifest V3 content blocker because broad host permissions, DNR rule capacity, incognito behavior, and file URL access can affect both review readiness and user trust.
```


Revision 1.6 coverage additions:

```text
Retained B0-B28, added a new B29, and renumbered the true final gate to B30. The new B29 covers remaining Manifest V3 engineering-readiness gaps that were not explicit enough in rev6: manifest content_security_policy validation, extension page/sandbox CSP boundaries, service worker lifecycle resilience, top-level event registration, persistent-state handling, timer-to-alarms migration, storage.local/session/sync/managed use and quota/access-level planning, offscreen document justification/cleanup, HTTPS-only network access, content-script world/run_at/frame matching safety, and production removal of localhost/dev CSP allowances. These matter because Chrome’s MV3 platform can reject or destabilize extensions that rely on unsupported CSP values, persistent service-worker state, string execution, hidden keepalive loops, unsafe storage exposure, or unjustified offscreen/content-script behavior.
```


Revision 1.7 coverage additions:

```text
Retained B0-B30 and tightened existing phases. Rev7 was already broad, but it did not explicitly cover recent Chrome Web Store operational hardening: verified CRX uploads / trusted private-key signing, reviewer test-account credentials where any account-gated behavior exists, Chrome 137+ test-runner resilience after removal of --load-extension from branded Chrome builds, and userScripts API toggle / execute-method review if the project ever adopts userScripts. These are now folded into B17, B21, B25, B28, B29, and B30 without adding another phase number.
```


Revision 1.8 coverage additions:

```text
Rev8 had one structural issue and one current-platform governance gap: it skipped B27 and did not explicitly require ongoing tracking of Chrome Extension platform changes after the June 2025 operational updates. Rev9 adds B27 as a dedicated Chrome platform-change governance gate. B27 covers the official Chrome Extensions What's New feed, 2026 Developer Dashboard role changes, Chrome 148 structured-clone messaging opt-in, Chrome 148 browser namespace adoption/avoidance, the new dashboard appeals workflow, private publishing to external organizations if ever relevant, Chrome 140 sidePanel layout/RTL handling if sidePanel is used, Chrome 139 removal of testing flags from branded Chrome builds, new extension host-access UI and chrome.permissions.addHostAccessRequest(), storage DevTools visibility, frozen-tab messaging behavior, DNR response-header matching if used, and API-key/secrets handling. This also fixes the B26-to-B28 numbering gap so the prompt now has continuous B0-B30 coverage.
```


Revision 1.9 coverage additions:

```text
Rev9 was broad, but the one-shot execution section still mislabeled B27 as a final gate instead of the current Chrome platform-change governance gate. Rev10 fixes that wording and adds an explicit Featured nomination eligibility checklist to the final gate: item must be an extension, the publisher must own it, English language support must exist, the item must be published and public before nomination, no active policy violations may exist, and core features must be accessible without extra credentials or payments. Rev10 also adds missing final-tree entries for the B27 Chrome platform-change audit and a dedicated Featured nomination eligibility artifact.
```

---

## Official source basis

The coder must use the current official Chrome documentation as the source of truth and must re-check these before finalizing:

```text
Chrome Web Store discovery / Featured badge / nomination criteria:
https://developer.chrome.com/docs/webstore/discovery

Chrome Web Store Featured Products policy:
https://developer.chrome.com/docs/webstore/program-policies/featured-products

Chrome Web Store Program Policies:
https://developer.chrome.com/docs/webstore/program-policies/policies

Chrome Web Store Quality Guidelines:
https://developer.chrome.com/docs/webstore/program-policies/quality-guidelines

Extensions quality guidelines FAQ / single purpose:
https://developer.chrome.com/docs/webstore/program-policies/quality-guidelines-faq

Chrome Web Store violation troubleshooting:
https://developer.chrome.com/docs/webstore/troubleshooting

Creating a great listing page:
https://developer.chrome.com/docs/webstore/best-listing

Complete listing information:
https://developer.chrome.com/docs/webstore/cws-dashboard-listing

Chrome Web Store review process:
https://developer.chrome.com/docs/webstore/review-process

Manifest V3 overview:
https://developer.chrome.com/docs/extensions/develop/migrate/what-is-mv3

Remote hosted code violations:
https://developer.chrome.com/docs/extensions/develop/migrate/remote-hosted-code

Extension service worker basics:
https://developer.chrome.com/docs/extensions/develop/concepts/service-workers/basics

Declare permissions:
https://developer.chrome.com/docs/extensions/develop/concepts/declare-permissions

Extension messaging:
https://developer.chrome.com/docs/extensions/develop/concepts/messaging

Content scripts:
https://developer.chrome.com/docs/extensions/develop/concepts/content-scripts

Cross-origin network requests:
https://developer.chrome.com/docs/extensions/develop/concepts/network-requests

Chrome Web Store branding guidelines:
https://developer.chrome.com/docs/webstore/branding

Chrome Web Store user data / Limited Use:
https://developer.chrome.com/docs/webstore/program-policies/limited-use

Chrome Web Store Best Practices:
https://developer.chrome.com/docs/webstore/best-practices

Register your developer account:
https://developer.chrome.com/docs/webstore/register

Set up your developer account:
https://developer.chrome.com/docs/webstore/set-up-account

Publish in the Chrome Web Store:
https://developer.chrome.com/docs/webstore/publish

Fill out the privacy fields:
https://developer.chrome.com/docs/webstore/cws-dashboard-privacy

Declare payment and set visibility / distribution:
https://developer.chrome.com/docs/webstore/cws-dashboard-distribution

Provide test instructions:
https://developer.chrome.com/docs/webstore/cws-dashboard-test-instructions

Manage user feedback:
https://developer.chrome.com/docs/webstore/support-users

Analyze store listing metrics:
https://developer.chrome.com/docs/webstore/metrics

Content Ratings Guidelines:
https://developer.chrome.com/docs/webstore/rating

Update, skip-review, cancel-review, and rollback guidance:
https://developer.chrome.com/docs/webstore/update
https://developer.chrome.com/docs/webstore/skip-review
https://developer.chrome.com/docs/webstore/cancel-review
https://developer.chrome.com/docs/webstore/rollback


Trader / non-trader disclosure and verification:
https://developer.chrome.com/docs/webstore/program-policies/trader-disclosure
https://developer.chrome.com/docs/webstore/program-policies/trader-verification-faq

Chrome Web Store Developer Agreement:
https://developer.chrome.com/docs/webstore/program-policies/terms

Share ownership / publisher members:
https://developer.chrome.com/docs/webstore/share-ownership

Deceptive installation tactics FAQ:
https://developer.chrome.com/docs/webstore/program-policies/deceptive-installation-tactics-faq

Listing requirements / keyword spam:
https://developer.chrome.com/docs/webstore/program-policies/listing-requirements

Spam policy FAQ:
https://developer.chrome.com/docs/webstore/program-policies/spam-faq

Use Google Analytics with the Chrome Web Store:
https://developer.chrome.com/docs/webstore/google-analytics

Supplying images / image guidelines:
https://developer.chrome.com/docs/webstore/images

Chrome Web Store API / staged deployment:
https://developer.chrome.com/docs/webstore/api

Verified uploads / trusted CRX upload signing:
https://developer.chrome.com/blog/verified-uploads-cws

Chrome Extensions June 2025 update: verified uploads, test credentials, --load-extension changes, userScripts changes:
https://developer.chrome.com/blog/extension-news-june-2025

Chrome Extensions What's New / current platform-change feed:
https://developer.chrome.com/docs/extensions/whats-new

User Scripts API:
https://developer.chrome.com/docs/extensions/reference/api/userScripts
```

---

# MASTER PROMPT FOR THE LLM CODER

```text
We are working in the GitHub repository Astrocytech/uBlockResurrected.

Goal:
Make the project as ready as possible for the Chrome Web Store Featured badge.

Important:
The Featured badge cannot be guaranteed. Chrome manually evaluates extensions. Your job is to make the project technically compliant, policy-compliant, privacy-safe, user-friendly, evidence-backed, and listing-ready.

Do not claim that the extension has, deserves, or will receive the Featured badge.
Do not write marketing claims that imply endorsement by Google, Chrome, uBlock Origin, or any other project.
Do not use "Featured", "Editor's Choice", "Number One", "best", "fastest", "official", or similar claims in product metadata.

Product positioning:
Treat this extension as a Manifest V3-native content blocker with transparent local diagnostics and evidence-first filtering behavior.

Immediate relationship to the implementation roadmap:
The existing P0-P16 product roadmap still controls product implementation.
This badge-readiness work is a cross-cutting P17 readiness layer.
Do not use P17 to bypass P0-P16.
If runtime, logger, DNR, cosmetics, scriptlets, ad-sink safety, popup stability, performance, privacy, CI, or documentation are incomplete, report that clearly.

Primary deliverable:
Create a complete Chrome Web Store Featured Badge Readiness implementation layer with:
1. source-based policy audit
2. MV3 compliance audit
3. remote-code audit
4. code readability / non-obfuscation audit
5. permission minimization and justification report
6. host permission justification report
7. user-data and privacy audit
8. Limited Use disclosure draft if user data is handled
9. security boundary audit
10. content-script and messaging security audit
11. web_accessible_resources minimization audit
12. ad-blocking safety audit
13. performance budget and evidence
14. UX/onboarding/accessibility review
15. Chrome Web Store listing package
16. screenshots/promotional asset checklist
17. branding/IP risk review
18. reviewer test instructions
19. release package validation
20. final badge-readiness score and blockers list
21. publisher/developer account readiness plan
22. verified publisher / official URL readiness plan
23. content rating, category, payment, and distribution field checklist
24. support URL, feedback, and user-review response plan
25. store metrics and uninstall-feedback monitoring plan
26. staged release / trusted tester / rollback plan
27. update and periodic re-review compliance plan
28. final Chrome Web Store dashboard field map
29. anti-manipulation audit for ratings, reviews, downloads, and ranking signals
30. trader/non-trader disclosure readiness and human verification checklist
31. developer agreement / legal eligibility / applicable-law review checklist
32. publisher ownership, access, and account recovery governance
33. off-store marketing and install-funnel compliance audit
34. localization and Google Analytics governance plan
35. supply-chain, dependency, license, vulnerability, and reproducible-build audit
36. CSP, service-worker lifecycle, storage, offscreen-document, HTTPS, and content-script execution-world audit

Strict rules:
- Use only Manifest V3.
- Do not add remotely hosted executable code.
- Do not add remote JavaScript, CDN scripts, or code fetched and executed at runtime.
- Do not use eval, new Function, string-based timers, or dynamic code execution.
- Do not hide or obfuscate functionality.
- Do not collect browsing history, URLs, page titles, rule-hit logs, or logger data remotely.
- Logger data must stay local by default.
- Do not fake ad impressions, clicks, conversions, viewability, or ad-server beacons.
- Do not contact real ad servers to simulate ad loads.
- Do not bypass paywalls, login restrictions, DRM, or copyrighted-media access controls.
- Do not add affiliate monetization unless explicitly disclosed and user-action-gated; default is no affiliate behavior.
- Do not add VPN, antivirus, crypto, bot, gambling, downloader, or unrelated features.
- Do not create duplicate/clone-like Chrome Web Store metadata.
- Do not keyword-stuff the listing.
- Do not claim superiority unless backed by evidence and phrased narrowly.
- Do not manipulate ratings, reviews, installs, uninstalls, downloads, usage metrics, ranking signals, or support feedback.
- Do not incentivize five-star reviews or suppress negative reviews.
- Do not use deceptive install funnels, typosquatted domains, fake urgency, fake system/browser/security warnings, or install gates that mislead users.
- Do not publish from an account that has unresolved trader verification, legal eligibility, 2-step verification, or developer-agreement blockers.
- Do not ship unreviewed third-party code, unclear-license assets, vulnerable dependencies, or non-reproducible build outputs without documented human approval.
- Do not submit a debug, prototype, placeholder, or non-production build as the final public store build.
- Do not leave dashboard fields blank when Chrome requires them for review, privacy, ratings, payment, visibility, or reviewer testing.

Execution behavior:
Proceed through all phases B0-B30 below.
For each phase:
- inspect existing repo state
- implement missing files/tools/docs/tests
- run relevant checks
- create evidence JSON
- record blockers instead of pretending success
- continue to the next phase when safe
- stop only for legal/policy/safety risk that would make continuing harmful

Definition of done:
The repo contains a complete P17 badge-readiness layer under docs/, tools/, tests/, and artifacts/.
Every required artifact exists.
Every artifact has a pass boolean.
The final badge-readiness report distinguishes:
- pass
- partial
- blocked
- not applicable
- needs human/legal review

Final output:
Return:
1. files changed
2. commands run
3. evidence artifacts generated
4. final readiness score
5. remaining blockers
6. exact Chrome Web Store listing materials prepared
7. human decisions still required
```

---

# B0 — Source-of-truth and policy snapshot

## Goal

Create a local source snapshot so the repo knows which Chrome documentation versions were used.

## Required files

```text
docs/chrome-web-store/official-source-index.md
artifacts/cws/source-snapshot.json
tools/cws/build-source-snapshot.mjs
```

## Implementation instructions

Create `docs/chrome-web-store/official-source-index.md` with:

```text
- official source title
- URL
- why it matters
- last checked date
- key requirements extracted
- local phase(s) affected
```

Create `tools/cws/build-source-snapshot.mjs` that writes `artifacts/cws/source-snapshot.json`.

The tool does not need to scrape the web automatically if that is not appropriate in CI. It may maintain a curated source registry and emit a machine-readable snapshot.

## Evidence schema

```json
{
  "sourcesListed": true,
  "officialChromeSourcesOnlyForPolicyClaims": true,
  "lastCheckedDatePresent": true,
  "affectedPhasesMapped": true,
  "pass": true
}
```

## Acceptance

```text
Policy claims in repo docs point to official Chrome sources.
No badge-readiness claim is based only on memory or unsupported assumptions.
```

---

# B1 — Single-purpose product definition

## Goal

Make the extension's purpose narrow, easy to understand, and not bundled with unrelated features.

## Required files

```text
docs/chrome-web-store/product-purpose.md
artifacts/cws/single-purpose-audit.json
tools/cws/audit-single-purpose.mjs
```

## Product purpose to enforce

Use this as the safe baseline:

```text
A Manifest V3-native content blocker with transparent local diagnostics and evidence-first filtering behavior.
```

## Implementation instructions

Audit all product text and repo docs for purpose drift.

Flag and remove or rewrite claims/features suggesting:

```text
VPN
antivirus
crypto
botting
video downloading
paywall bypassing
media piracy
search hijacking
coupon injection
affiliate injection
AI assistant
unrelated productivity tool
system cleaner
browser optimizer
```

## Evidence schema

```json
{
  "purposeStatementExists": true,
  "singlePurposeClear": true,
  "unrelatedFeatureClaims": [],
  "prohibitedOrFeatureRestrictedCategoriesFound": [],
  "pass": true
}
```

## Acceptance

```text
A reviewer can understand the product in one sentence.
No unrelated feature bundle exists.
No Chrome Web Store feature-restricted category is introduced.
```

---

# B2 — Branding, naming, and impersonation risk

## Goal

Avoid misleading naming, icons, screenshots, and descriptions.

## Required files

```text
docs/chrome-web-store/branding-ip-risk-audit.md
docs/chrome-web-store/name-options.md
artifacts/cws/branding-risk.json
tools/cws/audit-branding-risk.mjs
```

## Implementation instructions

Audit:

```text
manifest name
manifest short_name
Chrome Web Store title draft
summary
description
icons
screenshots
promo images
README claims
docs claims
package name if shown publicly
```

Flag risky terms:

```text
official
uBlock Origin
uBO
Google
Chrome official
Featured
Editor's Choice
Number One
best ad blocker
fastest ad blocker
superior to uBlock Origin
```

Do not delete repo identity unless requested. Instead, produce:

```text
- risk assessment
- safe public name options
- recommended public listing title
- phrases to avoid
- phrases allowed
```

## Safe public positioning examples

```text
MV3 Content Blocker with Local Diagnostics
Transparent MV3 Blocker
Evidence-First Content Blocker
```

## Evidence schema

```json
{
  "manifestNameAudited": true,
  "storeTitleAudited": true,
  "impersonationRiskFound": false,
  "riskyPhrases": [],
  "safeNameRecommendationExists": true,
  "humanLegalReviewRequired": true,
  "pass": true
}
```

## Acceptance

```text
The repo has a clear warning that final public name and icon need human/legal review.
No generated listing text implies affiliation with uBlock Origin, Google, or Chrome.
```

---

# B3 — Manifest V3 package compliance

## Goal

Ensure the extension is structurally MV3-compliant and package-ready.

## Required files

```text
tools/cws/audit-mv3-package.mjs
artifacts/cws/mv3-package-audit.json
docs/chrome-web-store/mv3-package-readiness.md
```

## Audit checks

```text
manifest_version is 3
background service_worker exists
service worker file exists in package
service worker is non-empty
all manifest paths exist
icons exist
content scripts exist
web_accessible_resources paths exist
declarative_net_request rule_resources paths exist
minimum_chrome_version is present if APIs require it
no MV2-only fields
no browser_action field if MV3 action is needed
no blocking webRequest usage unless allowed and justified
package can be zipped deterministically
```

## Evidence schema

```json
{
  "manifestVersion": 3,
  "serviceWorkerDeclared": true,
  "serviceWorkerFileExists": true,
  "serviceWorkerNonEmpty": true,
  "manifestPathsValid": true,
  "dnrRulesetPathsValid": true,
  "iconsValid": true,
  "mv2OnlyFields": [],
  "packageBuildPass": true,
  "pass": true
}
```

## Acceptance

```text
Chrome can load the unpacked extension from the intended folder.
The package does not contain broken manifest references.
```

---

# B4 — Remote hosted code and dynamic execution audit

## Goal

Prevent Chrome Web Store rejection for remote hosted code, hidden logic, or dynamic code execution.

## Required files

```text
tools/cws/audit-remote-code.mjs
artifacts/cws/remote-code-audit.json
docs/chrome-web-store/remote-code-policy.md
```

## Audit patterns

Search for:

```text
eval(
new Function
setTimeout("string")
setInterval("string")
import("http
import("https
<script src="http
<script src="https
chrome.scripting.executeScript with remote source
fetch(...).then(...eval...)
Function constructor
wasm loaded from remote URL
CDN URLs
unpkg
jsdelivr
cdnjs
googleapis scripts
remote script injection
base64-decoded code execution
```

External data is allowed only if it is data, not executable logic. Filter lists are data. Executing downloaded filter text as code is not allowed.

## Evidence schema

```json
{
  "evalFound": [],
  "newFunctionFound": [],
  "stringTimersFound": [],
  "remoteScriptReferencesFound": [],
  "cdnReferencesFound": [],
  "remoteExecutableLogicFound": false,
  "externalDataSourcesDocumented": true,
  "pass": true
}
```

## Acceptance

```text
All executable JavaScript is inside the submitted extension package.
Remote resources are data only and are documented.
```

---

# B5 — Code readability and non-obfuscation audit

## Goal

Ensure the submitted package is reviewable.

## Required files

```text
tools/cws/audit-code-readability.mjs
artifacts/cws/code-readability-audit.json
docs/chrome-web-store/code-readability.md
```

## Implementation instructions

Audit for:

```text
obfuscated files
packed/eval-like bundles
base64 encoded code
hex/unicode encoded suspicious strings
large unreadable generated files without source map or source reference
hidden behavior in minified vendor code
binary blobs not justified
```

Minification is acceptable, but reviewers must be able to discern functionality. For packaged generated bundles, maintain source references and build reproducibility.

## Evidence schema

```json
{
  "obfuscatedCodeFound": false,
  "minifiedButReadableOrSourceMapped": true,
  "generatedFilesDocumented": true,
  "binaryFilesJustified": true,
  "suspiciousEncodingFindings": [],
  "pass": true
}
```

## Acceptance

```text
A reviewer can understand what the extension does from submitted code and repo docs.
```

---

# B6 — Permission minimization and justification

## Goal

Request only necessary permissions and justify each one.

## Required files

```text
tools/cws/audit-permissions.mjs
docs/chrome-web-store/permissions-justification.md
artifacts/cws/permissions-audit.json
```

## Audit

Inspect:

```text
permissions
optional_permissions
host_permissions
optional_host_permissions
content_scripts.matches
externally_connectable
web_accessible_resources.matches
declarative_net_request rule scopes
```

For each permission, write:

```text
permission name
why it is needed
which feature uses it
whether it can be optional
whether activeTab can replace it
risk level
user-facing explanation
test proving it is used
```

## Special standard for a blocker

Broad host access may be necessary, but it must be explained clearly:

```text
The extension needs page/network access to apply filtering rules and cosmetic filtering on websites the user visits.
Filtering and diagnostics must remain local by default.
```

## Evidence schema

```json
{
  "permissions": [],
  "hostPermissions": [],
  "optionalPermissionsConsidered": true,
  "activeTabConsidered": true,
  "unusedPermissions": [],
  "overbroadPermissions": [],
  "allPermissionsJustified": true,
  "userFacingPermissionTextExists": true,
  "pass": true
}
```

## Acceptance

```text
No permission exists without a feature, test, and explanation.
No future-proof permissions are present.
```

---

# B7 — User data, privacy, and Limited Use readiness

## Goal

Make the extension local-first and privacy-policy ready.

## Required files

```text
docs/chrome-web-store/privacy-policy-draft.md
docs/chrome-web-store/privacy-practices.md
docs/chrome-web-store/limited-use-disclosure.md
docs/chrome-web-store/data-inventory.md
tools/cws/audit-user-data.mjs
artifacts/cws/user-data-audit.json
```

## Default privacy design

```text
No remote telemetry by default.
No sale or transfer of user data.
No remote collection of browsing history.
No remote collection of URLs, page titles, domains, rule hits, logger rows, or content.
Logger data is local-only by default.
Settings are local or Chrome sync only if explicitly implemented and disclosed.
```

## Data inventory categories

Audit and document:

```text
settings
filter list sources
custom rules
logger rows
blocked URLs
allowed URLs
tab IDs
hostnames/domains
extension errors
performance metrics
support diagnostics
sync data
crash/error reporting
```

For each category:

```text
collected?
stored?
where?
retention?
leaves device?
user can delete?
needed for which feature?
disclosed in UI/listing/privacy policy?
```

## Evidence schema

```json
{
  "dataInventoryExists": true,
  "remoteTelemetryDefault": false,
  "browsingHistoryLeavesDevice": false,
  "loggerLocalOnly": true,
  "privacyPolicyDraftExists": true,
  "limitedUseDisclosureExists": true,
  "privacyPracticesDraftExists": true,
  "deleteOrClearDataControlsDocumented": true,
  "pass": true
}
```

## Acceptance

```text
The user-data story is honest, local-first, and ready for the Chrome Web Store privacy tab.
```

---

# B8 — Security boundary audit

## Goal

Make privileged extension surfaces safe.

## Required files

```text
tools/cws/audit-security-boundaries.mjs
docs/chrome-web-store/security-boundary-review.md
artifacts/cws/security-boundary-audit.json
```

## Audit surfaces

```text
chrome.runtime.onMessage
chrome.runtime.onConnect
ports
content script messages
logger commands
popup commands
dashboard commands
reloadTab
dynamic rules
scriptlet injection
MAIN world injection
DNR updates
storage updates
web_accessible_resources
externally_connectable
native messaging if present
cross-origin fetches
```

## Required standards

```text
validate message channel
validate msgId
validate command name
validate tabId
validate URL and origin where relevant
do not trust content scripts
do not use innerHTML with untrusted data
do not let page-controlled input trigger privileged actions
rate-limit sensitive commands if needed
keep MAIN-world injection minimal and site-scoped
```

## Evidence schema

```json
{
  "runtimeMessageHandlersAudited": true,
  "contentScriptTrustBoundaryDocumented": true,
  "schemaValidationPresent": true,
  "unsafeInnerHtmlFindings": [],
  "privilegedCommandGuardsPresent": true,
  "mainWorldInjectionAudited": true,
  "externallyConnectableSafe": true,
  "pass": true
}
```

## Acceptance

```text
The extension treats page and content-script input as hostile.
No untrusted input can trigger unsafe privileged behavior.
```

---

# B9 — Web-accessible resources minimization

## Goal

Expose only what must be exposed.

## Required files

```text
tools/cws/audit-web-accessible-resources.mjs
docs/chrome-web-store/web-accessible-resources-audit.md
artifacts/cws/war-audit.json
```

## Audit

For each web-accessible resource:

```text
path
why exposed
which feature needs it
which matches can access it
can access be narrowed?
does it reveal extension internals?
can it be fingerprinted?
is it needed for ad-sink/cosmetics/scriptlets?
```

## Evidence schema

```json
{
  "resources": [],
  "allResourcesJustified": true,
  "matchesAreNarrowestPractical": true,
  "unnecessaryResources": [],
  "fingerprintingRiskDocumented": true,
  "pass": true
}
```

## Acceptance

```text
No file is web-accessible just because it is convenient.
```

---

# B10 — Ad-blocking safety and prohibited behavior audit

## Goal

Ensure anti-adblock compatibility does not become deceptive server-side behavior.

## Required files

```text
docs/chrome-web-store/ad-blocking-safety-policy.md
tools/cws/audit-ad-safety.mjs
artifacts/cws/ad-safety-audit.json
```

## Allowed

```text
block ads and trackers
block analytics and telemetry
redirect detection-prone page-side resources to local inert surrogates
preserve bait DOM nodes for page-side anti-adblock compatibility
define harmless page-side globals
cosmetic filtering
scriptlet defusers
local diagnostic logging
```

## Not allowed

```text
fake impressions
fake clicks
fake viewability
fake conversions
fake ad beacons
real ad-server signals for ads not shown
downloading real ads only to hide/encrypt/corrupt them
tricking ad servers into thinking an ad was viewed
paywall circumvention
login restriction bypass
DRM bypass
copyrighted media download/stream unlock
```

## Evidence schema

```json
{
  "fakeImpressionCodeFound": false,
  "fakeClickCodeFound": false,
  "fakeBeaconCodeFound": false,
  "realAdServerSimulationFound": false,
  "paywallBypassBehaviorFound": false,
  "safeAdSinkBoundariesDocumented": true,
  "controlledTestsCoverSafety": true,
  "pass": true
}
```

## Acceptance

```text
The blocker may fool page-side anti-adblock JavaScript in controlled, client-side ways.
It must not fool ad servers, billing systems, paywalls, or access controls.
```

---

# B11 — Performance and reliability budget

## Goal

Show that the extension is efficient and does not harm browsing.

## Required files

```text
docs/chrome-web-store/performance-budget.md
tools/cws/measure-performance-budget.mjs
tests/e2e/performance-budget.spec.mjs
artifacts/cws/performance-budget.json
```

## Required metrics

```text
extension load time
service worker startup time
service worker idle behavior
popup open time
logger open time
logger memory growth
DNR ruleset validation/load time
content script startup time
cosmetic MutationObserver overhead
scriptlet injection overhead
page load impact on controlled pages
CPU usage during idle
memory usage during idle
```

## Hard failures

```text
persistent service worker busy loop
runaway MutationObserver
unbounded logger memory growth
large synchronous work on every page
content-script WebSocket/WebRTC unless justified
unload handlers that harm page lifecycle
```

## Evidence schema

```json
{
  "serviceWorkerStartupMs": 0,
  "popupOpenMs": 0,
  "loggerOpenMs": 0,
  "contentScriptStartupMs": 0,
  "mutationObserverOverheadAcceptable": true,
  "loggerMemoryGrowthBounded": true,
  "idleCpuAcceptable": true,
  "pageLoadImpactAcceptable": true,
  "hardFailures": [],
  "pass": true
}
```

## Acceptance

```text
Performance is measured, not guessed.
Any slow area has a documented budget and remediation item.
```

---

# B12 — UX, onboarding, accessibility, and user control

## Goal

Meet high standard of user experience and design.

## Required files

```text
docs/chrome-web-store/ux-onboarding-review.md
docs/chrome-web-store/accessibility-review.md
tools/cws/audit-ux-readiness.mjs
artifacts/cws/ux-readiness.json
```

## UX requirements

```text
popup opens reliably
logger opens reliably
dashboard/settings are navigable
extension state is understandable
blocking state is understandable
site-level controls are clear
user can disable/enable major features
privacy behavior is explained
permissions are explained
errors are visible and actionable
no clipped popup/logger UI
no broken links
no dead buttons
no placeholder UI in release build
no console errors in common flows
```

## Accessibility requirements

```text
keyboard navigation
visible focus states
semantic buttons/labels
sufficient text contrast
no text-only icon controls without label/title
screen-reader labels for important controls
no tiny unclickable controls
does not depend only on color
```

## Evidence schema

```json
{
  "popupReliable": true,
  "loggerReliable": true,
  "settingsNavigable": true,
  "noPlaceholderReleaseUi": true,
  "noDeadButtons": true,
  "keyboardNavigationPass": true,
  "focusStatesPass": true,
  "labelsPass": true,
  "colorOnlyFailures": [],
  "consoleErrors": [],
  "pass": true
}
```

## Acceptance

```text
A normal user can install, understand, control, and troubleshoot the extension without reading source code.
```

---

# B13 — Chrome Web Store listing package

## Goal

Prepare accurate listing materials without unsupported claims.

## Required files

```text
docs/chrome-web-store/listing-title-options.md
docs/chrome-web-store/listing-summary.md
docs/chrome-web-store/listing-description.md
docs/chrome-web-store/listing-permissions-disclosure.md
docs/chrome-web-store/listing-privacy-disclosure.md
docs/chrome-web-store/listing-screenshot-plan.md
docs/chrome-web-store/listing-review-checklist.md
tools/cws/audit-listing-copy.mjs
artifacts/cws/listing-audit.json
```

## Listing copy rules

Do not use:

```text
best
fastest
#1
number one
Editor's Choice
Featured
official
uBlock Origin endorsed
Google endorsed
Chrome endorsed
superior to uBlock Origin
guaranteed blocks all ads
undetectable
stealth against everything
```

Do use accurate, evidence-backed wording:

```text
Manifest V3-native content blocker
transparent local diagnostics
local logger
local-first filtering
evidence-backed blocking decisions
user-controlled settings
privacy-conscious design
```

## Required listing materials

```text
title
short summary
long description
category recommendation
language/localization plan
privacy disclosure text
permissions disclosure text
support URL placeholder
homepage URL placeholder
screenshot plan
promo tile plan
marquee image plan
reviewer test instructions
known limitations
```

## Evidence schema

```json
{
  "titleDraftExists": true,
  "summaryDraftExists": true,
  "descriptionDraftExists": true,
  "permissionsDisclosureExists": true,
  "privacyDisclosureExists": true,
  "screenshotPlanExists": true,
  "unsupportedClaims": [],
  "keywordStuffingRisk": false,
  "competitorReferencesInSummary": false,
  "misleadingStatusClaims": [],
  "pass": true
}
```

## Acceptance

```text
The listing says only what the extension actually does.
Screenshots and descriptions match shipped behavior.
```

---

# B14 — Screenshots, icons, and promotional assets checklist

## Goal

Prepare a complete asset plan for review and possible featuring.

## Required files

```text
docs/chrome-web-store/asset-specification.md
docs/chrome-web-store/screenshot-capture-checklist.md
assets/chrome-web-store/README.md
tools/cws/audit-store-assets.mjs
artifacts/cws/store-assets-audit.json
```

## Asset checklist

```text
extension icon exists in required sizes
screenshots are real, current, and not mock-only
screenshots show popup
screenshots show logger
screenshots show settings/dashboard
screenshots show local evidence/artifacts if appropriate
screenshots do not show unsupported features
screenshots do not include misleading badges
screenshots do not include competitor trademarks unnecessarily
small promo tile plan exists
marquee image plan exists
visual branding is consistent
images are not cluttered
images avoid too much text
```

## Evidence schema

```json
{
  "iconsExist": true,
  "screenshotPlanExists": true,
  "screenshotsCurrent": false,
  "promoTilePlanExists": true,
  "marqueePlanExists": true,
  "misleadingAssetClaims": [],
  "assetHumanDesignReviewRequired": true,
  "pass": false
}
```

## Acceptance

```text
The repo has a complete asset checklist.
Actual final screenshots may remain blocked until UI implementation is complete.
```

---

# B15 — Reviewer instructions and submission package

## Goal

Make Chrome Web Store review easier by providing precise test instructions.

## Required files

```text
docs/chrome-web-store/reviewer-test-instructions.md
docs/chrome-web-store/release-submission-checklist.md
tools/cws/build-review-package.mjs
artifacts/cws/review-package.json
```

## Reviewer instructions must include

```text
extension purpose
what permissions are needed and why
how to load/test core functionality
how to test popup
how to test logger
how to test blocking on controlled test page
how to test cosmetic filtering if implemented
how to test scriptlets if implemented
how to test settings
what data is stored locally
what data does not leave device
known limitations
support contact placeholder
```

## Evidence schema

```json
{
  "reviewerInstructionsExist": true,
  "permissionExplanationIncluded": true,
  "privacyExplanationIncluded": true,
  "coreFlowTestStepsIncluded": true,
  "knownLimitationsIncluded": true,
  "supportContactPlaceholderIncluded": true,
  "packageChecklistExists": true,
  "pass": true
}
```

## Acceptance

```text
A Chrome reviewer can verify the extension without reverse-engineering expected behavior.
```

---

# B16 — CI gate and final badge-readiness report

## Goal

Tie all badge-readiness audits into CI and produce a single final report.

## Required files

```text
tools/cws/run-featured-readiness-audit.mjs
tools/cws/score-featured-readiness.mjs
artifacts/cws/featured-readiness-score.json
docs/chrome-web-store/featured-readiness-final-report.md
.github/workflows/featured-readiness.yml
```

If the repo does not use GitHub Actions, create the workflow file anyway or document the equivalent command in `package.json`.

## Required CI command

Add one command, adapting to the repo's package manager:

```bash
npm run cws:featured-readiness
```

This command must run:

```text
source snapshot
single-purpose audit
branding risk audit
MV3 package audit
remote-code audit
code-readability audit
permissions audit
user-data audit
security-boundary audit
web-accessible-resources audit
ad-safety audit
performance budget
UX readiness audit
listing copy audit
store assets audit
review package audit
score generation
publisher readiness audit
dashboard fields audit
support readiness audit
store metrics readiness audit
release lifecycle audit
expanded score generation
```

## Scoring model

Create `artifacts/cws/featured-readiness-score.json`:

```json
{
  "score": 0,
  "maxScore": 100,
  "badgeGuarantee": false,
  "manualGoogleReviewRequired": true,
  "categories": {
    "policyCompliance": 0,
    "mv3Compliance": 0,
    "remoteCodeSafety": 0,
    "permissionMinimization": 0,
    "privacyUserData": 0,
    "securityBoundaries": 0,
    "adBlockingSafety": 0,
    "performanceReliability": 0,
    "uxAccessibility": 0,
    "listingAccuracy": 0,
    "brandingTrust": 0,
    "reviewPackage": 0
  },
  "blockers": [],
  "warnings": [],
  "humanReviewRequired": [],
  "pass": false
}
```

## Minimum readiness thresholds

```text
Badge-ready internal target:
score >= 95
policyCompliance = 100
mv3Compliance = 100
remoteCodeSafety = 100
privacyUserData >= 95
securityBoundaries >= 95
adBlockingSafety = 100
listingAccuracy >= 95
brandingTrust >= 90
no critical blockers
```

## Critical blockers

Any of these makes badge readiness fail:

```text
remote executable code
MV3 package invalid
manifest broken
missing privacy disclosure for handled user data
unjustified broad permissions
deceptive listing claim
impersonation/endorsement risk not addressed
fake ad impression/click/beacon behavior
paywall or access-control bypass behavior
obfuscated code hiding functionality
core listed feature not working
non-production/debug build submitted as final
```

## Acceptance

```text
A single command generates the final badge-readiness score and all supporting artifacts.
The final report clearly separates:
- pass
- partial
- blocked
- not applicable
- needs human/legal review
```

---

# B17 — Publisher, developer account, and trust readiness

## Goal

Make the project ready for the non-code parts that affect trust, review, and potential featuring.

## Required files

```text
docs/chrome-web-store/publisher-account-readiness.md
docs/chrome-web-store/verified-publisher-readiness.md
docs/chrome-web-store/developer-reputation-risk.md
tools/cws/audit-publisher-readiness.mjs
artifacts/cws/publisher-readiness.json
```

## Human-owned items to document

```text
Chrome Web Store developer account exists
one-time registration fee handled
publisher/developer email is monitored
2-step verification is enabled for publishing account
developer profile is complete
official URL / website ownership can be verified
support URL is live
homepage URL is live
publisher name does not impersonate Google, Chrome, uBlock Origin, or another party
developer has no unresolved policy warnings or questionable-reputation issues
ownership/team access is documented if more than one maintainer will publish
verified CRX upload signing / trusted private-key opt-in decision is documented
private-key custody, rotation, backup, and loss response are human-owned and documented if opt-in is used
```

## Implementation instructions

The coding agent cannot create or verify the real account. It must create a readiness checklist and mark each item as:

```text
pass
blocked
needs human action
not applicable
```

## Evidence schema

```json
{
  "developerAccountChecklistExists": true,
  "publisherEmailMonitoringDocumented": true,
  "twoStepVerificationRequired": true,
  "officialUrlReadinessDocumented": true,
  "supportUrlReadinessDocumented": true,
  "developerReputationRiskDocumented": true,
  "verifiedUploadSigningDecisionDocumented": true,
  "privateKeyCustodyHumanOwnedIfUsed": true,
  "humanActionRequired": [],
  "pass": false
}
```

## Acceptance

```text
The repo clearly separates code readiness from publisher/account readiness.
A human can see exactly what must be completed in the Chrome Developer Dashboard.
```

---

# B18 — Dashboard field, category, content rating, payment, and distribution readiness

## Goal

Prepare every Chrome Web Store dashboard field needed for a clean submission.

## Required files

```text
docs/chrome-web-store/dashboard-field-map.md
docs/chrome-web-store/category-and-content-rating.md
docs/chrome-web-store/payment-and-distribution.md
tools/cws/audit-dashboard-fields.mjs
artifacts/cws/dashboard-fields-audit.json
```

## Required dashboard field groups

```text
single purpose statement
permission justifications
remote code declaration
user data categories
Limited Use certification
privacy policy URL
store title
summary
long description
category
language/localization
content rating
payment declaration
visibility/distribution
regions
homepage URL
support URL
official URL if verified
reviewer test instructions
screenshots
store icon
small promo tile
marquee tile if provided
promo video if provided
```

## Project-specific defaults

```text
payment: no paid features unless explicitly implemented and disclosed
remote code: No, if B4 passes
visibility: private/trusted tester before public launch
category: choose the closest honest category; do not choose a category only for ranking
content rating: should be non-mature/family-safe unless actual functionality says otherwise
regions: document any regional restrictions; default global only if support/privacy policy can handle it
```

## Evidence schema

```json
{
  "dashboardFieldMapExists": true,
  "singlePurposeFieldPrepared": true,
  "permissionJustificationsPrepared": true,
  "remoteCodeDeclarationPrepared": true,
  "privacyFieldsPrepared": true,
  "contentRatingPrepared": true,
  "paymentDeclarationPrepared": true,
  "distributionPlanPrepared": true,
  "reviewerInstructionsPrepared": true,
  "missingRequiredFields": [],
  "humanActionRequired": [],
  "pass": true
}
```

## Acceptance

```text
A publisher can fill the Developer Dashboard without inventing claims or guessing policy answers.
```

---

# B19 — Support, user feedback, review-response, and trust operations

## Goal

Prepare support and feedback operations so users and reviewers can trust the extension after launch.

## Required files

```text
docs/chrome-web-store/support-and-feedback-plan.md
docs/chrome-web-store/review-response-policy.md
docs/chrome-web-store/abuse-report-handling.md
tools/cws/audit-support-readiness.mjs
artifacts/cws/support-readiness.json
```

## Requirements

```text
support URL exists or is clearly blocked on human setup
support contact is monitored
bug report template exists
privacy/security report channel exists
response policy exists for user reviews and support tickets
no incentivized reviews
no review manipulation
no suppression of negative feedback
no misleading responses to user complaints
clear escalation path for privacy/security issues
```

## Evidence schema

```json
{
  "supportPlanExists": true,
  "supportUrlRequired": true,
  "bugReportTemplateExists": true,
  "securityReportChannelDocumented": true,
  "reviewResponsePolicyExists": true,
  "reviewManipulationBanned": true,
  "humanActionRequired": [],
  "pass": false
}
```

## Acceptance

```text
The project has an honest user-support plan and does not rely on artificial ranking/review manipulation.
```

---

# B20 — Store metrics, quality signals, and post-launch monitoring

## Goal

Prepare a monitoring plan for the quality signals that affect discovery and user trust.

## Required files

```text
docs/chrome-web-store/store-metrics-monitoring.md
docs/chrome-web-store/post-launch-quality-plan.md
tools/cws/audit-store-metrics-readiness.mjs
artifacts/cws/store-metrics-readiness.json
```

## Metrics to monitor after launch

```text
install conversion
active users
downloads vs uninstalls
uninstall reasons where available
rating trend
review themes
support volume
crash/error reports if available
policy warnings
review status
listing traffic by country/language
```

## Privacy rule

```text
Use Chrome Web Store dashboard metrics and user-submitted support data.
Do not add invasive telemetry just to optimize ranking.
Do not collect browsing history or URL data for analytics.
```

## Evidence schema

```json
{
  "metricsPlanExists": true,
  "qualitySignalsDocumented": true,
  "invasiveTelemetryProhibited": true,
  "uninstallMonitoringPlanned": true,
  "reviewThemeMonitoringPlanned": true,
  "localFirstAnalyticsPolicy": true,
  "pass": true
}
```

## Acceptance

```text
The extension can improve based on legitimate store metrics and user feedback without privacy-invasive telemetry.
```

---

# B21 — Production release, trusted testing, staged rollout, update, and rollback readiness

## Goal

Avoid submitting an unstable or non-production build, and prepare safe update/rollback procedures.

## Required files

```text
docs/chrome-web-store/release-channel-plan.md
docs/chrome-web-store/trusted-tester-plan.md
docs/chrome-web-store/update-and-rollback-plan.md
docs/chrome-web-store/periodic-review-readiness.md
tools/cws/audit-release-lifecycle.mjs
artifacts/cws/release-lifecycle.json
```

## Requirements

```text
private/trusted tester phase before public release
production build flag or release profile documented
no debug-only UI in public package
no test hostnames or localhost dependencies in public package
versioning policy exists
changelog policy exists
release notes template exists
staged rollout strategy exists if using API/deploy percentage
rollback plan exists
cancel-review procedure documented
periodic re-review compliance plan exists
all material changes trigger re-run of P17 audit
```

## Evidence schema

```json
{
  "trustedTesterPlanExists": true,
  "productionBuildChecklistExists": true,
  "debugArtifactsExcluded": true,
  "versioningPolicyExists": true,
  "changelogPolicyExists": true,
  "stagedRolloutPlanExists": true,
  "rollbackPlanExists": true,
  "periodicReviewPlanExists": true,
  "humanActionRequired": [],
  "pass": true
}
```

## Acceptance

```text
The project is prepared for first submission, updates, re-review, rollback, and policy changes.
```

---

# B22 — Expanded score-model gate

## Goal

Add the expanded score model that later final gates will use, and ensure human-only items do not get falsely marked as passed.

## Required files

```text
tools/cws/score-featured-readiness-expanded.mjs
artifacts/cws/featured-readiness-score-expanded.json
docs/chrome-web-store/featured-readiness-final-report-expanded.md
```

## Expanded scoring additions

Add these categories to the scoring model:

```json
{
  "publisherTrust": 0,
  "dashboardCompleteness": 0,
  "supportFeedbackReadiness": 0,
  "storeMetricsReadiness": 0,
  "releaseLifecycle": 0,
  "legalAccountGovernance": 0,
  "marketingInstallFunnel": 0,
  "supplyChainPackageIntegrity": 0
}
```

## Expanded critical blockers

```text
unmonitored publisher email
no support path
no privacy policy URL when user data is handled
missing required dashboard privacy fields
missing required graphic asset
misleading category/content rating/payment declaration
review/rating manipulation plan or code
public package contains debug/prototype/placeholder build
no rollback plan for high-risk update
unresolved policy warning not documented
trader/non-trader verification blocker not documented
public acquisition funnel uses deceptive installation tactics
keyword spam or review/ranking manipulation in metadata or public materials
unknown-license or high-risk dependency in submitted package
submitted package cannot be traced back to source
```

## Evidence schema

```json
{
  "baseScoreFileExists": true,
  "expandedScoreFileExists": true,
  "expandedScoreModelIncludesLaterGates": true,
  "humanOnlyItemsSeparated": true,
  "criticalBlockers": [],
  "warnings": [],
  "pass": false
}
```

## Acceptance

```text
The final score cannot be 100 unless all code, policy, listing, publisher, support, metrics, release-lifecycle, legal/account, acquisition-funnel, localization/analytics, and supply-chain/package-integrity gates are either passed or correctly marked not applicable.
```

---


# B23 — Legal, trader disclosure, ownership, and enforcement-readiness gate

## Goal

Make sure the publisher can submit and maintain the extension without avoidable account, legal, ownership, trader-disclosure, or enforcement-response blockers.

## Required files

```text
docs/chrome-web-store/legal-and-developer-agreement-readiness.md
docs/chrome-web-store/trader-disclosure-readiness.md
docs/chrome-web-store/ownership-and-access-governance.md
docs/chrome-web-store/violation-appeal-and-enforcement-playbook.md
tools/cws/audit-legal-account-governance.mjs
artifacts/cws/legal-account-governance.json
```

## Human-owned items to document

```text
Chrome Web Store Developer Agreement accepted by the actual publisher
publisher is legally eligible to publish
publisher is not barred from using Chrome Web Store under applicable law
publisher understands applicable-law responsibility
trader/non-trader status determined by the actual publisher
trader verification completed if required
public trader contact details reviewed if applicable
publisher ownership structure documented
publisher member roles documented
admin access limited to trusted maintainers
account recovery and 2-step verification backup plan documented
policy warning / rejection / takedown / appeal workflow documented
support ticket / One Stop Support escalation documented
copyright / trademark / privacy / publicity / third-party rights review marked for human/legal review
```

## Implementation instructions

The coding agent cannot complete legal verification or trader verification. It must create a checklist and mark each item as:

```text
pass
blocked
needs human action
not applicable
```

The audit must fail if the project pretends these human-owned legal/account items are code-complete.

## Evidence schema

```json
{
  "developerAgreementChecklistExists": true,
  "legalEligibilityChecklistExists": true,
  "traderDisclosureChecklistExists": true,
  "ownershipGovernanceExists": true,
  "accountRecoveryPlanExists": true,
  "enforcementAppealPlaybookExists": true,
  "humanLegalReviewRequired": true,
  "humanActionRequired": [],
  "criticalBlockers": [],
  "pass": false
}
```

## Acceptance

```text
A human publisher can see exactly which legal/account/trader/ownership items must be completed outside the repo before public submission.
The final badge-readiness score cannot treat these human-only items as passed unless evidence is entered manually.
```

---

# B24 — Off-store marketing, install-funnel, anti-spam, localization, and analytics governance

## Goal

Prevent the extension from losing trust or review eligibility because of misleading acquisition, keyword spam, deceptive install funnels, external landing pages, review manipulation, or privacy-invasive analytics.

## Required files

```text
docs/chrome-web-store/off-store-marketing-and-install-funnel-policy.md
docs/chrome-web-store/anti-spam-and-keyword-policy.md
docs/chrome-web-store/localization-plan.md
docs/chrome-web-store/analytics-governance.md
tools/cws/audit-marketing-install-funnel.mjs
artifacts/cws/marketing-install-funnel.json
```

## Audit scope

```text
Chrome Web Store title / summary / description
README and public docs
project website / homepage if present
support site if present
landing pages if present
GitHub release text
social posts / ads if maintained in repo
install buttons / calls to action
screenshots and promo images
localized listing drafts
Google Analytics use on the Chrome Web Store listing, if enabled
```

## Hard rules

```text
no typosquatted domains
no fake Chrome/browser/system/security warnings
no fake urgency or scareware language
no install gate implying users must install to continue to unrelated content
no misleading claims about being official, featured, safest, best, fastest, or guaranteed
no keyword stuffing
no lists of brands/sites/competitors only for ranking manipulation
no incentivized reviews
no suppression or hiding of negative reviews
no invasive telemetry just to optimize ranking
no Google Analytics plan that captures browsing history, URLs, page titles, rule hits, or local logger data
localized text must preserve the same claims and limitations as the primary listing
```

## Evidence schema

```json
{
  "marketingPolicyExists": true,
  "installFunnelAuditExists": true,
  "keywordSpamAuditExists": true,
  "localizationPlanExists": true,
  "analyticsGovernanceExists": true,
  "deceptiveInstallTacticsBanned": true,
  "keywordStuffingBanned": true,
  "reviewManipulationBanned": true,
  "analyticsPrivacyBoundariesDocumented": true,
  "humanActionRequired": [],
  "criticalBlockers": [],
  "pass": true
}
```

## Acceptance

```text
The project has a clear policy that covers Chrome Web Store metadata and any external acquisition path.
The extension does not rely on deceptive installation tactics, keyword spam, ranking manipulation, or privacy-invasive analytics.
```

---

# B25 — Supply-chain, dependency, license, vulnerability, and reproducible-package audit

## Goal

Make the submitted extension package reviewable, reproducible, license-clean, and free of known high-risk dependencies or hidden generated code.

## Required files

```text
docs/chrome-web-store/supply-chain-and-dependency-audit.md
docs/chrome-web-store/third-party-license-inventory.md
docs/chrome-web-store/reproducible-build-and-package-integrity.md
docs/chrome-web-store/vulnerability-management.md
tools/cws/audit-supply-chain.mjs
tools/cws/audit-package-integrity.mjs
artifacts/cws/supply-chain-audit.json
artifacts/cws/package-integrity.json
```

## Audit requirements

```text
lockfile exists if package manager is used
build is deterministic or non-determinism is documented
submitted package is produced from committed source
compiled/minified bundles map back to source where possible
source maps are included or deliberately excluded with a reviewer explanation
third-party code inventory exists
third-party asset inventory exists
license inventory exists
no unknown-license assets in submitted package
no vulnerable dependency above documented severity threshold
no postinstall/download scripts that fetch executable code
no hidden generated code outside the build pipeline
no vendored dependency modifications without documentation
package manifest version matches release notes
public package excludes tests, local fixtures, private keys, tokens, secrets, logs, and debug-only artifacts
if verified CRX uploads are enabled, package-signing flow is documented without committing private keys
release artifact checksum / provenance record is generated before upload
```

## Evidence schema

```json
{
  "dependencyInventoryExists": true,
  "licenseInventoryExists": true,
  "thirdPartyAssetInventoryExists": true,
  "lockfileAudited": true,
  "packageReproducibilityDocumented": true,
  "submittedPackageMatchesSource": true,
  "sourceMapPolicyDocumented": true,
  "vulnerabilityScanRun": true,
  "secretsExcluded": true,
  "debugArtifactsExcluded": true,
  "verifiedUploadSigningFlowDocumentedIfUsed": true,
  "releaseArtifactChecksumGenerated": true,
  "criticalBlockers": [],
  "warnings": [],
  "pass": false
}
```

## Acceptance

```text
A reviewer or maintainer can trace the submitted package back to source and understand every significant third-party dependency, license, generated bundle, and packaged asset.
Known severe dependency, license, secret, or package-integrity issues block public submission.
```

---

# B26 — Negative-policy trap audit: settings overrides, notifications, redirection, minimum functionality, and unauthorized-access boundaries

## Goal

Catch Chrome Web Store policy traps that are easy to miss because they are not part of the normal ad-blocker implementation path.

This phase is mostly a **prove absence / mark not applicable** audit. The LLM coder must not add these features unless they are already present and directly required. For `uBlockResurrected`, most of them should be explicitly prohibited or marked not applicable.

## Required files

```text
docs/chrome-web-store/negative-policy-trap-audit.md
docs/chrome-web-store/settings-overrides-policy.md
docs/chrome-web-store/notifications-and-user-messaging-policy.md
docs/chrome-web-store/minimum-functionality-and-redirection-policy.md
docs/chrome-web-store/unauthorized-access-and-copyright-boundary.md
tools/cws/audit-negative-policy-traps.mjs
artifacts/cws/negative-policy-traps.json
```

## Audit scope

```text
manifest permissions and chrome_settings_overrides
new tab / homepage / startup page / default search / omnibox behavior
chrome.notifications usage
external messaging and messages sent on behalf of users
browser action / popup behavior
first-run pages and install landing pages
support / homepage URLs
remote service dependencies
content-blocking and scriptlet rules that could bypass paywalls/login/DRM/copyright restrictions
claims that imply antivirus, security-suite, malware-removal, VPN, bot, downloader, or other feature-restricted functionality
content rating risks: mature, violent, hateful, gambling, crypto, political/religious if used for listing/positioning
```

## Hard rules

```text
no homepage/startup/new-tab/default-search/omnibox override for this project
no settings override unless explicitly human-approved and justified by a separate single-purpose product
no notification permission unless a implemented user-facing feature requires it and the listing discloses it
no spam, ad, promo, phishing, or unwanted notifications
no messages sent on behalf of users without explicit user confirmation of content and recipients
no extension whose only practical function is opening a website, theme, app, or other extension
no server-dependent feature that makes the extension fail review if the server is down
no placeholder/prototype/non-production submission
no bypassing paywalls, login restrictions, DRM, copyrighted-media access restrictions, or unauthorized download/streaming controls
no cryptocurrency mining or hidden compute work
no mature/violent/hate/gambling/prohibited content unless accurately classified; default target is family-safe
no antivirus/security/privacy claims beyond functionality actually implemented and evidenced
```

## Implementation instructions

The coding agent must implement an audit script that reads at least:

```text
platform/chromium/manifest.json
package manifests and build config
public docs / README / listing drafts
Chrome Web Store docs generated by this prompt
extension JS bundles and content scripts where feasible
```

The audit should look for:

```text
chrome_settings_overrides
chrome.notifications
chrome.omnibox
chrome.search if used
chrome.history if used
chrome.topSites if used
chrome.bookmarks if used
chrome.management if used
externally_connectable
nativeMessaging
URLs or code paths related to paywall/login/DRM/download bypassing
crypto-mining libraries or suspicious compute loops
first-run tabs or redirect-only flows
claims containing antivirus, malware removal, VPN, downloader, official, featured, fastest, best, or guaranteed
```

If a feature is absent, mark it `notApplicable` rather than inventing work.
If a feature is present, require justification, listing disclosure, tests, and human approval.

## Evidence schema

```json
{
  "settingsOverridesAbsentOrJustified": true,
  "searchHomepageNtpOverrideAbsent": true,
  "notificationsAbsentOrJustified": true,
  "notificationAbuseRisk": false,
  "messagesOnBehalfAbsentOrConfirmed": true,
  "redirectionOnlyExtensionRisk": false,
  "minimumFunctionalityRisk": false,
  "serverDependencyReviewComplete": true,
  "unauthorizedAccessBypassRisk": false,
  "paywallLoginDrmCopyrightBypassRisk": false,
  "cryptoMiningRisk": false,
  "matureViolentHateGamblingContentRisk": false,
  "deceptiveSecurityClaimsRisk": false,
  "nonProductionSubmissionRisk": false,
  "humanActionRequired": [],
  "criticalBlockers": [],
  "warnings": [],
  "pass": false
}
```

## Acceptance

```text
The extension does not change browser/search settings, abuse notifications, send messages on behalf of users, act as a launch-only wrapper, depend on dead external services, bypass unauthorized access controls, or make unsupported security/privacy claims.
Any present high-risk behavior is explicitly justified, disclosed, tested, and marked for human review.
```

---


# B27 — Current Chrome platform-change governance and compatibility watch

## Goal

Prevent the badge-readiness package from becoming stale as Chrome changes extension APIs, Developer Dashboard workflows, permission UX, testing flags, and review expectations.

This phase exists because Chrome extension readiness is not static. The coder must not only pass the current audit; the repo must also include a repeatable way to re-check Chrome's current extension updates before each submission, release, and badge nomination.

## Required files

```text
docs/chrome-web-store/chrome-platform-change-watch.md
docs/chrome-web-store/chrome-version-and-api-adoption-policy.md
docs/chrome-web-store/developer-dashboard-roles-and-appeals-governance.md
docs/chrome-web-store/permission-request-ux-and-host-access-policy.md
docs/chrome-web-store/api-secrets-and-test-runner-compatibility.md
tools/cws/audit-chrome-platform-change-readiness.mjs
artifacts/cws/chrome-platform-change-readiness.json
```

## Official sources to re-check

The coding agent must re-check the official Chrome Extensions What's New page before finalizing this phase. Treat it as a live dependency, because it lists recent Chrome Extension, Chrome Web Store, and policy/platform notices.

Minimum specific items to account for from current Chrome guidance:

```text
Developer Dashboard publisher-account member roles introduced in 2026
Chrome Web Store dashboard appeal workflow introduced in 2026
Chrome 148 structured-clone messaging opt-in
Chrome 148 browser namespace availability as a cross-browser alternative
private publishing to external organizations if enterprise/private distribution is ever used
Chrome 140 sidePanel.getLayout() if the project uses sidePanel and supports RTL languages
Chrome 139 removal of --extensions-on-chrome-urls and --disable-extensions-except from branded Chrome builds
Chrome 138 new-tab-page UI changes if the extension ever touches new-tab behavior
chrome.permissions.addHostAccessRequest() and changing host-access user experience
Chrome 135 userScripts.execute() if userScripts are ever adopted
Chrome 132 extension storage visibility in DevTools
Chrome 132 frozen tab behavior and queued messages
Chrome 130 action.onUserSettingsChanged if action/pin state matters
Chrome 130 StorageArea.getKeys() if storage scanning/export/import uses it
Chrome 128 DNR response-header matching if header matching is used
API key/secrets guidance: no secrets embedded in client-side extension code unless the risk is explicitly documented and mitigated
```

## Implementation instructions

Create an audit script that checks repo files and generated docs for:

```text
minimum_chrome_version and API compatibility policy
use of chrome namespace vs browser namespace
whether structured-clone messaging is intentionally disabled or intentionally adopted
message serialization assumptions in vAPI/client/service-worker code
use of command-line flags in tests that no longer work in branded Chrome builds
fallback to Chromium/Chrome for Testing where required for extension E2E
use of chrome.sidePanel and whether sidePanel layout/RTL behavior is handled
use of chrome.permissions.addHostAccessRequest or an explicit decision not to use it
use of userScripts / userScripts.execute and whether all userScripts rules from B28/B29 apply
use of DNR response-header matching and minimum Chrome compatibility
use of tabs.frozen-aware messaging if tab messaging becomes flaky
extension storage audit docs acknowledging DevTools visibility and local inspection
any embedded API keys, secrets, service credentials, or tokens
Developer Dashboard access roles and least-privilege ownership model
appeal workflow and responsible owner for policy enforcement responses
```

If an API or platform feature is not used, record it as `notApplicable` with a short reason. Do not add unnecessary APIs merely because Chrome supports them.

## Required docs content

`chrome-platform-change-watch.md` must include:

```text
last official Chrome What's New check date
links checked
current Chrome stable/beta/dev/canary compatibility assumptions
current testing-browser choice
known Chrome version dependencies
upcoming Chrome changes that could affect the extension
owner responsible for re-checking before submission/update/badge nomination
```

`chrome-version-and-api-adoption-policy.md` must include:

```text
which new APIs are used
which new APIs are deliberately not used
minimum Chrome version rationale
fallback behavior for older supported Chrome versions
no experimental API use in production unless explicitly justified
```

`developer-dashboard-roles-and-appeals-governance.md` must include:

```text
publisher account owner
least-privilege dashboard roles
who can upload packages
who can edit listing/privacy fields
who can respond to policy notices
who can file appeals
backup contact / continuity plan
no shared personal credentials
```

`permission-request-ux-and-host-access-policy.md` must include:

```text
install-time permissions
optional permissions
host permissions
runtime host access requests if used
user-facing copy for why access is needed
no surprise permission escalation in updates
```

`api-secrets-and-test-runner-compatibility.md` must include:

```text
no production secrets in extension package
no service-account JSON checked into repo
Chrome for Testing / Chromium compatibility plan
branded Chrome test-flag limitations
CI browser version pinning and upgrade policy
```

## Evidence schema

```json
{
  "officialWhatsNewChecked": true,
  "officialWhatsNewCheckedDate": "",
  "developerDashboardRolesReviewed": true,
  "appealsWorkflowReviewed": true,
  "structuredCloneMessagingDecision": "not-used | adopted | pending",
  "browserNamespaceDecision": "chrome-only | browser-namespace | compatibility-wrapper | pending",
  "testFlagsCompatibleWithCurrentChrome": true,
  "chromeForTestingOrChromiumPlanExists": true,
  "hostAccessRequestPolicyExists": true,
  "sidePanelLayoutHandledOrNotApplicable": true,
  "userScriptsExecuteHandledOrNotApplicable": true,
  "dnrResponseHeaderMatchingHandledOrNotApplicable": true,
  "frozenTabMessagingHandledOrNotApplicable": true,
  "storageDevToolsVisibilityAcknowledged": true,
  "apiSecretsAuditPass": true,
  "minimumChromeVersionRationaleExists": true,
  "newApiAdoptionPolicyExists": true,
  "humanActionRequired": [],
  "criticalBlockers": [],
  "warnings": [],
  "pass": false
}
```

## Acceptance

```text
The repo contains a repeatable current-Chrome-change review process.
The project does not depend on outdated branded-Chrome test flags.
The project has an explicit policy for new Chrome APIs instead of accidentally adopting them.
The project has no embedded secrets or dashboard credentials.
Developer Dashboard roles, appeals, and upload authority are documented.
Permission UX and host-access escalation risks are documented and controlled.
```

---

# B28 — Chrome API compatibility, DNR quota, incognito/file-access, and match-pattern readiness gate

## Goal

Make sure the extension is not only policy-ready in general, but also technically reviewable as a modern Manifest V3 content blocker that depends on DNR, broad match patterns, optional incognito behavior, optional file URL access, and Chrome-version-specific APIs.

This phase is especially important for `uBlockResurrected` because a content blocker may need broad host access and large static rulesets, while Chrome review can be affected by broad permissions, hard-to-review rulesets, and APIs that behave differently across Chrome versions.

## Required files

```text
docs/chrome-web-store/dnr-quota-and-rule-limit-readiness.md
docs/chrome-web-store/api-compatibility-and-minimum-chrome-version.md
docs/chrome-web-store/incognito-file-url-and-match-pattern-policy.md
tools/cws/audit-dnr-api-compatibility.mjs
artifacts/cws/dnr-api-compatibility-readiness.json
```

## Implementation instructions

Audit the extension for:

```text
manifest minimum_chrome_version
Chrome API versions used by service worker, DNR, side panel, offscreen documents, userScripts, scripting, storage, declarativeNetRequestFeedback, and other extension APIs
userScripts availability, permission need, minimum_chrome_version, user-toggle/developer-toggle behavior, and reviewer instructions if userScripts is used now or later
static ruleset count
enabled static ruleset count
static rule count
dynamic rule count
session rule count
unsafe dynamic/session rule count
regex rule count
compiled regex complexity risk
DNR rule ID ranges and collisions
DNR rule priorities and action ordering
getAvailableStaticRuleCount usage if ruleset capacity can be exceeded
getMatchedRules usage and permission requirements
declarativeNetRequestFeedback permission justification if used
redirect rules that target extension resources
web_accessible_resources entries needed for redirect rules
file:// access behavior
incognito behavior: spanning, split, or not_allowed
manual user-grant requirement for incognito/file URL access
<all_urls> and broad match-pattern justification
localhost/IP/development match patterns removed from production unless justified
unsupported top-level-domain match patterns absent
minimum supported Chrome version documented for users and reviewers
```

Do not increase broad host permissions merely to simplify tests. If `<all_urls>` or equivalent broad host access is necessary for content blocking, document why a narrower scope would break the stated single purpose and how privacy is still protected.

If incognito access is supported, document exactly what data is shared between normal and incognito contexts and how logger/settings behavior avoids misleading users. If incognito support is not supported, set `incognito: "not_allowed"` or document default behavior and provide clear user-facing limitations.

If file URL access is supported, document that Chrome requires users to manually enable access and that the extension must not imply file URL blocking works automatically.

If DNR rule counts approach platform limits, create a ruleset-capacity strategy instead of blindly adding rules. Prefer deterministic ruleset splitting, capacity checks, and a documented fallback.

## Evidence schema

```json
{
  "manifestMinimumChromeVersionAudited": true,
  "minimumChromeVersionRecommendation": "",
  "apiCompatibilityMatrixExists": true,
  "dnrStaticRulesetCount": 0,
  "dnrEnabledStaticRulesetCount": 0,
  "dnrStaticRuleCount": 0,
  "dnrDynamicRuleCount": 0,
  "dnrSessionRuleCount": 0,
  "dnrRegexRuleCount": 0,
  "dnrRuleLimitsDocumented": true,
  "getAvailableStaticRuleCountStrategyExists": true,
  "getMatchedRulesPermissionJustifiedOrAbsent": true,
  "dnrRedirectResourcesAreWebAccessible": true,
  "broadMatchPatternsJustified": true,
  "localhostOrDevelopmentPatternsAbsentFromProduction": true,
  "incognitoBehaviorDocumented": true,
  "fileUrlBehaviorDocumented": true,
  "userManualGrantDisclosedForIncognitoOrFileUrls": true,
  "unsupportedTopLevelDomainPatternsAbsent": true,
  "blockers": [],
  "warnings": [],
  "pass": true
}
```

## Acceptance

```text
The project has a documented Chrome-version/API compatibility matrix.
The manifest minimum_chrome_version is either absent with justification or present with a clear reason.
DNR rule limits and quota behavior are audited before broad filter-list import/release.
DNR redirect rules do not target non-web-accessible extension resources.
Broad match patterns are justified by the content-blocking purpose and privacy policy.
Incognito and file URL behavior are explicit, truthful, and not overclaimed.
Development-only match patterns are removed from production or explicitly gated.
```

## Stop conditions

```text
Stop and report blocked if DNR rules cannot load within platform limits.
Stop and report blocked if a required API is only available in a newer Chrome version and minimum_chrome_version is not updated or documented.
Stop and report blocked if broad host access is used but the privacy/listing explanation does not match actual behavior.
Stop and report blocked if the extension claims incognito or file URL support without Chrome user-grant handling and testing.
```

---


# B29 — CSP, service-worker lifecycle, storage, offscreen-document, HTTPS, and content-script execution-world readiness gate

## Goal

Make sure the extension is not only Web Store policy-ready, but also technically robust under Manifest V3’s execution model.

This phase catches a remaining class of Featured-readiness problems that may not show up in listing/policy audits: invalid or risky content security policy values, service-worker lifecycle bugs, state lost across worker shutdowns, timer misuse, unbounded keepalive behavior, unsafe storage exposure, unjustified offscreen documents, HTTP network requests, and content-script execution-world/frame-matching risks.

## Required files

```text
docs/chrome-web-store/csp-service-worker-storage-readiness.md
docs/chrome-web-store/offscreen-and-content-script-lifecycle-policy.md
tools/cws/audit-csp-serviceworker-storage.mjs
artifacts/cws/csp-serviceworker-storage-readiness.json
```

## Implementation instructions

Audit the extension for:

```text
manifest content_security_policy.extension_pages
manifest content_security_policy.sandbox
script-src values
object-src values
worker-src values if present
unsafe-eval or unsafe-inline usage
wasm-unsafe-eval usage and justification
localhost or 127.0.0.1 CSP allowances in production builds
remote script/style/font/resource assumptions
service worker top-level event listener registration
service worker reliance on global variables for persistent state
service worker use of window, document, DOMParser, localStorage, or other unavailable DOM/Web Storage APIs
XMLHttpRequest use in service worker
setTimeout / setInterval use for long-running background behavior
alarms use for periodic work
intentional or accidental service-worker keepalive loops
chrome.storage.local/session/sync/managed usage
storage quota handling and getBytesInUse strategy
storage.sync exposure and sensitive-data avoidance
storage.session/local/sync setAccessLevel decisions
settings/custom rules/logger data deletion controls
offscreen document usage, reasons, lifecycle, cleanup, and message boundaries
HTTP network requests from extension contexts
HTTPS-only policy for any permitted network access
content script run_at choices
content script world choices: ISOLATED vs MAIN
match_about_blank and match_origin_as_fallback usage
all_frames behavior
programmatic scripting injection guards
MAIN-world scriptlet injection scope and reviewer explanation
```

## Hard rules

```text
no unsafe-eval in extension_pages CSP
no unsafe-inline in extension_pages CSP
no remote script execution through CSP or code paths
no localhost/127.0.0.1 CSP allowances in production packages
no service-worker code relying on persistent globals for durable state
no service-worker DOM/window/localStorage/XMLHttpRequest reliance
no background long-running timer that should be an alarm
no intentional service-worker keepalive loop unless explicitly justified and human-approved
no sensitive logger/browsing data in storage.sync by default
no storage area exposed to content scripts unless explicitly justified
no offscreen document unless a real DOM-only task requires it
no offscreen document left open indefinitely without justification
no HTTP request unless explicitly justified as test-only and excluded from production
no MAIN-world content/scriptlet injection unless required, site-scoped, logged, and reviewed
```

## Evidence schema

```json
{
  "contentSecurityPolicyAudited": true,
  "extensionPagesCspSafe": true,
  "sandboxCspReviewedIfPresent": true,
  "unsafeEvalAbsent": true,
  "unsafeInlineAbsent": true,
  "wasmUnsafeEvalJustifiedOrAbsent": true,
  "localhostCspAbsentFromProduction": true,
  "serviceWorkerLifecycleAudited": true,
  "topLevelEventListenersAudited": true,
  "persistentStateNotStoredOnlyInGlobals": true,
  "serviceWorkerDomApisAbsent": true,
  "serviceWorkerXmlHttpRequestAbsent": true,
  "longTimersReplacedOrJustifiedWithAlarms": true,
  "keepaliveLoopRisk": false,
  "storageAreasInventoried": true,
  "storageQuotaStrategyExists": true,
  "sensitiveDataAvoidsSyncByDefault": true,
  "storageAccessLevelsReviewed": true,
  "clearDataControlsDocumented": true,
  "offscreenDocumentsAbsentOrJustified": true,
  "offscreenLifecycleDocumented": true,
  "httpRequestsAbsentFromProduction": true,
  "httpsOnlyNetworkPolicyExists": true,
  "contentScriptWorldsAudited": true,
  "mainWorldInjectionJustifiedOrAbsent": true,
  "frameMatchingOptionsAudited": true,
  "programmaticInjectionGuardsPresent": true,
  "blockers": [],
  "warnings": [],
  "pass": true
}
```

## Acceptance

```text
The production manifest has a safe MV3 content security policy.
The service worker is resilient to shutdown/restart and does not rely on page-like DOM APIs.
Periodic work uses alarms or event-driven behavior rather than fragile long timers.
Storage choices match sensitivity, quota, and user-deletion requirements.
Offscreen documents are absent unless justified by a real DOM-only use case.
Any content-script MAIN-world or frame-fallback behavior is scoped, documented, and tested.
Production code uses HTTPS-only network access where network access exists.
```

## Stop conditions

```text
Stop and report blocked if extension_pages CSP permits remote code, unsafe-eval, or unsafe-inline.
Stop and report blocked if production package includes localhost/127.0.0.1 CSP allowances.
Stop and report blocked if the service worker depends on globals for critical persistent state.
Stop and report blocked if logger/rules/settings data can be lost or leaked because storage areas are misused.
Stop and report blocked if offscreen documents are used as hidden persistent pages without clear justification.
Stop and report blocked if MAIN-world injection is broad, undocumented, or not needed for the blocker’s single purpose.
```

---

# B30 — True final expanded badge-readiness gate

## Goal

Produce the final readiness score only after B0-B29 have been generated, audited, and represented.

## Required files

```text
tools/cws/score-featured-readiness-final.mjs
tools/cws/audit-featured-nomination-eligibility.mjs
artifacts/cws/featured-readiness-score-final.json
artifacts/cws/featured-nomination-eligibility.json
docs/chrome-web-store/featured-nomination-eligibility.md
docs/chrome-web-store/featured-readiness-final-report-complete.md
```

## Final scoring categories

```json
{
  "officialSourceSnapshot": 0,
  "singlePurpose": 0,
  "brandingIpTrust": 0,
  "mv3PackageCompliance": 0,
  "remoteCodeSafety": 0,
  "codeReadability": 0,
  "permissionMinimization": 0,
  "privacyLimitedUse": 0,
  "securityBoundaries": 0,
  "webAccessibleResources": 0,
  "adBlockingSafety": 0,
  "performanceReliability": 0,
  "uxAccessibility": 0,
  "listingAccuracy": 0,
  "assetsScreenshots": 0,
  "reviewerSubmissionPackage": 0,
  "ciEvidence": 0,
  "publisherTrust": 0,
  "dashboardCompleteness": 0,
  "supportFeedbackReadiness": 0,
  "storeMetricsReadiness": 0,
  "releaseLifecycle": 0,
  "legalAccountGovernance": 0,
  "marketingInstallFunnel": 0,
  "supplyChainPackageIntegrity": 0,
  "negativePolicyTrapSafety": 0,
  "currentChromePlatformChangeGovernance": 0,
  "dnrApiIncognitoFileAccessCompatibility": 0,
  "cspServiceWorkerStorageLifecycle": 0,
  "featuredNominationEligibility": 0
}
```

## Final critical blockers

```text
any B0-B29 phase missing
any required artifact missing
any JSON artifact invalid
any pass=false critical blocker not explained
remote executable code
obfuscated or unreviewable code
unjustified broad permissions
inaccurate privacy practices fields
unpublished or missing privacy policy when user data is handled
web browsing activity collected remotely without a prominent user-facing feature and disclosure
unsupported or deceptive security/privacy/antivirus claims
fake ad impressions/clicks/beacons/viewability/conversions
brand impersonation or likely user confusion with uBlock Origin or Google/Chrome
Chrome settings/search/homepage/new-tab override without single-purpose justification
notification spam or message-sending on behalf of users
paywall/login/DRM/copyright-media bypass behavior
keyword spam or manipulative reviews/ratings/installs
missing support path or unmonitored publisher contact
package cannot be traced to source
high-risk dependency/license/secrets issue
unresolved human-only legal/trader/account item incorrectly marked complete
not actually an extension item
publisher does not own the nominated extension
no English language support
item is not published and public before nomination
active Chrome Web Store policy violation exists
core features require additional credentials or payments for normal user access
```

## Evidence schema

```json
{
  "allPhasesB0ToB29Represented": true,
  "allRequiredDocsPresent": true,
  "allRequiredToolsPresent": true,
  "allRequiredArtifactsPresent": true,
  "allJsonArtifactsValid": true,
  "humanOnlyItemsSeparated": true,
  "featuredNominationEligibilityPass": true,
  "extensionItem": true,
  "publisherOwnsExtension": true,
  "englishSupportExists": true,
  "publishedAndPublicBeforeNomination": true,
  "noActivePolicyViolations": true,
  "coreFeaturesAccessibleWithoutCredentialsOrPayments": true,
  "overallScore": 0,
  "criticalBlockers": [],
  "warnings": [],
  "humanActionRequired": [],
  "notApplicableItems": [],
  "badgeGuaranteeClaimed": false,
  "pass": false
}
```

## Acceptance

```text
The final report makes it impossible to confuse badge-readiness with a guaranteed badge.
The final score cannot be 100 unless all B0-B29 gates are passed, correctly marked not applicable, or blocked with transparent human-only action items.
The final score cannot be 100 unless Featured nomination eligibility is explicitly checked: extension item, publisher ownership, English language support, published/public status, no active policy violations, and core features accessible without extra credentials or payments.
```

---
# FINAL REQUIRED FILE TREE

The coding agent should create or update as many of these as appropriate:

```text
docs/chrome-web-store/
  official-source-index.md
  chrome-platform-change-watch.md
  featured-nomination-eligibility.md
  product-purpose.md
  branding-ip-risk-audit.md
  name-options.md
  mv3-package-readiness.md
  remote-code-policy.md
  code-readability.md
  permissions-justification.md
  privacy-policy-draft.md
  privacy-practices.md
  limited-use-disclosure.md
  data-inventory.md
  security-boundary-review.md
  web-accessible-resources-audit.md
  ad-blocking-safety-policy.md
  performance-budget.md
  ux-onboarding-review.md
  accessibility-review.md
  listing-title-options.md
  listing-summary.md
  listing-description.md
  listing-permissions-disclosure.md
  listing-privacy-disclosure.md
  listing-screenshot-plan.md
  listing-review-checklist.md
  asset-specification.md
  screenshot-capture-checklist.md
  reviewer-test-instructions.md
  release-submission-checklist.md
  featured-readiness-final-report.md
  publisher-account-readiness.md
  verified-publisher-readiness.md
  developer-reputation-risk.md
  dashboard-field-map.md
  category-and-content-rating.md
  payment-and-distribution.md
  support-and-feedback-plan.md
  review-response-policy.md
  abuse-report-handling.md
  store-metrics-monitoring.md
  post-launch-quality-plan.md
  release-channel-plan.md
  trusted-tester-plan.md
  update-and-rollback-plan.md
  periodic-review-readiness.md
  legal-and-developer-agreement-readiness.md
  trader-disclosure-readiness.md
  ownership-and-access-governance.md
  violation-appeal-and-enforcement-playbook.md
  off-store-marketing-and-install-funnel-policy.md
  anti-spam-and-keyword-policy.md
  localization-plan.md
  analytics-governance.md
  supply-chain-and-dependency-audit.md
  third-party-license-inventory.md
  reproducible-build-and-package-integrity.md
  vulnerability-management.md
  negative-policy-trap-audit.md
  settings-overrides-policy.md
  notifications-and-user-messaging-policy.md
  dnr-quota-and-rule-limit-readiness.md
  api-compatibility-and-minimum-chrome-version.md
  incognito-file-url-and-match-pattern-policy.md
  csp-service-worker-storage-readiness.md
  offscreen-and-content-script-lifecycle-policy.md
  minimum-functionality-and-redirection-policy.md
  unauthorized-access-and-copyright-boundary.md
  featured-readiness-final-report-expanded.md
  featured-readiness-final-report-complete.md

tools/cws/
  build-source-snapshot.mjs
  audit-chrome-platform-change-readiness.mjs
  audit-featured-nomination-eligibility.mjs
  audit-single-purpose.mjs
  audit-branding-risk.mjs
  audit-mv3-package.mjs
  audit-remote-code.mjs
  audit-code-readability.mjs
  audit-permissions.mjs
  audit-user-data.mjs
  audit-security-boundaries.mjs
  audit-web-accessible-resources.mjs
  audit-ad-safety.mjs
  measure-performance-budget.mjs
  audit-ux-readiness.mjs
  audit-listing-copy.mjs
  audit-store-assets.mjs
  build-review-package.mjs
  run-featured-readiness-audit.mjs
  score-featured-readiness.mjs
  audit-publisher-readiness.mjs
  audit-dashboard-fields.mjs
  audit-support-readiness.mjs
  audit-store-metrics-readiness.mjs
  audit-release-lifecycle.mjs
  score-featured-readiness-expanded.mjs
  audit-legal-account-governance.mjs
  audit-marketing-install-funnel.mjs
  audit-supply-chain.mjs
  audit-package-integrity.mjs
  audit-negative-policy-traps.mjs
  audit-dnr-api-compatibility.mjs
  audit-csp-serviceworker-storage.mjs
  score-featured-readiness-final.mjs

artifacts/cws/
  source-snapshot.json
  chrome-platform-change-readiness.json
  featured-nomination-eligibility.json
  single-purpose-audit.json
  branding-risk.json
  mv3-package-audit.json
  remote-code-audit.json
  code-readability-audit.json
  permissions-audit.json
  user-data-audit.json
  security-boundary-audit.json
  war-audit.json
  ad-safety-audit.json
  performance-budget.json
  ux-readiness.json
  listing-audit.json
  store-assets-audit.json
  review-package.json
  featured-readiness-score.json
  publisher-readiness.json
  dashboard-fields-audit.json
  support-readiness.json
  store-metrics-readiness.json
  release-lifecycle.json
  featured-readiness-score-expanded.json
  legal-account-governance.json
  marketing-install-funnel.json
  supply-chain-audit.json
  package-integrity.json
  negative-policy-traps.json
  dnr-api-compatibility-readiness.json
  csp-serviceworker-storage-readiness.json
  featured-readiness-score-final.json

tests/e2e/
  performance-budget.spec.mjs

.github/workflows/
  featured-readiness.yml

assets/chrome-web-store/
  README.md
```

---

# FINAL REPORT TEMPLATE

At the end, the coding agent must produce this summary:

```text
Chrome Web Store Featured Badge Readiness Summary

Repository:
Commit:
Date:

Important:
This does not guarantee the Featured badge.
Chrome manually evaluates extensions.

Overall readiness score:
Pass:
Critical blockers:

Category scores:
- Policy compliance:
- MV3 compliance:
- Remote-code safety:
- Permission minimization:
- Privacy/user data:
- Security boundaries:
- Ad-blocking safety:
- Performance/reliability:
- UX/accessibility:
- Listing accuracy:
- Branding/trust:
- Review package:
- Publisher/legal/account governance:
- Marketing/install-funnel compliance:
- Supply-chain/package integrity:
- Negative-policy trap safety:
- Current Chrome platform-change governance:
- DNR/API/incognito/file-access compatibility:
- CSP/service-worker/storage/offscreen/content-script lifecycle:
- Featured nomination eligibility:

Files changed:

Commands run:

Evidence artifacts:

Remaining blockers:

Human/legal review required:
- public product name
- icon/brand identity
- privacy policy final approval
- support URL/contact
- final screenshots
- final Chrome Web Store submission text
- developer account setup and verification
- official URL verification
- dashboard privacy fields
- category/content rating/payment/distribution fields
- trusted tester list
- support and security-report channels
- staged rollout and rollback approval
- trader/non-trader status and verification
- developer agreement/legal eligibility confirmation
- publisher ownership and account recovery setup
- external website/install-funnel approval
- localization approval if non-English listings are used
- Google Analytics decision if listing analytics are enabled
- third-party license and dependency risk approval
- minimum supported Chrome version approval
- incognito and file URL support/disclosure approval
- broad host permission and DNR capacity approval
- CSP / WebAssembly / offscreen document / storage-sync / MAIN-world injection approval if used
- Featured nomination eligibility confirmation: publisher owns extension, English support exists, item is public/published, no active violations, and core features are accessible without additional credentials or payments

Recommended next action:
Continue product implementation through P0-P16 until runtime, blocking, logger, cosmetics, scriptlets, UI, privacy, performance, CI, and docs are complete; then re-run P17 Featured Readiness audit.
```

---

# ONE-SHOT EXECUTION PROMPT

Use this if the LLM coder accepts only one prompt:

```text
Implement a complete Chrome Web Store Featured Badge readiness layer for Astrocytech/uBlockResurrected.

Create docs, tools, tests, CI, and JSON artifacts that audit the extension against official Chrome Web Store Featured, policy, MV3, privacy, listing, security, performance, and UX requirements.

Do not claim the badge is guaranteed.
Do not use unsupported marketing claims.
Do not add remote executable code.
Do not add unrelated features.
Do not fake ad impressions, clicks, beacons, conversions, or viewability.
Do not bypass paywalls, login restrictions, DRM, or copyrighted-media access controls.

Implement phases B0-B30 from this prompt:
B0 official source snapshot
B1 single-purpose product definition
B2 branding/impersonation risk
B3 MV3 package compliance
B4 remote hosted code and dynamic execution audit
B5 code readability/non-obfuscation audit
B6 permission minimization
B7 user data/privacy/Limited Use readiness
B8 security boundary audit
B9 web-accessible resources minimization
B10 ad-blocking safety audit
B11 performance/reliability budget
B12 UX/onboarding/accessibility review
B13 Chrome Web Store listing package
B14 screenshots/icons/promotional assets checklist
B15 reviewer instructions/submission package
B16 CI gate/final badge-readiness score
B17 publisher/developer account and trust readiness
B18 dashboard fields, category, content rating, payment, and distribution readiness
B19 support, feedback, review-response, and trust operations
B20 store metrics and post-launch quality monitoring
B21 production release, trusted testing, staged rollout, update, and rollback readiness
B22 expanded score-model gate
B23 legal, trader disclosure, ownership, and enforcement-readiness gate
B24 off-store marketing, install-funnel, anti-spam, localization, and analytics governance
B25 supply-chain, dependency, license, vulnerability, and reproducible-package audit
B26 negative-policy trap audit for settings overrides, notifications, redirection, minimum functionality, and unauthorized-access boundaries
B27 current Chrome platform-change governance and compatibility watch
B28 Chrome API compatibility, DNR quota, incognito/file-access, match-pattern, and userScripts readiness gate
B29 CSP, service-worker lifecycle, storage, offscreen-document, HTTPS, content-script execution-world, and current Chrome test-loading readiness gate
B30 true final expanded badge-readiness gate, including verified uploads, reviewer-credential readiness, current Chrome platform-change evidence, and explicit Featured nomination eligibility

Every phase must produce docs and JSON evidence.
Every JSON artifact must include pass boolean, blockers, warnings where appropriate.
Add npm script cws:featured-readiness if package.json exists.
Add GitHub Actions workflow if .github exists or create it if appropriate.
Generate artifacts/cws/featured-readiness-score.json and docs/chrome-web-store/featured-readiness-final-report.md.

Final output:
- files changed
- commands run
- evidence artifacts
- final readiness score
- critical blockers
- human decisions needed
- legal/trader/account blockers
- acquisition-funnel/listing-spam blockers
- supply-chain/package-integrity blockers
- negative-policy trap blockers
- settings/notifications/redirection/minimum-functionality/unauthorized-access blockers
- CSP/service-worker/storage/offscreen/content-script lifecycle blockers
- Featured nomination eligibility blockers: ownership, English support, public/published status, active violations, and gated core features

Continue through all phases unless blocked by a real safety, legal, or policy issue.
```
