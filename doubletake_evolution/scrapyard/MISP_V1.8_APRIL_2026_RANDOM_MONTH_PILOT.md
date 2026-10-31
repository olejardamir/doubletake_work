# MISP v1.8 Random-Month Pilot
## April 2026 — Independent semantic discovery and high-gainer check

**Status:** Pilot result  
**Method:** MISP v1.8 holdout / leave-one-out discovery  
**Period:** April 1–30, 2026  
**Pilot vectorizer:** TF-IDF unigram/bigram vectors with L2 normalization  
**Important:** This remains a mechanics pilot, not the final dense-embedding implementation.

---

# 1. Question

The experiment was:

> Run the same MISP discovery process on another month, identify the closest real crypto project using semantics only, then check the discovered project's monthly return afterward.

April 2026 was used.

Candidate returns were **not** used in semantic discovery ranking.

They were checked only after the ranking was locked.

---

# 2. Important methodological correction

For this April test, the TF-IDF semantic space was fitted **only on the source/synthesis universe**.

Discovery-candidate documents were transformed into that already-frozen semantic space afterward.

This prevents discovery candidates from affecting:

```text
vocabulary
inverse-document-frequency weights
source document vectors
baseline vector
market target
```

The procedure is therefore:

```text
SOURCE DOCUMENTS
      ↓
FIT SEMANTIC SPACE
      ↓
BUILD BASELINE + MARKET TARGET
      ↓
FREEZE TARGET
      ↓
TRANSFORM UNSEEN CANDIDATES
      ↓
DISCOVERY RANKING
      ↓
ONLY THEN CHECK RETURNS
```

This is stricter than the earlier exploratory pilots.

---

# 3. Source universe

The April source universe reused the same broad project set as the February experiment:

```text
BTC
ETH
SOL
AVAX
DOT
ADA
BNB
UNI
NEAR
ATOM
APT
SUI
KITE
MORPHO
DCR
```

The source project documents were represented with the same concise source-derived project descriptions used by the pilot methodology.

Discovery projects such as Euler, Compound, Aave, Kamino, Venus, Fluid, Maple/Syrup, Sky, Spark, Pendle, Ondo, Ethena, and others did not contribute to the April target.

---

# 4. April source-universe returns

Binance monthly spot open-to-close returns:

| Project | April 2026 return |
|---|---:|
| **MORPHO** | **+30.10%** |
| BTC | +11.81% |
| APT | +11.42% |
| ATOM | +10.60% |
| NEAR | +9.18% |
| ETH | +7.22% |
| SUI | +3.40% |
| AVAX | +2.02% |
| ADA | +1.86% |
| SOL | -0.12% |
| BNB | -0.33% |
| DOT | -3.91% |
| KITE | -8.68% |
| UNI | -10.07% |
| DCR | -10.89% |

The strongest source-universe winner was therefore MORPHO.

---

# 5. Baseline-corrected April market target

As in MISP v1.8:

\[
B = \frac{1}{N}\sum_i x_i
\]

\[
z_i = Normalize(x_i-B)
\]

\[
V_{market}
=
\frac{\sum_i r_i z_i}
{\sum_i |r_i|}
\]

\[
U_{market}=Normalize(V_{market})
\]

The strongest positive semantic directions in the resulting April target were approximately:

```text
lending
borrowing
collateral
permissionless credit markets
noncustodial financial infrastructure
interest-rate markets
financial primitives
liquidity
immutable / isolated markets
```

The dominant economic reason was straightforward:

```text
MORPHO +30.1%
```

while several generic L1 / governance / exchange-oriented projects were flat or negative.

---

# 6. Discovery universe

The independent holdout pool was widened semantically before checking returns.

It included projects representing:

```text
lending / credit
liquidity
yield
RWA finance
general smart-contract infrastructure
execution layers
trading infrastructure
```

Examples:

```text
EUL
COMP
AAVE
KMNO
XVS
FLUID
SYRUP
SKY
SPK
PENDLE
ONDO
ENA
FUEL
INJ
STX
ICP
COTI
VVV
ARB
OP
SEI
```

No candidate's April return was used to choose or score it.

---

# 7. Independent semantic ranking

For an unseen candidate \(j\):

\[
DiscoveryScore_j
=
\cos(z_j,U_{market})
\]

The strongest unseen matches were:

| Rank | Project | Discovery mode | Semantic score |
|---:|---|---|---:|
| **1** | **Euler (EUL)** | **UNSEEN_HOLDOUT** | **0.437** |
| 2 | Compound (COMP) | UNSEEN_HOLDOUT | 0.396 |
| 3 | Kamino (KMNO) | UNSEEN_HOLDOUT | 0.307 |
| 4 | Aave (AAVE) | UNSEEN_HOLDOUT | 0.289 |
| 5 | Venus (XVS) | UNSEEN_HOLDOUT | 0.276 |
| 6 | Fluid | UNSEEN_HOLDOUT | 0.248 |
| 7 | Maple / Syrup (SYRUP) | UNSEEN_HOLDOUT | 0.210 |
| 8 | Sky (SKY) | UNSEEN_HOLDOUT | 0.201 |
| 9 | Ondo (ONDO) | UNSEEN_HOLDOUT | 0.121 |
| 10 | Fuel | UNSEEN_HOLDOUT | 0.086 |
| 11 | Ethena (ENA) | UNSEEN_HOLDOUT | 0.069 |
| 12 | Spark (SPK) | UNSEEN_HOLDOUT | 0.062 |

