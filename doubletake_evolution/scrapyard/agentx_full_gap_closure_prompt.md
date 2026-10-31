# Agent_X Full Gap Closure Prompt

You are working in the `Agent_X` repository.

Current audit checkpoint:

```text
Repository: Astrocytech/Agent_X
Current commit under review: 65f58efbf3752fb5e586e61733c0159b968f0cee
Previous milestone verdict: PARTIAL / NOT_FINAL_ACCEPTED
Current practical state: advanced governed prototype, not final accepted
```


---

## 0A. Mandatory 95%+ Coverage Contract

The previous estimates were useful for triage, but the target of this pass is stricter:

```text
Every in-scope measured area must reach 95% or higher.
No area may remain in the 70–90% band and still be described as complete.
```

This does **not** mean faking percentages. It means doing the implementation, tests, proof-target work, evidence binding, deterministic reporting, and claim-boundary cleanup needed for each in-scope area to pass at or above 95%.

If an area cannot honestly reach 95% because it is outside the internal MVP scope, it must be explicitly moved to:

```text
DEFERRED_OUT_OF_SCOPE
```

with a real waiver, rationale, future acceptance requirement, and proof that it is not required for the current internal MVP milestone.

A waiver must not be used to hide a real blocker. A waived/deferred area may be excluded from the in-scope denominator only when the waiver is justified, evidence-linked, and accepted by the final hard gate.

### Required final area targets

The final scorecard must include the exact areas below and must show **before**, **after**, **target**, **verdict**, and **evidence**.

| Area | Previous estimate before this gap-closure pass | Required final target | Required final interpretation |
|---|---:|---:|---|
| Concept / architecture | 88–92% | >=95% | Architecture contract, capability map, module boundaries, layer boundaries, and claim boundaries are all enforced by proof targets. |
| Governance design | 86–90% | >=95% | Governance rules are implemented, tested, enforced, and cannot be bypassed by static reports or echo-only Makefile targets. |
| Documentation / milestone framing | 88–92% | >=95% | Documentation, README claims, milestone claims, reports, and final verdicts are aligned with evidence and cannot overclaim. |
| Initiator layer | 82–88% | >=95% | Initiator has real source, CLI, tests, proof target, schema validation, handoff validation, input-contract validation, and generated final verdict. |
| Patch execution / controlled evolution | 75–85% | >=95% | Controlled evolution, patch/diff preview, apply/refusal paths, post-apply validation, rollback, and human-review gates are integrated and tested. |
| Audit logs / evidence structure | 76–84% | >=95% | Evidence manifests, artifact versioning, content hashes, provenance, tamper detection, and report integrity are complete for in-scope artifacts. |
| Umbrella-agent proof milestone | 82–88% | >=95% | Umbrella-agent lifecycle is not fixture-only, has forbidden-action rejection, replayable evidence, deterministic reports, and real proof target. |
| Post-umbrella generalization | 70–78% | >=95% | Multiple agent families, positive and negative fixtures, generic adapter path, no hardcoded fixture-only path, replayable artifacts. |
| Benchmark / Scriptor / evaluation harness | 65–75% | >=95% | Evaluation harness, benchmark inventory, source hashes, replay reports, coverage matrix, and failure cases are deterministic and evidence-linked. |
| Replay / reproducibility proof | 52–62% | >=95% | Clean checkout, deterministic repeated runs, no tracked-file dirtiness, normalized report comparison, and reproducibility hard gate all pass. |
| Final acceptance runner | 62–70% | >=95% | Final hard-gated runner consumes all required subtarget reports, fails on false positives, and produces accepted final verdict only from real evidence. |
| Production readiness boundary / internal MVP operations | 38–45% | >=95% | Internal-MVP operational boundary is complete; production-ready claim remains explicitly refused. |
| Company-grade core product boundary | 48–52% | >=95% | In-scope company-core-product/internal-MVP modules have real behavior, tests, proof targets, evidence, docs, and reproducibility. |

The final status must not be:

```text
Prototype ~78%, core product ~50%.
```

The target is:

```text
In-scope governed prototype coverage: >=95%
In-scope company-core-product/internal-MVP coverage: >=95%
Evidence/reproducibility coverage: >=95%
Final hard-gated acceptance: ACCEPTED
Production-ready claim: explicitly NOT claimed
```

### Required scorecard behavior

The scorecard must fail the final gate if any in-scope dimension is below 95%.

The scorecard must include at minimum:

```json
{
  "schema_version": "1.0",
  "report_type": "progress_scorecard",
  "target_threshold": 0.95,
  "dimensions": [
    {
      "name": "architecture",
      "before_percent": 0.90,
      "after_percent": 0.95,
      "target_percent": 0.95,
      "verdict": "ACCEPTED",
      "evidence": [],
      "blocking_gaps": []
    }
  ],
  "all_in_scope_dimensions_at_or_above_95": true,
  "dimensions_below_95": [],
  "waived_or_deferred_dimensions": [],
  "final_verdict": "ACCEPTED"
}
```

The scorecard must use real evidence counts, not arbitrary percentages.

Examples of valid denominators:

```text
accepted required modules / total in-scope required modules
accepted proof targets / total in-scope required proof targets
passed behavioral checks / total required behavioral checks
versioned evidence artifacts / total in-scope evidence artifacts
deterministic report generators / total required report generators
```

Examples of invalid denominators:

```text
number of docs written
number of reports that say ACCEPTED
manual percentage estimate
counting waived modules as implemented
counting static reports as proof
```


Your task is to close **all remaining acceptance gaps** in one coherent pass.

Do not treat this as a documentation-only task. Do not patch reports to say `ACCEPTED` unless the acceptance state is generated by real deterministic proof logic. The goal is to make the repository actually pass from a clean checkout with reproducible local evidence.

---

## 0. Core Claim Boundary

The allowed final claim is:

```text
Agent_X is a working initial governed self-evolution prototype / internal MVP.
```

The system must **not** claim any of the following unless there is separate real evidence and explicit authorization:

```text
production-ready
enterprise-ready
fully autonomous
human-review-free
universal agent
customer-ready SaaS
security-certified
compliance-certified
commercially launched
```

Every report, README, final verdict, docs page, scorecard, and acceptance summary must respect this claim boundary.

---

## 1. Current High-Level Status to Preserve

Recent audit showed real improvement in these areas:

```text
Architecture contract: ACCEPTED
Governance enforcement: ACCEPTED
Docs claim alignment: ACCEPTED
Controlled evolution: ACCEPTED
Evidence closure: ACCEPTED
Umbrella-agent proof: ACCEPTED
Post-umbrella generalization: ACCEPTED
Evaluation harness: ACCEPTED
Company-core-product E2E: ACCEPTED as internal MVP boundary
Production-readiness behavioral: ACCEPTED only as internal MVP boundary, cannot claim PRODUCTION_READY
Replay evidence closure: ACCEPTED
```

However, the final hard-gated milestone is still blocked.

The key current blocker is:

```text
clean_reproducibility_hard_gate: NOT_ACCEPTED
```

The final hard-gated report currently fails because it detects:

```text
Required subtargets NOT_ACCEPTED: prove-clean-reproducibility-hard-gate
all_required_targets_accepted: false
clean_reproducibility_accepted: false
```

The clean reproducibility report previously reported these issues:

```text
Working tree is dirty before proof run.
Non-deterministic output for target 'prove-reproducibility'.
Proof commands dirtied tracked report files.
Working tree is dirty after proof run.
```

Also, the progress scorecard was still conservative, with a rough internal state similar to:

```text
Core Product: ~34.15%
Evidence: ~41.18%
```

and with blocking gaps such as:

```text
No proof target exists for this module.
Skeleton module - not yet implemented.
Retry storm patterns detected.
Promotion decision is not PROMOTION_READY.
Many unversioned artifacts.
```

Your job is to fix the underlying causes, not to hide these warnings.

---

## 2. Non-Negotiable Rules

### 2.1 No fake acceptance

Do not manually edit `final_verdict.json` files to force `ACCEPTED`.

A report may become `ACCEPTED` only if:

1. A deterministic CLI/tool generates it.
2. The corresponding Makefile proof target runs that CLI/tool.
3. The proof target validates required artifacts.
4. The proof target exits non-zero on failure.
5. The final hard gate consumes the generated report and verifies it.

### 2.2 No static verdict laundering

A proof target must not be an echo-only wrapper and must not rely on a pre-written static report.

Bad pattern:

```make
prove-x:
	echo "accepted"
```

Bad pattern:

```python
write_json("final_verdict.json", {"verdict": "ACCEPTED"})
```

unless it is backed by real checks and fail conditions.

Good pattern:

```python
checks = run_actual_checks()
if checks.failed:
    verdict = "NOT_ACCEPTED"
    exit(1)
else:
    verdict = "ACCEPTED"
```

### 2.3 Runtime artifacts must not dirty tracked files

Proof commands must not dirty tracked repository files.

Runtime reports should normally go to an ignored proof-run location such as:

```text
.agentx-proof/current/reports/
.agentx-proof-runs/<run_id>/reports/
```

not to committed `reports/` paths, unless the command is explicitly a documentation-regeneration command and the generated output is intentionally committed.

If committed baseline reports are kept, normal proof runs must either:

1. write to an ignored run directory, or
2. regenerate byte-identical files, or
3. compare generated output against tracked baselines without rewriting them.

### 2.4 Determinism is required

Proof outputs must be deterministic across repeated local runs.

Normalize:

```text
timestamps
absolute paths
temporary directory names
dictionary/list ordering
random seeds
environment-specific values
Python version noise where not relevant
GitHub run IDs
machine-specific usernames
```

Use fixed values when necessary:

```text
AGENTX_RUN_SEED
AGENTX_FIXED_TS
AGENTX_PROOF_RUN_DIR
AGENTX_RUNTIME_REPORTS_DIR
SOURCE_DATE_EPOCH
TZ=UTC
```

Every deterministic report should use stable ordering and normalized paths.

### 2.5 Human review must remain mandatory

Do not bypass human review to get acceptance.

Promotion may become ready only within the internal-MVP claim boundary and only when all required human-review gates are satisfied or explicitly marked as simulated fixture review.

A simulated review must be clearly labeled as a fixture and must not be described as a real human approval.

### 2.6 Do not expand claims beyond evidence

If a feature is only scaffolded, synthetic, fixture-only, interface-only, or local-only, the report must say that.

Do not convert a gap into a false acceptance.

Acceptable classifications:

```text
ACCEPTED
NOT_ACCEPTED
ACCEPTED_AS_INTERNAL_MVP_BOUNDARY
ACCEPTED_AS_LOCAL_DETERMINISTIC_PROTOTYPE_AUDIT
WAIVED_WITH_RATIONALE
DEFERRED_OUT_OF_SCOPE
```

But only `ACCEPTED` and explicitly accepted boundary statuses may count toward final milestone acceptance, and only if the final gate knows how to treat them.

---

## 3. Primary Mission

Make this pass from a clean checkout:

```bash
git status --porcelain
make prove-format

make prove-source-integrity

make prove-exhaustive-inventory-closure

make prove-requirement-reconciliation

make prove-behavioral-execution-matrix

make prove-internal-mvp-user-journey

make prove-component-coverage-95

make prove-dependency-security-boundary

make prove-target-architecture-layer-coverage-95

make prove-clean-reproducibility-hard-gate
make prove-final-acceptance-hard-gated
git status --porcelain
```

Acceptance condition:

```text
The working tree is clean before proof.
The proof run completes successfully.
The working tree is clean after proof, except ignored proof-run directories.
The clean reproducibility final verdict is ACCEPTED.
The final hard-gated final verdict is ACCEPTED.
No tracked files are dirtied by proof commands.
No static acceptance is detected.
No unsupported claim is detected.
No contradiction is detected.
No stale report is detected.
No echo-only target is detected.
```

---

## 4. Required Baseline Audit Before Editing

Start by running and saving a baseline local audit.

Run:

```bash
git status --porcelain
git rev-parse HEAD
python -m compileall -q tools/agentx_evolve tests || true
pytest -q || true
make prove-clean-reproducibility-hard-gate || true
make prove-final-acceptance-hard-gated || true
make prove-progress-scorecard || true
git status --porcelain
```

Create a working note at:

```text
.agentx-proof-runs/baseline/gap_closure_baseline.md
```

It should include:

```text
current commit
commands run
pass/fail result
dirty files before
dirty files after
failing targets
tracked files dirtied by proofs
non-deterministic outputs
missing proof targets
skeleton modules
unversioned artifacts
promotion blockers
```

This baseline note is runtime evidence and should remain ignored unless the repo intentionally tracks proof-run evidence.

---

## 5. Gap Closure Workstreams

Complete the following workstreams in order.

---

# Workstream A — Clean Reproducibility Hard Gate

## A1. Fix proof output location

Inspect every target used by:

```text
prove-clean-reproducibility-hard-gate
prove-reproducibility
prove-api-operator-surface
prove-replay-evidence-closure
prove-final-acceptance-hard-gated
prove-evidence-closure
prove-progress-scorecard
```

Ensure they do not write to tracked `reports/` during normal proof runs.

Preferred pattern:

```make
AGENTX_PROOF_RUN_DIR ?= .agentx-proof/current
AGENTX_RUNTIME_REPORTS_DIR ?= $(AGENTX_PROOF_RUN_DIR)/reports

prove-some-target:
	PYTHONPATH=. $(PYTHON) -m tools.agentx_evolve.some_module.cli --output $(AGENTX_RUNTIME_REPORTS_DIR)/some_module
	PYTHONPATH=. $(PYTHON) tools/agentx_evolve/make_helpers/verify_reports.py \
		--base $(AGENTX_RUNTIME_REPORTS_DIR)/some_module \
		--reports final_verdict,...
```

If `verify_reports.py` currently expects environment variables only, either preserve that style or improve it safely. Do not break existing targets.

## A2. Stop tracked report dirtiness

The previous hard-gate report listed tracked files dirtied under:

```text
reports/api_operator_surface/
reports/replay_evidence_closure/
reports/reproducibility/
reports/clean_reproducibility_hard_gate/
```

Fix the commands so those files are not rewritten during the proof.

If the tracked files are stale and should not be tracked, move them out of `reports/` and into an ignored proof directory, or remove them from tracking if appropriate.

Use `.gitignore` for runtime proof output only. Do not hide source files, docs, tests, or important committed fixtures.

## A3. Fix non-deterministic `prove-reproducibility`

Run `prove-reproducibility` twice in a row and compare output artifacts.

Eliminate differences caused by:

```text
generated_at timestamps
absolute repo paths
temporary paths
file ordering
dictionary ordering
mtime-dependent output
random seeds
environment-specific values
counts affected by proof output from previous run
```

Introduce deterministic normalization helpers if needed.

Suggested helper module:

```text
tools/agentx_evolve/common/determinism.py
```

Possible functions:

```python
stable_now()
normalize_path(path)
stable_json_dump(data, file)
sorted_walk(root)
stable_run_id()
strip_machine_specific_fields(data)
```

## A4. Hard gate must be strict

`prove-clean-reproducibility-hard-gate` must fail if:

```text
working tree dirty before run
tracked files dirtied after run
non-deterministic output detected
required subtarget fails
proof output missing
final verdict not ACCEPTED
```

It must pass only when all requirements pass.

---

# Workstream B — Artifact Versioning and Evidence Binding

The progress scorecard lists many unversioned artifacts.

Do not simply suppress these findings.

Classify artifacts into:

```text
tracked source artifact
tracked baseline report
ignored runtime report
fixture artifact
generated proof-run artifact
deprecated/stale artifact
```

For every artifact that remains tracked and evidence-relevant, ensure it has enough metadata:

```json
{
  "schema_version": "1.0",
  "report_type": "...",
  "generated_by": "...",
  "source_commit": "...",
  "generator_version": "...",
  "command": "...",
  "content_hash": "...",
  "claim_boundary": "...",
  "generated_at": "FIXED_OR_NORMALIZED_TS"
}
```

If this metadata would make old reports noisy, implement a versioning adapter or manifest file rather than hand-editing hundreds of files.

Suggested files:

```text
tools/agentx_evolve/artifact_versioning/
tools/agentx_evolve/artifact_versioning/cli.py
tools/agentx_evolve/artifact_versioning/audit.py
reports/artifact_versioning/   # only if intentionally tracked; otherwise use runtime reports dir
```

The proof should detect:

```text
unversioned tracked artifacts
stale artifacts
runtime artifacts accidentally tracked
missing content hashes
missing source commit
missing generator identity
```

Acceptance condition:

```text
No evidence-relevant tracked artifact is unversioned.
Runtime proof reports are ignored or generated into ignored proof-run directories.
The scorecard no longer treats ignored runtime artifacts as blocking tracked evidence gaps.
```

---

# Workstream C — Missing Proof Targets and Skeleton Modules

The progress scorecard reports:

```text
No proof target exists for this module.
Skeleton module - not yet implemented.
```

Do not convert skeleton modules into fake accepted modules.

For each module in the module registry / target architecture:

1. Determine whether it is required for the internal governed prototype.
2. Determine whether it is deferred/out-of-scope.
3. Determine whether it is only a skeleton.
4. Determine whether it has a CLI.
5. Determine whether it has a Makefile proof target.
6. Determine whether it has tests.
7. Determine whether it has a final verdict generated by real checks.

Create or update a canonical module status matrix.

Suggested artifact:

```text
.agentx-proof/current/reports/module_gap_closure/module_status_matrix.json
```

Required fields per module:

```json
{
  "module": "...",
  "required_for_internal_mvp": true,
  "status": "ACCEPTED|NOT_ACCEPTED|WAIVED_WITH_RATIONALE|DEFERRED_OUT_OF_SCOPE",
  "has_source": true,
  "has_cli": true,
  "has_tests": true,
  "has_make_target": true,
  "has_runtime_proof": true,
  "is_skeleton": false,
  "evidence": ["..."],
  "blocking_gaps": []
}
```

For required modules, either:

```text
implement minimal real behavior + tests + proof target
```

or:

```text
mark NOT_ACCEPTED and keep final gate blocked
```

For deferred modules, add a real waiver with:

```text
reason
scope boundary
why not needed for internal MVP
what would be required later
who/what approved the waiver
```

A waiver must not be counted as full implementation.

---

# Workstream D — Retry Storm / Cost Amplification Risk

The scorecard flagged retry storm patterns.

Audit all retry loops, polling loops, re-run helpers, and tool execution retries.

Required behavior:

```text
bounded retries
exponential or fixed backoff
timeout
clear stop condition
cost budget integration
audit event when retry limit is reached
no infinite loops
no recursive retry without cap
```

Create or update a proof:

```text
prove-retry-storm-guard
```

or integrate into existing:

```text
prove-cost-governance
prove-resource-guard
prove-runtime-observability
```

Acceptance report must include:

```text
files scanned
risky patterns found
risk classification
fixed files
remaining accepted exceptions
retry limits found
timeout checks
cost-budget checks
```

Do not ignore legitimate retry logic; classify it.

---

# Workstream E — Promotion Decision Not Ready

The scorecard flagged promotion decision not ready.

Fix this only within the allowed internal-MVP claim boundary.

Required:

```text
final promotion gate must not claim production readiness
promotion must require human review or fixture-labeled simulated review
promotion must require clean reproducibility
promotion must require final hard gate acceptance
promotion must require unsupported_claim_count == 0
promotion must require contradiction_count == 0
promotion must require static_verdict_count == 0
promotion must require no dirty tracked files
```

If the system is ready only as a governed prototype, use:

```text
PROMOTION_READY_FOR_INTERNAL_MVP
```

not:

```text
PRODUCTION_READY
```

Update:

```text
final_promotion_gate
human_review_gate
promotion_gate
company_core_product_e2e
final_acceptance_hard_gated
progress_scorecard
```

so they all agree.

---

# Workstream F — API Operator Surface

Current audit accepted the API operator surface but warned:

```text
endpoint_count: 0
api_server.py exists but no route decorators found
Boundary: API surface is interface-only, no routes registered.
```

Decide whether an actual minimal local API is required for the internal MVP.

If yes, implement a small local-only API surface with tests:

```text
GET /health
GET /version
GET /proof-targets
GET /runs
GET /runs/{run_id}
GET /artifacts/{run_id}
POST /runs/proof-target
```

Security requirements:

```text
local-only by default
no secret exposure
no arbitrary shell command endpoint
allowlist proof targets only
safe error handling
CORS restricted or disabled by default
structured error response
audit event for run request
```

If no, the final claim must clearly say:

```text
API surface is interface-only and not a runtime API.
```

Do not leave this ambiguous.

---

# Workstream G — Evaluation / Benchmark / Scriptor Closure

The evaluation harness currently passes 50/50 cases, but the benchmark/SCRIPTOR layer must not be accepted only because a small synthetic harness passes.

Audit:

```text
benchmarks/benchcore/
scriptor benchmark targets
source hash manifests
traceability matrix
per-PDF coverage matrix
replay report
generic pattern matrix
universal readiness matrix
```

Required:

```text
benchmark inputs are inventoried
source hashes are stable
coverage matrix is generated deterministically
replay report is generated deterministically
benchmark cannot claim universal readiness from narrow fixtures
negative cases are included
failure cases are visible
```

Acceptance condition:

```text
Evaluation harness remains ACCEPTED.
Benchmark/SCRIPTOR layer is either ACCEPTED with real bounded evidence or explicitly PARTIAL/NOT_ACCEPTED without blocking internal MVP if out of scope.
```

---

# Workstream H — Post-Umbrella Generalization

Current report says post-umbrella generalization is accepted with 8 fixtures:

```text
6 positive fixtures
2 negative fixtures
generic_adapter_passed: true
forbidden_capability_rejections_passed: true
hardcoded_fixture_only: false
```

Verify this is not hardcoded.

Required:

```text
add or preserve fixture diversity
ensure agent type is not hardcoded to umbrella/weather/clothing only
include negative fixtures for malicious code and data exfiltration
include at least one new positive fixture not already hardcoded
ensure generic adapter path is actually exercised
ensure artifacts are generated through shared path, not per-fixture shortcuts
```

Acceptance condition:

```text
generalization remains ACCEPTED
hardcoded_fixture_only remains false
negative fixture rejection remains true
evidence replay remains true
```

---

# Workstream I — CI and Local Equivalence

There is a GitHub workflow file, but the commit had no workflow runs attached.

Improve CI and local proof equivalence.

Required:

```text
CI should run final closeout or hard-gated proof.
Local proof and CI proof should use same proof targets.
CI should upload proof artifacts.
CI should include tamper checks.
CI should fail on dirty generated tracked files.
CI should not mutate committed reports.
```

Ensure this works locally without GitHub:

```bash
make prove-final-closeout-local-equivalence
```

or an equivalent existing target.

Add a clear local command:

```bash
make prove-final-acceptance-hard-gated
```

that gives the same logical result as CI.

Do not claim CI success unless a workflow has actually run successfully.

Report wording must distinguish:

```text
CI workflow configured
```

from:

```text
CI workflow passed
```

---

# Workstream J — Progress Scorecard Repair

The progress scorecard must become useful and non-deceptive.

It should show separate dimensions:

```text
architecture coverage
governance coverage
runtime behavior coverage
evidence/reproducibility coverage
company-core-product coverage
production readiness boundary
final hard-gated acceptance
```

It should not collapse everything into a single inflated percentage.

Required output:

```text
before percentage
after percentage
remaining blockers
waived/deferred modules
accepted modules
not accepted modules
evidence basis for each dimension
```

If the core product remains only ~50%, say so.

Do not force the scorecard to 100% unless all required modules are really complete.

---


---

# Workstream L — Raise Every In-Scope Dimension to 95%+

This workstream is mandatory. It prevents a narrow final-gate pass while the project still remains weak in one or more dimensions.

