# DOUBLETAKE — RESEARCH ASSIMILATION PRODUCTION INGRESS AND FINAL CLOSURE (OFFLOADED v4)

**Execution target:** `olejardamir/DT`, **not** Agent_X.  
**Purpose:** Finish **D04** for the remaining WORK mechanisms, then re-derive and close **D08**. Do **not** restart the v3 mission.  
**Reference repository observation:** GitHub `main` commit `ad5757462d4f` (2026-10-16 01:56 UTC). The canonical closure record was bound to `fcf6d485f13b`; at observation it reported `PARTIAL_WITH_BLOCKERS`, D01/D02/D03/D05/D06/D07 `PASS`, D04 `BLOCKED` (3/12 production-reachable), and consequently D08 `BLOCKED`. **This is a checkpoint, not a fixed HEAD or a license to overwrite newer work.**  
**Supersedes v3 only as the execution driver.** All stronger safety, trust, regression, and acceptance requirements of v3 and the repository's governing instructions remain binding. If v3 is available, treat it as a specification reference, not as an instruction to repeat green work.

## 0. Single objective and stop rule

Make **all 12 WORK mechanisms reachable and demonstrably executable via the existing genuine production ingress**, without caller-injected Python work, invented input records, or bypassed authority. Preserve `adaptive_operator_selection` as the separate POLICY SERVICE. Then regenerate the canonical committed records and independently verify a truthful final closure verdict.

**STOP SUCCESS** only when the independently generated `CRITERION_TABLE.json` reports D01–D08 `PASS` under their actual semantics; the final closure verifier accepts the reported outcome; all 12 WORK production routes and service-origin evidence pass; the three already completed durable chain scenarios still verify; and the records are committed/retained on authorized `main`. Lack of live-model benefit may still yield `OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN`, never a fabricated performance claim.

**STOP BLOCKED** only for a concrete external/permission/resource obstruction that cannot safely be resolved, with precise mechanism, input contract, owner, command, evidence, attempted lawful remedy, and remaining defect. Do not call blocked work complete. Do not spin forever or fabricate a source to force a pass.

## 1. Mandatory reconfirmation (read, do not reimplement)

Inspect the live `HEAD`, `git status`, `git log`, active writers, remote tracking, and these precise existing authorities:

- `AGENTS.md` and `ACTIVE_WORK` (shared `main` writer / workload policy).
- `tools/doubletake_evolve/collective_innovation/mechanism_runtime.py` — current `production_ingress`, governed service / phase-cycle dispatch and typed assemblers.
- `tools/doubletake_evolve/research_assimilation/runtime_bindings.py` — the single canonical 12 WORK / 1 POLICY SERVICE mapping; `INPUT_REQUIREMENTS`, `CHAIN_EDGES`, work builders.
- `tools/doubletake_evolve/research_assimilation/runtime_producers.py` and `runtime_inputs.py` — real persisted source resolution and provenance validation.
- `tools/doubletake_evolve/research_assimilation/operational_acceptance.py` and `test_operational_acceptance.py` — T10 service-origin integration receipts and negative tests.
- `tools/doubletake_evolve/research_assimilation/operational_delta_inventory.py` (or actual inventory generator), `criterion_table.py`, `mechanism_matrix.py`, `final_closure.py` and their tests.
- `reports/research_assimilation/operational_closure/{DELTA_INVENTORY,CRITERION_TABLE,MECHANISM_MATRIX,TEST_RESULTS,BENCHMARKS,PROMOTIONS,CHAIN_RECEIPTS,FINAL_CLOSURE}*` as applicable; the matrix is `.md`, most others `.json`.
- `docs/RESEARCH_ASSIMILATION_OPERATIONAL_INTEGRATION.md` for the current operator contract.

