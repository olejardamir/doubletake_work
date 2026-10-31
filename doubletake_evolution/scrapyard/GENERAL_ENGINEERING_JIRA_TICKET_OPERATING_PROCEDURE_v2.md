# GENERAL ENGINEERING JIRA TICKET OPERATING PROCEDURE
## Shared Setup + Per-Ticket Workflow Using Human Judgment and Copilot

**Purpose:**  
Provide one practical, repeatable method for completing engineering Jira tickets from start to finish when the engineer has access to the working environment and can use Copilot as the only AI assistant.

This procedure is designed for infrastructure, cloud, data-platform, configuration, access, governance, migration, deployment, troubleshooting, dashboard, automation, and similar engineering tickets.

The procedure clearly separates four things:

1. **What is established once for the overall workstream or environment**
2. **What must be done separately for every ticket**
3. **What the engineer must do manually**
4. **What Copilot should be used for**

---

# 1. Operating Model

Do **not** treat every ticket as a completely independent investigation.

Instead, work in two layers:

```text
LAYER 1 — SHARED WORKSTREAM BASELINE
Established once and reused across related tickets.

        ↓

LAYER 2 — INDIVIDUAL TICKET LIFECYCLE
Repeated separately for every Jira ticket.
```

The shared baseline prevents repeated discovery.

The per-ticket lifecycle preserves:
- scope control,
- separate Definition of Done,
- separate evidence,
- separate validation,
- separate closure.

The rule is:

> **Share context, architecture, tooling, conventions, and reusable investigation knowledge.  
> Keep scope, decisions, implementation evidence, validation, and closure separate for each ticket.**

---

# 2. Roles

There are two operating roles.

## HUMAN ENGINEER — Authority and Operator

The engineer is responsible for facts and actions in the real environment.

The engineer must:
- access the systems,
- verify what actually exists,
- verify environment and scope,
- determine whether approvals are required,
- make implementation decisions,
- review generated commands,
- execute changes,
- observe results,
- decide when to stop,
- perform functional validation,
- decide whether the ticket is complete,
- post the Jira update.

The engineer is the final authority.

---

## COPILOT — Teacher, Analyst, Engineer Assistant, and Reviewer

Copilot should be used for:
- explaining unfamiliar technology,
- interpreting Jira tickets,
- structuring requirements,
- drafting Definition of Done,
- creating investigation plans,
- generating read-only commands,
- analyzing outputs,
- identifying assumptions,
- proposing implementation approaches,
- generating code or commands,
- reviewing plans,
- generating validation steps,
- generating rollback/recovery steps,
- diagnosing unexpected results,
- reviewing evidence,
- drafting Jira closure notes.

Copilot must **never be treated as the source of truth for the environment**.

The rule is:

> **Copilot proposes and reviews.  
> The engineer verifies and executes.**

---

# 3. What Is Done Once vs. What Is Done Per Ticket

## A. DO ONCE PER WORKSTREAM / ENVIRONMENT

These activities should normally be completed once and then reused across all related tickets.

Examples of a workstream:
- one Azure subscription/platform area,
- one data-platform migration,
- one Databricks environment,
- one access-management initiative,
- one sprint containing several related tickets,
- one shared platform team backlog.

### Establish once:

#### 1. Environment Map
Document:
- tenants,
- subscriptions,
- environments,
- regions,
- resource groups,
- workspaces,
- common naming conventions,
- relevant repositories,
- relevant deployment pipelines.

#### 2. System Architecture
Understand:
- major components,
- how they connect,
- identity/authentication model,
- permission layers,
- deployment model,
- data-flow relationships,
- shared dependencies.

#### 3. Source-of-Truth Model
Determine where different kinds of configuration normally live:
- Terraform,
- Bicep,
- ARM,
- scripts,
- repositories,
- pipelines,
- manual Azure configuration,
- Databricks configuration,
- another internal system.

#### 4. Organizational Rules
Record:
- what changes require approval,
- who owns which systems,
- whether production changes require a change window,
- whether PRs are required,
- whether another team must validate access,
- escalation contacts,
- expected Jira evidence.

