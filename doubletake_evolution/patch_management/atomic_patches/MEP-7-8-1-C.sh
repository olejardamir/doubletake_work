#!/usr/bin/env bash
# MEP-7-8-1-C | 7.8.1 | Prerequisite execution gate
# Goal: Run revision and observer negative classifications; do not infer consumption from publication.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f tools/doubletake_evolve/mission_intake/test_mission_intake_boundary.py || exit 22
echo "UNIT=7.8.1-C SOURCE=$(git rev-parse HEAD)"
echo 'Unit is decomposed but acceptance or a source modification remains required.'
exit 78
