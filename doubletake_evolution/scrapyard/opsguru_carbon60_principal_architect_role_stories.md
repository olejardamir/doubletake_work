# Practical Role Stories — OpsGuru + Carbon60 Principal Software Architect Interview Preparation

This version is built specifically around the **OpsGuru + Carbon60 Principal Software Architect** opportunity.

It uses only the first three positions represented in the JSON resume, with the company sequence restored as:

1. **Astrocytech — Principal Software Architect**
2. **Ross Video — AI R&D / Lead Developer**
3. **SalesChoice — Software Engineer (NLP)**

The purpose of this document is not to force every technology into every project. The stronger architecture story is to show that each technology had a clear responsibility, that the systems could realistically have existed together, and that the engineering decisions connect to the responsibilities OpsGuru expects from a Principal Architect: cloud architecture, modernization, microservices, data and AI workloads, infrastructure decisions, cost awareness, customer guidance, delivery oversight, and technical leadership.

---

# 1. Astrocytech — Principal Software Architect

## Core story

At Astrocytech, I worked at principal-architecture level on a large AI data-processing platform.

The source data estate was approximately **412 TB**, while text-oriented releases and processing targets were measured at approximately **1.3 trillion tokens**. I would keep those two measurements separate in conversation: 412 TB described the broader source estate and processing footprint, while the token count described the text content being prepared for language-model training, evaluation, and research.

The main architectural problem was not simply storing large amounts of text. It was creating a platform that could repeatedly transform a large, mixed-source corpus into **traceable, reproducible, quality-controlled dataset releases** without requiring peak compute capacity to remain active continuously.

My responsibility was to make the processing model understandable and maintainable across data engineering, ML, infrastructure, and research concerns, and to make sure that individual implementation choices formed one coherent platform rather than a collection of unrelated tools.

## Business and technical requirements

The platform had to support several goals at the same time:

- Process hundreds of terabytes of source material.
- Run large structural transformations efficiently.
- Run Python-heavy model inference and classification at scale.
- Preserve source and processing lineage.
- Produce repeatable dataset versions.
- Support language, quality, privacy, and content-safety classification.
- Recover cleanly from failed distributed jobs.
- Scale compute up for major processing runs and back down afterward.
- Keep infrastructure reproducible.
- Give engineers and researchers a clear way to inspect run and dataset status.
- Prevent automation and AI tooling from receiving unrestricted infrastructure access.

These requirements drove the architecture.

## High-level architecture

The platform can be explained as:

```text
                         +----------------------+
                         |   Source collections |
                         +----------+-----------+
                                    |
                                    v
                         +----------------------+
                         |      Amazon S3       |
                         | raw / staged objects |
                         +----------+-----------+
                                    |
                                    v
                         +----------------------+
                         |    Apache Airflow    |
                         | orchestration / DAGs |
                         +----+-------------+---+
                              |             |
                 large table |             | Python / ML-heavy
                 transforms  |             | distributed work
                              v             v
                    +---------------+   +---------------+
                    | Apache Spark  |   | Ray / RayJobs |
                    | on Kubernetes |   | on Kubernetes |
                    +-------+-------+   +-------+-------+
                            \               /
                             \             /
                              v           v
                         +----------------------+
                         | validation / scoring |
                         | metadata / decisions |
                         +----------+-----------+
                                    |
                                    v
                         +----------------------+
                         |   Apache Iceberg     |
                         | tables over S3 data  |
                         +----------+-----------+
                                    |
                                    v
                         +----------------------+
                         | versioned datasets   |
                         | reports / consumers  |
                         +----------------------+

Infrastructure:
Terraform + AWS + Amazon EKS + Docker
```

## Why Amazon S3 was the storage layer

Amazon S3 was appropriate for the raw and processed corpus because the workload involved very large immutable or append-oriented objects and did not require every document to live in a transactional relational database.

S3 provided the durable object layer. The important distinction is that **S3 stored the actual data files**, while Apache Iceberg provided table semantics and version metadata over those files.

That distinction matters in an architecture interview because Iceberg is not a replacement object store. It is a table format and metadata layer that makes large analytical datasets easier to manage consistently.

## Why Airflow was the orchestrator

Airflow was responsible for **workflow coordination**, not the heavy computation itself.

A processing DAG represented the dependency graph for a dataset release. For example:

1. Validate the source manifest.
2. Normalize document encoding and structure.
3. Run large corpus transformations.
4. Detect language.
5. Run quality and safety classifiers.
6. Detect or redact sensitive information where policy required it.
7. Enrich records with processing metadata.
8. Perform dataset-level validation.
9. Publish the accepted version.
10. Generate release statistics and failure reports.

Airflow knew which stage should run next, recorded run status, and retried or stopped stages according to policy.

I would not describe Airflow as the data-processing engine. Spark and Ray performed the distributed work.

## Why Spark and Ray both existed

Using Spark and Ray in the same platform was intentional because they solved different classes of problem.

### Apache Spark

Spark was strongest for large, table-oriented transformations such as:

- Filtering billions of records.
- Joining processing metadata.
- Repartitioning data.
- Computing structural statistics.
- Deduplication support.
- Applying deterministic transformations across the corpus.
- Reading and writing Iceberg datasets.

For operations that naturally looked like distributed data-frame or SQL-style transformations, Spark was the correct tool.

### Ray

