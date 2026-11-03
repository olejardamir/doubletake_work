# Semantic-first simplification — distilled historical proposal

**Provenance:** Historical Agent_X cleanup proposal, originally anchored to DT commit `b8221098156f0145f2319f38b2db82b63dd934d7`. Previous complete text: Git blob `84ff4a6ffe9ec4d02fe8dc29daa3a6f7ffd3e08c` (recoverable through Git history). This is unverified historical design, **not** authorization to remove present DT components. Current implementation parity, tests and outcome UNKNOWN. Re-audit current private DT/main before adopting.

## Minimal architectural contract
Original user request (including an explicitly supplied external document/path) → bounded semantic preflight (intent, target delta, affected component ownership and known bindings) → coding agent independently reads, plans, edits and iterates → focused checks and regeneration of affected semantic model **from actual changed code** → atomic reconciliation. The coding agent, not semantic-first, owns requirement decomposition and iteration. Do not replace a deleted task framework with a renamed one.

**Authority:** User request defines intent; current semantic model describes capabilities, owners, interfaces, dependencies, invariants and bindings; coding agent implements; actual repository is implementation truth. Preserve original user request verbatim. A provider saying “done” cannot mark backend completion. A UI cannot mint authority.

**Keep:** deterministic exact-path write authorization, project/root containment, credentials and effect boundaries, transaction/lock/rollback safety, current-code ownership mapping, semantic intent/preflight, narrow scope amendment, safe read-only external document materialization and digest, bounded provider timeout/failover and strict schema validation, actual-code rescanning, atomic sync/conflict records. Broad governed repository reads are distinct from exact write scope. Unknown newly needed write path: resolve owner against accepted target; authorize narrowly or deny; do not rebuild the whole task. Provider failure before preflight blocks mutation, never triggers permissive fallback.

**Remove if current-code audit confirms redundancy:** spec-compliance requirement extraction/manifest/ledger, specification execution task/slice engine, runtime implementation packets and giant generated prompts, duplicate project-management loops, requirement-count UI, prose-based completion (`loopDeclaredDone`), duplicated drift/evidence/synchronization records and dead compatibility wrappers. Historical suspected loci: `semantic_first/spec_compliance.py`, `runtime_handoff.py`, `pipeline.py`, `interceptor.py`, `materialize.py`, `write_scope.py`, `synchronization.py`, `evidence.py`, `drift_detector.py`, `enrichment.py`, `project_model.py`, `api/semantic_gate.py`, chat provider callers and frontend. These are audit targets, not proof files still exist. Preserve legitimate migration/retention requirements and tests for actual safety invariants.

## Reconciliation and durable behavior
Suggested lifecycle: REQUESTED → PREFLIGHTED → CODING → RECONCILING → SYNCED / NEEDS_FIX / CONFLICT / NO_IMPLEMENTATION_EFFECT / BLOCKED. Mutation expected + no relevant code effect must **not** become success; a genuine read-only/no-op task may succeed. Changed paths must be authorized, focused tests must pass, regenerated semantics must match accepted target and **only then** promote semantic model plus sync revision atomically. Failed final checks cannot leave semantics describing rolled-back code. Reconciliation of unchanged accepted code is idempotent. Rename/move updates binding identity without duplicating capability; replacement must remove obsolete owner. Crash/restart must reconcile actual worktree before resuming, without resurrecting stale write authority. Never promise rollback for files not actually restorable; fail before mutation if required rollback cannot be guaranteed.

**Small state:** current project semantic model, accepted sync revision, bounded run-local target/diagnostics; keep audit/reproducibility evidence that enforces real invariants. Git history is not a substitute for needed protected runtime state.

## Falsifiable acceptance
1. Simple authorized code change → focused checks → SYNCED; repeat unchanged → SYNCED with no state churn.
2. New relevant path → narrow scope amendment permits; unrelated path → denies without interrupting read-only work.
3. Mutation expected, zero code change → NO_IMPLEMENTATION_EFFECT, regardless of provider prose.
4. Semantic mismatch → NEEDS_FIX with concise discrepancy, no premature promotion; stale concurrent change → CONFLICT.
5. Explicit large external specification → validated read-only access, original request/path reaches coding agent; no giant requirement manifest.
6. Provider unavailable, invalid schema, unauthorized path or failed final verification → fail closed, no state promotion.
7. Actual affected code rescanned; frontend completion derives from backend result, not textual completion or requirement counters.
8. Historical Harvest test: original user request must cause actual relevant Harvest edits and reconciliation; specifically audit any surviving `agentx_status` authority, disposition-only `can_implement()`, `EXPERIMENT_ONLY` eligibility, `(ui_api_wired or True)` bypass and Gate B claiming mutation authority. These are **historical suspected defects**, not confirmed present bugs.
9. Before/after production LOC, state concepts, dead references, ownership paths, security regression tests and independent caller behavior measured. Do not chase arbitrary LOC reduction if safety is lost.

**Migration:** audit current code and references first; adapt existing preflight/target/write-scope/reconciliation interfaces; switch provider callers and backend finalization to one authority; delete obsolete paths and tests; run actual representative end-to-end tasks; independently inspect accepted revision. Never leave old and new completion authorities active simultaneously.

**Present DT applicability (hypothesis):** concise preflight and exact-blob mission consumption may inform current GPT-only source/test workflow, but there is no running DT host and no demonstrated local runtime Ground. Historical spec is not a current implementation instruction; Director must compare against present private source and authorize any changes.
