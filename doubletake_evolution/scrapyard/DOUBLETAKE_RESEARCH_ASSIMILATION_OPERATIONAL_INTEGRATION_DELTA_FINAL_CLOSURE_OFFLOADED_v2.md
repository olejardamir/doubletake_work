# DOUBLETAKE_RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION — DELTA FINAL CLOSURE (OFFLOADED v2)

**Execution target:** DoubleTake (`olejardamir/DT`), not Agent_X.  
**Execution mode:** delta-only, evidence-first, complete real production integration.  
**Repository baseline inspected:** `main` through commit `860d61af55db3edf85b0c2ebae16ced62003546f` (2026-10-13). This is a reference point, **not** a fixed HEAD requirement. Reinspect actual HEAD before editing.  
**Mission:** Close the operational gaps left by `DOUBLETAKE_RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION_FINAL_CLOSURE_v1`. No claim of final closure is permitted until the requirements below pass on current, retained, committed code.

## 0. Non-negotiable operating rules

1. Read `AGENTS.md`, `docs/RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION.md`, `reports/research_assimilation/operational_closure/MECHANISM_MATRIX.md`, `tools/doubletake_evolve/research_assimilation/runtime_bindings.py`, and the original mission (if available). Inspect the live code and recent commits before deciding what remains. Source and tests supersede stale prose.
2. **Preserve completed work:** keep the 13-participant registry, 13 evidence links, T06 durable replay protection, T08 composition integrity, T09 status, T10 9-scenario acceptance, T11 benchmark verifier, T14 operator contract, and existing SEAGym implementation unless a failing regression proves a change is necessary. Do not redo green milestones just to generate activity.
3. Work against the existing architecture and **single authoritative registration/binding table**. No parallel mock controller, shadow registry, test-only production adapters, hard-coded happy-path outputs, or fabricated source records/scores. The 13th mechanism (`adaptive_operator_selection`) is a policy service, **not** a 13th phase-work builder.
4. Use the current **three-phase policy abstraction** and its pressure semantics (`OUTWARD`, `INWARD`, `GROUNDING`). Bind to stable pressure/contract semantics so a verified successor policy can reuse participants. Do not assume controller private operator names are permanent.
5. Preserve authority separation: eligibility does not grant execution, successful evaluation does not grant promotion, and research code does not bypass CONDUCT/Borg sealed execution/security boundaries. No foreign code execution in-process. No unauthorized model downloads or new paid inference dependency.
6. Work on the authorized shared branch policy in `AGENTS.md`; do not create or switch branches merely to isolate work. Coordinate shared `main` changes, serialize writers of the same paths and report generators, and avoid destructive git operations/squash/reset/rebase that could orphan bound evidence. Where clean-tree measurement is necessary, use safe **detached, temporary verification worktrees only**, consistent with current host policy.
7. Run all tests, builds, generators and mission experiments via `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>`. Observe the configured CPU, memory, task and time constraints. Execute focused tests sequentially. Treat host-guard refusal, timeout, OOM or absent provider as **INCONCLUSIVE/BLOCKED**, never PASS. Do not bypass guard or launch uncontrolled concurrent workloads.
8. Do not claim an algorithmic fixture PASS proves a real production performance improvement. Every report must distinguish `DECLARED`, `ADOPTED`, `REACHABLE_PRODUCTION`, `EXECUTED_PRODUCTION`, `MEASURED`, `BENEFICIAL`, and `PROMOTED`, with a typed explanation for `BLOCKED` or `INCONCLUSIVE`.
9. No infinite work loops. Run bounded cycles with durable checkpoints, stopping on verified closure or a concrete blocker. If stuck, leave honest machine-readable evidence with an exact blocker and next change; do **not** report closure.

## 1. Baseline facts to verify, not blindly assume

At inspected commit `860d61a`, 13 mechanisms were registered and algorithmically evidenced. Only `seagym_update_validation` had a real first-party phase-work builder; 11 other WORK mechanisms had only source bindings. The normal `POST /api/collective/innovation/cycle` path accepted a `work_request` but supplied no provenance-bound `RuntimeContext` or `research_work_bindings`; normal heartbeat/chat callers likewise supplied none. Thus operator harnesses could dispatch SEAGym but normal production invocation could not dispatch the research work. `ADAPTIVE` was declared but not promoted. The committed benchmark had a fixture-based correctness gain, not a proven live-model gain.

