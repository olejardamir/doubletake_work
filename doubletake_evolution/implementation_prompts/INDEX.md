# DT implementation prompt queue

Proposed prompts below are **for a future user-invoked LLM coder**. Workers only prepare and verify these artifacts.

| ID | Status | Prompt | Source retired from scrapyard? | Current DT parity | Notes |
| --- | --- | --- | --- | --- | --- |
| DT-IP-0001 | NEEDS_SOURCE_VALIDATION | [Governed unified capability projection](DT-IP-0001-governed-dynamic-capability-projection.md) | NO — source retained pending coverage repair | UNKNOWN | Scout audit: clarify potential B7 consumer-selection/no-loss contribution vs no claim of full B7 resolution; original `91f6575ce6c1aafe8c1e77378e621e191ae4c19d`, prompt `ba28d9e1c1d9f4b7656b8ea49c417f358f7dd2b9`; inventory `root_A-D.md` has exact gap; NOT IMPLEMENTED |

## Accounting
A source is counted as transferred only after (1) all distinct clauses covered by a verified prompt or existing library entry, (2) original source SHA checked, (3) SHA-guarded original deletion verified, and (4) matching existing inventory row reconciled. No status here establishes implemented DT behavior. Never execute a prompt automatically.
