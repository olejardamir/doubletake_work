# Glyphser Patent Direction
## Sixteenth-Pass Conflict Review, Strictly Improved Risk Scores, and Risk-Focused Replacement Architecture

**Review date:** July 17, 2026  
**Direction re-examined:** *Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts*  
**Replacement direction:** *Post-Commitment Obligation-Coded Challenge Matrices with Causal-Binding Syndrome Receipts*  
**Suggested protocol name:** **Glyphser Causal-Binding Matrix — GCBM**

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not legal advice, a patentability opinion, a validity opinion, or a freedom-to-operate opinion. A qualified patent attorney should review the cited claims, prosecution histories, continuations, patent families, legal status, non-patent literature, inventorship, public disclosures, and the exact Glyphser implementation in every intended jurisdiction.
>
> **Search limitation:** This pass used public patent-index searches and direct patent pages, together with the references identified in the preceding pass. Patent-office status labels and Google Patents status labels are search signals, not legal conclusions. The search cannot exclude unpublished applications, unindexed documents, non-English prior art, or relevant non-patent literature.

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

The fifteenth-pass direction should not remain the principal Glyphser patent nucleus.

That direction proposed:

- compiling a verification profile into mandatory obligation objects;
- creating an evaluation settlement capability and a non-applicability settlement capability for each obligation;
- consuming one capability and cancelling the companion capability;
- consuming bounded-use evidence capabilities;
- emitting typed relation-result capabilities;
- assigning and conserving acceptance authority;
- requiring exact-one obligation settlement;
- requiring exact-one final result consumption;
- issuing an acceptance conservation receipt.

The deeper review materially worsens the risk assessment.

The central mechanisms can be decomposed into a combination of already crowded fields:

```text
exactly-once transaction semantics
    +
single-use or bounded-use tokens
    +
policy or authorization tokens
    +
resource-budget accounting
    +
mutually exclusive state transitions
    +
audit and certification receipts
```

The combination may remain narrower than any one located reference, but it is vulnerable to a straightforward obviousness construction. It is also less enforceable than the prior score suggested because the principal conduct occurs inside the verifier. A competitor can implement equivalent guarantees through ordinary transactional records, idempotent database constraints, static type checking, set equality, a workflow engine, or a formal proof without exposing literal capabilities or acceptance-authority units.

The deeper review therefore revises the current direction to:

| Category | Fifteenth-pass score | Sixteenth-pass revised score |
|---|---:|---:|
| Novelty risk | 3.5 | **6.0** |
| Obviousness risk | 5.0 | **8.5** |
| Subject-matter/technicality risk | 1.0 | **2.0** |
| Freedom-to-operate risk | 3.5 | **6.5** |
| Ease of enforcing | 10.0 | **7.0** |
| Ease for competitors to design around | 2.5 | **6.0** |

## Replacement decision

Retire this as the principal filing direction:

> **Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts**

Retain only as optional embodiments:

- exact-once obligation records;
- bounded evidence-use counters;
- mutually exclusive applicability states;
- result-consumption records;
- accounting-style receipts.

Proceed instead with:

# **Post-Commitment Obligation-Coded Challenge Matrices with Causal-Binding Syndrome Receipts**

The replacement solves a more technically specific problem:

> A verifier can publicly claim that every mandatory obligation was checked while actually ignoring an obligation, wiring one obligation to another obligation's evidence, using one evidence path for several obligations, globally failing all adversarial inputs without preserving obligation-specific results, or generating a receipt that lists obligations without proving that each obligation was causally connected to its own evidence and result. How can the verifier prove, for one certificate and one production verifier build, that every mandatory obligation has a distinct, testable, one-to-one causal binding to its authorized evidence and its own result?

The replacement works by:

1. executing and committing a baseline production-verifier evaluation;
2. obtaining a challenge nonce only after the baseline commitment;
3. deriving a separating or `d`-disjunct obligation challenge matrix from the commitment and nonce;
4. constructing challenge certificates by applying canonical evidence perturbations to the obligations selected in each matrix row;
5. executing the same committed verifier build on the challenge certificates;
6. deriving an observed response signature for every obligation from its per-round result changes;
7. requiring each observed signature to equal the matrix column assigned to that obligation;
8. rejecting zero signatures, duplicate signatures, cross-wired signatures, fan-in signatures, global-failure signatures, and sibling-state instability;
9. emitting a public causal-binding syndrome receipt with independently openable matrix rows and result cells.

The core interaction is:

```text
baseline verifier commitment
    +
post-commitment unpredictable challenge seed
    +
profile-derived separating obligation matrix
    +
canonical evidence-only perturbations
    +
same production verifier build
    +
per-obligation response signatures
    +
column-to-signature equality
    +
cross-wiring and omission syndromes
    +
public challenge openings
```

This is materially less exposed to token, authorization, accounting, exact-once, and residual-policy patent families.

---

# 3. Revised scores

## 3.1 Direction re-examined

### Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts

| Category | Revised score |
|---|---:|
| **Novelty risk** | **6.0/10** |
| **Obviousness risk** | **8.5/10** |
| **Subject-matter/technicality risk** | **2.0/10** |
| **Freedom-to-operate risk** | **6.5/10** |
| **Ease of enforcing the patent** | **7.0/10** |
| **Ease for competitors to design around** | **6.0/10** |

## 3.2 Replacement direction

### Post-Commitment Obligation-Coded Challenge Matrices with Causal-Binding Syndrome Receipts

| Category | Score |
|---|---:|
| **Novelty risk** | **2.5/10** |
| **Obviousness risk** | **4.0/10** |
| **Subject-matter/technicality risk** | **0.5/10** |
| **Freedom-to-operate risk** | **2.0/10** |
| **Ease of enforcing the patent** | **9.5/10** |
| **Ease for competitors to design around** | **1.5/10** |

## 3.3 Strict improvement check

| Category | Re-examined direction | Replacement | Strict improvement |
|---|---:|---:|---|
| Novelty risk | 6.0 | 2.5 | **Yes — 3.5 lower** |
| Obviousness risk | 8.5 | 4.0 | **Yes — 4.5 lower** |
| Subject-matter/technicality risk | 2.0 | 0.5 | **Yes — 1.5 lower** |
| Freedom-to-operate risk | 6.5 | 2.0 | **Yes — 4.5 lower** |
| Ease of enforcing | 7.0 | 9.5 | **Yes — 2.5 higher** |
| Ease of design-around | 6.0 | 1.5 | **Yes — 4.5 lower** |

**Every requested category improves. None remains unchanged.**

---

# 4. Direction re-examined

