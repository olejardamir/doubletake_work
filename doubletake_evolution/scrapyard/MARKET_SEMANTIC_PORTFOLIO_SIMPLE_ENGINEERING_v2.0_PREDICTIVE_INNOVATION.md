# Market-Implied Semantic Portfolio (MISP)
## Simple Engineering Specification

**Status:** Predictive checkpoint — market-relative semantic innovation and forward discovery  
**Version:** 2.0-simple  
**Primary goal:** Convert documents/whitepapers to vectors, weight them by period gain/loss, create a market-implied semantic vector, and synthesize a fictional representative document from the resulting signal.

**Checkpoint changes:** v2.0 separates the descriptive problem from the predictive problem.

The v1.9 failure on the February 15–28 → March test exposed a structural error: ranking projects by similarity to the **level** of the current rewarded theme can select projects that merely resemble a theme that has already repriced. Prediction instead requires the **change in market semantic preference**.

v2.0 therefore adds four predictive rules:

1. **Market-relative returns:** remove broad crypto direction with robust cross-sectional excess returns.
2. **Reference vs signal windows:** construct a semantic preference vector for the prior window and the current signal window in the same frozen semantic space.
3. **Semantic innovation:** forecast from the change in those preference vectors, not from the current level alone.
4. **Two-gate discovery:** a candidate must align with both the current preferred direction and the newly emerging direction.

The v1.9 source-only semantic-space freeze, baseline correction, holdout/leave-one-out discovery, and signal-preserving synthesis rules remain mandatory.


# 0. Scope

MISP now has two related but distinct modes.

## 0.1 Descriptive mode

Descriptive mode answers:

> What semantic characteristics did the market reward during this period?

It may use the same-period market-preference vector and synthesize a representative archetype.

## 0.2 Predictive mode

Predictive mode answers:

> Which semantic direction is becoming more rewarded now than in the immediately preceding window, and which real projects already occupy that newly emerging semantic region?

The predictive dependency is:

```text
SOURCE DOCUMENTS
      ↓
FIT / FREEZE SOURCE-ONLY SEMANTIC SPACE
      ↓
BASELINE-CORRECT DOCUMENT VECTORS
      +
REFERENCE-WINDOW RETURNS
      +
SIGNAL-WINDOW RETURNS
      ↓
CROSS-SECTIONAL EXCESS RETURNS
      ↓
REFERENCE SEMANTIC PREFERENCE
      +
SIGNAL SEMANTIC PREFERENCE
      ↓
SEMANTIC INNOVATION
      ↓
FREEZE PREDICTIVE TARGET
      ↓
TRANSFORM DISCOVERY CANDIDATES
      ↓
CURRENT-PREFERENCE ALIGNMENT
      ×
INNOVATION ALIGNMENT
      ↓
FORECAST RANKING
      ↓
ONLY THEN OBSERVE FUTURE RETURNS
```

The predictive target must exist completely before future-period returns are read.

This is a hypothesis-generation / ranking system, not a claim of guaranteed investment performance.

---
# 1. Inputs

For every source asset \(i\):

```text
asset_id
document_id
document_text
document_available_at

reference_start
reference_end
reference_price_start
reference_price_end

signal_start
signal_end
signal_price_start
signal_price_end
```

For descriptive-only runs, a single period is sufficient.

For predictive runs:

```text
reference window immediately precedes signal window
signal window ends before outcome window begins
```

Example:

```text
reference: Feb 1–14
signal:    Feb 15–28
outcome:   Mar 1–31
```

Optional metadata:

```text
document_type
ticker
asset_name
source_url
liquidity_eligibility
```

Every source document must have been publicly available before the predictive signal begins.

Future-period returns are evaluation data only and are not input to target construction.

---
# 2. Convert each document to one vector

Use one pinned embedding model and revision for the complete experiment.

For document \(D_i\):

```text
clean text
    ↓
deterministic chunks
    ↓
embed each chunk
    ↓
normalize chunk vectors
    ↓
pool chunk vectors
    ↓
normalize
    ↓
document vector x_i
```

The resulting document vector is:

\[
x_i \in \mathbb{R}^{d}
\]

with:

\[
\|x_i\|_2 = 1
\]

The exact same document-vector function must also be used later when the synthetic document is re-embedded for validation.

## 2.1 Minimal chunking rule

Always create a deterministic chunk representation, even if the document fits in one embedding call. A short document simply becomes one chunk. This keeps document construction and evidence retrieval consistent.

Initial configuration:

```yaml
target_tokens: 750
overlap_tokens: 75
```

Do not heavily preprocess or summarize the document before embedding.

Remove only obvious extraction noise such as:

- repeated headers and footers;
- page numbers;
- duplicated table-of-contents text;
- broken whitespace.

Preserve the actual wording and meaning.

Every chunk should have a stable `chunk_id` derived from the document ID, chunk boundaries, chunker version, and cleaned-text hash.

## 2.2 Pooling

Let \(e_{ik}\) be a chunk embedding and:

\[
\hat e_{ik}
=
\frac{e_{ik}}{\|e_{ik}\|_2}
\]

Reject non-finite or near-zero chunk vectors.

Use a simple unique-token-length-weighted mean:

\[
v_i =
\frac{\sum_k L_{ik}^{unique} \hat e_{ik}}
{\sum_k L_{ik}^{unique}}
\]

then:

\[
x_i = \frac{v_i}{\|v_i\|_2}
\]

For overlapping chunks, \(L_{ik}^{unique}\) counts only the chunk's newly introduced token span. This prevents overlap from being counted twice.

If the pooled vector is non-finite or near zero, reject the document vector rather than normalizing it.

## 2.3 Freeze the semantic space before discovery

The source universe must fully determine the semantic coordinate system used to build the market target.

For a fixed pretrained embedding model:

```text
pin model
pin revision
do not fine-tune or adapt it using discovery candidates
```

For any vectorizer or transform that learns corpus statistics, including:

```text
TF-IDF
learned vocabulary
PCA
whitening
feature selection
topic basis
corpus normalization statistics
```

the required order is:

```text
source documents
    ↓
FIT semantic transform
    ↓
FREEZE transform
    ↓
construct source vectors + baseline + market target
    ↓
TRANSFORM discovery candidates only
```

A discovery candidate must never affect:

```text
vocabulary
IDF weights
embedding adaptation
dimensionality-reduction basis
normalization statistics
baseline vector
market target
```

Store:

```text
semantic_space_fit_scope = SOURCE_ONLY
semantic_space_fit_asset_ids_hash
semantic_space_version
semantic_space_frozen_at
```

If the embedding model is globally pretrained and no corpus-fitted transformation is used, record:

```text
semantic_space_fit_scope = PRETRAINED_FIXED
```

---

# 3. Calculate robust market-relative returns

For each source asset and each predictive window \(w\in\{R,S\}\):

\[
r_i^w
=
\frac{P_{i,1}^w-P_{i,0}^w}
{P_{i,0}^w}
\]

where:

- \(R\) = reference window;
- \(S\) = signal window.

Raw returns contain broad crypto beta. Predictive MISP should model **relative preference**, not simply whether the entire market rose or fell.

## 3.1 Robust cross-sectional excess return

For each window:

\[
m^w
=
Median_j(r_j^w)
\]

Then:

\[
q_i^w
=
r_i^w-m^w
\]

Interpretation:

> \(q_i^w\) measures whether asset \(i\) outperformed or underperformed the typical source asset during window \(w\).

Using the median makes the signal robust to a few extreme movers.

This creates an important invariance:

> Adding the same market-wide return shift to every asset does not change the semantic preference vector.

## 3.2 Preference weights

For each window:

\[
A^w
=
\sum_i |q_i^w|
\]

\[
p_i^w
=
\frac{q_i^w}{A^w}
\]

when \(A^w\) is safely above zero.

The weights reconstruct each window's market-relative semantic preference exactly.

## 3.3 Innovation weights

Define:

\[
d_i
=
p_i^S-p_i^R
\]

Then:

```text
d_i > 0  → asset semantics became more rewarded
d_i < 0  → asset semantics became less rewarded
```

