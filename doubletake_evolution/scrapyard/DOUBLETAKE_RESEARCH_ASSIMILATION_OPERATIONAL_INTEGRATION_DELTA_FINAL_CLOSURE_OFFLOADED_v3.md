# DOUBLETAKE RESEARCH ASSIMILATION — OPERATIONAL INTEGRATION DELTA FINAL CLOSURE (OFFLOADED v3)

**Target:** `olejardamir/DT` (DoubleTake only; not Agent_X).  
**Mode:** execute remaining engineering deltas, retain green work, evidence-first, bounded workloads.  
**Reference inspected:** `main` commits `c7c83178f4aff166325df6503506c4c997eeb243` and `242b4681b908bcbb206a25eb5c2b0165d95421f5` on 2026-10-14. **These are historical observations, not mandatory HEAD.**  
**Supersedes:** `DOUBLETAKE_RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION_DELTA_FINAL_CLOSURE_OFFLOADED_v2.md` as an execution driver; **inherits every unmet acceptance criterion and stronger safety restriction of v2**. If v2 is available, load it. Otherwise use the full requirements below and the repository's authoritative mission records.  
**Objective:** achieve verifiable end-to-end operational participation by all **12 WORK mechanisms** and preserve the **1 POLICY SERVICE**, without confusing declarations, synthetic fixture passes, adoption, production reachability, execution, or measured benefit.

## 0. Non-negotiable rules

1. First read `AGENTS.md`, `ACTIVE_WORK` if present, `docs/RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION.md`, `reports/research_assimilation/operational_closure/MECHANISM_MATRIX.md`, `reports/research_assimilation/operational_closure/{DELTA_INVENTORY,TEST_RESULTS,BENCHMARKS}.json`, `tools/doubletake_evolve/research_assimilation/runtime_bindings.py`, `tools/doubletake_evolve/collective_innovation/mechanism_runtime.py`, the governing policies, and v2 if accessible. Inspect actual HEAD, `git status`, remote tracking, and active writers before modifying files. **Code and reproducible evidence outrank stale prose, including this prompt.**
2. Preserve the working 13-participant registry, 13 evidence links, T06 replay integrity, T08 composition integrity, T09 status, T10 nine-scenario acceptance, T11 verifier, T14 operator contract, SEAGym, and any subsequently completed integrations. Do not recreate or re-run work solely to claim activity. If a prior item is now broken, repair its smallest demonstrable defect.
3. Follow the authorized **shared `main` policy** in `AGENTS.md`. Do not create development branches or use destructive reset, rebase, squash, force push, or clean that endangers others' work. Coordinate writes to common files, particularly generated reports. A detached disposable verification worktree is allowed only if the host policy permits it, and never for development or untracked state destruction.
4. Every test, build, evidence generator, and experiment must be invoked under `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>`. Run focused workloads sequentially, respecting declared CPU/memory/time and concurrency caps. Never bypass the host guard; refused, timed-out, OOM, and unavailable-provider runs are **BLOCKED/INCONCLUSIVE**, not PASS.
5. Keep the **single existing authoritative contract/binding surface**. `adaptive_operator_selection` is a **policy service**, not a 13th builder. Preserve pressure semantics `OUTWARD`, `INWARD`, `GROUNDING`, including future verified policy replacements. Do not wire mechanism behavior to brittle private policy names.
6. No fabricated first-party inputs, dummy producers, test-only production adapters, fake scores, self-reported PASS, or shadow ingress. Eligibility does not authorize execution; evaluation does not authorize promotion. Preserve CONDUCT/Borg seals, enterprise security controls, trust boundaries, explicit permissions, provenance, idempotence, rollback, and code-execution isolation. Do not execute third-party source inside the main DT process; no automatic model downloads or new paid dependencies.
7. **Never claim live-model performance gain from deterministic fixture/algorithmic evidence.** Do not change benchmark definitions, acceptance thresholds, schemas, or test assertions just to manufacture green status. Schema migrations must be deliberate, backwards-compatible where required, and separately tested.
8. All initial counts below are **reference observations only**; recompute at live HEAD. Report generators may be behind code commits; stale records are not ground truth. Never overwrite canonical generated JSON by hand.

## 1. Baseline and delta discovery (D00)

Read the current registry and calculate from actual code:

- Exactly 13 declared mechanisms, 12 WORK and 1 POLICY SERVICE, with digest-bound owner paths, inputs, authority, pressures and evidence.
- Existing builder IDs vs the canonical 12 WORK IDs. At inspected `c7c83178f` the runtime source exported ten builder functions: SEAGym, Theory of Agent, DGM, GEPA, Voyager, continual skill evaluation, SkillEvol frozen deployment, EvoAgentX, AlphaEvolve, POET. **ACE knowledge consolidation and EvolveR experience distillation appeared to be the remaining two builders**; verify rather than assume.
- The inspected generated inventory was bound to source `c7c83178f`; it reported `producer_available=false`, `production_reachable=false`, and `executed_production=false` for WORK participants (with policy handled separately). Therefore builder adoption does **not** complete D02, D04, or D05. Verify whether subsequent commits changed those states.
- Prior operational evidence generators and their durable commit/digest bindings; status and production API shape; three composition scenarios; current promotion policy; measurement surface; latest test outcomes.

Produce a machine-readable and human-readable **delta ledger** with row fields: `criterion`, `mechanism_id`, `expected`, `actual`, `source_file`, `test`, `evidence`, `verdict`, `owner`, `next_minimal_change`. Set `PASS` only after rederivation on retained code; otherwise `FAIL`, `BLOCKED`, or `INCONCLUSIVE`. If all criteria are already green, skip implementation and proceed straight to independent closure verification. On changed HEAD, rebase the logical delta **by inspection**, never by destructive Git operation.

## 2. Delta sequence — exact implementation boundaries and definitions of done

### D01 — Complete the twelve first-party phase-work builders

**Where:** `tools/doubletake_evolve/research_assimilation/runtime_bindings.py`, the existing concrete adapters (`ace_adapter.py`, `evolver_adapter.py`, others only if actually missing), and corresponding service-origin mechanism tests.

**How:** Compare `work_builder_ids()` with the 12 registry WORK IDs. For each genuinely missing builder (expected ACE / EvolveR at reference HEAD), implement the narrow typed callable using the real adapter and existing `BindingError` conventions; validate real first-party input types and nonempty provenance, honor caps/authority, refuse unavailable inputs, and return actual adapter assessment or explicit typed nonexecution. Register it once in `_WORK_BUILDERS`, export it following established conventions, and do not fabricate a reflection, playbook, trajectory, score, or gain. The function must be dispatched by `CollectiveService.innovation_phase_cycle` rather than asserted through a direct adapter-only unit test. Preserve already adopted functions without rewriting them.

**DoD:** exactly 12 unique WORK builder IDs; owner/binding/pressure assertions pass; each builder is reachable through the real service phase cycle on an authentic controlled first-party eligible input; missing/malformed inputs produce a typed refusal; work caps and unauthorized contexts prevent execution; a binding-removal mutation fails tests. Builder existence alone is *not* D02/D04/D05 closure.

### D02 — First-party provenance-bound input producers

**Where:** the existing research runtime seam and the actual first-party ownership surfaces for knowledge/reflections, outcomes/trajectories, capabilities, skills, innovation/evaluations, and workflows. Determine precise producer-owner module names from current code; do not invent parallel ownership stores. Extend `runtime_bindings.py` only if it is the correct existing seam.

**How:** Add a narrow `produce_references`-equivalent bridge (name may follow established code style) that resolves each declared `InputRequirement` by retrieving **existing persisted, authorized, source-owned records**. Input provenance must contain stable record ID, owner, kind, content digest, creation/version marker, authority/tenant context as applicable, and replay-safe reference; do not accept caller-supplied untrusted owner claims. Validate freshness, integrity, permitted cross-owner access, optionality, and schema. Return a structured `NOT_ELIGIBLE`/`NOT_AVAILABLE` with reason when the source is absent; never synthesize it. No manual callable injection is allowed as a substitute for an automatic production producer.

**DoD:** each of 12 WORK mechanisms has a concrete producer mapping from declared requirements to real first-party record owner(s), with successful retrieval on a persisted, independently generated eligible record and deterministic denial on absent, stale, corrupt, cross-tenant, or unauthorized data. Every producer claim has a service-origin test and durable evidence. A mechanism without an authentic owner is `BLOCKED`, not silently treated as complete.

### D03 — Governed work construction, dispatch and provenance

**Where:** existing `mechanism_runtime.py`, phase-cycle integration, `runtime_bindings.py`, existing phase-work dispatch and evidence ledger.

**How:** Take D02 retrieved references, validate the input contract, resolve the one registered first-party builder, and dispatch through the active three-phase policy and `CollectiveService.innovation_phase_cycle` under explicit authorization, bounded caps, provenance and idempotence. Maintain separation between `DECLARED`, `BOUND`, `ADOPTED`, `ELIGIBLE`, `DISPATCHED`, `EXECUTED`, `ASSESSED`, and `PROMOTED`; nonexecution is not success. Keep mechanism-pressure matching contract-based so successor policies can exercise the same mechanisms. Record consent/authority, source IDs/digests, pressure, dispatch request, refusal or result, and evidence linkage.

