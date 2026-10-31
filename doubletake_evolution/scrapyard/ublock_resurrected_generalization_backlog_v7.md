# uBlock Resurrected Generalization Backlog v7

Updated: 2026-06-27

Previous version rated: **9.36 / 10.00**

Post-commit review: `42dbe71f760ade1c86c234e4ef2521bd441254ee`

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



---

# v5 pass after commit `42dbe71f760ade1c86c234e4ef2521bd441254ee`

Commit reviewed: `42dbe71f760ade1c86c234e4ef2521bd441254ee`

Commit title observed:

```txt
P1.6, P1.10, P1.12, P1.17: wildcard gate, observer budget, release parity, static rule classifier bridge
```

## What this commit appears to have improved

This pass does not repeat the old backlog items. It treats the following as partially or newly addressed and then lists the next generalized work that should follow from them.

```txt
1. Smart cosmetic wildcard host matching is no longer blindly true.
   Wildcard targets now need `metadata.scope === "test-only"` or `safety.allowGlobal === true`.

2. A shared observer-budget primitive was added.
   It defines profile budgets for default web pages, app-shell pages, and auth-sensitive pages.

3. A release-manifest parity checker was added.
   It compares dev and release manifest surfaces and checks some dev-only rulesets/permissions.
```

The remaining work is mostly about turning these primitives into enforced architecture rather than leaving them as isolated helpers.

---

# New non-repeating backlog items from the post-commit review

## P0.31 Wire the observer budget into every active observer layer

### Problem

`src/js/runtime/observer-budget.ts` now exists, but a budget primitive is not enough. The breakage risk remains if video, cosmetic, smart-content, first-party detection, YouTube logic, shadow DOM scanning, and DOM surveyors continue to create `MutationObserver`s independently.

The generalized solution is not “make each observer safer by hand.” The generalized solution is one runtime lease system that every observer must pass through.

### Files

```txt
src/js/runtime/observer-budget.ts
src/js/video-adblock/video-engine.ts
src/js/contentscript/first-party-ad-detector.ts
src/js/smart-content.ts
platform/chromium/js/contentscript.js
platform/chromium/js/smart-content.js
platform/chromium/js/video-adblock-generic.js
tools/check-observer-budget-usage.mjs
tests/runtime/observer-budget-usage.spec.ts
```

### Generalized fix

Add an observer registry API:

```ts
type RuntimeLayer =
  | 'cosmetic-generic'
  | 'cosmetic-specific'
  | 'smart-cosmetic'
  | 'video-generic'
  | 'video-site-adapter'
  | 'first-party-ad-detector'
  | 'youtube-mainworld'
  | 'logger-inspector';

type ObserverLease = {
  id: string;
  layer: RuntimeLayer;
  profile: PageProfile;
  release(): void;
  canUseAttributes: boolean;
  maxNodesPerCycle: number;
  maxMsPerCycle: number;
};

export function requestObserverLease(args: {
  layer: RuntimeLayer;
  profile: PageProfile;
  wantsAttributeObserver: boolean;
  reason: string;
}): ObserverLease | null;
```

Every runtime layer must call `requestObserverLease()` before starting a `MutationObserver`. App-shell pages should receive fewer leases. Auth-sensitive pages should receive no mutating observers by default.

### Acceptance check

