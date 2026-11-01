# Historical Harvest Task 02 — Canonical Gate B integration

**Provenance:** Astrocytech/Agent_X audit `874bbe4268aca0539cbf8476f62444d704f2d555` (wave after `3887efe448edd223a00f94db324786d6a47a2d3b`). Historical design, not current authorization or implemented proof. D01 synthesis: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md); original blob `e9b17035387e8680f5ec2328fb51c7765edc43a8`.

**Integration locus (historical, current parity UNKNOWN):** canonical `collective_core/capability_distillation.py`, `evaluate_gate_b`, `AssimilationDisposition`, Gate B decision store, real `_mixins/write_code.py` or successor. Donors `harvest_contracts.py`, `harvest_gate_b.py`, `harvest_models.py` are research material, not new authorities.

**Mechanism:** One server-side Gate B assesses measurable gap, canonical owner, value floor, feasibility, experiment, guardrails and disposition `REJECT|EXPERIMENT|REPLACE|EXTEND|COMPLEMENT|NEW_COMPONENT`. A new component requires proof existing owners cannot absorb it; replacement identifies incumbent and cleanup. Revalidate decision freshness immediately before actual code write. `agentx_status`, novelty, UI choice, model confidence and donor registry do not grant authority. Proposed semantic state precedes implementation; verified state requires tests. Unknown or hard failure fails closed.

**Required negative decisions:** `NO_VALUE`, `DUPLICATE`, `ARCHITECTURAL_MISFIT`, `INFEASIBLE`, `UNTESTABLE`, `MAINTENANCE_BURDEN`, `GOVERNANCE`, `STALE_DECISION`.

**Falsifiable Ground:** Real Harvest→Gate A→Gate B→implementation-trigger test; `agentx_status=upgrade` alone never writes; stale decision cannot write; duplicate cannot spawn module; REPLACE identifies/removes incumbent; tests hit actual caller, not donor-only fixtures. Only after equivalent production behavior and references are verified may donor contracts/Gate B be removed and tests retargeted. Preserve start/end HEAD, semantic reconciliation, call paths, exact test results, rollback and unknowns. Recheck current DT owner/permissions before any action.
