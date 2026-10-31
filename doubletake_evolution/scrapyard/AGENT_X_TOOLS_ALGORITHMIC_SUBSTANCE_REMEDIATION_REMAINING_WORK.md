# Agent_X `/tools/` Algorithmic Substance Remediation — Remaining Work Only

## Purpose

Continue the algorithmic-substance remediation of:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

This prompt intentionally **removes work that has already been completed**.

Do not repeat the previous mass cleanup. Preserve the completed remediation and focus only on the remaining defects in the future harvesting → coding → assimilation → promotion pipeline.

---

# 1. Already Completed — Do Not Redo

Treat the following as the new baseline unless direct code inspection proves a regression:

- 159 legacy harvest-template placeholder modules were removed.
- 180 import-only / non-behavioral paired tests were removed.
- Harvest provenance was preserved in `harvest_remediation_audit.json`.
- 42 underspecified records were retained as `CONCEPT_ONLY` instead of fabricated into algorithms.
- Duplicate harvest records were consolidated into canonical capabilities.
- Seven real canonical harvested algorithm families were created under `harvested_algorithms/`:
  - adaptive mutation
  - elite preservation
  - hybrid ranking
  - semantic deduplication
  - ranked selection
  - lineage GC
  - ingest gate
- Those canonical algorithms now contain genuine executable behavior and behavioral tests.
- Stale manifests and generated `__init__.py` import clutter were cleaned.
- The synthesized manifest was reduced to the surviving real shim and resealed.
- The duplicate `superior_intelligence_ensemble` shim was retired.
- Unverified numeric source claims were removed from live implementation descriptions and retained only as unverified provenance.
- Existing giant legacy bucket-sink files from the first remediation were cleaned.
- The bucket/integrator prompts were rewritten to state:
  - mechanism extraction first,
  - existing-capability search,
  - `ALREADY_EXISTS`,
  - `CONCEPT_ONLY`,
  - behavioral-delta testing,
  - no default one-harvest-ID → one-module policy.
- An AST-based `algorithmic_substance_gate` was added.
- Legacy placeholder-shaped candidates are now blocked by several integration boundaries.
- Collision-suffix promotion is already blocked by `promote_candidate`.
- Canonical promotion already preserves rollback, owner placement, provenance, manifest rollback, and duplicate-content invariants.

Do not delete or rewrite these completed canonical algorithms just to satisfy this prompt.

Do not recreate the old mass audit.

Do not re-consolidate already consolidated harvest records unless a new concrete defect is found.

---

# 2. Remaining Critical Defect

The old placeholder files are gone, but the **future generation pipeline still has a second form of fake implementation**.

The deterministic author in:

`tools/agentx_evolve/collective_core/write_code_e2e.py`

still emits a Python **assimilation packet** containing structures such as:

```python
SOURCE_CAP = ...
ATOMIC_CAPABILITIES = ...
DECISIONS = {...: "PENDING RECONNAISSANCE"}
```

plus a trivial holder:

```python
@dataclass
class Something:
    value: Any = None
    valid: bool = True

    def is_valid(self):
        return bool(self.valid)
```

plus:

```python
def process(value=None, **kwargs):
    return {
        "status": "ok",
        "decision": "PENDING RECONNAISSANCE",
        ...
    }
```

and mining-hint functions that simply delegate to `process()`.

Its generated test verifies packet metadata such as:

```python
assert m.SOURCE_CAP == ...
assert m._main([]) == 0
assert m.process("x")["decision"] == "PENDING RECONNAISSANCE"
```

This is better documentation than the old `processed=True` template, but it is still **not an implementation of the harvested algorithm**.

A `PENDING RECONNAISSANCE` packet is evidence/specification state.

It must not masquerade as executable capability code.

---

# 3. Required Architectural Correction

The pipeline must support three distinct outcomes after analyzing harvested evidence:

```text
HARVESTED EVIDENCE
        |
        v
MECHANISM + REPOSITORY RECONNAISSANCE
        |
        +-------------------+--------------------+
        |                   |                    |
        v                   v                    v
ALREADY EXISTS        CONCEPT / DEFERRED   IMPLEMENTABLE
        |                   |                    |
        v                   v                    v
provenance only       provenance only      REAL ALGORITHM
no new .py            no new .py                 |
no tool               no tool                    v
                                       behavioral verification
                                                |
                                                v
                                         canonical promotion
```

