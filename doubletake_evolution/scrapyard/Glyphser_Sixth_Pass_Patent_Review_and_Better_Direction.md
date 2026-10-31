# Glyphser Patent Direction
## Sixth-Pass Conflict Review, Risk Scores, and Replacement Architecture

**Review date:** July 17, 2026  
**Direction examined:** *Counterbalanced Nondeterminism Transposition with Port-Bijection Certificates*  
**Replacement direction:** *Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities*

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not a legal opinion, patentability opinion, validity opinion, or freedom-to-operate opinion. A qualified patent attorney should review the cited claims, prosecution histories, continuations, national status, ownership, and the final implementation in each intended jurisdiction.

---

# 1. Score definitions

All scores use a **0–10 scale**.

| Category | Meaning of a higher score |
|---|---|
| Novelty risk | Worse: greater likelihood that one reference anticipates the proposed claim |
| Obviousness risk | Worse: greater likelihood that an examiner can combine known references |
| Subject-matter/technicality risk | Worse: greater risk of being considered abstract, administrative, or insufficiently technical |
| Freedom-to-operate risk | Worse: greater likelihood that implementation may practice active third-party claims |
| Ease of enforcing the patent | Better: easier to detect, claim-chart, and prove infringement |
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while retaining similar product value |

The scores are comparative engineering judgments, not probabilities.

---

# 2. Executive conclusion

The direction from the previous Markdown file should **not** remain the principal Glyphser patent nucleus.

The examined direction proposed:

- stable semantic nondeterminism ports;
- authenticated capsules containing recorded random values, clock values, scheduler choices, external inputs, backend choices, device selections, and asynchronous completion orders;
- replay of capsule A into programs A and B;
- replay of capsule B into programs A and B;
- a one-to-one port-consumption certificate;
- a four-cell counterbalanced execution matrix;
- classification of divergence as program-dependent, capsule-dependent, interaction-dependent, equivalent, invalid, or unsupported.

The new search found substantially closer prior art than the prior pass reflected.

Most importantly:

1. **US-9703693-B1 records production incoming messages, outgoing messages, timing data, random-number behavior, and clock behavior, then plays the production inputs into a modified software version and validates the modified execution.**
2. **US-7840940-B2 expressly claims semantic management of nondeterministic operations during logging or replay through an external software agent.**
3. **US-20230032237-A1 claims deterministic replay of recorded events among software entities.**
4. **US-12455800-B2 captures event sequences in one computing environment, constructs a workload from them, executes that workload in a second environment, and compares the resulting event sequences.**
5. **US-8402318-B2 and related families cover recording and replaying nondeterministic application events.**
6. **US-20070083645-A1 logs asynchronous events together with execution locations and replays those events.**
7. **US-20180300228-A1 replays captured traffic against software to identify interface changes.**
8. **US-12112162-B2 maps intermediate-representation objects between program versions, weakening the claimed distinction of stable cross-version semantic mappings.**
9. **Microsoft and other families already compare multiple replayable execution traces, compare code versions using generated inputs, and perform root-cause analysis across plural executions.**
10. **The four-cell matrix is likely to be treated as an experimental-design arrangement applied to known record/replay and differential-testing techniques.**

No single examined patent appears to claim the exact complete combination of two native capsules, reciprocal transposition, port-bijection proof, and a fixed source-classification algebra. Nevertheless, the prior-art combination is strong enough that the direction now carries high obviousness and freedom-to-operate risk.

## Replacement decision

Retire this as the principal direction:

> **Counterbalanced Nondeterminism Transposition with Port-Bijection Certificates**

Retain semantic nondeterminism identifiers and capsule recording only as optional embodiments.

Proceed instead with:

# **Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities**

Suggested protocol name:

## **Glyphser Nondeterminism Closure Gate — GNCG**

The new direction does **not** replay nondeterministic values and does not attempt to attribute an observed divergence through a multi-run matrix.

It solves a more fundamental verification problem:

> How can a completed execution provide machine-verifiable evidence that every nondeterministic influence entered through an authorized, typed semantic interface and that no direct, hidden, or unmediated nondeterministic access occurred?

The system places a privileged gate in front of low-level nondeterministic sources. An application can obtain a clock value, random value, external response, scheduling choice, device selection, backend choice, or asynchronous completion result only by first obtaining a **single-use mediation capability** from a declared semantic nondeterminism port.

The capability binds:

- the execution identity;
- semantic port identity;
- occurrence identity;
- authorized low-level source class;
- broker identity;
- sequence or freshness value;
- value-use restrictions.

The operating-system, hypervisor, runtime, or other lower-layer gate refuses the nondeterministic operation unless a valid unconsumed capability is presented. The lower layer consumes the capability and records the actual source access. The semantic broker separately records the port request and returned value.

A closure certificate is valid only when:

- no low-level nondeterministic source was accessed without a capability;
- every issued capability was consumed at most once;
- every successful low-level source access was associated with one declared semantic port;
- every mandatory broker response has a corresponding lower-layer consumption;
- unsupported source classes and monitoring gaps are absent.

The searches performed did **not** identify a single patent claiming the complete combination of:

- fail-closed low-level nondeterminism access;
- semantic-port-issued single-use capabilities;
- lower-layer consumption of those capabilities;
- separate semantic and source ledgers;
- cross-layer closure verification;
- a portable certificate that the execution used no unmediated nondeterminism.

---

# 3. Scores

## 3.1 Direction examined

### Counterbalanced Nondeterminism Transposition with Port-Bijection Certificates

| Category | Score |
|---|---:|
| **Novelty risk** | **6.5/10** |
| **Obviousness risk** | **8.5/10** |
| **Subject-matter/technicality risk** | **2.0/10** |
| **Freedom-to-operate risk** | **7.5/10** |
| **Ease of enforcing the patent** | **6.5/10** |
| **Ease for competitors to design around** | **7.0/10** |

## 3.2 Replacement direction

### Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities

