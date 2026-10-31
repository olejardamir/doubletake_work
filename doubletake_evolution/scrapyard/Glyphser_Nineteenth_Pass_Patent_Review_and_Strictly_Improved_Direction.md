# Glyphser Patent Direction
## Nineteenth-Pass Conflict Review, Strictly Improved Risk Scores, and Risk-Focused Replacement Architecture

**Review date:** July 17, 2026  
**Direction re-examined:** *Obligation-Indexed Decodable Closure Codes with Result-Coupled Acceptance Interlocks*  
**Replacement direction:** *Profile-Synthesized Inhabited Acceptance Objects with Constructor-Exclusive Obligation Witnesses*  
**Suggested protocol name:** **Glyphser Inhabited Acceptance Object — GIAO**

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the cited claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation:** This pass used public patent-index searches and direct patent pages, together with references identified in the preceding Glyphser reviews. Public status labels are search signals rather than legal conclusions. The search cannot exclude unpublished applications, unindexed documents, non-English prior art, or relevant non-patent literature. The replacement was selected only after rejecting directions that remained too close to error-correcting codes, set reconciliation, proof-of-compliance systems, proof-carrying computation, execution attestation, challenge matrices, single-use capability systems, and generic schema validation.

---

# 1. Score definitions

All scores use a **0–10 scale**.

| Category | Meaning of a higher score |
|---|---|
| Novelty risk | Worse: greater likelihood that one reference anticipates the proposed claim |
| Obviousness risk | Worse: greater likelihood that an examiner can combine known references |
| Subject-matter/technicality risk | Worse: greater risk of being treated as abstract, administrative, mathematical without sufficient technical application, or insufficiently tied to a technical improvement |
| Freedom-to-operate risk | Worse: greater likelihood that an implementation may practice active third-party claims |
| Ease of enforcing the patent | Better: easier to detect, test, claim-chart, and prove infringement |
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while preserving substantially the same commercial value |

The scores are comparative engineering judgments, not legal conclusions or probabilities.

---

# 2. Executive conclusion

The eighteenth-pass replacement should not remain the principal Glyphser patent nucleus.

That direction proposed:

- compiling a verification profile into an obligation-closure-code specification;
- assigning every mandatory obligation a distinct locator and multiple independent check coordinates;
- creating a profile target codeword representing exactly one authorized result for every obligation;
- emitting obligation-local closure shards bound to evidence, comparator contract, relation state, and result consumption;
- accumulating the shards without execution-order dependence;
- calculating coverage, binding, relation-state, and result-consumption syndromes;
- decoding non-zero syndromes into omitted, duplicated, substituted, or misbound obligations;
- preventing strong acceptance unless every required syndrome was zero;
- deriving an acceptance seal from the same closure state;
- exposing public shard openings.

The deeper search shows that the operational centre is substantially more crowded than the eighteenth-pass scores indicated.

The inventive centre can be decomposed as:

```text
profile-defined record set
    +
order-independent aggregate
    +
checksums or algebraic fingerprints
    +
error-detecting or error-correcting syndromes
    +
set reconciliation and difference localization
    +
schema validation
    +
compliance or integrity acceptance gate
```

The newly material references and categories include:

- **US-10698892-B2 — Order-Independent Multi-Record Hash Generation and Data Filtering**;
- **US-11386235-B1 — Systems and Methods for Dynamic Checksum Generation and Validation with Customizable Levels of Integrity Verification**;
- **US-12095919-B2 — Dynamic Data Compliance Controls at the Highest Directives and Standards Applicable with a Net-Sum Formula as a Zero-Knowledge Proof Compliance Validation Key**;
- **CN-120578670-A/B — Data Consistency Verification for Remote Heterogeneous Terminals**, using invertible Bloom lookup tables, checksums, and decoded difference locations;
- **US-10956403-B2 — Verifying Data Consistency**, using bucket-level comparisons and difference reporting;
- **US-6954892-B2 — Method for Calculating Syndrome Polynomial in Decoding Error Correction Codes**;
- **US-10698892-B2** and related order-independent multirecord aggregation families;
- **US-11809443-B2 — Schema Validation with Support for Ordering**;
- **US-12235830-B2 and EP-3616117-B1 — Verifying Structured Data**;
- **US-12261888-B2 — Authorization Policy Validation**;
- **US-6256734-B1 — Method and Apparatus for Compliance Checking in a Trust Management System**;
- established non-patent literature on invertible Bloom lookup tables, set reconciliation, multiset hashing, algebraic fingerprints, Reed-Solomon and BCH syndrome decoding, sparse parity-check matrices, and authenticated data structures.

The strongest problem is not that one cited reference necessarily claims the entire GDCE aggregate. The problem is that nearly every claimed operation is a conventional use of mature machinery:

```text
mandatory obligation identifiers
    → records or set elements

profile target closure word
    → reference set digest, checksum, codeword, or schema fingerprint

local closure shard
    → record fingerprint, code symbol, accumulator contribution, or parity-check contribution

coverage syndrome
    → set-difference or multiset-difference residue

binding syndrome
    → content checksum or authenticated-field mismatch

relation syndrome
    → encoded status-field mismatch

consumption syndrome
    → count or exact-once bookkeeping mismatch

decoded defect
    → set reconciliation, error localization, or bucket difference report

zero-syndrome acceptance
    → ordinary integrity or compliance gate
```

A skilled examiner can plausibly combine set reconciliation, semantic record hashing, syndrome decoding, and schema validation without changing the ordinary function of any component.

The current direction also has an enforcement weakness that was understated. A public product can expose a closure receipt while implementing completeness by:

- an ordinary map comparison;
- a sorted vector comparison;
- a Merkle-set equality check;
- a database uniqueness constraint;
- a schema validator;
- a SNARK;
- a proof-carrying data object;
- a conventional checklist;
- a custom hash that does not use decodable closure codes.

A similar receipt format therefore does not prove that the accused product uses the claimed locator, codeword, syndrome, or decoder architecture. Source-code discovery may be necessary.

## Revised score for the eighteenth-pass direction

| Category | Eighteenth-pass score | Nineteenth-pass revised score |
|---|---:|---:|
| Novelty risk | 2.50 | **6.75** |
| Obviousness risk | 4.00 | **9.00** |
| Subject-matter/technicality risk | 0.50 | **1.75** |
| Freedom-to-operate risk | 2.50 | **6.25** |
| Ease of enforcing | 9.50 | **7.50** |
| Ease for competitors to design around | 1.50 | **7.25** |

## Replacement decision

Retire this as the principal filing direction:

> **Obligation-Indexed Decodable Closure Codes with Result-Coupled Acceptance Interlocks**

Retain only as optional embodiments:

- order-independent obligation aggregation;
- checksum or codeword summaries;
- defect syndromes;
- bounded defect localization;
- public shard openings.

Proceed instead with:

# **Profile-Synthesized Inhabited Acceptance Objects with Constructor-Exclusive Obligation Witnesses**

The replacement solves a different technical problem:

> Conventional verifiers calculate a Boolean acceptance state and then optionally attach a receipt. The Boolean can be produced through a bypass path, the receipt can omit a mandatory obligation, a generic result can be copied into multiple obligation positions, a diagnostic or failing result can be relabeled as accepting, and downstream software may trust the Boolean without validating the receipt. How can a verification profile be compiled into an exact-shape machine object such that the only representable strong-acceptance artifact contains one locally verifiable, obligation-specific witness component for every mandatory obligation, contains no optional acceptance slots, admits only mutually exclusive authorized witness constructors for each obligation, has no independent authoritative acceptance flag, and is accepted by downstream consumers only after reconstruction and validation of the complete profile-dependent object type?

GIAO changes the acceptance representation itself.

Instead of producing:

```text
accepted = true
receipt = optional evidence
```

it produces:

```text
StrongAcceptance<Profile, Subject>
    =
Product(
    WitnessForObligation_1,
    WitnessForObligation_2,
    ...,
    WitnessForObligation_n
)
```

where every witness slot is:

- non-optional;
- indexed by one profile obligation;
- bound to the certificate subject;
- bound to the authorized evidence selector and evidence commitment;
- bound to the authorized comparator contract;
- restricted to one of the profile-authorized witness constructors;
- locally verifiable by a public checker;
- serialized in one canonical normal form.

For a mandatory obligation, the profile may authorize:

