# Maximum-Stealth Ad Blocking Method

## Status of the claim

A literal **100% stealth ad blocker** is not technically honest in a normal browser extension, especially on Chrome Manifest V3. A site can always observe at least some effects from the client side or server side:

- an ad auction did not happen;
- a beacon was not received;
- an iframe did not load the expected third-party code;
- an ad callback behaved differently;
- resource timing differs;
- a video manifest or server-side ad stream contains different data;
- the account/session has a history of missing ad events.

Therefore the correct goal is:

> **Maximum practical stealth:** make the blocker indistinguishable from a normal non-blocked browser for common client-side anti-adblock checks, while still preventing real ads, tracking, clicks, fraud, and user-visible ad display.

The closest practical method is a **compatibility-preserving ad sink**.

---

# 1. Core idea

Do not simply block every ad request with a hard failure.

Instead:

```text
real ad / tracker / bait request
        ↓
classified by rule engine
        ↓
redirected to local inert surrogate
        ↓
page receives plausible load signal
        ↓
tracking and ad rendering never happen
        ↓
user sees no real ad
        ↓
anti-adblock script has fewer observable failures
```

This means the blocker does four things at the same time:

1. **Blocks or redirects real ad/tracker network traffic.**
2. **Provides harmless local substitute resources where a hard block would reveal the blocker.**
3. **Preserves bait DOM nodes and expected layout signals.**
4. **Adds narrow, site-scoped scriptlets to neutralize detection code.**

This is not ad fraud. The blocker must not click ads, send real tracking beacons, load real ad auctions, or create fake billable impressions. It should only provide local inert compatibility objects.

---

# 2. Threat model

Anti-adblock systems detect blockers through observable side effects. The stealth method must cover these detection surfaces.

## 2.1 Network hard-failure detection

The page loads a known ad URL and checks whether it fails:

```js
const img = new Image();
img.onerror = () => showAdblockWall();
img.src = "https://ads.example.com/ad.gif";
```

Hard blocking makes `onerror` fire.

**Stealth response:** redirect known bait images/scripts/iframes to local inert resources that load successfully.

---

## 2.2 Script-global detection

The page checks whether ad scripts created globals:

```js
if (window.googletag === undefined) {
  showAdblockWall();
}
```

**Stealth response:** return local stubs that define expected globals but do not contact ad networks.

---

## 2.3 DOM bait detection

The page inserts a bait element:

```html
<div class="ad adsbox banner_ads"></div>
```

Then checks:

```js
const bait = document.querySelector(".adsbox");
if (!bait || bait.offsetHeight === 0 || getComputedStyle(bait).display === "none") {
  showAdblockWall();
}
```

**Stealth response:** preserve bait nodes and keep plausible layout metrics, while hiding or neutralizing real ad content inside them.

---

## 2.4 Timing and Performance API detection

The page checks resource timing:

```js
performance.getEntriesByName(adUrl)
```

or measures whether certain requests finish too quickly or fail.

**Stealth response:** for common bait resources, redirect to local surrogates that load successfully. For advanced timing checks, only site-specific mitigation is realistic.

---

## 2.5 MutationObserver detection

The page watches whether ad nodes are removed:

```js
new MutationObserver(records => {
  if (adNodeRemoved(records)) showAdblockWall();
});
```

**Stealth response:** do not delete bait nodes. Replace inner content or preserve shell nodes.

---

## 2.6 Server-side detection

The server checks whether expected ad beacons, auction calls, or video ad events arrived.

**Stealth response:** impossible to solve fully without contacting ad/tracking systems, which should not be done. The blocker can reduce client-side detection, but server-side detection remains a hard limit.

---

# 3. The best practical architecture

## 3.1 Module layout

Recommended project structure:

```text
src/js/stealth/
  stealth-mode.ts
  ad-sink-registry.ts
  dnr-surrogate-rules.ts
  bait-detector.ts
  bait-preserver.ts
  scriptlet-runner.ts
  site-profiles.ts
  stealth-evidence.ts

platform/chromium/web_accessible_resources/ad-sink/
  empty.js
  empty.css
  empty.json
  transparent-1x1.png
  blank-ad-frame.html
  empty-vast.xml
  stubs/
    adsbygoogle.js
    googletag-gpt.js
    gtag.js
    analytics.js
    amazon-apstag.js
    prebid.js
```

---

# 4. Layer 1 — DNR redirect to local surrogates

## 4.1 Why redirect instead of block

A hard block creates visible failure signals. A redirect can make the page believe a resource loaded, while the content is inert.

Use DNR `redirect.extensionPath` rules for known detection-prone resources.

Example concept:

```json
{
  "id": 900001,
  "priority": 460000,
  "action": {
    "type": "redirect",
    "redirect": {
      "extensionPath": "/web_accessible_resources/ad-sink/stubs/adsbygoogle.js"
    }
  },
  "condition": {
    "urlFilter": "||pagead2.googlesyndication.com/pagead/js/adsbygoogle.js",
    "resourceTypes": ["script"]
  }
}
```

## 4.2 Surrogate categories

| Resource type | Normal hard-block effect | Stealth surrogate |
|---|---|---|
| ad JS | `onerror`, missing globals | local no-op JS stub |
| tracking pixel | failed image | transparent 1×1 PNG |
| ad iframe | empty/error iframe | sandboxed blank local frame |
| analytics JSON | failed fetch | local empty JSON |
| VAST/VMAP | video player error | empty VAST XML |
| CSS | missing stylesheet error | empty CSS |

## 4.3 Critical rule

Only redirect resources that are safe to fake. Do not redirect arbitrary business logic scripts. Use allow/redirect/block classification.

---

# 5. Layer 2 — Ad script stubs

## 5.1 `googletag` / GPT stub

The stub should satisfy common page calls:

```js
(function () {
  const noop = function () {};
  const chain = {
    addService() { return this; },
    setTargeting() { return this; },
    defineSizeMapping() { return this; },
    setCollapseEmptyDiv() { return this; }
  };

  window.googletag = window.googletag || {};
  window.googletag.cmd = window.googletag.cmd || [];

  window.googletag.defineSlot = window.googletag.defineSlot || function () {
    return chain;
  };

  window.googletag.pubads = window.googletag.pubads || function () {
    return {
      enableSingleRequest: noop,
      collapseEmptyDivs: noop,
      addEventListener: noop,
      removeEventListener: noop,
      setTargeting: noop,
      refresh: noop,
      clear: noop
    };
  };

  window.googletag.enableServices = window.googletag.enableServices || noop;
  window.googletag.display = window.googletag.display || noop;

  while (window.googletag.cmd.length) {
    try {
      const fn = window.googletag.cmd.shift();
      if (typeof fn === "function") fn();
    } catch {}
  }

  const originalPush = window.googletag.cmd.push.bind(window.googletag.cmd);
  window.googletag.cmd.push = function (...items) {
    for (const item of items) {
      try {
        if (typeof item === "function") item();
      } catch {}
    }
    return originalPush(...items);
  };
})();
```

## 5.2 `adsbygoogle` stub

```js
(function () {
  window.adsbygoogle = window.adsbygoogle || [];
  const originalPush = window.adsbygoogle.push.bind(window.adsbygoogle);

  window.adsbygoogle.push = function (...items) {
    return originalPush(...items);
  };

  window.canRunAds = true;
})();
```

## 5.3 Analytics stubs

Analytics stubs must not send network beacons. They should only prevent page breakage:

```js
(function () {
  window.dataLayer = window.dataLayer || [];
  window.gtag = window.gtag || function () {
    window.dataLayer.push(arguments);
  };
  window.ga = window.ga || function () {};
})();
```

---

# 6. Layer 3 — DOM bait preservation

