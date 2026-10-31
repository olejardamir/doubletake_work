# Agent_X Harvest — Adaptive Multi-Fidelity Evidence Integration

## Status

**Purpose:** Replace plain Successive Halving inside Agent_X Harvest with a stronger evidence-allocation architecture that aggressively eliminates weak harvested candidates without prematurely killing candidates whose value only becomes visible under deeper testing.

**Recommended architecture:** **Uncertainty-Aware Multi-Objective ASHA/Hyperband**, used as the **evaluation and resource-allocation layer**, with a separate candidate-generation layer such as Topography, CMA-ES, CEM, Bayesian optimization, search, or harvested external algorithms.

This document is an implementation specification for integrating that architecture into the existing Agent_X Harvest pipeline.

---

# 1. Core decision

Do **not** replace Harvest with a single optimizer.

Instead, separate Harvest into two distinct systems:

1. **Candidate generation**
   - Topography
   - semantic/retrieval harvest
   - external algorithm harvest
   - mutation/recombination
   - CMA-ES
   - CEM
   - Bayesian optimization
   - LLM-generated implementations
   - human-submitted candidates

2. **Evidence allocation and promotion**
   - cheap checks first
   - increasingly expensive evaluation rungs
   - asynchronous promotion
   - uncertainty-aware re-testing
   - multi-objective scoring
   - protected exploration
   - evidence-gated assimilation

The second system should become the authoritative promotion mechanism for Harvest.

A generator may propose a candidate.

A generator may **not** directly promote, install, assimilate, or declare the candidate successful.

Only accumulated evidence may do that.

---

# 2. Why plain Successive Halving is not sufficient

Plain Successive Halving is useful because it:

- is simple;
- is deterministic enough to audit;
- discards weak candidates quickly;
- works well when candidates have roughly comparable resource requirements;
- works well when early measurements predict later measurements;
- has low orchestration complexity.

However, Agent_X Harvest violates several of those assumptions.

Harvested candidates may have:

- very different implementation cost;
- different test costs;
- noisy benchmark results;
- delayed value;
- different strengths across metrics;
- early-stage scores that are weak predictors of integration value;
- binary failures mixed with continuous quality measures;
- novelty without usefulness;
- usefulness without novelty;
- high apparent score caused by benchmark gaming;
- integration improvements that are invisible in isolated microbenchmarks.

Therefore a rigid "bottom X% dies at every rung" policy is too brittle.

The stronger design is to keep the useful **multi-fidelity racing** idea from Successive Halving while making promotion:

- asynchronous;
- multi-objective;
- uncertainty-aware;
- cost-aware;
- bracketed;
- evidence-gated;
- partially exploratory.

---

# 3. Target architecture

```text
                         ┌────────────────────────────┐
                         │ Candidate Generators       │
                         │                            │
                         │ Topography                 │
                         │ CEM / CMA-ES               │
                         │ Bayesian Optimization      │
                         │ Search / Retrieval         │
                         │ Mutation / Recombination   │
                         │ LLM / Human / Patent       │
                         └─────────────┬──────────────┘
                                       │
                                       ▼
                         ┌────────────────────────────┐
                         │ Candidate Normalization    │
                         │ Identity / lineage / dedup │
                         │ Experiment Contract        │
                         └─────────────┬──────────────┘
                                       │
                                       ▼
                     ┌───────────────────────────────────┐
                     │ HARVEST EVIDENCE SCHEDULER        │
                     │                                   │
                     │ ASHA / Hyperband-style brackets   │
                     │ + Pareto promotion                │
                     │ + uncertainty handling            │
                     │ + adaptive repeat testing         │
                     │ + exploration reserve             │
                     │ + cost normalization              │
                     └──────────────┬────────────────────┘
                                    │
       ┌────────────────────────────┼──────────────────────────────┐
       ▼                            ▼                              ▼
  R0 Structural                R1 Substance                  R2 Unit/Property
  validity                     evaluation                    tests
       │                            │                              │
       └────────────────────────────┼──────────────────────────────┘
                                    ▼
                              R3 Benchmark
                                    │
                                    ▼
                              R4 Integration
                                    │
                                    ▼
                              R5 Comparative
                              system evaluation
                                    │
                                    ▼
                              R6 Canary / shadow
                                    │
                                    ▼
                     ┌──────────────────────────────────┐
                     │ Evidence-Gated Assimilation     │
                     │ promote / retain / reject       │
                     └──────────────────────────────────┘
```

---

# 4. Important architectural rule

## Harvest must stop treating generation score as deployment authority

Topography score, semantic similarity, novelty score, LLM confidence, generator rank, source reputation, patent relevance, or evolutionary fitness may determine:

- whether a candidate enters evaluation;
- initial priority;
- which bracket it enters;
- how much exploratory budget it receives.

They must **not** determine final acceptance.

Final acceptance must depend on measured evidence.

---

# 5. Candidate object

Every Harvest item should become a typed candidate record.

```python
@dataclass(frozen=True)
class HarvestCandidate:
    candidate_id: str
    lineage_id: str
    parent_ids: tuple[str, ...]
    generator: str
    source_ref: str | None

    domain: str
    capability: str
    hypothesis: str

    implementation_ref: str
    experiment_contract_ref: str

    estimated_cost: float | None
    risk_class: str

    created_at: str
```

Do not use filesystem path, filename, title, or LLM-generated label as identity.

`candidate_id` should be content-derived or otherwise stable.

---

# 6. Mandatory Experiment Contract

No candidate may enter expensive evaluation without an Experiment Contract.

Minimum contract:

```yaml
candidate_id: ...
hypothesis: ...
target_system: ...
baseline: ...
expected_effect: ...
primary_metric: ...
secondary_metrics: [...]
guardrail_metrics: [...]
evaluation_method: ...
minimum_effect_size: ...
maximum_regression: ...
resource_budget: ...
failure_conditions: [...]
```

Example:

```yaml
hypothesis:
  Replacing FIFO retrieval dispatch with adaptive worth/value scheduling
  increases successful high-value retrieval completion.

baseline:
  current Agent_X retrieval scheduler

primary_metric:
  useful_result_rate

secondary_metrics:
  - mean_completion_latency
  - compute_cost
  - retrieval_ndcg_at_10

guardrail_metrics:
  - failure_rate
  - timeout_rate
  - determinism_regressions

minimum_effect_size:
  useful_result_rate: +0.10

maximum_regression:
  mean_completion_latency: +0.05
```

Harvest must reject vague contracts such as:

> "This should improve intelligence."

The hypothesis must be measurable.

---

# 7. Evaluation rungs

The recommended Harvest ladder is:

## R0 — Structural validity

**Cost:** extremely low

Checks:

- parses;
- imports;
- compiles;
- no forbidden dependencies;
- required symbols exist;
- expected interfaces exist;
- no import side effects;
- deterministic initialization where required;
- bounded execution;
- basic security/static policy checks.

Typical result:

```text
PASS / FAIL
```

Immediate hard kill on failure unless the failure is classified as repairable.

---

## R1 — Algorithmic substance and relevance

**Cost:** very low

Purpose: stop placeholder/bucket/slop code before it consumes benchmark resources.

Checks should answer:

- Is there an actual algorithm?
- Is behavior materially different from baseline?
- Does code implement the stated mechanism?
- Does the candidate affect the claimed subsystem?
- Is the code merely dispatch boilerplate?
- Is it a rename/wrapper around existing behavior?
- Is it duplicated from an existing Agent_X capability?
- Is claimed novelty unsupported?
- Does the implementation contain meaningful state transition, optimization, search, control, inference, ranking, allocation, or transformation logic?

Score dimensions:

```text
substance
relevance
novelty
implementation_completeness
lineage_distance
duplication_risk
```

A candidate that contains no meaningful algorithm should die here.

This rung directly addresses Harvest-generated clutter.

---

## R2 — Unit, invariant, property, and adversarial tests

**Cost:** low

Run:

- unit tests;
- invariants;
- property tests where applicable;
- negative tests;
- edge cases;
- deterministic replay;
- malformed input;
- budget exhaustion;
- timeout behavior;
- adversarial bypass tests;
- regression tests against the current implementation.

Promotion requires all mandatory safety/invariant gates to pass.

Quality score alone cannot override a failed hard invariant.

---

## R3 — Isolated benchmark / simulation

**Cost:** medium

Evaluate the candidate outside the full Agent_X runtime.

Examples:

- retrieval NDCG;
- scheduler throughput;
- mutation hit rate;
- benchmark task success;
- latency;
- token usage;
- memory;
- simulation quality;
- algorithmic convergence;
- false positive/negative rate.

Each candidate should be evaluated against:

1. current baseline;
2. relevant parent;
3. strongest known candidate in the same capability;
4. optionally a simple control.

Do not evaluate only absolute score.

Evaluate **delta versus baseline**.

---

## R4 — Integration evaluation

**Cost:** medium-high

Run the candidate in the real subsystem with controlled inputs.

Measure:

- integration correctness;
- effect on neighboring components;
- orchestration failures;
- state corruption;
- retry behavior;
- side effects;
- interaction with governance;
- latency amplification;
- resource amplification;
- end-to-end usefulness.

Many superficially strong algorithms should die here.

---

## R5 — Comparative system evaluation

**Cost:** high

Only the strongest candidates reach this rung.

Run:

- A/B or paired comparison;
- multiple seeds;
- multiple workloads;
- workload strata;
- repeated measurements;
- statistically meaningful confidence estimation;
- failure mode analysis.

Compare candidate against the **current champion** rather than merely the original baseline.

This prevents accumulation of individually positive but globally inferior implementations.

---

## R6 — Shadow / canary / reversible assimilation

**Cost:** highest

Candidate is not yet authoritative.

Possible modes:

```text
shadow
read-only
advisory
small traffic %
limited task class
limited capability scope
```

Track actual production/system evidence.

Promotion to authoritative implementation requires:

- sufficient sample;
- no guardrail violation;
- confirmed improvement;
- rollback state available;
- provenance recorded;
- experiment evidence linked.

---

# 8. Promotion algorithm

Do not use a single scalar score for all decisions.

Use a two-layer decision.

## Layer A — hard gates

A candidate is ineligible for promotion when it fails any mandatory constraint:

```text
correctness
security
governance
determinism requirement
resource ceiling
regression ceiling
required test
contract violation
```

## Layer B — Pareto / evidence ranking

Eligible candidates are compared across objectives such as:

```text
measured improvement
confidence
cost
latency
novelty
robustness
integration risk
maintenance burden
```

Use Pareto dominance where possible.

Example:

Candidate A should not kill Candidate B simply because A has a slightly higher task-success score if B is:

- much cheaper;
- significantly faster;
- more robust;
- better under a different workload stratum.

Maintain the non-dominated set at each major rung.

---

# 9. Recommended promotion score

A scalar can still be used for scheduler ordering, but not as sole acceptance authority.

Example scheduling utility:

```text
utility =
    expected_improvement
  × confidence
  × strategic_value
  × novelty_value
  / expected_remaining_cost
```

with penalties:

```text
utility *= robustness_factor
utility *= integration_factor
utility *= lineage_diversity_factor
utility *= evidence_quality_factor
```

This score decides **what to test next**.

It does not decide final assimilation.

---

# 10. Uncertainty-aware promotion

A major weakness of rigid Successive Halving is premature elimination.

Harvest should track:

```python
@dataclass
class MetricEstimate:
    mean: float
    variance: float
    n: int
    lower_bound: float
    upper_bound: float
```

For candidate-vs-baseline improvement:

```text
delta = candidate_metric - baseline_metric
```

Promotion categories:

```text
CLEAR_WIN
LIKELY_WIN
UNCERTAIN
LIKELY_LOSS
CLEAR_LOSS
```

Recommended behavior:

| Classification | Action |
|---|---|
| CLEAR_WIN | promote |
| LIKELY_WIN | promote or gather one confirmation sample |
| UNCERTAIN | repeat / increase budget |
| LIKELY_LOSS | normally reject |
| CLEAR_LOSS | reject immediately |

The scheduler should spend extra budget on **uncertain high-upside candidates**, not on obvious failures.

---

# 11. Asynchronous promotion

Do not wait for every candidate in a batch to complete.

Use ASHA-like asynchronous promotion.

When a candidate completes a rung:

1. record evidence;
2. compare against completed peers;
3. determine eligibility;
4. either:
   - promote;
   - repeat;
   - hold temporarily;
   - reject.

Benefits to Agent_X:

- expensive candidates do not block cheap candidates;
- heterogeneous benchmark times are tolerated;
- multiple harvest workers can operate continuously;
- independent agents can feed the same evaluation system.

---

# 12. Hyperband-style brackets

Do not place every candidate into the same pruning schedule.

Use several brackets.

Example:

```text
Bracket A — aggressive
R0 -> R1 -> R2 -> R3
large intake
strong pruning

Bracket B — balanced
R0 -> R1 -> R2 -> R3 -> R4
moderate pruning

Bracket C — deep exploration
R0 -> R1 -> R2 -> R3 -> R4 -> R5
small intake
gentle early pruning
```

This solves an important Harvest problem:

A candidate with weak early proxy performance but potentially strong system-level value still has a path to deeper evaluation.

---

# 13. Protected exploration reserve

Reserve part of evaluation budget for candidates that would otherwise be pruned.

Recommended starting value:

```text
10% to 20% of evaluation budget
```

Exploration candidates may be selected because they have:

- very high novelty;
- unusual lineage;
- high uncertainty;
- weak proxy but strong theoretical mechanism;
- underrepresented capability domain;
- disagreement between evaluators;
- potential for large upside.

The exploration reserve must remain bounded.

It is not a bypass around evidence.

It merely buys deeper evidence.

---

# 14. Cost-aware resource allocation

Resource should not mean only:

```text
epochs
iterations
tokens
benchmark cases
```

For Agent_X, define resource as a normalized evaluation budget.

Example:

```python
EvaluationCost(
    wall_seconds=...,
    cpu_seconds=...,
    gpu_seconds=...,
    llm_tokens=...,
    sandbox_runs=...,
    integration_runs=...,
    human_review_minutes=...,
)
```

Compute a normalized cost unit.

The scheduler should reason about:

```text
expected evidence gain / expected cost
```

rather than raw candidate score alone.

---

# 15. Noise handling

For noisy metrics:

- store every observation;
- never overwrite prior measurements;
- track seed;
- track workload;
- track environment;
- track baseline version;
- calculate uncertainty;
- increase repetitions near promotion thresholds.

Do **not** spend repeat budget equally.

Adaptive rule:

```text
far above threshold -> promote
far below threshold -> reject
near threshold -> repeat
high variance -> repeat
high impact + uncertainty -> repeat
low impact + uncertainty -> usually reject
```

---

# 16. Multi-objective Harvest

Agent_X should not optimize only "quality."

Candidate objectives may include:

```text
task success
correctness
latency
compute
token cost
memory
robustness
determinism
maintainability
novelty
coverage
safety
governance compatibility
```

Classify each objective as:

```text
PRIMARY
SECONDARY
GUARDRAIL
DIAGNOSTIC
```

Example:

```yaml
primary:
  useful_result_rate: maximize

secondary:
  latency: minimize
  token_cost: minimize

guardrails:
  failure_rate: <= baseline + 0.01
  governance_violation: == 0

diagnostic:
  novelty_score: maximize
```

Guardrails should never be hidden inside a weighted average.

---

# 17. Champion / challenger model

Every capability should have a current champion.

Example registry:

```text
retrieval.scheduler -> candidate_0182
evolution.mutation_gate -> candidate_0441
harvest.rank_engine -> candidate_0517
ui.inventory_virtualizer -> candidate_0632
```

New candidates are challengers.

A challenger reaches production only if it defeats or complements the champion under the required contract.

This changes Harvest from:

```text
"interesting item -> generate code -> keep code"
```

to:

```text
"candidate -> challenge incumbent -> prove value -> replace/complement or die"
```

---

# 18. Candidate outcomes

Do not use only ACCEPT / REJECT.

Use:

```text
REJECTED_INVALID
REJECTED_NO_SUBSTANCE
REJECTED_DUPLICATE
REJECTED_TEST_FAILURE
REJECTED_NO_IMPROVEMENT
REJECTED_REGRESSION
REJECTED_DOMINATED

RETAINED_UNCERTAIN
RETAINED_EXPLORATORY
RETAINED_SPECIALIST

PROMOTED_SHADOW
PROMOTED_CANARY
PROMOTED_CHAMPION
PROMOTED_COMPLEMENT
```

`PROMOTED_COMPLEMENT` is important.

A candidate may be inferior globally but superior for a specific task class.

Do not discard specialists if routing can exploit them.

---

# 19. Generator integration

## Topography

Topography should become a **proposal generator**, not final ranking authority.

It should supply:

```text
candidate
region / basin
similarity relationships
novelty estimate
predicted value
lineage
```

The evidence scheduler then tests those candidates.

Later, evaluation results should feed back into Topography so the topology reflects **measured value**, not only embedding geometry.

Recommended loop:

```text
Topography proposes
        ↓
Harvest evaluates
        ↓
evidence ledger
        ↓
measured fitness / failure / specialization
        ↓
Topography updates search priorities
```

---

## CMA-ES

Use CMA-ES when:

- candidate representation contains meaningful continuous parameters;
- the objective landscape is smooth enough;
- repeated evaluations are affordable.

CMA-ES should generate parameterized challengers.

The Harvest evaluator remains authoritative.

---

## CEM

Use CEM when:

- candidate configuration can be represented as a distribution;
- elite sampling can progressively concentrate useful configurations;
- categorical/discrete choices are present.

CEM updates its proposal distribution from Harvest evidence.

Do not let "CEM elite" automatically mean "assimilate."

---

## Bayesian optimization

Use BO when:

- evaluation is expensive;
- dimensions are modest;
- uncertainty modeling is useful;
- candidate parameters have interpretable search spaces.

BO decides what configuration is worth testing.

The evidence ladder decides whether it is worth keeping.

---

## LLM generation

An LLM should receive:

- experiment contract;
- baseline implementation;
- required interfaces;
- explicit metric;
- failure constraints.

It should not receive only a harvested title such as:

> "Adaptive mutation gate × Priority scheduler"

and then be expected to invent arbitrary code.

The generator must implement a testable hypothesis.

---


# 19A. Embedding-harvest search: the concrete integration contract

This section is **mandatory** for Agent_X's embedding-based Harvest search. The previous sections define how candidate evidence is allocated; this section defines what the embedding-search layer actually proposes, how a proposed vector becomes a real harvest result, and what the scheduler is allowed to optimize.

## 19A.1 Critical rule: never treat an arbitrary embedding vector as a harvest result

An embedding vector is not a reversible encoding of a useful algorithm, document, capability, or query. A vector produced by CMA-ES, CEM, Bayesian optimization, interpolation, extrapolation, or any other numerical method may be geometrically valid while being semantically meaningless or off the embedding model's natural manifold.

Therefore Agent_X must use this bridge:

```text
search state / numerical proposal
        ↓
HarvestProbe
        ↓
retrieval against a versioned embedding index
        ↓
real corpus items
        ↓
dedup + relevance/substance filters
        ↓
HarvestCandidate(s)
        ↓
ASHA / Hyperband evidence scheduler
        ↓
measured downstream outcome
```

The **retrieved real item**, not the synthetic vector, is the object that can ultimately become a Harvest candidate.

Synthetic vectors are allowed only as **retrieval probes**.

Do not attempt to "decode" arbitrary embedding vectors back into text.

---

## 19A.2 Required object model for embedding Harvest

Keep the following objects separate:

```python
@dataclass(frozen=True)
class CorpusSnapshot:
    corpus_id: str
    snapshot_id: str
    content_hash: str
    item_count: int
    created_at: str


@dataclass(frozen=True)
class EmbeddingSpec:
    provider: str
    model: str
    revision: str | None
    dimension: int
    metric: str                 # cosine | dot | l2
    normalized: bool
    preprocessing_version: str


@dataclass(frozen=True)
class EmbeddedItem:
    item_id: str
    content_hash: str
    source_ref: str
    embedding_ref: str
    corpus_snapshot_id: str
    embedding_spec_id: str


@dataclass(frozen=True)
class HarvestProbe:
    probe_id: str
    generator: str
    generator_version: str
    parent_probe_ids: tuple[str, ...]
    seed_refs: tuple[str, ...]
    vector_ref: str | None
    text_query: str | None
    filters: tuple[str, ...]
    retrieval_k: int
    params_hash: str
    corpus_snapshot_id: str
    embedding_spec_id: str


@dataclass(frozen=True)
class RetrievalHit:
    probe_id: str
    item_id: str
    rank: int
    distance: float
    exact_or_ann: str
    index_version: str


@dataclass(frozen=True)
class ProbeOutcome:
    probe_id: str
    retrieved_unique: int
    substantive_candidates: int
    benchmark_positive: int
    promoted_candidates: int
    total_cost: float
```

Do not collapse these into one generic candidate structure. The scheduler needs to distinguish:

- a search probe;
- a retrieved corpus item;
- a generated implementation candidate;
- a promoted capability.

---

## 19A.3 Embedding provider contract

The embedding layer must expose a stable interface:

```python
class EmbeddingProvider(Protocol):
    @property
    def spec(self) -> EmbeddingSpec:
        ...

    def embed_texts(self, texts: Sequence[str]) -> list[Sequence[float]]:
        ...
```

Every produced vector must be validated before indexing or querying:

```text
length == declared dimension
all values finite
no NaN
no +/-Inf
norm semantics match metric contract
provider/model/revision recorded
preprocessing version recorded
```

If cosine similarity is used, normalization must be explicit and consistent. Do not silently mix normalized and unnormalized vectors.

If dot product is used, do not assume it is equivalent to cosine unless vectors are normalized.

If Euclidean/L2 is used, thresholds must be calibrated independently.

---

## 19A.4 Embedding identity and cache key

Embedding cache identity must include at minimum:

```text
content_hash
provider
model
model revision if available
dimension
preprocessing_version
normalization policy
```

Recommended key:

```text
sha256(
    canonical_content_hash
  + embedding_spec_fingerprint
)
```

Never reuse an embedding across a changed preprocessing pipeline merely because source text is unchanged.

---

## 19A.5 Canonical preprocessing

Define one deterministic function:

```python
def canonicalize_for_embedding(item: SourceItem) -> str:
    ...
```

It must specify:

- Unicode normalization;
- newline normalization;
- decoding policy;
- binary rejection;
- maximum content policy;
- title/path metadata inclusion or exclusion;
- source boilerplate stripping;
- code/comment handling;
- chunking policy;
- language handling;
- whitespace handling.

The preprocessing version must change whenever semantics change.

Do not use filesystem paths as semantic content unless path information is intentionally part of the retrieval hypothesis.

---

## 19A.6 Chunking contract

For large source items, embeddings should normally be produced from bounded semantic chunks rather than only whole files.

Each chunk requires stable identity:

```text
source_item_id
chunker_version
chunk_index
start/end logical position
chunk_content_hash
```

A retrieved chunk must always resolve back to its parent source item.

Promotion/deduplication should occur at both levels:

```text
chunk-level retrieval dedup
        ↓
source-item aggregation
        ↓
capability/candidate dedup
```

Otherwise one long document can occupy most of the top-K results with neighboring chunks.

---

## 19A.7 Corpus snapshotting

Every evaluation run must bind to a fixed corpus snapshot.

A corpus snapshot must record:

```text
set of source item IDs/content hashes
chunker version
embedding spec
index version
metadata/filter schema version
```

This is essential because a changing corpus can make two search algorithms appear different even when the search logic did not change.

A new corpus snapshot does not invalidate historical evidence; it creates a new evaluation context.

---

## 19A.8 Index contract

Agent_X should define an index interface independent of the implementation:

```python
class VectorIndex(Protocol):
    def search(
        self,
        query_vector: Sequence[float],
        k: int,
        filters: Mapping[str, object] | None = None,
    ) -> list[RetrievalHit]:
        ...

    def exact_search(...):
        ...
```

The index implementation may later use HNSW, FAISS, ScaNN, a database extension, or another ANN backend. Harvest logic must not depend on backend-specific behavior.

For a new index build:

1. build ANN index;
2. sample representative queries;
3. compare ANN top-K with exact top-K;
4. record recall@K and latency;
5. reject index configuration if ANN recall is below the configured floor.

The scheduler must not mistake ANN approximation error for search-algorithm quality.

---

## 19A.9 Model/version drift

Embedding spaces from different models or materially different model revisions are not assumed to be directly comparable.

Never:

- query an index with a vector from an incompatible embedding model;
- compare raw distances across unrelated embedding specs;
- reuse topology coordinates across incompatible spaces;
- transfer a numeric similarity threshold without recalibration.

On embedding model change:

```text
1. create new EmbeddingSpec fingerprint
2. rebuild/re-embed corpus
3. create new index version
4. recalibrate distance distributions
5. rerun baseline harvest benchmarks
6. begin new evidence series
```

Historical outcomes can still train higher-level priors, but raw geometry must not be mixed.

---

## 19A.10 Search objective

The embedding-search objective is **not**:

```text
maximize semantic similarity
```

and not:

```text
maximize geometric novelty
```

The actual objective is closer to:

```text
maximize expected downstream Harvest value per unit search/evaluation cost
```

A practical delayed reward for probe `p` is:

```text
R(p) =
    w1 * unique_substantive_candidates
  + w2 * benchmark_positive_candidates
  + w3 * promoted_candidates
  + w4 * measured_system_improvement
  - w5 * duplicate_rate
  - w6 * retrieval/evaluation_cost
```

Do not assign large reward merely because a probe found geometrically distant content.

Novelty is useful only when it leads to new, relevant, substantive evidence.

---

## 19A.11 Two-stage reward: immediate proxy + delayed authority

Because final candidate promotion can be expensive, use two reward classes.

### Proxy reward

Available quickly:

```text
unique relevant hits
novel source coverage
R1 substance pass rate
non-duplicate yield
```

### Authoritative delayed reward

Available later:

```text
R3 benchmark-positive yield
R4 integration-positive yield
champion/complement promotion
measured Agent_X system improvement
```

Generators may adapt from proxy rewards early, but authoritative delayed reward must eventually dominate generator allocation.

This prevents the embedding search from learning to maximize a superficial proxy.

---

## 19A.12 Credit assignment

One candidate may be retrieved by many probes.

Do not give every probe full credit.

Store all retrieval provenance, then choose a credit policy such as:

```text
FIRST_DISCOVERY
SHAPED_SHARED_CREDIT
MARGINAL_CREDIT
DECAYED_DUPLICATE_CREDIT
```

Recommended initial policy:

```text
first probe that surfaced a candidate receives primary credit
later probes receive small discovery-redundancy credit or zero promotion credit
```

Also track generator-level attribution.

Without this, a broad high-recall probe can appear artificially strong by repeatedly rediscovering candidates found elsewhere.

---

## 19A.13 Safe parameterization of embedding search

Avoid directly optimizing every coordinate of a 768/1024/1536+ dimensional embedding vector unless there is strong evidence that doing so improves retrieval.

Raw high-dimensional coordinate optimization is vulnerable to:

- off-manifold proposals;
- concentration of measure;
- unstable local geometry;
- metric artifacts;
- weak interpretability;
- expensive optimization;
- vectors that retrieve accidental nearest neighbors.

Preferred search parameterizations are, in order:

### A. Real-query embedding search

Generate or mutate **text queries**, embed them using the same provider, then retrieve.

This guarantees probes lie on the model's text-embedding manifold.

```text
query text
   ↓ embed
valid probe vector
   ↓ retrieve
real items
```

### B. Weighted mixtures of real embeddings

Construct a probe from known-valid vectors:

```text
q = normalize(sum_i w_i * e_i)
```

Constrain weights and keep seed provenance.

### C. Directional residual search

Use a valid anchor and measured success/failure directions:

```text
q_new = normalize(q_anchor + alpha * direction)
```

Bound `alpha` and validate neighborhood behavior.

### D. Low-dimensional learned/control search

Optimize a compact set of interpretable controls such as:

```text
seed selection
mixture weights
expansion strength
novelty pressure
neighborhood radius
source/category filters
retrieval depth
query-expansion strategy
```

Use CMA-ES/CEM/BO over these parameters rather than over raw embedding coordinates.

### E. Raw-vector optimization

Allowed only as an experimental lane with strict validation and a small budget.

It should not be the default.

---

## 19A.14 Probe validity checks

Before spending full retrieval budget on a synthetic probe, run cheap checks:

```text
finite vector
correct dimension
correct norm policy
not approximately zero vector
not duplicate/near-duplicate of recent probe
reasonable nearest-neighbor distance distribution
reasonable local density
not pathological single-item collapse
```

Optional off-manifold heuristics:

- distance to nearest real-query embeddings;
- local density ratio;
- projection/reconstruction error if a manifold model is deliberately introduced;
- neighborhood coherence.

Do not make an off-manifold heuristic a permanent truth criterion without empirical validation.

---

## 19A.15 Probe generators to implement

Agent_X should expose embedding-search generators behind one interface:

```python
class ProbeGenerator(Protocol):
    def propose(
        self,
        context: SearchContext,
        budget: ProposalBudget,
    ) -> Iterable[HarvestProbe]:
        ...

    def observe(self, outcomes: Sequence[ProbeOutcome]) -> None:
        ...
```

Recommended generators:

```text
baseline_topography
semantic_neighbors
query_mutation
centroid_mixture
frontier_expansion
residual_direction
CEM_control_search
CMAES_control_search
Bayesian_control_search
randomized_diversity_control
```

Every generator must be evaluated under the same evidence system.

---

## 19A.16 Baseline Topography adapter

The existing Topography search should be wrapped, not deleted initially.

```python
class TopographyProbeGenerator:
    def propose(self, context, budget):
        # existing topography logic
        # returns HarvestProbe objects only
        ...

    def observe(self, outcomes):
        # optional evidence feedback
        ...
```

This creates a baseline against which the newer search methods can be evaluated.

Do not rewrite Topography and the scheduler simultaneously in the first experiment; otherwise causal attribution becomes difficult.

---

## 19A.17 Topography should become evidence-weighted

A geometric topology alone should not decide where Harvest spends most of its budget.

Each region/node/basin should accumulate empirical state:

```python
@dataclass
class RegionStats:
    region_id: str
    probes: int
    unique_hits: int
    substantive_hits: int
    benchmark_positive: int
    promoted: int
    total_cost: float
    mean_reward: float
    reward_uncertainty: float
    last_explored_at: str
```

Future search allocation can then use an exploration/exploitation rule:

```text
priority(region) =
    expected_value
  + uncertainty_bonus
  + coverage_bonus
  - redundancy_penalty
  - cost_penalty
```

The exact formula should remain configurable and benchmarked.

---

## 19A.18 Search modes