At start, produce a **live delta inventory** using current HEAD (commit, working-tree status, list of 12 WORK IDs, existing builders, real input producers, production callers, eligible runnable mechanisms, schema/evidence revisions, policy state). If other agents have closed a task, verify and mark it retained rather than rewriting it.

## 2. Exact mechanism completion matrix

Use the original `MECHANISM_MATRIX.md` as the authoritative inventory; its paths are relative to `tools/doubletake_evolve/research_assimilation/` except controller components. For **each** WORK ID below, implement a narrow executable builder inside `runtime_bindings.py` (`_WORK_BUILDERS`) backed by its **actual first-party adapter**. Implement or reuse a real typed input producer using the declared `(kind, owner)` references. Never satisfy a requirement by inserting a synthetic constant.

| ID | First-party owner | Real input records to locate/create through governed owner | Expected outcome |
|---|---|---|---|
| `seagym_update_validation` | `seagym_adapter.py` / `UpdateValidationLoop` | `benchmark_result@innovation`, `frozen_task_set@innovation`, `evaluator@innovation` | Preserve existing builder; connect to real production producer and matched frozen baseline/evaluator |
| `ace_knowledge_consolidation` | `ace_adapter.py` / `Curator` | `reflection@knowledge`, `playbook_snapshot@knowledge` | Assessed/traceable consolidation proposal, never silently overwrite knowledge |
| `evolver_experience_distillation` | `evolver_adapter.py` / `ExperienceDistiller` | `execution_trajectory@outcomes` | Distilled evidence linked to actual completed trajectory |
| `dgm_evolutionary_lineage` | `dgm_adapter.py` / `DGMAdapter` | `candidate_proposal@innovation`, `evaluator@innovation` | Versioned lineage and evaluated proposal, no unapproved self-modification |
| `gepa_reflective_optimization` | `gepa_adapter.py` / `GEPAAdapter` | `candidate@innovation`, `evaluation_examples@innovation`, `feedback@innovation` | Measured/refusable optimization candidate, frozen comparison |
| `voyager_curriculum_discovery` | `voyager_adapter.py` / `CurriculumPlanner` | `capability_gap@capabilities`, `task_verifier@innovation` | Verifiable curriculum task and capability-gap lineage |
| `alphaevolve_executable_certification` | `alphaevolve_adapter.py` / `ConstructionCertifier` | `construction_candidate@innovation`, `correctness_oracle@innovation`, `baseline@innovation` | Independent correctness/cost verification, not autonomous unsafe execution |
| `poet_boundary_challenge_generation` | `poet_adapter.py` / `BoundaryChallengeGenerator` | `capability_frontier@capabilities`, `challenge_environment@innovation` | Novel bounded challenge with a verifier and provenance |
| `continual_skill_evaluation` | `continual_skill_adapter.py` / `ContinualSkillEvaluator` | `skill_candidate@skills`, `task_sequence@innovation` | Retention/regression evidence over actual candidate and task sequence |
| `skillevol_frozen_deployment` | `skillevolbench_adapter.py` / `SkillEvolutionEvaluator` | `skill_candidate@skills`, `deployment_task_set@innovation` | Frozen holdout/deployment evaluation, not in-sample substitution |
| `evoagentx_workflow_evolution` | `evoagentx_adapter.py` / `WorkflowEvolution` | `workflow_graph@workflows`, `evaluator@innovation` | Measured workflow variant under existing execution authority |
| `theory_of_agent_placement` | `theory_of_agent_adapter.py` / `ArchitecturePlacementEvaluator` | `placement_decision@capabilities`, `placement_options@innovation` | Auditable placement decision against real options/constraints |

`adaptive_operator_selection`: retain policy-service classification in `collective_innovation/operator_selection.py`; verify pressure allocation and existing independent evidence. **Do not** add it to `_WORK_BUILDERS`.

