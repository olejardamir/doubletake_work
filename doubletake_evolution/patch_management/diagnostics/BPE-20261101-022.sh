#!/usr/bin/env bash
# BPE-20261101-022 | DT-EVO-007 / 7.3.1
# TYPE: READ_ONLY_DIAGNOSTIC. Actual source patch not justified until a qualified artifact exists.
# Goal: independently exercise existing knowledge intake and quarantine control fixtures.
# DoD: report current DT HEAD, guarded test exit and missing qualified source; do not call a rejected artifact assimilated.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
test -f tools/doubletake_evolve/runtime/host_workload.py
test -f tools/doubletake_evolve/collective_core/test_knowledge_intake_scope.py
test -f tools/doubletake_evolve/collective_core/test_knowledge_quarantine_contract.py
echo "ID=BPE-20261101-022 SOURCE=$(git rev-parse HEAD)"
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/collective_core/test_knowledge_intake_scope.py tools/doubletake_evolve/collective_core/test_knowledge_quarantine_contract.py
echo 'ISOLATED CONTROL TESTS PASSED. Full positive source-to-validated-knowledge Ground still OPEN.'
