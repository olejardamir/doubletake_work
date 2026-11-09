# DT-IP-0045 — Verification-only drift recovery without masking semantic/implementation conflicts

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / PROMPT_CREATED_NOT_IMPLEMENTED / NOT_EXECUTED. **Current private DT parity:** UNKNOWN. Conditional future-coder inspection, not a present defect or permission to modify DT.

## Public source and provenance
- FULL current source: `doubletake_evolution/scrapyard/AGENT_X_VERIFICATION_STALE_BASE_RECOVERY_REPAIR.md`, Git blob `5ce02ad702029014557116ce46d7d49036e0bdd7`; [public source](https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/AGENT_X_VERIFICATION_STALE_BASE_RECOVERY_REPAIR.md).
- Historical original blob `fbcc01af7de0daaadf3f23201f534e80cb7ab065` (not independently re-read); historical audited Agent_X revision `5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0` (reported by current source; not independently verified). Related canonical cluster: `doubletake_evolution/scrapyard/clustered/historical-semantic-provider-resolution-and-contract-repair.md`. Verify historical claims and any third-party license/reuse rights before relying on them; no external code copied.
- Historical example `SEMANTIC_CODE_CONFLICT:STALE_BASE; ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD`, run `run_1789331824444_bJEuisSZ`, alleged `tools/agentx_evolve/semantic_first/synchronization.py:assess_synchronization()`. These are unverified incident pointers, not evidence of current DT behavior. Digest inequality does not establish chronology.

## Distinct conditional mechanism
If CURRENT DT has an accepted semantic/implementation/verification synchronization baseline and a real authorized consumer, inspect actual source, tests, ownership and permission before proposing changes. Compute **three orthogonal projections** before classification: accepted/current semantic revision, production implementation revision and verification/test/proof revision. Only report exact changed verification paths if immutable baseline snapshots permit; aggregate-only legacy baselines must report unknown paths. Git HEAD is not automatically the accepted verification snapshot.

Classification matrix: all three unchanged → `SYNCED`; semantic and implementation unchanged but verification changed → governed evidence-only refresh-needed state (use `EVIDENCE_GATHERED` only if it fits current semantics); implementation changed, semantic unchanged → `IMPLEMENTATION_AHEAD` with conflict irrespective of verification drift; semantic changed, implementation unchanged → `SEMANTIC_AHEAD`; both changed → `BOTH_DIVERGED`; corrupt authority/repo/evidence → fail closed. Never early-return verification `STALE_BASE` and mask mixed drift.

Evidence-only refresh is **not** a write grant. Permit it only when accepted semantic and implementation revisions match current. Inspect verification diff, run actual deterministic checks, ensure critical assertions/coverage were not weakened or removed, issue new *paired* immutable target and proof bound to unchanged semantic/implementation, current verification digest, repo identity, source snapshot and run/change identity. Consume once; atomically promote through existing canonical baseline builder, then independently reassess `SYNCED` twice with no intervening changes. Do not pair old target with new proof, edit canonical JSON directly, copy a digest, or accept green tests after assertion deletion. Material verification-contract changes require authorized review.

For mixed drift, persist a real `SyncConflict` via existing governance, binding accepted/current semantic, implementation, verification revisions, paths and repo identity; require `validate_resolution_transaction()` or present equivalent. Revalidate on every revision change; stale proof/replay denies. Never refresh evidence first to legitimize production changes.

On test failure, missing/weak evidence, corrupt baseline, stale replay or wrong repo, retain old accepted state and deny mutation with precise diagnostics. Crash injection at pre-refresh, target issuance, proof issuance, pre-promotion, post-consumption and post-promotion/pre-reassessment must recover old or complete new state, never half-promoted or double-consumed. Concurrent refreshers: one atomic winner, loser reloads and reassesses without duplicate evidence. Exclude run-local evidence, conflicts and generated baselines from recursive verification snapshot hashing.

