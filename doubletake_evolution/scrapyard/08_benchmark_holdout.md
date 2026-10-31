# Remaining Task 08 — Qualify Search Policy with Real Holdout + Ablations

Connect benchmark logic to real retrieval/gating/promotion outcomes and only promote search policy on sustained downstream value.

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

- donor `harvest_benchmarks.py`
- canonical retrieval/generator/scheduler and promotion outcomes
- existing benchmark/test infrastructure

## Required work

Run fair B0-B5/equivalent baselines on fixed context/budget. Measure substantive candidates, benchmark-positive/promoted per cost, time/cost to first promotion, coverage, duplicates. Maintain TRAIN/VALIDATION/HOLDOUT and prevent leakage. Ablate diversity, delayed reward, uncertainty, exploration, R1, probe/candidate ASHA, generator adaptation. Control exact-vs-ANN effects.

## Exact completion gates

Proxy-only gains do not qualify. If holdout does not show advantage, incumbent policy remains default. Invalid context requires rebase, not cherry-picking.

## Tests / evidence

Equal-budget baseline; hidden holdout; ablations; exact-vs-ANN control; reject policy that improves novelty but worsens downstream promotions/value.

## Cleanup / replacement

Benchmark module may remain benchmark-only if wired to real production interfaces and never used as runtime authority.

## Completion record

Record starting/ending HEAD, semantic delta/reconciliation, owners changed, donor symbols consumed, donor files deleted/retained and why, production call paths, exact test commands/results, rollback point, and all failures/UNKNOWNs.
