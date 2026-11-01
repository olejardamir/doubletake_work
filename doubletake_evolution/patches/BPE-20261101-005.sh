#!/usr/bin/env bash
# BPE-20261101-005 — Reject externally supplied sealed-spec digests that do not match current claim contents.
# EXECUTOR COMPATIBILITY: feature/alphacode-provider @ b1931476299f5b0dfa7b7222ce2706df9d11a01e (after BPE-20261101-003)
# SOURCE: private DT @ 7b86364f1bbf34c0f04a2b85f21e5fb499fd7719; mission DT-EVO-007 / 7.9 evidence-trust extension
# STATUS: PREPARED_UNTESTED. Apply and tests are NOT preverified.
# This single file contains the exact source diff, safety checks, test and DoD.
# ONE PATCH PER RUN. Stop if any preflight or test fails. Do not force/push/reset.
# Positive acceptance:** An externally supplied seal identical to the independently recomputed digest is accepted; existing generated specs remain stable.
# Negative acceptance:** A supplied arbitrary digest or a reused old digest after modifying the sealed claim is rejected with a typed error before a false verification result.
# Ground and regression:** The authorized DT executor runs `git apply --check`, the new focused negative tests, the existing `test_claim_receipt.py` regression suite through the host-guarded runner, and an independently constructed unseen variant. Record source revision, test outputs, no unauthorized effects, unchanged unrelated behavior, and a safe rollback. Only actual observed evidence can advance status beyond PREPARED_UNTESTED.
# Failure condition:** Any old valid fixture fails, a negative control is accepted, source/blob differs, or evidence cannot be independently checked; mark FAILED/BLOCKED, do not self-approve.
set -euo pipefail

DT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP: run inside the DT Git checkout" >&2; exit 20; }
cd "$DT_ROOT"
if [[ ! -f tools/doubletake_evolve/runtime/host_workload.py ]]; then echo "STOP: this is not a DT checkout" >&2; exit 20; fi
printf 'PATCH_ID=%s\nSTART_HEAD=%s\n' "BPE-20261101-005" "$(git rev-parse HEAD)"
if [[ ! -f "tools/doubletake_evolve/claim_receipt/models.py" ]]; then echo "STOP: expected source file missing: tools/doubletake_evolve/claim_receipt/models.py" >&2; exit 21; fi
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/models.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/models.py"; then echo "STOP: preserve existing changes in tools/doubletake_evolve/claim_receipt/models.py" >&2; exit 22; fi
if [[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/models.py")" != "6806ec309b405f2b7f692aa0ee5341cf590e7839" ]]; then echo "STOP: source changed: tools/doubletake_evolve/claim_receipt/models.py; report STALE and ask Patch Engineer to rebase" >&2; exit 23; fi
if [[ -e "tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py" || -L "tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py" ]]; then echo "STOP: target test file already exists: tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py" >&2; exit 24; fi

PATCH_TEXT="$(cat <<'BPE_PATCH_PAYLOAD_BPE_20261101_005'
diff --git a/tools/doubletake_evolve/claim_receipt/models.py b/tools/doubletake_evolve/claim_receipt/models.py
--- a/tools/doubletake_evolve/claim_receipt/models.py
+++ b/tools/doubletake_evolve/claim_receipt/models.py
@@ -59,2 +59,1 @@
-        if self.spec_digest:
-            return
+        supplied_digest = self.spec_digest
@@ -73,1 +72,3 @@
+        if supplied_digest and supplied_digest != digest:
+            raise ValueError("ClaimReceiptSpec digest does not match its contents")
         object.__setattr__(self, "spec_digest", digest)
diff --git a/tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py b/tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py
@@ -0,0 +1,35 @@
+"""A pre-sealed claim specification must match its declared digest."""
+
+from dataclasses import replace
+
+import pytest
+
+from doubletake_evolve.claim_receipt.models import ClaimReceiptSpec, ClaimSpec
+
+
+def _spec():
+    return ClaimReceiptSpec(
+        spec_id="s", version="1",
+        claims=(ClaimSpec(
+            claim_id="a", statement="original", expected_kind="score",
+            evidence_path="ev/a", required_fields=("value",),
+        ),),
+        committed_claim_ids=("a",), sealed_at="2026-11-01T00:00:00Z",
+    )
+
+
+def test_matching_external_seal_is_accepted():
+    spec = _spec()
+    assert replace(spec, spec_digest=spec.spec_digest).spec_digest == spec.spec_digest
+
+
+def test_arbitrary_external_seal_is_rejected():
+    with pytest.raises(ValueError, match="digest"):
+        replace(_spec(), spec_digest="0" * 64)
+
+
+def test_reusing_old_seal_after_claim_mutation_is_rejected():
+    spec = _spec()
+    changed_claim = replace(spec.claims[0], statement="changed")
+    with pytest.raises(ValueError, match="digest"):
+        replace(spec, claims=(changed_claim,))
BPE_PATCH_PAYLOAD_BPE_20261101_005
)"
if ! printf '%s\n' "$PATCH_TEXT" | git apply --check -; then
  echo "STOP: git apply check failed. Preserve work; report patch as FAILED/STALE." >&2
  exit 30
fi
printf '%s\n' "$PATCH_TEXT" | git apply -
echo "Patch applied; running focused host-guarded tests."
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAILED_TESTS: modifications remain uncommitted for inspection; do not claim success." >&2
  exit 31
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/models.py" "tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py"
echo "PATCH_TESTS_PASSED: BPE-20261101-005; changes applied, NOT committed or independently Ground-verified."
git status --short