## 6.1 Do not delete bait nodes by default

Instead of:

```css
.adsbox { display: none !important; }
```

use site-aware behavior:

```text
if element is likely bait:
  preserve shell
  preserve dimensions
  remove clickable children
  remove remote iframe children
  neutralize pointer events
  visually collapse only where safe
```

## 6.2 Bait classification

A node is likely bait if:

- it has bait-like class names (`adsbox`, `ad-banner`, `advertisement`, etc.);
- it was inserted by anti-adblock code;
- it is empty or tiny;
- it is immediately measured by script;
- it is not user-visible real ad content.

A node is likely real ad content if:

- it contains third-party iframe/script/image from ad domains;
- it has click-through anchors;
- it loads tracking pixels;
- it is visually large or overlays content;
- it is associated with known ad containers.

## 6.3 Safe preservation strategy

For bait:

```css
.ad-sink-preserved {
  pointer-events: none !important;
  user-select: none !important;
}
```

Do not always use `display:none`, `visibility:hidden`, or `height:0`, because those are detection signals.

---

# 7. Layer 4 — Scriptlet defusers

## 7.1 Use narrow scriptlets

The scriptlet engine should support:

```text
set-constant
abort-on-property-read
abort-on-property-write
prevent-fetch
prevent-xhr
hide-if-contains
remove-node-text
trusted-replace-node-text
prevent-addEventListener
```

But these must be scoped by:

```text
site
URL pattern
script hash/signature
property name
call stack where possible
```

## 7.2 MAIN-world injection

Some anti-adblock checks happen in page scripts. Isolated content scripts cannot always affect page-visible globals. For those cases:

```text
inject at document_start
in MAIN world
only packaged local code
only site-scoped profiles
no remote code
```

## 7.3 Avoid broad monkeypatching

Do not globally replace:

```text
fetch
XMLHttpRequest
querySelector
getComputedStyle
offsetHeight
MutationObserver
PerformanceObserver
```

unless scoped to a known detector. Broad patches create breakage and fingerprintable behavior.

---

# 8. Layer 5 — Resource-timing compatibility

Some sites check whether a blocked resource is absent from `performance.getEntriesByType("resource")`.

Local redirects may create a resource entry, but not always with the same timing/origin attributes as the real request.

Mitigation:

```text
for known bait resources:
  redirect to small local surrogate
  avoid network error
  avoid long timeout
  avoid missing onload
```

Do not attempt universal performance spoofing. It is too fragile.

---

# 9. Layer 6 — Site profiles

A general stealth engine is not enough. Use per-site profiles.

Example:

```json
{
  "site": "example-news.com",
  "matches": ["*://*.example-news.com/*"],
  "mode": "balanced",
  "surrogates": [
    {
      "urlFilter": "||pagead2.googlesyndication.com/pagead/js/adsbygoogle.js",
      "resourceType": "script",
      "extensionPath": "/web_accessible_resources/ad-sink/stubs/adsbygoogle.js"
    }
  ],
  "baitPreservation": [
    ".adsbox",
    ".ad-placeholder",
    "[data-ad-slot]"
  ],
  "scriptlets": [
    {
      "name": "set-constant",
      "args": ["canRunAds", "true"]
    }
  ],
  "tests": [
    "no-anti-adblock-modal",
    "no-real-ad-network-contact",
    "no-visible-ad",
    "content-visible"
  ]
}
```

Profiles should be versioned, testable, and auditable.

---

# 10. Modes

## 10.1 Off

No stealth mitigation.

## 10.2 Balanced

Recommended default.

```text
redirect known bait scripts
preserve bait DOM
define common harmless globals
avoid broad API patches
```

## 10.3 Aggressive

For sites with anti-adblock walls.

```text
site-specific scriptlets
anti-modal removal
resource timing compatibility
bait-size preservation
```

## 10.4 Diagnostic

Logs every stealth decision to the logger:

```text
surrogate redirect
bait preserved
scriptlet applied
anti-adblock modal removed
real tracker blocked
```

This is important for debugging.

---

# 11. What would be needed for something close to “100%”

The closest possible design would require all of the following:

1. **Complete network coverage** for ad/tracker domains.
2. **Surrogate redirect coverage** for detection-prone resources.
3. **Cosmetic filtering that preserves bait nodes.**
4. **MAIN-world scriptlets at `document_start`.**
5. **Per-site anti-adblock profiles.**
6. **Video-specific handling for VAST/VMAP/IMA/SSA-style ads.**
7. **Resource timing compatibility for common bait probes.**
8. **No exposed extension fingerprinting surface.**
9. **No predictable web-accessible internal files except controlled surrogates.**
10. **Automated anti-detection tests for each supported site.**
11. **No real ad/tracker network contact.**
12. **No fake ad clicks or fake billable impressions.**
13. **Breakage monitoring and rollback profiles.**

Even with all of this, server-side detection remains unsolved.

---

# 12. Hard impossibility boundary

A browser extension cannot guarantee 100% stealth because:

```text
server can detect missing ad auction calls
server can detect missing impression beacons
server can compare page views against ad events
server can personalize anti-adblock responses
video platforms can use server-side ad insertion
sites can randomize detection scripts
browser APIs expose resource/timing/layout differences
MV3 limits dynamic interception and remote updates
```

Therefore:

```text
100% stealth against all sites: impossible
maximum stealth against common client-side checks: achievable
```

The correct product claim is:

> “Anti-adblock compatibility mode designed to reduce common client-side adblock detection.”

Not:

> “100% undetectable ad blocker.”

---

# 13. Implementation roadmap for uBlockResurrected

## Phase A — Fix foundation

```text
logger works
DNR ruleset blocks known tester domains
cosmetic filtering works
scriptlet runner works
browser tests pass
```

## Phase B — Add ad sink

```text
add local surrogate resources
add DNR redirect rules for bait resources
add ad-sink evidence report
```

## Phase C — Add bait preservation

```text
classify bait nodes
preserve bait dimensions
remove/neutralize real ad children
avoid obvious display:none on bait
```

## Phase D — Add scriptlet profiles

```text
MAIN-world injection
site-scoped rules
common globals stubs
anti-modal defusers
```

## Phase E — Add stealth evidence tests

```text
test hard-block detector
test bait DOM detector
test missing-global detector
test resource-error detector
test anti-modal detector
test no real ad network contact
test user sees no ads
test page content still usable
```

---

# 14. Evidence gate

A stealth evidence report should look like:

```json
{
  "mode": "balanced",
  "realAdNetworkContacted": false,
  "trackingBeaconSent": false,
  "fakeClickGenerated": false,
  "fakeImpressionGenerated": false,
  "surrogateScriptLoaded": true,
  "baitDomPreserved": true,
  "expectedAdGlobalsPresent": true,
  "antiAdblockModalAbsent": true,
  "contentVisible": true,
  "visibleAdAbsent": true,
  "consoleErrors": 0,
  "serverSideDetectionSolved": false
}
```

Gold-level stealth evidence should require:

```text
no real ad/tracker contact
no fake impressions
no fake clicks
common client-side detector passes
content remains visible
no page breakage
```

It should not require “serverSideDetectionSolved,” because that is outside extension control.

---

# 15. Final method summary

The best method is:

```text
DNR redirect to local harmless surrogates
+ bait DOM preservation
+ narrow MAIN-world scriptlets
+ per-site anti-adblock profiles
+ automated anti-detection tests
+ explicit refusal to fake clicks/impressions
```

This gives the closest practical result to stealth.

It can make the blocker appear inactive to many client-side anti-adblock scripts while still blocking real ad/tracker behavior.

It cannot honestly guarantee 100% stealth against server-side or adversarial detection.