| Category | Score |
|---|---:|
| **Novelty risk** | **3.5/10** |
| **Obviousness risk** | **5.5/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **5.0/10** |
| **Ease of enforcing the patent** | **8.0/10** |
| **Ease for competitors to design around** | **5.0/10** |

## 3.3 Comparative assessment

| Category | Transposition direction | Closure-gate direction | Change |
|---|---:|---:|---:|
| Novelty risk | 6.5 | 3.5 | **3.0 lower** |
| Obviousness risk | 8.5 | 5.5 | **3.0 lower** |
| Subject-matter/technicality risk | 2.0 | 1.5 | **0.5 lower** |
| Freedom-to-operate risk | 7.5 | 5.0 | **2.5 lower** |
| Ease of enforcing | 6.5 | 8.0 | **1.5 better** |
| Ease of design-around | 7.0 | 5.0 | **2.0 harder for competitors** |

The replacement remains exposed to known sandboxing, syscall interception, nondeterministic-value services, record/replay, and execution-attestation patents. Its improved position comes from making the inventive centre the **single-use cross-layer authorization of each nondeterministic source access and the resulting closure proof**, rather than replay itself.

---

# 4. Direction examined

## Counterbalanced Nondeterminism Transposition with Port-Bijection Certificates

The previous direction used this architecture:

```text
native execution A
    → capsule A

native execution B
    → capsule B

program A + capsule A → E_AA
program A + capsule B → E_AB
program B + capsule A → E_BA
program B + capsule B → E_BB

port-bijection validation
    ↓
program-axis and capsule-axis relations
    ↓
program, capsule, interaction, or equivalence classification
```

Its intended distinguishing features were:

1. values captured through stable semantic nondeterminism ports;
2. occurrence identifiers independent of instruction positions;
3. observed capsules rather than generated synthetic inputs;
4. cross-version mapping of port occurrences;
5. exactly-once consumption of transposed values;
6. a counterbalanced two-program by two-capsule execution matrix;
7. source attribution without full instruction-trace differencing.

The new search shows that the record/replay and cross-version testing portions are highly crowded.

---

# 5. Additional patents conflicting with the transposition direction

## 5.1 Production-event replay into a modified application

### US-9703693-B1  
**Regression Testing System for Software Applications**

### Relevant claimed mechanism

The claims describe a system containing:

- a random-number generator;
- a system clock;
- a recorder module operating during production execution;
- stored production incoming messages from external components;
- stored production outgoing messages;
- timing data associated with messages and events;
- playback of the production incoming messages to a modified version of the software application;
- receipt and validation of test outputs;
- reproduction or control of production timing, random behavior, and event registration.

### Conflict

This patent is a direct challenge to the previous direction.

The transposition design proposed recording:

- external input;
- timing;
- random values;
- completion order;
- other nondeterministic values;

and supplying those recorded values to another program version.

The use of semantic port identifiers and a four-run matrix remains different, but the core cross-version replay operation is already claimed.

### Effect

- High novelty pressure on broad capsule-replay claims.
- Strong obviousness reference for applying recorded nondeterminism to a modified program.
- Material FTO risk if Glyphser captures production inputs, timing, random behavior, and replays them into a modified version.

---

## 5.2 Semantic management of nondeterministic operations

### US-7840940-B2  
**Semantic Management Method for Logging or Replaying Non-Deterministic Operations Within the Execution of an Application Process**

### Relevant claimed mechanism

The patent addresses:

- an operation within an application process;
- a result containing an intrinsically nondeterministic phase;
- an external management software agent;
- intervention in computer software operation;
- logging or replay;
- provision of a result datum reproducible unambiguously from reproducible resources.

### Conflict

This patent directly weakens the notion that semantic mediation of nondeterministic operations is new.

The prior Glyphser direction used:

- semantic nondeterminism ports;
- managed values;
- recorded values;
- replay into another execution.

The replacement direction must therefore avoid claiming generic semantic nondeterminism management or replay as the invention.

---

## 5.3 Deterministic replay between software entities

### US-20230032237-A1 and family  
**Deterministic Replay of Events Between Software Entities**

### Relevant claimed mechanism

The claims cover:

- deterministic replay of a recording of events between software entities;
- representation of entities as graph nodes and events as graph edges;
- playing recorded events;
- queuing software entities stimulated by the events;
- executing queued software entities;
- processing events produced during replay.

### Conflict

The prior architecture replayed recorded nondeterministic events through software versions and classified the resulting behavior.

Graph representation is not required by Glyphser, but deterministic event replay among software entities is established.

---

## 5.4 Captured event sequences across environments

### US-12455800-B2 and family  
**Dynamic Testing with Captured Sequences of Events**

### Relevant claimed mechanism

The claims include:

- generating event sequences by executing test paths in a first environment;
- constructing a test workload from the first event sequences;
- executing the workload in a second environment;
- generating second event sequences;
- identifying variances by comparing first and second sequences;
- reconfiguring the second environment based on the variances.

### Conflict

The prior Glyphser design captured one execution's events and used them as controlled input to another execution environment or version.

The proposed fixed four-cell matrix is a difference, but the cross-environment event-transfer concept is known.

---

## 5.5 Application record and replay

### US-8402318-B2 and family  
**Systems and Methods for Recording and Replaying Application Execution**

### Relevant area

The family covers:

- recording application events;
- recording nondeterministic events;
- replaying those events;
- reproducing application execution.

### Conflict

Generic capsule capture and replay cannot support a broad Glyphser claim.

---

## 5.6 Logging and replaying asynchronous events

### US-20070083645-A1  
**System and Method for Logging and Replaying Asynchronous Events**

### Relevant claimed mechanism

The claims include:

- logging asynchronous events from a first program execution;
- determining an execution location associated with each event;
- replaying the event during a later execution at the corresponding location.

### Conflict

The prior direction attempted to distinguish itself through semantic occurrence identifiers rather than instruction addresses. That remains a difference, but asynchronous-event capture and replay are well established.

---

## 5.7 Traffic replay against changed interfaces

### US-20180300228-A1  
**Traffic Replay to Detect Interface Changes**

