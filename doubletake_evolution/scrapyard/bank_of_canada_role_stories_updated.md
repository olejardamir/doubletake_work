# Practical Role Stories — Bank of Canada Interview Preparation

The following stories are arranged in the same order as the positions in the JSON resume. The first three sections have been updated using the more specific Astrocytech, Ross Video, and SalesChoice project context. Cobalt Ridge Systems and the remaining positions are unchanged.

## 1. Astrocytech — AI & Automation Engineer

At Astrocytech, I worked on the processing layer for a **412-terabyte unstructured-text corpus containing approximately 1.3 trillion tokens**. The purpose of the platform was to convert a large mixed-source collection of raw text into clean, traceable, and versioned datasets that could be used for language-model training, evaluation, and research.

### What information the dataset contained

The safest way to describe the corpus is as a **mixed-source, web-scale unstructured-text dataset**. It contained documents and text records collected from multiple permitted sources rather than information from one business application.

The records could include categories such as:

- General web and document text
- Articles and long-form written material
- Technical and instructional documentation
- Public or licensed knowledge sources
- Discussion-style and question-and-answer text
- Other structured-as-text records converted into a common document format

The exact source composition could change between releases. For that reason, every document carried source and processing metadata so that the team could identify where it came from, how it was handled, and whether it was eligible for a particular training or evaluation dataset.

I would not describe the corpus as financial data, customer banking records, or a single collection of scientific papers unless that source is separately verified. The defensible description is a large, mixed-domain text corpus prepared for AI training and evaluation.

### How the processing platform worked

The core processing platform did **not** run on Databricks. Apache Airflow coordinated the workflow. Airflow tasks launched Python, Apache Spark, and Ray workloads in an Amazon EKS environment. The resulting datasets were written to Amazon S3 and managed as Apache Iceberg tables.

A simplified flow was:

1. Raw documents arrived in Amazon S3.
2. Airflow created a processing run and recorded the code, configuration, and source version.
3. Spark handled large corpus-wide transformations.
4. Ray handled Python-heavy and model-inference stages that benefited from flexible parallel execution.
5. Quality, privacy, language, toxicity, and metadata stages produced scores and decisions.
6. Accepted records were written to versioned Iceberg tables.
7. Dataset-level reports summarized what was accepted, rejected, redacted, or sent for review.

### What Amazon EKS did

**Amazon Elastic Kubernetes Service, or EKS, provided the managed Kubernetes environment in AWS.**

In practical terms, EKS gave us a controlled place to run the containerized processing services and workers. Kubernetes scheduled the containers onto available compute nodes, restarted failed containers, isolated workloads, and allowed the platform to add or remove compute capacity as processing demand changed.

For this project, EKS was the execution environment around the processing tools. It did not itself clean the data or train the models. It provided the infrastructure on which the Python, Spark, Ray, and supporting services ran.

A large corpus-processing run could require many workers temporarily. EKS allowed the team to scale those workers for the run and reduce them afterward instead of maintaining the maximum amount of compute continuously.

### What Ray Jobs did

**Ray Jobs submitted and managed packaged Python or Ray applications on a Ray cluster.**

Spark was appropriate for large table-oriented operations such as filtering, joining, repartitioning, and corpus-wide transformations. Ray was useful for stages that involved Python functions, model inference, or more flexible task-level parallelism.

For example, a Ray job could:

- Divide a document batch among many workers
- Load a language, toxicity, or quality model once per worker
- Score many documents in parallel
- Retry failed tasks
- Return status and processing statistics to the orchestration layer

Airflow remained the high-level orchestrator. A typical Airflow task submitted a Ray job, monitored its execution, captured its result, and then allowed the next pipeline stage to begin.

### What Apache Iceberg tables did

**Apache Iceberg provided a reliable table layer over the files stored in Amazon S3.**

Without a table format, a large S3 dataset can become a collection of files whose versions, partitions, and schemas are difficult to control. Iceberg added table-level metadata and made the data behave more like a managed analytical table.

Iceberg was useful for:

- **Dataset snapshots:** Each published version could point to a precise set of files.
- **Reproducibility:** Researchers could identify the exact dataset version used for an experiment.
- **Schema evolution:** Fields could be added or changed in a controlled manner.
- **Partition evolution:** The physical organization could change without rewriting all consumer logic.
- **Atomic publication:** A new dataset version became visible as a complete snapshot rather than as a partially written directory.
- **Rollback and comparison:** The team could compare releases or return to an earlier snapshot.
- **Multi-engine access:** Spark and other compatible analytical tools could work with the same tables.

The actual text and metadata files remained in S3. Iceberg maintained the table structure, manifests, snapshots, and file-level references that made those files manageable.

### How language identification was done

Language identification was performed before language-specific filtering and model scoring. The pipeline used a compact multilingual language-identification classifier, supported by Unicode and script-level checks.

The process was designed to work at both the document and chunk level:

1. The system normalized obvious encoding problems and sampled representative text.
2. Script checks identified patterns such as Latin, Cyrillic, Arabic, or CJK characters.
3. A multilingual classifier produced a predicted language and confidence score.
4. Longer documents could be checked in several chunks rather than using only the beginning.
5. The results were combined into a document-level decision.
6. Low-confidence or strongly mixed-language documents were labelled accordingly instead of being forced into one language.

The output included fields such as:

- Predicted language
- Confidence score
- Languages detected in different chunks
- Mixed-language indicator
- Unsupported or unknown-language indicator
- Model and rule-set version

The purpose was not merely to label the data. Language identification allowed the team to:

- Build language-specific datasets
- Apply the appropriate tokenizer or classifier
- Measure language coverage and imbalance
- Remove records in unsupported languages
- Detect pages containing navigation text or several unrelated languages
- Avoid evaluating an English-language quality model on text it was not designed to score

### How toxicity classification was done and why

Toxicity classification was implemented as a **multi-stage content-safety decision**, not as a simple search for prohibited words.

A classifier assigned scores to categories such as:

- Harassment or abusive language
- Hate or identity-directed attacks
- Threats
- Explicit sexual content
- Extreme violence
- Severe profanity or degradation
- Other high-risk content categories defined by the dataset policy

Rules and context checks supplemented the classifier. This mattered because individual words can be harmless in quotation, reporting, medical, legal, or educational contexts.

The pipeline used thresholds:

- **Low-risk records** could proceed automatically.
- **High-confidence prohibited records** could be rejected or placed in a restricted partition.
- **Borderline or high-impact records** were sent to a human-review queue.
- Every decision recorded the model version, category scores, threshold, and final disposition.

The purpose depended on the target dataset. Toxicity filtering could be used to:

- Prevent an unrestricted training dataset from overrepresenting abusive material
- Create a safer general-purpose corpus
- Protect human reviewers from unnecessary exposure
- Produce separate controlled datasets for safety research
- Measure how much harmful content was present in each source
- Prevent low-quality toxic spam from passing ordinary quality filters

Toxicity was therefore treated as metadata and a policy input. It was not assumed that every flagged record must always be permanently deleted.

### How metadata enrichment was done and why

Metadata enrichment converted a raw text record into a traceable data asset. Some fields came directly from the source, while others were calculated during processing.

A processed record could include:

- Source identifier, domain, or collection
- Retrieval or ingestion time
- Content type
- Character, word, and token counts
- Predicted language and confidence
- Document hash
- Near-duplicate cluster identifier
- Quality score
- Toxicity-category scores
- PII-detection and redaction status
- Licensing or permitted-use category
- Processing-run identifier
- Code, model, rule-set, and configuration versions
- Acceptance, rejection, or review decision
- Reason codes for the decision
- Output dataset and Iceberg snapshot identifiers

Spark produced scalable structural metadata such as counts, hashes, and document statistics. Model-based Ray stages added classification and scoring fields. Airflow added run-level lineage, and the publication process linked each accepted record to the resulting Iceberg snapshot.

Metadata enrichment was necessary for:

- Filtering and dataset construction
- Reproducing an earlier release
- Comparing dataset versions
- Auditing why a record was accepted or rejected
- Measuring language, source, and topic coverage
- Investigating regressions
- Applying licensing and retention rules
- Tracing a model-training example back to its processing history

