#!/usr/bin/env bash
# BPE-20261101-015 | DT-EVO-002 / 2.2.2
# PRECONDITION_DIAGNOSTIC, not a source-code modification.
# Objective: capture existing production repair caller and grant-boundary baseline before any new wiring.
# DoD for diagnostic only: exact DT HEAD, focused test outcome, and missing caller/grant owner.
# Never create a grant, edit retained state, or claim a repair was executed.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/tests/test_repair_console_ingress.py
test -f tools/doubletake_evolve/tests/test_w19_repair_delegation.py
printf 'BPE-015 source=%s\n' "$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/tests/test_repair_console_ingress.py tools/doubletake_evolve/tests/test_w19_repair_delegation.py
echo 'BASELINE TESTS PASSED. Not evidence of a granted production repair caller.'
