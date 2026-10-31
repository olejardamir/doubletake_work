# Market-Implied Semantic Portfolio (MISP)
## Simple Engineering Specification

**Status:** Focused implementation checkpoint — source-frozen semantic space and signal-preserving synthesis pass  
**Version:** 1.9-simple  
**Primary goal:** Convert documents/whitepapers to vectors, weight them by period gain/loss, create a market-implied semantic vector, and synthesize a fictional representative document from the resulting signal.

**Checkpoint changes:** preserves the v1.8 baseline correction, holdout discovery, and anti-self-influence rules, while fixing two flaws exposed by later pilots.

1. **Discovery-space leakage:** any corpus-fitted semantic transform (for example TF-IDF, PCA, whitening, learned vocabulary, or other corpus statistics) must be fit on the source universe only and frozen before discovery candidates are transformed. Discovery candidates must never alter the semantic space, baseline, or target they are scored against.
2. **Over-aggressive consensus filtering:** a strong market theme must not be deleted merely because only one source winner expresses it. Concepts are now classified as `CONSENSUS`, `HIGH_ECONOMIC_SIGNAL`, or `PROJECT_SPECIFIC_NOISE`. Strong single-source concepts may enter the synthetic archetype in a capped, abstracted form when they carry exceptional return-weighted contribution and are aligned with the market target.

The objective remains unchanged: infer a market semantic direction from source-period documents and returns, synthesize it without letting one project dictate the language, and independently discover real projects that resemble the inferred direction.


# 0. Scope

This version intentionally removes most of the broader architecture from earlier drafts.

The core experiment is:

```text
document / whitepaper
        ↓
embedding vector
        ↓
subtract universe/background semantic baseline
        ↓
baseline-corrected document vector
        +
period gain/loss %
        ↓
signed return-weighted market vector
        ↓
retrieve distinctive winner evidence
        ↓
classify concepts:
CONSENSUS
+
HIGH_ECONOMIC_SIGNAL
-
PROJECT_SPECIFIC_NOISE
        -
generic universe evidence
        -
loser-side evidence
        ↓
synthesize a fictional representative document / whitepaper
        ↓
re-embed + baseline-correct
        ↓
verify semantic similarity to the target vector
```

The central question is:

> After removing semantic characteristics common across the whole universe, which document characteristics are associated with gains rather than losses during the period, and what fictional document best represents that distinctive market-implied direction?

This is a descriptive semantic experiment. It does **not** claim to measure literal investor intent, capital flows, or causality.

A separate **discovery stage** is mandatory. The project eventually identified as the closest real-world match must not be allowed to manufacture its own match by contributing to the target used to score it.


---

# 1. Inputs

For every asset \(i\), the minimum required inputs are:

```text
asset_id
document_id
document_text
document_available_at
period_start
period_end
price_start
price_end
```

Optional:

```text
total_return
document_type
ticker
asset_name
source_url
```

For equities, the document can be a company business description, annual filing business section, or another fixed company-description source.

For crypto, the document can be a whitepaper or official project documentation.

The document used for a period must have been publicly available by `period_start`.

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

# 3. Calculate gain/loss for the period

For each asset:

\[
r_i =
\frac{P_{i,1}-P_{i,0}}
{P_{i,0}}
\]

where:

- \(P_{i,0}\) = price at the beginning of the period;
- \(P_{i,1}\) = price at the end of the period.

Example:

```text
Asset A: +20%  → r =  0.20
Asset B: +5%   → r =  0.05
Asset C: -10%  → r = -0.10
```

If reliable total-return data are available, total return may be used instead of price return, but one definition must be used consistently within an experiment.

The basic system weights by **percentage return only**.

Before calculating a return, require:

```text
price_start > 0
price_end >= 0
both prices finite
same return convention for every asset in the run
```

For simple price returns, reject values below `-1.0`; they indicate invalid data under this convention.

It does not require market capitalization, trading volume, sector adjustment, factor models, or portfolio holdings.

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

