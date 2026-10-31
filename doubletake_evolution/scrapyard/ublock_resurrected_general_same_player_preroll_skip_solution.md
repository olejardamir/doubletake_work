# uBlock Resurrected — General Same-Player Preroll Skip Solution

**Date:** 2026-06-24  
**Repo:** `Astrocytech/uBlockResurrected`  
**Failing behavior:** Page shows a play button. After pressing play, an ad plays first inside/over the same player. After a few seconds, a skip control appears. This is similar to YouTube-style preroll behavior.  
**Goal:** Add a general, safe same-player preroll skipper without hardcoding the publisher/video-site domain and without faking ad completion, clicks, impressions, beacons, or viewability.

---

## 0. Diagnosis

The current generic video blocker now handles:

- late-loaded videos
- adapter cascade
- document-wide overlay detection
- top-layer hit testing
- click neutralization
- near-player/click-layer style failures

But the described failure is different.

This is not mainly:

```text
overlay above video
near-player ad slot
transparent click layer
popunder trigger
missing static DNR domain
```

It is more likely:

```text
same-player preroll ad
skip button appears after delay
real video starts only after ad/skip
```

The YouTube subsystem already has a model for this: it waits for confirmed ad state and then uses the player’s own skip method or visible skip button. The generic subsystem needs a safe version of that pattern.

---

## 1. Add a generic preroll/skip detector

### Create file

```text
src/js/video-adblock/preroll-skip-detector.ts
```

### Purpose

Detect visible, enabled skip controls near a real video player after an ad/preroll begins.

This must be DOM-based and generic. It must not hardcode the publisher domain.

### Add implementation

```ts
export interface SkipControlCandidate {
    element: HTMLElement;
    confidence: "medium" | "high";
    reason: string;
}

const SKIP_TEXT_PATTERNS = [
    // English
    /\bskip\b/i,
    /skip\s+ad/i,
    /skip\s+ads/i,

    // German
    /überspringen/i,
    /anzeige\s+überspringen/i,
    /werbung\s+überspringen/i,

    // Romance-language common cases
    /saltar/i,
    /omitir/i,
    /ignorar/i,
    /passer/i,
    /passer\s+l['’]annonce/i,
    /salta/i,

    // Slavic/common UI cases
    /preskoči/i,
    /přeskočit/i,
    /preskocit/i,

    // Short timer/skip patterns used by custom players
    /^skip$/i,
    /^skip\s*>$/i,
];

const SKIP_CLASS_ID_SIGNALS = [
    "skip", "skipad", "skip-ad", "adskip", "ad-skip",
    "vast-skip", "ima-skip", "preroll-skip", "video-ad-skip",
];

const AD_STATE_SIGNALS = [
    "ad", "ads", "advert", "advertisement", "preroll", "midroll",
    "postroll", "vast", "vmap", "ima", "sponsor", "sponsored",
];

function visibleEnough(el: HTMLElement): boolean {
    if (!el.isConnected) return false;

    const rect = el.getBoundingClientRect();
    if (rect.width < 20 || rect.height < 10) return false;

    const style = getComputedStyle(el);
    if (style.display === "none") return false;
    if (style.visibility === "hidden") return false;
    if (style.pointerEvents === "none") return false;
    if (Number(style.opacity || "1") < 0.1) return false;

    return true;
}

function enabledEnough(el: HTMLElement): boolean {
    if (el.hasAttribute("disabled")) return false;
    if (el.getAttribute("aria-disabled") === "true") return false;
    if (el.classList.contains("disabled")) return false;
    return true;
}

function textLooksLikeSkip(el: HTMLElement): boolean {
    const text = [
        el.textContent || "",
        el.getAttribute("aria-label") || "",
        el.getAttribute("title") || "",
        el.getAttribute("value") || "",
    ].join(" ").trim();

    return SKIP_TEXT_PATTERNS.some(re => re.test(text));
}

function classOrIdLooksLikeSkip(el: HTMLElement): boolean {
    const cls = typeof el.className === "string" ? el.className : "";
    const id = el.id || "";
    const combined = `${cls} ${id}`.toLowerCase().replace(/_/g, "-");
    return SKIP_CLASS_ID_SIGNALS.some(signal => combined.includes(signal));
}

function elementNearVideo(el: HTMLElement, video: HTMLVideoElement): boolean {
    const er = el.getBoundingClientRect();
    const vr = video.getBoundingClientRect();

    if (vr.width < 200 || vr.height < 100) return false;

    const padX = vr.width * 0.45;
    const padY = vr.height * 0.45;

    const left = vr.left - padX;
    const right = vr.right + padX;
    const top = vr.top - padY;
    const bottom = vr.bottom + padY;

    return er.right >= left && er.left <= right && er.bottom >= top && er.top <= bottom;
}

function playerLooksAdLike(video: HTMLVideoElement): boolean {
    let current: Element | null = video.parentElement;
    let depth = 0;

    while (current && depth < 8) {
        const cls = typeof current.className === "string" ? current.className : "";
        const id = current.id || "";
        const aria = current.getAttribute("aria-label") || "";
        const combined = `${cls} ${id} ${aria}`.toLowerCase();

        if (AD_STATE_SIGNALS.some(signal => combined.includes(signal))) return true;

        current = current.parentElement;
        depth++;
    }

    return false;
}

export function findVisibleSkipControlsForVideo(
    video: HTMLVideoElement,
    document: Document,
): SkipControlCandidate[] {
    const candidates: SkipControlCandidate[] = [];

    const controls = Array.from(
        document.querySelectorAll<HTMLElement>(
            "button, a, [role='button'], .skip, [class*='skip'], [id*='skip'], [aria-label*='skip' i]",
        ),
    );

    for (const el of controls) {
        if (!visibleEnough(el)) continue;
        if (!enabledEnough(el)) continue;
        if (!elementNearVideo(el, video)) continue;

        const textSkip = textLooksLikeSkip(el);
        const classSkip = classOrIdLooksLikeSkip(el);
        const adLikePlayer = playerLooksAdLike(video);

        if (textSkip && classSkip) {
            candidates.push({
                element: el,
                confidence: "high",
                reason: "visible-enabled-skip-control-text-and-class",
            });
            continue;
        }

        if (textSkip && adLikePlayer) {
            candidates.push({
                element: el,
                confidence: "high",
                reason: "visible-enabled-skip-control-in-ad-like-player",
            });
            continue;
        }

        if (textSkip || classSkip) {
            candidates.push({
                element: el,
                confidence: "medium",
                reason: "visible-enabled-skip-control-near-video",
            });
        }
    }

    return candidates;
}
```

