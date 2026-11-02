#!/usr/bin/env bash
# MEP-7-5-2-B; mission DT-EVO-007 step 7.5.2
# Objective: Connect missing canonical knowledge intake seam only if verified.
# Evidence gate: prerequisite/authorization must be independently satisfied; not a ready code patch.
# Not an implementation diff. No production writes or permission changes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/governed_knowledge/test_source_generality_intake.py" || exit 22
echo "UNIT=7.5.2-B HEAD=$(git rev-parse HEAD)"
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/governed_knowledge/test_source_generality_intake.py"
fi
echo "BLOCKED/INCOMPLETE: real prerequisite or implementation patch required; no Ground claimed."
exit 78