Before editing, produce a short, working-tree-local checklist derived from **current code and generated evidence**: each WORK mechanism, its exact registered builder, required typed input, source-owner persisted record, current assembler, route, service-origin test, and missing condition. If the latest repo has already closed D04 or D08, **skip implementation** and verify completion instead. Generated records may lag freshly landed source: inspect source and tests before trusting a stale count; never write a generated JSON by hand.

## 2. Exact D04 implementation queue — nine reference gaps

At the observed canonical inventory, exactly three WORK mechanisms were marked production-reachable: `evolver_experience_distillation`, `dgm_evolutionary_lineage`, and `gepa_reflective_optimization`. Preserve their existing proven ingress behavior. The nine remaining reference gaps were:

| ID | WORK mechanism | Declared input reference(s) | Concrete existing owner |
|---|---|---|---|
| D04-01 | `ace_knowledge_consolidation` | `reflection@knowledge`, `playbook_snapshot@knowledge` | `research_assimilation/ace_adapter.py` |
| D04-02 | `alphaevolve_executable_certification` | `construction_candidate@innovation`, `correctness_oracle@innovation`, `baseline@innovation` | `research_assimilation/alphaevolve_adapter.py` |
| D04-03 | `continual_skill_evaluation` | `skill_candidate@skills`, `task_sequence@innovation` | `research_assimilation/continual_skill_adapter.py` |
| D04-04 | `evoagentx_workflow_evolution` | `workflow_graph@workflows`, `evaluator@innovation` | `research_assimilation/evoagentx_adapter.py` |
| D04-05 | `poet_boundary_challenge_generation` | `capability_frontier@capabilities`, `challenge_environment@innovation` | `research_assimilation/poet_adapter.py` |
| D04-06 | `seagym_update_validation` | `benchmark_result@innovation`, `frozen_task_set@innovation`, `evaluator@innovation` | `research_assimilation/seagym_adapter.py` |
| D04-07 | `skillevol_frozen_deployment` | `skill_candidate@skills`, `deployment_task_set@innovation` | `research_assimilation/skillevolbench_adapter.py` |
| D04-08 | `theory_of_agent_placement` | `placement_decision@capabilities`, `placement_options@innovation` | `research_assimilation/theory_of_agent_adapter.py` |
| D04-09 | `voyager_curriculum_discovery` | `capability_gap@capabilities`, `task_verifier@innovation` | `research_assimilation/voyager_adapter.py` |

Paths above are relative to `tools/doubletake_evolve/`. **Treat this table as a reference delta, not a directive to recreate implementations that appeared after the reference commit.** Recompute the missing set from current code after every logical checkpoint. Do not include `adaptive_operator_selection` in the WORK queue.

### Required implementation for EACH still-missing mechanism

1. **Source contract:** In `runtime_bindings.py`, resolve the registered `InputRequirement` and current builder; inspect the concrete adapter signature and accepted typed objects. Do not create an alternate binding, rename a trusted owner, or change the mechanism contract merely to make assembly easy.
2. **Authoritative record:** In `runtime_producers.py` / `runtime_inputs.py`, consume existing first-party persisted records with real record ID, owner, kind, digest, schema/version, scope/authority and replay integrity. For each requirement, document exactly which first-party store provides the record and how it is validated. Existing producer availability is a mapping, **not** proof that a suitable persisted value exists in every run.
3. **Assembler:** Extend the existing `production_ingress` assembly path in `collective_innovation/mechanism_runtime.py` (or a narrowly delegated existing module called by that path), reusing the evolver/DGM/GEPA pattern. Build only the typed, validated input the existing builder expects; resolve executable evaluators/oracles/verifiers **only from explicitly trusted, registered first-party authority**, never from user-supplied serialized callables, arbitrary `eval`/import, or synthetic success stubs. If no safe executable owner exists, return typed `NOT_AVAILABLE` / `NOT_ELIGIBLE` / `REFUSED` and name the actual missing owner rather than lying about production reachability.
4. **Dispatch:** Preserve the single existing `CollectiveService.innovation_phase_cycle` path, governed pressure matching (`OUTWARD`, `INWARD`, `GROUNDING`), permissions, CONDUCT/sealed Borg boundaries, work caps, idempotence, and separate evaluation/promotion controls. No shadow HTTP endpoint or test-only ingress. A caller cannot override origin, contract, work callable, authority or source-trust digest.
5. **Observability:** Persist origin/record/content digests, mechanism ID, pressure, authorization, input-assembly outcome, invocation status, result evidence, refusal reason, and replay key in the existing durable ledger. Preserve previous external API/status compatibility.
6. **Test:** Add focused service-origin tests using independently persisted controlled first-party records; call production ingress **without injecting a `RuntimeContext`, assembler, or work callable**. Assert a genuine adapter execution and a durable receipt/reload, and separately assert typed refusal for missing, malformed, stale, forged owner/digest, ineligible pressure, unauthorized request, exhausted capacity and replay. Mutate/removing this assembler or the production-to-service connection must make an asserted test fail. Direct adapter-only tests do **not** count.
7. **Record:** Once source and tests are committed and retained, regenerate existing evidence using canonical generators (not manual JSON edits) and verify from a code-bound clean snapshot. Record exact mechanism-specific before/after counts, command/exit status and evidence links.