# Exact-One Evidence-Obligation Settlement with Acceptance-Authority Conservation Receipts

The prior architecture was:

```text
verification profile
        ↓
mandatory obligation objects
        ↓
paired evaluation / non-applicability capabilities
        ↓
bounded-use evidence capabilities
        ↓
typed result capabilities
        ↓
acceptance-authority accounting
        ↓
exact-one finalization
        ↓
conservation receipt
```

Its strongest proposed limitations were:

1. one profile-minted object for every mandatory obligation;
2. two mutually exclusive settlement modes;
3. evaluation requiring evidence consumption;
4. non-applicability requiring proof consumption;
5. cancellation of the unused mode;
6. single-use or bounded-use evidence;
7. typed result objects;
8. diagnostic results having zero acceptance authority;
9. no net amplification of acceptance authority;
10. exactly one settlement per obligation;
11. exactly one final consumption per required result;
12. a machine-verifiable public receipt.

The deeper search shows that the inventive centre is assembled from mechanisms already used in transaction processing, token systems, access control, resource accounting, workflow completion, certification, and audit systems.

---

# 5. Deeper conflict analysis of the re-examined direction

## 5.1 Exactly-once transaction semantics

### [US-4949251-A — Exactly-once semantics in a TP queuing system](https://patents.google.com/patent/US4949251A/en)

The patent uses:

- unique task identifiers;
- durable transaction records;
- duplicate detection;
- exactly-once execution after failure and recovery.

### [US-7249192-B1 — Protocol for insuring exactly once semantics of transactions across an unordered, unreliable network](https://patents.google.com/patent/US7249192B1/en)

The patent addresses:

- exactly-once transaction execution;
- transaction identifiers;
- duplicate suppression;
- completion state across unreliable communication.

### [US-20160246522-A1 — Exactly once semantics](https://patents.google.com/patent/US20160246522A1/en)

The application describes:

- a unique transaction structure;
- persistent completion state;
- prevention of replay after completion;
- one execution of a non-idempotent operation.

### [US-12061608-B2 — Duplicate detection and replay to ensure exactly-once delivery in a streaming pipeline](https://patents.google.com/patent/US12061608B2/en)

The family uses duplicate detection, missing-event detection, replay, and audit information to obtain exactly-once behavior.

### Conflict

An obligation settlement can be characterized as a transaction that must commit once and cannot be replayed. A settlement identifier, state cell, consume flag, cancellation record, and final receipt are natural adaptations of exactly-once transaction machinery.

---

## 5.2 Exactly-once use of certified evidence or data

### [US-12088719-B2 — Method and system for incremental training of machine learning models on edge devices](https://patents.google.com/patent/US12088719B2/en)

The patent describes a verification module that ensures:

- each data item contributes exactly once;
- a unique encrypted signature prevents reuse;
- the resulting model version is certified.

### Conflict

The prior Glyphser direction similarly uses unique evidence identities, prevents reuse, and certifies a final result. The application domain differs, but the functional pattern is close enough to strengthen an obviousness combination.

---

## 5.3 Single-use and bounded-use token systems

### [US-8224754-B2 — Generation, distribution and verification of tokens using a secure hash algorithm](https://patents.google.com/patent/US8224754B2/en)

The patent describes:

- one-time token use;
- marking a token as used;
- removing or invalidating a consumed token;
- counters for predetermined numbers of uses;
- rejection after the use limit is reached.

Additional relevant families identified in the preceding pass include:

- **US-11715101-B2 — Single-Use Payment Tokens**;
- **US-11044257-B1 — One-Time Access to Protected Resources**;
- **US-10382426-B2 — Single Sign-On with Single-Use Access Tokens**;
- **US-11777725-B2 — Secure Selective Rules-Driven Token Invalidation**.

### Conflict

A settlement capability or evidence capability is functionally a bounded-use authorization object. Consuming one object, changing its state, cancelling a companion object, and rejecting subsequent use are established token-system behaviors.

---

## 5.4 Policy and authorization tokens

### [US-12219060-B2 — Access policy token](https://patents.google.com/patent/US12219060B2/en)

The patent concerns policy-bearing tokens used to represent security information and privileges.

### [US-9258312-B1 — Distributed policy enforcement with verification mode](https://patents.google.com/patent/US9258312B1/en)

The patent includes:

- policy enforcement;
- verification-mode tokens;
- substitution of decision data;
- reporting of policy and decision data used in evaluation.

Additional prior-pass references include:

- **US-11196560-B2 — Policy and Token-Based Authorization Framework**;
- **US-11658983-B2 — Authentication and Authorization Across Microservices**;
- **US-20140337955-A1 — Authentication and Authorization with a Bundled Token**.

### Conflict

A capability that authorizes one verifier operation under a profile can be characterized as a policy token. Typed authority and permitted obligation identifiers resemble token-scoped privileges.

---

## 5.5 Resource-accounting and budget conservation

### [US-5421011-A — Access and accounting control using a resource account](https://patents.google.com/patent/US5421011A/en)

The patent includes:

- resource accounts;
- quotas;
- decrementing available resources when consumed;
- rejection when a quota is exceeded;
- audit and accounting records.

Additional prior-pass references include:

- **US-20180025166-A1 / EP-3256998-A1 — Validating Computer Resource Usage**;
- transaction systems that deplete authorized amounts;
- UTXO-style systems that prohibit double spending and preserve value conservation.

### Conflict

“Acceptance authority” behaves as an accounting unit. Minting a fixed budget, routing it, consuming it, cancelling it, and requiring zero residual balance are familiar conservation-ledger operations. Replacing money, quota, or computing units with verification authority may be viewed as a field-of-use substitution.

---

## 5.6 Audit and certification receipts

### [US-12406255-B2 — Non-interactive token certification and verification](https://patents.google.com/patent/US12406255B2/en)

The patent concerns certified tokens and non-interactive verification.

### [US-11398906-B2 — Confirming receipt of audit records for audited use of a cryptographic key](https://patents.google.com/patent/US11398906B2/en)

The patent includes:

- signed audit records;
- auditor receipts;
- identifying records that have not been verified;
- blocking output when audit conditions are not satisfied.

### [US-10887104-B1 — Cryptographically secured decentralized testing](https://patents.google.com/patent/US10887104B1/en)

The patent includes:

- commitments to test-result identifiers;
- cryptographic proofs;
- authenticated test results;
- public or immutable recording.

### Conflict

The conservation receipt adds certification and audit visibility to already known state transitions. Receipt generation alone is unlikely to supply a strong inventive centre.

---

## 5.7 Workflow completion and evidence approval

### [US-7966350-B2 — Evidence repository application system and method](https://patents.google.com/patent/US7966350B2/en)

