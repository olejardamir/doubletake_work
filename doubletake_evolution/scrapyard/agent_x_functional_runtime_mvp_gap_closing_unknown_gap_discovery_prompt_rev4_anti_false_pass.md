# Agent_X Functional Runtime MVP — Final Gap-Closing + Unknown-Gap Discovery + Anti-False-PASS Prompt — Revision 4

## Repository

You are working in:

```text
https://github.com/Astrocytech/Agent_X
```

This prompt is for a coding LLM or coding agent. It is intentionally strict. Your task is not to expand Agent_X into a larger system. Your task is to close all known and discoverable gaps that prevent the current Functional Runtime MVP from being honestly classified as:

```text
FUNCTIONAL_RUNTIME_MVP
```

At the beginning of this task, assume the repo is still only:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

until proven otherwise by real commands, tests, persisted replay, evidence-backed reports, validators, idempotency checks, and clean-checkout regeneration.

---

# 0. Core Instruction

Do not start by coding.

First, discover and write down all known and unknown gaps.

Second, map every in-scope requirement to implementation, tests, validators, and evidence.

Third, implement only the minimum changes needed to close those gaps.

Fourth, prove the result with commands, scenario evidence, persisted replay, validator-negative tests, generated reports, clean-checkout regeneration, and consecutive proof-target idempotency.

Fifth, run an explicit anti-false-PASS audit.

The final claim must be evidence-backed. Do not claim `FUNCTIONAL_RUNTIME_MVP` unless the proof target and validators actually pass and the anti-false-PASS audit finds no bypass.

---

# 1. Final Success Definition

The repository reaches:

```text
FUNCTIONAL_RUNTIME_MVP
```

only if all of the following are true:

```text
1. safe_report_generation_goal passes.
2. unsafe_self_promotion_goal is denied and recorded.
3. Replay reconstructs/reruns both scenarios from persisted manifest/state/event/artifact evidence.
4. make prove-functional-runtime-mvp exits 0 twice consecutively.
5. python3 -m compileall -q tools/agentx_evolve tests exits 0.
6. make prove-format exits 0.
7. make test-evolve exits 0.
8. Acceptance matrix rows are derived from real proof evidence, not static PASS rows.
9. Command transcript records real command execution, not invented exit codes.
10. Reuse map is regenerated during the proof target.
11. Compatibility report is evidence-backed.
12. Safe scenario proves no source mutation using before/after source hash manifests.
13. Artifact store cannot silently overwrite artifacts or evidence.
14. Unsafe self-promotion records invariant, gate/promotion, and circuit-breaker/safety evidence.
15. All generated .agentx-init/reports outputs are reproducible from tracked source in a clean checkout.
16. All requirements in this prompt, the repo’s existing MVP documents, and any attached gap-closing documents are traced to tests or explicit non-goals.
17. Hidden/unlisted gaps discovered during inspection are either fixed, tested, and documented, or explicitly classified as out of scope with justification.
18. Validators have negative tests proving they reject corrupted, missing, stale, static, or contradictory evidence.
19. The anti-false-PASS audit passes.
```

If any item is missing, final classification must remain:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

or lower.

---

# 2. Non-Negotiable Rules

Do not use or preserve:

```text
hardcoded PASS rows
synthetic command transcript entries
static exit_code: 0
static “all checks passed” reports
report-only acceptance
skipped negative scenario
skipped replay
silent artifact overwrite
silent state overwrite
observer source-mutation stub
promotion denial without invariant evidence
promotion denial without safety/circuit-breaker evidence
compatibility PASS without actual checks
reuse-map PASS without regeneration
test-evolve failure hidden behind “pre-existing” text
live network dependency
live model dependency
weakening existing tests
weakening existing requirement documents
moving the goalposts to match incomplete implementation
validators that only check file existence
validators that accept stale reports from a previous commit
validators that accept PASS rows without evidence
validators that accept missing hashes
validators that accept corrupted JSON
validators that accept generated evidence not reproducible from tracked source
```

Do not implement non-MVP features:

```text
full multi-agent swarm
finance/domain agents
ZKP simulation
tokenized settlement
API server
plugin marketplace
distributed scheduler
advanced memory
advanced planner
large generated-agent ecosystem
live external integrations
```

