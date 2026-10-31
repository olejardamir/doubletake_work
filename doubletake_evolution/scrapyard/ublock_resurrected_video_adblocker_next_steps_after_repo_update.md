# uBlock Resurrected — Generic Video-Ad Blocker Follow-up Plan

**Date:** 2026-06-24  
**Repo:** `Astrocytech/uBlockResurrected`  
**Purpose:** Fix the current generic video-ad blocker so it works beyond YouTube, including aggressive video-hosting/ad-overlay test pages, without breaking Suno, Yandex, YouTube, ChatGPT, or normal HTML5 video playback.

---

## 0. Current repo state

The repo already has the first generic video-ad blocker pass in place.

Confirmed current wiring:

- `build.mjs` now builds:

```js
'src/js/video-adblock/index.ts': `${OUT_DIR}/video-adblock-generic.js`,
```

- `platform/chromium/manifest.json` injects `/js/video-adblock-generic.js` as an `ISOLATED` content script on HTTP/HTTPS pages, with exclusions for Suno, Yandex, YouTube, YouTube-nocookie, youtu.be, and ChatGPT.
- `src/js/video-adblock/index.ts` calls `startVideoAdBlocker()`.
- `src/js/video-adblock/video-engine.ts` exists.
- Current adapters are only:
  - `youtubeAdapter`
  - `genericHtml5Adapter`
- `static-video-ads` exists in `platform/chromium/dnr/ruleset-manifest.json`.
- `assets/seed-filters/static-video-ads.txt` currently contains only two video-ad network rules:
  - `||imasdk.googleapis.com/js/sdkloader/ima3.js^`
  - `||pubads.g.doubleclick.net/gampad/ads^`
- `tools/check-video-adblock-safety.mjs` exists and is already wired into `package.json` through `check:video-adblock-safety`.
- `test:video-adblock` is wired into `package.json`.

So the foundation exists. The remaining issue is that the generic runtime is still too shallow.

---

## 1. Biggest immediate bug: the engine disables itself too early

### Problem

`src/js/video-adblock/video-engine.ts` currently scans immediately at `document_start`.

At that point, many video-heavy sites do **not** have a `<video>` element in the DOM yet.

Current behavior:

```ts
if (shouldDisableGenericVideoEngine(document)) {
    stopEngine("no-video-found");
    return;
}
```

and:

```ts
if (players.length === 0) {
    stopEngine("no-players");
    return;
}
```

This permanently disables the engine before the site lazy-loads the real player.

This is likely the main reason it does not work on many non-YouTube video sites.

### Exact change

Edit:

```text
src/js/video-adblock/video-engine.ts
```

Replace the hard disable on no video / no players with a transient no-op.

#### Replace this block

```ts
if (shouldDisableGenericVideoEngine(document)) {
    stopEngine("no-video-found");
    return;
}
```

with:

```ts
if (shouldDisableGenericVideoEngine(document)) {
    debugLog("No video found yet; keeping observer alive");
    return;
}
```

#### Replace this block

```ts
if (players.length === 0) {
    stopEngine("no-players");
    return;
}
```

with:

```ts
if (players.length === 0) {
    debugLog("No primary video players found yet; keeping observer alive");
    return;
}
```

### Add startup/backoff state

Add near the constants:

```ts
const MAX_EMPTY_SCANS_BEFORE_BACKOFF = 40;
const SLOW_SCAN_INTERVAL = 1500;

let emptyScanCount = 0;
let currentScanInterval = SCAN_INTERVAL;
```

Inside `scan()`, after detecting no video or no players, increment `emptyScanCount`.

When `emptyScanCount >= MAX_EMPTY_SCANS_BEFORE_BACKOFF`, set:

```ts
currentScanInterval = SLOW_SCAN_INTERVAL;
```

When at least one player is found, reset:

```ts
emptyScanCount = 0;
currentScanInterval = SCAN_INTERVAL;
```

Then change the observer debounce from:

```ts
}, SCAN_INTERVAL);
```

to:

```ts
}, currentScanInterval);
```

### Acceptance requirement

The engine must **not** permanently disable itself just because no `<video>` exists at `document_start`.

---

## 2. Expand `SafeActionPlan` so it can target exact overlay elements

