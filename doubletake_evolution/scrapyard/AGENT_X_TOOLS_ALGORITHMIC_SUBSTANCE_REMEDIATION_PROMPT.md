# Agent_X `/tools/` Algorithmic Substance Remediation Prompt

## Mission

Perform a complete, recursive remediation of:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

The purpose is to eliminate the current failure mode where harvested, balanced, frontier-discovered, gap-filled, assimilated, or otherwise generated knowledge is being turned into **placeholder buckets, generic record handlers, trivial wrappers, metadata-only modules, or fake "implemented" capabilities** instead of true executable algorithms and meaningful Agent_X behavior.

This is an implementation task, not a documentation exercise.

Do not merely rename files, reorganize placeholders, add comments, add more schemas, wrap existing stubs, or make the current generated code look cleaner. Fix the underlying behavior.

The final state must ensure:

> Harvested knowledge is treated as evidence about a mechanism or capability. It becomes runtime code only when a real algorithm or meaningful behavioral mechanism has been reconstructed, integrated, and behaviorally verified.

---

# 1. Hard Scope

Primary write scope:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

Recursively inspect **the entire `tools/` tree**, including but not limited to:

- `tools/agentx/`
- `tools/agentx_evolve/`
- `tools/agentx_initiator/`
- harvesting/mining code
- balancer code
- gap-filler code
- frontier-discovery code
- assimilation code
- generated capability folders
- manifests
- registries
- adapters
- dispatchers
- acceptance systems
- tests
- proofs
- generated source files
- generated test files
- UI-to-runtime harvesting paths
- any code that transforms harvested knowledge into Python or other executable artifacts

You may inspect the rest of the Agent_X repository read-only when required to understand imports, interfaces, callers, runtime expectations, or compatibility constraints.

Do not perform unrelated architectural work outside `tools/`.

If something outside `tools/` depends on a bad generated implementation, preserve compatibility from inside `tools/` where practical. Do not use compatibility as an excuse to retain fake implementations.

---

# 2. Known Failure Pattern

A concrete example already exists in:

`tools/agentx_evolve/collective_adaptation/`

Generated files claim to implement algorithms such as:

- adaptive mutation gates
- normalized-rank threshold adaptation
- elite preservation
- hybrid embedding + keyword ranking
- generational garbage collection
- trust calibration
- transition gating
- differential-privacy gates

but some generated modules instead contain patterns such as:

```python
DOMAIN_FIELDS = ()
REQUIRED_FIELDS = ()
THRESHOLDS = ()
```

with generic functions such as:

```python
def analyze_record(record):
    ...
```

or:

```python
return {"kind": "...", "processed": True}
```

or trivial records such as:

```python
@dataclass
class Something:
    value: Any = None
    valid: bool = True

    def is_valid(self):
        return bool(self.valid)
```

This is **not** an implementation of the algorithm described by the harvested knowledge.

Likewise, tests such as:

```python
assert module._main([]) == 0
assert module.handle_something("x") is not None
```

prove importability, not algorithmic behavior.

The same problem may exist elsewhere under `tools/`. Find it recursively. Do not assume it is limited to `collective_adaptation`.

---

# 3. Definition of a Real Implementation

A harvested capability may be considered implemented only when it has meaningful executable behavior.

Examples of acceptable algorithmic substance include:

- ranking
- normalization
- scoring
- optimization
- search
- selection
- scheduling
- mutation
- threshold adaptation
- feedback control
- state transition
- inference
- graph traversal
- retrieval fusion
- clustering
- filtering
- pruning
- resource allocation
- uncertainty estimation
- calibration
- caching policy
- learning/update rules
- convergence detection
- novelty detection
- policy evaluation
- memory management
- planning
- dependency resolution
- constraint satisfaction
- validation that contains domain-specific semantics
- deterministic decision logic that materially changes system behavior

A real implementation normally has some combination of:

- meaningful inputs
- meaningful outputs
- actual computation
- state or feedback where the mechanism requires it
- domain invariants
- explicit assumptions
- failure handling
- boundary handling
- deterministic behavior where required
- meaningful integration points
- behavioral tests
- before/after or differential evidence