```text
EvaluatedPassWitness<obligation, evidence, comparator, relation>
```

or:

```text
ProvenNonApplicabilityWitness<obligation, applicability_proof>
```

The constructors are disjoint.

A failure, unresolved state, invalid proof, or diagnostic result inhabits a different rejection object and cannot be reinterpreted as a field of the strong-acceptance object.

The final strong-acceptance state is not a Boolean derived from the object.

The valid, completely inhabited acceptance object **is** the strong-acceptance state.

A downstream consumer recognizes strong acceptance only by:

1. resolving the profile-dependent acceptance-object descriptor;
2. validating the exact mandatory slot set;
3. validating each slot's constructor tag;
4. validating the obligation index and subject index;
5. validating the local evidence, comparator, relation, and proof bindings;
6. canonicalizing the object;
7. confirming that no field is missing, duplicated, substituted, optional, unknown, or ambiguously encoded;
8. deriving the accepted object identifier from the validated normal form.

The core interaction is:

```text
profile-generated exact-shape acceptance descriptor
    +
one non-optional obligation-indexed witness slot per mandatory obligation
    +
constructor-exclusive evaluated-pass or proven-nonapplicability witness
    +
local evidence/comparator/relation verification
    +
disjoint rejection object types
    +
canonical whole-object normalization
    +
no independent authoritative acceptance Boolean
    +
downstream acceptance only after complete object validation
```

The principal claim does not require:

- checksums;
- error-correcting codes;
- syndromes;
- set reconciliation;
- invertible Bloom lookup tables;
- cryptographic accumulators;
- a Merkle tree;
- a SNARK;
- a blockchain;
- proof-carrying code for executable safety;
- program slicing;
- runtime control-flow attestation;
- challenge matrices;
- mutation testing;
- single-use tokens;
- an authority ledger;
- trusted hardware;
- a specific programming language;
- a compile-time dependent-type implementation.

This materially reduces exposure to the patents that weaken GDCE.

---

# 3. Revised scores

## 3.1 Direction re-examined

### Obligation-Indexed Decodable Closure Codes with Result-Coupled Acceptance Interlocks

| Category | Revised score |
|---|---:|
| **Novelty risk** | **6.75/10** |
| **Obviousness risk** | **9.00/10** |
| **Subject-matter/technicality risk** | **1.75/10** |
| **Freedom-to-operate risk** | **6.25/10** |
| **Ease of enforcing the patent** | **7.50/10** |
| **Ease for competitors to design around** | **7.25/10** |

## 3.2 Replacement direction

### Profile-Synthesized Inhabited Acceptance Objects with Constructor-Exclusive Obligation Witnesses

| Category | Score |
|---|---:|
| **Novelty risk** | **2.00/10** |
| **Obviousness risk** | **3.50/10** |
| **Subject-matter/technicality risk** | **0.25/10** |
| **Freedom-to-operate risk** | **1.75/10** |
| **Ease of enforcing the patent** | **9.75/10** |
| **Ease for competitors to design around** | **1.00/10** |

## 3.3 Strict improvement check

| Category | Re-examined direction | Replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 6.75 | 2.00 | **Yes — 4.75 lower** |
| Obviousness risk | 9.00 | 3.50 | **Yes — 5.50 lower** |
| Subject-matter/technicality risk | 1.75 | 0.25 | **Yes — 1.50 lower** |
| Freedom-to-operate risk | 6.25 | 1.75 | **Yes — 4.50 lower** |
| Ease of enforcing | 7.50 | 9.75 | **Yes — 2.25 higher** |
| Ease of design-around | 7.25 | 1.00 | **Yes — 6.25 lower** |

**Every requested category improves. None remains unchanged.**

---

# 4. Direction re-examined

# Obligation-Indexed Decodable Closure Codes with Result-Coupled Acceptance Interlocks

The prior architecture was:

```text
mandatory obligation profile
        ↓
profile-derived locator coordinates
        ↓
profile target closure word
        ↓
obligation-local semantic closure shards
        ↓
order-independent accumulation
        ↓
coverage, binding, relation, and consumption syndromes
        ↓
decoded defect location
        ↓
zero-syndrome acceptance interlock
        ↓
public closure receipt
```

Its strongest proposed limitations were:

1. one profile-generated target codeword;
2. one distinct locator per mandatory obligation;
3. multiple independent check coordinates;
4. local shards bound to obligation, evidence, comparator, and result;
5. order-independent aggregation;
6. separate syndrome families;
7. bounded defect localization;
8. exact result consumption;
9. acceptance derived from zero syndromes;
10. public local openings.

The deeper review shows that this centre lies within mature integrity-checking, coding, set-reconciliation, and structured-data-validation territory.

---

# 5. Deeper conflict analysis of the re-examined direction

## 5.1 Order-independent record aggregation

### [US-10698892-B2 — Order-Independent Multi-Record Hash Generation and Data Filtering](https://patents.google.com/patent/US10698892B2/en)

The active patent describes:

- independently hashing records and fields;
- combining record hashes into a total data-set hash;
- generating order-independent aggregate values;
- comparing aggregate values to determine data-set equivalence;
- producing reports from the comparison.

### Conflict

GDCE similarly:

- generates one contribution for every obligation result;
- combines contributions without relying on order;
- compares the actual aggregate against a target aggregate;
- determines whether the complete result collection is equivalent to the required collection;
- publishes a result report.

The semantic use of obligations rather than database rows is a field-of-use distinction, not a strong architectural distinction.

---

## 5.2 Dynamic checksums over selected structured values

### [US-11386235-B1 — Systems and Methods for Dynamic Checksum Generation and Validation with Customizable Levels of Integrity Verification](https://patents.google.com/patent/US11386235B1/en)

The active patent describes:

- selecting data points according to integrity-verification criteria;
- generating checksums from selected positional and non-positional values;
- excluding unselected values;
- validating integrity by recomputing and comparing the checksum;
- varying the integrity-verification level.

### Conflict

GDCE's profile-selected obligation fields, local binding components, and profile-dependent projections are a specialized selected-field checksum system.

A claim that broadly covers profile-selected coordinates and semantic fields risks reading toward customizable structured-data checksum claims.

---

## 5.3 Compliance net-sum validation keys

### [US-12095919-B2 — Dynamic Data Compliance Controls at the Highest Directives and Standards Applicable with a Net-Sum Formula as a Zero-Knowledge Proof Compliance Validation Key](https://patents.google.com/patent/US12095919B2/en)

The active patent describes:

- identifying standards and directives applicable to data;
- converting compliance controls into symbolic instructions;
- forming a mathematical net-sum representation;
- producing a compliance validation key;
- applying the result to software, firmware, or hardware use of the data.

### Conflict

GDCE similarly converts profile obligations and semantic states into an aggregate mathematical representation that controls whether the certificate is accepted.

The specific codeword and syndrome mechanics remain distinctions, but the broad compliance-aggregation concept is occupied.

---

## 5.4 Invertible Bloom lookup table difference localization

### [CN-120578670-A — Data Consistency Verification for Remote Heterogeneous Terminals](https://patents.google.com/patent/CN120578670A/en)

The 2026 publication describes:

- generating invertible Bloom lookup table summaries;
- comparing summaries from two data sets;
- decoding added and missing record identifiers;
- using bucket counts and XOR aggregates;
- applying hierarchical checksums to localize content differences;
- retrying or degrading when the difference decoder cannot resolve all defects.

### Conflict

This is especially damaging to GDCE's enforcement narrative.

It demonstrates a practical system that:

```text
encodes a required or reference collection
    +
encodes an observed collection
    +
subtracts the summaries
    +
decodes missing and extra elements
    +
reports localized differences
```

That is the central behavior of the coverage syndrome and decoder.

The fact that GDCE's elements are mandatory verification obligations does not remove the set-reconciliation analogy.

---

## 5.5 Bucket-level data consistency verification

### [US-10956403-B2 — Verifying Data Consistency](https://patents.google.com/patent/US10956403B2/en)

The patent describes:

- loading data into two sets of hash buckets;
- comparing corresponding buckets;
- determining differences;
- generating a difference report.

### Conflict

GDCE's local check coordinates and decoded defect report can be characterized as a more elaborate bucketed consistency comparison.

Even where the patent is not an active FTO threat, it remains prior-art evidence against broad novelty and inventive step.

---

## 5.6 Syndrome generation and error localization

