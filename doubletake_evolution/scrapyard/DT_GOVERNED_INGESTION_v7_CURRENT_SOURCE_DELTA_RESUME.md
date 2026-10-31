# DOUBLETAKE — GOVERNED INGESTION v7: CURRENT-SOURCE DELTA RESUME

**Single active execution prompt.** This supersedes `DT_GOVERNED_INGESTION_REMAINING_WORK_v6.md` as the *execution driver* only. It does **not** supersede the original technical/security requirements in `reports/governed_ingestion/mission_source.md` (v3), `AGENTS.md`, or current L0/L1 governance. Earlier v4 and the seven-task closure instructions are supporting history, never simultaneous controllers.

**Repository:** `olejardamir/DT`, `main`. **Last remotely inspected HEAD:** `c3fdf547c18f46cf11c576d8c7b3ba89a7847fa8` (2026-10-28 18:14:48 UTC). **This is a reference snapshot, not a pinned execution target**: read current `main` and peer edits before acting.

## 1. Mission and boundary

Finish the **original DoubleTake-native governed-ingestion capability**, not a replacement architecture, new orchestration system, or unrelated closure campaign. The required synthetic inward-only flow is:

`requester → filtered catalogue → schema-constrained request → effective rights/policy → different-authority, digest-bound approval → governed connector/runner → local synthetic source → quarantine and inspection → atomic target landing → immutable/filtered audit and status → existing HTTP API/React UI`.

Preserve the v3 mission's G1–G32, S1–S43 and SI-01–SI-10 obligations, L0 independence, L1 FIC/promotion authority, L2 spec-only boundary, controlled agent tool set, secrets by reference, model-independent mock provider, rights revalidation, bounded scheduling/recovery, anti-SSRF/proxy/redirect/DNS and archive controls, lifecycle/rollback, and no exfiltration. No real organizational data, real credentials, production or cloud/Databricks/Azure connections, compulsory GPU/Docker/model downloads, copied third-party implementation, or claims of production certification.

## 2. Grounding: what the current inspected repository actually says

These observations are **committed records, not fresh locally rerun proof**. Re-measure only when source or binding genuinely changes.

| Surface | Concrete inspected observation | Consequence |
|---|---|---|
| `reports/governed_ingestion/mission_source.md` | Full v3 original mission text exists in repository | Mandatory requirements source; do not replace with abbreviated closure plan |
| `AGENTS.md` | Main-only/no-tags; detached worktrees only as authorized; guarded host workloads | Respect repository-level permissions and resource limits |
| `reports/governed_ingestion/closure/05_closure_matrix.json` | `READY_FOR_ACCEPTANCE`; 85/85 G/S/SI rows, zero `blocked_by`, 19 `CLOSED`, 2 `CLOSED_DECISION_READY`, 7 `DECISION_READY`, 4 `OUT_OF_SCOPE`, 43 S `PASS`, 10 SI `PASS` | Do not rebuild closed WP1–WP15; independently certify source applicability |
| `reports/governed_ingestion/closure/04_integrated_ingress.json` | Recorded API/controller/runner/atomic landing, filtered status, negative, crash, concurrency and Chromium UI measurements; 4 functional integration tests passed in recorded run | Reuse unless a changed seam invalidates it; limitations must remain explicit |
| `reports/governed_ingestion/closure/06_acceptance_request.json` | Bound independent-approval request exists | Validate against current evidence, actual human-review authority and approver identity |
| `reports/governed_ingestion/MISSION_ACCEPTANCE.json` | `AWAITING_AUTHORIZED_ACCEPTANCE`, no recorded decision | **Not accepted**; cannot self-approve |
| `reports/governed_ingestion/MISSION_STATE.json` | No activated governed-ingestion release; `version: NONE`, release count 0; read-only handoff selects `REVALIDATE_CHECKPOINT(WP0c)` | **Not activated**; handoff selection is not successful dispatch or permission |
| `tools/doubletake_evolve/governed_ingestion/mission_state.py` | Checkpoint and pure planning; no automatic acceptance | Do not treat `resume()` or `--handoff` as executing the mission |
| `tools/doubletake_evolve/governed_ingestion/closure_dispatch.py` | Authorized checkpoint verification receipt and bounded dispatcher exist | Use this flow, avoid second manager/eternal WP0c loop |
| `tools/doubletake_evolve/governed_ingestion/closure_queue.py` + `reports/governed_ingestion/closure/queue.json` | Durable Task 4/5 recorded VERIFIED; Task 6 waiting authorization; Task 7 not yet executed; queue fingerprints recorded for older inputs | **Important possible stale-state issue:** reconcile queue snapshots against current matrix and acceptance record before interpreting task readiness |
| `reports/governed_ingestion/closure/dispatch_state.json` | Recorded receipt for Task 2 at an older checkpoint, dispatcher selected Task 3 in that snapshot | Confirm current dispatcher/queue agree; no blanket rebind cascade |

