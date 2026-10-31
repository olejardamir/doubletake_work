# Remaining Task 01 — Revalidate Main and Disposition Every Donor

Verify the live authority map and classify every donor symbol before more architecture is built.

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

- `HARVEST_AUTHORITY_MAP.md`
- `collective_core/harvest_loop.py`, `_hp_mining.py`, `_hp_evidence.py`, `_hp_run.py`, `_hp_intel.py`
- `capability_distillation.py`
- canonical semantic services, stabilization scheduler/DB, promotion path, API, real frontend
- every donor `harvest_*.py` and matching test

## Required work

1. Trace owners from real callers, not filenames/comments.
2. For every public donor symbol classify: already exists; useful missing logic; test/benchmark only; duplicate; genuinely new cohesive responsibility.
3. Build a symbol-level migration table and find real production imports/callers.
4. Freeze creation of more `harvest_*.py` files until this passes.

## Exact completion gates

PASS only when every donor symbol has a disposition, every canonical owner is verified, every code-changing entry point is known, and no donor is called canonical merely because its docstring says so.

## Tests / evidence

Call/import graph; UI/API -> Harvest -> Gate B -> code/promotion trace; baseline regression suite. Prove isolated donor tests are not counted as production integration.

## Cleanup / replacement

No broad deletion yet except trivially unused duplicates with no unique logic. This task authorizes the later migration plan.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