Do not “simplify” the proof by deleting requirements.

---

# 3. Required Phase 1 — Unknown-Gap Discovery Pass

Before changing any implementation file, perform a repository-wide discovery pass.

Create:

```text
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.md
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.json
```

The gap discovery report must include:

```text
repo commit
branch
date/time
documents inspected
source files inspected
tests inspected
Makefile targets inspected
generated reports inspected, if present
known gaps confirmed
new gaps discovered
suspected gaps needing proof
out-of-scope items with rationale
final pre-implementation classification
```

## 3.1 Required search patterns

Run a search pass for at least these patterns:

```text
TODO
FIXME
stub
placeholder
pass
hardcoded
static PASS
exit_code
replay
overwrite
mutation
source mutation
self promotion
self-promotion
promotion
compatibility
reuse map
validator
deterministic
seed
clock
event log
artifact
evidence
proof
acceptance
report
manifest
hash
sha256
temp
random
datetime.now
time.time
uuid
glob
os.walk
symlink
path traversal
```

Search at minimum:

```text
Makefile
docs/
tools/agentx_evolve/
tests/
.agentx-init/reports/    # if present
```

## 3.2 Requirement source inventory

Inspect and list all requirement-bearing sources available in the repo or attached to the task.

At minimum, inspect if present:

```text
docs/plans/AGENT_X_FUNCTIONAL_RUNTIME_MVP_IMPLEMENTATION_PROMPT.md
docs/plans/*
README*
Makefile
tests/system/*
tools/agentx_evolve/acceptance/*
tools/agentx_evolve/validators/*
```

If attached gap-closing documents are available outside the repo, include them in the traceability matrix. If not available, state that explicitly.

## 3.3 Requirement traceability matrix

Create:

```text
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.json
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.md
```

Each requirement row must include:

```json
{
  "requirement_id": "FRMVP-001",
  "source": "prompt|repo_doc|test|makefile|discovered_gap|anti_false_pass_audit",
  "requirement": "string",
  "implementation_refs": ["path:line-or-symbol"],
  "test_refs": ["test path::test_name"],
  "validator_refs": ["validator path::check_name"],
  "evidence_refs": ["generated report or artifact"],
  "status": "PASS|FAIL|BLOCKED|OUT_OF_SCOPE",
  "notes": "string"
}
```

Validator must fail if any in-scope requirement has no implementation ref, no test ref, no validator ref, or no evidence ref.

---

# 4. Required Phase 2 — Baseline Command Transcript

Before modifying files, run:

```bash
git rev-parse --short HEAD
git branch --show-current
git status --short
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make test-evolve
make prove-format
```

Record every command in:

```text
.agentx-init/reports/functional_runtime_mvp_baseline_command_transcript.json
.agentx-init/reports/functional_runtime_mvp_baseline_command_transcript.md
```

Each command record must include:

```json
{
  "phase": "baseline",
  "command": "string",
  "exit_code": 0,
  "stdout_summary": "string",
  "stderr_summary": "string",
  "timestamp": "ISO-8601",
  "duration_seconds": 0.0,
  "git_commit": "short sha",
  "branch": "string",
  "environment": {
    "python": "string",
    "platform": "string"
  },
  "source": "subprocess"
}
```

Do not hide failed baseline output.

---

# 5. Required Phase 3 — Implementation Architecture

Use this strict architecture for proof and reporting.

## 5.1 Add a proof-result model

Create:

```text
tools/agentx_evolve/acceptance/proof_result.py
```

It must define serializable records for:

```text
CommandResult
ScenarioProof
ReplayProof
SourceMutationProof
ArtifactSafetyProof
CompatibilityProof
ReuseMapProof
RequirementTraceProof
GapDiscoveryProof
AntiFalsePassProof
AcceptanceRowProof
FunctionalMvpProofBundle
```

Every proof record must include:

```text
status
evidence_refs
errors
warnings
created_at
git_commit
```

Allowed statuses:

```text
PASS
FAIL
BLOCKED
UNKNOWN
OUT_OF_SCOPE
```

Rules:

```text
PASS requires at least one evidence_ref.
PASS cannot be created with errors.
UNKNOWN cannot be promoted to PASS by report generation.
FAIL/BLOCKED must propagate to acceptance matrix and final classification.
OUT_OF_SCOPE requires rationale and source.
```

