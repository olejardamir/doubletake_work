# DoubleTake — Enterprise E17 Evidence-Only Final Closure (Offloaded)

**Scope:** Finish the *existing* E17 full-DoubleTake regression certification, including the disk-space failure that prevented evidence generation. Do **not** reopen the enterprise security implementation, rewrite completed controls, or begin the Copilot/Windows port.

**Authoritative repository:** `https://github.com/olejardamir/DT.git`, branch `main`.

**Likely local checkout (discover; do not assume):** `/home/glompy/Desktop/OTHER_PROJECTS/DT`.

**Observed starting point (revalidate at execution):** At remote `main` commit `5797f15dd705b05b27a96ed20be96e47b24179a9` (2026-10-06), source-bound E17 schema **2** and the source-only-change adversarial tests were implemented. However, committed `reports/enterprise/regression_evidence.json` was **schema 1**, `measured=false`, `zero_regressions=true`, with **no** `release_source_digest`. Its prior head measurement exited without a valid JUnit report because pytest encountered `OSError: [Errno 28] No space left on device`. Therefore E17 was **not closed**. This is a snapshot, not permission to assume the same state now.

## Objective and non-negotiables

Complete E17 only if an independently reproducible, honest, *current* regression-evidence record is generated and verified. Preserve all completed E1–E16 enterprise security work, package allowlists, provider exclusions, mock coding-agent supervision, network/process/workspace/memory/logging/self-modification controls, and existing tests. Do not change a security boundary just to obtain a green test, waive failures, or label unmeasured behavior `PROVED`.

Work **on `main`** as required by repo instructions, but do long-running measurements in isolated detached worktrees or other clean snapshots of the chosen `main` commit. Other agents may modify the shared checkout concurrently: never overwrite, reset, rebase, force-push, squash, cherry-pick, or discard another worker's changes. Do not change branches in their working directory. Do not conflate `git cat-file -e` with remote baseline retention. Commit only necessary E17 evidence or tightly scoped fixes and publish by ordinary non-force push after verifying ancestry and concurrency state. Do not alter the original pre-enterprise baseline revision to obtain a favorable result.

Avoid creating another long mission document. Prefer **zero source edits** if the existing implementation is sound and only the evidence must be regenerated.

## Authoritative paths (verify in live tree)

- `tools/doubletake_evolve/enterprise/regression_evidence.py` — E17 generator/verifier; expected `SCHEMA_VERSION = "2"`; CLI `--verify`.
- `reports/enterprise/regression_evidence.json` — authoritative machine-readable output.
- `tools/doubletake_evolve/enterprise/tests/test_regression_evidence.py` — partition, source binding, baseline and adversarial tests.
- `scripts/prove_enterprise_e17_nonvacuity.sh` — 15 non-vacuity scenarios in isolated worktrees; one intentionally redundant `SILENT-OK` scenario, the remainder must fire as specified. Do not treat an unexpected collection error, NOOP, or silence as success.
- `tools/doubletake_evolve/enterprise/review_bundle/probes.py` — E17 reviewer-visible outcome, `PROVED` only for valid measured zero-regression records.
- `tools/doubletake_evolve/tests/enterprise/test_enterprise_acceptance.py` — enterprise acceptance gates.
- `tools/doubletake_evolve/enterprise/review_bundle/builder.py` — review bundle.
- `pytest.ini` — repository-declared suite scope.
- `AGENTS.md`, `ENTERPRISE_USE_NOTICE.md`, `ENTERPRISE_SECURITY_OVERVIEW.md` — conventions and approval boundaries.

The current baseline constant is expected to be `a50bc2c07df8ef6b6bcf996a6f9f5e032703243b`; confirm from the current instrument, validate that it predates enterprise work and is retained by a **published** ref recoverable in a clean clone, and never substitute a different baseline merely to suppress regressions.

## Stage 0 — Reinspect; stop immediately if already closed

1. Record remote/local `main` SHAs, working-tree status, available storage, and changes concurrent agents have made. Fetch safely and establish which commit is genuinely authoritative. Inspect the committed E17 record **as structured data**: schema, measured flag, baseline, head, both digest fields, error messages and regression sets.
2. Inspect the current verifier and tests; do not rely on this prompt's snapshot if code or record moved.
3. On a clean, current snapshot, run the existing **suite-free** E17 verification using the checked-out repository's own interpreter/environment. Default invocation from the repository root is:

   ```bash
   PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise.regression_evidence --verify
   ```

   If namespace resolution differs in the actual checkout, use `PYTHONPATH=.:tools python3 tools/doubletake_evolve/enterprise/regression_evidence.py --verify` rather than modifying imports gratuitously.
