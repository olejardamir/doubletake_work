# Historical orphan-harvest incident: crossover verification

**Status:** Historical Agent_X proposal, NOT current DT authority, implementation, or Ground. Full original Git blob `78c57f90e378d23f685af1703a8c238ee45f19dc`; previous compact blob `9cd8654bb1c956d5ebf0fe64fd7b675e0ce73ae6`. Target commit `1a0fd70ac01ca1a23670e61963d644b6a280cf07`. General production-necessity admission, lifecycle, bypass and positive/negative gate contracts are retained in [companion contract](AGENT_X_ORPHAN_HARVESTED_CAPABILITY_REMEDIATION2.md); broader principles in [CL-HARVEST-001](clustered/historical-harvest-governed-integration.md). This source retains **incident-specific audit evidence and unresolved questions**.

## Incident identity and unknowns

The historical change reportedly added `tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py` and tests, potentially exports in `harvested_algorithms/__init__.py` and routing in `collective_core/write_code_e2e.py`. Source ID `evolution_gap_21_3ee5`; possible origin `knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`. **Unverified:** source bytes and fidelity, complete commit diff, independent real production caller, actual historical disposition, current DT equivalents. The alleged problem is lack of demonstrated *production necessity*, not arithmetic correctness.

## Reproducible read-only investigation

1. Inspect the complete target commit diff and trace `fitness_weighted_crossover`, `blend_parents`, `rank_weights` through static/dynamic imports, production entrypoints, configuration, tests, routing, registries, manifests and exports. Separate actual invocation from `TEST_ONLY`, `EXPORT_ONLY`, `ROUTING_ONLY`, `REGISTRY_ONLY`, `DOCUMENTATION_ONLY`, `NO_REFERENCE`.
2. Search current/historical selection, mutation/adaptive mutation, recombination, candidate scoring and scheduling owners. Determine semantic duplication versus a genuinely required new responsibility. Check every other harvested algorithm separately; do not mass-retire legitimate capabilities.
3. Retrieve the original `evolution_gap_21_3ee5` report; compare source mechanism, implemented mechanism, omissions, behavior and unsupported performance claims. A generic weighted convex blend is not proof of a richer claimed crossover. Source missing/stale means fidelity **UNRESOLVED**.
4. Only if independent consumer/owner checks show the module orphaned, identify live unnecessary module/test/export/registration/route/manifest entries for authorized removal, preserving historical promotion receipts and checking later changes first.

## Incident-specific falsifiers

- A test that weights sum to one, fitter parent has greater weight, convex-hull outputs, or malformed inputs are rejected establishes local arithmetic **not production necessity**.
- Same-change owner map, synthetic caller, self-import, test-only or registry-only use cannot justify a new canonical owner.
- Positive control: pre-existing independent runtime need, faithful behavior, real caller and observed integration effect; never remove a verified used algorithm.
- Suggested historical commands (NOT executed): `PYTHONPATH=.:tools python -m pytest <focused affected tests>`; `python -m compileall -q tools tests`. Validate current paths before running. Report audited commit, source fidelity, real callers, owners, other algorithms checked, changed/deleted files, test results and unresolved blockers.

**Current-DT limitation:** A 2026-11-02 private DT indexed search reportedly found no `fitness_weighted_crossover` or `harvested_algorithms` matches; this does NOT prove absence. Revisit only on an authorized source/caller audit or bounded fixture. No B1, B7, autonomous-cycle or runtime Ground claim.