UI/bootstrap: a safely recoverable verification-only drift may refresh and resume the **same pending build request** through normal authorization; failure returns accurate policy/nonretryable or genuinely transient diagnostics, not a generic 403. Any historical trusted bootstrap path is **not** standing bypass permission. Maintain ordinary governed write scope.

## Future-coder conditional gates and tests
Only on explicit user invocation: inspect CURRENT private DT source/tests/permissions and real sync consumer. Exit `ALREADY_PRESENT` if equivalent enforcement exists, `NO_APPLICABILITY`/`NO_CURRENT_CONSUMER` if no relevant path, or `NO_AUTHORIZED_FIXTURE` without approved disposable testing. Do not code without these checks.

With authorization, freeze an accepted `SYNCED` baseline. Verification-only file change must produce evidence-only state, paired proof, canonical promotion, two stable `SYNCED` assessments and ordinary pending-request authorization. Code+verification → `IMPLEMENTATION_AHEAD`; semantic+verification → `SEMANTIC_AHEAD`; all three → `BOTH_DIVERGED`; each persists conflict and denies premature writes. Changed test failing, deleted/weak required assertion despite green suite, wrong repo, corrupt baseline, stale second verification revision, wrong target/proof pairing, and structural fallback must deny. Fault-inject all six crash boundaries and two concurrent refreshers. Verify generated runtime artifacts do not cause self-refresh loops; no manual baseline rewrite; tests are not misclassified as production changes. Run real synchronization and UI tests and independent destination readback; record exact commit, revisions, tests, authority and unresolved failures. No private code or tests executed by this prompt.

## Independent Scout coverage handoff
FULL current source blob above. Distinct clauses: three-axis classification, verification-only paired evidence transaction, mixed-drift conflict persistence, anti-weakening test guard, six crash boundaries, concurrency winner, snapshot recursion exclusion, UI continuation and no-bootstrap-bypass. Compare historical source and relevant existing prompts before approval or deletion. Original retained; Scout alone controls independent review/deletion.


## Historical full-source coverage repair (2026-11-09; conditional, NOT_EXECUTED)

Historical predecessor `fbcc01af7de0daaadf3f23201f534e80cb7ab065` was read **FULL** alongside current original `5ce02ad702029014557116ce46d7d49036e0bdd7`. Historical audited Agent_X revision `5ebf471c09a6c18585c2b67f1b16ecf2ceaa06f0` remains a **source-reported** revision, not independently verified current DT parity. The following historical acceptance details are preserved for a **future user-authorized coder only**, conditional on live ownership, consumer, API and fixture inspection.

### Exact historical SyncAssessment / API diagnostic contract

Inspect the CURRENT schema before changes. Historical `SyncAssessment` suggested `verification_revision: str`, `verification_changed: bool`, and `verification_affected_files: tuple[str, ...]`; preserve accepted **and** current verification revisions, and exact changed paths only if accepted immutable snapshots support a diff. For aggregate-only v1 baselines, report paths **UNKNOWN**, never invent paths from Git HEAD. A refresh failure must report accepted/current revision, known changed paths, failed checks, unchanged accepted baseline and denied write authority. Historical API example: `policy_decision="verification_refresh_required"`, `retryable=false`, `run_id` plus informative `error` and `detail`, with status code determined by **current** API policy. Provider-dependent transient failure may be retryable; do not label all mismatch as generic 403. Preserve diagnostic compatibility without giving `ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD` a false chronological meaning.

### Minimal immutable evidence and legacy migration

Before exact file-level diff, compare accepted immutable verification snapshot with current `verification_snapshot(root)` (path→hash); bind a new immutable verification source snapshot/hash and accepted verification-requirements digest only if current artifacts cannot already express them. Conservative v1 aggregate-only migration must retain mismatch/unknown-path status, reverify and remint canonically, never silently reinterpret old fields. Preserve portability across repository location changes and canonical identity rules. A new target+verification pair must bind unchanged semantic/production revisions, actual current production snapshot, verification revision, repository identity, refresh ID and verification requirements. Reject mismatched pairs and unauthorized evidence consumption.

