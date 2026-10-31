# LLM Prompt: Style-Only Polish for Cool Edit Pro EVP Ghost Hunter UI

You are working on the React/Vite UI in this repository:

```text
https://github.com/olejardamir/evp_ghost_hunter
```

The UI has already been restyled toward a Cool Edit Pro / Windows 98-era waveform editor. The current result is visually strong, but it needs a final **style-only polish pass** based on the latest screenshot.

This prompt is **only about visual styling and layout polish**. Do **not** add new product features, do **not** change audio behavior, do **not** change the data model unless absolutely required for styling, and do **not** add unrelated UI elements. Preserve the existing UI structure and only make the current interface look more faithful, readable, and clean.

---

## Current visual state

The UI currently has:

```text
- blue application title bar
- grey Windows 98-style side panels
- left session/chunks sidebar
- central black waveform grid with CH 01 / CH 02 / CH 03 lanes
- right Active Chunk editor panel
- bottom transport strip
- yellow selection region
- neon-green waveform look
```

The style direction is correct. Keep it.

The remaining issues are small visual/style problems:

```text
1. Some chunk-row icons overlap or crowd the chunk text.
2. CH 01, CH 02, and CH 03 waveforms need distinct colors.
3. The three channel lanes need more visible empty space between them.
4. The waveform editor needs ruler-like numeric measurement marks.
5. Selection overlay should remain visible but not overpower wave colors.
6. The right Active Chunk panel needs slightly better spacing.
7. The entire UI should remain old-school, square, compact, and non-modern.
```

---

## Non-negotiable style-only rule

Do not reinterpret this as a feature request.

Do **not** add:

```text
- new workflow features
- new processing modes
- new backend calls
- new data-export behavior
- new annotation semantics
- new audio-analysis logic
- new panels that are not already visually implied
- modern design components
```

Allowed changes:

```text
- CSS and visual constants
- small presentational wrappers needed to fix layout
- channel-specific color constants
- existing waveform/ruler visual rendering
- spacing, borders, shadows, labels, sizing, z-indexes
- minor presentational helper code only when needed for visual ruler ticks
```

The goal is to make the current UI look cleaner and more faithful to a classic audio editor, not to expand the app.

---

# Required style fixes

## 1. Fix chunk-row icon/text overlap

### Problem

In the left **CHUNKS** list, the small action icons/buttons are visually overlapping or crowding the chunk title/description and time text.

### Style-only fix

Each chunk row must reserve separate visual zones:

```text
[chunk number + text block                       ][small square buttons]
```

Requirements:

```text
- The text block must never run underneath icon buttons.
- The icon/action group must stay right-aligned.
- The text block must be allowed to shrink cleanly.
- Use min-width: 0 on the text area.
- Use ellipsis for long chunk descriptions.
- Keep the old-school square icon buttons.
- Do not make the buttons modern, circular, floating, or large.
```

Suggested CSS pattern:

```css
.chunk-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  align-items: center;
  column-gap: 6px;
}

.chunk-text {
  min-width: 0;
  overflow: hidden;
}

.chunk-title,
.chunk-time {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.chunk-actions {
  display: flex;
  flex: 0 0 auto;
  gap: 2px;
}
```

Acceptance check:

```text
No icon, button, or glyph overlaps chunk text at the current desktop viewport.
```

---

## 2. Use different waveform colors for CH 01, CH 02, and CH 03

### Problem

The three waveform lanes are currently too similar. They all read as green, so the lanes lose individual identity.

### Style-only fix

Keep the black/green grid background, but give each channel its own old-school neon waveform color.

Use this palette or very close equivalents:

```text
CH 01 — classic neon green
Stroke:        #35ff8f
Dim/reflection:#0f8f55
Fill/glow:     rgba(53, 255, 143, 0.18)

CH 02 — cyan/teal
Stroke:        #39d9ff
Dim/reflection:#147f99
Fill/glow:     rgba(57, 217, 255, 0.16)

CH 03 — amber/yellow composite
Stroke:        #ffbf45
Dim/reflection:#9a6b19
Fill/glow:     rgba(255, 191, 69, 0.16)
```

Requirements:

```text
- Wave strokes must be visibly different by lane.
- Grid lines should stay green/dark green.
- CH labels should match or subtly echo their lane color.
- Do not make the screen colorful in a modern way; colors must still feel like retro waveform/editor colors.
- The selected region must not wash all channels into the same yellow-green color.
```

Acceptance check:

```text
At a glance, CH 01, CH 02, and CH 03 can be identified by waveform color alone.
```

---

## 3. Add visible empty space between waveform lanes

### Problem

The three lanes are too vertically tight. They visually merge into one stacked waveform block.

### Style-only fix

Add clear, old-editor-style separation between CH 01, CH 02, and CH 03.

Requirements:

```text
- Add dark empty gutter space between lanes.
- Keep the central waveform editor compact, but do not let waveforms touch vertically.
- Each lane should feel like its own track strip.
- Use thin horizontal separators and/or dark gutters.
- The gutter should not contain bright UI decoration.
```

Suggested CSS approach:

```css
.wave-lane {
  position: relative;
  margin-bottom: 14px;
}

.wave-lane + .wave-lane {
  padding-top: 12px;
  border-top: 1px solid rgba(79, 155, 94, 0.28);
}

.wave-lane-gutter {
  height: 12px;
  background: #010904;
}
```

Acceptance check:

```text
CH 01, CH 02, and CH 03 read as three separate tracks even with dense waveforms.
```

---

## 4. Add/restore ruler-like numeric measurement styling

### Problem

The waveform area has grid lines, but it lacks the classic ruler-like numeric measurement marks visible in older audio editors.

