---
schema: "eqc-fic/bundle-v1"
bundle_id: "PAIV-FIC-BUNDLE-001"
version: "v0.1.0"
status: "ready-for-code"
project: "Progressive Architecture Induction and Verification (PAIV)"
fic_standard: "EQC-FIC v2.3"
fic_standard_source: "EquationCode/FIC/EQC_FIC_Standard_v2_3.md"
workflow_source: "EquationCode/FIC/Pseudocode_to_FIC_to_Code_Workflow_Note_v5.md"
date: "2026-07-24"
owner: "Damir Olejar / PAIV Project Team"
risk_level: "high"
enforcement_profile: "strict"
governing_docs:
  - "ALGO-001: PAIV Master Specification v0.1.0"
  - "OPLIB-001: PAIV Primitive and Architecture Operators v0.1.0"
  - "SIB-001: PAIV Spec-Implementation Bridge v0.1.0"
  - "EQC-FIC v2.3"
implementation_scope: "initial repository implementation"
---

# PAIV EQC-FIC Initial Implementation Bundle

**Bundle Version:** v0.1.0  
**Status:** Ready for bounded implementation, subject to the pre-code gate in this document  
**Date:** 2026-07-24  
**Owner:** Damir Olejar / PAIV Project Team  
**Governing Algorithm:** Progressive Architecture Induction and Verification (`PAIV`)  

---

## 0. Bundle Interpretation

EQC-FIC is file-level governance. A single project-wide FIC would be nonconforming because PAIV contains independently stateful files, distinct public surfaces, and different dependency layers. This physical Markdown file therefore contains a **bundle of separate FIC contracts**, each with its own unique `fic_id`, exact `target_file`, public surface, dependency contract, tests, acceptance criteria, and completion-evidence record.

The bundle MAY later be split mechanically into one Markdown file per `fic_id` without changing functional meaning. Until split, section anchors are authoritative identifiers.

### 0.1 Core rule

```text
No governed PAIV implementation file may be generated, edited, refactored,
or accepted until its corresponding FIC entry is ready-for-code and its
pre-code gate passes.
```

### 0.2 Claims boundary

This bundle governs implementation of the declared PAIV system. It does not claim that PAIV can already synthesize full SHA-256 when the exact target is absent. Existing experiments are evidence fixtures only. The implementation must preserve the distinction between:

1. exact execution of a supplied architecture;
2. selection of an exact architecture already present in a finite candidate set;
3. generation of an absent architecture through declared primitives and search.

No code, metric, CLI message, trace, or report may collapse these categories.

---

# 1. Authority and Common Contract

## 1.1 Authority order

```text
1. Non-waivable safety, provenance, and honesty invariants
2. ALGO-001 PAIV Master Specification
3. OPLIB-001 operator contracts
4. SIB-001 document-to-implementation bindings
5. This FIC bundle and its per-file contracts
6. Existing implementation code
7. Task notes and conversation context
8. Model inference
```

Conflicts produce `BLOCKED_CONFLICTING_DOCUMENTS`. Lower-authority code or notes do not silently override a higher-authority contract.

## 1.2 Global non-goals

All units inherit these hard non-goals:

- no cryptographic attack, key-recovery, preimage-search, or collision-search functionality;
- no claim that statistical prediction equals exact program recovery;
- no hidden target seeding;
- no target-name-dependent behavior in unseeded-generation milestones;
- no network access in the core runtime;
- no unbounded recursion, loops, memory, candidate growth, or solver time;
- no dynamic imports, `eval`, `exec`, unsafe deserialization, or raw shell execution;
- no hidden global mutable state;
- no acceptance decision made solely by a neural model or floating-point score;
- no undeclared public symbols, files, dependencies, fallback behavior, retries, caches, or environment variables;
- no weakening of tests to make an implementation pass.

## 1.3 Shared status and error model

Allowed run statuses:

```text
SUCCESS_EXACT
SUCCESS_EMPIRICAL_ONLY
AMBIGUOUS
BUDGET_EXHAUSTED
MODEL_MISMATCH
BLOCKED
FAILED
```

Allowed implementation outcomes:

```text
BLOCKED
NO_CHANGE
IMPLEMENTED_UNVALIDATED
VALIDATED
IMPLEMENTED_WITH_WAIVERS
REJECTED
```

All runtime failures use structured records:

```yaml
error:
  code: "ERROR_*"
  operator: "fully.qualified.symbol"
  message: "non-secret deterministic message"
  recoverable: false
  details: {}
  replay_token: "sha256:..."
```

## 1.4 Determinism and exactness

- Exact candidate semantics use fixed-width unsigned integers and declared modular overflow.
- Reference exact execution is CPU-only and bitwise deterministic.
- Candidate ordering, node ordering, test-vector ordering, archive reduction, and tie-breaking are deterministic.
- Randomness uses an explicitly threaded NumPy `PCG64` state or a later versioned replacement.
- Neural ranking is advisory only and cannot accept a candidate.
- SHA digest bit `0` means the most significant bit of digest byte `0`.
- The same approved manifest, data hashes, seed, limits, and checkpoint must replay bitwise for the exact pipeline.

## 1.5 Common security contract

```yaml
security:
  handles_sensitive_data: false
  input_validation_required: true
  authorization_required: false
  network_access: forbidden
  subprocess_access: forbidden
  dynamic_code_execution: forbidden
  unsafe_deserialization: forbidden
  path_policy: "all paths normalized and constrained to an explicitly supplied workspace root"
  secret_logging: forbidden
```

## 1.6 Common observability contract

Every state-changing or candidate-evaluating operation must support trace records containing, where applicable:

```yaml
trace_record:
  schema_version: "paiv-trace/v0.1.0"
  t: 0
  event: ""
  candidate_id: null
  parent_ids: []
  operator_id: ""
  dataset_partition: ""
  example_count: 0
  mismatch_count: 0
  active_candidate_count: 0
  active_semantic_class_count: 0
  budget_used: {}
  replay_token: ""
  state_fingerprint: ""
  result: ""
  failure_code: null
```

No trace may contain raw secrets, personal data, or undeclared model payloads.

## 1.7 Common validation commands

The exact command names may be wired by `pyproject.toml`, but every implementation completion record must report these checks individually:

```text
python -m pytest tests/unit
python -m pytest tests/property
python -m pytest tests/integration
python -m pytest tests/golden
python -m paiv.cli validate-manifest
python -m paiv.cli verify-executors
python -m paiv.cli reproduce-evidence --experiment all
python -m paiv.cli provenance-audit
```

A command not run must be recorded as `not-run` with a reason. It may not be reported as passed.

---

# 2. Shared Types and Public Interfaces

These names are owned only by `FIC-PAIV-001`. Other units import them and must not redefine equivalent competing types.

```text
RunStatus
VerificationLevel
CandidateStatus
ErrorCode
BitVectorType
ProgramNode
ProgramGraph
Observation
DatasetPartition
RepresentationBundle
TargetCharacterization
ArchitectureLattice
CandidateRecord
ExecutionLimits
ExecutionResult
ScoreVector
VersionSpaceState
AmbiguityReport
ArchiveState
QueryProposal
VerificationReport
TraceRecord
CheckpointEnvelope
RunResult
```

All public dataclasses are immutable by default, use explicit field types, forbid undeclared fields during deserialization, and have stable canonical serialization.

---

# 3. Unit DAG and Implementation Order

```text
UNIT-001 types
    -> UNIT-002 canonical
    -> UNIT-003 IR
    -> UNIT-004 primitives
    -> UNIT-005 executor A
    -> UNIT-006 executor B
    -> UNIT-007 representations
    -> UNIT-008 characterization
    -> UNIT-009 architecture lattice
    -> UNIT-010 mutation
    -> UNIT-011 composition
    -> UNIT-012 generator
    -> UNIT-013 version space
    -> UNIT-014 archive
    -> UNIT-015 query selection
    -> UNIT-016 solver
    -> UNIT-017 neural guidance
    -> UNIT-018 verification
    -> UNIT-019 checkpoint
    -> UNIT-020 CLI
    -> UNIT-021 package exports
    -> UNIT-022 benchmark/golden runner
```

Cross-cutting constraints:

- `UNIT-017 neural guidance` may rank but never accept.
- `UNIT-018 verification` must use both independent executors for exact acceptance.
- `UNIT-012 generator` must emit complete provenance proving whether the target was seeded, retrieved, mutated, composed, solved, or generated.
- `UNIT-020 CLI` contains orchestration only; it must not reimplement core semantics.
- Circular imports are forbidden.

---

# 4. FIC Registry