## L1. Build a canonical coverage calculator

Create or update a coverage calculator that computes per-dimension percentages from real evidence.

Suggested module:

```text
tools/agentx_evolve/coverage_scorecard/
tools/agentx_evolve/coverage_scorecard/cli.py
tools/agentx_evolve/coverage_scorecard/audit.py
```

Suggested Makefile target:

```text
prove-coverage-scorecard-95
```

The calculator must produce:

```text
.agentx-proof/current/reports/coverage_scorecard/final_verdict.json
.agentx-proof/current/reports/coverage_scorecard/coverage_scorecard.json
.agentx-proof/current/reports/coverage_scorecard/dimensions_below_95.json
.agentx-proof/current/reports/coverage_scorecard/waiver_register.json
.agentx-proof/current/reports/coverage_scorecard/evidence_basis.md
```

## L2. Required dimensions

The coverage calculator must include all of these dimensions:

```text
architecture
governance
documentation_claim_alignment
initiator_layer
controlled_evolution
patch_execution
evidence_structure
artifact_versioning
umbrella_agent
post_umbrella_generalization
evaluation_harness
benchmark_scriptor
replay_evidence
clean_reproducibility
final_acceptance_runner
api_operator_surface
company_core_product_internal_mvp
production_readiness_boundary
human_review_and_promotion
runtime_observability
security_and_policy_boundary
packaging_and_local_install
ci_local_equivalence
```

Every in-scope dimension must be:

```text
>= 95%
```

or the final verdict must be:

```text
NOT_ACCEPTED
```

## L3. Required denominator discipline

For each dimension, define:

```text
total_required_items
accepted_items
deferred_items
waived_items
not_accepted_items
percentage
evidence
```

Rules:

```text
accepted_items / total_required_items must be >= 0.95
deferred items are not counted as accepted
waived items are not counted as accepted unless the dimension explicitly permits waiver-based acceptance
required skeletons count as NOT_ACCEPTED
missing proof targets count as NOT_ACCEPTED
static reports count as NOT_ACCEPTED
echo-only targets count as NOT_ACCEPTED
runtime reports that dirty tracked files count as NOT_ACCEPTED
```

## L4. Final hard gate integration

`prove-final-acceptance-hard-gated` must consume `prove-coverage-scorecard-95`.

The final hard gate must fail if:

```text
coverage_scorecard verdict != ACCEPTED
any in-scope dimension < 95%
any required dimension missing
any denominator lacks evidence
any waiver lacks rationale
any required module is hidden by out-of-scope classification
```



---

# Workstream M — Company-Core-Product/Internal-MVP Completion to 95%+

The previous audit treated company-core-product progress as roughly 48–52%. This is not enough for this pass.

The goal is not production readiness. The goal is a coherent internal MVP that could reasonably serve as a company-core prototype.

## M1. Required internal-MVP product capabilities

Bring these in-scope capabilities to >=95% evidence-backed completion:

```text
local installation / setup
single-command local proof run
governed task intake
initiator handoff
context builder
source ingestion
capability registry
policy registry
sandbox / command boundary
candidate workspace
implementation proposal
diff preview
real apply engine for controlled workspace
post-apply validation
rollback
human review fixture and real-review boundary
promotion gate for internal MVP
evidence manifest generation
artifact store / artifact indexing
run ledger
runtime observability
failure taxonomy
remediation router
evaluation harness
post-umbrella agent generalization
local API/operator surface or explicit interface-only refusal
debug bundle
report redaction
claim-boundary enforcement
final acceptance runner
```

For each capability, provide:

```text
source module
CLI entrypoint
Makefile proof target
tests
runtime proof artifact
final verdict
claim boundary
remaining gaps
```

## M2. Required internal-MVP user path

The repository must prove at least one complete local path:

```text
user request / task intake
→ initiator creates/validates handoff
→ context/source ingestion
→ policy/sandbox checks
→ implementation proposal
→ diff preview
→ candidate review
→ controlled apply or refusal
→ post-apply validation
→ rollback path if failure
→ human review boundary
→ promotion decision for internal MVP
→ evidence manifest
→ final report
```

This path must be deterministic and replayable.

## M3. Product readiness boundary

The final report must distinguish:

```text
company-core internal MVP: ACCEPTED if >=95%
production-ready product: NOT_CLAIMED / OUT_OF_SCOPE
```

Do not use production-readiness gaps to block internal-MVP acceptance unless they are required for local deterministic governed operation.

Do not use internal-MVP acceptance to imply production readiness.


# Workstream K — Final Hard-Gated Acceptance

Update the final hard gate so it checks all required subtargets and refuses false positives.

It must check:

```text
architecture_contract accepted
governance_enforcement accepted
docs_claim_alignment accepted
controlled_evolution accepted
umbrella_agent accepted
api_operator_surface accepted or boundary accepted
company_core_product_e2e accepted as internal MVP
evidence_closure accepted
clean_reproducibility_hard_gate accepted
production_readiness_behavioral accepted only as internal MVP boundary
post_umbrella_generalization accepted
evaluation_harness accepted
replay_evidence_closure accepted
artifact_versioning accepted
source_integrity accepted
fresh_checkout_acceptance accepted
exhaustive_inventory_closure accepted
requirement_reconciliation accepted
behavioral_execution_matrix accepted
internal_mvp_user_journey accepted
component_coverage_95 accepted
dependency_security_boundary accepted
target_architecture_layer_coverage accepted
module_gap_closure accepted or accepted with explicit waivers
coverage_scorecard_95 accepted
all_known_gaps_closure accepted
anti_gaming_95 accepted
company_core_product_internal_mvp accepted at >=95%
all in-scope scorecard dimensions >=95%
all in-scope target architecture layers >=95%
all in-scope runtime/component groups >=95%
retry_storm_guard accepted
promotion gate accepted as internal MVP only
```

It must fail if:

```text
any required subtarget is NOT_ACCEPTED
working tree dirty before or after
unsupported_claim_count > 0
static_verdict_count > 0
contradiction_count > 0
stale_report_count > 0
echo_only_target_count > 0
non_gating_command_count > 0
unversioned required artifact count > 0
skeleton required module count > 0
missing required proof target count > 0
clean_reproducibility_accepted != true
determinism_verified != true
```

Final report must clearly say:

```text
verdict: ACCEPTED
claim: INTERNAL_GOVERNED_SELF_EVOLUTION_PROTOTYPE
cannot_claim: [...]
```

or fail.

---

## 6. Implementation Standards

### 6.1 Tests

Add or update tests for any logic you modify.

Minimum:

```bash
pytest -q
python -m compileall -q tools/agentx_evolve tests
```

For deterministic output, add a test that runs the same generator twice and compares normalized output.

### 6.2 Makefile targets

Every important proof module must have a Makefile target.

Target pattern:

```make
prove-x:
	$(PYTHON) -m compileall -q tools/agentx_evolve/x
	PYTHONPATH=. $(PYTHON) -m tools.agentx_evolve.x.cli --output $(AGENTX_RUNTIME_REPORTS_DIR)/x
	PYTHONPATH=. $(PYTHON) tools/agentx_evolve/make_helpers/verify_reports.py ...
	@echo "=== prove-x: OK ==="
```

Targets must fail on errors.

### 6.3 Report schema

Every final verdict should include:

```json
{
  "schema_version": "1.0",
  "report_type": "final_verdict",
  "generated_at": "NORMALIZED_OR_FIXED_TS",
  "verdict": "ACCEPTED|NOT_ACCEPTED|...",
  "claim": "...",
  "cannot_claim": [],
  "errors": [],
  "warnings": [],
  "evidence": [],
  "source_commit": "...",
  "generated_by": "...",
  "command": "..."
}
```

If older reports cannot immediately adopt this schema, provide a compatibility layer and document it.

### 6.4 No absolute local paths in committed reports

Do not write paths like:

```text
/home/glompy/Desktop/ASTROCYTECH/Agent_X/...
/tmp/...
```

into committed acceptance artifacts.

Use repo-relative paths:

```text
reports/...
tools/agentx_evolve/...
.agentx-proof/current/...
```

Runtime-only proof outputs may include absolute paths if ignored, but deterministic reports should normalize them.

---

## 7. Required Final Commands

At the end, run this exact final sequence from a clean working tree.

This is the authoritative final command ladder. Later sections may repeat this ladder for emphasis, but they must not weaken it.

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```

If `make prove-all` includes future/out-of-scope targets, then create and run:

```bash
make prove-all-internal-mvp
```

The final hard gate must explicitly explain whether `prove-all` or `prove-all-internal-mvp` is the correct final target for the internal-MVP milestone.

Then run the determinism check:

```bash
rm -rf .agentx-proof/current .agentx-proof-runs/determinism-a .agentx-proof-runs/determinism-b

AGENTX_PROOF_RUN_DIR=.agentx-proof-runs/determinism-a \
AGENTX_RUN_SEED=agentx-fixed-seed \
AGENTX_FIXED_TS=2026-07-06T00:00:00Z \
TZ=UTC \
make prove-final-acceptance-hard-gated

AGENTX_PROOF_RUN_DIR=.agentx-proof-runs/determinism-b \
AGENTX_RUN_SEED=agentx-fixed-seed \
AGENTX_FIXED_TS=2026-07-06T00:00:00Z \
TZ=UTC \
make prove-final-acceptance-hard-gated

diff -ru .agentx-proof-runs/determinism-a/reports .agentx-proof-runs/determinism-b/reports
```

If exact diff is too strict because of allowed fields, implement and run a normalized diff command:

```bash
python tools/agentx_evolve/make_helpers/compare_normalized_reports.py \
  .agentx-proof-runs/determinism-a/reports \
  .agentx-proof-runs/determinism-b/reports
