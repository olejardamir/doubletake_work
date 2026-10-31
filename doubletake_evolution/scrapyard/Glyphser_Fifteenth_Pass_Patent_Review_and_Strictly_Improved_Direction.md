# Glyphser Patent Direction
## Fifteenth-Pass Conflict Review, Strictly Improved Risk Scores, and Risk-Focused Replacement Architecture

**Review date:** July 17, 2026  
**Direction examined:** *Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs*  
**Replacement direction:** *Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts*

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the cited claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search note:** This pass goes deeper than the previous review. It incorporates additional patent searches directed specifically to executable program slices, policy partial evaluation, program specialization, single-use tokens, policy tokens, resource-consumption accounting, verification-mode policy systems, and completion-detection structures. The retrieved sources materially worsen the prior direction's scores and support a narrower replacement architecture.

---

# 1. Score definitions

All scores use a **0–10 scale**.

| Category | Meaning of a higher score |
|---|---|
| Novelty risk | Worse: greater likelihood that one reference anticipates the proposed claim |
| Obviousness risk | Worse: greater likelihood that an examiner can combine known references |
| Subject-matter/technicality risk | Worse: greater risk of being treated as abstract, administrative, or insufficiently technical |
| Freedom-to-operate risk | Worse: greater likelihood that implementation may practice active third-party claims |
| Ease of enforcing the patent | Better: easier to detect, test, claim-chart, and prove infringement |
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while preserving similar commercial value |

The scores are comparative engineering judgments, not legal conclusions or probabilities.

---

# 2. Executive conclusion

The fourteenth-pass direction should not remain the principal Glyphser patent nucleus.

That direction proposed:

- capturing one completed production-verifier decision;
- extracting an instance-specific decision slice;
- compiling the slice into a restricted deterministic microprogram;
- binding capsule inputs to committed certificate evidence or authenticated constants;
- replaying the decision through a small reference virtual machine;
- proving exact production-to-capsule equivalence;
- applying a deterministic reduction order;
- proving retained inputs and instructions irreducible under that order;
- proving omitted certificate fields cannot reach the capsule outputs;
- proving all acceptance obligations remain covered;
- emitting a portable decision-kernel capsule.

The deeper patent search found direct and active conflicts in the central mechanisms.

The most important newly emphasized references include:

- **US-11537372-B2 — Generating Compilable Machine Code Programs from Dynamic Language Code**
  - uses execution-informed program slicing;
  - produces executable slices;
  - applies partial evaluation and recompilation;
  - creates residual executable code.

- **US-8543974-B2 — Plan-Based Program Slicing**
  - extracts program statements by analyzing control and data relationships;
  - generates slices from a program representation according to slicing criteria.

- **US-8589893-B1 and US-9239716-B1 — Usage-Based Program Slicing**
  - use execution traces;
  - determine program slices;
  - distribute a baseline slice and supplemental slices.

- **US-20220357933-A1 — Computer Implemented Program Specialization**
  - reduces program instructions when only a subset of functions is required;
  - specializes a program using known configuration and desired functions;
  - aims to preserve soundness of the reduced program.

- **US-11080410-B1 and US-12118102-B1 — Partial Policy Evaluation**
  - precompute the portions of a policy independent of a future request;
  - produce a partially evaluated policy;
  - later combine the residual policy with request-specific parameters to produce an authorization decision.

- **US-9191408-B2 — Partial Evaluation to Construct a Simplified Policy**
  - constructs a simplified policy for known attributes;
  - retains only the policy material required for later evaluation.

- **US-6301700-B1 — Slicing Class Hierarchies**
  - eliminates classes, functions, members, and relationships unnecessary to preserve semantics.

- **US-20170010957-A1 — Multithreaded Program Output Uniqueness Testing and Proof Generation**
  - generates proof material concerning program outputs.

The prior direction's inventive centre can therefore be characterized as:

```text
execution trace
    +
program slicing
    +
partial evaluation or specialization
    +
restricted residual program
    +
replay or proof evidence
```

That combination is too crowded.

The irreducibility and omission-barrier witnesses remain narrower distinctions, but an examiner may treat them as verification checks applied to a known residual program.

The direction is also easy to avoid commercially. A competitor can:

- publish the full verifier;
- compile a simplified policy;
- use a policy decision graph;
- use proof-carrying code;
- use an unreduced residual verifier;
- use a formally verified small verifier;
- publish an explanation trace without an executable capsule;
- skip irreducibility;
- skip the omission barrier;
- provide an independent audit.

## Replacement decision

Retire this as the principal filing direction:

> **Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs**

Retain as optional embodiments:

- small replay programs;
- verifier decision slices;
- committed decision inputs;
- replay-equivalence checking;
- omission barriers.

Proceed instead with:

# **Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts**

Suggested protocol name:

## **Glyphser Obligation Settlement Machine — GOSM**

The replacement solves a different technical problem:

> A verifier may evaluate the same mandatory obligation twice, silently omit an obligation, use one evidence object to satisfy multiple obligations when reuse is prohibited, settle both “evaluated” and “not applicable” paths for the same obligation, convert diagnostic evidence into acceptance authority, or generate an acceptance decision while unsettled obligations remain. How can a verifier make these states unrepresentable or machine-detectable and produce a public receipt proving that every mandatory obligation was settled exactly once through one mutually exclusive settlement path, every evidence capability was consumed only as authorized, no operation duplicated or amplified acceptance authority, and the final acceptance gate consumed the complete settled-obligation set?

The proposed system compiles a verification profile into a restricted obligation-settlement state machine.

For every mandatory verification domain, the profile compiler mints:

1. one uniquely identified **obligation object**;
2. two mutually exclusive **settlement capabilities**:
   - an evaluation capability;
   - a non-applicability capability;
3. an acceptance-authority budget assigned by the profile.

The two settlement capabilities share one exclusivity serial.

Consuming either capability irrevocably cancels the other.

A comparator can produce a relation result only by consuming:

- the evaluation settlement capability;
- all profile-required evidence capabilities;
- the comparator contract capability.

A non-applicability result can be produced only by consuming:

- the non-applicability settlement capability;
- a profile-valid applicability-proof capability.

Every result capability is typed as:

- identity-capable;
- acceptance-capable;
- diagnostic-only;
- obligation-only.

The restricted settlement machine prohibits:

- capability duplication;
- double consumption;
- settlement of both mutually exclusive paths;
- reuse of non-reusable evidence;
- conversion of diagnostic-only capability into acceptance authority;
- net creation of acceptance authority;
- finalization while a mandatory obligation is unsettled;
- finalization while a required relation result remains unconsumed.

The final public receipt proves:

```text
all mandatory obligations minted
    =
all obligations settled exactly once
    =
all required result capabilities consumed exactly once
    =
final acceptance sink
```

with no residual acceptance authority and no missing obligation.

The principal claim does not require:

- program slicing;
- partial evaluation;
- a residual verifier program;
- dynamic taint tracking;
- mutation testing;
- group testing;
- counterfactual execution;
- blockchain;
- remote attestation;
- one token representation;
- one cryptographic commitment;
- one operating system.

This materially lowers exposure to the patents that weakened the prior direction.

---

# 3. Revised scores

## 3.1 Direction examined

### Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs

| Category | Revised score |
|---|---:|
| **Novelty risk** | **7.0/10** |
| **Obviousness risk** | **9.0/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **7.0/10** |
| **Ease of enforcing the patent** | **9.0/10** |
| **Ease for competitors to design around** | **7.0/10** |

## 3.2 Replacement direction

### Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts

| Category | Score |
|---|---:|
| **Novelty risk** | **3.5/10** |
| **Obviousness risk** | **5.0/10** |
| **Subject-matter/technicality risk** | **1.0/10** |
| **Freedom-to-operate risk** | **3.5/10** |
| **Ease of enforcing the patent** | **10.0/10** |
| **Ease for competitors to design around** | **2.5/10** |

## 3.3 Strict improvement check

| Category | Examined direction | Replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 7.0 | 3.5 | **Yes — 3.5 lower** |
| Obviousness risk | 9.0 | 5.0 | **Yes — 4.0 lower** |
| Subject-matter/technicality risk | 1.5 | 1.0 | **Yes — 0.5 lower** |
| Freedom-to-operate risk | 7.0 | 3.5 | **Yes — 3.5 lower** |
| Ease of enforcing | 9.0 | 10.0 | **Yes — 1.0 higher** |
| Ease of design-around | 7.0 | 2.5 | **Yes — 4.5 lower** |

**Every requested category improves. None remains unchanged.**

The replacement remains exposed to:

- single-use token systems;
- capability security;
- affine and linear type systems;
- access-policy tokens;
- resource-consumption accounting;
- UTXO-like spend records;
- policy verification modes;
- proof-carrying authorization;
- completion-detection systems.

Its stronger position depends on the complete interaction:

```text
profile-minted mandatory obligation objects
    +
mutually exclusive evaluation/non-applicability settlement capabilities
    +
single-use evidence capabilities
    +
typed relation-result capabilities
    +
acceptance-authority non-amplification
    +
exact-one obligation settlement
    +
complete result consumption
    +
public conservation receipt
```

---

# 4. Direction examined

## Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs

The prior architecture was:

```text
production verifier decision
        ↓
instance-specific decision slice
        ↓
restricted residual microprogram
        ↓
committed inputs
        ↓
reference-VM replay
        ↓
reduction-order irreducibility
        ↓
omission barrier
        ↓
portable capsule
```

Its strongest proposed limitations were:

1. one completed production decision;
2. an instance-specific executable slice;
3. a restricted deterministic residual program;
4. committed inputs;
5. exact output replay;
6. deterministic reduction;
7. retained-element irreducibility;
8. omitted-field exclusion;
9. obligation coverage;
10. a portable capsule.

The deeper search shows that the first six limitations are directly adjacent to active slicing, specialization, and policy-partial-evaluation patents.

---

# 5. Deeper conflict analysis of the examined direction

## 5.1 Executable execution-informed slices

### US-11537372-B2  
**Generating Compilable Machine Code Programs from Dynamic Language Code**

### Relevant mechanism

The patent describes:

- execution-informed analysis;
- dependency graphs;
- program slices;
- partially evaluated slices;
- executable or recompilable residual code;
- specialization of program behavior.

### Conflict

This is close to:

- capturing a verifier execution;
- extracting a decision slice;
- compiling a restricted executable capsule;
- replaying the resulting residual program.

---

## 5.2 Plan-based program slicing

### US-8543974-B2  
**Plan-Based Program Slicing**

### Relevant mechanism

The patent:

- constructs a plan representation of a program;
- accepts slicing criteria;
- traverses data and control relationships;
- generates a program slice.

### Conflict

A certificate decision output and its policy obligations are straightforward slicing criteria.

---

## 5.3 Usage-based program slicing

### US-8589893-B1  
### US-9239716-B1  
**Usage-Based Program Slicing**

### Relevant mechanism

The patents:

- access execution traces;
- calculate component usage information;
- construct a baseline slice and supplemental slices;
- distribute reduced program material.

### Conflict

The prior Glyphser direction also starts from a completed execution trace and constructs a smaller executable artifact.

---

## 5.4 Program specialization and debloating

### US-20220357933-A1  
**Computer Implemented Program Specialization**

### Relevant mechanism

The application:

- identifies desired program functions;
- partially interprets program configuration logic;
- propagates known states;
- removes unused instructions;
- preserves soundness of the specialized program.

### Conflict

The prior capsule is a specialization of the verifier for one certificate and one decision.

---

## 5.5 Partial policy evaluation

### US-11080410-B1  
### US-12118102-B1  
**Partial Policy Evaluation**

### Relevant mechanism

The patents:

- evaluate a portion of a policy using known parameters;
- create a partially evaluated policy;
- store or distribute the resulting policy;
- later combine it with remaining parameters;
- generate an authorization decision.

### Conflict

A verifier decision capsule can be characterized as a partially evaluated policy or residual authorization program.

These patents are active and create substantial FTO concern.

---

## 5.6 Simplified policy construction

### US-9191408-B2  
**Partial Evaluation to Construct a Simplified Policy**

### Relevant mechanism

The patent constructs a simplified policy for known attributes and later evaluates it.

### Conflict

This further weakens the residual policy aspect.

---

## 5.7 Class hierarchy slicing

### US-6301700-B1  
**Method and Apparatus for Slicing Class Hierarchies**

### Relevant mechanism

The patent removes unnecessary program structure while preserving relevant semantics.

### Conflict

It weakens dependent embodiments that remove verifier classes, methods, or dependency modules.

---

## 5.8 Proof generation for program outputs

### US-20170010957-A1  
**Multithreaded Program Output Uniqueness Testing and Proof Generation**

### Relevant mechanism

The application generates proof material for program outputs based on program constraints.

### Conflict

This weakens broad claims to a proof that the reduced program reproduces a selected output.

---

# 6. Revised risk analysis of the examined direction

## 6.1 Novelty risk — 7.0/10

The replay-equivalence, irreducibility, omission-barrier, and obligation-coverage combination may remain novel.

However, the claimed operational centre is close to:

- executable slicing;
- residual-program generation;
- program specialization;
- partial policy evaluation;
- output proof generation.

A narrow claim may survive, but broad commercial coverage would be difficult.

---

## 6.2 Obviousness risk — 9.0/10

A plausible examiner combination is:

1. executable program slicing;
2. execution-trace-guided slicing;
3. partial policy evaluation;
4. program specialization or debloating;
5. proof-carrying code or execution attestation;
6. dependency reachability for omitted fields.

Each component performs its ordinary function.

---

## 6.3 Subject-matter/technicality risk — 1.5/10

The direction remains technical.

It creates and executes a restricted program.

The risk is not eligibility; it is crowded prior art.

---

## 6.4 Freedom-to-operate risk — 7.0/10

The risk increased because the deeper search identified active US patents covering:

- partial policy evaluation;
- residual policy generation;
- executable slicing;
- program specialization.

The implementation would require detailed claim charts against:

- US-11080410-B1;
- US-12118102-B1;
- US-11537372-B2;
- US-9191408-B2;
- US-20220357933-A1 and later family members.

---

## 6.5 Ease of enforcing — 9.0/10

A public capsule is visible.

However, competitors can provide similar value using:

- simplified policies;
- full verifiers;
- policy graphs;
- formal proofs;
- residual policies;
- non-executable explanations.

This limits useful claim reach.

---

## 6.6 Ease for competitors to design around — 7.0/10

Competitors can avoid:

- executable capsules;
- deterministic reduction;
- irreducibility records;
- omission barriers;
- the reference VM.

They can preserve the customer outcome through existing policy-evaluation and proof techniques.

---

# 7. Replacement direction

# Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts

## 7.1 Technical objective

A certificate profile defines obligations such as:

```text
verify executable identity
verify dependency closure
verify policy identity
verify input artifact identity
verify externality handling
verify output artifact relation
verify metric relation
verify unsupported-domain state
```

Conventional verifiers represent these obligations as ordinary control flow and data structures.

That permits defects such as:

- one obligation never executed;
- one obligation executed twice;
- one evidence result reused for two obligations;
- both evaluation and `NOT_APPLICABLE` paths accepted;
- an applicability proof reused across unrelated domains;
- diagnostic evidence promoted into acceptance;
- acceptance finalized with unresolved obligations;
- a result generated but never consumed by the final decision.

GOSM makes these defects invalid state transitions.

---

# 8. Profile compilation

```text
obligation_settlement_profile:
    profile_id
    profile_version

    obligations:
        - obligation_id
          obligation_type
          evidence_requirement_root
          comparator_contract_id
          applicability_contract_id
          authority_budget
          output_capability_type
          settlement_policy

    obligation_count
    total_authority_budget
    profile_root
```

---

# 9. Obligation minting

For each mandatory obligation:

```text
obligation_object:
    obligation_id
    profile_root
    certificate_subject_root

    exclusivity_serial
    authority_budget
    settlement_state

    obligation_hash
```

Initial settlement state:

```text
UNSETTLED
```

---

# 10. Mutually exclusive settlement capabilities

Each obligation mints two capabilities:

```text
evaluation_settlement_capability:
    obligation_id
    exclusivity_serial
    permitted_comparator_contract
    authority_budget
    capability_serial

nonapplicability_settlement_capability:
    obligation_id
    exclusivity_serial
    permitted_applicability_contract
    authority_budget
    capability_serial
```

They are mutually exclusive.

Valid transition:

```text
UNSETTLED
    → SETTLED_BY_EVALUATION
```

or:

```text
UNSETTLED
    → SETTLED_BY_NONAPPLICABILITY
```

Invalid transitions:

```text
SETTLED_BY_EVALUATION
    → SETTLED_BY_NONAPPLICABILITY

SETTLED_BY_NONAPPLICABILITY
    → SETTLED_BY_EVALUATION

SETTLED
    → SETTLED_AGAIN
```

Consuming either capability cancels its companion capability.

---

# 11. Evidence capabilities

```text
evidence_capability:
    evidence_capability_id
    evidence_type
    source_commitment
    subject_root

    permitted_obligation_ids
    reuse_policy
    remaining_use_count

    influence_class
    authority_class
    capability_hash
```

Reuse policies:

```text
SINGLE_USE
DECLARED_MULTI_USE
DERIVATION_ONLY
DIAGNOSTIC_ONLY
```

A single-use evidence capability cannot satisfy two obligations.

A declared multi-use capability must disclose every authorized obligation ID.

---

# 12. Comparator settlement operation