# 5. Construct the market-implied semantic vectors

The implementation produces one **canonical baseline-corrected target vector** and two supporting side vectors.

All calculations use the baseline-corrected normalized document vectors \(z_i\).

## 5.1 Canonical market-implied vector

Use signed percentage returns:

\[
V_{market}
=
\frac{\sum_i r_i z_i}
{\sum_i |r_i|}
\]

When its norm is safely above zero:

\[
U_{market}=Normalize(V_{market})
\]

Positive returns pull the target toward an asset's distinctive document semantics. Negative returns push it away.

Interpretation:

> A signed semantic direction representing characteristics that are distinctive relative to the universe baseline and associated with gains rather than losses during the selected period.

This is the default target for the fictional synthesized document.

If \(V_{market}\) is near zero because positive and negative semantic effects cancel, `U_market` is undefined. The system may still report gain and loss centroids, but it must not invent a strong unified direction.

## 5.2 Gain vector

\[
g_i = \max(r_i,0)
\]

\[
V_{gain}
=
\frac{\sum_i g_i z_i}
{\sum_i g_i}
\]

\[
U_{gain}=Normalize(V_{gain})
\]

Interpretation:

> The distinctive semantic center of winner documents after common universe language has been removed.

## 5.3 Loss vector

\[
l_i = \max(-r_i,0)
\]

\[
V_{loss}
=
\frac{\sum_i l_i z_i}
{\sum_i l_i}
\]

\[
U_{loss}=Normalize(V_{loss})
\]

Interpretation:

> The distinctive semantic center of loser documents after common universe language has been removed.

Gain and loss vectors explain the signed target; they are not competing definitions of it.

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

# 7. Prevent self-influence without deleting real market signals

Baseline subtraction removes generic domain language, but two different biases remain:

```text
1. a candidate can resemble the target because it helped create the target;
2. one large winner can dominate the wording of the synthetic document.
```

v1.8 solved the second problem too aggressively by requiring every core concept to have multi-project support. That can erase a genuine emerging theme when one source project reprices first and a semantically related unseen project reprices later.

v1.9 therefore separates **economic influence** from **linguistic dominance**.

## 7.1 Broad source universe

Define the source universe before observing the semantic result. The exact eligibility rule is versioned and frozen before scoring.

## 7.2 Candidate holdout rule

A project may not be scored against a target that contains its own contribution.

For candidate project \(j\):

\[
V_{market}^{(-j)}
=
\frac{\sum_{i \ne j} r_i z_i}
{\sum_{i \ne j} |r_i|}
\]

\[
U_{market}^{(-j)}
=
Normalize(V_{market}^{(-j)})
\]

Use:

```text
UNSEEN_HOLDOUT
```

when the candidate never contributed to the source universe, and:

```text
LEAVE_ONE_OUT
```

when it did.

## 7.3 Economic contribution share

For every positive-return source project \(i\):

\[
E_i
=
\frac{\max(r_i,0)}
{\sum_j \max(r_j,0)}
\]

Store both:

```text
economic_contribution_share
synthesis_evidence_share
```

A project may legitimately dominate the economic signal without being allowed to dominate the prose.

## 7.4 Three concept classes

Every candidate concept is classified as exactly one of:

```text
CONSENSUS
HIGH_ECONOMIC_SIGNAL
PROJECT_SPECIFIC_NOISE
```

### CONSENSUS

A concept is `CONSENSUS` when it is independently supported by multiple winners.

Initial rule:

```yaml
minimum_distinct_supporting_projects: 2
preferred_distinct_supporting_projects: 3
```

It must also have positive market alignment, stronger winner than loser support, and remain distinctive relative to the baseline.

### HIGH_ECONOMIC_SIGNAL

A single-source concept may survive only when all of the following hold:

```text
project_count == 1
source_project_return > 0
economic_contribution_share >= high_signal_min_gain_share
market_alignment >= high_signal_min_alignment
winner_support > loser_support
baseline_support is low enough to remain distinctive
```

