# Agent_X — Final Two-Gap Semantic-First Closure

Current audited `main` at prompt creation:

`0f46fe4b55bd952b3d9b1cc679dacb0ef852260d`

Re-check actual current `main` and local working tree before editing.

This prompt contains only the final two remaining gaps.

Do not reopen already-fixed work unless a regression proves it is broken.

---

# Mission

Close these two remaining defects:

1. `affected_modules` from interpretation can still grant write authority without explicit target selection.
2. Canonical semantic/evidence/baseline state is still stale and has not been reminted/double-`SYNCED` against current code.

Final invariant:

```text
interpretation says what is affected
target design says what is intended to change
deterministic resolver maps accepted target → exact paths
only those paths become writable
```

Then current implementation must be canonically reconciled and proven:

```text
SYNCED
→ immediate no-change SYNCED
→ restart
→ SYNCED
```

---

# GAP 1 — Remove interpretation-only module write authority

## Current defect

Current `write_scope.py` is mostly target-driven, but still has a fallback equivalent to:

```python
for mod_id in affected_modules:
    mod = modules_by_id.get(mod_id)
    ...
    _add_resolved(
        resolved,
        mod.file_path,
        "modify",
        (f"module:{mod_id}",),
        "existing_module",
        mod_id,
    )
```

This means `interpretation.affected_modules` alone can still make a file writable.

That is incorrect.

`affected_modules` is impact analysis, not mutation authority.

## Required authority rule

A repository path may enter `mutation_scope` only when the accepted semantic target explicitly authorizes an implementation action.

Allowed mutation authority:

```text
AffectedComponent.implementation_action
+
AffectedComponent.implementation_targets
+
AffectedComponent.proposed_new_paths
+
deterministic canonical resolution
```

Not allowed by themselves:

- `interpretation.affected_modules`
- `interpretation.affected_capabilities`
- `interpretation.affected_invariants`
- `relationships_affected`
- transitive dependencies
- verification requirements
- read-scope evidence

These may inform read/verification scope only.

## Required change

Remove interpretation-only mutation fallback.

Instead:

```text
affected_modules
→ read_scope
```

unless the accepted target explicitly selects the module through:

```text
implementation_targets = ["module:<module_id>"]
```

or another exact canonical target resolving to the same file.

So:

```python
affected_modules=("tools.foo.bar",)
affected_components=()
```

must result in:

```text
mutation_scope = {}
read_scope includes tools/foo/bar.py
```

not a writable file.

## Explicit module target must still work

```json
{
  "component_id": "x",
  "implementation_action": "modify_existing",
  "implementation_targets": [
    "module:tools.foo.bar"
  ],
  "proposed_new_paths": []
}
```

Expected:

```text
mutation_scope = {"tools/foo/bar.py"}
```

with provenance tied to the target component.

## Preserve read-scope usefulness

For each `affected_module`:

- resolve exact canonical module;
- add its path to `read_scope`;
- if unknown, record unresolved;
- never grant write authority from interpretation alone.

## Unknown affected module

If interpretation returns:

```text
affected_modules = ["nonexistent.module"]
```

and no accepted target explicitly selects it:

Expected:

```text
read resolution unresolved
mutation_scope remains empty
```

If mutation is intended and exact target resolution is missing:

- use the existing one bounded governed scope-repair pass;
- if still unresolved, return `UNRESOLVED_WRITE_SCOPE`;
- no mutation.

## Update contradictory tests

Replace any test asserting:

```text
affected_modules alone
→ writable path
```

with:

### Test A — affected module is read-only

```python
scope = resolve_write_scope(
    model,
    affected_modules=("tools.foo.bar",),
    affected_components=(),
)
```

Expected:

```text
tools/foo/bar.py ∈ read_scope
tools/foo/bar.py ∉ mutation_scope
```

### Test B — explicit module target is writable

Add a target component selecting:

```text
module:tools.foo.bar
```

Expected exact module file in mutation scope.

### Test C — action none wins

Interpretation says module affected; target says:

```text
implementation_action = none
```

Expected no write authority.

## Audit other entity types

Apply the same principle to:

- capabilities
- invariants
- interfaces
- responsibilities
- semantic identities

For every category:

```text
affected
≠
authorized to mutate
```

If any direct-write fallback exists outside accepted target selection, remove it.

