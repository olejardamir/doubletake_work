# CL-HARVEST-001 — Historical Harvest-to-canonical-owner integration

**Scope:** One consolidated, public-safe *historical research specification*, not an executable mission or evidence of current DoubleTake implementation. Source: archival `Astrocytech/Agent_X` main at `874bbe4268aca0539cbf8476f62444d704f2d555` versus preceding `3887efe448edd223a00f94db324786d6a47a2d3b`. Later private DT parity, runtime callers, authorization, test outcomes and migration completion are **UNKNOWN**. Current Director owns execution priorities; this cluster grants no authority. Original verbose and shortened source versions remain recoverable by Git history and the exact SHA ledger below. Related historical cross-topic digest: [D01](../DISTILLED_KNOWLEDGE.md).

## Original observation and owner hypothesis

An archival implementation wave added 19 `harvest_*.py` donor modules, principally new files, without demonstrated changes in the canonical production owners. At the time, `capability_distillation.py` already owned the Harvest→Gate A→Gate B→implementation path; `harvest_loop.py` and `_hp_*` owned mining, evidence and lifecycle. Donor Gate B/contracts could duplicate implementation authority, donor embedding could duplicate an index/spec, and donor UI was an in-memory substring helper rather than real browser/API integration. A donor audit constructed classes and accepted partial successes; no exposed GitHub status checks were reported at the archival audit. These are *dated observations*, not present-day DT defects.

**Donor → hypothesized canonical owner / disposition (all require current source and caller verification):**

| Donor group | Historical canonical locus / allowed outcome |
|---|---|
| models, contracts, gate_b | Existing Harvest/distillation models, `capability_distillation.py:evaluate_gate_b`, decision store; split/merge and remove parallel Gate B. |
| embedding, corpus, grounding | Existing semantic embedding/index/retrieval and `_hp_evidence`; source-scope-preserving split/merge. |
| generators, scheduler, ranking, optimizers | `_hp_mining`, existing scheduler/evidence/search-policy; only retain optimizer with benchmark and real caller. |
| evaluation, champion, canary | Reality kernel, stabilization/promotion/version/release owners; split/merge. |
| wiring | Existing semantic implementation / code-write orchestration; no second gateway. |
| ui | Real API/frontend; remove in-memory helper after any unique DTO is migrated. |
| benchmarks | Test/benchmark tooling only; never runtime authority. |
| persistence, migration | Existing canonical state/DB and actual migrations; no second store. |
| audit | Real production integration and strict E2E tests; no donor-only class construction as proof. |

Per donor **symbol**, record importer, real caller, distinct behavior, destination owner, migration test and safe deprecation. Allowed dispositions: MERGE_INTO_EXISTING_OWNER, SPLIT_AND_MERGE, BENCHMARK_OR_TEST_ONLY, KEEP_AS_NEW_OWNER_WITH_PROOF, DELETE_AFTER_MIGRATION. A genuinely new owner needs independent responsibility, an actual consumer, and a removal/maintenance plan. Never delete a donor until unique logic, references and retained state are checked.

## Single governed pipeline and discriminating tests

1. **Discovery and semantic evidence:** One canonical provider/router, corpus chunks, index, retrieval scope and logical inventory. Every claim resolves to original source chunk, embedding spec, corpus/index identity and authorized scope. Reject missing scope, malformed/nonfinite vector, dimension/spec/role drift and synthetic vector→text reconstruction. Paraphrased queries must retrieve existing evidence; repeated discovery must merge, not duplicate. Embeddings navigate; they are not executable code or source truth.
2. **Gate B before implementation:** One server-side decision evaluates measurable gap, owner, value floor, feasibility, experiment, hard guardrails and disposition `REJECT|EXPERIMENT|REPLACE|EXTEND|COMPLEMENT|NEW_COMPONENT`. Explicit rejection cases: NO_VALUE, DUPLICATE, ARCHITECTURAL_MISFIT, INFEASIBLE, UNTESTABLE, MAINTENANCE_BURDEN, GOVERNANCE, STALE_DECISION. Revalidate immediately before code write. UI/status/model confidence, novelty, donor registry and generator fitness are not grants. REPLACE identifies incumbent/cleanup; COMPLEMENT proves distinct routing. UNKNOWN fails closed.
3. **Proposal scheduler:** Wrap existing producers in a proposal-only interface; reuse canonical persistent scheduler for bounded uncertainty/cost exploration, asynchronous multi-fidelity tests and delayed downstream reward. Optional semantic-neighbor, mutation, centroid, CEM/CMA-ES/Bayesian optimizer only after caller/value proof; operate on compact controls, not raw embeddings by default. Reject missing scope/provenance/cost. Scheduler priority cannot authorize code/promotion. Negative controls: slow probe cannot block other work, restart cannot double-count, cost cap, delayed reward changes allocation, generator cannot promote.
4. **Evaluation and promotion:** Existing owners run conjunctive R0 structural validity, R1 anti-slop, R2 independent invariants/adversarial/differential checks, R3 benchmark, R4 real production-path integration, R5 fresh champion/challenger, R6 non-mutating shadow or authorized bounded persisted canary. A hard failure cannot be averaged away; high absolute score below incumbent fails R5; disconnected caller fails R4; placeholder fails R1. REPLACE removes old active path, COMPLEMENT routes by justified specialization. Canary must abort, survive restart and support rollback; shadow must not write authoritative state.
5. **Durable state:** Assign each record to an existing canonical store; immutable/append-only evidence, stable IDs, idempotent writes, crash/restart reconciliation, migration only for actual persisted donor data. Never invent legacy lineage, metrics or PASS. Context drift invalidates derived decisions, not raw evidence. Acknowledged-write durability/ordering and historical-integrity disposition require owner-approved contracts; this historical plan **does not** resolve current B1/B4.
6. **Real UI/API:** Actual browser/API semantically searches governed inventory with capability/domain/source/status/disposition/champion/generator filters and displays evidence, decision and lifecycle. Server revalidates implementation eligibility on action; stale enabled button, tampered API request, double-click and hidden endpoint cannot bypass Gate B. Substring-only donor UI is insufficient. Success status follows backend verification.
7. **Equal-budget benchmark:** Freeze TRAIN/VALIDATION/HOLDOUT and B0–B5 or equivalent, with leakage controls. Measure qualified discoveries, downstream promoted value per cost, time/cost to first promotion, coverage, duplicates. Ablate diversity, delayed reward, uncertainty, exploration, R1, ASHA and generator adaptation; exact-vs-ANN retrieval control. Novelty-only improvement with worse promoted value fails; no holdout gain retains incumbent.
8. **Strict E2E and cleanup:** Real browser/API→source evidence→Gate B→authorized code→actual caller→evaluation→canary→promotion, including negative tamper/duplicate/stale/restart/rollback/obsolete-authority paths. PASS requires **every** hard gate and no hard UNKNOWN; partial-success counters and donor-only tests are insufficient. Confirm source/semantic/runtime reconciliation and remove obsolete donors only after references, unique behavior, state and tests are verified.

