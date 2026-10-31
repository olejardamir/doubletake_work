# AGENT_X Capability Distillation Layer — Direct Implementation Instructions

## Objective

Implement a new **Capability Distillation** stage in Agent_X between **Harvest** and **Assimilation**.

The purpose of this stage is to prevent harvested material from being translated directly into placeholder modules, arbitrary generated symbols, speculative features, or disconnected code.

The required pipeline is:

```text
KNOWLEDGE SOURCES
      ↓
HARVEST
      ↓
RAW HARVEST RECORDS
      ↓
CAPABILITY DISTILLATION
      ↓
CLEAN CAPABILITY CANDIDATES
      ↓
ASSIMILATION
      ↓
ARCHITECTURAL DECISION
      ↓
DESIGN / IMPLEMENTATION
      ↓
VERIFY / BENCHMARK
```

The implementation must make this separation real in runtime behavior. Do not merely rename existing steps or add descriptive wrappers.

---

# 1. Core Architectural Rule

**Harvest discovers information. It does not decide code structure.**

**Capability Distillation decides what technically meaningful capability, if any, exists inside a harvested record.**

**Assimilation decides how a surviving capability belongs in Agent_X.**

**Implementation writes code only after both stages have approved it.**

The following direct path must no longer be possible:

```text
HARVEST
   ↓
generated title / category / proposed symbol
   ↓
new Python module
```

Replace it with:

```text
HARVEST
   ↓
CAPABILITY DISTILLATION
   ↓
Gate A: meaningful capability?
   ↓
ASSIMILATION
   ↓
Gate B: real Agent_X capability gap?
   ↓
architectural owner
   ↓
implementation decision
   ↓
code
```

---

# 2. The Problem This Must Solve

Harvested material may contain:

- useful algorithms,
- useful architectural ideas,
- useful policies,
- useful heuristics,
- useful implementation techniques,
- irrelevant text,
- speculative claims,
- arbitrary metrics,
- malformed labels,
- generated names,
- marketing language,
- unrelated concepts accidentally combined into one record,
- concepts Agent_X already implements,
- concepts that are legitimate but not currently needed,
- ideas with no measurable behavioral effect.

Agent_X must not code all of these indiscriminately.

A high-ranked Harvest record is **not** automatically an implementation ticket.

A Harvest record is evidence requiring interpretation.

---

# 3. Required New Subsystem

Implement a subsystem conceptually named:

```text
Capability Distillation
```

Do not assume a filesystem path before repository reconnaissance.

Before creating files:

1. inspect the current Agent_X repository;
2. identify the existing Harvest output boundary;
3. identify the existing Assimilation input boundary;
4. identify schemas/models already used for harvested discoveries;
5. identify persistence mechanisms;
6. identify orchestration paths;
7. identify current code-generation triggers;
8. integrate with the existing owners whenever possible.

Do not create a parallel architecture when an existing owner can be extended cleanly.

---

# 4. Required Distillation Operations

Every Harvest record passed to Capability Distillation must go through the following operations.

## 4.1 Decompose

Split compound Harvest records into independent technical ideas.

Example:

```text
"Query-aware re-rank × Undo/redo ledger"
```

must become at least:

```text
Capability candidate A:
Query-aware reranking

Capability candidate B:
Reversible mutation history
```

Do not preserve accidental coupling simply because Harvest emitted the ideas in one record.

A single Harvest record may therefore produce:

```text
0..N capability candidates
```

Zero is valid and expected.

---

## 4.2 Remove Contamination

Strip material that does not contribute to a defensible engineering decision.

Examples include:

- fictional framing,
- "alien technology",
- vague claims of superiority,
- "novel domain leadership",
- arbitrary generated names,
- arbitrary module names,
- generated handler names,
- unsupported percentages,
- unsupported accuracy thresholds,
- unexplained numeric targets,
- category labels that do not map to real Agent_X architecture,
- prose that cannot be connected to inputs, mechanism, outputs, or measurable behavior.

Do not silently treat contaminated text as technical requirements.

Preserve relevant source evidence separately if traceability requires it, but do not allow contamination to become implementation authority.