### What Model Context Protocol integrations are

**Model Context Protocol, or MCP, is a standard way for an AI application to discover and call external tools through structured interfaces.**

In this project, an MCP server acted as a controlled adapter between the AI agent and the Databricks APIs. Instead of giving the model unrestricted network or workspace access, the server exposed a limited list of named tools with defined parameters and responses.

For example, the MCP server could expose tools such as:

- `list_databricks_jobs`
- `get_job_status`
- `run_approved_job`
- `query_approved_sql_warehouse`
- `retrieve_job_output`

The agent first selected a tool and generated structured arguments. The MCP server then:

1. Validated the tool name and parameters.
2. Checked whether the requested action was permitted.
3. Obtained or used the appropriate Databricks credential.
4. Called the Databricks REST API over HTTPS.
5. Validated and reduced the returned data.
6. Returned a structured result to the agent.
7. Recorded the tool invocation for auditing.

MCP standardized the tool boundary. Databricks still performed the actual workspace, job, or query operation.

### How the agent called Databricks securely

For the interview story, the secure authentication method is **OAuth 2.0 machine-to-machine authentication using a Databricks service principal**.

A service principal is a non-human identity created specifically for automated applications. It was assigned only the Databricks permissions required by the MCP tools.

The security flow was:

1. The MCP service authenticated as a Databricks service principal.
2. OAuth client credentials were exchanged for a short-lived access token.
3. The service called the Databricks REST API through HTTPS using that token.
4. Databricks authorized the request according to the service principal’s workspace, job, SQL, and data permissions.
5. The token expired after a limited period and was refreshed by the service when required.

Additional controls included:

- Credentials stored in a secret manager or protected Kubernetes secret, never in the prompt
- TLS/HTTPS for all API traffic
- Least-privilege Databricks permissions
- Separate service principals for different environments where appropriate
- Tool allowlists so the agent could call only approved operations
- Parameter validation and output filtering in the MCP server
- Human confirmation for destructive or high-impact actions
- Audit logs containing the user request, selected tool, parameters, Databricks operation, and outcome
- No exposure of the OAuth client secret or access token to the language model
- No use of an employee’s personal Databricks username and password

A personal access token could technically call Databricks APIs, but a service principal with OAuth machine-to-machine authentication is a stronger production design because it avoids tying automation to a human account and supports short-lived credentials and controlled permissions.

### The important architectural distinction

- **Airflow, Spark, Ray, EKS, S3, and Iceberg** supported the primary corpus-processing platform.
- **Databricks REST APIs and MCP tools** supported agentic access to an external Databricks workspace.
- Databricks was not installed locally.
- Databricks was not the execution platform for Astrocytech’s main corpus pipeline.
- The language model never received unrestricted Databricks credentials or arbitrary workspace access.

This experience is relevant to the Bank of Canada position because it involved distributed processing, orchestration, versioned analytical datasets, metadata and lineage, quality controls, secure platform integration, and the design of governed interfaces between AI systems and an enterprise data platform.

---

## 2. Ross Video — AI R&D, Lead Developer

At Ross Video, my principal project was **Scriptor**, an AI-assisted system for automated newsroom story and script writing.

The business problem was that newsroom teams often needed to turn incoming information into a usable broadcast script under severe time pressure. A script was not simply an article rewritten in shorter language. It also had to fit the available segment time and reflect how the story would be produced in the studio.

A production script could contain:

- Anchor or presenter text
- Story structure and transitions
- Estimated speaking duration
- Camera and microphone cues
- Speaker and studio information
- Video, graphic, or clip references
- Instructions used by production systems and operators

### The Scriptor workflow

The workflow began with available newsroom information, such as a story summary, wire copy, editorial notes, rundown information, timing constraints, and an editor’s preferred template.

The system normalized that input and generated a first-draft script or several script suggestions. The goal was not to replace the editor. The goal was to reduce the amount of time required to move from raw information to a structured draft.

The application separated two types of work:

- **AI-assisted generation:** Summarizing source material, proposing wording, organizing the story, and generating alternative versions.
- **Deterministic validation:** Checking required fields, structure, timing, production cues, and integration constraints.

