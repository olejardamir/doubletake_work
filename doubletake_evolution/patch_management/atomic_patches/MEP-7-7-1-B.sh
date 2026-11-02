#!/usr/bin/env bash
# MEP-7-7-1-B; mission DT-EVO-007 step 7.7.1
# Objective: Compare actual record semantics against executable-history replay contract.
# Evidence gate: evidence or focused positive/negative result required; not satisfied by planning alone.
# Not an implementation diff. No production writes or permission changes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/collective_core/test_cartography_tamper_contract.py" || exit 22
echo "UNIT=7.7.1-B HEAD=$(git rev-parse HEAD)"
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/collective_core/test_cartography_tamper_contract.py"
fi
echo "BLOCKED/INCOMPLETE: real prerequisite or implementation patch required; no Ground claimed."
exit 78
