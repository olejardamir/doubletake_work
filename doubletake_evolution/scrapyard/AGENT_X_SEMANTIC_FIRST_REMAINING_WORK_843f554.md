# Agent_X Semantic-First — Remaining Work Only

Current audited `main` at the time this prompt was written:

`843f554a5759c96557a11731178f4426cbe16910`

Do not assume that SHA is still current. Begin by checking the actual current `main`.

## Purpose

This file is intentionally **offloaded/rebased**.

It contains only:

1. unresolved work still required to finish the semantic-first task;
2. a small set of non-regression invariants protecting work already completed;
3. final acceptance tests required before declaring the task complete.

Do **not** redo work already present on `main`.

Do **not** re-implement semantic-first from scratch.

Do **not** redesign Harvest, Borg, the UI, provider architecture, Git handling, or the semantic model generally unless one of the remaining defects below requires a narrow correction.

Do **not** add CI/CD or GitHub Actions work.

Do **not** introduce a dedicated Architectural MCP.

Use the existing canonical semantic-first, mutation-authority, provider, verification, reconciliation, rollback, and synchronization stack.

---

# Remaining defect 1 — Baseline evidence fields are still placeholders, not real proof

The current accepted synchronization baseline contains values equivalent to:

- `accepted_target_digest = "structural-correction"`
- `verification_digest = "deterministic-verification"`

These are labels, not cryptographic bindings to the actual semantic target and verification artifacts.

A baseline must not be accepted as `SYNCED` merely because:

- its fields are non-empty;
- the outer `baseline_digest` recomputes.

The outer digest proves only that the JSON is internally self-consistent.

It does not prove that its target/verification fields refer to real issued evidence.

## Required fix

Make baseline promotion consume real issued artifacts or verified artifact references.

### `accepted_target_digest`

Must recompute from the exact sealed semantic target/overlay that authorized the implementation.

It must bind:

- change ID;
- run ID;
- workspace/repository identity;
- base semantic revision;
- base implementation revision;
- immutable request identity;
- intended architecture;
- prompt-only / prompt-driven / deterministic decisions;
- exact write/effect scope;
- verification requirements.

Reject:

- labels;
- placeholders;
- random SHA-looking strings;
- manually copied digests;
- digests unrelated to the promoted target.

### `verification_digest`

Must recompute from canonical verification evidence that binds:

- exact change ID;
- exact target digest;
- exact run/workspace;
- exact resulting implementation revision;
- exact changed/effected resources;
- exact tests/checks/results;
- verification issuance state;
- promotion/consumption state.

### `reconciliation_revision`

Must be produced by the canonical reconciliation process from the final accepted semantic state.

Do not allow callers to supply arbitrary values merely to satisfy a field.

## Required validation

Loading or assessing a baseline must reject it when:

- target evidence is missing;
- verification evidence is missing;
- evidence digest does not recompute;
- evidence belongs to another run/change;
- evidence refers to an older implementation revision;
- evidence was already consumed into another accepted baseline;
- target and verification fields are copied from each other without schema-defined equivalence.

## Required tests

Reject all of:

- `"structural-correction"`;
- `"deterministic-verification"`;
- arbitrary 64-hex values with no artifact;
- verification from another run;
- target from another change;
- stale verification;
- replayed verification;
- deleted/missing artifact;
- copied target/verification digest.

Final accepted baseline must contain only real recomputable evidence.

---

# Remaining defect 2 — `implementation_revision` still includes non-production repository material

The earlier runtime-state pollution was partially fixed.

However the current production snapshot still includes material that is not actual Agent_X production implementation, including examples such as:

- `tools/agentx_evolve/tests/test_*.py`;
- `benchmarks/.../tests/...`;
- `MAIN_DOCS/WISHLIST/...`;
- research/design documents;
- torrent/archive/reference material;
- human-only reports/plans.

A test change, wishlist edit, or research-document edit must not produce `IMPLEMENTATION_AHEAD` when runtime behavior did not change.

## Required fix

Replace broad tracked-file inclusion with deterministic artifact-role classification.

Every artifact considered by the snapshot system must resolve to the canonical equivalent of:

- production code;
- production frontend;
- runtime prompt;
- runtime config;
- runtime schema/contract;
- runtime-required production data;
- verification test;
- verification/CI/proof evidence;
- canonical semantic state;
- runtime-generated state;
- human documentation;
- research/reference;
- wishlist/future design;
- archive/dataset;
- secret/private/external;
- unknown.

Only actual runtime-authoritative production roles contribute to `implementation_revision`.

## Non-code files

Do not classify every Markdown/JSON/YAML/TXT/CSV file as runtime-authoritative.

A non-code file counts as production implementation only when deterministic evidence proves that current production Agent_X consumes it, or a protected runtime registry explicitly declares it.

Examples:

- runtime-loaded system prompt → production;
- runtime-loaded governance policy → production;
- runtime-loaded schema → production;
- wishlist document → not production;
- research report → not production;
- torrent/archive → not production;
- historical implementation report → not production.

## Tests and evidence

Test/CI/proof source belongs to verification evidence, not production implementation.

A change to a test may invalidate prior verification evidence, but must not claim that the production implementation itself changed.

Maintain a separate deterministic evidence/test revision if needed.

## Unknown classification

Do not silently treat `unknown` as production merely because Git tracks the file.

Resolve the role or fail closed where the distinction matters.

## Required real-repository tests

At minimum prove:

- `tools/agentx_evolve/api/chat.py` change → implementation revision changes;
- real `ui/src/...` production change → changes;
- actual runtime-loaded prompt → changes;
- actual runtime-loaded config/schema → changes;
- `tools/agentx_evolve/tests/test_snapshot_boundary.py` change → production implementation revision does not change;
- `benchmarks/.../tests/...` change → production implementation revision does not change unless explicitly production;
- `MAIN_DOCS/WISHLIST/...` change → does not change;
- torrent/archive reference change → does not change;
- human documentation change → does not change;
- runtime logs/history/cache change → does not change;
- new untracked production code → is visible before commit.

After this correction, regenerate the production implementation revision canonically.

---

# Remaining defect 3 — Accepted semantic model is still stale/polluted by test-only capabilities

The current generator now recognizes nested test paths better.

But the currently accepted canonical model still contains pure test-suite capabilities such as:

`benchmarks.benchcore.tests`

This means the accepted model was not cleanly regenerated and promoted under the corrected discovery rules.

## Required fix

Do not manually delete individual JSON objects.

Perform a clean candidate regeneration using the corrected deterministic discovery plus governed LLM enrichment.

### Test material belongs in evidence

Test modules should normally appear under:

- test inventory;
- verification evidence;
- provenance;
- `verified_by` relationships.

They should not automatically become:

- production capabilities;
- production responsibilities;
- production invariants;
- governance owners.

### Production invariant ownership

A test may verify a real invariant.

The production responsibility owns/enforces the invariant.

The test is evidence that verifies it.

Do not create production invariants whose owner is simply:

`tools.agentx_evolve.tests.test_*`

### Exclude semantic slop

Candidate model quality checks must reject or resolve:

- pure test-suite capabilities;
- CI/proof-only capabilities with no production responsibility;
- capabilities created solely from wishlist/research documents;
- duplicate responsibilities;
- conflicting owners;
- orphan capabilities;
- stale identities from replaced/deleted implementations;
- arbitrary test assertions promoted as architecture.

### Stable identities

Preserve stable semantic IDs for real unchanged production responsibilities.

Do not churn capability IDs simply because the model was regenerated.

## Required acceptance

In the regenerated candidate model:

- `benchmarks.benchcore.tests` must not be a production capability unless deterministic evidence proves it actually owns runtime production behavior;
- no capability may consist only of test files unless explicitly production;
- arbitrary assertions from nested test files must not appear as production invariants;
- real tests remain available as verification evidence.

Only after this quality check may the candidate model become accepted current semantic truth.

---

# Remaining defect 4 — Committed canonical state is still tied to one absolute checkout path

