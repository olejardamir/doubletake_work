# Market-Implied Semantic Portfolio (MISP)
## Simple Engineering Specification

**Status:** Focused implementation checkpoint — third flaw-correction pass  
**Version:** 1.6-simple  
**Primary goal:** Convert documents/whitepapers to vectors, weight them by period gain/loss, create a market-implied semantic vector, and synthesize a fictional representative document from the resulting signal.

**Checkpoint changes:** makes the signed gain/loss-adjusted vector the canonical market-implied target, keeps gain/loss vectors as diagnostics and evidence sources, verifies the generated fictional document by re-embedding it against that target, and fixes reconstruction, invalid-return, chunking, and pseudocode inconsistencies.

---

# 0. Scope

This version intentionally removes most of the broader architecture from earlier drafts.

The core experiment is:

```text
document / whitepaper
        ↓
embedding vector
        +
period gain/loss %
        ↓
return-weighted semantic vector
        ↓
retrieve the source text most aligned with that vector
        ↓
synthesize a fictional representative document / whitepaper
        ↓
re-embed the synthetic document
        ↓
verify semantic similarity to the target vector
```

The central question is:

> If each asset is represented by what its document says it is, and those semantic representations are adjusted by the asset's signed percentage gain/loss during a period, what fictional document best represents the resulting market-implied semantic direction?

This is a descriptive semantic experiment. It does **not** claim to measure literal investor intent, capital flows, or causality.

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

# 4. Construct the market-implied semantic vectors

The implementation produces one **canonical target vector** and two supporting side vectors.

## 4.1 Canonical market-implied vector

Use signed percentage returns:

\[
V_{market}
=
\frac{\sum_i r_i x_i}
{\sum_i |r_i|}
\]

When its norm is safely above zero:

\[
U_{market}=Normalize(V_{market})
\]

This is the core "adjusted" semantic vector.

Positive returns pull the vector toward an asset's document semantics. Negative returns push it away from those semantics. Larger percentage moves have larger influence.

Interpretation:

> A signed semantic direction representing characteristics associated with gains rather than losses during the selected period.

This is the default target used to evaluate the fictional synthesized document.

If \(V_{market}\) is near zero because positive and negative semantic effects cancel, `U_market` is undefined. In that case the system may still report gain-side and loss-side vectors, but it must not pretend that a strong unified market-implied direction exists.

---

## 4.2 Gain vector

For positive-return evidence and diagnostics:

\[
g_i = \max(r_i,0)
\]

\[
V_{gain}
=
\frac{\sum_i g_i x_i}
{\sum_i g_i}
\]

\[
U_{gain}=Normalize(V_{gain})
\]

Interpretation:

> The semantic center of documents associated with assets that gained during the period, weighted by how much they gained.

---

## 4.3 Loss vector

For negative-return evidence and diagnostics:

\[
l_i = \max(-r_i,0)
\]

\[
V_{loss}
=
\frac{\sum_i l_i x_i}
{\sum_i l_i}
\]

\[
U_{loss}=Normalize(V_{loss})
\]

Interpretation:

> The semantic center of documents associated with assets that lost during the period, weighted by how much they lost.

Gain and loss vectors help explain the signed target; they are not separate competing definitions of the main market-implied vector.

---

# 5. Do not attempt to "decode" the vector directly

Embedding vectors are not uniquely invertible into text.

There is no mathematically correct operation:

```text
target embedding → exact original/fake document
```

Instead, use the target vector to identify the real source material most aligned with it, then synthesize a new fictional document from that evidence.

This keeps the result connected to actual document semantics.

---

# 6. Retrieve evidence for synthesis

Store normalized chunk embeddings as well as whole-document vectors.

The canonical target is \(U_{market}\).

## 6.1 Positive supporting evidence

Only positive-return assets may provide positive support for the fictional rewarded document.

For positive-return asset \(i\):

\[
w_i^{gain}
=
\frac{\max(r_i,0)}
{\sum_j\max(r_j,0)}
\]

