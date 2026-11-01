# CL-AUTONOMY-CONTRACT-001 — Historical Agent_X governed autonomous completion contract

**Scope:** A compact, non-executable archival synthesis of two fully read historical Agent_X long-loop directives, not the present DoubleTake execution mission. Both sources were authored as historical planning instructions, **not empirical proof**. The source names and Git blobs below allow exact recovery from repository history. All requirements here are *proposed acceptance criteria*; no current DT parity, live result, or authority is inferred.

| Member | Original source path relative to `doubletake_evolution/scrapyard/` | Exact Git blob | Distinct contribution |
| --- | --- | --- | --- |
| AC-04 | `AGENT_X_AUTONOMOUS_COMPLETION_DIRECTIVE_v4.md` | `1d540d57e6af79c7d8cd5b674f15e3eac175a511` | Original phase-0–10 loop, proof contracts, preflight, recovery, governance, and optional launch prompt example. |
| AC-05 | `AGENT_X_AUTONOMOUS_COMPLETION_DIRECTIVE_v5.md` | `70067f589f82b65d401982296c441a552a2d65f4` | Subsumes the v4 technical body and adds phase 11, independent final-acceptance evaluator, explicit existing-system reuse, extra preflight checks and negative gates. |

**Source comparison:** All v4 technical sections have matching v5 bodies apart from section renumbering, minor wording, one preflight/checkpoint expansion, and the v4-only illustrative invocation snippet (read directive → inspect repository/status → earliest incomplete phase → smallest tested step → evidence → next step; refuse unsupported completion). The v4 snippet is **historical usage context**, not current execution authority. v5 is the more complete source. Both source bodies are recoverable by blob SHA. No third-party code or license has been copied.

## Product thesis and complete pipeline

Historical target: a governed seed that can instantiate or inspect an existing agentic codebase, parse a mission, inventory agents/tools/prompts/provider calls/dependencies/state/tests, derive a capability graph and missing tools, choose single- versus multi-agent structure, produce a transformation plan, apply *permissioned* changes, connect agents, run tests and validation, create provenance/evidence, promote or reject, and roll back. It is neither a scraper/UI/chatbot/framework wrapper nor proof merely because a demo or report exists. One hand-built demo, import-only, compile-only, echo-only, or static report **fails** the full-goal claim. Three genuinely different product proof classes are required after the substrate, with tests, evidence, README, config, run instructions and limitations; candidates include extraction, document intake, research, triage, QA, workflow and orchestration.

**Eleven conjunctive functional proof families (v5 §4):**
1. Control: allowed workspace write succeeds; protected write is blocked *without modifying target*; logged reason, exact verdict, promotion.
2. Self-instantiation: target/manifest/source revision, validated mission, safe acceptance and unsafe rejection.
3. Existing-agent inventory: deterministic dummy codebase; entrypoint/tools/prompts/direct provider imports/dependencies/tests/unsafe imports, machine-readable manifest; invalid target rejected.
4. Capability gap: mission-to-existing capability graph, missing tools/adapters/tests/evidence and risk report.
5. Transformation plan: typed changed files/imports/dependencies/tools/tests/evidence/rollback; malformed plans fail.
6. Permissioned implementation: proposal/adapter, allowed change and denied no-side-effect control, validation and rollback evidence.
7. Multi-agent interop: two dummy agents, manifests, typed handoff, minimal orchestrator, positive and failure-path integration tests.
8. Technology migration: unsafe provider/dependency identified, governed replacement and import/adapter migration, tests, evidence and rollback.
9. Product portfolio: ≥3 different product classes generated/transformed by the system rather than manually assembled, with real runnable proofs and limitations.
10. Report integrity: exact `ACCEPTED` (never substring `NOT_ACCEPTED`), no compile/echo/stale acceptance, consistent source→proof→report→scorecard mapping.
11. **v5 addition:** independent final evaluator rejects missing/incomplete phase/proof/test/evidence, malformed/stale evidence, wrong exact verdict, bypassed LLM boundary, required local external clone paths, hand-built product proof or missing rollback; produces final report and verdict.

## Ordered phase exit contracts (v5 §§5–6; do not skip)

