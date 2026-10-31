# Agent_X Master Gap-Closure Prompt

Use this prompt with a large coding LLM inside a clean checkout of `Astrocytech/Agent_X`.

Target reference commit for context: `1eca4dd8c5bd8c800af7ec8cc26df479f0c1b3d4`.

Do **not** treat this as a request to polish documentation only. The goal is to close the remaining acceptance gaps across the repository with source changes, tests, proof runners, reports, schemas, and reproducible evidence.

---

## 1. Role

You are the implementation-and-acceptance engineer for Agent_X.

Your job is to take the current Agent_X repository from an advanced governed prototype to an internally accepted MVP by closing the remaining proof, reproducibility, schema, CI/local-equivalence, and coverage gaps.

You must be conservative. Do not claim completion unless the repository proves it through executable commands and generated evidence.

---

## 2. Current status to assume

The latest assessment was:

```text
STATUS: ADVANCED GOVERNED PROTOTYPE
PROTOTYPE PROGRESS: ~82%
COMPANY-CORE-PRODUCT PROGRESS: ~60–65%
STRICT MODULE ACCEPTANCE: 46.03%
FINAL ACCEPTANCE: NOT_ACCEPTED
```

The project improved meaningfully, but final acceptance remains blocked.

The improvement table that must be converted into actual closure is:

| Area | Before | After | Improvement |
|---|---:|---:|---:|
| Concept / architecture | 85–90% | 88–92% | +3–5 |
| Governance design | 80–85% | 90–95% | +8–10 |
| Documentation / milestone framing | 85–90% | 92–96% | +5–7 |
| Initiator layer | 80–90% | 90–95% | +5–10 |
| Patch execution / controlled evolution | 65–75% | 85–92% | +15–20 |
| Audit logs / evidence structure | 65–75% | 78–88% | +10–15 |
| Umbrella-agent proof milestone | 60–70% | 88–95% | +20–25 |
| Post-umbrella generalization | 45–60% | 80–90% | +25–35 |
| Benchmark / Scriptor / evaluation harness | 45–55% | 80–90% | +30–35 |
| Replay / reproducibility proof | 40–55% | 65–75% | +20 |
| Final acceptance runner | 50–65% | 65–75% | +10 |
| Production readiness | 25–35% | 45–55% | +20 |

The new target is not merely another percentage increase. The target is **accepted internal MVP**, with all hard gates passing and no fake evidence.


---

## 2A. Mandatory coverage matrix for every percentage-gap row

The prompt must close **every row** from the percentage table. Treat this matrix as a non-optional checklist. Do not finish until every row has either an accepted proof or a formal internal-MVP waiver that is explicitly excluded from accepted counts.

