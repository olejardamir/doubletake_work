# Atomic mission execution packages

This directory has **58 individually addressable `.sh` packages**, one for every atomic unit in `../MISSION_ATOMIC_QUEUE.json`, spanning every active numbered step of `../../ACTIVE_MISSION.md`.

**Important:** These are conditional **prerequisite and acceptance packages**, not source-code patch implementations. They identify the exact mission unit, current DT source identity and a relevant pre-existing guarded test. They deliberately exit with code **78** to indicate that a real source implementation, authorization or independent runtime evidence is still necessary. Set `RUN_ISOLATED_BASELINE_TESTS=1` to run the existing test where supported. An isolated test pass is **not** completion.

Actual implementation patches with embedded source diffs are kept exclusively in `../../patches/`. The currently prepared, untested code patches are BPE-20261101-010, BPE-20261101-024 and BPE-20261101-025, bound to the current DT `main` source.

The hourly Patch Engineer must check each unit against actual source, authority and execution evidence and convert implementable work into genuine tested `BPE-*.sh` diffs, without inventing fixes or deleting retained state. It must mark impossible or authority-gated work truthfully. These packages are not intended for automatic selection by the local code-patch executor.
