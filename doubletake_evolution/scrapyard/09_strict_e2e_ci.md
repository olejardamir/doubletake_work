# Remaining Task 09 — Replace Smoke Audit with Strict Production-Path E2E + CI

Make the audit drive real API/UI/backend/semantic/promotion paths and fail on any hard requirement.

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

- donor `harvest_audit.py`, `test_harvest_audit.py`
- actual API/frontend and canonical production owners
- existing CI/test configuration

## Required work

Remove partial-success acceptance such as `passed >= 10`. PASS iff all hard checks pass and no hard UNKNOWN remains. Drive: duplicate/no-value rejection before code; tampered UI/API bypass attempt; high-value semantic-plan -> code -> real caller -> evaluation -> canary -> promotion; replacement cleanup; complement routing; restart no duplicate effect; rollback; semantic/source/runtime reconciliation; search for obsolete authority shortcuts/dead promoted files.

## Exact completion gates

One hard failure = overall FAIL. Importability/class construction is not E2E evidence. No certification without exercising real frontend/API/runtime caller.

## Tests / evidence

Strict empty-failure assertion; intentionally broken wiring makes audit fail; donor-only isolated implementation does not count; affected existing suites plus correction suites; visible CI command/status where supported.

## Cleanup / replacement

Move/delete runtime audit module if it is test-only. Keep runtime diagnostic only if a real operational consumer justifies it.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
