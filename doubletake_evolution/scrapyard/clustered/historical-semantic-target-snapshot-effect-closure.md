# CL-SEMANTIC-TARGET-001 — Historical target authority, snapshot truth and tool-effect closure

**Scope:** Two fully read historical Agent_X semantic-first closure prompts, merged by their shared problem: a semantic model may appear synchronized while mutation scope, source classification or tool effects remain incorrectly authorized. This is public-safe historical research, **not** a current DT mission or evidence that present DT has these defects.

**Sources (recover exact original bytes via Git):**
- **SEM-TWO:** `scrapyard/AGENT_X_FINAL_TWO_GAP_CLOSURE.md`, last blob `b4d1c7f5c8c9384c61a55caf93ac9c0458f9848a`, historically audited main `0f46fe4b55bd952b3d9b1cc679dacb0ef852260d`. Two gaps: interpretation-only mutation and stale canonical semantic baseline.
- **SEM-THREE:** `scrapyard/AGENT_X_FINAL_3_GAP_SEMANTIC_FIRST_CLOSURE.md`, last blob `05caa0ff4c5b4aa4b049dfb059bdbfcd414d4d83`, historically audited main `7346f477f23fe38025875a6e459a27b6e96d0689`. Three gaps: stale snapshot remint, broad non-code classification, heuristic MCP effect contracts.
- Historical code symbols, example artifact names and baseline revisions are *source claims*. No current private DT source/tests, user-specific filesystem paths or protected history are reproduced; source authorship/license beyond existing repository provenance not independently verified.

## A. Impact analysis must not confer write authority (SEM-TWO)

**Defect alleged:** `write_scope.py` could promote `interpretation.affected_modules` directly into writable paths via a fallback. Interpretation's modules/capabilities/invariants/interfaces/responsibilities and transitive relationships may inform **read and verification scope**, but cannot authorize mutation.

**Canonical rule:** only an **accepted semantic target component** with `implementation_action != none` and explicit `implementation_targets` / `proposed_new_paths`, deterministically resolved to exact resources, may grant a write. Each mutation path must carry accepted-component provenance; otherwise `UNAUTHORIZED_SCOPE_DERIVATION` and fail closed. Unknown affected module may be unresolved read context, not an implicit write. Intended write with unresolved exact target gets at most one bounded governed repair, then `UNRESOLVED_WRITE_SCOPE`.

**Regression matrix:**
- `affected_modules=(tools.foo.bar)` with no accepted target → `tools/foo/bar.py` readable, **not writable**.
- Explicit `module:tools.foo.bar` target with `modify_existing` → only that file writable, provenance tied to target.
- `implementation_action=none` → no write even when interpretation marks the module affected.
- Capability touching A+B with no target → no write; explicit `binding:A` → A only; explicit `capability:C` → A+B **only if** that target resolves canonically.
- Affected invariant/interface without target → no write; explicit enforcement/interface target → exact enforcement/interface resource only.
- Unknown module + no target → unresolved read, empty mutation; unknown selected write target → fail closed. Audit all entity classes for direct-write fallback.

## B. Production snapshot truth must be consumer-based (SEM-THREE)

**Historical defect alleged:** accepted `source_hashes` contained `mcp-test-skill.skill` and `test-skill.skill` after `artifact_role()` / `source_snapshot()` rules changed. Stored `SYNCED` cannot override recomputed source reality. Arbitrary non-code `.json/.yaml/.yml/.toml/.ini/.cfg/.conf/.sh` extensions were being treated too broadly as production config.

**Role taxonomy:** runtime prompt, runtime configuration, runtime schema/contract, runtime-required data; verification/evidence, generated state, documentation, research, wishlist, archive/dataset, secret/private/external, unknown. Production authority requires deterministic **actual runtime consumption**, e.g. protected runtime/prompt/schema/config registry, production loader/import or protected manifest. Git tracking, filename, extension and historical acceptance are insufficient. An unknown remains outside implementation authority, but if excluding it could hide a protected deterministic responsibility, `SYNCED` must be blocked pending classification.

**Specific historical classification probes:** `dataset_stats.json`, `evidence_manifest.json`, `final_verdict.json`, `mcp-test-skill.skill`, `test-skill.skill` — determine actual consumer; do not assume non-runtime. A runtime-loaded prompt/config/schema/required data edit must alter implementation revision; arbitrary unrelated JSON/YAML/TOML, verification report or generated evidence must not. Newly untracked runtime-consumed config must be visible before commit. **Adversarial invariant:** the snapshot-boundary classifier/registry is protected implementation and must not exclude itself by modifying its own classification.

