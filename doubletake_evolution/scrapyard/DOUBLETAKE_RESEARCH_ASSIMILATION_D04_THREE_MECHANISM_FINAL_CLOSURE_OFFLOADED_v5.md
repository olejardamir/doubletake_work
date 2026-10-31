# DOUBLETAKE — D04 THREE-MECHANISM / D08 FINAL CLOSURE (OFFLOADED v5)

**Target:** `olejardamir/DT` (DoubleTake; **not** Agent_X).  
**Mode:** execute remaining delta only; read live repository truth before changing anything.  
**Supersedes:** v4 as an *execution driver*, while retaining all stricter v3/v4 safety, tests, source-trust and evidence requirements.  
**Observed reference:** GitHub `main` through `a55d35fd7e71` (2026-10-16 07:23 UTC). The latest observed `FINAL_CLOSURE.json` was bound to `0bdd837c2c58`; `PARTIAL_WITH_BLOCKERS`, D01/D02/D03/D05/D06/D07 `PASS`, D04 `BLOCKED`, D08 therefore `BLOCKED`. The inventory recorded **9/12 WORK production-reachable**, **10 WORK with execution evidence**, and **12/12 builders present**. This is a **dated reference**, *not* a fixed HEAD requirement. Always rederive current states from checked-in source and authoritative generators.

## 0. Objective / stopping rule

Close **only three remaining D04 collaborator-owner deficits**, then obtain independently verified **D08 final closure**:

1. `continual_skill_evaluation`: `independent_arm`, `sequential_arm`;
2. `skillevol_frozen_deployment`: `arms` (including every required actual control/treatment arm);
3. `voyager_curriculum_discovery`: `runner`, `verifier`.

Use **actual first-party executable implementations**, fed by authorized persisted owner records and invoked by the existing `production_ingress` -> governed `CollectiveService` phase cycle. An existing builder is **not** an executable owner. A first-party producer mapping is **not** a running collaborator. No placeholder callbacks, fabricated outputs, arbitrary user-provided code, test-only injection, or unmeasured performance claims.

**SUCCESS:** All twelve WORK mechanisms have proved production reachability and service-origin genuine execution through the real route; the three remaining collaborator implementations have specific non-vacuous service-origin tests; D01–D07 independently `PASS`; D08 independently `PASS`; the durable three-scenario D05 chain still verifies; canonical records are committed and retained; `FINAL_CLOSURE.json` has a truthful acceptable closure decision (`OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN` if live gain remains unproven).

**BLOCKED:** Only a real unresolvable trust, authority, upstream-data, or resource obstacle after a bounded good-faith attempt, reported per exact callable/record/owner and supported by evidence. Keep green work, do not fake closure or run indefinitely. A missing owner in **our own source** is normally an implementation task, not an excuse to stop.

## 1. Ground-truth discovery (must happen first)

Read `AGENTS.md`, `ACTIVE_WORK`, git status/log/remote, existing parallel work and these exact modules:

- `tools/doubletake_evolve/collective_innovation/mechanism_runtime.py` — `production_ingress`, `INGRESS_COLLABORATORS`, `INGRESS_COLLABORATOR_REFS`, `INGRESS_COLLABORATOR_OWNERS`, `ingress_collaborator_defects`, assembler dispatch, refusal paths, governed phase cycle.
- `tools/doubletake_evolve/research_assimilation/runtime_bindings.py` — canonical identifiers, `INPUT_REQUIREMENTS`, owner bindings, builder signatures, `CHAIN_EDGES`.
- `tools/doubletake_evolve/research_assimilation/runtime_producers.py`, `runtime_inputs.py` — owner-backed source resolution/digest checks.
- `tools/doubletake_evolve/research_assimilation/{continual_skill_adapter,skillevolbench_adapter,voyager_adapter}.py` — actual typed task/arm/runner/verifier contracts, scoring/evaluation code.
- `tools/doubletake_evolve/research_assimilation/{operational_acceptance,test_operational_acceptance,operational_delta_inventory,criterion_table,final_closure}.py` and associated tests.
- `reports/research_assimilation/operational_closure/{DELTA_INVENTORY,CRITERION_TABLE,TEST_RESULTS,CHAIN_RECEIPTS,BENCHMARKS,PROMOTIONS,FINAL_CLOSURE}.json`, `MECHANISM_MATRIX.md`; `docs/RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION.md`.

