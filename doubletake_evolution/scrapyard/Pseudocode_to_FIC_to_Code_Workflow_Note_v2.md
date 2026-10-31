# Pseudocode-to-FIC-to-Code Workflow Note

**Date:** 2026-05-25  
**Version:** 2.0  
**Purpose:** Define the recommended workflow for using EQC-FIC as a bridge between whole-system pseudocode, bounded implementation-unit documents, and LLM-assisted coding.

---

## 1. Core Idea

The project should not ask an LLM coding agent to implement directly from broad architecture notes, vague feature descriptions, or whole-system pseudocode.

The safer workflow is:

```text
system goal
  -> whole-system pseudocode
  -> bounded pseudocode units
  -> EQC-FIC unit documents
  -> validated FIC bundle
  -> bounded coding-agent handoff
  -> one-unit implementation
  -> verification, traceability, review, rollback evidence
```

The FIC layer is the controlled bridge between intent and code. Pseudocode expresses intended behavior. FIC documents convert that behavior into enforceable implementation contracts.

The coding agent should implement from FIC documents, not from broad pseudocode.

---

## 2. Why This Workflow Exists

LLM coding failures often happen because the model is forced to design, infer requirements, select architecture, invent missing interfaces, and write code in the same step.

This workflow separates those activities:

| Stage | Main responsibility | Main risk controlled |
|---|---|---|
| System goal | Define what the system is for | Goal drift |
| Whole-system pseudocode | Capture end-to-end behavior | Missing global logic |
| Unit pseudocode | Split behavior into bounded units | Over-broad implementation |
| FIC document | Define enforceable implementation contract | Ambiguity and hallucination |
| FIC validation | Check consistency before coding | Cross-unit contradictions |
| Coding-agent handoff | Give only bounded context | Context overload and wrong edits |
| Verification | Prove implementation matches contract | False confidence |

The LLM is no longer asked to invent the system while coding it. It is asked to implement a bounded contract.

---

## 3. Recommended Repository Structure

A repository using this workflow should contain a document set similar to:

```text
/docs/fic/
  00_system_goal.md
  01_whole_system_pseudocode.md
  02_architecture_contract.md
  03_repo_structure_plan.md
  04_dependency_graph.md
  05_shared_types_and_interfaces.md
  06_validation_plan.md
  07_risk_ledger.md
  08_traceability_matrix.md
  09_coding_agent_handoff_rules.md
  units/
    unit_001_runtime_entrypoint.md
    unit_002_turn_contract.md
    unit_003_governance_gate.md
    unit_004_tool_mediator.md
    unit_005_memory_port.md
    unit_006_trace_writer.md
    unit_007_checkpoint_manager.md
```

Optional but recommended:

```text
/docs/fic/generated/
  fic_bundle_manifest.yaml
  unit_dag.yaml
  semantic_lockfile.yaml
  readiness_report.md
  validation_report.md
  review_packet.md
```

---

## 4. Full Pipeline

### Step 1: Define the system goal

The system goal document should define:

- what the system is for;
- who or what uses it;
- what success means;
- what is explicitly out of scope;
- what must never be broken;
- what runtime/resource constraints apply;
- what safety, governance, or persistence rules apply.

The system goal must be stable enough that unit-level documents can be judged against it.

---

### Step 2: Write whole-system pseudocode

The whole-system pseudocode should capture the complete intended process from entrypoint to completion.

It should include:

- main control flow;
- required decision points;
- required state transitions;
- required validation points;
- error and fallback paths;
- external dependencies;
- observable outputs;
- trace/checkpoint behavior.

It should not contain implementation-language details unless they are required constraints.

---

### Step 3: Split whole-system pseudocode into bounded units

Each unit should be small enough to implement and verify independently.

A good unit has:

- one stable responsibility;
- one clear public surface;
- one owner of state, or no state;
- bounded inputs and outputs;
- bounded dependencies;
- explicit tests;
- explicit traceability to whole-system pseudocode.

A bad unit is:

- a vague subsystem;
- a mixed responsibility bucket;
- an architecture idea without an interface;
- a file-shaped container with no semantic boundary;
- a unit that owns behavior already owned by another unit.

---

### Step 4: Convert each pseudocode unit into an EQC-FIC document

Each FIC document should contain:

- stable unit ID;
- source pseudocode reference;
- purpose;
- responsibility;
- non-responsibilities;
- public interface;
- inputs;
- outputs;
- state ownership;
- allowed dependencies;
- forbidden dependencies;
- preconditions;
- postconditions;
- invariants;
- side-effect classification;
- idempotence classification;
- failure modes;
- test obligations;
- acceptance criteria;
- trace/logging requirements;
- implementation boundaries;
- rollback/checkpoint requirements;
- residual risks;
- completion evidence requirements.

The FIC document is the coding contract. If a behavior is not in a FIC document, the coding agent should not implement it.

---

### Step 5: Build the unit DAG

Before coding, build a directed acyclic graph of unit dependencies.

Each unit should declare:

```yaml
unit_id: UNIT-003
depends_on:
  - UNIT-001
  - UNIT-002
provides:
  - GovernanceDecision
  - check_permission()
allowed_inbound:
  - UNIT-001
allowed_outbound:
  - UNIT-006
forbidden_dependencies:
  - direct_filesystem_write
  - direct_network_call
```

The DAG is used to:

- determine implementation order;
- prevent circular dependency drift;
- restrict context packets;
- detect missing shared interfaces;
- prevent accidental cross-unit expansion.

Circular dependencies are forbidden unless explicitly justified and approved in the architecture contract.

---

### Step 6: Create shared type and interface documents

Before implementation starts, shared types and interfaces should be documented once.

This prevents every unit from inventing its own version of the same concept.

Examples:

```text
TurnInput
TurnOutput
GovernanceDecision
ToolCallRequest
ToolCallResult
TraceRecord
CheckpointRecord
MemoryReadRequest
MemoryWriteRequest
```

Each shared type should define:

- fields;
- required vs optional status;
- valid enum values;
- default behavior;
- serialization format;
- validation rules;
- versioning policy;
- compatibility rules.

No coding agent should invent or modify shared types without an explicit FIC update.

---

### Step 7: Validate the FIC bundle before coding

Before any implementation, validate the entire FIC bundle.

The bundle should fail readiness if:

- a pseudocode unit has no FIC document;
- a FIC document has no source pseudocode reference;
- a FIC has vague acceptance criteria;
- a FIC has no test obligations;
- a public interface is defined in more than one place;
- state ownership is duplicated;
- a required dependency is undefined;
- a forbidden dependency is used by another document;
- a circular dependency exists without authorization;
- a unit has no place in the unit DAG;
- a unit depends on broad pseudocode instead of a specific FIC;
- a behavior exists only in broad pseudocode without a FIC owner;
- implementation order is unclear;
- rollback/checkpoint requirements are missing for stateful units;
- traceability records are incomplete.

Readiness status should be one of:

```text
READY_FOR_IMPLEMENTATION
BLOCKED_MISSING_CONTEXT
BLOCKED_CONFLICTING_DOCUMENTS
BLOCKED_UNDEFINED_INTERFACE
BLOCKED_UNTESTABLE_CONTRACT
BLOCKED_UNSAFE_DEPENDENCY
BLOCKED_DUPLICATED_OWNERSHIP
```

---

## 5. Bounded Coding-Agent Handoff Packet

The coding agent should receive a bounded packet, not the whole document set by default.

A handoff packet should contain:

```text
1. The specific FIC unit to implement.
2. The relevant source pseudocode excerpt.
3. The allowed files or expected new files.
4. The required public interface.
5. The shared types this unit may use.
6. The dependency rules.
7. The test obligations.
8. The required validation commands.
9. The allowed exit statuses.
10. The completion evidence template.
```

The agent should not receive unrelated units unless the implementation package explicitly permits a multi-unit change.

---

## 6. Coding Agent Instruction Pattern

Use a direct instruction pattern like:

```text
Implement only the unit described in this FIC document.

Do not implement behavior not described here.
Do not change public interfaces unless the FIC explicitly allows it.
Do not add dependencies unless the FIC explicitly allows them.
Do not infer missing behavior from broad pseudocode.
Do not edit outside the allowed implementation boundary.
Do not weaken tests to make implementation pass.
Do not silently choose defaults where the FIC requires explicit behavior.

If the FIC conflicts with existing code, stop and report BLOCKED.
If required context is missing, stop and report BLOCKED.
If the implementation is already complete, report NO_CHANGE with evidence.
If the task is unsafe or untestable, report BLOCKED with the reason.

Return:
- files inspected;
- files changed;
- implementation summary;
- tests added;
- tests run;
- validator results;
- unresolved risks;
- deviations from FIC;
- completion status.
```

---

## 7. Implementation Order

The recommended implementation order is:

```text
1. shared types and schemas
2. pure utility units
3. ports and interfaces
4. state containers
5. governance/policy units
6. tool mediation units
7. trace/checkpoint units
8. orchestration units
9. runtime entrypoint
10. integration tests
```

This order reduces the chance that high-level orchestration code invents lower-level behavior that should have been defined elsewhere.

---

## 8. Unit Completion Record

Each implemented unit should produce a completion record.

Template:

```yaml
unit_id: UNIT-003
fic_document: docs/fic/units/unit_003_governance_gate.md
status: IMPLEMENTED
source_pseudocode_refs:
  - docs/fic/01_whole_system_pseudocode.md#governance-before-action
files_inspected:
  - src/runtime/turn.py
  - src/governance/types.py
files_changed:
  - src/governance/gate.py
  - tests/governance/test_gate.py
tests_added:
  - tests/governance/test_gate.py::test_blocks_forbidden_action
  - tests/governance/test_gate.py::test_allows_safe_action
tests_run:
  - pytest tests/governance -q
validators_run:
  - fic_lint
  - typecheck
  - unit_tests
deviations_from_fic: []
unresolved_risks: []
rollback_plan:
  - revert src/governance/gate.py
  - revert tests/governance/test_gate.py
```

Allowed statuses:

```text
IMPLEMENTED
NO_CHANGE
PARTIAL
BLOCKED
REJECTED
```