For example, the system could propose a shorter version for a limited time window or provide several alternatives with different emphasis. The editor could select, revise, or reject the suggestions before anything entered the live production workflow.

### The main technical and product challenge

The difficult part was not calling a language model. The difficult part was establishing what a valid broadcast script actually meant.

The person with the deepest product knowledge had left the company, and different editors used different writing styles and templates. We had to reconstruct the requirements by speaking with internal teams, clients or newsroom stakeholders, and specialists familiar with OverDrive and newsroom production.

I helped convert those discussions into explicit rules:

- Which information must always be present
- Which elements varied by broadcaster or editor
- How duration should be estimated
- How production instructions should be separated from spoken text
- Where the system should generate suggestions rather than make a final decision
- Which outputs required human confirmation
- What information needed to pass to or from surrounding newsroom systems

### Architecture and integrations

I led the architecture and prototyping work around the AI workflow. A practical design included:

- A Python or FastAPI service for orchestration and model calls
- REST interfaces for submitting story information and receiving suggestions
- A React and TypeScript interface for reviewing drafts
- Structured schemas separating spoken text, timing, and production cues
- Template and configuration data for different newsroom styles
- Logging of model input, output, edits, and validation results
- CI/CD, unit tests, hardening cases, and stakeholder demonstrations

The integration design considered **MOS protocol and OverDrive requirements**. The objective was to exchange structured newsroom and production information without allowing generated text to directly and silently control a live broadcast system.

### Quality and human validation

We evaluated the generated scripts against representative examples and stakeholder expectations. Early validation was described as approximately 85% or better, but the important point was understanding what that measure represented.

The system was assessed on whether it:

- Included the necessary story information
- Followed an acceptable structure
- Stayed within the intended time window
- Separated spoken language from production instructions
- Produced wording that an editor could use with limited revision
- Avoided inventing unsupported facts
- Preserved human editorial control

The project eventually moved from the R&D and validation stage toward handoff to a development team.

### My role

My contribution included:

- Leading the Scriptor R&D effort
- Reconstructing requirements after the original expert left
- Translating broadcast workflows into an implementable architecture
- Separating model-generated suggestions from deterministic production rules
- Defining schemas, validation behaviour, and human-review points
- Coordinating with stakeholders around OverDrive and MOS integration
- Building or guiding the prototype and its interfaces
- Establishing tests, hardening cases, CI/CD expectations, and demonstrations
- Preparing the project for handoff to the development team

This experience is relevant to the Bank of Canada position because it required converting ambiguous operational requirements into a governed data and application design, establishing trusted interfaces, validating generated outputs, maintaining human controls, and coordinating across technical and business teams.

---

## 3. SalesChoice — Software Engineer, NLP

At SalesChoice, my work covered two related areas:

1. A **Purolator driver mood, engagement, and issue-reporting product**
2. SalesChoice’s core **AI-assisted revenue prediction and client-prioritization engine**

Both projects required turning operational and interaction data into information that managers or sales teams could use.

### Purolator driver mood and issue-reporting tool

The Purolator product allowed drivers to submit short daily reports from Zebra Android devices. The interaction had to be quick and easy because drivers were working in operational environments and could not spend significant time completing a form.

A driver could report:

- General mood or engagement
- A broken vehicle
- A vehicle or route concern
- An operational problem
- Free-form comments
- Location-related information where appropriate

The product then made that information available to managers through dashboards. The objective was to identify patterns that might otherwise remain hidden in individual reports.

For example, managers could look for:

- Repeated vehicle problems
- Negative mood or engagement patterns
- Issues concentrated in a depot or geographic region
- Reports requiring immediate action
- Problems that were outside the organization’s ability to resolve
- Changes in reporting patterns over time

### Driver application and backend architecture

The mobile application used **Ionic and React** so it could support Zebra Android devices while remaining adaptable to other device and web contexts.

The backend included:

- C#/.NET services for the main application workflow
- PostgreSQL on AWS for structured reporting data
- Geospatial or polygon-based queries for regional dashboard analysis
- Redis for temporary or stateless application data
- RabbitMQ for communication with the NLP service
- A Python and FastAPI service hosting the BERT-based analysis
- Dashboard and reporting interfaces for managers

During development, we had to mock Android integrations, location behaviour, and device-specific functions locally. We also tested the application on physical Zebra devices because third-party mobile libraries and battery behaviour could differ from ordinary browser testing.

### Mood, sentiment, and actionability analysis

The free-text reports were sent from the .NET backend to the Python NLP service through RabbitMQ.

The Python service used a **BERT-based sentiment model** because driver comments could contain short, informal, and grammatically inconsistent text. A simple positive-versus-negative word list would not handle context reliably.

The model returned sentiment information that could support the dashboard, but sentiment alone was not enough. A strongly negative report might describe something the company could not directly fix, while a neutral report might describe a serious mechanical problem.

We therefore also used company-specific classification to determine whether a report was likely to be:

- Actionable by the organization
- Related to a vehicle or operational issue
- A general mood or engagement signal
- Informational only
- Uncertain and in need of review

RabbitMQ made the NLP step asynchronous and reliable. The main application could accept the driver submission, place an analysis request on the queue, and receive the classification result without tightly coupling the user-facing application to the model’s processing time.

AWS GPU cost also affected the design. Because short GPU usage could still trigger a larger billing unit, inference requests could be batched within controlled windows instead of starting an expensive GPU resource for every individual report.

### SalesChoice’s core revenue prediction engine

The second major area was SalesChoice’s B2B prediction platform. Its purpose was to help sales teams decide where to spend their time and estimate the likely value of their pipeline.

The engine combined information such as:

- Accounts and customers
- Sales opportunities
- Opportunity stages
- Historical wins and losses
- Interaction frequency and recency
- Sales activities and workflow events
- Customer communication or notes where available
- Existing model scores and business rules

The prediction output could support questions such as:

- Which opportunities are most likely to close?
- Which accounts require attention?
- Which opportunities are at risk?
- How much expected revenue is represented by the current pipeline?
- Where should a salesperson spend limited time?
- Which changes in account behaviour should be surfaced to management?

The engine did not replace the salesperson’s judgment. It converted large amounts of account and interaction data into prioritization and forecasting signals.

### My work on the revenue engine

I worked across the backend, data, model-integration, and user-interface layers.

The platform used technologies including:

- Java for established backend services
- Python for newer analytical and NLP services
- REST APIs between platform components
- Angular, React, and TypeScript for user-facing workflows
- PostgreSQL for relational business data
- MongoDB for document-oriented or flexible records
- Redis for caching and frequently accessed results
- AWS for application hosting and supporting infrastructure
- Jenkins and CI/CD practices for controlled releases

A typical model-serving workflow was:

1. Account, opportunity, and activity information was collected from platform services.
2. The data was validated and converted into the feature structure expected by the prediction service.
3. The model returned probability, risk, prioritization, or expected-value outputs.
4. Backend services attached the result to the appropriate account or opportunity.
5. The user interface displayed the score together with the business context needed to interpret it.
6. Monitoring and logs helped identify stale inputs, model-service failures, or inconsistent outputs.

I also helped modernize legacy areas of the platform into clearer Java and Python service boundaries. This involved defining API contracts, improving SQL and NoSQL access, using Redis where caching was appropriate, adding automated tests, and making releases easier to diagnose.

### Relationship between the two SalesChoice projects

The Purolator application and the revenue prediction platform had different end users, but the engineering pattern was similar:

- Collect operational or interaction data
- Validate and normalize it
- Send appropriate information to an analytical or NLP service
- Store model outputs with the relevant business record
- Present the result through a dashboard or application
- Keep a human user responsible for the final operational decision

### My role

My contribution included:

- Leading or owning significant parts of the Purolator driver-reporting product
- Building across Ionic/React mobile, C#/.NET, PostgreSQL, Redis, RabbitMQ, and Python/FastAPI
- Implementing BERT-based sentiment and company-specific classification workflows
- Designing reliable communication between the application and NLP service
- Supporting regional and issue-pattern reporting
- Working on the SalesChoice revenue-prediction and client-prioritization platform
- Developing and modernizing Java and Python services
- Integrating model outputs into account and opportunity workflows
- Improving data access, caching, API contracts, tests, and release reliability
- Guiding co-op, junior, and mid-level developers through design and implementation

