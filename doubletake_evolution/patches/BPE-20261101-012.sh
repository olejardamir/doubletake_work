#!/usr/bin/env bash
# BPE-20261101-012 — Return nonzero exit status when claim verification fails.
# Mission: DT-EVO-007 / 7.9 evidence-trust extension; CLI consumer, not proof of 7.9.2 completion.
# Source: olejardamir/DT feature/alphacode-provider @ 9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb; tools/doubletake_evolve/claim_receipt/cli.py blob 56d52e2f724042567d11d1f1635601bcc413d9fe
# Revision 1 / PREPARED_UNTESTED; local apply and tests have NOT been run.
# DoD positive: valid evidence and receipt preserve JSON report and success exit.
# DoD negative: invalid digest produces JSON with all_pass=false AND nonzero exit.
# DoD regression: focused new CLI tests and existing claim receipt suite pass with host guard.
# Stop if source/test conflict, dirty target, apply check fails or tests fail. Do not auto-commit/push.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT_CHECKOUT" >&2; exit 20; }
cd "$ROOT"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 20; }
[[ "$(git branch --show-current)" == "feature/alphacode-provider" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 21; }
[[ -f "tools/doubletake_evolve/claim_receipt/cli.py" ]] || { echo "STOP_SOURCE_MISSING" >&2; exit 22; }
if ! git diff --quiet -- "tools/doubletake_evolve/claim_receipt/cli.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/claim_receipt/cli.py"; then echo "STOP_DIRTY_SOURCE" >&2; exit 23; fi
[[ "$(git hash-object -- "tools/doubletake_evolve/claim_receipt/cli.py")" == "56d52e2f724042567d11d1f1635601bcc413d9fe" ]] || { echo "STOP_STALE_BLOB" >&2; exit 24; }
[[ ! -e "tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py" && ! -L "tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py" ]] || { echo "STOP_TEST_ALREADY_EXISTS" >&2; exit 25; }
printf 'PATCH_ID=BPE-20261101-012\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
PATCH_TEXT="$(cat <<'BPE_DIFF_012_END'
diff --git a/tools/doubletake_evolve/claim_receipt/cli.py b/tools/doubletake_evolve/claim_receipt/cli.py
--- a/tools/doubletake_evolve/claim_receipt/cli.py
+++ b/tools/doubletake_evolve/claim_receipt/cli.py
@@ -57,8 +57,10 @@
             for v in result.verdicts
         ],
     }
-    json.dump(out, sys.stdout, indent=2, ensure_ascii=False)
-    sys.stdout.write("\n")
+    json.dump(out, sys.stdout, indent=2, ensure_ascii=False)
+    sys.stdout.write("\n")
+    if not result.all_pass:
+        raise SystemExit(1)
 
 
 def main() -> None:
diff --git a/tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py b/tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py
@@ -0,0 +1,54 @@
+"""The verification CLI must fail closed for an unsuccessful verdict."""
+
+import argparse
+import json
+
+import pytest
+
+from doubletake_evolve._shared.crypto_utils import canonical_json_digest
+from doubletake_evolve.claim_receipt.cli import cmd_verify
+from doubletake_evolve.claim_receipt.models import TerminalReceipt
+
+
+def _args(tmp_path, *, good):
+    spec = {
+        "spec_id": "cli", "version": "1",
+        "claims": [{
+            "claim_id": "a", "statement": "test", "expected_kind": "score",
+            "evidence_path": "ev/a", "required_fields": ["value"],
+        }],
+        "committed_claim_ids": ["a"], "sealed_at": "2026-11-01T00:00:00Z",
+    }
+    evidence = {"ev/a": {"value": "42"}}
+    digest = canonical_json_digest(evidence["ev/a"])
+    receipt = TerminalReceipt("a", digest if good else "invalid-digest", "")
+    for name, data in (
+        ("spec", spec), ("evidence", evidence),
+        ("receipts", {"a": {
+            "claim_id": receipt.claim_id,
+            "reported_digest": receipt.reported_digest,
+            "prev_receipt_digest": receipt.prev_receipt_digest,
+        }}),
+    ):
+        (tmp_path / f"{name}.json").write_text(json.dumps(data), encoding="utf-8")
+    return argparse.Namespace(
+        spec=str(tmp_path / "spec.json"),
+        evidence=str(tmp_path / "evidence.json"),
+        receipts=str(tmp_path / "receipts.json"),
+    )
+
+
+def test_cli_failure_is_nonzero_and_still_prints_structured_verdict(tmp_path, capsys):
+    with pytest.raises(SystemExit) as exc:
+        cmd_verify(_args(tmp_path, good=False))
+    assert exc.value.code == 1
+    report = json.loads(capsys.readouterr().out)
+    assert report["all_pass"] is False
+    assert report["verdicts"][0]["verdict"] == "INVALID"
+
+
+def test_cli_success_preserves_zero_exit_and_structured_verdict(tmp_path, capsys):
+    assert cmd_verify(_args(tmp_path, good=True)) is None
+    report = json.loads(capsys.readouterr().out)
+    assert report["all_pass"] is True
+    assert report["chain_valid"] is True
BPE_DIFF_012_END
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CHECK" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py" tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAIL_TESTS: changes remain uncommitted" >&2; exit 32
fi
git diff --check -- "tools/doubletake_evolve/claim_receipt/cli.py" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PATCH_TESTS_PASSED_BPE-20261101-012: applied locally, NOT committed or independently verified"
git status --short
