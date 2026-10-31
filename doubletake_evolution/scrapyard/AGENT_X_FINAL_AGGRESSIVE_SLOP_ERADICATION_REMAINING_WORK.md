# Agent_X `/tools/` Final Aggressive Slop Eradication — Remaining Work Only

## Status

The previous pass made real progress and must not be repeated.

Completed and offloaded:

- legacy placeholder population removed;
- canonical harvested algorithms preserved;
- typed authoring outcomes implemented;
- deterministic author no longer fabricates code;
- packet-era codec helpers largely removed;
- evidence token mining moved to `evidence_text.py`;
- stale bucket runtime artifacts purged;
- stale write-code ledger successes purged;
- SOURCE_CAP-based identity mostly removed;
- packet-era refresh constants removed;
- substance/test-evidence gates strengthened;
- behavioral tests executed before canonical promotion;
- approximately 462 production LOC removed from the primary hotspots.

Do not reopen those items unless a regression is proven.

---

# 1. Critical Remaining Defect: Two Promotion Engines Still Exist

The current remediation report says:

> `coding_loop` no longer runs a parallel canonical-owner/merge/promotion engine beside `assimilation_governance`.

That statement is not true in the current source.

`tools/agentx_evolve/collective_core/coding_loop.py::_run_integrate()` still directly performs:

- domain/target-directory resolution;
- host discovery;
- source merge;
- selective refresh;
- new-module creation;
- duplicate-content checks;
- collision handling;
- rollback snapshots;
- import/smoke verification;
- live test writing;
- live test execution;
- package `__init__.py` wiring;
- entry-point discovery;
- MCP manifest registration;
- integration-ledger recording.

Meanwhile:

`tools/agentx_evolve/collective_core/assimilation_governance.py::promote_candidate()`

already provides the canonical transaction for:

- canonical-owner resolution;
- PATCH vs CREATE;
- collision rejection;
- canonical containment;
- candidate merge;
- package wiring;
- substance gate;
- behavioral-test evidence;
- behavioral-test execution;
- manifest sealing;
- rollback;
- provenance;
- promotion ledger.

This is duplicate architecture and must be removed.

---

# 2. Required End State for `coding_loop.py`

`coding_loop.py` must stop being a second source-code integration engine.

Its responsibility should become approximately:

```text
harvest inventory
    ->
filter / prioritize / semantic dedupe
    ->
author candidate
    ->
verify candidate is worth attempting
    ->
stage candidate + metadata
    ->
call canonical promotion authority
    ->
report promotion outcome
```

For integration, it should call a single canonical API based on:

```python
assimilation_governance.promote_candidate(...)
```

or a very small canonical wrapper around it.

Do not create a third abstraction merely to wrap both old systems.

The old direct integration path must be deleted after equivalence tests pass.

---

# 3. Delete the Duplicate Integration Machinery From `coding_loop.py`

After rewiring `_run_integrate()` to canonical promotion, aggressively audit and delete helpers that become unnecessary.

Likely deletion candidates include, where no independent production caller remains:

- `_find_host_file`
- `_host_relevance_score`
- `_refresh_merged_bodies`
- `_refresh_host_selective`
- `_live_has_extra_defs`
- `_merge_into_host`
- `_find_existing_by_stem`
- `_rename_authored_module`
- `_resolve_arch_dir`
- local domain-host tables duplicated by assimilation governance
- `_import_and_smoke`
- `_write_live_test`
- `_run_live_test`
- `_wire_subsystem_init`
- `_live_entry_name`
- `_qualified_module`
- local rollback machinery inside `_run_integrate`
- direct `ToolManifest` / `register_mcp_tool` use from `_run_integrate`
- direct canonical-source filesystem writes from `_run_integrate`

Do not blindly delete by name.

First rewire the actual runtime path to `promote_candidate`, then perform caller analysis and delete everything no longer needed.

Goal:

> `coding_loop.py` may prepare and submit a candidate, but it must not know how canonical source promotion is physically performed.

---

# 4. Eliminate Split-Brain Promotion State

Currently the coding path has its own:

`coding_integrate_ledger.json`

while canonical promotion has its own candidate/promotion ledger.

Determine exactly what unique information `coding_integrate_ledger.json` still provides.

If it is only duplicating:

- source digest,
- target path,
- status,
- code digest,
- promotion outcome,
- timestamp,

then migrate any required UI/job-summary fields elsewhere and remove it as a promotion authority.

There must be one source of truth for:

```text
was this candidate promoted?
where?
under which owner?
with what digest?
with what test?
with what provenance?
```

The answer should be the canonical promotion/candidate ledger, not two ledgers that can disagree.

A lightweight coding-job progress record is acceptable.

A second authoritative promotion ledger is not.

---

