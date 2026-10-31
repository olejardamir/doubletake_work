# DOUBLETAKE — THREE-PHASE EVOLUTION: FINAL EVIDENCE CLOSURE (OFFLOADED v1)

**Mission type:** execute code and verification on the existing DoubleTake repository. **Scope:** close remaining defects and acceptance gaps in the already implemented three-phase migration. **Do not start the migration again.**

## 0. Authority, inputs and current checkpoint

Read these files **from the actual current checkout**, in this order:

1. `reports/three_phase_evolution/FINAL_VERDICT.md`
2. `reports/three_phase_evolution/EVIDENCE.md`
3. `reports/three_phase_evolution/BANK_DRIVER_COMPATIBILITY.md`
4. `reports/three_phase_evolution/BANK_DRIVER_MATRIX.json`
5. `reports/three_phase_evolution/external_driver_observations.json`
6. `reports/three_phase_evolution/IMPLEMENTATION.md` and `ROTATION.md`
7. Original complete mission `DOUBLETAKE_THREE_PHASE_EVOLUTION_MIGRATION_MISSION_v3_EXCLUSIVE.md` if present locally, or its exact versioned equivalent. Treat it as the **acceptance requirements**, not an instruction to redo completed implementation.
8. The on-disk five specialized Bank `MASTER_DRIVER.md` files and bounded sixth UI integration mission, including `THREE_PHASE_INGRESS_v1.md`.

**Orientation, not a substitute for repository inspection:** At the October 10, 2026 GitHub checkpoint (latest inspected commit `41d9af2b1`), the repository reported overall `PARTIAL` and had substantive production changes in `collective_innovation`, rotation/phase policy, the shared service/CLI, UI chat contribution, test infrastructure and Bank-driver amendments. Previous measurements included 135 passing phase/regression tests, five passing recorded-transport browser cases, matched model-owner call-count reductions (7→4 and 4→2), and 3/3 recovered cases versus 0/3 for a pinned old baseline. These are **reported tests with narrow scopes**, not proof of universal capability, live driver adoption, or real-world task quality. Reverify against current HEAD. Do not copy historic counts into a current verdict without binding them to their tested revision.

The earlier report also states that **exclusive execution was superseded by operator-authorized concurrent scoped work**. This conflicts with the original v3 exclusive migration requirement. Do not resolve the conflict by pretending either condition is currently true. Reconcile the current operator authorization and actual process/worktree state. **Do not stop, restart, kill or resume any Bank workload without explicit authorization.** Do not launch continuous Bank drivers for validation.

## 1. Hard boundaries

- Preserve the established **OUTWARD (+)** capability expansion, **INWARD (−)** consolidation/capability-density improvement, and **GROUNDING (⏚)** independent evaluation, with bounded adaptive phase emphasis. Grounding checks remain mandatory on *every* promoted candidate, not just during grounding-emphasis windows.
- Preserve L0/L1/L2 ownership, the existing innovation engine, registry, experiment harness, ledger, authorized API, capability routing, governance/promotion, recovery and rollback. Never create a second controller, router, state ledger, Borg, evaluator authority or parallel evolution runtime.
- Preserve all accepted code, demonstrated outcomes, evidence, source and mission checkpoints, original domain objectives, and the sixth mission's bounded nature. Do not rewrite finished work, restart old experiments or change prompt goals for stylistic reasons.
- No bank systems, credentials, live infrastructure, new model downloads, or uncontrolled provider calls. Use reproducible public/synthetic/authorized work. Respect host resource guards; a refusal is `BLOCKED`/`NOT_RUN`, not a reason to bypass containment.
- Git: avoid force pushes, resets, sweeping stages, unrelated commits, ownership collisions, or overwrite of peer edits. Pin baselines, use isolated experiment worktrees when feasible, verify exact files at landing and rerun necessary tests on landed HEAD. If concurrent ownership blocks safe landing, record a precise blocker.
- Do not infer live adoption from Markdown mentions, a newly patched driver file, a replacement CLI invocation, suspended database timestamps, synthetic API requests or an agent's own assertion. No claim of improved general intelligence from a pass on synthetic mechanics alone.

## 2. Begin with a delta-only audit (do not code before it)

Create/update a compact acceptance matrix grounded in current sources, with **requirement → canonical code owner → original evidence → latest recheck → verdict → exact remaining action**. At minimum enumerate:

A. Shared production entry from current evolutionary execution paths; backward-compatible legacy behavior and versioned records.

B. Outward candidate generation, preserved existing outcomes, correct admissibility and promotion.

C. Real inward optimization, semantic/functional equivalence, affected runtime/restart contracts, and measured complexity/cost benefit.

D. Independently evaluated grounding: representative held-out or unfamiliar scenarios, negative/ablation controls, and honest confidence bounds.

E. Actual phase rotation and feedback under bounded resource allocation, persistent replay, multiple owners, fair scheduling/no starvation, and correct abstention.

F. Normal **React UI → `/api/chat` → selected capability → real contributed output → model context → rendered response**; positive, ablated, benign and failed cases, using a recorded transport or authorized model where available. Do not assert live-model quality from mocks.

G. All five specialized Bank drivers' **original launcher/loaded instructions** and actual bounded shared-ingress adoption, immutable driver/mission/amendment identity, request-bound receipt, evidence and checkpoint recovery. Sixth bounded UI integration mission must be verified for its own scope without being forced into continuous rotation.

H. Security, authorization, isolation, recovery/rollback, interaction with current revisions, no false completion, and independent completion proof.

For each entry use exactly one of `PASS`, `FAIL`, `PARTIAL`, `BLOCKED`, `NOT_RUN`, `INCONCLUSIVE`, `NOT_APPLICABLE`. A historic `PASS` becomes `RECHECK_REQUIRED` in the working matrix until its relevant source identity and regression evidence have been reconciled. Do **not** treat missing access to external process data as failure or success; identify it separately.

