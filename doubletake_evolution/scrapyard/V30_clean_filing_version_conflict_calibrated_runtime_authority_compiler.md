# Conflict-Calibrated Deterministic Runtime Authority Compiler for Autonomous Agents

**Alternative title:** Deterministic Runtime Authority Compilation from Divergent Autonomous-Agent Proposals

---

## 1. Title

**Conflict-Calibrated Deterministic Runtime Authority Compiler for Autonomous Agents**

In one embodiment, the invention may also be described as deterministic runtime authority compilation from divergent autonomous-agent proposals.

---

## 2. Cross-Reference to Related Applications

Not applicable.

---

## 3. Technical Field

The invention relates to autonomous software agents, large-language-model-based agents, coding agents, enterprise automation agents, test orchestration agents, policy-governed runtime systems, deterministic execution-control systems, certificate-bound execution systems, replay verification systems, and runtime enforcement mechanisms for software systems that can perform side-effecting operations.

More particularly, the invention relates to systems and methods for controlling nondeterministic autonomous-agent execution by freezing task state, collecting plural or repeated proposals, converting proposals into canonical executable graphs, extracting candidate runtime operations, resolving each candidate operation on a binary authorization frame using proposal-graph evidence and conflict-calibrated evidence aggregation, compiling an authority packet, binding the packet to an execution certificate, and enforcing runtime operations against the certificate-bound packet before side effects occur.

---

## 4. Background

Autonomous agents can plan, propose, and perform actions. A coding agent may modify source files, run tests, execute shell commands, call tools, create patches, or interact with a repository. An enterprise agent may update human-resources systems, create tickets, modify customer-relationship records, submit access requests, call APIs, update identity systems, or trigger approval workflows.

Such agents often depend on probabilistic model outputs, dynamic context selection, model-routing decisions, tool-state variation, retrieval snapshots, or repeated planning passes. As a result, the same task can produce different proposed executable behavior across repeated runs.

For example, the same coding task may produce different proposals for selected tests, affected files, shell commands, validation steps, or tool calls. The same enterprise task may produce different proposals for access level, approval flow, target system, ticket content, or timing of execution. These differences can matter before side effects occur.

Existing approaches may validate a proposed action, check a requested tool call against a policy, certify a trace, log execution, replay a prior run, sandbox an agent, or apply runtime guardrails. Those mechanisms do not by themselves solve the technical problem of converting multiple proposals generated against the same frozen task state into deterministic runtime authority at the level of individual candidate operations.

A need exists for a control architecture that treats proposal-graph evidence and proposal-source conflict as inputs to operation-level authorization resolution, rather than merely approving or rejecting one proposed trace or tool call.

---

## 4A. Inventive Distinction over Conventional Systems

The invention should be distinguished from ordinary runtime guardrails, policy engines, sandboxing systems, consensus voting systems, audit logs, replay systems, CI test selectors, approval workflows, tool-call allowlists, and multi-agent debate systems.

Conventional systems often evaluate one trace, one tool call, one requested action, one policy rule, or one agent output. By contrast, the present system compiles deterministic operation-level authority from plural proposal graphs generated against the same frozen task state. It uses dependent-source pooling, independent-source conflict handling, direction-aligned authorization coverage, hard constraints, certificate binding, and pre-side-effect enforcement.

| Conventional System Type | Conventional Function | Present System Distinction |
|---|---|---|
| Runtime guardrail | Blocks or warns about unsafe behavior | Resolves each candidate operation using proposal-graph evidence and a binary authorization frame before runtime side effects |
| Policy engine | Checks whether a requested action satisfies a policy | Uses policy as a constraint gate inside operation-level authority resolution, not as the entire decision process |
| Sandbox | Restricts runtime capabilities generally | Compiles a task-specific authority packet from frozen inputs and evidence commitments |
| Consensus voting | Counts agreement among agents or models | Pools dependent sources, combines independent groups, and counts only direction-aligned AUTHORIZE coverage |
| Audit logging | Records what occurred | Binds authorization evidence and packet contents before execution, then replay-verifies compliance |
| Replay system | Reconstructs prior execution | Recomputes graph commitments, operation evidence, authority output, packet hash, and runtime compliance |
| CI test selector | Selects tests from code changes | Resolves each test/action operation under authorization evidence, constraints, and side-effect boundaries |
| Approval workflow | Requires approval for a class of actions | Treats approval state as a hard constraint and certificate-bound packet condition |
| Tool-call allowlist | Allows listed tools or arguments | Canonicalizes each attempted operation and checks operation tuple, arguments, evidence hooks, environment, and side effects |
| Multi-agent debate | Uses multiple model outputs to improve an answer | Converts plural proposal graphs into operation evidence and resolves runtime authority, not conversational answer quality |

The technical distinction is that the system produces an executable authority packet from operation-level resolution of proposal-graph evidence. The authority packet changes runtime behavior by determining which side-effecting computer operations are permitted, blocked, or review-required.

---

## 5. Summary of the Invention

The invention is a conflict-calibrated deterministic runtime-authority compiler for autonomous agents.

The system freezes a task state, obtains plural or repeated autonomous-agent proposals generated against the same frozen task state, normalizes the proposals into canonical executable graphs, and extracts a universe of candidate runtime operations. For each candidate operation, the system constructs a binary authorization frame comprising an authorize state and a withhold state. Proposal-graph evidence for the candidate operation is grouped by source dependence, pooled within dependent groups, combined across independent groups, checked for conflict, internal tension, ambiguity, coverage, evidence anchoring, and hard constraints, and then resolved as authorized, blocked, or review-required.

Authorized and blocked operations are compiled into an authority packet. A certificate builder 114 binds the authority packet to an execution certificate. A runtime enforcement gate intercepts attempted operations before side effects occur, canonicalizes each attempted operation, and permits the operation only if it matches an authorized operation in the certificate-bound authority packet and satisfies applicable argument, approval, evidence, environment, and side-effect constraints. A replay verifier 118 reconstructs frozen inputs, graph commitments, operation evidence, authority-resolution outputs, packet contents, certificate bindings, and runtime traces to verify reproducible packet generation and runtime compliance.

The protected core is not merely “authority compiled from classified operational divergence.” The protected core is:

> authority compiled by resolving each candidate runtime operation on a binary authorization frame using proposal-graph evidence, dependent-source pooling, independent-source conflict handling, direction-aligned authorization coverage, hard constraints, certificate binding, and runtime enforcement.

Operational divergence classes remain useful, but they are used as evidence features, constraint triggers, threshold-profile selectors, or fallback embodiments. They are not the sole center of the invention.

---

## 5A. Definitions

The following definitions are provided for clarity. These definitions describe representative embodiments and should not be read as limiting unless expressly recited in a claim.

**Candidate runtime operation** means a normalized executable operation that may be attempted by, requested by, or performed on behalf of an autonomous agent. Examples include a command execution, file write, patch application, API call, database mutation, ticket creation, access request, approval request, credential access, network call, test execution, workflow update, or evidence emission.

**Side effect** means an operation that modifies, exposes, commits, transmits, persists, or causes another system to modify, expose, commit, transmit, or persist computer state. Side effects include file writes, repository changes, database mutations, remote-service updates, ticketing updates, access-control changes, workflow-state changes, runtime-environment changes, external API mutations, credential access, network-visible changes, user-visible artifact creation, approval-state changes, persistent logging changes, process spawning, or external workflow triggers.

**Frozen task-state bundle** means a canonical representation of task-relevant state used to bind candidate proposals and runtime authority to a specific task condition. It may include task content, repository state, database state, policy state, permission state, tool state, retrieval state, approval state, environment digest, selector version, threshold profile, and runtime-gate version.

**Canonical executable graph** means a deterministic graph representation of executable proposal meaning. The graph may include operation nodes and typed edges representing order, data dependency, file dependency, policy dependency, approval dependency, evidence obligation, environment dependency, side-effect boundary, or certificate binding.

**Proposal-source dependence** means a relationship indicating that two or more evidence items should not be counted as independent sources. Proposal-source dependence may arise from the same agent, same model route, same prompt template, same retrieval snapshot, same dry-run source, same reviewer source, same human-edited source, same cached trace, or another shared origin.

**Independence group** means an identifier assigned to operation-evidence items that are treated as dependent for pooling. Evidence items sharing an independence group are summarized before any independent-group combination is performed.

**Group evidence summary** means a deterministic summary of operation-evidence items sharing an independence group. It may include authorize peak, withhold peak, resolved direction, resolved margin, relative clarity, internal tension, group authorization mass, source-resolved flag, coverage-facing quantity, explanation, and group summary hash.

**Authorization mass** means a belief-mass representation for a candidate operation on a binary authorization frame having AUTHORIZE and WITHHOLD states plus uncertainty. The authorization mass may be computed from independent group evidence summaries and may include conflict and internal-tension metadata.

**Direction-aligned source coverage** means an authorization-coverage value that counts only independent group evidence summaries aligned with the final AUTHORIZE direction for a candidate operation. Opposing groups may increase conflict or review risk, but they do not increase AUTHORIZE coverage.

**Direction-aligned quantity coverage** means a magnitude-weighted authorization-coverage value computed from coverage-facing quantities of independent group summaries aligned with the final AUTHORIZE direction.

**Authority packet** means a deterministic runtime authority object comprising authorized operations, blocked operations, argument constraints, approval requirements, evidence requirements, environment requirements, side-effect boundaries, expiry, version identifiers, and packet hash. An authority packet may include both test operations and action operations.

**Execution certificate** means a certificate, signed object, hash-bound record, attestation, or equivalent binding that links an authority packet to frozen task state, graph commitments, authorization evidence commitment, policy manifests, permission manifests, tool manifests, environment digest, selector version, runtime-gate version, expiry, and optional signature.

**Runtime gate** means a runtime enforcement component that intercepts attempted operations before side effects occur, canonicalizes each attempted operation, verifies the execution certificate, checks constraints, and permits only operations authorized by the certificate-bound authority packet.

**Replay verifier** means a verifier that reconstructs frozen task state, graph commitments, operation-evidence commitments, group summaries, authorization outputs, authority packet, execution certificate, runtime trace, and violation reports to confirm reproducibility and runtime compliance.

**Evidence obligation** means a requirement that an operation emit, preserve, or bind evidence such as command traces, test output logs, artifact hashes, diff captures, API receipts, approval tokens, environment digests, replay artifacts, or violation reports.

**Hard constraint** means a policy, permission, approval, side-effect, evidence, tool, environment, legal, compliance, or security predicate that blocks, limits, or requires review for an operation independently of the numerical authorization mass.

**Total-conflict fallback** means a terminal conflict state produced when independent evidence combination for a candidate operation is unresolved beyond a configured conflict condition. It is not treated as ordinary uncertainty for authorizing an operation; it causes the operation to be blocked or marked review-required.

---

## 6. Brief Description of the Drawings