The patent describes:

- evidence collection;
- criteria evaluation;
- approval processes;
- accountable roles;
- reports summarizing evaluation data.

Workflow systems commonly track mandatory tasks, terminal states, duplicates, completion, and missing actions.

### Conflict

Mandatory obligation objects and finalization guards can be characterized as a specialized workflow-completion engine.

---

## 5.8 Completion-detection structures

Prior-pass references include:

- **US-8074193-B2 — Mixed Single-Rail and Dual-Rail Logic with Completion Detection**;
- **US-7870516-B2 — Asynchronous Multi-Rail Logic with Completion Detection**;
- **US-6526542-B2 — Multi-Rail Asynchronous Flow with Completion Detection**.

### Conflict

These are hardware systems, not software verification protocols. They do not anticipate GOSM. However, they weaken broad arguments that paired mutually exclusive rails and complete terminal-state detection are conceptually unique.

---

# 6. Revised risk analysis of the re-examined direction

## 6.1 Novelty risk — 6.0/10

No single located reference was found with the complete GOSM interaction.

However, nearly every operational element is individually close to established mechanisms:

- exact-once transactions;
- one-time or bounded-use tokens;
- policy-scoped token privileges;
- cancellation or invalidation;
- quota and conservation accounting;
- workflow completion;
- audit receipts.

A narrow combination claim may remain novel, but its commercial breadth would be limited.

---

## 6.2 Obviousness risk — 8.5/10

A plausible examiner combination is:

1. exactly-once transaction identifiers and durable completion state;
2. single-use token invalidation;
3. policy-token scope restrictions;
4. resource-budget accounting;
5. workflow completion checks;
6. signed audit or certification receipts.

Each reference would perform its ordinary function. The principal inventive-step argument would depend on the aggregate verifier use case, which may not be enough.

---

## 6.3 Subject-matter/technicality risk — 2.0/10

The state machine is technical, but “obligation,” “acceptance authority,” and “settlement” can be characterized as administrative or mathematical bookkeeping unless the claims are tightly tied to:

- memory-state transitions;
- atomic update operations;
- replay prevention;
- evidence-object serialization;
- concrete verifier execution;
- a measurable reduction in omitted, duplicated, or misrouted verification operations.

The prior direction remains eligible-looking, but the abstract-accounting characterization is stronger than previously scored.

---

## 6.4 Freedom-to-operate risk — 6.5/10

Implementation could intersect active claims involving:

- one-time token generation and invalidation;
- access-policy tokens;
- verification-mode tokens;
- audit-record receipts;
- certified token verification;
- exactly-once streaming or transaction systems;
- quota and resource-consumption ledgers.

The exact risk depends heavily on whether Glyphser uses a token server, database transaction pattern, blockchain-like spend model, or protected execution environment.

---

## 6.5 Ease of enforcing — 7.0/10

The prior 10.0 score was too high.

A public receipt may reveal counts and roots, but the potentially infringing conduct is internal:

- whether two literal capabilities were minted;
- whether one was atomically cancelled;
- whether evidence was represented as a consumable capability;
- whether authority was internally conserved;
- whether a diagnostic result carried a zero-valued authority field.

A competitor can publish equivalent outputs while using materially different internal representations. Discovery may be required.

---

## 6.6 Ease for competitors to design around — 6.0/10

A competitor can preserve much of the commercial guarantee by using:

- database uniqueness constraints;
- ordinary task-completion tables;
- idempotent transaction records;
- immutable event logs;
- set equality between required and completed checks;
- static linear types;
- a formally verified verifier;
- proof-carrying code;
- a signed result manifest without capability objects;
- one ordinary enum per obligation instead of paired capabilities;
- one boolean “used” flag instead of authority conservation.

The direction therefore does not force competitors into a narrow technical corridor.

---

# 7. Replacement direction

# Post-Commitment Obligation-Coded Challenge Matrices with Causal-Binding Syndrome Receipts

## 7.1 Technical objective

A verifier may list every mandatory obligation and still contain any of these defects:

```text
obligation omitted from execution
obligation wired to the wrong evidence
one evidence path used for multiple obligations
one result copied into multiple obligation slots
obligation result generated but not causally dependent on evidence
all adversarial inputs rejected globally without obligation-specific evaluation
receipt fields populated from the profile rather than actual verifier behavior
```

GCBM proves a stronger property:

> Every mandatory obligation has a distinct, externally testable causal response to canonical perturbations of its own authorized evidence, while obligations not selected for perturbation preserve their baseline results.

This is not merely proof that the obligations were listed or settled. It is proof of a one-to-one causal binding among:

```text
obligation identifier
    ↔
authorized evidence position
    ↔
production-verifier relation result
```

---

# 8. Baseline commitment phase

The production verifier first evaluates the unmodified certificate.

It emits a baseline commitment before learning the challenge matrix.

```text
baseline_commitment:
    schema_version

    profile_root
    certificate_subject_root
    evidence_vector_root
    obligation_vector_root

    verifier_build_root
    verifier_configuration_root

    baseline_relation_vector_root
    baseline_final_state

    commitment_nonce
    commitment_time
    commitment_hash
```

Strong testing requires:

```text
baseline_final_state = ACCEPTED
```

The verifier build and configuration are fixed for all later challenge runs.

---

# 9. Post-commitment challenge seed

Only after the baseline commitment is fixed does the system obtain an unpredictable challenge value.

Possible sources:

```text
independent auditor nonce
public randomness beacon value
verifier-client joint nonce
signed challenge-service nonce
```

The challenge seed is:

```text
challenge_seed = H(
    baseline_commitment_hash
    || external_challenge_nonce
    || profile_root
    || certificate_subject_root
)
```

The post-commitment timing prevents a verifier from selecting a convenient baseline or hard-coding one known challenge schedule before the baseline is committed.

The principal claim does not require a blockchain, TEE, TPM, or remote-attestation service.

---

# 10. Obligation challenge contracts

Each mandatory obligation has a profile-defined challenge contract.

```text
obligation_challenge_contract:
    obligation_id
    obligation_type

    evidence_selector
    evidence_subject_rule

    nullification_transform_id
    contradiction_transform_id

    expected_nullification_state
    expected_contradiction_state

    sibling_stability_rule
    challenge_contract_hash
```

Canonical transformations act on evidence, not verifier code.

Examples:

```text
remove required artifact commitment
replace digest with same-length contradictory digest
replace dependency root with a different validly encoded root
replace metric threshold evidence with a boundary-violating value
remove applicability proof
replace policy identity with a different authenticated identity
```

The transformation must be:

- deterministic;
- profile-authorized;
- type preserving where required;
- limited to the selected obligation's evidence region;
- independently reproducible.

---

# 11. Separating obligation challenge matrix

For `n` mandatory obligations, the compiler generates a binary matrix:

```text
M ∈ {0,1}^{k×n}
```

Each column corresponds to one obligation.

Each row corresponds to one challenge run.

Required properties:

```text
column_i ≠ 0
column_i ≠ column_j for i ≠ j
no column is all ones
row weights satisfy profile bounds
```

A stronger profile may require a `d`-disjunct or otherwise uniquely decodable matrix so that a result depending on as many as `d` wrong evidence sources can be identified.

The matrix is generated from:

```text
M = MATRIX_GEN(
    challenge_seed,
    obligation_count,
    decoding_strength,
    row_weight_policy
)
```

The identity matrix is a conservative valid embodiment.

Compressed code matrices are performance embodiments.

---

# 12. Challenge certificate generation

For challenge row `r`:

```text
challenge_set_r = { obligation_i | M[r,i] = 1 }
```

The system creates a challenge certificate by applying the canonical transform only to evidence selected by that row.

```text
challenge_certificate_r:
    baseline_certificate_root
    challenge_seed
    matrix_row_index
    selected_obligation_ids
    applied_transform_ids
    transformed_evidence_root
    unchanged_evidence_root
    challenge_certificate_hash
```

Two matrix families may be generated:

```text
M_nullification
M_contradiction
```

The dual family distinguishes:

- a verifier that reacts only to missing data;
- a verifier that reacts to contradictory but well-formed data;
- a verifier that performs only global input rejection;
- a verifier that actually evaluates the obligation relation.

---

# 13. Same-build challenge execution

Every challenge certificate is evaluated by the same committed production verifier build and configuration.

```text
RUN_CHALLENGE(
    verifier_build_root,
    verifier_configuration_root,
    challenge_certificate_r
)
    →
challenge_relation_vector_r
    +
challenge_final_state_r
```

The system records a result for every mandatory obligation, not only one global rejection bit.

```text
challenge_relation_result:
    obligation_id
    relation_state
    failure_code
    evidence_selector_root
    result_hash
```

---

# 14. Observed response signatures

For obligation `i`, define a response bit in round `r`:

```text
response_bit[r,i] = 1
```

only when:

- obligation `i` was baseline-passing;
- challenge run `r` changed obligation `i` to its profile-defined challenge state;
- the changed result is bound to the expected transformed evidence selector.

The observed response signature is:

```text
S_i = response_bit[:,i]
```

Strong causal binding requires:

```text
S_i = M[:,i]
```

for the relevant challenge family.

---

# 15. Detectable defect syndromes

## 15.1 Omitted obligation

If obligation `i` is never evaluated:

```text
S_i = 0
```

Result:

```text
OMITTED_OR_INERT_OBLIGATION
```

---

## 15.2 Cross-wired obligation

If result slot `i` actually depends on evidence for obligation `j`:

```text
S_i = M[:,j]
```

Result:

```text
CROSS_WIRED_OBLIGATION(i, j)
```

---

## 15.3 Duplicate result mapping

If two obligation result slots depend on the same evidence path:

```text
S_i = S_j
```

Result:

```text
DUPLICATE_CAUSAL_BINDING(i, j)
```

---

## 15.4 Hidden fan-in

If obligation `i` depends on several evidence paths:

```text
S_i = OR(M[:,a], M[:,b], ...)
```

A `d`-disjunct matrix can decode a bounded dependency set.

Result:

```text
UNDECLARED_MULTI_EVIDENCE_BINDING
```

---

## 15.5 Global fail-closed shortcut

If every obligation is marked failed whenever any challenge occurs:

```text
S_i = all_ones
```

Because all-one columns are prohibited and unselected siblings must remain stable, the shortcut fails.

Result:

```text
GLOBAL_FAILURE_SUBSTITUTION
```

---

## 15.6 Overbroad perturbation

If perturbing obligation `i` changes an unselected obligation `j` without a declared dependency:

```text
M[r,j] = 0
and
result_r[j] ≠ baseline_result[j]
```

Result:

```text
SIBLING_STABILITY_VIOLATION
```

---

## 15.7 Receipt-only fabrication

A receipt generated from profile fields without executing the production verifier cannot reproduce independently challenged row openings unless it predicts the post-commitment challenge seed and consistent challenge results.

Result:

```text
CHALLENGE_OPENING_MISMATCH
```

---

# 16. Causal-binding syndrome receipt

```text
causal_binding_syndrome_receipt:
    schema_version

    profile_root
    certificate_subject_root

    verifier_build_root
    verifier_configuration_root

    baseline_commitment_hash
    baseline_relation_vector_root
    baseline_final_state

    external_challenge_nonce_commitment
    challenge_seed

    nullification_matrix_root
    contradiction_matrix_root
    matrix_dimensions
    decoding_strength

    challenge_certificate_root
    challenge_result_vector_root

    expected_signature_root
    observed_signature_root

    zero_signature_obligation_root
    duplicate_signature_root
    cross_wiring_root
    multi_binding_root
    sibling_instability_root
    global_failure_root

    unopened_row_commitment_root
    challenge_opening_policy

    final_causal_binding_state
    receipt_hash
```

Possible final states:

```text
CAUSAL_BINDING_CLOSED
OMITTED_OR_INERT_OBLIGATION
CROSS_WIRED_OBLIGATION
DUPLICATE_CAUSAL_BINDING
UNDECLARED_MULTI_EVIDENCE_BINDING
SIBLING_STABILITY_VIOLATION
GLOBAL_FAILURE_SUBSTITUTION
CHALLENGE_OPENING_MISMATCH
BASELINE_NOT_ACCEPTED
VERIFIER_BUILD_MISMATCH
MATRIX_INVALID
TRANSFORM_CONTRACT_VIOLATION
```

Only:

```text
CAUSAL_BINDING_CLOSED
```

supports the strongest certificate state.

---

# 17. Public challenge openings

The receipt supports independent opening of:

- one matrix row;
- one matrix column;
- one challenge certificate;
- one transformed evidence cell;
- one unchanged sibling evidence cell;
- one obligation result in one challenge round;
- one complete response signature;
- one decoded cross-wiring or multi-binding syndrome.

An opening contains:

```text
challenge_opening:
    receipt_hash
    matrix_coordinate
    matrix_membership_proof

    baseline_evidence_commitment
    transformed_evidence_value_or_commitment
    transform_contract

    baseline_result
    challenge_result
    result_vector_membership_proof

    expected_signature_fragment
    observed_signature_fragment

    opening_state
```

