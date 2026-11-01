# Historical provider architecture audit — distilled

**Scope:** Agent_X LLM7 plan, original Git blob `415b6f5c8a80d22a212c5c8baf9b82e738c363d8`; not a current DT code audit. [Master](00_MAIN_PROMPT.md), [D01 synthesis](DISTILLED_KNOWLEDGE.md).

**Existing locations to verify, not assume:** `src/app/providers/catalog.ts`, `definitions/{opencode,codex}.ts`, `registry.ts`, `install-backend.ts`, `runtime-config.ts`, `definitions/index.ts`, `__tests__/`. Inspect repo governance and preserve working tree. Trace provider type→catalog→definition→registry→install/no-install→runtime config→stored config→interactive/headless selection→model discovery→transport→SSE/tool normalization→errors→tests. Find existing generic OpenAI-compatible client and determine whether its constructor sends Authorization with absent/fake key.

**Output contract:** exact single canonical extension path, minimum changed files, real OpenCode/Codex parity and tests. Remote provider must not gain fake local install or mandatory login. No static model IDs, second provider subsystem or unrelated refactor. SDK anonymous behavior requires actual wire-level proof. A preparatory fix must be necessary and regression-tested. **Unknown:** whether paths still exist and whether any current DT gap remains; inspect current repository before applying.
