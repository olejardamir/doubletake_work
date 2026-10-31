# Glyphser Patent Direction
## Seventh-Pass Conflict Review, Risk Scores, and Replacement Architecture

**Review date:** July 17, 2026  
**Direction examined:** *Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities*  
**Replacement direction:** *Certified Source-Closed Executables with Reachability-Bound Nondeterminism Elimination*

> **Scope and limitation:** This is an engineering-oriented patent search and architecture assessment. It is not a legal opinion, patentability opinion, validity opinion, or freedom-to-operate opinion. Patent counsel should review the cited claims, prosecution histories, continuations, national status, ownership, and the exact implementation in every intended jurisdiction.

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
| Ease for competitors to design around | Worse: easier for competitors to avoid the claims while retaining similar commercial value |

The scores are comparative engineering judgments, not probabilities.

---

# 2. Executive conclusion

The direction from the previous Markdown file should not remain the principal Glyphser patent nucleus.

That direction proposed:

- declared semantic nondeterminism ports;
- a broker issuing a one-use capability for one port occurrence;
- a lower kernel, runtime, hypervisor, or sandbox gate;
- denial of clock, entropy, network, scheduler, device, or similar access without the capability;
- atomic consumption of the capability;
- a lower-layer source receipt;
- a broker-side semantic receipt;
- two independently generated ledgers;
- a closure certificate proving that every protected source access was semantically authorized and no unmediated access occurred.

The new search found a much denser capability and resource-gating patent field than the previous analysis reflected.

Important conflicts include:

1. **US-8707449-B2** uses a token broker to acquire and distribute tokens for commands that require access to token-controlled system resources.
2. **US-8631482-B2** uses tickets containing resource identifiers and access rights to authorize one program to access a resource through another program.
3. **US-20130061316-A1** forms process tokens whose security identifiers reference capabilities declared in a manifest for executable code.
4. **US-11089022-B2** covers a decentralized sparse capability system implemented with secure enclaves.
5. **US-10884953-B2** and **US-12056062-B2** cover hardware-enforced capability processing.
6. **US-10461926-B2** covers cryptographic evidence concerning persisted capabilities.
7. **US-20190028513-A1** gates operating-system services through distributed authentication and microkernel calls.
8. Generic capability systems, one-use authorization patterns, service gating, sandboxing, syscall interception, authenticated receipts, and audit-ledger reconciliation are separately established.
9. The semantic nondeterminism layer remains close to **US-7840940-B2**, which already manages nondeterministic operations through an external software agent.
10. A competitor can retain most of the same value through process-scoped capabilities, static allowlists, ordinary sandbox policies, complete VM mediation, or deterministic runtime APIs while avoiding the exact dual-receipt structure.

No examined patent appears to claim the complete combination of a semantic nondeterminism request, port-scoped single-use capability, lower-layer atomic consumption, dual receipt generation, and closure certification. However, the remaining distinction is narrow and likely vulnerable to a predictable-combination obviousness argument.

## Replacement decision

Retire this as the principal direction:

> **Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities**

Retain runtime mediation only as an optional enforcement embodiment.

Proceed instead with:

# **Certified Source-Closed Executables with Reachability-Bound Nondeterminism Elimination**

Suggested protocol name:

## **Glyphser Source Closure Compiler — GSCC**

The replacement moves the inventive centre away from runtime capability authorization.

It solves this technical problem:

> How can a verifier determine, from a transformed executable and a compact proof artifact, that every reachable path to a prohibited nondeterministic primitive has been removed, replaced by an approved deterministic adapter, or converted into a fail-closed trap before execution?

The system:

1. analyzes a compiled executable, linked libraries, runtime stubs, native extensions, device kernels, and external-call boundaries;
2. constructs a cross-layer call and resource-access graph;
3. identifies all reachable nondeterministic primitives under a versioned source ontology;
4. transforms each reachable primitive into one of:
   - an approved deterministic adapter;
   - a declared controlled input port;
   - a fail-closed trap;
5. preserves a correspondence from each transformed machine-code site to:
   - the original site;
   - source class;
   - transformation rule;
   - replacement target;
6. recomputes reachability after transformation;
7. issues a certificate only when no prohibited nondeterministic primitive remains reachable from any declared entry point;
8. binds the certificate to the exact transformed binary, dependency closure, ontology, transformation engine, and verifier.

The principal claim does not require:

- runtime replay;
- per-access capabilities;
- dual audit ledgers;
- a trusted online broker;
- monitoring every access during execution;
- complete instruction tracing.

The searches found patents on application transformation, static previrtualization, source-interface detection, syscall-table patching, binary rewriting, control-flow integrity, proof-carrying code, and runtime integrity markers.

They did **not** identify one patent claiming the complete interaction of:

- a versioned nondeterminism-source ontology;
- cross-layer reachable-source discovery;
- exhaustive per-site classification;
- deterministic-adapter, controlled-port, or trap transformation;
- post-transformation reachability proof;
- exact transformed-site correspondence;
- certificate issuance only when the prohibited-source reachable set is empty.

---

# 3. Scores

## 3.1 Direction examined

### Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities

