# Historical orphan-harvest crossover: incident-specific audit

**Historical proposal only; not DT implementation or Ground.** Full original blob `78c57f90e378d23f685af1703a8c238ee45f19dc`; preceding blob `8c05794bd947cb33e7155fe5b84007ed496d15ca`; historical target commit `1a0fd70ac01ca1a23670e61963d644b6a280cf07`. General admission/lifecycle/negative-control contract: [companion](AGENT_X_ORPHAN_HARVESTED_CAPABILITY_REMEDIATION2.md); shared concepts: [CL-HARVEST-001](clustered/historical-harvest-governed-integration.md). This file retains the *distinct incident investigation*, not an instruction to change current DT.

## Incident and evidence gaps

Reported module: `tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py`; possible exports `harvested_algorithms/__init__.py`, routing `collective_core/write_code_e2e.py`; source ID `evolution_gap_21_3ee5`, possible report `knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`. **UNKNOWN:** actual source bytes/fidelity, full historical diff, independent production caller, disposition, current DT equivalent. Local arithmetic correctness does not establish production necessity.

## Read-only verification recipe (NOT executed)

1. Fetch historical commit and parent, compare full diff, source report and implementation. Trace `fitness_weighted_crossover`, `blend_parents`, `rank_weights` through static/dynamic imports, entrypoints, configs, registries, exports and manifests. Distinguish real runtime invocation from test/export/route/registry/documentation-only and self-created callers.
2. Search existing selection, mutation/adaptive mutation, recombination, scoring and scheduling owners for semantic duplication and actual independent demand. Audit other harvested algorithms separately.
3. Test source fidelity: generic weighted convex blending is not necessarily the claimed crossover; source missing/stale means unresolved. Numeric weight-sum, fitter-parent priority, convex-hull and malformed-input tests establish arithmetic only.
4. **Positive control:** independently established pre-existing caller/need, faithful source, real integration effect. **Negative controls:** test-only use, same-change owner map, synthetic caller, self-import, registry-only use. Never retire a verified used capability.
5. Only after verified orphan status and authorized ownership review, consider removal of *live unnecessary* module, tests, exports, routes and manifest entries; preserve historical promotion receipts and later fixes. Suggested historical checks, **not run**: focused pytest with current paths verified, `python -m compileall -q tools tests`. Report commit, source digest, callers, owners, other algorithms, actual changes/tests and blockers.

A 2026-11-02 private DT indexed search reportedly found no `fitness_weighted_crossover` or `harvested_algorithms` matches; **not proof of absence**. No B1/B7 or natural-cycle Ground claim. Revisit on authorized source/caller audit or bounded fixture.
