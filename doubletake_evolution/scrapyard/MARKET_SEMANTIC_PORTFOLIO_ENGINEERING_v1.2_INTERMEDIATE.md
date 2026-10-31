# Market-Implied Semantic Portfolio (MISP)  
## Engineering Design Specification

**Status:** Intermediate convergence revision — implementation-ready core, final audit pending    
**Version:** 1.2-intermediate    
**Primary implementation:** U.S. public equities    
**Secondary adapter:** Cryptoassets    
**Primary cadence:** Monthly    
**Audience:** Data engineering, ML/NLP engineering, quantitative research, backend engineering, research infrastructure, and model-evaluation teams

**Revision note:** This intermediate revision incorporates the material corrections identified in the current convergence review. It is intentionally not labeled final: the remaining full-document audit has not yet been declared converged.

**Corrections incorporated in this revision:**
- restored normal Markdown structure from the escaped export;
- generalized contribution accounting so linear aggregation states reconstruct from explicit entity coefficients rather than state-specific ambiguous weight fields;
- separated aggregation-state reconstruction from model-derived regression reconstruction;
- prevented clustering from being forced when the evidence supports a single undivided mode;
- separated the quantitative run manifest from optional downstream generation manifests;
- reconciled sector-neutral definitions with the later point-in-time sector-classification contract;
- corrected the orthogonal-rotation contradiction by treating common rotations as invariance tests, not semantic-destruction nulls;
- moved Sections 71–94 ahead of the appendices so the numbered specification is contiguous.


---

## 0. Executive engineering contract

This repository implements a point-in-time system that represents investable economic entities as document-derived semantic vectors and combines those vectors with realized market outcomes to estimate the semantic characteristics associated with market reward and punishment.

The system is not an LLM narrative generator with market data attached. The quantitative state is the product. Generated prose is an optional interpretation layer and must be removable without changing any quantitative result.

The canonical dependency direction is:

~~~text  
point-in-time entity universe  
        +  
point-in-time documents  
        +  
frozen semantic representation  
        +  
realized market outcomes  
        ↓  
deterministic semantic states  
        ↓  
diagnostics / clusters / statistical estimators  
        ↓  
retrieved evidence  
        ↓  
optional grounded synthetic archetypes  
~~~

The following invariants are non-negotiable:

1. No future document, future universe membership, future security metadata, or future market observation may enter a historical state.  
2. Entity identity is separated from security/ticker identity.  
3. Multiple securities representing one issuer must not duplicate the issuer's semantic vector in the economic aggregation.  
4. Beginning-of-period economic size is used for return-attributed weighting.  
5. Raw market-cap-weighted results are preserved even when concentrated; concentration is diagnosed rather than silently removed.  
6. Robust/breadth states are separate estimators, not modifications of the economic state.  
7. Positive, negative, signed, contrastive, baseline-composition, and regression states are distinct objects with distinct interpretations.  
8. All embedding/preprocessing/model versions are immutable and explicitly identified.  
9. Every published **linear aggregation state** can be exactly reconstructed from an immutable contribution table and run manifest. Model-derived outputs such as regression directions must instead be exactly reconstructible from immutable fit artifacts, design matrices/snapshots, reducer artifacts, hyperparameters, and the run manifest.  
10. Every generated interpretation is traceable to source passages and cannot feed back into the quantitative pipeline.  
11. Source documents are treated as untrusted content when passed to an LLM; instructions contained inside documents are never executable instructions.  
12. Missing or ambiguous data fail closed. The pipeline does not guess.

---

# 1. Research object and terminology

## 1.1 Entity, security, document, and semantic space

An **entity** is the economic object whose meaning is represented by text.

For equities, the entity is normally an issuer/company. One issuer may have multiple listed securities or share classes.

For crypto, the entity may be a protocol/project, network, or economically distinct token depending on the configured universe. The identity model must explicitly encode that choice.

A **document version** is immutable source text with a reliable public-availability timestamp.

A **semantic space** is the complete frozen transformation from normalized document text to analysis vectors, including:

- parser version;  
- section-selection policy;  
- chunker version;  
- embedding model and revision;  
- chunk pooling;  
- optional centering/whitening;  
- normalization;  
- dimensionality.

Changing any of these creates a new semantic space.

## 1.2 Canonical names

- **MISP** — Market-Implied Semantic Portfolio: the overall methodology.  
- **MSS** — Market Semantic State: generic semantic state for a period.  
- **MSB** — Market Semantic Baseline: beginning-of-period size-weighted semantic composition.  
- **VCSS** — Value-Creation Semantic State: positive return-attributed value state.  
- **VDSS** — Value-Destruction Semantic State: negative return-attributed value state.  
- **SRS** — Signed Reward State: signed economic reward/destruction state preserving relative positive and negative magnitude.  
- **CSD** — Contrastive Semantic Direction: direction separating positive from negative states.  
- **RST** — Return-Induced Semantic Tilt: change in market semantic composition caused by returns while holding supply fixed.  
- **RSS** — Robust Semantic State: diversified/breadth-oriented estimator.  
- **SND** — Sector-Neutral Direction: semantic direction estimated from sector-neutral or factor-residual returns.  
- **SRC** — Semantic Reward Cluster: distinct rewarded semantic mode.  
- **SRA** — Synthetic Representative Archetype: evidence-grounded human-readable representation of a state or cluster.  
- **SD** — Semantic Drift.  
- **VBD** — Value-Breadth Divergence.

Avoid the phrase "what investors wanted" in production outputs. The system measures semantic characteristics associated with realized market-price outcomes, not investor psychology or literal capital flows.

---

# 2. Canonical time model

## 2.1 Measurement interval

For U.S. equities, a monthly observation uses:

- \(t_0\): official market close on the last trading day immediately preceding the target month;  
- \(t_1\): official market close on the last trading day of the target month.

The total return \(r_{i,t}\) is measured from \(t_0\) to \(t_1\).

The document used for the observation must satisfy:

\[  
available_at(D_{i,t}) \le t_0  
\]

This is stricter and safer than merely requiring a document to exist before the first calendar day of the month.

A document released after the \(t_0\) close is not admissible for that month's representation because the measured return begins at the \(t_0\) close.

## 2.2 Availability timestamp hierarchy

Each document stores both source and ingestion timestamps.

Required fields:

~~~text  
published_at  
filed_at  
source_available_at  
first_seen_at  
retrieved_at  
~~~

Canonical \(available_at\) is chosen using a source-specific deterministic rule:

1. authoritative public filing/publication timestamp when available;  
2. otherwise a reliable source timestamp;  
3. otherwise first_seen_at.

Never backdate a document using a date printed inside the document when the public availability time is unknown.

first_seen_at is operational provenance, not automatically the economic availability timestamp.

## 2.3 Time zones

All stored timestamps are UTC.

Source timestamps retain original timezone metadata when available.

Market session boundaries are generated using an exchange calendar and converted to UTC. Do not hard-code UTC offsets because daylight-saving transitions change them.

---

# 3. Entity and security identity

## 3.1 Equity identity

Use two levels:

~~~text  
issuer_id  
security_id  
~~~

Documents map to issuer_id.

Prices, returns, shares, exchange listings, and corporate actions map to security_id.

The monthly issuer observation is aggregated from eligible securities belonging to the issuer.

This prevents a dual-class issuer from receiving the same document embedding multiple times merely because it has multiple listed share classes.

For issuer \(j\) with securities \(s \in j\):

\[  
C_{j,t_0} = \sum_{s \in j} C_{s,t_0}  
\]

\[  
q_{j,t} = \sum_{s \in j} C_{s,t_0} r_{s,t}  
\]

\[  
r_{j,t}^{agg} =  
\begin{cases}  
q_{j,t}/C_{j,t_0}, & C_{j,t_0}>0 \\\\  
NA, & \text{otherwise}  
\end{cases}  
\]

The issuer semantic vector appears once, with issuer-level economic contribution \(q_{j,t}\).

## 3.2 Security history

Never identify a security only by ticker.

Store:

~~~text  
security_id  
issuer_id  
identifier_type  
identifier_value  
valid_from  
valid_to  
exchange  
share_class  
security_type  
currency  
country  
~~~

Identifier types may include stable vendor IDs, CIK, FIGI, ISIN, CUSIP where licensed, exchange symbol, and internal IDs.

Ticker reuse must produce distinct historical security identities.

## 3.3 Corporate events

The identity layer must represent:

- ticker changes;  
- share-class changes;  
- mergers;  
- acquisitions;  
- spin-offs;  
- splits and reverse splits;  
- bankruptcies;  
- delistings;  
- reincorporations;  
- ADR relationships;  
- SPAC mergers;  
- issuer name changes.

Do not rewrite history after a corporate event.

## 3.4 Crypto identity

Crypto requires at least:

~~~text  
project_id  
economic_asset_id  
instrument_id  
chain_id  
contract_address  
valid_from  
valid_to  
~~~

The model must support:

- ticker reuse;  
- contract migration;  
- chain migration;  
- forks;  
- redenominations;  
- token swaps;  
- wrapped assets;  
- liquid-staking representations;  
- bridged representations;  
- protocol governance tokens;  
- protocol utility tokens;  
- dead/delisted assets.

The MVP should not aggregate multiple economically distinct tokens into one project unless a documented mapping rule exists.

---

# 4. Universe construction

## 4.1 Equity MVP

Primary universe:

> U.S.-listed common equity of operating companies with valid point-in-time issuer identity, admissible business-description text, beginning-of-period market capitalization, and a measurable monthly total return.

Default exclusions:

- ETFs;  
- ETNs;  
- closed-end funds;  
- mutual funds;  
- preferred stock;  
- warrants;  
- rights;  
- units;  
- blank-check shells before an operating-company combination;  
- investment vehicles whose economic meaning is primarily a portfolio of other securities;  
- duplicate or non-economic listings.

ADRs should be excluded in v1 or handled in a separately versioned universe.

Do not impose a market-cap cutoff in the canonical research universe unless data quality requires one. Instead expose coverage and run robustness universes with liquidity/size thresholds.

## 4.2 Historical eligibility

Eligibility is calculated as of \(t_0\).

Current listing status must never determine historical membership.

Every monthly eligibility decision stores:

~~~text  
entity_id  
period  
eligible  
eligibility_rule_version  
eligibility_reason_codes[]  
~~~

Reason codes are machine-readable.

## 4.3 Crypto default eligibility

Initial configurable rules may include:

~~~yaml  
minimum_age_days: 90  
minimum_median_daily_volume_usd: 1000000  
minimum_market_cap_usd: 25000000  
require_admissible_document: true  
exclude_stablecoins: true  
exclude_wrapped_assets: true  
exclude_bridged_duplicates: true  
exclude_liquid_staking_receipts: true  
~~~

These are experiment configuration, never application constants.

Because crypto volume and capitalization data can be unreliable, eligibility must preserve vendor/source provenance and quality flags.

---

# 5. Document policy

## 5.1 Equity canonical document

The v1 equity semantic identity uses the latest admissible annual business description available at \(t_0\).

Preferred source:

> Annual regulatory filing business section describing the issuer's operations, products, services, customers, markets, and segments.

The baseline deliberately excludes unrelated filing sections such as:

- risk factors;  
- legal proceedings;  
- accounting policies;  
- compensation;  
- signatures;  
- generic regulatory boilerplate.

The goal is to represent what the company does, not every topic appearing in a filing.

## 5.2 Document update policy

An issuer's semantic representation changes only when a newly admissible canonical document becomes available.

Do not interpolate or retroactively update historical vectors.

Optional future channels may include:

~~~text  
business_identity_vector  
risk_vector  
earnings_call_vector  
management_outlook_vector  
product_update_vector  
news_vector  
~~~

Channels remain separate until an explicit fusion model is defined and validated.

## 5.3 Crypto document channels

Maintain at least two independent channels.

### Founding channel

- original whitepaper;  
- launch technical paper;  
- founding protocol specification.

This is mostly static and answers which founding ideas are rewarded over time.

### Living channel

- current official protocol documentation;  
- current technical documentation;  
- current official project description;  
- governance/architecture documentation.

This changes over time and answers which current project characteristics are associated with market outcomes.

Never silently substitute living documentation for a missing founding whitepaper.

## 5.4 Immutable raw storage

Every source artifact is content-addressed.

Required metadata:

~~~text  
document_id  
entity_id  
document_type  
source_name  
source_locator  
published_at  
filed_at  
source_available_at  
first_seen_at  
retrieved_at  
available_at  
language  
raw_content_hash  
normalized_content_hash  
parser_version  
document_policy_version  
supersedes_document_id  
~~~

