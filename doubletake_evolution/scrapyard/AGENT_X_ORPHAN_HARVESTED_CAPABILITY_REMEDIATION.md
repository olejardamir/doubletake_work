# Historical orphan-harvest remediation — distilled incident

**Scope/provenance:** This is a historical Agent_X remediation proposal, not current DT instructions, approval or runtime proof. Original complete working blob `78c57f90e378d23f685af1703a8c238ee45f19dc` (13387 characters) remains recoverable in Git history. Target commit: `1a0fd70ac01ca1a23670e61963d644b6a280cf07`. Separate generalized Harvest governance: [CL-HARVEST-001](clustered/historical-harvest-governed-integration.md). This file retains the distinct incident, exact verification targets and negative tests.

## Incident and unresolved evidence

The targeted change reportedly added `tools/agentx_evolve/harvested_algorithms/fitness_weighted_crossover.py` and its test, with possible `harvested_algorithms/__init__.py` exports and `collective_core/write_code_e2e.py` routing. The historical source identifier is `evolution_gap_21_3ee5`, possibly linked to `knowledge_sources/evolution_gap_21_3ee5_consensus_174-miner.report.md`. **UNKNOWN:** source existence/fidelity, complete affected commit diff, legitimate production caller, current DT path parity and actual disposition. The alleged defect was *unjustified production necessity*, not broken arithmetic.

**Core falsifier:** harvested evidence → mechanism/provenance → compare existing canonical owners → independent runtime need → authorized patch of existing owner (or separately justified new owner) → real caller/behavioral proof → governed promotion. The shortcut harvested record → interesting algorithm → new production file + tests + new owner mapping → self-declared canonical is invalid. A module's own exports, tests, registry/manifest, routing hint or owner map introduced by the same promotion cannot independently prove need.

## Exact read-only verification

1. Audit every file in historical commit `1a0fd70...`. Trace `fitness_weighted_crossover`, `blend_parents`, `rank_weights` across static/dynamic imports, real production callers, configuration, routing, registry, exports and tests. Classify `REAL_PRODUCTION_CONSUMER`, `TEST_ONLY`, `EXPORT_ONLY`, `ROUTING_ONLY`, `REGISTRY_ONLY`, `DOCUMENTATION_ONLY` or `NO_REFERENCE`. Only actual useful runtime invocation establishes consumption.
2. Compare selection, mutation/adaptive mutation, recombination/crossover, candidate scoring and scheduling owners. Classify `DUPLICATE`, `PARTIAL_DUPLICATE`, `USEFUL_PRIMITIVE_FOR_EXISTING_OWNER`, `GENUINELY_NEW_REQUIRED_CAPABILITY` or `ORPHAN_INTERESTING_ALGORITHM`. Semantic ownership matters more than bytewise uniqueness.
3. Resolve `evolution_gap_21_3ee5` to its original source; distinguish `SOURCE_MECHANISM`, `IMPLEMENTED_MECHANISM`, `PRESERVED_BEHAVIOR`, `OMITTED_BEHAVIOR`, `UNVERIFIED_CLAIMS`. A generic weighted convex blend cannot be claimed as a full richer crossover without proof. Missing/stale evidence blocks full-mechanism promotion.
4. Audit other `tools/agentx_evolve/harvested_algorithms/` modules, preserving verified legitimate canonical algorithms. For each: `REAL_RUNTIME_USED`, `CANONICAL_PRIMITIVE_USED_BY_REAL_OWNER`, `UNUSED_BUT_JUSTIFIED` or `ORPHAN_PRODUCTION_ALGORITHM`; record caller, owner, source, behavioral test and integration proof.

## Production-necessity and safe disposition

A harvested algorithm can be substantive, compilable, novel and unit-tested but still not needed. Promotion requires (1) independent real runtime demand, (2) existing-owner comparison, (3) legitimate execution path and effect, (4) source fidelity or honest partial scope, (5) meaningful behavior tests, (6) real subsystem integration proof, (7) pre-existing governed authority. A new canonical module additionally needs a coherent responsibility no existing owner can absorb, lower fragmentation and a maintenance/removal rationale. Same-promotion owner metadata cannot self-justify creation.

Prefer `PATCH_EXISTING_CANONICAL_OWNER` to `CREATE_CANONICAL_MODULE`. Without proof, retain source knowledge as `CONCEPT_ONLY`, `EVIDENCE_ONLY`, `DEFERRED`, `ALREADY_EXISTS` or `REJECTED`, not executable code. If genuinely orphaned, remove the unused module/test and exclusively supporting exports, registry, manifest, mappings, routes and false production claims **only after** checking real callers, unique behavior, dependencies and references. Do not create wrappers or second promotion/rollback/code-writing authority merely to retain it.

## Falsifiable controls and reporting

**Positive:** pre-existing independent runtime need and caller, justified owner, faithful behavior and observed downstream effect. **Negatives:** unit arithmetic (weights sum to one, fitter parent gets higher weight, convex-hull output, malformed-input refusal), self-import, registry-only use, same-change owner mapping, invented synthetic caller and unresolvable source **do not** establish necessity. Reject deletion that breaks a verified used capability. Test actual integration, not only the new module's own tests.

Historical suggested checks (NOT executed here): `PYTHONPATH=.:tools python -m pytest <focused affected tests>` and `python -m compileall -q tools tests`; validate current paths first. Report audited commit, disposition `RETAINED/MOVED/DELETED`, real callers, owner, source fidelity, changed/deleted files, other algorithms examined, test/compile results and blockers. No pass without genuine production necessity.

**Current comparison/trigger:** Private DT indexed code search for `fitness_weighted_crossover` and `harvested_algorithms` returned no matches on 2026-11-02; this **does not establish absence**. Revisit on current owner/caller proof or an authorized bounded fixture. Nothing here demonstrates B1 historical-integrity resolution, B7 mission consumption, natural autonomous cycles or DT Ground.
