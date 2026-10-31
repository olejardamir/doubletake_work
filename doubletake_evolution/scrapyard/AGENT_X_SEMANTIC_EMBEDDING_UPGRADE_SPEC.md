# Agent_X Semantic Embedding Upgrade Specification

**Repository:** `Astrocytech/Agent_X`  
**Target branch reviewed:** `main`  
**Purpose:** Define exactly what should be changed or added to Agent_X to turn the existing embedding capability into a governed semantic evidence, retrieval, contradiction, and relation-learning layer.  
**Status:** Implementation specification. This document does **not** authorize source changes by itself.

---

## 1. Objective

Agent_X already has strong deterministic governance, policy enforcement, provenance, evaluation, learning review, human approval, and an embedding-provider abstraction. The goal is **not** to replace those systems with embeddings.

The goal is to add a new horizontal capability:

> **Semantic evidence and consistency layer**

It must provide:

1. semantic repository/context retrieval;
2. semantic near-duplicate detection;
3. contradiction candidate detection;
4. contradiction-aware context preservation;
5. semantic durable-memory review;
6. historical regression/failure similarity;
7. learned relation vectors such as failure → repair;
8. optional calibrated semantic predicates;
9. evaluation and audit evidence for every semantic decision.

The authority hierarchy must remain:

```text
semantic inference
      ↓
semantic evidence
      ↓
existing Agent_X policy / validation / human review
      ↓
final decision
```

Embeddings must **never** directly grant authority, bypass policy, approve memory, execute tools, promote a patch, or override an explicit deterministic rule.

---

# 2. Non-negotiable invariants

These are hard requirements.

## 2.1 Deterministic authority remains sovereign

Do **not** alter the meaning of:

- `tools/agentx_evolve/policy/policy_enforcer.py`
- capability allow/deny rules;
- approval requirements;
- sandbox/path boundaries;
- exact test results;
- cryptographic hashes;
- Shepherd liveness/restart state machines.

Semantic results may be attached as evidence, but they do not become authorization.

---

## 2.2 Embeddings supplement hashes; they do not replace them

Continue using SHA-256 or existing content hashes for:

- exact identity;
- artifact integrity;
- exact deduplication;
- checkpoint verification;
- provenance.

Use embeddings for:

- semantic similarity;
- paraphrase detection;
- contradiction candidate retrieval;
- analogical relation retrieval;
- task relevance.

---

## 2.3 Never compare vectors from different semantic spaces

Every vector must belong to a deterministic `space_id`.

A semantic space is defined by at least:

```text
provider
model
model_revision_or_endpoint_profile
dimensions
normalization
input_role
instruction_or_prefix
chunking_profile
pooling_profile
geometry_version
```

Define:

```text
space_id = SHA256(canonical_json(space_profile))
```

No similarity, subtraction, relation arithmetic, contradiction feature construction, or indexing query may combine vectors whose `space_id` values differ.

Mismatch must fail closed with a typed error.

---

## 2.4 Semantic algebra must fail closed

For any operation involving relation vectors or semantic predicates, reject:

- unavailable provider;
- zero-vector fallback;
- all-zero vector;
- NaN;
- Inf;
- dimension mismatch;
- empty model name;
- unexpected model identity;
- unexpected provider identity;
- semantic-space mismatch;
- missing calibration for a thresholded classifier.

Do **not** pad or truncate vectors in the semantic algebra path.

---

## 2.5 Redaction and trust filtering happen before remote embedding

If an embedding provider is network-backed, unredacted sensitive content must not be sent to it.

For context construction the order must be:

```text
source authorization
→ safe repository read
→ prompt-injection filtering
→ sensitive-data redaction
→ embedding
→ semantic ranking / dedupe / contradiction
→ ordinary context packing
```

Blocked sources are never embedded.

---

## 2.6 Similarity is not truth

A high cosine similarity means only that two representations are geometrically close in that semantic space.

It does **not** establish:

- correctness;
- entailment;
- contradiction;
- authorization;
- causal relation;
- equivalence.

Contradiction and relation claims must use separately calibrated logic and remain evidence-level claims.

---

# 3. Fix these current problems first

Three changes should occur before enabling semantic behavior.

---

## 3.1 Fix the current deduplication sort bug

### File

`tools/agentx_evolve/context/deduplication_engine.py`

### Current problem

The final sort currently uses the wrong variable:

```python
_ctx['unique'].sort(
    key=lambda i: _ctx['i'].priority_score,
    reverse=True,
)
```

`_ctx['i']` is not the lambda argument and is not reliably defined at that point.

### Required change

Replace it with:

```python
_ctx['unique'].sort(
    key=lambda i: i.priority_score,
    reverse=True,
)
```

### Required regression test

Create a test that:

1. constructs at least three `ContextItem` values;
2. gives them different `priority_score` values;
3. includes at least one exact duplicate;
4. runs `deduplicate_context_items`;
5. verifies:
   - no exception;
   - duplicate count is correct;
   - returned `unique_items` are descending by `priority_score`.

This fix should be committed independently or at least isolated in the first semantic-upgrade change set.

---

## 3.2 Stop building repository context from paths only

### Files

- `tools/agentx_evolve/context/task_pack_builder.py`
- `tools/agentx_evolve/context/context_source_loader.py`
- new file: `tools/agentx_evolve/context/repository_text_loader.py`

### Current problem

The current source-to-item path can create a `ContextItem` using:

```python
content = src.source_path or src.source_id
```

instead of actual repository text.

Also:

```python
build_context_items_from_sources(
    sources,
    source_payloads=None,
    ...
)
```

currently ignores `source_payloads`.

This means semantic retrieval would otherwise risk embedding paths such as:

```text
tools/agentx_evolve/policy/policy_enforcer.py
```

rather than the code or snippets inside the file.

### Required change

Add a governed repository-text loader that uses the existing security read boundary.

Create:

`tools/agentx_evolve/context/repository_text_loader.py`

with a public function equivalent to:

```python
def load_repository_text(
    *,
    repo_root: Path,
    relative_path: str,
    sandbox_policy: SandboxPolicy,
) -> RepositoryTextLoadResult:
    ...
```

The implementation must call the existing:

```python
agentx_evolve.security.safe_file_ops.safe_read_file(...)
```

rather than direct unrestricted `Path.read_text()`.

`safe_read_file()` already enforces:

- repository boundary;
- read authorization;
- maximum file size;
- UTF-8 text;
- file existence/type;
- optional audit.

### Required `RepositoryTextLoadResult`

Use a dataclass with:

```python
@dataclass
class RepositoryTextLoadResult:
    path: str
    content: str = ""
    content_hash: str = ""
    bytes_read: int = 0
    security_decision_id: str | None = None
    status: str = ""
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
```

### Required behavior

