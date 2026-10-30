# DoubleTake — Research Offload

These are **hypotheses for later assessment**, not executable implementation requests. Promote only after current-repository evidence establishes a real gap and a measurable improvement.

## R-001 — Low-disruption proof of deployed runtime version
- **Question:** Can the active process expose a trustworthy loaded-version/capability receipt without restarting another agent's active session?
- **Potential value:** Distinguishes code committed to Git from code actually running.
- **Unknowns:** Whether existing runtime endpoints already solve this; safety of deployment observation; durability and tamper resistance.
- **Promotion evidence:** Demonstrated insufficiency of existing checks, design using existing facilities, and a controlled before/after test.

## R-002 — Efficient ongoing autonomy-performance comparisons
- **Question:** Can the current benchmark suite retain a small matched baseline so future autonomy improvements can be measured reproducibly rather than inferred from successful tests?
- **Potential value:** Quantifies latency, interventions, retry churn and recoverability.
- **Existing evidence:** A recent, separate-subsystem comparison demonstrates an established measurement method and explicitly reported regressions; this does not satisfy the autonomy comparison in the active mission.
- **Unknowns:** Baseline comparability for autonomy workloads, workload variance, test cost, already-present benchmark owners.
- **Promotion evidence:** Identification of a missing testable measurement, an existing owner to extend, and stable representative fixtures.

## R-003 — Investigate measured per-request verification overhead
- **Question:** Are measured verification/dispatch overheads on a frequently executed user-facing path, or are they acceptable costs on infrequent transitions?
- **Potential value:** Avoid unnecessary latency while retaining correctness and verification.
- **Existing evidence:** A refreshed benchmark in another subsystem reports several explicitly scoped regressions, even though its evidence-generation acceptance checks pass. That is not itself proof of an unacceptable end-to-end regression.
- **Unknowns:** Real call frequency, representative end-to-end workload, existing caching/reuse options, correctness impact of any optimization.
- **Promotion evidence:** Measured impact on a relevant hot path, a feasible bounded optimization, and tests proving retained correctness and reduced latency.

No third-party library or additional governance layer is recommended by these hypotheses alone.
