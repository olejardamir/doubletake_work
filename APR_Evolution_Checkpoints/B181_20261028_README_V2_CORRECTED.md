# APR B181 V2 — corrected comparator, immutable source and model forecasts

**2026-10-28 UTC · EXPOSED RETROSPECTIVE research only · no A165 change or trades.**

**Important correction:** The first B181 scoreboard/README mistakenly labeled C184's `q_fixed_matched` *ablation* as its final forecast. The actual C184 comparator is `q_refined_innovation` per C184's original mathematical definition. The original B181 files remain untouched; this **V2 supersedes their C184-related metrics**. The corrected B155 C184 Brier reproduces the published **0.163297955**, while B/M reproduce .187792170/.179779925. Markov/iid forecast vectors and 36 raw source arrays are unchanged.

**New data:** 36 Binance Spot historical 14d hourly 336-bar windows, 12,096 consecutive completed bars, stored in four new append-only B181 provider-normalized array files. Original exchange HTTP and contemporaneous historical provider delivery unavailable. Pre-t0 B176 p14 agrees to max 4.74e−10. Data retrieved retrospectively after the 2024–2026 events; first-hit maturity dates and historical issued q unverified.

**Falsifiable transformation:** estimate smoothed P(next up | prior up/down) with +2 pseudocount per branch, empirical conditional hourly log-return means u,d and last observed pre-t0 sign. Solve 2-state absorbing mean-jump Bellman equation for original log barriers ln(.97),ln(1.05) with 400 grid cells, tolerance 1e−11, max 6000 iterations. Fixed iid-sign ablation and 7d sensitivity. No forecast horizon, no P0 rebase. The original model q vectors were stored before joining the exposed historical labels, but the outcomes were previously known to the research program: **not blind validation**.

## Corrected same 36 resolved B155 events (10 target, 26 adverse)

| Method | Brier ↓ | Log loss ↓ | TP/FP/FN/TN at q≥.5 |
|---|---:| ---:|---|
| B | 0.187792170 | 0.561785418 | 7/4/3/22 |
| M | 0.179779925 | 0.543481857 | 7/3/3/23 |
| C184 | 0.163297955 | 0.512903084 | 7/2/3/24 |
| markov14 | 0.309333640 | 0.902083861 | 5/11/5/15 |
| iid14 | 0.300925579 | 0.872642655 | 5/11/5/15 |
| markov7 | 0.337524491 | 1.175801633 | 5/11/5/15 |
| iid7 | 0.338134348 | 1.132298908 | 5/11/5/15 |

Markov14 − C184 **0.146035685 Brier**, **0.389180777 log loss**; − iid14 **0.008408061 Brier**, **0.029441206 log loss**; − B **0.121541471**, − M **0.129553715**. Date wins/losses Markov14 vs C184 **3/9**; leave-one-date-out paired delta [0.112571001,0.172810584]. Asset paired Brier deltas: BTCUSDT 0.245433075; ETHUSDT 0.112328289; XRPUSDT 0.080345691. Date-matched top-one target hits /12: B 4; M 3; C184 4; markov14 3; iid14 3; markov7 2; iid7 3. No abstention credited.

**Verdict:** Markov14 does not improve C184, B, M or its iid-sign ablation on this exposed B155 cohort. This temporal-order signal is mathematically distinguishable, but its errors are not beneficial here. Do not tune sign smoothing or select 7d postlabel. Next falsifier is unchanged Markov14 transfer to disjoint B152/B154 using archived raw pre-t0 14d hourly arrays; existing B180/B179 derived summaries omit sign transition ordering, so fresh retrieval/archiving is needed. Future proof requires Nov05+ separate independently frozen shadow q and original individual P0 binding; Oct29 A165 27 q and C gates remain immutable.
