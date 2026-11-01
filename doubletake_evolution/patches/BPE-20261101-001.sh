#!/usr/bin/env bash
# BPE-20261101-001 rev2 | DT-EVO-007 / 7.9.1
# PREPARED_UNTESTED | Source-bound implementation patch, exact existing DT owner.
# GOAL: refuse reserved proof redirects and normalized collisions; preserve truthful evidence.json.
# DoD positive: permitted contained mission output and canonical evidence.json still succeed.
# DoD negatives: plan.json collision, aliased evidence.json, duplicate normalized outputs,
# symlink-redirected plan/evidence are rejected BEFORE writes; outside sentinel unchanged.
# LIMIT: check-then-use race is NOT proven safe; independent use-time Ground remains OPEN.
# Only local authorized executor may commit/push verified DT code; publish sanitized outcome separately.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[[ -f tools/doubletake_evolve/mission_intake/__init__.py ]] || { echo 'BLOCKED not a DT checkout'; exit 30; }
echo "BPE_ID=BPE-20261101-001 BRANCH=$(git branch --show-current) HEAD=$(git rev-parse HEAD)"
[[ -f "tools/doubletake_evolve/mission_intake/__init__.py" ]] || { echo 'BLOCKED missing source tools/doubletake_evolve/mission_intake/__init__.py' >&2; exit 31; }
git diff --quiet -- "tools/doubletake_evolve/mission_intake/__init__.py" && git diff --cached --quiet -- "tools/doubletake_evolve/mission_intake/__init__.py" || { echo 'BLOCKED dirty path tools/doubletake_evolve/mission_intake/__init__.py' >&2; exit 32; }
[[ "$(git hash-object -- "tools/doubletake_evolve/mission_intake/__init__.py")" == "206104ef6d8e446e68bddba3b2e3a6b15ee457a6" ]] || { echo 'STALE source tools/doubletake_evolve/mission_intake/__init__.py; report to Patch Engineer' >&2; exit 33; }
[[ -f "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py" ]] || { echo 'BLOCKED missing source tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py' >&2; exit 31; }
git diff --quiet -- "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py" && git diff --cached --quiet -- "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py" || { echo 'BLOCKED dirty path tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py' >&2; exit 32; }
[[ "$(git hash-object -- "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py")" == "2799b79ecf6cfd20b667f7b6ab6eb1acd4d71b35" ]] || { echo 'STALE source tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py; report to Patch Engineer' >&2; exit 33; }
patch_text="$(cat <<'BPE_001_UNIFIED_PATCH'
diff --git a/tools/doubletake_evolve/mission_intake/__init__.py b/tools/doubletake_evolve/mission_intake/__init__.py
--- a/tools/doubletake_evolve/mission_intake/__init__.py
+++ b/tools/doubletake_evolve/mission_intake/__init__.py
@@ -123,12 +123,24 @@
             errors.append(f"Missing required field: {req_field}")
     if "version" in mission and mission["version"] != "1.0":
         errors.append(f"Unsupported version: {mission['version']}")
+    seen_output_paths: set[str] = set()
     if "required_outputs" in mission:
         for i, req in enumerate(mission["required_outputs"]):
             if "path" not in req:
                 errors.append(f"Required output {i} missing 'path'")
             elif _path_escapes_output_dir(req["path"]):
                 errors.append(f"Required output {i} path escapes output directory: {req['path']}")
+            else:
+                normalized = os.path.normpath(req["path"])
+                if normalized == "plan.json":
+                    errors.append(f"Required output {i} collides with reserved plan.json")
+                if normalized == "evidence.json" and (
+                    req["path"] != "evidence.json" or req.get("format") != "json"
+                ):
+                    errors.append(f"Required output {i} must be canonical evidence.json with json format")
+                if normalized in seen_output_paths:
+                    errors.append(f"Required output {i} duplicates normalized path: {normalized}")
+                seen_output_paths.add(normalized)
             if "format" not in req:
                 errors.append(f"Required output {i} missing 'format'")
     return errors
@@ -259,6 +271,12 @@
     errors: list[str] = []
 
     validation_errors = validate_mission(mission)
