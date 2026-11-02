# MISP JAN16 31 2026 TO FEB2026 FORWARD LAG TEST — distilled source with numeric evidence

**Provenance:** original Git blob `8dc5402c673631d1874dbb8e39dc853c3028ce45`; complete original recoverable via Git history. Historical exploratory analysis only; numerical returns and claims not independently verified.

**Scope:** Jan 16–31, 2026 signal → Feb 1–28 outcome. MISP v1.8 baseline-corrected TF-IDF unigram/bigram; 15-source universe (BTC, ETH, SOL, AVAX, DOT, ADA, BNB, UNI, NEAR, ATOM, APT, SUI, KITE, MORPHO, DCR). This was a **retrospective forward-lag sanity check, not pristine blind holdout**: February had already been examined during exploratory work. Discovery candidates transformed into source-fitted frozen vectorizer; rank fixed before looking at returns.

**Mechanism:** `B=mean(x_i)`, `z_i=normalize(x_i-B)`, `V=sum(r_i*z_i)/sum(abs(r_i))`, `U=normalize(V)`; score held-out candidate by `cos(z_j,U)`. KITE Jan +47.14% while almost all other sources negative pushed agentic-economy/identity/permissions/payment theme. VVV ranked #1 at score 0.368, but was unavailable through the same Binance return query; independent price providers estimated February VVV return **+90% to +131%** (different definitions), so exact comparability is UNKNOWN. With conservative +90%: n=19 Spearman ≈+0.43, p≈0.069; top-3 equal weight ≈+32.2%, top-5 ≈+11.5%, measured pool ≈−11.3%. Top-5 depends heavily on VVV.

**Counterevidence and tests:** One selected month, known prior February exposure, small candidate pool, document/price provider choices, regime and researcher degrees of freedom prevent predictive-power claims. Freeze source/discovery universe, official pre-cutoff documents, vectorizer, baseline/return weights and ranking across many consecutive untouched windows; compare top-1/top-5/decile/Spearman against momentum and random selection, with source-date, price convention and survivorship controls. Not a DT capability or financial recommendation.

## Original numeric tables (preserved verbatim)

### Source table: 3. January 16–31 source returns

| Project | Jan 16–31 return |
|---|---:|
| **KITE** | **+47.14%** |
| BNB | -16.09% |
| BTC | -17.64% |
| MORPHO | -18.66% |
| ATOM | -20.43% |
| ADA | -25.43% |
| SOL | -25.86% |
| UNI | -26.00% |
| ETH | -26.12% |
| AVAX | -26.77% |
| DOT | -26.92% |
| APT | -29.28% |
| DCR | -29.90% |
| NEAR | -29.97% |
| SUI | -35.24% |

### Source table: 5. Frozen discovery ranking

| Rank | Project | Semantic score |
|---:|---|---:|
| **1** | **VVV (Venice Token)** | **0.368** |
| 2 | SKY | 0.105 |
| 3 | SPK | 0.099 |
| 4 | ENA | 0.098 |
| 5 | COTI | 0.064 |
| 6 | COMP | 0.059 |
| 7 | EUL | 0.050 |
| 8 | KMNO | 0.042 |
| 9 | XVS | 0.036 |
| 10 | HYPE | 0.035 |
| 11 | PENDLE | 0.029 |
| 12 | INJ | 0.008 |
| 13 | ONDO | 0.002 |
| 14 | SYRUP | -0.002 |
| 15 | AAVE | -0.016 |
| 16 | ICP | -0.028 |
| 17 | SEI | -0.066 |
| 18 | STX | -0.075 |
| 19 | ARB | -0.085 |
| 20 | OP | -0.118 |

### Source table: 6. February outcome check

| Project | Semantic rank | February return |
|---|---:|---:|
| SKY | #2 | **+12.02%** |
| SPK | #3 | -5.47% |
| ENA | #4 | -24.89% |
| COTI | #5 | -14.22% |
| COMP | #6 | -8.49% |
| EUL | #7 | -23.79% |
| KMNO | #8 | -37.31% |
| XVS | #9 | -11.76% |
| PENDLE | #11 | -19.38% |
| INJ | #12 | -13.69% |
| ONDO | #13 | -9.14% |
| SYRUP | #14 | -25.53% |
| AAVE | #15 | -13.26% |
| ICP | #16 | -10.65% |
| SEI | #17 | -21.58% |
| STX | #18 | -0.15% |
| ARB | #19 | -28.84% |
| OP | #20 | -47.65% |