**Evidence packet / definition of done:** starting and ending revisions, canonical owner/caller graph, per-symbol disposition, changed canonical code, actual UI/API-to-code path, independent negative controls and equal-budget held-out results, exact test commands/outcomes, release/restart state, rollback, removed/retained donors, unresolved unknowns. Source-only analysis, fixture-only PASS, status labels and prompt inclusion are not independently verified assimilation Ground. Test candidate only under current owner authorization; preserve private/public separation and single-main concurrency.

## Unique historical source ledger (original → most recent read blob)

All paths relative to `doubletake_evolution/scrapyard/`; each was fully read as UTF-8 for this merge. Historical original blob is retained in Git even if working copy is deleted. Content is archival self-authored user-provided planning material; no external code or paper reproduced; licensing/attribution of any *future* donor code must be checked separately.

| Member ID / source | Original SHA | Last-read SHA |
|---|---|---|
| H-00 `CURRENT_STATE_AUDIT.md` | `2ce5cbca46e1aed5f3f212322ea0cd906c7e643a` | `dc4a13e656b26937109c17a53ef56fb3979d28c0` |
| H-MX `DONOR_MODULE_DISPOSITION_MATRIX.md` | `b634d27a527e107e9af6df3929a96b42ac616498` | `f6022de2f82ce921142e2ab23f7ee8d8c9f27842` |
| H-MAIN `MAIN_EXECUTE_REMAINING_HARVEST_WORK.md` | `4a5682905e5f21f3b0a5a4e3ab552c27ce51fa8c` | `96f9d52276a4968fec98e39bb3e3cf8e5f8b5044` |
| H-01 `01_revalidate_and_disposition.md` | `df695e0556ab926f03cf1f59c91841fab4fb0d9a` | `6688846ab15a72d50c88c70a9d9696ee5709b611` |
| H-02 `02_gate_b_contract_integration.md` | `e9b17035387e8680f5ec2328fb51c7765edc43a8` | `0a4aec9bbfd3b26365c6fa4968c081a90027a638` |
| H-03 `03_semantic_embedding_grounding.md` | `046070224ecad6f037676438af00dcef130e9fa4` | `06f3081f219552203852b42fb6b0f55ee6ac574b` |
| H-04 `04_generation_scheduler_integration.md` | `bc1de84d7f1c4be97cff5b4636be048c45184b71` | `f177d789d16b1f5cc53b41644d5725de3de8369f` |
| H-05 `05_evaluation_promotion_integration.md` | `47bb697da972c59b0ce3cfe402c3b0628f6e07ac` | `39ec0cd88e2657862fa7961bfe8b67a104457555` |
| H-06 `06_persistence_migration_recovery.md` | `d2a2eed040d64d1e9d04c235e2bc59a24a53a555` | `1e9c6eb4924abe89a4ae4378ee771018f5760952` |
| H-07 `07_real_api_ui_inventory.md` | `f077f15df62d12bbda19ed5f832ff3e6b84b17cc` | `572d3e80a22d9de12beaa1939e020053911927ff` |
| H-08 `08_benchmark_holdout.md` | `9f5ca876be588f7249cd55e2c078b7a606ee84f7` | `9ac87fe414f86f76b7352b7d08a23a913487caf7` |
| H-09 `09_strict_e2e_ci.md` | `4465231b2ba76b867290031d365a2bd7f9959267` | `350060eba69d56d3eafab4594e30cd13e708128e` |

**Open research/verification:** actual current private DT owner and caller parity; safe owner-authorized independent end-to-end source-K fixture; legitimate knowledge→decision→implementation receipt; held-out transfer and no-loss durability. This cluster is a provenance-preserving historical synthesis, **not** a new `RESEARCH_OFFLOAD` proposal (no demonstrated current novelty). Revisit only on current evidence of a missing owner/caller, newly authorized safe experiment, or source conflict.