### [US-6954892-B2 — Method for Calculating Syndrome Polynomial in Decoding Error Correction Codes](https://patents.google.com/patent/US6954892B2/en)

The patent describes:

- calculating syndrome values from received codewords;
- treating all-zero syndromes as a no-error state;
- continuing syndrome computation when an error is present;
- decoding Reed-Solomon or BCH code errors.

Other active and historical patents cover:

- sparse parity-check matrices;
- syndrome decoder circuits;
- updated higher-order syndromes;
- multi-error detection and correction;
- error-location polynomials.

### Conflict

GDCE expressly uses:

- a profile target codeword;
- one or more actual codewords;
- independent parity or check coordinates;
- zero-syndrome acceptance;
- non-zero-syndrome defect localization.

Applying a known syndrome decoder to semantic obligation records is vulnerable to an obvious-use argument.

---

## 5.7 Schema fingerprints and exact structural validation

### [US-11809443-B2 — Schema Validation with Support for Ordering](https://patents.google.com/patent/US11809443B2/en)

The active patent describes:

- generating a first schema from a model;
- generating and ordering a second schema;
- creating fingerprints for the schemas;
- comparing fingerprints;
- validating data associated with a matching schema;
- preventing downstream processing when validation fails.

### Conflict

GDCE's profile target and actual closure structure can be viewed as fingerprints of an expected and observed schema-like result collection.

The acceptance interlock resembles the downstream processing gate.

---

## 5.8 Structured-data verification

### [US-12235830-B2 — Verifying Structured Data](https://patents.google.com/patent/US12235830B2/en)

### [EP-3616117-B1 — Verifying Structured Data](https://patents.google.com/patent/EP3616117B1/en)

These families address verification of structured data against an expected standard while tolerating or classifying mutable elements.

### Conflict

GDCE encodes a structured result object and validates it against a profile-generated standard.

The closure-code layer may narrow the claim, but it also drives the claim toward known coding machinery.

---

## 5.9 Policy schemas and type validation

### [US-12261888-B2 — Authorization Policy Validation](https://patents.google.com/patent/US12261888B2/en)

The active patent describes:

- validating a policy against an associated schema;
- detecting type and attribute inconsistencies;
- applying strict type checking and transformation;
- indicating that a policy is free of runtime type and attribute-access errors.

### Conflict

The reference weakens dependent GDCE embodiments that express locator coordinates, relation classes, or allowed obligation structures through a typed policy schema.

---

## 5.10 Proof of compliance

### [US-6256734-B1 — Method and Apparatus for Compliance Checking in a Trust Management System](https://patents.google.com/patent/US6256734B1/en)

The patent addresses whether a request complies with a policy using assertions and acceptance sets.

### Conflict

The broad idea of representing policy compliance as a machine-checkable proof or acceptance object is established.

GDCE cannot rely on “proof of all obligations” as the inventive distinction. It must rely on the specific coding architecture, which is itself crowded.

---

## 5.11 Multiset hashing and algebraic fingerprints

Established non-patent literature includes:

- commutative and order-independent multiset hashes;
- polynomial fingerprints for set equality;
- power-sum and moment-based missing-element recovery;
- invertible Bloom lookup tables;
- characteristic polynomials for set reconciliation;
- authenticated dictionaries;
- sparse error-location codes.

### Conflict

GDCE's independent moments, locator coordinates, and decoded missing-plus-duplicate states are natural adaptations of these techniques.

This materially increases obviousness risk even if the precise patent search does not locate a single anticipating claim.

---

# 6. Revised risk analysis of the re-examined direction

## 6.1 Novelty risk — 6.75/10

No reviewed reference was found to claim the complete combination of:

```text
mandatory verifier-obligation profile
    +
multiple semantic closure projections
    +
evidence/comparator/relation/result-consumption shards
    +
zero-syndrome acceptance
    +
public local openings
```

The narrow aggregate may remain novel.

The risk is nonetheless high because the claimed operations map closely to established systems for:

- set equality;
- multiset difference detection;
- order-independent hashing;
- structured-data checksums;
- error-correcting syndromes;
- difference decoding;
- compliance aggregation;
- schema validation.

A broad independent claim would be difficult to distinguish without importing many narrow semantic limitations.

---

## 6.2 Obviousness risk — 9.00/10

A plausible examiner combination is:

1. order-independent multi-record hashing;
2. profile or schema validation;
3. error-correcting-code syndrome generation;
4. set-reconciliation difference decoding;
5. a compliance or integrity acceptance gate;
6. a public difference report.

Each component performs its conventional function.

The examiner need only substitute “mandatory verification obligation result” for “record” or “data item.”

The separate coverage, binding, relation, and consumption projections are prudent engineering, but independent domain-separated checks are an expected way to avoid collisions among defect classes.

---

## 6.3 Subject-matter/technicality risk — 1.75/10

The direction remains technical when implemented through concrete codeword registers, matrices, and a decoder.

The risk rises because the principal claim can be characterized as:

- representing administrative verification requirements as numbers;
- adding the numbers;
- comparing the sum with a target;
- reporting a difference;
- permitting acceptance when the difference is zero.

Specific sparse matrices, finite-field operations, or decoder circuits would strengthen technicality but narrow the claim and increase FTO exposure.

---

## 6.4 Freedom-to-operate risk — 6.25/10

The implementation may approach active claims involving:

- order-independent multi-record hashing;
- customizable structured-data checksums;
- schema fingerprinting and validation;
- compliance validation keys;
- authenticated accumulators;
- polynomial commitments;
- specific decoder architectures;
- active 2025–2026 set-reconciliation and database-consistency families.

Avoiding all claimed implementations while preserving the GDCE concept would require careful claim-charting and primitive selection.

---

## 6.5 Ease of enforcing — 7.50/10

A public GDCE receipt is useful evidence, but it does not prove the internal mechanism.

A competitor can expose:

```text
coverage_status = exact
binding_status = exact
relation_status = exact
consumption_status = exact
```

without using:

- locator coordinates;
- a target codeword;
- codeword subtraction;
- syndrome decoding;
- a correction-distance bound.

Proving those limitations may require source code, architecture documents, expert testing, or discovery.

The black-box output does not reliably distinguish GDCE from an ordinary exact-map validator.

---

## 6.6 Ease for competitors to design around — 7.25/10

Competitors can provide substantially the same customer value through:

- a canonical sorted obligation vector;
- a generated exact schema;
- a map keyed by obligation identifier;
- database uniqueness and foreign-key constraints;
- a Merkle tree over obligation results;
- a vector commitment;
- a SNARK over the verifier;
- a proof-carrying data object;
- a formally checked result record;
- a capability settlement system;
- trusted-execution attestation;
- an ordinary complete-set comparison.

None requires a decodable closure code or syndrome family.

The current direction is therefore not commercially unavoidable.

---

# 7. Replacement direction

# Profile-Synthesized Inhabited Acceptance Objects with Constructor-Exclusive Obligation Witnesses

## 7.1 Technical objective

A conventional verifier often produces two logically separate artifacts:

```text
final_decision = ACCEPT
supporting_receipt = {...}
```

That separation permits defects such as:

```text
ACCEPT emitted without a complete receipt
receipt validated only after downstream acceptance
mandatory obligation omitted from the receipt
optional field used for a mandatory obligation
same generic witness copied into two slots
wrong evidence bound to a witness
wrong comparator contract bound to a witness
FAIL result relabeled as PASS
DIAGNOSTIC result treated as acceptance-capable
NOT_APPLICABLE used without an applicability proof
unknown extra fields changing semantics
ambiguous serialization producing two meanings
consumer trusting a Boolean without checking local witnesses
```

GIAO eliminates the authoritative Boolean.

The only strong-acceptance artifact is a profile-dependent exact-shape object that contains one valid witness component for every mandatory obligation.

A useful conceptual form is:

```text
StrongAcceptance<P, S>
    =
Witness<P, S, o1>
× Witness<P, S, o2>
× ...
× Witness<P, S, on>
```

where:

- `P` is the verification profile;
- `S` is the certificate subject;
- `o1 ... on` are the mandatory obligations compiled from `P`;
- `×` denotes an exact product with one non-optional component for each obligation.

The implementation need not use a programming language with dependent types.

Equivalent implementations include:

- a generated binary schema;
- a generated JSON or CBOR schema plus a strict validator;
- a typed abstract syntax tree;
- a canonical tagged record;
- a proof-term object;
- a generated class with non-null final fields;
- a runtime-interpreted exact-shape descriptor;
- a sealed record with per-field verification functions.

