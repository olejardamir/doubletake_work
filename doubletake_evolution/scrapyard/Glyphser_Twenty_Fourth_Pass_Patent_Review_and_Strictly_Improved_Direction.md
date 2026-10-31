# Glyphser Patent Direction
## Twenty-Fourth-Pass Conflict Review, Corrected Risk Scores, Patentability Score, and Strictly Improved Replacement Architecture

**Review date:** July 17, 2026  
**Direction re-examined:** *Obligation-Isolated Ephemeral State Domains with Dependency-Minimal Confluence Closure*  
**Prior protocol name:** **Glyphser State-Confluence Machine — GSCM**  
**Replacement direction:** *Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization*  
**Suggested replacement protocol name:** **Glyphser Acceptance-Code Machine — GACM**

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the exact claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation:** This pass used public patent-index searches, direct patent records, the references accumulated in the preceding Glyphser reviews, and technical literature categories identified through those records. A paid full-corpus novelty report and a fully configured official-office patent connector were not available in this session. The search cannot exclude unpublished applications, unindexed records, non-English prior art, source code, standards work, academic papers, or confidential commercial implementations.
>
> **Verification correction:** The twenty-third-pass document referred to **US-12645555-B1**. That record was not independently located or verified during this pass and is therefore **not relied upon** in the present conflict analysis or scoring. Counsel should independently confirm whether the number, title, and cited subject matter are correct before it appears in any filing memorandum.
>
> **Score correction rule:** The twenty-third-pass replacement received extremely optimistic scores, including 10.00/10 enforcement and 0.15/10 design-around risk. The deeper search found material active conflicts in execution isolation, state refresh, stateless test agents, dependency extraction, redundant-edge removal, ordered and unordered test execution, rollback, handle revocation, and static partial-order reduction. The strict-improvement comparison therefore uses the **corrected GSCM scores produced by this deeper review**, not the superseded optimistic scores.

---

# 1. Score definitions

All scores use a **0–10 scale**.

| Category | Meaning of a higher score |
|---|---|
| Novelty risk | Worse: greater likelihood that one reference anticipates the proposed claim |
| Obviousness risk | Worse: greater likelihood that an examiner can combine known references |
| Subject-matter/technicality risk | Worse: greater risk of being treated as abstract, administrative, predominantly mathematical, or insufficiently tied to a technical improvement |
| Freedom-to-operate risk | Worse: greater likelihood that an implementation may practice active third-party claims |
| Ease of enforcing the patent | Better: easier to detect, test, claim-chart, and prove infringement |
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while preserving substantially the same commercial value |
| Patentability score | Better: comparative composite of likely novelty, inventive-step strength, technical character, claim coherence, enforceability, and practical filing strength; target **10.00/10** |

The scores are comparative engineering judgments, not legal conclusions or statistical probabilities.

---

# 2. Executive conclusion

The twenty-third-pass GSCM direction should not remain the principal Glyphser patent nucleus.

GSCM proposed:

- committing a manifest of mutable and external verifier state;
- constructing one common baseline state root;
- executing every mandatory obligation in a separate ephemeral state domain;
- issuing domain-bound resource handles;
- permitting one typed result export;
- proving restoration, destruction, or unreachability of modified state;
- proving no residual mutable state, handles, aliases, or undeclared I/O;
- constructing a dependency graph among obligation results;
- removing redundant dependency edges;
- proving each retained edge necessary;
- proving that incomparable result operations commute;
- proving all valid topological orders yield the same acceptance state;
- issuing a public confluence-closed acceptance object.

The deeper search shows that the central GSCM mechanisms are substantially occupied by active and historical patents and mature technical literature.

The most damaging verified references include:

- **[US-11882184-B2 — Reuse of Execution Environments While Guaranteeing Isolation in Serverless Computing](https://patents.google.com/patent/US11882184B2/en)**
  - refreshes or swaps state memory to provide isolation between executions;
  - expressly addresses tainted variables, filesystems, unpredictable starting state, and reuse of execution environments;
  - belongs to an active continuation family.

- **[US-9378120-B2 — Automated Test Execution Plan Derivation System and Method](https://patents.google.com/patent/US9378120B2/en)**
  - extracts dependencies among test cases;
  - constructs a directed dependency graph;
  - identifies independent components;
  - schedules dependent and independent tests while preserving semantics;
  - discusses state resets and common initial-state assumptions.

- **[US-10423521-B2 — Automatically Executing Stateless Transactions with Data Dependency in Test Cases](https://patents.google.com/patent/US10423521B2/en)**
  - uses stateless test execution;
  - gives agents their own execution state;
  - supports explicit dependency data passed between test steps.

- **[US-10545857-B2](https://patents.google.com/patent/US10545857B2/en) and [US-11341031-B2](https://patents.google.com/patent/US11341031B2/en) — Controlling Executions of Synchronous and/or Non-Synchronous Operations with Asynchronous Messages**
  - distinguish independent steps executable in any order from dependent steps requiring a specific order;
  - maintain execution state and dependency-driven sequencing.

- **[US-11822962-B2 — Techniques for Execution Orchestration with Topological Dependency Relationships](https://patents.google.com/patent/US11822962B2/en)**
  - creates a topologically ordered dependency graph;
  - removes redundant dependencies;
  - executes according to the resulting order.

- **[US-6295515-B1 — Static Partial Order Reduction](https://patents.google.com/patent/US6295515B1/en)**
  - defines independent transitions by enabledness and commutativity;
  - treats two transitions as independent when either order reaches the same state;
  - reduces state-space exploration using those independence relations.

- **[US-7836170-B2 — Suspension and Reinstatement of Reference Handles](https://patents.google.com/patent/US7836170B2/en)**
  - manages assignable, suspended, reinstated, and released resource handles;
  - weakens broad claims to lease-bound handles and post-close invalidity.

- **[US-10887346-B2 — Application-Level Sandboxing](https://patents.google.com/patent/US10887346B2/en)**
  - creates isolated process and namespace environments with restricted resource access.

- **[US-7467378-B1 — System State Rollback After Modification Failure](https://patents.google.com/patent/US7467378B1/en)** and **[US-11829796-B2 — Automated Rollback](https://patents.google.com/patent/US11829796B2/en)**
  - create restore points, compare state, and roll systems back toward prior states.

The GSCM inventive centre can therefore be characterized as:

```text
common initial state
    +
per-task isolated or stateless execution
    +
revocable resource access
    +
state reset or destruction
    +
dependency graph
    +
redundant-edge removal
    +
commutativity of unordered operations
    +
all-order equivalence
    +
public acceptance artifact
```

The first eight elements are mature. Adding a certificate-verification label and public artifact is unlikely to carry broad novelty or inventive step.

## Replacement decision

Retire this as the principal filing direction:

> **Obligation-Isolated Ephemeral State Domains with Dependency-Minimal Confluence Closure**

Retain only as optional embodiments:

- fresh or isolated obligation execution;
- state reset and residual-state checks;
- explicit dependency declarations;
- order-randomization tests;
- commutativity checks;
- confluence evidence.

Proceed instead with:

# **Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization**

The replacement solves a narrower and more distinctive technical problem:

> Conventional verifiers reduce each mandatory obligation to an ordinary Boolean, enum, or log record and later aggregate those independent values. That structure permits a controller defect, malicious integration, or serialization error to omit one result, duplicate another, substitute a result from a different obligation, replay a result from another subject or run, relabel diagnostic output as acceptance evidence, or generate a public receipt after a separate acceptance decision. How can the final accepted representation itself be made structurally invalid unless the exact run-specific multiset of mandatory obligation computations contributed once, under the correct obligation identities, evidence commitments, comparator identities, subject root, and outcome classes—and how can the resulting defect be publicly localized to the affected obligation rather than merely producing a generic signature failure?

GACM answers by compiling each verification profile and run nonce into a **nonseparable acceptance code**. Each mandatory obligation receives a unique code position and generator contribution. The corresponding comparator is coupled to a contribution encoder that emits a run-specific symbol only after evaluating the obligation against committed evidence. The final accepted certificate is represented by a canonical codeword—not by a standalone pass bit plus an optional receipt.

Missing, duplicated, substituted, replayed, cross-subject, cross-profile, cross-comparator, or diagnostic-only contributions produce a noncanonical word with a nonzero or wrong-target syndrome. The public syndrome localizes the affected obligation lane within a declared detection bound. A downstream decoder derives the usable acceptance capability only from the canonical codeword.

The principal claim does **not** require:

- per-obligation sandboxes;
- state rollback;
- dependency graphs;
- partial-order reduction;
- topological sorting;
- execution of every ordering;
- a threshold secret-sharing scheme;
- attribute-based encryption;
- access-control key release;
- blockchain;
- a generic cryptographic accumulator;
- a particular error-correcting code;
- a trusted execution environment;
- a conformance certificate registry;
- a standalone PASS/FAIL receipt.

---

# 3. Revised scores

## 3.1 GSCM — corrected after deeper conflict review

### Obligation-Isolated Ephemeral State Domains with Dependency-Minimal Confluence Closure

| Category | Corrected score |
|---|---:|
| **Novelty risk** | **6.25/10** |
| **Obviousness risk** | **8.75/10** |
| **Subject-matter/technicality risk** | **0.75/10** |
| **Freedom-to-operate risk** | **6.50/10** |
| **Ease of enforcing the patent** | **5.75/10** |
| **Ease for competitors to design around** | **8.25/10** |
| **Patentability score** | **3.35/10** |

## 3.2 Replacement direction

### Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization

| Category | Replacement score |
|---|---:|
| **Novelty risk** | **1.75/10** |
| **Obviousness risk** | **3.25/10** |
| **Subject-matter/technicality risk** | **0.15/10** |
| **Freedom-to-operate risk** | **1.75/10** |
| **Ease of enforcing the patent** | **9.75/10** |
| **Ease for competitors to design around** | **1.50/10** |
| **Patentability score** | **9.15/10** |

## 3.3 Strict improvement check

| Category | Corrected GSCM | GACM replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 6.25 | 1.75 | **Yes — 4.50 lower** |
| Obviousness risk | 8.75 | 3.25 | **Yes — 5.50 lower** |
| Subject-matter/technicality risk | 0.75 | 0.15 | **Yes — 0.60 lower** |
| Freedom-to-operate risk | 6.50 | 1.75 | **Yes — 4.75 lower** |
| Ease of enforcing | 5.75 | 9.75 | **Yes — 4.00 higher** |
| Ease of design-around | 8.25 | 1.50 | **Yes — 6.75 lower** |
| Patentability score | 3.35 | 9.15 | **Yes — 5.80 higher** |

**Every requested category improves. None remains unchanged.**

## 3.4 Patentability target

| Measure | Score |
|---|---:|
| Target patentability score | **10.00/10** |
| Replacement patentability score | **9.15/10** |
| Remaining gap | **0.85** |

A literal 10.00/10 conclusion would be unsupported without a professional full-corpus search, non-patent-literature search, prosecution-history review, claim drafting, and jurisdiction-specific examination. The architecture is directed toward the 10.00 target, but the remaining 0.85 reflects unresolved cryptographic-combination, coding-theory, proof-aggregation, and claim-scope uncertainty.

---

# 4. Direction re-examined

# Obligation-Isolated Ephemeral State Domains with Dependency-Minimal Confluence Closure

The GSCM architecture was:

```text
state-surface manifest
        ↓
common committed baseline
        ↓
separate obligation-state domains
        ↓
lease-bound mutable and external handles
        ↓
one typed result export per domain
        ↓
state restoration, destruction, or unreachability
        ↓
zero residual state, handles, aliases, and I/O
        ↓
minimal dependency graph
        ↓
necessity proof for each edge
        ↓
swap confluence for incomparable operations
        ↓
all-linear-extension confluence
        ↓
confluence-closed acceptance object
```

Its strongest proposed limitations were:

1. one common committed baseline;
2. one isolated state domain per obligation;
3. domain-bound resource handles;
4. exactly one immutable result export;
5. restoration or destruction of all mutable state;
6. no residual aliases, handles, or undeclared I/O;
7. a reduced dependency graph;
8. evidence that each retained edge is necessary;
9. commutativity of unordered result operations;
10. one final state across all valid orders;
11. a public object controlling acceptance.

The deeper search shows that these limitations combine known execution isolation, stateless testing, dependency scheduling, transition independence, rollback, and receipt techniques.

---

# 5. Deeper conflict analysis of GSCM

## 5.1 State refresh and isolated environment reuse

### US-11882184-B2 and continuation family

The patent family describes:

- reusing an execution environment;
- avoiding tainted state between runs;
- switching a pointer from prior state memory to fresh initialized memory;
- isolating subsequent execution while retaining loaded code.

### Conflict

GSCM's baseline-derived domain and discard or refresh model is directly adjacent to the family’s state-isolation mechanism.

A claim broad enough to cover fresh processes, copy-on-write snapshots, memory swapping, and state destruction risks reading on known isolation families or becoming obvious over them.

---

## 5.2 Test dependency extraction and order-preserving execution

### US-9378120-B2

The patent describes:

- receiving test specifications;
- extracting dependencies;
- constructing a directed graph;
- identifying disconnected independent components;
- preserving dependent order;
- exploiting parallel execution for independent cases.

It also discusses state preservation and resetting tests toward an initial state.

### Conflict

This overlaps GSCM's:

```text
obligation nodes
    +
dependency graph
    +
independent components
    +
ordered dependent execution
    +
common initial state
```

GSCM adds necessity and acceptance confluence, but the execution architecture is already known.

---

## 5.3 Stateless agents with explicit dependency data

### US-10423521-B2

The patent claims test-step data containing dependency fields, execution of stateless test transactions, and use of values produced by one step in another step.

### Conflict

This weakens claims to:

- isolated per-obligation execution;
- one state packet per operation;
- explicit result-only cross-obligation transfer;
- stateless orchestration with declared dependency fields.

---

## 5.4 Independent steps executable in any order

### US-10545857-B2 and US-11341031-B2

The family describes:

- independent test steps that may execute in any order or in parallel;
- dependent steps that share state and require a defined order;
- completion messages and final test status.

### Conflict

This is close to the GSCM distinction between incomparable obligation results and ordered dependency edges.

---

## 5.5 Topological dependencies and redundant-edge removal

### US-11822962-B2

The patent claims:

- identifying dependencies from resource configurations;
- topological sorting;
- constructing a dependency graph;
- generating an execution queue;
- identifying and removing redundant dependencies.

### Conflict

GSCM's acyclic dependency graph, transitive reduction, and order generation are materially exposed.

The necessity artifact may remain narrower, but it can be viewed as an ordinary validation step applied to known redundant-edge removal.

---

## 5.6 Transition independence and commutativity

### US-6295515-B1

The patent and incorporated model-checking literature define independent transitions by:

```text
both transitions remain enabled after the other executes
and
executing them in either order reaches the same state
```

### Conflict

GSCM's swap-confluence rule is substantially the same mathematical condition, applied to certificate-result combination rather than model-checking transitions.

The all-linear-extension conclusion follows predictably from adjacent swaps of independent operations.

---

## 5.7 Resource-handle release and invalidation

### US-7836170-B2

The patent describes handles that can be assigned, suspended, reinstated, and released so that they no longer dereference a resource.

### Conflict

This weakens broad claims to:

- lease-bound resource handles;
- post-close invalidity;
- release on domain closure;
- prohibition on dereference after state-domain termination.

---

## 5.8 Sandboxing and namespace isolation

### US-10887346-B2

The patent claims process and namespace-based sandboxing with restricted host-resource access.

### Conflict

A GSCM implementation using Linux namespaces, containers, process forks, restricted filesystems, or network namespaces requires careful claim charting.

---

## 5.9 Rollback and baseline comparison

### US-7467378-B1 and US-11829796-B2

These references cover:

- creating restore points;
- monitoring modifications;
- comparing later state with prior state;
- rolling back toward the prior state when conditions fail.

### Conflict

GSCM's baseline-equivalent closure is exposed when implemented through conventional checkpoints, audit comparison, and rollback.

---

## 5.10 Mature non-patent literature

The following technical fields further weaken GSCM:

- database serializability and conflict graphs;
- commutativity and operation-based concurrency control;
- static and dynamic effect systems;
- linear, affine, and uniqueness types;
- process isolation and capability security;
- deterministic build and reproducible-execution systems;
- flaky-test and test-order-dependency detection;
- partial-order reduction;
- Mazurkiewicz traces;
- confluence in term-rewriting systems;
- transactional rollback and snapshot isolation;
- pure-functional programming and persistent data structures.

An examiner can combine patents with these publications to supply any limitation absent from one patent record.

---

# 6. Corrected GSCM risk analysis

## 6.1 Novelty risk — 6.25/10

No one reviewed patent was confirmed to claim every GSCM limitation in one independent claim.

However, one-reference novelty risk is substantial for important subclaims involving:

- fresh or refreshed execution state;
- isolated execution environments;
- dependency graphs;
- redundant-edge removal;
- stateless test transactions;
- ordered and unordered test steps;
- released handles;
- state rollback.

The remaining novelty appears concentrated in the total interaction of necessity artifacts, per-obligation closure, and acceptance-level all-order confluence. That interaction is too narrow to support the previously claimed broad coverage.

---

## 6.2 Obviousness risk — 8.75/10

A plausible examiner combination is:

1. serverless execution isolation or fresh state;
2. stateless test agents;
3. explicit dependency data;
4. topological dependency graphs with redundant-edge removal;
5. partial-order reduction using commutativity;
6. rollback or state destruction;
7. a public signed artifact.

Each component performs its ordinary function. The combination solves the predictable problem of preventing test-order and shared-state influence.

---

## 6.3 Subject-matter/technicality risk — 0.75/10

GSCM remains technical because it controls memory, handles, external reads, and executable ordering.

The risk rises above the prior 0.10 score because the broadest proposed claim can be reduced to abstract graph and equivalence conditions unless the claim recites concrete state interception, resource mediation, and machine-enforced closure.

---

## 6.4 Freedom-to-operate risk — 6.50/10

FTO concerns include active families covering:

- reusable isolated execution environments;
- stateless test execution with dependencies;
- dependency-graph orchestration;
- sandboxing;
- state rollback;
- resource-handle state transitions;
- execution-order control.

The risk is implementation-sensitive, but the number of active adjacent families makes the prior 0.70 score unsupportable.

---

## 6.5 Ease of enforcing — 5.75/10

The prior 10.00 score is not supportable.

Many critical limitations are internal:

- whether every obligation started from the same baseline;
- whether a handle was truly invalid outside its domain;
- whether every alias was eliminated;
- whether every external read was mediated;
- whether a dependency edge was genuinely necessary;
- whether every incomparable pair was proven confluent;
- whether the public artifact was generated before, rather than after, acceptance.

A competitor can expose a self-asserted confluence artifact without practicing the internal state-control method. Conversely, it can practice isolation internally without publishing enough evidence to prove infringement.

---

## 6.6 Ease for competitors to design around — 8.25/10

Competitors can preserve most commercial value through:

- a fixed deterministic order;
- a formally verified pure-function verifier;
- one fresh process for the complete verification;
- static effect typing;
- immutable state and no runtime closure artifact;
- conventional transaction isolation;
- deterministic replay testing;
- randomized test-order testing without all-order proof;
- a simple dependency graph without necessity artifacts;
- no public confluence object.

These alternatives provide strong confidence while avoiding multiple claim elements.

---

## 6.7 Patentability score — 3.35/10

GSCM is technically coherent but rests on a dense combination of mature mechanisms. The likely surviving claims would be narrow, implementation-dependent, and difficult to enforce from public behavior.

---

# 7. Replacement direction

# Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization

## 7.1 Technical objective

Conventional verifiers usually produce independent outputs:

```text
obligation A → PASS
obligation B → PASS
obligation C → NOT_APPLICABLE
...
controller → final PASS
```

That representation permits defects such as:

```text
one obligation result omitted
one result duplicated into another obligation slot
result from another subject substituted
result from an older run replayed
result generated under another profile reused
result generated by another comparator version reused
diagnostic-only result relabeled as acceptance-capable
NOT_APPLICABLE result used without applicability proof
public receipt generated after an independent final decision
ordinary PASS bit emitted even when the receipt is malformed
```

A bitmap, set-equality check, Merkle root, or signed log can detect some of these states only if the controller that constructs the final decision is itself correct and honest.

GACM changes the accepted representation.

The accepted certificate is not represented by a Boolean plus optional evidence. It is represented by a **profile-specific, subject-specific, run-specific canonical acceptance codeword** that can be decoded into a usable acceptance capability only when the exact required contribution multiset has been produced.

---

# 8. Acceptance-code profile compilation

```text
acceptance_code_profile:
    schema_version
    profile_identifier
    profile_version

    mandatory_obligation_ids
    obligation_count

    relation_outcome_classes
    diagnostic_outcome_classes
    nonapplicability_contracts

    code_family_identifier
    code_parameters
    detection_bound
    localization_bound

    generator_derivation_contract
    parity_or_constraint_contract
    canonical_acceptance_target
    acceptance_decoder_contract

    profile_root
```

The principal claim should not require Reed-Solomon, BCH, Hamming, LDPC, or another named code.

The profile requires a nonseparable accepted representation having at least:

1. distinct obligation-indexed contribution positions;
2. a canonical accepted code class;
3. a defect residue for an incorrect contribution multiset;
4. public localization of at least a declared class of omission, duplication, substitution, or replay defects.

---

# 9. Run-specific code instantiation

For each verification run:

```text
acceptance_code_instance:
    profile_root
    certificate_subject_root
    evidence_snapshot_root
    verifier_build_root
    run_nonce

    obligation_lane_root
    generator_column_root
    target_syndrome
    accepted_code_class_root

    code_instance_hash
```

The run nonce prevents replay of a valid contribution from another evaluation of the same subject.

The subject root prevents cross-certificate reuse.

The profile and build roots prevent cross-policy and cross-comparator substitution.

---

# 10. Obligation-indexed generator contribution

Each mandatory obligation receives a unique lane:

```text
obligation_code_lane:
    obligation_id
    lane_index

    subject_root
    profile_root
    comparator_contract_root
    evidence_requirement_root
    run_nonce

    acceptance_generator
    nonapplicability_generator
    failure_generator
    unresolved_generator
    diagnostic_generator_space

    lane_hash
```

A lane generator is derived from all claim-relevant identities rather than from the obligation number alone.

Conceptually:

```text
G_i = DERIVE(
    profile_root,
    subject_root,
    obligation_id,
    comparator_contract_root,
    evidence_requirement_root,
    run_nonce
)
```

The final accepted representation is constructed from obligation-specific contributions derived from these generators.

---

# 11. Comparator-coupled contribution emission

The contribution encoder is coupled to the relation comparator.

```text
EVALUATE_AND_ENCODE(
    obligation_lane,
    committed_evidence,
    comparator_contract,
    run_context
)
    → obligation_code_contribution
```

The encoder may emit an acceptance-class contribution only when:

1. the obligation identifier matches the lane;
2. the subject root matches the run;
3. the evidence root satisfies the lane’s evidence requirement;
4. the comparator identity matches the lane;
5. the comparator produces an acceptance-capable relation result;
6. the run nonce matches;
7. no contribution has already been emitted for the lane.

```text
obligation_code_contribution:
    obligation_id
    lane_index
    relation_outcome

    subject_root
    evidence_root
    comparator_contract_root
    run_nonce

    contribution_class
    contribution_value
    contribution_commitment
    emission_sequence
    contribution_hash
```

The principal claim should require coupling between the relation computation and contribution emission. A controller that merely converts pre-existing PASS flags into a checksum should not satisfy the strongest claim.

---

# 12. Non-applicability contribution

`NOT_APPLICABLE` is a separate accepted outcome class, not an absent lane.

```text
ENCODE_NONAPPLICABILITY(
    obligation_lane,
    applicability_proof,
    applicability_contract,
    run_context
)
    → nonapplicability_contribution
```

A non-applicability contribution is accepted only when:

- the obligation permits non-applicability;
- the applicability proof is committed;
- the applicability contract matches the profile;
- the contribution occupies the same obligation lane that evaluation would have occupied;
- no evaluation contribution exists for the same lane.

This preserves exact-one settlement while avoiding the single-use-capability architecture reviewed in earlier passes.

---

# 13. Diagnostic subspace separation

Diagnostic output must not cancel acceptance defects.

GACM assigns diagnostic-only contributions to a disjoint code space:

```text
diagnostic_projection_to_acceptance_space = ZERO
```

or an equivalent non-convertibility rule.

A diagnostic contribution may be included in the receipt but cannot satisfy an acceptance-lane equation, reduce a defect syndrome, or contribute to acceptance decoding.

Invalid state:

```text
DIAGNOSTIC_CONTRIBUTION_CANCELLED_ACCEPTANCE_RESIDUE
```

---

# 14. Nonseparable acceptance word

The finalizer combines the contributions into one candidate word:

```text
candidate_acceptance_word = COMBINE(
    ordered_or_commutative_multiset_of_obligation_contributions
)
```

Acceptance is not determined by separately checking a Boolean and then attaching the word.

Instead:

```text
acceptance_capability = DECODE(candidate_acceptance_word)
```

and decoding succeeds only when:

```text
candidate_acceptance_word ∈ canonical_acceptance_code_class
and
contribution_count = mandatory_obligation_count
and
distinct_lane_count = mandatory_obligation_count
and
all contribution bindings match the run
and
acceptance_syndrome = target_syndrome
and
fault_weight = 0
```

The final accepted object is authenticated or otherwise usable only through the decoded acceptance capability.

---

# 15. Fault syndrome

A candidate word produces a syndrome or equivalent defect residue:

```text
fault_syndrome = CHECK(candidate_acceptance_word, code_instance)
```

Closure requires:

```text
fault_syndrome = target_syndrome
```

or, in a zero-target embodiment:

```text
fault_syndrome = ZERO
```

Defects include:

```text
MISSING_LANE
DUPLICATE_LANE
CROSS_LANE_SUBSTITUTION
CROSS_SUBJECT_REPLAY
CROSS_RUN_REPLAY
CROSS_PROFILE_REPLAY
COMPARATOR_SUBSTITUTION
EVIDENCE_ROOT_SUBSTITUTION
DIAGNOSTIC_PROMOTION
UNPROVEN_NONAPPLICABILITY
OUTCOME_CLASS_SUBSTITUTION
CONTRIBUTION_AFTER_FINALIZATION
```

---

# 16. Fault-syndrome localization

A generic signature failure is not enough for the strongest enforcement position.

The profile selects a code construction whose syndrome identifies or narrows the affected obligation lane for declared defect classes.

```text
fault_localization_result:
    syndrome_root
    defect_class
    suspected_lane_root
    exact_lane_count
    localization_confidence_state
    correction_prohibited_or_permitted
    localization_hash
```

For example, within a declared single-defect bound:

```text
one omitted contribution
    → syndrome identifies omitted obligation lane

one duplicated contribution
    → syndrome identifies source and duplicate lane class

one cross-run replay
    → nonce-binding check identifies replayed lane
```

The acceptance verifier should reject rather than silently correct an acceptance defect. Error-correction capability may be used for localization but not to convert a defective verification into acceptance unless a separately claimed remediation protocol is satisfied.

---

# 17. Contribution multiplicity invariant

For mandatory obligation set `O`:

```text
∀ o ∈ O:
    contribution_count(o) = 1
```

and:

```text
contributed_obligation_set = mandatory_obligation_set
```

GACM does not rely only on an ordinary set comparison. The multiplicity invariant is embedded in the accepted code class so that an incorrect multiset changes the candidate word.

---

# 18. Binding invariant

For every accepted contribution `c_i`:

```text
c_i.subject_root = run.subject_root
c_i.profile_root = run.profile_root
c_i.run_nonce = run.run_nonce
c_i.obligation_id = lane_i.obligation_id
c_i.comparator_contract_root = lane_i.comparator_contract_root
c_i.evidence_root satisfies lane_i.evidence_requirement_root
```

A contribution that satisfies the algebraic check but violates a binding rule is rejected.

---

# 19. No standalone acceptance path

The implementation must prevent:

```text
final_pass = true
```

from being emitted independently of successful acceptance-code decoding.

A strong embodiment uses the decoded acceptance capability to:

- authenticate the final accepted certificate;
- derive a subject-bound finalization key;
- construct a typed accepted-object variant unavailable to ordinary code;
- unlock a write-once accepted-state transition;
- authorize publication of the accepted artifact.

The principal claim should avoid generic policy-controlled key release. It should claim that the usable final acceptance representation is derived from the canonical obligation-contribution codeword itself.

---

# 20. Acceptance-code receipt

```text
acceptance_code_receipt:
    schema_version

    profile_root
    certificate_subject_root
    evidence_snapshot_root
    verifier_build_root
    run_nonce

    code_family_identifier
    code_parameter_root
    generator_column_root
    target_syndrome

    mandatory_obligation_root
    mandatory_obligation_count

    contribution_commitment_root
    contribution_count
    distinct_lane_count

    evaluation_contribution_root
    nonapplicability_contribution_root
    diagnostic_contribution_root
    failure_contribution_root
    unresolved_contribution_root

    binding_violation_root
    duplicate_lane_root
    missing_lane_root
    replay_violation_root
    diagnostic_promotion_root

    candidate_acceptance_word_root
    calculated_syndrome
    defect_weight
    localized_fault_root

    decoder_state
    final_acceptance_object_root
    receipt_hash
```

Decoder states:

```text
CANONICAL_ACCEPTANCE_CODEWORD
NONCANONICAL_CODEWORD
NONZERO_FAULT_SYNDROME
WRONG_TARGET_SYNDROME
MISSING_OBLIGATION_LANE
DUPLICATE_OBLIGATION_LANE
CROSS_LANE_SUBSTITUTION
CROSS_RUN_REPLAY
CROSS_SUBJECT_REPLAY
CROSS_PROFILE_REPLAY
COMPARATOR_BINDING_FAILURE
EVIDENCE_BINDING_FAILURE
DIAGNOSTIC_PROMOTION
UNPROVEN_NONAPPLICABILITY
DECODER_BYPASS_ATTEMPT
INVALID_FINALIZATION
```

Only:

```text
CANONICAL_ACCEPTANCE_CODEWORD
```

permits construction of the accepted object.

---

# 21. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising compiling a certificate-verification profile into an acceptance-code profile defining a plurality of mandatory obligation lanes and a canonical accepted code class; instantiating an acceptance-code instance bound to a certificate-subject root, an evidence-snapshot root, a verifier-build root, and a run nonce; deriving, for each mandatory obligation lane, a distinct generator contribution bound to an obligation identifier, a comparator-contract root, an evidence-requirement root, the certificate-subject root, and the run nonce; evaluating each mandatory certificate-verification obligation by a comparator coupled to a contribution encoder; responsive to an acceptance-capable relation result, causing the coupled contribution encoder to emit exactly one obligation-code contribution for the corresponding mandatory obligation lane, the obligation-code contribution being bound to committed evidence used by the comparator; responsive to a profile-permitted non-applicability result, emitting for the same mandatory obligation lane a distinct non-applicability-class contribution only after validating an applicability proof; preventing a diagnostic-only contribution from occupying or cancelling an acceptance contribution space; combining the emitted obligation-code contributions into a candidate acceptance word; calculating from the candidate acceptance word a fault syndrome identifying at least a declared class of missing, duplicated, substituted, or replayed mandatory-obligation contribution; rejecting the candidate acceptance word when the fault syndrome differs from a target syndrome, when an obligation lane has other than one contribution, or when a contribution binding differs from the acceptance-code instance; decoding a usable certificate-acceptance capability from the candidate acceptance word only when the candidate acceptance word belongs to the canonical accepted code class and the exact run-specific mandatory-obligation contribution multiset is present; constructing a final accepted certificate object using the decoded certificate-acceptance capability; and issuing a machine-verifiable receipt bound to the obligation lanes, contribution commitments, candidate acceptance word, calculated fault syndrome, localized fault information, decoder state, and final accepted certificate object.

The strongest interacting limitations are:

1. profile-compiled mandatory obligation lanes;
2. run-specific code instantiation;
3. generator derivation bound to subject, obligation, comparator, evidence requirement, and nonce;
4. comparator-coupled contribution emission;
5. exactly one contribution per mandatory lane;
6. proof-backed non-applicability contribution in the same lane;
7. diagnostic-space non-convertibility;
8. a nonseparable final accepted codeword;
9. syndrome detection of incorrect contribution multiplicity or identity;
10. obligation-level fault localization;
11. no separately constructible acceptance path;
12. a public receipt tied to the codeword and decoder state.

---

# 22. Why the replacement is structurally different

GSCM asks:

> Did isolated obligations leave no state residue, and do all permitted schedules converge?

GACM asks:

> Is the accepted representation itself a run-specific canonical codeword that could only be formed from exactly one correctly bound contribution from every mandatory obligation, and does any omission, duplication, substitution, replay, or diagnostic promotion produce a publicly localizable defect residue?

The replacement moves away from:

```text
isolation
rollback
dependency graphs
commutativity
confluence
schedule equivalence
```

and toward:

```text
comparator-coupled symbol generation
obligation-indexed generator contributions
nonseparable accepted representation
multiplicity-sensitive defect residue
run and subject replay resistance
fault-syndrome localization
acceptance decoding from the complete contribution word
```

---

# 23. Closest prior-art categories for GACM

## 23.1 Error-detecting and error-correcting codes

Examples include:

- **[US-6536009-B1 — Technique for Generating Single-Bit Error-Correcting, Two-Bit Burst Error-Detecting Codes](https://patents.google.com/patent/US6536009B1/en)**
- **[US-7949927-B2 — Error Correction Method and Apparatus for Predetermined Error Patterns](https://patents.google.com/patent/US7949927B2/en)**
- **[US-12009837-B2 / US-20230318628-A1 — Syndrome Calculation for Error Detection and Error Correction](https://patents.google.com/patent/US20230318628A1/en)**

### Known mechanism

These references calculate syndromes to detect or locate corrupted transmitted or stored bits.

### Distinction

GACM does not claim a new communication or memory code. It uses a profile-specific nonseparable accepted representation in which:

- each code position is a mandatory verification obligation;
- the code generator is bound to subject, evidence requirement, comparator identity, and run nonce;
- symbols are emitted by relation comparators;
- the fault classes are obligation omission, duplication, substitution, replay, and diagnostic promotion;
- decoding constructs the accepted certificate object.

The claim should avoid broad ownership of syndrome arithmetic itself.

---

## 23.2 Cryptographic accumulators

Examples include:

- **[US-8726034-B2](https://patents.google.com/patent/US8726034B2/en)**
- **[US-9098725-B2](https://patents.google.com/patent/US9098725B2/en)**

### Known mechanism

These patents authenticate set membership through accumulator or authenticated-tree structures.

### Distinction

An ordinary accumulator establishes set membership. GACM's strongest claim requires:

- exact contribution multiplicity;
- comparator-coupled generation;
- outcome-class separation;
- run-specific code positions;
- fault localization for omission or duplication;
- acceptance capability decoding from the complete codeword.

A Merkle root or accumulator may be an optional commitment layer but should not be the inventive centre.

---

## 23.3 Secret sharing and threshold reconstruction

Examples include:

- **[US-8713329-B2 — Authenticated Secret Sharing](https://patents.google.com/patent/US8713329B2/en)**
- **[US-7551740-B2 — Weighted Secret Sharing and Reconstructing Method](https://patents.google.com/patent/US7551740B2/en)**
- **[US-8170216-B2 — Techniques for Validating and Sharing Secrets](https://patents.google.com/patent/US8170216B2/en)**

### Known mechanism

These references reconstruct a secret from sufficient shares and may authenticate reconstructed material.

### Distinction

GACM is not a quorum system. Strong acceptance requires the exact mandatory obligation set rather than any threshold subset. The claimed fault syndrome identifies obligation-lane defects, and symbols are generated by evidence comparators rather than independent shareholders.

The principal claim should not require splitting a pre-existing secret among obligations.

---

## 23.4 Policy-controlled key release and attribute-based encryption

Examples include:

- **[US-20160112456-A1 — Policy-Based Data Management](https://patents.google.com/patent/US20160112456A1/en)**
- **[US-9077525-B2 — User-Controlled Data Encryption with Obfuscated Policy](https://patents.google.com/patent/US9077525B2/en)**
- **[US-9547771-B2 — Policy Enforcement with Associated Data](https://patents.google.com/patent/US9547771B2/en)**
- **[US-11870894-B2 — Controlled Cryptographic Private Key Release](https://patents.google.com/patent/US11870894B2/en)**
- **[US-9735959-B2 — Enforcing Access-Control Policies with Secret Sharing](https://patents.google.com/patent/US9735959B2/en)**

### Known mechanism

These references release or permit use of a key when access-policy conditions are satisfied.

### Distinction

GACM does not principally protect data access and does not require a trusted policy authority. The decoded object is a certificate-verification acceptance representation derived from an exact obligation-codeword, with syndrome localization of missing, duplicated, substituted, or replayed verifier contributions.

The filing should avoid generic language such as “release a key when all conditions are met.”

---

## 23.5 Signed process-flow provenance

### US-11356275-B2 — Electronically Verifying a Process Flow

The patent signs inputs and outputs of process steps to establish integrity and provenance.

### Distinction

A signature chain proves step provenance. It does not inherently make the final accepted representation a multiplicity-sensitive codeword, localize a missing or duplicated obligation by syndrome, or prohibit a controller from issuing acceptance outside the chain.

---

## 23.6 Audited cryptographic use and receipt gating

### US-11398906-B2 — Confirming Receipt of Audit Records for Audited Use of a Cryptographic Key

The patent may block key-use output when required audit records are not acknowledged.

### Distinction

GACM does not rely on an auditor acknowledging logs. It derives the accepted object from the obligation contribution word and exposes a defect syndrome tied to obligation lanes.

---

## 23.7 Proof aggregation, polynomial identities, and vector commitments

Non-patent literature and additional patents may cover:

- batching multiple proof statements;
- polynomial identity tests;
- vector commitments;
- aggregate signatures;
- SNARK recursion and proof aggregation;
- proof-carrying data;
- error-locating codes;
- fingerprints of multisets;
- set reconciliation;
- all-of-N policy gates.

### Risk-control distinction

The strongest claim should require the complete interaction:

```text
mandatory verifier obligation lanes
    +
comparator-coupled contribution emission
    +
subject, evidence, comparator, profile, and nonce binding
    +
nonseparable accepted codeword
    +
wrong-multiset syndrome
    +
obligation-level fault localization
    +
no independent acceptance path
```

A generic proof aggregator or multiset hash should not satisfy the claim without this interaction.

---

# 24. Replacement risk analysis

## 24.1 Novelty risk — 1.75/10

Known components include:

- error-detecting codes;
- syndromes;
- cryptographic commitments;
- exact-set and multiset fingerprints;
- proof aggregation;
- policy-conditioned key use;
- signed process-flow provenance.

The reviewed patent material did not identify one record containing the complete GACM interaction:

```text
profile-compiled obligation lanes
    +
run-specific obligation generators
    +
comparator-coupled code-symbol emission
    +
exact-one contribution per lane
    +
proof-backed non-applicability in the same lane
    +
diagnostic code-space separation
    +
nonseparable accepted codeword
    +
syndrome localization of obligation-level omission, duplication, substitution, or replay
    +
acceptance-object decoding only from the canonical word
```

Residual novelty risk remains because coding and proof-system searches are terminology-sensitive, and unpublished applications may describe similar predicate-indexed proof codewords.

---

## 24.2 Obviousness risk — 3.25/10

A plausible examiner combination is:

1. a policy or verification engine;
2. a multiset commitment or cryptographic accumulator;
3. an error-detecting code with syndrome localization;
4. policy-controlled finalization or key derivation;
5. signed process-flow provenance.

The inventive-step argument must therefore focus on the technical interaction, not on isolated components.

The strongest arguments are:

- the relation comparator itself emits the obligation contribution;
- the contribution generator is bound to the exact evidence requirement and comparator contract;
- the accepted certificate is the decoded codeword output, not a Boolean followed by auditing;
- incorrect obligation multiplicity changes the accepted representation;
- the syndrome localizes verifier-obligation integration defects;
- diagnostics occupy a non-cancelling code space;
- run-specific generators prevent replay while preserving public verification.

---

## 24.3 Subject-matter/technicality risk — 0.15/10

The replacement changes the machine representation and finalization path of the verifier.

It performs:

- run-specific generator derivation;
- comparator-coupled symbol generation;
- codeword construction;
- syndrome calculation;
- defect localization;
- decoding of a typed or cryptographically authenticated acceptance object;
- rejection of structurally invalid contribution multisets.

The technical effect is not merely reporting compliance. It prevents software-integration errors from producing a valid accepted representation.

The claim should recite concrete encoded data structures and decoder-controlled object construction to avoid being characterized as abstract bookkeeping.

---

## 24.4 Freedom-to-operate risk — 1.75/10

FTO risk remains around implementation choices involving:

- proprietary error-correcting-code circuits;
- cryptographic accumulators;
- authenticated secret sharing;
- attribute-based encryption;
- policy-controlled key release;
- proof aggregation;
- signed process-flow chains;
- audit-gated cryptographic operations.

Risk is reduced by keeping the principal implementation independent of:

- a named coding scheme;
- threshold reconstruction;
- access control;
- blockchain;
- a trusted policy authority;
- a particular accumulator;
- a particular SNARK;
- hardware ECC circuitry;
- a generic key-release service.

A practical implementation should prefer well-understood unencumbered primitives and obtain a claim-by-claim FTO review for the selected coding and commitment libraries.

---

## 24.5 Ease of enforcing — 9.75/10

GACM has a strong enforcement position because the claim-relevant behavior is publicly testable.

A conforming artifact exposes:

- mandatory lane count;
- contribution count;
- distinct lane count;
- run nonce;
- subject and profile roots;
- generator or parameter root;
- candidate word root;
- target and calculated syndrome;
- defect weight;
- localized obligation lane;
- decoder state;
- final accepted-object root.

Black-box tests can submit or induce:

1. a certificate with one mandatory result suppressed;
2. a duplicated result under two obligation labels;
3. a result replayed from another run;
4. a result replayed from another subject;
5. a result generated by a mismatched comparator version;
6. diagnostic output routed into acceptance;
7. `NOT_APPLICABLE` without proof;
8. a contribution altered after finalization.

The accused system either:

- emits a localized noncanonical syndrome and refuses acceptance; or
- accepts despite a defect, contradicting its claimed implementation; or
- exposes a canonical codeword and decoder behavior that can be claim-charted.

The remaining 0.25 reflects the possibility that comparator coupling is internal and may require discovery when the public artifact alone does not prove where the contribution was generated.

---

## 24.6 Ease for competitors to design around — 1.50/10

A competitor can avoid literal “syndrome” or “codeword” terminology, but the claim strategy should cover equivalent nonseparable representations:

- linear error-detecting codes;
- polynomial multiset fingerprints;
- vector-commitment equations;
- group-valued obligation contributions;
- product accumulators with multiplicity detection;
- systematic codewords;
- sparse parity constraints;
- exact-set proof circuits;
- proof-carrying typed sums;
- nonseparable authentication tags.

A competitor seeking the same public guarantee must still provide an accepted representation that proves:

1. every mandatory obligation contributed exactly once;
2. each contribution is bound to the correct subject, run, evidence, profile, and comparator;
3. replay and cross-lane substitution are detected;
4. diagnostics cannot satisfy acceptance;
5. a malformed multiset cannot yield the accepted object;
6. a defect can be publicly attributed to the affected obligation or defect class.

Potential alternatives are weaker or costly:

### Ordinary bitmap plus signature

This can report lane presence but does not make acceptance nonseparable from the exact contribution multiset and may not bind contribution generation to comparator execution.

### Merkle tree of PASS values

This proves inclusion of supplied values, not that no value was duplicated or generated independently of the comparator unless additional circuits reproduce GACM's interaction.

### Full SNARK of the verifier

This can provide equivalent or stronger assurance, but a per-certificate proof circuit that enforces exact obligation multiplicity, binding, diagnostic separation, and final-object construction may practice an equivalent claimed embodiment or impose substantially greater implementation cost.

### Formal verification of the controller

This may prevent integration defects without a runtime artifact, but it forfeits the public per-certificate fault-localization product.

### Threshold key shares

This is exposed to separate prior-art families and generally does not localize which obligation was omitted, duplicated, or replayed.

### No public receipt

This avoids receipt claims but forfeits the principal commercial feature: independent machine verification and obligation-level fault localization.

---

## 24.7 Patentability score — 9.15/10

The replacement has a substantially stronger comparative position because:

- it abandons the crowded isolation, rollback, dependency-graph, and partial-order nucleus;
- it changes the verifier's accepted representation rather than adding an audit record;
- comparator execution is coupled to contribution generation;
- omission and duplication alter the encoded accepted object itself;
- replay resistance is run-specific and subject-specific;
- diagnostic output is structurally unable to satisfy acceptance;
- faults are localized to obligation lanes;
- public black-box testing produces direct claim-chart evidence;
- equivalent coding, commitment, and proof representations can be covered functionally without requiring one algorithm.

The remaining 0.85 gap reflects:

- possible proof-aggregation and predicate-codeword prior art not found in this preliminary search;
- potential obviousness combinations with error-detecting codes and policy-conditioned finalization;
- claim-scope tension between implementation-neutral breadth and technical specificity;
- the need to distinguish generic multiset hashing and exact-set proofs;
- unknown prosecution histories and unpublished applications.

---

# 25. Enforcement-focused public fields

A strong public receipt should expose at least:

```text
schema_version
profile_root
certificate_subject_root
evidence_snapshot_root
verifier_build_root
run_nonce

code_family_identifier
code_parameter_root
generator_column_root
target_syndrome

mandatory_obligation_root
mandatory_obligation_count

contribution_commitment_root
contribution_count
distinct_lane_count

accepted_contribution_root
nonapplicability_contribution_root
diagnostic_contribution_root
failure_contribution_root
unresolved_contribution_root

missing_lane_root
missing_lane_count
duplicate_lane_root
duplicate_lane_count
cross_lane_substitution_root
replay_violation_root
binding_violation_root
diagnostic_promotion_root

candidate_acceptance_word_root
calculated_syndrome
fault_weight
localized_fault_root
localization_state

decoder_state
final_acceptance_object_root
receipt_hash
```

---

# 26. Independent public verifier

The public verifier should check:

1. profile authenticity and version;
2. subject and evidence-snapshot binding;
3. run nonce freshness or uniqueness policy;
4. mandatory obligation-lane derivation;
5. generator derivation or commitment;
6. one contribution per mandatory lane;
7. contribution identity and comparator binding;
8. evidence-root binding;
9. non-applicability proof binding;
10. diagnostic-space separation;
11. candidate-word reconstruction;
12. target-syndrome calculation;
13. defect-weight calculation;
14. fault-localization consistency;
15. decoder state;
16. final accepted-object binding;
17. absence of a receipt-independent acceptance representation where externally testable.

---

# 27. Anti-design-around claim strategy

## 27.1 Avoid limiting claims to “error-correcting code”

Use broader language:

- nonseparable acceptance representation;
- obligation-indexed contribution constraint system;
- defect-residue function;
- canonical accepted code class;
- multiplicity-sensitive acceptance word.

Dependent claims may name linear codes, Reed-Solomon, BCH, polynomial fingerprints, or group accumulators.

---

## 27.2 Claim comparator coupling

The strongest claim should require that the same operation that determines the relation result causes or authorizes generation of the obligation contribution.

This distinguishes post-hoc checksums over ordinary PASS flags.

---

## 27.3 Claim exact multiplicity inside the representation

Do not rely only on:

```text
set(contribution_ids) = set(required_ids)
```

Claim that omission, duplication, or substitution changes the candidate acceptance word or defect residue and prevents decoding.

---

## 27.4 Claim multiple binding axes

Require binding to at least:

```text
subject
profile
obligation
comparator
evidence commitment
run nonce
```

This blocks replay and relabeling designs.

---

## 27.5 Claim diagnostic non-cancellation

A competitor may encode diagnostics in the same accumulator and permit them to offset a missing acceptance contribution.

Claim a disjoint diagnostic space or equivalent rule preventing diagnostic material from reducing an acceptance defect residue.

---

## 27.6 Claim fault localization

Generic hash mismatch is easier to design around and less enforceable.

Require the public defect residue to identify or narrow the affected obligation lane or declared defect class within a profile-defined bound.

---

## 27.7 Claim decoder-controlled acceptance construction

The accepted-object type, authentication tag, or capability must be derived from the canonical word.

Avoid generic downstream policy gating. Claim the construction relationship between the codeword and the accepted object.

---

## 27.8 Cover equivalent algebraic representations

Dependent claim embodiments should include:

- finite-field vectors;
- integer or modular groups;
- polynomial evaluations;
- sparse parity matrices;
- authenticated vector commitments;
- multiplicative accumulators;
- typed proof terms;
- recursive proof circuits.

---

## 27.9 Separate fault detection from fault correction

For strong acceptance, detected defects should cause rejection.

A competitor should not evade the claim by calling silent correction “recovery.” Dependent claims can protect remediation, but the principal acceptance claim should require zero unresolved defect residue before finalization.

---

# 28. Recommended claim families

## Family A — Acceptance-code profile compilation

Protect generation of mandatory lanes and accepted code constraints from a verification profile.

## Family B — Run-specific generator derivation

Protect subject, obligation, comparator, evidence-requirement, profile, and nonce-bound generator contributions.

## Family C — Comparator-coupled contribution emission

Protect emission of a code contribution as an integrated consequence of relation evaluation.

## Family D — Proof-backed non-applicability contribution

Protect explicit non-applicability symbols occupying the same mandatory lane.

## Family E — Diagnostic-space non-convertibility

Protect inability of diagnostic material to satisfy or cancel acceptance constraints.

## Family F — Multiplicity-sensitive accepted representation

Protect rejection when any mandatory lane has zero or more than one contribution.

## Family G — Replay- and substitution-sensitive contribution binding

Protect cross-run, cross-subject, cross-profile, cross-comparator, and cross-evidence detection.

## Family H — Fault-syndrome localization

Protect public localization of omitted, duplicated, substituted, or replayed obligation contributions.

## Family I — Decoder-controlled accepted object

Protect construction of the usable accepted certificate only from the canonical word.

## Family J — Acceptance-code receipt

Protect the machine-readable artifact and independent verification method.

## Family K — Cross-verifier codeword comparison

Protect comparison of contribution words from different verifier versions or implementations.

## Family L — Remediation without silent correction

Protect controlled reevaluation of localized defective lanes before a new accepted codeword is constructed.

---

# 29. Technical evidence required before filing

## 29.1 Missing obligation contribution

Suppress one mandatory contribution.

Expected state:

```text
MISSING_OBLIGATION_LANE
```

The syndrome should identify the missing lane within the declared localization bound.

---

## 29.2 Duplicate contribution

Insert one valid contribution twice.

Expected state:

```text
DUPLICATE_OBLIGATION_LANE
```

---

## 29.3 Cross-lane substitution

Use obligation A's contribution in obligation B's lane.

Expected state:

```text
CROSS_LANE_SUBSTITUTION
```

---

## 29.4 Cross-run replay

Reuse a contribution from an earlier run of the same subject.

Expected state:

```text
CROSS_RUN_REPLAY
```

---

## 29.5 Cross-subject replay

Reuse a contribution from another certificate subject.

Expected state:

```text
CROSS_SUBJECT_REPLAY
```

---

## 29.6 Comparator substitution

Use a contribution emitted under another comparator version.

Expected state:

```text
COMPARATOR_BINDING_FAILURE
```

---

## 29.7 Evidence substitution

Change the evidence root after contribution generation.

Expected state:

```text
EVIDENCE_BINDING_FAILURE
```

---

## 29.8 Diagnostic promotion

Attempt to route a diagnostic contribution into an acceptance lane.

Expected state:

```text
DIAGNOSTIC_PROMOTION
```

---

## 29.9 Non-applicability without proof

Emit a non-applicability contribution without a valid applicability proof.

Expected state:

```text
UNPROVEN_NONAPPLICABILITY
```

---

## 29.10 Receipt-independent acceptance

Attempt to generate an accepted object while the candidate word is noncanonical.

Expected state:

```text
DECODER_BYPASS_ATTEMPT
```

No accepted object should be constructible.

---

## 29.11 Exact canonical closure

Demonstrate:

```text
contribution_count = mandatory_obligation_count
distinct_lane_count = mandatory_obligation_count
all bindings valid
fault_syndrome = target_syndrome
fault_weight = 0
decoder_state = CANONICAL_ACCEPTANCE_CODEWORD
```

---

## 29.12 Implementation diversity

Implement equivalent semantics using at least three representations:

1. a finite-field parity-check matrix;
2. a polynomial multiset fingerprint with obligation locators;
3. a vector-commitment or proof-circuit representation.

All should produce one canonical public receipt schema.

This supports implementation-neutral claims while demonstrating that the invention is the obligation-code interaction rather than one algorithm.

---

# 30. Glyphser implementation path

## 30.1 New schemas

```text
acceptance_code_profile.v1
acceptance_code_instance.v1
obligation_code_lane.v1
obligation_code_contribution.v1
nonapplicability_code_contribution.v1
diagnostic_code_contribution.v1
fault_syndrome.v1
fault_localization_result.v1
acceptance_code_receipt.v1
canonical_acceptance_object.v1
```

## 30.2 Suggested modules

```text
runtime/glyphser/acceptance_code/profile.py
runtime/glyphser/acceptance_code/instance.py
runtime/glyphser/acceptance_code/generators.py
runtime/glyphser/acceptance_code/lanes.py
runtime/glyphser/acceptance_code/comparator_encoder.py
runtime/glyphser/acceptance_code/nonapplicability.py
runtime/glyphser/acceptance_code/diagnostic_space.py
runtime/glyphser/acceptance_code/combine.py
runtime/glyphser/acceptance_code/syndrome.py
runtime/glyphser/acceptance_code/localize.py
runtime/glyphser/acceptance_code/decode.py
runtime/glyphser/acceptance_code/receipt.py
runtime/glyphser/acceptance_code/verify.py
```

## 30.3 Suggested quality gates

```text
tooling/quality_gates/acceptance_code_profile_gate.py
tooling/quality_gates/lane_uniqueness_gate.py
tooling/quality_gates/comparator_coupling_gate.py
tooling/quality_gates/contribution_binding_gate.py
tooling/quality_gates/nonapplicability_proof_gate.py
tooling/quality_gates/diagnostic_separation_gate.py
tooling/quality_gates/contribution_multiplicity_gate.py
tooling/quality_gates/replay_resistance_gate.py
tooling/quality_gates/syndrome_localization_gate.py
tooling/quality_gates/decoder_bypass_gate.py
tooling/quality_gates/canonical_acceptance_gate.py
```

## 30.4 Adversarial fixtures

```text
mandatory_lane_missing
mandatory_lane_duplicated
contribution_lane_relabelled
contribution_from_other_subject
contribution_from_other_run
contribution_from_other_profile
contribution_from_other_comparator
contribution_evidence_root_changed
nonapplicability_without_proof
evaluation_and_nonapplicability_same_lane
diagnostic_contribution_in_acceptance_space
candidate_word_modified_after_combine
syndrome_target_modified
fault_localization_inconsistent
accepted_object_constructed_without_decoder
receipt_from_other_subject_replayed
```

---

# 31. Features to exclude from the principal claim

Do not make these essential:

- a named error-correcting code;
- Reed-Solomon;
- BCH;
- Hamming codes;
- LDPC;
- a threshold secret-sharing scheme;
- attribute-based encryption;
- blockchain;
- a generic cryptographic accumulator;
- a Merkle tree;
- a SNARK;
- a trusted execution environment;
- per-obligation process isolation;
- dependency graphs;
- partial-order reduction;
- rollback;
- a validator certificate registry;
- a particular hash function;
- a particular signature scheme;
- one processor architecture;
- one programming language.

These may appear as optional embodiments or dependent claims.

---

# 32. Filing strategy

## Principal independent method claim

Require:

- mandatory obligation lanes;
- run-specific generator derivation;
- comparator-coupled contribution emission;
- exact-one contribution multiplicity;
- proof-backed non-applicability;
- diagnostic non-cancellation;
- nonseparable candidate word;
- wrong-multiset syndrome;
- obligation-level localization;
- accepted-object decoding only from the canonical word.

## Separate system claim

Claim components such as:

- profile compiler;
- code-instance generator;
- obligation-lane generator;
- comparator-coupled encoder;
- contribution combiner;
- syndrome calculator;
- fault localizer;
- acceptance decoder;
- receipt generator;
- public verifier.

## Separate data-structure claim

Where permitted, claim the machine-readable receipt and canonical accepted object containing the obligation-lane, contribution, syndrome, localization, and decoder fields.

## Continuation applications

Potential continuation families:

1. comparator-coupled contribution emission;
2. run-specific obligation generator derivation;
3. diagnostic code-space separation;
4. proof-backed non-applicability symbols;
5. multiplicity-sensitive acceptance words;
6. replay-localizing syndromes;
7. decoder-controlled accepted-object construction;
8. cross-verifier codeword comparison;
9. localized reevaluation and replacement of defective lanes;
10. privacy-preserving contribution openings.

---

# 33. Final recommendation

The state-confluence direction is no longer the strongest filing candidate because its central mechanisms are closely adjacent to active or mature technologies involving:

- fresh or refreshed execution state;
- isolated execution environments;
- stateless test agents;
- explicit data dependencies;
- topological dependency graphs;
- redundant-edge removal;
- transition independence and commutativity;
- state rollback;
- resource-handle release;
- all-order equivalence.

Replace it with:

> **A certificate-verification architecture that compiles mandatory verification obligations into run-specific obligation-code lanes; binds each lane to the certificate subject, verification profile, comparator contract, evidence requirement, and run nonce; causes each comparator to emit exactly one lane-specific contribution as an integrated consequence of evaluating committed evidence; represents proof-backed non-applicability through a distinct contribution in the same lane; places diagnostic contributions in a non-cancelling code space; combines the exact contribution multiset into a nonseparable candidate acceptance word; calculates a defect syndrome that detects and localizes missing, duplicated, substituted, replayed, or improperly promoted obligation contributions; prevents construction of an accepted certificate object unless the candidate word belongs to the canonical accepted code class; and emits a public machine-verifiable receipt tied to the codeword, syndrome, fault localization, decoder state, and accepted object.**

This direction is better because it:

- removes execution isolation, rollback, dependency graphs, and confluence from the inventive centre;
- prevents an omitted or duplicated obligation from being hidden behind an ordinary PASS bit;
- binds every contribution to the exact subject, run, profile, comparator, and evidence requirement;
- treats non-applicability as an explicit lane contribution;
- makes diagnostic output structurally unable to cancel an acceptance defect;
- makes the accepted representation itself dependent on the exact obligation contribution multiset;
- detects replay and cross-lane substitution;
- localizes faults to obligation lanes for direct black-box testing;
- provides stronger public infringement evidence than internal state-domain claims;
- supports multiple implementations without depending on one coding algorithm;
- forces competitors seeking the same exact public guarantee to implement an equivalent nonseparable obligation-contribution representation or accept a materially weaker product;
- strictly improves every requested risk, enforcement, design-around, and patentability score after correcting the prior scores.

---

# 34. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh professional search focused on:
   - predicate-indexed error-detecting codes;
   - cryptographic proof codewords;
   - multiset fingerprints with error localization;
   - vector commitments with multiplicity proofs;
   - proof aggregation with missing-proof localization;
   - exact-all-condition cryptographic finalization;
   - workflow-step syndrome detection;
   - policy-conditioned codeword decoding;
   - error-locating accumulators;
   - proof-carrying typed sums;
2. limitation-by-limitation claim charts against:
   - error-correcting-code patent families selected for implementation;
   - cryptographic accumulator patents;
   - secret-sharing patents;
   - attribute-based encryption patents;
   - policy-controlled key-use patents;
   - process-flow provenance patents;
   - proof-aggregation patents;
3. prosecution-history review of the closest active US families;
4. non-patent-literature review covering:
   - coding theory;
   - multiset hashing;
   - polynomial identity testing;
   - vector commitments;
   - SNARK aggregation;
   - proof-carrying data;
   - aggregate signatures;
   - exact cover and all-of-N authorization structures;
5. jurisdiction-specific subject-matter analysis;
6. FTO review of the selected code, commitment, signature, and proof libraries;
7. inventorship analysis;
8. review of Glyphser repository disclosures and dates;
9. independent verification of the previously cited **US-12645555-B1** record before any further reliance.

No search can establish that undisclosed applications, unpublished applications, non-English documents, private source code, or unindexed prior art do not exist.

---

# 35. Public patent records relied upon in this pass

- [US-11882184-B2 — Reuse of Execution Environments While Guaranteeing Isolation in Serverless Computing](https://patents.google.com/patent/US11882184B2/en)
- [US-9378120-B2 — Automated Test Execution Plan Derivation System and Method](https://patents.google.com/patent/US9378120B2/en)
- [US-10423521-B2 — Automatically Executing Stateless Transactions with Data Dependency in Test Cases](https://patents.google.com/patent/US10423521B2/en)
- [US-10545857-B2 — Controlling Executions of Synchronous and/or Non-Synchronous Operations with Asynchronous Messages](https://patents.google.com/patent/US10545857B2/en)
- [US-11341031-B2 — Continuation in the Same Execution-Control Family](https://patents.google.com/patent/US11341031B2/en)
- [US-11822962-B2 — Execution Orchestration with Topological Dependency Relationships](https://patents.google.com/patent/US11822962B2/en)
- [US-6295515-B1 — Static Partial Order Reduction](https://patents.google.com/patent/US6295515B1/en)
- [US-7836170-B2 — Suspension and Reinstatement of Reference Handles](https://patents.google.com/patent/US7836170B2/en)
- [US-10887346-B2 — Application-Level Sandboxing](https://patents.google.com/patent/US10887346B2/en)
- [US-7467378-B1 — System State Rollback After Modification Failure](https://patents.google.com/patent/US7467378B1/en)
- [US-11829796-B2 — Automated Rollback](https://patents.google.com/patent/US11829796B2/en)
- [US-8726034-B2 — Cryptographic Accumulators for Authenticated Hash Tables](https://patents.google.com/patent/US8726034B2/en)
- [US-9098725-B2 — Continuation in the Cryptographic-Accumulator Family](https://patents.google.com/patent/US9098725B2/en)
- [US-8713329-B2 — Authenticated Secret Sharing](https://patents.google.com/patent/US8713329B2/en)
- [US-7551740-B2 — Weighted Secret Sharing and Reconstructing Method](https://patents.google.com/patent/US7551740B2/en)
- [US-8170216-B2 — Techniques for Validating and Sharing Secrets](https://patents.google.com/patent/US8170216B2/en)
- [US-20160112456-A1 — Policy-Based Data Management](https://patents.google.com/patent/US20160112456A1/en)
- [US-9077525-B2 — User-Controlled Data Encryption with Obfuscated Policy](https://patents.google.com/patent/US9077525B2/en)
- [US-9547771-B2 — Policy Enforcement with Associated Data](https://patents.google.com/patent/US9547771B2/en)
- [US-11870894-B2 — Controlled Cryptographic Private Key Release](https://patents.google.com/patent/US11870894B2/en)
- [US-9735959-B2 — Enforcing Access-Control Policies with Secret Sharing](https://patents.google.com/patent/US9735959B2/en)
- [US-11356275-B2 — Electronically Verifying a Process Flow](https://patents.google.com/patent/US11356275B2/en)
- [US-11398906-B2 — Confirming Receipt of Audit Records for Audited Use of a Cryptographic Key](https://patents.google.com/patent/US11398906B2/en)
- [US-6536009-B1 — Error-Detecting Code Generation](https://patents.google.com/patent/US6536009B1/en)
- [US-7949927-B2 — Error Correction for Predetermined Error Patterns](https://patents.google.com/patent/US7949927B2/en)
- [US-20230318628-A1 / US-12009837-B2 — Syndrome Calculation for Error Detection and Correction](https://patents.google.com/patent/US20230318628A1/en)