### Relevant mechanism

The family replays previously recorded activity or traffic against software modules and uses identifiers to map replayed activity and intercepted calls.

### Conflict

This weakens claims involving:

- recorded external events;
- playback into a changed software implementation;
- mapping replay requests to corresponding prior events;
- detecting version-related differences.

---

## 5.8 Cross-version object mapping

### US-12112162-B2  
**Method and System for Mapping Intermediate Representation Objects for Facilitating Incremental Analysis**

### Relevant claimed mechanism

The patent maps intermediate-representation objects between current and previous program versions despite changed identifiers, so prior analysis information can be reused.

### Conflict

The previous direction relied on stable semantic port identities and mappings across program versions.

Although nondeterminism ports are different from IR objects, cross-version semantic mapping is not itself a safe inventive centre.

---

## 5.9 Generated inputs for comparing code versions

### US-20200301815-A1 and family  
**Using Synthetic Inputs to Compare Execution of Different Code Versions**

### Relevant mechanism

The family compares two program versions by:

- examining prior recorded executions;
- identifying uncovered code paths;
- generating inputs;
- executing versions;
- evaluating equivalence.

### Conflict

Glyphser used observed rather than synthetic nondeterminism capsules. That distinction is useful but likely insufficient to make the broad concept of controlled cross-version execution non-obvious.

---

## 5.10 Multiple replayable execution traces

### US-11237947-B2  
### US-11698848-B2  
### EP-4091058-B1  
**Diffing Replayable Execution Traces**

### Relevant mechanism

These families cover:

- subject and comparison replayable traces;
- mappings among trace sections;
- comparison of multiple executions;
- identification of differences.

### Conflict

The prior direction avoided full-trace diffing, but its four-result matrix remains a plural-execution comparison structure. These patents contribute to an obviousness combination.

---

## 5.11 Root cause analysis of nondeterministic tests

### US-20180300229-A1 and related family  
**Root Cause Analysis of Non-Deterministic Tests**

### Relevant mechanism

The claims include:

- detecting a nondeterministic test;
- rerunning it;
- capturing application, test, and environment data;
- comparing passed and failed reruns;
- determining a root cause.

### Conflict

The previous matrix classified divergence as program-dependent, environment-dependent, or interaction-dependent.

That classification is close to established nondeterministic-test root-cause analysis, even though the specific matrix algebra is different.

---

## 5.12 Hidden-input reconstruction

### US-11093371-B1  
**Hidden Input Detection and Re-Creation of System Environment**

### Relevant mechanism

The patent captures environmental data, identifies hidden inputs, and recreates a first system's environment during execution on another system.

### Conflict

The prior design did not infer hidden inputs, but it transferred environment-derived nondeterministic values between executions. The family increases FTO risk for implementations that discover or reconstruct hidden environmental inputs.

---

## 5.13 Recent verification program

### JP-7776732-B2  
**Verification Program, Verification Method, and Information Processing Device**  
**Publication date:** November 27, 2025

### Relevant area

The claims instrument program executions, record values in different execution environments, and compare or verify the resulting behavior.

### Conflict

This recent family should receive a detailed jurisdiction-specific review before any filing based on cross-environment value recording and verification.

---

# 6. Reassessment of the transposition direction

## 6.1 Novelty risk — 6.5/10

No single examined reference appears to contain every proposed limitation.

However, US-9703693-B1 is particularly close because it:

- records external production inputs;
- records timing;
- accounts for random-number and clock behavior;
- replays the production behavior into a modified application;
- validates the resulting execution.

US-7840940-B2 adds semantic management of nondeterministic operations.

A broad independent claim would therefore need to depend heavily on the exact four-cell matrix and port-bijection certificate.

---

## 6.2 Obviousness risk — 8.5/10

A plausible examiner combination is:

1. US-9703693-B1 for replaying production nondeterminism into a modified version;
2. US-7840940-B2 for semantic mediation of nondeterministic operations;
3. US-12112162-B2 for cross-version semantic mapping;
4. plural-run debugging or root-cause patents for multi-execution comparison;
5. ordinary two-factor experimental design for the four-cell matrix;
6. cryptographic evidence commitments for portable certification.

Each known element would continue performing its ordinary function.

The four-run matrix may therefore be characterized as a predictable arrangement rather than an inventive technical mechanism.

---

## 6.3 Subject-matter/technicality risk — 2.0/10

The direction is technically grounded because it:

- intercepts nondeterministic operations;
- changes values supplied during execution;
- controls program behavior;
- performs replay;
- validates event consumption.

Its primary weakness is prior art, not subject-matter eligibility.

---

## 6.4 Freedom-to-operate risk — 7.5/10

Implementation may practice active claims involving:

- production-message capture;
- timing capture;
- random-number reproduction;
- playback into modified software;
- semantic management of nondeterministic operations;
- deterministic event replay;
- captured event sequences across environments;
- VM or application replay;
- plural replay-trace analysis.

This risk remains even if the final matrix classifier is novel.

---

## 6.5 Ease of enforcing — 6.5/10

The following artifacts could be visible:

- port catalog;
- capsule root;
- port mapping;
- cross-run identifiers;
- four result roots;
- source classification.

However, important limitations may be internal:

- whether the capsules were observed rather than generated;
- whether every source occurrence was consumed once;
- whether the program executed all four matrix cells;
- whether the product uses a fixed matrix rather than an adaptive set of reruns.

---

## 6.6 Ease for competitors to design around — 7.0/10

A competitor can preserve most of the diagnostic value while avoiding the claims by:

- replaying only one event history into both versions;
- using many statistical reruns instead of four fixed runs;
- comparing complete traces;
- reconstructing one environment;
- using synthetic event sequences;
- omitting a formal bijection;
- classifying causes through machine learning;
- comparing program versions one at a time.

The direction therefore has substantial design-around exposure.

---

# 7. Replacement direction

# Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities

## 7.1 Technical problem

A reproducibility harness may record known random seeds, configuration files, inputs, and environment variables while still missing nondeterministic influences such as:

- direct high-resolution clock instructions;
- unwrapped random-number generators;
- hidden operating-system entropy sources;
- scheduling decisions;
- thread wake-up order;
- device or kernel selection;
- asynchronous completion order;
- external network responses;
- file-system enumeration order;
- hardware counters;
- locale or timezone queries;
- backend-selected algorithms;
- process identifiers;
- temporary-file naming;
- dynamic library behavior;
- accelerator runtime decisions.

A manifest can prove what was recorded.

It does not prove that **nothing else influenced the execution**.

Record/replay systems typically capture enough information to reproduce a run. They do not necessarily produce a portable, fail-closed proof that every nondeterministic access was authorized through a declared semantic interface.

The replacement direction makes uncontrolled nondeterminism inaccessible rather than merely trying to discover it afterward.

---

# 8. Core architecture

## 8.1 Nondeterminism source classes

The system maintains a versioned catalog of low-level source classes:

```text
nondeterminism_source_catalog:
    source_catalog_version

    sources:
        - source_class_id
          access_primitive
          lower_layer
          value_schema
          mediation_required
          enforcement_mode
          monitoring_mode

    source_catalog_root
```

Example source classes:

```text
clock.wall
clock.monotonic
clock.high_resolution
random.os_entropy
random.hardware
scheduler.thread_selection
scheduler.wakeup_order
network.receive
network.response
filesystem.enumeration_order
device.selection
kernel.algorithm_selection
accelerator.completion_order
backend.algorithm_selection
process.identifier
temporary_name
locale.query
hardware.counter
```

The principal claim should not require this exact list.

---

## 8.2 Semantic nondeterminism ports

The application or workload declares typed semantic ports:

```text
semantic_nondeterminism_port:
    port_id
    port_version
    permitted_source_class_set
    value_schema
    occurrence_rule
    value_use_scope
    producer_code_hash
    port_contract_hash
```

Examples:

```text
glyphser.nd.random.model_initialization
glyphser.nd.random.dropout.layer_04
glyphser.nd.time.training_start
glyphser.nd.external.dataset_shard_order
glyphser.nd.backend.matmul_implementation
glyphser.nd.scheduler.worker_completion
```

A port identifies why a nondeterministic value is needed.

A source class identifies where the value physically or logically originates.

---

## 8.3 Privileged nondeterminism broker

The broker receives a semantic request:

```text
semantic_request:
    execution_id
    port_id
    occurrence_id
    requested_value_schema
    request_context_digest
```

The broker validates:

- the port exists;
- the occurrence is permitted;
- the requested source class is authorized;
- the caller is the correct execution subject;
- the port contract permits the requested operation.

The broker does not directly fabricate a generic result unless the port contract permits a deterministic synthetic source.

For an actual nondeterministic source, it issues a single-use mediation capability.

---

## 8.4 Single-use mediation capability

```text
mediation_capability:
    execution_id

    capability_id
    port_id
    occurrence_id

    authorized_source_class_id
    authorized_access_primitive
    value_schema

    broker_code_hash
    port_contract_hash
    source_catalog_root

    issuance_sequence
    expiry_condition
    previous_capability_commitment

    capability_authenticator
```

The capability is:

- scoped to one execution;
- scoped to one semantic port occurrence;
- scoped to one source class or primitive;
- consumable at most once;
- unusable by another process or execution;
- invalid after the permitted operation;
- bound to the broker and contract versions.

A capability may be represented through:

- a message authentication code;
- a digital signature;
- an operating-system capability object;
- a file descriptor or handle;
- a kernel token;
- a hypervisor token;
- a TEE-protected object;
- another unforgeable authorization primitive.

The principal claim should remain primitive-neutral.

---

## 8.5 Lower-layer nondeterminism gate

The gate exists at a layer capable of controlling the actual source access, such as:

- kernel;
- hypervisor;
- runtime;
- language VM;
- system-call interposition layer;
- device-runtime shim;
- accelerator-runtime shim.

For a protected source operation:

```text
application attempts nondeterministic source access
        ↓
gate requires mediation capability
        ↓
capability validation
        ↓
capability atomically marked consumed
        ↓
source operation performed
        ↓
value and source receipt returned
```

Without a valid capability, the gate performs one of:

```text
DENY
TRAP
TERMINATE_EXECUTION
MARK_EXECUTION_INVALID
```

The principal claim should require fail-closed behavior.

Logging a bypass without invalidating the execution should not be sufficient.

---

## 8.6 Source-consumption receipt

The lower-layer gate generates:

```text
source_consumption_receipt:
    execution_id
    capability_id

    source_class_id
    access_primitive_id

    source_sequence
    value_commitment
    lower_layer_monitor_id

    consumption_state
    receipt_authenticator
```

Possible states:

- `CONSUMED_SUCCESSFULLY`
- `DENIED_NO_CAPABILITY`
- `DENIED_INVALID_CAPABILITY`
- `DENIED_ALREADY_CONSUMED`
- `DENIED_WRONG_SOURCE_CLASS`
- `DENIED_WRONG_EXECUTION`
- `MONITOR_FAILURE`

The receipt is returned to the broker and committed in the lower-layer source ledger.

---

## 8.7 Semantic-port receipt

The broker generates:

```text
semantic_port_receipt:
    execution_id
    capability_id

    port_id
    occurrence_id
    port_contract_hash

    source_consumption_receipt_hash
    returned_value_commitment

    semantic_sequence
    delivery_state
    broker_authenticator
```

The broker does not issue a successful semantic receipt until it receives a valid lower-layer source-consumption receipt.

---

## 8.8 Dual ledgers

### Source ledger

The lower layer commits to:

```text
source_ledger:
    execution_id
    source_catalog_root

    successful_source_receipts
    denied_access_receipts
    monitor_state_events

    source_ledger_root
```

### Semantic ledger

The broker commits to:

```text
semantic_ledger:
    execution_id
    port_catalog_root

    issued_capabilities
    semantic_port_receipts
    undelivered_values
    cancelled_capabilities

    semantic_ledger_root
```

