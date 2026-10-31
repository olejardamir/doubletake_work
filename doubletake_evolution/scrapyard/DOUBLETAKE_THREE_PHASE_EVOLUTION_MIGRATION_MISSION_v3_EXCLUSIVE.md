# DOUBLETAKE — THREE-PHASE EVOLUTION MIGRATION MISSION v3

## Mission status and execution instruction

**EXECUTE against the current DoubleTake repository in EXCLUSIVE MIGRATION MODE.** This is a code-changing migration mission, not a request for an architecture essay, a roadmap alone, or a new independent agent framework. Inspect the actual checked-out repository and its live execution paths first; file names below are orientation points, not proof that any module is active. Continue through implementation, executable testing, integration and an evidence-backed final verdict. Work iteratively while measurable work remains, with bounded attempts and a genuine stopping condition. **Do not run an unbounded self-restarting loop.**

### Mission objective

Transform DoubleTake's existing evolutionary mechanisms into one coherent, **three-phase evolutionary system**:

1. **OUTWARD (+):** discover, create, evaluate and integrate genuinely useful new intelligence, knowledge and capabilities.
2. **INWARD (−):** evolve existing implementations inward: unify representations, consolidate duplicate or fragmented mechanisms, reduce execution and maintenance complexity, and increase capability density **without sacrificing demonstrated behaviors**. Inward work may produce a stronger general algorithm, not merely smaller code.
3. **GROUNDING (⏚):** independently challenge claims, measure changes on realistic and unfamiliar work, test generalization and integration, and return evidence to both other phases.

The phases rotate **emphasis and bounded resources**, not their safety requirements. All candidates in every phase always undergo the normal pre-promotion verification. A dedicated grounding emphasis performs deeper, independent audits. **Grounding is a reference/evaluation function, not a license to add a third redundant orchestration stack.**

Success means changed production code on a reachable path, demonstrable phase-aware evolution, at least one materially valuable inward transformation with preserved behavior, measurable grounding feedback, a working bounded phase rotation, **verified restart-ready compatibility for every applicable paused Bank driver without actually resuming its continuous workload**, and tests that prove outcomes rather than naming components. Documentation and passing isolated helper tests alone do not complete this mission.

## Non-negotiable constraints

- Respect the existing L0/L1/L2 boundaries and authoritative ownership. L1 is an external control-plane scaffold; do not assume its documented features are active runtime paths. Identify the actual runtime owner before editing.
- Reuse the existing evolution engine, candidate experimentation, scheduling, capability registry, evidence ledger, deployment gates and rollback. **Do not create parallel routers, alternative capability registries, duplicate promotion authority, a second Borg, or three new autonomous runtimes.**
- Preserve security and authorization boundaries, isolation, user control, capability participation, evidence provenance, durable state, replayability and rollback. No bank credentials, infrastructure, external bank connections, or privileged operations are needed for tests: use public or synthetic tasks.
- Maintain all verified outward functionality. Inward candidates must pass equivalence/behavioral tests covering affected contracts, plus non-regression on held-out work; deletion happens **only after** evidence supports retirement. A reduced line count is not success on its own.
- Avoid premature sweeping rewrites. Change one canonical owner at a time, ship small reviewable increments, retain a known-good state, and test on pinned snapshots.
- **Exclusive migration:** The operator intends all six Bank workloads to be paused. Do not assume they have actually stopped: verify the stop/checkpoint state before modifying production code. Do not stop, kill, or restart any process yourself without explicit operator authorization. If any conflicting Bank driver is still active, request a graceful operator stop and treat exclusive-migration entry as `BLOCKED` until verified. Other non-Bank processes may also own files: inspect before editing. Never reset, force-push, overwrite uncommitted changes, stage unrelated files, or claim another agent's work as your own. Use isolated experiment worktrees, ownership-scoped commits, and reevaluate the exact landing baseline.
- Never install or download models or tools merely to make the migration work. Use existing dependencies and already-authorized model/provider interfaces. No new infrastructure without demonstrated necessity.
- No invented measurements, tests, runtime invocations, evidence, or completion claims. Distinguish `PASSED`, `FAILED`, `BLOCKED`, `NOT_RUN`, `INCONCLUSIVE` and `NOT_APPLICABLE`.
- No arbitrary 120-degree timed switching or mandatory 60/20/20 allocation. Those are metaphors/illustrative starting hypotheses, not a validated policy.
- **Driver compatibility is mandatory but not assumed.** A `.md` prompt is not executable wiring by itself: prove that the real process launched for that driver calls the phase-aware runtime. Where a driver is an external OpenCode instruction executed directly against the repository, the migration must identify that boundary honestly and arrange the smallest reliable shared execution contract or make a justified, minimal driver amendment. Never claim universal automatic adoption if the driver bypasses DT runtime.
- **Paused-driver handling:** Pin and inventory each driver definition. Keep all six Bank missions stopped for the duration of the migration; never launch their continuous loops, even for acceptance testing. Publish minimal versioned compatibility amendments only when evidence demands them. Existing process contexts may still contain older instructions; on-disk edits do not imply adoption. Prepare an explicit operator-controlled restart/handoff plan for after migration acceptance.
- The six existing Bank missions are **five specialization drivers plus one bounded UI integration mission**, not necessarily six identical, long-running schedulers. Do not force a finished or non-evolutionary driver to rotate. Define applicability by observed entry point and work type, not by filename.

