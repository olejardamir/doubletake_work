# Donor Module Disposition Matrix

Starting hypothesis; revalidate current `main` before editing.

| Donor | Likely destination | Default |
|---|---|---|
| `harvest_models.py` | existing Harvest/distillation/evidence/stabilization models | split + merge |
| `harvest_contracts.py` | `capability_distillation.py` | merge |
| `harvest_gate_b.py` | canonical `evaluate_gate_b` + decision store | merge/replace duplicate |
| `harvest_embedding.py` | semantic embedding route/retrieval | split + merge |
| `harvest_corpus.py` | semantic index/search scope | split + merge |
| `harvest_grounding.py` | `_hp_evidence` + semantic retrieval/distillation | split + merge |
| `harvest_generators.py` | `_hp_mining.py` proposal layer | merge/adapt |
| `harvest_scheduler.py` | existing Harvest/stabilization scheduler | merge/adapt |
| `harvest_ranking.py` | scheduler/evidence comparison | merge/adapt |
| `harvest_optimizers.py` | proposal/search-policy layer | keep only if production/benchmark caller exists |
| `harvest_evaluation.py` | reality kernel + stabilization/promotion | split + merge |
| `harvest_champion.py` | existing promotion/version state | merge |
| `harvest_canary.py` | existing promotion/release path | merge |
| `harvest_wiring.py` | semantic implementation/write-code orchestration | merge |
| `harvest_ui.py` | real API + frontend Harvest UI | delete/relocate helper unless proven useful |
| `harvest_benchmarks.py` | benchmark/test tooling | benchmark-only allowed |
| `harvest_persistence.py` | existing state/scheduler DB owners | merge/delete duplicate |
| `harvest_migration.py` | real canonical migration mechanism | keep only if it performs real migration |
| `harvest_audit.py` | strict integration/E2E tests | replace/move to test tooling |

Every final disposition must record canonical owner, real caller, migrated symbols, rewritten tests, and deletion/deprecation status.
