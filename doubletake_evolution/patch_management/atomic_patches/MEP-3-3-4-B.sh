#!/usr/bin/env bash
# MEP-3-3-4-B | DT-EVO-003 / 3.3.4
# EXECUTABLE MISSION UNIT, NOT an implementation source diff.
# State: AWAITING_IMPLEMENTATION_OR_REAL_VERIFICATION
# Exact objective: Measure completed natural cycles with same workload/sampling.
# Acceptance/prerequisite: evidence or focused positive/negative result required; not satisfied by planning alone.
# Related code patch: none yet
# This script NEVER grants authority, changes DT code, edits retained state, deploys, or claims Ground.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "BLOCKED: run in DT checkout" >&2; exit 20; }
cd "$root"
test -f tools/doubletake_evolve/runtime/host_workload.py || { echo "BLOCKED: not DT checkout" >&2; exit 21; }
test -f 'tools/doubletake_evolve/autonomous_loop/test_autonomous_loop.py' || { echo "BLOCKED: source test fixture missing" >&2; exit 22; }
echo 'UNIT=3.3.4-B MISSION=3.3.4'
printf 'SOURCE_HEAD=%s BRANCH=%s\n' "$(git rev-parse HEAD)" "$(git branch --show-current)"
printf '%s\n' 'GOAL: Measure completed natural cycles with same workload/sampling.'
printf '%s\n' 'ACCEPTANCE/GATE: evidence or focused positive/negative result required; not satisfied by planning alone.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q 'tools/doubletake_evolve/autonomous_loop/test_autonomous_loop.py'
fi
echo 'SOURCE_AND_BASELINE_SCOPE_ONLY: no implementation was applied by this unit. Source-grounded patch/independent Ground still required.'
exit 78
