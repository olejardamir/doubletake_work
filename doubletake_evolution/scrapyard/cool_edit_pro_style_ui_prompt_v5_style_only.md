# LLM Prompt: Cool Edit Pro–Inspired **Style-Only** Transfer for EVP Ghost Hunter UI

## Purpose

You are a coding LLM working on this repository:

```text
https://github.com/olejardamir/evp_ghost_hunter
```

Your task is to apply a **visual style transfer only** to the existing React/Vite UI so that the current interface visually resembles a late-1990s / early-2000s Windows waveform editor inspired by Cool Edit Pro.

This is **not** a feature prompt. This is **not** a layout expansion prompt. This is **not** a request to add missing controls, panels, menus, tracks, toolbars, meters, or editing features. The task is to restyle what already exists.

Do not copy proprietary branding, product names, logos, exact icons, or exact UI artwork. Produce an original EVP Ghost Hunter interface that borrows only the general visual language: old Windows chrome, grey beveled controls, black waveform editor canvas, bright green waveform, compact technical text, dense utility panels, and inset/raised surfaces.

---

## Non-negotiable scope: style only

### You may change

```text
- CSS extensively.
- Existing class names.
- Existing element grouping only where necessary for styling.
- WaveSurfer visual options: waveColor, progressColor, cursorColor, height, bar settings, region color.
- Existing text presentation through CSS only.
- Existing panel spacing, borders, colors, typography, density, and visual hierarchy.
```

### You may not change

```text
- Do not add new product features.
- Do not add new workflow steps.
- Do not add new data model fields.
- Do not add new processing modes.
- Do not add backend behavior.
- Do not add dependencies, UI frameworks, icon libraries, or CSS frameworks.
- Do not add new toolbar buttons because the reference image has many buttons.
- Do not add a menu bar unless an equivalent menu/header already exists and is only being restyled.
- Do not add new file panels, meters, tabs, rulers, tracks, or controls purely to match the screenshot.
- Do not remove existing functionality.
- Do not alter API contracts.
- Do not turn existing controls into non-functional decorations.
```

### Preferred implementation restriction

Prefer a **CSS-first** update. TSX changes should be limited to:

```text
- adding class names,
- adding wrappers strictly needed for styling existing elements,
- changing WaveSurfer color/config values,
- removing no functionality.
```

If a reference screenshot feature has no existing equivalent in the app, ignore that feature. Transfer its **style language**, not the feature itself.

---

## Target visual identity

The interface should read immediately as:

```text
old Windows audio editor
classic grey desktop utility
compact waveform tool
technical sound editor
black waveform canvas with neon green audio
beveled grey panels and controls
small dense labels and status readouts
```

The interface must not read as:

```text
modern SaaS dashboard
landing page
glassmorphism React template
minimalist waveform viewer
mobile-first card UI
modern DAW with smooth dark theme
soft pastel music app
```

---

## Exact style transfer goals from the reference image

Transfer these **visual traits only**:

```text
1. Old Windows application chrome:
   grey body, blue title/header strip, hard rectangular edges, 3D borders.

2. Dense menu/toolbar feeling:
   compact controls, small text, square raised buttons, utility-app density.
   Do not add buttons; only style existing controls this way.

3. Dark waveform editor:
   black canvas, green waveform, thin grid lines, small time/sample markings.
   If exact time/sample markings are not already present, do not add functional markings; use subtle CSS grid/ruler styling only.

4. Left utility-pane feeling:
   grey/dark grey inset panel, compact list rows, small tabs/badges if already present.
   Do not add new tabs or panels.

5. Bottom transport/readout feeling:
   square transport controls, inset digital-style time readout, grey status strip.
   Only style existing transport/status controls.

6. Windows 9x/early XP bevel language:
   raised borders for buttons, recessed borders for fields/canvases, no floating cards.

7. Technical typography:
   Tahoma/Verdana/Arial, tiny labels, monospace only for numbers/time/readouts.
```

---

## Visual mapping: reference style → existing app

Use this mapping only as a style guide. Do not add missing equivalents.

```text
Reference title bar / blue strip
→ existing app header/top area should look like old desktop app chrome.

Reference menu/toolbar rows
→ existing button/transport/upload/process controls should become compact beveled toolbar-like controls.

Reference left Files/Effects pane
→ existing sidebar, loaded-file area, or annotation/chunk list should become a dark grey utility pane with compact rows.

Reference waveform editor
→ existing WaveSurfer container(s) should become black editor canvas with bright green waveform and grid overlay.

Reference yellow cursor/selection markers
→ existing selected regions/cursor should use yellow-green technical selection styling.

Reference bottom time/status/readouts
→ existing status line, time labels, and controls should become inset technical readout boxes.
```

