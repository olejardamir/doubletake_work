#!/usr/bin/env bash
# BPE-20261101-014 — Expose exact chain/verdict digests in structured verification CLI output
# Mission: DT-EVO-007 / 7.9.2 evidence identity; CLI visibility, not proof of full canonical contract.
# Source branch: feature/alphacode-provider; inspected HEAD 9d784b7f0e465cd7916dc0a49ab2fc0dcd94c5bb
# Dependency: BPE-20261101-012 applied/committed FIRST.
# Expected cli.py blob after BPE-012: 903445b151774881d36eebe2651549759403cc81
# Revision 1; PREPARED_UNTESTED; source hunk simulated, local tests NOT run.
# DoD positive: valid verification JSON includes digests equal to model-generated values.
# DoD negative: invalid verification exits nonzero but retains accurate digests in JSON.
# DoD regression: focused CLI suites and existing claim receipt tests pass under host guard.
# STOP on wrong branch, stale source, dirty target, missing dependency, apply/test failure.
# No auto-commit/push, no runtime or retained-state writes.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$ROOT"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NOT_DT" >&2; exit 20; }
[[ "$(git branch --show-current)" == "feature/alphacode-provider" ]] || { echo "STOP_WRONG_BRANCH" >&2; exit 21; }
SRC=tools/doubletake_evolve/claim_receipt/cli.py
TEST=tools/doubletake_evolve/claim_receipt/test_cli_proof_digest_output.py
[[ -f "$SRC" && ! -L "$SRC" ]] || { echo "STOP_SOURCE_MISSING_OR_LINK" >&2; exit 22; }
[[ -f tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py ]] || { echo "STOP_DEPENDENCY_012_NOT_APPLIED" >&2; exit 22; }
if ! git diff --quiet -- "$SRC" || ! git diff --cached --quiet -- "$SRC"; then echo "STOP_DIRTY_TARGET" >&2; exit 23; fi
[[ "$(git hash-object -- "$SRC")" == "903445b151774881d36eebe2651549759403cc81" ]] || { echo "STOP_STALE_BLOB_OR_DEPENDENCY" >&2; exit 24; }
[[ ! -e "$TEST" && ! -L "$TEST" ]] || { echo "STOP_TEST_ALREADY_PRESENT" >&2; exit 25; }
printf 'PATCH_ID=BPE-20261101-014\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
PATCH_TEXT="$(cat <<'BPE_DIFF_014_END'
diff --git a/tools/doubletake_evolve/claim_receipt/cli.py b/tools/doubletake_evolve/claim_receipt/cli.py
--- a/tools/doubletake_evolve/claim_receipt/cli.py
+++ b/tools/doubletake_evolve/claim_receipt/cli.py
@@ -48,3 +48,5 @@
         "missing_ids": list(result.coverage.missing_ids),
         "chain_valid": result.chain.chain_valid,
+        "chain_digest": result.chain.chain_digest,
+        "verdict_digest": result.verdict_digest,
         "verdicts": [
diff --git a/tools/doubletake_evolve/claim_receipt/test_cli_proof_digest_output.py b/tools/doubletake_evolve/claim_receipt/test_cli_proof_digest_output.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/claim_receipt/test_cli_proof_digest_output.py
@@ -0,0 +1,70 @@
+"""The CLI JSON must expose the chain and aggregate proof identities."""
+
+import argparse
+import json
+
+import pytest
+
+from doubletake_evolve.claim_receipt.cli import cmd_verify
+from doubletake_evolve.claim_receipt.models import (
+    ClaimReceiptSpec, ClaimSpec, EvidenceItem, TerminalReceipt,
+)
+from doubletake_evolve.claim_receipt.receipts import verify_claims
+
+
+def _case(tmp_path, *, valid):
+    spec = ClaimReceiptSpec(
+        spec_id="cli-proof-id", version="1",
+        claims=(ClaimSpec(
+            claim_id="a", statement="a", expected_kind="score",
+            evidence_path="ev/a", required_fields=("value",),
+        ),),
+        committed_claim_ids=("a",), sealed_at="2026-11-01T00:00:00Z",
+    )
+    item = EvidenceItem(path="ev/a", payload={"value": "1"})
+    receipt = TerminalReceipt("a", item.content_digest if valid else "invalid", "")
+    expected = verify_claims(spec, {"ev/a": item}, {"a": receipt})
+    spec_json = {
+        "spec_id": spec.spec_id, "version": spec.version,
+        "claims": [{
+            "claim_id": "a", "statement": "a", "expected_kind": "score",
+            "evidence_path": "ev/a", "required_fields": ["value"],
+        }],
+        "committed_claim_ids": ["a"], "sealed_at": spec.sealed_at,
+        "spec_digest": spec.spec_digest,
+    }
+    files = {
+        "spec": spec_json,
+        "evidence": {"ev/a": item.payload},
+        "receipts": {"a": {
+            "claim_id": receipt.claim_id,
+            "reported_digest": receipt.reported_digest,
+            "prev_receipt_digest": receipt.prev_receipt_digest,
+        }},
+    }
+    for name, value in files.items():
+        (tmp_path / f"{name}.json").write_text(json.dumps(value), encoding="utf-8")
+    args = argparse.Namespace(**{
+        name: str(tmp_path / f"{name}.json") for name in files
+    })
+    return args, expected
+
+
+def test_valid_cli_report_exposes_exact_proof_digests(tmp_path, capsys):
+    args, expected = _case(tmp_path, valid=True)
+    assert cmd_verify(args) is None
+    report = json.loads(capsys.readouterr().out)
+    assert report["all_pass"] is True
+    assert report["chain_digest"] == expected.chain.chain_digest
+    assert report["verdict_digest"] == expected.verdict_digest
+
+
+def test_invalid_cli_report_still_exposes_exact_proof_digests(tmp_path, capsys):
+    args, expected = _case(tmp_path, valid=False)
+    with pytest.raises(SystemExit) as exc:
+        cmd_verify(args)
+    assert exc.value.code == 1
+    report = json.loads(capsys.readouterr().out)
+    assert report["all_pass"] is False
+    assert report["chain_digest"] == expected.chain.chain_digest
+    assert report["verdict_digest"] == expected.verdict_digest
BPE_DIFF_014_END
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CHECK" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
if ! python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "$TEST" tools/doubletake_evolve/claim_receipt/test_cli_failure_exit_status.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py; then
  echo "FAIL_FOCUSED_TESTS: leave changes uncommitted for inspection" >&2; exit 32
fi
git diff --check -- "$SRC" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PATCH_TESTS_PASSED_BPE-20261101-014: applied locally, NOT committed, NOT independently Ground-verified"
git status --short