**Before writing code**, inspect the *real* contracts and produce a concise working checklist for these three rows: owner location, typed arguments, exact first-party persisted data, missing executable collaborator, call path, test path, anticipated refusal cases. Inspect newer agents' changes; if a gap has already been implemented, **verify and skip it**. Never overwrite a concurrent agent's work, overwrite JSON by hand, or invent a source function name that is not in the current repo.

## 2. D04-A — ContinualSkillBench production collaborators

**Mechanism:** `continual_skill_evaluation`  
**Current canonical builder:** `runtime_bindings.continual_skill_evaluation_work(tasks, independent_arm, sequential_arm, *, max_skills, genuine_margin)`  
**Adapter:** `continual_skill_adapter.py`, especially `SequenceTask`, `ContinualSkillEvaluator`, `build_continual_skill_report`.  
**Persisted source requirements:** `skill_candidate@skills`, `task_sequence@innovation`.

**Implement exactly:**

1. Identify the existing first-party task execution/evaluation service and first-party skill-library operations. Inspect the arm contract in the adapter, including callable signatures, task result schema, permissible state/memory, budget, and scoring semantics. Reuse the real service; do not equate an evaluator that computes metrics with an executable arm that performs tasks.
2. Implement or register **two distinct, first-party owned executable arms** over the *same frozen, provenance-bound task sequence*: independent (tasks without cross-task skill carryover) and sequential (authorized evolving/carryover skill state). Their distinction must be observable in behavior and retained state, not only in names or constant results. Prevent shared-state/cross-arm contamination; use matched task/evaluator versions and bounds. No model/provider download or new paid inference dependency.
3. Bind both collaborators using the existing `INGRESS_COLLABORATOR_*` contract or its legitimate evolved equivalent. Resolve only approved trusted owner code with scope/authority checks; reject missing owner, malformed/stale task/skill data, inconsistent evaluator identity, or absence of a runnable task service as typed non-success. Serialize **references and digests**, never executable callables.
4. Assemble typed input at `mechanism_runtime.production_ingress` using the existing producer bridge and invoke the existing registered builder through the governed service cycle. No adapter-only shortcut, injected `RuntimeContext`, fake runner, or synthetic PASS.
5. Add one positive **service-origin** acceptance scenario in `operational_acceptance.py` using controlled **persisted first-party records**; demonstrate both arms actually run, the comparison derives from their evidence, and a durable receipt survives reload. Add negative tests for arm removal, swapped arms/identity, contamination, no task sequence, bad provenance, permission refusal, out-of-budget, and replay. Ensure an arm-removal mutation makes a specific test fail.

**DoD:** `continual_skill_evaluation` is independently rederived as `production_reachable=true`, runs through the real production ingress with a retained service-origin `EXECUTED` receipt, and every above refusal/mutation property is asserted. A `NOT_RUN`/`BLOCKED` observation is *not* equivalent to success.

## 3. D04-B — SkillEvolBench production arm owner

**Mechanism:** `skillevol_frozen_deployment`  
**Current builder:** `runtime_bindings.skillevol_frozen_deployment_work(tasks, arms, *, max_skills, deployment_margin, composition_arm)`  
**Adapter:** `skillevolbench_adapter.py`, especially `EvolutionTask`, `ArmKind`, `SkillEvolutionEvaluator`, `build_skillevolbench_report`.  
**Persisted requirements:** `skill_candidate@skills`, `deployment_task_set@innovation`.

**Implement exactly:**

