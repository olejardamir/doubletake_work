# Historical Harvest donor-to-owner hypotheses — distilled

**Scope:** `Astrocytech/Agent_X` main `874bbe4268aca0539cbf8476f62444d704f2d555`; not verified for current DT. Original Git blob `b634d27a527e107e9af6df3929a96b42ac616498`. [Historical audit](CURRENT_STATE_AUDIT.md); [canonical synthesis](DISTILLED_KNOWLEDGE.md).

| Donor `harvest_*.py` | Hypothesized canonical owner/disposition |
|---|---|
| models | existing Harvest/distillation/evidence/stabilization models; split+merge |
| contracts, gate_b | `capability_distillation.py` / `evaluate_gate_b` and decision store; merge/remove duplicate |
| embedding, corpus, grounding | semantic embedding/index/retrieval and `_hp_evidence`; split+merge with scope |
| generators, scheduler, ranking, optimizers | `_hp_mining`, canonical scheduler/evidence/search-policy; optimize only with caller/benchmark |
| evaluation, champion, canary | reality kernel/stabilization, promotion/version/release; split+merge |
| wiring | existing semantic implementation/write-code orchestration; merge |
| ui | real API/frontend; remove in-memory helper unless independently justified |
| benchmarks | benchmark/test tooling only |
| persistence, migration | canonical state/DB and real migration mechanism; no duplicate store |
| audit | strict integration/E2E tests, not donor-only construction |

**Hard evidence gate:** per symbol record canonical owner, actual importer/production caller, unique migrated behavior, rewritten production-path tests, and donor deletion/deprecation. No parallel authority. Unknown: current file locations, actual migration, runtime results. This table is a migration hypothesis, not an implementation instruction or PASS.
