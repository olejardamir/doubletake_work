# DOUBLETAKE — AUTONOMY-FIRST, ZERO-REDUNDANT-BUREAUCRACY REFACTOR
## Single executable master mission · source-driven · incremental · verifiable

**Repository:** `https://github.com/olejardamir/DT`  
**Baseline observed during prompt preparation:** `main` contains `ea75925392d8` (October 29, 2026); treat this as a **historical reference**, not a pin. Read current HEAD and working tree before acting.  
**Scope:** Entire DoubleTake stack, **not only Governed Ingestion**.  
**Desired operating mode:** Unattended, autonomous work within enforceable standing permissions, with minimal procedural latency and no redundant approval/document/certification loops.  
**Authority hierarchy:** Current `AGENTS.md`, current security boundaries, existing operator-granted scope, and applicable law/credentials remain authoritative. This mission text does **not** itself grant new privileges or override protected controls.

## 0. Execute, do not produce another planning-only mission

You are the DT coding/evolution worker. Audit the *actual* current code and real entrypoints, then implement tested changes in small, reversible increments. Do not merely write proposals, create another manager, or rename bureaucracy. You are not authorized to erase safeguards for the appearance of autonomy. Do not pause for an approval ceremony when an operation is already authorized under a valid standing grant. If a necessary permission is absent, record precisely that missing grant and continue independent permitted work; never synthesize an operator signature or expand your own authority.

Use this prompt as one active controller mission. Preserve completed missions, verified capabilities, public contracts where required, and the minimal L0 kernel. Respect `main`-only/no-tags, shared writer ownership, and the workload guard described in `AGENTS.md`. All mission experiments/tests/builds must run through `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` under current host limits. Do not invoke real external integrations, install cloud dependencies, download models, or touch actual confidential data merely to perform this cleanup.

## 1. What success looks like

For a fully permitted operation, the critical path becomes:

`intent -> smallest durable task -> one deterministic permission/risk check -> execute -> affected tests and outcome verification -> atomic activate/rollback if applicable -> compact durable result -> next task`

No discretionary human review or separate procedural committee is inserted into that *already-authorized* path. Human review remains a possible optional adapter for workflows/third-party systems that explicitly require it, not the universal scheduler gate.

**Never confuse human-out-of-the-loop with authority-free.** An automated system cannot mint permissions it was not given. A standing permission may authorize many future tasks automatically, but must be scope-, effect-, resource-, destination- and expiry-aware. An agent may propose a change to its own governing policy, but it may not silently approve that policy change or turn off enforcement. Safety-critical denials fail closed; unrelated work continues.

Success must measurably **reduce unique decision gates, duplicated stores, required operator interventions, report regeneration, and time-to-execute** without reducing covered safety invariants or increasing unauthorized side effects. No artificial numeric improvement is required; compare measured before/after figures using identical task fixtures.

## 2. Grounding: inspect actual ownership before changing anything

Read and map, at minimum:

- `AGENTS.md`; L0 public entrypoint and independence tests; L1 policies/FIC/validator, review and promotion contracts; L2 spec-only boundaries.
- `tools/doubletake_evolve/mission_management/{models.py,store.py}` and real runner/controller/queue dispatch routes, durable event state, restart and concurrency behavior.
- `tools/doubletake_evolve/governed_ingestion/{mission_state.py,closure_dispatch.py,closure_queue.py,closure_acceptance.py}` and `reports/governed_ingestion/{MISSION_STATE.json,MISSION_ACCEPTANCE.json}` plus `reports/governed_ingestion/closure/*`.
- `tools/doubletake_evolve/human_review/` including lookup, queue, approval history, role enforcement, expirations, revocations, and actual decision-writing interface if currently present.
- `tools/doubletake_evolve/promotion/`, release resolver, component version activation, rollback, in-flight pinning, and recovery.
- Tool gateways and capability/permission registries, evolution/research dispatch, auto-repair, audit/evidence, host workload guard, UI/API routes and scheduler paths.
- Tests and records for current active missions including Governed Ingestion; avoid marking an accepted or active unit based solely on a report's status string.

For every procedure, trace **requesting entrypoint -> state/policy check -> decision function -> side effect -> evidence write -> next dispatch**. Identify all readers/writers of each record. Do not delete anything based on names alone. Search call sites and versioned schema consumers, confirm which mechanisms actually run, and identify dead, duplicate and safety-critical logic. Distinguish implementation from documentation. First collect baseline commands, outcomes and latency/number of stages on the same synthetic fixtures later used for the comparison.