Ray was stronger for Python-heavy or model-oriented work where each worker needed to execute custom Python logic.

Examples included:

- Language-model or classifier inference.
- Quality scoring.
- Toxicity or safety classification.
- Embedding or model-based enrichment.
- Python libraries that did not fit naturally into Spark's execution model.
- Workloads where a model should be loaded once by a worker and reused across many records.

A Ray job could divide work across many workers, keep model state resident in each worker, retry failed tasks, and return processing statistics to Airflow.

The architectural boundary was therefore:

```text
Airflow = orchestration
Spark   = large distributed data transformations
Ray     = distributed Python / model execution
EKS     = container execution environment
S3      = durable object storage
Iceberg = analytical table/version layer
```

That separation prevents the common mistake of describing all five technologies as though they perform the same function.

## Why Amazon EKS was used

Amazon EKS provided the managed Kubernetes environment for the containerized processing workloads.

The purpose of Kubernetes here was operational:

- Schedule containers on available compute.
- Isolate workloads.
- Restart failed workloads.
- Apply CPU and memory requests and limits.
- Scale worker capacity according to processing demand.
- Run different processing services with consistent deployment patterns.
- Allow Spark and Ray workloads to share a common infrastructure platform while retaining different execution models.

Large processing runs could temporarily require substantial compute. EKS allowed the worker layer to expand for a run and contract afterward rather than keeping peak capacity active continuously.

That point is directly relevant to the OpsGuru role because it connects cloud architecture to **cost and total-cost-of-ownership decisions**, rather than treating Kubernetes as a technology chosen for its own sake.

## Why Apache Iceberg was used

The processed corpus needed dataset-level guarantees that a directory full of objects in S3 did not provide by itself.

Iceberg added:

- Dataset snapshots.
- Atomic publication of a new version.
- Schema evolution.
- Partition evolution.
- Reproducible historical versions.
- Rollback and comparison.
- Metadata describing which physical files belong to a logical table version.
- Consistent access from compatible analytical engines.

A model experiment could therefore reference a specific dataset snapshot rather than a mutable S3 folder whose contents might change later.

That was important for both engineering reliability and research reproducibility.

## Data-quality pipeline

A typical document accumulated metadata throughout the pipeline.

The record could contain:

- Source or collection identifier.
- Retrieval or ingestion timestamp.
- Content type.
- Character and token counts.
- Document hash.
- Near-duplicate cluster identifier.
- Language prediction and confidence.
- Mixed-language indicator.
- Quality score.
- Content-safety scores.
- PII detection or redaction status.
- Processing-run identifier.
- Model and rule-set versions.
- Final acceptance, rejection, or review decision.
- Reason codes.
- Published dataset and Iceberg snapshot identifiers.

The important design decision was to retain **why** a record received a particular disposition instead of keeping only a final Boolean flag.

That made it possible to audit a release, investigate regressions, compare datasets, and reproduce earlier decisions.

## Language identification

Language detection happened before language-specific scoring.

A practical workflow was:

1. Normalize obvious encoding problems.
2. Sample representative chunks from long documents.
3. Run Unicode and script checks.
4. Run a multilingual language-identification classifier.
5. Aggregate chunk-level results.
6. Store the predicted language and confidence.
7. Mark strongly mixed or low-confidence documents rather than forcing a false single-language answer.

This prevented an English-specific quality model from being applied indiscriminately to text it was not designed to evaluate.

## Content-safety classification

Content safety was handled as a scored classification problem rather than keyword blocking.

The system could produce category scores for areas such as:

- Harassment.
- Hate or identity-directed attacks.
- Threats.
- Explicit sexual content.
- Extreme violence.
- Severe abusive language.
- Other policy-defined high-risk categories.

Thresholds then translated model scores into actions:

```text
low risk          -> continue
high-confidence   -> reject or restricted partition
borderline        -> human review
```

The model version, threshold set, category scores, and final disposition were retained as metadata.

This kept policy separate from raw model output and made the process auditable.

## Infrastructure as code

Terraform was the appropriate infrastructure-as-code layer for repeatable AWS environments.

I would describe Terraform as managing infrastructure definitions such as:

- Networking and environment configuration.
- EKS-related infrastructure.
- IAM roles and permissions.
- S3 resources and policies.
- Supporting AWS resources required by the processing platform.

The value was not just faster provisioning. It was the ability to review infrastructure changes, reproduce environments, reduce configuration drift, and reason about cost before creating resources.

## Platform API and automation

The processing platform also benefited from a thin service boundary for operations such as:

- Submit an approved processing run.
- Read run status.
- Retrieve processing statistics.
- Inspect the latest published dataset version.
- Retrieve validation failures.
- Query approved dataset metadata.

Where AI-assisted or agentic automation was used, I would describe it as **bounded automation**, not as an unrestricted autonomous agent.

The AI layer could select from approved operations, but:

- Infrastructure credentials stayed in backend services.
- The model did not receive AWS keys.
- Requests were validated.
- Tool operations were allowlisted.
- High-impact actions required deterministic checks or human confirmation.
- Calls and outcomes were logged.

That is the same architectural principle I would use in a customer environment today: the model proposes or selects an action; a governed service boundary decides whether that action is allowed.

## Cost and TCO decisions

The strongest cost story at Astrocytech is elasticity.

The data volume was large, but the maximum processing capacity was not needed continuously.

