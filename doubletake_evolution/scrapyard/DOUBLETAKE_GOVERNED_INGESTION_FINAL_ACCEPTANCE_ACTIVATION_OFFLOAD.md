# DOUBLETAKE — GOVERNED INGESTION FINAL ACCEPTANCE AND ACTIVATION
## Single bounded execution prompt — remaining work only

**Mission:** `DOUBLETAKE_GOVERNED_INGESTION_CLOSURE`

**Baseline verified from remote `olejardamir/DT` `main`:** `fa154adb0807451ba9119eca0b3836690178b0a5` (2026-10-28 17:45:17 UTC). Treat this as a reference, **not** as a pinned target; recheck remote/current HEAD, other agents' ownership, state and evidence before acting.

**Already completed — DO NOT REIMPLEMENT:** Earlier closure Tasks 1–5, including diagnosis, dispatcher/queue, integrated local synthetic ingestion/API/UI test evidence and 85-row G/S/SI closure matrix. The inspected `reports/governed_ingestion/closure/05_closure_matrix.json` has `decision.status=READY_FOR_ACCEPTANCE`, `blocked_by=[]`, and no missing or stale evidence rows. Do not repeat WP1–WP15, redesign G4/G5/G6/G13/G23/G24/G25/G30, or generate unchanged evidence. The checkpoint may still display `REVALIDATE_CHECKPOINT(WP0c)`; that is not an instruction to loop forever.

**Current unresolved state:** `reports/governed_ingestion/MISSION_ACCEPTANCE.json` has `status=AWAITING_AUTHORIZED_ACCEPTANCE`, `decision=null`; `reports/governed_ingestion/MISSION_STATE.json` records no authorized acceptance and no activated governed-ingestion release (`activation.version=NONE`, `release_count=0`). **Evidence readiness is not human authorization.** This prompt cannot grant permission, manufacture a signer, or authorize activation.

## Non-negotiable boundaries

- Follow `AGENTS.md`, the existing main-only / no-tags rule, valid ownership/leases, host resource guards and existing L0/L1/L2 policy. Do not add a kernel, new global manager, secret, external provider integration or production deployment.
- One authorized writer per changed file. Do not overwrite concurrent agent work. Inspect the latest `main` and use only existing authorized execution/worktree methods.
- Respect FIC scopes. `FIC-L1-PLAN-916` being present or draft **does not by itself authorize source edits, acceptance, or activation**. Obtain the appropriate approval via the existing review process if needed.
- No simulated, self-signed, forged, backdated or role-impersonated human decisions. A valid approval must be independently attributable and meet the actual policy. If human authority is unavailable, persist a clear waiting state and stop that branch.
- All verification uses locally permitted synthetic fixtures and the real current system boundaries; no live external networks, production credentials or models.
- Never turn `READY_FOR_ACCEPTANCE`, `VALIDATED`, `CHECKPOINTED` or `AWAITING_AUTHORIZED_ACCEPTANCE` into `ACCEPTED` solely to satisfy this prompt.

## Phase A — Fresh-state preflight (read-only)

1. Capture exact source HEAD (local and remote), branch, dirty state, concurrent worker ownership, and current hashes/records for:
   - `reports/governed_ingestion/closure/05_closure_matrix.json`
   - `reports/governed_ingestion/closure/06_acceptance_request.json`
   - `reports/governed_ingestion/MISSION_ACCEPTANCE.json`
   - `reports/governed_ingestion/MISSION_STATE.json`
   - Existing acceptance/release/human-review authority records and release pointers.
2. Verify `05_closure_matrix.json` still says `READY_FOR_ACCEPTANCE`, has exactly G1–G32, S1–S43 and SI-01–SI-10 (85 IDs), `blocked_by=[]`, no invalid/missing/stale evidence and genuinely bound integrated synthetic proofs. Re-run only necessary deterministic certifiers/tests through `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` with correct `PYTHONPATH` and the host guard. Verify refreshed inputs if HEAD changed; **do not refresh all WP evidence just because unrelated commits were added**.
3. If evidence has actually regressed, record exact failed IDs, source hashes and owning repair actions; stop acceptance until repaired. Avoid reverting to previously completed Tasks 1–5 by default.

**DoD A:** Source/evidence fingerprint recorded; readiness independently reproduced or a precise `BLOCKED_EVIDENCE` report exists; no unrelated source edits.

## Phase B — Complete Task 6: real acceptance decision

