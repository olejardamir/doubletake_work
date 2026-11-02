#!/usr/bin/env bash
# BPE-20261101-002 rev2 | DT-EVO-007 / 7.9.2 canonical receipt-chain acceptance
# Prepared against DT feature/alphacode-provider HEAD 9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb
# SOURCE receipts.py blob 5d2e9ce04089f14d1b7b2b02615cca7d1a1649f0, tests blob 0cbf09e728f483788d63c5b016cdd4df3d728c6e
# PREPARED_UNTESTED; prior local attempt blocked by working-tree edits, not proven source drift.
# Precise goal can be integrated minimally by Clai when existing edits overlap; never force/reset/overwrite.
# GOAL: fail closed on invalid predecessor continuity, forged receipt hash, false overall success.
# POSITIVE: valid single and ordered receipt chains continue to verify.
# NEGATIVE: second/disconnected root, skipped predecessor, forged hash or wrong receipt key rejected;
#          valid per-claim evidence cannot produce all_pass=true when continuity fails.
# CONFLICT: alternative to BPE-010's chain fix; do not apply both blindly. If one is integrated, 
#           mark the other superseded and reconcile dependent scripts.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[[ -f "tools/doubletake_evolve/claim_receipt/receipts.py" ]] || { echo 'STOP not a DT checkout'; exit 20; }
echo "PATCH_ID=BPE-20261101-002 HEAD=$(git rev-parse HEAD) BRANCH=$(git branch --show-current)"
# Preserve existing worktree edits from preceding patches; validate the actual patch context.
# Committed SHA checks provide provenance, not a blanket lock on unrelated edits.
for entry in \
  "tools/doubletake_evolve/claim_receipt/receipts.py:5d2e9ce04089f14d1b7b2b02615cca7d1a1649f0" \
  "tools/doubletake_evolve/claim_receipt/test_claim_receipt.py:0cbf09e728f483788d63c5b016cdd4df3d728c6e"; do
  path="${entry%%:*}"
  expected="${entry#*:}"
  [[ -f "$path" && ! -L "$path" ]] || { echo "BLOCKED_MISSING_OR_SYMLINK_PATH: $path" >&2; exit 21; }
  head_blob="$(git rev-parse "HEAD:$path" 2>/dev/null || true)"
  if [[ "$head_blob" != "$expected" ]]; then
    echo "NOTICE_HEAD_SOURCE_CHANGED: $path ($head_blob); review compatibility and tests" >&2
  fi
  if ! git diff --quiet -- "$path" || ! git diff --cached --quiet -- "$path"; then
    echo "NOTICE_LOCAL_EDITS: $path; preserve prior edits, stage only relevant changes after testing" >&2
  fi
done
patch_text="$(cat <<'BPE_002_UNIFIED_PATCH'
diff --git a/tools/doubletake_evolve/claim_receipt/receipts.py b/tools/doubletake_evolve/claim_receipt/receipts.py
--- a/tools/doubletake_evolve/claim_receipt/receipts.py
+++ b/tools/doubletake_evolve/claim_receipt/receipts.py
@@ -144,18 +144,22 @@
 
     chain_digests: list[str] = []
     gaps: list[str] = []
+    previous_digest = ""
-    seen_digests: set[str] = set()
 
     for r in ordered:
         chain_digests.append(r.receipt_sha256)
+        expected_digest = canonical_json_digest({
+            "claim_id": r.claim_id,
+            "reported_digest": r.reported_digest,
+            "prev_receipt_digest": r.prev_receipt_digest,
+        })
+        # Membership alone accepts multiple anchors, skipped predecessors and
+        # caller-supplied forged digests. Require one ordered, recomputed chain.
+        if (r.prev_receipt_digest != previous_digest
+                or r.receipt_sha256 != expected_digest
+                or receipts.get(r.claim_id) is not r):
-        seen_digests.add(r.receipt_sha256)
-
-        if r.prev_receipt_digest == "":
-            # First receipt in chain — valid anchor
-            continue
-
-        if r.prev_receipt_digest not in seen_digests:
             gaps.append(r.claim_id)