Support explicit modes rather than one opaque search behavior.

### EXPLOIT

Search around regions with demonstrated downstream yield.

### EXPLORE

Search under-sampled/high-uncertainty regions.

### FRONTIER

Search between successful and unsuccessful regions to find boundaries and nearby improvements.

### DIVERSIFY

Search far from already-covered successful candidates while preserving relevance.

### RECOVER

Revisit historically promising regions after corpus/model changes.

Balanced Harvest should combine these modes under a budget policy.

---

## 19A.19 Diversity and duplicate control

Similarity search naturally overproduces near-duplicates.

Apply deduplication at several layers:

```text
exact content hash
canonical content hash
source identity
chunk overlap
embedding near-duplicate
semantic/capability duplicate
implementation behavior duplicate
```

For retrieval-set diversification, an MMR-style or equivalent reranking step may be used:

```text
utility(hit) = relevance_to_probe - lambda * redundancy_with_selected
```

But the diversification parameter must be benchmarked against actual downstream Harvest yield.

Do not assume more diversity is always better.

---

## 19A.20 Embedding-distance calibration

Do not hardcode universal similarity thresholds.

For every EmbeddingSpec + corpus snapshot, estimate empirical distributions for:

```text
random pair similarity
near-duplicate similarity
same-source chunk similarity
same-domain similarity
known-relevant similarity
known-irrelevant similarity
```

Use these distributions to calibrate:

- duplicate thresholds;
- neighborhood radius;
- frontier radius;
- novelty bands.

Recalibrate when embedding model, preprocessing, or corpus changes materially.

---

## 19A.21 Retrieval filters

Filters are part of the search policy and must be recorded in probe identity.

Possible filters:

```text
source type
license/provenance class
domain
language
time range
file type
repository
patent class
code/text
known duplicate exclusion
already-assimilated exclusion
```

A filter change can materially change results; it therefore belongs in experimental provenance.

---

## 19A.22 Retrieval depth as fidelity

For embedding search, `k` is one useful resource dimension.

Example:

```text
R_probe_0: k=10
R_probe_1: k=50
R_probe_2: k=250
R_probe_3: k=1000 or corpus-shard expansion
```

But increasing `k` is not the only fidelity dimension.

Other resources may include:

```text
number of corpus shards searched
number of query variants
number of embedding seeds
number of rerank evaluations
number of retrieved items sent to R1 substance checks
number of downstream benchmark tasks
```

The scheduler must record exactly which resource dimension was increased.

---

## 19A.23 Separate probe racing from candidate racing

Agent_X has two distinct races:

### Race 1 — Search-probe race

Question:

> Which embedding/search strategies deserve more retrieval budget?

Evidence:

```text
unique relevant yield
substantive candidate yield
duplicate rate
cost
downstream promotion yield
```

### Race 2 — Candidate race

Question:

> Which retrieved/generated candidate deserves deeper implementation and integration testing?

Evidence:

```text
correctness
benchmark delta
integration delta
robustness
cost
```

Do not mix these into one score or one ASHA rung sequence.

Recommended pipeline:

```text
ProbeASHA
   ↓ retrieval
CandidateASHA
   ↓
Champion/Challenger
```

A bad probe can still accidentally discover a great candidate; candidate evidence remains independent.

A good probe can retrieve several bad candidates; probe value should be based on aggregate yield, not a single hit.

---

## 19A.24 Probe-level ASHA

Suggested initial probe rungs:

```yaml
probe_rungs:
  P0:
    retrieval_k: 10
    max_substance_checks: 10
  P1:
    retrieval_k: 50
    max_substance_checks: 30
  P2:
    retrieval_k: 250
    max_substance_checks: 100
  P3:
    retrieval_k: 1000
    max_substance_checks: 250
```

Promotion evidence should include:

```text
unique_hit_rate
substantive_hit_rate
novel_candidate_rate
duplicate_rate
cost_per_substantive_candidate
later benchmark-positive yield if available
```

Early probe promotion can rely more heavily on proxy yield.

Long-term allocation should use delayed downstream outcomes.

---

## 19A.25 Candidate-level ASHA

Candidate rungs remain approximately:

```text
C0 structural
C1 substance
C2 correctness/properties
C3 isolated benchmark
C4 integration
C5 champion comparison
C6 shadow/canary where needed
```

Keep probe-rung and candidate-rung identifiers distinct in code and storage.

Do not use generic `R0`, `R1` everywhere once both schedulers exist.

---

## 19A.26 Bracket assignment for probes

A probe may be assigned to:

```text
P_AGGRESSIVE
P_BALANCED
P_EXPLORATORY
```

Bracket selection can consider:

```text
generator maturity
novelty
uncertainty
cost
whether probe is on-manifold
historical generator yield
region coverage
```

Raw-vector experimental probes should normally enter the smallest exploratory bracket.

---

## 19A.27 Search budget accounting

Track probe-search cost separately from candidate-evaluation cost.

```python
@dataclass
class SearchCost:
    embed_calls: int = 0
    embedded_tokens: int = 0
    ann_queries: int = 0
    exact_queries: int = 0
    rerank_calls: int = 0
    retrieved_items_scored: int = 0
    wall_seconds: float = 0.0
    cpu_seconds: float = 0.0
    gpu_seconds: float = 0.0
```

This lets Agent_X answer:

```text
Which search strategy finds useful candidates most cheaply?
```

rather than only:

```text
Which search strategy finds the most candidates?
```

---

## 19A.28 Work deduplication and idempotency

Asynchronous workers will race unless all jobs are idempotent.

Use deterministic job keys:

```text
embed_job_key = hash(content_hash + embedding_spec)
probe_job_key = hash(probe_id + index_version + rung + resource_spec)
candidate_eval_job_key = hash(candidate_id + evaluator_version + rung + benchmark_snapshot)
```

Before dispatch:

```text
if completed(job_key): reuse result
elif running(job_key) and lease_valid: do not duplicate
else: acquire lease and run
```

Every write must be safe under retry.

---

## 19A.29 Worker leases and crash recovery

Every running job should have:

```text
job_id
owner_worker_id
lease_expires_at
heartbeat_at
attempt
max_attempts
```

If a worker dies:

1. lease expires;
2. job returns to READY;
3. another worker may claim it;
4. append-only evidence prevents partial result overwrite.

Do not encode worker-local state as scheduler authority.

---

## 19A.30 Atomic evidence commit

An evaluation result must become visible atomically:

```text
BEGIN
  write evaluation record
  write metric observations
  mark job COMPLETED
  append state transition
COMMIT
```

If using files instead of a database initially:

```text
write temp file
fsync where appropriate
atomic rename
append immutable event
```

A crash must not leave a job marked complete with missing evidence.

---

## 19A.31 Determinism and randomness

Every stochastic proposal or evaluation must record:

```text
RNG algorithm
seed
parent seed if derived
generator version
```

Do not use ambient global randomness as the only source of stochastic state.

Recommended derivation:

```text
seed = hash(run_id, generator_id, bracket_id, ordinal)
```

This allows exact replay of search proposals.

---

## 19A.32 Search-state checkpointing

CEM/CMA-ES/BO and evidence-weighted Topography require durable optimizer state.

Checkpoint at each completed generation/update:

```text
optimizer type/version
search-space schema version
population/distribution state
observations consumed
RNG state or reproducible seed lineage
best-known probes
pending probe IDs
```

On restart, restore from last committed checkpoint and reconcile pending jobs from the scheduler ledger.

---

## 19A.33 Search-space schema versioning

A change to optimized parameters creates a new search-space version.

Example:

```yaml
search_space_version: 3
parameters:
  novelty_pressure: [0.0, 1.0]
  neighbor_k: [10, 500]
  mixture_alpha: [0.0, 2.0]
  query_mutation_strength: [0.0, 1.0]
  source_weight_patent: [0.0, 1.0]
```

Do not blindly restore CMA-ES/CEM/BO state into an incompatible parameter schema.

---

## 19A.34 Cold-start behavior

Before meaningful promotion history exists:

1. use baseline Topography as one arm;
2. use simple semantic-neighbor/query-mutation probes;
3. allocate balanced exploration across generators;
4. collect R1/R3 outcome statistics;
5. delay aggressive adaptive reallocation until minimum evidence exists.

Do not let the first few lucky probes permanently dominate search budget.

Use minimum-observation floors before strong exploitation.

---

## 19A.35 Delayed-feedback handling

Final promotion may happen much later than retrieval.

Maintain two ledgers:

```text
probe -> retrieval hits
candidate -> final outcomes
```

Then periodically back-propagate candidate outcomes to all contributing probes/generators according to the configured credit policy.

The feedback worker must be idempotent.

Recommended event:

```json
{
  "type": "PROBE_REWARD_UPDATED",
  "probe_id": "...",
  "candidate_id": "...",
  "credit": 0.7,
  "reward_delta": 1.4,
  "outcome_version": "..."
}
```

---

## 19A.36 Prevent feedback leakage

Do not use evaluation-set labels/results to construct queries that are then scored on the same evaluation set without separation.

Maintain:

```text
SEARCH/TRAIN split
VALIDATION split
HOLDOUT split
```

Use SEARCH/TRAIN for optimizer updates.

Use VALIDATION for scheduler tuning.

Use HOLDOUT only for final comparison of the complete harvesting policy.

If the corpus itself is the search universe, hold out **benchmark tasks/seed families/time slices/source classes**, not necessarily the retrievable items themselves.

The exact split must reflect the actual claim being tested.

---

## 19A.37 Benchmark leakage prevention

A harvested algorithm may contain benchmark-specific logic.

Therefore benchmark metadata and test labels should not be supplied to candidate-generating LLMs unless necessary.

Use hidden or held-out test cases for final comparison.

Record whether a candidate had access to:

```text
benchmark inputs
benchmark outputs
metric code
baseline results
holdout identities
```

This is part of evidence provenance.

---

## 19A.38 Embedding-search benchmark suite

Build a fixed benchmark specifically for the Harvest search layer.

It should contain representative seed families such as:

```text
retrieval improvement
scheduler improvement
agent orchestration
memory/context
code repair/refactor
evolution/mutation
UI performance
security/governance
mathematical algorithms
patents/external technical corpus
```

For each seed family, record known useful targets or at least downstream judgments from the same candidate evaluator.

Compare search policies using identical corpus snapshots and budgets.

---

## 19A.39 Search-policy comparison metrics

Primary metrics should include:

```text
unique_substantive_candidates_per_1k_retrieved
benchmark_positive_candidates_per_search_cost
promoted_candidates_per_search_cost
time_to_first_promoted_candidate
cost_to_first_promoted_candidate
coverage_of_capability_domains
duplicate_rate
```

Secondary metrics:

```text
ANN latency
embedding cost
probe generation cost
scheduler overhead
index memory
```

Do not optimize only Recall@K unless the benchmark has trusted relevant-item labels.

For Agent_X the most valuable metric is downstream useful-candidate yield.

---

## 19A.40 Baselines that must be compared

At minimum compare:

```text
B0 random valid probes
B1 direct semantic nearest-neighbor search
B2 current Topography
B3 Topography + evidence allocation
B4 best new single probe generator
B5 portfolio of probe generators + ProbeASHA
```

This isolates whether gains come from:

- the proposal generator;
- the scheduler;
- or their combination.

---

## 19A.41 Ablation tests

Run ablations for:

```text
without diversity pressure
without delayed reward
without uncertainty bonus
without exploration reserve
without R1 substance gate
without probe ASHA
without candidate ASHA
without generator adaptation
```

A component should remain only if it provides measurable value or necessary safety/correctness.

---

## 19A.42 Exact-vs-ANN correctness test

For a deterministic sample of probes:

```text
exact_top_k = exact_search(q, k)
ann_top_k = ann_search(q, k)
recall = |intersection| / k
```

Track:

```text
mean recall@K
p05 recall@K
worst-case recall@K
latency ratio
```

If ANN recall degrades after an index change, search-policy benchmarks are not comparable until corrected or explicitly rebased.

---

## 19A.43 Shadow evaluation before replacing Topography

Run the new embedding search in shadow mode:

```text
production Harvest request
     ├─ current Topography -> authoritative candidates
     └─ new policy -> shadow candidates/evidence only
```

Compare equal-budget yield.

Do not allow the new policy to write permanent code during the first shadow phase.

Promotion criterion should require a sustained advantage over the current Topography baseline and no material guardrail regression.

---

## 19A.44 Incremental index updates

If the corpus changes continuously, distinguish:

```text
immutable benchmark snapshot
live production index
```

For live updates:

- stable item IDs;
- tombstones for removals;
- idempotent upserts;
- index-generation identifier;
- background rebuild capability;
- query routing to one coherent index generation.

Avoid serving one probe partly from two index generations unless the index backend guarantees coherent semantics.

---

## 19A.45 Deletions and provenance

If source content is removed, mark the source/item unavailable and prevent new retrieval.

Historical evidence may retain hashes/metrics/provenance as permitted, but active source content should respect the deletion policy.

A promoted candidate whose provenance becomes invalid or prohibited should be reviewable through governance.

---

## 19A.46 Missing and failed embeddings

Embedding failure must not silently drop items from evaluation.

Track states:

```text
PENDING
EMBEDDED
FAILED_RETRYABLE
FAILED_PERMANENT
EXCLUDED_POLICY
```

Expose corpus coverage:

```text
embedded_items / eligible_items
```

Search benchmarks are invalid if coverage differs materially between compared policies without accounting for it.

---

## 19A.47 Batch sizing and backpressure

Embedding/index workers should honor queue and provider limits.

Use bounded batches and explicit backpressure.

The scheduler should stop proposing new probes when any of these exceed configured limits:

```text
embedding queue depth
retrieval queue depth
R1 candidate queue depth
benchmark queue depth
storage pressure
cost budget
```

Otherwise the system can generate search work much faster than it can evaluate it, recreating Harvest clutter in the queue rather than the source tree.

---

## 19A.48 Admission control

Before a probe enters ProbeASHA, perform cheap admission checks:

```text
valid spec
new probe identity
budget available
corpus/index compatible
not denied by governance
not excessive duplicate of recent probes
```

Before a retrieval hit becomes a candidate:

```text
source permitted
not exact duplicate
not already rejected for identical content under same relevant context
meets minimum relevance floor if configured
```

Do not repeatedly evaluate identical material discovered through many probes.

---

## 19A.49 Re-evaluation policy

A previously rejected item may be reconsidered only when the evidence context materially changes, for example:

```text
new baseline/champion
new benchmark suite
new corpus/source context
new candidate implementation
new embedding model only if retrieval context matters
material evaluator bug fix
changed capability objective
```

Use a `context_fingerprint` to decide whether old rejection evidence is reusable.

---

## 19A.50 Search context fingerprint

Recommended fingerprint inputs:

```text
corpus_snapshot_id
embedding_spec_id
index_version
search_space_version
probe_generator_version
retrieval policy version
dedup version
R1 evaluator version
benchmark snapshot/version
champion version where downstream reward depends on it
```

This prevents stale evidence from contaminating current scheduler decisions.

---

## 19A.51 Candidate identity after retrieval

A candidate's identity should not depend on which probe found it.

For retrieved immutable content:

```text
candidate_source_identity = hash(canonical content + provenance class)
```

For generated implementation candidates:

```text
candidate_identity = hash(
    canonical source/code
  + experiment contract
  + relevant build configuration
)
```

Probe provenance is a many-to-many relation, not part of intrinsic candidate identity.

---

## 19A.52 Retrieval-set aggregation