| Category | Score |
|---|---:|
| **Novelty risk** | **6.0/10** |
| **Obviousness risk** | **8.0/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **7.0/10** |
| **Ease of enforcing the patent** | **7.0/10** |
| **Ease for competitors to design around** | **7.0/10** |

## 3.2 Replacement direction

### Certified Source-Closed Executables with Reachability-Bound Nondeterminism Elimination

| Category | Score |
|---|---:|
| **Novelty risk** | **3.5/10** |
| **Obviousness risk** | **5.5/10** |
| **Subject-matter/technicality risk** | **1.5/10** |
| **Freedom-to-operate risk** | **4.5/10** |
| **Ease of enforcing the patent** | **8.0/10** |
| **Ease for competitors to design around** | **5.0/10** |

## 3.3 Comparative assessment

| Category | Capability-closure direction | Source-closed executable direction | Change |
|---|---:|---:|---:|
| Novelty risk | 6.0 | 3.5 | **2.5 lower** |
| Obviousness risk | 8.0 | 5.5 | **2.5 lower** |
| Subject-matter/technicality risk | 1.5 | 1.5 | **No material change** |
| Freedom-to-operate risk | 7.0 | 4.5 | **2.5 lower** |
| Ease of enforcing | 7.0 | 8.0 | **1.0 better** |
| Ease of design-around | 7.0 | 5.0 | **2.0 harder for competitors** |

The replacement remains exposed to binary transformation, static analysis, proof-carrying code, control-flow integrity, syscall mediation, and trusted-executable patent families.

Its improved position comes from making the patent centre the **post-transformation emptiness proof for reachable prohibited nondeterminism**, rather than generic capability authorization.

---

# 4. Direction examined

## Cross-Layer Nondeterminism Closure with Single-Use Mediation Capabilities

The previous direction used this flow:

```text
semantic port request
        ↓
single-use mediation capability
        ↓
lower-layer source-access gate
        ↓
atomic capability consumption
        ↓
source-consumption receipt
        ↓
semantic-port receipt
        ↓
dual-ledger closure verification
        ↓
execution closure certificate
```

Its proposed essential limitations included:

1. a capability bound to execution, port, occurrence, and source class;
2. fail-closed denial without the capability;
3. one-use atomic consumption;
4. independently generated lower-layer and semantic receipts;
5. value commitment matching;
6. monitoring continuity;
7. certification only when no unmediated access occurred.

The new search shows that resource tokens, capability manifests, hardware capability enforcement, service gating, and capability evidence are highly developed patent areas.

---

# 5. Additional patents conflicting with the capability-closure direction

## 5.1 Token broker controlling system-resource access

### US-8707449-B2  
**Acquiring Access to a Token Controlled System Resource**

### Relevant claimed mechanism

The claims describe:

- a token broker;
- a command requiring access to a token-controlled system resource;
- acquisition of a token;
- assignment of a token to an operation handler;
- distribution of the command and token;
- execution of the command;
- return or release signaling associated with the token.

### Conflict

The previous Glyphser architecture similarly used:

- a broker;
- an access request;
- a token or capability;
- a protected low-level resource;
- execution only after token validation;
- single-use or return-state handling.

The nondeterminism-specific semantic port remains different, but the core broker-token-resource interaction is directly claimed.

---

## 5.2 Ticket-based cross-program resource authorization

### US-8631482-B2  
**Method for Managing Computer Resources Accessed by a Program Operating in a Restricted Environment**

### Relevant claimed mechanism

The claims include:

- a first program requesting access to a resource;
- generation of a ticket;
- the ticket identifying the resource;
- the ticket containing access rights;
- a second program presenting the ticket;
- examination of the ticket;
- granting or refusing access to the resource.

### Conflict

A port-scoped mediation capability is functionally similar to a ticket identifying:

- resource;
- rights;
- caller;
- use scope.

The exact source-class and closure-certificate limitations are distinguishing, but broad capability claims are unsafe.

---

## 5.3 Manifest-derived process capabilities

### US-20130061316-A1  
**Capability Access Management for Processes**

### Relevant claimed mechanism

The application describes:

- executable code;
- a manifest describing capabilities;
- a token formed when execution begins;
- security identifiers in the token referencing capabilities in the manifest;
- capability access decisions made from the token.

### Conflict

The previous Glyphser design proposed:

- a port catalog;
- source catalog;
- process or execution identity;
- capability issuance;
- source access restricted according to declared capabilities.

An examiner could characterize the semantic port catalog as another executable capability manifest.

---

## 5.4 Decentralized sparse capability system

### US-11089022-B2  
**Decentralized Sparse Capability System with Secure Enclaves**  
**Status reviewed:** Active US patent; estimated expiry in 2040.

### Relevant area

The family concerns:

- capability-controlled resource access;
- sparse or decentralized capability representation;
- secure enclaves;
- trusted capability handling.

### Conflict

This increases FTO risk for enclave-backed or distributed versions of the prior Glyphser capability design.

---

## 5.5 Cryptographic evidence of capabilities

### US-10461926-B2  
**Cryptographic Evidence of Persisted Capabilities**

### Relevant area

