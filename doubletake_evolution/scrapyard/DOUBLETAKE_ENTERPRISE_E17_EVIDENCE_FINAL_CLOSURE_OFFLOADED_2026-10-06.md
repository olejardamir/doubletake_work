# Enterprise E17 regression evidence: historical blocker and falsifiable contract

Source: condensed in place from 2026-10-06 offloaded E17 closure instructions; original Git blob `840d769d6ce0d80a761db98f9a1bef25115aefac` recoverable in history. **Historical specification, not proof of current DT implementation, E17 closure, or enterprise approval.**

## Historical observation (revalidate)

At public DT main `5797f15dd705b05b27a96ed20be96e47b24179a9`, E17 source-bound schema 2 and source-only mutation tests were reportedly implemented, but committed `reports/enterprise/regression_evidence.json` remained schema 1, `measured=false`, `zero_regressions=true`, lacking `release_source_digest`. The attempted measurement failed with `OSError: [Errno 28] No space left on device` during pytest JUnit writing. Therefore E17 was **OPEN at that snapshot**, regardless of the nominal zero-regressions field. Baseline expected in historical instrument: `a50bc2c07df8ef6b6bcf996a6f9f5e032703243b`; verify it predates enterprise work and is retained by a published ref in a clean clone, not just as a loose Git object.

## Source-linked surfaces (verify paths against current DT)

- Generator/verifier: `tools/doubletake_evolve/enterprise/regression_evidence.py` (historically `SCHEMA_VERSION = "2"`, `--verify`).
- Evidence: `reports/enterprise/regression_evidence.json`.
- Tests: `tools/doubletake_evolve/enterprise/tests/test_regression_evidence.py`, `tools/doubletake_evolve/tests/enterprise/test_enterprise_acceptance.py`.
- Non-vacuity: `scripts/prove_enterprise_e17_nonvacuity.sh` (historically 15 cases: 14 fire, 1 deliberately silent).
- Reviewer status: `tools/doubletake_evolve/enterprise/review_bundle/probes.py`; bundle builder `tools/doubletake_evolve/enterprise/review_bundle/builder.py`.
- Declared suite: `pytest.ini`; applicable operational and security boundaries: `AGENTS.md`, `ENTERPRISE_USE_NOTICE.md`, `ENTERPRISE_SECURITY_OVERVIEW.md`.

## Testable acceptance and negative controls

1. **Current source and provenance.** Establish published remote `main`, clean measured head, source and evidence SHAs, baseline retained ref, concurrent drift, and current reviewer status. Suite-free verifier alone is insufficient if reviewer probe disagrees or shipping source changed. Report-only evidence commits may remain valid when excluded by the instrument's precise source-binding rules; source/config/test changes must invalidate stale evidence.
2. **Safe measurement resources.** Verify free blocks **and inodes**, quotas, scratch/worktree/JUnit/cache locations and ownership. Reserve capacity for two complete declared suites plus non-vacuity and margin. Never blindly delete `/tmp/opencode`, another agent's files/worktrees, untracked data or evidence. Confirm alternate scratch paths are honored by scripts; if capacity cannot be safely established, report resource blocker rather than retrying an identical ENOSPC failure.
3. **Complete independent measurement.** On clean isolated baseline and candidate snapshots, run each revision's entire declared pytest surface, including discovered `test_*.py`, collection identities, node counts and parseable JUnit. Record exit codes, stderr, exact failed IDs and distinct baseline/head/new-test partitions. Ordinary pytest failure with complete JUnit differs from infrastructure, collection, truncation, timeout, abnormal exit or ENOSPC: the latter are **NOT MEASURED**, never a zero-regressions PASS.
4. **Two independent content bindings.** Test-surface digest and shipping-source digest must cover committed relevant modules, security policies, executable scripts, dependencies/config and file identities, not merely tests. A source-only enterprise-policy mutation with unchanged tests must invalidate prior evidence; an evidence-only report commit must not. Missing, moved or stale bindings fail closed with specific diagnostics. Verify against recorded revision **and current HEAD**.
5. **No disguised regression.** Baseline-passing test regressions must be zero; newly introduced failing tests and pre-existing failures must be accounted for separately. A pre-existing failure requires the same test ID observed failing in baseline. Never suppress coverage, weaken E1–E16 security controls, alter the baseline to improve results, hand-edit JSON, or claim `PROVED` from `zero_regressions=true` when `measured=false`.
6. **Non-vacuity and review.** Run focused E17 tests and the actual non-vacuity driver; derive current row count from script, historically 14 firing and one intentional `SILENT-OK`, with zero blind/broken/no-op or wrong-reason firings. Include source-only committed mutation and missing/stale evidence negatives. Reviewer-visible `PROVED` requires a valid current measured record; absent/stale/unmeasured yields `NOT_PROVEN` or `FAILED`. Restricted runtime packaging may intentionally omit the build-time instrument; that does not justify fabricated proof.
7. **Published reproducibility.** Integrate only verified report or narrowly evidenced E17 fixes without overwriting concurrent workers, rewriting history, or force pushing. Re-run verifier and reviewer probe after publication and reproduce suite-free verification from clean clone. Any subsequent in-scope source change requires new measurement.

## Honest disposition

E17 can be declared complete only with schema 2 (or justified newer), `measured=true`, independently recoverable baseline, complete baseline/head suites, zero genuine regressions, resolved new-test failures, valid test/source digests, green focused/enterprise acceptance, effective non-vacuity, reviewer `PROVED`, and published-state reproducibility. Otherwise retain **E17_FINAL_CLOSURE_BLOCKED** with exact first failing command, exit code, evidence and smallest safe correction; do not infer present closure from this archived prompt.

Linux E17 certification does **not** establish Windows-only E12, corporate deployment authorization, or enterprise-wide E1–E16 approval. Current DT parity, runtime, and Ground remain **UNKNOWN**.
