# MISP v1.8 Holdout-Discovery Pilot
## July 2026 — Can the algorithm discover COTI without using COTI?

**Status:** Pilot result  
**Method version:** MISP v1.8  
**Vectorizer:** TF-IDF pilot vectorizer, not production dense embeddings  
**Period:** July 2026  
**Primary question:** Can the market-implied semantic archetype independently identify COTI as the closest real project when COTI is excluded from synthesis?

---

# 1. Purpose

The previous pilot had two important biases:

1. the synthesis universe was too small, so Ethereum could dominate the target;
2. the generated document could inherit too much wording from one high-weight project.

MISP v1.8 introduced two corrections:

- **multi-project consensus synthesis**, so a core characteristic must be supported by multiple independent winner documents;
- **holdout / leave-one-out discovery**, so a project cannot rank highly merely because its own document helped create the target.

This pilot tests those corrections.

The desired behavior is:

```text
broad project universe
    ↓
build market-implied semantic archetype
    ↓
exclude COTI entirely from synthesis
    ↓
generate synthetic market-rewarded project
    ↓
search independent discovery universe
    ↓
see whether COTI emerges naturally
```

---

# 2. Source universe

The July synthesis used the following 12 projects:

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
```

COTI was **not** included in:

```text
universe baseline
document vectors used for synthesis
return-weighted target
winner evidence
loser evidence
consensus concepts
synthetic document generation
```

COTI therefore had no opportunity to influence the target.

---

# 3. July 2026 return context

The same July 2026 market period used in the previous pilot was retained.

Examples from the source universe:

```text
ETH   +18.5%
BTC    +7.3%
ADA   +16.5%
UNI   +56.5%
BNB    +7.4%

SOL    -1.1%
AVAX   -2.3%
DOT    -7.7%
NEAR   negative
ATOM   negative
APT    negative
SUI    negative
```

The purpose was not to optimize the asset list around COTI. The source universe was broadened specifically so the semantic target would be less dependent on Ethereum alone.

---

# 4. Anti-dominance rule

MISP v1.8 requires a core characteristic to be supported across multiple independent winner documents.

Initial rules used conceptually in this pilot:

```yaml
minimum_distinct_supporting_projects: 2
preferred_distinct_supporting_projects: 3
max_evidence_share_per_project: 0.35
```

This means:

```text
Ethereum-only characteristic
    → PROJECT_SPECIFIC
    → cannot define core archetype

Ethereum + Cardano + BNB characteristic
    → consensus characteristic
    → eligible for archetype
```

Economic return weighting remains unchanged.

The cap applies to synthesis evidence and wording, not to the quantitative return calculation.

---

# 5. Consensus concepts

After baseline correction and multi-project consensus filtering, the surviving winner-side theme was approximately:

```text
general-purpose programmable execution
Turing-complete or highly expressive contract logic
programmable ownership and spending conditions
digital-asset interaction
smart contracts
interacting / composable applications
financial applications
liquidity and exchange primitives
shared programmable infrastructure
contract-mediated transactions
```

The main improvement over the earlier pilot is that these concepts were not allowed to enter the archetype merely because Ethereum expressed them strongly.

They had to be supported across multiple winner-side projects.

---

# 6. Synthetic market-implied document

The resulting synthesis was:

> **Synthetic Market-Rewarded Programmable Finance Platform**
>
> The project is a programmable smart-contract execution environment for decentralized financial applications. The system supports Turing-complete contract logic and flexible rules for ownership, spending, transaction behavior, and digital assets.
>
> Smart contracts and applications can interact to compose financial protocols, token exchange, liquidity, and other programmable services on shared decentralized infrastructure.
>
> The design emphasizes general-purpose financial programmability, asset interaction, and contract-mediated transactions rather than requiring a separate application-specific blockchain for each use case.

This differs from the previous Ethereum-like synthesis in an important way.

It no longer centers on Ethereum-whitepaper-specific phrasing such as:

```text
arbitrary state-transition functions
arbitrary rules for transaction formats
shared programmable state system
```

Instead, it expresses a cross-project theme.

---

# 7. Independent discovery stage

Only after the archetype was created was COTI added to the discovery universe.

Two discovery modes were used.

## 7.1 UNSEEN_HOLDOUT

For projects not used in synthesis:

```text
candidate document
    ↓