### Problem

Current `SafeActionPlan` only supports selectors:

```ts
export interface SafeActionPlan {
    hideSelectors: string[];
    removeSelectors: string[];
    blockRequestHints: string[];
    mainWorldHooksAllowed: boolean;
    reason: string;
}
```

This is weak for real video ad overlays because many overlays have unstable classes, generated IDs, or no useful selector.

### Exact change

Edit:

```text
src/js/video-adblock/site-adapters/adapter-types.ts
```

Change `SafeActionPlan` to:

```ts
export interface SafeActionPlan {
    hideSelectors: string[];
    removeSelectors: string[];

    hideElements?: Element[];
    removeElements?: Element[];

    blockRequestHints: string[];
    mainWorldHooksAllowed: boolean;
    reason: string;
}
```

Then edit:

```text
src/js/video-adblock/safe-actions.ts
```

Inside `applySafeActionPlan()`, before selector handling, add:

```ts
for (const el of plan.hideElements ?? []) {
    safelyHideElement(el, plan.reason);
}

for (const el of plan.removeElements ?? []) {
    safelyRemoveElement(el, plan.reason);
}
```

Keep the existing selector logic after this.

### Acceptance requirement

Adapters must be able to hide/remove the **exact detected overlay element**, not only selector-derived elements.

---

## 3. Add a real overlay detector

### Create file

```text
src/js/video-adblock/video-overlay-detector.ts
```

### Add this implementation shape

```ts
export interface OverlayCandidate {
    element: Element;
    confidence: "low" | "medium" | "high";
    reason: string;
}

const AD_TEXT_SIGNALS = [
    "ad", "ads", "advert", "advertisement", "sponsor", "sponsored",
    "preroll", "midroll", "postroll", "vast", "vmap", "ima",
    "promo", "banner", "popunder", "popup",
];

const SAFE_TAGS = new Set(["video", "source", "track"]);

function rectOverlapRatio(a: DOMRect, b: DOMRect): number {
    const left = Math.max(a.left, b.left);
    const right = Math.min(a.right, b.right);
    const top = Math.max(a.top, b.top);
    const bottom = Math.min(a.bottom, b.bottom);

    const width = Math.max(0, right - left);
    const height = Math.max(0, bottom - top);
    const overlap = width * height;
    const base = Math.max(1, a.width * a.height);

    return overlap / base;
}

function hasAdLikeText(element: Element): boolean {
    const cls = typeof element.className === "string" ? element.className : "";
    const id = element.id || "";
    const aria = element.getAttribute("aria-label") || "";
    const title = element.getAttribute("title") || "";
    const src = element instanceof HTMLIFrameElement ? element.src : "";
    const href = element instanceof HTMLAnchorElement ? element.href : "";

    const combined = `${cls} ${id} ${aria} ${title} ${src} ${href}`.toLowerCase();
    return AD_TEXT_SIGNALS.some(signal => combined.includes(signal));
}

function isClickableOverlay(element: Element): boolean {
    if (element instanceof HTMLAnchorElement) return true;
    if (element instanceof HTMLButtonElement) return true;
    if (element.getAttribute("role") === "button") return true;
    if (element.querySelector("a,button,[role='button'],iframe")) return true;
    return false;
}

export function findVideoOverlayCandidates(video: HTMLVideoElement, root: Element): OverlayCandidate[] {
    const videoRect = video.getBoundingClientRect();
    const candidates: OverlayCandidate[] = [];

    if (videoRect.width < 200 || videoRect.height < 100) return candidates;

    const elements = Array.from(root.querySelectorAll("*"));

    for (const element of elements) {
        const tag = element.tagName.toLowerCase();
        if (SAFE_TAGS.has(tag)) continue;
        if (element === video) continue;
        if (element.contains(video)) continue;

        const rect = element.getBoundingClientRect();
        if (rect.width < 40 || rect.height < 20) continue;

        const overlap = rectOverlapRatio(videoRect, rect);
        if (overlap < 0.35) continue;

        const style = getComputedStyle(element);
        if (style.display === "none" || style.visibility === "hidden") continue;

        const z = Number.parseInt(style.zIndex || "0", 10);
        const positioned = ["absolute", "fixed", "sticky"].includes(style.position);
        const adLike = hasAdLikeText(element);
        const clickable = isClickableOverlay(element);

        if (overlap >= 0.70 && adLike && clickable) {
            candidates.push({
                element,
                confidence: "high",
                reason: "ad-like-clickable-overlay-over-video",
            });
            continue;
        }

        if (overlap >= 0.50 && adLike && (positioned || z > 1)) {
            candidates.push({
                element,
                confidence: "medium",
                reason: "ad-like-positioned-overlay-over-video",
            });
            continue;
        }

        if (overlap >= 0.80 && clickable && positioned && z > 10) {
            candidates.push({
                element,
                confidence: "medium",
                reason: "clickable-high-z-overlay-over-video",
            });
        }
    }

    return candidates;
}
```

