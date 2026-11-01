# Historical Live Match Centre simplification audit — distilled

**Dated:** 2026-08-19. **Original blob:** `ea15363566cf67deb19ddaae761a192d3a550656`. Historical design assessment only, not current DT or independently tested cloud deployment. [D01](DISTILLED_KNOWLEDGE.md).

**Conditional removals:** AWS WAF only if demonstrated app-layer abuse requires it; do not assume Nchan→Valkey compatibility—historical source identified Nchan's documented Redis OSS 7.1 ElastiCache dependency, **recheck upstream/version today**. Artillery SSE generator was experimental; prefer small TypeScript streaming client for POC to avoid measurement-harness confound.

**Retained by assigned responsibility:** Redis (Nchan history/cross-node resume), NLB (origin/draining), ASG (self-heal/rolling deploy), API Gateway (provider HTTPS), SQS FIFO (durable best-effort acceptance), Lambda (domain processing), DynamoDB (canonical truth), CloudFront (viewer edge/private origin), S3 (frontend/release separation), Nchan (fan-out), lobby channel (simpler replay). Further removal requires a measured Nchan+Redis+SSE POC; no unsupported simplification. **Unknown:** current upstream support, real deployment and transfer value to DT.
