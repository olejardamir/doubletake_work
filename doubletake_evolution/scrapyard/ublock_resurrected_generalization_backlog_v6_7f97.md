# uBlock Resurrected Generalization Backlog v6

Updated: 2026-06-28

Commit reviewed for v5: `ca353def57eacc103871afe919bc845b87502ce2`

Commit reviewed for v6: `7f97a6703b1b6edc6d7da6bda6ba39d061b07bff`

## Purpose

This document is a living development backlog for moving uBlock Resurrected away from site-specific patching and toward general, policy-driven behavior.

The target is not:

```txt
Add grok.com, chatgpt.com, suno.com, yandex.com, etc. to more exception lists.
```

The target is:

```txt
Classify every filtering action by risk.
Only run high-risk layers when policy and evidence allow it.
Make unknown complex apps safe by default.
Use named sites only as regression fixtures, not as the main safety mechanism.
```

---

## Priority model

Use this ordering when deciding what to implement first:

```txt
P0 = small change, big safety win; do first
P1 = medium change, strong architectural value
P2 = larger architecture shift
P3 = cleanup, long-term hardening, smaller wins
```

For every item, add an acceptance check. If there is no acceptance check, the change is not done.

---

## Generalization rule

A fix is generalized only if it satisfies all of these:

```txt
1. It removes or reduces the need for a new hostname exception.
2. It uses a central policy, central classifier, central utility, or central registry.
3. It has an automated invariant check.
4. It has at least one synthetic regression fixture where possible.
5. It fails safe when uncertain.
```

A fix is still patch-like if it mainly does this:

```txt
Add one more host to exclude_matches.
Add one more host to SENSITIVE_HOSTS.
Add one more allow rule for a broken site.
Add one more one-off sanitizer for a specific site's header.
```

Those are acceptable only as emergency hotfixes or regression fixtures, not as the architecture.

## v3 pass: what was added

This pass adds non-repeating backlog items around the extension control plane:

```txt
message contracts
remote fetch authority
frame and about:blank policy inheritance
webRequest/instrumentation activation
trusted-site allow semantics
permission/capability registry
filter parser reporting
per-tab lifecycle cleanup
policy caching and invalidation
CI gates for bypass paths
```

These items are important because many breakages do not come from one bad block rule. They come from runtime surfaces that can act before policy is resolved, accept loosely shaped messages, run in all frames, keep stale per-tab state, or fetch/execute behavior through a path not covered by the main policy model.

---

## v4 rating and pass summary

Current v3 rating: **8.84 / 10.00**.

Why it is strong:

```txt
- It already identifies the main architectural risk: global behavior plus host exceptions.
- It prioritizes small high-impact fixes before large rewrites.
- It covers DNR, cosmetics, video, smart rules, host access, runtime policy, messaging, and CI.
- It includes acceptance checks rather than only design ideas.
```

Why it is not 10.00 yet:

```txt
- Some items still describe broad direction rather than exact implementation primitives.
- The backlog needs more regression-prevention checks around schemas, constants, unsafe regex, storage shape, generated files, and runtime shutdown.
- It needs clearer small changes that make future one-off patches harder to add accidentally.
- It needs more “single registry” items so policy, manifests, scripts, checks, and docs do not drift.
```

This v4 pass adds non-repeating items focused on engineering generalization:

```txt
runtime schema validation
centralized constants and storage keys
safe regex compilation
MAIN-world injection policy
structured errors
layer shutdown contracts
extension-owned DOM markers
release artifact gates
privacy-preserving debug mode
test matrix generation
manifest/content-script drift checks
action reversibility metadata
```

## Current code pattern to move away from

The codebase already improved several concrete breakages, but the structure is still partly exception-based and layer-specific.

Observed patterns:

- `manifest.json` globally injects the main content-script stack on HTTP/HTTPS pages, then excludes specific sensitive apps.
- `manifest.json` globally injects the generic video engine on HTTP/HTTPS pages, then excludes specific sensitive apps.
- `breakage-guard.ts` still uses a `SENSITIVE_HOSTS` negative list.
- Safety tools also contain hardcoded sensitive-site lists, and those lists are not guaranteed to be identical.
- `policy-resolver.js` exists, but it currently returns broad booleans, not a layer-level risk policy.
- DNR fallback still installs broad block rules when compilation fails.
- Generic video adapters still have wildcard host matching, even though mutation is now high-confidence gated.
- High-risk interceptor code exists for fetch/XHR response mutation and should be policy-gated even if currently inactive.
- Some source checks point at prototype files rather than the canonical runtime path.

The next phase should generalize these into central policy, central risk classification, central activation contracts, shared utilities, and behavior-based regression tests.

---

# P0 — Small changes with big wins

## P0.1 Replace fallback block mode with degraded allow mode

### Problem

When no filter-list rules compile, the service worker still installs fallback DNR block rules. These fallback rules include high-risk resource types:

```txt
main_frame
sub_frame
script
xmlhttprequest
websocket
```

A compile failure should not create a more aggressive blocker. Failure mode must become safer, not more destructive.

### Files

```txt
platform/chromium/js/sw.js
```

### Generalized fix

Replace fallback blocking with degraded allow mode.

```js
async function enterDegradedAllowMode(reason) {
    console.warn(`[uBR] Entering degraded allow mode: ${reason}`);

    await chrome.declarativeNetRequest.updateDynamicRules({
        removeRuleIds: (await chrome.declarativeNetRequest.getDynamicRules()).map(r => r.id),
        addRules: [],
    });

    await chrome.declarativeNetRequest.updateSessionRules({
        removeRuleIds: (await chrome.declarativeNetRequest.getSessionRules()).map(r => r.id),
        addRules: [],
    });

    tabUnprocessedRequest.clear();
    dnrSyncCompleted = true;
    runtimeHealth.dnrDynamicRulesReady = false;
    runtimeHealth.filterListsReady = false;
    runtimeHealth.degradedMode = true;
    runtimeHealth.lastError = reason;

    return 0;
}
```

Replace every `return await installFallbackRules()` failure path with `enterDegradedAllowMode(...)`.

### Acceptance check

Production check fails if:

```txt
installFallbackRules exists in canonical sw.js
no-rules path installs fallback block rules
rule-install failure path installs fallback block rules
fallback rules include main_frame/script/xmlhttprequest/websocket
```

---

## P0.2 Fix DNR deduplication to include the full condition

### Problem

The compiler deduplicates network rules using only:

```txt
urlFilter | resourceTypes | action
```

That can drop important fields such as:

```txt
initiatorDomains
excludedInitiatorDomains
requestDomains
excludedRequestDomains
domainType
```

Two rules can share the same URL filter and resource type while having different initiator restrictions. Deduping them as identical can silently remove safety restrictions or exceptions.

### Files

```txt
platform/chromium/js/sw.js
```

### Generalized fix

Build the DNR rule first, then dedupe using normalized action and full condition.

```js
function normalizeConditionForKey(condition) {
    const out = { ...(condition || {}) };

    for (const key of [
        "resourceTypes",
        "initiatorDomains",
        "excludedInitiatorDomains",
        "requestDomains",
        "excludedRequestDomains",
    ]) {
        if (Array.isArray(out[key])) {
            out[key] = [...out[key]].sort();
        }
    }

    return out;
}

function stableDnrRuleKey(rule) {
    return JSON.stringify({
        action: rule.action,
        condition: normalizeConditionForKey(rule.condition),
    });
}
```

### Acceptance check

Add a unit test with two rules that share `urlFilter` and `resourceTypes`, but differ by `initiatorDomains`. Both must survive.

---

## P0.3 Add high-risk DNR rule classification before install

### Problem

Domain priority is not safety. A domain can be useful to block for ads but dangerous to block globally as `script`, `xmlhttprequest`, `websocket`, or `main_frame`.

### Files

```txt
platform/chromium/js/sw.js
```

### Generalized fix

Add a mandatory install gate:

```js
const HIGH_RISK_RESOURCE_TYPES = new Set([
    "main_frame",
    "script",
    "xmlhttprequest",
    "websocket",
]);

function classifyDnrRuleRisk(rule) {
    const condition = rule.condition || {};
    const types = new Set(condition.resourceTypes || []);

    if (types.has("main_frame")) return "high";
    if (types.has("script")) return "high";
    if (types.has("xmlhttprequest")) return "high";
    if (types.has("websocket")) return "high";
    if (condition.domainType === "firstParty") return "high";

    if (!condition.initiatorDomains && !condition.requestDomains) {
        return "medium";
    }

    return "safe";
}

function isSpecificEnoughForHighRisk(rule) {
    const condition = rule.condition || {};
    return (
        Array.isArray(condition.initiatorDomains) && condition.initiatorDomains.length > 0 ||
        Array.isArray(condition.requestDomains) && condition.requestDomains.length > 0 ||
        rule.action?.type === "allow" ||
        rule.action?.type === "allowAllRequests"
    );
}

function shouldInstallCompiledDnrRule(rule) {
    if (rule.action?.type !== "block") return true;
    const risk = classifyDnrRuleRisk(rule);
    if (risk === "high") return isSpecificEnoughForHighRisk(rule);
    return true;
}
```

### Acceptance check

Fixture rules:

```txt
||example-sdk.com^$script
||example-sdk.com^$xmlhttprequest
||example-sdk.com^$websocket
||example-sdk.com^$image
||example-sdk.com^$script,domain=known-video-site.example
```

Expected:

```txt
script/xhr/websocket without specificity = rejected
image = allowed
script with initiatorDomains = allowed
```

---

## P0.4 Make `scriptletInjectable` and `scriptletWillInject` policy-derived

### Problem

The content-script parameter response currently treats scriptlets as generally available. That is too broad. Scriptlets and main-world hooks are high-risk and should be disabled unless policy explicitly allows them.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
```

### Generalized fix

```js
scriptletInjectable: policy.scriptletsEnabled === true,
scriptletWillInject: policy.scriptletsEnabled === true && hasScriptletsForHostname(hostname),
```

For now:

```js
function hasScriptletsForHostname(_hostname) {
    return false;
}
```

### Acceptance check

```txt
trusted site -> scriptletInjectable false
no-scripting switch enabled -> scriptletInjectable false
normal site without scriptlet rules -> scriptletWillInject false
```

---

## P0.5 Add `getPagePolicy` and make it the first runtime gate

### Problem

`resolvePagePolicy()` exists, but content modules still mostly start first and ask for parameters later. The page policy should be the first authority every content runtime consults.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
src/js/smart-content.ts
src/js/video-adblock/video-engine.ts
platform/chromium/js/contentscript.js
```

### Generalized fix

Add a content-script message:

```js
case "getPagePolicy": {
    const hostname = msg.hostname || hostnameFromURL(msg.url || "");
    const url = msg.url || "";

    return resolvePagePolicy({
        url,
        hostname,
        trusted: isURLTrusted(url),
        netFilteringEnabled: getEffectiveNetFiltering(hostname),
        hostnameSwitches: getEffectiveHostnameSwitches(hostname),
        pageSignals: msg.pageSignals || {},
    });
}
```

Every runtime must ask for policy before installing:

```txt
MutationObserver
CSS injection
smart cosmetic runtime
video scanner
fetch/XHR hooks
scriptlets
main-world hooks
first-party ad detector
```

### Acceptance check

Production guard fails if a globally injected content script installs observers, hooks, video scanning, or CSS before calling `getPagePolicy`.

---

## P0.6 Canonicalize sensitive/regression fixtures

### Problem

Sensitive/app-like host lists are duplicated across runtime and tools. Named sites should test general safety. They should not be the safety mechanism.

### Files

```txt
src/js/video-adblock/breakage-guard.ts
tools/check-video-adblock-safety.mjs
tools/check-sensitive-site-dnr-regression.mjs
platform/chromium/manifest.json
```

### Generalized fix

Create one regression fixture file:

```txt
tests/fixtures/site-profiles/app-like-sites.json
```

Example:

```json
{
  "appLikeSites": [
    "chatgpt.com",
    "grok.com",
    "suno.com"
  ],
  "videoSites": [
    "youtube.com",
    "yandex.ru",
    "vkvideo.ru"
  ],
  "authSensitiveSites": [],
  "regressionOnly": true
}
```

### Acceptance check

No separate hardcoded `SENSITIVE_HOSTS` arrays in tools. Runtime may only use site lists as temporary compatibility shims or profile hints, not as the primary safety decision.

---

## P0.7 Expand `check-production-rule-surface` into invariant checks

### Problem

The production-surface check catches known old regressions, but it does not yet enforce the general safety model.

### Files

```txt
tools/check-production-rule-surface.mjs
```

### Add invariants

```txt
No fallback broad block mode.
No global heavyweight content script without policy bootstrap.
No wildcard video adapter may mutate unknown sites.
No generic cosmetic surveyor may run on app-like pages unless policy allows it.
No broad high-risk DNR block rule may install without specificity.
No duplicated sensitive-host constants across tools.
No unconditional scriptletInjectable/scriptletWillInject true.
No response mutation hooks without explicit policy gate.
```

### Acceptance check

Fail on these patterns unless explicitly gated:

```txt
installFallbackRules
SENSITIVE_HOSTS = [
domains: ["*"] with mutation actions
scriptletInjectable: true
scriptletWillInject: true
self.fetch =
XMLHttpRequest.prototype.open =
Object.defineProperty(this, "responseText"
```

---

## P0.8 Fix host-access checks to target the canonical service worker

### Problem

`host-access.js` exists, but the guard script checks `src/js/sw.js`, while the canonical runtime service worker is `platform/chromium/js/sw.js`. This can make the check pass/fail against the wrong file.

### Files

```txt
tools/check-host-access.mjs
platform/chromium/js/host-access.js
platform/chromium/js/sw.js
```

### Generalized fix

Change the check target to the canonical runtime:

```js
const SW_PATH = resolve(REPO_ROOT, "platform/chromium/js/sw.js");
```

Then import/use `resolveHostAccess()` from the canonical service worker or explicitly document why not.

### Why this is a small big win

It prevents the repo from proving safety against a file that is not loaded by the manifest.

### Acceptance check

`check-host-access` must fail if canonical `platform/chromium/js/sw.js` does not use host-access or an equivalent site-access gate.

---

## P0.9 Add a runtime layer registry

### Problem

The code has many layers that can affect a page, but they are not registered in one place with risk and activation rules.

### Files

```txt
platform/chromium/js/policy-resolver.js
platform/chromium/js/sw.js
src/js/runtime-layer-registry.ts
```

### Generalized fix

Create a central registry:

```ts
export const RUNTIME_LAYERS = {
    networkDnr: {
        risk: "medium",
        requiresPolicy: "network.mode",
        canRunGlobally: true,
    },
    genericCosmetic: {
        risk: "high",
        requiresPolicy: "cosmetic.generic",
        canRunGlobally: false,
    },
    proceduralCosmetic: {
        risk: "high",
        requiresPolicy: "cosmetic.procedural",
        canRunGlobally: false,
    },
    smartCosmetic: {
        risk: "high",
        requiresPolicy: "cosmetic.smart",
        canRunGlobally: false,
    },
    genericVideo: {
        risk: "high",
        requiresPolicy: "video.allowMutation",
        canRunGlobally: false,
    },
    mainWorldHooks: {
        risk: "critical",
        requiresPolicy: "scriptlets.mainWorldHooks",
        canRunGlobally: false,
    },
    firstPartyResponseMutation: {
        risk: "critical",
        requiresPolicy: "network.firstPartyResponseMutation",
        canRunGlobally: false,
    },
};
```

### Acceptance check

Every page-affecting runtime must have one registry entry. Production guard fails if a content module is globally injected but absent from the registry.

---

## P0.10 Stop using `@ts-nocheck` in high-risk page-mutation modules

### Problem

High-risk modules that mutate network responses or scan/mutate first-party DOM use `@ts-nocheck`. These are exactly the files where type safety matters most.

### Files

```txt
src/js/contentscript/universal-ad-interceptor.ts
src/js/contentscript/first-party-ad-detector.ts
```

### Generalized fix

Remove `@ts-nocheck` from high-risk modules and define explicit interfaces:

```ts
type RuntimePolicy = {
    mainWorldHooks: boolean;
    firstPartyResponseMutation: boolean;
    firstPartyDomDetection: boolean;
};
```

Then type the activation functions and state objects.

### Acceptance check

A check script fails if `@ts-nocheck` appears in:

```txt
src/js/contentscript/*interceptor*.ts
src/js/contentscript/*detector*.ts
src/js/video-adblock/*.ts
src/core/smart-cosmetic/*.ts
```

Allow exceptions only with a dated suppression comment.

---

## P0.11 Gate first-party ad detector creation behind policy

### Problem

The first-party ad detector currently performs broad DOM scanning and adds marker classes based on generic ID/class/data-attribute patterns. Even if exposed through a factory, creating it starts scanning immediately.

### Files

```txt
src/js/contentscript/first-party-ad-detector.ts
platform/chromium/js/contentscript.js
```

### Generalized fix

Make construction inert. Activation must require policy.

```ts
class FirstPartyAdDetector {
    constructor(private policy: RuntimePolicy) {}

    start() {
        if (this.policy.firstPartyDomDetection !== true) return;
        this.scanDocument();
        this.startObserver();
    }
}
```

### Acceptance check

Synthetic app-shell page with `data-ad`, `ad-*`, `sponsor-*`, or `advert-*` class names must not receive `ubor-ad-detected` unless policy explicitly enables first-party DOM detection.

---

## P0.12 Add a `safe action` policy parameter to all mutation functions

### Problem

`safe-actions.ts` has local guards, but mutation functions do not require a policy object. That means any future caller can bypass the policy layer accidentally.

### Files

```txt
src/js/video-adblock/safe-actions.ts
src/js/video-adblock/video-engine.ts
```

### Generalized fix

Require policy/capabilities for every mutation:

```ts
type MutationCapabilities = {
    hideElement: boolean;
    removeElement: boolean;
    neutralizeClick: boolean;
    skipClick: boolean;
};

export function applySafeActionPlan(
    plan: SafeActionPlan,
    capabilities: MutationCapabilities,
    root?: Document,
): SafeActionResult {
    // refuse action if capability is false
}
```

### Acceptance check

Tests must verify that even high-confidence detections perform zero mutation when capabilities are false.

---

## P0.13 Add a temporary compatibility budget for site-specific exceptions

### Problem

Emergency host exclusions may still be needed, but they should not silently accumulate.

### Files

```txt
platform/chromium/manifest.json
tools/check-production-rule-surface.mjs
tests/fixtures/site-profiles/app-like-sites.json
```

### Generalized fix

Require every site-specific exception to have:

```txt
reason
owner
added date
expiry or replacement generalization item
regression fixture
```

Example:

```json
{
  "host": "grok.com",
  "reason": "app-shell regression fixture until policy bootstrap lands",
  "added": "2026-06-27",
  "expiresAfter": "P2.1 thin bootstrap",
  "replacement": "policy.contentScript.loadVideoRuntime=false for app-shell profile"
}
```

### Acceptance check

Production check fails if a new host exception is added without metadata in the compatibility registry.

---

## P0.14 Make generated artifact checks cover all generated runtime files

### Problem

Some generated bundles have generated-file checks, but generated runtime files should be enforced consistently.

### Files

```txt
tools/check-source-ownership.mjs
platform/chromium/js/smart-content.js
platform/chromium/js/smart-engine.js
platform/chromium/js/video-adblock-generic.js
platform/chromium/js/contentscript.js
```

### Generalized fix

Extend source ownership checks so every generated runtime bundle must declare:

```txt
GENERATED FILE
source path
build command
```

and no generated file may be edited directly unless it is intentionally canonical.

### Acceptance check

`check-source-ownership` fails if any generated runtime bundle is missing source/build metadata.

---

## P0.15 Add typed message contracts and sender authorization

### Problem

The service worker dispatches messages by string channel and `msg.what`. This makes it easy for new UI/content/runtime code to add a bypass path that does not go through policy, host-access, or sender checks.

### Files

```txt
platform/chromium/js/sw.js
src/shared/message-contracts.ts
tools/check-message-contracts.mjs
```

### Generalized fix

Create one message contract registry:

```ts
type SenderKind = "content-script" | "popup" | "dashboard" | "logger" | "extension-page";

type MessageContract = {
    channel: string;
    what: string;
    allowedSenders: SenderKind[];
    requiresTab?: boolean;
    requiresPolicy?: boolean;
    schema: unknown;
};
```

Every dispatcher case must have a contract. The dispatcher should validate:

```txt
channel
what
sender kind
tab/frame identity
payload shape
required page policy
```

### Small first step

Add a static contract file for existing messages and a checker that fails when `dispatchMessage()` accepts a channel not listed in the registry.

### Acceptance check

Production check fails if:

```txt
A new channel is added without a contract.
A new msg.what is handled without a schema.
A content script can call dashboard/logger-only commands.
A page-affecting command does not require tab/page policy.
```

---

## P0.16 Gate remote asset fetching behind an asset authority

### Problem

The default message channel includes a `getAssetContent` handler that fetches a supplied URL. Any remote-fetch path should be explicit about who is allowed to call it and what URL classes are allowed.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/asset-authority.js
tools/check-remote-fetch-authority.mjs
```

### Generalized fix

Create an asset authority module:

```ts
type AssetFetchRequest = {
    url: string;
    purpose: "filter-list" | "asset-catalog" | "user-imported-list" | "debug-view";
    caller: "dashboard" | "updater" | "logger";
};

function mayFetchRemoteAsset(request: AssetFetchRequest): boolean;
```

Rules:

```txt
Content scripts cannot request arbitrary remote fetches through the service worker.
Dashboard fetches must be limited to known filter-list assets or user-confirmed imported lists.
Release mode must not add new remote fetch purposes without a check update.
Raw URLs should be normalized and stripped before logging.
```

### Acceptance check

Fail if `fetchWithTimeout(url)` is reachable from a generic/default message handler without asset-authority approval.

---

## P0.17 Make webRequest tracking policy- and logger-activated

### Problem

The service worker registers `webRequest` listeners for `<all_urls>` at startup. Even if the listeners are used mainly for stats/logger attribution, the instrumentation surface should be explicitly governed.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
tools/check-instrumentation-surface.mjs
```

