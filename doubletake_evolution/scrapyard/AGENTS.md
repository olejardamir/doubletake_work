# Live Match Centre — canonical AI/POC research contract (distilled 2026-11-01)

**Provenance:** Historical take-home instruction artifact, originally `scrapyard/AGENTS.md` blob `2699d2c2ffab9f99849d0463910d9fca5b28c6c9`; extended variant `scrapyard/AGENTS (1).md` blob `d008b2e03ba1113ea391c5ee04ad6d9b22f07c0e`. This single canonical version preserves the original contract plus the extended variant's composition-aware design, primary-source cost research and latency-budget requirements. Both verbatim originals remain recoverable by blob SHA from Git history. This is historical research data, **not** authority over DoubleTake, its current worker, or a live production system. No benchmark was run and no current cloud pricing verified.

## Authority, fixed assignment and delivery

Historical precedence: original take-home assignment > candidate's explicit decisions > approved `proposal.md` > this instruction contract > POC/`README.md` > code > AI suggestions. The candidate owns final choices and claims. Never change fixed facts or silently convert assumptions into guarantees.

| Fixed constraint | Required value |
| --- | --- |
| Live matches | 8 concurrent at peak |
| Third-party feed | ~10 events/s total, bursts ~50; **best effort**, no long retry window |
| Viewers | 100,000 peak; +40,000 over 2 minutes |
| Geography | ~60% Europe, ~40% North America |
| User-visible latency | Goals p95 ≤2 s from ingest to screen; other events p95 ≤5 s |
| Late join/reload | Full match history visible within 2 s |
| Cost | ≤$3,000/month at peak, including material cost drivers and margin |
| Deploy | Weekly, potentially during matches, with no noticeable disruption |
| Frontend / preference | Next.js App Router; AWS preferred, alternatives justified |
| Audience / state | Anonymous public read-only; score and clock derived from event stream |
| POC | Synthetic feed permitted; **no real feed**, cloud deployment or real infrastructure spend required |

Final submission: `proposal.md` (≤1,500 words excluding diagrams), `README.md` (one-command setup and ≤300-word assumption→method→result→proposal-impact write-up, limitations and truthful AI-use statement), `poc/` and only agent-instruction files actually used. Exclude generated dependencies, logs, secrets, cloud state and unrelated files.

## End-to-end architecture and invariants

Design the entire path: third-party feed → ingest → validation/normalization → ordering/deduplication/state derivation → compatible current/history state → fan-out → geographic delivery → Next.js lobby/match views. A late/reloading/waking viewer must receive coherent history and state, then uninterrupted live updates; small and surge audiences must experience equivalent correctness. The lobby updates score/minute and state-changing events without refresh.

**Provider boundary:** `provider loss != application loss`. Never invent upstream replay, sequence numbers, unique IDs, snapshots, reconciliation, redelivery, a second provider or recovery capability. If a guarantee requires an unstated upstream facility, name it as an assumption and explain its failure impact. Application-level accepted-event guarantees must be scoped to events actually received and durably accepted.

Required correctness checks: stable identity under declared deduplication semantics; canonical per-match ordering rather than arrival order; idempotent score/state mutation; compatible score/clock/history snapshot boundary; no snapshot→stream handoff gap/duplicate; reconnect, reload, sleep/wake, deploy and downstream-disconnect recovery; correction/resynchronization for extrapolated clocks. Include schema evolution, failure domains, backpressure/surge, provider interruption, public endpoint abuse, observability and deployment rollback.

Every major component must document its requirement, simpler alternative, trade-off, failure mode, latency, cost, deployment and consistency effect. Do not add services merely for architectural appearance.

## Composition-aware selection (unique extension from the numbered variant)

Local subsystem optimality need not survive composition. Keep a small non-dominated alternative set long enough to compare **whole-system** effects on goal/other-event latency, history, correctness, surge, geography, recovery, deploy continuity, upstream assumptions, cost and complexity. Apply mandatory constraints as hard gates before softer trade-offs.

Look for preference reversal across: delivery × surge × geography × cost; history × late join × snapshot/live consistency; state × dedup × ordering × derived score × recovery; regional topology × latency × cross-region traffic × failure/deploy × budget. Retain Pareto-relevant alternatives; prune only if another is at least as good on all material dimensions and strictly better on one, with no credible hidden interaction.