| FIC ID | Unit | Target file | Layer | Risk | Profile | Status |
|---|---|---|---:|---|---|---|
| FIC-PAIV-001 | Shared types | `src/paiv/types.py` | 0 | medium | strict | ready-for-code |
| FIC-PAIV-002 | Canonicalization | `src/paiv/canonical.py` | 0 | high | strict | ready-for-code |
| FIC-PAIV-003 | Typed IR | `src/paiv/ir.py` | 1 | high | strict | ready-for-code |
| FIC-PAIV-004 | Primitive semantics | `src/paiv/primitives.py` | 1 | high | strict | ready-for-code |
| FIC-PAIV-005 | Reference executor A | `src/paiv/executor_a.py` | 1 | high | strict | ready-for-code |
| FIC-PAIV-006 | Independent executor B | `src/paiv/executor_b.py` | 1 | high | strict | ready-for-code |
| FIC-PAIV-007 | Input representations | `src/paiv/representations.py` | 1 | medium | strict | ready-for-code |
| FIC-PAIV-008 | Target characterization | `src/paiv/characterize.py` | 2 | medium | standard | ready-for-code |
| FIC-PAIV-009 | Architecture lattice | `src/paiv/architecture_lattice.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-010 | Mutation engine | `src/paiv/mutation.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-011 | Composition engine | `src/paiv/composition.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-012 | Candidate generator | `src/paiv/generator.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-013 | Version-space engine | `src/paiv/version_space.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-014 | Diversity archive | `src/paiv/archive.py` | 2 | medium | standard | ready-for-code |
| FIC-PAIV-015 | Disagreement query | `src/paiv/query.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-016 | Solver portfolio | `src/paiv/solver.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-017 | Neural guidance | `src/paiv/neural.py` | 2 | high | strict | ready-for-code |
| FIC-PAIV-018 | Verification | `src/paiv/verification.py` | 3 | critical | critical | ready-for-code |
| FIC-PAIV-019 | Checkpointing | `src/paiv/checkpoint.py` | 3 | high | strict | ready-for-code |
| FIC-PAIV-020 | CLI orchestration | `src/paiv/cli.py` | 3 | high | strict | ready-for-code |
| FIC-PAIV-021 | Package exports | `src/paiv/__init__.py` | 3 | low | minimal | ready-for-code |
| FIC-PAIV-022 | Benchmark runner | `tests/benchmark_runner.py` | 4 | high | strict | ready-for-code |

---

# FIC-PAIV-001 — Shared Immutable Types

## A. Identity

```yaml
fic_id: FIC-PAIV-001
unit_id: UNIT-001
target_file: src/paiv/types.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: medium
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-001
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Define the single authoritative immutable type vocabulary shared by all PAIV runtime units.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Define the single authoritative immutable type vocabulary shared by all PAIV runtime units.
  implements_or_supports:
  - ALGO-001
  - UNIT-001
```

## D. Non-Goals

```yaml
non_goals:
- No algorithm execution.
- No hashing or serialization implementation.
- No I/O, randomness, logging, or mutable registries.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 0
  architectural_role: contract
  module_boundary: src/paiv/types.py
  owns_state: false
  state_owner: none
  depends_on_fics: []
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - 'Enums: RunStatus, VerificationLevel, CandidateStatus, ErrorCode.'
  - Frozen dataclasses listed in section 2 of this bundle.
  - Type aliases CandidateID, OperatorID, ReplayToken, StateFingerprint.
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Constructor fields with explicit runtime types and value constraints.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Immutable typed values only.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - dataclasses
  - enum
  - typing
  forbidden_imports:
  - numpy
  - torch
  - sklearn
  - z3
  - filesystem
  - network
  required_fic_dependencies: []
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate enum/value constraints in __post_init__ where structurally necessary.
  - Reject mutable collection inputs or normalize them to tuples/frozensets only when explicitly documented.
  - Expose no behavior beyond type construction and structural validation.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-001-01
  statement: All public records are immutable.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-001-02
  statement: No two units define competing versions of a shared public type.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-001-03
  statement: Serialization-sensitive field order is stable.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Invalid field value raises ValueError with deterministic message.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Invalid field type raises TypeError with deterministic message.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_types.py
  required_unit_tests:
  - Construction success for every type.
  - Mutation attempts fail.
  - Invalid enum/range values fail.
  - Field order and repr remain stable.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact structural equality and explicit exception type/message prefix.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-001
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_types.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-001
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All declared public types exist exactly once.
- No imports outside the allowed set.
- All types pass immutability and invalid-construction tests.
- 'The target file contains: EQC-FIC: FIC-PAIV-001 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-001
  fic_version: v0.1.0
  target_file: src/paiv/types.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-002 — Canonicalization and Content Addressing

## A. Identity

```yaml
fic_id: FIC-PAIV-002
unit_id: UNIT-002
target_file: src/paiv/canonical.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-002
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Provide deterministic canonical serialization and SHA-256 content identifiers for PAIV values,
    programs, state, and manifests.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Provide deterministic canonical serialization and SHA-256 content identifiers for PAIV
    values, programs, state, and manifests.
  implements_or_supports:
  - ALGO-001
  - UNIT-002
```

## D. Non-Goals

```yaml
non_goals:
- No candidate execution.
- No lossy serialization.
- No pickle.
- No filesystem access.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 0
  architectural_role: core
  module_boundary: src/paiv/canonical.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - canonical_bytes(value) -> bytes
  - canonical_json(value) -> str
  - sha256_hex(value) -> str
  - candidate_id(program) -> str
  - state_fingerprint(state) -> str
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Only declared PAIV scalar, enum, tuple, mapping, and frozen dataclass values.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: UTF-8 canonical JSON bytes/strings and lowercase sha256-prefixed identifiers.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - hashlib
  - json
  - math
  - dataclasses
  - enum
  - typing
  - paiv.types
  forbidden_imports:
  - pickle
  - marshal
  - yaml unsafe loaders
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Convert values to a canonical tagged tree.
  - Sort mapping keys lexicographically by canonical UTF-8 bytes.
  - Encode integers without width loss and floats only under the declared numeric policy.
  - Reject NaN, infinities, unsupported objects, duplicate normalized keys, and cycles.
  - Hash exact canonical bytes with SHA-256.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-002-01
  statement: Equivalent values yield identical bytes.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-002-02
  statement: Non-equivalent typed values cannot collide through omitted type tags.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-002-03
  statement: Canonicalization is independent of Python hash randomization and insertion order.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Unsupported type -> CanonicalizationError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Cycle -> CanonicalizationError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: NaN/Inf -> CanonicalizationError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_canonical.py
  required_unit_tests:
  - Golden canonical vectors.
  - Dictionary-order permutation property tests.
  - Cross-process PYTHONHASHSEED replay.
  - Known SHA-256 digest checks.
  - Cycle and NaN rejection.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact byte-for-byte canonical output and exact digest.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-002
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_canonical.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-002
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- 10,000 randomized equivalent-value permutations canonicalize identically.
- Golden vectors match exactly.
- No unsafe serializer is imported.
- 'The target file contains: EQC-FIC: FIC-PAIV-002 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-002
  fic_version: v0.1.0
  target_file: src/paiv/canonical.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-003 — Typed Intermediate Representation

## A. Identity

```yaml
fic_id: FIC-PAIV-003
unit_id: UNIT-003
target_file: src/paiv/ir.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-003
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Validate, normalize, encode, decode, and traverse bounded typed PAIV program graphs without executing
    them.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Validate, normalize, encode, decode, and traverse bounded typed PAIV program graphs without
    executing them.
  implements_or_supports:
  - ALGO-001
  - UNIT-003
```

## D. Non-Goals

```yaml
non_goals:
- No primitive evaluation.
- No search.
- No solver calls.
- No implicit type coercion.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 1
  architectural_role: core
  module_boundary: src/paiv/ir.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - validate_program(program, limits) -> None
  - canonicalize_program(program) -> ProgramGraph
  - encode_program(program) -> bytes
  - decode_program(payload, limits) -> ProgramGraph
  - walk_nodes(program) -> tuple[ProgramNode, ...]
  - dependency_order(program) -> tuple[str, ...]
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: ProgramGraph and ExecutionLimits.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Validated ProgramGraph, canonical bytes, stable topological order.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  - collections
  - typing
  forbidden_imports:
  - paiv.executor_a
  - paiv.executor_b
  - paiv.generator
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Check graph size and resource bounds.
  - Check unique node IDs and declared operator versions.
  - Check all edges reference existing nodes.
  - Check widths, shapes, state access, and output declarations.
  - Reject cycles except explicitly typed bounded recurrent modules.
  - Canonicalize node order by stable dependency order then node ID.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-003-01
  statement: A valid graph is fully typed.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-003-02
  statement: Canonicalization does not change semantics.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-003-03
  statement: Decode(Encode(program)) equals canonicalize(program).
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Malformed graph -> IRValidationError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Unknown operator -> IRValidationError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Limit exceeded -> ResourceLimitError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_ir.py
  required_unit_tests:
  - Malformed graph matrix.
  - Round-trip property tests.
  - Stable ordering under node insertion permutations.
  - Bounded recurrence vectors.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact normalized graph and exception classification.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-003
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_ir.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-003
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All invalid graph classes are rejected.
- Round-trip property holds for 100,000 generated bounded graphs.
- No execution behavior exists in this file.
- 'The target file contains: EQC-FIC: FIC-PAIV-003 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-003
  fic_version: v0.1.0
  target_file: src/paiv/ir.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-004 — Exact Primitive Semantics

## A. Identity

```yaml
fic_id: FIC-PAIV-004
unit_id: UNIT-004
target_file: src/paiv/primitives.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-004
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Implement the versioned exact Boolean, bit-vector, modular-arithmetic, state, memory, and composition
    primitives declared by OPLIB-001.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Implement the versioned exact Boolean, bit-vector, modular-arithmetic, state, memory, and
    composition primitives declared by OPLIB-001.
  implements_or_supports:
  - ALGO-001
  - UNIT-004
```

## D. Non-Goals