The platform therefore separated long-lived control components from elastic worker capacity. Compute could scale for large runs and reduce afterward.

Other cost-aware architectural principles included:

- Do not run model inference on GPU-class compute when CPU execution is sufficient.
- Use Spark for data-parallel transformations instead of forcing every task through expensive model workers.
- Avoid repeatedly rewriting large datasets when metadata or Iceberg-level changes can solve the requirement.
- Design partitioning around actual access patterns rather than creating excessive small files.
- Make failed work restartable at a meaningful stage instead of restarting an entire multi-stage release.
- Preserve run statistics so architecture and infrastructure changes can be evaluated against actual processing cost.

This is how I would discuss TCO with a customer: not only the hourly price of a VM, but utilization, operational overhead, failure recovery, data movement, and engineering time.

## Principal-level leadership

My role at this level was not limited to writing processing code.

The principal-architecture responsibility was to:

- Define boundaries between orchestration, compute, storage, and model services.
- Challenge proposals that added technology without a clear operational benefit.
- Translate research and data requirements into production architecture.
- Set API and data-contract expectations.
- Review failure modes before scaling a design.
- Make infrastructure choices understandable to engineers outside the platform team.
- Mentor engineers on service boundaries, distributed processing, and AI integration.
- Keep security and cost considerations part of the architecture discussion rather than afterthoughts.

## How this maps to OpsGuru

This is my strongest example for the OpsGuru requirements around:

- AWS architecture.
- Big-data and machine-learning workloads.
- Cloud-native design.
- Kubernetes and containerized workloads.
- Infrastructure as code.
- Technical leadership.
- Cost-aware cloud architecture.
- Data pipelines.
- Modernization and scalability.
- Communicating tradeoffs between multiple valid technologies.

## Interview version

A concise version I can use verbally:

> At Astrocytech I worked at principal-architecture level on a large AI data platform. The source estate was roughly 412 terabytes, with text releases measured at around 1.3 trillion tokens. I separated the architecture into clear responsibilities: S3 for durable objects, Airflow for orchestration, Spark for large corpus transformations, Ray for Python and model-heavy distributed work, EKS as the Kubernetes execution environment, and Iceberg for versioned analytical tables over S3. Terraform made the infrastructure repeatable. A major design concern was elasticity: large processing runs needed substantial temporary compute, but keeping peak capacity running continuously would have been wasteful. I also treated AI automation as a governed service integration rather than giving a model direct infrastructure access. The role was a combination of architecture, technical leadership, distributed data processing, AI integration, reliability, and cloud-cost decisions.

---

# 2. Ross Video — AI R&D / Lead Developer

## Core story

At Ross Video, I worked on AI-enabled products for broadcast and media workflows.

The work can be described as a portfolio with three connected areas:

1. **Scriptor** — AI-assisted newsroom script generation.
2. **Media intelligence** — multimodal search and content-quality or moderation services.
3. **Real-time broadcast telemetry** — event and status data associated with live or near-live media workflows.

The common architectural problem was integrating probabilistic AI capabilities into broadcast systems that still required deterministic interfaces, predictable failure behaviour, human editorial control, and clear tenant boundaries.

## The most important architectural principle

I did not treat the language model or ML model as the application.

The product had conventional software boundaries around the AI:

```text
React / TypeScript UI
        |
        v
Node.js application / integration layer
        |
        +----------------------+
        |                      |
        v                      v
REST business APIs       FastAPI AI services
                               |
                               v
                       model / inference layer
                               |
                               v
                     structured model result
        |                      |
        +-----------+----------+
                    |
                    v
          deterministic validation
                    |
                    v
             human confirmation
                    |
                    v
        broadcast-system integration
```

This separation mattered because AI output could be useful without being trusted as an unconstrained command.

## Scriptor business problem

Newsrooms often needed to turn incoming information into a usable broadcast script quickly.

The input could include:

- Wire or source copy.
- Story summaries.
- Editorial notes.
- Rundown information.
- Timing constraints.
- Existing templates.
- Speaker information.
- Production requirements.

The output was not simply prose.

A valid broadcast script could contain:

- Presenter text.
- Segment structure.
- Timing information.
- Camera or microphone cues.
- Speaker and studio fields.
- Video or graphic references.
- Production-system instructions.

The core challenge was therefore a **specification problem**: what makes an output valid for the actual newsroom workflow?

That is highly relevant to modern AI-assisted development because the quality of the system depended on turning ambiguous domain knowledge into explicit schemas, constraints, validation rules, and acceptance criteria.

## Reconstructing the specification

One of the difficult product problems was that the person with the deepest historical knowledge of the workflow was no longer available.

Different users also had different templates and editorial styles.

I worked with technical teams, newsroom stakeholders, and people familiar with OverDrive and broadcast workflows to convert tacit knowledge into explicit rules.

We defined:

- Required fields.
- Optional fields.
- Customer-specific template behaviour.
- Timing expectations.
- The separation between spoken text and production cues.
- Which fields the model could propose.
- Which fields required deterministic validation.
- Which actions required human confirmation.
- Which information could be exchanged with surrounding newsroom systems.

This is the part of the Ross story I would emphasize for a Principal Architect role: before choosing technology, I had to establish the operational contract the technology was supposed to satisfy.

## Scriptor application architecture

### React and TypeScript

React and TypeScript supported the editor-facing interface.

The UI allowed an editor to:

