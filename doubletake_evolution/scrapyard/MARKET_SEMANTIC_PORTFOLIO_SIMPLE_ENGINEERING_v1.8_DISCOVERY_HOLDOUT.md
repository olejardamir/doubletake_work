# Market-Implied Semantic Portfolio (MISP)
## Simple Engineering Specification

**Status:** Focused implementation checkpoint — discovery-holdout and anti-dominance pass  
**Version:** 1.8-simple  
**Primary goal:** Convert documents/whitepapers to vectors, weight them by period gain/loss, create a market-implied semantic vector, and synthesize a fictional representative document from the resulting signal.

**Checkpoint changes:** fixes two remaining biases exposed by the pilot.

1. **Self-influence / closed-world bias:** a real project must never be judged against a semantic target that it helped create. Discovery therefore uses a holdout or leave-one-out target.
2. **Single-project language dominance:** the synthetic document may not inherit its core description from one winner such as Ethereum. Material synthesized characteristics require support from multiple independent winner documents, and evidence from any one project is capped.

The intended behavior is now: build a market-implied semantic archetype from many projects, then independently search for the real project that most resembles that archetype.

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

# 7. Prevent self-influence and single-project dominance

Baseline subtraction removes generic domain language, but it does not solve two other biases:

```text
1. a candidate project can resemble the target because it helped create the target;
2. one large winner can dominate the wording of the synthetic document.
```

Both must be prevented.

## 7.1 Broad source universe

Do not build the target from a hand-picked five-project sample.

The source universe should be defined before observing the semantic result, for example:

```text
all eligible liquid crypto projects with:
- a usable official/founding document;
- valid start/end prices for the period;
- document availability before period start.
```

The exact eligibility rule is versioned.

The source universe is the market sample from which the archetype is inferred.

## 7.2 Candidate holdout rule

A project may not be scored against a target that contains its own document vector.

For candidate project \(j\), construct:

\[
V_{market}^{(-j)}
=
\frac{
\sum_{i \ne j} r_i z_i
}{
\sum_{i \ne j} |r_i|
}
\]

and:

\[
U_{market}^{(-j)}
=
Normalize(V_{market}^{(-j)})
\]

Then score candidate \(j\) against \(U_{market}^{(-j)}\), not against the full target.

If candidate \(j\) was never part of the source universe, the ordinary full target may be used because there is no self-influence.

This creates two valid discovery cases:

```text
UNSEEN_HOLDOUT
candidate was never in the synthesis universe

LEAVE_ONE_OUT
candidate was in the universe, but its own contribution is removed before scoring
```

The system must store which case was used.

## 7.3 Multi-project consensus rule

The fictional document is intended to describe a **market theme**, not paraphrase the largest winner.

A material synthesized characteristic must therefore satisfy:

```text
minimum_distinct_supporting_projects: 2
preferred_distinct_supporting_projects: 3
```

A trait supported by only one project is considered `PROJECT_SPECIFIC` by default and is excluded from the core archetype.

It may be reported separately as an idiosyncratic contributor, but it must not define the main synthetic document.

## 7.4 Per-project evidence cap

No single project may supply more than a configured fraction of the evidence used for synthesis.

Initial value:

```yaml
max_evidence_share_per_project: 0.35
```

This cap applies to **language/evidence synthesis**, not to the canonical economic return calculation.

The signed return-weighted vector remains mathematically faithful to the return inputs. The evidence cap only prevents one project from dictating the prose representation of that vector.

## 7.5 Distinguish economic influence from linguistic influence

Store both:

```text
economic_contribution_share
synthesis_evidence_share
```

They serve different purposes.

A project may legitimately have a large economic contribution because it moved strongly during the period.

That does **not** entitle its document to contribute most of the words or concepts in the synthetic document.

## 7.6 Consensus concept extraction

Before writing prose, construct a small set of candidate concepts from winner-side evidence.

For each concept \(c\), store:

```text
concept_id
supporting_project_ids[]
supporting_chunk_ids[]
winner_support
loser_support
baseline_support
market_alignment
project_count
largest_single_project_share
```

A concept is eligible for the core archetype only if:

```text
project_count >= minimum_distinct_supporting_projects
largest_single_project_share <= max_evidence_share_per_project
winner_support > loser_support
market_alignment > 0
```

This is intentionally simple.

The goal is to suppress:

```text
"Ethereum's wording"
```

while preserving:

```text
"a theme independently expressed by Ethereum plus other winners"
```

---

# 8. Retrieve distinctive evidence for synthesis

The retrieval goal is not simply to find passages that resemble winners.

It is to find passages supporting characteristics that are distinctive to winners relative to both the overall universe and the losing side.

Store normalized chunk embeddings as well as whole-document vectors.

## 8.1 Chunk baseline correction

Let \(\hat e_{ik}\) be a normalized chunk embedding.

Calculate:

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

when the residual norm is valid.

Use \(c_{ik}\) for contrastive passage retrieval.

## 8.2 Positive supporting evidence

Only positive-return assets may provide positive support.

For winner \(i\):

\[
w_i^{gain}
=
\frac{\max(r_i,0)}
{\sum_j\max(r_j,0)}
\]

A simple support score is:

\[
score_{ik}^{support}
=
w_i^{gain}
\cdot
\max(\cos(c_{ik},U_{market}),0)
\]

If `U_market` is undefined, \(U_{gain}\) may be used only as an explicitly labeled fallback.

Recommended initial limits:

```yaml
max_assets: 20
max_chunks: 40
max_chunks_per_asset: 3
```

Each retained positive evidence item stores:

```text
chunk_id
asset_id
document_id
return
gain_weight
target_similarity
retrieval_score
text
```

After chunk retrieval, group semantically similar evidence into candidate concepts. The prose generator receives only concepts that pass the multi-project consensus rules in Section 7.

A high-scoring chunk from one project alone is insufficient to define the core synthetic archetype.


## 8.3 Loss-side contrast evidence

For loser chunks:

\[
score_{ik}^{loss}
=
w_i^{loss}
\cdot
\max(\cos(c_{ik},U_{loss}),0)
\]

where:

\[
w_i^{loss}
=
\frac{\max(-r_i,0)}
{\sum_j\max(-r_j,0)}
\]

Loss-side passages are contrast evidence only.

## 8.4 Distinctiveness rule

A characteristic should appear in the final synthetic document only when it is:

1. supported by winner-side evidence;
2. aligned with the baseline-corrected target;
3. not merely generic across the universe;
4. not equally or more strongly represented among losers.

Conceptually:

\[
Distinctiveness(c)
=
Support_{winners}(c)
-
Support_{losers}(c)
-
Support_{baseline}(c)
\]

The first implementation does not need this exact scalar formula, but it must enforce the same logic.

Generic phrases such as:

```text
decentralized blockchain
smart contracts
digital assets
peer-to-peer network
technology platform
serves customers
```

should normally be omitted unless they are genuinely distinctive in that run.

---

# 9. Synthesize the fictional document

The generator receives:

```text
period
canonical baseline-corrected market target
consensus winner concepts
winner-side distinctive evidence
loser-side contrast evidence
generic baseline concepts to avoid
per-project synthesis evidence shares
```

It writes a **fictional representative document**, not a real company/project description and not a prediction.

The synthesis should answer:

> What would a hypothetical project/company look like if its document expressed the evidence-supported characteristics that distinguish gain-side documents from both the general universe and the losing side?

Prefer specific differentiating characteristics over domain-generic language.

For example, prefer:

```text
parallel execution with local fee markets
cross-consensus message passing
programmable state-transition logic
specialized validator architecture
```

over:

```text
decentralized blockchain
secure network
digital assets
smart contracts
```

unless the generic phrase itself is shown to be distinctive.

The generator must not invent unsupported:

- revenue;
- customers;
- market share;
- token price;
- valuation;
- geography;
- partnerships;
- technologies;
- performance claims.

Every material characteristic must reference at least one supporting winner-side `chunk_id`.

For the **core archetype**, every material characteristic must also reference at least two distinct supporting projects unless it is explicitly labeled `PROJECT_SPECIFIC`.

The generator must not copy or closely paraphrase characteristic wording from a single source when an equivalent cross-project abstraction can be expressed instead.


If distinctiveness evidence is weak, produce a shorter document rather than padding it with generic language.

---

# 9.1 Re-embed and verify the synthetic document

After generating the fictional document:

1. vectorize it with the same source-document vectorizer;
2. obtain raw synthetic vector \(x_{synthetic}\);
3. subtract the same universe baseline:

\[
d_{synthetic}=x_{synthetic}-B
\]

