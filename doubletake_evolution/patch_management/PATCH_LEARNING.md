# Patch engineering learning — durable evidence and adaptation

Authoritative rules: [WORKER_RULES.md](WORKER_RULES.md). This is a compact **learning log**, not an additional patch, mission, or source-of-truth index. Only public-safe lessons and sanitized observations belong here.

## Baseline (2026-11-01)

- Patch artifact format: **one self-contained, source-bound `.sh` per patch**, embedding real `git apply` diff, preflight checks, focused tests and DoD comments.
- Locally executable patches visible when this log was started: `BPE-20261101-003` through `BPE-20261101-007`.
- Initial baseline observation (before local execution feedback): no result JSON or independent test logs; success UNKNOWN. Subsequent execution observations appear in the ledger below.
- Baseline authoring strategy version: `single-file-v1`.
- Desired outcome: first-try valid integration and behavior verification with minimal local model reasoning, without weakened tests, permissions or private-source protections.

## Evidence ledger

| Observation | Patch or cohort | Actual stage and result | Source/evidence | Failure category | Reusable lesson |
|---|---|---|---|---|---|
| Baseline | 003–007 | PREPARED_UNTESTED; no observed executor feedback | PATCH_INDEX.json; results/ directory | Unknown/not executed | Do not infer patch quality from code generation or number published |
| 2026-11-01 first local report | BPE-20261101-003 | Feature-branch code commit and new test verified; local Clai reported 24/24 guarded tests, logs not yet available | DT `b1931476299f5b0dfa7b7222ce2706df9d11a01e`; `results/BPE-20261101-003.json` | Feedback path mismatch; follow-on scripts source-hash drift | Use one canonical public-safe result location; refresh source bindings after every real patch commit, especially for scripts sharing touched files |

## Strategy revisions

| Revision | Prior → proposed method | Testable hypothesis | Measurement & verification | Revert if |
|---|---|---|---|---|
| single-file-v1 (baseline) | Three-file packages → one `.sh` containing diff, steps and DoD | Fewer cross-file references reduce local interpretation and omissions | Compare actual local apply/test reports; first-try pass, intervention count, rework and verified push rate when feedback exists | Demonstrated regressions in reliability or evidence quality |
| learning-v1 (2026-11-01) | Static patch authoring → evidence-based feedback loop in WORKER_RULES.md | Diagnosing stage-specific failures and adjusting instructions decreases repeated local errors | New actual results with patch ID/revision, measured error category and follow-up result | Churn or weaker safety/DoD without measured benefit |
| source-reconcile-v1 (proposed) | Static source-hash checks for a batch → update remaining patch source bindings after each verified DT commit | Rebase compatible pending patches before the local model runs them to prevent avoidable stale-source stops | Subsequent patch first-try preflight/apply success versus 003 baseline; report actual counts | Conflicts, unsafe overwrites, or no demonstrated improvement |

## How to update this file each run

Review actual result JSON, fresh DT commits/tests and any patch rewrites. Add only grounded new observations; preserve denominators and unknowns. If a failure is reproducible, record root cause and the precise patch-format change to test; if strategy changes, version it, compare old/new outcomes on subsequent runs, and revert ineffective modifications. Keep under ~200 concise lines; move detailed per-patch evidence into `results/<ID>.json` or the index, without leaking private source or logs. Never invent local test, integration or commit evidence.


## 2026-11-01 — source-disclosure safety stop and pending-queue reconciliation

- **Observed authority conflict:** The current public `ACTIVE_MISSION.md` (blob `aaafac5be79b7ea46fdea19c1be762e14d22b66e`, 7.9 next action) expressly halts future public publication of private DT source-bearing diffs. Earlier patch rules encouraged public single-file diffs, but that does not override the newer mission safety stop. **Action:** no new/revised code-bearing public patches; mark BPE-20261101-004–007 `BLOCKED_PRIVATE_CONTENT`. Keep prior source-bearing scripts unchanged rather than republishing private code. Do not interpret prior public exposure as clearance.
- **Independent source check:** DT feature branch remains at `b1931476299f5b0dfa7b7222ce2706df9d11a01e`. One sanitized result for BPE-003 confirms the commit but still lacks independently observed guarded test logs. No results for 004–007. **No new verified applications**.
- **Specific pending failure identified before local execution:** 004, 006 and 007 all require the same exact pre-change source blob while touching one shared file. A deterministic in-memory hunk-match simulation of the existing publicly available patch texts against the confirmed private branch found each hunk uniquely matchable in order 004→006→007, but the exact hash preflight for 006 and 007 would reject after preceding integration. This is a **predictive preflight conflict, not an observed local failure**. Recorded dependency order 006→004 and 007→006 in the index; do not rebase or republish scripts while disclosure is prohibited.
- **Falsifiable future improvement (authorization required):** Once the owner permits a safe, non-confidential patch delivery mechanism, regenerate each dependent script against the actual committed predecessor blob, preserving full tests and negative controls. Measure first-try preflight and test pass rate on the authorized executor, and compare with the old known source-hash conflict. Revert if it introduces unsafe context matches, reduced coverage or ambiguous provenance. Until authorized, this experiment is `BLOCKED`, not `SUCCESS`.
- **Public artifact boundary:** Public index, mission map and generic learning may be updated without disclosing additional private implementation content. Private patches 001–002 must stay private. Any request to resume code-bearing public publication needs explicit disclosure authorization and re-inspection of exact contents.

## 2026-11-01 feature-branch reconciliation (observed source, reported tests)

At DT `feature/alphacode-provider` HEAD `9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb`, four previously blocked/stale scripts 004–007 were found already implemented. Exact commit IDs and their new test files were inspected; local executor staging records report guarded tests 23, 24, 23, 23 passed respectively. **Independently rerun tests: 0/4; test logs: unavailable.** The earlier `BLOCKED` statuses were false readiness signals caused by relying on an outdated branch baseline, not evidence of patch failure. Never rebase/reapply a patch until checking recent feature-branch commits and target test files. Hypothesis: branch-head-first reconciliation will reduce redundant executor attempts; metric: redundant attempts among next 5 local selections (target 0), revert only if this check prevents legitimate work. No claims of completed Ground.

## 2026-11-01 authoring check — BPE-010/011

Fresh branch source review found two separable fail-open claim-receipt conditions: chain links are checked as any prior seen digest and overall success ignores chain validity; externally supplied terminal receipt digest is accepted without recomputation. Split into independent `receipts.py` and `models.py` patches to avoid source-hash collisions. Source hunks matched the inspected blobs uniquely. **Hypothesis:** separate files plus exact blob preflight yield two conflict-free first-try executions; measure `git apply --check` and guarded test outcomes from actual executor feedback. Revert/revise if regression tests or real consumers show incompatible canonical semantics. No apply or test execution was observed in this run.

- BPE-012: found a separate CLI automation failure mode: unsuccessful verification still exits zero. Hypothesis: nonzero failure exit prevents downstream shell/CI consumers from treating invalid proof as success; measure first-try local apply, new negative and positive tests, and downstream compatibility. Revert if existing CLI contract explicitly requires success exit for failed verification; no such contract was observed in the inspected CLI.
