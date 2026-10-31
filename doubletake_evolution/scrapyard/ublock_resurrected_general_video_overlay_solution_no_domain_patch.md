# uBlock Resurrected — General Fix for Video Sites Where Generic Video Ad Blocking Still Fails

**Date:** 2026-06-24  
**Repo:** `Astrocytech/uBlockResurrected`  
**Failing example:** one aggressive video-hosting page was reported, but this plan must **not** hardcode that domain.  
**Goal:** Make the generic video-ad blocker work on more video sites by detecting geometry, click hijacks, and overlay behavior rather than relying on site-specific patches.

---

## 0. Diagnosis from current repo state

The repo already has these parts:

- `video-adblock-generic.js` is built from `src/js/video-adblock/index.ts`.
- The manifest injects `video-adblock-generic.js` in the `ISOLATED` world and excludes sensitive sites such as Suno, Yandex, YouTube, YouTube-nocookie, youtu.be, and ChatGPT.
- `aggressive-video-generic.ts` exists.
- `video-overlay-detector.ts` exists.
- `static-video-ads.txt` now includes generic VAST/IMA and aggressive video-hosting ad-network domains.
- `check:video-adblock-safety` and `test:video-adblock` are wired into `package.json`.

The current remaining weakness is not one specific domain. It is structural:

1. Adapter selection returns only the first matching adapter.
2. `aggressive-video-generic` matches almost every non-sensitive host, so the weaker `generic-html5` fallback is never reached.
3. Overlay detection searches only inside the selected player/container root.
4. Many aggressive video sites place overlays outside the player subtree, as body-level/fixed-position elements, or as transparent click layers.
5. The current detector relies too much on ad-like text/classes and misses classless clickable overlays.
6. There is no general capture-phase click shield for popunder/fake-play overlays.

So the fix must be: **adapter cascade + document-wide geometry overlay detection + click-shield neutralization**.

---

## 1. Change adapter selection from single adapter to cascade

### Current problem

`selectVideoSiteAdapter()` returns only the first matching adapter.

Because `aggressiveVideoGenericAdapter.matches()` returns true for every non-sensitive host, `genericHtml5Adapter` becomes unreachable.

### Edit

```text
src/js/video-adblock/site-adapters/index.ts
```

### Replace

```ts
export function selectVideoSiteAdapter(hostname: string): VideoSiteAdapter | null {
    const host = hostname.toLowerCase();
    return VIDEO_SITE_ADAPTERS.find((adapter) => adapter.matches(host)) ?? null;
}
```

### With

```ts
export function selectVideoSiteAdapters(hostname: string): VideoSiteAdapter[] {
    const host = hostname.toLowerCase();
    return VIDEO_SITE_ADAPTERS.filter((adapter) => adapter.matches(host));
}
```

Keep adapter order:

```ts
export const VIDEO_SITE_ADAPTERS: VideoSiteAdapter[] = [
    youtubeAdapter,
    aggressiveVideoGenericAdapter,
    genericHtml5Adapter,
];
```

---

## 2. Update the engine to run all matching adapters

### Edit

```text
src/js/video-adblock/video-engine.ts
```

### Replace import

```ts
import { selectVideoSiteAdapter } from "./site-adapters/index";
```

### With

```ts
import { selectVideoSiteAdapters } from "./site-adapters/index";
```

### Replace single adapter logic

Replace:

```ts
const adapter = selectVideoSiteAdapter(hostname);
if (!adapter) {
    stopEngine("no-adapter");
    return;
}

if (adapter.shouldDisableForBreakage(document)) {
    stopEngine("adapter-requested-disable");
    return;
}

const players = adapter.detectPlayer(document);
```

with:

```ts
const adapters = selectVideoSiteAdapters(hostname);
if (adapters.length === 0) {
    stopEngine("no-adapter");
    return;
}

const activeAdapters = adapters.filter(adapter => !adapter.shouldDisableForBreakage(document));
if (activeAdapters.length === 0) {
    stopEngine("all-adapters-requested-disable");
    return;
}

const players = Array.from(
    new Set(activeAdapters.flatMap(adapter => adapter.detectPlayer(document))),
);
```

