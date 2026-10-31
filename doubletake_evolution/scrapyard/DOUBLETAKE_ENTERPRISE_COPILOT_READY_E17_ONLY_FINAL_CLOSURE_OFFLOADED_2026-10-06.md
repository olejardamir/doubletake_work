# DoubleTake — Enterprise Copilot-Ready Boundary: E17-Only Final Closure (Offloaded)

**Date:** 2026-10-06  
**Repository:** `https://github.com/olejardamir/DT.git`  
**Authoritative branch:** `main`  
**Task:** Close **E17 — no full-DoubleTake regressions caused by the enterprise mission**, using executable, independently verifiable evidence.  
**Scope:** E17 and directly necessary E17 evidence plumbing **only**. This is **not** a restart of the enterprise-security mission.

## 0. Authority, baseline, and stop condition

Work from the actual current `main` and inspect its current state before changing anything. The repository seen on 2026-10-06 had HEAD `92796527b3b78a85714dd603ef4d3cb0b4343b85` and **already contained** `reports/enterprise/regression_evidence.json`. Those are **observations, not a pinned target SHA or an assertion that the evidence is valid**; re-read the repository and its upstream at execution time.

The original mission, `DOUBLETAKE_ENTERPRISE_COPILOT_READY_SECURITY_BOUNDARY_FINAL_CLOSURE_OFFLOADED_2026-10-04.md`, has already led to a restricted enterprise implementation and a substantial body of security and non-vacuity evidence. **Preserve that work.** The sole remaining work assigned here is to establish whether **E17 is PROVED now**, and to repair only objectively demonstrated E17 blockers if it is not.

**Immediate no-op stop (only after the release-binding check):** If the committed E17 record independently verifies, the current repository-context `probe_e17_full_dt_regression_free()` reports `PROVED` with reason `ZERO_REGRESSIONS`, the E17 tests and non-vacuity driver pass, **and the E17 record is proven to describe the actual shipping implementation as well as the declared test files**, do not modify code, tests, manifests, policy, or regenerate evidence gratuitously. Report `E17_CLOSURE_COMPLETE` with commands and observed evidence and stop. Passing the existing `--verify` **alone is insufficient**: the current verifier has a confirmed release-staleness gap described below.

Never infer completion merely from the presence of a JSON file, a green summary flag, or an earlier agent's claim.

## 1. Non-negotiable preservation rules

1. **Do not reopen E1–E16.** Do not redesign the enterprise package, provider boundary, allowlist, dependency resolution, mock coding-agent contract, logging, memory, subprocess, network, workspace, self-modification policy, or Copilot integration.
2. **Do not activate a Copilot or VS Code Agent Host/AHP backend.** Retain the **Copilot-ready, mock-backed** pre-integration posture and the restricted enterprise distribution. Keep the normal unrestricted DoubleTake `main` functionality available separately.
3. Do not relax tests, remove suites, edit `pytest.ini` to narrow collection, delete failing test IDs, whitelist failures, replace measured values with asserted outcomes, alter threshold semantics, or forge/hand-edit `zero_regressions`.
4. Do not rewrite or rebase historical evidence, change the legitimate baseline to force a zero delta, delete security controls, change artifact exclusion rules, or use documentation-only acceptance claims.
5. Do not modify shared, active worktrees belonging to other workers. Use isolated temporary worktrees for any expensive measurement, mutation testing, or validation. Do not overwrite concurrent changes.
6. **E12 live-Windows filesystem proof is separate.** Preserve its exact existing verdict. If still `NOT_PROVEN`, state that honestly; **do not** manufacture Windows evidence or expand this E17-only assignment to chase it. E17 closure is **not** a certification that E1–E17 all passed or that enterprise deployment is approved.
7. A failed, stale, uncollected, incomplete, or unrepeatable measurement is **not proof**. Record the correct blocked state and exact reason, never an optimistic PASS.

## 2. Inspect the actual E17 implementation and evidence

Prioritize these existing paths rather than building a competing instrument:

- `tools/doubletake_evolve/enterprise/regression_evidence.py`
- `reports/enterprise/regression_evidence.json`
- `tools/doubletake_evolve/enterprise/tests/test_regression_evidence.py`
- `tools/doubletake_evolve/enterprise/review_bundle/probes.py`
- `tools/doubletake_evolve/enterprise/review_bundle/builder.py`
- `tools/doubletake_evolve/tests/enterprise/test_enterprise_acceptance.py`
- `scripts/prove_enterprise_e17_nonvacuity.sh`
- `scripts/prove_enterprise_closure_nonvacuity.sh` (read-only cross-check; do not restart its entire mission)
- `pytest.ini`, `AGENTS.md` (especially measured-surface binding and baseline retention rules)