```

The normalized comparison must not ignore meaningful evidence differences.

---

## 8. Required Final Deliverables

When done, provide a final response containing:

```text
1. Final verdict
2. Final commit hash
3. Exact commands run
4. Which commands passed
5. Which files changed
6. Which gaps were closed
7. Which gaps remain, if any
8. Whether final hard-gated acceptance is ACCEPTED
9. Whether clean reproducibility is ACCEPTED
10. Whether the working tree stayed clean after proof
11. Updated percentage table with before/after/target columns for every audited area
12. Explicit proof that every in-scope area is >=95%
13. Explicit list of any waived/deferred areas and why they are not in scope
14. Explicit claim boundary
15. Explicit cannot-claim list
```

Also produce a Markdown report at:

```text
.agentx-proof/current/reports/final_gap_closure_summary.md
```

with tables:

```text
Before vs After percentages
Required targets and verdicts
Closed gaps
Remaining gaps
Waived/deferred modules
Commands and outputs
Evidence artifact locations
Claim boundary
```

If any required command fails, do not pretend completion. Stop and report:

```text
NOT_ACCEPTED
failing command
root cause
files likely involved
minimal next fix
```

---

## 9. Acceptance Definition

The work is complete only when all of the following are true:

```text
git status clean before final proof
compileall passes
pytest passes
prove-clean-reproducibility-hard-gate passes
prove-final-acceptance-hard-gated passes
clean reproducibility final verdict is ACCEPTED
final hard-gated final verdict is ACCEPTED
runtime proof does not dirty tracked files
all required proof targets are real and gating
no static acceptance remains
no unsupported claims remain
no contradictions remain
no stale required reports remain
no required skeleton modules remain
no required modules lack proof targets
artifact versioning/evidence binding is accepted
promotion readiness is accepted only for internal MVP boundary
production-ready claim is explicitly refused
CI is configured but not claimed as passed unless a real run passed
progress scorecard is updated honestly
coverage scorecard shows every in-scope dimension at >=95%
company-core-product/internal-MVP boundary is >=95%
evidence/reproducibility coverage is >=95%
no dimension remains below 95 unless explicitly deferred out of scope with accepted waiver
anti-gaming/falsification proof is ACCEPTED
denominator lock exists and is respected
independent final audit packet is generated
source integrity proof is ACCEPTED
fresh checkout acceptance proof is ACCEPTED
make prove-format passes
make prove-all or accepted internal-MVP successor passes
exhaustive inventory closure is ACCEPTED
requirement reconciliation is ACCEPTED
prompt consistency closure is ACCEPTED
all mandatory earlier-workstream proof targets are ACCEPTED
final proof dependency graph is ACCEPTED
no final-gate recursion or composite-target recursion exists
direct reproducibility proof is ACCEPTED
CI/local equivalence proof is ACCEPTED
fresh-checkout prerequisite does not call the final hard gate
no discovered in-scope area is missing from the 95% scorecard
behavioral execution matrix is ACCEPTED
internal MVP user journey is ACCEPTED
no area reaches 95% through report-only evidence
component coverage 95 proof is ACCEPTED
dependency/security boundary proof is ACCEPTED
runtime adapter, sandbox, packaging, observability, and operations components are either >=95% or explicitly out of scope with accepted waiver
target architecture layer coverage proof is ACCEPTED
Git integration, task queue, monitoring, model/runtime adapters, long-term learning, doc sync, and Backup/DR are explicitly accepted or explicitly deferred with accepted waiver
```

Final acceptable statement:

```text
Agent_X is now accepted as a local, deterministic, governed self-evolution prototype / internal MVP, with production readiness explicitly out of scope.
```

Unacceptable final statement:

```text
Agent_X is production-ready, fully autonomous, universal, enterprise-ready, or commercially launch-ready.
```

---

## 10. Start Now

Proceed without asking for confirmation.

First, run the baseline audit.

Then close the gaps in the order above.

Prefer real minimal implementations over broad scaffolding.

Do not fake acceptance.

Do not weaken the gates.

Do not hide blockers.

Make the repository prove the milestone.


---

## 11. Final 95%+ Completion Bar

The final response is acceptable only if it can honestly say:

```text
All in-scope Agent_X governed prototype/internal-MVP areas are at or above 95% coverage by the repository's own evidence-backed scorecard.
Clean reproducibility is ACCEPTED.
Final hard-gated acceptance is ACCEPTED.
Company-core-product/internal-MVP boundary is ACCEPTED at or above 95%.
Production readiness remains explicitly NOT claimed.
```

If any in-scope area remains below 95%, the final answer must be:

```text
NOT_ACCEPTED
```

and must identify the exact area, percentage, evidence gap, and next repair.


---

## 12. Mandatory All-Known-Gaps Closure Ledger

Before declaring completion, create a closure ledger that maps **every known audit gap** to a concrete fix and evidence artifact.

This section is mandatory because the target is not merely to pass a few commands. The target is to raise every in-scope area to **95% or above**.

Create:

```text
.agentx-proof/current/reports/all_known_gaps_closure/all_known_gaps_closure_ledger.json
.agentx-proof/current/reports/all_known_gaps_closure/all_known_gaps_closure_ledger.md
.agentx-proof/current/reports/all_known_gaps_closure/final_verdict.json
```

Add Makefile target:

```text
prove-all-known-gaps-closure
```

`prove-final-acceptance-hard-gated` must consume this target.

The ledger must contain one row for each of the following known gaps:

| Gap ID | Known gap | Required closure evidence | Required final state |
|---|---|---|---|
| G001 | `clean_reproducibility_hard_gate` was `NOT_ACCEPTED` | clean reproducibility final verdict, deterministic repeated run comparison, clean git status before/after | `ACCEPTED` |
| G002 | Proof commands dirtied tracked files | before/after git status, list of tracked files dirtied by proof run | zero tracked files dirtied |
| G003 | `prove-reproducibility` had non-deterministic output | two-run normalized diff report | deterministic |
| G004 | Final hard gate failed because clean reproducibility was not accepted | final hard-gated verdict consuming clean reproducibility | `ACCEPTED` |
| G005 | No CI workflow run was attached to the audited commit | CI/local-equivalence boundary report | either real passing CI evidence or explicit “CI configured, not claimed passed” |
| G006 | Progress scorecard showed core product around 34.15% | updated evidence-backed scorecard | in-scope core product/internal MVP >=95% |
| G007 | Progress scorecard showed evidence around 41.18% | updated evidence-backed evidence scorecard | evidence/reproducibility >=95% |
| G008 | Missing proof targets for modules | module status matrix + proof target registry | no required in-scope module lacks proof target |
| G009 | Skeleton modules existed | skeleton audit + implementation/waiver ledger | no required in-scope skeleton remains |
| G010 | Retry storm/cost-amplification patterns detected | retry-storm guard report | accepted or justified bounded exceptions only |
| G011 | Promotion decision was not ready | internal-MVP promotion gate report | `PROMOTION_READY_FOR_INTERNAL_MVP`, not production-ready |
| G012 | Many unversioned artifacts | artifact versioning report | no in-scope evidence artifact unversioned |
| G013 | API surface had zero endpoints / interface-only ambiguity | API runtime or explicit interface-only boundary | accepted and unambiguous |
| G014 | Benchmark/SCRIPTOR evidence was partial | benchmark coverage, replay, source-hash, and negative-case reports | >=95% or explicitly deferred out of scope |
| G015 | Post-umbrella generalization may still be fixture-narrow | generic adapter proof and expanded fixture set | >=95%, not hardcoded fixture-only |
| G016 | Initiator-layer report artifact was not clearly committed/found | generated runtime initiator final verdict and target | >=95% accepted |
| G017 | Evidence binding target existed but report artifact was not clearly found | generated runtime evidence binding final verdict and target | >=95% accepted |
| G018 | Production readiness could be confused with internal MVP | production boundary report | internal MVP accepted; production-ready refused |
| G019 | Static acceptance / echo-only proof risk | anti-false-pass scan | zero static acceptance and zero echo-only targets |
| G020 | Unsupported/overbroad claims risk | claim-boundary scan | zero unsupported claims |
| G021 | Stale report risk | stale report scan | zero stale required reports |
| G022 | Absolute local paths in reports | path normalization report | no absolute local paths in committed evidence |
| G023 | Artifact/report timestamps may be non-deterministic | deterministic timestamp normalization report | stable or normalized timestamps |
| G024 | Human review could be bypassed | human-review and promotion boundary report | human review enforced or fixture-labeled |
| G025 | Company-core-product path incomplete | end-to-end internal-MVP product path report | full local governed path accepted >=95% |

The ledger schema must include:

```json
{
  "schema_version": "1.0",
  "report_type": "all_known_gaps_closure_ledger",
  "target_threshold": 0.95,
  "gaps": [
    {
      "gap_id": "G001",
      "gap": "clean_reproducibility_hard_gate was NOT_ACCEPTED",
      "status": "CLOSED|OPEN|DEFERRED_OUT_OF_SCOPE",
      "required_for_internal_mvp": true,
      "closure_evidence": [],
      "proof_target": "prove-clean-reproducibility-hard-gate",
      "final_percentage": 1.0,
      "blocking_reason": null
    }
  ],
  "open_required_gaps": [],
  "all_required_gaps_closed": true,
  "all_in_scope_areas_at_or_above_95": true,
  "final_verdict": "ACCEPTED"
}
```

Rules:

```text
No required gap may be marked CLOSED without evidence.
No required gap may be moved out of scope without a waiver accepted by the final gate.
No area may be marked >=95% if any required gap in that area remains open.
The final hard gate must fail if this ledger is missing, incomplete, or inconsistent.
```

---

## 13. Mandatory Exact Before/After Table

The final generated summary must include this exact table structure, with real percentages filled in from evidence-backed scorecard logic:

| Area | Previous estimate | Required target | Final measured % | Delta | Final verdict | Evidence |
|---|---:|---:|---:|---:|---|---|
| Concept / architecture | 88–92% | >=95% | TBD | TBD | TBD | TBD |
| Governance design | 86–90% | >=95% | TBD | TBD | TBD | TBD |
| Documentation / milestone framing | 88–92% | >=95% | TBD | TBD | TBD | TBD |
| Initiator layer | 82–88% | >=95% | TBD | TBD | TBD | TBD |
| Patch execution / controlled evolution | 75–85% | >=95% | TBD | TBD | TBD | TBD |
| Audit logs / evidence structure | 76–84% | >=95% | TBD | TBD | TBD | TBD |
| Umbrella-agent proof milestone | 82–88% | >=95% | TBD | TBD | TBD | TBD |
| Post-umbrella generalization | 70–78% | >=95% | TBD | TBD | TBD | TBD |
| Benchmark / Scriptor / evaluation harness | 65–75% | >=95% | TBD | TBD | TBD | TBD |
| Replay / reproducibility proof | 52–62% | >=95% | TBD | TBD | TBD | TBD |
| Final acceptance runner | 62–70% | >=95% | TBD | TBD | TBD | TBD |
| Production readiness boundary / internal MVP operations | 38–45% | >=95% | TBD | TBD | TBD | TBD |
| Company-grade core product boundary | 48–52% | >=95% | TBD | TBD | TBD | TBD |

The final summary must fail if any `Final measured %` is below 95% for an in-scope area.

The final summary must explicitly distinguish:

```text
in-scope and accepted
in-scope and not accepted
deferred out of scope
accepted only as internal-MVP boundary
not claimed
```

---

## 14. Mandatory Final Stop Condition

Do not stop after partial improvement.

Do not stop after reaching 80%, 85%, or 90%.

Stop only when one of these is true:

### Successful stop condition

```text
All in-scope areas are >=95%.
All required known gaps are CLOSED.
Clean reproducibility is ACCEPTED.
Final hard-gated acceptance is ACCEPTED.
Working tree is clean before and after proof.
Production-ready claim is explicitly refused.
```

### Failure stop condition

```text
At least one in-scope area remains below 95%.
At least one required known gap remains open.
A required proof target fails.
The working tree is dirty after proof.
Determinism comparison fails.
The final hard gate is NOT_ACCEPTED.
```

If failure stop condition occurs, report `NOT_ACCEPTED` and do not claim milestone completion.



---

## 15. Mandatory 95% Anti-Gaming and Falsification Tests

The 95% requirement must be protected against denominator manipulation, waiver abuse, static acceptance, and dropped dimensions.

Create or update:

```text
tools/agentx_evolve/anti_gaming_95/
tools/agentx_evolve/anti_gaming_95/cli.py
tools/agentx_evolve/anti_gaming_95/audit.py
tests/test_anti_gaming_95.py
```

Add Makefile target:

```text
prove-anti-gaming-95
```

`prove-final-acceptance-hard-gated` must consume this target.

The anti-gaming proof must create:

```text
.agentx-proof/current/reports/anti_gaming_95/final_verdict.json
.agentx-proof/current/reports/anti_gaming_95/denominator_lock_report.json
.agentx-proof/current/reports/anti_gaming_95/waiver_abuse_report.json
.agentx-proof/current/reports/anti_gaming_95/dropped_dimension_report.json
.agentx-proof/current/reports/anti_gaming_95/falsification_cases_report.json
```

### Required anti-gaming checks

The final gate must fail if any of these happen:

```text
A required dimension is removed from the scorecard.
A required item is removed from a denominator without accepted waiver.
A required module is relabeled as out of scope without evidence.
A skeleton module is counted as implemented.
A static final_verdict.json is counted as proof.
An echo-only Makefile target is counted as proof.
A generated report says ACCEPTED but its required evidence files are missing.
A dimension below 95% is hidden by averaging with other dimensions.
A waived/deferred item is counted as implemented.
A stale report from a previous commit is counted as current evidence.
A runtime artifact dirties tracked files but is ignored by the scorecard.
A production-ready claim appears in docs/reports while production is out of scope.
```

### Required falsification cases

Add tests or fixture-based checks proving that the gates reject bad states.

At minimum, the anti-gaming proof must simulate or fixture-test these cases:

| Case ID | Falsification case | Expected result |
|---|---|---|
| F001 | Remove one required scorecard dimension | final gate rejects |
| F002 | Set a dimension to 94.9% | final gate rejects |
| F003 | Count waived item as implemented | final gate rejects |
| F004 | Mark skeleton module as accepted | final gate rejects |
| F005 | Replace a proof target with echo-only acceptance | final gate rejects |
| F006 | Use static `final_verdict.json` without generator evidence | final gate rejects |
| F007 | Add unsupported `production-ready` claim | final gate rejects |
| F008 | Use stale report from different commit | final gate rejects |
| F009 | Drop dirty tracked files from reproducibility report | final gate rejects |
| F010 | Remove required known gap from closure ledger | final gate rejects |
| F011 | Missing evidence file for a closed gap | final gate rejects |
| F012 | Absolute local path appears in committed evidence | final gate rejects |

Acceptance condition:

```text
prove-anti-gaming-95 returns ACCEPTED only if all falsification cases are rejected.
```

The anti-gaming report must include:

```json
{
  "schema_version": "1.0",
  "report_type": "anti_gaming_95",
  "verdict": "ACCEPTED",
  "falsification_cases_total": 12,
  "falsification_cases_rejected": 12,
  "denominator_locked": true,
  "required_dimensions_present": true,
  "waiver_abuse_detected": true,
  "static_acceptance_rejected": true,
  "echo_only_targets_rejected": true,
  "production_claim_rejected": true
}
```

---

## 16. Denominator Lock Before Repair

Before changing any implementation, lock the in-scope denominator for the 95% score.

Create:

```text
.agentx-proof/current/reports/coverage_scorecard/denominator_lock.json
.agentx-proof/current/reports/coverage_scorecard/denominator_lock.md
```

This lock must list:

```text
all required dimensions
all required modules per dimension
all required proof targets per dimension
all allowed waivers/deferred items
all forbidden denominator changes
source of each requirement
```

After repairs, compare final coverage against this locked denominator.

The final gate must fail if:

```text
the denominator lock is missing
a required dimension disappears
a required module disappears without accepted waiver
the final denominator is smaller than the baseline denominator without rationale
the denominator changes after failures are found merely to raise percentages
```

Allowed denominator changes:

```text
add new required items
add new dimensions
remove duplicate aliases
merge exact duplicate modules only with traceability
defer truly out-of-scope items only with accepted waiver
```

Forbidden denominator changes:

```text
remove failing modules to raise score
move required internal-MVP modules out of scope without evidence
count documentation-only scaffolds as implementation
count static reports as proof
count waived items as implemented
```

---

## 17. Independent Final Self-Audit Packet

At the end, create a packet intended for an independent reviewer or another LLM audit.

Create:

```text
.agentx-proof/current/reports/final_independent_audit_packet/README.md
.agentx-proof/current/reports/final_independent_audit_packet/command_transcript.md
.agentx-proof/current/reports/final_independent_audit_packet/evidence_index.json
.agentx-proof/current/reports/final_independent_audit_packet/scorecard_before_after.md
.agentx-proof/current/reports/final_independent_audit_packet/known_gaps_closure.md
.agentx-proof/current/reports/final_independent_audit_packet/claim_boundary.md
.agentx-proof/current/reports/final_independent_audit_packet/final_verdict.json
```

The packet must allow a reviewer to answer without guessing:

```text
What changed?
What gap did each change close?
What command proves each gap is closed?
What evidence file supports each accepted area?
Which areas are at or above 95%?
Which areas are out of scope and why?
Did proof runs dirty tracked files?
Did determinism pass?
Did final acceptance pass?
What claims are still forbidden?
```

The final packet verdict must be `ACCEPTED` only if:

```text
coverage_scorecard_95 == ACCEPTED
all_known_gaps_closure == ACCEPTED
anti_gaming_95 == ACCEPTED
clean_reproducibility_hard_gate == ACCEPTED
final_acceptance_hard_gated == ACCEPTED
```



---

## 18. Source Integrity, Formatting, and Fresh-Clone Proof

Earlier milestone checks were blocked partly by repository/file integrity problems, including raw files that appeared collapsed or malformed. The final 95%+ closure must explicitly prove that this cannot remain hidden.

Create or update:

```text
tools/agentx_evolve/source_integrity/
tools/agentx_evolve/source_integrity/cli.py
tools/agentx_evolve/source_integrity/audit.py
tests/test_source_integrity.py
```

Add Makefile target:

```text
prove-source-integrity
```

`prove-final-acceptance-hard-gated` must consume this target.

The source integrity proof must check:

```text
Makefile parses and required targets exist
shell scripts have valid newlines and shebangs where needed
Python files parse with ast.parse
JSON files parse with json.load
YAML workflow files parse or pass a safe syntax check
Markdown files are not single-line collapsed blobs unless intentionally minified
no required source/proof script has escaped "\n" instead of real newlines
no proof script is empty
no proof script is echo-only
no required CLI file is missing
no file has obvious binary corruption where text is expected
line endings are normalized or tolerated consistently
```

At minimum, scan these paths:

```text
Makefile
scripts/
tools/agentx_evolve/
tests/
.github/workflows/
docs/
benchmarks/
examples/
fixtures/
```

The report must include:

```text
files_scanned
malformed_files
collapsed_text_files
parse_failures
missing_shebang_scripts
empty_required_files
echo_only_targets
required_targets_missing
final_verdict
```

Acceptance condition:

```text
prove-source-integrity == ACCEPTED
```

---

## 19. Fresh Clean Checkout Acceptance

The final proof must not rely on a dirty local working tree, stale local artifacts, or untracked runtime files already present.

There are two separate fresh-checkout concepts:

```text
pre-final fresh-checkout prerequisite
post-final fresh-checkout closeout
```

The final hard gate may consume only the **pre-final prerequisite**. It must not consume a target that calls the final hard gate, because that would create recursion.

Create or update:

```text
tools/agentx_evolve/fresh_checkout_acceptance/
tools/agentx_evolve/fresh_checkout_acceptance/cli.py
tools/agentx_evolve/fresh_checkout_acceptance/audit.py
```

Add Makefile target:

```text
prove-fresh-checkout-acceptance
```

This target is a **pre-final prerequisite**. It must run or simulate safely from a clean checkout of the current commit and verify all prerequisite proof conditions **except** `prove-final-acceptance-hard-gated`.

Required behavior:

```text
create temporary clean checkout or verify current checkout is clean
install required local/test dependencies or verify they are available
run source integrity
run compileall
run pytest
run prove-format
run prove-source-integrity
run prove-exhaustive-inventory-closure
run prove-requirement-reconciliation
run prove-prompt-consistency-closure
run prove-behavioral-execution-matrix
run prove-internal-mvp-user-journey
run prove-component-coverage-95
run prove-dependency-security-boundary
run prove-target-architecture-layer-coverage-95
run prove-clean-reproducibility-hard-gate
run prove-coverage-scorecard-95
run prove-all-known-gaps-closure
run prove-anti-gaming-95
verify git status is clean after proof
verify runtime artifacts are ignored
verify no tracked files changed
```

Forbidden behavior inside `prove-fresh-checkout-acceptance`:

```text
must not call prove-final-acceptance-hard-gated
must not call make prove-all if prove-all calls the final gate
must not create recursive proof dependency through a composite target
```

If fully cloning is impractical inside the local proof environment, the proof may use a controlled temporary copy, but the report must clearly state the limitation:

```text
fresh_checkout_mode: "temporary_copy" | "git_clone" | "current_clean_checkout"
```

The final report must include:

```text
source_commit
checkout_mode
commands_run
commands_passed
commands_failed
dirty_files_before
dirty_files_after
tracked_files_changed
ignored_runtime_outputs
recursion_detected
final_verdict
```

Acceptance condition:

```text
prove-fresh-checkout-acceptance == ACCEPTED
```

The final hard gate must fail if this pre-final prerequisite target is missing or not accepted.

For post-final closeout, create one of these if needed:

```text
make prove-all
make prove-all-internal-mvp
```

That closeout wrapper may call `prove-final-acceptance-hard-gated` at the end, but it must not be consumed by the final gate.

---

## 20. Final Required Command Superset

The final command sequence must include the full proof ladder, not only the new targets.

Run from a clean checkout:

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```

