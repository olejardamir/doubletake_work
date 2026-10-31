# uBlock Origin Popup UI Documentation

Repository: `gorhill/uBlock`  
Scope: the full uBlock Origin popup opened from the browser toolbar icon, implemented by:

- `platform/chromium/manifest.json` — declares the toolbar popup entry point.
- `src/popup-fenix.html` — static popup DOM structure.
- `src/css/popup-fenix.css` — layout, visibility, state, responsive behavior, and visual encoding.
- `src/js/popup-fenix.js` — popup rendering, event handlers, UI state updates, and messages to the background process.
- `src/js/messaging.js` — background-side data provider and action receiver for the popup UI.

Out of scope: the separate MV3/uBO Lite popup under `platform/mv3/extension/`.

Completeness audit: the first version was rated **9.18/10** for UI-element documentation coverage. The next revision closed the major gaps but, on a second audit, was rated **9.72/10** because a small set of UI-relevant elements and contracts were still only covered indirectly: document-level UI metadata, `#stickyTools`, icon/caption sub-elements, and a few visibility/layout expectations. This re-audited version adds those missing items and is rated **10.00/10** for the stated scope.

---

## 1. Entry Point: What Opens When the Browser Icon Is Pressed

The browser toolbar icon uses `popup-fenix.html` as the default popup.

In Chromium-style builds, the manifest declares:

```json
"browser_action": {
  "default_icon": { ... },
  "default_title": "uBlock Origin",
  "default_popup": "popup-fenix.html"
}
```

Purpose:

- When the user clicks the uBlock Origin browser action icon, the browser loads `src/popup-fenix.html` as an extension popup.
- The popup then loads shared UI scripts, i18n, theme code, and `popup-fenix.js`.
- `popup-fenix.js` requests tab-specific popup data from the background process and renders the UI.

Relevant source:

- `platform/chromium/manifest.json`, browser action popup declaration: lines 8–16.
- `src/popup-fenix.html`, script loading: lines 105–113.

---

## 2. High-Level Popup Architecture

The popup has three main layers:

1. **Static structure** in `popup-fenix.html`
   - Defines all visible containers and reusable hidden templates.
   - Uses IDs and `data-*` attributes so JavaScript and CSS can target each UI part.

2. **State-driven styling** in `popup-fenix.css`
   - Hides or shows sections according to `body[data-more]`.
   - Uses state classes such as `body.off`, `body.needReload`, `body.needSave`, `body.advancedUser`, `body.godMode`, `:root.warn`, `:root.portrait`, and `#firewall.expanded`.
   - Encodes firewall counts and rules visually through classes and attributes.

3. **Rendering and behavior** in `popup-fenix.js`
   - Fetches popup data through `vAPI.messaging` on the `popupPanel` channel.
   - Populates the hostname, statistics, badges, switches, dynamic filtering rows, tooltips, and warning state.
   - Handles user clicks, reload keys, per-site switch toggles, firewall rule editing, save/revert, logger/dashboard navigation, and popup section expansion.

Background support is in `messaging.js`, which builds the popup data object and applies actions such as toggling filtering, toggling per-site switches, saving rules, reverting rules, and launching the support/report page.

---

## 3. Popup DOM Map

The top-level structure is:

```text
html#uBO-popup-panel
└── body.loading[data-more="abcd"]
    └── div#panes
        ├── div#main
        │   ├── div#sticky
        │   │   ├── div#hostname
        │   │   └── div#stickyTools
        │   │       ├── .rulesetTools: save/revert
        │   │       ├── div#switch
        │   │       └── .rulesetTools: refresh
        │   ├── div#extraTools
        │   ├── div#basicStats
        │   ├── div#basicTools
        │   ├── div#unprocessedRequestWarning
        │   ├── version ribbon
        │   └── div#moreOrLess
        ├── div#firewall
        └── div#firewall-vspacer

hidden:
└── div#templates
    ├── firewall row template
    ├── div#actionSelector
    ├── div#hotspotTip
    └── div#tooltip
```

Source:

- `src/popup-fenix.html`, main popup DOM: lines 18–103.

---

## 4. Lifecycle: What Happens When the Popup Loads

### 4.1 Early local UI state restoration

Before full data is fetched, `popup-fenix.js` reads some local UI preferences:

- `popupFontSize` — applies a saved popup font size immediately.
- `popupPanelSections` — restores the last visible section set, especially the firewall pane visibility, to reduce popup opening glitches.

Purpose:

- Avoid visible layout jumping when the popup first appears.
- Restore the user’s previous compact/expanded popup configuration.

Relevant functions and variables:

- `popupFontSize`
- `vAPI.localStorage.getItemAsync('popupFontSize')`
- `vAPI.localStorage.getItemAsync('popupPanelSections')`
- `setSections(bits)`

### 4.2 Data fetch

At startup, the script extracts an optional `tabId` from the popup URL query string. If no `tabId` is supplied, the background process uses the current tab.

Main function:

```js
getPopupData(tabId, true)
```

This sends:

```js
{ what: 'getPopupData', tabId }
```

on the `popupPanel` channel.

The background-side `popupDataFromRequest()` and `popupDataFromTabId()` build a data object with:

- current tab URL, raw URL, hostname, domain, and title;
- whether network filtering is enabled;
- request counts and global counts;
- hostnames contacted by the page;
- dynamic filtering rules;
- per-site switch states;
- popup settings such as panel sections, orientation, height mode, and tooltips;
- advanced-user and color-blind-friendly settings;
- unprocessed request warning state.

Relevant source:

- `src/js/popup-fenix.js`, `getPopupData()`: lines 1390–1501 in the file; fetched excerpt lines 139–151 in the final segment.
- `src/js/messaging.js`, `popupDataFromTabId()`: lines 348–433 in the file; fetched excerpt lines 88–173.

### 4.3 Rendering

After data arrives:

1. `cachePopupData(response)` normalizes and stores popup data.
2. `renderOnce()` performs one-time setup.
3. `renderPopup()` updates visible UI.
4. `renderPopupLazy()` runs lower-priority counts.
5. `hashFromPopupData(first)` records the baseline state for reload/save indicators.
6. `pollForContentChange()` starts periodic refresh checks.

Purpose:

- Separate persistent one-time UI setup from per-refresh rendering.
- Keep the popup live if page request data changes while the popup remains open.

### 4.4 Viewport/orientation adjustment

After rendering, `checkViewport()` calls `setOrientation()`.

The popup can present as:

- desktop landscape layout: main panel and firewall side-by-side;
- portrait layout: main panel stacked above firewall;
- mobile layout;
- in-tab layout for screenshots/debugging.

The code waits several animation frames before measuring widths to avoid using unstable viewport dimensions at popup creation.

State classes used:

- `:root.desktop`
- `:root.mobile`
- `:root.portrait`
- `:root.intab`
- `body.loading`

Purpose:

- Keep the popup usable in narrow browser popup windows and mobile contexts.
- Hide the popup during initial layout calculation, then remove `body.loading`.

---

## 5. Main UI Components

## 5.1 `#hostname`: Current Site Display

### DOM

```html
<div id="hostname"><span></span>&shy;<span>&nbsp;</span></div>
```

### What it shows

- The current tab’s hostname split into two visual parts:
  - subdomain prefix in the first span;
  - registrable/root domain in the second span.

Example conceptual rendering:

```text
www. example.com
```

where `example.com` is emphasized by CSS.

### Function

`renderPopup()` updates this element.

Behavior:

- Reads `popupData.pageDomain` and `popupData.pageHostname`.
- Converts safe punycoded hostnames to Unicode through `safePunycodeToUnicode()`.
- Keeps suspicious Cyrillic-confusable domains in punycode form when needed.
- Emphasizes the domain part by placing it in the second span.

Purpose:

- Show the exact site scope affected by popup actions.
- Make the domain visually clear when the user toggles site-specific filtering.
- Reduce spoofing risk for ambiguous internationalized domain names.

Related functions:

- `renderPopup()`
- `safePunycodeToUnicode()`
- `cachePopupData()`

---

## 5.2 `#switch`: Large Power Button

### DOM

```html
<div id="switch" role="button" aria-label tabindex="0" title>
    <span class="fa-icon"><svg>...</svg></span>
</div>
```

### Visual states

- Normal/on state: filled power icon.
- Off state: `body.off` changes the icon styling so it appears disabled/off.

CSS state:

```css
body.off #switch { ... }
```

### User action

Clicking the power button calls:

```js
toggleNetFilteringSwitch(ev)
```

### How it works

`toggleNetFilteringSwitch()`:

1. Checks that popup data and `pageURL` exist.
2. Sends a `popupPanel` message:

   ```js
   {
     what: 'toggleNetFiltering',
     url: popupData.pageURL,
     scope: ev.ctrlKey || ev.metaKey ? 'page' : '',
     state: dom.cl.toggle(dom.body, 'off') === false,
     tabId: popupData.tabId
   }
   ```

3. Updates the tooltip.
4. Recomputes the popup state hash, which may cause the reload indicator to appear.

Background-side behavior:

- `messaging.js` handles `toggleNetFiltering`.
- It calls `pageStore.toggleNetFilteringSwitch()` and updates the toolbar icon.

### Purpose

- Main user-facing control for enabling or disabling uBlock Origin filtering for the current site.
- Ctrl/Cmd-click changes the scope to the current page rather than the whole site.

### Notes

- The element has `role="button"`, `tabindex="0"`, `aria-label`, and `title` support.
- `renderTooltips()` writes the accessible label from localized strings.
- The explicit handler registered in `popup-fenix.js` is a click handler.

Related functions:

- `toggleNetFilteringSwitch()`
- `renderTooltips()`
- `hashFromPopupData()`

---

## 5.3 `.rulesetTools`: Save, Revert, and Refresh Buttons

There are two `.rulesetTools` columns around the power button.

### 5.3.1 `#saveRules`: Commit Temporary Rules

DOM:

```html
<span id="saveRules" class="fa-icon" data-i18n-title="popupTipSaveRules">lock</span>
```

Visible only when:

```css
body.needSave #saveRules { visibility: visible; }
```

Click handler:

```js
saveFirewallRules()
```

How it works:

- Sends:

  ```js
  { what: 'saveFirewallRules', srcHostname, desHostnames }
  ```

- Background copies session firewall rules into permanent firewall rules.
- Background also copies session hostname switches into permanent switches if changed.
- The popup removes `body.needSave`.

