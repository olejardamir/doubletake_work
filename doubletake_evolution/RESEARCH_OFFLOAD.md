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
- **Existing evidence:** The conditional, bounded-batch **and bulk** new-entry registration paths now refuse false success on failed persistence; do not reopen these corrected paths without a regression. Other legacy entry points still have best-effort persistence semantics. A separate discovery caller reaches a legacy method, but no representative failed-write production-path test, user-visible impact estimate or compatibility analysis has established that this should become active work.
- **Unknowns:** Caller-specific return contracts, whether consumers treat a returned object/count as durable confirmation, frequency of actual failures, and backward-compatible error signaling.
- **Promotion evidence:** Source-traced reachable caller, temporary-store failed-write fixture reproducing a misleading user-visible result, compatibility impact assessment, and a bounded correction with negative/restart tests. Do not mutate retained state, silently change authority, or conflate this research with the already-verified bounded admission fix.

## R-008 — Define audit-safe retention and recovery for growing durable loop history
- **Question:** What reversible, authority-compliant retention or archival strategy keeps durable history usable over long-running operation without discarding audit fields, counters or integrity evidence?
- **Potential value:** Restore sustainable history capacity instead of merely refusing writes once the loader budget is reached.
- **Existing evidence:** An earlier running generation repeatedly wrote history above the loader limit and then lost previously durable cycles on ordinary reload. The newer source now rejects oversized candidate writes before atomic replacement, preserves the last readable bytes and reports the attempt as non-durable; exact-boundary, restart, isolation and synthetic growth tests are committed and reviewed under completed 6.3.1/6.3.2. **The safety correction is now observed loaded:** a newer supported generation preserved nine durable operating-loop records while refusing five consecutive oversized candidates; no later accepted durable record was evidenced. The prior data-loss mode is prevented for these observed attempts, but the system now remains at a hard durable-progress ceiling. This is a measured operational limitation, not merely a projected capacity risk. Repeated refusal does not establish authorization to prune or migrate retained history. The separate status-route scope correction is now source/test verified under archived 6.4.1/6.4.2, but not observed loaded; it does not solve R-008 retention capacity.
- **Unknowns:** Required audit horizon, preservation of complete prior records, compatibility with existing digests and rollback, authorized archival owner, and acceptable bounded replay cost.
- **Promotion evidence:** First establish the existing audit/retention owner and whether any non-destructive, reversible capacity extension is already permitted; then supply representative worst-case growth/restart measurements, a backward-compatible format/archival design and guarded tests for integrity, complete audit accessibility, counter continuity, crash recovery, no silent loss, bounded load time and safe rollback. If authority is absent, remain research-only and explicitly report durable-progress starvation. Do not purge, truncate or rewrite retained history merely to make a size check pass.

## R-009 — Evaluate consumer semantics of stale versus degraded autonomy status
- **Question:** Does any real consumer incorrectly interpret `degraded=false` as healthy while the authoritative status is stalled/unhealthy, and would additive status semantics avoid that without hiding staleness?
- **Potential value:** Prevent a misleading single-flag interpretation while retaining both heartbeat-staleness and completed-cycle-starvation signals.
- **Existing evidence:** The earlier apparent disagreement between persisted degradation and API recomputation is now **explained by observation timing**, not by lost status: same-generation reads on either side of the heartbeat-age threshold both reported unhealthy. The measured actual tick cadence exceeded the nominal staleness threshold. This completes active reconciliation 3.4.1; it does **not** prove a consumer bug or recovery. A degraded-only consumer could see a false flag while status remains stalled.
- **Unknowns:** Actual consumers of the degraded flag, whether they also check authoritative status/healthy, documented precedence, and backward compatibility of a change.
- **Promotion evidence:** Source-trace a reachable consumer that misclassifies the state; reproduce the error with a same-generation, cadence-controlled fixture; identify the current status owner and a minimal additive correction; pass stale/idle/pause/transient-failure/sustained-starvation/recovery compatibility tests. Do not alter authority, rewrite retained status or claim the loop is healthy.

No third-party library or additional governance layer is recommended by these hypotheses alone.

## R-010 — Recursive Borg discovery and evolution-of-evolution generalization
- **Question:** Do existing discovery miners, knowledge representations, governed assimilation and meta-evaluation propagate validated improvements across all relevant DT components, or do any reachable paths bypass provenance, fail to preserve negative evidence or silently fragment learning?
- **Current evidence:** The authoritative Borg design requires continuous, bounded, provenance-backed discovery and one controlled assimilation path, with independent validation. The bounded source/real-service baseline now demonstrates an existing governed path and concrete cross-component gaps: receipt identity/replay, discovery-only synthesis isolation and non-authoritative provenance classification (all corrected at source/test scope), with authenticated identity/deferral now corrected at source/test scope and cross-component Ground still open. New independent reachability tests demonstrate that the normal discovery inventory does not produce the capability-gap trigger needed to reach the otherwise functioning governed handoff. This is a measurable coverage gap, not evidence of unauthorized execution or global Borg parity. Active DT-EVO-007 / 7.2.5–7.3.1 now qualifies an existing, provenance-backed absence signal before any conditional in-place integration. An inventory of *present* capabilities is not valid evidence of missing capabilities. An explicit/manual-only disposition remains a legitimate negative outcome if no safe producer qualifies; broader recursive generalization stays research-only.
- **Potential value:** Make the improvement process itself more general and reliable across reasoning, planning, memory, tools, execution, governance, verification, recovery and interfaces, without displacing live safety work.
- **Promotion evidence:** Source-traced reachable deficiency, stable positive/negative baseline, independently falsifiable cross-component test, authority-safe in-place integration plan, matched performance and rollback measurements. External mechanisms are research candidates, never authority or code to copy. If no gap is found, preserve the negative finding and leave this as research; do not manufacture changes.