If `make prove-all` is too broad or intentionally includes future/out-of-scope targets, then it must either:

```text
pass, or
be split into make prove-all-internal-mvp and make prove-all-future-scope,
with the final gate consuming prove-all-internal-mvp.
```

Do not ignore a failing `make prove-all` without documenting why it is too broad and what target replaces it for the internal MVP milestone.

---

## 21. Final Gate Complete Consumption List

The final hard gate must consume all of these prerequisite targets or their exact accepted successor names.

Important: the final gate must **not** consume itself, and it must not require a broad composite target that calls the final gate recursively.

```text
prove-format
prove-source-integrity
prove-architecture-contract
prove-governance-enforcement
prove-docs-claim-alignment
prove-initiator-layer
prove-api-operator-surface
prove-artifact-versioning
prove-evidence-binding
prove-module-gap-closure
prove-retry-storm-guard
prove-internal-mvp-promotion-gate
prove-exhaustive-inventory-closure
prove-requirement-reconciliation
prove-prompt-consistency-closure
prove-behavioral-execution-matrix
prove-internal-mvp-user-journey
prove-component-coverage-95
prove-dependency-security-boundary
prove-target-architecture-layer-coverage-95
prove-fresh-checkout-acceptance
prove-ci-local-equivalence
prove-reproducibility
prove-clean-reproducibility-hard-gate
prove-evidence-closure
prove-replay-evidence-closure
prove-controlled-evolution
prove-umbrella-agent
prove-post-umbrella-generalization
prove-evaluation-harness
prove-company-core-product-e2e
prove-production-readiness-behavioral
prove-progress-scorecard
prove-coverage-scorecard-95
prove-all-known-gaps-closure
prove-anti-gaming-95
prove-final-proof-dependency-graph
```

`prove-final-acceptance-hard-gated` must run **after** these prerequisites and must verify their generated runtime reports.

`make prove-all` or an accepted `make prove-all-internal-mvp` successor must run as a final closeout command, but it must not create recursion inside `prove-final-acceptance-hard-gated`.

It must fail if:

```text
any prerequisite target is missing
any prerequisite target is non-gating
any prerequisite target is echo-only
any prerequisite target relies only on stale committed reports
any prerequisite target dirties tracked files
any prerequisite target cannot run from a clean checkout
any prerequisite target reports below 95% for an in-scope dimension
any in-scope target architecture layer is absent or below 95%
any in-scope runtime/component group is absent or below 95%
any behavioral scenario required for internal MVP is absent or report-only
any discovered in-scope requirement is missing from the final scorecard or closure ledger
the final hard gate attempts to consume itself recursively
the final hard gate depends on a composite target that calls the final hard gate recursively
```

---

## 22. No-Regression Requirement Against Earlier Accepted Areas

While closing gaps, do not regress areas that were already accepted.

The final audit must compare before and after for:

```text
architecture_contract
governance_enforcement
docs_claim_alignment
controlled_evolution
evidence_closure
umbrella_agent
post_umbrella_generalization
evaluation_harness
company_core_product_e2e
production_readiness_behavioral boundary
replay_evidence_closure
```

For each area:

```text
previous verdict
new verdict
previous evidence
new evidence
regression_detected
```

Acceptance condition:

```text
no accepted in-scope area regresses below ACCEPTED
no accepted in-scope area drops below 95%
```

If an earlier accepted report was actually a false positive, do not hide that. Mark it as false positive, fix it, and regenerate the accepted evidence honestly.



---

## 23. Exhaustive Repository Inventory and Traceability Closure

The known-gap list is not enough by itself. The coding agent must also discover any additional gaps that are present in the repository but were not listed in the earlier audit.

Create or update:

```text
tools/agentx_evolve/exhaustive_inventory_closure/
tools/agentx_evolve/exhaustive_inventory_closure/cli.py
tools/agentx_evolve/exhaustive_inventory_closure/audit.py
tests/test_exhaustive_inventory_closure.py
```

Add Makefile target:

```text
prove-exhaustive-inventory-closure
```

`prove-final-acceptance-hard-gated` must consume this target.