| Phase | Required executable exit evidence and negative |
| --- | --- |
| 0 — thesis/contracts | Thesis, protected manifest, policy/FIC/mission/agent-manifest/handoff schemas, reality audit and loop state; **all** valid and malformed schema fixtures tested. |
| 1 — control | Policy registry accepts valid and rejects malformed; protected write denied without side effects; allowed write succeeds; decision ledger; exact verdict parser rejects `NOT_ACCEPTED`; nontrivial CLI/Makefile proof. |
| 2 — instantiate/intake | CLI creates target and manifest with parent/source revision; validates safe/unsafe missions, records evidence; no absolute local-path dependency. |
| 3 — inventory | Deterministic dummy repo detects entrypoint/tools/prompts/provider imports/dependencies/tests/missing evidence; typed manifest; invalid target negative. |
| 4 — gap graph | Mission requirements vs manifest; missing capability/tool/adapter/test/evidence/risk; deterministic graph/gap-report fixture. |
| 5 — planner | Validated plan schema with create/modify/import/dependency/tool/adapter/test/evidence/policy/rollback fields; malformed/incomplete rejection. |
| 6 — permissioned build | Proposal bundle, controlled file/command adapters (or explicit command denial), allowed and denied patches, no denied side effect; schema/tests/policy/evidence for built tools; rollback metadata. |
| 7 — interop | Validated handoff schema, two inventoried dummy agents, generated contract and orchestrator, success/failure tests, evidence. |
| 8 — verify/promote/rollback | Runner checks policy, schemas, tests, evidence, exact verdict; promotion only for validated proposal; stale/missing/protected-path negatives; source/report mapping and rollback. |
| 9 — portfolio | ≥3 distinct generated/transformed runnable product classes, each tested with evidence, README, config, instructions and limitations. |
| 10 — long-run | Durable loop state, bounded stuck-loop handling, earliest-incomplete-phase selection, fresh-checkout and path-independence tests; no fake-progress or premature no-human-review claims. |
| 11 — **v5-only final evaluator** | Reads phase status/evidence index and per-proof exact verdicts; fails every missing/stale/malformed/compile-only/echo-only/invalid-proof case; only all-proof success yields exact `ACCEPTED` and final completion report. |

## Canonical contracts, outputs, and negative controls

Historical *suggested paths* (not current DT file owners):
- Protected manifest: `configs/protected_core_manifest.yaml`, `schemas/protected_core_manifest.schema.json`, `tools/agentx_evolve/protected_core/`, `tests/test_protected_core_manifest.py`; valid/malformed, protected and allowed paths.
- Policy: `schemas/policy.schema.json`, `tools/agentx_evolve/policy_registry/`, `tests/test_policy_registry.py`; `ALLOW` vs `DENY` with reason and no forbidden side effects.
- FIC: `schemas/fic.schema.json`, `tools/agentx_evolve/fic/`, `tests/test_fic_schema.py`; valid/malformed, allowed/blocked paths, required artifacts.
- Mission: `schemas/mission.schema.json`, `tools/agentx_evolve/mission/`, `tests/test_mission_schema.py`; missing goal, unsafe mission, forbidden actions and required outputs.
- Agent manifest: `schemas/agent_manifest.schema.json`, `tools/agentx_evolve/agent_inventory/`, `tests/test_agent_manifest_schema.py`; entrypoint required, tools/direct provider calls representable.
- Handoff: `schemas/agent_handoff.schema.json`, `tools/agentx_evolve/agent_interop/`, `tests/test_agent_handoff_schema.py`; source/target required, input/output and failure policy.
- Permissioned file adapter: `tools/agentx_evolve/permissioned_actions/file_adapter.py` and `tests/test_permissioned_file_adapter.py`; allowed write, protected `L0/` denial, unchanged denied target, logged decision.
- Evidence and exact verdict: `tools/agentx_evolve/evidence_ledger/`, `tools/agentx_evolve/verdicts/`, `tests/test_evidence_ledger.py`, `tests/test_exact_verdict_parser.py`; missing/malformed verdicts rejected. `ACCEPTED_WITH_WARNINGS`, `PARTIAL`, `UNKNOWN`, `REJECTED`, `NOT_ACCEPTED` all **not accepted**.
- Typed proposal bundle: `proposal.json`, `patch.diff`, `changed_files.json`, `risk_report.json`, `evidence_plan.json`, `validation_plan.json`, `dependency_plan.json`, `rollback_plan.json`. Tool builds additionally need schema, policy, tests, evidence, failure behavior, security boundary, registration, documentation and proof target.
- Machine-readable agent inventory `reports/agent_system_inventory/<target>/agent_manifest.json`: language/framework/package manager, entrypoints, agents, tools, prompts, direct model/provider calls, memory, dependencies, unsafe imports, tests, runtime/deployment assumptions, validation gaps and multi-agent boundaries.
- Gap outputs `reports/capability_graph/{capability_graph,gap_analysis}.json`; plan output `reports/transformation_plans/<plan_id>/transformation_plan.json`. Plan validates mission/current/target summary, files/imports/dependencies, tools/adapters, agents, tests/evidence, policy risk and rollback.
- First interop proof: `research_agent` → typed handoff → `report_writer_agent`, integrated positive and failure tests. Technology migrations (provider adapter, JSON→SQLite, script→tool/CLI, FastAPI/Docker, dependency removal) require explicit reason, risk, changed files/dependencies, tests, evidence and rollback.
- Report integrity: `source module → proof target → report directory → final_verdict.json → scorecard`. Never shrink denominator, delete failures, alter acceptance semantics, or use stale source revision to improve score.

## Long-run orchestration, evidence, and recovery