A unit should not be marked `IMPLEMENTED` unless its completion record includes evidence.

---

## 9. Traceability Requirements

Traceability must run in both directions.

Each pseudocode unit must link to:

- its FIC document;
- its implementation files;
- its tests;
- its validation results;
- its completion record.

Each implementation file must link back to:

- the FIC unit that authorizes it;
- the public interface it implements;
- the tests that verify it.

A traceability matrix should include:

| Pseudocode ID | FIC ID | Implementation files | Tests | Status |
|---|---|---|---|---|
| PS-001 | UNIT-001 | `src/runtime/entrypoint.py` | `tests/runtime/test_entrypoint.py` | IMPLEMENTED |

No code file should contain important behavior that has no owning FIC document.

---

## 10. Validation and Test Strategy

Testing should be defined before coding.

Each FIC should specify which test levels are required:

| Test level | Purpose |
|---|---|
| example test | verifies a normal case |
| boundary test | verifies limits and edge cases |
| negative test | verifies rejection/failure behavior |
| property test | verifies broad behavioral properties |
| integration test | verifies cross-unit behavior |
| replay/golden test | verifies deterministic trace or output |
| migration test | verifies compatibility across versions |
| performance test | verifies resource/time budget |
| security test | verifies unsafe behavior is blocked |

A unit with no tests is not ready for coding unless it is explicitly documentation-only.

---

## 11. Handling Existing Code

If coding begins in an existing repository, the agent must inspect before modifying.

Before editing, the agent must identify:

- existing files that already implement similar behavior;
- existing public interfaces;
- existing tests;
- existing dependency patterns;
- existing naming conventions;
- existing runtime constraints;
- any conflict between the FIC and current code.

If existing code conflicts with the FIC, the coding agent should not improvise. It should return `BLOCKED_CONFLICTING_DOCUMENTS` or `BLOCKED_EXISTING_CODE_CONFLICT`.

---

## 12. Handling Missing or Ambiguous Information

The coding agent must not fill important gaps by guesswork.

It should stop or mark blocked when:

- a required interface is undefined;
- a dependency is unclear;
- ownership is duplicated;
- acceptance criteria are vague;
- test oracle is missing;
- runtime behavior is unspecified;
- security or persistence behavior is unclear;
- the FIC contradicts another higher-authority document.

For small local choices that do not affect behavior, the agent may choose a conventional implementation, but it must record the choice in completion evidence.

---

## 13. Change Control

Once a FIC unit is approved for implementation, it should be frozen.

During implementation:

- do not rewrite the FIC to match accidental code;
- do not expand scope;
- do not change public interfaces;
- do not move behavior to another unit;
- do not add dependencies;
- do not add new responsibilities.

If the FIC is wrong, stop implementation and create a FIC delta record.

FIC delta record template:

```yaml
delta_id: DELTA-004
affected_unit: UNIT-003
reason: existing shared type lacks required field
requested_change:
  - add field decision_reason to GovernanceDecision
impact:
  - UNIT-003
  - UNIT-006
approval_required: true
status: PENDING
```

---

## 14. Review Gate

Before accepting implementation, review:

- whether the implementation matches the FIC;
- whether it changed only allowed files;
- whether tests match acceptance criteria;
- whether public interfaces are preserved;
- whether side effects match the FIC;
- whether trace/logging behavior exists where required;
- whether no hidden behavior was added;
- whether completion evidence is complete;
- whether residual risks are acceptable.

Review status should be:

```text
ACCEPTED
REJECTED_NEEDS_FIX
REJECTED_SCOPE_DRIFT
REJECTED_TEST_INSUFFICIENT
REJECTED_TRACEABILITY_GAP
REJECTED_SECURITY_RISK
```

---

## 15. Anti-Patterns

Reject the workflow result if any of these occur:

- broad pseudocode is used as the direct coding instruction;
- a coding agent implements multiple units without authorization;
- a unit has no FIC;
- code introduces behavior that has no FIC owner;
- tests are written after coding without being tied to acceptance criteria;
- the agent changes interfaces because it is convenient;
- the agent adds architecture not described in the FIC;
- the FIC is rewritten after coding to justify the implementation;
- missing context is replaced with guesses;
- implementation success is claimed without test or validation evidence;
- multiple units own the same state;
- multiple files define incompatible versions of the same shared type.

---

## 16. Minimum Viable Version

A small project can start with only:

```text
/docs/fic/
  00_system_goal.md
  01_whole_system_pseudocode.md
  02_shared_types_and_interfaces.md
  03_traceability_matrix.md
  units/
    unit_001_first_unit.md
    unit_002_second_unit.md
```

Even in the minimum version, the following are mandatory:

- every unit has a stable ID;
- every unit has a FIC;
- every FIC has acceptance criteria;
- every FIC has test obligations;
- every implementation has completion evidence;
- every behavior has one owning FIC.

---

## 17. Final Rule

The coding agent should implement from FIC documents, not from broad pseudocode.

Pseudocode provides intent.  
FIC documents provide the enforceable implementation contract.  
Validation proves the contract is complete enough to code.  
Completion evidence proves the code attempted to satisfy the contract.
