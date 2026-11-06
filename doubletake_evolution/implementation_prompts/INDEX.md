# DT implementation prompt queue

Proposed prompts below are **for a future user-invoked LLM coder**. Workers only prepare and verify these artifacts.

| ID | Status | Prompt | Source retired from scrapyard? | Current DT parity | Notes |
| --- | --- | --- | --- | --- | --- |
| DT-IP-0001 | NEEDS_SOURCE_VALIDATION | [Governed unified capability projection](DT-IP-0001-governed-dynamic-capability-projection.md) | NO — independent audit found historical coverage gaps; original retained | UNKNOWN | Source `91f6575ce6c1aafe8c1e77378e621e191ae4c19d`; updated prompt `3f6087168caee4c08d77cc9690819388faa1c2c8`; repaired B7 distinction and historical-source Scout gaps (typed work-unit resolution, shortlist diversity, bounded failure/re-resolution, cache-key revisions, adversarial hidden-tool/provider-spoofing tests); NOT_EXECUTED; Scout re-audit found further historical gaps in descriptor semantics, lifecycle discovery, ranking controls, fallback, telemetry, configuration and migration/docs; see root_A-D.md S60; original retained |

## Accounting
A source is counted as transferred only after (1) all distinct clauses covered by a verified prompt or existing library entry, (2) original source SHA checked, (3) SHA-guarded original deletion verified, and (4) matching existing inventory row reconciled. No status here establishes implemented DT behavior. Never execute a prompt automatically.