The family concerns cryptographic evidence that capability state has been persisted and can be verified across processing resources and shared memory.

### Conflict

The prior direction used:

- authenticated capability state;
- capability consumption evidence;
- cryptographic receipts;
- ledger roots.

Generic cryptographic proof of capability state cannot support a broad claim.

---

## 5.6 Hardware capability enforcement

### US-10884953-B2  
**Capability Enforcement Processors**

### US-12056062-B2  
**Apparatus and Method for Capability-Based Processing**

### Relevant mechanisms

These families cover:

- processors that constrain execution according to capabilities;
- capability-controlled memory or processing access;
- interposed capability enforcement hardware;
- prevailing capability state;
- capability permission checks.

### Conflict

Any hardware-assisted implementation of Glyphser's capability gate requires careful claim-chart review.

The principal invention cannot be framed as hardware enforcing a capability.

---

## 5.7 Distributed service gating

### US-20190028513-A1  
**Distributed Authentication for Service Gating**

### Relevant claimed mechanism

The claims involve:

- a message-based operating system;
- a microkernel call;
- control of access to an operating-system authenticator;
- enforcement of a security policy;
- gating service access through distributed authentication.

### Conflict

This weakens claims to:

- lower-layer service gating;
- microkernel enforcement;
- authenticated access to protected operating-system functions.

---

## 5.8 Generic authenticated capability systems

The search also identified:

- compiler-directed capability protection;
- confidential-computing systems with capabilities;
- capability access processors;
- token-controlled resources;
- persisted capability evidence;
- rights-based microkernel security;
- capability-protected memory and objects.

### Consequence

The previous claim would require many narrow limitations to avoid being read as an application of known capability security to nondeterministic resources.

---

## 5.9 Audit reconciliation and receipts

Relevant families include:

- US-11169973-B2 — *Atomically Tracking Transactions for Auditability and Security*
- US-11398906-B2 — *Confirming Receipt of Audit Records for Audited Use of a Cryptographic Key*
- US-20230035551-A1 — *Multiple Source Audit Log Generation*
- US-11949784-B2 — *Auditing for Events*

### Conflict

The dual-ledger and matched-receipt part of the previous design is independently crowded.

---

# 6. Reassessment of the capability-closure direction

## 6.1 Novelty risk — 6.0/10

No single examined patent appears to contain all of:

- a semantic nondeterminism port;
- a one-use source capability;
- lower-layer atomic consumption;
- source and semantic receipts;
- closure over all protected nondeterministic accesses.

However, the core operational chain is assembled from known elements:

```text
manifest capability
    +
token broker
    +
resource ticket
    +
lower-layer service gate
    +
capability enforcement
    +
cryptographic capability evidence
    +
audit receipt matching
```

Broad independent claims would likely fail.

---

## 6.2 Obviousness risk — 8.0/10

A plausible examiner combination is:

1. manifest-derived process capability;
2. token broker for protected resources;
3. one-use or returned token handling;
4. lower-layer capability enforcement;
5. semantic nondeterminism management;
6. authenticated receipts and audit matching.

Each element would perform its ordinary function.

The specialization to clocks, randomness, schedulers, or external inputs may be treated as a field-of-use limitation.

---

## 6.3 Subject-matter/technicality risk — 1.5/10

The direction is strongly technical.

It changes:

- operating-system behavior;
- source-access permissions;
- token state;
- execution control;
- source mediation;
- audit generation.

Eligibility is not the principal weakness.

---

## 6.4 Freedom-to-operate risk — 7.0/10

Implementation may implicate active claims relating to:

- token-controlled resources;
- manifest-based process capabilities;
- hardware capability enforcement;
- secure-enclave capabilities;
- service gating;
- syscall tokens;
- resource tickets;
- persisted capability evidence;
- sandbox interposition;
- semantic nondeterminism management.

The exact token transport mechanism could create additional risk.

---

## 6.5 Ease of enforcing — 7.0/10

A product may expose:

- capability IDs;
- port catalogs;
- protected source catalogs;
- lower-layer gate identity;
- source and semantic receipt roots;
- closure status.

However, one-use semantics and atomic consumption may remain internal.

A competitor could expose a similar certificate while using a process-level allowlist rather than per-occurrence capabilities.

---

## 6.6 Ease for competitors to design around — 7.0/10

A competitor can retain most value by:

- assigning process-lifetime capabilities;
- using static allowlists;
- using one trusted monitor;
- using a deterministic VM;
- denying all direct access without per-occurrence tokens;
- recording accesses rather than authorizing each one;
- using ordinary sandbox policies;
- using complete VM mediation.

The exact per-occurrence dual-receipt mechanism is therefore avoidable.

---

# 7. Replacement direction

# Certified Source-Closed Executables with Reachability-Bound Nondeterminism Elimination

## 7.1 Technical objective

The replacement produces an executable artifact for which prohibited nondeterminism is structurally unreachable.

The claim is not:

> monitor nondeterministic accesses at runtime.

The claim is:

> transform and certify the executable so every reachable prohibited nondeterministic primitive has been eliminated, deterministically adapted, declared as a controlled input, or replaced with a trap.

This changes the trusted boundary.

