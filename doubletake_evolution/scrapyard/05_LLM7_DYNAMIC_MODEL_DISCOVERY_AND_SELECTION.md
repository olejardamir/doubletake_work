# Historical LLM7 dynamic model discovery — distilled

**Original blob:** `d88d81ef714a11f45a32754966fc8dcdfb84da1b`. Historical plan; current LLM7 model API/access unverified. [Master](00_MAIN_PROMPT.md); [D01](DISTILLED_KNOWLEDGE.md).

**Mechanism:** discover `GET https://api.llm7.io/v1/models` dynamically; normalize ID, owner, modality, context, streaming/tools/JSON/reasoning, status/tier where present. Optional metadata may be absent; malformed entries must not crash provider. Deduplicate, bounded TTL and explicit refresh; discovery outage retains prior config but stale cache is not permanent authority. No permanent static model list or fixed `codestral-latest`. Selector aliases (`default`, `fast`, `pro`) only if live API confirms.

**Entitlement evidence order:** live access/tier metadata → bounded cached anonymous probe → verified selector semantics → explicit runtime error/reselection. Advertised tool support does not prove anonymous use. Avoid probing every model. Support interactive dynamic choices and headless explicit ID; handle model churn, missing metadata, refresh, malformed entries and discovery failures in tests. **Unknown:** live schema, entitlement and actual DT runtime integration.
