# Prompt 01 — Audit the Real Agent_X Provider Architecture

## Objective

Before changing code, map the **actual current provider architecture** in Agent_X and identify the exact extension points required to add LLM7 as a first-class provider.

This phase must produce implementation-ready certainty, not a speculative design.

## Required work

1. Locate the real Agent_X repository root.
2. Read all repository-local implementation instructions.
3. Inspect Git status and preserve all existing work.
4. Find and read the provider implementation, starting with these previously identified paths:

   ```text
   src/app/providers/catalog.ts
   src/app/providers/definitions/opencode.ts
   src/app/providers/definitions/codex.ts
   src/app/providers/registry.ts
   src/app/providers/install-backend.ts
   src/app/providers/runtime-config.ts
   src/app/providers/definitions/index.ts
   src/app/providers/__tests__/
   ```

5. If any path has moved, locate the current equivalent. Do not create a second architecture merely because a previously known path no longer exists.
6. Trace, end to end:
   - provider identifiers/types;
   - provider catalog metadata;
   - provider definition modules;
   - registry construction;
   - install/backend handling;
   - runtime configuration construction;
   - environment/config persistence;
   - provider selection UX;
   - CLI/headless configuration;
   - model selection;
   - request transport;
   - streaming event normalization;
   - tool/function-call handling;
   - error mapping;
   - provider-specific tests.
7. Determine how OpenCode and Codex are currently implemented and which parts are provider-generic versus provider-specific.
8. Search the repository for any existing generic **OpenAI-compatible** transport/adapter/client. Reuse it if it can satisfy LLM7's anonymous behavior without emitting unwanted authentication headers.
9. Identify any code path that assumes every remote provider requires a key, login, credential name, token prompt, or `Authorization` header.
10. Identify the minimum set of files that must change for LLM7 and the tests that exercise those files.

## Hard constraints

- Do not implement a parallel provider subsystem.
- Do not remove or weaken OpenCode or Codex.
- Do not refactor unrelated provider code.
- Do not assume an SDK can represent anonymous mode correctly until you inspect whether it sends authentication automatically.
- Do not hardcode model IDs in this phase.
- Do not stop with only a prose architecture note if the repository already contains obvious small preparatory fixes required for a clean provider extension. Make only necessary, behavior-preserving preparatory changes and test them.

## Completion criteria

This phase is complete only when the codebase clearly exposes a single intended path for LLM7 through the existing provider architecture and you know exactly:

```text
provider identity
catalog entry
definition entrypoint
registry wiring
backend/install behavior
runtime config path
transport path
model discovery path
interactive config path
headless config path
streaming path
tool-calling path
tests to extend
```

Do not invent new layers unless the current architecture proves they are required.