- Submit or review story inputs.
- Request a generated draft.
- Compare alternatives.
- Edit the result.
- See validation problems.
- Confirm the final structured script.

TypeScript was useful because the application dealt with structured script objects rather than arbitrary strings. Shared schemas reduced mistakes between the UI and service layer.

### Node.js

Node.js was appropriate for the application and integration layer.

Its responsibilities could include:

- Session and request handling.
- Tenant context.
- UI-facing APIs.
- Integration coordination.
- Request validation.
- Routing requests to AI services.
- Returning structured application responses.

I would not claim Node.js performed the ML inference itself.

### Python and FastAPI

Python and FastAPI were used around AI orchestration and inference because the model ecosystem and supporting ML libraries were Python-centric.

A request flowed approximately as follows:

1. Node.js received the application request.
2. Required fields and tenant context were validated.
3. The AI request was sent to a FastAPI service.
4. The FastAPI service assembled model context and called the appropriate model.
5. The response was parsed into a structured schema.
6. Deterministic validators checked required fields, timing, and allowed production instructions.
7. The editor reviewed or changed the result.
8. Only an approved output could proceed toward the production integration.

The API boundary made it possible to change model implementation without forcing the UI and broadcast integration code to understand model-specific details.

## MOS and OverDrive integration

The architecture considered **MOS protocol** and Ross Video **OverDrive** workflow requirements.

The key safety boundary was that generated language did not silently become a live production command.

The integration consumed a **validated structured representation** after human confirmation.

That protects the live system from several AI failure modes:

- Hallucinated fields.
- Malformed production instructions.
- Unsupported commands.
- Missing required data.
- Model output that is semantically reasonable but operationally invalid.

This is an example of using AI inside a deterministic system rather than replacing the deterministic system.

## Real-time telemetry architecture

The JSON resume includes AWS Kinesis and real-time video telemetry. The clean architecture is to distinguish **telemetry events** from the large media payload.

I would describe it this way:

```text
broadcast / processing systems
          |
          | small time-ordered telemetry events
          v
Amazon Kinesis Data Streams
          |
          +----------------------+
          |                      |
          v                      v
 monitoring consumers      processing consumers
          |                      |
          v                      v
 dashboards / alerts      AI workflow triggers

Large media objects:
source -> Amazon S3 -> media / AI workers
```

Kinesis carried things such as:

- Processing-state events.
- Timing data.
- Asset identifiers.
- Workflow status.
- Tenant identifiers.
- Moderation or analysis requests.
- Completion and error events.

Large video files were stored in S3 rather than pushed as ordinary Kinesis Data Streams records.

That makes the architecture more realistic and avoids using a streaming-event service as bulk media storage.

## Multimodal AI and moderation

The media-intelligence services used Python/FastAPI and Docker around AI capabilities such as:

- Content classification.
- Media-quality checks.
- Moderation assistance.
- Search or retrieval based on media-derived features.
- Generation or enrichment of metadata.

A typical asynchronous flow could be:

1. A media asset or derived segment was stored in S3.
2. An event identified the asset and requested analysis.
3. A consumer retrieved the required media or sample.
4. The AI service ran inference.
5. The result was written as structured metadata.
6. The application surfaced the result for search, review, or downstream processing.

The important point is that the system moved **references and events** through the streaming layer and kept large media in object storage.

## Why AWS and GCP could both appear

The resume contains AWS as the primary cloud environment and GCP GPU instances for AI inference or experimentation.

I would explain that without presenting the architecture as an unnecessarily fragmented two-cloud production system.

The clean story is:

- AWS was the main application and data environment.
- EC2, S3, Kinesis, and Docker supported the application and media workflows.
- GCP GPU instances were used for selected AI experimentation or inference workloads where GPU availability or a specific experiment made that practical.
- Large media was not continuously transferred between clouds as part of every hot-path request.
- Where cross-cloud inference was used, we limited the transferred data to the inputs actually required by that inference path and treated network cost and latency as explicit design constraints.

This is a much stronger architecture answer than saying "we were multi-cloud" without explaining why.

## Cloud-native deployment

The services were containerized with Docker.

For this role, I would keep the deployment story consistent with the resume and describe AWS EC2 as the primary runtime for the application services.

That means:

```text
EC2 = compute hosts
Docker = service packaging
S3 = object/media storage
Kinesis = real-time event/telemetry transport
Node.js = application/integration services
FastAPI/Python = AI services
React/TypeScript = user interface
GCP GPU VMs = selected AI experimentation/inference
```

I would not introduce Kubernetes into this Ross story unless discussing a separate verified deployment, because it is not required to explain the architecture and the resume already gives a coherent EC2/Docker design.

## Multi-tenant design

The broadcast workflows were multi-tenant, so tenant identity had to be carried through the system rather than inferred later.

Important boundaries included:

- Tenant-aware API authorization.
- Tenant identifiers in requests and events.
- Controlled S3 object organization and access.
- No cross-tenant retrieval.
- Per-tenant configuration and templates.
- Logging that preserved tenant context without exposing unrelated customer data.

This is particularly important in AI systems because model context assembly must respect the same data boundaries as the rest of the application.

## Quality and evaluation

The Scriptor prototype was evaluated against representative examples and stakeholder expectations.

The output was checked for:

- Required information.
- Acceptable script structure.
- Timing.
- Separation of spoken text from production instructions.
- Unsupported factual additions.
- Amount of editor revision required.
- Preservation of human editorial control.

