#!/usr/bin/env bash
# MEP-7-8-2-B | 7.8.2 | Prerequisite execution gate
# Goal: Under existing authorization, test A/B and replay controls of canonical consumer.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/runtime/host_workload.py || exit 21
test -f tools/doubletake_evolve/mission_management/tests/test_bridge.py || exit 22
echo "UNIT=7.8.2-B SOURCE=$(git rev-parse HEAD)"
echo 'Unit is decomposed but acceptance or a source modification remains required.'
exit 78
