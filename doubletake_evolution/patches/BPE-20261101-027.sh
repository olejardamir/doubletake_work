#!/usr/bin/env bash
# BPE-20261101-027 | DT-EVO-007 / 7.9.2 | PREPARED_UNTESTED
# Goal: reject duplicate claim IDs in a sealed ClaimReceiptSpec.
# DT main baseline 17c70b0e2b7fec53e46bdeaa35e9e25d76034bd2; tools/doubletake_evolve/claim_receipt/models.py blob 91011f3908399ab228da89778ea063d24c5f50c9
# Independent of BPE-010/026; no authority or production state mutation.
# DoD: unique/empty specs accepted; duplicate definitions and committed IDs rejected;
# existing spec digest, coverage and claim receipt regressions pass.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$root"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 21; }
[[ "$(git branch --show-current)" == "main" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 22; }
src="tools/doubletake_evolve/claim_receipt/models.py"
testfile="tools/doubletake_evolve/claim_receipt/test_sealed_claim_id_uniqueness.py"
[[ -f "$src" && ! -L "$src" ]] || { echo "STOP_MISSING_SOURCE_OR_SYMLINK" >&2; exit 23; }
[[ ! -e "$testfile" && ! -L "$testfile" ]] || { echo "STOP_TEST_ALREADY_EXISTS" >&2; exit 24; }
printf 'PATCH_ID=BPE-20261101-027\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
committed="$(git rev-parse "HEAD:$src" 2>/dev/null)" || { echo "STOP_SOURCE_UNTRACKED" >&2; exit 25; }
if [[ "$committed" != "91011f3908399ab228da89778ea063d24c5f50c9" ]]; then
  echo "NOTICE_COMMITTED_SOURCE_DRIFT: require exact apply context and regression tests" >&2
fi
if ! git diff --quiet -- "$src" || ! git diff --cached --quiet -- "$src"; then
  echo "NOTICE_LOCAL_EDITS: preserve changes; apply-check required" >&2
fi
patch_text="$(cat <<'BPE_DIFF_027'
diff --git a/tools/doubletake_evolve/claim_receipt/models.py b/tools/doubletake_evolve/claim_receipt/models.py
--- a/tools/doubletake_evolve/claim_receipt/models.py
+++ b/tools/doubletake_evolve/claim_receipt/models.py
@@ -56,6 +56,11 @@
     spec_digest: str = ""
 
     def __post_init__(self) -> None:
+        claim_ids = tuple(claim.claim_id for claim in self.claims)
+        if len(claim_ids) != len(set(claim_ids)):
+            raise ValueError("ClaimReceiptSpec duplicate claim_id")
+        if len(self.committed_claim_ids) != len(set(self.committed_claim_ids)):
+            raise ValueError("ClaimReceiptSpec duplicate committed claim_id")
         supplied_digest = self.spec_digest
         digest = canonical_json_digest({
             "spec_id": self.spec_id,
diff --git a/tools/doubletake_evolve/claim_receipt/test_sealed_claim_id_uniqueness.py b/tools/doubletake_evolve/claim_receipt/test_sealed_claim_id_uniqueness.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_sealed_claim_id_uniqueness.py
@@ -0,0 +1,38 @@
+"""A sealed proof must not contain ambiguous duplicate claim identifiers."""
+
+import pytest
+
+from doubletake_evolve.claim_receipt.models import ClaimReceiptSpec, ClaimSpec
+
+
+def _claim(cid):
+    return ClaimSpec(claim_id=cid, statement=cid, expected_kind="score",
+                     evidence_path=f"ev/{cid}")
+
+
+def _spec(claims, committed):
+    return ClaimReceiptSpec(
+        spec_id="unique", version="1", claims=tuple(claims),
+        committed_claim_ids=tuple(committed),
+        sealed_at="2026-11-01T00:00:00Z",
+    )
+
+
+def test_distinct_claims_remain_valid_and_deterministic():
+    first = _spec((_claim("a"), _claim("b")), ("a", "b"))
+    second = _spec((_claim("a"), _claim("b")), ("a", "b"))
+    assert first.spec_digest == second.spec_digest
+
+
+def test_duplicate_claim_definition_is_rejected():
+    with pytest.raises(ValueError, match="duplicate claim_id"):
+        _spec((_claim("a"), _claim("a")), ("a",))
+
+
+def test_duplicate_committed_identifier_is_rejected():
+    with pytest.raises(ValueError, match="duplicate committed claim_id"):
+        _spec((_claim("a"),), ("a", "a"))
+
+
+def test_empty_claim_universe_remains_valid():
+    assert _spec((), ()).committed_claim_ids == ()
BPE_DIFF_027
)"
printf '%s\n' "$patch_text" | git apply --check - || { echo "STOP_APPLY_CONTEXT_OR_DUPLICATE" >&2; exit 30; }
printf '%s\n' "$patch_text" | git apply - || { echo "STOP_APPLY_FAILED" >&2; exit 31; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "$testfile" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py tools/doubletake_evolve/claim_receipt/test_committed_claim_coverage.py; then
  echo "FAIL_FOCUSED_TESTS: leave changes uncommitted for review" >&2; exit 32
fi
git diff --check -- "$src" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PASS_FOCUSED_TESTS_ONLY BPE-20261101-027; not committed, deployed or Ground-verified"
git status --short
