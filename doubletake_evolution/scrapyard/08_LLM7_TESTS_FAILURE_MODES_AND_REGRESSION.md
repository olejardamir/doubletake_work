# Prompt 08 — Harden Tests, Failure Modes, and Provider Regressions

## Objective

Prove that the LLM7 integration is real, bounded, failure-safe, and does not break existing providers.

## Test strategy

Use the repository's existing test framework and conventions.

Prefer three layers:

```text
1. deterministic unit tests with mocked HTTP/fixtures
2. provider integration tests around Agent_X runtime boundaries
3. small opt-in live LLM7 smoke tests
```

Do not make the normal test suite depend on external LLM7 availability unless the repository already follows that practice.

## Required deterministic coverage

Cover at minimum:

### Registration/configuration

```text
LLM7 in catalog
LLM7 in registry
definition export
no duplicate provider
anonymous credential optionality
headless config
config persistence/reload
```

### Models

```text
/v1/models success
empty list
malformed model
partial metadata
capability mapping
refresh/cache behavior
discovery timeout/failure
```

### Runtime

```text
correct base URL
correct chat path
no Authorization in anonymous mode
correct Content-Type
non-streaming response
streaming response
abort
timeout
4xx mapping
5xx mapping
rate-limit mapping
invalid JSON
missing choices/message
model unavailable
```

### Tools

```text
supported tool call
unsupported tool capability
token/paid-only tool failure
tool-call ID preservation
tool-result round trip
```

### Regressions

At minimum rerun the directly relevant OpenCode and Codex provider tests.

If shared transport/config code changed, run every test suite that exercises that shared boundary.

## Live smoke test

Provide a small opt-in live test/diagnostic consistent with repository conventions.

It should:

1. fetch `/v1/models`;
2. choose a plausible currently anonymous-compatible model without hardcoding a permanent inventory;
3. make a tiny no-auth chat request;
4. assert a valid response;
5. optionally verify streaming with a tiny response;
6. skip rather than falsely fail when the test is intentionally disabled;
7. fail clearly when enabled and the external service behavior has changed.

The live anonymous test must not read a secret just to prove anonymous access.

## Failure safety

Confirm:

- no partial provider state corruption;
- no accidental credential requirement;
- no accidental auth header;
- no secret logging;
- no retry storm;
- bounded retry/backoff consistent with existing Agent_X behavior;
- useful error messages.

## Quality rule

A test that only checks that a file exists or a provider name appears in text is insufficient. Exercise reachable behavior.

## Completion criteria

The test suite must make it difficult for a future refactor to silently turn LLM7 anonymous mode into a key-required provider or to replace dynamic discovery with a stale hardcoded model list.
