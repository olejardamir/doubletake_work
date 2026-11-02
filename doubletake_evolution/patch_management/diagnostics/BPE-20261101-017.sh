#!/usr/bin/env bash
# BPE-20261101-017 | DT-EVO-002 / 2.4.2
# TYPE: ISOLATED_DIAGNOSTIC; no implementation change.
# GOAL: Isolated fault-path repair regression
# LIMIT: Never inject a production fault without authority.
# DoD: exact HEAD, actual focused tests, observed result; not production integration.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/tests/test_autonomous_repair.py
test -f tools/doubletake_evolve/tests/test_repair_is_bounded.py
echo "ID=BPE-20261101-017 HEAD=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/tests/test_autonomous_repair.py tools/doubletake_evolve/tests/test_repair_is_bounded.py
echo 'DIAGNOSTIC_BASELINE_PASSED; no code changed, no live repair claimed.'