The verifier does not need to trust:

- an online broker;
- a stream of access tokens;
- continuous receipt matching;
- a runtime monitor that sees every operation.

Instead, the verifier checks a transformed executable and a machine-verifiable closure proof.

---

# 8. Core architecture

## 8.1 Nondeterminism-source ontology

The system defines a versioned ontology:

```text
nondeterminism_source_ontology:
    ontology_version

    source_classes:
        - source_class_id
          primitive_patterns
          resolution_layer
          value_type
          default_disposition
          allowed_adapter_classes
          allowed_port_classes

    ontology_root
```

Example source classes:

```text
clock.wall
clock.monotonic
clock.high_resolution
entropy.os
entropy.hardware
scheduler.thread_choice
scheduler.wakeup_order
network.receive
network.response
filesystem.enumeration_order
process.identifier
temporary_name
locale.query
device.selection
kernel.algorithm_selection
accelerator.completion_order
backend.algorithm_selection
hardware.counter
dynamic_library_resolution
```

The ontology may identify primitives by:

- machine instruction;
- system call;
- imported symbol;
- runtime intrinsic;
- device-runtime call;
- accelerator kernel primitive;
- library ABI;
- dynamic dispatch target;
- foreign-function interface;
- external message endpoint.

---

## 8.2 Artifact dependency closure

The compiler receives:

```text
closure_subject:
    primary_executable
    shared_libraries
    runtime_libraries
    native_extensions
    device_kernels
    plugin set
    dynamic loader constraints
    permitted external endpoints
```

It computes a dependency closure:

```text
artifact_dependency_closure:
    artifact_nodes
    import_edges
    dynamic_load_edges
    callback_edges
    device-launch_edges
    foreign-function edges
    external-endpoint edges
    dependency_root
```

The certificate is invalid if the executable can load an artifact outside the certified closure.

---

## 8.3 Cross-layer reachability graph

The analysis constructs:

```text
cross_layer_reachability_graph:
    entry_points
    machine_code_blocks
    call targets
    imports
    syscalls
    runtime intrinsics
    device calls
    external endpoints
    nondeterministic primitive nodes
```

The graph includes:

- direct calls;
- indirect calls;
- callback registrations;
- virtual dispatch;
- dynamically linked symbols;
- native extension calls;
- accelerator launches;
- runtime-generated stubs;
- controlled dynamic-loading alternatives.

The graph should include an uncertainty state for unresolved targets.

Unresolved targets cannot silently be treated as safe.

---

## 8.4 Site classification

Each reachable nondeterminism site receives:

```text
nondeterminism_site:
    original_artifact_digest
    original_site_id
    source_class_id

    reachability_witness
    call_context_digest
    transformation_disposition
```

Dispositions:

- `DETERMINISTIC_ADAPTER`
- `CONTROLLED_INPUT_PORT`
- `FAIL_CLOSED_TRAP`
- `PROVEN_UNREACHABLE`
- `UNSUPPORTED`
- `UNRESOLVED_TARGET`

Only the first four may appear in a certifiable executable.

---

## 8.5 Deterministic adapters

A deterministic adapter replaces a prohibited primitive with a deterministic function of declared execution inputs.

Example:

```text
wall clock
    → logical_time(execution_epoch, event_index)

OS entropy
    → deterministic_stream(seed_commitment, port_id, occurrence_id)

filesystem enumeration
    → canonical_sort(directory_entries)

temporary name
    → H(execution_id, port_id, occurrence_id)

device algorithm choice
    → fixed approved algorithm identifier
```

An adapter record contains:

```text
adapter_record:
    original_site_id
    source_class_id
    adapter_code_hash
    declared_input_set
    output_schema
    adapter_contract_hash
```

The principal claim should not require these exact adapter algorithms.

---

## 8.6 Controlled input ports

Some nondeterminism cannot be eliminated.

It is converted into a declared controlled input:

```text
controlled_input_port:
    port_id
    source_class_id
    value_schema
    occurrence_rule
    evidence_requirement
    provider_contract_hash
```

The transformed executable cannot invoke the original source primitive.

It can only consume the supplied controlled input.

---

## 8.7 Fail-closed traps

If no approved adapter or controlled port exists, the primitive is replaced by:

```text
trap_nondeterminism(source_class_id, original_site_id)
```

Execution terminates or becomes invalid if the path is reached.

This allows a source-closed certificate even when an unexercised path remains structurally possible, provided the prohibited operation itself is no longer performed.

---

## 8.8 Transformation correspondence map

For every modified site:

```text
site_correspondence:
    original_artifact_digest
    original_site_id
    original_code_commitment

    transformed_artifact_digest
    transformed_site_id
    transformed_code_commitment

    source_class_id
    disposition
    adapter_or_port_or_trap_id

    transformation_rule_id
    correspondence_witness
```

The map allows independent checking that:

- all identified sites were transformed;
- the intended replacement was inserted;
- no unrelated transformation is necessary to trust the certificate;
- a transformed site maps to one original source site.

---

## 8.9 Post-transformation reanalysis

After transformation, the system rebuilds the reachability graph.

It computes:

```text
prohibited_reachable_set =
    {
      reachable nodes that implement prohibited
      nondeterministic source primitives
    }
```

Certification requires:

```text
prohibited_reachable_set = ∅
```

The verifier separately checks:

```text
unresolved_reachable_target_set = ∅
uncertified_dependency_set = ∅
unclassified_source_site_set = ∅
```

The key proof is an emptiness result, not a runtime access log.

---

## 8.10 Source-closure certificate

```text
source_closed_executable_certificate:
    schema_version

    original_subject_root
    transformed_subject_root
    dependency_root

    ontology_root
    transformation_policy_root

    analyzer_code_hash
    transformer_code_hash
    verifier_code_hash

    original_reachability_root
    transformed_reachability_root
    correspondence_map_root

    deterministic_adapter_root
    controlled_input_port_root
    trap_site_root

    prohibited_reachable_count
    unresolved_reachable_target_count
    uncertified_dependency_count
    unclassified_site_count

    closure_state
    certificate_hash
```

Closure states:

- `SOURCE_CLOSED`
- `PROHIBITED_SOURCE_REACHABLE`
- `UNRESOLVED_DYNAMIC_TARGET`
- `UNCERTIFIED_DEPENDENCY`
- `UNCLASSIFIED_SOURCE_SITE`
- `TRANSFORMATION_CORRESPONDENCE_FAILURE`
- `ADAPTER_CONTRACT_FAILURE`
- `CONTROLLED_PORT_CONTRACT_FAILURE`

Only `SOURCE_CLOSED` supports strong deterministic-execution certification.

---

# 9. Strongest proposed claim nucleus

A proposed principal method nucleus is:

> A computer-implemented method comprising receiving a compiled executable and a nondeterminism-source ontology identifying low-level primitives capable of providing execution-dependent values; constructing a reachability representation extending across machine-code control flow, imported library calls, runtime intrinsics, and external execution interfaces; identifying, from one or more declared entry points, each reachable site associated with a prohibited nondeterminism-source class; transforming each identified reachable site by replacing the site with a deterministic adapter, a declared controlled-input port, or a fail-closed trap; generating a correspondence record binding each identified site in the compiled executable to a respective transformed site and transformation disposition; constructing a post-transformation reachability representation for the transformed executable and its certified dependency closure; determining that no prohibited nondeterminism-source primitive and no unresolved call target remains reachable from the declared entry points; and issuing a certificate bound to the transformed executable, the dependency closure, the nondeterminism-source ontology, and the correspondence records only after the determining succeeds.

The strongest limitations are:

1. compiled executable rather than source-only analysis;
2. cross-layer reachability;
3. versioned nondeterminism ontology;
4. every reachable prohibited site classified;
5. only three permitted transformations:
   - deterministic adapter;
   - controlled input port;
   - fail-closed trap;
6. site-level original-to-transformed correspondence;
7. mandatory post-transformation reanalysis;
8. empty prohibited reachable set;
9. empty unresolved-target set;
10. certified dependency closure;
11. certificate bound to the exact transformed artifact.

---

# 10. Closest patents and differences

## 10.1 US-20130111593-A1  
### Transforming Untrusted Applications into Trusted Executables Through Static Previrtualization

This family transforms untrusted applications into trusted executables using static previrtualization.

### Difference

The proposed Glyphser direction is not generic trusted transformation.

It requires:

- nondeterminism-source ontology;
- exhaustive reachable-source classification;
- limited replacement dispositions;
- post-transformation proof that no prohibited source primitive remains reachable;
- source-specific closure certificate.

---

## 10.2 US-9202044-B2  
### System and Method for Retrofitting Application Code

This family concerns modifying existing application code to add or alter behavior.

### Difference

Generic retrofitting is not claimed.

The principal claim requires nondeterminism-specific reachable-site elimination and an emptiness certificate.

---

## 10.3 US-20030192037-A1  
### Statically Detecting Externally Referenced Interfaces of a Program

This patent detects externally referenced program interfaces from compiled output without source code.

### Difference

The proposed direction uses external-interface detection as one analysis input.

It adds:

- source-class ontology;
- reachability from declared entry points;
- transformation;
- correspondence mapping;
- post-transformation reanalysis;
- emptiness-based closure.

---

## 10.4 US-20150007266-A1 / US-9483637-B2  
### Program Execution Integrity Verification for a Computer System

These families instrument programs with integrity markers and verify runtime execution through kernel interactions.

### Difference

The replacement does not require runtime markers.

Its certificate concerns structural absence of reachable prohibited nondeterminism.

---

## 10.5 US-20220092171-A1  
### Malicious Code Protection Based on System Call Table Modification and Runtime Application Patching

This family modifies syscall handling and patches applications at runtime.

### Difference

The principal Glyphser claim should avoid:

- runtime patching;
- syscall-table modification;
- malware prevention as the objective.

It transforms the artifact before certified execution and verifies source closure.

---

## 10.6 US-6275938-B1  
### Security Enhancement for Untrusted Executable Code

This patent replaces or redirects static links and controls host-system access for untrusted executable code.

### Difference

The proposed direction is not general sandboxing or untrusted-code confinement.