**DoD:** real inputs cause actual registered adapter execution from the service origin under an eligible pressure; disabled pressure, insufficient authority, missing producer, malformed data, repeated replay, and capacity exhaustion cannot execute or promote. Removing a builder or disconnecting producer injection causes the corresponding real-service test to fail.

### D04 — Genuine production ingress and routine conditional participation

**Where:** the pre-existing authenticated/CONDUCT-gated production service entrypoints, background evolution cycle, and operational status surfaces identified by code inspection. Do not create a second HTTP API or simulation service.

**How:** Hook the **real existing** production cycle to source-owned input production, D03 dispatch, and durable recording. HTTP callers may request an authorized operation using safe identifiers and options; they may **not** submit raw code, Python callables, arbitrary source identity claims, bypass permissions, or demand execution without eligible records. Keep legacy endpoint behavior and status fields. Automatic participation is conditional on a real work opportunity and available authorization; never require spontaneous execution in the absence of tasks.

**DoD:** at least one authentic production entrypoint reaches the registered service mechanism route with no test-harness callable injection. In controlled integration acceptance, every one of the 12 WORK mechanisms can be exercised **through that same real production route** when independently persisted qualifying input exists; policy service participates through its actual allocator route. The result/refusal/status and execution receipt are observable and survive restart/reload. Mutation removing ingress wiring fails the tests. Absent provider or absent qualifying production data is explicitly recorded as BLOCKED/INCONCLUSIVE.

### D05 — Durable cross-mechanism composition and independent proof

**Where:** canonical `CHAIN_EDGES` in `runtime_bindings.py`, existing stores, composition/acceptance tests, and operational closure evidence.

**How:** Execute the existing three declared scenarios using durable predecessor outputs from real service-origin calls: (a) `evolver_experience_distillation → ace_knowledge_consolidation`; (b) `voyager_curriculum_discovery → skillevol_frozen_deployment`; (c) `dgm_evolutionary_lineage → gepa_reflective_optimization → seagym_update_validation`. Consumer inputs must resolve and validate their predecessor's actual persisted record identity and content digest, not string similarity, in-memory test-only handoff, or invented records. Support retry/restart and correct idempotence across the chain. Mutate predecessor digest/owner/authority/type and verify refusal.

**DoD:** all three scenarios execute through real service-origin routes with durable receipts and independent replay verification; missing predecessor, wrong digest, wrong owner, stale reference, unauthorized chain, and broken middle edge fail closed. No fabricated external source or production gain.

### D06 — Adaptive policy promotion decision (separate from engineering adoption)

**Where:** `collective_innovation/{evolution_policy,policies,operator_selection}.py` as applicable, existing policy authority/promotion API, `reports/three_phase_evolution/adaptive_allocation_evidence.json`, and durable promotion decision records.

**How:** Compare CURRENT vs ADAPTIVE only on frozen, equivalently budgeted workloads with the same evaluator and independently checkable measured evidence. Test drift/fabrication/nonregression gates. Use the existing `promote_policy` authorization route only if criteria and explicit authority permit. Otherwise retain CURRENT and write `NOT_PROMOTED` with precise reason. Preserve successor and rollback controls; do not use mechanism success as promotion authority.

**DoD:** independent verifier rejects forged PASS, changed evaluator, changed content/budget and unsupported gains; policy decision is durable and status-visible. Authorized promotion, if performed, includes tested rollback. `NOT_PROMOTED` with an honest reason may satisfy D06 decision closure but never counts as promoted.

### D07 — Bounded real-workload measurement with honest uncertainty

**Where:** existing `operational_benchmarks.py`, benchmark report generator, and host-guarded workload runners.

**How:** Run disabled/enabled ablations on matched **real first-party** frozen workloads if available, matching evaluator, provider/model, task IDs, permissions, seed where applicable, budgets, and resource limits. Capture task correctness, completions, reliability/refusals, latency, cost and resource use, sample size, provenance, variance/confidence limitations, regressions. Distinguish deterministic algorithmic fixtures from real model/production evaluation. Preserve negative results. Where unavailable, record `NOT_MEASURED` or `INCONCLUSIVE`, not a numeric gain or BENEFICIAL claim.

**DoD:** content-bound, re-derivable benchmark report with clearly separated engineering-operation evidence and independently supported benefit claims. No unsupported claim of superiority; negative regression blocks that mechanism's promotion.

### D08 — Independent end-to-end verification and final records

**Where:** current acceptance, benchmark, registry/binding verification, operator docs, source-derived matrix, and `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json` with its **independent verifier**.

