# DoubleTake — Master v2 AutoTailor Final Gain, Selective Adoption & Closure (Offloaded v1)

**Target:** `olejardamir/DT`, authoritative `main` branch.  
**Suggested incoming agent:** MiMo-V2.6-Flash (verify the *actually served* model, never infer from the selection UI).  
**Original mission:** `DOUBLETAKE_GOAL_DRIVEN_AUTONOMOUS_CAPABILITY_EVOLUTION_RESEARCH_AND_TASK_CLOSURE_MASTER_v2_AUTOTAILOR.md`.  
**Purpose:** Continue **only the unresolved gain/adoption/final-closure delta** of the original master mission. This is an offloaded continuation, **not** a new architecture, a reimplementation, or permission to mark unproven results as complete.

## 0. Binding directive

The original v2 master mission, current repo `AGENTS.md`, recorded security policy, production governance, existing durable goal and capability manager, three-phase/successor evolution mechanism, and all already-certified deliverables remain authoritative. Read the original prompt **if available in repo or provided by operator**. Do not fabricate its presence: if not available, use this self-contained handoff and the repository's committed evidence as the concrete source of obligations, and request the original only if an essential ambiguity cannot be resolved.

**Primary outcome:** independently verify live model-assisted capability benefits; selectively **ADOPT**, **REJECT**, or **ALREADY_COVERED_NO_DELTA** each AutoTailor candidate under reproducible acceptance gates; apply justified code changes safely; regenerate the downstream evidence chain; and establish truthful final closure, or precisely document remaining barriers. No blanket “must adopt”: rejecting or retaining a candidate as unproven can be the correct engineering result. Do not loosen success criteria merely to obtain a green verdict.

## 1. Known handoff state — **snapshot, not a trusted current fact**

As examined from GitHub on **2026-10-19**, the latest inspected goal-driven evidence showed:

- `reports/goal_driven_capability_closure/FINAL_CLOSURE.json`: `closure_decision=ENGINEERING_COMPLETE_GAIN_UNPROVEN`, `mission_complete=false`, `unresolved=[]`, `gain=IMPROVEMENT_UNPROVEN`.
- `BENCHMARKS.json`: seven of seven groups measured (four live, three fixtures). All rows passed their *existing engineering criteria*; this is not equivalent to demonstrated end-to-end production benefit.
- `AUTOTAILOR_MECHANISM_MAPPING.json`: five mechanisms: **ADOPT=0**, **GAIN_UNPROVEN=4**, **ALREADY_COVERED_NO_DELTA=1**.
- `LIVE_GAIN.json`: `LIVE_MEASURED_STRICT_GAIN` for the tested combined capability-selection scenario.
- `LIVE_GAIN_ISOLATED.json`: `ISOLATED_ARMS_MEASURED`; 48 arm runs (four arms × 12 held-out scenarios); actual served model recorded as `opencode/big-pickle`, despite the operator now considering MiMo.
- Isolated arm outcomes relative to the **six-of-twelve** baseline: `COMPACT_QUALITY_ONLY` 6/12 (tie), `COMPACT_PLUS_LIKELIHOOD` 4/12 (**regression**), `DYNAMIC_RESELECTION` 6/12 (tie), `TRAJECTORY_SYNTHESIS_ONLY` 8/12 (**+2/12**, more average tool calls, 0.75 vs 0.583333). Earlier summaries called the strict improvement “+1/6”; the primary 12-scenario counts are the controlling denominator.
- Campaigns use a real model selection loop with governed deterministic harness; do not misstate them as production end-user task execution. Baseline rows are pinned to an existing model session and not rerun inside the isolated-arm record. No observed authorization violations in those recorded arms. Latency/token evidence may be incomplete; distinguish unknown costs from zero costs.
- At this snapshot, repository work elsewhere is continuing concurrently. The freshest observed GitHub HEAD was `2e041e775e` (prefix only), but it may have advanced. Never hardcode it as the current HEAD.