This produces direct black-box infringement evidence without requiring source-code discovery.

---

# 18. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising executing a certificate verifier on a certificate according to a verification profile defining a plurality of mandatory verification obligations and generating, before selection of challenge inputs, a baseline commitment bound to a verifier build, a verifier configuration, a certificate-subject value, an evidence vector, a mandatory-obligation vector, and a baseline relation-result vector; receiving, after generation of the baseline commitment, a challenge nonce; deterministically generating from the baseline commitment and the challenge nonce a challenge incidence matrix having a respective nonzero distinguishable column for each mandatory verification obligation; for each of a plurality of rows of the challenge incidence matrix, generating a challenge certificate by applying a profile-defined evidence transformation to evidence associated with each mandatory verification obligation indicated by the row while preserving evidence associated with mandatory verification obligations not indicated by the row; executing the committed verifier build and verifier configuration on each challenge certificate to generate a respective challenge relation-result vector; deriving, for each mandatory verification obligation, an observed response signature from changes of a corresponding relation result across the challenge relation-result vectors; comparing the observed response signature with the column of the challenge incidence matrix assigned to the mandatory verification obligation; detecting, according to the comparison, at least one of an omitted obligation, an obligation causally bound to evidence of a different obligation, two obligations causally bound to a common evidence path, an undeclared multi-evidence dependency, or a change to an unselected sibling obligation; and issuing a machine-verifiable causal-binding syndrome receipt bound to the baseline commitment, challenge nonce, challenge incidence matrix, evidence transformations, challenge relation-result vectors, observed response signatures, detected syndrome sets, and a final causal-binding state.

The strongest limitations are:

1. baseline commitment before challenge selection;
2. post-commitment challenge nonce;
3. one distinguishable matrix column per mandatory obligation;
4. profile-defined evidence perturbations rather than verifier-code mutation;
5. the same committed production verifier build for baseline and challenges;
6. per-obligation result vectors for every challenge run;
7. an observed response signature for each obligation;
8. equality between each response signature and its assigned matrix column;
9. detection of zero, duplicate, substituted, and composite signatures;
10. preservation of unselected sibling obligation results;
11. a public syndrome receipt;
12. independently openable matrix, evidence, and result coordinates.

---

# 19. Closest prior-art categories for the replacement

## 19.1 Mutation testing

### [US-11119902-B2 — Creating a higher order mutant for mutation testing software](https://patents.google.com/patent/US11119902B2/en)

The patent combines code mutations based on code paths to create higher-order mutants.

### [US-11409641-B1 — Mutation testing of database functions](https://patents.google.com/patent/US11409641B1/en)

The patent applies mutation testing to database functions.

### Difference

GCBM does not mutate verifier code to measure test quality.

It:

- commits a production verifier build;
- perturbs certificate evidence according to obligation contracts;
- derives one causal response signature per mandatory obligation;
- compares the signature with a post-commitment matrix column;
- emits a per-certificate public receipt.

---

## 19.2 Fault injection

### [US-7539978-B1 — Method for understanding and testing third-party software components](https://patents.google.com/patent/US7539978B1/en)

The patent injects directed or random faults into component data and observes behavior.

### [US-20140013164-A1 — Fault-based software testing method and system](https://patents.google.com/patent/US20140013164A1/en)

The application generates faulty programs, groups them, and evaluates representative faults.

### [US-12019119-B2 — Fault injection testing of an integrated-circuit hardware design](https://patents.google.com/patent/US12019119B2/en)

The patent groups fault nodes by common failure effect and performs selected fault injection tests.

### Difference

GCBM uses profile-defined evidence perturbations to prove a one-to-one mapping between mandatory obligation, evidence, and result. It is not general robustness testing or defect localization.

---

## 19.3 Combinatorial test design

### [US-11010285-B2 — Fault detection and localization using combinatorial test design](https://patents.google.com/patent/US11010285B2/en)

The patent uses combinatorial test design to detect and localize faults and generate failing test cases.

### Difference

GCBM's matrix columns are semantic identities assigned to mandatory certificate-verification obligations. The claimed output is not a fault bucket or regression suite; it is a causal-binding proof in which every obligation's observed response signature must match its assigned challenge column.

---

## 19.4 Test abstraction matrices

### [US-6986125-B2 — Testing and evaluating a software component using an abstraction matrix](https://patents.google.com/patent/US6986125B2/en)

The patent maps test scenarios to expected results and evaluates generated test results using the matrix.

### Difference

GCBM generates the matrix only after a baseline commitment, applies matrix-selected evidence perturbations, derives response signatures from production-verifier result changes, and diagnoses omission or cross-wiring by comparing a result signature to an obligation column.

---

## 19.5 Formal verification coverage and proof cores

### [US-8826201-B1 — Formal verification coverage metrics for circuit design properties](https://patents.google.com/patent/US8826201B1/en)

### [US-9177089-B2 — Formal verification coverage metrics for circuit design properties](https://patents.google.com/patent/US9177089B2/en)

The patents identify a proof core within a cone of influence and generate coverage metrics.

### Difference

GCBM does not calculate a circuit proof-core coverage ratio. It externally challenges certificate evidence and verifies the distinct behavioral signature of each mandatory software-verification obligation.

---

## 19.6 Counterfactual explanations

### [US-12596941-B2 — Realistic counterfactual explanation of machine-learning predictions](https://patents.google.com/patent/US12596941B2/en)

The patent generates realistic counterfactual changes that alter an ML prediction.

### Difference

GCBM is not an ML explanation method. It uses a post-commitment separating matrix to verify complete causal wiring of mandatory certificate obligations in a deterministic production verifier.

---

## 19.7 Cryptographically secured testing and commitments

### [US-10887104-B1 — Cryptographically secured decentralized testing](https://patents.google.com/patent/US10887104B1/en)

The patent uses commitments, cryptographic proofs, and recorded test results.

### Difference

GCBM's inventive centre is not the commitment primitive. It is the interaction among post-commitment matrix selection, evidence-only obligation challenges, per-obligation response signatures, syndrome decoding, sibling stability, and public openings.

---

# 20. Replacement-direction risk analysis

## 20.1 Novelty risk — 2.5/10

The component technologies are known:

- fault injection;
- mutation testing;
- combinatorial test design;
- group testing and separating matrices;
- challenge-response protocols;
- cryptographic commitments;
- result receipts;
- formal coverage metrics.

The reviewed patent material did not identify one reference containing the complete interaction:

```text
baseline production-verifier commitment
    +
challenge selected after commitment
    +
one distinguishable matrix column per mandatory obligation
    +
canonical evidence-only transformation
    +
same committed verifier build
    +
per-obligation challenge result vectors
    +
observed response signature per obligation
    +
signature-to-column equality
    +
omission / cross-wiring / duplicate / fan-in syndromes
    +
unselected sibling stability
    +
public challenge openings
```

The direction is narrower and more structurally distinctive than GOSM.

---

## 20.2 Obviousness risk — 4.0/10

An examiner could combine:

1. fault injection;
2. combinatorial test matrices;
3. challenge-response commitments;
4. audit receipts.

The stronger inventive-step arguments are:

- the baseline is committed before challenge selection;
- the matrix columns identify mandatory semantic obligations, not generic input factors;
- the system derives a behavioral signature for each obligation;
- the expected signature is the obligation's matrix column;
- cross-wiring is detected when one obligation follows another obligation's column;
- hidden fan-in is decoded from a composite signature;
- unselected sibling results must remain stable;
- the receipt proves per-certificate causal wiring of the production verifier.

These interactions are not the ordinary output of mutation testing or combinatorial test design.

---

## 20.3 Subject-matter/technicality risk — 0.5/10

The replacement is strongly technical because it requires:

- execution of a concrete verifier build;
- cryptographically or structurally committed baseline state;
- deterministic generation of a binary incidence matrix;
- byte-level or field-level evidence transformation;
- repeated machine execution;
- result-vector comparison;
- syndrome derivation;
- detection of specific wiring defects;
- independently verifiable data openings.

It changes the testing and verification operation of the computer and detects implementation defects that ordinary obligation lists cannot detect.

---

## 20.4 Freedom-to-operate risk — 2.0/10

FTO risks remain around:

- mutation and fault-injection systems;
- combinatorial test design;
- challenge-response commitments;
- cryptographically secured test-result systems;
- formal coverage analysis.

Risk is reduced because the principal claim can avoid requiring:

- mutation of source code;
- mutation of compiled verifier code;
- generation of regression test suites;
- ML counterfactual explanations;
- hardware fault-node simulation;
- blockchain;
- zero-knowledge proofs;
- one cryptographic commitment scheme;
- one group-testing construction.

The implementation should avoid copying the claim-specific code-mutation, test-generation, or hardware fault-node structures of active patents.

---

## 20.5 Ease of enforcing — 9.5/10

The replacement is directly black-box testable.

A conforming product exposes or can be induced to expose:

- a baseline commitment;
- a post-commitment challenge nonce;
- a matrix root;
- challenge certificates;
- per-obligation result vectors;
- response signatures;
- zero-signature and duplicate-signature sets;
- cross-wiring or fan-in syndromes;
- sibling-stability failures;
- public openings.

A claimant can supply a profile and certificate with known independent obligations, issue a nonce after baseline commitment, reproduce the matrix, submit the derived challenge certificates, and compare the returned result signatures.

The core infringement evidence does not depend on seeing internal token objects, authority ledgers, or source code.

---

## 20.6 Ease for competitors to design around — 1.5/10

The claim strategy should define a **separating challenge schedule** broadly enough to include:

- an identity matrix with one obligation per run;
- compressed binary code matrices;
- `d`-disjunct matrices;
- covering or locating arrays with distinguishable obligation signatures;
- deterministic or nonce-derived equivalent schedules.

A competitor can avoid the claims by using only:

- a static source-code proof;
- a fully formalized verifier proof;
- manual independent audits;
- a non-public internal test suite;
- a receipt that does not prove causal obligation-to-evidence binding.

Those alternatives lose the same inexpensive, per-certificate, public, black-box guarantee.

A competitor seeking the same combination of:

- public per-certificate proof;
- one-to-one obligation/evidence/result causality;
- omission detection;
- cross-wiring detection;
- duplicate binding detection;
- resistance to precomputed challenge responses;
- independently openable evidence;

has a narrow practical path around an implementation-neutral claim set.

---

# 21. Enforcement-focused design

## 21.1 Mandatory public fields

Every strong receipt should expose:

```text
profile_root
certificate_subject_root
verifier_build_root
verifier_configuration_root

baseline_commitment_hash
baseline_relation_vector_root
baseline_final_state

challenge_nonce_commitment
challenge_seed

matrix_root
matrix_dimensions
decoding_strength

challenge_certificate_root
challenge_result_vector_root

expected_signature_root
observed_signature_root

zero_signature_obligation_root
duplicate_signature_root
cross_wiring_root
multi_binding_root
sibling_instability_root
global_failure_root

final_causal_binding_state
receipt_hash
```

---

## 21.2 Public verifier

The public verifier should check:

1. baseline commitment integrity;
2. challenge nonce timing and binding;
3. matrix regeneration;
4. matrix-column uniqueness;
5. prohibited zero and all-one columns;
6. challenge transform validity;
7. preservation of unselected evidence;
8. same verifier build and configuration;
9. per-obligation result-vector commitments;
10. observed response signatures;
11. signature-to-column equality;
12. duplicate signatures;
13. cross-wired signatures;
14. multi-binding decoding;
15. sibling stability;
16. final receipt hash.

---

## 21.3 Product commands

```text
glyphser causal-profile compile
glyphser causal-baseline commit
glyphser causal-challenge derive
glyphser causal-challenge run
glyphser causal-syndrome finalize
glyphser causal-receipt inspect
glyphser causal-receipt open
glyphser causal-receipt verify
```

Suggested API surfaces:

```text
POST /causal-profiles/compile
POST /causal-evaluations/baseline
POST /causal-evaluations/{id}/challenge-seed
POST /causal-evaluations/{id}/challenge-certificates
POST /causal-evaluations/{id}/challenge-runs
POST /causal-evaluations/{id}/finalize
POST /causal-receipts/verify
POST /causal-receipts/{id}/open
GET  /causal-receipts/{id}
```

---

# 22. Anti-design-around claim strategy

## 22.1 Do not limit the principal claim to one matrix family

Use:

- separating challenge schedule;
- distinguishable obligation signatures;
- uniquely decodable challenge incidence structure.

Dependent claims may specify:

- binary matrices;
- identity matrices;
- error-correcting codes;
- `d`-disjunct matrices;
- locating arrays;
- compressed sensing or sparse-recovery constructions.

---

## 22.2 Claim evidence transformations independently of code mutation

Require transformation of committed verifier input evidence while preserving the committed verifier build.

This prevents a competitor from arguing that the invention is only mutation testing.

---

## 22.3 Claim the post-commitment timing

A competitor may precompute a fixed challenge suite.

Claim:

```text
baseline commitment
    precedes
challenge seed determination
```