## Repository orientation — verify before use

Likely owners from recent repo inspection (these may move as concurrent work lands):

- `tools/doubletake_evolve/collective_innovation/innovation.py` and `models.py`: gap → candidate → experiment → compare → select → deployment, digest-bound ledgers, strict demonstrated improvement.
- `tools/doubletake_evolve/collective_core/innovation_guard.py`: synthesis/composition validation and quarantined-component checks.
- `tools/doubletake_evolve/collective_core/harvest_scheduler.py`: multi-fidelity probe scheduling (ASHA/Hyperband-like rungs).
- `tools/doubletake_evolve/collective_core/harvest_loop.py`, harvest generators and research-source evolution: candidate discovery/evaluation.
- `tools/doubletake_evolve/collective_core/obsolescence.py`: evidence-based capability obsolescence assessments; the module previously described itself as **not yet connected to a production runtime consumer**. Verify actual reachability before relying on it.
- `tools/doubletake_evolve/collective_core/strategy_utility.py`: outcome-based strategy choice for task decomposition; may be gated/off. Do **not** mistake it for an existing evolutionary phase controller.
- `tools/doubletake_evolve/autonomous_loop/loop.py`: bounded iterative action/verification loop; do not automatically treat this as the owner of system evolution.
- `tools/doubletake_evolve/collective_core/capability_participation.py`, `tools/doubletake_evolve/runtime/capability_participation_surface.py`, `tools/doubletake_evolve/api/chat_sse/chat_route.py` and `event_stream.py`, `ui/src/hooks/useSendMessage.js`: user ingress and selected capability contribution.
- `L1/README.md`, L1 controller/promotion and evidence contracts: relevant governance boundaries, not necessarily active implementation.

Resolve the full runtime call graph, configuration, artifact/ledger owners, state handoff and actual promotion path. If these candidate owners are dead/unreachable, find the live ones and document why.

## Stage −1 — Exclusive migration entry and preservation gate (MANDATORY)

**This mission is the only authorized evolutionary implementation workload until acceptance.** "Exclusive" does not authorize taking over unrelated user work or killing processes; it is an operator-approved operating condition to verify, not to assume.

