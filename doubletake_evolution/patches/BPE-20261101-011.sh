#!/usr/bin/env bash
# BPE-20261101-011 — Reject forged or stale supplied TerminalReceipt digests
# Mission: DT-EVO-007 / 7.9 evidence-trust extension; NOT completion of distinct 7.9.2 proof-chain package.
# Executor branch: feature/alphacode-provider; source snapshot: 9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb
# Source blob: tools/doubletake_evolve/claim_receipt/models.py 51bb900549ee4ca9ddc6d236e7afbf090a72b6f0
# Revision: 1; status PREPARED_UNTESTED. No local execution or tests claimed.
# DoD positive: generated and matching supplied digest accepted
# DoD negative: arbitrary digest or changed claim/predecessor with stale digest rejected
# DoD regression: new focused tests and existing test_claim_receipt.py pass under host guard; git diff --check passes.
# DoD evidence: local executor records actual source/branch, tests and DT commit separately from public feedback.
# STOP if branch/source differs, touched path dirty, target test exists, apply-check or tests fail. Never auto-commit/push.
set -euo pipefail
DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_DT_CHECKOUT" >&2; exit 20; }
cd "$DT_ROOT"
[[ -f "tools/doubletake_evolve/runtime/host_workload.py" ]] || { echo "STOP_NOT_DT_SOURCE" >&2; exit 20; }
[[ "$(git branch --show-current)" == "feature/alphacode-provider" ]] || { echo "STOP_WRONG_EXECUTOR_BRANCH" >&2; exit 21; }
printf 'PATCH_ID=BPE-20261101-011\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
[[ -f "tools/doubletake_evolve/claim_receipt/models.py" ]] || { echo "STOP_MISSING_SOURCE" >&2; exit 22; }
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/models.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/models.py"; then
  echo "STOP_DIRTY_TARGET_SOURCE" >&2; exit 23
fi
[[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/models.py")" == "51bb900549ee4ca9ddc6d236e7afbf090a72b6f0" ]] || { echo "STOP_STALE_SOURCE_BLOB" >&2; exit 24; }
[[ ! -e "tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py" && ! -L "tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py" ]] || { echo "STOP_TEST_ALREADY_EXISTS_OR_PATCH_APPLIED" >&2; exit 25; }
PATCH_TEXT="$(cat <<'BPE_DIFF_011_END'
diff --git a/tools/doubletake_evolve/claim_receipt/models.py b/tools/doubletake_evolve/claim_receipt/models.py
--- a/tools/doubletake_evolve/claim_receipt/models.py
+++ b/tools/doubletake_evolve/claim_receipt/models.py
@@ -97,13 +97,14 @@
     receipt_sha256: str = ""
 
     def __post_init__(self) -> None:
-        if self.receipt_sha256:
-            return
-        object.__setattr__(self, "receipt_sha256", canonical_json_digest({
-            "claim_id": self.claim_id,
-            "reported_digest": self.reported_digest,
-            "prev_receipt_digest": self.prev_receipt_digest,
-        }))
+        digest = canonical_json_digest({
+            "claim_id": self.claim_id,
+            "reported_digest": self.reported_digest,
+            "prev_receipt_digest": self.prev_receipt_digest,
+        })
+        if self.receipt_sha256 and self.receipt_sha256 != digest:
+            raise ValueError("TerminalReceipt digest does not match its contents")
+        object.__setattr__(self, "receipt_sha256", digest)
 
 
 @dataclass(frozen=True)
diff --git a/tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py b/tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py
@@ -0,0 +1,30 @@
+"""A supplied receipt digest must match the actual receipt contents."""
+
+from dataclasses import replace
+
+import pytest
+
+from doubletake_evolve.claim_receipt.models import TerminalReceipt
+
+
+def test_generated_digest_and_matching_explicit_digest():
+    receipt = TerminalReceipt("a", "evidence-digest", "")
+    assert receipt.receipt_sha256
+    assert replace(receipt, receipt_sha256=receipt.receipt_sha256) == receipt
+
+
+def test_arbitrary_forged_digest_is_rejected():
+    with pytest.raises(ValueError, match="digest"):
+        TerminalReceipt("a", "evidence-digest", "", receipt_sha256="0" * 64)
+
+
+def test_reusing_digest_after_claim_change_is_rejected():
+    receipt = TerminalReceipt("a", "evidence-digest", "")
+    with pytest.raises(ValueError, match="digest"):
+        replace(receipt, claim_id="other")
+
+
+def test_reusing_digest_after_predecessor_change_is_rejected():
+    receipt = TerminalReceipt("a", "evidence-digest", "")
+    with pytest.raises(ValueError, match="digest"):
+        replace(receipt, prev_receipt_digest="different")
BPE_DIFF_011_END
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CHECK" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
if ! python3 "tools/doubletake_evolve/runtime/host_workload.py" -- python3 -m pytest -q "tools/doubletake_evolve/claim_receipt/test_terminal_receipt_digest_binding.py" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAIL_FOCUSED_TESTS: leave uncommitted changes for review" >&2; exit 32
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/models.py" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PATCH_TESTS_PASSED_BPE-20261101-011: applied locally, NOT committed, NOT independently Ground-verified"
git status --short
