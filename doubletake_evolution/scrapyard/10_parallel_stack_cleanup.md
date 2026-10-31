# Remaining Task 10 — Delete Parallel Harvest Stack and Obsolete Tests

After migration, remove donor files, duplicate state, and tests that validate obsolete isolated architecture.

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

- all donor modules/tests
- all imports/references
- canonical production owners/tests

## Required work

Re-run symbol migration matrix. Delete fully absorbed/unconsumed donors. Keep only uniquely justified files with real production caller. Rewrite useful tests against canonical owners. Remove dead registries, duplicate persistence/index/scheduler, obsolete status authority, stale adapters.

## Exact completion gates

One production owner per responsibility. No "leave it just in case". No compatibility adapter without removal condition.

## Tests / evidence

Full import/compile; production call graph; reference search; affected/full tests; startup/API smoke; no orphan state paths.

## Cleanup / replacement

Cleanup is part of implementation. Do not declare done while redundant production architecture remains.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