When multiple chunks of one source are retrieved, aggregate before expensive candidate evaluation.

Possible source score:

```text
max chunk relevance
+ bounded support from additional independent chunks
```

Do not simply sum every chunk score, which favors long documents.

Record the chosen aggregation function and version.

---

## 19A.53 Query mutation constraints

If an LLM or rule system mutates textual search queries:

- keep seed/query lineage;
- cap query length;
- reject empty/non-semantic mutations;
- detect duplicate paraphrases;
- preserve domain constraints when required;
- do not allow hidden benchmark labels into prompts;
- embed the mutated text using the same EmbeddingSpec as the index.

Query mutation outcome should be judged on retrieval yield, not linguistic plausibility.

---

## 19A.54 CEM integration for embedding Harvest

Preferred CEM search variables:

```text
query-family choice
seed-item mixture weights
novelty pressure
retrieval depth
region selection
source filter weights
query-mutation operator probabilities
```

CEM loop:

```text
sample control vectors
        ↓
construct valid probes
        ↓
ProbeASHA evaluates
        ↓
collect reward estimates
        ↓
select elite controls
        ↓
update sampling distribution
```

Use smoothing/minimum variance floors so the distribution does not collapse after a few lucky samples.

---

## 19A.55 CMA-ES integration for embedding Harvest

Preferred CMA-ES use:

- low-dimensional continuous control vector;
- continuous mixture coefficients;
- directional step sizes;
- exploration/exploitation parameters.

Avoid defaulting CMA-ES to the raw embedding dimension.

CMA-ES fitness should be based on probe reward under a fixed resource rung or normalized for resource differences.

Do not compare fitness from `k=10` against `k=1000` without fidelity-aware normalization.

---

## 19A.56 Bayesian optimization integration

BO is useful when each probe evaluation is expensive and the control space is compact.

The observation should include:

```text
control vector
resource rung
reward estimate
noise/variance
cost
context fingerprint
```

For multi-fidelity BO, include resource/fidelity explicitly rather than treating low- and high-fidelity outcomes as identical observations.

If dimensionality becomes large or categorical structure dominates, prefer CEM or another suitable generator.

---

## 19A.57 Search portfolio allocation

Do not permanently choose one generator if a portfolio performs better.

Treat generators as arms with delayed rewards.

Initial policy can use a conservative UCB/Thompson-like allocator or a simpler explicit budget table:

```yaml
generator_budget:
  topography: 0.35
  query_mutation: 0.20
  centroid_mixture: 0.15
  cem_controls: 0.10
  cmaes_controls: 0.10
  bayes_controls: 0.05
  random_diversity: 0.05
```

Then adapt slowly from downstream promotion yield.

Maintain minimum exploration floors so a temporarily unlucky generator is not permanently starved.

---

## 19A.58 Non-stationarity

Harvest reward changes when:

```text
corpus changes
embedding model changes
Agent_X champion changes
benchmarks change
new domains enter the system
previous easy wins are exhausted
```

Therefore generator statistics should be time/context-aware.

Use:

- context fingerprints;
- rolling windows or decayed statistics;
- minimum recent exploration;
- explicit reset/rebase after major representation changes.

Do not assume all historical reward is equally relevant forever.

---

## 19A.59 Coverage objective

Pure exploitation can repeatedly mine one productive semantic basin.

Track coverage across:

```text
capability domains
source classes
semantic clusters
algorithm families
known Agent_X gaps
```

Use a bounded coverage bonus only where broader coverage is strategically useful.

Coverage must not override hard relevance or governance constraints.

---

## 19A.60 Negative-space learning

Rejected candidates contain useful information.

Record semantic regions associated with:

```text
duplicates
placeholders
wrong-domain hits
low-substance items
benchmark failures
integration regressions
```

Use these as **soft negative evidence**, not permanent exclusion zones.

A later corpus/model/champion change can make an old negative region relevant again.

---

## 19A.61 Search region representation

A region should have stable semantics independent of a visualization.

Possible internal representation:

```text
cluster ID + member anchors
seed/centroid references
radius/density statistics
outcome statistics
context fingerprint
```

Do not make 2D/3D visualization coordinates the authoritative search representation. Projection methods distort high-dimensional distances.

Visualization is diagnostic only.

---

## 19A.62 Dimensionality reduction

PCA/UMAP/t-SNE or similar projections may be useful for inspection, clustering support, or low-dimensional control experiments, but:

- t-SNE should not be used as a metric-preserving global search space;
- UMAP distances should not automatically replace original-space similarity;
- PCA loses information and requires variance/quality checks;
- any reduced space used for optimization needs benchmark evidence against original-space baselines.

The original embedding/index remains the retrieval authority unless a reduced-space method is explicitly validated.

---

## 19A.63 Search termination

An embedding-search run needs explicit stop conditions.

Stop when any configured condition is met:

```text
global cost budget exhausted
wall-clock budget exhausted
maximum probe count reached
no meaningful reward improvement for N updates
all active brackets exhausted
queue backpressure threshold reached
marginal unique/substantive yield below floor
user/governance cancellation
```

An "infinite Harvest" mode must still operate as repeated bounded epochs with checkpoints and budgets.

No internal optimizer should contain an uncontrolled infinite loop.

---

## 19A.64 Epoch model for continuous Harvest

Recommended continuous execution:

```text
Epoch starts
  ↓ freeze policy/context fingerprints
  ↓ allocate bounded search budget
  ↓ run ProbeASHA
  ↓ candidate evaluation continues
  ↓ close search admissions
  ↓ collect available outcomes
  ↓ checkpoint generator updates
  ↓ publish epoch report
Epoch ends
```

Delayed candidate outcomes may update later epochs through the reward back-propagation ledger.

This yields continuous operation without unrecoverable unbounded state.

---

## 19A.65 Configuration schema

Recommended initial configuration:

```yaml
harvest_embedding_search:
  enabled: true

  corpus:
    snapshot_mode: fixed_per_epoch

  embedding:
    provider: configured_provider
    model: configured_model
    normalize: true

  retrieval:
    metric: cosine
    ann_recall_floor_at_20: 0.95
    default_k: 50
    max_k: 1000

  probe_scheduler:
    policy: asha_hyperband
    brackets:
      - aggressive
      - balanced
      - exploratory

  candidate_scheduler:
    policy: asha_hyperband

  exploration:
    minimum_generator_share: 0.05
    raw_vector_probe_share_max: 0.02

  dedup:
    exact: true
    semantic: true

  budgets:
    max_probe_count_per_epoch: 1000
    max_retrieved_items_per_epoch: 100000
    max_candidate_benchmarks_per_epoch: 500

  safety:
    production_write_before_candidate_r3: false
    require_experiment_contract: true
```

Values are starting points. They must be tuned against Agent_X benchmarks.

---

## 19A.66 Reference orchestration pseudocode

```python
def run_embedding_harvest_epoch(ctx: HarvestContext) -> EpochReport:
    snapshot = freeze_corpus_snapshot(ctx)
    emb_spec = resolve_embedding_spec(ctx)
    index = ensure_compatible_index(snapshot, emb_spec)

    assert index.embedding_spec_id == emb_spec.id
    assert index.corpus_snapshot_id == snapshot.id

    probe_scheduler = load_probe_scheduler(ctx)
    candidate_scheduler = load_candidate_scheduler(ctx)
    generators = load_probe_generators(ctx)

    while probe_scheduler.can_admit_more():
        generator = choose_generator(generators, ctx)
        probes = generator.propose(ctx.search_context(), budget=ctx.proposal_budget)

        for probe in probes:
            if not admit_probe(probe, ctx):
                continue
            probe_scheduler.enqueue(probe)

        for completed_probe_eval in run_ready_probe_work(index, probe_scheduler, ctx):
            commit_probe_evidence(completed_probe_eval)

            for hit in completed_probe_eval.new_hits:
                item = resolve_retrieval_hit(hit)
                if not admit_retrieved_item(item, ctx):
                    continue

                candidate = materialize_candidate(item, provenance=hit)
                link_probe_candidate(completed_probe_eval.probe_id, candidate.candidate_id)

                if candidate_scheduler.needs_evaluation(candidate):
                    candidate_scheduler.enqueue(candidate)

            decision = probe_scheduler.decide(completed_probe_eval)
            apply_probe_decision(decision)

        for completed_candidate_eval in run_ready_candidate_work(candidate_scheduler, ctx):
            commit_candidate_evidence(completed_candidate_eval)
            decision = candidate_scheduler.decide(completed_candidate_eval)
            apply_candidate_decision(decision)
            backpropagate_probe_credit(completed_candidate_eval)

        enforce_backpressure(ctx)
        checkpoint_if_due(ctx)

    finalize_epoch_admissions(ctx)
    reconcile_running_jobs(ctx)
    checkpoint_all_optimizers(ctx)
    return build_epoch_report(ctx)
```

The actual implementation may use queues/workers rather than this single control loop, but these authority boundaries should remain.

---

## 19A.67 Minimal database/logical tables

Whether stored in SQLite/PostgreSQL/another durable store, the logical schema should include:

```text
corpus_snapshots
embedding_specs
embedded_items
vector_indexes
harvest_probes
probe_jobs
probe_evidence
retrieval_hits
harvest_candidates
candidate_jobs
candidate_evidence
probe_candidate_links
optimizer_checkpoints
generator_stats
champion_registry
state_transitions
```

Important uniqueness constraints:

```text
unique(embedding cache key)
unique(probe_id)
unique(job_key)
unique(candidate_id)
unique(probe_id, item_id, index_version)
```

---

## 19A.68 Index-build validation gates

An index may become ACTIVE only if:

```text
all vectors match dimension
no invalid vectors
item count matches manifest within documented exclusions
exact-search smoke tests pass
ANN recall floor passes
query latency within configured ceiling or explicitly waived
index fingerprint stored
```

Otherwise mark it FAILED and retain the previous active index.

---

## 19A.69 Runtime compatibility checks

At query time assert:

```text
probe.embedding_spec_id == index.embedding_spec_id
probe.corpus_snapshot_id == index.corpus_snapshot_id
probe.vector_dimension == index.dimension
probe.metric_semantics compatible with index.metric
```

Fail closed on mismatch.

Do not coerce, truncate, or pad vectors to make incompatible dimensions fit.

---

## 19A.70 Search API boundary

Recommended service-level boundary:

```python
class HarvestEmbeddingSearch:
    def propose(self, request: HarvestSearchRequest) -> SearchRunId:
        ...

    def poll(self, run_id: SearchRunId) -> SearchRunState:
        ...

    def cancel(self, run_id: SearchRunId) -> None:
        ...

    def report(self, run_id: SearchRunId) -> SearchReport:
        ...
```

The UI should call this boundary rather than manipulating probe/rung internals.

---

## 19A.71 Observability

Required counters/gauges:

```text
harvest_embedding_items_total
harvest_embedding_failures_total
harvest_index_queries_total
harvest_probe_proposed_total
harvest_probe_promoted_total
harvest_probe_rejected_total
harvest_retrieval_hits_total
harvest_retrieval_unique_total
harvest_candidate_r1_substantive_total
harvest_candidate_promoted_total
harvest_duplicate_hits_total
harvest_search_cost_total
harvest_queue_depth{queue=...}
harvest_job_retry_total
harvest_false_prune_audit_total
```

Required distributions:

```text
embedding latency
ANN query latency
probe reward
candidate benchmark delta
cost per substantive candidate
cost per promoted candidate
```

Logs should use IDs and reason codes, not dump full private/source content by default.

---

## 19A.72 Failure reason taxonomy

Probe failures:

```text
INVALID_VECTOR
INCOMPATIBLE_EMBEDDING_SPEC
INCOMPATIBLE_INDEX
DUPLICATE_PROBE
INDEX_FAILURE
RETRIEVAL_TIMEOUT
BUDGET_EXHAUSTED
NO_UNIQUE_HITS
NO_SUBSTANTIVE_YIELD
DOMINATED_PROBE
```

Embedding failures:

```text
PROVIDER_ERROR
RATE_LIMIT
INVALID_RESPONSE
DIMENSION_MISMATCH
NONFINITE_VECTOR
CONTENT_REJECTED
```

Candidate failures should use the candidate outcome taxonomy already defined.

Structured reasons are essential for generator feedback.

---

## 19A.73 Security and trust boundaries

Retrieved content is untrusted input.

Before any LLM/code generation or execution stage:

- treat corpus instructions as data, not authority;
- strip/contain prompt-injection effects;
- preserve provenance;
- sandbox generated code;
- prevent retrieved source from altering governance or scheduler configuration;
- restrict filesystem/network access according to Agent_X execution policy.

The embedding search may discover a source; it does not grant that source authority.

---

## 19A.74 Licensing/provenance gate

If Harvest may assimilate external code/text, candidate admission must carry provenance and any relevant license/use policy classification.

A high search score cannot override a prohibited provenance class.

The evaluator should be able to distinguish:

```text
idea/reference only
compatible for adaptation
compatible for direct reuse
unknown/review required
prohibited
```

This is a hard gate before permanent assimilation where applicable.

---

## 19A.75 Resource starvation prevention

Use per-stage concurrency caps so deep benchmark work does not starve embedding/index work and vice versa.

Example:

```yaml
concurrency:
  embedding_workers: 4
  retrieval_workers: 8
  r1_workers: 8
  benchmark_workers: 4
  integration_workers: 2
```

Also reserve a minimum fraction for existing candidate completions before admitting more probes.

The system should prefer completing evidence on promising candidates over endlessly generating new search probes.

---

## 19A.76 Priority inversion prevention

A very large stream of cheap R0/R1 jobs must not indefinitely delay a nearly complete champion challenger.

Scheduling priority should include stage completion value, for example:

```text
priority =
    expected_information_value_per_cost
  + completion_bonus
  + aging_bonus
```

with hard governance/risk priorities where necessary.

---

## 19A.77 Fairness across domains

If multiple Harvest domains share workers, use weighted queues or domain budgets.

Without this, a high-volume domain may consume all embedding and benchmark capacity.

Track:

```text
requested budget
granted budget
consumed budget
yield by domain
```

Domain fairness is an operational policy; it should not be hidden inside semantic scores.

---

## 19A.78 Champion change and reward rebasing

When the current champion improves, old probe rewards based on beating an older weak baseline can become misleading.

Store the champion/baseline version for every downstream reward.

For current allocation, distinguish:

```text
historical discovery value
current competitive value
```

Periodically re-evaluate top retained challengers against the new champion if their old evidence is still potentially relevant.

---

## 19A.79 Counterfactual audit pool

To estimate whether ProbeASHA prunes useful search strategies too early:

1. sample rejected probes from each early rung;
2. give a small fraction the next-rung budget anyway;
3. measure how often they would have become strong;
4. estimate probe false-prune rate;
5. adjust promotion policy.

Maintain a separate candidate false-prune audit as already specified.

Both levels matter.

---

## 19A.80 Retrieval quality cannot be judged only from embedding distance

Embedding distance is an input signal.

R1 substance/relevance and downstream candidate outcomes are the authority.

A search method that retrieves slightly lower-similarity items but more substantive/promotable algorithms should win.

This is the central reason for connecting the embedding search to the evidence scheduler.

---

## 19A.81 Implementation order for Agent_X embedding Harvest

Implement in this order to reduce risk:

### E1 — Freeze contracts

Implement:

```text
EmbeddingSpec
CorpusSnapshot
HarvestProbe
RetrievalHit
probe/candidate IDs
context fingerprints
```

Acceptance:

```text
same inputs -> same identities
incompatible model/index -> hard failure
```