These are the canonical per-asset predictive contribution weights.

For diagnostics store:

```text
reference_return
signal_return
reference_excess_return
signal_excess_return
reference_preference_weight
signal_preference_weight
innovation_weight
```

Do not use future outcome returns in any of these calculations.

---
# 4. Remove the universe/background semantic baseline

The pilot showed that raw document vectors can be dominated by language common to almost every document in the domain.

For crypto, examples may include:

```text
blockchain
decentralized
transactions
digital assets
smart contracts
network
protocol
```

For equities, analogous generic language may include:

```text
customers
products
services
markets
operations
growth
technology
```

These concepts should not dominate the result merely because they appear in many documents.

## 4.1 Universe semantic baseline

For the \(N\) admissible document vectors in the run:

\[
B =
\frac{1}{N}
\sum_{i=1}^{N} x_i
\]

Do not normalize \(B\) before subtraction.

## 4.2 Baseline-corrected document vector

For each document:

\[
d_i = x_i - B
\]

Then:

\[
z_i = Normalize(d_i)
\]

when the residual norm is safely above zero.

The canonical return-weighted calculation uses \(z_i\), not the original \(x_i\).

Interpretation:

> \(z_i\) represents what is semantically distinctive about document \(i\) relative to the average document in the selected universe.

If \(d_i\) is near zero, exclude the document from the directional calculation with an explicit reason rather than forcing a noisy normalized vector.

## 4.3 Baseline scope

The baseline must be explicit and homogeneous.

For a simple crypto experiment:

```text
baseline universe = all admissible crypto documents in that run
```

For a simple equity experiment:

```text
baseline universe = all admissible company documents in that run
```

Do not mix unrelated asset classes into one baseline.

Store:

```text
baseline_vector_id
baseline_asset_count
baseline_document_ids_hash
baseline_vector_norm
```

The same baseline definition must be used when validating the synthetic document.

---

# 5. Construct semantic preference and innovation vectors

All source document vectors use the same frozen, baseline-corrected vectors \(z_i\).

## 5.1 Reference preference vector

\[
V_R
=
\sum_i p_i^R z_i
\]

When valid:

\[
U_R=Normalize(V_R)
\]

## 5.2 Signal preference vector

\[
V_S
=
\sum_i p_i^S z_i
\]

When valid:

\[
U_S=Normalize(V_S)
\]

Interpretation:

> \(U_S\) represents the semantic characteristics the market currently prefers relative to the source universe.

## 5.3 Predictive semantic innovation vector

The predictive target is the change in market preference:

\[
V_{\Delta}
=
V_S-V_R
\]

Equivalently:

\[
V_{\Delta}
=
\sum_i d_i z_i
\]

where:

\[
d_i=p_i^S-p_i^R
\]

When the norm is sufficient:

\[
U_{\Delta}=Normalize(V_{\Delta})
\]

Interpretation:

> \(U_{\Delta}\) represents the semantic direction that became more rewarded in the signal window than in the immediately preceding reference window.

This is the canonical predictive target.

## 5.4 Why prediction uses innovation rather than level

A theme can have a high current semantic-preference score after already being fully repriced.

Ranking only by \(U_S\) can therefore rediscover obvious same-theme projects without forecasting future propagation.

Prediction requires both:

```text
current relevance
+
new acceleration
```

so v2.0 uses both \(U_S\) and \(U_{\Delta}\).

## 5.5 Abstention

Do not force a forecast when semantic innovation is weak.

Abstain when:

```text
reference excess-return dispersion is near zero
signal excess-return dispersion is near zero
V_delta norm is near zero
too few admissible source assets remain
```

Store:

```text
prediction_status = ACTIVE | ABSTAIN
abstain_reason
innovation_vector_norm
```

---
# 6. Do not attempt to "decode" the vector directly

Embedding vectors are not uniquely invertible into text.

There is no mathematically correct operation:

```text
target embedding → exact original/fake document
```

Instead, use the target vector to identify the real source material most aligned with it, then synthesize a new fictional document from that evidence.

This keeps the result connected to actual document semantics.

---