1. Inspect current `ArmKind` enumeration, the adapter's minimum valid arms, existing real skill execution/evaluation services, and the required no-skill and raw-trajectory controls. Take the **canonical adapter's full required arm set** as authoritative; do not assume an invented four-arm mapping or change the gate to allow missing controls.
2. Provide first-party executable implementations for **every required arm** operating on a matched frozen deployment task set, with actual skill adoption/retention distinctions and independently measured outcomes. Treat candidate skill promotion/deployment as a *separately governed* action; a positive comparison never self-authorizes promotion.
3. Resolve the arm mapping through a registered, authoritative first-party owner (or owner factory), not a serialized callback or test fixture. Validate task/skill provenance, identical evaluation budget and environment, controlled isolation among arms, deterministic or properly versioned evaluator inputs, and refusal on stale/missing/forged records. Preserve resource limits and no code-in-process rule for foreign components.
4. Wire `production_ingress` to assemble the declared typed inputs and trusted arm mapping, then dispatch the **existing builder** through the real service. Preserve pressure and authority checks.
5. Add positive service-origin acceptance covering each required arm with persisted first-party input records and durable result evidence; include negative tests for removal of **each arm**, wrong `ArmKind`, missing control, no executable skill, incorrect ownership, false outcome, authority breach, capacity exhaustion, and replay. Explicit mutation should fail relevant tests.

**DoD:** `skillevol_frozen_deployment` becomes independently `production_reachable=true`, has actual production-initiated comparison with all required arms and retained execution evidence, and denies incomplete or forged arm sets. Do not count prior D05 chain fixtures as proof of production ingress.

## 4. D04-C — Voyager executable curriculum runner / verifier

**Mechanism:** `voyager_curriculum_discovery`  
**Current builder:** `runtime_bindings.voyager_curriculum_discovery_work(dimensions, tasks, runner, verifier, *, warm_up, max_failures, task_budget)`  
**Adapter:** `voyager_adapter.py`, `CurriculumPlanner`, `CurriculumTask`, `CurriculumDimension`, `build_voyager_report`.  
**Persisted requirements:** `capability_gap@capabilities`, `task_verifier@innovation`.

**Implement exactly:**

1. Trace the canonical curriculum/task schema and runner/verifier callable interfaces. Identify the existing authorized first-party task executor and separately trustworthy outcome validation/oracle. A declared `task_verifier` record alone is *not* an executable verification implementation.
2. Implement/register a **real task runner** that attempts admitted curriculum tasks through authorized existing task/capability execution paths, returning measured results and state; implement/register a **verifier** that checks the corresponding actual outcomes independently against the declared capability/task criterion. The verifier must not return PASS merely because the runner claims success.
3. Instantiate dimensions and tasks from provenance-checked persisted first-party capability and innovation records; do not synthesize a favorable challenge, invent scores, or allow user-supplied arbitrary executable callbacks. Honor warm-up, failure thresholds, budgets, curriculum eligibility and bounded progress.
4. Bind runner and verifier to an explicit first-party owner through `INGRESS_COLLABORATOR_*` or its existing canonical successor, assemble in real `production_ingress`, and route through the governed service cycle.
5. Add service-origin positive acceptance proving actual run + independent verification, durable result/reload, and eligible pressure. Add negative tests for task failures, false runner claims, verifier disagreement, missing owner, tampered criteria/digest, exhausted budget, ineligible task, authorization refusal, replay and removed runner/verifier mutations.

**DoD:** `voyager_curriculum_discovery` is independently `production_reachable=true`; both runner and verifier demonstrably execute from production-origin inputs; verified outcome and durable receipt exist; denial/mutation gates hold.

## 5. Shared implementation invariants for all three

