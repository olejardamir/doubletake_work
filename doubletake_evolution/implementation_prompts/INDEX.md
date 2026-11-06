# DT implementation prompt queue

Proposed prompts below are **for a future user-invoked LLM coder**. Workers only prepare and verify these artifacts.

| ID | Status | Prompt | Source retired from scrapyard? | Current DT parity | Notes |
| --- | --- | --- | --- | --- | --- |
| DT-IP-0001 | READY_FOR_FUTURE_LLM | [Governed unified capability projection](DT-IP-0001-governed-dynamic-capability-projection.md) | **YES — independently audited, SHA-guard deleted and absence verified** | UNKNOWN | FULL original `91f6575ce6c1aafe8c1e77378e621e191ae4c19d` and historical Git blob `d04135e7cd0ff55cfdd57eb8051520d6b1575d5d` reviewed; prompt `e74d5a091f7f2309cdfe04e6275a212f9c5de9e8` covers distinct technical mechanisms, security/negative tests, B7 nuance, S59–S61 hypotheses, upstream/authority/benchmark requirements. Source deletion commit `20eaebed4a6482ff5c78d736c286fb632ccb4cf3`; no DT implementation or tests executed. |

| DT-IP-0002 | READY_FOR_FUTURE_LLM — NOT_EXECUTED | [Read-only versioned history compatibility discriminator](DT-IP-0002-readonly-versioned-history-compatibility-gate.md) | **YES — independently verified, SHA-guard deleted, absence confirmed** | UNKNOWN | FULL incoming source SHA `12e38fd07323dbab379354507f16917e909d3677` covered by prompt SHA `22c374ee16488c7bb9b18a7e8d8bf8ed92dde4b6`, including restored R-012 provenance. Original deletion commit `475fc600a8d8a7a684fa761ed3b679b6e1ae5534`; inventory tombstone commit `7e4045016f629a6fc9fca90ee4036a015de9071d`. No DT implementation or tests executed. |

## Accounting
A source is counted as transferred only after (1) all distinct clauses covered by a verified prompt or existing library entry, (2) original source SHA checked, (3) SHA-guarded original deletion verified, and (4) matching existing inventory row reconciled. No status here establishes implemented DT behavior. Never execute a prompt automatically.
