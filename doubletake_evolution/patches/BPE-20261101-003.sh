#!/usr/bin/env bash
# BPE-20261101-003 — Recompute evidence digest from actual payload instead of trusting a stale or caller-supplied cached digest.
# SOURCE: private DT @ 7b86364f1bbf34c0f04a2b85f21e5fb499fd7719; mission DT-EVO-007 / 7.9 evidence-trust extension
# STATUS: PREPARED_UNTESTED. Apply and tests are NOT preverified.
# This single file contains the exact source diff, safety checks, test and DoD.
# ONE PATCH PER RUN. Stop if any preflight or test fails. Do not force/push/reset.
# Positive acceptance:** An unchanged evidence payload still produces the same recomputed digest and PASS against a matching receipt.
# Negative acceptance:** Mutating a payload after EvidenceItem construction invalidates its original receipt; an arbitrary caller-supplied cached content_digest cannot make mismatched payload pass.
# Ground and regression:** The authorized DT executor runs `git apply --check`, the new focused negative tests, the existing `test_claim_receipt.py` regression suite through the host-guarded runner, and an independently constructed unseen variant. Record source revision, test outputs, no unauthorized effects, unchanged unrelated behavior, and a safe rollback. Only actual observed evidence can advance status beyond PREPARED_UNTESTED.
# Failure condition:** Any old valid fixture fails, a negative control is accepted, source/blob differs, or evidence cannot be independently checked; mark FAILED/BLOCKED, do not self-approve.
set -euo pipefail

DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP: run inside the DT Git checkout" >&2; exit 20; }
cd "$DT_ROOT"
if [[ ! -f tools/doubletake_evolve/runtime/host_workload.py ]]; then echo "STOP: this is not a DT checkout" >&2; exit 20; fi
printf 'PATCH_ID=%s\nSTART_HEAD=%s\n' "BPE-20261101-003" "$(git rev-parse HEAD)"
if [[ ! -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]]; then echo "STOP: expected source file missing: tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 21; fi
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py"; then echo "STOP: preserve existing changes in tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 22; fi
if [[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/receipts.py")" != "a304c64d15db4ed37b94e491b4deebc9738b23ad" ]]; then echo "STOP: source changed: tools/doubletake_evolve/claim_receipt/receipts.py; report STALE and ask Patch Engineer to rebase" >&2; exit 23; fi
if [[ -e "tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py" || -L "tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py" ]]; then echo "STOP: target test file already exists: tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py" >&2; exit 24; fi

PATCH_TEXT="$(cat <<'BPE_PATCH_PAYLOAD_BPE_20261101_003'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -11,1 +11,1 @@
-from doubletake_evolve._shared.crypto_utils import sha256_text
+from doubletake_evolve._shared.crypto_utils import canonical_json_digest, sha256_text
@@ -39,1 +39,1 @@
-    return item.content_digest
+    return canonical_json_digest(item.payload)
diff --git a/tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py b/tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py
@@ -0,0 +1,43 @@
+"""Fail closed when a cached evidence digest disagrees with actual payload bytes."""
+
+from doubletake_evolve._shared.crypto_utils import canonical_json_digest
+from doubletake_evolve.claim_receipt.models import (
+    ClaimSpec, EvidenceItem, TerminalReceipt, INVALID, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import (
+    recompute_evidence_digest, verify_claim,
+)
+
+
+def _claim():
+    return ClaimSpec(
+        claim_id="a", statement="payload", expected_kind="score",
+        evidence_path="ev/a", required_fields=("value",),
+    )
+
+
+def _receipt(digest):
+    return TerminalReceipt(
+        claim_id="a", reported_digest=digest, prev_receipt_digest="",
+    )
+
+
+def test_unchanged_payload_remains_valid():
+    item = EvidenceItem(path="ev/a", payload={"value": "original"})
+    assert recompute_evidence_digest(item) == canonical_json_digest(item.payload)
+    assert verify_claim(_claim(), {"ev/a": item}, _receipt(item.content_digest)).verdict == PASS
+
+
+def test_mutating_payload_after_construction_invalidates_original_receipt():
+    item = EvidenceItem(path="ev/a", payload={"value": "original"})
+    receipt = _receipt(item.content_digest)
+    item.payload["value"] = "tampered"
+    assert recompute_evidence_digest(item) == canonical_json_digest(item.payload)
+    assert verify_claim(_claim(), {"ev/a": item}, receipt).verdict == INVALID
+
+
+def test_supplied_forged_cached_digest_cannot_override_payload():
+    item = EvidenceItem(
+        path="ev/a", payload={"value": "real"}, content_digest="0" * 64,
+    )
+    assert verify_claim(_claim(), {"ev/a": item}, _receipt("0" * 64)).verdict == INVALID
BPE_PATCH_PAYLOAD_BPE_20261101_003
)"
if ! printf '%s\n' "$PATCH_TEXT" | git apply --check -; then
  echo "STOP: git apply check failed. Preserve work; report patch as FAILED/STALE." >&2
  exit 30
fi
printf '%s\n' "$PATCH_TEXT" | git apply -
echo "Patch applied; running focused host-guarded tests."
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAILED_TESTS: modifications remain uncommitted for inspection; do not claim success." >&2
  exit 31
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/receipts.py" "tools/doubletake_evolve/claim_receipt/test_evidence_payload_digest.py"
echo "PATCH_TESTS_PASSED: BPE-20261101-003; changes applied, NOT committed or independently Ground-verified."
git status --short