**Repository observations do not prove:** current local uncommitted code state, that a human approved the mission, that activation happened, or that all original v3 interfaces were freshly exercised at latest HEAD. Verify these locally, explicitly.

## 3. Start with authoritative reconciliation, not implementation

1. Read the entire current `AGENTS.md`, `reports/governed_ingestion/mission_source.md`, `DT_GOVERNED_INGESTION_REMAINING_WORK_v6.md` if available, all current FICs relevant to target files, and `README.md`/governance policies. Confirm the active controller has this v7 instruction; do not infer worker activation from the presence of a Markdown file.
2. In the actual DT checkout, capture: `git rev-parse HEAD`, `git status --porcelain`, `git branch --show-current`, configured remotes, ownership of dirty files, active workers, FIC scopes and valid authorization. Never overwrite another worker's work. Honor main-only and no-tags.
3. **Read and trace actual code** (not just report summaries): identity/policy, agent/tool boundary, catalogue/request digest, independent approval and human review, connector/runner/landing/inspection, scheduler/retention, secrets handling, status/audit, FastAPI and React ingestion panel, lifecycle/promotion, mission state, dispatcher, durable queue and their tests. Use directory discovery if paths moved. Map the concrete callable/entrypoint and meaningful positive/negative assertion for every integrated seam.
4. Execute read-only validation under the required guard. Example commands, only after confirming current CLI semantics:
   ```bash
   python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 tools/doubletake_evolve/governed_ingestion/mission_state.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 tools/doubletake_evolve/governed_ingestion/mission_state.py --handoff
   ```
   Run focused mission, closure queue/dispatcher, acceptance, evidence, E2E and release tests sequentially through the guard; collect test counts and exit codes. Verify that `--verify` performs no mutations.
5. Compare `closure/queue.json` fingerprints and inputs with the **actual** current `closure/05_closure_matrix.json`, `MISSION_ACCEPTANCE.json`, and `MISSION_STATE.json`; detect stale Task 5/6/7 state. A prior `WAITING_EXTERNAL_AUTHORIZATION` based on a now-cleared 10-blocker matrix must not be reused as if it described the present evidence. Preserve historical attempts; refresh only affected dependencies under proper FIC, without fabricating outcome or redoing the 85-row evaluation if it still passes.
6. Produce a compact, evidence-backed delta table with exact files/functions, test outcomes and a declaration for each item: `VERIFIED_DONE`, `STILL_REQUIRED`, `BLOCKED_AUTHORIZATION`, `BLOCKED_EVIDENCE`, `EXTERNAL_OUT_OF_SCOPE`. Do not schedule completed units. If a genuine regression is found, add only a bounded authorized repair.

## 4. The only remaining executable work (conditional on Step 3)

### T1 — Repair stale closure handoff/queue **only if** current evidence proves it stale