Historical documents are append-only.

---

# 6. Parsing and normalization

## 6.1 Pipeline

~~~text  
raw source  
  → format-specific extraction  
  → structural section detection  
  → canonical section selection  
  → boilerplate filtering  
  → Unicode/text normalization  
  → language detection  
  → deterministic chunking  
  → chunk embeddings  
  → document pooling  
  → analysis-space transformation  
~~~

## 6.2 Normalization rules

Normalization may:

- normalize Unicode;  
- normalize whitespace;  
- remove repeated headers/footers;  
- remove page numbers;  
- remove duplicated table-of-contents text;  
- preserve sentence and paragraph boundaries;  
- preserve meaningful lists;  
- preserve product/technology names;  
- preserve negation.

Normalization must not paraphrase source text.

The normalized text hash is stored.

## 6.3 Parser regression fixtures

Maintain a fixture corpus covering:

- clean HTML filings;  
- malformed HTML;  
- plain text;  
- tables embedded in business sections;  
- multi-part filings;  
- amended filings;  
- documents with duplicated sections;  
- non-English text;  
- unusually short descriptions;  
- unusually long descriptions.

Parser changes require fixture diff review.

---

# 7. Chunking and document representation

## 7.1 Chunk schema

Every chunk stores:

~~~text  
chunk_id  
document_id  
entity_id  
section_path  
chunk_index  
character_start  
character_end  
token_start  
token_end  
token_count  
text_hash  
text  
chunker_version  
~~~

## 7.2 Initial chunking configuration

~~~yaml  
target_tokens: 768  
overlap_tokens: 128  
minimum_tokens: 50  
prefer_paragraph_boundaries: true  
prefer_sentence_boundaries: true  
~~~

Hard token slicing is a fallback, not the first choice.

## 7.3 Chunk embeddings

For raw chunk embedding \(e_k\):

\[  
\hat e_k = \frac{e_k}{\\|e_k\\|_2}  
\]

Reject non-finite or near-zero vectors.

## 7.4 Document pooling

Baseline:

\[  
\omega_k = \sqrt{\min(L_k,L_{cap})}  
\]

\[  
e_D =  
\frac{\sum_k \omega_k \hat e_k}  
{\sum_k \omega_k}  
\]

\[  
z_D = \frac{e_D}{\\|e_D\\|_2}  
\]

Default \(L_{cap}\) equals the target chunk length.

Supported experimental pooling:

- uniform mean;  
- token-length mean;  
- square-root-length mean;  
- section-weighted mean;  
- SIF/IDF-style weighting;  
- learned attention pooling.

The baseline must remain simple and reproducible.

---

# 8. Semantic-space preprocessing and anisotropy

Embedding spaces often contain a large common direction. Raw cosine similarities can therefore be high even for economically different companies.

The system stores both raw normalized document embeddings and an analysis embedding.

## 8.1 Raw vector

\[  
z_i^{raw}=Normalize(e_i)  
\]

## 8.2 Analysis vector

A configurable transformation:

\[  
x_i = Normalize\left(W(z_i^{raw}-\mu)\right)  
\]

where \(\mu\) is a reference mean and \(W\) may be identity, whitening, or top-PC removal.

The v1 production baseline should support two modes:

~~~text  
raw_normalized  
centered  
~~~

Do not make full whitening mandatory until robustness is demonstrated.

## 8.3 No unsupervised future leakage

For predictive studies, \(\mu\), PCA, whitening, or any learned preprocessing must be fitted only on information available before the prediction date.

For purely descriptive historical reconstruction, a global frozen reference transform may be reported, but it must be explicitly labeled as ex-post representation and must not be reused in a claimed out-of-sample prediction.

Preferred publication-grade approach:

- fit a frozen reference transform on a pre-specified calibration corpus; or  
- use expanding-window transforms.

Store the fitted transform artifact and hash.

---

# 9. Market data

## 9.1 Security-level monthly fields

~~~text  
security_id  
period  
t0_timestamp  
t1_timestamp  
price_t0  
price_t1  
total_return  
delisting_return_component  
shares_t0  
market_cap_t0  
free_float_market_cap_t0  
currency  
volume_usd  
trading_days_observed  
price_quality_flags[]  
source_snapshot_id  
~~~

## 9.2 Total return

Prefer total return including distributions.

For delisted securities, include terminal/delisting return when available.

A bankrupt or delisted issuer must remain in the historical panel through the economic loss event.

## 9.3 Beginning-of-period size

Canonical economic size is:

\[  
C_{i,t_0}=P_{i,t_0}\times Shares_{i,t_0}  
\]

or a vendor-provided point-in-time market capitalization reconciled to those components.

For global equities, convert beginning capitalization to the configured base currency using the \(t_0\) FX rate. Security return may be calculated in local currency or base currency, but the choice must be explicit and versioned.

## 9.4 Free-float vs total capitalization

If reliable point-in-time free-float data exist, calculate both.

Do not substitute current free float into historical observations.

The default U.S. MVP may use total issuer market capitalization for broader data availability.

---

# 10. Economic weighting: exact interpretation

Define issuer-level beginning capitalization \(C_i\) and total return \(r_i\).

\[  
q_i=C_i r_i  
\]

This is best called **return-attributed value change**, not literal capital flow and not exact accounting market-cap creation.

If shares are constant and return is price return, \(C_i r_i\) equals the price-driven change in capitalization.

With total returns, \(C_i r_i\) also attributes distributions to the investor return.

Issuance, repurchases, option exercise, token minting, token burns, and other supply changes are deliberately excluded from the return-attributed component.

Never define the primary contribution as:

\[  
C_{i,t_1}-C_{i,t_0}  
\]

because that mixes price performance with supply changes.

---

# 11. Canonical semantic states

Let \(x_i\) be the analysis vector.

## 11.1 Market Semantic Baseline (MSB)

Beginning-of-period semantic composition:

\[  
B_t =  
\frac{\sum_i C_i x_i}  
{\sum_i C_i}  
\]

Store both the raw vector and normalized direction.

This answers:

> What does the investable market semantically look like before the month's returns?

It is an essential baseline. Without it, a positive state can simply resemble the market because large companies dominate both.

## 11.2 Value-Creation Semantic State (VCSS)

\[  
q_i^+=C_i\max(r_i,0)  
\]

\[  
M_t^+ =  
\frac{\sum_i q_i^+ x_i}  
{\sum_i q_i^+}  
\]

\[  
U_t^+=Normalize(M_t^+)  
\]

This answers:

> What did entities responsible for positive return-attributed value change semantically look like?

## 11.3 Value-Destruction Semantic State (VDSS)

\[  
q_i^-=C_i\max(-r_i,0)  
\]

\[  
M_t^- =  
\frac{\sum_i q_i^- x_i}  
{\sum_i q_i^-}  
\]

\[  
U_t^-=Normalize(M_t^-)  
\]

This answers:

> What did entities responsible for negative return-attributed value change semantically look like?

## 11.4 Signed Reward State (SRS)

Do not define the economic signed state merely as \(M^+-M^-\), because that gives positive and negative sides equal total importance regardless of their economic magnitude.

Define:

\[  
S_t=  
\frac{\sum_i q_i x_i}  
{\sum_i |q_i|}  
\]

and directional version:

\[  
U_t^{SRS}=Normalize(S_t)  
\]

Let:

\[  
Q_t^+=\sum_i q_i^+  
\qquad  
Q_t^-=\sum_i q_i^-  
\]

Then:

\[  
S_t=  
\frac{Q_t^+}{Q_t^++Q_t^-}M_t^+  
-  
\frac{Q_t^-}{Q_t^++Q_t^-}M_t^-  
\]

This preserves the relative magnitude of value creation and destruction.

Store \(\\|S_t\\|\) rather than discarding it. It contains information about signed semantic coherence.

## 11.5 Contrastive Semantic Direction (CSD)

For discriminative interpretation:

\[  
D_t=M_t^+-M_t^-  
\]

\[  
U_t^{CSD}=Normalize(D_t)  
\]

This intentionally treats the positive and negative semantic distributions symmetrically and asks:

> Which semantic direction most simply separates what gained from what lost?

CSD and SRS must never share the same state_type.

## 11.6 Return-Induced Semantic Tilt (RST)

This is the most direct "semantic portfolio rotation caused by returns" construction.

Start composition:

\[  
B_t^{start}=  
\frac{\sum_i C_i x_i}{\sum_i C_i}  
\]

Counterfactual end composition holding security supply fixed:

\[  
B_t^{end,\*}=  
\frac{\sum_i C_i(1+r_i)x_i}  
{\sum_i C_i(1+r_i)}  
\]

Return-induced tilt:

\[  
T_t=B_t^{end,\*}-B_t^{start}  
\]

\[  
U_t^{RST}=Normalize(T_t)  
\]

This isolates the change in semantic market-cap composition caused by relative returns, rather than issuance or changing share counts.

RST should be a first-class output because it closely matches the idea of the market's semantic portfolio shifting through realized gains and losses.

---

# 12. Robust / breadth estimator

The economic state must remain uncapped. Mega-cap dominance is a feature of the economic measure.

A separate robust estimator answers whether reward is broad.

## 12.1 Cross-sectional robust return score

Let \(r_i^{resid}\) be raw, sector-neutral, or factor-residual return according to configuration.

Compute robust location and scale:

\[  
m_t=Median(r_i^{resid})  
\]

\[  
s_t=1.4826\cdot Median(|r_i^{resid}-m_t|)  
\]

with a minimum positive scale floor.

Define:

\[  
u_i=\frac{r_i^{resid}-m_t}{s_t}  
\]

and:

\[  
h_i=\tanh(u_i/\tau)  
\]

where \(\tau\) is configured.

## 12.2 Size transform

\[  
g(C_i)=\sqrt{C_i}  
\]

or optionally:

\[  
g(C_i)=\log(1+C_i/C_0)  
\]

## 12.3 Robust weight

\[  
a_i=g(C_i)h_i  
\]

Positive and negative robust states are computed separately from positive and negative \(a_i\).

If contribution caps are enabled, use an explicit iterative cap-and-renormalize algorithm. Never clip normalized weights once and leave the total below one.

Pseudo-algorithm:

~~~text  
weights = positive raw weights  
repeat:  
    normalize weights to sum 1  
    freeze entries above cap at cap  
    redistribute remaining mass proportionally across unfrozen entries  
until no entry exceeds cap or all entries are frozen  
~~~

Store whether the cap was binding and how many observations were capped.

---

# 13. Sector-neutral and factor-residual states

Raw return states can be dominated by sector rotation.

Sector neutralization must use the point-in-time sector classification valid at \(t_0\), as specified in Section 85. The residual definition is estimator-specific and must be encoded in the state ID.

For the **economic** sector-neutral state, use the beginning-capitalization-weighted sector return:

\[
\bar r_{s,t}^{cap}
=
\frac{\sum_{i\in s} C_i r_i}
{\sum_{i\in s} C_i}
\]

and:

\[
\epsilon_i^{sector,cap}
=
r_i-\bar r_{s(i),t}^{cap}
\]

For the **robust/breadth** sector-neutral state, a sector median may be used:

\[
\epsilon_i^{sector,median}
=
r_i-Median(r_j:j\in s(i))
\]

These two residual definitions are not interchangeable and must never share a state ID, estimator version, or interpretation.

Publication-grade research should also support residual returns from a pre-specified factor model.

Controls may include:

- market beta;
- size;
- value;
- momentum;
- profitability;
- investment;
- industry/sector fixed effects.

Factor-model specification, preprocessing, estimation window, and residual convention must be versioned. Do not estimate a flexible factor model separately for every desired result after seeing the semantic output.

---

# 14. State diagnostics

Every state is published with diagnostics.

## 14.1 Semantic drift

\[  
SD_t=1-\cos(U_t,U_{t-1})  
\]

Do not invent qualitative thresholds before observing the empirical distribution.

## 14.2 Winner-loser separation

\[  
WLS_t=1-\cos(U_t^+,U_t^-)  
\]

If positive and negative states are nearly identical, the semantic representation may explain little of that month's cross-sectional outcome.

## 14.3 Value-breadth divergence

\[  
VBD_t=1-\cos(U_t^{economic},U_t^{robust})  
\]

## 14.4 State coherence

For nonnegative normalized weights \(w_i\):

\[  
Coherence_t=\left\\|\sum_i w_i x_i\right\\|_2  
\]

