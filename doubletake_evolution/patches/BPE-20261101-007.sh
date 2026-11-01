#!/usr/bin/env bash
# BPE-20261101-007 — Reject a receipt for another claim ID in direct per-claim verification.
# EXECUTOR COMPATIBILITY: feature/alphacode-provider @ b1931476299f5b0dfa7b7222ce2706df9d11a01e (after BPE-20261101-003)
# SOURCE: private DT @ 7b86364f1bbf34c0f04a2b85f21e5fb499fd7719; mission DT-EVO-007 / 7.9 evidence-trust extension
# STATUS: PREPARED_UNTESTED; standalone patch, never claim verified before local testing.
# Positive:** A matching claim ID and correctly digested evidence still produce PASS through the direct `verify_claim` API.
# Negative:** A receipt for a different claim ID, even when its digest matches the provided evidence, returns INVALID rather than PASS. The same result holds for an unseen claim-ID substitution. This remains necessary even when full-chain validation is separately hardened.
# Ground:** Apply-check and new tests plus existing claim-receipt regression suite pass under the guarded host runner; independently verify one unseen negative control, unchanged unrelated behavior, no authorization or retained-state effects, and rollback. Source inspection and patch preparation alone are not a test or a verified fix.
set -euo pipefail
DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP: run inside DT checkout" >&2; exit 20; }
cd "$DT_ROOT"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP: not DT checkout" >&2; exit 20; }
printf 'PATCH_ID=%s\nSTART_HEAD=%s\n' "BPE-20261101-007" "$(git rev-parse HEAD)"
if [[ ! -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]]; then echo "STOP missing tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 21; fi
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py"; then echo "STOP dirty tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 22; fi
if [[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/receipts.py")" != "e0320b4ec4d6ca4431e57c4bc06fb4ee6b22618c" ]]; then echo "STOP source changed; ask patch worker to rebase tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 23; fi
if [[ -e "tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py" || -L "tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py" ]]; then echo "STOP existing tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py" >&2; exit 24; fi
PATCH_TEXT="$(cat <<'BPE_PATCH_PAYLOAD_BPE_20261101_007'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -65,1 +65,8 @@
+    if receipt.claim_id != claim.claim_id:
+        return ClaimVerdict(
+            claim_id=claim.claim_id,
+            verdict=INVALID,
+            reason="receipt claim identity differs from committed claim",
+        )
+
     item = evidence.get(claim.evidence_path)
diff --git a/tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py b/tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py
@@ -0,0 +1,29 @@
+"""Direct per-claim verification must reject a receipt for another claim."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimSpec, EvidenceItem, TerminalReceipt, INVALID, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_claim
+
+
+def _claim():
+    return ClaimSpec(
+        claim_id="a", statement="claim identity", expected_kind="score",
+        evidence_path="ev/a", required_fields=("value",),
+    )
+
+
+def _item():
+    return EvidenceItem(path="ev/a", payload={"value": "42"})
+
+
+def test_receipt_for_different_claim_cannot_verify_current_claim():
+    item = _item()
+    foreign = TerminalReceipt("other", item.content_digest, "")
+    assert verify_claim(_claim(), {"ev/a": item}, foreign).verdict == INVALID
+
+
+def test_receipt_for_matching_claim_still_passes():
+    item = _item()
+    matching = TerminalReceipt("a", item.content_digest, "")
+    assert verify_claim(_claim(), {"ev/a": item}, matching).verdict == PASS
BPE_PATCH_PAYLOAD_BPE_20261101_007
)"
if ! printf '%s\n' "$PATCH_TEXT" | git apply --check -; then echo "STOP git apply check failed; report FAILED/STALE" >&2; exit 30; fi
printf '%s\n' "$PATCH_TEXT" | git apply -
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then echo "FAILED_TESTS: changes remain uncommitted for review" >&2; exit 31; fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/receipts.py" "tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py"
echo "PATCH_TESTS_PASSED: BPE-20261101-007. Applied, not committed or independently Ground-verified."
git status --short
