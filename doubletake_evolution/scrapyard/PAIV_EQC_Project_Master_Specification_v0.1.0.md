# Progressive Architecture Induction and Verification (PAIV)

## EquationCode Project Master Specification

**Spec Version: v0.1.0**  
**EQC Format:** EQC-v1.1  
**Portfolio Governance Target:** EQC-ES-v1.9.1  
**Implementation Bridge Target:** EQC-SIB-v1.2.1  
**Date:** 2026-07-24  
**Authors:** Damir Olejar / Project Team  
**Status:** Experimental, normative initial project baseline  
**Primary DocID:** ALGO-001  
**Namespace:** `paiv`

---

## Document status and interpretation

This document is the initial complete EquationCode specification for PAIV. It governs the first implementation of a progressively specializing, neural-guided symbolic program-induction system that starts from a broad typed architecture space, narrows that space using observations, generates new candidate structures, and accepts only exact discrete programs that pass independent verification.

This specification is intentionally broader than the currently demonstrated prototypes. The prototypes prove only that exact target selection can succeed when the correct architecture is present inside a finite candidate family. They do not yet prove that PAIV can generate the complete SHA-256 architecture when it is absent. The difference is a mandatory project milestone and cannot be hidden by terminology.

The initial reference target is:

```text
96 hexadecimal characters
    -> decode as exactly 48 bytes
    -> unknown deterministic transformation
    -> observe one output bit
```

SHA-256 bit 0 is the principal benchmark, but the architecture is intended to support other bounded deterministic algorithms and compositions of algorithms.

---

# Block 0 — Header, Provenance, and Global Semantics

## 0.0 Identity

- **Algorithm:** Progressive Architecture Induction and Verification (`PAIV`)
- **Purpose (1 sentence):** Recover, sharpen, execute, and independently verify bounded deterministic programs from black-box observations without requiring the target algorithm name at run time.
- **Spec Version:** `EQC-v1.1 | v0.1.0 | 2026-07-24 | Damir Olejar / Project Team`
- **Domain / Problem Class:** Neural-guided symbolic program induction; typed bit-vector synthesis; architecture generation; active learning; exact verification.
- **Primary benchmark:** First output bit of SHA-256 for uniformly sampled 96-hex-character inputs decoded as 48 bytes.
- **General benchmark classes:** Boolean circuits, arithmetic circuits, ARX rounds, Feistel networks, substitution-permutation networks, sponge/permutation systems, GF(2) recurrences, finite-state systems, bounded parsers, and serial/parallel compositions.
- **Normative scope:** Bounded hypothesis classes with declared types, operators, memory, state, depth, round, and resource limits.
- **Non-goals:** Preimage recovery, key recovery, collision search, or any claim that finite examples identify unrestricted hidden functions.

## 0.A Objective Semantics

- **Optimization sense:** `MINIMIZE`
- **Objective type:** `Vector`
- **Primary comparison rule:** lexicographic total preorder over the following tuple:

```text
J(candidate) = (
    hard_invalid,
    required_example_mismatches,
    verification_failure_rank,
    unresolved_non_equivalent_alternatives,
    heldout_error_count,
    description_length_bits,
    exact_execution_cost,
    deterministic_candidate_id
)
```

Where:

1. `hard_invalid` is `0` for a well-typed executable candidate and `1` otherwise.
2. `required_example_mismatches` counts exact mismatches on all mandatory observations.
3. `verification_failure_rank` is ordered:
   - `0`: formal equivalence or exhaustive-domain proof,
   - `1`: independent exact replay plus all mandatory tests,
   - `2`: held-out empirical success only,
   - `3`: no independent verification,
   - `4`: contradicted.
4. `unresolved_non_equivalent_alternatives` is the number of semantically distinct surviving candidates.
5. `heldout_error_count` is exact, not averaged.
6. `description_length_bits` is computed by `Metric.DescriptionLength_v1`.
7. `exact_execution_cost` is the deterministic reference cost.
8. `deterministic_candidate_id` resolves all remaining ties.

- **Success definition:** a run succeeds only when the declared acceptance gate for the benchmark is satisfied. For the SHA96 final gate, success requires `100%` accuracy on the untouched test set and independent agreement with the reference SHA-256 specification or implementation.
- **Invalid objective policy:** malformed candidates, undefined operations, illegal memory accesses, width errors, solver errors, and `NaN/Inf` guidance scores are ranked worse than all valid candidates.
- **Chance baseline:** for a balanced one-bit target, the statistical baseline is `0.5`. A statistical predictor is not considered recovered unless its advantage is independently significant and stable; SHA reproduction requires exact recovery, not merely greater than chance.

## 0.B Reproducibility Contract

- **Seed space:** `seed ∈ {0..2^64-1}`
- **PRNG family:** NumPy `PCG64` for Python reference runs; any replacement requires a version bump and equivalence evaluation.
- **Randomness locality:** all sampling occurs only inside versioned `Random.*`, `Architecture.*`, `Data.*`, or `Query.*` operators that explicitly accept and return `rng_state`.
- **Replay guarantee:** a run is replayable given:
  - root seed,
  - PRNG family and version,
  - exact operator manifest,
  - numeric policy,
  - ordering policy,
  - parallel policy,
  - environment profile,
  - candidate-generation budget,
  - dataset hashes,
  - checkpoint digest.
- **Replay token:**

```text
replay_token_t = SHA256(
    canonical(rng_state_t)
    || canonical(active_candidate_ids_t)
    || canonical(manifest_digest)
    || canonical(dataset_digest_t)
)
```

- **Reference determinism level:** `BITWISE` for exact execution and version-space elimination; `TOLERANCE` for neural guidance training metrics only.
- **Non-replayable runs:** forbidden for acceptance evidence.

## 0.C Numeric Policy

- **Exact candidate semantics:** unsigned fixed-width integers with explicit modular overflow.
- **Bit numbering:** digest bit `0` is the most significant bit of digest byte `0`.
- **Word widths:** declared per candidate; initial profile supports `1`, `8`, `16`, `32`, and `64` bits.
- **Integer overflow:** wrap modulo `2^w`.
- **Shifts:** out-of-range shift amounts are invalid unless an operator explicitly defines modulo-width normalization.
- **Rotations:** rotation amount normalized by `n mod w`.
- **Floating-point format:** IEEE-754 binary64 for search statistics; binary32 or binary64 for neural models as declared by the environment profile.
- **Rounding mode:** round-to-nearest, ties-to-even.
- **Fast-math policy:** forbidden in reference validation.
- **Named tolerances:**
  - `EPS_EQ = 1e-12`
  - `EPS_PROB = 1e-12`
  - `EPS_LOSS = 1e-9`
  - `EPS_CALIBRATION = 1e-4`
- **NaN/Inf policy:** abort the affected operator and emit `ERROR_NUMERIC_INVALID`.
- **Accepted programs:** may not depend on floating-point approximations unless the target contract itself is approximate.
- **SHA profile:** all accepted SHA operations use exact 32-bit semantics.

## 0.D Ordering and Tie-Break Policy

- **Index base:** `0-based`
- **Candidate ordering:** ascending `candidate_id`.
- **Operator ordering:** canonical namespace, operator name, version.
- **Tie-breaking:** lower deterministic candidate ID wins after all semantic and complexity fields tie.
- **Iteration order:** ascending active candidate ID unless a declared deterministic batch partition is used.
- **Sorting stability:** required.
- **Output-bit ordering:** `0..output_width-1`, most-significant bit first within each byte.
- **Categorical boundary rule:** residual probability belongs to the highest-index category only after stable cumulative summation; exact architecture acceptance does not use categorical sampling.

## 0.E Parallel, Concurrency, and Reduction Policy

- **Parallel scope:** independent candidate execution, test-vector evaluation, proposal scoring, and solver calls.
- **Reduction semantics:** reduce results in ascending candidate ID and ascending test-vector ID.
- **Float reduction rule:** pairwise deterministic reduction; Kahan summation for reported aggregate losses where practical.
- **Concurrency restrictions:** no asynchronous state mutation of the candidate archive.
- **Candidate updates:** generated in isolated workers, committed by a deterministic coordinator.
- **Device policy:** exact reference validation is CPU-only. GPU guidance is allowed but cannot determine acceptance.
- **Distributed policy:** workers receive immutable snapshots and return content-addressed results.

## 0.F Environment and Dependency Policy

- **Reference runtime class:** CPU-only reference implementation; optional GPU guidance profile.
- **Reference Python:** `3.11.x`
- **Reference dependencies:**
  - `numpy`
  - `numba`
  - `scikit-learn`
  - future: `z3-solver`, `cvc5`, `torch`, `egglog` or equivalent, each pinned before use.
