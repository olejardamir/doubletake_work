# Cool Edit Pro / Windows 98 UI polish — condensed style specification

**Historical source:** user-authored UI-only prompt, original Git blob `0e1bef5ea3122a871fbf38230943a814e3b796e0` (full text and CSS samples recoverable through Git history). Target project named in source: https://github.com/olejardamir/evp_ghost_hunter . **Not a DoubleTake feature, instruction, approval or verified screenshot review.** Actual latest screenshot and repository state were not inspected in this distillation.

## Scope and visual invariants

Style-only changes to an existing React/Vite audio waveform UI. Retain blue application title bar, grey bevelled square panels/buttons, left sessions/chunks sidebar, black three-lane waveform grid, right Active Chunk editor, bottom transport strip, dense small Windows-era technical typography and utilitarian 1990s appearance. **No** new workflows, audio processing, backend calls, export/annotation semantics, data-model changes, extra panels, glassmorphism, large rounded cards, mobile-first redesign, pastel decoration or unrelated code edits.

## Seven distinct corrections and acceptance checks

1. **Chunk-row icon/text collision:** use a two-column grid `minmax(0,1fr) auto` with `min-width:0` on text, `text-overflow:ellipsis; white-space:nowrap` on title/time, right-aligned square action buttons, 6px gap. **Check:** long labels never pass beneath buttons.
2. **Distinct waveforms:** CH01 green `#35ff8f` (dim `#0f8f55`, glow rgba(53,255,143,.18)); CH02 cyan `#39d9ff` (dim `#147f99`, glow rgba(57,217,255,.16)); CH03 amber `#ffbf45` (dim `#9a6b19`, glow rgba(255,191,69,.16)). Labels echo lane colors; dark green grid remains. **Check:** lanes identifiable by waveform color through selection.
3. **Lane separation:** dark empty gutters (~12px), optional thin divider `1px solid rgba(79,155,94,.28)`; preserve compact track height. **Check:** dense waves do not visually merge.
4. **Time ruler:** flat dark `#07130c`, ~22px, small 10px MS Sans Serif/Tahoma, major/minor ticks (~14/7px), numeric labels at zoom-appropriate intervals (e.g. 0:00, 0:10, 0:20 or 0:02 increments). Align ruler with waveform grid; this is visual rendering, not a new measurement workflow.
5. **Selection:** translucent olive-yellow `rgba(214,202,42,.22)`, crisp `2px solid #fff36a` left/right boundaries, optional faint inset edge. **Check:** selection obvious but all three wave colors remain visible.
6. **Active Chunk panel:** compact field-group spacing (~9px), label margin (~3px), header grid `minmax(0,1fr) auto` and 8px gap. No new/missing fields; CH selector/time text must not collide.
7. **Retro grammar:** square grey transport, blue title bar, bevelled sidebars, dark waveform and green grid; no modern soft-shadow SaaS appearance. **Check:** visual reference still reads as a classic desktop audio editor.

## Reproduction and stop criteria

Inspect actual project before editing; historically suggested `ui/src/App.tsx`, `ui/src/components/WaveformWorkbench.tsx`, `ui/src/styles.css` (paths unverified). Compare against the *latest actual screenshot*, check icon/text overlap, per-channel color, gutters, numeric ruler alignment, transparent selection, compact right panel and bottom transport. Run `cd ui && npm run build`; a build pass is required but not sufficient for visual acceptance. Preserve functionality and do not change unrelated files. **Unknown:** current repo structure, screenshot, user approval and whether issues remain. This is a retained style reference, not an active DT mission.