---

## 2. Add a safe skip-click action

### Why

The current safety checks were correct to forbid random `.click()` use. But for this specific failure class, the blocker needs a **narrow, audited, visible-skip-control click**.

This is not fake ad completion. It is equivalent to clicking the real user-visible “Skip ad” control after it becomes available.

### Edit

```text
src/js/video-adblock/site-adapters/adapter-types.ts
```

Extend `SafeActionPlan`:

```ts
skipClickElements?: HTMLElement[];
```

### Edit

```text
src/js/video-adblock/safe-actions.ts
```

Add:

```ts
const SKIP_CLICKED_ATTR = "data-ubr-video-ad-skip-clicked";
const skipClicked = new WeakSet<Element>();

export function safelyClickVisibleSkipControl(element: HTMLElement, reason: string): boolean {
    if (!(element instanceof HTMLElement)) return false;

    const tag = element.tagName.toLowerCase();
    if (tag === "video" || tag === "body" || tag === "html") return false;

    if (skipClicked.has(element)) return true;
    if (element.hasAttribute("disabled")) return false;
    if (element.getAttribute("aria-disabled") === "true") return false;

    const rect = element.getBoundingClientRect();
    if (rect.width < 20 || rect.height < 10) return false;

    const style = getComputedStyle(element);
    if (style.display === "none") return false;
    if (style.visibility === "hidden") return false;
    if (style.pointerEvents === "none") return false;
    if (Number(style.opacity || "1") < 0.1) return false;

    skipClicked.add(element);
    element.setAttribute(SKIP_CLICKED_ATTR, "true");

    debugLog("Clicking visible video-ad skip control:", reason);
    element.click();

    return true;
}
```

Inside `applySafeActionPlan()` add:

```ts
for (const el of plan.skipClickElements ?? []) {
    safelyClickVisibleSkipControl(el, plan.reason);
}
```

### Safety rule

`.click()` is allowed only in this one helper:

```text
safelyClickVisibleSkipControl()
```

No other generic video-adblock source file may call `.click()`.

---

## 3. Add a generic preroll skipper adapter

### Create file

```text
src/js/video-adblock/site-adapters/generic-preroll-skipper.ts
```

### Implementation

```ts
import type { VideoSiteAdapter, VideoAdDetection, SafeActionPlan } from "./adapter-types";
import { isKnownSensitiveHost } from "../breakage-guard";
import { findVideoElements, isLikelyPrimaryVideo } from "../video-detector";
import { findVisibleSkipControlsForVideo } from "../preroll-skip-detector";

type PrerollDetection = VideoAdDetection & {
    skipControl?: HTMLElement;
};

export const genericPrerollSkipperAdapter: VideoSiteAdapter = {
    id: "generic-preroll-skipper",
    domains: ["*"],
    mainWorldHooksAllowed: false,

    matches(hostname: string): boolean {
        const host = hostname.toLowerCase();
        return !isKnownSensitiveHost(host);
    },

    detectPlayer(document: Document): HTMLVideoElement[] {
        return findVideoElements(document).filter(v => isLikelyPrimaryVideo(v));
    },

    detectAdState(document: Document, video: HTMLVideoElement): PrerollDetection {
        const skipControls = findVisibleSkipControlsForVideo(video, document);
        const high = skipControls.find(c => c.confidence === "high");
        const medium = skipControls.find(c => c.confidence === "medium");

        const candidate = high || medium;
        if (!candidate) {
            return {
                isAd: false,
                confidence: "none",
                reason: "no-visible-preroll-skip-control",
            };
        }

        return {
            isAd: true,
            confidence: candidate.confidence,
            reason: candidate.reason,
            video,
            container: candidate.element,
            skipControl: candidate.element,
        };
    },

    getSafeActions(document: Document, detection: PrerollDetection): SafeActionPlan {
        if (!detection.isAd || !detection.skipControl || detection.confidence === "none") {
            return {
                hideSelectors: [],
                removeSelectors: [],
                hideElements: [],
                removeElements: [],
                neutralizeClickElements: [],
                skipClickElements: [],
                blockRequestHints: [],
                mainWorldHooksAllowed: false,
                reason: "no-preroll-skip",
            };
        }

        return {
            hideSelectors: [],
            removeSelectors: [],
            hideElements: [],
            removeElements: [],
            neutralizeClickElements: [],
            skipClickElements: [detection.skipControl],
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

---

## 4. Register the preroll skipper before overlay adapters

### Edit

```text
src/js/video-adblock/site-adapters/index.ts
```

Add import:

```ts
import { genericPrerollSkipperAdapter } from "./generic-preroll-skipper";
```

Use this order:

```ts
export const VIDEO_SITE_ADAPTERS: VideoSiteAdapter[] = [
    youtubeAdapter,
    genericPrerollSkipperAdapter,
    aggressiveVideoGenericAdapter,
    genericHtml5Adapter,
];
```

### Why this order

If a real skip button is visible, that is a stronger signal than guessing which overlay to hide.

---

## 5. Add mutation handling for delayed skip buttons

The engine already rescans on mutations, but make sure it watches skip button visibility changes.

### Edit

```text
src/js/video-adblock/video-engine.ts
```

Current observer has:

```ts
attributeFilter: ["src", "class", "id", "style"],
```

Change to:

```ts
attributeFilter: ["src", "class", "id", "style", "disabled", "aria-disabled", "aria-label", "title"],
```

This ensures the engine rescans when the skip control appears, becomes enabled, or changes text/state.

---

## 6. Add tests for same-player preroll skip

### Create fixture

```text
tests/fixtures/video-adblock/same-player-preroll-skip.html
```

Fixture behavior:

1. Real `<video>` exists.
2. A normal play button starts an ad/preroll state.
3. Skip button is absent initially.
4. After 2 seconds, a visible enabled skip button appears near the video.
5. Clicking skip marks content as resumed.

Example:

```html
<div class="player ad-showing" id="player">
  <video id="real-video" style="width:640px;height:360px"></video>
  <button id="play">Play</button>
  <button id="skip-ad" style="display:none" aria-label="Skip ad">Skip ad</button>
