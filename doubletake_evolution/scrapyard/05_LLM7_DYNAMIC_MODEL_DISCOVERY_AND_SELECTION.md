# Prompt 05 — Implement Dynamic LLM7 Model Discovery, Capabilities, and Selection

## Objective

Use LLM7's live **Models API** as the authoritative source for current model availability instead of maintaining a fragile hardcoded list.

## Required implementation

1. Add LLM7 model discovery through:

   ```text
   GET https://api.llm7.io/v1/models
   ```

2. Parse the actual current response shape defensively.
3. Normalize LLM7 models into the existing Agent_X model representation.
4. Preserve useful metadata where available, including:
   - model ID;
   - provider/owner;
   - modalities;
   - context limit;
   - tool/function-call support;
   - streaming support;
   - JSON/structured-output support;
   - reasoning capability;
   - tier/status, if exposed and useful.
5. Tolerate missing optional fields.
6. Reject or clearly mark malformed model entries rather than crashing the whole provider.
7. Do not hardcode a permanent list of LLM7 concrete model IDs.
8. Do not make `codestral-latest` the only supported model. It may be used as a live smoke-test candidate when available.
9. If LLM7 exposes selectors such as `default`, `fast`, or `pro`, support them only when the live API/current service behavior confirms them and they fit the Agent_X model abstraction.
10. Distinguish model capability from access entitlement. A model advertising tool calling does not prove anonymous callers can use tool calling.

## Anonymous model usability

Agent_X's no-login path should avoid selecting an obviously token-only model when that information can be determined.

Use the best available evidence in this order:

```text
1. explicit access/tier metadata from live Models API
2. cached result of a bounded live anonymous capability probe
3. known generic selector semantics verified against the live service
4. clear runtime error with retry/reselection path
```

Do not add a large probe storm across every model.

## Caching

Follow existing Agent_X conventions. If model discovery is cached:

- use a bounded TTL;
- allow explicit refresh;
- do not persist secrets;
- handle stale/unreachable discovery gracefully;
- never turn a stale cache into a permanent static inventory.

## Selection UX

Where Agent_X lets users choose a model, display dynamically discovered models and relevant capability signals. Do not overload the UI with every raw API field.

For headless use, allow a model ID/selector to be supplied explicitly and validated reasonably without requiring interactive setup.

## Tests

Cover:

```text
valid /v1/models parsing
missing optional fields
malformed entry handling
deduplication if needed
dynamic model refresh
capability mapping
headless explicit model selection
no permanent static LLM7 model list
model-discovery failure behavior
```

## Completion criteria

Adding/removing/changing LLM7 models on the service side must not normally require an Agent_X code change.