The following do **not** count as algorithmic substance by themselves:

- `dispatch()`
- `handle_*()`
- `analyze_record()`
- `has_required_fields()`
- generic schemas
- dataclasses that only hold `value` and `valid`
- aliases
- registries
- manifests
- import wiring
- `processed=True`
- `status="accepted"`
- `status="implemented"`
- placeholder thresholds
- empty field tuples
- generic validation
- simple serialization
- CLI wrappers
- module import success
- `py_compile`
- type hints
- docstrings describing an algorithm that the code does not execute
- tests that only assert non-`None`
- tests that only assert a file imports
- tests that only assert an object can be instantiated

These may exist as supporting plumbing, but they may never be used as proof that a harvested capability has been implemented.

---

# 4. Critical Principle: Evidence Is Not Runtime Code

Replace this conceptual model wherever it exists:

```text
harvest item
    ->
generated Python file
    ->
generic handler
    ->
registered tool
    ->
"implemented"
```

with:

```text
harvest item
    ->
evidence/provenance
    ->
mechanism extraction
    ->
deduplication with existing capabilities
    ->
algorithmic specification
    ->
real implementation or extension of existing implementation
    ->
behavioral verification
    ->
runtime registration
```

A harvest ID is an evidence/provenance identifier.

It is **not automatically a module name, class name, tool name, handler name, or runtime capability**.

Do not maintain a one-harvest-item-to-one-Python-file architecture unless a specific harvested item genuinely represents a unique, independently useful executable capability.

---

# 5. Phase A — Recursive Inventory and Classification

Before deleting or rewriting generated code, recursively inventory `tools/`.

Classify relevant files/modules into these categories:

### A. REAL_CORE

Contains genuine runtime behavior or algorithms and should normally be preserved.

Examples may include actual schedulers, adaptation engines, stores, parsers, evaluators, planners, orchestration logic, state machines, ranking algorithms, search mechanisms, or proof systems.

### B. NECESSARY_PLUMBING

Adapters, manifests, serializers, wrappers, registries, CLI code, integration code, and other infrastructure that is legitimate but should not be misclassified as an algorithm.

### C. PLACEHOLDER_GENERATED

Files whose claimed capability is not actually implemented.

Typical signals:

- empty `DOMAIN_FIELDS`
- empty `REQUIRED_FIELDS`
- empty `THRESHOLDS`
- `processed=True`
- generic `dispatch`
- generic `handle_*`
- generic record validation
- source-description-only behavior
- trivial dataclass
- generic pass-through
- hardcoded success
- placeholder scores
- no algorithm matching the module description
- module docstring contains nearly all of the "intelligence"
- generated test only confirms importability

### D. MIXED_CONTAMINATED

A file contains real code plus appended/generated placeholder code.

This is especially important for giant "bucket sink" files where many harvest IDs have been appended into one module.

Salvage the real implementation. Extract provenance. Remove the generated contamination.

### E. DUPLICATED_CAPABILITY

Multiple files implement, claim to implement, or partially represent the same underlying mechanism.

Examples:

- many adaptive mutation gates
- many hybrid rankers
- many elite-preservation filters
- many threshold gates
- many GC/pruning mechanisms

These should normally converge into one canonical capability or a small family of genuinely different strategies.

### F. CONCEPT_ONLY

The harvested evidence describes a potentially useful idea but does not contain enough information to reconstruct a trustworthy algorithm.

Preserve the provenance and concept.

Do **not** fabricate an implementation.

Do **not** register it as an executable capability.

### G. UNRELATED_VALID_TOOLING

Normal tools that are not part of the harvesting/assimilation problem and do not need changes.

Do not refactor valid code merely because it is in `tools/`.

---

# 6. Produce a Machine-Readable Audit Before Destructive Cleanup

Create a compact machine-readable audit/provenance artifact under `tools/` or an existing appropriate Agent_X evolution metadata location.

