# uBlock Resurrected Generalization Backlog v17 — Additional non-repeating project-wide generalization points

Updated: 2026-06-28

Reviewed commit: `afd2cbad460fee7a5571740175ef56aaedae7092`

Previous detailed backlog: `ublock_resurrected_generalization_backlog_v5_ca353.md`

Previous project-wide pass: `ublock_resurrected_generalization_backlog_v6_afd2_projectwide.md`

## Scope of this pass

This pass looks at the whole project, not only the latest commit.

The latest commit is small and useful: it deduplicates `installContextMenu()` with a guard flag. The broader lesson is bigger than context menus: the extension needs a generalized startup/lifecycle/idempotency contract so every service-worker capability can be safely installed, reinstalled, disabled, restored, and verified without accumulating duplicate listeners, stale state, missing menus, stale DNR rules, or duplicate runtime layers.

This document does not repeat the full v5 backlog. It adds and refines remaining generalized work after the repo has already added major scaffolding such as page-policy profiles, richer policy resolver fields, degraded allow mode, runtime-layer interfaces, page classifier utilities, observer budgets, capability tokens, auto-recovery helpers, DNR transaction helpers, browser capability profiles, and compatibility debt metadata.

This v17 pass keeps the v16 list and inserts another narrow set of non-overlapping items found by reading the numbered backlog again. The new additions focus on prerender/BFCache/frozen/discarded-page lifecycle, IDNA/public-suffix normalization, unsupported DNR feature downgrade, browser-action/badge visible-state authority, chrome.alarms ownership, adaptive degradation ladders, DOM readiness phases, and targeted regression corpora for those surfaces.

## Current project rating

Current project-generalization rating: **9.52 / 10.00**

Why the score improved:

```txt
- The project now has a central policy resolver that loads profile config.
- Degraded allow mode is present in the active service-worker path.
- Policy now includes deeper network/cosmetic/video/scriptlet/content-script fields.
- The service worker imports the policy resolver and policy-profile loader.
- WebRequest tracking is at least internally gated by logger/popup activity.
- DNR install now does a later full-condition dedupe before actual install.
- The repo has many checks and release gates compared with earlier versions.
- The latest context-menu change shows attention to service-worker idempotency.
```

Why it is not 10.00:

```txt
- Several strong primitives still look like scaffolding rather than mandatory runtime paths.
- Manifest content scripts are still globally injected and narrowed by hostname exceptions.
- Policy profile values are not yet schema-enforced, so booleans/strings can drift.
- Context-menu idempotency is not rollback-safe and can break after disable/re-enable.
- DNR transaction rollback semantics still need to remove current rules before restoring snapshots.
- The first-stage compiler dedupe can still drop domain/initiator-specific distinctions before later install-time dedupe sees them.
- Cross-layer integration checking is advisory and appears to contain a `srcDir` reference bug.
- Compatibility debt entries are expired by absolute date but still present.
- Some checks exist but are not wired into `check:all` or are warning-only.
- Remote filter-list fetching still needs a central asset authority and cache rollback policy.
- Storage keys, timestamps, generated IDs, and URL/match-pattern semantics still need stronger shared ownership.
- Extension-page security, retention TTLs, release-mode pruning, version handshakes, owned schedulers, user-visible explanations, cache namespace authority, authenticated sender envelopes, main-world bridge isolation, permission-change downgrade, incognito/profile behavior, accessibility/localization coverage, optional permissions, static ruleset lifecycle, reset authority, state-surface consistency, rule canonicalization, DOM marker collisions, picker/zapper session isolation, subscription cleanup, archive manifests, multi-browser build parity, dependency provenance, overlay containment, rollback playbooks, restricted schemes, opaque origins, WAR delivery safety, allow/exception expiry, flood control, cloud conflict handling, first-run consent, third-party frame roles, and shipped-resource integrity are now explicit, but request initiator chains, resource-type taxonomy, feature flags/kill switches, redirect/surrogate target integrity, non-window contexts, extension co-residency, user-input preservation, CORS/preflight-safe redirect behavior, policy snapshot diffing, compile-time rule-cost budgets, cold-start hydration barriers, partitioned storage/network contexts, browser file-transfer side effects, offline/captive-portal retry behavior, privacy-budgeted counters, layout-read budgets, and CSS cascade/layer ordering still need first-class enforcement.
```

## Generalized direction after `afd2`

The next phase should treat every install/startup action as a managed capability:

```txt
context menu
webRequest instrumentation
DNR rules
filter-list updates
policy profile loading
runtime layer registration
content-script activation
BroadcastChannel subscriptions
badge updates
privacy settings
stealth/surrogate rules
logger state
popup state
whitelist state
backup/restore state
```

Each capability needs the same contract:

```txt
1. name
2. owner
3. required permissions
4. startup order
5. idempotency key
6. verify function
7. rollback function
8. reset function
9. policy dependency
10. check script
```

The context-menu guard fixed one duplicate-call symptom. The generalized fix is a startup/lifecycle registry that prevents the same class of bug everywhere.

---

# P0 — Small changes with large generalized wins

## P0.1 Replace local context-menu flag with a lifecycle-owned menu registry

### Problem

The latest commit adds:

```js
let contextMenuInstalled = false;

async function installContextMenu() {
    if (contextMenuInstalled) return;
    contextMenuInstalled = true;
    await chrome.contextMenus.removeAll().catch(...);
    chrome.contextMenus.create(...);
}
```

This prevents duplicate installation, but it is not a complete lifecycle contract.

Failure cases:

```txt
- The flag is set before menu creation succeeds.
- If `removeAll()` or `create()` fails, future calls return early and do not retry.
- If the user disables context menus, `removeAll()` runs but the flag remains true.
- Re-enabling context menus can silently no-op because the guard still says installed.
- `removeAll()` removes all extension context menus, not only menu IDs owned by this feature.
```

### Generalized fix

Create a central menu registry:

```txt
platform/chromium/js/context-menu-registry.js
```

Registry entry shape:

```ts
type ContextMenuEntry = {
  id: string;
  title: string;
  contexts: string[];
  documentUrlPatterns?: string[];
  enabledSetting?: string;
  owner: "element-picker" | "logger" | "debug";
};
```

API:

```js
registerContextMenu(entry)
ensureContextMenus({ force = false })
removeContextMenu(id)
removeContextMenusByOwner(owner)
verifyContextMenus()
resetContextMenuRegistry(reason)
```

Rules:

```txt
- Set installed=true only after all required menus are verified.
- Disable removes registered menu IDs and resets install state.
- Re-enable calls ensureContextMenus({ force: true }).
- Do not call removeAll() except during extension upgrade/migration.
- Context menu IDs are declared in one registry, not inline in sw.js.
```

### Acceptance check

Add:

```txt
tools/check-context-menu-lifecycle.mjs
tests/runtime/context-menu-lifecycle.spec.ts
```

The check fails if:

```txt
- `contextMenuInstalled = true` appears before successful creation/verification.
- `contextMenus.removeAll()` is used outside a migration/reset path.
- disabling context menus does not reset the registry state.
- a menu ID exists outside the registry.
```

---

## P0.2 Add a service-worker startup sequencer

### Problem

The active service worker performs many startup-like actions in scattered code paths:

```txt
load policy profiles
clear DNR schema state
restore session state
install context menus
sync stealth/surrogate rules
register webRequest listeners
load whitelist
start badge/icon state
init smart rules
handle runtime messages
```

A single local guard for context menus does not prevent other duplicate or out-of-order startup work.

### Generalized fix

Add:

```txt
platform/chromium/js/startup-sequencer.js
```

Capability shape:

```ts
type StartupCapability = {
  id: string;
  phase: "critical" | "policy" | "network" | "ui" | "diagnostic";
  once: boolean;
  dependsOn?: string[];
  run(): Promise<void>;
  verify?(): Promise<boolean>;
  rollback?(reason: string): Promise<void>;
};
```

Startup phases:

```txt
critical: schema migration, storage schema validation
policy: page-policy.json + browser-capabilities.json
network: DNR restore/sync, whitelist/trusted state, stealth rules
ui: context menus, badge state, commands
instrumentation: logger/webRequest/popup tracking
```

### Acceptance check

Add:

```txt
tools/check-startup-sequencer.mjs
tests/runtime/startup-sequencer.spec.ts
```

The check fails if:

```txt
- startup capability is called directly from multiple locations without a registry entry.
- a capability has no verify function when it mutates browser state.
- a capability has no rollback or degraded-mode plan when it changes DNR/session rules.
- service-worker message handling can run before critical + policy phases complete.
```

---

## P0.3 Gate all message handling behind policy/profile readiness

### Problem

The service worker imports `loadPolicyProfiles()` and `resolvePagePolicy()`, and policy profiles are loaded from `config/page-policy.json`. If a message arrives before policy profiles and browser capabilities are loaded, the resolver uses an inline fallback profile.

Fallback is safe, but it can create inconsistent behavior:

```txt
- popup says one thing, content script receives another.
- content parameters are calculated before profile config exists.
- runtime layer state can be initialized under fallback and not upgraded.
- tests can pass because fallback is safe, while real policy config is never exercised.
```

### Generalized fix

Create one boot promise:

```js
const bootReady = initializeServiceWorkerRuntime();
```

Before handling any mutation-capable message:

```js
await bootReady;
```

Read-only messages can return:

```txt
{ ok: false, error: "runtime-not-ready", retryable: true }
```

Policy boot state:

```ts
type PolicyBootState = {
  profilesLoaded: boolean;
  browserCapabilitiesLoaded: boolean;
  policyRevision: number;
  fallbackUsed: boolean;
  lastLoadError?: string;
};
```

### Acceptance check

Add:

```txt
tools/check-policy-readiness-gate.mjs
tests/runtime/policy-readiness.spec.ts
```

The check fails if:

```txt
- dispatchMessage can process mutation commands before policy boot.
- content params can return fallback policy without `fallbackUsed=true` diagnostic.
- profile loading failure is silent.
```

---

## P0.4 Add a strict schema for `config/page-policy.json`

### Problem

`config/page-policy.json` is now important enough to be treated as code.

Current risk examples:

```txt
- Some fields use strings: "trusted-specific-only", "off", "full".
- Some equivalent fields can drift into booleans, for example `mainWorldHooks`.
- Top-level flat fields and nested fields can disagree.
- A profile can enable a nested capability while the flat field says disabled.
- No schema currently proves every profile has the same required fields.
```

### Generalized fix

Add:

```txt
config/page-policy.schema.json
src/js/policy/page-policy-normalizer.ts
tools/check-page-policy-schema.mjs
```

Canonicalize every profile into a single normalized shape:

```ts
type NormalizedPagePolicy = {
  id: string;
  network: NetworkPolicy;
  cosmetic: CosmeticPolicy;
  video: VideoPolicy;
  scriptlets: ScriptletPolicy;
  contentScript: ContentScriptPolicy;
  instrumentation: InstrumentationPolicy;
  budgets: RuntimeBudgets;
};
```

Rules:

```txt
- No mixed boolean/string enums.
- No duplicate flat+nested authority unless generated from the same normalized object.
- `default-web` cannot enable generic video full mode unless evidence policy says it is safe.
- `auth-sensitive` and `payment-sensitive` cannot enable network/cosmetic/scriptlet mutation beyond specific cosmetic observation.
```

### Acceptance check

`npm run check:page-policy-schema` fails if:

```txt
- any profile is missing required keys.
- any enum value is outside the allowed set.
- flat and nested policies disagree.
- a high-risk layer is enabled without an explicit evidence field.
```

---

## P0.5 Rename `full-block` trusted profile to avoid semantic inversion

### Problem

Trusted/whitelisted pages are mapped to profile ID `full-block`, but that profile actually means filtering off.

This is risky naming:

```txt
full-block sounds like maximum blocking.
Trusted pages should mean extension-disabled or trusted-off behavior.
A future maintainer could misread the profile and enable the wrong branch.
```

### Generalized fix

Rename:

```txt
full-block -> trusted-off
```

or:

```txt
full-block -> extension-disabled
```

Then define a profile alias migration:

```js
const PROFILE_ALIASES = {
  "full-block": "trusted-off"
};
```

### Acceptance check

Add:

```txt
tools/check-profile-naming.mjs
```

The check fails if:

```txt
- a profile name implies the opposite of its behavior.
- trusted/whitelist handling maps to a profile with network/cosmetic/video mutation enabled.
- old profile names appear outside alias migration code.
```

---

## P0.6 Fix the first-stage compiler dedupe, not only install-stage dedupe

### Problem

The active sync path now performs a later full-condition dedupe before installing DNR rules. However, `compileFilterTextToDNR()` still deduplicates earlier using only:

```txt
urlFilter | resourceTypes | action
```

That can drop differences before the later safer dedupe ever sees them:

```txt
initiatorDomains
excludedInitiatorDomains
requestDomains
excludedRequestDomains
domainType
priority
source list
exception/allow semantics
```

### Generalized fix

Create one shared DNR key helper:

```txt
src/dnr/dnr-rule-key.ts
platform/chromium/js/dnr-rule-key.js
```

Canonical key:

```js
stableJson({
  action,
  condition: {
    urlFilter,
    regexFilter,
    resourceTypes,
    excludedResourceTypes,
    initiatorDomains,
    excludedInitiatorDomains,
    requestDomains,
    excludedRequestDomains,
    domainType,
  },
  priorityBand,
  sourceTrustTier,
})
```

Use it in:

```txt
compileFilterTextToDNR()
syncFilterListDnrRules()
static ruleset validation
user-rule validation
simulator snapshots
```

### Acceptance check

Add fixtures:

```txt
same-url-different-initiator.txt
same-url-excluded-initiator.txt
same-url-first-party-third-party.txt
same-url-allow-vs-block.txt
```

The check fails if rule count collapses incorrectly.

---

## P0.7 Wire `dnr-transaction.js` into the active rule sync path and fix rollback semantics

### Problem

The project has a DNR transaction helper, but the active service-worker sync path still calls rule update helpers directly.

The transaction helper also restores snapshots with:

```js
removeRuleIds: []
addRules: snapshot.dynamicRules
```

That is not a safe rollback. If the failed update partially installed new rules, restoring without removing current rules can leave duplicates, conflicts, or mixed state.

### Generalized fix

Transaction algorithm:

```txt
1. snapshot current dynamic + session rules
2. validate next rules with risk classifier and quota manager
3. remove all current target-scope rules
4. install next rules
5. read back installed rules
6. verify exact normalized equality
7. on any failure, remove all current target-scope rules
8. add snapshot rules
9. verify snapshot equality
10. if rollback fails, enter degraded allow mode
```

Target-scope is important: do not remove unrelated extension-managed rules unless they are in the same registered ID band.

### Acceptance check

Add:

```txt
tests/dnr/dnr-transaction-rollback.spec.ts
tools/check-dnr-transaction-wiring.mjs
```

The check fails if:

```txt
- active sw.js installs dynamic/session rules without transaction wrapper.
- rollback uses `removeRuleIds: []` before adding snapshot.
- transaction code declares unused remove variables.
- installed rules are not read back and verified.
```

---

## P0.8 Make compatibility debt dates real and synchronize with manifest exceptions

### Problem

`config/compatibility-sites.json` has temporary entries with absolute expiration dates. These entries are now expired but still present.

Also, manifest `exclude_matches` and compatibility debt entries can drift:

```txt
- manifest excludes ChatGPT in main content script.
- manifest excludes Suno/VK/Yandex/YouTube/ChatGPT in generic video script.
- compatibility debt includes some but not necessarily all manifest exceptions.
```

### Generalized fix

Treat compatibility debt as the source of truth for temporary hostname exceptions.

Add generated manifest exception blocks:

```txt
config/compatibility-sites.json -> manifest exclude_matches
```

Entry shape:

```ts
type CompatibilityDebtEntry = {
  site: string;
  status: "temporary" | "fixture-only" | "removed";
  layers: RuntimeLayerId[];
  replacementItem: string;
  owner: string;
  createdAt: string;
  expiresAt: string;
  manifestException: boolean;
  fixturePath: string;
  removalPR?: string;
};
```

### Acceptance check

Add:

```txt
tools/check-manifest-compatibility-sync.mjs
```

The check fails if:

```txt
- a manifest hostname exception is not in compatibility-sites.json.
- a compatibility exception is expired and still active.
- a debt entry lacks a fixture path.
- a removed exception still appears in manifest.
```

---

## P0.9 Make `check-cross-layer-integration` fail-closed

### Problem

The current cross-layer integration check is warning-only and appears to reference `srcDir`, which is not defined in the file.

This means the check is not yet a reliable CI gate.

### Generalized fix

Replace warnings with failures for mandatory invariants:

```txt
- all known layers exist
- all known layers are registered
- all manifest content-script JS files map to a layer or bootstrap entry
- all mutation layers require capability tokens
- all layers implement start/stop/canStart
- service worker imports the activation protocol or documented replacement
- all check scripts are included in check:all or explicitly marked advisory
```

### Acceptance check

The check itself must fail if:

```txt
- it references undefined variables.
- it only warns for missing mandatory layer modules.
- `failed` is never set when required dependencies are absent.
```

---

## P0.10 Centralize external filter-list fetching under asset authority

### Problem

The filter-list loader can fetch CDN URLs from asset metadata. That is normal for an ad blocker, but it needs a central authority model.

Current risks:

```txt
- external URLs are trusted if listed in asset metadata.
- failed bundled fetch falls through to CDN without a policy decision record.
- no uniform trust tier controls CDN vs bundled vs user-imported lists.
- no required hash/signature/cache rollback path.
```

### Generalized fix

Add:

```txt
platform/chromium/js/asset-authority.js
src/assets/asset-authority.ts
```

Decision shape:

```ts
type AssetFetchDecision = {
  allowed: boolean;
  reason: string;
  listKey: string;
  url: string;
  trustTier: "bundled" | "official-cdn" | "user-imported";
  requiresHash: boolean;
  mayUseCacheFallback: boolean;
};
```

Rules:

```txt
- bundled assets first.
- official CDN allowed only for known asset IDs.
- user-imported lists require explicit user setting and diagnostics.
- failed update keeps last known good compiled rules.
- no CDN response can replace a bundled list without provenance record.
```

### Acceptance check

Add:

```txt
tools/check-asset-fetch-authority.mjs
tests/assets/asset-authority.spec.ts
```

The check fails if:

```txt
- `fetchWithTimeout(url)` is reachable from filter-list loading without `mayFetchAsset()`.
- URL errors include full query strings or tokens.
- failed fetch wipes last known good rules.
```

---

## P0.11 Add a command/message contract registry for service-worker dispatch

### Problem

The service worker contains many `msg.what` switch branches for dashboard, popup, content scripts, smart rules, cloud, backup/restore, whitelist, user filters, and runtime state.

This is flexible but not generalized enough:

```txt
- payload schemas are not centralized.
- sender permissions are not declared per command.
- mutation commands and read-only commands are not separated.
- policy readiness is not required per command.
- content scripts can accidentally reach dashboard-only commands if not gated.
```

### Generalized fix

Add:

```txt
platform/chromium/js/message-contracts.js
src/shared/message-contracts.ts
```

Contract shape:

```ts
type MessageContract = {
  what: string;
  channel?: string;
  allowedSenders: ("content" | "popup" | "dashboard" | "logger" | "extension-page")[];
  mutation: boolean;
  requiresPolicyReady: boolean;
  requiresTab: boolean;
  schema: unknown;
};
```

### Acceptance check

Add:

```txt
tools/check-message-contracts.mjs
```

The check fails if:

```txt
- a `case "..."` message branch has no contract.
- a mutation command does not require policy readiness.
- content-script sender can call backup/restore/cloud/filter-list mutation commands.
```

---

## P0.12 Make WebRequest registration lazy or capability-owned

### Problem

The webRequest listeners are registered broadly for `<all_urls>`, although tracking is internally gated by logger/popup state.

Internal gating is an improvement, but the generalized lifecycle should still represent this as an instrumentation capability.

### Generalized fix

Add instrumentation lifecycle:

```txt
registerInstrumentationCapability("webRequestTracking")
startInstrumentation(reason)
stopInstrumentation(reason)
verifyInstrumentationListeners()
```

Options:

```txt
Option A: register listeners once, but prove callbacks are no-op unless capability active.
Option B: add/remove listeners when logger/popup starts/stops.
```

Option A is simpler and acceptable if documented and checked.

### Acceptance check

Add:

```txt
tools/check-webrequest-instrumentation-gate.mjs
```

The check fails if:

```txt
- webRequest callback writes logs/stats while instrumentation inactive.
- instrumentation active state is not policy-readable.
- no verifier proves callbacks are gated before mutation/logging.
```

---

## P0.13 Make profile classification structural, not `hasKnownFilterSupport`-driven

### Problem

The repo has page signal and classifier utilities, but active policy resolution still appears primarily driven by:

```txt
trusted
hasKnownFilterSupport
fallback/default profile
```

The stronger generalized model is:

```txt
page signals -> profile -> policy -> activation
```

not:

```txt
hostname/list support -> profile
```

### Generalized fix

Wire structural signals into active content-param and runtime activation paths:

```txt
collectPageSignals(document)
classifyPageProfile(signals)
send profile proposal to SW
SW resolves final policy using trusted state + switches + profile proposal
SW returns signed policy snapshot
content runtime activates only from snapshot
```

### Acceptance check

Add fixtures:

```txt
app-shell-with-contenteditable.html -> app-shell
auth-form.html -> auth-sensitive
checkout-form.html -> payment-sensitive
plain-news-page.html -> default-web
known-video-player.html -> video-site
```

The check fails if hostname alone determines one of these profiles.

---

## P0.14 Add policy revision to every runtime activation decision

### Problem

Policy can change when the user toggles whitelist, cosmetic filtering, scripting, filter lists, logger, or imported lists. Runtime layers need to know whether their current activation is stale.

### Generalized fix

Add:

```ts
type PolicySnapshot = {
  revision: number;
  tabId: number;
  frameId: number;
  documentId?: string;
  url: string;
  profileId: string;
  policy: NormalizedPagePolicy;
  issuedAt: number;
};
```

Every capability token includes:

```txt
policyRevision
documentId/frameId
tabId
layer
expiry
```

Runtime layers must stop or downgrade to observe-only when revision changes.

### Acceptance check

Add:

```txt
tests/runtime/policy-revision-invalidation.spec.ts
```

The test toggles whitelist/cosmetic/scripting and expects active layers to stop or re-request policy.

---

## P0.15 Add CI check for advisory-only scripts

### Problem

The repo has many check scripts, but a check script can be weak if it only warns, is not included in `check:all`, or never sets failure state.

### Generalized fix

Add:

```txt
tools/check-check-scripts-are-gates.mjs
config/check-script-policy.json
```

Each check is classified:

```txt
required-gate
advisory-report
release-only
dev-only
```

Rules:

```txt
- required-gate must be included in check:all or release:full.
- required-gate must call process.exit(1) or throw on failure.
- advisory-report cannot be named `check:*` unless clearly marked advisory in registry.
```

### Acceptance check

The check fails for scripts that:

```txt
- define `let failed = false` but never set it.
- only print warnings for mandatory invariants.
- are not reachable from any aggregate script.
```

---


## P0.16 Replace ad-hoc async booleans with a shared task lock and retry primitive

### Problem

The project now has several local guard flags and async state booleans:

```txt
contextMenuInstalled
syncInProgress
filterListsUpdating
loggerActive
popupNeedsTracking
dnrSyncCompleted
```

Local booleans are useful for a single function, but they do not generalize failure behavior.

Failure cases:

```txt
- flag is set before the operation fully succeeds.
- operation fails and future calls return early forever.
- concurrent callers race and both mutate browser state.
- one capability has retry/backoff while another silently gives up.
- tests prove one guard but not the class of duplicate-startup bugs.
```

### Generalized fix

Add:

```txt
platform/chromium/js/task-lock-registry.js
src/runtime/task-lock-registry.ts
```

API:

```ts
type TaskLock = {
  id: string;
  owner: string;
  state: "idle" | "running" | "succeeded" | "failed";
  startedAt?: number;
  completedAt?: number;
  lastError?: string;
  retryAfterMs?: number;
};
```

Functions:

```txt
runOnce(taskId, fn, options)
runExclusive(taskId, fn, options)
resetTask(taskId, reason)
getTaskState(taskId)
```

Use it for:

```txt
context menu installation
filter list sync
DNR rule installation
policy profile loading
browser capability loading
stealth/surrogate sync
badge refresh sweeps
cache purge/rebuild
```

### Acceptance check

Add:

```txt
tools/check-task-lock-usage.mjs
tests/runtime/task-lock-registry.spec.ts
```

The check fails if:

```txt
- new service-worker startup guards use plain booleans instead of the registry.
- a task can be marked successful before its verify step passes.
- a failed one-time task cannot be retried or reset.
- two concurrent calls can install the same browser-state capability twice.
```

---

## P0.17 Add a settings-effect registry for all user setting changes

### Problem

User setting changes currently trigger side effects through inline conditional branches.

Examples of setting effects:

```txt
contextMenuEnabled -> install/remove context menus
showCustomNewTab -> update navigation behavior
showIconBadge -> clear or refresh badges
prefetchingDisabled -> chrome.privacy.network
hyperlinkAuditingDisabled -> chrome.privacy.websites
webrtcIPAddressHidden -> chrome.privacy.services
stealth mode -> sync surrogate rules
advancedUserEnabled -> reveal panel sections
```

This is hard to generalize because each setting carries its own hidden lifecycle contract.

### Generalized fix

Add:

```txt
config/settings-effects.json
platform/chromium/js/settings-effect-registry.js
src/settings/settings-effect-registry.ts
```

Entry shape:

```ts
type SettingEffect = {
  setting: string;
  owner: string;
  capability?: string;
  permission?: string;
  apply(value, oldValue, context): Promise<void>;
  rollback?(oldValue, reason): Promise<void>;
  verify?(value): Promise<boolean>;
  policyRevisionBump: boolean;
};
```

Rules:

```txt
- setting mutation validates the setting name and value before writing storage.
- side effect runs through the startup/capability registry.
- failed side effect rolls back the setting or returns a typed partial-failure result.
- settings that affect runtime layers bump policy revision.
```

### Acceptance check

Add:

```txt
tools/check-settings-effect-registry.mjs
tests/runtime/settings-effects.spec.ts
```

The check fails if:

```txt
- `changeUserSetting()` contains direct one-off browser API calls.
- a setting changes browser state without verify/rollback.
- a setting that changes policy does not bump policy revision.
- a setting can be written without schema validation.
```

---

## P0.18 Add a listener registry for browser and extension events

### Problem

The context-menu duplication fix handles one install function, but similar duplication risks exist for event listeners.

Event surfaces include:

```txt
chrome.contextMenus.onClicked
chrome.webRequest.*
chrome.runtime.onMessage
chrome.commands.onCommand
chrome.tabs.*
chrome.webNavigation.*
BroadcastChannel listeners
```

A listener can be accidentally registered twice when code is moved into modules, when startup is retried, or when generated/runtime paths drift.

### Generalized fix

Add:

```txt
platform/chromium/js/listener-registry.js
src/runtime/listener-registry.ts
```

Registry entry:

```ts
type ListenerRegistration = {
  id: string;
  owner: string;
  eventName: string;
  phase: "startup" | "policy-ready" | "logger-active" | "tab-active";
  add(): void;
  remove?(): void;
  isRegistered?(): boolean;
};
```

Rules:

```txt
- every top-level `addListener` call must be declared in one registry.
- listeners that write logs/stats require active instrumentation capability.
- listeners that mutate tabs/storage/DNR require policy readiness.
- every removable listener must have a teardown path.
```

### Acceptance check

Add:

```txt
tools/check-listener-registry.mjs
tests/runtime/listener-registry.spec.ts
```

The check fails if:

```txt
- raw `addListener` appears outside the registry or an approved bootstrap file.
- the same event/handler id can be registered twice.
- no teardown exists for logger/popup-scoped listeners.
```

---

## P0.19 Gate backup, restore, and cloud paths through storage schema validation

### Problem

Backup/restore and cloud-like paths can write or return broad storage payloads.

General risks:

```txt
- restore writes keys before schema migration/validation.
- unknown keys can enter storage and affect future runtime paths.
- backup includes keys by a manual list that can drift from actual schema.
- cloud-like datakeys can become arbitrary storage slots.
- restoring old data can bypass current user-rule/filter-list validation.
```

### Generalized fix

Treat backup/restore/cloud as high-risk storage mutations.

Add:

```txt
src/storage/backup-restore-policy.ts
platform/chromium/js/backup-restore-policy.js
tools/check-backup-restore-schema.mjs
```

Rules:

```txt
- restore payload is parsed into a schema version before writing storage.
- unknown keys are rejected or quarantined.
- every restored key goes through migration and validation.
- user filters, whitelist, imported lists, switches, and dynamic rules re-run validators.
- cloud datakeys are allowlisted by registry, not caller-supplied strings.
- backup uses storage-schema registry, not a separate manual list.
```

### Acceptance check

Add fixtures:

```txt
restore-unknown-key.json
restore-old-user-rules.json
restore-invalid-filter-list.json
restore-cloud-datakey-injection.json
```

The check fails if restore can write unknown keys or bypass validators.

---

## P0.20 Define a runtime-health schema and transition contract

### Problem

`runtimeHealth` is useful, but health flags need the same rigor as policy state.

Examples of health concepts:

```txt
dnrStaticRulesReady
filterListsReady
degradedMode
adaptiveMode
lastError
filterListsOutdated
```

Without a schema and transition contract, health can become a loose diagnostic dump.

### Generalized fix

Add:

```txt
config/runtime-health.schema.json
platform/chromium/js/runtime-health.js
src/runtime/runtime-health.ts
```

State model:

```ts
type RuntimeHealth = {
  phase: "booting" | "ready" | "degraded" | "recovering" | "error";
  policyReady: boolean;
  dnrReady: boolean;
  filterListsReady: boolean;
  instrumentationActive: boolean;
  activeTasks: string[];
  lastErrors: RuntimeError[];
  revision: number;
};
```

Rules:

```txt
- all health writes go through `setRuntimeHealth()`.
- illegal transitions are rejected or logged as errors.
- popup/logger read the same normalized health object.
- degraded mode includes a reason and recovery path.
```

### Acceptance check

Add:

```txt
tools/check-runtime-health-contract.mjs
tests/runtime/runtime-health-transitions.spec.ts
```

The check fails if raw `runtimeHealth.foo = ...` assignments appear outside the health module.

---

## P0.21 Add a policy/config invalidation bus

### Problem

Policy can change from several directions:

```txt
page-policy config reload
browser-capability config change
whitelist update
user setting toggle
filter-list selection change
user rule update
compatibility debt removal
safe mode entered/exited
```

Runtime layers, caches, badges, popup state, logger state, and content scripts need one invalidation story.

### Generalized fix

Add:

```txt
src/runtime/policy-invalidation.ts
platform/chromium/js/policy-invalidation.js
```

Event shape:

```ts
type PolicyInvalidationEvent = {
  reason: string;
  oldRevision: number;
  newRevision: number;
  affectedTabs?: number[];
  affectedProfiles?: string[];
  requiredActions: ("stop-layers" | "reload-policy" | "clear-css" | "resimulate" | "refresh-popup")[];
};
```

Rules:

```txt
- every policy-affecting mutation emits one invalidation event.
- content scripts stop or re-request policy when their revision is stale.
- popup/logger display the latest policy revision.
- simulator snapshots include the revision that produced them.
```

### Acceptance check

Add:

```txt
tests/runtime/policy-invalidation-bus.spec.ts
tools/check-policy-invalidation-wiring.mjs
```

The check fails if whitelist/settings/filter-list/user-rule changes do not emit invalidation events.

---


## P0.22 Add an effective-site and origin-authority resolver

### Problem

Some current helpers normalize a hostname by taking the last two labels. That is useful as a rough fallback, but it is not a safe general identity model for extension policy.

Examples that need a stronger model:

```txt
example.co.uk
foo.github.io
project.pages.dev
localhost
127.0.0.1
about:blank
srcdoc frames
chrome-extension:// pages
youtube-nocookie.com embeds
private-network hosts
```

A wrong site key can cause policy cache collisions, whitelist mistakes, compatibility-debt mismatch, logger grouping errors, or DNR rule decisions being attributed to the wrong effective site.

### Generalized fix

Add one authority module:

```txt
src/shared/effective-site.ts
platform/chromium/js/effective-site.js
config/public-suffix-lite.json
```

Return a normalized identity object:

```ts
type EffectiveSiteIdentity = {
  rawUrl: string;
  normalizedUrl?: string;
  scheme: "http" | "https" | "extension" | "about" | "data" | "blob" | "file" | "other";
  hostname: string;
  registrableDomain: string | null;
  effectiveSite: string | null;
  topLevelSite?: string | null;
  origin: string | null;
  isOpaqueOrigin: boolean;
  isExtensionPage: boolean;
  isLocalhost: boolean;
  isPrivateNetwork: boolean;
};
```

Rules:

```txt
- all policy caches use EffectiveSiteIdentity, not ad-hoc hostname slicing.
- compatibility debt entries are matched against effective sites and explicit origins.
- DNR attribution uses normalized initiator/effective site.
- about:blank and srcdoc frames inherit the nearest non-opaque parent identity.
- private/local/extension pages default to safest policy unless explicitly allowed.
```

### Acceptance check

Add:

```txt
tests/shared/effective-site.spec.ts
tools/check-effective-site-usage.mjs
```

The check fails if new policy, compatibility, DNR attribution, or logger grouping code calls a local `split(".").slice(-2)` helper instead of the shared resolver.

---

## P0.23 Add target authority for tab/document/frame mutation requests

### Problem

Several mutating actions are routed by values like `msg.tabId`, `msg.docURL`, active tabs, or hostname matches. This is fragile on multi-tab, same-host, iframe-heavy, or SPA pages.

The problem is not only security. It also causes incorrect behavior: a cosmetic rule, picker command, logger action, safe-mode toggle, or user-filter save can apply to the wrong tab or stale document.

### Generalized fix

Add:

```txt
src/runtime/target-authority.ts
platform/chromium/js/target-authority.js
tools/check-target-authority.mjs
```

Target authority verifies:

```ts
type TargetAuthorityRequest = {
  action: string;
  requestedTabId?: number;
  requestedFrameId?: number;
  requestedDocumentId?: string;
  requestedUrl?: string;
  senderTabId?: number;
  senderFrameId?: number;
  senderDocumentId?: string;
  senderOrigin?: string;
  source: "content-script" | "popup" | "dashboard" | "logger" | "context-menu" | "command";
};
```

Rules:

```txt
- content-script requests can only mutate their own tab/frame/document unless a contract explicitly allows escalation.
- popup/dashboard/logger requests need activeTab, explicit user gesture, or a selected tab from trusted extension UI.
- docURL is evidence, not authority.
- hostname match is never enough to choose a target tab.
- stale documentId/frameId downgrades to observe-only or requires re-handshake.
```

### Acceptance check

Add fixtures:

```txt
two-tabs-same-host-one-active.html
same-host-popup-and-background-tab.html
app-with-cross-origin-player-iframe.html
stale-spa-document-id.html
```

The check fails if mutation-capable service-worker branches read `msg.tabId`, `msg.docURL`, or `tab.url` directly without calling the target-authority module.

---

## P0.24 Replace global unhandled-rejection suppression with structured error policy

### Problem

The service worker currently suppresses a known benign race (`No tab with id`) through a global unhandled-rejection handler.

That pattern is dangerous as the project grows because unrelated async failures can be hidden behind broad suppression logic.

### Generalized fix

Add:

```txt
src/runtime/error-policy.ts
platform/chromium/js/error-policy.js
tools/check-error-policy.mjs
```

Classify errors before suppressing or reporting them:

```ts
type RuntimeErrorClass =
  | "benign-tab-lifecycle-race"
  | "stale-document"
  | "policy-not-ready"
  | "dnr-update-failed"
  | "external-asset-fetch-failed"
  | "storage-schema-violation"
  | "unsafe-mutation-rejected"
  | "unexpected";
```

Rules:

```txt
- benign lifecycle races may be suppressed only at the call site or through `classifyRuntimeError()`.
- policy, DNR, storage, and mutation failures must update runtime health.
- unexpected unhandled errors must remain visible in dev builds.
- release builds may redact sensitive URLs but must not swallow unknown errors.
```

### Acceptance check

Add:

```txt
tests/runtime/error-policy.spec.ts
tools/check-unhandled-error-policy.mjs
```

The check fails on direct global `event.preventDefault()` suppression outside the error-policy module.

---

## P0.25 Add a user-visible partial-startup repair workflow

### Problem

The extension can now enter several partial states:

```txt
policy profiles failed to load
browser capabilities failed to load
DNR sync entered degraded mode
context-menu flag says installed but browser menus are missing
listener registration partly failed
filter-list sync lock stayed stuck after service-worker suspend
compatibility metadata is expired but still reflected in manifest exceptions
```

A developer can inspect logs, but a user or tester needs one visible recovery path.

### Generalized fix

Add:

```txt
src/runtime/repair-plan.ts
platform/chromium/js/repair-plan.js
src/js/popup-runtime-repair.ts
tools/check-repair-plan.mjs
```

Repair plan shape:

```ts
type ExtensionRepairPlan = {
  detectedProblems: string[];
  safeActions: (
    | "reload-policy-config"
    | "reload-browser-capabilities"
    | "verify-context-menus"
    | "reset-stale-locks"
    | "reconcile-listeners"
    | "verify-dnr-rules"
    | "rerun-filter-sync"
    | "clear-stale-layer-state"
    | "refresh-popup-state"
  )[];
  requiresUserConfirmation: boolean;
};
```

Rules:

```txt
- popup/logger can display degraded or partial-startup state.
- repair actions are idempotent and use the same lifecycle registries as startup.
- repair never installs broad fallback block rules.
- if repair fails, degraded allow mode remains the safe state.
```

### Acceptance check

Add fixtures/tests for:

```txt
missing context menu after flag true
policy config 404
DNR install failure
stale sync lock
expired compatibility exception
```

---

## P0.26 Add a web-accessible-resource ownership registry

### Problem

The manifest exposes several extension resources to `<all_urls>`. Some are necessary for element picker/zapper and assets, but exposure should be intentional, owned, and checked.

Without a registry, new files can become web-accessible because they are useful during development, then remain exposed in release builds.

### Generalized fix

Add:

```txt
config/web-accessible-resources.json
tools/check-web-accessible-resources-registry.mjs
tools/generate-web-accessible-resources.mjs
```

Registry entry:

```ts
type WebAccessibleResourceEntry = {
  resource: string;
  owner: string;
  purpose: "element-picker" | "zapper" | "cosmetic-ui" | "asset-catalog" | "test-only";
  matches: string[];
  releaseAllowed: boolean;
  requiresUserGesture?: boolean;
  policyGate?: string;
  notes?: string;
};
```

Rules:

```txt
- manifest web_accessible_resources are generated from the registry.
- `<all_urls>` exposure requires an explicit reason.
- test-only resources are stripped from release manifest.
- asset catalogs exposed to web pages must contain only public metadata.
```

### Acceptance check

The check fails if `manifest.json` exposes a resource not listed in the registry or if a release manifest exposes a test-only resource.

---

## P0.27 Add a generated-manifest surface model

### Problem

Permissions, commands, content scripts, web-accessible resources, DNR rulesets, compatibility exceptions, and release/dev differences are still spread across manifest JSON, generators, config files, and checks.

Checks are useful, but the stronger generalization is to make the manifest a generated result of capability registries.

### Generalized fix

Add:

```txt
config/manifest-surface.json
tools/generate-manifest-surface.mjs
tools/check-manifest-surface-generated.mjs
```

Surface model includes:

```txt
permissions
host permissions
content-script bundles
content-script worlds
all_frames/match_about_blank usage
commands
web-accessible resources
DNR rulesets
release/dev stripping rules
compatibility-generated exclusions
```

Rules:

```txt
- direct manual edits to high-risk manifest sections fail CI unless the source model changed.
- dev and release manifests are generated from the same source model.
- every manifest capability links to a policy field, owner, test, and release justification.
```

### Acceptance check

The check fails if manifest high-risk sections differ from generated output.

---


## P0.28 Add a per-document runtime injection sentinel

### Problem

The manifest still injects broad content-script payloads at `document_start`, across all frames, with `match_about_blank`. Even when policy later disables heavy layers, the page can still receive the same bootstrap/runtime path multiple times across SPA navigation, BFCache restore, iframe replacement, extension reload, or manual reinjection.

The lifecycle registry controls service-worker capabilities, but the page side also needs a document-level idempotency boundary.

### Generalized fix

Add:

```txt
src/js/runtime/document-runtime-sentinel.ts
platform/chromium/js/document-runtime-sentinel.js
tools/check-document-runtime-sentinel.mjs
```

Sentinel key:

```ts
type DocumentRuntimeKey = {
  tabId: number;
  frameId: number;
  documentId?: string;
  effectiveUrl: string;
  policyRevision: number;
  bundleId: string;
  layerId: string;
};
```

Rules:

```txt
- every content/runtime layer must acquire a document runtime slot before starting.
- duplicate acquire with same key returns already-active, not start-again.
- policy revision change invalidates mutation layers but may keep passive bootstrap.
- BFCache restore revalidates slot state before reusing observers/styles/listeners.
- about:blank/srcdoc frames use inherited effective URL in the key.
```

### Acceptance check

The check fails if:

```txt
- smart-content, contentscript, video runtime, scriptlets, or cosmetic runtime self-start without acquiring a sentinel slot.
- a layer can create a second observer/style/listener for the same document and policy revision.
- documentId/frameId/effectiveUrl are not part of the runtime identity.
```

---

## P0.29 Add stale-operation cancellation tokens for async commits

### Problem

Long async operations can outlive the state they were started under:

```txt
filter-list fetch
filter-list compile
DNR install
backup/restore
cloud push/pull
policy profile loading
content-script injection
tab message delivery
privacy-setting mutation
badge updates
```

A user may change settings, whitelist a site, close a tab, navigate, or trigger another sync while the old operation is still running. Without an operation token, stale async work can commit after the newer state wins.

### Generalized fix

Add:

```txt
platform/chromium/js/operation-token.js
src/runtime/operation-token.ts
tools/check-operation-token-usage.mjs
```

Token shape:

```ts
type OperationToken = {
  id: string;
  capability: string;
  policyRevision?: number;
  settingsRevision?: number;
  documentRevision?: number;
  startedAt: number;
  abortSignal: AbortSignal;
};
```

Rules:

```txt
- long-running operations must create an OperationToken before side effects.
- before committing storage/DNR/CSS/runtime changes, check token is still current.
- new operation for the same capability cancels or supersedes the previous token.
- navigation/document replacement cancels tab/document-scoped tokens.
- settings/filter-list/whitelist changes cancel stale policy-dependent tokens.
```

### Acceptance check

Add race tests:

```txt
sync list A starts -> user changes selected lists -> list A finishes late -> must not overwrite list B
content injection starts -> tab navigates -> old injection result cannot mutate new document
backup restore starts -> schema migration changes -> stale restore cannot commit unknown keys
```

---

## P0.30 Add filter-list trust tiers and capability caps

### Problem

The project now has asset-authority and filter-list loading work, but generalized safety also needs to know what each list is allowed to do after it is fetched and parsed.

Different sources should not have the same power:

```txt
built-in curated lists
bundled static lists
remote stock lists
user-imported external lists
manual user filters
trusted user filters
experimental/dev lists
```

Imported lists should not silently gain access to high-risk transforms such as redirects, header mutation, CSP mutation, scriptlet injection, broad first-party XHR blocking, or surrogate resources.

### Generalized fix

Add:

```txt
config/filter-list-trust.json
src/compiler/filter-list-capabilities.ts
platform/chromium/js/filter-list-capabilities.js
tools/check-filter-list-trust-tiers.mjs
```

Trust-tier fields:

```ts
type FilterListTrustTier = {
  id: string;
  allowedActions: string[];
  allowedResourceTypes: string[];
  allowRedirect: boolean;
  allowHeaderMutation: boolean;
  allowScriptlets: boolean;
  allowCspMutation: boolean;
  allowRemoveParam: boolean;
  maxRuleRisk: "low" | "medium" | "high";
};
```

Rules:

```txt
- imported external lists default to conservative network block-only capability.
- trusted user filters can opt into advanced actions only when advanced mode and explicit trust are enabled.
- built-in lists declare capability metadata and are checked at build time.
- unsupported/downgraded actions produce diagnostics, not silent widening.
```

### Acceptance check

The check fails if an imported or untrusted list can install:

```txt
redirect rules
modifyHeaders rules
main_frame/script/xhr/websocket broad blocks
scriptlets
CSP mutation
surrogate responses
```

---

## P0.31 Add a managed/default/user setting precedence resolver

### Problem

Settings currently appear in several forms:

```txt
userSettings
hiddenSettings
popupPanelSections
hostname switches
URL filtering rules
managed policy evidence
privacy settings
custom new tab setting
contextMenuEnabled
```

Generalized behavior needs one resolver that answers: what is the effective value, who set it, can the user override it, and what side effects must run?

### Generalized fix

Add:

```txt
src/settings/effective-settings.ts
platform/chromium/js/effective-settings.js
config/settings-precedence.json
tools/check-settings-precedence.mjs
```

Precedence model:

```txt
managed policy > enterprise/default lock > user setting > extension default > fallback safe default
```

Resolver output:

```ts
type EffectiveSetting<T> = {
  name: string;
  value: T;
  source: "managed" | "user" | "default" | "fallback";
  userEditable: boolean;
  sideEffectId?: string;
  policyRevisionBump: boolean;
};
```

### Acceptance check

The check fails if:

```txt
- direct reads of userSettings determine high-risk behavior without going through effective-settings.
- a managed setting can be overwritten by backup/restore/cloud sync.
- changing a setting with side effects bypasses the settings-effect registry.
```


---

## P0.32 Add a storage-key ownership and write-authority registry

### Problem

The backlog already calls for storage schema validation, but schema validation alone does not answer who is allowed to write each key.

The service worker and UI paths touch many storage keys:

```txt
userSettings
selectedFilterLists
userFilters
user-filters
whitelist
hostname switches
URL filtering rules
localData
cloudData
filterListCache
cosmeticFiltersData
compiled counts
runtime/degraded state
```

Without write ownership, backup/restore, cloud sync, settings UI, popup commands, and internal migrations can accidentally overwrite keys owned by another subsystem.

### Generalized fix

Add:

```txt
config/storage-keys.json
src/storage/storage-authority.ts
platform/chromium/js/storage-authority.js
tools/check-storage-key-authority.mjs
```

Each key should declare:

```ts
type StorageKeyAuthority = {
  key: string;
  owner: string;
  schemaId: string;
  allowedWriters: string[];
  allowedReaders: string[];
  backupPolicy: "include" | "exclude" | "redacted";
  cloudPolicy: "sync" | "local-only" | "forbidden";
  migrationPolicy: "manual" | "automatic" | "forbidden";
  privacyClass: "public" | "settings" | "diagnostic" | "sensitive";
};
```

All storage writes should go through:

```ts
setStorageKey({ key, value, writer, reason, policyRevision })
```

### Acceptance check

The check fails if:

```txt
- chrome.storage.local.set is called directly for a registered key outside the storage-authority wrapper.
- backup/restore/cloud paths can write keys not marked as importable/syncable.
- a key exists in code but not in config/storage-keys.json.
- one key has multiple writers without an explicit conflict policy.
```

---

## P0.33 Centralize time, expiry, and freshness decisions

### Problem

The project uses timestamps and expiry logic for many unrelated systems:

```txt
compatibility debt dates
filter-list cache write times
local backup/restore times
smart rule metadata
DNR decision timestamps
runtime-health timestamps
capability token expiry
operation cancellation
repair workflow state
```

If every subsystem calls `Date.now()` or parses dates independently, tests become nondeterministic and expiration rules drift.

### Generalized fix

Add:

```txt
src/shared/time-authority.ts
platform/chromium/js/time-authority.js
tools/check-time-authority.mjs
```

Central API:

```ts
type TimeAuthority = {
  nowMs(): number;
  nowIso(): string;
  monotonicOperationId(scope: string): string;
  isExpired(value: string | number, ttlPolicy: string): boolean;
  freshnessState(value: string | number, ttlPolicy: string): "fresh" | "stale" | "expired";
};
```

Policies should live in:

```txt
config/freshness-policy.json
```

Examples:

```txt
compatibility entry expiry
filter-list cache staleness
diagnostic bundle retention
capability token expiry
operation token expiry
local recorder retention
```

### Acceptance check

The check fails if production code uses raw `Date.now()`, `new Date()`, or ad-hoc date parsing for freshness, expiry, generated IDs, compatibility debt, or cache invalidation outside the time authority.

---

## P0.34 Add a stable ID and namespace allocator for all generated IDs

### Problem

The project has many generated identifiers:

```txt
DNR rule IDs
session rule ID ranges
smart cosmetic rule IDs
collection IDs
operation IDs
capability token IDs
diagnostic bundle IDs
local compatibility history IDs
context-menu IDs
BroadcastChannel/event IDs
```

Some IDs are hand-coded ranges and some are built from time/randomness. That is fragile for reproducibility, testing, collision avoidance, and rollback.

### Generalized fix

Add:

```txt
config/id-namespaces.json
src/shared/id-authority.ts
platform/chromium/js/id-authority.js
tools/check-id-authority.mjs
```

Namespace entry:

```ts
type IdNamespace = {
  id: string;
  owner: string;
  prefix?: string;
  numericRange?: [number, number];
  stableKeyFields?: string[];
  collisionPolicy: "reject" | "reuse-stable" | "allocate-next";
};
```

Rules:

```txt
- DNR rule IDs come from declared numeric ranges only.
- user-created smart rules use stable prefixed IDs from the allocator.
- operation/capability IDs use monotonic scoped IDs, not Math.random.
- release builds can reproduce generated IDs for the same input where possible.
```

### Acceptance check

The check fails if production code constructs IDs with raw `Date.now()`, `Math.random()`, unregistered numeric ranges, or ad-hoc string prefixes.

---

## P0.35 Add one URL/match-pattern semantic compiler

### Problem

The project currently has several places that reason about URLs and match patterns:

```txt
manifest matches
manifest exclude_matches
web_accessible_resources matches
compatibility-sites entries
page-policy profile matching
DNR initiator domains
whitelist entries
filter-list domains
logger grouping
host-access checks
```

Even with an effective-site resolver, raw Chrome match patterns and domain strings can still drift semantically.

Examples of risky drift:

```txt
example.com vs *.example.com
http only vs https only
about:blank inherited frames
file/chrome-extension URLs
youtube.com vs youtube-nocookie.com
yandex.com vs yandex.ru
mobile subdomains
public-suffix edge cases
```

### Generalized fix

Add:

```txt
src/url/match-pattern-authority.ts
platform/chromium/js/match-pattern-authority.js
tools/check-match-pattern-authority.mjs
```

All URL/match/domain inputs should compile to one form:

```ts
type CompiledPattern = {
  source: string;
  schemes: string[];
  hostMode: "exact" | "subdomains" | "effective-site" | "all";
  pathMode: "all" | "prefix" | "exact" | "glob";
  includesAboutBlank: boolean;
  includesOpaqueOrigin: boolean;
  normalizedEffectiveSite?: string;
};
```

### Acceptance check

The check fails if manifest patterns, compatibility entries, whitelist hostnames, DNR domain conditions, or web-accessible-resource matches are edited without a compiled semantic snapshot test.

---

## P0.36 Add policy-downgrade reason codes for every disabled or reduced layer

### Problem

The policy resolver can turn features off or downgrade them to observe-only/specific-only, but generalized behavior needs every downgrade to be explainable.

A disabled layer should never be a mystery to the user or developer.

Examples:

```txt
generic video disabled because profile is app-shell
scriptlets disabled because noScripting switch is active
main-world hooks disabled because browser capability is unavailable
network high-risk rules rejected because filter-list trust tier is low
cosmetic generic disabled because effective site is auth-sensitive
webRequest attribution disabled because logger is inactive
```

### Generalized fix

Add:

```txt
src/policy/policy-reasons.ts
platform/chromium/js/policy-reasons.js
tools/check-policy-reason-coverage.mjs
```

Policy output should include:

```ts
type PolicyDecisionReason = {
  layer: string;
  capability: string;
  state: "enabled" | "disabled" | "observe-only" | "specific-only" | "limited";
  reasonCode: string;
  explanation: string;
  source: "profile" | "setting" | "managed" | "browser-capability" | "trust-tier" | "safe-mode" | "compatibility";
};
```

### Acceptance check

The check fails if any policy field is `false`, `off`, `limited`, `observe-only`, or `specific-only` without a reason code and source.

---

## P0.37 Add high-risk user-intent tokens for dangerous manual actions

### Problem

Some operations are safe only when clearly initiated by the user from a trusted extension page or browser UI:

```txt
restore backup
import remote filter list
trust user filters
enable advanced mode
turn on stealth/surrogate rules
change privacy settings
clear all rules
relax/block page filtering
launch element picker/zapper on a tab
open privileged extension routes
```

Message sender checks are necessary but not enough. A stale page, content script, replayed message, or compromised extension page route should not be able to perform a dangerous operation just because it knows the message shape.

### Generalized fix

Add:

```txt
src/security/user-intent-token.ts
platform/chromium/js/user-intent-token.js
tools/check-user-intent-tokens.mjs
```

Token fields:

```ts
type UserIntentToken = {
  action: string;
  issuedFrom: "popup" | "dashboard" | "context-menu" | "command" | "options";
  tabId?: number;
  documentId?: string;
  issuedAt: number;
  expiresAt: number;
  oneTimeUse: boolean;
};
```

### Acceptance check

The check fails if high-risk actions can run from message handling, restore/import paths, command handlers, or extension routes without a fresh user-intent token.


# P1 — Medium changes with strong architecture value

## P1.1 Replace global content-script payload with policy bootstrap + programmatic layer injection

### Problem

The manifest still injects broad content-script bundles on all HTTP/HTTPS pages and then excludes known sensitive hosts.

This keeps the extension dependent on hostname exception lists.

### Generalized fix

Manifest should inject only a thin bootstrap:

```txt
/js/bootstrap-policy-client.js
```

Bootstrap responsibilities:

```txt
1. collect privacy-safe structural signals
2. request PolicySnapshot from service worker
3. load only allowed layer bundles
4. pass capability tokens to mutation layers
5. register cleanup handlers
```

Heavy bundles should be injected programmatically or dynamically loaded only after policy says yes:

```txt
cosmetic runtime
smart runtime
video runtime
scriptlets
interceptors
first-party response mutation
logger instrumentation
```

### Acceptance check

Manifest check fails if:

```txt
- generic video runtime is statically injected on all HTTP/HTTPS pages.
- smart runtime is statically injected on all HTTP/HTTPS pages.
- global `exclude_matches` grows as primary safety mechanism.
```

---

## P1.2 Convert runtime-layer interface into enforced adapters for real layers

### Problem

`runtime-layer.ts` defines a useful interface, but real layers must be forced through it.

### Generalized fix

Create adapters:

```txt
src/js/runtime/layers/cosmetic-layer.ts
src/js/runtime/layers/smart-cosmetic-layer.ts
src/js/runtime/layers/video-layer.ts
src/js/runtime/layers/scriptlet-layer.ts
src/js/runtime/layers/response-mutation-layer.ts
src/js/runtime/layers/logger-layer.ts
```

Each adapter must implement:

```txt
canStart(policy)
start(context)
stop(reason)
verifyStarted()
verifyStopped()
```

### Acceptance check

`check-cross-layer-integration` fails if a real mutating module starts itself outside a registered adapter.

---

## P1.3 Add frame-policy inheritance for `all_frames` and `match_about_blank`

### Problem

The manifest uses `all_frames` and `match_about_blank`. About:blank/srcdoc/child frames need policy inherited from parent context.

### Generalized fix

Create:

```txt
src/js/runtime/frame-policy.ts
platform/chromium/js/frame-policy.js
```

Policy fields:

```txt
tabId
frameId
parentFrameId
documentUrl
parentUrl
effectiveUrl
profileId
inheritsParentPolicy
thirdPartyFrame
aboutBlankOrSrcdoc
```

Rules:

```txt
- about:blank/srcdoc inherits nearest real parent.
- third-party ad iframes can be filtered even when top frame is app-shell, but only by frame-safe layers.
- main-world hooks are top-frame only unless explicit adapter says otherwise.
- video mutation in subframes requires known player adapter.
```

### Acceptance check

Add fixtures:

```txt
app-shell-with-aboutblank-frame.html
news-page-with-thirdparty-ad-frame.html
video-site-with-player-frame.html
```

---

## P1.4 Promote auto-recovery from helper to policy feedback loop

### Problem

Auto-recovery helper exists, but recovery should feed back into policy and layer activation.

### Generalized fix

Safe-mode state:

```ts
type TabSafeMode = {
  tabId: number;
  documentId?: string;
  reason: string;
  enteredAt: number;
  policyRevision: number;
  disabledLayers: RuntimeLayerId[];
};
```

When safe mode triggers:

```txt
- disable mutation layers for that tab/document
- remove extension-owned CSS for that document
- stop video mutation
- stop scriptlets/main-world hooks
- keep network blocking only if rule is low-risk and site-specific
- show diagnostic in popup/logger
```

### Acceptance check

Breakage fixtures must show that safe mode changes actual layer state, not only a Map entry.

---

## P1.5 Make DNR install decisions persistent and bounded

### Problem

DNR install decisions are currently held in an in-memory list. That is useful for debugging but weak for release diagnostics.

### Generalized fix

Create bounded diagnostic storage:

```txt
platform/chromium/js/dnr-decision-store.js
```

Behavior:

```txt
- max N records per update.
- aggregate counts by source list, action, risk, accepted/rejected reason.
- store raw filter only for user-approved debug export.
- default export redacts raw URLs/query strings.
```

### Acceptance check

Check fails if install decisions grow unbounded or include raw user URLs by default.

---

## P1.6 Unify BroadcastChannel usage into a typed event bus

### Problem

The service worker sends stringly typed BroadcastChannel messages like:

```txt
uBR: userFiltersUpdated
uBR: staticFilteringDataChanged
uBR: assetsUpdated
ubr-smart-cosmetic: rules-changed
```

This can drift across UI/content/runtime modules.

### Generalized fix

Create:

```txt
src/shared/runtime-events.ts
platform/chromium/js/runtime-events.js
```

Event shape:

```ts
type RuntimeEvent = {
  type: string;
  source: "sw" | "popup" | "dashboard" | "content";
  policyRevision?: number;
  payload?: unknown;
};
```

### Acceptance check

No raw `new BroadcastChannel("...").postMessage({ what: ... })` outside event bus.

---

## P1.7 Create a storage schema registry

### Problem

Storage keys are scattered:

```txt
userSettings
selectedFilterLists
userFilters
user-filters
whitelist
ubrPermanentNetFiltering
hostnameSwitchesString
dynamicFilteringString
filterListWriteTimes
cosmeticFiltersData
```

### Generalized fix

Add:

```txt
config/storage-schema.json
src/storage/storage-schema.ts
tools/check-storage-schema-coverage.mjs
```

Every key declares:

```txt
owner
shape
version
migration
backup/export allowed
cloud sync allowed
privacy class
```

### Acceptance check

The check fails if `chrome.storage.local.get/set/remove` uses a literal key not in the registry.

---

## P1.8 Make policy profile and browser capability loading deterministic in release packages

### Problem

`policy-resolver.js` loads config files via `chrome.runtime.getURL("config/...")`. Release packaging must prove those files are included and unchanged.

### Generalized fix

Add release package manifest:

```txt
dist/build/certificate/runtime-config-manifest.json
```

Include:

```txt
config/page-policy.json hash
config/browser-capabilities.json hash
config/compatibility-sites.json hash
config/features.json hash
schema versions
```

### Acceptance check

Release packaging fails if runtime config files are missing, unhashed, or differ from source.

---

## P1.9 Add centralized capability ownership for browser permissions

### Problem

The manifest includes broad permissions such as:

```txt
contextMenus
declarativeNetRequestFeedback
privacy
scripting
tabs
unlimitedStorage
webNavigation
webRequest
<all_urls>
```

Each permission should be tied to a feature/capability and an activation policy.

### Generalized fix

Create:

```txt
config/permission-capabilities.json
```

Entry:

```ts
type PermissionCapability = {
  permission: string;
  owner: string;
  usedBy: string[];
  releaseAllowed: boolean;
  activationPolicy: string;
  test: string;
};
```

### Acceptance check

Manifest permission check fails if permission is not justified in the registry.

---

## P1.10 Add app-safe cosmetic selector compilation

### Problem

Selector risk classification now exists, but the cosmetic compiler should use it as a gate.

### Generalized fix

Compile cosmetic selectors into action classes:

```txt
specific-safe
specific-risky
generic-safe
generic-risky
procedural
critical
```

Policy decides which classes can run per profile.

### Acceptance check

Synthetic app-shell fixtures with ad-like classnames must not hide primary app UI.

---


## P1.11 Add a manifest command registry separate from message contracts

### Problem

Manifest commands are a separate entry point from runtime messages.

Examples:

```txt
launch-element-zapper
launch-element-picker
launch-logger
open-dashboard
relax-blocking-mode
toggle-cosmetic-filtering
toggle-javascript
toggle-newtab
```

These commands can mutate page/runtime state and should not rely on ad-hoc command handling.

### Generalized fix

Add:

```txt
config/command-contracts.json
platform/chromium/js/command-router.js
src/shared/command-contracts.ts
```

Contract:

```ts
type CommandContract = {
  command: string;
  owner: string;
  requiresActiveTab: boolean;
  requiresPolicyReady: boolean;
  mutation: boolean;
  capability?: string;
  settingEffect?: string;
  allowedProfiles?: string[];
};
```

Rules:

```txt
- every manifest command has a contract.
- commands that mutate current page require active tab + policy snapshot.
- commands that toggle settings route through settings-effect registry.
- command handlers return typed results for popup/logger diagnostics.
```

### Acceptance check

Add:

```txt
tools/check-command-contracts.mjs
tests/runtime/command-contracts.spec.ts
```

The check fails if a command exists in manifest but not in command-contracts.json.

---

## P1.12 Add a reversible mutation journal for page and browser-state changes

### Problem

The project can mutate several kinds of state:

```txt
insert CSS
hide/remove DOM nodes
click skip buttons
install DNR/session rules
create context menus
set privacy preferences
update badge/icon state
write storage keys
```

Auto-recovery and safe mode are stronger if every mutation has a recorded owner and optional reversal.

### Generalized fix

Add:

```txt
src/runtime/mutation-journal.ts
platform/chromium/js/mutation-journal.js
```

Journal record:

```ts
type MutationRecord = {
  id: string;
  owner: string;
  layer: RuntimeLayerId;
  target: "page" | "browser" | "storage" | "dnr";
  policyRevision: number;
  reversible: boolean;
  revert?(): Promise<void>;
  redactedSummary: string;
};
```

Rules:

```txt
- mutation-capable layers must record journal entries.
- safe mode asks the journal to revert what is reversible.
- non-reversible mutations require stronger policy evidence.
- diagnostics expose summaries, not raw user content.
```

### Acceptance check

Add:

```txt
tools/check-mutation-journal.mjs
tests/runtime/mutation-journal.spec.ts
```

The check fails if CSS/video/scriptlet/response-mutation paths can mutate without a journal entry.

---

## P1.13 Add quota and backpressure management across DNR, storage, logs, and diagnostics

### Problem

The project has several bounded resources:

```txt
DNR dynamic/session rule limits
storage bytes
logger/network-entry buffers
install-decision records
cosmetic selector counts
observer budgets
BroadcastChannel event volume
```

Some budgets exist locally, but there is no single project-wide quota/backpressure contract.

### Generalized fix

Add:

```txt
config/runtime-quotas.json
src/runtime/quota-manager.ts
platform/chromium/js/quota-manager.js
```

Quota decision:

```ts
type QuotaDecision = {
  allowed: boolean;
  quota: string;
  current: number;
  limit: number;
  action: "allow" | "drop" | "sample" | "compress" | "defer" | "degraded-mode";
  reason: string;
};
```

Rules:

```txt
- every unbounded array/map/cache has a declared quota.
- hitting a soft limit degrades gracefully.
- hitting a hard limit fails closed or switches to observe-only.
- quotas are included in release certificate.
```

### Acceptance check

Add:

```txt
tools/check-runtime-quotas.mjs
tests/runtime/quota-manager.spec.ts
```

The check fails if a long-lived Map/array/cache is not quota-owned.

---

## P1.14 Add reliable event delivery on top of the typed event bus

### Problem

A typed event bus prevents string drift, but it does not guarantee delivery or ordering.

Service workers can suspend, content scripts can load late, and popup/logger pages can open after the event already happened.

### Generalized fix

Extend the event bus with:

```txt
revision number
sequence number
acknowledgement
last-known snapshot
replay for late subscribers
redacted event journal
```

Use for:

```txt
policy invalidation
filter list update complete
staticFilteringDataChanged
assetsUpdated
smart rules changed
safe mode entered/exited
runtime health changed
```

### Acceptance check

Add:

```txt
tests/runtime/event-bus-replay.spec.ts
tools/check-event-bus-reliability.mjs
```

The check fails if critical events are fire-and-forget only.

---

## P1.15 Add cross-layer action traceability, not only DNR install decisions

### Problem

DNR install reports are useful, but the generalized architecture needs traceability for every layer.

Traceable layers:

```txt
network DNR
cosmetic CSS
procedural cosmetic
smart cosmetic
video observation/mutation
scriptlet/main-world hooks
response mutation
context menu/commands
settings effects
```

### Generalized fix

Add:

```txt
src/runtime/action-trace.ts
platform/chromium/js/action-trace.js
```

Trace shape:

```ts
type ActionTrace = {
  actionId: string;
  layer: string;
  source: "filter-list" | "user-rule" | "policy" | "setting" | "runtime";
  policyRevision: number;
  decision: "allow" | "reject" | "observe-only" | "defer";
  reason: string;
  evidence?: string;
  privacyClass: "safe" | "url-redacted" | "debug-only";
};
```

### Acceptance check

Release diagnostics must be able to answer:

```txt
why did this layer run?
which policy allowed it?
which source requested it?
why was it allowed/rejected?
what changed when safe mode entered?
```

---


## P1.16 Add a browser-API facade for deterministic lifecycle tests

### Problem

The active service worker calls many Chrome APIs directly: context menus, tabs, DNR, storage, privacy, webRequest, BroadcastChannel, and runtime APIs.

Direct calls make it harder to test lifecycle ordering, partial failures, retry behavior, rollback, and browser-specific capability degradation.

### Generalized fix

Add:

```txt
src/platform/browser-api.ts
platform/chromium/js/browser-api.js
tests/fakes/fake-browser-api.ts
```

The facade should expose typed methods:

```txt
contextMenus.ensure/remove/verify
dnr.getDynamic/updateDynamic/getSession/updateSession
storage.get/set/remove/getBytesInUse
tabs.query/sendMessage/create
privacy.setNetworkPrediction/setHyperlinkAuditing/setIpHandling
webRequest.register/unregister
runtime.getURL
broadcast.post
```

Rules:

```txt
- service-worker lifecycle code depends on the facade, not raw global chrome APIs.
- tests can inject failure sequences: tab closed, DNR update fails, storage quota exceeded, context menu missing, listener duplicate.
- browser-capability profiles drive facade behavior.
```

### Acceptance check

Add:

```txt
tests/runtime/browser-api-failure-matrix.spec.ts
tools/check-browser-api-facade-usage.mjs
```

The check fails if new lifecycle, DNR, storage, context-menu, or listener code calls `chrome.*` directly outside approved platform adapters.

---

## P1.17 Add a navigation/document lifecycle reconciler

### Problem

Policy decisions and capability tokens are tied to tab/frame/document state, but modern pages mutate by SPA navigation, BFCache restore, same-document URL changes, iframe replacement, and prerender/activation.

A policy revision alone is not enough unless navigation events reconcile active layer state.

### Generalized fix

Add:

```txt
src/runtime/document-lifecycle.ts
platform/chromium/js/document-lifecycle.js
tools/check-document-lifecycle-wiring.mjs
```

Lifecycle events:

```txt
navigation-committed
history-state-updated
reference-fragment-updated
document-replaced
frame-detached
bfcache-pageshow
bfcache-pagehide
prerender-activated
tab-discarded
tab-restored
```

Rules:

```txt
- every active PolicySnapshot has a document lifecycle state.
- same-document navigation may keep some observers but must revalidate selectors and target authority.
- document replacement invalidates all mutation tokens.
- BFCache restore re-verifies CSS, observers, and listener state before mutating again.
```

### Acceptance check

Add fixtures:

```txt
spa-history-navigation.html
bfcache-restore-app.html
iframe-replace-video-player.html
same-document-hash-navigation.html
```

---

## P1.18 Build a policy-decision fuzzer for generalized safety invariants

### Problem

The backlog already includes property-based invariant tests, but the project also needs a dedicated policy-decision fuzzer that generates combinations of signals, settings, profiles, browser capabilities, user rules, frame relationships, and compatibility states.

This catches unsafe combinations that are not obvious from hand-written fixtures.

### Generalized fix

Add:

```txt
tests/fuzz/policy-decision-fuzzer.spec.ts
src/testing/policy-fuzz-generators.ts
```

Generated inputs:

```txt
page profile
frame tree
browser capability profile
settings switches
trusted/whitelist state
safe-mode state
filter-list support state
message source kind
target authority request
resource type / DNR action
```

Required invariants:

```txt
- trusted/off profiles never allow mutation layers.
- app-shell/auth/payment profiles never allow broad generic cosmetic or high-risk DNR blocking.
- missing browser capability downgrades, never upgrades.
- stale policy revision cannot produce a valid mutation token.
- content-script source cannot mutate another tab/document.
- about:blank inherits parent policy or falls back safe.
```

---


## P1.19 Add a cross-source DNR conflict and precedence resolver

### Problem

DNR behavior can now come from several sources:

```txt
static rulesets
dynamic compiled list rules
session rules
whitelist allow rules
unbreak rules
stealth/surrogate rules
user rules
URL filtering rules
fallback/degraded state
```

Even if each rule is safe in isolation, combinations can produce unsafe or ineffective behavior: allow rules can shadow blocks, redirect/surrogate rules can conflict with block rules, session rules can override dynamic assumptions, and user rules can unexpectedly beat curated rules.

### Generalized fix

Add:

```txt
src/dnr/dnr-conflict-resolver.ts
platform/chromium/js/dnr-conflict-resolver.js
tools/check-dnr-conflict-resolution.mjs
```

Conflict report shape:

```ts
type DnrConflict = {
  resourceKey: string;
  candidates: DnrRuleDecision[];
  winner: DnrRuleDecision;
  losers: DnrRuleDecision[];
  reason: string;
  risk: "none" | "low" | "medium" | "high" | "critical";
};
```

Rules:

```txt
- allow/allowAllRequests rules require explicit scope and explanation.
- user rules have clear precedence but cannot bypass high-risk policy gates unless trusted/advanced.
- unbreak rules cannot globally disable protection outside their target scope.
- stealth/surrogate rules must declare which block rules they intentionally replace.
- conflict snapshots are generated for app/auth/payment/video/default fixtures.
```

### Acceptance check

The check fails if high-risk precedence depends only on raw DNR priority numbers without a conflict decision record.

---

## P1.20 Add CSS injection ownership and cascade-layer cleanup

### Problem

The backlog includes a reversible mutation journal, but CSS deserves its own general contract because CSS can break apps without touching DOM nodes directly.

Potential problems:

```txt
multiple style tags from repeated injection
legacy broad CSS not fully removed from already-open tabs
CSS from one policy revision survives into another
cosmetic-specific CSS and generic CSS use the same ownership path
about:blank frames inherit CSS without a clear owner
```

### Generalized fix

Add:

```txt
src/cosmetic/css-injection-registry.ts
platform/chromium/js/css-injection-registry.js
tools/check-css-injection-ownership.mjs
```

CSS ownership key:

```ts
type CssInjectionRecord = {
  id: string;
  tabId: number;
  frameId: number;
  documentId?: string;
  policyRevision: number;
  layer: "specific" | "generic" | "procedural" | "smart" | "legacy-cleanup";
  cascadeLayer: string;
  selectorRiskSummary: object;
};
```

Rules:

```txt
- every injected stylesheet has an owner, layer, document key, and policy revision.
- generic/procedural/smart CSS can be removed independently.
- policy downgrade removes high-risk CSS before any new CSS is inserted.
- legacy cleanup is a one-way removal path, not a source of new broad CSS.
```

### Acceptance check

Fixtures must prove:

```txt
app-shell policy downgrade removes generic/procedural CSS
SPA navigation does not accumulate duplicate style tags
trusted-site toggle removes all owned styles
BFCache restore verifies style ownership before applying new CSS
```

---

## P1.21 Add a two-phase filter-list update pipeline with last-good rollback

### Problem

Remote and bundled filter-list content can fail in several ways:

```txt
network failure
stub/empty content
partial download
bad parser output
unsafe rule spike
DNR install failure
storage quota failure
```

The project needs a generalized update pipeline that separates fetching, compiling, validating, staging, installing, and publishing.

### Generalized fix

Add:

```txt
src/filtering/filter-update-transaction.ts
platform/chromium/js/filter-update-transaction.js
tools/check-filter-update-transaction.mjs
```

Phases:

```txt
1. fetch candidate
2. verify size/hash/source/tier
3. compile candidate
4. classify risk and quota impact
5. simulate install
6. stage DNR and cosmetic data
7. install transactionally
8. publish cache pointer to new version
9. keep last-good pointer
10. rollback on failure
```

Rules:

```txt
- never overwrite last-good cache until the new candidate is installed and verified.
- degraded allow mode is only for install failure, not ordinary remote fetch failure.
- failed list update keeps previous working rules unless schema upgrade requires clearing.
- user-visible diagnostics say which phase failed.
```

### Acceptance check

The check fails if compiled rules/cosmetics are written to active storage before validation and install verification pass.

---

## P1.22 Add an extension-page route and privilege registry

### Problem

The manifest exposes several extension pages and tools:

```txt
dashboard
logger UI
picker/zapper UI
tool overlays
new tab page
options page
web-accessible UI bundles
```

Message contracts protect some service-worker routes, but extension pages also need a route-level privilege model so each page can only call the commands it actually owns.

### Generalized fix

Add:

```txt
config/extension-routes.json
src/platform/extension-route-authority.ts
platform/chromium/js/extension-route-authority.js
tools/check-extension-route-authority.mjs
```

Registry fields:

```ts
type ExtensionRoute = {
  route: string;
  owner: string;
  pageKind: "dashboard" | "logger" | "picker" | "zapper" | "newtab" | "options";
  allowedMessageContracts: string[];
  allowedStorageKeys: string[];
  allowedTabActions: string[];
  webAccessible: boolean;
};
```

### Acceptance check

The check fails if:

```txt
- a web-accessible HTML/JS route has no registry entry.
- logger can call dashboard-only mutation commands.
- picker/zapper routes can access backup/restore/cloud commands.
- newtab can call filtering mutation commands.
```

---

## P1.23 Add an inter-capability conflict matrix

### Problem

Capabilities can be safe individually but unsafe together.

Examples:

```txt
safe mode + pending filter-list sync
trusted site + active session block rules
contextMenuEnabled=false + registered menu entries
custom newtab + extension route exposure
privacy settings + managed policy
stealth surrogate rules + degraded allow mode
logger instrumentation + privacy redaction disabled
```

### Generalized fix

Add:

```txt
config/capability-conflicts.json
platform/chromium/js/capability-conflicts.js
tools/check-capability-conflicts.mjs
```

Conflict rule shape:

```ts
type CapabilityConflictRule = {
  when: string[];
  severity: "warn" | "block" | "repair";
  repairAction?: string;
  explanation: string;
};
```

### Acceptance check

The check fails if known conflicting states can coexist without a warning, block, or repair action.

---

## P1.24 Add a privacy-preserving diagnostic bundle generator

### Problem

The repair workflow needs enough evidence to debug breakage, but diagnostics must not collect private page content, form values, chat text, full URLs with sensitive query strings, or raw filter-list content from user imports.

### Generalized fix

Add:

```txt
src/diagnostics/diagnostic-bundle.ts
platform/chromium/js/diagnostic-bundle.js
tools/check-diagnostic-bundle-privacy.mjs
```

Allowed contents:

```txt
extension version
browser capability profile
policy profile/revision
feature flags
DNR counts and risk summaries
compatibility debt entries affecting effective site
runtime-health state
last capability errors by code, not raw stack by default
redacted URL origin/effective site
fixture classification result
```

Forbidden contents:

```txt
page text
form values
chat/message content
full query strings
cookies
authorization headers
raw imported filter-list text
raw stack traces containing URLs unless debug export explicitly enabled
```

### Acceptance check

The check fails if the diagnostic bundle can include raw page text, form values, cookies, auth headers, or unredacted query strings.


---

## P1.25 Add an extension-page DOM/CSP safety contract

### Problem

The route-authority registry controls which extension pages can do what, but it does not by itself guarantee that those pages are safe against DOM injection, unsafe link opening, remote resource loading, unsafe HTML rendering, or accidental privilege escalation through web-accessible UI routes.

Extension pages are privileged because they can send messages to the service worker and access extension resources.

### Generalized fix

Add:

```txt
config/extension-page-security.json
src/ui/extension-page-security.ts
tools/check-extension-page-dom-safety.mjs
```

Contract fields:

```ts
type ExtensionPageSecurity = {
  route: string;
  allowInnerHTML: boolean;
  allowedExternalLinks: string[];
  requireRelNoopener: boolean;
  allowedMessageContracts: string[];
  allowedStorageKeys: string[];
  allowedRemoteImages: string[];
  cspProfile: "strict" | "ui-local-only" | "dev-only";
};
```

Rules:

```txt
- dashboard/logger/picker/zapper/newtab/options routes get different capabilities.
- HTML rendering helpers sanitize by default.
- external links use rel=noopener/noreferrer.
- no remote scripts or dynamic code execution.
- web-accessible UI routes get the smallest possible message surface.
```

### Acceptance check

The check fails if extension UI code uses unsafe HTML insertion, opens external links without noopener/noreferrer, imports remote scripts, or can call message contracts outside its route authority.

---

## P1.26 Generate profile test matrices from `page-policy.json`

### Problem

The project has a richer `page-policy.json`, but tests can still lag behind the config. Every new profile field should automatically create expectations for runtime behavior.

Manual profile tests are too easy to forget.

### Generalized fix

Add:

```txt
src/policy/profile-test-matrix.ts
tools/generate-policy-profile-tests.mjs
tests/generated/policy-profiles/*.spec.ts
```

Generated matrix dimensions:

```txt
profile id
network mode
cosmetic modes
video mode
scriptlet/main-world mode
contentScript layer booleans
instrumentation booleans
browser capability profile
managed/default/user setting overrides
safe-mode override
frame type: top, child, about:blank, srcdoc
```

### Acceptance check

The check fails if a profile field in `page-policy.json` has no generated test assertion or if a new profile is added without fixture coverage.

---

## P1.27 Add privacy-class retention and deletion policies

### Problem

The backlog now includes diagnostic privacy and quota/backpressure, but generalized privacy also needs retention and deletion rules for every stored/logged data class.

Examples:

```txt
network log entries
runtime-health history
local compatibility recorder history
diagnostic bundles
DNR install decisions
filter-list cache metadata
cloud sync metadata
backup metadata
policy decision traces
operation journals
```

### Generalized fix

Add:

```txt
config/privacy-retention.json
src/privacy/privacy-retention.ts
platform/chromium/js/privacy-retention.js
tools/check-privacy-retention.mjs
```

Retention entry:

```ts
type PrivacyRetentionPolicy = {
  dataClass: string;
  privacyClass: "public" | "settings" | "diagnostic" | "sensitive";
  defaultTtlDays: number;
  maxTtlDays: number;
  exportable: boolean;
  cloudSyncAllowed: boolean;
  deleteOnReset: boolean;
  redactOnExport: boolean;
};
```

### Acceptance check

The check fails if any diagnostic/log/history/cache key has no retention policy, or if sensitive/diagnostic data can be cloud-synced or exported raw by default.

---

## P1.28 Add a release-mode feature-pruning gate

### Problem

The project has many dev/test/check surfaces and specialized site tooling. Release builds need an explicit gate proving that dev-only code, tester-only injections, diagnostic-only privileges, and local recorder features are either removed, disabled, or clearly justified.

This is different from manifest parity. It asks whether a shipped capability belongs in the release profile at all.

### Generalized fix

Add:

```txt
config/release-feature-profile.json
tools/check-release-feature-pruning.mjs
docs/release-feature-profile.md
```

Feature entry:

```ts
type ReleaseFeatureProfile = {
  featureId: string;
  owner: string;
  releaseState: "enabled" | "disabled" | "dev-only" | "test-only" | "diagnostic-only";
  shippedFiles: string[];
  manifestSurfaces: string[];
  justification?: string;
};
```

### Acceptance check

The check fails if dev/test/local-only files are web-accessible, manifest-injected, command-reachable, or message-reachable in release mode without an explicit release profile entry.

---

## P1.29 Add safe external-link and navigation authority

### Problem

The extension opens pages and routes from several places: context menu, command handlers, popup/dashboard links, logger, newtab, import/help pages, and possibly diagnostic reports.

Navigation is a capability. It should not be scattered across `tabs.create`, `tabs.update`, `location.href`, or raw anchor links.

### Generalized fix

Add:

```txt
src/navigation/navigation-authority.ts
platform/chromium/js/navigation-authority.js
tools/check-navigation-authority.mjs
```

Navigation decision:

```ts
type NavigationDecision = {
  target: "extension-page" | "external-web" | "store-page" | "docs" | "blocked";
  url: string;
  sourceRoute: string;
  userIntentRequired: boolean;
  openerPolicy: "none" | "noopener" | "noreferrer";
  allowed: boolean;
  reason: string;
};
```

### Acceptance check

The check fails if production code opens tabs/windows or navigates extension pages without going through the navigation authority.


# P2 — Larger project-wide generalization work

## P2.1 Build a capability-state dashboard for developers

Show all active capabilities per tab:

```txt
policy profile
policy revision
content bundles loaded
runtime layers active
capability tokens issued
DNR rules installed
webRequest instrumentation state
context-menu registry state
safe mode state
compatibility-debt entries affecting this page
```

This should be local-only and redacted.

## P2.2 Turn local compatibility recorder into fixture generator

The project has a local recorder. The next step is to convert recordings into regression fixtures:

```txt
record local breakage -> redact -> generate fixture -> attach expected policy -> simulator snapshot -> CI test
```

## P2.3 Build a complete event-driven extension state machine

Centralize service-worker lifecycle events:

```txt
install
startup
activate
message
tab updated
navigation committed
history state updated
frame detached
tab removed
extension updated
policy changed
filter lists changed
safe mode entered/exited
```

Each event has permitted state transitions.

## P2.4 Replace inline service-worker monolith sections with modules

The canonical service worker is still large and manually maintained. Split only after the current behavior is covered by tests.

Suggested split:

```txt
sw-startup.js
sw-policy.js
sw-messages.js
sw-dnr.js
sw-filter-lists.js
sw-context-menu.js
sw-logger.js
sw-whitelist.js
sw-user-rules.js
sw-runtime-health.js
```

The manifest can still load `sw.js`, but `sw.js` should become a small orchestrator.

## P2.5 Create a release certificate for generalization safety

The release package should include a machine-readable certificate:

```txt
policy schema valid
all compatibility debt unexpired
all manifest exceptions accounted for
all runtime layers registered
all mutation APIs token-gated
all DNR installs transaction-wrapped
all external fetches asset-authorized
all storage keys schema-owned
all broad permissions capability-owned
all generated artifacts in sync
```

---


## P2.6 Add property-based invariant tests for policy and runtime decisions

The project now has many configs and decision functions. Handwritten fixtures are not enough for all combinations.

