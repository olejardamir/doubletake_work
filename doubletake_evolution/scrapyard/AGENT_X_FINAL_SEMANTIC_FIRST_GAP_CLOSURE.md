# Agent_X — Final Semantic-First Gap Closure

Current audited `main` at prompt creation:

`1346909f726b688046936f551bbf12607278806b`

Re-check actual current `main` and local working tree before editing.

This prompt contains **only the remaining work** required to close the semantic-first foundation.

Do not reopen already-fixed provider/bootstrap/timeout/governance/contract-repair work unless a regression proves it is broken.

---

# Mission

Close the final four defects:

1. explicit request-source files outside the repository/workspace are incorrectly rejected;
2. request materialization happens after semantic interpretation instead of before it;
3. write-scope resolution is broader than the accepted semantic target;
4. canonical semantic model/baseline/evidence have not been reminted for the current implementation.

The final normal path must be:

```text
user request
    ↓
explicit referenced source materialization
    ↓
governed semantic interpretation of the actual request + source content
    ↓
semantic target design
    ↓
exact semantic-target → implementation-binding resolution
    ↓
least-authority exact write set
    ↓
sealed semantic authorization
    ↓
implementation
    ↓
verification/reconciliation
    ↓
canonical accepted baseline
    ↓
independent SYNCED
    ↓
second no-change SYNCED
```

Do not weaken fail-closed behavior.

---

# 1. Fix explicit external request-source materialization

## Current defect

`semantic_first/materialize.py` currently treats the repository/workspace root as both:

- project mutation boundary; and
- request-source read boundary.

It rejects any path whose resolved path is not under `workspace_root`.

That means the exact user request:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

cannot materialize the referenced document when the Agent_X repository is elsewhere.

This is incorrect.

The repository boundary should constrain **writes**.

It should not automatically forbid explicitly user-referenced read-only source documents outside the repo.

## Required authority model

Separate:

```text
project mutation boundary
```

from:

```text
explicit user-selected read-only request source
```

An explicitly referenced external source file may be read when:

- the path is explicitly present in the user request or explicit attachment metadata;
- it resolves to a regular file;
- it is within allowed read-only source policy;
- it passes size/type/symlink checks.

It never becomes project mutation authority.

## Required implementation

Refactor materialization so the API distinguishes:

```python
workspace_root
```

from a read-only source policy.

Do not require:

```python
source_path.relative_to(workspace_root)
```

for explicitly user-selected source files.

Instead:

1. resolve the explicit path;
2. reject nonexistent paths;
3. reject directories;
4. reject device/socket/special files;
5. resolve symlink target;
6. apply read-only source policy to the resolved target;
7. enforce size limits;
8. enforce supported text/source types;
9. compute digest;
10. read only.

The materialized source should preserve an absolute resolved source identity internally.

Do not convert external paths into fake repository-relative paths.

Use a stable source ID such as:

```text
external-file:<sha256 or canonical path digest>
```

where appropriate.

## Security

Do not generalize this into unrestricted filesystem crawling.

Only read:

- a path explicitly referenced by the user;
- an explicit attached file;
- another explicitly authorized request source.

No globbing.

No recursive directory reads.

No `$HOME` crawl.

No implicit environment-file reads.

## Mutation rule

The external source path MUST NEVER enter:

- mutation scope;
- write set;
- delete set;
- project overlay write authority;

unless a completely separate explicit external-file editing workflow authorizes it.

For this semantic-first workflow it is input only.

---

# 2. Move materialization before semantic interpretation

## Current defect

Materialization currently occurs inside:

```python
design_target_state(...)
```

after:

```python
interpret(...)
```

has already run.

Therefore semantic interpretation may see only:

```text
continue completing everything according to:
/home/glompy/Downloads/...
```

instead of the actual contents of the specification.

This defeats the purpose of request materialization.

## Required order

The canonical pipeline must become:

```text
raw request
    ↓
materialize explicit request sources
    ↓
build governed semantic request context
    ↓
interpret
    ↓
design target
```

not:

```text
interpret
    ↓
materialize
    ↓
design
```

## Canonical request object

Use one request object for the semantic transaction.

Conceptually:

```python
MaterializedRequest(
    original_text=...,
    sources=(...),
    augmented_text=...,
    source_digest=...,
)
```

The same object/digest must feed:

- interpretation;
- target design;
- scope resolution;
- overlay metadata;
- freshness checks.