```yaml
non_goals:
- No graph traversal.
- No candidate acceptance.
- No floating approximation for exact primitives.
- No hidden target-specific macro named SHA.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 1
  architectural_role: core
  module_boundary: src/paiv/primitives.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - primitive_catalog() -> tuple[PrimitiveSpec, ...]
  - validate_primitive_call(op_id, args, params) -> None
  - execute_primitive(op_id, args, params) -> object
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Exact typed primitive operands and explicit parameters.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Exact typed primitive result.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - typing
  - operator
  - math only for declared validation
  forbidden_imports:
  - hashlib.sha256 as a candidate primitive
  - numpy random
  - network
  - filesystem
  - dynamic dispatch by eval
  required_fic_dependencies:
  - FIC-PAIV-001
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Resolve exact versioned operator from static catalog.
  - Validate arity, widths, shapes, and parameter ranges.
  - Execute exact modular semantics.
  - Normalize rotations modulo width.
  - Reject undefined shifts, illegal memory access, and width mismatch.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-004-01
  statement: All integer outputs are reduced to declared width.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-004-02
  statement: Same inputs produce bitwise-identical output.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-004-03
  statement: Primitive catalog order is stable.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-004-04
  statement: No target identity changes primitive semantics.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Unknown primitive -> PrimitiveNotFoundError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Type/width mismatch -> PrimitiveTypeError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Invalid parameter -> PrimitiveParameterError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: true
  benchmark_required: true
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_primitives.py
  required_unit_tests:
  - Truth tables for Boolean primitives.
  - Boundary vectors for shifts/rotations.
  - Modular overflow vectors.
  - Independent reference comparisons.
  - 100,000 property tests per primitive family.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact integer/bit-vector output.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-004
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_primitives.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-004
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Zero disagreements against independent test oracles.
- All catalog entries have version, signature, purity, determinism, and tests.
- No forbidden SHA macro exists.
- 'The target file contains: EQC-FIC: FIC-PAIV-004 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-004
  fic_version: v0.1.0
  target_file: src/paiv/primitives.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-005 — Reference Exact Executor A

## A. Identity

```yaml
fic_id: FIC-PAIV-005
unit_id: UNIT-005
target_file: src/paiv/executor_a.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-005
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Execute validated PAIV programs using the primary straightforward interpreter with explicit limits
    and traceable state transitions.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Execute validated PAIV programs using the primary straightforward interpreter with explicit
    limits and traceable state transitions.
  implements_or_supports:
  - ALGO-001
  - UNIT-005
```

## D. Non-Goals

```yaml
non_goals:
- No candidate generation.
- No neural code.
- No acceptance decision.
- No optimization that obscures semantics.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 1
  architectural_role: service
  module_boundary: src/paiv/executor_a.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - execute(program, inputs, limits, trace=False) -> ExecutionResult
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Validated ProgramGraph, immutable input tuple, ExecutionLimits.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: ExecutionResult containing outputs, step count, peak state size, trace digest, and structured failure.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.primitives
  - paiv.canonical
  forbidden_imports:
  - paiv.executor_b
  - paiv.verification
  - torch
  - network
  - filesystem except no direct access
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate program and inputs.
  - Allocate bounded local state.
  - Execute nodes in canonical order.
  - Apply bounded round/recurrent modules exactly.
  - Count every primitive step.
  - Abort deterministically when a declared limit is exceeded.
  - Return immutable result.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-005-01
  statement: No input mutation.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-005-02
  statement: No work beyond explicit limits.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-005-03
  statement: No hidden state across calls.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-005-04
  statement: Trace on/off does not alter output.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Invalid program/input -> structured failure.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Limit exceeded -> ERROR_RESOURCE_LIMIT.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Primitive failure -> wrapped structured failure preserving operator.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: true
  benchmark_required: true
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_executor_a.py
  required_unit_tests:
  - Known small circuits.
  - ARX and recurrent vectors.
  - Trace on/off equivalence.
  - Limit boundary tests.
  - Independent executor differential tests.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact output and exact status; resource counters may use declared exact rules.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-005
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_executor_a.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-005
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Matches executor B on all golden and 100,000 generated valid programs.
- Fails deterministically on all limit violations.
- Contains no search or verification acceptance logic.
- 'The target file contains: EQC-FIC: FIC-PAIV-005 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-005
  fic_version: v0.1.0
  target_file: src/paiv/executor_a.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-006 — Independent Exact Executor B

## A. Identity

```yaml
fic_id: FIC-PAIV-006
unit_id: UNIT-006
target_file: src/paiv/executor_b.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-006
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Provide an independently structured exact interpreter used to detect semantic defects in executor
    A and candidate definitions.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Provide an independently structured exact interpreter used to detect semantic defects in
    executor A and candidate definitions.
  implements_or_supports:
  - ALGO-001
  - UNIT-006
```

## D. Non-Goals

```yaml
non_goals:
- No code copied from executor A beyond shared public contracts.
- No acceptance policy.
- No optimization requiring shared execution internals.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 1
  architectural_role: service
  module_boundary: src/paiv/executor_b.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - execute_independent(program, inputs, limits, trace=False) -> ExecutionResult
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Same contract as executor A.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Same ExecutionResult contract as executor A.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.primitives
  - paiv.canonical
  forbidden_imports:
  - paiv.executor_a internals
  - paiv.verification
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Use an independently organized evaluation strategy.
  - Resolve dependencies without reusing executor A control flow.
  - Apply the same declared primitive semantics.
  - Enforce the same explicit limits.
  - Return canonical result.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-006-01
  statement: Independence of implementation structure.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-006-02
  statement: Functional equivalence to executor A for valid programs.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-006-03
  statement: Identical failure classification for declared invalid conditions.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Same public error codes as executor A.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Internal disagreement is never silently reconciled.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: true
  benchmark_required: true
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_executor_b.py
  required_unit_tests:
  - Differential property tests against executor A.
  - Mutation testing proving disagreements are detected.
  - Golden vector replay.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact cross-executor agreement plus primitive oracle.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-006
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_executor_b.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-006
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Cross-executor agreement on all mandatory tests.
- A planted semantic defect in either executor causes verification failure.
- No import of executor A.
- 'The target file contains: EQC-FIC: FIC-PAIV-006 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-006
  fic_version: v0.1.0
  target_file: src/paiv/executor_b.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-007 — Input Representation Builder

## A. Identity

```yaml
fic_id: FIC-PAIV-007
unit_id: UNIT-007
target_file: src/paiv/representations.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: medium
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-007
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Validate the SHA96 input contract and construct declared immutable typed views without discarding
    the original bytes.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Validate the SHA96 input contract and construct declared immutable typed views without
    discarding the original bytes.
  implements_or_supports:
  - ALGO-001
  - UNIT-007
```

## D. Non-Goals

```yaml
non_goals:
- No target querying.
- No feature learning.
- No candidate scoring.
- No silent endian choice.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 1
  architectural_role: adapter
  module_boundary: src/paiv/representations.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - validate_hex96(text) -> None
  - decode_hex96(text) -> bytes
  - build_views(raw_bytes, profile) -> RepresentationBundle
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Exactly 96 hexadecimal characters or exactly 48 raw bytes for SHA96 profile.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: RepresentationBundle with raw bytes, bits, 8/16/32/64-bit endian views as declared.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - binascii
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - hashlib target labeling
  - network
  - filesystem
  - randomness
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Reject non-string, wrong length, and non-hex text.
  - Decode exactly once.
  - Preserve raw bytes.
  - Construct each declared view with explicit endianness and bit numbering.
  - Record profile and view digests.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-007-01
  statement: Raw bytes round-trip exactly.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-007-02
  statement: View construction is deterministic.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-007-03
  statement: No view is treated as authoritative unless a later lattice commitment selects it.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Invalid text -> InputFormatError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Unsupported profile -> ProfileError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_representations.py
  required_unit_tests:
  - Valid upper/lower hex.
  - Wrong length.
  - Invalid characters.
  - Known endian vectors.
  - Round-trip property.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact bytes and exact view arrays.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-007
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_representations.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-007
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All parsing vectors pass.
- No target-label access exists.
- Every view has an explicit type and endianness.
- 'The target file contains: EQC-FIC: FIC-PAIV-007 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-007
  fic_version: v0.1.0
  target_file: src/paiv/representations.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-008 — Target Characterization

## A. Identity

```yaml
fic_id: FIC-PAIV-008
unit_id: UNIT-008
target_file: src/paiv/characterize.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: medium
enforcement_profile: standard
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-008
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Compute reproducible soft diagnostic evidence from observations without making irreversible architecture
    commitments or acceptance decisions.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Compute reproducible soft diagnostic evidence from observations without making irreversible
    architecture commitments or acceptance decisions.
  implements_or_supports:
  - ALGO-001
  - UNIT-008
```

## D. Non-Goals

```yaml
non_goals:
- No exact recovery claim.
- No candidate acceptance.
- No target-name inference presented as fact.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/characterize.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-007
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - characterize(observations, representations, config, rng_state) -> tuple[TargetCharacterization, rng_state]
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Sealed training observations, representation bundle summaries, declared config and RNG state.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Soft evidence with calibrated scores, uncertainty, sample count, and method IDs.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - numpy
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - paiv.verification
  - network
  - filesystem writes
  - unseeded randomness
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-007
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate dataset provenance and minimum sample rules.
  - Compute declared diagnostics only.
  - Record confidence and calibration metadata.
  - Return evidence that may rank but cannot eliminate a candidate unless promoted by an exact rule elsewhere.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-008-01
  statement: Soft evidence never equals proof.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-008-02
  statement: Same seed/data/config gives reproducible result within declared tolerance.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-008-03
  statement: Held-out/test labels are inaccessible.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Insufficient observations -> structured nonfatal diagnostic status.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: NaN/Inf -> ERROR_NUMERIC_INVALID.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_characterize.py
  required_unit_tests:
  - Seed replay.
  - Partition-leak tests.
  - Constant/random target fixtures.
  - NaN handling.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Metric-specific exact/tolerance oracle and partition-access audit.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-008
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_characterize.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-008
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- No test-partition access.
- No acceptance API.
- All diagnostics identify their method and uncertainty.
- 'The target file contains: EQC-FIC: FIC-PAIV-008 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-008
  fic_version: v0.1.0
  target_file: src/paiv/characterize.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-009 — Architecture Hypothesis Lattice

## A. Identity

```yaml
fic_id: FIC-PAIV-009
unit_id: UNIT-009
target_file: src/paiv/architecture_lattice.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-009
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Represent broad-to-specific architecture commitments, exact constraints, soft preferences, specialization
    history, and controlled reopening.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Represent broad-to-specific architecture commitments, exact constraints, soft preferences,
    specialization history, and controlled reopening.
  implements_or_supports:
  - ALGO-001
  - UNIT-009