#### 5. Common Tools and Access
Confirm:
- Azure Portal access,
- Cloud Shell access,
- CLI/PowerShell availability,
- Databricks access where applicable,
- repository access,
- read vs. write permissions.

#### 6. Reusable Investigation Commands
Build a small library of safe, read-only commands for common tasks.

Examples:
- current Azure context,
- resource discovery,
- identity lookup,
- role assignment lookup,
- configuration lookup,
- logs,
- deployment history.

#### 7. Common Risk Rules
Agree on what qualifies as:
- low risk,
- medium risk,
- high risk.

#### 8. Shared Copilot Context
Keep a reusable summary of:
- architecture,
- naming,
- environments,
- source-of-truth rules,
- deployment conventions,
- approval rules.

This can be reused in future Copilot conversations instead of rediscovering everything.

---

## B. DO SEPARATELY FOR EVERY TICKET

Every Jira ticket must still have its own:

1. Ticket understanding
2. Definition of Done
3. Risk classification
4. Scope confirmation
5. Current-state evidence
6. Ticket-specific unknowns
7. Desired state
8. Minimum required delta
9. Approval check
10. Implementation plan
11. Validation plan
12. Rollback/recovery plan
13. Execution record
14. Final-state evidence
15. Regression/side-effect check
16. Closure review
17. Jira closure note

Never combine these simply because several tickets look similar.

---

# 4. Shared Workstream Baseline Procedure — DO ONCE

This section is performed once before processing a group of related tickets.

---

## STEP S1 — Build the Environment Map

### HUMAN
Inspect the actual systems and record:
- environment names,
- subscriptions,
- relevant resources,
- workspaces,
- repositories,
- deployment systems,
- naming conventions.

### COPILOT
Use Copilot to turn your findings into a clean environment map.

Prompt:

```text
I am establishing a reusable engineering baseline for a group of related Jira tickets.

Here is the environment information I have confirmed.

Organize it into:

- environment hierarchy,
- systems/components,
- naming conventions,
- identity/access layers,
- deployment/configuration layers,
- dependencies,
- anything that appears unclear.

Do not invent missing information.
```

### OUTPUT
Create:

```text
WORKSTREAM ENVIRONMENT MAP
```

Reuse it for all related tickets.

---

## STEP S2 — Build the Architecture Model

### HUMAN
Confirm how the major systems relate in the real environment.

### COPILOT
Ask Copilot to explain the architecture from the confirmed information.

Prompt:

```text
Using only the confirmed environment information below, explain the technical architecture.

Show:
- components,
- relationships,
- control boundaries,
- identity/permission layers,
- configuration/deployment path,
- likely failure points.

Clearly mark anything that is an assumption.
```

### OUTPUT
Create:

```text
WORKSTREAM ARCHITECTURE SUMMARY
```

---

## STEP S3 — Establish the Source-of-Truth Rules

### HUMAN
Confirm where configuration is maintained.

Examples:

```text
Azure resources → Terraform
Databricks grants → SQL/Terraform
Manual support assignments → Azure Portal
Dashboard code → repository
```

### COPILOT
Help interpret existing repositories/scripts and identify possible drift risks.

### OUTPUT

```text
SOURCE OF TRUTH MATRIX

Configuration Type | Authoritative Location | Deployment Method | Manual Change Allowed?
```

This is reused for every ticket.

---

## STEP S4 — Establish Organizational Change Rules

### HUMAN
Determine:
- approval requirements,
- ownership boundaries,
- PR requirements,
- production rules,
- escalation path,
- expected evidence.

### COPILOT
Organize these into a reusable checklist.

### OUTPUT

```text
WORKSTREAM CHANGE RULES
```

---

## STEP S5 — Build the Reusable Read-Only Toolkit

### COPILOT
Generate safe read-only commands based on your environment.

### HUMAN
Review and test them.

Only keep commands you understand and have verified.

### OUTPUT

```text
READ-ONLY TOOLKIT
```