The following outcomes must **not create Python implementation modules**:

- `PENDING RECONNAISSANCE`
- `CONCEPT_ONLY`
- `KNOWLEDGE ONLY`
- `DEFER`
- `REJECT`
- `NO_CHANGE_REQUIRED`
- `ALREADY EXISTS`

Those are decisions / evidence states.

Store them in the existing audit / candidate / assimilation metadata system, not in runtime modules.

Only `IMPLEMENT`, `ADAPT`, or `MERGE` may produce source changes, and only when an actual mechanism has been resolved.

---

# 4. Remove Assimilation Packets From the Code Path

Refactor `write_code_e2e.author_functional_module()`.

It must no longer return a fake executable packet for unresolved knowledge.

Replace the current return contract:

```python
(module_name, source_code)
```

with a typed authoring result such as:

```text
REAL_IMPLEMENTATION
ALREADY_EXISTS
CONCEPT_ONLY
DEFERRED
REJECTED
```

carrying:

- canonical capability name
- canonical owner
- provenance
- reconnaissance evidence
- decision
- rationale
- source code only when `REAL_IMPLEMENTATION`
- behavioral test only when `REAL_IMPLEMENTATION`

For non-code outcomes:

```text
source_code = None
test_code = None
runtime_registration = forbidden
```

Do not create a `.py` file simply to record the decision.

If changing the public return type is too invasive, introduce a compatible typed wrapper internally and migrate callers cleanly.

Do not keep packet generation as a fallback.

---

# 5. The Default Author Must Not Fabricate Code

Current behavior falls back to the deterministic built-in author when no true author is injected.

That built-in author currently produces the `PENDING RECONNAISSANCE` packet.

Change this.

If the system cannot reconstruct a real implementation from available evidence, the default outcome must be:

```text
CONCEPT_ONLY / DEFERRED / NEEDS_RECONNAISSANCE
```

with no Python module.

The absence of an LLM author or sufficient algorithm specification must **not** cause a pseudo-module to be generated.

Do not replace the packet with another deterministic generic algorithm template.

No evidence → no implementation.

---

# 6. Remove Legacy Shape Requirements From `_verify_candidate`

Current `collective_core/coding_loop.py::_verify_candidate()` still requires legacy artifact-shape details such as:

- `SOURCE_CAP`
- a class named from the module
- `is_valid()`
- `_main()`
- a uniform `dispatch` or `process`

These requirements continue steering generated code toward the old bucket-coder structure.

Refactor verification around actual substance instead.

A real candidate should be accepted based on:

- parse/compile success
- canonical identity/provenance available in metadata, not necessarily source constants
- real callable algorithmic API
- mechanism-specific meaningful inputs/outputs
- resolved canonical owner
- no unresolved `PENDING RECONNAISSANCE`
- no `CONCEPT_ONLY`
- no trivial delegation-only implementation
- behavioral test exists
- behavioral test executes successfully
- behavioral delta is demonstrated
- production reachability / canonical integration is valid

Do not require a ceremonial dataclass or `_main()` unless the canonical subsystem genuinely needs them.

Do not require `SOURCE_CAP` inside implementation source when provenance already exists outside the module.

---

# 7. Remove Record-Codec Assumptions From `_smoke_candidate`

Current smoke verification still assumes candidate modules expose generic mined-record structures such as:

- `REQUIRED_FIELDS`
- `DOMAIN_FIELDS`
- `THRESHOLDS`
- generic `verdict` / `status` dictionaries

That is the old record-handler architecture.

A scheduler, ranker, adaptive controller, graph algorithm, GC policy, retrieval fusion algorithm, planner, or calibration algorithm should not be forced into a generic record validator interface.

Refactor smoke verification so it does not impose a fake universal data model.

Use:

- candidate-declared callable interface,
- test metadata,
- canonical subsystem contract,
- behavioral test,
- mechanism-specific fixture.

Generic smoke may still check importability and callability, but it must not define what every algorithm is supposed to look like.

---

# 8. Generated Tests Must Become Real Behavioral Tests

Retire the current `author_test_module()` behavior for assimilation packets.

A generated test is unacceptable if it primarily proves:

```text
module imports
SOURCE_CAP matches
is_valid is True
_main returns 0
process returns status=ok
PENDING_RECONNAISSANCE is present
hint function returns non-None
```

Those assertions may exist as secondary checks when relevant, but they are not behavioral evidence.

