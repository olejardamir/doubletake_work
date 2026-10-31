# LLM Prompt: Finish the Cool Edit Pro Bottom Player Style

## Task

Update the existing EVP Ghost Hunter React UI so the **bottom player / transport strip** matches the supplied Cool Edit Pro reference image as closely as possible.

This prompt is focused on the **bottom player only**. Do not redesign the whole app. Do not change the waveform layout, sidebars, chunk panel, or right-side annotation panel unless a tiny spacing adjustment is needed to stop the bottom bar from overlapping them.

Keep existing app behavior. This is mainly a visual/style and layout pass.

---

## Current problem to fix

The current bottom player is close, but the following details are not fully covered or still need polish:

1. Some icons overlap text or sit too close to labels.
2. The bottom player does not yet fully match the reference control strip.
3. The reference has **all transport buttons**, not only play/pause.
4. The reference has a separate **zoom button matrix**.
5. The reference has a large central time readout.
6. The reference has a right-side Begin / End / Length field table.
7. The app must keep **CH 01 / CH 02 / CH 03** controls visible and integrated into the bottom player.
8. The bar must stay compact, beveled, dense, and retro; it must not become a modern web toolbar.

---

## Reference style target

The bottom player should resemble a late-1990s / early-2000s Windows audio editor, especially Cool Edit Pro:

- blue-gray metal panel
- hard beveled borders
- square raised buttons
- inset pressed button states
- tight pixel-like spacing
- no rounded modern pills
- no glass effects
- no soft shadows
- no Material / Bootstrap / Tailwind-looking controls
- large central digital time display
- small right-side selection/view fields
- dense control groups separated by vertical bevel grooves

Use this design language throughout the bottom player.

---

## Required overall layout

Build the bottom player as one horizontal strip.

Recommended visual structure:

```text
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│ [Transport 2x5] │ [Zoom 2x4] │        BIG TIME DISPLAY        │ [Begin/End/Length table] │
│                 │            │       [CH 01] [CH 02] [CH 03]  │                          │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

Use this CSS layout approach:

```css
.bottom-player {
  height: 86px;
  display: grid;
  grid-template-columns: auto auto minmax(260px, 1fr) auto;
  align-items: stretch;
  overflow: hidden;
}
```

If the available width is too small, allow the strip itself to scroll horizontally rather than stacking into modern vertical cards:

```css
@media (max-width: 1100px) {
  .bottom-player {
    overflow-x: auto;
    overflow-y: hidden;
  }
}
```

The bottom strip must remain a continuous retro control panel.

---

## Bottom player container styling

Use a steel-blue beveled container similar to the reference:

```css
.bottom-player {
  background: #5b6874;
  border-top: 2px solid #aab4bd;
  border-left: 2px solid #aab4bd;
  border-right: 2px solid #2a333c;
  border-bottom: 2px solid #2a333c;
  box-shadow:
    inset 1px 1px 0 #d4dbe1,
    inset -1px -1px 0 #28313a;
  color: #e8edf1;
}
```

Every group inside it should look physically separated by grooves:

```css
.player-group {
  padding: 4px 6px;
  border-left: 2px solid #2f3842;
  border-right: 2px solid #9ca7b1;
  box-shadow:
    inset 1px 0 0 #75818c,
    inset -1px 0 0 #3a444e;
}
```

Avoid `border-radius` except `0` or `1px`.

---

## Required transport buttons: all buttons must be present

Create a **2-row by 5-column transport matrix** on the left.

Button order must be:

```text
Top row:
[ Stop ] [ Play ] [ Pause ] [ Play selected / loop region ] [ Loop toggle / infinity ]

Bottom row:
[ To start ] [ Rewind ] [ Fast forward ] [ To end ] [ Record ]
```

Use these glyphs or equivalent simple pixel-style symbols:

```text
Top row:    ■   ▶   ❚❚   ◇▶   ∞
Bottom row: |◀  ◀◀  ▶▶   ▶|   ●
```

Behavior requirements:

- Play keeps existing play behavior.
- Pause pauses playback.
- Stop pauses and seeks to zero or current view start if that is already the app convention.
- Play selected / loop region should trigger existing selected-region playback if available.
- Infinity loop should toggle the existing loop-selected-region state.
- To start, rewind, fast forward, to end, and record may be safe no-ops if not implemented yet, but they must have `title` attributes and must not throw console errors.
- Record is visual only unless recording exists already.

Do not remove any existing working behavior.

---

## Required zoom buttons: all buttons must be present

Add a **2-row by 4-column zoom matrix** immediately to the right of the transport group.

Button order:

```text
Top row:
[ Zoom in ] [ Zoom out ] [ Zoom to selection ] [ Zoom full ]

