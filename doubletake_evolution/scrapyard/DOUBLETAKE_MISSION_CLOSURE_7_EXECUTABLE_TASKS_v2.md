# DOUBLETAKE — GOVERNED INGESTION CLOSURE DEADLOCK
## Seven independently executable tasks with strict definitions of done (v2)

**Usage:** Execute **Task 1 only** first. After its acceptance criteria are met, execute Task 2, and so on. These are *bounded execution prompts*, not seven simultaneous controllers. A worker may hand off a task to a peer, but only one writer owns each changed file. If a task is already completed by a newer commit, verify its exact DoD against current source and record `REUSED_VERIFIED`; do not redo it. Stop with an honest `BLOCKED` result when necessary approval is missing; proceed with independent authorized tasks only.

**Grounding checked:** `olejardamir/DT` `main` through `b551816f33d2` (2026-10-27 19:44:23 UTC). `reports/governed_ingestion/MISSION_STATE.json` at bound source `c3765d1698` says `WP1–WP15=VALIDATED_NOT_ACCEPTED`, `WP0c=CHECKPOINTED`, `WP0=IN_PROGRESS`, `next_runnable_action=REVALIDATE_CHECKPOINT(WP0c)`, no accepted/activated release. Actual `tools/doubletake_evolve/governed_ingestion/mission_state.py` documents that `resume()` **returns a plan but executes and accepts nothing** and that the existing campaign manager lacks mission registration. These are facts, not permission to replace governance. Verify current checkout and newer work before acting.

**Always obey:** `AGENTS.md` main-only/no-tags policy; bounded detached worktrees only where authorized; peers' local changes; L0 independence, L1 promotion and FIC authority, L2 spec-only; no new kernel/second manager; only synthetic local data/mock provider; no external real systems, model downloads or secrets. Run proof/test workloads via `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` with proper `PYTHONPATH`, max one guarded experiment at a time, no bypass of CPU/RAM/deadline. A test that does not collect meaningful assertions is not proof. `VALIDATED` is not `ACCEPTED`; human approval cannot be forged. Preserve existing valid WP1–WP15 code and evidence.

---

# TASK 1 — Diagnose the closure loop, with a falsifiable root cause

**Objective:** Establish exactly where the handoff stops and which missing capability causes it. **No runtime refactoring yet.**

**Inspect:** `tools/doubletake_evolve/governed_ingestion/mission_state.py` (`_next_action`, `resume`, `build`, `defects`), `reports/governed_ingestion/MISSION_STATE.json`, `tools/doubletake_evolve/mission_management/{models.py,store.py}` and actual mission dispatch/runner, `L1/fic/units/`, acceptance/release mechanisms; `tools/doubletake_evolve/governed_ingestion/tests/test_mission_state.py`.

**Actions:**
1. Capture source HEAD, whether it matches remote `main`, working-tree condition, active controller/worker ownership and current `--handoff` output. Use a read-only isolated copy if the shared tree is dirty.
2. Trace the actual execution path from a user-selected prompt through controller/mission manager into `resume` and the next dispatched action. Separate **handoff plan creation**, **task dispatch**, **checkpoint verification**, **acceptance authority**, **release activation**; pinpoint the exact missing transition(s).
3. Count repeated `REVALIDATE_CHECKPOINT(WP0c)` actions with identical source+evidence digests if logs exist. If logs do not exist, demonstrate with a deterministic test harness; do not invent observed repetition counts.
4. Inspect whether `mission_management` can own this mission or whether the governed-ingestion fallback is intentionally isolated. Write a decision: extend existing manager via a minimal authorized adapter, or keep fallback and add a narrow, authorized closure dispatcher. State why the alternative is not selected.
5. Classify remaining blockers **ENGINEERING**, **EVIDENCE**, **AUTHORIZATION**, **EXTERNAL_OUT_OF_SCOPE**; map each to its actual owner and runnable next action.

**Deliverable:** `reports/governed_ingestion/closure/01_root_cause.md` (or currently approved reporting location) with precise code paths, observed vs inferred claims, reproduction commands and task ownership. Do not commit into unapproved locations; use existing approved report area or seek the requisite FIC.

**Definition of done — ALL required:**
- [ ] The exact first nonexecuting handoff point is identified with filename/function and controlled reproduction.
- [ ] An execution-flow diagram or ordered trace distinguishes checkpoint verification from actual mission work and authorized acceptance.
- [ ] Every non-completed condition has a specific owner, action, and authority boundary; no generic “continue evolving” instruction.
- [ ] A newly added focused regression test **fails under the existing defective behavior** or a pre-fix reproduction is committed with output; if no defect is confirmed, document evidence refuting it and move to the genuine blocker.
- [ ] `MISSION_STATE.json` has not been altered solely to make this task appear successful.