### Required inventory sources

The exhaustive inventory must scan and reconcile all of these sources:

```text
Makefile proof targets
tools/agentx_evolve/ modules
tests/
reports/ committed baseline reports
.agentx-proof/current runtime reports
docs/
docs/agentx_target_architecture/
L0/
L1/
L2/
benchmarks/
examples/
fixtures/
scripts/
.github/workflows/
pyproject.toml
requirements/
package.json / opencode.json if present
README / pipeline docs / milestone docs
```

The inventory must create a canonical object for every discovered entity:

```json
{
  "entity_id": "...",
  "entity_type": "module|proof_target|test|report|doc|script|workflow|fixture|benchmark|schema|example|runtime_artifact",
  "path": "...",
  "required_for_internal_mvp": true,
  "dimension": "...",
  "has_source": true,
  "has_test": true,
  "has_proof_target": true,
  "has_report": true,
  "has_schema": true,
  "has_claim_boundary": true,
  "has_evidence_binding": true,
  "deterministic": true,
  "status": "ACCEPTED|NOT_ACCEPTED|DEFERRED_OUT_OF_SCOPE|WAIVED_WITH_RATIONALE",
  "evidence": [],
  "blocking_gaps": []
}
```

### Required traceability matrices

Generate all of the following:

```text
.agentx-proof/current/reports/exhaustive_inventory_closure/entity_inventory.json
.agentx-proof/current/reports/exhaustive_inventory_closure/module_to_target_matrix.json
.agentx-proof/current/reports/exhaustive_inventory_closure/target_to_test_matrix.json
.agentx-proof/current/reports/exhaustive_inventory_closure/target_to_report_matrix.json
.agentx-proof/current/reports/exhaustive_inventory_closure/doc_claim_to_evidence_matrix.json
.agentx-proof/current/reports/exhaustive_inventory_closure/schema_coverage_matrix.json
.agentx-proof/current/reports/exhaustive_inventory_closure/orphan_artifact_report.json
.agentx-proof/current/reports/exhaustive_inventory_closure/orphan_module_report.json
.agentx-proof/current/reports/exhaustive_inventory_closure/orphan_target_report.json
.agentx-proof/current/reports/exhaustive_inventory_closure/orphan_test_report.json
.agentx-proof/current/reports/exhaustive_inventory_closure/final_verdict.json
```

### Required closure rules

The proof must fail if any of the following are true:

```text
An in-scope module has no proof target.
An in-scope proof target has no generated final verdict.
An in-scope proof target has no test or explicit test waiver.
An in-scope doc claim has no evidence mapping.
An in-scope report has no generator.
An in-scope generated report has no schema or compatibility schema.
An in-scope runtime artifact is committed accidentally.
An in-scope committed evidence artifact is unversioned.
An in-scope fixture is used as proof without being labeled as fixture/synthetic.
An in-scope benchmark has no source hash.
An in-scope example is used as proof but has no replayable command.
An in-scope workflow claims CI coverage but has no matching local proof target.
An in-scope target is present in Makefile but missing from the proof target registry.
An in-scope target is in the registry but missing from Makefile.
A required area is present in docs but absent from scorecard dimensions.
A required area is present in code but absent from scorecard dimensions.
A required area is present in reports but absent from scorecard dimensions.
```

### Required final verdict

The exhaustive inventory final verdict must be:

```json
{
  "schema_version": "1.0",
  "report_type": "exhaustive_inventory_closure",
  "verdict": "ACCEPTED",
  "entities_total": 0,
  "entities_in_scope": 0,
  "entities_accepted": 0,
  "entities_below_95": [],
  "orphan_modules": [],
  "orphan_targets": [],
  "orphan_tests": [],
  "orphan_reports": [],
  "unmapped_doc_claims": [],
  "unmapped_scorecard_dimensions": [],
  "runtime_artifacts_committed": [],
  "all_in_scope_entities_mapped": true,
  "all_in_scope_dimensions_at_or_above_95": true
}
```

The values above are an example schema. The real generated report must contain real counts, not zeros unless the counts are actually zero.

Acceptance condition:

```text
prove-exhaustive-inventory-closure == ACCEPTED
```

---

## 24. Requirement Reconciliation Against All Planning Documents

The repository may contain multiple plans, milestone docs, end-to-end completion documents, target architecture docs, and prompts. The coding agent must not rely only on the latest prompt.

Create or update:

```text
tools/agentx_evolve/requirement_reconciliation/
tools/agentx_evolve/requirement_reconciliation/cli.py
tools/agentx_evolve/requirement_reconciliation/audit.py
tests/test_requirement_reconciliation.py
```

Add Makefile target:

```text
prove-requirement-reconciliation
```

`prove-final-acceptance-hard-gated` must consume this target.

Scan all planning and milestone documents in:

```text
docs/
docs/plans/
docs/agentx_target_architecture/
L1/docs/
root-level *.md
benchmarks/benchcore/*.md
```

Extract requirement-like statements, especially those containing:

```text
must
required
acceptance
prove
target
gate
milestone
final
clean checkout
reproducibility
evidence
governance
human review
promotion
production boundary
internal MVP
company core product
95%
```

For each requirement, classify:

```text
implemented
accepted
covered_by_proof
deferred_out_of_scope
waived_with_rationale
not_accepted
duplicate
obsolete
contradictory
```

Generate:

```text
.agentx-proof/current/reports/requirement_reconciliation/requirement_inventory.json
.agentx-proof/current/reports/requirement_reconciliation/requirement_to_evidence_matrix.json
.agentx-proof/current/reports/requirement_reconciliation/contradiction_report.json
.agentx-proof/current/reports/requirement_reconciliation/obsolete_requirement_report.json
.agentx-proof/current/reports/requirement_reconciliation/uncovered_requirement_report.json
.agentx-proof/current/reports/requirement_reconciliation/final_verdict.json
```

The proof must fail if:

```text
an in-scope requirement has no evidence
a requirement contradicts the final claim boundary
a newer requirement silently overrides an older requirement without explanation
a deferred requirement is actually required for internal MVP
a 95% requirement is missing from the final gate
a production-ready claim is present without production evidence
```

Acceptance condition:

```text
prove-requirement-reconciliation == ACCEPTED
```

---

## 25. Final Gate Must Consume Exhaustive Discovery

The final hard gate must consume these additional targets:

```text
prove-exhaustive-inventory-closure
prove-requirement-reconciliation
```

It must fail if either target is missing or not accepted.

The final hard gate must also prove:

```text
No discovered in-scope area is absent from the 95% scorecard.
No discovered in-scope requirement is absent from the closure ledger.
No discovered in-scope module is absent from proof-target mapping.
No discovered in-scope proof target is absent from final hard-gate consumption.
No discovered in-scope report is absent from evidence binding.
```

This is the final protection against missed areas.

---

## 26. Updated Final Command Superset With Exhaustive Discovery

Run this final superset from a clean checkout:

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```

If `make prove-all` includes future/out-of-scope targets, create and use:

```text
make prove-all-internal-mvp
```

The final hard gate must explain exactly why `prove-all` is or is not the correct final target.



---

## 27. Behavioral Execution Proof, Not Report-Only Proof

The 95% target must be backed by actual executable behavior. A repository can contain many accepted reports while still not proving that the system works as a governed self-evolution prototype.

Therefore, final acceptance must distinguish:

```text
report coverage
source coverage
test coverage
behavioral execution coverage
end-to-end scenario coverage
```

A dimension may not reach 95% unless it has behavioral execution evidence.

Create or update:

```text
tools/agentx_evolve/behavioral_execution_matrix/
tools/agentx_evolve/behavioral_execution_matrix/cli.py
tools/agentx_evolve/behavioral_execution_matrix/audit.py
tests/test_behavioral_execution_matrix.py
```

Add Makefile target:

```text
prove-behavioral-execution-matrix
```

`prove-final-acceptance-hard-gated` must consume this target.

The behavioral execution matrix must create:

```text
.agentx-proof/current/reports/behavioral_execution_matrix/behavioral_execution_matrix.json
.agentx-proof/current/reports/behavioral_execution_matrix/scenario_results.json
.agentx-proof/current/reports/behavioral_execution_matrix/negative_scenario_results.json
.agentx-proof/current/reports/behavioral_execution_matrix/report_only_claims_rejected.json
.agentx-proof/current/reports/behavioral_execution_matrix/final_verdict.json
```

### Required behavioral scenarios

At minimum, prove these scenarios by running real local commands or deterministic local fixtures:

| Scenario ID | Scenario | Required result |
|---|---|---|
| B001 | Initiator accepts a valid internal-MVP task and emits a valid handoff package | accepted handoff with schema-valid artifact |
| B002 | Initiator rejects invalid/missing input contract | rejected with structured error |
| B003 | Context/source ingestion builds bounded context from local repo sources | accepted context artifact, no external dependency |
| B004 | Policy/sandbox refuses forbidden capability such as secret access or network egress | refused with evidence |
| B005 | Implementation proposal generates a bounded change plan without applying files | proposal artifact only, no source mutation |
| B006 | Diff preview produces inspectable diff for controlled workspace | diff artifact generated, no apply yet |
| B007 | Controlled apply applies only allowed files inside candidate/test workspace | allowed files changed, source boundary respected |
| B008 | Post-apply validation catches failing candidate | failure detected and promotion blocked |
| B009 | Rollback restores pre-apply candidate state | rollback evidence and clean workspace |
| B010 | Human-review boundary blocks promotion without review or fixture-labeled review | promotion refused or fixture-labeled only |
| B011 | Internal-MVP promotion succeeds only when all gates pass | `PROMOTION_READY_FOR_INTERNAL_MVP` only |
| B012 | Final evidence manifest binds claims to generated artifacts | content hashes/provenance present |
| B013 | Umbrella/weather agent path runs end to end | accepted bounded output |
| B014 | Non-weather agent path runs through generic adapter | accepted bounded output |
| B015 | Malicious-code or data-exfiltration fixture is rejected | rejected with policy evidence |
| B016 | Clean reproducibility repeated run produces deterministic normalized output | accepted deterministic comparison |
| B017 | Final hard gate fails on tampered evidence | tamper rejected |
| B018 | Final hard gate fails when one required dimension is below 95% | failure demonstrated |
| B019 | API/operator surface either runs local endpoint smoke tests or explicitly refuses runtime API claim | accepted boundary |
| B020 | Final independent audit packet can be generated from fresh proof outputs | accepted packet |

A scenario may use deterministic fixtures, but the fixture must be labeled as such and must exercise the same code path as the real internal-MVP flow.

A scenario may not pass merely because a static report exists.

### Required behavioral percentage rule

For every in-scope dimension:

```text
behavioral_scenarios_passed / behavioral_scenarios_required >= 0.95
```

If a dimension has no behavioral scenarios, its maximum score is:

```text
80%
```

unless it is a documentation-only dimension. Documentation-only dimensions still require claim-to-evidence mapping and contradiction checks.

The final scorecard must include:

```text
behavioral_coverage_percent
report_coverage_percent
test_coverage_percent
source_coverage_percent
evidence_coverage_percent
final_dimension_percent
```

The final dimension percent must be the minimum of the relevant coverage types, not an average that hides weak areas.

Example:

```text
architecture report coverage: 100%
architecture source coverage: 100%
architecture behavioral coverage: 90%
final architecture coverage: 90%
verdict: NOT_ACCEPTED because below 95%
```

This prevents report-heavy areas from appearing complete when behavior is still weak.

---

## 28. Minimal Real Internal-MVP User Journey

In addition to individual scenarios, prove at least one complete user journey.

Create or update:

```text
tools/agentx_evolve/internal_mvp_user_journey/
tools/agentx_evolve/internal_mvp_user_journey/cli.py
tools/agentx_evolve/internal_mvp_user_journey/audit.py
tests/test_internal_mvp_user_journey.py
```

Add Makefile target:

```text
prove-internal-mvp-user-journey
```

The journey must execute this chain:

```text
task intake
→ initiator validation
→ context/source ingestion
→ policy/sandbox check
→ implementation proposal
→ diff preview
→ candidate workspace preparation
→ controlled apply or refusal
→ post-apply validation
→ rollback path if validation fails
→ human review boundary
→ internal-MVP promotion decision
→ evidence manifest
→ final summary report
```

Required outputs:

```text
.agentx-proof/current/reports/internal_mvp_user_journey/journey_trace.json
.agentx-proof/current/reports/internal_mvp_user_journey/step_results.json
.agentx-proof/current/reports/internal_mvp_user_journey/artifact_manifest.json
.agentx-proof/current/reports/internal_mvp_user_journey/promotion_decision.json
.agentx-proof/current/reports/internal_mvp_user_journey/final_verdict.json
```

Acceptance condition:

```text
prove-internal-mvp-user-journey == ACCEPTED
```

The final hard gate must fail if this journey is missing, static, non-deterministic, or report-only.

---

## 29. Final Gate Must Reject Report-Only Completion

The final hard gate must fail if:

```text
any in-scope dimension reaches 95% only through reports without behavioral execution
any required behavioral scenario is missing
any required scenario uses a different code path from the internal-MVP flow
any scenario is static/prewritten rather than generated by a command
the internal-MVP user journey is missing
the internal-MVP user journey does not generate evidence artifacts
the internal-MVP user journey does not exercise promotion/refusal logic
the internal-MVP user journey cannot be replayed deterministically
```

Add these final-gate requirements:

```text
behavioral_execution_matrix accepted
internal_mvp_user_journey accepted
component_coverage_95 accepted
dependency_security_boundary accepted
target_architecture_layer_coverage accepted
all in-scope dimensions have behavioral coverage >=95 where applicable
final dimension percentages use minimum coverage, not average-only scoring
```

---

## 30. Updated Final Command Superset With Behavioral Proof

Run this expanded final command ladder from a clean checkout:

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```