### E2 — Wrap current Topography

Do not change its search behavior.

Return standardized `HarvestProbe` objects and record retrieval provenance.

Acceptance:

```text
current behavior reproduced through new interface
```

### E3 — Build embedding/index correctness harness

Implement:

```text
embedding validation
cache
exact search
ANN comparison
index fingerprinting
```

Acceptance:

```text
ANN recall floor enforced
model/index mismatch test passes
```

### E4 — Add probe evidence ledger

Measure:

```text
unique yield
substance yield
duplicate rate
cost
```

Acceptance:

```text
every hit traceable probe -> item -> candidate
```

### E5 — Add ProbeASHA

Use only Topography + simple query-neighbor generators first.

Acceptance:

```text
replayable promotion decisions
bounded budget
crash recovery
```

### E6 — Add anti-slop R1 and CandidateASHA

Acceptance:

```text
placeholder corpus test rejected early
no pre-R3 production writes
```

### E7 — Add one new search generator

Recommended first challenger:

```text
CEM over low-dimensional probe controls
```

or, if the existing search controls are strongly continuous:

```text
CMA-ES over low-dimensional probe controls
```

Do not begin with raw-vector optimization.

### E8 — Shadow benchmark against current Topography

Acceptance:

```text
equal budget
same corpus/index
same downstream evaluator
new system shows measurable yield/cost advantage or is rejected
```

### E9 — Add portfolio allocation

Only after at least two generators have sufficient outcomes.

### E10 — Add exploratory raw-vector lane if justified

Only if controlled experiments show benefit.

---

## 19A.82 Embedding Harvest end-to-end acceptance suite

The integration is not done until all of these pass.

### EH-01 Model/index mismatch

Query vector uses another embedding spec.

Expected:

```text
hard failure before retrieval
```

### EH-02 Non-finite vector

Expected:

```text
rejected before indexing/query
```

### EH-03 ANN degradation

ANN index intentionally configured poorly.

Expected:

```text
index activation rejected by recall gate
```

### EH-04 Duplicate chunk flood

One source contains many highly similar chunks.

Expected:

```text
source aggregation/dedup prevents top-K domination
```

### EH-05 Probe duplicate

Two workers propose identical probe.

Expected:

```text
one logical probe evaluation; result reused
```

### EH-06 Worker crash

Worker dies after computation but before final status write.

Expected:

```text
lease recovery; no duplicate authoritative evidence
```

### EH-07 Delayed reward

Candidate promoted after probe epoch closes.

Expected:

```text
reward back-propagates exactly once
```

### EH-08 Search-space version change

Optimizer checkpoint from prior parameter schema is loaded.

Expected:

```text
incompatible restore rejected or explicitly migrated
```

### EH-09 Off-manifold raw vector

Synthetic vector has pathological local-neighborhood behavior.

Expected:

```text
rejected or confined to exploratory lane
```

### EH-10 Strong low-similarity candidate

Probe retrieves an item with moderate distance but strong downstream benchmark value.

Expected:

```text
candidate may promote; distance does not veto evidence
```

### EH-11 High-similarity slop

Probe retrieves very close but meaningless wrappers/placeholders.

Expected:

```text
R1 rejects; probe receives poor downstream reward
```

### EH-12 Backpressure

Retrieval produces candidates faster than R1 can process them.

Expected:

```text
probe admission throttles; queue remains bounded
```

### EH-13 Baseline reproducibility

Same corpus snapshot, embedding spec, index, seeds, policy.

Expected:

```text
same deterministic proposals/decisions except documented stochastic components with recorded seeds
```

### EH-14 Corpus drift

Live corpus changes during benchmark.

Expected:

```text
benchmark remains bound to immutable snapshot
```

### EH-15 Embedding model migration

Model/dimension changes.

Expected:

```text
new index/snapshot context; old raw geometry not mixed
```

### EH-16 False-prune audit

Known delayed-value probe is placed among early rejects.

Expected:

```text
counterfactual audit can estimate miss rate
```

### EH-17 Champion rebase

Champion changes after prior candidate evidence.

Expected:

```text
old baseline version remains recorded; current competitive decisions use current champion evidence
```

### EH-18 Governance/provenance denial

High-scoring retrieved item is prohibited.

Expected:

```text
hard admission rejection; no score override
```

### EH-19 Cancellation

Epoch/run is cancelled during active jobs.

Expected:

```text
no new admissions; running jobs safely reconcile; durable checkpoint remains valid
```

### EH-20 Budget exhaustion

Expected:

```text
bounded stop; no uncontrolled optimizer loop
```

---

## 19A.83 Performance acceptance criteria

Before enabling authority, establish concrete targets relative to current Topography.

At minimum require that the new system does **not materially regress**:

```text
search latency at equal budget
memory within configured ceiling
ANN recall floor
R1 substantive yield
candidate evaluation throughput
system stability
```

And require improvement in at least one authoritative Harvest metric such as:

```text
promoted candidates per compute cost
benchmark-positive candidates per compute cost
cost to first useful candidate
source-tree growth per real improvement
```

Do not declare success merely because more unique documents were retrieved.

---

## 19A.84 Rollback

Keep the current Topography path callable behind a policy flag until the new search has passed shadow and canary evaluation.

Example:

```yaml
harvest_search_policy: topography
# later
harvest_search_policy: adaptive_portfolio
```

A rollback must change authority routing, not delete evidence.

Historical evidence remains available for analysis.

---

## 19A.85 No-work-loss migration

During migration:

- existing candidate IDs should be mapped where possible;
- existing embeddings should be reused only if their full spec/preprocessing fingerprint is known and compatible;
- unknown legacy embeddings should be treated as untrusted cache entries and regenerated;
- legacy Topography results may be imported as historical provenance but should not be granted fabricated benchmark evidence.

Do not invent missing lineage or metric data during migration.

---

## 19A.86 Minimal viable first implementation

If implementation scope must be reduced, the **minimum functional version** is:

```text
1. versioned EmbeddingSpec
2. deterministic preprocessing + cache
3. compatible versioned index + exact-vs-ANN validation
4. current Topography wrapped as ProbeGenerator
5. HarvestProbe + RetrievalHit provenance
6. R1 anti-slop gate
7. ProbeASHA with bounded k-based fidelity
8. CandidateASHA
9. evidence ledger + idempotent jobs
10. equal-budget benchmark against current Topography
```

CEM/CMA-ES/BO can be added after this foundation works.

This ordering prevents adding sophisticated optimizers on top of an unmeasurable or incompatible retrieval layer.

---

## 19A.87 Stronger production target

The eventual production target is:

```text
                           ┌─────────────────────────────┐
                           │ Versioned corpus + vectors  │
                           └──────────────┬──────────────┘
                                          │
                ┌─────────────────────────┴─────────────────────────┐
                │                                                   │
         Current Topography                               New generators
                │                               query/CEM/CMA/BO/frontier
                └──────────────────┬────────────────────────────────┘
                                   ▼
                             Probe admission
                                   ▼
                         Probe ASHA / Hyperband
                                   ▼
                         versioned vector index
                                   ▼
                         retrieved real items
                                   ▼
                           dedup / aggregate
                                   ▼
                         R1 substance gate
                                   ▼
                         Candidate ASHA
                                   ▼
                     champion/challenger evidence
                                   ▼
                      reversible assimilation
                                   │
                                   ▼
                     delayed reward backprop
                                   │
          ┌────────────────────────┴─────────────────────────┐
          ▼                                                  ▼
   generator budgets                                  topology regions
```

This is the integration architecture to implement.

---


# 19A.88 Canonical distance/score semantics

One common implementation failure is mixing "larger is better" similarity with "smaller is better" distance.

Define exactly one adapter:

```python
@dataclass(frozen=True)
class RetrievalScore:
    raw_value: float
    canonical_similarity: float   # larger is always better
    metric: str


def canonicalize_metric(raw: float, metric: str) -> RetrievalScore:
    ...
```

All ranking, thresholds, logs, and benchmark comparisons must either use the raw metric with explicit direction or `canonical_similarity`.

Never write generic code such as:

```python
sorted(hits, key=lambda x: x.distance, reverse=True)
```

without metric-specific semantics.

Add tests for cosine, dot, and L2 ranking direction.

---

# 19A.89 ASHA peer sufficiency and cold rung rules

Asynchronous halving can behave badly when the first few completed jobs define the comparison threshold.

Every rung must define:

```text
minimum_completed_peers_before_quantile_pruning
minimum_age_or_observations_before_rejection
promotion_fraction or eta
maximum_wait/hold policy
```

Recommended initial behavior:

```text
if completed_peer_count < min_peers:
    do not reject for relative rank;
    either HOLD or use absolute hard gates only.
```

This prevents the first fast candidate from becoming the de facto champion and prevents late but stronger candidates from being judged against unstable thresholds.

---

# 19A.90 Completion-time bias in asynchronous racing

Fast candidates complete earlier and can receive more adaptation credit merely because their outcomes arrive first.

Mitigations:

- compare candidates only against peers at the same fidelity/resource;
- keep minimum exploration shares;
- use cost as an explicit objective rather than letting wall-clock arrival implicitly define fitness;
- periodically recompute generator statistics from the ledger rather than only online incremental order;
- do not permanently update CEM/CMA/portfolio allocations from a partial batch unless policy explicitly supports streaming updates.

If streaming optimizer updates are used, record observation order and optimizer checkpoint after each update.

---

# 19A.91 Fidelity-specific comparison

Never compare a probe or candidate measured at different resource levels as if the scores were equivalent.

Every metric observation must include:

```text
rung/fidelity
resource specification
sample count
corpus/index context
benchmark context
```

Relative ranking for ASHA should normally use peers at the same rung.

Cross-fidelity models may be introduced later, but they require an explicit calibrated model of fidelity effects.

---

# 19A.92 Absolute floors plus relative promotion

Pure quantile promotion can promote bad candidates when all candidates are poor.

Every rung should have:

```text
absolute_minimum_gate
relative_peer_rank_gate
```

Example:

```text
candidate must pass minimum substantive yield
AND
candidate must be in promotable peer fraction
```

If no candidate clears the absolute floor, promote none.

Similarly, a clearly strong candidate may be promoted before a full quantile pool only if it crosses an explicit high-confidence absolute promotion threshold.

---

# 19A.93 Embedding model/configuration search is a separate outer experiment

There are two different meanings of "better harvesting embeddings":

1. **better probes inside one fixed embedding space**;
2. **a better embedding model/preprocessing/chunking representation itself**.

Do not mix them in one inner search race.

To compare embedding representations, define an outer `EmbeddingPolicyCandidate`:

```python
@dataclass(frozen=True)
class EmbeddingPolicyCandidate:
    policy_id: str
    provider: str
    model: str
    revision: str | None
    preprocessing_version: str
    chunker_version: str
    normalize: bool
    metric: str
    index_config_version: str
```

Each policy candidate requires its own compatible corpus embeddings/index and is evaluated with the **same fixed Harvest benchmark seeds, retrieval budget, candidate evaluator, and downstream scoring policy**.

Primary comparison metric should be downstream Harvest yield/cost, not average vector similarity.

---

# 19A.94 Outer-loop embedding policy evaluation

Recommended experiment:

```text
EmbeddingPolicy A ─┐
EmbeddingPolicy B ─┼─ same seed families
EmbeddingPolicy C ─┘   same source snapshot
                       same search policy
                       same retrieval budget
                       same R1/R3 evaluator
                              ↓
                    compare useful yield/cost
```

Then, after choosing or retaining several representation champions, optimize probes within each compatible space.

Do not let a better probe generator hide a worse embedding representation during the representation benchmark.

---

# 19A.95 Representation champion registry

Keep a champion by relevant corpus/task domain where evidence supports specialization:

```text
embedding_policy.global
embedding_policy.code
embedding_policy.patents
embedding_policy.research_text
```

Use one global policy initially unless domain-specific representation actually produces enough measured gain to justify multiple indexes and routing complexity.

---

# 19A.96 Avoid nested confounding

Do not change all of these simultaneously in one experiment:

```text
embedding model
chunker
preprocessing
ANN parameters
probe generator
ASHA policy
R1 evaluator
benchmark
```

Use a staged experiment matrix.

Examples:

```text
Experiment A: fixed representation/index; Topography vs CEM-control probes
Experiment B: fixed Topography/probe policy; embedding policy A vs B
Experiment C: fixed representation/probes; ASHA policy A vs B
```

Only after individual effects are understood should combined policies be tested.

---

# 19A.97 Fake/synthetic embedding providers are not production evidence

A fake, hash-derived, random, path-derived, or deterministic placeholder embedding provider may be used only for unit tests of plumbing.

It must never be used to establish that a Harvest search algorithm improves semantic discovery.

Evidence records must mark provider class:

```text
TEST_FAKE
REAL_LOCAL
REAL_REMOTE
```

Promotion to production authority requires benchmarks using the real intended embedding provider or an explicitly approved production-equivalent representation.

This prevents infrastructure tests from being mistaken for semantic-search evidence.

---

# 19A.98 Index configuration is also versioned experimental state

ANN parameters can materially change retrieval quality.

Record configuration such as:

```text
index algorithm
construction parameters
query-time parameters
efSearch / nprobe equivalents where applicable
quantization/compression settings
threading mode
```

Index configuration changes require exact-vs-ANN recall validation.

Do not attribute a retrieval regression to the probe generator when the underlying ANN configuration changed.

---

# 19A.99 Stale-job invalidation

A queued job may become stale after:

```text
corpus snapshot retirement
embedding policy change
index replacement
benchmark version change
candidate/champion supersession
governance policy change
```

Before a worker begins expensive work, revalidate its context fingerprint.

If stale:

```text
mark STALE_CONTEXT
consume no further expensive budget
retain provenance
optionally enqueue a newly contextualized job
```

Never silently run a stale job and merge its evidence into the current context.

---

# 19A.100 Storage lifecycle and garbage collection

Vectors, candidate workspaces, optimizer checkpoints, and evidence have different retention needs.

Recommended classes:

```text
ACTIVE_INDEX_DATA
REBUILDABLE_EMBEDDING_CACHE
IMMUTABLE_EVIDENCE
DISPOSABLE_CANDIDATE_WORKSPACE
PROMOTED_ARTIFACT
RETIRED_CHECKPOINT
```

Garbage collection rules must never delete evidence required to explain a current promoted candidate.

Disposable failed candidate source may be removed after its hash/provenance/evidence summary is durably retained, subject to policy.

Index data may be rebuilt from source + EmbeddingSpec and can therefore have a different retention policy from evidence.

---

# 19A.101 Disk/memory capacity guardrails

Before building a new full embedding index, estimate:

```text
item_count * dimension * bytes_per_component
+ index overhead
+ metadata
+ build scratch space
```

Reject or defer the build if configured disk/memory headroom would be violated.

Do not let outer-loop embedding-policy search create many full indexes without a storage budget.

Representation challengers should have an explicit maximum concurrent-index count.

---

# 19A.102 Numerical precision policy

Store/index precision must be explicit:

```text
float32
float16
quantized
other
```

If precision changes, validate retrieval recall against the reference representation.

Do not assume quantization is lossless for ranking.

The `EmbeddingSpec` or index fingerprint must capture any representation detail that changes search results.

---

# 19A.103 Empty/degenerate content handling

Before embedding:

- reject empty canonical content;
- reject content below a configured semantic-information floor only if benchmarked/justified;
- avoid embedding pure boilerplate repeatedly;
- detect pathological repeated-character/binary-decoding artifacts;
- preserve a reason code for exclusion.

