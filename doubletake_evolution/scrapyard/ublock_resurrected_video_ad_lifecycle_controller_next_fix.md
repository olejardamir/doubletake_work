# uBlock Resurrected — General Video-Ad Lifecycle Controller

**Date:** 2026-06-24  
**Repo:** `Astrocytech/uBlockResurrected`  
**Problem:** Some video ads still pass through. Sometimes content appears to start, then another ad comes in. Sometimes the old “wait, then skip” pattern remains.  
**Goal:** Move from one-shot skip/overlay detection to a persistent video-ad lifecycle controller that handles preroll, delayed skip, midroll/reinjected ads, reused skip buttons, and countdown text changes.

---

## 0. Current repo state

The repo already has these pieces:

- `genericPrerollSkipperAdapter` is registered before overlay adapters.
- `genericPrerollSkipperAdapter` detects visible skip controls near a real video.
- `safe-actions.ts` has `safelyClickVisibleSkipControl()`.
- `video-engine.ts` runs all active adapters.
- `video-engine.ts` watches attributes such as `src`, `class`, `id`, `style`, `disabled`, `aria-disabled`, `aria-label`, and `title`.

The remaining problem is lifecycle/state, not just detection.

Current limitation:

```text
scan detects current DOM state
skip button visible → click once
overlay visible → hide/neutralize once
```

But video ad systems are not one-shot. They do this:

```text
play → preroll starts → skip appears → skip clicked → content starts
content plays → midroll/reinjected ad starts → skip appears again → must handle again
```

So the next fix is a persistent per-video ad lifecycle controller.

---

## 1. Fix MutationObserver to catch countdown text changes

### Why

Many players show countdown text like:

```text
5
4
3
2
1
Skip
```

The existing observer watches attributes and child additions, but not text-node changes. If the skip button already exists and only its text changes, the engine may not rescan at the right time.

### Edit

```text
src/js/video-adblock/video-engine.ts
```

### Change observer config

Current:

```ts
observer.observe(document, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ["src", "class", "id", "style", "disabled", "aria-disabled", "aria-label", "title"],
});
```

Replace with:

```ts
observer.observe(document, {
    childList: true,
    subtree: true,
    attributes: true,
    characterData: true,
    attributeFilter: ["src", "class", "id", "style", "disabled", "aria-disabled", "aria-label", "title"],
});
```

Acceptance:

- changing text from countdown to “Skip” triggers a rescan.

---

## 2. Replace one-shot skip memory with ad-break-aware skip memory

### Current problem

`safe-actions.ts` uses:

```ts
const skipClicked = new WeakSet<Element>();
```

That means if the same skip button element is reused for a later ad break, the extension may refuse to click it again.

### Edit

```text
src/js/video-adblock/safe-actions.ts
```

### Replace

```ts
const skipClicked = new WeakSet<Element>();
```

### With

```ts
const skipClickState = new WeakMap<Element, {
    lastClickedAt: number;
    lastReason: string;
}>();

const SKIP_RECLICK_COOLDOWN_MS = 1500;
```

### Replace this logic

```ts
if (skipClicked.has(element)) return true;
...
skipClicked.add(element);
```

### With

```ts
const now = Date.now();
const prior = skipClickState.get(element);
if (
    prior &&
    now - prior.lastClickedAt < SKIP_RECLICK_COOLDOWN_MS &&
    prior.lastReason === reason
) {
    return true;
}
```

Then after passing visibility/enabled checks:

```ts
skipClickState.set(element, {
    lastClickedAt: now,
    lastReason: reason,
});
```

Acceptance:

- same skip button can be clicked again in a later ad break.
- repeated scans do not spam-click the same button every 250 ms.

---

## 3. Add a per-video lifecycle controller

### Create file

```text
src/js/video-adblock/video-ad-lifecycle.ts
```

### Purpose

Track each video over time:

```text
idle
content-candidate
ad-candidate
skip-waiting
skip-clicked
post-skip-verifying
content-playing
ad-reinjected
```

