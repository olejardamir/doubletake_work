# Agent_X Final Semantic-First Gap Closure Prompt

You are working on the current Agent_X `main`.

At the time this prompt was written, the latest independently audited `main` was:

`3485e010f1712a6bcd8fa603077a314ebd179ad4`

Do not assume that SHA is still current. Start by inspecting the actual current `main`.

## Mission

Close the final proven semantic-first defects and do not stop until the real production path is correct end to end.

Do **not** redesign semantic-first.

Do **not** redo Harvest.

Do **not** perform unrelated cleanup, UI redesign, CI/CD work, GitHub Actions work, broad refactors, or cosmetic edits.

Do **not** assume or introduce a dedicated Architectural MCP. Use Agent_X's existing provider/tool/MCP infrastructure.

Do **not** create parallel semantic-model, provider-routing, Git, mutation-authorization, verification, rollback, or synchronization systems. Reuse and repair the existing canonical stack.

The latest independently proven defects are concrete:

1. `semantic_project/semantic_code_sync.json` says `SYNCED`, but its `implementation_revision` was manually set to a 40-character Git SHA even though canonical synchronization computes implementation revision from the deterministic source snapshot digest. The current marker therefore cannot be trusted as having come from the canonical synchronization path.
2. `api_server.py` performs stale-backend revision binding with `json.dumps(...)` before importing `json`, causing startup binding failure and fail-closed write blockage after clean startup.
3. `/api/chat` invokes `run_semantic_first()` without a governed LLM provider, without a valid run-bound state root, and before the real run ID exists. It therefore cannot produce the valid LLM-backed, run-bound `semantic_first_state.json` required by `require_semantic_authorization()`.
4. Borg dependency coherence still rejects only literal `BLOCKED` dependencies rather than requiring `semantic_first` to have a genuine PASS-equivalent authorization result.

Fix these four proven defects **and re-prove the entire semantic-first contract**, because closing the latest symptoms is not enough to declare the whole task complete. The finished system must also preserve the previously established requirements for conflict recovery, concurrency, authorization lifetime, crash recovery, whole-project semantic coverage, exact verification binding, canonical-state governance, and all mutation origins.

The required invariant is:

> A normal Agent_X UI write request must automatically create a fresh, governed, LLM-backed, run-bound semantic target before any coding runtime obtains mutation authority, and the run must finish by canonical verification/reconciliation producing a genuinely valid `SYNCED` baseline.

---

# 1. Re-audit current main before changing anything

Inspect the actual current implementations of at least:

- `api_server.py`
- `tools/agentx_evolve/api/chat.py`
- `tools/agentx_evolve/api/state.py`
- `tools/agentx_evolve/api/codex_chat.py`
- `tools/agentx_evolve/api/llm7_chat.py`
- `tools/agentx_evolve/providers/opencode_provider.py`
- `tools/agentx_evolve/providers/codex_provider.py`
- `tools/agentx_evolve/semantic_first/interceptor.py`
- `tools/agentx_evolve/semantic_first/pipeline.py`
- `tools/agentx_evolve/semantic_first/project_model.py`
- `tools/agentx_evolve/semantic_first/enrichment.py`
- `tools/agentx_evolve/semantic_first/synchronization.py`
- `tools/agentx_evolve/workflow_governance/checkpoints.py`
- `tools/agentx_evolve/workflow_governance/models.py`
- `tools/agentx_evolve/collective_core/borg_collective_orchestrator.py`
- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`

Do not trust commit messages, AGENTS.md claims, comments, or status strings as proof.

Use actual code behavior and canonical data.

---

# 2. Repair stale-backend startup binding

The backend must successfully bind its implementation revision during normal startup.

Fix import/initialization ordering so every name used in the startup binding block is available before use.

Specifically verify the current `json.dumps(...)` startup bug is eliminated.

## Required behavior

At startup:

1. obtain deterministic current implementation/source snapshot;
2. compute implementation enforcement revision;
3. bind it to the running backend;
4. record binding success;
5. if any of those steps fails, write-capable operation remains fail-closed.

Do not weaken fail-closed behavior.

Do not restore `except: pass`.

## Production proof

After clean backend startup:

- binding must be `bound=True`;
- revision must be non-empty;
- immediate write-capable request must not be rejected merely because startup binding failed.

Then modify a relevant enforcement/runtime source file while the old process remains running.

Expected:

- new write-capable request is blocked;
- restart is required.

Restart against the new source.

Expected:

- binding succeeds;
- normal governed write flow resumes.

---

# 3. Stop using `semantic_project/` as an active UI transaction directory

Canonical semantic state and active per-run transaction state are different things.

`semantic_project/` contains accepted canonical semantic truth.

It must not act as the live state directory for arbitrary UI mutations.

The UI semantic-first transaction must live in the exact run's isolated state directory.

Required separation:

`semantic_project/`
= accepted canonical project model + accepted synchronization baseline

per-run state root
= active semantic target, `semantic_first_state.json`, change overlay, conflict binding, verification evidence, temporary run artifacts

Do not let concurrent UI runs share one `semantic_first_state.json`.

Do not let one user's old transaction authorize another request.

---

# 4. Create the run identity before semantic authorization

The current UI path runs semantic-first before the real run ID exists.

Fix the sequencing.

A write-capable UI request must establish an immutable run identity before semantic target authorization.

The sequence must be logically equivalent to:

1. validate request/workspace;
2. resolve workspace identity/epoch;
3. create or reserve exact run ID;
4. create isolated run state directory;
5. bind request text, workspace, runtime/provider selection, and run ID;
6. execute canonical semantic-first checkpoint/workflow;
7. obtain fresh semantic `change_id` and run-bound authorization;
8. bind authorization to coding runtime;
9. only then permit provider execution/mutation.

It is acceptable to create a provisional run record before semantic-first, provided:

- it has no mutation authority;
- blocked semantic-first runs are recorded as blocked/failed cleanly;
- no orphan active-run state remains.

Do not create the run after semantic authorization.

---

# 5. `/api/chat` must use the governed semantic provider, not `provider=None`

The current UI call into `run_semantic_first()` without `provider=` is invalid for architectural authorization.

Structural fallback cannot authorize project architecture.

For any write-capable UI run, semantic interpretation/design must use the existing governed LLM provider path.

Do not invent a UI-specific provider abstraction.

Reuse the same governed provider resolution used by `SemanticFirstCheckpoint` / workflow governance.

The semantic interpretation path must begin with:

`llm`

for authorization to succeed.

If a governed semantic provider cannot be resolved:

- block the write-capable request;
- do not fall back to structural authorization;
- read-only operation may remain available if technically read-only.

---

# 6. Reuse the canonical SemanticFirstCheckpoint lifecycle

Do not maintain two subtly different semantic-first implementations:

- workflow semantic-first;
- UI semantic-first.

Refactor the UI integration so it invokes the same canonical semantic authority logic used by governed workflow execution.

A shared helper/service is acceptable if it is genuinely the same semantics and state contract.

It must perform:

- accepted sync baseline validation;
- conflict detection;
- conflict-resolution binding when necessary;
- governed provider resolution;
- LLM interpretation;
- target design;
- implementation-mode decisions;
- coherence validation;
- change overlay persistence;
- `semantic_first_state.json` persistence;
- run/workspace binding.

The UI path must not manually approximate only some of these steps.

---

# 7. Create valid run-bound semantic state

A successful pre-implementation UI semantic-first pass must produce a valid `semantic_first_state.json` under the exact run state root.

It must bind:

- `change_id`;
- overlay digest;
- current project-model digest;
- exact run ID;
- exact workspace root;
- current accepted sync baseline digest;
- semantic interpretation;
- semantic target;
- exact write set;
- conflict ID/digest when applicable.

The persisted overlay must have:

- non-empty run ID;
- non-empty workspace root;
- valid source snapshot;
- valid base revision;
- valid base semantic model digest;
- valid target document;
- LLM interpretation path;
- coherent target;
- active status;
- exact write scope.

`require_semantic_authorization()` must succeed for valid authorized targets from that run and fail for unrelated run IDs.

---

# 8. Do not use wildcard authorization as final mutation authority

A wildcard `"*"` check may be used only as a narrow internal existence/preflight check if absolutely necessary.

It must not be treated as proof that any arbitrary mutation is allowed.

The final mutation boundary must still authorize every exact affected path/resource against the transaction's write set.

For external coding runtimes:

- OpenCode;
- Codex;
- LLM7 if it has mutation capability;
- future coding runtimes;

bind the exact run semantic state before execution.

Every permission callback/file effect must validate the exact requested resource.

Opaque shell/command mutation remains denied unless there is a deterministic mechanism that can prove its exact effects before authorization.

Do not weaken current shell fail-closed behavior.

---

# 9. Correct read-only handling without restoring heuristic authority

Do not run expensive semantic mutation transactions for truly read-only chat if the runtime is technically read-only.

But do not use natural-language keyword heuristics as mutation authority.

Correct rule:

- technically read-only execution environment → no semantic change transaction required;
- write-capable execution environment → semantic-first required before write authority exists.

If a write-capable runtime is used for a read-only question, either:

1. put it in enforced read-only mode; or
2. run semantic-first before granting any project-write capability.

Do not trust `_is_write_operation()` alone.

---

# 10. Fix Borg dependency coherence properly

`semantic_first` is a mandatory authority.

Keep it non-degradable.

Fix `_check_wave_coherence()` or the equivalent central dependency validator so that a dependent checkpoint cannot proceed merely because its prerequisite is “not BLOCKED”.

For `semantic_first`, dependency success must require a genuine allowed/pass-equivalent semantic authorization verdict.

These must never satisfy the semantic-first dependency:

- `BLOCKED`
- `DEGRADED`
- `NOT_APPLICABLE`
- missing result
- unknown verdict
- arbitrary custom non-pass value

Do not rely on later wave bookkeeping to catch this after downstream work has already executed.

The dependency gate must prevent execution in the first place.

## Preferred rule

Centralize mandatory-authority dependency evaluation rather than scattering special-case string comparisons.

For a mandatory authority prerequisite:

`dependency result must be in the explicitly accepted pass set`

and must contain any required authorization artifact/state.

For `semantic_first`, also verify semantic-first context state is actually populated.

---

# 11. Fix unreachable/incorrect `NOT_APPLICABLE` handling

Audit the current Borg condition equivalent to:

`if result.verdict not in PASSING_VERDICTS and result.verdict != "NOT_APPLICABLE":`

followed by special handling that tries to reject `semantic_first == NOT_APPLICABLE`.

That special handling is logically unreachable for `NOT_APPLICABLE`.

Correct the logic.

For `semantic_first`:

- `NOT_APPLICABLE` is never success;
- it must block downstream semantic-dependent work.

For other checkpoints, preserve their intended NotApplicableArtifact semantics.

Do not globally break legitimate non-semantic NOT_APPLICABLE handling.

---

# 12. Regenerate the accepted synchronization baseline canonically

Do not manually edit:

- `implementation_revision`;
- `semantic_revision`;
- `reconciliation_revision`;
- `baseline_digest`;
- source hashes;
- status;
- verification fields;

to make the JSON look synchronized.

The accepted baseline must be created through the current canonical synchronization implementation.

The current canonical definition is authoritative.

If `implementation_revision()` is based on the canonical digest of sorted source hashes, the final baseline must use that exact computed value.

Do not substitute Git HEAD SHA for it.

Git commit identity may be separately recorded as evidence if desired, but it is not a replacement for the canonical implementation revision.

---

# 13. Reconcile current code and semantic model through the canonical path

After fixing the code:

1. obtain deterministic source snapshot;
2. refresh exact structural facts;
3. run governed LLM semantic enrichment;
4. ensure `semantic_generation_status = complete`;
5. validate semantic claim provenance/evidence;
6. verify the actual implementation;
7. reconcile semantic current state against actual implementation;
8. call canonical synchronized-baseline construction;
9. persist the accepted model and baseline atomically;
10. re-load both;
11. independently assess synchronization using `assess_synchronization()`.

The final independent assessment must return:

`SyncStatus.SYNCED`

Do not infer success from the stored `"status": "SYNCED"` string.

---

# 14. Final canonical baseline invariants

The accepted final baseline must satisfy all current canonical invariants.

At minimum:

- `status == SYNCED`;
- baseline digest recomputes exactly;
- workspace root is correct;
- semantic revision equals accepted model digest;
- implementation revision equals `implementation_revision(source_snapshot(root))`;
- source hashes exactly equal current deterministic snapshot;
- bindings digest equals current semantic bindings digest;
- accepted change ID is real;
- accepted target digest is real;
- verification digest is real;
- verification revision is real;
- reconciliation revision is produced by the canonical reconciliation semantics;
- semantic generation is complete;
- semantic generation digest recomputes;
- semantic claims have valid governed provenance;
- semantic claims bind to current source evidence.

Then call:

`assess_synchronization(model, root, baseline)`

and require:

`SYNCED`

with no reasons/conflict.

---

# 15. Do not use Git HEAD as semantic or implementation truth

Git SHA is useful evidence, not the semantic synchronization definition.

Do not set fields merely because:

`current HEAD = xyz`.

The synchronization contract decides how revisions are computed.

Respect the current code contract.

If the contract itself is flawed, fix the contract deliberately with tests before generating the baseline.

Do not silently mix revision schemes.

---

# 16. Production test: normal UI write request

This is the decisive test.

Start a clean Agent_X backend.

Submit through the real `/api/chat` route an ordinary request equivalent to:

`implement a small harmless change in an isolated test workspace`

Use a controlled governed provider/runtime.

Prove exact ordering:

1. backend startup revision binding succeeds;
2. run ID is created/reserved;
3. run state root exists;
4. accepted sync baseline is read;
5. governed semantic provider is resolved;
6. LLM semantic interpretation runs;
7. semantic target is designed;
8. `change_id` is created;
9. `semantic_first_state.json` is persisted in the run state root;
10. overlay is bound to exact run/workspace;
11. provider runtime receives semantic authorization;
12. exact mutation target is checked against write set;
13. code mutation occurs;
14. implementation verification runs;
15. semantic enrichment/reconciliation runs;
16. accepted canonical baseline advances;
17. independent `assess_synchronization()` returns `SYNCED`.

A pre-existing transaction must not be required.

---

# 17. Production test: semantic provider unavailable

Start a write-capable request but make governed semantic provider resolution fail.

Expected:

- no target authorization;
- no coding runtime mutation authority;
- no file mutation;
- hard blocked response.

Structural fallback must not authorize it.

---

# 18. Production test: run binding

Create semantic authorization for run A.

Attempt to use it from run B.

Expected:

blocked.

Create request B with same prompt but a new legitimate semantic transaction.

Expected:

new change ID and new run binding.

No transaction reuse across runs.

---

# 19. Production test: exact write scope

Authorize:

`allowed.py`

Attempt:

- `allowed.py` → allowed;
- `other.py` → blocked;
- sibling-prefix tricks → blocked;
- path traversal → blocked;
- symlink escape → blocked;
- wildcard runtime mutation → blocked;
- opaque shell mutation → blocked unless exact effects are deterministically pre-authorized.

---

# 20. Production test: Borg semantic dependency

Force these semantic-first outcomes independently:

- PASS;
- BLOCKED;
- DEGRADED;
- NOT_APPLICABLE;
- missing result;
- arbitrary unknown verdict.

Only the valid PASS-equivalent semantic authorization may allow `provider_planning` or any downstream semantic-dependent work.

Prove downstream handler call counts remain zero for every invalid case.

---

# 21. Production test: clean startup

Run the real backend module from a clean process.

Prove no `NameError`/startup exception occurs in implementation revision binding.

Then query/inspect bound revision state.

Expected:

- bound;
- non-empty;
- matches current computed source snapshot digest.

This test must catch the previous `json` import-order bug.

---

# 22. Production test: stale backend

After clean successful startup:

1. change a relevant semantic/governance/runtime source file;
2. keep old process running;
3. submit write-capable request.

Expected:

- restart-required response;
- semantic pipeline does not authorize mutation;
- provider does not mutate.

Restart backend.

Expected:

- new binding matches source;
- normal write-capable semantic-first flow resumes.

---

# 23. Production test: canonical revision scheme

Build a baseline through `build_synchronized_baseline()`.

Verify:

`baseline.implementation_revision == implementation_revision(source_snapshot(root))`

Also verify it is not silently replaced with Git HEAD.

Then persist/reload it.

Expected:

same baseline, valid digest.

---

# 24. Production test: stored `SYNCED` string is insufficient

Create/tamper a fixture baseline whose:

- `status = "SYNCED"`;
- implementation revision is wrong.

Expected:

`assess_synchronization()` does not report `SYNCED`.

This regression test must prevent the current manual-Git-SHA mistake from returning.

---

# 25. Production test: UI end-to-end reconciliation

After a successful UI write:

- verify code changed only within exact authorized scope;
- verify semantic current state describes the resulting implementation;
- verify accepted baseline advanced exactly once;
- verify target/verification/reconciliation digests are tied to that exact run/change;
- verify no unresolved conflict remains;
- verify second no-change assessment returns `SYNCED`.

---

# 26. Preserve test isolation

All new tests must use isolated temp repositories/state.

Before and after running the complete semantic-first test suite, prove canonical production files are byte-for-byte unchanged.

Do not let tests regenerate or rewrite real:

- `semantic_project/project_model.json`;
- `semantic_project/semantic_code_sync.json`;
- canonical conflict/change history.

---

# 27. Canonical state promotion must be transactional

Do not leave project model updated while baseline update fails, or vice versa.

Prepare candidate reconciled semantic state and baseline first.

Validate both.

Promote accepted canonical state atomically or with a recoverable two-phase mechanism already present in Agent_X.

On failure:

- previous accepted state remains authoritative;
- failed candidate remains evidence only;
- no false `SYNCED`.

---


# 28. Provide a bounded recovery path from the currently disputed baseline

There is a bootstrap/circularity problem:

- the current accepted baseline is not trustworthy;
- normal semantic-first expects a valid accepted baseline;
- the repair itself must not bypass semantic-first permanently.

Resolve this explicitly.

Implement or use a **narrow recovery/conflict-resolution mode** that is authorized only when deterministic inspection proves the accepted synchronization baseline is invalid or inconsistent with the current canonical synchronization contract.

The recovery mode must:

- bind to the exact current workspace;
- bind to the exact disputed baseline digest;
- bind to the exact current semantic revision;
- bind to the exact current implementation snapshot;
- record the reason the accepted baseline is invalid;
- permit only the files/responsibilities required to repair semantic-first and its canonical state;
- require governed LLM architectural reasoning for semantic decisions;
- require exact verification before promotion;
- expire permanently once a valid canonical `SYNCED` baseline is minted.

It must **not** become a general bypass, maintenance flag, environment-variable escape hatch, or user-controlled “ignore semantics” mode.

Test that recovery authorization cannot be replayed after the repaired baseline is accepted.

---

# 29. Keep accepted current state and proposed target state strictly separate

The accepted semantic model describes verified current implementation.

A semantic change overlay describes proposed target state.

Do not mutate accepted-current semantic meaning before implementation verification succeeds.

Required invariant:

`accepted current`
!=
`proposed target`

until canonical reconciliation promotes a verified result.

The change transaction must preserve:

- base semantic revision;
- base implementation revision;
- requested intent;
- affected capabilities/responsibilities;
- proposed additions;
- proposed removals;
- proposed replacements;
- proposed moves/renames;
- intended interfaces;
- invariants;
- authority/implementation-mode decisions;
- read set;
- write set;
- verification requirements.

A failed or abandoned target must never leak into accepted current semantic truth.

Canonical semantic files themselves are governed state. Direct/manual edits to accepted semantic meaning must be detected as `SEMANTIC_AHEAD` or equivalent conflict, not silently treated as truth.

---

# 30. Support new files, deletions, renames, and replacements semantically

Semantic-first must work for more than edits to already-known modules.

The target design must be able to authorize:

- creation of a genuinely new file/module/prompt/config/schema/interface;
- deletion of an obsolete implementation;
- rename/move of an implementation while preserving semantic identity;
- replacement of old implementation with new implementation;
- consolidation of duplicates.

Do not derive the write set solely from modules that already exist in the current project model.

For new artifacts, the semantic target may propose exact future paths/bindings before those paths exist.

For deletion/rename:

- bind old path;
- bind intended new path or tombstone;
- verify deletion/move actually occurred;
- update stable semantic identity without manufacturing a new capability merely because the path changed.

Add regression tests for create, delete, rename/move, replacement, and duplicate consolidation.

---

# 31. Enforce concurrent-run isolation and transaction ownership

Multiple Agent_X runs may exist concurrently.

One run must never consume, overwrite, invalidate, or authorize mutation from another run's semantic transaction.

Require:

- unique run state root;
- unique change ID;
- unique overlay;
- exact run/workspace binding;
- immutable transaction identity;
- collision-safe persistence;
- locking or equivalent compare-and-swap protection for canonical promotion.

If two runs start from the same accepted baseline and both attempt overlapping writes:

- do not let both promote independently;
- first valid promotion advances the accepted base;
- second run becomes stale/conflicted and must rebase/reinterpret/reverify.

If runs are disjoint, allow concurrency only if canonical promotion can prove no semantic/implementation interference.

Add tests for overlapping and disjoint concurrent runs.

---

# 32. Close time-of-check/time-of-use drift

Authorization is valid only for the exact state it was designed against.

Between:

`semantic target approval`
and
`actual file effect`

re-check the transaction's relevant freshness bindings.

Before every mutation effect, prove at least:

- accepted baseline is still the one the target was designed from;
- project model digest has not changed unexpectedly;
- target file has not changed outside this run;
- no unauthorized files changed;
- workspace identity/epoch is still valid;
- overlay remains active and unrevoked.

If any binding changed, block before the effect and classify the state as stale/conflicted.

Do not rely only on the pre-provider authorization check.

---

# 33. Define authorization lifetime, terminal state, and revocation

A semantic transaction must not authorize writes forever.

Define explicit transaction lifecycle states such as the existing canonical equivalents of:

- active;
- verified;
- reconciled;
- rejected;
- superseded;
- aborted;
- expired.

Only `active` may authorize implementation effects.

After successful verification/reconciliation, revoke mutation authority for the completed change.

After cancellation, failure, timeout, conflict, provider abort, or user stop, revoke authority immediately.

Do not allow a completed transaction to be reused for another write.

Do not let restart resurrect old active authority without explicit recovery validation.

Add replay/reuse tests.

---

# 34. Add crash/restart recovery for half-finished semantic changes

Test and implement deterministic recovery at each important boundary:

- run created but semantic target not persisted;
- target persisted but provider not started;
- provider started but no mutation occurred;
- partial authorized mutation occurred;
- implementation finished but verification not run;
- verification succeeded but reconciliation not promoted;
- candidate model written but baseline promotion interrupted;
- canonical promotion completed but run record did not finalize.

On restart:

- never silently grant stale mutation authority;
- never auto-mint `SYNCED`;
- inspect durable transaction state;
- either resume the exact safe step, roll back, or classify as conflict;
- preserve evidence of partial effects;
- require new verification when implementation may have changed.

Recovery must be idempotent.

Repeated recovery must converge to one valid terminal state.

---

# 35. Bind verification exactly and make reconciliation non-self-certifying

Verification evidence must be issued by the canonical verification stage and bound to:

- exact change ID;
- exact semantic target digest;
- exact base revision;
- exact resulting implementation revision;
- exact changed-file set;
- exact tests/evidence;
- exact run/workspace.

A boolean `verified=True`, arbitrary digest, manually written JSON, test fixture, or caller assertion must never be enough to reconcile.

Verification evidence must be single-use for canonical promotion or otherwise protected against replay.

Reconciliation must reject:

- fabricated verification;
- verification from another run;
- verification for another target;
- verification for an older resulting tree;
- verification whose changed-file set differs from reality;
- verification already consumed by a different accepted baseline.

Tests are evidence, not the entire semantic proof.

---

# 36. Preserve merge-conflict semantics for all future out-of-band drift

After this repair, future code-only or semantic-only edits must still be handled correctly.

Compare:

- last accepted semantic revision;
- last accepted implementation revision;
- current semantic revision;
- current implementation revision;

against the same common accepted base.

Required outcomes include the current canonical equivalents of:

- `SYNCED`;
- `IMPLEMENTATION_AHEAD`;
- `SEMANTIC_AHEAD`;
- `BOTH_DIVERGED`;
- `PARTIAL_IMPLEMENTATION`;
- `STALE_BASE`;
- `UNRESOLVED_CONFLICT`.

Never resolve by:

- latest timestamp wins;
- code wins;
- semantic model wins;
- Git HEAD wins;
- regenerate semantic model from code and call it fixed;
- overwrite code to match stale semantics.

Conflict resolution must produce a new semantic target, verification, reconciliation, and accepted baseline.

Add regression tests for both directions and both-diverged state.

---

# 37. Prove whole-project semantic coverage, not only Harvest/UI coverage

Before declaring the semantic-first foundation complete, perform a coverage audit of the entire behavior-affecting Agent_X project.

The canonical model must cover, where behavior-affecting:

- Python/backend code;
- frontend/UI code;
- prompts and prompt modules;
- configuration;
- schemas/contracts;
- REST interfaces;
- MCP interfaces;
- CLI interfaces;
- provider/runtime integrations;
- persistence/state models;
- deterministic algorithms;
- security/governance boundaries;
- tests used as evidence;
- generated behavior that is part of production;
- cross-language artifacts that affect behavior.

Do not require every documentation file to become architecture.

Do require every material production responsibility to be represented or explicitly classified as external/unknown.

Unknown dynamic/reflection-based behavior must remain `unknown`; absence of static evidence must not become a verified claim that behavior does not exist.

---

# 38. Preserve stable semantic identity across refactors

Semantic identity must not equal file path.

Prove that a behavior-preserving move/rename:

- keeps the same semantic capability/responsibility identity;
- updates implementation bindings;
- updates source evidence;
- does not create duplicate semantic capabilities merely because the path changed.

Conversely, a material responsibility change must update semantic meaning rather than preserving stale identity blindly.

Add both tests.

---

# 39. Prove automatic incremental maintenance after the initial repair

The whole-project model must not require manual regeneration after every change.

After accepted changes:

- refresh only affected deterministic facts plus required dependency closure;
- run governed LLM reinterpretation/enrichment for affected semantic scope;
- preserve unaffected stable semantic identities;
- update bindings/provenance;
- reconcile current state.

Also retain a full-regeneration path for integrity checks.

Add regression tests proving:

- incremental refresh updates affected semantic scope;
- unrelated semantic identities remain stable;
- full regeneration and incremental refresh agree on accepted facts/meaning for the changed scope;
- provider-unavailable enrichment remains incomplete/blocked rather than structurally self-authorized.

---

# 40. Cover every material mutation origin and side-effect channel

Do not certify only `/api/chat`.

Audit and prove the semantic prerequisite for every path that can materially change Agent_X, including:

- normal UI chat;
- OpenCode;
- Codex;
- LLM7 if write-capable;
- self-upgrade;
- autonomous repair;
- Harvest implementation;
- Evolution;
- Balancer/code balancer;
- MCP tools;
- REST mutation endpoints;
- CLI mutation commands;
- patch/fuzzy-edit systems;
- generated code;
- assimilation/promotion;
- direct filesystem wrappers;
- subprocess helpers;
- Git helpers that can checkout/reset/apply/commit/modify working tree;
- dependency/package installation or lockfile mutation;
- database/schema migration or durable project-state migration;
- internal background/autonomic workers;
- subagents.

Do not merely search for known writer names.

Trace actual production side-effect primitives.

All material filesystem/project mutations must converge on one semantic authorization boundary or an equally strong canonical boundary that consumes the same transaction.

Read-only/network-only operations need not create mutation transactions.

---

# 41. Make reject/no-op/value decisions first-class

Semantic-first is not obligated to implement every requested change.

The governed target stage must be able to conclude:

- already exists;
- no-op;
- reject;
- merge with existing capability;
- extend existing capability;
- replace existing implementation;
- add genuinely new capability.

If implementation would degrade Agent_X, duplicate existing behavior, violate constraints, create unsupported complexity, or provide no meaningful value, the system may reject or reshape the request before code mutation.

A rejected/no-op target must not create fake implementation changes merely to satisfy the pipeline.

Record the decision and rationale without polluting accepted architecture with synthetic implementation.

---

# 42. Final audit must be independent of implementation claims

Do not use:

- commit message claims;
- AGENTS.md completion notes;
- generated reports;
- self-written `SYNCED` status;
- test names;
- comments;

as proof of completion.

At the end, freshly inspect actual current `main` and independently recompute:

- deterministic source snapshot;
- project model digest;
- semantic generation digest;
- semantic bindings digest;
- implementation revision;
- baseline digest;
- synchronization assessment.

Run the production-path behavioral tests.

Then perform a no-change rerun.

Only if the second audit independently returns `SYNCED` with no conflict and no canonical mutation is the foundation complete.



# 43. Bind authorization to the exact request identity and make retries idempotent

Run ID alone is not enough.

Bind each semantic transaction to an immutable request identity derived from the material request context, including the canonical equivalents of:

- normalized user request text;
- run ID;
- workspace ID/root;
- workspace epoch;
- selected runtime/provider mode;
- relevant agent/mode selection;
- base semantic revision;
- base implementation revision;
- idempotency key when supplied.

If the request text or material execution context changes after target creation, the old authorization must not silently authorize the changed request.

## HTTP/UI retries

Network retries must not create duplicate semantic changes for the same logical request.

For a valid idempotency key:

- same key + same immutable request identity may resume/return the same safe run/transaction;
- same key + different request identity must be rejected as an idempotency conflict;
- terminal successful requests must not execute a second mutation;
- blocked/failed requests must not accidentally resurrect mutation authority.

Add retry tests including connection drop/re-submit behavior.

---

# 44. Keep the semantic reasoning provider itself read-only with respect to project mutation

The governed LLM used to interpret/design semantic targets must not be able to mutate Agent_X while deciding whether mutation should be authorized.

Semantic reasoning happens before project-write authority exists.

Therefore semantic-provider execution must expose only the context/evidence needed for reasoning and must not gain project mutation capability through:

- filesystem tools;
- coding-runtime callbacks;
- shell;
- Git;
- MCP mutation tools;
- side-effecting plugins/adapters.

The semantic provider may produce a proposed semantic design.

Deterministic code validates and persists that proposal.

A provider response cannot itself perform or authorize the implementation.

Add a test proving semantic interpretation/design cannot mutate the workspace.

---

# 45. Minimize and deterministically validate the write set

The semantic target must authorize the smallest practical exact mutation scope.

Do not permit broad values such as:

- repository root;
- `"*"`;
- arbitrary directory trees;
- unconstrained glob patterns;

as final write authority.

For proposed new files, deletions, moves, or generated artifacts, exact future paths may be authorized.

Before persistence:

- normalize paths;
- reject workspace escape;
- reject symlink escape;
- validate path type;
- validate overlap with protected/canonical semantic state;
- prove each authorized path is justified by the semantic target.

The LLM may propose affected artifacts, but deterministic validation owns path safety and transaction scope.

If the implementation discovers a legitimate need to modify an additional file:

- do not silently expand authority;
- pause mutation;
- amend/re-design the target through semantic-first;
- issue a new sealed overlay/digest;
- then continue.

Test both scope expansion and attempted unauthorized “helpful” edits.

---

# 46. Define post-implementation failure semantics

A coding runtime changing files is not the end of a successful Agent_X change.

The UI/run must not report success until:

`implementation`
→ `verification`
→ `semantic enrichment`
→ `reconciliation`
→ `canonical promotion`

all succeed.

If implementation changed files but any later stage fails:

- do not report success;
- revoke the transaction's mutation authority;
- preserve exact evidence of the resulting implementation state;
- either roll back to the pre-change accepted implementation using the existing governed rollback mechanism, or record an explicit semantic/code conflict requiring resolution;
- never leave silently untracked implementation drift;
- never mint `SYNCED`.

If rollback itself fails, the repository remains conflicted/blocked until explicitly resolved.

Add tests for failure at verification, enrichment, reconciliation, promotion, and rollback.

---

# 47. Define pause, cancel, timeout, and resume semantics

User/UI lifecycle controls must not create authorization loopholes.

## Cancel

On cancel/stop:

- stop provider execution where possible;
- revoke active mutation authority;
- inspect whether project effects already occurred;
- if none occurred, terminate as aborted;
- if partial effects occurred, roll back or record conflict.

## Pause

Pause must not create new effects while paused.

Resume must revalidate:

- backend revision;
- workspace epoch;
- accepted baseline;
- target freshness;
- transaction status;
- write set.

## Timeout/provider disconnect

Treat uncertain side-effect completion conservatively.

Before retry/resume, inspect actual implementation state rather than assuming no mutation occurred.

Add pause/resume/cancel/timeout regression tests.

---

# 48. Validate persisted schema versions and keep canonical history clean

Every durable semantic artifact used for authority must carry and validate its schema/version.

This includes current canonical equivalents of:

- project model;
- sync baseline;
- semantic change overlay;
- semantic-first state;
- conflict record;
- conflict resolution;
- verification evidence.

Unknown/incompatible schema must not authorize mutation.

If migration is necessary:

- migrate explicitly;
- verify the migrated artifact;
- preserve provenance;
- do not silently reinterpret old fields.

Canonical change/conflict history must contain only genuine production semantic events.

Do not write into canonical history from:

- tests;
- fixtures;
- demos;
- dry-runs;
- synthetic proof prompts;
- temporary diagnostics.

---

# 49. Keep exact facts deterministic and LLM claims evidence-bound

The governed LLM supplies architectural meaning, not exact source truth.

Do not let LLM output manufacture:

- files;
- symbols;
- hashes;
- interfaces;
- governance authority;
- security authority;
- test results;
- implementation completion;
- exact dependency edges that contradict deterministic evidence.

Every accepted semantic claim must carry its evidence/provenance according to the existing schema.

When LLM architectural inference contradicts exact deterministic facts:

- deterministic facts win on exact fact questions;
- retain/report the semantic disagreement as conflict/rejected inference;
- do not silently force either representation into `SYNCED`.

Treat request text, harvested content, repository comments, and external evidence as potentially untrusted input to the semantic LLM.

Do not allow prompt injection in source/repository text to alter governance rules or grant mutation authority.

Add adversarial-evidence tests.

---

# 50. Add a real read-only production-path test

Start a clean backend and submit an ordinary explanatory request such as:

`explain how Harvest ranking works`

through the real UI/API path.

Use a technically enforced read-only execution mode.

Prove:

- no semantic mutation transaction is created;
- no `change_id` is created;
- no project mutation authority is granted;
- no canonical semantic state changes;
- response still succeeds.

Then use the same natural-language request with a runtime that remains write-capable.

Prove it cannot mutate without semantic-first.

This verifies that performance optimization is based on capability enforcement, not prose classification.



# 51. Define the authoritative implementation snapshot boundary

Do not treat every file under the repository root as implementation truth.

The synchronization source snapshot must have an explicit deterministic inclusion/exclusion contract.

Include every artifact whose content can materially affect Agent_X production behavior or architecture, including runtime-authoritative prompts/config/schemas/frontend/backend artifacts.

Exclude artifacts that are merely runtime evidence or generated noise unless they are intentionally authoritative, including current canonical equivalents of:

- caches;
- logs;
- temporary files;
- test output;
- coverage output;
- build products;
- runtime run records;
- sampling/drift history that is evidence rather than executable configuration;
- temporary downloads;
- generated diagnostics;
- isolated test state.

Canonical semantic state must not be counted as implementation state in a self-referential way:

- `semantic_project/project_model.json` changes are semantic-state changes;
- `semantic_project/semantic_code_sync.json` changes are synchronization-state changes;
- they must not alter the implementation revision merely by recording the new implementation revision.

Otherwise baseline construction becomes circular.

Do not hard-code “all Markdown is non-behavioral” or “all JSON is behavioral”.

Classify by architectural role.

A runtime-consumed prompt/config file is behavior-affecting even if it is Markdown/JSON/text.

A human-only report is not.

## Required regressions

Prove:

- production Python change → implementation revision changes;
- production frontend change → implementation revision changes;
- runtime prompt change → implementation revision changes;
- runtime config/schema change → implementation revision changes;
- non-authoritative README/report change → no implementation drift;
- runtime log/history/cache change → no implementation drift;
- canonical project-model change → semantic drift, not implementation drift;
- canonical sync-marker rewrite → does not recursively change implementation revision;
- behavior-affecting newly created untracked file inside authorized scope is visible before Git commit.

---

# 52. Bind synchronization and transactions to the exact worktree/workspace context

Do not assume repository path alone is always enough.

Where Agent_X supports multiple workspaces, worktrees, or branches, bind accepted and active state to the canonical equivalents of:

- repository identity;
- workspace/worktree root;
- workspace ID;
- workspace epoch;
- branch/ref when materially relevant;
- deterministic implementation snapshot.

A transaction designed in one worktree must not authorize another.

Switching branch/worktree while a transaction is active must invalidate or revalidate the transaction before mutation.

Do not use branch name as implementation truth; the deterministic snapshot remains authoritative.

Add cross-worktree and branch-switch tests.

---

# 53. Keep normal semantic-first execution bounded and hardware-appropriate

The foundation is not complete if every ordinary edit requires unbounded whole-repository LLM context or pathological rescanning.

Preserve correctness while using:

- deterministic incremental discovery;
- affected semantic subgraph/context;
- bounded evidence batches;
- bounded LLM response sizes;
- bounded relationship traversal;
- explicit escalation to full regeneration only when integrity requires it.

The whole-project model remains globally authoritative, but ordinary semantic reasoning should consume the smallest sufficient affected context.

Do not truncate away governance/invariants required for correctness.

Add a regression proving a small localized change does not send the entire multi-megabyte canonical project model to the provider.

Do not introduce a new graph database or heavy infrastructure solely for this closure.

---

# 54. Make verification target-specific and behavioral where required

Generic checks such as:

- module imports;
- symbol exists;
- file exists;
- test suite exits zero;

are useful evidence but are not sufficient for every semantic target.

Each target must derive verification requirements from its intended behavior, affected interfaces, invariants, and implementation mode.

Where behavior can be tested, verify behavior.

Where replacing/refactoring existing functionality, verify equivalence or explicitly intended behavioral delta.

Where changing interfaces, verify callers/consumers.

Where changing prompts/prompt-driven behavior, verify the governed prompt path is actually on the production decision path.

Where changing deterministic authority, verify the failure/denial cases as well as the happy path.

Do not permit semantic reconciliation to self-certify based only on structural existence.

---

# 55. Govern rollback/restoration authority explicitly

Rollback is itself a project mutation and must not become an emergency bypass.

A rollback/restoration operation may use deterministic recovery authority only when bound to:

- the original run/change ID;
- the exact pre-change accepted snapshot or rollback snapshot;
- the exact affected paths;
- the reason for rollback;
- the current conflicted/failed transaction.

Rollback must restore known prior accepted content, not allow arbitrary replacement.

After rollback:

- independently reassess implementation vs accepted semantic state;
- require `SYNCED` before normal write work resumes.

If rollback cannot restore the exact accepted state, record an explicit conflict and block.

Add tests proving arbitrary writes cannot be smuggled through the rollback path.



# 56. Prove first-time semantic bootstrap and distinguish it from corruption

The semantic-first foundation must work on a legitimate first initialization without requiring the user to manually generate semantic files.

## Genuine first bootstrap

When no accepted semantic project exists because the workspace has never been semantically initialized:

1. discover deterministic project facts;
2. resolve the governed semantic provider;
3. build the whole-project semantic model through governed LLM enrichment;
4. validate all semantic claims against deterministic evidence;
5. require `semantic_generation_status = complete`;
6. construct the initial accepted synchronization baseline through the canonical baseline builder;
7. persist canonical state transactionally;
8. independently assess `SYNCED`.

If the provider is unavailable or semantic enrichment is incomplete:

- do not generate heuristic architectural truth;
- do not permit write-capable changes;
- fail closed with a clear bootstrap-incomplete state.

## Missing/corrupt state in an established project

Do not confuse:

`never initialized`

with:

`accepted canonical state was deleted/corrupted`.

If repository/project evidence shows semantic initialization previously existed, missing/corrupt accepted state must enter bounded recovery/conflict handling.

Do not silently regenerate from current code and erase the historical common base.

Add tests for:

- genuine first bootstrap;
- provider unavailable during bootstrap;
- corrupted model;
- corrupted baseline;
- deleted model in established repo;
- deleted baseline in established repo.

---

# 57. Verify one canonical stack owns the lifecycle

At completion, prove there is exactly one logical owner for each responsibility:

- deterministic project discovery;
- canonical semantic model;
- governed semantic LLM reasoning;
- change transaction/overlay persistence;
- mutation authorization;
- provider/runtime mutation permission;
- implementation verification;
- rollback/recovery;
- semantic reconciliation;
- accepted synchronization baseline.

Different adapters may call these capabilities, but they must not implement conflicting parallel authorities.

Specifically audit for leftover UI-specific, Harvest-specific, provider-specific, or test-only paths that can independently:

- mint `SYNCED`;
- create accepted semantic truth;
- grant project mutation authority;
- bypass the canonical verification protocol.

Delete or demote obsolete shortcut paths where necessary.

Do not add a dedicated Architectural MCP.



# 58. Separate portable canonical project identity from run-local absolute paths

Accepted semantic project truth may be committed/shared across machines.

Therefore committed canonical authority must not become invalid merely because the repository is checked out at a different absolute filesystem path.

Distinguish:

- **portable canonical project/repository identity**;
- **run-local workspace root/worktree identity**.

Active transactions and mutation authorization must bind to the exact local absolute workspace root.

But a committed accepted semantic model/baseline must use a portable representation or a clearly local non-committed binding layer for machine-specific path identity.

Do not commit an absolute path such as `/home/user/.../Agent_X` as the sole canonical repository identity if loading the same accepted project at `/tmp/Agent_X` should remain valid.

If the current schema stores absolute `workspace_root` in the committed baseline:

- migrate the design cleanly;
- preserve exact run-local root validation in active state;
- update baseline validation accordingly;
- prove no weakening of cross-workspace authorization.

## Required portability tests

1. Produce accepted canonical state in checkout A.
2. Copy/checkout the exact same committed tree into checkout B at a different absolute path.
3. Load canonical state in B.
4. Verify the project can establish valid local runtime binding without rewriting semantic meaning solely because the path changed.
5. Verify a transaction created in A still cannot authorize writes in B.

Path portability must not become cross-workspace transaction portability.

---

# 59. Protect secrets, credentials, private runtime data, and non-text evidence

Whole-project semantic reasoning must not indiscriminately send every repository/runtime byte to an LLM provider.

Before semantic evidence enters provider context:

- exclude credentials/secrets/tokens/private keys;
- exclude `.env` secret values and credential stores;
- exclude user/private runtime data;
- exclude opaque binary contents unless semantically required and safely handled;
- apply existing Agent_X data isolation/redaction/governance;
- prefer safe metadata/hash/reference for artifacts whose raw contents are not required.

A secret-containing file may still be represented structurally as a protected external/config boundary without exposing the secret value.

Do not let semantic coverage become a data-exfiltration path.

Submodules, symlinks, external package roots, and paths outside the workspace must be represented as external boundaries unless explicitly and safely in scope; do not recursively ingest arbitrary external files.

Add tests proving secret-like fixtures are not included in governed semantic LLM messages.

---

# 60. Require a clean-main / fresh-checkout completion proof

Do not declare the task complete based on a dirty local worktree or uncommitted fixes.

Before final completion:

1. ensure all required production changes are committed to the actual current `main`;
2. ensure canonical accepted semantic state corresponds to those committed bytes under the canonical implementation snapshot definition;
3. verify no required fix exists only in untracked/local state;
4. create a fresh temporary checkout/worktree of that exact `main`;
5. run the semantic-first integrity/production-path regression suite there using isolated runtime state;
6. prove canonical state loads correctly under the fresh path;
7. prove no hidden local files are required;
8. independently assess synchronization.

Git HEAD remains evidence of which committed tree is being audited; it is still not substituted for semantic or implementation revision.

No CI/CD or GitHub Actions work is required for this proof.



# 61. Enforce a deterministic authority floor for implementation-mode decisions

The governed LLM may decide whether a responsibility is:

- `prompt_only`;
- `prompt_driven`;
- `deterministic`.

But this is not unrestricted authority.

Hard guarantees must never be downgraded to prompt-only reasoning.

The deterministic policy layer must reject or correct any LLM target that attempts to place these responsibilities solely under prompt authority:

- security;
- credentials/permissions;
- governance authorization;
- semantic mutation authorization;
- write-set enforcement;
- state persistence;
- transactions;
- locks/concurrency;
- exact schemas/contracts;
- exact deterministic algorithms where correctness depends on precise computation;
- validation;
- evidence sealing/digests;
- rollback/recovery mechanics;
- Git/filesystem/project side effects;
- budgets/resource hard limits;
- protocol enforcement;
- canonical state promotion.

Prompt-driven designs may use LLM reasoning for architecture/strategy, but executable guarantees remain deterministic.

The policy must be role-based, not merely based on filenames/category strings.

## Adversarial tests

Have a controlled semantic provider deliberately classify:

- mutation authorization as `prompt_only`;
- credential validation as `prompt_only`;
- rollback authority as `prompt_only`;
- schema validation as `prompt_driven` with no deterministic enforcement.

Expected:

the target is rejected or corrected before mutation authority exists.

Also prove legitimate reasoning/architecture responsibilities may remain prompt-only/prompt-driven when no hard guarantee is required.

---

# 62. Keep the semantic model architectural rather than turning evidence into slop

Tests, comments, filenames, directory names, and documentation are evidence sources, not automatically architectural truth.

Do not automatically promote every:

- test assertion;
- test helper;
- directory/package name;
- comment;
- README statement;
- fixture;
- temporary proof module;

into a production capability, architectural invariant, or responsibility.

In particular:

- arbitrary `assert ...` statements inside tests are not automatically production invariants;
- tests may verify an invariant without owning that invariant;
- test packages should normally appear as verification/evidence, not production capabilities;
- directory names are retrieval clues, not semantic subsystem authority.

Require semantic-model quality checks for:

- duplicate capabilities/responsibilities;
- multiple conflicting owners for one responsibility;
- orphan responsibilities;
- capabilities that exist only because a filename/package existed;
- test-only artifacts promoted as production architecture;
- stale identities after replacement/deletion;
- contradictory semantic claims;
- relationships unsupported by evidence.

Derived indexes/vector retrieval/caches may accelerate semantic access, but they are rebuildable projections, not independent canonical truth.

---

# 63. Require behavioral tests, not source-string self-certification

Do not certify a closure condition merely by asserting that:

- a function name exists;
- a source file contains a string;
- a comment says “fail closed”;
- an enum has a member;
- a test fixture manually writes `SYNCED`;
- a helper returns a canned PASS.

For every critical closure guarantee, execute the real production seam or the closest isolated production-equivalent seam.

Examples:

Bad proof:

`assert "run_semantic_first" in chat_source`

Good proof:

submit a request through the real route, instrument the semantic provider/runtime, and prove event ordering plus denied mutation before semantic PASS.

Bad proof:

`assert semantic_first not in degradable_categories`

Good proof:

force semantic-first failure and prove provider planning/mutation handlers are never called.

Bad proof:

write a fake `SYNCED` fixture and load it.

Good proof:

construct candidate state, call canonical baseline builder, persist/reload, and independently call synchronization assessment.

Use controlled deterministic test providers where external network calls would make tests flaky, but keep the actual Agent_X routing/authorization code under test.



# 64. Handle self-modification of semantic/governance enforcement safely

Agent_X is allowed to improve its own semantic-first/governance/mutation-enforcement code.

That creates a special lifecycle:

1. run starts under trusted enforcement revision A;
2. semantic target authorizes exact changes;
3. implementation changes enforcement source to candidate revision B;
4. the currently running process is still executing revision A in memory;
5. no new write-capable run may start under stale revision A;
6. the active authorized run must still be able to finish its exact verification/reconciliation lifecycle safely.

Do not let stale-backend protection accidentally strand the active run after its own authorized mutation.

But do not let the active run expand scope after enforcement code changed.

## Required behavior

When the active transaction changes semantic/governance/mutation-enforcement source:

- mark backend `restart_required_after_current_run`;
- refuse all new write-capable runs;
- keep the current run bound to its original sealed transaction and exact write set;
- permit only its required verification/reconciliation/rollback steps;
- do not issue a second unrelated semantic target under the stale process.

Before canonical promotion of enforcement revision B:

- load/import/start the candidate enforcement code in a fresh subprocess or otherwise isolated fresh interpreter;
- run the critical semantic-first startup/authorization regression checks against B;
- verify B can start cleanly and enforce the target invariants.

After successful promotion:

- current process must restart before another write-capable run;
- fresh process binds revision B;
- no-change synchronization assessment remains `SYNCED`.

If candidate B cannot start or enforce the contract:

- do not promote it as successful;
- roll back or enter explicit conflict.

Add a test where a semantic-first source file itself is modified during an authorized run.



# 65. Prove implementation-mode decisions control the real production architecture

The semantic target's mode decision must not be decorative metadata.

For each affected responsibility, verify that the actual implementation matches its chosen mode.

## `prompt_only`

Use when the responsibility is genuinely knowledge/reasoning behavior with no executable hard guarantee.

If project behavior is implemented through a stored/runtime prompt:

- that prompt is the production behavior owner;
- unnecessary duplicate hard-coded decision logic is removed or demoted;
- prompt changes themselves remain governed repository mutations when stored in the project.

Do not call something `prompt_only` while legacy code still independently owns the same decision.

## `prompt_driven`

The LLM/prompt must actually be on the normal production decision path.

Deterministic code may:

- validate;
- constrain;
- persist;
- authorize;
- enforce invariants;
- execute side effects.

But deterministic fallback templates must not silently make the semantic/architectural decision instead of the governed LLM.

If the provider is unavailable and the responsibility requires prompt-driven architectural judgment, fail closed or use an explicitly designed non-authoritative degraded read-only behavior; do not pretend the hard-coded fallback is equivalent.

## `deterministic`

Hard correctness/authority must be implemented in executable deterministic code.

A prompt may explain or recommend, but must not be the sole authority.

## Ownership/consolidation

For every migrated responsibility:

- identify one canonical owner;
- remove obsolete duplicate decision owners;
- avoid wrapper-per-legacy-function sprawl;
- reuse shared prompt/compiler/provider infrastructure;
- preserve only compatibility adapters that have a real necessary boundary and no independent authority.

Add regression tests where the semantic target says each mode and prove actual runtime behavior follows it.



# 66. Make the sealed semantic target drive implementation, not merely authorize it

Semantic-first is not just a permission gate.

After target design, the implementation runtime must receive the exact accepted semantic target as authoritative implementation context.

The handoff must bind at least:

- change ID;
- target/design digest;
- affected responsibilities/capabilities;
- intended architecture;
- implementation-mode decisions;
- exact write set;
- invariants;
- affected interfaces;
- replacement/extension/new-capability decision;
- verification requirements.

The coding runtime may inspect source code as implementation evidence after this target is established.

It must not independently replace the semantic target with a different architecture merely because the original natural-language request was broad.

The original user request and semantic target may both be included, but target conflicts are resolved in favor of the sealed governed target until a formal target amendment occurs.

If implementation discovers the target is incomplete/wrong:

- stop or pause effects;
- return the new evidence;
- amend/re-run semantic design;
- seal a new target digest;
- reauthorize;
- continue.

Do not silently let the coding runtime reinterpret architecture and then update semantics afterward to match whatever it did.

## Human/provider approval precedence

A user clicking “allow”, provider permission callback approval, or external runtime approval is never sufficient to override semantic denial.

Required precedence:

`semantic authorization`
AND
`other required governance/user approval`

not:

`user/provider approval OR semantic authorization`.

Add tests where the user/provider approves an unauthorized target and prove mutation is still denied.

---

# 67. Bind baseline evidence fields to their actual artifact semantics

Do not merely require non-empty digests.

Verify provenance and meaning:

- `accepted_change_id` identifies the exact promoted change;
- `accepted_target_digest` recomputes from the exact sealed semantic target/overlay used for implementation;
- `verification_digest` recomputes from the issued verification evidence for that exact target/result;
- `verification_revision` binds the exact verified resulting implementation state according to the canonical revision scheme;
- `reconciliation_revision` binds the exact accepted reconciled semantic state according to the canonical reconciliation scheme;
- `baseline_digest` seals all baseline fields.

Do not copy one digest into multiple fields merely to satisfy non-empty validation unless those artifacts are genuinely identical by definition and the schema explicitly specifies that.

Add tamper/copy-paste tests for each field.



# 68. Track authorized in-run effects so freshness checks distinguish self-change from interference

The original semantic target is bound to the pre-change source snapshot, but a real implementation may perform multiple authorized effects.

After the first legitimate write, comparing the workspace only to the original base snapshot is no longer sufficient.

Maintain a run-scoped deterministic expected-state/effect ledger using the existing effect-journal/transaction infrastructure where possible.

For every authorized project effect, record at minimum:

- run/change ID;
- target path;
- pre-effect hash/state;
- intended operation type;
- post-effect hash/state after successful effect;
- sequence/order;
- failure/rollback status.

Before the next effect:

- compare actual state to the run's latest expected state;
- allow prior changes produced by this exact authorized run;
- reject unexplained differences, including differences on another path that happens to be inside the authorized write set.

Do not treat “path is in write set” as proof that every change to that path came from this run.

## Required regressions

- same run writes the same authorized file twice → second authorized write can proceed after validating the first effect;
- same run writes two different authorized files sequentially → both can proceed;
- external process changes the first file between the run's first and second edits → next effect is blocked/conflicted;
- external process changes a different path that is also in the allowed write set → detected, not silently accepted;
- failed effect does not advance expected-state ledger;
- rollback updates/validates expected state consistently.

The final verification still compares the complete resulting implementation against the sealed semantic target and authorized write scope.



# 69. Govern material non-file side effects with typed transaction effects

A project change is not always a file write.

Material effects such as:

- dependency/package installation;
- virtual-environment mutation;
- database/schema migration;
- durable runtime/project-state migration;
- service/runtime configuration change;
- promotion/deployment action;
- destructive Git operation;

must be represented as typed transaction effects when they materially change Agent_X.

Do not pretend an empty file write set means these effects need no semantic authority.

For each typed effect:

- bind it to the same change/run/target;
- validate parameters deterministically;
- journal pre/post state where possible;
- define rollback/recovery behavior;
- include it in verification.

Network-only read operations that do not alter project/runtime authority need not be treated as mutation.

---

# 70. Protect the snapshot-boundary definition as part of the protected deterministic core

The code/configuration that decides which artifacts count toward implementation revision is itself behavior-authoritative.

It must be included in the protected implementation snapshot and semantic model.

A change must not be able to hide itself by modifying the inclusion/exclusion rules and then recomputing a “clean” implementation revision.

If snapshot-boundary rules change:

- treat that as a protected deterministic semantic change;
- verify old and new boundary behavior explicitly;
- migrate/recompute accepted baseline only through bounded recovery/reconciliation;
- prove critical enforcement files remain included.

Add an adversarial test where a candidate tries to exclude its own modified enforcement file from the snapshot.

Expected:

the attempt is detected/blocked unless the boundary change itself is legitimately authorized and verified.

---

# 71. Keep reject/no-op decisions from advancing accepted code/semantic baseline

A rejected or genuine no-op request may be recorded as a decision/evidence event, but it must not fabricate a new implementation revision, semantic revision, or accepted synchronization baseline.

If nothing material changed:

- accepted semantic/code baseline remains the same;
- no fake verification result claims implementation occurred;
- no fake changed-file set is created;
- no active mutation authority remains.

If a target concludes “already exists”, verify the existing capability sufficiently to justify the decision, then terminate without unnecessary mutation.

Add no-op/reject/already-exists baseline-stability tests.


# 72. Completion conditions

Do not stop until all are true:

1. `api_server.py` clean startup successfully binds implementation revision.
2. Startup binding no longer depends on names imported later in the module.
3. Missing/failed binding remains fail-closed.
4. Normal `/api/chat` write request does not require a pre-existing transaction.
5. Run identity exists before semantic authorization.
6. Active semantic state is per-run, not stored as one shared canonical transaction.
7. `/api/chat` uses governed LLM semantic reasoning.
8. Structural fallback cannot authorize architecture.
9. The UI uses the same canonical semantic-first authority semantics as governed workflow execution.
10. Successful semantic-first produces `semantic_first_state.json`.
11. Successful semantic-first produces a non-empty run-bound change overlay.
12. Run A authorization cannot authorize run B.
13. Exact workspace binding is enforced.
14. Exact write set is enforced.
15. Wildcard existence checking is not final mutation authority.
16. OpenCode mutation callbacks validate semantic authorization.
17. Codex mutation callbacks validate semantic authorization.
18. LLM7 does the same if write-capable.
19. Opaque shell mutation remains fail-closed unless exact effects are proven.
20. `semantic_first` remains non-degradable.
21. `semantic_first = NOT_APPLICABLE` cannot satisfy dependency coherence.
22. `semantic_first = DEGRADED` cannot satisfy dependency coherence.
23. Missing/unknown semantic-first result cannot satisfy dependency coherence.
24. `provider_planning` cannot execute without valid semantic-first success.
25. Current canonical semantic model is complete.
26. Semantic claim provenance passes current canonical validation.
27. Canonical baseline is produced by `build_synchronized_baseline()` or the one canonical equivalent path.
28. Final implementation revision uses the canonical source-snapshot revision scheme.
29. Git HEAD is not substituted for implementation revision.
30. Baseline digest recomputes.
31. Source hashes equal actual current snapshot.
32. Semantic revision equals actual accepted model digest.
33. Verification evidence is real and run/change-bound.
34. Final stored status is `SYNCED`.
35. Independent `assess_synchronization()` also returns `SYNCED`.
36. No unresolved conflict remains.
37. Full production-path tests pass.
38. Test suite does not mutate canonical production semantic state.
39. A fresh backend restart followed by an ordinary UI write request performs semantic-first automatically.
40. A fresh no-change re-assessment remains `SYNCED`.
41. Recovery from the currently disputed baseline uses a narrowly bound one-time repair/conflict transaction rather than a permanent bypass.
42. Recovery authorization cannot be replayed after a valid baseline is accepted.
43. Accepted current semantic state and proposed target state remain separate until verified promotion.
44. Canonical semantic-file edits themselves are governed and produce semantic-ahead conflict when changed out of band.
45. New file creation is supported by semantic target design before the file exists.
46. Deletion, rename/move, replacement, and consolidation are represented and verified semantically.
47. Stable semantic identity survives behavior-preserving path refactors.
48. Material responsibility changes update semantic meaning instead of preserving stale identity.
49. Concurrent runs cannot share or steal semantic authorization.
50. Overlapping concurrent transactions cannot both promote from the same stale base.
51. TOCTOU freshness is checked at the actual mutation boundary.
52. Authorization has an explicit active/terminal lifecycle and completed/aborted transactions cannot be reused.
53. Crash/restart at every major boundary converges safely and idempotently without false `SYNCED`.
54. Verification is exact, issued, run/target/result-bound, and cannot be fabricated or replayed.
55. Code-only drift produces implementation-ahead conflict.
56. Semantic-only drift produces semantic-ahead conflict.
57. Both-sided drift produces an explicit merge-style conflict.
58. No code-wins, semantic-wins, timestamp-wins, Git-wins, or regenerate-and-ignore shortcut exists.
59. Whole-project semantic coverage includes every material behavior-affecting production artifact class.
60. Dynamic/reflective uncertainty is preserved as unknown rather than converted to false verified absence.
61. Incremental semantic maintenance updates affected scope automatically after accepted changes.
62. Unaffected stable semantic identities survive incremental refresh.
63. Full regeneration remains available as an integrity check and agrees with incremental maintenance on accepted changed scope.
64. Provider-unavailable semantic enrichment cannot authorize architecture.
65. Every material mutation origin and side-effect channel is either routed through the canonical semantic authorization boundary or equivalently consumes the exact same transaction.
66. Direct filesystem, patch, subprocess, Git, background/autonomous, MCP, REST, CLI, Harvest, Evolution, Balancer, assimilation, and subagent mutation paths cannot bypass semantic authorization.
67. Reject/no-op/merge/extend/replace/new-capability decisions are first-class and do not force pointless code changes.
68. Failed/abandoned targets never leak into accepted current semantic truth.
69. Canonical promotion is concurrency-safe and transactional.
70. The final completion audit independently recomputes semantic and implementation truth rather than trusting self-reported completion artifacts.
71. Every semantic transaction is bound to an immutable request identity, not only a run ID.
72. Changed request/context cannot reuse a stale authorization.
73. Idempotent UI retries do not execute duplicate mutations.
74. Same idempotency key with different request identity is rejected.
75. Semantic reasoning provider has no project mutation authority while designing the target.
76. Final write scope is exact/minimal and cannot use wildcard/root authority.
77. Write-set expansion requires a newly sealed semantic target rather than silent authority expansion.
78. Post-code verification/enrichment/reconciliation/promotion failure cannot be reported as successful completion.
79. Failed post-code stages roll back or leave an explicit blocking conflict; no silent drift remains.
80. Cancel revokes mutation authority and resolves any partial effects.
81. Pause/resume revalidates all freshness/authority bindings.
82. Timeout/provider disconnect recovery inspects actual effects before retry.
83. Durable semantic authority artifacts reject unknown/incompatible schema versions.
84. Canonical semantic history contains no test/dry-run/synthetic pollution.
85. Exact source facts remain deterministic and cannot be invented by the LLM.
86. LLM semantic claims remain evidence-bound and source prompt injection cannot grant governance authority.
87. A true read-only production request succeeds without creating semantic mutation state, while the same request cannot mutate through a write-capable runtime without semantic-first.
88. The implementation snapshot has an explicit deterministic behavior-authoritative boundary rather than hashing arbitrary repository noise.
89. Canonical semantic/synchronization files do not self-reference into implementation revision.
90. Runtime logs/history/caches/test artifacts cannot create false implementation drift.
91. Behavior-authoritative prompts/config/schemas/frontend/backend artifacts do create implementation drift when changed.
92. Authorized new behavior-affecting files are visible in implementation state before Git commit.
93. Transactions are bound to exact workspace/worktree context and cannot cross-authorize another worktree.
94. Branch/worktree changes invalidate or revalidate active authorization before mutation.
95. Ordinary semantic-first execution uses bounded affected context rather than unbounded whole-model provider dumps.
96. Target-specific behavioral verification supplements structural checks wherever behavior is material.
97. Replacement/refactor verification proves intended equivalence or explicit behavioral delta.
98. Prompt-driven changes are verified on the actual production prompt decision path.
99. Rollback authority is bound to the exact failed transaction and prior accepted snapshot, not a generic bypass.
100. After rollback, independent synchronization assessment must return `SYNCED` or the repository remains explicitly conflicted/blocked.
101. Genuine first-time initialization automatically creates the complete governed semantic model and canonical baseline.
102. First-time bootstrap cannot authorize write-capable work when governed semantic enrichment is unavailable/incomplete.
103. Missing/corrupt canonical state in an established project enters recovery/conflict handling rather than being silently regenerated as a new baseline.
104. Exactly one canonical logical stack owns semantic truth, mutation authorization, verification, rollback, and synchronization.
105. No UI-specific, Harvest-specific, provider-specific, or legacy shortcut can independently mint `SYNCED` or accepted semantic authority.
106. No dedicated Architectural MCP is introduced or required.
107. Committed canonical semantic/synchronization state is portable across absolute checkout paths or explicitly separates machine-local binding from portable truth.
108. Active transactions remain bound to exact local workspace roots even when canonical state is portable.
109. A fresh checkout at a different path does not require rewriting semantic meaning solely because its absolute path changed.
110. Secret/credential/private runtime contents are excluded or redacted from semantic LLM evidence according to existing governance.
111. External/submodule/symlink targets are treated as bounded external evidence rather than recursively ingested without authority.
112. All required fixes and accepted canonical state are present on actual current `main`, not only in a dirty local worktree.
113. A fresh checkout/worktree of current `main` can load and validate semantic-first without hidden local files.
114. Fresh-checkout independent synchronization assessment agrees with the accepted canonical state.
115. Final production-path proof runs from isolated runtime state rather than relying on stale `.agentx` artifacts from development.
116. Final completion does not depend on CI/CD or GitHub Actions.
117. LLM implementation-mode decisions cannot downgrade hard deterministic authority into prompt-only behavior.
118. Security/governance/state/transactions/validation/rollback/side effects retain deterministic enforcement regardless of LLM suggestion.
119. Role-based authority policy is enforced independently of filenames and category labels.
120. Legitimate prompt-only/prompt-driven responsibilities remain possible where no hard deterministic guarantee is needed.
121. Arbitrary test assertions are not automatically promoted into production architectural invariants.
122. Tests are modeled primarily as evidence/verification unless they genuinely own production behavior.
123. Directory/package names and comments cannot self-create architectural capabilities without semantic evidence.
124. Duplicate/orphan/conflicting semantic ownership is detected and resolved or explicitly blocked.
125. Derived semantic indexes/vector caches remain rebuildable projections rather than independent canonical truth.
126. Critical completion tests exercise production behavior rather than source-string/comment existence.
127. Semantic-first failure tests prove downstream handlers do not execute, not merely that constants look correct.
128. Canonical synchronization tests invoke the real builder/persistence/assessment path rather than hand-writing passing fixtures.
129. A run that modifies semantic/governance enforcement remains bound to the original trusted transaction while new write-capable runs are blocked.
130. Self-modifying enforcement runs cannot expand their write scope after the enforcement source changes.
131. Candidate enforcement code is verified in a fresh interpreter/process before canonical promotion.
132. Broken candidate enforcement cannot be promoted as successful merely because the old in-memory process still works.
133. Successful enforcement self-modification forces restart before the next write-capable run.
134. After restart into the candidate enforcement revision, startup binding and independent synchronization still pass.
135. Prompt-only/prompt-driven/deterministic decisions are reflected in actual production behavior, not merely stored in semantic metadata.
136. Prompt-only responsibilities do not retain an independent legacy hard-coded decision owner.
137. Prompt-driven responsibilities actually invoke governed LLM/prompt reasoning on the normal production path.
138. Prompt-driven provider failure cannot silently fall back to an equivalent-authority hard-coded architectural decision.
139. Deterministic responsibilities retain executable deterministic authority.
140. Every migrated responsibility has one canonical owner rather than parallel competing authorities.
141. Obsolete duplicate logic is removed/demoted when responsibility ownership moves.
142. Shared prompt/provider infrastructure is reused instead of creating wrapper sprawl for legacy functions.
143. The coding/runtime implementation stage receives the exact sealed semantic target, not only the original user prompt.
144. Implementation-mode decisions, intended architecture, invariants, write scope, and verification requirements are present in the target-to-runtime handoff.
145. Coding runtimes cannot silently substitute a different architecture and then retroactively rewrite semantics to match.
146. Target amendments require a newly sealed target and reauthorization before additional effects.
147. Human/user/provider permission approval cannot override semantic denial.
148. `accepted_target_digest` recomputes from the exact promoted target rather than being a placeholder/copied verification value.
149. Verification/reconciliation revision fields bind their actual artifacts/state under the canonical revision scheme.
150. Baseline evidence-field tampering or digest copy/paste is detected and cannot produce accepted `SYNCED`.
151. Authorized in-run effects are recorded in a deterministic run-scoped expected-state/effect ledger.
152. Multiple legitimate edits to the same authorized file in one transaction do not falsely trip stale-target detection.
153. External interference with an authorized file is distinguished from the run's own prior writes and blocks/conflicts.
154. Changes to another path inside the allowed write set are not accepted merely because that path was authorized; provenance to the active run is checked.
155. Failed effects do not advance expected state, and rollback keeps the ledger consistent.
156. Final verification checks the complete result against the original sealed target plus the exact authorized effect history.
157. Material non-file effects are represented as typed transaction effects bound to the same semantic change rather than bypassing write-set governance.
158. Dependency/environment/database/service/promotion/destructive-Git effects have deterministic validation, effect evidence, and recovery semantics.
159. The implementation-snapshot inclusion/exclusion logic is itself protected behavior-authoritative code and cannot exclude its own unauthorized changes.
160. Snapshot-boundary changes require explicit semantic authorization and migration/reconciliation proof.
161. Rejected/no-op/already-existing requests do not fabricate new implementation/semantic revisions or advance the accepted baseline without material change.
162. No-op/reject termination revokes any provisional mutation authority and leaves canonical semantic/code synchronization unchanged.

---

# 73. Decisive final scenario

After a clean restart, the user opens Agent_X and types:

`implement this prompt`

The user does not mention semantic-first.

Agent_X must automatically perform:

`request`
→ `create/reserve run identity`
→ `accepted semantic/code sync check`
→ `governed LLM semantic interpretation`
→ `prompt-only / prompt-driven / deterministic-code decision`
→ `run-bound semantic target`
→ `exact mutation authorization`
→ `coding runtime`
→ `implementation`
→ `behavioral verification`
→ `governed semantic enrichment`
→ `bidirectional reconciliation`
→ `canonical baseline promotion`
→ independent `SYNCED` assessment

If any write-capable provider can mutate before the run-bound semantic target exists, continue fixing.

If the backend cannot perform this after a clean startup, continue fixing.

If the stored baseline says `SYNCED` but independent synchronization assessment disagrees, continue fixing.

If all of the above are demonstrably true on actual current `main`, stop.

At that point the semantic-first foundation is genuinely complete.
