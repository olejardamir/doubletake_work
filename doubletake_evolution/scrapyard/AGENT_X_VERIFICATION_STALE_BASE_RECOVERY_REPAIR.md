# Agent_X — Verification-Revision Stale-Base Recovery Repair

Current audited remote `main` when this prompt was written:

`5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0`

The local working tree may already contain later semantic-provider repairs or other uncommitted changes. Inspect the actual local repository before editing.

## Exact production failure

A normal build request:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

is blocked with:

```text
403
Semantic-first authorization required before project mutation.

SEMANTIC_FIRST_DENIED:
SEMANTIC_CODE_CONFLICT:STALE_BASE;
ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD
```

Example run:

`run_1789331824444_bJEuisSZ`

This is not a reason to bypass semantic-first.

It is a dead-end in the synchronization/recovery protocol.

---

# 1. Preserve the core safety rule

Do not allow project mutation from a stale or unverifiable accepted baseline.

Keep all of these rules:

- semantic-first remains mandatory;
- a stale accepted baseline cannot silently authorize writes;
- verification/test/proof changes may invalidate earlier verification evidence;
- structural fallback cannot authorize architecture;
- a changed verification suite cannot be treated as automatically trustworthy;
- canonical JSON cannot be hand-edited to force `SYNCED`.

The repair must make stale verification state **recoverable**, not ignored.

---

# 2. Proven current root cause

Inspect current:

`tools/agentx_evolve/semantic_first/synchronization.py`

Current `assess_synchronization()` approximately performs:

```python
current_verification_revision = verification_revision(
    verification_snapshot(root)
)

if baseline.verification_revision != current_verification_revision:
    return SyncAssessment(
        SyncStatus.STALE_BASE,
        baseline,
        semantic_revision,
        impl_revision,
        reasons=("ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD",),
    )
```

This happens **before** the function computes:

- `semantic_changed`;
- `implementation_changed`;
- affected production files;
- the normal `SyncConflict`.

Therefore one verification/test/proof change causes an immediate early return.

Consequences:

1. semantic drift is not assessed;
2. implementation drift is not assessed;
3. a simultaneous production-code change can be hidden behind verification drift;
4. `assessment.conflict` is `None`;
5. `SemanticFirstCheckpoint` cannot invoke its normal governed conflict-resolution path;
6. every subsequent build request receives the same 403;
7. the UI has no normal recovery path;
8. editing more code/tests can make the deadlock worse.

This is the defect to fix.

---

# 3. The reason code is also incorrect

`ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD`

does not prove that the accepted baseline is “ahead”.

The code only proves:

```text
baseline.verification_revision != current_verification_revision
```

The current verification projection could be:

- newer;
- older;
- changed in parallel;
- partially reverted;
- locally modified;
- missing evidence;
- otherwise different.

Replace the semantic meaning with an accurate reason equivalent to:

`VERIFICATION_EVIDENCE_CHANGED_SINCE_ACCEPTED_BASELINE`

or:

`ACCEPTED_SYNC_VERIFICATION_REVISION_MISMATCH`.

Keep backward compatibility only if needed for stored diagnostics/tests.

Do not keep the misleading `_AHEAD` name as authoritative semantics.

---

# 4. Verification revision must be an orthogonal synchronization dimension

Do not check verification drift as an early-return gate.

Compute all three projections first:

```text
semantic projection
implementation projection
verification/evidence projection
```

Then classify the complete state.

At minimum derive:

```python
semantic_changed = ...
implementation_changed = ...
verification_changed = ...
```

The synchronization decision must use all three.

---

# 5. Required classification matrix

Implement the current equivalent of this matrix.

## Case A — no projection changed

```text
semantic_changed = false
implementation_changed = false
verification_changed = false
```

Result:

`SYNCED`

unchanged.

## Case B — verification only changed

```text
semantic_changed = false
implementation_changed = false
verification_changed = true
```

This is **not** implementation drift.

This is **not** semantic drift.

Use the existing `EVIDENCE_GATHERED` status if its semantics fit, or a narrowly equivalent evidence-refresh state.

Do not call it fully `SYNCED`.

Do not call it unrecoverable `STALE_BASE`.

The state means:

> production semantic/code truth still matches the accepted base, but accepted verification evidence no longer describes the current verification suite/proof projection and must be revalidated.