### Acceptance requirement

The detector must never return:

- the `<video>` element
- `<source>`
- `<track>`
- `<body>`
- `<html>`
- an ancestor that contains the video

---

## 4. Add an aggressive-video generic adapter

### Create file

```text
src/js/video-adblock/site-adapters/aggressive-video-generic.ts
```

### Purpose

This adapter handles aggressive video-hosting pages, including sites with:

- ad overlays above a real video
- fake play buttons
- ad iframes above/near the player
- preroll/midroll markers in player containers
- popunder-style clickable overlays

Use neutral test fixtures. Do not hardcode real adult website names in code.

### Implementation shape

```ts
import type { VideoSiteAdapter, VideoAdDetection, SafeActionPlan } from "./adapter-types";
import { isKnownSensitiveHost } from "../breakage-guard";
import { findVideoElements, isLikelyPrimaryVideo, getLikelyVideoContainer } from "../video-detector";
import { findVideoOverlayCandidates } from "../video-overlay-detector";

export const aggressiveVideoGenericAdapter: VideoSiteAdapter = {
    id: "aggressive-video-generic",
    domains: ["*"],
    mainWorldHooksAllowed: false,

    matches(hostname: string): boolean {
        const host = hostname.toLowerCase();
        return !isKnownSensitiveHost(host);
    },

    detectPlayer(document: Document): HTMLVideoElement[] {
        return findVideoElements(document).filter(v => isLikelyPrimaryVideo(v));
    },

    detectAdState(document: Document, video: HTMLVideoElement): VideoAdDetection {
        const container = getLikelyVideoContainer(video) || video.parentElement || document.body;
        const overlays = findVideoOverlayCandidates(video, container);

        const high = overlays.find(o => o.confidence === "high");
        if (high) {
            return {
                isAd: true,
                confidence: "high",
                reason: high.reason,
                video,
                container: high.element,
            };
        }

        const medium = overlays.find(o => o.confidence === "medium");
        if (medium) {
            return {
                isAd: true,
                confidence: "medium",
                reason: medium.reason,
                video,
                container: medium.element,
            };
        }

        return {
            isAd: false,
            confidence: "none",
            reason: "no-aggressive-video-ad-overlay",
        };
    },

    getSafeActions(document: Document, detection: VideoAdDetection): SafeActionPlan {
        if (!detection.isAd || !detection.container || detection.confidence === "none") {
            return {
                hideSelectors: [],
                removeSelectors: [],
                hideElements: [],
                removeElements: [],
                blockRequestHints: [],
                mainWorldHooksAllowed: false,
                reason: "no-ad",
            };
        }

        return {
            hideSelectors: [],
            removeSelectors: [],
            hideElements: [detection.container],
            removeElements: [],
            blockRequestHints: [],
            mainWorldHooksAllowed: false,
            reason: detection.reason,
        };
    },

    shouldDisableForBreakage(document: Document): boolean {
        return false;
    },
};
```

### Register adapter

Edit:

```text
src/js/video-adblock/site-adapters/index.ts
```

Change imports to:

```ts
import { aggressiveVideoGenericAdapter } from "./aggressive-video-generic";
import { genericHtml5Adapter } from "./generic-html5";
import { youtubeAdapter } from "./youtube";
```

Change adapter order to:

```ts
export const VIDEO_SITE_ADAPTERS: VideoSiteAdapter[] = [
    youtubeAdapter,
    aggressiveVideoGenericAdapter,
    genericHtml5Adapter,
];
```

