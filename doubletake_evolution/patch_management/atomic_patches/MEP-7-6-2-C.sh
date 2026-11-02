#!/usr/bin/env bash
# MEP-7-6-2-C; mission DT-EVO-007 step 7.6.2
# Objective: Compare observed controls, intervention, retries and cost without cherry-picking.
# Evidence gate: evidence or focused positive/negative result required; not satisfied by planning alone.
# Not an implementation diff. No production writes or permission changes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/tests/test_ground_handoff_reachability.py" || exit 22
echo "UNIT=7.6.2-C HEAD=$(git rev-parse HEAD)"
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/tests/test_ground_handoff_reachability.py"
fi
echo "BLOCKED/INCOMPLETE: real prerequisite or implementation patch required; no Ground claimed."
exit 78