and bind the matrix to both values.

---

## 22.4 Claim the causal signature, not merely pass/fail testing

The key output is:

```text
one observed response signature per mandatory obligation
```

and the required relation is:

```text
observed_signature_i = assigned_challenge_signature_i
```

---

## 22.5 Claim cross-wiring and duplicate-binding syndromes

A competitor may produce a challenge matrix but use it only to calculate coverage.

Separate claims should require detecting:

- a zero signature;
- a signature equal to another obligation's assigned signature;
- duplicate observed signatures;
- a composite signature corresponding to several evidence columns.

---

## 22.6 Claim sibling stability

A global rejection shortcut is a major design-around risk.

Claim that an obligation not selected in a challenge row preserves its baseline relation state unless the profile declares a dependency.

---

## 22.7 Claim public coordinate openings

Permit independent opening of:

- matrix coordinates;
- transformed evidence coordinates;
- unchanged sibling coordinates;
- result-vector coordinates;
- response-signature coordinates.

This strengthens both enforceability and technical effect.

---

## 22.8 Claim implementation-neutral commitments

Use broader terms such as:

- authenticated commitment;
- binding digest;
- append-only record root;
- signed manifest root;
- Merkle root;
- vector commitment.

Do not make one cryptographic primitive essential.

---

# 23. Recommended claim families

## Family A — Baseline-before-challenge commitment

Protect commitment of verifier build, configuration, evidence vector, obligation vector, and baseline result vector before challenge selection.

## Family B — Obligation challenge contracts

Protect profile-defined evidence selectors, perturbation operations, expected failure states, and sibling-stability rules.

## Family C — Separating obligation challenge schedules

Protect one distinguishable challenge signature per mandatory obligation.

## Family D — Evidence-only matrix challenges

Protect generation of challenge certificates that modify selected obligation evidence while preserving verifier code and unselected evidence.

## Family E — Per-obligation response signatures

Protect construction of an observed behavioral signature from multiple challenge result vectors.

## Family F — Signature-to-column causal binding

Protect equality between an obligation's observed signature and its assigned challenge signature.

## Family G — Omission and cross-wiring syndromes

Protect zero-signature, substituted-signature, duplicate-signature, and composite-signature detection.

## Family H — Sibling stability

Protect preservation of unselected obligation results and detection of global-failure substitution.

## Family I — Causal-binding syndrome receipt

Protect the public machine-readable artifact and independent verification.

## Family J — Challenge openings

Protect coordinate-level opening of matrix, evidence, result, and syndrome commitments.

## Family K — Dual nullification and contradiction matrices

Protect two challenge families that distinguish missing-data checking from actual relation evaluation.

## Family L — Cross-verifier causal comparison

Protect comparing response signatures produced by two verifier builds or implementations for the same profile and certificate.

---

# 24. Technical evidence needed before filing

## 24.1 Omitted obligation

Configure one obligation result to ignore all evidence.

Expected signature:

```text
0...0
```

Expected state:

```text
OMITTED_OR_INERT_OBLIGATION
```

---

## 24.2 Cross-wired evidence

Wire obligation `A` to evidence selector `B`.

Expected observation:

```text
S_A = M[:,B]
```

Expected state:

```text
CROSS_WIRED_OBLIGATION(A, B)
```

---

## 24.3 Duplicate causal binding

Wire two result slots to one evidence path.

Expected state:

```text
DUPLICATE_CAUSAL_BINDING
```

---

## 24.4 Hidden fan-in

Make one obligation depend on two undeclared evidence paths.

Expected state:

```text
UNDECLARED_MULTI_EVIDENCE_BINDING
```

---

## 24.5 Global fail-closed shortcut

Make the verifier return every obligation as failed whenever any challenge transform appears.

Expected state:

```text
GLOBAL_FAILURE_SUBSTITUTION
```

or:

```text
SIBLING_STABILITY_VIOLATION
```

---

## 24.6 Overbroad transform

Modify one selected evidence region and one unselected region.

Expected state:

```text
TRANSFORM_CONTRACT_VIOLATION
```

---

## 24.7 Wrong verifier build

Execute challenge runs with a build different from the baseline build.

Expected state:

```text
VERIFIER_BUILD_MISMATCH
```

---

## 24.8 Precomputed challenge attack

Attempt to issue challenge results before the external nonce is provided.

The final receipt must fail nonce and matrix binding.

---

## 24.9 Nullification-only verifier

Build a verifier that rejects absent evidence but accepts contradictory evidence.

The contradiction matrix must expose the defect.

---

## 24.10 Receipt-only fabrication

Generate a receipt from profile metadata without running challenges.

Randomly selected coordinate openings must fail.

---

## 24.11 Exact causal closure

For a correct verifier, demonstrate:

```text
∀ obligation_i:
    observed_nullification_signature_i
        = assigned_nullification_column_i

∀ obligation_i:
    observed_contradiction_signature_i
        = assigned_contradiction_column_i

zero_signature_set = ∅
duplicate_signature_set = ∅
cross_wiring_set = ∅
multi_binding_set = ∅
sibling_instability_set = ∅
```

Expected state:

```text
CAUSAL_BINDING_CLOSED
```

---

## 24.12 Implementation diversity

Implement the same protocol using:

1. one challenge run per obligation using an identity matrix;
2. a compressed binary separating matrix;
3. a `d`-disjunct matrix with bounded fan-in decoding.

All implementations should produce canonically equivalent causal-binding conclusions.

This supports implementation-neutral claims.

---

# 25. Glyphser implementation path

## 25.1 New schemas

```text
causal_verification_profile.v1
obligation_challenge_contract.v1
baseline_verifier_commitment.v1
challenge_seed_record.v1
obligation_challenge_matrix.v1
challenge_certificate.v1
challenge_relation_vector.v1
obligation_response_signature.v1
causal_binding_syndrome.v1
causal_binding_syndrome_receipt.v1
causal_challenge_opening.v1
```

## 25.2 Suggested modules

```text
runtime/glyphser/causal/profile.py
runtime/glyphser/causal/baseline.py
runtime/glyphser/causal/seed.py
runtime/glyphser/causal/matrix.py
runtime/glyphser/causal/transforms.py
runtime/glyphser/causal/challenge.py
runtime/glyphser/causal/execute.py
runtime/glyphser/causal/signatures.py
runtime/glyphser/causal/decode.py
runtime/glyphser/causal/stability.py
runtime/glyphser/causal/receipt.py
runtime/glyphser/causal/opening.py
runtime/glyphser/causal/verify.py
```

## 25.3 Suggested quality gates