- Never read outside `repo_root`.
- Never bypass `safe_read_file`.
- Binary/non-UTF-8 files return an error, not an embedding.
- Oversized files return blocked/error according to the sandbox result.
- Preserve the `decision_id` from the safe-file operation as evidence.

### Change `_sources_to_items`

Refactor `_sources_to_items` so it receives resolved content rather than using a file path as content.

Preferred signature:

```python
def _sources_to_items(
    sources: list[ContextSource],
    source_payloads: dict[str, str] | None = None,
) -> list[ContextItem]:
```

For each source:

```python
content = source_payloads.get(src.source_id, "") if source_payloads else ""
```

Repository files with no loaded payload should either:

1. be excluded with a warning; or
2. produce a path-only metadata item explicitly marked as metadata-only.

Do **not** silently label a path string as a file snippet.

### Update `build_context_items_from_sources`

Actually pass and use `source_payloads`.

---

## 3.3 Create a strict semantic wrapper around the existing embedding provider

### Existing files

- `tools/agentx_evolve/models/embedding_provider.py`
- `tools/agentx_evolve/models/openai_compatible_embedding.py`

Do not break their existing generic retrieval/fallback behavior if other Agent_X code depends on it.

### New file

`tools/agentx_evolve/semantic/strict_provider.py`

### Purpose

Wrap `BaseEmbeddingProvider` and make semantic operations fail closed.

### Required public API

```python
class SemanticEmbeddingError(RuntimeError):
    pass


class StrictSemanticEmbeddingProvider:
    def __init__(
        self,
        provider: BaseEmbeddingProvider,
        expected_model: str,
        expected_dimensions: int,
        normalize: bool = True,
    ):
        ...

    def embed(self, text: str) -> SemanticEmbedding:
        ...

    def embed_batch(self, texts: list[str]) -> list[SemanticEmbedding]:
        ...
```

### Validation requirements

For each provider response:

```text
provider available
model == expected_model
len(vector) == expected_dimensions
all elements finite
L2 norm > epsilon
not all zero
```

Then normalize if the semantic space profile requires L2 normalization.

Never pad.

Never truncate.

Never substitute a zero vector.

Never reuse a generic provider fallback result as valid semantic evidence.

---

# 4. Add a new canonical semantic package

Create:

```text
tools/agentx_evolve/semantic/
```

This should be a canonical implementation package, not a compatibility wrapper.

Minimum initial files:

```text
tools/agentx_evolve/semantic/
    __init__.py
    semantic_models.py
    semantic_space.py
    strict_provider.py
    semantic_index.py
    semantic_retrieval.py
    semantic_deduplication.py
    contradiction.py
    relation_learning.py
    semantic_evidence.py
    calibration.py
    predicate_engine.py
    cli.py
```

Do not place semantic implementation logic in L0.

Add the package to:

`tools/agentx_evolve/ARCHITECTURE.md`

under canonical layer modules, preferably adjacent to model/context/learning capability descriptions.

Suggested architecture entry:

```text
Semantic evidence/retrieval/relations: `semantic/`
```

---

# 5. Define the semantic data model

## File

`tools/agentx_evolve/semantic/semantic_models.py`

Add the following core dataclasses.

---

## 5.1 `SemanticSpaceProfile`

```python
@dataclass(frozen=True)
class SemanticSpaceProfile:
    schema_version: str = "1.0"
    provider: str = ""
    model: str = ""
    model_revision: str = ""
    dimensions: int = 0
    normalization: str = "l2"
    input_role: str = "document"
    instruction: str = ""
    chunking_profile: str = "atomic-v1"
    pooling_profile: str = "provider-default"
    geometry_version: str = "1"
    space_id: str = ""
```

`space_id` must be deterministically derived from all geometry-affecting fields.

---

## 5.2 `SemanticEmbedding`

```python
@dataclass
class SemanticEmbedding:
    space_id: str = ""
    model: str = ""
    provider: str = ""
    dimensions: int = 0
    vector: tuple[float, ...] = ()
    vector_sha256: str = ""
    text_sha256: str = ""
```

The vector should not be serialized into ordinary JSON audit logs. Store a vector reference or BLOB in the index.

---

## 5.3 `SemanticMatch`

```python
@dataclass
class SemanticMatch:
    record_id: str = ""
    object_id: str = ""
    object_kind: str = ""
    score: float = 0.0
    space_id: str = ""
    evidence_ref: str = ""
    metadata: dict = field(default_factory=dict)
```

---

## 5.4 `SemanticEvidenceRecord`

```python
@dataclass
class SemanticEvidenceRecord:
    evidence_id: str = ""
    created_at: str = ""
    operation: str = ""
    authority: str = "EVIDENCE_ONLY"
    space_id: str = ""
    subject_refs: list[str] = field(default_factory=list)
    result: dict = field(default_factory=dict)
    calibration_id: str | None = None
    source_hashes: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
```

`authority` must remain `EVIDENCE_ONLY` for semantic inference.

---

## 5.5 `SemanticConflict`

```python
@dataclass
class SemanticConflict:
    conflict_id: str = ""
    claim_a_ref: str = ""
    claim_b_ref: str = ""
    similarity_score: float = 0.0
    contradiction_score: float = 0.0
    status: str = "POSSIBLE"
    space_id: str = ""
    calibration_id: str = ""
    evidence_refs: list[str] = field(default_factory=list)
```

Allowed statuses:

```text
POSSIBLE
SUPPORTED
RESOLVED_A_WINS
RESOLVED_B_WINS
BOTH_CONTEXTUALLY_VALID
SUPERSEDED
INSUFFICIENT_EVIDENCE
FORMAL_CONTRADICTION
FALSE_POSITIVE
```

---

## 5.6 `RelationModel`

```python
@dataclass
class RelationModel:
    relation_id: str = ""
    relation_type: str = ""
    space_id: str = ""
    vector_sha256: str = ""
    training_pair_refs: list[str] = field(default_factory=list)
    training_count: int = 0
    validation_metrics: dict = field(default_factory=dict)
    status: str = "EXPERIMENTAL"
    created_at: str = ""
```

Initially support relation types:

```text
FAILURE_TO_REPAIR
PROPOSAL_TO_PROMOTED
REJECTED_TO_CORRECTED
DRIFTED_TO_CANONICAL
UNSUPPORTED_TO_VERIFIED
```

---

# 6. Implement semantic-space identity and math

## File

`tools/agentx_evolve/semantic/semantic_space.py`

Required functions:

```python
def compute_space_id(profile: SemanticSpaceProfile) -> str
def validate_vector(vector: tuple[float, ...], expected_dim: int) -> None
def l2_normalize(vector: tuple[float, ...]) -> tuple[float, ...]
def cosine_similarity(a: SemanticEmbedding, b: SemanticEmbedding) -> float
def subtract(a: SemanticEmbedding, b: SemanticEmbedding) -> tuple[float, ...]
def add_vector(base: SemanticEmbedding, delta: tuple[float, ...]) -> tuple[float, ...]
def mean_vectors(vectors: list[tuple[float, ...]]) -> tuple[float, ...]
```

Every binary operation must assert matching `space_id`.

For normalized vectors, cosine may be implemented as a dot product after validating both vectors.

No NumPy dependency is required for Phase 1; standard-library math is acceptable. If NumPy is already guaranteed by Agent_X runtime, it may be used, but semantic behavior must remain deterministic and tested.

---

# 7. Add a durable semantic index

## File

`tools/agentx_evolve/semantic/semantic_index.py`

Use Python standard-library `sqlite3` for the first implementation.

Do **not** introduce an external vector database initially.

Runtime path:

```text
.agentx-init/semantic/semantic_index.sqlite3
```

SQLite gives:

- transactional writes;
- compact local storage;
- no new service;
- no network dependency;
- deterministic metadata filtering;
- easy migration/versioning.

For current Agent_X scale, brute-force cosine over filtered vectors is acceptable.

---

## 7.1 Required table: `semantic_vectors`

Columns:

```sql
record_id TEXT PRIMARY KEY,
object_id TEXT NOT NULL,
object_kind TEXT NOT NULL,
scope TEXT,
status TEXT,
space_id TEXT NOT NULL,
text_sha256 TEXT NOT NULL,
vector_sha256 TEXT NOT NULL,
dimensions INTEGER NOT NULL,
vector_f32le BLOB NOT NULL,
source_ref TEXT,
created_at TEXT NOT NULL,
metadata_json TEXT NOT NULL
```

Indexes:

```sql
CREATE INDEX ... ON semantic_vectors(space_id);
CREATE INDEX ... ON semantic_vectors(object_kind);
CREATE INDEX ... ON semantic_vectors(scope);
CREATE INDEX ... ON semantic_vectors(status);
CREATE INDEX ... ON semantic_vectors(text_sha256);
```

---

## 7.2 Required table: `semantic_edges`

Columns:

```sql
edge_id TEXT PRIMARY KEY,
edge_type TEXT NOT NULL,
source_object_id TEXT NOT NULL,
target_object_id TEXT NOT NULL,
space_id TEXT NOT NULL,
score REAL,
secondary_score REAL,
calibration_id TEXT,
status TEXT,
evidence_ref TEXT,
created_at TEXT NOT NULL,
metadata_json TEXT NOT NULL
```

Initial edge types:

```text
SEMANTICALLY_SIMILAR
POSSIBLE_PARAPHRASE
POSSIBLY_CONTRADICTS
SUPPORTS
TRANSFORMS_TO
REPAIRS
REGRESSES_FROM
RELATED_TO
```

---

## 7.3 Required table: `relation_models`

Columns:

```sql
relation_id TEXT PRIMARY KEY,
relation_type TEXT NOT NULL,
space_id TEXT NOT NULL,
vector_sha256 TEXT NOT NULL,
dimensions INTEGER NOT NULL,
vector_f32le BLOB NOT NULL,
training_count INTEGER NOT NULL,
training_refs_json TEXT NOT NULL,
metrics_json TEXT NOT NULL,
status TEXT NOT NULL,
created_at TEXT NOT NULL
```

---

## 7.4 Required index API

```python
class SemanticIndex:
    def upsert_embedding(...)
    def get_embedding(...)
    def delete_object(...)
    def search(...)
    def add_edge(...)
    def list_edges(...)
    def save_relation_model(...)
    def get_relation_model(...)
```

`search(...)` must allow metadata filters before cosine ranking:

```python
search(
    query,
    object_kinds=None,
    scopes=None,
    statuses=None,
    top_k=10,
)
```

All returned matches must share the query's `space_id`.

---

# 8. Add semantic chunking for repository text

## File

`tools/agentx_evolve/semantic/semantic_retrieval.py`

Do not start by embedding entire large source files as one average vector.

Create semantic retrieval units that are small enough to correspond to coherent code or documentation sections.

Initial deterministic chunking rule:

### Python

Prefer chunks by:

1. top-level class;
2. top-level function;
3. module-level constant/import preamble;
4. fallback fixed line windows.

### TypeScript/JavaScript

Initially use deterministic line windows unless an existing parser is already available.

### Markdown

Chunk by headings.

### Fallback

Use:

```text
max 160 lines per chunk
20-line overlap
```

Keep:

```text
source_path
start_line
end_line
content_sha256
```

Every semantic result must be traceable back to exact source text.

Do not use character-overlap averaging for relation arithmetic.

---

# 9. Change `ContextItem` to carry semantic metadata

## File

`tools/agentx_evolve/context/context_models.py`

Add optional fields to `ContextItem`:

```python
semantic_space_id: str | None = None
semantic_record_id: str | None = None
semantic_relevance_score: float = 0.0
semantic_cluster_id: str | None = None
semantic_conflict_refs: list[str] = field(default_factory=list)
semantic_evidence_refs: list[str] = field(default_factory=list)
```

Do **not** place raw vectors in `ContextItem`.

Vectors live in the semantic index.

Also add an item kind if needed:

```python
ITEM_KIND_SEMANTIC_CONFLICT = "SEMANTIC_CONFLICT"
```

and include it in any relevant kind registries/validation.

---

# 10. Replace keyword-only file relevance with hybrid relevance

## Files

- `tools/agentx_evolve/context/context_source_loader.py`
- `tools/agentx_evolve/context/priority_scorer.py`
- new adapter: `tools/agentx_evolve/context/semantic_context_adapter.py`

Do not delete lexical matching. Keep it as one feature.

---

## 10.1 New semantic-context adapter

Create:

`tools/agentx_evolve/context/semantic_context_adapter.py`

Public interface:

```python
def score_context_semantics(
    *,
    task_text: str,
    items: list[ContextItem],
    semantic_service: SemanticService,
) -> list[ContextItem]:
    ...
```

It should:

1. embed the task objective;
2. embed/index eligible redacted context chunks;
3. assign `semantic_relevance_score`;
4. attach evidence refs;
5. return the items without changing trust levels.

---

## 10.2 Hybrid priority score

Modify:

`tools/agentx_evolve/context/priority_scorer.py`

Current trust behavior remains.

Use a score conceptually equivalent to:

```text
priority =
    0.35 * trust_score
  + 0.35 * semantic_relevance
  + 0.10 * lexical_relevance
  + 0.10 * constraint_or_requirement_bonus
  + 0.10 * target_file_bonus
```

Then clamp to `[0, 1]`.

Exact initial weights may be stored in a profile:

```text
.agentx-init/semantic/calibration/context-ranking-v1.json
```

Do not hardcode thresholds in many files.

### Fail-safe behavior

If semantic service is unavailable:

```text
semantic_relevance = 0
```

and continue with deterministic/lexical ranking.

Do not return fabricated zero-vector evidence.

Retrieval is allowed to degrade gracefully; semantic algebra is not.

---

# 11. Run semantic processing in the correct context-packing order

## File

`tools/agentx_evolve/context/task_pack_builder.py`

Refactor the current pipeline to:

```text
1. normalize task
2. load/authorize context sources
3. safely load repository text/snippets
4. convert sources to ContextItems
5. prompt-injection filtering
6. sensitive-data redaction
7. semantic embedding/relevance
8. priority scoring
9. recency scoring
10. exact deduplication
11. semantic near-deduplication
12. semantic contradiction scan
13. budget estimation
14. contradiction-aware compression planning
15. semantic representative excerpt selection
16. model compatibility
17. tool compatibility
18. build TaskPack
```

This ordering is important.

Semantic embedding must not occur before redaction.

---

# 12. Keep exact deduplication and add semantic deduplication separately

## Existing file

`tools/agentx_evolve/context/deduplication_engine.py`

Its responsibility should remain **exact/key deduplication**.

Do not overload it with semantic logic.

## New file

`tools/agentx_evolve/semantic/semantic_deduplication.py`

Required API:

```python
def find_semantic_duplicates(
    items: list[ContextItem],
    *,
    similarity_threshold: float,
    semantic_index: SemanticIndex,
) -> SemanticDedupResult:
    ...
```

Use the result to form semantic clusters.

Do not automatically delete all members of a semantic cluster.

Rules:

```text
exact duplicate
    → existing exact dedupe behavior

very-high semantic similarity + same provenance family
    → retain highest-trust/highest-priority item; mark others as semantic duplicates

very-high similarity + independent provenance
    → keep the primary item but preserve supporting provenance refs

similar but conflicting
    → do NOT dedupe; send to contradiction stage
```

A contradiction candidate always takes precedence over semantic deduplication.

---

# 13. Add a contradiction engine

## File

`tools/agentx_evolve/semantic/contradiction.py`

Do not define contradiction as `1 - cosine`.

Contradictory statements can be highly similar.

Initial architecture:

```text
candidate claim
     ↓
semantic nearest-neighbor retrieval
     ↓
pair feature construction
     ↓
calibrated contradiction classifier
     ↓
SemanticConflict evidence
```

---

## 13.1 Candidate retrieval

For each claim, retrieve semantically close candidates first.

This limits pairwise cost.

Example:

```python
neighbors = index.search(
    query_embedding,
    object_kinds=["MEMORY_CANDIDATE", "POLICY_CLAIM", "CONSTRAINT", ...],
    top_k=50,
)
```

---

## 13.2 Pair features

For embeddings `u` and `v`, support the feature representation:

```text
|u - v|
u ⊙ v
cos(u, v)
```

A small trained classifier may estimate:

```text
p_contradiction
```

Alternatively, Phase 1 may use a dedicated textual contradiction/NLI model if it is separately governed and calibrated.

The classifier/model identity must be part of `calibration_id`.

---

## 13.3 Contradiction thresholds

Use three bands:

```text
p < low_threshold
    → no contradiction evidence

low_threshold <= p < review_threshold
    → weak warning/evidence only

p >= review_threshold
    → POSSIBLE_CONTRADICTION + human-review path where applicable
```

Do not use one magic universal threshold without calibration.

Thresholds must be benchmarked per semantic profile.

---

## 13.4 Scope resolution

Before escalating a contradiction, compare structured scope where available.

Examples:

```text
"network access prohibited"
"network access allowed in development mode"
```

may be compatible if scope differs.

The contradiction engine should attach:

```text
scope_a
scope_b
scope_compatible
```

but should not invent scope from embeddings alone.

If scope cannot be resolved deterministically, keep the conflict as possible rather than declaring it formal.

---

# 14. Make context compression contradiction-aware

## Files

- `tools/agentx_evolve/context/compression_planner.py`
- `tools/agentx_evolve/context/summary_selector.py`

### Change `compression_planner.py`

Today, compression primarily uses item kind, trust, and priority.

Add a hard keep rule:

```python
if item.semantic_conflict_refs:
    must_keep.append(item.context_item_id)
```

Also preserve both members of a semantic conflict pair until the conflict is resolved.

Required rule:

```text
CONSTRAINT / REQUIREMENT / POLICY
OR high trust
OR member of unresolved semantic conflict
→ MUST KEEP VERBATIM
```

---

## 14.1 Improve summary selection

The current summary path is essentially a fixed prefix/extractive excerpt.

Add semantic representative excerpt selection.

For a long eligible item:

1. split into deterministic chunks;
2. embed chunks;
3. embed current task;
4. rank chunks by task similarity;
5. penalize redundancy with already selected chunks;
6. select chunks until the summary character/token budget is filled;
7. preserve original text exactly.

Suggested selection score:

```text
score(chunk_i) =
    lambda * similarity(task, chunk_i)
  - (1 - lambda) * max_similarity(chunk_i, selected_chunks)
```

Initial `lambda = 0.75`, but place it in calibration/config.

This remains extractive, preserving provenance and reducing hallucination risk.

---

# 15. Add semantic review to durable learning

This is the second major production use after context retrieval.

## Files

- `tools/agentx_evolve/learning/outcome_models.py`
- `tools/agentx_evolve/learning/learning_index.py`
- `tools/agentx_evolve/learning/memory_candidate_builder.py`
- `tools/agentx_evolve/learning/outcome_reviewer.py`
- new file: `tools/agentx_evolve/learning/semantic_memory_review.py`

---

## 15.1 Extend `MemoryCandidate`

Add fields:

```python
semantic_space_id: str | None = None
semantic_record_id: str | None = None
semantic_near_duplicate_refs: list[str] = field(default_factory=list)
semantic_conflict_refs: list[str] = field(default_factory=list)
semantic_evidence_refs: list[str] = field(default_factory=list)
```

Keep existing:

```text
hash_of_candidate_text
supporting_evidence_refs
contradicting_evidence_refs
```

---

## 15.2 Do not replace `learning_index.py`

The current hash lists remain useful for exact identity.

Keep:

```text
candidate_hashes
approved_candidate_hashes
blocked_candidate_hashes
```

Add only lightweight semantic index references if useful, for example:

```python
semantic_index_path: str = ".agentx-init/semantic/semantic_index.sqlite3"
semantic_space_ids: list[str] = field(default_factory=list)
```

The vector data itself belongs in the semantic index, not in the learning JSON index.

---

## 15.3 Add semantic memory review

