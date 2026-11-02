#!/usr/bin/env bash
# MEP-4-2-2-2-B | DT-EVO-004, step 4.2.2.2
# Goal: Deploy only through approved existing release mechanism with rollback.
# Requirement: prerequisite/authorization must be independently satisfied; not a ready code patch.
# CONDITIONAL EXECUTABLE. Not a code modification. Gated until independent prerequisites/acceptance.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f "tools/doubletake_evolve/tests/test_w10_ui_build_identity.py" || exit 22
echo "UNIT=4.2.2.2-B SOURCE=$(git rev-parse HEAD)"
echo 'Prepared mission unit. No source changes and no runtime Ground claimed.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
 python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q "tools/doubletake_evolve/tests/test_w10_ui_build_identity.py"
fi
exit 78
