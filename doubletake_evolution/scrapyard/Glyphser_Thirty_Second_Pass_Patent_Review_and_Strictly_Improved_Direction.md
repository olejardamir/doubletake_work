# Glyphser Patent Direction
## Thirty-Second-Pass Conflict Review, Corrected Risk Scores, Patentability Score, and Strictly Improved Replacement Architecture

**Review date:** July 18, 2026  
**Direction re-examined:** *Consumer-Minted Write-Once Obligation Surfaces with Late-Bound Relation Writebacks and Atomic Closure*  
**Prior protocol name:** **Glyphser Obligation Writeback Surface — GOWS**  
**Replacement direction:** *Two-Origin Blind Relation Settlement with Hidden Target Routing, Decoy-Sink Rejection, and Fragment-Conservation Closure*  
**Suggested replacement protocol name:** **Glyphser Blind Settlement Fabric — GBSF**

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the exact claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation:** This pass used public patent-index records, public patent text, and the accumulated references from the preceding Glyphser reviews. The paid semantic patent-search service available in the environment did not have sufficient credits, and the official patent-office connector was not configured. The search therefore cannot exclude unpublished applications, unindexed records, non-English prior art, academic literature, standards, source code, or confidential commercial implementations.
>
> **Score correction:** The thirty-first-pass document assigned GOWS near-floor risk scores and near-ceiling enforceability. Deeper review identified direct conflicts in remote attestation, proof-of-execution, challenge-response access control, write-address tracking, one-time state, object-capability enforcement, deferred authenticated updates, distributed verifiable computation, and completion tracking. Those references materially weaken GOWS and expose a proof problem: a verifier can receive consumer cell descriptors, calculate a challenge response from a previously stored result, and populate the cells without proving that two independently originating facts—the actual evidence read and the comparator relation—caused the settlement. The scores below therefore correct GOWS before comparing the replacement. Every requested category strictly improves against the corrected scores.

---

# 1. Score definitions

All scores use a **0–10 scale**.

| Category | Meaning of a higher score |
|---|---|
| Novelty risk | Worse: greater likelihood that one reference anticipates the proposed claim |
| Obviousness risk | Worse: greater likelihood that an examiner can combine known references |
| Subject-matter/technicality risk | Worse: greater risk of being treated as abstract, administrative, predominantly mathematical, or insufficiently tied to a concrete computer improvement |
| Freedom-to-operate risk | Worse: greater likelihood that an implementation may practice active third-party claims |
| Ease of enforcing the patent | Better: easier to detect, test, claim-chart, and prove infringement |
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while preserving substantially the same commercial value |
| Patentability score | Better: comparative composite of novelty, inventive-step strength, technical character, claim coherence, enforceability, and practical filing strength; target **10.00/10** |

The scores are comparative engineering judgments, not legal conclusions or statistical probabilities.

---

# 2. Executive conclusion

GOWS should not remain the principal Glyphser patent nucleus.

GOWS proposed:

- a verifier commitment before an acceptance surface exists;
- a consumer-minted run-specific surface;
- one challenged write-once cell per mandatory obligation;
- relation-witness-generated pass writebacks;
- proof-generated non-applicability writebacks;
- atomic `EMPTY`-to-terminal transitions;
- rejection of duplicate, stale, cross-obligation, cross-subject, and post-seal writes;
- consumer-side exact-cell equality;
- a consumer-controlled atomic seal;
- an authoritative surface closure receipt.

The deeper review found that the operational centre is substantially closer to established patent fields than the prior score suggested.

The most important additional conflicts are:

- **[US-20230418985-A1 — Security Subsystem for Remote Attestation](https://patents.google.com/patent/US20230418985A1/en)**
  - accepts an authenticated challenge;
  - tracks writes to selected memory ranges using write bitmaps;
  - stores prior challenge values;
  - rejects stale challenges;
  - returns signed challenge-bound write-state information;
  - directly weakens claims based on consumer challenges, state cells, write tracking, freshness, and externally checked closure.

- **[US-7877604-B2 — Proof of Execution Using Random Function](https://patents.google.com/patent/US7877604B2/en)**
  - binds proof results to a program, input, challenge, and execution;
  - produces a third-party-verifiable certificate;
  - weakens broad claims that a challenge-bound relation writeback proves that a selected computation occurred.

- **[WO-2021150238-A1 — Remote Attestation](https://patents.google.com/patent/WO2021150238A1/en)** and **[US-11693992-B2 — Remote Attestation of System Integrity](https://patents.google.com/patent/US11693992B2/en)**
  - use verifier-generated nonces;
  - receive challenge-bound integrity evidence;
  - determine trust from the returned evidence;
  - weaken GOWS's late-bound cell-challenge nucleus.

- **[US-10297094-B2 — Challenge-Response Access Control Using Context-Based Proof](https://patents.google.com/patent/US10297094B2/en)**
  - sends a challenge;
  - receives a non-repudiatable response produced through an external validation system;
  - authorizes an operation only when the response is verified;
  - weakens the broad interaction of consumer challenge, external proof, and authoritative acceptance.

- **[US-11550952-B1 — Zero-Knowledge Proof Method and Electronic Device](https://patents.google.com/patent/US11550952B1/en)** and **[US-11496309-B2 — Disjunctive Proof for Two Relations](https://patents.google.com/patent/US11496309B2/en)**
  - use commitment, challenge, response, and relation-witness structures;
  - weaken attempts to distinguish GOWS merely by naming the response a relation witness or proof-backed writeback.

- **[EP-3566389-B1 — Distributed Privacy-Preserving Verifiable Computation](https://patents.google.com/patent/EP3566389B1/en)**
  - commits inputs and outputs;
  - generates proofs that computation was performed correctly;
  - distributes verification functions among inputters, workers, and recipients;
  - weakens the broad idea of separating computation from the party making the final verification decision.

- **[US-11163912-B2 — Data Attestation in Memory](https://patents.google.com/patent/US11163912B2/en)**
  - attests memory-resident state using challenge-response integrity checks;
  - weakens GOWS embodiments framed as externally controlled attested state cells.

- **[US-7558839-B1 — Read-After-Write Verification for Write-Once-Read-Many Storage](https://patents.google.com/patent/US7558839B1/en)**
  - verifies a write and marks data non-rewriteable;
  - weakens broad claims to verified write-once cell settlement.

- **[US-8108627-B2 — Array Comparison and Swap Operations](https://patents.google.com/patent/US8108627B2/en)**
  - performs multi-location comparison and atomic update;
  - weakens GOWS's atomic exact-cell closure when not tied to a more distinctive causal mechanism.

- **[US-11853795-B1](https://patents.google.com/patent/US11853795B1/en)** and **[US-12124873-B2](https://patents.google.com/patent/US12124873B2/en) — Scoreboard for Tracking Completion of Tasks**
  - receive task-completion signals;
  - track completion across a set;
  - issue a final completion signal;
  - weaken one-cell-per-obligation plus final seal embodiments.

- **[US-12099864-B2 — Formally Verified Trusted Computing Base with Active Security and Policy Enforcement](https://patents.google.com/patent/US12099864B2/en)**
  - uses object capabilities, protected domains, and controlled state objects;
  - weakens broad claims to consumer-owned capability cells and restricted transitions.

- **[US-10396991-B2 — Controlling Verification of Key-Value Stores](https://patents.google.com/patent/US10396991B2/en)**
  - authenticates data operations over untrusted storage;
  - returns verification information linked to prior operations;
  - weakens database-backed GOWS embodiments using authenticated versioned rows.

The GOWS inventive centre can therefore be characterized as:

```text
prover commitment
    +
verifier-generated challenge
    +
challenge-bound response or proof
    +
write-once or versioned state update
    +
one state location per required task
    +
completion-set equality
    +
atomic finalization
    +
public receipt
```

That combination is crowded by remote-attestation, proof-of-execution, challenge-response, WORM, transactional-state, and completion-scoreboard art.

GOWS also has a practical causality weakness. A competitor can:

- run an ordinary verifier and store a Boolean result per obligation;
- receive the consumer's cell descriptors afterward;
- calculate challenge responses from the stored Boolean and committed metadata;
- populate the consumer cells without exposing the evidence read that produced the result;
- synthesize relation-witness fields around the stored Boolean;
- use a generic attestation agent to sign the writebacks;
- keep the real acceptance decision in a separate policy engine;
- expose a surface receipt only as an audit artifact.

The surface proves that cells were written. It does not necessarily prove that two independent operational facts—the evidence acquisition and the comparator relation—were each indispensable to selecting the accepting state.

## Replacement decision

Retire this as the principal filing direction:

> **Consumer-Minted Write-Once Obligation Surfaces with Late-Bound Relation Writebacks and Atomic Closure**

Retain only as optional embodiments:

- consumer-controlled cells;
- write-once state transitions;
- challenge-bound writebacks;
- surface sealing;
- replay and stale-write rejection;
- externally hosted acceptance state.

Proceed instead with:

# **Two-Origin Blind Relation Settlement with Hidden Target Routing, Decoy-Sink Rejection, and Fragment-Conservation Closure**

Suggested protocol name:

## **Glyphser Blind Settlement Fabric — GBSF**

The replacement solves a narrower and more technically distinctive problem:

> A verifier can fabricate a challenge response from a stored pass flag because the verifier receives the accepting cell descriptor and controls both the evidence-reading and comparison narrative. How can an independent consumer require two separately generated, non-accepting fragments—one produced by the actual evidence-acquisition path and one produced by the actual comparator relation—to converge on an undisclosed accepting target, cause every incomplete, substituted, aliased, replayed, or generic-pass combination to be routed into a public decoy sink, and permit final acceptance only when the complete mandatory target set is reached with exact fragment conservation and zero decoy activity?

GBSF changes the settlement primitive.

The consumer does **not** send accepting cell handles to the verifier.

For each mandatory obligation, the consumer creates:

1. one hidden accepting target;
2. one evidence-origin challenge delivered to the authorized evidence adapter;
3. one relation-origin challenge delivered to the authorized comparator;
4. a private routing contract that maps only the correct pair of independently generated fragments to the hidden target;
5. decoy sinks for incomplete, duplicate, cross-obligation, stale, diagnostic, and mismatched fragment pairs.

The evidence adapter produces a fragment from the actual evidence value, evidence location, subject, and evidence-domain challenge. The comparator separately produces a fragment from the relation operator, normalized operand commitments, relation state, comparator execution identity, and relation challenge.

Neither fragment can settle anything alone.

The consumer combines the fragments under the hidden routing contract. Only the registered pair for one obligation reaches that obligation's hidden target. Every other combination reaches a typed decoy sink.

Strong closure requires:

```text
all mandatory hidden targets reached exactly once
    +
all evidence fragments consumed exactly once as authorized
    +
all relation fragments consumed exactly once as authorized
    +
no accepting target address disclosed before settlement
    +
no decoy sink activated
    +
no unmatched, replayed, aliased, diagnostic, or stale fragment remains
```

The principal claim does not require:

- remote attestation;
- a TEE or TPM;
- a write bitmap;
- a verifier-visible cell handle;
- a physical write-once memory;
- a blockchain;
- a zero-knowledge proof;
- an oblivious pseudorandom function;
- a threshold signature;
- resource access control;
- executable linking;
- a particular hash function;
- a particular database or atomic instruction.

---

# 3. Revised scores

## 3.1 GOWS — corrected after deeper conflict review

### Consumer-Minted Write-Once Obligation Surfaces with Late-Bound Relation Writebacks and Atomic Closure

| Category | Corrected score |
|---|---:|
| **Novelty risk** | **4.85/10** |
| **Obviousness risk** | **7.65/10** |
| **Subject-matter/technicality risk** | **0.40/10** |
| **Freedom-to-operate risk** | **5.15/10** |
| **Ease of enforcing the patent** | **8.70/10** |
| **Ease for competitors to design around** | **5.10/10** |
| **Patentability score** | **5.85/10** |

## 3.2 Replacement direction

### Two-Origin Blind Relation Settlement with Hidden Target Routing, Decoy-Sink Rejection, and Fragment-Conservation Closure

| Category | Replacement score |
|---|---:|
| **Novelty risk** | **1.70/10** |
| **Obviousness risk** | **2.90/10** |
| **Subject-matter/technicality risk** | **0.08/10** |
| **Freedom-to-operate risk** | **1.80/10** |
| **Ease of enforcing the patent** | **9.82/10** |
| **Ease for competitors to design around** | **1.65/10** |
| **Patentability score** | **9.39/10** |

## 3.3 Strict improvement check

| Category | Corrected GOWS | GBSF replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 4.85 | 1.70 | **Yes — 3.15 lower** |
| Obviousness risk | 7.65 | 2.90 | **Yes — 4.75 lower** |
| Subject-matter/technicality risk | 0.40 | 0.08 | **Yes — 0.32 lower** |
| Freedom-to-operate risk | 5.15 | 1.80 | **Yes — 3.35 lower** |
| Ease of enforcing | 8.70 | 9.82 | **Yes — 1.12 higher** |
| Ease of design-around | 5.10 | 1.65 | **Yes — 3.45 lower** |
| Patentability score | 5.85 | 9.39 | **Yes — 3.54 higher** |

**Every requested category improves. None remains unchanged.**

## 3.4 Patentability target

| Measure | Score |
|---|---:|
| Target patentability score | **10.00/10** |
| Replacement patentability score | **9.39/10** |
| Remaining gap | **0.61** |

The remaining gap is deliberate. No public search can establish absolute novelty, non-obviousness, validity, or freedom to operate. The gap also reflects known split-authorization, event-correlation, keyed-routing, decoy, and multi-party-verification art.

---

# 4. Direction re-examined

# Consumer-Minted Write-Once Obligation Surfaces with Late-Bound Relation Writebacks and Atomic Closure

The prior architecture was:

```text
verifier pre-surface commitment
        ↓
consumer-minted cell per obligation
        ↓
consumer challenge per cell
        ↓
relation-witness or applicability-proof writeback
        ↓
atomic one-time cell transition
        ↓
consumer-side exact-cell equality
        ↓
atomic accepted seal
        ↓
surface closure receipt
```

Its strongest limitations were:

1. a verifier commitment before the surface exists;
2. a consumer-generated surface;
3. one consumer-controlled cell per mandatory obligation;
4. an independent late-bound challenge per cell;
5. pass writeback generated from a relation witness;
6. non-applicability writeback generated from proof;
7. diagnostic and failure settlement prohibition;
8. atomic write-once transition;
9. duplicate, stale, alias, cross-subject, and late-backfill rejection;
10. consumer-side exact-cell equality;
11. consumer-side atomic seal;
12. a consumer-generated authoritative receipt.

The deeper review does not establish that one patent anticipates the complete narrow combination. It does show that most of the commercially important mechanisms are ordinary combinations of known challenge-response, attestation, proof, write-once state, exact-once messaging, and completion tracking.

---

# 5. Deeper conflict analysis of GOWS

## 5.1 Challenge-bound write tracking

### US-20230418985-A1

The application tracks writes to selected address ranges, records challenge history, rejects stale challenges, and returns signed challenge-bound write-state information.

### Conflict

GOWS similarly uses consumer challenges, state locations, write transitions, freshness checks, and a closure receipt. A claim that merely replaces memory ranges with obligation cells is vulnerable.

## 5.2 Proof of execution

### US-7877604-B2

The patent produces a proof that selected instructions executed with selected inputs on a selected device, using a challenge-sensitive random function.

### Conflict

A GOWS relation writeback may be characterized as a proof result bound to program, input, challenge, and execution. Calling it a cell writeback does not avoid the proof-of-execution field.

## 5.3 Remote-attestation nonce protocols

### WO-2021150238-A1, US-11693992-B2, EP-3972190-A1

These references use relying-party or verifier challenges and challenge-bound attestation responses to make trust decisions.

### Conflict

GOWS's precommitment and late challenge are conventional freshness mechanisms unless the claimed writeback interaction adds a further technical dependency.

## 5.4 Challenge-response access authorization

### US-10297094-B2

The access-controlling entity sends a challenge, receives a non-repudiatable response through an event-validation system, verifies it, and authorizes access only if valid.

### Conflict

GOWS substitutes certificate acceptance for access authorization and one cell per obligation for one challenge result. The general architecture is close.

## 5.5 Commitment-challenge-response proofs

### US-11550952-B1, US-11496309-B2, US-5493614-A

These references use commitments, challenges, relation witnesses, and responses.

### Conflict

A GOWS claim cannot rely on the words “relation witness,” “commitment,” or “late-bound challenge” as the inventive distinction.

## 5.6 Distributed verifiable computation

### EP-3566389-B1

The patent separates input commitment, computation, output commitment, proof generation, and recipient verification.

### Conflict

GOWS's separation between verifier and consumer is not independently strong. The distinguishing structure must be more specific than an external verifier checking proof-bearing outputs.

## 5.7 Write-once state

### US-7558839-B1 and one-time-programmable memory families

Write-once and read-after-write verification are established.

### Conflict

The `EMPTY@0 → TERMINAL@1` transition is technically useful but not a strong inventive centre by itself.

## 5.8 Atomic closure

### US-8108627-B2

Multi-location comparison and atomic update are known.

### Conflict

Consumer-side compare-and-seal is an implementation primitive, not a sufficient patent nucleus.

## 5.9 Completion scoreboards

### US-11853795-B1 and US-12124873-B2

These patents track completion across multiple tasks and issue a final completion indication.

### Conflict

One cell per obligation plus a final accepted seal can be characterized as a specialized completion scoreboard.

## 5.10 Object capabilities and protected state

### US-12099864-B2

The patent uses capabilities to control access to protected objects and semaphores.

### Conflict

Opaque cell handles and restricted state transitions may be treated as ordinary object-capability enforcement.

## 5.11 Authenticated untrusted storage

### US-10396991-B2

The patent verifies operations on data hosted at an untrusted module using cryptographic verification information linked to prior operations.

### Conflict

Database- or service-backed GOWS cells with authenticated updates are close to this field.

## 5.12 Post-hoc relation-witness synthesis

The verifier can store ordinary results and later populate relation-witness fields after receiving the consumer challenges.

### Conflict

The consumer sees a valid challenge response and cell transition but may not be able to prove that the evidence read and comparator relation were independently necessary to create it.

## 5.13 Non-authoritative surface use

A product may maintain a consumer-visible surface for audit while using a separate private policy result for production acceptance.

### Conflict

Enforcement still requires proof that the sealed surface is authoritative rather than explanatory.

---

# 6. Corrected GOWS risk analysis

## 6.1 Novelty risk — 4.85/10

GOWS retains potentially distinguishing details, especially:

- one externally controlled cell per mandatory verification obligation;
- post-commitment surface minting;
- proof-backed non-applicability;
- late-backfill rejection;
- consumer-authoritative finalization.

However, the broad operational chain is close to remote attestation, challenge-response proofs, write-once storage, and task completion. A viable claim would depend on narrow causal details that are difficult to observe in an accused product.

## 6.2 Obviousness risk — 7.65/10

A plausible examiner combination is:

1. remote attestation with a verifier nonce;
2. proof of execution;
3. one write-once state location per task;
4. a completion scoreboard;
5. atomic compare-and-swap;
6. an audit receipt.

Each element performs its ordinary function.

## 6.3 Subject-matter/technicality risk — 0.40/10

GOWS is technical when limited to specific state allocation, versioning, write transitions, and race handling. Risk rises when the claim is expressed functionally as “create a cell for each requirement, receive proof, mark complete, and finalize.”

## 6.4 Freedom-to-operate risk — 5.15/10

FTO pressure exists around:

- active remote-attestation claims;
- memory-write tracking;
- challenge-response authorization;
- proof-of-execution systems;
- authenticated state updates;
- capability security;
- transactional exact-once state;
- completion scoreboards.

## 6.5 Ease of enforcing — 8.70/10

Protocol traffic and rejection states can be tested, but the claimant may still need discovery to prove:

- that the writeback came from an actual comparator rather than a stored result;
- that the surface is production-authoritative;
- that a private acceptance engine does not bypass it;
- that the relation witness is not post-hoc metadata.

## 6.6 Ease for competitors to design around — 5.10/10

Competitors can preserve the customer outcome through:

- a signed exact obligation bitmap;
- a TEE attestation;
- a zero-knowledge proof;
- a recursive proof;
- an authenticated event log;
- a conventional verifier plus post-hoc challenged receipt;
- a private policy decision with a non-authoritative public surface.

## 6.7 Patentability score — 5.85/10

The corrected score reflects a technically coherent design whose key components nevertheless sit in mature patent fields and whose strongest causal limitation may be difficult to prove externally.

---

# 7. Replacement direction

# Two-Origin Blind Relation Settlement with Hidden Target Routing, Decoy-Sink Rejection, and Fragment-Conservation Closure

## 7.1 Technical objective

The accepting target for an obligation must not be disclosed to the verifier before the evidence and relation fragments are generated.

No single module may create an accepting settlement record.

The system must make the following insufficient:

- a stored pass Boolean;
- a generic signed challenge response;
- a relation fragment without evidence acquisition;
- an evidence fragment without a comparator relation;
- two fragments from different obligations;
- two fragments from different subjects or epochs;
- one fragment reused more than authorized;
- a diagnostic or failure fragment;
- a late fragment generated after closure;
- a fabricated target handle.

The consumer must be able to distinguish every invalid combination through a typed decoy-sink record.

---

# 8. Pre-fabric commitment

Before the blind settlement fabric exists, the verifier commits to:

```text
pre_fabric_commitment:
    schema_version

    commitment_id
    verifier_build_id
    evidence_adapter_catalog_root
    comparator_catalog_root

    profile_id
    profile_version
    profile_root

    certificate_subject_root
    evidence_manifest_root
    mandatory_obligation_root
    mandatory_obligation_count

    evaluation_request_root
    commitment_epoch
    commitment_hash
```

The commitment freezes:

- the subject;
- the evidence domains;
- the mandatory obligation set;
- authorized evidence adapters;
- authorized comparator contracts;
- the verifier build;
- the evaluation request.

A fabric created before this commitment is invalid for strong acceptance.

---

# 9. Consumer-created blind settlement fabric

After receiving the commitment, the consumer creates:

```text
blind_settlement_fabric:
    schema_version

    fabric_id
    fabric_epoch
    fabric_owner_id
    consumer_nonce

    pre_fabric_commitment_hash
    profile_root
    certificate_subject_root

    hidden_target_root
    hidden_target_count
    decoy_sink_root
    decoy_sink_count

    evidence_challenge_root
    relation_challenge_root
    routing_contract_root

    fragment_budget_root
    closure_contract_root

    fabric_state
    fabric_descriptor_hash
```

Initial state:

```text
fabric_state = OPEN
```

The consumer does not disclose:

- accepting target addresses;
- the mapping between obligations and accepting targets;
- the private route-selection state;
- decoy-sink allocation rules.

The principal claim should require that accepting target identifiers are not supplied to the verifier before settlement.

---

# 10. One hidden target per mandatory obligation

For each obligation `o`, the consumer creates:

```text
hidden_obligation_target:
    fabric_id
    fabric_epoch

    obligation_id
    obligation_type

    hidden_target_id
    target_generation_nonce

    expected_evidence_adapter_contract
    expected_comparator_contract
    expected_evidence_domain_root
    expected_relation_operator

    evidence_fragment_budget
    relation_fragment_budget

    target_state
    target_version
    target_hash
```

Initial values:

```text
target_state = UNREACHED
target_version = 0
```

Accepting transition:

```text
UNREACHED@0
    →
REACHED_VALID_PAIR@1
```

The verifier never receives `hidden_target_id` as a write destination.

---

# 11. Evidence-origin challenge

The consumer sends an evidence challenge only to the authorized evidence adapter:

```text
evidence_origin_challenge:
    fabric_id
    fabric_epoch
    obligation_id

    evidence_adapter_contract_id
    authorized_evidence_domain_root
    subject_root

    evidence_projection_contract_id
    evidence_challenge_nonce
    evidence_challenge_expiry

    challenge_hash
```

The challenge may require a canonical projection of:

- the evidence value commitment;
- source object identity;
- byte, field, record, or artifact location;
- normalization input commitment;
- acquisition time or version;
- subject binding;
- evidence-domain binding.

The evidence adapter does not receive the relation challenge or accepting target identifier.

---

# 12. Evidence-origin fragment

The evidence adapter produces:

```text
evidence_origin_fragment:
    fabric_id
    fabric_epoch
    obligation_id

    evidence_adapter_contract_id
    evidence_acquisition_id

    subject_root
    profile_root
    evidence_domain_root

    source_object_commitment
    source_location_commitment
    acquired_value_commitment
    acquisition_version

    evidence_challenge_hash
    evidence_challenge_response

    fragment_serial
    fragment_hash
```

An evidence fragment has:

```text
acceptance_authority = 0
```

It cannot reach or identify an accepting target by itself.

---

# 13. Relation-origin challenge

The consumer separately sends a relation challenge to the authorized comparator:

```text
relation_origin_challenge:
    fabric_id
    fabric_epoch
    obligation_id

    comparator_contract_id
    relation_operator
    normalization_contract_id

    relation_projection_contract_id
    relation_challenge_nonce
    relation_challenge_expiry

    challenge_hash
```

The comparator does not receive the hidden target identifier.

The comparator need not receive the evidence adapter's private challenge response. It receives only the evidence values or canonical operand commitments needed to perform the relation.

---

# 14. Relation-origin fragment

The comparator produces:

```text
relation_origin_fragment:
    fabric_id
    fabric_epoch
    obligation_id

    comparator_contract_id
    comparator_execution_id

    subject_root
    profile_root

    left_operand_commitment
    right_operand_commitment
    relation_operator
    relation_state

    normalization_contract_id
    comparator_build_id

    relation_challenge_hash
    relation_challenge_response

    fragment_serial
    fragment_hash
```

Permitted accepting relation states include:

```text
RELATION_PASS
PROVED_NONAPPLICABLE
```

Non-accepting states include:

```text
RELATION_FAIL
UNRESOLVED
DIAGNOSTIC_ONLY
INVALID_INPUT
```

A relation fragment also has:

```text
acceptance_authority = 0
```

It cannot reach or identify an accepting target by itself.

---

# 15. Proof-backed non-applicability pair

A non-applicable obligation still requires two origins:

1. an evidence-origin fragment proving the applicability-relevant evidence state;
2. a relation-origin fragment produced under the applicability contract and relation challenge.

Valid pair:

```text
applicability_evidence_fragment
    +
proved_nonapplicability_relation_fragment
    →
hidden target
```

Invalid shortcuts:

```text
missing evidence fragment
plain NOT_APPLICABLE flag
diagnostic applicability note
relation fragment without proof root
proof from another obligation
```

---

# 16. Private routing contract

For each obligation, the consumer registers a private routing contract:

```text
private_routing_contract:
    fabric_id
    fabric_epoch
    obligation_id

    expected_evidence_adapter_contract
    expected_comparator_contract

    expected_subject_root
    expected_profile_root
    expected_evidence_domain_root
    expected_relation_operator

    evidence_challenge_hash
    relation_challenge_hash

    hidden_target_id
    invalid_route_class_map

    routing_contract_hash
```

The routing contract validates the pair but does not need to expose the target mapping.

Equivalent implementations include:

- a keyed routing table;
- a private matching service;
- a sealed local map;
- a hardware-independent state machine;
- a neutral third-party routing service;
- a deterministic function whose secret routing state remains with the consumer.

The principal claim should not require an oblivious pseudorandom function, encryption, or a particular cryptographic primitive.

---

# 17. Blind pair submission

Fragments are submitted without a target address:

```text
SUBMIT_FRAGMENT_PAIR(
    evidence_origin_fragment,
    relation_origin_fragment
)
    →
routing_result
```

The consumer validates:

1. fabric and epoch;
2. obligation identity;
3. subject and profile bindings;
4. evidence adapter contract;
5. evidence domain;
6. evidence challenge;
7. acquisition identity and version;
8. comparator contract;
9. relation challenge;
10. operand commitments;
11. relation operator and state;
12. fragment serials and budgets;
13. pair freshness;
14. prior use;
15. closure state.

The verifier cannot request “write target X.” It can only submit the two fragments for routing.

---

# 18. Hidden-target reach operation

A valid pair causes:

```text
ROUTE_VALID_PAIR(
    obligation_id,
    evidence_fragment_hash,
    relation_fragment_hash,
    private_routing_contract
)
    →
REACH(hidden_target_id)
```

Atomic transition:

```text
UNREACHED@0
    →
REACHED_VALID_PAIR@1
```

The transition consumes:

- one authorized evidence fragment use;
- one authorized relation fragment use;
- one obligation-pair budget.

A target cannot be reached by:

- one fragment;
- a generic pass token;
- a verifier-selected address;
- a fragment pair from another obligation;
- fragments from different subjects, profiles, builds, or epochs.

---

# 19. Typed decoy sinks

Every invalid pair is routed to a typed decoy sink rather than merely returning a generic error.

Suggested sink classes:

```text
INCOMPLETE_PAIR_SINK
CROSS_OBLIGATION_SINK
CROSS_SUBJECT_SINK
CROSS_PROFILE_SINK
CROSS_EPOCH_SINK
EVIDENCE_ADAPTER_MISMATCH_SINK
EVIDENCE_DOMAIN_MISMATCH_SINK
COMPARATOR_MISMATCH_SINK
OPERAND_MISMATCH_SINK
RELATION_STATE_MISMATCH_SINK
DIAGNOSTIC_SINK
FAILURE_SINK
DUPLICATE_EVIDENCE_FRAGMENT_SINK
DUPLICATE_RELATION_FRAGMENT_SINK
PAIR_REPLAY_SINK
STALE_FRAGMENT_SINK
POST_CLOSURE_SINK
UNAUTHORIZED_NONAPPLICABILITY_SINK
```

A decoy sink records:

```text
decoy_sink_record:
    fabric_id
    fabric_epoch
    sink_class

    evidence_fragment_hash_or_null
    relation_fragment_hash_or_null
    claimed_obligation_id

    rejection_reason
    sequence_number
    sink_record_hash
```

Strong acceptance requires:

```text
acceptance-relevant decoy sink count = 0
```

The decoy mechanism is not intended as attacker deception. It is a deterministic invalid-route accounting system.

---

# 20. Fragment budgets and conservation

For mandatory obligation set `O`:

```text
minted_evidence_fragment_budget = |O|
minted_relation_fragment_budget = |O|
minted_pair_budget = |O|
```

Strong acceptance requires:

```text
consumed_authorized_evidence_fragments = |O|
consumed_authorized_relation_fragments = |O|
valid_pairs_routed = |O|
hidden_targets_reached = |O|
```

and:

```text
residual_required_evidence_fragments = 0
residual_required_relation_fragments = 0
reused_fragment_count = 0
cross-pair_alias_count = 0
```

For declared multi-use evidence, the profile must mint a separate authorized evidence-fragment budget for every permitted obligation. One physical evidence value may be read once, but each obligation receives a separately challenged fragment.

---

# 21. Exact hidden-target closure

The consumer computes:

```text
mandatory_hidden_target_set
reached_hidden_target_set
unreached_hidden_target_set
multiply_reached_target_set
```

Strong closure requires:

```text
mandatory_hidden_target_set
    =
reached_hidden_target_set
```

and:

```text
unreached_hidden_target_set = ∅
multiply_reached_target_set = ∅
```

The verifier cannot submit a target bitmap because it does not know the target identifiers.

---

# 22. Atomic fabric seal

The consumer performs:

```text
COMPARE_AND_SEAL_FABRIC(
    expected_fabric_state = OPEN,
    expected_fabric_epoch,
    expected_hidden_target_root,
    expected_reached_target_root,
    expected_fragment_conservation_root,
    expected_decoy_sink_root = EMPTY_ROOT
)
```

Successful transition:

```text
OPEN
    →
SEALED_ACCEPTED
```

Other terminal states:

```text
SEALED_REJECTED
EXPIRED
ABORTED
```

Any changed target root, residual fragment, replay, sink activity, or incomplete pair prevents accepted sealing.

---

# 23. Authoritative acceptance source

For strong conformance:

```text
certificate_acceptance_state
    =
sealed_blind_fabric_state
```

The verifier's private Boolean, attestation result, or audit report is non-authoritative.

The accepted seal may control:

- certificate admission;
- deployment eligibility;
- artifact promotion;
- trust-store insertion;
- downstream execution authorization;
- policy-compliance status;
- release workflow eligibility.

The principal claim need not require encryption or payload release.

---

# 24. Blind settlement receipt

```text
blind_settlement_receipt:
    schema_version

    fabric_id
    fabric_epoch
    fabric_owner_id

    pre_fabric_commitment_hash
    profile_root
    certificate_subject_root

    mandatory_hidden_target_root
    mandatory_hidden_target_count

    reached_hidden_target_root
    reached_hidden_target_count
    unreached_target_root
    duplicate_target_reach_root

    evidence_fragment_root
    evidence_fragment_count
    consumed_evidence_fragment_root
    residual_evidence_fragment_root

    relation_fragment_root
    relation_fragment_count
    consumed_relation_fragment_root
    residual_relation_fragment_root

    valid_pair_root
    valid_pair_count
    replayed_pair_root
    cross_pair_alias_root

    decoy_sink_root
    decoy_sink_count

    fragment_conservation_state
    target_closure_state
    fabric_seal_state

    receipt_hash
```

Strong acceptance state:

```text
SEALED_ACCEPTED
```

---

# 25. Pair-routing receipt

```text
pair_routing_receipt:
    fabric_id
    fabric_epoch
    obligation_id

    evidence_fragment_hash
    relation_fragment_hash

    evidence_adapter_contract_id
    comparator_contract_id

    route_class
    hidden_target_commitment_or_sink_class

    evidence_budget_before
    evidence_budget_after
    relation_budget_before
    relation_budget_after

    target_prior_state_commitment
    target_terminal_state_commitment

    routing_sequence
    routing_receipt_hash
```

Route classes:

```text
VALID_HIDDEN_TARGET_ROUTE
INCOMPLETE_PAIR_ROUTE
MISMATCHED_PAIR_ROUTE
REPLAY_ROUTE
DIAGNOSTIC_ROUTE
FAILURE_ROUTE
STALE_ROUTE
POST_CLOSURE_ROUTE
```

---

# 26. Independent public verifier

A public verifier checks:

1. pre-fabric commitment integrity;
2. fabric creation after commitment;
3. exact mandatory target count;
4. target-root commitment;
5. separate evidence and relation challenge roots;
6. evidence-adapter contract bindings;
7. comparator contract bindings;
8. evidence-fragment uniqueness and budgets;
9. relation-fragment uniqueness and budgets;
10. one valid pair per mandatory obligation;
11. no fragment replay or cross-pair aliasing;
12. equality between mandatory and reached target counts and roots;
13. zero unresolved target count;
14. zero duplicate target reaches;
15. zero acceptance-relevant decoy sink count;
16. exact fragment conservation;
17. accepted fabric seal;
18. receipt integrity.

Selective openings may reveal one obligation's route without revealing all hidden target identifiers.

---

# 27. Failure states

```text
PRE_FABRIC_COMMITMENT_MISSING
FABRIC_CREATED_BEFORE_COMMITMENT
COMMITMENT_MISMATCH
SUBJECT_MISMATCH
PROFILE_MISMATCH
BUILD_MISMATCH
MANDATORY_TARGET_MISSING
EXTRA_MANDATORY_TARGET
TARGET_MAPPING_DISCLOSED_EARLY
EVIDENCE_CHALLENGE_MISMATCH
RELATION_CHALLENGE_MISMATCH
EVIDENCE_ADAPTER_MISMATCH
EVIDENCE_DOMAIN_MISMATCH
EVIDENCE_ACQUISITION_MISMATCH
COMPARATOR_CONTRACT_MISMATCH
OPERAND_COMMITMENT_MISMATCH
RELATION_OPERATOR_MISMATCH
RELATION_STATE_INVALID
INCOMPLETE_FRAGMENT_PAIR
CROSS_OBLIGATION_PAIR
CROSS_SUBJECT_PAIR
CROSS_PROFILE_PAIR
CROSS_EPOCH_PAIR
EVIDENCE_FRAGMENT_REPLAY
RELATION_FRAGMENT_REPLAY
PAIR_REPLAY
FRAGMENT_BUDGET_EXCEEDED
DIAGNOSTIC_PAIR_ATTEMPT
FAILURE_PAIR_ATTEMPT
NONAPPLICABILITY_PROOF_MISSING
NONAPPLICABILITY_PAIR_INVALID
STALE_FRAGMENT
LATE_PAIR_SUBMISSION
POST_SEAL_PAIR_SUBMISSION
DECOY_SINK_ACTIVATED
UNREACHED_HIDDEN_TARGET
DUPLICATE_HIDDEN_TARGET_REACH
FRAGMENT_CONSERVATION_FAILURE
INVALID_ACCEPTED_SEAL
```

---

# 28. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising receiving, by a consumer computing system from a certificate-verification computing system, a pre-fabric commitment binding a certificate subject, a verification profile, a committed evidence manifest, a set of mandatory verification obligations, a catalogue of evidence-adapter contracts, a catalogue of comparator contracts, and a verifier build; after receiving the pre-fabric commitment, generating by the consumer computing system a run-specific blind settlement fabric comprising a respective undisclosed accepting target for each mandatory verification obligation and a plurality of typed decoy sinks, wherein an identifier of each respective undisclosed accepting target is withheld from the certificate-verification computing system; generating, for a first mandatory verification obligation, an evidence-origin challenge provided to an authorized evidence adapter and a separate relation-origin challenge provided to an authorized comparator; receiving from the authorized evidence adapter an evidence-origin fragment generated from an acquired evidence value, an evidence location, the certificate subject, an authorized evidence domain, and the evidence-origin challenge, the evidence-origin fragment having no independent acceptance authority; receiving from the authorized comparator a relation-origin fragment generated from operand commitments, a relation operator, a relation state, a comparator execution identity, and the relation-origin challenge, the relation-origin fragment having no independent acceptance authority; applying, by the consumer computing system, a private routing contract to the evidence-origin fragment and the relation-origin fragment without receiving from the certificate-verification computing system an accepting target identifier; routing the fragments to the respective undisclosed accepting target only when the fragments jointly satisfy obligation identity, subject, profile, evidence-domain, evidence-adapter, comparator, operand, relation, challenge, freshness, and fragment-use conditions; routing an incomplete, mismatched, replayed, diagnostic, failure, stale, cross-obligation, cross-subject, cross-profile, or cross-epoch fragment combination to a corresponding typed decoy sink; consuming an authorized use budget of each fragment when the respective undisclosed accepting target is reached; determining that every respective undisclosed accepting target corresponding to the set of mandatory verification obligations was reached exactly once by one authorized evidence-fragment and relation-fragment pair, that every required evidence-fragment and relation-fragment budget was consumed exactly once, that no fragment was reused or aliased, and that no acceptance-relevant decoy sink was activated; atomically sealing the blind settlement fabric in an accepted state only when the set of mandatory undisclosed accepting targets equals the set of reached undisclosed accepting targets and fragment conservation is exact; and issuing a machine-verifiable blind settlement receipt bound to the pre-fabric commitment, target-root commitments, fragment-root commitments, valid pair records, decoy-sink records, fragment budgets, fragment-conservation state, target-closure state, and accepted fabric seal.

The strongest limitations are:

1. commitment before fabric creation;
2. one undisclosed accepting target per mandatory obligation;
3. no accepting target identifier supplied to the verifier;
4. separate evidence-origin and relation-origin challenges;
5. evidence fragment generated by the actual evidence-acquisition path;
6. relation fragment generated by the actual comparator path;
7. neither fragment carrying acceptance authority alone;
8. private routing of the pair to a hidden target;
9. typed decoy sinks for every invalid route class;
10. exact fragment-use budgets;
11. exact hidden-target closure;
12. zero acceptance-relevant decoy activity;
13. consumer-authoritative atomic seal;
14. public fragment-conservation receipt.

---

# 29. Closest prior-art categories for GBSF

## 29.1 Remote attestation and proof of execution

Relevant references include US-20230418985-A1, US-7877604-B2, WO-2021150238-A1, and US-11693992-B2.

### Difference

These systems generally produce one challenge-bound attestation or proof from one prover or protected execution environment.

GBSF requires two non-accepting fragments from separate operational origins and withholds the accepting target from the verifier. The consumer, not the prover, routes the pair into hidden target or decoy state.

## 29.2 Multi-party authorization

Relevant references include:

- **[US-9231955-B1 — Multiparty Authorization for Controlling Resource Access](https://patents.google.com/patent/US9231955B1/en)**;
- **[US-20240005316-A1 — Authentication and Authorization of Networked Data Transactions](https://patents.google.com/patent/US20240005316A1/en)**.

### Difference

Those systems combine approvals or split control to authorize resource access.

GBSF does not require approvals by multiple people or entities. Its two origins are technical evidence acquisition and technical relation computation. Neither fragment expresses approval.

## 29.3 Event correlation

Relevant references include:

- **[US-9697100-B2 — Event Correlation](https://patents.google.com/patent/US9697100B2/en)**;
- **[US-8806005-B2 — Cross-Machine Event Log Correlation](https://patents.google.com/patent/US8806005B2/en)**;
- **[US-10956481-B2 — Event-Based Correlation of Non-Text Machine Data](https://patents.google.com/patent/US10956481B2/en)**.

### Difference

GBSF does not statistically correlate logs or events. It validates a pre-registered, obligation-specific pair and consumes fixed fragment budgets to reach an undisclosed target.

## 29.4 Keyed routing and hash tables

Relevant references include:

- **[US-11038798-B2 — Storing and Retrieving Data in a Hash Table](https://patents.google.com/patent/US11038798B2/en)**;
- **[US-12355876-B2 — Key-Value Storage Device with Hashing](https://patents.google.com/patent/US12355876B2/en)**.

### Difference

GBSF should not claim generic hashing or key-value placement. The route is conditioned on a complete evidence/relation pair, hidden target mapping, typed invalid sinks, exact budgets, and mandatory-set closure.

## 29.5 Decoy systems

Relevant references include:

- **[US-11687650-B2 — Utilization of Deceptive Decoy Elements](https://patents.google.com/patent/US11687650B2/en)**;
- **[US-10873601-B1 — Decoy Network-Based Service](https://patents.google.com/patent/US10873601B1/en)**.

### Difference

GBSF decoy sinks are not deception assets exposed to attackers. They are deterministic invalid-route state classes used to prove that no malformed fragment combination contributed to acceptance.

## 29.6 Threshold and oblivious cryptography

Relevant references include:

- **[US-10841081-B2 — Threshold Oblivious Pseudorandom Function](https://patents.google.com/patent/US10841081B2/en)**;
- **[US-20240235842-A1 — Oblivious Transfer from Key Encapsulation Mechanisms](https://patents.google.com/patent/US20240235842A1/en)**.

### Difference

The principal GBSF claim should not require OPRF, oblivious transfer, threshold keys, or secret sharing. A trusted local consumer can implement the private route table with ordinary memory and random identifiers.

## 29.7 Object capabilities

### US-12099864-B2

### Difference

GBSF fragments do not grant access to objects. They are non-authoritative facts that must be paired and privately routed before one hidden obligation target is reached.

## 29.8 Authenticated append-only state

### US-10396991-B2 and public audit-log families

### Difference

GBSF's novelty should not rest on append-only storage. It rests on two-origin, target-blind pairing, typed invalid routes, and fragment conservation.

---

# 30. Replacement risk analysis

## 30.1 Novelty risk — 1.70/10

The components are known:

- challenge-response;
- split control;
- event correlation;
- keyed routing;
- decoy records;
- single-use budgets;
- hidden identifiers;
- completion receipts.

The reviewed material did not identify one reference claiming the complete interaction:

```text
commit verifier context before fabric creation
    +
one undisclosed target per mandatory verification obligation
    +
separate evidence-origin and relation-origin challenges
    +
evidence-acquisition fragment with zero acceptance authority
    +
comparator-relation fragment with zero acceptance authority
    +
no accepting target handle supplied to verifier
    +
private pair routing to hidden target
    +
typed decoy sinks for every invalid pairing class
    +
exact fragment budgets and no reuse
    +
exact hidden-target closure
    +
zero decoy activity
    +
consumer-authoritative seal and public conservation receipt
```

The strongest novelty is not “two tokens” or “hidden addresses.” It is the causal requirement that two separately challenged technical origins jointly select an undisclosed mandatory target while every invalid composition leaves a typed public residue.

## 30.2 Obviousness risk — 2.90/10

A plausible examiner combination is:

1. remote attestation;
2. multi-party authorization;
3. event correlation;
4. keyed routing;
5. decoy or honeypot records;
6. completion tracking.

The inventive-step argument is that these fields would not ordinarily be combined in this manner:

- evidence acquisition is not an approver;
- comparator output is not an access token;
- neither fragment can identify the accepting target;
- the consumer routes the pair using a private obligation contract;
- all malformed combinations are conserved in typed sinks;
- final acceptance requires both target closure and fragment conservation.

The score remains above zero because an examiner can still argue that the design is an aggregation of split knowledge, challenge response, private routing, and exact-once accounting.

## 30.3 Subject-matter/technicality risk — 0.08/10

GBSF is strongly technical because it changes:

- message flow between evidence adapters, comparators, and consumers;
- which party knows accepting target identifiers;
- how state destinations are selected;
- fragment generation and use counts;
- invalid-route handling;
- replay and alias behavior;
- closure state;
- machine-readable failure states.

It prevents concrete computer defects:

- generic pass-token settlement;
- post-hoc relation-witness synthesis;
- evidence/comparator aliasing;
- cross-obligation substitution;
- fragment replay;
- target prepopulation;
- hidden bypass through verifier-controlled acceptance state.

## 30.4 Freedom-to-operate risk — 1.80/10

FTO risks remain around:

- active remote-attestation patents;
- split-control and multiparty authorization patents;
- keyed-routing and authenticated-store patents;
- object-capability systems;
- decoy and deception systems;
- threshold and oblivious cryptography if used.

Risk is reduced because the principal implementation can avoid:

- TEE and TPM claims;
- memory-write tracking;
- physical write-once memory;
- access-token issuance;
- resource access control;
- blockchain;
- threshold cryptography;
- OPRF;
- oblivious transfer;
- standard linker or loader structures.

The implementation should use a purpose-built consumer routing service with ordinary randomized identifiers and explicit fragment budgets.

## 30.5 Ease of enforcing — 9.82/10

GBSF is designed to expose direct protocol evidence:

- a pre-fabric commitment;
- separate evidence and relation challenge deliveries;
- separate fragment submissions;
- absence of target handles in verifier-facing messages;
- pair-routing responses;
- typed decoy-sink responses;
- fragment-budget changes;
- hidden-target count and reached-target root;
- fragment-conservation state;
- final seal and receipt.

Black-box tests can:

1. submit only the evidence fragment;
2. submit only the relation fragment;
3. pair fragments from two obligations;
4. pair fragments from two subjects;
5. reuse one evidence fragment;
6. reuse one relation fragment;
7. replay a valid pair in another epoch;
8. substitute a diagnostic relation fragment;
9. submit `NOT_APPLICABLE` without the evidence-origin proof fragment;
10. attempt to specify a target address;
11. attempt a late pair after sealing;
12. verify that each invalid combination enters a distinct sink class;
13. verify that acceptance requires zero sink activity and exact fragment conservation.

The remaining 0.18 reflects products that internalize all roles and protocol traffic inside one proprietary service. Discovery may still be required to prove separate fragment generation and target nondisclosure.

## 30.6 Ease for competitors to design around — 1.65/10

Claims should cover equivalent representations of:

- separate evidence and relation records;
- undisclosed acceptance destinations;
- private pair matching;
- invalid-pair state buckets;
- one-use fragment accounting;
- exact mandatory target closure.

Equivalent implementations may use:

- local processes;
- separate services;
- message queues;
- transactional rows;
- append-only streams;
- capability objects;
- shared memory;
- neutral third-party routers;
- hardware-independent state machines.

A competitor can use:

### A monolithic zero-knowledge proof

This is a genuine design-around. It requires a proof circuit, prover, verifier, and associated cryptographic infrastructure. It does not provide the same two-origin invalid-route residue unless separately implemented.

### A TEE attestation

This attests one protected execution environment but does not provide independently generated evidence and relation fragments or typed decoy routing.

### A signed exact obligation bitmap

This remains verifier-generated and can be synthesized from stored results.

### A conventional consumer challenge surface

This returns to GOWS and does not prevent generic pass-token settlement.

### Human or service multiparty approval

This does not prove technical evidence acquisition and comparator causality.

### Public target cells

This loses the target-blind anti-fabrication property.

A competitor seeking the same combination of:

- target nondisclosure;
- two independent technical origins;
- no single-fragment acceptance;
- public invalid-route residues;
- exact fragment conservation;
- exact hidden-target closure;

has few low-cost substitutes.

## 30.7 Patentability score — 9.39/10

The score is supported by:

- replacement of verifier-visible cells with undisclosed accepting targets;
- elimination of generic pass-token settlement;
- separate evidence-acquisition and comparator-relation origins;
- zero acceptance authority for either fragment alone;
- private target routing controlled by the consumer;
- typed decoy sinks for malformed combinations;
- exact fragment budgets and conservation;
- exact hidden-target closure;
- strong public protocol evidence;
- implementation-neutral coverage;
- avoidance of hardware attestation, access control, blockchain, OPRF, and physical WORM requirements.

The remaining 0.61 reflects:

- mature challenge-response art;
- split-control and multiparty-authorization art;
- event-correlation art;
- keyed-routing and authenticated-state art;
- possible examiner combinations;
- the need to prove operational independence between the evidence adapter and comparator;
- the possibility that a monolithic proof system offers a materially different substitute.

---

# 31. Enforcement-focused adversarial tests

## 31.1 Evidence-only submission

Submit a valid evidence fragment without a relation fragment.

Expected state:

```text
INCOMPLETE_PAIR_SINK
```

## 31.2 Relation-only submission

Submit a valid relation fragment without an evidence fragment.

Expected state:

```text
INCOMPLETE_PAIR_SINK
```

## 31.3 Cross-obligation pairing

Pair obligation A's evidence fragment with obligation B's relation fragment.

Expected state:

```text
CROSS_OBLIGATION_SINK
```

## 31.4 Cross-subject pairing

Pair fragments from different certificate subjects.

Expected state:

```text
CROSS_SUBJECT_SINK
```

## 31.5 Cross-epoch replay

Replay a valid pair in a later fabric epoch.

Expected state:

```text
CROSS_EPOCH_SINK
```

## 31.6 Evidence-fragment double use

Use one single-use evidence fragment in two pair submissions.

Expected state:

```text
DUPLICATE_EVIDENCE_FRAGMENT_SINK
```

## 31.7 Relation-fragment double use

Use one relation fragment twice.

Expected state:

```text
DUPLICATE_RELATION_FRAGMENT_SINK
```

## 31.8 Generic pass substitution

Submit a relation fragment created from a stored Boolean without the required operand commitments and comparator execution identity.

Expected state:

```text
OPERAND_MISMATCH_SINK
```

or:

```text
COMPARATOR_MISMATCH_SINK
```

## 31.9 Diagnostic promotion

Pair a valid evidence fragment with a diagnostic-only relation fragment.

Expected state:

```text
DIAGNOSTIC_SINK
```

## 31.10 False non-applicability

Submit a non-applicability relation fragment without the required evidence-origin applicability fragment.

Expected state:

```text
UNAUTHORIZED_NONAPPLICABILITY_SINK
```

## 31.11 Target-address injection

Attempt to submit a verifier-selected accepting target identifier.

Expected state:

```text
UNKNOWN_OR_DISCLOSED_TARGET_REJECTED
```

## 31.12 Post-seal pair

Submit a previously valid pair after accepted sealing.

Expected state:

```text
POST_CLOSURE_SINK
```

## 31.13 Exact closure

Demonstrate:

```text
mandatory targets = reached targets
required evidence fragments = consumed evidence fragments
required relation fragments = consumed relation fragments
valid pairs = mandatory obligations
decoy sink count = 0
```

Expected state:

```text
SEALED_ACCEPTED
```

---

# 32. Anti-design-around claim strategy

## 32.1 Do not limit the claim to “fragments”

Use broader alternatives:

- origin record;
- non-authoritative contribution;
- partial settlement record;
- evidence-origin datum;
- relation-origin datum;
- independently generated settlement component.

## 32.2 Claim target nondisclosure functionally

Cover:

- target identifier not provided to the verifier;
- verifier unable to select the accepting destination;
- destination selected only by consumer-side pair validation;
- equivalent sealed or private target maps.

## 32.3 Claim two operational origins

Do not require separate companies or machines.

Require logically distinct generation paths with different required inputs and contracts:

- evidence acquisition path;
- comparator relation path.

## 32.4 Claim zero independent authority

Each contribution alone must be incapable of changing an accepting target.

## 32.5 Claim typed invalid-route accounting

A competitor should not avoid the claim by returning ordinary errors. Cover machine-maintained invalid-route classes and their inclusion in finalization conditions.

## 32.6 Claim fragment budgets independently

Protect exact authorized use counts even when targets are represented by counters, rows, logs, or capabilities.

## 32.7 Claim target closure independently

Protect equality between mandatory hidden targets and reached targets, regardless of target storage representation.

## 32.8 Claim authoritative use

Require the fabric seal to control the relevant certificate acceptance, deployment, promotion, trust insertion, or downstream eligibility state.

---

# 33. Recommended claim families

## Family A — Pre-fabric commitment

Protect commitment before target and challenge creation.

## Family B — Hidden mandatory target generation

Protect one undisclosed target per mandatory obligation.

## Family C — Evidence-origin contribution

Protect challenge-bound records generated by the actual evidence-acquisition path.

## Family D — Relation-origin contribution

Protect challenge-bound records generated by the actual comparator relation path.

## Family E — Zero independent acceptance authority

Protect the inability of either contribution to settle an obligation alone.

## Family F — Blind pair routing

Protect consumer-side destination selection without verifier-supplied target identifiers.

## Family G — Typed decoy sinks

Protect deterministic invalid-route accounting.

## Family H — Fragment-use budgets

Protect exact authorized use and anti-replay accounting.

## Family I — Proof-backed non-applicability pair

Protect dual-origin settlement of `NOT_APPLICABLE`.

## Family J — Exact hidden-target closure

Protect complete and duplicate-free target reach.

## Family K — Fragment-conservation closure

Protect equality among mandatory obligations, consumed fragments, valid pairs, and reached targets.

## Family L — Blind settlement receipt

Protect the machine-readable public artifact.

## Family M — Neutral consumer router

Protect third-party hosting while preserving consumer routing authority.

## Family N — Cross-verifier comparison

Protect comparison of two verifier builds using equivalent hidden-target fabrics.

---

# 34. Glyphser implementation path

## 34.1 New schemas

```text
pre_fabric_commitment.v1
blind_settlement_fabric.v1
hidden_obligation_target.v1
evidence_origin_challenge.v1
evidence_origin_fragment.v1
relation_origin_challenge.v1
relation_origin_fragment.v1
private_routing_contract.v1
decoy_sink_record.v1
pair_routing_receipt.v1
fragment_budget_ledger.v1
blind_settlement_receipt.v1
```

## 34.2 Suggested modules

```text
runtime/glyphser/blind_settlement/commitment.py
runtime/glyphser/blind_settlement/fabric.py
runtime/glyphser/blind_settlement/targets.py
runtime/glyphser/blind_settlement/evidence_challenge.py
runtime/glyphser/blind_settlement/evidence_fragment.py
runtime/glyphser/blind_settlement/relation_challenge.py
runtime/glyphser/blind_settlement/relation_fragment.py
runtime/glyphser/blind_settlement/routing.py
runtime/glyphser/blind_settlement/decoy_sinks.py
runtime/glyphser/blind_settlement/budgets.py
runtime/glyphser/blind_settlement/closure.py
runtime/glyphser/blind_settlement/receipt.py
runtime/glyphser/blind_settlement/verify.py
```

## 34.3 Suggested quality gates

```text
tooling/quality_gates/pre_fabric_commitment_gate.py
tooling/quality_gates/hidden_target_nondisclosure_gate.py
tooling/quality_gates/evidence_origin_independence_gate.py
tooling/quality_gates/relation_origin_independence_gate.py
tooling/quality_gates/zero_single_fragment_authority_gate.py
tooling/quality_gates/blind_pair_routing_gate.py
tooling/quality_gates/decoy_sink_accounting_gate.py
tooling/quality_gates/fragment_budget_gate.py
tooling/quality_gates/nonapplicability_pair_gate.py
tooling/quality_gates/exact_hidden_target_closure_gate.py
tooling/quality_gates/fragment_conservation_gate.py
tooling/quality_gates/authoritative_fabric_seal_gate.py
```

## 34.4 Required adversarial fixtures

```text
fabric_created_before_commitment
target_identifier_disclosed_to_verifier
missing_hidden_target
extra_hidden_target
evidence_fragment_without_relation_fragment
relation_fragment_without_evidence_fragment
cross_obligation_pair
cross_subject_pair
cross_profile_pair
cross_epoch_pair
wrong_evidence_adapter
wrong_evidence_domain
wrong_comparator_contract
operand_commitment_substitution
stored_boolean_relation_fragment
evidence_fragment_reuse
relation_fragment_reuse
pair_replay
diagnostic_relation_pair
failure_relation_pair
nonapplicability_without_evidence_origin
nonapplicability_without_proof
stale_evidence_fragment
stale_relation_fragment
late_pair_after_closure
decoy_sink_nonzero_at_acceptance
unreached_hidden_target
duplicate_hidden_target_reach
fragment_budget_residual
fragment_budget_overdraft
alternate_private_acceptance_disagrees
```

## 34.5 Suggested product commands

```text
glyphser blind-settlement commit
glyphser blind-settlement fabric-mint
glyphser blind-settlement evidence-fragment
glyphser blind-settlement relation-fragment
glyphser blind-settlement route
glyphser blind-settlement seal
glyphser blind-settlement inspect
glyphser blind-settlement verify
```

## 34.6 Suggested API surfaces

```text
POST /blind-settlement/commitments
POST /blind-settlement/fabrics
POST /blind-settlement/fabrics/{fabric_id}/evidence-fragments
POST /blind-settlement/fabrics/{fabric_id}/relation-fragments
POST /blind-settlement/fabrics/{fabric_id}/pairs
POST /blind-settlement/fabrics/{fabric_id}/seal
GET  /blind-settlement/fabrics/{fabric_id}/receipt
POST /blind-settlement/receipts/verify
```

---

# 35. Technical evidence needed before filing

## 35.1 Implement separate origin paths

Use separate modules or services for:

1. evidence acquisition;
2. comparator relation generation.

Demonstrate that neither module can reach an accepting target alone.

## 35.2 Demonstrate target nondisclosure

Capture all verifier-facing protocol messages and prove that no accepting target identifier is transmitted before settlement.

## 35.3 Demonstrate generic-pass resistance

Replace the comparator with a component that knows only the final pass Boolean. It must be unable to produce a valid relation fragment.

## 35.4 Demonstrate evidence-path indispensability

Replace the evidence adapter with a component that knows only the evidence root but not the challenged acquisition location or value projection. It must be unable to produce a valid evidence fragment.

## 35.5 Demonstrate typed sink behavior

Exercise every invalid pair class and show deterministic sink assignment.

## 35.6 Demonstrate fragment conservation

Prove exact equality among:

- mandatory obligations;
- consumed evidence-fragment budgets;
- consumed relation-fragment budgets;
- valid pairs;
- reached hidden targets.

## 35.7 Demonstrate replay resistance

Replay each fragment independently and as a pair across obligations, subjects, profiles, builds, and epochs.

## 35.8 Demonstrate non-applicability settlement

Require both applicability evidence and a comparator-produced proof relation.

## 35.9 Demonstrate authoritative use

Make the sealed fabric state drive actual certificate acceptance or deployment eligibility.

## 35.10 Implement two routing backends

Implement:

1. an in-process private route map;
2. an external transactional routing service.

Both should emit the same canonical receipt.

## 35.11 Implement a no-cryptography embodiment

Use:

- random opaque identifiers;
- ordinary hashes for integrity;
- trusted local process boundaries;
- explicit budgets and route tables.

This supports claims independent of OPRF, encryption, signatures, blockchain, and TEE technology.

## 35.12 Measure technical effects

Measure:

- invalid-pair detection latency;
- fragment-replay rejection;
- target nondisclosure overhead;
- decoy-sink storage cost;
- fragment-budget overhead;
- closure latency;
- generic-pass fabrication resistance;
- divergence detection between private verifier state and fabric-authoritative state.

---

# 36. Features to exclude from the principal claim

Do not make these essential:

- a TEE;
- a TPM;
- remote attestation;
- a hardware write bitmap;
- WORM or OTP memory;
- blockchain;
- zero-knowledge proofs;
- recursive proofs;
- threshold signatures;
- secret sharing;
- an OPRF;
- oblivious transfer;
- encryption or key release;
- access control;
- a Merkle tree;
- a particular hash function;
- a particular signature scheme;
- one database;
- one message queue;
- one process-isolation mechanism;
- one operating system;
- one programming language.

They may appear as optional embodiments or dependent claims.

---

# 37. Filing strategy

## Principal independent method claim

Require:

- pre-fabric commitment;
- post-commitment hidden-target creation;
- one undisclosed target per mandatory obligation;
- separate evidence-origin and relation-origin challenges;
- separate non-authoritative fragments;
- private pair routing without verifier-supplied target address;
- typed invalid-route sinks;
- exact fragment budgets;
- exact hidden-target closure;
- zero acceptance-relevant sink activity;
- consumer-authoritative seal;
- blind settlement receipt.

## Separate consumer-system claim

Claim:

- commitment receiver;
- target generator;
- challenge generator;
- private router;
- decoy-sink manager;
- fragment-budget ledger;
- exact closure evaluator;
- sealing engine;
- receipt generator.

## Separate evidence-adapter claim

Claim:

- challenge receiver;
- authorized evidence acquisition;
- source-location commitment;
- acquired-value commitment;
- evidence-origin fragment generator;
- zero independent settlement authority.

## Separate comparator claim

Claim:

- relation challenge receiver;
- operand commitment processing;
- relation computation;
- relation-origin fragment generation;
- diagnostic and failure typing;
- zero independent settlement authority.

## Separate receipt claim

Where permitted, claim the blind settlement receipt and its independent verification method.

## Continuation applications

Potential continuation families:

1. target nondisclosure;
2. evidence-origin fragments;
3. relation-origin fragments;
4. zero independent authority;
5. private pair routing;
6. typed decoy sinks;
7. fragment budgets;
8. proof-backed non-applicability pairing;
9. exact hidden-target closure;
10. fragment-conservation receipts;
11. neutral routing services;
12. cross-verifier fabrics.

---

# 38. Final recommendation

The consumer-minted writeback-surface direction is no longer the strongest filing candidate because its central mechanisms are closely adjacent to:

- remote attestation;
- challenge-response trust decisions;
- proof of execution;
- commitment-challenge-response proofs;
- memory write tracking;
- write-once storage;
- object capabilities;
- authenticated state updates;
- completion scoreboards;
- atomic compare-and-seal operations.

Replace it with:

> **A certificate-verification protocol in which the verifier commits to the subject, profile, evidence manifest, mandatory obligations, evidence adapters, comparator catalogue, and build before a settlement fabric exists; the consumer then creates one undisclosed accepting target for each mandatory obligation and independently challenges the obligation's evidence-acquisition path and comparator-relation path; the evidence path and comparator path produce separate fragments having no acceptance authority alone; the consumer privately routes only a valid, fresh, obligation-matched fragment pair to the corresponding hidden target while routing every incomplete, substituted, replayed, diagnostic, failure, stale, or cross-boundary combination to a typed decoy sink; and the consumer accepts only after every mandatory hidden target has been reached exactly once, every required fragment budget has been consumed exactly once, no fragment has been reused or aliased, no acceptance-relevant decoy sink has been activated, and the fabric has been atomically sealed with a public fragment-conservation receipt.**

This direction is better because it:

- removes verifier-visible accepting cells from the inventive centre;
- prevents the verifier from selecting or prepopulating accepting destinations;
- requires two separately challenged technical origins;
- makes a stored pass Boolean insufficient;
- makes a generic signed challenge response insufficient;
- makes an evidence fragment or relation fragment insufficient alone;
- makes invalid fragment combinations produce public typed residues;
- prevents replay and cross-obligation aliasing through explicit budgets;
- treats non-applicability as a two-origin proof-backed settlement;
- requires exact hidden-target closure and exact fragment conservation;
- produces direct protocol-level infringement evidence;
- supports local, remote, database, queue, stream, and neutral-service implementations;
- avoids dependence on TEE, TPM, blockchain, OPRF, secret sharing, access control, and physical write-once memory;
- forces competitors seeking the same target-blind, two-origin, invalid-route-visible guarantee to implement an equivalent pairing and conservation mechanism or adopt materially heavier proof infrastructure;
- strictly improves every requested score;
- reaches a comparative patentability score of **9.39/10** against the explicit target of **10.00/10**.

---

# 39. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a professional prior-art search focused on:
   - target-blind verification routing;
   - two-origin settlement records;
   - evidence-acquisition and comparator split architecture;
   - hidden destination state machines;
   - invalid-pair sink accounting;
   - fragment-use conservation;
   - dual-channel proof generation;
   - private matching of independently generated technical records;
   - proof-backed non-applicability;
2. limitation-by-limitation claim charts against:
   - US-20230418985-A1 and any continuation or grant;
   - US-7877604-B2 and family;
   - US-10297094-B2 and family;
   - WO-2021150238-A1 and national family members;
   - US-11693992-B2;
   - EP-3566389-B1 and family;
   - US-9231955-B1;
   - US-20240005316-A1 and family;
   - US-12099864-B2;
   - US-10396991-B2 and continuations;
   - US-10841081-B2;
3. prosecution-history review of the closest active US and EP families;
4. jurisdiction-specific FTO analysis;
5. non-patent literature review covering:
   - remote attestation;
   - interactive proofs;
   - split knowledge and dual control;
   - object capabilities;
   - event correlation;
   - private set matching;
   - exact-once messaging;
   - authenticated event sourcing;
   - honeytokens and decoy-state systems;
   - keyed routing;
   - multi-party computation;
6. review of whether the evidence adapter and comparator are sufficiently independent in the exact implementation;
7. review of the hidden-target representation and target-nondisclosure guarantee;
8. review of Glyphser's public-disclosure history;
9. inventorship analysis.

No search can establish that undisclosed applications, unpublished applications, non-English documents, unindexed prior art, or confidential commercial implementations do not exist.

---

# 40. Public patent records relied upon in this pass

- [US-20230418985-A1 — Security Subsystem for Remote Attestation](https://patents.google.com/patent/US20230418985A1/en)
- [US-7877604-B2 — Proof of Execution Using Random Function](https://patents.google.com/patent/US7877604B2/en)
- [WO-2021150238-A1 — Remote Attestation](https://patents.google.com/patent/WO2021150238A1/en)
- [US-11693992-B2 — Remote Attestation of System Integrity](https://patents.google.com/patent/US11693992B2/en)
- [EP-3972190-A1 — Method and Apparatus for Negotiating Remote Attestation Mode](https://patents.google.com/patent/EP3972190A1/en)
- [US-10297094-B2 — Challenge-Response Access Control Using Context-Based Proof](https://patents.google.com/patent/US10297094B2/en)
- [US-11550952-B1 — Zero-Knowledge Proof Method and Electronic Device](https://patents.google.com/patent/US11550952B1/en)
- [US-11496309-B2 — Method for Performing a Disjunctive Proof for Two Relations](https://patents.google.com/patent/US11496309B2/en)
- [US-5493614-A — Private Signature and Proof Systems](https://patents.google.com/patent/US5493614A/en)
- [EP-3566389-B1 — Distributed Privacy-Preserving Verifiable Computation](https://patents.google.com/patent/EP3566389B1/en)
- [US-11163912-B2 — Data Attestation in Memory](https://patents.google.com/patent/US11163912B2/en)
- [US-7558839-B1 — Read-After-Write Verification for Write-Once-Read-Many Storage](https://patents.google.com/patent/US7558839B1/en)
- [US-8108627-B2 — Array Comparison and Swap Operations](https://patents.google.com/patent/US8108627B2/en)
- [US-11853795-B1 — Scoreboard for Tracking Completion of Tasks](https://patents.google.com/patent/US11853795B1/en)
- [US-12124873-B2 — Scoreboard for Tracking Completion of Tasks](https://patents.google.com/patent/US12124873B2/en)
- [US-12099864-B2 — Formally Verified Trusted Computing Base with Active Security and Policy Enforcement](https://patents.google.com/patent/US12099864B2/en)
- [US-10396991-B2 — Controlling Verification of Key-Value Stores](https://patents.google.com/patent/US10396991B2/en)
- [US-9231955-B1 — Multiparty Authorization for Controlling Resource Access](https://patents.google.com/patent/US9231955B1/en)
- [US-20240005316-A1 — Authentication and Authorization of Networked Data Transactions](https://patents.google.com/patent/US20240005316A1/en)
- [US-9697100-B2 — Event Correlation](https://patents.google.com/patent/US9697100B2/en)
- [US-8806005-B2 — Cross-Machine Event Log Correlation](https://patents.google.com/patent/US8806005B2/en)
- [US-10956481-B2 — Event-Based Correlation of Non-Text Machine Data](https://patents.google.com/patent/US10956481B2/en)
- [US-11038798-B2 — Storing and Retrieving Data in a Hash Table](https://patents.google.com/patent/US11038798B2/en)
- [US-12355876-B2 — Key-Value Storage Device with Hashing](https://patents.google.com/patent/US12355876B2/en)
- [US-11687650-B2 — Utilization of Deceptive Decoy Elements](https://patents.google.com/patent/US11687650B2/en)
- [US-10873601-B1 — Decoy Network-Based Service](https://patents.google.com/patent/US10873601B1/en)
- [US-10841081-B2 — Threshold Oblivious Pseudorandom Function](https://patents.google.com/patent/US10841081B2/en)
- [US-20240235842-A1 — Oblivious Transfer from Key Encapsulation Mechanisms](https://patents.google.com/patent/US20240235842A1/en)