### Add implementation shape

```ts
export type VideoAdLifecycleState =
    | "idle"
    | "content-candidate"
    | "ad-candidate"
    | "skip-waiting"
    | "skip-clicked"
    | "post-skip-verifying"
    | "content-playing"
    | "ad-reinjected";

export interface VideoAdLifecycleSnapshot {
    state: VideoAdLifecycleState;
    lastPlayAt: number;
    lastAdSignalAt: number;
    lastSkipClickAt: number;
    lastContentSignalAt: number;
    lastSrc: string;
    lastCurrentTime: number;
    stableContentTicks: number;
    adBreakIndex: number;
}

const lifecycles = new WeakMap<HTMLVideoElement, VideoAdLifecycleSnapshot>();

export function getVideoAdLifecycle(video: HTMLVideoElement): VideoAdLifecycleSnapshot {
    let state = lifecycles.get(video);
    if (!state) {
        state = {
            state: "idle",
            lastPlayAt: 0,
            lastAdSignalAt: 0,
            lastSkipClickAt: 0,
            lastContentSignalAt: 0,
            lastSrc: video.currentSrc || video.src || "",
            lastCurrentTime: 0,
            stableContentTicks: 0,
            adBreakIndex: 0,
        };
        lifecycles.set(video, state);
    }
    return state;
}

export function markVideoPlay(video: HTMLVideoElement): void {
    const s = getVideoAdLifecycle(video);
    s.lastPlayAt = Date.now();
    if (s.state === "idle") {
        s.state = "content-candidate";
    }
}

export function markAdSignal(video: HTMLVideoElement, reason: string): void {
    const s = getVideoAdLifecycle(video);
    const now = Date.now();
    s.lastAdSignalAt = now;

    if (s.state === "content-playing") {
        s.state = "ad-reinjected";
        s.adBreakIndex++;
        return;
    }

    if (s.state !== "skip-clicked" && s.state !== "post-skip-verifying") {
        s.state = "ad-candidate";
    }
}

export function markSkipClicked(video: HTMLVideoElement): void {
    const s = getVideoAdLifecycle(video);
    s.lastSkipClickAt = Date.now();
    s.state = "skip-clicked";
}

export function markContentTick(video: HTMLVideoElement): void {
    const s = getVideoAdLifecycle(video);
    const now = Date.now();
    const currentSrc = video.currentSrc || video.src || "";
    const currentTime = Number.isFinite(video.currentTime) ? video.currentTime : 0;

    if (currentSrc !== s.lastSrc) {
        s.lastSrc = currentSrc;
        s.stableContentTicks = 0;
        if (s.state === "content-playing") {
            s.state = "ad-reinjected";
            s.adBreakIndex++;
        }
        return;
    }

    if (currentTime > s.lastCurrentTime + 0.25 && !video.paused) {
        s.stableContentTicks++;
        s.lastContentSignalAt = now;
    }

    s.lastCurrentTime = currentTime;

    if (
        (s.state === "skip-clicked" || s.state === "post-skip-verifying" || s.state === "content-candidate") &&
        s.stableContentTicks >= 3
    ) {
        s.state = "content-playing";
    }
}

export function shouldKeepScanningAggressively(video: HTMLVideoElement): boolean {
    const s = getVideoAdLifecycle(video);
    const now = Date.now();

    return (
        s.state === "ad-candidate" ||
        s.state === "skip-waiting" ||
        s.state === "skip-clicked" ||
        s.state === "post-skip-verifying" ||
        s.state === "ad-reinjected" ||
        now - s.lastPlayAt < 15000 ||
        now - s.lastAdSignalAt < 15000
    );
}
```

Acceptance:

- the same video can go through multiple ad breaks.
- ad reinjection after apparent content start is recognized.

---

## 4. Install video event listeners

### Edit

```text
src/js/video-adblock/video-engine.ts
```

### Add import

```ts
import {
    markVideoPlay,
    markContentTick,
    shouldKeepScanningAggressively,
} from "./video-ad-lifecycle";
```