Examples:
- verify current Azure context,
- list resources,
- inspect configuration,
- inspect role assignments,
- inspect identities,
- inspect deployment history,
- inspect relevant logs.

---

## STEP S6 — Create the Shared Baseline Record

Maintain one reusable workstream document:

```text
WORKSTREAM:
ENVIRONMENTS:
ARCHITECTURE:
SOURCE OF TRUTH:
OWNERSHIP:
APPROVAL RULES:
DEPLOYMENT MODEL:
COMMON RISKS:
READ-ONLY TOOLKIT:
NAMING CONVENTIONS:
COMMON DEPENDENCIES:
```

This does **not** replace ticket-specific records.

It prevents repeating the same discovery work.

---

# 5. Per-Ticket Workspace — CREATE ONE FOR EVERY TICKET

Create this record separately for every Jira issue:

```text
TICKET:
TITLE:

ORIGINAL REQUEST:

DEFINITION OF DONE:

RISK:
LOW / MEDIUM / HIGH

SCOPE:

CONFIRMED FACTS:

ASSUMPTIONS:

UNRESOLVED QUESTIONS:

CURRENT STATE:

DESIRED STATE:

MINIMUM REQUIRED DELTA:

SOURCE OF TRUTH:

DEPENDENCIES:

APPROVALS REQUIRED:

IMPLEMENTATION PLAN:

VALIDATION PLAN:

ROLLBACK / RECOVERY PLAN:

STOP CONDITIONS:

EXECUTION NOTES:

FINAL STATE:

VALIDATION RESULTS:

REGRESSION / SIDE-EFFECT CHECK:

EVIDENCE:

JIRA CLOSURE SUMMARY:
```

---

# 6. Per-Ticket Stage 1 — Understand the Ticket

## HUMAN

Read:
- description,
- acceptance criteria,
- comments,
- attachments,
- linked issues,
- PR references,
- dependencies,
- environment references.

Compare the ticket to the shared workstream baseline.

Do not assume that the shared baseline automatically applies.

Verify that the ticket belongs to the same environment/workstream.

---

## COPILOT

Use:

```text
Read this Jira ticket as an implementation engineer.

Use the shared workstream context I provide, but do not assume it applies unless the ticket supports it.

Do not propose implementation yet.

Return:

1. Plain-language request.
2. Desired outcome.
3. Ticket-specific scope.
4. Systems involved.
5. Explicit requirements.
6. Assumptions.
7. Missing information.
8. Dependencies.
9. Risks.
10. Facts that must be verified in the environment.
```

---

## HUMAN DECISION

Confirm that you can explain:
- what is requested,
- where,
- why,
- expected result.

### GATE 1

**If the requested outcome is unclear, stop.**

---

# 7. Per-Ticket Stage 2 — Define Done

## COPILOT

Draft the Definition of Done.

Prompt:

```text
Draft an observable Definition of Done for this ticket.

Use the ticket and shared workstream context.

Include:
- final state,
- functional behavior,
- unchanged surrounding state,
- dependencies,
- approvals,
- evidence,
- closure blockers.

Do not invent requirements.
```

---

## HUMAN

Review and approve the Definition of Done.

### GATE 2

**No approved Definition of Done = no implementation.**

---

# 8. Per-Ticket Stage 3 — Classify Risk

## HUMAN

Classify the ticket:

### LOW
Read-only, documentation, simple isolated non-production work.

### MEDIUM
Configuration changes, access additions, shared-resource changes, non-production migration.

### HIGH
Production, permission removal, destructive change, security-sensitive work, broad-scope changes, data deletion, high blast radius.

---

## COPILOT

Ask:

```text
Given the ticket, classify the likely technical risk as LOW, MEDIUM, or HIGH.

Explain:
- blast radius,
- reversibility,
- security implications,
- production implications,
- validation requirements.

This is advisory only.
```

---

## HUMAN

Make the final risk decision.

---

# 9. Per-Ticket Stage 4 — Investigate Current State

Reuse the shared read-only toolkit where applicable.

Do not rediscover common architecture unless the ticket reveals something inconsistent.

---

## COPILOT