The claimed technical interaction is the profile-generated object shape, local constructor restrictions, whole-object validation, and downstream acceptance semantics.

---

# 8. Profile-to-acceptance-type compilation

```text
acceptance_object_profile:
    schema_version

    profile_id
    profile_version
    profile_root

    certificate_subject_type
    mandatory_obligation_root
    mandatory_obligation_count

    obligation_slot_descriptors
    canonical_slot_order
    accepted_constructor_rules
    rejection_constructor_rules

    normalization_rules
    unknown_field_policy
    duplicate_field_policy
    ambiguity_policy

    acceptance_object_type_root
```

The compiler deterministically generates one slot descriptor for each mandatory obligation.

The generated type root is bound to:

```text
profile_root
mandatory obligation identifiers
obligation types
allowed evidence selectors
allowed comparator contracts
allowed accepted relation classes
non-applicability rules
canonical encoding rules
```

The accepted object type is therefore profile-specific.

A verifier cannot redefine the required slot set from the result records it happened to produce.

---

# 9. Obligation slot descriptor

For obligation `o`:

```text
obligation_slot_descriptor:
    profile_root
    obligation_id
    obligation_type
    slot_index

    certificate_subject_rule
    evidence_selector_rule
    evidence_commitment_rule
    comparator_contract_rule

    allowed_witness_constructors
    allowed_relation_classes
    applicability_proof_rule

    local_verifier_id
    local_normalization_rule

    slot_descriptor_hash
```

The slot is not an optional map entry.

It is one required component of the accepted object.

A generic list entry cannot fill the slot unless it validates against the slot descriptor.

---

# 10. Constructor-exclusive witness model

Each mandatory obligation has an allowed witness-constructor set.

A typical pair is:

```text
EvaluatedPassWitness
ProvenNonApplicabilityWitness
```

The constructors are disjoint.

## 10.1 Evaluated-pass witness

```text
evaluated_pass_witness:
    profile_root
    certificate_subject_root

    obligation_id
    slot_index

    evidence_selector_root
    evidence_commitment
    comparator_contract_id

    normalized_relation_state
    relation_witness_root

    constructor_tag = EVALUATED_PASS
    local_witness_hash
```

The local checker validates:

1. profile identity;
2. subject identity;
3. obligation identity;
4. exact slot index;
5. authorized evidence selector;
6. evidence commitment;
7. comparator contract;
8. accepted relation class;
9. relation witness;
10. canonical local encoding.

## 10.2 Proven-non-applicability witness

```text
proven_nonapplicability_witness:
    profile_root
    certificate_subject_root

    obligation_id
    slot_index

    applicability_contract_id
    applicability_evidence_root
    applicability_proof_root

    constructor_tag = PROVEN_NONAPPLICABILITY
    local_witness_hash
```

The local checker validates:

1. the profile permits non-applicability for the obligation;
2. the applicability contract is authorized;
3. the proof concerns the same certificate subject;
4. the proof satisfies the profile rule;
5. the evaluated-pass constructor was not used in the same slot;
6. the encoding is canonical.

`NOT_APPLICABLE` is therefore an affirmative witness constructor, not an absent field.

---

# 11. Disjoint rejection objects

Invalid states do not inhabit the strong-acceptance object.

They inhabit separate object families:

```text
RejectedCertificate<P, S>
UnresolvedCertificate<P, S>
DiagnosticCertificate<P, S>
InvalidReceipt<P, S>
```

Possible rejection constructors include:

```text
FailedObligation
MissingEvidence
ComparatorError
InvalidApplicabilityProof
UnsupportedDomain
UnresolvedDependency
ProfileMismatch
SubjectMismatch
```

A rejection constructor cannot be cast, tagged, aliased, or normalized into an accepted witness slot.

The public checker treats constructor type as part of the machine semantics, not descriptive metadata.

---

# 12. Exact-shape acceptance object

```text
inhabited_acceptance_object:
    schema_version

    acceptance_object_type_root
    profile_root
    certificate_subject_root

    mandatory_obligation_root
    mandatory_obligation_count

    witness_slot_1
    witness_slot_2
    ...
    witness_slot_n

    normalized_object_root
    accepted_object_identifier
```

The object has no authoritative field such as:

```text
accepted = true
```

A display-only status field may exist, but it has no decision authority and is ignored by the public checker.

The authoritative condition is:

```text
object validates as StrongAcceptance<profile_root, certificate_subject_root>
```

---

# 13. Whole-object inhabitation rules

The checker enforces:

```text
observed_slot_count = mandatory_obligation_count
```

and:

```text
observed_slot_identifier_set
    =
profile_mandatory_obligation_identifier_set
```

and, for every slot:

```text
slot witness validates against its unique slot descriptor
```

Additional invariants are:

```text
missing_slot_set = ∅
duplicate_slot_set = ∅
unknown_slot_set = ∅
wrong_index_set = ∅
invalid_constructor_set = ∅
subject_mismatch_set = ∅
evidence_mismatch_set = ∅
comparator_mismatch_set = ∅
invalid_relation_set = ∅
invalid_applicability_proof_set = ∅
ambiguous_encoding_set = ∅
```

Only then does the object inhabit the strong-acceptance type.

---

# 14. Canonical normal form

A profile specifies one canonical whole-object normal form.

Normalization rules include:

- one canonical slot order;
- one integer encoding;
- one string normalization rule;
- one constructor-tag encoding;
- one omission rule;
- one unknown-field rule;
- one duplicate-field rule;
- one map-key ordering rule where maps are permitted;
- one treatment of default values;
- one treatment of null values;
- one domain-separation rule for local witness hashes.

The checker must reject rather than reinterpret:

```text
duplicate fields
unknown acceptance-relevant fields
multiple encodings of the same constructor
slot aliases
index aliases
non-canonical numeric encodings
ambiguous null/default substitutions
constructor-tag collisions
```

This prevents two byte sequences from being treated as the same accepted object under different parsers.

---

# 15. Accepted object identifier

After successful whole-object validation:

```text
accepted_object_identifier = H(
    "GLYPHSER-GIAO-ACCEPTED-OBJECT"
    || acceptance_object_type_root
    || profile_root
    || certificate_subject_root
    || normalized_object_bytes
)
```

A hash is a preferred embodiment, not an essential principal-claim limitation.

Equivalent identifiers may use:

- a digital signature;
- a canonical object address;
- a content identifier;
- a database key derived from the normal form;
- an authenticated object handle.

The identifier is generated only after complete validation.

---

# 16. Downstream consumer interlock

A downstream consumer must not accept a detached Boolean.

```text
CONSUME_STRONG_ACCEPTANCE(object):
    descriptor = RESOLVE_TYPE(object.acceptance_object_type_root)
    CHECK_PROFILE_BINDING(descriptor, object.profile_root)
    CHECK_SUBJECT_BINDING(descriptor, object.certificate_subject_root)
    CHECK_EXACT_SHAPE(descriptor, object)
    CHECK_EACH_LOCAL_WITNESS(descriptor, object)
    normalized = CANONICALIZE(descriptor, object)
    object_id = DERIVE_ACCEPTED_OBJECT_ID(normalized)
    return AcceptedHandle(object_id)
```

Any failed check returns a non-accepting state.

The accepted handle cannot be obtained from:

- a detached status flag;
- an incomplete receipt;
- a list with missing slots;
- a receipt with a diagnostic witness;
- an object whose local witnesses were not checked.

---

# 17. Local public verification

Each witness slot is independently openable and checkable.

```text
obligation_witness_opening:
    acceptance_object_type_root
    profile_root
    certificate_subject_root

    obligation_slot_descriptor
    descriptor_membership_proof

    obligation_witness
    local_evidence_opening
    comparator_contract_opening
    relation_or_applicability_opening

    local_normal_form
    local_verification_state
```

A third party can verify one slot without trusting the original verifier's Boolean decision.

The whole-object checker separately verifies exact slot completeness.

---

# 18. Invalid object states

## 18.1 Missing mandatory slot

Expected result:

```text
OBJECT_TYPE_UNINHABITED
MISSING_MANDATORY_SLOT(obligation_id)
```

## 18.2 Duplicate slot

Expected result:

```text
OBJECT_TYPE_UNINHABITED
DUPLICATE_OBLIGATION_SLOT(obligation_id)
```