Create:

`tools/agentx_evolve/learning/semantic_memory_review.py`

Required API:

```python
def review_memory_candidate_semantics(
    candidate: MemoryCandidate,
    *,
    semantic_service: SemanticService,
    approved_statuses: tuple[str, ...] = ("APPROVED",),
    blocked_statuses: tuple[str, ...] = ("BLOCKED", "REJECTED"),
) -> SemanticMemoryReview:
    ...
```

Required operations:

1. exact hash check remains first;
2. embed candidate text;
3. query existing approved and blocked memory candidates;
4. identify near duplicates/paraphrases;
5. run contradiction classifier against top semantic neighbors;
6. attach supporting/contradicting refs;
7. return evidence only.

---

## 15.4 Insert semantic review before learning policy decision

In:

`tools/agentx_evolve/learning/outcome_reviewer.py`

Current conceptual sequence:

```text
build signals
→ build candidates
→ check learning policy
```

Change to:

```text
build signals
→ build candidates
→ semantic memory review
→ attach semantic evidence
→ check learning policy
→ human approval / existing memory workflow
```

If a high-confidence contradiction is found against an **approved** durable memory:

```text
candidate.status = NEEDS_HUMAN_REVIEW
candidate.requires_human_approval = True
candidate.contradicting_evidence_refs += matching evidence refs
candidate.semantic_conflict_refs += conflict ids
```

Do not automatically reject it because the old memory may itself be obsolete.

If the candidate is a near paraphrase of an already approved memory:

```text
mark semantic near-duplicate
avoid promoting redundant durable memory
preserve evidence that the behavior was re-observed
```

---

# 16. Add historical semantic regression linkage

## File

`tools/agentx_evolve/learning/regression_linker.py`

Keep current deterministic evidence as primary:

- failing tests;
- prior passing refs;
- monitoring degradation;
- commit refs.

Add semantic investigation evidence, not causal proof.

For a new regression:

1. build an atomic textual regression summary;
2. embed it;
3. retrieve historical regression/failure records;
4. return top analogous incidents;
5. include their repairs and related commits as investigation candidates.

Extend `RegressionLink` optionally with:

```python
semantic_related_regression_refs: list[str] = field(default_factory=list)
semantic_evidence_refs: list[str] = field(default_factory=list)
```

Do not increase `CONFIRMED` regression status solely because semantic similarity is high.

---

# 17. Learn Agent_X relation vectors from historical experience

## File

`tools/agentx_evolve/semantic/relation_learning.py`

This is the experimental algebraic layer.

Do not begin with arbitrary English analogies.

Learn Agent_X-specific transitions.

---

## 17.1 Failure → repair

For historical verified pairs:

```text
failure_i
repair_i
```

embed:

```text
F_i = E(failure_i)
R_i = E(repair_i)
```

compute:

```text
d_i = R_i - F_i
```

learn:

```text
r_repair = mean(d_i)
```

For an unseen failure:

```text
q = E(new_failure) + r_repair
```

Use `q` only to retrieve historical verified repair records:

```text
best_repair =
    argmax cosine(E(repair_candidate), q)
```

Do not decode vectors directly into executable code.

Do not execute the retrieved repair automatically.

The retrieved repair becomes evidence/context for the agent.

---

## 17.2 Required controls

Every relation benchmark must compare:

### Baseline A

Nearest historical repair by ordinary similarity to the failure:

```text
cos(E(new_failure), E(old_failure))
```

### Treatment

Relation-transformed retrieval:

```text
E(new_failure) + r_repair
```

The relation model is useful only if treatment significantly improves held-out retrieval.

---

## 17.3 Relation quality checks

Before a relation is promoted from `EXPERIMENTAL` to `VALIDATED`:

- minimum training pair count;
- held-out evaluation;
- no train/test pair leakage;
- same `space_id`;
- stable results under repeated deterministic evaluation;
- measurable improvement over similarity-only baseline.

Store:

```text
top1_accuracy
top5_accuracy
MRR
baseline_top1
baseline_top5
baseline_MRR
mean_relation_alignment
relation_variance
```

---

# 18. Add optional semantic Boolean predicates

## File

`tools/agentx_evolve/semantic/predicate_engine.py`

This is Phase 5 or later.

Possible predicates:

```text
EXTERNAL_EFFECT
SENSITIVE_DATA
IRREVERSIBLE_EFFECT
PRIVILEGE_CHANGE
SECURITY_RELEVANT
REQUIRES_HUMAN_REVIEW
```

A semantic predicate returns:

```python
@dataclass
class SemanticPredicateResult:
    predicate: str
    probability: float
    threshold: float
    value: bool
    calibration_id: str
    space_id: str
    evidence_ref: str
```

Once thresholded, Boolean operations may be exact over the inferred values:

```text
DANGEROUS =
    EXTERNAL_EFFECT AND IRREVERSIBLE_EFFECT

REVIEW =
    SENSITIVE_DATA OR PRIVILEGE_CHANGE
```

However the source predicates are probabilistic.

Never let a semantic predicate bypass an explicit policy rule.

Preferred policy interaction:

```text
semantic predicate says "review-worthy"
        ↓
attach evidence / request stricter deterministic review path
```

not:

```text
semantic predicate says "safe"
        ↓
skip policy
```

---

# 19. Do not put semantic inference inside `PolicyEnforcer.enforce()`

## File to leave deterministic

`tools/agentx_evolve/policy/policy_enforcer.py`

Do not add cosine similarity, vector search, or model calls inside `enforce()`.

If semantic evidence affects a policy workflow, pass it in as structured precomputed evidence or a risk classification that an explicit deterministic policy rule knows how to handle.

Example:

```text
semantic_review_required = true
```

Then a deterministic policy rule may require human approval.

The semantic model itself never returns `ALLOW`.

---

# 20. Add semantic evidence persistence

## File

`tools/agentx_evolve/semantic/semantic_evidence.py`

Runtime root:

```text
.agentx-init/semantic/
```

Required files:

```text
.agentx-init/semantic/
    semantic_index.sqlite3
    semantic_events.jsonl
    latest_semantic_status.json
    calibration/
    manifests/
```

Each significant semantic operation should append an event.

Example event:

```json
{
  "evidence_id": "sem-...",
  "operation": "contradiction_scan",
  "authority": "EVIDENCE_ONLY",
  "space_id": "...",
  "subject_refs": ["memory:mc-a", "memory:mc-b"],
  "result": {
    "similarity_score": 0.91,
    "contradiction_score": 0.87,
    "status": "POSSIBLE"
  },
  "calibration_id": "contradiction-v1",
  "source_hashes": ["...", "..."],
  "created_at": "..."
}
```

Never dump raw secret-bearing source text into semantic audit events.

Prefer refs and hashes.

---