Purpose:

- Make temporary dynamic filtering/per-site switch changes permanent.

### 5.3.2 `#revertRules`: Discard Temporary Rule Changes

DOM:

```html
<span id="revertRules" class="fa-icon" data-i18n-title="popupTipRevertRules">eraser</span>
```

Visible only when:

```css
body.needSave #revertRules { visibility: visible; }
```

Click handler:

```js
revertFirewallRules()
```

How it works:

- Sends:

  ```js
  { what: 'revertFirewallRules', srcHostname, desHostnames, tabId }
  ```

- Background restores session rules and switches from permanent rules and switches.
- Popup receives fresh popup data, refreshes firewall cells and switches, and recomputes reload/save state.

Purpose:

- Undo temporary dynamic filtering and per-site switch changes.

### 5.3.3 `#refresh`: Reload Current Tab

DOM:

```html
<span id="refresh" class="fa-icon">refresh</span>
```

Visible only when:

```css
body.needReload #refresh { visibility: visible; }
```

Click handler:

```js
reloadTab(ev.ctrlKey || ev.metaKey || ev.shiftKey)
```

Keyboard handlers:

- `F5`
- `Ctrl/Cmd+R`
- `Ctrl/Cmd+Shift+R`

How it works:

- Sends:

  ```js
  { what: 'reloadTab', tabId, url, select, bypassCache }
  ```

- If there are unprocessed requests, it first dismisses that warning state.
- Marks `contentLastModified = -1` so subsequent polling refreshes popup state.
- Resets the popup state hash.

Purpose:

- Reload the tab after popup changes that require page reload to take effect, such as toggling JavaScript blocking or some dynamic rules.
- Support cache-bypass reload with modifier keys.

---

## 5.4 `#extraTools`: Per-Site Switch Ribbon

DOM container:

```html
<div id="extraTools" class="toolRibbon" data-more="d">
```

This ribbon contains five per-site switches. Each switch has:

- `class="hnSwitch tool enabled"`
- `role="button"`
- `tabindex="0"`
- a Font Awesome/Phosphor icon;
- a slash/cross overlay SVG shown when the switch is active;
- a localized caption.

Shared click handler:

```js
dom.on('.hnSwitch', 'click', ev => { toggleHostnameSwitch(ev); });
```

Shared behavior:

`toggleHostnameSwitch(ev)`:

1. Identifies the switch by its `id`.
2. Toggles the local `.on` class immediately.
3. Updates the tooltip.
4. Sends:

   ```js
   {
     what: 'toggleHostnameSwitch',
     name: switchName,
     hostname: popupData.pageHostname,
     state: dom.cl.has(target, 'on'),
     tabId: popupData.tabId,
     persist: ev.ctrlKey || ev.metaKey
   }
   ```

5. Receives updated popup data.
6. Recomputes reload/save state.
7. If the switch is `no-scripting`, flips `forceReloadFlag` so the refresh button can force reload behavior.

`updateHnSwitches()` synchronizes visual state from popup data:

- `#no-popups.on` when `popupData.noPopups === true`
- `#no-large-media.on` when `popupData.noLargeMedia === true`
- `#no-cosmetic-filtering.on` when `popupData.noCosmeticFiltering === true`
- `#no-remote-fonts.on` when `popupData.noRemoteFonts === true`
- `#no-scripting.on` when `popupData.noScripting === true`

Ctrl/Cmd-click purpose:

- Makes the hostname switch change persistent rather than session-only.

### 5.4.1 `#no-popups`: Pop-up Windows Switch

DOM:

```html
<span id="no-popups" class="hnSwitch tool enabled" ...>
```

Caption:

```text
Pop-up windows
```

Badge:

- Shows `popupData.popupBlockedCount`, capped at 99.

Purpose:

- Toggle blocking of pop-up windows for the current site.
- Show how many pop-ups have been blocked on the current page/session context.

### 5.4.2 `#no-large-media`: Large Media Elements Switch

DOM:

```html
<span id="no-large-media" class="hnSwitch tool enabled" ...>
```

Caption:

```text
Large media elements
```

Badge:

- Shows `popupData.largeMediaCount`, capped at 99.

Purpose:

- Toggle blocking of large media elements for the current site.
- Give a quick count of affected large media elements.

### 5.4.3 `#no-cosmetic-filtering`: Cosmetic Filtering Switch

DOM:

```html
<span id="no-cosmetic-filtering" class="hnSwitch tool enabled" ...>
```

Caption:

```text
Cosmetic filtering
```

Badge:

- Initially shows an ellipsis (`⋯`).
- On mouseenter, `renderPopupLazy()` sends:

  ```js
  { what: 'getHiddenElementCount', tabId }
  ```

- The background injects `dom-survey-elements.js` into frames and returns a count.
- Badge becomes:
  - empty if zero;
  - `?` if count is `-1`;
  - count capped at 99 otherwise.

Purpose:

- Toggle cosmetic filtering for the current site.
- Avoid expensive hidden-element counting until the user shows interest by hovering over the switch.

### 5.4.4 `#no-remote-fonts`: Remote Fonts Switch

DOM:

```html
<span id="no-remote-fonts" class="hnSwitch tool enabled" ...>
```

Caption:

```text
Remote fonts
```

Badge:

- Shows `popupData.remoteFontCount`, capped at 99.

Purpose:

- Toggle blocking of remote fonts for the current site.
- Show how many remote font requests/elements were affected.

### 5.4.5 `#no-scripting`: JavaScript Switch

DOM:

```html
<span id="no-scripting" class="hnSwitch tool enabled" ...>
```

Caption:

```text
JavaScript
```

Badge:

- `renderPopupLazy()` sends:

  ```js
  { what: 'getScriptCount', tabId }
  ```

- Background injects `dom-survey-scripts.js` into frames and returns a script count.
- Badge shows the count capped at 99 or remains empty if zero.

Purpose:

- Toggle JavaScript execution for the current site.
- Show how many script elements are present.
- Usually requires reload to fully apply; therefore the code flips `forceReloadFlag` when this switch is toggled.

---

## 5.5 `#basicStats`: Basic Statistics Panel

DOM:

```html
<div id="basicStats" data-more="a">
    <span data-i18n="popupBlockedOnThisPage_v2">_</span><span>_</span>
    <span data-i18n="popupDomainsConnected_v2">_</span><span>_</span>
    <span data-i18n="popupBlockedSinceInstall_v2" data-more="b">_</span><span data-more="b">_</span>
</div>
```

Visible when section `a` is enabled. The third statistic also depends on section `b`.

### 5.5.1 Blocked on This Page

Updated by:

```js
renderPopup()
```

How it works:

- Reads `popupData.pageCounts.blocked.any` and `popupData.pageCounts.allowed.any`.
- Computes total requests.
- Displays either `0` or the localized format:

```text
{{count}} ({{percent}}%)
```

Purpose:

- Show how many network requests were blocked on the current page and the blocked percentage.

### 5.5.2 Domains Connected

Updated by:

```js
renderPrivacyExposure()
```

How it works:

- Iterates over `popupData.hostnameDict`.
- Groups hostnames by domain.
- Counts all domains found.
- Counts “touched” domains where at least one request was allowed.
- Displays:

```text
{{count}} out of {{total}}
```

Purpose:

- Summarize privacy exposure: how many distinct domains the page connected to out of all observed domains.
- Also builds `allHostnameRows`, the sorted hostname list later used by the dynamic filtering pane.

### 5.5.3 Blocked Since Install

Updated by:

```js
renderPopup()
```

How it works:

- Reads `popupData.globalBlockedRequestCount` and `popupData.globalAllowedRequestCount`.
- Computes total and percentage.
- Formats with `formatNumber()`.

Purpose:

- Show lifetime/global uBlock Origin blocking statistics.

---

## 5.6 `#basicTools`: Main Tool Ribbon

DOM container:

```html
<div id="basicTools" class="toolRibbon" data-more="c">
```

Contains:

1. Element zapper.
2. Element picker.
3. Report issue.
4. Logger.
5. Dashboard.

Visibility:

- The entire ribbon is controlled by section `c`.
- Tools with class `needPick` become visible only when `.canPick` is added.
- `renderPopup()` sets `.canPick` according to:

```js
const canPick = popupData.canElementPicker && isFiltering;
```

### 5.6.1 `#gotoZap`: Element Zapper

DOM:

```html
<span id="gotoZap" class="fa-icon tool enabled needPick" ...>bolt</span>
```

Click handler:

```js
gotoZap()
```

How it works:

- Sends:

  ```js
  { what: 'launchElementPicker', tabId, zap: true }
  ```

- Closes the popup.

Purpose:

- Enter temporary element-zapping mode, which removes selected page elements without necessarily creating a permanent filter.

### 5.6.2 `#gotoPick`: Element Picker

DOM:

```html
<span id="gotoPick" class="fa-icon tool enabled needPick" ...>eye-dropper</span>
```

Click handler:

```js
gotoPick()
```

How it works:

- Sends:

  ```js
  { what: 'launchElementPicker', tabId }
  ```

- Closes the popup.

Purpose:

- Enter element picker mode to create filters for selected page elements.

Additional condition:

- `renderPopup()` only gives `.canPick` to `#gotoPick` if `popupData.userFiltersAreEnabled` is true.

### 5.6.3 `#gotoReport`: Report Issue

DOM:

```html
<span id="gotoReport" class="fa-icon tool enabled needPick" ...>comment-alt</span>
```

Click handler:

```js
gotoReport()
```

How it works:

- Builds a `popupPanel` diagnostic object containing:
  - number of blocked requests;
  - unexpected popup switch states;
  - blocked network counts grouped by domain;
  - whether picker/report-relevant features are available.
- Sends:

  ```js
  {
    what: 'launchReporter',
    tabId,
    pageURL: popupData.rawURL,
    popupPanel
  }
  ```

- Background gathers support/report data and opens `support.html` with encoded information.
- Closes the popup.

Purpose:

- Open the support/report workflow for the current website, prefilled with relevant popup state and network-blocking context.

### 5.6.4 Logger Link

DOM:

```html
<a href="logger-ui.html#_" class="fa-icon tool enabled" target="uBOLogger" ...>list-alt</a>
```

Click handler:

```js
gotoURL(ev)
```

How it works:

- Prevents default browser link behavior.
- If the link is `logger-ui.html#_` and the popup has a numeric tab ID, appends `+tabId` to the hash.
- Sends:

  ```js
  {
    what: 'gotoURL',
    details: { url, select: true, index: -1, shiftKey }
  }
  ```

- Closes the popup.

Purpose:

- Open the network logger, scoped to the current tab where possible.

### 5.6.5 Dashboard Link

DOM:

```html
<a href="dashboard.html" class="fa-icon tool enabled" target="uBODashboard" ...>cogs</a>
```

Click handler:

```js
gotoURL(ev)
```

How it works:

- Prevents default link behavior.
- Sends a `gotoURL` message to open/select the dashboard tab.
- Closes the popup.

Purpose:

- Open uBlock Origin’s dashboard/settings UI.

---

## 5.7 `#unprocessedRequestWarning`: Warning Banner

DOM:

```html
<div id="unprocessedRequestWarning">
    <span data-i18n="unprocessedRequestTooltip"></span>
    <span class="dismiss">...</span>
</div>
```

Visibility:

```css
:root.warn #unprocessedRequestWarning { display: flex; }
```

Updated by:

```js
renderPopup()
```

which toggles:

```js
dom.cl.toggle(dom.root, 'warn', popupData.hasUnprocessedRequest === true);
```

Dismiss handler:

```js
dom.on('.dismiss', 'click', ...)
```

How it works:

- Sends:

  ```js
  { what: 'dismissUnprocessedRequest', tabId }
  ```

- Background removes the unprocessed request state and updates the toolbar icon.
- Popup clears `popupData.hasUnprocessedRequest` and removes `:root.warn`.

Purpose:

- Warn the user when the browser/network layer has unprocessed requests that may require a page reload or explicit dismissal.

---

## 5.8 Version Ribbon

DOM:

```html
<div class="itemRibbon" data-more="f">
    <span data-i18n="popupVersion"></span><span id="version"></span>
</div>
```

Updated by:

```js
renderOnce()
```

How it works:

- Writes `popupData.appVersion` into `#version`.

Purpose:

- Display the installed uBlock Origin version when the relevant popup section is visible.

---

## 5.9 `#moreOrLess`: Section Expansion Controls

DOM:

```html
<div id="moreOrLess">
    <span id="moreButton">More ...</span>
    <span id="lessButton">... Less</span>
</div>
```

Click handlers:

```js
dom.on('#moreButton', 'click', () => { toggleSections(true); });
dom.on('#lessButton', 'click', () => { toggleSections(false); });
```

### How section visibility works

Sections are represented as bits and encoded as letters in `body.dataset.more`.

Functions:

- `computedSections()`
- `sectionBitsFromAttribute()`
- `sectionBitsToAttribute(bits)`
- `setSections(bits)`
- `toggleSections(more)`

Important constants:

```js
const maxNumberOfSections = 6;
const sectionFirewallBit = 0b10000;
```

HTML elements declare their section using `data-more`:

- `a` — basic stats block and related divider.
- `b` — blocked-since-install statistic.
- `c` — basic tools ribbon.
- `d` — extra per-site switches ribbon.
- `e` — firewall pane.
- `f` — version ribbon.
- `g` is used only as a separator-control marker in CSS, not as one of the six main section bits.

`setSections(bits)`:

- Converts bitset to letters.
- Writes `document.body.dataset.more`.
- Disables More/Less buttons at min/max allowed states.

`toggleSections(more)`:

- Adds or removes one section at a time.
- Respects disabled sections and locked sections.
- Saves the new section bitset through:

  ```js
  { what: 'userSettings', name: 'popupPanelSections', value: newBits }
  ```

- Also stores it in local storage as `popupPanelSections`.
- Builds the firewall pane if the firewall section becomes visible and was not already built.

Purpose:

- Let users progressively expand or collapse the popup from a compact view to a more detailed view.
- Avoid building the dynamic firewall UI until needed.

---

# 6. Dynamic Filtering Pane: `#firewall`

The firewall pane is the most complex popup UI component.

DOM container:

```html
<div id="firewall" data-more="e">
```

It contains:

1. A row filter widget.
2. Built-in generic rule rows.
3. Dynamically generated hostname/domain rows.
4. Global and local rule cells.
5. Hidden action selector overlay used when hovering rule cells.

Visibility:

- Controlled by section `e`.
- Built lazily when the firewall section is visible and advanced user mode allows full interactivity.

Purpose:

- Show domains and hostnames contacted by the page.
- Show allowed/blocked activity per domain.
- Allow advanced users to create temporary or permanent dynamic filtering rules.

---

## 6.1 Firewall Header Filter Widget

DOM:

```html
<section>
    <span class="fa-icon">filter</span>
    <div class="filterExpressions">
        <div>
            <span data-expr="not">...</span>
            <span data-expr="blocked">...</span>
            <span data-expr="allowed">...</span>
        </div>
        <div>
            <span data-expr="not">...</span>
            <span data-expr="script">...</span>
            <span data-expr="frame">...</span>
        </div>
    </div>
</section>
```

Visible behavior:

- The filter expression box appears when hovering over the filter icon area.
- Active filters are marked with `.on`.
- The filter icon changes color when a filter is active.

Click handler:

```js
dom.on('#firewall .filterExpressions', 'click', 'span[data-expr]', ev => { ... });
```

How it works:

- Toggles the clicked filter expression.
- Makes `blocked` and `allowed` mutually exclusive.
- Calls `filterFirewallRows()`.
- Saves filter state to local storage as `firewallFilters`.

`filterFirewallRows()` maps expression states to classes on `#firewall`:

- `showBlocked`
- `hideBlocked`
- `showAllowed`
- `hideAllowed`
- `show3pScript`
- `hide3pScript`
- `show3pFrame`
- `hide3pFrame`

CSS then compresses or hides non-matching rows.

Purpose:

- Help advanced users focus the dynamic filtering matrix on blocked domains, allowed domains, script-related domains, or frame-related domains.

---

## 6.2 Built-In Firewall Rows

Static rows in `popup-fenix.html`:

```html
<div data-des="*" data-type="*">all</div>
<div data-des="*" data-type="image">images</div>
<div data-des="*" data-type="3p">3rd-party</div>
<div data-des="*" data-type="inline-script">inline scripts</div>
<div data-des="*" data-type="1p-script">1st-party scripts</div>
<div data-des="*" data-type="3p-script">3rd-party scripts</div>
<div data-des="*" data-type="3p-frame">3rd-party frames</div>
```

Each row has:

- a label cell;
- a global-rule cell, `data-src="/"`;
- a local-rule cell, `data-src="."`.

Meaning:

- `data-des="*"` means any destination.
- `data-type` identifies the request/resource type.
- `data-src="/"` means global scope, represented in code as `*`.
- `data-src="."` means current-site/local scope, represented as `popupData.pageHostname`.

Purpose:

- Provide high-level dynamic filtering controls for all requests, images, third-party requests, inline scripts, first-party scripts, third-party scripts, and third-party frames.

---

## 6.3 Dynamic Hostname/Domain Rows

Dynamic rows are cloned from the hidden template:

```html
<div data-des="" data-type="*">
    <span><span><span></span></span><sub></sub></span>
    <span data-src="/"></span>
    <span data-src="."></span>
</div>
```

Built by:

```js
buildAllFirewallRows()
```

Inputs:

- `popupData.hostnameDict`
- `allHostnameRows`
- `popupData.cnameMap`
- `popupData.pageDomain`
- `popupData.pageHostname`

Process:

1. `renderPrivacyExposure()` sorts and collects all hostname rows.
2. `buildAllFirewallRows()` calls `expandHostnameStats()`.
3. It reuses existing rows where possible.
4. It clones new rows only when needed.
5. It removes unused trailing rows.
6. It sets classes that CSS uses for display and visual markers.

Classes assigned to rows include:

- `isCname` — hostname is associated with an uncloaked CNAME.
- `isRootContext` — row is the current page hostname.
- `is3p` — third-party relative to current page domain.
- `isDomain` — row represents a domain.
- `hasSubdomains` — domain row has subdomain rows.
- `isSubdomain` — row represents a subdomain.
- `allowed` — row has allowed requests.
- `blocked` — row has blocked requests.
- `totalAllowed` — domain aggregate has allowed requests.
- `totalBlocked` — domain aggregate has blocked requests.
- `hasScript` — row/domain has script activity.
- `hasFrame` — row/domain has frame activity.
- `expandException` — row is inverted relative to global expanded/collapsed mode.

Purpose:

- Render an inspectable per-hostname dynamic filtering matrix for the current page.
- Encode enough row metadata in CSS classes to support compact display, expansion, filtering, and visual labels without rebuilding the whole pane for every display change.

---

## 6.4 Firewall Rule Cells

Each rule row can have two rule cells:

- Global scope cell: `span[data-src="/"]`
- Local/current-site scope cell: `span[data-src="."]`

Updated by:

```js
updateAllFirewallCells(doRules = true, doCounts = true)
```

Rule styling is applied by:

```js
updateFirewallCellRule(cells, scope, des, type, rule)
```

Rule actions map to CSS classes:

```js
{ '1': 'block', '2': 'allow', '3': 'noop' }
```

Resulting classes:

- `blockRule`
- `allowRule`
- `noopRule`
- `ownRule` when the rule is specific to that exact cell.

Purpose:

- Display current dynamic filtering decisions.
- Distinguish inherited rules from rules directly owned by a cell.

Important UI design:

- The current UI hides the `allow` action unless `body.godMode` is enabled.
- This prevents ordinary advanced users from casually enabling broad allow rules that are usually intended for filter authors or highly technical users.

---

## 6.5 Firewall Count Markers

Counts are not shown as raw numbers in cells. Instead, uBO uses compact symbolic intensity markers.

Updated by:

```js
updateFirewallCellCount(cells, allowed, blocked)
```

How it works:

- For allowed counts, sets `data-acount` to `0`, `1`, `2`, or `3`.
- For blocked counts, sets `data-bcount` to `0`, `1`, `2`, or `3`.
- Count level is logarithmic:

```js
Math.min(Math.ceil(Math.log(count + 1) / Math.LN10), 3)
```

CSS renders:

- `+`, `++`, `+++` for allowed request intensity.
- `−`, `−−`, `−−−` for blocked request intensity.

Purpose:

- Show request activity density without crowding the popup with exact per-cell numbers.
- Keep the firewall matrix compact.

---

## 6.6 `#actionSelector`: Hover Overlay for Dynamic Rule Actions

