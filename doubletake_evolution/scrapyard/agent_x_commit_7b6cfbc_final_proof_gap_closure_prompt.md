# Agent_X Commit 7b6cfbc — Final Proof-Layer Gap Closure Prompt

## Target Repository

```text
https://github.com/Astrocytech/Agent_X
```

## Target Commit to Fix From

```text
7b6cfbc21651ade4e749de7f525746f037d3e3f6
```

Commit message:

```text
closing gaps
```

## Current Classification

Do **not** assume this commit is done.

At commit `7b6cfbc21651ade4e749de7f525746f037d3e3f6`, the repository should still be classified as:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

not:

```text
FUNCTIONAL_RUNTIME_MVP
```

The commit improved several implementation pieces, but the proof layer still has false-PASS risk. Your task is to close the exact remaining blockers below.

---

# 1. Main Objective

Convert the current proof/reporting layer from:

```text
report-driven PASS
```

to:

```text
evidence-derived PASS
```

The repository may be classified as `FUNCTIONAL_RUNTIME_MVP` only when the proof target proves the result through:

```text
real scenario execution
real persisted replay manifests
real state/event/artifact hash validation
real source mutation check around the actual safe scenario
real compatibility checks
real unknown-gap discovery
real validator-negative tests
real anti-false-PASS audit
real command transcripts
two consecutive successful proof-target runs
make test-evolve exit 0
```

Do not add new high-level architecture. Do not move to the next Agent_X milestone.

---

# 2. Non-Negotiable Final Success Criteria

The task is complete only if all of these pass:

```bash
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
make test-evolve
make prove-format
```

And the generated proof must show:

```text
1. Acceptance rows are derived from proof objects, not from file existence.
2. Full required acceptance row list is enforced.
3. Replay uses persisted manifests for safe and unsafe scenarios.
4. Replay validates state records, event logs, artifacts, verdicts, gate decisions, invariant results, promotion decisions, and safety events.
5. Safe scenario captures source manifest before and after the actual scenario execution.
6. Source mutation detection fails closed.
7. Gap discovery is generated from a real search pass.
8. Compatibility report is generated from real checks.
9. Anti-false-PASS audit attacks all mutate meaningful evidence and every attack is rejected.
10. Validators have negative tests proving they reject bad evidence.
11. `make test-evolve` exits 0.
12. Generated `.agentx-init/reports/*` can be deleted and regenerated from tracked source.
13. The proof target is idempotent across two consecutive runs.
```

If any item is missing, final classification must remain:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

---

# 3. Exact Remaining Blockers From Commit 7b6cfbc

## Blocker A — Acceptance rows are still mostly hardcoded PASS

### Current problematic file

```text
tools/agentx_evolve/acceptance/build_acceptance_rows.py
```

### Current problem

The file marks many rows as `PASS` if an evidence manifest exists.

A component cannot pass just because the evidence manifest exists.

### Required fix

Rewrite `build_acceptance_rows.py` so it builds every row from a real proof source.

Each row must be derived from one of:

```text
unit test command proof
system scenario proof
persisted replay proof
source mutation proof
artifact safety proof
compatibility proof
reuse-map proof
gap discovery proof
traceability proof
anti-false-PASS proof
validator-negative-test proof
clean-checkout/idempotency proof
```

### Required implementation

Update:

```text
tools/agentx_evolve/acceptance/build_acceptance_rows.py
tools/agentx_evolve/acceptance/proof_result.py
tools/agentx_evolve/acceptance/collect_mvp_proof.py
```

`build_acceptance_rows.py` must expose:

```python
REQUIRED_ACCEPTANCE_COMPONENTS = [
    "deterministic runtime context",
    "workspace manager",
    "artifact store",
    "typed I/O envelope",
    "runtime profile",
    "readiness check",
    "state store",
    "event bus",
    "action lifecycle",
    "contract registry",
    "capability graph",
    "policy rule engine",
    "decision gate",
    "invariant engine",
    "security envelope",
    "transaction manager",
    "simulation engine",
    "report generation executor",
    "observation system",
    "rollback controller",
    "circuit breaker",
    "review interface",
    "promotion gate",
    "scenario harness",
    "functional orchestrator",
    "safe report generation scenario",
    "unsafe self-promotion scenario",
    "persisted replay",
    "compatibility report",
    "reuse map",
    "command transcript",
    "source mutation proof",
    "artifact overwrite protection",
    "requirement traceability",
    "unknown-gap discovery",
    "validator negative tests",
    "anti-false-PASS audit",
    "clean-checkout reproducibility",
    "idempotency",
]
```

Add:

```python
def build_acceptance_rows_from_bundle(bundle: FunctionalMvpProofBundle) -> list[AcceptanceRowProof]:
    ...
```

Rules:

```text
PASS requires status PASS in proof bundle.
PASS requires evidence_refs.
PASS requires evidence hashes to validate.
FAIL/BLOCKED/UNKNOWN must propagate.
Missing proof object means row status BLOCKED.
No row may become PASS from file existence alone.
```

### Required tests

Add or strengthen:

```text
tools/agentx_evolve/tests/test_functional_acceptance.py
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

Required tests:

```text
test_build_acceptance_rows_blocks_missing_component_proof
test_build_acceptance_rows_blocks_pass_without_evidence
test_build_acceptance_rows_propagates_failed_proof
test_build_acceptance_rows_requires_all_required_components
test_acceptance_validator_rejects_missing_required_component
```

---

## Blocker B — Report validator does not enforce the full required row list

### Current problematic file

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
```

### Required fix

The validator must import or duplicate `REQUIRED_ACCEPTANCE_COMPONENTS`.

It must fail if:

```text
any required row is missing
any required row is not PASS
any PASS row lacks evidence_refs
any evidence ref is missing
any evidence hash is wrong
acceptance matrix PASS contradicts proof bundle
acceptance matrix PASS references a failed command
acceptance matrix PASS references stale report
proof bundle missing required proof object
proof bundle git_commit does not match current commit
evidence manifest missing or stale
```

### Required tests

Add:

```text
test_report_validator_rejects_missing_required_acceptance_row
test_report_validator_rejects_unknown_component_only_matrix
test_report_validator_rejects_pass_row_with_failed_command_evidence
test_report_validator_rejects_stale_git_commit
```

---

## Blocker C — Replay is still not persisted replay

### Current problematic files

```text
tools/agentx_evolve/acceptance/generate_mvp_reports.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
tools/agentx_evolve/testing/replay_manifest.py
tests/system/test_functional_runtime_mvp_replay.py
```

### Current problem

`generate_mvp_reports.py` currently creates replay evidence by rerunning pytest files and assigning expected verdicts if pytest exits 0.

That proves that tests pass. It does **not** prove persisted replay.

### Required fix

Implement real persisted replay.

Create or update:

```text
tools/agentx_evolve/testing/replay_manifest.py
tools/agentx_evolve/testing/replay_validator.py
tools/agentx_evolve/testing/scenario_runner.py
tools/agentx_evolve/orchestrator/functional_orchestrator.py
tests/system/test_safe_report_generation_goal.py
tests/system/test_unsafe_self_promotion_goal.py
tests/system/test_functional_runtime_mvp_replay.py
```

Each scenario must write a real manifest:

```text
.agentx-init/reports/functional_runtime_mvp_replay_manifest_safe_report_generation.json
.agentx-init/reports/functional_runtime_mvp_replay_manifest_unsafe_self_promotion.json
```

Each manifest must include:

```json
{
  "schema_version": "1.0.0",
  "scenario_name": "safe_report_generation",
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
    {
      "path": "string",
      "hash": "sha256",
      "type": "report|evidence|state|event"
    }
  ],
  "gate_decisions": [],
  "invariant_results": [],
  "review_decisions": [],
  "promotion_decisions": [],
  "safety_events": [],
  "final_verdict": "PASS|DENIED_AND_RECORDED|FAIL|BLOCKED",
  "created_at": "ISO-8601",
  "git_commit": "short sha"
}
```

### Required replay validator behavior

The replay validator must:

```text
read the persisted manifest
verify manifest schema
verify state_records_path exists
verify state_records_hash matches file
verify event_log_path exists
verify event_log_hash matches file
verify every artifact ref exists
verify every artifact hash matches
reconstruct/rerun the scenario from recorded seed, clock, profile, agent IDs, target agent, review decision, and report content
compare final verdict
compare key artifact hashes
compare gate decision
compare invariant result
compare promotion decision
compare safety event
fail on any mismatch
```

### Remove fallback behavior

In:

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
```

delete the fallback path that accepts replay report rows when no manifests exist.

If no replay manifests exist:

```text
FAIL
```

### Required tests

Add or strengthen:

```text
tests/system/test_functional_runtime_mvp_replay.py
tools/agentx_evolve/tests/test_replay_manifest.py
tools/agentx_evolve/tests/test_replay_validator.py
```

Required tests:

```text
test_safe_scenario_writes_real_replay_manifest
test_unsafe_scenario_writes_real_replay_manifest
test_replay_validator_requires_manifest
test_replay_validator_checks_state_hash
test_replay_validator_checks_event_log_hash
test_replay_validator_checks_artifact_hash
test_replay_validator_rejects_verdict_mismatch
test_replay_validator_rejects_missing_safety_event
test_replay_validator_rejects_missing_self_promotion_invariant
test_replay_reconstructs_safe_scenario_from_manifest
test_replay_reconstructs_unsafe_scenario_from_manifest
```

---

## Blocker D — Safe source mutation proof is not around the actual safe scenario

### Current problematic files

```text
tools/agentx_evolve/acceptance/generate_mvp_reports.py
tools/agentx_evolve/observation/source_manifest.py
tools/agentx_evolve/observation/observer.py
tests/system/test_safe_report_generation_goal.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
```

### Required fix

Move source manifest capture into the safe scenario harness.

Safe scenario must do:

```python
before = collect_source_manifest(...)
result = run_safe_report_generation_goal(...)
after = collect_source_manifest(...)
diff = compare_source_manifests(before, after)
write_source_mutation_report(...)
assert diff["mutation_detected"] is False
```

The source mutation report must include:

```json
{
  "scenario_name": "safe_report_generation",
  "mutation_detected": false,
  "before_manifest": "...",
  "before_manifest_hash": "sha256",
  "after_manifest": "...",
  "after_manifest_hash": "sha256",
  "source_scope": [],
  "files_changed": [],
  "files_added": [],
  "files_removed": [],
  "git_commit": "short sha"
}
```

### Required observer behavior

Update:

```text
tools/agentx_evolve/observation/observer.py
```

Do not silently return `False` on source mutation exceptions.

Instead, fail closed:

```text
source_mutation_detected = true
errors includes "source mutation check failed"
```

### Required tests

Add or strengthen:

```text
tools/agentx_evolve/tests/test_observer.py
tests/system/test_safe_report_generation_goal.py
tools/agentx_evolve/tests/test_source_manifest.py
```

Required tests:

```text
test_safe_scenario_source_manifest_wraps_actual_scenario_execution
test_source_mutation_check_fails_closed_on_exception
test_source_mutation_report_contains_manifest_hashes
test_source_mutation_validator_rejects_report_without_scenario_name
test_source_mutation_validator_rejects_missing_manifest_hash
test_source_mutation_validator_rejects_manifest_hash_mismatch
```

---

## Blocker E — Gap discovery is static, not a real discovery pass

### Current problematic file

```text
tools/agentx_evolve/acceptance/generate_gap_discovery_report.py
```

### Required fix

Rewrite it to perform a real discovery pass.

Create or update:

```text
tools/agentx_evolve/acceptance/gap_discovery.py
tools/agentx_evolve/acceptance/generate_gap_discovery_report.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
```

### Required search scope

Search at least:

```text
Makefile
docs/
tools/agentx_evolve/
tests/
.agentx-init/reports/   # if present
```

### Required search patterns

Search at least:

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

### Required validator behavior

The gap discovery validator must fail if:

```text
search patterns missing
search scope missing
no source files inspected
no documents inspected
matches missing
any match lacks classification
any NEW_GAP lacks resolution
any CLOSED gap lacks evidence_refs
any OUT_OF_SCOPE item lacks rationale
final_post_implementation_classification says FUNCTIONAL_RUNTIME_MVP while any in-scope gap remains unresolved
```

### Required tests

Add:

```text
tools/agentx_evolve/tests/test_gap_discovery.py
```

Required tests:

```text
test_gap_discovery_scans_real_files
test_gap_discovery_records_search_patterns
test_gap_discovery_classifies_matches
test_gap_discovery_validator_rejects_unclassified_match
test_gap_discovery_validator_rejects_closed_gap_without_evidence
```

---

## Blocker F — Compatibility report is still mostly static

### Current problematic file

```text
tools/agentx_evolve/acceptance/compatibility_report.py
```

### Required fix

Generate compatibility checks from the repository state and command transcript.

Required real checks:

```text
Makefile contains prove-functional-runtime-mvp
Makefile still contains all pre-existing critical targets
MVP_TESTS contains all required test files
required validator files exist
required acceptance files exist
required replay files exist
required scenario tests exist
L0/L1/L2 files were not modified by safe scenario
generated reports can be regenerated after deleting .agentx-init/reports
make test-evolve appears in transcript with exit_code 0
prove-format appears in transcript with exit_code 0
compileall appears in transcript with exit_code 0
proof target ran twice consecutively in final manual transcript
```

### Required implementation

Create or update:

```text
tools/agentx_evolve/acceptance/compatibility_report.py
tools/agentx_evolve/acceptance/compatibility_checks.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
```

Compatibility JSON must look like:

```json
{
  "report_type": "functional_runtime_compatibility",
  "verdict": "PASS|FAIL|BLOCKED",
  "git_commit": "short sha",
  "created_at": "ISO-8601",
  "checks": [
    {
      "name": "makefile_target_present",
      "status": "PASS|FAIL|BLOCKED",
      "details": "string",
      "evidence_refs": []
    }
  ],
  "known_failures": [],
  "conflicts_detected": [],
  "migration_decisions": []
}
```

Validator must fail if:

```text
compatibility verdict PASS but any check is not PASS
check lacks evidence_refs
make test-evolve missing from transcript
make test-evolve exit_code != 0
make prove-format missing from transcript
make prove-format exit_code != 0
```

### Required tests

Add:

```text
tools/agentx_evolve/tests/test_compatibility_report.py
```

Required tests:

```text
test_compatibility_report_checks_makefile_target
test_compatibility_report_requires_test_evolve_success
test_compatibility_report_requires_required_files
test_compatibility_validator_rejects_static_preserved_rows
test_compatibility_validator_rejects_pass_with_failed_check
```

---

## Blocker G — Anti-false-PASS audit attack 6 is weak/no-op when all commands pass

### Current problematic file

```text
tools/agentx_evolve/acceptance/run_anti_false_pass_audit.py
```

### Required fix

Rewrite attack 6 so it always creates a meaningful contradiction.

Use both approaches:

```text
1. Inject a fake successful command that never ran.
2. Mutate a real required command record in a way the validator must reject.
```

### Required transcript provenance

Strengthen:

```text
tools/agentx_evolve/acceptance/record_command.py
tools/agentx_evolve/acceptance/command_transcript.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
```

Every command transcript entry must include:

```json
{
  "command": "string",
  "exit_code": 0,
  "timestamp": "ISO-8601",
  "duration_seconds": 1.23,
  "git_commit": "short sha",
  "branch": "string",
  "environment": "string",
  "source": "subprocess",
  "provenance_id": "sha256",
  "stdout_hash": "sha256",
  "stderr_hash": "sha256"
}
```

Validator must reject:

```text
missing provenance_id
missing stdout_hash/stderr_hash
duration_seconds <= 0 for commands that actually ran
unknown command
duplicate command record with contradictory output
source != subprocess
stale git_commit
```

### Required tests

Add:

```text
tools/agentx_evolve/tests/test_anti_false_pass_audit.py
tools/agentx_evolve/tests/test_command_transcript.py
```

Required tests:

```text
test_attack_6_always_mutates_transcript_meaningfully
test_transcript_validator_rejects_fake_successful_command
test_transcript_validator_rejects_missing_provenance_id
test_transcript_validator_rejects_zero_duration_real_command
test_transcript_validator_rejects_stale_git_commit
```

---

## Blocker H — Anti-false-PASS audit warning must fail the proof target

### Current problematic file

```text
tools/agentx_evolve/acceptance/generate_mvp_reports.py
```

### Required fix

Change this pattern:

```python
audit_exit = run_audit_main()
if audit_exit != 0:
    print("WARNING: Anti-false-PASS audit returned non-zero exit")
```

to:

```python
audit_exit = run_audit_main()
if audit_exit != 0:
    raise SystemExit(audit_exit)
```

### Required test

Add:

```text
test_generate_reports_fails_when_anti_false_pass_audit_fails
```

---

## Blocker I — Source mutation validator is too weak

### Current problematic file

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
```

### Required fix

Validator must fail if:

```text
source mutation report missing
source mutation report JSON invalid
scenario_name != safe_report_generation
mutation_detected != false
before_manifest missing
after_manifest missing
before_manifest_hash missing
after_manifest_hash missing
before_manifest_hash mismatch
after_manifest_hash mismatch
source_scope missing
file_count == 0
git_commit missing or stale
files_changed not empty
files_added not empty
files_removed not empty
```

### Required tests

Add:

```text
test_source_safety_validator_rejects_missing_scenario_name
test_source_safety_validator_rejects_missing_manifest_hash
test_source_safety_validator_rejects_manifest_hash_mismatch
test_source_safety_validator_rejects_stale_commit
test_source_safety_validator_rejects_added_removed_changed_files
```

---

## Blocker J — Traceability matrix is too static

### Current problematic file

```text
tools/agentx_evolve/acceptance/generate_traceability_matrix.py
```

### Required fix

Make the matrix generated from:

```text
canonical requirement list
actual file existence
actual test existence
actual validator existence
actual generated evidence existence
proof bundle status
```

Rows may be initialized from a canonical list, but their status must be computed.

Each PASS row must prove:

```text
implementation_refs exist
test_refs exist
validator_refs exist
evidence_refs exist
related proof bundle item has PASS
```

If any referenced path does not exist:

```text
status = BLOCKED
```

not PASS.

### Required tests

Add:

```text
tools/agentx_evolve/tests/test_traceability_matrix.py
```

Required tests:

```text
test_traceability_blocks_missing_impl_ref
test_traceability_blocks_missing_test_ref
test_traceability_blocks_missing_validator_ref
test_traceability_blocks_missing_evidence_ref
test_traceability_blocks_failed_proof_bundle_status
```

---

## Blocker K — Add explicit idempotency target and report

### Current problematic file

```text
Makefile
```

### Required fix

Do **not** call `make prove-functional-runtime-mvp` recursively inside itself.

Add a separate target:

```make
prove-functional-runtime-mvp-idempotent:
	make prove-functional-runtime-mvp
	make prove-functional-runtime-mvp
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/generate_idempotency_report.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_idempotency.py
```

Create:

```text
tools/agentx_evolve/acceptance/generate_idempotency_report.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_idempotency.py
```

Required report:

```text
.agentx-init/reports/functional_runtime_mvp_idempotency_report.json
.agentx-init/reports/functional_runtime_mvp_idempotency_report.md
```

Required JSON:

```json
{
  "report_type": "functional_runtime_mvp_idempotency",
  "git_commit": "short sha",
  "runs": [
    {"command": "make prove-functional-runtime-mvp", "exit_code": 0, "transcript_hash": "sha256"},
    {"command": "make prove-functional-runtime-mvp", "exit_code": 0, "transcript_hash": "sha256"}
  ],
  "verdict": "PASS|FAIL"
}
```

Required tests:

```text
test_idempotency_report_requires_two_runs
test_idempotency_validator_rejects_one_run
test_idempotency_validator_rejects_nonzero_run
```

---

# 4. Required Makefile Behavior

Update:

```text
Makefile
```

Keep:

```make
prove-functional-runtime-mvp
```

but make it fail closed.

Required order:

```make
prove-functional-runtime-mvp:
	rm -rf .agentx-init/reports/
	mkdir -p .agentx-init/reports/
	$(REC) $(PYTHON) -m compileall -q tools/agentx_evolve tests
	$(REC) $(PYTHON) -m pytest $(MVP_TESTS) -q --tb=short -p no:cacheprovider -m "not live"
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/collect_mvp_proof.py --initial
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/generate_mvp_reports.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_reuse_map.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
	$(REC) make test-evolve
	$(REC) make prove-format
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/collect_mvp_proof.py --full
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/regenerate_transcript_md.py
	@echo "=== prove-functional-runtime-mvp: OK ==="
```

Add:

```make
prove-functional-runtime-mvp-idempotent
```

as described above.

---

# 5. Required Report Files

The proof target must generate:

```text
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.md
.agentx-init/reports/functional_runtime_mvp_gap_discovery_report.json
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.md
.agentx-init/reports/functional_runtime_mvp_requirement_traceability_matrix.json
.agentx-init/reports/functional_runtime_mvp_proof_bundle.json
.agentx-init/reports/functional_runtime_mvp_acceptance_matrix.json
.agentx-init/reports/FUNCTIONAL_RUNTIME_MVP_ACCEPTANCE_REVIEW.md
.agentx-init/reports/functional_runtime_mvp_command_transcript.md
.agentx-init/reports/functional_runtime_mvp_command_transcript.json
.agentx-init/reports/functional_runtime_mvp_evidence_manifest.json
.agentx-init/reports/functional_runtime_mvp_replay_report.md
.agentx-init/reports/functional_runtime_mvp_replay_report.json
.agentx-init/reports/functional_runtime_mvp_replay_manifest_safe_report_generation.json
.agentx-init/reports/functional_runtime_mvp_replay_manifest_unsafe_self_promotion.json
.agentx-init/reports/functional_runtime_compatibility_report.md
.agentx-init/reports/functional_runtime_compatibility_report.json
.agentx-init/reports/functional_runtime_reuse_map.md
.agentx-init/reports/functional_runtime_reuse_map.json
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_before.json
.agentx-init/reports/functional_runtime_mvp_source_hash_manifest_after.json
.agentx-init/reports/functional_runtime_mvp_source_mutation_report.json
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.md
.agentx-init/reports/functional_runtime_mvp_anti_false_pass_audit.json
.agentx-init/reports/functional_runtime_mvp_idempotency_report.md
.agentx-init/reports/functional_runtime_mvp_idempotency_report.json
```

If any are gitignored, they must be reproducible from tracked source.

---

# 6. Required Final Commands

After all changes, run:

```bash
git status --short
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp-idempotent
make test-evolve
make prove-format
git status --short
```

If feasible:

```bash
make test-quick
```

Do not claim success unless these commands exit 0.

---

# 7. Final Response Required From Coding Agent

When done, report:

```text
1. Starting commit.
2. Ending commit.
3. Files changed.
4. Files created.
5. Exact blockers closed.
6. New gaps discovered by real search.
7. How each discovered gap was closed or classified.
8. Proof target results with exit codes.
9. test-evolve result with exit code.
10. prove-format result with exit code.
11. Idempotency proof result.
12. Replay manifest proof summary.
13. Source mutation proof summary.
14. Compatibility proof summary.
15. Anti-false-PASS audit summary.
16. Remaining blockers, if any.
17. Final classification.
```

Allowed final classification only if fully proven:

```text
FUNCTIONAL_RUNTIME_MVP
```

Otherwise use:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

---

# 8. Final Judgment Rule

Do not optimize for a green-looking report.

Optimize for a report that is difficult to fake.

If the code cannot honestly prove a requirement, the correct implementation is to make the validator block the classification and report the blocker.

A blocked proof is acceptable.

A false PASS is not.