Interpretation depends on preprocessing and semantic space. Compare coherence only within the same semantic-space version.

## 14.5 Effective contributor count

\[  
\pi_i=\frac{|q_i|}{\sum_j|q_j|}  
\]

\[  
N_{eff}=\frac{1}{\sum_i \pi_i^2}  
\]

## 14.6 Contribution concentration

Store:

- largest contributor share;  
- top-5 share;  
- top-10 share;  
- top-25 share;  
- Herfindahl index of absolute contribution weights.

## 14.7 Sector concentration

For sector \(k\):

\[  
p_k=  
\frac{\sum_{i\in k}|q_i|}  
{\sum_j|q_j|}  
\]

\[  
HHI_{sector}=\sum_k p_k^2  
\]

## 14.8 Coverage

Store:

- eligible entities;  
- entities with admissible documents;  
- entities with valid embeddings;  
- entities with market data;  
- entities included in final state;  
- fraction of beginning market cap represented;  
- document-age distribution;  
- missing-data reason distribution.

---

# 15. Contribution accounting

Every published **linear aggregation state** has an immutable contribution table whose coefficients exactly reconstruct the stored pre-normalization vector.

Regression directions and other fitted/model-derived outputs use immutable fit artifacts rather than being forced into an entity-weight table. Section 18 defines that separate reconstruction path.

## 15.1 Canonical contribution schema

Minimum schema:

~~~text
run_id
period
state_id
state_type
estimator_version
state_component
entity_id
document_id
semantic_space_id
return_type
return_value
market_cap_t0
basis_weight
score_value
numerator_weight
normalization_denominator
normalized_coefficient
embedding_norm
state_alignment
absolute_coefficient_share
sector
industry
rank
quality_flags[]
~~~

Definitions:

- `basis_weight` is the economic or robust size term before the return/residual transform.
- `score_value` is the return, excess return, residual return, robust score, or other explicitly versioned state score.
- `numerator_weight` is the signed or unsigned scalar multiplying the entity vector before normalization.
- `normalization_denominator` is the scalar denominator for the relevant state component.
- `normalized_coefficient` is the final signed scalar multiplying \(x_i\) in the stored linear state.
- `state_component` distinguishes multi-component constructions such as `positive`, `negative`, `contrastive_positive`, `contrastive_negative`, or another explicitly versioned component.
- `absolute_coefficient_share` is computed from absolute final coefficients and is used for concentration diagnostics; it is not a substitute for the signed coefficient.

## 15.2 Exact reconstruction contract

For every linear aggregation state:

\[
M_t^{raw}
=
\sum_i \alpha_{i,t} x_i
\]

where:

\[
\alpha_{i,t}=normalized\_coefficient_{i,t}
\]

The contribution table must satisfy:

\[
StoredRawVector_t
\approx
\sum_i normalized\_coefficient_{i,t} x_i
\]

within the centrally configured float64 numerical tolerance.

If the published state also exposes a normalized direction:

\[
U_t=Normalize(M_t^{raw})
\]

the normalized direction is reconstructed only after the raw vector passes reconciliation.

Examples:

**MSB**

\[
\alpha_i=\frac{C_i}{\sum_j C_j}
\]

**VCSS**

\[
\alpha_i=\frac{q_i^+}{\sum_j q_j^+}
\]

**VDSS**

\[
\alpha_i=\frac{q_i^-}{\sum_j q_j^-}
\]

**SRS**

\[
\alpha_i=\frac{q_i}{\sum_j |q_j|}
\]

**CSD**

\[
\alpha_i=
\frac{q_i^+}{\sum_j q_j^+}
-
\frac{q_i^-}{\sum_j q_j^-}
\]

with positive and negative component rows retained separately when needed for auditability.

**RST**

Using the exact market-relative decomposition from Section 84:

\[
\alpha_i
=
\frac{p_i(r_i-\bar r_t)}
{1+\bar r_t}
\]

for the raw return-induced tilt when the denominator is valid.

The same reconstruction pattern applies to market-relative, sector-neutral, factor-residual, and robust linear states using their explicitly versioned numerator and denominator definitions.

## 15.3 Nonlinear and model-derived outputs

Clustering assignments, bootstrap distributions, null distributions, and regression directions are not misrepresented as simple entity-weighted centroids.

They must be reconstructible from the appropriate immutable artifacts:

~~~text
input snapshot IDs
semantic_space_id
feature/reducer artifact
design matrix or deterministic recipe
estimator configuration
hyperparameters
random seed derivation
fitted parameters
software/code version
~~~

For regression, the stored reduced-space coefficients and the frozen reducer must reproduce the reported regression semantic direction.

Aggregation uses float64 even if embeddings are stored as float32.

---

# 16. Semantic alignment and explanatory contribution

For normalized state direction \(U_t\):

\[  
Alignment_{i,t}=\cos(x_i,U_t)  
\]

A useful explanation score is:

\[  
ExplanationScore_{i,t}  
=  
|q_i|\max(Alignment_{i,t},0)  
\]

This is for evidence ranking, not state construction.

Do not rank explanatory assets by return alone.

---

# 17. Multimodality and clustering

A single centroid can create a semantic chimera when several unrelated themes are rewarded simultaneously. However, the system must not assume multimodality merely because a clustering algorithm is available.

The positive distribution therefore receives a **cluster-decomposition test**, which may validly conclude that no multi-cluster decomposition is supported.

## 17.1 Baseline algorithm

Use weighted spherical k-means over analysis vectors \(x_i\), weighted by positive economic or robust weights, only after basic contributor-count and weight-support gates pass.

Candidate models:

~~~yaml
allow_no_cluster: true
k_min_if_clustered: 2
k_max: 10
~~~

`no_cluster` is an explicit candidate and represents one undivided rewarded mode. It is not treated as an error.

The effective maximum \(k\) must also respect sample size, effective contributor count, and minimum cluster-size constraints.

## 17.2 Model selection

Select between `no_cluster` and admissible \(k \ge 2\) solutions using a pre-specified combination of:

- weighted silhouette or another geometry-appropriate separation statistic;
- bootstrap cluster stability;
- minimum cluster weight;
- minimum entity count;
- improvement over the undivided/null decomposition;
- parsimony.

A multi-cluster solution is accepted only if it clears the configured evidence gates. Otherwise publish `no_cluster`.

Do not choose \(k\) solely because a larger value produces more interesting narratives, and do not force \(k=2\) when the geometry does not support a split.

## 17.3 Cluster eligibility

Default generation gate:

~~~yaml
minimum_entities: 10
minimum_weight_share: 0.05
minimum_bootstrap_stability: 0.60
~~~

Thresholds are configuration and require calibration.

A cluster that fails the generation gate may remain available as a quantitative diagnostic if the quantitative clustering gate passed; it must not receive a confident archetype merely because it exists.

## 17.4 Cluster weight

\[
W_{k,t}=
\frac{\sum_{i\in k}q_i^+}
{\sum_iq_i^+}
\]

For non-VCSS clustering families, replace \(q_i^+\) with the explicitly configured positive clustering weight and record that weight definition in the cluster artifact.

## 17.5 Persistent cluster IDs

Compute cosine similarity between previous and current centroids and solve a maximum-weight bipartite assignment, subject to a minimum continuation-similarity gate.

Store:

~~~text
cluster_instance_id
persistent_cluster_id
period
parent_cluster_ids[]
centroid
weight_share
entity_count
similarity_previous
status
~~~

Initial statuses:

~~~text
new
continuing
disappeared
~~~

A rejected `no_cluster` period does not fabricate cluster identities. Split/merge semantics may be added after the simple matcher is validated.

Cluster labels are generated after clustering from evidence; labels never influence cluster membership.

---

# 18. Regression semantic direction

Centroids answer what contributors look like. Regression asks which semantic dimensions distinguish returns after controls.

## 18.1 Dimensionality reduction

Fit PCA or another linear reducer on an admissible calibration corpus.

\[  
v_i=P^\top x_i  
\]

Initial dimension:

~~~yaml  
regression_dimensions: 128  
~~~

The reducer is versioned and point-in-time safe for predictive work.

## 18.2 Cross-sectional estimator

\[  
r_i=  
\alpha+  
v_i^\top\beta+  
c_i^\top\gamma+  
\epsilon_i  
\]

Use ridge regression as the initial estimator.

Controls \(c_i\) may include sector indicators and conventional characteristics.

Store:

~~~text  
regression_state_vector  
coefficient_vector_reduced  
intercept  
regularization  
controls_version  
sample_size  
r2  
cross_validated_r2  
~~~

Do not call \(\beta\) a centroid.

## 18.3 Interpretation

- Positive centroid: what positive economic contributors resemble.  
- Contrastive direction: what differentiates positive and negative semantic distributions.  
- Regression direction: which semantic dimensions are associated with cross-sectional return conditional on specified controls.  
- RST: how market semantic composition changed because of returns.

These are complementary, not interchangeable.

---

# 19. Distributional semantic state

A mean vector loses information.

The v1 system stores enough information to later support a distributional representation:

\[  
\mathcal{P}_t=\\{(x_i,w_i)\\}  
\]

Possible future distances include:

- energy distance;  
- maximum mean discrepancy;  
- sliced Wasserstein distance;  
- optimal transport over semantic clusters.

Do not block the MVP on these methods, but do not discard the weighted entity-level distribution required to compute them later.

---

# 20. Evidence retrieval

Synthetic interpretation is retrieval-grounded.

For a state or cluster:

1. rank economically important entities;  
2. calculate entity alignment with the target state;  
3. retrieve semantically aligned chunks from admissible documents;  
4. diversify across entities;  
5. optionally diversify across sectors;  
6. produce a bounded evidence package.

Default limits:

~~~yaml  
max_entities_per_state: 30  
max_passages_per_state: 80  
max_passages_per_entity: 3  
minimum_distinct_entities: 8  
~~~

Each evidence record stores:

~~~text  
evidence_id  
run_id  
period  
state_id  
cluster_id  
entity_id  
document_id  
chunk_id  
chunk_text_hash  
state_similarity  
entity_weight  
entity_contribution_share  
retrieval_score  
section_path  
~~~

---

# 21. LLM safety and untrusted source text

Documents are data, not instructions.

When evidence is supplied to a language model:

- delimit evidence as quoted/untrusted source material;  
- explicitly instruct the model not to follow commands found inside evidence;  
- do not expose secrets, credentials, internal system prompts, or tool permissions;  
- disable arbitrary tool execution for the synthesis step unless separately justified;  
- do not allow retrieved text to select external URLs or trigger network requests;  
- validate model output against a strict schema;  
- retain evidence IDs for every claim.

This protects the system from prompt-injection text embedded in filings, websites, or project documentation.

---

# 22. Structured semantic profile

Before prose generation, create a structured profile.

Example schema:

~~~json  
{  
  "period": "YYYY-MM",  
  "state_type": "positive_economic",  
  "core_business_models": \[\],  
  "technologies": \[\],  
  "products_services": \[\],  
  "customer_types": \[\],  
  "revenue_models": \[\],  
  "infrastructure_requirements": \[\],  
  "economic_exposures": \[\],  
  "operating_characteristics": \[\],  
  "contrastive_characteristics": \[\],  
  "uncertain_characteristics": \[\],  
  "evidence_ids": \[\]  
}  
~~~

Each characteristic contains:

~~~json  
{  
  "label": "...",  
  "description": "...",  
  "support_weight": 0.0,  
  "supporting_entities": 0,  
  "supporting_passages": 0,  
  "evidence_ids": \[\],  
  "confidence": "low|medium|high"  
}  
~~~

Confidence is based on explicit support rules, not the language model's self-reported certainty.

---

# 23. Synthetic Representative Archetype

The system does not invert an embedding. There is no unique text corresponding to an embedding vector.

The SRA pipeline is:

~~~text  
state / cluster  
    → contribution ranking  
    → passage retrieval  
    → evidence diversification  
    → structured characteristic extraction  
    → support validation  
    → constrained prose generation  
    → claim/evidence validation  
~~~

Preferred titles:

~~~text  
Synthetic Market-Rewarded Archetype — YYYY-MM  
Synthetic Market-Penalized Archetype — YYYY-MM  
Reward Cluster Archetype — <cluster label> — YYYY-MM  
~~~

Avoid presenting the output as a real company.

Generation constraints:

- no invented revenue;  
- no invented valuation;  
- no invented market share;  
- no invented customers;  
- no invented geography;  
- no invented technologies;  
- no real ticker;  
- no claim that the synthetic company earned the observed market return;  
- no causal claim that a characteristic caused the return;  
- no unsupported superlatives;  
- no long copied source passages.

When evidence is weak or contradictory, the generator must abstain or express uncertainty.

---

# 24. Claim-level provenance and validation

Generated prose is represented internally as claims.

~~~json  
{  
  "claim_id": "...",  
  "text": "...",  
  "evidence_ids": \["..."\],  
  "supporting_entities": 0,  
  "support_weight": 0.0,  
  "validator_status": "supported|partial|unsupported|conflicted"  
}  
~~~

Only supported or explicitly qualified partial claims may appear in the default user-facing SRA.

An automated validator should check:

- all evidence IDs exist;  
- evidence belongs to the same run/state;  
- evidence documents were admissible at \(t_0\);  
- claimed attributes appear in supporting passages;  
- unsupported numerical facts are absent.

Optional NLI/LLM claim validation may be used as a secondary check, never as the sole provenance mechanism.

---

# 25. Storage architecture

A research-grade MVP does not need a complex distributed platform.

Recommended baseline:

- object storage for raw immutable documents;  
- Parquet for analytical tables;  
- DuckDB for local/research analytics;  
- PostgreSQL for metadata/run registry if multi-user service operation is needed;  
- vector index only when passage-retrieval latency justifies it.

A dedicated vector database is optional.

## 25.1 Data zones

~~~text  
raw/  
  source artifacts exactly as retrieved

normalized/  
  parsed and normalized immutable text

features/  
  chunks, embeddings, transforms

market/  
  security and issuer market panels

states/  
  contribution tables, vectors, diagnostics, clusters

evidence/  
  retrieval packages and claim provenance

generation/  
  structured profiles and SRA outputs

manifests/  
  immutable run manifests  
~~~

---

# 26. Core data contracts

## 26.1 issuers

~~~text  
issuer_id: string  
canonical_name: string  
country: string?  
sector_id: string?  
industry_id: string?  
valid_from: timestamp  
valid_to: timestamp?  
~~~

## 26.2 securities

~~~text  
security_id: string  
issuer_id: string  
security_type: string  
share_class: string?  
exchange: string?  
currency: string  
valid_from: timestamp  
valid_to: timestamp?  
~~~

## 26.3 security_identifiers

~~~text  
security_id  
identifier_type  
identifier_value  
valid_from  
valid_to  
source  
~~~

## 26.4 documents

~~~text  
document_id  
entity_id  
document_type  
source_name  
source_locator  
published_at  
filed_at  
source_available_at  
first_seen_at  
retrieved_at  
available_at  
language  
raw_content_hash  
normalized_content_hash  
parser_version  
document_policy_version  
~~~

## 26.5 document_chunks

~~~text  
chunk_id  
document_id  
entity_id  
section_path  
chunk_index  
character_start  
character_end  
token_start  
token_end  
token_count  
text_hash  
chunker_version  
~~~

## 26.6 embeddings

~~~text  
object_id  
object_type  
semantic_space_id  
embedding  
embedding_dimension  
storage_dtype  
embedding_norm  
created_at  
~~~

## 26.7 market_security_monthly

~~~text  
security_id  
period  
t0_timestamp  
t1_timestamp  
total_return  
market_cap_t0  
shares_t0  
volume_usd  
currency  
quality_flags  
source_snapshot_id  
~~~

## 26.8 market_entity_monthly

~~~text  
entity_id  
period  
market_cap_t0  
aggregate_total_return  
return_attributed_value_change  
security_count  
quality_flags  
~~~

## 26.9 semantic_states

~~~text  
run_id  
period  
state_id  
state_type  
semantic_space_id  
vector  
vector_norm  
entity_count  
effective_n  
coherence  
created_at  
~~~

## 26.10 semantic_contributions

Use the schema in Section 15.

## 26.11 semantic_clusters

~~~text  
run_id  
period  
cluster_instance_id  
persistent_cluster_id  
state_id  
centroid  
weight_share  
entity_count  
stability  
status  
~~~

---

# 27. Repository structure

~~~text  
market-semantic-portfolio/  
├── README.md  
├── pyproject.toml  
├── uv.lock  
├── Makefile  
├── .env.example  
├── config/  
│   ├── base.yaml  
│   ├── equities_us.yaml  
│   ├── crypto.yaml  
│   └── experiments/  
├── schemas/  
│   ├── assets/  
│   ├── documents/  
│   ├── market/  
│   ├── states/  
│   └── generation/  
├── src/misp/  
│   ├── identity/  
│   │   ├── issuers.py  
│   │   ├── securities.py  
│   │   ├── corporate_actions.py  
│   │   └── crypto_identity.py  
│   ├── universe/  
│   │   ├── eligibility.py  
│   │   ├── equities.py  
│   │   └── crypto.py  
│   ├── documents/  
│   │   ├── ingest.py  
│   │   ├── availability.py  
│   │   ├── parsing.py  
│   │   ├── sections.py  
│   │   ├── normalization.py  
│   │   └── chunking.py  
│   ├── semantics/  
│   │   ├── encoder.py  
│   │   ├── pooling.py  
│   │   ├── transforms.py  
│   │   └── store.py  
│   ├── market/  
│   │   ├── calendars.py  
│   │   ├── prices.py  
│   │   ├── returns.py  
│   │   ├── capitalization.py  
│   │   ├── delistings.py  
│   │   └── issuer_aggregation.py  
│   ├── states/  
│   │   ├── baseline.py  
│   │   ├── economic.py  
│   │   ├── signed.py  
│   │   ├── contrastive.py  
│   │   ├── tilt.py  
│   │   ├── robust.py  
│   │   ├── residual.py  
│   │   └── diagnostics.py  
│   ├── clusters/  
│   │   ├── weighted_spherical.py  
│   │   ├── selection.py  
│   │   └── persistence.py  
│   ├── regression/  
│   │   ├── reduction.py  
│   │   ├── ridge.py  
│   │   └── controls.py  
│   ├── evidence/  
│   │   ├── contributors.py  
│   │   ├── retrieval.py  
│   │   └── diversify.py  
│   ├── generation/  
│   │   ├── schema.py  
│   │   ├── profile.py  
│   │   ├── archetype.py  
│   │   ├── provenance.py  
│   │   └── validation.py  
│   ├── validation/  
│   │   ├── point_in_time.py  
│   │   ├── reconciliation.py  
│   │   ├── bootstrap.py  
│   │   ├── permutations.py  
│   │   └── robustness.py  
│   ├── pipeline/  
│   │   ├── monthly.py  
│   │   ├── backfill.py  
│   │   └── manifests.py  
│   ├── api/  
│   │   ├── models.py  
│   │   └── routes.py  
│   └── cli.py  
├── tests/  
│   ├── unit/  
│   ├── property/  
│   ├── integration/  
│   ├── regression/  
│   └── fixtures/  
├── notebooks/  
│   └── exploratory_only/  
└── docs/  
    ├── methodology.md  
    ├── data_dictionary.md  
    └── operations.md  
~~~

Canonical calculations live in src/, never only in notebooks.

---

# 28. Python interfaces

Use typed interfaces. Example shapes:

~~~python  
@dataclass(frozen=True)  
class Period:  
    label: str  
    t0: datetime  
    t1: datetime

@dataclass(frozen=True)  
class EntityObservation:  
    entity_id: str  
    document_id: str  
    vector: NDArray\[np.float32\]  
    market_cap_t0: float  
    total_return: float  
    sector_id: str | None

@dataclass(frozen=True)  
class SemanticState:  
    state_id: str  
    state_type: str  
    vector: NDArray\[np.float64\]  
    norm: float  
    entity_count: int  
    diagnostics: Mapping\[str, float\]  
~~~

Core pure functions:

~~~python  
def aggregate_issuer_market_data(  
    securities: DataFrame,  
) -> DataFrame: ...

def positive_state(  
    vectors: NDArray,  
    market_cap_t0: NDArray,  
    returns: NDArray,  
) -> StateResult: ...

def negative_state(... ) -> StateResult: ...

def signed_reward_state(... ) -> StateResult: ...

def return_induced_tilt(... ) -> StateResult: ...

def robust_state(... ) -> StateResult: ...

def reconcile_state(  
    state: StateResult,  
    contributions: DataFrame,  
    atol: float = 1e-10,  
) -> None: ...  
~~~

State functions should be pure: no database access, no network calls, no hidden global configuration.

---

# 29. Monthly build

Canonical high-level flow:

~~~python  
def build_month(period: Period, cfg: Config) -> PublishedMonth:  
    run = create_run_manifest(period, cfg)

    securities = universe.as_of(period.t0)  
    issuers = identity.resolve_issuers(securities, period.t0)

    docs = documents.latest_admissible(  
        entity_ids=issuers.entity_id,  
        available_at_or_before=period.t0,  
        policy=cfg.document_policy,  
    )

    vectors = semantics.load_or_build(  
        documents=docs,  
        semantic_space=cfg.semantic_space,  
    )

    market_security = market.load_period(  
        security_ids=securities.security_id,  
        t0=period.t0,  
        t1=period.t1,  
    )

    market_entity = aggregate_issuer_market_data(market_security)

    panel = build_validated_entity_panel(  
        issuers=issuers,  
        documents=docs,  
        vectors=vectors,  
        market=market_entity,  
    )

    states = compute_all_states(panel, cfg)  
    diagnostics = compute_diagnostics(panel, states, cfg)  
    clusters = compute_clusters(panel, states, cfg)  
    regression = compute_regression_states(panel, cfg)

    validate_quantitative_outputs(  
        panel, states, diagnostics, clusters, regression, run  
    )

    evidence = retrieve_evidence(panel, states, clusters, cfg)  
    archetypes = generate_and_validate_archetypes(  
        evidence=evidence,  
        states=states,  
        clusters=clusters,  
        cfg=cfg,  
    )

    publish_atomically(  
        run=run,  
        panel=panel,  
        states=states,  
        diagnostics=diagnostics,  
        clusters=clusters,  
        regression=regression,  
        evidence=evidence,  
        archetypes=archetypes,  
    )

    return PublishedMonth(run.run_id)  
~~~

Quantitative publication must be possible even if generation fails.

---

# 30. Job graph and idempotency

Independent jobs:

~~~text  
sync_identity  
sync_security_history  
sync_corporate_actions  
ingest_documents  
parse_documents  
normalize_documents  
chunk_documents  
embed_chunks  
pool_documents  
fit_semantic_transform  
ingest_market_data  
aggregate_entity_market_data  
build_monthly_panel  
calculate_states  
calculate_diagnostics  
calculate_clusters  
calculate_regression  
run_statistical_validation  
retrieve_evidence  
generate_profiles  
generate_archetypes  
validate_generation  
publish_month  
~~~

Every job is idempotent.

Use hashes and version IDs to skip unchanged work.

A retry must not create duplicate canonical records.

---

# 31. Run manifests and artifact lineage

Quantitative measurement and optional language-model generation have separate immutable manifests.

## 31.1 Quantitative run manifest

Every quantitative run has an immutable manifest.

~~~json
{
  "run_id": "...",
  "period": "YYYY-MM",
  "created_at": "...",
  "git_commit": "...",
  "config_hash": "...",
  "code_version": "...",
  "universe_version": "...",
  "identity_snapshot": "...",
  "document_snapshot": "...",
  "document_policy_version": "...",
  "parser_version": "...",
  "chunker_version": "...",
  "semantic_space_id": "...",
  "semantic_transform_id": "...",
  "market_data_snapshot": "...",
  "return_method_version": "...",
  "weighting_version": "...",
  "state_estimator_version": "...",
  "cluster_version": "...",
  "regression_version": "...",
  "statistical_validation_version": "...",
  "random_seed": 42
}
~~~

The quantitative `run_id` must not change merely because an archetype is regenerated with another model or prompt.

## 31.2 Downstream retrieval/generation manifest

Evidence retrieval and generation create child artifacts linked to an immutable quantitative run.

~~~json
{
  "generation_run_id": "...",
  "parent_run_id": "...",
  "created_at": "...",
  "retrieval_version": "...",
  "retrieval_config_hash": "...",
  "evidence_package_hash": "...",
  "generation_model": "...",
  "generation_model_revision": "...",
  "generation_prompt_version": "...",
  "generation_schema_version": "...",
  "validator_version": "...",
  "generation_seed": 42,
  "status": "VALIDATED"
}
~~~