Ask for a ticket-specific investigation plan:

```text
Using:
- this Jira ticket,
- its Definition of Done,
- the shared workstream baseline,

create the minimum read-only investigation plan needed for this specific ticket.

For each check:
- question answered,
- why it matters,
- read-only command/query,
- interpretation of possible results.

Do not generate write operations.
Do not repeat shared-baseline checks unless the ticket requires re-verification.
```

---

## HUMAN

Execute the read-only checks.

Confirm real context:
- account,
- environment,
- resource,
- identity,
- scope,
- configuration.

Return relevant output to Copilot.

---

## COPILOT

Analyze:

```text
Analyze this evidence.

Return:

CONFIRMED FACTS
ASSUMPTIONS
UNRESOLVED QUESTIONS
RISKS

Do not propose implementation yet.
```

---

## HUMAN

Resolve all material unknowns.

### GATE 3

**Critical unknown remaining = do not design the change.**

---

# 10. Per-Ticket Stage 5 — Confirm Source of Truth

Use the shared source-of-truth matrix.

## HUMAN

Confirm that the ticket follows the expected pattern.

If the shared baseline says a resource is Terraform-managed, verify that this ticket is not an exception.

## COPILOT

Use Copilot to inspect relevant configuration or code if needed.

### GATE 4

**Source of truth uncertain = do not modify.**

---

# 11. Per-Ticket Stage 6 — Design the Change

## COPILOT

Prompt:

```text
Using only confirmed facts:

Describe:

CURRENT STATE
DESIRED STATE
MINIMUM REQUIRED DELTA
UNCHANGED SURROUNDING STATE
DEPENDENCIES
SIDE EFFECTS
DESTRUCTIVE STEPS
VALIDATION REQUIREMENTS

Do not generate commands yet.
```

---

## HUMAN

Review the design and confirm:
- scope,
- target,
- minimum delta,
- no unnecessary changes.

---

# 12. Per-Ticket Stage 7 — Check Authorization and Dependencies

## HUMAN

Confirm:
- you are allowed to perform the change,
- required approvals exist,
- dependent teams have completed prerequisites,
- change window is correct,
- PR/review requirements are satisfied.

## COPILOT

Can help create a checklist but cannot determine organizational authorization.

### GATE 5

**Missing authorization or dependency = do not execute.**

---

# 13. Per-Ticket Stage 8 — Build the Runbook

## COPILOT

Prompt:

```text
Create a ticket-specific implementation runbook.

Use only confirmed values.

Include:

1. Preconditions.
2. Read-only verification immediately before change.
3. Write operations.
4. Expected result after each step.
5. Validation after each meaningful step.
6. Explicit stop conditions.
7. Rollback/recovery.
8. Final validation.
9. Regression checks.

Clearly mark destructive actions.

Do not invent IDs, names, paths, scopes, or environments.
```

---

## HUMAN

Review every command or action.

You must understand:
- what it changes,
- where it changes it,
- why it is needed,
- expected result,
- recovery path.

### GATE 6

**If you cannot explain a command/action, do not execute it.**

---

# 14. Per-Ticket Stage 9 — Pre-Execution Review

## HUMAN

Verify:
- ticket,
- environment,
- account/subscription/project,
- resource,
- scope,
- identity,
- source of truth,
- approval,
- rollback,
- validation.

---

## COPILOT

For medium/high risk:

```text
Perform a final pre-execution review.

Look only for material problems:

- unsupported assumptions,
- wrong scope,
- unsafe sequencing,
- unconfirmed values,
- destructive steps,
- missing dependencies,
- missing validation,
- missing recovery,
- configuration drift risk.

Do not redesign unnecessarily.
```

---

## HUMAN

Resolve material issues.

---

# 15. Per-Ticket Stage 10 — Execute

## HUMAN ONLY

The engineer performs the actual write operation.

Execute incrementally.

For each meaningful step:

```text
Confirm context
→ Execute one logical change
→ Observe result
→ Compare with expected result
→ Validate
→ Continue only if correct
```