Do not create hundreds of new audit files.

Use one consolidated artifact where practical.

For every suspicious generated capability, preserve at minimum:

```json
{
  "source_id": "...",
  "old_path": "...",
  "source_description": "...",
  "manifest_description": "...",
  "claimed_mechanism": "...",
  "classification": "PLACEHOLDER_GENERATED | MIXED_CONTAMINATED | DUPLICATED_CAPABILITY | CONCEPT_ONLY | ...",
  "canonical_capability": "... or null",
  "migration_status": "...",
  "provenance": [...]
}
```

Preserve useful source descriptions before deleting placeholder modules.

The objective is:

> Delete fake implementation code without deleting the knowledge that caused it to be generated.

---

# 7. Detect Semantic Corruption Between Source, Module, Manifest, and Handler

Audit for mismatches where:

- the filename refers to harvest item A
- `SOURCE_CAP` refers to A
- the docstring describes B
- the manifest describes C
- the exposed handlers belong to D
- appended bucket code belongs to E
- tests only verify that everything imports

Treat these as correctness defects.

For every runtime-registered capability, require consistent identity between:

- canonical capability name
- implementation
- manifest
- registry
- documentation
- tests
- provenance

Harvest source IDs may be many-to-one.

Canonical runtime identity must be coherent.

---

# 8. Consolidate Harvest IDs Into Canonical Algorithms

Do not keep code organized primarily by generated harvest IDs.

Where multiple harvested records describe the same mechanism, converge them into canonical implementations.

Example:

```text
harvest_A ----\
harvest_B -----\
harvest_C ------> AdaptiveMutationGate
harvest_D -----/
harvest_E ----/
```

not:

```text
harvest_A -> file_A.py
harvest_B -> file_B.py
harvest_C -> file_C.py
harvest_D -> file_D.py
harvest_E -> file_E.py
```

A suitable design may use domain-level canonical modules such as:

```text
algorithms/
    adaptive_mutation.py
    elite_preservation.py
    hybrid_ranking.py
    lineage_gc.py
    transition_gating.py
    calibration.py
```

but do not mechanically create this exact structure if an existing good architecture already provides a better canonical home.

Prefer extending real existing implementations over creating parallel implementations.

---

# 9. Algorithm Reconstruction Rules

For each PLACEHOLDER_GENERATED or DUPLICATED_CAPABILITY item:

## Step 1 — Extract the claimed mechanism

Identify:

- objective
- inputs
- outputs
- state
- update rule
- ranking/scoring rule
- equations if available
- threshold behavior
- optimization target
- constraints
- invariants
- failure cases
- feedback loop
- expected integration point
- claimed benefit
- source evidence

## Step 2 — Search existing `tools/` code

Before adding code, determine whether Agent_X already has:

- the same algorithm
- an equivalent algorithm
- a stronger implementation
- a reusable primitive
- a partially implemented version
- an appropriate canonical subsystem

If so, extend/fuse there.

Do not create another implementation solely to preserve the harvest ID.

## Step 3 — Decide IMPLEMENTABLE vs CONCEPT_ONLY

If the evidence is sufficient to specify meaningful behavior, implement it.

If the evidence is too vague, mark it `CONCEPT_ONLY`.

Never invent a sophisticated algorithm merely because the source description contains words such as:

- adaptive
- intelligent
- neuro-symbolic
- superior
- emergent
- optimized
- self-learning
- conscience
- frontier
- evolved

Names are not specifications.

## Step 4 — Implement the actual mechanism

Example: if the concept is "adaptive mutation gate using normalized rank", the code must actually perform operations such as:

```text
candidate population
    ->
fitness/rank calculation
    ->
rank normalization
    ->
threshold calculation
    ->
candidate admission/rejection
    ->
generation outcome observation
    ->
threshold update
    ->
next generation
```

with real data and real state if required.

A handler returning `"processed": true` is not acceptable.

## Step 5 — Integrate it where it changes behavior

The algorithm must have a real consumer or clearly defined callable capability.