For a real implementation, the test must prove the actual mechanism.

Examples:

### Adaptive controller

```text
same population
fixed threshold baseline
vs adaptive gate after feedback
=> threshold and/or admission behavior changes as specified
```

### Scheduler

```text
same work items
FIFO baseline
vs priority scheduler
=> intended ordering differs deterministically
```

### Retrieval fusion

```text
same query/documents
single-signal baseline
vs fusion
=> ranking changes according to the defined scoring rule
```

### Garbage collection

```text
same lineage state
GC disabled
vs GC enabled
=> stale entries removed while protected elites remain
```

The test must be mechanism-specific.

---

# 9. Promotion Must Execute the Behavioral Test

Current `promote_candidate()` compiles supplied `test_code` but does not execute it before promotion.

This is not sufficient.

Change promotion so a candidate cannot become live merely because:

- source compiles,
- test compiles,
- module imports,
- smoke call returns something.

Before committing canonical promotion:

1. write candidate + test into the rollback transaction,
2. execute the candidate's targeted behavioral test in a bounded isolated manner,
3. require success,
4. only then finalize source, manifest, registry, provenance, and candidate retirement.

If the test fails:

- rollback source,
- rollback test,
- rollback manifest,
- do not mark candidate promoted.

Do not require the entire repository suite for every single candidate.

Run the smallest trustworthy targeted behavioral proof plus relevant canonical subsystem tests.

---

# 10. Strengthen `algorithmic_substance_gate`

The current gate is still primarily an exact legacy-template detector.

It currently relies heavily on a combination such as:

```text
SOURCE_CAP
+
all mined field tuples empty
+
generic handlers / trivial record
```

This is too easy to evade accidentally or deliberately.

A fake implementation may pass simply by:

- giving one mined tuple a dummy value,
- omitting `SOURCE_CAP`,
- renaming `dispatch`,
- returning a slightly different dictionary,
- replacing `processed=True` with another metadata key,
- using `PENDING_RECONNAISSANCE`,
- delegating every public function to one metadata-returning function.

Strengthen the gate to detect **algorithmic non-substance**, especially generated assimilation packets.

At minimum reject live/promotion candidates that contain unresolved implementation states such as:

```text
PENDING RECONNAISSANCE
CONCEPT_ONLY
KNOWLEDGE ONLY
DEFER
```

when the candidate is being treated as executable implementation code.

Also detect combinations such as:

- trivial holder dataclass + metadata-only process
- all exported behavior functions delegate directly to one metadata function
- implementation contains no meaningful computation beyond metadata projection
- generated test contains only import/metadata/non-None assertions
- source describes gates/reconnaissance but executes no mechanism
- runtime manifest points to a specification packet rather than an algorithm

Do not make this a simplistic keyword-only rejection.

Use AST/structural analysis plus promotion metadata and test evidence.

---

# 11. Fix All Fail-Open Substance-Gate Fallbacks

There are multiple `_substance_gate_ok()` implementations.

Their current pattern is effectively:

```python
try:
    use canonical gate
except Exception:
    pass

if exact_legacy_pattern:
    reject

return True
```

That is not fail-closed.

If the canonical substance gate cannot import, crashes, or cannot assess a candidate, promotion/registration must be blocked.

Required behavior:

```text
gate unavailable -> BLOCKED
gate exception   -> BLOCKED
unparseable      -> BLOCKED
ambiguous verdict -> BLOCKED
```

Do not silently return success.

Apply this consistently to all relevant paths, including:

- `collective_core/coding_loop.py`
- `collective_core/assimilation_governance.py`
- `collective_core/write_code_e2e.py`
- any other registration/promotion helper found during the pass

Add explicit tests that simulate gate import failure and gate execution failure.

---

# 12. Packets / Concepts Must Never Enter MCP Manifests

Current `write_code_e2e.register_mcp_tool()` can register an authored module once `_substance_gate_ok()` accepts it.

Because the current gate accepts assimilation packets, unresolved packets can still be exposed as tools.

Fix the registration contract.

Manifest registration requires:

- implementation decision is final and executable,
- no unresolved reconnaissance state,
- canonical owner resolved,
- actual callable behavior exists,
- behavioral test executed and passed,
- substance gate passed,
- runtime entry corresponds to real capability behavior.

Never register:

- packet modules
- `PENDING RECONNAISSANCE`
- `CONCEPT_ONLY`
- `KNOWLEDGE ONLY`
- `DEFER`
- metadata-only process functions

Add manifest negative tests for each.

---

# 13. Eliminate Prompt / Code Contradictions

The current integrator prompt still contains legacy/conflicting instructions.

Fix at least these contradictions:

### Collision suffixes

Prompt text still says new modules may be deduped using `_2`, `_3`, etc.

Canonical promotion already forbids collision suffixes.

Make the prompt match the code:

> A name collision means search/merge/resolve ownership. It does not mean create `_2`, `_3`, `_4`.

### Fallback to `collective_synthesized`

The prompt still allows falling back to `collective_synthesized` when no mapped directory exists.

This can recreate a dumping ground.

Change to:

```text
canonical owner unresolved
    ->
DEFER / RECONNAISSANCE REQUIRED
    ->
no source promotion
```

Use `collective_synthesized` only for a capability that genuinely belongs there by architecture, not as a universal fallback.

---

# 14. Remove Filename-Based `_dedupe` From Capability Creation

`write_code_e2e._dedupe()` currently solves collisions by adding numeric suffixes.

This is incompatible with semantic consolidation.

For implementation candidates:

```text
same canonical name
    ->
compare mechanism and existing capability
    ->
MERGE / ADAPT / ALREADY_EXISTS / reject collision
```

not:

```text
thing.py
thing_2.py
thing_3.py
```

Numeric suffixing may remain only for temporary non-source artifacts where identity has no architectural meaning.

It must not determine live capability identity.

---

# 15. Resolve the Remaining `coding_loop` Failures In-Scope

The previous remediation report still records 34 failures in `test_coding_loop.py`, described as dormant-loop decay around:

- codec paths
- refresh paths
- stale-gate paths

This prompt now changes those exact areas.

Therefore, do not dismiss those failures merely as pre-existing.

Run the complete `collective_core/test_coding_loop.py` suite.

For every failure:

1. determine whether it touches the harvesting/coding/packet/stale/reuse/promotion path,
2. if yes, fix it as part of this remediation,
3. if truly unrelated, document the exact test and why it is unrelated.

The final remaining-work report must not simply state:

> pre-existing failure

for a test covering code modified by this remediation.

---

# 16. Retire Existing Staged Fake Artifacts

The earlier remediation report states that the old logic had populated ignored runtime staging with a large number of placeholder files.

Inspect local runtime state used by this pipeline, especially:

- `.agentx-init/coding_bucket/`
- `.agentx-init/assimilation/`
- corresponding bucket indexes
- integration ledgers
- write-code ledgers
- candidate indexes

Do not allow stale legacy placeholders or new packet-shaped pseudo-implementations to remain eligible for promotion.

Before deletion:

- preserve any provenance not already present in `harvest_remediation_audit.json`,
- distinguish source evidence from generated fake code.

Then:

- retire/delete stale generated `.py` and paired trivial tests,
- invalidate or migrate index entries,
- ensure future runs do not treat retired artifacts as already-completed real implementations.

Do not delete genuine canonical source code.

This is the only permitted ancillary cleanup outside `tools/`; keep it strictly limited to runtime state owned by this pipeline.

---

# 17. Add Adversarial Gate Tests

Extend the substance-gate test suite with near-placeholder variants that must fail.

At minimum test:

### Variant A — dummy non-empty fields

```python
SOURCE_CAP = "x"
DOMAIN_FIELDS = ("dummy",)
REQUIRED_FIELDS = ()
THRESHOLDS = ()
# generic metadata handlers only
```

### Variant B — no SOURCE_CAP

Generic metadata-only module without `SOURCE_CAP`.

### Variant C — renamed handler

Metadata-only behavior exposed through a non-standard function name.

### Variant D — packet-shaped fake

```python
ATOMIC_CAPABILITIES = ...
DECISIONS = {"cap-1": "PENDING RECONNAISSANCE"}

def process(...):
    return {"status": "ok", "decision": "PENDING RECONNAISSANCE"}
```

### Variant E — delegation-only public API

Every named capability function just returns `process(value)`.

### Variant F — trivial generated test

Test contains only:

```text
imports
non-None
status
identity
_main
PENDING RECONNAISSANCE
```

### Variant G — gate unavailable

Canonical substance-gate import raises.

Promotion must block.

### Variant H — gate crashes

Assessment raises unexpectedly.

Promotion must block.

