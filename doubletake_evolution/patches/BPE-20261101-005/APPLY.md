# BPE-20261101-005 — PREPARED_UNTESTED

**Goal:** Reject externally supplied sealed-spec digests that do not match current claim contents.

**DT source base:** `7b86364f1bbf34c0f04a2b85f21e5fb499fd7719` (no DT source modification by this GPT worker).
**Touched source blob:** `tools/doubletake_evolve/claim_receipt/models.py` at `6806ec309b405f2b7f692aa0ee5341cf590e7839`.
**New test path:** `tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py` (confirmed absent from the inspected tree).
**Dependencies:** none; patches 003/004/006 edit separate hunks in the same file, so recheck base and rebase after another patch is applied. The older unpublished private packages remain separate.

From a clean authorized DT checkout, perform these six shell steps. Stop on any mismatch or failed command; never force, reset, bypass governance, or mutate retained runtime state. Only the local authorized DT executor applies changes.

```sh
curl -fsSL https://raw.githubusercontent.com/olejardamir/doubletake_work/main/doubletake_evolution/patches/BPE-20261101-005/fix.patch -o /tmp/BPE-20261101-005.patch
test "$(git rev-parse HEAD)" = "7b86364f1bbf34c0f04a2b85f21e5fb499fd7719"
git apply --check /tmp/BPE-20261101-005.patch
git apply /tmp/BPE-20261101-005.patch
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_sealed_spec_digest.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
git diff --check && git status --short
```

**Evidence/stop:** A successful apply is not a verified fix. Record exact base and resulting revision, patch digest, test exit status, relevant negative-control outcome, and rollback method. Report only public-safe structured results to `doubletake_evolution/patches/results/BPE-20261101-005.json`; keep private logs and protected state in DT. On any failure report `FAILED` with a reproducible error; do not claim success.