- **Compiler/flags:** no fast-math for exact kernels.
- **Reference architecture:** x86_64 or a pinned container image.
- **Determinism level:** `BITWISE` for exact pipeline; `TOLERANCE` for neural-ranking metrics.
- **Dependency lock:** required before milestone M2.
- **External references:** SHA-256 semantics are pinned to the applicable NIST Secure Hash Standard profile.

## 0.G Operator Manifest

| Namespace | Operator | Version | Category | Required in initial implementation |
|---|---|---:|---|---|
| `Random` | `InitializePRNG` | v1 | Init | Yes |
| `Data` | `ValidateHex96` | v1 | IO | Yes |
| `Data` | `DecodeHex96` | v1 | IO | Yes |
| `Data` | `GenerateUniformHex96` | v1 | Generator | Yes |
| `Data` | `SplitDataset` | v1 | Init | Yes |
| `Oracle` | `QueryTargetBit` | v1 | External | Yes when queryable |
| `Representation` | `BuildViews` | v1 | Transform | Yes |
| `Probe` | `CharacterizeTarget` | v1 | Diagnostics | Yes |
| `Architecture` | `InitializeLattice` | v1 | Init | Yes |
| `Architecture` | `GenerateCandidate` | v1 | Propose | Yes |
| `Architecture` | `MutateCandidate` | v1 | Propose | Yes |
| `Architecture` | `ComposeSerial` | v1 | Propose | Yes |
| `Architecture` | `ComposeParallel` | v1 | Propose | Yes |
| `Architecture` | `Specialize` | v1 | Update | Yes |
| `Architecture` | `Reopen` | v1 | Update | Later |
| `Library` | `RetrieveModules` | v1 | Select | Yes |
| `Library` | `PromoteModule` | v1 | Update | Later |
| `ML` | `RankHypotheses` | v1 | Select | Later |
| `Solver` | `FillHoles` | v1 | Solve | Yes |
| `Solver` | `ConstraintPropagate` | v1 | Solve | Yes |
| `Executor` | `RunExact` | v1 | Core | Yes |
| `Evaluation` | `UpdateVersionSpace` | v1 | Update | Yes |
| `Evaluation` | `ScoreCandidate` | v1 | Objective | Yes |
| `Archive` | `UpdateDiversity` | v1 | Update | Yes |
| `Query` | `SelectDisagreement` | v1 | Select | Yes |
| `Verification` | `HeldoutExact` | v1 | Validation | Yes |
| `Verification` | `IndependentReplay` | v1 | Validation | Yes |
| `Verification` | `Equivalence` | v1 | Validation | Later |
| `Metric` | `DescriptionLength` | v1 | Metric | Yes |
| `Logging` | `LogIteration` | v1 | Logging | Yes |
| `Checkpoint` | `Save` | v1 | IO | Yes |
| `Checkpoint` | `Restore` | v1 | IO | Yes |
| `Termination` | `Terminated` | v1 | Termination | Yes |
| `Error` | `Emit` | v1 | Error | Yes |
| `Fingerprint` | `StateFingerprint` | v1 | Diagnostics | Yes |

Primitive namespaces required by candidates:

`Bit`, `BitVector`, `Arithmetic`, `Control`, `State`, `Memory`, `GF2`, `FiniteField`, and `Composition`.

## 0.H Namespacing and Packaging

- Fully qualified operator form: `paiv.<Namespace>.<Operator>_v#`.
- Imports use exact versions.
- No version collision is permitted in one run manifest.
- Canonical package structure is defined in Appendix D.
- Operator-to-file bindings are maintained in `sib-registry.yaml`.
- Document-to-implementation bindings are maintained in `sib-bindings.yaml`.
- Initial implementation artifacts must contain:

```text
EQC-SIB ArtID: <GlobalArtID> | Version: <vX.Y.Z>
```

## 0.I Outputs and Metric Schema

### Declared outputs

```text
RunResult = (
    status,
    recovered_program,
    recovered_program_digest,
    verification_level,
    ambiguity_report,
    metrics,
    trace,
    checkpoint_ref
)
```

### Required metrics

| Metric | Type | Unit | Rule |
|---|---|---|---|
| `train_exact_accuracy` | float64 | ratio | exact correct / total |
| `validation_exact_accuracy` | float64 | ratio | exact correct / total |
| `test_exact_accuracy` | float64 | ratio | exact correct / total |
| `active_candidate_count` | uint64 | candidates | semantically active |
| `active_semantic_class_count` | uint64 | classes | exact semantic buckets |
| `architecture_bit_hypotheses` | uint64 | pairs | candidate/output-bit pairs |
| `queries_used` | uint64 | queries | successful oracle calls |
| `description_length_bits` | uint64 | bits | canonical program encoding |
| `exact_evaluations` | uint64 | executions | reference executor calls |
| `wall_time_ms` | uint64 | ms | monotonic elapsed time |
| `peak_memory_bytes` | uint64 | bytes | measured or unavailable |
| `verification_level` | enum | none | L0-L4 |
| `false_acceptance_count` | uint64 | candidates | mandatory target is zero |

### Completion statuses

- `SUCCESS_VERIFIED`
- `SUCCESS_EMPIRICAL`
- `TERMINATED_BUDGET`
- `FAILED_NO_CANDIDATE`
- `FAILED_AMBIGUOUS`
- `FAILED_MODEL_MISMATCH`
- `FAILED_NUMERIC`
- `FAILED_REPLAY`
- `FAILED_VALIDATION`
- `FAILED_INTERNAL`

## 0.J Spec Lifecycle Governance

- **Compatibility baseline:** v0.1.0 is experimental and may receive breaking changes.
- **Semantic versioning:** MAJOR for behavior/contract breaks, MINOR for backward-compatible capability additions, PATCH for clarifications and non-semantic corrections.
- **Deprecation:** minimum one MINOR release before removal unless a safety or correctness defect requires immediate withdrawal.
- **Migration notes:** mandatory for every functional change.
- **Equivalence target:** Block VIII.
- **Status progression:** experimental -> active only after milestones M0-M4 pass under clean-room replay.

## 0.K Failure and Error Semantics

- **Global error model:** structured errors.
- Form:

```text
ERROR(code, operator, details, replay_token)
```

- Mandatory codes:
  - `ERROR_INPUT_INVALID`
  - `ERROR_SCHEMA_INVALID`
  - `ERROR_TYPE_INVALID`
  - `ERROR_NUMERIC_INVALID`
  - `ERROR_OPERATOR_UNDEFINED`
  - `ERROR_MEMORY_BOUNDS`
  - `ERROR_SOLVER_TIMEOUT`
  - `ERROR_SOLVER_UNKNOWN`
  - `ERROR_ORACLE_UNAVAILABLE`
  - `ERROR_DATA_LEAKAGE`
  - `ERROR_MODEL_MISMATCH`
  - `ERROR_CHECKPOINT_INVALID`
  - `ERROR_REPLAY_MISMATCH`
  - `ERROR_VERIFICATION_FAILED`
- **Error trace rule:** emit a final trace record with `t`, code, operator, diagnostics, and replay token.
- **Recovery policy:** deterministic retry budgets may be declared per solver; no silent retries.
- **Acceptance policy:** any unresolved internal error blocks verified acceptance.

## 0.L Input/Data Provenance

- **Default benchmark dataset:** generated uniformly from `{0..255}^48`.
- **External representation:** exactly 96 hexadecimal characters, case-insensitive, no prefix, no whitespace.
- **Decoding:** two hex characters per byte, left to right.
- **Target output:** one declared output bit.
- **Dataset partitions:** training, architecture-selection validation, and untouched final test.
- **Leakage rule:** no identical input may occur across partitions.
- **Generator provenance:** seed, PRNG, sample count, and generator version.
- **Target oracle provenance:** implementation identity, version, and digest.
- **SHA reference:** Python `hashlib.sha256` is used only as one independent implementation; the normative algorithm is the pinned NIST standard.
- **Caching:** keyed by input digest, oracle identity, and output-bit selection.
- **Parsing strictness:** any malformed input returns `ERROR_INPUT_INVALID`.

---

# Block I — System Model: State, Inputs, Domains

## I.A Persistent State