---

## 4.3 Normalize

Convert each surviving idea into a technology-neutral capability description.

A normalized capability must describe, when applicable:

```text
Capability
Problem addressed
Mechanism
Inputs
Outputs
Dependencies
Constraints
Expected behavioral effect
Evidence
Unknowns
Possible measurement
```

Example:

```text
Capability:
Query-aware retrieval reranking

Problem:
Retrieved candidates may be relevant globally but weakly aligned with the
current assimilation objective.

Inputs:
- current objective/focus
- retrieved candidates
- existing candidate scores
- candidate embeddings, if available

Mechanism:
Combine normalized base retrieval relevance with objective similarity,
then perform deterministic reranking.

Outputs:
- deterministically reordered candidates
- optional component scores for auditability

Expected behavioral effect:
More objective-relevant candidates appear in top-K retrieval results.

Possible measurement:
- NDCG@K
- MRR
- Recall@K
- downstream assimilation acceptance rate
```

At this stage, do **not** invent:

```text
handle_cross_modal_18()
cross_modal_18.py
frontier_capability_22.py
```

File names and symbols are architectural decisions, not Harvest decisions.

---

## 4.4 Classify

Classify the normalized candidate by implementation nature.

Minimum supported classes should include:

```text
ALGORITHM
ARCHITECTURE
POLICY
HEURISTIC
DATA_TRANSFORMATION
MODEL_OR_PROMPT_BEHAVIOR
UI_OR_WORKFLOW
INTEGRATION
OBSERVABILITY
TEST_OR_BENCHMARK
NON_ACTIONABLE
```

The purpose of classification is not cosmetic.

It must influence evaluation and downstream handling.

For example:

- an algorithm should require algorithmic inputs, mechanism, outputs, and measurable behavior;
- an architecture proposal should require ownership, state/lifecycle implications, and integration rationale;
- a policy proposal should not automatically generate a Python module;
- a test/benchmark improvement should route to verification infrastructure rather than capability implementation.

---

## 4.5 Validate Technical Substance

Determine whether the candidate represents a real technical capability.

The evaluator must explicitly answer:

```text
1. What actual problem does this solve?
2. What observable behavior changes if implemented?
3. What are its inputs?
4. What are its outputs?
5. What is the mechanism?
6. Who or what consumes the output?
7. Can success or failure be measured?
8. Is the idea internally coherent?
9. Is it separable from unrelated ideas?
10. Is there enough evidence to justify architectural investigation?
```

A candidate must not advance merely because it contains technical vocabulary.

---

# 5. Gate A — Capability Validity Gate

Capability Distillation must end with **Gate A**.

Gate A asks:

> Is there a coherent, technically meaningful capability here that warrants comparison with the current Agent_X architecture?

Allowed Gate A decisions:

```text
PASS
REJECT
DEFER_FOR_EVIDENCE
```

A rejected item must not reach implementation planning.

Examples of rejection reasons:

```text
NO_TECHNICAL_MECHANISM
NO_DEFINED_BEHAVIORAL_DELTA
UNSUPPORTED_CLAIM
DUPLICATE_TEXT_ONLY
ACCIDENTAL_CONCEPT_COMBINATION
NON_OPERATIONAL_GOAL
MARKETING_LANGUAGE
INVALID_OR_MEANINGLESS_CLASSIFICATION
NO_CONSUMER
NO_MEASURABLE_EFFECT
```

The system must record why a capability was rejected.

A rejected idea should disappear from the active implementation queue while remaining traceable in audit/history if Agent_X already maintains provenance.

---

# 6. Distillation Must Not Determine Final Novelty

Passing Gate A does **not** mean the capability is missing from Agent_X.

That determination belongs to Assimilation after repository reconnaissance.

Capability Distillation answers:

```text
"Is this a real technical idea?"
```

Assimilation answers:

```text
"Does Agent_X need to change because of it?"
```

Keep these responsibilities separate.

---

# 7. Required Assimilation Changes

Update Assimilation so it consumes **distilled capability candidates**, not raw Harvest implementation suggestions.

Assimilation must perform repository-grounded comparison against each surviving candidate.

