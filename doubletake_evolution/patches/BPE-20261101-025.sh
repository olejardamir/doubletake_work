#!/usr/bin/env bash
# BPE-20261101-025 | DT-EVO-003 / 3.4.2
# PREPARED_UNTESTED; exact source-grounded diff; no local test execution claimed.
# IDEA: Prioritize actual failed objective over unrelated authority request in campaign status
# DoD: positive existing behavior maintained, new negative regression passes.
# LIMIT: No final mission closure or autonomous recovery claimed.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP not DT"; exit 20; }
printf 'PATCH=BPE-20261101-025 HEAD=%s\n' "$(git rev-parse HEAD)"
[[ -f "tools/doubletake_evolve/mission_management/status.py" && ! -L "tools/doubletake_evolve/mission_management/status.py" ]] || { echo "STOP missing tools/doubletake_evolve/mission_management/status.py" >&2; exit 21; }
if [[ "$(git rev-parse HEAD:tools/doubletake_evolve/mission_management/status.py 2>/dev/null)" != "9a0878c0cb6c755eef30807f100c9ae30026ff2c" ]]; then echo "NOTICE source drift tools/doubletake_evolve/mission_management/status.py" >&2; fi
[[ -f "tools/doubletake_evolve/mission_management/tests/test_status_view.py" && ! -L "tools/doubletake_evolve/mission_management/tests/test_status_view.py" ]] || { echo "STOP missing tools/doubletake_evolve/mission_management/tests/test_status_view.py" >&2; exit 21; }
if [[ "$(git rev-parse HEAD:tools/doubletake_evolve/mission_management/tests/test_status_view.py 2>/dev/null)" != "b0745267d9b83c613930d9720234f84906bb125c" ]]; then echo "NOTICE source drift tools/doubletake_evolve/mission_management/tests/test_status_view.py" >&2; fi
patch_text="$(cat <<'PATCH_BPE_20261101_025'
diff --git a/tools/doubletake_evolve/mission_management/status.py b/tools/doubletake_evolve/mission_management/status.py
--- a/tools/doubletake_evolve/mission_management/status.py
+++ b/tools/doubletake_evolve/mission_management/status.py
@@ -54,17 +54,19 @@
     return dict(sorted(counts.items()))
 
 
 def _next_action(spec: CampaignSpec) -> Dict[str, str]:
-    for objective in spec.objectives:
-        if objective.state in _AUTHORITY_STATES:
-            return {"action": "REQUEST_AUTHORITY", "objective_id": objective.objective_id}
-        if objective.state is ObjectiveState.BLOCKED_CAPABILITY:
-            return {"action": "PROBE_OR_DECLARE_CAPABILITY", "objective_id": objective.objective_id}
-        if objective.state is ObjectiveState.BLOCKED_CONFLICT:
-            return {"action": "RESOLVE_CONFLICT", "objective_id": objective.objective_id}
-        if objective.state is ObjectiveState.FAILED:
-            return {"action": "DIAGNOSE_FAILURE", "objective_id": objective.objective_id}
+    # Diagnose actual failure before requesting authority for another objective.
+    for objective in spec.objectives:
+        if objective.state is ObjectiveState.FAILED:
+            return {"action": "DIAGNOSE_FAILURE", "objective_id": objective.objective_id}
+    for objective in spec.objectives:
+        if objective.state in _AUTHORITY_STATES:
+            return {"action": "REQUEST_AUTHORITY", "objective_id": objective.objective_id}
+        if objective.state is ObjectiveState.BLOCKED_CAPABILITY:
+            return {"action": "PROBE_OR_DECLARE_CAPABILITY", "objective_id": objective.objective_id}
+        if objective.state is ObjectiveState.BLOCKED_CONFLICT:
+            return {"action": "RESOLVE_CONFLICT", "objective_id": objective.objective_id}
     for objective in spec.objectives:
         if objective.state in {ObjectiveState.READY, ObjectiveState.IN_PROGRESS}:
             return {"action": "EXECUTE_OBJECTIVE", "objective_id": objective.objective_id}
     if spec.objectives and all(o.state is ObjectiveState.COMPLETED for o in spec.objectives):
diff --git a/tools/doubletake_evolve/mission_management/tests/test_status_view.py b/tools/doubletake_evolve/mission_management/tests/test_status_view.py
--- a/tools/doubletake_evolve/mission_management/tests/test_status_view.py
+++ b/tools/doubletake_evolve/mission_management/tests/test_status_view.py
@@ -68,8 +68,19 @@
     assert "next: REQUEST_AUTHORITY o-approval" in text
     assert len(text.splitlines()) <= 7
 
 
+def test_failure_next_action_precedes_unrelated_approval(tmp_path):
+    store = CampaignStore(tmp_path)
+    spec = _spec()
+    spec.objectives[0].state = ObjectiveState.FAILED
+    store.save(spec)
+    status = build_campaign_status(store, "c-status")
+    assert status["status"] == "FAILED"
+    assert status["next"] == {"action": "DIAGNOSE_FAILURE", "objective_id": "o-done"}
+    assert {"objective_id": "o-approval", "state": "WAITING_APPROVAL"} in status["blockers"]
+
+
 def test_missing_campaign_is_reported_not_invented(tmp_path):
     store = CampaignStore(tmp_path)
     status = build_campaign_status(store, "absent")
     assert status["status"] == "MISSING"
PATCH_BPE_20261101_025
)"
if ! printf '%s\n' "$patch_text" | git apply --check -; then echo 'STOP overlapping edits or already implemented; do not overwrite' >&2; exit 30; fi
printf '%s\n' "$patch_text" | git apply -
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/mission_management/tests/test_status_view.py
git diff --check -- "tools/doubletake_evolve/mission_management/status.py" "tools/doubletake_evolve/mission_management/tests/test_status_view.py"
echo "FOCUSED_TESTS_PASSED BPE-20261101-025; no DT commit, deployment or Ground verified by author."
