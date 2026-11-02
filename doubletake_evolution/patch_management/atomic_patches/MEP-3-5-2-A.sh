#!/usr/bin/env bash
# MEP-3-5-2-A | DT-EVO-003 / 3.5.2
# EXECUTABLE MISSION UNIT, NOT an implementation source diff.
# State: AUTHORITY_OR_DEPENDENCY_GATED
# Exact objective: Establish owner-approved conflict and acknowledgement contract (blocked).
# Acceptance/prerequisite: prerequisite/authorization must be independently satisfied; not a ready code patch.
# Related code patch: none yet
# This script NEVER grants authority, changes DT code, edits retained state, deploys, or claims Ground.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "BLOCKED: run in DT checkout" >&2; exit 20; }
cd "$root"
test -f tools/doubletake_evolve/runtime/host_workload.py || { echo "BLOCKED: not DT checkout" >&2; exit 21; }
test -f 'tools/doubletake_evolve/collective_core/test_shared_state_write_contract.py' || { echo "BLOCKED: source test fixture missing" >&2; exit 22; }
echo 'UNIT=3.5.2-A MISSION=3.5.2'
printf 'SOURCE_HEAD=%s BRANCH=%s\n' "$(git rev-parse HEAD)" "$(git branch --show-current)"
printf '%s\n' 'GOAL: Establish owner-approved conflict and acknowledgement contract (blocked).'
printf '%s\n' 'ACCEPTANCE/GATE: prerequisite/authorization must be independently satisfied; not a ready code patch.'
if [[ "${RUN_ISOLATED_BASELINE_TESTS:-0}" == "1" ]]; then
  python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q 'tools/doubletake_evolve/collective_core/test_shared_state_write_contract.py'
fi
echo 'GATED_PENDING: validated owner/dependency/real-runtime evidence required before implementation. Do not mark done.'
exit 78