For every candidate, determine:

```text
Current Agent_X equivalent
Existing architectural owner
Existing behavior
Capability gap
Overlap
Conflicts
Reusable implementation
Affected runtime path
Expected behavioral delta
Verification path
```

Assimilation must not trust a Harvest-proposed filename, module, handler, symbol, class, or package.

---

# 8. Gate B — Agent_X Need / Architectural Gap Gate

After architectural comparison, enforce **Gate B**.

Gate B asks:

> Does Agent_X require a real change to gain this capability or improvement?

Allowed final dispositions:

```text
IMPLEMENT
MERGE
EXPERIMENT
NO_CHANGE
DEFER
REJECT
```

Definitions:

## IMPLEMENT

Use only when:

- a real capability gap exists;
- the behavior is useful;
- the owner is known;
- the design is sufficiently defined;
- verification is possible.

## MERGE

Use when:

- the capability is partially present;
- existing code should be extended;
- creating a new standalone subsystem would duplicate ownership.

## EXPERIMENT

Use when:

- the idea is technically credible;
- benefit is uncertain;
- a bounded benchmark or prototype can determine value.

Experimental code must not silently become permanent production architecture.

## NO_CHANGE

Use when:

- Agent_X already provides the capability adequately;
- the harvested idea offers no demonstrated improvement.

## DEFER

Use when:

- the idea is legitimate;
- current Agent_X requirements do not justify implementation;
- required dependencies/evidence are missing.

## REJECT

Use when:

- the idea is incompatible,
- harmful,
- structurally incoherent,
- or fails architectural review.

---

# 9. Mandatory Behavioral Delta

No candidate may proceed to production implementation without a concrete **behavioral delta**.

Required format:

```text
BEFORE:
<current behavior>

AFTER:
<proposed behavior>

EXPECTED OBSERVABLE CHANGE:
<what becomes measurably different>

MEASUREMENT:
<how the difference will be verified>
```

Example:

```text
BEFORE:
Retrieval candidates remain ordered only by the current retrieval score.

AFTER:
Candidates are reranked using normalized retrieval relevance plus
objective similarity.

EXPECTED OBSERVABLE CHANGE:
Candidates more relevant to the current assimilation objective move higher
in top-K results.

MEASUREMENT:
Compare baseline vs reranked retrieval using NDCG@10, MRR, Recall@K,
and/or downstream assimilation acceptance rate.
```

If a meaningful BEFORE → AFTER change cannot be stated, production coding must not proceed.

---

# 10. Algorithmic Substance Requirement

Agent_X must distinguish between **real algorithmic implementation** and **placeholder/bucket implementation**.

A valid algorithmic proposal should identify:

```text
inputs
state, if any
transformations
decision rule
scoring/ranking logic
constraints
complexity/bounds where relevant
outputs
failure/fallback behavior
determinism requirements
measurement
```

Example of a legitimate reranking mechanism:

```python
base = normalize(candidate.base_score)
focus = cosine_similarity(focus_embedding, candidate.embedding)

candidate.final_score = (
    base_weight * base
    + focus_weight * focus
)
```

followed by deterministic ordering:

```python
ranked = sorted(
    candidates,
    key=lambda c: (-c.final_score, c.original_position),
)
```

The implementation must account for score-scale compatibility, missing embeddings, stable ties, weight bounds, top-K behavior, and deterministic fallbacks.

Do not accept an implementation such as:

```python
def handle_query_rerank(record):
    return {
        "status": "processed",
        "category": "query_reranking",
    }
```

as completion of an algorithmic capability.

That is a placeholder.

---

# 11. No Placeholder Module Rule

Do not create a new file simply because a Harvest record exists.

The following pattern is prohibited unless repository analysis proves that the new module is the correct architectural owner:

```text
tools/agentx_evolve/<harvest_category>/
    <generated_harvest_title>.py
```

The following are also prohibited as automatic outputs:

```text
handle_<harvest_label>()
process_<generated_id>()
analyze_record()
dispatch_record()
```

when they merely wrap, tag, serialize, or acknowledge the record without implementing the actual required behavior.

