#!/usr/bin/env bash
# BPE-20261101-008 | DT-EVO-007 / 7.8.1a
# Type: READ_ONLY_DIAGNOSTIC. Not an implementation patch; do not commit or push DT source.
# Goal: identify existing mission-consumer and receipt paths for independent A/B revision proof.
# Done when: local candidate owners + missing independent-observer evidence are reported truthfully.
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo 'STOP: enter DT Git repository'; exit 20; }
cd "$root"
test -f tools/doubletake_evolve/mission_management/manager.py || { echo 'STOP: not DT repository'; exit 21; }
printf 'PATCH_ID=BPE-20261101-008\nTYPE=READ_ONLY_DIAGNOSTIC\nDT_HEAD=%s\n' "$(git rev-parse HEAD)"
printf 'Working branch: '; git branch --show-current
printf '\nCandidate mission consumers / evidence owners (paths only):\n'
matches="$(git grep -l -i -E 'ACTIVE_MISSION\.md|mission[_ -]?revision|consumed[_ -]?blob|consumer[_ -]?read|execution[_ -]?receipt' -- tools/doubletake_evolve 2>/dev/null || true)"
if test -n "$matches"; then printf '%s\n' "$matches" | sed -n '1,45p'; else echo 'NO_SOURCE_MATCH (not proof no consumer exists)'; fi
printf '\nCandidate independent verifier/test paths:\n'
git ls-files 'tools/doubletake_evolve/*/*test*mission*' 'tools/doubletake_evolve/*/*test*receipt*' 'tools/doubletake_evolve/mission_management/tests/*wiring*' | sed -n '1,45p'
printf '\nREQUIRED LOCAL FOLLOW-UP: inspect exact owner methods privately; compare published A/B mission blob with actual consumer-read blob, action/run ID and independently observed receipt.\n'
printf 'NEGATIVE CONTROLS: stale A after B published; forged report; B replayed as a new run; blocked/denied action; delayed/clock-uncertain B acknowledgment.\n'
printf 'DO NOT CLAIM: code search, published SHA, or a self-reported status proves read, execution or Ground.\n'
printf 'RESULT=SOURCE_CENSUS_ONLY; capture local findings without private source in public feedback.\n'
