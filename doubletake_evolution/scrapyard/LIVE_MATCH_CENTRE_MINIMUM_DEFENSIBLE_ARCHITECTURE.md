# Live Match Centre — minimum defensible architecture (historical, 2026-08-19)

**Provenance:** Distilled in place from original Git blob `57cd7e532faf8bf7205c1fd2df2d09c45af7d9b0`; governing assignment `requirement.pdf` was NOT independently available in this run. This is an assignment-specific architecture hypothesis, **not** implemented DT architecture or proven production performance. Original complete text remains recoverable in Git history.

## Proposed topology and authority

Provider → API Gateway HTTP API (direct SQS integration) → SQS FIFO (group by match ID) → TypeScript canonical processor Lambda → DynamoDB canonical EVENT / HEAD-STATE / IDEMPOTENCY / ACTIVE_MATCH; after durable commit, Lambda publishes to private NLB → Nchan EC2 Auto Scaling fleet backed by shared ElastiCache Redis OSS 7.1. CloudFront serves S3-hosted Next.js static export and proxies read-only `/live/*` SSE subscriptions to private NLB. Browser uses native EventSource plus `canonical_seq` reducer. Lobby has one latest-full-state channel (buffer=1) for at most eight matches; each active match has a buffered history-to-live Nchan channel. Only custom production code: canonical Lambda and frontend/reducer.

**Distinct boundaries:** SQS FIFO serializes transport per match but does not prove provider semantic order. Nchan SSE `id`/`Last-Event-ID` resumes transport, not application identity; browser suppresses duplicate/regressing canonical sequences. DynamoDB, not Nchan/Redis, owns durable truth. If canonical transaction commits but publish is uncertain, SQS retry republishes the **same** canonical sequence without reallocating an event. This is a proposed idempotency design, not a tested guarantee. A full-buffer oldest-first match stream replaces normal snapshot/replay only if buffer retention, late-join latency and failover tests pass; canonical history still must permit rebuilding after Redis loss. Unknown provider event IDs, ordering, corrections and clock rules remain a major unresolved dependency.

**Configuration assumptions requiring verification:** Nchan supports SSE, heartbeat, oldest-first replay and shared Redis storage; multi-AZ EC2/NLB drains and rolling refresh; CloudFront streaming with caching disabled, heartbeats within origin-read timeout and no total response completion timeout; provider authentication/throttling per actual contract. Do not invent credentials or assume Valkey compatibility. Redis OSS 7.1 was chosen for documented compatibility, not proven optimality. WAF omitted only from the stated baseline, not as a universal security recommendation. S3 static export uses stable query routes for dynamic match IDs.

## Falsifiable acceptance / negative controls

Assignment-reported target envelope: 8 simultaneous matches; 10 events/s typical, 50/s burst; 100,000 viewers with +40,000 connections over two minutes; approximately 60% Europe / 40% North America; goal p95 ≤2s, other-event p95 ≤5s, complete late-join active-match history ≤2s under load; monthly cost ≤$3,000; weekly rolling deployment. **None independently measured here.** Use pinned Nchan/Nginx and Redis images, deterministic TypeScript publisher and multi-generator raw SSE client (capture IDs, canonical sequences, timing and generator saturation). Do not rely on an experimental SSE load-test plugin.

Tests must include late join while publishing, reconnect across nodes, stale `Last-Event-ID`, transport/application ID mismatch, duplicate SQS delivery, post-commit publish uncertainty, provider event reorder/correction, Redis loss/rebuild, cross-AZ failover, rolling deployment, unknown provider schema, backlog exhaustion and missing provider authentication. Explicitly measure complete history ≤2s *under 100k fan-out*, end-to-end p95, no missing/duplicated canonical UI events, durable recoverability and true cost. If shared Nchan buffer cannot meet these, restore an authorized snapshot/replay strategy rather than claim closure. Generator overload invalidates load-test conclusions.

## DT relevance and limits

Potentially transferable *pattern*: separate durable canonical state from ephemeral delivery; retry committed effects idempotently; distinguish transport cursor from semantic event identity; require end-to-end independent effect evidence. This overlaps DT's no-loss and mission-consumer concerns but is **not** evidence that DT implements, lacks or should adopt AWS/Nchan. No new research handoff without a demonstrated DT-specific delta; current private consumer, deployment, permission and parity UNKNOWN.

## Primary references (historical; current behavior unverified)

- Governing assignment: `requirement.pdf` (not fetched).
- Nchan documentation and changelog: https://nchan.io/ ; https://nchan.io/changelog
- CloudFront origin streaming: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/RequestAndResponseBehaviorCustomOrigin.html
- CloudFront VPC origins: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-vpc-origins.html
- API Gateway service integration: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-aws-services.html
- SQS FIFO quotas: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/quotas-messages.html
- ElastiCache versions: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/engine-versions.html
- Redis licensing: https://github.com/redis/redis
- AWS Shield: https://aws.amazon.com/shield/pricing/