### Replace action loop

Replace:

```ts
for (const video of players) {
    const detection = adapter.detectAdState(document, video);
    if (detection.isAd && detection.confidence !== "none") {
        const plan = adapter.getSafeActions(document, detection);
        applySafeActionPlan(plan);
        debugLog("Applied action for:", detection.reason);
    }
}
```

with:

```ts
for (const video of players) {
    for (const adapter of activeAdapters) {
        const detection = adapter.detectAdState(document, video);
        if (!detection.isAd || detection.confidence === "none") continue;

        const plan = adapter.getSafeActions(document, detection);
        applySafeActionPlan(plan);
        debugLog("Applied action for:", adapter.id, detection.reason);

        if (detection.confidence === "high") break;
    }
}
```

### Acceptance requirement

The aggressive adapter may handle overlays first, but if it does not detect an ad, the generic HTML5 adapter must still get a chance.

---

## 3. Make overlay detection document-wide, not container-only

### Current problem

`aggressive-video-generic.ts` uses:

```ts
const container = getLikelyVideoContainer(video) || video.parentElement || document.body;
const overlays = findVideoOverlayCandidates(video, container);
```

This misses overlays that are outside the player container.

### Edit

```text
src/js/video-adblock/video-overlay-detector.ts
```

### Add helper

```ts
function isUnsafeRemovalTarget(element: Element, video: HTMLVideoElement): boolean {
    const tag = element.tagName.toLowerCase();
    if (tag === "video" || tag === "source" || tag === "track") return true;
    if (tag === "body" || tag === "html") return true;
    if (element === video) return true;
    if (element.contains(video)) return true;
    return false;
}
```

### Add document-wide function

```ts
export function findDocumentWideVideoOverlayCandidates(
    video: HTMLVideoElement,
    document: Document,
): OverlayCandidate[] {
    const candidates: OverlayCandidate[] = [];

    const roots = new Set<Element>();
    roots.add(document.body);

    let current: Element | null = video.parentElement;
    let depth = 0;
    while (current && depth < 8) {
        roots.add(current);
        current = current.parentElement;
        depth++;
    }

    for (const root of roots) {
        for (const candidate of findVideoOverlayCandidates(video, root)) {
            if (!isUnsafeRemovalTarget(candidate.element, video)) {
                candidates.push(candidate);
            }
        }
    }

    return dedupeOverlayCandidates(candidates);
}
```

### Add dedupe

```ts
function dedupeOverlayCandidates(candidates: OverlayCandidate[]): OverlayCandidate[] {
    const seen = new Set<Element>();
    const out: OverlayCandidate[] = [];

    for (const candidate of candidates) {
        if (seen.has(candidate.element)) continue;
        seen.add(candidate.element);
        out.push(candidate);
    }

    return out;
}
```

---

## 4. Add top-layer hit-test detection for transparent/clickable overlays

### Why

Many aggressive video pages use classless overlays that do not say `ad`, `sponsor`, `vast`, etc. They simply sit above the video and intercept the click.

Selector/class detection will miss those.

### Edit

```text
src/js/video-adblock/video-overlay-detector.ts
```

### Add function

```ts
export function findTopLayerVideoOverlays(
    video: HTMLVideoElement,
    document: Document,
): OverlayCandidate[] {
    const rect = video.getBoundingClientRect();
    const candidates: OverlayCandidate[] = [];

    if (rect.width < 200 || rect.height < 100) return candidates;

    const points = [
        [0.20, 0.20], [0.50, 0.20], [0.80, 0.20],
        [0.20, 0.50], [0.50, 0.50], [0.80, 0.50],
        [0.20, 0.80], [0.50, 0.80], [0.80, 0.80],
    ];

    const hits = new Map<Element, number>();

    for (const [px, py] of points) {
        const x = rect.left + rect.width * px;
        const y = rect.top + rect.height * py;

        const top = document.elementFromPoint(x, y);
        if (!top) continue;
        if (top === video) continue;
        if (top.tagName.toLowerCase() === "video") continue;

        let candidate: Element | null = top;
        let climb = 0;

        while (candidate && climb < 4) {
            if (candidate === video) break;
            if (candidate.contains(video)) break;

            const style = getComputedStyle(candidate);
            const positioned = ["absolute", "fixed", "sticky"].includes(style.position);
            const z = Number.parseInt(style.zIndex || "0", 10);
            const pointerActive = style.pointerEvents !== "none";

            if (pointerActive && (positioned || z > 1 || isClickableOverlay(candidate))) {
                hits.set(candidate, (hits.get(candidate) ?? 0) + 1);
                break;
            }

            candidate = candidate.parentElement;
            climb++;
        }
    }

    for (const [element, count] of hits) {
        if (count >= 3) {
            candidates.push({
                element,
                confidence: count >= 5 ? "high" : "medium",
                reason: `top-layer-clickable-overlay:${count}/9`,
            });
        }
    }

    return candidates;
}
```