| Gap area from percentage table | Closure work required | Required proof / gate | Done only when |
|---|---|---|---|
| Concept / architecture | Complete architecture contract, architecture-layer coverage, requirement-to-architecture mapping, and claim-bounded architecture summary. | `make prove-architecture-contract`, `make prove-target-architecture-layer-coverage-95`, `make prove-requirement-reconciliation` | Architecture is proven by source + tests + evidence, not documentation alone. |
| Governance design | Ensure policy enforcement, allowed/warn/blocked decisions, anti-gaming, human-review boundary, and unsupported-claim rejection are behaviorally tested. | `make prove-governance-enforcement`, `make prove-anti-gaming-95`, `make prove-internal-mvp-promotion-gate` | Governance fails closed, rejects false acceptance, and cannot be bypassed by static reports. |
| Documentation / milestone framing | Reconcile milestone docs, target architecture docs, README/claim language, reports, and proof targets. | `make prove-docs-claim-alignment`, `make prove-requirement-reconciliation`, `make prove-prompt-consistency-closure` | Docs match implemented behavior and do not overclaim. |
| Initiator layer | Keep initiator accepted, tie it to task intake, planning, evidence, proof target, tests, and the internal-MVP user journey. | `make prove-initiator-layer`, `make prove-internal-mvp-user-journey`, `make prove-component-coverage-95` | Initiator is no longer just an isolated pass; it is proven in the full journey. |
| Patch execution / controlled evolution | Prove bounded patch/change creation, allowed workspace writes, validation, rollback, and human review/promotion boundary. | `make prove-controlled-evolution`, `make prove-behavioral-execution-matrix`, `make prove-internal-mvp-user-journey` | Controlled evolution is behavioral, not only report-level. |
| Audit logs / evidence structure | Standardize report schema, version all artifacts, bind evidence to commands/source/tests, and reject stale/static evidence. | `make prove-artifact-versioning`, `make prove-evidence-binding`, `make prove-replay-evidence-closure`, `make prove-anti-gaming-95` | Every accepted verdict is traceable to a proof command and valid evidence. |
| Umbrella-agent proof milestone | Preserve the accepted umbrella proof, make it replayable, include negative fixtures, and bind it to final acceptance. | `make prove-umbrella-agent`, `make prove-umbrella-agent-proof-milestone`, `make prove-final-acceptance-hard-gated` | Umbrella proof remains accepted after all schema, replay, and hard-gate repairs. |
| Post-umbrella generalization | Prove generic/non-hardcoded handling across positive, negative, and replay fixtures. | `make prove-post-umbrella-generalization`, `make prove-behavioral-execution-matrix` | Generalization is proven by multiple fixtures and forbidden-case rejection. |
| Benchmark / Scriptor / evaluation harness | Keep evaluation harness accepted, add benchmark closure, failure cases, and anti-false-pass checks. | `make prove-evaluation-harness`, `make prove-evaluation-benchmark-closure`, `make prove-coverage-scorecard-95` | Evaluation is executable, has enough cases, and cannot pass by static report editing. |
| Replay / reproducibility proof | Fix fresh checkout, clean reproducibility, deterministic proof output, replay evidence, no dirty tracked files, and CI/local equivalence. | `make prove-clean-reproducibility-hard-gate`, `make prove-fresh-checkout-acceptance`, `make prove-ci-local-equivalence`, `make prove-final-proof-dependency-graph` | A clean checkout can reproduce the final proof without manual hidden setup. |
| Final acceptance runner | Repair hard-gated final acceptance so it executes/validates all required subtargets and fails honestly. | `make prove-final-acceptance-hard-gated`, `make prove-all-internal-mvp` | Final hard gate is `ACCEPTED`, rejected subtarget count is 0, and no false-pass signals exist. |
| Production readiness | Close only the **internal-MVP production-readiness boundary**: monitoring/rollback/security/support/ops proof must be honest and must not claim real production readiness. | `make prove-production-readiness-behavioral`, `make prove-dependency-security-boundary`, `make prove-all-known-gaps-closure` | Internal-MVP readiness boundary passes; `production-ready` remains forbidden unless separately proven. |

Completion rule:

```text
The prompt is successful only if every area above has a passing proof path and the final hard gate accepts. If any row remains below target, the coding LLM must return PARTIAL or NOT_ACCEPTED and list the exact remaining row-level gaps.
```

---

## 3. Non-negotiable rules

1. Do not fake command output.
2. Do not edit `final_verdict.json` files to say `ACCEPTED` unless the corresponding code, tests, and proof runner actually justify the verdict.
3. Do not use echo-only Make targets as proof.
4. Do not rely on static JSON reports as acceptance.
5. Do not bypass hard gates.
6. Do not weaken thresholds to make the repo pass.
7. Do not delete hard-gate checks just because they fail.
8. Do not mark `NOT_ACCEPTED`, `PARTIAL`, `LOCAL_PROOF`, or `SCAFFOLD_ONLY` as accepted.
9. Do not claim production-ready, enterprise-ready, universal autonomy, or human-review-free operation.
10. Keep claims bounded to **internal MVP** unless production proof genuinely exists.
11. All new proof targets must execute behavior, validate generated evidence, and fail on known bad cases.
12. Reports must be generated by proof code, not manually invented.
13. Final acceptance must be reproducible from a clean checkout.
14. After proof commands run, the working tree must not be dirtied except by explicitly allowed ignored runtime/proof output directories.
15. Prefer fixing root causes over suppressing errors.

