# Agent_X Final Semantic-First Closure — End-to-End Repair Prompt

You are working on the current Agent_X `main`.

At the time this prompt was written, the latest audited main was:

`248f2edac494e0ddafead2fd69a9e9e4cf034eba`

Do not assume that SHA is still current. Begin by inspecting the actual current `main`.

## Mission

Finish the semantic-first architecture completely.

Do **not** redesign the whole system.

Do **not** redo Harvest generally.

Do **not** add unrelated cleanup, UI redesign, CI/CD, GitHub Actions, or broad refactors.

The remaining defects are specific:

1. Canonical semantic state is currently `EVIDENCE_GATHERED`, not `SYNCED`.
2. The canonical project model is currently `semantic_generation_status = incomplete`.
3. The current Harvest semantic tests can modify real canonical semantic files.
4. `/api/chat` checks for an already-existing semantic authorization but does not itself run the semantic-first lifecycle for an ordinary write-capable prompt.
5. `/api/chat` relies on `_is_write_operation()` as a practical bypass decision even though it is only a heuristic.
6. Stale-backend protection is fail-open in multiple places.
7. Borg dependency coherence still does not require an actual semantic-first PASS-equivalent authorization; it only rejects `BLOCKED`.
8. The repository must finish with an actually verified semantic↔implementation `SYNCED` baseline produced through the canonical pipeline.

The final invariant is:

> Every material Agent_X mutation begins from semantic truth, produces a semantic target before implementation, and ends only after actual implementation and canonical semantic state have been reconciled and accepted as synchronized.

## Execution rule: convergence loop

Execute this task as a closure loop, not as a one-pass patch:

1. inspect the current implementation and canonical semantic state;
2. identify the highest-impact remaining material discrepancy against this prompt;
3. fix it through the semantic-first lifecycle;
4. run production-path verification;
5. re-audit the actual resulting repository and canonical state from scratch;
6. repeat while any material discrepancy remains.

Do not stop because a checklist file says complete, a test count is green, or a status report claims success. Stop only when a fresh audit of the actual repository finds no material violation of any completion criterion in this document. Do not invent cosmetic work merely to continue the loop.

---

# 1. Inspect current main before making changes

Begin by inspecting the real current `main`.

Verify the current behavior of at least:

- `tools/agentx_evolve/api/chat.py`
- `tools/agentx_evolve/api/sessions.py`
- `tools/agentx_evolve/api/state.py`
- `api_server.py`
- `tools/agentx_evolve/workflow_governance/checkpoints.py`
- `tools/agentx_evolve/collective_core/borg_collective_orchestrator.py`
- `tools/agentx_evolve/semantic_first/interceptor.py`
- `tools/agentx_evolve/semantic_first/pipeline.py`
- `tools/agentx_evolve/semantic_first/project_model.py`
- `tools/agentx_evolve/semantic_first/enrichment.py`
- `tools/agentx_evolve/semantic_first/synchronization.py`
- `tools/agentx_evolve/semantic_first/reconcile_harvest.py`
- `tools/agentx_evolve/semantic_first/test_harvest_semantic_truth.py`
- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`

Do not trust status comments, completion logs, or self-reported test summaries.

Inspect actual code and canonical state.

## Safe entry from the currently disputed semantic state

The current repository may begin this task in a state such as:

- `EVIDENCE_GATHERED`;
- incomplete semantic generation;
- disputed/incorrect canonical semantic claims;
- semantic-first enforcement code that is itself one of the things being repaired.

Do not solve this circularity by disabling governance or allowing unrestricted direct writes.

Use the narrowest existing explicit repair/conflict-resolution/recovery mechanism capable of repairing semantic-first itself.

The repair authority must be bound to:

- the exact current repository/workspace;
- the exact current implementation snapshot;
- the disputed semantic baseline/state;
- this closure request;
- a unique repair/change ID;
- an explicit bounded repair write set;
- required verification/reconciliation evidence.

If no existing repair mode can express this safely, implement only the minimum deterministic recovery entrypoint necessary to bootstrap this one closure, under the same bindings above. That recovery entrypoint must not become an alternate normal mutation path.

While in repair mode:

- ordinary unrelated Agent_X mutations remain blocked;
- neither current code nor disputed semantic state automatically wins;
- canonical state is not declared `SYNCED` merely to enable the repair;
- every repair write is recorded against the exact repair transaction;
- successful completion must transition back into the normal canonical semantic-first lifecycle.

After closure:

- revoke/disable any temporary repair authority;
- prove it cannot be used to bypass semantic-first in normal `SYNCED` operation;
- retain only a deliberately governed future recovery path if the architecture genuinely requires one.

---

# 2. Repair canonical test isolation first

The semantic tests must never mutate real canonical semantic state.

The current test suite includes calls into Harvest reconciliation helpers that can write:

- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`

This must be fixed before any further reconciliation is trusted.

## Required behavior

All semantic/reconciliation tests must run against isolated temporary repositories or isolated temporary semantic state roots.

Tests must not modify:

- real `semantic_project/project_model.json`
- real `semantic_project/semantic_code_sync.json`
- real canonical change history
- real conflict history
- real runtime state
- real accepted baselines

## Required test fixture model

Use isolated temporary repository/workspace fixtures that contain only the minimum files needed for each test.

Where tests need a project model or synchronization baseline:

- copy/create it inside the temp workspace;
- bind code under test to that isolated workspace/state root;
- ensure production functions receive explicit workspace/state paths;
- do not rely on global repository constants when testing mutation/reconciliation.

If a production helper cannot be tested without touching global canonical state, refactor it minimally so its repository/state root can be injected.

Do not create test-only production architecture.

## Required anti-pollution proof

Before running the semantic test suite:

1. hash/capture canonical semantic files;
2. run the tests;
3. hash/capture them again;
4. assert byte-for-byte equality.

This must include at minimum:

- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`

If canonical history/conflict directories exist, verify they are unchanged too.

A test named "no pollution" that merely loads a model twice is not sufficient.

---

# 3. Restore canonical semantic model completeness

The canonical project model must not remain:

`semantic_generation_status = incomplete`

for accepted normal operation.

Use the existing governed LLM semantic enrichment system.

Do not replace deterministic discovery.

The required model lifecycle is:

`deterministic source discovery`
→ `governed LLM architectural enrichment`
→ `validation against deterministic evidence`
→ `semantic_generation_status = complete`

The LLM must provide architectural meaning.

Deterministic discovery remains authoritative for exact facts.

## Fail-closed rules

If governed semantic enrichment fails, is unavailable, produces invalid structure, or contradicts deterministic facts:

- do not mark the model complete;
- do not mint `SYNCED`;
- do not allow write-capable project mutation that depends on unresolved architecture.

Do not silently fall back to structural heuristics as final semantic truth.

## Bootstrap, incremental refresh, and stable semantic identity

The repaired system must preserve the existing whole-project semantic architecture, not merely make the current model complete once.

### Initial bootstrap

If canonical semantic state is genuinely absent:

- deterministic discovery must establish exact repository facts;
- the governed LLM must generate/enrich architectural meaning before the model is accepted;
- an un-enriched structural model may exist as intermediate evidence only;
- no write-capable architectural change may be authorized from structural-only fallback state.

### Incremental refresh

After ordinary localized implementation changes:

- determine the affected semantic subgraph from exact bindings and impact;
- re-discover changed deterministic facts;
- run governed LLM reinterpretation on the affected semantic scope;
- validate those claims against exact evidence;
- avoid whole-repository LLM reinterpretation unless architectural boundaries genuinely changed.

The bootstrap and reconciliation paths must use the same semantic meaning rules. They must not produce two incompatible forms of semantic truth.

### Stable identities

Semantic entity IDs must remain stable across:

- file moves;
- symbol renames;
- module splits/merges;
- behavior-preserving refactors;
- replacement of implementation while responsibility remains the same.

Path names may be bindings, not the sole semantic identity.

A behavior-preserving refactor must not create a brand-new conceptual capability merely because its file path changed.

## Whole-project semantic coverage

Before declaring the semantic-first foundation complete, prove that the canonical model is a whole-project model rather than a repaired Harvest subset.

Repository discovery must be repo-wide and must not depend on a hard-coded package/module list as the definition of Agent_X.

All behavior-affecting project surfaces must be represented through exact facts/bindings and semantic meaning as applicable, including:

- Python/runtime source;
- frontend TypeScript/JavaScript/TSX/JSX and behavior-affecting UI code;
- prompts and prompt templates;
- configuration that changes behavior;
- schemas/contracts/data models;
- MCP/tool registrations;
- REST/API surfaces;
- CLI entrypoints;
- provider/runtime adapters;
- governance/security/mutation enforcement;
- persistence/state models;
- important algorithms/protocols;
- tests as evidence/verification bindings where relevant;
- external interfaces/boundaries that affect architecture.

Not every file must become a conceptual capability. But every behavior-affecting artifact must either:

- bind into the relevant semantic entity/relationship/interface/invariant; or
- be explicitly classified as derived/non-architectural evidence with a defensible reason.

Do not treat documentation, caches, generated outputs, or test debris as architecture merely because they are tracked files.

## Deletion, replacement, and supersession

The model must remain truthful when implementation is removed or replaced.

When code is deleted/replaced:

- remove or supersede stale source bindings;
- preserve semantic identity if the same responsibility continues under a new implementation;
- mark semantic entities superseded/removed when the responsibility itself disappears;
- update consumers/interfaces/dependencies;
- verify old implementation is no longer live/reachable where replacement requires exclusivity;
- do not accumulate duplicate legacy/current ownership merely to preserve history.

Historical evidence may remain historical, but stale bindings must not remain `current`.

## Semantic ownership and relationship quality

For accepted current architecture:

- every material responsibility should have one clear canonical owner or an explicit justified shared/ambiguous ownership state;
- semantic relationships must describe architectural meaning, not simply mirror raw import/call adjacency;
- duplicate-looking implementations must be distinguished as true duplication, extension, compatibility boundary, alternative implementation, or separate responsibility;
- unresolved ownership must remain unresolved rather than being arbitrarily assigned from directory names.

---

# 4. Convert `/api/chat` from authorization checker to actual semantic-first entrypoint

The normal Agent_X UI must be able to receive an ordinary user request such as:

`implement this feature`

and automatically perform semantic-first.

The current behavior must not be:

`user prompt`
→ `check whether some semantic authorization already exists`
→ deny if none exists.

The required behavior is:

`user prompt`
→ determine whether request may mutate project
→ run canonical semantic-first workflow
→ create exact semantic change transaction
→ obtain semantic authorization
→ dispatch coding runtime
→ enforce authorization at mutation boundary
→ verify implementation
→ enrich semantic current state
→ reconcile
→ accepted synchronized baseline

## One canonical execution seam

Do not implement a separate UI-only semantic pipeline.

The UI should invoke/reuse the same canonical semantic-first machinery already used by governed Agent_X changes.

Provider/runtime selection must occur inside or after the semantic-first governed flow as architecturally appropriate.

OpenCode, Codex, LLM7, or future write-capable runtimes must not have different semantic-first rules.

## A coding runtime finishing is not the end of the Agent_X run

For a material change, provider/runtime completion is only the implementation phase.

The Agent_X run must not enter a terminal successful/accepted state merely because OpenCode, Codex, LLM7, or another coding runtime returned successfully.

Before the run can be accepted as successful:

1. capture the exact resulting implementation revision/source snapshot;
2. verify the result against the exact semantic target and required evidence;
3. run affected-scope semantic enrichment against the actual result;
4. reconcile target, actual implementation, and resulting semantic current state;
5. promote canonical semantic state and synchronized baseline transactionally.

If implementation succeeds but verification/reconciliation fails:

- the run is not accepted as complete;
- canonical semantic state is not advanced;
- the failure remains recoverable as a pending/failed transaction or conflict;
- further ordinary mutation must not silently proceed over it.

---

# 5. Eliminate heuristic write-intent as an authority boundary

`_is_write_operation()` may remain as a routing optimization.

It must **not** be the security/authority decision that determines whether semantic-first can be bypassed.

The current principle must be enforced:

> A write-capable runtime does not receive project mutation authority merely because a natural-language heuristic classified the prompt as read-only.

## Correct architecture

Separate:

### Conversational/read-only execution

If the execution environment is truly read-only and exposes no project mutation capability, a lightweight path is allowed.

### Write-capable execution

If the selected runtime/tooling can mutate Agent_X, then one of the following must be true:

- semantic-first transaction exists and authorizes the run; or
- the runtime is placed in a technically enforced read-only mode where project mutation is impossible.

Do not trust language classification alone.

## Ambiguous prompts

If intent is ambiguous and the downstream runtime has write capability:

- either create/resolve semantic intent through the governed semantic path;
- or force the runtime into read-only execution.

Do not allow mutation rights based on a negative keyword heuristic.

## Semantic target transaction contract

Every material proposed change must have a durable semantic target transaction before implementation authority is granted.

The transaction must bind, as applicable:

- unique change ID;
- repository identity;
- workspace identity;
- branch/base implementation revision;
- base semantic revision;
- accepted synchronization baseline digest;
- original request identity/digest;
- affected semantic entities;
- affected capabilities/responsibilities;
- architectural owner/placement;
- implementation-mode decision for each affected responsibility;
- rationale for each mode decision;
- semantic target changes;
- expected files/symbols/interfaces;
- read set;
- exact or bounded write set;
- dependencies/data-flow effects;
- invariants;
- governance/security constraints;
- compatibility/replacement decision where existing behavior is affected;
- verification requirements;
- conflict binding when applicable;
- transaction/target digests;
- lifecycle state.

A parsed LLM answer is not itself a transaction. The target must be normalized, validated, evidence-bound, and durable.

## Current state and target state must remain separate

Do not overwrite the accepted current semantic model with a proposed target before implementation succeeds.

The states are distinct:

- **current accepted semantic state** = what the accepted implementation actually does;
- **target/proposed semantic state** = what this exact transaction intends the implementation to become;
- **resulting semantic state** = semantic description of the verified implementation result after reconciliation.

A target overlay may authorize implementation, but it does not become accepted current truth until exact verification and reconciliation succeed.

## Legitimate no-change/rejection outcome

Semantic-first may determine that a requested material change should not be implemented because it is redundant, harmful, architecturally wrong, unsupported, valueless, or already satisfied.

That must be a first-class outcome:

- record the semantic decision/rationale as appropriate;
- grant no project mutation authority;
- do not fabricate an implementation merely because the user used an imperative verb;
- do not mark a no-op as an implementation success if no change was authorized.

---

# 6. Bind semantic authorization to the actual UI run

Semantic authorization must not be a generic repository-level permission.

For each write-capable UI request, the authorization must bind to the exact run.

At minimum bind:

- run ID;
- workspace root;
- workspace epoch if applicable;
- semantic change ID;
- overlay/transaction digest;
- semantic project-model revision;
- accepted synchronization baseline digest;
- semantic target digest;
- authorized write set;
- request identity or equivalent request binding;
- conflict ID/digest when resolving a conflict.

The coding runtime must receive only the authority belonging to that exact run.

Do not allow an unrelated old semantic transaction to authorize a new prompt.

Do not use wildcard target `"*"` as sufficient mutation authorization unless the underlying transaction explicitly and validly authorizes that exact scope.

Prefer exact paths or governed computed write scope.

## Concurrent and overlapping requests

Authorization must remain correct when multiple Agent_X runs exist concurrently.

Two simultaneous or overlapping write-capable runs must never:

- reuse each other's change ID;
- consume each other's overlay;
- inherit another run's write set;
- validate against the wrong base semantic revision;
- reconcile against another run's implementation result;
- overwrite one global mutable target document.

Each real change requires its own durable transaction identity and immutable base binding.

If two changes overlap semantically or in write scope, use the existing conflict/staleness machinery. Do not silently let last-writer-wins become architecture.

## Authorization lifetime and revocation

Semantic mutation authority must have an explicit lifecycle.

It is valid only for the bound transaction/run/result lifecycle and must cease to authorize writes when the transaction becomes:

- accepted;
- rejected;
- failed;
- rolled back;
- superseded;
- stale;
- conflicted;
- cancelled.

A previously valid change ID/token/overlay must not remain reusable as standing repository write permission.

Provider/tool write capability granted for one run must be revoked or rendered invalid at terminal state.

Do not rely only on callers remembering not to reuse old authorization. Enforce terminal-state invalidation at the canonical authorization boundary.

---

# 7. Ensure the mutation boundary remains the final authority

Fixing `/api/chat` is necessary but not sufficient.

Every actual project mutation must independently validate semantic authorization.

The mutation chokepoint must validate:

- active change ID;
- active overlay/transaction;
- overlay digest;
- run identity;
- workspace identity;
- synchronized base revision;
- semantic model revision;
- exact write scope;
- target validity;
- transaction freshness;
- non-rejected/non-superseded status;
- conflict-resolution binding where applicable.

This must protect mutations originating from:

- OpenCode;
- Codex;
- LLM7 if it can write;
- internal code generation;
- patch execution;
- fuzzy edit;
- autonomous repair;
- Harvest;
- Evolution;
- MCP;
- REST;
- CLI;
- generated code;
- assimilation;
- subagents.

Do not create a second mutation authorization protocol.

Reuse the existing canonical semantic authorization mechanism.

## Revalidate immediately at effect time

Authorization at request-planning time is not enough.

Immediately before each protected mutation or atomic mutation batch, revalidate the transaction against the current:

- workspace/repository identity;
- base/current implementation revision;
- semantic revision/baseline;
- transaction status;
- authorized write scope;
- target digest;
- conflict state.

If the repository or semantic base changed after authorization but before the write, treat the authorization as stale and block/re-resolve.

This closes time-of-check/time-of-use races between concurrent agents, external edits, and delayed provider actions.

## Cover direct shell, Git, subprocess, and provider-tool effects

The mutation boundary must cover actual effects, not just Agent_X's preferred Python write helpers.

Audit and close bypasses involving at minimum:

- shell/terminal commands that can create, edit, move, or delete repository files;
- `git apply`, `git checkout`, `git restore`, `git mv`, commits, rebases, resets, merges, cherry-picks, or equivalent project-changing Git actions;
- subprocesses launched by coding runtimes;
- editor/file tools exposed by OpenCode or Codex;
- patch/fuzzy-edit utilities;
- generated scripts subsequently executed against the repository;
- provider callbacks that grant tool/write permission;
- direct writes to configuration, prompts, schemas, semantic files, tests, or source.

Opaque shell commands that cannot be proven read-only must not receive project mutation authority outside the semantic transaction.

If a provider executes in an external process that cannot be intercepted at each syscall, enforce its write capability through a controlled workspace/sandbox/permission boundary such that unauthorized repository changes cannot become accepted project state. Detect and reject any resulting out-of-band drift before further mutation.

## Canonical semantic state is itself governed project state

Direct edits to:

- `semantic_project/project_model.json`;
- `semantic_project/semantic_code_sync.json`;
- canonical semantic change/history records;
- accepted conflict-resolution state;

are themselves material Agent_X mutations.

They must not be a backdoor around semantic-first. A semantic-only edit must either occur through an authorized semantic transaction or be detected as `SEMANTIC_AHEAD`/conflict before further work.

Neither a human edit nor an external coding agent may silently change semantic authority and then have that new state treated as accepted truth.

---

# 8. Make stale-backend enforcement truly fail-closed

Current stale-backend protection must not silently continue when revision binding/checking fails.

At startup:

- compute the authoritative implementation/enforcement revision;
- bind it successfully;
- if binding fails, mark write-capable operation unavailable.

Do not simply `except: pass`.

Before every write-capable run:

- compute current enforcement/runtime revision;
- compare against startup binding;
- if mismatch: block and require restart;
- if current revision cannot be determined: block write-capable operation;
- if no startup binding exists: block write-capable operation.

These states must not authorize writes:

- `not_yet_bound`
- `empty_revision`
- `implementation check failed`

Read-only behavior may remain available.

## Scope of revision binding

The digest/revision must cover at least the source that controls:

- semantic-first interception;
- mutation authorization;
- API/runtime dispatch;
- governed workflow checkpoints;
- Borg failure policy;
- synchronization/reconciliation;
- provider execution authority.

A broad repository source snapshot is acceptable if already reliable.

Do not use timestamp age.

---

# 9. Require true semantic-first success in Borg dependencies

`semantic_first` is now correctly classified as non-degradable mandatory authority.

Keep that.

But downstream dependency/coherence rules must require actual semantic success.

The current form:

`reject only if dependency verdict == BLOCKED`

is insufficient.

For the `semantic_first` dependency, downstream checkpoints must require an actual PASS-equivalent authorized result.

The following must never satisfy semantic-first dependency:

- `DEGRADED`
- `NOT_APPLICABLE`
- missing result
- incomplete result
- unknown verdict
- failed-but-not-BLOCKED custom state

At minimum:

`provider_planning`

must execute only after semantic-first returns valid PASS authorization.

Because mutation transitively depends on provider planning, this closes the downstream path.

If other checkpoints directly consume semantic authority, enforce PASS there too.

Do not broadly change unrelated Borg failure semantics.

---

# 10. Do not count DEGRADED semantic-first as completion anywhere

Audit every place in Borg/orchestration that treats:

`DEGRADED`

as success.

Generic degradable checkpoints may keep that behavior where intended.

But `semantic_first` must never be included in:

- successful completion counts;
- settled-success dispatch state;
- wave success;
- consensus success;
- prerequisite success;
- final run success;

unless its verdict is a genuine PASS-equivalent semantic authorization.

Avoid checkpoint-name special cases scattered throughout the code if a clean mandatory-authority rule can encode this centrally.

---

# 11. Finish Harvest semantic truth using the canonical pipeline

Do not return to the old hand-authored "accept all Harvest modules" reconciliation.

The current `reconcile_harvest.py` should remain evidence-gathering only or be removed if no longer needed.

It must not mint canonical `SYNCED`.

Use canonical semantic-first reconciliation to finish Harvest state.

The canonical Harvest semantic representation must be built from:

- deterministic implementation evidence;
- governed LLM architectural enrichment;
- verified bindings;
- provenance/confidence;
- real relationships;
- real responsibility ownership.

Do not claim stronger evidence than exists.

## Current Harvest state handling

If any Harvest capability remains unresolved:

- represent it accurately;
- do not mint `SYNCED` if unresolved meaning affects accepted semantic/code equivalence.

If a previously missing `_hp_*` production module has since been restored, verify actual runtime/import behavior rather than trusting metadata.

---

# 12. Complete semantic provenance and confidence correctly

Maintain the distinction:

- `verified` = exact deterministic evidence directly proves it;
- `inferred` = governed LLM architectural interpretation supported by evidence;
- `unknown` = insufficient evidence;
- `unresolved` = known incompleteness;
- `conflicted` = active disagreement.

Do not mark responsibility ownership or architectural purpose `verified` merely because a module imports.

Do not let generated semantic descriptions self-certify.

## Unknown dynamic behavior must remain unknown

Static discovery cannot always resolve behavior created through:

- reflection;
- dynamic imports;
- plugin/provider registration;
- runtime-generated symbols;
- configuration-driven dispatch;
- MCP/tool discovery;
- monkey-patching or late binding.

Where exact behavior cannot be proven, represent the uncertainty explicitly.

Do not turn "not statically observed" into a `verified` claim that the relationship/capability does not exist.

The governed LLM may infer architectural meaning from bounded evidence, but unresolved exact facts remain `unknown`/`unresolved` rather than fabricated certainty.

## One canonical semantic authority

There must be one canonical accepted semantic truth for the project.

Existing retrieval/vector/index structures such as `tools/agentx_evolve/semantic/` may provide derived search/retrieval acceleration, but they must not become an independently writable competing semantic authority.

Derived semantic/index state must be rebuildable from canonical semantic state plus exact implementation evidence.

If a derived index disagrees with canonical semantic state, it is stale derived data; it cannot silently redefine architecture.

## Preserve the full future drift/conflict protocol

The system must remain correct after this repair when future out-of-band changes occur.

Use the existing merge-style semantic/code conflict architecture with a common accepted base.

At minimum distinguish and handle:

- `SYNCED`;
- `IMPLEMENTATION_AHEAD`;
- `SEMANTIC_AHEAD`;
- `BOTH_DIVERGED`;
- `PARTIAL_IMPLEMENTATION`;
- `STALE_BASE`;
- `UNRESOLVED_CONFLICT`.

Conflict resolution must compare:

1. last accepted synchronized semantic state;
2. last accepted synchronized implementation/source state;
3. current semantic state;
4. current implementation state.

Never resolve by a blanket rule such as:

- code wins;
- semantic state wins;
- newest timestamp wins;
- Git HEAD wins;
- regenerate semantic model from code and declare success.

The governed semantic reasoner may propose a merged target, but exact source facts and governance authority remain deterministic.

An unresolved conflict must block ordinary mutation except an explicitly bound conflict-resolution transaction.

---

# 13. Replace the current EVIDENCE_GATHERED baseline with a real canonical reconciliation

The current canonical state must not finish as:

`EVIDENCE_GATHERED`.

That is an intermediate evidence state only.

After all fixes:

1. deterministic source facts refresh;
2. governed LLM semantic enrichment completes;
3. semantic target is validated;
4. actual implementation is verified;
5. canonical semantic current state is reconciled to implementation;
6. bidirectional comparison proves equivalence;
7. canonical synchronization baseline is minted through the canonical reconciliation path.

The final baseline must have:

- `status = SYNCED`;
- real accepted change ID;
- real accepted target digest;
- real implementation revision;
- real semantic revision;
- real verification digest;
- real verification revision;
- real reconciliation revision;
- valid baseline digest;
- exact source-hash/binding evidence.

No placeholder value such as:

`accepted_target_digest = "test"`

may exist in canonical state.

Do not manually edit the JSON to force success.

## Exact verification must precede reconciliation

Verification is not equivalent to "tests passed".

For the exact target transaction and exact resulting implementation revision, verify all applicable dimensions:

- authorized files and no unauthorized files;
- expected symbols/classes/functions;
- interfaces/APIs;
- schemas/contracts;
- dependencies and data flow;
- invariants;
- governance/security requirements;
- prompt/config behavior where changed;
- required tests;
- behavioral acceptance criteria;
- replacement/removal obligations;
- UI/API wiring where applicable;
- target semantic responsibilities and implementation-mode decision.

Verification evidence must bind the exact:

- change ID;
- target digest;
- base revisions;
- resulting implementation revision;
- workspace/run;
- verification requirements.

A verification object from another result revision, another run, or an earlier implementation attempt cannot certify the current result.

Verification authorization/evidence that is intended to be single-use must not be replayable to certify later mutations.

Reconciliation must consume valid verification; it must never manufacture its own proof that the implementation is correct.

---

# 14. Make canonical state writing transactional

Canonical semantic writes must occur only after successful verification/reconciliation.

Avoid the sequence:

`write project_model`
→ later discover failure.

Prefer:

`build candidate model in isolated transaction state`
→ validate
→ verify implementation
→ reconcile
→ atomically promote accepted model + sync baseline.

If promotion fails halfway:

- preserve previous accepted canonical state;
- keep repair transaction evidence separately;
- do not leave partially updated canonical files.

Reuse existing atomic persistence utilities.

Do not build a second transaction system.

## Failure, crash, and restart recovery

The lifecycle must remain correct if Agent_X stops at any point.

Handle at minimum interruption after:

- target transaction creation but before code mutation;
- some authorized writes but before implementation completion;
- implementation completion but before verification;
- verification but before semantic enrichment;
- semantic enrichment but before canonical reconciliation/promotion;
- first canonical file write during promotion.

On restart, Agent_X must be able to determine from durable state whether the transaction is:

- pending and safely resumable;
- stale and requires redesign/conflict resolution;
- partially implemented;
- verified but not reconciled;
- failed and requires rollback/repair;
- accepted.

Never infer acceptance from the mere presence of generated files or a Git commit.

A resumed transaction must bind the same exact base/target/result evidence or be explicitly invalidated/rebased through the semantic conflict protocol.

Rollback, where used, must itself be verified against the intended accepted state.

## Canonical history and artifact hygiene

Canonical accepted semantic history must represent real accepted project changes only.

Do not allow canonical history/baselines to be polluted by:

- tests;
- proofs;
- fixtures;
- synthetic prompts;
- dry runs;
- temporary workspaces;
- diagnostics;
- intermediate LLM map/reduce artifacts;
- debug files;
- runtime caches.

Test and temporary state roots must be explicit and isolated. There must be zero fallback from an isolated test run into the real canonical semantic root.

Source snapshots used for synchronization must have an explicit definition of project-affecting state. Rebuildable runtime noise must not create false architectural drift, while behavior-affecting prompts/config/schemas/frontend/source must not be omitted. Preserve exact reproducibility of whatever snapshot definition is chosen.

---

# 15. Required real tests

The final test suite must validate production behavior, not just function existence.

All tests must use isolated state and must prove no canonical pollution.

## A. UI write request creates semantic transaction

Submit an ordinary request equivalent to:

`implement a small feature`

through the real `/api/chat` entrypoint using a controlled test runtime/provider.

Prove ordering:

1. semantic-first invoked;
2. semantic transaction created;
3. target validated;
4. only then coding runtime receives write authority.

A pre-existing semantic transaction must not be required.

## B. UI read-only request

Submit a true read-only request through a technically read-only execution path.

Verify:

- no meaningless change transaction;
- no project mutation authority;
- response allowed.

## C. Ambiguous request + write-capable runtime

Use a prompt that the keyword heuristic may classify read-only but a coding runtime could act on.

Expected:

- no ungoverned mutation authority;
- semantic-first or enforced read-only mode.

## D. Old unrelated transaction

Create a valid semantic transaction for request A.

Then submit request B.

Expected:

transaction A cannot authorize B.

## E. Wrong write set

Valid transaction exists, but runtime attempts to write outside authorized scope.

Expected:

blocked.

## F. Missing semantic authorization

Directly invoke OpenCode/Codex/write-capable adapter without semantic transaction.

Expected:

blocked.

## G. Semantic-first failure

Force provider/enrichment/target failure.

Expected:

hard `BLOCKED`.

No coding runtime dispatch.

No mutation.

## H. Borg dependency

Create a non-PASS semantic-first result.

Expected:

provider planning does not run.

Mutation path does not run.

## I. Stale backend

Start backend against implementation revision A.

Change semantic/governance/mutation runtime code on disk to revision B.

Attempt write-capable request using still-running A.

Expected:

restart required.

No runtime dispatch.

No mutation.

## J. Missing startup binding

Simulate startup revision binding failure.

Expected:

write-capable requests blocked.

## K. Revision-check failure

Cause current-revision computation to fail.

Expected:

write-capable request blocked.

## L. Restart

Restart against current source.

Expected:

normal semantic-first governed write path resumes.

## M. Canonical pollution

Hash canonical semantic artifacts.

Run every semantic-first/Harvest reconciliation test.

Hash canonical artifacts again.

Expected:

byte-for-byte unchanged.

## N. False SYNC regression

Create semantic model with a nonexistent public API or incorrect binding.

Expected:

canonical reconciliation refuses `SYNCED`.

## O. Semantic-generation incomplete

Attempt canonical synchronization with:

`semantic_generation_status = incomplete`

Expected:

blocked.

## P. Full round trip

Starting from valid synchronized state:

`user write request`
→ semantic interpretation
→ implementation-mode decision
→ semantic target
→ implementation
→ verification
→ semantic enrichment
→ reconciliation
→ canonical promotion
→ `SYNCED`

Verify exact transaction/baseline binding end to end.

## Q. Out-of-band implementation drift

Start from `SYNCED`, change implementation outside semantic-first, then submit an ordinary write request.

Expected:

- `IMPLEMENTATION_AHEAD` detected before ordinary target design;
- ordinary mutation blocked or converted into the exact governed conflict-resolution flow;
- code is not silently accepted as semantic truth.

## R. Out-of-band semantic drift

Start from `SYNCED`, alter canonical semantic meaning outside an authorized transaction.

Expected:

- `SEMANTIC_AHEAD` detected;
- semantic edit cannot self-authorize;
- ordinary mutation cannot continue until conflict resolution.

## S. Both sides diverged

Change semantic and implementation independently from the same accepted base.

Expected:

- `BOTH_DIVERGED`;
- neither side automatically wins;
- resolution transaction binds the exact recorded conflict.

## T. Partial implementation and stale base

Exercise:

- only part of an authorized semantic target implemented;
- target based on an old semantic/source baseline.

Expected:

- `PARTIAL_IMPLEMENTATION` and/or `STALE_BASE` as appropriate;
- no acceptance/promotion.

## U. Initial semantic bootstrap

Use an isolated repository with no semantic model.

Expected:

- deterministic discovery runs;
- governed LLM enrichment runs;
- structural fallback alone cannot authorize architecture;
- accepted model becomes complete only after validated enrichment.

## V. Incremental semantic refresh

Make one localized accepted change.

Expected:

- affected scope is reinterpreted;
- unrelated semantic identities remain stable;
- whole-project reinterpretation is not required without architectural-boundary change.

## W. Refactor identity stability

Move/rename/split implementation while preserving behavior and responsibility.

Expected:

- stable semantic identity retained where meaning is unchanged;
- bindings update;
- deterministic behavior verification + governed semantic-equivalence reasoning required before rebaseline.

## X. Concurrent transaction isolation

Run two write-capable semantic transactions concurrently, including one overlapping-write case.

Expected:

- unique change IDs and overlays;
- no cross-authorization;
- no shared mutable target overwrite;
- overlap becomes staleness/conflict rather than last-writer-wins.

## Y. Direct shell/Git bypass attempts

Attempt repository mutation through shell, Git, subprocess, patch, and provider tool channels without valid semantic authorization.

Expected:

- blocked at the effect boundary where enforceable; or
- quarantined/detected as out-of-band drift and never accepted as synchronized state.

## Z. Semantic-file direct edit bypass

Directly modify canonical semantic files outside a transaction.

Expected:

- detected as semantic drift/conflict;
- cannot authorize implementation;
- cannot be promoted merely by recomputing hashes.

## AA. No-change/reject semantic decision

Submit a material-sounding request that semantic reasoning determines should not be implemented.

Expected:

- explicit no-change/reject decision with rationale;
- no write authorization;
- no fabricated code change;
- canonical implementation remains unchanged.

## AB. Exact verification binding and replay rejection

Produce verification for implementation result R1, then modify the result to R2 or attempt to reuse the verification in another run.

Expected:

- stale/replayed verification rejected;
- reconciliation cannot accept R2 using R1 evidence.

## AC. Interrupted transaction recovery

Crash/restart at each major lifecycle boundary: target-only, partial writes, implementation-before-verify, verified-before-reconcile, and promotion-in-progress.

Expected:

- no false accepted state;
- durable lifecycle state correctly identifies recovery action;
- safe resume/rollback/conflict path;
- canonical baseline advances only after complete success.

## AD. UI terminal-success ordering

Allow the coding provider to return success while forcing post-code verification or reconciliation to fail.

Expected:

- UI/Agent_X run is not reported as successfully completed/accepted;
- canonical sync state does not advance;
- failure is visible and recoverable.

## AE. Derived semantic index disagreement

Corrupt or stale a derived semantic retrieval/index representation while leaving canonical model and implementation intact.

Expected:

- derived state is rebuilt/rejected as stale;
- it cannot become canonical architectural truth or authorize mutation.

## AF. Authorization revocation/reuse

Complete, reject, cancel, fail, supersede, or roll back a transaction, then try to reuse its previous semantic authorization for another write.

Expected:

- authorization rejected in every terminal/stale state;
- provider/tool write capability from the old run cannot be reused.

## AG. TOCTOU stale authorization

Create a valid semantic target, then change the repository or semantic base before the authorized write executes.

Expected:

- effect-time revalidation detects stale base;
- write blocked;
- transaction enters redesign/conflict handling rather than writing against a changed base.

## AH. Mutation-origin matrix

Exercise at least one real project-changing path through each applicable origin:

- normal UI/OpenCode;
- Codex;
- LLM7 if write-capable;
- CLI/self-upgrade;
- REST/API mutation endpoint;
- MCP/tool invocation;
- autonomous repair/Borg loop;
- Harvest implementation/promotion;
- Evolution/self-modification;
- subagent/generated-code path.

Expected for every applicable origin:

`semantic-first target` → `authorized mutation` → `verification` → `semantic enrichment` → `reconciliation`.

No origin may rely solely on a later drift detector as its normal authorization path. Drift detection is defense-in-depth for truly out-of-band changes, not the intended mutation workflow.

## AI. Whole-project coverage audit

Run deterministic discovery over the actual repository and compare it to canonical semantic bindings.

Expected:

- every behavior-affecting project surface is represented or explicitly/explainably classified as non-architectural/derived evidence;
- frontend/prompts/config/schemas/API/MCP/CLI/provider/governance surfaces are not silently omitted;
- coverage does not depend on a hard-coded Harvest/package list;
- deleted files are not retained as current bindings.

## AJ. Delete/replace lifecycle

Delete or replace an implementation while preserving, changing, and removing responsibilities in separate cases.

Expected:

- stable semantic identity retained when responsibility is unchanged;
- old bindings superseded/removed;
- removed responsibility no longer marked current;
- replacement does not leave two accidental canonical owners;
- consumers/interfaces update correctly.

## AK. Ownership/relationship semantic quality

Use a fixture where import adjacency differs from architectural ownership and where two similar implementations serve different roles.

Expected:

- semantic ownership follows evidence + governed interpretation, not package/file names;
- relationships reflect actual meaning rather than raw imports;
- unresolved ambiguity remains explicit instead of fabricated certainty.

## AL. Recovery-mode containment

Start from a deliberately disputed/incomplete semantic-first state that requires repair of semantic-first itself.

Expected:

- the narrowly bound recovery/conflict transaction can perform only the authorized repair;
- unrelated mutations remain blocked;
- recovery authority is bound to exact workspace/base/request/write set;
- recovery mode cannot self-mint `SYNCED`;
- after successful closure, normal semantic-first becomes authoritative again;
- the repair authorization cannot be reused for a later ordinary change.

---

# 16. Test evidence must be real

Do not call a test complete merely because:

- a helper function exists;
- an enum contains the expected value;
- a source line contains a gate;
- an import succeeds;
- a fixture says `SYNCED`.

Tests must exercise the production path.

For example:

Bad proof:

`assert callable(_check_semantic_first_authorization)`

Good proof:

- POST actual write request into API route;
- instrument semantic checkpoint/provider;
- prove it ran before runtime dispatch;
- prove runtime dispatch is absent when semantic-first blocks.

Bad proof:

`assert semantic_first not in degradable categories`

Good proof:

- force semantic-first exception;
- run Borg workflow;
- prove downstream checkpoints do not execute.

---

# 17. Read-only vs write-capable must be enforced by capability, not prose alone

The safest architecture is:

- truly read-only runtime/tools may answer without mutation transaction;
- any runtime with project-write capability is governed by semantic-first before write authority is available.

If Agent_X wants to answer code questions through OpenCode/Codex without semantic overhead:

- invoke that runtime in a technically enforced read-only mode;
- do not merely trust the prompt classifier.

This preserves fast read-only UX without creating a semantic-first bypass.

---

# 18. Prompt-only / prompt-driven / deterministic-code decisions must remain automatic

For every material change, the semantic-first target must determine which responsibilities should be:

- prompt-only;
- prompt-driven with deterministic enforcement;
- deterministic-code-driven.

Do not force all future changes into code.

Do not force all future changes into prompts.

Preserve the architecture principle:

`semantic reasoning decides the implementation form`

while:

`deterministic enforcement protects exact authority/invariants`.

---

# 19. Final fresh audit

After implementation and tests, perform a fresh audit from the actual current `main`.

Do not use the implementation report as evidence.

Inspect the real code and canonical files.

Verify:

- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`
- API chat route;
- coding runtime dispatch;
- semantic-first checkpoint;
- Borg dependency logic;
- mutation authorization;
- stale-backend logic;
- test isolation;
- canonical reconciliation;
- initial semantic bootstrap;
- incremental enrichment;
- semantic identity stability;
- conflict/common-base behavior;
- concurrent transaction isolation;
- shell/Git/subprocess mutation channels;
- governance of canonical semantic-file writes;
- canonical history/artifact hygiene;
- current-vs-target separation;
- target transaction completeness;
- exact verification binding/replay resistance;
- interrupted transaction recovery;
- UI terminal-success ordering;
- canonical-vs-derived semantic authority;
- authorization lifetime/revocation;
- effect-time freshness/TOCTOU protection;
- mutation-origin coverage across UI/CLI/REST/MCP/autonomous/Harvest/Evolution/subagents;
- dynamic/reflective behavior uncertainty handling;
- whole-project behavior-affecting coverage;
- deletion/replacement/supersession cleanup;
- canonical ownership and semantic relationship quality;
- safe recovery bootstrap from disputed semantic-first state;
- revocation/containment of any temporary repair authority.