Add a property-based test suite that generates combinations of:

```txt
profile
frame type
top-frame vs subframe
trusted site state
no-scripting switch
no-cosmetic switch
logger active/inactive
browser capability profile
filter-list trust tier
rule risk class
```

Global invariants:

```txt
trusted site -> no mutation layers
app-shell -> no generic/procedural/smart cosmetic mutation
payment/auth -> no response mutation or main-world hooks
missing browser capability -> feature disabled
stale policy revision -> stop/downgrade layer
expired compatibility debt -> no active manifest exception
```

## P2.7 Build a generalization regression corpus across apps, media, commerce, auth, and news

The existing fixture direction should become a balanced corpus, not only a few sensitive sites.

Corpus groups:

```txt
SPA/chat/editor apps
login/auth flows
checkout/payment flows
video players with and without ads
news/article pages
search result pages
shadow DOM pages
about:blank/srcdoc iframe pages
extension pages
local file/error pages
```

Each fixture should include:

```txt
page signals
expected profile
expected policy snapshot
expected active layers
expected rejected layers
action simulator snapshot
safe-mode expectation
```

## P2.8 Create a migration plan from host exceptions to generated profile fixtures

Compatibility entries should not only expire; they should turn into fixtures.

Migration flow:

```txt
manifest exception -> compatibility debt entry -> local recorder sample -> redacted fixture -> policy/profile fix -> manifest exception removed -> regression fixture remains
```

The final state is not “no knowledge of important sites.” The final state is “site knowledge exists as fixtures/evidence, not as production hostname bypasses.”

## P2.9 Add an extension-state replay harness

Build a local replay harness that can simulate service-worker lifecycle sequences:

```txt
fresh install
upgrade
browser restart
service worker suspended/resumed
filter-list update failure
profile config load failure
context-menu disable/re-enable
safe mode entered/exited
backup restore
policy revision change while content script is active
```

This catches lifecycle bugs that unit tests miss.

## P2.10 Add a source-to-runtime trace map for every shipped behavior

The project has canonical runtime files, generated bundles, prototype sources, and many checks. Add a trace map that answers:

```txt
which source file owns this shipped runtime behavior?
which build step generated it, if any?
which check covers it?
which policy gate controls it?
which release certificate field proves it?
```

This prevents completed scaffolding from drifting away from the active extension package.



## P2.11 Build an upstream-rule semantic parity suite

### Problem

The project compiles and interprets uBO-style filters, but generalized safety depends on knowing when this extension intentionally matches upstream semantics and when it intentionally diverges.

Without a parity suite, parser/compiler changes can accidentally widen, downgrade, or ignore rule options.

### Generalized fix

Add:

```txt
tests/parity/upstream-filter-semantics.spec.ts
fixtures/parity/filter-options/*.txt
src/testing/upstream-semantics-oracle.ts
```

Coverage:

```txt
resource type options
negated resource types
domain and excluded domain options
important/badfilter/exception semantics
redirect/surrogate/removeparam/csp handling
cosmetic vs network filter boundaries
scriptlet/procedural cosmetic unsupported diagnostics
```

Rules:

```txt
- exact matches are marked compatible.
- intentional deviations require a named compatibility note.
- unsafe unsupported features must reject or downgrade with diagnostics.
- no parser option may be silently ignored if it changes rule safety.
```

### Acceptance check

The check fails if a supported option diverges from expected semantics without an explicit deviation record.

---

## P2.12 Add a long-run stability and leak harness across policy profiles

### Problem

Many safety issues only appear after time:

```txt
observer accumulation
style tag accumulation
BroadcastChannel leaks
message listener duplication
tab/frame state leaks
stale capability tokens
DNR session-rule drift
badge update loops
logger buffer growth
```

### Generalized fix

Add:

```txt
tests/soak/policy-profile-soak.spec.ts
tools/run-extension-soak-harness.mjs
```

Scenarios:

```txt
open/close 100 app-shell tabs
SPA navigate a chat fixture 100 times
create/destroy video iframes repeatedly
toggle trusted-site and cosmetic switches repeatedly
open/close logger and popup repeatedly
run filter-list update while navigating
simulate service-worker suspend/resume between operations
```

### Acceptance check

The harness fails if owned resources grow without bound or if runtime registries retain closed tab/document state after cleanup.

---

## P2.13 Add an adapter certification pipeline for specialized site/player support

### Problem

The project should avoid hostname patch lists, but it still needs strong targeted support for high-value complex surfaces such as video players. Specialized adapters are acceptable only if they are evidence-based, policy-gated, reversible, and regression-tested.

### Generalized fix

Add:

```txt
config/adapters.json
src/adapters/adapter-contract.ts
tools/check-adapter-certification.mjs
```

Adapter contract:

```ts
type AdapterCertification = {
  id: string;
  targetKind: "video-player" | "news-layout" | "commerce" | "social-feed" | "app-shell";
  activationSignals: string[];
  allowedLayers: string[];
  mutationCapabilities: string[];
  fixtures: string[];
  rollback: string;
  owner: string;
  expiresAt?: string;
};
```

Rules:

```txt
- adapters activate by structural signals and evidence, not raw hostname alone.
- every adapter has fixtures for true-positive and false-positive activation.
- every mutating adapter declares rollback and token requirements.
- expired adapters fail CI unless renewed with evidence.
```

### Acceptance check

No specialized adapter ships unless it has certification metadata, fixtures, policy mapping, and rollback coverage.

---


---

## P2.14 Build a policy/evidence coverage dashboard

### Problem

The project now has many registries and checks. At this stage, the risk is not absence of ideas; it is invisible partial coverage.

A developer needs to see which shipped behaviors have:

```txt
policy field
capability owner
message/command contract
storage authority
mutation journal coverage
privacy retention policy
release feature profile
fixture coverage
runtime-health state
rollback/repair path
```

### Generalized fix

Add:

```txt
tools/build-policy-evidence-dashboard.mjs
dist/reports/policy-evidence-dashboard.json
docs/policy-evidence-dashboard.md
```

Dashboard rows should be generated from existing registries, not manually maintained.

### Acceptance check

The report fails release if any shipped behavior is missing required coverage in the generalization model.

---

## P2.15 Add a behavior-deprecation and removal pipeline

### Problem

The extension has older compatibility shims, prototype files, generated bundles, site-specific tooling, tester helpers, and migration candidates. Generalization requires not only adding new registries but also retiring obsolete behavior without breaking users.

### Generalized fix

Add:

```txt
config/deprecations.json
tools/check-deprecation-pipeline.mjs
docs/deprecation-policy.md
```

Deprecation entry:

```ts
type BehaviorDeprecation = {
  behaviorId: string;
  owner: string;
  replacementBehaviorId?: string;
  firstDeprecatedVersion: string;
  removalTargetVersion: string;
  migration: "automatic" | "manual" | "none";
  userVisible: boolean;
  releaseBlockerAfter?: string;
};
```

### Acceptance check

The check fails if deprecated behavior remains reachable after its removal target, or if a replacement exists but the old path is still preferred by the active runtime.


---

## P0.38 Add service-worker/content-script version handshake and stale-runtime quarantine

### Problem

MV3 service workers can restart while old content scripts remain in already-open documents. Extension updates can also leave a document running an older injected bundle while the service worker now speaks a newer message, policy, or capability-token protocol.

The current backlog covers document lifecycle and stale-operation cancellation, but it does not explicitly require a version handshake between every active document runtime and the service worker.

Without that handshake:

```txt
- an old content script can send messages using an obsolete schema.
- a new service worker can return policy fields an old runtime misinterprets.
- a stale runtime can keep observers, styles, or tokens alive after extension update.
- compatibility fixes may appear to work only after a full tab reload.
```

### Generalized fix

Add:

```txt
src/runtime/runtime-version.ts
platform/chromium/js/runtime-version.js
tools/check-runtime-version-handshake.mjs
tests/runtime/version-handshake.spec.ts
```

Runtime handshake:

```ts
type RuntimeHandshake = {
  extensionVersion: string;
  runtimeProtocolVersion: number;
  contentBundleId: string;
  documentId?: string;
  frameId: number;
  policyRevision: number;
};
```

Rules:

```txt
- content scripts announce runtimeProtocolVersion before requesting mutation-capable policy.
- service worker rejects or quarantines stale protocol versions.
- stale runtimes are downgraded to observe-only and asked to reload/reinitialize.
- policy snapshots include minRuntimeProtocolVersion.
- extension update triggers cleanup/reconciliation for known old runtimes.
```

### Acceptance check

The check fails if content params, smart cosmetic, picker/zapper, video, scriptlet, logger, or dashboard messages can run without a runtime protocol/version check.

---

## P0.39 Add browser API failure taxonomy and fallback policy

### Problem

Many Chrome APIs can fail for normal reasons: tab closed, missing host permission, quota exceeded, unsupported browser capability, service-worker suspension, user disabled a permission, or extension update race.

Today, many code paths handle these with local `catch` blocks and warnings. Structured error policy was already added as a backlog item, but browser API failure handling needs a dedicated taxonomy because recovery differs by API.

### Generalized fix

Add:

```txt
src/runtime/browser-api-errors.ts
platform/chromium/js/browser-api-errors.js
tools/check-browser-api-error-policy.mjs
tests/runtime/browser-api-failure-policy.spec.ts
```

Error taxonomy:

```ts
type BrowserApiFailure = {
  api: "tabs" | "scripting" | "dnr" | "contextMenus" | "storage" | "webRequest" | "privacy" | "commands";
  operation: string;
  reason: "tab-closed" | "permission-missing" | "quota" | "unsupported" | "invalid-argument" | "transient" | "policy-denied";
  recoverable: boolean;
  fallback: "retry" | "degrade" | "repair" | "ignore" | "surface-to-user";
};
```

Rules:

```txt
- every browser API wrapper maps errors to a known reason.
- mutation operations cannot silently ignore unsupported or denied states.
- benign tab-closed races stay quiet but are counted.
- quota and permission failures become runtime-health transitions.
- release checks fail on raw catch-and-ignore for high-risk APIs.
```

### Acceptance check

No direct high-risk Chrome API call may catch an error without mapping it through the browser API failure taxonomy.

---

## P0.40 Add timer, interval, idle-callback, and scheduler ownership registry

### Problem

The project has observer budgets and task locks, but timers are another source of duplicate runtime work and leaks. Service-worker restarts, popup/logger sessions, badge refreshes, retries, delayed DNR syncs, and content-script scans can all create timers.

A lifecycle registry should own not only listeners and menus, but also scheduled work.

### Generalized fix

Add:

```txt
src/runtime/scheduler-registry.ts
platform/chromium/js/scheduler-registry.js
tools/check-scheduler-ownership.mjs
tests/runtime/scheduler-registry.spec.ts
```

Scheduler entry:

```ts
type ScheduledTask = {
  id: string;
  owner: string;
  kind: "timeout" | "interval" | "idle" | "animation-frame" | "service-worker-deferred";
  policyRevision?: number;
  documentKey?: string;
  maxRuns?: number;
  cancelOn: string[];
};
```

Rules:

```txt
- no raw setTimeout/setInterval/requestIdleCallback in mutation/runtime modules.
- scheduled work carries owner, reason, policy revision, and cancellation condition.
- tab close, frame detach, policy invalidation, logger close, popup close, and extension update cancel relevant work.
- repeated startup cannot create duplicate periodic tasks.
```

### Acceptance check

The check fails if raw timers appear outside the scheduler registry or test shims.

---

## P1.30 Add long-lived channel/session ownership registry

### Problem

Listener ownership covers static event registration, but it does not fully cover long-lived sessions such as `BroadcastChannel`, popup/logger sessions, content-script channels, devtools-like views, picker/zapper sessions, and local compatibility recorder sessions.

These sessions need explicit ownership, lifecycle, privacy level, and teardown semantics.

### Generalized fix

Add:

```txt
src/runtime/channel-registry.ts
platform/chromium/js/channel-registry.js
tools/check-channel-registry.mjs
tests/runtime/channel-lifecycle.spec.ts
```

Session contract:

```ts
type RuntimeChannelSession = {
  id: string;
  owner: string;
  channelKind: "broadcast" | "port" | "popup" | "logger" | "content" | "extension-page";
  allowedMessages: string[];
  privacyClass: string;
  openedAt: number;
  closeReason?: string;
};
```

Rules:

```txt
- channel sessions register on open and unregister on close/disconnect/document unload.
- message contracts apply to long-lived channels, not only one-shot runtime messages.
- logger/popup activation state derives from sessions, not loose booleans.
- stale sessions are cleaned on service-worker startup and tab/document reconciliation.
```

### Acceptance check

No BroadcastChannel, port, popup/logger live state, or picker/zapper session is created outside the channel/session registry.

---

## P1.31 Add a user-visible decision explanation API

### Problem

The backlog includes policy reasons, diagnostic bundles, and evidence dashboards. What is still missing is a small runtime API that lets popup/logger/dashboard ask: "why did this page get this policy, and why was this action allowed, rejected, downgraded, or observe-only?"

Without this, debugging stays developer-only and users cannot distinguish intentional safety downgrades from bugs.

### Generalized fix

Add:

```txt
src/runtime/decision-explainer.ts
platform/chromium/js/decision-explainer.js
tools/check-decision-explainer-coverage.mjs
```

Decision explanation:

```ts
type DecisionExplanation = {
  decisionId: string;
  target: "page" | "rule" | "selector" | "scriptlet" | "video" | "navigation" | "setting";
  outcome: "allowed" | "blocked" | "rejected" | "downgraded" | "observe-only" | "degraded";
  reasons: string[];
  evidence: string[];
  userVisibleSummary: string;
  privacyClass: "safe" | "redacted" | "developer-only";
};
```

Rules:

```txt
- every policy downgrade has a user-safe explanation.
- every rejected high-risk rule/action has a developer explanation.
- popup/logger can display explanations without exposing raw URLs, selectors, or private page text unless debug mode explicitly allows it.
```

### Acceptance check

The check fails if a policy, DNR, selector, scriptlet, video, navigation, or setting decision lacks an explanation hook.

---

## P1.32 Add a central heuristic evidence and confidence model

### Problem

The project uses many heuristic systems: page classification, smart cosmetics, video ad detection, auto-recovery, selector risk classification, anti-adblock handling, layout-collapse decisions, and adapter activation.

Each heuristic can become too aggressive unless confidence is comparable across layers.

### Generalized fix

Add:

```txt
src/runtime/heuristic-evidence.ts
config/heuristic-thresholds.json
tools/check-heuristic-evidence-model.mjs
tests/runtime/heuristic-thresholds.spec.ts
```

Evidence model:

```ts
type HeuristicEvidence = {
  detectorId: string;
  targetKind: string;
  positiveSignals: string[];
  negativeSignals: string[];
  confidence: number;
  requiredPolicy: string[];
  allowedActionsAtConfidence: Record<string, string[]>;
};
```

Rules:

```txt
- observation can run at low confidence.
- reversible cosmetics require medium confidence.
- irreversible DOM mutation, auto-click, response mutation, and scriptlet hooks require high confidence plus policy token.
- negative signals can force observe-only even when positive signals exist.
```

### Acceptance check

No heuristic detector may directly trigger mutation without producing a normalized evidence/confidence record.

---

## P1.33 Add header, CSP, cookie, and privacy-setting mutation authority

### Problem

Network blocking is not the only dangerous network-side behavior. Header changes, CSP mutation, cookie behavior, privacy API changes, and redirect/surrogate behavior can break sites or have privacy implications.

The policy resolver already contains placeholders for some network mutation concepts, but the backlog needs one authority for these non-blocking network mutations.

### Generalized fix

Add:

```txt
src/network/network-mutation-authority.ts
platform/chromium/js/network-mutation-authority.js
tools/check-network-mutation-authority.mjs
```

Authority record:

```ts
type NetworkMutationDecision = {
  mutationKind: "header" | "csp" | "cookie" | "privacy-setting" | "redirect" | "surrogate" | "upgrade";
  source: "static-rule" | "dynamic-rule" | "user-setting" | "filter-list" | "adapter";
  policyAllowed: boolean;
  trustTier: string;
  reversible: boolean;
  reason: string;
};
```

Rules:

```txt
- header/CSP/cookie/privacy mutations use the same policy/evidence pipeline as blocking.
- release mode forbids dev/test-only network mutations.
- user settings that affect browser privacy APIs have explicit browser support and rollback state.
```

### Acceptance check

No header, CSP, cookie, privacy API, redirect, surrogate, or upgrade behavior may be added without a network mutation decision record.

---

## P1.34 Add DOM traversal boundary policy

### Problem

The extension needs to inspect and mutate DOM safely across ordinary DOM, Shadow DOM, iframes, adopted stylesheets, document-start races, and SPA replacements. Existing items cover target authority and document lifecycle, but not the traversal boundaries themselves.

### Generalized fix

Add:

```txt
src/dom/dom-boundary-policy.ts
platform/chromium/js/dom-boundary-policy.js
tools/check-dom-boundary-policy.mjs
tests/runtime/dom-boundary-policy.spec.ts
```

Boundary decision:

```ts
type DomBoundaryDecision = {
  rootKind: "document" | "open-shadow" | "closed-shadow" | "iframe" | "srcdoc" | "adopted-stylesheet";
  allowRead: boolean;
  allowObserve: boolean;
  allowStyleInject: boolean;
  allowMutation: boolean;
  reason: string;
};
```

Rules:

```txt
- closed shadow roots are not assumed accessible.
- iframe traversal requires frame policy and target authority.
- adoptedStyleSheets and CSSOM mutations require CSS ownership metadata.
- auth/payment/app-shell profiles default to observe-only or off for deep traversal.
```

### Acceptance check

No DOM traversal helper may walk frames, shadow roots, or stylesheets without a boundary decision.

---

## P1.35 Add UI interaction safety policy for synthetic clicks, focus, keyboard, and pointer capture

### Problem

Some ad-blocking features require UI interactions such as skip-button clicks or element picker overlays. These are higher-risk than hiding a selector because they can trigger page actions.

The backlog has user-intent tokens and adapter certification, but it should also define a general safety contract for synthetic UI actions.

### Generalized fix

Add:

```txt
src/runtime/ui-interaction-policy.ts
platform/chromium/js/ui-interaction-policy.js
tools/check-ui-interaction-policy.mjs
tests/runtime/ui-interaction-policy.spec.ts
```

Interaction decision:

```ts
type UiInteractionDecision = {
  action: "click" | "focus" | "blur" | "keydown" | "pointer-capture" | "scroll";
  initiator: "user" | "adapter" | "scriptlet" | "picker" | "video";
  requiresGesture: boolean;
  confidence: number;
  allowed: boolean;
  reason: string;
};
```

Rules:

```txt
- automatic clicks require certified adapter evidence or fresh user intent.
- focus/keyboard actions are blocked by default on auth/payment/app-shell profiles.
- pointer capture and overlay actions are extension-owned and reversible.
- UI interactions are journaled and explainable.
```

### Acceptance check

No synthetic UI action may be emitted directly from video, scriptlet, picker, zapper, or smart runtime without a UI interaction decision.

---

## P1.36 Add capability-owned cache namespace and invalidation

### Problem

Storage-key ownership covers persistent storage. The project also has in-memory caches, session rules, cached hostnames, compiled cosmetics, available filter-list metadata, logger state, popup state, runtime health, and policy/profile caches.

These caches need ownership and invalidation just like storage keys.

### Generalized fix

Add:

```txt
src/runtime/cache-registry.ts
platform/chromium/js/cache-registry.js
tools/check-cache-registry.mjs
tests/runtime/cache-invalidation.spec.ts
```

Cache record:

```ts
type CacheNamespace = {
  id: string;
  owner: string;
  persistence: "memory" | "session" | "local-storage" | "dnr-session" | "dnr-dynamic";
  invalidatedBy: string[];
  privacyClass: string;
  maxEntries?: number;
};
```

Rules:

```txt
- every cache declares owner, persistence, invalidation sources, and privacy class.
- policy changes invalidate dependent cache namespaces.
- extension update and schema migration clear incompatible cache versions.
- memory/session caches expose size metrics for leak tests.
```

### Acceptance check

No new in-memory, session, or storage-backed cache may be created outside the cache registry.

---

## P2.16 Add extension-update migration and old-runtime cleanup

### Problem

The DNR schema migration path exists, but full extension-update migration is broader: storage schemas, policy profiles, generated assets, content-script protocol, context-menu registry, command contracts, compatibility entries, and runtime-health state may all change.

### Generalized fix

Add:

```txt
config/extension-migrations.json
src/runtime/extension-update-migration.ts
platform/chromium/js/extension-update-migration.js
tools/check-extension-migrations.mjs
tests/runtime/extension-update-migration.spec.ts
```

Migration record:

```ts
type ExtensionMigration = {
  fromVersion: string;
  toVersion: string;
  storageMigrations: string[];
  cacheInvalidations: string[];
  runtimeProtocolBump?: number;
  oldRuntimeAction: "allow" | "observe-only" | "quarantine" | "reload-required";
  rollback?: string;
};
```

Rules:

```txt
- onInstalled/update runs declared migrations in order.
- protocol bumps quarantine stale content scripts.
- generated assets and profile schemas are verified after update.
- failed migration enters visible repair/degraded mode instead of partial silent state.
```

### Acceptance check

Every version bump that changes policy, storage, DNR, generated assets, or runtime protocol has a migration entry.

---

## P2.17 Add user-authored rule preview, explain, commit, and undo workflow

### Problem

User-authored filters, smart cosmetic rules, element-picker results, dynamic rules, and imported rules can all affect the page. Validation alone is not enough; the user should be able to preview impact, see why a rule is high-risk, commit it, and undo it.

### Generalized fix

Add:

```txt
src/user-rules/user-rule-transaction.ts
platform/chromium/js/user-rule-transaction.js
tools/check-user-rule-transaction.mjs
tests/runtime/user-rule-preview-commit.spec.ts
```

Workflow:

```txt
parse -> normalize -> classify risk -> simulate -> explain -> preview -> commit transactionally -> journal -> undo
```

Rules:

```txt
- broad cosmetic, procedural, scriptlet, response-mutation, and first-party network rules require preview or trusted-user mode.
- committed user rules create journal entries and policy invalidation events.
- undo restores previous rule state and removes generated runtime artifacts.
```

### Acceptance check

No user-authored mutating rule path may save directly without passing through preview/classify/commit or an explicit trusted bypass.

---

## P2.18 Add resource and energy budget enforcement across all active runtimes

### Problem

Observer budgets exist, but runtime cost also comes from selector matching, message traffic, logger streams, network attribution, retries, diagnostics, timers, smart-rule evaluation, video scans, and repair loops.

A generalization architecture should prevent safe-mode and app-shell profiles from becoming slow even if every layer is individually "within budget."

### Generalized fix

Add:

```txt
src/runtime/resource-budget.ts
config/resource-budgets.json
tools/check-resource-budget-wiring.mjs
tests/runtime/resource-budget-soak.spec.ts
```

Budget:

```ts
type ResourceBudget = {
  profileId: string;
  maxCpuMsPerMinute: number;
  maxDomScansPerMinute: number;
  maxMessagesPerMinute: number;
  maxLoggerEventsPerMinute: number;
  maxMemoryKbPerDocument: number;
  onExceed: "backoff" | "observe-only" | "stop-layer" | "safe-mode";
};
```

Rules:

```txt
- app-shell/auth/payment profiles have strict budgets.
- logger/debug mode has separate explicit budget.
- repeated budget violations become runtime-health transitions.
- budget pressure downgrades lower-priority layers before disabling core blocking.
```

### Acceptance check

Long-run tests fail if active runtime cost exceeds the profile budget without a backoff or downgrade transition.




## P0.41 Add authenticated sender envelopes for every extension message

### Problem

The backlog already asks for message contracts, command contracts, target authority, and high-risk user-intent tokens. That is necessary, but it still leaves a separate authority gap: every message also needs a verifiable sender envelope.

A command can have a schema and still be unsafe if the service worker accepts the same shape from the wrong execution context:

```txt
content script -> dashboard-only command
old content runtime -> new service worker protocol
web-accessible extension route -> privileged route command
about:blank child frame -> top-frame action
stale popup/logger page -> mutation after state changed
replayed message -> repeated commit
```

### Generalized fix

Add:

```txt
src/security/sender-envelope.ts
platform/chromium/js/sender-envelope.js
tools/check-sender-envelope-usage.mjs
```

Envelope shape:

```ts
type SenderEnvelope = {
  senderKind: "service-worker" | "content-script" | "popup" | "dashboard" | "logger" | "options" | "extension-page" | "main-world-bridge";
  extensionOrigin: string;
  tabId?: number;
  frameId?: number;
  documentId?: string;
  pageOrigin?: string;
  routeId?: string;
  runtimeProtocolVersion: string;
  issuedAt: number;
  nonce?: string;
};
```

The envelope should be derived by trusted code, not accepted as user-controlled message data.

### Acceptance check

The check fails if:

```txt
- any service-worker message branch uses raw `sender` fields directly.
- any mutation-capable command runs without a normalized sender envelope.
- content-script senders can call extension-page-only or dashboard-only commands.
- extension-page routes can call content/page mutation commands without route authority.
- `sender.tab.id` alone is treated as proof of document authority.
```

---

## P0.42 Add main-world bridge authority with nonce-bound handshakes

### Problem

The manifest and runtime model include MAIN-world scripts and main-world hooks. These are high-risk because they share execution context with the page and can be observed or influenced by hostile page JavaScript.

Existing policy fields such as `mainWorldHooks` and `scriptlets` describe whether hooks should be allowed, but they do not by themselves define a bridge authority:

```txt
- who can create a page-world bridge.
- which nonce or channel binds the bridge to this extension instance.
- which commands are allowed over the bridge.
- which page origin/profile can receive the bridge.
- when the bridge expires after navigation, BFCache restore, or policy revision.
- how injected page-world code proves it belongs to the current extension runtime.
```

### Generalized fix

Add:

```txt
src/security/main-world-bridge-policy.ts
platform/chromium/js/main-world-bridge-policy.js
tools/check-main-world-bridge-authority.mjs
```

Bridge policy shape:

```ts
type MainWorldBridgePolicy = {
  bridgeId: string;
  tabId: number;
  frameId: number;
  documentId: string;
  pageOrigin: string;
  policyRevision: string;
  allowedMessages: string[];
  nonce: string;
  expiresAt: number;
  observeOnly: boolean;
};
```

The content script should only open a main-world bridge after policy resolution and capability-token issuance. The page-world side should receive a one-time nonce and should never receive broad extension state.

### Acceptance check

The check fails if:

```txt
- MAIN-world scripts can be injected without a bridge policy.
- page-world messages are accepted without nonce, documentId, frameId, and policyRevision validation.
- bridge code can call general service-worker commands.
- bridge listeners survive navigation or policy downgrade.
- bridge diagnostics include page text, form values, cookies, or localStorage.
```

---

## P0.43 Add incognito, private-window, and profile-mode policy

### Problem

The extension has storage, logging, filter-list cache, diagnostics, webRequest instrumentation, context menus, DNR session rules, and cloud/backup paths. These can behave differently in incognito/private windows, browser profiles, guest profiles, or split extension contexts.

Generalization should not assume one global profile state:

```txt
- storage may be shared, split, or unavailable.
- DNR session rules may need profile/window scoping.
- logger and diagnostic data may need stricter retention in private mode.
- cloud sync and backup may be disallowed in private mode.
- context-menu and command state may differ by profile/window.
- runtime-health and repair state may need separate namespaces.
```

### Generalized fix

Add:

```txt
src/privacy/profile-mode-policy.ts
platform/chromium/js/profile-mode-policy.js
tools/check-profile-mode-policy.mjs
```

Policy outputs:

```txt
normal profile
incognito split profile
incognito spanning profile
guest profile
managed enterprise profile
unknown/restricted profile
```

For each mode, define:

```txt
storage namespace
logger behavior
diagnostic retention
cloud/backup eligibility
DNR session/dynamic behavior
context-menu eligibility
webRequest instrumentation eligibility
safe-mode namespace
```

### Acceptance check

The check fails if storage, logger, diagnostic, DNR, cloud, or backup code writes global state without passing through profile-mode policy.