A new retrieval policy, model, prompt, validator, or generation attempt creates a new child manifest and never mutates the parent quantitative run.

If a quantitative result cannot be reproduced from its quantitative manifest and immutable source snapshots, it is not publication-grade. If a generated result cannot be reproduced/audited from its child manifest, parent run, evidence package, and retained model metadata to the extent the model provider permits deterministic reproduction, it is not generation-auditable.

---

# 32. Configuration discipline

No methodological constant is buried in code.

~~~yaml  
project:  
  asset_class: equity  
  frequency: monthly  
  base_currency: USD

universe:  
  version: equity_us_v1  
  exclude_funds: true  
  exclude_spacs_pre_combination: true  
  exclude_preferred: true  
  aggregate_share_classes_to_issuer: true

documents:  
  policy: annual_business_description_v1  
  availability_rule: at_or_before_t0

chunking:  
  target_tokens: 768  
  overlap_tokens: 128  
  minimum_tokens: 50

semantic_space:  
  id: semantic_v1  
  embedding_model: "<PINNED_MODEL>"  
  embedding_revision: "<PINNED_REVISION>"  
  pooling: sqrt_length_mean  
  transform: centered  
  output_normalization: l2

economic_state:  
  size: total_market_cap_t0  
  return: total_return

robust_state:  
  size_transform: sqrt  
  return_transform: tanh_robust_z  
  tau: 2.0  
  contribution_cap: 0.025

clustering:  
  allow_no_cluster: true  
  k_min_if_clustered: 2  
  k_max: 10  
  minimum_entities: 10  
  minimum_weight_share: 0.05

retrieval:  
  max_entities: 30  
  max_passages: 80  
  max_passages_per_entity: 3

random_seed: 42  
~~~

Values in angle brackets are deployment decisions, not silently assumed defaults.

---

# 33. Numerical requirements

- Store embeddings as float32 unless a model requires otherwise.  
- Convert vectors and weights to float64 for aggregation.  
- Reject NaN and infinity before state calculation.  
- Reject negative beginning market cap.  
- Define explicit behavior for zero denominators.  
- Use stable summation where practical for large universes.  
- Record tolerances centrally.

If a positive or negative side has zero total weight, the corresponding state is null with a reason code. Do not fabricate a zero vector and normalize it.

---

# 34. Property-based tests

The quantitative engine should satisfy mathematical properties.

## 34.1 Permutation invariance

Reordering entities cannot change a state beyond numerical tolerance.

## 34.2 Common size-scale invariance

Multiplying every \(C_i\) by the same positive constant cannot change normalized economic states.

## 34.3 Zero-return neutrality

An entity with \(r_i=0\) contributes zero to positive, negative, and signed reward states.

## 34.4 Issuer split invariance

Splitting one issuer's market capitalization into two otherwise identical securities with the same return must not change the issuer-level state after security-to-issuer aggregation.

## 34.5 Identical-vector behavior

If all entities have the same normalized vector, positive and negative centroids are identical whenever both exist, and the contrastive vector is zero/undefined.

## 34.6 Sign symmetry

Negating every return swaps positive and negative states and negates the signed reward state, subject to numerical tolerance.

## 34.7 Contribution reconciliation

Reconstructed state from stored contribution rows equals the stored state.

## 34.8 Deterministic rerun

Same immutable inputs, config, semantic space, and seed produce identical quantitative outputs.

---

# 35. Point-in-time tests

Permanent fixture:

~~~text  
Issuer A  
document_v1 available before period A t0  
document_v2 available after period A t0 but before period A t1  
~~~

Expected:

~~~text  
period A → document_v1  
next eligible period → document_v2  
~~~

Also test a filing released exactly at t0 according to the configured inclusive/exclusive boundary.

The boundary convention must be explicit and consistent.

---

# 36. Survivorship and delisting tests

Fixtures include:

- surviving issuer;  
- acquired issuer;  
- bankrupt issuer;  
- delisted issuer;  
- ticker-reused issuer;  
- dual-class issuer.

Historical states must contain each entity whenever historically eligible.

The current security master cannot be used as the historical universe.

---

# 37. Corporate-action tests

Test:

- stock split;  
- reverse split;  
- special dividend;  
- spin-off;  
- share issuance;  
- repurchase;  
- merger;  
- share-class conversion.

The return-attributed contribution should reflect investor return without treating mechanical share-count changes as semantic reward.

---

# 38. Null models

Implement null distributions before interpreting semantic structure.

## 38.1 Global return shuffle

Shuffle returns among entities within month.

## 38.2 Sector-constrained shuffle

Shuffle within:

~~~text  
period × sector  
~~~

## 38.3 Sector-size constrained shuffle

Preferred baseline:

~~~text  
period × sector × size_bucket  
~~~

## 38.4 Document shuffle

Randomly reassign entity documents while preserving market observations.

## 38.5 Geometry controls and embedding-destruction nulls

A single common orthogonal rotation of every embedding preserves dot products and cosine geometry. It is therefore an **implementation invariance test**, not a semantic-destruction null.

Use common orthogonal rotation to verify that geometry-only calculations are invariant to coordinate basis.

Valid geometry-destroying controls include independently generated random unit vectors matched in dimension and independently permuted embedding assignments. Document-to-entity and return permutations remain the primary semantic/economic nulls.

For every statistical null, reconstruct the complete statistic being tested rather than comparing only individual weights. Keep invariance tests and null-distribution tests in separate suites.

---

# 39. Required baselines

Compare against:

- equal-weight winner centroid;  
- market-cap baseline;  
- sector allocation;  
- industry allocation;  
- TF-IDF representation;  
- bag-of-words representation;  
- topic-model representation;  
- random document assignment;  
- shuffled returns;  
- predefined thematic labels where available.

The system is not validated because an LLM-generated archetype sounds plausible.

---

# 40. Bootstrap stability

For each month/state:

1. resample entities with replacement;  
2. preferably stratify by sector and size;  
3. recompute the state;  
4. repeat;  
5. calculate similarity and metric distributions.

Store:

~~~text  
bootstrap_iterations  
bootstrap_mean_similarity  
bootstrap_p05  
bootstrap_p50  
bootstrap_p95  
~~~

Run leave-contributor-out stress tests:

~~~text  
remove largest  
remove top 5  
remove top 10  
remove top 25  
~~~

Recalculate state direction and diagnostics.

---

# 41. Embedding robustness

At minimum, selected historical periods must be recomputed using:

- primary embedding model;  
- one independent embedding family;  
- raw normalized vectors;  
- centered vectors;  
- at least one alternate pooling strategy.

Compare:

- state cosine similarity;  
- cluster stability;  
- top contributors;  
- retrieved evidence;  
- temporal drift ranking.

Do not claim a semantic phenomenon that exists only in one fragile representation.

---

# 42. Statistical inference and multiple testing

For exploratory metrics, report uncertainty rather than binary significance alone.

When testing many semantic signals, horizons, universes, or embedding variants:

- pre-register primary tests when possible;  
- distinguish confirmatory from exploratory tests;  
- control false discovery rate or use family-wise corrections where appropriate;  
- report all tested variants, not only successful ones;  
- retain experiment manifests.

Prediction research must use walk-forward/out-of-sample evaluation.

---

# 43. Predictive extensions are a separate package

Descriptive state:

~~~text  
returns during t  
→ state describing t  
~~~

Prediction:

~~~text  
information available through t  
→ returns after t  
~~~

Potential features:

\[  
Alignment_{i,t}=\cos(x_{i,t},U_t)  
\]

\[  
RotationExposure_{i,t}=x_{i,t}^\top(U_t-U_{t-1})  
\]

\[  
ClusterExposure_{i,k,t}=\cos(x_{i,t},C_{k,t})  
\]

\[  
SemanticMomentum_t=\cos(U_t,U_{t-1})  
\]

Prediction code lives separately and cannot alter descriptive state construction.

---

# 44. API surface

Suggested read API:

~~~text  
GET /v1/runs/{run_id}  
GET /v1/periods/{period}/states  
GET /v1/periods/{period}/states/{state_type}  
GET /v1/periods/{period}/contributors  
GET /v1/periods/{period}/diagnostics  
GET /v1/periods/{period}/clusters  
GET /v1/clusters/{persistent_cluster_id}/history  
GET /v1/entities/{entity_id}/semantic-history  
GET /v1/periods/{period}/archetypes  
GET /v1/periods/{period}/evidence  
~~~

Responses include run_id, semantic_space_id, methodology version, and data-coverage metadata.

Do not serve "latest" without also returning the exact immutable run ID.

---

# 45. CLI

Suggested commands:

~~~text  
misp identity sync  
misp documents ingest --through <timestamp>  
misp documents parse  
misp semantics embed --space semantic_v1  
misp market ingest --period <YYYY-MM>  
misp build month <YYYY-MM>  
misp validate month <YYYY-MM>  
misp backfill --start <YYYY-MM> --end <YYYY-MM>  
misp compare-runs <run_a> <run_b>  
misp explain state <run_id> <state_type>  
~~~

Every mutating command supports dry-run where practical.

---

# 46. Publication gate

A month cannot become published unless critical checks pass.

Required:

- point-in-time document invariant passes;  
- historical universe invariant passes;  
- issuer/security mapping is valid;  
- no duplicated issuer observations;  
- all included vectors match semantic-space dimension;  
- vectors and weights are finite;  
- beginning capitalization is valid;  
- positive/negative weights reconcile;  
- signed state reconciles;  
- RST start/end weights reconcile;  
- contribution tables reproduce stored vectors;  
- cluster shares reconcile;  
- coverage report exists;  
- run manifest exists;  
- source snapshot IDs exist;  
- quantitative output is persisted before generation;  
- generated output, if published, has evidence provenance.

Generation failure must not invalidate a valid quantitative state.

---

# 47. Atomic publication

Use a two-phase status:

~~~text  
BUILDING  
VALIDATED  
PUBLISHED  
FAILED  
~~~

Write artifacts under a run-specific temporary namespace.

Only after validation succeeds should a single metadata transaction mark the run PUBLISHED.

Readers never see partially written canonical states.

---

# 48. Observability

Structured logs:

~~~text  
timestamp  
run_id  
job_name  
period  
entity_id?  
document_id?  
duration_ms  
status  
error_code?  
retry_count  
~~~

Metrics:

- documents ingested;  
- parser failures;  
- embedding cache hit rate;  
- market-data coverage;  
- state build duration;  
- invalid-vector count;  
- contribution reconciliation error;  
- cluster stability;  
- generation support failure rate.

Alerts should target invariant failures, not merely job duration.

---

# 49. Error handling

Classify errors:

~~~text  
SOURCE_UNAVAILABLE  
SOURCE_SCHEMA_CHANGED  
DOCUMENT_PARSE_FAILED  
DOCUMENT_AVAILABILITY_UNKNOWN  
IDENTITY_AMBIGUOUS  
MARKET_DATA_MISSING  
MARKET_DATA_INVALID  
VECTOR_INVALID  
SEMANTIC_SPACE_MISMATCH  
STATE_ZERO_DENOMINATOR  
RECONCILIATION_FAILED  
CLUSTER_UNSTABLE  
GENERATION_UNSUPPORTED_CLAIM  
~~~

Errors that can bias a historical state should fail closed.

Do not silently impute identity, availability timestamp, return, or market cap.

---

# 50. Data quality report

Every run publishes a machine-readable quality report.

Example fields:

~~~text  
eligible_entities  
entities_with_documents  
entities_with_vectors  
entities_with_market_data  
final_entities  
beginning_market_cap_coverage  
median_document_age_days  
p95_document_age_days  
missing_document_count  
missing_market_data_count  
identity_ambiguity_count  
largest_contributor_share  
top10_contributor_share  
effective_n  
~~~

A human-readable report may be generated from this object.

---

# 51. Data licensing and provenance

Every source adapter records:

- provider;  
- license/terms identifier where applicable;  
- retrieval method;  
- snapshot/version;  
- allowed retention mode;  
- redistribution restrictions.

Do not put licensed raw text or restricted identifiers into public artifacts unless permitted.

Generated reports should reference internal entity IDs and public identifiers only according to source licensing.

---

# 52. Secrets and access control

- secrets are never stored in config files committed to source control;  
- use environment/secret manager references;  
- principle of least privilege for storage and data vendors;  
- separate read and write credentials;  
- generated artifacts cannot expose credentials;  
- source document text is not allowed to alter tool permissions;  
- production write paths require authenticated service identity;  
- audit access to immutable source snapshots and published runs.

---