The aggressive adapter must run before the fallback generic HTML5 adapter.

---

## 5. Fix the existing generic HTML5 adapter

### Problem

Current `generic-html5.ts` only checks `video.parentElement`.

This misses the common real layout:

```html
<div class="player-root">
  <video></video>
  <div class="ad-overlay"></div>
</div>
```

The overlay is a sibling, not the video’s parent.

### Exact change

Edit:

```text
src/js/video-adblock/site-adapters/generic-html5.ts
```

Change:

```ts
const container = video.parentElement;
```

to:

```ts
const container = getLikelyVideoContainer(video) || video.parentElement;
```

Import:

```ts
import { findVideoElements, isLikelyPrimaryVideo, getLikelyVideoContainer } from "../video-detector";
```

Also stop returning selector-only plans. Prefer `hideElements` where possible.

---

## 6. Expand video-ad network seed coverage

### Edit file

```text
assets/seed-filters/static-video-ads.txt
```

Keep the existing two rules.

Append:

```text
! --- Generic VAST / IMA / video ad delivery ---
||googleads.g.doubleclick.net/pagead/ads^
||securepubads.g.doubleclick.net/gampad/ads^
||pubads.g.doubleclick.net/gampad/live/ads^
||pubads.g.doubleclick.net/pcs/view^
||ad.doubleclick.net/ddm/trackimp^
||tpc.googlesyndication.com/simgad^

! --- Aggressive video-hosting ad networks ---
||trafficjunky.net^
||trafficjunky.com^
||juicyads.com^
||juicyads.me^
||adnium.com^
||plugrush.com^
||ero-advertising.com^
||ero-advertising.net^
||hilltopads.net^
||popcash.net^
||onclickads.net^
||onclickalgo.com^
||realsrv.com^
||yllix.com^
||evadav.com^

! --- Existing broad aggressive networks should remain covered elsewhere too ---
||exoclick.com^
||exoclick.net^
||propellerads.com^
||adsterra.com^
||adsterra.net^
||popads.net^
```

Then run:

```bash
npm run build:static-rulesets
npm run check:static-pipeline
npm run check:video-adblock-safety
```

### Acceptance requirement

Generated file:

```text
platform/chromium/dnr/static-video-ads.rules.json
```

must still have `excludedInitiatorDomains` for:

```text
suno.com
yandex.com
yandex.ru
youtube.com
youtube-nocookie.com
youtu.be
chatgpt.com
```

The current safety checker already enforces this.

Do not add broad media blocks such as:

```text
||video
||stream
||media
||cdn
||cloudfront.net
||akamaized.net
*.m3u8
*.mp4
*.webm
```

Those can break real playback.

---

## 7. Add tests for late-loaded videos

### Create fixture

```text
tests/fixtures/video-adblock/late-loaded-video.html
```

It should:

1. load without a `<video>`
2. wait 500 ms
3. insert a player container with a `<video>`
4. insert an overlay above the video

### Create test

```text
tests/video-adblock/late-loaded-video.spec.ts
```

Test requirement:

- call `startVideoAdBlocker()`
- confirm engine does not disable permanently before the video exists
- insert video + overlay
- confirm overlay is hidden
- confirm video remains visible

This test directly covers the current `document_start` failure.

---

## 8. Add tests for aggressive video overlays

### Create fixture

```text
tests/fixtures/video-adblock/aggressive-video-overlay.html
```

Fixture shape:

```html
<div class="player-root">
  <video style="width:640px;height:360px"></video>
  <div class="ad-overlay sponsor-banner" style="position:absolute;z-index:9999">
    <a href="https://ads.example.test/click">Play</a>
  </div>
</div>
```

### Create test

```text
tests/video-adblock/aggressive-video-overlay.spec.ts
```

Assertions:

- overlay is detected
- overlay is hidden
- video is not hidden
- player root is not removed
- no `.click()` is called
- no beacon is sent

---

## 9. Add tests for fake play overlays

### Create fixture

```text
tests/fixtures/video-adblock/fake-play-overlay.html
```

It should have:

- a real `<video>`
- a clickable overlay covering the video
- overlay text/class/id such as `sponsored`, `ad`, `promo`, or `popunder`

### Create test