Do not convert invalid content into zero vectors.

Zero-vector substitution creates false neighborhoods and can corrupt Topography/search statistics.

---

# 19A.104 Corpus eligibility manifest

A benchmark corpus should have a manifest describing:

```text
eligible source count
excluded source count by reason
embedded count
failed embedding count
indexed count
snapshot hash
```

The benchmark harness must verify the manifest before comparing search policies.

If corpus coverage changes, the run is a different context.

---

# 19A.105 Reranker separation

If Agent_X adds a lexical, cross-encoder, LLM, or rule-based reranker after vector retrieval, treat it as a separate stage:

```text
probe -> vector retrieval -> reranker -> candidate admission
```

Record:

```text
pre-rerank rank/score
reranker version
post-rerank rank/score
reranker cost
```

Benchmark vector search with and without reranking so gains are attributed correctly.

A reranker may increase quality while making the underlying embedding search appear better than it is.

---

# 19A.106 Hybrid retrieval

A hybrid lexical+vector path may be added as another retrieval policy candidate.

Do not hardwire it into every probe initially.

Compare:

```text
vector only
lexical only
hybrid
```

at equal or normalized cost and identical downstream candidate evaluation.

Hybrid retrieval is especially useful as a robustness baseline when embedding neighborhoods miss exact technical terms, symbols, identifiers, or rare names.

---

# 19A.107 Query/result contamination by already-known winners

If benchmark seeds can trivially retrieve already-promoted known winners, policy comparisons may reward memorization rather than discovery.

Benchmark reporting should separate:

```text
rediscovery yield
new discovery yield
```

For discovery benchmarks, optionally exclude already-known promoted items from the searchable candidate pool or score their rediscovery separately.

---

# 19A.108 Search objective after easy wins are exhausted

As Harvest matures, `promoted_candidates_per_cost` may naturally fall because obvious improvements have already been found.

Track marginal discovery against the current corpus/champion and avoid comparing mature epochs directly to early easy-win epochs without context.

Use fixed historical benchmark snapshots for longitudinal algorithm comparison and live snapshots for operational usefulness.

---

# 19A.109 Tie-breaking

All deterministic schedulers need deterministic tie-breakers.

Recommended ordering after equal score:

```text
1. lower cost
2. higher uncertainty/coverage priority if exploration policy says so
3. stable candidate/probe ID lexical order
```

If random tie-breaking is intentional, record the seed.

Do not rely on database row order or Python set iteration order.

---

# 19A.110 Cancellation semantics

Cancellation must define what happens to each job state.

Recommended:

```text
READY -> CANCELLED
RUNNING -> CANCEL_REQUESTED, then cooperative stop if safe
COMPLETED -> unchanged
PROMOTED/REJECTED evidence -> unchanged
```

No new child jobs may be admitted after cancellation.

Partial observations are either marked `PARTIAL_NOT_COMPARABLE` or committed only if the evaluator contract explicitly supports partial-fidelity evidence.

---

# 19A.111 Timeouts

Timeout is not automatically equivalent to low quality.

Record timeout separately from metric failure.

Policy may decide:

```text
hard reject if runtime ceiling is itself a guardrail
retry if infrastructure timeout
compare as cost regression if algorithm exceeded valid runtime budget
```

Distinguish infrastructure failure from candidate behavior.

---

# 19A.112 Retry policy

Classify errors:

```text
RETRYABLE_INFRASTRUCTURE
RETRYABLE_PROVIDER_RATE_LIMIT
NONRETRYABLE_INVALID_INPUT
NONRETRYABLE_POLICY
CANDIDATE_BEHAVIOR_FAILURE
```

Retries should use bounded exponential backoff where appropriate and preserve attempt history.

A candidate must not gain multiple independent metric samples merely because an infrastructure job retried unless the evaluator explicitly commits each valid observation.

---

# 19A.113 Exact replay contract

A search run is replayable only if the following are available:

```text
corpus snapshot manifest
source content or resolvable immutable references
EmbeddingSpec
preprocessing/chunker code versions
index config
probe generator versions
optimizer checkpoints/seeds
scheduler policy/version
R1 evaluator version
benchmark snapshot
all evidence events
```

If external embedding providers are nondeterministic across time, record that limitation and distinguish **logical replay** from bit-identical vector replay.

---

# 19A.114 Implementation assertion list

Add runtime assertions for the conditions that must never be silently violated:

```text
embedding dimension compatibility
embedding spec compatibility
index snapshot compatibility
finite vectors
job context freshness
unique job key
rung/resource compatibility
hard-gate precedence
no production write before required rung
no current decision from incompatible historical evidence
```

Failing these assertions should stop the affected job safely and produce structured evidence, not continue with guessed defaults.

---

# 19A.115 Anti-placeholder acceptance rule for embedding search code itself

The new Harvest implementation must not merely create adapters named `asha`, `cem`, `cmaes`, or `topography` that return existing scores unchanged.

Each algorithmic module must have tests demonstrating its defining behavior.

Examples:

```text
ASHA: lower-fidelity losers are pruned and survivors receive larger resource.
CEM: elite outcomes change the sampling distribution.
CMA-ES: observations update mean/covariance/step state.
BO: observations alter acquisition-driven proposal choice.
Evidence-weighted Topography: region allocation changes after measured outcomes.
```

If an adapter delegates to existing behavior without implementing the claimed algorithm, it fails R1 substance for the Harvest system itself.

---

# 20. Evidence feedback to generators

Each generator should maintain empirical statistics:

```python
@dataclass
class GeneratorStats:
    proposed: int
    r0_pass: int
    r1_substantive: int
    r2_pass: int
    r3_positive: int
    r4_positive: int
    promoted: int

    mean_cost_to_decision: float
    mean_improvement: float
    promotion_rate: float
```

The scheduler may reduce intake from generators that repeatedly create slop.

This creates evolutionary pressure on Harvest itself.

Example:

```text
Generator A:
1000 candidates
800 structurally valid
120 substantive
14 benchmark-positive
1 promoted

Generator B:
100 candidates
90 structurally valid
65 substantive
28 benchmark-positive
9 promoted
```

Generator B should receive more future search budget.

---

# 21. Slop suppression

This integration should explicitly remove the current failure mode where Harvest generates many files that technically satisfy an interface but do not add real capability.

A candidate should be rejected at R1 when it is primarily:

- a placeholder;
- a bucket;
- a dispatch wrapper;
- renamed existing behavior;
- generic scoring glue;
- a constant-return function;
- unconnected helper code;
- shallow boilerplate;
- an implementation whose acceptance criterion cannot actually be measured;
- an implementation with no demonstrated delta from baseline.

Recommended requirement:

```text
NO HARVEST CANDIDATE MAY ENTER THE PERMANENT SOURCE TREE
BEFORE R3.
```

Prefer isolated candidate workspaces:

```text
.agentx/
  harvest/
    candidates/
      <candidate_id>/
        source/
        contract.yaml
        evidence/
        artifacts/
```

Only promoted candidates enter production source locations.

This single change will greatly reduce source-tree clutter.

---

# 22. Evidence ledger

Every evaluation event should be append-only.

Example:

```json
{
  "candidate_id": "cand_...",
  "rung": "R3",
  "evaluator": "retrieval_ndcg",
  "baseline_version": "...",
  "workload": "...",
  "seed": 1234,
  "resource": {
    "wall_seconds": 18.2
  },
  "metrics": {
    "ndcg_at_10": 0.413
  },
  "baseline_metrics": {
    "ndcg_at_10": 0.372
  },
  "delta": {
    "ndcg_at_10": 0.041
  },
  "decision": "REPEAT",
  "timestamp": "..."
}
```

Promotion must be replayable from evidence.

---

# 23. Scheduler state

Recommended state machine:

```text
PROPOSED
   ↓
NORMALIZED
   ↓
R0_READY → R0_RUNNING → R0_DONE
   ↓
R1_READY → R1_RUNNING → R1_DONE
   ↓
R2_READY → R2_RUNNING → R2_DONE
   ↓
...
   ↓
PROMOTED / RETAINED / REJECTED
```

A state transition must have:

```text
candidate_id
previous_state
new_state
reason
evidence_refs
scheduler_policy_version
timestamp
```

---

# 24. Promotion policy pseudocode

```python
def decide(candidate, rung, peer_pool, policy):
    evidence = load_evidence(candidate, rung)

    # 1. Mandatory gates
    violations = hard_gate_violations(evidence, policy)
    if violations:
        return Reject(reason=violations)

    # 2. Estimate candidate-vs-baseline improvement
    estimates = build_metric_estimates(evidence)

    # 3. Strong negative evidence
    if clearly_inferior(estimates, policy):
        return Reject(reason="clear_loss")

    # 4. Candidate is still uncertain
    if high_decision_uncertainty(estimates, policy):
        if candidate.remaining_budget > 0:
            return Repeat(resource=next_repeat_budget(candidate, rung))
        return Retain(reason="uncertain_budget_exhausted")

    # 5. Multi-objective comparison
    frontier = pareto_front(peer_pool, rung)

    if candidate in frontier:
        if promotion_capacity_available(rung):
            return Promote(next_rung(rung))

    # 6. Protected exploration
    if qualifies_for_exploration(candidate, estimates, policy):
        if exploration_budget_available():
            return Promote(next_rung(rung), lane="exploration")

    return Reject(reason="dominated")
```

---

# 25. Scheduling pseudocode

```python
while True:
    candidates = ready_candidates()

    for c in candidates:
        c.utility = (
            expected_information_value(c)
            * expected_improvement(c)
            * strategic_value(c)
            / max(expected_cost(c), EPS)
        )

    c = select_highest_priority(candidates)

    budget = choose_budget(c)

    dispatch_evaluation(
        candidate=c,
        rung=c.current_rung,
        budget=budget,
    )
```

The scheduler should optimize **evidence acquisition**, not raw candidate generation throughput.

---

# 26. Suggested initial bracket configuration

A practical starting configuration:

```yaml
brackets:

  aggressive:
    intake_share: 0.60
    promotion_fraction:
      R0_R1: 0.70
      R1_R2: 0.35
      R2_R3: 0.35
      R3_R4: 0.25
      R4_R5: 0.20

  balanced:
    intake_share: 0.30
    promotion_fraction:
      R0_R1: 0.80
      R1_R2: 0.50
      R2_R3: 0.45
      R3_R4: 0.35
      R4_R5: 0.30

  exploratory:
    intake_share: 0.10
    promotion_fraction:
      R0_R1: 0.90
      R1_R2: 0.70
      R2_R3: 0.60
      R3_R4: 0.50
      R4_R5: 0.40
```

These are **initial engineering defaults**, not research-derived universal constants.

They should later be learned from Agent_X's own evaluation history.

---

# 27. Dynamic promotion thresholds

Do not permanently hardcode fixed fractions.

Once enough historical evidence exists, adapt based on:

```text
candidate arrival rate
available compute
rung queue depth
historical promotion yield
estimated false-prune rate
cost per promoted candidate
domain
generator
capability
```

Example objective:

```text
maximize:
    demonstrated system improvement

subject to:
    evaluation compute budget
    maximum false-promotion rate
    maximum regression rate
    source-tree growth constraint
```

---

# 28. False-prune auditing

Because one of the main risks is prematurely killing good candidates, Agent_X should periodically audit rejected candidates.

Procedure:

1. sample a small number of R1/R2/R3 rejects;
2. give them one deeper evaluation;
3. measure how often a rejected candidate would have become competitive;
4. estimate false-prune rate;
5. adjust promotion thresholds.

This makes the pruning policy empirically self-correcting.

---

# 29. Kill criteria

Immediate rejection should occur for:

```text
invalid code
security violation
governance violation
unbounded execution
non-determinism where forbidden
missing contract
no substantive algorithm
duplicate behavior
required test failure
catastrophic performance regression
resource ceiling violation
data corruption
irreversible side effect
benchmark cheating
evidence fabrication
```

Normal rejection may occur for:

```text
dominated candidate
insufficient effect
poor cost/benefit
high maintenance burden
high uncertainty with low upside
failure to beat current champion
```

---

# 30. Stop criteria for an experiment

Stop testing a candidate when any of the following becomes true:

```text
A. Probability/credible confidence of meaningful win is sufficiently high.
B. Probability of meaningful win is sufficiently low.
C. Candidate violates a guardrail.
D. Remaining possible upside cannot justify remaining evaluation cost.
E. Candidate is Pareto-dominated with high confidence.
F. Maximum candidate budget is exhausted.
G. A newer challenger subsumes the candidate.
```

---

# 31. Assimilation rules

A candidate may enter production only when:

```text
R0 passed
R1 substantive
R2 mandatory tests passed
R3 measurable positive evidence
R4 integration evidence passed
required R5 comparison passed
required R6 canary/shadow passed
rollback available
evidence ledger complete
provenance complete
champion comparison complete
```

Not every capability needs R6.

The required final rung should depend on risk class.

Example:

| Risk | Final required rung |
|---|---|
| isolated helper | R3 |
| internal algorithm | R4 |
| orchestrator | R5 |
| governance/security/runtime authority | R6 |

---

# 32. Source-tree policy

Use three layers.

```text
harvest_candidates/
    disposable candidate workspaces

harvest_promoted/
    proven but not yet authoritative modules

Agent_X production tree/
    current authoritative capability
```

Candidates that fail are archived as evidence metadata, not retained as active code.

The source tree should represent **proven capability**, not Harvest history.

---

# 33. Specialist preservation

Do not require every candidate to be globally best.

A candidate can be retained if it is best for a detectable context.

Example:

```text
Candidate A:
best overall retrieval

Candidate B:
best for very short queries

Candidate C:
best for patent-language queries
```

Then create a router only if routing gains exceed routing cost.

Specialization must be evidence-backed.

---

# 34. Integration with existing Agent_X governance

The evaluator must sit below governance authority.

Recommended authority chain:

```text
Governance
   ↓
Experiment Contract
   ↓
Harvest Scheduler
   ↓
Evaluator
   ↓
Evidence Ledger
   ↓
Promotion Gate
   ↓
Assimilation / Rollback
```

The scheduler cannot override governance.

The generator cannot override the scheduler.

A candidate cannot override its own evaluator.

---

# 35. Repository-grounded Agent_X integration: reuse canonical subsystems

The implementation must integrate into the existing Agent_X architecture. **Do not create a new `tools/agentx_harvest/` semantic/vector stack or a second vector database.**

Current Agent_X implementation documents establish that the existing semantic subsystem already lives under:

```text
tools/agentx_evolve/semantic/
```

and already contains or owns concepts including:

```text
semantic models
semantic-space/vector math
strict embedding provider wrapper
SQLite semantic index
deterministic chunking
semantic service facade
semantic evidence log
calibration profiles
semantic deduplication
relation-learning scaffolding
semantic predicates
CLI
```

Relevant existing seams include, subject to current-HEAD verification:

```text
tools/agentx_evolve/semantic/service.py
tools/agentx_evolve/semantic/semantic_index.py
tools/agentx_evolve/semantic/semantic_models.py
tools/agentx_evolve/semantic/strict_provider.py
tools/agentx_evolve/semantic/embedding_route.py

tools/agentx_evolve/models/embedding_provider.py

tools/agentx_evolve/semantic_execution/service.py
tools/agentx_evolve/semantic_execution/provider_seam.py

tools/agentx_evolve/context/repository_text_loader.py
tools/agentx_evolve/context/semantic_context_adapter.py
tools/agentx_evolve/context/task_pack_builder.py
```

