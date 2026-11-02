#!/usr/bin/env bash
# BPE-20261101-010 — Require contiguous ordered receipt links and chain validity for overall success
# Mission: DT-EVO-007 / 7.9 evidence-trust extension; NOT completion of distinct 7.9.2 proof-chain package.
# Executor branch: feature/alphacode-provider; source snapshot: 03d09b55f0c37966144f425661f39313ce0f2830
# Source blob: tools/doubletake_evolve/claim_receipt/receipts.py bc39080efa674bb41f1b8f738130ee90ada9db6a
# Revision: 3; PREPARED_UNTESTED / LOCAL_APPLY_UNVERIFIED; rebased after BPE-013 already integrated all_pass gate. Only strict adjacency remains.
# DoD positive: one/two correctly linked receipts remain valid and all_pass
# DoD negative: two anchors, unknown predecessor, disconnected singleton, and skipped-middle receipt are rejected even when per-claim evidence matches
# DoD regression: new focused tests and existing test_claim_receipt.py pass under host guard; git diff --check passes.
# DoD evidence: local executor records actual source/branch, tests and DT commit separately from public feedback.
# STOP if committed source differs, target test exists, apply-check or tests fail. Preserve prior edits; never stage/commit/push.
set -euo pipefail
DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_DT_CHECKOUT" >&2; exit 20; }
cd "$DT_ROOT"
[[ -f "tools/doubletake_evolve/runtime/host_workload.py" ]] || { echo "STOP_NOT_DT_SOURCE" >&2; exit 20; }
[[ "$(git branch --show-current)" == "feature/alphacode-provider" ]] || { echo "STOP_WRONG_EXECUTOR_BRANCH" >&2; exit 21; }
printf 'PATCH_ID=BPE-20261101-010\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
[[ -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]] || { echo "STOP_MISSING_SOURCE" >&2; exit 22; }
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/receipts.py"; then
  echo "NOTICE_LOCAL_EDITS: actual overlap determined by git apply --check; preserve prior edits" >&2
fi
[[ "$(git rev-parse "HEAD:tools/doubletake_evolve/claim_receipt/receipts.py")" == "bc39080efa674bb41f1b8f738130ee90ada9db6a" ]] || { echo "STOP_STALE_SOURCE_BLOB" >&2; exit 24; }
[[ ! -e "tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py" && ! -L "tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py" ]] || { echo "STOP_TEST_ALREADY_EXISTS_OR_PATCH_APPLIED" >&2; exit 25; }
PATCH_TEXT="$(cat <<'BPE_DIFF_010_END'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -156,22 +156,17 @@
     # Deterministic ordering by claim_id
     ordered = sorted(receipts.values(), key=lambda r: r.claim_id)
 
