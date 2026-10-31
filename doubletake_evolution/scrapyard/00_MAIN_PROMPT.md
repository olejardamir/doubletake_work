# Agent_X LLM7 First-Class Provider — Master Execution Prompt

## Mission

Integrate **LLM7** into the real Agent_X repository as a **first-class provider** while preserving all existing provider behavior, especially the existing **OpenCode** and **Codex** integrations.

The defining requirement is that Agent_X must be able to use LLM7 in its **anonymous/no-login mode** when LLM7 currently permits it. Do not require the user to create an account, obtain an API key, or add an `Authorization` header for the anonymous path.

The live anonymous chat-completions request verified on 2026-09-11 used:

```text
POST https://api.llm7.io/v1/chat/completions
Content-Type: application/json
no Authorization header
```

with a normal OpenAI-compatible chat-completions body.

Treat live protocol behavior as something to verify, not something to assume permanently. LLM7 documentation and service behavior can change. The integration must therefore discover and validate capabilities instead of embedding fragile assumptions.

## Known Agent_X provider architecture

Start from the real repository and verify these paths rather than blindly assuming they are unchanged:

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

Agent_X already has a provider abstraction. Extend that abstraction. Do **not** create a parallel provider system.

## LLM7 integration invariants

The final implementation must satisfy all of the following:

1. LLM7 is represented as a normal first-class Agent_X provider.
2. Existing OpenCode and Codex providers continue to work unchanged unless a strictly necessary shared fix is required.
3. The LLM7 base URL is:

   ```text
   https://api.llm7.io/v1
   ```

4. Chat uses the OpenAI-compatible endpoint:

   ```text
   /chat/completions
   ```

5. Anonymous mode does not require account creation, API-key entry, or login.
6. Anonymous mode must not emit an `Authorization` header merely because an SDK normally expects an API key.
7. Models are discovered dynamically from:

   ```text
   GET https://api.llm7.io/v1/models
   ```

   Do not maintain a permanent hardcoded LLM7 model inventory.
8. Treat concrete model IDs as dynamic. A currently working model such as `codestral-latest` may be used for live verification, but must not become the only baked-in model.
9. Preserve and correctly handle streaming.
10. Preserve tool/function-calling behavior where the selected LLM7 model and access tier actually support it.
11. Capability claims must come from model metadata and/or live probes, not wishful defaults.
12. Interactive setup and non-interactive/headless configuration must both work.
13. A missing LLM7 credential must not be reported as an error when anonymous mode is selected and the service accepts anonymous traffic.
14. Paid/token-only LLM7 features must never be silently presented as anonymously available.
15. Authentication failures, rate limits, unavailable models, malformed responses, streaming failures, and capability mismatches must fail clearly and without corrupting provider state.
16. No unrelated refactors.
17. No placeholder-only implementation, TODO-only completion, or documentation claiming behavior that is not reachable and tested.

## How to execute this prompt suite

Execute the following prompt files **in order**. Each file is an implementation phase, not a planning exercise.

```text
01_REPOSITORY_PROVIDER_ARCHITECTURE_AUDIT.md
02_LLM7_LIVE_PROTOCOL_AND_CAPABILITY_PROBE.md
03_LLM7_PROVIDER_DEFINITION_REGISTRY_AND_INSTALL.md
04_LLM7_RUNTIME_TRANSPORT_AND_AUTHENTICATION.md
05_LLM7_DYNAMIC_MODEL_DISCOVERY_AND_SELECTION.md
06_LLM7_SETUP_UX_AND_HEADLESS_CONFIGURATION.md
07_LLM7_STREAMING_TOOLS_AND_RESPONSE_COMPATIBILITY.md
08_LLM7_TESTS_FAILURE_MODES_AND_REGRESSION.md
09_LLM7_FINAL_END_TO_END_VALIDATION.md
```

For every phase:

1. Read this master prompt again.
2. Read the target phase prompt completely.
3. Inspect the current repository state before editing.
4. Read all applicable repository-local instructions such as `AGENTS.md`, `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`, architecture documents, package configuration, and test configuration.
5. Bind conceptual names in the prompt to the **real current code**. If a listed path moved, find the current equivalent rather than creating a duplicate.
6. Preserve uncommitted user work.
7. Implement the phase completely.
8. Run the smallest relevant tests first, then broader provider/regression checks where justified.
9. Fix failures caused by the phase before continuing.
10. Do not ask the user to choose routine implementation details that can be resolved from repository evidence, existing conventions, tests, and live LLM7 behavior.
11. If the phase is already fully implemented, verify it rather than rewriting it.
12. Continue automatically to the next phase only after the current phase's completion criteria are satisfied.

## Priority order

When instructions conflict, resolve them in this order:

```text
1. applicable Agent_X repository governance and safety rules
2. preservation of existing provider behavior
3. this master prompt's LLM7 invariants
4. the current phase prompt
5. existing Agent_X implementation conventions
6. external LLM7 examples/documentation
```

External documentation is evidence, not architectural authority over Agent_X.

## Final stopping condition

Do not declare the project complete until all of the following are true:

```text
[ ] LLM7 appears as a first-class provider through the same architecture as OpenCode/Codex.
[ ] Anonymous/no-login chat works when the live LLM7 service permits it.
[ ] Anonymous mode requires no user credential.
[ ] The anonymous path does not send Authorization.
[ ] /v1/models is used for dynamic model discovery.
[ ] model/capability changes do not require editing a static LLM7 model list.
[ ] streaming works.
[ ] tool/function calling is capability-aware and correctly handled.
[ ] interactive setup works.
[ ] non-interactive/headless configuration works.
[ ] OpenCode still works.
[ ] Codex still works.
[ ] provider tests pass.
[ ] relevant broader regressions pass.
[ ] failure modes are explicit and safe.
[ ] implementation contains no fake/stub completion.
[ ] live end-to-end verification evidence exists for the currently reachable anonymous path.
```

If a live LLM7 behavior has changed since the earlier anonymous verification, implement the integration so that Agent_X reports that external change accurately. Do not fake success, silently inject a credential requirement, or rewrite the requirement into something easier.
