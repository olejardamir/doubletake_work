#!/usr/bin/env bash
# BPE-20261101-018 | DT-EVO-002 / 2.4.3
# TYPE: ISOLATED_DIAGNOSTIC; no implementation change.
# GOAL: Bounded retry and repair-state baseline
# LIMIT: Durable production effects are NOT proven by fixtures.
# DoD: exact HEAD, actual focused tests, observed result; not production integration.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/tests/test_repair_budget_exhaustion_reports_counts.py
test -f tools/doubletake_evolve/tests/test_repair_is_cycle_scoped.py
echo "ID=BPE-20261101-018 HEAD=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/tests/test_repair_budget_exhaustion_reports_counts.py tools/doubletake_evolve/tests/test_repair_is_cycle_scoped.py
echo 'DIAGNOSTIC_BASELINE_PASSED; no code changed, no live repair claimed.'