## 18.3 Wrong obligation identifier at a slot

Expected result:

```text
OBJECT_TYPE_UNINHABITED
SLOT_INDEX_IDENTIFIER_MISMATCH
```

## 18.4 Copied witness

A valid witness for obligation `a` is copied into obligation `b`.

Expected result:

```text
OBJECT_TYPE_UNINHABITED
WITNESS_OBLIGATION_INDEX_MISMATCH
```

## 18.5 Wrong evidence

Expected result:

```text
OBJECT_TYPE_UNINHABITED
EVIDENCE_BINDING_MISMATCH
```

## 18.6 Wrong comparator contract

Expected result:

```text
OBJECT_TYPE_UNINHABITED
COMPARATOR_CONTRACT_MISMATCH
```

## 18.7 Failure relabeled as pass

Expected result:

```text
OBJECT_TYPE_UNINHABITED
INVALID_ACCEPTANCE_CONSTRUCTOR
```

## 18.8 Diagnostic promotion

Expected result:

```text
OBJECT_TYPE_UNINHABITED
DIAGNOSTIC_CONSTRUCTOR_NOT_ACCEPTANCE_CAPABLE
```

## 18.9 False non-applicability

Expected result:

```text
OBJECT_TYPE_UNINHABITED
INVALID_NONAPPLICABILITY_WITNESS
```

## 18.10 Unknown field affecting acceptance

Expected result:

```text
OBJECT_TYPE_UNINHABITED
UNKNOWN_ACCEPTANCE_RELEVANT_FIELD
```

## 18.11 Ambiguous serialization

Expected result:

```text
OBJECT_TYPE_UNINHABITED
NONCANONICAL_OR_AMBIGUOUS_ENCODING
```

## 18.12 Detached Boolean bypass

A product emits `accepted=true` without a valid inhabited object.

Expected public-consumer result:

```text
NO_ACCEPTED_OBJECT_HANDLE
DETACHED_STATUS_IGNORED
```

## 18.13 Exact inhabitation

Expected state:

```text
all mandatory slots present exactly once
all local constructors authorized
all local witnesses valid
whole object canonical
accepted object identifier generated
consumer returns AcceptedHandle
```

---

# 19. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising compiling a certificate-verification profile into an acceptance-object descriptor that defines a profile-dependent exact-shape data object having a respective non-optional witness slot for each of a plurality of mandatory verification obligations; defining, for each respective witness slot, an obligation index and one or more authorized witness constructors including at least an evaluated-pass witness constructor or a proven-nonapplicability witness constructor, each authorized witness constructor requiring values bound to a certificate subject and to the corresponding mandatory verification obligation; receiving a plurality of obligation witness objects; validating, for each obligation witness object, that an obligation identifier and slot index correspond to a unique witness slot, that a constructor tag is authorized for the witness slot, and that evidence, comparator-contract, relation-state, or applicability-proof values satisfy local verification rules of the witness slot; rejecting construction of a strong-acceptance object when a mandatory witness slot is absent, duplicated, filled by an obligation witness object for a different obligation, filled by an unauthorized constructor, or filled by a witness object having an invalid subject, evidence, comparator, relation-state, or applicability-proof binding; constructing the strong-acceptance object only when every mandatory witness slot is filled exactly once by a locally valid obligation witness object; canonicalizing the constructed strong-acceptance object according to normalization rules of the acceptance-object descriptor; deriving an accepted-object identifier from the canonicalized strong-acceptance object; omitting an independent authoritative Boolean acceptance value such that validity of the constructed strong-acceptance object constitutes the strong-acceptance state; and, at a downstream consumer, producing an accepted handle only after resolving the acceptance-object descriptor and revalidating the exact-shape object, the locally valid obligation witness objects, and the canonicalized strong-acceptance object.

The strongest limitations are:

1. profile compilation into an exact-shape acceptance-object descriptor;
2. one non-optional witness slot per mandatory obligation;
3. obligation-indexed local witness types;
4. constructor-exclusive evaluated-pass and proven-nonapplicability states;
5. evidence, comparator, subject, and relation binding at each slot;
6. disjoint rejection and diagnostic object types;
7. rejection of missing, duplicate, substituted, unknown, and ambiguous fields;
8. canonical whole-object normal form;
9. no independent authoritative acceptance Boolean;
10. downstream accepted handle only after complete object revalidation;
11. public local witness openings.

---

# 20. Closest prior-art categories for the replacement

## 20.1 Proof-carrying code

### [US-8104021-B2 — Verifiable Integrity Guarantees for Machine Code Programs](https://patents.google.com/patent/US8104021B2/en)

The active patent concerns:

- machine-code modules structured for verification;
- static checks and runtime guards;
- safe executable modules;
- proof-carrying-code-like verification hints;
- control-flow and memory-safety guarantees.

### Difference

GIAO does not verify executable code safety.

It compiles a certificate-verification profile into an exact-shape accepted-result object with one local semantic witness per mandatory verification obligation.

No machine-code rewriting, memory guard, control-flow guard, or executable module is required.

---

## 20.2 Safe code formats and bytecode verification

### [US-8392897-B2 — Safe Computer Code Formats and Methods for Generating Safe Computer Code](https://patents.google.com/patent/US8392897B2/en)

The patent concerns code formats whose structure permits efficient safety verification.

### Difference

GIAO's object is not executable code.

Its required fields are semantic evidence witnesses for certificate obligations, and its downstream meaning is acceptance of a certificate subject rather than permission to execute a code module.

---

## 20.3 Proof of compliance in trust management

### [US-6256734-B1 — Method and Apparatus for Compliance Checking in a Trust Management System](https://patents.google.com/patent/US6256734B1/en)

The patent determines whether a request complies with a policy using assertions and acceptance sets.

### Difference

GIAO does not merely calculate compliance.

It changes the output representation so that strong acceptance exists only as one fully inhabited profile-dependent object containing exactly one locally verifiable witness for every mandatory obligation.

The absence of a detached authoritative Boolean and the downstream revalidation interlock are central limitations.

---

## 20.4 Proof-carrying data and recursive verifiable computation

### [US-12058265-B2 — Verifiable Computation for Cross-Domain Information Sharing](https://patents.google.com/patent/US12058265B2/en)

### [US-20210281412-A1 — Verifiable Computation for Cross-Domain Information Sharing](https://patents.google.com/patent/US20210281412A1/en)

These references describe:

- data accompanied by cryptographic proofs;
- local computations over data;
- recursive proof composition;
- downstream decisions based on proofs.

### Difference

GIAO does not require recursive proof composition, zk-SNARKs, or a proof of arbitrary computation.

It requires an exact product of obligation-indexed local witnesses generated from a profile, constructor exclusivity for each obligation, exact whole-object shape, and no separate authoritative acceptance state.

Proof-carrying data may be an optional witness implementation.

---

## 20.5 Credential-based authorization proofs

### [US-20170359184-A1 — Credential-Based Authorization](https://patents.google.com/patent/US20170359184A1/en)

The application concerns proving possession of attribute credentials that satisfy an access condition.

### Difference

GIAO is not a user-access credential protocol.

It creates one mandatory local witness slot for every certificate-verification obligation, including technical identity, artifact, dependency, output, metric, and non-applicability obligations.

It requires exact whole-profile inhabitation rather than proof that one or more attributes satisfy an access condition.

---

## 20.6 Schema validation with ordering

### [US-11809443-B2 — Schema Validation with Support for Ordering](https://patents.google.com/patent/US11809443B2/en)

The active patent generates schemas and fingerprints, orders one schema according to another, compares fingerprints, and permits downstream processing after equality validation.

### Difference

GIAO should avoid making schema fingerprint comparison essential.

Its distinguishing interaction is:

- one profile-generated non-optional witness slot per mandatory obligation;
- local semantic constructor verification;
- disjoint accepted and rejected constructors;
- no authoritative Boolean outside the validated object;
- downstream accepted-handle creation only from a fully inhabited object.

An ordinary schema containing syntactically required fields does not establish those semantic witness constraints.

---

## 20.7 Structured-data verification

### [US-12235830-B2 — Verifying Structured Data](https://patents.google.com/patent/US12235830B2/en)

### [EP-3616117-B1 — Verifying Structured Data](https://patents.google.com/patent/EP3616117B1/en)

These references verify structured data against expected standards and account for mutable portions.