```text
tests/video-adblock/fake-play-overlay.spec.ts
```

Assertions:

- fake play overlay is hidden
- real video remains visible
- real player controls remain visible
- the adapter never clicks the overlay

---

## 10. Add tests for safe same-origin video playback

### Create fixture

```text
tests/fixtures/video-adblock/same-origin-video-safe.html
```

It should have:

- a normal video
- normal player controls
- no ad overlay

### Create test

```text
tests/video-adblock/same-origin-video-safe.spec.ts
```

Assertions:

- nothing is hidden
- nothing is removed
- video remains playable
- no block/hide action is produced

This prevents the aggressive adapter from becoming too destructive.

---

## 11. Strengthen `check-video-adblock-safety.mjs`

### Edit file

```text
tools/check-video-adblock-safety.mjs
```

Add required source files:

```js
const REQUIRED_SOURCE_FILES = [
    "src/js/video-adblock/video-overlay-detector.ts",
    "src/js/video-adblock/site-adapters/aggressive-video-generic.ts",
    "tests/video-adblock/late-loaded-video.spec.ts",
    "tests/video-adblock/aggressive-video-overlay.spec.ts",
    "tests/video-adblock/fake-play-overlay.spec.ts",
    "tests/video-adblock/same-origin-video-safe.spec.ts",
];
```

Then check they exist:

```js
for (const rel of REQUIRED_SOURCE_FILES) {
    if (!existsSync(resolve(REPO_ROOT, rel))) {
        fail(`Required video-adblock file missing: ${rel}`);
    }
}
```

Add forbidden source patterns across `src/js/video-adblock/**/*.ts`:

```text
.click(
sendBeacon
completeAd
adComplete
impression
viewability
Object.defineProperty(window
Object.defineProperty(globalThis
```

The goal is to prevent the generic video blocker from becoming a fake-ad-completion system.

---

## 12. Update `package.json`

The repo already has:

```json
"check:video-adblock-safety": "node tools/check-video-adblock-safety.mjs",
"test:video-adblock": "vitest run tests/video-adblock"
```

Confirm both remain inside `check:runtime`.

They are already currently included, so only change this if future edits accidentally remove them.

---

## 13. Manual testing protocol

After implementing:

```bash
npm run build
npm run build:static-rulesets
npm run check:static-pipeline
npm run test:video-adblock
npm run check:video-adblock-safety
npm run check:sensitive-site-dnr-regression
npm run check:all
```

Then reload:

```text
chrome://extensions
→ uBlock Resurrected
→ Reload
```

Manual browser checks:

```text
https://suno.com
https://yandex.com/images/
https://yandex.ru/images/
https://youtube.com
one neutral HTML5 video page
one aggressive video-hosting test page
```

Expected:

- Suno opens.
- Yandex image search works.
- YouTube blocker still works through YouTube-specific path.
- Generic video pages do not lose the real video.
- Aggressive overlay ads are hidden when they sit above a real video.
- The blocker does not fake ad clicks, impressions, completion, or viewability.
- The blocker does not blindly block `.mp4`, `.m3u8`, `.mpd`, `.ts`, `.webm`, or normal CDN media streams.

---

## 14. What not to do

Do not do these:

```text
Do not run YouTube-specific logic on all websites.
Do not globally freeze page variables.
Do not globally disable window.open.
Do not click skip buttons automatically unless the site exposes a real user-visible skip button and a site adapter explicitly owns that behavior.
Do not fake ad completion.
Do not fake impressions.
Do not fake clicks.
Do not fake viewability.
Do not block all CDN/media/video/stream domains.
Do not hide the video element itself.
Do not remove player roots that contain the real video.
```

---

## 15. Final success criteria

This phase is complete only when all of the following are true:

- `video-adblock-generic.js` remains an `ISOLATED` content script.
- The engine survives late-loaded videos.
- Aggressive overlay fixtures pass.
- Fake-play overlay fixture passes.
- Safe same-origin video fixture passes.
- Suno/Yandex/YouTube/ChatGPT exclusions remain intact.
- `static-video-ads` has meaningful video-ad network coverage beyond two Google rules.
- `check-video-adblock-safety` enforces required files and forbidden fake-ad patterns.
- `npm run check:all` passes.
