# Practical Role Stories — OpsGuru + Carbon60 Principal Software Architect

## Source basis

This version is aligned to two source documents:

1. The generated **OpsGuru — Principal Software Architect** resume.
2. The original **Carbon60 / OpsGuru Principal Software Architect** job description.

Only three employer names are used here, following the agreed company mapping:

1. **Astrocytech — Principal Software Architect**
2. **Ross Video — Lead Cloud Architect and Engagement Lead**
3. **SalesChoice — Senior Cloud Solutions Architect**

The role titles, responsibilities, consulting scope, and technology stack follow the generated OpsGuru resume. The employer names are mapped to Astrocytech, Ross Video, and SalesChoice as requested.

This version intentionally removes technologies and project details that appeared in the earlier interview document but are not supported by the generated OpsGuru resume, including Airflow, Ray, Iceberg, FastAPI, Node.js, React, BERT, RabbitMQ, and the earlier dataset-size claims.

---

# What the original OpsGuru JD is really looking for

The original job description is a **Principal Architect in Professional Services**, not only a software-development role.

The strongest requirements are:

- Deep business and technical cloud expertise.
- Ability to work from CEO level to developer level.
- Trusted-advisor responsibility across several customer accounts.
- Cloud adoption.
- Big Data and Machine Learning.
- Microservices adoption.
- Infrastructure as Code.
- Cost reduction and Total Cost of Ownership.
- Multiple complex projects at the same time.
- Pre-sales and solution scoping.
- Support for Statements of Work.
- Budget and resourcing responsibility.
- Customer escalations.
- Technical-team leadership.
- Possible people management for approximately five Architects and Engineers.

The generated OpsGuru resume was written directly around those requirements, so the interview story should show **consulting leadership + architecture + commercial delivery + technology**, not technology alone.

---

# Core technology stack

## Cloud

- Amazon Web Services (AWS)
- Google Cloud Platform (GCP)
- Microsoft Azure
- Hybrid cloud
- Enterprise cloud architecture
- Cloud adoption
- Landing zones

## Platform and infrastructure

- Terraform
- AWS CloudFormation
- Infrastructure as Code
- Kubernetes
- Amazon EKS
- Google Kubernetes Engine
- Azure Kubernetes Service
- Docker
- CI/CD
- GitOps
- Linux
- Observability

## Application and data architecture

- Microservices
- Event-driven architecture
- API design
- REST APIs
- OpenAPI
- Distributed systems
- Data pipelines
- Apache Spark
- Amazon S3
- Amazon Kinesis
- Relational databases
- Elasticsearch
- Python
- Java
- TypeScript

## Consulting and delivery

- Executive advisory
- Technology strategy
- Discovery workshops
- Pre-sales
- Solution scoping
- Statements of Work
- Account management
- Roadmaps
- TCO modelling
- Cloud cost modelling
- Budget management
- Resource planning
- Project governance
- Risk management
- Customer escalations

## Leadership

- Technical leadership
- People management
- One-to-one meetings
- Professional development
- Goal setting
- Performance feedback
- Promotion recommendations
- Mentoring
- Team motivation
- Stakeholder communication
- Conflict resolution

---

# 1. Astrocytech — Principal Software Architect

## Core story

At Astrocytech, I worked as a Principal Software Architect and trusted technical advisor across several customer accounts.

The work was not limited to producing architecture diagrams. I worked across the full technology-adoption cycle:

```text
business problem
      |
      v
discovery and current-state assessment
      |
      v
target architecture and roadmap
      |
      v
cloud / platform / service choices
      |
      v
cost and TCO model
      |
      v
scope + effort + resourcing
      |
      v
delivery oversight
      |
      v
risk / escalation management
      |
      v
operational handover and next roadmap
```

The key responsibility was to make sure the technical solution actually solved the customer's business problem and remained realistic for budget, timeline, team skills, reliability, and operating cost.

## Multi-cloud architecture

I worked across AWS, GCP, and Azure.

I would not present multi-cloud as a goal by itself.

The architectural question was:

> Which platform and managed services best fit the customer's requirements, constraints, existing skills, regulatory needs, cost model, and operating model?