```text
SETTLE_EVALUATION(
    evaluation_settlement_capability,
    comparator_contract_capability,
    required_evidence_capabilities
)
    →
relation_result_capability
    +
settlement_receipt
    +
companion_cancellation_receipt
```

The operation validates:

1. obligation identity;
2. subject identity;
3. comparator contract;
4. evidence types;
5. evidence authorization;
6. evidence use count;
7. authority budget;
8. exclusivity serial;
9. prior settlement state.

---

# 13. Non-applicability settlement operation

```text
SETTLE_NONAPPLICABILITY(
    nonapplicability_settlement_capability,
    applicability_contract_capability,
    applicability_proof_capabilities
)
    →
nonapplicable_result_capability
    +
settlement_receipt
    +
companion_cancellation_receipt
```

`NOT_APPLICABLE` is therefore not an absent check.

It is an affirmative settlement requiring a profile-valid proof.

---

# 14. Typed result capabilities

```text
relation_result_capability:
    obligation_id
    relation_state
    evidence_root

    capability_type
    authority_budget
    influence_class

    capability_serial
    result_hash
```

Capability types:

```text
IDENTITY_RESULT
ACCEPTANCE_RESULT
DIAGNOSTIC_RESULT
OBLIGATION_RESULT
FAILURE_RESULT
UNRESOLVED_RESULT
```

Influence classes:

```text
IDENTITY_CAPABLE
ACCEPTANCE_CAPABLE
DIAGNOSTIC_ONLY
NO_DECISION_INFLUENCE
```

---

# 15. Acceptance-authority conservation

Each obligation begins with a fixed authority budget.

An operation may:

- preserve authority;
- reduce authority;
- route authority;
- consume authority.

An operation may not create net new authority.

For an operation:

```text
sum(output_acceptance_authority)
    ≤
sum(input_acceptance_authority)
```

For the complete evaluation:

```text
minted_acceptance_authority
    =
settled_result_authority
    +
cancelled_authority
    +
failed_authority
    +
residual_authority
```

Strong acceptance requires:

```text
residual_authority = 0
failed_authority = 0
unresolved_acceptance_authority = 0
```

Diagnostic capabilities have:

```text
acceptance_authority = 0
```

and cannot be promoted without a profile migration that explicitly changes their type.

---

# 16. Restricted obligation settlement machine

Suggested instruction set:

```text
MINT_OBLIGATION
MINT_SETTLEMENT_PAIR
MINT_EVIDENCE_CAPABILITY
VERIFY_EVIDENCE_COMMITMENT
CONSUME_EVIDENCE
SETTLE_EVALUATION
SETTLE_NONAPPLICABILITY
CANCEL_COMPANION
EMIT_RELATION_CAPABILITY
COMBINE_RELATION_CAPABILITIES
CONSUME_RELATION_CAPABILITY
FINALIZE_ACCEPTANCE
EMIT_CONSERVATION_RECEIPT
```

Prohibited operations:

```text
DUPLICATE_CAPABILITY
RESET_CONSUMED_CAPABILITY
INCREASE_AUTHORITY
PROMOTE_DIAGNOSTIC_AUTHORITY
SETTLE_WITHOUT_OBLIGATION
FINALIZE_WITH_UNSETTLED_OBLIGATION
FINALIZE_WITH_UNCONSUMED_REQUIRED_RESULT
```

---

# 17. Exact-one settlement invariant

For mandatory obligation set `O`:

```text
∀ o ∈ O:
    settlement_count(o) = 1
```

and:

```text
evaluation_settlement(o)
    XOR
nonapplicability_settlement(o)
```

The finalizer verifies:

```text
minted_obligation_set
    =
settled_obligation_set
```

and:

```text
duplicate_settlement_set = ∅
unsettled_obligation_set = ∅
```

---

# 18. Required-result consumption invariant

A result capability may be generated but ignored by an ordinary verifier.

GOSM requires:

```text
required_result_capability_set
    =
final_acceptance_consumed_capability_set
```

with:

```text
unconsumed_required_result_set = ∅
duplicate_result_consumption_set = ∅
```

---

# 19. Settlement receipt

```text
obligation_settlement_receipt:
    obligation_id
    exclusivity_serial

    settlement_path
    settlement_capability_serial
    companion_capability_serial
    companion_cancellation_root

    consumed_evidence_capability_root
    comparator_or_applicability_contract_id

    emitted_result_capability_hash
    authority_input
    authority_output

    settlement_state
    receipt_hash
```

Settlement paths:

```text
EVALUATED
NONAPPLICABLE
FAILED
UNRESOLVED
```

Only one path may be terminal.

---

# 20. Acceptance conservation receipt

```text
acceptance_conservation_receipt:
    schema_version

    profile_root
    certificate_subject_root

    minted_obligation_root
    minted_obligation_count

    evaluation_settlement_root
    nonapplicability_settlement_root
    failed_settlement_root
    unresolved_settlement_root

    settled_obligation_root
    settled_obligation_count
    duplicate_settlement_root
    unsettled_obligation_root

    minted_evidence_capability_root
    consumed_evidence_capability_root
    residual_evidence_capability_root
    unauthorized_reuse_root

    emitted_result_capability_root
    consumed_result_capability_root
    residual_result_capability_root

    minted_authority_total
    consumed_authority_total
    cancelled_authority_total
    residual_authority_total
    amplified_authority_total

    final_acceptance_state
    conservation_state
    receipt_hash
```

Conservation states:

```text
EXACT_ONE_SETTLEMENT_CLOSED
UNSETTLED_OBLIGATION
DUPLICATE_SETTLEMENT
MUTUALLY_EXCLUSIVE_PATH_VIOLATION
EVIDENCE_DOUBLE_USE
UNAUTHORIZED_EVIDENCE_USE
RESULT_NOT_CONSUMED
RESULT_DOUBLE_CONSUMED
AUTHORITY_AMPLIFICATION
DIAGNOSTIC_PROMOTION
RESIDUAL_AUTHORITY
INVALID_FINALIZATION
```

