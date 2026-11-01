# DoubleTake patches — ONE FILE PER PATCH

**Authoritative queue:** [PATCH_INDEX.json](PATCH_INDEX.json)  
**Worker rules:** [WORKER_RULES.md](WORKER_RULES.md)

Give Clai this GitHub folder URL and say: **"Choose the next patch and apply it to DoubleTake."**

Clai reads the index, selects the first compatible `PREPARED_UNTESTED` patch in priority order, downloads and inspects its one `BPE-....sh` file, runs it once from the actual DT Git checkout, and reports test results. It never needs to invent the code change; each shell script already contains the full unified diff, preflight, focused tests and definition of done.

```text
patches/
  PATCH_INDEX.json         # selects next eligible ID/file/priority
  WORKER_RULES.md          # GPT worker's operating contract
  BPE-20261101-003.sh      # single self-contained executable patch
  BPE-20261101-004.sh
  ...
  results/                 # optional independent execution feedback
```

Each `.sh` is intended to be **read and reviewed** before running; do not run an unchecked script downloaded from the Internet. A `PREPARED_UNTESTED` patch is NOT verified. Apply one at a time; if a source checksum changed or tests fail, report the exact conflict so scheduled GPT Patch Engineer can revise the same patch next run. The previous 3-file structure is deprecated.

**PUBLIC REPOSITORY:** the private DT source must be reviewed for safe publication, with no secrets or sensitive details in scripts.
