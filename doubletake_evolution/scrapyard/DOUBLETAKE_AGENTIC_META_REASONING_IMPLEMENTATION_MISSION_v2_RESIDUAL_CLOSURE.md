# DoubleTake Agentic Meta-Reasoning Implementation Mission
## v2 — residual closure / evidence-driven edition

**Current local `main` at execution time is authoritative.**
Re-inspect and re-measure before acting. Do not trust historical counts, statuses, diagnoses, or test totals if current `main` disagrees.

# MISSION

Finish the governed agentic meta-reasoning control layer already integrated into DoubleTake.

This is **not** a standalone subsystem and must not become one.

The meta-reasoning layer must remain a governed System-Two/control layer that:
- observes the canonical DoubleTake task/run state;
- proposes bounded changes or actions;
- evaluates and selects them under existing governance;
- dispatches only through canonical execution paths;
- persists truthful state/evidence;
- survives restart/concurrency/failure safely;
- cannot bypass Borg/Collective authority, capability governance, resource limits, scope, verification, rollback, or submission rules;
- demonstrates measurable value against DIRECT execution under matched conditions.

Do not redesign the whole architecture. Close the remaining measured gaps.

# AUTHORITATIVE CLOSURE TABLE

The authoritative convergence table is:

`tools/doubletake_evolve/meta_reasoning/tests/test_meta_convergence_table.py`

At the time this prompt was reduced, current `main` contained:

- 48 criteria total: MR-A through MR-AV
- 23 PASS
- 25 OPEN
- `test_no_criterion_is_open` intentionally red

PASS at reduction time:

`MR-A, MR-B, MR-D, MR-E, MR-G, MR-H, MR-I, MR-K, MR-L, MR-M, MR-N, MR-S, MR-T, MR-W, MR-AB, MR-AE, MR-AF, MR-AH, MR-AJ, MR-AL, MR-AQ, MR-AR, MR-AS`

OPEN at reduction time:

`MR-C, MR-F, MR-J, MR-O, MR-P, MR-Q, MR-R, MR-U, MR-V, MR-X, MR-Y, MR-Z, MR-AA, MR-AC, MR-AD, MR-AG, MR-AI, MR-AK, MR-AM, MR-AN, MR-AO, MR-AP, MR-AT, MR-AU, MR-AV`

These are a starting hypothesis only. Re-read the table from current `main`.

If a previously PASS criterion has genuinely regressed, repair it.
Otherwise treat PASS criteria as regression guards and do not spend iterations re-implementing them.

# CURRENT RESIDUAL GAP MAP

Re-derive this from current `main`, but use it to avoid repeating already-solved work.

## A. Missing or incomplete runtime mechanisms

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

### MR-F — Bounded state
Compact-state bounds are proven only against the store directly.
Drive a long real governed run and prove bounded state while preserving blockers/citations.

### MR-O — Capability participation integration
The capability reevaluation path is wired.
Certify it through the production meta path.

### MR-P — Dynamic capability reevaluation
Certify that a previously unused capability can become relevant later in a real run and that duplicate/cycle controls survive reentry.

### MR-Q — Governance preservation
Prove an over-authorizing meta-selected action is refused by canonical governance and the meta-controller cannot override the refusal.

### MR-R — STOP selects existing artifact
Finish production-path proof that STOP can only select a genuinely existing, eligible, verified artifact and cannot fabricate or silently substitute one.

### MR-U — Crash / resume
Exercise the named interruption points through the real cycle:
- after controller compute but before durable stage commit;
- after durable dispatch preparation;
- after effect completion before aggregation.
Prove no duplicate stage commit, duplicate mutation, or fabricated certainty.

### MR-V — Observability consistency
The report is now production-written.
Close any remaining cross-check between run report, cycle outcomes, ledger, lineage, stop state, and durable artifacts so contradictory telemetry cannot pass.

### MR-Y — Extensibility
Register a new worker/capability/artifact/action kind through the normal extension seam and prove no central meta-control name-specific edit is required.