# 53. Reproducibility

Version independently:

~~~text  
identity_version  
universe_version  
document_policy_version  
parser_version  
chunker_version  
embedding_model_revision  
semantic_space_id  
semantic_transform_id  
market_data_snapshot  
return_method_version  
weighting_version  
state_estimator_version  
cluster_version  
regression_version  
retrieval_version  
generation_version  
~~~

Quantitative randomness is seeded.

Where third-party GPU kernels are nondeterministic, record hardware/software environment and tolerance expectations.

---

# 54. Performance strategy

Do not recompute unchanged document embeddings.

~~~text  
normalized_content_hash + semantic_space_id  
        ↓  
embedding exists?  
    yes → reuse  
    no  → compute  
~~~

For a U.S. equity MVP, annual canonical documents mean embedding updates are relatively sparse compared with monthly state calculations.

Monthly state construction is matrix arithmetic and should be inexpensive once vectors and market data are present.

Use vectorized NumPy/Arrow operations before introducing distributed compute.

Scale out only after profiling.

---

# 55. Suggested technology baseline

A practical initial stack:

~~~text  
Python 3.12+  
uv or equivalent lockfile-based environment  
Pydantic for config/data validation  
PyArrow + Parquet  
DuckDB for research analytics  
NumPy / SciPy  
scikit-learn for PCA/ridge/baseline clustering  
PostgreSQL for service metadata when needed  
pgvector or FAISS only if retrieval scale requires it  
pytest + Hypothesis  
ruff + mypy/pyright  
pre-commit  
containerized reproducible jobs  
~~~

The architecture must not depend on any single embedding vendor.

Implement an encoder interface with pinned model metadata.

---

# 56. CI/CD

Every pull request runs:

- formatting/lint;  
- static type checks;  
- unit tests;  
- property tests;  
- parser fixtures;  
- point-in-time fixtures;  
- state reconciliation tests;  
- deterministic small end-to-end fixture;  
- schema compatibility checks.

Nightly/periodic jobs may run:

- larger historical regression tests;  
- alternate embedding checks;  
- permutation tests;  
- bootstrap tests.

A semantic-space change requires explicit approval and a new version ID.

---

# 57. Golden end-to-end fixture

Maintain a tiny synthetic universe with known answers.

Example:

~~~text  
3 issuers  
4 securities  
3 documents  
one dual-class issuer  
known 2-D semantic vectors  
known market caps  
known returns  
one zero return  
one negative return  
~~~

Hand-calculate:

- issuer aggregation;  
- MSB;  
- VCSS;  
- VDSS;  
- SRS;  
- CSD;  
- RST;  
- effective N.

The CI test compares implementation output with the hand-derived values.

This is the fastest defense against subtle refactors breaking the mathematics.

---

# 58. Interpretation hierarchy

When explaining a month, prefer this order:

1. data coverage and concentration diagnostics;  
2. return-induced semantic tilt;  
3. positive and negative economic states;  
4. contrastive direction;  
5. robust/breadth comparison;  
6. sector-neutral comparison;  
7. semantic clusters;  
8. evidence;  
9. optional synthetic archetype.

This prevents attractive generated prose from overshadowing weak or concentrated quantitative evidence.

---

# 59. Dashboard requirements

## Timeline

Show:

- RST drift;  
- positive-state drift;  
- winner-loser separation;  
- VBD;  
- coherence;  
- effective N;  
- top-10 contribution share;  
- sector concentration.

## Monthly state

Show:

- baseline semantic composition;  
- return-induced tilt;  
- positive/negative states;  
- top contributors;  
- clusters;  
- quality diagnostics;  
- archetypes with evidence.

## Cluster evolution

Show:

- persistent cluster weight;  
- centroid movement;  
- constituent turnover;  
- stability;  
- representative passages.

## 2-D map

Projection is visualization only.

All calculations use the full analysis space.

The UI must label the projection method and semantic-space version.

---

# 60. Research failure modes and required countermeasures

## 60.1 Mega-cap domination

Do not hide it.

Measure:

- largest share;  
- top-10 share;  
- effective N;  
- economic vs robust divergence;  
- leave-largest-out state.

## 60.2 Sector rotation masquerading as semantics

Measure:

- sector HHI;  
- sector-neutral state;  
- sector-constrained null;  
- within-sector regression.

## 60.3 Embedding common-direction bias

Measure:

- raw vs centered state;  
- positive/negative separation;  
- alternate model robustness.

## 60.4 Semantic chimera

Mitigate with weighted clustering and cluster-level archetypes.

## 60.5 Boilerplate contamination

Use section policy, parser fixtures, nearest-passage audits, and boilerplate detection.

## 60.6 Stale documents

Store document_age_days and test sensitivity by age bucket.

## 60.7 Endogenous document changes

A company may rewrite its description after its business changes. That is valid for subsequent periods but cannot be retroactively applied.

Analyze founding/static vs living/dynamic representations separately where relevant.

## 60.8 Price is not flow

Never describe \(C_0r\) as net investor inflow.

If actual flow data become available, create a separate Capital-Flow Semantic State.

## 60.9 Liquidity/manipulation in crypto

Use liquidity filters, price-quality flags, exchange aggregation, extreme-return diagnostics, and robustness caps in the robust state.

Never alter the uncapped economic state without labeling it.

## 60.10 Generator hallucination

Use structured evidence, claim-level provenance, schema validation, support validation, and abstention.

---

# 61. Capital-flow extension

If reliable security-level flows exist:

\[  
F_t=  
\frac{\sum_i Flow_{i,t}x_i}  
{\sum_i|Flow_{i,t}|}  
\]

Call this the **Capital-Flow Semantic State**.

Keep it separate from return states.

The divergence between flow semantics and return semantics may itself be informative.

---

# 62. Crypto-specific market engineering

Crypto market data needs additional controls:

- exchange/source aggregation;  
- circulating vs fully diluted capitalization;  
- historical supply provenance;  
- stale quote detection;  
- wash-trading/volume quality flags;  
- extreme-return handling;  
- chain/token migration continuity;  
- 24/7 UTC period boundaries.

Canonical monthly crypto boundary should use a fixed UTC timestamp, not an equity exchange close.

Use circulating capitalization for the economic state when reliable.

Fully diluted valuation is a separate experimental size measure.

---

# 63. Equities-first build sequence

## Phase 0 — Mathematical golden fixture

Deliver the tiny deterministic fixture and pure state functions before any large data ingestion.

Definition of done:

> Every canonical state has a hand-verifiable numerical test.

## Phase 1 — Point-in-time identity and market panel

Deliver:

- historical issuer/security master;  
- corporate-action mapping;  
- monthly total returns;  
- beginning capitalization;  
- delisting handling.

Definition of done:

> A historical month can be reconstructed without current-universe leakage.

## Phase 2 — Point-in-time document corpus

Deliver:

- annual business-section ingestion;  
- availability timestamps;  
- immutable raw storage;  
- parsing/normalization;  
- document selection.

Definition of done:

> Every issuer-period maps deterministically to the correct admissible document or an explicit missing reason.

## Phase 3 — Semantic representation

Deliver:

- deterministic chunking;  
- chunk embeddings;  
- pooling;  
- raw vectors;  
- analysis transform;  
- embedding cache.

Definition of done:

> Every canonical document maps reproducibly to one semantic vector per semantic-space version.

## Phase 4 — Economic states

Deliver:

- MSB;  
- VCSS;  
- VDSS;  
- SRS;  
- CSD;  
- RST;  
- contribution tables;  
- diagnostics.

Definition of done:

> Every state reconstructs exactly from its contributions.

## Phase 5 — Robustness states

Deliver:

- robust state;  
- sector-neutral state;  
- concentration diagnostics;  
- leave-largest-out.

Definition of done:

> Economic concentration and broad semantic reward can be distinguished.

## Phase 6 — Clusters

Deliver:

- weighted clustering;  
- model selection;  
- stability;  
- persistent IDs.

Definition of done:

> Multiple rewarded modes are represented without forcing one synthetic centroid narrative.

## Phase 7 — Evidence and archetypes

Deliver:

- contributor ranking;  
- passage retrieval;  
- diversification;  
- structured profiles;  
- SRA;  
- provenance;  
- prompt-injection defenses.

Definition of done:

> Every generated claim has valid evidence or is excluded/qualified.

## Phase 8 — Statistical validation

Deliver:

- null models;  
- bootstrap;  
- baseline representations;  
- alternate embedding;  
- sector/size constrained tests.

Definition of done:

> The observed semantic structure can be evaluated against non-semantic and randomized explanations.

## Phase 9 — Crypto adapter

Reuse the state engine.

Implement separate:

- identity;  
- universe;  
- document adapters;  
- market adapters;  
- data-quality rules.

---

# 64. Acceptance criteria for v1

v1 is releasable only when:

1. All canonical mathematical states have golden tests.  
2. Historical universe construction is point-in-time.  
3. Document selection is point-in-time.  
4. Dual-class issuers are not semantically double-counted.  
5. Delisted/bankrupt entities remain through relevant historical loss periods.  
6. Corporate actions are tested.  
7. Embeddings are frozen and versioned.  
8. Semantic transforms are reproducible.  
9. Monthly states reconcile to contribution tables.  
10. MSB and RST are implemented, not only winner centroids.  
11. Positive, negative, signed, and contrastive states are separate.  
12. Economic and robust estimators are separate.  
13. Coverage and concentration diagnostics accompany every state.  
14. Sector-neutral analysis exists.  
15. Null models and bootstrap infrastructure exist.  
16. Cluster stability is measured.  
17. Generated archetypes are evidence-grounded.  
18. Retrieved source text cannot execute instructions.  
19. Quantitative publication succeeds independently of LLM generation.  
20. Every run has immutable provenance.  
21. Same inputs/config produce the same quantitative outputs.  
22. No current-data lookup is required to reconstruct a historical state.  
23. A second embedding model can be run without changing state-engine code.  
24. Crypto can be added through adapters rather than forking the state engine.

---

# 65. Explicit non-goals for v1

Do not block v1 on:

- real-time/intraday states;  
- autonomous trading;  
- portfolio optimization;  
- causal claims;  
- investor-flow inference without flow data;  
- perfect semantic inversion;  
- a distributed vector database;  
- complex neural return prediction;  
- global equities;  
- all document channels;  
- full optimal transport;  
- automatic theme naming without evidence.

The v1 goal is a trustworthy measurement system.

---

# 66. Open decisions that must be resolved by experiment, not intuition

The following remain configuration-backed research choices:

1. primary embedding model;  
2. raw vs centered analysis space;  
3. exact reference corpus for centering;  
4. total vs free-float capitalization;  
5. sector taxonomy;  
6. robust-state cap;  
7. robust return transform parameter;  
8. cluster model-selection thresholds;  
9. minimum document coverage for publication;  
10. minimum evidence support for generated claims.

Each decision should have a named experiment and retained results.

---

# 67. Recommended canonical v1 outputs

For each period publish:

~~~text  
DATA QUALITY  
- eligible entities  
- final entities  
- market-cap coverage  
- document age  
- missing reasons

MARKET SEMANTIC BASELINE  
- MSB

RETURN-INDUCED SEMANTIC TILT  
- RST  
- drift from previous period

ECONOMIC REWARD  
- VCSS  
- VDSS  
- SRS  
- CSD

ROBUSTNESS  
- RSS  
- SND  
- VBD

CONCENTRATION  
- effective N  
- largest contributor  
- top-10 share  
- sector HHI  
- coherence

SEMANTIC MODES  
- rewarded clusters  
- cluster shares  
- cluster stability  
- persistent cluster history

EVIDENCE  
- top contributors  
- representative passages

OPTIONAL INTERPRETATION  
- global rewarded archetype  
- penalized archetype  
- cluster archetypes  
- claim provenance  
~~~

---

# 68. Canonical end-to-end data lineage

~~~text  
raw source artifact  
    ↓  
immutable document version  
    ↓  
availability timestamp  
    ↓  
canonical section extraction  
    ↓  
normalized text  
    ↓  
chunks  
    ↓  
frozen chunk embeddings  
    ↓  
pooled raw document vector  
    ↓  
versioned analysis transform  
    ↓  
entity semantic vector  
    ↓  
point-in-time issuer/security mapping  
    ↓  
beginning capitalization + realized total return  
    ↓  
issuer-level return-attributed contribution  
    ↓  
contribution table  
    ↓  
MSB / VCSS / VDSS / SRS / CSD / RST / RSS / SND  
    ↓  