4. normalize:

\[
z_{synthetic}=Normalize(d_{synthetic})
\]

5. compare it to the exact synthesis target.

Normally:

\[
F_{target}
=
\cos(z_{synthetic},U_{market})
\]

If the gain fallback was used:

\[
F_{target}
=
\cos(z_{synthetic},U_{gain})
\]

Also calculate, where available:

\[
F_{gain}
=
\cos(z_{synthetic},U_{gain})
\]

\[
F_{loss}
=
\cos(z_{synthetic},U_{loss})
\]

\[
ContrastMargin
=
F_{gain}-F_{loss}
\]

Store:

```text
synthesis_target = MARKET | GAIN_FALLBACK
synthetic_target_fidelity
synthetic_gain_similarity
synthetic_loss_similarity
synthetic_contrast_margin
```

Generate at most:

```yaml
max_synthesis_candidates: 3
```

Reject candidates that:

- fail evidence grounding;
- rely mainly on generic baseline concepts;
- are closer to the loss side than the gain side when both are defined.

Among remaining candidates, retain the one with the highest target fidelity.

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

text:
  cleaner_version: ...
  chunker_version: ...
  pooling_version: ...
  normalization_version: ...

baseline:
  method: universe_mean
  document_baseline_version: ...
  chunk_baseline_version: ...

consensus:
  minimum_distinct_supporting_projects: 2
  preferred_distinct_supporting_projects: 3
  max_evidence_share_per_project: 0.35

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

`input_hash` must cover the ordered set of asset IDs, document content hashes, period boundaries, and price/return inputs used in the run.

Changing the embedding model creates a different semantic space and therefore a different experiment.

Do not compare vectors from two different embedding models as though they occupy the same coordinate system.

Quantitative vectors must be deterministic from pinned inputs. Text generation may not be bit-for-bit reproducible for every model provider; the generated text, its hash, prompt version, model revision, and measured target fidelity must therefore be stored.

---

# 13. Core algorithm

