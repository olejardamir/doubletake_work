# Historical temporary closure-matrix register comparison — distilled 2026-11-01

**Original blob:** `cd5656a8d7e381cd685beab8893672005145d752` (recover full instructions from Git history). **Original context:** `TASK_5_EVIDENCE_CLOSURE_MATRIX / FIC-L1-PLAN-915`, DT `main`, historical local path `tools/doubletake_evolve/governed_ingestion/closure_matrix.py`. The source claimed status *in progress*, **not** verified complete or applicable to current private DT. Treat as archived defect/test case, not a runnable mission.

## Specific failure and proposed invariant

Evidence register vocabulary: `DEMONSTRATED_SYNTHETIC`, `INFERRED`, `DEFERRED`, `EXTERNALLY_SCOPED`, `BLOCKED`. Historical `closed_matrix._finish_row` reportedly compared only the first, third and fourth tokens, so `BLOCKED` and `INFERRED` produced `register_agrees: null`; G25 had register `BLOCKED` versus matrix `PARTIAL`. Requirement: independent matrix and WP15 register must compare dispositions, **without weakening any gate or changing row statuses**.

Proposed comparison semantics: `BLOCKED`/`INFERRED` agree only with non-PASS `DEFERRED`, `PARTIAL` or `MISSING_EVIDENCE` (like `DEFERRED`); known mismatches yield `False` plus `register_disposition_disagrees:<token>`; any unknown non-null token yields `False` plus `register_disposition_unknown:<token>`; absent disposition stays `None`.

## Reproduction / negative controls (authorized environment only)

- `BLOCKED + PARTIAL → True`; `BLOCKED + PASS → False` with reason; `INFERRED` never silently `None`; unknown token → False with reason.
- G25 output should be `register_disposition=BLOCKED`, `register_agrees=true`, while preserving G6/G25 blockers and `AWAITING_AUTHORIZED_ACCEPTANCE`.
- Check focused `test_closure_matrix.py`, guarded `closure_matrix.py --verify`, regenerated matrix JSON/MD, acceptance and mission-state checkpoint, preserving generator-bound digests and clean revision identity. Verify no other decision/status or digest-exclusion drift.
- Stop on concurrent guarded workload, host guard refusal, unrelated verification failure or altered authority; do not bypass. Roll back code/tests and regenerate only from canonical generators if needed.

**Unknowns:** Current DT code parity, whether this defect was fixed, current G25 record, owner authority and execution evidence. Do not reintroduce old prompt or claim Ground from this archived plan.
