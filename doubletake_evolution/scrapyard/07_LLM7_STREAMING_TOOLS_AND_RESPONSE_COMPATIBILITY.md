# Prompt 07 — Complete Streaming, Tool Calling, and OpenAI-Compatible Response Handling

## Objective

Make LLM7 behave correctly through Agent_X's higher-level agent runtime, especially for streaming and tool/function calls.

## Streaming

1. Trace Agent_X's canonical streaming abstraction.
2. Feed LLM7 streaming responses through that abstraction rather than exposing raw provider-specific SSE chunks to higher layers.
3. Correctly handle:
   - incremental content;
   - empty deltas;
   - finish reasons;
   - final termination marker/event;
   - usage data when present;
   - model metadata when present;
   - cancellation;
   - mid-stream error;
   - connection close.
4. Do not concatenate or drop chunks incorrectly.
5. Non-streaming and streaming paths must agree on final semantic output.

## Tool / function calling

LLM7 is OpenAI-compatible at the chat-completions layer, but **tool support is model- and access-dependent**.

Implement tool calling through Agent_X's existing tool abstraction.

Requirements:

```text
tools schema passes through correctly
tool_choice semantics are preserved where supported
tool_calls are parsed
tool call ids are preserved
arguments are not double-encoded
tool results are returned using the correct role/id linkage
multiple tool calls are handled if Agent_X supports them
finish reasons are normalized
```

Do not advertise tool calling for a model that discovery marks unsupported.

Do not assume an anonymously accessible text model also grants anonymous tool calling. If LLM7 returns a token/paid-feature error for tool use, surface that accurately and allow the runtime to choose a supported model/path according to existing Agent_X behavior.

## Other response compatibility

Inspect the actual Agent_X abstractions and support the OpenAI-compatible fields it relies on, such as:

```text
choices
message.content
message.tool_calls
finish_reason
usage
model
error
```

Ignore unknown fields safely unless Agent_X needs them.

Where the runtime supports JSON/structured output, enable it only when the selected model/access path actually supports it.

## Capability gating

Capability decisions should be centralized in the model/provider capability layer rather than scattered `if provider === "llm7"` checks throughout the agent runtime.

## Tests

Include representative fixtures for:

```text
non-streaming text
streaming text
empty delta
stream end
tool call request
tool result continuation
multiple tool calls if supported
tool capability disabled
tool access denied/token-required
malformed chunk
mid-stream provider error
cancellation
```

Run existing generic OpenAI-compatible/provider streaming and tool tests where applicable.

## Completion criteria

LLM7 can participate in the same Agent_X agent execution flow as existing capable providers without special-case leakage into unrelated layers.