For some customers the right answer could be AWS. For others it could be GCP or Azure. A customer might also have an existing hybrid environment that could not be replaced in one step.

The important principal-level skill was to explain the tradeoff without turning the conversation into a cloud-provider feature list.

## Cloud adoption

Cloud adoption started with the current state.

I would look at:

- Existing applications.
- Data.
- Networking.
- Security.
- Identity.
- Reliability requirements.
- Operating procedures.
- Team skills.
- Cost structure.
- Business deadlines.
- Migration constraints.

From there, I could help define:

- Target architecture.
- Landing-zone needs.
- Workload migration sequence.
- Modernization priorities.
- Platform standards.
- Security and reliability expectations.
- Delivery phases.
- Ownership boundaries.

This is directly aligned with the JD's requirement to discuss every stage of technology adoption.

## Microservices

Microservices were used when they created useful boundaries.

I would look for boundaries around:

- Business capabilities.
- Data ownership.
- Scaling needs.
- Deployment independence.
- Failure isolation.
- Team ownership.

I would not split a system into many small services only because "microservices" were requested.

A principal architect should be willing to tell a customer when a simpler architecture is better.

## Infrastructure as Code

Terraform and CloudFormation were part of the platform approach.

The value of Infrastructure as Code was:

- Repeatable environments.
- Reviewable infrastructure changes.
- Reusable modules.
- Reduced configuration drift.
- Automated validation.
- Consistent promotion between environments.
- Better governance.

The choice between Terraform and CloudFormation depended on customer context.

Terraform was useful across cloud providers and for common reusable infrastructure patterns.

CloudFormation was useful where the customer wanted an AWS-native infrastructure workflow.

## Kubernetes and containers

The generated resume includes Kubernetes as a core platform technology.

The relevant managed services were:

- Amazon EKS.
- Google Kubernetes Engine.
- Azure Kubernetes Service.

Docker provided the container packaging model.

Kubernetes provided orchestration for containerized services where the workload justified it.

The decision to use Kubernetes needed to account for:

- Number of services.
- Scaling patterns.
- Deployment frequency.
- Availability needs.
- Operations maturity.
- Observability.
- Security.
- Platform-team capability.
- Cost of operating the platform.

For a small workload, Kubernetes could add more complexity than value.

That is an important consulting answer because the OpsGuru role is about customer value, not selling one technology.

## Data and machine learning platforms

The broader stack included:

- Data platforms.
- Machine-learning platforms.
- Apache Spark.
- S3.
- Kinesis.
- Relational databases.
- Elasticsearch.
- Python and Java services.

A clean architecture explanation is:

```text
event / application sources
          |
          +--------------------+
          |                    |
          v                    v
     streaming path        batch/data path
      (Kinesis)              (S3)
          |                    |
          v                    v
  event consumers       Spark/data processing
          \                    /
           \                  /
            v                v
           APIs / services / ML workloads
                     |
                     v
       relational data / Elasticsearch
```

This diagram is an interview-safe architecture synthesis from the stated stack. It is not meant to claim one exact Astrocytech customer implementation.

## Cost and TCO

The JD explicitly requires strong cost modelling and TCO explanation.

I would treat TCO as more than cloud-service price.

I would include:

- Compute.
- Storage.
- Network transfer.
- Managed-service charges.
- Licensing.
- Support.
- Operational staffing.
- On-call burden.
- Backup and disaster recovery.
- Security tooling.
- Engineering effort.
- Migration effort.
- Availability requirements.
- Expected growth.

I would then compare realistic options.

For example:

```text
Option A: self-managed infrastructure
Option B: self-managed services in cloud
Option C: managed cloud services
```

The cheapest hourly infrastructure is not automatically the lowest TCO.

A managed service can cost more per unit but reduce operational labour and failure risk.

## Budget and resourcing

The generated resume supports budget management and resource planning.

For a delivery plan, I would connect:

- Scope.
- Architecture.
- Required skills.
- Team size.
- Project phases.
- Dependencies.
- Risk.
- Cost.

The purpose is to create a plan that can actually be delivered, rather than an architecture that only works on paper.

## Pre-sales and Statements of Work

I worked with account executives and pre-sales architects on:

- Opportunity qualification.
- Technical discovery.
- Target architecture.
- Assumptions.
- Exclusions.
- Delivery approach.
- Effort estimation.
- Staffing.
- Cloud-cost forecasts.
- Statements of Work.

This is important because the Principal Architect role sits between technical delivery and commercial work.

The architecture has to be technically sound, but it also has to be scoped clearly enough that the delivery team and customer share the same expectations.

## Customer escalations

When an issue became an escalation, my job was to bring structure to it.

I would establish:

1. What happened.
2. What business impact exists.
3. What is known versus assumed.
4. What the immediate containment action is.
5. What technical root cause needs investigation.
6. Who owns each action.
7. What the customer should expect next.

The goal is to be calm, precise, and transparent.

## People management

The generated resume explicitly includes management of five architects and engineers.

That included:

- Weekly one-to-one meetings.
- Professional-development planning.
- Goal setting.
- Delivery coaching.
- Candid feedback.
- Performance-review input.
- Promotion recommendations.

The leadership style I would describe is high ownership without micromanagement.

I want people to understand the expected outcome, the constraints, and the quality bar, then have room to solve the problem.

## Executive communication

I presented architecture strategy, investment tradeoffs, cost models, delivery risks, and adoption roadmaps to audiences ranging from C-level and VP stakeholders to engineers.

The content changes by audience.

With an executive, I focus on:

- Business outcome.
- Cost.
- Risk.
- Timeline.
- Organizational impact.
- Decisions required.

With an engineer, I can go deeper into:

- Service boundaries.
- APIs.
- deployment.
- failure modes.
- infrastructure.
- observability.

## Interview version

> At Astrocytech, I worked as a Principal Software Architect across several customer accounts. My role covered the full technology-adoption cycle, from discovery and current-state assessment to target architecture, cost modelling, delivery oversight, and escalations. I worked across AWS, GCP, and Azure, with Terraform and CloudFormation for Infrastructure as Code and Kubernetes where container orchestration made sense. I also worked with data and machine-learning platforms, microservices, APIs, and distributed systems. A major part of the role was consulting: I worked with executives, engineers, engagement managers, account teams, and pre-sales. I modelled TCO, helped define Statements of Work and resourcing plans, and managed five architects and engineers. My focus was always to connect the technology decision to customer value, cost, risk, and delivery.

---

# 2. Ross Video — Lead Cloud Architect and Engagement Lead

## Core story

At Ross Video, I worked as a Lead Cloud Architect and Engagement Lead for media, communications, and digital-platform workloads.

This role is the strongest technical example of cloud-native delivery in the generated resume.

The main technology stack was:

- AWS.
- GCP.
- Amazon EKS.
- Google Kubernetes Engine.
- Terraform.
- Kubernetes.
- Docker.
- Amazon S3.
- Amazon Kinesis.
- Microservices.
- Event-driven architecture.
- Machine-learning platforms.
- Observability.
- CI/CD.

## Architecture pattern

A coherent way to explain the stack is:

```text
client / source systems
        |
        v
API / event ingestion
        |
        +--------------------------+
        |                          |
        v                          v
event stream                  object/data storage
Amazon Kinesis                    Amazon S3
        |                          |
        v                          v
event-driven                 data / ML workloads
microservices                      |
        \                          /
         \                        /
          v                      v
        containerized application services
                 |
                 v
       EKS or GKE + Kubernetes
                 |
                 v
        observability + CI/CD
```

This is a logical synthesis of the resume's stated technologies.

The important point is that the architecture had clear responsibilities:

- S3 for durable object/data storage.
- Kinesis for event-driven streaming on AWS.
- Kubernetes for orchestrating containerized services.
- EKS or GKE depending on the cloud environment.
- Docker for packaging.
- Terraform for repeatable infrastructure.
- CI/CD for controlled software delivery.
- Observability for understanding behaviour in production.

## AWS and GCP

The role included both AWS and GCP.

That does not mean every application had to run actively in both clouds.

The consulting question was whether a workload had a reason to use one provider, both providers, or to consolidate.

I would evaluate:

- Existing customer footprint.
- Data location.
- Managed services.
- Skills.
- Reliability.
- Security.
- Cost.
- Vendor constraints.
- Migration effort.
- Operational complexity.

If there was no business or technical reason for a multi-cloud design, adding a second cloud could simply increase cost and operational burden.

## Kubernetes

At Ross Video, Kubernetes was part of the cloud-native platform pattern.

Amazon EKS and Google Kubernetes Engine provided managed Kubernetes in their respective clouds.

The value was:

- Consistent container deployment.
- Independent scaling.
- Service isolation.
- Health checks and restart behaviour.
- Rolling deployment patterns.
- Better separation between application teams and infrastructure primitives.

But I would still evaluate whether the customer had enough scale and platform maturity to justify Kubernetes.

## Terraform

Terraform was used for repeatable cloud infrastructure.

I would use reusable modules and clear environment boundaries so that infrastructure changes could be reviewed and promoted in a controlled way.

Terraform also made cloud architecture more visible during project reviews because the infrastructure definition was versioned rather than hidden in manual console changes.

## CI/CD and GitOps thinking

The generated resume explicitly includes CI/CD and GitOps in the overall skill set.

The delivery principle was:

```text
code / infrastructure change
          |
          v
automated validation
          |
          v
build / package
          |
          v
controlled deployment
          |
          v
health / telemetry checks
          |
          v
promote or roll back
```

The exact tooling can vary by customer.

The architecture concern is repeatability, auditability, and safe promotion.

## Observability

Observability was a core part of the cloud-native design.

I would expect to cover:

- Metrics.
- Logs.
- Traces where appropriate.
- Service health.
- Infrastructure health.
- Deployment status.
- Error rates.
- Latency.
- Capacity.
- Business-relevant service indicators.

An architecture is not complete if the team cannot tell whether it is healthy after deployment.

## Machine-learning platforms

The Ross role also included machine-learning workloads.

The principal-level question was not only how to deploy a model.

It was how the ML workload connected to:

- Data ingestion.
- Storage.
- APIs.
- Compute.
- Scaling.
- Security.
- Observability.
- Cost.
- Release and rollback.
- Customer operations.

## Multiple projects

The generated resume says I managed multiple complex projects simultaneously.

That meant coordinating:

- Customer executives.
- Product leaders.
- Engineers.
- Security specialists.
- Data teams.
- Vendors.
- Internal delivery staff.

The key was to make dependencies and risks visible early.

I would keep a clear view of:

- Scope.
- Decisions.
- Owners.
- Dependencies.
- Risks.
- Budget.
- Timeline.
- Escalations.

## Project governance

I owned engagement-level architecture quality, delivery planning, technical risk, resource allocation, budget tracking, and escalation management.

The architecture role therefore continued after design.

I stayed involved to make sure the implementation still matched the agreed customer outcome.

## Pre-sales

I also supported pre-sales discovery and solution shaping.

I helped define:

- Target architecture.
- Delivery phases.
- Assumptions.
- Exclusions.
- Effort estimates.
- Staffing.
- Cloud-cost forecasts.
- Statement-of-Work content.

That is directly aligned to the OpsGuru JD.

## Executive presentations

I presented modernization options and tradeoffs to customer leadership.

Typical comparisons included:

- Cloud provider.
- Managed versus self-managed services.
- Migration approach.
- Operating cost.
- Organization impact.
- Delivery risk.
- Expected business outcome.

The purpose was to support a decision, not to show technical depth for its own sake.

## Mentoring

I mentored architects and engineers through:

- Design reviews.
- Architecture Decision Records.
- Customer communication.
- Consulting skills.
- Technical presentations.
- Delivery ownership.

## Interview version

> At Ross Video, I worked as a Lead Cloud Architect and Engagement Lead for media and digital-platform clients. I designed cloud-native architectures mainly across AWS and GCP using Kubernetes, EKS or GKE, Terraform, Docker, S3, Kinesis, microservices, event-driven patterns, observability, and CI/CD. I also managed several projects at the same time, so I was responsible for architecture quality, delivery planning, technical risk, resource allocation, budget tracking, and escalations. I supported pre-sales by defining target architectures, phases, assumptions, effort, staffing, cloud-cost forecasts, and Statement-of-Work content. I also presented modernization and cloud tradeoffs to executive stakeholders. This role is a good example of combining technical architecture with consulting and delivery ownership.