# 21. Register semantic output with provenance

Where semantic evidence becomes relevant to a model/learning/policy decision, attach its evidence ID to the existing:

```text
evidence_refs
```

fields already used throughout Agent_X.

Do not invent a parallel authority chain.

The semantic layer participates in the existing provenance model through evidence refs.

---

# 22. Extend Agent_X evaluation with semantic comparators

## Files

- `tools/agentx_evolve/evaluation/evaluation_models.py`
- `tools/agentx_evolve/evaluation/comparator_engine.py`
- new file: `tools/agentx_evolve/evaluation/semantic_comparators.py`

Add comparator constants:

```python
SEMANTIC_SIMILARITY_AT_LEAST = "SEMANTIC_SIMILARITY_AT_LEAST"
SEMANTIC_SIMILARITY_AT_MOST = "SEMANTIC_SIMILARITY_AT_MOST"
CONTRADICTION_SCORE_AT_LEAST = "CONTRADICTION_SCORE_AT_LEAST"
CONTRADICTION_SCORE_AT_MOST = "CONTRADICTION_SCORE_AT_MOST"
RELATION_ALIGNMENT_AT_LEAST = "RELATION_ALIGNMENT_AT_LEAST"
SEMANTIC_RETRIEVAL_CONTAINS = "SEMANTIC_RETRIEVAL_CONTAINS"
```

Add them to `ALL_COMPARATOR_TYPES`.

Do not implement provider/model calls directly inside the generic deterministic comparator engine.

Instead, `semantic_comparators.py` should consume precomputed semantic evidence or an injected semantic evaluation context.

The generic comparator engine dispatches to the semantic comparator only when the benchmark explicitly requests it.

Semantic comparators must report:

```text
comparator_type
actual
expected
passed
space_id
calibration_id
evidence_ref
```

---

# 23. Add four benchmark suites before production rollout

Use the existing evaluation benchmark framework.

Create benchmark definitions/data for:

```text
semantic_context_retrieval
semantic_memory_deduplication
semantic_contradiction
semantic_relation_repair
```

Store them under the repository's existing evaluation benchmark structure.

---

## 23.1 Semantic context retrieval benchmark

Historical case:

```text
input:
    task objective

gold:
    files/chunks actually needed or touched
```

Metrics:

```text
Recall@5
Recall@10
MRR
precision@K
context tokens used
gold coverage per 1,000 tokens
```

Compare:

```text
existing lexical/path selector
vs
hybrid semantic selector
```

Production acceptance target:

- no material drop in exact target-file retention;
- meaningful Recall@K improvement;
- same or lower token use for equivalent gold coverage.

Do not set a numeric target until a baseline is measured.

---

## 23.2 Semantic memory deduplication benchmark

Create labeled pairs:

```text
EXACT_DUPLICATE
PARAPHRASE
RELATED_BUT_DISTINCT
CONTRADICTORY
UNRELATED
```

Measure:

```text
paraphrase precision
paraphrase recall
false merge rate
```

The most important safety metric is **false merge rate**.

A distinct policy/constraint must not be removed because it sounds similar.

---

## 23.3 Contradiction benchmark

Create Agent_X-specific pairs from:

- approved memory vs later conflicting candidate;
- policy vs violating proposal;
- constraint vs contradictory plan;
- specification vs drifted description;
- success claim vs contradictory evaluation evidence.

Metrics:

```text
precision
recall
PR-AUC
calibration error
false-negative rate
precision at human-review budget
recall at human-review budget
```

Split by semantic family and time, not merely random rows.

---

## 23.4 Relation-repair benchmark

Historical verified pairs:

```text
failure → repair
```

Train relation vector on training history.

Evaluate on held-out incidents.

Compare:

```text
ordinary semantic nearest-neighbor baseline
vs
relation-transformed retrieval
```

Do not enable relation-guided production retrieval until it beats baseline on held-out data.

---

# 24. Add calibration profiles

## File

`tools/agentx_evolve/semantic/calibration.py`

Runtime/config path:

```text
.agentx-init/semantic/calibration/
```

Profiles must be immutable/versioned once used as decision evidence.

Example:

```json
{
  "calibration_id": "semantic-context-v1",
  "space_id": "...",
  "semantic_duplicate_threshold": 0.94,
  "contradiction_candidate_similarity_floor": 0.45,
  "contradiction_review_threshold": 0.82,
  "context_weight_semantic": 0.35,
  "context_weight_trust": 0.35,
  "context_weight_lexical": 0.10,
  "context_weight_constraint": 0.10,
  "context_weight_target_file": 0.10,
  "created_at": "...",
  "benchmark_ref": "..."
}
```

These example values are starting values only. Replace them with empirically selected values after benchmark runs.

Every semantic evidence record that depends on a threshold must record the `calibration_id`.

---

# 25. Add a `SemanticService` facade

To avoid coupling every package directly to SQLite/provider details, create a facade.

## File

`tools/agentx_evolve/semantic/__init__.py` or a dedicated:

`tools/agentx_evolve/semantic/service.py`

Preferred API:

```python
class SemanticService:
    def embed_atomic(...)
    def index_text(...)
    def search(...)
    def semantic_similarity(...)
    def find_near_duplicates(...)
    def find_conflicts(...)
    def learn_relation(...)
    def apply_relation_query(...)
    def record_evidence(...)
```

Context, learning, evaluation, and regression code should call this service or small package-specific adapters.

Do not let those packages manipulate raw vector BLOBs themselves.

---

# 26. Update package exports

Update:

```text
tools/agentx_evolve/semantic/__init__.py
```

to export only stable public types/functions.

If Agent_X maintains package-wide import surfaces in:

```text
tools/agentx_evolve/models/__init__.py
tools/agentx_evolve/context/__init__.py
tools/agentx_evolve/learning/__init__.py
tools/agentx_evolve/evaluation/__init__.py
```

add only the new adapter/public symbols needed by callers.

Avoid exposing internal classifier/training details as general public API.

---

# 27. Security requirements for embedding providers

For network-backed providers:

1. obey existing network policy;
2. only send text after source authorization and redaction;
3. never send blocked source text;
4. log provider/model/space identity, not raw sensitive text;
5. allow local providers where network is disallowed;
6. treat provider unavailability as:
   - graceful semantic-feature degradation for ordinary retrieval;
   - hard failure for arithmetic/classifier operations that claim semantic evidence;
7. cache by:
   ```text
   space_id + text_sha256
   ```
   so the same redacted text need not be re-embedded.

The semantic index must never reuse a cached vector if `space_id` differs.

---

# 28. Shepherd remains unchanged

Do not add semantic logic to:

```text
shepherd/watch.ts
```

or the restart/liveness state machine.

Health detection, restart thresholds, safe-mode latching, and backoff must remain deterministic.