It targets a defined ontology of nondeterministic sources and proves no prohibited source remains reachable.

---

## 10.7 Control-flow integrity and binary rewriting patents

Relevant references include:

- US-20130283245-A1 — *Control Flow Integrity Enforcement at Scale*
- US-20140229717-A1 — *Binary Translator Driven Program State Relocation*
- US-20180081826-A1 — *Methods and Systems for Binary Scrambling*
- US-20190197216-A1 — protected execution and reverse-engineering resistance.

### Difference

The claim should not depend on generic control-flow integrity, obfuscation, relocation, or scrambling.

Reachability is used only to establish nondeterminism-source closure.

---

## 10.8 Proof-carrying and verified executable systems

Prior art exists on:

- proof-carrying code;
- verified compilation;
- low-level safety proofs;
- formal verification of binaries;
- proof-producing transformations.

### Difference

The application must focus on the specific technical invariant:

```text
no reachable prohibited nondeterminism primitive
```

and the transformation correspondence needed to prove it.

---

# 11. Replacement-direction risk analysis

## 11.1 Novelty risk — 3.5/10

The search found the component technologies:

- binary and application transformation;
- static previrtualization;
- external-interface detection;
- control-flow analysis;
- syscall rewriting;
- program instrumentation;
- verified executable generation;
- proof-carrying code.

It did not identify one reference claiming the complete nondeterminism-specific sequence:

```text
ontology
    +
cross-layer reachable-site discovery
    +
adapter/controlled-port/trap replacement
    +
site correspondence
    +
post-transform reachability
    +
empty prohibited set
    +
artifact-bound certificate
```

---

## 11.2 Obviousness risk — 5.5/10

A plausible examiner combination is:

1. static detection of external interfaces;
2. binary rewriting or previrtualization;
3. deterministic wrappers or sandbox stubs;
4. control-flow reachability;
5. proof-carrying or certified executable techniques.

The strongest inventive-step argument is the interaction:

> transformation is not complete when the original sites are rewritten; it is complete only when an independently checkable post-transformation reachability proof shows that the prohibited-source set and unresolved-target set are both empty over the certified dependency closure.

The application should provide examples where simple API replacement fails because:

- native extensions bypass wrappers;
- dynamically loaded libraries introduce new sources;
- accelerator kernels perform device-specific selection;
- indirect calls reach unclassified primitives;
- dead-code assumptions are incorrect;
- runtime-generated stubs expose nondeterministic operations.

---

## 11.3 Subject-matter/technicality risk — 1.5/10

The direction is strongly technical.

It changes:

- executable code;
- call targets;
- imported symbols;
- system interfaces;
- device calls;
- runtime behavior;
- binary dependencies.

It produces a transformed machine artifact and a verifiable technical invariant.

---

## 11.4 Freedom-to-operate risk — 4.5/10

FTO risk remains in:

- static previrtualization;
- executable retrofitting;
- binary rewriting;
- syscall redirection;
- sandbox transformation;
- verified compilation;
- proof-carrying code;
- control-flow analysis;
- dynamic-interface detection.

Risk can be reduced by:

- avoiding generic trust or security claims;
- not using runtime patching;
- not requiring one patented previrtualization technique;
- supporting multiple transformation backends;
- keeping proof representation primitive-neutral;
- claim-charting the exact linker, rewriting, and analysis methods.

---

## 11.5 Ease of enforcing — 8.0/10

A conforming product would likely expose:

- transformed executable;
- original and transformed roots;
- ontology version;
- correspondence-map root;
- adapter catalog;
- controlled-port catalog;
- trap-site catalog;
- prohibited reachable count;
- unresolved-target count;
- closure state.

Independent testing can inspect the binary and attempt to locate prohibited primitives.

A competitor marketing a “nondeterminism-free certified executable” would provide strong public evidence.

---

## 11.6 Ease for competitors to design around — 5.0/10

Competitors can avoid the claims by:

- relying entirely on a deterministic VM;
- using runtime mediation;
- using source-level restricted languages;
- using hardware enclaves;
- using complete execution replay;
- using manually written deterministic wrappers without certification;
- certifying only source code;
- allowing prohibited primitives but monitoring them.

However, those alternatives do not provide the same portable guarantee:

> every reachable prohibited low-level source has been structurally eliminated or trapped in the exact shipped executable and dependency closure.

Separate independent claims should cover:

1. reachability-bound source discovery;
2. source-specific transformation;
3. post-transform emptiness verification;
4. site correspondence;
5. artifact-bound closure certification.

---

# 12. Recommended claim families

## Family A — Nondeterminism-source ontology

Protect:

- versioned source classes;
- primitive patterns across machine code, syscalls, libraries, runtimes, and devices;
- source-specific allowed dispositions.

## Family B — Cross-layer reachable-source discovery

Protect:

- machine-code control flow;
- imports;
- dynamic loading;
- native extensions;
- runtime intrinsics;
- device launches;
- external endpoints;
- unresolved-target treatment.

## Family C — Restricted transformation dispositions

Protect:

- deterministic adapter;
- controlled input port;
- fail-closed trap;
- prohibition on silently leaving a reachable source unchanged.