Initial frozen defaults:

```yaml
high_signal_min_gain_share: 0.25
high_signal_min_alignment: 0.10
max_high_signal_concepts: 2
max_high_signal_claim_share: 0.25
```

These are implementation defaults, not empirical truths. They must not be retuned month-by-month.

### PROJECT_SPECIFIC_NOISE

Everything else is `PROJECT_SPECIFIC_NOISE` for the core archetype, including:

```text
weak single-source concepts
low-alignment concepts
generic concepts
branding language
concepts equally strong among losers
```

## 7.5 Anti-dominance caps

Initial limits:

```yaml
max_consensus_evidence_share_per_project: 0.35
max_high_signal_claim_share: 0.25
max_high_signal_concepts: 2
```

A strong single-source theme may therefore survive, but it can account for only a minority of the synthesized material claims.

## 7.6 Abstract, do not copy

A `HIGH_ECONOMIC_SIGNAL` concept must be expressed as a cross-project semantic abstraction, not copied from the source project's wording.

Example:

```text
source-specific:
"agent passport with programmable service permissions"

acceptable abstraction:
"machine-oriented identity and permission infrastructure"
```

## 7.7 Concept record

Store:

```text
concept_id
concept_class
supporting_project_ids[]
supporting_chunk_ids[]
winner_support
loser_support
baseline_support
market_alignment
project_count
largest_single_project_share
source_project_economic_share
claim_budget_share
```

The governing rule is:

```text
CONSENSUS
    +
capped HIGH_ECONOMIC_SIGNAL
    -
PROJECT_SPECIFIC_NOISE
```

---

# 8. Retrieve distinctive evidence and classify concepts

The retrieval goal is to find source passages supporting the baseline-corrected market direction while distinguishing winners from both the universe baseline and the loser side.

## 8.1 Source-only chunk baseline

Let \(\hat e_{ik}\) be a normalized source chunk embedding.

\[
B_{chunk}
=
\frac{1}{M}
\sum_{i,k}\hat e_{ik}
\]

Then:

\[
c_{ik}
=
Normalize(\hat e_{ik}-B_{chunk})
\]

Discovery-candidate chunks never participate in \(B_{chunk}\).

## 8.2 Positive supporting evidence

For winner \(i\):

\[
w_i^{gain}
=
\frac{\max(r_i,0)}
{\sum_j\max(r_j,0)}
\]

\[
score_{ik}^{support}
=
w_i^{gain}
\cdot
\max(\cos(c_{ik},U_{market}),0)
\]

Each retained item stores:

```text
chunk_id
asset_id
document_id
return
gain_weight
economic_contribution_share
target_similarity
retrieval_score
text
```

## 8.3 Loss-side contrast evidence

For loser chunks:

\[
score_{ik}^{loss}
=
w_i^{loss}
\cdot
\max(\cos(c_{ik},U_{loss}),0)
\]

Loss passages are contrast evidence only.

## 8.4 Concept formation and classification

Group semantically related winner passages into candidate concepts.

For each concept store:

```text
supporting_project_count
winner_support
loser_support
baseline_support
market_alignment
largest_single_project_share
source_project_economic_share
```

Then classify it as:

```text
CONSENSUS
HIGH_ECONOMIC_SIGNAL
PROJECT_SPECIFIC_NOISE
```

The prose generator receives all eligible `CONSENSUS` concepts plus at most `max_high_signal_concepts` eligible `HIGH_ECONOMIC_SIGNAL` concepts.

`PROJECT_SPECIFIC_NOISE` is retained only for diagnostics and as an avoid list.

## 8.5 Distinctiveness gate

A characteristic may appear in the synthetic document only when it is:

1. supported by winner-side evidence;
2. aligned with the baseline-corrected target;
3. not merely generic across the universe;
4. not equally or more strongly represented among losers;
5. classified as `CONSENSUS` or `HIGH_ECONOMIC_SIGNAL`.

---

# 9. Synthesize the fictional document