**Per-item definition of done:** This mechanism appears `production_reachable=true` in an independently re-derived canonical inventory; its genuine production route yields `EXECUTED` with a verified durable receipt for valid eligible first-party data; absence and abuse cases refuse safely; the specific test would fail if its assembler/dispatch were removed. Builder presence, a fake fixture, an injected callable or a derived boolean alone is **not** acceptance.

**Queue execution:** Resolve exact current gaps; implement the smallest safe batch (normally one mechanism); focused guard-run tests; commit/push under shared-`main` policy; only then regenerate bound records when appropriate. Coordinate serialization of writers for shared generated files. Never clobber simultaneous work or start uncontrolled parallel test workers. If one item is blocked by an absent trustworthy first-party callable/oracle, continue other independent D04 items while retaining the exact blocked row.

## 3. D08 final closure — only after D04 is genuinely complete

Do not modify the already-green D01, D02, D03, D05, D06 and D07 unless regression tests reveal a specific defect. In particular:

- D05 currently has a committed `CHAIN_RECEIPTS.json` and independent replay verification for all three composition scenarios. Preserve the actual chain records and negative-mutation behavior; do not replace them with fixture-only claims.
- D06 records `NOT_PROMOTED` for lack of explicit promotion authority. **That can be a valid PASS decision**. Do not grant yourself authority or force policy promotion for the sake of a green completion label.
- D07 has only a bounded `ALGORITHMIC_CORRECTNESS` gain from frozen inputs and limited measured category coverage; preserve `NOT_MEASURED` where warranted. No live-model superiority claim.

### Regeneration order

1. Finish source changes and focused tests; commit and push to the authorized shared branch, ensuring changes from other agents are preserved.
2. Observe the actual retained base SHA and consistency of the generation surface. Use the sanctioned clean detached **verification** snapshot only if repo policy allows; never use it for independent development or destructive synchronization.
3. Regenerate evidence with the **actual canonical generator interfaces** read from their `--help`/source and from `AGENTS.md`, in dependency order (participation/evidence, acceptance/benchmarks, delta inventory, chain receipts, policy decision, derived matrix/operator contract, criterion table, final closure). Do not invoke imaginary flags. If the existing implementation requires a different dependency order, follow its source-defined graph and document it.
4. For every required command, run it through the host guard as a full invocation, e.g.:

   ```sh
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/collective_innovation/mechanism_participation.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/evidence_package.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_acceptance.py --verify
   python3 tools/doubletake_evolve/runtime/host_workload.py -- env PYTHONPATH=.:tools python3 tools/doubletake_evolve/research_assimilation/operational_benchmarks.py --verify
   ```

   Also run the existing independent `--verify` routines for inventory, chain receipts, mechanism matrix, criterion table and final closure, plus affected unit, integration, regression and negative tests. Discover exact module names and CLI syntax from the repo; run each under the same host guard. Never accept a timeout, refusal, skipped test, missing provider or OOM as PASS.
