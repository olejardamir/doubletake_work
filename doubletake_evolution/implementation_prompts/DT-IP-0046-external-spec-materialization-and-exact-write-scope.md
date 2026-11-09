# DT-IP-0046 — External specification materialization and exact write-scope derivation

**State:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. **Private DT parity:** UNKNOWN. This is a conditional instruction for a future user-invoked, authorized coder, not a current defect finding, permission to implement, or test result.

## Source and provenance
- FULL current public original: `doubletake_evolution/scrapyard/AGENT_X_FINAL_SEMANTIC_FIRST_GAP_CLOSURE.md`; blob `4bd90c19e74e3c9c2dc00b2445006938c726f96f`, main link: https://github.com/olejardamir/doubletake_work/blob/main/doubletake_evolution/scrapyard/AGENT_X_FINAL_SEMANTIC_FIRST_GAP_CLOSURE.md
- Earlier full historical original identified by the current distilled source: Git blob `38cb0850be0c841aca92aa94808494b22006db9f` (25,725 UTF-8 bytes), historical Agent_X main `1346909f726b688046936f551bbf12607278806b`. **Historical blob independently retrieved in 2026-11-09 coverage-gap repair**; Scout must still independently compare complete source and prompt before retirement.
- Source is a historical Agent_X four-defect assertion, not observed current DT truth. It references no cleared third-party code. Source and derived prompt remain subject to repository and upstream license review; do not copy unlicensed code, private code, credentials or private fixtures.

## Distinct bounded objective
If current DT has an authorized semantic-first request interpreter that reads user-specified specifications and computes a mutation scope, enforce **two independent boundaries**: explicitly authorized external specification read is not external write authority; affected capability is not permission to modify every associated implementation file. Preserve the exact source digest through interpretation and mutation, and independently verify the resulting canonical baseline. Do not replace a working existing owner.

## Future-coder preflight and stop gates
Inspect current private DT source, tests, actual request entrypoint, owner, semantic transaction, consumer, permissions, and source/workspace path policies. Check adjacent queued semantic synchronization/effect contracts (especially DT-IP-0039 and DT-IP-0045) to avoid duplicating existing mechanisms. Stop with `ALREADY_PRESENT` if behavior and negative tests already hold; `NO_APPLICABILITY` if no real request interpreter/write-scope consumer; `NO_AUTHORIZED_FIXTURE` if a safe disposable test seam or permission is absent. Record the evidence. Only an explicit future user invocation may authorize implementation and real tests.

## Conditional technical contract
1. **External read-only source topology:** Distinguish explicit source-read policy from repository mutation policy. Accept an explicitly named absolute regular-file spec outside the workspace only when owner policy permits; resolve symlinks and reject missing files, directories, devices/sockets, oversize/unsupported inputs, globs, recursive traversal and implicit home/env discovery. Preserve absolute source identity internally (e.g. `external-file:<digest>`) and digest; never counterfeit a repository-relative path or grant outside-workspace writes.
2. **Materialize before interpreting:** Raw request → governed explicit source materialization → semantic request context → interpretation → target design. A single `MaterializedRequest(original_text, sources, augmented_text, source_digest)` identity/digest must reach interpretation, design, overlay, scope and freshness checks. Treat source text as untrusted data, not instructions or authorization. Before mutation, rehash the bound source; changed bytes revoke stale authorization and require rematerialization, interpretation, redesign and resealing. Do not perform redundant normal-path materializations.
3. **Exact target-to-write mapping:** An affected capability is impact evidence, never blanket write permission. Derive paths from accepted semantic target, per-component `implementation_action` (`none|modify_existing|replace_existing|remove_existing|create_new`), exact `implementation_targets`, `proposed_new_paths`, canonical bindings, owner and rationale. Recognize exact `binding:`, `module:`, `interface:`, `identity:`, `responsibility:` identifiers or uniquely resolved plain IDs. Ambiguous resolution fails `UNRESOLVED_WRITE_SCOPE`. `none` yields zero paths. Modify only exact bound implementation; replacement includes only justified incumbent/replacement/caller/registration/config/migration/test effects; removal selects exact obsolete target. New paths must be repository-relative, non-escaping, non-colliding and owner-bound. Capability fallback only when exactly one relevant implementation path is provable. Read/verification scope may be broader. One bounded governed scope repair may return canonical IDs, **not** arbitrary paths; a second failure stops. Record action, target, binding and derivation for every writable path; remain coherent with accepted prompt-only/prompt-driven/deterministic authority.
4. **Verification and baseline:** After authorized code/test changes, use canonical tools, not hand-edited JSON, to regenerate the semantic model and compute production `source_snapshot`, implementation, verification and semantic/model revisions. Bind fresh paired target/verification evidence, atomically validate/consume/persist synchronization; reject reused evidence, stale base, wrong repository, drift/conflict, missing evidence and transaction debris. Verify independent `SYNCED` on exact revision equality, again with no changes, and after restart. Do not treat a stored status label, unit-only green or one UI startup as Ground. Coordinate with existing DT-IP-0045 verification-only recovery rather than replacing it.

