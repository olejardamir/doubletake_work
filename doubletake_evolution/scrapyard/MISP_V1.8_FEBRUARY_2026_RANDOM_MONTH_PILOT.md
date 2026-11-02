# MISP V1.8 FEBRUARY 2026 RANDOM MONTH PILOT — distilled source with numeric evidence

**Provenance:** original Git blob `0fa2cca8b98a437dc56d8e382023e762197407fe`; complete original recoverable via Git history. Historical exploratory analysis only; numerical returns and claims not independently verified.

**Scope:** February 2026 same-month MISP v1.8 TF-IDF unigram/bigram pilot, not forward prediction or dense embeddings. Source universe BTC ETH SOL AVAX DOT ADA BNB UNI NEAR ATOM APT SUI KITE MORPHO DCR. Held-out VVV/COTI/ARB/OP/SEI/FUEL/HYPE/POWER did not affect baseline, target or prose; source members scored leave-one-out. Candidate February returns inspected after ranking, but research selection/history and prices not independently reproduced.

**Mechanism:** `B=mean(x_i)`, `z_i=normalize(x_i-B)`, `V=sum(r_i*z_i)/sum(abs(r_i))`, `U=normalize(V)`; candidate score cosine with U (source members leave-one-out). February KITE +80.10%, DCR +69.01%, MORPHO +55.01% opposed falling broad market. VVV unseen holdout ranked #1, cosine 0.189, reported February return about +96% (third-party pricing); POWER ranked #9 despite claimed +673%, demonstrating missed winners. **Important negative:** consensus-only prose (>=2 independent winners for core traits) suppressed KITE's high-weight single-source agent theme; prose retrieval ranked COTI #1, whose February return was −14.22%. Vector rank and prose rank are not equivalent.

**Conditional correction:** Distinguish `CONSENSUS` (>=2 winners), `HIGH_ECONOMIC_SIGNAL` (single high return-weighted source, abstractly labeled and capped), and `PROJECT_SPECIFIC_NOISE`; do not erase all single-source signals or let one project's phrasing dominate. Test frozen untouched months with leave-one-out and unseen discovery, source-date controls, independent price checks, source ablations and counterfactual prose-vs-vector comparison. No proof of future prediction, DT implementation or authorization.

## Original numeric tables (preserved verbatim)

### Source table: 3. February returns in the source universe

| Project | February return |
|---|---:|
| KITE | **+80.10%** |
| DCR | **+69.01%** |
| MORPHO | **+55.01%** |
| DOT | +7.36% |
| NEAR | -2.82% |
| UNI | -3.79% |
| ADA | -4.32% |
| ATOM | -6.24% |
| AVAX | -9.49% |
| BTC | -14.94% |
| ETH | -19.88% |
| SOL | -20.11% |
| BNB | -21.02% |
| SUI | -21.62% |
| APT | -24.49% |

### Source table: 5. Independent discovery ranking

| Rank | Project | Mode | Semantic score | February return |
|---:|---|---|---:|---:|
| **1** | **VVV (Venice Token)** | **UNSEEN_HOLDOUT** | **0.189** | **about +96%** |
| 2 | BTC | LEAVE_ONE_OUT | 0.070 | -14.94% |
| 3 | MORPHO | LEAVE_ONE_OUT | 0.036 | **+55.01%** |
| 4 | KITE | LEAVE_ONE_OUT | 0.035 | **+80.10%** |
| 5 | ATOM | LEAVE_ONE_OUT | 0.026 | -6.24% |
| 6 | DOT | LEAVE_ONE_OUT | 0.020 | +7.36% |
| 7 | DCR | LEAVE_ONE_OUT | 0.016 | **+69.01%** |
| 8 | UNI | LEAVE_ONE_OUT | 0.010 | -3.79% |
| 9 | POWER | UNSEEN_HOLDOUT | 0.007 | **about +673%** |