## 5.2 Add a real command transcript runner

Create:

```text
tools/agentx_evolve/acceptance/command_transcript.py
```

Required behavior:

```text
run external command
capture exit code
capture bounded stdout/stderr summaries
capture timestamp
capture duration
capture git commit
capture branch
capture Python/platform environment
write JSON and Markdown transcripts
mark source as subprocess
```

Reject records where:

```text
source is static
source is missing
exit_code is missing
timestamp is missing
git_commit is missing
environment is missing
```

Important:

Do not have `generate_mvp_reports.py` call `make prove-functional-runtime-mvp`; that causes recursion.

## 5.3 Split proof collection from report generation

Create or update:

```text
tools/agentx_evolve/acceptance/collect_mvp_proof.py
tools/agentx_evolve/acceptance/generate_mvp_reports.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
```

Required separation:

```text
collect_mvp_proof.py
  runs or reads actual proof artifacts
  produces functional_runtime_mvp_proof_bundle.json

generate_mvp_reports.py
  reads proof_bundle
  writes human/machine reports
  cannot invent PASS

validate_functional_runtime_mvp_reports.py
  validates reports and fails closed
```

Required proof bundle output:

```text
.agentx-init/reports/functional_runtime_mvp_proof_bundle.json
```

The proof bundle must include a hash of every generated report it uses as evidence.

---

# 6. Required Known-Gap Fixes

## Gap 1 — Acceptance matrix must be evidence-backed

Current problem:

```text
tools/agentx_evolve/acceptance/generate_mvp_reports.py
```

may create static `PASS` rows.

Fix:

Acceptance matrix rows must be generated from `FunctionalMvpProofBundle`.

Required rows:

```text
deterministic runtime context
workspace manager
artifact store
typed I/O envelope
runtime profile
readiness check
state store
event bus
action lifecycle
contract registry
capability graph
policy rule engine
decision gate
invariant engine
security envelope
transaction manager
simulation engine
report generation executor
observation system
rollback controller
circuit breaker
review interface
promotion gate
scenario harness
functional orchestrator
safe report generation scenario
unsafe self-promotion scenario
replay
compatibility report
reuse map
command transcript
source mutation proof
artifact overwrite protection
requirement traceability
unknown-gap discovery
validator negative tests
anti-false-PASS audit
clean-checkout reproducibility
idempotency
```

Required row shape:

```json
{
  "component": "artifact store",
  "status": "PASS",
  "details": "string",
  "evidence_refs": [
    {
      "path": "string",
      "type": "test|scenario|replay|command|source_manifest|artifact|compatibility|reuse_map|traceability|gap_discovery|anti_false_pass|validator_negative_test",
      "hash": "sha256-or-empty-if-not-file"
    }
  ],
  "proof_type": "unit|system|replay|validator|command|generated_report|traceability|audit"
}
```

Validator must fail if:

```text
required row missing
required row not PASS
PASS row lacks evidence_refs
evidence_ref points to missing file
file evidence_ref has wrong hash
row says PASS while proof_bundle says FAIL/BLOCKED/UNKNOWN
row says PASS but referenced command failed
row says PASS but referenced report is stale
```

---

## Gap 2 — Command transcript must reflect real execution

Final transcript:

```text
.agentx-init/reports/functional_runtime_mvp_command_transcript.json
.agentx-init/reports/functional_runtime_mvp_command_transcript.md
```

Must include real records for at least:

```bash
python3 -m compileall -q tools/agentx_evolve tests
pytest required MVP unit/system tests
python3 tools/agentx_evolve/acceptance/collect_mvp_proof.py
python3 tools/agentx_evolve/acceptance/generate_mvp_reports.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_reuse_map.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
make prove-format
make test-evolve
```

Do not record a command as exit code `0` unless the subprocess actually returned `0`.

If including `make prove-functional-runtime-mvp`, record it only from an outer/manual verification transcript, not from inside itself.

---

## Gap 3 — Real source mutation detection

Create:

```text
tools/agentx_evolve/observation/source_manifest.py
```

Required functions:

```text
collect_source_manifest(root: Path, include_paths: list[str]) -> dict
hash_file(path: Path) -> str
compare_source_manifests(before: dict, after: dict) -> dict
write_source_mutation_report(before, after, diff, output_dir) -> paths
```

Required source scope for MVP:

```text
Makefile
docs/plans/AGENT_X_FUNCTIONAL_RUNTIME_MVP_IMPLEMENTATION_PROMPT.md
tools/agentx_evolve/
tests/system/
```

Required outputs:

```text
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_before.json
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_after.json
.agentx-init/reports/functional_runtime_mvp_source_mutation_report.json
```

Required behavior:

```text
safe_report_generation_goal captures before manifest
runs scenario
captures after manifest
compares manifests
fails if source mutation detected
stores report as evidence
observer uses real diff result, not hardcoded False
source manifest uses sorted paths and normalized relative paths
source manifest rejects files outside the declared source scope
```

---

## Gap 4 — Artifact store must prevent silent overwrite

Update:

```text
tools/agentx_evolve/artifacts/artifact_store.py
```

Required behavior:

```text
Default overwrite_policy = deny.
If artifact path exists and overwrite_policy == deny, return FAIL or raise ArtifactOverwriteError.
If overwrite_policy == version, create deterministic versioned path.
If overwrite_policy == content_addressed, use hash-derived path.
Never overwrite existing bytes silently.
Metadata records overwrite_policy and version.
validate_ref fails for missing file or wrong hash.
retain_failed preserves failed artifact evidence.
Artifact names reject path traversal.
Artifact writes cannot escape workspace.
Symlink escapes are rejected.
```

Preferred API:

```python
write(
    run_id: str,
    action_id: str,
    name: str,
    data: Any,
    artifact_type: str = "report",
    agent_id: str = "",
    overwrite_policy: str = "deny",
) -> dict
```

---

## Gap 5 — Unsafe self-promotion must produce full denial evidence chain

Update:

```text
tools/agentx_evolve/invariants/invariant_engine.py
tools/agentx_evolve/promotion/promotion_gate.py
tools/agentx_evolve/safety/circuit_breaker.py
tools/agentx_evolve/orchestrator/functional_orchestrator.py
tests/system/test_unsafe_self_promotion_goal.py
```

Required evidence chain:

```text
1. self_promotion_attempt detected
2. no_self_promotion invariant result exists and passed == false
3. promotion gate denies
4. gate or promotion decision reason includes self-promotion
5. circuit breaker or safety event records unsafe_self_promotion_attempt
6. evidence artifact retained
7. no accepted artifact promoted
8. replay reproduces denial and same safety reason
```

Required context during promotion/invariant check:

```python
{
  "agent_id": "...",
  "target_agent": "...",
  "reviewer": "...",
  "reviewer_is_actor": True,
  "promotion_requested": True,
  "self_promotion_attempt": True,
  "action_type": "promote",
  "requires_evidence": True,
  "evidence_refs": [...]
}
```

---

## Gap 6 — Replay must use persisted manifest, not only repeated execution

Create:

```text
tools/agentx_evolve/testing/replay_manifest.py
```

Required manifest shape:

```json
{
  "schema_version": "1.0.0",
  "scenario_name": "safe_report_generation_goal",
  "run_id": "string",
  "goal_id": "string",
  "runtime_context": {
    "seed": "string",
    "fixed_clock": "ISO-8601",
    "profile_id": "STRICT"
  },
  "state_records_path": "string",
  "state_records_hash": "sha256",
  "event_log_path": "string",
  "event_log_hash": "sha256",
  "artifact_refs": [
    {"path": "string", "hash": "sha256", "type": "report|evidence"}
  ],
  "gate_decisions": [],
  "invariant_results": [],
  "review_decisions": [],
  "promotion_decisions": [],
  "safety_events": [],
  "final_verdict": "PASS|DENIED_AND_RECORDED|FAIL|BLOCKED",
  "created_at": "ISO-8601"
}
```

Required behavior:

```text
safe scenario writes replay manifest
unsafe scenario writes replay manifest
replay validator reads manifest
replay validator verifies referenced files and hashes
replay validator reconstructs/reruns scenario using recorded seed/clock/profile
replay validator compares final verdict
replay validator compares key artifact hashes
replay validator compares gate/promotion/safety outcomes
replay validator fails on hash mismatch or verdict mismatch
```

