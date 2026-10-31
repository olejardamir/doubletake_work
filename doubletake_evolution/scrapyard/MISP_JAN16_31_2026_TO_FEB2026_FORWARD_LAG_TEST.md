# MISP Forward-Lag Test
## January 16–31, 2026 signal → February 2026 returns

**Status:** Retrospective forward-lag pilot  
**Method:** MISP v1.8 baseline-corrected semantic target + independent discovery  
**Signal window:** January 16–31, 2026  
**Outcome window:** February 1–28, 2026  
**Pilot vectorizer:** Frozen TF-IDF unigram/bigram space  
**Primary question:** Does the semantic theme rewarded in the second half of January identify projects that outperform in February?

---

# 1. Important methodological note

This test uses the correct temporal direction:

```text
January 16–31 information
        ↓
freeze semantic target on January 31
        ↓
rank projects
        ↓
observe February returns
```

However, February 2026 had already been examined during earlier exploratory work in this project.

Therefore this is **not a pristine blind out-of-sample test**.

It is a retrospective forward-lag sanity check.

A stronger predictive study requires freezing the algorithm and then running many historical windows without altering the method after seeing their next-period outcomes.

---

# 2. Source universe

The source universe was the same broad 15-project set used in the recent pilots:

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

Only January 16–31 returns were used in the market target.

The semantic space was fitted on source documents only and then frozen before unseen discovery candidates were transformed into it.

---

# 3. January 16–31 source returns

Binance spot daily open-to-close data:

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

This is an unusually clear semantic setup:

```text
KITE strongly positive
almost every other source project strongly negative
```

So the signed market target becomes approximately:

> move toward KITE's distinctive semantics and away from the broad semantics associated with the rest of the falling market.

---

# 4. Semantic target

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
U_{market}
=
Normalize(V_{market})
\]

The resulting January target strongly favored concepts around:

```text
AI agents
agentic economy
machine-to-machine activity
programmable identity / permissions
payments
settlement
autonomous services
```

while moving away from generic L1 / execution / interoperability semantics.

---

# 5. Frozen discovery ranking

The ranking was calculated **before evaluating February returns**.

Discovery candidates were transformed into the semantic space already fitted on the source universe.

Top semantic matches:

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

VVV was far ahead of the rest of the discovery pool.

---

# 6. February outcome check

Only after the ranking was fixed were February returns checked.

For Binance-listed candidates:

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

VVV was not available through the same Binance spot query used for the rest of the table, so an external historical-price source is required for its February return.

Independent sources consistently identify VVV as a very large February 2026 winner.

Published monthly figures differ by provider:

```text
approximately +90%
to
approximately +131%
```

The exact percentage is provider-dependent, but the qualitative classification is not:

> VVV was one of February's major gainers.

---

# 7. Primary predictive result

The January 16–31 signal predicted:

```text
#1 semantic project = VVV
```

The subsequent February outcome was:

```text
VVV = major positive return
```

Using the conservative +90% monthly-return estimate:

```text
predicted rank = #1
next-month return ≈ +90%
```

Using another historical-price provider's open/close series, the estimate is approximately +131%.

Either measure makes VVV an exceptionally strong February performer.

---

# 8. Cross-sectional check

Using the conservative +90% VVV return and 18 other discovery candidates with measurable February returns:

```text
n = 19
Spearman(score, next-month return) ≈ +0.43
p ≈ 0.069
```

This is not statistically conclusive.

But the direction is positive and nontrivial for a single exploratory month.

---

# 9. Portfolio-style check

Using the conservative VVV return estimate:

## Top 1

```text
VVV ≈ +90%
```

## Top 3

```text
VVV + SKY + SPK
equal-weight average ≈ +32.2%
```

## Top 5

```text
VVV + SKY + SPK + ENA + COTI
equal-weight average ≈ +11.5%
```

## Measurable discovery-pool average

```text
≈ -11.3%
```

So in this specific window:

```text
top-5 MISP ≈ +11.5%
candidate-pool average ≈ -11.3%
```

The top-5 result is heavily helped by VVV, which is why many months are needed before drawing conclusions.

---

# 10. Why VVV was predicted

The January semantic target was driven strongly by KITE's relative strength.

KITE's project semantics emphasize:

```text
AI agents
autonomous economic actors
identity / permissions
machine payments
settlement
agent authorization
```

VVV independently occupies a nearby semantic region:

```text
AI inference
AI agents
developer / agent access
staking for computational services
machine-oriented economic infrastructure
private AI services
```

This produces a plausible propagation hypothesis:

```text
KITE reprices first
        ↓
January semantic target moves toward agentic economy
        ↓
VVV is semantically close but not used in target
        ↓
VVV strongly reprices in February
```

That is exactly the kind of lagged semantic propagation MISP is intended to test.

---

# 11. What this does and does not prove

## It supports

The experiment supports the possibility that:

> semantic themes revealed by current-period winners may identify related projects that reprice in the following period.

The strongest semantic match was not merely another January winner.

It was an independently ranked project that subsequently became a major February winner.

## It does not yet prove

One successful month does not establish predictive power.

Potential explanations still include:

```text
luck
theme momentum
selection effects
small discovery universe
document-representation artifacts
market-wide regime effects
researcher degrees of freedom
```

Most importantly, February had already been examined in earlier exploratory work, so this test is not fully blind.

---

# 12. Required next test

Freeze the method now:

```text
source-universe rules
document sources
embedding/vectorizer
baseline correction
return weighting
discovery universe
ranking rule
```

Then run many consecutive windows without changing them.

For example:

```text
Jan 1–15  → Jan 16–31
Jan 16–31 → February
February  → March
March     → April
April     → May
...
```

For every period record:

```text
semantic score
semantic rank
next-period return
next-period return rank
```

Primary metrics:

```text
Top-1 next-period return
Top-5 equal-weight next-period return
top-decile hit rate
Spearman score/return correlation
performance versus previous-period momentum
performance versus random selection
```

No parameter should be changed because a particular month succeeds or fails.

---

# 13. Bottom line

The requested lagged test produced:

```text
SIGNAL WINDOW
Jan 16–31, 2026

#1 DISCOVERY
VVV

OUTCOME WINDOW
February 2026

VVV RETURN
approximately +90% to +131%, depending on price-data provider

HIGH GAINER?
YES
```

This is the first result in the project that has the correct **signal first → future return second** structure.

It is highly encouraging, but it should be treated as one retrospective forward-lag observation rather than proof of predictive power.
