#!/usr/bin/env bash
# MEP-7-8-3-A | 7.8.3 | Prerequisite execution gate
# Goal: Trace accepted Scout source to actually consumed mission and authorized action.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f tools/doubletake_evolve/tests/test_ground_handoff_reachability.py || exit 22
echo "UNIT=7.8.3-A SOURCE=$(git rev-parse HEAD)"
echo 'Unit is decomposed but acceptance or a source modification remains required.'
exit 78