Do not register dead code merely to satisfy an implementation count.

---

# 10. Behavioral Delta Requirement

For every canonical harvested algorithm admitted to runtime, prove a meaningful behavioral delta.

At least one test must show:

```text
same meaningful scenario
    +
baseline behavior
    versus
new capability enabled
    =
materially different intended result
```

Examples:

- different candidate selection
- better ranking
- fewer wasted mutations
- different threshold after feedback
- stale lineage pruned
- elite variant preserved
- unsafe/low-value item rejected
- retrieval ordering changes
- allocation changes
- scheduler ordering changes
- state converges
- repeated failure reuses learned response

If removing the implementation would produce the same meaningful behavior, it is not actually integrated.

---

# 11. Replace Import-Only Tests With Algorithm Tests

Generated micro-tests that only verify:

```python
assert import_succeeds
assert object.is_valid()
assert _main([]) == 0
assert handle_x("x") is not None
```

must not be treated as implementation evidence.

Remove or replace them when their associated placeholder modules are removed.

Canonical algorithm tests should verify things such as:

- known input -> expected output
- monotonicity where appropriate
- deterministic tie-breaking
- threshold bounds
- state updates
- feedback adaptation
- ranking order
- invariant preservation
- invalid input rejection
- edge cases
- empty population behavior
- duplicated score behavior
- numerical stability
- persistence if required
- idempotency if required
- behavioral delta
- regression against baseline
- integration behavior

Do not generate one trivial test file per harvest ID.

Prefer tests organized around canonical capabilities.

---

# 12. Numeric and Performance Claims Must Be Proven or Removed

Do not preserve statements such as:

- "cuts ~30% wasted evolutions"
- "improves hit-rate by >=15%"
- "beats keyword-only retrieval"
- "reduces cost by X%"
- "improves accuracy by Y%"

as implementation facts unless the repository contains a reproducible benchmark demonstrating the claim.

For every numeric claim:

1. create or identify a deterministic benchmark,
2. calculate the metric correctly,
3. test the stated threshold,
4. retain the claim only if it passes.

Otherwise change the provenance record to indicate that the metric is a **source claim / unverified claim**, not a proven Agent_X property.

Do not silently fabricate benchmark results.

---

# 13. Runtime Registration Rules

A capability may be placed in:

- `mcp_tools.manifest.json`
- a tool registry
- `__init__.py`
- dispatcher mappings
- runtime capability maps
- assimilation registries
- callable tool indexes

only when it has a real implementation.

Do not runtime-register `CONCEPT_ONLY` evidence.

Do not use a source harvest ID as the primary public capability name when a canonical algorithm name exists.

Prefer:

```text
adaptive_mutation
elite_preservation
hybrid_ranking
lineage_gc
```

over:

```text
evolution_Superior_ass_balancer_1320_d76d
neuro_symbolic_gap_10_41ee
...
```

Source IDs belong in provenance.

---

# 14. Compatibility Rules

Before removing old generated modules:

1. search the repository for imports/references,
2. identify real callers,
3. migrate callers within `tools/`,
4. preserve compatibility only where actually required.

If an external caller still requires an old import path and changing it is outside scope, a temporary compatibility shim inside `tools/` is acceptable only if it:

- forwards to a canonical real implementation,
- contains no fake algorithm,
- is clearly marked as compatibility,
- is tested,
- is not counted as a separate capability,
- does not appear as a separate runtime tool unless truly required.

Do not keep thousands of obsolete modules "just in case."

---

# 15. Giant Bucket-Sink Files Must Be Decomposed

Find files that have accumulated many blocks such as:

```text
# --- integrated from bucket:... ---
```

or repeated imports/classes/handlers appended over time.

For each such file:

1. identify any genuine original implementation,
2. preserve it,
3. extract all harvest provenance,
4. map duplicated concepts to canonical algorithms,
5. remove appended placeholder blocks,
6. split real algorithms only when cohesion requires it,
7. reduce the file to a coherent responsibility.

File size alone is not the criterion.