Required outputs:

```text
.agentx-init/reports/functional_runtime_mvp_replay_report.json
.agentx-init/reports/functional_runtime_mvp_replay_report.md
```

---

## Gap 7 — Reuse map must be regenerated during proof

Ensure the proof path calls:

```python
write_reuse_map()
```

during:

```bash
make prove-functional-runtime-mvp
```

Required outputs:

```text
.agentx-init/reports/functional_runtime_reuse_map.md
.agentx-init/reports/functional_runtime_reuse_map.json
```

Validator must fail if:

```text
reuse map file missing
JSON does not parse
required component missing
listed compatibility test missing
decision == wrap but code does not delegate/wrap existing component
```

Use:

```text
decision: "new"
```

when the new component does not actually call or wrap existing code.

---

## Gap 8 — Compatibility report must be evidence-backed

Create or update:

```text
tools/agentx_evolve/acceptance/compatibility_report.py
```

Required checks:

```text
Makefile targets still present
required tests still present
L0/L1/L2 paths not modified by MVP scenario
new target exists
proof target regenerates reports from tracked source
baseline/final command transcript included
known failures classified
```

Required JSON shape:

```json
{
  "report_type": "functional_runtime_compatibility",
  "verdict": "PASS|FAIL|BLOCKED",
  "created_at": "ISO-8601",
  "git_commit": "string",
  "checks": [
    {
      "name": "existing_makefile_targets_preserved",
      "status": "PASS",
      "evidence_refs": [],
      "details": "string"
    }
  ],
  "conflicts_detected": [],
  "migration_decisions": [],
  "known_failures": []
}
```

Validator must fail if:

```text
verdict == PASS but any required compatibility check is not PASS
verdict == PASS while make test-evolve failed
required target removed
required test missing
```

For this final revision, do not allow a `make test-evolve` waiver for claiming `FUNCTIONAL_RUNTIME_MVP`.

---

## Gap 9 — make test-evolve failure must be resolved

`make test-evolve` must exit `0` for `FUNCTIONAL_RUNTIME_MVP`.

If it does not exit `0`:

```text
create a real known-failures report
make compatibility verdict BLOCKED
do not classify as FUNCTIONAL_RUNTIME_MVP
```

Required known-failures report, if used:

```text
.agentx-init/reports/functional_runtime_mvp_known_failures.json
```

Required fields:

```json
{
  "command": "make test-evolve",
  "exit_code": 2,
  "failing_tests": [],
  "first_observed_commit": "string",
  "current_commit": "string",
  "unrelatedness_rationale": "string",
  "accepted_by_validator": false,
  "blocks_functional_runtime_mvp": true
}
```

---

# 7. Required Unknown-Gap Categories to Check

In addition to known gaps, actively check for these hidden failure classes.

## 7.1 Determinism gaps

Check:

```text
unfixed random seeds
wall-clock use without fixed clock
temp paths leaking into hashes
dict/set iteration causing unstable JSON
platform-specific path separators
non-normalized line endings
unordered glob results
unordered os.walk traversal
non-deterministic event ordering
UUIDs used in proofs without deterministic injection
timestamps used in replay comparisons without normalization
```

Add tests or normalization where needed.

## 7.2 Evidence integrity gaps

Check:

```text
artifact hash calculated before final write
hash missing algorithm
relative paths escaping report root
evidence refs pointing to generated files that are not regenerated
missing event log hash
missing state-store hash
missing proof bundle hash
broken artifact validation on corrupted content
stale report from previous git commit accepted
proof bundle does not include report hashes
```

Add tests for corrupted, missing, stale, and contradictory evidence.

## 7.3 Security and boundary gaps

Check:

```text
path traversal in artifact names
absolute path injection
symlink escape
unsafe delete/overwrite behavior
write outside workspace
mutating source during safe scenario
promotion without review evidence
capability bypass
policy bypass
state-store path escape
report generator path escape
```

Add minimum tests for path traversal, symlink escape, and workspace containment.

## 7.4 Idempotency gaps

Check:

```text
running make prove-functional-runtime-mvp twice in a row
running proof after reports already exist
running replay after evidence already exists
writing same artifact name twice
stale reports passing validation
old proof bundle masking current failure
```