The #1 result was therefore:

> **Euler (EUL)**

Euler did not participate in synthesis.

---

# 8. Why Euler matched

The April target was strongly tilted toward:

```text
permissionless lending
configurable credit markets
collateralized borrowing
financial primitives
modular / isolated markets
noncustodial infrastructure
```

Euler is explicitly designed as modular onchain lending infrastructure for creating and configuring credit markets.

Its architecture includes configurable lending vaults, collateral relationships, interest-rate models, borrowing, risk parameters, and composable lending markets.

This is a strong semantic match to the April target generated largely from MORPHO's strong positive return.

---

# 9. Only after discovery: check April returns

After locking the semantic ranking, the candidate returns were checked.

Binance monthly spot open-to-close results:

| Project | Semantic rank | April return |
|---|---:|---:|
| **EUL** | **#1** | **+50.00%** |
| **COMP** | #2 | **+33.88%** |
| **KMNO** | #3 | **+23.53%** |
| AAVE | #4 | -5.44% |
| XVS | #5 | -9.09% |
| FLUID | #6 | Binance pair unavailable in this check |
| **SYRUP** | #7 | **+15.57%** |
| SKY | #8 | +6.99% |
| ONDO | #9 | -3.77% |
| ENA | #11 | **+12.86%** |
| **SPK** | #12 | **+70.88%** |

Additional checked projects:

```text
PENDLE +27.87%
INJ    +18.74%
ICP     +3.08%
STX     -1.78%
```

---

# 10. Primary result

The independently discovered #1 project was:

> **Euler (EUL)**

Its April return was:

\[
\boxed{+50.0\%}
\]

So the answer to the experiment is:

```text
discovered crypto = EUL
semantic rank     = #1
discovery mode    = unseen holdout
April return      = +50.0%
high-gainer?      = YES
```

---

# 11. A broader pattern also appeared

The result was not limited to Euler.

Several of the top semantic matches were also strong April gainers:

```text
EUL    #1   +50.0%
COMP   #2   +33.9%
KMNO   #3   +23.5%
SYRUP  #7   +15.6%
```

This suggests that the April semantic target was capturing a broader **credit / lending / liquidity infrastructure** theme rather than merely rediscovering one project.

However, the relationship is not perfect:

```text
AAVE   #4   -5.4%
XVS    #5   -9.1%
```

So semantic similarity is not equivalent to return prediction.

---

# 12. What the synthetic April archetype looks like

The vector itself points most strongly toward a project with approximately this architecture:

> **A permissionless, noncustodial credit infrastructure layer built from configurable lending markets. Users can supply assets, borrow against collateral, and interact with isolated markets whose risk parameters and interest-rate logic are defined onchain. The system acts as a composable financial primitive that applications and market operators can use to create specialized credit and liquidity products rather than relying on a single centrally managed lending pool.**

This description is intentionally a semantic interpretation of the April target rather than copied wording from Euler.

It is notably closer to:

```text
Euler
Compound
Kamino
Aave
Venus
```

than to general-purpose L1 projects.

---

# 13. Remaining prose-synthesis caveat

The known v1.8 prose issue is still relevant.

MORPHO was the strongest source winner at +30.1%, so much of the lending signal is a **high-economic-signal theme originating strongly from one source project**.

Strict multi-project consensus can suppress too much of that signal.

For this reason, the **quantitative market vector and independent discovery ranking remain the primary result** of this pilot.

The February recommendation still stands:

```text
CONSENSUS
    +
HIGH_ECONOMIC_SIGNAL
    -
PROJECT_SPECIFIC_NOISE
```

would be a better synthesis rule than simply deleting every single-source theme.

---

# 14. Interpretation

April is another encouraging month for the vector-discovery mechanism.

The source market said, approximately:

```text
MORPHO strongly up
several infrastructure chains moderately up
DEX / governance / some broad crypto themes weak
```

The hidden semantic target therefore moved strongly toward:

```text
lending
credit
collateral
borrowing
permissionless financial markets
```

Without using candidate returns, the closest unseen project was:

```text
Euler
```

Euler then turned out to have gained:

```text
+50%
```

during April.

---

# 15. Comparison with February

February:

```text
discovered project = VVV
actual return       ≈ +96%
```

April:

```text
discovered project = EUL
actual return       = +50%
```

These are two different semantic regimes:

```text
February → agentic / machine-economy infrastructure
April    → lending / credit infrastructure
```

and in both cases the #1 unseen semantic match was subsequently found to be a major monthly gainer.

This remains exploratory evidence, not proof of a predictive relationship.

---

# 16. Bottom line

For April 2026:

```text
MISP discovery = EUL
semantic score = 0.437
April return   = +50.0%
high-gainer    = YES
```

Several other high-ranking semantically similar lending projects also posted strong positive April returns.

The April random-month test therefore supports continued investigation of the core MISP vector-discovery idea.