Establish and record:

- actual current branch, local HEAD, published `origin/main`, worktree cleanliness, and whether local and remote `main` agree;
- whether the E17 record exists, parses, carries the expected schema, and was created from measured runs rather than a synthetic test fixture;
- baseline revision, ancestry/history-rewrite implications, and **retention by a branch or tag** (object existence is **not** retention);
- both revisions' declared `pytest.ini` testpath scope, collected/failing node IDs, and their completeness;
- recomputed `regression_node_ids`, `new_test_failure_node_ids`, `pre_existing_node_ids`, and `resolved_node_ids`;
- measurement-surface content identity at the recorded revision **and** at current committed `HEAD`, including file count and digest;
- **shipping source identity independent of the test-only measured surface**: whether any committed runtime, enterprise policy, packaging code, dependency, configuration, resource, or other shipped repository content has changed since the measurement; distinguish a report-only commit from a changed implementation;
- whether any E17 acceptance assertion is skipped, uncollected, weakened, or based on a forged scalar;
- exact repository-context E17 probe result, `status`, `reason_code`, and observations.

### Critical E17 release-binding defect discovered 2026-10-06

The live `measured_surface(rev)` implementation in `tools/doubletake_evolve/enterprise/regression_evidence.py` selects only committed `test_*.py` files beneath `pytest.ini` `testpaths`; `measured_digest(rev)` therefore digests only those test files. `verify_record()` compares that digest with current `HEAD`. Its own test `test_movement_outside_the_measured_surface_does_not_invalidate()` explicitly expects non-test Python edits not to invalidate a record. **This can accept an earlier regression result after implementation code has changed without the test files changing.** It establishes test-collection stability, not release implementation identity. An E17 `PROVED` result on this verifier is therefore not sufficient to certify a fresh shipping implementation for the enterprise Copilot port.

**Fix this as a narrow E17 evidence-integrity deficiency before a no-op closure.** Preserve the existing test-surface digest and its purpose. Add a **separate, deterministic release/source-content binding** (for example a git-tree-derived digest of all tracked shipping source/config/resource files, excluding the evidence record itself and any other explicitly identified self-generated non-executable evidence outputs). Bind the real baseline-versus-head test run to the exact source/config/dependency tree it exercised. The scope must not omit production implementation and enterprise security policy files merely because they are outside `testpaths`; it must be justified, automatically derived, and tested against source-only drift, changes to rules/config/dependencies, and a report-only commit. Conservatively reject or regenerate when a changed path cannot reliably be classified. The binding must work after committing the generated report without requiring the report to hash itself. Do not accept a blanket false-positive exemption for source edits. A full tracked-source identity excluding narrowly enumerated generated report paths is safer than attempting an incomplete handwritten import-closure allowlist.

Add a **non-vacuous adversarial test** using an isolated throwaway worktree or repository: generate/construct a legitimately verifiable zero-regression record, commit a non-test production-code change while leaving every `test_*.py` unchanged, show that the old test-surface digest stays identical, and assert the **new release binding rejects the old claim**. Also assert that committing only the evidence record preserves validity. Include a source-only mutation row in the E17 non-vacuity proof; do not weaken any existing mutation row or its declared silent redundant case. If other workers change the shipping implementation while measurement runs, do not publish the now-stale record as a current release claim.

Do not label this a discovered runtime vulnerability or claim that regressions *have* occurred. It is a **false-freshness possibility in regression evidence**, proven from the current binding scope. Repair and re-measure only to the extent necessary for an accurate source-bound E17 closure.

The current instrument uses a **set difference**, not a requirement that the entire legacy suite have zero failures. A genuine regression is a head failure for a test **collected and passing at the baseline**. A newly introduced test that the baseline never collected must be reported separately, not silently dropped and not mislabeled as a baseline regression. Pre-existing and resolved failures likewise require separate honest accounting. **E17's causal zero-regression claim does not excuse genuine failing new enterprise acceptance tests**; disclose and fix relevant mission-origin failures rather than bury them.

## 3. First attempt: verify the evidence already committed

From the current repo root (adjust `REPO` to the real checkout location if needed):

```bash
REPO="$(git rev-parse --show-toplevel)"
cd "$REPO"
git status --short
git rev-parse HEAD
git ls-remote origin refs/heads/main

test -s reports/enterprise/regression_evidence.json
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise.regression_evidence --verify

PYTHONPATH=.:tools python3 -m pytest \
  tools/doubletake_evolve/enterprise/tests/test_regression_evidence.py \
  tools/doubletake_evolve/tests/enterprise/test_enterprise_acceptance.py \
  -p no:randomly -q

bash scripts/prove_enterprise_e17_nonvacuity.sh "$REPO"
```