### Generalized fix

Create an instrumentation policy:

```ts
type InstrumentationPolicy = {
    webRequestTracking: boolean;
    collectRequestStats: boolean;
    collectMatchedRules: boolean;
    loggerActive: boolean;
};
```

Rules:

```txt
If logger is inactive and popup stats do not require live tracking, minimize or disable broad request tracking.
Do not record raw query strings unless logger/debug mode explicitly allows normalized URLs.
Tie instrumentation state to runtimeHealth so the user can see what is active.
```

### Acceptance check

A check fails if `<all_urls>` webRequest listeners are registered without an instrumentation policy or documented always-on reason.

---

## P0.18 Add frame-policy inheritance for all_frames and about:blank

### Problem

Global content scripts run with `all_frames: true` and `match_about_blank: true`. Child frames, `about:blank`, and `about:srcdoc` frames can inherit behavior from a parent page or represent a separate third-party context. The policy must be explicit for each frame.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/manifest.json
src/js/frame-policy.ts
```

### Generalized fix

Add a frame policy object:

```ts
type FramePolicy = {
    frameId: number;
    parentFrameId?: number;
    documentUrl: string;
    parentUrl?: string;
    effectiveUrl: string;
    inheritsParentPolicy: boolean;
    allowCosmetic: boolean;
    allowScriptlets: boolean;
    allowVideoMutation: boolean;
};
```

Default behavior:

```txt
about:blank/about:srcdoc inherits the nearest non-empty parent policy.
third-party iframes get a stricter policy than the top frame.
main-world hooks are top-frame only unless explicitly allowed.
video mutation in subframes requires known adapter evidence.
```

### Acceptance check

Synthetic tests for:

```txt
top app shell + about:blank frame
top news page + third-party ad iframe
top video site + player iframe
```

Each frame must receive the expected policy snapshot.

---

## P0.19 Correct trusted-site allow semantics

### Problem

Trusted/whitelist behavior should disable blocking for a trusted page. Session DNR allow rules must express that semantics correctly. A rule that only allows requests *to* a trusted domain does not necessarily allow all subresources *from* a trusted page.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
tests/runtime/whitelist-parity.spec.ts
```

### Generalized fix

Define trusted-site behavior once:

```txt
trusted top-frame -> no network blocking for that document and its frames unless user explicitly re-enables
trusted site -> cosmetics/scriptlets/video mutation off
trusted regex/path directive -> scoped to matching document URLs, not global request domains
```

DNR strategy should use the safest equivalent for document-level allow behavior, such as `allowAllRequests` scoped to matching `main_frame`/`sub_frame`, or an explicit policy path that prevents dynamic/session blockers from being installed for that tab/site.

### Acceptance check

Tests must verify that a whitelisted app page can load third-party scripts/XHR/WebSocket resources that would otherwise be blocked, while a non-whitelisted page remains filtered.

---

## P0.20 Add policy snapshot caching with explicit invalidation

### Problem