### Style-only fix

Add or style a horizontal time ruler so it looks like a classic editor measurement strip.

This is a visual measurement layer, not a new workflow feature.

Requirements:

```text
- Show compact numeric time labels.
- Show major and minor ticks.
- Align ruler ticks with the waveform grid as closely as practical.
- Place the ruler at the top or bottom of the waveform editor area, whichever fits the current layout best.
- Use old-school small fonts.
- Keep ruler background dark, flat, and technical.
```

Example labels:

```text
0:00    0:10    0:20    0:30    0:40    0:50    1:00
```

For short audio, use shorter intervals:

```text
0:00    0:02    0:04    0:06    0:08
```

For longer audio, use larger intervals:

```text
0:00    0:30    1:00    1:30    2:00
```

Suggested styling:

```css
.timeline-ruler {
  height: 22px;
  position: relative;
  background: #07130c;
  border-top: 1px solid #1c5d39;
  border-bottom: 1px solid #1c5d39;
  color: #9dffbd;
  font-family: "MS Sans Serif", Tahoma, Arial, sans-serif;
  font-size: 10px;
  line-height: 1;
}

.ruler-tick {
  position: absolute;
  bottom: 0;
  width: 1px;
  background: rgba(157, 255, 189, 0.65);
}

.ruler-tick.major {
  height: 14px;
}

.ruler-tick.minor {
  height: 7px;
  opacity: 0.55;
}

.ruler-label {
  position: absolute;
  top: 2px;
  transform: translateX(-50%);
  white-space: nowrap;
  color: #c6ffd6;
}
```

Acceptance check:

```text
The waveform editor visibly has a ruler-like measurement strip with numbers and ticks, not only green grid lines.
```

---

## 5. Make selection overlay more transparent and precise

### Problem

The yellow selection region is useful, but it is visually heavy. It can flatten the three channel colors and make waveforms look too similar.

### Style-only fix

Keep the yellow/olive selection style, but reduce opacity and sharpen the boundaries.

Requirements:

```text
- Region fill should be transparent enough for all channel colors to remain visible.
- Start and end edges should be crisp.
- Use thin bright edge lines.
- Keep the selected region visually obvious.
- Do not convert it into a modern rounded highlight.
```

Suggested style:

```css
.selection-region,
.region-selection {
  background: rgba(214, 202, 42, 0.22);
  border-left: 2px solid #fff36a;
  border-right: 2px solid #fff36a;
  box-shadow: inset 0 0 0 1px rgba(255, 243, 106, 0.35);
}
```

Acceptance check:

```text
The selected range is obvious, but CH 01/CH 02/CH 03 colors remain readable through it.
```

---

## 6. Improve right Active Chunk panel spacing without changing content

### Problem

The right panel looks stylistically correct, but some controls feel cramped.

### Style-only fix

Improve spacing and alignment only.

Requirements:

```text
- Keep the panel compact.
- Keep all controls rectangular and old-school.
- Add slight vertical breathing room between field groups.
- Prevent labels from colliding with inputs.
- Prevent top CH selector from crowding the active chunk time text.
- Do not add new fields.
- Do not remove fields.
```

Suggested CSS:

```css
.active-chunk-panel .field-group {
  margin-bottom: 9px;
}

.active-chunk-panel label {
  display: block;
  margin-bottom: 3px;
}

.active-chunk-header {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 8px;
  align-items: start;
}
```

Acceptance check:

```text
The right panel remains compact but all labels, text, and controls are readable.
```

---

## 7. Preserve the retro Cool Edit Pro visual grammar

All fixes must reinforce the old software look.

Keep:

```text
- blue Windows-style title bar
- grey beveled panels
- compact toolbar feel
- square buttons
- black waveform background
- green grid
- small technical typography
- dense desktop-application layout
- utilitarian, non-web-app appearance
```

Avoid:

```text
- large modern rounded cards
- glassmorphism
- soft shadows that look like modern SaaS
- animated modern controls
- large whitespace outside the track area
- floating action buttons
- circular icon buttons
- mobile-first card layout on desktop
- pastel decorative colors
- modern gradients
```

Acceptance check:

```text
A viewer should still read the app as a late-1990s / early-2000s desktop audio editor, not a modern web dashboard.
```

---

# Specific screenshot-based issues to verify

Use the latest screenshot as the visual reference. Before finishing, visually inspect for these exact issues:

```text
[ ] Left chunk action icons do not cover or collide with text.
[ ] Chunk title and time text are readable in the left sidebar.
[ ] CH 01 waveform is a distinct green/mint.
[ ] CH 02 waveform is a distinct cyan/teal.
[ ] CH 03 waveform is a distinct amber/yellow or equivalent composite color.
[ ] CH 01/CH 02/CH 03 have visible dark gaps between lanes.
[ ] The grid still looks like an old audio editor.
[ ] A ruler-like strip with numeric time labels is visible.
[ ] Ruler labels are small, technical, and aligned with the waveform width.
[ ] Selection overlay is transparent enough to see wave colors underneath.
[ ] Selection start/end boundaries are precise.
[ ] Right panel spacing is improved but still compact.
[ ] Bottom transport remains square, grey, and old-school.
[ ] The UI has not been modernized.
```

---

# Files likely involved

Inspect the repo first. Likely files:

```text
ui/src/App.tsx
ui/src/components/WaveformWorkbench.tsx
ui/src/styles.css
```

Do not modify unrelated files unless necessary for visual styling.

---

# Build check

After changes:

```bash
cd ui
npm run build
```

The build must pass.

---

# Commit message suggestion

```text
Polish Cool Edit Pro style details
```