Do not rematerialize independently at multiple stages and risk different contents.

## Interpretation input

When sources exist, the governed semantic interpretation must receive:

```text
ORIGINAL USER REQUEST
+
SOURCE PROVENANCE
+
MATERIALIZED SOURCE CONTENT
+
CURRENT CANONICAL PROJECT MODEL
```

Preserve the source as untrusted user context.

Do not treat text inside the source as system/developer authority.

## Target design

Target design should reuse the same materialized request object.

Do not reread the file unless validating freshness.

## Freshness

Immediately before first authorized project mutation:

1. re-stat/re-read or rehash the explicit source;
2. compare to the source digest bound into the target;
3. if changed:
   - revoke stale authorization;
   - rematerialize;
   - rerun interpretation/design;
   - reseal scope.

No stale document may drive a mutation.

---

# 3. Fix exact target-driven write-scope resolution

## Current defect

Current `write_scope.py` broadly treats:

```text
affected_capability
```

as sufficient to make:

- every `Capability.module_paths`; and
- every matching `ImplementationBinding.module_paths`

writable.

That is too broad.

It also does not make `implementation_targets` the authoritative narrowing mechanism for existing-file mutation.

An affected capability may have multiple implementation files, while a particular semantic target may require changing only one.

Affected does not mean writable.

## Required authority model

Write scope must be derived from:

```text
accepted semantic target
+
explicit implementation action
+
explicit implementation targets
+
canonical implementation bindings
```

Interpretation provides impact evidence.

Target design provides mutation intent.

The resolver seals exact files.

## Required target contract

For every mutation-intended target component require:

```json
{
  "component_id": "...",
  "implementation_action": "modify_existing|replace_existing|remove_existing|create_new|none",
  "implementation_targets": ["..."],
  "proposed_new_paths": []
}
```

### `none`

Must produce no mutation paths for that component.

### `modify_existing`

Must resolve only the explicitly named canonical implementation targets required for the change.

### `replace_existing`

Must resolve:

- exact incumbent implementation targets to modify/remove;
- exact replacement target/new path if applicable;
- required caller/registration paths only when the target explicitly requires them.

### `remove_existing`

Must resolve exact obsolete implementation targets.

### `create_new`

Must validate exact new repository-relative paths and semantic owner.

---

# 4. Define canonical implementation-target IDs

Do not make free-form file paths the primary language for existing code.

`implementation_targets` should resolve exact canonical entities such as:

- implementation binding ID;
- module ID;
- interface ID;
- semantic identity ID;
- responsibility ID;
- canonical capability binding target.

Define one deterministic target namespace.

Example:

```text
binding:<binding_id>
module:<module_id>
interface:<interface_id>
identity:<identity_id>
responsibility:<responsibility_id>
```

Do not guess what an unqualified string means when it could refer to multiple namespaces.

If backward compatibility requires plain IDs, normalize them only when exactly one canonical entity matches.

Ambiguity → unresolved, not guessed.

---

# 5. Resolver algorithm

The resolver must process each target component independently.

Conceptually:

```python
for component in target.components:
    action = component.implementation_action

    if action == "none":
        continue

    if action in {"modify_existing", "replace_existing", "remove_existing"}:
        require implementation_targets
        resolve each target exactly
        add only resolved files required by that action

    if action == "create_new":
        validate proposed_new_paths
        add exact create paths
```

Then merge/deduplicate paths across components.

Do not start from all affected capabilities and mark everything writable.

Affected capabilities may inform:

- read scope;
- verification scope;
- candidate binding lookup;

but not blanket mutation authority.

---

# 6. Capability-level fallback is allowed only when exact and singular

A capability may be used directly as an implementation target only when deterministic canonical truth proves it has exactly one relevant implementation binding/path for the requested action.

If a capability maps to multiple implementation paths:

- do not authorize them all automatically;
- require the semantic target or scope-repair pass to choose the exact binding(s).

This is a least-authority requirement.

---

# 7. Read scope and verification scope remain broader

It is valid for:

```text
read_scope
```

to include:

- affected capability files;
- dependencies;
- callers;
- interfaces;
- related configs;
- tests.

It is valid for:

```text
verification_scope
```

to include:

- relevant tests;
- proof code;
- invariant checks.

But:

```text
mutation_scope
```

must remain target-specific.

Do not solve limited write scope by expanding mutation scope.

---