An early validation number around 85% can be discussed only with the explanation that it was a project-specific acceptance or quality measure, not a universal "model accuracy" metric.

I would focus more on the evaluation dimensions than on a single percentage.

## Customer-facing and consulting behaviour

Ross is also a useful story for the customer-facing side of the OpsGuru position.

My role required me to:

- Ask domain experts how the workflow actually operated.
- Challenge the assumption that a model should directly control production.
- Translate broadcaster requirements into technical contracts.
- Explain architecture to people who were not ML engineers.
- Demonstrate prototypes.
- Incorporate feedback into the product and backlog.
- Balance what was technically interesting with what was safe and useful to the customer.
- Prepare the R&D work so a development team could take ownership.

This is close to the trusted-advisor pattern OpsGuru describes even though the commercial context was a product organization rather than a consulting engagement.

## Cost and TCO discussion

The strongest cost tradeoffs in this architecture were:

- Keep large media in S3 rather than moving it through expensive or unsuitable message paths.
- Stream compact telemetry events rather than media payloads.
- Use GPU inference only for workloads that justified it.
- Avoid cross-cloud transfer on the latency-sensitive path where it did not add value.
- Separate AI services so they could scale independently from the web application.
- Use asynchronous processing for work that did not need to block an editor request.
- Treat model latency, GPU utilization, cloud egress, and operational complexity as part of the architecture cost.

A Principal Architect should be able to explain these as business tradeoffs, not merely technology preferences.

## Technical leadership

My contribution included:

- Leading AI R&D architecture.
- Turning unclear workflow knowledge into specifications.
- Defining service and data boundaries.
- Reviewing API contracts.
- Establishing patterns for AI integration.
- Creating hardening and failure cases.
- Conducting code and design reviews.
- Mentoring developers.
- Coordinating technical decisions across product, engineering, and domain stakeholders.
- Preparing prototypes for handoff to a product development team.

## How this maps to OpsGuru

This is my strongest example for:

- Customer discovery.
- Trusted technical-advisor behaviour.
- Full-stack architecture.
- React and TypeScript.
- Node.js and Python/FastAPI.
- REST APIs and API contracts.
- AWS cloud design.
- Streaming architecture with Kinesis.
- S3-based media workflows.
- Docker.
- AI and multimodal systems.
- Cross-cloud tradeoff analysis.
- Product modernization.
- Human controls around generative AI.
- Technical leadership and stakeholder communication.

## Interview version

> At Ross Video I led R&D architecture for AI-assisted broadcast workflows. One project was Scriptor, which generated structured newsroom script drafts, but I deliberately kept the AI behind conventional software boundaries. React and TypeScript supported the editor interface, Node.js handled application and integration concerns, and Python/FastAPI handled AI orchestration. Model output went through deterministic validation and human approval before any MOS or OverDrive integration. In related media workflows, AWS Kinesis carried compact real-time telemetry and processing events while S3 held large media assets; that avoided treating a message stream as video storage. We also used GCP GPU instances selectively for AI experimentation or inference rather than making every production request cross-cloud. The architectural theme was integrating AI into a reliable broadcast system without giving probabilistic output direct control of production.

---

# 3. SalesChoice — Software Engineer (NLP)

## Core story

At SalesChoice, I worked across two related product areas:

1. A **Purolator driver mood, engagement, and operational issue-reporting application**.
2. SalesChoice's **AI-assisted revenue-prediction and client-prioritization platform**.

The common engineering pattern was to collect operational or business data, normalize it, enrich it with analytical or NLP results, and return the result to a human decision-maker through an application workflow.

Over time, I also worked on modernization of older services into clearer Java and Python service boundaries, data-processing pipelines, CI/CD, and later bounded agentic-style automation.

## Purolator product

The Purolator application allowed drivers to submit short daily reports from Zebra Android devices.

The interaction had to remain fast because the users were working in an operational environment.

A report could include:

- General mood or engagement.
- Vehicle problems.
- Route issues.
- Operational concerns.
- Free-form comments.
- Location context where appropriate.

Managers could then use dashboards to identify:

- Repeated vehicle problems.
- Negative engagement patterns.
- Geographic clusters.
- Reports that required action.
- Changes in issue frequency.
- Problems that were informational but not directly actionable.

## Mobile and application architecture

The client application used **Ionic, React, and TypeScript** to support Android-oriented workflows while retaining a web-development model.

The broader application contained existing .NET components, but the parts most relevant to the JSON resume and my modernization work were the **Java and Python service boundaries**.

I would explain this distinction explicitly if asked:

- .NET existed in the surrounding application.
- My broader platform modernization work emphasized Java services and Python analytical/NLP services.
- I would not claim that every component was rewritten into one language.

A simplified architecture was:

```text
Zebra Android device
Ionic + React + TypeScript
          |
          v
 application API / existing services
          |
          +---------------------------+
          |                           |
          v                           v
relational business data       RabbitMQ event
                                      |
                                      v
                              Python / FastAPI NLP
                                      |
                                      v
                           BERT + business classifier
                                      |
                                      v
                               structured result
                                      |
                                      v
                          application / dashboard
```

## Why RabbitMQ was used

The NLP step did not need to block the entire user-facing request.

RabbitMQ created an asynchronous boundary between the application and the model service.

