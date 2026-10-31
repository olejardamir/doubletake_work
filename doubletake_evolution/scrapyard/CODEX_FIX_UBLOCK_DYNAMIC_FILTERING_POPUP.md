# Codex Task: Restore the Full uBlock Origin Dynamic-Filtering Popup in uBlock Resurrected

## Mission

Work in:

```text
https://github.com/Astrocytech/uBlockResurrected
```

Starting baseline:

```text
main
a1bb2ceac593f759a07266c6df2f4e2b25f815a6
```

Restore the popup’s dynamic-filtering matrix so that it behaves like the original Firefox uBlock Origin popup, not merely resembles it visually.

Reference implementation:

```text
https://github.com/gorhill/uBlock
```

Use the upstream popup and dynamic-filtering behavior as the specification, especially:

```text
src/popup-fenix.html
src/css/popup-fenix.css
src/js/popup-fenix.js
src/js/messaging.js
src/js/ublock.js
src/js/dynamic-net-filtering.js
```

A useful pinned upstream reference is:

```text
697b2f1099a97f7ffb5bf1ccd346822509f51527
```

Do not stop at analysis. Inspect the active runtime, implement the fix, add real tests, run them, and keep correcting the implementation until the acceptance criteria pass.

Do not ask the user how to implement it. Resolve the repository architecture yourself.

---

## What is currently wrong

On the same `google.com` page, original uBlock Origin shows:

- a complete list of observed domains and hostnames;
- the expandable `+ all` or `− all` control;
- compact request indicators such as `+`, `++`, `+++`, `−`, `−−`, and `−−−`;
- colored request-status strips;
- two working dynamic-filtering columns for global and local rules;
- inherited and own rule colors;
- working block, noop, and optional allow actions;
- temporary rules, save, revert, reload, and persistence behavior.

uBlock Resurrected currently shows only a skeletal matrix, often only the page domain and hostname. Counts, colors, and effective rules are missing or inconsistent, and clicking the matrix does not reliably change actual request behavior.

This is not primarily a CSS problem. Most of the original popup rendering machinery is already present. The backend is failing to supply accurate per-tab data and is failing to enforce rule changes.

---

## Source-of-truth rules

Before editing, prove which files are active.

Known active paths that must be respected:

```text
platform/chromium/manifest.json
  background.service_worker = js/sw.js
  action.default_popup      = popup-fenix.html
```

The active service worker is:

```text
platform/chromium/js/sw.js
```

That file explicitly identifies itself as the canonical manifest-selected runtime. Do not implement the real fix only in inactive prototypes such as:

```text
src/js/messaging.ts
src/js/mv3/sw-entry.ts
platform/chromium/js/sw-entry-bundle.js
```

unless the build and manifest are deliberately changed so that the new code is unquestionably active.

The popup script source is:

```text
src/js/popup-fenix.ts
```

The build produces:

```text
platform/chromium/js/popup-fenix-bundle.js
```

Do not hand-edit generated popup bundles. Edit the source and run the repository build.

Preserve one authoritative implementation. Do not leave a corrected TypeScript implementation beside a different broken implementation used by the manifest.

---

## Existing popup code that should be made functional, not replaced with fake UI

The current popup source already:

- sets `data-acount` and `data-bcount`;
- converts real counts into one, two, or three compact signs;
- applies `allowRule`, `blockRule`, `noopRule`, and `ownRule`;
- builds hostname and domain rows from `popupData.hostnameDict`;
- supports global and local rule cells;
- supports the action selector;
- supports `+ all` and `− all` expansion;
- supports save and revert controls.

The current CSS already:

- renders `data-acount="1|2|3"` as `+`, `++`, or `+++`;
- renders `data-bcount="1|2|3"` as `−`, `−−`, or `−−−`;
- displays colored allowed, blocked, mixed, block-rule, noop-rule, and allow-rule states;
- exposes both rule columns when `body.advancedUser` is present.

Therefore:

> Do not hardcode plus signs, minus signs, colors, hostnames, or Google-specific values into the HTML.

Fix the data pipeline, settings pipeline, rule engine, and enforcement path so the existing rendering code receives truthful data. Only change popup HTML, CSS, or TypeScript where an actual divergence from upstream behavior is proven.

---

# Required implementation

## 1. Fix advanced-user setting propagation

There is currently a split settings model.

The settings page writes `advancedUserEnabled` into the normal `userSettings` object, but `buildPopupData()` reads:

```js
popupSettings.advancedUserEnabled
```