# 8. Scope-repair pass must return exact implementation targets

If the accepted target intends mutation but lacks resolvable exact targets:

Run one governed bounded scope-repair pass.

Its output must be machine-contract data such as:

```json
{
  "component_scopes": [
    {
      "component_id": "...",
      "implementation_action": "modify_existing",
      "implementation_targets": [
        "binding:semantic_first.pipeline"
      ],
      "proposed_new_paths": []
    }
  ]
}
```

Do not ask it for arbitrary file lists.

The deterministic resolver maps those IDs to files.

Strictly validate the repair output.

One repair pass only.

If still unresolved:

```text
UNRESOLVED_WRITE_SCOPE
```

No mutation.

---

# 9. Validate scope actions against authority decisions

Implementation scope and semantic authority must be compatible.

Examples:

## `prompt_only`

A purely prompt-only target may legitimately have:

- prompt file changes;
- semantic prompt/config changes;

but must not automatically authorize deterministic enforcement code.

## `prompt_driven`

May authorize:

- prompt/instruction changes;
- bounded deterministic enforcement/validation;
- existing runtime integration needed for the prompt-driven responsibility.

## `deterministic`

May authorize deterministic enforcement/state/effect code.

Do not let `implementation_targets` contradict the accepted authority decision silently.

Add a coherence check.

---

# 10. New-path validation

For `create_new`, validate:

- repository-relative;
- no absolute path;
- no `..`;
- no symlink escape;
- no outside-worktree write;
- valid file type;
- not generated/runtime debris location;
- no collision with unrelated canonical owner;
- no junk naming such as `*_v2` solely to avoid replacing incumbent code.

Bind each new path to:

- target component;
- semantic owner;
- action;
- rationale.

---

# 11. Replacement completeness

For `replace_existing`, scope resolution must include all required supersession effects.

At minimum determine whether the accepted target requires mutation/removal of:

- incumbent implementation file;
- import/caller path;
- registration;
- UI/API route;
- config;
- persisted-state migration;
- test/proof code.

Do not blindly include all of them.

Include only those explicitly required by the semantic target and deterministic dependency/reference evidence.

After implementation, reference scan must prove no unintended stale production path remains.

---

# 12. Scope provenance is mandatory

Every mutation path must carry provenance.

Example:

```yaml
path: tools/agentx_evolve/semantic_first/pipeline.py
action: modify
target_component: semantic_request_materialization
implementation_target: binding:semantic_first.pipeline
derived_from:
  - capability:semantic_first
  - binding:semantic_first.pipeline
resolution_kind: explicit_target_binding
```

No unexplained writable path.

---

# 13. External specification regression test

Add a real regression that mirrors the user's actual topology.

Use:

```text
repository root:
  /tmp/repo/Agent_X

explicit spec:
  /tmp/downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

The spec MUST be outside the repository/workspace root.

Request:

```text
continue completing everything according to:
/tmp/downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected:

- exact external file materialized;
- digest captured;
- contents included before semantic interpretation;
- source remains read-only;
- source path never appears in mutation scope.

The old test that uses the same `tmp_path` as both workspace and spec location is insufficient.

Keep it if useful, but add the real external-path case.

---

# 14. Pre-interpretation materialization regression

Instrument a fake semantic provider.

The provider must receive the actual contents of the referenced spec during the **interpretation** call.

Test:

```text
spec contains sentinel:
SEMANTIC_SPEC_SENTINEL_123
```

Assert:

```text
interpretation provider input contains SEMANTIC_SPEC_SENTINEL_123
```

This proves materialization happens before interpretation.

Do not accept a test that only proves target design sees the content.

---

# 15. Same-source-object regression

Verify that interpretation and target design refer to the same:

- source digest;
- source identity;
- source materialization transaction.

Do not independently materialize the same external file twice as normal behavior.

Freshness rehash before mutation is separate and intentional.

---

# 16. Target-driven write-scope tests

## A. Capability with two bindings, one target selected

```text
capability C
bindings:
  B1 → a.py
  B2 → b.py

target:
  implementation_action = modify_existing
  implementation_targets = [binding:B1]
```

Expected:

```text
mutation_scope = {a.py}
read_scope may include {a.py, b.py}
```

`b.py` must not be writable.

## B. Action `none`

Affected capability has files.

Target action:

```text
none
```

Expected:

```text
mutation_scope contains no files from this component
```