The existing governed embedding construction route is the canonical seam:

```python
agentx_evolve.semantic.embedding_route.build_governed_embedding_service(...)
```

Use the current equivalent if the exact symbol moved.

It should remain responsible for provider/model/revision/dimension checks, semantic-space identity, redaction, budget governance, DataScope/policy handling, and production rejection of fake/null/mock embeddings.

Do not duplicate these checks in the Harvest scheduler.

## 35.1 Existing Harvest/assimilation authority must also be reused

Repository-grounded Harvest work already uses or references existing machinery for:

```text
authoring
candidate state
Gate B
canonical-owner resolution
promotion
provenance
lifecycle
algorithmic substance
components/capability registry
```

Relevant current seams include, subject to current-HEAD verification:

```text
tools/agentx_evolve/collective_core/write_code_e2e.py
tools/agentx_evolve/algorithmic_substance_gate/
tools/agentx_evolve/harvested_algorithms/
tools/agentx_evolve/collective_core/components_db.py
tools/agentx_evolve/collective_core/capabilities.py
tools/agentx_evolve/collective_core/service.py
tools/agentx_evolve/collective_core/adoption.py
tools/agentx_evolve/collective_core/supersession.py
tools/agentx_evolve/collective_core/assimilation_queue.py
tools/agentx_evolve/promotion/
tools/agentx_evolve/scheduler/
tools/agentx_evolve/orchestrator/
```

Do not create a second candidate registry, second promotion engine, second implementation-status database, second semantic index, or second capability identity system merely for this integration.

## 35.2 Minimal-addition rule

Before adding any new file:

```text
1. inspect current HEAD;
2. identify the canonical owner of the responsibility;
3. extend that owner if the responsibility is already conceptually present;
4. add a new module only if no existing coherent owner exists;
5. keep the new module as small and typed as possible.
```

A likely mapping is:

```text
embedding/provider/index mechanics
    -> existing semantic/* and models/embedding_provider.py

probe generation/topography search
    -> current Harvest/frontier/topography owner, wherever it exists on HEAD

multi-fidelity scheduling
    -> existing scheduler/ or orchestration owner

R1 algorithmic substance
    -> existing algorithmic_substance_gate

candidate authoring
    -> existing write_code_e2e / authoring path

production-need decision / Gate B
    -> existing Gate B + candidate/store-backed evidence

promotion
    -> existing canonical promotion path

capability lifecycle
    -> existing components/capability registry and lifecycle machinery
```

The exact file names must follow current HEAD rather than this document if paths have moved.

## 35.3 No second semantic subsystem

This requirement is absolute unless current HEAD proves the old subsystem was deliberately replaced:

```text
Harvest adaptive search
        ↓
existing SemanticService / semantic index
        ↓
existing governed embedding provider route
```

Not:

```text
Harvest adaptive search
        ↓
new independent embedding provider
new independent vector database
new independent semantic cache
new independent semantic identity
```

The adaptive search layer should consume the existing semantic APIs and add search-policy/evidence state only where required.

## 35.4 Semantic authority remains evidence-only

Embedding/semantic output may influence:

```text
ranking
retrieval
search budget
candidate priority
novelty/coverage estimation
review evidence
```

It may not directly grant:

```text
filesystem mutation
process/network authority
promotion authority
release authority
implementation-needed authority
```

Those remain governed by the existing Agent_X authority path.

## 35.5 Production-necessity gate must precede expensive authoring

The anti-slop rule is stronger than algorithmic-substance detection.

A candidate can be:

```text
real algorithm
well tested
novel
relevant to the source material
```

and still be production slop if Agent_X has no independent need for it.

Therefore the pipeline must distinguish:

```text
R1 substance: "Is this a real mechanism?"

from

Production necessity / Gate B: "Does Agent_X actually need this in production?"
```

Before invoking expensive production code authoring, resolve independent need where feasible.

Evidence should include:

```text
base repository revision
existing runtime owner
existing behavior/baseline or independently established gap
canonical owner search
real integration path
consumer or accepted requirement
measurable acceptance criterion
intended promotion action
```

A harvested record, semantic similarity score, Topography score, generated test, export, route entry, or caller created in the same candidate change is not independent proof of production need.

## 35.6 Enforce production necessity again at canonical promotion

Defense in depth is required:

```text
Harvest discovery
    ↓
R1 substance
    ↓
production-need evidence
    ↓
optional authoring
    ↓
candidate evaluation
    ↓
canonical promotion revalidates production need
```

Do not add caller-controlled bypasses such as:

```text
production_needed=True
force=True
skip_need_check=True
allow_orphan=True
```

as normal autonomous Harvest authority.

If the evidence is missing, stale, malformed, or ambiguous, fail closed to a non-production outcome.

## 35.7 `IMPLEMENTED` is derived state, not caller metadata

For Harvest-origin items, `IMPLEMENTED` must mean that current canonical production evidence demonstrates an active implementation.

It must not be established merely because:

```text
a caller passed status="IMPLEMENTED"
an old promotion once existed
a stale path exists in metadata
a test passed historically
a routing table names the item
```

Current lifecycle state should be derived from canonical promotion/registry evidence.

## 35.8 Suggested code-placement strategy after current-HEAD inspection

Prefer minimal additions such as:

```text
existing semantic package:
    extend only for missing public APIs/metadata required by Harvest probes

existing scheduler package:
    add or extend probe-racing + candidate-racing scheduler policy

existing Harvest/topography owner:
    add ProbeGenerator adapter interface and Topography adapter

existing evidence/store:
    add typed probe outcome/provenance records if current schema cannot represent them

existing tests:
    add focused embedding-search, ASHA, production-need, and end-to-end tests
```

Do not mechanically create the earlier illustrative tree if equivalent canonical owners already exist.

---

# 36. Minimal interfaces

```python
class CandidateGenerator(Protocol):
    def propose(self, context, budget) -> Iterable[HarvestCandidate]:
        ...


class Evaluator(Protocol):
    def evaluate(
        self,
        candidate: HarvestCandidate,
        rung: str,
        budget: EvaluationBudget,
    ) -> EvaluationResult:
        ...


class PromotionPolicy(Protocol):
    def decide(
        self,
        candidate: HarvestCandidate,
        rung: str,
        evidence: EvidenceSet,
        peers: Sequence[HarvestCandidate],
    ) -> PromotionDecision:
        ...


class EvidenceStore(Protocol):
    def append(self, event: EvidenceEvent) -> None:
        ...

    def candidate_evidence(self, candidate_id: str) -> EvidenceSet:
        ...
```

---

# 37. Do not combine generator fitness and evidence fitness

Maintain two separate values:

```text
proposal_score
evidence_score
```

`proposal_score`:

- used before meaningful testing;
- predicts whether evaluation is worthwhile.

`evidence_score`:

- derived from actual measurements;
- becomes authoritative after evaluation.

Once enough evidence exists, `proposal_score` should have little or no effect on promotion.

---

# 38. Harvest UI simplification

The user should not have to manually manage individual candidates.

Default UI should show only:

```text
Harvest running
Candidates proposed
Candidates rejected as slop
Candidates under test
Candidates promoted
Compute spent
Measured improvement
Current champion changes
```

Detailed rung/evidence information belongs behind drill-down.

Do not expose dozens of scheduler controls in the default interface.

Use safe policy presets such as:

```text
CONSERVATIVE
BALANCED
EXPLORATORY
```

Internally these map to bracket, budget, and confidence policies.

---

# 39. Migration from current Successive Halving

## Phase 1 — Preserve existing SH, add evidence model

Implement:

- candidate IDs;
- experiment contracts;
- append-only evidence;
- baseline deltas;
- explicit rung state.

Do not change pruning yet.

Goal: make current decisions observable and replayable.

---

## Phase 2 — Add R1 substance gate

Before expensive evaluation, detect:

- placeholders;
- wrappers;
- duplicate implementations;
- untestable hypotheses;
- no-op candidates.

This likely gives the largest immediate reduction in Harvest clutter.

---

## Phase 3 — Convert synchronous SH to ASHA

Keep the same rungs and roughly the same promotion fractions.

Change only execution behavior:

```text
synchronous batch halving
        ↓
asynchronous candidate completion + promotion
```

This reduces blocking and handles heterogeneous runtime.

---

## Phase 4 — Add uncertainty and repeat testing

Add:

- multiple seeds;
- confidence bounds;
- threshold-aware repeats;
- high-variance detection.

Replace rigid promotion at boundaries.

---

## Phase 5 — Add Hyperband-style brackets

Create:

- aggressive;
- balanced;
- exploratory.

Track which bracket produces the best promotion yield per unit cost.

---

## Phase 6 — Add Pareto promotion

Replace single quality score with:

- hard guardrails;
- multi-objective frontier;
- scheduler utility only for ordering.

---

## Phase 7 — Add generator feedback

Feed evaluation results back to:

- Topography;
- CEM;
- CMA-ES;
- BO;
- mutation operators;
- LLM prompt templates.

Allocate more proposal budget to generators producing real improvements.

---

## Phase 8 — Champion/challenger assimilation

Require every permanent code addition to:

```text
beat
complement
or demonstrably specialize relative to
```

the current capability champion.

At this point Harvest becomes an evidence-driven evolution system rather than a code-generation inventory.

---

# 40. Acceptance tests for the integration

The integration is not complete until the following behaviors are demonstrated.

## Test A — obvious slop

Input:

```text
100 structurally valid placeholder/wrapper candidates
```

Expected:

```text
vast majority rejected at R1
none added to production tree
```

---

## Test B — delayed-value candidate

Construct candidate:

```text
weak R1/R2 proxy
strong R4 integration result
```

Expected:

```text
candidate has a non-zero path through balanced/exploratory bracket
plain aggressive pruning does not eliminate every copy
```

---

## Test C — obvious failure

Candidate violates a hard invariant.

Expected:

```text
immediate rejection
no Pareto score or exploration rule can revive it
```

---

## Test D — noisy candidate

Candidate has mean improvement near threshold with high variance.

Expected:

```text
adaptive repeat allocation
not immediate random promote/reject
```

---

## Test E — expensive candidate

Candidate is good but evaluation is 20x more expensive.

Expected:

```text
scheduler incorporates expected evidence gain / cost
candidate may still progress if expected value justifies cost
```

---

## Test F — specialist

Candidate loses overall but wins strongly on one stable workload class.

Expected:

```text
candidate may become PROMOTED_COMPLEMENT
not incorrectly discarded solely for lower global mean
```

---

## Test G — generator quality adaptation

One generator produces many slop candidates.

Another produces fewer but much stronger candidates.

Expected:

```text
future proposal budget shifts toward the productive generator
```

---

## Test H — reproducibility

Replay the evidence ledger using the same scheduler policy version.

Expected:

```text
same promotion/rejection decisions
```

except where the policy explicitly contains randomized exploration, in which case the random seed must be recorded.

---

# 41. Metrics for whether this change succeeds

Track system-level Harvest metrics:

```text
candidate_to_promotion_rate
cost_per_promoted_candidate
cost_per_measured_improvement
r1_slop_rejection_rate
r3_false_positive_rate
r4_integration_failure_rate
false_prune_audit_rate
promoted_candidate_regression_rate
median_time_to_reject
median_time_to_promote
source_tree_growth_per_real_improvement
generator_yield
champion_replacement_rate
rollback_rate
```

A particularly important metric is:

```text
source_tree_growth_per_real_improvement
```

The goal is for this to fall substantially.

Harvest should generate **more evidence and fewer permanent files**.

---

# 42. When plain Successive Halving should still be used

Do not eliminate Successive Halving completely.

Plain SH remains appropriate when:

- evaluation costs are homogeneous;
- every candidate can be given identical resource increments;
- early score is strongly predictive of final score;
- the metric is stable and low-noise;
- there is one dominant objective;
- the candidate population is fixed;
- simplicity and deterministic auditability matter more than utilization;
- candidate count is modest;
- scheduling overhead would exceed evaluation savings.

Therefore retain SH as a scheduler policy:

```text
policy = "successive_halving"
```

for simple evaluation domains.

The default general-purpose Harvest policy should be the adaptive architecture described here.

---

# 43. What is well-supported versus Agent_X-specific

## Well-supported foundations

The following ideas are established and broadly supported by optimization and systems practice:

- multi-fidelity evaluation;
- Successive Halving;
- Hyperband;
- asynchronous Successive Halving;
- Bayesian optimization;
- racing methods;
- confidence-aware repeated evaluation;
- Pareto multi-objective optimization;
- champion/challenger evaluation;
- canary/shadow deployment;
- immutable experiment/evidence recording;
- cost-aware scheduling.

## Agent_X-specific synthesis

The following is the proposed Agent_X architecture and should be treated as an engineering hypothesis to validate:

- combining ASHA/Hyperband brackets with a Pareto promotion gate;
- reserving explicit deep-evaluation budget for high-novelty/high-uncertainty Harvest candidates;
- using R1 algorithmic-substance detection as an anti-slop gate;
- feeding promotion yield back into Topography and generator budgets;
- using false-prune audits to tune Harvest pruning policy;
- forbidding permanent source-tree entry before measurable benchmark evidence;
- using source-tree growth per real improvement as a core Harvest health metric.

These adaptations should themselves be introduced under measurable Experiment Contracts.

---

# 44. Final Agent_X embedding-Harvest execution loop

The authoritative end-to-end loop is:

```text
0. Capture current Agent_X HEAD/config/governance context.

1. Resolve the existing canonical semantic subsystem.
   - real governed embedding provider
   - canonical SemanticSpace/EmbeddingSpec identity
   - deterministic preprocessing/chunking
   - existing semantic index
   - immutable/fingerprinted corpus context

2. Generate HarvestProbe proposals.
   Sources may include:
   - current Topography
   - query mutation
   - semantic neighbors
   - centroid/mixture probes
   - frontier/residual search
   - CEM/CMA-ES/BO over low-dimensional controls
   - bounded exploratory raw-vector lane

3. Validate/admit probes.
   - dimension/spec/index compatibility
   - finite/norm checks
   - duplicate probe suppression
   - governance/budget checks
   - context freshness

4. Run ProbeASHA/Hyperband.
   - increase retrieval/resource fidelity only for justified probes
   - compare same-fidelity peers
   - absolute floors + relative ranks
   - uncertainty repeats
   - exploration reserve
   - cost-aware scheduling
   - false-prune audit pool

5. Retrieve real corpus items through the existing semantic index.
   - never decode synthetic vectors
   - retain full probe->hit provenance
   - aggregate chunks to sources
   - exact/semantic duplicate control

6. Run cheap item/candidate admission.
   - allowed provenance/source
   - relevance floor where configured
   - existing capability overlap
   - R1 algorithmic substance
   - no placeholder/wrapper/no-op masquerading as capability

7. Establish independent Agent_X production need BEFORE expensive authoring.
   - current repository owner/baseline
   - independently established gap or runtime demand
   - canonical owner search
   - real integration path
   - measurable acceptance criterion
   - no self-justifying export/caller/test/status authority

8. Route non-production discoveries correctly.
   - knowledge/evidence retained
   - duplicate
   - already exists
   - deferred
   - rejected
   Do not generate production code merely because an idea is codable.

9. For justified implementation candidates, author/stage in isolation.
   - existing governed authoring path
   - stable candidate identity
   - Experiment Contract
   - no permanent source-tree write yet

10. Run CandidateASHA.
    C0 structural
    C1 substance/contract consistency
    C2 unit/property/adversarial correctness
    C3 isolated benchmark
    C4 real integration evaluation
    C5 champion/challenger comparison
    C6 shadow/canary when risk requires

11. Apply hard guardrails first, Pareto/evidence ranking second.
    - correctness/governance/security cannot be averaged away
    - compare delta against current baseline/champion
    - repeat near uncertainty thresholds

12. Canonical promotion revalidates production need.
    - evidence still current
    - canonical owner still valid
    - current champion comparison still valid
    - current repository context compatible
    - no caller-controlled IMPLEMENTED/force bypass

13. Promote only via existing Agent_X promotion/lifecycle machinery.
    - exact qualified artifact
    - governed mutation path
    - rollback available
    - append-only evidence/provenance
    - current canonical state becomes authoritative only after success

14. Back-propagate delayed outcome.
    candidate outcome
        -> retrieval hit provenance
        -> probe reward
        -> generator statistics
        -> Topography region statistics
        -> CEM/CMA/BO/portfolio updates

15. Reallocate future search budget toward demonstrated yield.
    Optimize:
        downstream useful discovery / total cost
    not:
        number of vectors
        raw similarity
        number of generated files

16. Periodically audit:
    - rejected probes for false pruning
    - rejected candidates for false pruning
    - ANN recall
    - embedding/index compatibility
    - stale evidence
    - generator collapse
    - duplicate/source-tree growth
    - champion regressions

17. Operate continuous Harvest as bounded, checkpointed epochs.
    No uncontrolled infinite internal loops.
```

