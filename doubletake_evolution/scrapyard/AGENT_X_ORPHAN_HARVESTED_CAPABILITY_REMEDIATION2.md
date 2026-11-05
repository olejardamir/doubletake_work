# Historical Harvest production-necessity gate — distinct contract

**Status:** Historical Agent_X proposal, not current DT authority, implemented behavior, or Ground. Original full blob `c776a7d4a2a5527992921206d9291b3eeacafda0` (47,847 bytes) and preceding reduced blob `f2aabe5359759ac6a36044ac19647ce80f9693c3` remain recoverable in Git history. Target historical commit `1a0fd70ac01ca1a23670e61963d644b6a280cf07`, parent `c685cc12257ac311906f6e26063bb23aeaab0c84`. Companion [incident verification](AGENT_X_ORPHAN_HARVESTED_CAPABILITY_REMEDIATION.md) retains the concrete crossover caller/source audit; [CL-HARVEST-001](clustered/historical-harvest-governed-integration.md) holds general integration concepts. This document retains the **distinct admission and lifecycle requirements**, not a second incident narrative.

## Admission invariant

An algorithm may be correct, novel, compilable and unit-tested yet unnecessary in production. Autonomous **evidence-origin** code promotion must prove need independently of candidate-authored files and same-change wiring; do not apply this specialized Harvest requirement indiscriminately to ordinary authorized human maintenance. Harvest, mining and gap-discovery evidence grants no mutation authority.

Independent evidence may be a pre-existing real runtime caller/unimplemented hook or acceptance failure; measured substitution into an existing subsystem with baseline and owner; previously authorized architectural gap; or an actual external API/CLI/plugin consumer contract. A new caller may be added in the same patch **only when its need was independently established first**. Tests, exports, registry, manifest, self-routing, new owner-map rows, candidate-provided `consumer_path`, `runtime_used=true`, `production_needed=true`, Gate B `MERGE`, or synthetic callers do not establish need.

Classify references as `REAL_RUNTIME_CALL`, `REAL_EXTERNAL_ENTRYPOINT`, `PREEXISTING_ACCEPTANCE_REQUIREMENT`, `PREEXISTING_ARCHITECTURAL_GAP`, `MEASURED_EXISTING_RUNTIME_IMPROVEMENT_PATH` versus `TEST_ONLY_REFERENCE`, `EXPORT_ONLY_REFERENCE`, `ROUTING_ONLY_REFERENCE`, `REGISTRY_ONLY_REFERENCE`, `MANIFEST_ONLY_REFERENCE`, `PROVENANCE_ONLY_REFERENCE`, `DOCUMENTATION_ONLY_REFERENCE`, `SAME_CHANGE_SELF_JUSTIFICATION`, `DEAD_REFERENCE`. Trace real entrypoint → subsystem → symbol → invocation, including dynamic loader/config to actual consumer.

## Historical incident-specific additional evidence

The target commit reportedly touched `tools/agentx_evolve/algorithmic_substance_gate/test_substance_gate.py`, `collective_core/write_code_e2e.py`, `harvested_algorithms/__init__.py`, `harvested_algorithms/fitness_weighted_crossover.py`, and `harvested_algorithms/test_fitness_weighted_crossover.py` (paths under `tools/agentx_evolve/` where applicable). Historical IDs `evolution_gap_21_3ee5` and `fcda4d3cc44fc3b7`; possible source `knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`. Verify source bytes/digest and actual diff: a docstring is not provenance. Classify fidelity `FAITHFUL`, `FAITHFUL_SUBSET`, `MATERIAL_SEMANTIC_DRIFT`, `SOURCE_UNRESOLVED`; distinguish source mechanism from implemented mechanism and omissions. Unsupported “22%” or “>=15%” improvement claims require fixed seeds, current-runtime baseline, workload and metrics. Test ordinal rank versus min-max fitness, “uniform crossover” versus arithmetic blending, NaN/inf, booleans, empty/mismatched genomes or scores, negative/equal fitness and deterministic float boundaries. These tests establish behavior, **not need**.

## Canonical ownership and lifecycle

