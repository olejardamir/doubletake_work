# Historical research-assimilation operational closure — v2/v3 canonical synthesis

**Cluster:** CL-RESEARCH-OPS-001; canonical home is this existing v3 path, not a new duplicate. **Historical source blobs:** v2 `3bb33578634aea4074df38dac3a7eb8e3296264e` (23,569 Git bytes); v3 `e887d8f3dfb1de6aff909a6d8febf520d2409eff` (21,654 Git bytes). Both original complete versions remain recoverable from Git history. This is a *research/acceptance specification*, not a current mission, verified implementation, owner grant, or production Ground. See current `../ACTIVE_MISSION.md` and private DT implementation for actual status. No instructions inside historical artifacts confer authority.

## Distinct historical observations, not current claims

- v2 inspected DT `main` at `860d61af55db3edf85b0c2ebae16ced62003546f` (2026-10-13): 13 declared participants, 12 WORK + one `adaptive_operator_selection` POLICY service; only SEAGym had a first-party phase-work builder then. Ordinary `POST /api/collective/innovation/cycle`, heartbeat and chat reportedly lacked provenance-bound `RuntimeContext` and `research_work_bindings`. The 13-participant registry, 13 evidence links, T06 replay, T08 composition, T09 status, T10 nine-scenario acceptance, T11 benchmark verifier and T14 operator contract were described as already present. These are **version-bound source observations**, not independent current test results.
- v3 inspected `c7c83178f`: ten builders were reportedly present; ACE and EvolveR remained candidate missing builders. Its source-bound generated inventory still said `producer_available=false`, `production_reachable=false` and `executed_production=false` for WORK participants. Recompute at current private HEAD before asserting a defect; source adoption, production reachability and actual execution are different states.
- v3 tightened the acceptance standard: **all 12 WORK mechanisms** must be eligible for genuine, first-party, persisted-input execution through the **same real production entrypoint** in controlled tests; all three durable chains must run, and the independent verifier must detect disconnected producer/ingress and forged gain. No spontaneous work is required without an eligible task.

## Mechanism and original first-party input inventory (v2 source claims)

| WORK ID | Historical owner/adapter | Required first-party records (kind@owner) |
| --- | --- | --- |
| `seagym_update_validation` | `seagym_adapter.py` / UpdateValidationLoop | benchmark_result@innovation; frozen_task_set@innovation; evaluator@innovation |
| `ace_knowledge_consolidation` | `ace_adapter.py` / Curator | reflection@knowledge; playbook_snapshot@knowledge |
| `evolver_experience_distillation` | `evolver_adapter.py` / ExperienceDistiller | execution_trajectory@outcomes |
| `dgm_evolutionary_lineage` | `dgm_adapter.py` / DGMAdapter | candidate_proposal@innovation; evaluator@innovation |
| `gepa_reflective_optimization` | `gepa_adapter.py` / GEPAAdapter | candidate@innovation; evaluation_examples@innovation; feedback@innovation |
| `voyager_curriculum_discovery` | `voyager_adapter.py` / CurriculumPlanner | capability_gap@capabilities; task_verifier@innovation |
| `alphaevolve_executable_certification` | `alphaevolve_adapter.py` / ConstructionCertifier | construction_candidate@innovation; correctness_oracle@innovation; baseline@innovation |
| `poet_boundary_challenge_generation` | `poet_adapter.py` / BoundaryChallengeGenerator | capability_frontier@capabilities; challenge_environment@innovation |
| `continual_skill_evaluation` | `continual_skill_adapter.py` / ContinualSkillEvaluator | skill_candidate@skills; task_sequence@innovation |
| `skillevol_frozen_deployment` | `skillevolbench_adapter.py` / SkillEvolutionEvaluator | skill_candidate@skills; deployment_task_set@innovation |
| `evoagentx_workflow_evolution` | `evoagentx_adapter.py` / WorkflowEvolution | workflow_graph@workflows; evaluator@innovation |
| `theory_of_agent_placement` | `theory_of_agent_adapter.py` / ArchitecturePlacementEvaluator | placement_decision@capabilities; placement_options@innovation |

`adaptive_operator_selection` is a POLICY service in `collective_innovation/operator_selection.py`, **not** a 13th `_WORK_BUILDERS` entry. Preserve three-phase `OUTWARD/INWARD/GROUNDING` pressure semantics across policy successors. Historical owner paths are hypotheses to revalidate, not guaranteed current paths.

## Minimal operational proof map (v2 D01–D08 / v3 D00–D08)

