# Prompt 04 — Implement LLM7 Runtime Transport and True Anonymous Authentication

## Objective

Make Agent_X able to execute LLM7 chat requests through its real runtime path while preserving **true no-login/no-key behavior**.

## Required implementation

1. Extend the canonical runtime-config/provider-runtime path to produce LLM7 runtime configuration.
2. Use:

   ```text
   base URL: https://api.llm7.io/v1
   chat endpoint: /chat/completions
   ```

3. Reuse the existing OpenAI-compatible transport/client if and only if it can satisfy the LLM7 protocol correctly.
4. Inspect exactly how that transport handles `apiKey`, `Authorization`, headers, and streaming.
5. For LLM7 anonymous mode:
   - do not require a credential;
   - do not prompt for a credential;
   - do not reject missing credential;
   - do not synthesize an auth error;
   - do not emit `Authorization: Bearer ...`;
   - do not put a fake secret into persistent config.
6. If the current OpenAI-compatible client library forces an `Authorization` header whenever instantiated, do not pass a fake `"unused"` key merely to satisfy its constructor if that header reaches the network. Instead:
   - use an existing lower-level configurable transport if available; or
   - minimally adapt the shared transport to support `auth: none`; or
   - add the smallest provider-specific transport shim that still conforms to Agent_X's provider/runtime interfaces.
7. Keep all generic request behavior that is genuinely OpenAI-compatible:
   - messages;
   - model;
   - temperature/other supported options;
   - streaming flag;
   - tools/tool choice where supported;
   - cancellation/abort;
   - timeout;
   - error handling.
8. Do not fork the entire OpenAI protocol stack just to omit one header.
9. Do not alter other providers' authentication behavior.

## Optional authenticated LLM7 mode

Only if the current Agent_X provider architecture naturally supports optional credentials, allow an optional LLM7 token as an enhancement. It must remain optional and must not change the default/no-login path.

If an optional token is present, use the existing secure credential mechanism. Never log the token.

## Error handling

Normalize at least:

```text
network failure
timeout
invalid response
HTTP 4xx
HTTP 5xx
authentication/token-required response
rate limit
model unavailable
abort/cancellation
```

Error messages must distinguish an external LLM7 access-policy change from an Agent_X configuration bug.

## Tests

Add tests proving that in anonymous mode:

```text
runtime config builds successfully without credentials
request URL is correct
Content-Type is correct
Authorization header is absent
no fake key is persisted
chat response is normalized
OpenCode auth behavior is unchanged
Codex auth behavior is unchanged
```

## Completion criteria

A real Agent_X runtime call can reach LLM7 anonymously when the service permits it, and the no-auth requirement is enforced by tests rather than only by comments.