The application could:

1. Accept the driver's submission.
2. Store the operational record.
3. Publish an analysis request.
4. Return control to the user.
5. Let an NLP worker process the request.
6. Store the classification result.
7. Update the dashboard when the result was available.

That reduced coupling between mobile interaction latency and model inference latency.

It also made failure handling clearer: an inference failure could be retried without forcing the driver to resubmit the original report.

## NLP service

Python and FastAPI were a natural boundary for NLP because the ML ecosystem was Python-based.

The service used a BERT-based model for sentiment or text classification.

The important design point was that **sentiment was not the business decision**.

A negative comment might not require action, while a neutral comment could describe a serious vehicle defect.

We therefore separated general language sentiment from company-specific actionability classification.

The result could contain fields such as:

- Sentiment category.
- Sentiment confidence.
- Operational-issue category.
- Actionability classification.
- Confidence or uncertainty indicator.
- Model version.
- Processing timestamp.

Uncertain cases could remain visible for human review instead of being silently forced into a high-confidence category.

## GPU cost control

NLP inference introduced a useful cloud-cost lesson.

Starting or reserving accelerated compute for isolated individual requests could be inefficient.

Where latency requirements allowed it, requests could be grouped into controlled batches so that a GPU resource processed meaningful work during its active period.

The design tradeoff was:

```text
lower latency per request
        versus
better accelerator utilization and lower cost per inference
```

That is the kind of tradeoff I would discuss with an OpsGuru customer: the technically fastest architecture is not always the architecture with the best business value.

## Revenue-prediction platform

The second major system helped sales teams prioritize accounts and estimate pipeline outcomes.

The platform combined information such as:

- Accounts.
- Opportunities.
- Opportunity stage.
- Historical wins and losses.
- Sales activity.
- Interaction recency.
- Customer notes or communication where permitted.
- Existing scores and business rules.

The model output could support:

- Win probability.
- Risk.
- Opportunity prioritization.
- Expected revenue.
- Account attention signals.
- Changes in customer behaviour.

The system did not make the commercial decision for the salesperson. It gave the user additional evidence and prioritization.

## Java and Python modernization

The platform had established backend functionality that could not simply be replaced in one rewrite.

I helped modernize the system incrementally by creating clearer service boundaries.

Java remained appropriate for established business services where stability and existing domain logic mattered.

Python was introduced where analytical, NLP, or ML capabilities benefited from the Python ecosystem.

REST APIs created a language-neutral boundary between them.

That allowed modernization without turning the project into a risky "rewrite everything" program.

The pattern was:

```text
existing business capability
        |
        v
well-defined REST contract
        |
        +-------------------+
        |                   |
        v                   v
 Java domain service    Python AI service
        |                   |
        +---------+---------+
                  |
                  v
       normalized application result
```

This is a strong brownfield-modernization story for OpsGuru because it shows that modernization does not require forcing every component onto the newest technology.

## Data pipelines and ETL/ELT

I also worked on Java and Python processing workflows that prepared structured sales data and unstructured text for analytical use.

The workflow was broadly:

1. Retrieve account, opportunity, activity, and text data from approved sources.
2. Validate required fields.
3. Normalize identifiers and timestamps.
4. Transform data into analytical features.
5. Run model or NLP processing.
6. Attach model outputs to the relevant business entities.
7. Surface results through APIs and user interfaces.
8. Monitor stale input, failed processing, and inconsistent outputs.

Some transformations were ETL-style, where data was transformed before loading into a target representation.

Other workflows were ELT-style, where data was loaded into the analytical environment first and transformed afterward.

The important point was not the label. It was making each data movement reproducible, observable, and tied to a business record.

## Storage and application data

The broader platform included different storage technologies for different access patterns.

### PostgreSQL

PostgreSQL was appropriate for structured relational entities such as:

- Accounts.
- Opportunities.
- User-facing reporting records.
- Relationships requiring transactional consistency.

### MongoDB

MongoDB was appropriate for flexible document-oriented information where records evolved more frequently or did not fit a fixed relational schema cleanly.

### Redis

Redis was used for short-lived or frequently accessed data such as:

- Cached results.
- Temporary state.
- Repeatedly requested derived data.

The architecture did not use Redis as the system of record for business data.

## Azure DevOps CI/CD with AWS hosting

The resume contains both **AWS** and **Azure DevOps**.

There is no contradiction.

AWS was the runtime environment for the application and services.

Azure DevOps was used as a build and delivery control plane.

A pipeline could:

1. Run automated tests.
2. Build the Java or Python service.
3. Build a Docker image where appropriate.
4. Publish an artifact.
5. Authenticate to the AWS deployment environment through an approved service connection.
6. Deploy or update the AWS-hosted service.
7. Run post-deployment validation.

Using Azure DevOps for CI/CD does not mean the application was hosted in Azure.

That distinction is worth stating clearly because it makes the resume technology list immediately coherent.

## Bounded agentic-style automation

The JSON resume mentions agentic-style automation.

Because the SalesChoice role spans 2021 to early 2025, I would place this in the **later modernization period**, not imply that LLM agents were part of the platform from the beginning.

The safest architecture story is a bounded multi-step workflow.

For example:

```text
business event
    |
    v
validate inputs
    |
    v
retrieve approved account context
    |
    v
invoke model / analytical tool
    |
    v
apply deterministic business rules
    |
    +---------- uncertain ----------> human review
    |
    v
write approved result
    |
    v
notify application
```