The ledgers are independently generated by different enforcement components.

This prevents the application-level broker from silently omitting a low-level access and prevents the lower layer from inventing a semantic justification after the fact.

---

## 8.9 Closure verifier

The closure verifier checks:

1. every successful protected source access has a valid capability;
2. the capability belongs to the same execution;
3. the capability's port authorizes the source class;
4. the capability was consumed once;
5. the source receipt is referenced by one successful semantic receipt;
6. the semantic receipt returns the same value commitment;
7. no capability is used for multiple source accesses;
8. no successful source access lacks a semantic port;
9. no mandatory semantic receipt lacks a source receipt;
10. no denied unmediated access occurred;
11. no monitor gap or monitor reset occurred;
12. all required enforcement layers remained active for the claimed execution interval.

The verifier does not need to replay the workload.

---

## 8.10 Nondeterminism closure certificate

```text
nondeterminism_closure_certificate:
    schema_version
    execution_id

    execution_subject_digest
    source_catalog_root
    port_catalog_root

    broker_code_hash
    lower_layer_gate_code_hash
    closure_verifier_code_hash

    source_ledger_root
    semantic_ledger_root

    successful_source_access_count
    successful_semantic_delivery_count
    denied_unmediated_access_count
    duplicate_capability_count
    unmatched_source_receipt_count
    unmatched_semantic_receipt_count
    monitoring_gap_count

    closure_state
    certificate_hash
```

Closure states:

- `CLOSED_COMPLETE`
- `UNMEDIATED_ACCESS_DETECTED`
- `CAPABILITY_REUSE_DETECTED`
- `SOURCE_WITHOUT_SEMANTIC_PORT`
- `SEMANTIC_PORT_WITHOUT_SOURCE`
- `UNSUPPORTED_SOURCE_CLASS`
- `MONITORING_GAP`
- `BROKER_OR_GATE_IDENTITY_MISMATCH`
- `INVALID_EXECUTION_INTERVAL`

Only `CLOSED_COMPLETE` may support a strong reproducibility or equivalence claim.

---

# 9. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising receiving, by a nondeterminism broker, a request associated with a declared semantic nondeterminism port of an executing program; generating a single-use mediation capability bound to an execution identifier, the semantic nondeterminism port, an occurrence identifier, and an authorized low-level nondeterminism source class; intercepting, at an enforcement layer below the executing program, an attempted access to a protected nondeterminism source; refusing the attempted access unless the single-use mediation capability authorizes the protected nondeterminism source; responsive to successful validation of the single-use mediation capability, atomically consuming the capability, obtaining a nondeterministic value from the protected source, and generating a source-consumption receipt; generating, by the nondeterminism broker, a semantic-port receipt that references the source-consumption receipt; and issuing an execution certificate only after verifying that every successful protected-source access during a claimed execution interval is associated with exactly one valid semantic-port receipt and that no unmediated protected-source access or monitoring gap occurred during the claimed execution interval.

The strongest limitations are:

1. semantic request before low-level source access;
2. capability generated for one port occurrence;
3. lower-layer source access requires the capability;
4. fail-closed refusal without the capability;
5. atomic single-use consumption;
6. source receipt from the lower layer;
7. semantic receipt from the broker;
8. cross-layer verification;
9. no successful unmediated access;
10. monitoring continuity over the execution interval;
11. certificate gated by closure verification.

---

# 10. Why the replacement is different from the closest patents

## 10.1 US-7840940-B2 — semantic nondeterministic operation management

That patent manages nondeterministic operations through an external software agent for logging or replay.

The replacement should not claim generic management, logging, or replay.

Its distinguishing interaction is:

- the semantic broker issues an unforgeable one-use capability;
- the lower enforcement layer refuses the source access without that capability;
- the lower layer atomically consumes it;
- the source and semantic layers independently receipt the same event;
- a certificate proves cross-layer closure.

---

## 10.2 US-9703693-B1 — replay into modified software

That patent records production behavior and replays it into modified software.

The replacement does not require:

- a modified program;
- replay;
- production-message playback;
- counterbalanced executions;
- output comparison.

It certifies one execution's nondeterminism closure.

---

## 10.3 US-8402318-B2 and US-10394560-B2 — record and replay

These families record nondeterministic events or instruction outputs for replay.

The replacement may optionally record values, but replay is not required by the principal claim.

The inventive centre is authorization and closure, not reproduction.

---

## 10.4 US-9612942-B2 — intercepting resource access and substituting responses

This patent intercepts access requests, including clock requests, and supplies controlled responses to test software behavior.

The replacement differs by requiring:

- a prior semantic-port request;
- a single-use authorization;
- lower-layer atomic consumption;
- independent source and semantic receipts;
- closure certification across all protected source classes.

Avoid making clock substitution or simulated migration part of the principal claim.

---

## 10.5 US-9521194-B1 — nondeterministic value source

This patent supplies nondeterministic values to computing instances, including high-availability systems.

The replacement should not claim a generic centralized nondeterministic-value service.

The distinguishing feature is that **all low-level source accesses are prohibited without a port-scoped one-time capability and are included in a closure proof**.

---

## 10.6 US-9483637-B2 — integrity markers in system calls

This patent modifies user-space programs so system calls contain integrity marker values passed to the kernel.

A mediation capability could appear similar to an integrity marker.

The principal claim should therefore require:

- semantic port and occurrence binding;
- authorization of a nondeterminism source class;
- atomic single-use consumption;
- value-bearing source receipt;
- semantic receipt;
- closure verification over all protected source accesses.

A generic marker in a syscall is not the invention.

---

## 10.7 US-20250173424-A1 — user-space sandbox interposition

This pending family interposes library calls in a user-space sandbox to enforce policy.

The replacement should not claim generic interposition or policy enforcement.

It requires the specific cross-layer relationship between:

- semantic nondeterminism request;
- one-use source authorization;
- lower-layer consumption;
- dual receipts;
- closure certificate.

