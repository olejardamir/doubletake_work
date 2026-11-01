# Historical Harvest Task 01 — Donor ownership and disposition

**Provenance:** Astrocytech/Agent_X `main` audit `874bbe4268aca0539cbf8476f62444d704f2d555`; implementation wave after `3887efe448edd223a00f94db324786d6a47a2d3b`. Historical proposal, **not** a current DT instruction or proof. Canonical research synthesis: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md) (D01). Original version recoverable at blob `df695e0556ab926f03cf1f59c91841fab4fb0d9a`.

**Mechanism:** Trace real imports/callers, not names or docstrings, for each public `harvest_*.py` donor symbol. Classify as existing owner, useful missing logic, test/benchmark only, duplicate, or genuinely new cohesive owner; record symbol-level migration and evidence. Freeze additional parallel Harvest/embedding/Gate B/scheduler/persistence/promotion/UI owners until ownership is proven. Integrate useful behavior into canonical owners before donor removal; new owners require independent responsibility and actual consumers. Proposed semantic state precedes behavior changes; verified state follows tests and runtime reconciliation. Server-side Gate B, not UI/status/model confidence, controls implementation.

**Historical targets:** `HARVEST_AUTHORITY_MAP.md`; `collective_core/harvest_loop.py`, `_hp_mining.py`, `_hp_evidence.py`, `_hp_run.py`, `_hp_intel.py`, `capability_distillation.py`; semantic services, stabilization scheduler/DB, promotion, API/frontend; all donor `harvest_*.py` and tests.

**Falsifiable acceptance:** Every donor symbol has a justified disposition and verified canonical owner; every code-changing caller is traced; no duplicate authority or donor-only test masquerades as integration. Evidence: import/call graph; real UI/API→Harvest→Gate B→code/promotion trace; production regression tests. Hard failure or UNKNOWN blocks PASS.

**Safe cleanup:** No broad deletion before migration, unique-function and reference checks. Record starting/ending HEAD, semantic delta, changed owners, consumed symbols, donor removals/retentions, actual callers, test commands/results, failures, rollback and unresolved unknowns. Recheck current DT architecture and owner authorization before reuse.