**How:** Re-run the canonical baseline commands listed below through the host workload wrapper. Add/retain complete tests for D01-D07, production route, all 13 rows, three chains, tenant/authority isolation, guards, policy promotion decision, rollback, and negative mutants (builder removal, producer disconnect, production ingress disconnect, forged gains/constant PASS, digest drift). Verify the canonical records from **retained pushed commits**, not only untracked or dirty worktree state. Resolve known report staleness by using established generators only; generator output must not conceal pending source changes. Update docs and mechanism matrix from code/records without contradicting them.

**DoD:** all verification commands exit 0 without guard bypass, all closure-required mutants are detected, records re-derive byte-for-byte or by canonical digest, all evidence links resolve, closure report names head/remote/inputs/verifier/version and residual uncertainty. If anything fails or cannot be exercised, emit an explicit noncomplete verdict.

## 3. Required verification commands

**Run each command individually** with `python3 tools/doubletake_evolve/runtime/host_workload.py --` prepended; preserve command/output/exit status, peak resource observations when available, HEAD and input digests:

```sh
PYTHONPATH=.:tools python3 tools/doubletake_evolve/collective_innovation/mechanism_participation.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/evidence_package.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_acceptance.py --verify
PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_benchmarks.py --verify
```

Locate and execute the actual existing test modules for every affected mechanism, complete phase cycle, production ingress, composition, authority, replay, status and independent closure verifier, using the same wrapper. Use `--help` or source inspection for exact generator flags, never guess a destructive command. If generator dependencies require clean retained HEAD, first commit/push source safely under `AGENTS.md`, then generate in an allowed isolated verification context bound to that retained commit; serialize final record writes. Afterwards independently verify the bound record matches its retained source surface. Do not mark generator self-report alone as independent acceptance.

## 4. Closure truth table (strict)

- **OPERATIONAL_INTEGRATION_COMPLETE:** D01–D05 and D08 PASS independently; all 12 actual builders, producers, conditional real ingress executions and persisted receipts established; all three chains pass; mandatory security/regression checks pass; D06 resolved truthfully and D07 coverage/limits disclosed.
- **OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN:** same engineering conditions as COMPLETE, but reliable live-model improvement not established. This is **not** a claim of performance superiority.
- **PARTIAL_WITH_BLOCKERS:** any requisite producer absent, genuine production path missing, any required participant/chain not demonstrated, failing verifier/security test, or authorized work unavailable. Preserve green evidence and specify blocker owner and next fix.
- **INCONCLUSIVE:** resource/provider/permission/environment conditions prevent independent verification; name unverified criteria. Do not infer PASS from prior green reports.

Do not count policy service as WORK. Do not count `measured` as `executed_production`, `adopted` as `production_reachable`, or `eligible` as `promoted`. Absence of suitable live tasks need not cause autonomous spontaneous execution; controlled *genuine production-route* demonstration with real persisted records is still mandatory for engineering closure.

## 5. Required output artifacts and completion report

1. Machine-readable D00 delta ledger and `D01`–`D08` criterion table with `PASS/FAIL/BLOCKED/INCONCLUSIVE`, proofs, exact files, test commands, exit codes, authoritative commit.
2. A 13-row mechanism table with 12 WORK + 1 POLICY SERVICE, input producer, builder, pressure, production route, actual service-origin result, durable evidence path, measured-benefit qualification, and `next_gap`.
3. `reports/research_assimilation/operational_closure/FINAL_CLOSURE.json` containing current retained source commit, binding/contract/report digests, evaluator/source identity, tests/host guard results, policy decision, rollback evidence, three chain receipts, provenance, baseline and measured deltas, and all unresolved blockers; plus its independent verifier.
4. Regenerated canonical source-bound inventory/acceptance/benchmark records and updated operator documentation; do not hand-edit generator-owned JSON.
5. Final concise execution summary listing precisely what changed in v3, preserved completed milestones, tests run and results, commit hashes, outstanding blockers and unequivocal closure verdict. If no code changes were needed, report why with independent verification.

## 6. Execution strategy, shared-repository safety and stop condition

Execute **D00 → smallest missing D01 → D02 → D03 → D04 → D05 → D06 → D07 → D08**. After every bounded logical edit, inspect concurrent writers and the latest remote HEAD; run relevant focused tests, commit only owned paths and push under current repo policy. Prefer small evidence-backed commits over sweeping rewrites. Preserve existing feature semantics and work across policy generations. Do not repeatedly regenerate reports while source is still moving. Repair a failing criterion and re-run just its dependent verification before full closure. Do not enter an uncontrolled infinite loop; persist explicit state for the next bounded iteration if work cannot finish within safe resource limits.

**Begin execution against the actual current DoubleTake repository. Do not ask for routine reapproval of authorized implementation steps. Never weaken permissions, tests, resource protections, or evidence requirements in order to declare closure.**