</div>

<script>
  window.__contentResumed = false;
  window.__skipClicked = false;

  document.getElementById("play").addEventListener("click", () => {
    setTimeout(() => {
      const skip = document.getElementById("skip-ad");
      skip.style.display = "block";
      skip.disabled = false;
    }, 2000);
  });

  document.getElementById("skip-ad").addEventListener("click", () => {
    window.__skipClicked = true;
    window.__contentResumed = true;
    document.getElementById("player").classList.remove("ad-showing");
  });
</script>
```

### Create test

```text
tests/video-adblock/same-player-preroll-skip.spec.ts
```

Assertions:

- before skip appears, nothing is clicked
- after skip appears, the skip control is clicked once
- `window.__contentResumed === true`
- video remains visible
- no fake completion/impression/beacon APIs are called
- repeated scans do not click the same skip button repeatedly

---

## 7. Add multilingual skip fixture

### Create

```text
tests/fixtures/video-adblock/multilingual-preroll-skip.html
```

Include skip buttons with:

```text
Skip ad
Anzeige überspringen
Werbung überspringen
Saltar anuncio
Omitir anuncio
Passer l’annonce
Preskoči oglas
Přeskočit reklamu
```

### Create test

```text
tests/video-adblock/multilingual-preroll-skip.spec.ts
```

Assertions:

- all visible enabled skip buttons are recognized when near video
- disabled/hidden skip buttons are not clicked
- skip-like text outside the video area is not clicked

---

## 8. Strengthen safety checker

### Edit

```text
tools/check-video-adblock-safety.mjs
```

Add required files:

```js
const REQUIRED_SOURCE_FILES = [
    "src/js/video-adblock/preroll-skip-detector.ts",
    "src/js/video-adblock/site-adapters/generic-preroll-skipper.ts",
    "tests/video-adblock/same-player-preroll-skip.spec.ts",
    "tests/video-adblock/multilingual-preroll-skip.spec.ts",
];
```

Add required APIs:

```text
findVisibleSkipControlsForVideo
safelyClickVisibleSkipControl
genericPrerollSkipperAdapter
skipClickElements
```

Change `.click()` rule:

- still forbid `.click()` in generic video code generally
- allow it only in:

```text
src/js/video-adblock/safe-actions.ts
```

and only inside:

```text
safelyClickVisibleSkipControl
```

Forbidden everywhere else:

```text
completeAd
adComplete
fakeClick
fakeView
fakeCompletion
impression
viewability
sendBeacon
window.open =
Window.prototype.open
HTMLVideoElement.prototype
```

---

## 9. Do not use YouTube-specific code directly

Do not copy the YouTube payload sanitizer into the generic adapter.

Do not add generic MAIN-world JSON/fetch/XHR hooks yet.

The generic solution should first use:

```text
visible real skip button
near real video
enabled
not hidden
not disabled
clicked once
```

This avoids fake ad completion and avoids broad page interference.

---

## 10. Optional later phase: generic VAST response pruning

Only after the visible-skip approach is stable, consider a separate **adapter-gated MAIN-world VAST/VMAP response sanitizer**.

That later phase must be:

- off by default
- host/category gated
- evidence backed
- not global
- not applied on Suno/Yandex/YouTube/ChatGPT
- limited to VAST/VMAP XML/JSON ad payloads
- never applied to real media streams

Do not implement this in the current phase.

---

## 11. Run checks

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

## 12. Manual expectations on the failing behavior

Expected after implementation:

- user presses the site’s normal play button
- preroll ad starts
- extension waits until the real skip button appears
- extension clicks that visible enabled skip button once
- content resumes
- real video remains playable
- no fake ad completion/impression/click/viewability is sent
- no publisher domain is hardcoded
- no global click/open/fetch patch is added

---

## 13. Why this is still a general solution

This handles a general video-ad pattern:

```text
same-player preroll → delayed visible skip control → content resumes after skip
```

It does not depend on the adult site domain. It should also help on other non-YouTube video sites that use the same delayed skip-button pattern.