For normalized chunk vector \(\hat e_{ik}\):

\[
score_{ik}^{support}
=
w_i^{gain}
\cdot
\max(\cos(\hat e_{ik},U_{market}),0)
\]

If `U_market` is undefined, use \(U_{gain}\) only as an explicitly labeled fallback target.

Rank chunks by this score and enforce a maximum number per asset so one winner cannot provide the entire synthesis.

Recommended initial limits:

```yaml
max_assets: 20
max_chunks: 40
max_chunks_per_asset: 3
```

`max_assets` applies after ranking assets by useful evidence contribution, not merely by raw return.

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

## 6.2 Loss-side contrast evidence

If loss-side assets exist, retrieve a small independent contrast set.

For a loser chunk, useful contrast is high when the chunk points away from the market target:

\[
score_{ik}^{contrast}
=
w_i^{loss}
\cdot
\max(\cos(\hat e_{ik},-U_{market}),0)
\]

where:

\[
w_i^{loss}
=
\frac{\max(-r_i,0)}
{\sum_j\max(-r_j,0)}
\]

If `U_market` is undefined, use \(U_{loss}\) for loss-side description without claiming a unified contrast direction.

Loss-side passages are **contrast evidence only**. They cannot serve as positive support for the rewarded fictional document.

If the retrieved evidence does not support a meaningful winner/loser distinction, the synthesis should say less rather than invent one.

---

# 7. Synthesize the fictional document

The generator receives:

```text
period
canonical market-target metadata
top gain-weighted assets
top aligned gain-side passages
optional loss-side contrast passages
```

The generator is instructed to write a **fictional representative document**, not a real company description and not a prediction.

For equities, the output may look like a fictional company description.

For crypto, the output may look like a fictional whitepaper summary or project description.

The synthesis should answer:

> What would a hypothetical project/company look like if its document expressed the recurring, evidence-supported characteristics most aligned with the period's signed gain/loss-adjusted semantic direction?

The generator may combine supported characteristics across gain-side documents.

Loss-side evidence may only be used to identify characteristics that appear less represented among losers. It must not be copied into the rewarded archetype as positive support.

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

Every material characteristic in the synthesis must reference at least one supporting gain-side `chunk_id`.

---

# 7.1 Re-embed and verify the synthetic document

This is a required part of the core experiment.

After generating the fictional document:

1. clean and vectorize it with the **same document-vector function** used for source documents;
2. obtain synthetic vector \(x_{synthetic}\);
3. compare it to the exact synthesis target.

Normally:

\[
F_{target}
=
\cos(x_{synthetic},U_{market})
\]

If `U_market` was undefined and the explicitly labeled fallback \(U_{gain}\) was used:

\[
F_{target}
=
\cos(x_{synthetic},U_{gain})
\]

Also calculate, where available:

\[
F_{gain}
=
\cos(x_{synthetic},U_{gain})
\]

\[
F_{loss}
=
\cos(x_{synthetic},U_{loss})
\]

and:

\[
ContrastMargin
=
F_{gain}-F_{loss}
\]

Store the target actually used:

```text
synthesis_target = MARKET | GAIN_FALLBACK
```

Do not assume a universal acceptable cosine threshold in advance; embedding models have different similarity distributions.

For the initial implementation, generate at most a small fixed number of candidates, for example:

```yaml
max_synthesis_candidates: 3
```

Reject any candidate that fails evidence-grounding rules. Among grounded candidates, retain the one with the highest \(F_{target}\).

Use `ContrastMargin` only as a diagnostic. Never improve it by inserting unsupported traits.

This closes the loop:

```text
signed gain/loss-adjusted target vector
        ↓
evidence-grounded synthetic text
        ↓
synthetic embedding
        ↓
measured similarity back to the exact target
```

The final document is therefore not merely plausible prose; its semantic relationship to the vector it is supposed to represent is measured.

---

# 8. Recommended synthesis format

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

# 9. Minimal contribution table

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

# 10. Minimal run manifest

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