The "agentic" characteristic was that the automation could coordinate several approved steps or tools around a goal.

It was not given unrestricted database or infrastructure access.

Important controls were:

- Defined tool boundaries.
- Input schemas.
- Allowed operations.
- Deterministic validation.
- Audit logs.
- Human escalation for ambiguous or high-impact cases.

This makes the claim technically credible and consistent with modern production patterns.

## Product ownership and delivery

The JSON resume also emphasizes product delivery.

I owned or contributed significantly to backlog work for the AI platform modernization.

That included:

- Converting stakeholder problems into user stories.
- Writing acceptance criteria.
- Prioritizing work against business objectives.
- Separating architectural requirements from implementation preferences.
- Coordinating work that crossed application, data, and model components.
- Managing dependencies.
- Demonstrating completed functionality.
- Handling technical issues that affected delivery.

This is relevant to OpsGuru because Principal Architects are expected to connect technical outcomes with customer business outcomes, scope, and delivery quality.

## Working with customer stakeholders

The Purolator project is my clearest SalesChoice customer example.

The technical requirement was not "build sentiment analysis."

The customer problem was closer to:

> How do we collect a very small amount of useful information from drivers without disrupting their work, and convert those reports into patterns that managers can act on?

That changed the architecture.

It meant:

- The mobile workflow had to be simple.
- NLP could be asynchronous.
- Sentiment alone was insufficient.
- Actionability classification mattered.
- Geographic and repeated-issue patterns mattered.
- Managers needed understandable outputs rather than raw model scores.

That is the same consulting behaviour I would bring to OpsGuru: start with the business decision, then design the technology around it.

## Technical leadership

My contribution included:

- Modernizing Java and Python service boundaries.
- Designing and integrating NLP services.
- Working across mobile, backend, data, and model layers.
- Defining REST contracts.
- Improving data-processing reliability.
- Contributing to CI/CD.
- Owning backlog and acceptance criteria for modernization work.
- Guiding co-op, junior, and mid-level developers.
- Reviewing designs and implementation.
- Explaining model behaviour to non-ML stakeholders.
- Investigating failures across application and model boundaries.

## How this maps to OpsGuru

This role is my strongest example for:

- Brownfield modernization.
- Java and Python services.
- REST APIs.
- Microservice boundaries.
- AWS-hosted applications.
- Azure DevOps CI/CD.
- AI/NLP integration.
- ETL and ELT pipelines.
- Asynchronous processing.
- Cost-aware model inference.
- Product ownership.
- Customer discovery.
- Technical mentoring.
- Controlled agentic automation.

## Interview version

> At SalesChoice I worked on both a Purolator operational-reporting product and the company's revenue-prediction platform. The architecture combined conventional application services with Python NLP and ML services rather than trying to make the model the whole application. For Purolator, drivers used an Ionic/React application on Zebra Android devices; reports were stored by the application and sent asynchronously through RabbitMQ to a Python/FastAPI NLP service. We separated sentiment from business actionability because a neutral mechanical issue can matter more than a negative but non-actionable comment. On the broader platform I helped modernize older functionality into clearer Java and Python service boundaries connected through REST APIs, built ETL/ELT-style processing workflows, and used Azure DevOps CI/CD to deliver AWS-hosted services. In the later modernization work I also used bounded agentic-style workflows for multi-step data and inference operations, with explicit tool boundaries and human escalation rather than unrestricted automation.

---

# Cross-role architecture story for OpsGuru

Across these three positions, the progression I would present is:

```text
SalesChoice
application + NLP integration + brownfield modernization
        |
        v
Ross Video
full-stack AI products + customer workflow discovery +
real-time cloud events + multimodal systems
        |
        v
Astrocytech
principal architecture + large distributed data +
Kubernetes + infrastructure as code + platform governance
```

The common theme is not simply "I have used many technologies."

The common theme is:

> I define clear system boundaries, choose technologies according to workload, explain tradeoffs to stakeholders, integrate AI without surrendering deterministic controls, and modernize systems incrementally while keeping reliability, cost, and delivery in view.

---

# OpsGuru JD coverage

## Cloud architecture

**Evidence**

- Astrocytech: AWS, EKS, S3, Terraform, distributed compute.
- Ross Video: AWS EC2, S3, Kinesis, Docker, selective GCP GPU use.
- SalesChoice: AWS-hosted services with Azure DevOps CI/CD.

**Principal-level message**

I can discuss not only how a service works but why a customer should choose one deployment model over another.

## Insights from Data / Big Data / Machine Learning

**Evidence**

- Astrocytech: hundreds of terabytes, Spark, Ray, Iceberg, AI training datasets.
- Ross Video: multimodal AI, media analysis, generative AI.
- SalesChoice: NLP, sentiment, business classification, revenue prediction, ETL/ELT.

## Cloud adoption and modernization

**Evidence**

- Astrocytech: cloud-native processing platform.
- Ross Video: AI functionality built as cloud services around existing broadcast workflows.
- SalesChoice: incremental Java/Python modernization rather than a high-risk rewrite.

## Microservices

**Evidence**

- Ross Video: Node.js application layer plus Python/FastAPI AI services.
- SalesChoice: Java business services plus Python analytical services.
- Astrocytech: separate orchestration, processing, model, and platform-service boundaries.

