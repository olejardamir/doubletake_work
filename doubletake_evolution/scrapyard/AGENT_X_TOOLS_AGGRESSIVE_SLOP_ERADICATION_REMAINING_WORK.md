# Agent_X `/tools/` Algorithmic Substance + Aggressive Slop Eradication — Remaining Work Only

## Mission

Continue work only on:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

The previous remediation fixed the core placeholder-generation defect. Do **not** redo completed work.

This pass has two goals:

1. finish any remaining correctness/verification gaps in the harvest → coding → assimilation → promotion path;
2. **aggressively delete obsolete, duplicated, compatibility-only, packet-era, generated, test-pinned, and otherwise low-value slop from the entire `tools/` tree.**

The deletion bias for this pass is intentional:

> If code has no demonstrated current runtime purpose, canonical architectural ownership, or meaningful testable behavior, prefer deleting it rather than preserving it “just in case.”

Do not confuse “old tests still reference it” with “production needs it.”  
Tests that exist only to preserve dead architecture should be deleted or rewritten together with that architecture.

Correctness and current runtime behavior remain mandatory. This is not permission to randomly delete working core systems.

---

# 1. Completed Work — Offloaded From This Prompt

Treat the following as complete unless direct current-code inspection proves a regression.

Do not spend another iteration rebuilding these items.

## Legacy placeholder cleanup

Already completed:

- 159 legacy harvest-template placeholder modules removed.
- 180 paired import-only/non-behavioral tests removed.
- provenance preserved in `harvest_remediation_audit.json`.
- underspecified harvested knowledge retained as `CONCEPT_ONLY`, not fabricated.
- duplicate harvest records consolidated.
- seven canonical real algorithm families created under `harvested_algorithms/`:
  - adaptive mutation
  - elite preservation
  - hybrid ranking
  - semantic deduplication
  - ranked selection
  - lineage GC
  - ingest gate
- unverified numeric source claims removed from live capability claims.
- stale manifests and large generated `__init__.py` import blocks cleaned.
- duplicate superior-intelligence shim retired.
- synthesized manifest reduced and resealed.

## Future authoring architecture

Already completed in current code:

- `AuthoringOutcome` / `AuthoringResult` now distinguish:
  - `REAL_IMPLEMENTATION`
  - `ALREADY_EXISTS`
  - `CONCEPT_ONLY`
  - `DEFERRED`
  - `REJECTED`
- deterministic/default author no longer fabricates an executable assimilation packet.
- default author returns metadata-only decisions with `code=None` and `test_code=None`.
- duplicate evidence can resolve to `ALREADY_EXISTS`.
- vague evidence can resolve to `CONCEPT_ONLY`.
- potentially codable but unresolved evidence can resolve to `DEFERRED`.
- only an injected real author can supply `REAL_IMPLEMENTATION`.
- non-code decisions do not create `.py` files and do not register runtime tools.
- filename suffixing was limited to temporary/staging identity; canonical live promotion forbids `_2`, `_3`, etc.
- canonical-name collision now means resolve ownership/merge/defer, not create a sibling.

## Candidate verification

Already completed:

- `_verify_candidate()` no longer requires:
  - `SOURCE_CAP`
  - a ceremonial dataclass
  - `is_valid()`
  - `_main()`
  - universal `dispatch()` / `process()`
- provenance can live in metadata rather than implementation constants.
- candidate verification now requires a real callable API and behavioral-test evidence.
- `_smoke_candidate()` no longer imposes universal:
  - `DOMAIN_FIELDS`
  - `REQUIRED_FIELDS`
  - `THRESHOLDS`
  - generic verdict/status record semantics.

## Substance gate

Already completed:

- exact legacy placeholder detection retained.
- gate strengthened to detect:
  - unresolved assimilation packets,
  - `PENDING RECONNAISSANCE`,
  - metadata-only entry functions,
  - trivial holder dataclasses,
  - dummy-field evasions,
  - renamed metadata handlers,
  - inbred delegation rings,
  - metadata-only generated tests.
- adversarial near-placeholder tests were added.
- substance-gate failures/import failures now block rather than silently pass in the major authoring/promotion paths.
- test-evidence gate was added.

## Behavioral proof and promotion

Already completed:

- real authored code requires an author-supplied behavioral test.
- metadata-only tests are rejected.
- targeted behavioral tests can be executed through `execute_behavioral_test()`.
- canonical promotion executes the behavioral test inside the rollback transaction.
- behavioral-test failure rolls back the promoted source/test/manifest.
- new canonical-module creation without a behavioral test is blocked.
- runtime registration can require:
  - final executable decision,
  - `test_passed=True`,
  - real module source,
  - passing substance gate.
- unresolved packet/concept source cannot be registered as an MCP tool.

## Prompt corrections

Already completed:

- integrator prompt no longer tells the system to create `_2/_3` live siblings.
- unresolved canonical owner now means defer/reconnaissance instead of universal fallback to `collective_synthesized`.

Do not reopen these completed items unless a regression is found.

---

# 2. Current Status: Main Remaining Problem Is Slop

The architectural direction is now correct, but the source still contains substantial **residual architecture from the system that was just replaced**.

This pass should be aggressive.

A successful refactor is not:

```text
new architecture added
+
old architecture retained beside it
```

It is:

```text
new architecture proven
+
old architecture removed
+
duplicate paths collapsed
+
tests rewritten around the surviving architecture
```

The objective is to leave **one authoritative path per responsibility**.

---

# 3. Immediate Confirmed Slop Hotspot: `write_code_e2e.py`

File:

`tools/agentx_evolve/collective_core/write_code_e2e.py`

The current production behavior now uses typed authoring outcomes, but the file still carries a large amount of the prior packet-era design.

Audit and aggressively delete or relocate anything no longer needed by the current runtime.

## 3.1 Remove stale module documentation

The file header still describes the old behavior:

```text
AUTHOR — capability-assimilation packet module
PENDING RECONNAISSANCE
dataclass
__main__ CLI
matching packet test
```

That description is now false.

Rewrite the module documentation around the actual current behavior:

```text
evidence
-> worthiness/reconnaissance
-> typed non-code decision OR real author
-> substance gate
-> behavioral proof
-> governed staging/promotion
```

Delete stale comments rather than layering corrective comments on top of them.

---

## 3.2 Remove packet-era vocabulary if it has no real production caller

Audit and remove dead constants/helpers such as, where proven unused by the surviving path:

- `PENDING_RECONNAISSANCE`
- `ALLOWED_IMPLEMENTATION_DECISIONS`
- `_RECON_CONCEPT_STEMS`
- `_recon_concepts`
- `_strip_source_claims`
- `_TERMINOLOGY_WATCH_PAIRS`
- `_atomic_behaviors`
- `_terminology_notes`

Do not preserve these solely because old unit tests import them.

If some functionality remains genuinely valuable for evidence normalization, move only the actually used logic into a small, clearly named **evidence/reconnaissance utility module**.

Do not keep packet-authoring vocabulary in `write_code_e2e.py` after packet authoring has been removed.

---

## 3.3 Remove obsolete knowledge-codec machinery unless it has a current consumer

Audit:

- `_NOISE_TERMS`
- `_tokens_from_text`
- `_THRESHOLD_SIGNAL`
- `_THRESHOLD_PATTERNS`
- `_extract_thresholds`
- `_REQUIRED_PATTERNS`
- `_extract_required_fields`
- `_domain_fields_from_text`
- associated packet/codec constants and comments

The old rationale was:

> turn capability text into generated record-validation constants.

That is no longer the implementation model.

If these helpers are now used only by tests labelled “knowledge codec” or “mining utilities stay available,” that is not sufficient reason to retain them.

Required decision:

```text
real production caller exists?
    yes -> move to the subsystem that actually owns reconnaissance/evidence parsing
    no  -> delete helper + delete/replace tests that pin it
```

Do not leave a dead mini-parser inside `write_code_e2e.py` because it might someday be useful.

---

## 3.4 Remove obvious duplicated statements and local clutter

Current code contains duplicate initialization blocks such as repeated:

```python
results: list[dict] = []
written = 0
not_worthy = 0
```

Remove such duplicate statements.

Run an AST/static pass for:

- repeated assignments with no intervening read,
- unused locals,
- unused imports,
- unreachable branches,
- duplicate constants,
- functions superseded by newer functions,
- private helpers with zero production callers.

Do not leave “harmless” duplication.

---

## 3.5 Remove dead compatibility API

`author_functional_module()` currently accepts compatibility parameters such as `existing_modules` even though canonical identity no longer uses filename dedupe.

If no real current caller requires a compatibility argument:

- delete the argument,
- update callers,
- update tests.

Do not retain compatibility signatures without a demonstrated external caller.

“Someone could call this someday” is not a caller.

---

# 4. Test-Pinned Slop Must Be Removed

Current tests still deliberately preserve portions of the old codec/reconnaissance machinery.

Examples include test classes that import private helpers solely to assert they “stay available.”

This is a slop smell.

Apply this rule:

> A test protects required behavior. It does not grant immortality to obsolete implementation machinery.

For every test that directly imports a private helper:

1. identify the current runtime feature the helper supports;
2. find the production caller;
3. if there is no production caller, delete the helper and test;
4. if the behavior is genuinely needed, test it through the owning public/current architecture.

Aggressively remove tests whose primary purpose is preserving:

- packet-era helper names,
- obsolete codec internals,
- legacy module shape,
- historical compatibility behavior,
- dead private APIs.

Keep adversarial tests that protect against regression into fake implementations.

---

# 5. `coding_loop.py` Contains a Second Integration Engine — Collapse It

File:

`tools/agentx_evolve/collective_core/coding_loop.py`

This file still contains substantial live-tree integration logic that overlaps with:

`tools/agentx_evolve/collective_core/assimilation_governance.py`

Examples currently present include logic for:

- finding host files,
- merging candidate definitions,
- refreshing merged bodies,
- refreshing packet-era assignments,
- same/foreign `SOURCE_CAP` handling,
- locating previously authored files,
- live module identity,
- manifest wiring,
- rollback/integration behavior.

This duplication is a major slop source.

## Required architecture

`coding_loop.py` should primarily orchestrate:

```text
inventory
-> prioritization/dedup
-> author request
-> staged candidate
-> call canonical assimilation/promotion authority
-> report result
```

It should **not implement its own second canonical-owner / merge / refresh / promotion engine**.

Use `assimilation_governance.py` as the authority for:

- canonical owner resolution,
- merge/create decisions,
- collision rules,
- substance gate,
- behavioral proof,
- transactional promotion,
- manifest commit,
- rollback,
- promotion provenance.

Delete duplicate logic from `coding_loop.py` after callers are rewired.

---

# 6. Explicitly Attack Packet-Era Refresh Code

`coding_loop.py` still contains packet-era compatibility machinery such as:

```text
_REFRESHABLE_ASSIGNS
SOURCE_DESCRIPTION
DOMAIN_FIELDS
REQUIRED_FIELDS
THRESHOLDS
_refresh_host_assigns()
```

The comments explicitly describe these as retained for legacy hosts.

The previous remediation already removed the legacy harvest-template population.

Therefore:

1. scan current live `tools/` code for legitimate surviving hosts that still require this compatibility path;
2. if zero legitimate current hosts depend on it:
   - delete `_REFRESHABLE_ASSIGNS`,
   - delete `_refresh_host_assigns`,
   - simplify/delete `_refresh_host_selective` if it becomes unnecessary,
   - delete tests that exist only for this legacy healing behavior;
3. if a tiny number of real hosts remain:
   - migrate them once,
   - then delete the compatibility code.

Do not keep a permanent compatibility engine for artifacts already cleaned from the repository.

---

# 7. Remove `SOURCE_CAP` as a Hidden Runtime Identity System

The current architecture correctly moved provenance outside implementation source, but `coding_loop.py` still contains helpers such as:

- `_source_cap_map`
- `_source_capability_name`
- `_host_carries_foreign_capability`
- `_host_is_same_capability`
- `_find_existing_authored`

that rely on `SOURCE_CAP` embedded in source files.

Audit all of them.

Prefer authoritative identity from:

- candidate metadata,
- canonical owner,
- promotion ledger,
- provenance index,
- manifest/registry where appropriate.

Do not maintain a second source-text identity protocol unless an actual surviving runtime contract requires it.

If metadata identity fully replaces it, delete the SOURCE_CAP-based compatibility layer.

---

# 8. Remove Append-Based “Bucket Integration” Slop

Current code still contains historical append markers such as:

```text
# --- imports for Agent_X integrated component ---
# --- integrated from bucket:... ---
```

and logic that appends blocks directly into hosts.

This is exactly how giant bucket-sink files were created previously.

The canonical promotion path already has better ownership controls.

Required:

- route integration through canonical promotion;
- stop emitting historical bucket markers into production source;
- delete append-only integration paths where superseded;
- migrate/clean any surviving marker blocks if they no longer serve a real purpose.