+    # Reserved artifacts must not redirect writes before any proof is created.
+    for reserved_name in ("plan.json", "evidence.json"):
+        if not _resolved_within(os.path.join(output_dir, reserved_name), output_dir):
+            validation_errors.append(
+                f"Reserved output path escapes output directory: {reserved_name}"
+            )
     if validation_errors:
         errors.extend(validation_errors)
         return {
@@ -281,6 +299,10 @@
     results: list[dict] = []
     for req in mission.get("required_outputs", []):
         out_path = os.path.join(output_dir, req["path"])
+        if req["path"] == "evidence.json":
+            # The canonical evidence artifact is written below, not as a placeholder.
+            results.append({"path": out_path, "format": "json", "written": True})
+            continue
         if not _resolved_within(out_path, output_dir):
             errors.append(f"Required output path escapes output directory: {req['path']}")
             continue
diff --git a/tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py b/tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py
--- a/tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py
+++ b/tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py
@@ -16,6 +16,7 @@
 import ast
 import csv
 import io
+import json
 import os
 import py_compile
 import subprocess
@@ -124,6 +125,49 @@
         assert validate_mission(_mission()) == []
 
 
+class TestReservedArtifactCollisions:
+    def test_reserved_names_and_aliases_reject_before_proof_writes(self, tmp_path: Path):
+        for i, path in enumerate(("plan.json", "nested/../plan.json",
+                                  "./evidence.json", "nested/../evidence.json")):
+            out = tmp_path / f"case_{i}"
+            result = execute_mission(_mission(required_outputs=[
+                {"path": path, "format": "json"}
+            ]), output_dir=str(out))
+            assert result["validation_verdict"] == "NOT_ACCEPTED"
+            assert result["promotion_decision"] == "REJECT"
+            assert result["outputs_produced"] == []
+            assert not (out / "plan.json").exists()
+            assert not (out / "evidence.json").exists()
+
+    def test_duplicate_normalized_output_rejected(self, tmp_path: Path):
+        out = tmp_path / "duplicates"
+        result = execute_mission(_mission(required_outputs=[
+            {"path": "same.json", "format": "json"},
+            {"path": "nested/../same.json", "format": "json"},
+        ]), output_dir=str(out))
+        assert result["validation_verdict"] == "NOT_ACCEPTED"
+        assert any("duplicates normalized path" in e for e in result["errors"])
+        assert not (out / "plan.json").exists()
+        assert not (out / "same.json").exists()
+
+    def test_evidence_requires_canonical_json_format(self):
+        errors = validate_mission(_mission(required_outputs=[
+            {"path": "evidence.json", "format": "md"}
+        ]))
+        assert any("canonical evidence.json" in e for e in errors)
+
+    def test_default_evidence_is_proof_not_placeholder(self, tmp_path: Path):
+        out = tmp_path / "normal"
+        result = execute_mission(_mission(), output_dir=str(out))
+        actual = json.loads((out / "evidence.json").read_text())
+        assert result["validation_verdict"] == "ACCEPTED"
+        assert actual["proof_class"] == "Mission-Driven Proof"
+        assert actual["promotion_decision"] == "PROMOTE"
+        assert actual["outputs_produced"] == result["outputs_produced"]
+        assert actual["outputs_produced"][0]["written"] is True
+        assert "status" not in actual
+
+
 class TestExecuteMissionPathContainment:
     def test_execute_bails_and_never_writes_outside(self, tmp_path: Path):
         out_dir = str(tmp_path / "out")
@@ -177,6 +221,26 @@
         assert (out / "results" / "output.json").exists()
 
 
+class TestReservedProofArtifactContainment:
+    def test_reserved_symlinks_fail_before_any_write(self, tmp_path: Path):
+        for reserved in ("plan.json", "evidence.json"):
+            out = tmp_path / reserved.replace(".", "_")
+            out.mkdir()
+            outside = tmp_path / f"outside_{reserved}"
+            outside.write_text("original")
+            (out / reserved).symlink_to(outside)
+            result = execute_mission(_mission(required_outputs=[
+                {"path": "safe.json", "format": "json"}
+            ]), output_dir=str(out))
+            assert result["validation_verdict"] == "NOT_ACCEPTED"
+            assert result["promotion_decision"] == "REJECT"
+            assert result["outputs_produced"] == []
+            assert any(reserved in e for e in result["errors"])
+            assert outside.read_text() == "original"
+            assert not (out / "safe.json").exists()
+            assert not (out / ("evidence.json" if reserved == "plan.json" else "plan.json")).exists()
+
+
 class TestPySafeText:
     def test_triple_quotes_neutralized(self):
         assert _py_safe_text('a"""b') == "a'''b"
BPE_001_UNIFIED_PATCH
)"
printf '%s\n' "$patch_text" | git apply --check -
printf '%s\n' "$patch_text" | git apply -
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py
git diff --check -- tools/doubletake_evolve/mission_intake/__init__.py tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py
echo 'TESTS_PASSED if runner exited 0; GROUND race negative remains unverified. Commit/push only after independent verification.'