For bulk work:
- test one representative case first,
- validate,
- then continue.

---

# 16. Stop Conditions During Execution

Stop immediately if:

- actual environment differs from plan,
- scope is broader than expected,
- required object is missing,
- output differs materially from expected result,
- an unexpected dependency appears,
- a destructive action becomes necessary but was not planned,
- validation fails,
- authorization is uncertain,
- recovery is no longer possible,
- Copilot's explanation conflicts with observed behavior,
- you no longer understand the next action.

Do not allow Copilot to "push through" uncertainty.

---

# 17. Troubleshooting

## HUMAN

Stop changing the system.

Collect:
- action,
- command,
- result,
- error,
- actual state,
- expected state.

---

## COPILOT

Prompt:

```text
The observed result differs from the expected result.

Do not propose a fix yet.

Return:
1. Most likely causes.
2. Evidence supporting each cause.
3. Read-only tests that distinguish them.
4. Which assumptions may now be invalid.
```

---

## HUMAN

Run the read-only tests.

Once the cause is proven, return to:
- design,
- review,
- execution.

Never troubleshoot by stacking unverified changes.

---

# 18. Per-Ticket Stage 11 — Validate

Validation is separate from execution.

## HUMAN

Perform:

### A. Configuration Validation
Does the intended configuration exist?

### B. Functional Validation
Does the required behavior actually work?

### C. Regression / Side-Effect Validation
Did anything unintended change?

---

## COPILOT

Use:

```text
Here are:

1. Original Jira request.
2. Definition of Done.
3. Final observed state.
4. Validation evidence.

For each Definition of Done item classify:

PROVEN
NOT PROVEN
FAILED
NOT APPLICABLE

Do not infer success from the implementation plan.
Use only observed evidence.
```

---

## HUMAN

Review the result.

### GATE 7

**Material DoD item not proven = ticket remains open.**

---

# 19. Per-Ticket Stage 12 — Build Evidence

## COPILOT

Draft the evidence package from your actual execution notes.

Use:

```text
Create a concise evidence package from the confirmed execution record.

Include:

- original request,
- original state,
- implemented change,
- final state,
- validation performed,
- regression checks,
- approvals/dependencies,
- references.

Do not state anything that is not supported by the evidence.
```

---

## HUMAN

Verify every factual statement.

---

# 20. Per-Ticket Stage 13 — Close Jira

## COPILOT

Draft the closure note.

Suggested format:

```text
Implemented:
<what changed>

Scope:
<where>

Validation:
<what was verified>

Result:
<final state>

References:
<PR/change/deployment/evidence>
```

---

## HUMAN

Review and post.

The human decides whether the ticket is complete.

---

# 21. Working on Multiple Related Tickets

When several tickets belong to the same initiative:

## SHARE ONCE
- architecture understanding,
- environment map,
- naming conventions,
- source-of-truth rules,
- common access model,
- common deployment process,
- reusable commands,
- common risk rules,
- common organizational procedures.

## KEEP SEPARATE
- Definition of Done,
- ticket scope,
- current-state evidence,
- unresolved questions,
- desired state,
- exact change,
- approvals,
- execution record,
- final validation,
- evidence,
- closure.

---

# 22. When Related Tickets May Be Investigated Together

It is reasonable to combine investigation when tickets share:
- same environment,
- same resource family,
- same migration,
- same identity convention,
- same repository,
- same deployment.

Example:

```text
SHARED INVESTIGATION
    ↓
Ticket A-specific findings
Ticket B-specific findings
Ticket C-specific findings
```

Do not duplicate identical read-only discovery unnecessarily.

But record which findings apply to which ticket.

---

# 23. When Related Tickets May Be Executed Together

Tickets may be executed as one coordinated change only when:

- the same approved change naturally satisfies multiple tickets,
- scopes are understood,
- separate Definitions of Done remain traceable,
- evidence can still be separated,
- failure handling is clear,
- approvals permit it.

Even when implementation is shared:

```text
ONE IMPLEMENTATION EVENT
        ↓
Ticket A validation
Ticket B validation
Ticket C validation
        ↓
Separate closure decisions
```

