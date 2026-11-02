# Scrapyard canonical inventory — sharded

Last rebuilt: 2026-11-02. Snapshot of public repository main: `d998ccce408670221b30da2e247569ad16f72657`.

**This is the canonical small entrypoint, replacing the 621,621-character monolithic editable ledger.** Legacy detailed findings were retained *unaltered* in `doubletake_evolution/inventory_archives/INVENTORY_pre_sharding_20261102.md` at exact original Git blob `74a09db470c223dd690a6fb493576f9507ce395d`. Original history remains intact. Pre-sharding `INVENTORY_DELTA.md` is retained as historical metadata; S23–S25 factual source SHAs, reductions and Director dispositions are now reconciled in the appropriate source/incoming shards. Do not append further duplicate delta notes.

- Current tree verified 2026-11-02: **375 scrapyard blobs** = 324 root files (including this entrypoint and legacy delta), 29 incoming, 13 canonical clusters, 9 inventory shards. The original **366** count excluded the nine shards.
- **364 non-inventory files** appear in the shard manifests; `INVENTORY.md` and `INVENTORY_DELTA.md` are intentionally excluded to avoid self-referential blob-SHA cycles.
- A listed blob is not proof of full reading, semantic value, or valid cluster membership. `LEGACY_STATUS_NOT_YET_MIGRATED` means classification must be reconciled with the archived inventory and actual current content before mutation.
- In every run, edit only the shard(s) whose original source content was changed. Refetch SHA after commit and verify its row; mark old source deleted only after complete preservation/merge of unique content and check existing references.
- Do not create another monolithic inventory or new running delta log. Report actual bytes reduced, source files modified, clusters merged, originals deleted, incoming disposition, and any unverified Ground.

## Shards

- [clustered.md](inventory_shards/clustered.md) — 13 tracked files
- [incoming.md](inventory_shards/incoming.md) — 29 tracked files
- [root_0-9.md](inventory_shards/root_0-9.md) — 3 tracked files
- [root_A-D.md](inventory_shards/root_A-D.md) — 141 tracked files
- [root_E-H.md](inventory_shards/root_E-H.md) — 46 tracked files
- [root_I-L.md](inventory_shards/root_I-L.md) — 19 tracked files
- [root_M-P.md](inventory_shards/root_M-P.md) — 49 tracked files
- [root_Q-T.md](inventory_shards/root_Q-T.md) — 14 tracked files
- [root_U-Z.md](inventory_shards/root_U-Z.md) — 50 tracked files

## Backlog priorities

1. **S23–S25 reconciled:** source current SHAs and Director feedback are in root_A-D/incoming shards; keep the old delta as archival metadata, not an active competing tracker.
2. Work through historical documents for genuinely useful minimal extracts and source-file rewriting; prioritize large duplicate prompt editions only if sections can be inspected safely and independent value protected.
3. Merge overlapping sources into canonical `clustered/` records with provenance; delete old originals only after source-value preservation is verified. Keep explicit tombstones in shards.
4. Intake research must not repeatedly displace historical dissection.