### MR-Z — Adversarial non-vacuity
Complete the remaining required perturbations through the real path, including the rows still relying on component/helper evidence.

### MR-AA — System-Two authority boundary
Finish executable provider-authority proof and mutation evidence showing meta-reasoning cannot become a routine Borg/Collective owner or silently seize provider authority.

### MR-AC — Structured stage contracts / tool authority
Finish the remaining named adversarial stage-contract cases on the real production cycle. Do not merely expand parsers; fail closed on untrusted stage output.

### MR-AD — Run artifact isolation
Prove a governed run's artifacts cannot leak into global/cross-project collective memory or learning state unless an explicit governed promotion path permits it.

### MR-AI — Submission eligibility
Finish the remaining production-path eligibility/role/verification proof so the meta layer cannot promote control notes or unverified artifacts into submission-eligible outputs.

### MR-AK — User-interaction block
Certify that waiting-on-user state cannot be fabricated by the controller, no response is invented, and resume continues from durable state once the interaction genuinely resolves.

### MR-AM — Loop termination / no-progress
Drive repeated no-progress/duplicate cycles and prove bounded truthful termination rather than endless self-reflection or cosmetic churn.

### MR-AN — Pause / cancel / emergency control
Certify cancel/pause propagation, prevention of new work after cancellation, handling of in-flight work, and restart/resume without replaying completed effects.

### MR-AO — Mid-run task revision
Drive a real steering/revision event.
Invalidate stale decisions, reassess under the new revision, and prove steering text does not silently expand scope.

### MR-AP — Objective / scope non-drift
Drive a long multi-cycle run containing an off-objective proposal and prove it is refused/excluded before execution.

### MR-AT — Deadline / timeout propagation
Use a provider/action that does not return and prove one canonical deadline budget propagates through retry/recovery without granting a fresh full deadline.

### MR-AU — Committed delta cursor / out-of-order results
Drive real parallel workers that complete in reverse order and prove the durable cursor remains gap-safe across restart.

### MR-AV — Single meta transition / optimistic concurrency
Drive two real supported triggers concurrently against one run.
Prove exactly one transition wins, the loser records a durable conflict/requeue event, and the next Assess reconsiders it.

## C. Required comparison / mission-level closure mechanism

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

# LOOP

Repeat until convergence:

1. Inspect current `main`.

2. Read the entire authoritative MR-A–MR-AV table.

3. Run the meta-reasoning convergence suite.

4. Build the exact current OPEN set.

5. For every OPEN row, classify the blocker as one of:
   - missing mechanism;
   - mechanism wired but no production certifier;
   - helper/component evidence only;
   - partial criterion with one missing half;
   - stale/incorrect evidence;
   - matched-comparison/mission-level evidence gap.

6. Select the single highest-value coherent delta that can close one criterion or a tightly coupled cluster without weakening already-proven invariants.

7. Trace the real path before editing:
   ingress/trigger
   → canonical task/run state
   → Assess
   → Propose
   → Evaluate
   → selection/budget/governance
   → durable dispatch intent
   → worker/effect
   → aggregation
   → artifact/verification
   → stop/recovery
   → evidence/report.

8. Implement the smallest general runtime repair.

9. Add production-driving executable evidence.

10. Add non-vacuity evidence:
    perturb the exact mechanism you added or repaired and prove the relevant test turns red.

11. Run the focused criterion tests.

12. Run the whole meta-reasoning convergence suite.

13. Re-read the authoritative table from disk after tests.
    Do not infer closure from commit messages.

14. If a PASS criterion regressed, repair the regression before proceeding.

15. Update criterion status only when its full semantic claim is proven.

16. Rebuild the OPEN set.

17. Repeat until no OPEN criterion remains.

# IMPLEMENTATION PRIORITIES

Prefer this order unless current evidence shows a dependency inversion:

1. Close missing mechanisms that block multiple downstream criteria:
   - MR-C DIRECT-history production;
   - MR-J conflict/compatibility;
   - MR-AG transactional completion/reconciliation.

