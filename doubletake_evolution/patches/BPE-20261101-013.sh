#!/usr/bin/env bash
# BPE-20261101-013 — Bind aggregate verdict digest to the exact receipt chain digest
# Mission: DT-EVO-007 / 7.9.2 evidence-integrity support; NOT proof of complete canonical 7.9.2 contract.
# Target branch: feature/alphacode-provider at original inspection 9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb
# Dependency: BPE-20261101-011 must be applied/committed FIRST.
# Expected models.py blob after BPE-011: 0f903b08461edce217c83a1feb324958affb159f
# Revision: 1; PREPARED_UNTESTED; source-hunk simulated, NOT git-applied/tested.
# DoD positive: valid unchanged chain yields identical verdict digest on repeat.
# DoD negative: two invalid chains with equal per-claim verdicts but different predecessor hashes yield different verdict digests.
# DoD regression: existing claim receipt and terminal digest tests pass under host guard.
# Stop on missing dependency, dirty source, stale blob, existing test, failed apply check or tests.
# No auto-commit, no push, no protected-state mutation.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$ROOT"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 20; }
[[ "$(git branch --show-current)" == "feature/alphacode-provider" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 21; }
SRC=tools/doubletake_evolve/claim_receipt/models.py
TEST=tools/doubletake_evolve/claim_receipt/test_verdict_chain_binding.py
[[ -f "$SRC" && ! -L "$SRC" ]] || { echo "STOP_SOURCE_MISSING_OR_LINK" >&2; exit 22; }
[[ -f tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py ]] || { echo "STOP_DEPENDENCY_011_NOT_APPLIED" >&2; exit 22; }
if ! git diff --quiet -- "$SRC" || ! git diff --cached --quiet -- "$SRC"; then echo "STOP_DIRTY_TARGET" >&2; exit 23; fi
[[ "$(git hash-object -- "$SRC")" == "0f903b08461edce217c83a1feb324958affb159f" ]] || { echo "STOP_STALE_BLOB_OR_DEPENDENCY" >&2; exit 24; }
[[ ! -e "$TEST" && ! -L "$TEST" ]] || { echo "STOP_TEST_ALREADY_PRESENT" >&2; exit 25; }
printf 'PATCH_ID=BPE-20261101-013\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
PATCH_TEXT="$(cat <<'BPE_DIFF_013_END'
diff --git a/tools/doubletake_evolve/claim_receipt/models.py b/tools/doubletake_evolve/claim_receipt/models.py
--- a/tools/doubletake_evolve/claim_receipt/models.py
+++ b/tools/doubletake_evolve/claim_receipt/models.py
@@ -161,5 +161,6 @@
             "coverage_fraction": self.coverage.coverage_fraction,
             "covered": self.coverage.covered,
             "chain_valid": self.chain.chain_valid,
+            "chain_digest": self.chain.chain_digest,
             "sufficiency_fraction": self.sufficiency_fraction,
             "all_pass": self.all_pass,
diff --git a/tools/doubletake_evolve/claim_receipt/test_verdict_chain_binding.py b/tools/doubletake_evolve/claim_receipt/test_verdict_chain_binding.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_verdict_chain_binding.py
@@ -0,0 +1,48 @@
+"""The verdict fingerprint must bind the actual receipt-chain fingerprint."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimReceiptSpec, ClaimSpec, EvidenceItem, TerminalReceipt, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_claims
+
+
+def _verification(second_predecessor=None):
+    ids = ("a", "b")
+    spec = ClaimReceiptSpec(
+        spec_id="chain-bound-verdict", version="1",
+        claims=tuple(
+            ClaimSpec(claim_id=cid, statement=cid, expected_kind="score",
+                      evidence_path=f"ev/{cid}", required_fields=("value",))
+            for cid in ids
+        ),
+        committed_claim_ids=ids, sealed_at="2026-11-01T00:00:00Z",
+    )
+    evidence = {
+        f"ev/{cid}": EvidenceItem(path=f"ev/{cid}", payload={"value": cid})
+        for cid in ids
+    }
+    first = TerminalReceipt("a", evidence["ev/a"].content_digest, "")
+    second = TerminalReceipt(
+        "b", evidence["ev/b"].content_digest,
+        first.receipt_sha256 if second_predecessor is None else second_predecessor,
+    )
+    return verify_claims(spec, evidence, {"a": first, "b": second})
+
+
+def test_valid_chain_has_stable_bound_verdict_digest():
+    first = _verification()
+    repeated = _verification()
+    assert first.all_pass and repeated.all_pass
+    assert first.chain.chain_valid and repeated.chain.chain_valid
+    assert first.verdict_digest == repeated.verdict_digest
+
+
+def test_different_invalid_chains_have_different_verdict_digests():
+    first = _verification("broken-predecessor-one")
+    second = _verification("broken-predecessor-two")
+    assert not first.all_pass and not second.all_pass
+    assert not first.chain.chain_valid and not second.chain.chain_valid
+    assert all(v.verdict == PASS for v in first.verdicts)
+    assert first.verdicts == second.verdicts
+    assert first.chain.chain_digest != second.chain.chain_digest
+    assert first.verdict_digest != second.verdict_digest
BPE_DIFF_013_END
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CHECK" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "$TEST" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py; then
  echo "FAIL_FOCUSED_TESTS: inspect uncommitted changes" >&2; exit 32
fi
git diff --check -- "$SRC" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PATCH_TESTS_PASSED_BPE-20261101-013: applied locally, NOT committed, NOT independently Ground-verified"
git status --short