### Mandatory conditional verification procedure

On an authorized disposable fixture: parse/load every changed verification source; execute required deterministic checks; compare protected test/guardrail **coverage and assertions** against accepted requirements, not merely green exit status. Run synchronization and semantic-first enforcement suites, exact pending-request UI regression, model reconciliation, canonical target and proof issuance, canonical baseline promotion, backend restart, and **two independent consecutive no-change `SYNCED` assessments after restart**. Independently check destination effects and preserved mutation authorization. Historical exact request was `continue completing everything according to: /home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md`; this is **historical fixture text, not permission or a path to access now**. A successful refresh must continue that *same logical pending request* through ordinary semantic-first authorization; no stale UI deadlock.

### Explicit forbidden shortcuts

Never remove the verification revision check; overwrite `baseline.verification_revision` with current merely to pass; assume changed tests harmless; hand-edit `semantic_code_sync.json`; mark `STALE_BASE` as PASS; authorize writes with stale verification; exclude tests/proofs from `verification_snapshot()` merely to silence a mismatch; or move tests/proof files into production `source_snapshot()`. Do not turn historical trusted bootstrap into a standing bypass. Keep source/test/proof projections distinct, and runtime-issued artifacts out of recursive verification hashing.

### Historical 30-condition completion matrix (all individually checkable; future authorized tests only)

1. Verification mismatch is not an early return before semantic/implementation assessment.
2. All three projections are assessed together.
3. Verification-only drift has a recoverable state distinct from `SYNCED` and unrecoverable `STALE_BASE`.
4. Changed tests cannot mask implementation drift.
5. Changed tests cannot mask semantic drift.
6. Changed tests cannot mask simultaneous semantic and implementation divergence.
7. Verification-only drift grants no project-mutation authority.
8. A governed canonical verification-only refresh exists where applicable.
9. Refresh executes actual verification.
10. Changed tests are not automatically trusted; protected coverage is checked.
11. Failed refresh leaves the old accepted baseline intact.
12. Refresh issues a newly coherent target+verification evidence pair.
13. Refresh never replays consumed verification evidence.
14. Refresh baseline is produced through the canonical builder.
15. Relevant conflicts bind verification revisions.
16. A conflict becomes invalid if verification changes again.
17. Runtime-issued semantic evidence does not recursively change verification revision.
18. Immediate no-change reassessment after refresh remains stable.
19. Safe verification-only drift is recovered before continuing the original pending build request.
20. Implementation+verification drift yields `IMPLEMENTATION_AHEAD`, not `STALE_BASE`.
21. Semantic+verification drift yields `SEMANTIC_AHEAD`.
22. Three-way drift yields `BOTH_DIVERGED`.
23. Recoverable non-`SYNCED` semantic/production divergence carries a real conflict.
24. Corrupt baseline or evidence still fails closed.
25. No manual canonical JSON edits are needed.
26. The exact historical build-request regression no longer deadlocks on `ACCEPTED_SYNC_VERIFICATION_REVISION_AHEAD`.
27. Normal semantic-first authorization still runs **after** recovery.
28. Exact project-mutation authorization and write scope remain unchanged.
29. Independent final synchronization assessment returns `SYNCED`.
30. Second no-change assessment remains `SYNCED`.

These are historical **acceptance hypotheses**, not claims of executed tests or current DT defects. Future coder must first inspect current DT source, tests, consumer and permissions; exit `ALREADY_PRESENT`, `NO_APPLICABILITY`/`NO_CURRENT_CONSUMER` or `NO_AUTHORIZED_FIXTURE` as appropriate. Record actual real-test and commit evidence only if separately authorized.

**Independent Scout handoff:** Compare all five previously flagged groups (30 conditions; SyncAssessment/API diagnostics; v1 immutable migration; parse/coverage/restart/double-SYNCED and exact UI regression; forbidden shortcuts) against the full historical and live originals. Original remains untouched pending Scout-only independent audit/deletion.
