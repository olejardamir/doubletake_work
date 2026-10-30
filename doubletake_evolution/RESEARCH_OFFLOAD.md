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
- **Unknowns:** Baseline comparability, workload variance, test cost, already-present benchmark owners.
- **Promotion evidence:** Identification of a missing testable measurement, an existing owner to extend, and stable representative fixtures.

No third-party library or additional governance layer is recommended by these hypotheses alone.
