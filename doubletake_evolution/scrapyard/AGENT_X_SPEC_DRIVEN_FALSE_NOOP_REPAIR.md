# Agent_X — Spec-Driven False No-Op / Premature “Task Complete” Repair

Current audited `main` at prompt creation:

`aac9141b225c1f15c85977953947b4a213fa3884`

Re-check actual current `main` and working tree before editing.

## Exact production failure

The user runs:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Agent_X reports the task as complete / does nothing.

That completion decision is false.

Current `main` still contains Harvest implementation defects explicitly forbidden by the referenced specification.

Examples verified on current `main`:

### Harvest Gate B still claims implementation authority

`tools/agentx_evolve/collective_core/harvest_gate_b.py`

still describes Gate B as:

```text
the ONLY mint of implementation authorization
```

and `GateBDecisionV2` is still described as:

```text
the only record that authorizes code changes
```

This contradicts the intended architecture:

```text
Harvest Gate B:
candidate admission / disposition authority

Semantic-first:
sole project mutation authority
```

### `agentx_status` still drives architectural disposition

Current `analyze_semantic_fit()` still uses:

```python
item.agentx_status in ("upgrade", "update")
item.agentx_status == "exists"
```

to select:

```text
REPLACE
REJECT
EXTEND
```

This is specifically forbidden by the Harvest implementation specification.

`agentx_status` may be evidence/hint only.

It cannot be architectural authority.

### Harvest UI still enables implementation from disposition alone

Current:

```python
def can_implement(disposition: str) -> bool:
    return disposition.lower() in (
        "experiment_only",
        "replace",
        "extend",
        "complement",
        "new_component",
    )
```

This remains wrong.

Implementation eligibility must require the actual governed preconditions, not only a disposition string.

`EXPERIMENT_ONLY` must not mean production implementation is enabled.

### Harvest wiring still contains an unconditional truth bypass

Current `WiringRecord.completion_ready` still contains:

```python
(self.ui_api_wired or True)
```

which means UI/API wiring can never block completion.

This is explicitly one of the known Harvest defects the implementation spec requires removing.

Therefore:

```text
task complete
```

is objectively incorrect.

The issue is now in Agent_X's semantic completion / no-op reasoning for specification-driven requests.

---

# 1. Core defect

Current semantic-first correctly materializes referenced external specification files before interpretation.

However, the no-op/completion decision still reasons primarily from:

```text
does this capability/module already exist?
```

rather than:

```text
does current implementation satisfy every applicable requirement in the materialized specification?
```

For a request such as:

```text
complete everything according to: <spec.md>
```

these are not equivalent.

Existing Harvest modules only prove:

```text
Harvest exists
```

They do not prove:

```text
Harvest satisfies this specification
```

---

# 2. New invariant

For a spec-driven mutation/completion request:

```text
NO-OP / TASK COMPLETE
```

may be returned only after a **requirement-level compliance assessment** proves that every applicable requirement in the referenced specification is already satisfied by current accepted implementation truth.

Formally:

```text
spec-driven request
+
materialized specification
+
current canonical semantic model
+
current implementation evidence
↓
requirement coverage assessment
↓
all applicable requirements SATISFIED
↓
no-op/task complete allowed
```

Otherwise:

```text
one or more requirements:
UNSATISFIED
PARTIAL
UNKNOWN
UNVERIFIED
↓
task is NOT complete
```

---

# 3. Do not treat capability existence as completion

Capability/module existence may inform current-state discovery but never establish spec completion.

Keep distinct:

```text
EXISTS
SATISFIES_REQUIREMENT
VERIFIED_COMPLETE
```

---

# 4. Detect specification-driven requests explicitly

Add a deterministic request mode such as:

```text
SPEC_COMPLIANCE
```

when:

- user explicitly references a materialized specification/document; and
- request language means implement/complete/fix/bring project into compliance with that document.

Examples:

```text
complete everything according to: /path/spec.md
implement everything according to: /path/spec.md
finish everything in: /path/spec.md
make the project comply with: /path/spec.md
continue completing everything according to: /path/spec.md
```

Use materialized-source presence + semantic intent, not exact phrase matching only.

---

# 5. Create a canonical requirement model for the run

For `SPEC_COMPLIANCE` requests, transform the materialized specification into a bounded structured requirement set before deciding no-op.

Conceptually:

```python
SpecRequirement(
    requirement_id: str,
    source_digest: str,
    source_location: str,
    category: str,
    statement: str,
    mandatory: bool,
    semantic_targets: tuple[str, ...],
    acceptance_conditions: tuple[str, ...],
)
```

Use stable IDs derived from source digest + normalized requirement identity.

---

# 6. Requirement extraction must preserve explicit obligations

Capture where present:

- required behavior;
- forbidden behavior;
- authority rules;
- ownership rules;
- lifecycle requirements;
- replacement/removal requirements;
- UI behavior;
- error/failure behavior;
- evidence requirements;
- acceptance tests;
- state transitions;
- exact named defects to remove;
- exact code/interface constraints.

