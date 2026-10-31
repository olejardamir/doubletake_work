# MISP v1.8 Random-Month Pilot
## February 2026 — Independent discovery and high-gainer check

**Status:** Pilot result  
**Method:** MISP v1.8 holdout / leave-one-out discovery  
**Period:** February 1–28, 2026  
**Pilot vectorizer:** TF-IDF unigram/bigram vectors with L2 normalization  
**Important:** This is still a mechanics pilot, not the final dense-embedding implementation.

---

# 1. Question

The experiment was:

> Pick another month, run the same semantic procedure without targeting a known answer, discover the closest real crypto project, and then check whether that project was actually a high-gainer during the month.

February 2026 was used.

The discovery score did **not** use the candidate project's February return.

Candidate returns were checked only after the semantic ranking was produced.

---

# 2. Source universe

The synthesis universe contained:

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

The original July large-cap set was therefore retained and expanded with several February projects that had clear source documents and liquid market data.

The discovery pool also contained unseen holdout projects such as:

```text
VVV
COTI
ARB
OP
SEI
FUEL
HYPE
POWER
```

An unseen holdout did not contribute to:

```text
baseline
return-weighted target
winner evidence
loser evidence
synthesis
```

Source-universe projects were evaluated under leave-one-out scoring.

---

# 3. February returns in the source universe

Binance spot monthly open-to-close returns:

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

This was a useful stress test because the broad market was weak while a small number of projects strongly outperformed.

---

# 4. Baseline-corrected February semantic target

As in v1.8:

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

The strongest positive TF-IDF directions in the February market target were approximately:

```text
lending
machine / machine economy
governance
agents
protocol development
staking
settlement
payments
coordination
permissions
```

The strongest negative directions were approximately:

```text
general smart-contract execution
digital assets
state
parallel execution
ownership
transaction execution
programming language
high throughput
generic decentralized applications
```

This is qualitatively different from July.

February's target moved away from generic L1 execution language and toward a mixture of:

```text
agentic economic infrastructure
staking / participation
governance
financial primitives
payments / settlement
```

---

# 5. Independent discovery ranking

The semantic discovery score did **not** use the candidate's February return.

For unseen candidates:

\[
DiscoveryScore_j
=
\cos(z_j,U_{market})
\]

For a source-universe candidate, its score used a leave-one-out market target.

Top results:

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

The strongest semantic match was therefore **VVV**.

VVV was not part of the synthesis universe.

---

# 6. Was VVV actually a February high-gainer?

Yes.

Independent February performance reporting placed Venice Token (VVV) among the month's largest crypto gainers, at approximately:

```text
+96.15%
```

VVV's project description is also unusually compatible with the positive February target:

```text
AI-agent-oriented infrastructure
staking
machine access to services
tokenized economic resources
programmable AI economy
persistent inference resources
```

This overlaps strongly with the KITE-driven agentic-economy direction while remaining an independent holdout.

So the vector stage produced the desired kind of result:

```text
February documents + returns
        ↓
hidden semantic target
        ↓
independent discovery
        ↓
VVV ranked #1
        ↓
check return afterward
        ↓
VVV was a major February gainer
```

---

# 7. Important second result: the prose synthesis diverged

The v1.8 **vector target** worked better than the v1.8 **consensus prose synthesis** in this month.

The consensus rules require core synthesized traits to be supported by at least two independent winner projects.

In the source universe:

```text
KITE   → strong AI-agent / machine-economy signal
MORPHO → lending / financial primitive signal
DCR    → governance / staking signal
DOT    → interoperability / shared infrastructure signal
```

The AI-agent concept was extremely important quantitatively because KITE gained about +80%, but it was represented by only one source winner.

Under v1.8's strict multi-project consensus rule, much of that AI-agent signal was therefore suppressed from the synthetic prose.

A consensus-safe synthesis looked approximately like:

> **Synthetic February Economic Coordination Protocol**
>
> A decentralized economic coordination protocol in which token holders participate through staking and governance while the network provides verifiable settlement for digital economic activity. Participants can vote on protocol development and shared resources, while applications use the infrastructure for noncustodial financial interactions, payments, lending, and other permissionless services. The system acts as shared infrastructure for independent participants rather than a centrally controlled financial intermediary.

This prose is intentionally less dominated by KITE.

However, when unseen candidates were compared directly to that consensus-filtered prose, **COTI** was the closest tested match rather than VVV.

COTI's February return was approximately:

```text
-14.22%
```

So:

```text
VECTOR DISCOVERY
VVV → #1 → +96% actual return
GOOD

CONSENSUS PROSE DISCOVERY
COTI → #1 → -14% actual return
NOT GOOD
```

---

# 8. What February taught us

This random-month test exposed an important remaining flaw.

The v1.8 anti-dominance rule solved the July Ethereum-paraphrase problem, but it is now **too aggressive** in periods where a genuine market theme is concentrated in one major source winner and independently appears in an unseen winner.

In February:

```text
KITE
    ↓
strong agentic-economy semantic signal
    ↓
VVV independently expresses a very similar theme
    ↓
VVV was also a +96% gainer
```

But the prose generator removed much of the KITE-specific AI-agent signal because only one source winner supported it.

The quantitative target retained that information and successfully discovered VVV.

The prose stage did not.

---

# 9. Recommended algorithm correction

Do **not** remove a strong single-project semantic theme completely.

Instead separate concepts into:

```text
CONSENSUS
supported by >= 2 source winners

HIGH_ECONOMIC_SIGNAL
supported by one source winner but carrying unusually large,
baseline-corrected return-weighted contribution

PROJECT_SPECIFIC_NOISE
single-source and weak economic contribution
```

The synthetic document may include `HIGH_ECONOMIC_SIGNAL` concepts, but:

1. they must be expressed abstractly rather than copied from the source project's wording;
2. they must be labeled internally as single-source hypotheses;
3. they must not dominate the document;
4. independent holdout discovery can then validate whether another project expresses the same theme.

This would have allowed:

```text
agentic economic infrastructure
machine-to-machine services
staking for service access
programmable payments / settlement
```

to remain visible in February without turning the synthesis into a KITE paraphrase.

If an unseen project such as VVV then independently matches that direction, the signal gains credibility.

---

# 10. Conclusion

The random February test was encouraging but also diagnostic.

## Quantitative semantic target

**Success.**

The #1 unseen semantic match was:

> **Venice Token (VVV)**

and VVV was indeed a major February 2026 gainer at roughly **+96%**.

Several other highly ranked source projects were also strong February gainers:

```text
MORPHO +55%
KITE   +80%
DCR    +69%
```

## Synthetic prose

**Still needs one correction.**

The strict multi-project consensus filter removed a genuine high-weight semantic theme when it appeared in only one source winner, causing the prose representation to drift away from the vector target.

The next version should preserve strong single-source economic signals as controlled hypotheses rather than deleting them.

---

# 11. Bottom line

For February 2026:

```text
discovered crypto = VVV (Venice Token)
discovery mode    = unseen holdout
semantic rank     = #1
February return   ≈ +96%
high-gainer?      = YES
```

The vector portion of MISP passed this random-month test.

The prose-synthesis portion exposed the next flaw to fix.