## C. Ambiguous plain target

Two canonical entities share the same plain ID/name.

Expected:

```text
UNRESOLVED_WRITE_SCOPE
```

not both.

## D. Exact module target

```text
module:tools.agentx_evolve.semantic_first.pipeline
```

Expected exact single file.

## E. Replace target

Target selects incumbent binding + exact replacement/new path.

Expected only required replace/remove/create files.

---

# 17. Scope-repair tests

Initial target lacks exact implementation targets.

Expected:

```text
one governed scope repair
→ exact canonical binding IDs returned
→ deterministic resolver
→ exact write scope
```

Invalid repair returns arbitrary file path instead of canonical target:

Expected rejection.

Second failed repair:

Expected:

```text
UNRESOLVED_WRITE_SCOPE
```

No second repair loop.

---

# 18. Real exact-user regression

After implementation, from the real UI submit:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Required evidence:

1. external `/home/glompy/Downloads/...md` is read;
2. digest recorded;
3. interpretation sees document contents;
4. target design uses same source digest;
5. exact implementation targets are selected;
6. mutation scope is non-empty only where actual remaining work exists;
7. no unrelated capability files become writable;
8. semantic coherence succeeds;
9. coding runtime starts.

If the specification is already fully satisfied:

- return canonical no-op;
- do not invent a write set.

---

# 19. Recheck current implementation truth before final remint

Do not immediately remint after code changes.

First run the actual semantic-first regression suite.

At minimum verify:

- provider bootstrap;
- timeout/failover;
- governed kwargs;
- prompt governance;
- contract repair;
- verification-revision recovery;
- request materialization;
- write-scope resolution;
- effect contracts;
- authorization;
- finalization;
- restart/recovery.

Do not trust the latest commit message.

---

# 20. Canonical semantic model must include the new architecture

The current semantic model must be regenerated/reconciled through canonical tooling so it represents:

- explicit request-source materialization;
- external source read-only trust boundary;
- source digest freshness;
- target-driven implementation scope;
- canonical semantic-target → implementation-binding resolution;
- read/verification/mutation scope separation;
- governed scope repair;
- no wildcard fallback.

Do not hand-edit `project_model.json`.

---

# 21. Remint the canonical baseline

The currently committed `semantic_code_sync.json` predates the final implementation and is stale.

After all code/tests are correct:

1. compute current production `source_snapshot`;
2. compute current `implementation_revision`;
3. compute current verification snapshot/revision;
4. rebuild/reconcile semantic project model;
5. compute semantic/model revision;
6. issue new target evidence;
7. issue new verification evidence;
8. bind both to the actual current revisions;
9. validate evidence pairing;
10. consume evidence atomically;
11. build synchronization baseline through the canonical builder;
12. persist atomically.

Do not:

- manually copy hashes;
- hand-edit revision fields;
- reuse an old consumed evidence pair;
- reuse the September 13 baseline.

---

# 22. Baseline must include all new production files

Verify the current production snapshot/baseline includes, where runtime-authoritative:

- `semantic_first/materialize.py`;
- `semantic_first/write_scope.py`;
- updated `semantic_first/pipeline.py`;
- updated interceptor/provider/governance code from prior repairs;
- any new runtime helper introduced by this final repair.

Tests remain verification evidence rather than production implementation unless current classifier says otherwise.

---

# 23. Evidence must match current code exactly

For the final target/verification evidence prove:

```text
evidence implementation revision
==
current recomputed implementation revision
```

and:

```text
evidence semantic revision
==
current recomputed semantic/model revision
```

and:

```text
verification revision
==
current verification snapshot revision
```

No stale hashes from earlier semantic-first closure iterations.

---

# 24. Independent final synchronization assessment

After baseline persistence:

Run a fresh independent assessment.

Require exactly:

```text
SYNCED
```

with:

- no stale base;
- no implementation ahead;
- no semantic ahead;
- no verification drift;
- no unresolved conflict;
- no missing evidence;
- no repository identity mismatch.

Do not infer success from the baseline file contents alone.

---

# 25. Second no-change assessment

Immediately run synchronization assessment again without modifying anything.

Require:

```text
SYNCED
```

again.

This proves:

- evidence persistence does not change source snapshot;
- verification artifacts do not self-trigger drift;
- canonical model persistence does not create implementation drift;
- no transaction junk changes authority state.

---

# 26. Restart acceptance

Restart Agent_X/backend.