### Difference

GIAO is not merely validation of input structure.

It generates the only recognized strong-acceptance artifact, whose structure is synthesized from mandatory verification obligations and whose fields must be locally valid semantic witnesses.

---

## 20.8 Authorization policy type validation

### [US-12261888-B2 — Authorization Policy Validation](https://patents.google.com/patent/US12261888B2/en)

The active patent validates a policy against a schema and detects runtime type or attribute-access errors.

### Difference

GIAO does not validate whether a policy program is type-safe.

It validates whether an accepted certificate object has exactly one locally verified witness for every obligation defined by an already selected profile.

The profile-to-object compiler and acceptance-object consumer are different components from a policy-language validator.

---

## 20.9 Format-agnostic certificate issuance

### [US-7509489-B2 — Format-Agnostic System and Method for Issuing Certificates](https://patents.google.com/patent/US7509489B2/en)

The patent uses policy-driven certificate issuance and credential formatting.

### Difference

GIAO does not claim generic certificate formatting.

It requires that the accepted object's exact field structure be generated from the mandatory obligation set and that each field be a locally verifiable obligation witness whose constructor controls acceptance semantics.

---

## 20.10 Validation before certificate signing

### [US-11671264-B1 — Validating Certificate Information Before Signing](https://patents.google.com/patent/US11671264B1/en)

The active patent concerns pre-issuance validation of certificate information before signing.

### Difference

GIAO is not limited to X.509 or certificate-authority signing workflows.

The accepted object is itself the proof-product of the verification profile and is revalidated by downstream consumers.

---

## 20.11 Algebraic data types, dependent records, and proof terms

Non-patent literature establishes:

- product and sum types;
- tagged unions;
- Curry-Howard proof terms;
- dependent records;
- refinement types;
- typestate;
- proof-carrying authorization;
- canonical serialization formats.

### Difference

The patent position depends on the complete applied interaction:

```text
certificate-verification profile
    →
exact-shape acceptance-object descriptor
    →
one non-optional local witness slot per mandatory obligation
    →
constructor-exclusive accepted witness states
    →
whole-object canonical inhabitation
    →
no independent authoritative acceptance Boolean
    →
downstream accepted handle only after complete revalidation
```

Counsel must search the non-patent literature carefully because the individual type-theoretic tools are old.

---

# 21. Replacement-direction risk analysis

## 21.1 Novelty risk — 2.00/10

The component technologies are known:

- generated schemas;
- required fields;
- typed records;
- tagged unions;
- local proof objects;
- proof-carrying data;
- policy compliance checking;
- canonical serialization;
- downstream validation.

The reviewed patent material did not identify one reference containing the complete interaction:

```text
profile-synthesized exact acceptance object
    +
one non-optional witness slot for every mandatory verifier obligation
    +
obligation-indexed constructor restrictions
    +
evaluated-pass versus proven-nonapplicability constructor exclusivity
    +
local evidence/comparator/relation binding
    +
disjoint rejection object types
    +
no authoritative acceptance Boolean outside the object
    +
consumer accepted handle only after exact-shape and local-witness revalidation
```

The replacement is not dependent on one novel cryptographic primitive or mathematical code.

Its novelty resides in changing the verifier's accepted-result representation and downstream acceptance contract.

---

## 21.2 Obviousness risk — 3.50/10

A plausible examiner combination is:

1. generated schemas with required fields;
2. proof-carrying data or proof-carrying code;
3. tagged union or typed-record semantics;
4. policy-based certificate issuance;
5. downstream validation before processing.

The stronger inventive-step arguments are:

- the profile generates one unique semantic witness slot for every mandatory verifier obligation;
- field presence alone is insufficient because each slot has a local evidence/comparator/relation verifier;
- evaluated pass and proven non-applicability are distinct authorized constructors;
- failure and diagnostic constructors belong to disjoint non-accepting object types;
- no detached Boolean is authoritative;
- downstream acceptance is represented by successful object inhabitation and accepted-handle construction;
- exact shape, local proof validity, and canonical encoding are checked together.

This is more than validating ordinary structured data or attaching a generic proof to a certificate.

---

## 21.3 Subject-matter/technicality risk — 0.25/10

The replacement is strongly technical when the specification claims concrete machine behavior:

- deterministic profile-to-descriptor compilation;
- allocation of exact non-optional witness slots;
- strict constructor-tag dispatch;
- local evidence and comparator verification;
- duplicate, unknown, and ambiguous-field rejection;
- canonical binary normalization;
- accepted-object identifier generation;
- downstream parser and accepted-handle interlock.

It changes:

- the in-memory and serialized representation of an accepted result;
- the verifier's construction rules;
- the parser's rejection behavior;
- the downstream consumer's state-transition conditions.

The specification should avoid presenting the invention merely as a mathematical proof or administrative checklist.

---

## 21.4 Freedom-to-operate risk — 1.75/10

FTO risks remain around:

- specific proof-carrying-code formats;
- specific proof-carrying-data cryptographic systems;
- schema fingerprinting and ordering;
- authorization-policy validators;
- certificate pre-issuance systems;
- credential proof protocols;
- specific canonical serialization patents.

Risk is reduced because the principal claim can remain independent of:

- executable code verification;
- recursive cryptographic proofs;
- zero-knowledge proofs;
- schema fingerprints;
- ordered schema comparison;
- access-control credentials;
- X.509 issuance;
- one serialization format;
- one type system;
- one proof language;
- one cryptographic signature scheme.

A conventional strict parser, generated descriptor, and local witness-check interface can implement the concept without adopting claim-specific structures from the identified active patents.

---

## 21.5 Ease of enforcing — 9.75/10

A conforming strong-acceptance artifact necessarily exposes or permits observation of:

- the acceptance-object type identifier;
- the profile root;
- the certificate subject root;
- the mandatory obligation count;
- one witness component per mandatory obligation;
- witness constructor tags;
- obligation indices;
- local evidence, comparator, relation, or applicability bindings;
- the canonical object form or object identifier;
- downstream acceptance or rejection of malformed variants.

A claimant can perform direct black-box tests:

1. remove one mandatory slot;
2. duplicate one slot;
3. swap two obligation identifiers;
4. copy one witness into another slot;
5. substitute the evidence root;
6. substitute the comparator contract;
7. change an evaluated-pass constructor into a diagnostic constructor;
8. use non-applicability without a valid proof;
9. add an unknown acceptance-relevant field;
10. submit a non-canonical duplicate-key encoding;
11. submit `accepted=true` without a valid object;
12. submit a valid object and observe creation of an accepted handle.

The principal claim does not depend on proving an invisible internal arithmetic decoder or actual execution path.

The accused public object and consumer behavior provide direct claim-chart evidence.

---

## 21.6 Ease for competitors to design around — 1.00/10

The claim strategy should cover implementation-equivalent exact-shape acceptance objects implemented as:

- dependent records;
- generated classes;
- tagged product objects;
- typed abstract syntax trees;
- generated JSON or CBOR schemas with semantic field validators;
- binary protocol descriptors;
- proof-term bundles;
- sealed records;
- runtime-interpreted profile descriptors.

A competitor can avoid the claim by using:

- a general SNARK proving the entire verifier;
- trusted hardware attesting the verifier;
- a conventional Boolean plus a weaker optional receipt;
- a private internal check with no public local witnesses;
- a monolithic opaque proof with no obligation-specific openings.

The first two alternatives are technically heavier and less transparent.

The latter three provide a materially weaker public guarantee.

A competitor seeking the same combination of:

- one public local witness for every mandatory obligation;
- exact missing and duplicate rejection;
- evidence and comparator binding;
- proof-backed non-applicability;
- no diagnostic promotion;
- no detached acceptance bypass;
- consumer-verifiable acceptance;

must implement an equivalent profile-generated exact witness product or sacrifice one of those properties.

---

# 22. Enforcement-focused design

## 22.1 Mandatory public fields

Every strong acceptance object should expose:

```text
schema_version
acceptance_object_type_root
profile_root
certificate_subject_root

mandatory_obligation_root
mandatory_obligation_count

for each obligation:
    obligation_id
    slot_index
    witness_constructor_tag
    evidence_selector_root
    evidence_commitment
    comparator_or_applicability_contract_id
    relation_or_applicability_state
    local_witness_root

normalized_object_root
accepted_object_identifier
```

## 22.2 Mandatory public checker behavior