Semantic services may themselves expose health information, but semantic health must not redefine Shepherd's core state transitions unless a future explicit architecture change is approved.

---

# 29. Recommended implementation sequence

Implement in this order.

---

## Phase 0 — correctness and foundations

### Change

- fix `deduplication_engine.py` lambda bug;
- add governed repository content loading;
- make `source_payloads` real;
- create semantic package skeleton;
- implement `SemanticSpaceProfile`;
- implement strict semantic provider wrapper;
- implement vector validation;
- implement SQLite semantic index;
- add semantic audit events.

### Definition of done

- all existing tests pass;
- repository content is read only through safe-file boundaries;
- semantic space mismatches raise;
- zero/invalid vectors raise in strict semantic mode;
- vectors can be stored/retrieved by `space_id`;
- no production decision uses semantic results yet.

---

## Phase 1 — semantic context retrieval in shadow mode

### Change

- chunk repository text;
- index chunks;
- compute task relevance;
- keep existing selector as primary;
- record what semantic ranking would have selected.

### Definition of done

- historical benchmark exists;
- hybrid selector measured against current selector;
- no behavior change to production context selection until benchmark reviewed.

---

## Phase 2 — enable hybrid context ranking

### Change

- use semantic relevance in `priority_scorer.py`;
- retain trust/policy constraints;
- use semantic representative excerpts for compression.

### Definition of done

- hybrid retrieval beats or materially improves current historical Recall@K/token efficiency;
- blocked/untrusted source behavior is unchanged;
- provider outage falls back to deterministic ranking.

---

## Phase 3 — semantic deduplication

### Change

- semantic clusters;
- paraphrase detection;
- provenance-preserving merge behavior;
- contradiction candidates are exempt from semantic dedupe.

### Definition of done

- benchmarked low false-merge rate;
- exact dedup still works independently;
- independent supporting sources are not silently erased.

---

## Phase 4 — contradiction-aware durable memory

### Change

- extend `MemoryCandidate`;
- add `semantic_memory_review.py`;
- insert review before `check_learning_policy`;
- store conflict evidence;
- route high-confidence conflicts to human review.

### Definition of done

- approved memory is semantically searchable;
- paraphrased duplicates are detected;
- contradictory candidates are surfaced;
- semantic layer cannot approve/reject memory by itself.

---

## Phase 5 — contradiction-aware context packs

### Change

- scan selected context claims for conflict;
- create conflict evidence;
- preserve conflict pairs during compression;
- expose unresolved conflicts explicitly in the task pack.

### Definition of done

- conflict benchmark passes target review metrics;
- context compression never removes one side of a known unresolved pair;
- trust/provenance remain visible.

---

## Phase 6 — semantic regression/failure investigation

### Change

- index historical failures/regressions/repairs;
- add similarity evidence to regression review;
- retrieve analogous prior incidents.

### Definition of done

- current deterministic regression evidence remains primary;
- semantic similarity never marks causation as confirmed;
- retrieved analogues improve investigation benchmark or human review quality.

---

## Phase 7 — relation arithmetic

### Change

- learn `FAILURE_TO_REPAIR`;
- evaluate held-out performance;
- optionally add other transition relations after success.

### Definition of done

- treatment beats ordinary similarity baseline;
- no cross-space arithmetic;
- no relation vector directly produces executable action;
- relation-guided result remains retrieved evidence only.

---

## Phase 8 — semantic predicates / Boolean composition

Only after calibration infrastructure is mature.

### Definition of done

- predicate benchmarks exist;
- thresholds are versioned;
- false-safe classifications are explicitly measured;
- deterministic policy remains final authority.

---

# 30. Exact existing-file change list

The following existing files should be modified.

| File | Required update |
|---|---|
| `tools/agentx_evolve/ARCHITECTURE.md` | Register `semantic/` as canonical capability |
| `tools/agentx_evolve/context/deduplication_engine.py` | Fix bad sort lambda; retain exact-dedupe responsibility |
| `tools/agentx_evolve/context/context_models.py` | Add semantic metadata fields to `ContextItem`; optional semantic conflict item kind |
| `tools/agentx_evolve/context/context_source_loader.py` | Support actual governed source payload/content, not path-only semantic representation |
| `tools/agentx_evolve/context/task_pack_builder.py` | Insert safe loading, semantic ranking, semantic dedupe, contradiction scan in correct order |
| `tools/agentx_evolve/context/priority_scorer.py` | Add hybrid semantic relevance feature |
| `tools/agentx_evolve/context/compression_planner.py` | Preserve unresolved semantic conflict items |
| `tools/agentx_evolve/context/summary_selector.py` | Select task-relevant extractive semantic excerpts |
| `tools/agentx_evolve/learning/outcome_models.py` | Add semantic fields to `MemoryCandidate`; optional semantic refs on `RegressionLink` |
| `tools/agentx_evolve/learning/learning_index.py` | Keep hashes; add lightweight semantic index metadata/space refs only |
| `tools/agentx_evolve/learning/outcome_reviewer.py` | Run semantic memory review before learning policy decision |
| `tools/agentx_evolve/learning/regression_linker.py` | Attach historical semantic analogue evidence without changing causal confirmation semantics |
| `tools/agentx_evolve/evaluation/evaluation_models.py` | Register semantic comparator constants |
| `tools/agentx_evolve/evaluation/comparator_engine.py` | Dispatch explicit semantic comparator types |
| package `__init__.py` files where required | Export stable new public adapters/types |

The following files should **not** have their authority logic changed:

| File/system | Rule |
|---|---|
| `tools/agentx_evolve/policy/policy_enforcer.py` | Keep deterministic; no model calls inside `enforce()` |
| `tools/agentx_evolve/security/safe_file_ops.py` | Reuse existing safe read/write boundary; do not bypass it |
| `tools/agentx_evolve/security/path_boundary_service.py` | Reuse existing sandbox policy/path rules |
| `shepherd/watch.ts` | Keep liveness/restart logic deterministic |

---

# 31. Exact new-file list

Create at minimum:

```text
tools/agentx_evolve/semantic/__init__.py
tools/agentx_evolve/semantic/service.py
tools/agentx_evolve/semantic/semantic_models.py
tools/agentx_evolve/semantic/semantic_space.py
tools/agentx_evolve/semantic/strict_provider.py
tools/agentx_evolve/semantic/semantic_index.py
tools/agentx_evolve/semantic/semantic_retrieval.py
tools/agentx_evolve/semantic/semantic_deduplication.py
tools/agentx_evolve/semantic/contradiction.py
tools/agentx_evolve/semantic/relation_learning.py
tools/agentx_evolve/semantic/semantic_evidence.py
tools/agentx_evolve/semantic/calibration.py
tools/agentx_evolve/semantic/predicate_engine.py
tools/agentx_evolve/semantic/cli.py

tools/agentx_evolve/context/repository_text_loader.py
tools/agentx_evolve/context/semantic_context_adapter.py

tools/agentx_evolve/learning/semantic_memory_review.py

tools/agentx_evolve/evaluation/semantic_comparators.py
```