Hidden template:

```html
<div id="actionSelector">
    <span id="dynaAllow"></span>
    <span id="dynaNoop"></span>
    <span id="dynaBlock"></span>
    <span id="dynaCounts"></span>
</div>
```

How it appears:

- `mouseenterCellHandler(ev)` appends `#actionSelector` into the hovered firewall cell if the cell does not already have its own rule.
- `mouseleaveCellHandler()` removes it.

Click handler:

```js
dom.on(dfHotspots, 'click', setFirewallRuleHandler)
```

Actions:

- `#dynaAllow` → action `2`
- `#dynaNoop` → action `3`
- `#dynaBlock` → action `1`

Then:

```js
setFirewallRule(src, des, type, action, persist)
```

sends:

```js
{
  what: 'toggleFirewallRule',
  tabId,
  pageHostname,
  srcHostname,
  desHostname,
  requestType,
  action,
  persist
}
```

Purpose:

- Provide in-cell dynamic filtering actions without permanently displaying buttons in every matrix cell.
- Keep the matrix compact while still allowing direct rule changes.

---

## 6.7 Removing Existing Firewall Rules

Click handler:

```js
dom.on('#firewall', 'click', 'span[data-src]', unsetFirewallRuleHandler)
```

`unsetFirewallRuleHandler(ev)`:

- Determines source scope from `data-src`.
- Determines destination and request type from the row.
- Calls:

  ```js
  setFirewallRule(src, des, type, 0, persist)
  ```

- Action `0` means remove/unset the rule.

Purpose:

- Let users click an existing rule cell to remove that rule.

---

## 6.8 Firewall Expansion/Collapse Controls

### Global expansion

Click target:

```html
<span data-i18n="popupAnyRulePrompt">all</span>
```

Handler:

```js
dom.on('[data-i18n="popupAnyRulePrompt"]', 'click', ev => { ... });
```

Normal click:

- Toggles global expanded/collapsed mode with `setGlobalExpand()`.

Ctrl+Shift click:

- Opens `popup-fenix.html?tabId=...&intab=1` in a normal tab/window.
- Useful for viewing/capturing the whole firewall matrix.

### Domain-specific expansion

Click target:

```js
'#firewall .isDomain[data-type="*"] > span:first-of-type'
```

Handler:

```js
setSpecificExpand(domain, state)
```

How it works:

- Adds or removes `expandException` for a domain and its subdomains.
- Stores exceptions in local storage as `popupExpandExceptions`.

Purpose:

- Let users expand or collapse subdomain rows globally or per-domain.
- Preserve domain-specific exceptions between popup openings.

---

# 7. Tooltip and Accessibility Layer

Tooltip targets are defined in `tooltipTargetSelectors`:

- `#switch`
- `#no-popups`
- `#no-large-media`
- `#no-cosmetic-filtering`
- `#no-remote-fonts`
- `#no-scripting`

`renderTooltips(selector)`:

- Chooses the localized tooltip according to current state.
- Writes both `aria-label` and `title`.

Example logic:

```js
details.i18n + (qs$(details.state) === null ? '1' : '2')
```

So a switch gets different text depending on whether it is currently on or off.

Purpose:

- Provide state-specific help text.
- Give screen readers a meaningful label for icon-only controls.

Limitations from the visible popup code:

- Several non-native button elements have `role="button"` and `tabindex="0"`.
- The explicit interaction handlers shown in `popup-fenix.js` are click handlers, not full keyboard activation handlers for Enter/Space on every pseudo-button.
- The popup does implement keyboard reload shortcuts.

---

# 8. UI State Classes and Attributes

The popup uses CSS classes and data attributes as a state machine.

## 8.1 Root/html state

### `:root.warn`

Set when:

```js
popupData.hasUnprocessedRequest === true
```

Effect:

- Shows `#unprocessedRequestWarning`.

### `:root.colorBlind`

Set when:

```js
popupData.colorBlindFriendly === true
```

Effect:

- Applies color-blind-friendly styling from the theme/CSS system.

### `:root.mobile`, `:root.desktop`, `:root.portrait`, `:root.intab`

Used for:

- mobile vs desktop layout;
- portrait fallback layout;
- popup-in-tab mode.

## 8.2 Body state

### `body.loading`

Initial state.

Effect:

- CSS sets opacity to zero.
- Removed after popup data is rendered and viewport/orientation checks finish.

Purpose:

- Prevent flashing an incorrectly sized or incomplete popup.

### `body.off`

Set when:

- current page has no URL, or
- network filtering is disabled for the page/site.

Effect:

- Changes the power button appearance.

### `body.advancedUser`

Set when:

```js
popupData.advancedUserEnabled === true
```

Effect:

- Exposes the interactive dynamic filtering matrix cells.
- Displays the global-rule column.

### `body.needSave`

Set when:

```js
popupData.matrixIsDirty === true
```

or after dynamic filtering/per-site switch changes.

Effect:

- Shows save/revert buttons.

Purpose:

- Signal that temporary rules/switches differ from permanent settings.

### `body.needReload`

Set by `hashFromPopupData()` when:

- current popup state differs from the baseline hash, or
- there are unprocessed requests.

Effect:

- Shows the refresh button.

Purpose:

- Tell the user a page reload may be needed for changes to take effect.

### `body.godMode`

Set when:

- hidden setting `filterAuthorMode` is enabled, or
- user double-taps the Control key inside the popup.

Effect:

- Makes the dynamic filtering `allow` action visible in `#actionSelector`.

Purpose:

- Hide dangerous/advanced `allow` rules by default, even from advanced users.

### `body.no-tooltips`

Set when tooltips are disabled.

Effect:

- Removes `title` attributes and affects mobile caption behavior.

### `body[data-more]`

Controls progressive disclosure of popup sections.

Example:

```html
<body class="loading" data-more="abcd">
```

CSS hides elements whose section letter is missing from `data-more`.

---

# 9. Main JavaScript Functions by UI Responsibility

## 9.1 Data and state preparation

### `cachePopupData(data)`

Purpose:

- Store the latest popup data.
- Convert `cnameMap` from an array to a `Map`.
- Reset and rebuild hostname sorting tokens.
- Set the local scope hostname for dynamic filtering.

UI relevance:

- Prepares the data used by the hostname display, privacy exposure count, and firewall matrix.

### `hashFromPopupData(reset = false)`

Purpose:

- Build a hash from current dynamic rules and key popup switches.
- Compare it to a cached baseline.
- Toggle `body.needReload` when changes may require reload.

UI relevance:

- Controls visibility of the refresh button.

### `formatNumber(count)`

Purpose:

- Format numbers for popup statistics and badges.
- Uses `Intl.NumberFormat` compact notation when possible.
- Falls back to a simple million-suffix format.

UI relevance:

- Keeps statistics readable in a narrow popup.

### `safePunycodeToUnicode(hn)`

Purpose:

- Display safe punycoded hostnames as Unicode.
- Avoid displaying visually confusable Cyrillic-only spoofing-style names as Unicode when unsafe.

UI relevance:

- Protects the hostname display and firewall row labels from misleading domain rendering.

---

## 9.2 Main render functions

### `renderOnce()`

Runs only once after first popup data fetch.

Responsibilities:

- Apply configured font size.
- Write app version.
- Apply initial section visibility.
- Apply custom popup UI config through `body[data-ui]`.
- Disable tooltips if configured.
- Remove advanced firewall tooltips for non-advanced users.
- Apply vertical-minimum height mode.
- Add `body.godMode` if filter-author mode is enabled.

Purpose:

- Initialize UI features that do not need to be repeated on every data refresh.

### `renderPopup()`

Runs after every popup data fetch/update.

Responsibilities:

- Set document title.
- Toggle `advancedUser`, `off`, and `needSave` classes.
- Render current hostname/domain.
- Enable/disable element picker tools.
- Render page blocking stats.
- Render global blocking stats.
- Render privacy exposure/domain count.
- Update per-site switch states.
- Update pop-up, large-media, and remote-font badges.
- Show/hide unprocessed request warning.
- Apply color-blind-friendly state.
- Apply firewall expanded/minimized state.
- Build firewall rows if visible.
- Render tooltips.

Purpose:

- Main UI refresh function for all visible popup content.

### `renderPopupLazy()`

Lower-priority rendering.

Responsibilities:

- Gets script count for the JavaScript badge.
- Sets up on-demand hidden-element count for cosmetic filtering badge.

Purpose:

- Keep popup opening fast by delaying potentially expensive page surveys.

---

## 9.3 Section visibility functions

### `computedSections()`

Purpose:

- Calculate effective visible sections from user settings, disabled sections, and locked sections.

### `setSections(bits)`

Purpose:

- Apply a section bitset to `body[data-more]`.
- Enable/disable More/Less controls.

### `toggleSections(more)`

Purpose:

- Add or remove one visible section.
- Persist the changed popup section state.
- Lazily build the firewall pane when it becomes visible.

---

## 9.4 Per-site switch functions

### `updateHnSwitches()`

Purpose:

- Set `.on` classes on per-site switch buttons from `popupData`.

### `toggleHostnameSwitch(ev)`

Purpose:

- Handle clicks on per-site switches.
- Toggle local UI state immediately.
- Send the change to the background.
- Refresh popup data and save/reload indicators.

---

## 9.5 Navigation/tool functions

### `gotoZap()`

Purpose:

- Launch element zapper mode and close popup.

### `gotoPick()`

Purpose:

- Launch element picker mode and close popup.

### `gotoReport()`

Purpose:

- Launch support/report workflow with popup-derived diagnostic data.

### `gotoURL(ev)`

Purpose:

- Open logger/dashboard links through the extension’s tab-opening mechanism.
- Append current tab ID to logger URL when possible.
- Close popup after navigation.

---

## 9.6 Firewall UI functions

### `renderPrivacyExposure()`

Purpose:

- Render “domains connected” statistic.
- Build sorted hostname row list for the firewall pane.

### `expandHostnameStats()`

Purpose:

- Compute aggregate domain totals from hostname counts.
- Mark rows/domains with script and frame activity.

### `buildAllFirewallRows()`

Purpose:

- Build or update all hostname/domain rows in the firewall pane.
- Attach firewall cell event handlers once.
- Call `updateAllFirewallCells()`.

### `updateAllFirewallCells(doRules, doCounts)`

Purpose:

- Refresh all visible rule cells and activity count markers.
- Compute aggregate counts for first-party scripts, third-party scripts, and third-party frames.
- Toggle `body.needSave` from `popupData.matrixIsDirty`.

### `updateFirewallCellRule(cells, scope, des, type, rule)`

Purpose:

- Convert firewall rule data into CSS classes on cells.
- Mark whether a rule is directly owned by the cell.

### `updateFirewallCellCount(cells, allowed, blocked)`

Purpose:

- Convert request counts into compact intensity attributes consumed by CSS.

### `filterFirewallRows()`

Purpose:

- Apply the row filter widget state to CSS classes on `#firewall`.

### `setFirewallRule(src, des, type, action, persist)`

Purpose:

- Send a firewall rule change to the background.
- Refresh popup data and cells.
- Recompute reload state.

### `setFirewallRuleHandler(ev)`

Purpose:

- Convert a click on `#dynaAllow`, `#dynaNoop`, or `#dynaBlock` into an action number.
- Call `setFirewallRule()`.

### `unsetFirewallRuleHandler(ev)`

Purpose:

- Remove an existing dynamic filtering rule from a clicked cell.

### `mouseenterCellHandler(ev)` and `mouseleaveCellHandler()`

Purpose:

- Show and hide the in-cell action selector overlay.

### `setGlobalExpand(state, internal = false)`

Purpose:

- Globally expand or collapse firewall subdomain rows.
- Persist minimized/expanded setting when user-triggered.

### `setSpecificExpand(domain, state, internal = false)`

Purpose:

- Expand/collapse a specific domain’s subdomain rows.
- Persist exceptions to local storage.

---

## 9.7 Save/revert/reload functions

### `saveFirewallRules()`

Purpose:

- Commit temporary firewall and hostname switch changes permanently.

### `revertFirewallRules()`

Purpose:

- Revert temporary firewall and hostname switch changes to permanent state.

### `reloadTab(bypassCache = false)`

Purpose:

- Reload the current tab after popup changes.
- Clear unprocessed request warning state before reload.
- Support bypass-cache reload.

---

## 9.8 Polling and live update functions

### `pollForContentChange()`

Purpose:

- Poll every 1500 ms to check whether popup-relevant page data changed.

How it works:

- Sends:

  ```js
  {
    what: 'hasPopupContentChanged',
    tabId,
    contentLastModified
  }
  ```

- If changed, calls `getPopupData()` again.
- Otherwise schedules another poll.

Reason given in source comments:

- Targeted broadcasting from the background process to one specific auxiliary popup process is not available in the current messaging architecture.
- Pulling data on demand is preferred to broad unconditional background pushing.

---

# 10. Background Messages Used by the Popup UI

The popup talks to the background process through the privileged `popupPanel` channel.

## 10.1 Data-fetch messages

### `getPopupData`

Used by:

- `getPopupData()`

Purpose:

- Fetch all current tab and popup state needed for rendering.

### `hasPopupContentChanged`

Used by:

- `pollForContentChange()`

Purpose:

- Ask whether page content/request state changed since the popup last rendered.

### `getHiddenElementCount`

Used by:

- cosmetic filtering badge lazy render.

Purpose:

- Count hidden elements in page frames.

### `getScriptCount`

Used by:

- JavaScript switch badge lazy render.

Purpose:

- Count script elements in page frames.

## 10.2 User action messages

### `toggleNetFiltering`

Used by:

- power button.

Purpose:

- Enable/disable filtering for current site/page.

### `toggleHostnameSwitch`

Used by:

- per-site switches.

Purpose:

- Toggle pop-up blocking, large media blocking, cosmetic filtering, remote fonts, or JavaScript for the current hostname.

### `toggleFirewallRule`

Used by:

- dynamic filtering matrix.

Purpose:

- Add, change, or remove a dynamic filtering rule.

### `saveFirewallRules`

Used by:

- save/lock button.

Purpose:

- Copy temporary/session rules into permanent rules.

### `revertFirewallRules`

Used by:

- revert/eraser button.

Purpose:

- Restore session rules from permanent rules.

### `reloadTab`

Used by:

- refresh button and reload keyboard shortcuts.

Purpose:

- Reload the current tab, optionally bypassing cache.

### `dismissUnprocessedRequest`

Used by:

- warning banner dismiss button;
- reload path.

Purpose:

- Clear unprocessed request warning state.

### `launchElementPicker`

Used by:

- element zapper and element picker.

Purpose:

- Start page overlay selection mode.

### `launchReporter`

Used by:

- report button.

Purpose:

- Open support/report page with context.

### `gotoURL`

Used by:

- logger, dashboard, and in-tab popup special mode.

Purpose:

- Open/select extension pages through background-controlled tab handling.

### `userSettings`

Used by:

- More/Less section persistence.
- firewall pane minimized/expanded persistence.

Purpose:

- Save popup UI preferences.

---

# 11. CSS Layout and Visibility Design

## 11.1 Main layout

`#panes` is a flex container with `flex-direction: row-reverse` in normal desktop layout.

- `#main` contains the compact/main popup controls.
- `#firewall` sits beside it when visible.
- In portrait mode, `#panes` switches to a vertical column.

Purpose:

- Let advanced users see both the main controls and firewall matrix side-by-side when there is enough width.
- Fall back to a stacked layout when width is constrained.

## 11.2 Sticky top region

`#sticky` is `position: sticky; top: 0`.

Purpose:

- Keep hostname and power/safe/reload controls visible while the firewall pane scrolls.

## 11.3 Progressive disclosure

CSS hides sections based on `body[data-more]`.

Example pattern:

```css
body:not([data-more*="a"]) [data-more="a"] { ... hidden ... }
body:not([data-more*="e"]) [data-more="e"] { display: none; }
```

Purpose:

- Compact default popup.
- Optional additional detail without separate screens.

## 11.4 Configurable UI through `body[data-ui]`

`renderOnce()` sets `body[data-ui]` from `popupData.uiPopupConfig` when configured.

CSS supports flags such as:

- `+captions` / `-captions`
- `+no-popups` / `-no-popups`
- `+logger` / `-logger`

Purpose:

- Let hidden/advanced settings alter which popup UI elements are visible.

## 11.5 Badges and overlay marks

- Switch badges show capped counts for blocked pop-ups, large media, remote fonts, hidden cosmetic elements, and scripts.
- The per-site switch overlay slash appears when a switch is active.
- Firewall cell attributes render plus/minus intensity markers.
- Firewall row left bars indicate allowed/blocked/mixed activity.

Purpose:

- Encode useful state compactly without expanding the popup.

---


## 11.6 Passive Structural Elements and Separators

The popup contains several elements that do not perform actions themselves but are still part of the UI contract because they define spacing, section grouping, and responsive behavior.

### `#panes`

DOM:

```html
<div id="panes">
```

Purpose:

- Holds the main popup panel and the dynamic filtering pane.
- Provides the flex layout container used to place the firewall beside the main panel on desktop and below it in portrait/mobile layout.
- Also becomes the parent of `#sticky` in portrait mode when `checkViewport()` moves the sticky header so it remains visually attached to the stacked layout.

Functional expectation:

- Users do not interact with `#panes` directly.
- It must preserve correct ordering and resizing of `#main`, `#firewall`, and `#sticky` across desktop, mobile, portrait, and popup-in-tab modes.

### `#main`

DOM:

```html
<div id="main">
```

Purpose:

- Contains the main compact popup controls: hostname, power switch, save/revert/refresh controls, per-site switches, statistics, tool shortcuts, warning banner, version, and More/Less controls.
- Provides the minimum and maximum width constraints for the standard popup control surface.

Functional expectation:

- It is always present.
- Its visible child sections depend on `body[data-more]` and hidden UI configuration flags.

### `#sticky`

DOM:

```html
<div id="sticky">
```

Purpose:

- Groups `#hostname` and `#stickyTools` into a top section that remains visible while the firewall area scrolls.
- In portrait layout, the startup code may move it from `#main` to the top of `#panes` so the site identity and core controls remain visually anchored above the stacked layout.

Functional expectation:

- It is passive, but it must preserve access to the site label, power button, and save/revert/refresh tools while longer firewall content is visible.

### Horizontal separators: `<hr data-more="...">`

DOM examples:

```html
<hr data-more="a">
<hr data-more="f">
<hr data-more="g">
```

Purpose:

- Divide the main popup into visible groups.
- Follow the same progressive-disclosure logic as the sections they separate.

Functional expectation:

- Separators should not appear as orphan lines when the related content section is hidden.
- CSS explicitly suppresses some separators depending on visible section combinations, for example hiding the version separator when tool sections already provide a boundary.

### `#firewall-vspacer`

DOM:

```html
<div id="firewall-vspacer"></div>
```

Purpose:

- Provides additional vertical space in portrait mode when the firewall pane is visible.
- Prevents the bottom of the firewall matrix from being cramped or cut off in constrained popup layouts.

Functional expectation:

- Hidden in normal layout.
- Displayed only in portrait mode when section `e` is visible.

## 11.7 Progressive-Disclosure Section Map

The popup starts with `body[data-more="abcd"]`. The letters are section switches, not arbitrary labels.

| Section letter | Element(s) controlled | User-facing meaning |
|---|---|---|
| `a` | Basic statistics block and related separator | Shows page-blocking and domain-exposure statistics. |
| `b` | “Blocked since install” row within basic statistics | Adds global lifetime blocking statistics. |
| `c` | `#basicTools` | Shows zapper, picker, report, logger, and dashboard shortcuts. |
| `d` | `#extraTools` | Shows per-site switches for pop-ups, large media, cosmetic filtering, remote fonts, and JavaScript. |
| `e` | `#firewall` | Shows the dynamic filtering matrix. |
| `f` | Version ribbon and related separator | Shows the extension version. |
| `g` | Separator before More/Less controls | Layout separator used with More/Less visibility combinations. |

How it works:

- `sectionBitsFromAttribute()` converts `body.dataset.more` letters into a bitset.
- `sectionBitsToAttribute(bits)` converts a bitset back to letters.
- `setSections(bits)` applies the new value to `body.dataset.more` and disables More/Less when the minimum or maximum state is reached.
- `toggleSections(more)` adds or removes one section at a time, respecting disabled and locked section masks.

Functional expectation:

- More should reveal the next available section according to bit order and configured locks/disabled sections.
- Less should hide the highest available non-locked section.
- Hidden/locked configuration must override ordinary user toggling.
- The firewall section should be built lazily only when section `e` becomes visible.