Unless otherwise noted, reference numerals may be used as follows:

| Reference Numeral | Element |
|---:|---|
| 100 | Conflict-calibrated runtime authority compiler system |
| 102 | Frozen task-state builder |
| 104 | Proposal collector |
| 106 | Canonical graph builder |
| 108 | Candidate operation universe builder |
| 110 | Binary authorization resolver |
| 112 | Authority packet synthesizer |
| 114 | Certificate builder |
| 116 | Runtime enforcement gate |
| 118 | Replay verifier |
| 120 | Evidence store |
| 122 | Divergence feature extractor |
| 124 | Operation-evidence generator |
| 126 | Dependent-source pooler |
| 128 | Independent-group combiner |
| 130 | Constraint gate |
| 132 | Attempted runtime operation |
| 134 | Normalized operation tuple |
| 136 | Certificate-bound authority packet |
| 138 | Violation report |
| 140 | Replay verification report |

### FIG. 1 - Overall Conflict-Calibrated Runtime Authority Compiler Pipeline


FIG. 1 illustrates, in one embodiment, the full system pipeline. A frozen task-state builder 102 constructs a frozen task-state bundle from task state, policy state, permission state, tool state, environment state, and selector/runtime versions. A proposal collector 104 obtains plural or repeated autonomous-agent proposals against the same frozen task-state hash. A canonical graph builder 106 normalizes the proposals into canonical executable graphs. A candidate operation universe builder 108 extracts candidate operations from the graphs. A binary authorization resolver 110 resolves each candidate operation on a binary authorization frame. Authorized and blocked operations are compiled into an authority packet. A certificate builder 114 binds the authority packet to an execution certificate. A runtime enforcement gate 116 permits only certificate-bound authorized operations before side effects occur. A replay verifier 118 reconstructs the evidence chain and verifies packet reproducibility and runtime compliance.

### FIG. 2 - Canonical Graph Normalization and Candidate Operation Extraction


FIG. 2 illustrates, in one embodiment, conversion of raw proposals into canonical executable graphs and extraction of candidate runtime operations. Raw proposals may include natural-language plans, tool-call plans, command plans, dry-run traces, reviewer-agent plans, or human-edited candidate plans. Each proposal is normalized into typed operation nodes and typed dependency, policy, approval, side-effect, and evidence edges. The canonical graphs are serialized using a deterministic ordering rule and hashed. Distinct executable operations appearing in at least one proposal graph, required by policy, required by dependency closure, or required by evidence generation are extracted into a candidate operation universe.

### FIG. 3 - Divergence Feature Extraction


FIG. 3 illustrates, in one embodiment, extraction of operational divergence features from plural canonical executable graphs. A graph equivalence and difference engine identifies equivalent portions, divergent tests, divergent commands, divergent file writes, divergent tool calls, divergent approvals, divergent evidence obligations, divergent environment assumptions, and divergent side-effect boundaries. These divergences may be classified as D0-D11 or other configured divergence classes. The divergence classes are not themselves final authorization decisions; instead, they become evidence features, constraint triggers, threshold-profile selectors, or selector inputs for operation-level authorization resolution.

### FIG. 3A - Operation-Level Binary Authorization Resolution


FIG. 3A illustrates, in one embodiment, operation-level authority resolution. Candidate operations extracted from canonical executable proposal graphs are each mapped to a binary authorization frame comprising AUTHORIZE and WITHHOLD. Proposal-graph evidence items are assigned direction, strength, source reliability, relevance, and independence-group identifiers. Dependent evidence items are pooled into group evidence summaries. Independent group summaries are combined to compute authorization mass, conflict, internal tension, direction-aligned source coverage, direction-aligned quantity coverage, ambiguity-adjusted anchor strength, and review risk. A constraint gate applies policy, permission, approval, side-effect, evidence, and environment constraints. The authority resolution engine marks each candidate operation as authorized, blocked, or review-required.

### FIG. 4 - Authority Packet and Certificate Binding


FIG. 4 illustrates, in one embodiment, synthesis of the authority packet and binding to an execution certificate. The authority packet may include authorized operations, blocked operations, argument constraints, approval requirements, evidence requirements, environment requirements, side-effect boundaries, expiry, selector version, threshold profile, graph-set commitment, and packet hash. The execution certificate binds the authority packet to frozen task-state hash, ordered graph-set commitment, authorization evidence commitment, policy manifest hash, permission manifest hash, tool manifest hash, environment digest, runtime gate version, expiry, and optional signature.

### FIG. 5 - Runtime Gate Matching Attempted Operation Against Authority Packet


FIG. 5 illustrates, in one embodiment, runtime enforcement. Before an attempted operation produces a side effect, the runtime enforcement gate receives the operation and canonicalizes it into a normalized operation tuple. The tuple may include operation type, target, arguments, tool identifier, side-effect class, required approval, environment digest, and evidence obligation. The gate verifies the execution certificate, checks packet expiry and environment constraints, and compares the canonicalized attempted operation against the certificate-bound authority packet. Matching operations are permitted and recorded. Operations absent from the authority packet, exceeding argument constraints, lacking approval, lacking evidence hooks, violating environment constraints, or exceeding side-effect boundaries are blocked and recorded in a violation report.

### FIG. 6 - Replay Verification Evidence Chain


FIG. 6 illustrates, in one embodiment, replay verification. A replay verifier 118 reconstructs the frozen task-state bundle, proposal set, canonical executable graphs, ordered graph-set commitment, candidate operation universe, operation-evidence items, group evidence summaries, authorization masses, conflict states, threshold profile, authority packet, execution certificate, runtime trace, blocked-operation reports, environment manifest, evidence artifacts, and audit log. The verifier confirms that the same frozen task-state bundle, graph commitments, authorization evidence, and selector versions reproduce the same authority packet; that the certificate binds the correct authority packet; and that observed runtime execution remained within the certificate-bound authority packet.

---

## 7. Detailed Description

### 7.1 Overview

The disclosed system controls autonomous-agent execution by resolving candidate runtime operations before side effects occur. A proposal may contain one or more executable operations, such as test execution, command execution, file writing, API calls, database operations, ticket creation, approval requests, or credential access. The system does not allow an operation merely because an agent proposed it. Each operation must be evaluated as a candidate runtime operation under a binary authorization frame.

The system may operate before execution, during dry-run execution, inside a CI/CD pipeline, inside an enterprise automation control plane, through a local shell wrapper, as an agent-framework middleware component, or as a runtime gateway between an agent and the external systems it can affect.

### 7.2 Frozen Task-State Bundle

A frozen task-state builder constructs a canonical task-state bundle. The bundle may include:

- task object;
- task hash;
- repository commit or tree hash;
- changed-file manifest;
- dependency graph;
- test inventory;
- source-to-test map;
- coverage map;
- database schema version;
- query plan snapshot;
- policy manifest;
- permission manifest;
- tool manifest;
- context manifest;
- retrieval snapshot;
- external data snapshot;
- environment digest;
- model configuration hash;
- prompt template hash;
- approval state;
- risk class;
- selector version;
- threshold profile;
- runtime-gate version;
- expiry or freshness metadata.

The bundle may be serialized using canonical JSON, deterministic CBOR, canonical CBOR, or another stable representation. The system may generate a frozen task-state hash. Candidate proposals are compared only when associated with the same frozen task-state hash or an accepted equivalent frozen state.

### 7.3 Proposal Collection

A proposal collector obtains plural candidate proposals associated with the frozen task-state bundle. The proposals may come from:

- repeated runs of the same autonomous agent;
- multiple autonomous agents;
- multiple LLMs;
- multiple model configurations;
- reviewer agents;
- dry-run tool traces;
- human-edited candidate plans;
- policy-generated candidate plans;
- combinations of machine and human sources.

Each proposal may be stored with the frozen task-state hash, source identity, model configuration, prompt-template hash, timestamp, retrieval snapshot identifier, dry-run trace identifier, and independence-group metadata.

### 7.4 Canonical Executable Graphs

Each proposal is normalized into a canonical executable graph. The graph represents executable meaning rather than wording.

Example node types include:

- PLAN_STEP;
- TEST_RUN;
- COMMAND_EXEC;
- FILE_READ;
- FILE_WRITE;
- PATCH_APPLY;
- API_CALL;
- TOOL_CALL;
- DATABASE_READ;
- DATABASE_WRITE;
- NETWORK_CALL;
- TICKET_CREATE;
- TICKET_UPDATE;
- APPROVAL_REQUEST;
- APPROVAL_VERIFY;
- CREDENTIAL_ACCESS;
- RETRIEVAL_ACCESS;
- POLICY_CHECK;
- EVIDENCE_EMIT;
- ARTIFACT_HASH;
- SIDE_EFFECT_BOUNDARY;
- RUNTIME_ASSERTION.

Example edge types include:

- ORDER_BEFORE;
- DATA_DEPENDS_ON;
- FILE_DEPENDS_ON;
- POLICY_DEPENDS_ON;
- APPROVAL_DEPENDS_ON;
- TOOL_DEPENDS_ON;
- ENV_DEPENDS_ON;
- TEST_COVERS;
- ARTIFACT_PRODUCES;
- SIDE_EFFECT_REQUIRES;
- CERTIFICATE_BINDS.

A canonical executable graph may be represented as a sorted adjacency structure. Operation nodes may be keyed by a normalized tuple comprising normalized operation type, normalized target, normalized arguments, side-effect class, required authority, required approval state, evidence obligation, environment constraint, and policy tag. Edges may be sorted by typed dependency relation. The serialized graph may be hashed to produce a graph commitment.

### 7.5 Graph Equivalence Rules

In one embodiment, two canonical executable graph nodes are equivalent only if their normalized operation type, normalized target, normalized argument set, side-effect class, required authority, required approval state, evidence obligation, environment constraint, and policy tag match under a versioned equivalence rule.

Two graph edges are equivalent only if their source node commitment, target node commitment, edge type, dependency condition, and policy/evidence annotation match under the same versioned equivalence rule.

Two graphs are operationally equivalent when their sorted node commitments and sorted edge commitments match, or when a versioned equivalence rule identifies one graph as a permitted refinement of another without changing authorized side effects, required approvals, evidence obligations, environment constraints, policy tags, or runtime authority.

---

## 8. Core System Components

In one embodiment, the system comprises:

1. 100 Conflict-calibrated runtime authority compiler system  
2. 102 Frozen task-state builder  
3. 104 Proposal collector  
4. 106 Canonical graph builder  
5. 108 Candidate operation universe builder  
6. 110 Binary authorization resolver  
7. 112 Authority packet synthesizer  
8. 114 Certificate builder  
9. 116 Runtime enforcement gate  
10. 118 Replay verifier  
11. 120 Evidence store  
12. 122 Divergence feature extractor  
13. 124 Operation-evidence generator  
14. 126 Dependent-source pooler  
15. 128 Independent-group combiner  
16. 130 Constraint gate  

