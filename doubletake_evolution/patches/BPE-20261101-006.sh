#!/usr/bin/env bash
# BPE-20261101-006 — Do not count receipts for committed claim IDs absent from the sealed claim set as coverage.
# EXECUTOR COMPATIBILITY: feature/alphacode-provider @ b1931476299f5b0dfa7b7222ce2706df9d11a01e (after BPE-20261101-003)
# SOURCE: private DT @ 7b86364f1bbf34c0f04a2b85f21e5fb499fd7719; mission DT-EVO-007 / 7.9 evidence-trust extension
# STATUS: PREPARED_UNTESTED. Apply and tests are NOT preverified.
# This single file contains the exact source diff, safety checks, test and DoD.
# ONE PATCH PER RUN. Stop if any preflight or test fails. Do not force/push/reset.
# Positive acceptance:** A receipt for a declared committed claim with matching evidence remains covered and produces the existing PASS result.
# Negative acceptance:** Adding a committed claim ID absent from the sealed claims cannot be covered by merely supplying a receipt for that ID; overall all_pass remains false.
# Ground and regression:** The authorized DT executor runs `git apply --check`, the new focused negative tests, the existing `test_claim_receipt.py` regression suite through the host-guarded runner, and an independently constructed unseen variant. Record source revision, test outputs, no unauthorized effects, unchanged unrelated behavior, and a safe rollback. Only actual observed evidence can advance status beyond PREPARED_UNTESTED.
# Failure condition:** Any old valid fixture fails, a negative control is accepted, source/blob differs, or evidence cannot be independently checked; mark FAILED/BLOCKED, do not self-approve.
set -euo pipefail

DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP: run inside the DT Git checkout" >&2; exit 20; }
cd "$DT_ROOT"
if [[ ! -f tools/doubletake_evolve/runtime/host_workload.py ]]; then echo "STOP: this is not a DT checkout" >&2; exit 20; fi
printf 'PATCH_ID=%s\nSTART_HEAD=%s\n' "BPE-20261101-006" "$(git rev-parse HEAD)"
if [[ ! -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]]; then echo "STOP: expected source file missing: tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 21; fi
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py"; then echo "STOP: preserve existing changes in tools/doubletake_evolve/claim_receipt/receipts.py" >&2; exit 22; fi
if [[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/receipts.py")" != "e0320b4ec4d6ca4431e57c4bc06fb4ee6b22618c" ]]; then echo "STOP: source changed: tools/doubletake_evolve/claim_receipt/receipts.py; report STALE and ask Patch Engineer to rebase" >&2; exit 23; fi
if [[ -e "tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py" || -L "tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py" ]]; then echo "STOP: target test file already exists: tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py" >&2; exit 24; fi

PATCH_TEXT="$(cat <<'BPE_PATCH_PAYLOAD_BPE_20261101_006'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -110,1 +110,1 @@
-    covered = committed & set(receipts.keys())
+    covered = committed & set(receipts.keys()) & {c.claim_id for c in spec.claims}
diff --git a/tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py b/tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py
@@ -0,0 +1,41 @@
+"""A receipt cannot cover a committed claim absent from the sealed claim set."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimReceiptSpec, ClaimSpec, EvidenceItem, TerminalReceipt,
+)
+from doubletake_evolve.claim_receipt.receipts import check_coverage, verify_claims
+
+
+def _spec(committed_ids):
+    return ClaimReceiptSpec(
+        spec_id="s", version="1",
+        claims=(ClaimSpec(
+            claim_id="a", statement="sample", expected_kind="score",
+            evidence_path="ev/a", required_fields=("value",),
+        ),),
+        committed_claim_ids=committed_ids, sealed_at="2026-11-01T00:00:00Z",
+    )
+
+
+def _receipts(item):
+    first = TerminalReceipt("a", item.content_digest, "")
+    extra = TerminalReceipt("ghost", "not-an-evidence-digest", first.receipt_sha256)
+    return {"a": first, "ghost": extra}
+
+
+def test_known_committed_claim_is_covered():
+    item = EvidenceItem(path="ev/a", payload={"value": "1"})
+    result = verify_claims(_spec(("a",)), {"ev/a": item}, {"a": _receipts(item)["a"]})
+    assert result.coverage.covered
+    assert result.all_pass
+
+
+def test_unknown_committed_claim_cannot_be_covered_by_unverified_receipt():
+    item = EvidenceItem(path="ev/a", payload={"value": "1"})
+    spec = _spec(("a", "ghost"))
+    receipts = _receipts(item)
+    coverage = check_coverage(spec, receipts)
+    assert not coverage.covered
+    assert "ghost" in coverage.missing_ids
+    result = verify_claims(spec, {"ev/a": item}, receipts)
+    assert not result.all_pass
BPE_PATCH_PAYLOAD_BPE_20261101_006
)"
if ! printf '%s\n' "$PATCH_TEXT" | git apply --check -; then
  echo "STOP: git apply check failed. Preserve work; report patch as FAILED/STALE." >&2
  exit 30
fi
printf '%s\n' "$PATCH_TEXT" | git apply -
echo "Patch applied; running focused host-guarded tests."
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAILED_TESTS: modifications remain uncommitted for inspection; do not claim success." >&2
  exit 31
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/receipts.py" "tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py"
echo "PATCH_TESTS_PASSED: BPE-20261101-006; changes applied, NOT committed or independently Ground-verified."
git status --short