**Current known examples (verify at current HEAD):**
1. `mission_management.models.CampaignSpec` already models effect classes and required human approvals; evaluate making standing delegated grants the routine execution path while preserving checks for absent authority.
2. Governed ingestion has a separate `closure_dispatch.py`, `closure_queue.py` backed by `CampaignStore`, `mission_state.py` and `closure_acceptance.py`. Inspect duplication and integrate common scheduling/state logic into the existing owner without making mission semantics generic when they are not.
3. `closure_acceptance.py` currently consumes an independent human-review decision for mission acceptance. Separate synthetic research demonstration acceptance from external/legal/organizational approval; permit automatic technical acceptance **only where already delegated policy explicitly permits it**. Do not rewrite prior evidence to imply such a delegation existed.
4. Several governed-ingestion evidence records bind source heads and induce cascading rebind commits. Preserve meaningful content/provenance verification but avoid invalidating unrelated evidence simply because a report-only commit advanced HEAD.
5. `L1/docs/11_L1_REVIEW_GATE.md` currently describes completion record + review packet for implementation acceptance. Determine which part is essential for independent verification and which adds no security beyond executable tests, source provenance and existing standing authorization.
6. `AGENTS.md` mandates guarded experiments and protects VPN push hooks. Do not classify these resource and security protections as bureaucracy merely because they add a check.

## 3. Canonical classification of each mechanism

Create one compact, machine-readable audit inventory, no sprawling parallel planning paperwork. For each gate, writer, queue, report, approval and retry loop record:

`component/path | real caller | behavior | concrete failure prevented | external obligation? | existing overlapping enforcement | runtime cost | proposed KEEP / MERGE / AUTOMATE / LAZY / REMOVE | authorization required | before/after tests`.

Rules:
- **KEEP** only if it prevents a concrete failure or is required for compatibility/legal/organizational boundaries.
- **MERGE** duplicate stores, dispatchers, status authorities and repetitive policies into an existing authoritative owner, preserving adapters where necessary.
- **AUTOMATE** mechanical checks and routine permitted approvals with deterministic, testable, non-self-authorizing rules.
- **LAZY** derive reports/views on demand rather than regenerate after every minor commit; cache by exact inputs and invalidate affected dependencies only.
- **REMOVE** unused ceremonies, inert scaffolds, stale docs, duplicate acceptance wrappers and loops with no independent safety value, after dependency scans and regression tests.

Do not remove retention/audit evidence that is required to recover, reproduce, investigate, or prove permission decisions. Preserve compatibility readers or apply a tested migration for existing persisted states.

## 4. Implementation tasks (bounded, in priority order)

### T1 — One authoritative execution/state owner

**Goal:** Avoid multiple independently authoritative queue/dispatch/checkpoint mechanisms for the same mission.

- Identify the actual central mission manager and its live operation entrypoint. Reuse it; do not create a new general framework.
- Make one idempotent task identity and one authoritative state transition model. Existing specialized managers may remain adapters, but must delegate scheduling, claims, retries and durable results to the same owner when semantically compatible.
- Preserve independent mission specifications and scopes; do not mix mission acceptance with task settlement or human approval.
- Implement restart/resume, concurrency leases, no double execution/approval, scoped invalidation, and precise terminal `DONE / WAITING_AUTHORITY / BLOCKED_UNSAFE / FAILED_RECOVERABLE` equivalents using existing vocabulary when possible.
- Detect two identical no-progress fingerprints; diagnose/park the blocked task and run independent work instead of endlessly checkpointing.

**DoD:** A real user-facing/agent entrypoint uses the consolidated owner; crash/restart, parallel claim, approved artifact reuse, changed input, blocked independent task, and terminal no-op tests pass. No second authoritative queue makes the same decision. Capture before/after authority graph and remove or deprecate redundant live state paths safely.

### T2 — Standing-grant autonomous permission decisions

**Goal:** No routine human step in operations already covered by valid delegated authority.

- Inventory actual effect classes (`READ_ONLY`, `CREATE_ARTIFACT`, `CODE_MUTATION`, `NETWORK`, `DESTRUCTIVE`, `EXTERNAL_ACTION`, etc.), scope checks and tool owners.
- At the existing policy/permission enforcement seam, add or reuse **standing grants**: principal, effect, allowed targets/tools, resource ceiling, expiry/revocation, version/source binding if applicable. A grant originates from established authority; the agent never grants or widens its own authority.
- Evaluate policy deterministically at execution, retry, scheduling and promotion boundaries; ensure the actual gateway enforces denial independent of model prompts.
- For fully covered actions, route directly without `REQUEST_HUMAN_REVIEW`; for insufficient grants, fail closed or park only the affected task, without suspending unrelated authorized tasks.
- Allow self-evolution only within the preexisting delegated mutation scope and under invariant checks; a request to disable the checker itself is outside that scope unless explicitly independently authorized.
- Do not change third-party or legally mandated approvals into automatic grants.