```text
RunState = {
    run_id: UUID,
    spec_version: string,
    phase: enum,
    t: uint64,
    rng_state: PCG64State,
    target_contract: TargetContract,
    bounds: SearchBounds,
    operator_manifest: Manifest,
    datasets: DatasetRegistry,
    observations: ordered list[Observation],
    representation_hypotheses: ordered map[RepID, RepState],
    architecture_lattice: ArchitectureLattice,
    active_candidates: ordered map[CandidateID, CandidateState],
    semantic_classes: ordered map[SemanticID, CandidateSet],
    module_library: ModuleLibrary,
    archive: DiversityArchive,
    solver_state: SolverPortfolioState,
    best_candidate_id: optional CandidateID,
    best_objective: ObjectiveTuple,
    ambiguity: AmbiguityReport,
    metrics: MetricRecord,
    trace: append-only Trace,
    checkpoint_sequence: uint64,
    completion_status: enum,
    failure: optional StructuredError
}
```

### Persistent candidate state

```text
CandidateState = {
    candidate_id,
    canonical_program,
    type_signature,
    unresolved_holes,
    provenance,
    exact_match_mask,
    semantic_signature,
    description_length_bits,
    resource_cost,
    status,
    verification_record
}
```

## I.B Inputs and Hyperparameters

### Immutable target inputs

- `input_schema`
- `output_schema`
- `target_access ∈ {static_dataset, queryable_black_box, formal_specification}`
- `observations`
- optional `oracle`
- optional `formal_specification`

### Search bounds

- `max_program_nodes`
- `max_program_depth`
- `max_modules`
- `max_rounds`
- `max_state_words`
- `allowed_word_widths`
- `max_array_length`
- `max_table_entries`
- `max_branches`
- `max_queries`
- `max_exact_evaluations`
- `wall_time_budget_ms`
- `memory_budget_bytes`
- `candidate_population_limit`
- `solver_timeout_ms`

### Initial benchmark profile: `SHA96-BIT0-PROFILE-v1`

```text
input: 96 hex characters -> 48 bytes
output: one bit
word widths: 8, 16, 32, 64
max rounds: 64
max state words: 16
allowed base primitives:
    XOR, AND, OR, NOT, MUX, BOOL3_TT,
    ADD_MOD, SUB_MOD,
    SHL, SHR, ROTL, ROTR,
    SLICE, CONCAT, PERMUTE,
    REGISTER_READ, REGISTER_WRITE,
    REPEAT_FIXED,
    SEQUENCE, PARALLEL, MERGE
```

## I.C Constraints and Feasible Set

A candidate is feasible if and only if:

1. every node is typed;
2. every width conversion is explicit;
3. every memory access is within declared bounds;
4. every loop or recurrence is statically bounded;
5. every state write is ordered;
6. all operations are present in the active manifest;
7. exact execution is deterministic;
8. serialized form is canonical;
9. resource cost is within the declared limits;
10. no undeclared external state is accessed.

Operator:

```text
paiv.Constraints.Feasible_v1(candidate, bounds, manifest) -> {0,1}
```

No penalty can convert an infeasible candidate into an accepted candidate.

## I.D Transient Variables

Transient values include:

- current proposal batch;
- probe results;
- solver assumptions;
- unsatisfiable cores;
- neural logits;
- temporary execution buffers;
- per-worker output vectors;
- proposed query inputs;
- candidate diffs;
- local caches.

Transient values may not be referenced after the iteration unless explicitly promoted into persistent state and logged.

## I.E Invariants and Assertions

Mandatory invariants:

1. `active_candidates` is sorted by candidate ID.
2. every active candidate is feasible.
3. every accepted observation is immutable and provenance-bound.
4. no final-test label is visible before final evaluation.
5. all candidates in one semantic class agree on the current probe set.
6. candidate elimination is monotonic within a fixed manifest and observation set.
7. reopening requires an explicit DSL or bound change and a new phase marker.
8. every candidate digest matches its canonical serialization.
9. `false_acceptance_count == 0` for `SUCCESS_VERIFIED`.
10. every checkpoint contains the full persistent state required for replay.
11. neural scores never override exact contradictions.
12. a target architecture is not considered generated if it was directly inserted into the initial candidate population.
13. benchmark claims identify whether the exact target was seeded, generated, retrieved, or supplied.

Assertions:

- no dataset overlap;
- no output leakage;
- no hidden SHA-specific operator in a benchmark that claims architecture-independent discovery;
- exact reference executor agrees with a second interpreter on mandatory vectors.

---

# Block II — Initialization

## II.A Initialization procedure

1. `t <- 0`
2. `rng_state <- Random.InitializePRNG_v1(seed)`
3. validate the target contract.
4. validate and normalize supplied observations.
5. generate or import partitioned datasets using `Data.SplitDataset_v1`.
6. compute dataset digests.
7. initialize the exact primitive operation manifest.
8. initialize input representations using `Representation.BuildViews_v1`.
9. initialize the broad architecture lattice using `Architecture.InitializeLattice_v1`.
10. retrieve compatible verified modules using `Library.RetrieveModules_v1`.
11. generate the initial candidate population without inserting the hidden target unless the benchmark explicitly declares `target_seeded=true`.
12. initialize semantic signatures and diversity archive.
13. set `best_candidate_id <- none`.
14. set metrics to zero.
15. emit the initialization trace record.
16. assert all Block I invariants.
17. set phase to `CHARACTERIZE`.

## II.B Initial architecture lattice

The lattice begins with generic typed categories:

```text
Bounded deterministic program
├── acyclic combinational graph
├── straight-line word program
├── fixed-round state machine
│   ├── ARX-like
│   ├── Boolean-mixing
│   ├── Feistel-like
│   ├── substitution/permutation
│   ├── sponge/permutation
│   └── generated hybrid
├── GF(2) recurrence
├── bounded finite-state machine
├── bounded parser/encoder
├── bounded memory program
└── serial/parallel composition
```

Categories are priors and generators, not final labels.

## II.C Initialization acceptance checks

Initialization fails if:

- the target contract is incomplete;
- the dataset split leaks inputs;
- the operation manifest is not version-complete;
- the correct target is deliberately inserted while the benchmark claims unseeded generation;
- the final-test set is accessible to proposal or selection operators;
- the canonicalizer or environment profile is missing.

---

# Block III — Operator Library

## III.A Common operator contract

Every operator below inherits the following unless overridden:

- **Purity:** `PURE`
- **Determinism:** deterministic
- **Failure behavior:** structured error per Block 0.K
- **No hidden globals:** only signature inputs, declared constants, and listed dependencies
- **Test vectors:** referenced by `TEST-001`
- **Canonical result:** required where the result enters persistent state

## III.B Core orchestration operators

### Operator: `paiv.Random.InitializePRNG_v1`

- **Category:** Init
- **Signature:** `(seed:uint64) -> rng_state:PCG64State`
- **Purity class:** PURE
- **Determinism:** deterministic
- **Definition:** initialize PCG64 from the exact unsigned 64-bit seed.
- **Preconditions:** seed in declared seed space.
- **Postconditions:** first generated value matches the pinned PCG64 test vector.
- **Edge cases:** seed `0` is valid.
- **Complexity:** `O(1)`.
- **Dependencies:** pinned NumPy PCG64 definition.
- **Failure:** `ERROR_SCHEMA_INVALID`.

### Operator: `paiv.Data.ValidateHex96_v1`

- **Category:** IO
- **Signature:** `(text:string) -> valid:bit`
- **Purity class:** PURE
- **Definition:** return `1` iff the text has length 96 and every character is hexadecimal.
- **Edge cases:** no `0x`, whitespace, separators, or Unicode lookalikes.
- **Complexity:** `O(96)`.
- **Failure:** never; validation returns a bit.

### Operator: `paiv.Data.DecodeHex96_v1`

- **Category:** IO
- **Signature:** `(text:Hex96) -> bytes[48]`
- **Purity class:** PURE
- **Definition:** decode each consecutive hexadecimal pair as one byte.
- **Preconditions:** `ValidateHex96_v1(text) == 1`.
- **Postconditions:** encoding the result as lowercase hexadecimal reproduces the lowercase input.
- **Failure:** `ERROR_INPUT_INVALID`.

### Operator: `paiv.Data.GenerateUniformHex96_v1`

- **Category:** Generator
- **Signature:** `(count:uint64, rng_state) -> (inputs:list[bytes48], rng_state')`
- **Purity class:** STATEFUL
- **Determinism:** stochastic but replayable.
- **Definition:** sample each byte independently and uniformly from `0..255`.
- **Postconditions:** exact count, no mutation of prior outputs.
- **Duplicate policy:** duplicates are detected; cross-partition duplicates are rejected and resampled.
- **Failure:** `ERROR_DATA_LEAKAGE` if uniqueness cannot be achieved within the retry budget.

### Operator: `paiv.Representation.BuildViews_v1`

