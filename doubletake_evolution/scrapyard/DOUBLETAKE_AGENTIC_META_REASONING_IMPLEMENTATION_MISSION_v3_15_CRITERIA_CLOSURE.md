# DoubleTake Agentic Meta-Reasoning Implementation Mission
## v3 — 4-criterion residual closure edition

**Current local `main` at execution time is authoritative.**
Re-read and re-measure the convergence table before every substantive iteration.

# MISSION

Finish the remaining agentic meta-reasoning gaps in DoubleTake without redesigning already-working architecture.

The meta-reasoning layer must remain a governed System-Two/control layer. It may observe, assess, propose, select, dispatch, recover, stop, and report only through canonical DoubleTake authority.

Do not weaken already-proven behavior to close the remaining rows.

# AUTHORITATIVE TABLE

Use:

`tools/doubletake_evolve/meta_reasoning/tests/test_meta_convergence_table.py`

At reduction time:

- 48 criteria total
- 44 PASS
- 4 OPEN
- `test_no_criterion_is_open` remains red by design

Current OPEN set:

`MR-AC, MR-AI, MR-AP, MR-Z`

Re-derive this set from current `main`.
If any listed row has since closed, do not redo it.
If a previously PASS row has genuinely regressed, repair the regression.

# REMAINING WORK

## MR-F — Bounded state

Current gap:
compact-state bounds and blocker/citation survival are proven only through direct `CompactStateStore` tests.

Close it by driving a sufficiently long real governed run through the production cycle and proving:

- compact state remains bounded;
- important blockers survive compaction;
- required citations/evidence survive compaction;
- the bound is exercised rather than vacuous;
- removing or enlarging the production bound makes the certifier fail.

Do not close MR-F with another helper-only test.

## MR-Q — Governance preservation

Current gap:
fail-closed governance references are proven, but the stronger behavioural claim is not.

Drive a meta-selected action that requests more authority than canonical governance permits and prove:

- canonical governance refuses it;
- the refusal survives through meta selection/dispatch;
- the controller cannot override, rewrite, or reinterpret the refusal into permission;
- no side effect occurs;
- evidence identifies governance as the operative reason.

Perturb the canonical governance handoff and prove the test turns red.

## MR-R — STOP selects an existing eligible artifact

Current state already proves substantial STOP behavior, including earlier-artifact selection and digest-invalid refusal.

Close only the remaining semantic gaps in the row.

Prove through the production path that STOP:

- selects an artifact that actually exists in the current run;
- selects only an artifact whose current durable state still satisfies eligibility/verification requirements;
- does not fabricate an artifact identifier;
- does not silently substitute the newest artifact when the selected one is invalid;
- records a truthful refusal when no acceptable artifact exists.

Do not reopen already-proven STOP behavior unless current evidence has regressed.

## MR-V — Observability consistency

`build_report` is now production-wired. The remaining task is consistency, not existence.

Cross-check the real run report against authoritative runtime/durable evidence:

- cycle outcomes;
- ledger/resource accounting;
- dispatch records;
- artifacts;
- lineage;
- stop state;
- verification/eligibility state.

A report must not claim an action executed when it was suppressed, an artifact was selected when it was refused, or a capability/result contributed when durable execution says otherwise.

Inject at least one contradiction and prove the consistency certifier fails.

## MR-Y — Extensibility

Use the normal extension seam, including `ActionKindRegistry` or its current authoritative replacement.

Register a genuinely new ordinary extension through the supported mechanism and prove:

- it becomes usable by meta-control;
- no central name-specific conditional is added;
- no central orchestration table requires editing solely for that extension;
- existing governance/budget/scope rules still apply;
- removing the registry/extension wiring makes the test fail.

Prefer a synthetic extension registered through the real production mechanism over editing an existing built-in action.

## MR-Z — Adversarial non-vacuity

Complete the mission's remaining perturbation coverage.

At reduction time, the table still recorded missing production-path perturbations around areas including:

- artifact-edge correctness;
- selective context widening;
- STOP artifact existence;
- governance handoff;
- compact-state bounds.

Re-read current MR-Z before acting because this list may shrink.

For each still-required perturbation:

1. establish a green baseline;
2. modify one production mechanism;
3. prove the intended certifier turns red;
4. restore the mechanism;
5. record only measured non-vacuity.