2. Close production-path safety/liveness gaps:
   - MR-U crash/resume;
   - MR-AT deadlines;
   - MR-AV concurrency;
   - MR-AU out-of-order completion;
   - MR-AN cancel/pause;
   - MR-AO steering/revision.

3. Close governance/scope/isolation gaps:
   - MR-Q;
   - MR-AA;
   - MR-AD;
   - MR-AI;
   - MR-AP;
   - MR-AK.

4. Close integration/extensibility/state gaps:
   - MR-F;
   - MR-O;
   - MR-P;
   - MR-Y;
   - MR-AM.

5. Complete remaining stage/STOP/observability/adversarial evidence:
   - MR-R;
   - MR-V;
   - MR-Z;
   - MR-AC.

6. Wire and execute MR-X matched DIRECT-vs-META evidence.

Do not follow this order mechanically when a current dependency graph proves another sequence is better.

# HARD RULES

- Work on authoritative current `main`.
- Meta-reasoning is integrated DoubleTake control infrastructure, not a parallel agent framework.
- Preserve Borg/Collective ownership boundaries.
- Preserve capability-participation architecture.
- Preserve canonical inference/provider authority.
- Preserve deterministic governance and authorization.
- Preserve truthful resource accounting.
- Preserve fail-closed behavior for missing/unmeasurable authority, cost, verification, or stage output.
- Preserve durable evidence and restart semantics.
- Preserve task objective and revision authority.
- Do not let the controller declare its own permissions.
- Do not let the controller fabricate user input.
- Do not let a model reply become authority merely because it parses.
- Do not let a worker self-promote an artifact or role.
- Do not let STOP invent an artifact.
- Do not let retries reset total deadlines or resource ceilings.
- Do not let concurrency silently overwrite durable state.
- Do not add giant static action-name or capability-name routing tables.
- Do not hard-code the current worker/capability inventory when a registry/contract mechanism can generalize.
- Do not replace missing runtime behavior with documentation.
- Do not close a criterion because a helper test passes.
- Do not close a criterion because a fixture can call an otherwise unreachable function.
- Do not close a criterion by deleting or weakening its adversarial case.
- Do not count an explanatory waiver as closure.
- Do not create cosmetic commits when no justified implementation/test delta exists.
- Commit substantive progress.

# PRODUCTION EVIDENCE STANDARD

A behavioural criterion counts as closed only when evidence can trace:

requirement
→ actual supported ingress/trigger
→ canonical production path
→ changed runtime behavior
→ durable/observable result
→ adversarial or perturbation evidence.

Component tests may support the proof but cannot replace production-path proof where the criterion is behavioural.

A test is not sufficient if it:
- invokes only the helper under test;
- constructs impossible state;
- bypasses canonical governance;
- relies on a synthetic shortcut that production cannot reach;
- checks only presence rather than causal effect;
- would remain green if the claimed production wiring were removed.

# MATCHED DIRECT-vs-META ACCEPTANCE

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

# ADVERSARIAL FINAL PASS

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

# STOP CONDITION

Stop only when all of the following are true on current `main`:

1. all 48 MR-A–MR-AV criteria are PASS for their actual semantic requirements;
2. `test_no_criterion_is_open` passes for the right reason;
3. no PASS status is supported only by helper/component/test-only reachability where production behavior is claimed;
4. every mechanism added during closure has executable non-vacuity/perturbation evidence appropriate to its risk;
5. crash/restart/concurrency/deadline/cancel/steering paths are durably truthful;
6. governance, Borg authority, capability authority, scope, isolation, verification, submission eligibility, and resource ceilings remain intact;
7. MR-X matched DIRECT-vs-META evidence executes under matched resources and records both benefit and overhead honestly;
8. a fresh adversarial pass finds no material remaining meta-reasoning gap;
9. a fresh full-suite run remains green;
10. another full inspection of current `main` produces no justified implementation or evidence delta.

Then report:

`AGENTIC_META_REASONING_CONVERGED`

and cite the exact executable evidence and matched-comparison result.

Until then, continue the loop.
