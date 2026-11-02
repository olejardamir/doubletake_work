#!/usr/bin/env bash
# BPE-20261101-023 | DT-EVO-007 / 7.5.2
# TYPE: DIAGNOSTIC ONLY, not a code fix or a source qualification.
# Goal: test existing governed intake fixtures without inventing a new source or capability grant.
# DoD: focused guarded tests and exact source revision recorded; actual source-backed knowledge Ground stays OPEN.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/governed_knowledge/test_source_generality_real_sources.py
test -f tools/doubletake_evolve/governed_knowledge/test_source_generality_intake.py
echo "ID=BPE-20261101-023 SOURCE=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/governed_knowledge/test_source_generality_real_sources.py tools/doubletake_evolve/governed_knowledge/test_source_generality_intake.py
echo 'SOURCE FIXTURE BASELINE PASSED. Requires qualifying external source before implementation.'