**Failure/stop:** If the only true blocker is an external authorization, mark `BLOCKED_AUTHORIZATION` and do not design an automatic acceptance bypass. **Next:** Task 2.

---

# TASK 2 — Repair dispatch and checkpoint liveness, not the checkpoint's integrity rules

**Objective:** Stop unchanged WP0c revalidation from monopolizing the mission and make the existing owner dispatch the next legitimate task.

**Permitted scope (subject to FIC):** existing `mission_management` dispatcher/controller and/or narrow `governed_ingestion` adapter + focused tests. Reuse `mission_state.py` as the *integrity oracle*. Do not weaken `--verify` and do not reinterpret CHECKPOINTED as ACCEPTED.

**Actions:**
1. Obtain a valid FIC for actual runtime source/tests. The pre-existing plan FIC that allows only evidence reports is insufficient. Confirm authority before protected edits.
2. Introduce a deterministic closure state/action selection that distinguishes `REVALIDATE_CHECKPOINT`, `EXECUTE_PENDING_CLOSURE_TASK`, `REQUEST_APPROVAL`, `ACCEPTANCE_READY`, `BLOCKED`, and `DONE` (names may follow existing vocabulary). Do not create a new global orchestration framework.
3. On **successful** WP0c verification against the same measured binding, record an idempotent revalidation receipt bound to content/digest and let the dispatcher choose the next real closure task. A new relevant code/evidence change must invalidate the receipt and trigger genuine revalidation again. Never allow unverified checkpoint continuation.
4. Persist task ID, owner, inputs, precondition hashes, attempts, resulting artifacts, and terminal status using the existing durable mission or campaign storage. On restart, resume the same task without double effects or skipped permission checks.
5. A read-only `--handoff` remains a pure plan; executable routing occurs only in the authorized dispatcher, **not** as a side effect of `resume()` or `--verify`.

**Definition of done — ALL required:**
- [ ] A regression test shows the old behavior (unchanged WP0c repeatedly selected) and proves it is now rejected/skipped **only after successful verification**.
- [ ] Repeated calls at identical verified source return the same next closure action, with **no duplicate execution/approval**.
- [ ] Changed bound digest, corrupt checkpoint, missing evidence, failed verifier, absent FIC, or concurrent writer **cannot** skip validation; negative cases all pass.
- [ ] The next dispatched task is a named, executable closure task (Task 3 or 4 etc.), or an explicit `BLOCKED_AUTHORIZATION`/`BLOCKED_EVIDENCE` with exact missing prerequisite — **not** WP0c forever.
- [ ] Existing mission-state certifier and neighboring mission-manager suites pass without changing accepted semantics.
- [ ] The new dispatcher is wired into the entrypoint actually used by the user/agent; an isolated helper with green unit tests does not count.

**Failure/stop:** A missing code-change FIC blocks implementation; output exact required approval without creating fake credentials/signatures. **Next:** Task 3.

---

# TASK 3 — Durable closure task queue and anti-stall guards

**Objective:** Convert remaining work into finite, automatically resumable tasks using *existing* manager infrastructure.

**Actions:**
1. Populate only unresolved tasks: UI/browser and API connected flows; end-to-end ingestion and adversarial probes; WP14 deferred comparisons only if mission-mandatory; evidence mapping; acceptance eligibility; promotion/activation. Assign explicit ownership and dependency relationships. If another worker already proved an item, cite its artifact and remove it from the queue.
2. Compute a stable fingerprint from task ID + relevant source/evidence inputs. Distinguish `NO_CHANGE_ALREADY_VERIFIED`, `EXECUTED_WITH_NEW_EVIDENCE`, `BLOCKED`, `FAILED`, `WAITING_EXTERNAL_AUTHORIZATION`.
3. Detect repeated same-fingerprint no-progress loops. After **two** unsuccessful identical attempts, record a diagnostic and switch to the **root-cause investigation** or a different independent task; do not repeatedly regenerate unchanged evidence. This is a scheduling rule, **not** a statistical or evidence-quality threshold.
4. Add restart/concurrency/idempotency tests: same task cannot be claimed by two workers; interrupted task resumes; an accepted validated artifact is reused; changing the input invalidates only affected tasks.

**Definition of done — ALL required:**
- [ ] One canonical queue exists and is surfaced by actual mission handoff, with task IDs, precise inputs, owner, dependencies, status and next command.
- [ ] Every nonterminal task has at least one measurable completion predicate, one verifiable output path, and one declared permission boundary.
- [ ] Consecutive identical no-progress attempts no longer produce an infinite sequence of evidence-only commits or silently succeed.
- [ ] Tests demonstrate restart, same-task double claim refusal, unchanged artifact reuse, input invalidation and independent-task continuation under a genuine blocker.
- [ ] The queue does not schedule rebuilding WP1–WP15 validated implementations.