The generator receives:

```text
period
canonical baseline-corrected market target
CONSENSUS concepts
HIGH_ECONOMIC_SIGNAL concepts
winner-side evidence
loser-side contrast evidence
generic baseline concepts to avoid
PROJECT_SPECIFIC_NOISE concepts to avoid
claim-budget limits
```

The synthesis should answer:

> What hypothetical project/company best expresses the market-implied semantic direction while separating broadly supported themes from strong but still unconfirmed single-source themes?

## 9.1 Claim budget

Material claims are divided into:

```text
CONSENSUS claims
HIGH_ECONOMIC_SIGNAL claims
```

Initial rule:

```yaml
max_high_signal_claim_share: 0.25
```

If consensus evidence is sparse, produce a shorter document rather than padding it with generic prose.

## 9.2 High-signal language rule

A `HIGH_ECONOMIC_SIGNAL` concept must:

- be phrased abstractly;
- avoid branded/source-specific wording;
- cite its supporting source internally;
- remain within the claim budget;
- never be described as multi-project consensus.

## 9.3 Grounding

Every material characteristic must reference supporting winner-side evidence.

A `CONSENSUS` claim must reference at least two independent source projects.

A `HIGH_ECONOMIC_SIGNAL` claim may reference one source project only because it passed the strict Section 7 high-signal gate.

The generator must not invent unsupported revenue, customers, market share, token price, valuation, geography, partnerships, technologies, or performance claims.

## 9.4 Anti-copy rule

Preserve the semantic direction, not the source winner's phrasing.

---

## 9.5 Re-embed and verify

Vectorize the synthetic document with the same **frozen source-defined semantic pipeline**.

Subtract the same source-universe baseline:

\[
d_{synthetic}=x_{synthetic}-B
\]

\[
z_{synthetic}=Normalize(d_{synthetic})
\]

Calculate:

\[
F_{target}=\cos(z_{synthetic},U_{market})
\]

and, where available:

\[
F_{gain}=\cos(z_{synthetic},U_{gain})
\]

\[
F_{loss}=\cos(z_{synthetic},U_{loss})
\]

Store:

```text
synthetic_target_fidelity
synthetic_gain_similarity
synthetic_loss_similarity
synthetic_contrast_margin
consensus_claim_count
high_signal_claim_count
high_signal_claim_share
```

Reject candidates that exceed the high-signal claim budget, fail grounding, rely mainly on generic baseline concepts, closely paraphrase one source project, or align more strongly with the loss side.

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

Each run stores:

```yaml
run_id: ...
period_start: ...
period_end: ...

return_method: price_return

embedding:
  model: ...
  revision: ...

semantic_space:
  fit_scope: SOURCE_ONLY | PRETRAINED_FIXED
  fit_asset_ids_hash: ...
  version: ...
  frozen_at: ...

text:
  cleaner_version: ...
  chunker_version: ...
  pooling_version: ...
  normalization_version: ...

baseline:
  method: universe_mean
  document_baseline_version: ...
  chunk_baseline_version: ...

concepts:
  minimum_distinct_supporting_projects: 2
  preferred_distinct_supporting_projects: 3
  high_signal_min_gain_share: 0.25
  high_signal_min_alignment: 0.10
  max_high_signal_concepts: 2
  max_high_signal_claim_share: 0.25
  max_consensus_evidence_share_per_project: 0.35

discovery:
  self_influence_policy: leave_one_out
  discovery_universe_version: ...
  scoring_version: ...

synthesis:
  model: ...
  model_revision: ...
  prompt_version: ...
  max_candidates: 3

input_hash: ...
random_seed: 42
```

`input_hash` must cover the ordered source asset IDs, source document hashes, period boundaries, return inputs, and semantic-space configuration.

Discovery candidates must not participate in source-side fitting or baseline construction.

---

# 13. Core algorithm