5. Commit and push regenerated canonical artifacts, verify retained references/digests and the source/record match, then independently verify them again without manual edits. In `CRITERION_TABLE.json`, D04 must report **12/12 WORK production-reachable**, service-origin genuine execution evidence for each and all required refusal checks. D08 must be derived from the conjunction of preceding criteria, not a check for the mere presence of `FINAL_CLOSURE.json` (avoid circular self-certification).
6. `FINAL_CLOSURE.json` must truthfully contain current retained commit, per-criterion verdict and evidence, mechanism-specific routes, production input provenance, 12 service-origin execution receipts, three verified durable composition chains, run commands/exit codes and host telemetry, remaining blockers, promotion decision/rollback, benchmark scope and non-gain limitations. The independent verifier must detect changed content and false PASS claims.

### Final definition of done

**D04 PASS:** Every WORK mechanism has an actual assembler, owner-backed typed input, legitimate production route, safe denials, real service-origin result, and durable independently checked evidence; the policy service still runs via its own controller route and is not counted as a thirteenth WORK item.

**D08 PASS:** Canonical records re-derive from retained source; D01–D07 are independently PASS (including genuine D04 and durable D05); mutation/regression suites remain green; all host and security constraints hold; no circular or stale proof; closure verifier accepts a truthful `OPERATIONAL_INTEGRATION_COMPLETE` or `OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN` as appropriate.

## 4. Safety, shared repo and efficiency

- **Read `AGENTS.md` first.** Follow current shared-main policy; do not create feature branches, force-push, reset, rebase, squash, delete others' files, or run `git clean` in shared state. Avoid adding scratch prompts to Git.
- All mission experiments, pytest, builds and generators under `python3 tools/doubletake_evolve/runtime/host_workload.py -- ...`; focused workloads sequentially within defined limits. No bypass or unlimited retries.
- Do not execute external/foreign code inside DoubleTake; no arbitrary dynamic imports/callables from untrusted inputs; no unauthorized model downloads, network exfiltration, paid providers, or trust/approval expansion.
- Never change tests or benchmarks to paper over a failure. Fix the implementation or record the honest blocker. No fabricated inputs, paper records, scores, receipts, or performance claims.
- Avoid rechecking every green subsystem after each tiny code change; perform focused tests during implementation, and one **full canonical** verification sweep for closure or when a genuine regression warrants it.
- Status after each committed delta: exactly which mechanism became reachable/executed, relevant source/test commit, before/after canonical count, failures/blockers, and next unfinished D04 ID. Never claim a percentage from builder count alone.

## 5. Required final response

Return only a concise, evidence-backed summary with:

1. **Verdict:** `OPERATIONAL_INTEGRATION_COMPLETE`, `OPERATIONAL_INTEGRATION_COMPLETE_GAIN_UNPROVEN`, `PARTIAL_WITH_BLOCKERS`, or `INCONCLUSIVE` (exactly the canonical verifier result).
2. `D01–D08` PASS/BLOCKED/FAIL/INCONCLUSIVE table with source evidence and independent verifier result.
3. All 12 WORK IDs, first-party input owner, ingress assembler, authentic production execution receipt link, and replay/negative-test status; identify the separate POLICY SERVICE.
4. Retained branch/HEAD, source and generated record digests, test command/exit summaries, three durable composition chains, policy decision and rollback proof, benchmarking limitations and any outstanding blockers.

**Begin from live repository state and execute only unfinished D04 changes, followed by D08. Do not request further approval for implementation steps already authorized by v3; do not infer that research integration is complete merely because adapters or builders exist.**