## C. Tool-effect authorization must be explicit (SEM-THREE)

**Historical defect alleged:** hard-coded read-only tool names and substrings (`git`, `commit`, `database`, `install`, `service`, `remote`) could influence effect class. They may be migration diagnostics but **not** final authorization.

Canonical registered tool contract must declare effect class, read-only status, argument schema/resource extractor, local/remote effects, exact file/Git/DB/environment/service/durable targets and rollback semantics. Closed classes: `read_only`, `exact_file`, `multi_file`, `git`, `database`, `dependency_environment`, `service_config`, `durable_project_state`, `remote_durable`, `unknown`. Missing metadata, unknown class, malformed or unresolved resource extractor → **DENY**, or amend/reseal the semantic target through existing authority.

For a file tool derive exact path(s); Git derives repository/worktree+operation; DB derives store+operation+target; dependency tool derives environment+package/action; service/remote tool derives exact resource identity. Authorization requires semantic target **AND** explicit tool-effect contract **AND** ordinary tool/MCP governance **AND** other required approvals. Human/provider approval does not override semantic denial. A tool registered read-only but observed mutating state must fail, record discrepancy and quarantine/revoke incorrect contract. Preserve observation as defense in depth for high-risk tools.

**Negative test set:** registered read-only query, exact file, multi-file, Git, DB, dependency install, service config, remote durable, durable project state, unknown/unregistered effect, missing effect metadata, resource extraction failure and observed read-only violation. Tool-name heuristics alone never permit a write.

## D. Canonical remint and independent synchronization (both sources)

After source/authority fixes, **never hand-edit** model/baseline JSON, source hashes, implementation revision or status labels. Recompute `source_snapshot()` and production `implementation_revision`, separate `verification_snapshot`/`verification_revision`, deterministic project facts and governed semantic model/enrichment; validate provenance, remove stale non-production bindings, run behavioral tests, reconcile actual production. Build baseline via canonical builder and persist model+baseline transactionally. Historical `semantic_project/semantic_code_sync.json` and September 13 recovery baseline were cited as stale in SEM-TWO; they are not current DT evidence.

Issue fresh target and verification evidence bound to the same change ID, run ID, repository identity, semantic/implementation revisions, target digest and current verification revision. Reject mismatched evidence, stale/replayed consumption, placeholder target, missing owner or unresolved write scope. Consume evidence **exactly once**; accepted baseline includes semantic, implementation, verification revisions, source hashes, bindings digest, repository identity, accepted target/change/run IDs.

**Required proof sequence:**
1. Fresh current production snapshot matches accepted model and baseline `source_hashes`; recomputed implementation revision matches baseline; arbitrary non-runtime file changes do not affect implementation truth.
2. Real external specification is materialized **before** interpretation, remains read-only, source digest freshness checked, and target design selects exact implementation paths. Background provider completion must invoke canonical semantic finalization; no wildcard tool authorization, stale-backend bypass or structural-fallback-only approval.
3. Governed ordinary UI request: run identity → semantic target → exact effect authorization → provider write (only if permitted) → verification → semantic reconciliation → canonical promotion → completed → independent `SYNCED`.
4. Immediately repeat synchronization with **no changes**: `SYNCED` again, no new canonical write or transient conflict.
5. Restart/reload model, baseline and consumed-evidence state: `SYNCED` again. Fresh checkout at a different absolute path independently `SYNCED` without rewriting canonical files.
6. Re-run original external-spec request: either real governed remaining work or canonical no-op; never interpretation-only writes, `EMPTY_WRITE_SET` deadlock, stale-base/timeout loops, effect-enum mismatch, provider kwarg failure or synthetic completion. Retention of legacy transaction history must follow owner policy; do not delete protected state to pass.

## E. Limits and DT gap mapping

The two documents are **chronological, not identical**: SEM-TWO focuses on interpretation/write-scope and remint; SEM-THREE expands into snapshot role classification and explicit tool-effect contracts. Their requirements are complementary; neither establishes that current DT lacks these mechanisms. Current DT B1 owner historical-integrity decision, B7 actual mission consumption, natural completed cycles, independent external assimilation and transfer Ground remain unverified. This cluster is a historical negative-test library, not a new Director handoff. Only current source/test evidence of a matching gap justifies an authorized, bounded test proposal. Related `clustered/historical-semantic-first-authorization-recovery.md` covers provider/transport and separate recovery failure modes.