## Case C — implementation changed, semantic unchanged

Regardless of whether verification also changed:

`IMPLEMENTATION_AHEAD`

with a real conflict/recovery record.

Verification drift must be recorded as an additional evidence difference.

It must not mask implementation drift.

## Case D — semantic changed, implementation unchanged

Regardless of verification drift:

`SEMANTIC_AHEAD`

with a real conflict/recovery record.

## Case E — semantic and implementation both changed

Regardless of verification drift:

`BOTH_DIVERGED`

with a real conflict/recovery record.

## Case F — accepted baseline/evidence itself is corrupt

Examples:

- baseline digest invalid;
- target/verification evidence invalid;
- repository identity mismatch;
- semantic model digest corrupt.

Continue to fail closed.

Do not auto-refresh a corrupt authority record into legitimacy.

---

# 6. Extend `SyncAssessment` to expose verification state

Do not hide verification drift inside a generic reason string.

Add current-equivalent fields such as:

```python
verification_revision: str
verification_changed: bool
verification_affected_files: tuple[str, ...]
```

if this can be done without excessive schema churn.

At minimum the assessment must deterministically expose:

- accepted verification revision;
- current verification revision;
- changed verification/test/proof paths.

This is needed for:

- recovery;
- diagnostics;
- conflict identity;
- tests;
- UI detail.

---

# 7. Compute changed verification files

`verification_snapshot()` already returns path → hash.

Compare:

- the accepted verification snapshot used by the baseline/evidence; and
- the current verification snapshot.

If the current baseline does not persist enough information to compute an exact file-level diff, add the minimum immutable artifact binding needed for future baselines.

Do not infer changed tests from Git HEAD alone.

Git is evidence only.

For existing v1 baselines that have only the aggregate revision:

- report aggregate verification mismatch;
- recover conservatively;
- once reminted, persist enough evidence for exact future diffs.

Do not silently fabricate a file list.

---

# 8. Add a safe verification-only refresh path

When **only** verification/evidence changed and semantic + implementation truth still exactly match the accepted baseline, Agent_X needs a canonical way to refresh verification evidence without pretending code changed.

Implement a bounded `verification-only refresh` transaction.

Required sequence:

1. retain the accepted semantic revision;
2. retain the accepted implementation revision;
3. retain exact current production `source_snapshot`;
4. inspect current verification/test/proof changes;
5. run the required deterministic verification;
6. prove the accepted semantic invariants/verification requirements still hold;
7. if verification succeeds, issue a new immutable target/evidence pair describing:
   - no production semantic change;
   - no production implementation change;
   - verification evidence refresh only;
8. bind the new verification artifact to:
   - current verification revision;
   - unchanged implementation revision;
   - unchanged semantic revision;
   - repository identity;
   - refresh run/change ID;
9. build the new synchronization baseline only through the canonical builder;
10. persist atomically;
11. independently reassess;
12. require `SYNCED`.

No project source mutation is authorized merely by this refresh.

---

# 9. Do not reuse the old target evidence blindly

Current evidence validation binds target and verification artifacts to the same accepted change.

For a verification-only refresh, do not simply replace:

`verification_revision`

inside `semantic_code_sync.json`.

Do not copy a new verification digest under an old unrelated target.

Issue a new coherent evidence pair for the verification-refresh transaction.

The semantic target can explicitly mean:

```text
Preserve the currently accepted semantic and implementation state.
Refresh verification evidence against the current verification suite.
No production mutation is intended.
```

This keeps evidence provenance correct.

---

# 10. Verification-only refresh must not trust changed tests automatically

A modified test suite may be:

- stronger;
- weaker;
- broken;
- maliciously relaxed;
- unrelated;
- incomplete.

Therefore a verification-only refresh must prove the verification contract is still valid.

At minimum:

- current verification files parse/load;
- required tests/checks can run;
- semantic target's required invariants remain checked;
- required acceptance/guardrail coverage was not silently removed;
- verification completes successfully.

For changes to protected verification/governance tests, use governed semantic reasoning when necessary to determine whether the evidence contract itself changed materially.

Do not approve verification refresh solely because `pytest` exits 0 if the changed suite deleted the important assertions.

Use existing verification requirements and semantic evidence.

Do not build a second general test-governance architecture.