### 8.1 Candidate Operation Universe

The system extracts a candidate operation universe from the plural canonical executable proposal graphs. The candidate operation universe includes each distinct executable operation that appears in at least one proposal graph, is required by policy, is required by a dependency rule, or is necessary for evidence generation.

Each candidate operation may include:

- operation type;
- normalized target;
- normalized arguments;
- tool identifier;
- side-effect class;
- required authority;
- approval requirement;
- evidence obligation;
- environment requirement;
- policy tag;
- source proposal identifiers;
- graph-node commitments.

A candidate operation is not authorized merely because it appears in a proposal graph. Each candidate operation is separately evaluated as a binary authorization proposition before it may enter the authority packet.

### 8.2 Formal Definition of Side Effect

A side effect includes any operation that modifies a file, repository, database, remote service, ticket, access-control system, workflow state, runtime environment, external API state, credential state, network-visible resource, user-visible artifact, approval state, persistent log, or other persistent system state, or that causes another system to perform such a modification.

A side effect may also include an operation that sends network traffic, accesses credentials, triggers an external workflow, causes another process to execute, changes system permissions, modifies evidence state, or exposes data outside an authorized boundary.

---

## 9. Operation-Level Binary Authorization Resolution

### 9.1 Binary Authorization Frame for Candidate Operations

For each candidate runtime operation \(o\), the system constructs a binary authorization frame:

\[
\Theta_o = \{AUTHORIZE_o, WITHHOLD_o\}
\]

`AUTHORIZE_o` means that operation \(o\) may be included in the authority packet. `WITHHOLD_o` means that operation \(o\) is not authorized for inclusion absent review, approval, policy override, or some other resolution artifact.

The system evaluates each candidate operation independently on its own authorization frame. Proposal-graph content supporting inclusion of \(o\) contributes evidence toward `AUTHORIZE_o`. Proposal-graph content opposing inclusion of \(o\), proposing incompatible alternatives, omitting \(o\) in favor of a safer operation, identifying policy inconsistency, or showing missing evidence may contribute evidence toward `WITHHOLD_o` or may create a hard constraint record. Neutral or unrelated proposal content contributes ignorance and does not count as directional authorization support.

### 9.2 Operation-Evidence Items

For a candidate operation, the system generates operation-evidence items from canonical executable graphs, graph differences, policies, permissions, tool manifests, approval state, environment state, and evidence obligations.

Each operation-evidence item may include:

- candidate operation identifier;
- direction: AUTHORIZE, WITHHOLD, or NEUTRAL;
- strength value;
- relevance value;
- source reliability value;
- independence-group identifier;
- source proposal identifier;
- graph node commitment;
- explanation;
- whether the item is an evidence item or a hard constraint.

An effective evidence weight may be computed as:

\[
w_e = clamp(strength_e \times sourceReliability_e \times relevance_e, 0, 1)
\]

Reliability is included in the effective evidence weight and should not be multiplied again into authorization mass, anchor strength, operation confidence, or packet confidence.

### 9.2A Operation-Evidence Direction Mapping

In one embodiment, proposal-graph events are mapped to operation-evidence directions as follows.

| Proposal-Graph Event | Evidence Direction |
|---|---|
| Proposal graph includes candidate operation with matching normalized tuple | AUTHORIZE evidence |
| Proposal graph includes narrower compatible operation | AUTHORIZE evidence for narrower operation; WITHHOLD evidence for broader operation |
| Proposal graph includes incompatible alternative operation | WITHHOLD evidence for conflicting operation |
| Proposal graph omits an optional operation without proposing an alternative | NEUTRAL evidence |
| Proposal graph omits an operation required by policy, dependency closure, or evidence generation | WITHHOLD evidence or constraint trigger |
| Proposal graph includes operation but lacks required evidence hooks | WITHHOLD evidence or evidence constraint trigger |
| Proposal graph includes operation prohibited by policy or permission state | Hard constraint, not ordinary evidence mass |
| Proposal graph includes operation exceeding side-effect boundary | Hard constraint or WITHHOLD evidence depending on threshold profile |

This mapping makes proposal-graph evidence functional rather than merely descriptive. The same proposal event may create evidence, trigger a constraint, or both, depending on the configured threshold profile, policy manifest, permission state, and evidence requirements.

### 9.3 Consensus Is an Evidence Feature, Not the Final Decision

Consensus status is treated as an operation-evidence feature, not as the final authorization decision. An operation that appears in multiple proposal graphs may still be blocked if independent conflict is high, evidence anchoring is weak, direction-aligned authorization coverage is insufficient, an evidence obligation is missing, an environment requirement fails, or a hard constraint prohibits the operation.

An operation that appears in fewer than all proposals may still be authorized if policy requires it, if dependency closure requires it, if it is low-risk and evidence-supported, or if approval and evidence requirements are satisfied.

### 9.4 Dependent Proposal-Source Pooling

Operation-evidence items sharing an independence group are treated as dependent. Repeated proposals from the same agent, same model route, same prompt template, same retrieval snapshot, same reviewer agent, same dry-run source, or same human-edited source may be assigned to the same independence group unless expressly marked independent.

Evidence inside one independence group is pooled into a group evidence summary before cross-group combination. The system does not apply independent-source combination inside one dependent group. This prevents repeated runs of the same agent or same model route from being counted as independent authorization sources.

A dependent group may compute an AUTHORIZE peak, a WITHHOLD peak, a resolved margin, a relative clarity value, an internal tension value, and a coverage-facing quantity. If the group is semantically unresolved, the group may be pooled to ignorance with internal tension and may not count toward direction-aligned authorization coverage.

### 9.4A Group Evidence Summary Structure

In one embodiment, each group evidence summary comprises:

- candidate operation identifier;
- independence-group identifier;
- authorize peak value;
- withhold peak value;
- resolved direction: AUTHORIZE, WITHHOLD, or UNDETERMINED;
- resolved margin;
- relative clarity;
- internal tension;
- group authorization mass;
- source-resolved flag;
- coverage-facing quantity;
- explanation;
- group summary hash.

The group summary hash may be included in the authorization evidence commitment. A group that is unresolved may contribute uncertainty and internal tension but may be excluded from direction-aligned authorization coverage.

### 9.5 Independent Proposal-Group Combination

After dependent pooling, group evidence summaries from independent groups are combined. In one embodiment, a Dempster-Shafer style binary combination is applied across independent group summaries. The combination produces an authorization mass comprising:

- mass assigned to AUTHORIZE;
- mass assigned to WITHHOLD;
- mass assigned to uncertainty or ignorance;
- independent-source conflict;
- accumulated internal tension;
- combination status.

If independent proposal-group combination enters total-conflict fallback, the candidate operation is marked `BLOCKED_FOR_CONFLICT` or `REVIEW_REQUIRED`. The fallback state is not treated as ordinary ignorance and is not used to authorize the operation.

A total-conflict fallback may be recorded in the authority evidence chain, certificate evidence commitment, replay report, and blocked-operation reason code.

### 9.6 Direction-Aligned Authorization Coverage

For a candidate operation, only resolved independent proposal groups aligned with the final AUTHORIZE direction increase authorization source coverage or authorization quantity coverage. Groups aligned with WITHHOLD remain available for conflict, review risk, false-compromise detection, and blocked-operation explanation, but they do not increase authorization coverage.

This prevents a large number of conflicting proposal groups from being misinterpreted as support for authorizing the operation.

### 9.7 Constraint Gate

Constraints are logical predicates, not evidence masses. A constraint may be derived from policy, permission, approval state, side-effect class, environment state, evidence obligation, certificate requirement, or domain-specific rule.

A candidate operation may be blocked or marked review-required if:

- it is prohibited by policy;
- it exceeds permission scope;
- required approval is absent;
- evidence obligations are unsatisfied;
- environment digest does not match;
- side-effect class exceeds allowed threshold;
- credential access is unauthorized;
- database or API mutation is disallowed;
- runtime gate cannot enforce the operation;
- certificate binding cannot be generated.

### 9.8 Authority Resolution Engine

The authority resolution engine determines whether each candidate operation is authorized, blocked, or review-required from:

- authorization mass;
- dominant authorization direction;
- conflict state;
- internal tension;
- direction-aligned source coverage;
- direction-aligned quantity coverage;
- evidence obligation state;
- hard constraints;
- threshold profile;
- approval state;
- risk class;
- environment state.

Only operations that satisfy authorization direction, coverage, evidence, and constraints are eligible to enter the authorized portion of the authority packet.

### 9.9 Authorization Decision Rule

In one embodiment, the authority resolution engine applies the following deterministic decision rule for each candidate operation.

For candidate operation \(o\), the engine determines:

- combination status;
- dominant authorization direction;
- authorization margin;
- authorization clarity;
- direction-aligned source coverage;
- direction-aligned quantity coverage;
- ambiguity or conflict risk;
- internal tension risk;
- evidence obligation state;
- constraint state;
- approval state;
- environment state.

The candidate operation is marked `AUTHORIZED` only when:

1. the combination status is normal;
2. the dominant authorization direction is `AUTHORIZE`;
3. the authorization margin satisfies a configured minimum margin threshold;
4. the authorization clarity satisfies a configured minimum clarity threshold;
5. direction-aligned source coverage satisfies a configured source-coverage threshold;
6. direction-aligned quantity coverage satisfies a configured quantity-coverage threshold;
7. ambiguity, conflict, and internal tension are below configured review thresholds;
8. required evidence hooks are present;
9. required approval state is satisfied;
10. required environment state matches the frozen or certified environment state; and
11. no hard constraint blocks the operation.

The candidate operation is marked `BLOCKED` when a hard constraint prohibits the operation, when total-conflict fallback occurs, when required evidence hooks are absent, when environment state does not match, or when the operation exceeds side-effect, approval, permission, or tool constraints.

The candidate operation is marked `REVIEW_REQUIRED` when authorization evidence is unresolved, direction-aligned coverage is insufficient, conflict or internal tension exceeds a review threshold, or a required policy-resolution artifact is absent.

The decision rule is deterministic because the same frozen task-state bundle, canonical executable graphs, operation-evidence items, independence-group assignments, threshold profile, policy manifest, permission manifest, tool manifest, environment digest, and selector version produce the same authority-resolution output.


---

## 9A. Representative Pseudocode

The following pseudocode illustrates one implementation path. Function names are descriptive and may be implemented using different programming languages, data stores, graph libraries, policy engines, runtime wrappers, or certificate formats.