## Discriminating tests and negative cases (future authorized tests only)
- Repository `/tmp/repo/Agent_X`, explicitly requested outside spec `/tmp/downloads/spec.md`: allowed read/digest and content propagation; **no** write to source. A shared parent `tmp_path` is not sufficient.
- Sentinel `SEMANTIC_SPEC_SENTINEL_123` appears in the *interpretation* provider input, not merely target design; same materialization identity/digest persists. Change bytes before first mutation: stale seal denied, rematerialization/reinterpretation required.
- Capability C with B1→`a.py`, B2→`b.py`: `binding:B1` authorizes only `a.py` writes; both may be read. `none` writes nothing; ambiguous plain ID fails; exact module selects one; replacement only justified effects.
- Reject absolute, traversal, symlink-escape, outside-worktree, generated-state and colliding new paths, gratuitous `*_v2` shadow owners, forged IDs and arbitrary-path repair; failed repair never loops indefinitely.
- Actual user flow must preserve digest and authorization from explicit source through interpretation, target, scope and runtime. If already implemented, canonical no-op is correct; never fabricate writes.
- Regressions: bootstrap, provider timeout/failover, governed kwargs, contract repair, revision recovery, scope, effect enforcement, finalization, restart, fresh paired baseline and no accumulated change/run-state junk. Preserve unrelated working subsystems.


## Historical full-source COVERAGE_GAP repair (conditional, not executed)
The historical full Git blob `38cb0850be0c841aca92aa94808494b22006db9f` was independently retrieved for this repair. The following requirements preserve the distinct original §2, §18, §26 and §29 clauses. Historical absolute paths and names are **test scenario identifiers only**; never access a real person's file or execute a private runtime without future explicit authorization and a disposable approved fixture.

**Governed interpretation input (§2):** The interpretation call must receive all four separately traceable inputs: (1) ORIGINAL USER REQUEST verbatim, (2) SOURCE PROVENANCE including exact external path/identity and digest, (3) MATERIALIZED SOURCE CONTENT rather than a path placeholder, and (4) CURRENT CANONICAL PROJECT MODEL with its revision. Preserve these together in the same transaction and do not let external text override system or user authority. Test a missing/stale model, substituted provenance, changed source and absent original request as distinct failure gates.

**Exact real-UI regression (§18):** The historical request was `continue completing everything according to:\n/home/glompy/Downloads/AGENT_X_FINAL_SEMANTIC_FIRST_CLOSURE_CURRENT_MAIN.md`. Future authorized testing must reproduce this *topology and request semantics* with a safely controlled equivalent file; do not read the historical user's path without authorization. Verify external source read, digest, full interpretation input, shared design digest, exact targets, nonempty mutation scope **iff** actual work remains, exclusion of unrelated files, semantic coherence, and entry into coding runtime **iff** work remains and separately authorized. When fully satisfied, assert canonical no-op, not synthetic mutation. A `/tmp` unit fixture alone does not replace an authorized UI end-to-end test.