4. Also inspect the repository's current E17 outcome in the enterprise review-bundle path. A direct `--verify` exit zero **alone** is not enough if the bundle reports E17 failed/not-proven or if the evidence is not from the current shipping source.
5. If the record verifies, has `measured=true`, schema 2 (or a justified newer schema), no regressions, valid test **and** shipping-source bindings, no relevant unresolved failures, and current evidence already passes the required E17 tests and non-vacuity driver, finish with **NO CHANGES**. Report the exact confirming commands and source/evidence SHA. Otherwise continue only for the exact proven gap.

## Stage 1 — Resolve the disk-space failure safely

Before running expensive tests, inspect available **blocks and inodes** on the filesystem used by the source checkout, pytest working directories, `TMPDIR`, `/tmp`, generated JUnit output, Git worktrees and caches:

```bash
pwd
git branch --show-current
git rev-parse HEAD
git status --short
df -h . /tmp
df -i . /tmp
du -sh /tmp/opencode 2>/dev/null || true
```

Investigate actual filesystem and quota limits, pytest scratch usage, runtime caches, and duplicate worktrees. The failure mode was a `No space left on device` error while pytest wrote its JUnit output; simply retrying the same full test run is not an acceptable remedy.

**Never** blindly delete `/tmp/opencode`, the project's `.git`, other agents' worktrees, user files, source, untracked state, evidence, dependencies, or caches that may be in use. Inventory storage ownership and active worktrees/processes. Remove **only** positively identified stale temporary files created by *this E17 attempt*, after ensuring no agent owns them; otherwise use an explicitly provisioned filesystem with ample capacity. If an alternate scratch volume is available, set `TMPDIR` and any relevant per-tool scratch/cache paths to that safe location, test that it is writable, and ensure the shell/worktree scripts actually honor the selected paths; do not assume a script with a hard-coded `/tmp/opencode` will follow `TMPDIR`.

Estimate space for **two complete declared pytest runs**, baseline and candidate worktrees, JUnit files, import/caching overhead, and 15 non-vacuity scenarios. Preserve a safety margin. Verify progress and free capacity before expensive stages. Stop and report a specific **resource blocker** if safe capacity cannot be guaranteed; never invent a passing record or edit the JSON manually.

## Stage 2 — Validate the E17 instrument, not the old result

Inspect schema 2's independent bindings:

1. Declared test surface derived from each revision's `pytest.ini testpaths` and committed `test_*.py` files, with collection identities and JUnit counts.
2. **Shipping-source binding** derived from tracked source/config/release content (not solely tests), including enterprise security policy, Python modules, dependency/config files, executable scripts and file identities. The intended exclusion of generated report content and ordinary prose must not accidentally exclude shipping source under an unusual directory or extension.
3. Recorded-revision digest check **and** present-HEAD comparison, so a source-only commit after measurement invalidates E17 even when test files are byte-identical.
4. A report-only evidence commit must not invalidate its own source binding; an implementation/config change must.
5. Missing/stale/moved bindings must yield distinct actionable failures. New test failures must be recorded separately from genuine regressions and pre-existing failures; no head failure may disappear silently from the partition.
6. Missing JUnit, truncated output, collection errors, abnormal interpreter termination, missing declared testpaths, incomplete baselines and disk errors must produce **NOT MEASURED / FAILED**, never zero-regressions PASS.
7. The baseline must predate enterprise work, be independently retrievable, and not be a loose object masquerading as a retained revision.

Run focused E17 tests on the **actual** source. Confirm meaningful negative and positive controls. Keep this focused: repair only an E17 defect demonstrated by an executable failing test and give that change its own regression test; do not clean unrelated style or refactor enterprise policies.

## Stage 3 — Generate the real record once the environment is safe

- Freeze one coherent source snapshot of the latest authoritative `main` for the measurement. Check it out into a clean isolated location; ensure the baseline has its own clean snapshot. Use the source script's actual `--head-root`, `--baseline-root` and `--out` behavior after inspecting it, and do **not** assume a temporary worktree changes the module's `REPO_ROOT` or default output path correctly.
- Execute the generator against both the baseline and the selected candidate from their committed trees, on a filesystem with sufficient free space. Run **the entire suite each revision declares**, not a trimmed list chosen to get green. Keep command lines, exit codes, JUnit test/node counts, stderr, test identifiers, baseline SHA, measured head SHA, and both content digests.
- Distinguish the ordinary nonzero pytest exit for genuine test failures **with a complete parseable JUnit report** from infrastructure/collection failures and unmeasured runs. Neither a code-0 program exit nor a nonempty JSON file alone establishes completion.
- The generated record must use the new schema and contain real `release_source_digest`, `release_source_file_count`, the measured-surface digest, and a fully partitioned set of failures. A `zero_regressions=true` field is **not** persuasive without `measured=true`, verifiable node sets and passing bindings.
- If a regression is detected, identify its actual behavior and root cause; fix only mission-caused regressions with meaningful tests, then regenerate against the resulting new source snapshot. Pre-existing failures require evidence of the *same failed test IDs at baseline*, not a remembered allowlist. Failures in newly introduced E17/security tests must be resolved or explicitly treated as an outstanding closure blocker—not hidden because the baseline never collected them.
- If the measurement encounters `ENOSPC`, timeout, a corrupt JUnit output, process interruption, or unstable concurrent source, **stop** and report it. Do not endlessly repeat a broken run.