Because this application is recent and pending, counsel should review its full prosecution and continuation family.

---

## 10.8 US-10963288-B2 — virtual-machine tracing

This family records deterministic instructions, inputs, and nondeterministic side effects in virtual machines.

The replacement should avoid complete VM instruction tracing.

Its certificate should be based on protected source events and semantic-port receipts, not a full replayable execution trace.

---

## 10.9 US-20170213028-A1 — time-deterministic replay

This family records inputs and timing information and replays execution for timing-channel detection.

The replacement does not require replay or reproduction of precise timing.

Direct clock and timing access is simply capability-gated and included in closure.

---

## 10.10 Generic sandbox and capability systems

Capabilities, syscall mediation, sandboxing, and access-control checks are established.

The application must not claim:

> use a capability to authorize a system call.

The claim must require the complete nondeterminism-specific cross-layer protocol and closure result.

---

# 11. Recommended claim families

## Family A — Single-use nondeterminism mediation capability

Protect:

- execution binding;
- semantic port binding;
- occurrence binding;
- authorized source-class binding;
- single-use consumption;
- source-specific authorization.

## Family B — Fail-closed lower-layer gate

Protect:

- interception of protected nondeterministic access;
- refusal without a valid capability;
- atomic consumption;
- invalidation of execution after bypass or monitor failure.

## Family C — Dual-receipt cross-layer closure

Protect:

- lower-layer source receipt;
- broker semantic receipt;
- shared capability identifier;
- value-commitment correspondence;
- independent ledger roots;
- cross-layer matching.

## Family D — Monitoring-continuity proof

Protect:

- claimed execution interval;
- active enforcement state;
- detection of monitor restart, detachment, bypass, or gap;
- certificate invalidation after a monitoring discontinuity.

## Family E — Source-class completeness

Dependent claims may cover:

- clock sources;
- random sources;
- scheduler sources;
- external network sources;
- filesystem ordering;
- device and backend selection;
- accelerator completion order;
- process and temporary-name sources.

## Family F — Closure-gated execution comparison

Dependent or continuation claims may require:

- both compared executions to have `CLOSED_COMPLETE`;
- rejection of equivalence certification when either execution lacks closure;
- comparison only over evidence generated within the certified intervals.

## Family G — Hardware-assisted mediation

Dependent claims may cover:

- hypervisor enforcement;
- CPU instruction trapping;
- TEE enforcement;
- TPM-backed monitor identity;
- kernel-enforced capabilities;
- device-runtime enforcement.

Do not require hardware in every independent claim.

---

# 12. Residual patent risks for the replacement

## 12.1 Semantic nondeterminism management

US-7840940-B2 is the most important conceptual reference.

### Mitigation

Do not claim replay or generic result management.

Require the fail-closed, single-use, dual-receipt closure interaction.

---

## 12.2 Sandbox and syscall interposition

The field contains many active and pending patents on:

- user-space sandboxes;
- system-call interposition;
- library interposition;
- untrusted code confinement;
- resource access control.

### Mitigation

Keep the principal claim neutral regarding the exact interposition technology.

Claim nondeterminism-specific authorization and closure.

---

## 12.3 Integrity markers and syscall tokens

US-9483637-B2 and related families may be relevant when token information is embedded in system calls.

### Mitigation

A mediation capability should carry the claimed semantic and source restrictions and be consumed exactly once. Avoid relying only on passing a marker to the kernel.

---

## 12.4 Centralized nondeterministic-value services

US-9521194-B1 and related systems provide nondeterministic values to computing instances.

### Mitigation

Do not claim merely receiving random or nondeterministic values from a broker.

Require direct source access to be unavailable without broker authorization.

---

## 12.5 Execution tracing and record/replay

VMware, Microsoft, and other active families cover:

- nondeterministic instruction recording;
- replay buffers;
- VM tracing;
- deterministic replay;
- timing replay.

### Mitigation

The principal claim should not require replay and should avoid full instruction tracing.

---

## 12.6 Cryptographic receipts and ledgers

Generic signed receipts, audit logs, hash chains, and commitment trees are crowded.

### Mitigation

Do not claim the receipt primitive itself.

The claim should focus on the causal sequence:

```text
semantic request
    → one-use capability
    → lower-layer authorization and consumption
    → source receipt
    → semantic receipt
    → closure certificate
```

---

# 13. Replacement-direction risk analysis

## 13.1 Novelty risk — 3.5/10

The search found the individual components:

- semantic handling of nondeterministic operations;
- syscall and library interposition;
- sandboxes;
- capability-like access controls;
- integrity markers;
- nondeterministic value services;
- execution tracing;
- signed or authenticated records.

It did not identify one reference claiming the entire sequence of:

- semantic-port request;
- port-scoped one-use source capability;
- lower-layer fail-closed enforcement;
- atomic capability consumption;
- source receipt;
- broker semantic receipt;
- cross-layer closure certificate;
- monitoring-continuity requirement.

Novelty risk remains because differently worded capability and attestation patents may be missed by semantic searching.

---

## 13.2 Obviousness risk — 5.5/10

An examiner could combine:

1. US-7840940-B2 for semantic nondeterminism management;
2. sandbox or syscall-interposition patents for enforcement;
3. capability access control for source authorization;
4. US-9483637-B2 for passing integrity information with system calls;
5. audit or attestation patents for receipts and a certificate.

The principal inventive-step argument must therefore emphasize the technical effect of the full closed loop:

- a high-level port request is the only means of authorizing a low-level source access;
- the capability is one-time and source-specific;
- the lower-layer source event and high-level semantic delivery are independently evidenced;
- an execution cannot obtain a strong verification status if either side is unmatched or monitoring was interrupted.

---

## 13.3 Subject-matter/technicality risk — 1.5/10

The direction is strongly technical because it changes computer operation:

- direct source accesses are trapped;
- capabilities are generated and consumed;
- system calls, instructions, runtime operations, or device operations are denied;
- two enforcement layers generate authenticated state;
- execution is invalidated on bypass;
- a certificate represents an enforced execution property.