The criterion is whether unrelated harvest records have been appended into one accidental bucket.

---

# 16. Preserve Real Agent_X / Borg Runtime Behavior

Do not destroy working runtime systems while cleaning harvested code.

Real code may already exist for:

- adaptation
- orchestration
- governance
- persistence
- acceptance
- execution
- scheduling
- retrieval
- memory
- evaluation
- distributed state
- defensive learning
- tool integration

Inspect behavior before editing.

For example, if a core module already performs a real adaptation loop, preserve that behavior and remove only the generated placeholder contamination around it.

Do not replace functioning algorithms with newly generated abstractions.

---

# 17. Fail-Closed Defaults for Claimed Verification

Audit defaults that silently convert missing verification into success.

Bad example:

```python
self._test_fn = test_fn or (lambda candidate: True)
```

when the surrounding contract claims that untested candidates cannot deploy.

Where the semantics require actual verification, missing verification must not silently become success.

Use the correct domain-specific fail-closed behavior.

Do not blindly change all defaults; reason about each subsystem.

---

# 18. Add an Automated Anti-Placeholder Gate

Add or extend acceptance tooling under `tools/` so this failure mode cannot immediately return.

The gate must inspect runtime-registered harvested/generated capabilities and reject suspicious patterns.

At minimum, detect and fail cases where a claimed algorithm consists only of combinations of:

- empty `REQUIRED_FIELDS`
- empty `THRESHOLDS`
- empty domain specification
- trivial `valid=True`
- `processed=True`
- generic `dispatch`
- generic `handle_*`
- generic schema projection
- import-only test
- non-`None` test
- docstring-only algorithm description
- hardcoded success
- manifest entry with no behavioral implementation
- harvest-ID module registered as a tool with no canonical algorithm
- metric claim with no benchmark
- source/manifest/handler identity mismatch

Do not make the gate a naive text grep that rejects legitimate code accidentally.

Use AST inspection, registry inspection, semantic structural checks, and/or targeted allowlisting where appropriate.

The gate itself must have positive and negative tests.

---

# 19. Harvesting Pipeline Prevention Fix

Finding and deleting existing placeholders is not sufficient.

Locate the code under `tools/` that **generates** these modules.

Fix the generation/assimilation path so future harvesting behaves correctly.

The future pipeline must:

1. ingest harvested evidence,
2. extract the mechanism,
3. search existing capabilities,
4. deduplicate,
5. choose:
   - extend existing capability,
   - implement new canonical capability,
   - store as `CONCEPT_ONLY`,
6. require behavioral tests,
7. require algorithmic-substance acceptance,
8. register only after acceptance,
9. preserve provenance many-to-one.

It must **not** default to generating:

```python
class HarvestId:
    value = ...
```

plus:

```python
def handle_x(...):
    return {"processed": True}
```

plus:

```python
def dispatch(...):
    ...
```

and then call the result implemented.

The generator prompt/templates must explicitly forbid this.

---

# 20. Balancer, Gap Filler, Frontier Discovery, and Harvesting

Audit these systems specifically because they are high-risk producers of generated capability records.

Their outputs must be treated as:

> information/evidence for assimilation

not automatically as:

> source code to paste or generate one-to-one.

Balancer/gap/frontier outputs may contribute to:

- strengthening an existing algorithm,
- changing parameters backed by evidence,
- suggesting a new strategy,
- identifying missing behavior,
- producing a new canonical capability,
- producing `CONCEPT_ONLY` evidence.

They must not force code creation when no meaningful algorithm can be recovered.

---

# 21. Deduplication Must Be Semantic, Not Filename-Based

Two harvested items may be duplicates even when:

- the IDs differ,
- the domains differ,
- the prompts differ,
- the descriptions use different words,
- one came from balancer and another from frontier discovery.

Compare:

- objective
- inputs
- outputs
- state
- update rule
- decision rule
- algorithm family
- expected integration point

If the core mechanism is the same, merge provenance into a canonical implementation.

Do not create "AdaptiveMutationGateForX", "AdaptiveMutationGateForY", etc. unless their behavior genuinely differs.

