# Glyphser Patent Direction
## Fourteenth-Pass Conflict Review, Revised Risk Scores, and Risk-Focused Replacement Architecture

**Review date:** July 17, 2026  
**Direction examined:** *Bidirectional Parse-to-Decision Evidence Exhaustion with Decision-Input Closure*  
**Replacement direction:** *Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs*

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the cited claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation for this pass:** The GoVeda patent-search credit balance remained exhausted, so another broad semantic patent search could not be completed. This pass therefore performs a deeper conflict analysis using patent records and search results retrieved during the preceding Glyphser reviews. The replacement direction requires a fresh professional prior-art and FTO search before filing.

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

The thirteenth-pass direction should not remain the principal Glyphser patent nucleus.

That direction proposed:

- a byte-ownership map covering every non-padding certificate byte;
- canonical evidence nodes bound to exact encoded byte ranges;
- detection of duplicate, overlapping, aliased, or inconsistent parses;
- runtime tracing of every acceptance-rule input;
- a forward evidence-consumption graph from parsed evidence to the final decision;
- an independently generated reverse obligation graph from the acceptance contract to required evidence;
- proof that every required evidence node was consumed;
- proof that every consumed input was committed or authorized;
- ambient-input exclusion;
- diagnostic noninterference;
- a public evidence-consumption closure certificate.

The concept addresses a concrete verifier defect: a certificate may be signed and structurally valid while required evidence is ignored or hidden inputs influence acceptance.

However, its patentable centre is weakened by established fields covering:

- dynamic taint tracking;
- static and dynamic dataflow analysis;
- program slicing;
- data provenance;
- policy-engine decision tracing;
- parser canonicalization;
- duplicate-key and ambiguous-encoding detection;
- information-flow noninterference;
- execution attestation;
- proof-carrying software;
- complete mediation;
- code, branch, and decision coverage.

A plausible examiner could combine:

```text
byte-level parser provenance
    +
dynamic rule-input tracing
    +
static reverse dependency analysis
    +
information-flow noninterference
    +
execution attestation
```

The direction also remains avoidable. A competitor can provide similar assurance through:

- formally verified parsing;
- a memory-safe typed parser;
- dynamic taint tracking without a reverse obligation graph;
- static policy analysis without runtime traces;
- dual-parser differential validation;
- code and branch coverage;
- mandatory-field access checks;
- a small dedicated verifier;
- proof-carrying code;
- a security audit rather than a public closure certificate.

## Replacement decision

Retire this as the principal filing direction:

> **Bidirectional Parse-to-Decision Evidence Exhaustion with Decision-Input Closure**

Retain as optional implementation and verification material:

- byte ownership;
- canonical parse graphs;
- input provenance;
- reverse acceptance obligations;
- ambient-input inventories;
- diagnostic noninterference.

Proceed instead with:

# **Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs**

Suggested protocol name:

## **Glyphser Decision Kernel Capsule — GDKC**

The replacement solves a narrower, more product-visible technical problem:

> A production certificate verifier may be large, depend on many libraries, and contain parsing, diagnostic, compatibility, and policy code unrelated to one particular acceptance decision. How can the verifier produce a small portable executable capsule containing exactly the evidence values, profile constants, and deterministic decision operations sufficient to reproduce that decision, prove that no retained kernel input or operation can be removed under a declared reduction order without changing the decision or violating an acceptance obligation, prove that omitted certificate fields cannot enter the capsule decision, and allow an independent party to replay the exact decision without trusting the production verifier?

The proposed system:

1. evaluates a candidate certificate using a production verifier;
2. captures the acceptance-decision trace;
3. extracts an instance-specific decision slice;
4. converts the slice into a restricted deterministic decision microprogram;
5. binds every microprogram input to:
   - a canonical certificate value commitment;
   - an authenticated profile constant;
   - or an authorized verifier constant;
6. executes the capsule in a small reference decision virtual machine;
7. proves replay equivalence between:
   - the production decision;
   - the capsule decision;
8. applies a deterministic reduction order to remove unnecessary inputs and instructions;
9. generates an irreducibility witness showing that each retained kernel element is required for:
   - decision reproduction;
   - identity reproduction;
   - or profile-obligation satisfaction;
10. generates an omission-barrier witness showing that every omitted certificate field is unreachable from the capsule outputs;
11. emits a public capsule containing:
   - the microprogram;
   - committed inputs;
   - output digest;
   - replay-equivalence witness;
   - irreducibility witness;
   - omission-barrier witness;
   - acceptance-obligation witness.

The principal claim does not require:

- general-purpose taint propagation;
- a complete byte-level parse graph;
- mutation testing;
- multiple verifier engines;
- program-version differencing;
- counterfactual execution;
- group testing;
- binary rewriting;
- remote attestation;
- one cryptographic proof system;
- one parser language;
- one operating system.

This reduces exposure to the broad provenance and dataflow fields while retaining a strongly technical and externally inspectable artifact.

---

# 3. Revised scores

## 3.1 Direction examined

### Bidirectional Parse-to-Decision Evidence Exhaustion with Decision-Input Closure