For each WORK adapter explicitly implement and test: real upstream source, typed record and validation, provenance (stable identifier + content digest + owner), builder factory, bounded `work(cap)` invocation, measured evidence/refusal, idempotent replay, effect/side-effect boundary, and rollback or no-commit on rejection. Builders must invoke real methods on these owner classes; wrapping a `NOT_RUN` result is **not** adoption.

## 3. Ordered implementation tasks and definitions of done

### D01 — Inventory and guardrails (first)
**Inspect:** `AGENTS.md`; both operator docs; registry and `runtime_bindings.py`; `collective_innovation/mechanism_runtime.py`, `collective_innovation/innovation.py`, `collective_innovation/evolution_policy.py`; API/heartbeat/chat call sites; associated tests and evidence generators.

**Change:** Write a small machine-readable initial delta manifest in `reports/research_assimilation/operational_closure/` enumerating each of the 13 IDs and the seven states (declared/adopted/producer available/production reachable/executed/measured/promoted), with source references and deficits. Reuse any existing reporting infrastructure; no redundant permanent registry.

**DoD:** all 13 identifiers accounted for; exact current commit recorded; every deficit traceable to a file/function/test; statuses determined from live code rather than aspirational docs; existing baseline verifiers pass or precise pre-existing failures recorded.

### D02 — Real producer and provenance bridge
**Inspect/change likely:** `tools/doubletake_evolve/research_assimilation/runtime_inputs.py`, `runtime_bindings.py`; first-party owner modules for capabilities, outcomes, skills, knowledge, workflow, and innovation; `collective_innovation/mechanism_runtime.py`. Reuse existing durable ledgers and records before adding a new bridge.

**Implement:** a bounded, in-process **first-party-only** context assembler that retrieves authorized existing records from their real owners and constructs `RuntimeContext`, `SourceReference`, and mechanism-specific typed builder inputs. Confirm source digests from actual persisted content; reject absent, stale, untrusted, contradictory, unauthorized or cross-run references. Do not expose arbitrary client-supplied `trusted=true` or caller-provided executable callables over HTTP. A chain producer may supply downstream inputs **only after** its own durable receipt/evidence digest exists and matches the declared chain edge.

**DoD:** each of the 12 WORK mechanisms has an actual producer path in normal deployment code, even if the current live workload has no qualifying records; true source records are discovered automatically; missing source produces `BLOCKED_INPUT`/typed reason without fabrication; tampering, replay and source-owner mismatch tests fail closed; T08 digests still verify.

### D03 — Adopt the remaining 11 adapters
**Change:** `_WORK_BUILDERS` in `runtime_bindings.py` and the respective existing `*_adapter.py` files only where necessary. Implement one adapter at a time, preserving its own semantics and score/evidence model. Use reusable typed error handling where warranted, but do not hide distinct refusal reasons behind a catch-all.

**DoD:** `work_builder_ids()` contains **exactly 12** WORK IDs, never the allocator; `work_builder_defects()` returns `[]`; each callable invokes the real owner implementation on valid first-party inputs and emits evidence with bounded `work_units` and explicit `opportunities`; tests prove beneficial, neutral, harmful/rejected, invalid/missing baseline, changed evaluator, cap budget and exception/refusal paths as applicable. No builder succeeds solely because it was instantiated.

### D04 — Connect normal production ingress and scheduler
**Inspect/change likely:** `collective_innovation/innovation.py` (`CollectiveService.innovation_phase_cycle`), actual automatic cycle initiators, and `tools/doubletake_evolve/api/` innovation route handlers. Locate the exact call sites through code search; do not guess HTTP handler filenames.

**Implement:** an internal trusted integration point that (a) obtains real sources, (b) constructs authorized context/bindings, (c) invokes existing governed `innovation_phase_cycle`, (d) persists receipts and inspectable statuses. Wire this through the **actual normal autonomous/heartbeat/chat path** as appropriate to current design; ensure ordinary eligible work can run without operator test harness injections. Keep external HTTP request schema restricted to `work_request`; any needed privileged context must be assembled internally after auth/CONDUCT checks, not accepted as unverified client assertions. Maintain one-cycle-per-request semantics, caps, fairness, idempotency and policy permissions.

