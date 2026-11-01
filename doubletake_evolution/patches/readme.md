# DoubleTake patch packages

This directory is the **single requested public destination** for patches derived from the mission in `../ACTIVE_MISSION.md`.

The **Borg Patch Engineer** is intended to run as its own GPT scheduled worker. It prepares *multiple* independent, narrowly scoped patches whenever source evidence warrants them.

```text
patches/
  WORKER_RULES.md
  PATCH_INDEX.json
  PATCH-0001/
    fix.patch
    APPLY.md
  definitions_of_done/
    PATCH-0001.md
  results/
    PATCH-0001.json
```

The workbench does not imply the scheduled worker is active or that generated patches are tested. Local DT/Clai applies and tests patches. The GPT worker inspects recorded results each subsequent run, and revises stale or failed patches.

**Publication note:** this repository is public, while DT source is private. Do not upload secrets, proprietary or sensitive private code. Public-safe diff content is a prerequisite for publishing any source-bearing patch.
