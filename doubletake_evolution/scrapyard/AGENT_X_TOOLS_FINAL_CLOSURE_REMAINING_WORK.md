# Agent_X `/tools/` Final Closure Pass — Remaining Work Only

## Purpose

Continue cleanup of:

`/home/glompy/Desktop/ASTROCYTECH/Agent_X/tools/`

This prompt intentionally offloads the large remediation work that is already complete.

Do **not** redesign harvesting, coding, assimilation, promotion, or Borg runtime again.

The remaining work is now a **closure/audit problem**, not an architecture rewrite.

---

# 1. Completed — Do Not Redo

Treat all of the following as complete unless direct current-code inspection proves a regression.

## Harvest / algorithmic-substance remediation

- Legacy placeholder harvest modules removed.
- Import-only / metadata-only paired tests removed.
- Provenance preserved in `harvest_remediation_audit.json`.
- Underspecified harvested items retained as non-code decisions rather than fabricated implementations.
- Duplicate harvested mechanisms consolidated.
- Seven canonical harvested algorithm families exist with behavioral tests:
  - adaptive mutation
  - elite preservation
  - hybrid ranking
  - semantic deduplication
  - ranked selection
  - lineage GC
  - ingest gate
- Unverified source claims are not presented as benchmarked runtime facts.
- Generated manifest/import clutter was cleaned.

## Typed authoring / no fake code

- Default deterministic author no longer fabricates Python implementations.
- `AuthoringOutcome` / `AuthoringResult` separate:
  - real implementation
  - already exists
  - concept only
  - deferred
  - rejected
- Non-code decisions carry no implementation source and do not become runtime tools.
- Real implementations require meaningful behavioral tests.

## Substance / behavioral gates

- Placeholder and near-placeholder code is blocked.
- Unresolved packet/specification states cannot become executable runtime implementations.
- Metadata-only generated tests are blocked.
- Gate import/execution failures fail closed.
- Candidate behavioral tests are executed before canonical promotion.
- Failed tests rollback source/test/manifest mutation.

## Promotion architecture

This is now complete and must remain single-authority:

`coding_loop.py::_run_integrate()`

now delegates canonical source promotion to:

`assimilation_governance.promote_candidate()`

The coding loop no longer owns its own:

- canonical source merge engine
- module creation engine
- rollback transaction
- package wiring
- manifest writer
- live test runner
- second promotion-result ledger

There is one canonical promotion authority and promotion ledger.

Do not recreate a second integration path.

## Packet-era / compatibility slop

Already removed or migrated:

- packet-era source identity as primary runtime identity
- legacy packet refresh constants
- obsolete knowledge-codec helpers
- stale generated bucket markers
- dead deterministic packet authoring
- dead compatibility helpers
- unrelated write-code refactor/bytecode side jobs

## Runtime-state purge

Already completed:

- stale fake coding-bucket modules removed
- paired fake tests removed
- stale coding-bucket index reset
- stale write-code success records purged
- false `already_done` authority from deleted fake implementations removed

## Scaffold purge

Already completed:

- 656 dead files removed
- ~12,290 lines removed
- 139 scaffold/placeholder files deleted
- 381 no-op negative fixtures deleted
- 108 proof-only CLI files deleted
- 27 empty generated package initializers deleted
- dead existence-only tests removed
- 71 dead Make target blocks removed
- skeleton-contract architecture that existed only to require placeholders was removed
- remaining `SCAFFOLD_ONLY` population reduced to 13 files / 26 occurrences and classified as current runtime/proof infrastructure

Do not restart a broad scaffold purge unless a surviving file fails the evidence rules below.

## Current focused verification

Already achieved:

- `test_coding_loop.py`: passing
- focused coding/promotion/governance suite: passing
- `compileall tools tests`: passing

Preserve these results.

---

# 2. Remaining Work

There are now four narrow closure targets:

1. **22 orphan artifact records**
2. **63 orphan module records**
3. **20 byte-identical groups / ~300 duplicate files**
4. **full-repository pytest collection blockers**

The goal is to close these without destabilizing the now-correct architecture.

---

# 3. Orphan Artifact Records — Resolve All 22

The current exhaustive inventory reports:

```text
22 orphan artifact records
```

Do not merely leave the inventory at `NOT_ACCEPTED`.

For every orphan artifact record:

## 3.1 Classify

Use one of:

```text
STALE_METADATA
DELETED_ARTIFACT_REFERENCE
MOVED_ARTIFACT_REFERENCE
LEGITIMATE_EXTERNAL_ARTIFACT
MISSING_REQUIRED_ARTIFACT
CORRUPT_RECORD
```

## 3.2 Resolve

### STALE_METADATA

Delete or migrate the stale record.

### DELETED_ARTIFACT_REFERENCE

Remove the record if the artifact was intentionally deleted and no runtime depends on it.

Preserve historical provenance elsewhere if necessary.

### MOVED_ARTIFACT_REFERENCE

Update the record to the canonical current path.

### LEGITIMATE_EXTERNAL_ARTIFACT

Keep only if the record intentionally points outside the current source tree and that behavior is documented/validated.

### MISSING_REQUIRED_ARTIFACT

Restore the artifact only if current runtime architecture genuinely requires it.

Do not recreate a placeholder just to satisfy inventory.

### CORRUPT_RECORD

Repair or delete fail-closed.

---

# 4. Orphan Module Records — Resolve All 63

The current exhaustive inventory reports:

```text
63 orphan module records
```

For each record, prove whether the referenced module:

- was deleted intentionally,
- moved,
- renamed,
- merged into another canonical module,
- remains dynamically loaded,
- is genuinely missing,
- or is stale registry/inventory metadata.

Required outcomes:

```text
stale -> DELETE RECORD
moved -> REPOINT
merged -> REPOINT TO CANONICAL OWNER / RETIRE OLD IDENTITY
dynamic real module -> KEEP WITH EVIDENCE
required but missing -> RESTORE REAL IMPLEMENTATION ONLY
```

Never recreate deleted scaffold or placeholder code just to make the inventory green.

The inventory should reflect reality.

Reality must not be mutated to satisfy obsolete inventory metadata.

---

# 5. Exhaustive Inventory Must Reach a Meaningful Terminal State

After resolving the 22 + 63 records, rerun the exhaustive inventory.

Target:

```text
ACCEPTED
```

If a small number of records legitimately remain unresolved, the result may remain non-green only when each has:

- exact record ID/path
- exact reason
- external dependency or concrete blocker
- no safe local resolution

Do not leave generic categories such as:

```text
orphan
future work
owner review
```

without concrete evidence.

---

# 6. Audit the 20 Byte-Identical Groups / ~300 Files

The current whole-tools audit reports:

```text
20 byte-identical digest groups
~300 duplicate files
```

Do not blindly delete them.

But do not automatically retain them either.

For every digest group:

## 6.1 Classify each copy

Use:

```text
CANONICAL_RUNTIME
REQUIRED_ALIAS
GENERATED_TEST_FIXTURE
PROOF_FIXTURE
PACKAGE_REQUIRED
DEAD_DUPLICATE
```

## 6.2 Delete dead duplication

Delete `DEAD_DUPLICATE` files.

A duplicate file may survive only with concrete evidence such as:

- import path compatibility actively used
- plugin/loader requires exact location
- separate package identity required
- fixture intentionally duplicated for isolated test semantics
- build/proof system consumes that exact path

The following are not sufficient reasons:

```text
same code but different folder
tests may need it
it is harmless
future compatibility
historical package structure
```

---

# 7. Prefer Canonical Reuse Over Copied Source

Where two packages need identical behavior, prefer:

```text
one canonical implementation
+
import/re-export/reference
```

over:

```text
copy A.py
copy B.py
copy C.py
```

But do not create excessive alias wrappers.

Use this order:

```text
1. Can callers import the canonical implementation directly?
   yes -> update callers + delete copy

2. Is a stable compatibility path truly required?
   yes -> minimum forwarding shim

3. Otherwise -> delete duplicate
```

Do not replace 300 duplicate files with 300 wrappers.

---

# 8. Audit the Remaining 130 Empty `__init__.py` Files

The current audit reports about:

```text
130 empty __init__.py files
```

Do not delete them blindly.

For each:

## Keep only if needed for:

- package import semantics used by current runtime
- package discovery
- plugin loading
- test isolation
- tooling that requires regular packages rather than namespaces

## Delete when:

- directory no longer contains active Python code
- package exists only as historical scaffolding
- namespace package semantics are sufficient
- no current importer depends on the regular-package boundary

Also delete directories that become empty after removal.

---

# 9. Remove Stale References Created by Earlier Deletions

After orphan and duplicate cleanup, scan:

- manifests
- registries
- Makefiles
- package `__init__.py`
- import maps
- capability maps
- proof inventories
- documentation used as machine-readable configuration
- tests
- generated indexes

