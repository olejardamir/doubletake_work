# No-hardware DoubleTake critical-path runbook

The four existing scheduled GPT workers continue reasoning, research, patch design and validation planning. The local DT checkout does not need a stronger model for routine patch application: `tools/doubletake_evolve/patch_execution/bpe_queue_runner.py` deterministically checks patch identity, dependencies and source state and executes **one** exact, trusted, locally reviewed script. It does not infer authorization from publication. It does not commit, push, alter retained history or deploy. [Private DT usage and tests](https://github.com/olejardamir/DT/blob/main/tools/doubletake_evolve/patch_execution/BPE_QUEUE_RUNNER.md).

## Checkpoint A — actual local runner acceptance (OPEN)

Run `python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py` on the existing authorized host. Record real test logs and source SHA. Then select and review one truly new source-compatible BPE patch with `patch_blob_sha`; verify its local positive/negative tests and commit only intended source with the existing authorized process. Current runner code is committed, tests unobserved. No patch must be replayed merely because a stale index says prepared.

## Checkpoint B — B1 historical integrity owner disposition (OPEN / BLOCKED_AUTHORITY)

Existing source observations show fail-closed historical integrity refusal and no fully completed natural autonomous cycles. The retained-history owner must identify an already permissible, audited **non-destructive** decision, or explicitly deny all alternatives. Before that, only source review and temporary-copy test evidence is allowed. No manual re-seal, bypass, deletion, live record rewrite or rollback over accepted work. On an authorized disposition, independently verify no-loss, tamper-negative, restart and unchanged-other-work, followed by a new version-bound 60-minute natural schedule with multiple full completions. Do not repeat identical failed windows while decision is pending.

## Checkpoint C — real mission consumer and learning effect (OPEN / EVIDENCE_UNAVAILABLE)

Verify the actual canonical DT reader (not a new standalone downloader) consumes public `ACTIVE_MISSION.md` revision A and later B. Bind **published SHA → consumer-read SHA → permitted action/run ID → output → independent assessment → later reuse**. Negative controls: B published but unread, stale A read, forged receipt, denied request, same-B old receipt replay, delayed read. Only if a reproducible missing seam exists may the existing owner add the minimum in-place evidence. No parallel Borg controller and no fabricated source.

## Other existing gates

Production fault-to-repair caller, release of the served UI, shared-state write ownership and long-term durable capacity remain governed by their existing external owners; a successful isolated test does not authorize live state changes.

## Metrics

Track real fully completed autonomous cycles, independently validated actual mission reads and changes in behavior, no-loss durable progress, approved repair outcomes, and first-pass BPE success. **58 work orders is planning coverage; source commits are not runtime Ground.** Keep every worker enabled and continue independent eligible work around blocked branches.