### Variant I — unresolved concept manifest

Manifest registration of `CONCEPT_ONLY` or `PENDING RECONNAISSANCE`.

Must block.

---

# 18. Required End-State

The complete future path must become:

```text
HARVEST
   |
   v
EVIDENCE
   |
   v
RECONNAISSANCE
   |
   v
MECHANISM SPECIFICATION
   |
   +------------------------------+
   |                              |
   v                              v
INSUFFICIENT / DUPLICATE      IMPLEMENTABLE
   |                              |
   v                              v
metadata decision             real source
NO .py                        real behavioral test
NO manifest                       |
NO runtime tool                   v
                             test EXECUTION
                                  |
                                  v
                             substance gate
                                  |
                                  v
                           canonical promotion
                                  |
                                  v
                           runtime registration
```

There must be no path:

```text
evidence
   ->
PENDING RECONNAISSANCE packet.py
   ->
metadata-only test
   ->
compile/import
   ->
manifest
   ->
"implemented"
```

---

# 19. Acceptance Criteria — Remaining Work Only

This follow-up remediation is complete only when:

- [ ] `author_functional_module()` no longer emits unresolved assimilation packets as implementation modules.
- [ ] Non-code decisions are stored as metadata/provenance, not `.py`.
- [ ] The default author produces no implementation when evidence is insufficient.
- [ ] `_verify_candidate()` no longer requires legacy `SOURCE_CAP` / trivial dataclass / `_main` ceremony.
- [ ] `_smoke_candidate()` no longer imposes universal `DOMAIN_FIELDS` / `REQUIRED_FIELDS` / `THRESHOLDS` record semantics.
- [ ] Generated tests for real implementations are mechanism-specific.
- [ ] `promote_candidate()` executes the targeted behavioral test before final promotion.
- [ ] Behavioral-test failure transactionally rolls back source/test/manifest.
- [ ] `algorithmic_substance_gate` rejects assimilation packets and near-placeholder variants, not only the exact old template.
- [ ] Every substance-gate exception/import failure blocks rather than passes.
- [ ] `PENDING RECONNAISSANCE`, `CONCEPT_ONLY`, `KNOWLEDGE ONLY`, and `DEFER` cannot be registered as runtime tools.
- [ ] Integrator prompt no longer instructs `_2/_3` live capability suffixing.
- [ ] Unknown canonical owner causes defer/block, not dumping into `collective_synthesized`.
- [ ] Live capability creation no longer uses filename suffixing as semantic deduplication.
- [ ] Relevant `test_coding_loop.py` failures are resolved.
- [ ] Existing ignored stale bucket/assimilation fake artifacts are retired or migrated.
- [ ] New adversarial gate tests pass.
- [ ] Existing seven canonical harvested algorithms remain behaviorally intact.
- [ ] Existing provenance/audit artifacts remain intact.
- [ ] No mass re-generation of previously deleted placeholder modules occurs.
- [ ] A fresh harvesting → coding → integration trial demonstrates:
  - duplicate evidence -> `ALREADY_EXISTS`, no new module;
  - vague evidence -> `CONCEPT_ONLY`/defer, no new module;
  - implementable evidence -> real algorithm + executed behavioral test + canonical promotion.

---

# 20. Verification

Run at minimum:

1. substance-gate tests,
2. `collective_core/test_coding_loop.py`,
3. `write_code_e2e` tests,
4. assimilation-governance / promotion tests,
5. harvested canonical algorithm tests,
6. manifest/runtime integration tests affected by this path,
7. one clean end-to-end harvest → code → integrate fixture covering all three decision branches.

Perform a final scan for:

```text
PENDING RECONNAISSANCE
```

Any occurrence is acceptable only in:

- metadata/provenance,
- decision models,
- tests specifically validating deferred state,

not in live runtime capability implementations or manifests.

Perform a final scan for generated tests whose only evidence is:

```text
import
is_valid
_main
non-None
status
identity
```

There should be no such test representing a live implemented capability.

---

# Final Instruction

Do not redo the completed cleanup.

The remaining job is narrower and more important:

> **Finish separating knowledge/specification state from executable implementation state.**

The previous pass removed the old fake algorithms.

This pass must prevent the system from replacing them with `PENDING RECONNAISSANCE` Python packets that can still pass the gate, compile, import, and potentially become registered/promoted.

Only actual implemented behavior may cross into canonical runtime code.
