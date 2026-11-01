# CL-META-REASONING-001 — historical governed meta-reasoning acceptance contracts

**Status:** public-safe archival research consolidation, **NOT** current DT implementation or execution instructions. Original historical source texts remain recoverable through Git. **Current DT parity UNKNOWN**; do not claim that old PASS/OPEN values describe today's code.

## Exact source provenance and scope

- **MR-HIST-V2:** `DOUBLETAKE_AGENTIC_META_REASONING_IMPLEMENTATION_MISSION_v2_RESIDUAL_CLOSURE.md`, original Git blob `552fef41ec2d1166f1e058eaa2de72ef8e574263` (16291 UTF-8 characters). Historical 48-criterion convergence at 23 PASS / 25 OPEN; this version contains broader residual diagnostics, production evidence standards, matched DIRECT-vs-META comparisons and adversarial controls.
- **MR-HIST-V3:** `DOUBLETAKE_AGENTIC_META_REASONING_IMPLEMENTATION_MISSION_v3_15_CRITERIA_CLOSURE.md`, original Git blob `fde46435d106157f8ac884deb3f7dc1f6b3d02d3` (14569 UTF-8 characters). Later snapshot at 44 PASS / 4 OPEN, but still lists 15 detailed candidate gaps. **Contradiction retained:** its introductory/current-status sections identify only MR-AC, MR-AI, MR-AP and MR-Z as OPEN, whereas the 15-item body and "33 PASS" regression-guard wording reflect a broader transitional backlog. Treat the actual current convergence table as authoritative, never the title or prose.
- These are historical author-provided task specifications, not external peer-reviewed validation; licensing/ownership beyond the already-public texts was not independently determined. No private DT code or BORG source is reproduced.

## Historical status snapshots (not live evidence)

### V2 snapshot


### V3 snapshot


## Distinct V2 residual mechanisms not repeated as full V3 sections

### MR-C — Escalation
The deterministic escalation half is proven. The DIRECT-history half is not.
`SIGNAL_DIRECT_HISTORY` exists but no producer currently carries a DIRECT attempt's prior work, consumption, workspace state, and failure into the first Assess.

### MR-J — Conflict / concurrency control
`parallelizable_hint` exists in representation, but no general pairwise compatibility/conflict mechanism consumes it.
Two individually useful but incompatible mutable actions therefore lack a production conflict decision.

### MR-AG — Transactional dispatch
Durable intent-before-effect is proven.
The remaining half requires honest completion/reconciliation across the effect/commit boundary, including crash ambiguity, without double execution or fabricated certainty.

Treat any row that current `main` now proves differently according to current evidence.

## B. Mechanism exists, but production-path certifier is missing or incomplete

### MR-O — Capability participation integration
The capability reevaluation path is wired.
Certify it through the production meta path.

### MR-P — Dynamic capability reevaluation
Certify that a previously unused capability can become relevant later in a real run and that duplicate/cycle controls survive reentry.

### MR-U — Crash / resume
Exercise the named interruption points through the real cycle:
- after controller compute but before durable stage commit;
- after durable dispatch preparation;
- after effect completion before aggregation.
Prove no duplicate stage commit, duplicate mutation, or fabricated certainty.

### MR-AO — Mid-run task revision
Drive a real steering/revision event.
Invalidate stale decisions, reassess under the new revision, and prove steering text does not silently expand scope.

### MR-AT — Deadline / timeout propagation
Use a provider/action that does not return and prove one canonical deadline budget propagates through retry/recovery without granting a fresh full deadline.

### MR-AU — Committed delta cursor / out-of-order results
Drive real parallel workers that complete in reverse order and prove the durable cursor remains gap-safe across restart.

### MR-X — Matched comparison harness
The DIRECT-vs-META matched comparison is mission-critical and currently lacks a production caller/certifier.

Implement or wire the real harness so DoubleTake can compare DIRECT and META under matched:
- task/input;
- model/provider;
- resource budget;
- tool/capability availability;
- environment;
- stopping conditions;
- measurement contract.

Do not declare the mission complete without this evidence.

## V3 refined production acceptance and negative tests (15 criteria)

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

## Shared integration contract and falsifiable Ground

