# EQC-FIC: EQC File Implementation Contract Standard

**Version:** EQC-FIC v1.0  
**Date:** 2026-05-25  
**Purpose:** A specification-first standard for writing implementation documents that can later be converted into code by an LLM coding agent with minimal drift, hallucination, ambiguity, architectural damage, or hidden behavioral change.

---

## 0. Status

This document defines a practical standard for preparing implementation documents before writing code.

The intended workflow is:

1. Write the system-level design.
2. Write one EQC-FIC document per future code file.
3. Validate the file documents against this standard.
4. Only then allow an LLM coding agent to generate code from the documents.
5. Bind generated code back to the documents through validation, tests, traces, and change classification.

This standard is designed to sit below EQC-SIB.

Suggested hierarchy:

```text
EQC / EQC-ES        = document and semantic governance
EQC-SIB             = document ↔ implementation bridge
EQC-FIC             = per-file implementation contract
Actual code         = generated artifact bound to EQC-FIC
Tests/traces        = evidence that code matches EQC-FIC
```

---

## 1. Core Principle

Every code file must be preceded by a file contract document.

The LLM must not write code from vague intent. It must write code from a bounded file-level contract that defines:

- purpose
- non-purpose
- public surface
- owned state
- dependencies
- inputs
- outputs
- invariants
- failure behavior
- security rules
- performance expectations
- tests
- traceability
- document bindings
- acceptance criteria

The file contract is the source of implementation truth for that file.

---

## 2. Main Objective

EQC-FIC exists to reduce LLM coding failures by converting implicit engineering expectations into explicit documented constraints.

It targets these failure classes:

| LLM coding failure | EQC-FIC control |
|---|---|
| Goal drift | File purpose, non-goals, acceptance criteria |
| Hallucinated APIs | confirmed dependency and public surface sections |
| Wrong architecture | layer, ownership, allowed dependency rules |
| Over-engineering | simplicity budget and forbidden expansions |
| Under-engineering | required invariants, failure behavior, and tests |
| Cross-file breakage | dependency and consumer/provider bindings |
| Incorrect behavior | examples, edge cases, tests, trace requirements |
| Missing edge cases | boundary table and invalid-input behavior |
| Security mistakes | threat surface and prohibited operations |
| Performance mistakes | resource budget and complexity expectations |
| Refactor drift | equivalence requirements and no-hidden-change rule |
| False confidence | evidence requirements and status outputs |
| Context loss | each file carries its own local implementation context |
| Tool misuse | pre-code checklist and post-code validation gate |

---

## 3. Normative Language

The following terms are used strictly:

- **MUST** means required.
- **MUST NOT** means prohibited.
- **SHOULD** means strongly recommended.
- **MAY** means optional.
- **UNKNOWN** means the document explicitly lacks information and coding must not proceed until resolved or waived.
- **WAIVED** means a missing or relaxed requirement is explicitly accepted through a documented waiver.

---

## 4. Required File Contract Structure

Each future code file MUST have a matching EQC-FIC document.

Recommended naming:

```text
docs/fic/<target_path>.fic.md
```

Example:

```text
src/runtime/planner.py
docs/fic/src_runtime_planner_py.fic.md
```

Each EQC-FIC document MUST contain the sections below.

---

# EQC-FIC Document Template

## A. Identity

```yaml
fic_id: "FIC-<unique-id>"
target_file: "<future or existing code file path>"
target_language: "<python|typescript|go|rust|java|other>"
artifact_type: "<production|test|schema|adapter|utility|cli|config|generated>"
status: "<draft|ready-for-code|implemented|deprecated>"
version: "vX.Y.Z"
owner: "<person/team/agent>"
last_updated: "YYYY-MM-DD"
```

Rules:

- `fic_id` MUST be globally unique within the project.
- `target_file` MUST be the exact file to be generated or modified.
- `status` MUST be `ready-for-code` before code generation begins.
- The generated code MUST contain a file marker binding it back to `fic_id`.

Recommended code marker:

```text
EQC-FIC: FIC-<unique-id> | Version: vX.Y.Z
```

---

## B. File Purpose

This section MUST answer:

1. What is this file responsible for?
2. Why does this file exist?
3. What system-level problem does it solve?
4. What larger document/spec does it implement?

Template:

```text
This file is responsible for:
- ...

This file exists because:
- ...

This file implements or supports:
- ...
```

Rules:

- The purpose MUST be narrow.
- The purpose MUST describe behavior, not merely file type.
- A file with more than one unrelated purpose MUST be split.

---

## C. Non-Goals

This section MUST list what the file must not do.

Template:

```text
This file MUST NOT:
- ...
```

Common non-goals:

- must not own global state
- must not perform I/O
- must not call network
- must not mutate inputs
- must not contain business logic
- must not know about UI
- must not know about persistence
- must not create threads
- must not call the LLM directly
- must not change governance decisions
- must not bypass validation
- must not import higher-layer modules

Rules:

- Non-goals are mandatory.
- If there are no non-goals, the document is incomplete.
- Non-goals are used to detect LLM overreach.

---

## D. Layer and Ownership

```yaml
layer: <integer>
architectural_role: "<schema|contract|core|service|adapter|orchestrator|test|cli|integration>"
owns_state: true|false
state_owner: "<this file|other file|none>"
allowed_callers:
  - "<path/module/pattern>"
forbidden_callers:
  - "<path/module/pattern>"
```

Rules:

- Lower layers MUST NOT import higher layers.
- A file MUST NOT mutate state it does not own.
- If ownership is shared, the sharing rule MUST be explicit.
- If ownership is unclear, code generation MUST stop.

---

## E. Public Surface

This section defines what the file exposes.

For Python:

```yaml
provides:
  functions:
    - name: ""
      signature: ""
      purpose: ""
      returns: ""
      raises: []
  classes:
    - name: ""
      purpose: ""
      public_methods: []
  constants:
    - name: ""
      type: ""
      value_policy: "<fixed|computed|environment-bound>"
```

Rules:

- Every public function/class/type MUST be listed.
- No additional public symbols may be created during coding unless the FIC is updated first.
- Function signatures MUST be exact where possible.
- Public surface changes are FUNCTIONAL changes.

---

## F. Internal Helpers

```yaml
internal_helpers_allowed: true|false
helper_rules:
  - "Helpers MUST be private/internal."
  - "Helpers MUST NOT become public API."
  - "Helpers MUST NOT create new architecture."
```

Rules:

- Internal helpers MAY be generated if permitted.
- Internal helpers MUST support the declared public surface.
- Internal helpers MUST NOT become hidden subsystems.

---

## G. Inputs

This section defines all accepted inputs.

Template:

```yaml
inputs:
  - name: ""
    type: ""
    source: "<caller|config|environment|file|network|database|generated>"
    required: true|false
    validation_rule: ""
    allowed_values: []
    invalid_values: []
```

Rules:

- Every input must have a type and validation rule.
- Unknown input shape blocks implementation.
- Environment variables, files, database rows, and network responses count as inputs.
- Hidden inputs are prohibited.

---

## H. Outputs

```yaml
outputs:
  - name: ""
    type: ""
    destination: "<return|file|database|stdout|event|trace|network|state>"
    success_shape: ""
    failure_shape: ""
```

Rules:

- Every output must be defined.
- Silent output side effects are prohibited.
- If a function returns `None`, the reason must be stated.
- If output order matters, ordering must be defined.

---

## I. State Contract

```yaml
state:
  owns_state: true|false
  state_items:
    - name: ""
      type: ""
      lifecycle: "<created|read|updated|deleted|cached>"
      mutation_allowed: true|false
      persistence: "<memory|file|db|external|none>"
      concurrency_rule: ""
```

Rules:

- Mutable state MUST be explicitly declared.
- Cache behavior MUST be explicit.
- Global mutable state is forbidden unless specifically justified.
- State transitions MUST be testable.

---

## J. Dependency Contract

```yaml
allowed_imports:
  - "<module/package>"
forbidden_imports:
  - "<module/package>"
required_existing_symbols:
  - symbol: ""
    source_file: ""
    confirmation_required: true
external_dependencies:
  - name: ""
    version_policy: "<pinned|range|stdlib|project-local>"
```