Policy is recomputed in different places from storage/session state. Without a versioned snapshot, a content runtime can start with stale policy after a popup toggle, whitelist change, filter-list reload, migration, or tab navigation.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-cache.js
src/js/policy-client.ts
```

### Generalized fix

Cache page policy by tab/frame/document lifecycle:

```ts
type PolicySnapshot = {
    tabId: number;
    frameId: number;
    documentId?: string;
    url: string;
    hostname: string;
    revision: number;
    policy: PagePolicy;
};
```

Invalidate on:

```txt
tab URL change
popup switch change
whitelist change
filter-list reload
storage migration
managed policy change
extension update
```

### Acceptance check

Changing `noCosmeticFiltering`, whitelist, or net filtering must bump the policy revision and cause already-loaded runtimes to stop or downgrade.

---

## P0.21 Add user-rule validation before saving dynamic firewall/URL rules

### Problem

The popup/rules path accepts session and permanent URL/firewall rules as strings. User rules are powerful, so they need the same risk classifier and validation path as filter-list rules.

### Files

```txt
platform/chromium/js/sw.js
src/js/rules/user-rule-validator.ts
tests/user-rules/*.spec.ts
```

### Generalized fix

Add one validator for user-entered network rules:

```ts
type UserRuleDecision = {
    normalized: string;
    risk: "safe" | "medium" | "high" | "critical";
    accepted: boolean;
    reason: string;
};
```

Rules:

```txt
High-risk global script/xhr/websocket blocks require advanced mode and explicit confirmation.
Rules affecting auth/payment/app-shell profiles must show a warning.
Invalid or ambiguous rules are rejected, not silently saved.
All user rules get decision records.
```

### Acceptance check

Tests cover global script block, global XHR block, site-specific script block, and invalid rule syntax.

---

# P1 — Medium changes with strong architectural value

## P1.1 Expand `resolvePagePolicy()` into a layered policy object

### Problem

The resolver currently returns coarse booleans:

```txt
netFilteringEnabled
cosmeticFilteringEnabled
scriptletsEnabled
remoteFontsAllowed
largeMediaAllowed
popupsAllowed
```

That is not enough to safely decide between specific CSS, generic CSS, procedural CSS, smart rules, video scanning, scriptlets, main-world hooks, first-party response mutation, and DNR risk modes.

### Files

```txt
platform/chromium/js/policy-resolver.js
```

### Proposed policy shape

```ts
export type PagePolicy = {
    trustedSite: boolean;

    network: {
        mode: "full" | "safe" | "off";
        firstParty: "explicit-only" | "off";
        highRiskResources: "specific-only" | "off";
        firstPartyResponseMutation: boolean;
    };

    cosmetic: {
        specific: boolean;
        generic: boolean;
        procedural: boolean;
        smart: boolean;
    };

    video: {
        mode: "known-adapter" | "observe-only" | "off";
        allowMutation: boolean;
        allowSkipClick: boolean;
    };

    scriptlets: {
        mode: "trusted-specific-only" | "off";
        mainWorldHooks: boolean;
    };

    instrumentation: {
        webRequestTracking: boolean;
        loggerAttribution: boolean;
        collectMatchedRules: boolean;
    };

    contentScript: {
        enabled: boolean;
        loadCosmeticRuntime: boolean;
        loadSmartRuntime: boolean;
        loadVideoRuntime: boolean;
        loadInterceptors: boolean;
    };
};
```

### Unknown app default

```js
const DEFAULT_UNKNOWN_APP_POLICY = {
    network: {
        mode: "safe",
        firstParty: "explicit-only",
        highRiskResources: "specific-only",
        firstPartyResponseMutation: false,
    },
    cosmetic: {
        specific: true,
        generic: false,
        procedural: false,
        smart: false,
    },
    video: {
        mode: "observe-only",
        allowMutation: false,
        allowSkipClick: false,
    },
    scriptlets: {
        mode: "trusted-specific-only",
        mainWorldHooks: false,
    },
    contentScript: {
        enabled: true,
        loadCosmeticRuntime: true,
        loadSmartRuntime: false,
        loadVideoRuntime: false,
        loadInterceptors: false,
    },
};
```

### Acceptance check

Every feature layer must read a policy field. No layer should use its own sensitive-host list as its primary runtime decision.

---

## P1.2 Split cosmetic filtering into specific, generic, procedural, and smart modes

### Problem

The current content-script parameter path combines specific and generic cosmetic filters under one broad cosmetic flag. Generic and procedural cosmetics are higher breakage risk than site-specific declarative CSS.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/contentscript.js
src/js/smart-content.ts
```

### Generalized fix

Return separate fields:

```js
return {
    noCosmeticFiltering: !policy.cosmetic.specific && !policy.cosmetic.generic,
    noSpecificCosmeticFiltering: !policy.cosmetic.specific,
    noGenericCosmeticFiltering: !policy.cosmetic.generic,
    noProceduralCosmeticFiltering: !policy.cosmetic.procedural,
    noSmartCosmeticFiltering: !policy.cosmetic.smart,
    specificCosmeticFilters: policy.cosmetic.specific ? specificOnly : emptyCosmetics,
    genericCosmeticFilters: policy.cosmetic.generic ? genericOnly : emptyCosmetics,
};
```

### Unknown app default

```txt
specific cosmetics: allowed
generic cosmetics: off
procedural cosmetics: off
smart cosmetics: off
```

### Acceptance check

Synthetic app-shell page with many `ad`, `sponsored`, `banner`, and `promo` class names must not receive generic/procedural/smart cosmetic mutation by default.

---

## P1.3 Replace global generic video mutation with known-adapter activation

### Problem

Generic video adapters still use wildcard host matching. Even when actions are high-confidence gated, the engine still starts broadly and scans pages.

### Files

```txt
src/js/video-adblock/breakage-guard.ts
src/js/video-adblock/video-engine.ts
src/js/video-adblock/site-adapters/*.ts
```

### Generalized fix

Use capability-based activation:

```ts
type AdapterMode = "known-host" | "known-player" | "observe-only";

type VideoSiteAdapter = {
    id: string;
    mode: AdapterMode;
    canMutateUnknownHost: false;
    matches(hostname: string, signals: VideoPageSignals): boolean;
};
```

Unknown sites:

```txt
observe-only
no hide
no remove
no neutralize click
no skip click
no main-world hooks
```

### Small first step

```ts
if (policy.video.allowMutation !== true) {
    debugLog("Video engine observe-only; mutation disabled by policy");
    return;
}
```

### Acceptance check

A synthetic app page with a normal `<video>` and overlay UI must not hide, remove, neutralize, or click anything unless classified as known video-adapter eligible.

---

## P1.4 Generalize protected UI detection beyond YouTube

### Problem

There is YouTube-specific protected UI logic, but the generic rule should protect application shells everywhere.

### Files

```txt
src/js/video-adblock/safe-actions.ts
platform/chromium/js/contentscript.js
```

### Generalized guard

Protect by default:

```txt
html
body
video
main/header/nav/form
input/textarea/select/button in forms
contenteditable elements
dialog/modal roots
ARIA application roots
large viewport containers
extension-owned UI
```

Example:

```ts
function isProtectedAppUi(element: Element): boolean {
    if (!(element instanceof Element)) return true;

    const tag = element.tagName.toLowerCase();
    if (["html", "body", "video", "main", "header", "nav", "form"].includes(tag)) {
        return true;
    }

    if (element.closest("form, [contenteditable='true'], [role='application'], [role='dialog']")) {
        return true;
    }

    const rect = element.getBoundingClientRect();
    const viewportArea = window.innerWidth * window.innerHeight;
    const elementArea = rect.width * rect.height;

    if (viewportArea > 0 && elementArea / viewportArea > 0.35) {
        return true;
    }

    return false;
}
```

### Acceptance check

Synthetic SPA page with header/sidebar/main/chat-input must not have these elements hidden, removed, or click-neutralized by generic rules.

---

## P1.5 Move first-party fetch/XHR response mutation behind explicit policy

### Problem

The universal ad interceptor can override `fetch`, override XHR, and rewrite JSON/text responses. This is one of the highest-risk behaviors in an extension because it can corrupt app state.

### Files

```txt
src/js/contentscript/universal-ad-interceptor.ts
platform/chromium/js/contentscript.js
platform/chromium/js/policy-resolver.js
```

### Generalized fix

Rules:

```txt
No fetch override on unknown sites.
No XHR override on unknown sites.
No responseText/response rewrite unless trusted, site-specific, and explicitly enabled.
No JSON key stripping globally.
No main-world hook without policy.scriptlets.mainWorldHooks === true.
```

### First implementation

```ts
export function createUniversalAdInterceptor(policy: PagePolicy) {
    if (policy.network.firstPartyResponseMutation !== true) {
        return { activate() {}, destroy() {} };
    }
    return new UniversalAdInterceptor(policy);
}
```

### Acceptance check

Production guard fails if global content code contains these without a policy gate:

```txt
self.fetch =
XMLHttpRequest.prototype.open =
Object.defineProperty(this, "responseText"
Object.defineProperty(this, "response"
```

---

## P1.6 Make smart cosmetic wildcard targets test-only or explicitly confirmed

### Problem

The smart cosmetic engine supports target `*`, which matches all hosts. That is too risky for active smart rules.

### Files

```txt
src/core/smart-cosmetic/engine.ts
src/core/smart-cosmetic/smart-rule-store.ts
src/js/smart-content.ts
```

### Generalized fix

Reject active wildcard smart rules unless they are:

```txt
dev/test-only
previewed and confirmed
limited to observe-only
scoped by a policy profile
```

Small first step:

```ts
if (target.value === '*') {
    return rule.metadata?.scope === 'test-only' || rule.safety?.allowGlobal === true;
}
```

Long-term production default:

```ts
if (target.value === '*') return false;
```

### Acceptance check

An active smart rule with target `*` must not apply in production unless it passes a production safety gate.

---

## P1.7 Create shared URL/domain utilities

### Problem

Hostname/domain logic is scattered. Some logic uses simple `slice(-2)` domain extraction, some checks subdomains manually, and special-page handling exists separately.

### Files

```txt
platform/chromium/js/url-utils.js
platform/chromium/js/sw.js
platform/chromium/js/host-access.js
src/js/video-adblock/breakage-guard.ts
tools/*.mjs
```

### Generalized fix

Create shared helpers:

```ts
export function extractHostname(url: string): string;
export function isHttpWebUrl(url: string): boolean;
export function isSpecialBrowserUrl(url: string): boolean;
export function isSubdomainOrExact(hostname: string, base: string): boolean;
export function getApproxRegistrableDomain(hostname: string): string;
export function normalizeHostname(hostname: string): string;
```

### Acceptance check

All runtime and tools use shared helpers for:

```txt
subdomain matching
supported URL checks
special page checks
registrable-domain approximation
```

No new local `hostname.endsWith(...)` helpers unless justified.

---

## P1.8 Create DNR ID and priority band registry

### Problem

DNR rule ID ranges and priority numbers are scattered. This increases collision risk and makes policy reasoning harder.

### Files

```txt
platform/chromium/js/dnr-registry.js
platform/chromium/js/sw.js
tools/validate-static-rulesets.mjs
tools/check-dnr-priority-semantics.mjs
```

### Generalized fix

Create one registry:

```js
export const DNR_ID_RANGES = {
    staticCore: [1, 99999],
    whitelistSession: [300000, 309999],
    dynamicCompiled: [100, 4999999],
    sessionOverflow: [23000000, 23004999],
    stealthSurrogates: [90000000, 90009999],
};

export const DNR_PRIORITY_BANDS = {
    allowCritical: 900000,
    allowUser: 500000,
    blockImportant: 100001,
    blockDefault: 1,
};
```

### Acceptance check

Checks fail if a rule ID or priority is outside an allowed named band without registry metadata.

---

## P1.9 Add a storage migration registry

### Problem

There is now a DNR schema version, but storage has more schema-sensitive data:

```txt
compiled filter counts
cosmeticFiltersData
selected filter lists
user filters
whitelist
hostname switches
firewall rules
smart rules
```

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/storage-migrations.js
```

### Generalized fix

Add a registry:

```ts
type Migration = {
    id: number;
    name: string;
    run(): Promise<void>;
};

const MIGRATIONS: Migration[] = [
    { id: 1, name: "clear-legacy-global-cosmetics", run: cleanupLegacyGlobalCosmeticFilters },
    { id: 2, name: "clear-dnr-broad-fallback-state", run: clearDnrStateForSchemaUpgrade },
    { id: 3, name: "normalize-selected-filter-lists", run: normalizeSelectedFilterListsStorage },
];
```

### Acceptance check

Startup must run pending migrations before reading cached runtime state. Every migration is idempotent and has a test.

---

## P1.10 Add observer budgets as a shared runtime primitive

### Problem

Several runtimes can install mutation observers or scanning loops:

```txt
content DOM watcher
cosmetic surveyor
first-party ad detector
smart runtime
video engine
universal interceptor observer
```

If these run together on app-like pages, performance and breakage risk increase.

### Files

```txt
src/js/runtime/observer-budget.ts
src/js/video-adblock/video-engine.ts
src/js/contentscript/first-party-ad-detector.ts
src/core/smart-cosmetic/smart-runtime.ts
platform/chromium/js/contentscript.js
```

### Generalized fix

Create a shared budget:

```ts
type ObserverBudget = {
    maxObservers: number;
    maxNodesPerCycle: number;
    maxMsPerCycle: number;
    allowAttributeObservers: boolean;
};
```

Policy maps page profile to observer budget.

### Acceptance check

Synthetic app-shell fixture must not run more than the allowed number of observers/scanning loops under default policy.

---

## P1.11 Add rule/action decision reports

### Problem

When a rule or runtime action is accepted/rejected, there is no compact reason trail. That makes general safety hard to debug.

### Files

```txt
platform/chromium/js/sw.js
src/js/video-adblock/video-engine.ts
src/core/smart-cosmetic/engine.ts
```

### Generalized fix

Create decision records:

```ts
type DecisionRecord = {
    layer: "dnr" | "cosmetic" | "video" | "smart" | "scriptlet";
    action: string;
    risk: "safe" | "medium" | "high" | "critical";
    decision: "allowed" | "rejected" | "observe-only" | "degraded";
    reason: string;
    source?: string;
};
```

Expose the last N decisions in the logger/dashboard.

### Acceptance check

Every rejected high-risk DNR rule and every blocked mutation action must produce a decision record.

---

## P1.12 Release/dev manifest parity checks

### Problem

The release manifest generator removes dev-only rulesets and narrows host permissions, but production safety invariants must be checked against both dev and release manifests.

### Files

```txt
tools/generate-release-manifest.mjs
tools/check-production-rule-surface.mjs
tools/audit-mv3-manifest.mjs
platform/chromium/manifest.json
platform/chromium/manifest.release.json
```

### Generalized fix

After generating release manifest, run the same invariants against both:

```txt
content script injection surface
host permissions
DNR rulesets
permissions
web-accessible resources
sensitive compatibility registry
```

### Acceptance check

`npm run check:mv3-manifest:release` must include the new production-surface invariants.

---

## P1.13 Add negative tests for generic heuristics

### Problem

Most ad-block tests prove that ads are blocked. Generalization also needs tests proving that non-ads are not touched.

### Files

```txt
tests/fixtures/*.html
tests/video-adblock/*.spec.ts
tests/cosmetic/*.spec.ts
tests/runtime/*.spec.ts
```

### Add fixtures

```txt
app-shell-with-ad-like-classnames.html
chat-app-with-sponsored-text.html
settings-page-with-administration-ids.html
auth-form-with-promo-code-field.html
video-call-ui-with-overlay.html
normal-player-with-controls-overlay.html
```

### Acceptance check

Default policy must produce:

```txt
zero hidden app-shell elements
zero removed app-shell elements
zero neutralized app-shell clicks
zero response mutations
zero main-world hooks
```

---

## P1.14 Centralize compatibility metadata for temporary site exceptions

### Problem

Manifest exclusions, sensitive host lists, DNR excludedInitiatorDomains, and tool fixtures can diverge.

### Files

```txt
config/compatibility-sites.json
tools/check-compatibility-metadata.mjs
platform/chromium/manifest.json
src/js/video-adblock/breakage-guard.ts
```

### Generalized fix

All temporary site exceptions should be generated from one metadata file, or at least checked against it.

```json
{
  "version": 1,
  "temporaryExceptions": [
    {
      "host": "example.com",
      "layers": ["contentScript", "genericVideo"],
      "reason": "temporary app-shell protection until bootstrap policy is shipped",
      "expiresWhen": "P2.1 complete",
      "fixture": "fixtures/app-shell-basic.html"
    }
  ]
}
```

### Acceptance check

If a host appears in manifest `exclude_matches` or runtime sensitive-host code, it must appear in compatibility metadata.

---

## P1.15 Add a permission and capability registry

### Problem

The manifest requests several powerful permissions. The codebase should define which feature owns each permission and whether it is required in dev, release, or optional modes.

### Files

```txt
platform/chromium/manifest.json
config/permission-capabilities.json
tools/check-permission-capabilities.mjs
```

### Generalized fix

Create a registry:

```json
{
  "webRequest": {
    "owner": "instrumentation",
    "releaseRequired": true,
    "activationPolicy": "instrumentation.webRequestTracking"
  },
  "declarativeNetRequestFeedback": {
    "owner": "logger-dev",
    "releaseRequired": false,
    "activationPolicy": "dev-only"
  },
  "privacy": {
    "owner": "settings",
    "releaseRequired": "justify"
  }
}
```

### Acceptance check

Manifest check fails if a permission exists without a registry owner, release profile, and activation reason.

---

## P1.16 Normalize filter-parser unsupported and downgraded options

### Problem

Unsupported filter options are often skipped or simplified. That is safer than pretending to support them, but the compiler should report every skip/downgrade so behavior is explainable and testable.

### Files

```txt
platform/chromium/js/sw.js
src/compiler/filter-compile-report.ts
tools/check-filter-syntax-coverage.mjs
```

### Generalized fix

Add compile diagnostics:

```ts
type FilterCompileDiagnostic = {
    rawFilter: string;
    sourceList: string;
    decision: "compiled" | "skipped" | "downgraded";
    reason: string;
    unsupportedOptions?: string[];
};
```

Rules:

```txt
Negated resource types must not be ignored silently.
Unsupported options must produce diagnostics.
A downgrade from specific to broad must be forbidden unless explicitly safe.
Dashboards/checks should show unsupported count per list.
```

### Acceptance check

Fixtures with `$~script`, `$redirect`, `$removeparam`, `$domain=~example.com`, and regex filters must produce explicit diagnostics.

---

## P1.17 Generalize static allow/unbreak rules through the same risk model

### Problem

Dynamic compiled rules, fallback rules, static rules, and unbreak/allow rules should not have separate safety logic. Static allow/block rules can still create broad side effects.

### Files

```txt
platform/chromium/dnr/*.rules.json
tools/validate-static-rulesets.mjs
tools/check-dnr-priority-semantics.mjs
src/dnr/risk-classifier.ts
```

### Generalized fix

Run every DNR source through one classifier:

```txt
static-core
static-privacy
static-video-ads
static-unbreak
dynamic compiled lists
session whitelist rules
user rules
```

Acceptance fields per rule:

```txt
risk
resource type class
initiator specificity
action class
priority band
source ruleset
reason
```

### Acceptance check

Static ruleset validation fails if a broad high-risk block or allow rule lacks explicit classifier metadata.

---

## P1.18 Add per-tab layer lifecycle cleanup

### Problem

The service worker cleans some tab maps on removal, but runtime layers need a unified lifecycle for navigation, BFCache restore, SPA route changes, tab discard, frame removal, and extension reload.

### Files

```txt
platform/chromium/js/sw.js
src/js/runtime/page-lifecycle.ts
src/js/video-adblock/video-engine.ts
src/core/smart-cosmetic/smart-runtime.ts
platform/chromium/js/contentscript.js
```

### Generalized fix

Define lifecycle events:

```ts
type PageLifecycleEvent =
  | "document-start"
  | "policy-ready"
  | "spa-navigation"
  | "pagehide"
  | "pageshow"
  | "frame-detached"
  | "tab-discarded"
  | "tab-removed"
  | "extension-updated";
```

Each runtime layer must implement cleanup for relevant events.

### Acceptance check

Synthetic SPA route changes and BFCache restore must not duplicate observers, CSS, prototype hooks, timers, or hidden-element state.

---

## P1.19 Add normalized URL logging and redaction

### Problem

Logger and diagnostics need URLs for attribution, but raw URLs can contain private query strings, tokens, or chat/session identifiers.

### Files

```txt
platform/chromium/js/sw.js
src/shared/url-redaction.ts
tools/check-logger-privacy.mjs
```

### Generalized fix

Create one redaction utility:

```ts
type RedactedUrl = {
    origin: string;
    pathnameClass: string;
    queryKeys: string[];
    raw?: never;
};
```

Rules:

```txt
Default logs store origin + coarse path only.
Query values are never stored unless explicit debug export is enabled.
Known sensitive keys are removed entirely.
Decision records refer to normalized URLs.
```

### Acceptance check

Logger privacy tests fail if stored log entries include raw query values, fragments, auth tokens, or form values.

---

## P1.20 Add a central feature-flag registry

### Problem

Experimental features can be toggled through settings or hidden code paths, but there is no single feature registry connecting flags to risk, policy fields, permissions, and tests.

### Files

```txt
config/features.json
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
tools/check-feature-registry.mjs
```

### Generalized fix

Feature registry entry:

```json
{
  "id": "firstPartyResponseMutation",
  "risk": "critical",
  "default": false,
  "policyField": "network.firstPartyResponseMutation",
  "requires": ["message-contract", "privacy-redaction", "negative-fixtures"],
  "permissions": []
}
```

### Acceptance check

Any new setting/hidden flag/experimental option must exist in the feature registry and have at least one test fixture.

---

## P1.21 Add per-layer user-visible diagnostics

### Problem

A user can see that a page broke, but not which layer acted. Diagnostics should be generalized by layer rather than site.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/policy-resolver.js
platform/chromium/pages/logger-ui.html
src/js/logger-ui.ts
```

### Generalized fix

Expose per-tab layer state:

```ts
type LayerRuntimeState = {
    layer: string;
    state: "off" | "observe-only" | "active" | "blocked-by-policy" | "error";
    policyReason: string;
    lastAction?: string;
    lastError?: string;
};
```

### Acceptance check

Logger/popup can show, for the active tab, whether network, cosmetic, smart, video, scriptlet, interceptor, and instrumentation layers are active or disabled by policy.

---

## P1.22 Make custom new-tab behavior a separate capability

### Problem

The extension also changes browser navigation behavior through custom new-tab interception. This is separate from ad blocking and should be isolated in the same capability/policy model.

### Files

```txt
platform/chromium/js/sw.js
config/features.json
tools/check-feature-registry.mjs
```

### Generalized fix

Treat new-tab replacement as its own feature:

```txt
feature: customNewTab
risk: navigation-modifying
permission surface: tabs/commands/storage
default: explicit user setting only
recovery: keyboard command or settings toggle
```

### Acceptance check

No ad-blocking policy or migration may implicitly toggle custom new-tab behavior.

---

# P2 — Larger architectural changes

## P2.1 Replace manifest-level global heavyweight injection with a thin bootstrap

### Problem

Manifest-level injection is too coarse. Once a large script is injected into every page, every subsystem must defend itself separately.

### Goal

Manifest injects only:

```txt
/js/bootstrap.js
```

The bootstrap asks the service worker for policy. The service worker conditionally enables:

```txt
cosmetic runtime
smart cosmetic runtime
video runtime
scriptlet runtime
logger hooks
first-party detector
interceptors
```

### Proposed bootstrap

```js
(async () => {
    const policy = await chrome.runtime.sendMessage({
        channel: "contentscript",
        msg: {
            what: "getPagePolicy",
            url: location.href,
            hostname: location.hostname,
            pageSignals: collectCheapPageSignals(),
        },
    });

    if (!policy?.contentScript?.enabled) return;

    await chrome.runtime.sendMessage({
        channel: "contentscript",
        msg: {
            what: "activatePageLayers",
            url: location.href,
            hostname: location.hostname,
            policy,
        },
    });
})();
```

### Acceptance check

Global manifest content-script entries may only contain bootstrap files. Heavy runtime files must be loaded conditionally.

---

## P2.2 Add app-like page classification

### Problem

The extension needs a general way to avoid breaking complex web apps without knowing their hostnames.

### Cheap page signals

Collect only structural signals, not private content:

```txt
has contenteditable
has textarea/input focus surface
has WebSocket/EventSource usage if observable
has service worker controller
has large root app container
has SPA root ids/classes: root, app, __next, main, shell
has login/payment/auth-like form
has video but no known video-adapter signal
has many shadow roots
has same-origin API activity
```

### Classifier

```ts
function classifyPageProfile(signals): PageProfile {
    if (signals.hasAuthForm) return "auth-sensitive";
    if (signals.hasPaymentForm) return "payment-sensitive";
    if (signals.hasContentEditable || signals.hasLargeAppRoot) return "app-shell";
    if (signals.hasPrimaryVideo && signals.hasKnownVideoPlayerSignal) return "video-site";
    return "default-web";
}
```

### Policy mapping

```txt
app-shell:
  generic cosmetic off
  procedural cosmetic off
  smart cosmetic off
  first-party high-risk network off
  video mutation off
  main-world hooks off

claim/auth/payment-sensitive:
  all mutation off except explicit specific cosmetics

video-site:
  known adapter allowed
  generic unknown mutation off
```

### Acceptance check

Run fixture pages through classifier and snapshot the policy object.

---

## P2.3 Compile rule evidence into install reports

### Problem

When a rule is installed, rejected, or downgraded, the system should know why.

### Generalized fix

Add internal reports:

```ts
type RuleInstallDecision = {
    id: number;
    action: string;
    sourceList: string;
    rawFilter: string;
    resourceTypes: string[];
    risk: "safe" | "medium" | "high" | "critical";
    specificity: "site-specific" | "third-party" | "broad";
    decision: "installed" | "rejected" | "downgraded";
    reason: string;
};
```

Store compact data in:

```txt
dist/build/certificate/dnr-install-decisions.json
```

or in runtime storage for logger/debug builds.

### Acceptance check

Every installed dynamic/session DNR rule must have a decision record.

---

## P2.4 Add automatic recovery when a page looks broken after filtering

### Problem

Users currently discover breakage manually.

### General recovery signal

If a tab matches several of these soon after navigation:

```txt
main frame loaded but body remains nearly empty
many high-risk DNR blocks occurred
script/xhr/websocket blocks occurred
user reloads same tab repeatedly
extension-side content errors occur
content script reports zero usable app roots after mutation
large percentage of viewport hidden by extension CSS
```

then the extension should enter temporary safe mode for that tab.

### Safe-mode behavior

```txt
remove dynamic/session high-risk blocks for this tab/site
remove cosmetic CSS inserted by extension
stop smart cosmetic runtime
stop video runtime
stop main-world hooks
show logger recovery message
```

### Acceptance check

Synthetic app page intentionally broken by a test rule must recover after safe-mode trigger.

---

## P2.5 Add transactional DNR updates with rollback

### Problem

DNR updates can partially fail. A failed update should not leave a stale or mixed ruleset active.

### Files

```txt
platform/chromium/js/sw.js
platform/chromium/js/dnr-transaction.js
```

### Generalized fix

Implement a transaction wrapper:

```ts
type DnrSnapshot = {
    dynamicRules: chrome.declarativeNetRequest.Rule[];
    sessionRules: chrome.declarativeNetRequest.Rule[];
};

async function updateDnrTransaction(nextDynamic, nextSession) {
    const snapshot = await snapshotDnrRules();
    try {
        await replaceDynamicRules(nextDynamic, true);
        await replaceSessionRules(nextSession, true);
        return { ok: true };
    } catch (err) {
        await restoreDnrSnapshot(snapshot).catch(() => enterDegradedAllowMode("DNR rollback failed"));
        return { ok: false, error: String(err) };
    }
}
```

### Acceptance check

A simulated install failure must either restore the previous good rules or enter degraded allow mode. It must not leave partial broad rules active.

---

## P2.6 Move from host exceptions to site profiles

### Problem

Hostnames are a weak abstraction. The same safety behavior is needed for many unrelated apps.

### Generalized fix

Use profiles:

```txt
app-shell
auth-sensitive
payment-sensitive
video-known-adapter
video-unknown
news/content
search/results
extension/test-page
```

Hostnames may map to profiles only as hints or regression fixtures.

### Acceptance check

Policy decisions are made by profile + signals. Adding a new app-like fixture should require no hostname change.

---

## P2.7 Create a runtime activation protocol

### Problem

Each runtime starts/stops differently. Some install observers, some install CSS, some expose factories, some modify prototypes.

### Generalized fix

Every runtime layer implements:

```ts
interface RuntimeLayer {
    id: string;
    risk: "safe" | "medium" | "high" | "critical";
    canStart(policy: PagePolicy): boolean;
    start(context: RuntimeContext): Promise<void> | void;
    stop(reason: string): Promise<void> | void;
    getDiagnostics(): RuntimeLayerDiagnostics;
}
```

### Acceptance check

No content runtime may self-start outside the activation protocol.

---

## P2.8 Add privacy-preserving page signal collection

### Problem

The policy needs page signals, but signal collection must not read private content unnecessarily.

### Generalized fix

Collect only structural booleans/counts:

```txt
number of input/textarea/contenteditable elements
presence of auth/payment-like form types
presence of primary video
presence of app root candidates
presence of shadow roots
presence of serviceWorker.controller
count of same-origin/third-party resource types if available
```

Avoid collecting:

```txt
full text content
input values
chat messages
user identifiers
URLs with sensitive query params unless normalized
```

### Acceptance check

Logger/privacy check fails if page signal payload contains text content, form values, or raw query strings.

---

## P2.9 Build a rule/action simulator before applying changes

### Problem

The safest way to generalize breakage prevention is to simulate what would happen before DNR rules, cosmetics, video actions, or scriptlets are activated.

### Files

```txt
src/simulator/rule-action-simulator.ts
tests/fixtures/site-profiles/*.json
tools/check-runtime-simulator.mjs
```

### Generalized fix

Create a simulator that takes:

```txt
PageProfile
PagePolicy
DNR rule candidates
cosmetic candidates
video detections
smart rules
scriptlets
```

and outputs:

```txt
allowed actions
rejected actions
observe-only actions
reasons
risk summary
```

### Acceptance check

Every synthetic fixture has a simulator snapshot. A PR that changes policy or rule classification must update snapshots intentionally.

---

## P2.10 Add capability tokens for mutation APIs

### Problem

Even if policy is checked at startup, a future caller may directly call a mutation function. Capability tokens make accidental bypass harder.

### Files

```txt
src/runtime/capability-token.ts
src/js/video-adblock/safe-actions.ts
src/core/smart-cosmetic/smart-runtime.ts
src/js/contentscript/universal-ad-interceptor.ts
```

### Generalized fix

Mutation functions require a capability produced by the policy resolver/runtime activation protocol:

```ts
type CapabilityToken<T extends string> = {
    layer: T;
    tabId: number;
    frameId: number;
    policyRevision: number;
    expiresAt: number;
};
```

No token means no mutation. Expired token means downgrade to observe-only.

### Acceptance check

Unit tests must show that direct calls to hide/remove/click/response-mutate functions fail without a valid token.

---

## P2.11 Create a unified policy DSL for rules, profiles, and features

### Problem

Policy will become hard to maintain if it is scattered across JS conditionals, manifest exclusions, tool scripts, feature flags, and compatibility files.

### Files

```txt
config/page-policy.schema.json
config/page-policy.json
platform/chromium/js/policy-resolver.js
tools/compile-page-policy.mjs
```

### Generalized fix

Use a declarative policy source:

```json
{
  "profiles": {
    "app-shell": {
      "cosmetic.generic": false,
      "cosmetic.procedural": false,
      "video.allowMutation": false,
      "scriptlets.mainWorldHooks": false,
      "network.highRiskResources": "specific-only"
    }
  }
}
```

Compile it into runtime JS and test snapshots.

### Acceptance check

No policy-relevant default may exist only as an inline conditional. It must come from the policy config or a documented emergency override.

---

## P2.12 Add cross-browser capability profiles

### Problem

MV3 behavior differs across Chromium-family browsers and Firefox-like environments. General safety should not assume one browser capability set.

### Files

```txt
config/browser-capabilities.json
platform/chromium/js/host-access.js
platform/chromium/js/policy-resolver.js
tools/check-browser-features.mjs
```

### Generalized fix

Represent capabilities explicitly:

```json
{
  "chromium": {
    "dnrFeedback": "dev-only",
    "webRequestBlocking": false,
    "scriptingInsertCSS": true,
    "documentId": "maybe"
  },
  "edge": {},
  "firefox-mv3": {}
}
```

Policy resolver should degrade safely if a browser lacks a needed capability.

### Acceptance check

Capability tests cover at least Chromium, Edge-like Chromium, and restricted/no-feedback release profile.

---

## P2.13 Add a compatibility debt dashboard

### Problem

Temporary exceptions and compatibility shims become permanent unless tracked. A dashboard makes site-patch debt visible.

### Files

```txt
config/compatibility-sites.json
tools/report-compatibility-debt.mjs
docs/compatibility-debt.md
```

### Generalized fix

Generate a report:

```txt
current temporary host exceptions
which layers they disable
which generalization item will replace them
age
owner
fixtures
status
```

### Acceptance check

CI fails if an exception is expired, has no owner, or has no replacement generalization item.

---

# P3 — Cleanup and long-term hardening

## P3.1 Move demo smart rules into test fixtures only

### Problem

`seedDemoRules()` remains exportable from production runtime source. It is no longer called from service worker startup, which is good, but demo rules should not live in production engine code.

### Files

```txt
src/core/smart-cosmetic/engine.ts
```

### Fix

Move demo rules to:

```txt
tests/fixtures/smart-rules/demo-rules.ts
```

or guard them behind a dev-only build path.

### Acceptance check

Production generated `smart-engine.js` must not contain:

```txt
demo:simple-ad
demo:smart-card
```

---

## P3.2 Choose one canonical runtime source per generated file

### Problem

The service worker is manually canonical, while several other runtime files are generated. This can be workable, but it must be enforced consistently.

### Fix options

Option A:

```txt
Keep sw.js canonical.
Make source-ownership checks strict for every generated file.
```

Option B:

```txt
Move canonical service worker to TypeScript.
Generate sw.js.
Make generated artifact checks strict.
```

### Acceptance check

Every production runtime file has one clear source of truth.

---

## P3.3 Replace site-specific sanitizer cleanup with generic protected-selector policy

### Problem

There is YouTube-specific cleanup for masthead selectors. That was useful for a concrete problem, but the pattern should become generic.

### General model

```txt
Protected selector policy:
  - app shell selectors
  - navigation/header selectors
  - input/auth/payment selectors
  - large container selectors
  - extension-owned UI selectors
  - site-specific protected selectors as fixtures only
```

### Acceptance check

A selector sanitizer should reject generic selectors that match protected UI on synthetic app fixtures, not only on YouTube.

---

## P3.4 Quarantine obsolete or inactive high-risk code

### Problem

Inactive high-risk code can become active later without enough review.

### Files

```txt
src/js/contentscript/universal-ad-interceptor.ts
src/js/contentscript/first-party-ad-detector.ts
src/core/smart-cosmetic/engine.ts
```

### Fix

Move experimental/high-risk inactive code into:

```txt
src/experimental/
```

or require explicit activation metadata:

```txt
status: inactive
risk: critical
activation gate: PagePolicy
owner: runtime-layer-registry
```

### Acceptance check

Production check fails if inactive high-risk code is bundled into global runtime without activation metadata.

---

## P3.5 Add a “no new patch lists” lint rule

### Problem

Future code can reintroduce the same anti-pattern through a new array of hardcoded sites.

### Fix

Add a lint/check script that flags:

```txt
SENSITIVE_HOSTS
EXCLUDED_HOSTS
BROKEN_SITES
KNOWN_SAFE_SITES
chatgpt.com/grok.com/suno.com/yandex.com outside fixtures/compatibility metadata
```

### Acceptance check

New site lists must live in one of:

```txt
tests/fixtures/site-profiles/*.json
config/compatibility-sites.json
site profile classifier tests
```

---

## P3.6 Add documentation for “risk layer contract”

### Problem

A contributor can accidentally add a global heuristic, observer, hook, or DNR rule without understanding the safety model.

### Fix

Add:

```txt
docs/risk-layer-contract.md
```

Content:

```txt
What each layer may do.
What policy field it must read.
What evidence it needs.
What it must do when uncertain.
What synthetic fixture proves it is safe.
```

### Acceptance check

PR checklist requires updating the risk-layer contract when adding a new runtime layer.

---

## P3.7 Centralize magic numbers and runtime budgets

### Problem

Scan intervals, max nodes, DNR limits, logger buffer sizes, schema versions, priority values, and observer budgets are spread across files. This makes it hard to reason about risk and performance.

### Files

```txt
config/runtime-budgets.json
platform/chromium/js/sw.js
src/js/video-adblock/video-engine.ts
src/core/smart-cosmetic/*.ts
tools/check-runtime-budgets.mjs
```

### Generalized fix

Create named budget constants:

```json
{
  "video.scanIntervalMs": 250,
  "video.maxNodesPerScan": 150,
  "logger.bufferMax": 5000,
  "dnr.dynamicRuleLimit": 5000,
  "smart.maxCandidates": 150
}
```

### Acceptance check

Check fails on new hardcoded high-impact limits unless they are in the budget registry.

---

## P3.8 Add ADRs for canonical architectural decisions

### Problem

The repo has important decisions that need to survive future agent/code changes: canonical service worker, policy-first runtime, degraded allow mode, no hostname patch lists, and generated-file ownership.

### Files

```txt
docs/adr/0001-canonical-service-worker.md
docs/adr/0002-policy-first-runtime.md
docs/adr/0003-degraded-allow-mode.md
docs/adr/0004-no-hostname-patch-lists.md
```

### Acceptance check

PR checklist requires updating an ADR when changing service-worker ownership, policy defaults, DNR failure mode, or compatibility exception rules.

---

## P3.9 Add dead-code status metadata instead of only dead-code detection

### Problem

Some code may be intentionally inactive, experimental, generated, or retained for migration cleanup. A dead-code checker alone cannot distinguish these states.

### Files

```txt
config/source-status.json
tools/check-dead-orphan-files.mjs
tools/check-source-ownership.mjs
```

### Generalized fix

Track file status:

```json
{
  "src/js/contentscript/universal-ad-interceptor.ts": {
    "status": "experimental-inactive",
    "risk": "critical",
    "activationGate": "PagePolicy.network.firstPartyResponseMutation"
  },
  "platform/chromium/js/sw.js": {
    "status": "canonical-runtime"
  }
}
```

### Acceptance check

High-risk inactive files must either be excluded from production bundles or have explicit activation metadata.

---

## P3.10 Normalize naming across uBO/uBR/uBoL remnants

### Problem

Mixed naming makes ownership and generated/runtime boundaries harder to reason about. Some attributes and comments still use older project abbreviations.

### Files

```txt
platform/chromium/js/*.js
src/js/**/*.ts
tools/check-naming-consistency.mjs
```

### Generalized fix

Create a naming map:

```txt
uBR = product/runtime prefix
ubor/ubol/uBO = legacy compatibility only, documented where retained
```

### Acceptance check

Check fails on new legacy prefixes unless the file is marked compatibility/legacy.

---

# Recommended implementation order

Do this order first:

```txt
1. P0.1 degraded allow mode
2. P0.2 full-condition DNR dedupe
3. P0.3 high-risk DNR install gate
4. P0.4 policy-derived scriptlet flags
5. P0.8 fix host-access check to canonical sw.js
6. P0.7 production invariant checks
7. P0.5 getPagePolicy first runtime gate
8. P0.9 runtime layer registry
9. P0.12 mutation functions require capabilities
10. P0.6 canonical regression fixtures
11. P0.10 remove @ts-nocheck from high-risk modules
12. P1.1 layered PagePolicy
13. P1.2 split cosmetic modes
14. P1.3 known-adapter video activation
15. P1.4 generic protected app UI guard
16. P1.5 policy-gated response mutation
17. P1.7 shared URL/domain utilities
18. P1.8 DNR ID/priority registry
19. P1.9 storage migration registry
20. P0.15 typed message contracts and sender authorization
21. P0.16 remote asset fetch authority
22. P0.17 instrumentation/webRequest policy
23. P0.18 frame-policy inheritance
24. P0.19 trusted-site allow semantics
25. P0.20 policy snapshot cache/invalidation
26. P0.21 user-rule validation
27. P1.15 permission/capability registry
28. P1.16 filter-parser diagnostics
29. P1.18 per-tab lifecycle cleanup
30. P2.1 thin bootstrap architecture
```

This gives the highest safety improvement with the least UI disruption.

---

# Minimal first coding pass prompt

Use this when asking a coding agent to implement the first wave:

```txt
Implement the first generalization wave for uBlock Resurrected.

