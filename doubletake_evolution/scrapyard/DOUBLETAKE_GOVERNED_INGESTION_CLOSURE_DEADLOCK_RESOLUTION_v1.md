# DoubleTake — Governed Ingestion Mission Closure Deadlock Resolution v1

> **EXECUTE, DO NOT MERELY PLAN.** This is a bounded continuation of the existing Governed Ingestion mission, not a new manager, kernel, independent mission, or blanket authorization to promote code. Identify and resolve the actual reason validated work is not progressing toward independently verified closure. Keep all existing governance and safety gates intact.
>
> **Repository observation:** `olejardamir/DT`, `main`, last observed `43d34264a175` (2026-10-27 15:02:35 UTC). `reports/governed_ingestion/MISSION_STATE.json` was generated at 2026-10-27 03:16:36 UTC, bound to `c3765d1698`, and reports WP1–WP15 `VALIDATED_NOT_ACCEPTED`, WP0 `IN_PROGRESS`, WP0c `CHECKPOINTED`, next action `REVALIDATE_CHECKPOINT WP0c`, no recorded `MISSION_ACCEPTANCE.json` and no activated mission release. **Reinspect the live checkout first; these observations may have changed.**
>
> **Confirmed design fact, not a bug assumption:** `tools/doubletake_evolve/governed_ingestion/mission_state.py` says the existing mission manager lacks mission-ID registration, so this mission uses a checkpoint fallback. WP0c deliberately cannot certify its own freshly written checkpoint. Its `resume()` returns a **plan only**; it executes nothing, grants no approval, and never accepts or activates a capability. Do not alter that behavior solely to silence a recurring handoff.

## 1. Governing constraints

1. Read current `AGENTS.md`, checked-out HEAD, branch/ref policy, live working tree, owners of concurrent files, current mission controller and active driver. `AGENTS.md`, current L0/L1/L2/FIC/review/promotion rules, and the original requirements in `reports/governed_ingestion/mission_source.md` outrank this mission instruction. Maintain main-only/no-tags; use detached worktrees only where allowed. Never overwrite concurrent edits.
2. Use the existing mission manager, governance controller, release/activation mechanisms, and evidence architecture. L0 remains minimal and independently runnable; L2 remains specification-only. Do not introduce a second mission controller, privileged bypass, special-case acceptance switch, unchecked release pointer, or new permanent kernel capability.
3. All experiment, test, proof, and build commands must run under `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` or the currently mandated equivalent. Respect single guarded workload, CPU/memory/task/deadline caps. Do not rerun the same failing or evidence-only loop indefinitely; no resource-limit bypass.
4. Synthetic fixtures and deterministic mock only; no live organizational integrations, private organizational data, real credentials, unauthorized egress or external model calls. Separate *requester approval for an ingestion job* from *human/governance approval of a code release*.
5. **Acceptance is not automatic.** If an authorized human or L1 review decision is required, generate a review-ready evidence package and an exact human decision request. Never impersonate the signer, invent an approval, infer one from green tests, or self-activate.

## 2. First: produce an evidence-based diagnosis (one bounded pass)

Inspect source, tests and most recent committed artifacts rather than relying on a prompt's progress number:

- `tools/doubletake_evolve/governed_ingestion/mission_state.py`, especially `build`, `defects`, `resume`, `next_runnable_action`, WP0c self-validation, approval and release-store detection.
- `tools/doubletake_evolve/governed_ingestion/tests/test_mission_state.py`, actual next-action expectations, independent verifier behavior, and relevant mission-state CLI.
- `tools/doubletake_evolve/mission_management/` actual campaign/mission registration interface and task-dispatch behavior. Determine who **currently owns mission completion**, if anyone; do not assume the fallback checkpoint is an executive agent.
- The current L1 FIC/decomposition validator, review/promotion gates, capability lifecycle, release store, human review interfaces, and allowed authorization path. Find the exact actor and record required for a genuine `ACCEPTED` decision.
- `reports/governed_ingestion/MISSION_STATE.json`, `BASELINE.json`, all `evidence/wp*.json`, `DECISION_RECORDS.md`, `docs/governed_agent/evidence_register.md`, relevant threat/risk registers, and any existing scenario or E2E evidence. For each report, distinguish **source-present**, **focused test green**, **integrated**, **independently reviewed**, **accepted**, **activated**, **deferred** and **unrun**.
- Actual in-flight workers and active v7 driver, if observable locally, including worker ownership of current mission files and any repeated no-op iterations.

Generate a concise `CLOSURE_DIAGNOSIS` with exact file/function/test references and categorize each potential failure:

| Category | Specific question |
|---|---|
| Scheduling | Is the system repeatedly picking WP0c because there is no downstream closure unit, or simply because checkpoint revalidation is the correct next step? |
| Authority | Does any existing L1 mechanism have authority to certify/accept the mission? Which approval remains absent? |
| Execution | Is the controller actually executing new closure tasks, or only generating resume plans and summaries? |
| Evidence | Are real browser E2E, complete synthetic end-to-end, negative security probes and comparison decisions actually present, independently checked and current? |
| Integration | Are individual WP gates green while multi-component paths remain untested? |
| Drift | Are recurring evidence rebuilds triggered by a real source change or an avoidable circular HEAD/digest dependency? |
| Human gate | Does final closure depend on a human decision that automation cannot make? |

**Do not label a deliberate WP0c revalidation as a deadlock until proven that completing it leads back to the same state with no authorized forward action.** If the main blocker is missing verification/authority rather than a code bug, address that precise blocker.

## 3. Establish a real, finite closure workflow without bypassing governance

Build a **read-only derived closure plan** using the existing mission manager/controller and currently authorized extension points. Prefer configuring/reusing a current task/action type over adding infrastructure. The plan must choose one of the following *truthful* next steps and cannot silently fall back to WP0c forever:

1. `REVALIDATE_CHECKPOINT` — required only when integrity/freshness actually needs verification; record the result and advance on green verification. Do not keep selecting an identical completed revalidation without changed inputs.
2. `RUN_MISSING_INTEGRATION_TEST` — precise test target/scenario, owner, command and completion evidence.
3. `REPAIR_VALIDATED_DEFECT` — bounded implementation fix, authorized FIC, exact regression proof, no reopening unrelated WPs.
4. `RECONCILE_DECISION_OR_EVIDENCE` — exact unresolved gap, comparison, source binding or negative security outcome; no vanity report churn.
5. `REQUEST_AUTHORIZED_REVIEW` — explicit review packet + authorized role + decision to obtain, without claiming it happened.
6. `PERFORM_GOVERNED_ACTIVATION` — only when the real approval, compatibility, security and rollback gates are satisfied and the actor has authority.
7. `CLOSED_ACCEPTED` / `CLOSED_QUALIFIED` / `BLOCKED_EXTERNAL_AUTHORITY` — final truthful terminal condition; `CLOSED_QUALIFIED` is not release acceptance.

A plan is not execution. Where the existing controller supports actions, pass the next task into that controller; where it does not, invoke a currently authorized execution path or produce a concrete handoff executable by the authorized existing controller. Do not fabricate execution or make the WP0c checkpoint module a hidden tool executor.

A plan must include `{action, owner, authorizing_contract, dependencies, exact_command_or_review_request, expected_artifacts, proof_condition, blocker, next_step}` and carry a stable task fingerprint derived from the **meaningful target surface** (not HEAD alone). Repeated identical decisions with no new evidence should produce a `NO_PROGRESS_BLOCKED` diagnosis and escalate to a named authorized owner, not generate unlimited iterations.

**If existing authority/architecture does not permit the closure workflow to be persisted or executed, do not implement it anyway.** Leave a precise minimal FIC proposal for the authorized reviewer, and continue with independently permitted test/analysis work.

## 4. Finish only the actual remaining verification

Use the evidence inventory to execute missing work, not all WP1–WP15 again:

- End-to-end synthetic local path through real available entrypoints: requester → typed request/catalogue → requester/executor policy → independent approval → gateway/runner → bounded connector/quarantine → atomic landing → audit/status → authenticated API/UI. Include browser-level behavior where unproven.
- Scheduled execution, updated permissions, stale catalogue/policy, cancellation/suspension, retry/recovery/retention, concurrent single-use approval, versioned activation/rollback when supported.
- Mandatory negative cases: cross-user/direct API abuse, CSRF/origin, prompt injection, unsafe archive, SSRF/redirect/rebinding, forbidden output, planted credential in logs/model/context, malicious content rejected from landing and tampered audit.
- WP14 decision comparisons: verify exact outstanding G4/G23/G24/G6 and any G5/G10/activation comparison not already proved. Record honest `DEFERRED` for an unavailable optional model/provider rather than requiring cloud access.
- Full G1–G32, S1–S43 and SI-01–SI-10 matrix, with evidence paths, actual commands/exit codes, test counts, digests, and honest `PASS | FAIL | UNRUN | BLOCKED | NOT_APPLICABLE` as appropriate. Organizational G29–G32 remain outside synthetic scope.

Security invariant failure must block release; it does not justify weakening a check. Reuse validated WP tests unless changed dependency/evidence demands a targeted rerun. Prefer a single stable final certification window with one evidence writer rather than repeated cross-agent digest cascades.

## 5. Explicitly separate engineering completion from approval/activation

After tests, construct the real admission decision from independent evidence:

- **ENGINEERING_VALIDATED**: all essential technical checks that were actually run pass; this does not equal authorized acceptance.
- **REVIEW_REQUIRED**: name the exact missing authorized decision, eligible reviewer, record schema and evidence packet; stop automation at the approval boundary.
- **ACCEPTED**: only if an actual recognized and valid governance approval record already exists or is returned through the existing legitimate review process.
- **ACTIVATED**: only if authorized release pointer actually binds a compatible governed-ingestion capability and rollback proof is valid.
- **PARTIAL/BLOCKED**: name the exact unresolved essential test, safety issue or authority; never use missing organizational production integrations as synthetic failures if excluded by mission scope.

Never create or edit `reports/governed_ingestion/MISSION_ACCEPTANCE.json` as a substitute for a real decision. If the legitimate review mechanism produces such an artifact, verify signer/authority, scope, digest, expiry, schema and source binding. The release store must be updated only by the existing authorized promotion mechanism. A test suite cannot mint acceptance.

## 6. Anti-deadlock and anti-churn tests (mandatory)

Add focused tests within a valid FIC for the **actual owner** of next-action/closure logic, or construct a bounded executable regression harness when a code change is unnecessary. Test the following cases:

1. All WP1–WP15 `VALIDATED_NOT_ACCEPTED` plus WP0c checkpointed: after a successful successor revalidation, the **closure controller** either advances to actual pending E2E/decision/review work or yields a precise authorized blocker; it does not repeatedly schedule the identical WP0c task with unchanged inputs.
2. Checkpoint drift after a relevant source edit: revalidation occurs exactly when needed and cannot be suppressed merely to show progress.
3. Unchanged source with independent green WP tests: do not regenerate unrelated evidence only because another unrelated commit changes HEAD (subject to original mandatory binding semantics).
4. Missing valid FIC, absent reviewer decision, invalid release pointer, unresolved security failure: each fails closed and cannot become `ACCEPTED` or `ACTIVATED`.
5. Real approved acceptance plus verified compatibility: existing authorized route can record the approved decision and activate or yield an explicit supported/manual step without manufacturing authority.
6. Simulated interruption/concurrent workers: task fingerprints and ownership avoid duplicate execution, double approval use and two evidence writers.
7. A `--handoff`/resume-only call remains side-effect-free and never masquerades as having completed a task.
8. No-progress repeat handling is finite and diagnostic, not an unbounded retry loop; prove a blocked terminal state preserves remaining actionable details.

Do not weaken old WP0c evidence certifier assertions to make the new plan green. If a higher-level closure coordinator is needed, reuse an **existing** authorized coordination seam. Tests must show the checkpoint and the actor responsible for execution remain distinct.

## 7. Success conditions and deliverables

The mission succeeds as a **deadlock-resolution** task if and only if:

- A source/test-backed explanation shows the actual stalled boundary and distinguishes intentional checkpoint behavior from a controller defect.
- Each final closure obligation is classified: already satisfied, runnable now, requires FIC, requires human approval, optional/deferred, or genuinely blocked.
- The normal authorized workflow makes real forward progress (e.g. missing end-to-end proof is executed, or a review-ready approval packet is produced and the controller stops at the human gate), rather than cycling through unchanged checkpoint regeneration.
- Anti-loop and non-bypass tests pass under the guarded workload. No new kernel/manager, no unauthorized acceptance/activation, no diminished security.
- Reports identify what engineering work is proven, what independent E2E/security results are not yet proven, and whether activation is `NONE` or an actual bound version.

**Deliver** the minimal authorized code/test changes if required; an exact evidence-backed root cause; a structured closure queue; an acceptance-ready review packet if a human gate remains; and a durable handoff with one actionable next step. Do not mark the whole ingestion mission accepted unless every actual acceptance authority and required proof is present.

## 8. Required final report

```text
MISSION: GOVERNED_INGESTION_CLOSURE_DEADLOCK_RESOLUTION_v1
HEAD BEFORE / AFTER: <actual SHAs>
ACTIVE DRIVER: <confirmed|not_confirmed>
ACTUAL ROOT CAUSE: <file:function, tested causal observation>
WP0c SEMANTICS: <intentional checkpoint behavior versus proved scheduling bug>
EXECUTION OWNER: <existing manager/controller/module or authorized external reviewer>
NEW NEXT-ACTION LOGIC: <actual implemented change, or explicit no-change rationale>
CLOSURE QUEUE: <runnable and blocked items with exact ownership>
E2E AND SECURITY PROOFS: <commands, results, artifact digests>
REGRESSION / ANTI-LOOP TESTS: <collected, passed, failed, unrun>
FIC / REVIEW AUTHORITY: <actual IDs, missing decision/eligible approver>
ACCEPTANCE: <recognized decision|NONE>
ACTIVATION: <bound release/version|NONE>
CURRENT BLOCKERS: <precise, not a generic "pending closure">
NEXT RUNNABLE ACTION: <one executable bounded task, or named review request>
```

**Begin with evidence-based diagnosis. Then actually fix or advance the smallest authorized blocked boundary. Never claim a fabricated acceptance to reach 100%.**
