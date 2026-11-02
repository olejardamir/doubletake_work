#!/usr/bin/env bash
# MEP-7-7-2-A | Mission 7.7.2
# Goal: Only after confirmed gap, modify canonical verifier in-place.
# CONDITIONAL ACCEPTANCE/GATE PACKAGE; no code changes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/collective_core/test_canonical_event_log_integrity.py" || exit 22
echo "MISSION_UNIT=7.7.2-A HEAD=$(git rev-parse HEAD)"
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/collective_core/test_canonical_event_log_integrity.py"
fi
echo 'REQUIRES_SOURCE_IMPLEMENTATION_OR_INDEPENDENT_ACCEPTANCE; no Ground demonstrated.'
exit 78