- **Category:** Transform
- **Signature:** `(bytes48, representation_manifest) -> ordered map[RepID, TypedValue]`
- **Definition:** construct declared bit, byte, word, endian, field, and learned-grouping views without discarding the raw bytes.
- **Required initial views:** 384 bits, 48 bytes, 24x16-bit, 12x32-bit, 6x64-bit, big-endian and little-endian variants.
- **Edge cases:** incompatible grouping is omitted and logged.
- **Failure:** `ERROR_TYPE_INVALID`.

### Operator: `paiv.Probe.CharacterizeTarget_v1`

- **Category:** Diagnostics
- **Signature:** `(observations, optional oracle, probe_budget, rng_state) -> (fingerprint, rng_state')`
- **Definition:** compute output balance, input influence estimates, linear/affine tests, locality, periodicity, field boundaries, and architecture-family evidence.
- **Oracle rule:** perturbation probes are permitted only with a queryable oracle or matching supplied observations.
- **Output role:** ranking only; cannot eliminate a legal candidate by itself in complete mode.
- **Failure:** returns `fingerprint_uncertain` rather than inventing evidence.

### Operator: `paiv.Architecture.InitializeLattice_v1`

- **Category:** Init
- **Signature:** `(types, primitive_manifest, bounds) -> ArchitectureLattice`
- **Definition:** build the canonical hierarchy of architecture generators and composition rules.
- **Postconditions:** every generated structure compiles to the common typed IR.
- **Failure:** `ERROR_SCHEMA_INVALID`.

### Operator: `paiv.Architecture.GenerateCandidate_v1`

- **Category:** Propose
- **Signature:** `(lattice_node, context, rng_state) -> (candidate, rng_state')`
- **Purity class:** STATEFUL
- **Determinism:** stochastic but replayable.
- **Definition:** generate a candidate graph from primitive constructors and retrieved modules.
- **Mandatory provenance:** generator node, parent IDs, mutation trace, seed fingerprint.
- **Target-seeding rule:** direct insertion of a reference implementation is forbidden unless the benchmark declares `target_seeded=true`.
- **Failure:** invalid proposals are returned as rejected proposal records.

### Operator: `paiv.Architecture.MutateCandidate_v1`

- **Category:** Propose
- **Signature:** `(candidate, mutation_policy, rng_state) -> (candidate', rng_state')`
- **Allowed mutations:** operation replace, edge reroute, constant mutate, module duplicate, module delete, serial insert, parallel branch, round-count change, state-width change, schedule-tap change.
- **Postconditions:** candidate' is either feasible or explicitly rejected.
- **Failure:** no silent repair.

### Operator: `paiv.Architecture.ComposeSerial_v1`

- **Category:** Propose
- **Signature:** `(P:A->B, Q:B->C) -> R:A->C`
- **Definition:** typed serial composition.
- **Edge cases:** incompatible types fail.
- **Complexity:** additive node count before simplification.

### Operator: `paiv.Architecture.ComposeParallel_v1`

- **Category:** Propose
- **Signature:** `(P:A->B, Q:A->C, combiner:B×C->D) -> R:A->D`
- **Definition:** evaluate branches under deterministic order then combine.
- **State rule:** shared-state writes are forbidden unless explicitly reduced.

### Operator: `paiv.Architecture.Specialize_v1`

- **Category:** Update
- **Signature:** `(candidate_set, evidence, policy) -> specialized_candidate_set`
- **Definition:** narrow unresolved types, structures, operations, constants, routes, and repetitions when exact evidence supports the narrowing.
- **Hard-pruning rule:** only exact contradiction permits irreversible removal in complete mode.
- **Heuristic mode:** low-ranked branches may be suspended, not described as impossible.

### Operator: `paiv.Library.RetrieveModules_v1`

- **Category:** Select
- **Signature:** `(fingerprint, type_signature, module_library) -> ordered module list`
- **Definition:** retrieve verified modules by type, semantic signature, normalized graph, and benchmark-independent features.
- **Contamination rule:** benchmark identity and target name are excluded from retrieval keys in blind tests.

### Operator: `paiv.Library.PromoteModule_v1`

- **Category:** Update
- **Signature:** `(subgraph, evidence, library) -> library'`
- **Promotion conditions:** exact semantics, repeated independent occurrence, description-length improvement, transfer benefit, provenance, checksum, and regression tests.
- **Failure:** rejected proposals remain traceable but are not executable library entries.

### Operator: `paiv.ML.RankHypotheses_v1`

- **Category:** Select
- **Signature:** `(observations, fingerprint, candidates, solver_state, model) -> scores`
- **Purity class:** PURE for fixed model.
- **Definition:** score representations, architecture generators, modules, mutations, and solver allocation.
- **Acceptance prohibition:** scores cannot make an incorrect candidate valid.
- **NaN policy:** score becomes worst rank and emits diagnostic.

### Operator: `paiv.Solver.FillHoles_v1`

- **Category:** Solve
- **Signature:** `(sketch, constraints, solver_profile) -> result`
- **Definition:** solve finite operator, constant, routing, width, and repetition holes using enumeration, SAT, SMT, SyGuS, or deterministic hybrid search.
- **Result:** `SAT(candidate)`, `UNSAT(core)`, `UNKNOWN(reason)`, or `TIMEOUT`.
- **Failure:** solver unknown is not interpreted as absence.

### Operator: `paiv.Solver.ConstraintPropagate_v1`

- **Category:** Solve
- **Signature:** `(partial_candidate, observations, abstract_state) -> refined_state`
- **Definition:** apply type, width, bit-mask, interval, congruence, path, and dependency propagation before complete execution.
- **Soundness:** pruning must be sound in complete mode.

### Operator: `paiv.Executor.RunExact_v1`

- **Category:** Core
- **Signature:** `(program, input) -> output | ERROR`
- **Definition:** execute the canonical discrete program using exact typed semantics.
- **No approximation:** neural or soft routing is forbidden.
- **Independent implementations:** reference interpreter A and acceptance interpreter B.
- **Failure:** any undefined behavior is a structured error.

### Operator: `paiv.Evaluation.UpdateVersionSpace_v1`

- **Category:** Update
- **Signature:** `(candidate_set, observation) -> candidate_set'`
- **Definition:** execute candidates and remove exact contradictions; update surviving output-bit masks and semantic classes.
- **Monotonicity:** candidate count cannot increase under a fixed DSL and observation set.
- **Output:** elimination reasons per candidate.

### Operator: `paiv.Evaluation.ScoreCandidate_v1`

- **Category:** Objective
- **Signature:** `(candidate, evidence, metrics) -> ObjectiveTuple`
- **Definition:** compute the Block 0.A tuple exactly.
- **Tie handling:** deterministic candidate ID.

### Operator: `paiv.Archive.UpdateDiversity_v1`

- **Category:** Update
- **Signature:** `(archive, candidates, descriptors) -> archive'`
- **Definition:** preserve high-quality candidates in deterministic behavior/structure cells.
- **Descriptors:** architecture family, state size, recurrence, operation distribution, depth, width, module reuse.
- **Purpose:** prevent premature convergence while preserving exact ranking.

### Operator: `paiv.Query.SelectDisagreement_v1`

- **Category:** Select
- **Signature:** `(survivors, input_domain, query_budget, solver) -> optional input`
- **Definition:** choose the lexicographically lowest highest-value input that maximizes semantic disagreement after deterministic scoring.
- **Static dataset mode:** may propose but cannot label an input.
- **Failure:** none if no distinguishing input exists; return `none`.

### Operator: `paiv.Verification.HeldoutExact_v1`

- **Category:** Validation
- **Signature:** `(program, untouched_dataset, oracle) -> VerificationRecord`
- **Definition:** exact evaluation on a sealed test set.
- **Leakage guard:** the operator verifies that test-set digest was committed before search.
- **SHA final gate:** every test must match.

### Operator: `paiv.Verification.IndependentReplay_v1`

- **Category:** Validation
- **Signature:** `(canonical_program, test_vectors, interpreter_B) -> VerificationRecord`
- **Definition:** deserialize and execute the program in a separately implemented exact interpreter.
- **Failure:** any disagreement invalidates acceptance.

### Operator: `paiv.Verification.Equivalence_v1`

- **Category:** Validation
- **Signature:** `(candidate, specification, domain_model) -> PROVED | COUNTEREXAMPLE | UNKNOWN`
- **Definition:** use exhaustive enumeration, SAT/SMT, theorem proving, or translation validation.
- **UNKNOWN:** not proof.

### Operator: `paiv.Metric.DescriptionLength_v1`