from the separate `ubrPopupSettings` cache. As a result, the checkbox can be enabled while the popup still receives:

```js
advancedUserEnabled: false
```

and never adds the `advancedUser` class. That hides the global rule column, the extra built-in rows, rule colors, and action cells.

Replace this with one canonical settings source or a correctly synchronized compatibility layer.

Requirements:

1. `advancedUserEnabled` must survive popup close, service-worker suspension, browser restart, and extension reload.
2. Enabling advanced-user mode in Settings must affect the very next popup opening.
3. `buildPopupData()` must read the same persisted setting that the Settings page writes.
4. Migrate existing installations that may have values in either:
   - `userSettings`;
   - `ubrPopupSettings`;
   - top-level popup storage keys.
5. Add a `chrome.storage.onChanged` listener or equivalent cache invalidation so the active service worker does not retain stale settings.
6. Apply the same consistency check to:
   - `colorBlindFriendly`;
   - `tooltipsDisabled`;
   - `godMode`;
   - `fontSize`;
   - `uiPopupConfig`;
   - `firewallPaneMinimized`;
   - `popupPanelSections`.

Do not solve this by forcing advanced mode to `true` unconditionally.

---

## 2. Replace the global, popup-gated request statistics with a real per-tab ledger

The current runtime tracks basic request details only when:

```js
loggerActive || popupNeedsTracking
```

This means a page usually finishes loading before the popup is opened, so the popup cannot know which hosts were contacted.

The current `buildPopupData()` also iterates a global `hostnameStats` map rather than a map scoped to the requested tab. That can omit the current page’s hosts or leak hosts from unrelated tabs.

Implement a minimal always-on per-tab request ledger. Detailed logger payloads may remain conditional, but the small counters required by the popup must always be recorded.

A suitable model is:

```ts
type RequestCounts = {
    any: number;
    script: number;
    frame: number;
};

type HostnameEntry = {
    domain: string;
    allowed: RequestCounts;
    blocked: RequestCounts;
};

type TabRequestLedger = {
    tabId: number;
    navigationId: string | number;
    pageURL: string;
    pageHostname: string;
    pageDomain: string;
    pageCounts: {
        allowed: RequestCounts;
        blocked: RequestCounts;
    };
    hostnameDict: Record<string, HostnameEntry>;
    pendingRequests: Map<string, PendingRequest>;
    contentRevision: number;
    updatedAt: number;
};
```

Equivalent architecture is acceptable, but the behavior must match.

### Request lifecycle

Use request IDs and terminal events to prevent double counting.

At minimum:

- `webRequest.onBeforeRequest`
  - record the pending request;
  - derive URL hostname and registrable domain;
  - record tab, request type, frame information, and navigation generation.

- `webRequest.onCompleted`
  - finalize the pending request once as allowed.

- `webRequest.onErrorOccurred`
  - do **not** count every error as allowed;
  - classify extension-blocked requests, such as `net::ERR_BLOCKED_BY_CLIENT`, as blocked;
  - classify unrelated network failures as failed, not allowed and not blocked;
  - finalize a request only once.

- Redirects
  - handle redirect hops without counting duplicate callbacks for the same hop;
  - preserve the final host and any separately completed redirect requests according to the upstream counting model.

- Top-level navigation
  - reset the tab ledger at the correct beginning of a new main-frame navigation;
  - do not mix counts from the previous document.

- Tab close
  - remove the tab ledger and pending state.

Use `webNavigation.onCommitted` for frame `0`, or another proven navigation boundary. Do not reset late enough to erase requests that already belong to the new document.

### Service-worker suspension

In-memory maps alone are insufficient because the extension service worker can stop and restart while tabs remain open.

Persist compact per-tab popup ledgers in:

```js
chrome.storage.session
```

or another session-scoped mechanism designed for service-worker state.

Requirements:

- debounce or batch writes;
- keep data bounded;
- hydrate before answering `getPopupData`;
- retain active-tab popup data across service-worker restart;
- clear state on tab removal and new top-level navigation;
- do not write a full logger history for every request.

---

## 3. Attribute allowed and blocked requests to the correct hostname

The current code explicitly sets every hostname’s blocked count to zero. That guarantees that blocked row colors and `−`, `−−`, and `−−−` cannot appear.

Fix it.

### Production-safe attribution

The extension already observes request URLs in `webRequest`. Keep pending request metadata keyed by `requestId`, then correlate terminal completion or blocked-error events with the same request.

Do not count `onErrorOccurred` as allowed.