# 7. Preserve emerging signals without letting one source dominate

The v1.9 concept classes remain:

```text
CONSENSUS
HIGH_ECONOMIC_SIGNAL
PROJECT_SPECIFIC_NOISE
```

For predictive mode, however, `HIGH_ECONOMIC_SIGNAL` is based on **positive semantic innovation contribution**, not simple positive return mass.

## 7.1 Predictive innovation share

Let:

\[
h_i=\max(d_i,0)
\]

and:

\[
H_i
=
\frac{h_i}
{\sum_j h_j}
\]

when the denominator is valid.

`H_i` is the project's share of positive semantic innovation.

This prevents a project from remaining dominant merely because it was already a strong winner in the reference window.

## 7.2 Predictive HIGH_ECONOMIC_SIGNAL gate

A single-source concept may be `HIGH_ECONOMIC_SIGNAL` when:

```text
project_count == 1
innovation_weight > 0
innovation_share >= high_signal_min_innovation_share
innovation_alignment >= high_signal_min_alignment
winner_support > loser_support
baseline_support is sufficiently low
```

Initial frozen defaults:

```yaml
high_signal_min_innovation_share: 0.25
high_signal_min_alignment: 0.10
max_high_signal_concepts: 2
max_high_signal_claim_share: 0.25
```

## 7.3 Consensus

`CONSENSUS` still requires support from at least two independent source projects and must align positively with \(U_{\Delta}\) in predictive mode.

## 7.4 Anti-dominance

A strong innovation contributor may survive concept filtering, but its language remains capped and abstracted.

The predictive governing rule is:

```text
CONSENSUS ON EMERGING DIRECTION
        +
CAPPED HIGH-INNOVATION SIGNAL
        -
PROJECT_SPECIFIC_NOISE
```

---
# 8. Retrieve evidence for the emerging direction

Use source chunks only.

## 8.1 Chunk baseline correction

The source-only chunk baseline remains unchanged.

For source chunk \(k\) of asset \(i\):

\[
c_{ik}=Normalize(\hat e_{ik}-B_{chunk})
\]

## 8.2 Positive emerging evidence

For predictive synthesis, positive evidence comes from assets with:

\[
d_i>0
\]

A simple retrieval score is:

\[
score_{ik}^{emerge}
=
\max(d_i,0)
\cdot
\max(\cos(c_{ik},U_{\Delta}),0)
\]

Normalize positive innovation weights for diagnostics if desired.

## 8.3 Fading-side contrast evidence

Assets with:

\[
d_i<0
\]

provide contrast evidence.

Their concepts represent semantic directions that became less rewarded between the reference and signal windows.

## 8.4 Concept classification

Group evidence into concepts and classify:

```text
CONSENSUS
HIGH_ECONOMIC_SIGNAL
PROJECT_SPECIFIC_NOISE
```

using innovation alignment and innovation share.

The synthetic predictive archetype is generated from:

```text
CONSENSUS
+
capped HIGH_ECONOMIC_SIGNAL
```

not from the current-level vector alone.

---
# 9. Synthesize the predictive archetype

The generator receives:

```text
reference period
signal period
U_signal
U_innovation
CONSENSUS emerging concepts
HIGH_ECONOMIC_SIGNAL emerging concepts
fading-side contrast concepts
generic baseline concepts to avoid
claim-budget limits
```

The predictive synthesis should answer:

> What hypothetical project best expresses the semantic direction that has become more rewarded during the signal window, while still belonging to the market's currently preferred region?

The generator must not simply describe the strongest current winner.

All v1.9 grounding, anti-copy, and claim-budget rules remain in force.

## 9.1 Validation

Re-embed the synthetic archetype with the same frozen source-defined semantic pipeline.

After baseline correction calculate:

\[
F_{level}
=
\cos(z_{synthetic},U_S)
\]

\[
F_{innovation}
=
\cos(z_{synthetic},U_{\Delta})
\]

A valid predictive synthesis should have:

```text
F_level > 0
F_innovation > 0
```

Store both values.

---
# 10. Recommended synthesis format

A compact output is sufficient.