Never close several tickets merely because one shared deployment succeeded.

---

# 24. What Must Be Re-Verified Every Time

Even if established once, re-check these before every meaningful write:

- current environment,
- current account/subscription/project,
- target resource,
- exact scope,
- target identity/object,
- ticket-specific source of truth,
- approvals,
- expected operation.

Shared context reduces discovery.

It does **not** remove the need for pre-change verification.

---

# 25. Compact Human vs. Copilot Matrix

| Activity | Once / Per Ticket | Copilot | Human |
|---|---|---:|---:|
| Environment map | Once | Organize | **Discover/verify** |
| Architecture understanding | Once | Explain | **Verify** |
| Source-of-truth model | Once | Analyze | **Confirm** |
| Organizational rules | Once | Organize | **Confirm** |
| Reusable read-only toolkit | Once | Generate | **Review/test** |
| Ticket interpretation | Per ticket | **Draft/analyze** | Verify |
| Definition of Done | Per ticket | **Draft** | **Approve** |
| Risk classification | Per ticket | Advise | **Decide** |
| Current-state investigation | Per ticket | Plan/analyze | **Execute** |
| Facts/assumptions/unknowns | Per ticket | **Analyze** | Resolve |
| Source-of-truth confirmation | Per ticket | Assist | **Confirm** |
| Change design | Per ticket | **Propose** | **Approve** |
| Authorization | Per ticket | Checklist only | **Confirm** |
| Runbook | Per ticket | **Draft** | Review |
| Commands/code | Per ticket | **Generate** | **Review** |
| Write operations | Per ticket | No | **Execute** |
| Troubleshooting | Per ticket | **Analyze** | Test |
| Functional validation | Per ticket | Design checks | **Execute** |
| Closure review | Per ticket | **Evaluate evidence** | **Decide** |
| Jira note | Per ticket | **Draft** | **Post** |

---

# 26. Compact End-to-End Workflow

```text
ONCE PER WORKSTREAM
───────────────────
Build environment map
        ↓
Understand architecture
        ↓
Establish source-of-truth rules
        ↓
Establish organizational rules
        ↓
Build reusable read-only toolkit
        ↓
Create shared baseline


FOR EACH TICKET
───────────────
Read ticket
        ↓
Define Done
        ↓
Classify risk
        ↓
Run ticket-specific read-only investigation
        ↓
Confirm facts / resolve unknowns
        ↓
Confirm source of truth
        ↓
Design minimum change
        ↓
Confirm authorization
        ↓
Build runbook
        ↓
Copilot review
        ↓
Human pre-change verification
        ↓
Human execution
        ↓
Validate configuration
        ↓
Validate function
        ↓
Check side effects
        ↓
Compare final state to DoD
        ↓
Build evidence
        ↓
Close Jira
```

---

# 27. Non-Negotiable Rules

1. **Shared context is reusable; ticket completion is not.**
2. **Every ticket gets its own Definition of Done.**
3. **Every ticket gets its own evidence and closure decision.**
4. **Copilot never establishes environment facts by itself.**
5. **The engineer executes all write operations.**
6. **Never execute code you cannot explain.**
7. **Never act on an unverified environment or scope.**
8. **Never continue after a meaningful unexpected result.**
9. **Never treat command success as functional success.**
10. **Never close a ticket with a material DoD item unproven.**
11. **Never bypass approvals because a change looks technically simple.**
12. **Always compare the observed final state to the original Jira request, not merely to the implementation plan.**

---

# 28. Definition of a Successful Process

The process is successful when:

- common knowledge was established once rather than rediscovered repeatedly,
- each ticket retained clear independent scope,
- Copilot was used heavily for analysis, explanation, planning, review, and documentation,
- the engineer remained responsible for facts and execution,
- changes were performed from verified information,
- unexpected results triggered investigation rather than improvisation,
- validation proved the requested result,
- evidence was sufficient for another engineer to understand what happened,
- and each Jira ticket was closed only when its own Definition of Done was demonstrated.

That is the standard operating model.