Do not preserve generated historical comments in source merely as provenance.

Provenance belongs in provenance metadata/ledger.

---

# 9. Remove Duplicate / Obsolete Manifest Helpers

In `assimilation_governance.py`, audit helpers such as:

- `_manifest_if_dispatch`
- `_manifest_if_entry`

If `_manifest_if_dispatch` is now superseded and has no caller, delete it.

More generally, for every helper replaced during the previous iterations:

```text
old helper
new helper
```

delete the old one after verifying references.

Do not leave superseded private functions indefinitely.

---

# 10. Fix Stale Contract Text

The integrator prompt and comments must match current runtime behavior.

For example, remove stale instructions that still say:

```text
Post-integrate: call dispatch({})
```

when the architecture now supports arbitrary declared/public entries.

The surviving contract should say:

```text
execute the actual declared/canonical runtime entry or the behavioral proof;
do not assume every capability is a dict-taking dispatch function.
```

Perform the same stale-text cleanup across:

- docstrings,
- comments,
- markdown reports,
- prompt strings,
- test names,
- variable names.

Do not keep misleading historical language.

---

# 11. Aggressive Whole-`tools/` Slop Audit

After fixing the known harvesting files, recursively inspect the **entire**:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

Do not limit this pass to `agentx_evolve/collective_core`.

Classify and act on the following.

## 11.1 Orphan modules

Delete modules that have:

- no production imports,
- no registry/manifest entry,
- no CLI/API entry,
- no dynamic loader reference,
- no configuration reference,
- no documented standalone invocation,
- and no unique behavior needed by current architecture.

A unit test importing the module does not by itself count as a production consumer.

---

## 11.2 Test-only production helpers

Find production code referenced only from tests.

For each:

- if the helper exists solely to make tests pass, delete helper and obsolete test;
- if it represents real behavior, route the test through the actual public path.

---

## 11.3 Duplicate implementations

Detect:

- byte-identical files,
- near-identical files,
- wrapper modules that simply forward to another wrapper,
- parallel registries for the same concept,
- duplicated normalization/sanitize/hash functions,
- duplicated manifest sealing,
- duplicated canonical-owner resolution,
- duplicated retry/ledger logic,
- duplicated candidate merge code.

Collapse to one owner.

---

## 11.4 Empty / ceremonial packages

Delete package directories whose meaningful content is only:

- empty `__init__.py`,
- re-export-only `__init__.py` with no compatibility need,
- README + no implementation,
- trivial CLI forwarding to another identical CLI,
- obsolete manifests,
- generated evidence with no current consumer.

Do not delete namespace/package structure required by imports, but do not preserve empty architectural theater.

---

## 11.5 Compatibility shims

For every shim:

- prove an actual current external/internal caller;
- if caller exists, keep the minimum shim;
- if no caller, delete it.

Add a temporary compatibility note only when there is concrete evidence that migration cannot be completed in this pass.

Do not preserve shims based on hypothetical consumers.

---

## 11.6 Broad exception swallowing

Audit patterns such as:

```python
except Exception:
    pass
```

especially in:

- persistence,
- promotion,
- coding,
- manifests,
- identity,
- cleanup,
- test execution.

If swallowing is not intentional best-effort behavior with a clear boundary:

- narrow the exception,
- report the failure,
- or delete the unnecessary branch.

Do not allow “slop resilience” to hide broken/dead paths.

---

## 11.7 Dead feature flags and dormant branches

Delete:

- flags with one surviving value,
- old rollout paths no longer selectable,
- legacy fallback branches never reached,
- deprecated adapters with no callers,
- duplicated old/new execution modes after migration is complete.

Do not keep two architectures after choosing one.

---

## 11.8 Historical generated comments

Remove comments such as:

```text
Agent_X integrated component
integrated from bucket
generated component
legacy compatibility
temporary fallback
```

when the associated mechanism is now canonical and provenance exists elsewhere.

Comments must explain current code, not preserve archaeology.

---

## 11.9 Stale reports and misleading documentation

`HARVEST_REMEDIATION_REPORT.md` currently describes earlier states and test counts.

Update it only after the final pass.

Do not leave obsolete statements such as:

- packet `process` is accepted,
- 34 failures are deliberately untouched,
- old gate behavior,
- old manifest counts,
- old shim counts,