```markdown
# Synthetic Market-Rewarded Document — YYYY-MM

## Core idea
Short description of the hypothetical company/project.

## What it does
Products, services, protocol functions, or business activities represented in the evidence.

## Technology / infrastructure
Recurring technical characteristics represented in the evidence.

## Users / customers
Recurring user or customer categories, when supported.

## Economic model
Recurring business/revenue/token-economic characteristics, when supported.

## Distinguishing characteristics
Characteristics especially associated with gain-side documents relative to loss-side documents.

## Evidence
List of supporting `chunk_id`, `asset_id`, and `document_id` references for the material claims.
```

Do not make the output unnecessarily long.

---

# 11. Minimal contribution table

For each period store:

```text
period
asset_id
document_id
return
gain_weight
loss_weight
market_weight
document_vector_id
baseline_vector_id
residual_vector_id
market_alignment
gain_alignment
loss_alignment
```

Weights are defined as:

\[
gain\_weight_i =
\frac{\max(r_i,0)}{\sum_j\max(r_j,0)}
\]

\[
loss\_weight_i =
\frac{\max(-r_i,0)}{\sum_j\max(-r_j,0)}
\]

\[
market\_weight_i =
\frac{r_i}{\sum_j|r_j|}
\]

where each weight is null when its denominator is zero.

This is enough to answer:

- which documents affected each vector;
- by how much;
- whether they aligned with the final direction;
- whether the stored market, gain, and loss vectors can be reconstructed exactly.

---

# 12. Minimal run manifest

Each predictive run stores:

```yaml
run_id: ...

reference:
  start: ...
  end: ...

signal:
  start: ...
  end: ...

return_method: price_return
cross_sectional_center: median

embedding:
  model: ...
  revision: ...

semantic_space:
  fit_scope: SOURCE_ONLY | PRETRAINED_FIXED
  fit_asset_ids_hash: ...
  version: ...
  frozen_at: ...

baseline:
  method: universe_mean
  version: ...

predictive_target:
  method: semantic_innovation
  reference_preference_version: ...
  signal_preference_version: ...
  innovation_version: ...
  min_innovation_norm: ...

concepts:
  minimum_distinct_supporting_projects: 2
  high_signal_min_innovation_share: 0.25
  high_signal_min_alignment: 0.10
  max_high_signal_concepts: 2
  max_high_signal_claim_share: 0.25

discovery:
  scoring: level_times_innovation
  self_influence_policy: leave_one_out
  universe_version: ...

input_hash: ...
random_seed: 42
```

The manifest must be frozen before future outcome data are evaluated.

---
# 13. Core predictive algorithm