```text
PROCEDURE BUILD_FROZEN_TASK_STATE(task, repo_or_system_state, policy_manifest,
                                  permission_manifest, tool_manifest,
                                  environment_manifest, approval_state,
                                  selector_version, runtime_gate_version):
    bundle = CANONICALIZE({
        task: task,
        system_state: repo_or_system_state,
        policy_manifest_hash: HASH(policy_manifest),
        permission_manifest_hash: HASH(permission_manifest),
        tool_manifest_hash: HASH(tool_manifest),
        environment_digest: DIGEST(environment_manifest),
        approval_state: approval_state,
        selector_version: selector_version,
        runtime_gate_version: runtime_gate_version
    })
    bundle.hash = HASH(bundle)
    RETURN bundle
```

```text
PROCEDURE NORMALIZE_PROPOSAL_TO_GRAPH(proposal, frozen_bundle):
    graph = NEW CanonicalExecutableGraph()
    FOR EACH proposed_step IN EXTRACT_EXECUTABLE_STEPS(proposal):
        node = NORMALIZE_OPERATION_NODE(proposed_step, frozen_bundle)
        ADD node TO graph.nodes
        FOR EACH dependency IN EXTRACT_DEPENDENCIES(proposed_step):
            edge = NORMALIZE_OPERATION_EDGE(dependency, graph)
            ADD edge TO graph.edges
    graph.nodes = SORT_BY_COMMITMENT(graph.nodes)
    graph.edges = SORT_BY_COMMITMENT(graph.edges)
    graph.graph_hash = HASH(graph)
    RETURN graph
```

```text
PROCEDURE EXTRACT_CANDIDATE_OPERATIONS(graphs, policy_manifest, dependency_rules, evidence_rules):
    universe = EMPTY_SET()
    FOR EACH graph IN graphs:
        FOR EACH operation_node IN graph.nodes:
            ADD NORMALIZED_OPERATION_TUPLE(operation_node) TO universe
    FOR EACH policy_required_operation IN policy_manifest.required_operations:
        ADD policy_required_operation TO universe
    FOR EACH dependency_required_operation IN dependency_rules.required_operations:
        ADD dependency_required_operation TO universe
    FOR EACH evidence_required_operation IN evidence_rules.required_operations:
        ADD evidence_required_operation TO universe
    RETURN DETERMINISTIC_SORT(universe)
```

```text
PROCEDURE GENERATE_OPERATION_EVIDENCE(candidate_operation, graphs, policy_manifest,
                                      permission_manifest, tool_manifest,
                                      evidence_rules, dependence_rules):
    items = []
    FOR EACH graph IN graphs:
        event = COMPARE_OPERATION_TO_GRAPH(candidate_operation, graph)
        direction = MAP_EVENT_TO_AUTHORIZATION_DIRECTION(event, policy_manifest)
        strength = COMPUTE_EVIDENCE_STRENGTH(event)
        relevance = COMPUTE_RELEVANCE(candidate_operation, event)
        reliability = SOURCE_RELIABILITY(graph.source)
        group_id = ASSIGN_INDEPENDENCE_GROUP(graph.source, dependence_rules)
        item = OperationEvidenceItem(candidate_operation.id, direction, strength,
                                     relevance, reliability, group_id, event.explanation)
        ADD item TO items
    FOR EACH hard_constraint IN EVALUATE_HARD_CONSTRAINTS(candidate_operation,
                                                          policy_manifest,
                                                          permission_manifest,
                                                          tool_manifest,
                                                          evidence_rules):
        ADD hard_constraint TO items
    RETURN items
```

```text
PROCEDURE POOL_DEPENDENT_GROUP(operation_evidence_items, threshold_profile):
    groups = GROUP_BY(operation_evidence_items WHERE item.is_constraint == false,
                      item.independence_group)
    summaries = []
    FOR EACH group_id, group_items IN groups:
        directional_items = FILTER_DIRECTIONAL(group_items)
        IF directional_items IS EMPTY:
            CONTINUE
        authorize_peak = MAX_WEIGHT(directional_items WHERE direction == AUTHORIZE)
        withhold_peak = MAX_WEIGHT(directional_items WHERE direction == WITHHOLD)
        margin = ABS(authorize_peak - withhold_peak)
        clarity = RELATIVE_CLARITY(authorize_peak, withhold_peak)
        tension = INTERNAL_TENSION(authorize_peak, withhold_peak)
        resolved_direction = RESOLVE_GROUP_DIRECTION(authorize_peak, withhold_peak,
                                                     margin, clarity, threshold_profile)
        mass = GROUP_MASS(resolved_direction, margin, tension)
        summary = GroupEvidenceSummary(group_id, mass, resolved_direction,
                                       margin, clarity, tension)
        summary.hash = HASH(DETERMINISTIC_SERIALIZE(summary))
        ADD summary TO summaries
    RETURN summaries
```

```text
PROCEDURE COMBINE_INDEPENDENT_GROUPS(group_summaries):
    IF group_summaries IS EMPTY:
        RETURN AuthorizationMass(mAUTHORIZE=0, mWITHHOLD=0, mUNKNOWN=1,
                                 status="normal")
    mass = DIRECT_DEMPSTER_COMBINATION(group_summaries.mass)
    IF mass.status == "total_conflict_fallback":
        RETURN mass  # terminal review/block metadata, not ordinary ignorance
    RETURN mass
```

```text
PROCEDURE RESOLVE_OPERATION_AUTHORITY(candidate_operation, group_summaries, mass,
                                      hard_constraints, threshold_profile,
                                      approval_state, environment_state,
                                      evidence_state):
    dominant = DOMINANT_AUTHORIZATION_DIRECTION(mass, threshold_profile)
    source_coverage = DIRECTION_ALIGNED_SOURCE_COVERAGE(group_summaries, dominant)
    quantity_coverage = DIRECTION_ALIGNED_QUANTITY_COVERAGE(group_summaries, dominant)
    constraint_result = APPLY_CONSTRAINT_GATE(candidate_operation, hard_constraints,
                                              approval_state, environment_state,
                                              evidence_state)

    IF constraint_result.blocks_operation:
        RETURN AuthorityResolutionOutput(candidate_operation, BLOCKED,
                                         reason=constraint_result.reason)
    IF mass.status == "total_conflict_fallback":
        RETURN AuthorityResolutionOutput(candidate_operation, BLOCKED,
                                         reason="total_conflict_fallback")
    IF dominant != AUTHORIZE:
        RETURN AuthorityResolutionOutput(candidate_operation, REVIEW_REQUIRED,
                                         reason="no_authorize_dominant_direction")
    IF source_coverage < threshold_profile.required_source_coverage:
        RETURN AuthorityResolutionOutput(candidate_operation, REVIEW_REQUIRED,
                                         reason="insufficient_direction_aligned_source_coverage")
    IF quantity_coverage < threshold_profile.required_quantity_coverage:
        RETURN AuthorityResolutionOutput(candidate_operation, REVIEW_REQUIRED,
                                         reason="insufficient_direction_aligned_quantity_coverage")
    IF CONFLICT_OR_TENSION_EXCEEDS_REVIEW_THRESHOLD(mass, threshold_profile):
        RETURN AuthorityResolutionOutput(candidate_operation, REVIEW_REQUIRED,
                                         reason="conflict_or_tension_review_required")
    RETURN AuthorityResolutionOutput(candidate_operation, AUTHORIZED)
```

```text
PROCEDURE BUILD_AUTHORITY_PACKET(frozen_bundle, candidate_operations,
                                 authority_outputs, selector_version,
                                 threshold_profile):
    packet = AuthorityPacket()
    packet.frozen_task_state_hash = frozen_bundle.hash
    packet.selector_version = selector_version
    packet.threshold_profile_hash = HASH(threshold_profile)
    packet.authorized_operations = FILTER(authority_outputs, status == AUTHORIZED)
    packet.blocked_operations = FILTER(authority_outputs, status == BLOCKED)
    packet.review_required_operations = FILTER(authority_outputs, status == REVIEW_REQUIRED)
    packet.argument_constraints = COLLECT_ARGUMENT_CONSTRAINTS(authority_outputs)
    packet.approval_requirements = COLLECT_APPROVAL_REQUIREMENTS(authority_outputs)
    packet.evidence_requirements = COLLECT_EVIDENCE_REQUIREMENTS(authority_outputs)
    packet.environment_requirements = COLLECT_ENVIRONMENT_REQUIREMENTS(authority_outputs)
    packet.side_effect_boundaries = COLLECT_SIDE_EFFECT_BOUNDARIES(authority_outputs)
    packet.hash = HASH(DETERMINISTIC_SERIALIZE(packet))
    RETURN packet
```

```text
PROCEDURE BUILD_EXECUTION_CERTIFICATE(frozen_bundle, graph_set_commitment,
                                      authorization_evidence_commitment,
                                      authority_packet, policy_manifest,
                                      permission_manifest, tool_manifest,
                                      environment_digest, runtime_gate_version,
                                      expiry, issuer_key):
    cert = ExecutionCertificate()
    cert.frozen_task_state_hash = frozen_bundle.hash
    cert.graph_set_commitment = graph_set_commitment
    cert.authorization_evidence_commitment = authorization_evidence_commitment
    cert.authority_packet_hash = authority_packet.hash
    cert.policy_manifest_hash = HASH(policy_manifest)
    cert.permission_manifest_hash = HASH(permission_manifest)
    cert.tool_manifest_hash = HASH(tool_manifest)
    cert.environment_digest = environment_digest
    cert.runtime_gate_version = runtime_gate_version
    cert.expiry = expiry
    cert.signature = SIGN(DETERMINISTIC_SERIALIZE(cert WITHOUT signature), issuer_key)
    RETURN cert
```

```text
PROCEDURE ENFORCE_ATTEMPTED_OPERATION(attempted_operation, certificate,
                                      authority_packet, current_environment,
                                      evidence_hooks):
    IF VERIFY_CERTIFICATE(certificate) == false:
        RETURN BLOCK("invalid_certificate")
    IF IS_EXPIRED(certificate):
        RETURN BLOCK("expired_certificate")
    IF DIGEST(current_environment) != certificate.environment_digest:
        RETURN BLOCK("environment_digest_mismatch")
    normalized = CANONICALIZE_ATTEMPTED_OPERATION(attempted_operation)
    IF MATCH_AUTHORIZED_OPERATION(normalized, authority_packet) == false:
        RETURN BLOCK("operation_absent_from_authority_packet")
    IF SATISFIES_ARGUMENT_CONSTRAINTS(normalized, authority_packet) == false:
        RETURN BLOCK("argument_constraint_failure")
    IF REQUIRED_EVIDENCE_HOOKS_ACTIVE(normalized, evidence_hooks) == false:
        RETURN BLOCK("required_evidence_hook_inactive")
    RETURN PERMIT_AND_RECORD(normalized)
```