### Add state

```ts
const instrumentedVideos = new WeakSet<HTMLVideoElement>();
let fastScanTimer: ReturnType<typeof setInterval> | null = null;
let lastKnownPlayers: HTMLVideoElement[] = [];
```

### Add helper

```ts
function instrumentVideo(video: HTMLVideoElement): void {
    if (instrumentedVideos.has(video)) return;
    instrumentedVideos.add(video);

    video.addEventListener("play", () => {
        markVideoPlay(video);
        ensureFastScanLoop();
    }, true);

    video.addEventListener("playing", () => {
        markContentTick(video);
        ensureFastScanLoop();
    }, true);

    video.addEventListener("timeupdate", () => {
        markContentTick(video);
    }, true);

    video.addEventListener("loadedmetadata", () => {
        ensureFastScanLoop();
    }, true);

    video.addEventListener("durationchange", () => {
        ensureFastScanLoop();
    }, true);

    video.addEventListener("waiting", () => {
        ensureFastScanLoop();
    }, true);

    video.addEventListener("pause", () => {
        ensureFastScanLoop();
    }, true);
}
```

### Add fast scan loop

```ts
function ensureFastScanLoop(): void {
    if (fastScanTimer !== null) return;

    fastScanTimer = window.setInterval(() => {
        const active = lastKnownPlayers.some(video =>
            video.isConnected && shouldKeepScanningAggressively(video)
        );

        if (!active) {
            window.clearInterval(fastScanTimer!);
            fastScanTimer = null;
            return;
        }

        try {
            scan();
        } catch (err) {
            warnLog("Fast scan error:", err);
        }
    }, 250);
}
```

### Update scan loop

After players are computed:

```ts
lastKnownPlayers = players;
for (const video of players) {
    instrumentVideo(video);
}
```

Acceptance:

- after a user presses play, the blocker scans repeatedly during the first seconds of preroll.
- when a midroll/reinjected ad appears, scanning resumes aggressively.
- scanning stops when content stabilizes.

---

## 5. Mark ad signals from adapters

### Edit

```text
src/js/video-adblock/video-engine.ts
```

### Add import

```ts
import { markAdSignal, markSkipClicked } from "./video-ad-lifecycle";
```

Inside this block:

```ts
if (!detection.isAd || detection.confidence === "none") continue;

const plan = adapter.getSafeActions(document, detection);
applySafeActionPlan(plan);
debugLog("Applied action for:", adapter.id, detection.reason);
```

Change to:

```ts
if (!detection.isAd || detection.confidence === "none") continue;

markAdSignal(video, detection.reason);

const plan = adapter.getSafeActions(document, detection);
applySafeActionPlan(plan);

if ((plan.skipClickElements ?? []).length > 0) {
    markSkipClicked(video);
}

debugLog("Applied action for:", adapter.id, detection.reason);
```

Acceptance:

- lifecycle state updates when overlay/skipper/near-player adapters detect ads.
- skip clicks transition the video into verification state.

---

## 6. Improve skip detector for reused/delayed controls

### Edit

```text
src/js/video-adblock/preroll-skip-detector.ts
```

### Add countdown/skip readiness signals

Add patterns:

```ts
/skip\s+in/i,
/ad\s+ends/i,
/seconds?/i,
/sec\.?/i,
/weiter/i,
/continue/i,
```

But **do not click** countdown controls until text/class actually indicates skip is available.

### Add function

```ts
function looksLikeCountdownOnly(el: HTMLElement): boolean {
    const text = [
        el.textContent || "",
        el.getAttribute("aria-label") || "",
        el.getAttribute("title") || "",
    ].join(" ").trim().toLowerCase();

    if (/^\d+$/.test(text)) return true;
    if (/skip\s+in\s+\d+/.test(text)) return true;
    if (/\d+\s*(s|sec|seconds)/.test(text) && /skip|ad|wait/.test(text)) return true;

    return false;
}
```