```python
def build_predictive_run(
    reference_period,
    signal_period,
    source_assets,
    discovery_assets,
    cfg,
):
    # 1. Fit/freeze semantic space from source documents only.
    semantic_space = fit_source_only_space(
        source_assets,
        signal_period,
        cfg,
    )
    freeze(semantic_space)

    # 2. Build one baseline-corrected vector z_i per source asset.
    rows, document_baseline = build_source_vectors(
        source_assets,
        semantic_space,
        signal_period,
        cfg,
    )

    # 3. Calculate raw returns in both windows.
    for row in rows:
        row["r_ref"] = period_return(
            row["asset_id"],
            reference_period,
        )
        row["r_sig"] = period_return(
            row["asset_id"],
            signal_period,
        )

    # 4. Remove broad market movement robustly.
    med_ref = median(row["r_ref"] for row in rows)
    med_sig = median(row["r_sig"] for row in rows)

    for row in rows:
        row["q_ref"] = row["r_ref"] - med_ref
        row["q_sig"] = row["r_sig"] - med_sig

    den_ref = sum(abs(row["q_ref"]) for row in rows)
    den_sig = sum(abs(row["q_sig"]) for row in rows)

    if near_zero(den_ref) or near_zero(den_sig):
        return abstain("NO_CROSS_SECTIONAL_DISPERSION")

    # 5. Exact semantic-preference weights.
    for row in rows:
        row["p_ref"] = row["q_ref"] / den_ref
        row["p_sig"] = row["q_sig"] / den_sig
        row["innovation_weight"] = (
            row["p_sig"] - row["p_ref"]
        )

    V_ref = sum(
        row["p_ref"] * row["residual_vector"]
        for row in rows
    )

    V_sig = sum(
        row["p_sig"] * row["residual_vector"]
        for row in rows
    )

    V_delta = V_sig - V_ref

    U_sig = safe_normalize(V_sig)
    U_delta = safe_normalize(V_delta)

    if U_sig is None or U_delta is None:
        return abstain("NO_STABLE_SEMANTIC_INNOVATION")

    # 6. Innovation-share diagnostics.
    positive_innovation = sum(
        max(row["innovation_weight"], 0.0)
        for row in rows
    )

    for row in rows:
        row["innovation_share"] = (
            max(row["innovation_weight"], 0.0)
            / positive_innovation
            if positive_innovation > 0
            else 0.0
        )

    # 7. Build predictive concepts from positive innovation.
    evidence = retrieve_innovation_evidence(
        rows,
        target=U_delta,
        cfg=cfg,
    )

    concepts = classify_predictive_concepts(
        evidence,
        rows,
        cfg,
    )

    synthetic = synthesize_predictive_archetype(
        concepts,
        level_target=U_sig,
        innovation_target=U_delta,
        semantic_space=semantic_space,
        baseline=document_baseline,
        cfg=cfg,
    )

    # 8. Freeze predictive target BEFORE candidate/outcome evaluation.
    freeze(U_sig)
    freeze(U_delta)

    results = []

    for candidate in discovery_assets:
        z = transform_candidate_with_frozen_space(
            candidate,
            semantic_space,
            document_baseline,
            cfg,
        )

        if candidate.asset_id in source_asset_ids(rows):
            level_target, innovation_target = (
                rebuild_leave_one_out_predictive_targets(
                    candidate.asset_id,
                    rows,
                )
            )
            mode = "LEAVE_ONE_OUT"
        else:
            level_target = U_sig
            innovation_target = U_delta
            mode = "UNSEEN_HOLDOUT"

        level_alignment = max(
            cosine(z, level_target),
            0.0,
        )

        innovation_alignment = max(
            cosine(z, innovation_target),
            0.0,
        )

        # Both gates must be positive.
        forecast_score = (
            level_alignment
            * innovation_alignment
        )

        results.append({
            "asset_id": candidate.asset_id,
            "mode": mode,
            "level_alignment": level_alignment,
            "innovation_alignment": innovation_alignment,
            "forecast_score": forecast_score,
        })

    return sort_descending(
        results,
        key="forecast_score",
    )
```

The predictive ranking is therefore:

\[
Score_j
=
\max(\cos(z_j,U_S),0)
\cdot
\max(\cos(z_j,U_{\Delta}),0)
\]

This deliberately requires both:

```text
the candidate fits what the market currently prefers
AND
the candidate fits what is newly becoming more preferred
```

---
# 14. Important edge cases

## No cross-sectional dispersion

If all source assets move similarly, the market-relative signal is undefined or weak.

Return:

```text
prediction_status = ABSTAIN
reason = NO_CROSS_SECTIONAL_DISPERSION
```

## No semantic innovation

If:

\[
\|V_{\Delta}\|
\]

is near zero, the semantic preference did not materially change.

Return:

```text
prediction_status = ABSTAIN
reason = NO_STABLE_SEMANTIC_INNOVATION
```

## Candidate aligns with level but not innovation

Do not rank it highly.

This is exactly the failure mode v2.0 is designed to prevent.

## Candidate aligns with innovation but not current preference

Do not rank it highly either.

The emerging theme must still sit inside the currently rewarded semantic region.

## Broad market crash or rally

A uniform market-wide shift is removed by median-centering and should not materially change the predictive target.

## Future data

Any access to future-period returns before the ranking is frozen invalidates the predictive run.

---
# 15. Minimal diagnostics

Store:

```text
source_asset_count

reference_return_median
signal_return_median

reference_excess_return_dispersion
signal_excess_return_dispersion

reference_preference_vector_norm
signal_preference_vector_norm
innovation_vector_norm

top_positive_innovation_contributors
top_negative_innovation_contributors

candidate_level_alignment
candidate_innovation_alignment
candidate_forecast_score

prediction_status
abstain_reason
```

For predictive evaluation also store, only after the ranking is frozen:

```text
future_return
future_return_rank
```

---
# 16. Minimal tests

## Source-only semantic-space fit

Discovery candidates must not alter source vectors, fitted vocabulary/statistics, baseline, reference preference, signal preference, or semantic innovation.

## Market-shift invariance

If the same constant \(c\) is added to every source return in a window:

\[
r_i^w \rightarrow r_i^w+c
\]

then:

\[
q_i^w
\]

and the semantic preference vector must remain unchanged.

## Stationary-preference abstention

If:

\[
p_i^S=p_i^R
\]

for every source asset, then:

\[
V_{\Delta}=0
\]

and predictive mode must abstain.

## Exact innovation reconstruction

Stored innovation weights must satisfy:

\[
V_{\Delta}
=
\sum_i d_i z_i
\]

within numerical tolerance.

## Level-only false positive

A candidate with high level alignment but non-positive innovation alignment must receive forecast score zero.

## Innovation-only false positive

A candidate with high innovation alignment but non-positive level alignment must receive forecast score zero.

## Self-influence prevention

A source-universe candidate must use leave-one-out reference, signal, and innovation targets.

## Holdout discovery

An unseen project must be able to rank first without contributing to either window's target.

## Future leakage

Changing future outcome returns must not change any predictive ranking.

## Concept preservation

Strong positive innovation themes may survive as `HIGH_ECONOMIC_SIGNAL`; themes that were already strong but are decelerating must not qualify merely because their current return remains positive.

---
# 17. Suggested repository

```text
misp/
├── config.yaml
├── src/
│   ├── documents.py
│   ├── embeddings.py
│   ├── returns.py
│   ├── vectors.py
│   ├── retrieval.py
│   ├── synthesis.py
│   └── pipeline.py
├── tests/
│   ├── test_vectors.py
│   ├── test_returns.py
│   ├── test_time_boundary.py
│   └── test_synthesis_grounding.py
└── outputs/
    └── YYYY-MM/
        ├── contributions.parquet
        ├── vectors.npz
        ├── evidence.json
        ├── synthetic_document.md
        └── manifest.json
```

No distributed system, factor engine, cluster engine, vector database, or complex API is required for the initial implementation.

---

# 18. Independent real-project discovery

After the synthetic market archetype exists, search for the real project most similar to it.

This is a separate stage from synthesis.

## 18.1 Discovery candidate universe

The discovery universe may be much wider than the synthesis universe.

It can include:

```text
projects omitted from the source universe
newer projects
smaller projects
projects from external databases
projects that lacked period price data
projects intentionally held out for evaluation
```

Every candidate still requires a usable official/founding document vector.

## 18.2 Candidate scoring

For candidate \(j\):

```text
if candidate j contributed to the source universe:
    compare j to leave-one-out target U_market^(-j)
else:
    compare j to full target U_market
```

Base score:

\[
DiscoveryScore_j
=
\cos(z_j,U_{target,j})
\]

where \(U_{target,j}\) is either the full target or the candidate-specific leave-one-out target.

Optional diagnostics may include:

```text
similarity_to_gain_direction
similarity_to_loss_direction
concept_overlap_count
consensus_concept_coverage
```

Do not use the candidate's return during the target period to boost its discovery score. The discovery question is semantic:

> Which real project most resembles the independently inferred market archetype?

## 18.3 Final matched project

Return:

```text
rank
project_id
project_name
discovery_mode
semantic_similarity
consensus_concepts_matched[]
missing_consensus_concepts[]
extra_project_specific_concepts[]
```

The top project is the discovered analogue.

Crucially:

> A project should be able to rank first even when it was completely excluded from synthesis.

That is the desired test for a COTI-like discovery.

## 18.4 Holdout evaluation

For validation, deliberately hide known projects.

Example:

```text
1. remove candidate COTI from the synthesis universe;
2. build the archetype without COTI;
3. include COTI only in the discovery universe;
4. rank all discovery candidates;
5. observe whether COTI emerges near the top.
```

This is a legitimate evaluation protocol because the holdout is defined **before** synthesis and COTI contributes no document text, vector, return, baseline weight, or evidence to the archetype.

Do not hand-edit the synthetic document to make the holdout candidate rank higher.

---

# 19. Implementation sequence

## Step 1
Freeze the source universe and document corpus.

## Step 2
Fit/freeze the source-only semantic space and source baseline.

## Step 3
Choose adjacent reference and signal windows of the same intended cadence.

## Step 4
Calculate source returns in both windows.

## Step 5
Median-center returns cross-sectionally in each window.

## Step 6
Build reference and signal semantic-preference vectors.

## Step 7
Subtract them to obtain the semantic-innovation vector.

## Step 8
Classify emerging concepts using innovation weights, not raw positive-return mass.

## Step 9
Synthesize and validate the predictive archetype against both current preference and innovation.

## Step 10
Freeze both predictive targets.

## Step 11
Transform discovery candidates only after the targets are frozen.

## Step 12
Rank by:

```text
positive current-preference alignment
×
positive innovation alignment
```

## Step 13
Only after ranking is frozen, read future-period returns and evaluate performance.

---
# 20. What not to build yet

Do **not** block the experiment on:

- market-cap weighting;
- sector neutralization;
- factor models;
- regressions;
- clustering;
- portfolio optimization;
- prediction;
- causal inference;
- complex corporate-action handling;
- distributed compute;
- a vector database;
- a dashboard;
- an API;
- real-time processing;
- autonomous trading.

Those can be added only if the simple experiment produces something useful.

---

# 21. Definition of done

Predictive v2.0 is implemented when the system can:

1. fit/freeze a source-only semantic space;
2. create baseline-corrected source vectors;
3. calculate returns for adjacent reference and signal windows;
4. remove broad market movement with robust cross-sectional centering;
5. construct reference and signal semantic-preference vectors;
6. construct an exact semantic-innovation vector from their difference;
7. identify concepts whose semantic contribution is accelerating rather than merely high;
8. synthesize a predictive archetype without copying one source project;
9. freeze current-preference and innovation targets before discovery;
10. transform discovery candidates only afterward;
11. score each candidate using both level and innovation alignment;
12. use leave-one-out targets for any source-universe candidate;
13. abstain when no stable predictive innovation exists;
14. freeze the ranking before any future-period return is observed;
15. reproduce the same ranking from the same pre-outcome inputs.

---
# 22. Canonical interpretation

The primary output should be described as:

> **A market-relative semantic innovation signal that identifies what is becoming more rewarded now than in the immediately preceding window, then ranks independent projects that align with both the current preferred region and that emerging direction.**

A shorter user-facing description can be:

> **What a hypothetical market-rewarded project/company would look like after stripping away the generic language shared by the rest of the market.**

Avoid presenting it as proof of what investors literally intended to buy.

---

# 23. Final engineering rule

For description:

```text
what is rewarded now?
```

Use the current semantic-preference vector.

For prediction:

```text
what is becoming more rewarded now?
```

Use semantic innovation.

Canonical predictive pipeline:

```text
SOURCE-ONLY FROZEN SEMANTIC SPACE
        ↓
BASELINE-CORRECT SOURCE VECTORS
        ↓
REFERENCE RETURNS → MEDIAN-CENTER → PREFERENCE VECTOR
        +
SIGNAL RETURNS    → MEDIAN-CENTER → PREFERENCE VECTOR
        ↓
SEMANTIC INNOVATION = SIGNAL - REFERENCE
        ↓
FREEZE TARGETS
        ↓
DISCOVERY CANDIDATES
        ↓
CURRENT-PREFERENCE ALIGNMENT
        ×
INNOVATION ALIGNMENT
        ↓
FORECAST RANKING
        ↓
FUTURE RETURN EVALUATION
```

Do not rank a project highly merely because it resembles a theme that was already rewarded.

The predictive object is **semantic acceleration**, not semantic resemblance alone.