```text
PROCEDURE VERIFY_REPLAY(frozen_bundle, proposal_graphs, candidate_operations,
                        evidence_items, group_summaries, authority_outputs,
                        authority_packet, certificate, runtime_trace):
    recomputed_graph_set = HASH_ORDERED_GRAPHS(proposal_graphs)
    recomputed_evidence_commitment = HASH_AUTHORIZATION_EVIDENCE(
        candidate_operations, evidence_items, group_summaries, authority_outputs)
    recomputed_packet = BUILD_AUTHORITY_PACKET(frozen_bundle, candidate_operations,
                                               authority_outputs,
                                               authority_packet.selector_version,
                                               authority_packet.threshold_profile)
    ASSERT recomputed_graph_set == certificate.graph_set_commitment
    ASSERT recomputed_evidence_commitment == certificate.authorization_evidence_commitment
    ASSERT recomputed_packet.hash == certificate.authority_packet_hash
    ASSERT RUNTIME_TRACE_WITHIN_PACKET(runtime_trace, authority_packet)
    RETURN ReplayVerificationReport(status="verified")
```

---

## 9B. Representative Data Schemas

The following schemas are illustrative. Fields may be omitted, renamed, extended, serialized differently, or represented in database tables, object stores, evidence bundles, or signed records.

```text
STRUCT FrozenTaskStateBundle:
    task_id
    task_representation
    task_hash
    repository_commit_or_system_state_hash
    changed_file_manifest_hash
    dependency_graph_hash
    policy_manifest_hash
    permission_manifest_hash
    tool_manifest_hash
    retrieval_snapshot_hash
    approval_state_hash
    environment_digest
    selector_version
    threshold_profile_version
    runtime_gate_version
    expiry
    frozen_task_state_hash
```

```text
STRUCT CanonicalExecutableGraph:
    graph_id
    frozen_task_state_hash
    proposal_id
    source_identifier
    source_route
    nodes: list of OperationNode
    edges: list of OperationEdge
    serialization_format
    graph_hash
```

```text
STRUCT OperationNode:
    node_id
    operation_type
    normalized_target
    normalized_arguments
    tool_identifier
    side_effect_class
    required_authority
    approval_requirement
    evidence_obligation
    environment_requirement
    policy_tag
    node_hash
```

```text
STRUCT OperationEdge:
    edge_id
    source_node_hash
    target_node_hash
    edge_type
    dependency_condition
    policy_annotation
    evidence_annotation
    edge_hash
```

```text
STRUCT CandidateOperation:
    candidate_operation_id
    normalized_operation_tuple
    operation_type
    normalized_target
    normalized_arguments
    tool_identifier
    side_effect_class
    required_authority
    approval_requirement
    evidence_obligation
    environment_requirement
    policy_tag
    source_proposal_ids
    graph_node_commitments
```

```text
STRUCT OperationEvidenceItem:
    evidence_item_id
    candidate_operation_id
    source_graph_id
    proposal_id
    direction: AUTHORIZE / WITHHOLD / NEUTRAL
    strength
    relevance_value
    source_reliability_value
    independence_group_identifier
    event_type
    is_constraint
    explanation
    evidence_item_hash
```

```text
STRUCT GroupEvidenceSummary:
    candidate_operation_id
    independence_group_identifier
    authorize_peak_value
    withhold_peak_value
    resolved_direction: AUTHORIZE / WITHHOLD / UNDETERMINED
    resolved_margin
    relative_clarity
    internal_tension
    group_authorization_mass
    source_resolved_flag
    coverage_facing_quantity
    explanation
    group_summary_hash
```

```text
STRUCT AuthorityResolutionOutput:
    candidate_operation_id
    authorization_mass
    dominant_authorization_direction
    authorization_margin
    authorization_clarity
    direction_aligned_source_coverage
    direction_aligned_quantity_coverage
    conflict_state
    internal_tension_state
    ambiguity_or_review_risk
    constraint_state
    approval_state
    environment_state
    evidence_obligation_state
    final_status: AUTHORIZED / BLOCKED / REVIEW_REQUIRED
    reason_codes
    output_hash
```

```text
STRUCT AuthorityPacket:
    packet_id
    frozen_task_state_hash
    ordered_graph_set_commitment
    authorization_evidence_commitment
    selector_version
    threshold_profile_version
    authorized_operations
    blocked_operations
    review_required_operations
    argument_constraints
    approval_requirements
    evidence_requirements
    environment_requirements
    side_effect_boundaries
    expiry
    authority_packet_hash
```

```text
STRUCT ExecutionCertificate:
    certificate_id
    frozen_task_state_hash
    ordered_graph_set_commitment
    authorization_evidence_commitment
    authority_packet_hash
    policy_manifest_hash
    permission_manifest_hash
    tool_manifest_hash
    environment_digest
    selector_version
    threshold_profile_version
    runtime_gate_version
    expiry
    issuer_identity
    signature_algorithm
    certificate_signature
```

```text
STRUCT RuntimeTraceEntry:
    trace_entry_id
    attempted_operation_raw
    normalized_operation_tuple
    certificate_id
    authority_packet_hash
    gate_decision: PERMITTED / BLOCKED
    decision_reason
    evidence_hooks_active
    environment_digest_at_attempt
    timestamp
    trace_entry_hash
```

```text
STRUCT ReplayVerificationReport:
    replay_report_id
    frozen_task_state_hash
    recomputed_graph_set_commitment
    recomputed_authorization_evidence_commitment
    recomputed_authority_packet_hash
    certificate_authority_packet_hash
    runtime_trace_hash
    verification_status: VERIFIED / REJECTED / REVIEW_REQUIRED
    rejection_reasons
    replay_report_hash
```

---
## 10. Authority Packet Synthesis

The system synthesizes an authority packet from operation-level authority resolution outputs.

The packet may include:

- frozen task-state hash;
- ordered graph-set commitment;
- authorization evidence commitment;
- threshold profile version;
- selector version;
- authorized operations;
- blocked operations;
- review-required operations;
- blocked-operation reason codes;
- argument constraints;
- approval requirements;
- evidence requirements;
- environment requirements;
- tool constraints;
- side-effect boundaries;
- expiry;
- packet hash.

The authority packet is synthesized from operation-level authority resolution, with divergence classes used as evidence features, constraint triggers, or threshold-profile selectors.

### 10.1 Divergence Classes as Authority-Resolution Features

Operational divergence classes remain useful. They may be used to generate candidate operations, classify evidence features, trigger constraints, select threshold profiles, or route operations into specialized selector rules.

Representative divergence classes include:

- D0 no executable divergence;
- D1 surface divergence;
- D2 planning decomposition divergence;
- D3 test-selection divergence;
- D4 action-selection divergence;
- D5 policy divergence;
- D6 evidence divergence;
- D7 security/compliance divergence;
- D8 environment divergence;
- D9 retrieval/external-state divergence;
- D10 model-routing divergence;
- D11 timing/concurrency divergence.

The divergence class does not by itself authorize an operation. The candidate operation must pass binary authorization resolution, evidence anchoring, direction-aligned coverage requirements, conflict guards, and hard constraints before it enters the authority packet.

---

## 11. Certificate Binding

An execution certificate binds the authority packet to the inputs and evidence that produced it.

In one embodiment, the execution certificate comprises:

```text
certificate:
  certificate_id
  frozen_task_state_hash
  ordered_graph_set_commitment
  candidate_operation_universe_hash
  authorization_evidence_commitment
  divergence_report_hash
  threshold_profile_version
  selector_version
  authority_packet_hash
  policy_manifest_hash
  permission_manifest_hash
  tool_manifest_hash
  environment_digest
  runtime_gate_version
  expiry
  issuer_identity
  signature_algorithm
  certificate_signature
  evidence_commitment
```

The runtime gate rejects the certificate if any bound hash, version, expiry, signature, environment digest, graph-set commitment, authorization evidence commitment, or authority packet hash fails verification.


An authorization evidence commitment may comprise a deterministic commitment to the candidate operation universe, operation-evidence items, independence-group assignments, group evidence summaries, authorization masses, constraint records, threshold profile, and authority-resolution outputs. In one embodiment, the commitment is generated by hashing a deterministically ordered serialization of those objects.

The certificate does not merely approve an agent. It binds a specific authority packet to a specific frozen task state, graph-set commitment, authorization evidence chain, policy state, permission state, tool state, environment digest, selector version, and runtime gate version.

---

## 12. Runtime Enforcement

The runtime enforcement gate mediates execution before side effects occur.

Before an attempted operation executes, the gate may:

1. receive the attempted runtime operation;
2. canonicalize the attempted operation into a normalized operation tuple;
3. verify the execution certificate;
4. check packet expiry;
5. check environment constraints;
6. check approval requirements;
7. check tool and argument constraints;
8. check evidence-hook status;
9. compare the canonicalized attempted operation to the certificate-bound authority packet;
10. permit matching operations;
11. block out-of-packet operations;
12. record runtime evidence or violation evidence.

### 12.1 Attempted Operation Matching

A normalized attempted-operation tuple may include:

- operation type;
- target;
- arguments;
- tool identifier;
- side-effect class;
- required approval;
- environment digest;
- evidence obligation.

An attempted operation is permitted only when the tuple matches an authorized operation in the certificate-bound authority packet and satisfies applicable argument constraints, approval requirements, evidence requirements, environment requirements, and side-effect boundaries.

### 12.2 Bypass-Resistance Examples

The runtime gate may block attempts to evade the authority packet through syntactic variation.

**Tool aliasing:** `python -m pytest tests/auth/test_tokens.py` canonicalizes to the same COMMAND_EXEC test operation class as a direct pytest invocation and is blocked if `tests/auth/test_tokens.py` is not authorized.

**Path variation:** `./tests/auth/../auth/test_tokens.py` canonicalizes to `tests/auth/test_tokens.py` and is blocked if absent from the packet.

**Argument smuggling:** `pytest tests/auth/test_session.py --ignore-policy --network` is blocked when the argument set exceeds the packet’s allowed argument constraints or introduces unauthorized side effects.

**Shell expansion:** `pytest tests/auth/*.py` is expanded into concrete test targets or conservatively blocked unless every expanded test target is authorized by the authority packet.

**Environment drift:** an operation is blocked when the current environment digest differs from the environment digest bound to the execution certificate.

**Evidence bypass:** an otherwise authorized operation is blocked when command tracing, artifact hashing, test-output logging, or other required evidence hooks are inactive.

**Side-effect laundering:** a nominally allowed command is blocked if its normalized side-effect class includes unauthorized network access, credential access, database operation, file write, ticket modification, process spawning, or external API mutation.

---

## 13. Replay Verification

The replay verifier reconstructs the authority chain.

It may reconstruct:

- frozen task-state bundle;
- proposal set;
- canonical executable graphs;
- ordered graph-set commitment;
- candidate operation universe;
- operation-evidence items;
- dependent group evidence summaries;
- independent group combination outputs;
- authorization mass per operation;
- conflict states;
- internal tension states;
- direction-aligned coverage values;
- hard constraint records;
- authority resolution outputs;
- authority packet;
- execution certificate;
- runtime trace;
- blocked-operation reports;
- environment manifest;
- evidence artifacts;
- audit log.