Only `EXACT_ONE_SETTLEMENT_CLOSED` supports strong acceptance.

---

# 21. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising compiling a certificate-verification profile into a plurality of mandatory obligation objects, each mandatory obligation object having an obligation identifier, an acceptance-authority budget, and a pair of mutually exclusive settlement capabilities comprising an evaluation settlement capability and a non-applicability settlement capability sharing an exclusivity serial; generating evidence capabilities bound to respective committed certificate evidence values and to authorized obligation identifiers; settling a first mandatory obligation through an evaluation operation that consumes the first mandatory obligation's evaluation settlement capability and one or more required evidence capabilities, generates a typed relation-result capability, and irreversibly cancels the first mandatory obligation's non-applicability settlement capability; settling a second mandatory obligation through a non-applicability operation that consumes the second mandatory obligation's non-applicability settlement capability and one or more applicability-proof capabilities, generates a typed non-applicability result capability, and irreversibly cancels the second mandatory obligation's evaluation settlement capability; preventing duplication or reuse of a capability contrary to a capability reuse policy; preventing an operation from generating acceptance authority exceeding acceptance authority of its consumed input capabilities; preventing a diagnostic-only result capability from contributing acceptance authority; consuming each required relation-result capability at a final acceptance operation; determining that each mandatory obligation object was settled exactly once through one of the mutually exclusive settlement capabilities, each required relation-result capability was consumed exactly once, no unauthorized evidence reuse occurred, and no residual or amplified acceptance authority remains; and issuing a machine-verifiable acceptance conservation receipt bound to the obligation objects, settlement capabilities, evidence capabilities, relation-result capabilities, cancellation records, authority totals, and final acceptance state.

The strongest limitations are:

1. profile-minted mandatory obligation objects;
2. one mutually exclusive settlement-capability pair per obligation;
3. evaluation settlement requiring evidence consumption;
4. non-applicability settlement requiring proof consumption;
5. cancellation of the unused settlement path;
6. single-use or explicitly bounded evidence capabilities;
7. typed result capabilities;
8. diagnostic authority fixed at zero;
9. non-amplifying acceptance authority;
10. exact-one settlement;
11. exact-one required-result consumption;
12. a public conservation receipt.

---

# 22. Closest prior-art categories and references

## 22.1 Single-use tokens

Relevant references include:

- **US-11715101-B2 — Single-Use Payment Tokens**
- **US-20230036852-A1 and WO-2021140376-A1 — Single-Use Tokens**
- **US-11044257-B1 — One-Time Access to Protected Resources**
- **US-10382426-B2 — Single Sign-On with Single-Use Access Tokens**

### Difference

These references use tokens to authorize one payment, transfer, login, or resource access.

GOSM uses paired single-use settlement capabilities to settle mandatory verifier obligations and generate typed relation results.

No blockchain or access request is required.

---

## 22.2 Selective token invalidation

### US-11777725-B2  
**Secure Selective Rules-Driven Token Invalidation**

### Relevant mechanism

The patent invalidates access tokens according to rules and expiration conditions.

### Difference

GOSM's companion cancellation enforces mutual exclusivity between two settlement paths for one verification obligation.

---

## 22.3 Policy tokens

Relevant references include:

- **US-12219060-B2 — Access Policy Token**
- **US-11196560-B2 — Policy and Token-Based Authorization Framework**
- **US-11658983-B2 — Authentication and Authorization Across Microservices**
- **US-20140337955-A1 — Authentication and Authorization with a Bundled Token**

### Difference

GOSM capabilities do not grant resource access.

They are consumed inside a restricted verification machine to prove exact-one evidence-obligation settlement.

---

## 22.4 Proof-carrying and restricted tokens

### WO-2022144411-A1  
**System for Communicating Through Tokens**

### Relevant mechanism

The disclosure describes restricted tokens, proof-carrying authentication, and contextual token conditions.

### Difference

GOSM's distinguishing interaction is obligation minting, mutually exclusive settlement, evidence consumption, result capability generation, authority conservation, and final receipt.

---

## 22.5 Policy verification mode

### US-9258312-B1  
**Distributed Policy Enforcement with Verification Mode**

### Relevant mechanism

The patent:

- transforms and enforces policies;
- supports verification mode;
- substitutes decision data;
- reports policies and decision data used during evaluation.

### Difference

GOSM does not merely report decision inputs.

It enforces exact-once obligation settlement and non-amplifying acceptance authority through capability state transitions.

---

## 22.6 Resource-consumption accounting

Relevant references include:

- **US-20180025166-A1 and EP-3256998-A1 — Validating Computer Resource Usage**
- token and transaction systems in which an authorized consumption amount is depleted.

### Difference

GOSM accounts for verification authority and mandatory obligations rather than metered computing-resource consumption.

The principal claim should not require blockchain transactions.

---

## 22.7 Token certification and audit records

Relevant references include:

- **US-12406255-B2 — Non-Interactive Token Certification and Verification**
- **US-12013924-B1 — Non-Repudiable Proof of Digital Identity Verification**
- **US-20240333537-A1 — Audit Chain for Hashes Using Tokenization**
- **US-7000118-B1 — Tamper-Proof Audit Trail**

### Difference

GOSM's public artifact proves a complete exact-one settlement computation, not merely token validity or audit-log integrity.

---

## 22.8 Completion-detection structures

Relevant references include:

- **US-8074193-B2 — Mixed Single-Rail and Dual-Rail Logic with Completion Detection**
- **US-7870516-B2 — Asynchronous Multi-Rail Logic with Completion Detection**
- **US-6526542-B2 — Multi-Rail Asynchronous Flow with Completion Detection**

### Difference

These are circuit architectures using signal rails.

GOSM does not require dual-rail hardware.

Its paired capabilities are software verification rights bound to one obligation and one certificate subject.

The principal claim should use “mutually exclusive settlement capabilities” rather than claim generic dual-rail completion detection.

---