---

# 11. If verification refresh fails, fail closed accurately

Expected result:

```text
VERIFICATION_REFRESH_FAILED
```

or current equivalent.

Return:

- changed verification paths where known;
- failed checks;
- current verification revision;
- accepted verification revision.

Keep the previous accepted baseline intact.

Do not partially update:

- baseline;
- evidence consumption;
- semantic model;
- verification revision.

Do not grant mutation authority.

---

# 12. Production or semantic drift must take precedence over verification drift

This is crucial.

If implementation or semantic truth changed, do **not** perform a verification-only baseline refresh first.

Example:

```text
production code changed
tests changed
```

Current code incorrectly reports only:

`STALE_BASE / ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD`.

Correct result:

`IMPLEMENTATION_AHEAD`

plus verification-drift evidence.

Similarly:

```text
project_model changed
tests changed
```

must report:

`SEMANTIC_AHEAD`

plus verification drift.

And:

```text
code + model + tests changed
```

must report:

`BOTH_DIVERGED`

plus verification drift.

This ensures the real source/semantic divergence cannot be hidden by a test change.

---

# 13. Create a conflict object whenever semantic or implementation truth diverges

Current `SemanticFirstCheckpoint` already knows how to work with a real `SyncConflict`:

- persist conflict;
- ask governed provider for a resolution proposal;
- bind conflict ID/digest;
- continue through a canonical conflict-resolution semantic transaction.

Make sure every recoverable:

- `IMPLEMENTATION_AHEAD`;
- `SEMANTIC_AHEAD`;
- `BOTH_DIVERGED`;
- partial implementation state;

has a valid conflict object.

Verification drift may be included in that conflict as orthogonal evidence.

Do not let a recoverable divergence return:

```text
assessment.status != SYNCED
assessment.conflict is None
```

unless the condition is genuinely non-resolvable/corrupt.

---

# 14. Extend conflict identity for verification drift

If verification state differs while a semantic/code conflict exists, include the accepted/current verification revisions in the immutable conflict identity or equivalent binding.

Otherwise:

1. conflict is recorded;
2. verification suite changes again;
3. old conflict could be mistakenly reused against a different evidence environment.

Bind conflict resolution to:

- base semantic revision;
- current semantic revision;
- base implementation revision;
- current implementation revision;
- accepted verification revision;
- current verification revision;
- affected implementation files;
- known affected verification files;
- repository identity.

Update `validate_resolution_transaction()` accordingly.

---

# 15. Preserve evidence replay protection

Do not weaken:

- target/verification evidence pairing;
- evidence consumption claims;
- baseline digest sealing;
- replay prevention.

A verification refresh creates **new evidence**.

It does not reuse one consumed verification artifact in a different baseline.

---

# 16. Make the interceptor automatically recover verification-only drift

In `SemanticFirstCheckpoint`:

After initial synchronization assessment:

## If `SYNCED`

Continue normally.

## If verification-only evidence drift

Attempt the canonical verification-refresh procedure.

If successful:

1. load the newly accepted baseline;
2. reassess;
3. require `SYNCED`;
4. continue processing the user's pending build request in the same logical gate execution or through a safe bounded continuation.

Do not require the user to know about or manually request baseline repair.

The semantic-first foundation is supposed to maintain its own accepted evidence.

## If semantic/implementation conflict

Use the normal governed conflict-resolution path.

## If corrupt/untrusted authority

Block with explicit recovery diagnostics.

---

# 17. Avoid infinite self-refresh loops

A verification refresh itself may create transient run-local evidence files.

Those files must not be classified into `verification_snapshot()` if they are runtime/generated transaction artifacts.

Only repository verification/test/proof sources belong in that projection.

After a successful refresh:

```text
verification_revision(verification_snapshot(root))
```

must remain stable on an immediate no-change recheck.

Required regression:

```text
refresh
→ assess = SYNCED
→ assess again = SYNCED
```

No self-induced revision churn.

---

# 18. Ensure canonical baseline files do not alter the verification revision

Changes under canonical runtime evidence stores such as:

- `semantic_project/evidence/...`;
- run-local semantic evidence;
- evidence consumption records;
- semantic conflict records;

must not recursively cause `verification_snapshot()` to change unless they are explicitly part of repository verification source by design.

The verification projection should represent:

- tests;
- proof code;
- CI/proof configuration where applicable.

It should not hash its own issued verification-result artifacts.

Add regression tests.

---

# 19. Fix API error behavior

A verification-only stale baseline that can be automatically refreshed should not immediately surface to the user as:

```text
403 semantic policy denial
```

Attempt recovery first.

If recovery succeeds:

- continue normal semantic authorization.

If recovery fails because verification fails:

return a precise blocked result such as:

```json
{
  "error": "Accepted verification evidence is stale and could not be refreshed.",
  "detail": "...",
  "policy_decision": "verification_refresh_required",
  "retryable": false,
  "run_id": "..."
}
```

Use status code consistent with current API policy.

If the cause is a transient provider needed to assess changed verification semantics, a retryable service error may be appropriate.

Do not call every synchronization problem a generic 403 authorization denial.

---

# 20. Exact regression from the user's current failure

Create the real sequence:

1. begin from a valid `SYNCED` baseline;
2. change verification/test code so `verification_revision` differs;
3. leave production source and semantic model unchanged;
4. submit the build request:

```text
continue completing everything according to:
/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md
```

Expected:

```text
verification-only drift detected
→ verification refresh runs
→ new coherent evidence pair issued
→ new baseline accepted
→ reassessment = SYNCED
→ governed semantic interpretation of pending request runs
→ normal build request proceeds
```

It must **not** return:

```text
SEMANTIC_CODE_CONFLICT:STALE_BASE;
ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD
```

---

# 21. Mixed-drift regression

Start `SYNCED`.

Then modify:

- one production implementation file;
- one test/proof file.

Expected assessment:

```text
IMPLEMENTATION_AHEAD
```

not `STALE_BASE`.

Expected:

- conflict object exists;
- verification drift is recorded;
- governed conflict-resolution path can run;
- no mutation authority is granted until resolution target is sealed.

---

# 22. Semantic + verification regression

Start `SYNCED`.

Then alter accepted semantic state in a controlled isolated fixture and alter a verification file.

Expected:

`SEMANTIC_AHEAD`

with a real conflict record plus verification drift.

---

# 23. Both-diverged + verification regression

Start `SYNCED`.

Alter:

- semantic state;
- production implementation;
- verification source.

Expected:

`BOTH_DIVERGED`

with all three dimensions represented.

No dimension masks another.

---

# 24. Verification refresh failure regression

Start `SYNCED`.

Modify a required test so the current implementation fails it.

Expected:

- verification-only drift is detected if production/model projections are unchanged;
- refresh verification fails;
- old baseline remains untouched;
- no mutation authority;
- exact failing evidence is recorded.

---

# 25. Verification weakening regression

Start `SYNCED`.

Delete or weaken a verification requirement that is explicitly required by the accepted semantic target.

Expected:

- refresh does not automatically certify the weaker suite merely because remaining tests pass;
- material verification-contract weakening is blocked or sent through governed semantic analysis;
- old baseline remains accepted until a valid replacement verification contract is reconciled.

---

# 26. Restart/recovery

Crash at each point:

1. before verification refresh begins;
2. after new target evidence is issued;
3. after verification evidence is issued;
4. before baseline promotion;
5. after evidence consumption claim;
6. after baseline promotion but before reassessment.

Recovery must produce exactly one of:

- old accepted baseline;
- fully valid new accepted baseline.

Never:

- half-updated baseline;
- replayed evidence;
- baseline pointing to missing artifact;
- duplicate consumption with different baseline.

---

# 27. Concurrency

Two runs observe verification-only drift simultaneously.

Only one baseline refresh may win.

The other must:

1. detect the newly accepted baseline;
2. reassess against it;
3. reuse the now-current accepted state;
4. continue or safely retry.

Do not let two distinct baseline refreshes consume/replay the same evidence incorrectly.

Use existing atomic/evidence-consumption mechanisms.

---

# 28. Do not solve this by ignoring verification revision

Forbidden shortcuts:

- delete the verification revision check;
- always update `baseline.verification_revision` to current;
- treat all test changes as harmless;
- manually edit `semantic_code_sync.json`;
- mark STALE_BASE as PASS;
- allow write-capable runs while verification is stale;
- remove test/proof files from verification classification merely to avoid mismatch.

The verification dimension is useful.