1. Inventory the five specialized Bank evolution instances and the sixth bounded UI integration mission, including any replacements/duplicate launchers and their real process/run identities when observable. Mark each `STOPPED_CONFIRMED`, `QUIESCING`, `ACTIVE`, or `UNKNOWN`; a missing PID alone is not proof that work is committed or quiesced.
2. Ask the operator to **gracefully stop/checkpoint** any still-active Bank workload. Finish in-flight atomic writes, transactions and Git operations where safe. Do not terminate, force-close, reset or restart those agents on your own. If processes or launchers are not inspectable, request a clear operator attestation and record its limitations rather than claiming machine verification.
3. Preserve and record each mission's driver/mission versions, objective, completed checkpoints, uncommitted work ownership, commit SHA, durable run/evidence records, and resumable invocation. Never mark pending work completed or re-run completed work merely because a phase schema changed.
4. Inspect repository status; **do not demand a clean tree by discarding edits**. Reconcile and preserve pre-existing work using attributable commits, checkpoints, or isolated worktrees before establishing a reproducible migration baseline. Confirm there are no active writers on paths that this mission will modify.
5. Record `EXCLUSIVE_MIGRATION_READY` only when stop/checkpoint, ownership, and baseline conditions are supportable. Otherwise return `BLOCKED_EXCLUSIVE_ENTRY` and specific safe operator actions; do **not** proceed to production migration.
6. Keep the Bank drivers paused through **every** later stage, including integration tests and final review. Test actual launcher compatibility using a bounded single-shot/dry-run/recorded-transport harness that cannot schedule its long-running loop. An acceptance test must be able to demonstrate the real launch contract while suppressing autonomous continuation, with proof it did not resume a paused mission.

**Gate −1:** No production modifications, scheduler activation, migration promotion, or Bank-driver restart before the exclusive-entry evidence is sufficient. Non-mutating inventory and baseline exploration are permitted while this gate is unresolved.

## Stage 0 — Establish a trustworthy baseline before editing

1. Record base commit SHA and clean/dirty state; confirm exclusive-migration evidence from Gate −1, check for unexpected new writers, and preserve any newly detected work.
2. Inventory all materially active evolution paths: gap/need declaration, source discovery, candidate generation, evaluation, multi-agent composition, evidence verification, promotion, runtime capability publication, and UI-chat execution. Classify each as `LIVE`, `REACHABLE_UNPROVEN`, `LIBRARY_ONLY`, `DEAD`, or `UNKNOWN`, with evidence.
3. Reuse the Gate −1 snapshot to discover and inventory **all six paused Bank mission/driver pairs actually in use** and any additional configured drivers that share the relevant evolutionary route. Search the repository, versioned prompt pack, available run manifests and configured launch commands; do not infer runtime execution from repository presence. For each record: canonical driver path, linked mission path, configured command/process identity if observable, active/unknown status, ingress, called evolution engine, proof of reachability, default behavior, and whether the driver bypasses DT runtime. Avoid exposing tokens or private process data in reports. If local running-process inspection is unavailable, label it `NOT_VERIFIED` and request a reproducible invocation receipt, not a guess.
4. Identify and map all existing phase-like concepts and every relevant scheduler/loop. Select **one canonical integration point** for phase policy and **one canonical acceptance/promotion decision**, preserving existing authority. No new active control plane without proving the current one cannot support the requirements.
5. Construct a frozen, versioned baseline of representative tasks covering ordinary chat, technical diagnosis, unfamiliar causal reasoning, knowledge/capability reuse, composition, multi-step execution, failure handling, recovery, and security refusals. Include negative controls and tasks designed to reveal regression. Record actual invocation, execution effects, correctness, resource cost and reliability when measurable.
6. Benchmark feasible complexity proxies: reachable production owners, duplicated live responsibilities, branch/call-path complexity, runtime overhead, provider/tool calls, dependency/coupling hotspots, and code surface. Document limitations of every proxy.
7. Capture execution receipts and evidence hashes before changing implementation; avoid test leakage and benchmark contamination.

