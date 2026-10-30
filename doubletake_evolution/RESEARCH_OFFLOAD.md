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

## R-004 — Diagnose compatibility-safe handling of a historical integrity refusal
- **Question:** Does a persistent historical verification mismatch reflect an old representation/verification compatibility issue, or an actual integrity violation? How can the system distinguish them without weakening tamper detection?
- **Potential value:** Preserve strict integrity enforcement while allowing healthy work to continue where a single historical record is unverifiable.
- **Existing evidence:** A bounded, read-only inspection narrowed recurring refusals to one historical record and found no broad chain corruption. The origin of the mismatch is still unproven; no repair, re-sealing, bypass or retained-state deletion was authorized or performed.
- **Unknowns:** Original write-time format, independent provenance, safe compatibility interpretation, and whether a narrow read-only degraded-state report is preferable to mutation.
- **Promotion evidence:** Reproducible isolated fixture, independently validated provenance and threat-model review, a non-destructive design that fails closed on genuinely tampered data, and focused positive/negative tests. Any state rewrite or integrity-policy change requires its existing authority; do not self-authorize it.

## R-005 — Assess stale registry identity hygiene without unsafe state deletion
- **Question:** Can stale or non-source identities in a durable worker registry be distinguished from legitimate retained history and prevented from repeatedly consuming reconciliation effort?
- **Potential value:** Reduce misleading availability signals and repeated bookkeeping while preserving valid provenance and rollback.
- **Existing evidence:** A recent read-only census found a substantial population of invalid-looking historical entries in one registry, with repeat reconciliation churn. The existing source-scope correction prevents new instances of the observed contamination, but does not clean historical entries. The census does **not** establish this as the cause of the live-cycle timeout, and a separate capability catalogue was not shown to be affected.
- **Unknowns:** Authoritative identity/provenance rules, legitimate retention obligations, safe quarantine semantics, cost of keeping historical entries, and whether any improvement is material after the pending performance corrections are activated.
- **Promotion evidence:** A reproducible synthetic fixture, measured post-activation impact, a non-destructive fail-closed plan, independent positive/negative tests, and existing authorization for any retained-state mutation. No purge, re-seal or self-granted repair is authorized by this research entry.

## R-006 — Bound repeated acquisition work as authorized input roots accumulate
- **Question:** Can a growing collection of individually bounded, authorized discovery roots cause aggregate acquisition to exceed the existing phase budget even when each root is valid?
- **Potential value:** Prevent future autonomous-cycle starvation without losing authorized discoveries or creating new approval machinery.
- **Existing evidence:** Read-only, guarded synthetic measurements found approximately additive per-root discovery cost; a sufficiently large collection can exceed a shared phase budget. The relevant input collection was empty at observation time, so this is a **latent scalability risk**, not a demonstrated current live fault. Discovery-only measurements do not include registration cost.
- **Unknowns:** Representative root arrival rate and content mix, existing deduplication or incremental-scan facilities, cost of registration, and correctness obligations when deferring work.
- **Promotion evidence:** A reproducible representative multi-root fixture including discovery **and** registration; evidence that a realistic authorized workload breaches budget after the currently committed fixes are loaded; a bounded, checkpointable approach using existing state owners; tests for no silent omissions, idempotent resumption, fairness and restart recovery. Do not prune retained manifests, silently drop authorized work or change live state without existing authority.

**Boundary with active work:** A separately verified default-path registration amplification is now actionable as DT-EVO-005, with source-level tests and durability requirements. R-006 remains research-only for the distinct problem of aggregate *discovery across multiple authorized roots* and should not duplicate DT-EVO-005 or imply a current live fault.

## R-007 — Assess durability expectations of legacy capability-registration callers
- **Question:** Do other still-used registration entry points promise durable success while handling failed writes as best-effort, and would tightening them break existing compatibility or unrelated work?
- **Potential value:** Prevent reported capabilities from disappearing after restart outside the newly corrected bounded-acquisition path.
- **Existing evidence:** Current source distinguishes strict conditional/batched admission from legacy registration methods that can ignore persistence failure. A separate environment-discovery caller uses a legacy method, but no representative failed-write production-path test or impact estimate was verified in this inspection.
- **Unknowns:** Caller-specific return contracts, whether consumers treat a returned object/count as durable confirmation, frequency of actual failures, and backward-compatible error signaling.
- **Promotion evidence:** Source-traced reachable caller, temporary-store failed-write fixture reproducing a misleading user-visible result, compatibility impact assessment, and a bounded correction with negative/restart tests. Do not mutate retained state, silently change authority, or conflate this research with the already-verified bounded admission fix.

No third-party library or additional governance layer is recommended by these hypotheses alone.