# 5. Fix the Promotion API Instead of Preserving Coding-Loop Workarounds

If `promote_candidate()` lacks something the coding UI genuinely requires, add the smallest required capability to the canonical promotion API.

Examples may include:

- explicit update-vs-create intent;
- caller-provided filter metadata;
- returning a UI-friendly result;
- indicating `already_done`;
- indicating unresolved owner;
- exposing the canonical destination.

Do not use a missing convenience feature as justification for retaining a 500–1000 line duplicate promotion engine.

---

# 6. Canonical Promotion Must Support Existing Real Behavioral Tests

When rewiring updates:

- do not allow PATCH promotion to bypass meaningful testing merely because a host already has tests;
- run the candidate-specific behavioral test when one exists;
- run affected canonical subsystem tests where practical;
- retain transactional rollback.

The result should be at least as strict as the existing coding-loop path, preferably stricter.

---

# 7. The 550 `SCAFFOLD_ONLY` Markers Are Now the Largest Known Slop Reserve

The current report says approximately 550 `SCAFFOLD_ONLY` markers remain and sampled groups have zero production/test importers, but they were retained because some Makefile proof flows and skeleton-contract existence tests expect them.

That is not sufficient justification.

This pass must perform a real subsystem-by-subsystem scaffold purge.

For every `SCAFFOLD_ONLY` file/component:

## A. Determine whether real runtime behavior exists

Check:

- production imports;
- registry/manifest use;
- CLI invocation;
- API invocation;
- Makefile invocation;
- dynamic loader references;
- configuration references;
- generated shell scripts;
- CI scripts;
- documentation claiming supported runtime behavior.

## B. Classify

Use exactly one:

```text
REAL_RUNTIME
TEST_FIXTURE
BUILD/PROOF_FIXTURE
EMPTY_ARCHITECTURAL_PLACEHOLDER
DEAD_GENERATED_SCAFFOLD
OBSOLETE_COMPATIBILITY
```

## C. Delete aggressively

Delete:

- `EMPTY_ARCHITECTURAL_PLACEHOLDER`
- `DEAD_GENERATED_SCAFFOLD`
- `OBSOLETE_COMPATIBILITY`

For `BUILD/PROOF_FIXTURE`:

- determine whether the proof is testing real behavior or merely proving the scaffold exists;
- if it proves only existence/shape, delete the fixture and delete/rewrite the proof;
- if a Makefile target exists solely to prove fake skeleton completeness, remove the target.

For `TEST_FIXTURE`:

- keep only when it intentionally simulates a condition for a real runtime test;
- move into test fixture directories where appropriate;
- do not keep test-only fake code in production packages.

---

# 8. Skeleton-Contract Tests Do Not Automatically Win

Tests under paths such as:

```text
tests/skeleton_contracts/
```

must be challenged.

For each skeleton-contract test, ask:

> Does this test protect behavior that Agent_X currently needs, or does it merely require architectural placeholders to exist?

If the latter:

- delete the test;
- delete the scaffold;
- remove any Makefile proof target tied only to that scaffold.

Do not keep 550 fake components because an old test suite demands 550 fake components.

Tests follow architecture.

Architecture does not serve obsolete tests.

---

# 9. Require Large Net Reduction From the Scaffold Pass

The previous pass removed ~462 production LOC from known hotspots.

The remaining scaffold population is much larger.

For this pass, report:

- number of `SCAFFOLD_ONLY` files inspected;
- number deleted;
- number converted to test fixtures;
- number retained as real runtime;
- number of skeleton-contract tests deleted;
- number of Makefile targets deleted;
- production LOC removed;
- test/proof LOC removed.

Do not set an arbitrary deletion quota, but a result such as:

```text
550 inspected
5 deleted
545 retained because tests exist
```

is unacceptable without extraordinary evidence.

---

# 10. Resolve the Five Remaining `test_coding_loop.py` Failures

The current report lists five failures:

- one domain-route-table test because mapped peer directories are absent;
- four harvest-envelope content tests due `_build_knowledge_doc` wording drift.

Do not leave them as permanent “baseline failures” without resolving the contract.

For the route-table failure:

- either the directories are required and missing -> fix architecture;
- or they are optional/nonexistent -> fix the route table/test;
- or the test is obsolete -> delete it.

For the four wording tests:

- determine whether wording is part of a real digest/API contract;
- if yes, fix code intentionally;
- if no, stop snapshot-testing prose and rewrite/delete the tests.

Target: zero failures in `test_coding_loop.py`.

---

# 11. Remove Stale Comments That Still Describe the Old Architecture

Examples still visible include language such as:

```text
production steps are fast (deterministic codec)
```

even though deterministic packet-code generation was removed.

Audit `coding_loop.py` and related files for comments describing:

- deterministic codec authoring;
- old SOURCE_CAP identity;
- packet generation;
- generic dispatch contracts;
- old direct integration responsibilities after those responsibilities move.

Delete or rewrite stale comments.

Comments must describe current architecture.

---

# 12. Simplify `INTEGRATE_SYSTEM_PROMPT`

Once `coding_loop.py` no longer performs promotion itself, the integration prompt should not duplicate the entire promotion algorithm.

It should instruct the reasoning/decision layer to determine:

- candidate intent;
- canonical owner evidence;
- PATCH / CREATE / REJECT recommendation;
- rationale.

The actual mutation semantics must belong to canonical code.

Do not encode canonical write mechanics twice:

```text
prompt version
+
Python implementation version
```

The prompt describes decisions.

The canonical promotion code enforces mutations.

---

# 13. Re-audit `write_code_e2e.py` for Non-Core Responsibilities

After the previous cleanup it is still ~1481 lines.

Audit whether all of these belong in the write-code stage:

- safe regex refactoring pass;
- bytecode cleanup pass;
- direct manifest registration;
- worthiness scoring;
- staging author decisions;
- utility sanitization;
- ledger implementation.

Do not split merely for aesthetics.

But if a responsibility:

- has no production caller,
- is only tested directly,
- is unrelated to authoring,
- duplicates another subsystem,

delete or move it to the existing owner.

In particular, determine whether the generic `_refactor_pass` is actually used by the current assimilation runtime or is historical “do extra stuff while here” architecture.

Remove opportunistic side jobs from the authoring path when they have no current value.

---

# 14. No More Bounded Whole-Tools Audit

The prior report calls its 6,234-file audit “bounded.”

The user explicitly wants aggressive slop removal.

Perform the audit recursively across:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

Focus by descending expected slop yield:

1. `SCAFFOLD_ONLY`
2. generated naming families
3. duplicate file digests
4. test-only production modules
5. empty/trivial packages
6. unreferenced shims
7. obsolete manifests
8. compatibility paths
9. proof-only CLI harnesses
10. stale generated comments
11. dead Makefile targets
12. unused private helpers

Do not stop at sampling once a repeated slop family is identified.

Process the family.

---

# 15. Evidence Required to Retain Suspicious Code

For suspicious code to survive, record at least one concrete reason:

```text
production import from <path>
runtime registry entry <name>
API endpoint <name>
CLI entry <name>
Makefile target used by real CI/runtime proof <target>
dynamic loader pattern <pattern>
test fixture for real behavior <test>
```

Reasons such as:

```text
could be useful
tests expect it
Makefile mentions it
architecturally nice
future work
owner review needed
```

are insufficient by themselves.

---

# 16. Update the Remediation Report Truthfully

The current report must be corrected after this pass.

In particular, do not retain the statement that `coding_loop.py` no longer runs a parallel promotion engine until the direct integration code has actually been removed.

The report should distinguish:

```text
completed
partially completed
remaining
```

with evidence.

Do not report desired architecture as if it were already implemented.

---

# Acceptance Criteria

This pass is complete only when:

- [ ] `_run_integrate()` delegates canonical source promotion to `assimilation_governance.promote_candidate()` or one authoritative equivalent.
- [ ] `coding_loop.py` no longer directly merges/writes canonical source modules.
- [ ] `coding_loop.py` no longer owns its own rollback transaction for canonical source promotion.
- [ ] `coding_loop.py` no longer directly wires canonical `__init__.py` files.
- [ ] `coding_loop.py` no longer directly writes canonical MCP manifests.
- [ ] duplicate host-selection/merge/create helpers are deleted.
- [ ] duplicate live-test/promotion helpers are deleted where canonical promotion owns them.
- [ ] one authoritative promotion/provenance ledger remains.
- [ ] all 550 `SCAFFOLD_ONLY` occurrences are classified, not merely sampled.
- [ ] dead scaffold families are deleted together with existence-only tests/proofs.
- [ ] production test fixtures are moved out of runtime packages where appropriate.
- [ ] `test_coding_loop.py` has zero unresolved failures or every remaining failure has a concrete external blocker.
- [ ] stale packet/codec comments are gone.
- [ ] the remediation report no longer overclaims duplicate-engine removal.
- [ ] final whole-tools scan shows a substantial additional net LOC/file reduction.
- [ ] no real canonical algorithm or Borg runtime behavior regresses.

---

# Final Instruction

The previous pass successfully removed debris around the new architecture.

This pass must finish the architectural consolidation.

The biggest remaining mistake is not a fake algorithm anymore.

It is:

> **two different systems still know how to promote code into the live Agent_X tree.**

There must be one.

After that, attack the 550 scaffold population as a deletion project, not as an owner-review backlog.

The burden of proof remains on code that wants to survive.