-    chain_digests: list[str] = []
-    gaps: list[str] = []
-    seen_digests: set[str] = set()
-
-    for r in ordered:
-        chain_digests.append(r.receipt_sha256)
-        seen_digests.add(r.receipt_sha256)
-
-        if r.prev_receipt_digest == "":
-            # First receipt in chain — valid anchor
-            continue
-
-        if r.prev_receipt_digest not in seen_digests:
-            gaps.append(r.claim_id)
-
-    chain_valid = len(gaps) == 0
+    chain_digests: list[str] = []
+    gaps: list[str] = []
+    expected_predecessor = ""
+
+    for r in ordered:
+        chain_digests.append(r.receipt_sha256)
+        if r.prev_receipt_digest != expected_predecessor:
+            gaps.append(r.claim_id)
+        expected_predecessor = r.receipt_sha256
+
+    chain_valid = not gaps
     chain_digest = sha256_text("|".join(chain_digests))
 
     return ReceiptChain(
diff --git a/tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py b/tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py
@@ -0,0 +1,93 @@
+"""Chain continuity is mandatory for an aggregate success verdict."""
+
+from doubletake_evolve.claim_receipt.models import (
+    ClaimReceiptSpec, ClaimSpec, EvidenceItem, TerminalReceipt, PASS,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_chain, verify_claims
+
+
+def _case(predecessor=None):
+    spec = ClaimReceiptSpec(
+        spec_id="chain", version="1",
+        claims=tuple(
+            ClaimSpec(claim_id=cid, statement=cid, expected_kind="score",
+                      evidence_path=f"ev/{cid}", required_fields=("value",))
+            for cid in ("a", "b")
+        ),
+        committed_claim_ids=("a", "b"), sealed_at="2026-11-01T00:00:00Z",
+    )
+    evidence = {
+        cid: EvidenceItem(path=f"ev/{cid}", payload={"value": cid})
+        for cid in ("a", "b")
+    }
+    first = TerminalReceipt("a", evidence["a"].content_digest, "")
+    second = TerminalReceipt(
+        "b", evidence["b"].content_digest,
+        first.receipt_sha256 if predecessor is None else predecessor,
+    )
+    return spec, {f"ev/{k}": v for k, v in evidence.items()}, {"a": first, "b": second}
+
+
+def test_valid_two_receipt_chain_and_full_coverage_pass():
+    spec, evidence, receipts = _case()
+    result = verify_claims(spec, evidence, receipts)
+    assert result.chain.chain_valid
+    assert result.coverage.covered
+    assert result.all_pass
+
+
+def test_second_anchor_is_not_a_valid_predecessor():
+    spec, evidence, receipts = _case("")
+    result = verify_claims(spec, evidence, receipts)
+    assert all(v.verdict == PASS for v in result.verdicts)
+    assert result.coverage.covered
+    assert not result.chain.chain_valid
+    assert result.chain.gaps == ("b",)
+    assert not result.all_pass
+
+
+def test_unknown_predecessor_cannot_yield_overall_success():
+    spec, evidence, receipts = _case("not-a-predecessor")
+    result = verify_claims(spec, evidence, receipts)
+    assert result.coverage.covered
+    assert all(v.verdict == PASS for v in result.verdicts)
+    assert not result.chain.chain_valid
+    assert not result.all_pass
+
+
+def test_single_receipt_with_unconnected_predecessor_is_invalid():
+    receipt = TerminalReceipt("a", "digest", "not-an-anchor")
+    chain = verify_chain({"a": receipt})
+    assert not chain.chain_valid
+    assert chain.gaps == ("a",)
+
+
+def test_reversed_mapping_insertion_keeps_valid_order():
+    spec, evidence, receipts = _case()
+    result = verify_claims(spec, evidence, {"b": receipts["b"], "a": receipts["a"]})
+    assert result.chain.chain_valid
+    assert result.all_pass
+    assert [r.claim_id for r in result.chain.receipts] == ["a", "b"]
+
+
+def test_skipped_middle_receipt_does_not_count_as_contiguous_chain():
+    ids = ("a", "b", "c")
+    spec = ClaimReceiptSpec(
+        spec_id="skip", version="1",
+        claims=tuple(
+            ClaimSpec(claim_id=cid, statement=cid, expected_kind="score",
+                      evidence_path=f"ev/{cid}", required_fields=("value",))
+            for cid in ids
+        ),
+        committed_claim_ids=ids, sealed_at="2026-11-01T00:00:00Z",
+    )
+    evidence = {f"ev/{cid}": EvidenceItem(path=f"ev/{cid}", payload={"value": cid}) for cid in ids}
+    first = TerminalReceipt("a", evidence["ev/a"].content_digest, "")
+    middle = TerminalReceipt("b", evidence["ev/b"].content_digest, first.receipt_sha256)
+    last = TerminalReceipt("c", evidence["ev/c"].content_digest, first.receipt_sha256)
+    result = verify_claims(spec, evidence, {"a": first, "b": middle, "c": last})
+    assert result.coverage.covered
+    assert all(v.verdict == PASS for v in result.verdicts)
+    assert not result.chain.chain_valid
+    assert result.chain.gaps == ("c",)
+    assert not result.all_pass
BPE_DIFF_010_END
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CHECK" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
if ! python3 "tools/doubletake_evolve/runtime/host_workload.py" -- python3 -m pytest -q "tools/doubletake_evolve/claim_receipt/test_chain_continuity_gate.py" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAIL_FOCUSED_TESTS: leave uncommitted changes for review" >&2; exit 32
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/receipts.py" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PATCH_TESTS_PASSED_BPE-20261101-010: applied locally, NOT committed, NOT independently Ground-verified"
git status --short