The public checker should expose stable rejection codes for:

```text
TYPE_DESCRIPTOR_NOT_FOUND
PROFILE_TYPE_MISMATCH
SUBJECT_TYPE_MISMATCH
MISSING_MANDATORY_SLOT
DUPLICATE_OBLIGATION_SLOT
UNKNOWN_OBLIGATION_SLOT
SLOT_INDEX_IDENTIFIER_MISMATCH
INVALID_WITNESS_CONSTRUCTOR
EVIDENCE_BINDING_MISMATCH
COMPARATOR_CONTRACT_MISMATCH
INVALID_RELATION_WITNESS
INVALID_NONAPPLICABILITY_WITNESS
DIAGNOSTIC_CONSTRUCTOR_NOT_ACCEPTANCE_CAPABLE
NONCANONICAL_ENCODING
AMBIGUOUS_ENCODING
DETACHED_STATUS_IGNORED
OBJECT_TYPE_INHABITED
```

## 22.3 Product commands

```text
glyphser acceptance-type compile
glyphser acceptance-object construct
glyphser acceptance-object normalize
glyphser acceptance-object inspect
glyphser acceptance-object verify
glyphser acceptance-object open-slot
glyphser acceptance-object consume
```

Suggested API surfaces:

```text
POST /acceptance-types/compile
POST /acceptance-objects/construct
POST /acceptance-objects/normalize
POST /acceptance-objects/verify
POST /acceptance-objects/{id}/open-slot
POST /acceptance-objects/{id}/consume
GET  /acceptance-types/{type_root}
GET  /acceptance-objects/{object_id}
```

---

# 23. Anti-design-around claim strategy

## 23.1 Do not limit the claim to “dependent types”

Use broader terms:

- profile-dependent exact-shape object;
- mandatory witness component;
- obligation-indexed field descriptor;
- constructor-restricted witness state;
- complete accepted-result object;
- downstream accepted handle.

Dependent types should be one dependent claim or embodiment.

## 23.2 Claim exact shape independently of serialization

Cover:

- fixed binary records;
- generated schemas;
- object classes;
- typed ASTs;
- proof terms;
- runtime descriptors.

Do not make JSON, CBOR, Protocol Buffers, ASN.1, or one binary format essential.

## 23.3 Claim local semantic validation independently of field presence

A competitor may use a generated schema with required fields but no local semantic witness verification.

The principal claim should require local validation of:

- obligation identity;
- subject identity;
- evidence binding;
- comparator or applicability contract;
- accepted relation state or applicability proof.

## 23.4 Claim constructor exclusivity

A competitor may represent every result with a generic status enum.

Claim:

- at least two disjoint accepted witness constructors;
- profile authorization of constructors per obligation;
- failure and diagnostic constructors excluded from the strong-acceptance object;
- constructor tag participating in local verification and canonicalization.

## 23.5 Claim absence of an independent authoritative Boolean

The strongest commercial distinction is:

```text
valid complete object = strong acceptance
```

not:

```text
Boolean decision + optional evidence
```

Claim that downstream accepted-state transition occurs only after successful object validation and accepted-handle construction.

## 23.6 Claim consumer revalidation

A competitor may construct the object but have downstream software trust the producer's status flag.

Use a separate claim requiring the consumer to:

- resolve the descriptor;
- validate exact shape;
- validate local witnesses;
- canonicalize the object;
- derive or verify the accepted object identifier;
- produce the accepted handle.

## 23.7 Claim canonical ambiguity rejection

A competitor may exploit duplicate JSON keys, null/default aliases, or multiple numeric encodings.

Claim rejection of any encoding that is not the one normal form accepted by the profile-dependent descriptor.

## 23.8 Claim local openings

Claim independent opening and verification of one obligation witness while retaining whole-object completeness verification.

This strengthens both product utility and infringement evidence.

---

# 24. Recommended claim families

## Family A — Profile-to-acceptance-object compilation

Protect deterministic synthesis of an exact-shape accepted-result descriptor from mandatory verification obligations.

## Family B — Non-optional obligation witness slots

Protect one unique required witness component for every mandatory obligation.

## Family C — Constructor-exclusive obligation witnesses

Protect evaluated-pass and proven-nonapplicability constructors and exclusion of failure or diagnostic constructors.

## Family D — Local semantic witness binding

Protect subject, evidence, comparator, relation, and applicability-proof validation at each slot.

## Family E — Disjoint rejection object families

Protect the inability to reinterpret failure, unresolved, or diagnostic objects as strong acceptance.

## Family F — Canonical acceptance-object normal form

Protect exact canonicalization and rejection of unknown, duplicate, ambiguous, or aliased acceptance-relevant fields.

## Family G — Acceptance without an authoritative Boolean

Protect strong acceptance represented only by a valid complete object.

## Family H — Downstream accepted-handle interlock

Protect consumer revalidation before creation of an accepted handle or access to downstream processing.

## Family I — Public local witness openings

Protect independent opening and verification of one obligation slot.

## Family J — Cross-version acceptance-object migration

Protect deterministic migration between profile-dependent acceptance-object types while preserving local witness identity and explicitly identifying invalidated slots.

---

# 25. Technical evidence needed before filing

## 25.1 Missing-slot test

Remove one required obligation slot.

Expected result:

```text
MISSING_MANDATORY_SLOT
NO_ACCEPTED_OBJECT_HANDLE
```

## 25.2 Duplicate-slot test

Duplicate one obligation slot.

Expected result:

```text
DUPLICATE_OBLIGATION_SLOT
NO_ACCEPTED_OBJECT_HANDLE
```

## 25.3 Slot-swap test

Swap two slot identifiers while retaining witness bodies.

Expected result:

```text
SLOT_INDEX_IDENTIFIER_MISMATCH
```

## 25.4 Copied-witness test

Copy one valid witness into another obligation slot.

Expected result:

```text
WITNESS_OBLIGATION_INDEX_MISMATCH
```

## 25.5 Evidence-substitution test

Change the selected evidence commitment.

Expected result:

```text
EVIDENCE_BINDING_MISMATCH
```

## 25.6 Comparator-substitution test

Change the comparator contract identifier.

Expected result:

```text
COMPARATOR_CONTRACT_MISMATCH
```

## 25.7 Constructor-promotion test

Replace a failure or diagnostic constructor tag with `EVALUATED_PASS` without changing the witness.

Expected result:

```text
INVALID_WITNESS_CONSTRUCTOR
```

## 25.8 False non-applicability test

Use `PROVEN_NONAPPLICABILITY` without a valid applicability proof.

Expected result:

```text
INVALID_NONAPPLICABILITY_WITNESS
```

## 25.9 Unknown-field test

Add an unknown field that one permissive parser might treat as acceptance-relevant.

Expected result:

```text
UNKNOWN_ACCEPTANCE_RELEVANT_FIELD
```

## 25.10 Duplicate-key ambiguity test

Serialize one slot with duplicate keys carrying conflicting values.

Expected result:

```text
AMBIGUOUS_ENCODING
```

## 25.11 Detached-Boolean test

Provide:

```text
accepted = true
```

without a valid inhabited object.

Expected result:

```text
DETACHED_STATUS_IGNORED
NO_ACCEPTED_OBJECT_HANDLE
```

## 25.12 Exact-inhabitation test

Provide one valid local witness for every mandatory obligation.

Expected result:

```text
OBJECT_TYPE_INHABITED
ACCEPTED_OBJECT_IDENTIFIER_GENERATED
ACCEPTED_HANDLE_CREATED
```

## 25.13 Implementation-diversity test

Implement the same profile and object semantics using:

1. a generated Python dataclass and strict runtime checker;
2. a Rust or other sealed tagged-record implementation;
3. a canonical CBOR descriptor interpreted by a small verifier;
4. a typed AST proof-term representation.

All implementations should produce the same canonical accepted object identifier.

This supports implementation-neutral claims.

---

# 26. Glyphser implementation path

## 26.1 New schemas

```text
acceptance_object_profile.v1
acceptance_object_type_descriptor.v1
obligation_slot_descriptor.v1
evaluated_pass_witness.v1
proven_nonapplicability_witness.v1
rejection_witness.v1
inhabited_acceptance_object.v1
accepted_object_handle.v1
obligation_witness_opening.v1
acceptance_object_verification_report.v1
```

## 26.2 Suggested modules

