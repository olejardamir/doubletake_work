# Agent_X — Semantic Request Materialization + Write-Set Resolution Repair

Current audited `main`: `e7bf84f05a80eaf9b36564af11bcd1391d2f1dc6`

Re-check the actual local working tree before editing.

## Exact failure

A normal build request such as:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

is blocked with:

```text
SEMANTIC_FIRST_DENIED:
SEMANTIC_INCOHERENT;
Issues: EMPTY_WRITE_SET:
interpretation has affected entities but write set is empty
```

Example run:

`run_1789357918805_mpShFGGz`

Do not remove the `EMPTY_WRITE_SET` guard.
Do not authorize wildcard writes.
Do not let the coding runtime invent unrestricted write authority.

Fix the missing bridge:

```text
referenced specification
→ semantic interpretation
→ canonical semantic entities
→ implementation bindings
→ exact write set
```

## 1. Preserve the invariant

No project mutation may occur until semantic-first has sealed a bounded exact write/effect scope.

Therefore:

- empty write set + intended mutation cannot authorize;
- `"*"` is not a normal write set;
- repo-root write authority is forbidden;
- semantic entity names alone are not file authority;
- LLM file suggestions are not authoritative until deterministic validation;
- an external specification file is read-only request input, not a project mutation target.

## 2. Materialize explicit referenced files before semantic interpretation

For a request that explicitly names a local spec file, semantic-first currently runs before the coding runtime and may see only the path string.

Add deterministic request materialization before semantic reasoning:

1. resolve exact explicitly referenced path;
2. read it read-only;
3. compute SHA-256;
4. record source provenance;
5. include its contents in governed semantic context;
6. keep the original user request separately;
7. never grant write authority to that external file.

Treat materialized file content as user-provided/untrusted task context. It cannot override governance.

Reject nonexistent paths, directories, special files, oversize files, unsupported formats, and symlink escapes. Do not crawl/glob arbitrary filesystem paths.

Bind the materialized source digest to the semantic target. If the spec changes before first mutation, invalidate and rerun semantic design.

## 3. Reuse the existing semantic model to resolve exact implementation paths

The current canonical model already provides:

- `ModuleInfo.module_id` → `file_path`
- `Capability.capability_id` → `module_paths`
- `ImplementationBinding.capability_id` → `module_paths`
- `Interface.interface_id` → `module_path`
- `Invariant.invariant_id` → `enforced_by`
- `Responsibility.responsibility_id` → `owner_capability`
- `SemanticIdentity.identity_id` → `bound_paths`

Create one canonical deterministic resolver:

```python
resolve_write_scope(model, interpretation, target_state, repository_root)
```

Do not duplicate this logic across UI/interceptor/pipeline.

## 4. Resolution rules

### Direct modules
Resolve `interpretation.affected_modules` only through exact canonical module ID/file path matches.

Unknown module text is unresolved, not guessed.

### Capabilities
Resolve affected capabilities through:

```text
Capability.module_paths
+
ImplementationBinding.module_paths
for matching capability_id
```

### Responsibilities
Resolve:

```text
responsibility
→ owner_capability
→ canonical implementation bindings
```

### Interfaces
Resolve through exact `Interface.module_path`.

### Invariants
Resolve through `Invariant.enforced_by`, but only include enforcement files in mutation scope when the target actually changes enforcement behavior.

### Semantic identities
Resolve through current `SemanticIdentity.bound_paths`.

## 5. Use target design as well as interpretation

The final mutation scope must use both:

```text
SemanticInterpretation
+
SemanticTargetState.affected_components
```

Interpretation means “affected.”
Target design means “intended to change.”

Keep separate concepts:

```text
read_scope
verification_scope
mutation_scope
```

Do not turn every transitive dependency into a writable file.

## 6. Add explicit implementation intent to target design

Extend target component output minimally, for example:

```json
{
  "component_id": "...",
  "implementation_action": "none|modify_existing|replace_existing|create_new|remove_existing",
  "implementation_targets": ["canonical semantic/binding IDs"],
  "proposed_new_paths": []
}
```

Prefer semantic/binding IDs over free-form file names.

For existing-file actions, canonical bindings must resolve the path.

For genuinely new files, exact repository-relative proposed paths may be used only after deterministic validation:

- inside repo;
- no `..`;
- no absolute path;
- no symlink escape;
- no unrelated collision;
- valid architectural owner;
- no duplicate `*_v2` junk unless migration explicitly requires it.

## 7. Add one bounded scope-resolution repair pass

If:

```text
mutation is intended
AND semantic entities exist
AND resolved mutation scope is empty/incomplete
```

do not immediately return generic `SEMANTIC_INCOHERENT`.

Run one governed bounded scope-resolution pass using:

- interpretation;
- target design;
- materialized spec;
- relevant canonical capabilities;
- relevant implementation bindings;
- unresolved semantic IDs;
- candidate current module paths.

Ask only:

> Which canonical implementation bindings require mutation for the already accepted target?