- **Category:** Metric
- **Signature:** `(canonical_program, encoding_version) -> uint64`
- **Definition:** bit length of the canonical self-delimiting representation.
- **Use:** simplicity preference only after exact correctness fields.

### Operator: `paiv.Logging.LogIteration_v1`

- **Category:** Logging
- **Signature:** `(trace, trace_record) -> trace'`
- **Purity class:** IO
- **Definition:** append canonical record; records are immutable after commit.
- **Failure:** logging failure aborts verified runs.

### Operator: `paiv.Checkpoint.Save_v1`

- **Category:** IO
- **Signature:** `(persistent_state, destination) -> checkpoint_ref`
- **Definition:** serialize Block IX contents, compute digests, then atomically publish.
- **Failure:** partial checkpoints are invalid and removed.

### Operator: `paiv.Checkpoint.Restore_v1`

- **Category:** IO
- **Signature:** `(checkpoint_ref, environment) -> persistent_state`
- **Definition:** verify signatures, manifests, policies, and digests before restoring.
- **Failure:** `ERROR_CHECKPOINT_INVALID`.

### Operator: `paiv.Termination.Terminated_v1`

- **Category:** Termination
- **Signature:** `(persistent_state, bounds) -> (bit, reason_code)`
- **Termination conditions:** verified success, no candidate, ambiguity with exhausted budget, resource limit, unrecoverable error, or explicit user stop.
- **Priority:** error > verified success > no candidate > budget.

### Operator: `paiv.Fingerprint.StateFingerprint_v1`

- **Category:** Diagnostics
- **Signature:** `(persistent_state) -> SHA256Digest`
- **Definition:** hash canonical persistent state excluding wall-clock-only metrics.

## III.C Primitive typed operator library

| Operator | Signature | Exact definition | Edge/failure rule |
|---|---|---|---|
| `Bit.XOR_v1` | `Bit×Bit->Bit` | exclusive OR | total |
| `Bit.AND_v1` | `Bit×Bit->Bit` | conjunction | total |
| `Bit.OR_v1` | `Bit×Bit->Bit` | disjunction | total |
| `Bit.NOT_v1` | `Bit->Bit` | complement | total |
| `BitVector.XOR_v1` | `BV[w]×BV[w]->BV[w]` | bitwise XOR | widths must match |
| `BitVector.AND_v1` | `BV[w]×BV[w]->BV[w]` | bitwise AND | widths must match |
| `BitVector.OR_v1` | `BV[w]×BV[w]->BV[w]` | bitwise OR | widths must match |
| `BitVector.NOT_v1` | `BV[w]->BV[w]` | width-limited complement | total |
| `BitVector.ROTR_v1` | `BV[w]×uint->BV[w]` | rotate right by `n mod w` | `w>0` |
| `BitVector.ROTL_v1` | `BV[w]×uint->BV[w]` | rotate left by `n mod w` | `w>0` |
| `BitVector.SHR_v1` | `BV[w]×uint->BV[w]` | zero-fill right shift | `n>=w` gives zero |
| `BitVector.SHL_v1` | `BV[w]×uint->BV[w]` | left shift modulo width | `n>=w` gives zero |
| `BitVector.SLICE_v1` | `BV[w]×range->BV[k]` | selected contiguous bits | valid range required |
| `BitVector.CONCAT_v1` | `BV[a]×BV[b]->BV[a+b]` | exact concatenation | max width bound |
| `BitVector.PERMUTE_v1` | `BV[w]×perm[w]->BV[w]` | output bit `i=input[perm[i]]` | permutation must be bijective |
| `Arithmetic.ADD_MOD_v1` | `BV[w]^n->BV[w]` | sum modulo `2^w` | total |
| `Arithmetic.SUB_MOD_v1` | `BV[w]×BV[w]->BV[w]` | difference modulo `2^w` | total |
| `Control.MUX_v1` | `Bit×T×T->T` | select true/false branch | types equal |
| `Control.BOOL3_TT_v1` | `BV[w]^3×uint8->BV[w]` | bitwise arbitrary 3-input truth table | total |
| `Control.REPEAT_FIXED_v1` | `State×Module×uint->State` | repeat exact module `n` times | `n<=max_rounds` |
| `State.READ_v1` | `State×index->T` | deterministic indexed read | bounds required |
| `State.WRITE_v1` | `State×index×T->State` | copy-on-write update | bounds/type required |
| `Memory.TABLE_LOOKUP_v1` | `Array[T,n]×index->T` | exact lookup | bounds required |
| `GF2.XOR_REDUCE_v1` | `BV[w]^n->BV[w]` | XOR reduction in index order | total |
| `Composition.SEQUENCE_v1` | `(A->B)×(B->C)->(A->C)` | serial composition | type match |
| `Composition.PARALLEL_v1` | `(A->B)×(A->C)->(A->B×C)` | ordered pair | isolated state |
| `Composition.MERGE_v1` | `B×C×Combiner->D` | exact combiner call | typed |

## III.D Randomness rule

`SAMPLE` may appear only inside operators that thread `rng_state`. The algorithm procedure itself contains no implicit randomness.

## III.E Constraint handling

The project uses strict feasibility:

```text
infeasible candidate -> reject
```

Penalties may rank feasible approximate candidates in exploratory modes but cannot make an infeasible candidate acceptable.

---

# Block IV — Algorithm Procedure

## IV.A Main procedure: `PAIV.Execute_v1`

```text
PROCEDURE PAIV.Execute_v1(task, seed, bounds):

    state <- BlockII.Initialize(task, seed, bounds)
    Logging.LogIteration_v1(INIT_RECORD(state))

    WHILE NOT Termination.Terminated_v1(state, bounds):

        IF state.phase == CHARACTERIZE:
            fingerprint <- Probe.CharacterizeTarget_v1(
                state.observations,
                task.oracle,
                bounds.probe_budget,
                state.rng_state
            )
            state.architecture_lattice <- Architecture.Specialize_v1(
                state.architecture_lattice,
                fingerprint,
                soft_only_policy
            )
            state.phase <- SEARCH

        ELSE IF state.phase == SEARCH:
            retrieved <- Library.RetrieveModules_v1(
                fingerprint,
                task.input_schema -> task.output_schema,
                state.module_library
            )

            proposals <- Architecture.GenerateCandidate_v1(
                state.architecture_lattice,
                {
                    observations,
                    retrieved,
                    archive,
                    solver_state,
                    bounds
                },
                state.rng_state
            )

            proposals <- proposals
                UNION Architecture.MutateCandidate_v1(...)
                UNION Architecture.ComposeSerial_v1(...)
                UNION Architecture.ComposeParallel_v1(...)

            feasible_proposals <- FILTER(
                proposals,
                Constraints.Feasible_v1
            )

            solved_proposals <- Solver.FillHoles_v1(
                feasible_proposals,
                observations,
                solver_profile
            )

            state.active_candidates <- state.active_candidates
                UNION canonicalize(solved_proposals)

            state.active_candidates <- Evaluation.UpdateVersionSpace_v1(
                state.active_candidates,
                state.observations
            )

            state.archive <- Archive.UpdateDiversity_v1(
                state.archive,
                state.active_candidates,
                architecture_descriptors
            )

            state.best_candidate_id <- ARGMIN(
                Evaluation.ScoreCandidate_v1(candidate)
            )

            IF count_non_equivalent(state.active_candidates) > 1
               AND task.target_access != static_dataset:
                state.phase <- DISCRIMINATE
            ELSE:
                state.phase <- VERIFY

        ELSE IF state.phase == DISCRIMINATE:
            query_input <- Query.SelectDisagreement_v1(
                state.active_candidates,
                task.input_domain,
                bounds.query_budget,
                state.solver_state
            )

            IF query_input == none:
                state.phase <- VERIFY
            ELSE:
                observed_bit <- Oracle.QueryTargetBit_v1(
                    task.oracle,
                    query_input
                )
                state.observations <- append_immutable(
                    state.observations,
                    (query_input, observed_bit)
                )
                state.active_candidates <- Evaluation.UpdateVersionSpace_v1(
                    state.active_candidates,
                    (query_input, observed_bit)
                )
                state.metrics.queries_used <- state.metrics.queries_used + 1
                state.phase <- SEARCH

        ELSE IF state.phase == VERIFY:
            candidate <- state.active_candidates[state.best_candidate_id]

            heldout_record <- Verification.HeldoutExact_v1(
                candidate,
                sealed_test_set,
                task.oracle
            )

            replay_record <- Verification.IndependentReplay_v1(
                candidate.canonical_program,
                mandatory_test_vectors,
                interpreter_B
            )

            IF task.target_access == formal_specification:
                equivalence_record <- Verification.Equivalence_v1(
                    candidate,
                    task.specification,
                    task.domain_model
                )
            ELSE:
                equivalence_record <- NOT_AVAILABLE

            state <- UPDATE_VERIFICATION_STATE(
                state,
                candidate,
                heldout_record,
                replay_record,
                equivalence_record
            )

            IF ACCEPTANCE_GATE_SATISFIED(state):
                state.phase <- LEARN
            ELSE IF counterexample_available:
                state.observations <- append_immutable(
                    state.observations,
                    counterexample
                )
                state.phase <- SEARCH
            ELSE:
                state.completion_status <- FAILED_VALIDATION

        ELSE IF state.phase == LEARN:
            state.module_library <- Library.PromoteModule_v1(
                verified_repeated_subgraphs,
                transfer_evidence,
                state.module_library
            )
            state.completion_status <- SUCCESS_VERIFIED

        state.metrics <- UPDATE_REQUIRED_METRICS(state)
        state.trace <- Logging.LogIteration_v1(
            state.trace,
            TRACE_RECORD(state)
        )
        state.t <- state.t + 1

        IF CHECKPOINT_DUE(state):
            state.checkpoint_sequence <- state.checkpoint_sequence + 1
            checkpoint_ref <- Checkpoint.Save_v1(state, destination)

    RETURN BUILD_RUN_RESULT(state)
```