The specification should avoid framing the invention as merely “documenting reproducibility.”

---

## 13.4 Freedom-to-operate risk — 5.0/10

FTO risk is material but lower than the replay-matrix direction.

The principal risks are:

- semantic nondeterminism management;
- user-space sandboxing;
- syscall interposition;
- integrity-marker system calls;
- nondeterministic-value services;
- VM nondeterministic-instruction trapping;
- the selected capability implementation.

Risk can be reduced by:

- not implementing replay in the principal feature;
- avoiding full VM tracing;
- using implementation alternatives;
- keeping exact token transport primitive-neutral;
- reviewing active claims before selecting kernel, hypervisor, or user-space enforcement.

---

## 13.5 Ease of enforcing — 8.0/10

A product implementing the claimed guarantee would likely expose:

- declared port catalog;
- protected source catalog;
- broker identity;
- gate identity;
- capability identifiers;
- source receipt root;
- semantic receipt root;
- unmediated-access count;
- monitoring-gap count;
- closure state.

A competitor marketing a certificate that proves all nondeterminism was mediated would provide strong public evidence.

Technical testing can also attempt direct clock, random, network, and device accesses to determine whether the product traps or denies them.

---

## 13.6 Ease for competitors to design around — 5.0/10

Competitors can avoid the claims by:

- relying on static analysis alone;
- using complete VM replay;
- using a deterministic operating system;
- recording source accesses without semantic ports;
- trusting a single monitor;
- omitting one-use capabilities;
- permitting direct access and merely logging it;
- producing no portable closure certificate.

However, these alternatives weaken the specific guarantee:

> every successful nondeterministic source access was authorized in advance by exactly one declared semantic need and independently accounted for at both layers.

A coordinated set of independent claims can make design-around harder.

---

# 14. Technical evidence needed before filing

## 14.1 Direct-access rejection

Demonstrate that an execution cannot directly access:

- wall clock;
- monotonic clock;
- high-resolution counter;
- operating-system entropy;
- hardware RNG;
- network receive;
- filesystem enumeration;
- device selection;
- backend algorithm selection;
- accelerator completion order;

without a valid mediation capability.

---

## 14.2 Capability misuse rejection

Test:

- capability replay;
- capability use by another process;
- capability use by another execution;
- capability use at another port;
- capability use for another source class;
- capability use after cancellation;
- capability use after monitor restart;
- duplicate consumption;
- changed capability contents.

---

## 14.3 Cross-layer mismatch detection

Create cases with:

- source receipt but no semantic receipt;
- semantic receipt but no source receipt;
- different value commitments;
- different execution IDs;
- different port IDs;
- different capability IDs;
- monitor gap;
- broker restart;
- source-gate restart;
- forged broker receipt;
- forged source receipt.

The verifier must refuse `CLOSED_COMPLETE`.

---

## 14.4 Hidden nondeterminism tests

Introduce deliberately unwrapped sources into test workloads.

Examples:

- direct CPU timestamp instruction;
- direct operating-system random syscall;
- library call bypassing the broker;
- device API call from native extension;
- dynamically loaded library reading time;
- subprocess obtaining entropy;
- accelerator runtime selecting an algorithm;
- thread scheduler influence outside declared ports.

The execution should fail closed or become uncertifiable.

---

## 14.5 Performance measurements

Measure:

- capability issuance latency;
- gate validation latency;
- source operation overhead;
- receipt size;
- ledger storage;
- certificate verification time;
- workload slowdown;
- overhead by source class;
- comparison with full trace capture.

---

## 14.6 Independent implementation

Build independent implementations of:

- broker;
- lower-layer gate;
- closure verifier.

Verify identical closure outcomes and certificate hashes from the same ledgers.

---

# 15. Glyphser implementation path

## 15.1 New schemas

```text
nondeterminism_source_catalog.v1
semantic_nondeterminism_port_catalog.v1
mediation_capability.v1
source_consumption_receipt.v1
semantic_port_receipt.v1
nondeterminism_source_ledger.v1
nondeterminism_semantic_ledger.v1
nondeterminism_closure_certificate.v1
```

## 15.2 Suggested modules

```text
runtime/glyphser/nondeterminism/source_catalog.py
runtime/glyphser/nondeterminism/port_catalog.py
runtime/glyphser/nondeterminism/broker.py
runtime/glyphser/nondeterminism/capability.py
runtime/glyphser/nondeterminism/source_gate.py
runtime/glyphser/nondeterminism/source_receipt.py
runtime/glyphser/nondeterminism/semantic_receipt.py
runtime/glyphser/nondeterminism/closure.py
runtime/glyphser/nondeterminism/certificate.py
```

## 15.3 Suggested quality gates

```text
tooling/quality_gates/no_unmediated_nondeterminism_gate.py
tooling/quality_gates/single_use_capability_gate.py
tooling/quality_gates/source_semantic_receipt_match_gate.py
tooling/quality_gates/monitor_continuity_gate.py
tooling/quality_gates/nondeterminism_closure_gate.py
```

## 15.4 Required adversarial fixtures

```text
direct_clock_access
direct_hardware_counter_access
direct_os_entropy_access
native_extension_random_access
subprocess_network_access
filesystem_order_bypass
device_selection_bypass
backend_algorithm_bypass
capability_reuse
wrong_execution_capability
wrong_port_capability
wrong_source_class_capability
source_receipt_without_semantic_receipt
semantic_receipt_without_source_receipt
value_commitment_mismatch
broker_restart_gap
source_gate_restart_gap
monitor_detachment
forged_source_receipt
forged_semantic_receipt
```

---

# 16. Features to exclude from the principal claim

Do not make these essential:

- replay of nondeterministic values;
- counterbalanced four-run matrices;
- full instruction traces;
- VM snapshots;
- checkpoint replay;
- synthetic inputs;
- trace differencing;
- root-cause ranking;
- hidden-input inference;
- complete environment reconstruction;
- one particular sandbox;
- one particular system-call interface;
- one particular capability representation;
- one particular hash or signature;
- blockchain;
- Merkle trees;
- TPM or TEE;
- one specific operating system;
- one specific ML framework.