---

## P0.44 Add permission-change observer and downgrade/recovery flow

### Problem

The manifest declares many permissions and the backlog already asks for capability ownership. A separate gap remains: permissions can be missing, revoked, unsupported by browser, disabled by policy, or behave differently by profile.

The extension needs a single flow for permission changes:

```txt
- detect missing permission at startup.
- detect revoked optional permission.
- detect browser API unavailable despite manifest permission.
- downgrade dependent layers.
- explain the downgrade.
- offer user-visible repair when appropriate.
- prevent stale capabilities from continuing after permission loss.
```

### Generalized fix

Add:

```txt
src/runtime/permission-state.ts
platform/chromium/js/permission-state.js
tools/check-permission-downgrade-wiring.mjs
```

Permission state should feed into:

```txt
policy resolver
runtime-layer activation
browser capability snapshot
decision explanation API
partial-startup repair workflow
runtime-health state machine
release certificate
```

### Acceptance check

The check fails if a layer directly assumes `chrome.scripting`, `chrome.webRequest`, `chrome.privacy`, `chrome.tabs`, `chrome.contextMenus`, `chrome.declarativeNetRequestFeedback`, or `chrome.storage.sync` without querying permission/capability state first.

---

## P1.37 Add remote filter content safety scanner and decompression/parser limits

### Problem

Filter-list fetching and trust tiers are now called out, but remote content safety needs its own generalization item. A remote list can be syntactically valid enough to parse while still being dangerous operationally:

```txt
- extremely large files.
- decompression bombs.
- huge single-line filters.
- excessive regex complexity.
- too many redirect/surrogate/header/CSP/cookie rules.
- rules that are valid but exceed profile trust caps.
- files that change type or encoding unexpectedly.
- CDN response mismatch with cached metadata.
```

### Generalized fix

Add:

```txt
src/filtering/filter-content-safety.ts
platform/chromium/js/filter-content-safety.js
tools/check-filter-content-safety.mjs
```

Safety scan stages:

```txt
1. transport metadata check
2. content-type/encoding check
3. size and decompression limit check
4. line-length and total-line check
5. syntax-class histogram
6. action-risk histogram
7. trust-tier cap application
8. parser budget enforcement
9. staged install approval
```

### Acceptance check

The check fails if remote/imported filter content can enter parser/compiler/install paths without content safety results and trust-tier cap results.

---

## P1.38 Add extension UI state isolation and privilege-separated stores

### Problem

The extension has popup, dashboard, logger, picker, zapper, options, custom new-tab, and other web-accessible UI surfaces. These surfaces should not share one implicit state model.

A generalized blocker should separate UI state by privilege and route:

```txt
- popup display state
- dashboard configuration state
- logger diagnostic state
- picker/zapper transient page-target state
- options persistent settings state
- new-tab UI state
- repair workflow state
- developer/debug UI state
```

Without isolation, a bug in one route can accidentally mutate state owned by another route, persist transient data, or expose privileged diagnostics to a lower-privilege UI.

### Generalized fix

Add:

```txt
src/ui/ui-state-registry.ts
platform/chromium/js/ui-state-registry.js
tools/check-ui-state-isolation.mjs
```

Each UI state entry declares:

```txt
owner route
storage namespace
privacy class
persistence mode
allowed readers
allowed writers
clear-on-navigation/update/profile-mode rules
backup/cloud eligibility
```

### Acceptance check

The check fails if extension pages read/write arbitrary `chrome.storage.local` keys or share logger/picker/popup/dashboard state without route ownership.

---

## P1.39 Add accessibility and localization regression gates for extension pages

### Problem

Generalization is not only blocking behavior. If the extension adds repair flows, decision explanations, compatibility dashboards, policy debuggers, and user-rule preview/undo pages, those UIs need to remain usable and localizable.

This is currently a separate quality/safety gap:

```txt
- repair messages may be hardcoded English.
- decision reasons may not map to localized message keys.
- keyboard-only users may not be able to use picker/logger/repair flows.
- popup/dashboard state may be screen-reader hostile.
- generated policy explanations may expose raw internal codes without user-safe wording.
```

### Generalized fix

Add:

```txt
src/ui/a11y-l10n-contract.ts
tools/check-extension-ui-a11y.mjs
tools/check-extension-ui-l10n.mjs
```

Every user-visible route and generated explanation should declare:

```txt
message keys
ARIA role expectations
keyboard navigation expectations
focus management rules
danger/repair wording class
safe technical-detail expansion
```

### Acceptance check

The check fails if new user-visible strings, repair messages, decision explanations, or route labels bypass localization keys or if privileged flows cannot be reached/confirmed by keyboard-only navigation.

---

## P2.19 Add privacy-mode and profile-mode regression corpus

### Problem

The existing regression corpus covers page types and runtime profiles, but it should also cover browser privacy/profile modes. Bugs in this area tend to appear only after the same feature is run in normal windows, incognito/private windows, multiple profiles, or managed environments.

### Generalized fix

Add fixtures for:

```txt
normal profile + standard tab
normal profile + multiple windows
incognito/private + logger closed
incognito/private + logger open
split incognito storage unavailable
managed profile with restricted privacy API
guest profile with storage limitations
extension update while private window has stale content runtime
filter-list update while private and normal windows are both open
```

### Acceptance check

Tests fail if:

```txt
- private-mode diagnostics persist longer than policy.
- private-mode storage leaks into normal-mode namespace.
- DNR/session/runtime-health state is attributed to the wrong profile mode.
- cloud/backup operations run where policy forbids them.
- stale private-window content runtimes keep mutation authority after extension update.
```

---

## P2.20 Add permission-surface drift and store-compliance review generator

### Problem

The manifest, policy resolver, runtime-layer activation, web-accessible-resource registry, browser capability profiles, and release certificate all describe pieces of the permission surface. These can drift independently.

A general extension should generate a review artifact whenever the permission surface changes:

```txt
permissions added/removed
host permissions widened/narrowed
content-script matches/excludes changed
MAIN-world scripts changed
web-accessible resources changed
DNR feedback or webRequest usage changed
privacy/tabs/scripting usage changed
optional permission request flows changed
```

### Generalized fix

Add:

```txt
tools/generate-permission-surface-review.mjs
dist/release/permission-surface-review.json
docs/generated/permission-surface-review.md
```

The artifact should explain:

```txt
why each permission exists
which feature owns it
which policy profiles can activate it
which user-visible UI explains it
which tests cover it
whether it is dev-only, release, optional, or required
```

### Acceptance check

Release checks fail if the permission surface changes without an updated review artifact and matching policy/test coverage.

---

## P2.21 Add adversarial tests for main-world bridges and page-owned script interaction

### Problem

A normal regression corpus can prove that main-world bridges work. It does not prove that hostile or unusual pages cannot misuse them.

### Generalized fix

Add adversarial fixtures for:

```txt
page spoofs extension bridge messages
page replays old nonce
page delays response until policy revision changes
page navigates frame after bridge opens
page replaces history state during bridge operation
page monkey-patches postMessage/EventTarget before bridge load
page floods bridge channel
page creates same-named DOM events
page embeds sandboxed/credentialless/about:blank iframes
page attempts to read bridge diagnostics
```

### Acceptance check

Tests fail if page-owned JavaScript can trigger mutation-capable extension behavior, reuse stale bridge authority, leak diagnostics, or keep bridge listeners alive after navigation/policy downgrade.

---

## P0.45 Add optional-permission grant flow and least-privilege migration

### Problem

The project already has permission-surface review and downgrade behavior, but it still needs a positive permission acquisition model. A broad permission can be present in the manifest forever even if only a small subset of features need it.

Without an optional-permission flow:

```txt
- permissions are treated as globally available instead of feature-scoped.
- feature enablement can drift from the permission actually granted.
- the extension cannot explain why a permission is needed at the moment of use.
- least-privilege migration is hard because every feature assumes baseline access.
- permission loss and permission gain are not symmetric lifecycle events.
```

### Generalized fix

Add:

```txt
platform/chromium/js/permission-request-authority.js
config/permission-capabilities.json
src/js/runtime/optional-permission-policy.ts
```

Each permission should declare:

```ts
type PermissionCapability = {
  permission: string;
  optional: boolean;
  owners: string[];
  requiredFor: string[];
  userFacingReasonKey: string;
  fallbackPolicy: "disable" | "observe-only" | "degraded";
  grantTriggers: string[];
  revokeEffects: string[];
};
```

Rules:

```txt
- no feature asks for a permission directly.
- permission requests route through one authority.
- permission prompts require fresh user intent.
- granted permission emits policy invalidation.
- revoked permission cancels related tokens and downgrades active layers.
- release review can distinguish required vs optional permission surfaces.
```

### Acceptance check

Add:

```txt
tools/check-optional-permission-authority.mjs
tests/permissions/optional-permission-flow.spec.ts
```

The check fails if a feature calls `chrome.permissions.request()` directly, uses permission-gated APIs without a declared capability, or enables high-risk behavior without a grant/fallback decision.

---

## P0.46 Add static-ruleset lifecycle and enabled-state reconciliation

### Problem

The backlog covers dynamic/session DNR transactions and cross-source conflict resolution. Static rulesets are a separate lifecycle surface because they are declared in the manifest and can be enabled/disabled independently.

Failure cases:

```txt
- a static ruleset remains enabled after policy/profile downgrade.
- a disabled static ruleset is assumed active by diagnostics.
- manifest-declared test rulesets leak into release builds.
- static and dynamic rules disagree but the health model reports only dynamic state.
- extension update changes ruleset IDs without migration cleanup.
```

### Generalized fix

Add:

```txt
platform/chromium/js/static-ruleset-registry.js
config/static-ruleset-policy.json
tools/check-static-ruleset-lifecycle.mjs
```

Registry fields:

```ts
type StaticRulesetPolicy = {
  id: string;
  manifestPath: string;
  owner: string;
  releaseMode: "dev" | "test" | "release";
  defaultEnabled: boolean;
  allowedProfiles: string[];
  conflictsWith: string[];
  migrationVersion: number;
};
```

Rules:

```txt
- startup reconciles actual enabled static rulesets against policy.
- diagnostics report static, dynamic, and session state together.
- test/dev rulesets are impossible to enable in release unless explicitly allowed.
- static rulesets participate in conflict/precedence explanations.
- ruleset ID changes require a migration entry.
```

### Acceptance check

The check fails if a manifest static ruleset has no registry entry, a release package includes enabled test rulesets, or runtime health cannot report effective static ruleset state.

---

## P0.47 Add safe-reset and factory-reset authority

### Problem

Partial-startup repair handles known failures, but the project also needs a controlled reset path when state is corrupt or unrecoverable. A user should not need to manually clear extension storage or reinstall to escape a bad migration, broken ruleset state, stale menus, or invalid policy config.

### Generalized fix

Add:

```txt
platform/chromium/js/reset-authority.js
src/js/dashboard/reset-flow.ts
tools/check-reset-authority.mjs
```

Reset levels:

```txt
level 1: repair transient runtime state
level 2: clear caches and generated artifacts
level 3: reset DNR/session/dynamic/context-menu/listener/runtime state
level 4: reset settings to defaults but keep user filters/whitelist
level 5: full factory reset after explicit confirmation/export prompt
```

Rules:

```txt
- reset authority declares exactly which storage keys and runtime surfaces it may touch.
- destructive reset requires fresh user-intent token.
- reset creates a privacy-safe diagnostic summary before clearing state.
- reset never deletes user-authored filters without explicit confirmation.
- reset re-runs startup sequencer and reports verification result.
```

### Acceptance check

Tests simulate corrupt storage, invalid DNR schema, stale context menus, invalid policy profile cache, and incompatible runtime protocol. Each must produce a safe repair or reset path without manual reinstall.

---

## P1.40 Add user-visible state-surface reconciliation

### Problem

The project has runtime health, decision explanations, popup/logger state, badge updates, and repair UI, but these surfaces can disagree if each reads a different subset of state.

Examples:

```txt
- badge says filtering is active while runtime health is degraded.
- popup says lists are loaded while DNR install failed.
- logger displays network attribution while instrumentation is inactive.
- dashboard shows a setting changed but active content runtimes still use old policy revision.
- repair page reports success but context menu or static ruleset verification failed.
```

### Generalized fix

Add:

```txt
platform/chromium/js/state-surface-reconciler.js
src/js/ui/effective-extension-state.ts
tools/check-state-surface-reconciliation.mjs
```

Expose one effective state object:

```ts
type EffectiveExtensionState = {
  policyRevision: string;
  healthState: string;
  filteringState: "active" | "degraded" | "observe-only" | "disabled";
  dnrState: object;
  listState: object;
  runtimeState: object;
  permissionState: object;
  repairState: object;
  visibleStatus: {
    badge: string;
    popup: string;
    logger: string;
    dashboard: string;
  };
};
```

Rules:

```txt
- popup, badge, logger, dashboard, and repair UI read the same normalized state.
- state changes are revisioned and evented.
- stale UI surfaces must show stale/refreshing, not pretend to be current.
- state explanations are privacy-redacted by default.
```

### Acceptance check

Tests force degraded DNR, policy-load failure, permission loss, disabled lists, and safe mode. Badge, popup, logger, dashboard, and repair UI must agree on the same effective state.

---

## P1.41 Add rule canonicalization and provenance-hash authority

### Problem

The project has dedupe, trust tiers, conflict resolution, and upstream semantic parity, but it still needs one canonical representation of a rule after parsing and before installation.

Without canonicalization:

```txt
- equivalent rules can receive different IDs or decisions.
- dedupe can occur before important condition fields are visible.
- diagnostics cannot reliably group the same logical rule across list updates.
- rollback cannot prove that the restored rule set is semantically identical.
- source provenance can be lost after transformation.
```

### Generalized fix

Add:

```txt
src/js/filtering/rule-canonical-form.ts
platform/chromium/js/rule-provenance.js
tools/check-rule-canonicalization.mjs
```

Canonical record:

```ts
type CanonicalRule = {
  semanticKind: "network" | "cosmetic" | "scriptlet" | "redirect" | "exception";
  normalizedCondition: object;
  normalizedAction: object;
  source: {
    listId: string;
    trustTier: string;
    lineHash: string;
  };
  semanticHash: string;
  installHash: string;
  risk: string;
};
```

Rules:

```txt
- dedupe uses canonical semantic hash, not ad-hoc string keys.
- diagnostics store hashes and provenance, not raw private content by default.
- DNR transaction rollback verifies canonical install hash sets.
- parser/compiler changes update canonicalization fixtures.
```

### Acceptance check

The check fails if DNR/cosmetic/scriptlet install paths bypass canonical form, or if two semantically equal rules produce different semantic hashes.

---

## P1.42 Add DOM marker and attribute namespace registry

### Problem

Content scripts and page tools often mark DOM nodes with attributes/classes/data fields. Without a namespace registry, extension-owned markers can collide with page attributes, other extensions, or old versions of this extension.

Risks:

```txt
- page CSS reacts to extension markers and changes layout.
- page JavaScript spoofs an extension marker.
- old content script markers remain after policy downgrade or extension update.
- picker/zapper/video/smart layers use inconsistent marker names.
- diagnostics expose marker names that let hostile pages infer internals.
```

### Generalized fix

Add:

```txt
src/js/runtime/dom-marker-registry.ts
platform/chromium/js/dom-marker-authority.js
tools/check-dom-marker-namespace.mjs
```

Rules:

```txt
- all DOM markers use one prefix and owner registry.
- mutation-capable decisions never trust page-existing marker attributes alone.
- marker writes require capability token and document key.
- marker cleanup runs on policy downgrade, navigation, teardown, and extension update.
- old marker versions are recognized and removed safely.
```

### Acceptance check

Adversarial fixtures pre-create marker-like attributes/classes. The extension must not treat them as trusted evidence or skip safety checks because of them.

---

## P1.43 Add picker/zapper transactional session boundary

### Problem

Element picker and zapper are interactive tools that can inspect, preview, hide, and commit changes. Existing user-intent tokens and rule-preview workflows cover dangerous actions broadly, but picker/zapper need a dedicated session model because they bridge extension UI, page overlay, DOM targeting, preview CSS, and rule creation.

### Generalized fix

Add:

```txt
src/js/element-tools/picker-session.ts
src/js/element-tools/zapper-session.ts
tools/check-element-tool-sessions.mjs
```

Session contract:

```ts
type ElementToolSession = {
  sessionId: string;
  tool: "picker" | "zapper";
  tabId: number;
  frameId: number;
  documentId: string;
  policyRevision: string;
  userIntentToken: string;
  previewMutations: string[];
  committedRuleIds: string[];
  expiresAt: number;
};
```

Rules:

```txt
- preview mutations are reversible and expire automatically.
- committed rules go through user-rule preview/commit/undo workflow.
- cross-frame selection requires target authority.
- page navigation cancels session and removes overlays.
- picker/zapper cannot call dashboard/logger/backup contracts.
```

### Acceptance check

Tests cover navigation during picker session, stale overlay cleanup, iframe target switching, preview rollback, and commit undo.

---

## P1.44 Add filter-list subscription lifecycle reconciliation

### Problem

Filter-list updates are covered, but subscription lifecycle is broader: lists can be selected, deselected, imported, renamed, disabled, removed from catalog, replaced by aliases, or fail for long periods.

Failure cases:

```txt
- stale rules from deselected lists remain installed.
- cache entries survive after a list is removed or replaced.
- imported list URL changes but keeps old trust decisions.
- catalog alias migration causes duplicate subscriptions.
- a list repeatedly fails and blocks unrelated working lists.
```

### Generalized fix

Add:

```txt
platform/chromium/js/filter-subscription-reconciler.js
config/filter-list-aliases.json
tools/check-filter-subscription-lifecycle.mjs
```

Rules:

```txt
- every installed rule set maps to active subscriptions by canonical list ID.
- deselected/removed lists trigger staged removal of their rules and cache.
- aliases migrate selected state once and record migration.
- persistent list failure downgrades that list, not the whole engine, unless no valid rules remain.
- imported-list identity includes normalized URL, trust tier, and user approval revision.
```

### Acceptance check

Tests simulate list removal, alias replacement, deselect/reselect, imported URL edit, long-failing remote list, and partial update success.

---

## P1.45 Add versioned user-data archive manifest

### Problem

Backup/restore/cloud schema gates control what can be written, but exported data also needs a versioned archive manifest so restores can be explained, migrated, partially imported, or rejected before any write happens.

### Generalized fix

Add:

```txt
src/js/data/user-data-archive.ts
config/user-data-archive.schema.json
tools/check-user-data-archive-manifest.mjs
```

Archive manifest:

```ts
type UserDataArchiveManifest = {
  archiveVersion: number;
  extensionVersion: string;
  createdAt: string;
  includedDomains: string[];
  sections: {
    settings: object;
    filters: object;
    whitelist: object;
    dynamicRules: object;
    diagnostics?: object;
  };
  privacyClasses: string[];
  redactions: string[];
  migrationTarget: string;
};
```

Rules:

```txt
- restore previews archive contents and risks before writing.
- incompatible archive sections can be skipped, not force whole restore failure.
- sensitive diagnostics are excluded unless explicitly requested.
- cloud sync may only use sections marked syncable.
- archive import creates a rollback snapshot.
```

### Acceptance check

Tests restore old archive versions, archives with unknown sections, partial imports, redacted diagnostic exports, and cloud-ineligible data.

---

## P2.22 Add multi-browser manifest/build parity matrix

### Problem

Browser capability profiles describe runtime differences, but the build and manifest surfaces also need parity checks. Chrome, Edge, Firefox MV3, dev builds, store builds, and test builds may need different permissions, service-worker fields, ruleset declarations, and web-accessible resources.

### Generalized fix

Add:

```txt
config/browser-build-matrix.json
tools/generate-browser-manifest.mjs
tools/check-browser-build-parity.mjs
```

Matrix dimensions:

```txt
browser family
manifest version target
store/dev/test channel
permission availability
DNR limits and feedback API availability
content script world support
userScripts/main-world availability
webRequest restrictions
static ruleset support
WAR semantics
```

### Acceptance check

Release CI generates or validates manifests for supported targets and fails if a runtime capability profile has no corresponding manifest/build profile.

---

## P2.23 Add dependency and toolchain provenance gate

### Problem

The project has many generated checks, build scripts, and package/runtime artifacts. A generalized release gate should prove not only that the extension source is safe, but that the toolchain and dependencies used to generate the shipped package are known and reproducible.

### Generalized fix

Add:

```txt
tools/check-toolchain-provenance.mjs
dist/build/certificate/toolchain-provenance.json
```

Certificate fields:

```txt
node/npm versions
lockfile hash
package manager
build script hashes
generated artifact hashes
dependency license/security summary
CI/local build source
release package hash
```

### Acceptance check

Release packaging fails if generated artifacts were built with an unknown toolchain, if lockfile/package metadata drift, or if generated files do not match their source inputs.

---

## P2.24 Add overlay visual containment regression suite

### Problem

Picker, zapper, video overlays, repair banners, logger panels, and diagnostic UI can affect page layout or be affected by page CSS. DOM/CSP safety and UI interaction policy do not fully prove visual containment.

### Generalized fix

Add fixtures for:

```txt
high z-index app shell
shadow DOM app
fullscreen video player
fixed headers/footers
CSS resets and hostile global styles
high-contrast mode
zoomed page
right-to-left layout
mobile viewport
nested iframes
```

Assertions:

```txt
- overlay does not permanently shift page layout.
- overlay is removable after teardown/navigation.
- page CSS cannot hide critical extension controls.
- extension CSS does not leak broad rules into the page.
- accessibility focus order remains valid while overlay is active.
```

### Acceptance check

Add visual/layout regression tests and fail if overlays cause persistent layout shift, inaccessible controls, or leaked CSS after teardown.

---

## P2.25 Add post-release rollback and incident artifact workflow

### Problem

The backlog covers release certificates and repair paths, but after a release ships, a generalized incident workflow is needed: identify what changed, what policy/ruleset/profile caused the issue, which rollback is safe, and what evidence should be attached to the next fix.

### Generalized fix

Add:

```txt
tools/generate-incident-template.mjs
tools/check-release-rollback-plan.mjs
docs/release/rollback-playbook.md
```

Incident artifact fields:

```txt
release version
changed manifest surfaces
changed policy profiles
changed rulesets/filter lists
changed runtime protocol
changed permissions/WAR
known compatibility debt
rollback options
safe-mode switch
diagnostic bundle schema
fixture to add before fix
```

### Acceptance check

Every release artifact includes a rollback plan and an incident template. A compatibility bug must be reproducible as a fixture before a new host exception or high-risk workaround is accepted.

## P0.48 Add restricted-scheme and opaque-origin policy

### Problem

The backlog already has effective-site authority, target authority, match-pattern compilation, and frame inheritance, but restricted schemes and opaque origins deserve a first-class policy. Extension code can encounter `about:blank`, `about:srcdoc`, `data:`, `blob:`, `filesystem:`, `file:`, `chrome:`, `edge:`, extension pages, sandboxed iframes, and inherited-origin documents. Treating these as ordinary HTTP(S) pages can create unsafe attribution, wrong parent inheritance, broken picker/zapper behavior, or accidental mutation of a document whose authority cannot be proven.

### Generalized fix

Add a restricted-scheme policy module:

```txt
src/js/runtime/document-origin-classifier.ts
src/js/runtime/restricted-scheme-policy.ts
config/restricted-schemes.json
tools/check-restricted-scheme-policy.mjs
```

Classify every document target into one of:

```txt
http-document
https-document
extension-document
file-document
browser-internal-document
opaque-origin-document
inherited-origin-document
sandboxed-document
blob-document
data-document
about-blank-document
about-srcdoc-document
unknown-document
```

Each class must define:

```txt
canInjectBootstrap
canInjectMainWorld
canRunCosmetic
canRunScriptlets
canRunVideoLayer
canMutateDom
canUseInheritedPolicy
requiresParentDocumentProof
requiresUserGesture
canSendDiagnostics
canUsePickerZapper
fallbackPolicyProfile
```

### Acceptance check

No runtime layer may decide by checking only `url.startsWith("http")` or by treating `about:blank` as automatically safe. Opaque-origin and inherited-origin documents must either prove parent authority or fall back to observe-only/no-op behavior.

## P0.49 Add web-accessible-resource MIME, embed, and navigation policy

### Problem

The backlog already requires web-accessible-resource ownership, but ownership alone is not enough. Extension resources have different risks depending on whether they are JavaScript, CSS, HTML, images, JSON, WASM, fonts, or internal data. A page embedding an extension HTML/JS/CSS resource is different from an extension page loading it intentionally. A registry should say not only "who owns this resource" but also how it may be loaded, embedded, navigated to, cached, and referenced.

### Generalized fix

Extend the WAR registry with a resource-delivery contract:

```txt
resource
owner
resourceType
expectedMime
mayBeLoadedByPage
mayBeNavigatedToDirectly
mayBeEmbeddedInFrame
mayBeLoadedByExtensionPage
mayBeLoadedByContentScript
requiresNonceOrToken
cachePolicy
cspPolicy
exposesInternals
releaseMode
```

Generate manifest exposure and tests from this registry. HTML resources should be especially strict: direct navigation, iframe embedding, and page-origin references should be denied unless explicitly intended.

### Acceptance check

CI fails if an exposed WAR item lacks MIME/embed/navigation policy. A page-owned fixture must not be able to load privileged extension HTML/JS/CSS resources unless the registry explicitly allows that use.

## P0.50 Add allow/exception rule authority, expiry, and provenance

### Problem

The backlog covers compatibility debt and DNR conflict resolution, but allow/exception rules need their own authority model. Whitelist entries, unbreak rules, temporary compatibility allowances, user-created exceptions, trusted-site modes, and emergency repair relaxations can all reduce blocking. These should not be permanent or invisible unless explicitly intended.

### Generalized fix

Create an allow/exception authority:

```txt
src/js/rules/allow-rule-authority.ts
config/allow-rule-classes.json
tools/check-allow-rule-authority.mjs
```

Every allow/exception source must declare:

```txt
source
scope
reason
owner
createdAt
expiresAt or permanentJustification
userVisibleLabel
affectedCapabilities
riskClass
precedence
provenanceHash
undoPath
```

Temporary exception classes must expire. Permanent exception classes must explain why they are permanent and be included in release review.

### Acceptance check

No allow rule, trusted-site relaxation, compatibility allowance, or repair downgrade can be installed without source, scope, reason, provenance, and expiry/permanent justification.

## P0.51 Add per-sender, per-document, and per-channel flood control

### Problem

The backlog has resource budgets and authenticated sender envelopes, but message/event flood control is a separate issue. A broken page, stale content script, hostile main-world bridge fixture, noisy logger, or repeated popup/dashboard refresh can flood the service worker with messages or channels even when each individual message is authenticated and schema-valid.

### Generalized fix

Add a central flood-control primitive:

```txt
src/js/runtime/flood-control.ts
config/runtime-rate-limits.json
tools/check-flood-control-wiring.mjs
```

Budget by:

```txt
sender extension page
sender document id
sender frame id
message type
channel id
capability id
policy revision
incognito/profile mode
```

Actions:

```txt
allow
coalesce
debounce
drop
quarantine sender
downgrade capability
open repair diagnostic
```

### Acceptance check

Mutation-capable and diagnostic-heavy messages must pass through flood control. A fixture that sends thousands of valid-looking messages cannot cause unbounded logs, DNR work, CSS injection, policy recomputation, or BroadcastChannel churn.

## P1.46 Add cloud and multi-device sync conflict resolution

### Problem

The backlog validates backup/restore/cloud paths, but cloud sync also needs conflict semantics. Two extension instances may modify settings, filter subscriptions, custom rules, whitelist entries, or UI state concurrently. Last-write-wins can lose user-authored rules or resurrect deleted entries.

### Generalized fix

Add a cloud sync conflict resolver:

```txt
src/js/storage/sync-conflict-resolver.ts
src/js/storage/sync-tombstones.ts
config/sync-merge-policies.json
tools/check-sync-conflict-policy.mjs
```

Define per data class:

```txt
merge strategy
identity key
tombstone behavior
conflict marker
user-visible resolution path
privacy class
backup inclusion
rollback path
```