New modules must be justified by architectural ownership, not record identity.

---

# 12. Merge-First Rule

When a surviving capability belongs to an existing runtime owner:

**modify the owner.**

Do not add a parallel capability bucket.

Example:

```text
Harvest finds:
query-aware reranking

Repository analysis finds:
existing retrieval/ranking component

Correct result:
extend the existing ranking component
```

Not:

```text
tools/agentx_evolve/cross_modal/query_aware_rerank_18.py
```

The new code should live where the runtime responsibility already exists unless a deliberate architectural refactor proves a new owner is necessary.

---

# 13. Evidence Model

Maintain separation between:

```text
SOURCE CLAIM
DISTILLED INTERPRETATION
AGENT_X ARCHITECTURAL FINDING
IMPLEMENTATION DECISION
VERIFICATION RESULT
```

Do not collapse these into a single generated narrative.

A useful internal record should preserve provenance such as:

```text
source_record_id
source_type
source_excerpt_or_reference
distilled_capability_id
evidence_strength
interpretation_notes
architecture_findings
disposition
verification_result
```

Use existing Agent_X provenance structures where possible.

Do not introduce redundant storage if equivalent structures already exist.

---

# 14. Unsupported Metrics

Harvested numeric claims must not become acceptance criteria automatically.

Example:

```text
"cross-modal grounding accuracy ≥ 0.8"
```

must be rejected as an implementation criterion unless all of the following exist:

```text
metric definition
evaluation corpus
ground truth / labels
baseline
test procedure
sample size or evaluation scope
reason the threshold is appropriate
```

If these do not exist, preserve the number only as an unverified source claim.

Do not code to arbitrary generated thresholds.

---

# 15. Compound-Idea Splitting

Implement explicit detection/handling for records that combine unrelated capabilities.

Signals may include:

- "X × Y" titles,
- multiple independent mechanisms,
- unrelated architectural domains,
- separate input/output chains,
- separate owners,
- separate verification criteria.

Do not assume one LLM-generated title defines one capability.

A record can produce multiple candidates and each candidate must receive its own Gate A and Gate B decisions.

---

# 16. Example — Required Treatment of a Noisy Harvest Record

Given a Harvest record similar to:

```text
Title:
Query-aware re-rank × Undo/redo ledger

Domain:
cross_modal

Focus:
Advanced agentic AI from alien technology...

Proposed symbol:
handle_cross_modal_18

Acceptance:
cross-modal grounding accuracy ≥0.8
novel domain leadership demonstrated
```

Capability Distillation should produce approximately:

```text
Candidate A:
Query-aware retrieval reranking

Class:
ALGORITHM

Gate A:
PASS

Mechanism:
Use current objective similarity to rerank retrieved candidates.

Useful evidence:
Potentially meaningful information-retrieval improvement.

Discarded contamination:
- cross_modal label unless independently supported
- alien-technology framing
- handle_cross_modal_18
- unsupported 0.8 threshold
- novel-domain-leadership statement
```

and:

```text
Candidate B:
Reversible mutation journal / undo-redo capability

Class:
ARCHITECTURE

Gate A:
PASS

Mechanism:
Persist sufficient reversible or compensating state for governed mutation
rollback and replay.

Unknowns:
- whether Agent_X requires general rollback
- which mutations are reversible
- transactional boundaries
- external side effects
```

Assimilation may then decide:

```text
Candidate A:
EXPERIMENT or IMPLEMENT/MERGE after repository analysis

Candidate B:
DEFER unless an actual rollback/audit requirement exists
```

The original combined record must not become one generated Python file.

---

# 17. Irreversible Operations

Do not accept a blanket claim that every mutation can support exact inverse operations.

Classify mutation types, for example:

```text
REVERSIBLE
COMPENSATABLE
SNAPSHOT_RESTORABLE
IRREVERSIBLE
EXTERNAL_SIDE_EFFECT
```

Examples:

Potentially reversible:

```text
config A -> B
rename
local add/remove with retained state
metadata change
```

Potentially non-reversible or only compensatable:

```text
send email
external API side effect
publish remote artifact
spend credits
delete external resource
trigger third-party workflow
```

Any future undo/redo architecture must represent this distinction explicitly.

---

# 18. Required Data Contracts

Use existing Agent_X model patterns where possible.

Conceptually, the Distillation stage needs structures equivalent to:

```python
class DistilledCapability:
    id: str
    source_record_ids: tuple[str, ...]
    name: str
    capability_type: str
    problem: str
    mechanism: str
    inputs: tuple[str, ...]
    outputs: tuple[str, ...]
    dependencies: tuple[str, ...]
    constraints: tuple[str, ...]
    expected_behavioral_effect: str
    evidence: tuple[EvidenceRef, ...]
    unknowns: tuple[str, ...]
    measurements: tuple[str, ...]
    gate_a_decision: str
    gate_a_reasons: tuple[str, ...]
```

Assimilation should add or associate data equivalent to:

```python
class AssimilationDisposition:
    capability_id: str
    current_owner: str | None
    existing_behavior: str
    capability_gap: str
    integration_points: tuple[str, ...]
    behavioral_delta_before: str
    behavioral_delta_after: str
    expected_observable_change: str
    verification_plan: tuple[str, ...]
    disposition: str
    disposition_reasons: tuple[str, ...]
```

These are conceptual contracts.

Adapt them to the actual repository architecture rather than copying them blindly.

---

# 19. Determinism and Boundedness

The new stage must follow existing Agent_X deterministic/bounded execution expectations.

Where practical:

- deterministic ordering;
- stable identifiers;
- bounded candidate counts;
- bounded decomposition;
- bounded evidence attachment;
- explicit confidence;
- no hidden infinite recursive decomposition;
- no import-time side effects;
- reproducible decisions when inputs/configuration are unchanged.

If an LLM is used for semantic decomposition/normalization, its output must be validated against a strict schema and downstream gates must not trust free-form prose blindly.

---

# 20. Human-Readable Output

Capability Distillation must produce human-readable review output.

A user should be able to inspect:

```text
What Harvest found
What was discarded
What capability was extracted
Why it is technically meaningful
What remains uncertain
Whether it passed Gate A
Where Assimilation thinks it belongs
Whether Agent_X needs a change
Final disposition
```

Do not make this information available only in embeddings or opaque database fields.

---

# 21. Harvest Contract Changes

Refactor Harvest output so it is primarily an **evidence/discovery record**, not a coding ticket.

Prefer fields equivalent to:

```text
Discovery
Source
Observed technique
Observed mechanism
Claimed benefit
Original context
Constraints
Evidence
Confidence
Unknowns
```

Remove or demote implementation-authoritative fields such as:

```text
Proposed symbol
Generated module path
Generated handler name
Generated package
Mandatory coding contract derived only from Harvest
```

If compatibility requires retaining old fields temporarily, mark them explicitly as:

```text
UNTRUSTED_SUGGESTION
```

and ensure Capability Distillation/Assimilation never treat them as implementation authority.

---

# 22. Existing Harvest Producers

Apply the same contract to all current/future knowledge producers, including where applicable:

```text
Balancer
Gap Filler
Frontier Discovery
patent ingestion
paper ingestion
repository mining
MCP-derived knowledge
external technical sources
embedding-driven discovery
```

These systems should produce discoveries/evidence.

They should not independently create production code ownership.

---

# 23. Coding Trigger

There must be exactly one controlled transition from architectural approval into coding.

Conceptually:

```text
if gate_a_passed
and gate_b_disposition in {IMPLEMENT, MERGE}
and architectural_owner_resolved
and behavioral_delta_defined
and verification_plan_defined:
    implementation_allowed = True
else:
    implementation_allowed = False
```

Do not literally implement this exact snippet if Agent_X has an existing governance state machine. Integrate the rule into the correct governance mechanism.

No alternative path may bypass these requirements.

---

# 24. EXPERIMENT Handling

`EXPERIMENT` must not be treated as equivalent to `IMPLEMENT`.

An experiment should define:

```text
hypothesis
baseline
candidate change
dataset/workload
metric
success criterion
failure criterion
bounded runtime
cleanup path
```

