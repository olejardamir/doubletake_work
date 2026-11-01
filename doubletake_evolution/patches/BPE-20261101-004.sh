#!/usr/bin/env bash
# BPE-20261101-004 — Reject evidence whose embedded path disagrees with the committed evidence path.
# SOURCE: private DT @ 7b86364f1bbf34c0f04a2b85f21e5fb499fd7719; mission DT-EVO-007 / 7.9 evidence-trust extension
# STATUS: PREPARED_UNTESTED. Apply and tests are NOT preverified.
# This single file contains the exact source diff, safety checks, test and DoD.
# ONE PATCH PER RUN. Stop if any preflight or test fails. Do not force/push/reset.
# Positive acceptance:** An evidence item with its own path matching the committed path still passes with valid required fields and matching digest.
# Negative acceptance:** Mapping an EvidenceItem under a committed key while its own path points elsewhere yields INVALID, even with matching payload digest.
# Ground and regression:** The authorized DT executor runs `git apply --check`, the new focused negative tests, the existing `test_claim_receipt.py` regression suite through the host-guarded runner, and an independently constructed unseen variant. Record source revision, test outputs, no unauthorized effects, unchanged unrelated behavior, and a safe rollback. Only actual observed evidence can advance status beyond PREPARED_UNTESTED.
# Failure condition:** Any old valid fixture fails, a negative control is accepted, source/blob differs, or evidence cannot be independently checked; mark FAILED/BLOCKED, do not self-approve.
set -euo pipefail

DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP: run inside the DT Git checkout" >&2; exit 20; }
cd "$DT_ROOT"
if [[ ! -f tools/doubletake_evolve/runtime/host_workload.py ]]; then echo "STOP: this is not a DT checkout" >&2; exit 20; fi
printf 'PATCH_ID=%s\nSTART_HEAD=%s\n' "BPE-20261101-004" "$(git rev-parse HEAD)"
if [[ ! -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]]; then echo "STOP: expected source file missing: tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 21; fi
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py"; then echo "STOP: preserve existing changes in tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 22; fi
if [[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/receipts.py")" != "a304c64d15db4ed37b94e491b4deebc9738b23ad" ]]; then echo "STOP: source changed: tools/doubletake_evolve/claim_receipt/receipts.py; report STALE and ask Patch Engineer to rebase" >&2; exit 23; fi
if [[ -e "tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py" || -L "tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py" ]]; then echo "STOP: target test file already exists: tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py" >&2; exit 24; fi

PATCH_TEXT="$(cat <<'BPE_PATCH_PAYLOAD_BPE_20261101_004'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -73,1 +73,8 @@
+    if item.path != claim.evidence_path:
+        return ClaimVerdict(
+            claim_id=claim.claim_id,
+            verdict=INVALID,
+            reason="evidence path identity differs from committed claim",
+        )
+
     # Check required fields
diff --git a/tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py b/tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py
@@ -0,0 +1,30 @@
+"""The committed evidence path must agree with the item's own identity."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimSpec, EvidenceItem, TerminalReceipt, INVALID, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_claim
+
+
+def _claim():
+    return ClaimSpec(
+        claim_id="a", statement="path binding", expected_kind="score",
+        evidence_path="ev/a", required_fields=("value",),
+    )
+
+
+def _receipt(item):
+    return TerminalReceipt(
+        claim_id="a", reported_digest=item.content_digest, prev_receipt_digest="",
+    )
+
+
+def test_mapping_key_cannot_launder_mismatched_evidence_path():
+    item = EvidenceItem(path="ev/other", payload={"value": "42"})
+    verdict = verify_claim(_claim(), {"ev/a": item}, _receipt(item))
+    assert verdict.verdict == INVALID
+
+
+def test_correct_evidence_path_still_passes():
+    item = EvidenceItem(path="ev/a", payload={"value": "42"})
+    assert verify_claim(_claim(), {"ev/a": item}, _receipt(item)).verdict == PASS
BPE_PATCH_PAYLOAD_BPE_20261101_004
)"
if ! printf '%s\n' "$PATCH_TEXT" | git apply --check -; then
  echo "STOP: git apply check failed. Preserve work; report patch as FAILED/STALE." >&2
  exit 30
fi
printf '%s\n' "$PATCH_TEXT" | git apply -
echo "Patch applied; running focused host-guarded tests."
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAILED_TESTS: modifications remain uncommitted for inspection; do not claim success." >&2
  exit 31
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/receipts.py" "tools/doubletake_evolve/claim_receipt/test_evidence_path_binding.py"
echo "PATCH_TESTS_PASSED: BPE-20261101-004; changes applied, NOT committed or independently Ground-verified."
git status --short
