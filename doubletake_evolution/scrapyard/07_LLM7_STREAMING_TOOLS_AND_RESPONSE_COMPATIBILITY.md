# Historical LLM7 streaming/tool compatibility — distilled

**Original blob:** `6b53c2ca4f7925f4bfd3c0761c87ed849daa9c9c`. Historical Agent_X plan, not DT implementation evidence. [Master](00_MAIN_PROMPT.md), [D01](DISTILLED_KNOWLEDGE.md).

**Streaming:** use canonical agent runtime abstraction rather than raw SSE. Preserve incremental text, empty deltas, finish reasons, final termination, optional usage/model metadata, cancellation, connection close and midstream errors. Streaming and nonstreaming outputs should agree semantically; no dropped/duplicated chunks.

**Tools:** existing tool schema/choice, IDs, argument JSON (not double-encoded), role-linked results, multiple calls when supported, normalized finish reasons. Tool support depends on **model and access tier**; advertised capability does not imply anonymous entitlement. Paid/token-only denial must be accurately surfaced without disabling ordinary anonymous chat. Centralize capability gating; do not scatter provider-specific branches. Structured JSON output only if proven supported.

**Negative fixtures:** empty delta, malformed chunk, missing termination, cancellation, midstream error, unsupported tool, paid-tier refusal, tool-result continuation and multi-call linkage; rerun generic OpenAI-compatible tests. **Unknown:** current LLM7 service semantics and actual DT runtime parity.