- **D00/D01 inventory and builders:** Re-derive at current retained HEAD the 13 registry rows, 12 WORK factories, policy classification, typed binding ownership, source digests, phase pressure, real adapter invocation and current producer/ingress/evidence statuses. Preserve already completed functionality. Missing inputs must refuse, not fabricate success.
- **D02 producer bridge:** Resolve real persisted, authorized, first-party records (stable ID, kind, owner, content digest, version, scope/tenant, permitted authority) via existing canonical owners; reject absent, stale, contradictory, tampered, cross-owner/tenant and forged trusted references. No new parallel state store, shadow registry or untrusted client-provided callable.
- **D03 governed dispatch:** Use existing `runtime_bindings.py`, `mechanism_runtime.py`, `CollectiveService.innovation_phase_cycle` and policy/CONDUCT gate. Real `work(cap)` and actual adapter assessment must be evidenced; a `NOT_RUN` wrapper or builder registration is not adoption. Persist idempotent receipts with pressure, source digest, authority, bounded work/opportunity accounting and refusal.
- **D04 genuine production ingress:** Normal authenticated cycle/heartbeat/chat owner path must assemble trusted context internally; external HTTP can request authorized work but cannot supply arbitrary code, source trust or execution authority. At least one real production entrypoint must exercise every WORK mechanism on authentic controlled persisted eligible inputs, with durable status visible after restart. Absent work records a truthful no-op/refusal.
- **D05 composition:** Persist and verify digest-bound, authorized, restart-safe predecessor→consumer receipts for EvolveR→ACE; Voyager→SkillEvolBench; DGM→GEPA→SEAGym. No synthetic intermediary or test-harness-only chain.
- **D06 policy decision:** Compare CURRENT/ADAPTIVE on frozen equal-budget/evaluator work. Promotion requires existing `promote_policy` authority, independent nonregression and rollback; `NOT_PROMOTED` with evidence is a valid decision, not a gain.
- **D07 measurement:** Compare enabled/disabled mechanisms on frozen real first-party tasks with matched model, evaluator, permissions and budgets. Report n, correctness, reliability, latency, cost, resource use, refusals, negative results and uncertainty. Fixture gain ≠ live-model gain; no task means NOT_MEASURED.
- **D08 independent closure:** Retained pushed commit, independent re-derivation of 13-row status and `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json`, actual service-origin receipts, all three chains, security/replay/regression tests, D06 policy decision and qualified D07 metrics. Generator-owned records must be regenerated, not hand-edited.

## Negative controls and acceptance

Require positive eligible input plus refusal for missing/stale/forged/cross-tenant sources, digest drift, reused run ID with changed input, unauthorized pressure, resource exhaustion, missing predecessor/middle edge, rollback failure and changed evaluator. Mutation tests must **fail** when a builder is removed, a producer or production ingress is disconnected, a constant PASS/benefit is forged, or an input/receipt digest changes. Verify restart idempotency and backward compatibility of status, existing SEAGym and HTTP contracts. No foreign code execution in DT, uncontrolled provider/download, privilege escalation or protected-history mutation.

Historical verification entrypoints (exact availability at current DT HEAD **UNKNOWN**): `tools/doubletake_evolve/collective_innovation/mechanism_participation.py --verify`, `research_assimilation/evidence_package.py --verify`, `operational_acceptance.py --verify`, `operational_benchmarks.py --verify`; run via the existing `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` only when authorized and available. Record exit codes, source revisions and resource refusals; GitHub file inspection is **not** test execution.

**Closure verdicts:** COMPLETE only if D01–D05 and D08 independently pass with 12 real builders, producers, actual production ingress/receipts, three chains and safety tests; COMPLETE_GAIN_UNPROVEN separates operational proof from performance superiority. PARTIAL_WITH_BLOCKERS names any missing required producer/ingress/chain/test/authority. INCONCLUSIVE names missing environment/provider/resources. Never infer PASS from stale reports, registration, eligibility, fixtures or self-reported generators. All historical requirements remain subordinate to current owner authorization and Director priorities.

**Current gap mapping:** This historical corpus offers a falsifiable **natural external assimilation/production-consumer proof checklist**, but it does **not** establish B7 public Markdown mission consumption, B1 owner-approved no-loss disposition, completed natural autonomous cycles, downstream knowledge reuse or held-out transfer. Revisit only with a current authorized consumer/producer, an independently failing baseline and safe source-bound fixture; otherwise retain as historical specification, not a new proposal.