**Gate 0:** No structural deletion, automatic promotion, or phase rotation until the live owner map, **Bank driver compatibility inventory**, and repeatable baseline are established. If blocked, finish with a truthful blocker report instead of inventing measurements.

## Stage 1 — Shared, multi-objective evidence contract

Introduce the smallest backward-compatible extension at the existing evaluation/record boundary; do not rewrite frozen historical digests or change old ledger entries in place. Explicitly version any new record/schema and preserve legacy parsing where supported.

Classify candidates as `OUTWARD` or `INWARD`; `GROUNDING` is an evaluation campaign and source of evidence/challenges, **not a way for changes to bypass candidate promotion**. Every candidate must declare:

- Stable candidate identity, phase intent, baseline commit/registry digest, owner and affected behavior contracts.
- Falsifiable hypothesis and objective improvement target.
- Experiment/worktree identity, matched baseline and candidate runs, non-vacuous positive and negative controls, and source/test provenance.
- A measured quality vector when available: task success/quality, reliability, generalization, implementation complexity, execution cost, latency, and security/invariant results. Keep `UNMEASURED` distinct from zero and prohibit score fabrication.
- Predeclared **hard constraints** (authorization, safety, no false completion, regressions, capability reachability, required user-visible behavior) that cannot be compensated by a weighted fitness score.
- Observed failures, uncertainty, invalidated assumptions, rollback plan, downstream affected capabilities and exact promotion decision.

**Selection principle:** choose using explicit feasibility constraints plus Pareto/non-dominated comparison or a documented deterministic tie policy. Do not silently replace the existing strict-baseline-win rule; evolve it compatibly to allow **equivalent user capability with independently verified lower complexity/cost** as a legitimate *inward improvement*. Do not accept a non-improvement because its phase name is `INWARD`.

## Stage 2 — Real inward evolution, first

Do not start by writing a phase scheduler. First prove that the live innovation/promotion path can evaluate and integrate an inward candidate.

Generate opportunities from **observed production redundancies**, such as duplicate validation rules, multiple owners of the same state, unnecessary wrapper paths, repeated evidence readers, fragmented hypothesis comparisons, or overlapping capability execution abstractions. Rank by plausible effect on real tasks, not lines removed.

Support four candidate classes:

- `I1` — eliminate redundant implementations while preserving all callers and contracts.
- `I2` — consolidate architecture/ownership, avoiding parallel execution and state paths.
- `I3` — unify related cognitive or evidence mechanisms into one more general implementation.
- `I4` — discover a demonstrably stronger shared representation/algorithm that subsumes specialized predecessors.

For the first migration, select **one high-value, bounded, reachable** I1/I2 target unless an I3/I4 opportunity is already provable. Independently measure before and after on the frozen baseline and adversarial negative controls; retain deprecated compatibility entry points temporarily where required. Verify rollback and actual callers. Delete obsolete implementations only after the replacement is proven, and show an explicit map from each retired behavior to its tested successor.

**Gate 2:** At least one inward transformation must land with proven preserved or improved task behavior and a material, measurable reduction in complexity/cost. If no honest candidate passes, record `NO_JUSTIFIED_INWARD_CHANGE`, keep production unchanged, and do not pretend the phase is implemented.

## Stage 3 — Grounding as independent empirical selection

Reuse the current gates and test infrastructure. Add the smallest practical common evaluator that can test both outward and inward records against the **same pinned evidence basis**.

Two levels:

1. **Always-on pre-promotion grounding:** reproducible behavior, regression, security, scope, real path reachability, negative controls, evidence integrity and rollback before any candidate lands.
2. **Dedicated grounding emphasis:** independent held-out and unfamiliar tasks, ablation (disable/remove candidate to prove contribution), cross-capability use, realistic user chat, failure recovery, calibrated uncertainty, and comparison against a stable baseline. When feasible, compare with a matched external agent without claiming superiority from mismatched model/tool/compute budgets.

