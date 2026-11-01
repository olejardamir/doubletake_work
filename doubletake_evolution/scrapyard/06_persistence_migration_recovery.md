# Historical Harvest Task 06 — No-loss persistence and recovery

**Provenance:** Astrocytech/Agent_X audit `874bbe4268aca0539cbf8476f62444d704f2d555` (implementation wave after `3887efe448edd223a00f94db324786d6a47a2d3b`). Historical proposal, not a current DT writer contract, repair grant or proof. Original blob `d2a2eed040d64d1e9d04c235e2bc59a24a53a555`; D01 canonical digest: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md).

**Historical owners:** Existing Harvest job JSON/state, Gate B decision store, semantic index DB, stabilization DB, promotion state. Donor models/persistence/migration do not justify a parallel state owner.

**Mechanism:** Assign each record type to canonical store. Keep immutable/append-only raw evidence and stable operation IDs; idempotent repeatable mutations, queued/running/completed reconciliation across crash, and one valid state after partial transactions. Migrate only actual persisted donor data, never invent unknown legacy lineage, metrics or PASS. Context drift invalidates derived decisions, not raw evidence. Semantic proposed state precedes behavior-changing code; server governance controls code changes.

**Falsifiable tests:** Duplicate request has identical effect/no double count; kill/restart recovers once; repeated migration is idempotent; stale context invalidates Gate B/promotion; raw evidence cannot be overwritten; every inventory item accounted. Acknowledged-write durability, exact ordering and historical-integrity disposition must follow owner-approved contracts, not be inferred from this design. Delete donor persistence abstractions only after unique data and reference checks. Record start/end HEAD, exact tests, owner changes, rollback and unknowns. Current B1/B4 authority unresolved.