The verifier may reject verification when:

- a recomputed graph-set commitment differs from the certificate-bound graph-set commitment;
- a recomputed authorization evidence commitment differs from the certificate-bound evidence commitment;
- the same frozen task-state bundle, selector version, and threshold profile do not reproduce the same authority packet hash;
- a permitted runtime operation does not correspond to an authorized operation in the certificate-bound authority packet;
- a blocked operation lacks a corresponding violation report;
- required evidence hooks were inactive;
- the environment digest did not match.

---

## 14. Examples

### 14.1 Coding-Agent Example

A coding agent receives a task to fix a bug in an authentication module. The frozen task-state bundle includes a repository commit hash, changed-file manifest, dependency graph, test inventory, source-to-test map, policy manifest, permission manifest, tool manifest, environment digest, selector version, and runtime gate version.

Proposal A includes a write to `auth/session.py` and test executions for `test_session.py` and `test_login.py`.

Proposal B includes a write to `auth/session.py`, a write to `auth/tokens.py`, all authentication tests, and integration tests.

Proposal C includes a write to `auth/session.py` and only `test_session.py`.

The system extracts candidate operations:

1. write `auth/session.py`;
2. write `auth/tokens.py`;
3. run `test_session.py`;
4. run `test_login.py`;
5. run integration authentication tests.

For each candidate operation, the system constructs an AUTHORIZE/WITHHOLD frame. Proposal graph evidence supporting, opposing, omitting, or conflicting with each candidate operation is grouped, pooled, combined, and constrained.

The write to `auth/session.py` may be authorized because it is supported by all proposals, has matching patch hash, satisfies evidence obligations, and does not violate policy. The write to `auth/tokens.py` may be blocked because it is a non-consensus side-effecting operation, lacks direction-aligned coverage, and is not approved. The integration tests may be blocked or review-required depending on policy-selected test scope and environment constraints.


#### 14.1A Worked Operation-Level Trace

Candidate operation: `FILE_WRITE auth/tokens.py`

| Evidence Source | Proposal-Graph Event | Direction / Treatment | Illustrative Group |
|---|---|---|---|
| Proposal A | Omits `auth/tokens.py` write | NEUTRAL or WITHHOLD depending on threshold profile | model_route_A |
| Proposal B | Includes `FILE_WRITE auth/tokens.py` with `PATCH_B` | AUTHORIZE evidence, strength 0.80 | model_route_B |
| Proposal C | Omits `auth/tokens.py` write | NEUTRAL or WITHHOLD depending on threshold profile | model_route_C |

Resolution for `FILE_WRITE auth/tokens.py`:

- authorize support appears in one proposal group only;
- direction-aligned authorization coverage is below the configured threshold;
- the side-effect class is `SOURCE_MODIFICATION`;
- no approval token authorizes expansion of the authority packet;
- required evidence may be available, but evidence alone does not override insufficient authorization coverage or side-effect constraints;
- result: `BLOCKED`;
- blocked reason: `insufficient_direction_aligned_authorization_coverage` and/or `non_consensus_side_effecting_operation`.

This trace illustrates that an operation is not authorized merely because one proposal graph includes it. The operation must satisfy operation-level authorization resolution, coverage requirements, constraint checks, approval state, evidence obligations, environment requirements, and side-effect boundaries before it can enter the authority packet.

The authority packet authorizes only permitted operations. The runtime gate blocks attempts outside the packet.

### 14.2 Enterprise Onboarding Example

An enterprise onboarding agent receives a task to prepare access for a Level 2 customer-success employee. The frozen bundle includes employee role, employee level, manager approval state, HR policy, identity-system policy, CRM policy, ticketing manifest, permission manifest, tool manifest, environment digest, and selector version.

Proposal A requests Slack access, HR profile update, CRM read-only access, and manager approval before IT ticket submission.

Proposal B requests Slack access, CRM standard access, CRM export permission, and immediate IT ticket submission.

Proposal C requests Slack access, HR profile update, manager approval, and no CRM export permission.

Candidate operations include Slack access request, HR update, CRM read-only access, CRM standard access, CRM export permission, manager approval request, draft IT ticket creation, and final IT ticket submission.

Each operation is resolved separately. CRM export permission may be blocked due to sensitive data, low direction-aligned authorization coverage, and security/compliance constraints. Final IT ticket submission may be withheld until an approval token is present. Slack access request and HR profile update may be authorized if supported and low-risk.


#### 14.2A Worked Enterprise Operation-Level Trace

Candidate operation: `API_CALL crm.provision_access level=standard`

| Evidence Source | Proposal-Graph Event | Direction / Treatment | Illustrative Independence Group |
|---|---|---|---|
| Proposal A | Proposes CRM read-only access | WITHHOLD evidence for standard access; AUTHORIZE evidence for narrower read-only access | model_route_A |
| Proposal B | Proposes CRM standard access | AUTHORIZE evidence for standard access | model_route_B |
| Proposal C | Omits CRM standard access and requests manager approval | WITHHOLD evidence or approval constraint trigger | model_route_C |

Resolution for `crm.provision_access level=standard`:

- authorize support appears in one independent group;
- another group supports only a narrower compatible operation;
- manager approval state is not satisfied;
- side-effect class is `ACCESS_CONTROL_CHANGE`;
- policy requires approval for standard CRM access;
- result: `REVIEW_REQUIRED` or `BLOCKED` depending on policy profile;
- reason codes may include `approval_required`, `insufficient_direction_aligned_authorization_coverage`, and `broader_than_consensus_operation`.

Authority packet consequence:

- authorize `API_CALL crm.request_access level=read_only` if evidence and policy permit;
- authorize `APPROVAL_REQUEST manager_approval`;
- block or withhold `API_CALL crm.provision_access level=standard` until approval token is present.

Runtime consequence:

- an attempted direct CRM standard-access provisioning call is blocked before side effects occur;
- a manager-approval request is permitted and recorded;
- replay verifies that the direct provisioning operation was absent from the certificate-bound authority packet.

### 14.3 Database Maintenance Agent Example

A database maintenance agent receives a task to remediate slow customer-account queries. The frozen task-state bundle includes database schema version, query plan snapshot, permission manifest, tool manifest, approval state, environment digest, policy manifest, selector version, and runtime gate version.

Proposal A recommends creating an index on `customer_id` and running a read-only query benchmark.

Proposal B recommends creating an index on `customer_id`, dropping an unused index, and vacuuming a production table.

Proposal C recommends creating an index on `customer_id` and running a benchmark against a staging replica.

The canonical proposal graphs agree on index creation but diverge on dropping an index, vacuuming a production table, and using production versus staging data. Candidate operations are resolved on binary authorization frames.

The selector may authorize a staging benchmark and a draft migration plan, block production table modification, block dropping the index, and require DBA approval before any production schema change. The runtime gate blocks attempted production database writes absent an approval token and matching environment digest.


#### 14.3A Worked Database Operation-Level Trace

Candidate operation: `DATABASE_WRITE production DROP_INDEX unused_idx`

| Evidence Source | Proposal-Graph Event | Direction / Treatment | Illustrative Independence Group |
|---|---|---|---|
| Proposal A | Omits index drop and proposes read-only benchmark | WITHHOLD evidence for production index drop | model_route_A |
| Proposal B | Proposes dropping unused production index | AUTHORIZE evidence for production index drop | model_route_B |
| Proposal C | Omits index drop and proposes staging benchmark | WITHHOLD evidence for production index drop and AUTHORIZE evidence for staging operation | model_route_C |

Resolution for `DATABASE_WRITE production DROP_INDEX unused_idx`:

- authorize evidence exists in only one independent group;
- two independent groups withhold or choose narrower/staging alternatives;
- side-effect class is `PRODUCTION_DATABASE_MUTATION`;
- no DBA approval token is present;
- production environment digest must match but is insufficient by itself;
- hard constraint requires DBA approval for production schema changes;
- result: `BLOCKED`;
- reason codes may include `hard_constraint_requires_dba_approval`, `insufficient_direction_aligned_authorization_coverage`, and `production_database_mutation_blocked`.

Authority packet consequence:

- authorize staging benchmark if environment digest and evidence hooks match;
- authorize draft migration plan;
- block production index drop;
- block production vacuum operation;
- require approval token for production schema mutation.

Runtime consequence:

- an attempted production `DROP INDEX` operation is canonicalized into a normalized database-write tuple and blocked;
- the violation report records missing DBA approval and absence from the certificate-bound authority packet;
- replay recomputes the same blocked result from the frozen task-state bundle, proposal graphs, evidence commitments, threshold profile, and selector version.

---

## 15. Implementation Variations

The system may be implemented as:

- a local runtime;
- CI/CD controller;
- coding-agent wrapper;
- enterprise-agent control plane;
- policy engine;
- agent sandbox;
- runtime library;
- hosted service;
- on-premises service;
- plugin for agent frameworks;
- governed-agent architecture component.

The runtime gate may be implemented as:

- tool proxy;
- shell wrapper;
- API gateway;
- database proxy;
- file-system monitor;
- CI/CD wrapper;
- agent-framework middleware;
- enterprise-control-plane gateway;
- local runtime supervisor.

The evidence layer may use hashes, signatures, Merkle commitments, immutable logs, transparency logs, local evidence bundles, determinism reports, replay plans, or artifact commitments.

The mechanism may operate with coding agents, DevOps agents, HR onboarding agents, IT access agents, CRM agents, ERP agents, database agents, healthcare workflow agents, banking agents, public-sector agents, defense agents, research automation agents, or regulated workflow agents.

---

## 16. Technical Advantages

The system improves computer operation by replacing nondeterministic runtime action selection by autonomous agents with a deterministic pre-execution authority boundary derived from frozen input state and operation-level proposal-graph evidence.

Technical advantages may include:

- reduction of uncontrolled tool calls;
- reduction of unauthorized file writes;
- reduction of unauthorized API calls;
- reduction of unauthorized database modifications;
- reduction of inconsistent test execution;
- reduction of approval bypass;
- reduction of environment-drift execution;
- improved side-effect control;
- improved replay verification;
- improved evidence anchoring for runtime authority;
- deterministic reproduction of authority packets from frozen inputs and selector versions;
- controlled deployment of nondeterministic autonomous agents in side-effecting environments.

The system improves computer execution control by interposing a certificate-bound runtime gate between nondeterministic autonomous-agent proposal generation and side-effecting execution. The gate changes runtime behavior by blocking file writes, command executions, API calls, ticket creations, database mutations, credential accesses, network calls, process-spawning operations, and other operations unless the attempted operation matches a precompiled certificate-bound authority packet.

The authority packet is not merely a score or advisory output. It is an executable control object that determines which runtime operations are permitted, which operations are blocked, which operations require review, and which evidence, approval, environment, and side-effect conditions must be satisfied before execution.