- Reconcile the manager-backed Task 4–7 queue with the latest matrix, approval request, checkpoint and dispatcher receipt. Do not create a new queue, controller, FIC mechanism or seed kernel.
- Ensure successful unchanged WP0c verification yields an idempotent content-bound receipt and the *actual executor* chooses a real pending task, a precise wait state, or a terminal no-op. Distinguish read-only `--handoff` from executable dispatcher; `mission_state.resume()` must remain a pure plan.
- Two identical no-progress attempts trigger diagnostic/no-op or independent permitted task, never endless evidence-only commits.
- **DoD:** tests demonstrate restart-safe idempotency; no duplicate claims, approvals or effects; changed relevant digest invalidates only relevant receipts; corrupt evidence, missing FIC and concurrent writer fail closed; current workflow reaches explicit acceptance/activation path or truthful waiting state. If the mechanism already behaves correctly, record `REUSED_VERIFIED` and do not edit.

### T2 — Complete actual Task 6 independent mission acceptance, never agent self-approval

- Re-evaluate Task 5 matrix at a stable measured binding; no security failures, missing evidence or false PASS. Assert that 85/85 rows remain accounted for and valid. Preserve G29–G32 organizational boundaries and the synthetic-only limitations.
- Verify actual human-review approval policy, role/identity independence, approval-history/lookup validator, scope, digest, expiry, revocation, replay detection and the FIC authorization for writing acceptance records. A draft `FIC-L1-PLAN-916` or an agent-produced request is **not** an approved acceptance decision.
- Reconcile and validate the existing `06_acceptance_request.json` against the current matrix/source. Use the existing approved human-review route, not an invented reviewer, signature or implicit permission. If a genuine independent decision is present, verify signer, distinct authority, exact scope, source/evidence binding, freshness, and record acceptance through the real validator.
- If no valid independent decision exists, set/persist **`AWAITING_AUTHORIZED_ACCEPTANCE`** with exact owner/action and request identifier. Do not try to replace authorization with more reports, tests or role simulation. Other safe independent work may continue.
- **DoD:** acceptance request queryable after restart; genuine decision yields `ACCEPTED` only under independently validated authority, otherwise persists waiting and never claims ACCEPTED. Negative tests cover forged/self approval, scope drift, altered evidence, expired/revoked/replayed and duplicate decisions.

### T3 — Finish actual Task 7 through existing governed lifecycle, only if authorized

- Locate the real DT release/promotion registry/store and exact supported component-version contract. Check compatibility, active job pins/drain, permission boundary, rollback preconditions and current target pointer. No new release manager.
- **If accepted and release authority exists:** perform **local synthetic** activation only. Verify actual release pointer/version persisted in the real store; run end-to-end smoke through genuine API/controller/runner/landing/status/UI; test deliberate safe rollback and stale/incompatible version rejection. Preserve existing service and worker ownership.
- **If acceptance or activation authority is missing:** do not activate; write final qualified, restart-safe `AWAITING_AUTHORIZATION` status with the single precise decision/action owner. Do not mark a production deployment complete.
- **DoD:** activated route = validated authority + pointer + smoke + rollback + evidence; blocked route = precise terminal waiting state, no activation, no repeated WP0c/queue spin, and restart/no-op/authorization-arrives tests. Separate engineering validation, mission acceptance, local activation and production deployment in all reports.

### T4 — Recheck any true original-mission functional omissions, **not every historical WP**

The original v3 remains binding. The 85-row acceptance matrix means the assessed local scope is decision-ready, **not** that every transport or real deployment exists. Inspect its stored limitations, especially WP13 native lifecycle and integrated-ingress note about controller-composed landing versus a stand-alone land connector, audit event coverage, synthetic provider boundaries and unsupported transport modes. If a v3-required *local* path lacks actual integration proof and is mandatory, record exact missing seam and implement/test only with valid FIC, then refresh impacted evidence. If legitimately optional/deferred/out-of-scope, document without treating it as PASS or changing the acceptance matrix's semantics. Do **not** broaden work into real Azure, Databricks, employer infrastructure, enterprise IdP, real SFTP endpoints or production network isolation.

## 5. Allowed ordering and anti-loop rules

