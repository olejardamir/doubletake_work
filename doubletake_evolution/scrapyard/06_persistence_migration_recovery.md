# Remaining Task 06 — Integrate Evidence, Persistence, Migration, Idempotency, Recovery

Use existing state stores/scheduler persistence instead of a parallel Harvest persistence framework.

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

- existing Harvest job JSON/state, Gate B store, semantic index DB, stabilization DB, promotion state
- donor models/persistence/migration

## Required work

Assign each record type to its canonical store. Preserve append-only evidence. Add stable IDs/idempotency where missing. Migrate only real persisted donor data. Unknown legacy fields stay UNKNOWN. Restart reconciles queued/running/completed states without duplicate effects. Context drift invalidates derived decisions, not raw evidence.

## Exact completion gates

Every repeatable mutation is idempotent; completed evidence cannot run/count twice; migration cannot invent lineage/metrics/PASS; partial transaction recovers to one valid state.

## Tests / evidence

Duplicate request no-op/same result; kill/restart scenarios; migration rerun idempotent; stale context invalidates Gate B/promotion; append-only evidence cannot be overwritten; inventory fully accounted.

## Cleanup / replacement

Delete duplicate persistence/migration abstractions unless they perform a real canonical migration.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
