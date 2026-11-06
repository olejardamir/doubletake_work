# DT implementation prompt queue

Proposed prompts below are **for a future user-invoked LLM coder**. Workers only prepare and verify these artifacts.

| ID | Status | Prompt | Source retired from scrapyard? | Current DT parity | Notes |
| --- | --- | --- | --- | --- | --- |
| DT-IP-0001 | READY_FOR_FUTURE_LLM | [Governed unified capability projection](DT-IP-0001-governed-dynamic-capability-projection.md) | **YES — independently audited, SHA-guard deleted and absence verified** | UNKNOWN | FULL original `91f6575ce6c1aafe8c1e77378e621e191ae4c19d` and historical Git blob `d04135e7cd0ff55cfdd57eb8051520d6b1575d5d` reviewed; prompt `e74d5a091f7f2309cdfe04e6275a212f9c5de9e8` covers distinct technical mechanisms, security/negative tests, B7 nuance, S59–S61 hypotheses, upstream/authority/benchmark requirements. Source deletion commit `20eaebed4a6482ff5c78d736c286fb632ccb4cf3`; no DT implementation or tests executed. |

| DT-IP-0002 | PROMPT_READY_PENDING_INDEPENDENT_REVIEW — NOT_EXECUTED | [Read-only versioned history compatibility discriminator](DT-IP-0002-readonly-versioned-history-compatibility-gate.md) | **NO — incoming original retained for Scout audit** | UNKNOWN | FULL incoming source `12e38fd07323dbab379354507f16917e909d3677`; prompt `233bf490c23373802158e41bce09de7cca9582b3`; conditional synthetic-only compatibility gate, no integrity bypass, no private implementation or tests. |

## Accounting
A source is counted as transferred only after (1) all distinct clauses covered by a verified prompt or existing library entry, (2) original source SHA checked, (3) SHA-guarded original deletion verified, and (4) matching existing inventory row reconciled. No status here establishes implemented DT behavior. Never execute a prompt automatically.