1. Inspect the actual authorized acceptance route, including `L1/docs/11_L1_REVIEW_GATE.md`, the human-review approval-history/revocation mechanism, `L1/controller/fic_validator.py` or current equivalents, and the governed-ingestion acceptance schema/validator. Determine required reviewer role, separation of duties, approval identity, scope, expiry, digest binding and decision format. Clearly distinguish FIC permission from mission acceptance permission.
2. Validate/regenerate **only when necessary** `reports/governed_ingestion/closure/06_acceptance_request.json`, binding the current accepted source/evidence hashes, matrix decision, integration outcomes, known synthetic-only limitations and activation implications. Keep a stable request ID for an identical payload.
3. Query the genuine independent review route for an approval covering this exact request and latest eligible evidence. Check signer/role, source and evidence scope, revocation/expiry, uniqueness/replay and self-approval prohibition using existing policy.
4. **If valid approval exists:** consume it through the existing authorized acceptance mechanism; validate and persist `MISSION_ACCEPTANCE.json` (and derived `MISSION_STATE.json`) as genuinely `ACCEPTED` only within its approved scope. Run appropriate negative governance tests (forged role, self-approval, revoked/expired/duplicate decision, changed digests) and the existing certifiers. Do not claim cryptographic provenance if the underlying approval history only attests identity.
5. **If valid approval does not exist:** retain `AWAITING_AUTHORIZED_ACCEPTANCE`, with a durable request reference, exact approver role/action, latest source/evidence binding and clear explanation. **Do not automatically approve, invent reviewer credentials, keep polling indefinitely, or treat this as an engineering defect.** Continue only independent authorized reporting work; do not execute activation requiring approval.

**DoD B:** Either a validated independently authorized acceptance record and passing governance checks **OR** a durable exact waiting-for-approval state. An acceptance request alone is not acceptance.

## Phase C — Complete Task 7: authorized local activation or truthful terminal handoff

1. Inspect the existing release/activation store, component contract, current candidate, dependency compatibility, L0 independence, in-flight pin/drain, rollback and policy safeguards. Do not create a parallel release manager or infer activation from a report.
2. Confirm a valid acceptance **and** the separate activation permission required by actual policy. Ensure the release candidate's hash equals the authorized artifact; rerun only impacted and mandatory safety checks.
3. **Only if fully authorized:** use the real existing release mechanism to perform **local synthetic** controlled activation; verify actual release pointer/version, dependency health, real smoke results, explicit rollback exercise and audit/activation receipts. After rollback test, establish and verify the intended final state under the authorized procedure. Do not imply external production deployment.
4. **Otherwise:** do not activate; persist final qualified status `VALIDATED_AWAITING_AUTHORIZATION` / `AWAITING_ACTIVATION_AUTHORIZATION` / `BLOCKED_EVIDENCE` as applicable. Record exact single next owner/action and resume criteria. Do not call an unactivated system 100% accepted/deployed.
5. Ensure subsequent restart/handoff at identical source/evidence is a terminal no-op or precise wait, **not** another WP0c revalidation/evidence-commit loop. If a later genuine approval arrives, reevaluate its bindings and resume the specific pending phase, not Tasks 1–5. Verify tests against the actual entrypoint, not an unused helper.

**DoD C:** Either an authorized, verified, rollback-tested local activated version with durable evidence **OR** a complete, persisted, non-looping terminal waiting/blocked handoff with exact approver/action. Production deployment remains out of scope.

## Mandatory final response — one concise report

```text
MISSION: DOUBLETAKE_GOVERNED_INGESTION_CLOSURE
CURRENT_MAIN_HEAD: <SHA + UTC time>
EVIDENCE_MATRIX: READY_FOR_ACCEPTANCE | BLOCKED_EVIDENCE (<IDs>)
TASK_6: ACCEPTED_AUTHORIZED | AWAITING_AUTHORIZED_ACCEPTANCE | BLOCKED_EVIDENCE
ACCEPTANCE_REQUEST: <path, id, digest>
ACCEPTANCE_DECISION: <real authority/record validation OR NONE>
TASK_7: ACTIVATED_LOCAL_VERIFIED | AWAITING_ACTIVATION_AUTHORIZATION | NOT_AUTHORIZED | BLOCKED_EVIDENCE
ACTIVATION: <actual pointer/version OR NONE>
ROLLBACK_SMOKE: <actual test and result OR NOT_RUN>
TESTS: <exact guarded commands, real passed/failed counts, source bindings>
CHANGED_FILES: <paths or NONE>
FINAL_REPORT: <authorized repo path and hash, if created>
NEXT_OWNER_AND_SINGLE_ACTION: <role + exact action, or NONE if terminal accepted/activated>
OVERALL: <engineering validated versus formally accepted versus locally activated versus externally deployed — separate statuses>
```

**Stop condition:** Once formal acceptance and local activation have been verified, or a durable waiting-on-independent-authority status has been persisted, **stop**. No endless retries, no unapproved permission shortcuts, no unnecessary reimplementation, and no invented 100% completion.
