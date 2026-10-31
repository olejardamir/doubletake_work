# Remaining Task 02 — Collapse Contracts and Gate B into Existing Assimilation

Move useful contract/value/fit/replacement logic into the real `capability_distillation.py` Gate B and actual write-code caller.

## Baseline and rules

Repository: `Astrocytech/Agent_X`  
Audited `main` when this pack was generated: `874bbe4268aca0539cbf8476f62444d704f2d555`.  
The implementation wave began after `3887efe448edd223a00f94db324786d6a47a2d3b`.

Before work, re-check current local `main` and the working tree. Never reset newer work to this baseline.

Hard rules:
1. The recently added `harvest_*.py` files are **donor code**, not presumed canonical owners.
2. Merge useful logic into the existing subsystem that already owns the responsibility unless a new owner is independently justified.
3. Do not create a second/third Harvest stack, scheduler, persistence layer, embedding route, Gate B, promotion path, or UI.
4. Semantic proposed state precedes behavior-changing code; verified semantic state follows tests/runtime reconciliation.
5. Replace/merge before add. Once donor logic is absorbed, delete/deactivate the redundant donor path.
6. Tests must exercise production paths, not only isolated donor classes.
7. Any hard gate failure or hard UNKNOWN blocks PASS.
8. UI never authorizes implementation; server-side Gate B/governance does.
9. Do not keep code because effort was spent on it; keep it only if it has a justified owner, consumer, and value.

## Primary existing targets

- `collective_core/capability_distillation.py`
- canonical `evaluate_gate_b`, `AssimilationDisposition`, Gate B decision store
- actual `_mixins/write_code.py` or current equivalent
- donor `harvest_contracts.py`, `harvest_gate_b.py`, relevant `harvest_models.py`

## Required work

Strengthen one Gate B. Require measurable gap, canonical owner, value floor, feasibility, experiment contract, guardrails, and explicit REJECT/EXPERIMENT/REPLACE/EXTEND/COMPLEMENT/NEW_COMPONENT disposition. Remove `agentx_status`, update/upgrade, novelty, UI choice, and LLM confidence as authority. Revalidate stale decisions before coding. `NEW_COMPONENT` requires proof no existing owner can absorb it.

## Exact completion gates

The real code-writing path must fail closed unless the current canonical Gate B explicitly authorizes. Hard outcomes include NO_VALUE, DUPLICATE, ARCHITECTURAL_MISFIT, INFEASIBLE, UNTESTABLE, MAINTENANCE_BURDEN, GOVERNANCE, STALE_DECISION.

## Tests / evidence

Harvest record -> Gate A -> Gate B -> implementation-trigger integration test; `agentx_status=upgrade` cannot authorize; stale decision cannot authorize; duplicate cannot create new module; REPLACE names incumbent and cleanup.

## Cleanup / replacement

Delete/neutralize donor contracts/Gate B after migration. Rewrite their useful tests against canonical `capability_distillation.py`.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