Add an idempotency test or validator check.

## 7.5 Failure-path gaps

Check that validators fail on:

```text
missing acceptance matrix
missing proof bundle
missing replay manifest
missing event log
missing state records
corrupt JSON
wrong artifact hash
missing source mutation report
unsafe scenario without safety event
PASS row without evidence
static command transcript
stale report commit
contradictory proof bundle vs acceptance matrix
```

Add negative tests for validators.

## 7.6 Regression gaps

Check:

```text
existing Makefile targets remain
existing tests are not removed
old L0/L1/L2 paths are not modified by scenarios
existing generated reports can still be regenerated
no broad unrelated rewrite
```

Document in compatibility report.

---

# 8. Required Anti-False-PASS Audit

Create:

```text
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.md
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.json
tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
```

The audit must intentionally try to falsify the proof by creating temporary corrupted copies of generated reports/evidence in a temp directory and ensuring validators reject them.

The audit must test at least these attacks:

```text
1. Change a PASS row to reference a missing evidence file.
2. Change an evidence hash to the wrong hash.
3. Remove the unsafe self-promotion safety event.
4. Remove the no_self_promotion invariant result.
5. Replace command transcript source with static.
6. Change command transcript exit_code to 0 for a known failing command.
7. Remove replay event log hash.
8. Corrupt replay manifest JSON.
9. Change final verdict in replay report.
10. Delete source mutation report.
11. Change compatibility report verdict to PASS while a required check is FAIL.
12. Delete reuse map.
13. Use stale git_commit in proof bundle.
14. Remove requirement traceability row.
15. Mark an unclassified discovered gap as PASS without evidence.
```

Required result:

```text
Every attack must be rejected by at least one validator.
The anti-false-PASS audit itself must fail if any attack is accepted.
```

This is the main protection against unknown report-only gaps.

---

# 9. Required Validators

Add:

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reuse_map.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
```

All validators must fail closed.

## Report validator fails if:

```text
acceptance matrix missing
acceptance review missing
proof bundle missing
required row missing
required row not PASS
PASS row lacks evidence_refs
evidence_ref file missing
evidence_ref hash mismatch
compatibility verdict not PASS
reuse map missing
source mutation report missing
artifact overwrite proof missing
negative scenario lacks self-promotion invariant evidence
anti-false-PASS audit missing
```

## Replay validator fails if:

```text
replay manifest missing
event log missing
state records missing
artifact ref missing
artifact hash mismatch
verdict mismatch
safe replay not PASS
unsafe replay not DENIED_AND_RECORDED
unsafe replay lacks safety event
unsafe replay lacks self-promotion invariant result
```

## Transcript validator fails if:

```text
command transcript missing
required command missing
exit_code missing
timestamp missing
git commit missing
environment missing
source != subprocess
any required command exit_code != 0
synthetic/static marker detected
```

## Traceability validator fails if:

```text
traceability matrix missing
in-scope requirement lacks implementation ref
in-scope requirement lacks test ref
in-scope requirement lacks validator ref
in-scope requirement lacks evidence ref
in-scope requirement status not PASS
discovered gap lacks closure decision
OUT_OF_SCOPE row lacks rationale
```

## Gap discovery validator fails if:

```text
gap discovery report missing
search patterns not recorded
documents inspected not recorded
source files inspected not recorded
known gaps not covered
new gaps not classified
```

## Anti-false-PASS validator fails if:

```text
any attack case is missing
any attack is accepted
audit JSON is missing
audit summary claims PASS without per-attack rejection evidence
```

---

# 10. Required Tests to Add or Strengthen

## Artifact store

```text
tools/agentx_evolve/tests/test_artifact_store.py
```

Required tests:

```text
test_write_denies_existing_artifact_by_default
test_write_versions_existing_artifact_when_requested
test_original_content_preserved_after_versioned_write
test_validate_ref_fails_for_wrong_hash
test_validate_ref_fails_for_missing_file
test_failed_artifact_retained
test_artifact_name_rejects_path_traversal
test_artifact_write_rejects_workspace_escape
test_artifact_write_rejects_symlink_escape
```

## Observer/source safety

```text
tools/agentx_evolve/tests/test_observer.py
```

Required tests:

```text
test_source_hash_manifest_detects_mutation
test_source_hash_manifest_passes_when_unchanged
test_observer_uses_real_source_mutation_report
test_safe_scenario_fails_if_source_changes
```

## Invariant engine

```text
tools/agentx_evolve/tests/test_invariant_engine.py
```

Required tests:

```text
test_self_promotion_violation_recorded_for_promotion_context
test_promotion_without_evidence_fails
test_false_file_claim_fails
test_invariant_results_are_serializable
```

## Promotion and safety

```text
tools/agentx_evolve/tests/test_promotion_gate.py
tools/agentx_evolve/tests/test_circuit_breaker.py
```

Required tests:

```text
test_self_promotion_denied_with_reason
test_self_promotion_decision_is_recorded
test_promotion_requires_review_evidence_observation_gate_invariant
test_circuit_breaker_records_unsafe_self_promotion_event
```

## Replay

```text
tests/system/test_functional_runtime_mvp_replay.py
```

Required tests:

```text
test_replay_uses_persisted_manifest_for_safe_scenario
test_replay_uses_persisted_manifest_for_unsafe_scenario
test_replay_fails_on_artifact_hash_mismatch
test_replay_fails_on_verdict_mismatch
test_replay_fails_on_missing_event_log
test_replay_fails_on_missing_state_records
```

## Acceptance and validators

```text
tools/agentx_evolve/tests/test_functional_acceptance.py
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