```

## D. Non-Goals

```yaml
non_goals:
- No candidate execution.
- No target-specific shortcut.
- No irreversible commitment from soft evidence alone.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: core
  module_boundary: src/paiv/architecture_lattice.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - initialize_lattice(profile) -> ArchitectureLattice
  - specialize(lattice, evidence, rule) -> ArchitectureLattice
  - reopen(lattice, proof) -> ArchitectureLattice
  - allowed_choices(lattice, dimension) -> tuple
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Benchmark profile, exact evidence, soft evidence, specialization/reopen rules.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Immutable versioned ArchitectureLattice.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - executor modules
  - neural frameworks
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Initialize all declared dimensions broad.
  - Apply exact eliminations only when logically justified.
  - Apply soft evidence as ranking metadata.
  - Record every commitment with source, rule, timestamp-free sequence ID, and reversible/irreversible class.
  - Allow reopening only with explicit contradiction proof or approved policy.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-009-01
  statement: At least one choice remains in every active dimension unless status is MODEL_MISMATCH.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-009-02
  statement: Exact and soft evidence remain distinguishable.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-009-03
  statement: History is append-only.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Empty dimension without model-mismatch transition -> LatticeInvariantError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Unauthorized reopen -> LatticePolicyError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_architecture_lattice.py
  required_unit_tests:
  - Initialization snapshot.
  - Specialization monotonicity.
  - Soft evidence non-elimination.
  - Reopen authorization.
  - Empty-space model-mismatch.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact lattice state and history digest.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-009
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_architecture_lattice.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-009
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All state transitions are deterministic and traced.
- Soft evidence cannot remove the exact target.
- Contradictory exact constraints produce MODEL_MISMATCH, not silent deletion.
- 'The target file contains: EQC-FIC: FIC-PAIV-009 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-009
  fic_version: v0.1.0
  target_file: src/paiv/architecture_lattice.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-010 — Candidate Mutation Engine

## A. Identity

```yaml
fic_id: FIC-PAIV-010
unit_id: UNIT-010
target_file: src/paiv/mutation.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-010
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Apply bounded typed structural and parameter mutations to candidate programs with complete provenance
    and deterministic replay.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Apply bounded typed structural and parameter mutations to candidate programs with complete
    provenance and deterministic replay.
  implements_or_supports:
  - ALGO-001
  - UNIT-010
```

## D. Non-Goals

```yaml
non_goals:
- No candidate acceptance.
- No hidden target insertion.
- No untyped arbitrary source-code mutation.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/mutation.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-009
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - enumerate_mutations(program, lattice, budget) -> tuple[MutationSpec, ...]
  - apply_mutation(program, mutation, rng_state) -> tuple[ProgramGraph, MutationRecord, rng_state]
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Validated ProgramGraph, lattice, explicit mutation budget, seeded RNG state.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Validated child ProgramGraph and immutable MutationRecord.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.canonical
  forbidden_imports:
  - hashlib target matching
  - eval
  - exec
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-009
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Enumerate only type-correct mutation sites.
  - Select or apply mutation under deterministic/seeded rule.
  - Validate child.
  - Record parent ID, operator, site, before/after fragments, seed fingerprint, and whether target-equivalent structure
    was already present.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-010-01
  statement: Every child has complete provenance.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-010-02
  statement: No mutation exceeds graph/resource bounds.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-010-03
  statement: A mutation cannot silently copy an undeclared module.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: No legal mutation -> empty result, not fabricated change.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Invalid child -> MutationRejected record.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_mutation.py
  required_unit_tests:
  - All mutation classes.
  - Type preservation.
  - Budget enforcement.
  - Seed replay.
  - Target-seeding audit.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact child canonical ID and mutation record.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-010
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_mutation.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-010
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- M3 fixture can generate an absent one-mutation target.
- Initial population provenance proves the target absent.
- No invalid child enters the candidate stream.
- 'The target file contains: EQC-FIC: FIC-PAIV-010 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-010
  fic_version: v0.1.0
  target_file: src/paiv/mutation.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-011 — Serial and Parallel Composition

## A. Identity

```yaml
fic_id: FIC-PAIV-011
unit_id: UNIT-011
target_file: src/paiv/composition.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-011
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Compose validated program modules serially or in parallel while enforcing type, width, state,
    and resource contracts.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Compose validated program modules serially or in parallel while enforcing type, width,
    state, and resource contracts.
  implements_or_supports:
  - ALGO-001
  - UNIT-011
```

## D. Non-Goals

```yaml
non_goals:
- No module search.
- No implicit adapters.
- No automatic width coercion.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/composition.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - compose_serial(left, right, mapping, limits) -> ProgramGraph
  - compose_parallel(branches, combiner, limits) -> ProgramGraph
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Validated modules, explicit port mapping/combiner, resource limits.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Validated canonical composite ProgramGraph.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.canonical
  forbidden_imports:
  - executors
  - neural frameworks
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate module contracts.
  - Validate explicit port mapping.
  - Reject cycles or state ownership conflicts.
  - Allocate deterministic node IDs.
  - Compute aggregate resource bounds.
  - Canonicalize composite.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-011-01
  statement: Composition preserves declared module semantics.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-011-02
  statement: No hidden adapter or coercion.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-011-03
  statement: State ownership remains unique.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Port/type mismatch -> CompositionTypeError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: State conflict -> CompositionStateError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Budget exceed -> ResourceLimitError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_composition.py
  required_unit_tests:
  - Identity composition.
  - Parallel combiner vectors.
  - Type mismatch negatives.
  - State conflict negatives.
  - Canonical ID stability.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact canonical graph and independent execution equivalence.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-011
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_composition.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-011
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All valid compositions execute equivalently to explicit reference graphs.
- All invalid mappings fail before execution.
- 'The target file contains: EQC-FIC: FIC-PAIV-011 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-011
  fic_version: v0.1.0
  target_file: src/paiv/composition.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-012 — Architecture Candidate Generator

## A. Identity

```yaml
fic_id: FIC-PAIV-012
unit_id: UNIT-012
target_file: src/paiv/generator.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-012
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Generate bounded known, hybrid, and novel candidate graphs from the lattice, primitive catalog,
    verified module library, mutations, and compositions.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Generate bounded known, hybrid, and novel candidate graphs from the lattice, primitive
    catalog, verified module library, mutations, and compositions.
  implements_or_supports:
  - ALGO-001
  - UNIT-012
```

## D. Non-Goals

```yaml
non_goals:
- No target oracle access.
- No candidate acceptance.
- No undeclared module retrieval.
- No exact-target injection.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: orchestrator
  module_boundary: src/paiv/generator.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - generate_candidates(request, lattice, modules, rng_state) -> tuple[tuple[CandidateRecord, ...], rng_state]
  - generation_provenance(candidate) -> GenerationProvenance
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: GenerationRequest with explicit budgets, lattice, content-addressed module set, RNG state.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Ordered immutable CandidateRecords with full generation provenance.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.mutation
  - paiv.composition
  - paiv.canonical
  forbidden_imports:
  - paiv.verification acceptance
  - hashlib labels
  - network
  - filesystem writes
  - dynamic code
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Resolve allowed primitive/module choices.
  - Generate within exact count/depth/round/state budgets.
  - Validate and canonicalize each proposal.
  - Deduplicate by candidate ID.
  - Sort deterministically.
  - 'Record generation origin: seed, module, mutation, composition, solver-filled, or neural-proposed.'
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-012-01
  statement: Every candidate provenance is complete.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-012-02
  statement: Candidate count never exceeds request budget.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-012-03
  statement: Target-presence audit is computable before evaluation.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Invalid request -> GenerationRequestError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: No legal candidates -> empty tuple with reason.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Module digest mismatch -> BLOCKED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_generator.py
  required_unit_tests:
  - Seed replay.
  - Budget boundaries.
  - Deduplication.
  - Provenance completeness.
  - Unseeded target-absence fixture.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact ordered candidate ID/provenance sequence.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-012
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_generator.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-012
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- M3 run proves exact target absent initially and generated later.
- No target oracle or test labels are imported.
- All outputs validate under IR.
- 'The target file contains: EQC-FIC: FIC-PAIV-012 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-012
  fic_version: v0.1.0
  target_file: src/paiv/generator.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-013 — Exact Version-Space Engine

## A. Identity

```yaml
fic_id: FIC-PAIV-013
unit_id: UNIT-013
target_file: src/paiv/version_space.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-013
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Maintain exact candidate/output hypotheses, eliminate contradictions, deduplicate semantic classes,
    and report unresolved ambiguity.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Maintain exact candidate/output hypotheses, eliminate contradictions, deduplicate semantic
    classes, and report unresolved ambiguity.
  implements_or_supports:
  - ALGO-001
  - UNIT-013
