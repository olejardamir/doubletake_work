#!/usr/bin/env bash
# BPE-20261102-028 | DT-EVO-007 / 7.9.2 | PREPARED_UNTESTED
# Goal: reject forged caller-supplied ReceiptVerification verdict digests.
# DT main db86a85f2ca204117bcd36e8e51a9d1df05d9bbf; tools/doubletake_evolve/claim_receipt/models.py blob 7f5eb49c20094911c5deedf5937cabb2c5b7d849
# DoD positive: derived/matching digests accepted and stable.
# DoD negative: forged digest and reused digest after chain change rejected.
# DoD regression: existing verdict-chain and claim-receipt tests pass host-guarded.
# No local tests or runtime Ground claimed by author.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$root"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 21; }
[[ "$(git branch --show-current)" == "main" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 22; }
src="tools/doubletake_evolve/claim_receipt/models.py"
testfile="tools/doubletake_evolve/claim_receipt/test_verdict_digest_validation.py"
[[ -f "$src" && ! -L "$src" ]] || { echo "STOP_SOURCE_MISSING_OR_SYMLINK" >&2; exit 23; }
[[ ! -e "$testfile" && ! -L "$testfile" ]] || { echo "STOP_TEST_EXISTS" >&2; exit 24; }
printf 'PATCH=BPE-20261102-028 DT_HEAD=%s\n' "$(git rev-parse HEAD)"
if [[ "$(git rev-parse "HEAD:$src" 2>/dev/null)" != "7f5eb49c20094911c5deedf5937cabb2c5b7d849" ]]; then
  echo "NOTICE_COMMITTED_SOURCE_DRIFT: actual hunk check decides compatibility" >&2
fi
PATCH_TEXT="$(cat <<'BPE_028_DIFF'
diff --git a/tools/doubletake_evolve/claim_receipt/models.py b/tools/doubletake_evolve/claim_receipt/models.py
--- a/tools/doubletake_evolve/claim_receipt/models.py
+++ b/tools/doubletake_evolve/claim_receipt/models.py
@@ -152,21 +152,22 @@
     all_pass: bool
     verdict_digest: str = ""
 
-    def __post_init__(self) -> None:
-        if self.verdict_digest:
-            return
-        object.__setattr__(self, "verdict_digest", canonical_json_digest({
-            "spec_digest": self.spec_digest,
-            "verdicts": [
-                {"claim_id": v.claim_id, "verdict": v.verdict, "reason": v.reason,
-                 "fields_missing": list(v.fields_missing),
-                 "recomputed_digest": v.recomputed_digest}
-                for v in self.verdicts
-            ],
-            "coverage_fraction": self.coverage.coverage_fraction,
-            "covered": self.coverage.covered,
-            "chain_valid": self.chain.chain_valid,
-            "chain_digest": self.chain.chain_digest,
-            "sufficiency_fraction": self.sufficiency_fraction,
-            "all_pass": self.all_pass,
-        }))
+    def __post_init__(self) -> None:
+        digest = canonical_json_digest({
+            "spec_digest": self.spec_digest,
+            "verdicts": [
+                {"claim_id": v.claim_id, "verdict": v.verdict, "reason": v.reason,
+                 "fields_missing": list(v.fields_missing),
+                 "recomputed_digest": v.recomputed_digest}
+                for v in self.verdicts
+            ],
+            "coverage_fraction": self.coverage.coverage_fraction,
+            "covered": self.coverage.covered,
+            "chain_valid": self.chain.chain_valid,
+            "chain_digest": self.chain.chain_digest,
+            "sufficiency_fraction": self.sufficiency_fraction,
+            "all_pass": self.all_pass,
+        })
+        if self.verdict_digest and self.verdict_digest != digest:
+            raise ValueError("ReceiptVerification digest does not match its contents")
+        object.__setattr__(self, "verdict_digest", digest)
diff --git a/tools/doubletake_evolve/claim_receipt/test_verdict_digest_validation.py b/tools/doubletake_evolve/claim_receipt/test_verdict_digest_validation.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_verdict_digest_validation.py
@@ -0,0 +1,38 @@
+"""A supplied verdict fingerprint must bind actual aggregate proof contents."""
+from dataclasses import replace
+import pytest
+from doubletake_evolve.claim_receipt.models import (
+    ClaimVerdict, CoverageResult, ReceiptChain, ReceiptVerification, PASS,
+)
+
+def _verified():
+    return ReceiptVerification(
+        spec_digest="sealed-spec",
+        verdicts=(ClaimVerdict("a", PASS, "evidence verified"),),
+        coverage=CoverageResult(
+            committed_ids=("a",), covered_ids=("a",), missing_ids=(),
+            coverage_fraction=1.0, covered=True,
+        ),
+        chain=ReceiptChain(
+            chain_digest="valid-chain", receipts=(), chain_valid=True, gaps=(),
+        ),
+        sufficiency_fraction=1.0, all_pass=True,
+    )
+
+def test_generated_digest_is_stable():
+    assert _verified().verdict_digest == _verified().verdict_digest
+
+def test_matching_supplied_digest_is_accepted():
+    result = _verified()
+    assert replace(result, verdict_digest=result.verdict_digest) == result
+
+def test_forged_supplied_digest_is_rejected():
+    with pytest.raises(ValueError, match="digest does not match"):
+        replace(_verified(), verdict_digest="0" * 64)
+
+def test_old_digest_cannot_attest_to_changed_chain():
+    result = _verified()
+    changed = replace(result.chain, chain_digest="different-chain")
+    with pytest.raises(ValueError, match="digest does not match"):
+        replace(result, chain=changed, verdict_digest=result.verdict_digest)
+    assert replace(result, chain=changed, verdict_digest="").verdict_digest != result.verdict_digest
BPE_028_DIFF
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_WORKTREE_APPLY_CHECK" >&2; exit 30; }
if ! git diff --quiet -- "$src" || ! git diff --cached --quiet -- "$src"; then
  echo "STOP_DIRTY_TARGET: preserve prior edits; use isolated reviewed integration" >&2; exit 31
fi
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 32; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "$testfile" tools/doubletake_evolve/claim_receipt/test_verdict_chain_binding.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAIL_FOCUSED_TESTS: leave uncommitted changes for review" >&2; exit 33
fi
git diff --check -- "$src" "$testfile" || { echo "FAIL_DIFF_CHECK" >&2; exit 34; }
echo "FOCUSED_TESTS_PASSED BPE-20261102-028; no commit/deployment/independent Ground claimed"
git status --short