if they are no longer true.

Prefer one current factual report over accumulating multiple historical reports.

Git history already preserves history.

---

# 12. Delete Before Abstracting

When encountering repeated or awkward code, use this order:

```text
1. Is it needed?
   no -> DELETE

2. Is it duplicate?
   yes -> USE EXISTING OWNER + DELETE DUPLICATE

3. Is it compatibility-only?
   no demonstrated caller -> DELETE

4. Is it genuinely required but misplaced?
   move/consolidate

5. Only then consider a new abstraction.
```

Do not solve slop by creating:

- another manager,
- another registry,
- another adapter,
- another facade,
- another compatibility layer,
- another helper package.

Deletion is preferred over abstraction when behavior is not required.

---

# 13. No “Keep It Because Tests Pass”

A passing test suite can protect slop.

During this pass:

- identify tests that preserve obsolete structure;
- distinguish **behavioral contract tests** from **implementation-preservation tests**;
- delete or rewrite implementation-preservation tests when the implementation is being removed.

Examples of bad reasons to keep code:

```text
a test imports it
a test checks the constant
a test checks the helper directly
a snapshot contains it
an old fixture expects it
```

The question is:

> Does current Agent_X need the behavior?

---

# 14. No “Keep It Because It Is Harmless”

Harmless code is maintenance surface.

Delete dead code even if it:

- compiles,
- is small,
- has tests,
- is private,
- is currently unused but “might be useful,”
- was expensive to create.

Every retained line must justify its presence.

---

# 15. Require a Net Slop Reduction

This pass should produce a measurable reduction.

Report:

- production Python LOC before/after for modified slop hotspots,
- test LOC before/after,
- modules deleted,
- functions deleted,
- compatibility paths deleted,
- duplicate implementations collapsed,
- stale tests deleted,
- stale comments/docs removed.

Do **not** chase an arbitrary percentage at the expense of correctness.

However, if the pass adds significantly more production code than it removes, treat that as a warning that slop is being reorganized rather than eliminated.

For the known packet/coding-loop areas, expect a clear net reduction unless a concrete current requirement prevents it.

---

# 16. Preserve These Real Systems

Do not damage or gratuitously rewrite:

- the seven canonical harvested algorithms,
- real adaptation behavior,
- Borg governance/runtime,
- real orchestrators,
- real persistence/provenance,
- security boundaries,
- canonical promotion transaction semantics,
- behavioral-test execution,
- substance/test-evidence gates,
- actual registries/manifests still in use,
- user-facing CLI/API behavior that has demonstrated callers.

Aggressive deletion applies to slop, not to real capability.

---

# 17. Verify the New Authoring Path End-to-End

After deletion/consolidation, prove these three branches:

## Duplicate evidence

```text
harvested duplicate
-> ALREADY_EXISTS
-> no Python source
-> no test source
-> no manifest
-> provenance retained
```

## Vague evidence

```text
underspecified item
-> CONCEPT_ONLY or DEFERRED
-> no Python source
-> no test source
-> no manifest
```

## Real implementable evidence

```text
evidence
-> real author
-> real mechanism
-> behavioral test
-> test-evidence gate
-> substance gate
-> targeted test execution
-> canonical owner
-> transactional promotion
-> runtime registration where appropriate
```

No packet layer may reappear between evidence and implementation.

---

# 18. Run the Previously Problematic Test Areas

No external CI status currently proves the latest commit.

Therefore execute locally and make the repository prove itself.

At minimum run:

- `algorithmic_substance_gate` tests
- `collective_core/test_write_code_e2e.py`
- complete `collective_core/test_coding_loop.py`
- assimilation-governance tests
- candidate/promotion tests
- harvested algorithm tests
- manifest/runtime tests
- Borg integration tests affected by changed files

The old report previously listed 34 `test_coding_loop.py` failures.

Do not automatically label them “pre-existing” anymore.

For each remaining failure:

```text
current code path touched by this remediation?
    yes -> FIX
    no  -> prove unrelated and list exact test/reason
```

The target is zero failures in all directly affected suites.

---

# 19. Local Runtime-State Slop Must Also Be Purged

Git does not expose ignored local runtime state, so inspect it during execution.

Audit:

- `.agentx-init/coding_bucket/`
- `.agentx-init/assimilation/`
- candidate stores
- bucket indexes
- integration ledgers
- write-code ledgers
- generated paired tests
- obsolete manifests in runtime state