Then:

1. load canonical semantic state;
2. independently assess;
3. require `SYNCED`;
4. submit a read-only request;
5. submit the exact external-spec build regression;
6. verify semantic-first uses the reminted baseline.

No in-memory-only success.

---

# 27. No-change exact request behavior

If the referenced closure document is now completely satisfied, the exact request should not create fake work.

Expected:

```text
external spec materialized
→ semantic comparison against current accepted project
→ no remaining mutation
→ canonical no-op/completed outcome
```

This is a valid success.

Do not fail because write set is empty when semantic reasoning has explicitly established a no-op.

---

# 28. Do not reopen closed work unnecessarily

Do not use this prompt to redesign:

- provider architecture;
- LLM7 discovery;
- prompt-governance system;
- verification recovery;
- tool-effect contracts;
- Harvest;
- UI styling;
- unrelated runtime code.

Only repair regressions in those areas if final tests prove one.

---

# 29. Completion criteria

Do not stop until ALL are true:

1. explicitly referenced external files may be materialized read-only even outside repo root;
2. arbitrary filesystem crawling is still impossible;
3. external sources never gain mutation authority;
4. external source digest is recorded;
5. materialization occurs before semantic interpretation;
6. interpretation receives actual source contents;
7. target design receives the same materialized source identity/digest;
8. source digest is revalidated before first mutation;
9. changed source invalidates stale target;
10. mutation scope is target-driven, not merely capability-driven;
11. `implementation_action=none` produces no writes;
12. exact `implementation_targets` drive existing-file mutation;
13. canonical target namespaces are deterministic;
14. ambiguous targets fail closed;
15. capability with multiple bindings does not automatically authorize all paths;
16. read scope can remain broader than mutation scope;
17. verification scope can remain broader than mutation scope;
18. new files require exact validated paths;
19. one bounded governed scope-repair pass can resolve missing targets;
20. scope repair cannot return arbitrary authoritative paths;
21. unresolved scope ends as `UNRESOLVED_WRITE_SCOPE`;
22. replacements include exact necessary supersession paths;
23. every writable path has provenance;
24. the real outside-workspace regression passes;
25. interpretation-sentinel regression proves pre-interpretation materialization;
26. exact `/home/glompy/Downloads/...md` request reaches semantic design correctly;
27. exact request reaches coding runtime when real remaining work exists;
28. exact request returns no-op when the spec is already fully satisfied;
29. semantic model has been canonically regenerated/reconciled;
30. current production implementation revision recomputes and matches evidence;
31. current semantic/model revision recomputes and matches evidence;
32. current verification revision recomputes and matches evidence;
33. accepted target/verification artifacts are new and coherent;
34. `semantic_code_sync.json` is reminted from current code, not September 13 state;
35. independent synchronization assessment returns `SYNCED`;
36. immediate second no-change assessment returns `SYNCED`;
37. backend restart still loads a `SYNCED` canonical state;
38. no `semantic_project/changes/` or run-state junk accumulates from the closure process.

---

# Final decisive acceptance scenario

The task is complete only when this exact flow works:

```text
User:
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md

        ↓

Agent_X explicitly materializes that external file read-only

        ↓

Semantic interpretation sees the actual file content

        ↓

Current accepted Agent_X semantic model is compared to the requested work

        ↓

If work remains:
    target design selects exact canonical implementation targets
    ↓
    deterministic resolver seals least-authority exact mutation paths
    ↓
    semantic authorization succeeds
    ↓
    coding runtime performs only authorized changes
    ↓
    verification/reconciliation succeeds

If no work remains:
    canonical no-op/completed result

        ↓

canonical model/evidence/baseline rebuilt from current implementation

        ↓

independent assessment = SYNCED

        ↓

second no-change assessment = SYNCED

        ↓

restart

        ↓

assessment still = SYNCED
```

---

# Stop condition

Stop only when the four audited gaps are gone:

```text
1. external explicit source files work read-only
2. materialization happens before interpretation
3. write scope follows exact semantic target/bindings
4. canonical current state is reminted and independently double-SYNCED
```

Do not stop because:

- unit tests alone pass;
- commit message says fixed;
- the UI reaches the coding runtime once;
- a baseline file contains `"SYNCED"`;
- the old September 13 evidence still validates internally.

The final authority is the actual current code plus newly generated current evidence plus two independent no-change `SYNCED` assessments.