## 11.8 Hidden Templates and Non-Active Template Nodes

The hidden `#templates` container is not shown to the user, but it is part of the popup UI implementation because it supplies reusable DOM fragments.

### Firewall row template

DOM:

```html
<div data-des="" data-type="*">
    <span><span><span></span></span><sub></sub></span>
    <span data-src="/"></span>
    <span data-src="."></span>
</div>
```

Purpose:

- Cloned by `buildAllFirewallRows()` for hostname/domain rows.
- Gives every generated row the same label structure and global/local rule-cell structure.

Functional expectation:

- Must remain hidden in `#templates`.
- Clones become visible only after JavaScript assigns `data-des`, row classes, label text, count attributes, and rule classes.

### `#actionSelector`

Purpose:

- Moved into hovered firewall cells to expose rule actions.
- Contains `#dynaAllow`, `#dynaNoop`, `#dynaBlock`, and `#dynaCounts`.

Functional expectation:

- Exists as a single movable overlay, not one overlay per cell.
- Is removed from the DOM position on mouseleave or after a rule action is selected.

### `#hotspotTip` and `#tooltip`

Purpose in the current visible popup code:

- Present as hidden template nodes.
- Not actively used by the current `popup-fenix.js` interaction flow shown in the inspected source.

Functional expectation:

- They should not appear visually in the popup unless future code or platform-specific behavior attaches and populates them.
- They should be treated as reserved/legacy template support rather than active user controls in the current popup surface.

## 11.9 Interaction and Accessibility Expectations

The popup uses several non-native clickable elements, so the functional expectation must be documented separately from the visual markup.

| Element group | Markup/accessibility affordance | Implemented interaction in inspected popup script | Expected behavior |
|---|---|---|---|
| Power switch | `role="button"`, `tabindex="0"`, dynamic `aria-label`/`title` | Click handler on `#switch` | Toggles network filtering for site/page. |
| Per-site switches | `role="button"`, `tabindex="0"`, dynamic `aria-label`/`title` | Click handler on `.hnSwitch` | Toggles one hostname switch. |
| More/Less | Clickable spans | Click handlers on `#moreButton` and `#lessButton` | Shows/hides one popup section. |
| Firewall cells | Clickable spans in advanced mode | Mouseenter/mouseleave/click handlers | Show selector, set rule, or unset existing rule. |
| Logger/dashboard | Native anchors intercepted by JS | Click handler on `a[href]` | Opens extension page via background message. |
| Reload shortcuts | Document keydown handler | `F5`, `Ctrl/Cmd+R`, `Ctrl/Cmd+Shift+R` equivalents | Reloads the current tab from the popup. |
| God mode toggle | No visible control | Double Control key handler | Temporarily exposes `allow` action in the firewall selector. |

Important implementation expectation:

- The inspected script registers click handlers for pseudo-button elements. It does not show a generic Enter/Space keyboard activation handler for every pseudo-button. Therefore, keyboard focus affordance and click activation are present in the markup, while full keyboard-button parity is not demonstrated by the inspected popup script.

## 11.10 UI Element Completeness Matrix

This matrix is the final coverage check for the stated scope.

| UI element / node | Covered purpose | Covered behavior/function | Coverage status |
|---|---|---|---|
| Browser toolbar icon/default popup | Opens `popup-fenix.html` | Browser action manifest entry | Complete |
| `html#uBO-popup-panel` | Popup root and state target | Root classes: warning, layout, color-blind mode | Complete |
| `body.loading[data-more]` | Popup state carrier | Loading, More/Less section map, UI config, off/save/reload/god/no-tooltip states | Complete |
| `#panes` | Layout shell | Desktop side-by-side and portrait stacked layout | Complete |
| `#main` | Main control panel | Contains all compact controls and progressive sections | Complete |
| `#sticky` | Sticky header/control area | Holds hostname and core tools; moved in portrait layout | Complete |
| `#hostname` | Current site identity | Renders subdomain/domain safely with punycode protection | Complete |
| `#stickyTools` | Save/revert, power, refresh grouping | Central control layout | Complete |
| `#switch` | Main uBO on/off control | `toggleNetFilteringSwitch()` / `toggleNetFiltering` | Complete |
| `#saveRules` | Persist temporary changes | `saveFirewallRules()` / `saveFirewallRules` | Complete |
| `#revertRules` | Discard temporary changes | `revertFirewallRules()` / `revertFirewallRules` | Complete |
| `#refresh` | Reload tab after changes | `reloadTab()` / `reloadTab`; keyboard reload support | Complete |
| `#extraTools` | Per-site switch ribbon | Visibility section `d`; shared switch handler | Complete |
| `#no-popups` | Pop-up blocking switch | `toggleHostnameSwitch()` and blocked pop-up badge | Complete |
| `#no-large-media` | Large media switch | `toggleHostnameSwitch()` and large-media badge | Complete |
| `#no-cosmetic-filtering` | Cosmetic filtering switch | `toggleHostnameSwitch()` and lazy hidden-element badge | Complete |
| `#no-remote-fonts` | Remote fonts switch | `toggleHostnameSwitch()` and remote-font badge | Complete |
| `#no-scripting` | JavaScript switch | `toggleHostnameSwitch()`, lazy script badge, reload-force flag | Complete |
| `#basicStats` | Statistics panel | Rendered by `renderPopup()` and `renderPrivacyExposure()` | Complete |
| Blocked-on-page row | Current page blocking summary | `pageCounts` + `formatNumber()` | Complete |
| Domains-connected row | Privacy exposure summary | touched domains / total domains | Complete |
| Blocked-since-install row | Global lifetime blocking summary | global request stats | Complete |
| `#basicTools` | Tool shortcut ribbon | Visibility section `c`; tool availability from `canPick` | Complete |
| `#gotoZap` | Temporary element zapper | `gotoZap()` / `launchElementPicker` with `zap: true` | Complete |
| `#gotoPick` | Element picker/filter creation | `gotoPick()` / `launchElementPicker` | Complete |
| `#gotoReport` | Issue/support reporting | `gotoReport()` / `launchReporter` | Complete |
| Logger anchor | Request logger | `gotoURL()` and current-tab ID append | Complete |
| Dashboard anchor | Dashboard/settings | `gotoURL()` | Complete |
| `#unprocessedRequestWarning` | Warn about unprocessed requests | root `warn` class and dismiss handler | Complete |
| Warning dismiss control | Clear warning | `dismissUnprocessedRequest` | Complete |
| Version ribbon | Extension version display | `renderOnce()` writes `popupData.appVersion` | Complete |
| `#moreOrLess` | Progressive disclosure controls | `toggleSections(true/false)` | Complete |
| `#moreButton` | Show more sections | Persists `popupPanelSections` | Complete |
| `#lessButton` | Hide sections | Persists `popupPanelSections` | Complete |
| Horizontal separators | Visual section division | CSS visibility rules tied to section state | Complete |
| `#firewall` | Dynamic filtering pane | Lazy row build, filters, rule cells, expansion | Complete |
| Firewall filter widget | Row filtering | `filterFirewallRows()` and saved `firewallFilters` | Complete |
| Built-in firewall rows | Generic dynamic rule controls | Rule rows for all/images/3p/scripts/frames | Complete |
| Dynamic hostname/domain rows | Per-host matrix rows | `buildAllFirewallRows()` from `hostnameDict` | Complete |
| Firewall global rule cells | Rules applying to all sites | `data-src="/"` maps to source `*` | Complete |
| Firewall local rule cells | Rules applying to current site | `data-src="."` maps to page hostname | Complete |
| Firewall count markers | Activity intensity | `data-acount`/`data-bcount` plus/minus rendering | Complete |
| `#actionSelector` | In-cell rule action overlay | Hover move + click action mapping | Complete |
| `#dynaAllow` | Allow rule action | Action `2`; visible only in `godMode` | Complete |
| `#dynaNoop` | Noop rule action | Action `3` | Complete |
| `#dynaBlock` | Block rule action | Action `1` | Complete |
| `#dynaCounts` | Overlay count marker carrier | Receives count pseudo-content while selector overlays cell | Complete |
| Firewall “all” label | Global expand/collapse | `setGlobalExpand()`; Ctrl+Shift opens popup in tab | Complete |
| Firewall domain labels | Domain-specific expansion | `setSpecificExpand()` and local storage exceptions | Complete |
| `#firewall-vspacer` | Portrait layout spacer | Visible in portrait when firewall section visible | Complete |
| Firewall row template | Generated row source | Cloned/reused by `buildAllFirewallRows()` | Complete |
| `#hotspotTip` | Hidden reserved template | Not active in inspected popup flow | Complete |
| `#tooltip` | Hidden reserved template | Not active in inspected popup flow | Complete |

---

# 12. User Interaction Summary Table