Do not add more site-specific exclusions as the primary fix.

Implement:
1. Replace fallback DNR blocking with degraded allow mode.
2. Fix DNR deduplication so it uses full normalized action + condition, including initiatorDomains, excludedInitiatorDomains, requestDomains, excludedRequestDomains, resourceTypes, and domainType.
3. Add DNR risk classification before install. Reject broad high-risk block rules for main_frame, script, xmlhttprequest, websocket, and firstParty unless the rule is trusted/specific.
4. Make scriptletInjectable and scriptletWillInject policy-derived, not unconditional true.
5. Fix tools/check-host-access.mjs so it checks the canonical service worker at platform/chromium/js/sw.js.
6. Extend tools/check-production-rule-surface.mjs with invariants that fail on fallback block mode, broad high-risk fallback rules, unconditional scriptlet flags, ungated response mutation hooks, and duplicated hardcoded sensitive-host lists in tools.
7. Add or update tests proving that compile failure leaves DNR empty/degraded, not broadly blocking.
8. Add a message-contract registry for service-worker dispatch channels and fail unknown unregistered handlers.
9. Gate remote asset fetching through an asset-authority module.
10. Add frame-policy inheritance for all_frames/match_about_blank behavior.
11. Add a permission/capability registry for manifest permissions.

Acceptance:
- npm run typecheck passes if applicable.
- npm run test passes if applicable.
- npm run check:production-rule-surface passes.
- npm run check:host-access checks the canonical runtime path.
- No fallback rule may block main_frame, script, xmlhttprequest, or websocket.
- No site-specific domain additions are used as the main solution.
```

---

# Regression fixtures to add

Add synthetic tests that catch Grok/ChatGPT/Suno-like breakage without depending on those real sites.

```txt
fixtures/app-shell-basic.html
fixtures/app-shell-chat-stream.html
fixtures/app-shell-websocket.html
fixtures/auth-login-form.html
fixtures/payment-popup-flow.html
fixtures/video-normal-no-ads.html
fixtures/video-call-overlay.html
fixtures/video-known-adapter-preroll.html
fixtures/shadow-dom-app.html
fixtures/generic-news-page-with-ads.html
fixtures/app-shell-with-ad-like-classnames.html
fixtures/settings-page-with-administration-ids.html
fixtures/chat-app-with-sponsored-text.html
```

Expected default policy:

| Fixture | Network | Generic Cosmetic | Procedural | Smart | Video Mutation | Main-world Hooks | Response Mutation |
|---|---:|---:|---:|---:|---:|---:|---:|
| app-shell-basic | safe | off | off | off | off | off | off |
| app-shell-chat-stream | safe | off | off | off | off | off | off |
| app-shell-websocket | safe | off | off | off | off | off | off |
| auth-login-form | safest | off | off | off | off | off | off |
| payment-popup-flow | safest | off | off | off | off | off | off |
| video-normal-no-ads | safe | off | off | off | observe-only | off | off |
| video-call-overlay | safe | off | off | off | off | off | off |
| video-known-adapter-preroll | full/safe | specific-only | off | off | known-adapter | off | off |
| generic-news-page-with-ads | full/safe | on | limited | off | off | off | off |

---

# Current improvement notes

Already improved:

```txt
- Dev/test DNR rulesets are disabled in the manifest.
- Release manifest generator strips dev/test rulesets and narrows host permissions.
- Canonical service worker has DNR schema migration and calls it on install/startup.
- Demo smart rules are no longer called by service worker startup.
- Generic video actions are now high-confidence gated before mutation.
- Grok has been added as a temporary exclusion, but that is a compatibility patch, not the general solution.
```

Still needs generalization:

```txt
- Global content-script injection still relies on exclusion lists.
- Global generic video injection still relies on exclusion lists.
- Runtime and tools still rely on hardcoded sensitive/app-like host arrays.
- Fallback DNR still blocks broad high-risk resource types.
- Generic cosmetics are still not separated cleanly from specific cosmetics by policy.
- Policy resolver is too coarse for the number of risk layers.
- Safe action protected UI logic is still too site-specific.
- First-party response mutation code needs explicit policy gating.
- Host-access check should target the canonical service worker.
- Production checks are still mostly pattern-based and need behavioral invariants.
- Message dispatch is string-based and should have schema/sender contracts.
- Remote fetch authority should be explicit for asset/list fetching.
- all_frames and match_about_blank need per-frame policy inheritance.
- Broad webRequest instrumentation should be policy/logger activated or explicitly justified.
- Trusted-site DNR allow semantics need parity tests against intended page-level disable behavior.
- User-entered URL/firewall rules need the same risk classification as compiled filter-list rules.
```

---

# Living update format

When adding future generalization work, append entries like this:

```md

## P0.22 Add runtime schema validation for every service-worker message

### Problem

Typed message contracts are necessary, but not enough. Runtime messages can still be malformed, stale, or sent from an unexpected frame. Current dispatch code routes many channels through one dispatcher and often forwards raw `msg` objects to handlers.

This creates a general risk:

```txt
a malformed message can trigger permissive fallback behavior
a stale UI can call a handler with missing fields
a content frame can send a message intended only for extension UI
a future handler can silently accept the wrong payload shape
```

### Files

```txt
platform/chromium/js/sw.js
src/js/messaging/*
tests/runtime/*
tools/check-message-contracts.mjs
```

### Generalized fix

Create a `message-schemas.ts` registry:

```ts
type MessageSchema = {
    channel: string
    what: string
    sender: "extension-ui" | "content-script" | "service-worker" | "any"
    required: Record<string, "string" | "number" | "boolean" | "array" | "object">
    optional?: Record<string, "string" | "number" | "boolean" | "array" | "object">
    defaultResponse: unknown
}
```

Every message enters through:

```ts
const checked = validateMessage(channel, msg, sender)
if (!checked.ok) {
    return checked.safeResponse
}
```

### Acceptance check

```txt
- Unknown channel returns structured error.
- Unknown what returns structured error.
- Missing required field returns safe response.
- Content scripts cannot call extension-UI-only handlers.
- CI fails if dispatchMessage has a handler not listed in message-schemas.ts.
```

---

## P0.23 Centralize extension-owned DOM markers and attributes

### Problem

Several runtime layers use their own marker attributes and classes, for example hidden-element markers, click-neutralized markers, extension UI markers, smart cosmetic markers, and video-adblock markers. When these markers are scattered, one layer can fail to recognize another layer's owned DOM and accidentally hide, remove, count, or mutate extension-owned UI.

### Files

```txt
src/js/dom/owned-markers.ts
src/js/video-adblock/safe-actions.ts
src/js/contentscript/*
src/core/smart-cosmetic/*
platform/chromium/js/contentscript.js
```

### Generalized fix

Create a single owned-marker registry:

```ts
export const EXTENSION_OWNED_ATTRIBUTES = [
    "data-ubr-owned",
    "data-ubr-extension-ui",
    "data-ubol-overlay",
    "data-ubol-overlay-dialog",
    "data-ubr-video-ad-hidden",
    "data-ubr-video-ad-click-neutralized",
]

export function isExtensionOwnedElement(el: Element): boolean {
    return EXTENSION_OWNED_ATTRIBUTES.some(attr => el.hasAttribute(attr))
}
```

Every DOM mutation function must call this before hide, remove, neutralize, click, scan count, or cosmetic application.

### Acceptance check

```txt
- No mutation layer defines its own extension-owned marker list.
- All hide/remove/click functions import isExtensionOwnedElement().
- Test fixture with picker UI, logger UI, smart overlay, and video marker is never hidden or removed.
```

---

## P0.24 Add a safe-regex compiler for whitelist, filter, and smart-rule regex

### Problem

Regex appears in multiple places: whitelist directives, DNR regex filters, smart rules, parser logic, and selector/procedural logic. Each place can parse regex differently. A broken or expensive regex can cause silent failure, performance problems, or inconsistent policy.

### Files

```txt
src/js/utils/safe-regex.ts
platform/chromium/js/sw.js
src/core/smart-cosmetic/*
tests/security/safe-regex.spec.ts
tools/check-safe-regex-usage.mjs
```

### Generalized fix

Create one safe regex wrapper:

```ts
type SafeRegexResult =
  | { ok: true; regex: RegExp; source: string }
  | { ok: false; reason: "too-long" | "invalid" | "forbidden-construct" }

function compileSafeRegex(raw: string, opts: {
    maxLength: number
    allowFlags?: string
    context: "whitelist" | "filter" | "smart-rule" | "test"
}): SafeRegexResult
```

All user-provided or filter-list-provided regex must go through it.

### Acceptance check

```txt
- CI fails on direct `new RegExp(userInput)` outside safe-regex.ts.
- Invalid whitelist regex does not break whitelist loading.
- Overlong regex is rejected with a diagnostic.
- Smart-rule regex and whitelist regex use the same reporting model.
```

---

## P0.25 Add a central storage-key and schema registry

### Problem

The service worker uses many storage keys directly. A storage migration registry is useful, but it still needs a typed source of truth for key names, ownership, schema version, default value, privacy class, and invalidation behavior.

### Files

```txt
src/js/storage/storage-registry.ts
platform/chromium/js/sw.js
tools/check-storage-registry.mjs
tests/storage/storage-registry.spec.ts
```

### Generalized fix

Create a registry:

```ts
type StorageEntry = {
    key: string
    owner: "policy" | "filters" | "cosmetic" | "smart" | "popup" | "logger" | "migration"
    version: number
    defaultValue: unknown
    privacy: "local-only" | "may-contain-url" | "may-contain-selector" | "safe"
    invalidates: Array<"page-policy" | "dnr" | "cosmetic" | "popup" | "logger">
}
```

Handlers must import keys from the registry instead of using inline strings.

### Acceptance check

```txt
- CI fails on new chrome.storage.local.get/set string keys not present in the registry.
- Every key has a default value and owner.
- Changing selected filter lists invalidates the policy/DNR/cosmetic caches through registry metadata.
```

---

## P0.26 Add a MAIN-world injection allowlist registry

### Problem

MAIN-world scripts are high-risk because they interact with page JavaScript directly. The manifest has MAIN-world entries for specific cases. Future additions should not be allowed by pattern drift or convenience.

### Files

```txt
platform/chromium/manifest.json
tools/check-main-world-injection-policy.mjs
src/js/runtime/main-world-policy.ts
tests/runtime/main-world-policy.spec.ts
```

### Generalized fix

Create a registry:

```ts
type MainWorldEntry = {
    file: string
    allowedHosts: string[]
    reason: string
    owner: string
    expires?: string
    testFixture: string
}
```

Release checks compare manifest MAIN-world entries against this registry.

### Acceptance check

```txt
- CI fails if manifest contains `world: MAIN` for a file not in the registry.
- CI fails if a MAIN-world entry uses http://*/* or https://*/*.
- Each MAIN-world file has a reason and regression test.
```

---

## P0.27 Add structured error codes and recovery actions

### Problem

Many handlers return raw strings such as `Unhandled ...` or `Failed to fetch ...`. This makes diagnostics hard to generalize and makes UI recovery inconsistent. A general extension needs errors that can be grouped, counted, shown to the user, and mapped to safe fallback behavior.

### Files

```txt
src/js/errors/error-codes.ts
platform/chromium/js/sw.js
src/js/logger/*
src/js/popup/*
tests/runtime/error-codes.spec.ts
```

### Generalized fix

Use structured errors everywhere:

```ts
type UbrError = {
    ok: false
    code: "E_UNKNOWN_CHANNEL" | "E_BAD_MESSAGE" | "E_POLICY_DENIED" | "E_REMOTE_FETCH_DENIED" | "E_RULE_REJECTED"
    layer: "sw" | "content" | "dnr" | "cosmetic" | "video" | "smart"
    recoverable: boolean
    recovery?: "disable-layer" | "reload-tab" | "open-logger" | "do-nothing"
}
```

### Acceptance check

```txt
- No handler returns raw `{ error: string }` unless wrapped by makeError().
- UI can show a short user-facing reason without parsing strings.
- Logger groups failures by code.
```

---

## P0.28 Add a per-layer shutdown contract

### Problem

Some layers create observers, timers, listeners, injected CSS, markers, and cached tab state. The backlog already includes lifecycle cleanup, but each runtime layer should also have the same local interface so shutdown can be verified mechanically.

### Files

```txt
src/js/runtime/layer-contract.ts
src/js/video-adblock/video-engine.ts
src/js/contentscript/*
src/core/smart-cosmetic/smart-runtime.ts
tests/runtime/layer-shutdown.spec.ts
```

### Generalized fix

Every runtime layer implements:

```ts
type RuntimeLayer = {
    id: string
    start(policy: PagePolicy): Promise<void> | void
    stop(reason: string): Promise<void> | void
    status(): { active: boolean; observers: number; timers: number; mutations: number }
}
```

The bootstrap owns start/stop sequencing.

### Acceptance check

```txt
- Toggling off cosmetic filtering leaves zero cosmetic observers and zero injected CSS.
- Toggling off video layer leaves zero video observers/timers and restores hidden elements.
- Trusted-site transition calls stop() for every active layer.
```

---

## P0.29 Add reversibility metadata to every mutating action

### Problem

Hide/remove/click/neutralize/mute actions do not all have the same reversibility model. A general safe-mode and recovery system needs to know which actions can be undone and which are permanent for the page session.

### Files

```txt
src/js/runtime/action-types.ts
src/js/video-adblock/safe-actions.ts
src/core/smart-cosmetic/*
src/js/contentscript/*
tests/runtime/action-reversibility.spec.ts
```

### Generalized fix

Represent each mutation as:

```ts
type PageAction = {
    layer: string
    action: "hide" | "remove" | "neutralize-click" | "click" | "mute" | "insert-css"
    targetKind: "element" | "selector" | "request" | "prototype" | "css"
    reversible: boolean
    rollback?: () => void
    evidence: string[]
    policyToken: string
}
```

### Acceptance check

```txt
- Every mutating function emits PageAction metadata.
- Safe mode can roll back all reversible actions.
- Non-reversible actions require higher policy confidence and are logged separately.
```

---

## P0.30 Add manifest/content-script drift checks

### Problem

Generated and source code can say one thing while the manifest injects another. This creates hidden runtime behavior. The release gates should verify that content-script entries, generated bundles, source ownership, and runtime-layer registry all agree.

### Files

```txt
tools/check-content-script-drift.mjs
platform/chromium/manifest.json
build.mjs
src/js/runtime/layer-registry.ts
```

### Generalized fix

Check:

```txt
- every content script JS file appears in the runtime layer registry
- every generated content script points back to a source file
- every all_frames script has a frame-policy entry
- every match_about_blank script has an inheritance policy
- every excluded host list is sourced from a fixture/compatibility registry, not manually duplicated
```

### Acceptance check

```txt
- CI fails when a manifest content script has no registry entry.
- CI fails when source says generated but the file lacks source metadata.
- CI fails when generated output is stale relative to source.
```

---

## P1.23 Add a policy-aware CSS selector compiler

### Problem

Selector handling exists in multiple forms: generic cosmetic selectors, specific selectors, procedural selectors, YouTube protected selector sanitization, smart cosmetic selectors, and user-created selectors. A general system should classify selector risk once.

### Files

```txt
src/js/cosmetic/selector-compiler.ts
src/js/contentscript/*
src/core/smart-cosmetic/*
tests/cosmetic/selector-compiler.spec.ts
```

### Generalized fix

Create a selector compiler that returns:

```ts
type CompiledSelector = {
    selector: string
    source: "filter-list" | "user" | "smart" | "generated"
    specificity: "generic" | "site-specific" | "entity-specific"
    procedural: boolean
    protectedUiRisk: "none" | "possible" | "high"
    pageRootRisk: boolean
    allowedByPolicy: boolean
}
```

### Acceptance check

```txt
- Generic selectors cannot target protected UI.
- Procedural selectors are disabled on unknown app pages unless policy allows them.
- YouTube-specific sanitizer becomes one protected-UI fixture, not a special path.
```

---

## P1.24 Add a filter-list capability manifest

### Problem

Filter lists are treated mostly as sources of rules. A general system should also know what each list is allowed to contribute: network rules, generic cosmetic rules, scriptlets, procedural cosmetics, redirects, or trusted rules.

### Files

```txt
assets/assets.json
src/js/filters/filter-list-capabilities.ts
platform/chromium/js/sw.js
tests/filters/filter-list-capabilities.spec.ts
```

### Generalized fix

Add metadata:

```ts
type FilterListCapability = {
    key: string
    canNetworkBlock: boolean
    canGenericCosmetic: boolean
    canProceduralCosmetic: boolean
    canScriptlet: boolean
    canRedirect: boolean
    trustLevel: "core" | "community" | "user" | "unknown"
}
```

### Acceptance check

```txt
- Imported custom lists default to low trust.
- Low-trust lists cannot install scriptlets or high-risk DNR without user confirmation.
- UI shows when a selected list contains disabled high-risk capabilities.
```

---

## P1.25 Add domain/entity normalization using a public suffix boundary

### Problem

Several pieces of code approximate registered-domain behavior by slicing the last two hostname labels. That fails for domains such as `co.uk`, `com.au`, and many private suffixes. This causes policy and smart-rule matching to over-match or under-match.

### Files

```txt
src/js/utils/domain-normalizer.ts
src/core/smart-cosmetic/engine.ts
platform/chromium/js/sw.js
tests/domain/domain-normalizer.spec.ts
```

### Generalized fix

Create one domain normalizer:

```ts
type DomainParts = {
    hostname: string
    registrableDomain: string
    subdomain: string
    publicSuffix: string
    entityCandidates: string[]
}
```

All policy, smart-rule, whitelist, firewall, and logger code uses it.

### Acceptance check

```txt
- `foo.example.co.uk` resolves to registrable domain `example.co.uk`.
- Smart-rule domain target does not overmatch unrelated same-TLD sites.
- Firewall and popup domain display use the same normalized result.
```

---

## P1.26 Add privacy classes to logger events

### Problem

Logger and diagnostics need to explain decisions, but generalized diagnostics can accidentally collect URLs, selectors, text snippets, or rule contents. A privacy classification layer lets the extension be more useful without increasing data risk.

### Files

```txt
src/js/logger/event-schema.ts
src/js/logger/*
platform/chromium/js/sw.js
tools/check-logger-privacy.mjs
```

### Generalized fix

Each event has:

```ts
type LoggerPrivacyClass =
    | "counter-only"
    | "hostname-only"
    | "url-redacted"
    | "selector-redacted"
    | "full-debug-local-only"
```

### Acceptance check

```txt
- Release mode defaults to hostname-only or url-redacted.
- Full URL logging requires explicit local debug mode.
- CI fails if a logger event has no privacy class.
```

---

## P1.27 Add a regression-fixture generator from compatibility metadata

### Problem

Compatibility metadata is useful only if it produces tests. Otherwise it becomes another list that drifts. Each temporary exception should generate a synthetic or recorded fixture entry.

### Files

```txt
compat/compatibility-registry.json
tools/generate-compat-fixtures.mjs
tests/compat/*
```

### Generalized fix

For every compatibility entry, generate:

```txt
- one page-policy fixture
- one DNR safety fixture
- one content-script activation fixture
- one “exception no longer needed” reminder
```

### Acceptance check

```txt
- CI fails if a compatibility entry has no generated fixture.
- CI fails if an expired compatibility entry still affects manifest or policy.
```

---

## P1.28 Add a central build graph for generated runtime files

### Problem

There are generated files, canonical files, inactive prototype files, and release-generated manifests. Existing checks catch some ownership issues, but a build graph would make generated/runtime relationships explicit.

### Files

```txt
build-graph.json
tools/check-build-graph.mjs
build.mjs
tools/generate-release-manifest.mjs
tools/check-source-ownership.mjs
```

### Generalized fix

Create a graph:

```json
{
  "platform/chromium/js/video-adblock-generic.js": {
    "source": "src/js/video-adblock/index.ts",
    "command": "npm run build",
    "runtime": true,
    "generated": true
  }
}
```

### Acceptance check

```txt
- CI fails if runtime generated output is stale.
- CI fails if a generated runtime file lacks a source.
- CI shows which command regenerates each artifact.
```

---

## P2.14 Add a cross-layer integration matrix

### Problem

Many bugs are not inside one layer. They happen when DNR, content scripts, video logic, smart cosmetic rules, and popup switches interact. A generalization backlog needs a matrix that tests combinations, not just files.

### Files

```txt
tests/integration/policy-matrix.spec.ts
tools/generate-policy-matrix.mjs
```

### Generalized fix

Generate tests for combinations:

```txt
trusted site + video tag + generic cosmetic selector
unknown app + websocket + smart rule active
known video site + generic video adapter + specific DNR
custom user filter + protected UI selector
net filtering off + cosmetic filtering on/off
all_frames child frame + inherited parent policy
```

### Acceptance check

```txt
- Every runtime layer appears in at least one cross-layer test.
- Every popup switch appears in at least one cross-layer test.
- Unknown complex app fixtures remain functional under all default policies.
```

---

## P2.15 Add a policy-diff preview before applying dangerous settings

### Problem

User actions such as enabling imported lists, toggling scriptlets, saving firewall rules, or activating smart rules can substantially change behavior. A general system should preview what capabilities will change before applying them.

### Files

```txt
src/js/policy/policy-diff.ts
src/js/popup/*
src/js/dashboard/*
platform/chromium/js/sw.js
tests/policy/policy-diff.spec.ts
```

### Generalized fix

Before applying a change, compute:

```ts
type PolicyDiff = {
    addedCapabilities: string[]
    removedCapabilities: string[]
    newlyHighRiskRules: number
    affectedHosts: string[]
    rollbackAvailable: boolean
}
```

### Acceptance check

```txt
- Enabling a custom list shows whether scriptlets/procedural cosmetics are included.
- Activating a smart rule shows affected target hosts.
- Dangerous settings can still be applied, but only after explicit confirmation.
```

---

## P2.16 Add a local-only compatibility recorder

### Problem

Manual debugging is slow. A general local recorder can collect policy decisions, blocked rules, active layers, and recovery events for the current tab without uploading anything.

### Files

```txt
src/js/diagnostics/local-recorder.ts
platform/chromium/js/sw.js
src/js/logger/*
tests/diagnostics/local-recorder.spec.ts
```

### Generalized fix

Recorder captures:

```txt
page policy snapshot
active runtime layers
DNR matched rule ids
mutating actions with reversibility metadata
errors with structured codes
recovery actions
```

### Acceptance check

```txt
- Recorder is off by default.
- Recorder data is local-only and redacted by privacy class.
- Export includes enough information to reproduce a compatibility fixture.
```

---

## P3.11 Add “implementation slicing” to every backlog item

### Problem

Some backlog items are large. They should include a first small slice so work can start without waiting for a full rewrite.

### Files

```txt
docs/generalization/*
```

### Generalized fix

Every item gets:

```txt
first slice
full target
acceptance check
rollback plan
```

### Acceptance check

```txt
- CI/docs check fails if a backlog item has no first slice.
- Large P2/P3 items can be started as P0/P1 slices.
```

---

## P3.12 Add code-owner labels by risk layer

### Problem

As the extension grows, files should be grouped by risk layer rather than only by directory. This helps reviews focus on what can break apps.

### Files

```txt
.github/CODEOWNERS
risk-owners.json
tools/check-risk-owners.mjs
```

### Generalized fix

Risk layers:

```txt
network
cosmetic
procedural-cosmetic
scriptlet
main-world
video
smart-cosmetic
storage
messaging
diagnostics
release
```

### Acceptance check

```txt
- Every runtime file maps to a risk layer.
- CI fails if a high-risk file has no owner/risk label.
- Pull request template asks which risk layers changed.
```

---

## P3.13 Add a “patch-to-generalization” review checklist

### Problem

A contributor may add a hostname exception because it is the quickest fix. That can be acceptable, but the PR should also say what general mechanism will eventually remove it.

### Files

```txt
.github/pull_request_template.md
docs/review/patch-to-generalization-checklist.md
```

### Generalized fix

Checklist:

```txt
Is this a host-specific patch?
What general risk classifier should cover it?
What fixture was added?
Does it expire?
What backlog item will remove it?
```

### Acceptance check

```txt
- PR template includes the checklist.
- Compatibility entries require a linked backlog item.
- Review fails if a new exception has no fixture and no expiration.
```


## Update YYYY-MM-DD — <short title>

### Problem generalized

### Files changed

### New primitive added

### Site-specific patches removed or made unnecessary

### Regression tests added

### Remaining gaps
```

---

# v5 pass: post-`ca353def57eacc103871afe919bc845b87502ce2` generalization review

## What changed in the repo

The commit implements or scaffolds many of the earlier P1/P2 ideas:

```txt
page classifier
page signal collector
policy DSL config
runtime-layer activation protocol
observer budgets
capability tokens
auto-recovery
DNR install decision records
DNR transaction helper
rule/action simulator
browser capability profile config
compatibility debt dashboard
policy diff and local compatibility recorder tooling
```

This is a strong shift in the correct direction. The next work should not add another broad wishlist. It should connect, harden, and verify these new primitives so they actually replace host-specific patching in runtime.

The main v5 finding:

```txt
The repo now has the right primitives, but several are still scaffold-level:
- present as files but not necessarily authoritative;
- not fully wired into the manifest-selected runtime;
- not schema-validated;
- not always fail-closed in CI;
- not yet forcing old layers to go through the new policy/activation/capability path.
```

Therefore the highest-priority work is now:

```txt
make the new generalization primitives mandatory
make bypasses fail CI
make policy config the single source of truth
make runtime layers prove they obey the policy before mutating anything
```

---

## P0.40 Make the new post-ca353 checks fail-closed, not advisory

### Why this matters

The new cross-layer integration check is exactly the right kind of generalized gate, but it must fail when a layer is missing, unwired, or dependent on a missing primitive. A check that only prints warnings does not prevent regressions.

### Current risk pattern

```txt
tools/check-cross-layer-integration.mjs
```

Issues to generalize:

```txt
- Known layers are listed manually.
- Missing dependencies currently produce warnings.
- The `failed` flag is initialized but not consistently set.
- The dependency path references `srcDir`, while the file defines `runtimeDir`.
- The script can print "Done" even when the wiring is incomplete.
```

### Generalized fix

Create a reusable check pattern:

```txt
check-fails-on-violation.mjs
check-layer-registry.mjs
check-new-generalization-primitives-wired.mjs
```

Rules:

```txt
- Any missing required layer = fail.
- Any missing required dependency = fail.
- Any content script in manifest without a runtime registry entry = fail.
- Any runtime file that self-starts without registerLayer() = fail.
- Any new check script that only warns must be marked advisory and excluded from check:all.
```

### Acceptance check

```txt
npm run check:cross-layer-integration
```

must fail on a synthetic fixture where:

```txt
- video layer is removed from the registry;
- smart-content starts without runtime-layer;
- a manifest content script has no registered layer;
- a dependency path typo exists.
```

---

## P0.41 Make `config/page-policy.json` the actual policy source of truth

### Why this matters

The repo now has a declarative policy file, but the runtime policy resolver still contains inline policy constants and host-support logic. That creates two policy systems:

```txt
config/page-policy.json
platform/chromium/js/policy-resolver.js
```

That is dangerous because the JSON can say one thing and the active runtime can do another.

### Generalized fix

Introduce a policy compiler/loader:

```txt
tools/compile-page-policy.mjs
platform/chromium/js/compiled-page-policy.js
src/js/runtime/page-policy-schema.ts
```

The flow should be:

```txt
config/page-policy.json
  -> schema validation
  -> normalized nested policy object
  -> generated runtime module
  -> policy-resolver imports generated policy
```

Do not let `policy-resolver.js` define a second independent truth.

### Acceptance check

```txt
- Changing `config/page-policy.json` changes the generated runtime policy.
- CI fails if policy-resolver hardcodes a profile that is absent from JSON.
- CI fails on duplicate keys or mixed flat/nested policy shapes.
- CI fails if `policy-resolver.js` contains a hardcoded profile allowlist.
```

---

## P0.42 Normalize policy shape before any layer can read it

### Problem

The new JSON policy uses dotted keys:

```txt
"cosmetic.generic": false
"video.allowMutation": false
"network.highRiskResources": "specific-only"
```

Other runtime code expects nested objects:

```txt
policy.cosmetic.generic
policy.video.allowMutation
policy.network.highRiskResources
```

If this is not normalized at one boundary, each layer will add its own compatibility handling.

### Generalized fix

Add:

```txt
src/js/runtime/normalize-policy.ts
```

It should convert these forms:

```txt
{ "cosmetic.generic": false }
```

into:

```txt
{ cosmetic: { generic: false } }
```

and reject ambiguous mixtures:

```txt
{
  "cosmetic.generic": false,
  "cosmetic": { "generic": true }
}
```

### Acceptance check

```txt
- Every policy object passes normalizePolicy() exactly once.
- Layers receive only the normalized shape.
- CI fails if a layer reads dotted policy keys directly.
```

---

## P0.43 Remove duplicate policy keys from runtime objects

### Problem

Policy objects should be mechanically checkable. If an object contains duplicate keys or legacy aliases that silently overwrite earlier values, automated reasoning becomes unreliable.

A specific risk pattern is returning both:

```txt
contentScript: POLICY_NETWORK_OFF
contentScript: getNestedContentScript(...)
```

in the same object shape.

### Generalized fix

Add:

```txt
tools/check-no-duplicate-policy-keys.mjs
src/js/runtime/policy-object-contract.ts
```

Rules:

```txt
- No duplicate object keys in policy resolver code.
- No field may be both a legacy scalar and nested object under the same key.
- Backward-compatible aliases must live under `legacy`, not beside canonical fields.
```

Example canonical shape:

```txt
{
  network: { mode: "safe", highRiskResources: "specific-only" },
  cosmetic: { specific: true, generic: false, procedural: false, smart: false },
  video: { mode: "observe-only", allowMutation: false },
  scriptlets: { mode: "off", mainWorldHooks: false },
  contentScript: { enabled: true, bootstrapOnly: true },
  instrumentation: { webRequestTracking: false },
  legacy: { cosmeticFilteringEnabled: true }
}
```

### Acceptance check

```txt
- A duplicate `contentScript` key fails CI.
- A mixed scalar/object policy field fails CI.
- Existing callers use the canonical nested form.
```

---

## P0.44 Replace hardcoded “established filter support” hosts with evidence-derived support

### Problem

The new policy resolver still has a named support set for sites that receive the full pipeline.

That is better than unlimited global activation, but it is still a host list. If the goal is generalization, named hosts should move toward fixtures and measured support evidence.

### Generalized fix

Replace:

```txt
ESTABLISHED_FILTER_SUPPORT_HOSTS
```

with an evidence-derived function:

```txt
hasEstablishedFilterSupport(hostname, evidence)
```

Evidence can come from:

```txt
- compiled list contains specific cosmetic/network rules for this eTLD+1;
- site has known adapter registered;
- simulator returns low breakage risk;
- compatibility corpus has a passing profile;
- user explicitly enabled full mode for this profile/domain.
```

Named hosts can remain only here:

```txt
tests/fixtures/compatibility-sites.json
config/compatibility-sites.json
```

### Acceptance check

```txt
- No production policy file contains a static full-pipeline host allowlist.
- YouTube/Yandex/etc. can still become full-pipeline through evidence.
- Unknown video sites remain known-adapter-only or observe-only until evidence exists.
```

---

## P0.45 Wire page classification into the active runtime, not only source modules

### Problem

The repo now has:

```txt
src/js/runtime/page-signals.ts
src/js/runtime/page-classifier.ts
config/page-policy.json
```

But the active extension path still depends on the manifest-selected service worker and globally injected content scripts. A classifier only helps if the active runtime actually calls it before loading or activating risky layers.

### Generalized fix

Create a single active flow:

```txt
content bootstrap
  -> collect structural page signals
  -> send signals to SW
  -> SW resolves profile + policy
  -> SW returns policy snapshot + revision
  -> runtime-layer activates only allowed layers
```

No layer should read the DOM and self-start before this flow completes, except the minimal bootstrap.

### Acceptance check

```txt
- video-adblock-generic does not start before policy snapshot exists.
- smart-content does not start before policy snapshot exists.
- universal/heuristic interceptors cannot activate before policy snapshot exists.
- A test page with app-shell signals receives app-shell policy without adding a host exception.
```

---

## P0.46 Fix page-signal overclassification

### Problem

`hasLargeAppRoot` currently appears to be true if the page has any selector like:

```txt
#root, #app, #__next, main, .shell, [data-app-root]
```

This can classify ordinary sites as app-shell just because they have `<main>` or a frontend root. Also, page classification checks app-shell before video-site, so video pages with app-like roots may be downgraded unintentionally.

### Generalized fix

Replace boolean-only classification with scored classification:

```txt
profile: app-shell | auth-sensitive | payment-sensitive | video-site | article-site | default-web
confidence: 0.00-1.00
reasons: string[]
```

Signals should include ratios and thresholds:

```txt
- interactiveInputCount
- contentEditableCount
- appRootAreaRatio
- routeChangeHistoryApiPresent
- long-lived websocket/fetch signal, without reading URLs if privacy risk
- videoAreaRatio
- knownPlayerSignal
- formSensitivityScore
```

### Acceptance check

```txt
- A simple news/article page with `<main>` is not automatically app-shell.
- A video page with `#__next` and a primary video can become video-site.
- A chat-like page with contenteditable and app root becomes app-shell.
- The classifier returns reasons and confidence for debugging.
```

---

## P0.47 Make page-signal collection budgeted and privacy-audited

### Problem

Collecting structural signals is the right approach, but DOM-wide scans such as `querySelectorAll("*")` can become expensive on large SPAs. Also, the privacy boundary must be enforced by code, not comments.

### Generalized fix

Create:

```txt
src/js/runtime/page-signal-budget.ts
src/js/runtime/page-signal-privacy-guard.ts
tools/check-page-signal-privacy.mjs
```

Rules:

```txt
- No textContent, innerText, value, href query string, or form value access.
- DOM scans have max node counts and max milliseconds.
- Shadow-root detection samples bounded nodes.
- Signal collection returns `{partial: true}` when budget is exceeded.
```

### Acceptance check

```txt
- CI fails if signal code reads textContent, input.value, textarea.value, URL query strings, or localStorage/sessionStorage.
- Large DOM fixture completes within the configured budget.
- Budget overflow produces safe policy, not full filtering.
```

---

## P0.48 Make capability tokens authoritative and unforgeable

### Problem

The new capability token object is a good primitive, but if it is only a normal object created in content code, it does not actually authorize mutation. A layer could create its own token unless validation is tied to a trusted authority.

### Generalized fix

Move token minting and validation authority to the service worker or a sealed runtime authority:

```txt
platform/chromium/js/capability-authority.js
src/js/runtime/capability-token-client.ts
```

Token rules:

```txt
- Token IDs are cryptographically random, not incremental.
- Token is stored in authority state and validated by ID.
- Token is bound to tabId, frameId, documentId if available, layer, action class, and policyRevision.
- Validation checks expected tab/frame/layer/action/revision, not only layer.
- Expired or mismatched token downgrades to observe-only.
- Mutating APIs accept token IDs, not arbitrary token objects.
```

### Acceptance check

```txt
- A content script cannot forge a token by constructing an object.
- A video token cannot authorize cosmetic or response mutation.
- A token from an old policy revision fails.
- A token from a different frame fails.
```

---

## P0.49 Enforce capability tokens at the mutation boundary

### Problem

Adding tokens is not enough. Every function that can hide, remove, click, neutralize, modify response data, inject scriptlets, or install CSS must require the capability.

### Mutation boundaries

```txt
safe-actions.ts
DOMFilterer add/remove CSS paths
scriptlet injection paths
universal-ad-interceptor activation
first-party detector marker writes
video adapter action plans
chrome.scripting.executeScript / insertCSS wrappers
DNR update wrappers for high-risk rules
```

### Generalized fix

Create wrapper APIs:

```txt
mutateDomWithCapability(token, action)
installCssWithCapability(token, css)
injectScriptletWithCapability(token, scriptlet)
clickWithCapability(token, element)
updateNetworkRulesWithCapability(token, rules)
```

### Acceptance check

```txt
- No direct `.remove()`, `.style.display`, `.click()`, `insertCSS`, or `executeScript` call exists outside wrapper modules.
- CI fails on new direct mutation calls in content/runtime code.
- Tests prove expired tokens cause observe-only behavior.
```

---

## P0.50 Make auto-recovery part of policy resolution

### Problem

`auto-recovery.ts` can store safe-mode state, but safe mode must become an input to policy resolution. Otherwise a tab can be marked safe while layers continue to run as before.

### Generalized fix

Policy inputs should include:

```txt
safeMode: isTabInSafeMode(tabId)
safeModeReason
safeModeEnteredAt
navigationId / documentId
```

Safe mode policy:

```txt
network.highRiskResources = "reject"
cosmetic.generic = false
cosmetic.procedural = false
cosmetic.smart = false
video.allowMutation = false
scriptlets.mainWorldHooks = false
contentScript.loadInterceptors = false
instrumentation.webRequestTracking = false unless debugging is explicit
```

### Acceptance check

```txt
- A tab that enters safe mode gets a new policy revision.
- Runtime layers are deactivated after safe-mode entry.
- Safe mode expires on navigation or after a bounded TTL.
- Safe mode can be inspected locally without remote reporting.
```

---

## P0.51 Fix DNR transaction rollback semantics

### Problem

The new transaction helper snapshots rules, but rollback must remove whatever partial new state was installed before re-adding the snapshot. Restoring by adding snapshot rules without clearing current rules can fail because duplicate IDs or leftover rules may remain.

Also, unused remove ID variables are a signal that the transaction design is not finished.

### Generalized fix

Transaction flow:

```txt
snapshot current dynamic/session rules
compute current IDs before each restore
try remove all current dynamic/session rules
try add snapshot rules
verify exact rule-id set equals snapshot
if restore fails, clear all dynamic/session rules and enter degraded allow mode
record transaction report
```

All DNR updates should go through:

```txt
updateDnrTransaction({ dynamic, session, reason, source, policyRevision })
```

### Acceptance check

```txt
- Unit test: dynamic update fails halfway; old rule set is exactly restored.
- Unit test: session update fails after dynamic succeeds; both stores restore.
- Unit test: rollback fails; all rules are cleared and degraded allow mode is recorded.
- CI fails if code calls chrome.declarativeNetRequest.updateDynamicRules directly outside the transaction module, except in the transaction module itself and explicit tests.
```

---

## P0.52 Make DNR install decisions bounded, queryable, and privacy-classified

### Problem

The install-decision module records decision objects in memory. That is useful, but it must not become an unbounded or privacy-risky log. It also needs to record rejected decisions, not only installed rules, because rejections explain why a rule did not run.

### Generalized fix

Decision record contract:

```txt
id
ruleId
ruleClass: dynamic | session | static | redirect | allow | block
sourceListId
sourceListTitle
filterHash
rawFilter: dev-only, never release logs
resourceTypes
risk
specificity
decision: installed | rejected | downgraded | observe-only | skipped
reason
policyRevision
timestamp
```

Storage:

```txt
- bounded ring buffer, e.g. last 1000 decisions;
- release build stores hashes, not raw filters;
- dev build may expose raw filters locally;
- records cleared on policy/schema migration.
```

### Acceptance check

```txt
- Rejected high-risk rules appear in the decision report.
- Release artifact contains no raw filter text unless explicitly dev-only.
- Ring buffer cannot exceed configured size.
- Logger UI can look up why a visible request was blocked, allowed, or skipped.
```

---

## P0.53 Make compatibility debt dates real and self-expiring

### Problem

Compatibility entries now have owners, replacements, and expiration dates, which is good. However, stale or placeholder dates turn the dashboard into noise. If the current date is after an entry's expiration, the build should force a decision:

```txt
remove exception
extend with reason
convert to fixture only
complete replacement generalization item
```

### Generalized fix

Compatibility debt lifecycle:

```txt
temporary -> fixture-only -> removed
```

Each entry needs:

```txt
site
layers
reason
replacementItem
owner
createdAt
expiresAt
status
lastVerifiedAt
fixturePath
removalPlan
```

### Acceptance check

```txt
- Expired temporary entries fail CI.
- Extending an entry requires a new lastVerifiedAt and reason.
- A compatibility entry cannot exist without a fixture path.
- Host exceptions in manifest must correspond to compatibility entries.
```

---

## P0.54 Prevent manifest exceptions from drifting away from compatibility metadata

### Problem

The manifest still contains explicit host exclusions in content-script declarations. If exclusions exist, they must be treated as compatibility debt, not as hidden policy.

### Generalized fix

Add:

```txt
tools/check-manifest-compatibility-sync.mjs
```

Rules:

```txt
- Every exclude_matches host must exist in compatibility-sites.json.
- Every compatibility entry must identify the manifest/content layer it affects.
- Every exclude_matches entry must have an expiration/replacement.
- If a site is removed from compatibility config but still excluded in manifest, CI fails.
```

### Acceptance check

```txt
- Removing chatgpt.com from compatibility-sites.json while it remains in manifest fails CI.
- Adding yandex.com to manifest exclude_matches without metadata fails CI.
```

---

## P0.55 Ensure new generalization checks are actually included in `check:all`

### Problem

Adding a tool is not enough. A generalization check only protects the project if it is included in the standard verification path, or clearly marked as advisory.

### Generalized fix

Create:

```txt
tools/check-generalization-gate-coverage.mjs
config/generalization-checks.json
```

Each check has:

```txt
name
script
category: policy | runtime | dnr | compatibility | privacy | manifest | migration
requiredIn: check:base | check:runtime | check:functional | check:security | advisory
```

### Acceptance check

```txt
- New files under tools/check-*.mjs must appear in package scripts.
- Required generalization checks must be reachable from check:all.
- Advisory checks must explicitly say why they are advisory.
```

---

## P1.40 Replace boolean page profiles with confidence-scored policy inputs

### Problem

A single page can be several things at once:

```txt
video app-shell
auth inside app-shell
payment inside SPA
article with embedded video
chat app with player preview
```

Returning only one profile can hide important risk signals.

### Generalized fix

Use:

```ts
type PageClassification = {
  primaryProfile: PageProfile;
  profiles: Record<PageProfile, number>;
  confidence: number;
  reasons: string[];
  safeDefaultReason?: string;
};
```

Then policy resolver combines risk signals:

```txt
payment-sensitive dominates network/scriptlet risk
auth-sensitive disables response mutation
video-site enables only known-adapter video mutation
app-shell disables generic/procedural/smart cosmetics
article-site allows conservative generic cosmetics
```

### Acceptance check

```txt
- Mixed-profile fixtures produce predictable combined policy.
- No profile can accidentally re-enable a layer disabled by a higher-risk profile.
- Classifier output is explainable in local diagnostics.
```

---

## P1.41 Add an `article-site` / `document-site` profile

### Problem

Without an article/document profile, the resolver has to choose between app-shell and default-web. Many ordinary pages have `<main>`, `#__next`, or `.app`, but are still safe for normal cosmetic filtering.

### Generalized fix

Add profiles:

```txt
article-site
document-site
search-results
commerce-listing
media-gallery
```

Start with only `article-site` if keeping scope small.

Article-site policy:

```txt
cosmetic.generic = true
cosmetic.procedural = limited
cosmetic.smart = limited or false
video.allowMutation = false unless known player
scriptlets.mainWorldHooks = false by default
network.highRiskResources = specific-only
```

### Acceptance check

```txt
- News/article fixture with `<main>` is not app-shell.
- Blog/documentation fixture gets article-site policy.
- App-shell fixture still disables risky cosmetics.
```

---

## P1.42 Make browser capabilities runtime-verified, not only configured

### Problem

A browser capability config is useful, but actual browser support can vary by version, channel, enterprise policy, or permissions granted by the user.

### Generalized fix

Create:

```txt
platform/chromium/js/browser-capability-detector.js
src/js/runtime/browser-capability-snapshot.ts
```

Flow:

```txt
static config gives expected capability
runtime probe verifies actual capability
policy resolver uses intersection of expected and actual
```

Capabilities to probe:

```txt
chrome.declarativeNetRequest session/dynamic rule support
available rule limits where possible
chrome.scripting.insertCSS
chrome.scripting.executeScript
permissions.contains origins
webRequest availability
documentId/frameId support
```

### Acceptance check

```txt
- If a capability is missing at runtime, policy degrades safely.
- Browser profile mismatch is visible in local diagnostics.
- Tests can simulate missing DNR/session rules and prove fallback is safe.
```

---

## P1.43 Use the simulator as a mandatory preflight, not just a library

### Problem

A simulator is only protective if rule/cosmetic/video/scriptlet candidates must pass through it before activation.

### Generalized fix

Preflight flow:

```txt
candidate actions
  -> simulateActions()
  -> allowed / rejected / observeOnly
  -> capability tokens only minted for allowed actions
  -> rejected and observeOnly actions recorded in install/action decisions
```

### Acceptance check

```txt
- Video adapter action plans are simulated before mutation.
- Cosmetic selector batches are simulated before CSS insertion.
- Scriptlets are simulated before injection.
- High-risk DNR candidates are simulated before install.
- CI fails if action paths bypass simulator/preflight wrappers.
```

---

## P1.44 Make runtime-layer registry frame-aware and document-aware

### Problem

`activateLayersForTab(tabId, policy, context)` is too coarse for pages with iframes, about:blank frames, embedded players, and dynamic navigation. A layer should be activated for a specific tab + frame + document + policy revision.

### Generalized fix

Change activation context:

```ts
type RuntimeContext = {
  tabId: number;
  frameId: number;
  documentId?: string;
  url: string;
  topUrl: string;
  profile: PageClassification;
  policy: NormalizedPolicy;
  policyRevision: number;
};
```

Layer lifecycle:

```txt
canStart(context)
start(context)
pause(reason)
stop(reason)
onPolicyChange(oldPolicy, newPolicy)
onNavigation(newDocumentId)
```

### Acceptance check

```txt
- Same tab can have different frame policies.
- about:blank child frame inherits safe parent policy.
- SPA navigation updates policy revision without duplicating observers.
- Layer stop receives enough context to clean only its own frame/document.
```

---

## P1.45 Add a runtime-bypass inventory

### Problem

After ca353, the repo contains both new generalized primitives and older direct runtime paths. The highest risk is not the absence of primitives; it is bypassing them.

### Generalized fix

Create a generated inventory:

```txt
dist/build/certificate/runtime-bypass-inventory.json
```

Track direct usage of:

```txt
MutationObserver
setInterval / setTimeout long loops
chrome.scripting.executeScript
chrome.scripting.insertCSS
chrome.declarativeNetRequest.updateDynamicRules
chrome.declarativeNetRequest.updateSessionRules
element.remove / element.click / style mutation
fetch/XHR monkey-patching
Object.defineProperty(responseText/response)
```

Every entry must state:

```txt
file
line
risk layer
allowed wrapper
reason
owner
```

### Acceptance check

```txt
- New direct mutation/network/script injection APIs fail CI unless allowlisted with owner and wrapper plan.
- The allowlist expires or maps to a backlog item.
```

---

## P1.46 Convert compatibility entries into generated regression fixtures

### Problem

Compatibility metadata is useful, but it should automatically produce tests. Otherwise the same known-broken class can come back after the exception is removed.

### Generalized fix

For each compatibility site, generate fixture requirements:

```txt
app-shell fixture
contenteditable fixture
auth form fixture
primary video fixture
large DOM fixture
shadow DOM fixture
network critical-path fixture
```

Do not fetch live sites in CI. Use synthetic structures derived from the risk pattern.

### Acceptance check

```txt
- Every compatibility entry has at least one generated fixture.
- Removing an exception requires the fixture to pass under generalized policy.
- Fixture names describe the risk pattern, not the brand/site name only.
```

---

## P1.47 Add policy migration/versioning

### Problem

The DNR schema is versioned, but the policy DSL, browser capability config, compatibility debt config, and runtime layer registry now also need versioning.

### Generalized fix

Version these artifacts:

```txt
config/page-policy.json
config/browser-capabilities.json
config/compatibility-sites.json
runtime-layer registry schema
capability token schema
page classification schema
```

Migration path:

```txt
read config version
migrate if known old version
reject unknown future version
clear stale policy snapshots/tokens on migration
record migration evidence
```

### Acceptance check

```txt
- Unknown policy schema version fails safe.
- Old policy snapshots are invalidated after migration.
- Capability tokens minted under old schema fail validation.
```

---

## P1.48 Add a typed message for policy snapshots

### Problem

The control plane currently has many message channels. Policy snapshots should be a typed, auditable message contract because every runtime layer depends on it.

### Generalized fix

Message contract:

```ts
type GetPolicySnapshotRequest = {
  channel: "runtimePolicy";
  what: "getPolicySnapshot";
  tabId: number;
  frameId: number;
  documentId?: string;
  url: string;
  topUrl: string;
  pageSignals: PageSignals;
};

type GetPolicySnapshotResponse = {
  ok: true;
  policyRevision: number;
  profile: PageClassification;
  policy: NormalizedPolicy;
  tokens?: CapabilityTokenGrant[];
};
```

### Acceptance check

```txt
- Runtime layers cannot call generic dashboard/vapi channels to get policy.
- Sender tab/frame must match the request.
- Invalid message shape returns typed error and safe default.
```

---

## P2.40 Replace manifest-wide content scripts with policy-loaded modules

### Problem

The manifest still injects large content/runtime bundles on broad URL matches. That means the decision to load code still happens before policy classification.

This was already identified in earlier versions, but ca353 makes the next step clearer: now that classifier, policy DSL, runtime-layer, and tokens exist, broad injection should become only a bootstrap.

### Generalized fix

Manifest loads:

```txt
/js/bootstrap.js
```

Bootstrap does only:

```txt
- collect bounded structural signals;
- request policy snapshot;
- dynamically import or request injection of allowed modules;
- pass capability token grants;
- register lifecycle cleanup.
```

Risky modules are no longer manifest-loaded globally:

```txt
contentscript.js
smart-content.js
video-adblock-generic.js
universal-ad-interceptor.js
first-party-ad-detector.js
```

### Acceptance check

```txt
- On app-shell fixture, only bootstrap runs.
- On known video fixture, video layer loads through runtime-layer.
- Manifest `exclude_matches` shrinks because policy handles app safety.
- CI fails if a high-risk bundle is manifest-injected on http://*/* or https://*/*.
```

---

## P2.41 Build a policy debugger for local diagnosis

### Problem

General policy systems are harder to debug than host exceptions. Developers need to see why a page got a profile and why a layer was allowed, rejected, or downgraded.

### Generalized fix

Local-only debugger view:

```txt
profile
confidence
classification reasons
policy revision
safe-mode status
active layers
blocked/rejected/observe-only actions
capability grants
DNR install decisions
compatibility debt entry if present
```

### Acceptance check

```txt
- No remote reporting.
- No text content/form values/query strings are shown.
- Debugger can explain why ChatGPT/Grok/Suno/Yandex-style fixtures were protected without a hardcoded patch.
```

---

## P2.42 Add classifier drift tests

### Problem

Once classification drives policy, a small classifier change can silently move many pages from safe defaults to full filtering.

### Generalized fix

Create a corpus:

```txt
tests/fixtures/page-profiles/
```

Include:

```txt
article-basic
article-with-video
spa-dashboard
chat-contenteditable
auth-login
payment-checkout
video-known-player
video-unknown-player
large-shadow-dom-app
search-results
commerce-listing
```

For each fixture:

```txt
expected profile scores
expected policy fields
expected active layers
expected denied capabilities
```

### Acceptance check

```txt
- Classifier changes produce a readable diff.
- Full filtering cannot become enabled for app/auth/payment fixtures without explicit snapshot update.
```

---

## P2.43 Make “known adapter” a registry with evidence, not a boolean

### Problem

The policy now talks about known-adapter-only video mutation. That needs a formal registry; otherwise every adapter defines “known” differently.

### Generalized fix

Create:

```txt
src/js/video-adblock/adapter-registry.ts
config/video-adapters.json
```

Each adapter declares:

```txt
id
scope: exact-host | profile | structural-signal
mutationClasses: hide | click | remove | neutralize | response
confidenceThreshold
requiredSignals
protectedSelectors
fixtures
owner
```

### Acceptance check

```txt
- Wildcard adapters cannot mutate unless registry grants structural-signal evidence.
- Adapter confidence thresholds are tested.
- Unknown adapters run observe-only.
```

---

## P2.44 Turn local compatibility recorder into a reproduction artifact

### Problem

A local recorder that groups decisions by domain is useful, but generalization needs reproducible risk patterns, not just domain history.

### Generalized fix

Recorder output should include:

```txt
page profile
policy snapshot hash
active layers
blocked/rejected/observe-only counts
safe-mode transitions
breakage signals
compatibility entry link
fixture suggestion
```

It should not include:

```txt
full URLs with query strings
page text
form values
user account identifiers
raw request bodies
```

### Acceptance check

```txt
- Recorder can generate a synthetic fixture stub from a local broken page.
- Generated fixture contains structure only, no private content.
- The fixture can be checked into tests.
```

---

## P2.45 Add “generalization readiness” scoring per item

### Problem

The backlog is now large. To avoid implementing impressive but disconnected scaffolding, each item should have a readiness score.

### Score dimensions

```txt
runtime-wired: 0/1
policy-gated: 0/1
capability-gated: 0/1
CI-enforced: 0/1
fixture-backed: 0/1
privacy-reviewed: 0/1
removes-host-exception: 0/1
```

### Acceptance check

```txt
- Every completed generalization item has a score.
- Items below 5/7 are marked scaffolded, not complete.
- Release notes distinguish scaffolded primitives from enforced runtime behavior.
```

---

## P3.40 Add naming consistency between profiles and policy fields

### Problem

The current names mix older and newer concepts:

```txt
genericVideo
video.allowMutation
scriptlets
scriptletsField
networkField
firstPartyNetwork
contentScript as scalar/object
```

### Generalized fix

Adopt stable namespaces:

```txt
policy.network.*
policy.cosmetic.*
policy.video.*
policy.scriptlet.*
policy.content.*
policy.instrumentation.*
policy.compatibility.*
```

Legacy names move under:

```txt
policy.legacy.*
```

### Acceptance check

```txt
- Runtime code reads canonical namespaces.
- Legacy aliases are generated in one compatibility function only.
- New code cannot add top-level policy booleans.
```

---

## P3.41 Add generated documentation from policy config

### Problem

Now that there is a policy DSL, the docs should be generated from it. Otherwise documentation will drift.

### Generalized fix

Generate:

```txt
docs/generated/page-policy.md
docs/generated/browser-capabilities.md
docs/generated/runtime-layers.md
docs/generated/compatibility-debt.md
```

### Acceptance check

```txt
- CI fails if generated docs are stale.
- Each profile page shows allowed/denied layers and reason.
- Compatibility docs show expiration and replacement item.
```

---

# Recommended next implementation order after ca353

Do these before adding more features:

```txt
1. Fix check-cross-layer-integration so missing wiring fails CI.
2. Make page-policy.json the source of truth and generate runtime policy from it.
3. Normalize policy shape and ban duplicate/mixed policy fields.
4. Wire page-signals -> page-classifier -> policy snapshot -> runtime-layer activation in active runtime.
5. Make capability tokens unforgeable and enforce them at mutation boundaries.
6. Fix DNR transaction rollback and force all DNR updates through the transaction module.
7. Make auto-recovery safe mode part of policy resolution.
8. Sync manifest exclude_matches with compatibility-sites.json and fail expired entries.
9. Add budget/privacy guards to page signal collection.
10. Make simulator a mandatory preflight for DNR/cosmetic/video/scriptlet actions.
```

This order focuses on small or medium changes with large safety impact. It avoids building more architecture before the new architecture is authoritative.

---

# Definition of “done” for the ca353 generalization layer

The ca353 layer should not be considered fully done until this is true:

```txt
- Every high-risk layer is registered in runtime-layer.
- Every high-risk layer receives a normalized policy snapshot.
- Every mutation requires an unforgeable capability token.
- Every high-risk DNR install goes through transaction + simulator + decision record.
- Every compatibility host exception has metadata, fixture, expiration, and replacement item.
- Every new generalization check is part of check:all or explicitly advisory.
- Unknown app-like pages are safe without adding hostname exclusions.
- Known video/content sites can still be filtered through evidence, not hardcoded host lists.
```

---

# ca353-specific review summary

## Good direction

```txt
The commit adds the right conceptual primitives.
It moves the project from "more exception lists" toward page profiles, policy snapshots, runtime activation, simulator preflight, capability tokens, and compatibility debt tracking.
```

## Main remaining problem

```txt
Several primitives are not yet enforceable enough.
They need to become mandatory runtime paths and CI gates, not optional files or advisory tools.
```

## Highest-value next task

```txt
Connect the classifier/policy/runtime-layer/token chain into the active manifest-selected runtime and add checks that fail if any high-risk layer bypasses it.
```


---

# v6 pass: whole-project generalization review after `7f97a6703b1b6edc6d7da6bda6ba39d061b07bff`

Reviewed commit: `7f97a6703b1b6edc6d7da6bda6ba39d061b07bff`  
Commit message: `Fixes and tuneups`  
Review date: `2026-06-28`

This pass is intentionally broader than a commit diff review. The commit was checked against the whole active extension architecture: manifest-selected runtime, canonical service worker, content-script boot path, DNR installation path, policy resolver, policy config, capability/token primitives, message dispatch, compatibility debt, certificate/readiness claims, and existing roadmap direction.

Important branch note: compared with the previous reviewed checkpoint `ca353def57eacc103871afe919bc845b87502ce2`, this ref is not a simple linear successor. It diverges from that checkpoint. Treat this v6 review as a review of the active state at `7f97...`, not as a narrow patch delta from `ca353...`.

## v6 main finding

The project has moved from **missing generalization primitives** to **authority sprawl without enough authority enforcement**.

That is real progress. The repo now contains many of the right primitives:

- policy profile config
- browser capability config
- permission capability config
- action traces
- allow-rule authority
- DNR transaction helper
- operation tokens
- policy snapshots
- main-world bridge policy
- hydration gate
- message contracts
- CSS injection registry
- compatibility debt config
- production rule surface checks
- broader video adapters
- removal of a dedicated Yandex blocker file

But the most important question is now different:

> Are these primitives actually on the canonical execution path, or are they files beside the runtime?

In multiple places, the answer is still "beside the runtime." The active manifest and canonical service worker still bypass several of the new authority modules. The next work should therefore focus less on adding more primitives and more on making the existing primitives mandatory.

## What materially improved in this state

### 1. The project now explicitly names the correct architectural problem

`ANCHORED_SUMMARY.md` correctly identifies the old model as negative exception handling: run broad logic everywhere, then exclude broken sites. It also correctly identifies the dangerous patterns that caused breakage: dev/test DNR rules enabled in development, domain-widening, forced critical-domain injection, global MAIN-world script injection, and lazy hostname-wide session rules.

This is important because it means the project direction is now aligned with the goal:

- no site-by-site whack-a-mole as the primary fix
- unknown apps get safe defaults
- full filtering requires evidence
- policy must become the central authority

### 2. The manifest no longer injects `ad-block-main.js` globally

This is a concrete improvement. The previous global MAIN-world `ad-block-main.js` injection was a high-risk breakage source because it could freeze or modify globals before app frameworks finished booting.

The current manifest still injects content runtime globally, but it does not show the old global `ad-block-main.js` MAIN-world block.

### 3. Dev/test DNR rulesets are disabled in the manifest

The manifest has `benchmark-extra`, `tester-blocklist`, and `tester-bait` disabled. That prevents dev/test rules from becoming real browsing behavior when loading the extension from source.

This is a real generalization win because it removes accidental test-specific blocking from all sites.

### 4. The policy resolver now loads policy config and browser capability config

`platform/chromium/js/policy-resolver.js` now fetches `config/page-policy.json` and `config/browser-capabilities.json`. That is the right direction. Policy is no longer only inline JavaScript.

However, this is still only partial authority because:

- there is still an inline fallback profile
- the resolver still decides profile mostly from hostname/trust/known-support inputs
- active `getPagePolicy` does not yet use structural page signals
- the policy shape still has flat and nested duplicate fields
- config schema validation is not yet a hard gate

### 5. Hardcoded established filter-support hosts were removed from the policy resolver path

The previous explicit established-host support set was replaced by `hasEstablishedFilterSupport()` returning false and a comment that structural classification should replace it.

This removes one major host-list dependency from the resolver. The next step is to make structural classification active, not just planned.

### 6. Dedicated Yandex blocker source was removed

Removing `src/js/contentscript/yandex-blocker.ts` is aligned with the project direction. The general video and policy path should handle Yandex-like video/ad behavior through evidence, adapters, and profile policy, not an isolated site-specific content script.

### 7. Many authority modules now exist

The repo now contains more of the correct long-term building blocks:

- `allow-rule-authority.js`
- `policy-snapshot.js`
- `main-world-bridge-policy.js`
- `startup-hydration-gate.js`
- `message-contracts.js`
- `operation-token.js`
- `css-injection-registry.js`
- `dnr-transaction.js`
- `permission-capabilities.json`
- `browser-capabilities.json`

These should not be treated as completed architecture until the active service worker and content runtime are forced to use them.

### 8. The public claim direction was partially corrected

README and BENCHMARK no longer simply present a Gold state. The badge text was downgraded to Bronze. This is safer than overclaiming.

However, the certificate language is internally inconsistent and still needs cleanup because the same files mix Bronze, Silver, "all required gates pass," and a visible `no_remote_rule_fetch` failure.

## v6 highest-priority theme

The next implementation wave should be:

> Turn the 7f97 authority modules into the only allowed execution path.

That means:

- the manifest-selected runtime must match the docs
- active content scripts must not choose their own policy
- page signals must affect policy resolution
- policy snapshots must be created by the service worker
- capability tokens must be issued from snapshots
- mutation paths must require tokens
- DNR writes must go through transaction authority
- whitelist/allow rules must go through allow-rule authority
- message contracts must gate the dispatcher
- hydration gate must protect cold-start mutations
- CI checks must fail on bypasses, not merely check file existence

---

# v6 source evidence anchors

These anchors are included so the next coding agent can quickly verify why the backlog items below exist.

## Active manifest and runtime

- `platform/chromium/manifest.json`
  - DNR test/benchmark rulesets are disabled.
  - `<all_urls>` host permission remains.
  - The main content script still globally injects `vapi.js`, `vapi-client.js`, `contentscript.js`, and `smart-content.js` on all HTTP/HTTPS pages, excluding only ChatGPT in that block.
  - The generic video content script still globally injects `video-adblock-generic.js` on all HTTP/HTTPS pages, with host exclusions for Suno, VKVideo, Yandex, YouTube, and ChatGPT.
  - `web_accessible_resources` still match `<all_urls>`.

- `platform/chromium/js/bootstrap.js`
  - Comment says "Manifest injects only this file."
  - Active manifest does not actually do that.
  - The file sends `getPagePolicy` with simple page signals and then sends `activatePageLayers`.

- `platform/chromium/js/sw.js`
  - Header says this is the canonical service worker loaded by the manifest.
  - Imports shown at the top are still mainly stealth surrogates, YouTube engine, smart engine, and policy resolver.
  - The new authority modules are not visibly imported in the canonical SW import header.
  - Active `getPagePolicy` ignores page signals and resolves from URL/hostname/trust/known-support.
  - Active `activatePageLayers` accepts `msg.policy` from the content side and returns a list of active layer names. It does not create a `PolicySnapshot`, issue capability tokens, or invoke the runtime-layer registry.

## Policy config and policy resolver

- `config/page-policy.json`
  - Defines `app-shell`, `auth-sensitive`, `payment-sensitive`, `video-site`, `default-web`, and `trusted-off`.
  - `app-shell` is safe-ish: safe network, specific-only cosmetic, generic/procedural/smart false, video observe-only.
  - `auth-sensitive` and `payment-sensitive` disable network/scriptlets/video.
  - `video-site` and `default-web` are much more permissive.
  - `default-web` enables full network/cosmetic/video behavior.
  - Mixed aliases remain: flat fields such as `genericVideo`, nested fields such as `video.mode`, and mixed `mainWorldHooks` values.

- `config/page-policy.schema.json`
  - Claims no mixed boolean/string enums.
  - Still allows `proceduralCosmetic`, `smartCosmetic`, and `mainWorldHooks` to be boolean or string.
  - Has a condition that can conflict with profiles that set `cosmetic: "off"` while also defining `cosmeticField`.

- `platform/chromium/js/policy-resolver.js`
  - Loads `page-policy.json` and `browser-capabilities.json`.
  - Still uses inline fallback profile.
  - `DEFAULT_PROFILE_ID` is `app-shell`.
  - `resolveProfile()` does not yet use structural page classification.
  - `hasEstablishedFilterSupport()` returns false with a TODO-style comment.
  - `resolvePagePolicy()` produces both flat and nested fields.

## DNR and allow-rule path

