# Historical LLM7 live-protocol probe plan — distilled

**Original blob:** `d56f73a0643a65b4d5aea815efdffd32db9115ae`. The source **claimed** a successful anonymous request on 2026-09-11 to `POST https://api.llm7.io/v1/chat/completions` with JSON `model=codestral-latest`, one user message, no Authorization. Receipt and current entitlement not independently checked. [Master](00_MAIN_PROMPT.md); [D01](DISTILLED_KNOWLEDGE.md).

**Bounded probes (opt-in, no credential leakage):** (1) `GET /v1/models`: parse ID, owner, modality, context, tier/status, streaming/tools and optional metadata without assuming all fields; (2) tiny no-auth nonstreaming chat: record HTTP status and schema; (3) if supported, `stream:true` SSE chunk/termination behavior; (4) advertised tool support versus **actual anonymous** tool entitlement; (5) nonexistent model, malformed payload, naturally encountered rate/access errors. Never hammer service. Model IDs and access tiers can change; `codestral-latest` is only an example.

**Ground requirement:** preserve redacted protocol fixtures, opt-in live tests, bounded timeouts and explicit current evidence. Do not turn SDK-required fake key into Authorization. Treat documentation and model metadata as claims when contradicted by live behavior. Unknown: present-day LLM7 terms, availability, anonymous tool access and actual DT runtime consumer.