Grounding must feed back actionable counterexamples and opportunity records: outward gaps where ability is missing; inward opportunities where equivalent ability is duplicated; regressions requiring rollback. Record invalid/null results and epistemic limits. Never equate passing unit tests with broader intelligence or externally useful outcomes.

A grounding cycle can legitimately produce **zero promotions**. It must be possible to discover a promoted improvement was unsound and trigger safe re-evaluation/reversion through existing authority.

## Stage 4 — Bounded phase rotation using the existing runtime

Only after Stages 0–3 have evidence, integrate a **small phase emphasis policy** at the verified canonical scheduler/orchestration owner. Reuse established queues, budgets, work identity, ledgers and locks.

- Maintain one rotation state: current emphasis, allocation caps, evidence confidence, backlog/opportunity counts, pending evaluations, prior results, and relevant pinned baseline. Keep it durable or derivable using the established state owner; do not introduce a separate state service.
- Permit all phases to have useful work simultaneously. Allocate additional exploration/evaluation budget to the current emphasis, not exclusive execution. All phase candidates always meet continuous grounding gates.
- Start with bounded **round-robin emphasis** or a documented modest weighting as a baseline. Switch on completed bounded work units and real backpressure (not raw wall-clock alone). Enforce fairness, starvation limits, finite resource budgets and recovery from an interrupted rotation.
- Run an A/B evaluation of simple rotation versus available baseline scheduling with comparable work and resource budgets. Only adopt adaptive phase allocation when measured feedback outperforms or clearly matches a simpler policy while reducing cost/complexity. Do not import the task-decomposition utility mechanism blindly.
- Outward-to-inward handoff: new capability becomes consolidation candidate if its behavior duplicates or fragments an existing owner.
- Inward-to-grounding handoff: affected contracts and old/new implementation equivalents become frozen evaluation obligations.
- Grounding-to-outward/inward handoff: unexplained errors, regressions and opportunities become separately ranked proposals, not permission to alter production without normal acceptance.
- Prevent thrashing: limit phase switches, rate-limit repeated rejected hypotheses, avoid redoing already-proven failures, and allow abstention when no valuable work is available.

**Gate 4:** Demonstrate a complete OUTWARD → INWARD → GROUNDING → next-cycle feedback rotation on the real production owner with attributable state transitions and restart recovery. Each phase must do meaningful work rather than update a label; no forced code change where evidence finds none.

## Stage 5 — Full user-value integration

Verify the actual path: `React UI user prompt → /api/chat → intent/capability routing → capability invocation → model/tool context → final answer → UI`, plus queue/tool paths where materially different.

- Confirm outward discoveries and inward-consolidated implementations remain selectable and reachable from ordinary appropriate prompts, not only from direct helper tests.
- Show capability contribution by ablation: compare with/without the mechanism on matched user tasks. Inspect actual tool calls/behavior, not just trace strings saying `participated`.
- Verify that grounding findings can change future evolution opportunities, while a benign ordinary chat remains free of irrelevant evolutionary overhead.
- Confirm negative controls: irrelevant capability is not activated; failed/untested work is not called complete; quarantined capabilities are not introduced through recombination; plan-only and authorization restrictions remain intact; interrupted runs are accurately accounted for.
- Run frozen plus held-out tests after latest-main integration. Report flaky, blocked, pre-existing and induced failures separately with evidence rather than hiding them.

## Stage 5A — Existing Bank driver adoption (mandatory; cannot be satisfied by generic UI tests)