| Category | Revised score |
|---|---:|
| **Novelty risk** | **6.0/10** |
| **Obviousness risk** | **8.0/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **5.5/10** |
| **Ease of enforcing the patent** | **9.0/10** |
| **Ease for competitors to design around** | **6.0/10** |

## 3.2 Replacement direction

### Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs

| Category | Score |
|---|---:|
| **Novelty risk** | **4.0/10** |
| **Obviousness risk** | **5.5/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **4.0/10** |
| **Ease of enforcing the patent** | **9.5/10** |
| **Ease for competitors to design around** | **3.0/10** |

## 3.3 Comparative assessment

| Category | Evidence-consumption closure | Decision-kernel capsule | Change |
|---|---:|---:|---:|
| Novelty risk | 6.0 | 4.0 | **2.0 lower** |
| Obviousness risk | 8.0 | 5.5 | **2.5 lower** |
| Subject-matter/technicality risk | 1.5 | 1.5 | **No material change** |
| Freedom-to-operate risk | 5.5 | 4.0 | **1.5 lower** |
| Ease of enforcing | 9.0 | 9.5 | **0.5 better** |
| Ease of design-around | 6.0 | 3.0 | **3.0 harder for competitors** |

The replacement remains exposed to:

- program slicing;
- partial evaluation;
- reduced programs;
- proof-carrying code;
- policy compilation;
- bytecode verification;
- verifiable computation;
- minimal proof cores;
- execution attestation;
- symbolic reduction;
- program specialization.

Its improved position depends on the complete interaction:

```text
instance-specific verifier decision slice
    +
restricted deterministic decision microprogram
    +
committed evidence-input slots
    +
production-to-capsule replay equivalence
    +
deterministic reduction order
    +
kernel irreducibility witness
    +
omitted-field reachability barrier
    +
acceptance-obligation coverage
    +
portable independently executable capsule
```

---

# 4. Direction examined

## Bidirectional Parse-to-Decision Evidence Exhaustion with Decision-Input Closure

The thirteenth-pass architecture was:

```text
certificate bytes
        ↓
byte ownership
        ↓
canonical parse graph
        ↓
runtime rule-input events
        ↓
forward consumption graph
        ↓
final decision

acceptance contract
        ↓
reverse obligation graph
        ↓
required rule inputs
        ↓
required evidence nodes
```

Strong certification required:

- no unowned non-padding bytes;
- no unauthorized parse overlap;
- no ambiguous aliases;
- no unread required evidence;
- no skipped required rule;
- no unauthorized decision input;
- no ambient input;
- no diagnostic path to identity or acceptance.

The conflict assessment shows that these mechanisms are close to combinations of established parser, provenance, taint, slicing, noninterference, and attestation technologies.

---

# 5. Conflict analysis of the examined direction

## 5.1 Dynamic taint tracking

### US-9171028-B1  
**Method of Maintaining a Large Set of Taint Labels**

### Relevant mechanism

The patent tracks flows of data through a program by:

- associating data with taint storage elements;
- joining taint elements;
- propagating taint information through program operations;
- evaluating conditions at an output or egress.

### Conflict

The forward evidence-consumption graph can be characterized as a specialized dynamic taint graph.

---

## 5.2 Data-taint instrumentation

Relevant retrieved references include:

- **US-20150356282-A1 — Apparatus and Method for Data Taint Tracking**
- **US-20190311131-A1 — Staged Dynamic Taint Flow Inference**
- **US-20140108867-A1 — Dynamic Taint Analysis of Multi-Threaded Programs**
- **US-11354433-B1 — Dynamic Taint Tracking on Mobile Devices**
- **US-9298918-B2 — Taint Injection and Tracking**
- **US-20220197998-A1 — Taint Tracking via Non-Intrusive Bytecode Instrumentation**

### Conflict

Rule-input provenance and source-to-decision paths are close to established taint instrumentation.

---

## 5.3 Static data dependency and reverse analysis

Relevant references include:

- **US-5987252-A — Statically Analyzing a Computer Program for Data Dependencies**
- **US-9817643-B2 — Incremental Interprocedural Dataflow Analysis**
- **US-20140130153-A1 — Sound and Effective Data-Flow Analysis in the Presence of Aliasing**
- **US-20070006151-A1 — Incremental Analysis of Program Properties**

### Conflict

The reverse acceptance-obligation graph can be characterized as a specialized static dependency or slicing graph.

---

## 5.4 Information flow and integrity policy

Relevant references include:

- **US-20120137275-A1 — Tracking Information Flow**
- **US-20170039375-A1 — Simultaneous Definition and Enforcement of Access-Control and Integrity Policies**
- **US-10460112-B2 — Privacy Leakage Detection and Prevention**
- context-sensitive taint and integrity-policy families.

### Conflict

Ambient-input exclusion and diagnostic noninterference are adjacent to known information-flow controls.

---

## 5.5 Parser and canonicalization validation

Established fields include:

- duplicate-key rejection;
- canonical serialization;
- alternate-encoding detection;
- parser differential testing;
- input byte-range provenance;
- schema validation;
- authenticated parsing.

### Conflict

Byte ownership and alias closure may be treated as predictable parser-hardening measures.

---

## 5.6 Execution attestation and proof generation

Relevant references include:

- **US-12619401-B2 — Protecting and Attesting Program Executions Through Shadow Programs**
- **US-12542673-B2 — Efficient Methods for Trusted Remote Program Execution**
- **US-20070039046-A1 — Proof of Execution Using Random Function**
- **US-12010237-B2 — System and Method for Digital Proof Generation**
- **US-8458460-B2 — Digest Generation from Instruction Op-Codes**

### Conflict

A public certificate proving the verifier's trace can be characterized as another attested computation artifact.

---

# 6. Revised risk analysis of the examined direction

## 6.1 Novelty risk — 6.0/10

No reviewed patent appears to claim the complete thirteenth-pass interaction.

The strongest distinctions are:

- exact non-padding byte ownership;
- independently generated reverse obligations;
- equality between required and authorized consumed inputs;
- diagnostic path separation;
- a public closure artifact.

However, the component mechanisms are extensively established.

---

## 6.2 Obviousness risk — 8.0/10

A plausible examiner combination is:

1. canonical parser validation;
2. dynamic taint tracking;
3. static reverse dependency analysis;
4. information-flow noninterference;
5. execution attestation.

Each component performs its expected function.

---

## 6.3 Subject-matter/technicality risk — 1.5/10

The direction is strongly technical.

It operates on:

- encoded bytes;
- parser nodes;
- verifier rule executions;
- data-dependency graphs;
- decision paths;
- authenticated witnesses.

Its weakness is not eligibility.

---

## 6.4 Freedom-to-operate risk — 5.5/10

Implementation may implicate claims concerning:

- taint tracking;
- parser instrumentation;
- data provenance;
- program slicing;
- information-flow enforcement;
- execution attestation;
- authenticated evidence structures.

The exact trace collection, dependency analysis, and proof mechanism affect FTO.

---

## 6.5 Ease of enforcing — 9.0/10

A public closure certificate exposes useful fields.

However, important internal operations may remain difficult to prove:

- whether the reverse graph was genuinely independent;
- whether all runtime reads were captured;
- whether ambient state was fully inventoried;
- whether parser-stage disagreement was detectable.

---

## 6.6 Ease for competitors to design around — 6.0/10

Competitors can offer similar assurance through:

- a formally verified parser;
- static policy verification;
- dynamic taint analysis;
- dual parsers;
- branch coverage;
- mandatory-field checks;
- a tiny verifier;
- proof-carrying code;
- external security evaluation.

---

# 7. Replacement direction

# Portable Decision-Kernel Capsules with Irreducibility and Omission-Barrier Proofs

## 7.1 Technical objective

A production verifier may contain:

- certificate parsing;
- compatibility code;
- diagnostic formatting;
- logging;
- policy loading;
- signature verification;
- relation comparison;
- threshold logic;
- exception handling;
- optional extensions;
- network or storage adapters.

An independent party normally has to trust that the production verifier used the correct subset of this code and evidence for one acceptance decision.

GDKC produces a compact, deterministic, independently replayable decision capsule for the specific decision.

---

# 8. Production decision capture

```text
production_decision_capture:
    evaluation_id
    candidate_certificate_digest
    certificate_profile_hash
    production_verifier_digest

    production_decision_state
    production_decision_digest

    decision_trace_root
    consumed_evidence_root
    consumed_profile_constant_root
```

The decision trace records only operations relevant to:

- subject identity;
- relation classification;
- acceptance;
- required profile obligations.

---

# 9. Instance-specific decision slice

The system extracts a decision slice:

```text
decision_slice:
    slice_id
    production_verifier_digest
    candidate_certificate_digest

    retained_operation_ids
    retained_input_ids
    retained_profile_constant_ids
    retained_obligation_ids

    omitted_operation_root
    omitted_input_root
    slice_root
```

The slice is instance-specific.

It is not a general reduced version of the entire verifier.

---

# 10. Restricted decision microprogram

The slice is compiled into a restricted deterministic instruction set.

Suggested instruction classes:

```text
LOAD_COMMITTED_INPUT
LOAD_PROFILE_CONSTANT
VERIFY_COMMITMENT
VERIFY_SIGNATURE_STATUS
COMPARE_EXACT
COMPARE_SEMANTIC
COMPARE_THRESHOLD
BOOL_AND
BOOL_OR
BOOL_NOT
SELECT_ENUM
ASSERT_REQUIRED_STATE
ASSERT_OBLIGATION
EMIT_IDENTITY_DIGEST
EMIT_RELATION_STATE
EMIT_ACCEPTANCE_STATE
```

Excluded instructions include:

```text
NETWORK_READ
FILESYSTEM_READ
CLOCK_READ
RANDOM_READ
DYNAMIC_CODE_LOAD
UNBOUNDED_LOOP
UNDECLARED_MEMORY_ACCESS
```

---

# 11. Decision-kernel input table

```text
decision_kernel_input:
    kernel_input_id
    input_class

    source_certificate_path
    source_value_commitment
    source_evidence_root

    profile_obligation_ids
    output_influence_class

    kernel_input_hash
```

Input classes:

```text
CERTIFICATE_EVIDENCE
PROFILE_CONSTANT
VERIFIER_CONSTANT
DERIVED_KERNEL_VALUE
```

Output influence classes:

```text
IDENTITY
RELATION
ACCEPTANCE
OBLIGATION_ONLY
```