+        previous_digest = r.receipt_sha256
 
     chain_valid = len(gaps) == 0
     chain_digest = sha256_text("|".join(chain_digests))
@@ -187,7 +191,8 @@
     n = len(verdicts)
     n_pass = sum(1 for v in verdicts if v.verdict == PASS)
     sufficiency = n_pass / n if n else 1.0
+    all_pass = (all(v.verdict == PASS for v in verdicts)
+                and coverage.covered and chain.chain_valid)
-    all_pass = all(v.verdict == PASS for v in verdicts) and coverage.covered
 
     return ReceiptVerification(
         spec_digest=spec.spec_digest,
diff --git a/tools/doubletake_evolve/claim_receipt/test_claim_receipt.py b/tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
--- a/tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
+++ b/tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
@@ -153,6 +153,29 @@
         assert ch.chain_valid is False
         assert "b" in ch.gaps
 
+    def test_disconnected_second_anchor_is_invalid(self):
+        a = _make_receipt("a", "d1")
+        b = _make_receipt("b", "d2")
+        chain = verify_chain({"a": a, "b": b})
+        assert chain.chain_valid is False
+        assert "b" in chain.gaps
+
+    def test_skipped_predecessor_is_invalid(self):
+        a = _make_receipt("a", "d1")
+        b = _make_receipt("b", "d2", prev=a.receipt_sha256)
+        c = _make_receipt("c", "d3", prev=a.receipt_sha256)
+        chain = verify_chain({"a": a, "b": b, "c": c})
+        assert chain.chain_valid is False
+        assert "c" in chain.gaps
+
+    def test_forged_receipt_digest_is_invalid(self):
+        r = TerminalReceipt("a", "d1", "", receipt_sha256="forged")
+        assert verify_chain({"a": r}).chain_valid is False
+
+    def test_receipt_key_must_match_claim_id(self):
+        r = _make_receipt("a", "d1")
+        assert verify_chain({"wrong-key": r}).chain_valid is False
+
     def test_chain_ordering_by_claim_id(self):
         r1 = _make_receipt("a", "d1", prev="")
         r2 = _make_receipt("b", "d2", prev=r1.receipt_sha256)
@@ -179,6 +202,18 @@
         assert result.sufficiency_fraction == 1.0
         assert result.coverage.covered is True
 
+    def test_matching_evidence_but_disconnected_chain_does_not_pass(self):
+        spec = _make_spec("a", "b")
+        a = _make_evidence("ev/a", "1")
+        b = _make_evidence("ev/b", "2")
+        ra = _make_receipt("a", recompute_evidence_digest(a))
+        rb = _make_receipt("b", recompute_evidence_digest(b))
+        result = verify_claims(spec, {"ev/a": a, "ev/b": b}, {"a": ra, "b": rb})
+        assert result.sufficiency_fraction == 1.0
+        assert result.coverage.covered is True
+        assert result.chain.chain_valid is False
+        assert result.all_pass is False
+
     def test_missing_receipt_yields_inconclusive_coverage(self):
         spec = _make_spec("a", "b")
         item = EvidenceItem(path="ev/a", payload={"value": "1"})
BPE_002_UNIFIED_PATCH
)"
if ! printf '%s\n' "$patch_text" | git apply --check -; then
  echo "BLOCKED_LOCAL_OVERLAP_OR_ALREADY_IMPLEMENTED: this script changed no files." >&2
  echo "Clai: inspect existing verify_chain() and verify_claims(), preserve earlier changes," >&2
  echo "implement only missing ordered-link, digest and aggregate-failure behavior," >&2
  echo "run focused positive/negative tests, then commit/push only verified changes." >&2
  echo "A worktree conflict is not proof that the committed GitHub baseline is stale." >&2
  exit 30
fi
printf '%s\n' "$patch_text" | git apply -
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
git diff --check -- tools/doubletake_evolve/claim_receipt/receipts.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
echo 'PASS focused tests. Run independent unseen negative and regression before authorized commit/push. Publish sanitized feedback separately.'
