# Historical Agent_X semantic-first closure — reduced working contract

Original complete historical instruction: Git blob `2f5b495de7b5c436d87d9cafe75e28901c2e348c` (58789 characters), historical Agent_X main `248f2edac494e0ddafead2fd69a9e9e4cf034eba`. This is a source-derived design and historical defect report, **not** present-day DT code evidence, owner authorization, executed tests or Ground. The complete original remains recoverable from Git history. Current DT parity is UNKNOWN. Do not execute as an active mission.

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

Inspect actual code and canonical state.

# 2. Repair canonical test isolation first
The semantic tests must never mutate real canonical semantic state.

The current test suite includes calls into Harvest reconciliation helpers that can write:

- `semantic_project/project_model.json`
- `semantic_project/semantic_code_sync.json`

This must be fixed before any further reconciliation is trusted.

# 3. Restore canonical semantic model completeness
The canonical project model must not remain:

`semantic_generation_status = incomplete`

for accepted normal operation.

Use the existing governed LLM semantic enrichment system.

# 4. Convert `/api/chat` from authorization checker to actual semantic-first entrypoint
The normal Agent_X UI must be able to receive an ordinary user request such as:

`implement this feature`

and automatically perform semantic-first.

The current behavior must not be:

# 5. Eliminate heuristic write-intent as an authority boundary
`_is_write_operation()` may remain as a routing optimization.

It must **not** be the security/authority decision that determines whether semantic-first can be bypassed.

The current principle must be enforced:

> A write-capable runtime does not receive project mutation authority merely because a natural-language heuristic classified the prompt as read-only.

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

# 8. Make stale-backend enforcement truly fail-closed
Current stale-backend protection must not silently continue when revision binding/checking fails.

At startup:

- compute the authoritative implementation/enforcement revision;
- bind it successfully;
- if binding fails, mark write-capable operation unavailable.

Before every write-capable run:

# 9. Require true semantic-first success in Borg dependencies
`semantic_first` is now correctly classified as non-degradable mandatory authority.

Keep that.

But downstream dependency/coherence rules must require actual semantic success.

The current form:

# 10. Do not count DEGRADED semantic-first as completion anywhere
Audit every place in Borg/orchestration that treats:

`DEGRADED`

as success.

Generic degradable checkpoints may keep that behavior where intended.

# 11. Finish Harvest semantic truth using the canonical pipeline
The current `reconcile_harvest.py` should remain evidence-gathering only or be removed if no longer needed.

It must not mint canonical `SYNCED`.

Use canonical semantic-first reconciliation to finish Harvest state.

The canonical Harvest semantic representation must be built from:

# 12. Complete semantic provenance and confidence correctly
Maintain the distinction:

- `verified` = exact deterministic evidence directly proves it;
- `inferred` = governed LLM architectural interpretation supported by evidence;
- `unknown` = insufficient evidence;
- `unresolved` = known incompleteness;
- `conflicted` = active disagreement.

# 13. Replace the current EVIDENCE_GATHERED baseline with a real canonical reconciliation
The current canonical state must not finish as:

`EVIDENCE_GATHERED`.

That is an intermediate evidence state only.

After all fixes:

# 14. Make canonical state writing transactional
Canonical semantic writes must occur only after successful verification/reconciliation.

Avoid the sequence:

`write project_model`
→ later discover failure.

Prefer:

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


## AI. Whole-project coverage audit
Run deterministic discovery over the actual repository and compare it to canonical semantic bindings.

Expected:

- every behavior-affecting project surface is represented or explicitly/explainably classified as non-architectural/derived evidence;
- frontend/prompts/config/schemas/API/MCP/CLI/provider/governance surfaces are not silently omitted;
- coverage does not depend on a

## AJ. Delete/replace lifecycle
Delete or replace an implementation while preserving, changing, and removing responsibilities in separate cases.

Expected:

- stable semantic identity retained when responsibility is unchanged;
- old bindings superseded/removed;
- removed responsibility no longer marked current;
- replacement does not leave two accidental canonical owners;
- consumers/interfaces update correct

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
- after s

# 16. Test evidence must be real
- a helper function exists;
- an enum contains the expected value;
- a source line contains a gate;
- an import succeeds;
- a fixture says `SYNCED`.

Tests must exercise the production path.

For example:

Bad proof:

# 17. Read-only vs write-capable must be enforced by capability, not prose alone
The safest architecture is:

- truly read-only runtime/tools may answer without mutation transaction;
- any runtime with project-write capability is governed by semantic-first before write authority is available.

If Agent_X wants to answer code questions through OpenCode/Codex without semantic overhead:

- invoke that runtime in a technically enforced read-only mode;
- do not merely trust the prompt classifier.

# 18. Prompt-only / prompt-driven / deterministic-code decisions must remain automatic
For every material change, the semantic-first target must determine which responsibilities should be:

- prompt-only;
- prompt-driven with deterministic enforcement;
- deterministic-code-driven.

Preserve the architecture principle:

`semantic reasoning decides the implementation form`

# 19. Final fresh audit
After implementation and tests, perform a fresh audit from the actual current `main`.

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
-

# 20. Final completion criteria
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
13. Semantic authorization is bound to the exact current run/request/wo

## Verification boundary and relevance

The 38 A–AL tests above are historical proposed falsifiers, not run results. Preserve separate semantic current/target identities, exact run/change/source/effect authorization, real caller paths, atomic evidence and restart/no-loss behavior. No stored SYNCED label, provider completion or prompt-only assertion constitutes independent Ground. Recheck current DT owner and code before any proposal; B1 owner integrity disposition and B7 authenticated mission consumption remain independently unresolved unless current Director evidence proves otherwise.
