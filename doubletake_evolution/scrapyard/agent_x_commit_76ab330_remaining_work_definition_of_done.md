# Agent_X Commit `76ab3300b2562a47c884b8ce39478bfcd35606f0` — Remaining Work to Reach `FUNCTIONAL_RUNTIME_MVP`

## Purpose

This document states exactly what still needs to be done after auditing commit:

```text
76ab3300b2562a47c884b8ce39478bfcd35606f0
```

Current classification remains:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

Target classification:

```text
FUNCTIONAL_RUNTIME_MVP
```

The project is close, but it is not done. The remaining work is not mainly about adding more runtime components. The remaining work is about making the proof layer impossible to fake accidentally.

---

# 1. Executive Verdict

Commit `76ab3300b2562a47c884b8ce39478bfcd35606f0` should not yet be accepted as `FUNCTIONAL_RUNTIME_MVP`.

The main remaining problems are:

```text
1. The default proof target does not prove two full clean consecutive runs.
2. Anti-false-PASS audit can count validator failures for the wrong reason.
3. Gap discovery is still partially hardcoded.
4. Report validator still allows some required rows to be non-PASS.
5. Replay is improved but still too static.
6. Validator negative tests are not included in the MVP proof test list.
7. Traceability validator is too permissive.
8. There is no external CI/status proof for the audited commit.
```

Until these are fixed, the correct classification remains:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

---

# 2. Definition of Done

The work is done only when all conditions below are true.

## 2.1 Required command success

From a clean checkout of the target commit, the following must pass:

```bash
git clean -xfd
git reset --hard HEAD
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp-idempotent
make test-evolve
make prove-format
```

All must exit:

```text
0
```

## 2.2 Required proof behavior

The proof must demonstrate:

```text
safe_report_generation scenario => PASS
unsafe_self_promotion scenario => DENIED_AND_RECORDED
persisted replay validates both scenarios
source mutation proof validates before/after source manifests
artifact overwrite protection is tested and enforced
anti-false-PASS audit rejects all attack cases for the right reason
traceability matrix has only PASS or justified OUT_OF_SCOPE rows
all acceptance rows required for MVP are PASS
make test-evolve is in the transcript with exit_code 0
prove-format is in the transcript with exit_code 0
compileall is in the transcript with exit_code 0
two clean proof runs are recorded and compared
```

## 2.3 Required generated reports

The proof target must regenerate all of these from tracked source:

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
.agentx-init/reports/functional_runtime_mvp_idempotency_report.md
.agentx-init/reports/functional_runtime_mvp_idempotency_report.json
```

## 2.4 Required CI/status proof

There must be either:

```text
1. a GitHub Actions workflow run on the final commit showing success, or
2. a committed/attached command transcript from a clean checkout showing the exact commands above with exit_code 0.
```

Preferred:

```text
GitHub Actions workflow run on the exact final commit.
```

---

# 3. Work Item 1 — Fix Idempotency Proof

## Problem

The default target:

```text
make prove-functional-runtime-mvp
```

currently runs one proof pass and then calls:

```bash
generate_idempotency_report.py --run1 .agentx-init/reports
```

without a second run directory.

This compares:

```text
baseline transcript
vs
final transcript
```

inside the same proof run.

That is not the same as proving:

```text
clean run 1
vs
clean run 2
```

The separate target:

```text
make prove-functional-runtime-mvp-idempotent
```

does two runs, but the main MVP proof does not require it.

## Where to change

```text
Makefile
tools/agentx_evolve/acceptance/generate_idempotency_report.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_idempotency.py
```

## What to do

### Option A — Preferred

Make the main proof target call a real two-run idempotency check.

Because recursive Make targets can be risky, split the proof into:

```text
prove-functional-runtime-mvp-once
prove-functional-runtime-mvp
prove-functional-runtime-mvp-idempotent
```

Suggested structure:

```make
prove-functional-runtime-mvp-once:
	rm -rf .agentx-init/reports/
	mkdir -p .agentx-init/reports/
	$(REC) $(PYTHON) -m compileall -q tools/agentx_evolve tests
	$(REC) $(PYTHON) -m pytest $(MVP_TESTS) -q --tb=short -p no:cacheprovider -m "not live"
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/collect_mvp_proof.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/generate_mvp_reports.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_reuse_map.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_source_safety.py
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_anti_false_pass.py
	$(REC) make test-evolve
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_transcript.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/collect_mvp_proof.py --full
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/collect_mvp_proof.py --rebuild-reports
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/regenerate_transcript_md.py
	@echo "=== prove-functional-runtime-mvp-once: OK ==="

