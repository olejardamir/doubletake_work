#!/usr/bin/env bash
# MEP-4-2-2-3-A | DT-EVO-004, step 4.2.2.3
# Goal: Wait for independent full natural-cycle recovery proof.
# Requirement: evidence or focused positive/negative result required; not satisfied by planning alone.
# CONDITIONAL EXECUTABLE. Not a code modification. Gated until independent prerequisites/acceptance.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/api/test_autonomic_progress.py" || exit 22
echo "UNIT=4.2.2.3-A SOURCE=$(git rev-parse HEAD)"
echo 'Prepared mission unit. No source changes and no runtime Ground claimed.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/api/test_autonomic_progress.py"
fi
exit 78