**Next:** Task 4.

---

# TASK 4 — Execute a true integrated synthetic ingress smoke and security test

**Objective:** Prove the existing subsystem actually works across boundaries; do not mistake independent WP tests for E2E.

**Required positive journey:** `authenticated requester → catalogue + schema → effective policy → different-authority approval bound to canonical digest → gateway/runner → synthetic allowlisted source → quarantine/inspection → atomic landing → audit chain/status → filtered HTTP API → current React UI`.

**Required negative/recovery subsets:** at least direct API bypass, wrong-user request/audit read, self-approval, forged identity, CSRF/Origin, expired/revoked approval, source redirect/SSRF, unsafe archive, secret planted in output/log, recurring job after rights change, concurrent approval claim, crash before atomic publication. Remaining S1–S43/SI-01–SI-10 must be inventoried: pre-existing integrated proofs reused; missing mandatory tests are scheduled rather than fabricated.

**Actions:** Inspect existing entrypoints and tests first; write one executable driver/harness that uses **actual integrated boundaries** (mock provider and loopback synthetic fixtures allowed). Keep host guard constraints. If missing bridge logic exists, implement only that seam under its own valid FIC and tests. Do not invoke real services or alter L0.

**Definition of done — ALL required:**
- [ ] At least one success flow goes through the real API/controller and reaches a verified landed manifest with correct digest, audit record and filtered status; UI/browser smoke independently demonstrates its user view (if UI driver unavailable, record explicitly `UNRUN` and keep this task incomplete).
- [ ] Negative integration cases above are executable and show **denial before unauthorized side effect**, not merely expected error text from a mock.
- [ ] Crash and concurrent-claim tests show no partial or duplicate authorized landing.
- [ ] Test artifacts have command, source SHA, test count/pass/fail, timestamps, hashes and bounded actual outcomes; a model-generated “PASS” is insufficient.
- [ ] No new network/service/cloud dependency, secret exposure or L0 changes; unchanged focused suites remain valid.

**Failure/stop:** If a single required integration bridge is absent, produce a bounded missing-seam coding task with owner/FIC; do not switch to another broad design document. **Next:** Task 5.

---

# TASK 5 — Resolve evidence/decision gaps and validate global coverage honestly

**Objective:** Consolidate existing WP evidence and the Task 4 integrated test into a traceable, correctly scoped mission verdict without duplicating completed packages.

**Inspect:** `reports/governed_ingestion/evidence/wp1.json` … `wp15.json`, `wp13_native_launch.json`, `docs/governed_agent/{threat_model,risk_register,evidence_register}.md`, `reports/governed_ingestion/DECISION_RECORDS.md`, source v3 scenario and invariant requirements.

**Actions:**
1. Map G1–G32, S1–S43 and SI-01–SI-10 by **actual** source→owner→test→result→digest. Distinguish isolated tests from actual integrated security tests. Preserve `DEFERRED`, `NOT_APPLICABLE` and organizational boundaries rather than transforming them into PASS.
2. Check the WP14 report's declared unresolved **G4/G23/G24/G6** alternatives against current commits. Conduct any genuinely required remaining local comparisons with identical fixtures, actual metrics and honest limitations. Optional unapproved real-provider evaluation remains DEFERRED.
3. Check current FIC scope for WP12/WP13/WP15 **implementation vs evidence-only**; register any authorization gap separately from technical completion.
4. Verify evidence freshness for the measured source, semantic match, collectability and nonzero assertions; do not rebind every package merely because unrelated main commits occurred.
5. Produce an explicit **closure matrix** and unresolved items list, each with permitted next action/owner, or `EXTERNAL_OUT_OF_SCOPE`/`REQUIRES_HUMAN_APPROVAL`.

**Definition of done — ALL required:**
- [ ] Every G/S/SI ID has an explicit evidence-backed status, no missing rows, invented success or stale digest claim.
- [ ] Every integrated security invariant has an independently re-runnable assertion; every unresolved condition is labeled as a blocker, deferred choice or external-only requirement.
- [ ] WP14 decision gaps are measured or explicitly documented as legitimately deferred under the original scope; conditional recommendations reference observed data only.
- [ ] A single machine-readable and human-readable closure matrix exists under an authorized location; independent tests detect tampering, missing evidence and false PASS.
- [ ] There is a definite `READY_FOR_ACCEPTANCE` versus `BLOCKED_BY_[...]` decision, with exact reasons. No obligation is erased merely to obtain green.

**Next:** Task 6.

---

# TASK 6 — Authorized mission acceptance decision (not an agent self-approval)

