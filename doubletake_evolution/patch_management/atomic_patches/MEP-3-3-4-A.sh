#!/usr/bin/env bash
# MEP-3-3-4-A | DT-EVO-003 / 3.3.4
# EXECUTABLE MISSION UNIT, NOT an implementation source diff.
# State: AUTHORITY_OR_DEPENDENCY_GATED
# Exact objective: Freeze comparable pre/post measurement and attribution (after 1.3.3).
# Acceptance/prerequisite: prerequisite/authorization must be independently satisfied; not a ready code patch.
# Related code patch: none yet
# This script NEVER grants authority, changes DT code, edits retained state, deploys, or claims Ground.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "BLOCKED: run in DT checkout" >&2; exit 20; }
cd "$root"
test -f tools/doubletake_evolve/runtime/host_workload.py || { echo "BLOCKED: not DT checkout" >&2; exit 21; }
test -f 'tools/doubletake_evolve/autonomous_loop/test_autonomous_loop.py' || { echo "BLOCKED: source test fixture missing" >&2; exit 22; }
echo 'UNIT=3.3.4-A MISSION=3.3.4'
printf 'SOURCE_HEAD=%s BRANCH=%s\n' "$(git rev-parse HEAD)" "$(git branch --show-current)"
printf '%s\n' 'GOAL: Freeze comparable pre/post measurement and attribution (after 1.3.3).'
printf '%s\n' 'ACCEPTANCE/GATE: prerequisite/authorization must be independently satisfied; not a ready code patch.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q 'tools/doubletake_evolve/autonomous_loop/test_autonomous_loop.py'
fi
echo 'GATED_PENDING: validated owner/dependency/real-runtime evidence required before implementation. Do not mark done.'
exit 78