**DoD:** Identical permitted synthetic tasks complete with zero per-task human prompts; absent/expired/revoked/out-of-scope/aliased/forged grants and cross-user actions are refused *before* side effects. No extra privilege appears after self-update, restart or retry. Existing mission test suites keep their security results.

### T3 — Replace ceremony with objective verification

**Goal:** Accept and promote safely eligible changes without repetitive paperwork.

- Trace FIC, review packets, completion records, acceptance queues and promotion gates. Determine which decisions can be made from standing authority plus real code/test/evidence provenance.
- For eligible **internal** code/component changes, make automatic technical verification and governed promotion a normal operation under existing grants, using the real version resolver and rollback mechanism.
- Keep explicit human/external authorization when required by a nondelegated right, signed contract, third-party system or protected policy. Such workflows remain available, but they cannot monopolize all unrelated autonomous work.
- Preserve an independently testable verifier: mutation proposer must not forge its own results, alter policy, suppress failing tests or self-certify using generated prose. Use real executable assertions and trusted status sources.
- Convert redundant review artifacts into on-demand machine-readable receipts derived from one canonical execution record. Maintain required FIC semantics until authorized amendments to those contracts are in effect.

**DoD:** One representative code change passes targeted tests, is independently verified, safely activated under a preexisting permitted grant and rolled back under deliberate failure. Forged tests, stale evidence, missing FIC where still required, wrong privilege, incompatible version and self-approval of policy expansion are rejected. Do not label past pending human-reviewed missions `ACCEPTED` retroactively.

### T4 — Evidence and checkpoint deduplication

**Goal:** Stop repeated full-mission certification for unrelated changes.

- Build/use a content-dependency map: executable source/contracts, scenarios, affected tests, evidence digests and release pointer.
- An unrelated report, timestamp or documentation commit should not force mass recompilation/re-certification unless an **actual verified existing contract** explicitly requires whole-HEAD binding. If so, change that contract only through valid authority and versioned migration, not by bypassing it silently.
- Preserve traceability to original measured source and exact tests. Record `REUSED_VERIFIED` only when all relevant inputs match.
- Make bulky reports reproducible, queryable views or final exports; retain the minimal source evidence/receipts and explicit histories needed for audit.
- Ensure report generation cannot trigger itself by modifying an input it hashes.

**DoD:** With same inputs, rerunning a completed mission produces no new evidence-only commits or new approvals. Editing an unrelated Markdown file leaves unaffected proof reusable; modifying security source invalidates only dependent proof (or the legitimately broader set defined by current contract). Tampering, missing assertions and changed authority are caught.

### T5 — One practical autonomous repair/rollback loop

**Goal:** Errors do not cause infinite stall or unsafe continuous retries.

- Reuse the existing recovery/diagnostic/repair capability, not a second self-healing controller.
- On failed tests/activation: classify failure, keep last-good version, apply one bounded repair attempt under current grants, rerun affected tests, rollback if unsafe, and park the exact blocked task if the same fingerprint repeats.
- Preserve state and evidence so another worker can resume without repeating side effects. Continue independent permitted work.
- Do not automatically retry resource-limit refusals; respect `AGENTS.md` workload limits.

**DoD:** Fault-injection tests prove automatic recovery or rollback, bounded attempt count, no corrupted release pointer, no duplicate landing/external effects, and unrelated task progress. The system cannot recursively rewrite protected safety constraints to force a pass.

### T6 — Compact status, minimal docs, deprecation and compatibility

**Goal:** Keep the working system understandable without ceremony.

- Provide one small human-readable status view derived from authoritative machine state: task, owner, latest verified code/evidence digest, effect scope, test verdict, active version, blocker, next runnable action.
- Move historical task transcripts out of `AGENTS.md` if present while preserving current live operating rules. Keep short docs that explain architecture, policy boundaries and migration.
- Delete deprecated files only after no live consumers remain or compatibility is migrated; preserve required release/audit records and documented historical evidence.
- Measure file/line count of *active governance logic*, number of authoritative state owners, per-task gates, operator interruptions, latency, and redundant report commits. Avoid counting deletion alone as success.

**DoD:** Current CLI/UI/runtime call paths still work; all consumers use authoritative state or tested compatibility adapter; no dead import or missing persisted reader; old and new state records migrate/recover safely; status reflects actual effects, not prose claims.

## 5. Cross-cutting security guarantees — never optimize away