**No percentage should determine closure.** The prior conversational estimate of ~97% refers to engineering completion, not verified promotion or goal satisfaction.

## 2. Preparation and non-interference (mandatory first action)

1. Confirm `git status`, actual `HEAD`, origin/main relationship, active processes, current run ownership, active work units, current model/provider, permissions, machine limitations, and relevant `AGENTS.md` rules. Inspect commits since the handoff snapshot.
2. Read the CURRENT committed versions of `FINAL_CLOSURE.json`, `CRITERION_TABLE.json`, `AUTOTAILOR_MECHANISM_MAPPING.json`, `AUTOTAILOR_ABLATIONS.json`, `CAPABILITY_FILTER_EVIDENCE.json`, `DYNAMIC_RESELECTION_EVIDENCE.json`, `TRAJECTORY_TOOL_EVIDENCE.json`, `LIVE_GAIN.json`, `LIVE_GAIN_ISOLATED.json`, `BENCHMARKS.json`, `LIVE_TASKS.json`, `CROSS_ARTIFACT_AUDIT.json`, and `MISSION_MANAGER.json`. Inspect each generator, certifier, and `--verify` recipe, not merely status strings.
3. **Single-writer ownership:** operate on `main` in accord with current `AGENTS.md`. Do not create branches, tags, hidden worktrees, reset others' commits, clobber another agent's dirty changes, or re-run competing live campaigns. If another lane owns the relevant file, defer to it and do different independent verification work. Cross-lane changes require explicit handoff.
4. All test/workload runs must use the repository's host workload guard as required in `AGENTS.md` (notably `python3 tools/doubletake_evolve/runtime/host_workload.py -- <command>` when applicable), respecting sequential workload and resource limits. No unapproved downloads, installs, network probes, destructive changes, or policy bypasses.
5. Obtain a **fresh** before-state report listing exact artifacts, stale digests, status, evidence character (`MEASURED_LIVE`, `MEASURED_FIXTURE`, `NOT_MEASURED`), live provider, model requested vs served, each candidate's currently justified decision, and active blockers. Preserve the immutable original record and comparative baseline.

### DoD 0
A verifiable, commit-bound work plan shows ownership, live model identity, original acceptance thresholds, affected paths, and a no-regression baseline; no speculative code changes have occurred.

## 3. Evaluate AutoTailor candidates individually — no forced adoption

Assess separately:

**A — Trajectory-to-tool synthesis.** The current evidence indicates a 12-scenario completion gain (8 vs 6) with additional tool calls. Confirm the gain on controlled held-out repetitions and, when feasible, a newly selected non-overlapping legitimate real task. Verify synthesized tools generalize to parameter variations, changed inputs/DOM, correct provenance, permissions, no credential or PII capture, evidence integrity, rollback, and failure fallback. Measure cost/latency where feasible; if unavailable label `NOT_MEASURED`. Do not promote based only on one favorable stochastic sequence or contaminate held-out material.

**B — Quality/granularity filtering.** The isolated arm tied baseline. Verify absence of false-positive removal, safety-critical and rare-tool retention, correct pre-promotion registry wiring, preserved long-tail task success, and a measured improvement in some declared dimension (tool inventory, token/context budget, latency, or quality) without unacceptable regressions. **Tie in completion alone is not proof of gain**. If no qualifying gain, declare unproven or reject according to the frozen rule.

**C — Usage-likelihood compact selection.** Existing live arm REGRESSED (4 vs 6). This is **not promotable** without a genuine corrected implementation and independent, pre-declared held-out retest that resolves missed capability coverage and passes all gates. Prefer a truthful REJECT / disabled state over shipping a known regression. Do not optimize the test material or delete low-use but essential recovery tools.

**D — Dynamic reselection.** Existing isolated arm tied baseline. Determine whether real task recovery, gap classification, retries, latency, or coverage exhibit independent measurable advantages on tasks where reselection is actually invoked. Maintain authorization denials as hard stops; bounded loops, anti-oscillation, and correct parent task resume are non-negotiable. If the tests never trigger reselection, a tie cannot establish that reselection works beneficially.