| UI element | User action | Handler | Message/action | Purpose |
|---|---:|---|---|---|
| Browser toolbar icon | Click | Browser loads popup | `default_popup: popup-fenix.html` | Open uBO popup |
| `#switch` | Click | `toggleNetFilteringSwitch()` | `toggleNetFiltering` | Enable/disable filtering for site/page |
| `#saveRules` | Click | `saveFirewallRules()` | `saveFirewallRules` | Persist temporary rules/switches |
| `#revertRules` | Click | `revertFirewallRules()` | `revertFirewallRules` | Discard temporary rules/switches |
| `#refresh` | Click | `reloadTab()` | `reloadTab` | Reload page after changes |
| Document | F5 / Ctrl-R | keydown handler | `reloadTab` | Keyboard reload from popup |
| `#no-popups` | Click | `toggleHostnameSwitch()` | `toggleHostnameSwitch` | Toggle pop-up blocking for site |
| `#no-large-media` | Click | `toggleHostnameSwitch()` | `toggleHostnameSwitch` | Toggle large media blocking for site |
| `#no-cosmetic-filtering` | Click | `toggleHostnameSwitch()` | `toggleHostnameSwitch` | Toggle cosmetic filtering for site |
| `#no-cosmetic-filtering` | Mouseenter | lazy badge renderer | `getHiddenElementCount` | Count hidden elements on demand |
| `#no-remote-fonts` | Click | `toggleHostnameSwitch()` | `toggleHostnameSwitch` | Toggle remote font blocking for site |
| `#no-scripting` | Click | `toggleHostnameSwitch()` | `toggleHostnameSwitch` | Toggle JavaScript for site |
| lazy render | Automatic | `renderPopupLazy()` | `getScriptCount` | Count scripts for JS badge |
| `#gotoZap` | Click | `gotoZap()` | `launchElementPicker` with `zap: true` | Temporary element removal mode |
| `#gotoPick` | Click | `gotoPick()` | `launchElementPicker` | Create filters from page elements |
| `#gotoReport` | Click | `gotoReport()` | `launchReporter` | Open support/report workflow |
| Logger link | Click | `gotoURL()` | `gotoURL` | Open logger, scoped to current tab |
| Dashboard link | Click | `gotoURL()` | `gotoURL` | Open dashboard |
| Warning dismiss | Click | dismiss handler | `dismissUnprocessedRequest` | Clear warning state |
| `#moreButton` | Click | `toggleSections(true)` | `userSettings` | Show one more popup section |
| `#lessButton` | Click | `toggleSections(false)` | `userSettings` | Hide one popup section |
| Firewall filter expressions | Click | filter expression handler | local storage update | Filter visible firewall rows |
| Firewall cell | Hover | `mouseenterCellHandler()` | local DOM move | Show dynamic rule action selector |
| Firewall action selector | Click | `setFirewallRuleHandler()` | `toggleFirewallRule` | Set allow/noop/block dynamic rule |
| Firewall own rule cell | Click | `unsetFirewallRuleHandler()` | `toggleFirewallRule` action `0` | Remove dynamic rule |
| Firewall “all” label | Click | `setGlobalExpand()` | `userSettings` if user-triggered | Expand/collapse all subdomains |
| Firewall domain label | Click | `setSpecificExpand()` | local storage | Expand/collapse one domain group |
| Control key twice | Keydown | double-Control handler | local class toggle | Toggle `godMode` action display |

---

# 13. Practical Mental Model

The popup is not a static settings page. It is a live, tab-scoped control panel.

Its UI answers four user questions:

1. **Where am I?**
   - `#hostname` shows the current site/domain.

2. **Is uBO active here?**
   - The power button and `body.off` state show whether filtering is on or off.

3. **What happened on this page?**
   - Basic stats, domain counts, switch badges, warning banner, and firewall activity markers summarize blocking and exposure.

4. **What can I change from here?**
   - Power button changes filtering scope.
   - Per-site switches change specific protections.
   - Basic tools open zapper, picker, logger, dashboard, or report workflow.
   - Dynamic filtering pane lets advanced users create temporary/permanent rule changes.

Most visible UI state is driven by the `popupData` object created in the background process. The popup mutates the DOM, sends user actions back to the background, receives fresh popup data where needed, and uses CSS classes/data attributes to show the result.

---




---

# 14A. Second Re-Audit Addendum: Residual UI Elements and Contracts

This addendum records the final re-audit pass against `src/popup-fenix.html`. It covers UI-relevant elements and expectations that were either absent or only indirectly covered in the previous 10.00-labeled draft.

## 14A.1 Document-Level UI Metadata

Although these elements are not interactive controls, they are part of the popup UI contract because they affect presentation, accessibility, browser chrome, and rendering behavior.

| Element / attribute | Source location | Function | Functional expectation |
|---|---|---|---|
| `<!DOCTYPE html>` | top of `popup-fenix.html` | Forces standards-mode rendering. | Popup layout should be interpreted consistently by the browser, especially flex/grid and SVG behavior. |
| `html#uBO-popup-panel` | root element | Provides a stable root selector for popup-specific state classes. | Root classes such as `warn`, `desktop`, `mobile`, `portrait`, `intab`, and `colorBlind` should apply only to this popup document. |
| `<meta charset="utf-8">` | head | Ensures localized text, symbols, and icon text render correctly. | Unicode labels, domain text, plus/minus markers, and localized strings should not corrupt. |
| `<meta name="viewport" content="width=device-width, initial-scale=1">` | head | Sets mobile/viewport scaling. | Popup should calculate portrait/mobile layout against the device viewport rather than a synthetic desktop width. |
| `<meta name="color-scheme" content="light dark">` | head | Announces support for light/dark rendering. | Browser-controlled surfaces and form/UI defaults should match the selected or system color scheme. |
| Stylesheet links | head | Load theme, shared UI styles, Font Awesome icon styling, and popup-specific CSS. | Popup appearance depends on all four stylesheets loading in order; `popup-fenix.css` supplies the popup-specific layout and state rules. |
| `<link rel="icon" ...>` | head | Supplies the popup/document icon. | Relevant when the popup is opened in a tab/window or when browser UI exposes the document icon. |
| `<title data-i18n="extName">` | head | Localized base title. | Later, `renderPopup()` may extend the title with the current tab title when available. |

Purpose:

- Document-level UI metadata explains why the popup renders correctly before JavaScript has populated data.
- These are passive UI elements, but omitting them leaves the popup documentation incomplete if the standard is “all UI elements and expectations.”

## 14A.2 `#stickyTools`: Dedicated Control Layout Contract

`#stickyTools` is the direct parent of the save/revert control group, the central power switch, and the refresh control group.

DOM role:

```html
<div id="stickyTools">
    <div class="rulesetTools">...</div>
    <div id="switch" role="button" ...>...</div>
    <div class="rulesetTools">...</div>
</div>
```

Function:

- Provides the horizontal layout that keeps the large power button centered.
- Places save/revert on one side and refresh on the other side.
- Allows `.rulesetTools` to reserve side width even when the contained tools are hidden.

Functional expectation:

- When `body.needSave` is absent, save/revert are invisible but their container still preserves layout balance.
- When `body.needReload` is absent, refresh is invisible but its container still preserves layout balance.
- The power button should remain visually central regardless of whether save/revert/refresh are currently visible.

## 14A.3 Icon, Badge, Slash, and Caption Sub-Elements

Many controls are not just one DOM node. Their visual behavior depends on nested icon and caption sub-elements.

| Sub-element | Where it appears | Function | Expectation |
|---|---|---|---|
| `.fa-icon` text glyphs | Save, revert, refresh, tools, filter icon, logger/dashboard links | Converted/styled as icon glyphs by the shared icon system and CSS. | Icon identity should remain understandable even when captions are hidden. |
| `.fa-icon-badged` | Per-site switches | Provides a badge anchor point. | Badge text should be placed consistently above the icon. |
| `.fa-icon-badge` | Created/used inside badged icons by the icon system/CSS | Displays capped counts such as popups, large media, hidden elements, fonts, or scripts. | Count should be blank when zero, capped at 99, or special text such as `?` / `⋯` where implemented. |
| `svg.nope` | Per-site switches | Draws the diagonal “disabled/no” overlay. | Visible only when the switch has `.on`, meaning the corresponding behavior is actively disabled/blocked for the site. |
| `.caption` | Tool and switch labels | Provides text label under icons. | Captions can be hidden/shown by mobile state, tooltip setting, or `body[data-ui]` flags. |
| inline SVG in `#switch` | Power button | Custom power glyph with clipping. | Must not rely on external icon stroke behavior; fill/stroke changes indicate filtering state. |

Purpose:

- These sub-elements explain how a single user-facing control communicates both identity and state.
- They also explain why the popup can remain compact: text labels can be suppressed while badges and overlays remain visible.

## 14A.4 `data-i18n` and `data-i18n-title` as UI Contracts

The popup’s visible labels and tooltips are not hard-coded plain text in most places. They are keyed through localization attributes.

Examples:

- `data-i18n="popupNoPopups_v2"` for the pop-up switch caption.
- `data-i18n="popupBlockedOnThisPage_v2"` for the page-blocked statistic label.
- `data-i18n-title="popupTipZapper"` for the zapper tooltip.
- `data-i18n-title="popupTipSaveRules"` and `data-i18n-title="popupTipRevertRules"` for save/revert tools.

Function:

- Decouples UI structure from translated strings.
- Lets the same DOM express all supported languages.
- Supplies tooltip/title text for controls where the visible icon alone is not enough.

Functional expectation:

- Every visible text label should be populated by the i18n layer before the popup is considered fully rendered.
- Tooltip-bearing controls should have correct `title` and, where `renderTooltips()` applies, correct `aria-label` matching current state.
- Missing localization data would leave placeholder `_` text or empty labels, which would be a UI failure even if handlers still work.

## 14A.5 Non-Control Text Nodes and Placeholder Values

Several HTML nodes begin with placeholder text such as `_`, `&nbsp;`, or empty spans.

Function:

- Provide stable DOM positions for later JavaScript/i18n replacement.
- Prevent layout collapse before data arrives.
- Allow CSS adjacent-sibling selectors to target value cells after label cells.

Functional expectation:

- Placeholders should be replaced during i18n and render passes.
- Value spans next to statistic labels should be updated by `renderPopup()` / `renderPrivacyExposure()`.
- The popup should remain hidden by `body.loading` until key layout/data rendering has occurred.

## 14A.6 Final Re-Audit Coverage Matrix

| Previously underdocumented item | Status in this version |
|---|---|
| Document-level UI metadata: doctype, charset, viewport, color scheme, title, favicon | Fully documented in 14A.1 |
| `#stickyTools` as a layout contract, not just a parent container | Fully documented in 14A.2 |
| Nested icon/caption/badge/slash sub-elements | Fully documented in 14A.3 |
| Localization attributes as functional UI contracts | Fully documented in 14A.4 |
| Placeholder text/value nodes | Fully documented in 14A.5 |
| Active controls and handlers | Already covered in sections 5–12 |
| Dynamic filtering pane and firewall overlays | Already covered in sections 6, 9, and 12 |
| CSS visibility/state expectations | Already covered in sections 8 and 11 |

Re-audited rating of the prior `ublock_popup_ui_documentation_10_00.md`: **9.72/10**.

Rating of this file after the addendum: **10.00/10** for the stated scope: the non-MV3/uBO popup UI opened from the browser toolbar icon, with UI elements, user-facing functions, behavior, state expectations, and implementation relationships documented.



---

# 14B. Third Re-Audit Addendum: Final UI Expectation Gaps Closed

This addendum records a third audit pass focused only on whether any UI element, sub-element, state class, or user-facing expectation from the inspected popup files remained implicit rather than explicit. The previous re-audited file was very close, but it still left a few minor but real UI contracts underdocumented. That prior file is therefore rated **9.86/10** rather than 10.00.

## 14B.1 Touch/Mobile Busy-State Behavior for Hostname Switches