Required tests:

```text
test_acceptance_matrix_rejects_missing_required_row
test_acceptance_matrix_rejects_pass_without_evidence
test_acceptance_matrix_rejects_missing_evidence_file
test_replay_report_rejects_mismatch
test_command_transcript_rejects_static_success
test_traceability_rejects_unmapped_requirement
test_gap_discovery_rejects_unclassified_gap
test_validator_rejects_corrupt_json
test_validator_rejects_stale_report_commit
test_anti_false_pass_audit_rejects_all_attacks
```

## System scenario strengthening

```text
tests/system/test_safe_report_generation_goal.py
tests/system/test_unsafe_self_promotion_goal.py
```

Safe scenario must assert:

```text
source before manifest exists
source after manifest exists
source mutation report exists
source mutation detected == false
artifact refs validate by hash
transaction committed exactly once
review ref exists
promotion decision promoted == true
event log persisted
state records persisted
replay manifest exists
```

Unsafe scenario must assert:

```text
final verdict == DENIED_AND_RECORDED
self-promotion invariant result exists and passed == false
promotion decision promoted == false
circuit breaker/safety event exists
no accepted artifact promoted
evidence artifact retained and validates by hash
event log persisted
state records persisted
replay manifest exists
```

---

# 11. Required Makefile Target Update

Update:

```text
Makefile
```

The target:

```text
prove-functional-runtime-mvp
```

must execute this order:

```make
prove-functional-runtime-mvp:
	$(PYTHON) -m compileall -q tools/agentx_evolve tests
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) -m pytest \
	  [all listed MVP unit/system tests] \
	  -q --tb=short -p no:cacheprovider -m "not live"
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/acceptance/collect_mvp_proof.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/acceptance/generate_mvp_reports.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_reuse_map.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
	PYTHONPATH="L0/CODE:L1:L2:tools/agentx_initiator:tools/agentx_evolve:tools" $(PYTHON) \
	  tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
	@echo "=== prove-functional-runtime-mvp: OK ==="
```

Do not print OK if any validator fails.

---

# 12. Required Reports

The proof must generate:

```text
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.md
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.json
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.md
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.json
.agentx-init/reports/functional_runtime_mvp_baseline_command_transcript.md
.agentx-init/reports/functional_runtime_mvp_baseline_command_transcript.json
.agentx-init/reports/functional_runtime_mvp_proof_bundle.json
.agentx-init/reports/functional_runtime_mvp_acceptance_matrix.json
.agentx-init/reports/FUNCTIONAL_RUNTIME_MVP_ACCEPTANCE_REVIEW.md
.agentx-init/reports/functional_runtime_mvp_command_transcript.md
.agentx-init/reports/functional_runtime_mvp_command_transcript.json
.agentx-init/reports/functional_runtime_mvp_evidence_manifest.json
.agentx-init/reports/functional_runtime_mvp_replay_report.md
.agentx-init/reports/functional_runtime_mvp_replay_report.json
.agentx-init/reports/functional_runtime_compatibility_report.md
.agentx-init/reports/functional_runtime_compatibility_report.json
.agentx-init/reports/functional_runtime_reuse_map.md
.agentx-init/reports/functional_runtime_reuse_map.json
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_before.json
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_after.json
.agentx-init/reports/functional_runtime_mvp_source_mutation_report.json
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.md
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.json
```

