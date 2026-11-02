#!/usr/bin/env bash
# MEP-7-3-1-A | DT-EVO-007, step 7.3.1
# Goal: Acquire independently qualified source-backed artifact (dependency).
# Requirement: prerequisite/authorization must be independently satisfied; not a ready code patch.
# CONDITIONAL EXECUTABLE. Not a code modification. Gated until independent prerequisites/acceptance.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/collective_core/test_knowledge_intake_scope.py" || exit 22
echo "UNIT=7.3.1-A SOURCE=$(git rev-parse HEAD)"
echo 'Prepared mission unit. No source changes and no runtime Ground claimed.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/collective_core/test_knowledge_intake_scope.py"
fi
exit 78