---

## 4. Main blockers to close

The latest hard gate rejected these required subtargets:

```text
prove-artifact-versioning
prove-exhaustive-inventory-closure
prove-requirement-reconciliation
prove-internal-mvp-user-journey
prove-component-coverage-95
prove-dependency-security-boundary
prove-target-architecture-layer-coverage-95
prove-coverage-scorecard-95
prove-all-known-gaps-closure
prove-anti-gaming-95
prove-fresh-checkout-acceptance
prove-ci-local-equivalence
```

The latest repository also had these larger blockers:

```text
1. final_acceptance_hard_gated remains NOT_ACCEPTED.
2. fresh_checkout_acceptance reports dirty-tree failure.
3. ci_local_equivalence is NOT_ACCEPTED.
4. artifact versioning / schema consistency fails across many reports.
5. component coverage shows missing tests, proof targets, behavioral evidence, and documentation.
6. raw strict module acceptance is only 46.03%.
7. adjusted score and hard-gate score are inconsistent; the scoring system must not overstate acceptance.
```

Close all of these.

---

## 5. Work method

Work in this order.

### Phase 0 — Establish a clean baseline

Run and record:

```bash
git status --short
git rev-parse HEAD
python3 --version
make prove-format
make compileall-check
make prove-progress-scorecard || true
make prove-final-acceptance-hard-gated || true
make prove-fresh-checkout-acceptance || true
make prove-ci-local-equivalence || true
```

Create a baseline report under an ignored runtime/proof output directory, not as a manually committed acceptance artifact.

The baseline report must include:

```text
commit hash
working tree status
Python version
commands executed
pass/fail result for each command
list of failing proof targets
list of dirty paths after proof execution
```

### Phase 1 — Repair source integrity and formatting first

Before any high-level proof work, ensure all text/source files are valid and not collapsed or malformed.

Required behavior:

```bash
make prove-format
make compileall-check
make prove-source-integrity
```

Acceptance condition:

```text
All three commands pass.
No Python syntax errors.
No collapsed text files.
No corrupted Makefile sections.
No echo-only proof targets.
No binary corruption issues.
No missing CLI/audit pairs for required modules.
```

### Phase 2 — Fix final-verdict schema/versioning globally

The artifact-versioning gate is failing because many reports lack required fields such as:

```text
schema_version
generated_at
report_type
```

Implement a shared verdict/report schema utility. Do not patch hundreds of JSON files manually. Add a reusable helper used by report generators.

Required implementation:

```text
1. Define canonical final verdict schema.
2. Define canonical report metadata fields.
3. Update report-writing helpers to include required fields.
4. Update module-specific report generators to use the shared helper.
5. Add migration/normalization only where it is safe and generated by code.
6. Add tests proving invalid reports fail and valid reports pass.
7. Ensure deterministic timestamps are used only in deterministic proof mode.
```

Canonical `final_verdict.json` minimum schema:

```json
{
  "schema_version": "agentx.final_verdict.v1",
  "report_type": "final_verdict",
  "generated_at": "<ISO-8601 or deterministic proof timestamp>",
  "verdict": "ACCEPTED | NOT_ACCEPTED | SCAFFOLD_ONLY",
  "errors": [],
  "warnings": [],
  "claim_boundary": {
    "claim_level": "internal_mvp | advanced_prototype | scaffold | partial",
    "cannot_claim": []
  },
  "evidence": {
    "proof_command": "<make target or CLI command>",
    "source_files": [],
    "test_files": [],
    "generated_reports": []
  }
}
```

Acceptance command:

```bash
make prove-artifact-versioning
```

Acceptance condition:

```text
Every generated final verdict has required metadata.
Schema validation rejects incomplete verdicts.
No manual ACCEPTED verdicts are introduced.
All final verdicts are traceable to proof commands or marked NOT_ACCEPTED.
```

### Phase 3 — Fix proof inventory and requirement reconciliation

The repo must know what exists, what is required, and what remains uncovered.