Historical iteration algorithm: inspect directive, shallow tree, `git status`, loop state, existing validators/CLI/tests/reports/scorecards; find **earliest** phase with unmet executable exit; prefer smallest vertical slice (one schema/adapter/CLI/proof target with tests and evidence) over broad scaffolding; run focused unit → schema/negative → integration → phase proof → relevant broader regression. Reuse existing modules, naming, verifiers, evidence, report formats, Makefile/CLI and schema locations; a parallel policy engine, ledger, scorecard, CLI or duplicate module requires explicit justification. Protect unrelated uncommitted changes and do not commit unless authorized.

Suggested durable `reports/agentx_autonomous_loop/` files: `loop_state.json`, `iteration_log.jsonl`, `current_phase.json`, `current_reality_audit.json`, `evidence_index.json`, `blocked_items.json`, `phase_gate_status.json`, `run_summary.md`. State records phase/status/last step/next step/blocker/reason/human review/last verdict; each iteration records selected step, reason, changed files, tests, evidence, verdict, next step and limitations. Recover after context loss from these persisted records, git status and recent reports, **not** by restarting already verified work. Refresh phase status every five iterations or on phase completion; every criterion requires test/evidence pointer and overall `PARTIAL` until all pass.

Stuck loop: after three failures for same reason, record blocker, stop that approach, choose smaller same-phase fallback or nearest prerequisite; never mark complete. After two documentation-only changes, choose executable work or document the actual blocker. Unrunnable tests → `PARTIAL` with reason, never accepted. Priority for next step: enforcement → schema validation → negative test → evidence → callable entrypoint → existing proof integration → documentation of already-working behavior. Do not run unrelated expensive suites without a reason.

Protected examples: `L0/`, `policies/`, `policy_registry/`, `promotion_gate/`, scorecard/verifier/evidence/final gates, secrets, `.env`, credentials, deployment settings. Read allowed; modification only under phase, existing policy, controlled proposal/adapter, tests, evidence and promotion; before policy exists, limit to minimal initial manifest/schema/validator. Machine-readable policy, permissioned actions, negative tests, evidence, promotion and rollback are prerequisites to any reduced-human-review claim. No live integrity history repair, permission expansion or autonomous self-grant follows from this historical text.

LLM boundary: generated/transformed components must use an Agent_X-approved LLM adapter rather than direct provider calls absent explicit policy; historical forbidden examples include `openai`, `anthropic`, `cohere`, `mistral`, `groq`, `google.generativeai` and external framework provider routing. Deterministic fixtures first. External Hermes architecture may inform patterns only with license/source commit, copied extent, destination, path-independence and boundary tests recorded in `reports/hermes_usage/hermes_usage_decision.json`; no external clone/runtime path, wholesale fork, AGPL/unclear license, gateway or unrelated feature. Any new dependency must justify standard-library alternative, license, runtime/test impact and optional/core status.

**Final acceptance (v5 §38):** `agentx final-acceptance` or repo-native equivalent reads `phase_gate_status.json`, `evidence_index.json`, `run_summary.md`, and `reports/*/final_verdict.json`; rejects missing phases/proofs/tests/artifacts, stale/malformed evidence, any non-exact `ACCEPTED`, compile/echo-only and hand-built product proofs, direct-provider/clone dependency and missing rollback. Outputs `reports/agentx_final_completion/final_completion_report.json` and `final_verdict.json` only on verified all-proof success.

## Distinctions, limits and DT relevance

- **Complementary evolution:** v4's short illustrative launch prompt was dropped in v5; v5 added reuse discipline and a distinct all-phases final evaluator. There is no conflict requiring two working copies.
- **Potential relevance:** mission receipt, durable state, no-loss evidence chain, independent acceptance and safe governed recovery; *not* evidence of a natural autonomous DT cycle. Mapping to current DT requires canonical owner/consumer and current tests; old Agent_X paths/phase ordering must **not** override DT `ACTIVE_MISSION.md`.
- **Negative/unknown:** no source-versioned live DT result, owner-authorized B1 disposition, authenticated local scheduler→DT receipt, or independent external assimilation Ground supplied by either source. The two historical directives may be internally consistent but cannot prove implementation. Do not treat the historical suggestion to reduce human review as permission to bypass current governance.
- **Small falsifiable Director-only research test:** with existing authorized disposable DT fixture, freeze mission blob and consumer identity; verify receipt, run/evidence binding, truthful incomplete/refusal classification, negative replay/stale/wrong-revision controls, independent readback and restart. If no actual local consumer exists, label `NO_AUTHORIZED_FIXTURE`, not `ACCEPTED`. Existing DT tests may already cover this; compare parity first. No new DT code or private text published.
- **Revisit trigger:** verified current canonical caller/test mapping or a real consumer/run receipt; historical source blob recoverable by SHA if nuance is later needed.

**Authority:** This canonical record is archival research only, not a live coding-agent instruction, a promotion gate, or approval for changing private DT. Source provenance is maintained by Git history and the original blob SHAs above.