This is a technical improvement in the control of autonomous-agent execution, not merely a presentation of safety information or a subjective review of agent behavior.

---

## 17. Claim-Like Statements

### Claim 1 — Narrowed Core System Claim

A computer-implemented system for controlling autonomous-agent execution, comprising one or more processors and memory storing instructions that, when executed, cause the system to:

1. construct a frozen task-state bundle for an autonomous-agent task;

2. obtain plural candidate proposals associated with the frozen task-state bundle;

3. normalize the candidate proposals into canonical executable graphs;

4. identify, from the canonical executable graphs, a candidate operation universe comprising candidate runtime operations;

5. for each candidate runtime operation, construct a binary authorization frame comprising an authorize state and a withhold state;

6. generate operation-evidence items from the canonical executable graphs, each operation-evidence item having at least a direction, strength, relevance value, source reliability value, and independence-group identifier;

7. pool operation-evidence items sharing an independence-group identifier into a group evidence summary so that dependent proposal evidence is not counted as independent authorization support;

8. combine group evidence summaries across independent groups to compute an authorization mass, a conflict state, and an internal tension state for the candidate runtime operation;

9. compute direction-aligned authorization coverage for the candidate runtime operation, wherein only independent group evidence summaries aligned with the authorize state increase authorization coverage;

10. apply a constraint gate comprising policy, permission, approval, evidence, environment, and side-effect constraints;

11. determine, from at least the authorization mass, conflict state, internal tension state, direction-aligned authorization coverage, and constraint gate, whether the candidate runtime operation is authorized, blocked, or review-required;

12. synthesize an authority packet comprising authorized operations, blocked operations, argument constraints, approval requirements, evidence requirements, environment requirements, and side-effect boundaries;

13. bind the authority packet to an execution certificate comprising at least a frozen task-state hash, graph-set commitment, authorization evidence commitment, authority packet hash, selector version, environment digest, and runtime-gate version;

14. intercept an attempted runtime operation before the attempted runtime operation produces a side effect;

15. canonicalize the attempted runtime operation into a normalized operation tuple;

16. permit the attempted runtime operation only when the normalized operation tuple matches an authorized operation in the certificate-bound authority packet and satisfies the argument constraints, approval requirements, evidence requirements, environment requirements, and side-effect boundaries; and

17. generate replay evidence verifying that the same frozen task-state bundle, graph commitments, authorization evidence commitment, and selector version reproduce the authority packet and that observed runtime execution remained within the certificate-bound authority packet.

### Claim 2 — Computer-Implemented Method Claim

A computer-implemented method for controlling autonomous-agent execution comprises:

1. freezing task state for an autonomous-agent task;
2. receiving plural candidate proposals associated with the frozen task state;
3. normalizing the plural candidate proposals into canonical executable graphs;
4. extracting a candidate operation universe from the canonical executable graphs;
5. resolving each candidate operation on a binary authorization frame comprising AUTHORIZE and WITHHOLD states;
6. generating operation-evidence items from proposal-graph events;
7. assigning the operation-evidence items to independence groups according to proposal-source dependence;
8. pooling dependent operation-evidence items into group evidence summaries;
9. combining independent group evidence summaries to compute authorization mass, conflict, and internal tension;
10. computing direction-aligned authorization coverage for each candidate operation;
11. applying policy, permission, approval, evidence, environment, and side-effect constraints;
12. marking each candidate operation as authorized, blocked, or review-required;
13. generating an authority packet from the authorized, blocked, and review-required candidate operations;
14. binding the authority packet to an execution certificate;
15. canonicalizing attempted runtime operations before side effects occur;
16. permitting only attempted runtime operations matching authorized operations in the certificate-bound authority packet; and
17. replay-verifying packet reproducibility and runtime compliance.

### Claim 3 — Non-Transitory Computer-Readable Medium Claim

A non-transitory computer-readable medium stores instructions that, when executed by one or more processors, cause the one or more processors to:

1. construct a frozen task-state bundle;
2. normalize plural autonomous-agent proposals into canonical executable graphs;
3. extract candidate runtime operations from the canonical executable graphs;
4. construct a binary authorization frame for each candidate runtime operation;
5. generate operation-evidence items comprising direction, strength, relevance value, source reliability value, and independence-group identifier;
6. pool operation-evidence items within independence groups;
7. combine independent group summaries to compute authorization mass, conflict state, and internal tension state;
8. compute direction-aligned authorization coverage;
9. apply hard constraints comprising policy, permission, approval, evidence, environment, and side-effect constraints;
10. synthesize an authority packet;
11. bind the authority packet to an execution certificate;
12. enforce attempted runtime operations against the certificate-bound authority packet before side effects occur; and
13. generate replay evidence verifying reproduction of the authority packet and compliance of runtime execution.

### Claim 4 — Divergence-Class Selector Embodiment

A computer-implemented system comprises one or more processors and memory storing instructions that, when executed, cause the system to:

1. construct a frozen task-state bundle for an autonomous-agent task;
2. obtain plural candidate proposals associated with the frozen task-state bundle;
3. normalize the candidate proposals into canonical executable graphs;
4. compare the canonical executable graphs to identify graph-level operational differences;
5. classify the graph-level operational differences into operational divergence classes;
6. synthesize, by a versioned deterministic selector, an authority packet using the operational divergence classes to generate operation-evidence items, trigger constraints, select threshold profiles, or route candidate operations into operation-level authorization resolution;
7. generate an execution certificate binding the authority packet to the frozen task-state bundle and graph-set commitment;
8. intercept and canonicalize attempted runtime operations; and
9. permit only attempted runtime operations matching authorized operations in the certificate-bound authority packet.

### Claim 5 — Runtime Matching Method

A computer-implemented method for enforcing deterministic authority for an autonomous agent comprises:

1. receiving an attempted runtime operation before the attempted runtime operation produces a side effect;
2. canonicalizing the attempted runtime operation into a normalized operation tuple comprising operation type, target, arguments, tool identifier, side-effect class, approval requirement, environment digest, and evidence obligation;
3. verifying an execution certificate bound to an authority packet generated from operation-level authorization resolution over plural canonical executable proposal graphs;
4. comparing the normalized operation tuple to authorized operations in the certificate-bound authority packet;
5. permitting the attempted runtime operation only when the normalized operation tuple satisfies an authorized operation, argument constraint, approval requirement, evidence requirement, environment requirement, and side-effect boundary in the certificate-bound authority packet; and
6. blocking the attempted runtime operation otherwise.

### Dependent Claim Ideas

6. The system of claim 1, wherein the frozen task-state bundle comprises at least a task hash, repository commit hash, changed-file manifest hash, policy manifest hash, permission manifest hash, tool manifest hash, environment digest, selector version, threshold profile version, and runtime-gate version.

7. The system of claim 1, wherein a canonical executable graph comprises operation nodes keyed by normalized operation type, normalized target, normalized arguments, tool identifier, side-effect class, approval requirement, evidence obligation, environment requirement, and policy tag.

8. The system of claim 1, wherein a canonical executable graph comprises typed edges representing at least one of order dependency, data dependency, file dependency, policy dependency, approval dependency, evidence dependency, environment dependency, or side-effect requirement.

9. The system of claim 1, wherein graph equivalence requires matching sorted node commitments and sorted edge commitments under a versioned equivalence rule.

10. The system of claim 1, wherein proposal-source dependence is detected from at least one of model route, prompt template, retrieval snapshot, dry-run trace, reviewer source, human-edited source, cached trace, or shared tool context.

11. The system of claim 1, wherein repeated proposals generated by the same model route are assigned to a same independence group.

12. The system of claim 1, wherein proposals generated from a same retrieval snapshot are assigned to a same independence group unless marked independent by metadata.

13. The system of claim 1, wherein a total-conflict fallback causes the candidate runtime operation to be blocked or marked review-required and prevents the fallback from being treated as ordinary uncertainty for authorization.

14. The system of claim 1, wherein direction-aligned source coverage excludes independent group evidence summaries aligned with the withhold state from increasing authorization coverage.

15. The system of claim 1, wherein direction-aligned quantity coverage is computed from coverage-facing quantities of independent group summaries aligned with the authorize state.

16. The system of claim 1, wherein each group evidence summary comprises an authorize peak value, a withhold peak value, a resolved direction, a resolved margin, relative clarity, internal tension, group authorization mass, a source-resolved flag, a coverage-facing quantity, and a group summary hash.

17. The system of claim 1, wherein the runtime enforcement gate blocks an otherwise authorized operation when required tracing, hashing, logging, receipt capture, or evidence hooks are inactive.

18. The system of claim 1, wherein the runtime enforcement gate blocks an attempted operation when a normalized side-effect class of the attempted operation includes an unauthorized file write, network call, credential access, database operation, ticket modification, external API mutation, or process-spawning operation.

19. The system of claim 1, wherein the authority packet comprises an expiry value and the runtime enforcement gate blocks attempted operations after expiry.

20. The system of claim 1, wherein the runtime enforcement gate blocks attempted operations when a current environment digest differs from an environment digest bound to the execution certificate.

21. The system of claim 1, wherein the runtime enforcement gate blocks an attempted operation when command-line arguments exceed an allowed argument set bound to the authority packet.

22. The system of claim 1, wherein the runtime enforcement gate blocks a wildcard, shell-expanded, or dynamically expanded command unless each expanded operation is authorized by the certificate-bound authority packet.

23. The system of claim 1, wherein the runtime enforcement gate canonicalizes file paths to remove relative path segments, symbolic path aliases, or equivalent path encodings before comparing an attempted file operation to the certificate-bound authority packet.

24. The system of claim 1, wherein the runtime enforcement gate canonicalizes tool aliases to a common operation type before comparing an attempted operation to the certificate-bound authority packet.

25. The system of claim 1, wherein the runtime gate is implemented as an API gateway that blocks external API calls absent authorization in the certificate-bound authority packet.

26. The system of claim 1, wherein the runtime gate is implemented as a shell wrapper that blocks command execution absent authorization in the certificate-bound authority packet.

27. The system of claim 1, wherein the runtime gate is implemented as a CI/CD wrapper that blocks tests, commands, deployments, or artifact publication absent authorization in the certificate-bound authority packet.

28. The system of claim 1, wherein the runtime gate is implemented as enterprise workflow middleware that blocks ticket creation, access provisioning, identity-system updates, CRM updates, ERP updates, or HR-system updates absent authorization in the certificate-bound authority packet.

29. The system of claim 1, wherein the replay verifier rejects verification when a recomputed authorization evidence commitment differs from an authorization evidence commitment bound to the execution certificate.

30. The system of claim 1, wherein the replay verifier rejects verification when a recomputed ordered graph-set commitment differs from an ordered graph-set commitment bound to the execution certificate.

31. The system of claim 1, wherein the replay verifier rejects verification when the same frozen task-state bundle, selector version, and threshold profile version do not reproduce the same authority packet hash.

