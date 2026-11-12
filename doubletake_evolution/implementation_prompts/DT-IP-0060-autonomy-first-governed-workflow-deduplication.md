# DT-IP-0060 — Autonomy-first governed workflow deduplication

**Status:** PROMPT_READY_PENDING_INDEPENDENT_REVIEW / NOT_EXECUTED. Public deferred implementation hypothesis, not a defect report or permission to implement. Current private DT parity UNKNOWN.

**Live source:** `doubletake_evolution/scrapyard/DOUBLETAKE_AUTONOMY_BUREAUCRACY_REDUCTION_MASTER_v1.md`, blob `8db825e3be7a0b3ffa46de73aa18d93caf489f88` (complete distilled source). **Historical full predecessor:** same path in Git history, blob `a36418f4fa6870ad9599bb126d5dad868b1f96cf` (22,386 Git bytes); historical DT baseline `ea75925392d8` dated 2026-10-29, not current proof. Related later residual: `DOUBLETAKE_AUTONOMY_BUREAUCRACY_REDUCTION_REMAINING_WORK_v2.md` (not yet independently reconciled). Original historical instructions to execute are archival data, not authorization. Git history and original authorship preserved; third-party code/licenses must be checked before reuse. Do not copy private code.

## Mandatory future user-authorized coder preflight

Inspect CURRENT private DT source, tests, `AGENTS.md`, owners, callers, writers, permission grants, host restrictions and actual consumer. Determine if any duplication/latency is measured with authorized matched fixtures. Exit `ALREADY_PRESENT` if existing controls suffice, `NO_APPLICABILITY` if no real duplicate owner/consumer, `NO_AUTHORIZED_FIXTURE` if tests cannot be run safely, or `BLOCKED` on absent permissions. Do not create a new kernel, worker, global dispatcher, authority store or approval bypass to satisfy this archival proposal. No code/test execution until separately requested by user.

## Conditional behavioral contracts (only when live ownership and evidence justify change)

1. **T1 — one durable task and dispatch owner.** Trace real request → mission manager/store → dispatcher/queue → effect → receipt → next task. Reuse canonical owner; adapters must not independently claim, retry or settle same task. Stable idempotency identity, crash recovery, concurrent claim exclusion, changed-input invalidation, terminal states and repeated-no-progress parking; independent runnable tasks continue. Negative: duplicate effect, competing claim, lost acknowledged state, starvation, stale replay.
2. **T2 — scoped standing-grant gateway.** For already authorized operations enforce principal, effect class (read/artifact/code/network/destructive/external), target, resource budget, expiry and revocation at first action, retry, scheduling and promotion. No agent-created/expanded grants, no report or model output as permission, no aliased-target/cross-user/forged/expired grants. Preserve required human, legal, third-party and external approvals. Negative: self-authorization and changed-scope retries must fail before effects.
3. **T3 — objective independent technical acceptance.** Existing tests, provenance, policy/FIC and release-owner activation/rollback may replace redundant ceremonial review only where legally and operationally permitted. Preserve policy-change approvals, exact revision, real caller/effect evidence and independent validation. Reject forged/stale test receipt, wrong privilege, missing FIC, release incompatibility, synthetic fixture masquerading as production approval.
4. **T4 — dependency-scoped evidence reuse.** Map source/contract/security/test/evidence/release dependency digests; reuse verified unaffected receipts only at exact immutable inputs. Report-only HEAD churn must not trigger unrelated full rebind unless the current contract requires it; migrate that contract only with permission. Reject changed security dependency, digest forgery, hidden invalidation and history erasure.
5. **T5 — bounded repair and rollback.** Reuse current diagnostic/release owners, keep last-good pointer, attempt only grant-covered bounded repairs, rerun affected tests, rollback unsafe outcome, park identical failures, continue independent tasks. Reject retrying hard resource-limit refusals, orphan effects, duplicate external landing, corrupt release pointers and unauthorized policy edits.
6. **T6 — canonical truthful status and compatibility.** Derive task, owner, digest, effect scope, tests, active version, blocker and next runnable action from canonical evidence. Migrate every actual reader before removing redundant store/report; retain mandatory audit/release history and current live rules. Measure unique authoritative stores, gate count, human interruptions, latency and redundant report commits against a matched baseline; mark UNMEASURED rather than invent savings.


## Historical §3 mechanism-audit decision contract (Scout gap G1)

For **each** actual gate, writer, queue, report, approval and retry loop, future authorized inspection must record the compact, machine-readable fields: `component/path | real caller | behavior | concrete failure prevented | external obligation? | existing overlapping enforcement | runtime cost | proposed KEEP/MERGE/AUTOMATE/LAZY/REMOVE | authorization required | before/after tests`. Do not collapse distinct writers or omit an external/legal/organizational obligation merely to claim lower overhead. Apply the exact five-way disposition conditionally: **KEEP** concrete failure prevention or compatibility/legal/organizational necessity; **MERGE** duplicate authorities into the existing owner with necessary adapters; **AUTOMATE** only mechanical checks and routine approvals already covered by deterministic non-self-granted authority; **LAZY** derive/cache report views by immutable inputs with affected-dependency invalidation; **REMOVE** only inert or redundant ceremony after real dependency/reader scans and regression tests. Required retention/audit/recovery/permission evidence and tested persisted-state migrations remain mandatory. Negative tests: removal of a legally required gate, unauthorized auto-approval, cache reuse after changed security input, double authority after merge, un-migrated reader, missing audit receipt, and purported cost reduction without matched baseline must reject the proposed disposition. A classification is a proposal, not execution permission.