# 23. Replacement-direction risk analysis

## 23.1 Novelty risk — 3.5/10

The component technologies are known:

- single-use tokens;
- capabilities;
- policy tokens;
- token invalidation;
- resource-consumption accounting;
- completion detection;
- audit receipts;
- linear and affine resource semantics.

The reviewed patent material did not identify one reference claiming the complete interaction:

```text
mandatory verifier obligation object
    +
paired mutually exclusive settlement capabilities
    +
evidence capability consumption
    +
proof-backed non-applicability settlement
    +
typed result capability
    +
diagnostic authority prohibition
    +
acceptance-authority non-amplification
    +
exact-one final settlement
    +
public conservation receipt
```

This is narrower and more structurally distinctive than the prior executable-capsule direction.

---

## 23.2 Obviousness risk — 5.0/10

A plausible examiner combination is:

1. single-use capabilities or tokens;
2. policy verification;
3. resource-consumption accounting;
4. mutually exclusive state transitions;
5. audit receipts.

The strongest inventive-step argument is the technical interaction:

- each mandatory verification obligation creates a paired settlement right;
- exactly one of the two rights must be consumed;
- the unused right is cancelled;
- actual evaluation consumes committed evidence;
- non-applicability consumes affirmative proof;
- relation results carry typed authority;
- no operation may amplify authority;
- final acceptance requires exact settlement and exact result consumption.

This is more than using a token as a credential or logging a policy result.

---

## 23.3 Subject-matter/technicality risk — 1.0/10

The replacement is strongly technical.

It operates through:

- a restricted state machine;
- uniquely serialized capability objects;
- machine-enforced use counts;
- atomic consume-and-cancel transitions;
- typed result objects;
- authority-budget arithmetic;
- finalization guards;
- machine-verifiable receipts.

It changes the verifier's permissible runtime states and prevents double-use, omission, and unauthorized authority propagation.

---

## 23.4 Freedom-to-operate risk — 3.5/10

FTO risks remain around:

- one-time capability systems;
- access-policy tokens;
- resource-consumption ledgers;
- token invalidation;
- audit receipts;
- proof-carrying authorization.

Risk is reduced because the principal claim can remain independent of:

- blockchain;
- access control;
- payment;
- resource metering;
- a token server;
- a distributed ledger;
- a specific cryptographic token format;
- a specific memory representation.

The implementation should avoid copying the claimed transaction structures of active token and blockchain patents.

---

## 23.5 Ease of enforcing — 10.0/10

This is the strongest enforcement position of the reviewed directions.

A conforming product would expose:

- obligation count;
- obligation serials;
- settlement-path bitmap;
- settlement receipt root;
- cancelled companion root;
- evidence capability root;
- evidence reuse violations;
- result capability root;
- unconsumed result count;
- minted authority;
- consumed authority;
- cancelled authority;
- residual authority;
- amplified authority;
- final conservation state.

The behavior is directly black-box testable.

A claimant can submit:

- one missing obligation;
- one duplicated obligation;
- one evidence object reused twice;
- both settlement paths for one obligation;
- a false `NOT_APPLICABLE` result;
- a diagnostic result routed into acceptance;
- a result generated but omitted from finalization;
- a double-consumed result capability.

The public receipt and deterministic rejection states provide direct claim-chart evidence.

---

## 23.6 Ease for competitors to design around — 2.5/10

Competitors can avoid literal token terminology, but the claim strategy should cover equivalent machine representations:

- capability objects;
- affine handles;
- single-use records;
- spend bitmaps;
- atomic state cells;
- monotonic counters;
- UTXO-like records;
- typed state-machine transitions.

A competitor can instead:

### Recompute everything in conventional control flow

This avoids the capability architecture but loses a public exact-one conservation proof.

### Use ordinary set equality

This may prove every obligation appears once, but does not prove evidence-use limits, mutually exclusive settlement, typed authority, or exact result consumption.

### Use a static type system

This may prevent some duplication, but does not produce the public runtime receipt unless it implements equivalent obligation and authority accounting.

### Use a formal proof of the verifier

This can substitute for the guarantee but is substantially more expensive and difficult to expose as a per-certificate public artifact.

A competitor seeking the same combination of:

- exact-one obligation settlement;
- affirmative non-applicability proof;
- no evidence double-use;
- no diagnostic promotion;
- no authority amplification;
- public per-certificate verification;

has few practical alternatives.

---

# 24. Enforcement-focused design

## 24.1 Mandatory public fields

Every strong receipt should expose:

```text
profile_root
certificate_subject_root

minted_obligation_root
minted_obligation_count

settled_obligation_root
settled_obligation_count
evaluation_settlement_root
nonapplicability_settlement_root

duplicate_settlement_root
unsettled_obligation_root
mutual_exclusion_violation_root

minted_evidence_capability_root
consumed_evidence_capability_root
residual_evidence_capability_root
unauthorized_reuse_root

emitted_result_capability_root
consumed_result_capability_root
residual_result_capability_root

minted_authority_total
consumed_authority_total
cancelled_authority_total
residual_authority_total
amplified_authority_total

final_acceptance_state
conservation_state
receipt_hash
```

---

## 24.2 Public verifier

The public verifier should check:

1. profile authenticity;
2. obligation minting;
3. unique obligation serials;
4. paired settlement-capability serials;
5. mutual exclusion;
6. evidence authorization;
7. evidence reuse policy;
8. comparator contract binding;
9. applicability-proof binding;
10. result capability types;
11. diagnostic authority;
12. authority conservation;
13. required-result consumption;
14. exact-one obligation settlement;
15. final receipt hash.

---

## 24.3 Product commands

```text
glyphser obligations compile
glyphser obligations mint
glyphser obligations settle
glyphser obligations finalize
glyphser obligations inspect
glyphser obligations verify
```

Suggested API surfaces:

```text
POST /obligation-profiles/compile
POST /obligation-evaluations
POST /obligation-evaluations/{id}/settle
POST /obligation-evaluations/{id}/finalize
POST /obligation-receipts/verify
GET  /obligation-receipts/{id}
```