The accepted baseline currently stores an absolute machine path equivalent to:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X`

and synchronization assessment still treats that absolute path as canonical acceptance identity.

That breaks portability.

The same committed Agent_X project checked out at another path should not require rewriting canonical semantic truth merely because the local path differs.

## Required fix

Separate:

### Portable canonical project identity

Committed accepted state should bind to:

- repository identity;
- semantic revision;
- production implementation revision;
- portable source bindings;
- artifact-backed target/verification/reconciliation evidence.

### Local run identity

Active mutation authorization should bind to:

- absolute local workspace root;
- worktree ID;
- workspace ID;
- workspace epoch;
- run ID;
- local transaction state.

A transaction from checkout A must never authorize checkout B.

But the accepted canonical baseline itself must remain usable in B.

## Fresh-checkout test

1. Produce accepted canonical state in checkout A.
2. Check out the exact same committed `main` into checkout B at a different absolute path.
3. Do not rewrite canonical semantic files.
4. Bind B locally.
5. Independent synchronization assessment in B must return `SYNCED`.
6. A transaction created in A must still fail authorization in B.

---

# Remaining defect 5 — Browser-disconnect background completion can bypass semantic finalization

Foreground provider routes have improved.

But the OpenCode background-disconnect helper still effectively does:

provider task finishes
→ provider/run reconciliation
→ mark run `completed`

without guaranteeing canonical semantic:

verification
→ enrichment
→ reconciliation
→ baseline promotion.

That is a production completion bypass.

## Required fix

Background completion must use the same semantic finalization contract as foreground completion.

Required sequence:

1. provider execution finishes;
2. provider telemetry/run record reconciles;
3. durable status becomes an intermediate state such as `provider_completed` / `verifying`;
4. call canonical `finalize_ui_run()` or the one canonical equivalent;
5. verify implementation effects;
6. enrich/reconcile semantic state;
7. promote canonical baseline if effects occurred;
8. only then set durable status `completed`.

If finalization fails:

- run becomes failed/conflicted;
- transaction authority is revoked;
- rollback or explicit conflict occurs;
- never mark completed.

## Required tests

Test background lifecycle for:

- browser disconnect before any effect;
- disconnect after partial effect;
- disconnect after provider finished but before semantic finalization;
- verification success;
- verification failure;
- provider exception;
- timeout;
- restart during background finalization.

No background path may produce `completed` without semantic finalization.

---

# Remaining defect 6 — LLM7/MCP tool authorization still falls back to wildcard on unknown effects

Current LLM7 tooling improved exact-path checks.

But when no recognized path can be extracted from arguments, it still falls back to wildcard authorization.

That assumes:

“no recognized file path”
≈
“read-only or harmless”

which is false.

Effectful tools may mutate:

- Git;
- database state;
- dependency environment;
- service config;
- multiple files;
- remote durable state;
- resources encoded under different argument names.

## Required fix

Use deterministic typed tool-effect contracts from the canonical tool/MCP registry.

Every tool must resolve to one of the canonical equivalents of:

- read-only;
- exact file effect;
- bounded multi-file effect;
- Git effect;
- database/durable-state effect;
- dependency/environment effect;
- service/runtime-config effect;
- remote durable effect;
- unknown/opaque effect.

The registered contract must define how validated tool arguments map to exact resources/effect parameters.

## Execution rule

Only genuinely read-only tools may execute without mutation authorization.

Every effectful tool must pass:

semantic authorization
AND
tool/MCP governance
AND
other required approval.

Unknown/opaque effect:

DENY

unless the semantic target is amended/resealed first.

No wildcard transaction-existence check may serve as final effect authority.

## Required tests

Test:

- file write to authorized path;
- file write outside scope;
- multi-file write;
- unusual resource argument name;
- Git reset/checkout/commit;
- DB mutation;
- dependency install;
- service-config mutation;
- remote durable write;
- truly read-only query;
- tool incorrectly declared read-only but observed attempting mutation.

Semantic denial must always win.

---

# Remaining defect 7 — Legacy semantic transaction pile and terminal overlay lifecycle

The user has real local legacy files such as:

`semantic_project/changes/<change_id>.json`

Current code no longer intends this to be the active transaction location, but there is still no explicit migration/cleanup path.

Also terminal run transactions can remain semantically `active` after no-effect or terminal completion.

## Required fix A — migrate legacy `semantic_project/changes/`

Implement a bounded one-time migration/cleanup.

For every legacy overlay:

1. validate schema/digest if possible;
2. determine whether it is referenced by:
   - active run;
   - unresolved conflict;
   - recovery state;
   - accepted historical evidence;
3. if still required, migrate it to the correct run/conflict authority location;
4. if terminal/stale and no longer authoritative, compact/remove it;
5. retain only bounded immutable audit metadata when genuinely needed.

Do not blindly delete the entire directory.

After migration:

- `semantic_project/changes/` is never an active authority location;
- add `semantic_project/changes/` to ignore/protection rules;
- correct stale comments/docstrings that still describe it as the normal overlay store;
- restart protection must stop old backends from continuing to create new files there.

## Required fix B — terminalize overlays

`active` must mean live mutation authority only.

A transaction ending in any of these states must transition out of `active`:

- successful reconciliation;
- no-op;
- rejected;
- aborted;
- superseded;
- rolled back;
- unresolved conflict.

Use explicit terminal lifecycle states.

No-effect successful run must become `noop` or equivalent.

Successful promoted run must become `reconciled`/`accepted`.

Failed run must become `aborted`/`rejected`/`conflicted` as appropriate.

## Required fix C — bounded retention

Keep full transaction payload only while:

- active;
- recovering;
- unresolved/conflicted.

After safe terminalization:

- compact/remove bulky run-local transaction artifacts after the recovery window;
- keep only bounded audit records/digests;
- let existing run cleanup remove expired terminal state.

Repeated ordinary UI requests must not create an unbounded permanent pile in any directory.

---

# Final remint — discard the currently self-declared `SYNCED` baseline

The current baseline must not be preserved as final authority after these changes.

Once Remaining Defects 1–7 are fixed:

1. treat the current baseline as historical/disputed input;
2. compute corrected production implementation snapshot;
3. compute verification/evidence revision separately;
4. generate clean candidate semantic model;
5. run governed LLM semantic enrichment;
6. run semantic quality validation;
7. run actual production behavioral verification;
8. produce real sealed target artifact;
9. produce real issued verification artifact;
10. reconcile semantic state against production implementation;
11. construct the new baseline through the canonical builder;
12. persist model + baseline transactionally;
13. reload them;
14. validate every inner artifact binding/digest;
15. independently run synchronization assessment;
16. run the fresh-checkout portability test;
17. run a no-change second assessment.

The final state is acceptable only if both assessments independently return:

`SYNCED`

with no unresolved conflict.

---

# Non-regression contract — do not redo these, just prove they still hold

The following capabilities are already materially present on current `main`.

Do not replace them unless a remaining defect requires a narrow correction.

Prove they still work:

- startup implementation binding uses canonical `implementation_revision(source_snapshot(...))`;
- startup binding is fail-closed;
- normal UI mutation reserves run identity before semantic authorization;
- active transaction state is run-local rather than shared canonical transaction state;
- UI uses canonical `SemanticFirstCheckpoint` semantics;
- governed LLM provider is required for architectural authorization;
- structural fallback alone cannot authorize architecture;
- semantic-first is mandatory/non-degradable in Borg;
- downstream semantic-dependent work requires a valid mandatory-authority result;
- run/workspace/change authorization is bound to the active transaction;
- exact file effects are checked against the write set;
- stale backend blocks new write-capable runs;
- provider completion is not supposed to equal semantic completion;
- test execution remains isolated from canonical production semantic files;
- one-off Harvest reconciliation cannot independently mint `SYNCED`;
- canonical semantic generation status must be `complete`;
- code-only / semantic-only / both-diverged states remain explicit conflicts;
- Git HEAD is evidence, not semantic or implementation revision authority.

---

# Required final production tests

Do not certify by source-string checks alone.

Use real production seams or isolated production-equivalent seams.

At minimum run:

## Normal UI mutation

ordinary user request
→ reserve run
→ semantic-first
→ sealed target
→ provider write authorization
→ exact effects
→ verification
→ enrichment
→ reconciliation
→ baseline promotion
→ `completed`
→ independent `SYNCED`.

## Read-only request

true technically read-only execution:

- succeeds;
- creates no mutation transaction;
- grants no write authority;
- changes no canonical semantic state.

## Semantic provider unavailable

Write-capable request:

- blocked;
- no provider write authority;
- no structural fallback authorization.

## Wrong write/effect scope

Attempt out-of-scope mutation:

- denied.

## Background disconnect

Provider finishes after browser disconnect:

- semantic finalization still runs;
- no direct completion bypass.

## Tool effect authorization

Effectful MCP/LLM7 tool:

- exact typed effect required;
- opaque/wildcard effect denied.

## Stale backend

Modify protected enforcement source while backend runs:

- new write-capable request blocked;
- restart required.

## Conflict detection

Verify:

- implementation-only drift;
- semantic-only drift;
- both-diverged drift.

## Test/evidence-only change

Change test-only code:

- evidence revision changes as appropriate;
- production implementation revision does not.

## Wishlist/document change

Change non-runtime wishlist/research document:

- production implementation revision does not change.

## Runtime prompt change

Change a real runtime-consumed prompt:

- production implementation revision changes.

## Legacy transaction migration

Populate old `semantic_project/changes/` with representative:

- stale;
- completed;
- unresolved;
- active/referenced;

records.

Migration must preserve only what remains authoritative and clean the rest safely.

## Fresh checkout

Same exact committed tree at a different absolute path:

- canonical state loads unchanged;
- local binding succeeds;
- independent `SYNCED`.

---

# Completion conditions

Do not stop until all are true:

1. No placeholder target/verification evidence exists in accepted baseline.
2. Every accepted evidence digest recomputes from a real artifact.
3. Baseline load/assessment validates inner artifact provenance, not just outer JSON digest.
4. Production implementation revision contains only runtime-authoritative production artifacts.
5. Test-only source is evidence, not production implementation.
6. Wishlist/research/archive/torrent material is not production implementation.
7. Runtime prompts/configs/schemas are included only when deterministic production consumption is proven.
8. Separate evidence/test revision exists where necessary.
9. Canonical semantic model has been cleanly regenerated from corrected discovery.
10. Pure test-suite capabilities are absent unless explicitly production.
11. Arbitrary test assertions are absent as production invariants.
12. Stable semantic identities survive regeneration where meaning did not change.
13. Canonical committed state is portable across absolute checkout paths.
14. Active transactions remain strictly local-workspace-bound.
15. Background OpenCode completion always executes semantic finalization.
16. Background failures cannot become `completed`.
17. LLM7/MCP uses typed effect contracts, not wildcard fallback for unknown effects.
18. Unknown/opaque effectful tools are denied.
19. Legacy `semantic_project/changes/` is migrated/cleaned safely.
20. `semantic_project/changes/` cannot accumulate again under current code.
21. Terminal overlays never remain semantically `active`.
22. Terminal transaction retention is bounded.
23. New accepted baseline is minted only after corrected snapshot/model/evidence semantics are active.
24. Final target digest comes from the exact promoted target.
25. Final verification digest comes from exact issued verification evidence.
26. Final implementation revision recomputes from corrected production snapshot.
27. Final semantic revision recomputes from accepted model.
28. Final baseline digest recomputes.
29. Independent synchronization assessment returns `SYNCED`.
30. Fresh checkout at another path independently returns `SYNCED`.
31. Second no-change assessment remains `SYNCED`.
32. Ordinary UI write request performs the entire lifecycle automatically without user mentioning semantic-first.
33. No write-capable runtime can mutate before a valid semantic target exists.
34. No provider/background/tool path can report success before semantic finalization.
35. No unbounded semantic transaction junk pile remains.

---

# Stop condition

Stop only when actual current `main` demonstrates all of the above.

Do not stop because:

- commit message says fixed;
- JSON contains `"SYNCED"`;
- AGENTS.md says complete;
- test names imply coverage;
- source contains the expected function names.

Stop only when the production behavior and independently recomputed canonical semantic/code state prove the task is complete.
