#!/usr/bin/env bash
# BPE-20261101-026 | DT-EVO-007 / 7.9.2 | PREPARED_UNTESTED
# Goal: reject extra receipts outside the sealed committed proof universe.
# DT main baseline 17c70b0e2b7fec53e46bdeaa35e9e25d76034bd2; tools/doubletake_evolve/claim_receipt/receipts.py blob bc39080efa674bb41f1b8f738130ee90ada9db6a
# Independent of BPE-010's adjacent-link hunk; local overlap check mandatory.
# DoD: exact proof and empty proof pass; well-linked extra and empty-set extra fail.
# Local executor only; never force/reset/stage unrelated files or deploy.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$root"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 21; }
[[ "$(git branch --show-current)" == "main" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 22; }
src="tools/doubletake_evolve/claim_receipt/receipts.py"
testfile="tools/doubletake_evolve/claim_receipt/test_uncommitted_receipt_universe.py"
[[ -f "$src" && ! -L "$src" ]] || { echo "STOP_MISSING_SOURCE_OR_SYMLINK" >&2; exit 23; }
[[ ! -e "$testfile" && ! -L "$testfile" ]] || { echo "STOP_TEST_ALREADY_EXISTS" >&2; exit 24; }
printf 'PATCH_ID=BPE-20261101-026\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
committed="$(git rev-parse "HEAD:$src" 2>/dev/null)" || { echo "STOP_SOURCE_UNTRACKED" >&2; exit 25; }
if [[ "$committed" != "bc39080efa674bb41f1b8f738130ee90ada9db6a" ]]; then
  echo "NOTICE_COMMITTED_SOURCE_DRIFT: require exact context and focused tests" >&2
fi
if ! git diff --quiet -- "$src" || ! git diff --cached --quiet -- "$src"; then
  echo "NOTICE_LOCAL_EDITS: preserve existing edits; apply-check required" >&2
fi
patch_text="$(cat <<'BPE_DIFF_026'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -201,7 +201,14 @@
     n = len(verdicts)
     n_pass = sum(1 for v in verdicts if v.verdict == PASS)
     sufficiency = n_pass / n if n else 1.0
-    all_pass = all(v.verdict == PASS for v in verdicts) and coverage.covered and chain.chain_valid
+    # A sealed proof cannot accept receipts outside its committed universe.
+    # An extra receipt may have a valid chain without belonging to this spec.
+    unexpected_receipts = set(receipts) - set(spec.committed_claim_ids)
+    all_pass = (
+        all(v.verdict == PASS for v in verdicts)
+        and coverage.covered and chain.chain_valid
+        and not unexpected_receipts
+    )
 
     return ReceiptVerification(
         spec_digest=spec.spec_digest,
diff --git a/tools/doubletake_evolve/claim_receipt/test_uncommitted_receipt_universe.py b/tools/doubletake_evolve/claim_receipt/test_uncommitted_receipt_universe.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_uncommitted_receipt_universe.py
@@ -0,0 +1,47 @@
+"""Reject extra receipts outside the sealed committed claim set."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimReceiptSpec, ClaimSpec, EvidenceItem, TerminalReceipt, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_claims
+
+
+def _spec(*ids):
+    return ClaimReceiptSpec(
+        spec_id="sealed-universe", version="1",
+        claims=tuple(
+            ClaimSpec(claim_id=cid, statement=cid, expected_kind="score",
+                      evidence_path=f"ev/{cid}", required_fields=("value",))
+            for cid in ids
+        ),
+        committed_claim_ids=ids, sealed_at="2026-11-01T00:00:00Z",
+    )
+
+
+def test_exact_universe_passes():
+    item = EvidenceItem(path="ev/a", payload={"value": "ok"})
+    first = TerminalReceipt("a", item.content_digest, "")
+    result = verify_claims(_spec("a"), {"ev/a": item}, {"a": first})
+    assert result.all_pass and result.chain.chain_valid
+
+
+def test_extra_validly_linked_receipt_fails_aggregate():
+    item = EvidenceItem(path="ev/a", payload={"value": "ok"})
+    first = TerminalReceipt("a", item.content_digest, "")
+    extra = TerminalReceipt("z-extra", item.content_digest, first.receipt_sha256)
+    result = verify_claims(_spec("a"), {"ev/a": item},
+                           {"a": first, "z-extra": extra})
+    assert result.coverage.covered and result.chain.chain_valid
+    assert all(v.verdict == PASS for v in result.verdicts)
+    assert not result.all_pass
+
+
+def test_empty_universe_rejects_extra_receipt():
+    extra = TerminalReceipt("extra", "digest", "")
+    result = verify_claims(_spec(), {}, {"extra": extra})
+    assert result.coverage.covered and result.chain.chain_valid
+    assert not result.all_pass
+
+
+def test_empty_universe_without_receipts_passes():
+    assert verify_claims(_spec(), {}, {}).all_pass
BPE_DIFF_026
)"
printf '%s\n' "$patch_text" | git apply --check - || { echo "STOP_APPLY_CONTEXT_OR_DUPLICATE" >&2; exit 30; }
printf '%s\n' "$patch_text" | git apply - || { echo "STOP_APPLY_FAILED" >&2; exit 31; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "$testfile" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py; then
  echo "FAIL_FOCUSED_TESTS: leave changes uncommitted for review" >&2; exit 32
fi
git diff --check -- "$src" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PASS_FOCUSED_TESTS_ONLY BPE-20261101-026; not committed, deployed or Ground-verified"
git status --short
