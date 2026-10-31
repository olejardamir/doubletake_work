# Agent_X Full Gap Closure Prompt: Hermes-Assisted Path to 100% Strict Full-Repo Coverage

## Purpose

This document is a handoff for the next Agent_X work pass.

The current state should be treated as:

- **Agent_X internal MVP:** accepted / serious internal MVP system.
- **Estimated practical internal-MVP maturity:** approximately **75–82%**.
- **Strict full-repo module accounting:** **65.35%**.
- **Strict full-repo status:** **NOT_ACCEPTED**.
- **Goal of this work:** close **all** strict full-repo module gaps through repeated evidence-backed passes until strict full-repo acceptance is honestly achieved, not by gaming the scorecard.

The local Hermes reference repositories are already cloned here:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Use these repositories as **reference implementations and optional selective source material**, not as a wholesale replacement for Agent_X.

---

## Core Rule

Do **not** turn Agent_X into a Hermes fork.

Agent_X should remain a governed self-evolution / proof / promotion / reproducibility framework.

Hermes can help with runtime maturity, including:

- provider abstraction
- tool registry patterns
- terminal/backend abstraction
- session persistence
- plugin structure
- cron/scheduled agent work
- skill/self-evolution patterns
- evaluation and before/after metrics

But the Agent_X proof model, scorecard, final gates, promotion boundary, and governance layer must remain Agent_X-native.

---

## Current Problem

The latest evaluation showed a split:

| Scope | Status |
|---|---|
| Internal MVP proof scope | Accepted |
| Full repo strict coverage | 65.35% |
| Full repo claim | Not allowed |
| Production-ready claim | Not allowed |
| Main issue | Many modules are still scaffold-only, compile-only, missing proof, or blocked in the scorecard |

The next work should chase **real 100% strict full-repo closure**, not a fake 100%. Every remaining blocked module must either be honestly closed or explicitly reported as impossible/unsafe with exact reasons. It should close real modules with:

1. executable module CLI
2. behavioral proof
3. negative test or anti-gaming check where appropriate
4. `reports/<module>/final_verdict.json`
5. Makefile proof target
6. scorecard integration
7. deterministic/reproducible proof output
8. no provider-key leakage
9. no unsupported production claim

---

## What to Borrow from Hermes

### Borrow as Architecture Patterns

Use Hermes primarily as a design reference for these areas:

| Agent_X gap area | Hermes area to inspect | How to use |
|---|---|---|
| Tool adapter / tool registry | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/registry.py`, `model_tools.py`, tools runtime docs | Borrow registry pattern, not the full tool inventory |
| Provider/model abstraction | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/runtime_provider.py`, `models.py`, `auth.py` | Borrow provider-resolution shape, but keep provider keys outside proofs |
| Session state / replay | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_state.py` | Borrow SQLite/session-lineage ideas if useful |
| Execution environments | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/environments/` | Borrow backend abstraction ideas for local/docker/ssh-style execution |
| Plugins | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/plugins.py` | Borrow extension-boundary pattern |
| Cron/scheduled work | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/cron/` | Borrow scheduler concepts only after core proof closure |
| Self-evolution pipeline | `/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/` | Borrow external optimizer pattern, not uncontrolled code mutation |

### Borrow as Code Only When Necessary

Direct code borrowing is allowed only if all of the following are true:

- The code is MIT-compatible.
- The copied portion is small and targeted.
- The copied code closes a named Agent_X gap.
- Attribution is preserved.
- The copied code is adapted to Agent_X interfaces.
- The code is covered by Agent_X tests and proof reports.
- The code does not introduce provider keys, unbounded network calls, hidden background execution, or production-ready claims.

### Do Not Borrow

Do **not** borrow or import:

- Hermes as a direct runtime dependency.
- The whole Hermes app.
- The whole Hermes gateway.
- Provider-key handling as-is.
- Any code that forces specific model providers.
- Any code that makes Agent_X depend on Nous Portal, OpenAI, Anthropic, OpenRouter, or similar services.
- Darwinian Evolver into Agent_X core.
- AGPL code into Agent_X core.
- Anything that changes Agent_X’s governance, final acceptance, or promotion semantics to make the score look better.

---

## Full-Closure Driver Loop

The previous version of this prompt was strong for a bounded improvement pass, but not complete enough for closing all gaps. The working instruction must now be:

```text
Do not stop at 72%, 75%, 80%, or 90% if more work can be done safely.
Continue closing strict full-repo gaps in repeated batches until:
1. blocking_report_count == 0
2. accepted_modules == total_modules
3. scaffold_only_modules == 0
4. strict_full_repo_status == "ACCEPTED"
5. strict_full_repo_claim_allowed == true
6. final acceptance hard gate accepts the full repo scope
7. no unsupported production-ready claim is introduced
```

If full closure cannot be completed in the current run, the system must stop only after producing an honest, machine-readable remainder report.

Create or update:

```text
reports/full_repo_closure_driver/
reports/full_repo_closure_driver/final_verdict.json
reports/full_repo_closure_driver/closure_driver_report.json
```

The closure driver report must include:

```json
{
  "report_type": "full_repo_closure_driver",
  "starting_strict_full_repo_progress_percent": 65.35,
  "ending_strict_full_repo_progress_percent": "<new value>",
  "starting_accepted_modules": 264,
  "ending_accepted_modules": "<new value>",
  "starting_total_modules": 404,
  "ending_total_modules": "<new value>",
  "starting_blocking_report_count": 140,
  "ending_blocking_report_count": "<new value>",
  "closed_this_run": ["<module>", "..."],
  "still_blocking": ["<module>", "..."],
  "impossible_or_deferred": [
    {
      "module": "<module>",
      "reason": "<exact reason>",
      "required_next_action": "<specific action>"
    }
  ],
  "hermes_references_used": [
    {
      "agent_x_module": "<module>",
      "hermes_path": "<path>",
      "usage": "pattern_only | small_code_adapted | not_used",
      "license_attribution_required": true
    }
  ],
  "claim_integrity": {
    "internal_mvp_claim_preserved": true,
    "full_repo_claim_allowed_only_if_all_modules_pass": true,
    "production_claim_allowed": false
  }
}
```

The closure loop must follow this logic:

1. Read current scorecard.
2. Build exact gap inventory.
3. Select a bounded batch of highest-leverage gaps.
4. Close the batch with real module CLIs, reports, tests, negative cases, and Makefile proof targets.
5. Run proof targets.
6. Regenerate scorecard.
7. Re-read the updated scorecard.
8. Repeat until full strict closure or until blocked by a genuine external constraint.
9. Write a closure-driver report.
10. Write a human-readable before/after summary.

Do not add new modules unless required. If a new module is added, it must be mapped, proved, and included honestly in the denominator.

Do not lower the denominator by deleting or hiding blocked modules.

Do not change `NOT_ACCEPTED` parsing semantics. Negative verdicts must always be checked before positive substrings.

---

## False-Positive Acceptance Hardening

Strict full-repo closure is not complete if the scorecard reaches 100% by accepting weak reports. Agent_X must also detect and harden false-positive accepted modules.

A module is **weakly accepted** and must be rechecked if any of these are true:

1. Its Makefile target runs only `compileall` and echo.
2. Its `final_verdict.json` has `verdict: ACCEPTED` but no meaningful `checks`.
3. Its `checks` array is empty and there is no separate behavioral report.
4. Its evidence list is empty.
5. Its report was generated only by a generic migration utility without module-specific behavior.
6. Its `source_commit` or `committed_as_commit` is stale relative to the current HEAD, unless the timestamp/commit is deliberately normalized by a reproducibility proof.
7. Its report lacks negative tests for a module that enforces a boundary, gate, sandbox, policy, adapter, provider, or proof.
8. Its CLI cannot regenerate the report deterministically.
9. Its proof does not fail when given an intentionally bad fixture.
10. Its target can pass while the module is missing, empty, or semantically broken.

Create or update:

```text
tools/agentx_evolve/false_positive_acceptance_audit/
reports/false_positive_acceptance_audit/
reports/false_positive_acceptance_audit/final_verdict.json
reports/false_positive_acceptance_audit/false_positive_acceptance_audit_report.json
```

The audit must scan:

```text
Makefile
tools/agentx_evolve/*/
reports/*/final_verdict.json
reports/progress_scorecard/*.json
```

It must classify every accepted module as one of:

```text
STRONG_ACCEPTED
WEAK_ACCEPTED_NEEDS_HARDENING
STALE_ACCEPTED_NEEDS_RERUN
COMPILE_ONLY_ACCEPTED
MIGRATION_ONLY_ACCEPTED
MISSING_BEHAVIORAL_EVIDENCE
MISSING_NEGATIVE_CASE
```

The audit itself must not automatically flip verdicts unless the existing Agent_X conventions support that. But the closure driver must treat weak accepted modules as closure work, not as finished work.

A true 100% claim requires:

```text
blocking_report_count == 0
scaffold_only_modules == 0
weak_accepted_module_count == 0
compile_only_accepted_module_count == 0
migration_only_accepted_module_count == 0
stale_accepted_module_count == 0
missing_negative_case_required_count == 0
```

If the scorecard says 100% but this audit finds weak accepted modules, the correct overall verdict is:

```text
PARTIAL / NOT_FULLY_ACCEPTED
```

---

## Full-Repo Hard Gate Upgrade

The current final acceptance hard gate may be internal-MVP scoped. That is not enough for strict 100% full-repo closure.

Create or update a separate full-repo hard gate:

```text
tools/agentx_evolve/final_full_repo_acceptance_gate/
reports/final_full_repo_acceptance_gate/
reports/final_full_repo_acceptance_gate/final_verdict.json
reports/final_full_repo_acceptance_gate/final_full_repo_acceptance_report.json
```

This gate must validate:

1. Every module counted by the scorecard has a Makefile proof target or an explicit justified waiver.
2. Every proof target runs more than compileall unless the module is a pure static artifact and has a justified static-proof waiver.
3. Every accepted module has fresh or reproducibly normalized evidence.
4. Every boundary/gate/security/policy/provider/sandbox module has a negative case.
5. Every report referenced by the scorecard exists and is valid JSON.
6. No scorecard denominator manipulation occurred.
7. No blocking modules remain.
8. No scaffold-only modules remain.
9. No weak accepted modules remain according to `false_positive_acceptance_audit`.
10. Internal-MVP acceptance remains intact.
11. Full-repo claim is allowed only if all full-repo checks pass.
12. Production claim remains false unless separately proven.

The final full-repo gate must be the last gate used for a 100% claim. Internal-MVP hard gate acceptance alone is insufficient.

Expected final full-repo gate verdict shape:

```json
{
  "report_type": "final_verdict",
  "verdict": "ACCEPTED",
  "errors": [],
  "full_repo_scope": true,
  "total_modules_checked": "<number>",
  "accepted_modules": "<number>",
  "blocking_report_count": 0,
  "scaffold_only_modules": 0,
  "weak_accepted_module_count": 0,
  "compile_only_accepted_module_count": 0,
  "migration_only_accepted_module_count": 0,
  "stale_accepted_module_count": 0,
  "missing_negative_case_required_count": 0,
  "internal_mvp_acceptance_preserved": true,
  "strict_full_repo_claim_allowed": true,
  "production_claim_allowed": false
}
```

---

## Module Closure Quality Standard

A module is not truly closed merely because `final_verdict.json` says `ACCEPTED`.

Each module closure must satisfy this quality standard:

| Module type | Required positive proof | Required negative proof |
|---|---|---|
| Runtime / core product | Executes a deterministic fixture successfully | Rejects invalid input or broken state |
| Adapter / provider / model | Resolves a valid fake/local descriptor | Rejects unknown provider/model and avoids provider key leakage |
| Tool / MCP / connector | Registers and dispatches allowed tool schema | Rejects malformed, unknown, or undeclared capability |
| Policy / governance | Accepts compliant fixture | Rejects forbidden fixture |
| Sandbox / security | Allows safe fixture | Blocks unsafe command, path, or egress |
| Evidence / audit | Replays valid evidence | Detects missing, stale, corrupted, or contradictory evidence |
| Evaluation / benchmark | Passes deterministic benchmark | Detects regression or below-threshold candidate |
| Reproducibility | Re-runs with same output | Detects dirty non-proof artifact or nondeterminism |
| Production boundary | Allows internal-MVP claim | Rejects production-ready claim unless separately proven |
| Documentation | Aligns documented claim with proof | Detects unsupported claim |

Every module-specific report should contain:

```json
{
  "module": "<module>",
  "positive_fixture": "<name>",
  "negative_fixture": "<name or not_required_with_reason>",
  "checks": [
    {"name": "...", "passed": true}
  ],
  "anti_gaming": {
    "static_acceptance_only": false,
    "echo_only_target": false,
    "compile_only_target": false,
    "stale_report": false,
    "unsupported_claim": false
  }
}
```

---

## Waiver Policy

Some modules may be pure static artifacts or compatibility aliases. Do not hide them. Use explicit waivers.

Create or update:

```text
reports/module_waiver_registry/
reports/module_waiver_registry/final_verdict.json
reports/module_waiver_registry/module_waiver_registry_report.json
```

A waiver is valid only if it includes:

```json
{
  "module": "<module>",
  "waiver_type": "alias_only | static_artifact | deprecated_with_replacement | intentionally_out_of_scope",
  "replacement_or_parent_module": "<module or null>",
  "reason": "<specific reason>",
  "expires": "<date or milestone>",
  "approved_for_full_repo_closure": true,
  "proof_that_it_should_not_count_as_gap": "<evidence path>"
}
```

Waivers must be rare. They cannot be used to bypass real implementation work.

A 100% claim can include waived modules only if the scorecard and full-repo hard gate explicitly account for them without hiding them.

---

## Denominator and Mapping Integrity

Before and after every closure batch, record:

```text
total_modules
accepted_modules
not_accepted_modules
scaffold_only_modules
blocking_report_count
dimension_scores
new_modules_added
modules_removed
modules_renamed
modules_reclassified
```

If `total_modules` changes, write an explanation. Do not reduce the denominator by deleting, hiding, renaming, or reclassifying modules without a justified mapping report.

Create or update if needed:

```text
reports/scorecard_denominator_integrity/
reports/scorecard_denominator_integrity/final_verdict.json
reports/scorecard_denominator_integrity/scorecard_denominator_integrity_report.json
```

A full closure claim requires denominator integrity to be accepted.

---

## Parser, Mapping, and Attribution Integrity

A full gap-closure prompt must also prevent three subtle failure modes:

1. **Verdict parser bug:** `NOT_ACCEPTED` contains the substring `ACCEPTED`. Any verifier or scorecard parser must compare exact enum values, not substrings.
2. **Source/report mismatch:** a module can exist in source but not in Makefile, Makefile but not in reports, reports but not in scorecard, or scorecard but not in source.
3. **Untracked borrowed code:** Hermes code may be MIT-compatible, but copied code still needs attribution and provenance.

Create or update these integrity reports if they do not already exist:

```text
reports/verdict_parser_integrity/
reports/verdict_parser_integrity/final_verdict.json
reports/verdict_parser_integrity/verdict_parser_integrity_report.json

reports/source_report_bijection/
reports/source_report_bijection/final_verdict.json
reports/source_report_bijection/source_report_bijection_report.json

reports/third_party_code_attribution/
reports/third_party_code_attribution/final_verdict.json
reports/third_party_code_attribution/third_party_code_attribution_report.json
```

The verdict parser integrity report must prove:

```text
"ACCEPTED" -> accepted
"NOT_ACCEPTED" -> not accepted
"REJECTED" -> not accepted
"PARTIAL" -> not accepted
"ACCEPTED_WITH_WARNINGS" -> not accepted unless explicitly supported
missing verdict -> not accepted
malformed JSON -> not accepted
```

The source/report bijection report must prove every module relationship:

```text
source module -> Makefile target -> report directory -> final_verdict.json -> scorecard entry
```

and must list all exceptions as explicit waivers.

The third-party attribution report must prove that any copied Hermes code has:

```text
original repository
original file path
original commit/ref if known
license
copied/adapted destination path
extent of copying: pattern_only | small_code_adapted | substantial_copy
attribution location
```

If code is copied, create or update an attribution file such as:

```text
THIRD_PARTY_NOTICES.md
docs/third_party/hermes_agent_attribution.md
```

Pattern-only inspiration does not require code attribution, but the report should still record the reference path when Hermes materially influenced a closure.

---

## Fresh Checkout, CI/Local Equivalence, and Path Independence

Strict full-repo closure is not complete if it only works in the current dirty working tree or depends on local absolute paths.

The local Hermes repositories may be used as references during development:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

But final Agent_X code must not require those paths to exist.

Create or update:

```text
reports/fresh_checkout_full_repo_acceptance/
reports/fresh_checkout_full_repo_acceptance/final_verdict.json
reports/fresh_checkout_full_repo_acceptance/fresh_checkout_full_repo_acceptance_report.json

reports/ci_local_equivalence_full_repo/
reports/ci_local_equivalence_full_repo/final_verdict.json
reports/ci_local_equivalence_full_repo/ci_local_equivalence_full_repo_report.json

reports/local_path_independence/
reports/local_path_independence/final_verdict.json
reports/local_path_independence/local_path_independence_report.json
```

The fresh-checkout acceptance proof must show that a clean checkout can run the full proof sequence without relying on untracked files, local cache state, or generated artifacts that were not committed.

The CI/local equivalence proof must show that the local proof command and CI proof command execute the same gating targets and interpret verdicts the same way.

The local-path independence proof must scan source, Makefile, docs used by proof, and reports for forbidden hard dependencies on:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Those paths may appear only in documentation/provenance/reference fields, not in runtime imports, proof-critical code, required config, or Makefile execution paths.

A true 100% full-repo claim requires:

```text
fresh_checkout_full_repo_acceptance == ACCEPTED
ci_local_equivalence_full_repo == ACCEPTED
local_path_independence == ACCEPTED
```

---

## Main Work Strategy

### Phase 1 — Build a Real Gap Inventory

First, read the current scorecard outputs and construct an exact gap list.

Inspect these files:

```text
reports/progress_scorecard/final_verdict.json
reports/progress_scorecard/progress_scorecard_report.json
reports/progress_scorecard/dimension_scores_report.json
reports/progress_scorecard/adjusted_progress_report.json
reports/final_acceptance_hard_gated/final_verdict.json
```

Extract:

- total modules
- accepted modules
- not accepted modules
- scaffold-only modules
- blocking reports
- dimension scores
- strict full-repo status
- internal MVP status
- production claim status

Then create or update:

```text
reports/full_repo_gap_inventory/
reports/full_repo_gap_inventory/final_verdict.json
reports/full_repo_gap_inventory/gap_inventory_report.json
reports/false_positive_acceptance_audit/final_verdict.json
reports/false_positive_acceptance_audit/false_positive_acceptance_audit_report.json
reports/scorecard_denominator_integrity/final_verdict.json
reports/scorecard_denominator_integrity/scorecard_denominator_integrity_report.json
reports/final_full_repo_acceptance_gate/final_verdict.json
reports/final_full_repo_acceptance_gate/final_full_repo_acceptance_report.json
```

The gap inventory should include every currently blocked module grouped by dimension:

- API Surface
- Core Product
- Evaluation
- Evidence
- Production Readiness
- Reproducibility
- Uncategorized

Each gap entry should include:

```json
{
  "module": "<module_name>",
  "dimension": "<dimension>",
  "current_status": "NOT_ACCEPTED | SCAFFOLD_ONLY | MISSING | COMPILE_ONLY",
  "likely_reason": "<short reason>",
  "closure_type": "behavioral_cli | proof_report | negative_test | makefile_target | scorecard_mapping | docs_alignment | reproducibility",
  "priority": "P0 | P1 | P2",
  "hermes_reference": "<path or null>",
  "expected_output": "reports/<module>/final_verdict.json"
}
```

Do not proceed randomly. Use this inventory to choose the next modules.

---

### Phase 2 — Close High-Impact Dimensions First

The previous dimension distribution was approximately:

| Dimension | Total | Accepted | Not accepted | Scaffold only | Score |
|---|---:|---:|---:|---:|---:|
| API Surface | 19 | 17 | 2 | 0 | 89.47% |
| Architecture | 1 | 1 | 0 | 0 | 100% |
| Controlled Evolution | 2 | 2 | 0 | 0 | 100% |
| Core Product | 130 | 89 | 39 | 2 | 68.46% |
| Documentation Alignment | 1 | 1 | 0 | 0 | 100% |
| Evaluation | 22 | 15 | 7 | 0 | 68.18% |
| Evidence | 34 | 24 | 10 | 0 | 70.59% |
| Final Acceptance | 1 | 1 | 0 | 0 | 100% |
| Governance | 1 | 1 | 0 | 0 | 100% |
| Production Readiness | 71 | 40 | 31 | 0 | 56.34% |
| Reproducibility | 66 | 33 | 30 | 3 | 50.00% |
| Uncategorized | 56 | 40 | 16 | 0 | 71.43% |

Priority order:

1. **API Surface** — close the last 2 if still blocked.
2. **Evaluation** — close the remaining benchmark/eval modules because they help prove other closures.
3. **Evidence** — close evidence integrity, audit, and replay-related modules.
4. **Reproducibility** — close clean checkout, dependency, workspace, runtime-state, and replay gaps.
5. **Core Product** — close real runtime modules, especially those related to tool/model/context/session/adapters.
6. **Production Readiness** — close internal-MVP production boundary modules, but do not claim real production-ready.
7. **Uncategorized** — either map correctly to dimensions or close with real proof.

---

### Phase 3 — Convert Compile-Only Targets Into Behavioral Proof Targets

Many modules may currently have Makefile targets that only do this pattern:

```make
prove-some-module:
	$(PYTHON) -m compileall -q tools/agentx_evolve/some_module
	@echo "=== prove-some-module: OK ==="
```

That is not enough for strict closure.

For each selected module, upgrade it to this pattern:

```make
prove-some-module:
	$(PYTHON) -m compileall -q tools/agentx_evolve/some_module
	PYTHONPATH=.:tools $(PYTHON) -m tools.agentx_evolve.some_module.cli --output reports/some_module
	PYTHONPATH=.:tools $(PYTHON) -m tools.agentx_evolve.make_helpers.prove_verifier some_module reports/some_module
	@echo "=== prove-some-module: OK ==="
```

The module CLI should write at least:

```text
reports/some_module/final_verdict.json
reports/some_module/<module_specific_report>.json
```

Minimum accepted `final_verdict.json` shape:

```json
{
  "report_type": "final_verdict",
  "generated_at": "REPRODUCIBLE_OR_NORMALIZED_TIMESTAMP",
  "verdict": "ACCEPTED",
  "errors": [],
  "checks": [
    {"name": "positive_behavior", "passed": true},
    {"name": "negative_behavior", "passed": true},
    {"name": "deterministic_output", "passed": true}
  ],
  "evidence": [
    "reports/some_module/<module_specific_report>.json"
  ],
  "claim_scope": "internal_mvp",
  "production_claim_allowed": false
}
```

If a module cannot honestly be accepted, report `NOT_ACCEPTED` with exact errors. Do not force acceptance.

---

### Phase 4 — Hermes-Informed Module Closures

Use the Hermes repos only as targeted references.

#### Tool Registry / Tool Adapter Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/registry.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/model_tools.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/toolsets.py
```

Use these ideas to close Agent_X modules such as:

- `tool_adapter`
- `tool_exposure_boundary`
- `mcp`
- `external_connector_governance`
- `plugin_governance`
- `command_sandbox_runner`
- `source_adapters`

Expected Agent_X proof:

- registers tools by explicit contract
- validates schemas
- rejects malformed tool specs
- rejects unknown tools
- records evidence
- proves no hidden provider import
- proves no unbounded shell/network access

#### Provider / Model Adapter Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/runtime_provider.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/models.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/auth.py
```

Use these ideas to close Agent_X modules such as:

- `model_adapter`
- `model_runtime`
- `local_model_runtime_profile`
- `llm_worker`
- `providers`

Expected Agent_X proof:

- provider-neutral model descriptor
- local/offline provider option
- no direct provider API key references in proof path
- deterministic fake provider for tests
- negative test for unknown provider/model
- no production claim

#### Session / Replay / State Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_state.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/gateway/session.py
```

Use these ideas to close Agent_X modules such as:

- `session_state`
- `state_store`
- `runtime_state_store`
- `replay_evidence`
- `state_consistency_audit`
- `run_ledger`
- `session_dependency_graph`

Expected Agent_X proof:

- deterministic session IDs in fixtures
- append-only event log
- replay from recorded events
- corruption detection
- missing-event detection
- idempotent re-run proof

#### Execution Environment / Sandbox Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/environments/
```

Use these ideas to close Agent_X modules such as:

- `execution_environment`
- `runtime_sandbox`
- `workspace_isolation`
- `command_sandbox_runner`
- `network_egress_guard`
- `security_sandbox`

Expected Agent_X proof:

- local deterministic sandbox fixture
- denied dangerous commands
- denied unapproved network egress
- workspace boundary enforced
- clear audit log
- no real external side effects during tests