---

## 31. Runtime Component, Adapter, Security, Packaging, and Operations Coverage

The repository must not reach 95% by proving only meta-audit/reporting infrastructure. Agent_X also needs explicit coverage for the actual runtime components expected of a governed agent/orchestrator/internal-MVP system.

Create or update:

```text
tools/agentx_evolve/component_coverage_95/
tools/agentx_evolve/component_coverage_95/cli.py
tools/agentx_evolve/component_coverage_95/audit.py
tests/test_component_coverage_95.py
```

Add Makefile target:

```text
prove-component-coverage-95
```

`prove-final-acceptance-hard-gated` must consume this target.

### Required component groups

The component coverage proof must measure each of these groups separately and require each in-scope group to reach >=95%:

| Component group | Required proof |
|---|---|
| Initiator / task intake | Valid task intake, invalid task rejection, schema validation, handoff generation. |
| Context builder / source ingestion | Bounded repo context, source inventory, path normalization, no hidden external dependency. |
| Prompt contract | Prompt/input/output schema, claim boundary, forbidden claim refusal, deterministic formatting. |
| LLM worker / model adapter boundary | Local/deterministic fixture mode, model-provider abstraction, timeout/error handling, no production model claim unless proven. |
| Tool/MCP adapter boundary | Tool registry, allowlist, denied tool behavior, structured tool errors, no arbitrary command execution. |
| Policy registry | Policy loading, unsupported claim detection, forbidden capability refusal, policy versioning. |
| Security sandbox / command boundary | Allowlisted commands, denied commands, network/secret refusal, path boundary enforcement. |
| Patch execution / controlled workspace | Proposal, diff preview, allowed apply, denied apply, rollback, post-apply validation. |
| Human review / promotion gate | Review-required path, fixture-labeled simulated review, internal-MVP promotion only, no production promotion. |
| Evidence / provenance / artifact store | Evidence manifests, content hashes, run ledger, artifact index, tamper detection. |
| Replay / reproducibility | Clean checkout, deterministic repeated run, normalized diff, no tracked-file dirtiness. |
| Evaluation / benchmark harness | Positive and negative cases, source hashes, replay, coverage matrix, bounded claims. |
| Failure taxonomy / remediation router | Failure classification, suggested repair path, no silent swallowing of failure. |
| Runtime observability | Structured logs/events, run IDs, error reports, redaction, debug bundle. |
| Resource/cost governance | Retry limits, timeout limits, budget limits, no retry storm, failure on budget breach. |
| Packaging / local install | Local setup path, importability, CLI entrypoints, dependency declaration, reproducible local run. |
| CI/local equivalence | CI configured, local equivalent command, artifact upload where applicable, no false CI pass claim. |
| Backup/recovery / rollback | Candidate rollback, artifact recovery, proof-run cleanup, no destructive source mutation. |
| API/operator surface | Local endpoints tested or explicit interface-only boundary, no ambiguous API claim. |
| Documentation/user operation | Usage docs match real commands, troubleshooting docs, claim boundary visible, no stale instructions. |

### Required report files

Generate:

```text
.agentx-proof/current/reports/component_coverage_95/component_groups.json
.agentx-proof/current/reports/component_coverage_95/component_to_source_matrix.json
.agentx-proof/current/reports/component_coverage_95/component_to_test_matrix.json
.agentx-proof/current/reports/component_coverage_95/component_to_behavior_matrix.json
.agentx-proof/current/reports/component_coverage_95/component_to_proof_target_matrix.json
.agentx-proof/current/reports/component_coverage_95/component_to_evidence_matrix.json
.agentx-proof/current/reports/component_coverage_95/components_below_95.json
.agentx-proof/current/reports/component_coverage_95/final_verdict.json
```

### Required scoring rule

For each component group:

```text
source coverage >=95%
test coverage >=95%
proof-target coverage >=95%
behavioral coverage >=95%
evidence coverage >=95%
documentation/claim-boundary coverage >=95%
```

The final component score must be:

```text
minimum(source, test, proof_target, behavioral, evidence, documentation)
```

not an average.

If any in-scope component group is below 95%, then:

```text
prove-component-coverage-95 == NOT_ACCEPTED
prove-final-acceptance-hard-gated == NOT_ACCEPTED
```

### Required negative checks

The proof must fail if:

```text
LLM worker is claimed but only static text exists.
Tool adapter permits arbitrary shell commands.
Sandbox accepts paths outside allowed workspace.
Patch execution mutates source without explicit approved apply.
Promotion can happen without review boundary.
Evidence artifacts lack content hashes.
Retry loops are unbounded.
Runtime logs expose secrets.
Local install instructions do not match real commands.
Documentation claims a component that has no source/test/proof.
API is described as available but no endpoint or explicit interface-only boundary exists.
CI is claimed as passed without a real successful run or clearly separated local-equivalence proof.
```

Acceptance condition:

```text
prove-component-coverage-95 == ACCEPTED
```

---

## 32. Dependency, Secret, and Supply-Chain Boundary

The internal MVP does not need enterprise-grade supply-chain certification, but it must not ignore dependency/security basics.

Create or update:

```text
tools/agentx_evolve/dependency_security_boundary/
tools/agentx_evolve/dependency_security_boundary/cli.py
tools/agentx_evolve/dependency_security_boundary/audit.py
tests/test_dependency_security_boundary.py
```

Add Makefile target:

```text
prove-dependency-security-boundary
```

This proof must check:

```text
dependencies are declared in the appropriate files
imports used by in-scope modules are declared or part of stdlib
no hardcoded secrets/tokens/API keys in tracked source
no unsafe default network egress in proof paths
no proof requires paid/external service to pass
no shell injection risk in proof target wrappers
subprocess calls use allowlists or fixed commands
temporary files are created inside allowed runtime dirs
debug bundles redact sensitive environment values
```

The proof must clearly distinguish:

```text
internal-MVP security boundary: required
enterprise security certification: not claimed
```

Acceptance condition:

```text
prove-dependency-security-boundary == ACCEPTED
```

---

## 33. Final Gate Must Consume Component and Security Coverage

The final hard gate must consume:

```text
prove-component-coverage-95
prove-dependency-security-boundary
```

It must fail if either target is missing or not accepted.

The final scorecard must include:

```text
component_coverage_95
dependency_security_boundary
```

Both must be at or above 95% for the internal-MVP scope, or explicitly fail.

---

## 34. Final Command Superset With Component Coverage

Run this expanded final command ladder from a clean checkout:

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```



---

## 35. Target Architecture Layer Coverage to 95%+

The final 95%+ claim must cover the full intended Agent_X target architecture, not only the proof/reporting infrastructure and not only the currently strongest modules.

Create or update:

```text
tools/agentx_evolve/target_architecture_layer_coverage/
tools/agentx_evolve/target_architecture_layer_coverage/cli.py
tools/agentx_evolve/target_architecture_layer_coverage/audit.py
tests/test_target_architecture_layer_coverage.py
```

Add Makefile target:

```text
prove-target-architecture-layer-coverage-95
```

`prove-final-acceptance-hard-gated` must consume this target.

### Required target architecture layers

The coverage proof must discover and classify every intended Agent_X layer, including at minimum:

```text
Initiator
Security Sandbox
Policy Registry
Patch Execution
Failure Taxonomy
Tool/MCP Adapter
Model Adapter
Local Model Runtime Profile
Context Builder
Prompt Contract
LLM Worker
Self-Evolution Orchestrator
Human Review
Promotion Gate
Git Integration
Evaluation Harness
Long-Term Learning
Doc Sync
Task Queue
Monitoring / Runtime Observability
Packaging
Backup / Disaster Recovery
Final Acceptance
```

For each layer, the report must include:

```json
{
  "layer": "...",
  "required_for_internal_mvp": true,
  "required_for_future_scope": false,
  "status": "ACCEPTED|NOT_ACCEPTED|DEFERRED_OUT_OF_SCOPE|WAIVED_WITH_RATIONALE",
  "source_modules": [],
  "cli_entrypoints": [],
  "make_targets": [],
  "tests": [],
  "behavioral_scenarios": [],
  "evidence_artifacts": [],
  "claim_boundary": "...",
  "coverage_percent": 0.95,
  "blocking_gaps": []
}
```

### Required per-layer closure expectations

| Layer | Required internal-MVP proof |
|---|---|
| Initiator | Valid/invalid task intake, handoff generation, schema validation, no source mutation. |
| Security Sandbox | Denied commands, allowed commands, path boundaries, network/secret refusal, audit evidence. |
| Policy Registry | Policy load/versioning, unsupported claim detection, forbidden capability refusal. |
| Patch Execution | Proposal, diff preview, controlled apply, refusal path, post-apply validation, rollback. |
| Failure Taxonomy | Failure classification, routing to remediation, no silent swallowing of errors. |
| Tool/MCP Adapter | Tool allowlist, denied tool behavior, structured tool errors, no arbitrary tool/command path. |
| Model Adapter | Provider abstraction, fixture/local deterministic mode, timeout/error handling, no external dependency required for proofs. |
| Local Model Runtime Profile | Clear local-runtime boundary, resource limits, deterministic fixture fallback, no false production-model claim. |
| Context Builder | Bounded source/context ingestion, path normalization, deterministic context artifact. |
| Prompt Contract | Input/output schemas, claim-boundary constraints, deterministic prompt/report formatting. |
| LLM Worker | Request/response boundary, fixture mode, structured errors, refusal behavior for forbidden tasks. |
| Self-Evolution Orchestrator | End-to-end governed flow from task to proposal/apply/review/promotion, no unsupervised production mutation. |
| Human Review | Review-required path, simulated review labeled as fixture, no bypass to promotion. |
| Promotion Gate | Internal-MVP promotion only, blocked on failed proofs, blocked on missing review, no production-ready claim. |
| Git Integration | Candidate branch/workspace behavior, clean git status checks, no dirty tracked files after proof, commit/promotion boundary. |
| Evaluation Harness | Positive/negative cases, coverage matrix, replayability, source hashes. |
| Long-Term Learning | Explicit memory/learning boundary, append-only or versioned learning artifacts, no unreviewed self-modifying memory. |
| Doc Sync | Docs generated or checked against implemented commands/reports, stale docs detection, claim-to-evidence mapping. |
| Task Queue | Bounded local queue or explicit deferred boundary, no infinite retry loop, task status lifecycle. |
| Monitoring / Runtime Observability | Structured run events, run IDs, redaction, debug bundle, error visibility. |
| Packaging | Local install/import checks, CLI entrypoints, dependency declaration, no missing runtime dependency. |
| Backup / Disaster Recovery | Candidate rollback, proof-run cleanup, artifact recovery, no destructive source mutation. |
| Final Acceptance | Hard-gated proof runner consumes all required accepted targets and fails on any gap. |

### Required layer scoring rule

Each in-scope layer must meet all of the following:

```text
source coverage >=95%
test coverage >=95%
proof target coverage >=95%
behavioral scenario coverage >=95%
evidence binding coverage >=95%
claim-boundary coverage >=95%
documentation/user-operation coverage >=95%
```

The final layer score is the minimum of those coverage types.

An in-scope layer below 95% must make:

```text
prove-target-architecture-layer-coverage-95 == NOT_ACCEPTED
prove-final-acceptance-hard-gated == NOT_ACCEPTED
```

A future-scope layer may be deferred only if:

```text
it is not required for the internal MVP
the waiver explains why
the final claim boundary excludes it
the scorecard does not count it as implemented
the final gate accepts the waiver
```

### Required output files

Generate:

```text
.agentx-proof/current/reports/target_architecture_layer_coverage/layer_inventory.json
.agentx-proof/current/reports/target_architecture_layer_coverage/layer_to_source_matrix.json
.agentx-proof/current/reports/target_architecture_layer_coverage/layer_to_test_matrix.json
.agentx-proof/current/reports/target_architecture_layer_coverage/layer_to_behavior_matrix.json
.agentx-proof/current/reports/target_architecture_layer_coverage/layer_to_evidence_matrix.json
.agentx-proof/current/reports/target_architecture_layer_coverage/layers_below_95.json
.agentx-proof/current/reports/target_architecture_layer_coverage/deferred_layers.json
.agentx-proof/current/reports/target_architecture_layer_coverage/final_verdict.json
```

Acceptance condition:

```text
prove-target-architecture-layer-coverage-95 == ACCEPTED
```

---

## 36. Final Gate Must Consume Target Architecture Layer Coverage

The final hard gate must consume:

```text
prove-target-architecture-layer-coverage-95
```

It must fail if:

```text
any required target architecture layer is missing from the layer inventory
any in-scope layer is below 95%
any layer is marked out of scope without an accepted waiver
any layer is counted as implemented only because documentation exists
any layer lacks behavioral execution evidence where behavior is applicable
any layer has no claim boundary
any layer required for the internal MVP lacks source, tests, proof target, or evidence
```

The final scorecard must include:

```text
target_architecture_layer_coverage
```

and it must be at or above 95% for all in-scope layers.

---

## 37. Final Command Superset With Target Architecture Layer Coverage

Run this expanded final command ladder from a clean checkout:

```bash
git status --porcelain
git rev-parse HEAD