**DoD:** a production-path integration test using the *actual* entrypoint (not calling the harness or seam in isolation) processes a first-party persisted qualifying input, executes at least one non-SEAGym mechanism, and produces a durable receipt visible in `/api/collective/innovation/status`. A normal request without available inputs records truthful blocked/no-op states. Dropped authority and input produce refusals. Existing innovation routes and ledger remain additive and backward compatible.

### D05 — Make genuine cross-mechanism chains work
**Use existing** `CHAIN_EDGES` / `chain_edge_defects()` and real receipt digests, including:
- EvolveR → ACE (research to knowledge)
- Voyager → SkillEvolBench (skill acquisition/retention)
- DGM → GEPA → SEAGym (candidate optimization/verification)

**DoD:** each chain is demonstrated via first-party source/receipt production with exact digest linkage, correct dependency ordering and no fabricated intermediate record. Independently mutate digest, drop producer, fail producer, change run identity, and reorder edges; each fault blocks consumer. Never claim a chain is production-ready based only on declared topology.

### D06 — Measured promotion and adaptive policy decision
**Inspect:** `collective_innovation/evolution_policy.py`, `policies.py`, `operator_selection.py`, `reports/three_phase_evolution/adaptive_allocation_evidence.json`.

**Implement:** a controlled, separately authorized path to *consider* policy promotion based on independent measured evidence; do **not** unconditionally promote `ADAPTIVE`. Compare `CURRENT` and `ADAPTIVE` under matching frozen workloads, same budgets and evaluator; require strict non-regression, content-bound evidence, and extant `promote_policy` authority. If evidence meets criteria and authority is explicitly present, promote through existing API and verify successor/rollback. If not, leave CURRENT active and identify why. Mechanism evaluation must never auto-promote its own unverified output.

**DoD:** promotion gate independently rejects fabricated PASS/evaluator drift/evidence drift; approved promotion is durable, status-visible and rollback-tested; otherwise produce an honest `NOT_PROMOTED` record. **Lack of a successful adaptive policy promotion is not itself a D01–D05 failure**, but the decision and evidence must be complete.

### D07 — Bounded production performance validation
**Implement:** comparisons with mechanisms disabled/enabled on frozen real first-party workloads where such workloads exist, with matching model/provider/evaluator/task set/seeds where applicable. Evaluate functional correctness, solved tasks, reliability, regression, latency/cost, and resource use; identify which claims are deterministic fixture-only versus authentic production/model workload. No fabricated samples and no unsupported numeric gains. Isolate pilot runs; retain full provenance.

**DoD:** a re-derivable benchmark and production execution report with explicit sample sizes, baselines, deltas, cost/reliability, refusals and confidence limitations. Any mechanism with insufficient real data must remain `NOT_MEASURED`, not `BENEFICIAL`. A real negative result must be retained, and the mechanism must not be promoted on that result. Code integration can be complete while a *gain claim* remains unproven; report them separately.

### D08 — Full verification, closure proof, docs
**Change:** extend existing acceptance, benchmark, participation and status verifiers rather than replacing them. Update docs and matrix from authoritative runtime evidence. Add a new `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json` plus an **independent `--verify`** generator/verifier in `tools/doubletake_evolve/research_assimilation/` that derives its claims from current committed code, first-party entrypoint tests, runtime evidence and measured-surface digests; make it collectable under default pytest.

**DoD:** all D01–D05 operational gates pass with 12/12 builders and 12/12 real producer paths, production invocation, honest receipts, three tested real chains, no regression, and no unhandled blockers; D06 policy decision and D07 gain qualifications explicitly recorded. New closure verifier detects false adoption, missing ingress, fake executions, missing producer, forged benefits, changed input digest, missing authority, broken rollback and missing chain evidence. Documentation matches verified deployment capabilities; not merely a test fixture.

## 4. Required tests and adversarial checks

Write focused unit, service integration, and first-party production-entry tests. At minimum:

1. Coverage: 12 WORK mechanisms have factories; allocator has none; binding ownership and pressure registry still agree.
2. Per-mechanism: real adapter invocation, preserved evaluator/inputs, beneficial/neutral/harmful/blocked when applicable, bounded work accounting.
3. Real input: valid persisted source, missing source, stale source, forged `trusted`, digest mutation, owner mismatch, incomplete chain, invalid authority, changed run ID.
4. Replay: same `(run_id, input digest, policy)` gives identical receipt without repeating effects; changed input with reused run ID refuses; restart recovers state.
5. Production: authenticated/CONDUCT-checked route or genuine automatic owner path produces a research work receipt without harness injection; HTTP never accepts code/callables or arbitrary source-trust assertions.
6. Composition: all three chain scenarios consume real persisted predecessor receipts, and negative dependency mutations fail.
7. Gate integrity: mutation tests must prove that removing a builder, disconnecting production injection, forcing constant PASS, or forging gain **fails** relevant tests/verifier (non-vacuity).
8. Isolation: no foreign code is run in the DT process; no bypass of host guard, resource policy, capability approval or existing enterprise security boundaries.
9. Backward compatibility: innovation ledger, old HTTP route contract, existing status fields, existing SEAGym behavior, existing evidence verifiers and active policy reading survive.

All existing baseline commands remain mandatory (under host guard):

```sh
PYTHONPATH=.:tools python3 tools/doubletake_evolve/collective_innovation/mechanism_participation.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/evidence_package.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_acceptance.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_benchmarks.py --verify
```

Use `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` for **each** invocation; the commands above are the inner commands, not exceptions to the guard. Regenerate committed records only using existing content-binding/retention rules, after source commits are landed and retained on the authoritative remote. Do not force a stale verifier PASS by weakening its measured surface.

## 5. Closure truth table and stopping conditions

`FINAL_CLOSURE.json` must include current retained commit, digests, per-mechanism evidence/paths/states, production entrypoint and source identity, tests invoked with exit status and bounded telemetry, chain receipts, baseline and measured deltas, policy promotion decision, and all unresolved blockers.

- `OPERATIONAL_INTEGRATION_COMPLETE` **only if** D01–D05 and D08 all independently PASS, all twelve real phase-work builders exist, real first-party input production and routine execution path work end-to-end, evidence is durable and re-verifiable, and required regressions/host guard checks are green. D06 is resolved as either authorized evidenced promotion or honestly documented retention of CURRENT; D07's measurement coverage is explicitly qualified.
- `OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN` may describe the above engineering closure when no reliable live-model gain is established. Do **not** report a live benefit without evidence.
- `PARTIAL_WITH_BLOCKERS` if any of the twelve cannot be connected to an actual upstream owner, production path does not invoke work, chain is only a fixture, tests fail, evidence binding breaks, or permissions are absent. Name the exact blocker and retain all green work.
- `INCONCLUSIVE` for missing live data/provider or resource interruptions where the relevant property cannot be verified. Do not infer PASS.

No per-mechanism need to execute spontaneously when no suitable task exists: **eligibility and non-fabricated conditional participation** are the target. However, all 12 must be proven executable via the genuine production route using real first-party persisted eligible records in controlled tests. Keep runtime caps and approval gates intact.

## 6. Execution cadence and deliverables

Work in this order: `D01 → D02 → D03 → D04 → D05 → D06 → D07 → D08`, iterating on localized failures. Before each change check for concurrent updates to the same paths and adopt newer verified work. After each bounded checkpoint publish: precise completed tasks, file/commit refs, commands and outcomes, changes in builder/producer counts, production executions, blockers and next delta. Never conceal partial status behind a generic green summary. Make small logical commits and push according to repository policy. Avoid deleting existing reports or modifying unrelated missions.

**Final output:**

1. A concise exact completion table for D01–D08 with `PASS / FAIL / BLOCKED / INCONCLUSIVE` and references.
2. A 13-row mechanism table showing 12 WORK + 1 POLICY SERVICE, with producer, builder, production reachability, last truthful execution status and evidence link.
3. Retained commit/branch, provenance, source and test commands/results, benchmark limitations, policy decision, rollback proof, and remaining blockers (if any).
4. `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json` with independent verifier; updated canonical operator documentation and machine-derived mechanism matrix.
5. An unequivocal closure verdict from Section 5. **Never call an unexecuted binding operational integration.**

**Start immediately from the current live repo. Do not ask for reapproval of implementation details already authorized by this mission; do not weaken execution, trust or promotion gates to manufacture closure.**
