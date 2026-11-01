# Patch engineering learning — durable evidence and adaptation

Authoritative rules: [WORKER_RULES.md](WORKER_RULES.md). This is a compact **learning log**, not an additional patch, mission, or source-of-truth index. Only public-safe lessons and sanitized observations belong here.

## Baseline (2026-11-01)

- Patch artifact format: **one self-contained, source-bound `.sh` per patch**, embedding real `git apply` diff, preflight checks, focused tests and DoD comments.
- Locally executable patches visible when this log was started: `BPE-20261101-003` through `BPE-20261101-007`.
- Current observation: **no execution-result JSON files have been observed** in `results/`. Their actual apply/test/integration/push success is **UNKNOWN**, not zero or passing.
- Baseline authoring strategy version: `single-file-v1`.
- Desired outcome: first-try valid integration and behavior verification with minimal local model reasoning, without weakened tests, permissions or private-source protections.

## Evidence ledger

| Observation | Patch or cohort | Actual stage and result | Source/evidence | Failure category | Reusable lesson |
|---|---|---|---|---|---|
| Baseline | 003–007 | PREPARED_UNTESTED; no observed executor feedback | PATCH_INDEX.json; results/ directory | Unknown/not executed | Do not infer patch quality from code generation or number published |

## Strategy revisions

| Revision | Prior → proposed method | Testable hypothesis | Measurement & verification | Revert if |
|---|---|---|---|---|
| single-file-v1 (baseline) | Three-file packages → one `.sh` containing diff, steps and DoD | Fewer cross-file references reduce local interpretation and omissions | Compare actual local apply/test reports; first-try pass, intervention count, rework and verified push rate when feedback exists | Demonstrated regressions in reliability or evidence quality |
| learning-v1 (2026-11-01) | Static patch authoring → evidence-based feedback loop in WORKER_RULES.md | Diagnosing stage-specific failures and adjusting instructions decreases repeated local errors | New actual results with patch ID/revision, measured error category and follow-up result | Churn or weaker safety/DoD without measured benefit |

## How to update this file each run

Review actual result JSON, fresh DT commits/tests and any patch rewrites. Add only grounded new observations; preserve denominators and unknowns. If a failure is reproducible, record root cause and the precise patch-format change to test; if strategy changes, version it, compare old/new outcomes on subsequent runs, and revert ineffective modifications. Keep under ~200 concise lines; move detailed per-patch evidence into `results/<ID>.json` or the index, without leaking private source or logs. Never invent local test, integration or commit evidence.