**Objective:** Connect `VALIDATED_NOT_ACCEPTED` to a real, existing acceptance authority while preserving separation of duties.

**Actions:**
1. Inspect *actual* L1 acceptance/promotion policies, signers/roles, schema and the expected `reports/governed_ingestion/MISSION_ACCEPTANCE.json` structure. Determine whether project policy permits automatic acceptance after objective checks or requires an explicit external human decision. Do not infer a signer from an FIC draft.
2. Build an evidence-backed **acceptance request** listing Task 5 matrix, failed/unrun risks, exact source/head, bounded limitations, activation implications and authority required. Submit through an existing approved route; do not create a fake approver or synthetic permission.
3. If an independently authorized acceptance decision is actually available, verify it, record in the mandated format and make the checkpoint derive `ACCEPTED` only for properly authorized scope. If not, represent `AWAITING_AUTHORIZED_ACCEPTANCE` with the concrete action for the human authority and **stop** the acceptance branch; continue other allowed work.
4. Add negative tests: forged signer, duplicate/expired authorization, scope mismatch, changed source/evidence since approval and self-approval cannot yield `ACCEPTED`.

**Definition of done — ALL required:**
- [ ] Exact approval authority and acceptance schema are documented with actual source/validator reference.
- [ ] A valid acceptance request with bound test evidence exists; its status can be queried and safely resumed after restart.
- [ ] Either a genuine independently authorized acceptance record passes validation **or** a precise waiting-on-human/blocker state persists without claiming acceptance.
- [ ] Missing approval never causes a WP0c revalidation loop, fake approval, or reimplementation of completed WPs.
- [ ] Forgery/replay/source-change/authority negative tests and existing governance suites pass.

**Next:** Task 7 only if the applicable authorization permits it.

---

# TASK 7 — Controlled activation or final qualified handoff

**Objective:** End the mission in one of two truthful terminal states: safely activated and accepted; or technically validated with precise pending human authorization/unproven requirements. Never claim a production deployment.

**Actions:**
1. Inspect existing DT component release/activation mechanism; do not invent a new manager or release store. Verify candidate artifact contract, L0 independence, dependency compatibility, in-flight pin/drain behavior, rollback and safety checks.
2. For an **actually authorized** release, perform controlled local synthetic activation, verify pointers/versions using the real release store, execute smoke and rollback, and retain evidence.
3. Without that authority, do **not** activate. Return `VALIDATED_AWAITING_AUTHORIZATION` / `PARTIAL` with exact acceptance and activation prerequisites, owner and resumable handoff; do not keep running indefinitely.
4. Re-run only impacted evidence and required safety tests at a stable source checkpoint. Confirm no new regressions and no competing worker changes to bound surfaces.

**Definition of done — ALL required:**
- [ ] A terminal closure report records the exact release state and includes validated source/evidence digests, applicable G/S/SI coverage and outstanding limitations.
- [ ] If activated: verified authority, correct release pointer, healthy local smoke, deliberate rollback test and independent record confirm success.
- [ ] If not activated: explicit durable terminal `AWAITING_AUTHORIZATION` / `BLOCKED_EVIDENCE` with a **single actionable next owner/action**; no false 100% and no silent infinite retries.
- [ ] The closure dispatcher reloading this terminal state neither restarts WP1–WP15 nor repeats WP0c indefinitely; tests cover restart/no-op, changed source, and later receipt of genuine authorization.
- [ ] All final reports distinguish **engineering validation**, **mission acceptance**, **local activation**, and **external production deployment**.

---

## Required response after EACH bounded task

```text
MISSION: DOUBLETAKE_GOVERNED_INGESTION_CLOSURE
TASK: <1..7> / <short title>
STATUS: VERIFIED_DONE | REUSED_VERIFIED | BLOCKED_AUTHORIZATION | BLOCKED_EVIDENCE | FAILED
SOURCE_HEAD_BEFORE / AFTER: <actual shas>
AUTHORIZATION/FIC: <id, scope and validity or missing>
CHANGED_FILES: <paths or NONE>
BEHAVIOR_PROVEN: <actual effect, not a verbal claim>
TESTS: <guarded commands, exit codes, collected/pass/fail>
ARTIFACTS: <paths and content hashes>
ACCEPTANCE: <actual authority/record or NONE>
ACTIVATION: <actual release pointer/version or NONE>
PRECISE_BLOCKER: <if applicable>
NEXT_TASK: <number or 'waiting on authorized external actor'>
```

**Do not execute Task N+1 if Task N has an unresolved dependency that affects N+1.** You may proceed on unaffected independent tasks under valid authorization. A completed-task report must be backed by persisted committed code/evidence, independently re-runnable tests and an actual transition in the live workflow—not just a Markdown statement of completion. Run Task 1 now.