---

# 25. Anti-design-around claim strategy

## 25.1 Avoid limiting claims to “tokens”

Use broader terms:

- single-use capability;
- consumable obligation state;
- non-duplicable settlement object;
- atomically transitionable obligation record;
- bounded-use evidence authorization.

Dependent claims may use token terminology.

---

## 25.2 Claim the mutually exclusive settlement pair

A competitor may represent one obligation with an enum.

Claim:

- two authorized terminal settlement modes;
- shared exclusivity identifier;
- selection of one mode disabling the other;
- proof attached to the selected mode.

---

## 25.3 Claim evidence-use policy independently

A competitor may settle obligations exactly once but reuse one evidence result improperly.

Use a separate claim for:

- single-use evidence;
- bounded multi-use evidence;
- declared authorized obligation set;
- unauthorized-reuse rejection.

---

## 25.4 Claim acceptance-authority non-amplification

A competitor may avoid obligation tokens but implement result weights.

Claim the invariant:

```text
output acceptance authority
    ≤
consumed input acceptance authority
```

across verifier operations.

---

## 25.5 Claim diagnostic non-convertibility

A competitor may account for authority but allow diagnostics to influence acceptance.

Claim diagnostic capability type with zero acceptance authority and prohibition on promotion without profile migration.

---

## 25.6 Claim exact result consumption

A competitor may generate all checks but ignore one result.

Claim equality between required emitted result capabilities and final consumed result capabilities.

---

## 25.7 Claim receipt challenge openings

Permit independent opening of:

- one obligation;
- one settlement pair;
- one evidence capability;
- one result capability;
- one cancellation record;
- one authority transition.

This strengthens proof and enforcement.

---

# 26. Recommended claim families

## Family A — Profile-minted verification obligations

Protect deterministic creation of mandatory obligation objects.

## Family B — Mutually exclusive settlement capabilities

Protect evaluation and non-applicability settlement paths.

## Family C — Evidence capability consumption

Protect use counts and authorized obligation bindings.

## Family D — Applicability-proof settlement

Protect affirmative proof for `NOT_APPLICABLE`.

## Family E — Typed relation-result capabilities

Protect identity, acceptance, diagnostic, failure, and unresolved types.

## Family F — Acceptance-authority conservation

Protect non-amplification and zero residual authority.

## Family G — Exact-one settlement

Protect complete and duplicate-free obligation settlement.

## Family H — Exact result consumption

Protect final-decision consumption of every mandatory result.

## Family I — Acceptance conservation receipt

Protect the public machine-readable artifact.

## Family J — Cross-verifier receipt comparison

Protect comparison of obligation settlements across verifier versions or implementations.

---

# 27. Technical evidence needed before filing

## 27.1 Missing obligation

Remove one mandatory obligation before finalization.

Expected state:

```text
UNSETTLED_OBLIGATION
```

---

## 27.2 Duplicate settlement

Attempt to settle one obligation twice.

Expected state:

```text
DUPLICATE_SETTLEMENT
```

---

## 27.3 Both settlement paths

Settle one obligation by evaluation and then by non-applicability.

Expected state:

```text
MUTUALLY_EXCLUSIVE_PATH_VIOLATION
```

---

## 27.4 Evidence double use

Use a single-use evidence capability for two obligations.

Expected state:

```text
EVIDENCE_DOUBLE_USE
```

---

## 27.5 Unauthorized evidence use

Use evidence for an obligation outside its permitted obligation set.

Expected state:

```text
UNAUTHORIZED_EVIDENCE_USE
```

---

## 27.6 False non-applicability

Attempt `NOT_APPLICABLE` without the required proof capability.

Finalization must fail.

---

## 27.7 Diagnostic promotion

Attempt to convert a diagnostic-only result into acceptance authority.

Expected state:

```text
DIAGNOSTIC_PROMOTION
```

---

## 27.8 Authority amplification

Use one unit of acceptance authority to generate two units.

Expected state:

```text
AUTHORITY_AMPLIFICATION
```

---

## 27.9 Unconsumed result

Generate a mandatory relation result but omit it from final acceptance.

Expected state:

```text
RESULT_NOT_CONSUMED
```

---

## 27.10 Double-consumed result

Consume one result capability twice.

Expected state:

```text
RESULT_DOUBLE_CONSUMED
```

---

## 27.11 Exact closure

Demonstrate:

```text
minted obligations = settled obligations
required results = consumed results
minted authority = consumed + cancelled authority
residual authority = 0
```

Expected state:

```text
EXACT_ONE_SETTLEMENT_CLOSED
```

---

## 27.12 Implementation diversity

Implement the same protocol using:

1. explicit capability objects;
2. an atomic bitmap and monotonic counters;
3. an affine-type verifier runtime.

All implementations should produce the same canonical conservation receipt.

This supports broad implementation-neutral claims.

---

# 28. Glyphser implementation path

## 28.1 New schemas

```text
obligation_settlement_profile.v1
verification_obligation_object.v1
settlement_capability_pair.v1
evidence_capability.v1
comparator_contract_capability.v1
applicability_contract_capability.v1
relation_result_capability.v1
obligation_settlement_receipt.v1
acceptance_authority_ledger.v1
acceptance_conservation_receipt.v1
```

## 28.2 Suggested modules

```text
runtime/glyphser/obligations/profile.py
runtime/glyphser/obligations/mint.py
runtime/glyphser/obligations/capabilities.py
runtime/glyphser/obligations/evidence.py
runtime/glyphser/obligations/comparators.py
runtime/glyphser/obligations/applicability.py
runtime/glyphser/obligations/settle.py
runtime/glyphser/obligations/authority.py
runtime/glyphser/obligations/finalize.py
runtime/glyphser/obligations/receipt.py
runtime/glyphser/obligations/verify.py
```

## 28.3 Suggested quality gates