---

# 45. Concrete implementation sequence on current Agent_X HEAD

Execute in this order. Do not skip directly to CEM/CMA-ES/BO.

## Step 1 — Repository reality map

Inspect current equivalents of:

```text
tools/agentx_evolve/semantic/
tools/agentx_evolve/models/embedding_provider.py
tools/agentx_evolve/semantic_execution/
tools/agentx_evolve/algorithmic_substance_gate/
tools/agentx_evolve/collective_core/write_code_e2e.py
tools/agentx_evolve/collective_core/components_db.py
tools/agentx_evolve/scheduler/
tools/agentx_evolve/orchestrator/
tools/agentx_evolve/promotion/
current Harvest/Topography implementation
current Gate A/Gate B implementation
current candidate/provenance/lifecycle store
```

Create a small mapping in implementation notes:

```text
required responsibility -> current canonical owner -> change needed? yes/no
```

Fail this step if an implementation plan proposes a duplicate owner without first proving the canonical owner is insufficient.

## Step 2 — Semantic compatibility contract

Verify/fix only what is missing for Harvest:

```text
real provider route
provider/model/revision/dimension identity
space identity
batch ordering contract
preprocessing/chunking identity
index fingerprint
search API
exact-vs-index correctness path
coverage manifest
```

Do not create another semantic service/index.

## Step 3 — Add probe provenance types to the current appropriate store

Required logical records:

```text
HarvestProbe
ProbeJob
RetrievalHit
ProbeOutcome
ProbeCandidateLink
SearchContextFingerprint
```

Prefer extending an existing durable store/event model over adding a new database.

## Step 4 — Wrap current Topography unchanged

Make it implement the standard probe-generator interface.

Acceptance:

```text
same seeds/context -> behavior equivalent to current Topography
all results now have probe provenance
no new search algorithm yet
```

This creates the baseline.

## Step 5 — Build the embedding-search benchmark harness

Before changing search behavior, establish:

```text
fixed corpus snapshot
fixed embedding/index context
fixed seed families
fixed downstream R1/R3 evaluator
fixed budgets
baseline Topography results
```

If the baseline cannot be reproduced, stop and fix measurement before adding optimization.

## Step 6 — Implement ProbeASHA as a scheduler policy

Must demonstrate actual behavior, not an adapter name.

Required:

```text
same-fidelity peer comparison
minimum peer count
absolute floors
promotion fraction/eta
uncertainty repeat lane
exploration lane
bounded budgets
idempotent jobs
leases/crash recovery
context freshness
```

First run it using current Topography + one trivial baseline generator.

## Step 7 — Connect retrieval output to existing R1 substance/dedup gates

Ensure the flow is:

```text
retrieved source
-> existing/canonical dedup
-> R1 substance
-> candidate/knowledge classification
```

No permanent generated module is allowed at this point merely because the hit is substantive.

## Step 8 — Wire independent production-necessity evidence

Before code authoring, reuse/extend current Gate B/candidate evidence to prove:

```text
real need
canonical owner
integration path
baseline/criterion
```

Fail closed when missing.

## Step 9 — Connect CandidateASHA to current authoring/evaluation/promotion seams

Do not create a parallel promotion system.

Candidate evaluation should progressively allocate expensive tests while current canonical promotion remains the only production authority.

## Step 10 — Add CEM or CMA-ES over LOW-DIMENSIONAL probe controls

Default first choice:

```text
CEM if controls are mixed/categorical/distribution-friendly
CMA-ES if controls are mostly continuous
```

Do not default to raw full-dimensional embedding-coordinate optimization.

## Step 11 — Add portfolio allocation and delayed reward

Only after enough measured probe/candidate outcomes exist.

Use downstream useful yield, not similarity-only reward.

## Step 12 — Add embedding-policy outer-loop experiments if desired

If the goal includes finding a better embedding model/representation:

```text
hold search policy constant
build compatible index per embedding policy
run same benchmark/budget
compare downstream yield/cost
```

Do not mix embedding-model changes with probe-generator changes in the same causal benchmark.

## Step 13 — Shadow run

Run old Topography authority and new adaptive search side-by-side.

New system cannot mutate production merely because it wins retrieval metrics.

Require downstream useful-yield advantage and all guardrails.

## Step 14 — Canary authority

Move a bounded fraction of Harvest search admissions to the new policy.

Keep rollback to current Topography routing.

## Step 15 — Default authority only after sustained proof

Switch default search policy only when:

```text
new policy consistently improves authoritative Harvest metrics
false-prune rate acceptable
cost acceptable
queues stable
no semantic/governance regressions
production-need/promotion invariants intact
```

---

# 46. One-sentence implementation objective

> **Use Agent_X's existing governed semantic/index and Harvest/promotion architecture to turn embedding harvesting into a two-level evidence race—first allocating retrieval budget to the probes that actually discover useful material, then allocating implementation budget only to candidates that independently prove both technical value and real Agent_X production need.**

---

# 47. Final definition of done — embedding Harvest

The integration is complete only when every item below is true.

## Representation/index correctness

- real production embedding provider is used for production evidence;
- provider/model/revision/dimension/normalization/metric identity is explicit;
- fake/hash/path/random embeddings are test-only;
- deterministic preprocessing/chunking is versioned;
- canonical Agent_X semantic service/index is reused;
- no second vector database exists;
- corpus/index context is fingerprinted;
- model/index mismatch fails closed;
- non-finite/degenerate vectors fail closed;
- ANN behavior is validated against an exact/reference path where ANN is used;
- metric direction is canonicalized and tested;
- partial indexing coverage is recorded truthfully;
- unindexed does not mean irrelevant.

## Search-probe functionality

- current Topography is wrapped as a baseline ProbeGenerator;
- probes have stable identity and lineage;
- arbitrary synthetic vectors are probes only, never decoded candidates;
- real retrieved items become candidate inputs;
- raw full-dimensional vector optimization is not the default;
- CEM/CMA-ES/BO operate on bounded, benchmarked controls unless raw-vector experiments explicitly prove value;
- duplicate probes and duplicate retrieval hits are suppressed idempotently;
- probe context/version staleness is enforced;
- retrieval depth and other fidelity resources are explicit;
- ProbeASHA performs real progressive resource allocation;
- low-peer/cold-rung rules prevent unstable early quantile decisions;
- completion-time bias is bounded/observable;
- absolute floors prevent "best of a bad batch" promotion;
- exploration reserve is bounded;
- false-prune probe audits exist.

## Candidate functionality

- probe racing and candidate racing are distinct;
- retrieved material passes canonical dedup/relevance/substance analysis;
- placeholders/wrappers/no-op implementations are rejected early;
- substantive does not automatically mean production-worthy;
- candidate identity is independent from the probe that found it;
- every implementation candidate has measurable contract/baseline;
- CandidateASHA progressively allocates expensive evidence;
- hard guardrails dominate aggregate scores;
- uncertain boundary cases receive adaptive repeat testing;
- specialist/complement outcomes are supported only with evidence;
- candidate false-prune auditing exists.

## Production-necessity / anti-slop correctness

- independent production need is evaluated before expensive authoring where feasible;
- production need is bound to repository revision/owner/action/evidence;
- candidate cannot self-create its own need proof;
- status labels such as update/upgrade/IMPLEMENTED are non-authoritative;
- caller-supplied booleans cannot authorize production need;
- new-module creation has a stricter necessity/owner/integration bar;
- canonical promotion revalidates production need;
- a real/tested algorithm with no current need remains knowledge/evidence rather than production code;
- rejected/non-production discoveries do not clutter the active source tree.

## Scheduling/runtime correctness

- job keys are deterministic/idempotent;
- worker leases and bounded retries exist;
- crash recovery cannot create duplicate authority/evidence;
- evidence commits are atomic;
- stochastic seeds/state are recorded;
- optimizer state is checkpointed/versioned;
- incompatible checkpoint restore fails closed;
- queue backpressure exists;
- admission control exists;
- stage/domain starvation is prevented;
- cancellation/timeout semantics are explicit;
- continuous Harvest uses bounded checkpointed epochs, not uncontrolled loops;
- storage/index build budgets exist;
- stale jobs do not merge evidence into current context.

## Measurement correctness

- search objective is downstream useful yield/cost, not raw similarity;
- proxy and delayed authoritative rewards are separated;
- many-probe-to-one-candidate credit is handled explicitly;
- already-known winner rediscovery is reported separately from new discovery;
- SEARCH/VALIDATION/HOLDOUT or equivalent leakage controls exist;
- benchmark versions and champion versions are recorded;
- same-fidelity comparisons are used for racing;
- ANN changes cannot masquerade as generator changes;
- reranker changes cannot masquerade as embedding-search changes;
- embedding-model changes are benchmarked as a separate outer experiment;
- fixed baselines/ablations can isolate source of gains;
- current Topography remains an equal-budget comparison baseline until superseded by evidence.

## Agent_X architecture correctness

- existing `tools/agentx_evolve/semantic/` stack is reused;
- existing governed embedding route is reused;
- existing candidate/Gate B/canonical-owner/promotion/provenance/lifecycle machinery is reused;
- no duplicate semantic authority, candidate registry, promotion engine, or implementation-status database is introduced;
- semantic/search evidence can rank/route but cannot grant governed effects;
- current canonical promotion remains production authority;
- current lifecycle/registry is the source of active implementation truth;
- implementation adapts to current HEAD if paths have moved.

## Rollout correctness

- current Topography can remain authoritative during shadow comparison;
- new policy is evaluated at equal/normalized budget;
- rollout is reversible;
- canary scope is bounded;
- default authority changes only after sustained downstream improvement and guardrail compliance;
- historical evidence is preserved through rollback/rebase.

---

# 48. Iterative completeness review and stopping condition

This specification was reviewed in repeated adversarial passes. Each pass asked:

> What missing requirement or contradiction could make an otherwise plausible implementation fail, generate misleading evidence, create a parallel Agent_X subsystem, or accelerate Harvest slop?

## Iteration 1 — Generic evaluator completeness

Found and covered:

```text
multi-fidelity candidate evaluation
uncertainty
Pareto/hard-gate separation
cost-aware scheduling
exploration reserve
champion/challenger
source-tree containment
```

Result after pass: **7.0/10** for the narrower embedding-Harvest objective.

Main remaining defect: embedding search itself was underspecified.

## Iteration 2 — Embedding-search semantics

Found and covered:

```text
probe -> retrieval -> real candidate bridge
non-invertibility of embeddings
off-manifold raw vectors
embedding identity
preprocessing/chunking
corpus snapshots
index compatibility
ANN validation
distance calibration
probe/candidate separation
```

Result after pass: **8.4/10**.

Main remaining defects: asynchronous edge cases, representation-model experiments, and failure recovery.

## Iteration 3 — Scheduler/numerical/runtime adversarial pass

Found and covered:

```text
metric direction errors
cold-rung peer counts
completion-time bias
same-fidelity comparison
absolute floors
stale jobs
idempotency
leases
atomic evidence
optimizer checkpoints
retries/timeouts/cancellation
storage/resource bounds
```

Result after pass: **9.2/10**.

Main remaining defect: generic architecture could duplicate existing Agent_X semantic/Harvest subsystems.

## Iteration 4 — Repository-grounded architecture pass

Grounded the plan against known current Agent_X seams and corrected it to reuse:

```text
tools/agentx_evolve/semantic/
models/embedding_provider.py
semantic_execution/
algorithmic_substance_gate/
collective_core authoring/capability/lifecycle machinery
scheduler/orchestrator/promotion machinery
Gate B / canonical promotion
```

Explicitly prohibited:

```text
second semantic stack
second vector database
second promotion system
second implementation-state registry
```

Result after pass: **9.6/10**.

Main remaining defect: a technically real algorithm could still become orphan production slop.

## Iteration 5 — Production-necessity / self-justification pass

Found and covered:

```text
substance != production need
independent need before authoring
need revalidation at canonical promotion
no status/boolean authority
no self-created caller/export/test as need proof
stricter CREATE_CANONICAL_MODULE threshold
IMPLEMENTED derived from current canonical evidence
```

Result after pass: **9.9/10**.

## Iteration 6 — Final end-to-end contradiction and operability pass

Verified the specification now has an explicit answer for:

```text
what is being optimized
what an embedding probe represents
how probes become real harvest items
how Topography fits
where SH/ASHA/Hyperband fits
where CEM/CMA-ES/BO fit
how embedding models themselves are compared
how candidates are progressively evaluated
how duplicate/slop code is stopped
how real production need is established
how promotion remains governed
how failures/restarts/version changes are handled
how feedback reaches search generators
how the system is benchmarked
how it rolls out and rolls back
how it avoids creating parallel Agent_X infrastructure
```

No remaining **known material design contradiction or implementation-critical functional hole** was identified within the scope of integrating adaptive multi-fidelity search into Agent_X embedding Harvest.

### Final completeness score

| Area | Score |
|---|---:|
| Embedding/provider/index correctness | 1/1 |
| Probe semantics and search-space validity | 1/1 |
| Topography + CEM/CMA-ES/BO integration | 1/1 |
| Probe ASHA/Hyperband functionality | 1/1 |
| Candidate evidence scheduling | 1/1 |
| Anti-slop + production necessity | 1/1 |
| Concurrency/recovery/versioning | 1/1 |
| Measurement/benchmark/credit correctness | 1/1 |
| Existing Agent_X architecture/governance reuse | 1/1 |
| Rollout/rollback/acceptance closure | 1/1 |
| **TOTAL** | **10/10** |

### Meaning of 10/10

`10/10` here means:

```text
no known material design hole remains in the implementation specification
under the stated scope and repository facts available to this review
```

It does **not** authorize an implementation to assume current source files still exactly match historical audit documents. The coding pass must inspect current HEAD, map each responsibility to its present canonical owner, and adapt path names without weakening the invariants in this specification.

If current HEAD reveals a stronger existing invariant or a changed canonical owner, preserve the stronger/current architecture rather than mechanically creating the illustrative names in this document.

**Stopping condition reached. This revision is the implementation target for Agent_X embedding Harvest adaptive search.**