### Important

This is a general solution because it detects actual visual/click interception over the video, not a domain or class.

---

## 5. Use both document-wide and top-layer detection in aggressive adapter

### Edit

```text
src/js/video-adblock/site-adapters/aggressive-video-generic.ts
```

### Replace import

```ts
import { findVideoOverlayCandidates } from "../video-overlay-detector";
```

### With

```ts
import {
    findDocumentWideVideoOverlayCandidates,
    findTopLayerVideoOverlays,
} from "../video-overlay-detector";
```

### Replace

```ts
const container = getLikelyVideoContainer(video) || video.parentElement || document.body;
const overlays = findVideoOverlayCandidates(video, container);
```

### With

```ts
const overlays = [
    ...findDocumentWideVideoOverlayCandidates(video, document),
    ...findTopLayerVideoOverlays(video, document),
];
```

Then keep the existing high/medium selection logic.

---

## 6. Add a click-shield for detected overlays

### Why

Some sites do not need a visible overlay to stay visible. They need a click layer that triggers a popunder/new tab.

Hiding may not be enough. The generic blocker must suppress pointer/click propagation on detected overlay elements.

### Edit types

```text
src/js/video-adblock/site-adapters/adapter-types.ts
```

Extend `SafeActionPlan`:

```ts
neutralizeClickElements?: Element[];
```

### Edit safe actions

```text
src/js/video-adblock/safe-actions.ts
```

Add constants:

```ts
const CLICK_NEUTRALIZED_ATTR = "data-ubr-video-ad-click-neutralized";
const clickNeutralized = new WeakSet<Element>();
```

Add function:

```ts
export function safelyNeutralizeClickElement(element: Element, reason: string): boolean {
    if (!(element instanceof Element)) return false;

    const tag = element.tagName.toLowerCase();
    if (tag === "video" || tag === "body" || tag === "html") return false;
    if (element.contains(document.querySelector("video"))) return false;

    if (clickNeutralized.has(element)) return true;
    clickNeutralized.add(element);
    element.setAttribute(CLICK_NEUTRALIZED_ATTR, "true");

    const handler = (event: Event) => {
        event.preventDefault();
        event.stopImmediatePropagation();
        debugLog("Neutralized video-ad overlay click:", reason);
    };

    element.addEventListener("pointerdown", handler, true);
    element.addEventListener("mousedown", handler, true);
    element.addEventListener("click", handler, true);

    return true;
}
```

Inside `applySafeActionPlan()` add:

```ts
for (const el of plan.neutralizeClickElements ?? []) {
    safelyNeutralizeClickElement(el, plan.reason);
}
```

### Edit aggressive adapter safe plan

In `aggressive-video-generic.ts`, return:

```ts
return {
    hideSelectors: [],
    removeSelectors: [],
    hideElements: [detection.container],
    removeElements: [],
    neutralizeClickElements: [detection.container],
    blockRequestHints: [],
    mainWorldHooksAllowed: false,
    reason: detection.reason,
};
```

### Acceptance requirement

The blocker must not globally disable `window.open`. It should only neutralize clicks on detected overlay elements.

---

## 7. Add classless overlay fixture

### Create

```text
tests/fixtures/video-adblock/classless-top-layer-overlay.html
```

Fixture shape:

```html
<div id="player" style="position:relative;width:640px;height:360px">
  <video id="real-video" style="width:640px;height:360px"></video>
</div>

<div
  id="opaque-click-layer"
  style="
    position:fixed;
    left:0;
    top:0;
    width:640px;
    height:360px;
    z-index:999999;
    background:transparent;
    pointer-events:auto;
  "
>
</div>
```

### Create test

```text
tests/video-adblock/classless-top-layer-overlay.spec.ts
```

Assertions:

- top-layer overlay is detected without ad-like class names
- overlay is hidden or click-neutralized
- video remains visible
- player root remains visible
- no fake click/ad-completion/beacon behavior occurs

---

## 8. Add body-level sibling overlay fixture

### Create

```text
tests/fixtures/video-adblock/body-level-video-overlay.html
```

Fixture shape:

```html
<div class="player-root">
  <video id="real-video" style="width:640px;height:360px"></video>
</div>

<div
  class="promo-layer"
  style="
    position:absolute;
    left:0;
    top:0;
    width:640px;
    height:360px;
    z-index:9999;
  "
>
  <a href="https://ads.example.test/click">Continue</a>
</div>
```

### Create test

```text
tests/video-adblock/body-level-video-overlay.spec.ts
```

Assertions:

- overlay outside player subtree is still detected
- overlay is hidden/click-neutralized
- video remains visible
- the adapter does not remove the player root

---

## 9. Add popunder click-shield fixture

### Create

```text
tests/fixtures/video-adblock/popunder-click-layer.html
```

Fixture shape:

```html
<div id="player-root">
  <video id="real-video" style="width:640px;height:360px"></video>
  <div id="click-layer" style="position:absolute;z-index:9999;width:640px;height:360px"></div>
</div>

<script>
  window.__popupAttempted = false;
  document.getElementById("click-layer").addEventListener("click", () => {
    window.__popupAttempted = true;
    window.open("https://ads.example.test/pop");
  });
</script>
```

### Create test

```text
tests/video-adblock/popunder-click-layer.spec.ts
```

Assertions:

- click layer is detected
- simulated click does not set `window.__popupAttempted`
- `window.open` is not called
- video remains visible

---

## 10. Expand safety checker

### Edit

```text
tools/check-video-adblock-safety.mjs
```

Add required tests:

```js
const REQUIRED_SOURCE_FILES = [
    "src/js/video-adblock/video-overlay-detector.ts",
    "src/js/video-adblock/site-adapters/aggressive-video-generic.ts",
    "tests/video-adblock/classless-top-layer-overlay.spec.ts",
    "tests/video-adblock/body-level-video-overlay.spec.ts",
    "tests/video-adblock/popunder-click-layer.spec.ts",
];
```

Add a check that these source-level APIs exist:

```text
findDocumentWideVideoOverlayCandidates
findTopLayerVideoOverlays
neutralizeClickElements
safelyNeutralizeClickElement
selectVideoSiteAdapters
```

Do not allow the old single-adapter API to be the only exported selector:

```text
selectVideoSiteAdapter(
```

If it still exists, it must not be used by `video-engine.ts`.

---

## 11. Keep domain-specific code out

Do not add the failing domain to:

```text
manifest.json
breakage-guard.ts
aggressive-video-generic.ts
static-video-ads.txt
```

The only valid domain additions are general ad-network domains, not the publisher/video site itself.

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

## 13. Manual test expectations

On aggressive video-hosting pages:

- real video remains visible
- visible overlay above video disappears
- transparent click layer no longer opens a popunder
- fake play overlay is neutralized
- normal video controls remain usable
- no fake ad impression/click/completion/viewability is sent
- no global `window.open` monkeypatch is used
- no site domain is hardcoded

On sensitive pages:

- Suno still opens
- Yandex Images still works
- YouTube uses its YouTube-specific adapter
- ChatGPT remains excluded

---

## 14. Why this is general

This solution does not depend on any specific adult/video site.

It detects:

- visual overlap over a real video
- top-layer clickable interception
- body-level/fixed-position overlays
- classless transparent click layers
- sibling overlays outside player DOM subtree
- popunder click hijacking

That is the general pattern aggressive video sites use.