## Family D — Site correspondence proof

Protect:

- original site;
- transformed site;
- original and transformed code commitments;
- source class;
- transformation rule;
- replacement identity.

## Family E — Post-transformation emptiness proof

Protect:

- rebuilt reachability graph;
- empty prohibited-source set;
- empty unresolved-target set;
- empty uncertified-dependency set;
- certificate issuance only after emptiness.

## Family F — Dependency-closure locking

Protect:

- certified dynamic-library set;
- native extension set;
- device kernel set;
- plugin set;
- rejection of execution with an unlisted dependency.

## Family G — Closure-gated execution comparison

Dependent or continuation claims may require both compared executables to possess valid source-closure certificates before an equivalence or reproducibility certificate is issued.

---

# 13. Technical evidence needed before filing

## 13.1 Demonstrate wrapper bypass

Build examples where ordinary API wrappers miss:

- direct syscalls;
- direct CPU timestamp instructions;
- native extension calls;
- dynamically loaded libraries;
- device runtime operations;
- JIT-generated calls;
- foreign-function calls.

Show that GSCC detects and transforms them.

---

## 13.2 Demonstrate post-transform emptiness

For each source class, show:

```text
before:
    reachable prohibited sites > 0

after:
    reachable prohibited sites = 0
```

The independent verifier should recompute the result.

---

## 13.3 Demonstrate unresolved-target rejection

Create:

- indirect call with unknown target;
- unconstrained dynamic library load;
- callback from uncertified plugin;
- runtime-generated native stub;
- accelerator kernel chosen at runtime.

The certificate must fail unless the target set is resolved or constrained.

---

## 13.4 Demonstrate transformation dispositions

For one workload, use all three:

- deterministic adapter;
- controlled input port;
- fail-closed trap.

Show that the transformed executable behaves correctly and that reaching a trap invalidates execution.

---

## 13.5 Demonstrate exact artifact binding

Modify one byte of:

- transformed executable;
- adapter library;
- port provider;
- dependency;
- ontology;
- correspondence map.

Verification must fail.

---

## 13.6 Benchmark technical effect

Measure:

- analysis time;
- transformation time;
- binary size change;
- runtime overhead;
- number of eliminated sources;
- number of controlled ports;
- number of traps;
- certificate size;
- independent verification time;
- comparison with full VM mediation.

---

# 14. Glyphser implementation path

## 14.1 New schemas

```text
nondeterminism_source_ontology.v1
artifact_dependency_closure.v1
cross_layer_reachability_graph.v1
nondeterminism_site_inventory.v1
site_transformation_correspondence.v1
deterministic_adapter_catalog.v1
controlled_input_port_catalog.v1
source_closed_executable_certificate.v1
```

## 14.2 Suggested modules

```text
runtime/glyphser/source_closure/ontology.py
runtime/glyphser/source_closure/dependencies.py
runtime/glyphser/source_closure/reachability.py
runtime/glyphser/source_closure/site_inventory.py
runtime/glyphser/source_closure/transform.py
runtime/glyphser/source_closure/adapters.py
runtime/glyphser/source_closure/ports.py
runtime/glyphser/source_closure/traps.py
runtime/glyphser/source_closure/correspondence.py
runtime/glyphser/source_closure/verify.py
runtime/glyphser/source_closure/certificate.py
```

## 14.3 Suggested quality gates

```text
tooling/quality_gates/dependency_closure_gate.py
tooling/quality_gates/no_unresolved_target_gate.py
tooling/quality_gates/nondeterminism_site_coverage_gate.py
tooling/quality_gates/site_correspondence_gate.py
tooling/quality_gates/post_transform_source_emptiness_gate.py
tooling/quality_gates/source_closed_artifact_gate.py
```

## 14.4 Required adversarial fixtures

```text
direct_clock_instruction
direct_os_entropy_syscall
native_extension_entropy
dynamic_library_clock_access
unresolved_indirect_call
uncertified_plugin_load
foreign_function_bypass
jit_generated_source_access
device_runtime_algorithm_choice
accelerator_completion_source
adapter_hash_mismatch
port_provider_hash_mismatch
trap_removed_after_certification
dependency_added_after_certification
correspondence_map_site_omission
transformed_site_wrong_source_class
```

---

# 15. Features to exclude from the principal claim

Do not make these essential:

- runtime single-use capabilities;
- dual receipt ledgers;
- online brokers;
- replay;
- four-run matrices;
- complete VM tracing;
- blockchain;
- TPM;
- TEE;
- one specific binary rewriter;
- one specific static-analysis framework;
- one particular proof system;
- one particular hash;
- one operating system;
- one processor architecture;
- one ML framework;
- source-code availability.

These may appear as optional embodiments or dependent claims.

---

# 16. Filing strategy

## Principal independent method claim

Require:

- compiled executable;
- source ontology;
- cross-layer reachability;
- reachable site inventory;
- permitted transformation disposition;
- site correspondence;
- post-transform reanalysis;
- empty prohibited-source set;
- empty unresolved-target set;
- artifact-bound certificate.

## System claim

Claim components such as:

- dependency resolver;
- cross-layer analyzer;
- source-site classifier;
- transformation engine;
- correspondence generator;
- post-transform verifier;
- certificate generator.

## Computer-readable-medium claim

Mirror the method without unnecessarily limiting architecture or operating system.

## Separate independent claims

Consider separate independent claims for:

1. source ontology and site inventory;
2. cross-layer source elimination;
3. site correspondence;
4. post-transform emptiness proof;
5. dependency-locked source-closed certificate.

## Specification breadth

Disclose:

- source and binary inputs;
- static and hybrid analysis;
- CPU and accelerator artifacts;
- dynamic libraries;
- native extensions;
- JIT restrictions;
- multiple adapter types;
- multiple controlled-port providers;
- multiple trap implementations;
- different certificate and proof formats.

---

# 17. Final recommendation

The previous capability-closure direction is no longer the strongest filing candidate because its core operations can be assembled from patent families covering:

- token-controlled system resources;
- resource tickets;
- process capability manifests;
- hardware capability enforcement;
- secure-enclave capabilities;
- service gating;
- persisted capability evidence;
- audit receipt matching;
- semantic nondeterminism management.

Replace it with:

> **A transformation and certification system that identifies every reachable low-level nondeterminism source in a compiled executable and its dependency closure, replaces each identified source with a deterministic adapter, declared controlled-input port, or fail-closed trap, preserves a machine-verifiable original-to-transformed site correspondence, recomputes cross-layer reachability after transformation, and issues a certificate only when no prohibited nondeterminism primitive, unresolved target, or uncertified dependency remains reachable.**

This direction is better because it:

- removes generic capability systems from the inventive centre;
- avoids runtime token brokers and dual-ledger obviousness;
- creates a transformed technical artifact;
- produces a clear computer-operation improvement;
- requires post-transformation verification rather than trusting the transformer;
- addresses direct instructions, syscalls, libraries, native extensions, runtimes, and device code;
- produces visible, testable infringement evidence;
- is harder to reproduce through ordinary sandbox policy;
- was not matched by one patent containing the complete nondeterminism-ontology, site-correspondence, and post-transform emptiness interaction in the searches performed.

---

# 18. Principal references reviewed in this pass

## Direct conflicts with the capability-closure direction

- US-8707449-B2 — *Acquiring Access to a Token Controlled System Resource*
- US-8631482-B2 — *Managing Computer Resources Accessed by a Program Operating in a Restricted Environment*
- US-20130061316-A1 — *Capability Access Management for Processes*
- US-11089022-B2 — *Decentralized Sparse Capability System with Secure Enclaves*
- US-10461926-B2 — *Cryptographic Evidence of Persisted Capabilities*
- US-10884953-B2 — *Capability Enforcement Processors*
- US-12056062-B2 — *Apparatus and Method for Capability-Based Processing*
- US-20190028513-A1 — *Distributed Authentication for Service Gating*
- US-11169973-B2 — *Atomically Tracking Transactions for Auditability and Security*
- US-11398906-B2 — *Confirming Receipt of Audit Records for Audited Use of a Cryptographic Key*
- US-20230035551-A1 — *Multiple Source Audit Log Generation*
- US-11949784-B2 — *Auditing for Events*
- US-7840940-B2 — *Semantic Management of Non-Deterministic Operations*

## Closest references to the replacement direction

- US-20130111593-A1 — *Transforming Untrusted Applications into Trusted Executables Through Static Previrtualization*
- US-9202044-B2 — *System and Method for Retrofitting Application Code*
- US-20030192037-A1 — *Statically Detecting Externally Referenced Interfaces of a Program*
- US-20150007266-A1 / US-9483637-B2 — *Program Execution Integrity Verification for a Computer System*
- US-20220092171-A1 — *Malicious Code Protection Based on System Call Table Modification and Runtime Application Patching*
- US-6275938-B1 — *Security Enhancement for Untrusted Executable Code*
- US-20130283245-A1 — *Control Flow Integrity Enforcement at Scale*
- US-20140229717-A1 — *Binary Translator Driven Program State Relocation*
- US-20180081826-A1 — *Methods and Systems for Binary Scrambling*
- US-20190197216-A1 — protected execution and reverse-engineering resistance
- US-11989291-B2 — *System, Method, and Apparatus for Software Verification*
- US-11836246-B2 — computer-implemented program transformation
- US-10235218-B2 — *Automatic Correction of Cryptographic Application Program Interfaces*

---

# 19. Required legal follow-up

Before filing or implementation, counsel should perform:

1. limitation-by-limitation claim charts against the references above;
2. prosecution-history review of static previrtualization, binary transformation, capability, and verified-executable families;
3. jurisdiction-specific FTO review;
4. review of the exact binary rewriting and reachability-analysis engines selected;
5. review of proof-carrying-code and verified-compilation patents;
6. review of the Glyphser repository's public disclosure history;
7. inventorship analysis;
8. non-patent literature search on deterministic compilation, hermetic execution, reproducible builds, effect systems, sandbox transformation, binary rewriting, syscall elimination, and proof-producing compilers.

No search can establish that undisclosed applications, unpublished applications, non-English documents, or unindexed prior art do not exist.
