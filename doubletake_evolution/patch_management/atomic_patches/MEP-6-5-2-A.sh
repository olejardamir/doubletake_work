#!/usr/bin/env bash
# MEP-6-5-2-A | DT-EVO-006, step 6.5.2
# Goal: Obtain owner-approved reversible capacity policy (blocked).
# Requirement: prerequisite/authorization must be independently satisfied; not a ready code patch.
# CONDITIONAL EXECUTABLE. Not a code modification. Gated until independent prerequisites/acceptance.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/tests/test_loop_durable_history_preservation.py" || exit 22
echo "UNIT=6.5.2-A SOURCE=$(git rev-parse HEAD)"
echo 'Prepared mission unit. No source changes and no runtime Ground claimed.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/tests/test_loop_durable_history_preservation.py"
fi
exit 78