- `platform/chromium/js/dnr-transaction.js`
  - Transaction helper exists.
  - It removes current rules before install and restore.
  - It verifies installed rule count, not exact rule equality.
  - Restore catches add failures silently.

- `platform/chromium/js/sw.js`
  - Still directly calls `chrome.declarativeNetRequest.updateDynamicRules()` / `updateSessionRules()` in multiple paths.
  - Whitelist/trusted-site allow rules are generated directly in `installWhitelistAllowRules()`.
  - Filter-list sync still uses direct dynamic/session writes instead of the transaction helper.
  - A large `CRITICAL_DOMAIN_PRIORITY` table remains in the canonical SW. It appears no longer used for forced injection, but it still shapes rule survival/priority.

- `platform/chromium/js/allow-rule-authority.js`
  - Defines a good allow/exception entry model with source, scope, reason, owner, expiry/permanent justification, affected capabilities, risk class, precedence, and diagnostic snapshot.
  - It is not yet the mandatory path for whitelist/session allow rules.

## Tokens, snapshots, message contracts, and startup gate

- `src/js/runtime/capability-token.ts`
  - Still creates forgeable plain-object tokens with incrementing IDs.
  - Validation checks only existence, layer match, and expiry.
  - It does not validate tab/frame/document/policy revision/action against a trusted server-side registry.

- `platform/chromium/js/policy-snapshot.js`
  - Intended to bind tokens to policy revision/document identity.
  - `PolicySnapshot.create()` appears to call `new PolicySnapshot(...)` even though `PolicySnapshot` is the exported object and `_Snapshot` is the class. This likely breaks snapshot creation if this path is executed.
  - Tokens are still plain objects, though with an `isValid()` closure.

- `platform/chromium/js/message-contracts.js`
  - Defines a useful dispatcher contract model.
  - The canonical SW dispatcher still routes channels directly and does not appear to enforce these contracts.

- `platform/chromium/js/startup-hydration-gate.js`
  - Defines a useful cold-start readiness/queue model.
  - The canonical SW dispatcher does not yet appear to use it.

- `platform/chromium/js/main-world-bridge-policy.js`
  - Defines nonce-bound bridge policies.
  - Nonces are generated with `Math.random`, not cryptographic randomness.

## Checks and public claims

- `tools/check-cross-layer-integration.mjs`
  - Still has an undefined `srcDir` variable.
  - Mostly warns rather than fails.
  - `failed` is initialized but not set by most checks.
  - It can print done without enforcing cross-layer integration.

- `tools/check-production-rule-surface.mjs`
  - Stronger and useful.
  - But its compatibility registry validation checks `compat.exceptions`, while the actual `config/compatibility-sites.json` is an array. That means the compatibility check can no-op on the real file shape.

- `config/compatibility-sites.json`
  - Temporary entries for ChatGPT, Grok, Suno, and Yandex expire on `2026-06-01`.
  - Current review date is `2026-06-28`, so these entries are expired if enforced literally.

- `README.md` and `BENCHMARK.md`
  - Badge says Bronze.
  - Same docs also reference Silver / `PARTIAL_SUPERIORITY`.
  - Required gate table visibly lists `no_remote_rule_fetch` as FAIL.

---

# New v6 backlog items

The item numbers below continue the prior backlog without replacing earlier v5 items. They focus on new or newly-evidenced whole-project work after `7f97...`.

---

## P0.60 — Make manifest-selected runtime match the bootstrap-only claim

### Problem

`platform/chromium/js/bootstrap.js` says the manifest injects only this file and that it replaces the previous global heavyweight injection pattern.

The actual manifest still injects heavyweight content scripts globally:

- `vapi.js`
- `vapi-client.js`
- `contentscript.js`
- `smart-content.js`
- `video-adblock-generic.js`

The generic video runtime is still broad-match and excluded by named host patterns. That is better than the earlier global MAIN-world `ad-block-main.js`, but it is not the bootstrap-only architecture described by the code comment.

### Why this matters for generalization

The whole goal is to avoid "run everything everywhere, then exclude sites that break."

If heavyweight scripts still load everywhere, then policy only gates part of behavior after parse/import time. Any top-level side effect, early monkey patch, global marker, observer startup, or imported module initialization can still break apps before policy denies activation.

### Fix

Choose one of two directions.

Preferred direction:

1. Manifest injects only the absolute minimum bootstrap stack:
   - `vapi.js`
   - `vapi-client.js`
   - `/js/bootstrap.js`
2. Bootstrap collects bounded structural signals.
3. Bootstrap asks the service worker for a policy snapshot.
4. Bootstrap loads or activates only allowed modules.
5. Heavy modules are no longer manifest-global:
   - `contentscript.js`
   - `smart-content.js`
   - `video-adblock-generic.js`
   - interceptor modules
   - first-party detector modules

Temporary alternative:

1. Remove false bootstrap-only claims.
2. Add CI that marks the current runtime as transitional.
3. Require all globally-injected modules to prove top-level side-effect freedom.

### Acceptance

- `manifest.json` no longer broad-injects heavyweight smart/video/interceptor bundles.
- CI fails if a comment says "manifest injects only bootstrap" while manifest injects heavy runtime bundles.
- Unknown app pages receive only the bootstrap path by default.
- Dedicated site content scripts remain allowed only when backed by adapter fixtures.
- Manifest host exclusions shrink over time rather than grow.

---

## P0.61 — Build an active authority-module inventory

### Problem

`7f97...` adds many authority modules, but the canonical manifest-selected service worker does not visibly import most of them.

Examples of modules that appear present but not yet authoritative in the active path:

- `allow-rule-authority.js`
- `policy-snapshot.js`
- `message-contracts.js`
- `startup-hydration-gate.js`
- `main-world-bridge-policy.js`
- `operation-token.js`
- `css-injection-registry.js`
- `dnr-transaction.js`

The repo now risks a new failure mode: appearing architecturally complete because authority files exist, while active code continues to bypass them.

### Fix

Create an inventory file:

`config/active-authorities.json`

Example shape:

```json
{
  "authorities": [
    {
      "id": "policy-snapshot",
      "path": "platform/chromium/js/policy-snapshot.js",
      "state": "active",
      "canonicalImporter": "platform/chromium/js/sw.js",
      "requiredFor": ["getPagePolicy", "activatePageLayers", "capability-token"],
      "tests": ["tests/runtime/policy-snapshot.spec.ts"]
    }
  ]
}
```

Add a check:

`tools/check-active-authorities.mjs`

It should verify:

- every `state: "active"` authority is imported by a manifest-selected runtime path
- every `state: "active"` authority has at least one test
- every mutation-capable path references its required authority
- every unused authority is marked `inactive`, `prototype`, or moved under `_unused`

### Acceptance

- CI fails when an active authority file exists but is not imported by the canonical runtime.
- CI fails when a mutation path bypasses the authority assigned to it.
- CI distinguishes:
  - active
  - prototype
  - fixture-only
  - deprecated
  - unused
- Public docs stop counting inactive/prototype files as completed enforcement.

---

## P0.62 — Fix `PolicySnapshot.create()` before using policy snapshots for capabilities

### Problem

`platform/chromium/js/policy-snapshot.js` defines an internal `_Snapshot` class, but `PolicySnapshot.create()` appears to instantiate `new PolicySnapshot(...)`.

That is likely wrong because `PolicySnapshot` is the exported object, not the class.

### Why this matters

The project needs policy snapshots to become the trusted root for:

- policy revision
- document/frame binding
- capability token issuance
- stale policy invalidation
- navigation cleanup
- safe downgrade after policy change

If snapshot creation is broken, every downstream token/security step becomes unreliable.

### Fix

Change:

```js
const snap = new PolicySnapshot({ ... });
```

to:

```js
const snap = new _Snapshot({ ... });
```

Then add tests for:

- snapshot creation
- snapshot replacement
- token issuance
- token invalidation on replacement
- `invalidateAll()`
- `invalidate(tabId, frameId)`
- active snapshot count

### Acceptance

- `PolicySnapshot.create()` returns a valid snapshot.
- `PolicySnapshot.issueToken()` works after snapshot creation.
- Old tokens are invalid after snapshot replacement.
- Old tokens are invalid after `invalidateAll()`.
- CI fails if `PolicySnapshot.create()` references the exported object constructor again.

---

## P0.63 — Stop accepting caller-supplied policy in `activatePageLayers`

### Problem

The active `activatePageLayers` handler accepts `msg.policy` from the content side:

```js
const policy2 = msg.policy || resolvePagePolicy(...)
```

This is not safe enough. Content scripts run in the page context boundary and should not be able to provide their own effective policy. They can provide observations, but the service worker must own the decision.

### Why this matters

If the content side can pass a permissive policy, then the policy resolver is not the actual authority. Even if accidental rather than malicious, stale or malformed content policy can activate too much after navigation or SPA route changes.

### Fix

The content side should send:

- URL
- origin/hostname
- frame identity
- document identity if available
- bounded page signals
- previous policy revision, if any

The service worker should:

1. verify sender tab/frame
2. derive URL/hostname from sender where possible
3. classify page
4. resolve policy
5. create `PolicySnapshot`
6. issue capability tokens only for allowed layers
7. return `{ snapshotId, policyRevision, profile, activeLayers, tokens, reasons }`

### Acceptance

- `activatePageLayers` ignores any caller-supplied policy object.
- Forged content message with `loadVideoRuntime: true` on app-shell still returns app-shell-safe active layers.
- Service worker creates or retrieves a policy snapshot before activation.
- Layer activation cannot occur without a service-worker-owned revision.
- Tests cover stale policy after navigation.

---

## P0.64 — Wire page signals into active policy resolution

### Problem

`bootstrap.js` sends `pageSignals`, but the actual active path does not fully use them:

- manifest does not inject `bootstrap.js` as the only bootstrap
- `getPagePolicy` ignores `msg.pageSignals`
- `resolvePagePolicy()` chooses profile from trusted/hostname/known-support logic
- `hasEstablishedFilterSupport()` currently returns false
- structural classification is still not authoritative in the canonical runtime

### Why this matters

Host exceptions can only disappear when unknown apps are classified structurally.

Without active page-signal classification, everything unknown defaults to `app-shell`, while explicit full behavior depends on manual known-support inputs or broad defaults. That is safer than before, but it is not yet a mature generalization system.

### Fix

Make the active path:

```text
content bootstrap
  → collect privacy-safe signals
  → send GetPolicySnapshotRequest
  → SW validates sender/tab/frame
  → SW calls classifyPageProfile(signals)
  → SW resolves profile
  → SW normalizes policy
  → SW creates PolicySnapshot
  → SW returns policy + active layers + tokens
```

Add explicit structural signals:

- contenteditable count
- password input presence
- payment-like form presence
- primary video area ratio
- app root confidence
- route/history API usage signal
- shadow root count, capped
- input count, capped
- form count, capped
- iframe count, capped
- large DOM flag, capped
- user gesture requirement flag

Do not include:

- text content
- input values
- form values
- query strings
- localStorage/sessionStorage
- cookies
- raw page titles
- private URLs beyond normalized origin/hostname/path class

### Acceptance

- `getPagePolicy` passes page signals to classifier.
- `resolvePagePolicy` can accept a resolved `profileId` and classification reasons.
- `app-shell`, `auth-sensitive`, `payment-sensitive`, `video-site`, and `default-web` can be selected without hostname exceptions.
- Auth/payment profiles win over default/video when sensitive signals are present.
- Tests prove a `#__next` video site is not incorrectly reduced to app-shell solely because it has an app root.
- Tests prove a generic `<main>` news article is not incorrectly classified as app-shell.

---

## P0.65 — Validate `config/page-policy.json` against schema in CI

### Problem

`config/page-policy.schema.json` exists but appears internally inconsistent with the config and with its own description.

Examples:

- The schema says no mixed boolean/string enums, but allows `proceduralCosmetic`, `smartCosmetic`, and `mainWorldHooks` to be boolean or string.
- The schema has a condition that may reject a profile with `cosmetic: "off"` and `cosmeticField`, while `trusted-off` uses exactly that kind of shape.
- `genericVideo` uses `known-adapter-only`, while nested `video.mode` uses `known-adapter`.
- `default-web` uses `mainWorldHooks: true`, while other profiles use string values.

### Fix

Add:

`tools/check-page-policy-schema.mjs`

Then decide one canonical representation.

Recommended canonical shape:

```json
{
  "network": {
    "mode": "safe",
    "firstParty": "explicit-only",
    "highRiskResources": "specific-only",
    "firstPartyResponseMutation": false
  },
  "cosmetic": {
    "specific": true,
    "generic": false,
    "procedural": false,
    "smart": false
  },
  "video": {
    "mode": "observe-only",
    "allowMutation": false,
    "allowSkipClick": false
  },
  "scriptlets": {
    "mode": "trusted-specific-only",
    "mainWorldHooks": false
  },
  "content": {
    "enabled": true,
    "loadCosmeticRuntime": true,
    "loadSmartRuntime": false,
    "loadVideoRuntime": false,
    "loadInterceptors": false
  }
}
```

Legacy flat fields can be generated by resolver for old callers, but they should not be authoring fields.

### Acceptance

- `npm run check:page-policy-schema` exists.
- `check:all` reaches the schema check.
- Current `page-policy.json` passes schema.
- Schema fails on mixed boolean/string authoring fields after migration.
- Schema fails on unknown policy keys.
- Schema explicitly allows `trusted-off`.
- Schema explicitly validates compatibility between flat migration aliases and nested canonical fields only during migration.

---

## P0.66 — Normalize policy into one canonical nested shape before runtime use

### Problem

The current policy object contains both old flat fields and new nested fields:

- `network` and `networkField`
- `cosmetic` and `cosmeticField`
- `scriptlets` and `scriptletsField`
- `genericVideo` and `video`
- `mainWorldHooks` as string or boolean
- `smartCosmetic` as boolean or string

This makes it easy for layers to read different meanings.

### Fix

Add:

`platform/chromium/js/normalize-policy.js`

or source equivalent:

`src/js/runtime/normalize-policy.ts`

The normalizer should:

1. accept config profile
2. reject ambiguous mixed fields when values disagree
3. produce one canonical nested shape
4. attach migration aliases only in `policy.legacy`
5. freeze the returned policy object in development/test
6. add `policy.schemaVersion`

### Acceptance

- Active runtime receives normalized policy only.
- Runtime layers read only nested canonical fields.
- Direct reads of `policy.genericVideo`, `policy.smartCosmetic`, `policy.scriptlets`, etc. outside resolver/legacy adapter fail CI.
- The policy debugger can show both canonical and legacy aliases during migration.
- Eventually flat aliases are removed.

---

## P0.67 — Route every DNR write through transaction authority

### Problem

`dnr-transaction.js` exists, but canonical `sw.js` still directly calls:

- `chrome.declarativeNetRequest.updateDynamicRules`
- `chrome.declarativeNetRequest.updateSessionRules`

in multiple places, including:

- schema upgrade clear
- whitelist allow rules
- stealth surrogate rules
- filter-list sync
- session rules

### Why this matters

A transaction helper is only meaningful if it is the only allowed write path. Otherwise partial writes, stale writes, and unproven broad allow/block rules can still bypass rollback and provenance.

### Fix

Create a single DNR authority API:

```js
DnrAuthority.update({
  scope: "filter-list-sync" | "whitelist" | "stealth" | "user-rule" | "migration",
  dynamicRules,
  sessionRules,
  provenance,
  policyRevision,
  riskSummary,
  reason
})
```

Under the hood it should:

1. simulate/risk-check candidate rules
2. detect conflicts
3. use operation token
4. snapshot target scope
5. install transactionally
6. verify exact rule equality
7. record install decisions
8. rollback on failure
9. enter degraded allow mode only with recorded reason

### Acceptance

- CI bans direct `chrome.declarativeNetRequest.update*Rules` outside DNR authority modules and tests.
- Schema migration uses DNR authority.
- Whitelist uses DNR authority.
- Stealth surrogate rules use DNR authority.
- Filter-list sync uses DNR authority.
- Failed filter-list update restores exact previous rules.
- All DNR writes have provenance and risk class.

---

## P0.68 — Make allow-rule authority govern whitelist and trusted-site rules

### Problem

`allow-rule-authority.js` defines the correct model for allow/exception rules, but the canonical whitelist path still compiles directives into broad high-priority DNR allow rules directly.

### Why this matters

Trusted/allow behavior is one of the most dangerous bypass categories. A broad allow rule can undo blocking in exactly the places where the extension needs strongest provenance and clear user intent.

### Fix

Move whitelist/trusted-site handling through `AllowRuleAuthority`.

Every allow rule should have:

- source
- scope
- owner
- reason
- createdAt
- expiresAt or permanentJustification
- affectedCapabilities
- riskClass
- precedence
- undoPath
- userVisibleLabel
- provenanceHash

Then the DNR layer should generate allow rules only from active authority entries.

### Acceptance

- `installWhitelistAllowRules()` no longer writes DNR rules directly.
- Every trusted-site DNR allow rule maps to an `AllowRuleAuthority` entry.
- Expired temporary allow entries are removed before DNR generation.
- User-created permanent allow entries require permanent justification.
- Emergency repair allow entries require expiry.
- Popup/logger can explain why a site is trusted and how to undo it.

---

## P0.69 — Verify DNR transaction rollback by exact normalized rule equality

### Problem

`dnr-transaction.js` currently verifies installed rule counts, not exact rule equality. A same-count but wrong-rule result would pass.

`restoreDnrSnapshot()` also catches update failures silently when adding snapshot rules.

### Fix

Add normalized rule equality:

```js
normalizeRule(rule) → stable JSON
sameRuleSet(actual, expected) → exact id/action/condition/priority comparison
```

Rollback should:

1. remove target-scope current rules
2. add snapshot
3. read back
4. verify exact snapshot equality
5. throw if restore failed
6. enter degraded allow mode if restore cannot be verified

### Acceptance

- Test: same count/different IDs fails.
- Test: same IDs/different conditions fails.
- Test: failed add during restore enters degraded allow mode.
- Test: rollback success restores exact previous dynamic/session rules.
- Transaction result includes:
  - `ok`
  - `rolledBack`
  - `degraded`
  - `reason`
  - `beforeHash`
  - `afterHash`
  - `restoredHash`

---

## P0.70 — Make message contracts enforce the canonical dispatcher

### Problem

`message-contracts.js` defines an excellent model, but the canonical dispatcher still routes channels directly.

Current dispatcher style:

```js
if (channel === "loggerUI") return handleLoggerUI(msg);
if (channel === "popupPanel") return handlePopupPanel(msg);
if (channel === "contentscript") return handleContentscript(msg, senderTabId, senderFrameId);
...
```

No central contract check is visible in that path.

### Fix

1. Register contracts for every `msg.what`.
2. Determine sender type:
   - content
   - popup
   - dashboard
   - logger
   - extension page
   - unknown
3. Determine sensitivity:
   - safe read
   - diagnostic read
   - mutation low
   - mutation high
   - network mutation
   - UI mutation
4. Check:
   - allowed sender
   - tab/frame presence
   - policy readiness
   - payload schema
   - mutation authority
5. Route only after authorization.

### Acceptance

- Unknown `msg.what` is denied before handler.
- Content sender cannot call dashboard/logger mutation messages.
- Popup cannot call raw content mutation messages.
- Mutation messages fail if policy is not ready.
- Contracts are generated into docs.
- CI fails if a handler exists without a contract.

---

## P0.71 — Wire `HydrationGate` into service-worker startup and dispatch

### Problem

`startup-hydration-gate.js` exists, but the canonical dispatcher does not visibly use it.

During MV3 service-worker cold start, messages can arrive before policy profiles, browser capabilities, storage state, or DNR state are ready. Without a gate, mutation-capable messages can execute with fallback or partial state.

### Fix

At service-worker startup:

```js
HydrationGate.beginHydration("service-worker-startup");
HydrationGate.registerComponent("storage", "critical");
HydrationGate.registerComponent("policy-profiles", "policy");
HydrationGate.registerComponent("browser-capabilities", "policy");
HydrationGate.registerComponent("dnr-state", "network");
HydrationGate.registerComponent("filter-lists", "network");
HydrationGate.registerComponent("ui-state", "ui");
```

In dispatcher:

```js
const gate = HydrationGate.checkEvent({ eventType, sensitivity });
if (!gate.allowed) {
  return { ok: false, retryable: gate.queued, reason: gate.reason };
}
```

### Acceptance

- Safe read messages pass during startup.
- Network mutation messages wait or fail retryably until policy/network hydration completes.
- Content activation cannot run before policy profiles are loaded or safe fallback is explicitly recorded.
- Filter-list sync cannot commit before storage and DNR state are hydrated.
- Hydration errors cause degraded safe mode, not permissive fallback.

---

## P0.72 — Replace `Math.random` and incrementing security IDs with cryptographic IDs

### Problem

Several token/nonce-like systems use weak identifiers:

- main-world bridge nonce uses `Math.random`
- operation tokens use incrementing counters
- capability tokens use incrementing counters
- allow-rule provenance hash uses a simple integer hash

Not all of these are equally security-sensitive, but the project should have one rule:

> Anything that acts as authority, nonce, token, bridge, or provenance identity must use the shared ID authority.

### Fix

Use one ID module, for example:

`platform/chromium/js/id-authority.js`

It should provide:

- `randomId(prefix)`
- `randomNonce(bytes)`
- `stableHash(value)` for non-secret provenance hashes
- deterministic test seam only in test mode

Security-sensitive randomness should use:

- `crypto.randomUUID()`, where available
- `crypto.getRandomValues()`, fallback where needed

### Acceptance

- CI fails on `Math.random` usage in:
  - token modules
  - bridge modules
  - nonce modules
  - capability modules
  - transaction IDs
- Capability IDs are unguessable.
- Bridge nonces are unguessable.
- Operation IDs are unique enough for diagnostics and stale commit prevention.
- Provenance hashes are stable and collision-resistant enough for audit, but not treated as secrets.

---