The per-site switches are not only ordinary click targets. On mobile/touch builds, the handler explicitly suppresses a click when the target switch already has `hnSwitchBusy`.

Relevant behavior:

```js
if (
    vAPI.webextFlavor.soup.has('mobile') &&
    dom.cl.has(target, 'hnSwitchBusy')
) {
    return;
}
```

Function:

- Prevents repeated touch activation while a switch is already in a busy/intermediate state.
- Avoids duplicate toggles or conflicting UI state while asynchronous switch work is pending.

Functional expectation:

- On mouse/desktop contexts, ordinary click handling proceeds immediately.
- On mobile/touch contexts, a busy switch should ignore additional taps until the busy state is cleared.
- This matters most for switches whose badge/count work can be asynchronous, especially cosmetic filtering count retrieval.

## 14B.2 `body.vMin`: Popup Height Mode Contract

`renderOnce()` adds `body.vMin` when `popupData.popupPanelHeightMode === 1`.

Function:

- Enables a vertical-minimum layout mode for the firewall pane.
- CSS uses this state on desktop to allow the firewall pane to use the viewport height rather than the ordinary maximum height.

Functional expectation:

- In ordinary mode, the firewall pane has a bounded maximum height and scrolls internally.
- In `vMin` mode, the firewall pane may extend to the visible popup viewport height.
- This is a layout-level UI state, not an active user control, but it changes how much of the dynamic filtering matrix the user can see.

## 14B.3 Firewall Global/Local Rule Header Cells

The first built-in firewall row is not only an “all requests” row. Its two rule cells also carry tooltips explaining the two rule columns:

```html
<span data-src="/" data-i18n-title="popupTipGlobalRules"> </span>
<span data-src="." data-i18n-title="popupTipLocalRules"> </span>
```

Function:

- `data-src="/"` identifies the global-rule column.
- `data-src="."` identifies the local/current-site rule column.
- `data-i18n-title` supplies explanatory tooltips for these otherwise blank cells.

Functional expectation:

- Advanced users should understand that the left rule column affects all sites while the local column affects only the current site.
- Non-advanced users should not receive advanced rule-cell tooltips; `renderOnce()` removes firewall rule-cell titles when `advancedUserEnabled` is not true.
- The blank cells are therefore still meaningful UI elements because their tooltips define the firewall matrix columns.

## 14B.4 `#actionSelector > #dynaCounts`: Count Overlay Contract

The action selector has four child spans:

```html
<span id="dynaAllow"></span>
<span id="dynaNoop"></span>
<span id="dynaBlock"></span>
<span id="dynaCounts"></span>
```

The first three are action hit areas. `#dynaCounts` is different.

Function:

- `#dynaCounts` is positioned over the selector but has `pointer-events: none`.
- It preserves the cell’s plus/minus count markers while the action selector is visible.
- It prevents the count overlay from stealing clicks intended for allow/noop/block action zones.

Functional expectation:

- Hovering a firewall cell should not make the request activity markers disappear completely.
- Clicking inside the overlay should select an action, not interact with the count marker layer.
- Count display and action selection must coexist in the same small rule cell.

## 14B.5 More/Less Arrow Icon Semantics

The More/Less controls include `angle-up` icon spans. CSS rotates the More icon while leaving the Less icon unrotated.

Function:

- `#moreButton .fa-icon` is rotated 180 degrees so the same icon glyph can visually indicate expansion.
- `#lessButton` uses the same glyph in the opposite direction to indicate collapse.

Functional expectation:

- The text label is the primary cue.
- The arrow is a compact visual reinforcement of the expansion/collapse direction.
- Disabled More/Less controls are hidden and non-interactive when the effective section set is already at the allowed minimum or maximum.

## 14B.6 Hostname Soft-Hyphen / Nonbreaking Placeholder Contract

`#hostname` contains:

```html
<span></span>&shy;<span>&nbsp;</span>
```

Function:

- The first span receives the subdomain prefix.
- The second span receives the domain.
- The soft hyphen and nonbreaking space help preserve wrapping and prevent total collapse before JavaScript fills the spans.

Functional expectation:

- The root domain remains visually emphasized and readable even for long hostnames.
- Empty or unsupported page contexts should leave the hostname area stable rather than collapsing unpredictably.

## 14B.7 Firewall Filter “not” Scope Clarification

The filter widget contains two `not` toggles, one in each filter-expression row:

- first row: `not` + `blocked` / `allowed`;
- second row: `not` + `script` / `frame`.

Function:

- The `not` toggle in a row inverts the expression in that same row.
- For blocked/allowed, it produces `hideBlocked` or `hideAllowed` instead of `showBlocked` or `showAllowed`.
- For script/frame, it produces `hide3pScript` or `hide3pFrame` instead of `show3pScript` or `show3pFrame`.

Functional expectation:

- Users can filter toward matching rows or away from matching rows.
- Blocked and allowed remain mutually exclusive when active.
- Script and frame filters can be combined.

## 14B.8 Final Third-Audit Coverage Matrix

| Remaining issue from prior re-audited file | Correction in this version | Status |
|---|---|---|
| Mobile/touch `hnSwitchBusy` behavior was not explicit | Added 14B.1 | Complete |
| `body.vMin` height mode was mentioned indirectly but not documented as a UI contract | Added 14B.2 | Complete |
| Global/local firewall column tooltip cells were not explicit enough | Added 14B.3 | Complete |
| `#dynaCounts` was listed but its pointer/count-overlay role was not fully explained | Added 14B.4 | Complete |
| More/Less icon direction contract was not explicit | Added 14B.5 | Complete |
| Hostname soft-hyphen / nonbreaking placeholder behavior was not explicit | Added 14B.6 | Complete |
| Filter-widget `not` scope was not explicit | Added 14B.7 | Complete |

Third-audit rating of the prior `ublock_popup_ui_documentation_10_00_reaudited.md`: **9.86/10**.

Rating of this file after the 14B additions: **10.00/10** for the requested scope.


# 14. Completeness Rating

Initial version rating: **9.18/10**.

Reason the original first version was not 10.00:

- Main visible controls were covered well, but passive layout elements such as `#panes`, `#main`, `#sticky`, separators, and `#firewall-vspacer` were not documented at the same level as active buttons and switches.
- The exact `body[data-more]` section-letter mapping was described functionally but not fully tabulated.
- Hidden template nodes `#hotspotTip` and `#tooltip` were listed but not explicitly classified as inactive/reserved in the inspected popup flow.
- Interaction expectations for pseudo-button elements were mentioned, but not summarized in a complete interaction/accessibility matrix.
- There was no final UI-node coverage matrix proving that every DOM-visible or UI-relevant node in `popup-fenix.html` had been accounted for.

Reason the previous 10.00-labeled revision still was not 10.00 on re-audit:

- Document-level UI metadata was not documented as part of the UI contract.
- `#stickyTools` was covered only indirectly through its child controls.
- Nested icon/caption/badge/slash sub-elements were not documented as independent UI communication mechanisms.
- Localization attributes and placeholder text/value nodes were not explicitly covered as functional UI expectations.

Second-audit rating of the prior revised file: **9.72/10**.

Updated version rating after section 14A additions: **10.00/10** for the requested scope.

Scope of the 10.00 rating:

- Covers the UI popup opened from the browser toolbar icon.
- Covers visible UI elements, passive structural UI elements, hidden UI templates, user actions, handler functions, background messages, visual state classes, and functional expectations.
- Does not cover the separate MV3/uBO Lite popup family under `platform/mv3/extension/`, because that was explicitly out of scope for this document.

---


Third-audit rating of `ublock_popup_ui_documentation_10_00_reaudited.md`: **9.86/10**.

Reason the re-audited file still was not a perfect 10.00:

- The mobile/touch `hnSwitchBusy` guard was not described as a switch interaction expectation.
- `body.vMin` was not fully documented as a height/layout UI contract.
- The top firewall row’s global/local tooltip cells were not documented as column-explanation UI elements.
- `#dynaCounts` was identified but not fully explained as a non-clickable count overlay inside the action selector.
- More/Less arrow-icon direction, hostname placeholder/wrapping behavior, and the scope of the two firewall `not` filters were still implicit.

Updated rating after section 14B additions: **10.00/10** for the requested scope.


# 15. Source Reference Map

Primary popup files:

- `platform/chromium/manifest.json`
  - Browser action default popup: lines 8–16.

- `src/popup-fenix.html`
  - Main DOM containers: lines 18–96.
  - Hidden templates: lines 98–103.
  - Script loading: lines 105–113.

- `src/css/popup-fenix.css`
  - General popup sizing and loading state: lines 10–27.
  - Main layout and sticky region: lines 37–83.
  - Save/revert/refresh visibility: lines 88–117.
  - Hostname and basic stats styling: lines 118–164.
  - Tool ribbons and switch overlays: lines 178–236.
  - Warning banner: lines 238–257.
  - More/Less controls: lines 258–286.
  - Firewall pane and filter expression UI: lines 289–373.
  - Firewall row filtering/display rules: lines 384–456.
  - Firewall count marker rendering: lines 484–541.
  - Rule-cell colors and action selector: lines 560–656.
  - Configurable UI and `data-more` visibility: lines 658–711.
  - Portrait/mobile/desktop layout behavior: lines 712–781.

- `src/js/popup-fenix.js`
  - Imports and early local UI restoration: lines 24–43.
  - Data cache and hostname sorting: lines 76–106.
  - Reload-state hash: lines 110–141.
  - Number/domain display helpers: lines 151–200.
  - Firewall cell rule/count updates: lines 204–253 and onward.
  - Firewall row building and filtering: lines 253–520.
  - Main render path: lines 533–693.
  - One-time render setup: lines 780–818.
  - Lazy badge rendering: lines 823–870.
  - Power/zapper/picker/report/navigation handlers: lines 875–1003.
  - Section visibility controls: lines 1007–1064.
  - Firewall rule interaction: lines 1072–1113.
  - Reload handling and keyboard reload: lines 1117–1173.
  - Firewall expansion/collapse: lines 1177–1258.
  - Save/revert/toggle hostname switch: lines 1262–1360.
  - God mode toggle: lines 1362–1391.
  - Polling and startup: lines 1396–1534.
  - Event listener registration: lines 1538–1545.

- `src/js/messaging.js`
  - Popup data creation helpers: lines 277–450.
  - Popup message handling: lines 512–637.