They may appear as optional embodiments or dependent claims.

---

# 17. Filing strategy

## Principal independent method claim

Require:

- semantic port request;
- one-use mediation capability;
- source-class authorization;
- lower-layer interception;
- fail-closed denial;
- atomic capability consumption;
- source receipt;
- semantic receipt;
- closure verification;
- monitoring continuity.

## Principal system claim

Claim components such as:

- semantic nondeterminism broker;
- lower-layer nondeterminism gate;
- capability generator;
- source ledger;
- semantic ledger;
- closure verifier;
- certificate generator.

## Computer-readable-medium claim

Mirror the method while avoiding unnecessary operating-system limitations.

## Separate independent claims

Consider separate independent claims for:

1. capability issuance and lower-layer consumption;
2. dual-receipt closure verification;
3. monitoring-continuity certification;
4. closure-gated execution comparison;
5. hardware-assisted source gating.

## Specification breadth

Disclose alternatives for:

- kernel, hypervisor, language runtime, and device-runtime enforcement;
- token form;
- receipt authentication;
- source catalogs;
- semantic port schemas;
- local and remote workloads;
- CPU and accelerator execution;
- exact and tolerant execution comparison.

---

# 18. Final recommendation

The prior nondeterminism-transposition direction is no longer the strongest filing candidate because its core operations can be assembled from active and published patent families covering:

- production-input replay into modified software;
- semantic management of nondeterministic operations;
- deterministic event replay;
- event-sequence testing across environments;
- record/replay;
- cross-version mapping;
- plural-execution debugging and root-cause analysis.

Replace it with:

> **A fail-closed execution architecture in which a declared semantic nondeterminism port issues a single-use capability authorizing one specified low-level nondeterministic source access; a lower enforcement layer refuses the access without the capability, atomically consumes the capability when the source is used, and generates a source receipt; a semantic broker generates a corresponding port receipt; and an execution certificate is issued only when every successful protected-source access is matched across both layers and no unmediated access or monitoring gap occurred.**

This direction is better because it:

- removes replay from the inventive centre;
- avoids the four-run matrix and experimental-design obviousness problem;
- solves a more fundamental reproducibility problem;
- makes hidden nondeterminism fail closed rather than merely observable;
- produces a strong computer-operation improvement;
- creates externally inspectable certificate artifacts;
- provides practical infringement-testing opportunities;
- reduces dependence on full execution traces;
- was not matched by one patent containing the complete single-use capability and cross-layer closure interaction in the searches performed.

---

# 19. Principal references reviewed in this pass

## Direct conflicts with the transposition direction

- US-9703693-B1 — *Regression Testing System for Software Applications*
- US-7840940-B2 — *Semantic Management Method for Logging or Replaying Non-Deterministic Operations*
- US-20230032237-A1 — *Deterministic Replay of Events Between Software Entities*
- US-12455800-B2 — *Dynamic Testing with Captured Sequences of Events*
- US-8402318-B2 — *Systems and Methods for Recording and Replaying Application Execution*
- US-20070083645-A1 — *System and Method for Logging and Replaying Asynchronous Events*
- US-20180300228-A1 — *Traffic Replay to Detect Interface Changes*
- US-12112162-B2 — *Mapping Intermediate Representation Objects for Facilitating Incremental Analysis*
- US-20200301815-A1 — *Using Synthetic Inputs to Compare Execution of Different Code Versions*
- US-11237947-B2 — *Diffing a Plurality of Subject Replayable Execution Traces*
- US-11698848-B2 — *Diffing a Subject Replayable Execution Trace Against Comparison Traces*
- EP-4091058-B1 — *Diffing Plural Replayable Execution Traces*
- US-20180300229-A1 — *Root Cause Analysis of Non-Deterministic Tests*
- US-11093371-B1 — *Hidden Input Detection and Re-Creation of System Environment*
- JP-7776732-B2 — *Verification Program, Verification Method, and Information Processing Device*

## Closest references to the replacement direction

- US-7840940-B2 — *Semantic Management Method for Logging or Replaying Non-Deterministic Operations*
- US-9612942-B2 — *Verification of a Computer Program in Respect to an Unexpected Response to an Access Request*
- US-9521194-B1 — *Nondeterministic Value Source*
- US-9483637-B2 — *Program Execution Integrity Verification for a Computer System*
- US-20250173424-A1 — *System and Method to Enforce Policy Using a User-Space Sandbox*
- US-10963288-B2 — *Virtual Machine Execution Tracing*
- US-20170213028-A1 — *Detecting Covert Timing Channels Using Time-Deterministic Replay*
- US-10394560-B2 — *Efficient Recording and Replaying of Non-Deterministic Instructions in a Virtual Machine*
- US-10592662-B1 — *Systems and Methods for Altering Time Data*
- US-6275938-B1 — *Security Enhancement for Untrusted Executable Code*
- US-20160196426-A1 — *Ultra-Low Cost Sandboxing for Application Appliances*
- US-20030192037-A1 — *Statically Detecting Externally Referenced Interfaces of a Program*
- US-20150007266-A1 — *Program Execution Integrity Verification for a Computer System*
- US-11989291-B2 — *System, Method, and Apparatus for Software Verification*

---

# 20. Required legal follow-up

Before filing or implementation, counsel should perform:

1. limitation-by-limitation claim charts against the references above;
2. prosecution-history review for US-7840940-B2, US-9483637-B2, US-9703693-B1, US-20250173424-A1, US-10963288-B2, and related continuations;
3. jurisdiction-specific FTO review;
4. review of the exact kernel, hypervisor, runtime, or sandbox mechanism selected;
5. review of capability-system patents relevant to the selected token implementation;
6. review of Glyphser's public repository history and prior disclosures;
7. inventorship analysis;
8. non-patent literature search on deterministic execution, syscall mediation, capability systems, reproducible builds, record/replay, and nondeterminism control.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