Compare current HEAD and historical diff; never blindly revert later fixes. Search existing selection, mutation, recombination and scoring owners. Classify `DUPLICATE`, `PARTIAL_DUPLICATE`, `USEFUL_PRIMITIVE_FOR_EXISTING_OWNER`, `GENUINELY_NEW_REQUIRED_CAPABILITY`, `ORPHAN_INTERESTING_ALGORITHM`. Prefer patching an existing owner. A new module requires independently established demand, documented owner search and alternatives, coherent responsibility, real integration/contract, less fragmentation, resolvable provenance, fidelity and behavioral/integration tests. Audit other harvested algorithms separately rather than mass-delete.

For a verified orphan, retire only live unnecessary module/test/export, `blend_parents`/`rank_weights` exports, crossover-specific `_CANONICAL_MECHANISMS` routes, manifests/registrations, active status and exclusively supporting wiring **after** checking actual consumers and unique dependencies. Preserve historical promotion/Gate B/audit receipts as historical truth. Current `IMPLEMENTED` requires matching canonical target/digest, valid receipt, executed tests, independently authorized need and non-retirement. Retired modules cannot reactivate via stale ledger, manifest or replay. Reuse existing lifecycle authority; no parallel status database.

## Enforcement boundaries

Bind typed need evidence to source/capability/candidate IDs, durable digest/fidelity, base revision, independent need class and proof, alternatives searched, owner, integration path, baseline/acceptance and proposed action. Unknown source/origin, stale revision, malformed evidence, parser/search failure, ownership ambiguity or mismatch must fail closed to a typed non-production outcome (`CONCEPT_ONLY`, `EVIDENCE_ONLY`, `DEFERRED`, `REJECTED`). Reject `production_needed=True`, `skip_production_need=True`, `trusted=True`, `force_production=True` and analogous bypass flags. LLM rationale is advisory.

Before expensive authoring, decline unneeded production source/test staging; at mutation/promotion recheck need, identity, owner, action and revision. Audit autonomous entrypoints `write_code_e2e`, `author_functional_module`, `promote_candidate`, `PATCH_CANONICAL`, `CREATE_CANONICAL_MODULE`, `register_mcp_tool` and equivalent paths. Preserve one governed promotion transaction, Gate B, rollback and trust-boundary enforcement; protect actual decision/mutation/status authority in `TRUST_BOUNDARY_RELS` or equivalent, not every descriptive reference. Same evidence should yield same decision; stale evidence cannot authorize changed HEAD.

## Required falsifiers (not executed)

1. Substantive orphan with green unit tests: no author call, source/test/export/route/manifest/registration/promotion or `IMPLEMENTED`; retain evidence and typed rejection.
2. Reject fake consumer, self-export/routing, same-change owner, test/doc/manifest-only references, bypass flag, status spoof and stale/unresolved source. Parser failure must not default to approval.
3. Positive pre-existing need plus canonical owner: legitimate normal authoring→Gate B→promotion→lifecycle succeeds; authorized human maintenance remains unaffected.
4. New-module proposal without independent contract/owner search fails; verified new responsibility with real integration may pass.
5. Retired historical capability stays in audit history but cannot be resurrected by replay; retry is idempotent.
6. If retained, exercise fitness edge cases, fidelity and reproducible baseline improvement; local arithmetic alone cannot prove runtime need.
7. Audit all harvested modules and mechanism routes; require real caller/owner, actual lifecycle tests, negative controls and concurrency/retry behavior.

Historical suggested verification: focused authoring, substance, governance, lifecycle and algorithm suites; `compileall`, pytest collection, final diff and reference search for `fitness_weighted_crossover`, `blend_parents`, `rank_weights`, `evolution_gap_21_3ee5`, `fcda4d3cc44fc3b7`. Deleting a file or passing isolated tests is not closure: demonstrate necessity enforcement across **all real autonomous evidence→production paths** with positive controls.

**Current DT applicability UNKNOWN.** No private DT source/test verification, historical B1 resolution, B7 mission consumption, autonomous cycle or Ground follows from this text. Revisit only when a present-DT evidence-origin promotion path and authorized reproducible fixture are identified.