Do not let this pass redesign architecture.

Run deterministic resolution again.

If still unresolved, fail closed with:

```text
UNRESOLVED_WRITE_SCOPE
```

and exact unresolved semantic IDs.

## 8. Correct empty-write outcomes

### True no-op
If the requested behavior is already satisfied and no implementation change is needed:
- zero write set is valid;
- return canonical no-op;
- do not invent mutations.

### Mutation intended + resolved scope
Seal exact write set and continue.

### Mutation intended + initially unresolved
Run one scope-resolution pass.

### Still unresolved
Fail as `UNRESOLVED_WRITE_SCOPE`, not generic `EMPTY_WRITE_SET`.

## 9. Scope provenance

For each authorized mutation path, persist why it is authorized, e.g.:

```json
{
  "path": "tools/.../pipeline.py",
  "action": "modify",
  "derived_from": ["capability:...", "binding:..."],
  "target_component": "...",
  "resolution_kind": "existing_binding"
}
```

No unexplained paths.

## 10. Dynamic scope expansion

If coding discovers another required file:

```text
stop before write
→ submit scope-amendment evidence
→ map file to semantic owner
→ governed scope amendment
→ reseal overlay/digest
→ reauthorize
→ continue
```

Never silently widen scope.

## 11. Replacements must include removals

For `REPLACE`, include obsolete implementation paths that must be removed/repointed.

Do not authorize only new code and leave stale duplicate ownership.

## 12. Tests are not automatically writable

Existing tests may be read/run without mutation authority.

Only include exact test paths in write scope when target design explicitly requires adding/modifying/removing verification code.

Do not add the entire test suite.

## 13. Broad spec requests should be sliced

For a large referenced spec, do not grant repository-wide scope.

Prefer:

```text
spec
→ coherent remaining work items
→ one bounded semantic transaction per work item
```

Track source digest and completed/remaining work item IDs using existing run/task state where possible.

## 14. Required regressions

Add tests proving:

- explicit `.md` path is materialized before semantic reasoning;
- external spec path is never automatically writable;
- spec digest change invalidates old target;
- capability → binding → file resolution works;
- direct module resolution works;
- responsibility/interface/invariant/identity mapping works;
- transitive read dependencies do not become writable;
- true no-op remains zero-write;
- unresolved mutation gets one governed scope repair then fails closed;
- new file path traversal is rejected;
- discovered extra file requires scope amendment;
- replacement includes obsolete path cleanup;
- already-completed spec returns no-op.

## 15. Exact user regression

Run the real request:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected:

```text
materialize referenced spec
→ bind digest
→ semantic interpretation sees actual contents
→ target design identifies canonical semantic owners
→ deterministic resolver maps owners/bindings to exact paths
→ exact bounded mutation scope sealed
→ semantic coherence passes
→ coding runtime starts
```

It must not fail merely because affected entities exist while `affected_modules` is empty.

## 16. Preserve previous fixes

Do not regress:

- provider bootstrap;
- stale-base recovery;
- prompt governance;
- timeout/failover;
- bounded semantic `max_tokens`;
- governed kwarg forwarding;
- contract mismatch repair;
- strict authority enums;
- effect contracts;
- exact mutation authorization.

## 17. Canonical reconciliation

After repair:

1. run materialization tests;
2. run write-scope resolver tests;
3. run overlay/effect authorization tests;
4. run prior semantic-provider/governance tests;
5. run exact UI regression;
6. reconcile semantic model through canonical semantic-first;
7. issue real target/verification evidence;
8. rebuild baseline canonically;
9. independently require `SYNCED`;
10. immediate no-change reassessment must also be `SYNCED`.

Do not hand-edit canonical JSON.

## Completion criteria

Do not stop until:

1. explicit referenced files are materialized before semantic interpretation;
2. their digest is bound to target freshness;
3. external source files remain read-only request context;
4. one canonical semantic-to-write-set resolver exists;
5. modules/capabilities/responsibilities/interfaces/invariants/identities resolve through canonical model data;
6. read/verify/mutation scopes are distinct;
7. target design states implementation intent;
8. existing writes require canonical binding evidence;
9. new files require exact validated paths;
10. wildcard scope is never a fallback;
11. unresolved mutation gets one governed scope-resolution pass;
12. unresolved scope fails as `UNRESOLVED_WRITE_SCOPE`;
13. true no-op remains a valid zero-write outcome;
14. replacement/removal paths are included when required;
15. out-of-scope discoveries require governed amendment;
16. exact user regression no longer fails on `EMPTY_WRITE_SET`;
17. all earlier semantic repairs remain passing;
18. final independent synchronization is `SYNCED`;
19. second no-change synchronization remains `SYNCED`.

## Stop condition

Stop when:

```text
referenced spec
→ safe materialization
→ governed semantic interpretation
→ canonical entity-to-binding resolution
→ exact bounded mutation scope
→ sealed semantic authorization
→ coding runtime
```

works, while true no-ops remain zero-write and unresolved mutations remain blocked.