Rules:

- The LLM MUST NOT invent imports.
- The LLM MUST confirm required existing symbols before using them.
- New dependencies are prohibited unless the FIC explicitly allows them.
- Dynamic imports are prohibited unless explicitly declared.
- Cross-layer imports are prohibited unless allowed by the architecture.

---

## K. Algorithm or Procedure

This section describes the file’s behavior.

Template:

```text
Procedure:
1. ...
2. ...
3. ...

Decision points:
- If ..., then ...
- If ..., then ...

Termination condition:
- ...
```

Rules:

- The procedure must be specific enough to implement.
- It must not depend on hidden judgment.
- Any stochastic behavior must define seed policy.
- Any ordering or tie-breaking must be explicit.
- Any external call must define timeout, retry, and failure behavior.

---

## L. Invariants

```yaml
invariants:
  - id: "INV-001"
    statement: ""
    enforcement: "<code|test|type|schema|trace|review>"
    violation_behavior: ""
```

Rules:

- Every file MUST have at least one invariant.
- Invariants MUST be testable or reviewable.
- An invariant that cannot be checked SHOULD be rewritten.
- Violating an invariant is a functional failure.

Common invariants:

- output is deterministic for same input
- no mutation of input objects
- no network access
- no unbounded loop
- no silent exception swallowing
- no dependency on wall-clock time
- no hidden global state
- public API remains stable

---

## M. Error and Failure Behavior

```yaml
errors:
  - condition: ""
    behavior: "<raise|return-error|log-and-skip|retry|abort>"
    error_type: ""
    message_rule: ""
    recoverable: true|false
```

Rules:

- Exceptions MUST be intentional.
- Silent failure is prohibited unless explicitly justified.
- Error messages MUST not leak secrets.
- Retry behavior MUST be bounded.
- Failure behavior must be tested.

---

## N. Security Contract

```yaml
security:
  handles_sensitive_data: true|false
  sensitive_data_types: []
  trust_boundaries: []
  input_validation_required: true|false
  forbidden_operations:
    - "eval"
    - "exec"
    - "unsafe shell execution"
    - "path traversal"
    - "logging secrets"
```

Rules:

- User-controlled input MUST be treated as untrusted.
- Secrets MUST NOT be logged.
- Shell commands MUST NOT be constructed from raw input.
- File paths MUST be normalized and constrained.
- Deserialization must be safe.
- Authorization checks must not be skipped or moved unless explicitly governed.

---

## O. Performance and Resource Budget

```yaml
performance:
  expected_complexity: ""
  max_input_size: ""
  memory_budget: ""
  timeout_budget: ""
  batching_required: true|false
  caching_allowed: true|false
  cache_invalidation_rule: ""
```

Rules:

- Unbounded work is prohibited.
- Infinite loops must be structurally impossible.
- Resource-heavy operations must be declared.
- If the file is on a hot path, benchmarks are required.

---

## P. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true|false
  time_policy: "<not-used|fixed|injected|recorded>"
  randomness_policy: "<not-used|seeded|external>"
  ordering_policy: ""
  floating_point_policy: ""
```

Rules:

- Wall-clock time must be injected or recorded if used.
- Randomness must be seeded or explicitly external.
- Sorting/tie-breaking must be deterministic.
- Floating-point tolerance must be defined where relevant.

---

## Q. Observability and Tracing

```yaml
observability:
  logs_allowed: true|false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
    - "secrets"
    - "personal data unless explicitly allowed"
```

Rules:

- Logs must support debugging without leaking sensitive data.
- Required trace events must map to acceptance tests or runtime diagnosis.
- Logging must not become behavior.

---

## R. Edge Cases

This section MUST include an edge-case table.

| Case | Input/State | Expected Behavior | Test Required |
|---|---|---|---|
| Empty input | | | yes/no |
| Null/None | | | yes/no |
| Invalid type | | | yes/no |
| Boundary value | | | yes/no |
| Large input | | | yes/no |
| Duplicate input | | | yes/no |
| Missing dependency | | | yes/no |
| Permission failure | | | yes/no |
| Timeout | | | yes/no |

Rules:

- Every file MUST document edge cases.
- If an edge case is impossible, explain why.
- Edge cases with business or safety impact require tests.

---

## S. Test Contract

```yaml
tests:
  required_unit_tests:
    - ""
  required_integration_tests:
    - ""
  required_property_tests:
    - ""
  required_regression_tests:
    - ""
  required_negative_tests:
    - ""
  coverage_expectation: ""