**E — General-agent fallback.** Previously mapped `ALREADY_COVERED_NO_DELTA`; preserve if the existing fallback passes tests. Do not introduce a redundant agent engine or new central controller.

For every candidate, write an evidence-backed decision ledger row with: existing equivalent, code path, exact behavioral delta, original baseline, scenario population and sample counts, model requested/served, controlled comparisons, positive/negative-control coverage, grant checks, stability risks, resource cost, confidence limits, decision, and rollback path. Separate **implemented**, **benchmarked**, **promoted**, and **activated** — these are not interchangeable.

### DoD 1
Every candidate has a defensible independent decision, and **none** is promoted on source-paper benchmarks, offline fixture success alone, a tie without a measured benefit, a one-off lucky model response, or a metric worsened outside the declared acceptance envelope.

## 4. Establish fair cross-model evidence

Because the previous recorded campaigns actually served **Big Pickle**, switching the development agent to MiMo does **not** automatically switch the model used by the live test harness. Test the *served* model explicitly.

1. Record MiMo request configuration AND response-observed provider/model identifiers. If MiMo isn't actually served, call that out and do not label a Big Pickle campaign “MiMo”.
2. Decide whether evidence is being compared **within a fixed model** (preferred for mechanism attribution) or **across models** (a separate question). Preserve separate arms/sessions/model tags; do not conflate the effect of the model switch with a capability change.
3. Reuse the frozen benchmark set for reproduction, then add a strictly held-out challenge set if needed; lock evaluation rules *before* model calls. Keep baseline/candidate trials paired under the same model, environment, grants, tasks, retry budget, and budget guard. Do not overwrite the historical baseline.
4. Evaluate repeatability or uncertainty. If the sample is too small to support a robust performance claim, record `GAIN_UNPROVEN` rather than asserting causality. Preserve failed/refused outcomes and complete accounting of sessions, API usage, tests, timestamps, and costs.
5. Prove all security and non-vacuity fault-injection controls still refuse malicious or corrupted evidence, injected instructions, permission escalation, stale identities, side-effect replay, and incomplete source coverage.

### DoD 2
Each claimed gain is traceable to a fair comparison, with model identity and scenario denominator explicit. The independent certifier detects intentionally mutated gain claims and any attempted model-identity misattribution.

## 5. Governed promotion, or principled non-promotion

For each justified candidate:

1. Locate **existing** capability registry, adoption, version/rollback, filtering, and task-reselection seams; use them. Do not create a competing controller, kernel, model gateway, or registry.
2. Register and activate only the smallest tested capability delta with the existing permission chain, version stamps, sandboxing, and guarded evaluation. Preserve the general fallback and all protected capabilities.
3. Independently test: normal task; previously failing gap task; changed-input held-out task; rollback; version activation; resumed parent without duplicated consequential side effects; denied authorization; malicious prompt injection; restart/crash retention; concurrency constraints according to the existing runtime policies.
4. Conduct matched before/after integration testing against committed baseline, with evidence from the actual production entrypoint or a clearly labelled isolated analogue. Do not call a temporary test store “production”.
5. If promotion fails, **roll back cleanly** and record REJECT, BLOCKED, or GAIN_UNPROVEN with factual grounds. Do not relax thresholds, alter verdict vocabularies to force PASS, or fabricate network availability.

**Special rule:** A result of **zero adopted mechanisms** may be truthful if none meets the genuine-gain standard; in that case, do **not** incorrectly declare `mission_complete=true` if the master contract explicitly requires verified improvement. Instead explain the exact unmet objective and the minimal feasible next evidence step.

### DoD 3
Any adopted mechanism is actually active through the existing DT path, measurably beneficial, safely reversible, and supported by independent reproducible evidence. All non-adopted mechanisms have explicit defensible verdicts.

## 6. Downstream evidence regeneration and final closure