The six existing missions are: `01_REASONING_INTELLIGENCE`, `02_BANK_RELEVANT_PROBLEM_SOLVING`, `03_KNOWLEDGE_EVOLUTION`, `04_AUTONOMOUS_TASK_EXECUTION`, `05_RELIABILITY_RECOVERY`, and `06_END_TO_END_UI_INTEGRATION` (or the actual observed equivalent of the sixth bounded mission). The first five were delivered as distinct `MASTER_DRIVER.md` + `MISSION.md` pairs under `MAIN_DOCS/OTHER/BANK/DOUBLETAKE_SPECIALIZED_EVOLUTION_PACK_v1/`; verify current names/locations rather than assuming they remain unchanged. The sixth was a separate bounded `.md` migration/integration mission. Discover any replacements, duplicates, or additional active launchers and report them. **Do not interpret this list as proof that the six scripts are all running.**

### A. Reachability matrix for every driver

Create a machine-readable row and a human-readable audit trail per actual driver:

`driver_id | driver_sha | linked_mission_sha | actual launcher/command | observed run ID | entry point | uses canonical evolution owner? | OUTWARD handoff | INWARD handoff | GROUNDING handoff | promotion gate | feedback receipt | compatibility action | verdict`.

For each row distinguish `VERIFIED_LIVE`, `STATIC_REACHABLE_ONLY`, `EXTERNAL_DRIVER`, `UNKNOWN`, and `INAPPLICABLE_WITH_REASON`. Include a separate explicit status for `NOT_RUN`, `BLOCKED`, `FAILED`, `PASS`. Mere filename presence, imported helpers, log messages stating phase names, or a prompt that instructs the model to 'use three phases' do **not** establish integration.

### B. One canonical, backwards-compatible entry contract

For applicable evolution work entering via the Bank drivers, use the **existing** evolution ingress and canonical owner to receive a normalized work request containing its objective, owner, evidence requirements, phase eligibility and run identity. If the drivers launch the OpenCode CLI directly and bypass that owner, determine the lightest truthful bridge (for example, a verifiable existing CLI dispatch seam, a versioned driver preamble that invokes the canonical interface, or a launch-wrapper amendment). **Do not create a second scheduler, proxy all chat traffic through a new service, or assume that editing a markdown document changes a running process.**

Preserve each driver's original specialization and task priorities. Rotation is at the evolutionary-work boundary; ordinary Bank task answers, security interventions, and one-time bounded integration/verification work must not be artificially turned into endless research cycles. No mandatory three-model invocation or three-agent sequence on every request. Explicitly account for provider time/tool budget and continue the user's original work.

All applicable evolutions must share the same phase policy, measurement contracts, and promotion authority. Historical work remains valid, historical records remain immutable, and the migration must not replay previously completed work or invalidate prior evidence merely because its original driver lacked phase tags.

### C. Executable representative acceptance per driver

For every **applicable** paused specialization driver, capture one representative **bounded, non-continuing acceptance invocation** through **the same launcher/entry point an operator uses**, on a synthetic/public task, with normal provider/tool constraints or a faithful recorded-transport harness if external calls are unavailable. Explicitly disable autonomous continuation, recurring scheduling and agent self-restart in the test; prove that no paused Bank evolution loop was resumed. Prove the emitted request reaches the shared phase-aware owner and records real work, not merely the textual instruction. For each test:

1. Establish an old-or-legacy compatible baseline: original mission objective still reaches its prior capability path.
2. Demonstrate an eligible outward improvement or legitimate `NO_CHANGE`, plus an actual inward opportunity assessment or documented `NO_JUSTIFIED_INWARD_CHANGE`, plus independent grounding evidence; phase *work* may span rotation rounds rather than all execute synchronously per task.
3. Observe a committed phase-emphasis transition and a feedback receipt that affects future candidate prioritization on the **same durable owner**; negative controls prove labels alone do not count.
4. Verify permission/security, evidence/provenance, no false-completion, rollback, resource cap and user-visible output remain intact.
5. Repeat on a fresh process or replayable restart path to show persisted compatibility, and verify at latest landed `main` rather than just in an isolated worktree.