```

Rules:

- Every public behavior must have at least one test or waiver.
- Tests must check behavior, not implementation details.
- Negative tests are required for validation-heavy files.
- Property tests are recommended for parsers, transformers, state machines, and canonicalizers.
- A code file is not complete until its tests are complete.

---

## T. Examples

This section gives concrete examples.

Template:

```yaml
examples:
  - name: "basic success"
    input: {}
    expected_output: {}
  - name: "invalid input"
    input: {}
    expected_error: ""
```

Rules:

- Examples must be executable or directly translatable into tests where possible.
- Examples must include at least one normal case and one failure/boundary case.

---

## U. Document and Code Bindings

```yaml
bindings:
  governs:
    - doc_id: ""
      anchor_id: ""
      binding_strength: "HARD|SOFT"
  implements:
    - spec_id: ""
      section: ""
  validated_by:
    - test_file: ""
    - trace_id: ""
```

Rules:

- Every FIC must bind to at least one higher-level document or task.
- Every generated code file must bind back to the FIC.
- HARD bindings require code/document synchronization.
- Functional changes require updating the FIC first.

---

## V. Change Policy

```yaml
change_policy:
  allowed_change_types:
    - "metadata"
    - "state"
    - "functional"
    - "validation"
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
```

Rules:

- Code must not change behavior before the FIC changes.
- Refactors must preserve declared behavior.
- Public API changes require FIC update and version impact.
- Test-only changes must be classified as validation changes.

---

## W. Implementation Instructions for LLM Agent

This section is written directly for the coding agent.

Mandatory text:

```text
Before coding:
1. Read this FIC completely.
2. Confirm target file path.
3. Confirm all required existing symbols.
4. Confirm allowed imports.
5. Confirm public surface.
6. Confirm tests to create or update.
7. If any required information is UNKNOWN, stop and report BLOCKED.
8. Do not invent APIs, files, dependencies, or requirements.
9. Do not edit outside the declared target and test files unless the FIC allows it.
10. Produce the smallest implementation that satisfies this FIC.
```

---

## X. Acceptance Criteria

```yaml
acceptance_criteria:
  - ""
```

Rules:

- Acceptance criteria must be binary or evidence-based.
- “Looks good” is not valid.
- “Implementation is complete” is not valid.
- Acceptance must include tests/checks.

Example:

```yaml
acceptance_criteria:
  - "All public functions listed in section E exist with the declared signatures."
  - "No public symbols beyond section E are introduced."
  - "All required unit tests pass."
  - "No forbidden imports are present."
  - "All declared edge cases are covered by tests or waivers."
```

---

## Y. Completion Evidence

The LLM coding agent must return a completion record.

```yaml
completion_record:
  status: "<implemented|blocked|no_change>"
  files_changed: []
  public_surface_created: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run:
    - check: ""
      reason: ""
  deviations_from_fic: []
  requires_fic_update: true|false