32. The system of claim 1, wherein the authorization evidence commitment comprises a Merkle root over candidate operations, operation-evidence items, group evidence summaries, authorization masses, constraint records, and authority-resolution outputs.

33. The system of claim 1, wherein the execution certificate is signed by an issuer identity and the runtime enforcement gate rejects the certificate if signature verification fails.

34. The system of claim 1, wherein the authority packet includes review-required operations and excludes the review-required operations from runtime permission unless a later approval token expands or reissues the authority packet.

35. The system of claim 1, wherein the constraint gate applies a hard constraint independent of authorization mass when a candidate operation violates policy, permission, approval, side-effect, evidence, environment, legal, security, or compliance predicates.

36. The system of claim 1, wherein operation-evidence direction mapping treats a narrower compatible operation as authorize evidence for the narrower operation and withhold evidence for a broader candidate operation.

37. The system of claim 1, wherein operation-evidence direction mapping treats an incompatible alternative operation as withhold evidence for a conflicting candidate operation.

38. The system of claim 1, wherein an operation required by policy, dependency closure, or evidence generation is added to the candidate operation universe even when absent from all proposal graphs.

39. The system of claim 1, wherein the authority packet binds authorized operations to evidence obligations requiring at least one of command trace hash, artifact hash, diff capture, API receipt, approval token, runtime log, or environment digest.

40. The system of claim 1, wherein the replay verifier verifies that each permitted runtime operation corresponds to an authorized operation in the certificate-bound authority packet and that each blocked runtime operation corresponds to a violation report.

41. The system of claim 1, wherein the system is applied to coding-agent execution and the candidate runtime operations include file writes, patch applications, command executions, test executions, dependency updates, and artifact generation.

42. The system of claim 1, wherein the system is applied to enterprise-agent execution and the candidate runtime operations include access requests, ticket creation, identity-system updates, CRM updates, HR-system updates, approval requests, and API calls.

43. The system of claim 1, wherein the system is applied to database-agent execution and the candidate runtime operations include query execution, schema modification, index creation, index deletion, table vacuuming, and production-data access.
## 18. Abstract

A conflict-calibrated runtime authority compiler for autonomous agents creates deterministic execution authority from nondeterministic agent proposals. The system freezes task state, obtains plural candidate proposals associated with the same frozen task-state hash, converts the proposals into canonical executable graphs, and extracts a universe of candidate runtime operations. For each candidate operation, the system constructs a binary authorization frame having an authorize state and a withhold state, generates operation-evidence items from the proposal graphs, pools dependent evidence by independence group, combines independent group summaries, and evaluates conflict, internal tension, direction-aligned coverage, evidence obligations, and hard constraints. The system compiles authorized and blocked operations into an authority packet, binds the packet to an execution certificate, and uses a runtime gate to block attempted operations outside the certificate-bound packet before side effects occur. A replay verifier 118 reconstructs graph commitments, authorization evidence, packet, certificate, and runtime trace to verify reproducible packet generation and runtime compliance.

---

# Appendix A — Divergence-Class Selector Embodiment and Runtime Gate Details

The divergence-class selector embodiment may be used alone or as a preprocessing, threshold-profile selection, or fallback mechanism for the operation-level binary authorization resolver.

## A.1 Representative Divergence-Treatment Table

| Divergence Class | Example Condition | Representative Treatment |
|---|---|---|
| D0 | Proposal graphs are identical or equivalent | Generate candidate operations with AUTHORIZE evidence |
| D1 | Wording differs but executable graph is equivalent | Ignore wording difference |
| D2 | Intermediate plan differs but executable meaning is equivalent | Preserve final executable operation evidence |
| D3 | Test set, scope, order, or arguments differ | Use as test-selection evidence feature and threshold trigger |
| D4 | Commands, file writes, tool calls, API calls, tickets, or DB operations differ | Use as side-effect risk feature and conflict trigger |
| D5 | Approval, permission, risk, or policy mapping differs | Trigger policy constraint or review-required state |
| D6 | Evidence hooks, traces, replay artifacts, or certificate inputs differ or are missing | Trigger evidence constraint |
| D7 | Credential, sensitive data, regulated records, or compliance boundary differs | Trigger security/compliance constraint |
| D8 | Runtime, dependency, OS, seed state, or environment digest differs | Trigger environment constraint |
| D9 | Retrieval snapshot, API state, live data, or external content differs | Require frozen external-state snapshot |
| D10 | Model, provider, route, or model configuration affects executable graph | Trigger model-route policy treatment |
| D11 | Scheduling, races, order, or timing assumptions differ | Require deterministic schedule or block |

## A.2 Concrete Authority Packet Example

For a coding-agent task having frozen task-state hash `H_TASK_123`, the authority packet may include:

```text
authority_packet:
  frozen_task_state_hash: H_TASK_123
  selector_version: S_4
  threshold_profile_version: TP_2
  ordered_graph_set_commitment: H_GRAPHSET_456
  authorization_evidence_commitment: H_AUTH_EVIDENCE_654
  environment_digest: ENV_456

  authorized_operations:
    - operation_type: FILE_WRITE
      target: auth/session.py
      patch_hash: PATCH_A
      side_effect_class: SOURCE_MODIFICATION
      evidence_required:
        - diff_capture
        - artifact_hash

    - operation_type: COMMAND_EXEC
      tool: pytest
      target: tests/auth/test_session.py
      side_effect_class: TEST_EXECUTION
      evidence_required:
        - test_output_log
        - command_trace_hash

  blocked_operations:
    - operation_type: FILE_WRITE
      target: auth/tokens.py
      reason: insufficient_direction_aligned_authorization_coverage

    - operation_type: COMMAND_EXEC
      tool: pytest
      target: tests/integration/auth
      reason: review_required_or_environment_constraint

  side_effect_boundaries:
    - no network access
    - no writes outside authorized paths
    - no credential access

  packet_hash: H_PACKET_789
```

## A.3 Minimum Implementation Architecture

In one implementation, the system includes:

- proposal ingestion service;
- graph-normalization library;
- graph-comparison library;
- candidate operation universe builder;
- operation-evidence generator;
- dependent evidence pooler;
- independent group combiner;
- conflict/coverage/anchor evaluator;
- constraint gate;
- authority packet builder;
- certificate builder;
- runtime gate;
- replay verifier;
- evidence store.

---

# Appendix B — Mathematical Authority-Resolution Embodiment

This appendix provides one mathematical embodiment of operation-level authorization resolution. The terminology is operation-authorization terminology. AUTHORIZE corresponds to inclusion of a candidate operation in the authority packet. WITHHOLD corresponds to not authorizing the candidate operation absent review or override.

## B.1 Binary Authorization Frame

For candidate operation \(o\), define:

\[
\Theta_o = \{A_o, W_o\}
\]

where:

- \(A_o\): AUTHORIZE operation \(o\);
- \(W_o\): WITHHOLD operation \(o\).

The mechanism uses three focal elements:

\[
\{A_o\},\quad \{W_o\},\quad U_o = \{A_o, W_o\}
\]

A valid mass function satisfies:

\[
m(A_o)+m(W_o)+m(U_o)=1
\]

## B.2 Operation-Evidence Weight

For operation-evidence item \(e\):

\[
w_e=clamp(strength_e \times sourceReliability_e \times relevance_e,0,1)
\]

Supporting evidence assigns mass to AUTHORIZE:

\[
m_e(A_o)=w_e,\quad m_e(W_o)=0,\quad m_e(U_o)=1-w_e
\]

Withholding evidence assigns mass to WITHHOLD:

\[
m_e(A_o)=0,\quad m_e(W_o)=w_e,\quad m_e(U_o)=1-w_e
\]

Neutral evidence assigns pure ignorance:

\[
m_e(A_o)=0,\quad m_e(W_o)=0,\quad m_e(U_o)=1
\]

Constraints are not evidence masses.

## B.3 Dependent Group Summary

Evidence items sharing an independence group are pooled before independent-source combination. For group \(g\):

\[
S_g=\max\{w_e: e \text{ supports AUTHORIZE}\}
\]

\[
O_g=\max\{w_e: e \text{ supports WITHHOLD}\}
\]

\[
\Delta_g=|S_g-O_g|
\]

\[
\lambda_g=
\begin{cases}
0,&S_g+O_g=0\\
\frac{|S_g-O_g|}{S_g+O_g},&S_g+O_g>0
\end{cases}
\]

\[
\tau_g=
\begin{cases}
0,&S_g+O_g=0\\
\frac{2\min(S_g,O_g)}{S_g+O_g}\max(S_g,O_g),&S_g+O_g>0
\end{cases}
\]

If the group clears margin and clarity thresholds, it resolves toward AUTHORIZE or WITHHOLD. Otherwise it is pooled to ignorance with internal tension.

## B.4 Independent Group Combination

Group summaries from independent groups are combined. For group masses \(m_1,\ldots,m_G\):

\[
\widetilde m(A)=\prod_{g=1}^{G}(m_g(A)+m_g(U))-\prod_{g=1}^{G}m_g(U)
\]

\[
\widetilde m(W)=\prod_{g=1}^{G}(m_g(W)+m_g(U))-\prod_{g=1}^{G}m_g(U)
\]

\[
\widetilde m(U)=\prod_{g=1}^{G}m_g(U)
\]

\[
Z=\widetilde m(A)+\widetilde m(W)+\widetilde m(U)
\]

If \(Z\le\varepsilon_K\), the operation enters terminal total-conflict fallback and cannot be authorized by treating the fallback as ordinary ignorance.

Otherwise:

\[
m(A)=\frac{\widetilde m(A)}{Z},\quad
m(W)=\frac{\widetilde m(W)}{Z},\quad
m(U)=\frac{\widetilde m(U)}{Z}
\]

## B.5 Dominant Authorization Direction

The dominant direction is AUTHORIZE only if:

\[
m(A)>m(W)
\]

and:

\[
|m(A)-m(W)|\ge\eta_D
\]

and:

\[
\frac{|m(A)-m(W)|}{m(A)+m(W)}\ge\eta_\chi
\]

Otherwise the operation is unresolved, blocked, or review-required depending on constraints and threshold profile.

## B.6 Direction-Aligned Coverage

Only independent groups resolved toward the final AUTHORIZE direction count toward authorization source coverage and authorization quantity coverage.

Withholding groups affect conflict and review risk, but they do not increase authorization coverage.

## B.7 Constraint Separation

Policy, permission, approval, side-effect, evidence, and environment constraints are logical predicates. They are not evidence masses. A hard constraint can block an operation even when authorization mass favors AUTHORIZE.

## B.8 Status Guards

Only normal combination status may be used for operation authorization. `total_conflict_fallback` is terminal review metadata and blocks authorization. Invalid status blocks authorization.

---

# End of V30 Master Filing Draft