- Execute T1 only if current source demonstrates stale dispatch. Then T2. T3 only after genuine applicable authorization. T4 only for a proven mandatory functional gap; otherwise report `REUSED_VERIFIED` and do not build.
- Work with **one writer per changed file** and one global evidence coordinator. Do not serialize independent read-only inspections, but obey guarded workload limits and single-writer evidence requirements.
- Test locally before each source change and immediately after; do not regenerate all WP1–WP15 evidence because of unrelated commits. Re-bind only the semantic surfaces the certifier requires, preserving exact measured source and retained commit history. Missing retained history is not permission to recreate tags/branches.
- Never bypass FICs, forge human decisions, self-promote, edit a matrix to make it green, downgrade negative tests, loosen network controls, or silently omit original scope. Do not make an approval-required task appear completed through synthetic approval history.
- After two unchanged same-fingerprint no-progress cycles, stop that branch in a durable state; no indefinite retry or report-only commit churn.
- On actual inability to execute, report the exact blocking policy/owner/receipt and finish the response truthfully; do not claim background execution.

## 6. Final acceptance conditions / stop point

The mission may be declared **FULLY ACCEPTED AND LOCALLY ACTIVATED** only if all are true:

1. Original v3 locally applicable behavior and security invariants remain re-runnable, evidenced and no longer blocked; 85-row matrix still certifies `READY_FOR_ACCEPTANCE` or equivalent under current rules.
2. Genuine independent acceptance validated by the existing review authority; non-self approval, unchanged bound scope and evidence.
3. Controlled locally authorized release recorded in actual versioned store with verified pointer, healthy native smoke, safe rollback and failure tests.
4. Correct current task queue/checkpoint shows stable terminal behavior across restart; no evidence-only revalidation loop.
5. No unapproved L0 changes, real-system access, production claims, missing secrets safeguards or false positive test reports.

If an outside reviewer/release authority remains unavailable, the correct final result is **ENGINEERING_VALIDATED / AWAITING_AUTHORIZED_ACCEPTANCE** (or more precise blocker if the local tests fail), **NOT 100% accepted/activated**. This is an allowed truthful terminal handoff, not permission to manufacture authorization.

## 7. Mandatory worker report after each bounded attempt

```text
MISSION: DOUBLETAKE_GOVERNED_INGESTION_ORIGINAL_V3
ACTIVE_DRIVER: v7_CURRENT_SOURCE_DELTA_RESUME
SOURCE_HEAD_BEFORE / AFTER: <actual SHAs>
WORKTREE_AND_OWNERSHIP: <exact status and peer conflicts>
ORIGINAL_SPEC: reports/governed_ingestion/mission_source.md <digest>
VERIFIED_REUSE: <exact completed WPs and evidence hashes>
REAL_REMAINING_WORK: <only not-done T1–T4 with filename/function and DoD>
FIC_SCOPE: <approved IDs and files, or MISSING>
TESTS: <guarded command, assertions, collected/passed/failed, exit, timestamp>
EVIDENCE_MATRIX: <status, 85-row counts, invalid/missing/stale/blocked>
QUEUE_DISPATCH: <actual claimed task, fingerprint, receipt, idempotency result>
ACCEPTANCE: <real independent validated decision or AWAITING_AUTHORIZED_ACCEPTANCE>
ACTIVATION: <pointer/version and smoke/rollback proof or NONE>
LIMITATIONS: <original-spec exclusions and unrun cases>
TERMINAL_STATUS: FULLY_ACCEPTED_LOCALLY_ACTIVATED | ENGINEERING_VALIDATED_AWAITING_AUTHORIZATION | BLOCKED_EVIDENCE | BLOCKED_IMPLEMENTATION
NEXT_OWNER_ACTION: <one precise action, or NONE>
```

**Begin now:** inspect current `main`, verify original v3 obligations and current mission artifacts; build delta-only executable work from reality. Do not restart the governed-ingestion agent implementation, and do not run the separate seven-task deadlock prompt as an independent mission.