Do not count changes to test scaffolding as perturbing the production mechanism.

## MR-AA — System-Two authority boundary

The controller already reaches the governed System-Two path and current evidence protects routine Borg/Collective ownership boundaries.

Close the remaining provider-authority requirement.

Prove with the canonical provider-authority audit that meta-reasoning introduces no:

- UNKNOWN authority;
- stale authority;
- misclassified provider owner;
- routine-control ownership leak.

Then inject a forbidden provider dependency/ownership edge into a routine owner and prove the authority evidence fails.

Do not create a second provider authority model for the meta layer.

## MR-AC — Structured stage contracts / stage tool authority

Most adversarial stage-contract cases are already closed.

Re-read the row and implement only the remaining named cases.

Requirements remain:

- model/stage output is untrusted data;
- malformed, non-JSON, unknown-version, oversize, unsupported, or authority-expanding replies fail closed as applicable;
- stage output cannot invent tool/provider/governance authority;
- the production cycle, not only the parser helper, demonstrates each remaining case;
- perturbing the corresponding enforcement makes the certifier fail.

Do not broaden parsing permissiveness merely to make examples pass.

## MR-AD — Run artifact isolation

Run scoping and sibling-run isolation are already partly proven.

Close the remaining leak boundary:

After a real governed run, inspect relevant global/shared stores and prove run-local artifacts do not automatically enter:

- global collective memory;
- cross-project state;
- long-term learning stores;
- other shared artifact authorities;

unless a separate explicit governed promotion path authorizes it.

The certifier must distinguish "not leaked" from "store was never inspected."

## MR-AI — Submission eligibility

Role clamping is already production-proven.

Close only the remaining eligibility gap.

Prove that the meta layer cannot make an artifact submission-eligible merely by:

- worker self-assertion;
- controller preference;
- role wording;
- STOP selection;
- missing verification.

Also prove that a legitimately verified and eligible artifact is not blocked by an accidental flat ban.

Eligibility must come from canonical authority, not the model's claim.

## MR-AK — User-interaction block

Drive a real waiting-on-user condition.

Prove:

- the controller cannot fabricate the missing user response;
- the run does not continue past a hard user-input dependency as though it were satisfied;
- the waiting reason is durable/truthful;
- when a real response arrives, the run resumes from durable state;
- completed work is not replayed unnecessarily;
- the new user response does not silently broaden authority or scope.

Perturb by allowing fabricated/synthetic resolution and prove the certifier fails.

## MR-AM — Loop termination / no-progress control

Drive repeated no-progress behavior through production.

Prove:

- repeated equivalent proposals/work are recognized;
- identical work is not executed forever;
- low-improvement/no-progress state is durable and observable;
- the run reaches a bounded truthful terminal/refusal state;
- termination is not satisfied merely by an arbitrary tiny hard-coded iteration count;
- genuinely new useful work can still continue.

Perturb duplicate/no-progress recognition and prove the run/test exposes the defect.

## MR-AN — Pause / cancel / emergency control

Drive real cancellation and, where supported, pause/resume.

Prove:

- cancellation prevents new stages/dispatches from issuing;
- in-flight operations are handled truthfully;
- resource reservations are reconciled;
- resume continues from durable state where appropriate;
- completed mutating work is not duplicated;
- cancellation cannot be overridden by meta reasoning.

Do not simulate cancellation solely by directly calling a state helper.

## MR-AP — Objective / scope non-drift

The canonical objective and revision already reach dispatched work.

Drive a multi-cycle production run containing a plausible but off-objective proposal.

Prove:

- it is detected as outside the current objective/scope;
- it is refused before execution;
- refusal is attributable to objective/scope authority rather than unrelated budget/ranking failure;
- later cycles do not gradually normalize the off-objective work;
- a legitimate objective revision can change what is allowed only through the canonical revision mechanism.

## MR-AV — Single meta transition / optimistic concurrency

Store-level stale-digest protection is already proven.

Close the production concurrency half.

Drive two real supported triggers concurrently against the same run/state and prove:

- only one transition commits against the expected state;
- the loser cannot silently overwrite the winner;
- the conflict is durably recorded;
- lost work is requeued/reconsidered when appropriate;
- the next Assess sees the authoritative resulting state;
- no duplicate mutating effect is produced.

Do not close this with another direct state-store CAS test.

# LOOP

Repeat until convergence:

1. Inspect authoritative current `main`.
2. Read the full MR-A–MR-AV convergence table.
3. Run the meta-reasoning convergence suite.
4. Derive the exact current OPEN set.
5. Ignore already-PASS rows except as regression guards.
6. For each OPEN row, classify the residual as:
   - missing runtime mechanism;
   - production wiring gap;
   - production certifier gap;
   - helper-only proof;
   - partial semantic requirement;
   - stale evidence.
7. Choose the single highest-value coherent delta.
8. Trace the actual production path before editing.
9. Implement the smallest general repair.
10. Add production-driving executable evidence.
11. Add non-vacuity evidence by perturbing the real repaired mechanism.
12. Run focused tests.
13. Run the complete meta-reasoning convergence suite.
14. Re-read the table from current committed state.
15. Update a row to PASS only when its full semantic requirement is proven.
16. Rebuild the OPEN set and repeat.

# REGRESSION GUARDS

The 33 rows already PASS are not implementation targets unless their evidence becomes red.

Preserve in particular:

- production ingress and deterministic activation;
- DIRECT-history escalation;
- control/object-work separation;
- incremental assessment;
- budget truth and set selection;
- conflict/concurrency decisions;
- self-contained dispatch;
- artifact lineage and persistent retrieval;
- capability participation and dynamic reevaluation;
- verification discipline;
- forced-stop honesty;
- crash/resume;
- matched DIRECT-vs-META comparison;
- canonical inference/provider authority;
- canonical task authority;
- transactional dispatch;
- capability baseline non-regression;
- stale-decision refusal;
- single orchestration authority;
- mid-run task revision;
- context data governance/egress;
- import/authority identity;
- no recursive control-ingress reentry;
- timeout/deadline propagation;
- committed-delta/out-of-order safety.

Do not "simplify" remaining work by weakening any of these.

# HARD RULES

- Current `main` is authoritative.
- Meta reasoning is integrated DoubleTake control infrastructure, not a second agent framework.
- Do not invent parallel governance, provider, task, capability, artifact, or budget authorities.
- Do not let model output grant authority.
- Do not let the controller fabricate user input.
- Do not let workers self-promote roles or eligibility.
- Do not let STOP invent artifacts.
- Do not let cancellation, pause, timeout, retry, or restart erase durable truth.
- Do not let concurrency silently overwrite state.
- Do not replace a missing production mechanism with prose.
- Do not close behavioural criteria using helper-only tests.
- Do not weaken adversarial tests to obtain PASS.
- Do not hard-code current action/capability names when an extensible registry/contract mechanism exists.
- Every substantive repair must have executable evidence.
- Every important new guard must have a measured way to turn red.
- Make no cosmetic commit when no runtime/test delta is justified.

# FINAL VALIDATION

Before declaring convergence:

1. Confirm all 48 rows are PASS for their actual semantic requirements.
2. Confirm `test_no_criterion_is_open` passes.
3. Run the full meta-reasoning suite.
4. Re-run the matched DIRECT-vs-META comparison and preserve honest overhead/results.
5. Perform a fresh adversarial pass targeting all 15 formerly OPEN areas.
6. Check that no closure relies only on helper-level reachability.
7. Check that governance, provider authority, artifact authority, capability authority, objective/scope, isolation, eligibility, budget, restart, cancellation, deadlines, and concurrency remain intact.
8. Reinspect current `main` once more and make no change if no justified gap remains.

# STOP CONDITION

Stop only when:

- the authoritative table contains zero OPEN rows;
- `test_no_criterion_is_open` passes for the right reason;
- every formerly OPEN behavioural criterion has production-path evidence;
- the remaining perturbation/non-vacuity obligations are complete;
- the full suite is green;
- the adversarial pass finds no material defect;
- another fresh inspection produces no justified runtime or evidence change.

Then report:

`AGENTIC_META_REASONING_CONVERGED`

Until then, continue the loop.

# CURRENT STATUS (as of measurement against main)

Measured on `248dc22984be0399ebc0f83c8bbc9de9b5fbff9c`:

- 48 criteria total (A–AV)
- 44 PASS
- 4 OPEN: MR-AC, MR-AI, MR-AP, MR-Z
- `test_no_criterion_is_open` fails by design with those 4 rows

This document reflects the current state of the convergence table on main. No code changes were made.