For a driver genuinely not applicable (e.g. a completed bounded UI integration mission), prove why using its actual execution contract and ensure its persistent regression tests participate in grounding. **No silent exemptions.** Do not require live adoption **during exclusive migration**: proving restart-ready adoption through a faithful, bounded actual-launcher acceptance test is the target. Record `RESTART_READY_VERIFIED` separately from `LIVE_ADOPTION_NOT_YET_TESTED`; do not mislabel either. If the real launcher cannot be exercised without restarting an indefinite Bank loop, report `BLOCKED_DRIVER_COMPATIBILITY`, specify the minimal safe seam needed, and do not resume that loop. Give explicit operator-controlled post-acceptance restart and live-verification steps.

### D. Counterexamples that must fail acceptance

- A driver writes successful code but never calls canonical phase scheduling or emits a verifiable shared-phase work receipt.
- A modified prompt advertises `OUTWARD/INWARD/GROUNDING` while the runtime never changes its evaluation, selection, and feedback behavior.
- A helper is called only from its unit test or a detached worktree and not from the operator's actual launcher.
- A finished driver is deceptively recorded as rotating merely because another driver's scheduler is active.
- Inward work removes an apparently duplicate implementation whose specialized Bank task behavior changes.
- A bounded test launch or planned post-migration restart uses an older immutable prompt version and falsely reports v3 adoption.
- All acceptance checks pass on a copied harness but fail, are skipped, or become unobservable on current `main`.

**Gate 5A:** Every applicable paused driver has evidenced **restart-ready compatibility** and a bounded same-ingress acceptance test that cannot resume continuous evolution; every non-applicable driver has a supported rationale and regression coverage. Live post-restart adoption is deliberately **not** required to complete the migration, because no Bank driver may be resumed during the mission. Label it `LIVE_ADOPTION_PENDING_OPERATOR_RESTART`, not `VERIFIED_LIVE`. Genuine bypass paths are either repaired or reported as blocking completion. Do not add a fallback that quietly runs the old evolutionary process while claiming three-phase adoption.

## Stage 6 — Cleanup, exclusive integration, and exit

- Before every promotion/merge, reconfirm the exclusive-migration condition and unexpected writers; stop and reconcile if exclusivity is lost. Re-run affected tests on the actual landed tree; a worktree-only passing result is not integrated completion.
- Integrate only the selected canonical implementations; avoid keeping a phase-specific fork of orchestration that must be maintained forever.
- Provide backward compatibility/migration for existing manifests, evidence, config and persisted run state. Explicitly test restart/upgrade/rollback.
- Remove dead or redundant code only with reachability and behavioral proof; do not sweep unrelated modules or generated state.
- Update operator documentation/config minimally, using source paths and command examples verified on current repository.

## Deliverables (must exist in the repo, not only in the final response)

1. `reports/three_phase_evolution/BASELINE.md`: pinned SHA, live ownership map, starting measurements, known unknowns, conflict boundaries.
2. `reports/three_phase_evolution/IMPLEMENTATION.md`: decision on reuse vs modification for each existing evolutionary owner; exact production changes; reasons not to build parallel runtime infrastructure.
3. `reports/three_phase_evolution/EVIDENCE.md`: reproducible before/after experiments, grounding challenges, held-out evaluation, ablations, negative controls, security and recovery results, costs, limitations.
4. `reports/three_phase_evolution/ROTATION.md`: phase rotation events/budgets, starvation/restart tests, feedback handoffs and impact measurements.
5. Versioned executable tests (and code) in the **existing production owner packages**; prove integration with user chat and capability participation, not isolated-only helpers.
6. `reports/three_phase_evolution/BANK_DRIVER_COMPATIBILITY.md` and `BANK_DRIVER_MATRIX.json`: versioned inventory, pause/checkpoint receipts, bounded no-resume launcher tests, applicability, shared phase-owner reachability, any minimal amendments, and an operator-controlled post-acceptance restart/handoff checklist.
7. `reports/three_phase_evolution/FINAL_VERDICT.md` with per-gate `PASS`, `FAIL`, `BLOCKED` or `INCONCLUSIVE`, exact commit SHAs, changed files, tests executed, observed deltas, outstanding risks, rollback and next action.

