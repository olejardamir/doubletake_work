# DoubleTake patch management (no patches here)

The actual executable patch directory contains ONLY one self-contained `.sh` file per patch:
[doubletake_evolution/patches/](../patches/).

This sibling directory holds workflow metadata only:
- `PATCH_INDEX.json`: authoritative patch priority, status, eligibility, dependencies and file names
- `WORKER_RULES.md`: independent scheduled Borg Patch Engineer instructions
- `PATCH_LEARNING.md`: self-improvement hypotheses and observed outcomes
- `results/<ID>.json`: actual sanitized local integration/test evidence

### Minimal local usage

Given only the URL of `doubletake_evolution/patches/`, clai should locate the sibling `../patch_management/PATCH_INDEX.json`, identify the first eligible status and priority, inspect its corresponding `patches/<ID>.sh` script, apply/test the one patch on the private DT checkout, then commit and push verified changes to the authorized implementation branch if permitted. Report sanitized results to `patch_management/results/<ID>.json` if connector access permits. Never claim a patch verified merely because it was generated.

The patch file itself contains the full unified diff, source preflight, focused tests and definition of done; clai should treat it as a precise implementation goal, check actual DT behavior, stop on unsafe source changes/conflict, and report test and push outcomes accurately.

Public repo confidentiality applies. Do not publish private DT secrets or sensitive content.