```

## D. Non-Goals

```yaml
non_goals:
- No probabilistic acceptance.
- No candidate generation.
- No access to sealed test labels.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: core
  module_boundary: src/paiv/version_space.py
  owns_state: true
  state_owner: this-file
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - initialize(candidates, output_domain) -> VersionSpaceState
  - update(state, observations, executor) -> VersionSpaceState
  - semantic_deduplicate(state, signatures) -> VersionSpaceState
  - ambiguity_report(state) -> AmbiguityReport
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Candidate records, declared output hypotheses, training/query observations, exact executor callable.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Immutable VersionSpaceState and AmbiguityReport.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: true
  state_items:
  - declared immutable state value passed and returned explicitly
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - paiv.neural acceptance
  - test partition
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Evaluate each active hypothesis in canonical order.
  - Eliminate only exact mismatches or invalid executions.
  - Record elimination witness.
  - Group candidates only by declared exact semantic signature.
  - Preserve at least one representative and complete equivalence membership.
  - Report all unresolved non-equivalent alternatives.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-013-01
  statement: Eliminated hypotheses never silently return.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-013-02
  statement: Every elimination has a witness.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-013-03
  statement: No held-out/test observation is consumed.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-013-04
  statement: Ambiguity is never reported as exact recovery.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Executor disagreement -> ERROR_EXECUTOR_DISAGREEMENT.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: All candidates eliminated -> MODEL_MISMATCH.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Missing witness -> VersionSpaceInvariantError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: true
  benchmark_required: true
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_version_space.py
  required_unit_tests:
  - Finite Boolean recovery.
  - Seeded SHA-family reproduction.
  - All-eliminated model mismatch.
  - Ambiguity reporting.
  - Partition-leak audit.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact active-hypothesis set and witness map.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-013
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_version_space.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-013
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Reproduces E1/E2 traces exactly.
- Never claims exact recovery with multiple non-equivalent survivors.
- Every elimination is auditable.
- 'The target file contains: EQC-FIC: FIC-PAIV-013 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-013
  fic_version: v0.1.0
  target_file: src/paiv/version_space.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-014 — Quality-Diversity Archive

## A. Identity

```yaml
fic_id: FIC-PAIV-014
unit_id: UNIT-014
target_file: src/paiv/archive.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: medium
enforcement_profile: standard
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-014
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Preserve bounded structurally diverse candidate representatives using declared deterministic descriptors
    and total ordering.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Preserve bounded structurally diverse candidate representatives using declared deterministic
    descriptors and total ordering.
  implements_or_supports:
  - ALGO-001
  - UNIT-014
```

## D. Non-Goals

```yaml
non_goals:
- No exact acceptance.
- No hidden candidate generation.
- No unbounded storage.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/archive.py
  owns_state: true
  state_owner: this-file
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - initialize_archive(config) -> ArchiveState
  - update_archive(archive, candidates, scores) -> ArchiveState
  - select_diverse(archive, count) -> tuple[CandidateRecord, ...]
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Archive config, candidate records, exact/soft score vectors.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Bounded immutable ArchiveState and ordered selections.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: true
  state_items:
  - declared immutable state value passed and returned explicitly
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - test labels
  - network
  - filesystem direct writes
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Compute declared structural descriptor.
  - Assign deterministic cell.
  - Compare by global total preorder.
  - Retain bounded representatives.
  - Record replacement witnesses.
  - Select in stable cell/order sequence.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-014-01
  statement: Archive size within budget.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-014-02
  statement: Ties resolved deterministically.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-014-03
  statement: Soft score cannot override exact mismatch fields.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Invalid descriptor -> candidate rejected with evidence.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Config invalid -> ArchiveConfigError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_archive.py
  required_unit_tests:
  - Cell assignment.
  - Tie handling.
  - Capacity eviction.
  - Seed-independent deterministic update.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact archive membership/order.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-014
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_archive.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-014
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Archive replay is bitwise deterministic.
- No exact-invalid candidate outranks an exact-valid candidate.
- 'The target file contains: EQC-FIC: FIC-PAIV-014 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-014
  fic_version: v0.1.0
  target_file: src/paiv/archive.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-015 — Disagreement Query Selection

## A. Identity

```yaml
fic_id: FIC-PAIV-015
unit_id: UNIT-015
target_file: src/paiv/query.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-015
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Select bounded oracle queries that maximally distinguish surviving hypotheses without accessing
    unavailable target outputs before submission.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Select bounded oracle queries that maximally distinguish surviving hypotheses without accessing
    unavailable target outputs before submission.
  implements_or_supports:
  - ALGO-001
  - UNIT-015
```

## D. Non-Goals

```yaml
non_goals:
- No direct oracle call.
- No test-set reuse.
- No target-specific handcrafted inputs unless profile declares them.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/query.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-013
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - select_disagreement_query(state, candidate_inputs, executor, budget) -> QueryProposal
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Version space, unlabeled candidate inputs, exact executor, query-selection budget.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: QueryProposal with chosen input, predicted partition, score, tie-break evidence.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - oracle labels
  - test partition
  - network
  - filesystem
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-013
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate candidate input provenance.
  - Predict each survivor output without querying target.
  - Score deterministic disagreement objective.
  - Choose maximum score; ties by canonical input ID.
  - Return no-query reason when survivors do not disagree.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-015-01
  statement: Target label is unknown during selection.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-015-02
  statement: Chosen input is not from sealed test set.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-015-03
  statement: Query budget is enforced.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: No legal input -> no-query result.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Executor disagreement -> ERROR_EXECUTOR_DISAGREEMENT.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_query.py
  required_unit_tests:
  - Two-hypothesis distinguishing fixture.
  - Tie-break.
  - No-disagreement.
  - Test-set leakage guard.
  - Budget zero.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact chosen input ID and predicted partition.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-015
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_query.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-015
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Selection never reads target outputs.
- All ties replay identically.
- Queries reduce version space on mandatory fixtures when a distinguishing input exists.
- 'The target file contains: EQC-FIC: FIC-PAIV-015 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-015
  fic_version: v0.1.0
  target_file: src/paiv/query.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-016 — Symbolic Solver Portfolio

## A. Identity

```yaml
fic_id: FIC-PAIV-016
unit_id: UNIT-016
target_file: src/paiv/solver.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-016
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Fill explicitly declared finite program holes and propagate exact constraints under deterministic
    resource limits.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Fill explicitly declared finite program holes and propagate exact constraints under deterministic
    resource limits.
  implements_or_supports:
  - ALGO-001
  - UNIT-016
```

## D. Non-Goals

```yaml
non_goals:
- No unrestricted source-code synthesis.
- No solver result accepted without exact replay.
- No hidden external service.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/solver.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-005
  - FIC-PAIV-006
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - fill_holes(template, constraints, budget) -> SolverResult
  - constraint_propagate(template, constraints, budget) -> SolverResult
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Typed template with finite holes, exact constraints, explicit solver budget.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: SolverResult with zero or more validated candidate completions, proof/evidence, status, resource usage.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.ir
  - paiv.canonical
  - optional pinned z3/cvc5 adapter only
  forbidden_imports:
  - network solvers
  - unbounded solver time
  - test labels
  - dynamic code
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-005
  - FIC-PAIV-006
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate finite domains.
  - Translate only declared constraints.
  - Set deterministic timeout/conflict budget.
  - Enumerate models in canonical order.
  - Validate each model through IR and both executors before return.
  - Record solver/version/options.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-016-01
  statement: No candidate returned without exact validation.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-016-02
  statement: Timeout is BUDGET_EXHAUSTED, not UNSAT.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-016-03
  statement: UNSAT requires solver evidence under declared model.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Unsupported constraint -> SolverUnsupported.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Timeout -> BUDGET_EXHAUSTED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Model validation failure -> ERROR_SOLVER_INVALID_MODEL.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_solver.py
  required_unit_tests:
  - Known SAT/UNSAT.
  - Timeout classification.
  - Model enumeration ordering.
  - Cross-executor validation.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact status and candidate set; proof object where supported.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-016
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_solver.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-016
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Timeout never becomes unsat.
- Every candidate validates independently.
- Solver configuration is fully recorded.
- 'The target file contains: EQC-FIC: FIC-PAIV-016 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-016
  fic_version: v0.1.0
  target_file: src/paiv/solver.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-017 — Neural Guidance and Ranking

## A. Identity

```yaml
fic_id: FIC-PAIV-017
unit_id: UNIT-017
target_file: src/paiv/neural.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-017
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Train and apply advisory proposal/ranking models that allocate search effort without defining
    candidate semantics or acceptance.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Train and apply advisory proposal/ranking models that allocate search effort without defining
    candidate semantics or acceptance.
  implements_or_supports:
  - ALGO-001
  - UNIT-017
