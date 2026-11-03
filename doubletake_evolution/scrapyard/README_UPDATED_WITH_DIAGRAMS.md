# Agent_X governed seed kernel — historical README distilled

Source: `doubletake_evolution/scrapyard/README_UPDATED_WITH_DIAGRAMS.md`, prior blob `f66b274b73cbb53ca6a2d7c2cf699dcf0c624414`. Historical Agent_X project README, **not** current DT operating instructions. Original 13 diagram references and full wording remain recoverable through Git history; referenced `DOCUMENTS/` images were not inspected here. **License: proprietary** (historical `LICENSE` reference); no code or image reuse authorized.

## Scope and architecture
L0 is a minimal governed replayable seed, not an autonomous assistant. Intended offline/minimal environment: no model, GPU, network, Docker or environment secrets. Production default forbids live self-modification, direct shell/network access, unauthorized filesystem writes and promotion during normal turns. L1+ is an **external** authorized evolution agent, not part of L0.

`User Input → KernelService.run_turn → PlannerPort → GovernancePort → ToolGatewayPort → MemoryPort → EvaluationPort → TracePort → CheckpointPort → Output`.

The governance gate is **between** planner selection and tool execution. Profile specialization and extension ABI must not bypass it. Seed manifest, invariants, public contracts, acceptance checklists and extension ABI were referenced in original README but not verified against current DT.

## Reproducibility claims, not current proof
Historical commands: `make install`, `make seed-boot`, `make prove-seed`, `make run`, `make build-seed`, `make clean`. Original claimed the proof suite checks boot, governed execution, denial, governance-before-gateway ordering, evidence persistence, checkpoint replay, manifest closure and phase order. **No commands executed in this review**; current implementation and actual proof artifacts unknown.

## Distinct design lessons / negative tests
- Keep L0's governed tool choke point separate from external evolution authority. Test direct/fallback routes for denied actions and absence of side effects.
- A proof command or diagram is not evidence of an executed current-revision test. Demand exact source SHA, reproducible pass/fail receipt and independent effect observation.
- For replay, verify checkpoint provenance and state consistency without altering protected historical state.
- External evolution proposal must be a small reversible change with explicit authority, source evidence, tests, documented outcome and rollback; a prompt is not an execution grant.

## Diagram provenance
Original README linked 13 visual diagrams in `DOCUMENTS/`: high-level flow; authority hierarchy; source of truth; pseudocode; phase I/O; incremental implementation; evidence pyramid; L0 boundary; deliverable package; decision gates; document map; quick rules; end-to-end journey. **Image contents were not independently inspected**; this is a summary of the original README captions, not image conversion.

## Applicability / falsifier
Potential conceptual relevance: DT B7 authenticated mission-consumer and independent governed-cycle proof. **No new verified DT capability or novel implementation gap established.** Compare current private DT's planner/governance/gateway boundaries and current tests before any proposal. If equivalent gate and replay checks already exist, classify ALREADY_PRESENT. B1 owner disposition remains required; this historical document does not authorize history repair. Revisit only on concrete current-source discrepancy or executed negative-test failure.