```python
def build_period(period, assets, cfg):
    rows = []

    for asset in assets:
        if asset.document_available_at > period.start:
            continue

        if not valid_prices(asset.price_start, asset.price_end):
            continue

        chunks = chunk(clean(asset.document_text), cfg.chunking)
        chunk_vectors = normalize_chunk_vectors(
            embed(chunks, cfg.embedding)
        )
        document_vector = pool_and_normalize(
            chunk_vectors,
            chunks,
        )

        r = (
            asset.price_end - asset.price_start
        ) / asset.price_start

        rows.append({
            "asset_id": asset.asset_id,
            "document_id": asset.document_id,
            "vector": document_vector,
            "chunks": chunks,
            "chunk_vectors": chunk_vectors,
            "return": r,
        })

    document_baseline = mean_vector(
        [row["vector"] for row in rows]
    )

    chunk_baseline = mean_vector([
        v
        for row in rows
        for v in row["chunk_vectors"]
    ])

    usable_rows = []

    for row in rows:
        residual = safe_normalize(
            row["vector"] - document_baseline
        )

        if residual is None:
            continue

        row["residual_vector"] = residual
        row["residual_chunk_vectors"] = [
            safe_normalize(v - chunk_baseline)
            for v in row["chunk_vectors"]
        ]

        usable_rows.append(row)

    market_den = sum(
        abs(row["return"])
        for row in usable_rows
    )

    gain_den = sum(
        max(row["return"], 0.0)
        for row in usable_rows
    )

    loss_den = sum(
        max(-row["return"], 0.0)
        for row in usable_rows
    )

    market_vector = weighted_vector_or_null(
        usable_rows,
        vector_key="residual_vector",
        weight=lambda row: row["return"],
        denominator=market_den,
    )

    gain_vector = weighted_vector_or_null(
        usable_rows,
        vector_key="residual_vector",
        weight=lambda row: max(row["return"], 0.0),
        denominator=gain_den,
    )

    loss_vector = weighted_vector_or_null(
        usable_rows,
        vector_key="residual_vector",
        weight=lambda row: max(-row["return"], 0.0),
        denominator=loss_den,
    )

    market_direction = safe_normalize(market_vector)
    gain_direction = safe_normalize(gain_vector)
    loss_direction = safe_normalize(loss_vector)

    if market_direction is not None:
        synthesis_target = market_direction
        synthesis_target_type = "MARKET"
    elif gain_direction is not None:
        synthesis_target = gain_direction
        synthesis_target_type = "GAIN_FALLBACK"
    else:
        synthesis_target = None
        synthesis_target_type = None

    evidence = (
        retrieve_distinctive_winner_evidence(
            rows=usable_rows,
            target=synthesis_target,
            loss_target=loss_direction,
            chunk_baseline=chunk_baseline,
            cfg=cfg.retrieval,
        )
        if synthesis_target is not None
        else []
    )

    loss_evidence = retrieve_loss_contrast_evidence(
        rows=usable_rows,
        loss_target=loss_direction,
        chunk_baseline=chunk_baseline,
        cfg=cfg.retrieval,
    )

    candidates = (
        generate_grounded_candidates(
            period=period,
            target_type=synthesis_target_type,
            gain_evidence=evidence,
            loss_evidence=loss_evidence,
            generic_baseline_terms=extract_generic_terms(rows),
            max_candidates=cfg.synthesis.max_candidates,
        )
        if synthesis_target is not None
        else []
    )

    scored = []

    for candidate in candidates:
        if not claims_are_grounded(candidate, evidence):
            continue

        synthetic_raw = vectorize_document(
            candidate.text,
            cfg.embedding,
            cfg.chunking,
        )

        synthetic_residual = safe_normalize(
            synthetic_raw - document_baseline
        )

        if synthetic_residual is None:
            continue

        target_fidelity = cosine(
            synthetic_residual,
            synthesis_target,
        )

        gain_similarity = (
            cosine(synthetic_residual, gain_direction)
            if gain_direction is not None
            else None
        )

        loss_similarity = (
            cosine(synthetic_residual, loss_direction)
            if loss_direction is not None
            else None
        )

        contrast_margin = (
            gain_similarity - loss_similarity
            if gain_similarity is not None
            and loss_similarity is not None
            else None
        )

        if (
            contrast_margin is not None
            and contrast_margin <= 0
        ):
            continue

        scored.append({
            "candidate": candidate,
            "vector": synthetic_residual,
            "target_fidelity": target_fidelity,
            "gain_similarity": gain_similarity,
            "loss_similarity": loss_similarity,
            "contrast_margin": contrast_margin,
        })

    synthetic = max(
        scored,
        key=lambda item: item["target_fidelity"],
        default=None,
    )

    return {
        "period": period,
        "document_baseline": document_baseline,
        "chunk_baseline": chunk_baseline,
        "market_vector": market_vector,
        "market_direction": market_direction,
        "gain_vector": gain_vector,
        "gain_direction": gain_direction,
        "loss_vector": loss_vector,
        "loss_direction": loss_direction,
        "synthesis_target_type": synthesis_target_type,
        "evidence": evidence,
        "synthetic_document": (
            synthetic["candidate"].text
            if synthetic
            else None
        ),
        "synthetic_vector": (
            synthetic["vector"]
            if synthetic
            else None
        ),
        "synthesis_validation": synthetic,
    }
```

The central change is:

```text
raw document vector
    ↓
subtract universe mean
    ↓
distinctive document vector
    ↓
apply signed return weighting
```

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

Same documents, prices, model revision, baseline definition, and configuration produce the same vectors and contribution weights.

## Baseline subtraction

If every document vector is identical, every baseline-corrected residual is zero/undefined and no market direction is produced.

## Common-component removal

A semantic component shared equally by every document should be substantially suppressed by baseline subtraction.

## Generic-trait suppression

A characteristic represented similarly among winners and losers must not dominate the final synthesis merely because it is common in the domain.

## Self-influence prevention

For any candidate that contributed to synthesis, its discovery score must be computed from a target rebuilt without that candidate.

## Holdout discovery

A project deliberately excluded from synthesis must still be eligible to rank first during discovery.

## Single-project dominance

A concept supported by only one project cannot enter the core archetype when `minimum_distinct_supporting_projects >= 2`.

## Evidence-share cap

No project's synthesis evidence share may exceed `max_evidence_share_per_project`.


## Return weighting

For identical document vectors, a +20% asset receives twice the gain weight of a +10% asset.

## Gain/loss separation

A negative-return asset contributes nothing to `gain_vector`.

A positive-return asset contributes nothing to `loss_vector`.

## Sign symmetry

