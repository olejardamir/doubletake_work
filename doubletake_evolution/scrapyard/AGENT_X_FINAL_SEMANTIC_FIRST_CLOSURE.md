# Historical Agent_X semantic-first governance — compact verification contract

**Provenance:** This is a historical Agent_X proposal, not current DT authorization or implementation evidence. Full original blob `2f5b495de7b5c436d87d9cafe75e28901c2e348c`; immediately preceding working blob `c54fa68f5bfad4b943f05b0f84318a75ca1f14e8`, both recoverable in Git history. Historical Agent_X revision `248f2edac494e0ddafead2fd69a9e9e4cf034eba`. Historical source contained partially truncated clauses; do not interpret their omissions as accepted design. Current DT parity and actual test results UNKNOWN.

## Transferable invariants

- Separate deterministic code facts from governed semantic interpretation. A canonical semantic model must distinguish `verified`, `inferred`, `unknown`, `unresolved`, `conflicted`, and must not declare `SYNCED` on evidence gathering, incomplete enrichment or unverified structural heuristics alone.
- A normal write-capable UI/API/CLI/MCP/agent invocation must create or reference its own valid semantic transaction before dispatch. Natural-language write-intent classification is advisory; technically enforced read-only execution may bypass write transaction, but no write-capable tool may inherit authority from a read-only label.
- Bind authority to request/run, workspace and epoch, semantic change/overlay digest, synchronized implementation and semantic baselines, target digest, exact write set, policy and conflict identity. Revalidate at the actual mutation boundary; stale backend, revoked transaction, changed target, wrong scope or missing evidence fail closed.
- Mutation origins (UI, Codex/OpenCode, shell/Git/subprocess, REST, MCP, Harvest, autonomous repair/evolution, subagents) must not evade the same effect-time gate. Where external edits cannot be prevented, detect out-of-band drift and quarantine rather than silently accepting it.
- Canonical model/history writes are transactional and isolated from tests, fixtures, dry runs and derived indexes. Commit only after verification and reconciliation; preserve stable semantic identity across behavior-preserving refactors, refresh affected scope, and reject false `SYNCED` from non-existent APIs or stale indexes.
- Separate current semantics from proposed target, and classify `IMPLEMENTATION_AHEAD`, `SEMANTIC_AHEAD`, `BOTH_DIVERGED`, `PARTIAL_IMPLEMENTATION`, `STALE_BASE` without choosing an unverified winner. Bind conflict resolution to the recorded common base and exact conflict; concurrent overlapping changes must not silently overwrite.
- Provider success is not accepted task success. Require actual verification, reconciliation, canonical promotion and independent effect evidence before terminal success. Durable interrupted transactions must resume or roll back without false acceptance.
- Implementation form (prompt-only, prompt plus deterministic enforcement, deterministic code) is a governed semantic choice; no new parallel owner/authority is implied.

## Historical verification matrix (proposed, NOT executed)

- A: UI write request creates semantic transaction
- B: UI read-only request
- C: Ambiguous request + write-capable runtime
- D: Old unrelated transaction
- E: Wrong write set
- F: Missing semantic authorization
- G: Semantic-first failure
- H: Borg dependency
- I: Stale backend
- J: Missing startup binding
- K: Revision-check failure
- L: Restart
- M: Canonical pollution
- N: False SYNC regression
- O: Semantic-generation incomplete
- P: Full round trip
- Q: Out-of-band implementation drift
- R: Out-of-band semantic drift
- S: Both sides diverged
- T: Partial implementation and stale base
- U: Initial semantic bootstrap
- V: Incremental semantic refresh
- W: Refactor identity stability
- X: Concurrent transaction isolation
- Y: Direct shell/Git bypass attempts
- Z: Semantic-file direct edit bypass
- AA: No-change/reject semantic decision
- AB: Exact verification binding and replay rejection
- AC: Interrupted transaction recovery
- AD: UI terminal-success ordering
- AE: Derived semantic index disagreement
- AF: Authorization revocation/reuse
- AG: TOCTOU stale authorization
- AH: Mutation-origin matrix
- AI: Whole-project coverage audit
- AJ: Delete/replace lifecycle
- AK: Ownership/relationship semantic quality
- AL: Recovery-mode containment

For each case require actual production entrypoint/consumer, positive and negative controls, isolated canonical state, exact source/revision/evidence binding, fail-closed rejection and a real observed outcome. A helper, enum, import, fixture label or provider success is not proof. Historical targets included `tools/agentx_evolve/api/chat.py`, `api/sessions.py`, `semantic_first/{interceptor,pipeline,project_model,enrichment,synchronization,reconcile_harvest}.py`, `workflow_governance/checkpoints.py`, `collective_core/borg_collective_orchestrator.py`, `semantic_project/{project_model,semantic_code_sync}.json`; verify current existence before any use.

## Unknowns / transfer gate

Historical text's detailed A–AL expected outputs and several numbered requirements were incomplete in the preceding reduced working copy. Recover the original blob for exact test implementations before implementation or deletion of further evidence. Compare to current DT owners and active mission, use a bounded authorized fixture, preserve protected history, and demand real test and consumer receipts. No verified B1 resolution, B7 mission consumption, autonomous natural cycle, or DT Ground is asserted.