```

Rules:

- The agent MUST NOT claim tests passed unless they were run.
- Any deviation from the FIC must be reported.
- If code cannot satisfy the FIC, status must be `blocked`.

---

# 5. Pre-Code Gate

Before coding, the FIC must pass this checklist.

```text
[ ] Identity complete
[ ] Target file path defined
[ ] Purpose narrow and clear
[ ] Non-goals listed
[ ] Layer and ownership defined
[ ] Public surface defined
[ ] Inputs defined
[ ] Outputs defined
[ ] State ownership defined
[ ] Dependencies defined
[ ] Algorithm/procedure defined
[ ] Invariants defined
[ ] Failure behavior defined
[ ] Security contract defined
[ ] Performance/resource budget defined
[ ] Determinism policy defined
[ ] Edge cases documented
[ ] Tests specified
[ ] Examples provided
[ ] Document bindings declared
[ ] Acceptance criteria binary/evidence-based
[ ] LLM implementation instructions included
```

Coding MUST NOT begin unless all boxes are checked or explicitly waived.

---

# 6. Post-Code Gate

After code generation, the implementation must be checked against the FIC.

```text
[ ] Target file exists
[ ] File contains EQC-FIC marker
[ ] Public surface matches section E
[ ] No extra public symbols introduced
[ ] Forbidden imports absent
[ ] Required imports confirmed
[ ] State behavior matches section I
[ ] Error behavior matches section M
[ ] Security prohibitions respected
[ ] Performance constraints respected or tested
[ ] Determinism policy respected
[ ] Required tests exist
[ ] Required tests pass or failure is reported
[ ] Edge cases covered or waived
[ ] Completion record produced
```

If any item fails, the implementation is not accepted.

---

# 7. File Splitting Rule

A file must be split if any of the following are true:

- It has more than one unrelated purpose.
- It owns multiple unrelated state domains.
- It exposes unrelated public APIs.
- It needs unrelated dependency groups.
- It mixes orchestration and low-level implementation.
- It mixes business logic and I/O.
- It mixes validation and mutation.
- It becomes difficult to describe in one narrow purpose statement.

---

# 8. Anti-Patterns

The following are prohibited unless explicitly justified.

## 8.1 Architecture Anti-Patterns

- hidden global state
- circular imports
- god files
- service locator abuse
- unnecessary abstract factories
- duplicate ownership
- direct cross-layer imports
- business logic inside adapters
- validation spread across unrelated files

## 8.2 LLM-Specific Anti-Patterns

- adding “helpful” features not requested
- creating new files not declared in the FIC
- inventing dependency APIs
- replacing existing architecture with a new one
- weakening tests to make code pass
- deleting safeguards as cleanup
- adding generic wrappers without need
- converting explicit behavior into implicit behavior
- swallowing errors to avoid test failures

## 8.3 Documentation Anti-Patterns

- vague purpose
- no non-goals
- unspecified inputs
- unspecified outputs
- no edge cases
- no test contract
- no dependency rules
- no ownership statement
- unbounded “future extension” language
- prose that cannot be checked

---

# 9. Required Minimal FIC for Small Files

For very small files, a compact FIC may be used, but it must still include:

```yaml
fic_id: ""
target_file: ""
purpose: ""
non_goals: []
public_surface: []
allowed_imports: []
forbidden_imports: []
inputs: []
outputs: []
invariants: []
errors: []
tests: []
acceptance_criteria: []
```

Small files do not get exemption from governance. They only get a shorter form.

---

# 10. FIC Status Lifecycle

```text
draft
  ↓
reviewed
  ↓
ready-for-code
  ↓
implemented
  ↓
validated
  ↓
released
```

Status rules:

- `draft`: may be incomplete.
- `reviewed`: internally coherent but not ready for coding.
- `ready-for-code`: all mandatory sections complete.
- `implemented`: code exists.
- `validated`: code passed required checks.
- `released`: accepted into governed codebase.

The LLM may only code from `ready-for-code` or later.

---

# 11. Change Classification

All changes to code generated from a FIC must be classified.

| Change Type | Meaning | Requires FIC Update |
|---|---|---|
| METADATA | comments, formatting, non-functional markers | maybe |
| VALIDATION | tests/traces only | maybe |
| STATE | dependency/toolchain/config state changes | yes if behavior affected |
| FUNCTIONAL | behavior, public API, invariants, semantics | yes, before code |

Rules:

- Functional code change before FIC update is invalid.
- Public surface change is functional.
- Error behavior change is functional.
- Dependency change may be state or functional depending on effect.
- Test-only change is validation unless it changes expected behavior.

---

# 12. Relationship to EQC-SIB

EQC-FIC is the per-file specialization of EQC-SIB.

EQC-SIB governs:

- artifact registry
- document ↔ implementation binding
- dependency graph
- trace binding
- canonical hashing
- change propagation
- paired checkpoints

EQC-FIC governs:

- the intended content of each implementation file
- public surface of each file
- local invariants
- allowed dependencies
- state ownership
- test requirements
- implementation instructions for the LLM

EQC-FIC documents should become entries in the EQC-SIB binding map.

---

# 13. Recommended Repository Layout

```text
docs/
  fic/
    src_runtime_planner_py.fic.md
    src_runtime_governor_py.fic.md
    src_memory_store_py.fic.md