Experimental outputs should either:

```text
PROMOTE_TO_IMPLEMENT
NO_CHANGE
DEFER
REJECT
```

after evidence is collected.

Avoid permanent accumulation of abandoned experiment modules.

---

# 25. Cleanup of Existing Harvest-Generated Clutter

After implementing the new pipeline, inspect existing code produced by prior Harvest/Assimilation flows.

Do **not** mass-delete files solely because their names look generated.

For each suspicious artifact:

1. identify whether it is imported or executed;
2. identify whether it owns real runtime behavior;
3. identify whether the behavior duplicates an existing owner;
4. identify tests;
5. identify provenance;
6. identify whether it is only a placeholder/record processor;
7. classify it as:
   - KEEP,
   - MERGE,
   - REFACTOR,
   - REMOVE,
   - REVIEW.

Only remove code when repository evidence supports removal.

Preserve compatibility/migrations where required.

---

# 26. Tests

Add tests that prove the architecture, not only serialization.

Minimum test coverage should include:

## Distillation decomposition

One compound record produces independent candidates.

## Noise rejection

Nonsensical or promotional text does not become a capability.

## Unsupported metric handling

An arbitrary numeric target remains an unverified claim and does not become an acceptance criterion.

## Zero-candidate outcome

A Harvest record may legitimately produce no implementation candidate.

## Gate A rejection

A record with no mechanism or behavioral delta cannot proceed.

## Existing-capability outcome

A valid distilled idea can still produce `NO_CHANGE` after Assimilation discovers existing functionality.

## Merge-first behavior

A capability with an existing owner is routed to extension/merge rather than a generated standalone module.

## Coding bypass prevention

Raw Harvest records cannot trigger implementation directly.

## Behavioral-delta requirement

Implementation is blocked when BEFORE/AFTER/MEASUREMENT are missing.

## Determinism

Equivalent inputs produce stable normalized outputs/ordering where deterministic behavior is expected.

## Provenance

A distilled candidate can be traced back to its Harvest source.

## Multiple disposition outcomes

Exercise:

```text
IMPLEMENT
MERGE
EXPERIMENT
NO_CHANGE
DEFER
REJECT
```

---

# 27. Verification of Real Algorithms

When a capability is classified as `ALGORITHM`, tests must verify actual algorithmic behavior.

Do not consider the feature complete merely because:

- a handler exists,
- a record is parsed,
- a status is returned,
- a category is assigned,
- an object is persisted.

For a reranker, for example, verify cases such as:

```text
more focus-relevant candidate is promoted
zero focus weight preserves base ranking
equal scores preserve deterministic original order
missing embeddings use defined fallback
top-K is respected
invalid weights are rejected or normalized according to contract
score normalization behaves as defined
```

Use domain-appropriate metrics for benchmark tests.

---

# 28. Repository Reconnaissance Is Mandatory

Before implementation, inspect the full relevant call graph.

Do not guess file locations.

At minimum identify:

```text
Harvest producers
Harvest persistence
Harvest orchestration
current review/gating stages
Assimilation entrypoint
Assimilation models
implementation planning
code generation/execution trigger
verification
UI status/reporting
```

Trace both direct and transitive flows where necessary.

The goal is to modify the actual runtime path, not add an unused subsystem.

---

# 29. UI / Observability

If Agent_X exposes Harvest/Assimilation state in the UI, add Distillation visibility using the existing UI architecture.

At minimum make the lifecycle understandable:

```text
HARVESTED
DISTILLING
DISTILLED
GATE_A_REJECTED
READY_FOR_ASSIMILATION
ASSIMILATING
NO_CHANGE
DEFERRED
EXPERIMENT
APPROVED_FOR_IMPLEMENTATION
MERGED
IMPLEMENTED
VERIFIED
FAILED
```

Adapt names to existing state conventions.

Do not introduce redundant state systems if one already exists.

---

# 30. Failure Semantics

A Distillation failure must not default to implementation.

Use fail-closed behavior.

Examples:

```text
schema invalid -> hold/reject
architecture owner unresolved -> defer/review
behavioral delta missing -> block implementation
verification plan missing -> block production implementation
source evidence unavailable -> lower confidence/defer
LLM output malformed -> retry boundedly or fail closed
```

Never interpret evaluator failure as approval.

---

# 31. No Cosmetic Completion

The task is not complete if the implementation only adds:

- a `CapabilityDistiller` class,
- schemas,
- database rows,
- logging,
- UI status,
- prompt text,

while raw Harvest records can still reach coding through an old path.

You must prove that all production implementation paths are gated by the new architecture.

Search for bypasses.

Remove or refactor bypasses.

Add tests against bypasses.

---

# 32. Expected End-State

The end-state should behave like this:

```text
Raw Harvest record
    ↓
decompose
    ↓
remove contamination
    ↓
normalize technical candidates
    ↓
classify
    ↓
Gate A
    ├─ reject → archive/audit
    ├─ defer  → evidence queue
    └─ pass
         ↓
      Assimilation
         ↓
      repository comparison
         ↓
      architectural owner
         ↓
      Gate B
         ├─ NO_CHANGE
         ├─ DEFER
         ├─ REJECT
         ├─ EXPERIMENT
         ├─ MERGE
         └─ IMPLEMENT
                    ↓
             behavioral delta
                    ↓
             verification plan
                    ↓
              design/code
                    ↓
                verify
```

---

# 33. Primary Design Principle

The implementation must enforce:

> **Harvest discovers. Distillation extracts. Assimilation decides. Implementation changes behavior. Verification proves it.**

No stage should silently absorb the responsibilities of all the others.

---

# 34. Definition of Done

This work is complete only when all of the following are true:

- [ ] Capability Distillation exists as a real runtime stage between Harvest and Assimilation.
- [ ] Raw Harvest records cannot directly authorize coding.
- [ ] Compound discoveries can be split into multiple capability candidates.
- [ ] Noisy/irrelevant material can be discarded without discarding useful underlying ideas.
- [ ] A Harvest record may produce zero candidates.
- [ ] Harvest-proposed filenames and symbols have no implementation authority.
- [ ] Gate A rejects non-substantive ideas.
- [ ] Assimilation compares surviving capabilities against the real repository.
- [ ] Gate B distinguishes IMPLEMENT, MERGE, EXPERIMENT, NO_CHANGE, DEFER, and REJECT.
- [ ] Existing architectural owners are preferred over new generated modules.
- [ ] A behavioral delta is mandatory before production coding.
- [ ] A verification plan is mandatory before production coding.
- [ ] Algorithm-class candidates must result in real algorithmic behavior, not placeholder handlers.
- [ ] Unsupported numeric claims do not become acceptance criteria automatically.
- [ ] Provenance from source → distilled capability → disposition → implementation is preserved.
- [ ] Failures fail closed rather than defaulting to implementation.
- [ ] Old bypass paths from Harvest directly to code are removed or gated.
- [ ] Tests prove the gates cannot be bypassed.
- [ ] Existing suspicious Harvest-generated artifacts are inventoried and classified safely.
- [ ] The UI/logging makes the new lifecycle inspectable if equivalent lifecycle visibility already exists.
- [ ] No unused parallel subsystem is added.
- [ ] All modified code follows existing Agent_X conventions and remains deterministic, bounded, testable, and side-effect safe on import.

---

# 35. Final Implementation Instruction

Do not implement this document as terminology layered on top of the current pipeline.

Change the actual Agent_X execution flow so the following becomes structurally impossible:

```text
Harvest found something
        ↓
therefore create code
```

The only valid reasoning chain is:

```text
Harvest found something
        ↓
Distillation extracted a coherent capability
        ↓
Gate A approved technical substance
        ↓
Assimilation proved a real Agent_X gap or improvement opportunity
        ↓
Gate B approved IMPLEMENT or MERGE
        ↓
the correct architectural owner was identified
        ↓
a concrete behavioral delta and verification plan were defined
        ↓
code changed real runtime behavior
        ↓
tests/benchmarks proved the change
```

Anything else must be rejected, deferred, treated as an experiment, or recorded as no change.