Also add focused tests/fixtures following the repository's accepted test layout for:

```text
semantic_space
strict_provider
semantic_index
semantic_retrieval
semantic_deduplication
contradiction
relation_learning
repository_text_loader
semantic_context_adapter
semantic_memory_review
semantic_comparators
```

---

# 32. Minimum unit tests

The following cases are mandatory.

## Semantic space

- same profile → same `space_id`;
- one geometry field changes → different `space_id`;
- cross-space cosine raises;
- cross-space subtraction raises;
- zero vector rejected;
- NaN rejected;
- Inf rejected;
- wrong dimensions rejected.

## Strict provider

- provider unavailable;
- model mismatch;
- dimension mismatch;
- all-zero fallback returned by underlying provider;
- valid batch result;
- normalization is deterministic.

## Repository loader

- normal UTF-8 file;
- missing file;
- directory path;
- outside-repo path;
- oversized file;
- non-UTF-8/binary file;
- security decision ref preserved.

## Retrieval

- semantically relevant chunk outranks unrelated chunk;
- explicit target file is not accidentally discarded;
- blocked source never enters embedding call;
- provider unavailable produces deterministic fallback ranking.

## Semantic dedupe

- exact paraphrase;
- distinct-but-related pair;
- contradictory pair is not merged;
- independent provenance is preserved.

## Contradiction

- obvious contradiction;
- paraphrase;
- unrelated pair;
- scoped apparent contradiction;
- threshold boundary;
- missing calibration.

## Learning

- candidate near-duplicates existing approved memory;
- candidate conflicts with approved memory;
- candidate conflicts with blocked memory;
- semantic service unavailable;
- candidate still requires existing human/policy flow.

## Relation learning

- relation trained only on training pairs;
- held-out retrieval;
- cross-space training rejected;
- treatment compared against baseline;
- zero training pairs rejected.

---

# 33. Production acceptance criteria

Do not promote the semantic layer merely because examples look good.

At minimum:

### Context retrieval

Must beat or justify itself against the current selector on held-out historical tasks.

### Semantic deduplication

Must demonstrate low false-merge rate.

### Contradiction

Must be calibrated for the available human-review budget and report precision/recall.

### Durable learning

Must never auto-approve based on semantic evidence.

### Relation arithmetic

Must beat similarity-only retrieval on held-out data.

### Reliability

All semantic evidence must identify:

```text
space_id
model
provider
calibration_id where applicable
source refs/hashes
```

### Failure behavior

A provider failure must never be transformed into a valid-looking zero-vector semantic result.

### Governance

Policy and sandbox behavior must be identical or stricter than before the semantic upgrade.

---

# 34. What should explicitly be deferred

Do **not** add these in the first implementation:

- external vector database;
- approximate nearest-neighbor infrastructure;
- automatic policy authorization from embeddings;
- automatic execution from relation arithmetic;
- arbitrary vector-to-code decoding;
- hidden-state intervention/steering inside the primary LLM;
- global Procrustes transform as a claimed analogy fix;
- unsupervised contradiction threshold with no labeled calibration;
- automatic deletion of semantically similar durable memories;
- embedding Shepherd liveness state;
- embedding raw secrets or blocked source text.

These can be reconsidered only if the simpler local semantic layer proves useful.

---

# 35. Recommended first PR/change set

The first implementation change should be deliberately small enough to validate the architecture.

## PR 1: Semantic foundations + shadow retrieval

### Fix

- `context/deduplication_engine.py` sort bug.

### Add

- governed repository text loading;
- `semantic/` package;
- semantic-space identity;
- strict provider wrapper;
- SQLite semantic index;
- deterministic source chunking;
- task/chunk embedding;
- shadow semantic ranking;
- semantic evidence logs;
- initial retrieval benchmark.

### Do not yet enable

- semantic context ranking as production authority;
- semantic deduplication;
- contradiction blocking;
- learning admission changes;
- relation arithmetic.

### PR 1 success condition

For historical tasks:

```text
semantic/hybrid shadow retrieval
```

must show a measurable improvement in retrieving actually relevant files/chunks without violating source trust, redaction, sandbox, or token-budget constraints.

Once this passes, enable Phase 2.

---

# 36. Recommended second PR/change set

## PR 2: Hybrid context retrieval + semantic compression

Enable:

- semantic relevance in `priority_scorer.py`;
- semantic chunk selection;
- exact provenance retention;
- semantic representative excerpts.

Keep graceful fallback to current deterministic/lexical behavior.

---

# 37. Recommended third PR/change set

## PR 3: Semantic consistency for learning

Add:

- approved/blocked memory semantic index;
- semantic near-duplicate review;
- contradiction review;
- contradiction evidence refs;
- human-review escalation;
- memory semantic benchmark.

This is likely the highest strategic-value feature after context retrieval.

---

# 38. Recommended fourth PR/change set

## PR 4: Experience geometry

Add:

- historical failure/regression indexing;
- failure → repair relation model;
- held-out benchmark;
- relation-guided repair retrieval;
- no automatic execution.

Only retain this feature if it beats the ordinary semantic similarity baseline.

---

# 39. Final target behavior

When complete, Agent_X should behave approximately like this.

```text
User / task / failure / evidence
              │
              ▼
      deterministic source policy
              │
              ▼
        safe source loading
              │
              ▼
      injection filter / redaction
              │
              ▼
      ┌────────────────────────┐
      │ Semantic layer         │
      │                        │
      │ relevance              │
      │ near-duplicates        │
      │ contradictions         │
      │ historical analogues   │
      │ relation transforms    │
      │ calibrated predicates  │
      └───────────┬────────────┘
                  │
                  ▼
          semantic evidence
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
  context/learning      evaluation
        │                   │
        └─────────┬─────────┘
                  ▼
        deterministic policy
        validation / sandbox
          human approval
                  │
                  ▼
              action
```

The semantic layer makes Agent_X **more informed**, not more authoritative.

---

# 40. Final design principle

The upgrade should establish a strict separation:

```text
geometry answers:
    "What appears semantically related?"

contradiction models answer:
    "What appears mutually inconsistent?"

relation models answer:
    "What historical transformation appears analogous?"

deterministic Agent_X governance answers:
    "What is actually allowed, verified, promoted, remembered, or executed?"
```

That separation is the core requirement.

If implemented this way, embeddings become a reusable semantic substrate across Agent_X without weakening the governance architecture that already makes the project distinctive.