Implement or repair:

```text
1. Exhaustive module inventory.
2. Proof-target registry.
3. Requirement inventory extracted from milestone docs and target architecture docs.
4. Mapping from requirement -> source file(s) -> tests -> proof command -> reports.
5. Uncovered requirement report.
6. Waiver registry for intentionally deferred requirements.
7. Explicit rule that waived/deferred requirements cannot be counted as accepted.
```

Acceptance commands:

```bash
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
```

Acceptance condition:

```text
All required modules are inventoried.
Every required internal-MVP requirement is mapped to source, tests, proof target, and evidence.
No required requirement is silently missing.
Deferred items are listed with reason and do not inflate acceptance.
Uncovered required items are zero for internal MVP.
```

### Phase 4 — Fix component coverage to 95%+

The component coverage report shows many areas below 95% for tests, proof targets, behavioral evidence, and documentation.

You must close these coverage gaps by adding real tests/proofs/docs or correctly narrowing the internal-MVP scope with explicit waivers.

Do not merely alter the threshold or remove components from the list.

Required component categories include, at minimum:

```text
Initiator / task intake
Context builder
Prompt contract
LLM worker
Tool / MCP adapter
Policy registry
Security sandbox
Patch execution
Human review / promotion
Evidence / provenance
Replay / reproducibility
Evaluation / benchmark
Failure taxonomy
Runtime observability
Resource / cost governance
Packaging / local install
CI / local equivalence
API / operator surface
Documentation / user operation
```

For each component category, ensure:

```text
has_tests >= 95%
has_proof_target >= 95%
has_behavioral_evidence >= 95%
has_documentation >= 95%
```

Where a category is intentionally outside internal MVP scope, add a formal waiver with:

```text
component
reason
risk
owner/action
why it is not required for internal MVP
why it cannot be counted as accepted
```

Acceptance command:

```bash
make prove-component-coverage-95
```

Acceptance condition:

```text
Coverage is >=95% for required internal-MVP components.
Waived items are explicit and excluded from accepted percentage.
No component is hidden to inflate the score.
```

### Phase 5 — Fix target architecture layer coverage

Target architecture coverage must be tied to actual implemented behavior.

Implement or repair mapping for:

```text
L0 seed / kernel
L1 validators / governance
L2 structure / higher-level scaffolding
tools/agentx_evolve modules
initiator layer
controlled evolution
patch application boundary
human review / promotion boundary
evidence / audit / replay
API/operator surface
company-core-product internal MVP
production-readiness boundary
```

Each architecture layer must have:

```text
source paths
tests
proof commands
evidence reports
claim boundary
known gaps or waiver
```

Acceptance command:

```bash
make prove-target-architecture-layer-coverage-95
```

Acceptance condition:

```text
At least 95% of required internal-MVP architecture layers have source, tests, proof target, evidence, and documentation.
No architecture area is accepted from documentation alone.
```

### Phase 6 — Fix behavioral internal-MVP user journey

The internal MVP must be demonstrable through a real user journey, not just module-level reports.

Implement an end-to-end internal-MVP journey that proves:

```text
1. User or operator defines a target agent/task.
2. Agent_X ingests the task safely.
3. Context is assembled.
4. Governance evaluates allowed / warned / blocked actions.
5. A bounded plan is produced.
6. A candidate change or generated agent artifact is created in an allowed workspace.
7. Tests or validation are selected and run.
8. Evidence is recorded.
9. Human review gate is reached.
10. Promotion is either approved or rejected according to policy.
11. Rollback/recovery path is available where applicable.
12. Final report explains what can and cannot be claimed.
```

This journey must include at least:

```text
one positive fixture
one blocked forbidden fixture
one ambiguous/warn fixture
one replay run
one failure/rollback fixture
```

Acceptance command:

```bash
make prove-internal-mvp-user-journey
```

Acceptance condition:

```text
The full internal-MVP journey passes with generated evidence.
Forbidden capability is rejected.
Ambiguous action is not silently promoted.
Human-review boundary is enforced.
Claims remain bounded.
```

