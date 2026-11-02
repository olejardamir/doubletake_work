# IS-20261102-022 — committed-consumer-aware rollback admissibility (source-corrected)

**Provenance:** Internet Scout intake, original blob `07ddc17ddb10fbf35befe8abb5bf61642730d285` (full prior note recoverable through Git history); reviewed 2026-11-02. **Disposition:** KEEP / VALIDATED_CONCEPT / REPRODUCTION_UNVERIFIED / CONDITIONAL_DIRECTOR_REVIEW. This is research data, never a DT execution instruction or authority grant.

## Primary source and crucial attribution correction

- Yang et al., *DART: Semantic Recoverability for Structured Tool Agents*, preprint 2026-05-22, https://arxiv.org/abs/2605.23311 . The abstract independently confirms that controller-legal local rollback can invalidate already-committed downstream work, and proposes dependency/effect-aware checkpoint admissibility. Preprint results are author-reported; no DT reproduction.
- **Important correction:** The intake identified https://github.com/KeoYang/DART as the paper's code. Its **actual README** instead titles the project **“DART — Deterministic Agent Runtime with Transition-guards”** and describes cloud/edge deterministic FSM governance. Its 72-path tree has generic `runtime/recovery.py`, but no apparent paper-specific semantic-recoverability benchmark/audit scripts. The README/title mismatch makes **paper↔repository correspondence UNVERIFIED**. Do **not** cite this repository as the paper's reproducible artifact, import it as such, or infer misconduct. The repository's MIT LICENSE applies to that repository, **not automatically to the paper or any absent benchmark assets**. Verify authors' actual paper artifact link and independent code availability before any reproduction claim.
- Adjacent but distinct: Li et al., *Pilot Execution*, NSDI 2026, https://www.usenix.org/conference/nsdi26/presentation/li-zhenyu (author-reported preflight recovery-failure detection in distributed systems); not a DT-safe recovery implementation.

## Atomic mechanism, limits and novelty hypothesis

**Claim:** A checkpoint can be structurally restorable yet semantically inadmissible when a downstream consumer has committed a dependent result or an irreversible effect was crossed. A conservative classifier should require exact failed-instance/re-entry identity, certified boundary, read/write dependency edges and effect policy; missing/ambiguous data **vetoes local rollback**, not the entire safe workflow. Whole-task replay is not automatically safe for external side effects.

**Limits:** Original intake reports a five-domain paper audit (35 admissions, 12 blocks, zero observed unsafe admissions/false blocks); the exact table denominators and audit method were **not independently reproduced**. It is a small author-defined evaluation, not proof of arbitrary distributed consistency. No DT authority, history disposition, scheduler-to-local consumption, or autonomous cycle is supplied.

**Distinct from:** IS-001 event-history compatibility; IS-010 acknowledged-write oracle; IS-011 ambiguous acknowledgements; IS-017 termination semantics. This candidate tests a *proposed restore decision after downstream commitment*. Private DT's documented synthetic file-rollback proofs do not expressly establish this cross-consumer semantic property; exhaustive current implementation/test parity and a permitted fixture remain UNKNOWN. Never claim a live DT defect from that absence.

## Small falsifiable DT-compatible research gate (no automatic implementation)

**OUTWARD:** Owner locates an already-authorized, disposable, version-pinned rollback decision fixture, or returns `NO_AUTHORIZED_FIXTURE`. Freeze owner contract, existing baseline and 24 independent synthetic dependency/effect traces (8 independent safe restores; 8 committed dependent consumers; 4 irreversible effects; 4 unknown/missing contracts), plus replayed receipt, wrong instance ordinal and omitted dependency-edge negatives. Keep protected history untouched.

**INWARD (Director/owner approval only):** Compare existing DT evaluator with a trivial conservative never-rollback baseline and a read-only dependency/effect veto on identical traces. No new controller, network side effect, state rewrite or third-party code import. If existing DT already refuses all unsafe cases, record `ALREADY_PRESENT/NO_DELTA`.

**GROUND threshold:** Independent observer on held-out traces **and one authorized real decision seam** shows zero unsafe admissions, zero lost downstream commitments, correct instance identity and no new false blocks against the applicable owner contract, with bounded cost; a previously false-safe baseline decision must be corrected. Fixture-only success is not DT Ground. Full-Borg acceptance additionally needs genuine source→consumer receipt→governed changed behavior→independent observation→later reuse; **not observed**. B1 owner integrity decision remains separate.

**Handoff:** `R-BORG-SCOUT-20261102-022`, conditional proposal for Director. Priority LOW until owner-approved fixture, code provenance and current-DT parity are established. **Internet Scout feedback:** resolve paper-to-code identity first; seek actual current DT decision/fixture evidence, not additional generic recovery notes.