for references to deleted paths.

No dangling names should survive.

---

# 10. Fix Full-Repository Pytest Collection Blockers

The current remediation report says full pytest discovered ~20,581 tests but collection is blocked by:

- missing helper modules
- a missing patch module
- duplicate test-module name

These must now be resolved.

Do not treat them as permanently unrelated.

## 10.1 Missing helper modules

For each missing helper import:

Determine whether:

```text
helper should exist -> restore/fix real helper
helper moved -> update import
helper deleted intentionally -> update/delete stale test
test obsolete -> delete test
```

Do not create dummy helpers just to satisfy imports.

## 10.2 Missing patch module

Apply the same rule:

- real required code -> restore real implementation
- renamed/moved -> update importer
- obsolete test/reference -> delete it

No placeholder module.

## 10.3 Duplicate test-module name

Resolve the collection collision properly:

- rename file/module,
- fix package structure,
- or remove duplicate obsolete test.

Do not disable test discovery globally.

---

# 11. Full Test Collection Must Complete

The minimum target for this pass is:

```text
pytest collection completes successfully
```

This does **not** mean every one of ~20k tests must necessarily pass if unrelated runtime failures remain.

But collection itself must not fail due to broken repository structure.

After collection succeeds:

- run the directly affected suites,
- run the widest practical suite,
- report exact failures.

---

# 12. Do Not Reopen Correct Architecture

While fixing orphans/duplicates/tests, do not reintroduce:

- generated placeholder algorithms
- packet modules
- SOURCE_CAP runtime identity
- second promotion engine
- direct coding-loop canonical writes
- collision-suffixed live capabilities
- existence-only scaffold tests
- fake proof CLI packages
- stale success-ledger authority
- broad compatibility layers

Any fix that recreates one of these is a regression.

---

# 13. Evidence Standard for Retaining Suspicious Files

A suspicious file may survive only with at least one concrete current reason:

```text
production import: <path>
runtime registry: <entry>
API route: <route>
CLI entry: <command>
dynamic loader: <loader>
Make/CI proof: <target>
test fixture for real behavior: <test>
external package compatibility: <consumer>
```

Do not retain code for:

```text
maybe useful
historical
tests used to expect it
future work
architecturally nice
owner review
```

---

# 14. Required Metrics

Report before/after:

```text
orphan artifact records
orphan module records
byte-identical groups
duplicate files
empty __init__.py files
Python file count
production LOC removed
test/proof LOC removed
dangling references
pytest collection errors
```

The goal is closure, not an arbitrary LOC target.

But the numbers should move materially in the correct direction.

---

# 15. Required Final Verification

Run at minimum:

1. exhaustive inventory closure
2. duplicate digest scan
3. dangling-reference scan
4. `python -m compileall -q tools tests`
5. `test_coding_loop.py`
6. promotion/governance tests
7. write-code tests
8. substance-gate tests
9. harvested-algorithm tests
10. full pytest collection
11. widest practical test run after collection succeeds

---

# 16. Acceptance Criteria

This final closure pass is complete only when:

- [ ] 22 orphan artifact records are individually resolved.
- [ ] 63 orphan module records are individually resolved.
- [ ] exhaustive inventory reaches ACCEPTED or has only concretely blocked external exceptions.
- [ ] all 20 byte-identical groups are individually classified.
- [ ] dead duplicate files are deleted.
- [ ] required duplicate paths have documented concrete consumers.
- [ ] empty `__init__.py` files are audited rather than blindly retained.
- [ ] empty/dead package directories are removed.
- [ ] dangling references to deleted artifacts/modules are gone.
- [ ] missing pytest helper imports are resolved without dummy modules.
- [ ] missing patch-module reference is resolved without placeholder code.
- [ ] duplicate pytest module-name collision is fixed.
- [ ] full pytest collection completes.
- [ ] focused coding/promotion suites remain green.
- [ ] no second promotion engine reappears.
- [ ] no fake algorithm/scaffold generation reappears.
- [ ] final report reflects current reality only.

---

# Final Instruction

Do not redesign Agent_X again.

The major architectural remediation is complete.

This pass is about **closing the books**:

```text
remove stale records
remove dead duplicates
remove dead package shells
repair stale references
make repository inventory truthful
make pytest collect cleanly
```

Prefer deletion and canonical reuse over compatibility clutter.

Do not recreate anything that was intentionally removed unless current runtime behavior proves it is genuinely required.