This experience is relevant to the Bank of Canada position because it involved building complete analytical products: acquiring operational data, creating trusted models and classifications, defining reusable business concepts, integrating results into user workflows, and maintaining reliable backend, storage, and deployment processes.

---

## 4. Cobalt Ridge Systems — Software Engineer, Data Analytics

At Cobalt Ridge Systems, I worked on an internal property-assessment platform used by field specialists and appraisal professionals. The main objective was to make large collections of property information searchable and easier to use in assessment workflows.

I developed backend services using **Java, Spring Boot, and Spring MVC**. These services exposed REST APIs that allowed internal applications to search for properties, retrieve assessment information, and submit data to predictive models.

A typical request might involve finding properties that matched a specific location, building type, assessment range, or set of physical characteristics. The backend received the search criteria, validated the request, translated it into an Elasticsearch query, and returned structured results to the TypeScript interface.

I worked on the **Elasticsearch** layer because simply loading data into an index did not guarantee useful search results. We needed to decide how property fields should be mapped, which fields should be searchable, how filters should behave, and how results should be ranked.

For example, a field specialist might search using an incomplete address or a variation of a property description. I experimented with query expansion, field weighting, and ranking behaviour to improve the relevance of the returned properties. I worked with domain specialists to understand why certain results were useful and why others were not.

The platform also integrated predictive-model outputs with structured property data. My responsibility was not necessarily to create every machine-learning model. I built the services and APIs that allowed an internal application to send property information to a model and receive the result in a format that could be displayed and used in the appraisal workflow.

I also developed customer-facing or internal search interfaces using **TypeScript**. The frontend communicated with the Java REST APIs rather than accessing Elasticsearch or the underlying databases directly.

The services were deployed to **AWS EC2**, with Docker used for containerization and Jenkins and Maven supporting builds and deployments. I participated in monitoring, troubleshooting, code reviews, and release activities.

We also **evaluated Kubernetes through a proof of concept** as part of a possible migration of internal services. Kubernetes was not necessarily the established production platform. My involvement was limited to evaluating whether container orchestration would improve deployment, scaling, and service management.

The important architectural distinction is:

- Java and Spring Boot supported the backend services and REST APIs.
- Elasticsearch supported property search and retrieval.
- TypeScript supported the user-facing search interface.
- Predictive models were integrated into the workflow through APIs.
- AWS EC2 and Docker supported deployment.
- Kubernetes was evaluated as a proof of concept rather than presented as an established production environment.

This experience is relevant to the Bank of Canada position because it involved turning heterogeneous operational information into a trusted analytical product, designing data-access services, improving retrieval quality, integrating analytical models, and working directly with domain experts to translate business needs into technical behaviour.

---

## 5. Meridian Data Works — Full-Stack Developer

At Meridian Data Works, I worked on prototypes and internal applications for processing and analyzing text-oriented and healthcare-adjacent data. The work combined distributed data processing with backend APIs and user-facing interfaces.

I developed data-processing workflows using **Python and Apache Spark**. The purpose of Spark was to process datasets that were too large or inefficient to handle through a simple single-process script.

A typical workflow began with files stored in **Amazon S3**. The processing application loaded the data, validated the expected fields, transformed the records, and produced a cleaner dataset for NLP or analytical use.

For healthcare-adjacent information, data privacy was an important part of the processing design. Pipelines could apply anonymization or remove fields that should not be exposed to downstream users. Validation checks ensured that required fields existed and that malformed records were identified rather than silently included in the results.

I also built backend REST APIs using Python or Java-based services. These APIs allowed other applications to submit data-processing requests, access analytical results, or interact with NLP models without needing to understand the internal Spark implementation.

On the frontend, I used **React and TypeScript** to build internal interfaces where users could submit information, review processing status, and inspect results. The purpose of the interface was to make an experimental NLP capability usable by people who were not data engineers.