Do not reduce a detailed implementation spec to a vague summary.

---

# 7. Requirement extraction must be governed and auditable

Use governed LLM semantic reasoning to understand prose requirements, then validate deterministically:

- non-empty requirement ID;
- source location;
- meaningful statement;
- mandatory/optional classification;
- acceptance conditions where applicable.

Persist the extracted requirement set as run-bound evidence.

Do not silently mutate the requirement list later.

---

# 8. Compare each requirement to current implementation

For every mandatory requirement classify:

```text
SATISFIED
UNSATISFIED
PARTIAL
UNKNOWN
NOT_APPLICABLE
```

Each classification requires evidence.

Conceptually:

```python
RequirementAssessment(
    requirement_id=...,
    status=...,
    evidence=(code path, symbol, semantic binding, deterministic check, test/proof),
    reasoning=...,
)
```

---

# 9. `SATISFIED` requires positive evidence

Examples:

Requirement:

```text
Gate B must not be mutation authority.
```

Current code says Gate B is the only implementation authorization mint.

Result:

```text
UNSATISFIED
```

Requirement:

```text
agentx_status must not decide disposition.
```

Current code branches disposition on `agentx_status`.

Result:

```text
UNSATISFIED
```

Requirement:

```text
UI implement eligibility requires governed preconditions.
```

Current `can_implement(disposition)` uses disposition alone.

Result:

```text
UNSATISFIED
```

Requirement:

```text
UI/API wiring must actually block completion where applicable.
```

Current code contains:

```python
self.ui_api_wired or True
```

Result:

```text
UNSATISFIED
```

These exact regressions must become acceptance tests.

---

# 10. `UNKNOWN` and `PARTIAL` are not completion

Any mandatory requirement with:

```text
UNKNOWN
PARTIAL
UNSATISFIED
```

must block task completion.

Agent_X may gather more read evidence or run verification, but must not convert uncertainty into success.

---

# 11. No-op gate for spec-driven requests

Before returning no-op/task complete require:

```python
all(
    assessment.status in {"SATISFIED", "NOT_APPLICABLE"}
    for mandatory assessments
)
```

and no mandatory `UNKNOWN`, `PARTIAL`, or `UNSATISFIED`.

If any mandatory requirement fails, no-op is forbidden.

---

# 12. Target design must be driven by unsatisfied requirements

For spec-driven work, target design should receive:

```text
only remaining mandatory requirements
+
their current evidence
+
current canonical semantic owners
```

and generate implementation targets that close those gaps.

Do not redesign already-satisfied parts unnecessarily.

---

# 13. Preserve completed requirements

Already-satisfied requirements become immutable context for the current closure run.

Target design must distinguish:

```text
KEEP
MODIFY
REPLACE
REMOVE
CREATE
```

at requirement/component level.

---

# 14. Progress must be requirement-based

For long spec execution, persist:

```text
requirement set
assessment status
work item mapping
completed requirements
remaining requirements
verification evidence
source digest
```

Repeated runs against the same spec must continue from remaining requirements, not restart or falsely declare completion.

---

# 15. Source digest controls requirement identity

If the referenced spec changes:

- recompute source digest;
- invalidate old completion claim;
- re-extract/reconcile requirements;
- preserve reusable evidence only where safely mapped.

---

# 16. Completion assessment must use actual current code

Do not rely only on semantic model descriptions.

Preferred evidence order:

1. canonical accepted implementation snapshot;
2. exact source code/symbols;
3. runtime wiring/config;
4. tests/proofs;
5. semantic model/context.

Semantic descriptions alone cannot prove implementation compliance.

---

# 17. Prevent self-certification from stale semantic descriptions

If semantic metadata says:

```text
Harvest Gate B is the only authorization mint
```

while the requested spec says the opposite, that is a mismatch to repair, not evidence of completion.

Current semantic state describes what exists. It does not override the requested target.

---

# 18. Do not allow `already_exists=true` to bypass target design

For `SPEC_COMPLIANCE` mode, `already_exists` means only that related architecture exists.

Add a distinct compliance result such as:

```text
spec_compliance_complete
```

or equivalent structured state.

Only requirement assessment may set it true.

---

# 19. Improve completion result

When task complete is returned for a spec-driven request, provide bounded evidence:

```text
Specification: <source identity>
Digest: <digest>
Mandatory requirements: N
Satisfied: N
Not applicable: M
Remaining: 0
Verification: passed
Semantic reconciliation: SYNCED
```

Do not claim completion with no compliance evidence.

---

# 20. Real blockers must not be masked as completion

If requirements remain, implementation must continue.

If blocked, return the real blocker:

```text
UNRESOLVED_WRITE_SCOPE
PROVIDER_UNAVAILABLE
TEST_FAILURE
CONFLICT
GOVERNANCE_DENIAL
```

Never convert a blocker into “task complete.”

---

# 21. Exact Harvest regression test