**Restart acceptance (§26):** Following canonical remint and restart, load persisted state, independently assess `SYNCED`, then exercise **both** a read-only request **and** the exact external-spec build request (or authorized topology-preserving substitute). Both must use the newly reminted baseline; do not accept an in-memory-only result.

**Historical 38-condition acceptance matrix (§29; each independently testable and conditional):**
1. Explicit outside-repository files are read-only materializable under policy.
2. Arbitrary filesystem crawling remains denied.
3. External source never confers mutation authority.
4. External source digest is recorded.
5. Materialization precedes semantic interpretation.
6. Interpretation receives actual source content.
7. Target design uses identical source identity/digest.
8. Revalidate source digest before first mutation.
9. Changed source invalidates stale target/authorization.
10. Mutation scope derives from exact target, not broad capability.
11. `implementation_action=none` grants no writes.
12. Exact `implementation_targets` govern existing-file changes.
13. Canonical target namespaces resolve deterministically.
14. Ambiguous targets fail closed.
15. Multiple bindings do not authorize every associated path.
16. Read scope may be broader than mutation scope.
17. Verification scope may be broader than mutation scope.
18. New files require exact validated paths.
19. At most one bounded governed scope-repair attempt may resolve targets.
20. Repair output cannot authorize arbitrary paths.
21. Unresolved repair ends `UNRESOLVED_WRITE_SCOPE`.
22. Replacement includes only required supersession paths.
23. Every writable path has provenance.
24. Real outside-workspace regression passes.
25. Interpretation sentinel proves pre-interpretation content delivery.
26. Exact historical external-spec request reaches semantic design.
27. Same request reaches coding runtime only when actual work remains and future authority permits.
28. Fully satisfied spec returns canonical no-op.
29. Canonical semantic model is regenerated/reconciled, not hand-edited.
30. Recomputed production implementation revision equals evidence.
31. Recomputed semantic/model revision equals evidence.
32. Recomputed verification revision equals evidence.
33. Target and verification artifacts are fresh, coherent and paired.
34. `semantic_code_sync.json` reminted from current code, not historical September 13 state.
35. Fresh independent synchronization assessment returns `SYNCED`.
36. Immediate unchanged second assessment returns `SYNCED`.
37. Backend restart loads and independently confirms `SYNCED`.
38. No `semantic_project/changes/` or run-state transaction junk accumulates.

**Scope and evidence:** Each numbered item is an acceptance hypothesis for an applicable, authorized future consumer, **not** an instruction to access Agent_X or private DT now. If the current private system has no such consumer, exit `NO_APPLICABILITY`; if already correct, `ALREADY_PRESENT`; without an approved safe fixture, `NO_AUTHORIZED_FIXTURE`. Future coder must provide real positive and negative test receipts for applicable items, never claim passes from this prompt alone.

## Dependency/consumer hypotheses and evidence
Likely owners: governed materializer, semantic interpreter, target planner, write-scope resolver, mutation interceptor, canonical sync/evidence store. **Hypotheses only** until current DT inspection. Record current owner/consumer mapping, source revision, policy and fixture approval, baseline failures, positive/negative real tests, exact authorized code/test commits and independent receipts. The historical source's 38 criteria are not current acceptance proof. No current DT implementation, private test, B1/B7 outcome or source deletion is asserted.

## Coverage handoff for independent Scout
Current compact source's four numbered clauses preserved: external source/read-vs-write, materialization-before-interpretation and freshness, exact per-target scope, fresh baseline/restart verification. Also preserved external topology/sentinel/B1-B2/no-op/new-path/repair/rollback/restart negative tests, historical source pointers, authority caveats and current parity unknown. Scout must independently reread historical blob and identify any uncovered historical clause before retiring original.
