# Historical Harvest Task 08 — Fixed-budget holdout and ablation

**Provenance:** Astrocytech/Agent_X audit `874bbe4268aca0539cbf8476f62444d704f2d555` (implementation wave after `3887efe448edd223a00f94db324786d6a47a2d3b`). Historical benchmark plan, not a verified DT improvement. Original blob `9f5ca876be588f7249cd55e2c078b7a606ee84f7`; D01 digest: [DISTILLED_KNOWLEDGE.md](DISTILLED_KNOWLEDGE.md).

**Historical loci:** Donor `harvest_benchmarks.py`, canonical retrieval/generator/scheduler, actual promotion results and existing benchmark infrastructure. Benchmarks cannot become runtime authority.

**Mechanism:** Fair B0–B5 (or equivalent) fixed-context/fixed-budget comparison, TRAIN/VALIDATION/HOLDOUT with leakage controls. Measure substantive qualified candidates, promotion/value per cost, time/cost to first promotion, coverage and duplicate rate; distinguish downstream success from novelty proxy. Ablate diversity, delayed reward, uncertainty, exploration, R1, probe/candidate ASHA and generator adaptation; control exact-vs-ANN retrieval. Rebase on invalid context, never cherry-pick.

**Falsifiable acceptance:** Hidden holdout and equal-budget controls must show sustained downstream improvement; a novelty-only gain with worse promoted value fails. If no holdout advantage, incumbent policy remains default. Donor benchmark code may stay test-only if it uses real production interfaces and does not grant promotion. Record start/end HEAD, exact evaluation commands/results, semantic delta, owner changes, rollback and unknowns. Current DT baseline and source parity unverified.
