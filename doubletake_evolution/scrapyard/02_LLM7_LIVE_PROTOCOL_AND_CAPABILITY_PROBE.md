# Prompt 02 — Verify LLM7 Live Protocol and Anonymous Capabilities

## Objective

Establish the **current live LLM7 behavior** that Agent_X must integrate against. The implementation must be based on evidence rather than stale documentation or remembered behavior.

## Known starting evidence

A no-login request was successfully verified on 2026-09-11 using:

```bash
curl https://api.llm7.io/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model":"codestral-latest",
    "messages":[
      {"role":"user","content":"Reply with exactly: LLM7_OK"}
    ]
  }'
```

No `Authorization` header was supplied.

The service returned a normal OpenAI-compatible chat-completions response.

## Required live probes

Use safe, minimal requests and bounded timeouts.

### 1. Models API

Probe:

```text
GET https://api.llm7.io/v1/models
```

Determine the actual response shape and available metadata, including where present:

```text
id
owned_by/provider
input/output modalities
tool-calling support
streaming support
context limits
status/tier
other capability flags
```

Do not assume every field is always present.

### 2. Anonymous non-streaming chat

Verify a small no-auth request against a currently available anonymous-compatible model.

Requirements:

```text
no login
no API key
no Authorization header
small prompt
small output
bounded timeout
```

Record the HTTP status and response schema needed by Agent_X.

### 3. Anonymous streaming

Where the currently reachable anonymous model supports streaming, verify `stream: true` and inspect the exact chunk/SSE termination behavior.

### 4. Tool/function calling

Determine separately:

- whether the Models API advertises tool calling for candidate models;
- whether anonymous access to tool calling actually succeeds;
- whether tool calling requires a paid/token-authenticated tier.

Do not infer anonymous tool support merely because a model advertises a Tools capability.

### 5. Failure behavior

Probe only as needed to identify stable error shapes for:

- nonexistent model;
- anonymous request to a token-only capability/model, if safely testable;
- malformed payload;
- rate limit, only if naturally encountered.

Do not intentionally hammer the service.

## Interpretation rules

1. **Live behavior outranks stale examples.**
2. Documentation remains useful for intended API semantics, but if docs and observed anonymous behavior disagree, capture the disagreement and make Agent_X robust to it.
3. The integration must never convert "anonymous currently works" into "user must create an account" merely because an SDK's constructor demands an API-key string.
4. The integration must never advertise tool calling anonymously unless the live anonymous path actually supports it.
5. `codestral-latest` is a verification example, not a permanent hardcoded default.
6. Prefer dynamic selection/discovery so model turnover does not break Agent_X.

## Implementation output from this phase

Create or extend the project's provider-test fixtures/helpers so the protocol facts needed by later phases can be represented without requiring every unit test to hit the network.

Where appropriate, isolate live-network probes as opt-in integration tests or a small diagnostic path consistent with repository conventions.

## Completion criteria

The repository must now have a concrete, testable understanding of:

```text
LLM7 base URL
models endpoint
chat endpoint
anonymous-auth semantics
response shape
streaming shape
tool-call capability semantics
important error shapes
```

Do not continue on the basis of unverified assumptions.