```python
def build_period(period, source_assets, discovery_assets, cfg):

    # 1. Fit/load semantic space from SOURCE ONLY.
    source_texts = admissible_source_texts(
        source_assets,
        period,
    )

    semantic_space = fit_or_load_semantic_space(
        source_texts,
        cfg.embedding,
        fit_scope="SOURCE_ONLY",
    )
    freeze(semantic_space)

    # 2. Transform source documents.
    rows = vectorize_source_assets(
        source_assets,
        period,
        semantic_space,
        cfg,
    )

    # 3. Build SOURCE-ONLY baselines.
    document_baseline = mean_vector(
        [row["vector"] for row in rows]
    )

    chunk_baseline = mean_vector([
        v
        for row in rows
        for v in row["chunk_vectors"]
    ])

    rows = baseline_correct_rows(
        rows,
        document_baseline,
        chunk_baseline,
    )

    # 4. Build return-weighted target.
    market_direction, gain_direction, loss_direction = (
        build_return_weighted_directions(rows)
    )

    gain_den = sum(
        max(row["return"], 0.0)
        for row in rows
    )

    for row in rows:
        row["economic_contribution_share"] = (
            max(row["return"], 0.0) / gain_den
            if gain_den > 0
            else 0.0
        )

    # 5. Retrieve evidence and form concepts.
    winner_evidence = retrieve_winner_evidence(
        rows,
        market_direction,
        loss_direction,
        chunk_baseline,
        cfg,
    )

    loss_evidence = retrieve_loss_evidence(
        rows,
        loss_direction,
        chunk_baseline,
        cfg,
    )

    concepts = cluster_evidence_into_concepts(
        winner_evidence,
        loss_evidence,
        rows,
        cfg,
    )

    classified = classify_concepts(
        concepts,
        consensus_min_projects=(
            cfg.concepts.minimum_distinct_supporting_projects
        ),
        high_signal_min_gain_share=(
            cfg.concepts.high_signal_min_gain_share
        ),
        high_signal_min_alignment=(
            cfg.concepts.high_signal_min_alignment
        ),
    )

    synthesis_concepts = select_synthesis_concepts(
        classified,
        max_high_signal_concepts=(
            cfg.concepts.max_high_signal_concepts
        ),
        max_high_signal_claim_share=(
            cfg.concepts.max_high_signal_claim_share
        ),
    )

    # 6. Generate and validate synthetic archetype.
    synthetic = synthesize_and_validate(
        period=period,
        semantic_space=semantic_space,
        document_baseline=document_baseline,
        target=market_direction,
        gain_direction=gain_direction,
        loss_direction=loss_direction,
        concepts=synthesis_concepts,
        evidence=winner_evidence,
        cfg=cfg,
    )

    # 7. Only now transform discovery candidates.
    results = []

    for candidate in discovery_assets:
        candidate_vector = vectorize_with_frozen_space(
            candidate.document_text,
            semantic_space,
            cfg,
        )

        if candidate.asset_id in {
            row["asset_id"] for row in rows
        }:
            target = rebuild_leave_one_out_target(
                candidate.asset_id,
                rows,
            )
            mode = "LEAVE_ONE_OUT"
        else:
            target = market_direction
            mode = "UNSEEN_HOLDOUT"

        residual = safe_normalize(
            candidate_vector - document_baseline
        )

        if residual is None or target is None:
            continue

        results.append({
            "asset_id": candidate.asset_id,
            "mode": mode,
            "score": cosine(residual, target),
        })

    return sort_descending(results, key="score")
```

The critical dependency is:

```text
SOURCE ONLY
    ↓
fit/freeze semantic space
    ↓
build baseline + market target
    ↓
classify CONSENSUS + HIGH_ECONOMIC_SIGNAL
    ↓
synthesize
    ↓
freeze target
    ↓
transform discovery candidates
    ↓
rank
```

Discovery candidates never participate upstream.

---

# 14. Important edge cases

Keep the rules simple.

## No winners

If:

\[
\sum_i \max(r_i,0)=0
\]

then no gain document is generated for that period.

## No losers