## IV.B Total state update table

| Persistent field | Update each iteration |
|---|---|
| `phase` | explicit branch assignment or unchanged |
| `t` | `t+1` |
| `rng_state` | returned by stochastic operator or unchanged |
| `observations` | immutable append or unchanged |
| `architecture_lattice` | specialized or unchanged |
| `active_candidates` | generated/eliminated/unchanged |
| `semantic_classes` | recomputed after candidate changes |
| `module_library` | promotion or unchanged |
| `archive` | deterministic update or unchanged |
| `solver_state` | updated by solver calls or unchanged |
| `best_candidate_id` | recomputed or unchanged if no candidates |
| `best_objective` | recomputed with best candidate |
| `ambiguity` | recomputed after semantic changes |
| `metrics` | updated every iteration |
| `trace` | appended every iteration |
| `checkpoint_sequence` | incremented when saved |
| `completion_status` | explicit or running |
| `failure` | structured error or none |

## IV.C No implicit side effects

Only declared IO operators may write files, query an oracle, append trace records, or publish checkpoints. Candidate execution is pure.

---

# Block V — Observability, Trace, Comparability

## V.A Logging rule

Every iteration, including initialization, termination, and failure, calls `paiv.Logging.LogIteration_v1`.

## V.B Required trace schema

```text
TraceRecord = {
    schema_version,
    run_id,
    t,
    phase,
    timestamp_monotonic_ns,
    replay_token,
    state_fingerprint,
    dataset_digest,
    manifest_digest,
    active_candidate_count,
    active_semantic_class_count,
    architecture_bit_hypotheses,
    generated_count,
    rejected_invalid_count,
    eliminated_mismatch_count,
    suspended_count,
    reopened_count,
    best_candidate_id,
    best_objective,
    best_train_accuracy,
    best_validation_accuracy,
    best_test_accuracy_if_released,
    queries_used,
    exact_evaluations,
    solver_calls,
    solver_sat,
    solver_unsat,
    solver_unknown,
    solver_timeout,
    architecture_family_histogram,
    representation_histogram,
    module_reuse_count,
    description_length_bits,
    verification_level,
    invariant_status,
    failure_code,
    failure_operator,
    checkpoint_ref
}
```

## V.C Metric comparability

Metrics are comparable only when:

- input contract is identical;
- target oracle identity is identical;
- output-bit definition is identical;
- dataset generation and split policy are identical;
- compute and query budgets are declared;
- acceptance gate is identical;
- target seeding status is identical;
- DSL and bounds are declared.

## V.D Mandatory benchmark disclosure

Every benchmark report must state:

```text
target_name_disclosed_to_learner: yes/no
target_architecture_seeded: yes/no
target_architecture_retrieved: yes/no
target_architecture_generated: yes/no
target_present_in_dsl: yes/no/unknown
full_output_available: yes/no
intermediate_traces_available: yes/no
oracle_access: static/queryable/specification
```

Failure to disclose these fields invalidates comparisons.

---

# Block VI — Parallelism and Nondeterminism Semantics

- Candidate execution may run in parallel.
- Proposal generation may run in parallel from immutable snapshots.
- Worker result order is normalized by candidate ID.
- Duplicate candidates are resolved by canonical digest; the lowest provenance ID is retained.
- No asynchronous archive updates.
- Solver portfolio responses are committed in deterministic request ID order.
- GPU kernels cannot be used for exact acceptance unless bitwise equivalence is independently demonstrated.
- Distributed checkpoints include worker partition maps and result digests.
- Parallel speed changes may target E1 metric equivalence; exact candidate outputs remain E0.

---

# Block VII — Validation, Test Vectors, and Tooling

## VII.A Lint rules

The specification and implementation must pass all EQC v1.1 lint classes:

1. symbol completeness;
2. no hidden globals;
3. total state updates;
4. stochastic explicitness;
5. edge-case totality;
6. ordering and tie adherence;
7. trace compliance;
8. manifest completeness;
9. versioned initialization;
10. parallel policy declaration;
11. total objective preorder;
12. total constraint policy;
13. purity class for every operator;
14. deterministic failure semantics;
15. data provenance.

Additional PAIV rules:

16. sealed final-test set;
17. target-seeding disclosure;
18. target-architecture provenance;
19. exact executor independence;
20. no neural acceptance;
21. no hidden target-name feature;
22. candidate generator can produce canonical serialization;
23. search-budget comparability;
24. false acceptance must remain zero.

## VII.B Mandatory test vectors

### Input parsing

| ID | Input | Expected |
|---|---|---|
| `TV-HEX-001` | 96 zeros | 48 zero bytes |
| `TV-HEX-002` | uppercase valid hex | accepted and normalized |
| `TV-HEX-003` | 95 characters | `ERROR_INPUT_INVALID` |
| `TV-HEX-004` | includes `g` | `ERROR_INPUT_INVALID` |
| `TV-HEX-005` | prefixed with `0x` | `ERROR_INPUT_INVALID` |

### Primitive operations

Each primitive receives exhaustive tests for small widths and boundary tests for 32/64 bits.

Required SHA-sensitive vectors:

- rotation by `0`, `1`, `31`, `32`, `33`;
- modular addition overflow;
- arbitrary Boolean truth-table correctness for all eight input triples;
- big-endian word parsing;
- fixed padding of a 48-byte message;
- output-bit numbering.

### Version-space elimination

- one observation cannot increase the survivor set;
- the correct seeded candidate is never removed;
- an incorrect candidate is removed by a distinguishing observation;
- duplicate semantic candidates share a class;
- final unique candidate must be independently replayable.

## VII.C Current experimental evidence

### Experiment E0 — Known exact SHA architecture with trainable readout

- Artifact: `sha_known_architecture_trainable_head.py`
- Artifact SHA-256: `bd1a14c0af8b3aa0e29199cc875ff2a1325e80256354a0bf5779e8eac3dcd181`
- Run log SHA-256: `ee98394c203dec338ca18be9bd1e1a0988a0127cad3a885e19fb3f37a31a38b6`
- Training examples: `12,000`
- Untouched test examples: `4,000`
- Result: `100%` training and `100%` test accuracy.
- Independent core check: exact match with `hashlib`.
- Interpretation: proves only that the exact supplied SHA core plus learned bit selector reaches 100%.

### Experiment E1 — Finite progressive SHA-style version space

- Artifact: `progressive_sha_architecture_recovery.py`
- Artifact SHA-256: `55d706b8ef7d4915041bfc7bc42b84a25b01204b5afb4dac94db4a79c34cb115`
- Run log SHA-256: `6ee27825fc9b4a40a8c70e92dad0c9655d455701f01a4689dd421dbe965234e3`
- Initial architecture cores: `756`
- Initial architecture/output-bit hypotheses: `193,536`
- Training observations used: `17`
- Unique recovered configuration: SHA schedule, constants, Boolean logic, 64 rounds, output bit 0.
- Untouched test examples: `10,000`
- Result: `100%`.
- Interpretation: proves exact selection inside a finite declared family containing the target.

### Experiment E2 — Generic generated round-machine population with seeded exact target