---

## Color palette

Use a constrained old-Windows/audio-editor palette. Avoid modern gradients except tiny title-bar/chrome gradients.

```css
:root {
  --cep-title-blue: #064aa8;
  --cep-title-blue-dark: #002f7a;
  --cep-title-blue-light: #1a6ed1;

  --cep-chrome: #8b939d;
  --cep-chrome-dark: #59616b;
  --cep-chrome-darker: #3f4650;
  --cep-chrome-light: #c8cdd2;
  --cep-chrome-highlight: #f2f4f6;

  --cep-button: #a8b0ba;
  --cep-button-face: #9ca5af;
  --cep-button-highlight: #f4f6f8;
  --cep-button-shadow: #343b44;

  --cep-pane: #555e69;
  --cep-pane-dark: #424b56;
  --cep-pane-light: #707985;

  --cep-editor-black: #000500;
  --cep-editor-grid-major: rgba(52, 255, 154, 0.22);
  --cep-editor-grid-minor: rgba(52, 255, 154, 0.09);
  --cep-wave: #2dff91;
  --cep-wave-dim: #0ca85a;
  --cep-wave-fill: rgba(45, 255, 145, 0.36);
  --cep-cursor: #fff36b;
  --cep-selection: rgba(255, 232, 78, 0.28);

  --cep-text-dark: #101418;
  --cep-text-light: #eef3f8;
  --cep-text-muted: #d0d6dc;
  --cep-readout-green: #90ffc0;
}
```

Do not use:

```text
- white app background,
- purple/blue SaaS gradients,
- frosted transparent panels,
- pastel waveform colors,
- large neon cyberpunk backgrounds,
- rounded modern card colors.
```

---

## Typography rules

Use a compact Windows-era font stack globally:

```css
font-family: Tahoma, Verdana, Arial, sans-serif;
font-size: 11px;
line-height: 1.15;
```

Use monospace only for time/readout values:

```css
font-family: "Courier New", Consolas, monospace;
```

Style requirements:

```text
- No giant hero typography.
- No marketing headline scale.
- Headings should be compact utility labels.
- Labels should be tiny, often uppercase or title-case.
- Text should feel technical and dense.
```

If current content contains large headings, reduce their visual size through CSS. Do not rewrite content unless necessary for layout consistency.

---

## Bevel system

Create consistent raised and inset styles.

### Raised controls

Use for buttons, toolbar-like controls, upload button, process button, export button.

```css
.cep-raised,
button {
  border-radius: 0;
  border-top: 2px solid var(--cep-button-highlight);
  border-left: 2px solid var(--cep-button-highlight);
  border-right: 2px solid var(--cep-button-shadow);
  border-bottom: 2px solid var(--cep-button-shadow);
  background: var(--cep-button-face);
  color: var(--cep-text-dark);
  box-shadow: none;
}
```

### Pressed/inset controls

Use for inputs, textareas, selects, waveform canvas, status/readout boxes, list panes.

```css
.cep-inset,
input,
textarea,
select {
  border-radius: 0;
  border-top: 2px solid var(--cep-button-shadow);
  border-left: 2px solid var(--cep-button-shadow);
  border-right: 2px solid var(--cep-button-highlight);
  border-bottom: 2px solid var(--cep-button-highlight);
  background: var(--cep-pane-dark);
  color: var(--cep-text-light);
  box-shadow: none;
}
```

### Pressed button state

```css
button:active,
button.is-active {
  border-top-color: var(--cep-button-shadow);
  border-left-color: var(--cep-button-shadow);
  border-right-color: var(--cep-button-highlight);
  border-bottom-color: var(--cep-button-highlight);
  transform: translate(1px, 1px);
}
```

---

## Layout geometry and density

Make the UI dense and rectangular.

```text
- Border radius: 0–3px maximum.
- Padding: compact, usually 2px–8px.
- Margins: tight, utility-app density.
- Avoid large vertical gaps.
- Avoid centered landing-page spacing.
- Avoid rounded panels and floating cards.
- Avoid modern shadows; use bevel borders instead.
```

The app should feel like it is inside a fixed desktop application window, not a website.

Suggested body/app surface:

```css
body {
  margin: 0;
  background: #59616b;
  color: var(--cep-text-dark);
  font-family: Tahoma, Verdana, Arial, sans-serif;
}

.app-shell {
  width: 100vw;
  min-height: 100vh;
  padding: 0;
  background: var(--cep-chrome);
  border: 2px solid var(--cep-button-shadow);
}
```

Adjust class names to match the current app.

---

## Header/top area style

If the app already has a top/header area, style it like old Windows chrome:

```text
- dark/medium blue title strip,
- small white title text,
- grey control/tool area underneath,
- compact controls,
- no large hero spacing.
```

Do not add a real menu bar unless one already exists. If no menu exists, do not create File/Edit/View menus. Instead, use the existing header/control area with this visual treatment.

Suggested style:

```css
.header,
.hero,
.app-top {
  background: linear-gradient(to right, var(--cep-title-blue-dark), var(--cep-title-blue), var(--cep-title-blue-light));
  color: white;
  border-bottom: 2px solid var(--cep-button-shadow);
  padding: 3px 6px;
  min-height: 22px;
}
```

If the current app has large upload-card styling, make it compact and toolbar-like, not a large drop-zone card.

---

## Buttons and transport controls

All existing buttons should look like old toolbar/transport buttons.

Requirements:

```text
- square corners,
- small height,
- dense labels,
- grey raised bevel,
- dark text,
- pressed state inset,
- disabled state faded/flat.
```

Suggested CSS:

```css
button {
  min-height: 22px;
  padding: 2px 7px;
  border-radius: 0;
  font-size: 11px;
  font-family: Tahoma, Verdana, Arial, sans-serif;
}

button:disabled {
  color: #5d646c;
  background: #8a929b;
  text-shadow: 1px 1px rgba(255,255,255,0.35);
}
```

Avoid:

```text
- gradient CTA buttons,
- pill buttons,
- large rounded controls,
- emoji controls,
- large icon-library controls.
```

---

## Inputs, textareas, selects, sliders

Style existing form controls as compact utility fields.

Requirements:

```text
- inset border,
- square corners,
- small font,
- dark grey or grey background,
- compact height,
- no modern rounded form styling.
```

Textareas should feel like old notes/properties fields, not modern large cards.

Range sliders may remain browser-native if necessary, but their container/label should match the grey control panel style.

---

## Waveform editor: most important area

The waveform area is the highest-priority style target.

Required visual result:

```text
- black/near-black editor canvas,
- bright green waveform,
- thin green/grey grid overlay,
- yellow cursor or selection line,
- inset border around editor,
- dense technical ruler feel.
```

WaveSurfer configuration should use:

```ts
waveColor: '#2dff91',
progressColor: '#0ca85a',
cursorColor: '#fff36b',
```

If there are multiple waveform containers already, style all of them consistently. If there is only one waveform container, style only that one. Do not add additional waveform lanes just for style transfer.

Suggested CSS overlay:

```css
.waveform,
.waveform-editor,
.track-waveform {
  background-color: var(--cep-editor-black);
  background-image:
    linear-gradient(to right, var(--cep-editor-grid-major) 1px, transparent 1px),
    linear-gradient(to right, var(--cep-editor-grid-minor) 1px, transparent 1px),
    linear-gradient(to bottom, var(--cep-editor-grid-major) 1px, transparent 1px),
    linear-gradient(to bottom, var(--cep-editor-grid-minor) 1px, transparent 1px);
  background-size: 96px 100%, 16px 100%, 100% 48px, 100% 12px;
}
```

If WaveSurfer renders inside canvas/shadow DOM and the CSS background is not visible, apply the black/grid background to the parent container and ensure the WaveSurfer element is transparent where possible.

---

## Region selection style

Selected regions should look like classic audio-editor selections.

Requirements:

```text
- translucent yellow/amber selection,
- sharp vertical boundaries,
- no rounded selection cards,
- no pastel React highlight.
```

Use region color like:

```ts
regions.enableDragSelection({
  color: 'rgba(255, 232, 78, 0.28)'
});
```

If existing region styling allows borders, use:

```css
border-left: 1px solid #fff36b;
border-right: 1px solid #fff36b;
```

---

## Sidebar, lists, annotation/chunk panels

If the current UI has sidebars, saved regions, loaded files, or annotation lists, style them like old utility panes.

Requirements:

```text
- dark grey pane,
- inset border,
- compact rows,
- tiny text,
- rectangular badges,
- no card shadows,
- no rounded notification-list look,
- scrollable file-list/effects-list feeling.
```

Rows should look like old file/effect rows:

```css
.annotation-row,
.chunk-row,
.file-row {
  background: #6b747f;
  border-top: 1px solid #aeb5bc;
  border-left: 1px solid #aeb5bc;
  border-right: 1px solid #333a42;
  border-bottom: 1px solid #333a42;
  padding: 3px 5px;
  border-radius: 0;
}
```

Badges should be small rectangles, not pills:

```css
.badge {
  border-radius: 0;
  padding: 1px 3px;
  font-size: 9px;
  border: 1px solid #232a31;
  background: #c0c7ce;
  color: #101418;
}
```

---

## Status/readout areas

Any existing status lines, time displays, counters, or messages should become old-style readouts.

Requirements:

```text
- inset box,
- monospace for numeric values,
- small uppercase utility text where appropriate,
- grey background or dark readout background,
- no alert-card styling.
```

Suggested CSS:

```css
.status-line,
.readout,
.time-display {
  border-top: 2px solid var(--cep-button-shadow);
  border-left: 2px solid var(--cep-button-shadow);
  border-right: 2px solid var(--cep-button-highlight);
  border-bottom: 2px solid var(--cep-button-highlight);
  background: #3f4650;
  color: var(--cep-readout-green);
  font-family: "Courier New", Consolas, monospace;
  font-size: 11px;
  padding: 2px 5px;
}
```

Do not add new readouts. Restyle existing ones.

---

## Scrollbars

If the app has scrollable lists, optionally style scrollbars to match the old grey UI:

```css
.scroll-pane::-webkit-scrollbar,
.annotations-list::-webkit-scrollbar {
  width: 14px;
  height: 14px;
}

.scroll-pane::-webkit-scrollbar-track,
.annotations-list::-webkit-scrollbar-track {
  background: #68717c;
}

.scroll-pane::-webkit-scrollbar-thumb,
.annotations-list::-webkit-scrollbar-thumb {
  background: var(--cep-button-face);
  border-top: 1px solid var(--cep-button-highlight);
  border-left: 1px solid var(--cep-button-highlight);
  border-right: 1px solid var(--cep-button-shadow);
  border-bottom: 1px solid var(--cep-button-shadow);
}
```

This is optional and should not introduce layout breakage.

---

## Anti-modern removal checklist

Before finishing, inspect the UI and remove/restyle anything that visually resembles:

```text
- hero section,
- marketing landing page,
- modern dashboard card,
- 16px+ border radius,
- soft drop shadow,
- glass/frosted panel,
- modern gradient CTA button,
- large whitespace,
- large headline typography,
- pastel waveform,
- pill badges,
- mobile-first rounded controls.
```

Replace with:

```text
- compact grey application chrome,
- square panels,
- bevels/insets,
- small Tahoma/Verdana labels,
- black waveform editor,
- green waveform,
- yellow technical selection,
- dense status/readout styling.
```

---

## Style-only acceptance criteria

The style transfer is complete only if all of these are true:

```text
- Existing behavior still works.
- The app builds.
- No new features were added.
- No new workflow elements were added.
- The UI no longer looks like a modern web dashboard.
- The interface reads visually as an old Windows waveform editor.
- The waveform area is black/green with grid/ruler feel.
- Buttons are compact square grey beveled controls.
- Form fields are inset utility fields.
- Lists/panels are grey dense utility panes.
- Header/top area is compact app chrome, not a large hero section.
- Border radii are mostly 0–3px.
- Typography is small and technical.
```

The style transfer is incomplete if any of these remain:

```text
- large rounded cards,
- big modern headings,
- pastel or light waveform editor,
- modern CTA buttons,
- airy white-space-heavy layout,
- glassmorphism/shadow-heavy UI,
- pill badges,
- marketing-page feel.
```

---

## Build check

Run:

```bash
cd ui
npm install
npm run build
```

Fix all build errors.

---

## Final report format

Report only:

```text
Files changed:
- ...

Style-only changes completed:
- old Windows grey chrome
- black/green waveform editor styling
- bevel/inset controls
- compact technical typography
- dense utility-list/panel styling
- status/readout restyling

Functional changes:
- none intended

Build:
- passed / failed

Known limitations:
- ...
```

Suggested commit message:

```text
Apply Cool Edit Pro inspired style-only transfer
```