I also created wrapper libraries and command-line utilities that gave data scientists a consistent way to access NLP models and Spark workflows. Rather than requiring each person to write their own integration code, the wrapper provided documented commands and expected input and output formats.

The applications and microservices were deployed on **AWS EC2**, with Docker used for packaging. Jenkins and Maven supported automated builds, testing, and deployment.

I participated in troubleshooting and support during evaluation periods. When a processing job failed, I examined whether the problem came from malformed input, a Spark transformation, resource limitations, an application error, or the deployment environment.

The important architectural distinction is:

- Spark was used for distributed processing and NLP-oriented data pipelines.
- Python and Java supported processing logic and backend services.
- React and TypeScript supported internal user interfaces.
- S3 provided cloud-based input and output storage.
- Docker, EC2, Jenkins, and Maven supported deployment and delivery.
- Much of this work involved prototypes and evaluation platforms, so it should not be described as operating a large enterprise production lakehouse unless additional evidence supports that claim.

This experience is relevant to the Bank of Canada position because it involved creating repeatable ingestion and transformation workflows, applying data validation, using Spark for distributed processing, exposing data through reusable interfaces, and automating application delivery.

---

## 6. Harborlight Technologies — Back-End Java Developer

At Harborlight Technologies, I worked primarily on backend Java services and system integrations. The role focused on moving information correctly between applications, databases, and external interfaces.

I developed and maintained integration points using **Java, REST APIs, XML, JSON, and Oracle PL/SQL**. The systems involved different data formats and service contracts, so a major part of the work was translating information from one representation into another without losing required fields or violating business rules.

For example, one application might send an XML request while another system expected a JSON structure or a database procedure call. I helped implement the logic that received the original request, validated it, transformed the fields, called the appropriate downstream service or database operation, and returned a structured response.

I worked with **Oracle PL/SQL** when application services needed to retrieve or update information in Oracle databases. This included calling stored procedures, investigating database results, and confirming that application-level data matched what was stored in the database.

I also maintained service contracts and **Swagger/OpenAPI documentation**. This documentation described available endpoints, required parameters, request formats, response formats, and possible errors. Keeping these contracts accurate was important because other development teams depended on them when integrating with our services.

Production support involved tracing failures across several layers. When an integration did not work, I might examine the original XML or JSON request, application logs, API responses, database records, and downstream-system behaviour to identify where the data was rejected or transformed incorrectly.

I participated in peer code reviews, requirements discussions, technical documentation, and Agile sprint planning. Jenkins and Maven supported the build and CI/CD process. I helped maintain these pipelines and participated in release validation before changes were deployed.

I also supported production systems and investigated integration or data-pipeline incidents. My responsibility was to determine the technical cause, correct the immediate problem, and help prevent the same failure from recurring.

The important architectural distinction is:

- Java supported the backend application and integration logic.
- REST APIs provided communication between systems.
- XML and JSON were the principal interchange formats.
- Oracle PL/SQL supported database access and processing.
- Swagger/OpenAPI documented the service contracts.
- Jenkins and Maven supported builds and deployments.
- This role should be described as backend integration and production-support work, not as ownership of a modern cloud lakehouse or analytics platform.

This experience is relevant to the Bank of Canada position because it established the foundation for later data-platform work: controlled data movement, validation, interface contracts, traceability, production troubleshooting, and disciplined delivery across interconnected enterprise systems.

---

## Overall Career Story

Across these roles, the common theme is that I moved from developing individual backend services to owning increasingly complete data and analytics platforms.

Early in my career, I focused on APIs, database integration, controlled releases, and production support. I then moved into distributed processing, Spark pipelines, cloud deployment, search, and analytics systems. In later roles, I took responsibility for architecture, platform reliability, data quality, technical standards, and mentoring other engineers.

The Bank of Canada position is a natural continuation of that progression. Microsoft Fabric would be a new platform context, but the underlying responsibilities are familiar: designing how data enters the platform, transforming it reliably, creating trusted analytical models, automating deployment and testing, enforcing governance, and helping business users obtain dependable information from complex systems.