## Stage 4 — Prove that the certificate is non-vacuous

On the measured code, run and preserve logs for:

```bash
PYTHONPATH=.:tools python3 -m pytest \
  tools/doubletake_evolve/enterprise/tests/test_regression_evidence.py \
  -p no:randomly -q

bash scripts/prove_enterprise_e17_nonvacuity.sh "$(git rev-parse --show-toplevel)"
```

Confirm the driver's **actual** final exit status and that all 15 rows behave as expected: **14 firing** and **1 declared-silent**, **0 blind**, **0 broken/collection errors**, and **0 no-op**. These are present observations about the inspected script; if it legitimately changes, derive counts from its rows instead of hard-coding them. In particular, the source-only mutation row must demonstrate rejection of an E17 record after a **committed** enterprise-policy change with unchanged tests.

Run the focused enterprise acceptance suite (including the E17 test) and affected boundary checks. Verify that the reviewer-facing E17 probe reports `PROVED` **in source/review context** for a valid record, and honestly `NOT_PROVEN` or `FAILED` for absent/unmeasured/stale records. Distinguish the intentionally unshipped regression instrument inside the restricted runtime package: its absence there is **not** authorization to fabricate E17 `PROVED` inside the package.

Do not require Windows-only `E12` to turn green on a Linux host to certify E17. Report that native Windows check as a **separate future pre-activation gate**, without claiming it is complete.

## Stage 5 — Commit/publish stable evidence without disturbing shared main

1. Confirm the measured source SHA still represents the shipping code. If any in-scope source/test/config file changed on `main` after the recorded snapshot, the record is stale: **regenerate** against the new code rather than rewriting recorded SHAs or digests.
2. If the only intervening change is an allowed generated evidence/report-only change excluded by the exact binding scope, verify that it does not invalidate the record rather than assuming.
3. Atomically integrate only the valid report and any narrowly justified E17 fixes. Do not overwrite another worker's report or restore stale content from a prior squash. Use optimistic/concurrency-safe comparisons of HEAD and file blobs before staging, committing and ordinary pushing.
4. Re-run `--verify` **after** the evidence commit and against the final current `main`; check E17 remains `PROVED` in the review path. Confirm local/remote commit identity and published baseline retention. In a clean clone or disposable worktree, reproduce at least the suite-free `--verify` result (and checks appropriate to that environment) to catch accidental dependence on local loose objects or untracked files.
5. Do not alter enterprise packaging exclusions or relax its fail-closed controls to ship a build-time E17 instrument. If the review bundle has remaining E1–E16 or E12 `NOT_PROVEN`, accurately separate **E17 closure** from **enterprise-wide approval**.

## Completion criteria (all must be evidenced)

- Exact current `main` source tree and measured revision established; no unacknowledged concurrent drift.
- Storage blocker resolved without deleting other agents' or user work.
- Record is current schema, parseable, `measured=true`, baseline and candidate fully measured, partitions exhaustive and internally consistent.
- **Zero genuine baseline-passing test regressions**, with new test failures and other failures honestly resolved or explicitly blocking closure.
- Recorded test surface **and shipping source** content match current source; source-only drift refusal is demonstrated, while record-only commits remain valid.
- Focused E17 and relevant enterprise acceptance checks are green; non-vacuity driver succeeds with no blind/broken/NOOP row.
- E17 probe in repository review context actually returns `PROVED` with traceable evidence; verification from the final committed published state succeeds.
- No weakening of E1–E16 controls, new credential exposure, provider inclusion, network permission, self-modification privilege, or silent test coverage omission.

**If every criterion is satisfied, report exactly:** `E17_FINAL_CLOSURE_COMPLETE`.

Otherwise report **exactly:** `E17_FINAL_CLOSURE_BLOCKED`, followed by the specific unfulfilled criterion, first failing command, actual exit code, measured error, and smallest safe corrective action. A partial success or a disk-space workaround is not closure.

## Final response format

Report briefly:

- Local/remote `main` SHA, measured source SHA, evidence commit SHA, baseline SHA and retained ref.
- Disk/block/inode condition before/after; scratch location and any precisely scoped cleanup performed.
- Generation commands, measured baseline/head test counts, failures and classification; source/test digests and schema.
- Focused tests, enterprise acceptance, non-vacuity summary and exit codes; reviewer-visible E17 status.
- `--verify` output on final published state, independently reproducible commands and artifact paths.
- Any unresolved limitation, particularly Windows E12 and corporate deployment authorization, which this **E17-only** prompt cannot claim to satisfy.
- Exact terminal closure marker from the preceding rule.

**STOP once E17 is proven.** Do not broaden this mission into the Windows/Copilot port, enterprise policy redesign, or ongoing monitoring.