If:

\[
\sum_i \max(-r_i,0)=0
\]

then the loss vector is absent.

## Near-zero document residual

If a document vector is almost identical to the universe baseline, its residual direction is undefined.

Exclude it from the directional calculation and record:

```text
reason = NON_DISTINCTIVE_DOCUMENT
```

## Near-zero market vector

If positive and negative semantic effects cancel and:

\[
\|V_{market}\|
\]

is near zero, do not normalize it.

Report the canonical market direction as undefined. A gain-side fallback may still be used for synthesis, but it must be labeled `GAIN_FALLBACK`.

## Missing document

Exclude the asset from semantic aggregation and report it as missing.

## Missing or invalid price

Exclude the asset for that period and record the reason.

## No grounded synthetic candidate

If every generated candidate fails evidence grounding, publish the quantitative vectors and evidence but no synthetic document.

Do not select an unsupported candidate merely because its embedding is close to the target.

## Extreme return

Do not silently cap it in the canonical calculation.

Report the largest return-weight share so the user can see when one asset dominates the result.

A capped or transformed-return version can later be added as a separate robustness experiment.

---

# 15. Minimal diagnostics

For each period report only:

```text
asset_count
gain_asset_count
loss_asset_count
baseline_asset_count
largest_gain_weight
largest_loss_weight
largest_absolute_market_weight
gain_vector_norm_before_normalization
loss_vector_norm_before_normalization
baseline_vector_norm
market_vector_norm_before_normalization
gain_vs_loss_cosine
synthetic_target_fidelity
synthetic_loss_similarity
synthetic_contrast_margin
```

Also list the top 10 gain contributors and top 10 loss contributors.

This is enough to reveal obvious domination or semantic cancellation without turning the experiment into a large quantitative platform.

---

# 16. Minimal tests

The implementation is acceptable when these tests pass.

## Determinism

Same source documents, prices, semantic-space definition, model revision, and configuration produce the same quantitative outputs.

## Source-only semantic-space fit

Adding, removing, or changing an unseen discovery candidate must not change:

```text
source vectors
semantic-space fit statistics
baseline
market vector
gain vector
loss vector
synthetic target
```

For TF-IDF specifically, discovery text must not change vocabulary or IDF weights.

## Baseline subtraction

If every source document vector is identical, every baseline-corrected residual is zero/undefined and no market direction is produced.

## Self-influence prevention

A candidate that contributed to the source universe must be scored against a leave-one-out target.

## Holdout discovery

A project excluded from synthesis must still be able to rank first during discovery.

## Consensus preservation

A qualifying multi-project concept must remain eligible as `CONSENSUS`.

## High-economic-signal preservation

A qualifying strong single-source concept must remain eligible as `HIGH_ECONOMIC_SIGNAL` rather than being automatically discarded.

## Weak single-source rejection

A single-source concept that fails the high-signal gates must remain `PROJECT_SPECIFIC_NOISE`.

## High-signal claim cap

The synthetic document must not exceed `max_high_signal_claim_share`.

## Anti-copy

A high-signal concept may survive semantically, but its generated wording must not closely reproduce the source project's branded or source-specific wording.

## Generic-trait suppression

A concept common to winners, losers, and the universe baseline must not dominate synthesis.

## Return weighting

For identical residual vectors, a +20% asset receives twice the gain weight of a +10% asset.

## Gain/loss separation

Negative-return assets contribute nothing to `gain_vector`; positive-return assets contribute nothing to `loss_vector`.

## Future-document rejection

A document published after the signal period begins cannot be used for that period.

## Synthetic re-embedding

The synthetic document must be re-embedded with the same frozen source-defined semantic pipeline.

## Predictive freeze

When evaluating future-period performance, the complete ranking must be frozen before future returns are read.

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
Define the source universe before observing the semantic result.

## Step 2
Fit or load the semantic space from **source documents only**, then freeze it.

## Step 3
Transform source documents and calculate the source-only semantic baseline.