If any report is gitignored, prove it is regenerated from tracked source.

---

# 13. Clean-Checkout and Idempotency Requirements

Generated `.agentx-init/reports/*` files may be gitignored. That is acceptable only if tracked source can regenerate them.

Required proof:

```bash
rm -rf .agentx-init/reports
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
```

The second run must not fail due to stale generated files or artifact overwrite conflicts. If artifacts are versioned, versioning must be deterministic and validated.

Add a validator or test proving:

```text
required reports regenerate after deletion
second run is safe
stale report commit is rejected
missing report is rejected
old proof bundle cannot mask current failure
```

---

# 14. Final Manual Verification

After implementation, run:

```bash
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
make test-evolve
make prove-format
git status --short
```

If feasible:

```bash
make test-quick
```

Final answer must include:

```text
files created
files modified
tests added/strengthened
commands run with exit codes
generated reports
final classification
remaining blockers, if any
whether generated .agentx-init reports are reproducible from tracked source in clean checkout
whether proof target is idempotent across two consecutive runs
whether anti-false-PASS audit passed
```

---

# 15. Final Classification Rules

Use exactly these rules.

## FUNCTIONAL_RUNTIME_MVP

Use only if:

```text
make prove-functional-runtime-mvp exits 0 twice consecutively
python3 -m compileall -q tools/agentx_evolve tests exits 0
make prove-format exits 0
make test-evolve exits 0
safe scenario PASS with source mutation proof
unsafe scenario DENIED_AND_RECORDED with invariant/gate/safety evidence
persisted replay validates both scenarios
acceptance matrix is evidence-backed PASS
compatibility report is evidence-backed PASS
reuse map regenerated and validated
command transcript is real
artifact overwrite protection validated
unknown-gap discovery report completed and validated
requirement traceability matrix completed and validated
validator negative tests pass
anti-false-PASS audit passes
clean-checkout report regeneration validated
```

## FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE

Use if:

```text
core scenarios exist and mostly run
but any proof/report/replay/evidence/compatibility/traceability/gap-discovery/anti-false-PASS validator remains incomplete
```

## FUNCTIONAL_SCAFFOLD

Use if:

```text
components exist but end-to-end scenarios do not pass
```

## NOT_FUNCTIONAL

Use if:

```text
no working goal → action → evidence loop exists
```

---

# 16. Required Final Output From Coding Agent

When finished, report:

```text
1. Files created.
2. Files modified.
3. Tests added or strengthened.
4. Existing components reused/wrapped.
5. New gaps discovered beyond the original list.
6. How each discovered gap was closed or classified.
7. Requirement traceability status.
8. Anti-false-PASS audit status.
9. Makefile target changes.
10. Commands run with exit codes.
11. Reports regenerated.
12. Whether make prove-functional-runtime-mvp passed twice consecutively.
13. Whether make test-evolve passed.
14. Whether generated .agentx-init reports are reproducible from tracked source in a clean checkout.
15. Final classification.
16. Remaining blockers, if any.
```

Allowed success claim only if fully proven:

```text
Agent_X has reached FUNCTIONAL_RUNTIME_MVP.
```

Otherwise say exactly what remains incomplete.

---

# 17. Important Implementation Judgment

Prefer small, direct, testable changes over broad rewrites.

If a requirement appears too large for one pass, do not fake completion. Implement the proof validator so it blocks the classification, then report the blocker.

A blocked honest proof is better than a false PASS.

This revision is intentionally conservative: it should make it difficult for the repo to claim `FUNCTIONAL_RUNTIME_MVP` unless the implementation is actually able to survive known-gap closure, unknown-gap discovery, replay validation, evidence corruption tests, and idempotent clean-checkout regeneration.