Diagnostic-only values are excluded from the principal decision kernel unless a profile obligation explicitly requires them.

---

# 12. Portable decision capsule

```text
portable_decision_kernel_capsule:
    capsule_version

    candidate_certificate_digest
    certificate_profile_hash
    production_verifier_digest

    decision_vm_contract_hash
    decision_microprogram_root
    decision_kernel_input_root
    profile_obligation_root

    expected_identity_digest
    expected_relation_digest
    expected_acceptance_state
    expected_decision_digest

    replay_equivalence_witness_root
    irreducibility_witness_root
    omission_barrier_witness_root
    obligation_coverage_witness_root

    capsule_state
    capsule_hash
```

---

# 13. Capsule replay

A small reference decision virtual machine executes:

```text
decision_microprogram
    +
committed kernel inputs
    +
authenticated profile constants
```

and produces:

```text
capsule_identity_digest
capsule_relation_digest
capsule_acceptance_state
capsule_decision_digest
```

Strong replay requires exact equality with the production capture.

---

# 14. Replay-equivalence witness

```text
replay_equivalence_witness:
    production_decision_digest
    capsule_decision_digest

    production_identity_digest
    capsule_identity_digest

    production_relation_digest
    capsule_relation_digest

    production_acceptance_state
    capsule_acceptance_state

    trace_correspondence_root
    equivalence_state
```

States:

```text
EXACT_DECISION_EQUIVALENCE
IDENTITY_MISMATCH
RELATION_MISMATCH
ACCEPTANCE_MISMATCH
TRACE_MAPPING_INCOMPLETE
UNAUTHORIZED_CAPSULE_INPUT
```

---

# 15. Deterministic kernel reduction

The capsule generator applies a declared reduction order.

Example order:

```text
1. remove unused diagnostic values
2. remove unreachable operations
3. remove duplicate computations
4. replace constant subgraphs with committed constants
5. remove inputs not reaching an output or obligation
6. remove instructions whose removal preserves all required outputs
7. canonicalize commutative operation order
```

The reduction order is part of the profile.

This avoids claiming globally smallest code, which may be computationally difficult.

---

# 16. Irreducibility witness

The kernel is **reduction-order irreducible**, not necessarily globally minimal.

For each retained element:

```text
kernel_irreducibility_record:
    retained_element_id
    retained_element_class

    attempted_reduction_id
    reduced_capsule_hash

    reduction_failure_class
    affected_output_ids
    affected_obligation_ids

    record_hash
```

Failure classes:

```text
DECISION_CHANGED
IDENTITY_CHANGED
RELATION_CHANGED
ACCEPTANCE_CHANGED
OBLIGATION_VIOLATED
INPUT_ANCESTRY_BROKEN
CAPSULE_INVALID
```

A retained element is justified when the declared reduction step cannot remove it while preserving all required capsule outputs and obligations.

---

# 17. Omission-barrier proof

The capsule must also prove that excluded certificate fields cannot enter the capsule result.

```text
omission_barrier_witness:
    full_certificate_field_root
    retained_certificate_field_root
    omitted_certificate_field_root

    kernel_input_path_root
    omitted_to_kernel_reachability_root

    unauthorized_omitted_path_count
    barrier_state
```

Strong state requires:

```text
unauthorized_omitted_path_count = 0
```

Barrier states:

```text
OMISSION_BARRIER_CLOSED
OMITTED_FIELD_REACHES_KERNEL
UNKNOWN_FIELD_MAPPING
INPUT_PATH_INCOMPLETE
```

---

# 18. Acceptance-obligation coverage

The certificate profile defines required obligations.

```text
acceptance_obligation:
    obligation_id
    required_relation
    required_input_classes
    required_output_state
```

The capsule contains:

```text
obligation_coverage_witness:
    profile_obligation_root
    covered_obligation_root
    uncovered_obligation_root

    obligation_to_instruction_root
    obligation_to_input_root

    uncovered_obligation_count
```

Strong state requires:

```text
uncovered_obligation_count = 0
```

---

# 19. Capsule state

Suggested states:

```text
DECISION_KERNEL_VALID
PRODUCTION_REPLAY_MISMATCH
KERNEL_NOT_IRREDUCIBLE
OMISSION_BARRIER_OPEN
OBLIGATION_COVERAGE_INCOMPLETE
UNAUTHORIZED_INPUT
UNSUPPORTED_INSTRUCTION
INVALID_PROFILE
INVALID_CAPSULE
```

Only `DECISION_KERNEL_VALID` supports the strong Glyphser guarantee.

---