Bottom row:
[ Fine zoom in ] [ Fine zoom out ] [ Horizontal zoom ] [ Reset zoom ]
```

Use simple glyphs if no icon library is present:

```text
Top row:    ⌕+   ⌕−   ⌕▭   ⌕↔
Bottom row: ⌕1   ⌕2   ⌕3   ⌕0
```

If zoom actions are not implemented, wire safe no-op handlers and add descriptive `title` attributes.

Do not add a dependency just for icons.

---

## Button styling

All transport and zoom buttons must be square, beveled, dense, and retro.

Use this base:

```css
.retro-button {
  width: 34px;
  height: 30px;
  padding: 0;
  margin: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0;
  background: linear-gradient(#eef2f4, #aab5bd 48%, #dce2e6 50%, #8d98a2);
  border-top: 2px solid #ffffff;
  border-left: 2px solid #ffffff;
  border-right: 2px solid #424b54;
  border-bottom: 2px solid #424b54;
  box-shadow:
    inset 1px 1px 0 #ffffff,
    inset -1px -1px 0 #6d7780;
  font-size: 15px;
  font-weight: 900;
  line-height: 1;
  text-align: center;
  color: #007b69;
  overflow: hidden;
  white-space: nowrap;
}
```

Pressed / active state:

```css
.retro-button.active,
.retro-button:active {
  border-top-color: #3a434d;
  border-left-color: #3a434d;
  border-right-color: #eef3f6;
  border-bottom-color: #eef3f6;
  background: linear-gradient(#87939d, #c6ced4);
  transform: translate(1px, 1px);
}
```

Use colors:

```css
.transport-button {
  color: #007c68;
}

.zoom-button {
  color: #798300;
}

.record-button {
  color: #a90000;
}

.retro-button:disabled {
  color: #68727a;
  opacity: 1;
}
```

---

## Mandatory icon/text overlap fixes

Fix all overlap problems in the bottom bar.

Requirements:

- No button icon may overlap any text.
- No channel label may overlap a button.
- No text may be vertically clipped in fields.
- Button contents must be centered with `display: inline-flex`.
- Use fixed `width` and `height` for buttons.
- Use `line-height: 1` for icon glyphs.
- Do not place labels inside the transport or zoom buttons.
- Do not mix button icons and text labels in the same button.
- Use `title` attributes for accessibility/tooltips instead of visible text labels inside the small buttons.

If using SVG or image icons, force size:

```css
.retro-button svg,
.retro-button img {
  width: 15px;
  height: 15px;
  display: block;
  margin: auto;
  flex: 0 0 auto;
  pointer-events: none;
}
```

Prefer text glyphs over external images for this pass.

---

## Central time display

The center of the bar must contain a large time display like the reference.

It should be the most visually dominant object in the bottom player.

Style:

```css
.player-center {
  min-width: 280px;
  display: grid;
  grid-template-rows: 1fr auto;
  align-items: center;
  justify-items: center;
  padding: 2px 10px 4px;
  background: #5b6874;
  border-left: 2px solid #303943;
  border-right: 2px solid #9da8b2;
}

.time-display {
  font-family: "Arial Narrow", "Trebuchet MS", Arial, sans-serif;
  font-size: 56px;
  font-weight: 300;
  line-height: 0.95;
  letter-spacing: 0.02em;
  color: #f0f5f8;
  text-shadow: 1px 1px 0 #1d252c;
  white-space: nowrap;
}
```

Preferred format:

```text
0:00.000
```

Do not let the time display collide with the CH tabs below it.

---

## CH 01 / CH 02 / CH 03 must remain and fit inside the bottom player

Keep CH 01, CH 02, and CH 03 visible.

Recommended placement:

```text
         BIG TIME DISPLAY
      [ CH 01 ] [ CH 02 ] [ CH 03 ]
```

They must be integrated into the center group, below the big time display, unless the layout becomes too tight.

If vertical space is too tight, place them as a compact group between the zoom buttons and the time display:

```text
[Transport] [Zoom] [CH 01 CH 02 CH 03] [Big Time] [Fields]
```

Channel tab styling:

```css
.channel-tabs {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 4px;
  margin-top: 4px;
  min-height: 24px;
}

.channel-tab {
  min-width: 54px;
  height: 22px;
  padding: 0 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0;
  background: linear-gradient(#e0e5e9, #9ea9b2);
  border-top: 2px solid #f8fafb;
  border-left: 2px solid #f8fafb;
  border-right: 2px solid #3b444d;
  border-bottom: 2px solid #3b444d;
  color: #1d2830;
  font-size: 11px;
  font-weight: 800;
  line-height: 1;
  white-space: nowrap;
}

.channel-tab.active {
  color: #fff46a;
  background: linear-gradient(#596570, #303a43);
  border-top-color: #202830;
  border-left-color: #202830;
  border-right-color: #c5ccd2;
  border-bottom-color: #c5ccd2;
}
```

Spacing requirements:

- Leave at least `4px` between the big time readout and the channel tabs.
- Leave at least `6px` between the channel tabs and neighboring groups.
- CH tab text must not be clipped.
- CH tab text must not overlap button icons.

---

## Right-side Begin / End / Length table

The right side must resemble the field block in the reference image.

Required visual structure:

```text
          Begin       End       Length
Sel       0:02.05     0:07.00   0:04.95
View      0:00.00     0:14.00   0:14.00
```

Use read-only values. Do not make fields editable unless they already are.

Style:

```css
.time-fields {
  display: grid;
  grid-template-columns: 42px 86px 86px 86px;
  grid-auto-rows: 20px;
  gap: 3px;
  align-items: center;
  padding: 4px 6px;
  color: #d8e0e6;
  font-size: 12px;
  min-width: 318px;
}

.time-field-heading {
  text-align: center;
  color: #d7dee4;
  text-shadow: 1px 1px 0 #27313a;
  line-height: 1;
}

.time-field-label {
  text-align: right;
  color: #d5dde3;
  padding-right: 3px;
  line-height: 1;
}

.time-field-value {
  height: 20px;
  padding: 2px 5px;
  display: flex;
  align-items: center;
  background: #303943;
  border-top: 2px solid #1f262d;
  border-left: 2px solid #1f262d;
  border-right: 2px solid #a8b1ba;
  border-bottom: 2px solid #a8b1ba;
  color: #e8edf1;
  font-family: "Courier New", monospace;
  font-size: 12px;
  font-weight: 700;
  overflow: hidden;
  white-space: nowrap;
}
```

If exact values are not available, compute:

- Sel Begin = selected region start
- Sel End = selected region end
- Sel Length = selected region duration
- View Begin = 0 or current visible start
- View End = audio duration
- View Length = visible range or audio duration

If no region is selected, show zero values for Sel.

---

## Divider and groove details

The reference has strong vertical grooves between sections. Add narrow beveled dividers where needed:

```css
.player-divider {
  width: 4px;
  background: linear-gradient(to right, #29323b, #8996a1, #29323b);
  box-shadow:
    inset 1px 0 0 #1e252c,
    inset -1px 0 0 #aab4bd;
}
```

Use dividers or group borders between:

- transport buttons and zoom buttons
- zoom buttons and central time display
- central time display and right fields

The final strip should look segmented but continuous.

---

## Responsive behavior

Do not stack the bottom player into cards.

For smaller widths:

```css
@media (max-width: 1100px) {
  .bottom-player {
    overflow-x: auto;
  }

  .time-display {
    font-size: 42px;
  }

  .retro-button {
    width: 30px;
    height: 28px;
    font-size: 13px;
  }

  .time-fields {
    grid-template-columns: 38px 74px 74px 74px;
    min-width: 276px;
  }
}
```

The visual identity must remain retro even in responsive mode.

---

## Files to update

Likely files:

```text
ui/src/App.tsx
ui/src/components/WaveformWorkbench.tsx
ui/src/styles.css
```

If the bottom player already exists as a separate component, update that component instead.

Do not restructure the entire project unless absolutely necessary.

---

## Build and manual checks

Run:

```bash
cd ui
npm run build
```

Then manually check:

1. Bottom bar is a single Cool Edit Pro-like strip.
2. Transport group has exactly 10 visible buttons in a 2x5 layout.
3. Zoom group has exactly 8 visible buttons in a 2x4 layout.
4. All buttons are square, beveled, and compact.
5. Play, pause, stop, selected-region play, and loop preserve existing behavior where possible.
6. CH 01, CH 02, and CH 03 are still visible and integrated into the bar.
7. Central time readout is large and white.
8. Begin / End / Length table appears on the right.
9. No button icon overlaps text.
10. No channel tab text overlaps icons.
11. No field text is vertically clipped.
12. The bottom bar does not overlap the waveform or side panels.
13. The app still builds successfully.

---

## Do not do

Do not:

- redesign the whole UI
- change the waveform visual style in this pass
- change sidebar contents
- add unrelated features
- remove CH 01 / CH 02 / CH 03
- replace the retro strip with modern UI components
- use rounded pills, soft shadows, cards, or translucent glass
- introduce a new icon dependency just for this toolbar
- allow any icon/text overlap
- allow console errors from placeholder buttons