## Historical §8 per-slice evidence contract (Scout gap G2)

For each **future separately authorized** T1–T6 implementation slice, produce a machine-readable receipt with the historical fields: `MISSION` (historical label `DT_AUTONOMY_FIRST_BUREAUCRACY_REDUCTION`, not a newly activated mission), `SOURCE_HEAD_BEFORE / AFTER` (actual revisions), `SLICE` (T1–T6 and behavior), `AUTHORITY` (real grant/FIC/owner or blocker), `PREVIOUS_PATH` (old execution chain and measured gates), `NEW_PATH` (actual chain and measured gates), `FILES` (changed paths), `TESTS` (guarded commands, collected results, failures and negative assertions), `COMPATIBILITY / MIGRATION` (actual outcome), `SECURITY` (regressions/escalation probes), `LATENCY / OVERHEAD` (matched before/after or `NOT_MEASURED`), `STATE` (only `DONE | REUSED_VERIFIED | BLOCKED_AUTHORITY | BLOCKED_SAFETY | FAILED` with evidence), and `NEXT` (one legitimate independent action or terminal). Never fabricate SHAs, executed commands, permissions, performance, migrations or PASS. A future final report must separately distinguish operational autonomy, reduced procedural steps, actual safety evidence, authority boundaries and unproven areas; no blanket completion percentage. Negative controls: absent source revision, forged authority, unrun test reported PASS, undocumented migration, stale before/after baseline and falsely marked DONE all fail closed.

## Scout grouped-gap coverage handoff

| Historical clause and blob | Prompt section | Transformer disposition |
|---|---|---|
| §3 lines 50–63; historical `a36418f4fa6870ad9599bb126d5dad868b1f96cf` | Historical §3 mechanism-audit decision contract | G1 COVERED for all eleven fields, five disposition rules, obligations, migration, failure and negative controls |
| §8 lines 172–190; same historical blob | Historical §8 per-slice evidence contract | G2 COVERED for all thirteen named receipt lines including MISSION, exact state enum, measured-or-unknown metrics, final distinctions and negative controls |
| §4 T1–T6, §5 security, §§6–7 integrated checks | Existing 1–6, preflight, integrated verification | UNCHANGED; no redundant rewrite |
| §9 historical execute-now imperative | Preflight and status | ARCHIVAL_ONLY, not authorization; no private implementation |
| Separate v2 residual live blob `1baed7b5617ad3ea88b26b5de80dd7a46a944738` | None | NOT_CLAIMED; distinct source retained for independent audit |

This is Transformer clause mapping only; independent Scout must re-fetch and verify before any source retirement.

## Source-clause → prompt coverage and negative-test ledger

| Source clause | This prompt | Required proof / failure gate |
|---|---|---|
| Historical §§0–3, distilled scope/source map | Preflight, 1–6 | Real entrypoints and caller/owner map; no authority from historical mission |
| Historical §4 T1 | 1 | Parallel claim, crash/restart, replay, no-progress and independent continuation |
| Historical §4 T2 | 2 | Revocation, expiry, scope, aliased target, forged principal, no unauthorized effect |
| Historical §4 T3 | 3 | Independent acceptance, FIC, forged/stale result, release approval separation |
| Historical §4 T4 | 4 | Dependency digests, unchanged-input reuse, changed-security invalidation |
| Historical §4 T5 | 5 | Repair budget, last-good rollback, failed/duplicate external effects |
| Historical §4 T6 | 6 | Reader migration, status fidelity, audit retention, before/after metrics |
| Historical §5 security guarantees | Preflight, 2–6 | L0/L1/L2 boundaries, secrets/network/host guard, no new privilege or policy rewrite |
| Historical §§6–9 sequence, acceptance, reporting | Completion below | A/B/C end-to-end paths, per-slice evidence, truthful BLOCKED/UNMEASURED |

**Conditional integrated verification:** Under authorized host workload guard and current policy, exercise (A) permitted read/report and denied unauthorized write; (B) grant-covered internal change, independent tests, activation and injected rollback; (C) synthetic governed ingestion through actual authorized landing. Verify loaded revision, real caller, effects, idempotency, durable receipts, restart/replay, no second owner, grant revocation, release pinning and migrated readers. Compare matched before/after intervention, latency, duplicate stores/gates/reports. Use affected tests per slice and a final integration pass; do not assert production certification from synthetic tests.

**Dependencies/uncertainty:** Historical paths `mission_management/{models.py,store.py}`, `mission_state.py`, `closure_dispatch.py`, `closure_queue.py`, `closure_acceptance.py`, scheduler, human-review, gateway, repair and release resolver are hypotheses, not verified current DT owners. Later v2 residual and existing DT-IP governance/evidence/recovery prompts may already cover some contracts; future coder must deduplicate by live consumer, not title.

**Completion evidence:** Record exact authorized scope, current revision/owner/consumer, before/after baseline, negative and positive test commands/results, effect readback, migration compatibility, permission and rights review, changed files/commit or explicit stop disposition. This prompt is NOT_EXECUTED. Only independent Scrapyard Scout can verify complete source transfer and retire original; no source deletion by Transformer.