- Artifact: `progressive_generic_round_machine.py`
- Artifact SHA-256: `d6618fc63c373df38afbf3ffdfcbb778ff62791de9bed105aa76e1e8bd42f687`
- Run log SHA-256: `5e5ad06669e243a6f0fc81195887b805e126b855b92258fc9127de77784328af`
- Initial generated architectures: `20,000`
- Initial architecture/output-bit hypotheses: `5,120,000`
- Training observations used: `20`
- Untouched test examples: `10,000`
- Result: `100%`.
- Critical limitation: the exact SHA parameter vector was inserted at a random population index.
- Interpretation: demonstrates elimination among a broad generic round-machine family, not unseeded architecture invention.

## VII.D Required next falsification milestone

### M3 — Unseeded one-mutation recovery

The exact target candidate must be absent from the initial population. At least one initial candidate must be exactly one declared mutation away. The system must:

1. generate the missing mutation without target-name access;
2. identify it using training/validation evidence;
3. reach 100% on 10,000 untouched inputs;
4. independently replay the program;
5. log complete provenance showing the target was not seeded.

Failure at M3 blocks stronger claims.

## VII.E Full validation ladder

| Milestone | Target | Initial target presence | Required result |
|---|---|---|---|
| M0 | exact supplied SHA core | supplied | 100% |
| M1 | finite SHA-style family | present | unique, 100% |
| M2 | generic round-machine population | seeded present | unique, 100% |
| M3 | generic population | absent, one mutation away | generated, 100% |
| M4 | generic population | absent, multi-step | generated, 100% |
| M5 | reduced-round SHA-like | absent | exact recovered |
| M6 | full SHA-256 bit 0 | absent | exact recovered |
| M7 | unseen non-SHA cryptographic families | absent | exact family-specific recovery |
| M8 | serial/parallel composite targets | absent | exact compositional recovery |
| M9 | machine-discovered reusable family | absent | transfer improvement verified |

## VII.F Golden traces

Required golden traces:

- `GT-M0-known-sha-v1.jsonl`
- `GT-M1-progressive-family-v1.jsonl`
- `GT-M2-generic-seeded-v1.jsonl`
- `GT-M3-unseeded-one-mutation-v1.jsonl` after completion.

Golden traces include environment digest, seed, target contract, candidate population digest, survivor counts, and final program digest.

## VII.G Machine-readable sidecars

Required sidecars:

- `ecosystem-registry.yaml`
- `ecosystem-graph.yaml`
- `compatibility.yaml`
- `data-registry.yaml`
- `sib-registry.yaml`
- `sib-bindings.yaml`
- `tooling-manifest.yaml`
- `trace-schema.json`
- `checkpoint-schema.json`

---

# Block VIII — Refactoring, Optimization, and Semantic Equivalence

## VIII.A Equivalence levels

- **E0 Trace-equivalent:** identical canonical traces excluding explicitly non-functional wall-clock fields.
- **E1 Metric-equivalent:** identical required metrics and final program; performance counters may differ.
- **E2 Distribution-equivalent:** only for stochastic search-policy comparisons; exact target program acceptance is still required.
- **E3 Invariant-equivalent:** preserves declared invariants but may produce different valid programs.

Required levels:

| Change | Minimum |
|---|---|
| exact executor refactor | E0 |
| candidate canonicalizer change | E0 |
| parallelization | E1 plus exact final program equality |
| neural ranker replacement | E1 across benchmark suite |
| proposal generator expansion | E1 on old suite, new coverage tests |
| module-library promotion | E1 and contamination audit |
| description-length encoding change | breaking unless migration supplied |
| trace schema change | MAJOR |

## VIII.B Allowed refactors

- algebraic simplification;
- verified rewrite rules;
- constant folding;
- vectorization and deterministic batching;
- semantic memoization;
- deterministic parallel execution;
- solver replacement with equal semantics;
- neural ranking replacement;
- operator version replacement through manifest update.

## VIII.C Equivalence test procedure

- fixed seed set: at least 30 seeds for stochastic search comparisons;
- mandatory benchmark set: Boolean, arithmetic, ARX, GF(2), reduced SHA-like, composition, negative control;
- exact metrics: false acceptance, final accuracy, recovered program digest where uniqueness is expected;
- statistical metrics: time-to-solve, queries, memory, evaluations;
- multiple-comparison correction: Holm method for exploratory comparisons;
- any false acceptance is an automatic failure;
- improvements must state target-seeding status.

## VIII.D Breaking-change rules

The following are breaking:

- changing output-bit numbering;
- changing hex decoding;
- changing exact overflow;
- changing canonical program encoding;
- allowing neural acceptance;
- weakening final-test sealing;
- hiding target-seeding status;
- changing the objective preorder;
- removing independent replay.

---

# Block IX — Checkpoint, Restore, and Long-Run Replay

## IX.A Checkpoint contents

A checkpoint contains:

- complete `RunState`;
- PRNG state;
- observation list and digests;
- partition commitments;
- architecture lattice;
- active candidates or content-addressed references;
- semantic classes;
- diversity archive;
- module library bindings;
- solver pending requests;
- operator manifest;
- policy hashes;
- environment profile;
- trace schema version;
- completion status and reason;
- state fingerprint;
- parent checkpoint digest;
- atomic checkpoint digest.

## IX.B Serialization

- **Format:** canonical CBOR or canonical JSON for metadata; binary content-addressed blobs for large arrays.
- **Endianness:** network byte order for portable integer fields.
- **Float encoding:** hexadecimal IEEE representation in canonical JSON.
- **Version tag:** `paiv-checkpoint-v1`.
- **Atomicity:** write temporary, verify digest, then rename.
- **Restore guarantee:** E0 for exact pipeline state.
- **Forward compatibility:** readers may reject unknown MAJOR versions; unknown optional PATCH fields are ignored only if marked metadata.
- **Security:** checkpoint signatures are required before distributed execution.

---

# Appendix A — System Components and Connections

```text
Target observations / oracle
        |
        v
Observation and provenance manager
        |
        v
Multi-representation encoder
        |
        v
Target characterization
        |
        v
Architecture hypothesis lattice
        |
        +--------------------+
        |                    |
        v                    v
Architecture generator   Verified module library
        |                    ^
        v                    |
Neural meta-controller      |
        |                    |
        v                    |
Symbolic hole solver         |
        |                    |
        v                    |
Exact candidate executor     |
        |                    |
        v                    |
Version-space eliminator     |
        |                    |
        v                    |
Quality-diversity archive ---+
        |
        +--> disagreement query generator --> target oracle
        |
        v
Independent verification
        |
        v
Canonical recovered program
        |
        v
Module discovery and promotion
```

### Component responsibilities

| Component | Function |
|---|---|
| Observation manager | normalize, split, seal, hash, and track target data |
| Representation encoder | preserve multiple typed interpretations |
| Characterizer | generate soft evidence about structure |
| Hypothesis lattice | maintain broad-to-specific architecture commitments |
| Generator | create known, hybrid, and novel candidate graphs |
| ML controller | rank proposals and allocate compute |
| Solver | fill exact holes and propagate constraints |
| Executor | run candidates with exact semantics |
| Version space | eliminate contradictions and report ambiguity |
| Diversity archive | preserve structurally different high-quality candidates |
| Query generator | select inputs that distinguish survivors |
| Verifier | test, replay, and prove where possible |
| Module learner | promote verified repeated structures |

---

# Appendix B — Project Portfolio Registry

The project begins as a central-root portfolio.

| DocID | Title | Type | Layer | Version | Status | Path |
|---|---|---|---:|---|---|---|
| `CORE-001` | EquationCode v1.1 | core-guidelines | 0 | v1.1 | external frozen | `external/EquationCode/EQC.md` |
| `ES-001` | PAIV Ecosystem Governance | core-guidelines | 0 | v0.1.0 | experimental | `governance/EQC-ES-PAIV.md` |
| `ALGO-001` | PAIV Master Specification | algorithm-spec | 2 | v0.1.0 | experimental | `docs/ALGO-001-PAIV.md` |
| `OPLIB-001` | PAIV Primitive and Architecture Operators | operator-library | 1 | v0.1.0 | experimental | `docs/OPLIB-001.md` |
| `DATA-001` | PAIV Dataset Registry | data-registry | 1 | v0.1.0 | experimental | `governance/data-registry.yaml` |
| `SCHEMA-001` | PAIV Checkpoint Schema | checkpoint-schema | 2 | v0.1.0 | experimental | `schemas/checkpoint-schema.json` |
| `TEST-001` | PAIV Validation Suite | test-suite | 3 | v0.1.0 | experimental | `docs/TEST-001.md` |
| `TRACE-001` | PAIV Golden Trace Set | golden-trace-set | 3 | v0.1.0 | experimental | `traces/TRACE-001.md` |
| `SIB-001` | PAIV Spec-Implementation Bridge | other | 0 | v0.1.0 | experimental | `governance/EQC-SIB-PAIV.md` |
| `IMPL-001` | Exact Typed IR and Executor | derived-impl | 4 | v0.1.0 | planned | `src/paiv/ir_executor.py` |
| `IMPL-002` | Architecture Generator | derived-impl | 4 | v0.1.0 | planned | `src/paiv/generator.py` |
| `IMPL-003` | Version-Space Engine | derived-impl | 4 | v0.1.0 | planned | `src/paiv/version_space.py` |
| `IMPL-004` | Solver Portfolio | derived-impl | 4 | v0.1.0 | planned | `src/paiv/solver.py` |
| `IMPL-005` | Neural Guidance | derived-impl | 4 | v0.1.0 | planned | `src/paiv/neural.py` |
| `HARNESS-001` | Benchmark and Golden Trace Runner | derived-impl | 4 | v0.1.0 | planned | `tests/benchmark_runner.py` |