## P0.73 — Decide whether remote filter fetch is a release feature or a release blocker

### Problem

The SW still has remote list fallback behavior: bundled list first, then CDN URL fallback when bundled content is missing/stub.

At the same time, README/BENCHMARK show conflicting certificate language:

- Bronze badge
- Silver canonical claim
- "all required gates pass"
- visible `no_remote_rule_fetch` FAIL

This is a trust problem. The project can support remote list fetch, but it must not claim a release profile that forbids it.

### Fix

Choose one of two product positions.

Option A: strict store/release profile

- no remote rule fetch in release
- bundled lists only
- imported user lists disabled or manual-only
- release certificate can pass no-remote-fetch

Option B: remote list feature

- remote fetch is explicit
- list URLs have provenance
- cache has integrity metadata
- update rollback exists
- user can disable remote list updates
- certificate truthfully says this profile includes remote filter updates

### Acceptance

- README badge, benchmark badge, certificate badge, and gate table agree.
- If `no_remote_rule_fetch` is FAIL, docs do not say all required gates pass.
- If remote fetch is allowed, release profile documents why and how it is controlled.
- CI prevents Bronze/Silver/Gold contradiction in public docs.
- Release certificate separates "functional evidence" from "store-policy strictness."

---

## P0.74 — Sync manifest host exclusions with compatibility metadata using the real date

### Problem

`config/compatibility-sites.json` contains temporary entries expiring `2026-06-01`.

Current review date is `2026-06-28`.

If enforced literally, these entries are expired. The manifest still contains host-specific exclusions for multiple sites in content-script blocks.

### Fix

Add:

`tools/check-manifest-compatibility-sync.mjs`

Rules:

- every host in `exclude_matches` must have a compatibility metadata entry
- every compatibility entry must have:
  - status
  - layer
  - reason
  - replacement generalization item
  - owner
  - createdAt
  - expiresAt
  - lastVerifiedAt
  - fixturePath
  - removalPlan
- expired temporary entries fail CI
- extension requires a short extension reason
- removed manifest host exclusions require fixture pass

### Acceptance

- Current expired entries fail until renewed, downgraded to fixture-only, or removed.
- ChatGPT/Grok/Suno/Yandex entries cannot silently remain as temporary debt.
- YouTube/VK/Yandex manifest exclusions are either adapter-owned fixtures or compatibility entries.
- Named host exceptions remain visible and time-bounded.

---

## P0.75 — Fix compatibility validation in `check-production-rule-surface.mjs`

### Problem

`tools/check-production-rule-surface.mjs` checks:

```js
if (compat && Array.isArray(compat.exceptions)) { ... }
```

But `config/compatibility-sites.json` is currently an array, not an object with `exceptions`.

That means the compatibility validation can no-op on the real file shape.

### Fix

Pick one shape.

Recommended:

```json
{
  "schemaVersion": 1,
  "exceptions": [...]
}
```

Or keep array shape but validate it explicitly.

Then update `check-production-rule-surface.mjs` to fail if the shape is wrong.

### Acceptance

- Malformed compatibility config fails.
- Current real compatibility shape is validated.
- Missing owner/replacement/expiry/fixturePath fails.
- Expired temporary entries fail.
- Check is included in `check:all`.

---

## P1.60 — Move `CRITICAL_DOMAIN_PRIORITY` out of canonical SW code

### Problem

`sw.js` still contains a large hardcoded `CRITICAL_DOMAIN_PRIORITY` table.

It appears the prior forced-injection bug was removed, which is good. But the hardcoded table still affects which domains survive priority sorting and budget truncation.

### Why this matters

A hardcoded ad/tracker priority table inside the canonical SW is not necessarily wrong, but it is the wrong layer. It should be data with provenance, not logic embedded in the monolith.

### Fix

Move to:

`config/domain-priority.json`

Each entry should include:

- domain or pattern
- priority
- source list provenance
- evidence class
- last reviewed date
- reason
- test fixture
- whether it can affect dynamic/session/static priority

### Acceptance

- `sw.js` no longer contains a large named-domain priority table.
- Priority entries are validated as data.
- Priority entries have provenance and test coverage.
- Budget truncation decisions can be explained.
- No priority entry can invent a rule; it can only prioritize already-compiled rules.

---

## P1.61 — Split active runtime into bootstrap, policy, and engine bundles

### Problem

Even with policy checks, the current content path still ships large bundles into all pages.

The safer design is:

1. tiny bootstrap
2. policy request
3. selective engine loading
4. engine activation with tokens

### Fix

Create separate runtime bundles:

- `bootstrap-runtime.js`
- `cosmetic-runtime.js`
- `smart-cosmetic-runtime.js`
- `video-runtime.js`
- `interceptor-runtime.js`
- `scriptlet-runtime.js`

Only bootstrap is globally injected. Other bundles load only after policy.

### Acceptance

- App-shell pages never parse smart/video/interceptor runtime unless policy allows it.
- Video pages load video runtime only after video profile or known adapter evidence.
- Auth/payment pages do not load mutation-capable runtimes.
- Bundle load decisions are visible in policy debugger.
- Tests prove no global side effects before policy snapshot.

---

## P1.62 — Add top-level side-effect audit for content modules

### Problem

`contentscript-entry.ts` imports modules before asking for policy, including:

- `universal-ad-interceptor.ts`
- `first-party-ad-detector.ts`

Even if current modules are mostly inert, top-level imports are risk. A future edit can add a side effect and break the policy-first guarantee.

### Fix

Add:

`tools/check-content-top-level-side-effects.mjs`

It should scan active content entry modules and their imports for top-level:

- `new MutationObserver`
- `addEventListener`
- `setInterval`
- `setTimeout`
- `fetch`/XHR monkey patching
- `Object.defineProperty`
- DOM writes
- CSS injection
- click/keyboard/mouse dispatch
- `chrome.scripting` or `insertCSS`
- global marker writes
- immediate class instantiation with side effects

Allowed top-level actions:

- type declarations
- constant definitions
- pure helper functions
- explicit `export function start(policy, tokens)`

### Acceptance

- Universal interceptor has no top-level mutation before policy.
- First-party detector has no top-level mutation before policy.
- Smart/video modules have no top-level activation.
- CI fails on new top-level side effects in active global content imports.
- Exceptions require owner, reason, expiry, and fixture.

---

## P1.63 — Integrate CSS injection registry with actual removal

### Problem

`css-injection-registry.js` records CSS injection IDs per tab/frame. That is useful, but tracking alone does not remove CSS. Actual cleanup needs to call the proper removal API or remove DOM style nodes.

### Fix

Define CSS injection lifecycle:

```text
register injection
  → apply CSS
  → on policy downgrade / trusted site / navigation / teardown
  → remove CSS by registered handle
  → verify no stale style remains
```

Support both:

- DOM `<style>` injection
- `chrome.scripting.insertCSS` / `removeCSS`

### Acceptance

- Policy downgrade from default-web to app-shell removes generic CSS.
- Trusted site toggle removes active cosmetic CSS immediately.
- SPA navigation invalidates old frame/document styles.
- CSS registry records exact CSS text or handle needed for removal.
- Tests verify visible stale hidden elements do not remain after removal.

---

## P1.64 — Move site-specific UI protections out of generic bootstrap

### Problem

`src/js/contentscript/07-bootstrap.ts` contains YouTube-specific protected UI selectors and logic.

Some site-specific adapter logic is valid. But it should live in adapter fixtures/registries, not generic bootstrap code.

### Fix

Move YouTube protected UI selectors to:

- `src/js/video-adblock/site-adapters/youtube.ts`
- `config/site-protected-ui/youtube.json`
- or equivalent adapter fixture

Generic bootstrap should ask:

```js
ProtectedUiRegistry.getProtectedSelectors(profile, adapterId)
```

### Acceptance

- Generic bootstrap has no named site UI selectors.
- YouTube adapter declares protected selectors and fixtures.
- Future Yandex/VK/etc. protections use the same adapter fixture model.
- Protected UI rules are testable and removable.
- CI fails on named site selector additions to generic bootstrap.

---

## P1.65 — Use operation tokens for every asynchronous commit boundary

### Problem

`operation-token.js` exists and models stale-operation cancellation, but it must be applied consistently.

High-risk async commit boundaries include:

- DNR sync
- filter-list load
- remote/bundled list fallback
- selected list changes
- whitelist changes
- stealth surrogate updates
- settings writes
- policy snapshot activation
- smart rule import/export
- CSS injection/removal
- popup-driven reload/toggle commands

### Fix

For every async operation that can commit side effects:

1. acquire operation token
2. perform async work
3. check `token.isCurrent()` before commit
4. release token
5. abort superseded operations

### Acceptance

- Stale filter-list sync cannot install rules after newer sync.
- Stale policy response cannot activate old layers after navigation.
- Stale whitelist update cannot restore old allow rules.
- Stale smart-rule import cannot overwrite newer rule state.
- Tests simulate out-of-order promises.

---

## P1.66 — Version and invalidate policy snapshots across all policy-affecting events

### Problem

Policy snapshots only matter if every policy-affecting change invalidates them.

Policy-affecting events include:

- hostname switch change
- net filtering toggle
- trusted-site whitelist change
- filter-list selection change
- filter-list update
- browser capability change
- permission state change
- feature expiry gate change
- safe mode/recovery change
- navigation/documentId change
- frame teardown
- extension update/migration

### Fix

Create central invalidation API:

```js
PolicyInvalidation.invalidate({
  scope: "tab" | "frame" | "global",
  reason,
  affectedLayers,
  source
});
```

Every relevant subsystem calls it.

### Acceptance

- Old tokens fail after settings toggle.
- Old tokens fail after whitelist change.
- Old tokens fail after filter-list update.
- Old tokens fail after navigation/document change.
- Runtime layers receive `onPolicyChange` or teardown.
- Policy debugger shows last invalidation reason.

---

## P1.67 — Generate active runtime import graph certificate

### Problem

The repo has many source and generated files, some active and some prototypes. It is easy to review the wrong file.

### Fix

Add:

`tools/generate-active-runtime-graph.mjs`

It should start from:

- `platform/chromium/manifest.json`
- background service worker
- content_scripts
- web_accessible_resources that can be loaded dynamically
- generated bundles actually referenced by manifest or runtime

Output:

`dist/build/certificate/active-runtime-graph.json`

It should classify:

- active entrypoint
- imported file
- mutation API usage
- policy authority used
- token authority used
- DNR authority used
- message contract used
- hydration gate used
- known bypasses

### Acceptance

- Reviewers can see the real active runtime graph.
- CI fails on active mutation API without authority path.
- CI distinguishes source-only prototypes from manifest-selected runtime.
- Backlog items can reference graph nodes.

---

## P1.68 — Treat browser capability config as declared, not observed

### Problem

`config/browser-capabilities.json` declares capabilities by browser family. The policy resolver selects by user agent.

That is useful, but user-agent-derived capability is not sufficient. Runtime support can vary by browser version, channel, permissions, and extension environment.

### Fix

Add runtime detector:

`platform/chromium/js/browser-capability-detector.js`

It should safely probe:

- DNR presence
- DNR feedback availability
- dynamic/session rule support
- max rules where observable
- `chrome.scripting.insertCSS`
- `documentId`
- `webNavigation`
- userScripts
- tab hide
- storage quotas

Policy should use:

```text
effective capability = declared capability ∩ observed capability ∩ permission state
```

### Acceptance

- Edge with no userScripts disables main-world hooks even if config changes accidentally.
- Firefox MV3 disables unsupported regex/userScripts behavior.
- Missing DNR feedback disables diagnostic matched-rule collection.
- Capability mismatch recorded locally.
- Tests mock mismatched declared/observed capability.

---

## P2.60 — Replace SW monolith with enforced module dispatcher gradually

### Problem

The canonical SW is still manually maintained as a large monolith. Many new modules are beside it, not necessarily inside it.

A full rewrite is risky. But leaving the monolith uncontrolled means authority modules will keep being bypassed.

### Fix

Use a gradual routing approach:

1. Create a module registry.
2. Move one handler group at a time behind registered module metadata.
3. For each module, declare:
   - channel
   - messages
   - sender types
   - mutation level
   - required authorities
   - hydration requirements
   - policy requirements
4. Keep old handler code but call through dispatcher wrapper.
5. Delete direct channel routing only after parity tests.

### Acceptance

- New handler cannot be added without metadata.
- Mutation-capable handler cannot bypass contract/hydration/policy.
- Old direct dispatcher shrinks over time.
- CI reports remaining monolith handlers by risk.
- No behavior rewrite required in first pass.

---

## P2.61 — Build local replay artifact from ActionTrace and DecisionExplainer

### Problem

`action-trace.js` and `decision-explainer.js` exist, but the project needs a practical local replay artifact to debug why a page was classified or why a rule/action was allowed.

### Fix

Add local-only export:

`dist/build/certificate/local-replay/<timestamp>.json`

Fields:

- extension version
- policy schema version
- browser capability snapshot
- normalized hostname/path class
- page classification reasons
- policy profile
- policy diff from previous snapshot
- active layers
- issued capabilities by layer, redacted IDs
- DNR decision summary
- allow-rule provenance
- recovery/safe-mode transitions
- compatibility entry link
- fixture suggestion

Do not include:

- raw page text
- form values
- cookies
- local/session storage
- full query strings
- request bodies
- private tokens

### Acceptance

- A user can attach replay artifact to a bug report without leaking page content.
- A test can replay the policy decision offline.
- Replayer can produce synthetic fixture stub.
- ActionTrace is bounded and privacy scrubbed.

---

## P2.62 — Create a separate "generalization readiness" score

### Problem

The public release badge/certificate is currently mixed with superiority/benchmark claims. That does not directly answer the architectural question:

> Is the extension generalized enough to avoid site-by-site breakage?

### Fix

Add a separate score:

`Generalization Readiness: 0–100`

Dimensions:

- active manifest bootstrap-only: 0/10
- structural classification active: 0/10
- normalized policy shape: 0/10
- authority modules active: 0/10
- mutation tokens enforced: 0/10
- DNR transaction authority enforced: 0/10
- compatibility debt non-expired: 0/10
- fixtures for app/auth/payment/video: 0/10
- privacy-safe signal collection: 0/10
- CI fail-closed checks: 0/10

### Acceptance

- Score is generated from checks, not hand-written.
- README distinguishes:
  - release certificate
  - benchmark superiority
  - store compliance
  - generalization readiness
- Score cannot be higher than the weakest critical authority gate.
- Bronze/Silver/Gold terminology is not reused for this score unless clearly defined.

---

## P3.60 — Add ownership and lifecycle metadata for authority modules

### Problem

The repo now has many one-file authorities. Without lifecycle metadata, it becomes hard to know which are active, which are prototypes, and which are safe to delete.

### Fix

For every authority module, add metadata either in file header or central inventory:

- owner
- status
- active runtime path
- required tests
- required docs
- required callers
- mutation APIs controlled
- deprecation plan if inactive

### Acceptance

- Authority files are not counted as complete unless active.
- Unused authority files are not silently kept forever.
- Cleanup tools can distinguish real code from prototypes.
- Coding agents have a clear target.

---

## P3.61 — Remove or correct inaccurate completion language

### Problem

Some comments and docs state completed architecture that the manifest-selected runtime does not yet implement.

Example:

- `bootstrap.js` says the manifest injects only it.
- Summary language says runtime activation protocol exists and every runtime layer uses it, but active `activatePageLayers` only returns layer names.

### Fix

Add a documentation truth check:

`tools/check-architecture-claims.mjs`

It should scan selected docs/comments for strong claims such as:

- "only"
- "every"
- "must"
- "source of truth"
- "no runtime may"
- "all required gates pass"

Then verify those claims against manifest/runtime checks or require a claim ID with evidence.

### Acceptance

- No source comment claims bootstrap-only unless manifest proves it.
- No public doc says all required gates pass if a required gate is FAIL.
- No authority doc says "must" unless CI enforces it.
- Architecture claims become evidence-linked.

---

# Updated implementation order after `7f97...`

This order is chosen to get small/big wins first while preventing further authority sprawl.

## Wave 1 — Stop false authority and fix broken checks

1. Fix `PolicySnapshot.create()` constructor bug and add snapshot/token tests.
2. Fix `tools/check-cross-layer-integration.mjs`:
   - replace undefined `srcDir`
   - set `failed = true` on violations
   - fail on missing imports/registry references
   - include in `check:all`
3. Add active authority inventory and check.
4. Fix compatibility config shape validation and expired-entry enforcement.
5. Fix README/BENCHMARK certificate contradiction.

## Wave 2 — Make policy actually service-worker-owned

6. Stop accepting caller-supplied policy in `activatePageLayers`.
7. Wire pageSignals into the active `getPagePolicy` path.
8. Create service-worker-owned policy snapshots.
9. Return capability tokens only from snapshots.
10. Invalidate snapshots on navigation/settings/filter/whitelist changes.

## Wave 3 — Make mutation paths obey authorities

11. Route every DNR write through transaction authority.
12. Route whitelist/trusted-site allow rules through allow-rule authority.
13. Make DNR transaction verify exact rule equality.
14. Wire message contracts into dispatcher.
15. Wire hydration gate into dispatcher/startup.

## Wave 4 — Reduce global runtime footprint

16. Align manifest with bootstrap-only or explicitly mark transitional runtime.
17. Split active content runtime into bootstrap/policy/engine bundles.
18. Audit top-level side effects in globally imported content modules.
19. Integrate CSS injection registry with actual removal.
20. Move site-specific protected UI logic into adapter fixtures.

## Wave 5 — Make generalization measurable

21. Generate active runtime graph certificate.
22. Add browser capability runtime detector.
23. Add local replay artifact.
24. Add generalization readiness score.
25. Add architecture-claim truth checker.

---

# v6 definition of done

The `7f97...` generalization wave should not be considered done until all of the following are true:

- The manifest-selected runtime matches the architecture docs.
- Heavy content engines do not load globally before policy.
- Page signals drive profile selection in the active path.
- Content scripts cannot submit their own effective policy.
- The service worker creates policy snapshots.
- Capability tokens are issued from trusted snapshots.
- Tokens are unforgeable and bound to tab/frame/document/layer/action/revision.
- Mutation APIs reject calls without valid capability.
- Every DNR write goes through DNR authority/transaction.
- DNR transaction rollback verifies exact rule equality.
- Whitelist/trusted-site allow rules go through allow-rule authority.
- Message contracts gate every mutation-capable handler.
- Hydration gate protects service-worker cold-start mutations.
- Compatibility entries are non-expired or downgraded to fixture-only.
- Manifest host exclusions are synchronized with compatibility metadata.
- Policy config passes schema validation.
- Runtime layers read one normalized policy shape.
- Public certificate/badge language matches actual gate results.
- CI fails on authority bypasses.

---

# v6 coding-agent prompt

Use this prompt for the next implementation agent if you want to turn the current review into code.

```text
Implement the v6 generalization enforcement wave for Astrocytech/uBlockResurrected at commit 7f97a6703b1b6edc6d7da6bda6ba39d061b07bff or newer.

Do not add new host-specific exclusions as the primary fix.
The goal is to make the existing authority primitives mandatory in the active manifest-selected runtime.

Required first wave:

1. Fix platform/chromium/js/policy-snapshot.js:
   - PolicySnapshot.create must instantiate the internal snapshot class, not the exported object.
   - Add tests for create, issueToken, replacement invalidation, invalidateAll, invalidate(tabId, frameId).

2. Fix tools/check-cross-layer-integration.mjs:
   - Remove the undefined srcDir bug.
   - Convert warnings into failures for required integration.
   - Verify active runtime imports or uses required authority modules.
   - Include the check in the check:all path.

3. Add active authority inventory:
   - config/active-authorities.json
   - tools/check-active-authorities.mjs
   - Mark each authority active/prototype/inactive.
   - Fail if active authorities are not imported/used by manifest-selected runtime.

4. Stop accepting caller-supplied policy in activatePageLayers:
   - Content scripts may send page identity and bounded pageSignals only.
   - SW must resolve policy, create PolicySnapshot, and return active layers/tokens.
   - Add a test proving forged content policy is ignored.

5. Wire pageSignals into the active getPagePolicy path:
   - Use structural classifier for app-shell/auth/payment/video/default-web.
   - Do not collect page text, form values, raw query strings, localStorage, cookies, or request bodies.
   - Add fixtures for app-shell, auth, payment, video, article/default-web.

6. Make page-policy schema validation real:
   - Add check:page-policy-schema.
   - Normalize mixed flat/nested policy fields.
   - Current config must pass.
   - Contradictory flat/nested values must fail.

7. Route DNR writes through transaction authority:
   - Ban direct chrome.declarativeNetRequest.updateDynamicRules/updateSessionRules outside authority modules/tests.
   - Convert schema clear, whitelist, stealth, and filter-list sync paths.
   - Verify rollback by exact normalized rule equality, not only counts.

8. Route whitelist/trusted-site allow rules through AllowRuleAuthority:
   - Every allow rule must have source, scope, reason, owner, risk class, expiry/permanent justification, and undo path.
   - Expired temporary allow entries must not generate DNR rules.

9. Wire MessageContracts and HydrationGate into the canonical SW dispatcher:
   - Every msg.what handler must have a contract.
   - Mutation messages must require policy readiness.
   - Cold-start mutation messages must queue or fail retryably until hydrated.

10. Fix compatibility/certificate truth:
   - Validate current compatibility-sites.json shape.
   - Fail expired temporary compatibility entries.
   - Sync manifest exclude_matches with compatibility metadata.
   - Fix README/BENCHMARK Bronze/Silver/no_remote_rule_fetch contradictions.

Acceptance:
- npm run typecheck, if available.
- npm run test or targeted test suite.
- npm run check:all or closest available subset.
- No new site-specific domain exclusions as the main solution.
- Unknown app pages are safe through structural classification and policy, not hostname denylisting.
- High-risk mutation paths cannot bypass policy snapshot, capability token, message contract, hydration gate, and DNR transaction authority.
```