# 11. Core algorithm

```python
def build_period(period, assets, cfg):
    rows = []

    for asset in assets:
        if asset.document_available_at > period.start:
            continue

        if not valid_prices(asset.price_start, asset.price_end):
            continue

        chunks = chunk(clean(asset.document_text), cfg.chunking)
        chunk_vectors = normalize_chunk_vectors(embed(chunks, cfg.embedding))
        document_vector = pool_and_normalize(chunk_vectors, chunks)

        r = (asset.price_end - asset.price_start) / asset.price_start

        rows.append({
            "asset_id": asset.asset_id,
            "document_id": asset.document_id,
            "vector": document_vector,
            "chunks": chunks,
            "chunk_vectors": chunk_vectors,
            "return": r,
        })

    market_den = sum(abs(row["return"]) for row in rows)
    gain_den = sum(max(row["return"], 0.0) for row in rows)
    loss_den = sum(max(-row["return"], 0.0) for row in rows)

    market_vector = weighted_vector_or_null(
        rows,
        weight=lambda row: row["return"],
        denominator=market_den,
    )

    gain_vector = weighted_vector_or_null(
        rows,
        weight=lambda row: max(row["return"], 0.0),
        denominator=gain_den,
    )

    loss_vector = weighted_vector_or_null(
        rows,
        weight=lambda row: max(-row["return"], 0.0),
        denominator=loss_den,
    )

    market_direction = safe_normalize(market_vector)
    gain_direction = safe_normalize(gain_vector)
    loss_direction = safe_normalize(loss_vector)

    contributions = build_contribution_rows(
        period=period,
        rows=rows,
        market_den=market_den,
        gain_den=gain_den,
        loss_den=loss_den,
        market_direction=market_direction,
        gain_direction=gain_direction,
        loss_direction=loss_direction,
    )

    if market_direction is not None:
        synthesis_target = market_direction
        synthesis_target_type = "MARKET"
    elif gain_direction is not None:
        synthesis_target = gain_direction
        synthesis_target_type = "GAIN_FALLBACK"
    else:
        synthesis_target = None
        synthesis_target_type = None

    if synthesis_target is None:
        evidence = []
        synthetic = None
    else:
        evidence = retrieve_positive_evidence(
            rows=rows,
            target=synthesis_target,
            cfg=cfg.retrieval,
        )

        loss_evidence = retrieve_loss_contrast_evidence(
            rows=rows,
            market_target=market_direction,
            loss_target=loss_direction,
            cfg=cfg.retrieval,
        )

        candidates = generate_grounded_candidates(
            period=period,
            target_type=synthesis_target_type,
            gain_evidence=evidence,
            loss_evidence=loss_evidence,
            max_candidates=cfg.synthesis.max_candidates,
        )

        scored = []

        for candidate in candidates:
            if not claims_are_grounded(candidate, evidence):
                continue

            synthetic_vector = vectorize_document(
                candidate.text,
                cfg.embedding,
                cfg.chunking,
            )

            target_fidelity = cosine(
                synthetic_vector,
                synthesis_target,
            )

            gain_similarity = (
                cosine(synthetic_vector, gain_direction)
                if gain_direction is not None
                else None
            )

            loss_similarity = (
                cosine(synthetic_vector, loss_direction)
                if loss_direction is not None
                else None
            )

            scored.append({
                "candidate": candidate,
                "vector": synthetic_vector,
                "target_fidelity": target_fidelity,
                "gain_similarity": gain_similarity,
                "loss_similarity": loss_similarity,
                "contrast_margin": (
                    gain_similarity - loss_similarity
                    if gain_similarity is not None
                    and loss_similarity is not None
                    else None
                ),
            })

        synthetic = max(
            scored,
            key=lambda item: item["target_fidelity"],
            default=None,
        )

    return {
        "period": period,
        "market_vector": market_vector,
        "market_direction": market_direction,
        "gain_vector": gain_vector,
        "gain_direction": gain_direction,
        "loss_vector": loss_vector,
        "loss_direction": loss_direction,
        "synthesis_target_type": synthesis_target_type,
        "contributions": contributions,
        "evidence": evidence,
        "synthetic_document": (
            synthetic["candidate"].text if synthetic else None
        ),
        "synthetic_vector": (
            synthetic["vector"] if synthetic else None
        ),
        "synthesis_validation": synthetic,
    }
```