Examples:

```txt
settings: precedence merge with source timestamps and schema version
filter subscriptions: set merge with tombstones and alias resolution
user filters: text conflict marker or explicit user choice
whitelist: scoped entry merge with tombstone support
cloud options: device-owned fields cannot overwrite another device name silently
```

### Acceptance check

Cloud pull/push cannot silently overwrite user-authored rules, resurrect deleted subscriptions, or merge incompatible schema versions without a visible conflict record and rollback path.

## P1.47 Add first-run, onboarding, and consent-state machine

### Problem

Many policies depend on what the extension is allowed to do: optional permissions, diagnostics, cloud sync, logger behavior, filter-list defaults, browser privacy settings, trusted user filters, and repair flows. The backlog covers these surfaces individually, but the project also needs one first-run/onboarding state machine so safe defaults are explicit before consent or configuration exists.

### Generalized fix

Add an onboarding/consent state machine:

```txt
src/js/runtime/onboarding-state.ts
src/js/runtime/consent-registry.ts
config/first-run-defaults.json
tools/check-consent-state-machine.mjs
```

Track:

```txt
firstRunComplete
minimumBlockingEnabled
optionalPermissionsExplained
filterListsChosen
cloudSyncEnabled
loggerDiagnosticsEnabled
trustedUserFiltersEnabled
privacySettingsMutationsAllowed
repairFlowSeen
profileMode
```

No high-risk feature should infer consent from a missing key.

### Acceptance check

A fresh profile, upgraded profile, imported backup, and reset profile all reach deterministic safe defaults. Missing consent keys must not enable diagnostics, cloud sync, trusted user filters, optional permissions, or browser privacy mutations.

## P1.48 Add third-party frame role classification before frame-level filtering

### Problem

Frame policy inheritance says how child frames inherit policy, but it does not fully answer what role a frame plays. A third-party frame can be an ad, payment widget, auth widget, embedded video, comments widget, editor, CAPTCHA, consent dialog, analytics frame, or ordinary content. The same network/cosmetic/scriptlet action has different risk depending on frame role.

### Generalized fix

Add frame role classification:

```txt
src/js/runtime/frame-role-classifier.ts
config/frame-role-policy.json
tests/fixtures/frame-roles/
```

Frame roles:

```txt
ad-frame
video-frame
auth-frame
payment-frame
captcha-frame
consent-frame
editor-frame
comments-frame
analytics-frame
content-frame
unknown-third-party-frame
same-site-frame
extension-owned-frame
```

Frame role should feed into policy snapshots, target authority, DOM traversal boundaries, DNR attribution, diagnostics, and picker/zapper session rules.

### Acceptance check

Unknown third-party frames default to conservative policy. Auth/payment/CAPTCHA/consent frames cannot receive generic cosmetic, synthetic click, response-mutation, or main-world bridge authority unless explicit evidence and user intent exist.

## P1.49 Add shipped-resource integrity and cache-busting manifest

### Problem

Dependency provenance covers build inputs, and release reproducibility covers artifacts, but runtime code still needs a simple way to know which shipped resources belong to the current extension package. Generated assets, policy profiles, browser capability configs, static rulesets, web-accessible resources, HTML pages, CSS, and JS bundles can drift or be cached in unexpected combinations during development or extension update.

### Generalized fix

Generate a shipped-resource manifest:

```txt
dist/build/shipped-resources.json
platform/chromium/js/resource-integrity.js
tools/generate-shipped-resource-manifest.mjs
tools/check-shipped-resource-integrity.mjs
```

Each resource records:

```txt
path
kind
hash
buildId
schemaVersion
owner
releaseMode
loadedByManifest
webAccessible
requiredByPolicy
```

Runtime should be able to compare build IDs for service worker, content scripts, generated configs, and extension pages. Development can warn; release can fail closed or repair.

### Acceptance check

A mismatched generated config, stale content script bundle, or missing static ruleset must be detected as a package/state inconsistency rather than producing silent mixed-version behavior.

## P2.26 Add restricted-scheme and opaque-origin regression corpus

### Problem

Restricted-scheme policy will be easy to regress because these pages are hard to reproduce manually.

### Generalized fix

Add synthetic fixtures for:

```txt
about:blank inherited from HTTP parent
about:srcdoc sandboxed iframe
blob: iframe from app shell
data: iframe
file: URL if permission exists
chrome-extension: page
browser-internal blocked page mock
sandboxed iframe with null origin
nested opaque-origin frame
```

### Acceptance check

Fixtures prove that injection, mutation, diagnostics, picker/zapper, and policy inheritance either work with proven authority or fall back to no-op/observe-only behavior.

## P2.27 Add web-accessible-resource abuse regression corpus

### Problem

WAR exposure bugs are often found by pages embedding or navigating to resources in ways developers did not intend.

### Generalized fix

Add adversarial fixtures that try to:

```txt
iframe extension HTML pages
load extension JS from page script tags
load extension CSS into hostile page context
fetch JSON/internal config resources
reuse picker/zapper resources outside a session
cache stale resource URLs across extension updates
probe resource existence as fingerprinting signal
```

### Acceptance check

The corpus must prove that WAR resources are minimized, typed, intentionally embeddable only when required, and not usable as an authority bypass.

## P2.28 Add cloud sync conflict regression suite

### Problem

Cloud conflicts are rare in manual testing but damaging when they occur.

### Generalized fix

Add tests simulating:

```txt
two devices editing user filters
one device deleting a subscription while another edits it
schema upgrade on one device before another syncs
backup import followed by cloud pull
conflicting whitelist edits
cloud disabled then re-enabled with stale data
incognito/profile-mode cloud isolation
```

### Acceptance check

Every conflict either merges safely, creates a user-visible conflict record, or preserves both versions with rollback. Silent data loss fails the suite.

## P2.29 Add message and channel flood adversarial tests

### Problem

Authenticated messages can still be used badly if rate limits are missing.

### Generalized fix

Add adversarial tests for:

```txt
popup refresh loop
logger stream flood
content script message storm
BroadcastChannel replay storm
main-world bridge valid nonce flood
stale runtime repeated repair requests
picker/zapper session message spam
```

### Acceptance check

Flood fixtures must not cause unbounded memory, logs, style injection, DNR updates, policy recomputation, channel creation, or browser API calls.

## P2.30 Add third-party frame role regression corpus

### Problem

Frame-role mistakes can either break real applications or miss embedded ads.

### Generalized fix

Add fixtures for:

```txt
ad iframe inside article
YouTube/video iframe inside app shell
payment iframe inside checkout
login iframe inside app shell
CAPTCHA iframe
consent-management iframe
comments iframe
rich editor iframe
analytics-only iframe
unknown third-party iframe
```

### Acceptance check

Frame-role classification must choose conservative policy for sensitive roles while still allowing evidence-backed ad/video handling in non-sensitive frames.

## P0.52 Add request initiator-chain authority for network decisions

### Problem

Network decisions can be wrong when they look mostly at the requested URL or tab hostname. A request can be caused by a top document, a nested frame, a worker, a media playlist, a redirect, a prefetch, a beacon, an extension page, or a page-created script. Treating these as the same context creates both breakage and missed blocking.

### Generalized fix

Create a request initiator-chain authority:

```txt
src/js/runtime/request-context-authority.ts
platform/chromium/js/request-context-authority.js
tools/check-request-context-authority.mjs
tests/request-context-authority/
```

Every network-facing decision should receive a normalized context:

```ts
type RequestContext = {
  requestId: string;
  tabId: number;
  frameId: number;
  documentId?: string;
  requestUrl: string;
  requestOrigin: string | null;
  initiatorOrigin: string | null;
  topOrigin: string | null;
  frameOrigin: string | null;
  resourceType: CanonicalResourceType;
  loadContext: CanonicalLoadContext;
  redirectDepth: number;
  isUserInitiated: boolean;
  isExtensionInitiated: boolean;
  policyRevision: string;
};
```

Rules:

```txt
- DNR install decisions, logger entries, redirect/surrogate decisions, allow rules, and diagnostics must use RequestContext.
- Top-document identity and request-target identity must not be collapsed into one string.
- Initiator-less requests must be explicitly classified, not guessed from active tab.
- Redirect chains must preserve both original and current context.
- Extension-origin requests must be separated from page-origin requests.
```

### Acceptance check

CI must fail if network policy, logger attribution, redirect/surrogate logic, or compatibility matching derives authority from only request URL, active tab URL, or hostname.

## P0.53 Add a canonical resource-type and load-context taxonomy

### Problem

Browser APIs, DNR, WebRequest, filter syntax, HTML elements, JavaScript APIs, media manifests, and workers do not use exactly the same resource categories. Without one taxonomy, the extension can block a resource as one type, log it as another, and apply policy as a third.

### Generalized fix

Add one resource/load-context compiler:

```txt
src/js/runtime/resource-context.ts
config/resource-context-taxonomy.json
tools/check-resource-context-taxonomy.mjs
tests/resource-context-taxonomy/
```

Canonical dimensions:

```txt
main_document
sub_document
script
module_script
worker
shared_worker
service_worker
worklet
stylesheet
font
image
media
media_manifest
websocket
webtransport
eventsource
fetch
xhr
beacon
ping
preflight
prefetch
prerender
other
```

Load context should also capture:

```txt
tag/API source
parser-created vs script-created
user-initiated vs background
visible document vs hidden/prerendered
top-level vs frame vs worker
extension-origin vs page-origin
```

### Acceptance check

DNR conversion, WebRequest instrumentation, logger display, policy resolver, rule simulator, and diagnostics must map through the same taxonomy. Fixtures must prove no ad-hoc string comparisons for request types remain in high-risk paths.

## P0.54 Add feature-flag, experiment, and kill-switch authority

### Problem

Release-feature pruning proves that dev/test behavior is not accidentally shipped, but it does not fully control runtime feature flags, experiments, emergency disables, or temporary compatibility toggles. A generalizing extension needs one authority for staged activation and fast rollback.

### Generalized fix

Create a feature-flag authority:

```txt
config/feature-flags.json
src/js/runtime/feature-flag-authority.ts
platform/chromium/js/feature-flag-authority.js
tools/check-feature-flag-authority.mjs
```

Each flag must declare:

```ts
type FeatureFlag = {
  id: string;
  owner: string;
  defaultState: "off" | "observe-only" | "on";
  allowedInRelease: boolean;
  policyProfiles: string[];
  requiredCapabilities: string[];
  expiresAt?: string;
  killSwitch?: boolean;
  rollout?: "none" | "local-dev" | "manual" | "stable";
  reason: string;
  fixtures: string[];
};
```

Rules:

```txt
- Temporary flags require expiry.
- Kill switches must downgrade safely and invalidate active policy snapshots.
- Experiments cannot enable mutation-capable behavior without policy/capability coverage.
- Release builds fail if dev-only or expired flags remain active.
```

### Acceptance check

A check must fail when a shipped runtime branch depends on an undeclared feature flag, when a temporary flag is expired, or when a kill switch does not cancel tokens and active layers.

## P0.55 Add redirect and surrogate target integrity policy

### Problem

Redirect and surrogate behavior is more dangerous than simple blocking because it replaces a network target with another target. The project already needs a general network mutation authority, but redirect/surrogate targets also need MIME, origin, cache, CSP, and semantic compatibility checks.

### Generalized fix

Create a redirect/surrogate target authority:

```txt
src/js/runtime/redirect-target-authority.ts
config/redirect-surrogate-targets.json
tools/check-redirect-target-integrity.mjs
tests/redirect-target-integrity/
```

Each target must declare:

```ts
type RedirectTarget = {
  id: string;
  owner: string;
  sourceRuleClasses: string[];
  targetUrl: string;
  targetOrigin: "extension" | "same-origin" | "trusted-static";
  expectedMime: string;
  allowedResourceTypes: CanonicalResourceType[];
  cachePolicy: "immutable" | "versioned" | "no-store";
  integrityHash: string;
  cspExpectations: string[];
  rollback: "block" | "allow" | "degraded-allow";
};
```

Rules:

```txt
- Redirect/surrogate targets must be extension-owned or explicitly trusted.
- MIME/type must match the request context.
- Surrogates must not be generic JavaScript placeholders unless policy allows that exact class.
- Failed integrity or MIME checks must downgrade to block/allow according to policy, not fall through silently.
```

### Acceptance check

CI must fail if a redirect/surrogate rule can point to a target without declared owner, resource-type compatibility, MIME expectation, integrity hash, and rollback behavior.

## P1.50 Add non-window execution-context policy

### Problem

Modern pages run logic outside ordinary windows and iframes: workers, shared workers, service workers, worklets, offscreen documents, prerendered pages, fenced frames, anonymous iframes, and media pipelines. Page-profile and frame-policy logic can miss these contexts or accidentally inherit unsafe policy.

### Generalized fix

Add a non-window context policy:

```txt
src/js/runtime/execution-context-policy.ts
config/execution-context-policy.json
tools/check-execution-context-policy.mjs
tests/execution-context-policy/
```

Classify:

```txt
window document
about:blank inherited document
sandboxed iframe
anonymous iframe
fenced frame
prerendered document
worker
shared worker
service worker
worklet
offscreen document
media pipeline request
extension page
```

Rules:

```txt
- Mutation-capable DOM layers can only run in document contexts.
- Network/logging policy must distinguish worker-initiated and document-initiated requests.
- Hidden/prerendered contexts should default to observe-only or no mutation until activation.
- Extension pages must not inherit page filtering policy.
```

### Acceptance check

Fixtures must prove workers, worklets, prerendered pages, fenced frames, anonymous iframes, and extension pages cannot receive unsafe DOM, scriptlet, bridge, picker/zapper, or UI-interaction capability by inheritance.

## P1.51 Add extension co-residency and foreign-interference diagnostics

### Problem

Users can run multiple blockers, privacy extensions, password managers, script injectors, VPN helpers, or browser content settings at the same time. Failures can then be caused by another extension or browser setting, but the extension may misattribute the breakage to its own filters or repeatedly apply unsafe repair.

### Generalized fix

Add co-residency diagnostics that do not spy on other extensions but detect observable interference safely:

```txt
src/js/runtime/co-residency-diagnostics.ts
platform/chromium/js/co-residency-diagnostics.js
tools/check-co-residency-diagnostics.mjs
tests/co-residency-diagnostics/
```

Signals:

```txt
DNR rule install failure due to quota already consumed
unexpected content-security or header changes
DOM markers/styles not owned by this extension
blocked extension resources
browser content setting disables required API
permission/API present in manifest but unavailable at runtime
page already contains known blocker bait state before uBR acts
```

Rules:

```txt
- Diagnostics must not enumerate other extensions or collect their IDs.
- Foreign interference should downgrade to explanation/repair, not unsafe escalation.
- Runtime health should distinguish own failure, browser limitation, and external interference.
```

### Acceptance check

Regression fixtures must simulate quota exhaustion, blocked extension resources, foreign DOM styles, and disabled APIs. The extension must report the cause without leaking other extension identities.

## P1.52 Add user-input preservation policy for DOM, CSS, and UI mutations

### Problem

Ad blockers can accidentally hide, remove, click, focus, scroll, or restyle elements that contain user input or live editing state. App-safe selectors and UI interaction safety help, but there should be a specific invariant: never lose user-entered state.

### Generalized fix

Add a user-input preservation policy:

```txt
src/js/runtime/user-input-preservation.ts
tools/check-user-input-preservation.mjs
tests/user-input-preservation/
```

Protected state:

```txt
focused element
text selection
input/textarea value
contenteditable contents
form state
file picker state
media playback position
draft/editor dirty state
composition/IME state
drag/drop state
pointer capture state
```

Rules:

```txt
- DOM removal/hiding/click/focus/keyboard/scroll mutations must check protected state first.
- Mutation journals must record enough to undo visible/style mutations, but must not store private input values.
- Element picker/zapper preview must not remove active input/editing state unless the user explicitly confirms a targeted element.
- Generic cosmetics must not hide focused/editable elements.
```

### Acceptance check

Tests must prove filter application, picker/zapper, video skip actions, synthetic clicks, and cosmetic cleanup cannot erase or obscure focused inputs, rich-text editors, form drafts, media playback state, or IME composition.

## P1.53 Add redirect-chain, preflight, and CORS-safe network mutation policy

### Problem

Blocking, redirecting, upgrading, or replacing resources can interact badly with redirect chains, CORS preflight, credentials, service-worker interception, module scripts, and media manifests. A target may look safe in isolation but break the request chain semantics.

### Generalized fix

Extend network mutation policy with chain-aware rules:

```txt
src/js/runtime/network-chain-policy.ts
config/network-chain-policy.json
tools/check-network-chain-policy.mjs
tests/network-chain-policy/
```

Policy should account for:

```txt
redirect count and original URL
preflight request and actual request pairing
credentials mode
CORS mode
module/classic script distinction
service-worker interception
media manifest segment chains
upgrade/insecure-request behavior
surrogate substitution
```

Rules:

```txt
- Do not redirect preflight independently from the actual request.
- Do not surrogate a credentialed/API request unless explicitly safe.
- Do not convert a CORS-sensitive script/API request into an extension-resource response unless target policy allows it.
- Media manifest and segment decisions must stay consistent across the chain.
```

### Acceptance check

Fixtures must cover preflight + API request, redirect loops, module scripts, credentialed XHR/fetch, service-worker-controlled pages, media manifests, and extension-resource surrogates.

## P1.54 Add policy snapshot diff and disruptive-change preview

### Problem

Changing filters, settings, permissions, compatibility metadata, or profile classification can suddenly change many runtime decisions. The project has policy revisions and explanations, but it also needs a structured diff so disruptive changes are visible before or immediately after they apply.

### Generalized fix

Add a policy snapshot diff engine:

```txt
src/js/runtime/policy-snapshot-diff.ts
platform/chromium/js/policy-snapshot-diff.js
tools/check-policy-diff-coverage.mjs
tests/policy-snapshot-diff/
```

Diff categories:

```txt
network mode changed
cosmetic mode changed
scriptlet/main-world changed
video mutation changed
permission unavailable
filter-list changed
compatibility exception changed
safe mode entered/exited
profile reclassified
feature flag/kill switch changed
```

Rules:

```txt
- Disruptive changes must produce reason-coded diffs.
- UI can show what changed without exposing private page data.
- Runtime can cancel or reissue tokens based on diff severity.
- Rollback can refer to previous policy snapshot hash.
```

### Acceptance check

Every policy revision caused by settings, filter-list update, permissions, feature flags, compatibility metadata, safe mode, and classifier changes must produce a bounded, privacy-preserving diff.

## P1.55 Add filter-rule cost model and compile-time risk budgeting

### Problem

Runtime resource budgets limit work after activation, but expensive or risky rule sets should be recognized before they are installed or stored. A filter list can contain many rules that are individually valid but collectively expensive, fragile, or likely to break apps.

### Generalized fix

Add a compile-time rule cost model:

```txt
src/js/filters/rule-cost-model.ts
platform/chromium/js/rule-cost-model.js
config/rule-cost-budget.json
tools/check-rule-cost-model.mjs
tests/rule-cost-model/
```

Cost dimensions:

```txt
selector complexity
procedural selector risk
regex complexity
broad substring match
resource-type breadth
third-party/domainType ambiguity
first-party mutation risk
redirect/surrogate risk
domain scope breadth
exception/allow broadness
list trust tier
```

Rules:

```txt
- Compile output must include cost/risk summary by source list and rule class.
- Untrusted lists get lower high-risk budgets.
- High-cost rules can be rejected, downgraded to observe-only, or require user/trusted-list authority.
- Cost summaries feed diagnostics and release certificates.
```

### Acceptance check

A pathological but syntactically valid list must fail or downgrade before installation. CI must prove cost budgeting happens before DNR, cosmetic, scriptlet, redirect, or surrogate rules become active.

## P2.31 Add request initiator-chain regression corpus

### Problem

Request-context bugs are hard to catch with simple URL fixtures because the same URL can be safe or unsafe depending on the initiator chain.

### Generalized fix

Add fixtures for:

```txt
main-frame request
third-party iframe request
nested iframe request
worker-initiated fetch
module script import
media playlist and segment
beacon/ping
prefetch/prerender
redirect chain
extension-origin request
initiator-less browser request
```

### Acceptance check

Policy, logger, DNR decision records, compatibility matching, and diagnostics must agree on the same normalized request context.

## P2.32 Add resource-type/load-context parity corpus

### Problem

Resource-type drift can silently break blocking quality or app safety.

### Generalized fix

Build a parity corpus that feeds the same fixture into:

```txt
filter parser
DNR compiler
WebRequest mapper
logger renderer
policy resolver
simulator
diagnostic bundle generator
```

### Acceptance check

Every layer must assign the same canonical resource type and load context, or explicitly record a safe deviation.

## P2.33 Add extension co-residency and foreign-interference harness

### Problem

Co-residency problems usually appear only after real users combine extensions and browser settings.

### Generalized fix

Create a harness that simulates:

```txt
DNR quota already consumed
browser API throws permission/unavailable errors
foreign stylesheet hides extension overlay
extension resource blocked by page/browser policy
content setting blocks scripts/cookies/popups
another actor removes uBR DOM markers or styles
```

### Acceptance check

The extension must classify these as external/interference/limitation states, avoid unsafe escalation, and show repair/explanation where possible.

## P2.34 Add feature-flag expiry and kill-switch release audit

### Problem

Feature flags and emergency kill switches become dangerous if they remain undocumented or active forever.

### Generalized fix

Add a release audit that produces:

```txt
active flags
expired flags
kill switches
mutation-capable flags
profile-limited flags
flags without fixtures
flags without owner/reason
flags that change manifest/runtime behavior
```

### Acceptance check

Release builds must fail if expired, ownerless, fixture-less, or mutation-capable experimental flags are active without explicit release approval.


## P0.56 Add cold-start hydration barrier and startup event queue

### Problem

MV3 service workers can be awakened by many event types while startup state is still incomplete:

```txt
runtime messages
commands
context-menu clicks
webRequest events
webNavigation events
alarms/timers
popup/dashboard/logger requests
filter-list update triggers
content-script handshake requests
```

A startup sequencer defines order, but each event handler still needs a shared answer to this question:

```txt
Is the service worker hydrated enough to make this decision safely?
```

Without a hydration barrier, a mutation-capable event can run while policy profiles, whitelist state, DNR readiness, compatibility debt, storage schema, runtime health, or permission state is still stale or unloaded.

### Generalized fix

Add:

```txt
platform/chromium/js/startup-hydration-gate.js
```

Core API:

```js
beginHydration(reason)
markHydrated(component, metadata)
markHydrationFailed(component, error)
awaitHydration({ component, eventType, sensitivity, timeoutMs })
queueUntilHydrated(eventEnvelope)
rejectUntilHydrated(eventEnvelope, reason)
getHydrationSnapshot()
```

Event sensitivity:

```txt
safe-read: may return stale-but-labeled state
diagnostic-read: may return partial state with warnings
mutation-low: waits for hydration or rejects
mutation-high: rejects until policy/storage/permission/DNR are hydrated
network-mutation: rejects until DNR and policy are hydrated
ui-mutation: waits for document authority and policy snapshot
```

Rules:

```txt
- Read-only UI may show partial state, but must label it as partial.
- Mutation-capable messages cannot run before required components are hydrated.
- Queued events carry an epoch and expire if startup takes too long.
- Hydration failure enters a typed repair/degraded state instead of continuing silently.
- A new service-worker epoch invalidates queued stale events from an older epoch.
```

### Acceptance check

Add:

```txt
tools/check-startup-hydration-gate.mjs
tests/runtime/startup-hydration-gate.spec.ts
```

The check fails if:

```txt
- mutation-capable message handlers do not await or reject on hydration.
- DNR updates can run before DNR state is hydrated.
- content-script activation can run before policy profiles are loaded.
- context-menu clicks can launch picker/zapper before target authority is ready.
- hydration failure leaves the extension in an unlabeled partial state.
```

---

## P0.57 Add partitioned storage and network-context authority

### Problem

The project already distinguishes profiles, frames, initiators, incognito/private modes, and request context. It still needs one authority for modern browser partitioning semantics:

```txt
top-level site
frame site
initiator site
request site
storage partition
cookie partition
third-party cookie blocking state
private/incognito storage separation
sandboxed/opaque partition behavior
```

Ad blockers can make wrong choices when a third-party frame is treated as if it shares first-party storage or cookies with the top page, or when diagnostic/storage state crosses profile/partition boundaries accidentally.

### Generalized fix

Add:

```txt
src/js/runtime/partition-context.ts
platform/chromium/js/partition-context.js
```

Canonical context:

```ts
type PartitionContext = {
  topLevelSite: string;
  frameSite: string;
  initiatorSite: string;
  requestSite: string;
  effectiveSite: string;
  thirdParty: boolean;
  profileMode: "normal" | "incognito" | "private" | "managed";
  storagePartitionKey: string;
  cookiePartitionKey: string;
  opaque: boolean;
  sandboxed: boolean;
};
```

Use it in:

```txt
policy resolution
DNR rule risk classification
cookie/header/CSP mutation authority
logger grouping
diagnostic bundle redaction
cloud/backup eligibility
runtime health partitioning
frame-role classification
```

### Acceptance check

Add:

```txt
tools/check-partition-context-usage.mjs
tests/runtime/partition-context.spec.ts
```

The check fails if:

```txt
- code makes third-party/first-party decisions from hostname alone.
- incognito/private partition keys can share diagnostics with normal mode.
- cookie/header mutation does not receive partition context.
- logger grouping can collapse unrelated top-level-site partitions.
```

---

## P0.58 Add browser file-transfer, clipboard, and download authority

### Problem

The project now covers backup/restore, user-data archive manifests, cloud sync, extension-page DOM safety, and user-intent tokens. A separate browser side-effect surface remains:

```txt
download/export files
file picker/import files
clipboard read/write
drag-and-drop import
copy diagnostic bundle
copy rule/explanation text
save backup/archive
```

These operations cross a trust boundary between extension state and the user filesystem or clipboard. They need the same authority model as navigation, storage, and UI mutations.

### Generalized fix

Add:

```txt
platform/chromium/js/file-transfer-authority.js
src/js/runtime/file-transfer-policy.ts
```

Operation envelope:

```ts
type FileTransferRequest = {
  operation: "import" | "export" | "download" | "clipboard-read" | "clipboard-write" | "drag-drop";
  sourceRoute: "popup" | "dashboard" | "logger" | "options" | "repair";
  dataClass: "user-rules" | "backup" | "diagnostic" | "settings" | "compatibility-report";
  privacyClass: "public" | "local-sensitive" | "private";
  userIntentToken: string;
  filename?: string;
  mime?: string;
  schemaVersion?: string;
};
```

Rules:

```txt
- Import is always staged, schema-checked, previewed, and reversible.
- Export applies redaction rules based on privacy class.
- Clipboard write requires recent user intent and route authority.
- Clipboard read is disabled unless a route explicitly owns it.
- Download filenames and MIME types are generated by policy, not user payload.
- Diagnostic exports include a manifest of omitted/redacted fields.
```

### Acceptance check

Add:

```txt
tools/check-file-transfer-authority.mjs
tests/ui/file-transfer-authority.spec.ts
```

The check fails if:

```txt
- extension pages call download/clipboard/import APIs directly.
- backup or diagnostic export lacks a manifest and privacy class.
- import paths write storage before staged validation.
- clipboard write can run without fresh user intent.
```

---

## P1.56 Add offline, captive-portal, and retry/backoff authority

### Problem

The project fetches remote or bundled list content, syncs cloud-like data, loads local extension resources, and may retry work after startup or update failures. A generic failure taxonomy is useful, but network availability and retry behavior need a separate owner.

Failure cases:

```txt
- captive portal returns HTML where a filter list was expected.
- offline mode causes repeated failed fetches and noisy logs.
- retries stampede after service-worker restart.
- stale cached lists are discarded too aggressively.
- cloud sync and filter-list update retries race with user edits.
- failed remote fetches are treated as parser failures instead of network-state failures.
```

### Generalized fix

Add:

```txt
platform/chromium/js/network-retry-authority.js
src/js/runtime/network-availability.ts
```

Policy dimensions:

```txt
network state: online | offline | captive-portal-suspected | metered | unknown
resource class: filter-list | cloud-sync | bundled-resource | diagnostics-upload | update-check
retry class: no-retry | fixed | exponential | user-triggered-only
fallback: use-last-good | use-bundled | degraded-allow | disable-feature | ask-user
```

Rules:

```txt
- Filter-list fetches validate MIME/content shape before parser handoff.
- Captive portal HTML never becomes cached filter-list content.
- Retry state is keyed by source, profile mode, resource class, and epoch.
- Retry backoff survives service-worker restart without unbounded growth.
- User edits cancel stale sync/update retries that would overwrite them.
```

### Acceptance check

Add:

```txt
tools/check-network-retry-authority.mjs
tests/runtime/network-retry-authority.spec.ts
```

The check fails if:

```txt
- fetch paths implement their own retry/backoff timers.
- remote filter list parser accepts captive-portal HTML as a normal list.
- retries are not cancelled by newer user settings or subscription state.
- offline state produces repeated immediate retries.
```

---

## P1.57 Add local metrics, counters, and privacy-budgeted telemetry schema

### Problem

The project has runtime health, decision explanations, diagnostic bundles, retention policies, and logger/privacy work. It still needs a single schema for local counters and metrics so every feature does not invent its own tracking shape.

Examples:

```txt
DNR install counts
filter-list compile costs
policy downgrade counts
safe-mode entries
capability denials
message floods
bridge rejections
hydration failures
retry/backoff state
UI repair actions
```

These are useful for debugging, but they can become privacy-sensitive if keyed by raw host, URL, rule text, document title, user rule text, or stable identifiers.

### Generalized fix

Add:

```txt
src/js/runtime/local-metrics-schema.ts
platform/chromium/js/local-metrics.js
```

Metric shape:

```ts
type LocalMetric = {
  name: string;
  owner: string;
  privacyClass: "aggregate" | "profile-local" | "sensitive";
  dimensions: Record<string, string>;
  count: number;
  firstSeen: number;
  lastSeen: number;
  ttlMs: number;
  exportable: boolean;
};
```

Rules:

```txt
- Metrics are aggregate by default.
- Raw URL, query string, page text, form values, and rule text are forbidden dimensions.
- Host/site dimensions must be hashed or reduced to declared buckets unless in developer mode.
- Metrics have TTLs and deletion hooks.
- Diagnostic export includes metric schema, not raw sensitive dimensions.
```

### Acceptance check

Add:

```txt
tools/check-local-metrics-schema.mjs
tests/privacy/local-metrics-schema.spec.ts
```

The check fails if:

```txt
- feature code writes ad-hoc metric objects to storage.
- metric dimensions include URLs, query strings, page text, or form values.
- metrics lack owner, privacy class, TTL, and export policy.
- diagnostic bundles can export sensitive metrics by default.
```

---

## P1.58 Add layout-read and computed-style budget authority

### Problem

Mutation safety is not only about writes. Repeated reads can also break performance and user experience:

```txt
getComputedStyle
getBoundingClientRect
offsetWidth/offsetHeight
scrollHeight/scrollWidth
elementFromPoint
computed style traversal
animation/transition probing
layout-dependent selector evaluation
```

These can force layout, thrash complex app shells, drain battery on video pages, and create timing-sensitive failures even when no DOM node is removed.

### Generalized fix

Add:

```txt
src/js/runtime/layout-read-budget.ts
platform/chromium/js/layout-read-authority.js
```

Budget dimensions:

```txt
per document
per frame
per runtime layer
per policy profile
per event loop tick
per second/minute
per selector evaluation
per user-triggered tool session
```

Rules:

```txt
- App-shell/auth/payment profiles get stricter layout-read budgets.
- Video/player adapters get separate media-aware budgets.
- Picker/zapper may get temporary user-intent-expanded budgets.
- Exceeding budget downgrades to observe-only or delays work.
- Layout reads are counted separately from DOM traversal and DOM mutation.
```

### Acceptance check

Add:

```txt
tools/check-layout-read-authority.mjs
tests/perf/layout-read-budget.spec.ts
```

The check fails if:

```txt
- runtime code calls layout-forcing APIs outside a budget wrapper.
- app-shell profiles can run unbounded computed-style scans.
- picker/zapper expanded budgets do not expire.
- layout-read budget violations do not downgrade or back off work.
```

---

## P1.59 Add CSS cascade, layer, and animation conflict policy

### Problem

The backlog now includes CSS injection ownership, selector risk, overlay containment, and user-input preservation. A remaining CSS-specific issue is cascade conflict:

```txt
injection order
CSS cascade layers
!important rules
animation/transition side effects
z-index and stacking contexts
pointer-events changes
visibility/display/opacity differences
style removal order
interaction with page CSS resets
```

Without a cascade policy, two safe-looking style injections can combine into a broken page or an unrecoverable overlay/picker state.

### Generalized fix

Add:

```txt
src/js/runtime/css-cascade-policy.ts
platform/chromium/js/css-cascade-authority.js
```

Policy fields:

```txt
owner
cascadeLayer
insertionOrder
allowedProperties
forbiddenProperties
importantAllowed
animationAllowed
transitionAllowed
pointerEventsAllowed
zIndexPolicy
cleanupOrder
profileLimit
```

Rules:

```txt
- Extension CSS uses declared cascade layers, not ad-hoc style tags.
- High-risk properties require policy and owner justification.
- Picker/zapper overlay CSS is isolated from cosmetic-filter CSS.
- User-authored cosmetic CSS is separated from extension UI CSS.
- CSS removal follows reverse dependency order.
```

### Acceptance check

Add:

```txt
tools/check-css-cascade-policy.mjs
tests/ui/css-cascade-conflict.spec.ts
```

The check fails if:

```txt
- injected CSS lacks owner and cascade layer.
- extension UI CSS shares a layer with user/filter cosmetic CSS.
- high-risk properties are allowed without policy.
- cleanup can remove a lower-level dependency before its dependent overlay/style.
```

---

## P2.35 Add cold-start, suspension, and hydration chaos harness

### Problem

The project has replay, lifecycle, and long-run stability tests. It still needs a focused chaos harness for MV3 service-worker behavior:

```txt
worker cold start
worker suspension between async steps
startup interrupted by message storm
policy profile fetch delayed
storage get/set failure during hydration
DNR API temporarily unavailable
context-menu creation failure then retry
content script messages from old worker epoch
```

### Generalized fix

Create:

```txt
tests/chaos/mv3-cold-start-hydration.spec.ts
tools/run-mv3-chaos-harness.mjs
```

The harness should inject:

```txt
slow storage
slow policy-profile load
API transient failures
worker epoch changes
message reordering
navigation while queued
permission loss mid-hydration
DNR failure mid-install
```

### Acceptance check

The harness passes only if:

```txt
- unsafe events cannot bypass hydration.
- stale queued events expire or are rejected.
- startup failures produce typed repair/runtime-health state.
- retry succeeds after transient context-menu/DNR/storage failures.
- no duplicate listeners, menus, channels, tokens, or runtime layers remain after recovery.
```

---

## P2.36 Add offline, captive-portal, and retry regression corpus

### Problem

Remote fetches and sync-like operations need fixtures that simulate network realities, not only parser realities.

### Generalized fix

Create fixtures for:

```txt
offline filter-list update
captive portal HTML returned as list content
HTTP 204/304/404/500 handling
redirect loop
large compressed response
wrong MIME type
slow response timeout
cloud conflict during offline-to-online transition
bundled fallback after remote failure
last-good cache restore
```

### Acceptance check

Add:

```txt
tests/network/offline-retry-corpus.spec.ts
```

The corpus must prove:

```txt
- captive portal content is rejected before parser/cache.
- last-good lists are retained on transient failure.
- retry state backs off and does not stampede after worker restart.
- user subscription edits cancel stale retry commits.
```

---

## P2.37 Add partitioned-context and storage-isolation corpus

### Problem

Partitioned storage/network context needs regression fixtures across combinations that normal unit tests rarely cover.

### Generalized fix

Create fixtures for:

```txt
same frame URL under different top-level sites
third-party iframe with blocked cookies
sandboxed iframe with opaque origin
about:blank inherited frame
incognito/private profile start
normal and private windows open together
cloud disabled in private mode
diagnostics generated in private mode
user filter import in one profile mode only
```

### Acceptance check

Add:

```txt
tests/privacy/partitioned-context-corpus.spec.ts
```

The corpus must prove:

```txt
- policy decisions include top-level site and frame site.
- diagnostics and metrics do not cross profile/partition modes.
- cookie/header mutation authority receives partition context.
- logger grouping does not collapse unrelated partitions.
```

---

## P2.38 Add file-transfer and clipboard adversarial corpus

### Problem

Backup/import/export/clipboard paths can quietly become data-leak or state-corruption surfaces.

### Generalized fix

Create fixtures for:

```txt
malformed backup archive
oversized diagnostic export
backup with unknown storage keys
backup with private diagnostics
clipboard write without user gesture
clipboard read attempt from unowned route
filename injection
wrong MIME type
partial import failure
undo after import
```

### Acceptance check

Add:

```txt
tests/ui/file-transfer-adversarial.spec.ts
```

The corpus must prove:

```txt
- imports stage and preview before writing.
- unknown keys are rejected or quarantined.
- exports redact by privacy class.
- clipboard operations require route authority and fresh user intent.
- partial import can be rolled back.
```

---

## P0.59 Add page lifecycle mode authority for prerender, BFCache, frozen, and discarded documents

### Problem

The backlog already covers service-worker startup, document lifecycle reconciliation, stale runtimes, and cold-start hydration. A separate browser-level lifecycle surface remains: a document can be prerendered, hidden, frozen, put into BFCache, discarded, restored, or revived while old content-script code, observers, ports, style handles, policy snapshots, and capability tokens still exist.

Without an explicit page-lifecycle authority, the extension can accidentally:

```txt
- mutate a prerendered document before it becomes visible.
- keep observers active while a page is frozen or restored from BFCache.
- apply a stale policy after a tab is discarded and reloaded.
- preserve old tokens after browser-level restore.
- double-inject style/script/runtime state after BFCache resume.
- confuse normal SPA navigation with browser restore/resume events.
```

### Generalized fix

Add:

```txt
src/js/runtime/page-lifecycle-authority.ts
tools/check-page-lifecycle-authority.mjs
tests/runtime/page-lifecycle-authority.spec.ts
```

Define a shared lifecycle model:

```ts
type PageLifecycleMode =
  | "active"
  | "hidden"
  | "prerendering"
  | "frozen"
  | "bfcache-suspended"
  | "discarded"
  | "restoring"
  | "revived";
```

Rules:

```txt
- mutation tokens are valid only in active/revived documents unless explicitly observe-only.
- prerendering documents can collect cheap signals but cannot mutate DOM, click, inject scriptlets, or install CSS.
- BFCache suspend invalidates timers, observers, bridge nonces, and mutation journals until resume reconciliation.
- discarded tabs clear document-owned state and require full policy re-hydration on reload.
- restored documents get a new document lifecycle epoch before any mutation-capable work resumes.
- page visibility alone is not authority; the lifecycle mode must be explicit.
```

### Acceptance check

Add tests that simulate:

```txt
prerender -> visible
active -> hidden -> frozen -> active
active -> BFCache suspend -> restore
active -> discarded -> reload
SPA route change during freeze
extension update during BFCache restore
```

The tests must prove:

```txt
- stale tokens fail after lifecycle epoch change.
- observers do not duplicate after restore.
- CSS injections are reconciled, not blindly duplicated.
- mutation attempts in prerender/frozen/discarded state downgrade to observe-only or reject.
```

---

## P0.60 Add IDNA, public-suffix, and effective-domain normalization authority

### Problem

The backlog already requires effective-site identity, restricted-scheme policy, partitioned context, and match-pattern semantics. A more specific domain-normalization surface is still missing: hostnames are not enough. Production filtering needs one canonical authority for IDNA/punycode, Unicode hostnames, public-suffix boundaries, IP literals, localhost, extension origins, opaque origins, and private/internal names.

Naive domain splitting can misclassify:

```txt
- `co.uk` / `com.au` / other multi-part public suffixes.
- internationalized domains with punycode representation.
- Unicode lookalike or mixed-script hostnames.
- IPv4/IPv6 literals.
- localhost and private development hostnames.
- extension URLs and browser-internal origins.
- opaque/inherited origins from sandboxed or `about:blank` frames.
```

### Generalized fix

Add:

```txt
src/js/url/domain-authority.ts
config/public-suffix-snapshot.json
tools/update-public-suffix-snapshot.mjs
tools/check-domain-authority-coverage.mjs
```

The authority should expose:

```ts
type DomainIdentity = {
  rawUrl: string;
  scheme: string;
  hostKind: "dns" | "idna" | "ipv4" | "ipv6" | "localhost" | "extension" | "opaque" | "internal";
  asciiHost: string;
  unicodeHost?: string;
  registrableDomain?: string;
  publicSuffix?: string;
  siteKey: string;
  normalizationWarnings: string[];
};
```

Rules:

```txt
- all policy, DNR attribution, logger grouping, compatibility matching, allowlisting, and UI display use this authority.
- punycode/display form is separated from matching form.
- mixed-script or suspicious Unicode domains can be shown as punycode in diagnostics.
- public-suffix data is versioned and included in release provenance.
- unknown or failed normalization fails safe and records a downgrade reason.
```

### Acceptance check

Add fixtures for:

```txt
example.co.uk
bücher.example
xn--bcher-kva.example
127.0.0.1
[::1]
localhost
chrome-extension://...
about:blank inherited from top frame
data: opaque origin
sandboxed iframe with no same-origin permission
```

The same fixture result must be used by policy resolver, compatibility matcher, logger grouping, and DNR decision attribution.

---

## P0.61 Add unsupported-DNR-feature capability mapping and downgrade pipeline

### Problem

The backlog covers DNR transactions, rule cost, browser capability profiles, resource taxonomy, and rule semantic parity. A separate install-time problem remains: a parsed rule can express an action, condition, modifier, header operation, transform, regex, or resource constraint that the current browser or release mode cannot support safely.

If unsupported features are silently dropped, the extension may overblock, underblock, or claim compatibility it does not have.

Risk examples:

```txt
- a rule requiring regex support is converted to a weaker urlFilter without proof.
- response-header/cookie/CSP mutation is accepted when the browser/profile cannot enforce it.
- redirect/transform/surrogate behavior is partially supported and silently downgraded.
- initiator/request-domain conditions are lost during conversion.
- browser-specific DNR limits change behavior without an install decision record.
```

### Generalized fix

Add:

```txt
src/js/dnr/dnr-capability-mapper.ts
src/js/dnr/dnr-unsupported-feature-policy.ts
tools/check-dnr-capability-mapping.mjs
tests/dnr/unsupported-feature-downgrade.spec.ts
```

Each compiled rule should emit:

```ts
type DnrCapabilityDecision = {
  sourceRuleId: string;
  requiredCapabilities: string[];
  supportedCapabilities: string[];
  unsupportedCapabilities: string[];
  decision: "install" | "downgrade" | "reject" | "observe-only";
  downgradeReason?: string;
  semanticLoss: "none" | "low" | "medium" | "high" | "critical";
};
```

Rules:

```txt
- no unsupported DNR action/condition/modifier can be silently dropped.
- downgrade is allowed only when semanticLoss is below policy threshold.
- high/critical semantic loss rejects the rule or moves it to observe-only diagnostics.
- every downgrade/reject is visible in logger/explain output.
- browser capability profiles and runtime probes both feed the mapper.
```

### Acceptance check

The check fails if:

```txt
- a compiler branch drops a rule option without recording semantic loss.
- regex/header/redirect/surrogate/cookie/CSP behavior bypasses the mapper.
- release mode installs a rule with unsupported capabilities.
- downgrade decisions are not represented in decision diagnostics.
```

---

## P0.62 Add browser-action, badge, icon, title, side-panel, and visible-status write authority

### Problem

The backlog already requires user-visible state reconciliation, decision explanations, repair UI, and state-surface consistency. A more concrete write-authority surface remains: many parts of an extension can want to write the browser action badge, icon, title, popup state, side-panel state, repair state, or status banners.

If these writes stay scattered, users can see stale or contradictory states:

```txt
- badge shows blocking active while extension is degraded.
- popup says ready while DNR install failed.
- logger says observe-only while icon/title says active.
- repair UI disappears after a later harmless status write.
- badge count from stale document overwrites current tab health.
```

### Generalized fix

Add:

```txt
src/js/ui/visible-status-authority.ts
src/js/ui/status-surface-schema.ts
tools/check-visible-status-writes.mjs
tests/ui/visible-status-authority.spec.ts
```

Only this authority can write:

```txt
chrome.action.setBadgeText
chrome.action.setBadgeBackgroundColor
chrome.action.setIcon
chrome.action.setTitle
popup effective-status model
side-panel effective-status model
repair-banner state
logger header status
```

Status inputs:

```txt
policy readiness
DNR readiness
runtime health
permission status
private/profile mode
safe/degraded mode
current tab profile
compatibility debt state
active user override
```

### Acceptance check

CI fails if code calls badge/icon/title APIs outside the authority.

Tests must prove:

```txt
- degraded mode always overrides normal active state.
- permission loss is visible across popup, badge, and logger.
- stale tab writes cannot overwrite current-tab status.
- safe mode has a clear user-visible state and repair link.
```

---

## P1.60 Add chrome.alarms and scheduled-maintenance ownership registry

### Problem

The backlog covers timers, intervals, idle callbacks, deferred work, startup queues, and retry/backoff. A related but distinct MV3 surface is `chrome.alarms`: alarms survive service-worker suspension and can re-enter the worker later with stale assumptions.

Unowned alarms can cause:

```txt
- duplicate filter-list updates.
- stale cleanup jobs after migration.
- retry storms after offline/captive-portal failures.
- periodic diagnostics in private/profile modes.
- jobs firing after feature flags or permissions changed.
```

### Generalized fix

Add:

```txt
src/js/runtime/alarm-registry.ts
tools/check-alarm-ownership.mjs
tests/runtime/alarm-registry.spec.ts
```

Each alarm must declare:

```ts
type AlarmRegistration = {
  name: string;
  owner: string;
  purpose: string;
  scheduleKind: "one-shot" | "periodic" | "retry" | "maintenance";
  profileModes: string[];
  requiredPermissions: string[];
  freshnessEpochs: string[];
  maxSkewMs: number;
  migrationVersion: number;
  onStale: "ignore" | "reschedule" | "delete" | "repair";
};
```

Rules:

```txt
- no raw `chrome.alarms.create`, `clear`, or `onAlarm.addListener` outside the registry.
- alarms include an epoch so old scheduled jobs cannot commit after migration/settings/policy changes.
- private/profile-mode rules apply before a job runs.
- failed jobs use central retry/backoff authority.
```

### Acceptance check

The test suite must simulate:

```txt
extension update with old alarms
offline retry alarm
permission loss before alarm fires
profile-mode switch before alarm fires
duplicate alarm registration
```

and prove stale jobs cannot mutate state.

---

## P1.61 Add adaptive degradation ladder for resource pressure and browser throttling

### Problem

The backlog already asks for runtime budgets, quota/backpressure, resource/energy budgets, and local metrics. What is still missing is a single degradation ladder that says exactly what happens when the extension is under pressure.

Without a ladder, each subsystem may choose its own emergency behavior:

```txt
- video observer backs off while cosmetic engine continues heavy scans.
- DNR install failure enters degraded mode but content scripts still mutate.
- message flood control rejects messages while timers keep scheduling more work.
- layout-read budget exhaustion does not downgrade future cosmetic actions.
```

### Generalized fix

Add:

```txt
src/js/runtime/degradation-ladder.ts
config/degradation-policy.json
tools/check-degradation-ladder.mjs
tests/runtime/degradation-ladder.spec.ts
```

Define ordered levels:

```txt
L0 normal
L1 reduced diagnostics
L2 reduced observers
L3 cosmetic specific-only
L4 observe-only runtime
L5 network safe-only
L6 extension safe mode
L7 extension disabled for document until repair/navigation
```

Rules:

```txt
- every budget violation maps to a level transition.
- transitions have reason codes and TTLs.
- higher-severity states dominate lower-severity states.
- recovery requires explicit condition checks, not only time passing.
- user-visible status authority receives degradation changes.
```

### Acceptance check

Add tests for:

```txt
message flood + layout budget exhaustion
DNR install failure + active content scripts
high CPU observer + video page
offline filter update + stale cache
safe-mode exit after navigation
```

The same input state must always produce the same degradation level.

---

## P1.62 Add DOM readiness and document-phase contract for mutation actions

### Problem

The manifest and content scripts run early, often at `document_start`. The backlog covers document lifecycle, DOM traversal boundaries, user-input preservation, CSS injection order, and mutation journals, but it does not explicitly require every mutation-capable action to declare which document phase it needs.

Some actions are safe at `document_start`; others are not:

```txt
- CSS preload may be safe before body exists.
- overlay UI needs body or documentElement and style containment.
- picker/zapper preview needs layout and hit testing.
- input preservation needs focused element and selection state.
- video controls may not exist until media/player readiness.
```

### Generalized fix

Add:

```txt
src/js/runtime/document-phase-authority.ts
tools/check-document-phase-contracts.mjs
tests/runtime/document-phase-authority.spec.ts
```

Define phases:

```txt
before-document-element
document-element-ready
head-ready
body-ready
interactive
first-paint-after-policy
media-player-ready
user-interaction-ready
```

Every mutation API must declare:

```txt
requiredPhase
fallbackBeforePhase
maxWaitMs
stalePolicyOnWait
userInputSnapshotNeeded
```

### Acceptance check

The check fails if:

```txt
- a DOM mutation wrapper has no required phase.
- overlay/picker/zapper starts before its required phase.
- a delayed mutation commits after policy revision changes.
- a user-input-preserving mutation runs without the needed snapshot.
```

---

## P2.39 Add page-lifecycle adversarial corpus

### Problem

Page lifecycle failures are hard to catch with normal static fixtures.

### Generalized fix

Create fixtures for:

```txt
prerendered document that becomes visible
BFCache restore after style injection
frozen page with pending timeout
discarded tab revived after policy update
hidden video page with observer budget pressure
SPA navigation during lifecycle suspend
```

### Acceptance check

`tests/lifecycle/page-lifecycle-adversarial.spec.ts` proves stale observers, tokens, bridges, CSS, and pending operations cannot survive lifecycle epoch changes unsafely.

---

## P2.40 Add IDNA/public-suffix/domain-normalization corpus

### Problem

Domain bugs cause policy, logger, allowlist, DNR attribution, and compatibility mismatches.

### Generalized fix

Add a shared corpus containing:

```txt
multi-part public suffixes
punycode domains
Unicode domains
mixed-script suspicious domains
IPv4 and IPv6 hosts
localhost variants
extension URLs
opaque origins
sandboxed inherited origins
private/internal hostnames
```

### Acceptance check

The corpus runs against every exported domain/site matching function and fails if any subsystem produces a different site identity for the same input.

---

## P2.41 Add unsupported-DNR-feature downgrade corpus

### Problem

DNR downgrade bugs can look like successful installs while silently changing semantics.

### Generalized fix

Create rule fixtures for:

```txt
regex unsupported or too complex
header mutation unavailable
redirect transform unsupported
cookie/CSP mutation unavailable
initiator condition loss
resource-type mismatch
browser rule-limit downgrade
surrogate unsupported in release mode
```

### Acceptance check

Every fixture must produce an explicit `install`, `downgrade`, `reject`, or `observe-only` decision with semantic-loss metadata.

---

## P2.42 Add visible-status regression corpus

### Problem

Users need the same effective state across badge, icon, title, popup, logger, dashboard, and repair UI.

### Generalized fix

Create status fixtures for:

```txt
normal active filtering
degraded allow mode
safe mode
permission loss
private/profile mode
DNR install failed
filter lists updating
compatibility exception active
trusted/off site
stale runtime quarantined
```

### Acceptance check

Every fixture must produce one normalized visible status and prove no stale tab/document write can overwrite it.

---

## P2.43 Add alarms and scheduled-maintenance chaos tests

### Problem

Scheduled work can re-enter the service worker after the original assumptions are gone.

### Generalized fix

Test:

```txt
old alarm after extension update
duplicate periodic filter update alarm
offline retry storm
alarm fired after permission loss
alarm fired in private/profile mode
alarm fired after feature flag expiry
alarm fired during cold-start hydration
```

### Acceptance check

Stale alarms must be ignored, migrated, or repaired before they can write storage, update DNR, fetch filters, or change UI state.


# Suggested implementation order

Do these first:

```txt
1. P0.1 context-menu lifecycle registry
2. P0.16 shared task lock/retry primitive
3. P0.18 listener registry for browser/extension events
4. P0.2 service-worker startup sequencer
5. P0.4 page-policy schema validator
6. P0.6 first-stage DNR dedupe fix
7. P0.7 DNR transaction wiring + rollback fix
8. P0.8 compatibility debt / manifest sync gate
9. P0.9 fail-closed cross-layer integration check
10. P0.3 policy readiness gate for messages/content params
11. P0.17 settings-effect registry
12. P0.19 backup/restore/cloud schema gate
13. P0.20 runtime-health contract
14. P0.21 policy/config invalidation bus
15. P0.10 asset-fetch authority
16. P0.11 message contract registry
17. P1.11 manifest command registry
18. P0.12 webRequest instrumentation capability
19. P0.13 structural page classification in active path
20. P0.14 policy revision invalidation
21. P0.15 advisory-check detector
22. P0.22 effective-site / origin-authority resolver
23. P0.23 tab-document target authority
24. P0.24 structured error policy
25. P0.25 partial-startup repair workflow
26. P0.26 web-accessible-resource ownership registry
27. P0.27 generated-manifest surface model
28. P1.1 thin bootstrap / programmatic layer activation
29. P1.12 reversible mutation journal
30. P1.13 quota/backpressure manager
31. P1.15 cross-layer action traceability
32. P0.38 service-worker/content-script version handshake
33. P0.39 browser API failure taxonomy
34. P0.40 timer/scheduler ownership registry
35. P1.16 browser-API facade for tests
36. P1.17 navigation/document lifecycle reconciler
37. P1.30 long-lived channel/session registry
38. P1.31 user-visible decision explanation API
39. P1.32 central heuristic evidence/confidence model
40. P1.33 header/CSP/cookie mutation authority
41. P1.34 DOM traversal boundary policy
42. P1.35 UI interaction safety policy
43. P1.36 cache namespace and invalidation registry
44. P0.41 authenticated sender envelopes
45. P0.42 main-world bridge authority
46. P0.43 incognito/private/profile-mode policy
47. P0.44 permission-change downgrade/recovery flow
48. P1.37 remote filter content safety scanner
49. P1.38 extension UI state isolation
50. P1.39 accessibility/localization regression gates
51. P2.11 policy-decision fuzzer
52. P2.16 extension-update migration and old-runtime cleanup
53. P2.17 user-authored rule preview/commit workflow
54. P2.18 resource/energy budget enforcement
55. P2.19 privacy/profile-mode regression corpus
56. P2.20 permission-surface review generator
57. P2.21 main-world bridge adversarial tests
58. P0.45 optional-permission grant flow
59. P0.46 static-ruleset lifecycle reconciliation
60. P0.47 safe/factory reset authority
61. P1.40 user-visible state-surface reconciliation
62. P1.41 rule canonicalization and provenance hashes
63. P1.42 DOM marker namespace registry
64. P1.43 picker/zapper transactional sessions
65. P1.44 filter-list subscription lifecycle reconciliation
66. P1.45 versioned user-data archive manifest
67. P2.22 multi-browser manifest/build parity matrix
68. P2.23 dependency and toolchain provenance gate
69. P2.24 overlay visual containment regression suite
70. P2.25 post-release rollback and incident artifacts
71. P0.48 restricted-scheme and opaque-origin policy
72. P0.49 web-accessible-resource MIME/embed/navigation policy
73. P0.50 allow/exception rule authority and expiry
74. P0.51 per-sender/per-document flood control
75. P1.46 cloud and multi-device sync conflict resolver
76. P1.47 first-run/onboarding consent-state machine
77. P1.48 third-party frame role classification
78. P1.49 shipped-resource integrity manifest
79. P0.52 request initiator-chain authority
80. P0.53 resource-type/load-context taxonomy
81. P0.54 feature-flag and kill-switch authority
82. P0.55 redirect/surrogate target integrity policy
83. P1.50 non-window execution-context policy
84. P1.51 extension co-residency diagnostics
85. P1.52 user-input preservation policy
86. P1.53 redirect-chain/preflight/CORS-safe mutation policy
87. P1.54 policy snapshot diff and disruptive-change preview
88. P1.55 filter-rule cost model and compile-time risk budgeting
89. P2.26 restricted-scheme/opaque-origin regression corpus
90. P2.27 web-accessible-resource abuse corpus
91. P2.28 cloud sync conflict regression suite
92. P2.29 message/channel flood adversarial tests
93. P2.30 third-party frame role regression corpus
94. P2.31 request initiator-chain regression corpus
95. P2.32 resource-type/load-context parity corpus
96. P2.33 extension co-residency and foreign-interference harness
97. P2.34 feature-flag expiry and kill-switch release audit
98. P0.56 cold-start hydration barrier and startup event queue
99. P0.57 partitioned storage and network-context authority
100. P0.58 browser file-transfer, clipboard, and download authority
101. P1.56 offline/captive-portal retry authority
102. P1.57 privacy-budgeted local metrics schema
103. P1.58 layout-read and computed-style budget authority
104. P1.59 CSS cascade/layer/animation conflict policy
105. P2.35 cold-start/hydration chaos harness
106. P2.36 offline/retry regression corpus
107. P2.37 partitioned-context and storage-isolation corpus
108. P2.38 file-transfer and clipboard adversarial corpus
109. P0.59 page lifecycle mode authority
110. P0.60 IDNA/public-suffix domain authority
111. P0.61 unsupported-DNR-feature capability mapper
112. P0.62 visible-status write authority
113. P1.60 chrome.alarms ownership registry
114. P1.61 adaptive degradation ladder
115. P1.62 DOM readiness and document-phase contract
116. P2.39 page-lifecycle adversarial corpus
117. P2.40 IDNA/public-suffix/domain-normalization corpus
118. P2.41 unsupported-DNR-feature downgrade corpus
119. P2.42 visible-status regression corpus
120. P2.43 alarms and scheduled-maintenance chaos tests
```