diagnostics + clusters + regression  
    ↓  
retrieved source passages  
    ↓  
structured characteristics  
    ↓  
validated synthetic archetype  
~~~

Every arrow is versioned or reproducible.

---

# 69. Engineering definition of correctness

A result is correct only if it is simultaneously:

**Point-in-time correct**    
No information unavailable at the measurement boundary is used.

**Identity correct**    
Economic entities and tradable securities are mapped without duplication or ticker-history errors.

**Economically interpretable**    
Weights correspond to a clearly named quantity and are not mislabeled as flows.

**Numerically reproducible**    
The state reconstructs from stored contributions.

**Semantically reproducible**    
Document-to-vector transformation is frozen and versioned.

**Statistically inspectable**    
Concentration, nulls, stability, and alternative explanations can be tested.

**Interpretably grounded**    
Generated language is supported by admissible source evidence.

**Operationally auditable**    
The run manifest identifies every material input and implementation version.

---

# 70. Final implementation rule

The system is built around the following separation:

~~~text  
MEANING OF ECONOMIC ENTITIES  
        +  
REALIZED MARKET OUTCOMES  
        ↓  
DETERMINISTIC MARKET SEMANTIC MEASUREMENT  
        ↓  
STATISTICAL INTERPRETATION  
        ↓  
OPTIONAL HUMAN-READABLE SYNTHESIS  
~~~

Never reverse this dependency.

An LLM must not define the market state.

A future document must not define a historical entity.

A current ticker map must not define a historical universe.

A robust estimator must not silently replace the economic estimator.

A synthetic company must not be mistaken for a literal investment target.

The core deliverable is a reproducible time series of semantic market states whose exact economic and statistical meaning is explicit.

---

---

# 71. Temporal state-change attribution

Month-to-month semantic movement can arise from three different mechanisms:

1. market weights/returns changed;  
2. an entity's canonical document changed;  
3. the eligible universe changed through entry, exit, merger, acquisition, or missing-data status.

A raw cosine difference between monthly states conflates all three.

The system must therefore publish a temporal attribution diagnostic.

For entities present in both periods, retain both prior and current vectors:

\[  
x_{i,t-1},\quad x_{i,t}  
\]

and prior/current state weights:

\[  
w_{i,t-1},\quad w_{i,t}  
\]

Construct counterfactual states on the common universe.

**Weight-only counterfactual**

\[  
M_t^{weight-only}  
=  
\sum_{i\in common} w_{i,t}x_{i,t-1}  
\]

This changes market weights while freezing semantic identity.

**Document-only counterfactual**

\[  
M_t^{document-only}  
=  
\sum_{i\in common} w_{i,t-1}x_{i,t}  
\]

This changes semantic representation while freezing prior weights.

Also report the contribution from entries/exits separately.

Because nonlinear normalization prevents a unique additive decomposition, do not pretend these components sum exactly after cosine normalization. Treat them as counterfactual diagnostics, or use a formal Shapley decomposition if an additive attribution is required.

Required metrics:

~~~text  
state_drift_total  
state_drift_weight_only  
state_drift_document_only  
state_drift_common_universe  
entry_exit_weight_share  
entities_with_document_change  
market_cap_share_with_document_change  
~~~

This prevents annual filing updates or IPO/delisting turnover from being misreported as purely market-driven semantic rotation.

---

# 72. Price-return tilt vs total-return wealth tilt

Section 11.6 uses \(1+r_i\). Its interpretation depends on the return definition.

If \(r_i\) is **price return**, the counterfactual end weights approximate market-cap weights under fixed share counts.

If \(r_i\) is **total return**, distributions are included. The resulting object is better interpreted as a return-adjusted investor-wealth composition, not literal end market capitalization.

The implementation should therefore support both:

~~~text  
RST_PRICE  
RST_TOTAL_RETURN  
~~~

Canonical research output may use total return because it reflects investor economic performance, but the UI and paper must label it correctly.

Do not describe a total-return RST as exact market-cap redistribution.

---

# 73. State degeneracy and validity gates

Cosine directions become unstable when an aggregate vector has near-zero norm.

For every directional state, calculate:

~~~text  
pre_normalization_norm  
weight_denominator  
effective_n  
bootstrap_stability  
~~~

A state is directionally valid only when:

- denominator is positive;  
- vector norm exceeds a semantic-space-specific numerical floor;  
- all values are finite.

If a state fails, store:

~~~text  
state_status = DEGENERATE  
state_vector = raw pre-normalized vector where meaningful  
normalized_direction = null  
reason_code  
~~~

Do not normalize an almost-zero vector.

Drift, separation, and alignment metrics requiring a valid direction become null rather than misleading numbers.

Thresholds must be calibrated and versioned.

---

# 74. Cross-semantic-space comparison rule

Vectors from different semantic_space_id values are not directly comparable.

The API must reject direct cosine comparisons across semantic spaces unless an explicit alignment artifact exists.

If semantic-space migration is required, create a versioned alignment map using a stable anchor corpus and validate:

- neighborhood preservation;  
- pairwise cosine preservation;  
- state-direction preservation;  
- cluster preservation.

Prefer recomputing historical states in the new semantic space over aligning spaces when feasible.

---

# 75. Contrastive evidence retrieval

A contrastive direction \(D_t=M_t^+-M_t^-\) is not necessarily the embedding of any real document.

Do not retrieve evidence for CSD as if it were a normal document centroid.

Instead retrieve two evidence sets:

~~~text  
positive-side evidence:  
  high positive contribution  
  high alignment with M+

negative-side evidence:  
  high negative contribution  
  high alignment with M-

contrastive characteristic:  
  supported by positive evidence  
  absent from or contradicted by negative evidence  
~~~

The generated contrastive summary must distinguish:

- characteristics positively represented among winners;  
- characteristics positively represented among losers;  
- characteristics that truly differentiate the two.

This reduces false "winner trait" claims caused by characteristics common to the entire market.

---

# 76. Null-model correction and geometric invariance

A single common orthogonal rotation of all embeddings preserves dot products and cosine geometry. It is therefore **not** a semantic-destruction null model.

Use common orthogonal rotation only as an implementation invariance test: results based purely on inner-product geometry should be unchanged.

Valid geometry-destroying nulls include:

- document-to-entity permutation;  
- return permutation;  
- sector/size-constrained return permutation;  
- independently generated random unit vectors matched in dimension;  
- independently permuted embedding assignments.

Keep invariance tests and statistical null models in separate test suites.

---

# 77. Robust-cap feasibility

An iterative contribution cap \(c\) can only produce normalized weights summing to one when enough eligible contributors exist.

Before applying a cap, require:

\[  
N_{positive}\cdot c \ge 1  
\]

for the positive side, and the analogous condition for the negative side.

If infeasible:

- disable the cap for that side and emit a reason; or  
- use a pre-specified adaptive cap rule.

Never silently violate normalization to satisfy an impossible cap.

Store:

~~~text  
configured_cap  
effective_cap  
cap_binding  
capped_entity_count  
cap_feasible  
~~~

---

# 78. Market-data and document revision policy

External vendors and source systems may revise historical records.

A published run must reference immutable source snapshots.

A later vendor correction creates a new run; it does not mutate an old published run.

Maintain:

~~~text  
source_snapshot_id  
source_record_hash  
ingested_at  
supersedes_snapshot_id  
revision_reason  
~~~

Provide run-to-run diffs for:

- universe membership;  
- document selection;  
- returns;  
- market caps;  
- vectors;  
- states;  
- clusters.

This makes historical corrections auditable.

---

# 79. Backfill policy

A backfill is not allowed to use today's document-selection logic against an unversioned current corpus.

Backfill steps:

1. reconstruct the historical entity universe;  
2. select only documents with admissible historical availability;  
3. use the requested frozen semantic-space version;  
4. use an immutable historical market-data snapshot;  
5. calculate the state;  
6. persist a run manifest.

If a required historical field is unavailable, mark the observation missing. Do not fill it with a current value merely to improve coverage.

---

# 80. Regression inference

For descriptive cross-sectional regression, report heteroskedasticity-robust uncertainty where inferential statistics are shown.

For multi-period asset-pricing research, support a separate panel/Fama-MacBeth style research workflow rather than treating thousands of entity-month rows as independent observations.

Prediction studies must use walk-forward splits and fit preprocessing, PCA, hyperparameters, and controls inside the training window.

No full-sample preprocessing may leak into a claimed out-of-sample result.

---

# 81. Generation release gate

The archetype layer has its own status independent of quantitative publication and is recorded under a child retrieval/generation manifest as specified in Section 31:

~~~text  
NOT_REQUESTED  
PENDING  
VALIDATED  
PARTIAL  
REJECTED  
~~~

A generated archetype is VALIDATED only when:

- every material claim has evidence IDs;  
- evidence belongs to the same run and admissible period;  
- minimum distinct-entity support is satisfied for broad claims;  
- no unsupported numeric fact is present;  
- no source instruction was executed;  
- claim validator finds no unsupported material statement.

A REJECTED archetype is not shown by default.

Quantitative results remain published.

---

# 82. Final pre-release engineering audit

Before declaring the implementation production-ready, run five independent review passes:

**Pass A — Mathematical correctness**    
Re-derive every formula from contribution tables and golden fixtures.

**Pass B — Point-in-time integrity**    
Attempt to introduce future documents, current ticker mappings, revised universe membership, and post-period data. Tests must block them.

**Pass C — Economic interpretation**    
Verify that every metric name matches what its weights actually measure, especially total return, dividends, market capitalization, and flow terminology.

**Pass D — Statistical robustness**    
Run concentration stress tests, constrained nulls, bootstrap stability, sector-neutral variants, and alternate semantic representations.

**Pass E — Operational and generation safety**    
Reproduce runs from manifests, simulate partial failures, verify atomic publication, test prompt-injection documents, and reject unsupported generated claims.

A "10/10" review is an engineering target, not a mathematical guarantee of zero future defects. Release requires all specified acceptance tests to pass and all known critical issues to be closed or explicitly documented.

---

# 83. Market-relative semantic reward

The previous economic states answer absolute value creation/destruction. A broad market rally can make almost every entity a "winner" even when there is little cross-sectional semantic information.

The system therefore adds a first-class market-relative family.

Define beginning-capitalization weights:

\[  
p_i=\frac{C_i}{\sum_j C_j}  
\]

and the capitalization-weighted market return:

\[  
\bar r_t=\sum_i p_i r_i  
\]

Define market-relative return:

\[  
e_i=r_i-\bar r_t  
\]

## 83.1 Relative Reward Semantic State — positive

\[  
a_i^+=C_i\max(e_i,0)  
\]

\[  
R_t^+=  
\frac{\sum_i a_i^+x_i}  
{\sum_i a_i^+}  
\]

This answers:

> What semantic characteristics were represented by entities that outperformed the beginning-of-period capitalization-weighted market?

## 83.2 Relative Reward Semantic State — negative

\[  
a_i^-=C_i\max(-e_i,0)  
\]

\[  
R_t^-=  
\frac{\sum_i a_i^-x_i}  
{\sum_i a_i^-}  
\]

This answers:

> What semantic characteristics were represented by entities that underperformed the capitalization-weighted market?

## 83.3 Signed Relative Reward State

\[  
R_t^{signed}  
=  
\frac{\sum_i C_i e_i x_i}  
{\sum_i C_i|e_i|}  
\]

This is the preferred signed cross-sectional "reward direction" when the research question is relative market preference rather than absolute wealth creation.

Store the raw vector, normalized direction, numerator norm, denominator, and contribution table.

## 83.4 Interpretation hierarchy

Use:

- VCSS / VDSS for **absolute return-attributed value creation/destruction**;  
- RRS positive/negative for **market-relative winners/losers**;  
- RST for **change in semantic portfolio composition caused by relative returns**;  
- sector/factor residual states for **reward beyond specified conventional exposures**.

Do not call raw positive-return VCSS the unique measure of "what the market preferred."

---

# 84. Exact RST decomposition

RST has an exact market-relative form.

Let:

\[  
B_t=\sum_i p_i x_i  
\]

and:

\[  
\bar r_t=\sum_i p_i r_i  
\]

Then:

\[  
B_t^{end,\*}  
=  
\frac{B_t+\sum_i p_i r_i x_i}  
{1+\bar r_t}  
\]

Therefore:

\[  
T_t  
=  
B_t^{end,\*}-B_t  
=  
\frac{\sum_i p_i(r_i-\bar r_t)x_i}  
{1+\bar r_t}  
\]