`weighted_vector_or_null` returns null when its denominator is zero.

`safe_normalize` returns null for null, non-finite, or near-zero vectors.

The implementation must not silently replace these nulls with zero vectors.

---

# 12. Important edge cases

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

# 13. Minimal diagnostics

For each period report only:

```text
asset_count
gain_asset_count
loss_asset_count
largest_gain_weight
largest_loss_weight
largest_absolute_market_weight
gain_vector_norm_before_normalization
loss_vector_norm_before_normalization
market_vector_norm_before_normalization
gain_vs_loss_cosine
synthetic_target_fidelity
synthetic_loss_similarity
synthetic_contrast_margin
```

Also list the top 10 gain contributors and top 10 loss contributors.

This is enough to reveal obvious domination or semantic cancellation without turning the experiment into a large quantitative platform.

---

# 14. Minimal tests

The implementation is acceptable when these tests pass.

## Determinism

Same documents, prices, model revision, and configuration produce the same vectors and contribution weights.

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

# 15. Suggested repository

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

# 16. Implementation sequence

## Step 1

Create a tiny dataset of 10–20 assets with:

```text
document
start price
end price
```

## Step 2

Embed every document and store its vector.

## Step 3

Calculate gain/loss percentages.

## Step 4

Calculate:

```text
market_vector
gain_vector
loss_vector
```

## Step 5

Inspect the top contributing documents manually.

If the vectors do not correspond to intuitively related source material, fix the document representation before adding more machinery.

## Step 6

Embed source chunks and retrieve passages nearest to the gain vector.

## Step 7

Generate the fictional representative document from those passages.

## Step 8

Re-embed the synthetic document with the same document-vector function and store its similarity to the exact market target (or the explicitly labeled gain fallback). If using multiple candidates, retain the highest-fidelity grounded candidate.

## Step 9

Run the same pipeline month by month and compare the resulting synthetic documents and vectors over time.

---

# 17. What not to build yet

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

# 18. Definition of done

The first working version is complete when, for any chosen period, the system can:

1. load one admissible document/whitepaper per asset;
2. convert each document into a reproducible embedding vector;
3. calculate each asset's percentage gain/loss;
4. weight the document vectors by those returns;
5. produce the canonical signed market vector plus gain and loss semantic vectors;
6. reconstruct those vectors from stored contribution weights;
7. identify which real documents and passages most strongly support the gain vector;
8. generate one fictional representative document grounded in those passages;
9. re-embed that fictional document and report its semantic fidelity to the exact synthesis target;
10. show which assets and passages influenced the result;
11. reproduce the same quantitative result from the same inputs and pinned embedding revision.

That is the complete core experiment.

---

# 19. Canonical interpretation

The primary output should be described as:

> **A synthetic semantic archetype grounded in winner documents and targeted at the signed percentage-return-weighted market vector for the selected period.**

A shorter user-facing description can be:

> **What a hypothetical market-rewarded project/company would look like when gains pull its semantic profile closer and losses push it away.**

Avoid presenting it as proof of what investors literally intended to buy.

---

# 20. Final engineering rule

Keep the dependency simple:

```text
REAL DOCUMENTS
      ↓
EMBEDDINGS
      +
GAIN / LOSS %
      ↓
SIGNED GAIN/LOSS-WEIGHTED SEMANTIC VECTOR
      ↓
ALIGNED REAL SOURCE PASSAGES
      ↓
FICTIONAL REPRESENTATIVE DOCUMENT
      ↓
RE-EMBED + COMPARE TO TARGET VECTOR
```

Do not add complexity unless it demonstrably improves this pipeline.