Why this order:

```txt
- Items 1–4 generalize the exact class of bug fixed by afd2: local one-off guards become reusable lifecycle, lock, listener, and startup contracts.
- Items 5–14 prevent silent drift in the new architecture and make settings/storage/health invalidation explicit.
- Items 15–18 close bypass paths around external fetches, messages, commands, and instrumentation.
- Items 19–34 move the extension away from global injection, hostname exception lists, untraceable mutations, weak tab/document targeting, and unowned manifest exposure.
- Items 35–120 close remaining lifecycle gaps around stale runtimes, browser API failures, timers/channels, explanations, heuristic confidence, network mutation authority, DOM/UI boundaries, cache invalidation, sender authentication, main-world bridge isolation, private/profile behavior, permission downgrade, extension updates, user-rule commits, runtime resource budgets, optional permissions, static rulesets, reset authority, state-surface consistency, canonical rule identity, DOM marker collisions, picker/zapper sessions, subscription cleanup, archive portability, browser build parity, dependency provenance, overlay containment, post-release rollback, restricted schemes, WAR delivery safety, allow-rule expiry, sender flood control, cloud sync conflict handling, first-run consent state, third-party frame roles, shipped-resource integrity, request initiator chains, resource-type/load-context taxonomy, feature-flag authority, redirect/surrogate target integrity, non-window contexts, extension co-residency, user-input preservation, chain-safe network mutation, policy diff previews, compile-time rule-cost budgeting, cold-start hydration, partitioned context, file-transfer authority, page lifecycle modes, IDNA/public-suffix identity, unsupported DNR downgrade, visible-status authority, scheduled alarms, degradation ladders, and document-phase contracts.
```

---


# Minimal coding-agent prompt for the next pass

```txt
Work on uBlock Resurrected after commit afd2cbad460fee7a5571740175ef56aaedae7092.

Goal: continue generalizing the extension away from hostname exceptions and one-off guards. Treat the latest context-menu guard as a symptom of a broader need for lifecycle/idempotency management.

Implement the first project-wide generalization wave:

1. Replace the local contextMenuInstalled boolean with a context-menu registry that supports ensure, verify, disable, reset, and retry-after-failure.
2. Add a shared task-lock/retry primitive and move context-menu install, filter-list sync, DNR sync, policy loading, and stealth sync onto it.
3. Add a listener registry so browser/extension/BroadcastChannel listeners are declared once, owned, gated, and teardown-capable.
4. Add a service-worker startup sequencer for policy profiles, browser capabilities, DNR schema migration, session restore, context menus, whitelist, and instrumentation.
5. Add a page-policy schema validator for config/page-policy.json and fail on mixed boolean/string enum values or flat/nested policy disagreement.
6. Fix compileFilterTextToDNR first-stage dedupe so it includes the full DNR condition and action, not only urlFilter/resourceTypes/action.
7. Wire dnr-transaction.js into the active DNR sync path and fix rollback so it removes current target-scope rules before restoring snapshots.
8. Make compatibility-sites.json synchronize with manifest exclude_matches and fail on expired active entries.
9. Make check-cross-layer-integration.mjs fail-closed, fix undefined srcDir, and include it in an aggregate check.
10. Add a policy readiness gate before mutation-capable message handling and content-param responses.
11. Add a settings-effect registry so settings that mutate browser/page/runtime state validate, apply, verify, rollback, and bump policy revision where needed.
12. Gate backup/restore/cloud storage paths through the storage schema and migration validators.
13. Add a runtime-health schema and state-transition helper; remove raw runtimeHealth field writes.
14. Add a policy/config invalidation bus so whitelist/settings/filter-list/user-rule/safe-mode changes invalidate active layers.
15. Add command contracts for manifest keyboard/menu commands and route mutating commands through policy snapshots.
16. Add a reversible mutation journal for CSS, DOM, DNR, settings, context-menu, and video/scriptlet actions.
17. Add an effective-site/origin-authority resolver and migrate policy, logger, compatibility, and DNR attribution to it.
18. Add target authority for tab/document/frame mutation requests; stop using docURL or hostname match as authority.
19. Replace global unhandled-rejection suppression with structured error classification.
20. Add a user-visible partial-startup repair workflow for missing menus, stale locks, degraded DNR, and policy-load failures.
21. Add a web-accessible-resource registry and generate/check manifest exposure from it.
22. Add a generated-manifest surface model for permissions, content scripts, commands, WAR, DNR rulesets, and compatibility exclusions.
23. Add a browser-API facade with fake failure injection for lifecycle tests.
24. Add a document lifecycle reconciler for SPA/BFCache/frame replacement.
25. Add a policy-decision fuzzer for profile/capability/settings/frame/message combinations.
26. Add per-document runtime injection sentinels so broad manifest/bootstrap scripts cannot start duplicate layers.
27. Add stale-operation cancellation tokens for filter sync, DNR install, storage restore, tab/document injection, and policy-dependent commits.
28. Add filter-list trust tiers and capability caps for built-in, remote, imported, user, trusted-user, and dev lists.
29. Add managed/default/user setting precedence resolution before any setting controls high-risk behavior.
30. Add cross-source DNR conflict resolution across static, dynamic, session, whitelist, unbreak, stealth, and user rules.
31. Add CSS injection ownership and cascade-layer cleanup for policy revision changes and trusted-site toggles.
32. Add a two-phase filter-list update transaction with last-good rollback.
33. Add extension-page route authority for dashboard, logger, picker, zapper, newtab, options, and web-accessible UI routes.
34. Add inter-capability conflict rules and repair actions for incompatible runtime states.
35. Add a privacy-preserving diagnostic bundle generator for repair and compatibility debugging.
36. Add an upstream-rule semantic parity suite for parser/compiler behavior.
37. Add a long-run stability/leak harness across app, video, auth, commerce, news, logger, and popup profiles.
38. Add adapter certification metadata for specialized player/site support.
39. Add storage-key ownership and write authority.
40. Add central time/freshness authority.
41. Add stable ID namespace allocation.
42. Add shared URL/match-pattern semantic compilation.
43. Add policy-downgrade reason coverage.
44. Add high-risk user-intent tokens.
45. Add extension-page DOM/CSP safety checks.
46. Generate profile test matrices from page-policy.json.
47. Add privacy retention policies for logs, diagnostics, cache metadata, and journals.
48. Add release-mode feature pruning and navigation authority.
49. Add a policy/evidence coverage dashboard.
50. Add a behavior-deprecation and removal pipeline.
51. Add service-worker/content-script version handshakes and stale-runtime quarantine.
52. Add browser API failure taxonomy and fallback policy.
53. Add timer/scheduler ownership registry.
54. Add long-lived channel/session ownership registry.
55. Add user-visible decision explanations.
56. Add central heuristic evidence/confidence model.
57. Add header/CSP/cookie/privacy-setting mutation authority.
58. Add DOM traversal boundary policy.
59. Add UI interaction safety policy.
60. Add capability-owned cache namespace and invalidation.
61. Add extension-update migration and old-runtime cleanup.
62. Add user-authored rule preview/commit/undo workflow.
63. Add resource/energy budget enforcement across active runtimes.
64. Add authenticated sender envelopes for all extension messages.
65. Add main-world bridge authority with nonce-bound handshakes.
66. Add incognito/private/profile-mode policy for storage, diagnostics, DNR, cloud, and runtime health.
67. Add permission-change observer with downgrade, explanation, repair, and stale-capability cancellation.
68. Add remote filter content safety scanning, decompression limits, and parser/action caps.
69. Add extension UI state isolation and privilege-separated stores.
70. Add accessibility/localization gates for repair, decision, popup, dashboard, logger, picker, and options UIs.
71. Add privacy/profile-mode regression corpus.
72. Add permission-surface drift and store-compliance review generator.
73. Add adversarial main-world bridge tests.
74. Add optional-permission grant flow and least-privilege migration.
75. Add static-ruleset lifecycle and enabled-state reconciliation.
76. Add safe-reset and factory-reset authority.
77. Add user-visible state-surface reconciliation across badge, popup, logger, dashboard, and repair UI.
78. Add rule canonicalization and provenance-hash authority.
79. Add DOM marker and attribute namespace registry.
80. Add picker/zapper transactional session boundaries.
81. Add filter-list subscription lifecycle reconciliation.
82. Add versioned user-data archive manifest.
83. Add multi-browser manifest/build parity matrix.
84. Add dependency and toolchain provenance gate.
85. Add overlay visual containment regression suite.
86. Add post-release rollback and incident artifact workflow.
87. Add restricted-scheme and opaque-origin policy for about, data, blob, file, extension, browser-internal, sandboxed, and inherited-origin documents.
88. Add web-accessible-resource MIME, embed, navigation, cache, and CSP delivery policy.
89. Add allow/exception rule authority with source, scope, reason, provenance, expiry, and undo path.
90. Add per-sender, per-document, and per-channel flood control for messages, bridges, logger streams, and event bus traffic.
91. Add cloud/multi-device sync conflict resolution with tombstones, merge policies, conflict records, and rollback.
92. Add first-run/onboarding consent-state machine for safe defaults, optional permissions, diagnostics, cloud, trusted filters, and privacy mutations.
93. Add third-party frame role classification before frame-level filtering and mutation decisions.
94. Add shipped-resource integrity and cache-busting manifest for generated configs, static rulesets, bundles, pages, CSS, and WAR resources.
95. Add request initiator-chain authority for network, logger, compatibility, and diagnostic decisions.
96. Add one canonical resource-type/load-context taxonomy shared by parser, DNR, WebRequest, logger, simulator, and policy.
97. Add feature-flag, experiment, and kill-switch authority with expiry, owner, safe downgrade, and release audit.
98. Add redirect/surrogate target integrity policy for MIME, origin, cache, CSP, resource type, and rollback.
99. Add non-window execution-context policy for workers, worklets, prerendered documents, fenced/anonymous frames, and extension pages.
100. Add extension co-residency and foreign-interference diagnostics without identifying other extensions.
101. Add user-input preservation policy for DOM, CSS, picker/zapper, video, and UI mutations.
102. Add redirect-chain, preflight, and CORS-safe network mutation policy.
103. Add policy snapshot diff and disruptive-change preview for settings, filters, permissions, profile changes, safe mode, and feature flags.
104. Add compile-time filter-rule cost model and risk budgets before install/storage.
105. Add restricted-scheme, WAR abuse, cloud-conflict, flood, third-party-frame, request-context, resource-taxonomy, co-residency, and feature-flag regression/audit corpora.

Do not add new site-specific exclude_matches as the primary fix.
Do not treat scaffolding as complete unless active sw.js/runtime paths use it.
Do not weaken ad blocking; only make high-risk behavior policy/evidence-gated.

Acceptance:
- npm run typecheck, if available
- npm run test, if available
- npm run check:page-policy-schema
- npm run check:context-menu-lifecycle
- npm run check:dnr-transaction-wiring
- npm run check:manifest-compatibility-sync
- npm run check-cross-layer-integration or npm script equivalent
- npm run check:task-lock-usage
- npm run check:listener-registry
- npm run check:settings-effect-registry
- npm run check:backup-restore-schema
- npm run check:runtime-health-contract
- npm run check:policy-invalidation-wiring
- npm run check:command-contracts
- npm run check:mutation-journal
- npm run check:effective-site-usage
- npm run check:target-authority
- npm run check:unhandled-error-policy
- npm run check:repair-plan
- npm run check:web-accessible-resources-registry
- npm run check:manifest-surface-generated
- npm run check:browser-api-facade-usage
- npm run check:document-lifecycle-wiring
- npm run test:policy-decision-fuzzer, if added
- npm run check:document-runtime-sentinel
- npm run check:operation-token-usage
- npm run check:filter-list-trust-tiers
- npm run check:settings-precedence
- npm run check:dnr-conflict-resolution
- npm run check:css-injection-ownership
- npm run check:filter-update-transaction
- npm run check:extension-route-authority
- npm run check:capability-conflicts
- npm run check:diagnostic-bundle-privacy
- npm run test:upstream-filter-semantics, if added
- npm run test:policy-profile-soak, if added
- npm run check:adapter-certification
- npm run check:storage-key-authority
- npm run check:time-authority
- npm run check:id-authority
- npm run check:match-pattern-authority
- npm run check:policy-reason-coverage
- npm run check:user-intent-tokens
- npm run check:extension-page-dom-safety
- npm run generate-policy-profile-tests && npm run test:policy-profiles, if added
- npm run check:privacy-retention
- npm run check:release-feature-pruning
- npm run check:navigation-authority
- npm run check:policy-evidence-dashboard
- npm run check:deprecation-pipeline
- npm run check:runtime-version-handshake
- npm run check:browser-api-error-policy
- npm run check:scheduler-ownership
- npm run check:channel-registry
- npm run check:decision-explainer-coverage
- npm run check:heuristic-evidence-model
- npm run check:network-mutation-authority
- npm run check:dom-boundary-policy
- npm run check:ui-interaction-policy
- npm run check:cache-registry
- npm run check:extension-migrations
- npm run check:user-rule-transaction
- npm run check:resource-budget-wiring
- npm run check:sender-envelope-usage
- npm run check:main-world-bridge-authority
- npm run check:profile-mode-policy
- npm run check:permission-downgrade-wiring
- npm run check:filter-content-safety
- npm run check:ui-state-isolation
- npm run check:extension-ui-a11y
- npm run check:extension-ui-l10n
- npm run test:profile-mode-corpus, if added
- npm run check:permission-surface-review
- npm run test:main-world-bridge-adversarial, if added
- npm run check:optional-permission-authority
- npm run check:static-ruleset-lifecycle
- npm run check:reset-authority
- npm run check:state-surface-reconciliation
- npm run check:rule-canonicalization
- npm run check:dom-marker-namespace
- npm run check:element-tool-sessions
- npm run check:filter-subscription-lifecycle
- npm run check:user-data-archive-manifest
- npm run check:browser-build-parity
- npm run check:toolchain-provenance
- npm run test:overlay-visual-containment, if added
- npm run check:release-rollback-plan
- npm run check:restricted-scheme-policy
- npm run check:war-delivery-policy
- npm run check:allow-rule-authority
- npm run check:flood-control-wiring
- npm run check:sync-conflict-policy
- npm run check:consent-state-machine
- npm run check:frame-role-policy
- npm run check:shipped-resource-integrity
- npm run check:request-context-authority
- npm run check:resource-context-taxonomy
- npm run check:feature-flag-authority
- npm run check:redirect-target-integrity
- npm run check:execution-context-policy
- npm run check:co-residency-diagnostics
- npm run check:user-input-preservation
- npm run check:network-chain-policy
- npm run check:policy-diff-coverage
- npm run check:rule-cost-model
- npm run test:request-context-corpus, if added
- npm run test:resource-context-parity, if added
- npm run test:co-residency-harness, if added
- npm run check:feature-flag-release-audit
- npm run check:start-up-hydration-gate || npm run check:startup-hydration-gate
- npm run check:partition-context-usage
- npm run check:file-transfer-authority
- npm run check:network-retry-authority
- npm run check:local-metrics-schema
- npm run check:layout-read-authority
- npm run check:css-cascade-policy
- npm run test:mv3-cold-start-hydration, if added
- npm run test:offline-retry-corpus, if added
- npm run test:partitioned-context-corpus, if added
- npm run test:file-transfer-adversarial, if added
- npm run test:restricted-scheme-corpus, if added
- npm run test:war-abuse-corpus, if added
- npm run test:cloud-sync-conflicts, if added
- npm run test:message-flooding, if added
- npm run test:frame-role-corpus, if added
- no new hostname exception as main solution
- no warning-only check for mandatory invariants
```

---

# Completion definition for this phase

This phase is complete only when:

```txt
- context menus can be enabled/disabled/re-enabled without stale flags.
- policy profiles are loaded and validated before mutation messages run.
- DNR updates are transaction-wrapped and rollback-verified.
- compatibility exceptions are generated from one registry and are unexpired.
- global content-script exceptions stop growing.
- every runtime layer has a real lifecycle adapter.
- settings changes run through validated setting-effect handlers.
- backup/restore/cloud writes cannot introduce unknown storage keys.
- runtime health has typed states and legal transitions.
- policy invalidation stops or refreshes stale active layers.
- manifest commands have the same contract rigor as messages.
- mutations are journaled and reversible where possible.
- effective-site identity is shared across policy, DNR attribution, logger grouping, and compatibility matching.
- mutating actions prove tab/document/frame authority before applying changes.
- global async errors are classified instead of broadly suppressed.
- partial startup failures have a visible repair path.
- web-accessible resources and manifest surfaces are generated from ownership registries.
- lifecycle tests can inject Chrome API failures through a browser facade.
- document lifecycle events reconcile active policy snapshots and mutation tokens.
- fuzzed policy decisions cannot produce unsafe combinations.
- broad manifest/bootstrap injection cannot start duplicate document runtimes.
- stale async work cannot commit after newer settings, policy, navigation, or filter-list state wins.
- filter-list source trust determines which rule actions/options are allowed.
- managed/default/user settings resolve through one precedence model.
- DNR conflicts are explained across static/dynamic/session/user/allow/unbreak/surrogate sources.
- every CSS injection has owner, document key, layer, policy revision, and cleanup path.
- filter-list updates publish only after staged validation and install verification, with last-good rollback.
- extension pages and web-accessible UI routes have explicit privileges.
- incompatible capability states have block/warn/repair rules.
- diagnostic bundles are useful but privacy-preserving by construction.
- parser/compiler semantics either match upstream-compatible expectations or declare safe deviations.
- long-run soak tests do not show unbounded registry/listener/style/token/log growth.
- specialized adapters ship only after certification metadata, fixtures, policy mapping, and rollback coverage.
- every storage key has owner, schema, allowed writers, backup/cloud policy, and privacy class.
- timestamps, freshness, and expiry decisions are deterministic and testable.
- generated IDs come from declared namespaces, not ad-hoc time/random strings.
- manifest, DNR, compatibility, whitelist, WAR, and policy patterns share one semantic compiler.
- every policy downgrade has a reason code and source.
- dangerous manual actions require fresh user-intent tokens.
- extension pages have DOM/CSP/link/message safety contracts.
- profile tests are generated from page-policy.json.
- logs, diagnostics, caches, journals, and histories have retention/deletion policies.
- release builds prune dev/test/diagnostic-only behavior unless explicitly justified.
- navigation is routed through an authority with opener and user-intent policy.
- shipped behaviors appear in a generated coverage dashboard.
- deprecated behavior has a removal/migration path and cannot remain preferred forever.
- content scripts and service worker prove compatible runtime protocol versions before mutation-capable work.
- stale runtimes after extension update are quarantined, downgraded, or repaired.
- browser API errors map to known fallback policies instead of local catch-and-ignore behavior.
- timers, intervals, idle callbacks, and deferred work are owned and cancellable.
- long-lived channels and sessions have owners, privacy classes, contracts, and teardown.
- users and developers can ask why a rule/action/policy was allowed, rejected, downgraded, or observe-only.
- heuristic detectors emit normalized evidence/confidence records before causing mutations.
- header, CSP, cookie, privacy-setting, redirect, surrogate, and upgrade mutations use one authority.
- DOM traversal across frames, shadow roots, and stylesheets uses boundary decisions.
- synthetic clicks, focus, keyboard, pointer, and scroll actions follow UI interaction safety policy.
- memory/session/local/DNR caches have owners, invalidation rules, limits, and privacy classes.
- extension update migrations cover storage, generated assets, runtime protocol, policy config, and old-runtime cleanup.
- user-authored rules can be previewed, explained, committed transactionally, and undone.
- active runtimes enforce profile-level CPU, DOM scan, message, logger, and memory budgets.
- every extension message has a trusted sender envelope that is not copied from user-controlled payload data.
- main-world bridges require nonce-bound, document-bound, policy-revision-bound authority and expire on navigation or downgrade.
- incognito/private/profile-mode behavior is explicit for storage, diagnostics, DNR, context menus, cloud, backup, and runtime health.
- permission loss or browser API unavailability downgrades dependent capabilities, cancels stale tokens, explains the reason, and offers repair when appropriate.
- remote/imported filter content passes size, encoding, decompression, parser-budget, syntax-risk, and trust-tier safety scans before compilation.
- popup, dashboard, logger, picker, zapper, options, new-tab, and repair UIs use privilege-separated state namespaces.
- user-visible repair and explanation flows are keyboard-accessible and localization-key backed.
- private/profile-mode regression tests prevent diagnostics, storage, runtime-health, DNR, cloud, and stale-runtime leakage across modes.
- permission-surface changes generate a review artifact mapping each permission/resource/script surface to owner, policy profile, UI explanation, and tests.
- adversarial page fixtures cannot spoof, replay, flood, or retain main-world bridge authority.
- optional permissions are requested only through a user-intent-backed authority with fallback policy and reviewable explanations.
- static ruleset enabled state is reconciled with manifest, release mode, profile policy, migration version, and runtime health.
- safe reset and factory reset can repair corrupt extension state without deleting user-authored filters unless explicitly confirmed.
- badge, popup, logger, dashboard, and repair UI report the same effective filtering/runtime/permission/health state.
- every installed rule has canonical semantic identity, provenance hash, risk class, and install hash.
- extension-owned DOM markers use declared namespaces, are not trusted when page-created, and are cleaned up across teardown/update.
- picker and zapper sessions are transaction-scoped, preview-reversible, authority-bound, and expire on navigation/policy downgrade.
- filter-list subscription changes prune stale rules/caches and handle aliases, removals, failures, and imported URL edits safely.
- user-data export/import archives have versioned manifests, privacy classes, redactions, migration previews, and rollback snapshots.
- supported browser/build targets have manifest surfaces generated or validated against runtime capability profiles.
- release artifacts include toolchain/dependency provenance and reproducibility hashes.
- extension overlays are visually contained, accessible, and fully removable across app shells, video pages, iframes, zoom, RTL, and hostile CSS.
- every release has a rollback/incident artifact that maps changed surfaces to safe rollback options and required future fixtures.
- restricted, opaque, inherited-origin, sandboxed, and browser-internal documents have explicit policy rather than accidental URL-string behavior.
- web-accessible resources declare MIME, embed, navigation, cache, CSP, and authority expectations.
- allow/exception rules cannot silently reduce blocking without source, scope, reason, provenance, expiry/permanent justification, and undo path.
- valid-looking message/channel floods are rate-limited, coalesced, quarantined, or downgraded before causing unbounded work.
- cloud sync uses merge policies, tombstones, conflict records, and rollback instead of silent last-write-wins for user-authored data.
- fresh install, upgrade, backup import, reset, and profile-mode starts reach deterministic consent-aware safe defaults.
- third-party frames are classified by role before risky cosmetic, scriptlet, network, picker/zapper, bridge, or UI-interaction authority is granted.
- shipped resources have build IDs, hashes, owners, schema versions, and release-mode expectations, and stale mixed-version resources are detected.
- restricted-scheme, WAR-abuse, cloud-conflict, message-flood, and third-party-frame corpora guard these surfaces against regression.
- request initiator chains are normalized before network, logger, compatibility, redirect, surrogate, and diagnostic decisions.
- resource types and load contexts use one shared taxonomy across parser, DNR, WebRequest, logger, simulator, and policy.
- feature flags, experiments, and kill switches have owner, reason, scope, expiry, safe downgrade, policy invalidation, and release audit.
- redirect and surrogate targets declare MIME, origin, cache, CSP, resource-type compatibility, integrity, and rollback behavior.
- non-window execution contexts cannot inherit DOM/scriptlet/bridge/UI authority accidentally.
- foreign extension/browser interference is diagnosed without enumerating or identifying other extensions.
- DOM/CSS/UI mutations preserve focused inputs, form drafts, editor state, selection, IME composition, media position, and pointer state.
- redirect chains, preflight requests, CORS mode, credentials mode, module scripts, service workers, and media chains are considered before network mutation.
- disruptive policy revisions produce bounded privacy-preserving diffs and can cancel or reissue tokens based on severity.
- filter-rule compile output includes cost/risk summaries and rejects or downgrades high-cost rules before install.
- request-context, resource-taxonomy, co-residency, and feature-flag corpora guard these surfaces against regression.
- mutation-capable events cannot run before required service-worker hydration components are ready.
- queued startup events carry epochs, expire safely, and cannot commit after newer startup/navigation/policy state wins.
- top-level site, frame site, initiator site, storage partition, cookie partition, and profile mode are part of relevant policy/network/storage decisions.
- browser file-transfer, clipboard, download, import, and export operations use staged schemas, privacy classes, user-intent tokens, and rollback where applicable.
- offline, captive-portal, timeout, redirect-loop, and remote-resource retry behavior is centrally owned and cannot poison parser/cache state.
- local metrics and counters use declared schemas, TTLs, privacy classes, and forbidden-dimension checks.
- layout-forcing reads are budgeted separately from DOM traversal and mutation.
- CSS injection uses declared cascade layers, allowed property sets, insertion order, cleanup order, and conflict rules.
- cold-start/hydration, offline/retry, partitioned-context, and file-transfer adversarial corpora guard these surfaces against regression.
- prerendered, BFCache-restored, frozen, discarded, and revived documents cannot keep stale mutation authority.
- IDNA, punycode, public-suffix, localhost, IP, opaque-origin, and extension-origin normalization uses one tested authority.
- unsupported or browser-specific DNR actions/options are downgraded, rejected, or explained before install.
- browser-action icons, badges, titles, side-panel status, popup state, and repair UI are written through one visible-status authority.
- chrome.alarms and scheduled maintenance jobs have owners, uniqueness keys, migration behavior, and stale-job cleanup.
- resource-pressure degradation follows a deterministic ladder instead of scattered ad-hoc disabling.
- DOM mutations and CSS injections declare the document readiness phase they require.
- page-lifecycle, IDNA/public-suffix, unsupported-DNR, visible-status, and alarms corpora guard these surfaces against regression.
- every check that claims safety fails closed in CI.
```