---

# 3. SalesChoice — Senior Cloud Solutions Architect

## Core story

At SalesChoice, I worked as a Senior Cloud Solutions Architect on cloud adoption and application modernization for enterprise and mid-market customers.

The role covered AWS, Azure, and GCP.

The main technology and architecture areas were:

- Microservices.
- Data processing.
- Machine learning.
- API integration.
- Identity.
- Networking.
- Security.
- Observability.
- Backup.
- Disaster recovery.
- Multi-environment deployment.
- Terraform.
- CloudFormation.
- Kubernetes.
- Docker.

## Cloud-adoption lifecycle

A typical engagement moved through:

```text
assessment
   |
   v
current-state architecture
   |
   v
business + technical constraints
   |
   v
target architecture
   |
   v
roadmap and migration sequence
   |
   v
implementation
   |
   v
operational handover
```

The target architecture had to work for both technology and operations.

That included security, recovery, deployment, ownership, and support.

## Brownfield modernization

A major part of this role was modernization.

I would avoid a "rewrite everything" approach unless there was a strong reason.

Instead, I would identify:

- Stable components that could stay.
- High-risk legacy components.
- Integration boundaries.
- APIs that could isolate old and new systems.
- Data dependencies.
- Migration sequencing.
- Operational constraints.

Microservices were one possible modernization pattern, but they had to be introduced deliberately.

## Reference architectures

I designed reference architectures covering:

- Microservices.
- Data processing.
- Machine learning.
- API integration.
- Identity.
- Networking.
- Security.
- Observability.
- Backup and disaster recovery.
- Multiple environments.

The value of a reference architecture was consistency.

It gave delivery teams a common starting point rather than letting every project solve the same platform problem differently.

## Terraform and CloudFormation

I created Infrastructure as Code foundations using Terraform and CloudFormation.

Important practices included:

- Reusable modules.
- Policy controls.
- Automated validation.
- Environment promotion.
- Deployment standards.

The main benefit was not only automation.

It was governance and repeatability.

## TCO comparison

This role is the strongest example for the JD's TCO requirement.

I compared:

```text
on-premises
vs.
self-managed cloud infrastructure
vs.
managed cloud services
```

The comparison included:

- Infrastructure cost.
- Licensing.
- Support.
- Staffing.
- Resilience.
- Backup and recovery.
- Operational effort.
- Growth assumptions.

This gave executive stakeholders a business view of the architecture decision.

## Managed services versus self-managed

A managed service can look more expensive if you only compare direct service price.

But it can lower TCO when it removes:

- Patching.
- Cluster administration.
- Backup work.
- Failover engineering.
- Monitoring setup.
- On-call burden.
- Specialist staffing.

The correct comparison is total operating cost and risk.

## Security and reliability

The reference architectures included security and reliability as design concerns from the beginning.

That included:

- Identity.
- Network boundaries.
- Data protection.
- Observability.
- Backup.
- Disaster recovery.
- Environment separation.

These were architecture requirements, not tasks added only before production.

## Multiple initiatives

I managed delivery across several customer initiatives at once.

I balanced:

- Roadmap priorities.
- Technical dependencies.
- Budgets.
- Resource constraints.
- Stakeholder expectations.
- Escalation paths.

This is a direct match to the original JD.

## Account growth

I supported account growth through:

- Architecture assessments.
- Roadmap workshops.
- Proposal development.
- Technical presentations.
- Solution estimates.
- Follow-on recommendations.

This is relevant to the JD's pre-sales and account-management expectations.

## Interview version

> At SalesChoice, I worked as a Senior Cloud Solutions Architect on cloud-adoption and application-modernization programs across AWS, Azure, and GCP. I designed reference architectures for microservices, data processing, machine learning, APIs, identity, networking, security, observability, backup, disaster recovery, and multi-environment deployment. I also created Infrastructure as Code foundations with Terraform and CloudFormation. A major part of the role was cost and capacity analysis. I compared on-premises, self-managed cloud, and managed-service options and explained the TCO assumptions to executive stakeholders. I managed several customer initiatives at the same time and supported account growth through architecture assessments, roadmaps, proposals, estimates, and technical presentations.