Create a fixture representing the Harvest implementation spec with at least these mandatory requirements:

1. Gate B is not project mutation authority.
2. `agentx_status` is evidence only.
3. semantic-first is sole mutation authority.
4. `EXPERIMENT_ONLY` cannot directly enable production implementation.
5. `can_implement()` requires governed prerequisites.
6. UI/API wiring must block completion when applicable.
7. no `(ui_api_wired or True)` bypass.
8. canonical reconciliation/finalization required.

Run against fixture/current bad Harvest code.

Expected:

```text
UNSATISFIED > 0
spec_compliance_complete = false
no-op forbidden
```

---

# 22. Exact current-main regression

Against actual current Harvest implementation, the compliance assessment must detect at least:

```text
Gate B mutation-authority defect
agentx_status authority defect
can_implement disposition-only defect
ui_api_wired-or-True defect
```

If it reports all satisfied before those are fixed, the test fails.

---

# 23. Rerun the real user command

After this false-no-op repair is implemented, submit:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Expected:

```text
materialize Harvest spec
↓
extract requirement set
↓
compare current Harvest implementation requirement-by-requirement
↓
detect remaining defects
↓
NO-OP REJECTED
↓
semantic target built from remaining requirements
↓
exact target-driven write scope
↓
implementation starts
```

It must not immediately say task complete while known defects remain.

---

# 24. Harvest completion acceptance

After Harvest is genuinely fixed, submit the same command again.

Only then may Agent_X return completion/no-op, after proving:

```text
all mandatory Harvest requirements satisfied
+
required tests/evidence passed
+
canonical semantic reconciliation complete
+
current synchronization = SYNCED
```

---

# 25. Preserve semantic-first closure

Do not weaken or redesign the completed semantic-first foundation.

Preserve:

- external materialization before interpretation;
- bounded semantic provider behavior;
- prompt governance;
- strict semantic contracts;
- target-driven write authority;
- exact mutation scopes;
- scope provenance;
- verification freshness;
- evidence pairing;
- synchronization baseline;
- fail-closed semantics.

This repair changes completion reasoning for spec-driven work, not mutation authority.

---

# 26. Do not hard-code Harvest only

The bug is generic.

The same false completion can affect any request:

```text
complete everything according to: <large spec>
```

where a subsystem exists but is not compliant.

Implement generic spec-compliance semantics and use Harvest as the mandatory regression case.

---

# 27. Do not disable no-op globally

No-op remains valid when all requirements are truly satisfied.

The fix is:

```text
prove compliance before no-op
```

not:

```text
never no-op
```

---

# Completion criteria

Do not stop until all are true:

1. spec-driven requests are explicitly recognized.
2. referenced spec content is materialized before compliance assessment.
3. a structured run-bound requirement set is produced.
4. requirement IDs are source-digest bound/stable.
5. every mandatory requirement receives a status.
6. statuses include SATISFIED/UNSATISFIED/PARTIAL/UNKNOWN/NOT_APPLICABLE.
7. SATISFIED requires positive current implementation evidence.
8. UNKNOWN blocks completion.
9. PARTIAL blocks completion.
10. UNSATISFIED blocks completion.
11. capability/module existence alone cannot prove completion.
12. `already_exists=true` cannot bypass spec compliance.
13. remaining requirements drive target design.
14. satisfied requirements are not needlessly rewritten.
15. repeated runs resume from remaining requirements.
16. changed spec digest invalidates stale completion.
17. actual code/evidence is inspected, not semantic descriptions alone.
18. stale semantic descriptions cannot override requested target semantics.
19. task-complete result includes bounded compliance evidence.
20. real blockers cannot be masked as task complete.
21. current bad Harvest code is deterministically assessed as NOT COMPLETE.
22. Gate B old authority wording/behavior is detected as unsatisfied.
23. `agentx_status` authority usage is detected as unsatisfied.
24. disposition-only `can_implement()` is detected as unsatisfied.
25. `(ui_api_wired or True)` is detected as unsatisfied.
26. rerunning the real Harvest command starts implementation instead of immediately completing.
27. after genuine Harvest closure, the same command correctly returns no-op/completed.
28. semantic-first remains fail-closed and sole mutation authority.
29. canonical reconciliation after this repair ends `SYNCED`.
30. immediate no-change reassessment remains `SYNCED`.

# Stop condition

Stop only when Agent_X can distinguish:

```text
"The subsystem exists"
```

from:

```text
"The subsystem satisfies every mandatory requirement in this referenced specification"
```

and the exact current Harvest implementation is correctly judged incomplete until its known defects are actually repaired.

Decisive acceptance:

```text
complete everything according to:
/home/glompy/Downloads/AGENT_X_HARVEST_CURRENT_CODE_10_OF_10_IMPLEMENTATION.md
```

Against current bad Harvest implementation:

```text
must NOT return task complete
must identify remaining requirements
must proceed into semantic target + implementation
```

Only after those requirements are truly satisfied may the same command return task complete.