---

# 20. Final completion criteria

Do not stop until every item below is demonstrably true.

1. Canonical tests cannot modify canonical semantic state.
2. Semantic tests prove byte-for-byte no-pollution of all accepted semantic artifacts.
3. Test/proof/dry-run/fixture state has no fallback path into canonical semantic history or baselines.
4. Canonical project model has completed governed LLM semantic enrichment.
5. `semantic_generation_status = complete`.
6. Exact repository facts remain deterministic authority.
7. Architectural purpose, ownership, responsibility boundaries, and semantic relationships are governed LLM meaning with provenance/confidence rather than filename heuristics.
8. Initial bootstrap from no model invokes governed LLM enrichment before architectural authorization.
9. Localized post-change refresh uses affected-scope incremental enrichment by default.
10. Stable semantic IDs survive behavior-preserving file moves/renames/refactors.
11. Ordinary write-capable `/api/chat` requests automatically run semantic-first.
12. A user does not need to pre-create a semantic transaction manually.
13. Semantic authorization is bound to the exact current run/request/workspace/base.
14. Old unrelated transactions cannot authorize new requests.
15. Concurrent runs have isolated change IDs, overlays, targets, write sets, and result bindings.
16. Overlapping concurrent mutations become conflict/staleness, not last-writer-wins.
17. Natural-language write detection is not the mutation-authority boundary.
18. Write-capable runtimes cannot mutate when semantic-first has not succeeded.
19. Read-only requests remain possible only through genuinely read-only authority.
20. OpenCode cannot bypass semantic authorization.
21. Codex cannot bypass semantic authorization.
22. LLM7 cannot bypass semantic authorization if write-capable.
23. Future runtimes inherit provider-independent semantic-first enforcement.
24. Shell/terminal mutation cannot bypass semantic authorization.
25. Project-changing Git operations cannot bypass semantic authorization.
26. Subprocess/provider tool/editor/patch/fuzzy-edit effects cannot become accepted project state without semantic authorization.
27. `semantic_first` remains non-degradable.
28. Borg downstream dependencies require actual semantic PASS authorization.
29. `DEGRADED`, `NOT_APPLICABLE`, missing, or unknown verdicts cannot satisfy semantic-first success.
30. Actual mutation boundary independently validates semantic authorization.
31. Wrong write-set mutation is rejected.
32. Direct canonical semantic-file edits are governed or detected as semantic drift before further mutation.
33. Stale backend revision is detected.
34. Missing revision binding blocks writes.
35. Revision-check errors block writes.
36. Restart restores normal governed writes.
37. Harvest semantic claims reflect actual implementation evidence.
38. LLM semantic claims use correct inferred provenance.
39. No false verified architectural claims remain.
40. One-off Harvest reconciliation cannot self-certify `SYNCED`.
41. Common-base conflict resolution remains functional for `IMPLEMENTATION_AHEAD`.
42. Common-base conflict resolution remains functional for `SEMANTIC_AHEAD`.
43. Common-base conflict resolution remains functional for `BOTH_DIVERGED`.
44. Partial implementation and stale-base states cannot be accepted.
45. Neither code nor semantic state automatically wins a conflict.
46. Ordinary mutation is blocked while unresolved conflict remains, except the exactly bound resolution transaction.
47. Canonical semantic writes are transactionally promoted only after success.
48. Failure during canonical promotion preserves the previous accepted state.
49. Canonical history contains real accepted changes, not synthetic/test/runtime debris.
50. `accepted_target_digest` is real and non-placeholder.
51. Canonical semantic/code baseline is produced through the canonical pipeline.
52. Final `semantic_code_sync.json` status is exactly `SYNCED`.
53. Final implementation revision matches actual current source under the defined synchronization snapshot.
54. Final semantic revision matches actual accepted semantic model.
55. Final verification/reconciliation evidence binds the exact accepted target, implementation result, semantic result, run/change identity, and base revisions.
56. No unresolved conflict remains.
57. No semantic-generation incompleteness remains.
58. No canonical test pollution remains.
59. Production-path tests exercise actual API/workflow/provider/mutation behavior rather than helper existence.
60. Prompt-only / prompt-driven+deterministic / deterministic-code responsibility classification is produced automatically for material changes and carries rationale.
61. A validated durable target transaction exists before implementation authority for every material change.
62. Accepted current semantic state is never overwritten by the proposed target before implementation is verified.
63. Legitimate semantic no-change/reject decisions grant no mutation authority and do not fabricate code changes.
64. Verification covers the exact target and actual resulting implementation, not merely generic tests.
65. Verification evidence is bound to exact run/change/target/result/base revisions and cannot be replayed across results.
66. Reconciliation consumes valid verification and cannot self-certify.
67. Provider/runtime completion alone cannot mark a material Agent_X change accepted; post-code verification and reconciliation must succeed first.
68. Interrupted transactions recover without false acceptance at every lifecycle boundary.
69. Resume/rebase/rollback behavior remains bound to durable transaction/base/target evidence.
70. One canonical semantic authority exists; derived semantic retrieval/index state cannot redefine architecture.
71. Dynamic/reflection/config-driven behavior that cannot be proven remains unknown/unresolved rather than falsely verified absent.
72. Semantic mutation authorization expires/revokes on accepted/rejected/failed/rolled-back/superseded/stale/conflicted/cancelled terminal states.
73. Old transaction authorization cannot be reused as standing repository write permission.
74. Effect-time authorization revalidates current base/revisions/scope and closes TOCTOU drift.
75. UI, CLI, REST, MCP, autonomous repair, Harvest, Evolution, and subagent mutation origins all use the same semantic-first authorization invariant where applicable.
76. Drift detection remains defense-in-depth, not the normal authorization path for in-product mutation origins.
77. Canonical semantic discovery covers the whole behavior-affecting Agent_X project rather than a hard-coded Harvest/package subset.
78. Frontend, prompts, behavior-affecting config, schemas, MCP/REST/CLI interfaces, provider/runtime adapters, governance, state/persistence, and important algorithms/protocols are represented or explicitly classified as non-architectural evidence.
79. Deleted/replaced implementation does not remain bound as current semantic truth.
80. Responsibility-preserving replacement retains stable semantic identity while updating bindings.
81. Removed responsibilities are superseded/removed rather than kept current.
82. Material responsibilities have a clear canonical owner or explicit justified ambiguity/shared ownership.
83. Semantic relationships represent architectural meaning rather than raw import adjacency.
84. A disputed/incomplete semantic-first installation can be repaired only through an explicitly bound recovery/conflict transaction, not unrestricted governance bypass.
85. Recovery authority is scoped to exact workspace/base/request/write set and cannot self-certify `SYNCED`.
86. Temporary repair authority is revoked after closure and cannot authorize later ordinary changes.
87. Governance/security/state/transactions/locks/Git/rollback/promotion/verification/evidence authority remains deterministic and cannot be invented by LLM output.
88. No duplicate semantic/provider/reconciliation/mutation-authority stack was introduced to achieve closure.
89. A fresh no-change recheck returns `SYNCED`.
90. Re-running the complete audit from current `main` finds no material bypass, stale state, false semantic claim, incomplete lifecycle, omitted behavior-affecting surface, uncontained recovery path, or unverified acceptance path.

## Decisive final scenario

After a clean restart, a user opens the normal Agent_X UI and types:

`implement this prompt`

Without the user mentioning semantics, Agent_X must automatically perform:

`request`
→ `semantic model`
→ `governed architectural reasoning`
→ `prompt-only / prompt-driven / deterministic-code decision`
→ `semantic target`
→ `authorized implementation`
→ `verification`
→ `semantic enrichment`
→ `reconciliation`
→ `SYNCED`

At no point may a write-capable runtime modify Agent_X before the semantic target exists and is authorized.

If that statement is not true for the actual production path, continue fixing.

If it is demonstrably true and the canonical state is genuinely `SYNCED`, stop.

At that point the semantic-first foundation is complete.