Thus the RST numerator is exactly the capitalization-weighted covariance-like semantic tilt generated by cross-sectional excess returns.

Consequences:

1. if every entity has the same return, RST is exactly zero;  
2. a market-wide rally with no cross-sectional return differences creates no RST;  
3. the RST direction is the same as the unnormalized signed market-relative numerator whenever \(1+\bar r_t>0\);  
4. RST is inherently baseline-relative.

Add the following golden properties:

~~~text  
all_returns_equal → RST == zero  
add_same_constant_to_all_returns → RST numerator unchanged  
two_asset_closed_form → implementation matches hand calculation  
~~~

For total returns, retain the wealth-composition interpretation from Section 72.

---

# 85. Point-in-time sector and industry classification

Sector and industry classifications are historical data.

Never assign a historical observation using today's sector classification.

Store:

~~~text  
entity_id  
taxonomy_name  
taxonomy_version  
sector_id  
industry_group_id  
industry_id  
valid_from  
valid_to  
source_snapshot_id  
~~~

Sector-neutral states and sector-constrained null models must use the classification valid at \(t_0\).

If historical classifications are unavailable, either:

- reconstruct a versioned point-in-time classification from admissible information; or  
- mark sector-neutral analysis unavailable for that observation.

Do not silently backfill current classifications.

For economic sector-neutral returns, the default residual is:

\[  
\bar r_{s,t}^{cap}  
=  
\frac{\sum_{i\in s}C_i r_i}  
{\sum_{i\in s}C_i}  
\]

\[  
\epsilon_i^{sector,cap}  
=  
r_i-\bar r_{s(i),t}^{cap}  
\]

For the robust/breadth estimator, a sector median may be used as a separate explicitly named residual:

\[  
\epsilon_i^{sector,median}  
=  
r_i-Median(r_j:j\in s(i))  
\]

Do not mix these two residual definitions under one state ID.

---

# 86. Capitalization basis and share-count correctness

"Market capitalization" must be operationally defined.

The equity implementation supports two mutually exclusive bases:

~~~text  
LISTED_SECURITY_CAP  
ISSUER_EQUITY_CAP  
~~~

## 86.1 Listed-security basis

\[  
C_{issuer,t_0}  
=  
\sum_{s\in eligible\\ listed\\ classes}  
P_{s,t_0}Shares_{s,t_0}  
\]

Use this when the research object is the listed investable equity represented by observable securities.

## 86.2 Issuer-equity basis

Use a point-in-time vendor issuer capitalization that includes the intended equity classes.

If this basis is used, do not also sum security-level market caps and double count non-listed or overlapping share classes.

The run manifest records capitalization_basis.

## 86.3 Share-count timestamp

shares_t0 must be economically valid at \(t_0\), not merely the most recently reported quarterly shares outstanding if a split, issuance, conversion, or repurchase changed the count before \(t_0\).

Store:

~~~text  
shares_value  
shares_effective_at  
shares_source  
shares_quality_flag  
~~~

A stale-share diagnostic is mandatory.

## 86.4 Return validity

Reject or quarantine:

- non-finite returns;  
- total returns below -100% unless a documented data convention explains them;  
- zero/negative prices where impossible;  
- nonpositive capitalization;  
- return observations inconsistent with known corporate-action handling.

Every quarantine has a reason code.

---

# 87. Coverage and missingness bias

A high market-cap coverage ratio does not guarantee an unbiased semantic sample.

For every period, compare the included and eligible-but-missing populations on observable characteristics available without the missing document/vector:

- market-cap distribution;  
- sector distribution;  
- listing age;  
- exchange;  
- liquidity;  
- return distribution where market data exist.

Publish:

~~~text  
entity_count_coverage  
market_cap_coverage  
sector_coverage_vector  
return_coverage_difference  
size_coverage_difference  
missingness_reason_counts  
~~~

If missingness is material, label the state as representing the **covered universe**, not the full universe.

Do not use inverse-probability weighting in the canonical state unless a missingness model is pre-specified and validated. It may be a robustness experiment.

Add a publication gate allowing the project to set minimum entity-count and market-cap coverage thresholds.

---

# 88. Filing amendments and document supersession

A later amendment does not automatically replace an earlier canonical business description.

For regulatory filings:

1. preserve the original filing;  
2. preserve every amendment as a separate document version;  
3. identify which canonical sections changed;  
4. update the semantic document only when the amendment materially changes a section used by the document policy;  
5. set the new semantic version's available_at to the amendment's actual public availability time.

Store:

~~~text  
filing_accession  
amends_document_id  
amendment_type  
canonical_section_changed  
semantic_supersession  
~~~

This prevents a 10-K/A correcting an unrelated exhibit or signature from creating a false semantic event.

---

# 89. Corporate-event attribution diagnostics

Large semantic contributions can coincide with events whose return mechanism is not well summarized as ordinary repricing.

Flag observations involving:

- merger announcements or completion;  
- acquisition consideration;  
- spin-offs;  
- bankruptcy;  
- liquidation;  
- extraordinary distributions;  
- trading halts;  
- relisting;  
- major share-class conversions.

Do not automatically remove these observations from the economic state. They are real market outcomes.

Instead publish:

~~~text  
event_flag  
event_type  
event_window  
event_contribution_share  
state_without_flagged_events  
cosine_full_vs_event_excluded  
~~~

This lets researchers distinguish ordinary cross-sectional reward from states dominated by a small number of corporate events.

---

# 90. Deterministic IDs, seeds, and artifact addressing

Every derived object receives a deterministic ID based on its semantic inputs.

Recommended pattern:

~~~text  
semantic_space_id = hash(model_revision, parser_policy, chunker, pooling, transform)  
state_id = hash(run_id, period, state_type, estimator_version)  
cluster_instance_id = hash(state_id, cluster_version, cluster_index)  
evidence_id = hash(state_id, entity_id, chunk_id, retrieval_version)  
~~~

Randomized procedures derive job-specific seeds from:

~~~text  
master_seed + run_id + job_name + period  
~~~

Do not reuse a mutable global random generator across parallel jobs.

Deterministic IDs make retries idempotent and allow exact artifact reconciliation.

---

# 91. Primary/secondary metric contract

To prevent research conclusions from changing through metric shopping, every experiment declares primary and secondary outputs before execution.

Recommended descriptive contract:

~~~text  
PRIMARY  
1. RST_TOTAL_RETURN or RST_PRICE, explicitly chosen  
2. signed market-relative reward state  
3. positive/negative market-relative reward states  
4. concentration and coverage diagnostics

SECONDARY  
5. VCSS / VDSS absolute value-creation states  
6. robust/breadth state  
7. sector-neutral state  
8. factor-residual state  
9. semantic clusters  
10. regression direction  
~~~

A paper or dashboard may show all metrics, but the primary specification must be stored in the experiment manifest.

---

# 92. Expanded golden-test suite

Add the following tests.

## Market-relative tests

~~~text  
all equal returns:  
  RST == zero  
  signed relative reward numerator == zero

common return shift:  
  relative-return numerator unchanged

single outlier:  
  contribution direction matches the outlier vector after market demeaning  
~~~

## Classification tests

~~~text  
historical sector changes:  
  period before change uses old classification  
  period after change uses new classification  
~~~

## Amendment tests

~~~text  
10-K/A changes unrelated section:  
  canonical semantic document unchanged

10-K/A changes canonical business section:  
  semantic document changes only after amendment available_at  
~~~

## Missingness tests

~~~text  
missing document:  
  entity excluded with reason  
  coverage denominator still includes eligible entity where appropriate  
~~~

## Capitalization tests

~~~text  
split at t0:  
  price and shares reconcile to unchanged capitalization absent economic move

dual listed classes:  
  no duplicate issuer vector

issuer-cap mode:  
  security caps are not summed into issuer cap again  
~~~

## Degeneracy tests

~~~text  
near-zero aggregate vector:  
  normalized direction is null  
  dependent cosine metrics are null  
~~~

---

# 93. Revised release gate

In addition to Section 64, release now requires:

1. market-relative reward states are implemented;  
2. RST passes the exact decomposition tests;  
3. sector/industry data used in neutralization are point-in-time;  
4. capitalization_basis is explicit;  
5. stale-share diagnostics exist;  
6. filing amendments follow section-aware supersession;  
7. coverage/missingness diagnostics compare included vs excluded eligible entities;  
8. corporate-event contribution diagnostics exist;  
9. cross-semantic-space cosine comparison is blocked by default;  
10. robust contribution caps are feasibility-checked;  
11. generated contrastive summaries use two-sided evidence;  
12. randomized procedures are deterministically seeded.

---

# 94. Second-loop engineering conclusion

After this review, the most important conceptual correction is that **absolute positive return is not the same object as relative semantic reward**.

The implementation should treat the following as different scientific measurements:

~~~text  
absolute wealth creation  
    → C_i \* r_i positive/negative states

market-relative semantic reward  
    → C_i \* (r_i - market_return)

semantic portfolio rotation  
    → exact RST composition change

sector/factor-adjusted semantic reward  
    → C_i \* residual_return

breadth/robust semantic reward  
    → transformed size × robust return score  
~~~

This separation materially improves the system because it prevents a broad market move, sector move, or a handful of large companies from being mistaken for a unique semantic preference.

The resulting architecture remains the same: point-in-time documents and identity feed deterministic semantic vectors; market outcomes create auditable contribution tables; statistical estimators interpret those contributions; generated prose remains a downstream evidence-grounded view only.

---

# Appendix A — Core formulas at a glance

For entity \(i\):

\[  
x_i = \text{analysis semantic vector}  
\]

\[  
C_i = \text{beginning-of-period issuer market capitalization}  
\]

\[  
r_i = \text{period total return}  
\]

\[  
q_i=C_i r_i  
\]

Baseline:

\[  
B_t=\frac{\sum_i C_i x_i}{\sum_i C_i}  
\]

Positive:

\[  
M_t^+=\frac{\sum_i C_i\max(r_i,0)x_i}{\sum_i C_i\max(r_i,0)}  
\]

Negative:

\[  
M_t^-=\frac{\sum_i C_i\max(-r_i,0)x_i}{\sum_i C_i\max(-r_i,0)}  
\]

Signed:

\[  
S_t=\frac{\sum_i C_i r_i x_i}{\sum_i |C_i r_i|}  
\]

Contrastive:

\[  
D_t=M_t^+-M_t^-  
\]

Return-adjusted end composition:

\[  
B_t^{end,\*}=  
\frac{\sum_i C_i(1+r_i)x_i}  
{\sum_i C_i(1+r_i)}  
\]

Return-induced tilt:

\[  
T_t=B_t^{end,\*}-B_t  
\]

Semantic drift:

\[  
SD_t=1-\cos(U_t,U_{t-1})  
\]

Winner-loser separation:

\[  
WLS_t=1-\cos(U_t^+,U_t^-)  
\]

Effective contributors:

\[  
N_{eff}=  
\frac{1}  
{\sum_i  
\left(  
\frac{|q_i|}{\sum_j|q_j|}  
\right)^2}  
\]

---

# Appendix B — Mandatory review checklist for every methodology change

Before merging a change, answer:

- Does this alter the historical information set?  
- Does this alter entity/security identity?  
- Does this alter document selection?  
- Does this alter semantic-space geometry?  
- Does this alter economic weighting?  
- Does this alter normalization?  
- Does this alter state interpretation?  
- Does this alter clustering?  
- Does this alter evidence retrieval?  
- Does this alter generation only?  
- Is a new version ID required?  
- Can old runs still be reproduced?  
- Do golden fixtures still pass?  
- Do point-in-time tests still pass?  
- Does the run manifest capture the change?

If the answer to any material question is unknown, do not publish the changed methodology.

---

# Appendix C — Definition of done for an engineering handoff

An engineer unfamiliar with the original idea should be able to implement the system from this specification and answer, from code and stored provenance:

1. Which entities were eligible in a historical month?  
2. Which document represented each entity at the return start boundary?  
3. Which semantic-space version produced each vector?  
4. Which securities rolled up into each issuer?  
5. Which beginning market cap and return produced each economic contribution?  
6. How was each state calculated?  
7. How concentrated was it?  
8. How did it differ from the market baseline?  
9. How did it differ from a robust or sector-neutral state?  
10. Which clusters existed?  
11. Which passages support each generated interpretation?  
12. Can the entire result be reproduced without consulting today's data?

If all twelve answers are machine-auditable, the engineering foundation is functioning as intended

---

