#!/usr/bin/env bash
# BPE-20261101-016 | DT-EVO-002 / 2.2.3
# TYPE: ISOLATED_DIAGNOSTIC; no implementation change.
# GOAL: Record denied/failed repair baseline
# LIMIT: Existing tests do not establish a granted production caller.
# DoD: exact HEAD, actual focused tests, observed result; not production integration.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/tests/test_repair_is_cycle_scoped.py
test -f tools/doubletake_evolve/tests/test_repair_provider_failure_is_honest.py
echo "ID=BPE-20261101-016 HEAD=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/tests/test_repair_is_cycle_scoped.py tools/doubletake_evolve/tests/test_repair_provider_failure_is_honest.py
echo 'DIAGNOSTIC_BASELINE_PASSED; no code changed, no live repair claimed.'
