#!/usr/bin/env bash
# BPE-20261101-019 | DT-EVO-003 / 3.4.2
# TYPE: VERIFICATION_DIAGNOSTIC; no source-code implementation.
# GOAL: Truthful status and cycle-boundary report baseline
# LIMIT: Current fixture status is not proof of fully completed live autonomy.
# DoD: guarded test result and exact local revision; preserve deployment and owner permissions.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/mission_management/tests/test_status_view.py
test -f tools/doubletake_evolve/tests/test_cycle_summary_boundary.py
echo "ID=BPE-20261101-019 HEAD=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/mission_management/tests/test_status_view.py tools/doubletake_evolve/tests/test_cycle_summary_boundary.py
echo 'VERIFICATION_BASELINE_ONLY; no live authority, code change, or Ground acceptance claimed.'