#### Plugin / Extension Boundary Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/plugins.py
```

Use these ideas to close Agent_X modules such as:

- `plugin_governance`
- `external_connector_governance`
- `integration_packs`
- `third_party_integration`

Expected Agent_X proof:

- plugin manifest validation
- capability whitelist
- rejected undeclared capability
- rejected unsafe lifecycle hook
- deterministic plugin loading order
- audit evidence

#### Self-Evolution / Evaluation Modules

Inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Especially:

```text
PLAN.md
README.md
evolution/skills/evolve_skill.py
evolution/core/constraints.py
evolution/core/dataset_builder.py
evolution/core/fitness.py
```

Use these ideas to close Agent_X modules such as:

- `evaluation_harness`
- `benchmark_scriptor`
- `change_benchmark_corpus`
- `selective_test_planner`
- `candidate_test_executor`
- `candidate_review_gate`
- `prompt_variation_executor`
- `self_evolution_orchestrator`
- `evolution_acceptance`
- `risk_classification_engine`
- `task_complexity_estimator`

Expected Agent_X proof:

- baseline vs candidate comparison
- holdout tests
- deterministic fixture dataset
- negative regression case
- constraint validation
- PR/human-review boundary
- no direct auto-merge
- no production mutation without promotion gate

---

## Acceptance Criteria for This Pass

This pass is successful only if it does all of the following:

1. Creates a fresh full-repo gap inventory.
2. Closes a meaningful number of blocked modules with real behavioral proof.
3. Avoids changing scorecard semantics merely to inflate coverage.
4. Preserves the internal-MVP vs full-repo distinction.
5. Preserves `production_claim_allowed = false` unless actual production-readiness evidence exists.
6. Adds or improves Makefile proof targets for selected modules.
7. Adds deterministic reports.
8. Adds negative tests or anti-gaming checks where appropriate.
9. Runs the relevant proof targets.
10. Regenerates scorecard reports.
11. Produces a before/after summary.

Target for this work:

```text
strict_full_repo_progress_percent: 65.35% -> 100.00%
accepted_modules: 264 -> total_modules
blocking_report_count: 140 -> 0
scaffold_only_modules: 5 -> 0
strict_full_repo_status: NOT_ACCEPTED -> ACCEPTED
strict_full_repo_claim_allowed: false -> true
```

Intermediate milestones such as 72%, 75%, 80%, 90%, and 95% are useful checkpoints only. They are not the final goal.

Do not claim 100% unless every strict full-repo module is actually accepted, every scaffold-only module is resolved, the blocking list is empty, no weak accepted modules remain, denominator integrity is accepted, and the final full-repo hard gate agrees.

---

## Do Not Do These Things

Do not:

- Replace Agent_X with Hermes.
- Vendor the full Hermes repo into Agent_X.
- Import Hermes as a runtime dependency.
- Copy large files without attribution.
- Pull in AGPL code into Agent_X core.
- Add provider API keys or provider env var checks into proof-critical code.
- Make proof reports say `ACCEPTED` without real checks.
- Change the scorecard to hide blocking modules.
- Delete blocking modules from the inventory just to raise percentage.
- Mark production-ready unless production-readiness evidence exists.
- Run uncontrolled self-evolution on code without tests and review.
- Add broad new architecture before closing known gaps.

---

---

## All-Gap Completeness Checklist

Before declaring the work complete, Agent_X must verify all of the following:

| Check | Required final state |
|---|---|
| Exact blocking list parsed | Yes |
| Gap inventory covers every blocking module | Yes |
| Gap inventory covers every scaffold-only module | Yes |
| Every accepted module has `final_verdict.json` | Yes |
| Every accepted module has at least one real behavioral check | Yes |
| Negative or anti-gaming test exists where relevant | Yes |
| Makefile target runs CLI + verifier, not only compileall | Yes |
| Scorecard regenerated after closures | Yes |
| `accepted_modules == total_modules` | Yes for 100% claim |
| `blocking_report_count == 0` | Yes for 100% claim |
| `scaffold_only_modules == 0` | Yes for 100% claim |
| `strict_full_repo_status == ACCEPTED` | Yes for 100% claim |
| `strict_full_repo_claim_allowed == true` | Yes for 100% claim |
| `production_claim_allowed == false` unless separately proven | Yes |
| Hermes copied code attribution | Present if copied |
| AGPL code imported into Agent_X core | No |
| Provider env vars in proof-critical path | No |
| Direct provider imports in proof-critical path | No |
| Unsupported claims | Zero |
| Static/echo-only acceptance | Zero |
| Stale reports | Zero |
| Internal-MVP hard gate agrees | Yes |
| Final full-repo hard gate exists and agrees | Yes |
| Verdict parser exact enum integrity | Yes |
| Source/report/Makefile/scorecard bijection | Yes |
| Third-party copied-code attribution | Yes if code copied |
| Dependency hygiene accepted | Yes |
| Fresh checkout full-repo acceptance | Yes |
| CI/local equivalence full-repo proof | Yes |
| Local Hermes path independence | Yes |

# Paste-Ready Prompt for Agent_X

Copy the prompt below and give it to Agent_X.

---

## BEGIN PROMPT

You are working inside the Agent_X repository.

We need a focused, evidence-driven gap-closure pass. Do not make random architecture changes. Do not attempt a wholesale rewrite. Do not turn Agent_X into a Hermes fork.

Current assessment:

- Agent_X is accepted as an internal MVP proof system.
- Estimated practical internal-MVP maturity: 75–82%.
- Strict full-repo module accounting is only 65.35%.
- Strict full-repo status is NOT_ACCEPTED.
- Internal MVP claim is allowed.
- Full-repo claim is not allowed.
- Production-ready claim is not allowed.

The local Hermes repositories are available only as references and optional small MIT-compatible source pools:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Use Hermes for patterns, not wholesale merging.

Your job is to close real Agent_X gaps and continue until strict full-repo coverage reaches honest 100%, without gaming the scorecard. Do not stop at 72%, 75%, 80%, or 90% if more closures can be safely completed.

Important constraints:

1. Preserve Agent_X identity as a governed self-evolution / proof / promotion / reproducibility framework.
2. Do not vendor or import the entire Hermes app.
3. Do not add provider-specific API keys or provider env var dependencies into proof-critical code.
4. Do not import AGPL code into Agent_X core.
5. Do not change scorecard semantics just to inflate percentages.
6. Do not hide or delete blocking modules to raise the score.
7. Do not mark production-ready unless real production-readiness evidence exists.
8. Preserve the internal-MVP vs full-repo distinction.
9. Every accepted module must have real proof, not only compileall.
10. Prefer small, deterministic, local fixtures.

Start by reading these Agent_X reports:

```text
reports/progress_scorecard/final_verdict.json
reports/progress_scorecard/progress_scorecard_report.json
reports/progress_scorecard/dimension_scores_report.json
reports/progress_scorecard/adjusted_progress_report.json
reports/final_acceptance_hard_gated/final_verdict.json
```

Then build a current full-repo gap inventory. After that, run a false-positive acceptance audit so that weak accepted modules are also treated as gaps.

Mandatory supporting audits and gates:

Before claiming full closure, implement or update the following support modules and reports.

1. False-positive acceptance audit

Create or update:

```text
tools/agentx_evolve/false_positive_acceptance_audit/
reports/false_positive_acceptance_audit/
reports/false_positive_acceptance_audit/final_verdict.json
reports/false_positive_acceptance_audit/false_positive_acceptance_audit_report.json
```

This audit must scan:

```text
Makefile
tools/agentx_evolve/*/
reports/*/final_verdict.json
reports/progress_scorecard/*.json
```

It must classify accepted modules as:

```text
STRONG_ACCEPTED
WEAK_ACCEPTED_NEEDS_HARDENING
STALE_ACCEPTED_NEEDS_RERUN
COMPILE_ONLY_ACCEPTED
MIGRATION_ONLY_ACCEPTED
MISSING_BEHAVIORAL_EVIDENCE
MISSING_NEGATIVE_CASE
```

Treat a module as weak if any of the following are true:

- Makefile target runs only `compileall` and echo.
- `final_verdict.json` says `ACCEPTED` but has no meaningful checks.
- `checks` is empty and there is no separate behavioral report.
- evidence list is empty.
- report was generated only by a generic migration utility without module-specific behavior.
- source commit is stale relative to current HEAD, unless deliberately normalized for reproducibility.
- boundary/gate/security/policy/provider/sandbox module has no negative test.
- CLI cannot regenerate the report deterministically.
- proof does not fail on an intentionally bad fixture.
- target can pass while module is missing, empty, or semantically broken.

A true 100% claim requires:

```text
weak_accepted_module_count == 0
compile_only_accepted_module_count == 0
migration_only_accepted_module_count == 0
stale_accepted_module_count == 0
missing_negative_case_required_count == 0
```

2. Scorecard denominator integrity

Create or update:

```text
tools/agentx_evolve/scorecard_denominator_integrity/
reports/scorecard_denominator_integrity/
reports/scorecard_denominator_integrity/final_verdict.json
reports/scorecard_denominator_integrity/scorecard_denominator_integrity_report.json
```

Before and after every closure batch, record:

```text
total_modules
accepted_modules
not_accepted_modules
scaffold_only_modules
blocking_report_count
dimension_scores
new_modules_added
modules_removed
modules_renamed
modules_reclassified
```

If `total_modules` changes, explain why. Do not reduce the denominator by deleting, hiding, renaming, or reclassifying modules without a justified mapping report.

3. Module waiver registry

Create or update:

```text
tools/agentx_evolve/module_waiver_registry/
reports/module_waiver_registry/
reports/module_waiver_registry/final_verdict.json
reports/module_waiver_registry/module_waiver_registry_report.json
```

A waiver is valid only if it includes:

```json
{
  "module": "<module>",
  "waiver_type": "alias_only | static_artifact | deprecated_with_replacement | intentionally_out_of_scope",
  "replacement_or_parent_module": "<module or null>",
  "reason": "<specific reason>",
  "expires": "<date or milestone>",
  "approved_for_full_repo_closure": true,
  "proof_that_it_should_not_count_as_gap": "<evidence path>"
}
```

Waivers must be rare. They cannot be used to bypass real implementation work.

4. Final full-repo acceptance gate

Create or update:

```text
tools/agentx_evolve/final_full_repo_acceptance_gate/
reports/final_full_repo_acceptance_gate/
reports/final_full_repo_acceptance_gate/final_verdict.json
reports/final_full_repo_acceptance_gate/final_full_repo_acceptance_report.json
```

This is separate from the internal-MVP final acceptance gate. Internal-MVP acceptance alone is not enough for strict full-repo 100%.

The final full-repo gate must validate:

- every module counted by the scorecard has a proof target or explicit justified waiver
- every proof target runs more than compileall unless a static-proof waiver exists
- every accepted module has fresh or reproducibly normalized evidence
- every boundary/gate/security/policy/provider/sandbox module has a negative case
- every report referenced by the scorecard exists and is valid JSON
- no scorecard denominator manipulation occurred
- verdict parsing uses exact enum matching, not substring matching
- source/report/Makefile/scorecard mapping is complete or explicitly waived
- copied third-party code has attribution and license provenance
- fresh checkout full-repo acceptance passes
- CI/local equivalence full-repo proof passes
- no proof-critical code depends on local absolute Hermes repository paths
- no blocking modules remain
- no scaffold-only modules remain
- no weak accepted modules remain
- internal-MVP acceptance remains intact
- full-repo claim is allowed only if all full-repo checks pass
- production claim remains false unless separately proven

Expected final full-repo gate verdict shape:

```json
{
  "report_type": "final_verdict",
  "verdict": "ACCEPTED",
  "errors": [],
  "full_repo_scope": true,
  "total_modules_checked": "<number>",
  "accepted_modules": "<number>",
  "blocking_report_count": 0,
  "scaffold_only_modules": 0,
  "weak_accepted_module_count": 0,
  "compile_only_accepted_module_count": 0,
  "migration_only_accepted_module_count": 0,
  "stale_accepted_module_count": 0,
  "missing_negative_case_required_count": 0,
  "internal_mvp_acceptance_preserved": true,
  "strict_full_repo_claim_allowed": true,
  "production_claim_allowed": false
}
```

Module closure quality standard:

A module is not truly closed merely because `final_verdict.json` says `ACCEPTED`.

Use this standard:

| Module type | Required positive proof | Required negative proof |
|---|---|---|
| Runtime / core product | Executes a deterministic fixture successfully | Rejects invalid input or broken state |
| Adapter / provider / model | Resolves a valid fake/local descriptor | Rejects unknown provider/model and avoids provider key leakage |
| Tool / MCP / connector | Registers and dispatches allowed tool schema | Rejects malformed, unknown, or undeclared capability |
| Policy / governance | Accepts compliant fixture | Rejects forbidden fixture |
| Sandbox / security | Allows safe fixture | Blocks unsafe command, path, or egress |
| Evidence / audit | Replays valid evidence | Detects missing, stale, corrupted, or contradictory evidence |
| Evaluation / benchmark | Passes deterministic benchmark | Detects regression or below-threshold candidate |
| Reproducibility | Re-runs with same output | Detects dirty non-proof artifact or nondeterminism |
| Production boundary | Allows internal-MVP claim | Rejects production-ready claim unless separately proven |
| Documentation | Aligns documented claim with proof | Detects unsupported claim |

Every module-specific report should include anti-gaming fields:

```json
{
  "module": "<module>",
  "positive_fixture": "<name>",
  "negative_fixture": "<name or not_required_with_reason>",
  "checks": [
    {"name": "...", "passed": true}
  ],
  "anti_gaming": {
    "static_acceptance_only": false,
    "echo_only_target": false,
    "compile_only_target": false,
    "stale_report": false,
    "unsupported_claim": false
  }
}
```

Additional mandatory integrity checks:

A. Verdict parser integrity

Create or update:

```text
tools/agentx_evolve/verdict_parser_integrity/
reports/verdict_parser_integrity/
reports/verdict_parser_integrity/final_verdict.json
reports/verdict_parser_integrity/verdict_parser_integrity_report.json
```

The verifier and scorecard must use exact verdict enum parsing. Do not count a verdict as accepted merely because the string contains `"ACCEPTED"`.

Required parser test cases:

```text
"ACCEPTED" -> accepted
"NOT_ACCEPTED" -> not accepted
"REJECTED" -> not accepted
"PARTIAL" -> not accepted
"ACCEPTED_WITH_WARNINGS" -> not accepted unless explicitly supported by schema
missing verdict -> not accepted
malformed JSON -> not accepted
```

This matters because `NOT_ACCEPTED` contains the substring `ACCEPTED`. Any substring-based parser is a false-positive acceptance bug and must be fixed before full closure can be claimed.

B. Source/report/Makefile/scorecard bijection

Create or update:

```text
tools/agentx_evolve/source_report_bijection/
reports/source_report_bijection/
reports/source_report_bijection/final_verdict.json
reports/source_report_bijection/source_report_bijection_report.json
```

This report must prove every module relationship:

```text
source module -> Makefile target -> report directory -> final_verdict.json -> scorecard entry
```

It must list:

```text
source modules without reports
source modules without Makefile proof targets
Makefile proof targets without source modules
reports without source modules
reports not counted by scorecard
scorecard entries without source modules
duplicate module names
alias modules
deprecated modules
waived modules
```

All exceptions must be explicit waivers in the module waiver registry. Do not hide mapping mismatches.

C. Third-party code attribution and license hygiene

Create or update:

```text
tools/agentx_evolve/third_party_code_attribution/
reports/third_party_code_attribution/
reports/third_party_code_attribution/final_verdict.json
reports/third_party_code_attribution/third_party_code_attribution_report.json
```

If any Hermes code is copied or adapted, create or update an attribution file such as:

```text
THIRD_PARTY_NOTICES.md
docs/third_party/hermes_agent_attribution.md
```

The attribution report must include:

```json
{
  "source_repository": "NousResearch/hermes-agent or NousResearch/hermes-agent-self-evolution",
  "source_path": "<path>",
  "source_commit_or_ref": "<sha or unknown>",
  "source_license": "MIT",
  "destination_path": "<path in Agent_X>",
  "usage": "pattern_only | small_code_adapted | substantial_copy",
  "attribution_file": "<path>",
  "agpl_code_imported_into_core": false
}
```

Pattern-only inspiration does not require license notice as copied code, but the report should still record the Hermes reference path when it materially influenced the implementation.

E. Fresh checkout, CI/local equivalence, and local path independence

Create or update:

```text
tools/agentx_evolve/fresh_checkout_full_repo_acceptance/
reports/fresh_checkout_full_repo_acceptance/
reports/fresh_checkout_full_repo_acceptance/final_verdict.json
reports/fresh_checkout_full_repo_acceptance/fresh_checkout_full_repo_acceptance_report.json

tools/agentx_evolve/ci_local_equivalence_full_repo/
reports/ci_local_equivalence_full_repo/
reports/ci_local_equivalence_full_repo/final_verdict.json
reports/ci_local_equivalence_full_repo/ci_local_equivalence_full_repo_report.json

tools/agentx_evolve/local_path_independence/
reports/local_path_independence/
reports/local_path_independence/final_verdict.json
reports/local_path_independence/local_path_independence_report.json
```

The local Hermes repositories are development references only:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Final Agent_X code must not require those paths to exist.

The fresh-checkout proof must show:

```text
clean checkout can run full proof sequence
no proof depends on untracked files
no proof depends on dirty working tree state
no proof depends on local cache artifacts
all required generated reports can be regenerated
```

The CI/local equivalence proof must show:

```text
local proof command and CI proof command run the same gate set
local and CI use the same verdict parser semantics
local and CI fail on the same intentionally bad fixtures
local and CI both run final_full_repo_acceptance_gate
```

The local-path independence proof must scan:

```text
Makefile
tools/agentx_evolve/
reports/
docs/
pyproject.toml
requirements*.txt
```

and must reject any proof-critical dependency on:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Those paths may appear only in reference/provenance documentation, not in imports, execution commands, required config, or proof-critical logic.

A 100% full-repo claim requires:

```text
fresh_checkout_full_repo_acceptance == ACCEPTED
ci_local_equivalence_full_repo == ACCEPTED
local_path_independence == ACCEPTED
```

D. Dependency hygiene

Do not add dependencies casually. If a dependency is added, update the appropriate dependency file and prove:

```text
dependency is necessary
license is compatible
import path is deterministic
offline/local fixture path still works
proof-critical path does not require network or provider keys
```

A full closure claim requires the dependency hygiene checks to pass.

Full closure driver:

Create or update:

```text
tools/agentx_evolve/full_repo_closure_driver/
reports/full_repo_closure_driver/
reports/full_repo_closure_driver/final_verdict.json
reports/full_repo_closure_driver/closure_driver_report.json
```

The closure driver report must include:

```json
{
  "report_type": "full_repo_closure_driver",
  "starting_strict_full_repo_progress_percent": 65.35,
  "ending_strict_full_repo_progress_percent": "<new value>",
  "starting_accepted_modules": 264,
  "ending_accepted_modules": "<new value>",
  "starting_total_modules": 404,
  "ending_total_modules": "<new value>",
  "starting_blocking_report_count": 140,
  "ending_blocking_report_count": "<new value>",
  "closed_this_run": ["<module>", "..."],
  "still_blocking": ["<module>", "..."],
  "impossible_or_deferred": [
    {
      "module": "<module>",
      "reason": "<exact reason>",
      "required_next_action": "<specific action>"
    }
  ],
  "hermes_references_used": [
    {
      "agent_x_module": "<module>",
      "hermes_path": "<path>",
      "usage": "pattern_only | small_code_adapted | not_used",
      "license_attribution_required": true
    }
  ],
  "claim_integrity": {
    "internal_mvp_claim_preserved": true,
    "full_repo_claim_allowed_only_if_all_modules_pass": true,
    "production_claim_allowed": false
  }
}
```

Create or update:

```text
tools/agentx_evolve/full_repo_gap_inventory/
reports/full_repo_gap_inventory/
reports/full_repo_gap_inventory/final_verdict.json
reports/full_repo_gap_inventory/gap_inventory_report.json
reports/false_positive_acceptance_audit/final_verdict.json
reports/false_positive_acceptance_audit/false_positive_acceptance_audit_report.json
reports/scorecard_denominator_integrity/final_verdict.json
reports/scorecard_denominator_integrity/scorecard_denominator_integrity_report.json
reports/final_full_repo_acceptance_gate/final_verdict.json
reports/final_full_repo_acceptance_gate/final_full_repo_acceptance_report.json
```

The inventory must parse the current scorecard blocking modules, scaffold-only modules, and weak accepted modules from the false-positive acceptance audit, then group them by dimension. Each gap entry must include:

```json
{
  "module": "<module_name>",
  "dimension": "<dimension>",
  "current_status": "NOT_ACCEPTED | SCAFFOLD_ONLY | MISSING | COMPILE_ONLY",
  "likely_reason": "<short reason>",
  "closure_type": "behavioral_cli | proof_report | negative_test | makefile_target | scorecard_mapping | docs_alignment | reproducibility",
  "priority": "P0 | P1 | P2",
  "hermes_reference": "<path or null>",
  "expected_output": "reports/<module>/final_verdict.json"
}
```

After the inventory, run a repeated full-closure loop. Close gaps in this order:

1. API Surface gaps.
2. Evaluation gaps.
3. Evidence gaps.
4. Reproducibility gaps.
5. Core Product gaps.
6. Production Readiness internal-MVP boundary gaps.
7. Uncategorized gaps through either correct mapping or real proof.

For each selected module, do the following:

1. Inspect the current module under `tools/agentx_evolve/<module>/`.
2. If the Makefile target only runs compileall, upgrade it to run the module CLI and `prove_verifier`.
3. Add or repair `tools/agentx_evolve/<module>/cli.py`.
4. Add deterministic fixtures if needed.
5. Add behavioral checks.
6. Add at least one negative/anti-gaming check where appropriate.
7. Write `reports/<module>/final_verdict.json`.
8. Write a module-specific report.
9. Ensure `final_verdict.json` uses honest `ACCEPTED` or `NOT_ACCEPTED`.
10. Regenerate progress scorecard.
11. Produce a before/after summary.

Use this Makefile pattern for real proof targets:

```make
prove-some-module:
	$(PYTHON) -m compileall -q tools/agentx_evolve/some_module
	PYTHONPATH=.:tools $(PYTHON) -m tools.agentx_evolve.some_module.cli --output reports/some_module
	PYTHONPATH=.:tools $(PYTHON) -m tools.agentx_evolve.make_helpers.prove_verifier some_module reports/some_module
	@echo "=== prove-some-module: OK ==="
```

The minimum final verdict shape is:

```json
{
  "report_type": "final_verdict",
  "generated_at": "REPRODUCIBLE_OR_NORMALIZED_TIMESTAMP",
  "verdict": "ACCEPTED",
  "errors": [],
  "checks": [
    {"name": "positive_behavior", "passed": true},
    {"name": "negative_behavior", "passed": true},
    {"name": "deterministic_output", "passed": true}
  ],
  "evidence": [
    "reports/some_module/<module_specific_report>.json"
  ],
  "claim_scope": "internal_mvp",
  "production_claim_allowed": false
}
```

Hermes reference usage:

A. For tool registry, MCP, tool exposure, source adapters, and external connector governance, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/registry.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/model_tools.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/toolsets.py
```

Borrow only the registry pattern. Agent_X proof must show schema validation, unknown-tool rejection, malformed-tool rejection, capability boundary enforcement, and audit evidence.

B. For model/provider/runtime modules, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/runtime_provider.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/models.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/auth.py
```

Borrow only provider abstraction ideas. Agent_X proof must show provider-neutral descriptors, local deterministic fake provider, rejection of unknown providers, and no provider-key leakage.

C. For session/state/replay modules, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_state.py
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/gateway/session.py
```

Borrow session-lineage and persistence ideas. Agent_X proof must show deterministic fixtures, replay from events, corruption detection, missing-event detection, and idempotent rerun behavior.

D. For sandbox/execution-environment modules, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/tools/environments/
```

Borrow backend abstraction ideas. Agent_X proof must show workspace isolation, denial of dangerous commands, denied unapproved network egress, and deterministic local proof behavior.

E. For plugin/integration modules, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent/hermes_cli/plugins.py
```

Borrow plugin-boundary ideas. Agent_X proof must show manifest validation, capability whitelist, rejected undeclared capability, rejected unsafe lifecycle hook, and deterministic loading order.

F. For evaluation/self-evolution modules, inspect:

```text
/home/glompy/Desktop/OTHER_PROJECTS/hermes-agent-self-evolution/
```

Especially:

```text
PLAN.md
README.md
evolution/skills/evolve_skill.py
evolution/core/constraints.py
evolution/core/dataset_builder.py
evolution/core/fitness.py
```

Borrow the external optimization-loop pattern. Agent_X proof must show baseline-vs-candidate comparison, holdout fixtures, constraints, before/after metrics, regression detection, and human-review/promotion boundary. Do not implement uncontrolled auto-merge.

Specific likely modules to prioritize if they are still blocking:

```text
benchmark_scriptor
change_benchmark_corpus
selective_test_planner
candidate_test_executor
candidate_review_gate
risk_classification_engine
task_complexity_estimator
replay_evidence
state_consistency_audit
run_ledger
session_dependency_graph
runtime_state_store
workspace
workspace_isolation
clean_workspace
dependency_inventory
dependency_lock
circular_dependency_detector
missing_source_detector
tool_exposure_boundary
plugin_governance
external_connector_governance
model_adapter
model_runtime
local_model_runtime_profile
llm_worker
agent_lifecycle
session_state
state_store
source_inventory
source_adapters
context
memory_boundary
agents
agent_roles
agentx_orchestrator
docs
docs_sync
documentation_audit
production_readiness_boundary
security_and_policy_boundary
supply_chain_boundary
privacy_governance
legal_document_readiness
support_operations
enterprise_readiness
```

If a listed module is already accepted, skip it and choose the next highest-priority blocked module from the scorecard. This list is not complete and must not be treated as authoritative. The authoritative list is the current `blocking_reports` list plus scaffold-only entries from the scorecard plus weak accepted modules from the false-positive acceptance audit. Continue until there are no blocking reports, no scaffold-only modules, no weak accepted modules, no stale accepted modules, no compile-only accepted modules, no denominator-integrity failures, and the final full-repo hard gate accepts.

Acceptance criteria for this full-closure work:

Full closure stop condition:

```text
The work is complete only when:
- strict_full_repo_progress_percent == 100.00
- accepted_modules == total_modules
- blocking_report_count == 0
- scaffold_only_modules == 0
- strict_full_repo_status == "ACCEPTED"
- strict_full_repo_claim_allowed == true
- final_acceptance_hard_gated agrees for internal MVP
- final_full_repo_acceptance_gate agrees for strict full-repo scope
- false_positive_acceptance_audit has zero weak accepted modules
- scorecard_denominator_integrity is accepted
- verdict_parser_integrity is accepted
- source_report_bijection is accepted
- third_party_code_attribution is accepted if any Hermes code was copied
- dependency hygiene is accepted if dependencies changed
- fresh_checkout_full_repo_acceptance is accepted
- ci_local_equivalence_full_repo is accepted
- local_path_independence is accepted
- no unsupported production-ready claim is introduced
```

If any of those are false, the correct verdict is PARTIAL, not ACCEPTED. If the scorecard says 100% but false-positive acceptance audit or denominator integrity fails, the correct verdict is still PARTIAL.


1. Produce `reports/full_repo_gap_inventory/final_verdict.json`.
2. Produce a gap inventory report with all current blocking modules, scaffold-only modules, and weak accepted modules.
3. Continue closing modules until strict full-repo coverage reaches 100%, or produce an explicit machine-readable list of modules that could not be closed in this run and why.
4. Resolve all scaffold-only modules and all weak accepted modules; none may remain if claiming 100%.
5. Do not degrade any existing accepted internal-MVP required report.
6. Preserve `internal_mvp_final_acceptance = ACCEPTED`.
7. Preserve `strict_full_repo_status = NOT_ACCEPTED` unless all strict full-repo modules honestly pass.
8. Set `strict_full_repo_status = ACCEPTED` only when `blocking_report_count == 0`, `accepted_modules == total_modules`, `scaffold_only_modules == 0`, `weak_accepted_module_count == 0`, denominator integrity is accepted, and final full-repo acceptance gate accepts.
9. Preserve `production_claim_allowed = false` unless actual production evidence exists.
10. Run relevant Makefile proof targets.
11. Regenerate progress scorecard after every closure batch.
12. Produce `reports/full_repo_closure_driver/final_verdict.json` and `reports/full_repo_closure_driver/closure_driver_report.json`.
13. Produce `reports/false_positive_acceptance_audit/final_verdict.json`.
14. Produce `reports/scorecard_denominator_integrity/final_verdict.json`.
15. Produce `reports/final_full_repo_acceptance_gate/final_verdict.json`.
16. Produce `reports/verdict_parser_integrity/final_verdict.json`.
17. Produce `reports/source_report_bijection/final_verdict.json`.
18. Produce `reports/third_party_code_attribution/final_verdict.json` if any Hermes code was copied or adapted.
19. Produce `reports/fresh_checkout_full_repo_acceptance/final_verdict.json`.
20. Produce `reports/ci_local_equivalence_full_repo/final_verdict.json`.
21. Produce `reports/local_path_independence/final_verdict.json`.
22. Produce a before/after summary showing:
    - previous strict percentage
    - new strict percentage
    - modules closed
    - modules still blocking
    - weak accepted modules still requiring hardening
    - denominator changes, if any
    - final full-repo gate result
    - dimension-level improvements
    - any Hermes-inspired patterns used
    - any copied code and attribution, if applicable

When finished, report:

```text
VERDICT: <ACCEPTED | PARTIAL | NOT_ACCEPTED>

Previous strict full-repo coverage: 65.35%
New strict full-repo coverage: <value>
Target strict full-repo coverage: 100.00%
Closure complete: <true|false>
Internal MVP status: <value>
Full repo status: <value>
Production claim allowed: <true|false>
Fresh checkout full-repo acceptance: <value>
CI/local equivalence full-repo proof: <value>
Local path independence: <value>

Closed modules:
- ...

Still blocking:
- ...

Files changed:
- ...

Hermes references used:
- ...

Risks:
- ...

Next exact targets:
- ...
```

Do not stop after only generating scaffolds. Do not claim success unless the proof reports and scorecard support it.

## END PROMPT

---

## Suggested Working Order After Giving the Prompt

1. Let Agent_X create the full gap inventory first.
2. Check whether the inventory matches the scorecard.
3. Let it close bounded batches of modules, for example 10–20 modules at a time.
4. Run the proof targets.
5. Regenerate the scorecard.
6. Re-read the new blocking list.
7. Repeat until strict full-repo closure is complete or until a real blocker is documented.

The safe route may still happen in stages:

```text
65.35% -> 72–75% -> 80–85% -> 90% -> 95%+ -> 100%
```

But the prompt should not define 72–75% as success. The final success condition is honest 100% strict full-repo acceptance.

Each step should preserve honesty of claims and improve real executable proof coverage.