## Infrastructure as code

**Evidence**

- Astrocytech: Terraform.

**Message**

Infrastructure definitions were part of the architecture and review process, not manual cloud-console configuration.

## Cost reduction and TCO

**Evidence**

- Astrocytech: elastic processing capacity rather than continuous peak compute.
- Ross Video: media in S3, events in Kinesis, selective GPU and cross-cloud use.
- SalesChoice: asynchronous inference and batching to improve accelerator utilization.

**Message**

I evaluate cost as utilization + operational complexity + reliability + data movement + engineering overhead, not only VM hourly price.

## Technical leadership

**Evidence**

- Astrocytech: principal-level architecture and engineering guidance.
- Ross Video: R&D leadership, design patterns, code reviews, handoff.
- SalesChoice: mentoring junior through mid-level developers and modernization guidance.

## Customer and stakeholder communication

**Evidence**

- Ross Video: broadcaster/editor workflow discovery and demonstrations.
- SalesChoice: Purolator business workflow and manager-facing outputs.
- Astrocytech: translation between research, ML, data, and platform requirements.

## Product and delivery alignment

**Evidence**

- SalesChoice: backlog ownership, user stories, acceptance criteria, prioritization.
- Ross Video: requirements reconstruction, prototype validation, product handoff.
- Astrocytech: platform architecture driven by release and processing requirements.

---

# Important claim boundaries

The OpsGuru JD contains several senior consulting requirements that should be handled carefully.

The goal is to connect adjacent experience without inventing experience that is not supported.

## CxO / VP presentations

The role asks for presentations to CxO and VP audiences.

The three role stories support stakeholder communication, customer discovery, demonstrations, and technical explanation.

Do **not** automatically say "I regularly presented to CxOs" unless that is factually true.

A safe answer is to describe the highest-level stakeholders actually involved and explain that the communication style changed according to the audience.

## Pre-sales and Statements of Work

The Ross and SalesChoice work supports:

- Technical discovery.
- Customer demonstrations.
- Requirements clarification.
- Architecture recommendations.
- Scoping technical work.

Those are highly transferable to pre-sales.

Do **not** claim ownership of formal SOW creation or quota-carrying sales unless that actually happened.

## Budget ownership

The architecture stories strongly support:

- Cloud-cost tradeoffs.
- GPU utilization decisions.
- Elastic-compute decisions.
- Resourcing and delivery tradeoffs.

That is different from having formal ownership of a departmental or project budget.

If asked directly, distinguish **cost modelling and architecture economics** from formal budget-signing authority.

## Direct people management

The stories support:

- Mentoring.
- Technical leadership.
- Code and design review.
- Guiding junior and mid-level developers.

Do not call engineers "direct reports" unless they formally reported to you.

The OpsGuru role says people management **may** be required, so strong technical leadership is still relevant even if formal line-management experience is more limited.

---

# Technology consistency rules

These are the points I should keep consistent throughout the interview.

## Astrocytech

- **S3 stores data.**
- **Iceberg manages analytical table metadata and snapshots over S3 files.**
- **Airflow orchestrates.**
- **Spark performs large data transformations.**
- **Ray performs Python/model-heavy distributed work.**
- **EKS runs containerized workloads.**
- **Terraform defines infrastructure.**
- Do not say EKS itself processes documents.
- Do not say Iceberg is a separate database containing the corpus.
- Do not say Airflow is the distributed compute engine.

## Ross Video

- **Kinesis Data Streams carries telemetry and events, not large video files.**
- **S3 carries media objects and artifacts.**
- **React/TypeScript is the editor/client UI.**
- **Node.js handles application/integration concerns.**
- **FastAPI/Python handles AI orchestration and inference.**
- **Docker packages services.**
- **EC2 is the principal AWS compute story.**
- **GCP GPU instances are selective AI experimentation/inference capacity, not an unexplained duplicate production platform.**
- Model output does not directly control OverDrive.

## SalesChoice

- The surrounding Purolator application can contain .NET components, while **my resume-level modernization story is Java + Python**.
- **RabbitMQ is asynchronous transport**, not permanent business storage.
- **PostgreSQL is relational system-of-record data.**
- **MongoDB is flexible document data where appropriate.**
- **Redis is cache/temporary state**, not the authoritative database.
- **Python/FastAPI hosts NLP/analytical services.**
- **Azure DevOps performs CI/CD while AWS hosts the application.**
- Agentic-style automation belongs to the **later** part of the 2021–2025 role.
- Agentic automation is bounded by APIs, schemas, rules, audit, and human escalation.

---

# Overall Principal Architect answer

If asked why these roles make me a fit for OpsGuru, I would summarize them this way:

> My background combines three layers that I think are important for this role. At SalesChoice I worked close to application modernization, data pipelines, customer workflows, and Java/Python AI-service integration. At Ross Video I moved further into architecture and R&D leadership, designing full-stack AI products, real-time AWS event flows, and customer-facing broadcast integrations where AI had to coexist with deterministic production controls. At Astrocytech I worked at principal-architecture level on a much larger distributed-data problem, using AWS, EKS, Terraform, Spark, Ray, S3, and Iceberg to build a scalable and reproducible AI-data platform. Across all three, the pattern is that I start from the business and operational requirement, define clean technology boundaries, explain the tradeoffs, and keep cost, reliability, security, and delivery part of the architecture decision.