- L0 independent minimal kernel and existing policy/tool boundary; no model-driven direct execution authority.
- Enforced permissions, least privilege, scope/expiry/revocation, no self-granted escalation, including self-modifying policy/governance code.
- Safe filesystem/network/egress boundaries, secrets handling, audit/provenance and no unauthorized data access.
- Real assertions with negative/adversarial cases; clear distinction between implementation, validation, technical acceptance, release and production adoption.
- Atomic state/landing, locking, durable idempotency, source-binding, version compatibility, rollback and in-flight operation continuity.
- One running guarded experiment according to active host resource limits; preservation of VPN push hook and repository-ref policy.
- Scope separation: local synthetic research acceptance does not imply enterprise, legal or third-party approval.

## 6. Execution sequence and no-stall strategy

1. Capture HEAD, clean/dirty status, live workers/leases and baseline outcomes. Take *one* compact inventory, no report cascade.
2. Identify a small number of high-cost redundant paths using actual traces. Prioritize a removal/merge only when a working alternative exists.
3. Implement T1–T6 in independently deployable, reversible slices; each slice: pre-fix negative case -> minimum code edit -> focused and neighboring tests -> compatibility check -> measured improvement -> commit once. Assign disjoint writers on shared `main`.
4. Do **not** run whole-product certification after every slice. Use affected tests, then one stable final integrated verification after changes settle.
5. When a required authority is missing, do not stop everything: park the exact action and continue independent tasks. Do not circumvent the missing authority via tests or JSON edits.
6. Keep no more than one authoritative overall controller for this cleanup. No duplicate worker prompts or recursive self-triggering.
7. At the end, exercise three realistic deterministic, local missions end-to-end: (a) simple permitted read/report, (b) allowed code evolution and promotion, (c) governed synthetic ingestion. Include rejection of an out-of-scope tool action, and recovery from injected failure.
8. Capture before/after measured outcomes and independently verify full affected security regressions, L0 isolation and repo policy. Fix introduced regressions or rollback the slice. Persist exact final state, not a celebratory declaration.

## 7. Whole-mission acceptance criteria (all required)

- [ ] At least three real entrypoints traverse the simplified path with no mandatory human prompt for fully authorized operations; claims verified in actual integration tests.
- [ ] A single existing manager is authoritative for shared scheduling/claims; specialized adapters cannot bypass it. Any unmerged separate authorities have explicit, measured reasons.
- [ ] No operation can obtain new privileges merely by editing its own policy, altering a report, or writing its own approval record.
- [ ] All originally applicable negative security invariants retain passing coverage; missing/non-executable tests remain `UNRUN`, not `PASS`.
- [ ] Replay/restart/idempotency, concurrency, controlled release, rollback and protected-host constraints pass.
- [ ] Unchanged inputs yield no endless checkpoint or evidence regeneration; changed relevant inputs invalidate correctly.
- [ ] The baseline-to-final comparison reports actual stage counts, latency (with test setup held constant), human-interruption count, duplicate report writes and distinct authoritative stores; no invented performance claim.
- [ ] Existing mission source requirements remain satisfied or explicit scope and authorized contract changes are documented. No prior record is falsely promoted to `ACCEPTED`.
- [ ] No new global manager/kernel/governance framework is introduced. L0 remains minimal; L2 remains spec-only.
- [ ] One compact reusable architecture/status document and actual code/tests/migrations are committed; finished work is not merely prompt files, diagrams or plans.

## 8. Mandatory per-slice response

```text
MISSION: DT_AUTONOMY_FIRST_BUREAUCRACY_REDUCTION
SOURCE_HEAD_BEFORE / AFTER: <actual shas>
SLICE: <T1..T6, precise changed behavior>
AUTHORITY: <real grant / FIC / code owner scope, or exact blocker>
PREVIOUS_PATH: <old execution chain and measured gates>
NEW_PATH: <new actual execution chain and measured gates>
FILES: <changed paths>
TESTS: <guarded commands, collection, pass/fail, negative assertions>
COMPATIBILITY / MIGRATION: <actual result>
SECURITY: <regressions and attempted escalation checks>
LATENCY / OVERHEAD: <measured before/after, or NOT_MEASURED>
STATE: DONE | REUSED_VERIFIED | BLOCKED_AUTHORITY | BLOCKED_SAFETY | FAILED
NEXT: <one legitimate independent action, or terminal>
```

Final summary must distinguish: **operational autonomy**, **fewer bureaucratic steps**, **actual safety evidence**, **authority boundaries**, and **unproven areas**. No arbitrary 100% label. This prompt is authorization to investigate and implement *within existing delegated permissions*, not to give DT unlimited external or administrative rights.

## 9. Start now

Read the current repository, verify all paths, find the **first live duplicative execution/approval chain** with measurable overhead, implement its minimal safe simplification, run focused tests, and continue through the bounded tasks. Do not stop after an analysis document. Do not initiate a separate mission-management or governance project. Preserve the ability to run DoubleTake fully unattended **for all tasks already covered by standing permissions**.