- **Single authority:** preserve the 12 `WORK` + one `POLICY SERVICE` registry. Do not redefine active pressures `OUTWARD`/`INWARD`/`GROUNDING`; bind to stable pressure semantics compatible with future verified policy successors.
- **Real production:** invoke existing `production_ingress` and `CollectiveService.innovation_phase_cycle`, with no harness injection or alternate mocked controller. Eligible input can still correctly be refused for insufficient data, authority or budget; don't fabricate successful tasks to inflate counts.
- **No implicit trust:** permit only first-party owner-resolved executable collaborators with immutable/versioned identity and authorized scope. Never deserialize executable Python, import a caller-chosen module, call `eval`, or run foreign code in DT's main process. Preserve sealed Borg, CONDUCT, enterprise and capability gates.
- **Non-vacuity:** each mechanism has a direct positive test and a mutation that makes a specific asserted property fail if its registered collaborator, ingress assembler, or dispatch link is removed. A green test with the whole path disabled is **FAIL**.
- **Durability:** exact input source IDs, schema versions, digest/authority, model/evaluator identity if applicable, pressure, invocation/result, work units and refusal reason must survive replay/restart in authoritative durable records.
- **Measured improvements only:** deterministic algorithmic correctness is not a live-model or production-performance gain. Do not auto-promote a research mechanism or adaptive allocation policy. Preserve `NOT_PROMOTED` where authority is absent.
- **Host safety:** all tests, generators, benchmarks and builds run as guarded commands via `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>`. One focused workload at a time; obey CPU, RAM, time, task and swap caps. Timeout, OOM, missing provider and host refusal are BLOCKED/INCONCLUSIVE, not PASS.
- **Shared main:** obey current `AGENTS.md`/`ACTIVE_WORK`; coordinate concurrent writers; use small atomic commits on authorized `main`; do not rebase/reset/squash away another agent's work. A detached worktree is acceptable only for *clean verification/evidence regeneration* if allowed, not parallel ungoverned development. Commit/push source **before** content-binding generated records to a retained SHA.
- **No work recycling:** D01–D03 and D05–D07 are green at the reference checkpoint; change them only for a specific demonstrated regression or a dependency introduced by these three changes. Do not reopen the already complete research adapters or repeat unrelated bank/enterprise/UI missions.

## 6. D08 independent final closure procedure

After each real mechanism implementation: run focused positive and negative tests through host guard, commit/push in shared-main-safe order, regenerate affected truthful records from retained source, and check the per-ID transition from missing owner -> production reachable -> executed.

When all three are truly complete:

1. Confirm **12/12 WORK** `production_reachable=true` in the independently re-derived `DELTA_INVENTORY.json`; require each of twelve to have a genuine, persisted **service-origin** result and per-mechanism non-vacuous checks. Keep the separate policy service correctly classified.
2. Reverify the three D05 scenarios and `CHAIN_RECEIPTS.json` with their independent verifier; preserve cross-record digest, replay/restart and mutation refusal checks.
3. Regenerate *via existing generator entrypoints and their actual supported options*, in source-defined dependency order: participation/evidence, operational acceptance/benchmarks, inventory, durable chain receipts, policy decision, derived matrix/operator contract, criterion table, final closure. Consult `AGENTS.md`/source; no hand-edited reports, invented flags or self-signing circular evidence.
4. The four canonical baseline commands must each run **under host guard**, along with all other required affected tests and record verifiers:

   ```sh
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/collective_innovation/mechanism_participation.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/evidence_package.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_acceptance.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_benchmarks.py --verify
   ```

5. Regenerate/check `CRITERION_TABLE.json`: D01–D07 each `PASS` on real evidence; D04 specifically **12/12 production-reachable** plus actual service-origin proofs. D08 must be a conjunction of independently checked conditions, never a presence check on `FINAL_CLOSURE.json`.
6. Regenerate/check `FINAL_CLOSURE.json` using its independent verifier; require authoritative retained source commit, truthful digests, commands/outcomes, no unresolved mandatory blockers, all mechanisms and receipts, rollback/promotion decisions and limitations. Distinguish `OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN` from an unsupported live gain. Commit/push generated results; reverify against retained remote state and check for intervening mutations.
7. If all conditions are met, stop. If the real repository evolved and superseded these names, verify exact semantic equivalence through authoritative sources; never change scope or loosen checks merely to print PASS.

## 7. Output after each checkpoint / final response

Use one concise status table for the **three IDs** with: source path/owner, implementation commit, production ingress test and mutation result, authoritative record digest/SHA, `production_reachable`, `executed_production`, remaining blocker. Then provide D04 and D08 verdicts separately, actual verified source/remote commit, test/generator commands with exit status and bounded telemetry, D05 retention status, D06 policy decision, D07 gain limitations, and the **exact** `FINAL_CLOSURE.json` decision.

Never say complete without a retained independently verifiable final closure. Do not ask for reauthorization to implement the already authorized bounded first-party collaboration work. Begin by rechecking the live repository now.