# 20. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising evaluating a candidate execution certificate using a production verifier and recording a production acceptance decision and a decision trace; extracting, from the decision trace, an instance-specific decision slice comprising certificate evidence values, profile constants, and decision operations contributing to one or more of a subject-identity output, a relation output, an acceptance output, and a profile-obligation output; compiling the decision slice into a restricted deterministic decision microprogram executable by a reference decision virtual machine; binding each input of the decision microprogram to a committed certificate value or an authenticated profile or verifier constant; executing the decision microprogram to generate capsule outputs; determining exact replay equivalence between the capsule outputs and corresponding outputs of the production verifier; applying a profile-defined deterministic reduction order to the decision microprogram and its inputs; generating an irreducibility witness identifying, for each retained decision-microprogram element, a reduction attempt that changes a required output, violates a profile obligation, or breaks committed input ancestry; generating an omission-barrier witness showing that certificate fields omitted from the decision microprogram have no authorized path to the capsule outputs; generating an obligation-coverage witness showing that every acceptance obligation is represented by at least one retained input and retained decision operation; and issuing a portable decision-kernel capsule bound to the candidate execution certificate, production verifier, decision microprogram, committed inputs, replay-equivalence witness, irreducibility witness, omission-barrier witness, and obligation-coverage witness.

The strongest limitations are:

1. one production decision capture;
2. an instance-specific verifier decision slice;
3. a restricted deterministic decision microprogram;
4. committed capsule inputs;
5. independent capsule replay;
6. exact production-to-capsule output equivalence;
7. a profile-defined deterministic reduction order;
8. retained-element irreducibility records;
9. omitted-field reachability exclusion;
10. acceptance-obligation coverage;
11. a public portable capsule.

---

# 21. Closest prior-art categories and references

## 21.1 Program slicing and dependency reduction

Relevant retrieved references include:

- **US-5987252-A — Statically Analyzing a Computer Program for Data Dependencies**
- **US-20070006151-A1 — Incremental Analysis of Program Properties**
- **US-20140068567-A1 — Determining Relevant Events in Source Code Analysis**
- **US-6077311-A — Program Region Extraction**
- dynamic slicing and dataflow-analysis families.

### Difference

GDKC extracts an instance-specific acceptance-decision capsule, not a general source-code slice.

The capsule also contains replay equivalence, irreducibility, omission-barrier, and obligation-coverage evidence.

---

## 21.2 Symbolic reduction and reduced verification programs

Relevant references include:

- **US-20120151271-A1 — MAT-Reduced Symbolic Analysis**
- **US-8359578-B2 — Symbolic Reduction of Dynamic Executions**
- **US-20070074210-A1 — Optimal Stateless Search**
- symbolic execution and abstraction families.

### Difference

The principal claim should not require symbolic execution.

The output is a concrete deterministic microprogram for one certificate decision.

---

## 21.3 Proof-carrying code and certified software

Relevant references include:

- **US-7937692-B2 — Complete Static Analysis and Software Distribution Certification**
- **WO-2023060525-A1 — Generating Verifiable Software Releases**
- proof-carrying-code and certified compilation families;
- **US-20110185345-A1 — Type-Preserving Compiler for Security Verification**.

### Difference

GDKC does not certify the safety of the program under test.

It carries the minimal replayable acceptance decision for one certificate evaluation.

---

## 21.4 Execution attestation and shadow programs

Relevant references include:

- **US-12619401-B2 — Protecting and Attesting Program Executions Through Shadow Programs**
- **US-12542673-B2 — Efficient Methods for Trusted Remote Program Execution**
- **US-20070039046-A1 — Proof of Execution Using Random Function**

### Difference

A GDKC capsule is not a shadow execution of the certified program.

It is a portable replay of the verifier's acceptance decision.

---

## 21.5 Digital proof generation

Relevant references include:

- **US-12010237-B2 — System and Method for Digital Proof Generation**
- **US-11088823-B2 — Pinocchio/Trinocchio on Authenticated Data**
- **US-12500768-B2 — Facilitating Zero-Knowledge Proofs**

### Difference

The principal claim should remain independent of zero-knowledge proof systems.

Its distinguishing features are decision slicing, deterministic reduction, irreducibility, omission barrier, and obligation coverage.

---

## 21.6 Output-uniqueness and proof generation

### US-20170010957-A1  
**Multithreaded Program Output Uniqueness Testing and Proof Generation**

### Relevant mechanism

The application constructs program constraints and generates proofs concerning output uniqueness.

### Difference

GDKC reproduces one verifier decision through a concrete restricted microprogram and proves the capsule's relation to the production evaluation.

---

## 21.7 Partial evaluation and policy compilation

Established fields include:

- specializing a program for known inputs;
- compiling policies into executable decision graphs;
- reducing rule engines;
- generating minimal policy evaluators.

### Difference

GDKC requires:

- production-decision equivalence;
- reduction-order irreducibility;
- an omitted-field reachability barrier;
- profile-obligation coverage;
- a public capsule.

A fresh search should focus heavily on these fields.

---

# 22. Replacement-direction risk analysis

## 22.1 Novelty risk — 4.0/10

The component technologies are known:

- program slicing;
- partial evaluation;
- policy compilation;
- bytecode execution;
- proof-carrying code;
- execution attestation;
- minimal proof cores;
- dependency analysis.

The reviewed patent material did not identify one reference claiming the complete interaction:

```text
instance-specific certificate decision slice
    +
restricted deterministic decision microprogram
    +
committed capsule inputs
    +
exact production-decision replay
    +
deterministic reduction-order irreducibility
    +
omitted-field reachability barrier
    +
acceptance-obligation coverage
    +
portable public capsule
```

A fresh search is required before relying on this assessment.

---

## 22.2 Obviousness risk — 5.5/10

A plausible examiner combination is:

1. dynamic or static program slicing;
2. partial evaluation;
3. policy compilation;
4. proof-carrying code;
5. execution attestation.

The strongest inventive-step argument is the technical interaction:

- the capsule is generated for one certificate and one completed production decision;
- it reproduces identity, relation, acceptance, and obligation outputs;
- it is reduced under a declared deterministic order;
- every retained element has a failed reduction witness;
- every omitted field is subject to a reachability barrier;
- every profile obligation is mapped into the capsule;
- the capsule is independently replayable.

---

## 22.3 Subject-matter/technicality risk — 1.5/10

The replacement is strongly technical.

It operates on:

- verifier execution traces;
- program slices;
- deterministic bytecode;
- committed evidence values;
- decision virtual machines;
- replay digests;
- reduction witnesses;
- reachability barriers;
- executable capsule artifacts.

It reduces verifier code and data required for independent decision reproduction.

---

## 22.4 Freedom-to-operate risk — 4.0/10

FTO risks include:

- program slicing;
- partial evaluation;
- policy compilation;
- reduced programs;
- proof-carrying code;
- verifiable computation;
- execution attestation.

Risk is reduced because the principal claim can remain neutral regarding:

- the slicing algorithm;
- the verifier language;
- the decision virtual machine encoding;
- the commitment scheme;
- the signature scheme;
- the certificate format;
- the operating system;
- the hardware trust mechanism.

---

## 22.5 Ease of enforcing — 9.5/10

A conforming product would likely expose:

- capsule hash;
- candidate certificate digest;
- production verifier digest;
- decision VM contract;
- microprogram root;
- kernel input root;
- expected decision digest;
- replay-equivalence state;
- retained input count;
- retained instruction count;
- irreducibility record count;
- omitted-field root;
- omission-barrier state;
- covered-obligation count;
- capsule state.

A competitor advertising:

> “We generate a minimal portable verifier capsule that independently reproduces the exact certificate decision and proves that omitted evidence cannot affect it”

would expose the central method.

The capsule is directly inspectable and executable.

---

## 22.6 Ease for competitors to design around — 3.0/10

Competitors can avoid the claim by:

### Publishing the full verifier

This avoids extraction of a decision kernel but preserves a much larger trusted code base and attack surface.

### Publishing only a decision trace

This does not provide a portable executable replay.

### Publishing a policy explanation

This does not prove exact production-decision equivalence.

### Using a formally verified verifier

This may substitute for some assurance but requires substantially greater engineering effort.

### Generating an unreduced replay program

This avoids irreducibility but produces a materially larger and less auditable artifact.

### Omitting the omission barrier

This cannot prove that excluded certificate fields are irrelevant.

A competitor seeking the same combination of:

- small trusted decision code;
- exact independent replay;
- evidence reduction;
- omitted-field exclusion;
- obligation coverage;
- public inspection;

has few practical substitutes.

---

# 23. Enforcement-focused design

## 23.1 Mandatory public fields

To maximize enforceability, every strong capsule should expose:

```text
candidate_certificate_digest
certificate_profile_hash
production_verifier_digest
decision_vm_contract_hash
decision_microprogram_root
decision_kernel_input_root
profile_obligation_root
expected_identity_digest
expected_relation_digest
expected_acceptance_state
expected_decision_digest
replay_equivalence_witness_root
irreducibility_witness_root
omission_barrier_witness_root
obligation_coverage_witness_root
retained_input_count
retained_instruction_count
omitted_field_count
uncovered_obligation_count
capsule_state
capsule_hash
```

---

## 23.2 Public replay engine

Glyphser should provide a small reference VM that:

1. verifies the capsule;
2. opens committed inputs;
3. executes the microprogram;
4. reproduces identity, relation, and acceptance outputs;
5. checks replay equivalence;
6. checks irreducibility records;
7. checks omission-barrier evidence;
8. checks obligation coverage.

---

## 23.3 Product commands

```text
glyphser decision-kernel capture
glyphser decision-kernel extract
glyphser decision-kernel reduce
glyphser decision-kernel replay
glyphser decision-kernel verify
glyphser decision-kernel inspect
```

Suggested API surfaces:

```text
POST /decision-kernels/capture
POST /decision-kernels/extract
POST /decision-kernels/reduce
POST /decision-kernels/replay
POST /decision-kernels/verify
GET  /decision-kernels/{id}
```

---

# 24. Anti-design-around claim strategy

## 24.1 Separate capsule replay from irreducibility

Use independent claims for:

### Portable decision replay

A restricted microprogram reproduces the production decision.

### Reduction-order irreducibility

Each retained element has a failed-reduction witness.

A competitor should not escape by omitting one feature.

---

## 24.2 Separate omission barrier

A competitor may generate a replay capsule while leaving omitted-field influence unresolved.

Use an independent claim for the omitted-to-kernel reachability barrier.

---

## 24.3 Claim multiple output classes

Do not limit the capsule to one Boolean decision.

Cover:

- identity digest;
- relation states;
- acceptance state;
- obligation state;
- selected result classifications.

---

## 24.4 Claim profile-obligation coverage

A competitor may reproduce the final Boolean result while skipping required intermediate policy obligations.

Claim obligation-to-input and obligation-to-instruction mappings.