Do not produce large duplicated prose reports in lieu of implementation. Make records concise, specific and independently reproducible.

## Acceptance criteria — ALL required for `COMPLETE`

- [ ] Gate −1 exclusive migration entered with all six Bank workloads confirmed stopped/checkpointed; no Bank continuous loop was restarted during testing or implementation.

- [ ] Actual live evolution owner traced; no parallel evolution runtime created.
- [ ] Versioned phase-aware candidate/evidence representation supported without historical ledger corruption.
- [ ] Outward evolution remains functional under previous observable contracts.
- [ ] A material inward candidate is integrated with independently verified equivalent or superior behavior and measurable complexity/cost reduction.
- [ ] Independent grounding evaluates both phase types, includes negative cases and can block or reverse unsupported changes.
- [ ] Bounded three-phase **emphasis rotation** executes on the real scheduling path; basic safety checks remain continuous.
- [ ] Evidence-grounded feedback from grounding influences future outward/inward candidate prioritization.
- [ ] User-facing end-to-end participation and capability effectiveness are verified on actual app chat path, including ablation.
- [ ] Every applicable paused Bank driver is **restart-ready** for the shared phase-aware owner, proven via bounded tests through the real operator ingress with phase-feedback receipts **without restarting continuous Bank work**; justified exceptions are recorded.
- [ ] Existing driver objectives and previously completed work remain intact; all six remain paused throughout migration; checkpoint evidence and tested versioned compatibility amendments, if any, are delivered with a safe operator adoption plan. Live adoption is explicitly pending until the operator chooses to resume.
- [ ] Security, permission, isolation, integrity, recovery, migration and rollback contracts hold.
- [ ] Tested changes have landed on the intended branch/tree and are re-measured there; no coworker edits were swept.
- [ ] Evidence manifests and final verdict are present with no unmeasured claims represented as success.

**Stop** at `COMPLETE` only when every criterion passes with actual evidence. Otherwise report `PARTIAL`, `BLOCKED` or `NO_JUSTIFIED_CHANGE` with precise unmet gates. Never loop forever on an unavailable dependency, an unchanged hypothesis, the same failed test, or a conflict; checkpoint and state the unresolved blocker. A future attempt may resume at the checkpoint without repeating accepted work.

## Operating directive to the executing coding agent

Begin by **verifying all six Bank workloads are gracefully stopped and their state/checkpoints preserved**; if this cannot be established, report `BLOCKED_EXCLUSIVE_ENTRY` without changing production code. Then inspect the current repository state, map live evolution owners, and write the reproducible baseline. Proceed with the **first real inward transformation before building rotation**, then grounded acceptance and bounded phase policy, followed by end-to-end user tests **and bounded per-Bank-driver actual-launcher restart-readiness tests (without running continuous loops)**. Prioritize demonstrable intelligence and user value over cosmetic cleanup. Reuse the system's current evolution algorithms and authority; evolve those owners rather than surround them with another framework. Produce verified code changes and a concise final gate report. Do not claim completion merely because a schedule toggles through three names or driver Markdown files mention the new phases.

## Final adversarial self-review before declaring completion

Make one pass attempting to falsify the mission result: locate a real driver that bypasses the canonical owner, a branch of the old runtime left reachable, an untested retirement, a non-independent baseline, a stale commit/fixture, a hidden security regression, a paused Bank loop accidentally resumed, an old loaded driver version, a missing UI contribution, or a phase ledger that advances without real work. Repair substantive defects and rerun the relevant real-path tests. Stop after a pass finds no material defect; do not nitpick presentation, invent metrics, or repeat unchanged unsuccessful experiments.