```text
tooling/quality_gates/baseline_prechallenge_commitment_gate.py
tooling/quality_gates/challenge_nonce_binding_gate.py
tooling/quality_gates/challenge_matrix_separation_gate.py
tooling/quality_gates/challenge_transform_scope_gate.py
tooling/quality_gates/same_verifier_build_gate.py
tooling/quality_gates/response_signature_gate.py
tooling/quality_gates/cross_wiring_syndrome_gate.py
tooling/quality_gates/duplicate_binding_gate.py
tooling/quality_gates/multi_binding_decode_gate.py
tooling/quality_gates/sibling_stability_gate.py
tooling/quality_gates/causal_receipt_opening_gate.py
```

## 25.4 Required adversarial fixtures

```text
obligation_result_never_reads_evidence
obligation_a_reads_evidence_b
two_obligations_share_one_evidence_path
one_obligation_reads_two_undeclared_paths
all_challenges_fail_globally
challenge_changes_unselected_evidence
challenge_changes_unselected_result
challenge_uses_wrong_verifier_build
challenge_uses_wrong_configuration
challenge_seed_preselected
matrix_has_zero_column
matrix_has_duplicate_columns
matrix_has_all_one_column
nullification_detected_but_contradiction_ignored
receipt_generated_without_challenge_runs
challenge_opening_uses_wrong_row
challenge_opening_uses_wrong_result_cell
baseline_not_accepted
```

---

# 26. Features to exclude from the principal claim

Do not make these essential:

- single-use tokens;
- capability objects;
- acceptance-authority budgets;
- authority conservation;
- exact-once transaction records;
- blockchain;
- UTXO records;
- program slicing;
- partial policy evaluation;
- verifier-code mutation;
- source-code mutation;
- hardware fault-node simulation;
- machine-learning counterfactual explanations;
- zero-knowledge proofs;
- remote attestation;
- TPM;
- TEE;
- one matrix construction;
- one cryptographic hash;
- one commitment scheme;
- one operating system;
- one processor architecture.

They may appear as optional embodiments or dependent claims.

---

# 27. Filing strategy

## Principal independent method claim

Require:

- a baseline production-verifier commitment;
- challenge selection after the commitment;
- one distinguishable challenge signature per mandatory obligation;
- profile-defined evidence transformations;
- same-build challenge executions;
- per-obligation response signatures;
- signature-to-assigned-column comparison;
- detection of at least omission or cross-wiring;
- a public causal-binding syndrome receipt.

## Separate system claim

Claim components such as:

- profile compiler;
- baseline commitment engine;
- challenge-seed engine;
- separating-matrix generator;
- evidence-transform engine;
- challenge executor;
- response-signature generator;
- syndrome decoder;
- sibling-stability checker;
- receipt generator;
- opening verifier.

## Separate receipt claim

Where permitted, claim the machine-readable causal-binding syndrome receipt and its independent verification method.

## Separate challenge-service claim

Claim an independent service that:

- receives the baseline commitment;
- issues the post-commitment nonce;
- regenerates the challenge matrix;
- selects coordinate openings;
- verifies returned challenge evidence and results.

## Continuation applications

Potential continuation families:

1. baseline-before-challenge timing;
2. obligation challenge contracts;
3. separating challenge matrices;
4. dual nullification and contradiction matrices;
5. cross-wiring syndromes;
6. bounded fan-in decoding;
7. sibling-stability enforcement;
8. public challenge openings;
9. cross-verifier causal comparison;
10. compressed challenge schedules.

---

# 28. Final recommendation

The exact-one settlement direction is no longer the strongest filing candidate because its central mechanisms are closely adjacent to:

- exactly-once transaction systems;
- single-use and bounded-use tokens;
- policy and authorization tokens;
- token cancellation;
- resource and quota accounting;
- workflow completion;
- audit and certification receipts.

Replace it with:

> **A certificate-verification protocol that commits a baseline production-verifier result before challenge selection, derives from a later challenge nonce a separating challenge schedule assigning each mandatory obligation a distinguishable perturbation signature, modifies only the committed evidence selected in each challenge row, re-executes the same committed verifier build, derives an observed behavioral response signature for every obligation, detects omitted, cross-wired, duplicated, composite, globally substituted, or sibling-unstable obligation behavior by comparing observed signatures with assigned challenge signatures, and emits a public causal-binding syndrome receipt with independently openable matrix, evidence, and result coordinates.**

This direction is better because it:

- removes exact-once transactions, token consumption, and authority accounting from the inventive centre;
- proves actual obligation-to-evidence causality rather than only obligation bookkeeping;
- detects an obligation that exists in a receipt but is inert in execution;
- detects when one obligation is wired to another obligation's evidence;
- detects duplicate or hidden shared evidence paths;
- detects global fail-closed behavior that masquerades as obligation-specific verification;
- binds challenges to a nonce obtained after the baseline commitment;
- uses the same production verifier rather than a separate explanatory or residual verifier;
- is directly testable through a black-box challenge protocol;
- produces public infringement evidence without source-code discovery;
- covers identity matrices and compressed uniquely decodable challenge schedules;
- permits independent coordinate openings;
- makes a commercially equivalent design-around materially more difficult;
- strictly improves every requested score.

---

# 29. Required legal follow-up

Before filing or implementation, counsel should perform:

1. a fresh professional prior-art search focused on:
   - software group testing;
   - separating and locating arrays;
   - `d`-disjunct test matrices;
   - coded fault injection;
   - causal software testing;
   - metamorphic testing;
   - obligation-level policy mutation;
   - post-commitment challenge generation;
   - publicly verifiable test transcripts;
   - proof-of-execution challenge protocols;
2. limitation-by-limitation claim charts against:
   - US-11119902-B2;
   - US-11409641-B1;
   - US-11010285-B2;
   - US-6986125-B2;
   - US-7539978-B1;
   - US-8826201-B1;
   - US-9177089-B2;
   - US-10887104-B1;
3. prosecution-history review of the active families most relevant to:
   - mutation testing;
   - combinatorial fault localization;
   - cryptographically secured testing;
   - formal verification coverage;
4. non-patent literature review concerning:
   - group testing;
   - superimposed codes;
   - separating systems;
   - locating arrays;
   - mutation analysis;
   - causal testing;
   - metamorphic testing;
   - challenge-response protocols;
   - Fiat–Shamir-style challenge derivation;
   - Merkle and vector commitments;
5. jurisdiction-specific subject-matter analysis;
6. jurisdiction-specific FTO analysis;
7. review of Glyphser's exact challenge-transform implementation;
8. review of the public-disclosure history of the Glyphser repository;
9. inventorship analysis.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