Use the repository's **documented regeneration order**, including prerequisite records, `AUTOTAILOR_MECHANISM_MAPPING`, applicable gain reports, `BENCHMARKS`, `LIVE_TASKS`, `CRITERION_TABLE`, `FINAL_CLOSURE`, `CROSS_ARTIFACT_AUDIT`, and `MISSION_MANAGER` (adjust order to the current `AGENTS.md` recipes). Never silently patch derived JSON totals by hand.

After each independent work unit:

- Commit the smallest coherent changed set on `main` without overwriting another agent's simultaneous changes.
- Re-derive affected SHA, bound-head/retention identity, evaluator input, and mapped-blob facts from committed blobs.
- Run local certifiers, canonical verification commands, non-vacuity/fault-injection tests, regression suite, and a clean verifier pass at a reachable commit.
- Check the final decision against the full actual master contract, including measurable gain, capability activation, parent goal completion, and truthful user-facing output. `unresolved=[]` and a green verifier are **necessary but insufficient** for `mission_complete=true` if gain remains `IMPROVEMENT_UNPROVEN`.
- Preserve the distinction among `ENGINEERING_COMPLETE_GAIN_UNPROVEN`, `MISSION_OPEN_UNRESOLVED_ROWS`, a justified safe final completion, and genuine external authorization blockers. Never manufacture a closure state or use historical narrative as current truth.

### DoD 4 (final)
The final operator report contains (1) verified repo SHA; (2) old/new closure state and proof; (3) mechanism-by-mechanism ADOPT/REJECT/ALREADY_COVERED/GAIN_UNPROVEN decisions; (4) active versions and rollback refs for promoted components; (5) actual served model(s); (6) measured held-out success/cost/latency with denominators; (7) canonical verifier exits and residual failing tests; (8) limitations and next minimal step for anything unproven. **Do not claim success without an independently proven full master mission.**

## 7. Execution / stopping rules

Work autonomously through concrete, testable slices. At every iteration, choose the highest-value remaining **measurable gap**; implement only where the measured effect justifies it; verify, commit, and resume. Remain within existing resource, policy, and approval constraints. If a genuine external dependency or live access authorization blocks progress, capture it once with proof, continue independent safe work, and finish with a precise blocked-state report instead of an infinite loop.

Stop when: (a) all master-v2 obligations have independently verified completion, including a defensible gain and actual activation where required; or (b) remaining actions cannot legally, technically, or experimentally proceed under present permissions/resources, with blockers proven and operator decisions explicitly requested. Never keep regenerating evidence without making substantive forward progress.

**Do not redo the earlier engineering mission. Do not add REA. Do not offload another prompt merely to avoid remaining verification work.**

## 8. First response and final response contract

**At start**, report in under 12 lines: current HEAD, status of `FINAL_CLOSURE`, exact latest candidate verdicts, actual model served in the latest live gain campaign, newly identified vs already-recorded blockers, and your single next work unit. Then execute it, not just outline it.

**At finish**, output:

```
ORIGINAL_MISSION: DOUBLETAKE_GOAL_DRIVEN_AUTONOMOUS_CAPABILITY_EVOLUTION_RESEARCH_AND_TASK_CLOSURE_MASTER_v2_AUTOTAILOR
START_SHA: <sha>
FINAL_SHA: <sha>
MODEL_REQUESTED: <provider/model>
MODEL_SERVED: <provider/model or NOT_MEASURED>
ENGINEERING_STATUS: <derived>
GAIN_STATUS: <derived, with baseline and candidate denominators>
AUTOTAILOR_A: <decision + evidence ref>
AUTOTAILOR_B: <decision + evidence ref>
AUTOTAILOR_C: <decision + evidence ref>
AUTOTAILOR_D: <decision + evidence ref>
AUTOTAILOR_E: <decision + evidence ref>
MISSION_COMPLETE: <true only if independently proven; otherwise false>
VERIFICATION: <commands and exits>
UNRESOLVED: <exact blockers or none>
NEXT_MINIMAL_ACTION: <one concrete action, or none>
```

**Do the work; do not merely propose it.**