```text
runtime/glyphser/acceptance_types/profile.py
runtime/glyphser/acceptance_types/compiler.py
runtime/glyphser/acceptance_types/descriptors.py
runtime/glyphser/acceptance_types/constructors.py
runtime/glyphser/acceptance_types/local_verify.py
runtime/glyphser/acceptance_types/object_builder.py
runtime/glyphser/acceptance_types/normalize.py
runtime/glyphser/acceptance_types/verify.py
runtime/glyphser/acceptance_types/opening.py
runtime/glyphser/acceptance_types/consumer.py
runtime/glyphser/acceptance_types/migration.py
```

## 26.3 Suggested quality gates

```text
tooling/quality_gates/acceptance_type_compilation_gate.py
tooling/quality_gates/mandatory_slot_exactness_gate.py
tooling/quality_gates/witness_constructor_gate.py
tooling/quality_gates/local_evidence_binding_gate.py
tooling/quality_gates/local_comparator_binding_gate.py
tooling/quality_gates/nonapplicability_proof_gate.py
tooling/quality_gates/rejection_type_separation_gate.py
tooling/quality_gates/canonical_encoding_gate.py
tooling/quality_gates/detached_boolean_bypass_gate.py
tooling/quality_gates/downstream_consumer_revalidation_gate.py
```

## 26.4 Required adversarial fixtures

```text
mandatory_slot_missing
mandatory_slot_duplicated
unknown_slot_added
slot_index_identifier_mismatch
witness_copied_to_other_slot
witness_subject_mismatch
witness_evidence_selector_mismatch
witness_evidence_commitment_mismatch
witness_comparator_contract_mismatch
witness_relation_state_invalid
nonapplicability_constructor_not_allowed
nonapplicability_proof_missing
nonapplicability_proof_subject_mismatch
diagnostic_constructor_promoted
failure_constructor_promoted
unknown_acceptance_field
duplicate_serialization_key
noncanonical_integer_encoding
null_default_alias
constructor_tag_alias
profile_type_root_mismatch
certificate_subject_root_mismatch
detached_accept_boolean_only
consumer_skips_local_verification
valid_exact_inhabited_object
```

---

# 27. Features to exclude from the principal claim

Do not make these essential:

- Reed-Solomon codes;
- BCH codes;
- parity-check matrices;
- syndromes;
- invertible Bloom lookup tables;
- multiset hashes;
- cryptographic accumulators;
- Merkle trees;
- polynomial commitments;
- zero-knowledge proofs;
- recursive proof-carrying data;
- proof-carrying executable code;
- dependent-type source languages;
- Rust, Haskell, Coq, Lean, Agda, or one language;
- JSON, CBOR, ASN.1, Protocol Buffers, or one serialization;
- blockchain;
- trusted execution;
- remote attestation;
- mutation testing;
- dual execution;
- challenge-response protocols;
- one hash function;
- one signature scheme;
- one operating system.

They may appear as optional embodiments or dependent claims.

---

# 28. Filing strategy

## Principal independent method claim

Require:

- compilation of the profile into an exact-shape acceptance-object descriptor;
- one non-optional witness slot per mandatory obligation;
- authorized constructor rules per slot;
- local witness binding to subject, evidence, comparator, and relation or applicability proof;
- rejection of missing, duplicate, substituted, invalid-constructor, and ambiguous objects;
- construction of strong acceptance only as a fully valid object;
- no independent authoritative acceptance Boolean;
- consumer accepted-handle creation only after complete revalidation.

## Separate system claim

Claim components such as:

- profile-to-type compiler;
- descriptor registry;
- local witness verifier;
- constructor dispatcher;
- exact-shape object builder;
- canonical normalizer;
- accepted-object identifier generator;
- public slot-opening verifier;
- downstream acceptance consumer.

## Separate object-format claim

Where permitted, claim the machine-readable accepted object characterized by:

- a profile-dependent type identifier;
- one obligation-indexed witness component per mandatory obligation;
- constructor tags;
- local evidence and comparator bindings;
- canonical whole-object representation;
- accepted-object identifier.

## Separate consumer claim

Claim downstream refusal of detached status values and accepted-handle construction only after exact-shape and local-witness validation.

## Continuation applications

Potential continuation families:

1. profile-synthesized exact-shape acceptance objects;
2. constructor-exclusive non-applicability witnesses;
3. disjoint rejection object families;
4. canonical ambiguity rejection;
5. detached-Boolean bypass prevention;
6. consumer accepted-handle interlocks;
7. local public witness openings;
8. profile-version migration of accepted objects;
9. cross-verifier equivalence of canonical accepted objects.

---

# 29. Final recommendation

The obligation-indexed decodable closure-code direction is no longer the strongest filing candidate because its central mechanisms are closely adjacent to:

- order-independent multirecord hashing;
- dynamic structured-data checksums;
- compliance net-sum validation keys;
- invertible Bloom lookup tables;
- set reconciliation;
- error-correcting-code syndromes;
- difference decoding;
- schema fingerprints;
- structured-data validation;
- policy-schema checking.

Replace it with:

> **A certificate-verification architecture that compiles a verification profile into a profile-dependent exact-shape strong-acceptance object having one non-optional, obligation-indexed witness slot for every mandatory verification obligation; restricts each slot to authorized, mutually distinguishable witness constructors including evidence-backed evaluated pass or proof-backed non-applicability; locally validates each witness against the certificate subject, authorized evidence, comparator contract, relation state, and applicability rule; excludes failure, unresolved, and diagnostic constructors from the strong-acceptance object; rejects missing, duplicate, substituted, unknown, and ambiguously encoded witness components; canonicalizes the complete object; treats successful inhabitation of the complete object rather than a detached Boolean as the only authoritative strong-acceptance state; and permits a downstream consumer to produce an accepted handle only after independently revalidating the exact object shape and every local witness.**

This direction is better because it:

- removes checksums, codewords, syndromes, and set reconciliation from the inventive centre;
- removes dependence on an internally invisible algebraic decoder;
- changes the accepted-result representation rather than adding another audit layer;
- makes every mandatory obligation a non-optional structural component;
- prevents one generic witness from silently filling multiple obligation positions;
- makes evaluated pass and non-applicability explicit disjoint constructors;
- makes failure and diagnostic states structurally non-accepting;
- prevents downstream systems from trusting a detached Boolean;
- exposes direct black-box evidence through object shape, constructor tags, local openings, and malformed-object rejection behavior;
- supports implementation-neutral claims across generated schemas, typed records, proof terms, binary descriptors, and runtime validators;
- forces competitors seeking the same public per-obligation and bypass-free guarantee to implement an equivalent exact witness product or accept a materially weaker product;
- strictly improves every requested score;
- was not matched in the reviewed patent material by one reference containing the complete profile-synthesized exact object, one mandatory local witness per obligation, constructor exclusivity, semantic local binding, no detached authoritative acceptance state, canonical inhabitation, and downstream accepted-handle interaction.

---

# 30. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh professional prior-art search focused on:
   - proof-carrying authorization;
   - proof-carrying data;
   - dependent records and refinement types;
   - generated exact schemas;
   - certificate proof objects;
   - canonical typed credentials;
   - mandatory policy-witness products;
   - downstream proof-validation interlocks;
   - algebraic data types in security protocols;
   - typed attestations;
2. limitation-by-limitation claim charts against:
   - US-8104021-B2;
   - US-8392897-B2;
   - US-6256734-B1;
   - US-12058265-B2;
   - US-20170359184-A1;
   - US-11809443-B2;
   - US-12235830-B2;
   - EP-3616117-B1;
   - US-12261888-B2;
   - US-7509489-B2;
   - US-11671264-B1;
3. prosecution-history review of the active structured-data, proof-carrying-code, policy-validation, and schema-validation families;
4. jurisdiction-specific subject-matter analysis for software data structures and verification systems;
5. non-patent literature review covering:
   - Curry-Howard correspondence;
   - dependent and refinement types;
   - algebraic data types;
   - proof-carrying code;
   - proof-carrying authorization;
   - proof-carrying data;
   - typestate;
   - canonical serialization;
   - language-neutral interface definition systems;
6. review of whether any public Glyphser document has already disclosed the exact GIAO interaction;
7. inventorship analysis for the profile compiler, witness constructors, canonical object semantics, and consumer interlock;
8. implementation-specific FTO review of the chosen schema, proof, signature, and serialization libraries.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