### Optional debug corroboration

`chrome.declarativeNetRequest.onRuleMatchedDebug` exposes the request URL, request ID, type, and tab ID, but it is available only to unpacked extensions with `declarativeNetRequestFeedback`.

Therefore:

- use it as a development/test oracle or supplemental signal when available;
- do not make release behavior depend on it;
- deduplicate it against `webRequest` terminal events.

`getMatchedRules()` may be used as an aggregate sanity check. It must not be used to invent per-host attribution because it does not provide the request URL.

### Required popup data

`buildPopupData(tabId)` must derive all of these from the requested tab’s ledger:

```js
pageCounts
hostnameDict
contentLastModified
```

Do not iterate a process-global hostname map.

For each actually observed hostname, return:

```js
hostnameDict[hostname] = {
    domain,
    counts: {
        allowed: { any, script, frame },
        blocked: { any, script, frame }
    }
};
```

Also ensure:

- the page hostname and registrable page domain are present;
- domain rows aggregate their subdomain counts the same way upstream does;
- first-party and third-party rows are classified correctly;
- script and frame counters are accurate;
- connected-domain statistics use the same real per-tab data;
- the page blocked percentage uses a consistent numerator and denominator;
- no unmatched page-level blocked total is silently distributed among arbitrary hosts.

Do not hardcode:

```text
google.com
www.google.com
gstatic.com
googleusercontent.com
csp.withgoogle.com
```

Those rows should appear only when the browser actually observes those hosts.

---

## 4. Preserve the original meaning of the compact signs

The signs are compact count indicators:

```text
+    1–9 allowed requests
++   10–99 allowed requests
+++  100 or more allowed requests

−    1–9 blocked requests
−−   10–99 blocked requests
−−−  100 or more blocked requests
```

Use the existing upstream-compatible bucketing code. Do not insert the signs as literal row text.

The `+ all` or `− all` label is different: it expands or collapses hostname detail rows.

Requirements:

- click `+ all` to expand;
- click `− all` to collapse;
- persist the chosen firewall-pane state;
- do not treat this click as a firewall action;
- preserve per-domain expansion exceptions;
- use the expected localized label, normally `all`, rather than introducing a new hardcoded `Any`.

---

## 5. Restore real global and local dynamic-filtering behavior

The two rule columns must work as in uBlock Origin:

```text
data-src="/"  => global source "*"
data-src="."  => current page hostname
```

The built-in rule rows must support:

```text
*
image
3p
inline-script
1p-script
3p-script
3p-frame
```

Hostname rows use destination hostname with request type `*`.

Actions:

```text
0 = unset
1 = block
2 = allow
3 = noop
```

The popup already sends these values. Fix the active backend.

### Current enforcement defect

The active `toggleFirewallRule`, `saveFirewallRules`, and `revertFirewallRules` handlers mainly mutate JavaScript maps and storage. They do not reliably update the actual browser rules that decide requests.

After every relevant state change, compile and synchronize the effective firewall policy into the browser:

- temporary popup rules -> `chrome.declarativeNetRequest.updateSessionRules`;
- permanent saved rules -> `chrome.declarativeNetRequest.updateDynamicRules`.

Use reserved, non-colliding ID ranges. Verify the repository’s existing ranges before choosing them. Use deterministic IDs or transactional full-range replacement so updates are stable and duplicate-free.

Do not merely wire in an inactive prototype without proving that the manifest-selected service worker invokes it.

### Session and permanent state

Match upstream semantics:

#### Normal click

A normal click changes only the session firewall.

It must:

- take effect immediately;
- mark the matrix dirty when session and permanent state differ;
- survive service-worker suspension during the browser session;
- disappear when the browser session ends unless saved.

#### Ctrl-click or Command-click

A modified click with `persist: true` changes both session and permanent state immediately.

#### Unset action

When `action === 0`:

- always remove the session cell;
- remove the permanent cell only when `persist === true`;
- do not delete permanent state on an ordinary unpersisted click.

The current implementation incorrectly removes permanent rules even for an ordinary unset. Fix it.

#### Save button

The lock/save operation must copy the relevant session matrix to permanent state, including removals.

It receives:

```js
srcHostname
desHostnames
```

Implement upstream `copyRules` semantics for:

- rules scoped to the current source hostname;
- relevant global rows;
- destination hostnames visible in the popup;
- hostname switches associated with the current page.

Do not simply append all current session entries to the permanent object. Permanent rules that were removed from the session matrix must also be removed when saving.