baseline-correct candidate vector
    ↓
compare against full independently generated market target
```

COTI uses this mode.

## 7.2 LEAVE_ONE_OUT

For projects that were part of the source universe:

```text
remove candidate contribution
    ↓
rebuild target without candidate
    ↓
score candidate against that target
```

Ethereum, Uniswap, Cardano, NEAR, and other source projects use this mode.

This prevents self-matching.

---

# 8. Discovery ranking

Using cosine similarity against the independently generated July market target:

| Rank | Project | Discovery mode | Similarity |
|---:|---|---|---:|
| **1** | **COTI** | **UNSEEN_HOLDOUT** | **0.178** |
| 2 | Ethereum | LEAVE_ONE_OUT | 0.163 |
| 3 | Uniswap | LEAVE_ONE_OUT | 0.136 |
| 4 | Arbitrum | UNSEEN_HOLDOUT | 0.115 |
| 5 | Cardano | LEAVE_ONE_OUT | 0.046 |
| 6 | Optimism | UNSEEN_HOLDOUT | 0.045 |
| 7 | NEAR | LEAVE_ONE_OUT | 0.042 |
| 8 | Sei | UNSEEN_HOLDOUT | 0.037 |

COTI therefore ranked **#1** even though it had no influence on synthesis.

---

# 9. Synthetic-document discovery check

A second check compared unseen candidate projects directly with the generated synthetic document.

The strongest result was again COTI.

Approximate pilot similarity:

```text
COTI   0.215
Fuel   0.122
```

COTI remained the closest tested unseen project.

---

# 10. Why the COTI result is meaningful

COTI V2 is broadly compatible with the independently inferred theme:

```text
programmable smart-contract execution
financial applications
asset interaction
composable contract logic
Ethereum-compatible execution
programmable token behavior
```

But the synthetic document did **not** contain COTI's highly distinctive implementation details such as:

```text
garbled circuits
confidential computation
privacy-preserving execution
```

That matters.

If those COTI-specific characteristics had appeared in the synthesis, it would suggest leakage or reverse engineering.

Instead, COTI matched because its broader architecture happened to resemble the market-implied archetype.

---

# 11. Comparison with the previous pilot

## Previous behavior

```text
small universe
    ↓
ETH receives large positive return weight
    ↓
Ethereum vocabulary dominates
    ↓
synthetic document looks like Ethereum
    ↓
Ethereum appears to be closest match
```

## v1.8 behavior

```text
broader universe
    ↓
baseline subtraction
    ↓
signed return weighting
    ↓
multi-project consensus
    ↓
single-project language cap
    ↓
synthetic cross-project archetype
    ↓
independent discovery
    ↓
COTI ranks #1
```

This is much closer to the intended experiment.

---

# 12. Result

The pilot result is:

> **COTI was successfully discovered as the closest tested real project without COTI participating in the synthesis process.**

Ethereum ranked second when evaluated under a leave-one-out target, meaning Ethereum could no longer benefit from matching a semantic target partly created by Ethereum itself.

This suggests that the v1.8 anti-dominance and holdout-discovery corrections address the specific flaw exposed by the earlier pilot.

---

# 13. Important limitation

This remains a **small mechanics pilot using TF-IDF vectors**.

It does not yet prove that COTI would rank first under:

```text
modern dense embeddings
hundreds of crypto projects
full official whitepapers
many historical periods
strict point-in-time project universes
```

The important result is narrower:

> The corrected algorithm can synthesize a market theme without COTI and subsequently identify COTI as the closest tested project.

The next production-grade test should run the exact v1.8 procedure using a pinned dense embedding model over a much broader historical crypto-document universe.

---

# 14. Pilot conclusion

For the specific flaw being tested, v1.8 behaved as intended.

```text
COTI excluded from synthesis
        ↓
market archetype built independently
        ↓
Ethereum prevented from self-matching
        ↓
COTI introduced only during discovery
        ↓
COTI ranks #1
```

That is the desired behavior.
