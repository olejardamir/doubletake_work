# Current State Audit — Why Work Remains

Audited repository: `Astrocytech/Agent_X`  
Audited `main`: `874bbe4268aca0539cbf8476f62444d704f2d555`

The recent implementation wave added a substantial parallel Harvest framework and matching tests. It also added `HARVEST_AUTHORITY_MAP.md`, which correctly identifies many real pre-existing owners.

However, comparison from `3887efe448edd223a00f94db324786d6a47a2d3b` to `874bbe4268aca0539cbf8476f62444d704f2d555` showed the implementation wave was overwhelmingly **new files**, while the canonical production owners identified in Task 01 were not correspondingly modified. Therefore the design is not yet integrated end-to-end.

New donor modules:
- `tools/agentx_evolve/collective_core/harvest_models.py`
- `tools/agentx_evolve/collective_core/harvest_contracts.py`
- `tools/agentx_evolve/collective_core/harvest_gate_b.py`
- `tools/agentx_evolve/collective_core/harvest_embedding.py`
- `tools/agentx_evolve/collective_core/harvest_corpus.py`
- `tools/agentx_evolve/collective_core/harvest_grounding.py`
- `tools/agentx_evolve/collective_core/harvest_generators.py`
- `tools/agentx_evolve/collective_core/harvest_scheduler.py`
- `tools/agentx_evolve/collective_core/harvest_evaluation.py`
- `tools/agentx_evolve/collective_core/harvest_ranking.py`
- `tools/agentx_evolve/collective_core/harvest_champion.py`
- `tools/agentx_evolve/collective_core/harvest_wiring.py`
- `tools/agentx_evolve/collective_core/harvest_canary.py`
- `tools/agentx_evolve/collective_core/harvest_ui.py`
- `tools/agentx_evolve/collective_core/harvest_optimizers.py`
- `tools/agentx_evolve/collective_core/harvest_benchmarks.py`
- `tools/agentx_evolve/collective_core/harvest_persistence.py`
- `tools/agentx_evolve/collective_core/harvest_migration.py`
- `tools/agentx_evolve/collective_core/harvest_audit.py`

Key verified problems:
- `capability_distillation.py` already owns the actual Harvest -> Gate A -> Gate B -> implementation boundary, yet a second Gate B/contracts stack was added.
- `harvest_loop.py` and `_hp_*` already own the real Harvest lifecycle/mining/inventory path.
- `harvest_ui.py` is an in-memory Python helper, not the actual browser UI; its search is substring-based rather than semantic.
- `harvest_embedding.py` creates a separate embedding/chunk/spec layer instead of making the canonical governed semantic embedding path the production owner.
- `harvest_audit.py` mostly instantiates donor classes; `test_harvest_audit.py` accepts partial success instead of requiring all hard checks to pass.
- At audit time GitHub exposed no status checks for the HEAD.

Correction goal: treat every donor module as source material. For each symbol choose one of `MERGE_INTO_EXISTING_OWNER`, `SPLIT_AND_MERGE`, `BENCHMARK_OR_TEST_ONLY`, `KEEP_AS_NEW_OWNER_WITH_PROOF`, or `DELETE_AFTER_MIGRATION`. End with one authoritative production path per responsibility.