---

# Cross-role progression

```text
SalesChoice
Senior Cloud Solutions Architect
cloud adoption + modernization + reference architecture + TCO
        |
        v
Ross Video
Lead Cloud Architect and Engagement Lead
cloud-native delivery + project governance + pre-sales + executive advisory
        |
        v
Astrocytech
Principal Software Architect
multiple accounts + multi-cloud strategy + TCO + SOWs +
people management + executive and technical leadership
```

The progression is useful because it shows increasing responsibility across:

- Technical breadth.
- Customer advisory.
- Commercial delivery.
- Project oversight.
- Cost ownership.
- People leadership.

---

# Direct mapping to the original OpsGuru JD

| Original JD requirement | Evidence in the generated resume / role stories |
|---|---|
| Major cloud providers | AWS, GCP, Azure across the three roles |
| Big Data / Machine Learning | Data platforms, ML platforms, Spark, data pipelines |
| Cloud adoption | Astrocytech and SalesChoice |
| Microservices adoption | All three roles |
| Infrastructure as Code | Terraform and CloudFormation |
| Cost reductions | Cloud cost optimization and TCO work |
| 10+ years IT | Generated resume states 11+ years |
| 7+ years professional services/product management | Generated resume states 8+ years professional services |
| CxO / VP presentations | Astrocytech and Ross Video |
| Multiple complex projects | Ross Video and SalesChoice |
| Pre-sales | Astrocytech and Ross Video |
| TCO modelling | Astrocytech and SalesChoice |
| Budget and project costs | Astrocytech and Ross Video |
| Resourcing plans | Astrocytech |
| Customer escalations | Astrocytech and Ross Video |
| Technical-team leadership | All three roles |
| Possible management of ~5 people | Astrocytech explicitly manages five architects and engineers |
| 1:1s, development and goals | Astrocytech |
| Performance and promotion input | Astrocytech |

---

# Technology consistency rules

## Astrocytech

- AWS, GCP, and Azure are all valid parts of the consulting scope.
- Terraform and CloudFormation are both valid IaC technologies.
- Kubernetes is part of the platform stack, but do not imply every customer needed Kubernetes.
- TCO includes operating effort, licensing, resilience, staffing, and migration—not only cloud billing.
- Pre-sales, SOWs, account management, budgets, resourcing, and people management are part of the generated resume and should not be treated as side topics.

## Ross Video

- AWS and GCP are the primary clouds in this role.
- EKS and GKE are managed Kubernetes services.
- Docker packages services; Kubernetes orchestrates them.
- S3 is object/data storage.
- Kinesis supports event-driven streaming in AWS.
- Terraform provides repeatable infrastructure.
- Observability and CI/CD are first-class architecture concerns.
- The role includes project governance, budget tracking, escalations, pre-sales, and executive presentations.

## SalesChoice

- AWS, Azure, and GCP are all part of the role.
- Terraform and CloudFormation are used for Infrastructure as Code foundations.
- The architecture includes microservices, data, ML, APIs, identity, networking, security, observability, backup, and disaster recovery.
- This is the strongest TCO story: on-premises versus self-managed cloud versus managed services.
- The role includes multiple customer initiatives, budgets, resourcing constraints, proposals, estimates, and account growth.

---

# Overall answer: Why OpsGuru?

> My background fits the role because I have worked across the technical and consulting sides of cloud architecture. At SalesChoice, I focused on cloud adoption, modernization, reference architectures, Infrastructure as Code, and TCO. At Ross Video, I moved into lead architecture and engagement ownership, with AWS and GCP cloud-native platforms, Kubernetes, Terraform, event-driven systems, delivery governance, pre-sales, and executive communication. At Astrocytech, I worked at Principal Architect level across several accounts, covering AWS, GCP, and Azure, cloud and data strategy, cost models, Statements of Work, budgets, resourcing, escalations, and management of five architects and engineers. The common theme is that I connect technology decisions to business outcomes, cost, risk, and delivery.