Then before accepting a candidate:

```ts
if (looksLikeCountdownOnly(el)) continue;
```

Acceptance:

- disabled/countdown skip UI is observed but not clicked too early.
- when the same element text changes to “Skip,” `characterData: true` triggers a scan and it gets clicked.

---

## 7. Add same-player ad reinjection test

### Create fixture

```text
tests/fixtures/video-adblock/same-player-ad-reinjection.html
```

Fixture behavior:

1. User presses play.
2. Content starts for 1 second.
3. Player switches to an ad state.
4. Skip button appears after 2 seconds.
5. Skip click resumes content.
6. After another 3 seconds, a second ad break reuses the same skip button.
7. Skip must be clicked again.

### Create test

```text
tests/video-adblock/same-player-ad-reinjection.spec.ts
```

Assertions:

```text
- first skip clicked once
- content resumes
- second ad break starts
- same skip element is clicked again after cooldown
- content resumes again
- no fake completion/impression/beacon calls
```

---

## 8. Add countdown text-change test

### Create fixture

```text
tests/fixtures/video-adblock/countdown-text-skip.html
```

Fixture behavior:

```text
button exists immediately
text = "5"
text changes to "4", "3", "2", "1"
then text changes to "Skip ad"
```

### Create test

```text
tests/video-adblock/countdown-text-skip.spec.ts
```

Assertions:

```text
- button is not clicked while text is numeric/countdown
- button is clicked after text becomes "Skip ad"
- test passes without attribute changes
```

This proves `characterData: true` matters.

---

## 9. Add midroll overlay-after-content test

### Create fixture

```text
tests/fixtures/video-adblock/midroll-overlay-after-content.html
```

Fixture behavior:

```text
content starts
after 2 seconds a video ad overlay appears
overlay disappears after skip/click-neutralize
content continues
after 4 seconds another overlay appears
```

### Create test

```text
tests/video-adblock/midroll-overlay-after-content.spec.ts
```

Assertions:

```text
- first overlay hidden/neutralized
- second overlay also hidden/neutralized
- real video remains visible
```

---

## 10. Update safety checker

### Edit

```text
tools/check-video-adblock-safety.mjs
```

Add required files:

```js
"src/js/video-adblock/video-ad-lifecycle.ts",
"tests/video-adblock/same-player-ad-reinjection.spec.ts",
"tests/video-adblock/countdown-text-skip.spec.ts",
"tests/video-adblock/midroll-overlay-after-content.spec.ts",
```

Add required APIs:

```text
getVideoAdLifecycle
markVideoPlay
markAdSignal
markSkipClicked
markContentTick
shouldKeepScanningAggressively
```

Keep this rule:

```text
Do not fake ad completion.
Do not fake impressions.
Do not fake clicks.
Do not fake viewability.
Do not patch HTMLVideoElement.prototype globally.
Do not patch window.open globally.
```

`.click()` remains allowed only inside:

```text
safelyClickVisibleSkipControl()
```

---

## 11. Do not implement generic MAIN-world hooks yet

Do **not** copy YouTube’s JSON/fetch/XHR sanitizer into the generic path yet.

That is a later, higher-risk phase.

This phase should remain:

```text
ISOLATED world
DOM/state based
visible skip button only
repeatable per ad break
no fake completion
no network payload mutation
```

---

## 12. Run checks

```bash
npm run build
npm run build:static-rulesets
npm run check:static-pipeline
npm run test:video-adblock
npm run check:video-adblock-safety
npm run check:sensitive-site-dnr-regression
npm run check:all
```

---

## 13. Expected result

After this phase:

- if the site shows a wait-to-skip preroll, it waits until skip is actually enabled and clicks it
- if content starts then another ad comes in, the lifecycle controller keeps scanning and handles the new ad break
- if the same skip element is reused, it can be clicked again after cooldown
- if skip readiness is text-only, the observer still catches it
- no publisher domain is hardcoded
- no fake ad events are sent
- real video remains playable
