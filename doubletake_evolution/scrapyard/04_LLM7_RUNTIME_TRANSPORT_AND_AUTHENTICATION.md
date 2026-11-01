# Historical LLM7 transport and no-auth contract — distilled

**Original blob:** `e4987706cad7770cbe01c832d51d48843a4b1615`. Historical plan, not current provider behavior. [Master](00_MAIN_PROMPT.md); [D01](DISTILLED_KNOWLEDGE.md).

**Transport:** canonical runtime config → OpenAI-compatible request to `https://api.llm7.io/v1/chat/completions`; reuse existing client only if anonymous wire behavior is correct. Anonymous mode must require no credential/login, no fake persisted key and **no Authorization header**. If SDK forces bearer auth, prefer existing configurable lower-level transport, otherwise a minimal `auth:none` adapter or interface-compatible narrow shim; do not fork entire protocol stack. Optional token must use secure existing store and never be logged. Preserve message/model/options, stream, tool choice when supported, cancellation and timeout. Preserve OpenCode/Codex authentication semantics.

**Negative tests:** anonymous config without credentials succeeds; URL/Content-Type correct; no Authorization on outgoing request; no fake secret stored; response normalized; network/timeout/abort, malformed response, 4xx/5xx, rate limit, model unavailable and token-required errors accurately classified. External policy change is not automatically an app config bug. **Unknown:** live anonymous entitlement and current DT transport parity.