Use the actual tools/environment dependencies declared by the repository; do not silently skip a command because it is expensive. Capture exit codes, output, timestamps, and exact HEAD. Investigate environmental and collection failures separately from functional failures. Do not claim the checks ran if they did not.

Also invoke the actual **repository-context** `probe_e17_full_dt_regression_free()` and record its `status` and `reason_code`. Do not use the restricted enterprise artifact's inability to import this build-time-only instrument as a substitute for repository-context verification: `REGRESSION_INSTRUMENT_NOT_PACKAGED` is an **intentional** distinct `NOT_PROVEN` case *inside* the restricted artifact, not evidence that E17 has been measured there.

**Decision after first attempt:**

- Valid `--verify` + repository E17=`PROVED`/`ZERO_REGRESSIONS` + focused acceptance green + non-vacuity green **+ separate current-shipping-source binding proved with adversarial tests** → **stop with no further changes**. If the separate shipping-source binding does not yet exist, this condition is not met even when the old tests are green.
- Missing or stale record → regenerate *only* the E17 measurement, after checking the reason.
- Reported true regression → diagnose specific test nodes and causality; make the **smallest real regression fix**, then remeasure.
- Collection errors, missing baseline retention, incomplete JUnit, absent testpaths, digest drift, or non-vacuity blindness → repair precisely the demonstrated E17 evidence/probe defect, not the broader enterprise mission.

## 4. Only if verification fails: repair and regenerate correctly

### 4.1 Provenance and scope

The instrument's declared historical baseline on inspection was:

`a50bc2c07df8ef6b6bcf996a6f9f5e032703243b`

**Do not assume this SHA is still appropriate without verifying it.** Verify it is actually pre-enterprise, obtainable from a clean clone through an advertised retained ref, and that the current instrument's expected baseline matches it. No "better" baseline may be selected just because it yields a greener result. Preserve honest historical comparisons across squash merges and backup refs; if a required ref is not published/reproducible, classify the evidence as blocked rather than letting a locally dangling commit satisfy the test.

Derive test scope from each revision's committed `pytest.ini`, not a manually curated list. Preserve collection identity, JUnit failure/error node sets, counts, and the exhaustive partition. Verify failing IDs are within the collected set. Keep the record's measured-test-surface digest stable with the actual test files on the current committed shipping surface **and** add the separate executable/release source-content binding required by the Critical E17 release-binding defect above. Test changes and implementation changes must both be able to stale a claim, without self-invalidating when the evidence JSON alone is committed.

### 4.2 Run the actual full measurement in isolation

If regeneration is required, allocate an isolated clean detached worktree from a stable, published `main` revision. Confirm no other worker is changing its test surface. Then run the **existing** generator, which measures both the head and the historical baseline; **do not** substitute a focused suite for full-DT evidence:

```bash
# Example: run within the isolated clean HEAD worktree.
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise.regression_evidence
PYTHONPATH=.:tools python3 -m doubletake_evolve.enterprise.regression_evidence --verify
```

The generator can run for tens of minutes; run it to completion rather than narrowing the declared suite. If the implementation or any shipping source/config content changed since the previous measurement, re-run at the final frozen candidate and prove the new release/source-content binding; do not reuse an old result merely because `test_*.py` files have not moved. Preserve full result logs and exit status. Do not edit the generated node sets or Boolean summary. Only if verification succeeds, move the generated `reports/enterprise/regression_evidence.json` into the intended versioned evidence path using a concurrency-safe integration step. Revalidate the content identity after landing the change; the evidence record can be committed after its measured source revision **only when the declared measured test surface has not changed**. A different commit SHA alone is not proof of staleness or freshness.

If test code or measured helpers legitimately change during a repair, regenerate against the **new final shipping surface**. If other workers move `main` while the worktree measures, do not silently publish a record bound to a superseded surface; compare digests and remeasure when the bound surface truly changed.

### 4.3 Narrow repairs only

For any true regression, provide its exact test node ID, baseline result, head result, causal production path, and smallest targeted fix. For any E17 verifier fault, provide the exact failed invariant, test demonstrating the failure before repair, and the passing corrected test. Do not accept tests that fail merely because of import/setup errors as a successful red mutation; negative tests must fail **for their named guard**.

Once fixed, repeat the focused tests and full measured delta as needed. Stop if the legitimate state remains blocked by an environmental limitation that cannot be resolved without expanding scope; produce a reproducible blocker report instead of gaming the test.

