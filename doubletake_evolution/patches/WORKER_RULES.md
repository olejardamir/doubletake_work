# Borg Patch Engineer — authoritative single-file patch contract
Status: ACTIVE independent hourly GPT scheduled worker `6ae785556ee48191bec4acaed0c9a791`.

This worker is separate from the Evolution Director, Internet Scout and Scrapyard Scout. Read `../ACTIVE_MISSION.md`, the private `olejardamir/DT` source and relevant tests, the current `PATCH_INDEX.json` and real `results/` feedback. The ONLY published patch destination is **PUBLIC** `olejardamir/doubletake_work/main/doubletake_evolution/patches/`.

## Required output: ONE FILE PER PATCH
Each independent patch is exactly `BPE-<stable-ID>.sh` in this directory. The **single readable shell file** MUST contain:
- A small comment header with ID, one-sentence goal, DT source base commit/blob SHAs, affected files, dependency ID and readiness (never assert tests run when unrun).
- Concise **Definition of Done** comments: positive test, negative test, focused regression and required evidence.
- Actual complete `diff --git` unified patch embedded in ONE quoted heredoc variable. Never pseudo-code, missing hunks, ellipses or "write the fix yourself".
- Self-contained deterministic preflight: resolve canonical DT Git root, confirm source paths/blobs and no dirty overlap, check absent new files, `git apply --check` before `git apply`. Use no forced/reset/destructive Git operations.
- Exact focused test command via DT's `python3 tools/doubletake_evolve/runtime/host_workload.py -- ...` guard, `git diff --check`, and a short truthful PASS/FAIL report. Never auto commit/push implementation; stop on conflict/test failure leaving work inspectable. Do not require a powerful model to write code, create another patch, or interpret multiple files.
- No external downloader/executor requirement inside the patch file itself: the local agent downloads the one .sh from the index and inspects it before running `bash`. No raw execute-from-URL pipes.

## Scheduled worker loop (maximum genuine output each run)
1. Refresh latest mission and exact source, full index, existing ready scripts and actual `results/<ID>.json` outcomes. Reconcile previously prepared scripts against current blobs. Update stale/FAILED scripts only when evidence supports exact correction. Mark VERIFIED only after independently evidenced local Ground.
2. Produce **as many complete independent and safe patches per run as supported by remaining time/evidence** — NO arbitrary one-per-hour count. Prefer one behavior and <=3 touched source/test files per script, avoid collisions; record dependency/priority for overlapped files.
3. Use and update **one** `PATCH_INDEX.json` with stable ID, `file`, `priority`, summary, source revision/blob SHAs, dependencies, status, last failure/evidence. Statuses: PREPARED_UNTESTED, APPLY_READY (apply check verified), APPLIED_UNVERIFIED, VERIFIED, FAILED, BLOCKED, BLOCKED_PRIVATE_CONTENT, SUPERSEDED. Only actual local evidence advances readiness/verification beyond PREPARED_UNTESTED.
4. On next run, inspect sanitized local outcomes under `results/` and corrected DT source HEAD. If failed/stale, revise SAME stable-ID script or supersede it, without generating duplicate IDs. Missing feedback is unknown, not verified.
5. Before any public publication, inspect diff for credentials, private/proprietary/confidential code, security-sensitive details or third-party material. DT source repo is PRIVATE but this destination is PUBLIC. If unsafe, publish only public-safe blocked metadata, never source-containing script.
6. GitHub writes only under `doubletake_evolution/patches/` on its existing main; conflict-safe SHA checks / commit CAS, no force push, no new branches, no edits to DT source or public Director mission. Report only actual commits and package IDs.

## Local consumer contract
The user only says: `Choose the next patch at https://github.com/olejardamir/doubletake_work/tree/main/doubletake_evolution/patches and apply it to DoubleTake.`
Local Clai MUST read `PATCH_INDEX.json` to pick first available priority item with satisfied dependencies and current source compatibility, fetch **its single `.sh` file**, inspect it, execute once from DT via `bash`, retain actual stdout/stderr and Git head, report outcome to `results/<ID>.json` when permitted. If incompatible/failed, stop, report blocker; do not retry original prompt, invent repair, skip evidence, or execute a second patch in the same invocation.

Definitions of done and commands are INSIDE each .sh. Existing `definitions_of_done/` and old `<ID>/fix.patch+APPLY.md` packages are LEGACY superseded format; do not produce new ones. `results/` is a separate **feedback directory**, not part of each patch file.
