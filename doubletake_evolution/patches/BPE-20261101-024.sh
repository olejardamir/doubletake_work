#!/usr/bin/env bash
# BPE-20261101-024 | DT-EVO-004 / 4.2.2.2
# PREPARED_UNTESTED; exact source-grounded diff; no local test execution claimed.
# IDEA: Prevent unmounted UI build from claiming it is production-served
# DoD: positive existing behavior maintained, new negative regression passes.
# LIMIT: No production deployment or actual served-bundle acceptance.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP not DT"; exit 20; }
printf 'PATCH=BPE-20261101-024 HEAD=%s\n' "$(git rev-parse HEAD)"
[[ -f "tools/doubletake_evolve/api/health.py" && ! -L "tools/doubletake_evolve/api/health.py" ]] || { echo "STOP missing tools/doubletake_evolve/api/health.py" >&2; exit 21; }
if [[ "$(git rev-parse HEAD:tools/doubletake_evolve/api/health.py 2>/dev/null)" != "cf6249355a6990648c23d297c46b92ff9eea69f3" ]]; then echo "NOTICE source drift tools/doubletake_evolve/api/health.py" >&2; fi
[[ -f "tools/doubletake_evolve/tests/test_w10_ui_build_identity.py" && ! -L "tools/doubletake_evolve/tests/test_w10_ui_build_identity.py" ]] || { echo "STOP missing tools/doubletake_evolve/tests/test_w10_ui_build_identity.py" >&2; exit 21; }
if [[ "$(git rev-parse HEAD:tools/doubletake_evolve/tests/test_w10_ui_build_identity.py 2>/dev/null)" != "785660f7586faa0eeb697398da41a67e1a8e848e" ]]; then echo "NOTICE source drift tools/doubletake_evolve/tests/test_w10_ui_build_identity.py" >&2; fi
patch_text="$(cat <<'PATCH_BPE_20261101_024'
diff --git a/tools/doubletake_evolve/api/health.py b/tools/doubletake_evolve/api/health.py
--- a/tools/doubletake_evolve/api/health.py
+++ b/tools/doubletake_evolve/api/health.py
@@ -49,9 +49,9 @@
     dist = ui_dist_dir()
     return build_identity(
         dist,
         api_contract_version=API_CONTRACT_VERSION,
-        serving=bool(getattr(state, "ui_static_mount_active", dist.is_dir())),
+        serving=bool(getattr(state, "ui_static_mount_active", False)),
     )
 
 
 @router.get(UI_BUILD_ROUTE)
diff --git a/tools/doubletake_evolve/tests/test_w10_ui_build_identity.py b/tools/doubletake_evolve/tests/test_w10_ui_build_identity.py
--- a/tools/doubletake_evolve/tests/test_w10_ui_build_identity.py
+++ b/tools/doubletake_evolve/tests/test_w10_ui_build_identity.py
@@ -295,8 +295,17 @@
     assert not_served["present"] is True
     assert not_served["server_serving"] is False
 
 
+def test_dist_without_mount_fact_never_claims_ui_served(tmp_path, monkeypatch):
+    dist = _make_build(tmp_path / "dist", {"index.html": "<html></html>"})
+    monkeypatch.setattr(health, "ui_dist_dir", lambda: dist)
+    monkeypatch.delattr(state, "ui_static_mount_active", raising=False)
+    identity = health._ui_build_payload()
+    assert identity["present"] is True
+    assert identity["server_serving"] is False
+
+
 def test_health_route_returns_the_same_identity(tmp_path, monkeypatch):
     dist = _make_build(tmp_path / "dist", {"index.html": "<html></html>"})
     monkeypatch.setattr(health, "ui_dist_dir", lambda: dist)
     monkeypatch.setattr(state, "ui_static_mount_active", True, raising=False)
PATCH_BPE_20261101_024
)"
if ! printf '%s\n' "$patch_text" | git apply --check -; then echo 'STOP overlapping edits or already implemented; do not overwrite' >&2; exit 30; fi
printf '%s\n' "$patch_text" | git apply -
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/tests/test_w10_ui_build_identity.py
git diff --check -- "tools/doubletake_evolve/api/health.py" "tools/doubletake_evolve/tests/test_w10_ui_build_identity.py"
echo "FOCUSED_TESTS_PASSED BPE-20261101-024; no DT commit, deployment or Ground verified by author."