- Meta-reasoning is a governed System-Two layer on existing task/run state and canonical execution, not a new owner of provider, governance, capability, budget, artifacts or Borg routine control. Model/stage output is untrusted and cannot grant permission, invent user responses, artifacts, role eligibility or success.
- **Production trace:** supported ingress → durable task/run state → Assess/Propose/Evaluate → governed selection/budget → intent-before-effect → actual worker/effect → aggregation/artifact/verification → stop/recovery → report/ledger reconciliation. A helper-only green test or fabricated fixture state is insufficient for a behavioral criterion.
- **Non-vacuity:** perturb the *production mechanism* (not just test scaffolding) so the named certifier turns red; restore and re-run. Require legitimate positive cases alongside refusal/negative cases; don't win by blanket blocking all actions.
- **Crash/concurrency:** preserve truthful ambiguous effect/commit windows, idempotent replay, optimistic conflict requeue, gap-safe committed cursors, cancellation, no new work after cancel, deadlines without reset, scope revision invalidation and no cross-run memory leak.
- **Objective:** compare DIRECT vs META on matched input, provider/model, tools, environment, budget, stopping conditions and verifier. Track correctness, latency/cost, calls/steps, retry, failure, meta overhead and verified artifacts. Report neutral or worse META results, not only wins.

### V2 matched-comparison acceptance (historical exact details)

Before final convergence, execute MR-X with a reproducible matched comparison.

At minimum record for DIRECT and META:

- task identity and input digest;
- provider/model identity;
- resource ceilings;
- actual measured resource consumption;
- tool/capability inventory;
- wall/step/model-call budget;
- completion state;
- verified output/artifact;
- correctness/quality measure appropriate to the task;
- latency/cost;
- retries/recovery;
- failures;
- meta-controller overhead;
- final decision evidence.

The comparison must not give META hidden extra budget or tools.

The purpose is not to prove META always wins.
The purpose is to establish whether the governed meta layer adds measurable value, when it abstains, and whether its overhead/safety trade is honestly recorded.

If META is worse or neutral on a task, record that result rather than tuning the benchmark after seeing it.

### V2 adversarial end-to-end negatives (historical exact details)

After all 48 rows appear PASS, perform a fresh adversarial pass against the integrated runtime.

Attempt to cause:

- a DIRECT-history escalation that loses the prior attempt;
- two individually useful but incompatible mutable actions to execute together;
- state growth beyond the declared bound;
- a meta-selected action to bypass canonical governance;
- STOP to select a missing/unverified/ineligible artifact;
- crash after provider response but before durable commit;
- crash after effect completion before aggregation;
- contradictory report/ledger/artifact evidence;
- leakage into shared/global memory;
- controller authority to leak into Borg/routine control;
- malformed/oversize/unknown stage output to escape fail-closed handling;
- cancellation followed by new work;
- steering followed by execution of a stale decision;
- off-objective work to execute;
- a timeout retry to receive a fresh full deadline;
- out-of-order completion to skip a missing delta;
- two concurrent triggers to silently overwrite one another;
- a newly registered action/capability to require central edits;
- a no-progress loop to continue indefinitely;
- META to appear better only because it received more budget/resources;
- a green criterion test to remain green after its production wiring is removed.

Repair any material failure and repeat the convergence pass.

### V3 regression guards (historical, not current PASS)

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

## Disagreements, limitations, next falsifier

1. **V2 23/25 vs V3 44/4** is temporal claimed progress, **not** independently verified improvement. V3 internally lists 15 residual tests while saying 4 OPEN; preserve the distinction between a *possible regression/strengthening test* and a current OPEN criterion.
2. Both documents instruct repeated convergence loops; this canonical **does not authorize** any loop, code modification, changed mission, or automatic criterion promotion. Only the Evolution Director and authorized DT executor can determine current scope and run permitted tests.
3. **Unknown:** present private source revision and actual convergence-table verdict, authenticated local mission receipt, independent host test logs, matched runtime benchmarks, owner permission for any fixture, and whether any historical MR mechanism is still missing.
4. **Small safe discriminator:** Director/authorized executor reads the current MR-A–MR-AV table and compares the four v3 OPEN claims plus the 11 other v3 described gaps against real production certifiers. Require exact source/test identity, green baseline, named negative mutation turning red, unchanged permissions and independent observation. If already present, mark ALREADY_PRESENT; if fixture unavailable, NO_AUTHORIZED_FIXTURE. This does not repair B1 or prove natural Borg autonomy.

**Stable members:** MR-HIST-V2 `552fef41ec2d1166f1e058eaa2de72ef8e574263`; MR-HIST-V3 `fde46435d106157f8ac884deb3f7dc1f6b3d02d3`. **Related gap:** evidence-backed governed recovery, no-loss coordination, System-Two specialization, reliable propagation, and Director B7 Ground. **Handoff:** none newly promoted; current DT novelty unverified.
