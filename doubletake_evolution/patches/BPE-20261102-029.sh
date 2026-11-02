#!/usr/bin/env bash
# BPE-20261102-029 rev1 | DT-EVO-007 / 7.9.1-C | PREPARED_UNTESTED
# Goal: refuse reserved plan/evidence symlink replacement at write-use time.
# Source: DT/main df5f733cef0292dee865cf5a184fbb9d0c209e6d
# tools/doubletake_evolve/mission_intake/__init__.py blob ed871b95f15fb3434145b77adec35df20c6b3cf6
# DoD: normal JSON proof; late plan/evidence swaps and symlinked output root
# cannot overwrite outside sentinels; existing mission intake tests pass.
# Partial 7.9.1-C only; NOT independent runtime Ground.
# Local bash -n, git apply --check and guarded pytest NOT RUN by publisher.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$root"
[[ "$(git branch --show-current)" == "main" ]] || { echo "STOP_NOT_MAIN" >&2; exit 21; }
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NO_HOST_GUARD" >&2; exit 22; }
[[ "$(git rev-parse "HEAD:tools/doubletake_evolve/mission_intake/__init__.py" 2>/dev/null)" == "ed871b95f15fb3434145b77adec35df20c6b3cf6" ]] || { echo "STOP_SOURCE_BLOB_MISMATCH" >&2; exit 23; }
if ! git diff --quiet -- "tools/doubletake_evolve/mission_intake/__init__.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/mission_intake/__init__.py"; then
 echo "STOP_TOUCHED_FILE_DIRTY: preserve existing edits" >&2; exit 24
fi
[[ ! -e "tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py" && ! -L "tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py" ]] || { echo "STOP_TEST_ALREADY_EXISTS" >&2; exit 25; }
PATCH_TEXT="$(cat <<'BPE_029_DIFF'
diff --git a/tools/doubletake_evolve/mission_intake/__init__.py b/tools/doubletake_evolve/mission_intake/__init__.py
--- a/tools/doubletake_evolve/mission_intake/__init__.py
+++ b/tools/doubletake_evolve/mission_intake/__init__.py
@@ -264,6 +264,20 @@
         }, indent=2) + "\n"
 
 
+def _write_reserved_json(output_dir: str, name: str, value: dict[str, Any]) -> None:
+    """Pin output directory and refuse a swapped reserved-file symlink."""
+    root_fd = os.open(output_dir, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
+    try:
+        fd = os.open(
+            name, os.O_WRONLY | os.O_CREAT | os.O_TRUNC | os.O_NOFOLLOW,
+            0o600, dir_fd=root_fd,
+        )
+    finally:
+        os.close(root_fd)
+    with os.fdopen(fd, "w", encoding="utf-8") as stream:
+        json.dump(value, stream, indent=2)
+
+
 def execute_mission(mission: dict[str, Any], output_dir: str = "proofs/mission_proof") -> dict[str, Any]:
     """Execute a mission: produce required outputs with evidence."""
     os.makedirs(output_dir, exist_ok=True)
@@ -293,8 +307,7 @@
 
     plan = plan_from_mission(mission)
     plan_path = os.path.join(output_dir, "plan.json")
+    _write_reserved_json(output_dir, "plan.json", plan)
-    with open(plan_path, "w") as f:
-        json.dump(plan, f, indent=2)
 
     results: list[dict] = []
     for req in mission.get("required_outputs", []):
@@ -327,8 +340,7 @@
         "promotion_decision": "PROMOTE" if not errors else "REJECT",
     }
     ev_path = os.path.join(output_dir, "evidence.json")
+    _write_reserved_json(output_dir, "evidence.json", evidence)
-    with open(ev_path, "w") as f:
-        json.dump(evidence, f, indent=2)
 
     return evidence
 
diff --git a/tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py b/tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py
new file mode 100644
--- /dev/null
+++ b/tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py
@@ -0,0 +1,67 @@
+"""Reserved proof artifacts must not follow symlinks swapped after validation."""
+import json
+import pytest
+import doubletake_evolve.mission_intake as intake
+
+
+def _mission():
+    return {
+        "mission_id": "reserved-use-time",
+        "version": "1.0",
+        "goal": "produce a contained artifact",
+        "allowed_actions": ["read", "write"],
+        "forbidden_actions": ["delete", "network", "shell"],
+        "required_outputs": [{"path": "safe.txt", "format": "txt"}],
+    }
+
+
+def test_plan_leaf_swap_after_validation_does_not_touch_outside(tmp_path, monkeypatch):
+    out = tmp_path / "out"
+    out.mkdir()
+    outside = tmp_path / "outside-plan"
+    outside.write_text("unchanged")
+    original = intake.plan_from_mission
+
+    def swap(mission):
+        (out / "plan.json").symlink_to(outside)
+        return original(mission)
+
+    monkeypatch.setattr(intake, "plan_from_mission", swap)
+    with pytest.raises(OSError):
+        intake.execute_mission(_mission(), output_dir=str(out))
+    assert outside.read_text() == "unchanged"
+    assert not (out / "evidence.json").exists()
+
+
+def test_evidence_leaf_swap_after_validation_does_not_touch_outside(tmp_path, monkeypatch):
+    out = tmp_path / "out"
+    out.mkdir()
+    outside = tmp_path / "outside-evidence"
+    outside.write_text("unchanged")
+    original = intake._render_content
+
+    def swap(req, mission):
+        (out / "evidence.json").symlink_to(outside)
+        return original(req, mission)
+
+    monkeypatch.setattr(intake, "_render_content", swap)
+    with pytest.raises(OSError):
+        intake.execute_mission(_mission(), output_dir=str(out))
+    assert outside.read_text() == "unchanged"
+
+
+def test_reserved_root_symlink_refused(tmp_path):
+    outside = tmp_path / "outside"
+    outside.mkdir()
+    (tmp_path / "out").symlink_to(outside, target_is_directory=True)
+    with pytest.raises(OSError):
+        intake.execute_mission(_mission(), output_dir=str(tmp_path / "out"))
+    assert not (outside / "plan.json").exists()
+
+
+def test_normal_reserved_json_roundtrip(tmp_path):
+    out = tmp_path / "out"
+    result = intake.execute_mission(_mission(), output_dir=str(out))
+    assert result["promotion_decision"] == "PROMOTE"
+    assert json.loads((out / "plan.json").read_text())["mission_id"] == "reserved-use-time"
+    assert json.loads((out / "evidence.json").read_text())["promotion_decision"] == "PROMOTE"
BPE_029_DIFF
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CONTEXT" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py" "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py" || { echo "FAIL_GUARDED_TESTS" >&2; exit 32; }
git diff --check -- "tools/doubletake_evolve/mission_intake/__init__.py" "tools/doubletake_evolve/mission_intake/test_reserved_proof_use_time.py" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PASS_FOCUSED_TESTS_UNCOMMITTED: BPE-20261102-029"