If every return sign is reversed:

```text
gain_vector ↔ loss_vector
market_vector → -market_vector
```

subject to numerical tolerance.

## Equal returns

If all assets have the same positive return, `gain_vector` becomes the simple mean of the document vectors.

## Zero return

A zero-return asset contributes nothing to market, gain, or loss weighting.

## Future-document rejection

A document published after the period begins cannot be used for that period.

## Reconstruction

The stored contribution rows reproduce the stored market, gain, and loss vectors.

## Evidence grounding

Every material statement in the synthetic document must have at least one supporting gain-side retrieved passage.

## Synthetic re-embedding

The selected synthetic document is re-embedded with the same vectorization pipeline used for source documents, and its cosine similarity to the exact synthesis target is stored.

## Candidate selection

An unsupported candidate can never beat a grounded candidate solely because it has higher cosine similarity.

## Contribution weights

Stored `market_weight`, `gain_weight`, and `loss_weight` exactly reconstruct the corresponding raw vectors within numerical tolerance.

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

Create a broad, rule-defined source universe rather than a hand-picked handful of assets.

## Step 2

Embed every source document and store its raw vector.

## Step 3

Calculate the universe semantic baseline and baseline-correct every document vector.

## Step 4

Calculate gain/loss percentages.

## Step 5

Calculate:

```text
market_vector
gain_vector
loss_vector
```

using baseline-corrected document vectors.

## Step 6

Retrieve winner and loser evidence and extract candidate concepts.

## Step 7

Apply multi-project consensus and the per-project evidence cap.

Reject single-project concepts from the core archetype unless explicitly labeled `PROJECT_SPECIFIC`.

## Step 8

Generate the fictional representative document from consensus concepts.

## Step 9

Re-embed and baseline-correct the fictional document and validate it against the target.

## Step 10

Build a separate discovery universe.

For each discovery candidate, use:

```text
full target
```

if it never contributed to synthesis, or:

```text
leave-one-out target
```

if it did.

## Step 11

Rank real projects by semantic similarity to the independently inferred target.

## Step 12

Run holdout experiments in which known projects are deliberately excluded from synthesis and tested only during discovery.

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

The first working version is complete when, for any chosen period, the system can:

1. construct a broad rule-defined source universe;
2. load one admissible official/founding document per source asset;
3. convert each document into a reproducible embedding vector;
4. calculate a reproducible universe/background semantic baseline;
5. subtract that baseline from each document vector;
6. calculate each asset's percentage gain/loss;
7. produce the signed baseline-corrected market vector;
8. extract winner-side evidence and loser-side contrast evidence;
9. derive consensus concepts supported by multiple independent winner projects;
10. prevent any one project from dominating the synthesis language;
11. generate one fictional representative document grounded in consensus evidence;
12. re-embed and validate that fictional document;
13. search an independent discovery universe for the closest real project;
14. ensure a candidate never scores against a target containing its own contribution;
15. support explicit holdout evaluation in which a project is absent from synthesis but may still rank first in discovery;
16. reproduce the same quantitative outputs from the same inputs and configuration.

That is the complete core experiment.

---

# 22. Canonical interpretation

The primary output should be described as:

> **A consensus semantic archetype inferred from many winner/loser documents, stripped of generic domain language and single-project wording, then matched independently against real projects that did not influence their own discovery score.**

A shorter user-facing description can be:

> **What a hypothetical market-rewarded project/company would look like after stripping away the generic language shared by the rest of the market.**

Avoid presenting it as proof of what investors literally intended to buy.

---

# 23. Final engineering rule

Keep the dependency simple:

```text
BROAD SOURCE UNIVERSE
      ↓
DOCUMENT EMBEDDINGS
      ↓
SUBTRACT UNIVERSE SEMANTIC BASELINE
      +
GAIN / LOSS %
      ↓
SIGNED DISTINCTIVE MARKET VECTOR
      ↓
MULTI-PROJECT CONSENSUS CONCEPTS
      ↓
FICTIONAL REPRESENTATIVE DOCUMENT
      ↓
RE-EMBED + VALIDATE
      ↓
INDEPENDENT DISCOVERY UNIVERSE
      ↓
HOLDOUT / LEAVE-ONE-OUT MATCHING
      ↓
CLOSEST REAL PROJECT
```

Do not add complexity unless it demonstrably improves this pipeline.