```

## D. Non-Goals

```yaml
non_goals:
- No exact acceptance.
- No direct test-label training.
- No replacement for symbolic execution.
- No hidden pretrained model download.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 2
  architectural_role: service
  module_boundary: src/paiv/neural.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - train_ranker(tasks, config, rng_state) -> tuple[RankerArtifact, rng_state]
  - rank_hypotheses(ranker, task_context, candidates) -> tuple[RankedCandidate, ...]
  - evaluate_ranker(ranker, benchmark) -> RankerEvaluation
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Generated/meta-training tasks, declared config, RNG state, candidate features.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Content-addressed model artifact, advisory rankings, evaluation report.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - numpy
  - optional pinned torch
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - network model download
  - paiv.verification acceptance mutation
  - sealed test labels
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate task provenance and partitioning.
  - Train under seeded deterministic profile where available.
  - Record environment and model digest.
  - Rank candidates without changing exact score fields.
  - Evaluate against deterministic baseline.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-017-01
  statement: Acceptance remains impossible through this API.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-017-02
  statement: Exact-invalid candidate remains invalid regardless of rank.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-017-03
  statement: Evaluation uses held-out generated task families.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Unavailable deterministic kernel -> explicit determinism downgrade or BLOCKED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: NaN loss -> ERROR_NUMERIC_INVALID.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_neural.py
  required_unit_tests:
  - No-acceptance API audit.
  - Partition leakage.
  - Seed/tolerance replay.
  - Baseline comparison.
  - Corrupt artifact rejection.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Declared tolerance metrics plus exact artifact/provenance checks.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-017
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_neural.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-017
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Improves solve rate or time significantly against deterministic baseline before promotion.
- Cannot mark a candidate verified.
- All model/data/environment digests recorded.
- 'The target file contains: EQC-FIC: FIC-PAIV-017 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-017
  fic_version: v0.1.0
  target_file: src/paiv/neural.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-018 — Independent Verification and Acceptance

## A. Identity

```yaml
fic_id: FIC-PAIV-018
unit_id: UNIT-018
target_file: src/paiv/verification.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: critical
enforcement_profile: critical
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-018
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Apply the only authoritative candidate acceptance gates using sealed held-out data, independent
    executors, provenance audits, and equivalence evidence where available.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Apply the only authoritative candidate acceptance gates using sealed held-out data, independent
    executors, provenance audits, and equivalence evidence where available.
  implements_or_supports:
  - ALGO-001
  - UNIT-018
```

## D. Non-Goals

```yaml
non_goals:
- No candidate generation.
- No neural judgment.
- No acceptance from training accuracy alone.
- No silent waiver.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 3
  architectural_role: service
  module_boundary: src/paiv/verification.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-013
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - heldout_exact(candidate, dataset, executors, policy) -> VerificationReport
  - independent_replay(candidate, vectors, executors) -> VerificationReport
  - equivalence(candidate, reference, policy) -> VerificationReport
  - accept(report_set, gate) -> VerificationReport
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Candidate, sealed datasets/vectors, both executors, exact gate policy, provenance records.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Immutable VerificationReport with level, evidence digests, failures, ambiguity, and acceptance boolean.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  - paiv.canonical
  - paiv.executor_a
  - paiv.executor_b
  forbidden_imports:
  - paiv.neural decision use
  - network
  - unsealed data mutation
  - single-executor acceptance
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-013
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Verify dataset seals and partition identity.
  - Audit candidate generation provenance.
  - Execute both interpreters on mandatory vectors.
  - Require exact agreement.
  - Evaluate untouched test set only after candidate freeze.
  - Run equivalence procedure when declared.
  - Apply binary gate without heuristic override.
  - Emit final evidence record.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-018-01
  statement: Only this unit may produce accepted=True.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-018-02
  statement: 100% means exact numerator equals denominator.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-018-03
  statement: A seeded-target experiment is labeled seeded.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-018-04
  statement: Executor disagreement always fails acceptance.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-018-05
  statement: Unresolved ambiguity cannot be exact recovery.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Seal mismatch -> BLOCKED_DATA_PROVENANCE.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Executor disagreement -> REJECTED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Incomplete evidence -> IMPLEMENTED_UNVALIDATED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Waiver absent -> REJECTED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_verification.py
  required_unit_tests:
  - Known good/bad candidate.
  - One-bit error rejection.
  - Executor fault injection.
  - Seeded/unseeded provenance classification.
  - Test-set reuse detection.
  - Ambiguity rejection.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Binary gate with exact evidence; no tolerance for SHA bit outputs.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-018
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_verification.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-018
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- A one-error candidate is rejected.
- A valid exact supplied SHA graph passes 10,000+ untouched vectors and independent reference.
- Unseeded M3 requires target absent initially and generated later.
- No neural import or score participates in acceptance.
- 'The target file contains: EQC-FIC: FIC-PAIV-018 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-018
  fic_version: v0.1.0
  target_file: src/paiv/verification.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-019 — Checkpoint Save and Restore

## A. Identity

```yaml
fic_id: FIC-PAIV-019
unit_id: UNIT-019
target_file: src/paiv/checkpoint.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-019
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Save and restore complete PAIV persistent state with atomic content addressing, schema validation,
    and replay guarantees.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Save and restore complete PAIV persistent state with atomic content addressing, schema
    validation, and replay guarantees.
  implements_or_supports:
  - ALGO-001
  - UNIT-019
```

## D. Non-Goals

```yaml
non_goals:
- No pickle.
- No partial undocumented state.
- No path escape.
- No automatic compatibility migration.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 3
  architectural_role: service
  module_boundary: src/paiv/checkpoint.py
  owns_state: true
  state_owner: this-file
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - save_checkpoint(state, path, policy) -> CheckpointEnvelope
  - restore_checkpoint(path, policy) -> PersistentState
  - validate_checkpoint(path, policy) -> CheckpointValidation
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Complete persistent state, normalized workspace path, schema/policy.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Atomic checkpoint files and immutable envelope/validation result.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: true
  declared_effects:
  - bounded local file writes
```

## K. State Contract

```yaml
state:
  owns_state: true
  state_items:
  - declared immutable state value passed and returned explicitly
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - json
  - os
  - tempfile
  - pathlib
  - paiv.types
  - paiv.canonical
  forbidden_imports:
  - pickle
  - network
  - unsafe yaml
  - path outside workspace
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate complete state and manifest bindings.
  - Canonicalize payload.
  - Write temporary file inside target directory.
  - fsync where supported.
  - Atomic replace.
  - Verify digest after write.
  - Restore only after schema, digest, policy, and version checks.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-019-01
  statement: Checkpoint includes all persistent state and RNG state.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-019-02
  statement: Failed writes do not replace last valid checkpoint.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-019-03
  statement: Restore preserves declared replay class.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Path escape -> SecurityError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Digest mismatch -> CheckpointIntegrityError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Unsupported version -> CheckpointCompatibilityError.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_checkpoint.py
  required_unit_tests:
  - Round-trip.
  - Corruption.
  - Interrupted-write simulation.
  - Path traversal.
  - Missing field.
  - Cross-version rejection.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact state fingerprint and checkpoint digest after round-trip.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-019
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_checkpoint.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-019
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Atomicity tests pass.
- No unsafe serializer.
- All required persistent fields are present and validated.
- 'The target file contains: EQC-FIC: FIC-PAIV-019 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-019
  fic_version: v0.1.0
  target_file: src/paiv/checkpoint.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-020 — Command-Line Orchestration

## A. Identity

```yaml
fic_id: FIC-PAIV-020
unit_id: UNIT-020
target_file: src/paiv/cli.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-020
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Expose bounded PAIV commands that validate configuration, orchestrate declared units, and emit
    machine-readable results without reimplementing core semantics.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Expose bounded PAIV commands that validate configuration, orchestrate declared units, and
    emit machine-readable results without reimplementing core semantics.
  implements_or_supports:
  - ALGO-001
  - UNIT-020
```

## D. Non-Goals

```yaml
non_goals:
- No core primitive semantics.
- No hidden defaults.
- No network.
- No shell execution.
- No target-specific shortcut.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 3
  architectural_role: cli
  module_boundary: src/paiv/cli.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-007
  - FIC-PAIV-008
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  - FIC-PAIV-012
  - FIC-PAIV-013
  - FIC-PAIV-014
  - FIC-PAIV-015
  - FIC-PAIV-016
  - FIC-PAIV-017
  - FIC-PAIV-018
  - FIC-PAIV-019
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - 'main(argv: Sequence[str] | None = None) -> int'
  - 'Commands: run, validate-manifest, verify-executors, reproduce-evidence, provenance-audit, inspect-checkpoint'
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: CLI arguments and declared local config/manifests.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Exit code, JSON stdout result, human diagnostics on stderr.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: true
  declared_effects:
  - stdout/stderr
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - argparse
  - json
  - pathlib
  - paiv public modules only
  forbidden_imports:
  - subprocess
  - network
  - eval
  - exec
  - direct cryptographic target implementation outside benchmark adapters
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-007
  - FIC-PAIV-008
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  - FIC-PAIV-012
  - FIC-PAIV-013
  - FIC-PAIV-014
  - FIC-PAIV-015
  - FIC-PAIV-016
  - FIC-PAIV-017
  - FIC-PAIV-018
  - FIC-PAIV-019
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Parse without hidden environment variables.
  - Validate paths/config.
  - Dispatch exactly one command.
  - Call public unit interfaces.
  - Emit deterministic JSON schema.
  - Return documented exit code.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-020-01
  statement: stdout is machine-readable when JSON mode is selected.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-020-02
  statement: Errors never claim success.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-020-03
  statement: CLI cannot bypass verification gate.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Usage -> exit 2.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Blocked contract/provenance -> exit 3.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Validation failure -> exit 4.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Runtime failure -> exit 5.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Success -> exit 0.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_cli.py
  required_unit_tests:
  - Every command success/failure.
  - Unknown argument.
  - Path traversal.
  - JSON schema.
  - Verification bypass attempt.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact exit code and output schema; stable keys/order where declared.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-020
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_cli.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-020
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- All commands have documented help and exit codes.
- No subprocess/network imports.
- No acceptance path bypasses verification.
- 'The target file contains: EQC-FIC: FIC-PAIV-020 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-020
  fic_version: v0.1.0
  target_file: src/paiv/cli.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-021 — Package Public Exports

## A. Identity

```yaml
fic_id: FIC-PAIV-021
unit_id: UNIT-021
target_file: src/paiv/__init__.py
target_language: python
artifact_type: production
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: low
enforcement_profile: minimal
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-021
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Expose the intentionally small stable PAIV package surface and version marker.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Expose the intentionally small stable PAIV package surface and version marker.
  implements_or_supports:
  - ALGO-001
  - UNIT-021