## 5. E17 non-vacuity is mandatory

Run `scripts/prove_enterprise_e17_nonvacuity.sh` on the final stable source state. The current script declares **12 mutation rows**: **11 must fire** and **one explicitly declared redundant/silent row must remain silent**. Inspect the live script for its actual dynamically derived expectations; do not hard-code these counts in a new certifier.

Required proof semantics include:

- falsifying the recorded zero-regression verdict is rejected;
- partition and node-ID sets are re-derived independently of stored summary fields;
- baseline pre-enterprise status and ref retention are checked against a real synthetic orphan/retained control;
- missing evidence cannot become `PROVED`;
- distinct unable-to-measure states remain distinct;
- truncated reports cannot masquerade as complete collection;
- all non-baseline failures are accounted for, including newly introduced tests;
- the declared test surface and its movement since measurement are checked against **current committed HEAD**, not merely against the recorded commit;
- **a separate release/source-content binding catches a non-test implementation/configuration change despite an identical `test_*.py` digest, while an evidence-only commit remains valid**;
- mutated tests are actually collected and failing for the intended reason, with no no-op perturbations or setup-only failures.

Require the driver to exit zero with **zero blind, zero broken, and zero no-op** rows. Preserve its known intentional redundant/silent case rather than misclassifying it as a blind spot. If it is genuinely blind or broken, fix the smallest guard/test defect and rerun. The same rules apply after any source or instrument change.

## 6. Review-bundle reconciliation without reopening other gates

Read the actual E17 outcome from `review_bundle/probes.py` in repository context. Confirm that the review-bundle generator includes E17 among its outcomes and that its summary is re-derived from row-level statuses. If an E17 defect requires regenerating the review bundle, use the existing `doubletake_evolve.enterprise.review_bundle.builder` in a clean checkout and inspect its **individual** outcomes.

Do **not** force its `all_proved` to `true`. Other evidence (notably E12's native Windows path/reparse-point proof) may legitimately remain `NOT_PROVEN`; this does **not** negate a separately proved E17 but does prevent global enterprise certification. Existing E1–E16 results must not become worse because of an E17-only change. No new enterprise provider integrations, deployments, or security-profile edits are authorized by this task.

## 7. Loop and strict stopping logic

Repeat only while a **real E17 blocker** remains and an in-scope, evidence-backed repair is possible:

1. Inspect exact current HEAD, origin/main, committed measured surface, and record.
2. Run `--verify`, focused E17 acceptance, repository E17 probe, and non-vacuity.
3. Classify the first substantive blocker precisely (measurement absent, invalid, stale surface, true regression, collection failure, retention failure, blind guard, or environment limitation).
4. Apply at most the smallest necessary in-scope fix; no cosmetic refactor or speculative redesign.
5. Re-run affected tests and any full measurement that a changed measured surface invalidates.
6. Verify the final on-disk and committed evidence, current surface binding, and remote reproducibility where applicable.
7. Stop **immediately** when E17 is genuinely proved or when a blocker cannot be resolved without leaving the authorized scope. Do not loop indefinitely without progress.

Maintain an explicit evidence ledger of commands, outcomes, changed files, digests, SHAs, and residual limitations. If no changes were necessary, the ledger should explicitly say `NO_CHANGES_REQUIRED`.

## 8. Final output (exact contract)

Return a concise evidence-based report with:

- `HEAD` / `origin/main` / working-tree state and retained pre-enterprise baseline;
- `reports/enterprise/regression_evidence.json` existence, verification result, source measurement revision, test-surface identity, **separate shipping-source/configuration identity**, source-only stale-record mutation result, and artifact SHA-256;
- baseline/head suite commands, collected/failed/skipped/error counts, test result node-ID partitions, and whether there are **zero actual regressions**;
- repository-context `E17` status and reason code (must be `PROVED` + `ZERO_REGRESSIONS` for completion);
- focused-test and non-vacuity commands, exit codes, and mutation-driver results;
- E1–E16 preservation statement **without** claiming they were rerun if not;
- separate E12/global enterprise-release caveat if still open;
- precisely which files were changed and why (or `NO_CHANGES_REQUIRED`);
- final closure decision and any named blockers.

End with exactly one of:

`E17_CLOSURE_COMPLETE` — only when every E17 gate above is backed by repeatable current evidence **and both test-surface and shipping-source bindings are current**;

`E17_CLOSURE_BLOCKED` — otherwise, with the smallest concrete unmet conditions.

**Do not output `ENTERPRISE_SECURITY_CLOSURE_COMPLETE`, `E1_E17_ALL_PROVED`, or a production deployment approval from this E17-only task.**