src/
  runtime/
    planner.py
    governor.py
  memory/
    store.py

tests/
  runtime/
    test_planner.py
    test_governor.py
  memory/
    test_store.py

sib-registry.yaml
sib-bindings.yaml
sib-graph.yaml
```

---

# 14. LLM Coding Prompt Wrapper

When converting a FIC document to code, use a wrapper like this:

```text
You are implementing code from an EQC-FIC document.

You must follow the FIC exactly.

Rules:
1. Do not invent files, APIs, dependencies, or requirements.
2. Do not add public symbols not listed in the FIC.
3. Do not change architecture beyond the FIC.
4. Do not silently ignore UNKNOWN fields.
5. If the FIC is incomplete, return BLOCKED.
6. Implement only the declared target file and declared tests.
7. Preserve all invariants.
8. Follow the declared error behavior.
9. Follow the declared dependency contract.
10. Produce a completion record.

Input:
- EQC-FIC document: <paste document>
- Existing repository context: <paste only confirmed relevant context>

Output:
- Code for target file
- Code for required tests
- Completion record
```

---

# 15. Standard Validation Questions

A reviewer or validator should ask:

1. Can the target file be implemented without guessing?
2. Are all imports known and allowed?
3. Is the public surface exact?
4. Are all inputs and outputs defined?
5. Is state ownership clear?
6. Are failure modes defined?
7. Are security risks identified?
8. Are performance limits stated?
9. Are tests sufficient to detect wrong behavior?
10. Would an LLM know when to stop?
11. Would an LLM know when it is blocked?
12. Would an LLM know what not to do?
13. Can code be checked against this document mechanically?
14. Can future changes be classified?
15. Can drift be detected?

If the answer to any of these is no, the FIC is not ready.

---

# 16. Example Compact FIC

```markdown
# FIC-RUNTIME-PLANNER-001

## Identity

target_file: src/runtime/planner.py
target_language: python
status: ready-for-code
version: v1.0.0

## Purpose

This file converts a validated task request into a bounded execution plan.

## Non-Goals

This file MUST NOT:
- execute tools
- call an LLM
- write memory
- perform governance approval
- access the network

## Layer and Ownership

layer: 2
architectural_role: core service
owns_state: false

## Public Surface

- `create_plan(request: TaskRequest, policy: PlanningPolicy) -> ExecutionPlan`

## Inputs

- `TaskRequest`: validated task object
- `PlanningPolicy`: constraints for planning

## Outputs

- `ExecutionPlan`: ordered steps with bounded actions

## State

No owned mutable state.

## Dependencies

Allowed:
- src.contracts.task
- src.contracts.plan
- src.runtime.policy

Forbidden:
- src.tools
- src.memory
- src.llm
- requests
- subprocess

## Procedure

1. Validate that request is actionable.
2. Convert request objective into one primary plan objective.
3. Apply policy constraints.
4. Produce bounded steps.
5. Return an ExecutionPlan.

## Invariants

- The function is deterministic for the same request and policy.
- The function never executes the plan.
- The function never mutates the request.

## Errors

- Invalid request: raise PlanningInputError.
- Unsatisfiable policy: raise PlanningPolicyError.

## Tests

- valid request produces plan
- invalid request raises
- policy violation raises
- same input produces same output
- input object is not mutated

## Acceptance Criteria

- Public surface matches exactly.
- No forbidden imports.
- All tests pass.
- No hidden state.
```

---

# 17. Final Rule

The LLM is not allowed to treat code generation as creative expansion.

Under EQC-FIC, coding is a constrained transformation:

```text
governed file contract → implementation → tests/traces → validation evidence
```

If the document is insufficient, the correct output is:

```text
BLOCKED: FIC incomplete
```

not guessed code.