```

## D. Non-Goals

```yaml
non_goals:
- No runtime work.
- No import-time side effects.
- No eager import of heavy neural/solver dependencies.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 3
  architectural_role: contract
  module_boundary: src/paiv/__init__.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - __version__
  - RunResult
  - RunStatus
  - VerificationLevel
  - ProgramGraph
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Import operation only.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: Declared package exports.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: false
  declared_effects: []
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - paiv.types
  forbidden_imports:
  - torch
  - z3
  - filesystem
  - network
  - logging configuration
  required_fic_dependencies:
  - FIC-PAIV-001
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Set version constant.
  - Import only lightweight declared symbols.
  - Define __all__ exactly.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-021-01
  statement: Import is side-effect free.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-021-02
  statement: No undeclared export.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-021-03
  statement: Heavy optional dependencies not imported.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Missing internal symbol fails import loudly; no fallback.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test___init__.py
  required_unit_tests:
  - Import smoke test.
  - __all__ exact match.
  - Optional dependencies absent.
  - No logging/file side effects.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact export set.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-021
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test___init__.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-021
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Exact declared export set.
- Import succeeds without optional dependencies.
- No side effects.
- 'The target file contains: EQC-FIC: FIC-PAIV-021 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-021
  fic_version: v0.1.0
  target_file: src/paiv/__init__.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# FIC-PAIV-022 — Benchmark and Golden-Trace Runner

## A. Identity

```yaml
fic_id: FIC-PAIV-022
unit_id: UNIT-022
target_file: tests/benchmark_runner.py
target_language: python
artifact_type: test
status: ready-for-code
version: v0.1.0
owner: PAIV Project Team
last_updated: '2026-07-24'
risk_level: high
enforcement_profile: strict
implementation_mode: new-file
```

## B. Authority and Source Hierarchy

```yaml
authority:
  governing_docs:
  - doc_id: ALGO-001
    path: docs/ALGO-001-PAIV.md
    authority_level: architecture
    anchor_ids:
    - Block-0
    - Block-III
    - Block-IV
    - Block-VII
  - doc_id: OPLIB-001
    path: docs/OPLIB-001.md
    authority_level: subsystem
    anchor_ids: []
  - doc_id: PAIV-FIC-BUNDLE-001
    path: docs/fic/PAIV_EQC_FIC_Implementation_Bundle_v0.1.0.md
    authority_level: task
    anchor_ids:
    - FIC-PAIV-022
  conflict_resolution:
    rule: higher_authority_wins
    tie_breaker: most_recent_validated_checkpoint
  stale_doc_policy:
    max_age_days: null
    stale_behavior: BLOCKED
```

## C. File Purpose

```yaml
purpose:
  responsibility: Run reproducible evidence experiments E0-E3 and later milestones, seal datasets, capture traces,
    and prevent unsupported completion claims.
  reason_for_existence: Provide one bounded implementation owner for this behavior.
  system_problem_solved: Run reproducible evidence experiments E0-E3 and later milestones, seal datasets, capture
    traces, and prevent unsupported completion claims.
  implements_or_supports:
  - ALGO-001
  - UNIT-022
```

## D. Non-Goals

```yaml
non_goals:
- No production semantics.
- No alteration of candidate acceptance rules.
- No rewriting evidence to pass.
```

## E. Layer, Ownership, and Placement

```yaml
architecture:
  layer: 4
  architectural_role: test
  module_boundary: tests/benchmark_runner.py
  owns_state: false
  state_owner: none
  depends_on_fics:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-007
  - FIC-PAIV-008
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  - FIC-PAIV-012
  - FIC-PAIV-013
  - FIC-PAIV-014
  - FIC-PAIV-015
  - FIC-PAIV-016
  - FIC-PAIV-017
  - FIC-PAIV-018
  - FIC-PAIV-019
  - FIC-PAIV-020
  - FIC-PAIV-021
  forbidden_callers: []
  forbidden_callees:
  - higher-layer private internals
  - undeclared network or shell services
```

## F. Public Surface Contract

```yaml
public_surface:
  symbols:
  - main(argv=None) -> int
  - run_experiment(manifest_path) -> ExperimentReport
  - seal_dataset(dataset, path) -> DatasetSeal
  - compare_golden(report, golden_path) -> GoldenComparison
  stability: experimental
  exports_must_match_exactly: true
  hidden_surface_allowed: false
```

## G. Compatibility and Versioning Contract

```yaml
compatibility:
  backward_compatible: true
  public_surface_change: false
  migration_required: false
  deprecation_required: false
  version_impact: minor for new artifact; later changes classified independently
  compatibility_tests_required: true
  affected_callers: []
  affected_configs: []
  affected_data_formats: []
```

## H. Internal Helper Policy

```yaml
internal_helpers:
  allowed: true
  rules:
  - Helpers are private and begin with an underscore.
  - Helpers support only the declared public surface.
  - Helpers do not create hidden state, I/O, retries, caches, or public behavior.
  max_helper_count: null
  max_helper_complexity: bounded by the narrow file purpose
```

## I. Inputs

```yaml
inputs:
  contract: Versioned experiment manifest, seed, dataset profile, budgets, expected evidence class.
  validation_required: true
  hidden_inputs_allowed: false
  untrusted_input_policy: validate before use
```

## J. Outputs and Side Effects

```yaml
outputs:
  contract: ExperimentReport, sealed dataset metadata, trace files, completion status.
  ordering_rule: canonical deterministic order where collections are returned
side_effects:
  allowed: true
  declared_effects:
  - bounded local file writes
```

## K. State Contract

```yaml
state:
  owns_state: false
  state_items: []
  global_mutable_state_allowed: false
  cache_allowed: false
  concurrency_rule: no asynchronous mutation; caller coordinates deterministic commits
  reset_rule: construct or restore explicit state; never implicit process reset
```

## L. Dependency Contract

```yaml
dependencies:
  allowed_imports:
  - stdlib
  - numpy
  - hashlib
  - paiv public modules
  forbidden_imports:
  - network
  - test result fabrication
  - monkeypatch of verification gate
  - unseeded wall-clock randomness
  required_fic_dependencies:
  - FIC-PAIV-001
  - FIC-PAIV-002
  - FIC-PAIV-003
  - FIC-PAIV-004
  - FIC-PAIV-005
  - FIC-PAIV-006
  - FIC-PAIV-007
  - FIC-PAIV-008
  - FIC-PAIV-009
  - FIC-PAIV-010
  - FIC-PAIV-011
  - FIC-PAIV-012
  - FIC-PAIV-013
  - FIC-PAIV-014
  - FIC-PAIV-015
  - FIC-PAIV-016
  - FIC-PAIV-017
  - FIC-PAIV-018
  - FIC-PAIV-019
  - FIC-PAIV-020
  - FIC-PAIV-021
  new_dependencies_allowed: false
  dynamic_imports_allowed: false
```

## M. Existing-Code Inspection Contract

```yaml
existing_code_inspection:
  required: false
  reason: new-file implementation
  must_inspect:
  - governing EQC documents
  - declared dependency public surfaces already implemented
  - tests and schemas referenced by this FIC
  no_change_allowed: true
```

## N. Algorithm or Procedure

```yaml
procedure:
  steps:
  - Validate manifest and environment.
  - Generate/load data with declared seed.
  - Seal train/validation/test partitions.
  - Run declared experiment.
  - Freeze candidate before test access.
  - Invoke verification.
  - Write append-only evidence and compare golden traces.
  - Label seeded/unseeded status explicitly.
  decision_points: []
  termination_condition: all declared steps complete or a structured failure/budget status occurs
  tie_breaking_rule: lowest canonical identifier wins after the declared total preorder
  ordering_rule: canonical stable order
```

## O. Invariants

```yaml
invariants:
- id: INV-022-01
  statement: Test set inaccessible before candidate freeze.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-022-02
  statement: Every reported metric has numerator/denominator.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-022-03
  statement: E0/E1/E2 never count as unseeded synthesis.
  enforcement: code+test
  violation_behavior: structured failure and rejection
- id: INV-022-04
  statement: Failed checks remain failed in report.
  enforcement: code+test
  violation_behavior: structured failure and rejection
```

## P. Error and Failure Behavior

```yaml
errors:
- condition: Manifest mismatch -> BLOCKED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Golden drift -> FAILED_VALIDATION.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Missing dependency -> BLOCKED.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
- condition: Interrupted run -> incomplete evidence, never pass.
  behavior: raise-or-return-structured-error
  error_type: declared domain error
  message_rule: deterministic non-secret prefix
  recoverable: false
  retry_policy: none
silent_failure_allowed: false
broad_exception_swallowing_allowed: false
```

## Q. Security Contract

```yaml
security:
  inherits: bundle section 1.5
  handles_sensitive_data: false
  input_validation_required: true
  network_access: false
  subprocess_access: false
  dynamic_code_execution: false
  path_access: none unless declared in section J
```

## R. Performance and Resource Budget