---

# Appendix C — Initial Spec–Implementation Bindings

| ArtID | Type | Layer | Governing documents | Binding |
|---|---|---:|---|---|
| `IMPL-001` | reference-impl | 1 | ALGO-001 Block 0.C, III.C, IV | IMPLEMENTS exact semantics |
| `IMPL-002` | generator | 2 | ALGO-001 II.B, III.B, IV | IMPLEMENTS candidate generation |
| `IMPL-003` | operator-impl | 2 | ALGO-001 III.B, IV, V | IMPLEMENTS elimination and ambiguity |
| `IMPL-004` | operator-impl | 2 | ALGO-001 III.B | IMPLEMENTS solving |
| `IMPL-005` | operator-impl | 2 | ALGO-001 III.B | IMPLEMENTS ranking only |
| `HARNESS-001` | test-harness | 3 | TEST-001, ALGO-001 VII | VALIDATES all implementation artifacts |
| `SCRIPT-E0` | benchmark | 3 | ALGO-001 VII.C | EVIDENCE known architecture |
| `SCRIPT-E1` | benchmark | 3 | ALGO-001 VII.C | EVIDENCE finite family |
| `SCRIPT-E2` | benchmark | 3 | ALGO-001 VII.C | EVIDENCE generic seeded family |

All implementation artifacts must contain the EQC-SIB inline version marker.

---

# Appendix D — Initial Repository Layout

```text
paiv/
├── README.md
├── LICENSE
├── pyproject.toml
├── requirements-lock.txt
├── governance/
│   ├── EQC-ES-PAIV.md
│   ├── EQC-SIB-PAIV.md
│   ├── ecosystem-registry.yaml
│   ├── ecosystem-graph.yaml
│   ├── compatibility.yaml
│   ├── data-registry.yaml
│   ├── sib-registry.yaml
│   ├── sib-bindings.yaml
│   └── tooling-manifest.yaml
├── docs/
│   ├── ALGO-001-PAIV.md
│   ├── OPLIB-001.md
│   ├── TEST-001.md
│   └── TRACE-001.md
├── schemas/
│   ├── trace-schema.json
│   └── checkpoint-schema.json
├── src/paiv/
│   ├── __init__.py
│   ├── types.py
│   ├── canonical.py
│   ├── ir.py
│   ├── executor_a.py
│   ├── executor_b.py
│   ├── primitives.py
│   ├── representations.py
│   ├── characterize.py
│   ├── architecture_lattice.py
│   ├── generator.py
│   ├── mutation.py
│   ├── composition.py
│   ├── version_space.py
│   ├── archive.py
│   ├── query.py
│   ├── solver.py
│   ├── neural.py
│   ├── verification.py
│   ├── checkpoint.py
│   └── cli.py
├── tests/
│   ├── unit/
│   ├── property/
│   ├── integration/
│   ├── golden/
│   └── benchmark_runner.py
├── traces/
├── checkpoints/
└── experiments/
    ├── e0_known_architecture/
    ├── e1_finite_family/
    ├── e2_generic_seeded/
    ├── e3_unseeded_one_mutation/
    └── manifests/
```

---

# Appendix E — Implementation Workstreams and Acceptance Gates

## Workstream 1 — Exact foundation

Deliver:

- typed IR;
- canonical serialization;
- exact interpreter A;
- independent interpreter B;
- primitive tests;
- SHA96 input contract.

Gate:

- zero disagreements across mandatory vectors and 100,000 generated primitive property tests.

## Workstream 2 — Version-space engine

Deliver:

- candidate masks;
- semantic deduplication;
- exact elimination;
- ambiguity reports;
- deterministic replay.

Gate:

- reproduce E1 and E2 traces under clean-room execution.

## Workstream 3 — Unseeded generation

Deliver:

- mutation grammar;
- architecture crossover;
- one-step target generation;
- provenance audit.

Gate M3:

- exact target absent initially and generated during search; 100% final accuracy.

## Workstream 4 — Multi-step synthesis

Deliver:

- hierarchical modules;
- constraint propagation;
- solver portfolio;
- quality-diversity archive.

Gate M4:

- target requires multiple generated edits; exact recovery under fixed budget.

## Workstream 5 — Neural guidance

Deliver:

- task generator;
- architecture encoder;
- proposal ranker;
- resource scheduler;
- deterministic baseline.

Gate:

- statistically significant solve-rate or time improvement without increased false acceptance.

## Workstream 6 — Cross-family generality

Deliver:

- ARX, Feistel, sponge, SPN, GF(2), and composition benchmarks;
- out-of-family and model-mismatch tests.

Gate:

- exact recovery on held-out generated families and honest model-mismatch reporting.

## Workstream 7 — Full SHA challenge

Gate M6:

- exact SHA candidate absent from initial population and module library;
- only declared generic primitives available;
- learner not told target name;
- one-bit observations under the declared query budget;
- generated canonical program;
- independent equivalence or exhaustive structured proof;
- 100% untouched test accuracy.

---

# Appendix F — Risk Register

| Risk | Severity | Detection | Mitigation |
|---|---|---|---|
| correct target hidden in initial population | Critical | provenance audit | mandatory target-seeding disclosure |
| dataset leakage | Critical | partition digest and duplicate scan | sealed splits |
| version-space explosion | Critical | active count/memory metrics | semantic classes, MITM, solvers, hierarchy |
| one-bit feedback too weak | Critical | scaling ladder failure | active queries, architecture priors, curriculum |
| neural overfitting | High | validation/test divergence | neural ranking only |
| shared executor defect | Critical | independent interpreter | replay and differential tests |
| target outside DSL | High | persistent no-candidate and diagnostics | controlled DSL expansion |
| module retrieval contamination | Critical | benchmark identity audit | blind retrieval keys |
| premature pruning | High | correct-candidate survival tests | complete mode, suspension/reopening |
| unsupported security claims | Critical | claim review | distinguish reproduction from cryptanalysis |
| irreproducible parallel results | High | replay mismatch | deterministic coordinator |
| fabricated or incomplete evidence | Critical | artifact/run hashes | immutable logs and provenance |

---

# Appendix G — Claims and Nonclaims

## Permitted claims at v0.1.0

- Exact SHA output can be reproduced when the exact architecture is supplied.
- A finite candidate architecture family containing SHA can be narrowed to the exact configuration using one-bit observations.
- A broad generic round-machine population containing an inserted exact SHA configuration can be narrowed to that configuration.
- The core version-space elimination mechanism is real and reproducible under the recorded environment.

## Prohibited claims at v0.1.0

- PAIV has generated SHA-256 from generic primitives when SHA was absent.
- PAIV can reliably recover arbitrary cryptographic functions from one-bit observations.
- The current prototypes prove scalability.
- A result greater than 50% constitutes SHA reproduction.
- A generated cryptographic design is secure because it passes statistical tests.

---

# Appendix H — References

1. EquationCode repository, `EQC.md`, EQC v1.1: https://github.com/olejardamir/EquationCode/blob/main/EQC.md
2. EquationCode repository, `ECOSYSTEM.md`, EQC-ES v1.9.1: https://github.com/olejardamir/EquationCode/blob/main/ECOSYSTEM.md
3. EquationCode repository, `BRIDGE.md`, EQC-SIB v1.2.1: https://github.com/olejardamir/EquationCode/blob/main/BRIDGE.md
4. National Institute of Standards and Technology, FIPS 180-4, Secure Hash Standard: https://doi.org/10.6028/NIST.FIPS.180-4
5. Local experimental artifacts and run logs identified by the SHA-256 digests in Block VII.C.

---

# End of Specification

**Spec Version: v0.1.0**