python -m compileall -q tools/agentx_evolve tests

pytest -q

make prove-format
make prove-source-integrity
make prove-architecture-contract
make prove-governance-enforcement
make prove-docs-claim-alignment
make prove-initiator-layer
make prove-api-operator-surface
make prove-artifact-versioning
make prove-evidence-binding
make prove-module-gap-closure
make prove-retry-storm-guard
make prove-internal-mvp-promotion-gate
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-prompt-consistency-closure
make prove-behavioral-execution-matrix
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-reproducibility
make prove-clean-reproducibility-hard-gate
make prove-evidence-closure
make prove-replay-evidence-closure
make prove-controlled-evolution
make prove-umbrella-agent
make prove-post-umbrella-generalization
make prove-evaluation-harness
make prove-company-core-product-e2e
make prove-production-readiness-behavioral
make prove-progress-scorecard
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all

git status --porcelain
```



---

## 38. Prompt Consistency and Authoritative-Command Rule

This prompt has grown through multiple closure passes. The coding agent must not exploit repeated or older command lists to run a weaker proof sequence.

Rules:

```text
Repeated command ladders in Sections 20, 26, 30, 34, and 37 must match Section 7 exactly or be treated as stale.
```


```text
When command lists differ, use the strictest/latest superset.
When final-gate consumption lists differ, consume the union of all required targets.
When a later section adds a target, it becomes mandatory unless explicitly deferred with an accepted waiver.
When two sections conflict, the stricter requirement wins.
When a section says a target is optional but another section says it is required for internal MVP, treat it as required until requirement reconciliation proves otherwise.
```

Create a prompt-consistency check:

```text
tools/agentx_evolve/prompt_consistency_closure/
tools/agentx_evolve/prompt_consistency_closure/cli.py
tools/agentx_evolve/prompt_consistency_closure/audit.py
tests/test_prompt_consistency_closure.py
```

Add Makefile target:

```text
prove-prompt-consistency-closure
```

The final hard gate must consume this target.

The proof must generate:

```text
.agentx-proof/current/reports/prompt_consistency_closure/command_union.json
.agentx-proof/current/reports/prompt_consistency_closure/final_gate_union.json
.agentx-proof/current/reports/prompt_consistency_closure/conflict_report.json
.agentx-proof/current/reports/prompt_consistency_closure/final_verdict.json
```

It must fail if:

```text
an older weaker command list is used as the final command list
a later mandatory target is missing from final gate consumption
two sections contradict each other and no stricter resolution is documented
the final scorecard omits a mandatory target introduced anywhere in this prompt
```

Acceptance condition:

```text
prove-prompt-consistency-closure == ACCEPTED
```

Add this target to the authoritative final command ladder and final gate consumption list unless it is implemented as part of requirement reconciliation.


---

## 39. Explicit Mandatory Targets for Every Earlier Workstream

Some earlier workstreams describe areas such as artifact versioning, evidence binding, module gap closure, retry-storm guard, promotion readiness, architecture, governance, docs alignment, initiator, and API/operator surface. These must not remain implicit or only indirectly covered by later scorecards.

Create or verify these mandatory proof targets:

```text
prove-architecture-contract
prove-governance-enforcement
prove-docs-claim-alignment
prove-initiator-layer
prove-api-operator-surface
prove-artifact-versioning
prove-evidence-binding
prove-module-gap-closure
prove-retry-storm-guard
prove-internal-mvp-promotion-gate
```

Each target must:

```text
run real source code
generate a runtime final_verdict.json
fail non-zero on NOT_ACCEPTED
write runtime artifacts to ignored proof-run directories
avoid dirtying tracked files
include schema/version metadata
include evidence paths
include claim boundary
be consumed by prove-final-acceptance-hard-gated
be represented in the 95% coverage scorecard
be represented in all-known-gaps closure
be represented in exhaustive inventory closure
```

### Required target meanings

| Target | Required acceptance meaning |
|---|---|
| `prove-architecture-contract` | Layer boundaries, forbidden imports, claim boundaries, and architecture rules are enforced. |
| `prove-governance-enforcement` | Governance policies cannot be bypassed and unsupported claims/forbidden actions are rejected. |
| `prove-docs-claim-alignment` | Docs, reports, README, and milestone claims map to evidence and do not overclaim. |
| `prove-initiator-layer` | Initiator source, CLI, schema validation, handoff validation, and invalid-input rejection are proven. |
| `prove-api-operator-surface` | API/operator surface is either runnable locally with smoke tests or explicitly interface-only with no runtime API claim. |
| `prove-artifact-versioning` | Evidence-relevant tracked artifacts are versioned or runtime-only artifacts are ignored. |
| `prove-evidence-binding` | Claims are bound to artifacts through manifests, hashes, provenance, and tamper detection. |
| `prove-module-gap-closure` | No required in-scope module lacks source, tests, proof target, generated verdict, or accepted waiver. |
| `prove-retry-storm-guard` | Retry/cost-amplification risks are bounded by retry limits, timeouts, budgets, and audit events. |
| `prove-internal-mvp-promotion-gate` | Promotion can become `PROMOTION_READY_FOR_INTERNAL_MVP` only after review boundary, clean reproducibility, final gate, and claim checks pass. |

The final hard gate must fail if any of these targets is missing, static, echo-only, stale, non-gating, dirtying tracked files, or below 95% for its in-scope area.



---

## 40. Non-Circular Final Closeout Rule

The final proof architecture must be non-circular.

Use this dependency order:

```text
leaf proof targets
→ coverage / gap / inventory / anti-gaming aggregators
→ prove-final-acceptance-hard-gated
→ prove-all or prove-all-internal-mvp closeout wrapper
```

Forbidden dependency order:

```text
prove-final-acceptance-hard-gated
→ prove-final-acceptance-hard-gated
```

Forbidden dependency order:

```text
prove-final-acceptance-hard-gated
→ prove-all
→ prove-final-acceptance-hard-gated
```

If `make prove-all` currently calls the final gate, then the final gate must not consume `prove-all`.

If `make prove-all` includes future or out-of-scope targets, create:

```text
make prove-all-internal-mvp
```

This target must run the complete non-circular internal-MVP proof ladder and may call `prove-final-acceptance-hard-gated` at the end.


Additional non-circular rule:

```text
prove-fresh-checkout-acceptance must be pre-final only.
It must not call prove-final-acceptance-hard-gated if the final gate consumes it.
Post-final fresh-checkout closeout must be handled by prove-all or prove-all-internal-mvp after the final gate.
```

Create or update a dependency graph report:

```text
.agentx-proof/current/reports/final_proof_dependency_graph/dependency_graph.json
.agentx-proof/current/reports/final_proof_dependency_graph/cycle_report.json
.agentx-proof/current/reports/final_proof_dependency_graph/final_verdict.json
```

Add Makefile target:

```text
prove-final-proof-dependency-graph
```

The final hard gate must consume `prove-final-proof-dependency-graph`.

Acceptance condition:

```text
no cycles
no recursive final-gate consumption
no composite target recursion
all required prerequisite targets reachable
all in-scope proof targets represented
final_verdict == ACCEPTED
```

Add this target to the authoritative final command ladder before `prove-final-acceptance-hard-gated`.



---

## 41. Explicit CI/Local Equivalence and Direct Reproducibility Proof

Earlier workstreams mention CI/local equivalence and direct reproducibility, but these must not remain only implicit inside other aggregators.

Create or verify these targets:

```text
prove-reproducibility
prove-ci-local-equivalence
```

`prove-clean-reproducibility-hard-gate` must consume `prove-reproducibility`.

`prove-final-acceptance-hard-gated` must consume `prove-ci-local-equivalence`.

### `prove-reproducibility`

Required meaning:

```text
runs the reproducibility proof directly
generates deterministic runtime reproducibility reports
normalizes timestamps, paths, run IDs, ordering, and environment-specific values
can be run twice with the same fixed seed and produce identical or normalized-identical reports
does not dirty tracked files
```

Required verdict:

```text
prove-reproducibility == ACCEPTED
```

### `prove-ci-local-equivalence`

Required meaning:

```text
maps CI workflow jobs to local proof targets
proves local command equivalence for each required CI gate
distinguishes CI configured from CI passed
does not claim CI success unless a real workflow run passed
verifies local final closeout command covers the same logical gates
```

Required verdict:

```text
prove-ci-local-equivalence == ACCEPTED
```

If the repository cannot prove real CI passed for the current commit, the accepted boundary must be:

```text
CI_CONFIGURED_AND_LOCAL_EQUIVALENCE_ACCEPTED
```

not:

```text
CI_PASSED
```

The final gate must fail if:

```text
prove-reproducibility is missing
prove-reproducibility is non-deterministic
prove-ci-local-equivalence is missing
CI is claimed as passed without a real run
local proof ladder is weaker than CI
CI workflow contains required gates that local proof does not cover
local proof contains required gates that CI silently skips without rationale
```

Add both targets to the authoritative final command ladder and final gate consumption list.