Aggressively remove:

- old legacy placeholder modules,
- packet-shaped pseudo-implementation modules,
- paired trivial tests,
- stale index entries referencing deleted files,
- duplicate staged copies,
- terminal candidates already represented in provenance,
- old collision-suffixed staged junk no longer needed,
- orphan manifests.

Before deletion, preserve any provenance not already durable.

Do not let stale runtime state cause the new code to report `already_done` for fake historical implementations.

---

# 20. Final Anti-Slop Scan

Before declaring completion, recursively scan `tools/` for all of the following:

```text
PENDING RECONNAISSANCE
SOURCE_CAP
DOMAIN_FIELDS
REQUIRED_FIELDS
THRESHOLDS
integrated from bucket
Agent_X integrated component
_2.py / _3.py generated capability siblings
processed=True
is_valid() ceremony
_main() ceremony in generated capabilities
metadata-only process/dispatch
CONCEPT_ONLY inside executable modules
KNOWLEDGE ONLY inside executable modules
unused compatibility
legacy fallback
temporary shim
deprecated
TODO / FIXME / XXX
except Exception: pass
```

Do not blindly delete every textual occurrence.

For every occurrence classify:

- real/current and justified,
- provenance/test fixture,
- stale slop.

Delete the stale category.

The final report must list justified survivors for suspicious patterns.

---

# 21. Acceptance Criteria

This pass is complete only when all are true:

- [ ] Previous completed placeholder remediation remains intact.
- [ ] Typed authoring decisions remain the only default authoring behavior.
- [ ] No deterministic fallback fabricates executable code.
- [ ] Real implementation still requires behavioral proof.
- [ ] Packet-era dead helpers in `write_code_e2e.py` are removed or moved to a real current owner.
- [ ] Tests no longer keep dead packet/codec helpers alive merely for compatibility.
- [ ] Duplicate initialization / unused locals / unused imports are removed.
- [ ] `coding_loop.py` no longer maintains a redundant canonical integration engine where `assimilation_governance.py` already owns the behavior.
- [ ] Legacy packet refresh constants/paths are removed after surviving hosts are migrated.
- [ ] SOURCE_CAP-based hidden identity logic is removed wherever metadata/provenance already replaces it.
- [ ] Append-based bucket integration markers/path are eliminated where canonical promotion supersedes them.
- [ ] Superseded manifest/private helpers are deleted.
- [ ] Stale `dispatch({})` universal assumptions are removed.
- [ ] Orphan modules in the entire `tools/` tree are deleted.
- [ ] Test-only production helpers with no runtime consumer are deleted.
- [ ] Byte-identical and semantically duplicate modules are consolidated.
- [ ] Compatibility shims without proven callers are deleted.
- [ ] Dead flags/dormant branches are removed.
- [ ] Broad exception swallowing is reduced to justified boundaries.
- [ ] Historical generated comments are removed from production source.
- [ ] Local `.agentx-init` stale generated slop is retired.
- [ ] Directly affected tests pass.
- [ ] No new abstraction layer was created merely to house deleted slop.
- [ ] Modified slop hotspots show a meaningful net LOC reduction.
- [ ] Final remediation report reflects the **current** state, not previous iterations.

---

# 22. Required Final Report

Replace/update the existing remediation report with a concise current-state report containing:

```text
production files inspected
production files deleted
production files consolidated
test files deleted
functions/classes deleted
compatibility paths deleted
duplicate implementations collapsed
LOC before
LOC after
net LOC removed
runtime-state generated artifacts retired
remaining suspicious-pattern occurrences
justification for each survivor
test commands
pass/fail counts
unresolved failures
```

Do not create a celebration document.

Do not keep multiple iterative reports unless another system genuinely consumes them.

One current report is preferable.

---

# Final Instruction

Be aggressive.

The previous iterations fixed the conceptual architecture.  
This iteration must remove the debris left behind by that transition.

Do not merely make slop safer.

Do not merely add another guard around slop.

Do not merely rename legacy code.

**Delete it when it no longer has a demonstrated current purpose.**

The desired final condition is:

```text
less code
fewer paths
fewer compatibility branches
fewer wrappers
fewer generated artifacts
fewer private helpers
fewer test-pinned internals
one canonical implementation per responsibility
real algorithms only
behaviorally proven promotion
```

The burden of proof is now on code that wants to remain.
