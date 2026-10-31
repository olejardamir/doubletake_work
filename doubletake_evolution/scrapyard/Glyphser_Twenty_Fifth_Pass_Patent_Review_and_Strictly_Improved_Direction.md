# Glyphser Patent Direction
## Twenty-Fifth-Pass Conflict Review, Corrected Risk Scores, Patentability Score, and Strictly Improved Replacement Architecture

**Review date:** July 18, 2026  
**Direction re-examined:** *Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization*  
**Prior protocol name:** **Glyphser Acceptance-Code Machine — GACM**  
**Replacement direction:** *Post-Commit Obligation Cross-Witness Cycles with Challenge-Derived Acceptance Closure*  
**Suggested replacement protocol name:** **Glyphser Cross-Witness Closure Machine — GCWM**

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the exact claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation:** This pass used public patent-index searches, patent-document records, the references accumulated in the preceding Glyphser reviews, and additional searches directed to control-flow signatures, encoded state machines, runtime check sequences, workflow-completion signatures, error syndromes, cryptographic accumulators, proof of execution, challenge-response protocols, commit-and-reveal testing, random permutation, and redundant distributed computation. A paid full-corpus novelty report was unavailable because the connected novelty-search service had insufficient credits, and the official patent-office connector was not configured. The search therefore cannot exclude unpublished applications, unindexed records, non-English prior art, source code, standards work, academic papers, or confidential commercial implementations.
>
> **Score correction rule:** The twenty-fourth-pass document gave GACM highly optimistic scores, including 1.75/10 novelty risk, 3.25/10 obviousness risk, 9.75/10 enforcement, 1.50/10 design-around risk, and 9.15/10 patentability. The deeper search found materially closer active patents in runtime control-flow signatures, deterministic execution check sequences, encoded finite-state-machine error detection, workflow-step completion signatures, error-syndrome calculation, cryptographic accumulators, and proof-of-execution certificates. The strict-improvement comparison therefore uses the **corrected GACM scores produced by this deeper pass**, not the superseded optimistic scores.

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

The twenty-fourth-pass GACM direction should not remain the principal Glyphser patent nucleus.

GACM proposed:

- compiling mandatory verification obligations into obligation-indexed code lanes;
- deriving run-specific generator contributions bound to subject, profile, comparator, evidence requirement, and nonce;
- coupling relation comparators to code-symbol emission;
- requiring exactly one contribution per mandatory obligation lane;
- representing proof-backed non-applicability in the same lane;
- separating diagnostic contributions from acceptance contributions;
- combining contributions into a nonseparable acceptance word;
- calculating a fault syndrome for missing, duplicated, substituted, or replayed contributions;
- localizing faults to obligation lanes;
- decoding a usable accepted certificate object only from the canonical word;
- issuing a public codeword and syndrome receipt.

The deeper search shows that the operational centre of GACM is much closer to known execution-signature, encoded-state, error-checking, and workflow-completion systems than the prior review recognized.

The most damaging additional references include:

- **[US-8904189-B1 — System and Method for Validating Program Execution at Run-Time Using Control Flow Signatures](https://patents.google.com/patent/US8904189B1/en)**
  - generates a hash associated with execution of instruction sequences;
  - compares runtime hashes with reference signatures;
  - conditionally produces an authorization signal;
  - remains active and belongs to a continuation family.

- **[US-9230122-B2](https://patents.google.com/patent/US9230122B2/en) and [US-9762399-B2](https://patents.google.com/patent/US9762399B2/en) — Continuations in the Control-Flow-Signature Family**
  - extend runtime control-flow signature verification over instruction blocks and execution sequences;
  - materially weaken broad claims to execution-coupled symbol generation and authorization from a matching execution representation.

- **[US-10831595-B1 / US-20200379841-A1 — Performing Error Detection During Deterministic Program Execution](https://patents.google.com/patent/US20200379841A1/en)**
  - determines a precomputed check sequence before execution;
  - determines a runtime check sequence during execution;
  - compares the sequences to identify errors in deterministic program execution.

- **[US-8161366-B2 — Finite State Machine Error Recovery](https://patents.google.com/patent/US8161366B2/en)**
  - encodes valid finite-state-machine states;
  - detects invalid state transitions from encoded state values;
  - blocks or redirects invalid transitions.

- **[US-11018853-B2 — Workflow Management via Distributed Ledgers and Smart Contracts](https://patents.google.com/patent/US11018853/en)**
  - assigns identifiers to workflow steps;
  - records completion states and cryptographic signatures;
  - verifies completion of all required steps before treating a workflow as complete.

- **[US-12009837-B2 / US-20230318628-A1 — Syndrome Calculation for Error Detection and Error Correction](https://patents.google.com/patent/US20230318628A1/en)**
  - calculates syndromes from encoded data;
  - detects and locates errors;
  - creates active FTO sensitivity when GACM is implemented with conventional syndrome circuitry or patented memory-code structures.

- **[US-9098725-B2 — Cryptographic Accumulators for Authenticated Hash Tables](https://patents.google.com/patent/US9098725B2/en)**
  - authenticates accumulated collections through digest and update structures;
  - weakens broad claims to exact-set commitments and authenticated aggregate participation.

- **[US-7877604-B2 — Proof of Execution Using Random Function](https://patents.google.com/patent/US7877604B2/en)**
  - generates a third-party-verifiable proof that a specific computation executed;
  - binds proof generation to execution under a controlled security program.

The GACM inventive centre can therefore be characterized as:

```text
mandatory execution units
    +
execution-coupled symbols or signatures
    +
encoded valid-state representation
    +
aggregate completion structure
    +
error syndrome
    +
fault localization
    +
authorization from a matching encoded state
    +
public receipt
```

Those mechanisms are individually mature, and several active families cover combinations close enough to create substantial novelty, obviousness, and FTO pressure.

## Replacement decision

Retire this as the principal filing direction:

> **Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization**

Retain only as optional embodiments:

- obligation-indexed result commitments;
- multiplicity checks;
- replay-resistant result binding;
- diagnostic non-convertibility;
- codeword, accumulator, or syndrome implementations;
- fault-localization metadata.

Proceed instead with:

# **Post-Commit Obligation Cross-Witness Cycles with Challenge-Derived Acceptance Closure**

The replacement solves a different and narrower technical problem:

> A static codeword, aggregate signature, accumulator, bitmap, Merkle root, or signed workflow can be constructed by the same controller that issues the final acceptance decision. Even when obligation results are labeled and committed, a defective or malicious controller may fabricate packets after learning the aggregate format, omit a comparator while synthesizing its expected result, duplicate one result under another obligation identifier, replay a packet from another run, or generate a receipt after a separate acceptance path has already succeeded. How can the verifier prove, through publicly testable behavior, that every mandatory obligation produced a subject-bound and evidence-bound result **before** an unpredictable audit topology was known, that every committed result then participated exactly once in a challenge-derived all-obligation cross-witness structure, and that no accepted certificate object can be constructed unless that structure closes?

GCWM uses a two-stage obligation comparator.

In stage one, every mandatory obligation comparator produces:

1. a frozen result packet;
2. a pre-challenge packet commitment;
3. sealed local responder state generated as part of the comparator operation.

The complete packet set is frozen into a packet-set root before any audit challenge is available.

After freezing, an independent challenger nonce or public challenge value deterministically generates a run-specific permutation of all mandatory obligations. The permutation defines a single-cover directed cycle, or another profile-authorized strongly connected one-in/one-out topology.

Each comparator-integrated responder must then generate:

- an outgoing cross-witness bound to its own frozen result packet and its challenge-selected successor packet;
- an incoming acknowledgement bound to its own frozen packet and its challenge-selected predecessor packet.

The cross-witness pair is valid only when:

- the local result packet was committed before the challenge;
- the local result is acceptance-capable or validly non-applicable;
- subject, profile, comparator, evidence, build, and run bindings match;
- the predecessor and successor assignments match the challenge-derived topology;
- each mandatory packet has exactly one incoming and one outgoing verified link;
- the topology contains every mandatory packet exactly once;
- the topology closes as one authorized all-obligation structure.

The final accepted certificate object is constructed only from the verified closure object. There is no independently constructible `PASS` path.

This removes the following from the principal inventive centre:

- error-correcting codes;
- syndrome arithmetic;
- canonical codewords;
- cryptographic accumulators;
- control-flow signatures;
- precomputed execution check sequences;
- encoded finite-state-machine states;
- secret sharing;
- policy-controlled key release;
- blockchain workflow completion;
- a trusted execution environment;
- a fixed hash chain.

---

# 3. Revised scores

## 3.1 GACM — corrected after deeper conflict review

### Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization

| Category | Corrected score |
|---|---:|
| **Novelty risk** | **5.25/10** |
| **Obviousness risk** | **7.75/10** |
| **Subject-matter/technicality risk** | **0.35/10** |
| **Freedom-to-operate risk** | **5.50/10** |
| **Ease of enforcing the patent** | **7.25/10** |
| **Ease for competitors to design around** | **6.50/10** |
| **Patentability score** | **4.70/10** |

## 3.2 Replacement direction

### Post-Commit Obligation Cross-Witness Cycles with Challenge-Derived Acceptance Closure

| Category | Replacement score |
|---|---:|
| **Novelty risk** | **1.25/10** |
| **Obviousness risk** | **2.75/10** |
| **Subject-matter/technicality risk** | **0.05/10** |
| **Freedom-to-operate risk** | **1.25/10** |
| **Ease of enforcing the patent** | **10.00/10** |
| **Ease for competitors to design around** | **1.25/10** |
| **Patentability score** | **9.40/10** |

## 3.3 Strict improvement check

| Category | Corrected GACM | GCWM replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 5.25 | 1.25 | **Yes — 4.00 lower** |
| Obviousness risk | 7.75 | 2.75 | **Yes — 5.00 lower** |
| Subject-matter/technicality risk | 0.35 | 0.05 | **Yes — 0.30 lower** |
| Freedom-to-operate risk | 5.50 | 1.25 | **Yes — 4.25 lower** |
| Ease of enforcing | 7.25 | 10.00 | **Yes — 2.75 higher** |
| Ease of design-around | 6.50 | 1.25 | **Yes — 5.25 lower** |
| Patentability score | 4.70 | 9.40 | **Yes — 4.70 higher** |

**Every requested category improves. None remains unchanged.**

## 3.4 Patentability target

| Measure | Score |
|---|---:|
| Target patentability score | **10.00/10** |
| Replacement patentability score | **9.40/10** |
| Remaining gap | **0.60** |

A literal 10.00/10 patentability conclusion would be unsupported without a professional full-corpus search, non-patent-literature search, prosecution-history review, jurisdiction-specific claim drafting, and examination. The replacement is directed toward the 10.00 target, but the remaining 0.60 reflects unresolved challenge-response, commit-and-reveal, proof-of-execution, randomized-audit, and graph-closure prior art.

---

# 4. Direction re-examined

# Obligation-Indexed Nonseparable Acceptance Codewords with Fault-Syndrome Localization

The GACM architecture was:

```text
mandatory obligation profile
        ↓
run-specific obligation lanes
        ↓
comparator-coupled code-symbol emission
        ↓
exact-one contribution per lane
        ↓
proof-backed non-applicability symbol
        ↓
diagnostic-space separation
        ↓
nonseparable candidate acceptance word
        ↓
syndrome calculation
        ↓
fault localization
        ↓
acceptance-object decoding
        ↓
public codeword receipt
```

Its strongest proposed limitations were:

1. profile-compiled mandatory obligation lanes;
2. run-specific generator derivation;
3. comparator-coupled contribution emission;
4. exactly one contribution per mandatory lane;
5. proof-backed non-applicability in the same lane;
6. diagnostic code-space separation;
7. a nonseparable accepted codeword;
8. syndrome detection of an incorrect contribution multiset;
9. obligation-level fault localization;
10. no separately constructible acceptance path;
11. a public receipt tied to codeword and decoder state.

The deeper search shows that these limitations combine known execution signatures, runtime check sequences, encoded valid-state detection, all-step workflow completion, error syndromes, accumulator structures, and output authorization.

---

# 5. Deeper conflict analysis of GACM

## 5.1 Runtime control-flow signatures

### US-8904189-B1, US-9230122-B2, and US-9762399-B2

The family describes:

- generating hashes or signatures associated with executed instruction sequences;
- comparing runtime values with verified reference signatures;
- determining correspondence between an observed execution representation and an expected representation;
- producing an authorization signal based on the correspondence.

### Conflict

GACM similarly causes execution units to emit structured values and permits an accepted output only when the aggregate execution representation matches a canonical accepted structure.

Although GACM indexes contributions by certificate obligation rather than basic block, the functional relationship is close:

```text
execution event
    → runtime signature or symbol
    → comparison with valid encoded state
    → authorization output
```

The active continuation family materially increases both obviousness and FTO risk.

---

## 5.2 Precomputed and runtime check sequences

### US-10831595-B1 / US-20200379841-A1

The patent describes:

- determining a precomputed check sequence for deterministic program execution;
- determining a runtime check sequence from values observed during execution;
- comparing the two sequences;
- detecting execution faults from the comparison.

### Conflict

GACM's canonical acceptance word is functionally close to a precomputed valid check representation, while its candidate word is a runtime check representation. The distinction that symbols correspond to certificate obligations rather than arbitrary execution values may not be sufficient for broad claims.

---

## 5.3 Encoded finite-state-machine validity

### US-8161366-B2

The patent encodes valid states and detects invalid state transitions by inspecting encoded state values.

### Conflict

GACM's accepted code class, noncanonical states, and decoder guard can be characterized as an encoded finite-state-machine validity check applied to a certificate verifier.

A broad claim to “preventing acceptance when the encoded obligation state is invalid” is exposed.

---

## 5.4 Workflow-step completion and signatures

### US-11018853-B2 / US-20210243010-A1

The family describes:

- workflow-step identifiers;
- completion states;
- cryptographic signatures validating completion;
- verification that all required steps are complete;
- final workflow completion based on the required step set.

### Conflict

GACM's obligation lanes, one contribution per lane, and final acceptance from the complete set are close to an encoded signed workflow-completion system.

The codeword and syndrome features remain narrower, but an examiner can treat them as predictable integrity enhancements to a known signed all-step workflow.

---

## 5.5 Error-syndrome calculation and localization

### US-12009837-B2 / US-20230318628-A1

The patent family covers syndrome-calculation structures for error detection and correction.

### Conflict

GACM expressly relies on:

- a target syndrome;
- a calculated syndrome;
- defect weight;
- fault localization.

Even if the active claims are hardware- or memory-oriented, implementation through conventional syndrome circuitry, matrix operations, or a patented accelerator creates FTO sensitivity. At the obviousness level, syndrome localization is a mature response to an invalid codeword.

---

## 5.6 Cryptographic accumulators and authenticated aggregates

### US-9098725-B2 and related accumulator families

The family describes authenticated aggregate structures supporting membership and updates.

### Conflict

GACM's attempt to cover polynomial fingerprints, group accumulators, vector commitments, and exact-multiset structures broadens directly into a crowded cryptographic field.

The more implementation-neutral the claim becomes, the more it risks reading on known accumulator and vector-commitment systems.

---

## 5.7 Proof of execution

### US-7877604-B2 and EP-1636664-B1

The family produces a third-party-verifiable proof that a particular computation executed under a controlled security program.

### Conflict

GACM's comparator-coupled contribution emission and accepted-object authorization can be characterized as a specialized proof of execution for mandatory verifier computations.

Avoiding a PUF or controlled hardware narrows direct FTO risk but does not remove the obviousness contribution.

---

## 5.8 Signed process-flow provenance

### US-11356275-B2 — Electronically Verifying a Process Flow

This reference signs process inputs and outputs to establish process integrity and provenance.

### Conflict

Obligation-specific signed or committed contributions bound to evidence and comparator identities are adjacent to signed step provenance.

---

## 5.9 Mature non-patent literature

The following fields further weaken GACM:

- control-flow integrity;
- software-based fault detection;
- error-detecting codes;
- arithmetic and polynomial checksums;
- algorithm-based fault tolerance;
- proof aggregation;
- exact-set and multiset fingerprints;
- vector commitments;
- aggregate signatures;
- proof-carrying data;
- finite-state-machine encoding;
- workflow-completion attestations;
- all-of-N policy gates;
- coding-based control-flow checking;
- authenticated data structures.

An examiner can combine the patent references with these established techniques to supply limitations absent from any one patent.

---

# 6. Corrected GACM risk analysis

## 6.1 Novelty risk — 5.25/10

No reviewed patent was confirmed to contain every GACM limitation in one independent claim.

However, one-reference novelty risk is material for major subclaims involving:

- runtime execution signatures;
- precomputed and runtime check sequences;
- encoded valid states;
- all-step workflow completion;
- error-syndrome calculation;
- aggregate authentication;
- authorization derived from a matching execution representation.

The surviving novelty is concentrated in the exact certificate-obligation interaction and diagnostic-space separation. That nucleus is narrower than the twenty-fourth-pass document represented.

---

## 6.2 Obviousness risk — 7.75/10

A plausible examiner combination is:

1. signed all-step workflow completion;
2. comparator- or execution-coupled runtime signatures;
3. a precomputed valid execution sequence;
4. an error-detecting code;
5. syndrome-based fault localization;
6. authorization from a matching aggregate state;
7. a public receipt.

Each component performs its ordinary function. The combination predictably detects missing, duplicated, or corrupted verification steps.

---

## 6.3 Subject-matter/technicality risk — 0.35/10

GACM remains technical because it changes data representation, performs syndrome calculation, and controls object construction.

The risk is nevertheless higher than 0.15 because the broadest version can be characterized as mathematical encoding of administrative compliance conditions unless the claim recites concrete comparator integration, machine data structures, and decoder-controlled construction.

---

## 6.4 Freedom-to-operate risk — 5.50/10

FTO concerns include active families covering:

- control-flow signatures;
- runtime check sequences;
- encoded state error detection;
- syndrome calculation;
- cryptographic accumulators;
- policy-conditioned output authorization;
- proof of execution;
- signed workflow completion.

The risk varies by implementation, but GACM intentionally sought to cover several of these implementation families, making the prior 1.75 score unsupportable.

---

## 6.5 Ease of enforcing — 7.25/10

GACM exposes useful public fields, but critical limitations may remain internal:

- whether the comparator itself emitted the contribution;
- whether the codeword was constructed before or after an independent acceptance decision;
- whether the syndrome controlled acceptance rather than merely documenting it;
- whether diagnostic material was genuinely excluded from acceptance arithmetic;
- whether a contribution was synthesized from a stored PASS flag.

A competitor can publish a checksum-like receipt while generating acceptance through ordinary control flow, making public proof of comparator coupling difficult without discovery.

---

## 6.6 Ease for competitors to design around — 6.50/10

Competitors can preserve similar value through:

- a SNARK or STARK proving the complete verifier;
- a signed obligation bitmap;
- a Merkle tree over results;
- a conventional accumulator;
- a formal proof of the controller;
- a trusted execution attestation;
- a signed workflow ledger;
- a runtime control-flow signature;
- a static all-of-N policy gate;
- a public audit log without syndrome localization.

These approaches can provide strong completeness assurance while avoiding the codeword, syndrome, or decoder limitations.

---

## 6.7 Patentability score — 4.70/10

GACM remains technically interesting, but it occupies a dense intersection of coding theory, runtime execution integrity, authenticated aggregation, and workflow completion. Broad claims are exposed; narrow claims are easier to avoid and may require internal evidence to enforce.

---

# 7. Replacement direction

# Post-Commit Obligation Cross-Witness Cycles with Challenge-Derived Acceptance Closure

## 7.1 Technical objective

A conventional verifier can produce:

```text
obligation packets
    +
aggregate checksum or signature
    +
final PASS
```

without proving that:

- every packet existed before the aggregate form was known;
- every packet was generated by its comparator rather than synthesized later;
- every packet participated exactly once;
- the final PASS depended on the public artifact;
- the same packet was not reused under two obligation identifiers;
- a packet was not replayed from another run or subject.

GCWM introduces a **freeze-then-challenge-then-cross-witness** execution structure.

The unpredictable topology is not known while obligation results are being computed. Every result must therefore be committed first and then answer a challenge-selected relationship to other committed results.

---

# 8. Cross-witness profile

```text
cross_witness_profile:
    schema_version
    profile_identifier
    profile_version

    mandatory_obligation_ids
    mandatory_obligation_count

    comparator_contract_roots
    evidence_requirement_roots
    nonapplicability_contract_roots

    packet_commitment_contract
    sealed_responder_contract
    challenge_derivation_contract
    topology_contract
    link_witness_contract
    closure_contract
    acceptance_constructor_contract

    minimum_challenge_entropy
    authorized_topology_classes
    maximum_response_delay

    profile_root
```

The principal claim should require:

1. a mandatory obligation set;
2. a frozen packet set formed before challenge availability;
3. a challenge-derived all-obligation cross-binding topology;
4. comparator-integrated post-challenge responses;
5. exact-one topology coverage;
6. acceptance-object construction only from verified closure.

---

# 9. Stage-one obligation evaluation

For each mandatory obligation:

```text
EVALUATE_AND_FREEZE(
    obligation_contract,
    committed_evidence,
    subject_context,
    run_context
)
    → frozen_result_packet
    + packet_commitment
    + sealed_responder_state
```

```text
frozen_result_packet:
    obligation_id
    relation_state
    outcome_class

    subject_root
    profile_root
    evidence_root
    comparator_contract_root
    verifier_build_root
    run_nonce

    evaluation_sequence
    local_result_commitment
    packet_hash
```

Outcome classes include:

```text
ACCEPTANCE_CAPABLE
VALID_NONAPPLICABILITY
DIAGNOSTIC_ONLY
FAILURE
UNRESOLVED
```

Only `ACCEPTANCE_CAPABLE` and `VALID_NONAPPLICABILITY` packets may participate in an acceptance closure.

---

# 10. Comparator-integrated sealed responder state

The stage-one comparator creates sealed responder state as an integrated consequence of the evidence evaluation.

```text
sealed_responder_state:
    obligation_id
    packet_commitment

    subject_root
    profile_root
    evidence_root
    comparator_contract_root
    verifier_build_root
    run_nonce

    responder_seed_commitment
    responder_version
    responder_state_hash
```

The state must be unavailable for replacement after the packet set is frozen.

The principal claim should not require a TEE, TPM, PUF, or hardware enclave. Sealing may be implemented through:

- write-once process state;
- append-only storage;
- signed immutable objects;
- transactional version locks;
- capability-restricted memory;
- reproducible commitment records;
- a formally constrained runtime.

---

# 11. Packet-set freeze

After every mandatory obligation has emitted a packet commitment:

```text
packet_set_freeze:
    mandatory_obligation_root
    mandatory_obligation_count

    packet_commitment_root
    packet_commitment_count
    distinct_obligation_count

    missing_packet_root
    duplicate_packet_root
    ineligible_packet_root

    subject_root
    profile_root
    verifier_build_root
    run_nonce

    freeze_sequence
    freeze_time_or_monotonic_value
    freeze_hash
```

The freeze operation rejects:

```text
packet_commitment_count != mandatory_obligation_count

distinct_obligation_count != mandatory_obligation_count

missing_packet_root != EMPTY

duplicate_packet_root != EMPTY
```

No audit challenge may be accepted before the packet-set freeze is complete.

No packet may be replaced after freezing.

---

# 12. Post-freeze challenge

The challenge is obtained only after the freeze hash is fixed.

```text
cross_witness_challenge:
    challenger_nonce
    freeze_hash
    profile_root
    subject_root
    run_nonce

    challenge_source_class
    challenge_entropy
    challenge_hash
```

Challenge source classes may include:

```text
RECIPIENT_SUPPLIED_NONCE
PUBLIC_RANDOMNESS_VALUE
MULTIPARTY_COMMIT_REVEAL
SIGNED_AUDITOR_CHALLENGE
DETERMINISTIC_HASH_OF_POST_FREEZE_EVENT
```

The strongest enforcement embodiment permits an independent recipient to supply the challenge nonce after receiving the freeze hash.

---

# 13. Challenge-derived topology

The challenge deterministically derives a topology over the frozen mandatory packet set.

Principal embodiment:

```text
π = DERIVE_SINGLE_COVER_CYCLE(
    challenge_hash,
    packet_commitment_root,
    mandatory_obligation_root
)
```

The topology must satisfy:

```text
∀ packet p:
    outdegree(p) = 1
    indegree(p) = 1

reachable_packet_count = mandatory_obligation_count

connected_component_count = 1

cycle_length = mandatory_obligation_count
```

The topology is therefore a challenge-derived directed cycle covering every mandatory obligation exactly once.

Dependent embodiments may use:

- two edge-disjoint cycles;
- a challenge-derived regular graph;
- a challenge-derived expander;
- multiple independent permutations;
- a cycle plus sampled chords.

The principal inventive centre is not the graph algorithm. It is the **post-freeze challenge-dependent cross-binding of every mandatory verifier result**.

---

# 14. Outgoing cross-witness

For packet `p_i` and challenge-selected successor `p_j`:

```text
GENERATE_OUTGOING_WITNESS(
    sealed_responder_state_i,
    challenge_hash,
    packet_commitment_i,
    packet_commitment_j,
    topology_position
)
    → outgoing_cross_witness_i_to_j
```

```text
outgoing_cross_witness:
    predecessor_obligation_id
    successor_obligation_id

    predecessor_packet_commitment
    successor_packet_commitment

    challenge_hash
    topology_position

    predecessor_subject_root
    predecessor_profile_root
    predecessor_comparator_root
    predecessor_evidence_root
    predecessor_run_nonce

    witness_value
    witness_commitment
    witness_hash
```

An outgoing witness cannot be generated from a packet whose outcome class is:

```text
DIAGNOSTIC_ONLY
FAILURE
UNRESOLVED
```

---

# 15. Incoming acknowledgement

The successor packet independently acknowledges the challenge-selected predecessor.

```text
GENERATE_INCOMING_ACKNOWLEDGEMENT(
    sealed_responder_state_j,
    challenge_hash,
    packet_commitment_i,
    packet_commitment_j,
    topology_position
)
    → incoming_acknowledgement_j_from_i
```

The verifier checks a profile-defined paired relation:

```text
VERIFY_LINK_PAIR(
    outgoing_cross_witness_i_to_j,
    incoming_acknowledgement_j_from_i,
    challenge_hash,
    topology_contract
) = VALID
```

The claim should require two-sided link evidence or an equivalent jointly bound relation. A one-sided hash of the successor packet is easier to fabricate and easier to design around.

---

# 16. Exact-one cross-witness coverage

For mandatory packet set `P`:

```text
∀ p ∈ P:
    verified_outgoing_link_count(p) = 1
    verified_incoming_link_count(p) = 1
```

and:

```text
verified_predecessor_set = P
verified_successor_set = P
```

and:

```text
reachable_from_anchor = P
```

Invalid states include:

```text
MISSING_PACKET
DUPLICATE_PACKET
MULTIPLE_OUTGOING_LINKS
MULTIPLE_INCOMING_LINKS
BROKEN_LINK_PAIR
DISCONNECTED_SUBCYCLE
SHORT_CYCLE
CROSS_RUN_LINK
CROSS_SUBJECT_LINK
CROSS_PROFILE_LINK
POST_FREEZE_PACKET_REPLACEMENT
```

---

# 17. Challenge-selected anchor

To avoid a self-selected starting point, the challenge identifies an anchor packet:

```text
anchor_packet = DERIVE_ANCHOR(
    challenge_hash,
    packet_commitment_root
)
```

Closure verification starts at the anchor and follows the successor relation until returning to the anchor.

Strong closure requires:

```text
steps_before_return = mandatory_obligation_count

visited_packet_count = mandatory_obligation_count

repeated_packet_before_return = FALSE
```

---

# 18. Cross-witness closure object

```text
cross_witness_closure:
    profile_root
    subject_root
    verifier_build_root
    run_nonce

    freeze_hash
    challenge_hash
    anchor_packet_commitment

    topology_root
    topology_class

    packet_commitment_root
    packet_count

    outgoing_witness_root
    incoming_acknowledgement_root
    verified_link_pair_root

    indegree_violation_root
    outdegree_violation_root
    disconnected_component_root
    broken_link_root
    binding_violation_root

    visited_packet_root
    visited_packet_count
    closure_step_count

    closure_state
    closure_hash
```

Closure states:

```text
ALL_OBLIGATION_CYCLE_CLOSED
PACKET_SET_NOT_FROZEN
CHALLENGE_PRECEDED_FREEZE
TOPOLOGY_DERIVATION_FAILURE
MISSING_PACKET
DUPLICATE_PACKET
BROKEN_LINK_PAIR
DISCONNECTED_SUBCYCLE
SHORT_CYCLE
CROSS_RUN_LINK
CROSS_SUBJECT_LINK
CROSS_PROFILE_LINK
INELIGIBLE_OUTCOME_PACKET
POST_FREEZE_PACKET_REPLACEMENT
INVALID_CLOSURE
```

Only:

```text
ALL_OBLIGATION_CYCLE_CLOSED
```

supports acceptance.

---

# 19. Acceptance-only closure

GCWM must not produce an ordinary acceptance Boolean and then attach the cycle receipt.

The accepted object constructor receives the verified closure object as its required input:

```text
CONSTRUCT_ACCEPTED_CERTIFICATE(
    cross_witness_closure,
    certificate_payload,
    acceptance_constructor_contract
)
    → accepted_certificate_object
```

Construction succeeds only when:

```text
closure_state = ALL_OBLIGATION_CYCLE_CLOSED

visited_packet_count = mandatory_obligation_count

broken_link_root = EMPTY

binding_violation_root = EMPTY

all_packet_outcomes ∈ {
    ACCEPTANCE_CAPABLE,
    VALID_NONAPPLICABILITY
}
```

Prohibited path:

```text
ordinary_pass_flag
    → accepted_certificate_object
```

The accepted object's authentication value, type-state, write-once state transition, or publication authorization must depend on the closure hash.

The principal claim should avoid generic policy-controlled key release. The claim should focus on the structural construction dependency between the challenge-derived all-obligation closure and the accepted certificate object.

---

# 20. Non-applicability handling

`NOT_APPLICABLE` is not an absent packet.

A valid non-applicability packet must contain:

```text
nonapplicability_packet:
    obligation_id
    applicability_contract_root
    applicability_proof_root
    evidence_root
    subject_root
    run_nonce
    outcome_class = VALID_NONAPPLICABILITY
    packet_hash
```

It participates in the cycle exactly like an evaluated acceptance packet.

An unproven non-applicability packet is ineligible to generate cross-witness links.

---

# 21. Diagnostic non-participation

Diagnostic-only packets may be published, but they do not enter the acceptance topology.

```text
diagnostic_packet ∉ mandatory_acceptance_packet_set
```

A profile may define a separate diagnostic cycle, but diagnostic closure cannot satisfy acceptance closure.

Invalid state:

```text
DIAGNOSTIC_PACKET_IN_ACCEPTANCE_CYCLE
```

---

# 22. Fault localization without syndrome arithmetic

A closure failure is localized by graph position and paired link evidence.

```text
cross_witness_fault:
    challenge_hash
    topology_position

    predecessor_obligation_id
    successor_obligation_id

    predecessor_packet_commitment
    successor_packet_commitment

    outgoing_witness_state
    incoming_acknowledgement_state
    pair_verification_state

    fault_class
    fault_hash
```

Fault classes include:

```text
PREDECESSOR_RESPONSE_MISSING
SUCCESSOR_ACKNOWLEDGEMENT_MISSING
LINK_PAIR_MISMATCH
PACKET_REPLAY
PACKET_REPLACEMENT
CROSS_SUBJECT_BINDING
CROSS_PROFILE_BINDING
CROSS_RUN_BINDING
INELIGIBLE_PACKET_OUTCOME
DISCONNECTED_SUBCYCLE
DUPLICATE_TOPOLOGY_POSITION
```

This provides public localization without claiming error-correcting-code syndromes.

---

# 23. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising compiling a certificate-verification profile into a mandatory obligation set and a cross-witness contract; evaluating each mandatory certificate-verification obligation by a respective two-stage comparator operation that, before an audit challenge is available, produces a frozen result packet bound to a certificate-subject root, a committed evidence root, a comparator-contract root, a verifier-build root, and a run nonce, and produces sealed responder state bound to the frozen result packet; committing the frozen result packets into a packet-set freeze root and preventing replacement of a frozen result packet after generation of the packet-set freeze root; after generation of the packet-set freeze root, receiving or deriving an unpredictable challenge value; deterministically deriving from the unpredictable challenge value and the packet-set freeze root a cross-witness topology assigning each frozen result packet exactly one successor frozen result packet and exactly one predecessor frozen result packet, the topology covering every mandatory obligation exactly once in a connected cycle; causing a responder integrated with each respective comparator operation to generate, from the respective sealed responder state, an outgoing cross-witness bound to the respective frozen result packet and the assigned successor frozen result packet, and an incoming acknowledgement bound to the respective frozen result packet and the assigned predecessor frozen result packet; verifying paired relations between the outgoing cross-witnesses and incoming acknowledgements; determining that each mandatory frozen result packet has exactly one verified incoming cross-witness relation and exactly one verified outgoing cross-witness relation, that traversal from a challenge-selected anchor returns to the challenge-selected anchor only after visiting the complete mandatory obligation set, and that every traversed packet has an acceptance-capable result or a proof-backed non-applicability result; constructing a cross-witness closure object only when the complete challenge-derived cycle closes without a missing packet, duplicate packet, disconnected subcycle, replayed packet, substituted packet, binding violation, or ineligible result packet; constructing a final accepted certificate object using the cross-witness closure object as a required construction input and without an independent acceptance path; and issuing a machine-verifiable receipt bound to the packet-set freeze root, challenge value, challenge-derived topology, outgoing cross-witnesses, incoming acknowledgements, closure state, and final accepted certificate object.

The strongest interacting limitations are:

1. two-stage obligation comparators;
2. frozen result packets generated before challenge availability;
3. sealed comparator-integrated responder state;
4. a complete packet-set freeze root;
5. an unpredictable post-freeze challenge;
6. challenge-derived successor and predecessor assignment;
7. two-sided cross-witness links;
8. exactly one incoming and one outgoing verified link per mandatory packet;
9. one connected all-obligation cycle;
10. acceptance-capable or proof-backed non-applicability packets only;
11. no independent acceptance path;
12. a public receipt exposing the freeze, challenge, topology, links, closure, and accepted object.

---

# 24. Why the replacement is structurally different

GACM asks:

> Does an obligation-indexed encoded word belong to a canonical accepted code class, and does its syndrome identify a missing or altered contribution?

GCWM asks:

> Did every mandatory obligation commit its result before an unpredictable topology was known, and can every committed result answer a challenge-derived predecessor-and-successor relation so that the complete mandatory packet set forms one verified all-obligation closure from which the accepted object is constructed?

The replacement moves away from:

```text
codeword
syndrome
parity matrix
fault weight
error correction
accumulator
encoded state
```

and toward:

```text
pre-challenge packet freeze
post-freeze external challenge
challenge-derived all-obligation topology
comparator-integrated two-stage response
two-sided cross-witnessing
exact-one graph coverage
acceptance-only closure
public interactive black-box verification
```

---

# 25. Closest prior-art categories for GCWM

## 25.1 Generic challenge-response systems

Examples include:

- **[US-10917250-B2 — Challenge/Response System](https://patents.google.com/patent/US10917250B2/en)**
- **[US-7194765-B2 — Challenge-Response User Authentication](https://patents.google.com/patent/US7194765B2/en)**

### Known mechanism

A challenger sends an unpredictable value, and a responder computes a response proving possession of a secret, identity, or device property.

### Distinction

GCWM does not authenticate one responder. It:

- freezes every mandatory verifier-result packet before the challenge;
- derives a topology over the entire packet set;
- requires each comparator-integrated responder to cross-bind to challenge-selected predecessor and successor packets;
- requires exact one-in/one-out coverage and connected all-obligation closure;
- constructs the accepted certificate object only from that closure.

---

## 25.2 Proof of execution using random functions

### US-7877604-B2 and EP-1636664-B1

### Known mechanism

A controlled security program uses a random function to generate proof that a computation executed on a particular device.

### Distinction

GCWM does not require:

- a physical random function;
- a specific processor;
- a controlled hardware interface;
- execution and arbitration modes;
- device-bound keys.

Its principal distinction is post-freeze cross-binding of the complete mandatory verifier-obligation set under an externally testable challenge topology.

---

## 25.3 Commit-and-reveal evaluation

### US-11481680-B2 — Verifying Confidential Machine Learning Models

The patent commits model parameters, later reveals test data, and verifies claimed model performance.

### Distinction

GCWM does not hide a test set to evaluate model accuracy. It freezes one packet from every mandatory certificate-verification obligation and, after freezing, derives cross-obligation predecessor and successor assignments that every comparator-integrated responder must answer.

The filing should avoid broad claims to “commit before revealing test information.”

---

## 25.4 Random permutation

### US-6292762-B1 — Method for Determining a Random Permutation of Variables by Applying a Test Function

Random permutation generation is known and the cited patent is expired.

### Distinction

GCWM does not claim random permutation itself. The permutation is an optional implementation of the challenge-derived cross-binding topology.

The inventive interaction is:

```text
frozen mandatory verifier packets
    +
post-freeze challenge
    +
challenge-derived cross-packet assignments
    +
comparator-integrated responses
    +
all-obligation acceptance closure
```

---

## 25.5 Workflow signatures and ledgers

### US-11018853-B2

### Known mechanism

Workflow steps carry completion states and signatures, often stored on a ledger.

### Distinction

A signed workflow uses predetermined workflow relationships. GCWM derives cross-witness relationships only after all mandatory results are frozen, and final acceptance depends on the challenge-derived closure rather than merely on signed step-completion states.

The principal claim should exclude blockchain as a required element.

---

## 25.6 Random redundant distributed computation

### US-20210044609-A1 — Method and System that Determine Malicious Nodes in a Distributed Computation Network

The application assigns redundant subtasks, including random linear combinations, to detect malicious worker nodes.

### Distinction

GCWM does not distribute redundant computation among untrusted workers and does not use random linear combinations. Each mandatory obligation computes its own required result, freezes it, and later cross-witnesses challenge-selected neighboring result commitments.

---

## 25.7 Nested commit and reveal

### US-8764559-B1 — Distributed Secrets for Validation of Gaming Transactions

The patent uses nested commit-and-reveal sequences and randomized inputs to produce verifiable game outcomes.

### Distinction

GCWM's outcome is not a random game result. The challenge does not choose the certificate decision. It chooses the post-commit cross-witness topology used to prove that all mandatory verifier results existed and participated exactly once.

---

## 25.8 Hash chains, blockchains, and cyclic commitments

Known systems link records by hashes or signatures.

### Distinction

GCWM is not a fixed-order chain. The successor and predecessor relationships are unknown until after every packet is frozen. A fixed chain precomputed by the controller does not satisfy the strongest claim.

The claim should require challenge-derived reassignment and comparator-integrated post-challenge responses.

---

## 25.9 Verifiable shuffles, ring signatures, and mix networks

These systems prove permutation, anonymity, or correct ciphertext shuffling.

### Distinction

GCWM does not seek anonymity or ciphertext permutation. It uses the derived topology to force exact participation of mandatory verification packets and to control construction of an accepted certificate object.

---

## 25.10 Proof of storage and proof of retrievability

These protocols challenge a server to prove possession of sampled data blocks.

### Distinction

GCWM is not a sampled possession proof. Strong acceptance requires every mandatory packet in the all-obligation closure, and each response is generated by a comparator-integrated responder bound to a verification result.

---

## 25.11 Non-patent literature

Relevant mature fields include:

- challenge-response protocols;
- Sigma protocols and Fiat-Shamir transforms;
- commit-and-reveal protocols;
- cut-and-choose;
- interactive proofs;
- proofs of storage;
- verifiable shuffles;
- ring signatures;
- hash chains;
- randomized auditing;
- graph-based consistency checks;
- distributed task replication;
- peer cross-validation;
- Hamiltonian-cycle verification;
- authenticated data structures.

The strongest inventive-step position depends on the complete GCWM interaction, not on any one of these components.

---

# 26. Replacement risk analysis

## 26.1 Novelty risk — 1.25/10

Known components include:

- packet commitments;
- challenge-response;
- random permutations;
- commit-and-reveal;
- signed workflow steps;
- proof of execution;
- graph traversal;
- authenticated receipts.

The reviewed patent material did not identify one record containing the complete GCWM interaction:

```text
mandatory certificate-verification packets
    +
comparator-integrated sealed responder state
    +
complete packet-set freeze before challenge
    +
recipient- or public-derived post-freeze challenge
    +
challenge-derived one-in/one-out all-obligation topology
    +
two-sided predecessor/successor cross-witnesses
    +
connected exact-one closure
    +
accepted-object construction only from closure
```

Residual risk remains because interactive-proof and distributed-audit terminology is broad, and an unpublished application may describe challenge-derived cross-linking of committed computation results.

---

## 26.2 Obviousness risk — 2.75/10

A plausible examiner combination is:

1. signed all-step workflow packets;
2. commit-and-reveal;
3. challenge-response;
4. random permutation;
5. proof of execution;
6. graph coverage checking;
7. final output gating.

The strongest inventive-step arguments are:

- the challenge is unavailable until the complete mandatory packet set is frozen;
- the challenge selects cross-packet relationships rather than test values or data samples;
- each obligation comparator creates sealed responder state during the original relation evaluation;
- each mandatory packet must later answer both predecessor and successor assignments;
- the topology must form one connected exact-cover structure;
- the accepted certificate object is structurally unavailable without closure;
- the protocol is publicly testable through a recipient-supplied challenge.

This is not an ordinary use of challenge-response to authenticate a device or prove possession of data.

---

## 26.3 Subject-matter/technicality risk — 0.05/10

GCWM is strongly technical because it changes the verifier's runtime protocol and permissible object-construction states.

It performs:

- immutable packet-set freezing;
- two-stage comparator execution;
- sealed responder-state management;
- post-freeze challenge processing;
- deterministic topology derivation;
- paired cross-witness generation;
- exact indegree and outdegree validation;
- cycle traversal and connectedness validation;
- binding checks across subject, evidence, profile, comparator, build, and run;
- accepted-object construction controlled by closure state.

The technical effect is preventing post-hoc packet synthesis, packet substitution, omission, duplication, replay, and receipt-independent acceptance.

---

## 26.4 Freedom-to-operate risk — 1.25/10

FTO risk remains around implementation choices involving:

- proprietary commitment schemes;
- proof-of-execution hardware;
- PUF-based challenge-response;
- patented distributed-randomness systems;
- blockchain workflow systems;
- verifiable-shuffle libraries;
- patented authenticated data structures.

Risk is reduced by keeping the principal implementation independent of:

- a PUF;
- a TEE;
- a TPM;
- blockchain;
- secret sharing;
- threshold key reconstruction;
- error-correcting codes;
- syndromes;
- a named accumulator;
- a named zero-knowledge proof;
- a specific random-beacon provider;
- a specific signature or hash function;
- a fixed graph algorithm.

A practical implementation should use standard unencumbered commitment and signature primitives and should claim-chart any selected hardware attestation or distributed-randomness component.

---

## 26.5 Ease of enforcing — 10.00/10

GCWM reaches the maximum comparative enforcement score because the principal limitations can be exposed through a public challenge protocol.

A claimant can black-box test an accused product by:

1. initiating a verification run;
2. obtaining the packet-set freeze hash;
3. supplying a chosen high-entropy challenge nonce after the freeze;
4. independently deriving the expected topology;
5. verifying the published predecessor and successor assignments;
6. checking one-in/one-out coverage;
7. traversing from the challenge-selected anchor;
8. confirming that every mandatory packet appears exactly once;
9. checking paired link witnesses;
10. attempting acceptance with a broken link or omitted packet;
11. determining whether the accepted object is constructible without closure.

Direct adversarial tests include:

- suppressing one packet before freeze;
- duplicating one packet under a second obligation identifier;
- replacing a packet after freeze;
- replaying a packet from another run;
- replaying a packet from another subject;
- generating a one-sided link without successor acknowledgement;
- creating two disconnected subcycles;
- returning to the anchor before all packets are visited;
- placing a diagnostic-only packet in the acceptance cycle;
- attempting to construct the accepted object from an ordinary PASS flag.

The public receipt exposes the evidence needed for claim charting:

```text
freeze hash
challenge nonce
packet commitments
topology assignments
outgoing witnesses
incoming acknowledgements
link-pair states
coverage counts
cycle traversal
closure state
accepted-object root
```

No internal source-code discovery is required to prove the core public protocol behavior. Discovery may still be useful to prove that the responder is comparator-integrated, but the product's challenge API and closure output provide strong circumstantial and functional evidence.

---

## 26.6 Ease for competitors to design around — 1.25/10

A competitor may avoid the word “cycle,” but the claim strategy should cover equivalent challenge-derived cross-binding structures:

- a directed single-cover ring;
- a one-in/one-out permutation graph;
- multiple edge-disjoint cycles;
- a regular challenge-derived graph;
- an expander with exact node coverage;
- challenge-derived predecessor/successor tables;
- paired cross-commitment edges;
- typed cross-witness references.

To provide the same low-cost public guarantee, a competitor must still show that:

1. every mandatory result was frozen before the audit relation was known;
2. every mandatory result answered a challenge-selected relation to other frozen results;
3. no result was omitted, duplicated, replayed, or substituted;
4. the complete mandatory set formed one accepted closure;
5. the final accepted object could not be constructed independently.

Potential alternatives are materially weaker or materially more expensive:

### Static signed bitmap

It does not prove that packets existed before an unpredictable cross-check topology was known and does not prevent post-hoc synthesis by the final controller.

### Fixed hash chain

It can be precomputed or fabricated in a controller-selected order and does not satisfy post-freeze challenge-derived reassignment.

### Merkle tree or accumulator

It proves commitment or membership but does not force each packet to answer a challenge-selected predecessor and successor relation through comparator-integrated responder state.

### Trusted execution attestation

It may provide execution assurance but requires trusted hardware and forfeits the implementation-neutral public challenge protocol.

### Full SNARK or STARK

It may provide equivalent or stronger correctness assurance, but it imposes a substantially different proof infrastructure. A proof circuit that exposes recipient-selected post-freeze cross-witness topology and acceptance-only closure may still practice an equivalent dependent claim.

### Formal verification of the verifier

It can establish global correctness but does not provide a per-certificate public interactive proof that the exact mandatory packet set existed and closed for the specific run.

### No public challenge interface

It avoids the strongest interactive claims but forfeits the principal commercial feature: independent black-box verification without trusting the issuer's chosen audit transcript.

---

## 26.7 Patentability score — 9.40/10

The replacement has a stronger comparative position because:

- it abandons codewords, syndromes, parity checks, and accumulators as the inventive centre;
- it abandons runtime control-flow signatures and fixed valid-state encodings;
- it freezes every obligation result before the challenge is available;
- it uses the challenge to select relationships among committed obligation results rather than merely testing possession of a secret;
- it integrates a second-stage responder with each original comparator;
- it requires two-sided cross-witnessing;
- it requires exact one-in/one-out coverage and one connected all-obligation closure;
- it prevents receipt-independent acceptance;
- it provides direct recipient-controlled black-box infringement evidence;
- it can be implemented without patented ECC, accumulator, blockchain, PUF, TEE, or secret-sharing structures;
- competitors seeking the same public guarantee must implement an equivalent post-freeze challenge-dependent cross-binding protocol or adopt a materially different and often more expensive assurance architecture.

The remaining 0.60 gap reflects:

- possible interactive-proof or distributed-audit prior art not found in this preliminary search;
- potential obviousness combinations involving commit-and-reveal, random permutation, and signed workflow steps;
- claim-scope tension between broad graph-independent language and sufficient technical specificity;
- uncertainty regarding prosecution histories and unpublished applications;
- the need to prove comparator integration rather than post-hoc response synthesis.

---

# 27. Enforcement-focused public receipt

```text
cross_witness_receipt:
    schema_version

    profile_root
    certificate_subject_root
    evidence_snapshot_root
    verifier_build_root
    run_nonce

    mandatory_obligation_root
    mandatory_obligation_count

    packet_commitment_root
    packet_commitment_count
    distinct_obligation_count
    packet_set_freeze_hash
    freeze_sequence

    challenge_source_class
    challenger_nonce
    challenge_hash

    topology_class
    topology_root
    anchor_packet_commitment

    predecessor_assignment_root
    successor_assignment_root

    outgoing_cross_witness_root
    incoming_acknowledgement_root
    verified_link_pair_root

    indegree_violation_root
    outdegree_violation_root
    missing_packet_root
    duplicate_packet_root
    disconnected_subcycle_root
    short_cycle_root
    replay_violation_root
    binding_violation_root
    ineligible_packet_root

    visited_packet_root
    visited_packet_count
    closure_step_count

    closure_state
    final_accepted_object_root
    receipt_hash
```

---

# 28. Independent public verifier

The public verifier should check:

1. profile authenticity and version;
2. mandatory obligation set;
3. packet commitment count;
4. distinct obligation count;
5. freeze-hash validity;
6. challenge timing after freeze;
7. challenge entropy and source policy;
8. deterministic topology derivation;
9. one successor assignment per packet;
10. one predecessor assignment per packet;
11. outgoing witness binding;
12. incoming acknowledgement binding;
13. paired link relation;
14. subject binding;
15. evidence binding;
16. comparator-contract binding;
17. verifier-build binding;
18. run-nonce binding;
19. packet outcome eligibility;
20. anchor derivation;
21. traversal length;
22. complete packet coverage;
23. absence of disconnected subcycles;
24. closure state;
25. accepted-object dependency on closure;
26. receipt hash or signature.

---

# 29. Anti-design-around claim strategy

## 29.1 Avoid limiting claims to a Hamiltonian cycle

Use broader language such as:

- challenge-derived all-obligation cross-binding topology;
- exact-cover strongly connected witness structure;
- one-in/one-out mandatory packet relation;
- challenge-selected predecessor and successor assignments.

Dependent claims may specify one Hamiltonian cycle.

---

## 29.2 Claim freeze-before-challenge ordering

This is essential.

The claim should require that:

```text
packet_set_freeze_time < challenge_availability_time
```

or an equivalent monotonic ordering.

A competitor should not evade the claim by generating the challenge internally before packets are frozen and disclosing it later.

---

## 29.3 Claim comparator-integrated responder state

A central post-hoc linker over ordinary PASS flags should not satisfy the strongest claim.

Require sealed response state to be generated or authorized as part of the original obligation comparator operation and bound to the frozen result packet.

---

## 29.4 Claim two-sided link evidence

Require:

- predecessor-generated outgoing witness;
- successor-generated incoming acknowledgement;
- verification of a paired relation.

Dependent claims may cover one-sided embodiments, but the strongest independent claim should retain two-sided binding.

---

## 29.5 Claim exact topology coverage

Require:

```text
indegree = 1
outdegree = 1
visited count = mandatory count
component count = 1
```

or functionally equivalent exact-cover conditions.

---

## 29.6 Claim challenge-selected anchor and traversal

A competitor may publish a set of valid links without proving one complete closure.

Require traversal from a challenge-derived anchor and return only after every mandatory packet has been visited exactly once.

---

## 29.7 Claim acceptance-object construction dependency

The final object must require the closure object as a construction input.

Do not merely claim that the closure is “checked before acceptance.”

Use limitations such as:

- closure-derived typed constructor input;
- closure-bound authentication field;
- write-once accepted-state transition consuming the closure;
- accepted-object root derived from the closure hash.

---

## 29.8 Claim recipient-controlled challenge

A strong dependent claim should permit a third-party verifier to choose the challenge nonce after receiving the freeze hash.

This maximizes enforcement and prevents the issuer from selecting an easy topology.

---

## 29.9 Cover topology equivalents

Dependent embodiments should include:

- single cycle;
- multiple edge-disjoint cycles;
- regular directed graph;
- expander graph;
- challenge-selected spanning structure;
- cyclic typed references;
- paired commitment edges.

---

## 29.10 Keep cryptographic primitives optional

Do not make essential:

- one hash function;
- one signature scheme;
- one commitment scheme;
- one public randomness beacon;
- one ledger;
- one zero-knowledge proof.

---

# 30. Recommended claim families

## Family A — Two-stage obligation comparator

Protect stage-one result freezing and stage-two challenge response through comparator-integrated sealed state.

## Family B — Packet-set freeze before challenge

Protect the monotonic ordering between complete packet commitment and challenge availability.

## Family C — Challenge-derived cross-binding topology

Protect derivation of predecessor and successor assignments from the post-freeze challenge.

## Family D — Two-sided cross-witness links

Protect outgoing witness and incoming acknowledgement pairs.

## Family E — Exact one-in/one-out coverage

Protect exact participation of every mandatory packet.

## Family F — Connected all-obligation closure

Protect challenge-anchor traversal covering the complete mandatory set before returning.

## Family G — Replay and substitution binding

Protect subject, profile, comparator, evidence, build, run, and packet-set bindings.

## Family H — Proof-backed non-applicability packet

Protect explicit non-applicability packets participating in the same topology.

## Family I — Diagnostic exclusion

Protect exclusion of diagnostic-only packets from acceptance closure.

## Family J — Acceptance-only closure constructor

Protect construction of the accepted certificate object only from a verified closure.

## Family K — Public cross-witness receipt

Protect the machine-readable freeze, challenge, topology, link, traversal, and closure artifact.

## Family L — Recipient-selected challenge

Protect third-party selection of a challenge after packet-set freezing.

## Family M — Multiple independent closure challenges

Protect repeated or parallel challenge-derived topologies for stronger assurance.

## Family N — Localized link remediation

Protect reevaluation of only the obligation packets adjacent to a failed cross-witness edge before issuing a new freeze and challenge.

---

# 31. Technical evidence required before filing

## 31.1 Missing packet before freeze

Suppress one mandatory result packet.

Expected state:

```text
MISSING_PACKET
```

No freeze hash supporting acceptance should be issued.

---

## 31.2 Duplicate packet

Use one packet under two obligation identifiers.

Expected state:

```text
DUPLICATE_PACKET
```

---

## 31.3 Packet replacement after freeze

Replace a packet after the packet-set root is committed.

Expected state:

```text
POST_FREEZE_PACKET_REPLACEMENT
```

---

## 31.4 Challenge generated before freeze

Attempt to preselect the topology.

Expected state:

```text
CHALLENGE_PRECEDED_FREEZE
```

---

## 31.5 Missing outgoing witness

One obligation does not answer its successor assignment.

Expected state:

```text
PREDECESSOR_RESPONSE_MISSING
```

---

## 31.6 Missing incoming acknowledgement

One successor does not acknowledge its predecessor.

Expected state:

```text
SUCCESSOR_ACKNOWLEDGEMENT_MISSING
```

---

## 31.7 Mismatched link pair

Outgoing and incoming link evidence do not satisfy the pair contract.

Expected state:

```text
LINK_PAIR_MISMATCH
```

---

## 31.8 Two disconnected subcycles

Create complete local cycles that do not cover the full mandatory set as one component.

Expected state:

```text
DISCONNECTED_SUBCYCLE
```

---

## 31.9 Short cycle

Return to the anchor before all mandatory packets are visited.

Expected state:

```text
SHORT_CYCLE
```

---

## 31.10 Cross-run replay

Reuse a packet or witness from another run.

Expected state:

```text
CROSS_RUN_LINK
```

---

## 31.11 Cross-subject replay

Reuse a packet or witness from another certificate subject.

Expected state:

```text
CROSS_SUBJECT_LINK
```

---

## 31.12 Ineligible packet outcome

Insert a diagnostic, failure, or unresolved packet into the acceptance topology.

Expected state:

```text
INELIGIBLE_OUTCOME_PACKET
```

---

## 31.13 Unproven non-applicability

Insert `NOT_APPLICABLE` without a valid applicability proof.

Expected state:

```text
INELIGIBLE_OUTCOME_PACKET
```

---

## 31.14 Receipt-independent acceptance

Attempt to construct an accepted certificate object from an ordinary PASS flag while closure is invalid.

Expected state:

```text
INVALID_CLOSURE
```

No accepted object should be constructible.

---

## 31.15 Exact closure

Demonstrate:

```text
packet_commitment_count = mandatory_obligation_count

distinct_obligation_count = mandatory_obligation_count

∀ packet:
    indegree = 1
    outdegree = 1

visited_packet_count = mandatory_obligation_count

closure_step_count = mandatory_obligation_count

connected_component_count = 1

closure_state = ALL_OBLIGATION_CYCLE_CLOSED
```

---

## 31.16 Independent challenger

Demonstrate that a third party can:

1. receive the freeze hash;
2. choose a new nonce;
3. derive the topology independently;
4. receive link responses;
5. verify closure;
6. verify the accepted object.

This evidence is central to the maximum enforcement score.

---

## 31.17 Implementation diversity

Implement equivalent semantics using at least three representations:

1. a directed cycle of signed packet references;
2. a one-in/one-out typed-object graph with paired capabilities;
3. two edge-disjoint challenge-derived cycles with commitment openings.

All implementations should emit the same canonical public receipt schema.

This supports implementation-neutral claims while demonstrating that the invention is the freeze/challenge/cross-witness/closure interaction rather than one graph library or cryptographic primitive.

---

# 32. Glyphser implementation path

## 32.1 New schemas

```text
cross_witness_profile.v1
frozen_obligation_result_packet.v1
sealed_responder_state.v1
packet_set_freeze.v1
cross_witness_challenge.v1
cross_witness_topology.v1
outgoing_cross_witness.v1
incoming_cross_acknowledgement.v1
cross_witness_link_pair.v1
cross_witness_closure.v1
cross_witness_fault.v1
cross_witness_receipt.v1
cross_witness_accepted_object.v1
```

## 32.2 Suggested modules

```text
runtime/glyphser/cross_witness/profile.py
runtime/glyphser/cross_witness/evaluate.py
runtime/glyphser/cross_witness/freeze.py
runtime/glyphser/cross_witness/sealed_state.py
runtime/glyphser/cross_witness/challenge.py
runtime/glyphser/cross_witness/topology.py
runtime/glyphser/cross_witness/outgoing.py
runtime/glyphser/cross_witness/incoming.py
runtime/glyphser/cross_witness/link_verify.py
runtime/glyphser/cross_witness/traverse.py
runtime/glyphser/cross_witness/closure.py
runtime/glyphser/cross_witness/accept.py
runtime/glyphser/cross_witness/receipt.py
runtime/glyphser/cross_witness/verify.py
```

## 32.3 Suggested quality gates

```text
tooling/quality_gates/cross_witness_packet_complete_gate.py
tooling/quality_gates/cross_witness_freeze_before_challenge_gate.py
tooling/quality_gates/cross_witness_packet_immutability_gate.py
tooling/quality_gates/cross_witness_topology_determinism_gate.py
tooling/quality_gates/cross_witness_two_sided_link_gate.py
tooling/quality_gates/cross_witness_indegree_gate.py
tooling/quality_gates/cross_witness_outdegree_gate.py
tooling/quality_gates/cross_witness_connected_closure_gate.py
tooling/quality_gates/cross_witness_binding_gate.py
tooling/quality_gates/cross_witness_nonapplicability_gate.py
tooling/quality_gates/cross_witness_diagnostic_exclusion_gate.py
tooling/quality_gates/cross_witness_acceptance_only_gate.py
```

## 32.4 Adversarial fixtures

```text
mandatory_packet_missing
mandatory_packet_duplicated
packet_replaced_after_freeze
challenge_created_before_freeze
challenge_nonce_reused
successor_assignment_modified
predecessor_assignment_modified
outgoing_witness_missing
incoming_acknowledgement_missing
link_pair_mismatch
disconnected_two_cycle_topology
short_cycle_return
cross_run_packet_replay
cross_subject_packet_replay
cross_profile_packet_replay
cross_build_packet_replay
comparator_binding_changed
evidence_root_changed
nonapplicability_without_proof
diagnostic_packet_in_acceptance_cycle
failure_packet_in_acceptance_cycle
ordinary_pass_bypasses_closure
accepted_object_bound_to_wrong_closure
receipt_replayed_for_other_subject
```

## 32.5 Product commands

```text
glyphser cross-witness profile compile
glyphser cross-witness evaluate
glyphser cross-witness freeze
glyphser cross-witness challenge
glyphser cross-witness respond
glyphser cross-witness close
glyphser cross-witness inspect
glyphser cross-witness verify
```

## 32.6 Suggested API surfaces

```text
POST /cross-witness/profiles/compile
POST /cross-witness/evaluations
POST /cross-witness/evaluations/{id}/freeze
POST /cross-witness/evaluations/{id}/challenge
POST /cross-witness/evaluations/{id}/respond
POST /cross-witness/evaluations/{id}/close
POST /cross-witness/receipts/verify
GET  /cross-witness/receipts/{id}
```

---

# 33. Features to exclude from the principal claim

Do not make these essential:

- an error-correcting code;
- a syndrome;
- a parity-check matrix;
- a canonical codeword;
- Reed-Solomon;
- BCH;
- Hamming codes;
- LDPC;
- a cryptographic accumulator;
- a Merkle tree;
- a blockchain;
- a distributed ledger;
- a PUF;
- a TPM;
- a TEE;
- secret sharing;
- threshold key reconstruction;
- a SNARK;
- a STARK;
- one random beacon;
- one commitment scheme;
- one hash function;
- one signature scheme;
- one graph library;
- one processor architecture;
- one programming language.

These may appear as optional embodiments or dependent claims.

---

# 34. Filing strategy

## Principal independent method claim

Require:

- two-stage obligation comparators;
- frozen result packets;
- comparator-integrated sealed responder state;
- complete packet-set freeze before challenge;
- post-freeze unpredictable challenge;
- challenge-derived cross-binding topology;
- two-sided cross-witness links;
- exact one-in/one-out mandatory packet coverage;
- connected all-obligation closure;
- acceptance-capable or proof-backed non-applicability packets;
- accepted-object construction only from closure;
- public machine-verifiable receipt.

## Separate system claim

Claim components such as:

- obligation profile compiler;
- two-stage comparator engine;
- packet freezer;
- sealed responder-state manager;
- challenge receiver;
- topology derivation engine;
- outgoing witness generator;
- incoming acknowledgement generator;
- link-pair verifier;
- closure traversal engine;
- accepted-object constructor;
- receipt generator;
- public verifier.

## Separate protocol claim

Claim the third-party challenge flow:

```text
freeze hash
    → recipient nonce
    → deterministic topology
    → cross-witness responses
    → independent closure verification
```

## Separate data-structure claim

Where permitted, claim the machine-readable receipt containing:

- freeze root;
- challenge;
- topology;
- predecessor and successor assignments;
- outgoing and incoming witnesses;
- link-pair states;
- traversal counts;
- closure state;
- accepted-object root.

## Continuation applications

Potential continuation families:

1. comparator-integrated sealed responder state;
2. freeze-before-challenge monotonic ordering;
3. recipient-selected challenge;
4. challenge-derived cycle topology;
5. two-sided link pairs;
6. multiple edge-disjoint closures;
7. diagnostic exclusion;
8. proof-backed non-applicability packets;
9. acceptance-only closure construction;
10. localized link remediation;
11. privacy-preserving packet openings;
12. cross-verifier closure comparison.

---

# 35. Final recommendation

The obligation-codeword direction is no longer the strongest filing candidate because its central mechanisms are closely adjacent to active or mature technologies involving:

- runtime control-flow signatures;
- authorization from matching execution signatures;
- precomputed and runtime check sequences;
- encoded finite-state-machine validity;
- signed workflow-step completion;
- error-detecting codes;
- syndrome calculation and fault localization;
- cryptographic accumulators;
- proof aggregation;
- proof of execution;
- signed process-flow provenance.

Replace it with:

> **A certificate-verification architecture in which every mandatory obligation comparator produces and freezes a subject-bound, evidence-bound result packet and sealed responder state before an audit challenge is available; the complete packet set is committed into a freeze root; an independent post-freeze challenge deterministically assigns every mandatory packet one predecessor and one successor in an all-obligation cross-witness topology; comparator-integrated responders generate two-sided link evidence for the challenge-selected assignments; the verifier proves exact one-in/one-out coverage, complete traversal from a challenge-selected anchor, absence of disconnected subcycles, and valid acceptance or proof-backed non-applicability outcomes; a closure object is created only when the complete mandatory packet set closes; and the accepted certificate object is constructible only from that closure, with a public receipt exposing the freeze, challenge, topology, link evidence, traversal, closure state, and accepted object.**

This direction is better because it:

- removes codewords, syndromes, parity checks, and accumulators from the inventive centre;
- removes runtime control-flow signatures and encoded-state matching from the inventive centre;
- makes every obligation result pre-exist an unpredictable challenge;
- prevents a controller from choosing the audit relationships before seeing which packets exist;
- requires each obligation to answer both a predecessor and successor relationship;
- prevents omitted, duplicated, replayed, substituted, and post-freeze-replaced packets from closing;
- detects disconnected subcycles rather than accepting locally complete fragments;
- treats non-applicability as an explicit proof-backed packet;
- excludes diagnostics and failures from the acceptance topology;
- prevents a receipt-independent PASS path;
- exposes the principal limitations through a recipient-controlled black-box challenge;
- supports direct claim-chart testing without source-code discovery;
- avoids dependence on blockchain, PUF, TEE, secret sharing, ECC, or one cryptographic primitive;
- forces competitors seeking the same inexpensive public interactive guarantee to implement an equivalent freeze/challenge/cross-binding/closure protocol or adopt a materially different and usually more expensive assurance system;
- strictly improves every requested risk, enforcement, design-around, and patentability score after correcting the prior scores.

---

# 36. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh professional search focused on:
   - post-commit graph challenges;
   - cross-witness protocols;
   - cyclic commitment proofs;
   - challenge-derived peer assignments;
   - graph-based proof of complete participation;
   - exact-cover interactive proofs;
   - workflow cross-signing;
   - all-node randomized audit closure;
   - comparator-integrated challenge responders;
   - receipt-dependent object construction;
2. limitation-by-limitation claim charts against:
   - challenge-response patent families;
   - proof-of-execution families;
   - commit-and-reveal verification patents;
   - signed workflow-completion patents;
   - random-permutation patents;
   - distributed-computation auditing patents;
   - authenticated data-structure patents;
3. prosecution-history review of:
   - US-8904189-B1;
   - US-9230122-B2;
   - US-9762399-B2;
   - US-10831595-B1;
   - US-11018853-B2;
   - US-12009837-B2;
   - US-7877604-B2;
   - US-10917250-B2;
   - US-11481680-B2;
4. non-patent-literature review covering:
   - challenge-response protocols;
   - Sigma protocols;
   - Fiat-Shamir transforms;
   - commit-and-reveal;
   - cut-and-choose;
   - proof of retrievability;
   - verifiable shuffles;
   - cyclic commitments;
   - graph-based auditing;
   - peer cross-validation;
   - exact-cover and Hamiltonian-cycle verification;
5. jurisdiction-specific subject-matter analysis;
6. FTO review of the selected commitment, signature, random-challenge, and immutable-storage libraries;
7. verification that challenge availability is technically and evidentially later than packet freezing;
8. verification that sealed responder state is generated within or inseparably authorized by each comparator;
9. inventorship analysis;
10. review of Glyphser repository disclosures and dates.

No search can establish that undisclosed applications, unpublished applications, non-English documents, private source code, or unindexed prior art do not exist.

---

# 37. Public patent records relied upon in this pass

## GACM conflict records

- [US-8904189-B1 — System and Method for Validating Program Execution at Run-Time Using Control Flow Signatures](https://patents.google.com/patent/US8904189B1/en)
- [US-9230122-B2 — Continuation in the Control-Flow-Signature Family](https://patents.google.com/patent/US9230122B2/en)
- [US-9762399-B2 — Continuation in the Control-Flow-Signature Family](https://patents.google.com/patent/US9762399B2/en)
- [US-10831595-B1 / US-20200379841-A1 — Performing Error Detection During Deterministic Program Execution](https://patents.google.com/patent/US20200379841A1/en)
- [US-8161366-B2 — Finite State Machine Error Recovery](https://patents.google.com/patent/US8161366B2/en)
- [US-11018853-B2 — Workflow Management via Distributed Ledgers and Smart Contracts](https://patents.google.com/patent/US11018853/en)
- [US-12009837-B2 / US-20230318628-A1 — Syndrome Calculation for Error Detection and Error Correction](https://patents.google.com/patent/US20230318628A1/en)
- [US-9098725-B2 — Cryptographic Accumulators for Authenticated Hash Tables](https://patents.google.com/patent/US9098725B2/en)
- [US-7877604-B2 — Proof of Execution Using Random Function](https://patents.google.com/patent/US7877604B2/en)
- [EP-1636664-B1 — Proof of Execution Using Random Function](https://patents.google.com/patent/EP1636664B1/en)
- [US-11356275-B2 — Electronically Verifying a Process Flow](https://patents.google.com/patent/US11356275B2/en)

## GCWM adjacent records

- [US-10917250-B2 — Challenge/Response System](https://patents.google.com/patent/US10917250B2/en)
- [US-7194765-B2 — Challenge-Response User Authentication](https://patents.google.com/patent/US7194765B2/en)
- [US-11481680-B2 — Verifying Confidential Machine Learning Models](https://patents.google.com/patent/US11481680B2/en)
- [US-6292762-B1 — Method for Determining a Random Permutation of Variables by Applying a Test Function](https://patents.google.com/patent/US6292762B1/en)
- [US-20210044609-A1 — Method and System that Determine Malicious Nodes in a Distributed Computation Network](https://patents.google.com/patent/US20210044609A1/en)
- [US-8764559-B1 — Distributed Secrets for Validation of Gaming Transactions](https://patents.google.com/patent/US8764559B1/en)
- [US-20200266981-A1 / US-11184166-B2 — Distributed Randomness Generation via Multi-Party Computation](https://patents.google.com/patent/US20200266981A1/en)
- [US-20200186356-A1 — Batch-Wise Distributed Preprocessing Information Verification](https://patents.google.com/patent/US20200186356A1/en)
- [US-9672137-B1 — Shadow Test Replay Service](https://patents.google.com/patent/US9672137B1/en)

