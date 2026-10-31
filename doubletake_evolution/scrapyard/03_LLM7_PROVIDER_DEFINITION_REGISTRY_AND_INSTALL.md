# Prompt 03 — Add LLM7 to Provider Definition, Catalog, Registry, and Backend Wiring

## Objective

Make LLM7 a **first-class Agent_X provider** through the same provider architecture already used by OpenCode and Codex.

## Required implementation

Using the real patterns discovered in Prompt 01:

1. Add the LLM7 provider identifier/type in the canonical provider type location.
2. Add LLM7 to the provider catalog with accurate user-facing metadata.
3. Add a provider definition module following the existing provider-definition conventions.
4. Export that definition through the existing definitions index.
5. Register LLM7 through the existing provider registry.
6. Wire LLM7 through the existing install/backend abstraction.
7. Ensure all provider lists, provider-choice logic, labels, descriptions, and supported-mode metadata include LLM7 through normal registry/catalog mechanisms rather than scattered special cases.
8. Preserve OpenCode and Codex behavior.
9. Do not create a fake local executable/install requirement if LLM7 is a remote API provider and the architecture already supports remote providers.
10. If the install-backend abstraction requires a notion of "nothing to install" or "remote/no-install", implement that minimally and generically only if the architecture truly lacks it.

## LLM7 provider facts to encode

Stable service identity may be encoded:

```text
provider id: llm7
display name: LLM7
base URL: https://api.llm7.io/v1
chat path: /chat/completions
models path: /models
```

Do **not** encode a permanent static model list.

Do **not** mark a credential as required for anonymous mode.

If the provider metadata system distinguishes authentication strategies, model LLM7 as supporting an anonymous/no-auth strategy first. Optional token-authenticated behavior may be represented only if the existing architecture can do so cleanly and without making it a prerequisite.

## User-facing intent

The provider should communicate that LLM7 is useful as a no-login/OpenAI-compatible remote provider when anonymous service access is available.

Do not present "Get API key" as a mandatory first step for the anonymous path.

## Tests

Extend the relevant provider tests to cover at minimum:

```text
catalog contains llm7
registry resolves llm7
definition exports correctly
provider enumeration includes llm7 once
existing opencode entry still resolves
existing codex entry still resolves
install/backend handling for llm7 is correct
llm7 does not incorrectly require credentials
```

Prefer exact existing test style and helpers.

## Completion criteria

Agent_X must recognize LLM7 everywhere a provider is canonically represented, with no parallel registry and no regression to OpenCode/Codex.