---

# 22. Do Not Over-Consolidate Distinct Algorithms

The opposite error is also forbidden.

Do not merge algorithms merely because they share words such as:

- rank
- threshold
- adaptive
- filter
- retrieval
- mutation

If two mechanisms have materially different:

- objectives
- state
- equations
- guarantees
- constraints
- consumers
- failure behavior

keep them distinct.

Consolidate by semantic equivalence, not by superficial naming.

---

# 23. Clean Manifests and Registries

For every manifest/registry in `tools/`:

- remove entries for deleted fake capabilities,
- point surviving entries to canonical real implementations,
- make module paths correct,
- make descriptions match actual behavior,
- make parameters match actual callable interfaces,
- preserve provenance separately,
- eliminate duplicate registration,
- eliminate stale imports,
- eliminate source/handler mismatches,
- recalculate digests if the format requires them.

A manifest must describe what the runtime actually does.

---

# 24. Clean `__init__.py` Files

Remove long lists of imports whose only purpose is to expose generated harvest-ID modules.

Package exports should emphasize stable canonical APIs.

Do not force every harvested source into package-level imports.

Provenance records do not need to be imported.

---

# 25. No Fake Completion

Do not declare the task complete because:

- files compile,
- tests pass if tests are trivial,
- manifests load,
- dispatch works,
- imports succeed,
- lint passes,
- placeholders were renamed,
- placeholder files were moved,
- source IDs were consolidated into another giant bucket,
- algorithm names now sound better.

Completion requires actual algorithmic and behavioral substance.

---

# 26. Verification Strategy

Run the strongest existing test suite relevant to `tools/`.

Also perform targeted verification for this remediation.

At minimum verify:

## Structural

- no broken imports in `tools/`
- no stale manifest entries
- no deleted module still registered
- no accidental duplicate canonical capability
- no unexpected import cycles introduced
- no giant generated bucket sink remains without justification

## Placeholder regression

Search/scan for suspicious generated patterns.

Every remaining occurrence must be either:

- legitimate plumbing,
- compatibility code,
- test fixture,
- explicitly documented exception,

and must not be misrepresented as an algorithm.

## Behavioral

Each new/reconstructed canonical algorithm has meaningful tests.

## Provenance

Every migrated harvest item remains traceable to its canonical capability or `CONCEPT_ONLY` status.

## Metrics

No unverified numeric improvement claim is represented as a proven Agent_X result.

## Runtime

Canonical implementations are callable through the intended Agent_X paths where appropriate.

---

# 27. Required Remediation Report

At the end, create one concise report under `tools/` describing:

- number of files inspected
- number classified REAL_CORE
- number classified NECESSARY_PLUMBING
- number classified PLACEHOLDER_GENERATED
- number classified MIXED_CONTAMINATED
- number classified DUPLICATED_CAPABILITY
- number classified CONCEPT_ONLY
- number removed
- number consolidated
- canonical algorithms created
- canonical algorithms extended
- compatibility shims retained
- manifests/registries repaired
- generator paths repaired
- tests added/replaced
- anti-placeholder gate added
- unresolved concepts left as `CONCEPT_ONLY`
- verification commands executed
- failures, if any

Do not write a long self-congratulatory document.

Make it a factual engineering audit.

---

# 28. Required Acceptance Criteria

This task is accepted only when all of the following are true:

- [ ] The complete `tools/` directory was recursively inspected.
- [ ] Existing real runtime behavior was preserved.
- [ ] Placeholder-generated capabilities were identified.
- [ ] Mixed real/placeholder files were separated correctly.
- [ ] Useful harvested descriptions/provenance were preserved before deletion.
- [ ] Harvest IDs are no longer automatically treated as runtime capability identities.
- [ ] Duplicate mechanisms were consolidated semantically.
- [ ] Real algorithms were reconstructed where evidence was sufficient.
- [ ] Vague evidence was retained as `CONCEPT_ONLY`, not fabricated into code.
- [ ] Runtime registration contains only real executable capabilities or legitimate plumbing.
- [ ] Manifests match implementations.
- [ ] `__init__.py` files no longer expose generated clutter unnecessarily.
- [ ] Giant bucket-sink files were remediated.
- [ ] Import-only/non-`None` generated tests were removed or replaced.
- [ ] Canonical algorithms have meaningful behavioral tests.
- [ ] Every admitted harvested capability demonstrates behavioral substance.
- [ ] Numeric performance claims are benchmark-backed or clearly marked unverified source claims.
- [ ] The code-generation/assimilation pipeline was fixed so the defect does not regenerate.
- [ ] An automated anti-placeholder acceptance gate exists and is tested.
- [ ] Relevant existing Agent_X tests pass.
- [ ] New remediation tests pass.
- [ ] No new fake "implemented" capability was created during the repair.

---

# 29. Execution Method

Do not stop after the first cleanup pass.

Perform the work iteratively:

```text
INVENTORY
    ->
CLASSIFY
    ->
PRESERVE PROVENANCE
    ->
DETECT DUPLICATES
    ->
RECONSTRUCT / CONSOLIDATE
    ->
REWIRE
    ->
REMOVE PLACEHOLDERS
    ->
REPAIR GENERATOR
    ->
TEST
    ->
AUDIT AGAIN
```

After the first full pass, recursively scan `tools/` again.

If the second scan still finds:

- placeholder capabilities,
- fake algorithms,
- harvest-ID clutter,
- stale registrations,
- trivial generated tests,
- semantic mismatches,
- unverified claims,
- duplicated mechanisms,
- bucket-sink files,

continue correcting them.

Repeat audit -> repair -> test until the acceptance criteria are actually satisfied.

Do not loop by rewriting working code endlessly.

Stop when further passes find no substantive defect in this problem class.

---

# 30. Decision Rule for Every Suspicious Generated File

For each suspicious file, answer internally:

```text
Does this file execute the mechanism it claims to implement?
```

If **yes**:

- preserve or improve it,
- canonicalize if duplicated,
- ensure behavioral tests exist.

If **partially**:

- salvage the real part,
- reconstruct the missing mechanism if evidence allows,
- remove placeholder contamination.

If **no, but evidence is sufficient**:

- reconstruct a real canonical algorithm,
- migrate provenance,
- rewire callers,
- delete the fake implementation.

If **no, and evidence is insufficient**:

- preserve the idea as `CONCEPT_ONLY`,
- unregister it,
- delete the fake runtime implementation.

This rule is mandatory.

---

# 31. Core Architectural Outcome

The target architecture is:

```text
HARVESTING / BALANCER / GAP / FRONTIER
                    |
                    v
             EVIDENCE RECORDS
                    |
                    v
           MECHANISM EXTRACTION
                    |
                    v
          EXISTING-CAPABILITY SEARCH
                    |
          +---------+---------+
          |                   |
          v                   v
     MATCH EXISTS         NO MATCH
          |                   |
          v                   v
   EXTEND / FUSE       SPEC SUFFICIENT?
                              |
                      +-------+-------+
                      |               |
                     YES              NO
                      |               |
                      v               v
              REAL ALGORITHM     CONCEPT_ONLY
                      |
                      v
               BEHAVIORAL TEST
                      |
                      v
              ACCEPTANCE GATE
                      |
                      v
              RUNTIME REGISTRY
```

The architecture must **not** be:

```text
harvest record
    ->
template Python
    ->
handler
    ->
dispatch
    ->
manifest
    ->
done
```

---

# Final Instruction

Execute this remediation directly against:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

Treat the current placeholder-generation behavior as a systemic defect.

Preserve useful knowledge.

Preserve real algorithms.

Remove fake implementations.

Consolidate duplicated mechanisms.

Reconstruct genuine algorithms only when the evidence supports them.

Fix the generator so the same defect cannot return.

Prove behavior with meaningful tests.

Do not claim completion until the entire `tools/` tree passes the algorithmic-substance standard above.
