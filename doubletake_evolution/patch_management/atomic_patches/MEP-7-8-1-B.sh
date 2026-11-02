#!/usr/bin/env bash
# MEP-7-8-1-B | Mission 7.8.1
# Goal: Freeze A/B published-versus-consumed SHA and stable run identity.
# CONDITIONAL ACCEPTANCE/GATE PACKAGE; no code changes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py" || exit 22
echo "MISSION_UNIT=7.8.1-B HEAD=$(git rev-parse HEAD)"
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py"
fi
echo 'REQUIRES_SOURCE_IMPLEMENTATION_OR_INDEPENDENT_ACCEPTANCE; no Ground demonstrated.'
exit 78