```txt
1. Static check fails if `new MutationObserver(` appears outside approved observer-registry code or approved tests.
2. Runtime test proves `app-shell` pages allow at most one observer.
3. Runtime test proves `auth-sensitive` pages allow zero observers.
4. Attribute observers are denied when `allowAttributeObservers === false`.
5. All existing observers either use the registry or are explicitly marked test-only.
```

---

## P0.32 Add an “unused generalization primitive” check

### Problem

The repo now has generalization primitives such as observer budgets and release parity checks. A common failure mode is adding the primitive but not wiring it into runtime or CI. That looks like progress but does not change behavior.

### Files

```txt
tools/check-generalization-primitive-usage.mjs
package.json
tests/safety/generalization-primitive-usage.spec.ts
```

### Generalized fix

Create a manifest of primitives and required usage points:

```json
{
  "observer-budget": {
    "source": "src/js/runtime/observer-budget.ts",
    "requiredRuntimeImports": [
      "video-engine",
      "smart-content",
      "first-party-ad-detector",
      "dom-surveyor"
    ],
    "requiredChecks": [
      "check:observer-budget-usage"
    ]
  },
  "release-manifest-parity": {
    "source": "tools/check-release-manifest-parity.mjs",
    "requiredPackageScripts": [
      "check:release-manifest-parity",
      "check:base"
    ]
  }
}
```

The check should fail when a new primitive exists but is not imported, not tested, or not included in an npm check group.

### Acceptance check

```txt
1. `observer-budget.ts` without runtime imports fails CI.
2. `check-release-manifest-parity.mjs` without package script wiring fails CI.
3. Adding a new primitive requires updating the primitive manifest.
4. Test-only primitives must be explicitly marked as test-only.
```

---

## P0.33 Validate smart cosmetic wildcard rules at import time, not only at match time

### Problem

The smart cosmetic engine now refuses wildcard targets unless the rule is test-only or explicitly marked safe. That is good, but match-time rejection is late. Unsafe wildcard rules can still be loaded, stored, synced, exported, shown in UI, and counted as active.

The generalization should move wildcard safety into rule validation and import.

### Files

```txt
src/core/smart-cosmetic/engine.ts
src/core/smart-cosmetic/rule-store.ts
src/core/smart-cosmetic/schema.ts
src/core/smart-cosmetic/validator.ts
tests/smart-cosmetic/wildcard-safety.spec.ts
tools/check-smart-rule-safety.mjs
```

### Generalized fix

Add a validator:

```ts
export function validateSmartRuleSafety(rule: SmartCosmeticRule): ValidationResult {
  const hasWildcardTarget = rule.targets.some(t => t.value === '*');

  if (hasWildcardTarget) {
    if (rule.metadata?.scope === 'test-only') return ok();
    if (rule.safety?.allowGlobal === true && rule.safety?.maxMatches !== undefined) return ok();
    return fail('SMART_RULE_GLOBAL_TARGET_REQUIRES_SAFETY_METADATA');
  }

  return ok();
}
```

Apply this at every entry point:

```txt
rule import
rule creation
collection sync
test fixture load
storage migration
UI edit/save
```

### Acceptance check

```txt
1. Unsafe wildcard smart rules are rejected before storage.
2. Existing unsafe stored wildcard rules are disabled during migration.
3. UI shows why a wildcard rule was rejected.
4. Test-only wildcard rules cannot be bundled into release artifacts.
5. Runtime engine still keeps the match-time guard as a second line of defense.
```

---

## P0.34 Replace boolean wildcard approval with a safety envelope

### Problem

`safety.allowGlobal === true` is too broad as a long-term contract. A boolean does not say what kind of global behavior is allowed, how many nodes can be touched, whether procedural selectors are allowed, whether scriptlets may run, or whether the rule can mutate DOM.

### Files

```txt
src/core/smart-cosmetic/schema.ts
src/core/smart-cosmetic/validator.ts
src/core/smart-cosmetic/engine.ts
tests/smart-cosmetic/safety-envelope.spec.ts
```

### Generalized fix

Replace or wrap the boolean with a structured safety envelope:

```ts
type GlobalRuleSafety = {
  allowGlobal: true;
  maxMatches: number;
  allowedActions: Array<'hide' | 'style' | 'mark-only'>;
  forbiddenContexts: Array<'app-shell' | 'auth-sensitive' | 'payment' | 'editor'>;
  requiresSpecificSelector: boolean;
  allowProceduralSelectors: boolean;
  allowScriptlets: false;
  evidence: {
    fixtureIds: string[];
    reason: string;
  };
};
```

### Acceptance check

```txt
1. `allowGlobal: true` without `maxMatches` fails validation.
2. Global rules cannot run scriptlets.
3. Global rules cannot run on app-shell/auth-sensitive profiles unless explicitly allowed by policy.
4. Every release global rule references at least one fixture ID.
```

---

## P0.35 Make `check-release-manifest-parity` a safety-invariant check, not a global-injection check

### Problem

The new release parity checker currently checks that the release manifest still has global HTTP/HTTPS content-script matches. That verifies parity, but it can also preserve the wrong architecture. Long term, the goal is to reduce broad global injection, not require it forever.

### Files

```txt
tools/check-release-manifest-parity.mjs
tools/check-production-rule-surface.mjs
tools/generate-release-manifest.mjs
package.json
tests/tools/check-release-manifest-parity.spec.ts
```

### Generalized fix

Change the checker from “same broad content-script surface” to “same or safer risk surface.”

Preferred checks:

```txt
release content scripts must not be broader than dev
release content scripts must not add new MAIN-world scripts
release must not remove safety excludes without a policy replacement
release must not include dev/test rulesets
release must not include dev-only permissions
release must not increase all_frames/match_about_blank usage
release must not add web_accessible_resources for dynamic code or unsafe HTML
release must include the same or stricter policy bootstrap
```

### Acceptance check

```txt
1. Removing global injection from release must pass if a policy bootstrap replaces it.
2. Adding a new global content script must fail unless it is a thin bootstrap.
3. Adding MAIN-world release injection must fail unless it has capability metadata.
4. The check is wired into `check:base`, `check:security`, or `check:all`.
```

---

## P0.36 Wire new checks into package scripts automatically

### Problem

A new checker file can exist without being reachable from `npm run check:all`. That means a real invariant can silently sit outside CI.

### Files

```txt
package.json
tools/check-command-consistency.mjs
tools/check-unwired-checks.mjs
tests/tools/check-unwired-checks.spec.ts
```

### Generalized fix

Add a checker that scans `tools/check-*.mjs` and verifies each one is either:

```txt
1. referenced by a package script;
2. referenced by a generated command graph;
3. marked as manual-only with an explicit reason;
4. marked as deprecated with removal date.
```

### Acceptance check

```txt
1. `tools/check-release-manifest-parity.mjs` without package wiring fails.
2. A manual-only check must include owner, reason, and review date.
3. `check:all` reports the command graph summary.
4. Duplicate script aliases are detected and reported.
```

---

## P0.37 Add a profile resolver before observer-budget lookup

### Problem

`getObserverBudget(profile = "default-web")` assumes some other layer already classified the page profile. Without a central profile resolver, each runtime layer may guess its own profile or default to `default-web`, which weakens the safety model.

### Files

```txt
src/js/runtime/page-profile.ts
src/js/runtime/observer-budget.ts
platform/chromium/js/policy-resolver.js
tests/runtime/page-profile.spec.ts
tools/check-page-profile-policy.mjs
```

### Generalized fix

Add a single resolver:

```ts
type PageProfile =
  | 'default-web'
  | 'article-page'
  | 'video-page'
  | 'app-shell'
  | 'auth-sensitive'
  | 'payment-sensitive'
  | 'editor-sensitive'
  | 'unknown-complex-app';

export function resolvePageProfile(input: {
  url: string;
  documentSignals?: DocumentSignals;
  frameType: 'top' | 'sub' | 'about-blank';
  userOverrides?: Record<string, unknown>;
}): PageProfile;
```

Then observer budget, scriptlets, cosmetics, video adapters, response mutation, and frame policy all consume the same profile.

### Acceptance check

```txt
1. No runtime layer calls `getObserverBudget("default-web")` directly unless profile resolution failed safe.
2. App-shell signals resolve to app-shell or unknown-complex-app.
3. Auth and payment pages resolve to stricter profiles.
4. Profile decisions are available in diagnostics without leaking page content.
```

---

## P0.38 Make observer budgets enforce work, not only observer counts

### Problem

The budget primitive tracks `maxObservers`, `maxNodesPerCycle`, `maxMsPerCycle`, and `allowAttributeObservers`, but `checkObserverBudget()` only checks observer count. That leaves the important limits unenforced.

### Files

```txt
src/js/runtime/observer-budget.ts
src/js/runtime/work-budget.ts
tests/runtime/observer-work-budget.spec.ts
```

### Generalized fix

Add a cycle helper:

```ts
export function runBudgetedObserverCycle<T>(args: {
  lease: ObserverLease;
  nodes: T[];
  process: (node: T) => void;
  now?: () => number;
}): {
  processed: number;
  skipped: number;
  timedOut: boolean;
};
```

Every observer callback should process through this helper. The helper should stop after node count or time budget is exceeded.

### Acceptance check

```txt
1. A callback with 10,000 nodes processes only the allowed number.
2. A callback exceeding `maxMsPerCycle` stops and schedules backoff.
3. A runtime health event is emitted for repeated budget overrun.
4. App-shell profile uses stricter cycle limits than default-web.
```

---

## P0.39 Add observer backoff and auto-disable after repeated budget violations

### Problem

A budget that only denies new observers is not enough. A page can still become unstable if an allowed observer repeatedly exceeds its node or time budget.

### Files

```txt
src/js/runtime/observer-budget.ts
src/js/runtime/runtime-health.ts
src/js/runtime/layer-disable.ts
tests/runtime/observer-backoff.spec.ts
```

### Generalized fix

Add per-layer violation counters:

```txt
1st violation: skip remaining nodes this cycle
2nd violation: increase scan interval/backoff
3rd violation: disable the layer for this tab
4th violation across tabs: disable the layer globally until restart or setting reset
```

Do not disable all filtering. Disable the smallest responsible layer.

### Acceptance check

```txt
1. Repeated video observer overruns disable only video-generic.
2. Cosmetic-specific still runs if video-generic is disabled.
3. User sees a diagnostic reason, not a silent failure.
4. Reloading the tab clears tab-local violations but not global temporary disables.
```

---

## P0.40 Add a central target-matching utility for host/domain/entity/regex/wildcard

### Problem

The smart cosmetic engine has target matching logic directly inside `ruleMatchesHost()`. Other parts of the extension also need host/domain/entity/regex/wildcard matching. If every layer implements this separately, wildcard safety and domain boundaries drift.

### Files

```txt
src/core/matching/target-matcher.ts
src/core/matching/domain-utils.ts
src/core/smart-cosmetic/engine.ts
platform/chromium/js/sw.js
tests/core/target-matcher.spec.ts
tools/check-target-matcher-usage.mjs
```

### Generalized fix

Move matching into a central function:

```ts
export function targetMatchesHostname(args: {
  target: RuleTarget;
  hostname: string;
  safety: RuleSafety;
  context: MatchContext;
}): MatchResult;
```

It should handle:

```txt
host exact match
domain match using public-suffix-aware registered domain
entity match
safe regex match with timeout/fallback
wildcard match requiring safety envelope
invalid targets with structured errors
```

### Acceptance check

```txt
1. Smart cosmetic engine uses target matcher.
2. Any new host/domain/entity matcher outside the utility fails CI.
3. Wildcard target behavior is identical across rule import, runtime match, and tests.
4. Domain matching does not assume the last two labels are the registered domain.
```

---

## P0.41 Add release artifact existence and freshness checks

### Problem

`check-release-manifest-parity` currently skips if `platform/chromium/manifest.release.json` is missing. That is acceptable for a standalone manual check, but not for release gating. A release check should fail if the release artifact is missing or stale.

### Files

```txt
tools/check-release-manifest-parity.mjs
tools/generate-release-manifest.mjs
tools/check-release-artifact-freshness.mjs
package.json
tests/tools/release-artifact-freshness.spec.ts
```

### Generalized fix

Split modes:

```txt
--mode=dev: warn if release manifest is missing
--mode=release: fail if release manifest is missing
--mode=ci: generate release manifest first, then check freshness and parity
```

Add freshness check:

```txt
manifest.release.json must be generated from current manifest.json
hash of source manifest must match recorded generation metadata
release generator version must match recorded version
```

### Acceptance check

```txt
1. Release mode fails when manifest.release.json is missing.
2. Release mode fails when dev manifest changed after release manifest generation.
3. Dev mode can warn but must not silently pass in release CI.
4. `check:release-readiness` includes this check.
```

---

## P0.42 Add a static-rule classifier bridge that produces visible evidence

### Problem

The commit title mentions a static rule classifier bridge, but the visible changed files in the reviewed commit mainly show wildcard gating, observer budget, and release parity. If a static rule classifier bridge exists elsewhere, it needs clear evidence. If it does not, it remains a gap.

### Files

```txt
src/core/rules/static-rule-classifier.ts
tools/build-static-rulesets.mjs
tools/check-static-rule-classifier-bridge.mjs
dist/build/certificate/static-rule-classifier-evidence.json
tests/compiler/static-rule-classifier-bridge.spec.ts
```

### Generalized fix

Static rules should be classified before they become DNR rules:

```ts
type StaticRuleClassification = {
  risk: 'low' | 'medium' | 'high' | 'critical';
  evidence: string[];
  allowedResourceTypes: string[];
  forbiddenResourceTypes: string[];
  requiresInitiatorConstraint: boolean;
  requiresDomainSpecificity: boolean;
  canEnterStaticRuleset: boolean;
  canEnterDynamicRuleset: boolean;
};
```

The bridge should write a certificate artifact containing:

```txt
count by risk class
rules rejected by reason
rules downgraded or narrowed
rules requiring initiator constraints
rules allowed into static rulesets
rules excluded from release
```

### Acceptance check

```txt
1. Static ruleset build cannot add a high-risk script/xhr/websocket block without classifier approval.
2. Classifier output is saved as evidence.
3. CI fails if static rulesets are built without classifier evidence.
4. Dynamic and static pipelines use the same classifier rules.
```

---

## P0.43 Add a “generalization implementation status” index

### Problem

The backlog now has many items. Some are implemented, some are partial, and some are still design-only. Without a status index, it becomes easy to repeat work or claim an item is done because a helper file was added.

### Files

```txt
docs/generalization/status.md
dist/build/certificate/generalization-status.json
tools/check-generalization-status.mjs
```

### Generalized fix

Track each backlog item with a machine-readable state:

```yaml
P1.10:
  title: Observer budgets
  status: partial
  implemented:
    - src/js/runtime/observer-budget.ts
  missing:
    - runtime integration
    - static usage check
    - budget overrun tests
    - CI wiring
  evidence:
    - tests/runtime/observer-budget.spec.ts
  next_action: P0.31
```

### Acceptance check

```txt
1. Every backlog item has one of: not-started, partial, implemented, superseded.
2. Partial items must list missing work.
3. Implemented items must link to tests/checks/evidence.
4. CI fails if a completed status lacks evidence.
```

---

## P1.29 Convert observer budget into a runtime layer scheduler

### Problem

A budget answers “may this layer observe?” A scheduler answers “when should this layer run, how often, and in what order?” Without a scheduler, layers can independently wake up and fight each other even if each one obeys a local budget.

### Files

```txt
src/js/runtime/layer-scheduler.ts
src/js/runtime/observer-budget.ts
src/js/runtime/runtime-health.ts
tests/runtime/layer-scheduler.spec.ts
```

### Generalized fix

Add a scheduler:

```ts
type LayerTask = {
  layer: RuntimeLayer;
  priority: 'critical' | 'normal' | 'background';
  costEstimate: number;
  canRunOnProfile(profile: PageProfile): boolean;
  run(deadline: RuntimeDeadline): Promise<void> | void;
};
```

The scheduler should:

```txt
batch DOM scans
avoid duplicate scans by different layers
defer background scanning on app-shell pages
run specific/site-confirmed filters before generic heuristics
stop lower-priority layers when budget is exhausted
```

### Acceptance check

```txt
1. Generic video scanning does not run before page policy/profile exists.
2. Cosmetic-specific can run without enabling cosmetic-generic.
3. Background scans pause under app-shell profile.
4. A single scheduler telemetry event reports skipped/deferred layers.
```

---

## P1.30 Add a feature-flag registry for staged generalization rollout

### Problem

Generalization changes can be risky if flipped all at once. The extension needs a central way to enable a new policy path per layer, profile, or build type without adding one-off conditionals everywhere.

### Files

```txt
src/js/runtime/feature-flags.ts
platform/chromium/js/policy-resolver.js
tools/check-feature-flag-registry.mjs
tests/runtime/feature-flags.spec.ts
```

### Generalized fix

Add flags such as:

```txt
policyBootstrapOnly
observerBudgetEnforced
smartWildcardValidationStrict
releaseParitySafetyMode
staticRuleClassifierRequired
genericVideoKnownAdapterOnly
```

Each flag should declare:

```txt
default in dev
default in release
owner
expiry/review date
fallback behavior
associated check/test
```

### Acceptance check

```txt
1. No ad-hoc `if (EXPERIMENTAL_...)` flags outside registry.
2. Expired flags fail CI.
3. Release defaults are stricter than or equal to dev defaults.
4. Diagnostics can report active flags without exposing browsing data.
```

---

## P1.31 Add policy-aware release manifest generation

### Problem

Release manifest generation should not be a text cleanup step only. It should be driven by the same policy/capability model that governs runtime.

### Files

```txt
tools/generate-release-manifest.mjs
src/core/policy/capability-registry.ts
tools/check-release-manifest-parity.mjs
tests/tools/generate-release-manifest-policy.spec.ts
```

### Generalized fix

Generate release manifest from a manifest capability registry:

```ts
type ManifestCapability = {
  permission?: string;
  hostPermission?: string;
  contentScript?: string;
  world?: 'ISOLATED' | 'MAIN';
  allFrames?: boolean;
  matchAboutBlank?: boolean;
  risk: 'low' | 'medium' | 'high';
  allowedInRelease: boolean;
  evidenceCheck: string;
};
```

The generator should remove anything not approved for the release profile.

### Acceptance check

```txt
1. MAIN-world content scripts require a release-approved capability.
2. all_frames + match_about_blank requires frame-policy evidence.
3. Release manifest cannot add permissions outside the registry.
4. The release parity checker uses capability diffs, not manual string checks.
```

---

## P1.32 Generalize “YouTube-only” safety checks into reusable layer templates

### Problem

The repo has many YouTube-specific checks and strong safety gates. That is good for YouTube, but generalization requires extracting reusable templates instead of creating a parallel custom safety universe for each site.

### Files

```txt
tools/check-layer-template.mjs
tools/check-youtube-*.mjs
src/js/runtime/layer-template.ts
docs/generalization/layer-template.md
```

### Generalized fix

Define a reusable layer template:

```txt
network layer template
cosmetic layer template
main-world hook layer template
video adapter template
surrogate/redirect layer template
observer-heavy layer template
```

Each template should require:

```txt
capability declaration
policy profile compatibility
budget limits
reversibility contract
diagnostics event class
fixture coverage
release eligibility
```

### Acceptance check

```txt
1. YouTube checks map to reusable templates.
2. New site-specific layer must choose a template.
3. Template gaps fail the layer check.
4. No new site-specific safety check can be added without declaring whether it should become a reusable template.
```

---

## P1.33 Add a “site exception retirement” workflow

### Problem

Some site exceptions are still needed as emergency safety. But every exception should have a path toward deletion. Otherwise, exception lists become the architecture.

### Files

```txt
src/core/compat/exception-registry.ts
docs/generalization/site-exception-retirement.md
tools/check-site-exception-retirement.mjs
tests/compat/site-exception-retirement.spec.ts
```

### Generalized fix

Every exception entry should include:

```txt
site/pattern
reason
breakage class
owner
added date
review date
generalization item that should replace it
synthetic fixture ID
current status: active / retired / fixture-only
```

### Acceptance check

```txt
1. Exception without review date fails CI.
2. Exception without linked generalized replacement fails CI.
3. Retired exceptions remain as fixtures, not runtime behavior.
4. Adding a new hostname exception requires a matching fixture.
```

---

## P1.34 Add a rule-build “explain plan” before DNR install

### Problem

The extension compiles and installs many DNR rules. Generalization improves if every generated rule has an explainable path: source list, parser interpretation, classifier risk, transforms applied, and final install location.

### Files

```txt
src/core/rules/rule-explain-plan.ts
tools/build-static-rulesets.mjs
platform/chromium/js/sw.js
dist/build/certificate/dnr-explain-plan.json
tests/compiler/rule-explain-plan.spec.ts
```

### Generalized fix

For each compiled rule, record:

```txt
source list
raw filter
normalized filter
resource types
initiator constraints
request domains
excluded initiators
action
risk class
classifier decision
final rule ID
ruleset target: static / dynamic / session / rejected
```

### Acceptance check

```txt
1. A high-risk rule with missing initiator constraints is rejected with explanation.
2. Rule IDs can be traced back to source filters.
3. Release artifacts include aggregate explain-plan counts.
4. User/debug UI can show “why this rule exists” without exposing private page data.
```

---

## P2.17 Move from manifest-time global injection to policy-bootstrap dynamic injection

### Problem

The manifest still has broad content-script injection as the baseline architecture. Previous backlog items already identified this. The post-commit changes make the next step clearer: the runtime now needs a bootstrap that resolves profile, capabilities, observer budget, and layer eligibility before loading heavier layers.

### Files

```txt
platform/chromium/manifest.json
platform/chromium/js/bootstrap.js
platform/chromium/js/policy-resolver.js
src/js/runtime/page-profile.ts
src/js/runtime/layer-loader.ts
tools/check-bootstrap-only-global-injection.mjs
tests/runtime/layer-loader.spec.ts
```

### Generalized fix

Manifest should globally inject only a very small bootstrap:

```txt
bootstrap loads no heavy observer
bootstrap performs no DOM mutation
bootstrap does not override fetch/XHR
bootstrap resolves host access, frame policy, page profile, and layer policy
bootstrap asks service worker for allowed layer bundle list
bootstrap dynamically imports only allowed layers
```

### Acceptance check

```txt
1. Global content script list contains only bootstrap/vAPI essentials.
2. video-generic, smart-content, first-party detector, and heavy cosmetic layers load only through policy.
3. App-shell pages load no generic mutating layers by default.
4. Release manifest fails if a heavy script is added globally.
```

---

## P2.18 Add a real runtime capability-token system

### Problem

The backlog already calls for capability gating. The post-commit observer and wildcard work show the need for tokens that are not just booleans. Each high-risk action should receive a scoped token issued by policy.

### Files

```txt
src/js/runtime/capability-token.ts
src/js/runtime/layer-loader.ts
src/js/runtime/observer-budget.ts
src/core/smart-cosmetic/engine.ts
src/js/video-adblock/safe-actions.ts
tests/runtime/capability-token.spec.ts
```

### Generalized fix

Issue scoped tokens:

```ts
type CapabilityToken = {
  id: string;
  layer: RuntimeLayer;
  action: 'observe' | 'hide' | 'remove' | 'click' | 'scriptlet' | 'main-world-hook' | 'response-mutate';
  profile: PageProfile;
  expiresAt: number;
  maxUses: number;
  constraints: Record<string, unknown>;
};
```

Mutation APIs should refuse to run without a valid token.

### Acceptance check

```txt
1. `safelyRemoveElement` fails without remove token.
2. `safelyClickVisibleSkipControl` fails without click token.
3. MAIN-world hook installation fails without main-world-hook token.
4. Tokens expire and cannot be reused after release.
```

---

## P2.19 Create a generalization dashboard artifact

### Problem

The repo now has many checks and many backlog items. Developers need a single artifact showing the generalization status: what is implemented, what is partial, what is wired into CI, and what still depends on exception lists.

### Files

```txt
dist/build/certificate/generalization-dashboard.json
tools/generate-generalization-dashboard.mjs
docs/generalization/dashboard.md
```

### Generalized fix

Generate a dashboard with:

```txt
policy primitives implemented
runtime primitives wired
checks wired into package scripts
exceptions still active
fixtures covering exceptions
high-risk APIs still globally reachable
release manifest risk surface
rules rejected by classifier
budget violations in tests
```

### Acceptance check

```txt
1. Dashboard is generated in `check:evidence`.
2. Dashboard reports partial primitives separately from implemented primitives.
3. Dashboard lists unretired site exceptions.
4. Dashboard fails release if critical generalization checks are missing.
```

---

## P3.14 Add checklist sections to commit messages for generalization commits

### Problem

Commit titles can say a generalized bridge exists, but reviewers need a consistent way to see what changed, what was wired, what was tested, and what remains partial.

### Files

```txt
.github/pull_request_template.md
docs/generalization/commit-template.md
tools/check-generalization-commit-template.mjs
```

### Generalized fix

For any commit touching policy, filtering, runtime layers, or release checks, require a short checklist:

```txt
Primitive added:
Runtime integration:
CI wiring:
Tests:
Release artifact impact:
Remaining partial work:
Site-specific patches removed:
```

### Acceptance check

```txt
1. PR template includes the checklist.
2. Generalization commits without checklist are flagged in review tooling.
3. “Primitive added” cannot be marked complete unless runtime integration and CI wiring are also addressed or explicitly marked partial.
```

---


---

# v6 rating and non-repeating pass

## Rating of v5

```txt
9.18 / 10.00
```

### Why it is already strong

The v5 document has a good architecture direction:

```txt
- It prioritizes generalized policy over hostname patches.
- It separates small/high-value safety work from larger architecture shifts.
- It tracks partial progress after commit 42dbe71f...
- It identifies the difference between adding a primitive and actually wiring it into runtime, CI, diagnostics, and release artifacts.
- It already covers DNR risk, content-script gating, observer budgets, wildcard smart cosmetics, release parity, compatibility metadata, and policy-driven activation.
```

### Why it is not a 10 yet

The remaining weakness is not lack of ideas. The weakness is closure:

```txt
- Some new primitives can exist without being consumed.
- Some checks can pass in warn/skip mode.
- Some profiles and safety fields are still stringly typed or boolean-shaped.
- There is not yet a strict contract saying every generalization item must have runtime reachability, test reachability, release reachability, and an evidence artifact.
- The check suite is large enough that command drift, duplicate aliases, stale checks, and partial wiring become their own source of risk.
```

The v6 additions below focus on those gaps without repeating the earlier backlog.

---

## P0.44 Make check severity explicit: `strict`, `warn`, or `dev-only`

### Problem

A guard script can look like a safety gate while still exiting successfully when an artifact is missing or a condition is skipped. That weakens the whole backlog because future developers may assume a check is enforced when it is only advisory.

This is especially important for release-facing checks. A missing release artifact should not silently pass in release mode.

### Files

```txt
tools/check-release-manifest-parity.mjs
tools/check-*.mjs
tools/lib/check-severity.mjs
package.json
```

### Generalized fix

Create one helper for check severity:

```ts
type CheckMode = 'dev' | 'ci' | 'release';
type Severity = 'strict' | 'warn' | 'dev-only';

function reportCheck(result: {
  id: string;
  severity: Severity;
  mode: CheckMode;
  passed: boolean;
  skipped?: boolean;
  reason?: string;
}): void;
```

Rules:

```txt
1. In release mode, strict checks cannot skip and cannot pass on missing input.
2. In CI mode, skipped checks must print a machine-readable reason.
3. In dev mode, warn checks may pass but must emit evidence that they were warnings.
4. No check may call `process.exit(0)` after a WARN unless the warning is declared in a central severity registry.
```

### Why this is a small big win

It does not redesign the extension. It prevents false confidence in the guardrail system.

### Acceptance check

```txt
1. tools/lib/check-severity.mjs exists.
2. check-release-manifest-parity uses it.
3. A fixture where manifest.release.json is missing fails in release mode.
4. A fixture where manifest.release.json is missing only warns in dev mode.
5. CI artifact records skipped/warned/failed checks separately.
```

---

## P0.45 Freeze and validate observer budget definitions

### Problem

The observer-budget primitive currently defines useful profiles, but the registry is mutable and accepts arbitrary budget objects. That is okay for a first primitive, but it should become a policy-controlled registry before runtime layers depend on it.

If any code can call `setObserverBudget(profile, budget)` without validation, a future feature can accidentally disable the protection that the observer budget is supposed to provide.

### Files

```txt
src/js/runtime/observer-budget.ts
src/js/runtime/page-profile.ts
tests/runtime/observer-budget.spec.ts
tools/check-observer-budget-safety.mjs
```

### Generalized fix

Replace open mutation with typed, validated registration:

```ts
export type PageProfile =
  | 'default-web'
  | 'media-page'
  | 'app-shell'
  | 'auth-sensitive'
  | 'payment-sensitive'
  | 'editor-sensitive';

export type ObserverBudget = Readonly<{
  maxObservers: number;
  maxNodesPerCycle: number;
  maxMsPerCycle: number;
  allowAttributeObservers: boolean;
  allowSubtreeObservers: boolean;
}>;

export function getObserverBudget(profile: PageProfile): ObserverBudget;

// Test-only or policy-registry-only. Not a public runtime escape hatch.
export function registerObserverBudgetForTests(profile: PageProfile, budget: ObserverBudget): void;
```

Validation rules:

```txt
1. Unknown profile must not silently become default-web without diagnostics.
2. Negative values are invalid.
3. app-shell and sensitive profiles cannot allow unlimited subtree+attribute observers.
4. Budget mutation is allowed only in tests or policy initialization.
5. Runtime layers receive a frozen budget object.
```

### Acceptance check

```txt
1. Object.isFrozen(getObserverBudget('app-shell')) is true in tests.
2. Unknown profile emits a structured policy warning.
3. Invalid budget registration throws in tests and fails CI.
4. Production runtime code cannot import a generic setObserverBudget escape hatch.
```

---

## P0.46 Add source-to-artifact reachability checks for new runtime primitives

### Problem

A TypeScript primitive can be added under `src/`, but the active Chromium extension may run generated or copied files under `platform/chromium/js/`. A primitive is not useful until it is reachable from the actual manifest-loaded runtime.

This is different from a simple unused-code check. The question is not only “is it imported?” The question is: “does it affect the extension that is actually loaded by Chrome?”

### Files

```txt
tools/check-runtime-primitive-reachability.mjs
docs/runtime/reachability-map.json
platform/chromium/manifest.json
src/js/runtime/observer-budget.ts
platform/chromium/js/**/*.js
```

### Generalized fix

Create a reachability map:

```json
{
  "src/js/runtime/observer-budget.ts": {
    "expectedConsumers": [
      "src/js/video-adblock/video-engine.ts",
      "src/js/smart-content.ts",
      "src/js/contentscript/first-party-ad-detector.ts"
    ],
    "expectedRuntimeArtifacts": [
      "platform/chromium/js/video-adblock-generic.js",
      "platform/chromium/js/smart-content.js",
      "platform/chromium/js/contentscript.js"
    ],
    "requiredEvidence": "dist/build/certificate/observer-budget-reachability.json"
  }
}
```

The checker verifies:

```txt
1. Source primitive is imported by expected source consumers.
2. Built platform artifacts contain the expected runtime marker or behavior.
3. Manifest-loaded files reference the built artifact.
4. Evidence artifact exists after build.
```

### Acceptance check

```txt
1. Adding a primitive without a runtime consumer fails the reachability check.
2. Importing a primitive only from tests does not count as production reachability.
3. A generated platform artifact that omits the primitive fails the check.
4. The report identifies source path, consumer path, artifact path, and manifest entry.
```

---

## P0.47 Replace ad-hoc `safety` fields with a shared safety metadata schema

### Problem

Different layers can invent their own safety fields:

```txt
allowGlobal
maxMatches
confidence
scope
risk
```

That creates a slow drift where one layer treats a field as strict, another treats it as advisory, and a third ignores it completely.

### Files

```txt
src/core/safety/safety-metadata.ts
src/core/smart-cosmetic/types.ts
src/core/static-rules/types.ts
src/js/video-adblock/types.ts
tests/safety/safety-metadata.spec.ts
tools/check-safety-metadata-consistency.mjs
```

### Generalized fix

Create one shared schema:

```ts
export type SafetyMetadata = Readonly<{
  scope: 'test-only' | 'site-specific' | 'entity' | 'global';
  risk: 'low' | 'medium' | 'high' | 'critical';
  confidence: 'exact' | 'strong' | 'heuristic' | 'unknown';
  maxMatches?: number;
  maxMutations?: number;
  reversible: boolean;
  evidenceId?: string;
  expiresAt?: string;
  allowGlobal?: boolean;
}>;
```

Rules:

```txt
1. global scope requires risk <= medium, confidence != unknown, and evidenceId.
2. critical risk requires explicit capability token.
3. heuristic confidence cannot authorize irreversible mutation.
4. expiresAt is required for site-specific compatibility workarounds.
5. No layer may define its own incompatible safety object.
```

### Acceptance check

```txt
1. Smart cosmetic rules use SafetyMetadata.
2. Static/DNR rule classifier emits SafetyMetadata.
3. Video safe actions accept SafetyMetadata or derived capability tokens.
4. check-safety-metadata-consistency fails on unknown safety keys.
5. Fixture: `allowGlobal: true` without evidenceId fails import.
```

---

## P0.48 Stop silent fallback from unknown profile to `default-web`

### Problem

A profile resolver or budget lookup that silently maps unknown values to `default-web` can make sensitive pages less protected than intended. This is a policy failure disguised as a safe default.

### Files

```txt
src/js/runtime/page-profile.ts
src/js/runtime/observer-budget.ts
src/js/policy-resolver.js
tests/runtime/page-profile.spec.ts
```

### Generalized fix

Use two different defaults:

```txt
unknown-by-bug      -> fail closed / app-shell budget / diagnostic warning
unknown-by-design   -> default-web budget / diagnostic info
```

Example result shape:

```ts
type ProfileResolution = {
  profile: PageProfile;
  confidence: 'explicit' | 'derived' | 'fallback';
  reason: string;
  safeDefaultApplied: boolean;
};
```

Policy:

```txt
1. If profile string is invalid, use app-shell or auth-sensitive safe mode, not default-web.
2. If no classifier signal exists, default-web is allowed only for normal top-level web pages.
3. about:blank, sandboxed iframes, extension pages, auth/payment/editor pages never receive default-web by silent fallback.
```

### Acceptance check

```txt
1. Invalid profile names produce a structured diagnostic.
2. Invalid profile names do not receive high observer or mutation budgets.
3. Unknown iframe context inherits parent safety restrictions.
4. Tests cover typo profile values such as `app_shel`, `appshell`, and empty string.
```

---

## P0.49 Add an invariant that safety comments must match executable checks

### Problem

Comments can say “production requires safety metadata” or “runs the same invariants,” but the actual code can later drift. Safety comments are useful, but they are not enforcement.

### Files

```txt
tools/check-safety-comment-parity.mjs
docs/safety/comment-parity.md
src/**/*.ts
platform/chromium/js/**/*.js
tools/**/*.mjs
```

### Generalized fix

Scan for high-risk safety phrases and require nearby executable enforcement or an evidence reference:

```txt
requires safety metadata
fails closed
release invariant
test-only
production-only
allowGlobal
capability token
observer budget
```

For each match, require one of:

```txt
1. A function call to a known guard helper.
2. A checker reference in package.json.
3. A test fixture ID.
4. A structured evidence ID.
```

### Acceptance check

```txt
1. A comment saying “test-only” without a metadata check fails.
2. A comment saying “release invariant” without a release-mode check fails.
3. False positives can be suppressed only with a documented suppression ID and expiry.
```

---

## P0.50 Add a command-suite drift checker for aliases, duplicates, and stale checks

### Problem

The package scripts now contain many check commands and aggregators. That is good for coverage, but it introduces a new maintenance problem:

```txt
- new checks can be added but not included in check:all;
- duplicate aliases can point to the same tool with different names;
- old commands can remain after files are deleted;
- release checks can exist but only be reachable manually;
- YouTube-specific checks can grow without a generic equivalent.
```

### Files

```txt
tools/check-command-suite-drift.mjs
package.json
docs/ci/check-taxonomy.json
dist/build/certificate/check-suite-drift.json
```

### Generalized fix

Create a check taxonomy:

```json
{
  "check:release-manifest-parity": {
    "category": "release",
    "riskLayer": "manifest",
    "requiredIn": ["check:base", "check:all"],
    "mode": ["ci", "release"],
    "specificity": "generic"
  },
  "check:youtube-observer-budget": {
    "category": "runtime",
    "riskLayer": "observer",
    "requiredGenericEquivalent": "check:observer-budget-safety",
    "specificity": "site-specific-regression"
  }
}
```

The checker reports:

```txt
1. commands whose target file does not exist;
2. check files with no package script;
3. package scripts not included in any aggregator;
4. duplicate aliases;
5. site-specific checks with no generic equivalent;
6. release checks missing from release aggregators.
```

### Acceptance check

```txt
1. Adding a new tools/check-*.mjs without package.json wiring fails.
2. Adding a package script pointing to a missing file fails.
3. Adding a YouTube-specific safety check without a generic layer-template check fails.
4. check-suite-drift.json lists all commands, categories, and aggregator reachability.
```

---

## P0.51 Add a “generic equivalent required” rule for every site-specific safety check

### Problem

Site-specific checks are useful as regression fixtures, but they can accidentally become the main architecture. For example, YouTube checks may encode good ideas that should be promoted to generic video/runtime checks.

### Files

```txt
docs/ci/check-taxonomy.json
tools/check-generic-equivalent-required.mjs
package.json
```

### Generalized fix

Every site-specific check must declare:

```json
{
  "siteSpecific": true,
  "site": "youtube",
  "genericEquivalent": "check:video-layer-template",
  "regressionPurpose": "verify known site behavior after generic policy change"
}
```

Rules:

```txt
1. Site-specific checks are allowed only as regression checks.
2. Each site-specific check must point to a generic check or an explicit exception ticket.
3. Generic check must be in check:all before the site-specific check can pass release.
```

### Acceptance check

```txt
1. Any `check:youtube-*` command without genericEquivalent fails taxonomy validation.
2. The generic equivalent must exist and be wired into check:all.
3. The report shows site-specific checks grouped under their generic risk layer.
```

---

## P1.35 Add a “policy compile target” for each runtime layer

### Problem

Policy can be defined centrally but still not become executable in every layer. A policy object should compile into explicit layer decisions:

```txt
network DNR decision
content script decision
cosmetic decision
scriptlet decision
video decision
observer budget decision
logger decision
MAIN-world decision
```

Without compile targets, layers may interpret policy differently.

### Files

```txt
src/js/policy/compiler.ts
src/js/policy/targets.ts
src/js/policy-resolver.js
tests/policy/policy-compiler.spec.ts
```

### Generalized fix

Create compile targets:

```ts
type PolicyCompileTarget =
  | 'dnr'
  | 'content-script'
  | 'cosmetic'
  | 'scriptlet'
  | 'video'
  | 'observer'
  | 'logger'
  | 'main-world';

type LayerDecision = {
  target: PolicyCompileTarget;
  enabled: boolean;
  mode: 'off' | 'observe' | 'specific-only' | 'full';
  capabilities: string[];
  budgetId?: string;
  reason: string;
};
```

Each runtime layer consumes its own compiled decision, not the raw page policy.

### Acceptance check

```txt
1. For a given page profile, all compile targets receive deterministic decisions.
2. Unknown app-shell profile compiles video/scriptlet/MAIN-world to off or observe-only.
3. Tests compare decisions across all targets for normal, app-shell, auth-sensitive, and video-page fixtures.
```

---

## P1.36 Add a “default deny for new layer capabilities” rule

### Problem

New capabilities can be added over time:

```txt
canObserveAttributes
canMutateDOM
canClick
canRewriteResponse
canInjectMainWorld
canInstallDynamicDnr
```

If new capabilities default to true or are omitted from policy, high-risk behavior can return by accident.

### Files

```txt
src/js/policy/capabilities.ts
src/js/runtime/layer-registry.ts
tools/check-policy-capability-defaults.mjs
tests/policy/capability-defaults.spec.ts
```

### Generalized fix

All capability checks must use:

```ts
hasCapability(policy, layerId, capabilityName)
```

Behavior:

```txt
1. Unknown capability returns false.
2. Missing capability returns false.
3. Capability names are enum values, not arbitrary strings.
4. New enum values require tests for every profile.
```

### Acceptance check

```txt
1. Adding a capability enum without profile tests fails.
2. Direct `policy.capabilities.includes(...)` calls fail lint.
3. Runtime layers cannot infer permission from undefined fields.
```

---

## P1.37 Add a cross-layer “same decision, same reason” diagnostic

### Problem

Different layers can disable themselves for different reasons on the same page. Sometimes that is correct, but often it hides policy drift.

Example:

```txt
cosmetic: disabled because trusted site
video: disabled because sensitive host
scriptlet: disabled because noScripting
logger: enabled because debug mode
```

A diagnostic should explain whether those decisions are consistent.

### Files

```txt
src/js/policy/decision-diagnostics.ts
platform/chromium/js/sw.js
pages/logger-ui.html
tests/policy/decision-diagnostics.spec.ts
```

### Generalized fix

For each tab, expose a structured decision bundle:

```json
{
  "tabId": 123,
  "pageProfile": "app-shell",
  "decisions": {
    "cosmetic": { "mode": "specific-only", "reason": "app-shell-profile" },
    "scriptlet": { "mode": "off", "reason": "high-risk-layer-disabled" },
    "video": { "mode": "observe", "reason": "unknown-video-site" }
  },
  "consistencyWarnings": []
}
```

### Acceptance check

```txt
1. Logger can show the policy reason for every layer.
2. Inconsistent reasons produce a warning, not silent drift.
3. Tests assert decision bundles for representative profiles.
```

---

## P1.38 Add a fixture for “generalization primitive exists but is unsafe by default”

### Problem

Current tests may catch missing primitives, but they also need to catch primitives that exist and are wired but default to unsafe behavior.

Examples:

```txt
unknown profile -> default-web with high observer budget
missing safety metadata -> allowGlobal accepted
release manifest missing -> warning pass
new capability missing -> enabled by default
```

### Files

```txt
tests/generalization/unsafe-defaults.spec.ts
fixtures/generalization/unsafe-defaults.json
tools/check-generalization-unsafe-defaults.mjs
```

### Generalized fix

Create a negative fixture suite where every missing/unknown value must fail safe:

```txt
1. unknown profile
2. unknown capability
3. unknown safety field
4. missing evidence id
5. missing release artifact
6. missing generic equivalent
7. missing runtime consumer
```

### Acceptance check

```txt
1. Every unsafe-default fixture fails before implementation.
2. Every fixture passes only when failure mode is safe and diagnostic is emitted.
3. No fixture passes by deleting the tested feature.
```

---

## P2.20 Build a generalized “risk-layer compiler” instead of independent ad hoc checkers

### Problem

The project has many checkers, many policy ideas, and many runtime layers. Over time, each checker can become its own small policy language.

That makes it hard to answer:

```txt
What risk layer does this file belong to?
Which policy controls it?
Which checks enforce it?
Which release artifact proves it?
Which sites are only regression fixtures?
```

### Files

```txt
docs/risk-layers/schema.json
docs/risk-layers/layers.json
tools/compile-risk-layers.mjs
dist/build/certificate/risk-layer-report.json
```

### Generalized fix

Define one schema:

```json
{
  "layerId": "video-generic",
  "risk": "high",
  "runtimeFiles": ["src/js/video-adblock/video-engine.ts"],
  "manifestFiles": ["/js/video-adblock-generic.js"],
  "policyTargets": ["video", "observer", "dom-mutation"],
  "requiredChecks": [
    "check:video-adblock-safety",
    "check:observer-budget-safety",
    "check:generic-equivalent-required"
  ],
  "siteRegressionChecks": ["check:youtube-*"],
  "releaseEvidence": ["video-layer-report.json"]
}
```

The compiler produces:

```txt
1. missing policy targets;
2. missing checks;
3. missing evidence;
4. site-specific checks without generic layer;
5. runtime files that mutate pages without a layer entry;
6. manifest-loaded files with no risk-layer ownership.
```

### Acceptance check

```txt
1. Every manifest-loaded JS file maps to exactly one or more risk layers.
2. Every high-risk layer has a policy target, capability gate, and release evidence.
3. Adding a new mutating script without a risk-layer entry fails CI.
```

---

## P2.21 Add a policy-to-manifest generator for content scripts

### Problem

Hand-maintained manifest content scripts are easy to patch with hostname exclusions. A policy-generated manifest would make global injection, frame behavior, MAIN-world injection, and exclusions outputs of the same policy registry.

This is larger than release-manifest parity. It makes the manifest a compiled artifact rather than the source of truth for risk policy.

### Files

```txt
src/manifest/content-script-policy.ts
tools/generate-content-script-manifest.mjs
platform/chromium/manifest.template.json
platform/chromium/manifest.json
platform/chromium/manifest.release.json
```

### Generalized fix

Define content-script entries as policy records:

```ts
type ContentScriptPolicyEntry = {
  id: string;
  layerId: string;
  files: string[];
  defaultScope: 'none' | 'specific-sites' | 'all-http';
  framePolicy: 'top-only' | 'same-origin-frames' | 'all-frames';
  world: 'ISOLATED' | 'MAIN';
  requiredCapabilities: string[];
  emergencyExclusions?: TemporaryCompatibilityException[];
};
```

The generator creates dev and release manifests from the same policy source.

### Acceptance check

```txt
1. Direct edits to content_scripts in generated manifest fail source-ownership check.
2. Adding exclude_matches requires a compatibility exception ID.
3. Release manifest cannot be broader than the policy source.
4. Generated manifest diff is deterministic.
```

---

## P3.15 Add backlog item IDs to code comments and check evidence

### Problem

Comments currently reference labels like P1.6 or P1.10, but there is no machine-readable mapping from code comments to backlog items. That makes it harder to know whether the code closed the item, partially implemented it, or only started it.

### Files

```txt
docs/generalization/backlog-index.json
tools/check-backlog-id-traceability.mjs
src/**/*.ts
tools/**/*.mjs
```

### Generalized fix

Use stable IDs:

```txt
GEN-P1-006 smart-cosmetic-wildcard-gate
GEN-P1-010 observer-budget-runtime-primitive
GEN-P1-012 release-manifest-parity
```

Each code comment referencing a backlog ID must include:

```txt
status: partial | wired | enforced | retired
check: <package script>
evidence: <artifact path>
```

### Acceptance check

```txt
1. A `P1.6` comment without a stable backlog ID fails.
2. A backlog ID marked enforced must have a passing check and evidence artifact.
3. Retired backlog IDs must point to the commit/check that retired them.
```

# Recommended next implementation order after `42dbe71f...`

Do these first because they are small-to-medium changes with high protection value:

```txt
1. P0.44 — Make check severity explicit so release guards cannot silently skip.
2. P0.36 — Wire new checks into package scripts automatically.
3. P0.46 — Add source-to-artifact reachability checks for new runtime primitives.
4. P0.31 — Wire observer budget into every active observer layer.
5. P0.45 — Freeze and validate observer budget definitions.
6. P0.33 — Validate smart wildcard rules at import time.
7. P0.47 — Replace ad-hoc safety fields with shared SafetyMetadata.
8. P0.35 — Convert release parity from global-injection parity to safety-invariant parity.
9. P0.50 — Add command-suite drift checks so new checks cannot become manual-only.
10. P0.43 — Add implementation status index so partial primitives are not mistaken for finished architecture.
```

The main pattern is:

```txt
A primitive is not done when a file exists.
It is done when runtime uses it, CI enforces it, release artifacts reflect it, and diagnostics can explain it.
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

## Rating of v6

Score: **9.36 / 10.00**

### Why it is strong

- It now covers the main breakage classes: DNR fallback risk, global injection, generic video mutation, cosmetic/scriptlet policy, runtime schema validation, observer budgets, compatibility metadata, release parity, command drift, and generalization status tracking.
- It prioritizes small changes with large safety impact before larger architecture moves.
- It repeatedly turns one-off site fixes into reusable policy, fixture, registry, and check concepts.

### Why it is not a 10 yet

- Several primitives are listed, but not enough of the backlog forces them to interact through one canonical request/page/action context.
- There is still room to generalize precedence, ownership, rate limiting, storage concurrency, API monkey-patching, and DNR quota handling.
- The document still mostly assumes each layer will behave correctly once guarded; it should also specify arbitration when multiple layers want to act on the same request, node, frame, or API.

---

# v7 pass: remaining non-repeating generalization work

This pass adds items that are not already covered by v6. The priority remains:

```txt
small change + big safety win first,
then medium architecture,
then large architecture,
then cleanup and smaller wins.
```

The main new theme is **coordination**. Previous passes added many good primitives. The next work is to make sure all layers use the same context, precedence rules, ownership model, rate limits, quota broker, and mutation arbitration.

---

## P0.52 Add a canonical `RuntimeContext` object for every decision

### Problem

Different layers can derive hostname, domain, frame ID, initiator, resource type, tab ID, document URL, and policy profile independently. That creates subtle disagreement between DNR, content scripts, smart cosmetics, video, logger, popup, and user-rule code.

This is not solved by a policy resolver alone. The policy resolver still needs a canonical input object.

### Files

- `src/js/runtime/runtime-context.ts`
- `platform/chromium/js/sw.js`
- `src/js/video-adblock/video-engine.ts`
- `src/js/smart-content.ts`
- `src/js/contentscript/*`
- `tests/runtime/runtime-context.spec.ts`

### Generalized fix

Create one normalized context shape:

```ts
type RuntimeContext = {
  tabId?: number;
  frameId?: number;
  parentFrameId?: number;
  documentUrl: string;
  frameUrl: string;
  initiatorUrl?: string;
  requestUrl?: string;
  pageHostname: string;
  frameHostname: string;
  requestHostname?: string;
  registeredDomain?: string;
  resourceType?: string;
  documentLifecycle?: 'active' | 'prerender' | 'cached' | 'unknown';
  firstParty: boolean;
  profile: PageProfile;
};
```

All policy and action decisions consume this object rather than recomputing context from raw strings.

### Acceptance check

Add `tools/check-runtime-context-usage.mjs` that fails if high-risk modules call ad-hoc URL/hostname extraction instead of using the canonical context helper.

---

## P0.53 Add a central decision precedence table

### Problem

There are many possible authorities:

- trusted-site whitelist;
- user dynamic firewall rules;
- user URL rules;
- static block lists;
- static unbreak/allow rules;
- managed enterprise policy;
- per-site switches;
- compatibility safe mode;
- runtime recovery safe mode;
- dev/test rules.

Without one precedence table, each feature can accidentally define its own ordering. That makes behavior hard to reason about and difficult to generalize.

### Files

- `src/js/policy/decision-precedence.ts`
- `platform/chromium/js/policy-resolver.js`
- `platform/chromium/js/sw.js`
- `tests/policy/decision-precedence.spec.ts`

### Generalized fix

Create a machine-readable precedence table, for example:

```txt
1. Browser cannot-run / restricted pages
2. Managed enterprise forced allow/block
3. User trusted-site disablement
4. Runtime safe mode / breakage recovery
5. User dynamic rules
6. User static/custom filters
7. Static unbreak/allow rules
8. Static block rules
9. Heuristic/runtime layers
10. Default policy
```

Each decision report must include which precedence layer won and which lower layers were suppressed.

### Acceptance check

Add tests where all authorities disagree and assert the same winner across popup, DNR planning, cosmetic planning, scriptlet planning, and logger explanations.

---

## P0.54 Add message rate limiting and backpressure by tab/channel

### Problem

Typed messages and sender authorization reduce wrong messages, but not excessive valid messages. A broken page, SPA loop, or malicious page-adjacent interaction can still cause content scripts to spam the service worker with valid requests.

### Files

- `platform/chromium/js/sw.js`
- `src/js/runtime/message-rate-limit.ts`
- `tests/runtime/message-rate-limit.spec.ts`

### Generalized fix

Add a small token bucket per `{tabId, frameId, channel, what}`. High-frequency messages should return a structured `rate_limited` error and trigger layer backoff.

Start with high-noise channels:

- cosmetic selector retrieval;
- logger/event reporting;
- element picker updates;
- video/runtime diagnostics;
- policy refresh requests.

### Acceptance check

A test sends 1,000 valid messages from one tab/channel and asserts that the service worker remains responsive, rejects excess calls, and does not write repeated storage entries.

---

## P0.55 Add idempotent content-script bootstrap guards

### Problem

Global content scripts, SPA navigations, about:blank frames, prerendered pages, and repeated extension reloads can cause the same runtime layer to initialize more than once in the same frame.

This creates duplicate observers, duplicate wrappers, duplicate CSS, and inconsistent cleanup.

### Files

- `src/js/runtime/bootstrap-guard.ts`
- `src/js/smart-content.ts`
- `src/js/video-adblock/index.ts`
- `src/js/contentscript/*`
- `tests/runtime/bootstrap-guard.spec.ts`

### Generalized fix

Create a shared bootstrap guard:

```ts
claimRuntimeLayer(layerId, context, version): ClaimResult
releaseRuntimeLayer(layerId, context): void
```

The guard should support:

- same-version duplicate detection;
- old-version replacement;
- cleanup-before-restart;
- diagnostics for double injection.

### Acceptance check

A fixture injects the same content script twice and verifies only one observer, one stylesheet, one event listener set, and one API wrapper are active.

---

## P0.56 Add a DNR quota broker before dynamic/session/static rule allocation

### Problem

The repo already has DNR budget checks and ID/priority concepts, but each rule producer can still think locally. Dynamic rules, session allow rules, whitelist rules, fallback rules, video rules, user rules, and generated static shards need a shared quota broker.

### Files

- `src/js/dnr/quota-broker.ts`
- `platform/chromium/js/sw.js`
- `tools/check-dnr-budget-planner.mjs`
- `tests/dnr/quota-broker.spec.ts`

### Generalized fix

Create a broker that allocates DNR capacity by owner:

```txt
core-static
unbreak-static
privacy-static
video-static
user-dynamic
trusted-site-session
temporary-recovery-session
emergency-runtime-session
```

Each owner receives:

- max dynamic rules;
- max session rules;
- priority band;
- eviction policy;
- telemetry label;
- failure mode.

### Acceptance check

A test fills DNR capacity and asserts lower-priority temporary/runtime rules are evicted before user rules or core unbreak rules.

---

## P0.57 Add a DNR rule-owner ledger and orphan cleanup

### Problem

Rules can remain after startup, migration, feature toggles, safe-mode transitions, or failed updates. ID ranges help, but they do not by themselves explain rule ownership, version, or cleanup responsibility.

### Files

- `src/js/dnr/rule-owner-ledger.ts`
- `platform/chromium/js/sw.js`
- `tests/dnr/rule-owner-ledger.spec.ts`
- `tools/check-dnr-orphans.mjs`

### Generalized fix

Every dynamic/session rule install should write a compact owner ledger:

```ts
type RuleOwnerRecord = {
  ruleId: number;
  owner: string;
  reason: string;
  policyVersion: number;
  createdAt: number;
  expiresAt?: number;
  cleanupMode: 'startup' | 'profile-change' | 'tab-close' | 'manual';
};
```

On startup, reconcile actual DNR rules against the ledger and remove unknown or expired rules unless explicitly preserved.

### Acceptance check

A test injects orphan dynamic/session rules, restarts the simulated service worker, and verifies they are removed or reported with a blocking check failure.

---

## P0.58 Add a global API patch registry for fetch/XHR/history/timers/listeners

### Problem

Some runtime layers may patch browser/page APIs such as `fetch`, `XMLHttpRequest`, history navigation, timers, or event listeners. YouTube-specific wrapper checks exist, but the general extension needs one registry for all page/API monkey patches.

### Files

- `src/js/runtime/api-patch-registry.ts`
- `src/js/contentscript/universal-ad-interceptor.ts`
- `src/js/video-adblock/*`
- `src/js/youtube/*`
- `tools/check-api-patch-registry.mjs`

### Generalized fix

All API patches must go through:

```ts
registerApiPatch({
  api: 'fetch' | 'XMLHttpRequest.open' | 'history.pushState' | 'addEventListener',
  owner,
  world,
  policyCapability,
  install,
  restore,
  idempotencyKey,
});
```

The registry prevents double wrapping, records ownership, exposes restore handles, and refuses high-risk patches without capability tokens.

### Acceptance check

A check fails if code assigns directly to `window.fetch`, `self.fetch`, `XMLHttpRequest.prototype.open`, or `history.pushState` outside the patch registry.

---

## P0.59 Add first-party/third-party calculation as a shared utility

### Problem

DNR, logger, popup, firewall rules, cosmetic rules, and request analysis all need first-party/third-party classification. If each layer computes it differently, rules will disagree.

### Files

- `src/js/url/party.ts`
- `platform/chromium/js/sw.js`
- `src/js/logger-ui*`
- `tests/url/party.spec.ts`

### Generalized fix

Create one function:

```ts
classifyParty({ pageHostname, frameHostname, requestHostname, initiatorHostname }):
  'first-party' | 'third-party' | 'same-site-frame' | 'opaque' | 'unknown'
```

Use public suffix boundaries and explicit handling for opaque origins, extension pages, `about:blank`, `blob:`, `data:`, and sandboxed frames.

### Acceptance check

All request/log/firewall tests use the same expected party classification fixture.

---

## P0.60 Add storage write coalescing and conflict detection

### Problem

Many runtime paths write to `chrome.storage.local`: popup settings, whitelist, stats, URL rules, element picker state, compiled counts, migrations, compatibility metadata, and evidence. Independent writes can race or overwrite each other.

### Files

- `src/js/storage/storage-writer.ts`
- `platform/chromium/js/sw.js`
- `tests/storage/storage-writer.spec.ts`

### Generalized fix

Add one write helper with:

- per-key schema validation;
- debouncing for noisy stats;
- compare-and-swap for critical settings;
- conflict warnings;
- migration lock awareness;
- structured evidence of dropped or merged writes.

### Acceptance check

A test runs concurrent whitelist/settings/rule writes and verifies no unrelated key is lost.

---

## P0.61 Add CSS/style injection ownership and cleanup registry

### Problem

DOM markers are one part of ownership. CSS injection also needs ownership. Cosmetic filtering, YouTube CSS, legacy CSS removal, element picker UI, smart cosmetics, and theme/UI styles can all inject or remove CSS.

### Files

- `src/js/runtime/style-registry.ts`
- `platform/chromium/js/sw.js`
- `src/js/contentscript/*`
- `tests/runtime/style-registry.spec.ts`

### Generalized fix

Every injected stylesheet gets:

```ts
type StyleOwner = {
  styleId: string;
  owner: string;
  scope: 'tab' | 'frame' | 'shadow-root' | 'document';
  policyCapability: string;
  reversible: boolean;
  cleanupTrigger: string[];
};
```

This makes style insertion/removal idempotent and auditable.

### Acceptance check

A test toggles cosmetic filtering repeatedly and asserts no duplicate style tags, no orphan CSS, and no removal of styles owned by other layers.

---

## P0.62 Add a shadow-DOM access policy

### Problem

Shadow DOM handling is useful for modern sites and video UIs, but broad traversal or mutation inside shadow roots can break app shells. Existing safety work mentions shadow DOM but needs one general access policy.

### Files

- `src/js/runtime/shadow-dom-policy.ts`
- `src/js/video-adblock/*`
- `src/js/contentscript/*`
- `tests/runtime/shadow-dom-policy.spec.ts`

### Generalized fix

Define shadow access levels:

```txt
none        = do not enter shadow roots
observe     = count/query only, no mutation
targeted    = only selectors from specific rules
owned-only  = only extension-created shadow roots
full        = test/dev only
```

Runtime layers request access through policy, not by directly walking every shadow root.

### Acceptance check

A synthetic app-shell fixture with custom elements remains unchanged when policy is `none` or `observe`.

---

## P0.63 Add a redirect/surrogate capability registry

### Problem

Redirects and surrogate resources are high impact. They can fix trackers and video scripts, but they can also replace critical application code if too broad.

### Files

- `src/js/dnr/redirect-capabilities.ts`
- `assets/resources/*`
- `platform/chromium/rulesets/*`
- `tools/check-redirect-resources.mjs`

### Generalized fix

Every redirect/surrogate resource must declare:

- allowed initiator profiles;
- allowed request domains;
- allowed resource types;
- expected content type;
- maximum match breadth;
- whether it is allowed in app-shell/auth/payment profiles;
- regression fixtures.

### Acceptance check

A release check fails if a redirect rule points to a surrogate without capability metadata.

---

## P0.64 Add a hardcoded-domain catalog with roles and expiry

### Problem

Hardcoded domains appear in block lists, unbreak rules, video exclusions, sensitive-site fixtures, release checks, privacy checks, and compatibility metadata. Some are policy fixtures, some are actual filter targets, some are temporary exceptions.

Without a catalog, domains keep spreading through code.

### Files

- `data/domain-catalog.json`
- `tools/check-domain-catalog.mjs`
- all tools/checks with hardcoded host arrays

### Generalized fix

Every hardcoded domain outside external filter lists must appear in the catalog with:

```json
{
  "domain": "example.com",
  "role": "regression-fixture | compatibility-exception | static-filter-target | unbreak-target | test-only | docs-example",
  "owner": "...",
  "expires": "YYYY-MM-DD or null",
  "genericReplacement": "policy/profile/check name"
}
```

### Acceptance check

A lint check fails for newly hardcoded domains unless they are cataloged.

---

## P0.65 Add policy monotonicity tests

### Problem

Profiles such as `auth-sensitive`, `app-shell`, `default-web`, `known-video`, and `tester` should form a predictable safety gradient. Right now, there is no general test that a stricter profile cannot accidentally allow more dangerous capabilities than a looser profile.

### Files

- `tests/policy/policy-monotonicity.spec.ts`
- `src/js/policy/*`

### Generalized fix

Define partial ordering between profiles:

```txt
auth-sensitive <= app-shell <= default-web <= known-video <= tester/dev
```

Then assert that stricter profiles never enable more high-risk capabilities than looser profiles unless explicitly documented by an exception.

### Acceptance check

A test compares all profile pairs and fails if `auth-sensitive` allows observers, scriptlets, API patches, generic video mutation, or broad cosmetics that `app-shell` disallows.

---

## P1.39 Add a mutation arbitration bus

### Problem

Multiple layers can try to mutate the same node or request:

- generic cosmetics;
- specific cosmetics;
- procedural cosmetics;
- smart cosmetics;
- video safe actions;
- element picker;
- first-party ad detector;
- YouTube-specific code.

Even if each layer is individually safe, the combination can be unsafe.

### Files

- `src/js/runtime/mutation-arbiter.ts`
- `src/js/contentscript/*`
- `src/js/video-adblock/*`
- `tests/runtime/mutation-arbiter.spec.ts`

### Generalized fix

Layers propose actions; the arbiter decides:

```ts
proposeMutation({ owner, target, action, confidence, reversibility, policyCapability })
```

The arbiter prevents duplicate actions, conflicting actions, mutations on protected UI, and low-confidence actions overriding high-confidence specific rules.

### Acceptance check

A fixture where three layers target the same node results in one approved action and two suppressed action reports.

---

## P1.40 Add a request-action arbitration bus

### Problem

DNR rules, user firewall rules, static allow rules, redirect rules, dynamic URL filtering, and recovery safe mode can conflict on the same request. A DNR explain plan helps, but the system still needs one arbitration model for request-level actions.

### Files

- `src/js/dnr/request-arbiter.ts`
- `platform/chromium/js/sw.js`
- `tests/dnr/request-arbiter.spec.ts`

### Generalized fix

Before installing or simulating rules, classify possible outcomes:

```txt
allow
allowAllRequests
block
redirect
upgradeScheme
modifyHeaders
observeOnly
```

Resolve conflicts through the central precedence table and emit a reason.

### Acceptance check

A conflict fixture with block, allow, redirect, and safe-mode rules returns the same action in simulator, logger explanation, and generated DNR plan.

---

## P1.41 Add policy version stamping to every runtime action

### Problem

A page can receive a policy snapshot, then settings change, then an old content script action fires. Without policy version stamping, stale actions can run after the user disables a layer or after safe mode activates.

### Files

- `src/js/policy/policy-version.ts`
- `platform/chromium/js/sw.js`
- `src/js/runtime/*`
- `tests/policy/policy-version.spec.ts`

### Generalized fix

Every policy snapshot includes `policyVersion`. Every delayed action carries the version it was authorized under. Before execution, high-risk actions verify the version is still current.

### Acceptance check

A test authorizes an action, changes policy, then verifies the stale action is rejected.

---

## P1.42 Add local fixture minimization for breakage reports

### Problem

Compatibility fixtures can grow large and site-specific. To generalize them, the project needs a way to minimize a breakage case into the smallest generic fixture: app shell + websocket + shadow DOM + video player + login form, etc.

### Files

- `tools/minimize-breakage-fixture.mjs`
- `tests/fixtures/breakage/*`
- `data/compatibility/*`

### Generalized fix

Create a local-only reducer that maps a recorded compatibility case to generic features:

```txt
uses-websocket
uses-streaming-fetch
uses-contenteditable
uses-shadow-dom
uses-auth-form
uses-history-router
uses-primary-video
uses-third-party-cdn
```

Then generate a generic fixture from those features.

### Acceptance check

A named-site compatibility entry must include a generated generic fixture or an explicit reason why it cannot yet be generalized.

---

## P1.43 Add a filter-list source trust registry

### Problem

Filter lists are not all equal. Some lists may contain only static network rules; others may contain aggressive scriptlets, redirects, procedural cosmetics, or broad exceptions. The backlog already asks for list capability manifests, but it should also include list source trust.

### Files

- `data/filter-source-trust.json`
- `src/js/filtering/source-trust.ts`
- `tools/check-filter-source-trust.mjs`

### Generalized fix

Each list source declares:

- source type: bundled, user-imported, remote, dev/test;
- allowed rule capabilities;
- update channel;
- checksum or pinned version mode;
- maximum risk level;
- whether rules may be promoted to static, dynamic, or session DNR.

### Acceptance check

An imported custom list cannot install high-risk scriptlet/redirect/procedural rules unless the user explicitly enables that capability.

---

## P1.44 Add service-worker task serialization for critical sections

### Problem

MV3 service workers restart and run asynchronous tasks. DNR sync, whitelist reload, migration, filter-list update, popup setting changes, and rule saves can overlap.

### Files

- `src/js/runtime/task-queue.ts`
- `platform/chromium/js/sw.js`
- `tests/runtime/task-queue.spec.ts`

### Generalized fix

Create named critical sections:

```txt
dnr-sync
storage-migration
whitelist-reload
filter-list-update
policy-recompute
settings-write
```

Only one task per section runs at a time; dependent sections wait or merge.

### Acceptance check

A test triggers DNR sync + whitelist reload + filter update concurrently and verifies final dynamic/session rules match the latest policy.

---

## P1.45 Add navigation lifecycle handling for BFCache, prerender, and SPA route changes

### Problem

The backlog covers per-tab lifecycle and SPA lifecycle in broad terms, but modern pages also use BFCache, prerendering, and document lifecycle transitions. Runtime layers should not mutate prerendered/cached documents as if they were active.

### Files

- `src/js/runtime/navigation-lifecycle.ts`
- `src/js/runtime/runtime-context.ts`
- `src/js/contentscript/*`
- `tests/runtime/navigation-lifecycle.spec.ts`

### Generalized fix

Normalize lifecycle events:

```txt
document_start
DOMContentLoaded
pageshow persisted=true
pagehide persisted=true
prerendering
visibilitychange
history route change
hash route change
frame detach
```

Map each event to layer actions: start, pause, resume, refresh policy, cleanup, or no-op.

### Acceptance check

A BFCache fixture navigates away and back without duplicate observers, duplicate styles, stale policy actions, or lost cleanup state.

---

## P1.46 Add a privacy-safe event aggregation layer

### Problem

Logger privacy classes are useful, but raw event production can still be too detailed. Many diagnostics only need aggregates, not URLs or selectors.

### Files

- `src/js/logger/event-aggregator.ts`
- `platform/chromium/js/sw.js`
- `tests/logger/event-aggregator.spec.ts`

### Generalized fix

Add aggregation modes:

```txt
none        = no logging
counter     = count only
bucketed    = count by risk/layer/type
redacted    = redacted labels only
full-dev    = dev only, never release
```

Runtime layers emit structured events, but release mode stores only the allowed aggregate level.

### Acceptance check

A release-profile test fails if logger output includes raw full URLs, selectors, text content, or request bodies for routine events.

---

## P1.47 Add a capability negotiation handshake between service worker and content scripts

### Problem

Policy snapshots tell a content script what it may do. But content scripts also have their own compiled capabilities depending on bundle version, browser, world, frame, and feature flags.

### Files

- `src/js/runtime/capability-handshake.ts`
- `platform/chromium/js/sw.js`
- `src/js/smart-content.ts`
- `src/js/video-adblock/index.ts`
- `tests/runtime/capability-handshake.spec.ts`

### Generalized fix

On startup, content scripts send:

```ts
{ layerId, version, world, supportedCapabilities, contextHash }
```

The service worker responds with:

```ts
{ grantedCapabilities, deniedCapabilities, policyVersion, reason }
```

No high-risk layer starts until the grant is received.

### Acceptance check

A content script with an old version or missing capability cannot start generic video mutation, response mutation, scriptlets, or procedural cosmetics.

---

## P2.22 Build a unified rule provenance graph

### Problem

Rule evidence, attribution, ownership ledgers, and filter-list capability manifests are all useful separately. The next larger generalization is a graph that connects every runtime action back to source material.

### Files

- `src/js/provenance/rule-provenance-graph.ts`
- `tools/generate-provenance-graph.mjs`
- `dist/evidence/rule-provenance-graph.json`

### Generalized fix

Represent:

```txt
filter list -> parsed rule -> normalized rule -> risk classification -> DNR rule / cosmetic rule / scriptlet -> runtime action -> logger/event evidence
```

This allows debugging and release review by asking: “Why did this action exist?”

### Acceptance check

A random installed rule/action can be traced back to a source list, parser decision, risk class, policy capability, and acceptance check.

---

## P2.23 Add a global policy conflict solver

### Problem

A precedence table is a deterministic start, but policy conflicts will become more complex as profiles, enterprise policy, safe mode, user rules, and site profiles grow.

### Files

- `src/js/policy/conflict-solver.ts`
- `tests/policy/conflict-solver.spec.ts`

### Generalized fix

Model policy inputs as constraints:

```txt
mustAllow
mustBlock
mayObserve
mustNotMutate
userOverride
managedOverride
safeModeOverride
profileDefault
```

The solver emits one final policy plus explanations for suppressed constraints.

### Acceptance check

All existing policy/profile tests route through the solver rather than duplicating if/else logic.

---

## P2.24 Add a page-risk scoring model separate from site identity

### Problem

Named sites should be regression fixtures, not runtime safety mechanisms. Page profiles help, but a richer site-independent risk score can guide unknown pages.

### Files

- `src/js/policy/page-risk-score.ts`
- `tests/policy/page-risk-score.spec.ts`

### Generalized fix

Compute risk from features:

```txt
login/password fields
payment fields
contenteditable editor
large SPA root
websocket/streaming requests
shadow DOM density
active media player
service-worker controlled page
cross-origin frame depth
history-router activity
```

Map risk score to allowed layers and observer budgets.

### Acceptance check

Synthetic fixtures classify as expected without referencing domain names.

---

## P2.25 Add generated policy documentation from schemas

### Problem

As policy schemas grow, handwritten documentation will drift. The backlog should eventually generate human docs from actual schemas and defaults.

### Files

- `tools/generate-policy-docs.mjs`
- `docs/policy-generated.md`
- `src/js/policy/schemas.ts`

### Generalized fix

Generate docs for:

- profile defaults;
- capabilities;
- risk levels;
- precedence order;
- observer budgets;
- mutation permissions;
- DNR owner quotas;
- release/dev differences.

### Acceptance check

A docs consistency check fails if generated policy docs are stale.

---

## P3.16 Add “definition of done” blocks to each backlog priority group

### Problem

The backlog has many acceptance checks, but each priority group should also have a shared definition of done so implementation does not become scattered.

### Files

- this document
- `docs/generalization-definition-of-done.md`

### Generalized fix

For each priority group, define:

```txt
P0 done = primitive wired, strict check, fixture, no new exceptions
P1 done = policy integrated, evidence artifact, migration path
P2 done = architecture replaces old path, old path guarded/deprecated
P3 done = cleanup completed, docs generated, stale code removed
```

### Acceptance check

Every completed backlog item links to the relevant definition-of-done block.

---

## P3.17 Add stale-primitive retirement rules

### Problem

As more generalization primitives are added, some will become obsolete. Without retirement rules, the repo may accumulate unused abstractions.

### Files

- `tools/check-stale-generalization-primitives.mjs`
- `docs/architecture/generalization-primitives.md`

### Generalized fix

A primitive is stale if:

- no production import exists after N commits;
- no test covers it;
- no policy references it;
- a newer primitive supersedes it;
- comments mention a backlog item that is marked complete elsewhere.

### Acceptance check

A check fails or warns when a primitive remains unused past its declared adoption window.

---

## P3.18 Add a generalization changelog separate from normal release notes

### Problem

Normal release notes focus on user-visible changes. Generalization work often changes architecture and safety invariants without visible UI changes.

### Files

- `docs/generalization-changelog.md`
- `tools/check-generalization-changelog.mjs`

### Generalized fix

Each generalization commit records:

- primitive added;
- old site-specific path reduced;
- new safety invariant;
- new fixture/check;
- remaining risk;
- rollback instructions.

### Acceptance check

A check fails if a commit touches policy/runtime/check tooling without updating the generalization changelog or explicitly marking the change as unrelated.

---

## v7 implementation order

Recommended next implementation slice:

```txt
1. P0.52 RuntimeContext
2. P0.53 decision precedence table
3. P0.55 idempotent content-script bootstrap guard
4. P0.58 global API patch registry
5. P0.56 DNR quota broker
6. P0.57 DNR owner ledger and orphan cleanup
7. P0.54 message rate limiting
8. P0.60 storage write coalescing
9. P0.61 style injection ownership
10. P0.65 policy monotonicity tests
```

Reason: these create shared coordination points. They make the existing v6 primitives enforceable across layers instead of leaving each layer to interpret policy independently.