```yaml
performance:
  expected_complexity: bounded by explicit input/program/candidate/solver limits
  max_input_size: supplied by caller or benchmark profile
  memory_budget: supplied through declared limits for resource-sensitive operations
  timeout_budget: no hidden timeout; explicit budget where applicable
  batching_required: false
  caching_allowed: false
  hot_path: false
  benchmark_required: false
  acceptable_regression: no unapproved regression above 10% on pinned benchmark after baseline exists
```

## S. Determinism and Reproducibility

```yaml
determinism:
  deterministic_required: true
  time_policy: not-used
  randomness_policy: not-used unless RNG state is explicit in the public signature
  ordering_policy: canonical stable order
  floating_point_policy: exact integer semantics where applicable; declared tolerance only for advisory ML metrics
  concurrency_policy: no asynchronous state mutation
```

## T. Observability and Tracing

```yaml
observability:
  inherits_trace_schema: bundle section 1.6
  logs_allowed: false
  required_log_events: []
  metrics: []
  traces: []
  forbidden_log_content:
  - secrets
  - personal data
  - raw undeclared model payloads
```

## U. Edge Cases

| Case | Expected behavior | Test required | Waiver allowed |
|---|---|---:|---:|
| Empty input | Reject or return the explicitly declared empty result; never infer behavior | yes | no |
| `None`/null | Reject unless explicitly included in the public signature | yes | no |
| Invalid type | Deterministic type/validation failure | yes | no |
| Boundary resource limit | Exact boundary succeeds; first value beyond fails | yes | no |
| Duplicate input/ID | Follow declared deduplication or reject rule | yes | no |
| Missing dependency | `BLOCKED` before implementation/run | yes | no |
| Timeout/budget exhaustion | Return budget status, never success/unsat | yes | no |
| Concurrent access | No unsynchronized mutation | yes | no |

## V. Test Contract

```yaml
tests:
  required_test_files:
  - tests/unit/test_benchmark_runner.py
  required_unit_tests:
  - Self-test of seal enforcement.
  - Metric arithmetic.
  - Seed replay.
  - Golden mismatch.
  - False-claim fixture.
  - E3 target-absence audit.
  required_integration_tests:
  - integration with every direct FIC dependency
  required_property_tests:
  - determinism/replay property where applicable
  - resource-bound property where applicable
  required_regression_tests: []
  required_negative_tests:
  - invalid input and forbidden behavior
  required_security_tests:
  - forbidden dependency and side-effect audit
  required_performance_tests:
  - pinned benchmark when benchmark_required is true
  coverage_expectation: every public behavior, error, invariant, and required edge case has an oracle or approved
    waiver
```

## W. Examples and Test Oracles

```yaml
examples:
- name: normal declared behavior
  input: small valid fixture defined in the test file
  expected_output: exact output or declared invariant
- name: invalid or boundary behavior
  input: one explicit invalid/boundary fixture
  expected_error: declared structured failure
test_oracles:
- oracle_type: exact-output-or-property
  applies_to: all public behavior
  pass_rule: Exact report schema, hashes, metrics, status, and golden comparison.
```

## X. Document and Code Bindings

```yaml
bindings:
  governs:
  - doc_id: ALGO-001
    anchor_id: relevant operator/procedure sections
    binding_strength: HARD
  - doc_id: FIC-PAIV-022
    anchor_id: this contract
    binding_strength: HARD
  implements:
  - spec_id: ALGO-001
    section: operator manifest, operator library, procedure, validation
  validated_by:
  - test_file: tests/unit/test_benchmark_runner.py
  - trace_id: TRACE-001
  sib_artifact_id: PAIV::UNIT-022
```

## Y. Change Policy

```yaml
change_policy:
  allowed_change_types:
  - METADATA
  - VALIDATION
  - STATE
  - FUNCTIONAL
  requires_fic_update_before_code_change: true
  public_surface_change_requires_version_bump: true
  behavioral_change_requires_tests: true
  refactor_requires_equivalence_evidence: true
  edits_outside_target_and_declared_tests: false
delete_or_deprecate:
  action: none
  affected_files: []
  replacement: ''
  compatibility_behavior: not applicable
  migration_steps: []
  rollback_steps: []
```

## Z. LLM Implementation Instructions

```text
Before coding:
1. Read this FIC completely.
2. Confirm the exact target file and all direct dependency public surfaces.
3. Confirm allowed and forbidden imports.
4. Implement no public symbol outside section F.
5. Create or update only the declared target and test files.
6. If a required dependency or governing clause is missing or contradictory, return BLOCKED.
7. Do not invent APIs, files, dependencies, defaults, retries, caches, or requirements.
8. Produce the smallest implementation satisfying this contract.
9. Run every available required check and report each check honestly.
10. Produce the completion record in section AB.
```

## AA. Acceptance Criteria

```yaml
acceptance_criteria:
- Reproduces existing evidence only when scripts and inputs match.
- E3 cannot pass if target present initially.
- No failed/not-run check is represented as pass.
- 'The target file contains: EQC-FIC: FIC-PAIV-022 | Version: v0.1.0'
- No public symbols beyond section F are introduced.
- No forbidden import or side effect is present.
- Every required test passes or an explicit approved waiver is recorded.
- The completion record contains no unreported deviation.
```

## AB. Completion Evidence

```yaml
completion_record:
  status: <implemented|blocked|no_change>
  fic_id: FIC-PAIV-022
  fic_version: v0.1.0
  target_file: tests/benchmark_runner.py
  files_changed: []
  public_surface_created_or_preserved: []
  tests_created_or_updated: []
  checks_run: []
  checks_not_run: []
  deviations_from_fic: []
  unresolved_unknowns: []
  requires_fic_update: false
```

---

# 5. Bundle-Level Pre-Code Gate

The bundle is ready for implementation only when all applicable boxes are checked:

```text
[x] Every planned production Python file in the initial runtime has a unique FIC ID.
[x] Every FIC has an exact target path.
[x] Shared types have one owner.
[x] Unit DAG and implementation order are explicit.
[x] Public surfaces are declared.
[x] Non-goals and forbidden dependencies are declared.
[x] State ownership is unique.
[x] Exact acceptance is owned only by FIC-PAIV-018.
[x] Neural guidance cannot accept candidates.
[x] Target-seeding provenance is mandatory.
[x] Required tests and oracles are declared.
[x] Completion records are required.
[ ] Exact dependency versions are pinned in pyproject/lock files before the affected implementation is validated.
[ ] OPLIB-001 is physically present and its operator IDs match the code manifest before primitive implementation is validated.
[ ] Trace and checkpoint JSON schemas are physically present before FIC-PAIV-018/019 are validated.
```

The unchecked items do not block beginning `UNIT-001` through `UNIT-003`; they block final validation of affected later units. A coding agent must not silently mark them complete.

# 6. Post-Code Bundle Gate

```text
[ ] Every implemented file contains its exact EQC-FIC marker.
[ ] All FIC public surfaces match code and package exports.
[ ] No undeclared files were introduced.
[ ] No circular dependency exists.
[ ] Both executors agree on all mandatory vectors and generated properties.
[ ] Version-space E1/E2 evidence is reproduced honestly.
[ ] M3 provenance proves the exact target was absent initially.
[ ] Test partitions remain sealed until candidate freeze.
[ ] Neural ranking has no acceptance route.
[ ] Verification rejects one-error, ambiguous, provenance-invalid, and executor-disagreement fixtures.
[ ] Checkpoints pass round-trip, corruption, atomicity, and path-security tests.
[ ] All checks are represented accurately in completion records.
```

# 7. Artifact Coverage Outside This Bundle

This bundle directly governs the initial Python implementation files listed in section 4. The following artifacts remain governed primarily by EQC-ES, EQC-SIB, schema, or dedicated document contracts and must exist before the corresponding acceptance gate:

```text
governance/EQC-ES-PAIV.md
governance/EQC-SIB-PAIV.md
governance/ecosystem-registry.yaml
governance/ecosystem-graph.yaml
governance/compatibility.yaml
governance/data-registry.yaml
governance/sib-registry.yaml
governance/sib-bindings.yaml
governance/tooling-manifest.yaml
docs/ALGO-001-PAIV.md
docs/OPLIB-001.md
docs/TEST-001.md
docs/TRACE-001.md
schemas/trace-schema.json
schemas/checkpoint-schema.json
pyproject.toml
requirements-lock.txt
```

Their absence must produce a specific `BLOCKED` state when a unit needs them; no coding agent may invent their contents during implementation.

# 8. Required Split Plan

For repository adoption, this physical bundle should be split without semantic edits into:

```text
docs/fic/index.fic.yaml
docs/fic/FIC-PAIV-001-types.md
...
docs/fic/FIC-PAIV-022-benchmark-runner.md
```

The split tool must preserve each section byte-for-byte after canonical line-ending normalization and must create a manifest mapping `fic_id` to file path and SHA-256 digest.

# 9. Final Status

```yaml
bundle_status: "READY_FOR_BOUNDED_IMPLEMENTATION"
first_allowed_unit: "FIC-PAIV-001"
implementation_order_enforced: true
full_project_validation_ready: false
remaining_blockers:
  - "pin exact dependency and toolchain versions"
  - "materialize OPLIB-001, TEST-001, TRACE-001 and JSON schemas"
  - "split bundle into per-file FICs before automated EQC-FIC registry enforcement"
```

The bundle is sufficient to begin the exact foundation in bounded order. It is not permission to implement all files simultaneously or to skip per-unit completion evidence.

# End of PAIV EQC-FIC Initial Implementation Bundle