## Add a deterministic authority-audit assertion

After scope resolution, verify every mutation path can be traced to at least one accepted target component whose:

```text
implementation_action != none
```

and whose canonical implementation target resolves to that path.

If any mutation path lacks this:

```text
UNAUTHORIZED_SCOPE_DERIVATION
```

Fail closed.

## Required regression matrix

| Interpretation | Target | Expected mutation |
|---|---|---|
| affected module A | none | none |
| affected module A | target module:A | A |
| affected capability C with A+B | none | none |
| affected capability C with A+B | target binding:A | A only |
| affected capability C with A+B | target capability:C | A+B only because capability:C was explicitly selected |
| affected invariant I | none | none |
| affected invariant I | explicit enforcement target | exact enforcement path |
| affected interface X | none | none |
| affected interface X | target interface:X | interface path |

No row may grant writes solely from interpretation.

## Exact user regression after Gap 1

Run:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Required:

- external spec materialized before interpretation;
- affected semantic entities populate read/verification context;
- target design explicitly chooses exact implementation targets;
- only exact resolved paths become writable;
- no interpretation-only module receives mutation authority.

If no work remains, return canonical no-op.

---

# GAP 2 — Canonical remint and double-SYNCED closure

## Current defect

The committed:

```text
semantic_project/semantic_code_sync.json
```

still contains the older recovery baseline from September 13.

It does not represent the current semantic-first implementation.

Current `main` is therefore not canonically closed yet.

## Never manually patch the baseline

Forbidden:

- editing revision hashes by hand;
- copying source hashes manually;
- reusing old consumed evidence;
- changing only timestamps;
- replacing only `implementation_revision`;
- forcing status text to `SYNCED`.

Use canonical tooling.

## Recompute current production implementation state

After Gap 1 is fixed and tests pass, compute current canonical production snapshot and:

```text
implementation_revision
source_hashes
repository_identity
```

The snapshot must include all current production-authoritative semantic-first files, including as applicable:

- `semantic_first/materialize.py`
- `semantic_first/write_scope.py`
- `semantic_first/pipeline.py`
- `semantic_first/interceptor.py`
- provider/governance helpers changed by prior repairs
- synchronization/recovery logic
- any new helper introduced by Gap 1

Do not classify tests as production unless canonical classifier says so.

## Recompute verification state

Compute current:

```text
verification_snapshot
verification_revision
```

using canonical verification classification.

Do not reuse an older verification revision.

## Reconcile current semantic model

Regenerate/reconcile the semantic model through canonical tooling.

It must represent:

- external explicit request-source materialization;
- read-only external source boundary;
- pre-interpretation materialization;
- source digest freshness;
- target-driven mutation authority;
- canonical implementation-target namespaces;
- exact semantic-target → path resolution;
- separate read/verification/mutation scopes;
- bounded scope repair;
- interpretation-only entities are non-authoritative for writes;
- no wildcard write fallback.

Do not hand-edit `project_model.json`.

## Issue fresh target evidence

Create a new canonical target artifact bound to:

- new change ID;
- new run ID;
- current semantic revision;
- current implementation revision;
- current repository identity;
- current target digest;
- accepted current architecture;
- no unresolved scope authority.

Do not reuse September 13 target evidence.

## Issue fresh verification evidence

Run the required verification suite and issue fresh verification evidence bound to:

```text
current target
current semantic revision
current implementation revision
current verification revision
repository identity
```

Minimum verification:

- target-driven write-scope tests;
- interpretation-only no-write regression;
- external materialization tests;
- pre-interpretation sentinel test;
- source freshness test;
- scope-repair test;
- effect authorization tests;
- provider/governance regressions;
- synchronization/finalization tests.

## Validate evidence pairing

Before baseline promotion prove:

```text
target.change_id == verification.change_id
target.run_id == verification.run_id
target.implementation_revision == verification.implementation_revision
target.semantic_revision == verification.semantic_revision
verification.verification_revision == current verification revision
repository identity matches
```

Mismatch blocks promotion.

## Consume evidence atomically

Use existing replay-protection/evidence-consumption machinery.

Consume new target/verification evidence exactly once.

No reuse of consumed evidence.

## Build new baseline canonically

Use canonical baseline builder.

The new baseline must contain current:

```text
semantic_revision
implementation_revision
verification_revision
source_hashes
bindings_digest
repository_identity
accepted_target_digest
accepted_change_id
accepted_run_id
```

The old September 13 baseline must no longer be current authority.

## Independent first synchronization assessment

After baseline persistence, run a fresh assessment from disk/state.

Require exactly:

```text
SYNCED
```

No:

- `STALE_BASE`
- `IMPLEMENTATION_AHEAD`
- `SEMANTIC_AHEAD`
- `BOTH_DIVERGED`
- verification mismatch
- unresolved conflict
- missing evidence
- repository mismatch

## Immediate second no-change assessment

Without modifying anything, run synchronization assessment again.

Require:

```text
SYNCED
```

again.

This is mandatory.

## Restart persistence test

Restart Agent_X/backend.

Then:

1. reload canonical model;
2. reload baseline;
3. reload evidence-consumption state;
4. run synchronization assessment;
5. require `SYNCED`.

No in-memory-only success.

## Exact post-restart user regression

Submit:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected one of two valid outcomes:

### Work remains

```text
external source materialized
→ governed interpretation
→ exact target selection
→ exact least-authority write set
→ implementation proceeds
```

### Work already complete

```text
external source materialized
→ semantic comparison
→ canonical no-op/completed result
```

Invalid outcomes include:

- stale-base deadlock;
- prompt review deadlock;
- timeout loop;
- kwarg TypeError;
- authority enum mismatch;
- `EMPTY_WRITE_SET` from interpretation-only scope;
- write authorization from `affected_modules` alone.

## Final cleanup

Before completion, inspect:

```text
semantic_project/changes/
run-local semantic state
conflict records
temporary evidence
bootstrap repair artifacts
```

Retain only what canonical retention/replay policy requires.

No stale transient state may participate in current authority.

---

# Completion criteria

Do not stop until ALL are true:

1. `affected_modules` alone never grants mutation authority.
2. `affected_capabilities` alone never grants mutation authority.
3. interpretation-only invariants/interfaces/responsibilities do not grant writes.
4. affected modules remain available in read scope.
5. explicit `module:<id>` target grants exact module write authority.
6. target action `none` grants no write authority.
7. exact binding target grants only its exact file(s).
8. every writable path traces to an accepted target component.
9. authority audit rejects mutation paths lacking target provenance.
10. tests no longer expect interpretation-only module writes.
11. exact external-spec user regression still works.
12. target design is the only source of mutation intent.
13. write scope remains least-authority.
14. prior semantic-first repair tests still pass.
15. current implementation snapshot is recomputed.
16. current verification revision is recomputed.
17. current semantic model is canonically reconciled.
18. fresh target evidence is issued.
19. fresh verification evidence is issued.
20. evidence pair validates against current revisions.
21. evidence is consumed atomically once.
22. new synchronization baseline is built canonically.
23. old September 13 baseline is no longer current authority.
24. first independent assessment is `SYNCED`.
25. second no-change assessment is `SYNCED`.
26. restart assessment is still `SYNCED`.
27. exact post-restart external-spec request either proceeds correctly or returns canonical no-op.
28. no stale transient artifact overrides accepted current baseline.

---

# Final decisive acceptance sequence

```text
affected module detected by interpretation
        ↓
read scope only
        ↓
accepted target explicitly selects implementation target
        ↓
deterministic exact path resolution
        ↓
mutation authority

then:

current code
        ↓
canonical semantic reconciliation
        ↓
fresh target evidence
        ↓
fresh verification evidence
        ↓
new accepted baseline
        ↓
independent SYNCED
        ↓
second no-change SYNCED
        ↓
restart
        ↓
SYNCED
```

---

# Stop condition

Stop only when both final gaps are gone:

```text
1. interpretation can no longer grant write authority by itself
2. current main has a genuinely current canonically reminted baseline proven by double-SYNCED and restart-SYNCED
```

Do not stop because tests alone pass, commit messages say complete, `project_model.json` changed, a baseline file exists, one assessment returned `SYNCED`, or the UI ran successfully once.

Final authority is:

```text
actual current code
+
fresh current semantic model
+
fresh current evidence
+
fresh current baseline
+
independent SYNCED
+
second no-change SYNCED
+
restart-SYNCED
```