## 3. Execute ONLY unresolved work, in priority order

### Priority 1 — Safe state / concurrency / evidence integrity

- Inventory current HEAD, relevant worktrees, changed files, source hashes, and any process/session observations already available. Ask the operator to establish quiescence only if required; do not invent or force it.
- Determine whether tests ran on the final integrated tree. Address stale or defective fixtures and real regression failures without hiding failed experiments or retroactively changing frozen controls.
- Preserve the original five Bank specialization missions' progress and external checkpoints. If a checkpoint cannot be observed, record exact missing fact and operator step instead of guessing.

### Priority 2 — Actual driver handoff / native adoption

- Confirm the five patched driver definitions still delegate to the **same existing phase-aware owner** via the versioned shared ingress, without an alternate orchestrator or bypass.
- Exercise bounded, replay-safe per-driver invocations through the real authorized API; independently verify phase records, objective-specific relevance, durable replay, feedback and negative cases. A passing substitute CLI is not sufficient for *original external launcher* acceptance.
- When actual launcher/in-memory prompt identity is available, verify a bounded invocation via that exact launcher **with continuation/automatic retries off**, without running a continuous Bank loop. Capture a scrubbed receipt tied to exact driver, mission, amendment and source identities. **Never launch or resume drivers on your own.** If the operator must perform this action, mark `BLOCKED_OPERATOR_ACTION` in detail and provide exact instructions; do not prevent safe non-dependent test work.
- Maintain the bounded sixth UI mission as separate; confirm its completion checkpoint and affected UI contract instead of pretending it is a sixth identical outward scheduler.

### Priority 3 — Independent grounding quality, not just mechanics

- Construct a small but representative, versioned and **precommitted** evaluation corpus: unknown-to-candidate tasks, outward discovery tasks, inward equivalence/regression tasks, causal/technical reasoning tasks, and ordinary chat questions. Synthetic/public scenarios only.
- Compare current system to a pinned prior baseline or deliberately disabled phase under the **same tasks, resource budgets, model/provider availability and permissions**. Separate effects of routing, candidate generation, phase allocation, reliability and model answer quality. Use independent outcome oracles and adversarial negatives; do not let the candidate grade itself.
- Require evidence that the **three-phase policy** changes useful outcomes versus an outward-only control where practicable. If no reliable model/transport is available, test what is measurable and mark actual generalization as `NOT_RUN` or `BLOCKED`, never fabricated.
- Never trade functional/security regression for complexity reduction. Confirm actual inward benefit on a reachable path and retention of old contracts; call-count proxies are limited and must not be presented as total latency or memory savings.

### Priority 4 — Close strictly necessary production gaps

For each candidate defect: reproduce on current reachable path → freeze independent failing test and baseline → minimal canonical-owner repair → ablate/restore old behavior to prove test sensitivity → relevant regression suite → source-bound landing and recheck. If the gap is solely documentation, correct only that documentation. Do not reopen the three-phase architecture or add cosmetic layers.

### Priority 5 — Final integrated acceptance

Execute the focused phase suites, altered entry-path tests, security/recovery tests, driver and browser checks, then the broadest relevant test suite the host can safely run. Record commands, exit codes, source revision, key measures, failed/blocked tests, and resource refusals. Verify the final rendered chat path with appropriate positive/negative controls, without overstating mock-based evidence.

## 4. Final verdict and offloading stop rule

Update **existing** `reports/three_phase_evolution/FINAL_VERDICT.md`, `EVIDENCE.md`, `BANK_DRIVER_MATRIX.json` and `BANK_DRIVER_COMPATIBILITY.md` (plus specific artifacts only if necessary). Keep historic outcomes legible; append delta evidence rather than overwrite history. Explicitly separate:

- **Implemented**: reachable code change with source ownership.
- **Verified**: independent, current-source acceptance evidence.
- **Live-adopted**: real original launchers/loaded instructions proved, not inferred.
- **Operationally resumed**: operator action confirmed; never assume it from compatibility.

Output `COMPLETE` **only** when every applicable original v3 acceptance gate is verified on current state and the independent handoff evidence exists. Otherwise output `PARTIAL`, `BLOCKED`, or `FAILED`, with a small exact backlog, concrete evidence links/paths, and the operator actions needed. It is acceptable—and required—to stop at `PARTIAL` or `BLOCKED` when evidence or authorization is unavailable.

**Iterative execution:** repeat the *delta audit → one justified repair → independent validation → update verdict* cycle while new, measurable progress is possible under the authorized budget. Stop when all gates pass, a genuine external blocker remains, the host refuses further work, or two consecutive bounded passes find no substantive executable change. Do not self-restart indefinitely, spend cycles on report wording, or invent work simply to keep running.

## 5. Final response format

Report concisely:

1. Current repository HEAD and whether the measured tree matches.
2. Exact new fixes since this offloaded prompt, or `NO_JUSTIFIED_CHANGE`.
3. Three-phase engine: outward/inward/grounding/rotation, one short evidence statement per phase.
4. UI path and all five Bank original launchers plus sixth bounded mission: tested versus unverified, explicitly distinguished.
5. Tests: commands, pass/fail/not-run, negative/ablation controls, limitations.
6. Final verdict (`COMPLETE`, `PARTIAL`, `BLOCKED`, `FAILED`) and **only** remaining substantive blockers.
7. Explicit statement that continuous Bank workloads were **not** resumed unless a separately authorized operator did so.

**Success is closure of real remaining evidence and execution gaps—not a longer prompt, a prettier report, a new architecture, a commit count, or a fictional 100% completion claim.**