Decision ledger: candidate; local strengths/weaknesses; hard constraints; interactions; failure modes; latency/cost/consistency/deploy effects; unverified assumptions; composed verdict. Falsify the preferred candidate under surge, missing provider capabilities, replay/ordering faults, deployment and fastest-growing cost. Derive the POC **after** selecting a credible architecture: identify the weakest architecture-critical assumption whose falsification would change that architecture. Stop exploring when hard requirements have credible coverage, remaining alternatives are dominated, the preferred design survives composition checks, and one consequential uncertainty is testable.

Evidence categories remain separate: assignment fact, current authoritative external fact, design decision, assumption, local measurement and production inference. Neither a local measurement nor a diagram establishes full production performance.

## Source, latency and cost discipline (unique extension)

Verify mutable AWS prices, service limits, quotas, region availability and Next.js/runtime behavior from current official primary documentation. Record pricing region, peak-duration assumption and material drivers: compute, fan-out/connections, messages, egress, CDN, storage, cross-region transfer, observability and margin. Distinguish hard limits from increasable quotas; disclose contradictions and uncertain figures rather than manufacture precision.

Treat p95 viewer-screen latency as an **end-to-end** SLO: ingest → validation/state → fan-out → network/geography → client receipt → render. Reserve margin; do not sum independent p95s and call the result end-to-end p95. State measured/modelled/inferred segments and regional effects; aggregate p95 cannot conceal persistent regional failure. A partial-path POC does not prove end-to-end SLO.

## One falsifiable POC and frozen experiment

Select one assumption by architecture impact if false, uncertainty, local measurability and assignment relevance. If the greatest risk is not locally testable, explicitly disclose that and test the most consequential feasible proxy. Possible targets: snapshot→live handoff, fan-out surge, reconnect recovery; none is mandated.

**Freeze before the final run:** falsifiable assumption, architecture decision affected, untestable production claim, steady/burst workload (matches, connections, ramp, payload, duration, warm-up, repetitions, seed and resource limits), metrics and thresholds. Changing thresholds after results starts a new experiment. Metrics only as needed: throughput, p50/p95/p99 with defined population, drops, duplicates, out-of-order, handoff/reconnect, history time, connection success, CPU/memory.

Measurement rules: measure the exact boundary claimed (`ingest→receiver` ≠ `ingest→viewer screen`); use monotonic elapsed timing; repeated runs when variance matters, no cherry-picking; disclose local CPU/memory/container limits, file-descriptor/ephemeral-port/loopback/load-generator bottlenecks; identify saturation knee/headroom when feasible. For reduced scale, state what shrank, what property is believed comparable, why, and that 100,000-viewer capacity was **not** measured. Reproduce 10/50 events/s, 8 matches, +40k/2min analogue, reload/reconnect and relevant event classes when material.

Outcome is `ACCEPT | REJECT | INCONCLUSIVE` against the frozen assumption, **not** approval of the entire architecture. Failed or inconclusive tests are useful evidence and must not be hidden or rerun until a lucky pass.

## Minimal implementation, execution and proof

AI may help research, draft, code, test and calculate; it must not invent requirements, APIs, numbers, provider features, test executions or claims, change acceptance after seeing results, expand scope, conceal failures, or choose architecture the candidate cannot defend. Missing evidence is `UNKNOWN`/`BLOCKED`.

POC includes only what changes the selected measurement; avoid unnecessary authentication, database, Kubernetes, Terraform, cloud SDK, polished UI or CI/CD. Clean checkout plus container runtime; one command such as `docker compose up --build` must build, start, generate declared load, measure and clearly report result. No cloud credentials, hidden local files or external spend; pin material versions and seed where needed. Example output fields: experiment, measured runs, generated/delivered/dropped/duplicate/out-of-order events, relevant latency percentiles, criterion and verdict. Do not package generated logs.

Traceability: assignment requirement → architecture decision → risky assumption → frozen local experiment → measured result → verdict → proposal confirmation/change. Before final delivery, verify fixed facts, provider honesty, state/history coherence, alternatives after composition, geographic and cost/latency budgets, primary-source mutable facts, single falsifiable POC, reproducible command, honest measurement/proxy limitations, word limits and clean package. Stop when the selected assumption has a valid or inconclusive outcome and the evidence is reflected honestly; further polish without validity gain is out of scope.

**Transfer hypothesis for DT (unverified):** A source→consumer provenance receipt and full-chain mission acknowledgement should be tested end-to-end, not inferred from a scheduler or component-only pass. This document supplies an analogy for experimental discipline, not a new approved Borg task. Current DT parity, active consumer, permission and independent Ground remain UNKNOWN.
