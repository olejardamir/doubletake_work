# TEMP PROMPT — Complete the closure matrix's register-disposition comparison

Status: in progress
Unit: TASK_5_EVIDENCE_CLOSURE_MATRIX (FIC-L1-PLAN-915)
Phase: 2 (strengthen/repair existing behavior)
Repo: /home/glompy/Desktop/OTHER_PROJECTS/DT, branch `main` only

## Why this unit

`docs/governed_agent/evidence_register.md` declares five disposition tokens:
`DEMONSTRATED_SYNTHETIC`, `INFERRED`, `DEFERRED`, `EXTERNALLY_SCOPED`,
`BLOCKED`. `closed_matrix._finish_row` compares only
`DEMONSTRATED_SYNTHETIC`, `DEFERRED` and `EXTERNALLY_SCOPED`; `BLOCKED` and
`INFERRED` fall through to `register_agrees = None`. The committed matrix
therefore prints `register_agrees: null` for G25 even though the register says
`BLOCKED` and the matrix says `PARTIAL`.

FIC-L1-PLAN-915 requires: "The matrix compares its independent result with the
WP15 evidence register's dispositions and records disagreements." A token that
is never compared leaves that requirement incomplete. The defect is not a gate
weakening: it makes the comparison stricter, and it changes no row status.

## Bounded steps

1. In `tools/doubletake_evolve/governed_ingestion/closure_matrix.py`,
   `_finish_row`:
   - treat `BLOCKED` and `INFERRED` explicitly as non-pass register claims:
     they agree only with a non-pass matrix status
     (`DEFERRED`, `PARTIAL`, `MISSING_EVIDENCE`), following the existing
     `DEFERRED` rule;
   - keep `None` as "no disposition supplied" (unchanged);
   - treat any other non-`None` token as a recorded disagreement:
     `register_agrees = False` and reason
     `register_disposition_unknown:<token>`, so it cannot be silently skipped;
   - keep the existing `register_disposition_disagrees:<token>` reason for
     known-token disagreements.
   - Add a short comment naming the declared vocabulary and why it must stay
     complete.
2. In `tools/doubletake_evolve/governed_ingestion/tests/test_closure_matrix.py`
   add focused tests:
   - `_finish_row` maps `BLOCKED` + `PARTIAL` → True and `BLOCKED` + `PASS` →
     False with the disagreement reason;
   - `INFERRED` is compared, not `None`;
   - an unknown token is `False` with `register_disposition_unknown:<token>`;
   - the committed matrix's G25 row has a non-`None` `register_agrees` and
     `register_disposition == "BLOCKED"`.
3. Run the focused matrix suite and the matrix generator's `--verify` through
   `tools/doubletake_evolve/runtime/host_workload.py --profile experiment`.
4. Commit code + tests first (record must bind a clean head).
5. Regenerate `reports/governed_ingestion/closure/05_closure_matrix.json` and
   `.md` with `closure_matrix.py --generate`, then `--verify`; commit.
6. Regenerate the dependent acceptance records with
   `closure_acceptance.py --generate`, then the checkpoint with
   `mission_state.py` (bare run writes; verify with `--verify --no-recheck`
   then the full `--verify` if the guard allows); commit each step.

## Done when

- `BLOCKED`/`INFERRED` are compared; unknown tokens are recorded;
- G25's committed row carries `register_agrees: true` (not `null`);
- no row status, decision, blocker list or digest-exclusion changes except the
  G25 comparison field and the records' own digests/heads;
- acceptance remains `AWAITING_AUTHORIZED_ACCEPTANCE` and the checkpoint still
  names WP0c revalidation plus the G6/G25 blockers;
- the temporary prompt file is deleted.

## Stop conditions

- Another agent is running a guarded workload against this tree: do not edit
  until it exits.
- The focused suite or `--verify` fails for a reason other than the intended
  comparison change: stop and record the exact failure.
- A row status, decision or blocker changes beyond the G25 comparison field:
  revert and record why.
- The host guard refuses the workload: report the refusal, do not bypass it.

## Rollback

Restore `_finish_row`, remove the new tests, regenerate the matrix, acceptance
and checkpoint records from their owning generators, and delete this file.