```text
tooling/quality_gates/obligation_mint_complete_gate.py
tooling/quality_gates/settlement_pair_exclusive_gate.py
tooling/quality_gates/evidence_use_policy_gate.py
tooling/quality_gates/applicability_proof_gate.py
tooling/quality_gates/result_capability_type_gate.py
tooling/quality_gates/diagnostic_authority_gate.py
tooling/quality_gates/authority_nonamplification_gate.py
tooling/quality_gates/exact_one_settlement_gate.py
tooling/quality_gates/exact_result_consumption_gate.py
tooling/quality_gates/acceptance_conservation_receipt_gate.py
```

## 28.4 Required adversarial fixtures

```text
mandatory_obligation_not_minted
duplicate_obligation_serial
settlement_pair_serial_mismatch
evaluation_after_nonapplicability
nonapplicability_after_evaluation
same_path_settled_twice
single_use_evidence_reused
evidence_used_for_unauthorized_obligation
evidence_subject_mismatch
comparator_contract_substituted
applicability_contract_substituted
nonapplicability_without_proof
result_capability_from_wrong_obligation
diagnostic_result_promoted
acceptance_authority_amplified
negative_authority_balance
required_result_not_consumed
result_consumed_twice
finalize_with_unsettled_obligation
finalize_with_residual_authority
receipt_replayed_for_other_subject
```

---

# 29. Features to exclude from the principal claim

Do not make these essential:

- executable program slicing;
- partial evaluation;
- residual policy generation;
- a decision virtual machine;
- mutation testing;
- dynamic taint tracking;
- group testing;
- counterfactual execution;
- blockchain;
- remote attestation;
- zero-knowledge proofs;
- TPM;
- TEE;
- one token storage format;
- one capability implementation;
- one hash function;
- one signature scheme;
- one operating system;
- one processor architecture;
- one ML framework.

They may appear as optional embodiments or dependent claims.

---

# 30. Filing strategy

## Principal independent method claim

Require:

- profile-minted obligations;
- mutually exclusive settlement capabilities;
- evidence capability consumption;
- evaluation and proof-backed non-applicability settlement;
- result capability typing;
- authority non-amplification;
- exact-one settlement;
- exact result consumption;
- final conservation receipt.

## Separate system claim

Claim components such as:

- obligation profile compiler;
- obligation minter;
- capability manager;
- evidence capability manager;
- comparator settlement engine;
- applicability settlement engine;
- authority ledger;
- exact-one finalizer;
- receipt generator;
- receipt verifier.

## Separate receipt claim

Claim the machine-readable acceptance conservation receipt and its independent verification method where permitted.

## Continuation applications

Potential continuation families:

1. paired settlement capabilities;
2. evidence-use limits;
3. proof-backed non-applicability;
4. typed result authority;
5. authority non-amplification;
6. exact result consumption;
7. implementation-neutral settlement states;
8. cross-verifier settlement comparison.

---

# 31. Final recommendation

The portable decision-kernel direction is no longer the strongest filing candidate because its central mechanisms are closely covered by active and historical patents involving:

- executable program slicing;
- execution-trace-guided slicing;
- program specialization;
- software debloating;
- partial policy evaluation;
- simplified policy construction;
- residual executable programs;
- proof generation for program outputs.

Replace it with:

> **A certificate-verification state machine that deterministically mints one mandatory obligation object for every verification requirement, gives each obligation a pair of mutually exclusive single-use settlement capabilities for evidence-backed evaluation or proof-backed non-applicability, consumes bounded-use evidence capabilities to emit typed relation-result capabilities, prohibits duplicate consumption, diagnostic promotion, and net amplification of acceptance authority, requires every obligation and every mandatory result to be consumed exactly once before acceptance, and emits a public conservation receipt proving complete settlement with zero residual authority.**

This direction is better because it:

- removes program slicing, partial evaluation, and residual policy generation from the inventive centre;
- makes omission, duplication, double settlement, evidence reuse, and diagnostic promotion invalid machine states;
- treats `NOT_APPLICABLE` as an affirmative proof-backed settlement rather than an absent check;
- prevents result generation without final result consumption;
- creates a measurable non-amplification invariant;
- uses a restricted technical state machine rather than an abstract reporting rule;
- produces the strongest public infringement evidence of the reviewed directions;
- supports direct black-box double-spend, omission, mutual-exclusion, and authority-amplification tests;
- can claim capability objects, bitmaps, affine handles, monotonic state cells, and equivalent exact-one representations;
- forces competitors seeking the same exact-one public guarantee to implement an equivalent settlement and authority-accounting mechanism or accept a materially weaker product;
- strictly improves every requested score;
- was not matched by one patent containing the complete mandatory-obligation, mutually exclusive settlement, evidence-consumption, typed-result, non-amplifying-authority, exact-finalization, and public conservation-receipt interaction in the patent material reviewed to date.

---

# 32. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh professional prior-art search focused on:
   - linear and affine capability systems;
   - proof-relevant resource semantics;
   - policy-obligation tokens;
   - exact-once workflow settlement;
   - consumable evidence objects;
   - authority-budget conservation;
   - proof-carrying authorization;
   - completion detection in software state machines;
2. limitation-by-limitation claim charts against:
   - single-use token patents;
   - access-policy token patents;
   - resource-consumption ledger patents;
   - token invalidation patents;
   - verification-mode policy patents;
   - capability-security patents;
3. prosecution-history review of:
   - US-11715101-B2;
   - US-11044257-B1;
   - US-11777725-B2;
   - US-12219060-B2;
   - US-9258312-B1;
4. jurisdiction-specific FTO analysis;
5. review of non-patent literature on:
   - linear logic;
   - affine type systems;
   - capability machines;
   - uniqueness types;
   - exact-once processing;
   - UTXO accounting;
   - resource-aware type systems;
   - proof-carrying authorization;
6. review of the exact capability representation and atomic transition mechanism;
7. review of the Glyphser repository's public-disclosure history;
8. inventorship analysis.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