---

## 24.5 Claim production trace correspondence

A competitor may independently reimplement the policy.

Claim correspondence between production decision operations and capsule instructions.

---

## 24.6 Claim deterministic reduction order

Avoid requiring global minimality.

Claim a profile-bound reduction sequence and irreducibility under that sequence.

---

## 24.7 Claim capsule challenge openings

Permit independent opening of:

- one kernel input;
- one instruction;
- one trace correspondence;
- one irreducibility record;
- one omitted-field barrier path;
- one obligation mapping.

This strengthens proof and enforcement.

---

# 25. Recommended claim families

## Family A — Instance-specific verifier decision slicing

Protect extraction of one completed decision.

## Family B — Restricted deterministic decision microprogram

Protect the portable capsule execution format.

## Family C — Committed decision-kernel inputs

Protect certificate-value and profile-constant bindings.

## Family D — Production-to-capsule replay equivalence

Protect exact reproduction of multiple output classes.

## Family E — Deterministic reduction order

Protect canonical kernel reduction.

## Family F — Kernel irreducibility witnesses

Protect retained-element necessity under the reduction order.

## Family G — Omission-barrier proof

Protect exclusion of omitted certificate fields.

## Family H — Acceptance-obligation coverage

Protect required intermediate policy obligations.

## Family I — Portable capsule verification

Protect independent execution and validation.

## Family J — Capsule comparison across verifier versions

Protect detection that two production verifiers generate different kernels or decisions for the same certificate.

---

# 26. Technical evidence needed before filing

## 26.1 Exact replay

For a production verifier decision, demonstrate that the capsule reproduces:

```text
identity digest
relation digest
acceptance state
decision digest
```

exactly.

---

## 26.2 Unused code removal

Remove logging, diagnostics, compatibility handlers, and unused policy branches.

Demonstrate that capsule output remains equivalent.

---

## 26.3 Retained-input irreducibility

For every retained input, attempt removal or authorized neutralization.

The witness must show:

- decision change;
- output change;
- obligation violation;
- or ancestry break.

---

## 26.4 Retained-instruction irreducibility

For every retained instruction, attempt removal under the declared reduction order.

The capsule must fail equivalence or obligation coverage.

---

## 26.5 Omitted-field influence challenge

Create an omitted diagnostic or extension field that the production verifier accidentally uses.

The omission barrier must detect a path into the kernel.

---

## 26.6 Boolean-only false replay

Construct a capsule that reproduces only `ACCEPTED` but not the same relation or identity digest.

The replay-equivalence checker must reject it.

---

## 26.7 Obligation omission

Remove an intermediate mandatory obligation while preserving the final Boolean result.

The obligation-coverage witness must fail.

---

## 26.8 Unauthorized instruction

Insert a clock, randomness, filesystem, or network instruction into the capsule.

The reference VM must reject it.

---

## 26.9 Cross-verifier comparison

Run two production verifier versions on the same candidate certificate.

Compare:

- decision outputs;
- retained inputs;
- microprograms;
- obligation mappings.

This can reveal semantic verifier drift.

---

## 26.10 Performance benchmark

Measure:

- production verifier size;
- capsule size;
- production verifier dependencies;
- capsule dependencies;
- replay time;
- retained input percentage;
- retained instruction percentage;
- independent audit time.

---

# 27. Glyphser implementation path

## 27.1 New schemas

```text
production_decision_capture.v1
instance_decision_slice.v1
decision_microprogram.v1
decision_kernel_input.v1
replay_equivalence_witness.v1
kernel_irreducibility_record.v1
omission_barrier_witness.v1
obligation_coverage_witness.v1
portable_decision_kernel_capsule.v1
decision_kernel_comparison.v1
```

## 27.2 Suggested modules

```text
runtime/glyphser/decision_kernel/capture.py
runtime/glyphser/decision_kernel/slice.py
runtime/glyphser/decision_kernel/compile.py
runtime/glyphser/decision_kernel/vm.py
runtime/glyphser/decision_kernel/inputs.py
runtime/glyphser/decision_kernel/replay.py
runtime/glyphser/decision_kernel/reduce.py
runtime/glyphser/decision_kernel/irreducibility.py
runtime/glyphser/decision_kernel/omission.py
runtime/glyphser/decision_kernel/obligations.py
runtime/glyphser/decision_kernel/capsule.py
runtime/glyphser/decision_kernel/verify.py
```

## 27.3 Suggested quality gates

```text
tooling/quality_gates/decision_capture_gate.py
tooling/quality_gates/decision_slice_gate.py
tooling/quality_gates/decision_microprogram_gate.py
tooling/quality_gates/kernel_input_binding_gate.py
tooling/quality_gates/replay_equivalence_gate.py
tooling/quality_gates/kernel_irreducibility_gate.py
tooling/quality_gates/omission_barrier_gate.py
tooling/quality_gates/obligation_coverage_gate.py
tooling/quality_gates/portable_capsule_gate.py
```

## 27.4 Required adversarial fixtures