## Step 4
Calculate signal-period gain/loss percentages.

## Step 5
Build the baseline-corrected market, gain, and loss directions.

## Step 6
Retrieve source evidence and form candidate concepts.

## Step 7
Classify concepts as:

```text
CONSENSUS
HIGH_ECONOMIC_SIGNAL
PROJECT_SPECIFIC_NOISE
```

using frozen thresholds.

## Step 8
Generate the archetype from:

```text
CONSENSUS
+
capped HIGH_ECONOMIC_SIGNAL
```

and exclude `PROJECT_SPECIFIC_NOISE`.

## Step 9
Re-embed and validate the archetype in the same frozen source-defined space.

## Step 10
Freeze the target and only then transform discovery candidates.

## Step 11
Use the full target for unseen holdouts and leave-one-out targets for source-universe candidates.

## Step 12
Rank projects by semantic similarity.

## Step 13
For predictive evaluation, freeze the ranking at the end of signal period \(t\), then inspect returns only in future period \(t+1\).

Future returns must never alter source selection, semantic-space fitting, thresholds, baseline, concept classes, synthesis, discovery universe, or ranking.

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

The first working version is complete when, for any chosen signal period, the system can:

1. construct a rule-defined source universe;
2. fit/load a semantic space using source information only;
3. freeze the semantic space before discovery;
4. produce reproducible source document vectors;
5. calculate the source-universe baseline;
6. calculate source-period returns;
7. produce the signed baseline-corrected market vector;
8. extract winner and loser evidence;
9. classify concepts as `CONSENSUS`, `HIGH_ECONOMIC_SIGNAL`, or `PROJECT_SPECIFIC_NOISE`;
10. preserve strong single-source economic themes without letting one source dominate the prose;
11. generate a grounded fictional archetype;
12. re-embed and validate that archetype in the same frozen source space;
13. transform discovery candidates only after the target is frozen;
14. prevent candidate self-influence through unseen-holdout or leave-one-out scoring;
15. freeze rankings before future-period predictive outcomes are inspected;
16. reproduce the same outputs from the same source inputs and configuration.

---

# 22. Canonical interpretation

The primary output should be described as:

> **A baseline-corrected market semantic archetype that combines multi-project consensus with capped high-economic-signal themes, then independently matches real projects in a semantic space frozen before discovery.**

A shorter user-facing description can be:

> **What a hypothetical market-rewarded project/company would look like after stripping away the generic language shared by the rest of the market.**

Avoid presenting it as proof of what investors literally intended to buy.

---

# 23. Final engineering rule

Keep the dependency simple and one-way:

```text
SOURCE UNIVERSE
      ↓
FIT / FREEZE SEMANTIC SPACE
      ↓
SOURCE DOCUMENT VECTORS
      ↓
SUBTRACT SOURCE-UNIVERSE BASELINE
      +
SIGNAL-PERIOD GAIN / LOSS %
      ↓
SIGNED DISTINCTIVE MARKET VECTOR
      ↓
EVIDENCE + CONCEPT CLASSIFICATION
      ↓
CONSENSUS
      +
CAPPED HIGH_ECONOMIC_SIGNAL
      -
PROJECT_SPECIFIC_NOISE
      ↓
FICTIONAL REPRESENTATIVE DOCUMENT
      ↓
RE-EMBED + VALIDATE
      ↓
FREEZE TARGET
      ↓
TRANSFORM INDEPENDENT DISCOVERY UNIVERSE
      ↓
HOLDOUT / LEAVE-ONE-OUT MATCHING
      ↓
CLOSEST REAL PROJECTS
      ↓
OPTIONAL FUTURE-PERIOD RETURN EVALUATION
```

The three invariants are:

```text
1. Discovery candidates never shape the target they are scored against.
2. A strong single-source economic signal is not automatically deleted.
3. A strong single-source signal is never allowed to dominate the synthetic language.
```

Do not add complexity unless it demonstrably improves this pipeline under frozen, out-of-sample evaluation.

