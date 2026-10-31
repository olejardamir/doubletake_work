# Remaining Task 04 — Integrate Generators, ASHA, Ranking, and Optimizers

Move proposal/evidence-budget logic into existing mining/scheduling owners; generators never become promotion authority.

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

- `_hp_mining.py`
- current Harvest job scheduler/lifecycle
- `learning/stabilization/scheduler.py` where appropriate
- donor generators/scheduler/ranking/optimizers

## Required work

Wrap current Topography/producers behind a proposal interface. Add only useful semantic-neighbor/mutation/centroid/qualified optimizer modes. Use existing scheduler persistence for asynchronous multi-fidelity allocation, uncertainty/cost repeats, delayed downstream reward, bounded exploration. CEM/CMA-ES/BO operate on compact controls, not raw full embedding vectors by default.

## Exact completion gates

Scheduler allocates resources only. Hard invalidity/scope/provenance/cost/governance rejects immediately. Generator fitness never promotes code. No new scheduler DB if existing owners suffice.

## Tests / evidence

Topography behavior preserved; slow probes do not block; cost cap enforced; delayed reward changes allocation; exploration bounded; restart does not double-count; generator cannot call implementation/promotion.

## Cleanup / replacement

Absorb useful donor logic. Delete unconsumed donor scheduler/ranking paths; keep optimizer code only with real production/benchmark caller.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