### Phase 7 — Fix dependency security boundary

Implement or repair the dependency/security boundary without pretending to provide full enterprise security.

Required behavior:

```text
1. Dependency inventory exists.
2. Runtime proof can run without unapproved network access.
3. Dependency scan reports known dependencies and risk level.
4. Secrets are not printed into reports.
5. File-system writes are bounded.
6. Shell commands used by proof targets are allowlisted or justified.
7. Missing lock files or dependency pinning gaps are reported.
8. The report clearly says this is internal-MVP security boundary, not enterprise security certification.
```

Acceptance command:

```bash
make prove-dependency-security-boundary
```

Acceptance condition:

```text
Dependency/security boundary passes internal-MVP criteria.
Known risks are listed.
No enterprise or production security claim is made.
```

### Phase 8 — Fix anti-gaming and scorecard honesty

The scorecard must not show an inflated accepted verdict when raw module acceptance remains low or final hard gates fail.

Repair scoring semantics.

Required behavior:

```text
1. If final_acceptance_hard_gated is NOT_ACCEPTED, the top-level scorecard verdict must not be ACCEPTED.
2. If raw module acceptance is below the configured internal-MVP threshold, the scorecard must show this clearly.
3. Weighted adjusted progress may be reported, but it must be labeled as weighted/audit-adjusted, not final acceptance.
4. Static ACCEPTED verdicts must be rejected unless tied to a proof command and fresh evidence.
5. Echo-only Make targets must not count as proof.
6. Stale reports must not count as current proof.
7. `NOT_ACCEPTED` must never be normalized to `ACCEPTED` because it contains the substring `ACCEPTED`.
8. `PARTIAL`, `LOCAL_PROOF`, and `SCAFFOLD_ONLY` must not count as accepted.
```

Acceptance commands:

```bash
make prove-anti-gaming-95
make prove-coverage-scorecard-95
make prove-progress-scorecard
```

Acceptance condition:

```text
Scorecard is conservative and internally consistent.
Final verdict reflects hard gates.
Raw, weighted, and adjusted scores are clearly separated.
No false pass is possible through static report editing.
```

### Phase 9 — Fix all-known-gaps closure

Implement a single known-gap registry and closure verifier.

The known-gap registry must include at least:

```text
final hard gate failing subtargets
fresh checkout dirty-tree failure
CI/local equivalence mismatch
artifact schema/versioning failures
component coverage gaps
architecture coverage gaps
requirement reconciliation gaps
anti-gaming risk
score inflation risk
raw module acceptance below target
production-readiness overclaim risk
```

For each gap, record:

```text
gap_id
title
source report
severity
required fix
files changed
tests added
proof target
status
waiver, if any
```

Acceptance command:

```bash
make prove-all-known-gaps-closure
```

Acceptance condition:

```text
All required internal-MVP gaps are CLOSED.
Deferred gaps are waived explicitly and do not count as accepted.
No unknown critical gap remains.
```

### Phase 10 — Fix fresh checkout acceptance

Final acceptance must be reproducible from a fresh clone/checkout, not only a dirty local workspace.

Implement a fresh-checkout proof that:

```text
1. Creates or uses a clean temporary clone.
2. Checks out the target commit/branch.
3. Installs only declared dependencies.
4. Runs the canonical proof command set.
5. Verifies source integrity.
6. Verifies compileall.
7. Verifies required Make targets exist.
8. Verifies no tracked files are dirtied by proof commands.
9. Allows only ignored runtime/proof output directories.
10. Produces a transcript and final verdict.
```

Acceptance command:

```bash
make prove-fresh-checkout-acceptance
```

Acceptance condition:

```text
working_tree_clean = true
source_integrity_parse_ok = true
compileall_ok = true
makefile_exists = true
no tracked source files dirtied
no manual setup outside documented commands
```

### Phase 11 — Fix CI/local equivalence

The current CI/local equivalence report says local equivalents are missing for gates such as:

```text
structure_audit
functional_runtime_mvp
functional_agentx
seed_boot
l1_tests
l2_tests
umbrella_agent
agent_evolution_alpha
agent_evolution_beta
governed_self_evolution
repo_memory
git_promotion
```

Fix this by building a CI/local gate matrix.

Required behavior:

```text
1. Parse GitHub workflow files.
2. Extract CI gates.
3. Map each CI gate to a local Make target.
4. Ensure every mapped local target exists.
5. Ensure every local target executes behavior, not only echo.
6. Run local equivalent targets in a deterministic proof mode.
7. Report mismatch as NOT_ACCEPTED.
8. If a CI gate is intentionally deferred, add a waiver and exclude from accepted count.
```

Acceptance command:

```bash
make prove-ci-local-equivalence
```

Acceptance condition:

```text
ci_configured = true
all_gates_have_local_equivalent = true
ci_vs_local != CI_MISMATCH
missing_local_count = 0
ci_failed_gate_count = 0 or explicitly justified by unavailable remote CI with local proof passing
```

### Phase 12 — Fix final proof dependency graph

Final acceptance must know the dependency order of proof targets.

Implement a final proof dependency graph that:

```text
1. Lists every required final proof target.
2. Lists dependencies for each target.
3. Detects missing dependencies.
4. Detects cycles.
5. Runs or verifies targets in valid topological order.
6. Shows which downstream targets are blocked by upstream failures.
```

Acceptance command:

```bash
make prove-final-proof-dependency-graph
```

Acceptance condition:

```text
No missing required dependency.
No cycles.
All required proof targets reachable from final acceptance.
Topological proof order is documented.
```

---

## 6. Final hard-gate repair

After phases 1–12, repair `prove-final-acceptance-hard-gated` so it checks the actual required targets and fails honestly if anything remains unresolved.

It must check at least:

```text
prove-architecture-contract
prove-governance-enforcement
prove-docs-claim-alignment
prove-controlled-evolution
prove-umbrella-agent
prove-api-operator-surface
prove-company-core-product-e2e
prove-evidence-closure
prove-clean-reproducibility-hard-gate
prove-production-readiness-behavioral
prove-post-umbrella-generalization
prove-evaluation-harness
prove-source-integrity
prove-artifact-versioning
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
prove-coverage-scorecard-95
prove-all-known-gaps-closure
prove-anti-gaming-95
prove-fresh-checkout-acceptance
prove-ci-local-equivalence
prove-final-proof-dependency-graph
```

Acceptance command:

```bash
make prove-final-acceptance-hard-gated
```

Acceptance condition:

```text
verdict = ACCEPTED
rejected_subtarget_count = 0
all_required_targets_accepted = true
clean_reproducibility_accepted = true
determinism_verified = true
non_gating_command_count = 0
static_verdict_count = 0
unsupported_claim_count = 0
echo_only_target_count = 0
stale_report_count = 0
contradiction_count = 0
```

---

## 7. Final proof command set

At the end, run:

```bash
make prove-format
make compileall-check
make prove-source-integrity
make prove-artifact-versioning
make prove-exhaustive-inventory-closure
make prove-requirement-reconciliation
make prove-internal-mvp-user-journey
make prove-component-coverage-95
make prove-dependency-security-boundary
make prove-target-architecture-layer-coverage-95
make prove-coverage-scorecard-95
make prove-all-known-gaps-closure
make prove-anti-gaming-95
make prove-fresh-checkout-acceptance
make prove-ci-local-equivalence
make prove-final-proof-dependency-graph
make prove-final-acceptance-hard-gated
make prove-all-internal-mvp
```

If `make prove-all-internal-mvp` is too broad or too slow, do not remove it. Instead, fix the target, split subtargets if necessary, and document the exact reason in a generated proof report.

---

## 8. Required final artifacts

Generate these artifacts under the appropriate reports directory:

```text
reports/final_acceptance_hard_gated/final_verdict.json
reports/fresh_checkout_acceptance/final_verdict.json
reports/ci_local_equivalence/final_verdict.json
reports/artifact_versioning/final_verdict.json
reports/component_coverage_95/final_verdict.json
reports/target_architecture_layer_coverage_95/final_verdict.json
reports/all_known_gaps_closure/final_verdict.json
reports/anti_gaming_95/final_verdict.json
reports/final_proof_dependency_graph/final_verdict.json
reports/progress_scorecard/progress_scorecard_report.json
reports/progress_scorecard/adjusted_progress_report.json
reports/progress_scorecard/score_explanation.md
```

Also generate a human-readable final acceptance summary:

```text
reports/final_acceptance_summary.md
```

The summary must contain:

```text
commit hash
final verdict
all commands run
pass/fail table
remaining gaps, if any
claim boundary
cannot-claim list
raw module acceptance
weighted adjusted progress
final hard-gate status
fresh-checkout status
CI/local-equivalence status
```

---

## 9. Required final claim boundary

If all gates pass, the strongest allowed claim is:

```text
Agent_X is an internally accepted governed agent-evolution MVP. It demonstrates bounded agent generation/orchestration, governed change planning/application, evidence generation, replay/reproducibility checks, human-review promotion boundaries, and conservative final acceptance gates in a local/internal-MVP setting.
```

Still forbidden unless separately proven:

```text
production-ready
enterprise-ready
security-certified
fully autonomous
human-review-free
universally capable agent generator
commercially validated
cloud/SaaS ready
safe for unbounded third-party execution
```

---

## 10. Expected final status after successful work

The target final table should become:

| Area | Current after estimate | Target after closure | Required proof |
|---|---:|---:|---|
| Concept / architecture | 88–92% | 95–100% | architecture coverage + requirement mapping |
| Governance design | 90–95% | 95–100% | governance enforcement + anti-gaming gate |
| Documentation / milestone framing | 92–96% | 95–100% | docs claim alignment + requirement reconciliation |
| Initiator layer | 90–95% | 95–100% | initiator proof + internal-MVP user journey |
| Patch execution / controlled evolution | 85–92% | 95–100% | controlled evolution + patch/human review proof |
| Audit logs / evidence structure | 78–88% | 95–100% | artifact versioning + evidence binding + replay |
| Umbrella-agent proof milestone | 88–95% | 95–100% | umbrella proof remains accepted and replayable |
| Post-umbrella generalization | 80–90% | 95–100% | generic fixture proof + negative fixtures |
| Benchmark / Scriptor / evaluation harness | 80–90% | 95–100% | evaluation harness + benchmark closure |
| Replay / reproducibility proof | 65–75% | 95–100% | fresh checkout + clean reproducibility + CI/local equivalence |
| Final acceptance runner | 65–75% | 100% | final hard gate accepted |
| Production readiness | 45–55% | 95–100% internal-MVP boundary only; real production-ready remains forbidden | production-readiness behavioral proof + dependency/security boundary + known-gap closure without production-ready claim |

Target overall status:

```text
STRICT MODULE ACCEPTANCE: >=95% for internal-MVP required modules, or lower only if deferred modules are formally waived and excluded from accepted counts.
FINAL ACCEPTANCE: ACCEPTED.
FRESH CHECKOUT: ACCEPTED.
CI/LOCAL EQUIVALENCE: ACCEPTED.
FINAL CLAIM: INTERNAL MVP ONLY.
```

---

## 11. Final answer format required from the coding LLM

When finished, respond in this exact format:

```text
VERDICT:
ACCEPTED / PARTIAL / NOT_ACCEPTED

SUMMARY:
One paragraph explaining what changed.

COMMAND RESULTS:
Table with command, result, evidence path.

CLOSED GAPS:
Table with gap, fix, files changed, proof.

REMAINING GAPS:
Only if any remain. Include reason and required next action.

FINAL CLAIM BOUNDARY:
What Agent_X can claim and cannot claim.

FINAL ACCEPTANCE CONDITION:
Whether make prove-final-acceptance-hard-gated and make prove-all-internal-mvp pass from a clean checkout.
```

If anything fails, return `PARTIAL` or `NOT_ACCEPTED`. Do not massage the result.