prove-functional-runtime-mvp:
	rm -rf /tmp/agentx-mvp-idempotency
	mkdir -p /tmp/agentx-mvp-idempotency/run1 /tmp/agentx-mvp-idempotency/run2
	$(MAKE) prove-functional-runtime-mvp-once
	cp -R .agentx-init/reports/. /tmp/agentx-mvp-idempotency/run1/
	$(MAKE) prove-functional-runtime-mvp-once
	cp -R .agentx-init/reports/. /tmp/agentx-mvp-idempotency/run2/
	PYTHONPATH="$(MVP_PYTHONPATH)" $(PYTHON) tools/agentx_evolve/acceptance/generate_idempotency_report.py \
	  --run1 /tmp/agentx-mvp-idempotency/run1 \
	  --run2 /tmp/agentx-mvp-idempotency/run2
	$(REC) $(PYTHON) tools/agentx_evolve/validators/validate_functional_runtime_mvp_idempotency.py
	@echo "=== prove-functional-runtime-mvp: OK ==="

prove-functional-runtime-mvp-idempotent: prove-functional-runtime-mvp
	@echo "=== prove-functional-runtime-mvp-idempotent: OK ==="
```

### Option B — Acceptable

Keep `prove-functional-runtime-mvp` as one run, but final classification must require:

```bash
make prove-functional-runtime-mvp-idempotent
```

However, this is weaker because people will naturally run the default proof target and assume it is enough.

## Do not do

Do not accept single-run baseline-vs-final transcript comparison as idempotency proof.

## Done when

```text
make prove-functional-runtime-mvp itself proves two full clean proof runs.
functional_runtime_mvp_idempotency_report.json has exactly two run directories.
Both runs have real transcripts.
Both runs have exit_code 0.
The report compares stable transcript/proof/report content from run 1 and run 2.
validate_functional_runtime_mvp_idempotency.py fails if only one run is present.
```

---

# 4. Work Item 2 — Fix Anti-False-PASS Audit

## Problem

The anti-false-PASS audit copies only:

```text
.agentx-init/reports
```

into a temp workspace.

Then it runs validators with:

```text
cwd = temp workspace
validator path = tools/agentx_evolve/validators/<validator>.py
```

The temp workspace does not contain:

```text
tools/agentx_evolve/validators/
```

So validators can fail because the validator script path does not exist. That means an attack may be counted as rejected even when the validator did not actually inspect the corrupted evidence.

## Where to change

```text
tools/agentx_evolve/acceptance/run_anti_false_pass_audit.py
tools/agentx_evolve/validators/*
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

## What to do

Change the validator invocation model.

Validators must support an explicit report directory:

```bash
python3 tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py \
  --report-dir /tmp/attack/.agentx-init/reports
```

Implement shared helper:

```text
tools/agentx_evolve/validators/common.py
```

Suggested helper:

```python
from pathlib import Path
import argparse

def parse_report_dir() -> Path:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report-dir", default=".agentx-init/reports")
    args = parser.parse_args()
    return Path(args.report_dir)
```

Update every MVP validator to use:

```python
REPORT_DIR = parse_report_dir()
```

Then update anti-false-PASS audit so it runs:

```python
subprocess.run(
    [
        sys.executable,
        str(ROOT / "tools/agentx_evolve/validators" / f"{validator_name}.py"),
        "--report-dir",
        str(attack_ws / ".agentx-init" / "reports"),
    ],
    cwd=str(ROOT),
    ...
)
```

Important:

```text
cwd must be repo root
validator script path must be absolute
report dir must point to corrupted temp copy
```

## Add proof that rejection is for the right reason

For each attack result, record:

```json
{
  "attack_id": 1,
  "name": "PASS row points to missing evidence file",
  "expected_rejectors": ["validate_functional_runtime_mvp_reports"],
  "validator_results": [
    {
      "validator": "validate_functional_runtime_mvp_reports",
      "exit_code": 1,
      "stdout_summary": "...",
      "stderr_summary": "...",
      "reason_contains": "Evidence ref points to missing file"
    }
  ],
  "result": "REJECTED"
}
```

The audit should fail if the expected validator fails only with:

```text
No such file or directory
can't open file
ModuleNotFoundError
ImportError
validator script missing
```

unless the specific attack is intended to test missing validator infrastructure, which it is not.

## Done when

```text
All 15 attack cases are run against corrupted temp report copies.
Validators execute from the real repo root.
Validators read the temp --report-dir.
Each expected rejector fails for a relevant evidence-validation reason.
No attack is counted as rejected because the validator file cannot be opened.
Anti-false-PASS audit JSON includes per-validator stdout/stderr summaries.
validate_functional_runtime_mvp_anti_false_pass.py fails if any attack has infrastructure_error == true.
```

---

# 5. Work Item 3 — Remove Hardcoded Gap Discovery Claims

## Problem

The gap discovery report is still partially hardcoded.

It includes fixed known gaps:

```text
No streaming execution
No distributed cluster support
No persistent queue for inbox
```

It includes fixed new gaps marked `FIXED`:

```text
Non-enforcing source guard allows writes
Self-promotion bypasses decision recording
Artifact store allows overwrite by default
```

It also writes:

```text
final_post_implementation_classification = FUNCTIONAL_RUNTIME_MVP
```

This is not a true unknown-gap discovery pass.

## Where to change

```text
tools/agentx_evolve/acceptance/generate_gap_discovery_report.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_gap_discovery.py
```

## What to do

Gap discovery must be evidence-derived.

Replace hardcoded “new gaps” with scan-derived rows.

Suggested output shape:

```json
{
  "report_type": "functional_runtime_mvp_gap_discovery_report",
  "git_commit": "short sha",
  "search_scope": [],
  "search_patterns": [],
  "documents_inspected": [],
  "source_files_inspected": [],
  "matches": {},
  "findings": [
    {
      "finding_id": "GD-001",
      "pattern": "hardcoded",
      "file": "path",
      "line": 123,
      "context": "line snippet",
      "classification": "MVP_BLOCKER|FIXED|OUT_OF_SCOPE|BENIGN|NEEDS_REVIEW",
      "rationale": "string",
      "closure_evidence": ["path or test"]
    }
  ],
  "known_blockers_from_audit": [],
  "new_blockers_discovered": [],
  "out_of_scope": [],
  "final_pre_implementation_classification": "FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE",
  "final_post_implementation_classification": "FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE|FUNCTIONAL_RUNTIME_MVP",
  "classification_basis": "computed from validators/proof bundle"
}
```

Classification rule:

```text
final_post_implementation_classification = FUNCTIONAL_RUNTIME_MVP
```

only if:

```text
all MVP validators passed
all in-scope gap findings are FIXED or BENIGN
no finding is MVP_BLOCKER or NEEDS_REVIEW
idempotency report passed
anti-false-PASS audit passed
```

## Do not do

Do not hardcode final post-classification to `FUNCTIONAL_RUNTIME_MVP`.

Do not mark a gap `FIXED` unless there is closure evidence.

## Done when

```text
Gap discovery is generated from actual search results.
Every finding has file/line/context when applicable.
Every finding has classification and rationale.
Every FIXED finding has closure evidence.
Validator fails if any finding is NEEDS_REVIEW or MVP_BLOCKER.
Validator fails if final_post_implementation_classification is FUNCTIONAL_RUNTIME_MVP while any MVP validator failed.
```

---

# 6. Work Item 4 — Remove Acceptance Matrix Waivers

## Problem

The report validator currently allows these components to be non-PASS:

```text
artifact overwrite protection
requirement traceability
```

These are not optional. They are required MVP proof rows.

## Where to change

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
tools/agentx_evolve/acceptance/build_acceptance_rows.py
tools/agentx_evolve/acceptance/collect_mvp_proof.py
```

## What to do

Remove:

```python
PRE_EXISTING_GAP_COMPONENTS = {
    "artifact overwrite protection",
    "requirement traceability",
}
```

For `FUNCTIONAL_RUNTIME_MVP`, every required acceptance component must be:

```text
PASS
```

Only acceptable non-PASS row:

```text
unsafe self-promotion scenario = DENIED_AND_RECORDED
```

because denial is the expected safe behavior.

## Done when

```text
validate_functional_runtime_mvp_reports.py fails if artifact overwrite protection is not PASS.
validate_functional_runtime_mvp_reports.py fails if requirement traceability is not PASS.
All required acceptance matrix rows are present.
All required rows have evidence refs.
All evidence refs exist and hash-validate.
No row can be PASS if proof bundle says FAIL/BLOCKED/UNKNOWN.
```

---

# 7. Work Item 5 — Include Validator Negative Tests in MVP Proof

## Problem

The intended validator-negative test file exists:

```text
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

But it is not listed in:

```text
MVP_TESTS
```

inside the Makefile.

That means the main MVP proof does not necessarily run the validator-negative tests.

## Where to change

```text
Makefile
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

## What to do

Add this file to `MVP_TESTS`:

```text
tools/agentx_evolve/tests/test_functional_mvp_validators.py
```

Also add any missing test files for:

```text
idempotency validator
anti-false-PASS audit
traceability validator
gap discovery validator
replay validator
report validator
```

## Important correction

The current negative tests use temp report directories but validators do not properly accept temp report dirs. After Work Item 2, update these tests to call validators with:

```bash
--report-dir <temp report dir>
```

## Done when

```text
MVP_TESTS includes test_functional_mvp_validators.py.
make prove-functional-runtime-mvp runs it.
The command transcript proves it ran.
At least one transcript command contains test_functional_mvp_validators.py.
Validator-negative tests corrupt temp reports and validators reject them for correct reasons.
```

---

# 8. Work Item 6 — Strengthen Replay

## Problem

Replay is improved, but it still mostly reconstructs scenarios from static Python-side defaults:

```text
safe_report_generation
unsafe_self_promotion
```

The replay script reads some runtime context from the manifest, but it does not truly reconstruct from persisted state/event/artifact evidence.

The replay report also initially records:

```text
replay_verdict = expected verdict if scenario test exit_code == 0
```

That is not enough.

## Where to change

```text
tools/agentx_evolve/acceptance/replay_execute.py
tools/agentx_evolve/testing/replay_manifest.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_replay.py
tools/agentx_evolve/acceptance/generate_mvp_reports.py
tests/system/test_functional_runtime_mvp_replay.py
tests/system/test_safe_report_generation_goal.py
tests/system/test_unsafe_self_promotion_goal.py
tools/agentx_evolve/acceptance/scenario_export.py
```

## What to do

### 8.1 Replay manifest must contain enough data

The manifest must include:

```json
{
  "schema_version": "1.0.0",
  "scenario_name": "safe_report_generation",
  "run_id": "string",
  "goal_id": "string",
  "runtime_context": {
    "seed": "string",
    "fixed_clock": "ISO-8601",
    "profile_id": "STRICT",
    "agent_id": "string",
    "target_agent": "string",
    "review_decision": "string",
    "reviewer": "string"
  },
  "goal_text": "string",
  "context_overrides": {},
  "state_records_path": "string",
  "state_records_hash": "sha256",
  "event_log_path": "string",
  "event_log_hash": "sha256",
  "artifact_refs": [],
  "gate_decisions": [],
  "invariant_results": [],
  "review_decisions": [],
  "promotion_decisions": [],
  "safety_events": [],
  "final_verdict": "PASS|DENIED_AND_RECORDED|FAIL|BLOCKED",
  "created_at": "ISO-8601"
}
```

### 8.2 Replay execution must compare behavior

`replay_execute.py` should:

```text
read manifest
verify state_records_hash
verify event_log_hash
verify all artifact hashes
recreate the scenario from manifest goal_text/context_overrides/runtime_context
rerun orchestrator
compare final verdict
compare key gate decisions
compare invariant results
compare promotion decision promoted true/false
compare safety event trigger for unsafe scenario
compare artifact hashes when deterministic
emit replay result JSON
```

### 8.3 Replay report must come from replay execution

In `generate_mvp_reports.py`, do not write:

```text
replay_verdict = expected verdict because scenario test passed
```

Instead:

```text
1. create replay manifests
2. run replay_execute.py for each manifest
3. collect actual replay result
4. write replay report from actual replay result
```

## Done when

```text
validate_functional_runtime_mvp_replay.py fails if replay_execute.py is missing.
validate_functional_runtime_mvp_replay.py fails if event/state/artifact hashes are missing.
validate_functional_runtime_mvp_replay.py fails if replayed verdict differs.
validate_functional_runtime_mvp_replay.py fails if unsafe replay lacks safety event.
Replay report is generated from replay_execute.py output, not scenario test exit code.
```

---

# 9. Work Item 7 — Strengthen Traceability Validation

## Problem

Traceability validation currently accepts:

```text
PASS
OUT_OF_SCOPE
PARTIAL
```

For MVP, `PARTIAL` should not pass unless the project is explicitly not claiming `FUNCTIONAL_RUNTIME_MVP`.

The validator mainly checks that refs are present, not that:

```text
files exist
tests were executed
validators were executed
evidence exists
evidence hashes match
```

## Where to change

```text
tools/agentx_evolve/validators/validate_functional_runtime_mvp_traceability.py
tools/agentx_evolve/acceptance/generate_traceability_matrix.py
```

## What to do

For `FUNCTIONAL_RUNTIME_MVP`, the traceability validator must reject:

```text
PARTIAL
BLOCKED
UNKNOWN
FAIL
```

unless the row is explicitly:

```text
OUT_OF_SCOPE
```

and has a rationale.

For every PASS row, validate:

```text
implementation_refs exist
test_refs exist
validator_refs exist
evidence_refs exist
evidence refs have hashes when file-based
test_refs appear in command transcript with exit_code 0
validator_refs appear in command transcript with exit_code 0, or are run as part of the active proof
```

## Done when

```text
Traceability validator fails on PARTIAL in a FUNCTIONAL_RUNTIME_MVP claim.
Traceability validator fails if a test ref exists but was not executed.
Traceability validator fails if a validator ref exists but was not executed.
Traceability validator fails if an evidence ref is missing or hash mismatched.
Traceability matrix contains no forced PASS rows.
```

---

# 10. Work Item 8 — Add External CI Proof

## Problem

The audited commit has no GitHub Actions workflow runs or status checks.

That means there is no independent proof that the commit passed the full target outside a local/generated report.

## Where to change

```text
.github/workflows/functional-runtime-mvp.yml
```

## What to do

Create a workflow:

```yaml
name: Functional Runtime MVP Proof

on:
  push:
  pull_request:

jobs:
  prove-functional-runtime-mvp:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install test dependencies
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
          if [ -f requirements/seed.txt ]; then pip install -r requirements/seed.txt; fi

      - name: Compile
        run: python3 -m compileall -q tools/agentx_evolve tests

      - name: Functional Runtime MVP Proof
        run: make prove-functional-runtime-mvp

      - name: Second Proof Run
        run: make prove-functional-runtime-mvp

      - name: Idempotent Proof Target
        run: make prove-functional-runtime-mvp-idempotent

      - name: Evolve Tests
        run: make test-evolve

      - name: Format Proof
        run: make prove-format

      - name: Upload MVP Reports
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: functional-runtime-mvp-reports
          path: .agentx-init/reports/
```

## Done when

```text
A GitHub Actions run exists for the final commit.
The run exits success.
Reports are uploaded as artifacts.
The final answer can cite the successful workflow run.
```

---

# 11. Work Item 9 — Make Report Hashing and Evidence Stable

## Problem

Reports include timestamps, generated-at fields, and dynamic hashes. This can cause unstable idempotency checks or make proof bundles stale after final writes.

## Where to change

```text
tools/agentx_evolve/acceptance/collect_mvp_proof.py
tools/agentx_evolve/acceptance/generate_mvp_reports.py
tools/agentx_evolve/acceptance/generate_idempotency_report.py
tools/agentx_evolve/validators/validate_functional_runtime_mvp_reports.py
```

## What to do

Separate:

```text
raw report hash
stable report hash
```

Raw hash:

```text
hash exact file bytes
```

Stable hash:

```text
hash normalized report content with known dynamic fields removed
```

Dynamic fields to normalize:

```text
generated_at
created_at
timestamp
duration_seconds
environment platform details, if allowed
```

But do not normalize:

```text
command
exit_code
git_commit
source
verdict
status
evidence_refs
artifact hashes
state hashes
event hashes
```

## Done when

```text
Idempotency comparison ignores only approved dynamic fields.
Idempotency comparison fails if verdict/status/exit_code/evidence hash changes.
Proof bundle hash validation uses raw hashes for evidence integrity.
Stable hashes are used only for run-to-run idempotency comparison.
```

---

# 12. Suggested Implementation Order

Use this order.

```text
1. Add --report-dir support to validators.
2. Fix anti-false-PASS audit to use real repo root + temp report dir.
3. Add validator-negative tests to MVP_TESTS.
4. Remove report validator waivers.
5. Strengthen traceability validator.
6. Remove hardcoded gap discovery classification.
7. Strengthen replay manifest/execution/report generation.
8. Fix idempotency proof so default target proves two clean runs.
9. Add CI workflow.
10. Run clean verification.
```

Do not start with CI. CI will only show failures until the proof logic is fixed.

---

# 13. Final Verification Commands

After all changes, run:

```bash
git clean -xfd
git reset --hard HEAD
python3 -m compileall -q tools/agentx_evolve tests
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp
make prove-functional-runtime-mvp-idempotent
make test-evolve
make prove-format
git status --short
```

Expected:

```text
all commands exit 0
git status shows only expected generated ignored files, or clean tracked tree
```

If GitHub Actions is added, push and verify:

```text
Functional Runtime MVP Proof workflow => success
```

---

# 14. Final Acceptance Checklist

Do not claim `FUNCTIONAL_RUNTIME_MVP` until every checkbox below is true.

```text
[ ] Main proof target performs or requires two clean proof runs.
[ ] Idempotency report compares run1 vs run2, not baseline vs final transcript.
[ ] Anti-false-PASS audit validators run from repo root.
[ ] Anti-false-PASS audit validators read corrupted temp report dirs.
[ ] Anti-false-PASS audit records validator stdout/stderr/reason per attack.
[ ] No attack is counted as rejected due to missing validator path/import error.
[ ] Gap discovery has no hardcoded final FUNCTIONAL_RUNTIME_MVP claim.
[ ] Every gap finding has evidence and classification.
[ ] No in-scope required acceptance row is allowed non-PASS.
[ ] test_functional_mvp_validators.py is included in MVP_TESTS.
[ ] Traceability rejects PARTIAL/BLOCKED/UNKNOWN/FAIL for MVP claims.
[ ] Traceability verifies files, tests, validators, and evidence refs.
[ ] Replay report is generated from replay_execute.py results.
[ ] Replay validates persisted event/state/artifact hashes.
[ ] make test-evolve appears in transcript with exit_code 0.
[ ] make prove-format appears in transcript with exit_code 0.
[ ] compileall appears in transcript with exit_code 0.
[ ] Source mutation report proves no source mutation for safe scenario.
[ ] Artifact overwrite protection is tested and enforced.
[ ] Compatibility report is PASS and evidence-backed.
[ ] Reuse map is regenerated during proof and validated.
[ ] Proof bundle git_commit matches current commit.
[ ] Evidence manifest hashes match actual files.
[ ] Generated reports regenerate after deleting .agentx-init/reports.
[ ] GitHub Actions or clean-checkout command transcript proves final commit.
```

Only after all boxes are checked may the final classification be:

```text
FUNCTIONAL_RUNTIME_MVP
```

Otherwise, keep:

```text
FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE
```

---

# 15. Final Expected Coding-Agent Output

The coding agent must report:

```text
1. Files created.
2. Files modified.
3. Tests added.
4. Validators changed.
5. How anti-false-PASS was corrected.
6. How gap discovery became evidence-derived.
7. How replay became persisted-evidence-based.
8. How idempotency now proves two clean runs.
9. Commands run with exit codes.
10. GitHub Actions status, if added.
11. Generated reports.
12. Final classification.
13. Remaining blockers, if any.
```

If any required item fails, the final answer must not say `FUNCTIONAL_RUNTIME_MVP`.

Use this exact blocker statement if still incomplete:

```text
Agent_X remains FUNCTIONAL_SCAFFOLD_WITH_MVP_VERTICAL_SLICE because the proof layer still allows incomplete or unverifiable MVP claims.
```
