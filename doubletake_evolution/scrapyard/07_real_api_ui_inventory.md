# Remaining Task 07 — Implement Real API + Frontend Inventory UX

Replace in-memory UI helper behavior with the actual Agent_X Harvest UI/API backed by semantic search and server gates.

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

- `api/stackmgmt.py`
- `harvest_loop.py:list_harvest_inventory`
- canonical semantic search from Task 03
- canonical Gate B from Task 02
- locate/modify current real frontend Harvest components
- donor `harvest_ui.py`

## Required work

Real UI must semantically search inventory and filter capability/domain/source/status/disposition/champion/generator as useful. Detail shows Do not implement / Experiment / Replace / Extend / Complement / New capability / Blocked with evidence. Implement/Test control is server-derived and revalidated at action time. Stale/tampered client cannot authorize. Retry is idempotent. Replace names incumbent; complement explains specialization. Show real lifecycle/progress/recovery.

## Exact completion gates

Backend eligibility is authoritative. Substring-only search is insufficient. No hidden endpoint bypass.

## Tests / evidence

Browser/API semantic retrieval test; combined filters; stale enabled button rejected; tampered request blocked; double click idempotent; successful state appears only after backend verification; actual UI reaches canonical implementation path.

## Cleanup / replacement

Delete `harvest_ui.py` if it remains only a parallel in-memory abstraction; relocate any useful DTO under a real owner with a proven consumer.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