After saving:

- update persistent storage;
- update dynamic DNR rules;
- make `matrixIsDirty` false;
- keep the visible effective session matrix unchanged.

#### Revert button

Revert must restore the relevant session rules and hostname switches from permanent state.

Do not merely delete session rules.

After reverting:

- update session DNR rules;
- return fresh popup data;
- make `matrixIsDirty` false;
- restore the correct own and inherited colors.

### Service-worker restart

Hydrate permanent and session firewall state before handling popup requests or network decisions.

Session rules must not vanish merely because the extension service worker was suspended.

---

## 6. Implement correct block, noop, and allow semantics

Do not compile all non-block actions into the same DNR `allow` action.

In particular:

> A uBlock Origin `noop` rule is not a general allow rule.

A noop rule cancels a matching broader dynamic-filtering decision and allows evaluation to fall through to lower filtering layers. Static filter-list blocking must remain able to block the request.

A naïve high-priority DNR `allow` for noop would bypass static blocking and is incorrect.

Implement a compiler that preserves the effective dynamic-filtering hierarchy. Use exclusions, rule splitting, or an equivalent policy compilation so that a more-specific noop neutralizes only the broader dynamic firewall rule.

At minimum, test these cases:

1. Global third-party block:
   ```text
   * * 3p block
   ```
   blocks third-party requests.

2. Local noop:
   ```text
   page.test * 3p noop
   ```
   neutralizes the global dynamic third-party block on `page.test`.

3. A request still matched by a static filter remains blocked under the local noop.

4. An explicit allow action may bypass lower blocking when upstream semantics say it should.

5. A more-specific destination block overrides the appropriate broader state according to upstream precedence.

6. First-party and third-party script rules do not affect the wrong party.

7. Frame rules affect subframes and objects but not unrelated request types.

8. Inline-script rules have real effect. If exact behavior cannot be represented by one DNR rule, use the existing CSP/content-script policy layer to implement the equivalent; do not display a rule that does nothing.

Base precedence on upstream uBlock Origin’s dynamic filtering engine. Do not invent a simplified fallback chain and call it equivalent.

---

## 7. Fix rule serialization and matrix colors

`buildPopupData()` must return `firewallRules` in the exact shape expected by the popup:

```text
/ * *
. * *
/ destination.example *
. destination.example *
```

and corresponding entries for each built-in request type.

Each returned rule string must retain:

```text
src destination type action
```

The popup must be able to determine:

- effective action;
- global or local source;
- whether the rule is inherited;
- whether the rule is an own rule.

Verify the resulting classes in the live DOM:

```text
allowRule
blockRule
noopRule
ownRule
allowed
blocked
totalAllowed
totalBlocked
```

Do not “fix” colors by applying classes without a real rule or count behind them.

---

## 8. Scope `matrixIsDirty` correctly

The current dirty-state calculation examines global session rule maps too broadly.

Compute dirty state using the same scope as the current popup:

- current source hostname;
- visible destination hostnames;
- relevant built-in type rows;
- current hostname switches.

A temporary rule in another tab or for an unrelated site must not make this popup show save/revert controls.

The dirty calculation must correctly detect removals as well as additions and action changes.

---

## 9. Keep popup data live and internally consistent

Every request, rule change, hostname-switch change, save, revert, or navigation that affects the popup must increment the correct tab revision.

`hasPopupContentChanged` must compare against that revision.

After a rule action:

- return the fully refreshed popup data;
- update the visible cells immediately;
- show the reload button when the new rule requires page reload;
- preserve upstream behavior for save and revert icons.

The following values must agree with one another:

```text
pageCounts
hostnameDict
Domains connected
Blocked on this page
Blocked percentage
toolbar count
compact row signs
row colors
```

Do not use one counter source for the popup total and an unrelated incomplete source for the denominator or hostname rows.

---

# Testing requirements

## A. Unit tests

Add focused tests for:

1. advanced-user setting migration and persistence;
2. per-tab isolation;
3. opening the popup after page load;
4. allowed request counting;
5. blocked request counting;
6. `onErrorOccurred` classification;
7. request-ID deduplication;
8. redirect handling;
9. navigation reset;
10. tab removal cleanup;
11. service-worker state hydration;
12. registrable-domain aggregation;
13. first-party and third-party classification;
14. script and frame counters;
15. count buckets for `+`, `++`, `+++`, `−`, `−−`, `−−−`;
16. rule lookup and inheritance;
17. own-rule detection;
18. dirty-state additions, removals, and unrelated-site isolation;
19. session save and revert semantics;
20. deterministic DNR rule compilation;
21. noop not becoming a broad allow;
22. collision-free session and dynamic rule IDs.