Its **recovery semantics and ordering** are what are broken.

---

# 29. Do not solve this by treating tests as production implementation

The production/evidence split established earlier remains correct.

Do not move test files back into `source_snapshot()` to make revisions change together.

Keep:

```text
production implementation revision
```

separate from:

```text
verification/evidence revision
```

Then reason over both correctly.

---

# 30. Update baseline schema only if necessary

If exact recovery needs additional immutable fields, evolve the schema minimally.

Potential additions:

- verification source hashes/snapshot digest;
- accepted verification requirements digest.

If schema changes:

- support/migrate existing v1 baseline conservatively;
- do not silently reinterpret old fields;
- build the new baseline through canonical recovery;
- preserve portability.

Avoid schema churn if existing evidence artifacts already contain enough exact state.

---

# 31. Update semantic evidence

Because synchronization/recovery behavior itself is architecture-authoritative:

After implementation:

1. run the complete synchronization test suite;
2. run semantic-first enforcement tests;
3. run user-regression route test;
4. reconcile current semantic model;
5. issue real target evidence;
6. issue real verification evidence;
7. build a new accepted baseline;
8. restart backend;
9. independently assess synchronization;
10. require `SYNCED`;
11. immediately reassess with no changes;
12. require `SYNCED` again.

Do not manually patch canonical JSON.

---

# 32. Bootstrap note for this repair

The user's local repository is already in the dead-end state:

```text
STALE_BASE / verification revision mismatch
```

Therefore the broken `/api/chat` build path may not authorize the repair itself.

Apply this synchronization-recovery fix using the same trusted external/bootstrap maintenance approach used for the semantic-provider bootstrap repair.

This does not create a permanent bypass.

After repair:

- restart Agent_X;
- recover/remint baseline canonically;
- prove the ordinary UI can maintain verification-only drift itself;
- all future project mutation returns to normal semantic-first enforcement.

---

# 33. Completion criteria

Do not stop until all are true:

1. verification revision mismatch is no longer checked before semantic/implementation drift;
2. semantic, implementation, and verification projections are assessed together;
3. verification-only drift has a first-class recoverable state;
4. production implementation drift cannot be masked by changed tests;
5. semantic drift cannot be masked by changed tests;
6. both-diverged state cannot be masked by changed tests;
7. verification-only drift does not grant mutation authority;
8. verification-only drift can be canonically refreshed;
9. refresh runs actual verification;
10. changed tests are not automatically trusted;
11. failed refresh leaves old baseline intact;
12. refresh issues a new coherent evidence pair;
13. refresh does not replay consumed verification evidence;
14. refresh baseline is created by canonical builder;
15. conflict records include verification revision binding where relevant;
16. stale conflict records cannot be reused after verification changes again;
17. runtime-issued semantic evidence does not recursively alter verification revision;
18. immediate no-change recheck after refresh is stable;
19. verification-only drift is automatically recovered before a normal pending build request when safe;
20. mixed code + verification drift produces `IMPLEMENTATION_AHEAD`, not `STALE_BASE`;
21. mixed semantic + verification drift produces `SEMANTIC_AHEAD`;
22. three-way drift produces `BOTH_DIVERGED`;
23. recoverable non-SYNCED production/semantic states carry a real conflict object;
24. corrupt baseline/evidence still fails closed;
25. no manual canonical JSON edits are required;
26. the user's exact build-request regression no longer deadlocks on `ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD`;
27. normal semantic-first authorization still occurs after recovery;
28. exact mutation authorization remains unchanged;
29. independent final assessment returns `SYNCED`;
30. second no-change assessment remains `SYNCED`.

---

# Stop condition

Stop only when this sequence works end-to-end:

```text
accepted baseline
        ↓
verification/test source changes
        ↓
normal Agent_X build request
        ↓
three-dimensional synchronization assessment
        ↓
verification-only refresh if and only if production semantic/code truth is unchanged
        ↓
canonical evidence regeneration
        ↓
independent SYNCED
        ↓
pending build request continues through normal governed semantic-first
        ↓
coding runtime receives authority only after a valid semantic target
```

and mixed production/test drift correctly enters normal semantic/code conflict resolution rather than being hidden behind `STALE_BASE`.

At that point `ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD` can no longer permanently strand Agent_X's build UI.