```text
capsule_uses_wrong_certificate
capsule_uses_wrong_profile
capsule_uses_wrong_verifier_digest
kernel_input_commitment_mismatch
profile_constant_substitution
unauthorized_vm_instruction
clock_read_in_capsule
random_read_in_capsule
filesystem_read_in_capsule
network_read_in_capsule
capsule_reproduces_boolean_only
identity_digest_mismatch
relation_digest_mismatch
acceptance_state_mismatch
trace_correspondence_incomplete
retained_input_removable
retained_instruction_removable
omitted_field_reaches_kernel
omitted_field_mapping_unknown
required_obligation_uncovered
irreducibility_record_from_other_capsule
capsule_replayed_for_other_certificate
```

---

# 28. Features to exclude from the principal claim

Do not make these essential:

- a complete byte-level parse graph;
- general dynamic taint tracking;
- mutation testing;
- multiple verifier engines;
- program-version differencing;
- binary rewriting;
- counterfactual execution;
- group testing;
- remote attestation;
- zero-knowledge proofs;
- blockchain;
- TPM;
- TEE;
- one slicing algorithm;
- one virtual-machine encoding;
- one commitment scheme;
- one signature scheme;
- one operating system;
- one processor architecture;
- one ML framework.

They may appear as optional embodiments or dependent claims.

---

# 29. Filing strategy

## Principal independent method claim

Require:

- production decision capture;
- instance-specific decision slice;
- restricted deterministic microprogram;
- committed inputs;
- exact replay equivalence;
- deterministic reduction order;
- irreducibility witnesses;
- omission barrier;
- obligation coverage;
- public portable capsule.

## Separate system claim

Claim components such as:

- decision-trace collector;
- decision slicer;
- microprogram compiler;
- decision VM;
- kernel reducer;
- irreducibility analyzer;
- omission-barrier analyzer;
- obligation mapper;
- capsule generator;
- capsule verifier.

## Separate capsule claim

Claim the machine-readable portable decision-kernel capsule and its independent replay process where permitted.

## Continuation applications

Potential continuation families:

1. verifier decision slicing;
2. decision microprogram restrictions;
3. committed kernel inputs;
4. replay equivalence;
5. reduction-order irreducibility;
6. omission barriers;
7. obligation coverage;
8. cross-verifier kernel comparison.

---

# 30. Final recommendation

The parse-to-decision evidence-exhaustion direction is no longer the strongest filing candidate because its core mechanisms can be assembled from established fields covering:

- dynamic taint tracking;
- static dataflow analysis;
- program slicing;
- parser canonicalization;
- information-flow noninterference;
- execution attestation;
- authenticated evidence structures.

Replace it with:

> **A certificate-verification protocol that captures one completed production-verifier decision, extracts an instance-specific decision slice, compiles the slice into a restricted deterministic microprogram using only committed certificate values and authenticated constants, independently replays the microprogram to reproduce the production identity, relation, acceptance, and obligation outputs, applies a deterministic reduction order, proves that every retained input and instruction resists an authorized reduction attempt, proves that omitted certificate fields cannot reach the capsule outputs, and issues a portable decision-kernel capsule containing replay-equivalence, irreducibility, omission-barrier, and obligation-coverage witnesses.**

This direction is better because it:

- moves away from general-purpose taint and provenance tracking;
- creates a small independently executable artifact rather than a large trace graph;
- reduces the trusted verifier code required to reproduce one decision;
- proves exact production-decision equivalence;
- avoids the difficult claim of global minimality;
- proves irreducibility under a declared deterministic reduction order;
- proves that excluded evidence cannot influence the capsule;
- preserves mandatory acceptance obligations rather than only a final Boolean result;
- produces unusually strong public infringement evidence;
- supports direct independent replay and inspection;
- makes full-verifier publication, ordinary decision traces, and policy explanations materially weaker substitutes;
- forces competitors seeking the same small trusted decision artifact to implement comparable slicing, replay, reduction, omission-barrier, and obligation-coverage mechanisms;
- supports multiple independent claim families that reduce design-around risk;
- was not matched by one patent containing the complete instance-specific decision-slice, exact replay, reduction-order irreducibility, omission-barrier, obligation-coverage, and portable-capsule interaction in the patent material reviewed to date.

---

# 31. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh broad prior-art search after restoring patent-search credits;
2. searches specifically focused on:
   - verifier decision slicing;
   - policy-decision program specialization;
   - portable reduced verifier generation;
   - minimal executable proof kernels;
   - irreducible program slices;
   - partial evaluation of policy engines;
   - replayable decision explanations;
   - omitted-input noninfluence proofs;
   - proof-carrying decision capsules;
3. limitation-by-limitation claim charts against slicing, partial evaluation, proof-carrying-code, reduced-program, policy-compilation, and attestation families;
4. prosecution-history review of the closest program-slicing and proof-carrying-code patents;
5. jurisdiction-specific FTO analysis;
6. review of the exact deterministic decision VM and reduction order;
7. review of the omission-barrier and obligation-coverage implementations;
8. review of the Glyphser repository's public-disclosure history;
9. inventorship analysis;
10. non-patent literature search on:
    - program slicing;
    - partial evaluation;
    - proof kernels;
    - policy compilation;
    - minimal unsatisfiable and sufficient cores;
    - proof-carrying code;
    - decision provenance;
    - verified interpreters;
    - software debloating;
    - executable explanations.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
