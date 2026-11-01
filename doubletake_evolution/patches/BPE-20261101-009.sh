#!/usr/bin/env bash
# BPE-20261101-009 | DT-EVO-007 / 7.7.1a
# Type: READ_ONLY_DIAGNOSTIC; invokes only existing temporary-fixture tests.
# Goal: establish actual cartography record/verification baseline before considering workflow-history replay.
# Done when: actual owner record type and safe test result are reported; no live-state edits.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo 'STOP: enter DT Git repository'; exit 20; }
cd "$root"
test -f tools/doubletake_evolve/collective_cartography/cartography.py || { echo 'STOP: missing canonical cartography owner'; exit 21; }
test -f tools/doubletake_evolve/collective_core/test_cartography_tamper_contract.py || { echo 'STOP: baseline fixture missing'; exit 22; }
printf 'PATCH_ID=BPE-20261101-009\nTYPE=READ_ONLY_DIAGNOSTIC\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
printf '\nRelevant local owner and test file paths:\n'
git ls-files 'tools/doubletake_evolve/collective_cartography/*' 'tools/doubletake_evolve/collective_core/test_cartography*' | sed -n '1,55p'
printf '\nRunning existing guarded isolated tamper/roundtrip contract:\n'
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/collective_core/test_cartography_tamper_contract.py
printf '\nSOURCE REVIEW REQUIRED: determine whether existing records represent executable commands/effects or only digest-bound placement/event/patrol history. Do not assume Temporal workflow replay applies.\n'
printf 'NEGATIVE CONTROLS: tampering, incompatible record/version, malformed provenance, unexpected side effect; test only synthetic tmp fixtures.\n'
printf 'RESULT=BASELINE_TEST_COMPLETED_NOT_REPLAY_GROUND. Classify GAP_VERIFIED/ALREADY_PRESENT/NOT_APPLICABLE/AUTHORITY_BLOCKED only after independent source review.\n'
