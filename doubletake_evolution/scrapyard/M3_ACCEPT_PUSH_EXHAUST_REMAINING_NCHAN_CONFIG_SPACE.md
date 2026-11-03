# Historical EA M3 frozen-v2.3.0 Nchan configuration investigation — distilled

**Provenance:** original blob `ceb9ccbe45b08b98a6e5dabb8bcb6f679db5179d`, original length 21554 characters, recoverable via Git history. Historical EA research prompt, not DT instructions, implementation, tested result or proof of ACCEPT. Source claims and Nchan compatibility remain unverified.

## Frozen contract and negative baseline
EA canonical contract: `poc/internal_docs/EXPERIMENT_CONTRACT_v2_3_0.md`. 100,000 viewers (60,000 baseline +40,000 within 120s); four active Nchan partitions plus spare, Redis 7.2, Nchan 1.3.8, nginx 1.27.4, four Go loadgen shards. Required p95 fan-out <=500ms, surge <=500ms, burst <=1000ms, late join <=2000ms. Zero correctness violations; all generator/DUT/publisher/eight-match/reconnect/restart-replacement gates; three identical terminal runs seeds 42/43/44, CV <=0.15. Never change topology, versions, workload, correctness or thresholds.

Reported F1 baseline: 100k active, zero correctness violations, fan-out p95 2757ms, burst p95 3707ms, surge/late join clean. Redis `io-threads=4`, `io-threads-do-reads=yes`; distributed Nchan, four workers/partition, `multi_accept off`, `NGINX_DEBUG=0`, `LIVELOCK_WATCHER=0`, `nchan_shared_memory_size 64m`, `tcp_nopush on`. Reported coordinator hostname resolve-once/pinned-transport fix requires independent source verification. **Known failed candidate:** backup storage on non-owner p1/p2/p3 lost 190 late-join messages; not a valid speed improvement.

## Version-dependent candidate matrix — hypotheses, NOT validated
Verify exact Nchan 1.3.8 implementation of `nchan_redis_storage_mode distributed|backup|nostore`, location-level binding, channel-global state, Redis pub/sub, subscriber history and publisher semantics. Source claimed: distributed uses Redis for publish/retrieval; backup publishes locally then forwards to Redis and documentation limits backup to one server per backend; nostore does not persist. Do not infer safe mixed modes from names.

- **N1:** distributed publisher/history with nostore live /sub on all partitions, preserving complete Redis history; test for semantic correctness and hot-path improvement.
- **N2:** N1 plus nostore live lobby only if N1 improves and lobby latest-state requirements survive.
- **B1:** p0-only backup, non-owner p1/p2/p3/spare distributed; exact-version same-channel history behavior must be established first. Never repeat non-owner backup.
- **B2:** p0-only backup plus non-owner nostore subscribers only after both individual semantics are proven.
- **D1:** adjust supported `nchan_redis_idle_channel_cache_timeout` only if telemetry shows Redis channel churn.
- **R1:** align Redis CPU/thread allocation only if observed starvation/oversubscription and frozen resource allowance permit it.
- **Additional:** bounded source audit of Redis publish/receive/storage, subscriber enqueue, worker fan-out, location-scoped modes and shared-memory path; at most three source-supported config-only candidates. Combine only individually valid, orthogonal mechanisms.

## Reproducible falsification and acceptance
1. Verify EA current SHA, frozen contract, F1 config, prior G1/G1b/H1/H2 and exact Nchan 1.3.8 parser/source. Classify each candidate SUPPORTED / UNSUPPORTED / AMBIGUOUS; ambiguous requires small isolated smoke.
2. Stage 1: 4k smoke requires complete phase barriers, history/late join, reconnect/restart replacement; missing=duplicate=out_of_order=0, all validity counters zero, no DNS/orchestration failure. A 4k PASS is not ACCEPT.
3. Stage 2: only correct candidates get 100k probe. Record fan-out/surge/burst/late-join p95, population, generator/DUT/publisher/eight-match and correctness. Compare F1 2757/3707. Near-pass diagnostic (not acceptance): fan-out <=750ms and burst <=1500ms; >=20% gain still below contract is only material improvement. Preserve failures, revert invalid configs.
4. Short 100k full-gate pass -> terminal-duration nonqualifying probe (30s warmup, 120s measure, 30s burst, 120s surge, 10s cooldown) -> freeze identical contract/config/source -> three qualifying seeds 42/43/44 with machine ACCEPT plus independent audit. Failed terminal seed: preserve evidence and diagnose using separate nonqualifying probes; never tune directly on qualifying seeds.
5. Claim config-only impossibility only after all supported matrix entries, exact-version audit, up to three additional strong candidates and valid orthogonal combinations are exhausted; document remaining measured bottleneck and required out-of-scope change. No ACCEPT or impossibility result was established by the original document.

## Evidence and historical submission constraints
Preserve exact source/config/contract SHA, rendered Compose, commands, raw stdout/stderr, p95s, validity, independent verdict, immutable historical evidence. Original EA instruction also required hashing this agent-instruction artifact and synchronizing final submission ZIP/proposal truthfully; that is historical EA context, not authority to execute. No DT Ground, runtime test, source compatibility validation or current DT applicability verified. Revisit only for a concrete DT experiment using frozen-baseline/negative-control methodology without transferring EA performance claims.
