#!/usr/bin/env bash
# BPE-20261102-030 rev1 | DT-EVO-007 / 7.9.1-C supporting executor integrity
# Goal: run exactly the bytes whose hash was checked, not a replaceable pathname.
# DT/main source HEAD df5f733cef0292dee865cf5a184fbb9d0c209e6d
# tools/doubletake_evolve/patch_execution/bpe_queue_runner.py blob 88d0a3c6d18e8be13cb7957ed62115bc51819733
# tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py blob a3be102d65aa4c754d8287bfd5f399e738572e99
# DoD: original pinned script executes; post-inspection swap refused before execution;
# existing runner status, dependency and receipt tests pass. Not mission proof Ground.
# REMOTE source hunk match only; local git apply, bash -n and pytest NOT RUN.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "STOP_NOT_GIT" >&2; exit 20; }
cd "$root"
[[ "$(git branch --show-current)" == "main" ]] || { echo "STOP_NOT_MAIN" >&2; exit 21; }
[[ -f tools/doubletake_evolve/runtime/host_workload.py ]] || { echo "STOP_NO_HOST_GUARD" >&2; exit 22; }
[[ "$(git rev-parse "HEAD:tools/doubletake_evolve/patch_execution/bpe_queue_runner.py" 2>/dev/null)" == "88d0a3c6d18e8be13cb7957ed62115bc51819733" ]] || { echo "STOP_SOURCE_BLOB" >&2; exit 23; }
[[ "$(git rev-parse "HEAD:tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py" 2>/dev/null)" == "a3be102d65aa4c754d8287bfd5f399e738572e99" ]] || { echo "STOP_TEST_BLOB" >&2; exit 23; }
if ! git diff --quiet -- "tools/doubletake_evolve/patch_execution/bpe_queue_runner.py" "tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py" || ! git diff --cached --quiet -- "tools/doubletake_evolve/patch_execution/bpe_queue_runner.py" "tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py"; then
 echo "STOP_TOUCHED_FILES_DIRTY: preserve edits, inspect local context" >&2; exit 24
fi
PATCH_TEXT="$(cat <<'BPE_030_DIFF'
diff --git a/tools/doubletake_evolve/patch_execution/bpe_queue_runner.py b/tools/doubletake_evolve/patch_execution/bpe_queue_runner.py
--- a/tools/doubletake_evolve/patch_execution/bpe_queue_runner.py
+++ b/tools/doubletake_evolve/patch_execution/bpe_queue_runner.py
@@ -211,13 +211,22 @@
         result_path = dt_root / "patch_results" / (candidate["patch_id"] + ".json")
         if result_path.exists() or result_path.is_symlink():
             raise QueueRefusal("already recorded; refuse duplicate execution")
-        proc = subprocess.Popen(
-            ["bash", candidate["script"]], cwd=dt_root,
-            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
-            text=True, start_new_session=True,
-        )
-        try:
-            stdout, stderr = proc.communicate(timeout=timeout)
+        # Execute inspected bytes, not a mutable path after preflight.
+        raw = Path(candidate["script"]).read_bytes()
+        if (_blob_sha(raw) != candidate["script_blob_sha"]
+                or hashlib.sha256(raw).hexdigest() != candidate["script_sha256"]):
+            raise QueueRefusal("script changed after queue inspection")
+        try:
+            script_text = raw.decode("utf-8")
+        except UnicodeDecodeError as exc:
+            raise QueueRefusal("non-UTF8 patch script") from exc
+        proc = subprocess.Popen(
+            ["bash", "-s"], cwd=dt_root,
+            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
+            stderr=subprocess.PIPE, text=True, start_new_session=True,
+        )
+        try:
+            stdout, stderr = proc.communicate(input=script_text, timeout=timeout)
             returncode = proc.returncode
         except subprocess.TimeoutExpired:
             os.killpg(proc.pid, signal.SIGKILL)
diff --git a/tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py b/tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py
--- a/tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py
+++ b/tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py
@@ -129,3 +129,19 @@
     _git(dt, "checkout", "--detach", "HEAD")
     with pytest.raises(QueueRefusal, match="main branch"):
         inspect_queue(dt, queue)
+
+def test_refuse_script_replaced_after_inspection(sample, monkeypatch):
+    dt, queue, _, _, script = sample
+    from doubletake_evolve.patch_execution import bpe_queue_runner as runner
+    original = runner.inspect_queue
+
+    def swap_after_inspection(*args, **kwargs):
+        report = original(*args, **kwargs)
+        script.write_text("#!/usr/bin/env bash\\nprintf malicious > applied.txt\\n")
+        return report
+
+    monkeypatch.setattr(runner, "inspect_queue", swap_after_inspection)
+    with pytest.raises(QueueRefusal, match="script changed after queue inspection"):
+        execute_one(dt, queue, reviewed=True)
+    assert not (dt / "applied.txt").exists()
+    assert not (dt / "patch_results" / (PATCH_ID + ".json")).exists()
BPE_030_DIFF
)"
printf '%s\n' "$PATCH_TEXT" | git apply --check - || { echo "FAIL_APPLY_CONTEXT" >&2; exit 30; }
printf '%s\n' "$PATCH_TEXT" | git apply - || { echo "FAIL_APPLY" >&2; exit 31; }
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py" || { echo "FAIL_GUARDED_TESTS" >&2; exit 32; }
git diff --check -- "tools/doubletake_evolve/patch_execution/bpe_queue_runner.py" "tools/doubletake_evolve/patch_execution/test_bpe_queue_runner.py" || { echo "FAIL_DIFF_CHECK" >&2; exit 33; }
echo "PASS_FOCUSED_TESTS_UNCOMMITTED: BPE-20261102-030"