Do not accept tests that only search source text for function names.

The existing `tools/check-dynamic-filtering.mjs` is not sufficient because it mainly checks for strings and hardcoded constants. Upgrade it or supplement it with executable behavioral tests.

## B. Real extension integration tests

Use the repository’s existing Playwright or browser-extension harness.

Create a deterministic local fixture rather than depending only on Google. A suitable setup is:

```text
page.test
first.page.test
assets.test
blocked.test
frames.test
```

Map test hostnames to localhost through the browser’s host-resolver rules and serve controlled:

- scripts;
- images;
- XHR/fetch;
- frames;
- allowed resources;
- resources blocked by a known test static rule.

Test sequence:

1. Launch a clean browser profile with the unpacked built extension.
2. Enable advanced-user mode through the real Settings UI.
3. Navigate to the fixture.
4. Let the fixture finish its network activity.
5. Open the popup only after loading is complete.
6. Verify the popup still contains every observed hostname.
7. Verify two dynamic-filtering columns are visible.
8. Verify built-in rows are visible.
9. Verify real `data-acount` and `data-bcount` attributes.
10. Verify the corresponding signs and status colors.
11. Verify connected-domain and page-block statistics.
12. Click `+ all` and `− all`; verify expansion and persistence.
13. Apply a temporary global block and verify the request is blocked after reload.
14. Apply a local noop and verify only the broader dynamic rule is neutralized.
15. Verify a static-list block remains active under noop.
16. Apply an explicit allow in god mode and verify its intended semantics.
17. Verify the matrix dirty state and save/revert controls.
18. Save and verify the rule appears in `getDynamicRules()`.
19. Create a temporary rule and verify it appears in `getSessionRules()`.
20. Revert and verify the session state and browser rules return to permanent state.
21. Restart or terminate the extension service worker.
22. Reopen the popup and verify counts, settings, and session rules remain correct.
23. Restart the browser and verify permanent rules remain while temporary session rules do not.
24. Open two tabs with different fixtures and prove their hostname rows and dirty states do not contaminate each other.

Also perform a manual smoke check on `google.com`, but do not assert exact Google hostnames or counts because they can vary.

---

# Build and validation

Run the repository’s real commands. At minimum, use the applicable equivalents of:

```bash
npm ci
npm run build
npm run typecheck:ui
npm run typecheck:runtime
npm test
npm run check:source-ownership
npm run check:generated-artifacts
npm run check:dynamic-filtering
npm run test:playwright
npm run check:extension-smoke
npm run check:package-integrity
```

If a listed command does not exist, inspect `package.json`, run the correct repository command, and document the substitution.

After building, prove that:

```text
platform/chromium/popup-fenix.html
platform/chromium/js/popup-fenix-bundle.js
platform/chromium/js/sw.js
```

contain or load the corrected implementation.

Do not report success based only on source files that the manifest does not load.

---

# Non-negotiable constraints

- No hardcoded Google hostnames.
- No hardcoded screenshot counts.
- No literal fake `++` or `−−` strings added to rows.
- No CSS-only imitation.
- No global hostname map used as popup data for every tab.
- No counting failed requests as allowed.
- No dependence on opening the popup before page load.
- No dependence on the logger being open.
- No production dependence on `onRuleMatchedDebug`.
- No noop compiled as a generic allow.
- No permanent rule deletion during an ordinary unpersisted unset.
- No save implementation that fails to propagate removals.
- No revert implementation that merely clears session maps.
- No changes made only to inactive TypeScript prototypes.
- No direct edits to generated popup bundles.
- No “tests” that only grep source code.
- No claim of parity without real browser proof.

Preserve unrelated uBlock Resurrected functionality, including filter lists, element picker, logger, video-specific code, smart cosmetic filtering, and existing settings.

---

# Required final report

When finished, provide:

1. the verified root causes;
2. the active files changed;
3. any new canonical modules created;
4. the data-flow design for per-tab request accounting;
5. the dynamic-rule compilation and noop strategy;
6. the settings migration;
7. the exact commands run;
8. pass/fail output for every required check;
9. the Playwright scenarios executed;
10. confirmation that the built manifest-selected runtime was tested;
11. remaining limitations, if any, stated precisely.

Do not say “implemented” unless the popup matrix changes actual network behavior and the live built extension passes the browser tests.
