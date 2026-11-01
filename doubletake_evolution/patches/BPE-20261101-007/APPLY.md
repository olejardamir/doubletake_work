# BPE-20261101-007 — PREPARED_UNTESTED

**Goal:** Reject mismatched claim identities in the exported direct `verify_claim` API, independently of whole-chain checks.

**Source:** private DT `7b86364f1bbf34c0f04a2b85f21e5fb499fd7719`; `tools/doubletake_evolve/claim_receipt/receipts.py` blob `a304c64d15db4ed37b94e491b4deebc9738b23ad`. The new test file must not already exist. This patch is independent of 003–006 and the two retained private packages; rebase if another patch has already modified the checkout.

From a clean, authorized DT checkout, run these six steps; stop on any failed check. No runtime retained-state mutation is authorized.

```sh
curl -fsSL https://raw.githubusercontent.com/olejardamir/doubletake_work/main/doubletake_evolution/patches/BPE-20261101-007/fix.patch -o /tmp/BPE-20261101-007.patch
test "$(git rev-parse HEAD)" = "7b86364f1bbf34c0f04a2b85f21e5fb499fd7719"
git apply --check /tmp/BPE-20261101-007.patch
git apply /tmp/BPE-20261101-007.patch
python3 tools/doubletake_evolve/runtime/host_workload.py -- python3 -m pytest -q tools/doubletake_evolve/claim_receipt/test_claim_id_binding.py tools/doubletake_evolve/claim_receipt/test_claim_receipt.py
git diff --check && git status --short
```

Only the local authorized executor may apply and test. Record exact revision, apply check, negative controls, focused regression and rollback. Keep private logs private; report only public-safe structured results in `doubletake_evolution/patches/results/BPE-20261101-007.json`. Do not mark VERIFIED without actual independent evidence.
