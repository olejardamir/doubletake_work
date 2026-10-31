# Azure Databricks — hands-on-only ticket labs (one sandbox)

**Version:** 5.0 · 6 October 2026 · hands-on-only revision  
**Format:** **one** persistent sandbox; 1 once-only bootstrap ticket (`S00`) + **38 separately verifiable, self-seeding hands-on tickets** (`F01`–`C01`) with runnable implementation playbooks  
**Objective:** Complete real, observable Databricks exercises in **Volumes, Tables, Jobs, Policies, DevOps, and Infrastructure/scripts/configuration**. No assigned reading, no essays, no theory quizzes. Each lab is a ticket with implementation and tests.

> **Critical operating decision: ONE PERSISTENT SANDBOX FOR THE ENTIRE PROGRAM.** You provision/select ONE Azure Databricks development workspace, ONE primary Unity Catalog catalog, ONE primary schema, ONE shared input volume, ONE learning repository, and ONE consistent naming convention. You do **not** create another sandbox for each ticket. The tickets are *standalone work items* within this shared environment: each describes its own fixture, actions, tests, outputs and Definition of Done. Where suitable, create ticket-prefixed tables/files/jobs inside the same schema. A failed or skipped ticket must not block another ticket. “Standalone ticket” means standalone *acceptance and fixtures*, not a separate workspace, catalog, repo or new sandbox.

## Immediately start here

1. Open **S00** below and build/verify the one shared sandbox. Only do this once.
2. Choose any ticket (recommended first: **V01** or **T01**) and open its **Hands-on execution playbook**.
3. Copy the ticket fixture into SQL/Notebook/CLI; replace only approved non-secret identifiers; run.
4. Compare output with the exact values in **Pass/Prove**; execute the ticket's safe negative test and repair.
5. Save run links/results and mark `DONE` **only when the actual checks pass**. Reuse the **same workspace/catalog/schema/volume** for the next ticket.

**Required reading outside this file: NONE. Required writing: only minimal results/evidence.**

## 1. Start working — no reading prerequisites

**Work-first rule:** Start with `S00` and then execute tickets. There are **zero required book chapters, reading assignments, written concept definitions, or theory questions**. Learn terminology through the actions and the result/error messages. A ticket passes when you **create or inspect real objects, run a reproducible test, verify an exact result, exercise a safe failure/recovery, and save minimal execution evidence**. Do not confuse merely pasting code or preparing a design with completing a hands-on task.

**What you do for every ticket:** (1) set up its own tiny synthetic fixture, (2) execute the commands or UI actions, (3) compare actual to expected, (4) intentionally exercise one contained failure, (5) fix or safely recover, and (6) record the result and stop unnecessary resources. **No reading before doing.** Documentation is an optional lookup when an API/UI behavior differs or an error must be diagnosed.

**Scope:** These are standalone, original lab exercises designed for Azure Databricks. Commands, permissions, UI features and pricing can vary by workspace; check the current Azure Databricks documentation *only when troubleshooting a concrete issue*. Tests must run in your own authorized workspace.

### 1.1 Shared sandbox contract (do ONCE, not per ticket)

| Shared resource | Preferred name / policy | Lifetime |
|---|---|---|
| Workspace | Your one authorized, non-production Azure Databricks workspace | Whole program |
| Unity Catalog catalog | `C` = a catalog you own or are permitted to use | Whole program |
| Unity Catalog schema | `S` = `dbx_learning` **inside C**, subject to permitted naming | Whole program |
| Shared managed volume | `V` = `lab_files` in `C.S` | Whole program; never delete during a ticket |
| Shared repository | `databricks-learning-lab` (private) | Whole program |
| Working environment | One default SQL warehouse or allowed general-purpose compute, plus job compute when required | Reuse; stop idle compute |
| Workspace code area | One own-user Git folder/workspace directory for all notebooks and scripts | Whole program |
| Optional Azure resources | One dedicated learning resource group `RG`, ADLS container/prefix, IAM test principal (only when authorized) | Whole program, with labeled ownership |

**Names:** Replace placeholders `C`, `S`, `V`, `RG`, and `<...>` before executing. They are documentation placeholders, not literal Databricks variables. For examples, assume `C=dbx_lab_catalog`, `S=dbx_learning`, `V=lab_files`. Never assume you can create a catalog: if the account administrator assigns an existing catalog, use that without changing its governance. Object names use a *ticket prefix* (`v01_products`, `t01_sales`, `j02_parameterized`, `p01_secure_orders`, etc.). Files use `/Volumes/C/S/V/<TICKET-ID>/...`; do not create a new volume just to store each dataset.

**Ticket isolation:** A ticket may read the once-created shared reference fixture, but **must be able to generate or regenerate its own ticket-scoped data** and must not require any output of another ticket. Restarting a ticket must not replace another ticket's table, job, pipeline or folder. A ticket may refer to a *hypothetical* architecture created in earlier learning exercises, but implementation steps and validation must still work without it. For advanced features that inherently require extra permission, label the ticket `ADMIN / CONDITIONAL`; never impersonate admins or bypass permissions.

**Keep** the one catalog, one schema, the shared volume, the private repo, the central reference fixtures, and reusable settings after each ticket. **Clean up** only the ticket's temporary namespaced resources and recurring scheduled runs. For high-value examples it is fine to retain clearly labeled completed objects, provided resource and ongoing-cost inventories stay accurate.

### 1.2 Cost and security guardrails

- Only use your own or explicitly authorized Azure subscription/workspace; never use an employer's production environment for training.
- Use synthetic data only. Never commit tokens, passwords, connection strings, secrets, real identifiers or private endpoints to Git or AI prompts; redact screenshots and execution logs.
- Set Azure budget/alerts and compute auto-termination; prefer existing allowed compute; stop idle SQL warehouses, pipelines and job schedules. A 24/7 job is **never** part of this course.
- Do not delete existing metastores, access connectors, shared external locations, storage credentials, Azure identities, policies or production resources. For P01/V03 only, narrowly scoped, approved and reversible test-principal USE grants on the existing shared catalog/schema may be necessary; log preexisting grants, add only approved grants, and remove only those newly created by the ticket. Any administrative changes must have a scope and documented rollback.
- External storage, second-person security tests, compute policy creation, Terraform Azure resources, deployment credentials and Azure DevOps pipeline identities are **conditional** on authorization and eligibility. An unperformed admin exercise is `BLOCKED`, **not** `DONE`.
- Do not assume older screenshots/UI terminology are current. For example, the names and configuration controls for Lakeflow Jobs, Lakeflow Spark Declarative Pipelines, and Declarative Automation Bundles (formerly Databricks Asset Bundles) may differ by workspace or tool release.

### 1.3 Once-only repository structure

```text
databricks-learning-lab/
├── README.md                 # sandbox architecture, permissions, cost limits
├── config/
│   ├── sandbox.example.env   # names only; no secrets, no live token
│   └── resources.md          # inventory, IDs redacted when shared
├── fixtures/
│   ├── create_reference_data.sql
│   └── data_dictionary.md
├── tickets/
│   ├── F01/ ...             # one directory per ticket, same sandbox
│   ├── V01/ ...
│   └── C01/ ...
├── src/                      # reusable notebooks, Python packages, SQL
├── bundles/                  # bundles can be ticket-specific subfolders
├── infra/                    # reviewed Terraform, never silent apply
├── tests/                    # SQL assertions, Python tests, bundle checks
└── evidence/                 # sanitized, private; one folder per ticket
```

Use a single work-item template for every ticket (paste into `tickets/<ID>/README.md`):

```markdown
# <ID> — <ticket title>
Status: NOT STARTED | IN PROGRESS | BLOCKED | FAILED VALIDATION | DONE
Date / owner / time: ...
Object or behavior to create/test: ...
Prerequisite permission check: ...
Objects used/created (C.S names and paths): ...
Steps actually executed (SQL, Python, CLI, UI): ...
Expected vs. actual outcome (include deterministic values): ...
Negative/failure test + why it failed: ...
Security, cost and operational review: ...
Evidence paths / run links / commit IDs (sanitized): ...
Cleanup/retention decisions: ...
Definition of Done: PASSED / NOT PASSED, with evidence
```

**Common Definition of Done, applies to all 38:** prerequisites/access confirmed; ticket fixtures reproducible; intended run executed in the single sandbox; each expected assertion shown; safe negative/failure case demonstrated or reason for safe exclusion documented; evidence saved; cleanup/retention and future charges checked; no cross-ticket object modified. No written answer or screenshot substitutes for actual successful execution. Establish `S00` once as the persistent baseline; rerun each ticket safely by reseeding **only its own** fixture, not the whole sandbox.

### 1.4 Practical work map — pick a ticket and execute it

| Work area | Tickets | What you will actually do |
|---|---|---|
| Shared setup | S00 | Reuse one authorized workspace; create one schema, one shared volume and starter data |
| Workspace and execution | F01–F04 | Inspect your real workspace, check permissions, run Spark plans, test a 3-stage transformation |
| Volumes/storage | V01–V04 | Create CSV files, connect external storage where authorized, test access, load Delta |
| Delta tables | T01–T07 | CRUD, invalid schema tests, replay-safe MERGE, RESTORE, CDF, plans, quality assertions |
| Jobs | J01–J06 | Run scheduled/manual jobs, parameters, DAGs, file triggers, failure repair, safe replays |
| Policies/security | P01–P06 | Test permissions, masking, compute policies, run-as, lineage, inventory |
| DevOps | D01–D06 | Git commits, Databricks CLI, bundle validation/deploy, CI tests, simulated promotion |
| Infrastructure/config | I01–I04 | Inspect compute, plan authorized Terraform, run a declarative pipeline, monitor cost |
| Capstone | C01 | Run and validate a complete mock order-processing system |

**Execution instructions are inside each ticket, under “Hands-on execution playbook.”** You do not need to read anything else first.

## 1.5 Ticket execution workflow (repeat for each ticket; never rebuild the sandbox)

1. **Open your sandbox:** select the existing workspace and permitted compute. Open the ticket playbook, note its own object/file prefix, and execute its first seed/setup action. Do not read a book chapter or write theoretical definitions.
2. **Scope**: record `C`, `S`, `lab_files`, compute type, ticket prefix, object inventory, expected budget effect and effective privileges. Use one consistent repo. Check for collisions before creating/deleting anything.
3. **Prepare executable steps without secrets**: Copilot/another LLM may help draft or debug safe SQL/Python/YAML/Terraform and validation commands if useful. **You**, not the assistant, inspect generated code and run the actions in the authorized sandbox. Never put live tokens, identifiers, restricted files or employee data into prompts.
4. **Execute** in this sequence: self-seed fixture → verify initial state → implement → capture observed counts/schemas/run IDs → run a controlled failing case → fix/retry → verify final invariants.
5. **Prove**: attach commands/config files plus result evidence to `tickets/<ID>/` and `evidence/<ID>/`. Distinguish expected results, observed results and inferences; capture version/feature differences and the actual execution identity.
6. **Close**: stop/disable owned recurring triggers, log any continuing DBU/cloud cost, decide whether to keep ticket-scoped objects for review, and complete the common rubric. Do not delete bootstrap objects or resources outside your ticket prefix.

**Responsibility boundary:** AI can help draft executable code, interpret failures, suggest fixes, and construct validation tests. You choose compute and permissions, enter the workspace, execute/run, inspect outputs, approve any changes, and certify the ticket. No LLM-only solution is a pass.

### Status vocabulary

| State | Exact meaning |
|---|---|
| `NOT STARTED` | No environment action yet |
| `IN PROGRESS` | Begun but acceptance checks still outstanding |
| `FAILED VALIDATION` | Attempted with observed behavior contrary to required result |
| `BLOCKED` | Essential permission, product feature, budget or external approval missing; no claim of completion |
| `PARTIAL` | Useful work and evidence obtained, but a mandatory hands-on component remains blocked |
| `DONE` | All essential validations executed, passed and recorded in the one sandbox |

`S00` is once-only. Other tickets have no *runtime* dependency on previous ticket outputs, but the schedule below gives a recommended *learning* sequence. “Admin conditional” means **separate permissions or resource types within the same single sandbox**, not a second sandbox.

### Practical safety distinctions during execution

- Do not replace a Unity Catalog Volume exercise with writing a workspace notebook file.
- Do not treat a CSV in a Volume as a managed Delta table; check using `DESCRIBE DETAIL` / Catalog Explorer where authorized.
- Do not use a Unity Catalog grant to test compute-limit policies: those are different permission controls.
- Do not claim `databricks bundle validate` proves data correctness: run the ticket's data assertions too.
- Do not interpret file-arrival triggers as “one guaranteed job run per input file”: verify output idempotency by actual row counts.
- Do not run Terraform `apply` or change grants/policies unless the resource and permission are explicitly approved.

---

## 2. S00 — ONCE ONLY: establish the shared Databricks laboratory

**Type:** One-time shared bootstrap, **not an additional sandbox**. **Time:** 60–150 minutes plus any permission/administrator wait. **Access:** Allowed workspace user; `CREATE SCHEMA` and `CREATE VOLUME` in an approved catalog, or administrator-provided equivalents.

**Hands-on kickoff:** Open Catalog Explorer, select the assigned catalog, inspect schema privileges, confirm available compute, then execute the SQL below. Save the actual catalog, schema, volume path, query results, and resource IDs (non-secret) in `config/resources.md`. No preliminary theory or written definitions.

**Steps:**

1. In one authorized dev workspace, inspect and record region, edition, identity, Unity Catalog attachment, permitted catalog(s), usable SQL warehouse/compute and your effective privileges. **Do not create an extra workspace if a suitable dev workspace already exists.**
2. Select one catalog `C` and establish **one schema `C.S`**. If you cannot create the schema, request one owned/approved schema and record its existing grants rather than escalating privileges on your own.
3. Create **one shared managed volume** `C.S.lab_files` if authorized. If volume creation is denied, record the missing privilege and leave volume-required tickets `BLOCKED` until enabled; SQL-only tickets can still proceed. If account-wide Unity Catalog is not enabled, record the limitation; do not replace a managed volume with a legacy DBFS mount and claim the exercise is equivalent.
4. Create your one private repository and shared Databricks Git/workspace folder. Record your compute budget, SQL warehouse auto-stop or cluster auto-termination, and ownership map. Test notebook/SQL access.
5. Generate synthetic fixture files and a small shared reference table **once**; leave them in place for the entire program. Ticket-specific variations must be seeded inside each ticket's own prefix.

**Optional executable SQL (run only after replacing names):**

```sql
-- The admin may instead supply your C.S; never create outside approved scope.
CREATE SCHEMA IF NOT EXISTS C.dbx_learning;
CREATE VOLUME IF NOT EXISTS C.dbx_learning.lab_files;
CREATE TABLE IF NOT EXISTS C.dbx_learning.reference_products (
  product_id STRING, category STRING, unit_price DECIMAL(10,2)
) USING DELTA;
-- Idempotently seed only the five expected keys; never replace the whole table.
MERGE INTO C.dbx_learning.reference_products AS t
USING (SELECT * FROM VALUES
  ('p01','books',10.00), ('p02','books',20.00),
  ('p03','hardware',30.00), ('p04','hardware',40.00),
  ('p05','office',50.00)
  AS v(product_id,category,unit_price)) AS s
ON t.product_id=s.product_id
WHEN MATCHED THEN UPDATE SET t.category=s.category, t.unit_price=s.unit_price
WHEN NOT MATCHED THEN INSERT (product_id,category,unit_price)
  VALUES (s.product_id,s.category,s.unit_price);
SELECT COUNT(*) AS n, SUM(unit_price) AS total_price
FROM C.dbx_learning.reference_products;
```

**Expected:** 5 products, total price **150.00**. `C.S.lab_files` resolves to a valid volume path at `/Volumes/C/S/lab_files/`. If rerunning bootstrap, **do not destroy someone else's data**; check ownership/contents first. The `MERGE` does not duplicate those five keys when re-run. If the reference table already contains extra or duplicated keys, the row-count assertion will fail: inspect and reconcile **only the table that you own**, not arbitrary pre-existing data. Do not run `CREATE OR REPLACE` on shared resources.

**Boundary test:** Without changing grants, inspect which of `CREATE SCHEMA`, `CREATE VOLUME`, `CREATE TABLE`, Workflows job creation, compute-policy management, and Unity Catalog privilege management you can actually perform or are explicitly assigned; mark anything unverified as `UNKNOWN`, not `ALLOWED`. **Evidence:** screenshot or SQL output for catalog/schema/volume/table, reference count/sum, private repository tree, sanitized permission matrix, budget/compute setting and initial object inventory. **Done when:** one shared sandbox works and its costs and ownership are understood. **Do not drop C, S, V, or reference_products after individual tickets.**

### Working conventions for the tickets below

Every ticket is *executed in C.S*. For brevity, an object such as `t01_sales` means **`C.S.t01_sales`**, and a path such as `V01/products.csv` means **`/Volumes/C/S/lab_files/V01/products.csv`**. For notebooks, choose and record `C` and `S` in a private non-secret config cell or checked-in sample configuration; substitute their real values in executable code. A ticket may create its own additional volume, external location or IAM test resource only when the *topic itself* is creation/isolation of that object; such resource remains **inside the same workspace** and is named for that ticket.

**Independent reset pattern:** Inspect the inventory, then (when authorized) drop/recreate **only `C.S.<ticket-prefix>_*` resources**, remove only `/Volumes/C/S/lab_files/<TICKET-ID>/`, and stop/delete only `<ticket-prefix>` jobs, schedules and pipelines. Never run `DROP SCHEMA`, `DROP CATALOG`, or `DROP VOLUME lab_files` inside a ticket.

---

### Universal execution reference — use for every ticket

These playbooks expand, rather than replace, the 38 ticket contracts above. The **ticket acceptance criteria remain mandatory**. Work through the ticket specification, then its execution playbook. A task is `DONE` only after its actual Databricks output satisfies both. Each playbook has a seed, an execution path, a check, a failure probe and evidence. All cloud instructions require approved permissions and have no elevated-access shortcut.

#### Universal notebook preflight (copy to every Python lab notebook)

Change **only** the three non-secret identifiers after `S00`. This cell is repeated deliberately: standalone tickets must not rely on another lab notebook's session state. Use a compatible Azure Databricks Python notebook running on permitted compute with Unity Catalog volume access. SQL editors instead run `USE CATALOG <actual_catalog>; USE SCHEMA <actual_schema>;` at the **beginning of every SQL session**.

```python
# Copy this cell to each independently runnable notebook.
CATALOG = "dbx_lab_catalog"    # REPLACE with catalog assigned in S00
SCHEMA = "dbx_learning"       # REPLACE if S00 selected another schema
VOLUME = "lab_files"          # the one shared volume from S00
assert all(v.isidentifier() for v in (CATALOG, SCHEMA, VOLUME)), "Use simple approved identifiers"
NS = f"{CATALOG}.{SCHEMA}"
VOL = f"/Volumes/{CATALOG}/{SCHEMA}/{VOLUME}"
print("Lab scope:", NS, VOL)
```

**Safe preflight, before each ticket:** (1) confirm the target is the non-production workspace, (2) check the repo branch, (3) check owner and ticket prefix for any existing object, (4) select an approved compute policy/warehouse, (5) record current resource inventory, (6) do not paste any authentication credentials into code/LLM/chat, (7) record timestamp, run ID and observed results. Ticket fixtures are **deterministic** but job run IDs and Delta commit versions are **not**: capture them dynamically.

**SQL context snippet** (replace angle-bracket placeholders; execute separately from other code):

```sql
USE CATALOG dbx_lab_catalog;
USE SCHEMA dbx_learning;
-- Verify effective namespace in the SQL editor UI / session properties.
```

**Minimal execution record for every ticket** (`tickets/<ID>/results.md`): actual command/UI action; ticket-owned object; expected result; observed result; run link/UTC time; negative test and fix; permission/cost outcome; cleanup or retention. Where a result cannot be verified, write `NOT VERIFIED` and leave ticket `BLOCKED` or `PARTIAL` rather than predicting success. Screenshots must be redacted. Ticket setup and teardown must never mutate `reference_products`, the shared `lab_files` volume, or another ticket's objects.

**SQL assertions:** For counts and invariants below, an executable test is a query returning the expected number **plus** a comparison to the expected number (or `assert_true` where supported); attach the real result. SQL snippets are single-session when using temp views. A Python notebook can use `assert` for stricter stop-on-failure behavior. Duplicate execution of `CREATE OR REPLACE TABLE` **is permitted only on an explicitly ticket-owned table after checking ownership**; never run it on S00/shared objects.

---

# Track A — Workspace navigation and Spark execution (4 tickets)

## F01 — Map the real sandbox architecture and trust boundaries
- **Access/time:** Workspace/UI inspection and own F01 notebook/Volume file writes, 45–60 min.
- **Fixture & steps:** Use existing sandbox. In UI locate Catalog, Compute, Workflows/Jobs, SQL, Workspace and identity context. Locate Workspace, Compute, Jobs, Catalog and Volumes in the UI; verify a real object at each available location and record paths/identifiers.
- **Prove:** actual UI screenshots/metadata or queries for at least 10 available components and their permissions; demonstrate one notebook stored in Workspace and one file stored in Volumes are different objects. A diagram is optional, not a required writing exercise.
- **Hands-on check:** Open Workspace and Catalog Explorer. Record a workspace notebook path and a Volume file path; verify they are distinct objects. Capture three actual permission/configuration observations. **Cleanup:** None.


### Hands-on execution playbook for F01

1. Sign in to the **one** workspace. In the UI, locate your workspace identifier/region, Catalog Explorer (catalog, schema, volume and table), SQL warehouses, Compute, Jobs & Pipelines, Git folder and signed-in identity. Record `FOUND`, `NOT ENABLED` or `NO ACCESS` for each rather than inferring privileges.
2. Open only the `S00.reference_products` table and `lab_files` volume; obtain table location/storage metadata when allowed using `DESCRIBE DETAIL <C>.<S>.reference_products`, and compare it to `/Volumes/<C>/<S>/lab_files/` without interpreting a workspace directory as storage.
3. In the workspace UI and permitted metadata, capture three real enforcement surfaces: the signed-in identity, one catalog/table privilege and one compute/job permission or configuration. Save the observed screens/outputs; do not infer unseen permissions.
4. Create `tickets/F01/component_inventory.csv` with columns `component,ui_or_sql_path,observed_status,observed_permission_or_setting,evidence`, at least **10 rows**. If allowed, stop an owned idle SQL warehouse or compute and verify the existing reference table is still listed in Catalog Explorer; never stop shared compute or delete jobs.
5. **Mismatch test:** create a Databricks notebook named `f01_workspace_probe` inside your shared personal learning workspace directory. In that notebook, include the standard preflight cell and run:

```python
path = f"{VOL}/F01/f01_volume_probe.txt"
dbutils.fs.mkdirs(f"{VOL}/F01")
dbutils.fs.put(path, "F01 ticket-owned volume file\n", overwrite=True)
assert dbutils.fs.head(path).strip() == "F01 ticket-owned volume file"
print("Stored Volume file:", path)
```

6. In Workspace, verify `f01_workspace_probe` is a notebook object; in Catalog Explorer → Volumes, verify `F01/f01_volume_probe.txt` is a file object. Save the two distinct paths and successful read-back. No destructive actions; leave the shared Volume untouched except the F01 subdirectory.

**Pass:** 10 observed components, three observed permission/configuration surfaces, a created notebook, and a Volume file that is written and read back. **Evidence:** inventory CSV and actual UI/notebook output. **Access:** own notebook and F01 file creation; any item you cannot inspect is flagged unknown, not fabricated.

## F02 — Audit effective privileges, ownership and service limits
- **Access/time:** Read-only, 45–75 min.
- **Fixture & steps:** Inventory permissions for C, S, V, reference table, job creation, pipeline creation, SQL warehouse, Git folder and CLI/API; note grants vs inferred rights. Separate Azure role from UC privileges and record who can approve missing access.
- **Prove:** `access_matrix.md` with at least 12 operations, required permission, actual result and approver; at least three rights verifications. Safe negative: document a genuinely unsupported/denied operation without modifying permissions.
- **Hands-on check:** Execute `SHOW GRANTS` on allowed lab objects and a `SELECT COUNT(*)` from the reference table. Capture one observed permitted and one denied/unavailable action without modifying existing grants. **Cleanup:** None.


### Hands-on execution playbook for F02

1. Build `tickets/F02/access_matrix.csv` with the fields `action,object,required_layer,expected_permission,verification_method,observed_result,approver`.
2. Enter **at least 12** rows: use catalog, use schema, select reference table, create table, create volume, read volume, write volume, create job, run job, create pipeline, use compute, configure compute policy, and optionally create external location. Distinguish *Unity Catalog* grants, *workspace entitlements*, *compute permissions*, and *Azure RBAC*.
3. Query (if authorized) and capture actual table/schema/volume privileges:

```sql
SHOW GRANTS ON CATALOG dbx_lab_catalog;
SHOW GRANTS ON SCHEMA dbx_lab_catalog.dbx_learning;
SHOW GRANTS ON VOLUME dbx_lab_catalog.dbx_learning.lab_files;
SHOW GRANTS ON TABLE dbx_lab_catalog.dbx_learning.reference_products;
SELECT COUNT(*) AS rows_seen FROM dbx_lab_catalog.dbx_learning.reference_products;
```

4. In Compute and Jobs, inspect the create/run buttons and policy assignments. **Do not** equate a visible button to a verified permission, and do not intentionally change roles. Record effective identity or membership only from a permitted identity view.
5. **Negative probe:** pick one already-denied or unavailable read-only action. Record the exact permission error **only if safely obtained**; otherwise label the action `UNVERIFIED` and do not attempt the potentially unsafe probe.

**Pass:** ≥12 accurately sourced rows; ≥3 verifications with actual outputs; each `ALLOWED`, `DENIED`, `NOT AVAILABLE`, or `UNKNOWN` justified; no privilege escalation. **Evidence:** CSV, sanitized grants, permission gap list.

## F03 — Trace execution of one Spark query
- **Access/time:** SQL warehouse or notebook compute, 60–80 min.
- **Fixture & steps:** Run `SELECT bucket, COUNT(*) FROM (SELECT id % 4 AS bucket FROM range(1000)) GROUP BY bucket ORDER BY bucket;`. Inspect physical plan and available query/Spark UI metrics; label scans, aggregation and shuffle if present.
- **Prove:** 4 groups, each **250**; annotated query plan with two observed metrics and execution explanation. Negative: describe why *no Spark job* may be visible until an action is triggered (execution engine-dependent).
- **Hands-on check:** Run the aggregate and `EXPLAIN FORMATTED`, capture the four `250` results and two execution metrics; in a notebook compare a lazy DataFrame definition with an action run. **Cleanup:** Stop only newly started compute.


### Hands-on execution playbook for F03

Execute on a permitted SQL warehouse (note that its plan UI can differ from notebook Spark UI):

```sql
SELECT id % 4 AS bucket, COUNT(*) AS n
FROM range(1000)
GROUP BY id % 4
ORDER BY bucket;
EXPLAIN FORMATTED
SELECT id % 4 AS bucket, COUNT(*) AS n
FROM range(1000)
GROUP BY id % 4
ORDER BY bucket;
```

1. Confirm exact rows `(0,250),(1,250),(2,250),(3,250)`; attach query result as CSV or screenshot.
2. Inspect the query profile/physical plan and identify scan, aggregate and exchange **only if actually present**. Record two actual observed metrics (e.g., rows output, duration, shuffle data size); when the engine hides them, record `UNAVAILABLE`.
3. In a Python notebook with permitted Spark compute, run `from pyspark.sql.functions import expr; df=spark.range(1000).withColumn("bucket", expr("id % 4"))`; capture available UI metrics **before** and **after** running `df.groupBy("bucket").count().collect()`. Do not claim an identical UI implementation between SQL and Spark jobs.
4. **Fail probe:** omit `.collect()` in a separate run and compare actual execution records with those from the action; do not claim zero backend tasks in every execution engine.

**Pass:** exact four 250 counts plus annotated plan, 2 grounded metrics or documented UI limitation, and distinction between Spark's execution graph and a Databricks scheduled Job.

## F04 — Build and verify a miniature Bronze/Silver/Gold transformation
- **Access/time:** SQL, 60–90 min.
- **Fixture & steps:** In a **ticket-local temporary dataset**, create six synthetic records with fields `(event_id, order_id, event_ts, qty, unit_price, status)`: three normal orders, one same-order retry with a distinct `event_id`, one null-quantity order and one later correction. Run the provided Bronze/Silver/Gold temporary-view SQL, including invalid-row handling and latest-valid-event selection. Run at least **five executable SQL assertions** against ticket-local input/expected-output views; do not stop at a diagram. No dependency on another ticket.
- **Prove:** executed `contracts.sql` with actual raw/Silver/Gold results and before/after duplicate/invalid-row checks. Negative: show why dropping invalid rows in Bronze hides audit evidence.
- **Hands-on check:** Run the six-event fixture, verify 6 raw, 1 rejected, 3 latest valid orders and Gold 30; deliberately query raw rows to capture the wrong total of 44. **Cleanup:** None.


### Hands-on execution playbook for F04

**Fixture** (six events; price in whole units to make arithmetic unambiguous):

```sql
CREATE OR REPLACE TEMP VIEW f04_input AS
SELECT * FROM VALUES
 ('e1',1,1,'2026-01-01T10:00:00Z',2,5,'paid'),
 ('e2',2,1,'2026-01-01T10:00:00Z',1,8,'paid'),
 ('e3',3,1,'2026-01-01T10:00:00Z',1,6,'paid'),
 ('e4',2,2,'2026-01-01T10:01:00Z',1,8,'paid'),
 ('e5',4,1,'2026-01-01T10:01:00Z',CAST(NULL AS INT),4,'paid'),
 ('e6',3,3,'2026-01-01T10:02:00Z',2,6,'paid')
AS t(event_id,order_id,seq,event_ts,qty,unit_price,status);
CREATE OR REPLACE TEMP VIEW f04_rejects AS
SELECT * FROM f04_input WHERE qty IS NULL OR qty <= 0 OR status <> 'paid';
CREATE OR REPLACE TEMP VIEW f04_silver AS
SELECT event_id,order_id,qty,unit_price FROM (
 SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY event_ts DESC,seq DESC,event_id DESC) AS rn
 FROM f04_input WHERE qty IS NOT NULL AND qty > 0 AND status='paid'
) q WHERE rn=1;
SELECT COUNT(*) AS bronze_events FROM f04_input;       -- 6
SELECT COUNT(*) AS rejects FROM f04_rejects;           -- 1
SELECT COUNT(*) AS silver_orders FROM f04_silver;      -- 3
SELECT SUM(qty*unit_price) AS gold_total FROM f04_silver; -- 30
SELECT COUNT(DISTINCT order_id) AS n FROM f04_silver; -- 3
```

1. Run the fixture SQL and save the exact SQL in `tickets/F04/contracts.sql`. Confirm the selected event IDs for each order and that rejected `e5` remains in the raw input.
2. Execute all five queries. Verify `e5` is rejected, `e4` supersedes `e2` for order 2, and `e6` supersedes `e3` for order 3; save those observed rows.
3. **Fail probe:** intentionally compute `SUM(qty*unit_price)` on the raw six rows (null contribution is ignored, duplicate events double count), obtain actual raw total **44** and compare it to the correct Silver-derived Gold total **30**. Save both query outputs as a failing-versus-corrected test.
4. Correctness check: Silver business keys exactly `{1,2,3}` with amounts `10,8,12` → Gold `30`. **No cross-ticket resources** needed (temporary views only).

**Pass:** five observed SQL checks, raw-vs-correct result comparison (44 vs 30), and a reproducible SQL file; no prose assignment or diagram is required.

---

# Track B — Unity Catalog Volumes and storage (4 tickets)

## V01 — Write, list and read files in the shared managed volume
- **Access/time:** Volume `READ/WRITE`, notebook compute, 45–70 min.
- **Fixture & steps:** Create **folder** `V01/` inside the already-existing shared volume; write `products.csv` as `product_id,price\np1,10\np2,20\np3,30\np4,40\np5,50\n`. Use `dbutils.fs.put` (if supported on your compute), list the folder, read with Spark CSV header and explicit numeric types.
- **Prove:** count **5**, sum(price) **150**, correct path and schema captured; error probe for `V01/missing.csv`. Record that, for file writes, effective permissions commonly include both `READ VOLUME` and `WRITE VOLUME` plus parent namespace `USE` privileges; test them against your actual setup.
- **Hands-on check:** Write the sample CSV inside `lab_files/V01/`, list it and load with an explicit schema. Verify count=5 and sum=150; prove no Delta table appears just by writing the file. **Cleanup:** Only `V01/` if you choose; retain `lab_files`.


### Hands-on execution playbook for V01

Use the universal preflight cell, then:

```python
import os
from pyspark.sql import functions as F
p = f"{VOL}/V01/products.csv"
os.makedirs(os.path.dirname(p), exist_ok=True)
with open(p, "w", encoding="utf-8") as f:
    f.write("product_id,price\np1,10\np2,20\np3,30\np4,40\np5,50\n")
df = spark.read.option("header", True).schema("product_id STRING, price INT").csv(p)
assert df.count() == 5
assert df.agg(F.sum("price")).first()[0] == 150
assert [r.name for r in dbutils.fs.ls(f"{VOL}/V01/")].count("products.csv") == 1
try:
    spark.read.csv(f"{VOL}/V01/missing.csv").count()
except Exception as ex:
    print("Expected missing-file negative test:", type(ex).__name__)
else:
    raise AssertionError("Missing-path probe unexpectedly succeeded")
```

**Pass:** `n=5`, sum `150`, explicit schema, listing, expected missing-file error. **Permissions:** parent namespace `USE` plus `READ VOLUME`; writing typically needs `READ VOLUME` and `WRITE VOLUME`. Never write in volume root or another ticket folder. Record that volume storage does not create a Delta table.

## V02 — Connect a ticket-owned external ADLS location and volume [ADMIN / CONDITIONAL]
- **Access/time:** 90–180 min, Azure RBAC + UC privilege; within the **same** workspace.
- **Fixture & steps:** In the one approved learning RG/storage account, allocate *unique* prefix `v02/` (do not reuse a storage root). Seed 3 fake CSV rows. Register or reuse an authorized managed-identity credential and external location; create `C.S.v02_external` pointing to the exact approved prefix. Read via `/Volumes/C/S/v02_external/orders.csv`.
- **Prove:** 3 rows; map Azure RBAC → identity → credential → external location → UC grants → volume → user. Negative: demonstrate a harmless permission/invalid-path denial, not privilege escalation. Verify underlying files survive dropping the external volume (if cleanup is approved).
- **Hands-on check:** With approved storage rights, write an external-volume marker and verify it from both Unity Catalog and the dedicated Azure storage prefix; confirm access/ownership separately. **Cleanup:** Only V02 UC object and dedicated ADLS prefix, after retention check; **never** touch shared V.


### Hands-on execution playbook for V02

**No secrets. Do not try this on an unapproved storage account.** Use one pre-approved Azure learning resource group and a **V02-only** ADLS Gen2 container/prefix (`.../v02/`), inside the same workspace. The credential/external location may already exist: do not create duplicates if an administrator provides governed equivalents.

1. Ask administrator for the approved `abfss://<container>@<account>.dfs.core.windows.net/v02/` path, managed identity/access connector, dedicated storage credential and external-location name. Record ownership and Azure RBAC scope **without embedding IDs into public files**.
2. Confirm ADLS directory and seed **only** `v02/orders.csv` with `order_id,qty\n1,2\n2,3\n3,4\n` using the approved upload interface. Create the external volume under the one `C.S` using Catalog Explorer, or after reviewing rights use:

```sql
-- Replace all placeholders. `CREATE EXTERNAL VOLUME` requires approved external location permissions.
CREATE EXTERNAL VOLUME dbx_lab_catalog.dbx_learning.v02_external
LOCATION 'abfss://<container>@<storage-account>.dfs.core.windows.net/v02/';
```

3. On compatible notebook compute with the preflight cell:

```python
p = f"/Volumes/{CATALOG}/{SCHEMA}/v02_external/orders.csv"
df = spark.read.option("header", True).schema("order_id INT, qty INT").csv(p)
assert df.count() == 3
assert sum(row.qty for row in df.select("qty").collect()) == 9
```

4. Draw and validate identity chain: cloud RBAC → access connector/identity → storage credential → external location → volume → UC rights of caller. **Fail probe** only on a different, harmless missing V02 path or a preapproved denied action; never attempt to bypass access policy.
5. Only with explicit approval, drop the V02 UC volume, verify external backing data still exists through the approved storage interface, and document the persistence distinction; do not delete underlying data unless told to.

**Pass:** three records, qty sum 9, verified credential/permission chain, observed external-data persistence when authorized. **Block:** no Azure rights or external location rights means `BLOCKED`; a local mock is not equivalent.

## V03 — Test least-privilege Volume READ versus WRITE [SECURITY / CONDITIONAL]
- **Access/time:** 60–90 min, authorized separate test principal in **same sandbox**.
- **Fixture & steps:** Create `C.S.v03_secure` (dedicated *test volume*, not replacement of shared V) containing `evidence.txt`. With an explicitly authorized test principal, grant `USE CATALOG` + `USE SCHEMA` and `READ VOLUME` only; test read succeeds and write fails; grant `WRITE VOLUME` and repeat; revoke only the test grants and retest. Confirm there are no inherited grants or ownership rights that invalidate the isolation test. Inspect effective permissions and ownership.
- **Prove:** permission matrix and at least one actual denied write, one allowed read, one allowed write. Negative: confirm denial is a privilege error rather than missing file/compute access.
- **Hands-on check:** Using an approved test principal, run actual read and write probes before and after a minimal reversible grant; capture allow/deny results and rollback. **Cleanup:** Revoke only V03 test grants, delete `v03_secure` if approved, keep C/S/V.


### Hands-on execution playbook for V03

1. Obtain a separate **approved test principal** with no inherited `READ/WRITE VOLUME` or owner privileges over `C.S.v03_secure`; inspect effective inherited catalog/schema grants first. Create `v03_secure` (never `lab_files`), and as owner upload `evidence.txt` containing `synthetic-only`.
2. Grant only the needed **parent** `USE CATALOG` and `USE SCHEMA` and **object** `READ VOLUME` to that principal, after reviewing default/inherited rights. Example (substitute actual names and properly quoted principal):

```sql
GRANT USE CATALOG ON CATALOG dbx_lab_catalog TO `<approved_test_principal>`;
GRANT USE SCHEMA ON SCHEMA dbx_lab_catalog.dbx_learning TO `<approved_test_principal>`;
GRANT READ VOLUME ON VOLUME dbx_lab_catalog.dbx_learning.v03_secure TO `<approved_test_principal>`;
SHOW GRANTS ON VOLUME dbx_lab_catalog.dbx_learning.v03_secure;
-- After signed-in separate-principal read + denied write:
GRANT WRITE VOLUME ON VOLUME dbx_lab_catalog.dbx_learning.v03_secure TO `<approved_test_principal>`;
```

3. **As that principal, not as owner:** read succeeds; write to an owned test filename must fail before WRITE, then succeed after WRITE. Capture exact 3 observations and effective identities. Inspect whether WRITE also requires READ in your runtime (the volume privilege matrix says it does).
4. Revoke **only grants newly made for V03** after test; preserve any pre-existing parent grants; inspect the result as test principal. No secret/token sharing or impersonation.

**Pass:** `allow READ → deny WRITE → allow WRITE` proven by independent identity, not by simulated SQL. **Block:** no second approved principal or no privilege-management rights.

## V04 — Load a volume CSV into a Delta table and prove separation
- **Access/time:** 50–75 min.
- **Fixture & steps:** Seed `V04/orders.csv` with `(1001,2,5.00), (1002,1,9.00), (1003,3,4.00)` under `order_id,qty,price`. Read it via Spark, explicitly cast numbers, and save as `C.S.v04_orders` with Delta format (prefer create/insert explicit schema). Confirm table metadata and physical file paths.
- **Prove:** row count **3** and `SUM(qty*price)=31.00`. Change the CSV without reloading and verify **the table does not update itself**. Negative: add malformed row only in `V04/`, capture quality handling, and do not silently incorporate it.
- **Hands-on check:** Load the ticket-owned CSV to a Delta table, change only its source data, reload as specified, and inspect table history; compare the file and Delta table state. **Cleanup:** Only `v04_orders` and `V04/` (optional).


### Hands-on execution playbook for V04

Preflight cell, then:

```python
import os
from pyspark.sql import functions as F
p = f"{VOL}/V04/orders.csv"
os.makedirs(os.path.dirname(p), exist_ok=True)
with open(p, "w", encoding="utf-8") as f:
    f.write("order_id,qty,price\n1001,2,5.00\n1002,1,9.00\n1003,3,4.00\n")
df = spark.read.option("header",True).schema("order_id INT, qty INT, price DECIMAL(10,2)").csv(p)
assert df.count() == 3
target = f"{NS}.v04_orders"
# Only overwrite your *own* V04 table after checking ownership/inventory.
df.write.format("delta").mode("overwrite").saveAsTable(target)
assert spark.table(target).count() == 3
assert spark.table(target).selectExpr("sum(qty*price) AS gross").first()[0] == 31
with open(p, "a", encoding="utf-8") as f:
    f.write("1004,10,10.00\n")
assert spark.table(target).count() == 3  # table did not auto-refresh
assert spark.read.option("header",True).schema("order_id INT,qty INT,price DECIMAL(10,2)").csv(p).count() == 4
```

**Fail probe:** append malformed `1005,bad,2.00` to the source **after** validation; compare the actual permissive-parse result against the strict validation/reject result on the malformed row. **Pass:** table 3/31.00 while source 4 after benign append, Delta `DESCRIBE DETAIL` observed and table storage separated from source CSV. This lab owns `v04_orders` and `V04/` only.

---

# Track C — Delta tables, reliability and performance (7 tickets)

## T01 — Complete CRUD lifecycle on a Delta table
- **Access/time:** SQL warehouse, 45–65 min.
- **Fixture & steps:** `CREATE TABLE C.S.t01_sales (id INT, customer STRING, amount DECIMAL(10,2)) USING DELTA;` insert `(1,'c1',10),(2,'c2',20),(3,'c3',30)`; inspect schema/history; UPDATE id=2 to 25; DELETE id=3.
- **Prove:** final IDs `1,2`, amount sum **35**, recorded commit history. Negative: update nonexistent id=999 and verify the row count/checksum did not change.
- **Hands-on check:** Execute INSERT, UPDATE and DELETE on `t01_sales`. Verify 2 remaining rows and sum=35, then inspect the actual Delta history. **Cleanup:** Only `t01_sales`.


### Hands-on execution playbook for T01

After selecting `C.S` and confirming table name unowned or ticket-owned:

```sql
CREATE OR REPLACE TABLE t01_sales (id INT, customer STRING, amount DECIMAL(10,2)) USING DELTA;
INSERT INTO t01_sales VALUES (1,'c1',10.00),(2,'c2',20.00),(3,'c3',30.00);
UPDATE t01_sales SET amount=25.00 WHERE id=2;
DELETE FROM t01_sales WHERE id=3;
SELECT id,amount FROM t01_sales ORDER BY id; -- (1,10.00),(2,25.00)
SELECT COUNT(*) AS n,SUM(amount) AS total FROM t01_sales; -- (2,35.00)
DESCRIBE HISTORY t01_sales;
UPDATE t01_sales SET amount=999 WHERE id=999; -- should change zero rows
SELECT COUNT(*) AS n,SUM(amount) AS total FROM t01_sales; -- remains (2,35.00)
```

**Pass:** 2/35.00, update/delete commits observed in history and a nonexistent-ID test leaving the invariant unchanged. Save the `DESCRIBE HISTORY` output as evidence.

## T02 — Trigger and diagnose schema enforcement
- **Access/time:** SQL, 45–70 min.
- **Fixture & steps:** Create `t02_orders(id INT, amount DECIMAL(10,2))`, insert `(1,5.00)`; attempt `CAST('not_a_number' AS DECIMAL(10,2))` in ANSI mode before/while inserting; record error. Insert valid `(2,9.99)` and check schema/history.
- **Prove:** count **2**, invalid value absent, exact failure category and corrected statement. Negative: run `try_cast` on malformed input, observe the resulting NULL, then prove a NOT NULL/quality assertion catches it.
- **Hands-on check:** Try an incompatible insert, capture the real schema/type error, quarantine malformed test input, then run a corrected insert and show the accepted state. **Cleanup:** Only `t02_orders`.


### Hands-on execution playbook for T02

```sql
CREATE OR REPLACE TABLE t02_orders (id INT, amount DECIMAL(10,2)) USING DELTA;
INSERT INTO t02_orders VALUES (1,5.00);
-- Run the following as a separate, expected-to-fail statement in ANSI mode:
-- INSERT INTO t02_orders SELECT 999, CAST('not_a_number' AS DECIMAL(10,2));
INSERT INTO t02_orders VALUES (2,9.99);
SELECT COUNT(*) AS n, SUM(amount) AS total FROM t02_orders; -- 2,14.99
SELECT try_cast('not_a_number' AS DECIMAL(10,2)) AS permissive_result; -- NULL
```

1. Before the failing statement, check that `spark.sql.ansi.enabled`/SQL warehouse behavior actually rejects invalid casts and record observed setting. Execute uncommented **negative INSERT separately**, capture its error and confirm the table still has only the intended rows.
2. Do **not** treat `TRY_CAST` silently emitting `NULL` as a passed schema contract. Create a temporary reject output or note rejected original string and reason.

**Pass:** 2/14.99, exact error class, comparison with TRY_CAST, and explanation of raw retention vs trusted table contract.

## T03 — Make a replay-safe MERGE
- **Access/time:** SQL, 55–85 min.
- **Fixture & steps:** `t03_accounts(id INT, balance INT)` initially `(1,100),(2,200)`; merge source `(2,250),(3,300)` matched UPDATE / unmatched INSERT. Execute the same merge **twice** with the same seed; compare results.
- **Prove:** 3 records, total balance **650** after both runs; save both history events and logical-state checks. Negative: run the ticket-scoped duplicate-source-key MERGE probe and capture its failure or the verified pre-merge duplicate guard.
- **Hands-on check:** Execute the MERGE twice and compare key counts and balances after each run; the second run must produce no duplicate business state. **Cleanup:** Only `t03_accounts` and staging relation.


### Hands-on execution playbook for T03

```sql
CREATE OR REPLACE TABLE t03_accounts (id INT, balance INT) USING DELTA;
INSERT INTO t03_accounts VALUES (1,100),(2,200);
CREATE OR REPLACE TEMP VIEW t03_changes AS SELECT * FROM VALUES (2,250),(3,300) AS x(id,balance);
MERGE INTO t03_accounts AS t USING t03_changes AS s ON t.id=s.id
WHEN MATCHED THEN UPDATE SET balance=s.balance
WHEN NOT MATCHED THEN INSERT (id,balance) VALUES (s.id,s.balance);
SELECT COUNT(*) n,SUM(balance) total FROM t03_accounts; -- 3,650
-- Execute the same MERGE a second time, unchanged, then repeat SELECT; still 3/650.
DESCRIBE HISTORY t03_accounts;
```

**Fail probe:** create `t03_bad_changes` with `(2,250),(2,260)` and attempt a MERGE that ambiguously updates the same matched target row; capture whether runtime detects the ambiguity. The source must be deduplicated deterministically **before** any real MERGE. Do not leave the bad merge applied. **Pass:** same set `{1:100,2:250,3:300}` after both identical merges and a documented failure/guard.

## T04 — Recover a table with version history and time travel
- **Access/time:** SQL, 50–80 min.
- **Fixture & steps:** Create `t04_products(id INT, price INT)`; insert `(1,10),(2,20)`; record the post-insert version **V**. Simulate `UPDATE t04_products SET price=1`, compare current to version V, then RESTORE only your own test table where supported.
- **Prove:** bad sum **2**, restored sum **30**, recorded versions and recovery operation; negative: inspect the actual table history/retention setting; do not delete old files or run aggressive VACUUM.
- **Hands-on check:** Capture the actual pre-change Delta version, make a controlled bad update, query the earlier snapshot, RESTORE and verify the original sum of 30. **Cleanup:** Only `t04_products`.


### Hands-on execution playbook for T04

```sql
CREATE OR REPLACE TABLE t04_products (id INT,price INT) USING DELTA;
INSERT INTO t04_products VALUES (1,10),(2,20);
DESCRIBE HISTORY t04_products; -- RECORD post-insert version V here; do not guess
UPDATE t04_products SET price=1;
SELECT SUM(price) AS bad_total FROM t04_products; -- 2
-- Replace <V> with the observed post-insert Delta version number:
-- SELECT SUM(price) AS original_total FROM t04_products VERSION AS OF <V>;  -- 30
-- RESTORE TABLE t04_products TO VERSION AS OF <V>; -- only if permitted/supported
SELECT SUM(price) AS current_total FROM t04_products; -- 30 after restore
```

**Pass:** actual V, bad 2, versioned 30, restored 30, restore commit visible. **If RESTORE unsupported:** record `PARTIAL` rather than claiming recovery occurred. **Safety probe:** inspect current Delta history and effective retention settings; confirm you can query the saved pre-change version before attempting RESTORE. Do **not** run aggressive VACUUM in the shared sandbox.

## T05 — Use Delta Change Data Feed for inserts, updates and deletes
- **Access/time:** SQL/compute compatible with CDF, 60–95 min.
- **Fixture & steps:** Create `t05_inventory(sku STRING, qty INT)` with `TBLPROPERTIES (delta.enableChangeDataFeed=true)` **before making any writes**. Insert `('a',10),('b',20)`; record the insertion version. Update a→7, delete b, insert c→8. Query `table_changes('C.S.t05_inventory', <observed_version>)`.
- **Prove:** from the first observed data commit onward, identify **three inserts** (a,b,c), **one update preimage**, **one update postimage**, and **one delete**, with observed versions and current inventory `(a,7),(c,8)`. Negative: query CDF for an earlier unavailable version where safe and record actual capability/error; never invent pre-activation change records.
- **Hands-on check:** Enable CDF on the ticket table, perform insert/update/delete, then query the CDF ranges for the actual `insert`, `update_preimage`, `update_postimage` and `delete` rows. **Cleanup:** Only `t05_inventory`.


### Hands-on execution playbook for T05

```sql
CREATE OR REPLACE TABLE t05_inventory (sku STRING, qty INT) USING DELTA
TBLPROPERTIES (delta.enableChangeDataFeed = true);
INSERT INTO t05_inventory VALUES ('a',10),('b',20);
DESCRIBE HISTORY t05_inventory; -- RECORD this insert commit version V
UPDATE t05_inventory SET qty=7 WHERE sku='a';
DELETE FROM t05_inventory WHERE sku='b';
INSERT INTO t05_inventory VALUES ('c',8);
SELECT * FROM t05_inventory ORDER BY sku; -- ('a',7),('c',8)
-- Replace <V> with captured first INSERT commit version; execute separately:
-- SELECT sku,qty,_change_type,_commit_version
-- FROM table_changes('dbx_lab_catalog.dbx_learning.t05_inventory', <V>)
-- ORDER BY _commit_version,sku,_change_type;
```

**Pass:** 3 `insert` events (a,b,c), 1 `update_preimage`, 1 `update_postimage`, 1 `delete` *when queried from the initial insert commit* and current inventory a=7/c=8. Record actual CDF versions; no assumptions about exact version numbers or CDF for earlier disabled periods. **Fail probe:** document why attempting CDF at versions before activation cannot reconstruct missing historical changes.

## T06 — Inspect Spark plans and Delta maintenance without false benchmarks
- **Access/time:** SQL/compute, 60–90 min.
- **Fixture & steps:** Create `t06_events` as a Delta table from `range(10000)` with `bucket=id%10` and `value=id%100`; run filtered count and `EXPLAIN FORMATTED`; measure three runs, execute `OPTIMIZE` if supported/permitted, and inspect `DESCRIBE DETAIL` before/after.
- **Prove:** bucket=3 has **1000** rows. Capture timing methodology, data size, file counts and any query-plan differences. Negative: explicitly state that **small data may not improve** and a speedup claim without controlled evidence fails the ticket.
- **Hands-on check:** Capture an actual physical plan and table-detail metrics before/after the approved Delta maintenance action; report measured differences without promising a speedup. **Cleanup:** Only `t06_events`.


### Hands-on execution playbook for T06

```sql
CREATE OR REPLACE TABLE t06_events USING DELTA AS
SELECT CAST(id AS BIGINT) AS id, CAST(id % 10 AS INT) AS bucket,
       CAST(id % 100 AS INT) AS value FROM range(10000);
SELECT COUNT(*) AS n FROM t06_events WHERE bucket=3; -- 1000
EXPLAIN FORMATTED SELECT COUNT(*) FROM t06_events WHERE bucket=3;
DESCRIBE DETAIL t06_events;
-- Only if permitted / supported: OPTIMIZE t06_events;
-- Then rerun DESCRIBE DETAIL and same query/profile, not an assumed speedup.
```

1. Measure three runs under comparable conditions and record cache/warehouse state, wall-time, rows, file counts and compute type. Do not treat tiny-dataset measurements as a benchmark of production architecture.
2. **Fail probe:** propose “OPTIMIZE always makes every query faster”; refute using observed metrics or explicitly mark inconclusive when noise dominates.

**Pass:** count 1000, recorded plan before/after, actual file/size metadata, honest comparison with uncertainties and potential DBU cost.

## T07 — Build a valid table-quality contract and regression tests
- **Access/time:** SQL, 60–90 min.
- **Fixture & steps:** Seed `t07_orders(event_id,order_id,qty,price,status)` with `(e1,1,2,5,paid),(e2,2,1,8,paid),(e3,2,1,8,paid),(e4,3,-1,4,paid),(e5,4,2,9,unknown)`. Treat `e2` as the deterministic survivor for order 2 (order by explicit event_id/sequence); `e3` is a duplicate retry, `e4` fails quantity, `e5` fails status. Create `t07_rejected` with exact reason codes and `t07_clean` by explicit rules.
- **Prove:** raw **5**, clean **2** distinct valid IDs (1 and 2), rejected **3** event IDs (e3/e4/e5), and exactly **one primary rejection reason per rejected event**. Add SQL assertions and fail intentionally on the raw table.
- **Hands-on check:** Execute the five data-quality assertions; inject the prescribed invalid fixture to make a test fail, then correct the fixture and obtain a clean pass. **Cleanup:** Only `t07_*`.


### Hands-on execution playbook for T07

```sql
CREATE OR REPLACE TABLE t07_orders (event_id STRING,order_id INT,qty INT,price INT,status STRING) USING DELTA;
INSERT INTO t07_orders VALUES
('e1',1,2,5,'paid'),('e2',2,1,8,'paid'),('e3',2,1,8,'paid'),
('e4',3,-1,4,'paid'),('e5',4,2,9,'unknown');
CREATE OR REPLACE TEMP VIEW t07_decisions AS
WITH ranked AS (
 SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY event_id ASC) AS rn
 FROM t07_orders
)
SELECT *, CASE
 WHEN qty <= 0 OR qty IS NULL THEN 'INVALID_QTY'
 WHEN status <> 'paid' OR status IS NULL THEN 'INVALID_STATUS'
 WHEN rn > 1 THEN 'REPLAY'
 ELSE 'OK' END AS reason FROM ranked;
CREATE OR REPLACE TABLE t07_rejected USING DELTA AS
 SELECT * FROM t07_decisions WHERE reason <> 'OK';
CREATE OR REPLACE TABLE t07_clean USING DELTA AS
 SELECT event_id,order_id,qty,price,status FROM t07_decisions WHERE reason='OK';
SELECT COUNT(*) AS raw FROM t07_orders; -- 5
SELECT COUNT(*) AS valid FROM t07_clean; -- 2
SELECT COUNT(*) AS rejected FROM t07_rejected; -- 3
SELECT event_id,reason FROM t07_rejected ORDER BY event_id;
-- e3 REPLAY; e4 INVALID_QTY; e5 INVALID_STATUS
```

**Pass:** exact e3/e4/e5 reason map, only e1/e2 in clean and exactly 2 unique order IDs. **Fail probe:** run `SELECT COUNT(*) FROM t07_orders` (which returns 5), then execute the duplicate/null/validity assertions that detect actual defects despite the same count. **Trade-off:** higher-level policy might reject multiple reasons; here one *primary* reason is intentionally assigned per event for deterministic assessment.

---

# Track D — Lakeflow Jobs and orchestration (6 tickets)

## J01 — Create and run a manual Databricks Job
- **Access/time:** `CREATE JOB` rights + permitted job compute, 45–75 min.
- **Fixture & steps:** Create `src/j01_count_orders` notebook or Python task that generates **10** synthetic IDs and prints/writes their count; make job `dbx_j01_manual` with one task. Run manually, inspect run ID, task status, compute used, duration and logs.
- **Prove:** successful execution with count **10** and run page evidence. Negative: attempt a test run of a deliberately missing notebook path in a separate task/job or inspect pre-validation without altering working job; capture the actual missing-task/path error or validation state.
- **Hands-on check:** Create the manual job, run it, open the Databricks run page, and capture the exact run result plus a real job/run ID. **Cleanup:** Delete/disable only J01 test job if desired.


### Hands-on execution playbook for J01

**In `tickets/J01/` create a Databricks Python notebook named `j01_count_orders`:**

```python
# Databricks notebook source
from pyspark.sql import functions as F
n = spark.range(10).count()
assert n == 10, f"Expected ten synthetic rows, got {n}"
print("J01 verified rows:", n)
```

1. Workflows → Jobs & Pipelines → **Create Job**. Name `dbx_j01_manual`, task key `count_orders`, task type **Notebook**, select the J01 notebook in your existing workspace/Git folder and **approved small compute**. Set **no schedule**; limit concurrent runs to 1.
2. Select **Run now** once. Open run details. Capture job ID, run ID, state (`SUCCESS`), task output `J01 verified rows: 10`, compute used and elapsed time. Verify the task is *run as* the identity recorded in the run configuration.
3. **Safe failure:** create a **separate temporary J01 negative task/job** pointing to an intentionally nonexistent *J01* notebook path (or use preflight validation if UI disallows submission). Observe missing-path error and remove only that temporary task/job; leave original successful job intact.
4. No second workspace, no fake datasets required. **Pass:** real successful run, output 10, negative diagnostic, saved log/run link, no active schedule. **Block:** job creation or compute denied.

## J02 — Parameterize a job and verify different outcomes
- **Access/time:** Job creation, 55–80 min.
- **Fixture & steps:** Create task `src/j02_process_orders` taking `region` and `batch_size`; generate synthetic `range(batch_size)` records and write count to `C.S.j02_results` tagged by run/region. Execute twice: `region=ON,batch_size=3` and `region=QC,batch_size=5`.
- **Prove:** two distinct run IDs and results **3** and **5** without manual code edits. Negative: empty/negative batch_size must fail validation with a useful error.
- **Hands-on check:** Run the job with two parameter combinations and compare the persisted outputs and logged parameter values. **Cleanup:** Stop job and keep/remove only J02 table.


### Hands-on execution playbook for J02

**Create notebook `j02_process_orders`**; include universal preflight:

```python
# Databricks notebook source
from uuid import uuid4
dbutils.widgets.text("region", "ON")
dbutils.widgets.text("batch_size", "3")
region = dbutils.widgets.get("region").strip().upper()
raw = dbutils.widgets.get("batch_size")
assert region in ("ON", "QC"), "region must be ON or QC"
assert raw.isdecimal() and 0 < int(raw) <= 20, "batch_size must be integer 1..20"
n = spark.range(int(raw)).count()
assert n == int(raw)
# Save deterministic business result and unique attempt ID, without secrets.
run_tag = uuid4().hex
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.j02_results (run_tag STRING, region STRING, n INT) USING DELTA")
rows = spark.createDataFrame([(run_tag, region, n)], "run_tag STRING,region STRING,n INT")
rows.write.mode("append").insertInto(f"{NS}.j02_results")
print(f"J02 result: {region} {n} tag={run_tag}")
```

1. Create manual-only `dbx_j02_parameterized` with a Notebook task. Set the notebook task's two `base_parameters`: `region=ON`, `batch_size=3`. Confirm widget names match exactly (job-level parameter forwarding differs by task type; choose the mechanism proven by your workspace).
2. Run once with ON/3; override with QC/5 in another run (do not change the source notebook). Record **both actual run IDs and printed run tags**. Verify:

```sql
SELECT region, n, run_tag FROM j02_results ORDER BY run_tag;
-- Match the two captured run_tag values: one (ON,3) and one (QC,5).
```

3. **Fail:** run with `batch_size=-1` under a third run; expect an **intentional assertion/validation failure** before data write. Verify the bad attempt created no successful `j02_results` row with that run tag.
4. **Pass:** 2 successful runs with 3/5 and distinct IDs, one failed invalid-parameter run, no source code changes, all outputs traceable. Clear only J02 table/job if resetting. Stop schedules.

## J03 — Model a three-task DAG and passing outputs
- **Access/time:** Job creation, 75–110 min.
- **Fixture & steps:** Create tasks `generate`, `validate`, `summarize` inside `dbx_j03_dag`; each is a standalone notebook/script within J03. Generate 6 fake orders into `j03_raw` with `(order_id,qty,unit_price) = (1,1,10),(2,2,5),(3,1,7),(4,1,8),(5,3,2),(6,2,4)`; validate all quantities positive into `j03_valid`; summarize `COUNT(*)` and `SUM(qty*unit_price)`. Link tasks by explicit dependencies, pass run-specific references through supported parameters/task values.
- **Prove:** all three succeed, **6** validated records and **49** total value, predecessor links and run lineage visible. Negative: seed one invalid row and confirm the validating task fails and downstream summary does not misleadingly succeed.
- **Hands-on check:** Build the three-task DAG in Jobs, run it, inspect the task graph and pass task outputs using the specified supported method. **Cleanup:** Stop/delete only J03 job; ticket tables only.


### Hands-on execution playbook for J03

**Configure `dbx_j03_dag`, max concurrent runs 1, with three notebook tasks:** `generate` → `validate` → `summarize`. Include universal preflight in **each notebook** (tasks have separate sessions). Use the following notebook bodies:

**`j03_generate.py`**:

```python
from pyspark.sql import functions as F
records = [(1,1,10),(2,2,5),(3,1,7),(4,1,8),(5,3,2),(6,2,4)]
spark.createDataFrame(records,"order_id INT,qty INT,unit_price INT") \
    .write.mode("overwrite").format("delta").saveAsTable(f"{NS}.j03_raw")
assert spark.table(f"{NS}.j03_raw").count() == 6
dbutils.jobs.taskValues.set(key="fixture_count", value=6)
```

**`j03_validate.py`**:

```python
n_upstream = dbutils.jobs.taskValues.get(taskKey="generate", key="fixture_count")
assert n_upstream == 6
src = spark.table(f"{NS}.j03_raw")
assert src.count() == 6
assert src.where("qty IS NULL OR qty <= 0 OR unit_price < 0").count() == 0, "Invalid order in J03 raw"
src.write.mode("overwrite").format("delta").saveAsTable(f"{NS}.j03_valid")
dbutils.jobs.taskValues.set(key="validated_count", value=src.count())
```

**`j03_summarize.py`**:

```python
from pyspark.sql import functions as F
expected_n = dbutils.jobs.taskValues.get(taskKey="validate", key="validated_count")
src = spark.table(f"{NS}.j03_valid")
n = src.count()
total = src.selectExpr("SUM(qty*unit_price) AS gross").first()[0]
assert (n, total) == (expected_n, 49), (n,total)
print("J03 success:", n, total)
```

1. Run and inspect the dependency graph. Verify `generate → validate → summarize` and printed `J03 success: 6 49`; record task-level run IDs, task values/outputs (as visible) and duration.
2. **Negative:** in a *controlled J03 test run*, change one generator record to a negative quantity (e.g. `(4,-1,8)`); run again. `validate` must fail and `summarize` must be skipped/blocked. Restore original fixture code after the test and rerun green. For a stronger exercise, use a J03-only job parameter `inject_bad_row` rather than committing deliberate corruption.
3. **Pass:** green original 6/49, red injection blocks summary, fixed retry green; the tables are only `j03_*`. *Never* assume task values are available from an interactive notebook run outside a job context.

## J04 — Configure and safely test a file-arrival trigger
- **Access/time:** Conditional: compatible file-arrival trigger available, job permissions, 70–110 min.
- **Fixture & steps:** Use dedicated `V/J04/incoming/` folder (not V root) and job `dbx_j04_file_trigger`; configure a supported file-arrival trigger or document a feature-available alternative (e.g. supported schedule) **without pretending they are equivalent**. Write one synthetic file `batch_001.csv`, observe triggered run, then a second distinct file.
- **Prove:** all intended **distinct file contents** represented once logically (trigger may batch several files or fire more than once), recorded in `j04_ingestion_audit`, with timestamp and run ID. Negative: replay the same file and show deduplication/idempotency rather than duplicate business rows.
- **Hands-on check:** Land files in the watched Volume path, observe actual trigger runs, then replay a source file and prove your output has no duplicate business keys. **Cleanup:** **disable trigger first**, then delete J04 job/folder if desired.


### Hands-on execution playbook for J04

Use universal preflight. **Create notebook `j04_ingest`** and keep `max_concurrent_runs=1`:

```python
import os
from pyspark.sql import functions as F
from delta.tables import DeltaTable
from uuid import uuid4
folder=f"{VOL}/J04/incoming"
dbutils.widgets.text("run_id", "")  # optionally bind to {{job.run_id}} in Notebook task parameters
run_id=dbutils.widgets.get("run_id") or f"manual-{uuid4().hex}"
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.j04_events (event_id STRING, amount INT) USING DELTA")
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.j04_ingestion_audit (attempt_ts TIMESTAMP, run_id STRING, input_count BIGINT) USING DELTA")
incoming=(spark.read.option("header",True).schema("event_id STRING,amount INT")
          .csv(f"{folder}/*.csv"))
assert incoming.where("event_id IS NULL OR amount IS NULL").count() == 0
# Do not MERGE ambiguous conflicting duplicates in a single batch.
assert incoming.groupBy("event_id").agg(F.countDistinct("amount").alias("k")).where("k>1").count() == 0
clean=incoming.dropDuplicates(["event_id", "amount"]).dropDuplicates(["event_id"])
DeltaTable.forName(spark,f"{NS}.j04_events").alias("t").merge(
    clean.alias("s"),"t.event_id=s.event_id").whenNotMatchedInsertAll().execute()
spark.createDataFrame([(run_id,incoming.count())],"run_id STRING,input_count BIGINT") \
 .withColumn("attempt_ts", F.current_timestamp()) \
 .select("attempt_ts","run_id","input_count").write.mode("append").insertInto(f"{NS}.j04_ingestion_audit")
print("J04 durable unique events:", spark.table(f"{NS}.j04_events").count())
```

1. Seed **only J04** file `batch_001.csv` inside `/Volumes/.../lab_files/J04/incoming/` using this notebook cell, **outside** the triggered ingestion task:

```python
import os
folder=f"{VOL}/J04/incoming"
os.makedirs(folder,exist_ok=True)
with open(f"{folder}/batch_001.csv","w",encoding="utf-8") as f:
    f.write("event_id,amount\na,10\nb,20\n")
# After the first observed run, create batch_002.csv with event c/30;
# after the second observed run, create batch_replay.csv with a/10 and b/20.
```

   Create `dbx_j04_file_trigger` pointing at **exactly the J04 landing folder** if file-arrival trigger is supported, authorized and enabled. Never point at shared V root. In the notebook task parameters, optionally map `run_id` to the supported Databricks dynamic reference `{{job.run_id}}`; confirm actual reference support for your task type, and record the run page ID even if parameter substitution is unavailable.
2. Observe at least one run (trigger latency is not fixed). Create distinct `batch_002.csv` with `c,30` and observe processed output. Use a separate seeding cell:

```python
with open(f"{folder}/batch_002.csv","w",encoding="utf-8") as f:
    f.write("event_id,amount\nc,30\n")
```

   **Check `j04_events`: 3 unique IDs, total 60.** Audit attempt rows can exceed file count or have different per-attempt counts.
3. **Replay** same logical IDs `a,b` in a new `batch_replay.csv` with text `event_id,amount\na,10\nb,20\n` using the same `with open` write pattern; observe another execution or manually re-run if the platform does not emit another trigger. **Check `j04_events` remains count 3 / total 60**. Do not assert exactly one run per file.
4. **Fail:** seed a J04-only file with two rows carrying the same `event_id` but different amounts; the notebook's conflict assertion should fail before Merge. Remove only conflict file after recording, then run green.
5. **Pass:** real file-arrival execution(s) and correct state, replay and conflict test, run IDs, ingress timing, trigger disabled on completion. **If the feature is unavailable:** a scheduled/manual ingest proves only the fallback, **not** a completed file-trigger ticket (`PARTIAL`/`BLOCKED`).

## J05 — Reproduce failure, inspect run logs and repair safely
- **Access/time:** Job editing, 60–90 min.
- **Fixture & steps:** Create job `dbx_j05_failure` whose notebook deliberately fails for `simulate_failure=true` (a controlled exception) and succeeds otherwise. Run a failed case; inspect task details/logs, notification settings and retry policy; perform a **repair run only if** the UI/API actually supports correcting the failed task under its original run context; otherwise create a **new** successful run with corrected configuration and label it a *rerun*, not a repair.
- **Prove:** one documented failed run and one successful corrected run, exact root cause, alert path and retry decision; no unauthorized notification recipients.
- **Hands-on check:** Create a deterministic failure, capture the stack trace/status, repair the input/config and successfully rerun; compare run histories. **Cleanup:** Turn off schedule/notifications and delete J05 job if desired.


### Hands-on execution playbook for J05

**Create `j05_failure` notebook:**

```python
# Databricks notebook source
dbutils.widgets.text("simulate_failure", "true")
flag=dbutils.widgets.get("simulate_failure").strip().lower()
assert flag in ("true","false"), "Expected true/false"
if flag == "true":
    raise RuntimeError("J05 deliberate transient-looking test error: fix flag; retry will not help")
assert spark.range(5).count() == 5
print("J05 repaired or rerun success=5")
```

1. Create job `dbx_j05_failure` with a single notebook task, no recurrence. Run with `simulate_failure=true`; capture task error message, status, run ID and whether any configured retry fires.
2. Decide **no automatic retry** for this deterministic validation error (a retry with unchanged input cannot succeed). Set flag `false` via a supported repair-run parameter override **only when the repair action actually supports it**. Otherwise create a **new run** with `false`. Save label `repair` vs `fresh rerun` accurately.
3. **Pass:** one observed failed attempt, one observed success printing 5, root cause and changed parameter, task graph/log evidence, documented alert routing for an authorized address (or note no alert configured). Disable schedule if any.

## J06 — Make a production-style job safe to re-run
- **Access/time:** Job and Delta privileges, 70–100 min.
- **Fixture & steps:** Job `dbx_j06_retry_safe` creates identical four-order batch `(1..4)` and merges by `order_id` into `j06_orders`. Run twice with same `batch_id`, then once with a corrected value for id=3. Persist run ID and input checksum to `j06_audit` without duplicating orders.
- **Prove:** orders table stays **4** records after all runs, corrected row takes effect, audit distinguishes attempts from business events. Negative: show why pure append would produce **8** rows after second run.
- **Hands-on check:** Execute repeated job runs on the same fixture and show the target count/checksum remains stable; test the configured concurrency limit where permitted. **Cleanup:** Disable any schedules; drop only J06 resources if desired.


### Hands-on execution playbook for J06

**Job notebook (include preflight, `max_concurrent_runs=1`):**

```python
from uuid import uuid4
from pyspark.sql import functions as F
from delta.tables import DeltaTable
dbutils.widgets.text("third_order_qty", "1")
q=int(dbutils.widgets.get("third_order_qty"))
assert q in (1,2), "Allowed test correction values: 1 or 2"
batch=[(1,1,10),(2,1,20),(3,q,7),(4,1,8)]
source=spark.createDataFrame(batch,"order_id INT,qty INT,unit_price INT")
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.j06_orders (order_id INT,qty INT,unit_price INT) USING DELTA")
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.j06_audit (attempt_id STRING, qty3 INT) USING DELTA")
DeltaTable.forName(spark,f"{NS}.j06_orders").alias("t").merge(
 source.alias("s"),"t.order_id=s.order_id") \
 .whenMatchedUpdateAll().whenNotMatchedInsertAll().execute()
audit=spark.createDataFrame([(uuid4().hex,q)],"attempt_id STRING, qty3 INT")
audit.write.mode("append").insertInto(f"{NS}.j06_audit")
print("J06 logical rows:",spark.table(f"{NS}.j06_orders").count())
```

1. Run with qty3=1 twice, then qty3=2 once. Verify table: always 4 rows, order 3 changes `(1,7)` to `(2,7)`; total amount evolves **45 → 45 → 52**. Audit holds 3 attempts and 3 distinct attempt IDs.
2. **Fail probe (read-only mathematical illustration):** an append-on-retry would store 8 business rows after a replay; never actually append to the trusted output table for this test.
3. **Pass:** 4/45, 4/45, 4/52, audit count 3 and concurrency guard recorded; code and job name scoped J06. Job's task execution/retry policy should be examined separately from Delta MERGE idempotence. Disable all owned recurrences.

---

# Track E — Policies, access control, governance and security (6 tickets)

## P01 — Grant then revoke object privileges using a test principal [SECURITY / CONDITIONAL]
- **Access/time:** Managed test identity and grants, 60–90 min.
- **Fixture & steps:** Create `p01_orders` with two fake records. As authorized owner/admin, grant necessary parent USE + `SELECT` only to a consenting dedicated test principal; confirm SELECT succeeds but `MODIFY`/write is denied; revoke SELECT and verify it is denied again.
- **Prove:** before/after privileges and actual allowed/denied evidence, without affecting anyone else's rights. Negative: verify namespace USE does **not** automatically authorize SELECT.
- **Hands-on check:** Capture access denial for an approved test principal, apply a minimal grant, verify success, revoke and verify denial again. **Cleanup:** Revoke only P01 grants, remove P01 table.


### Hands-on execution playbook for P01

1. Under `C.S`, using SQL editor as authorized owner:

```sql
CREATE OR REPLACE TABLE p01_orders (id INT,amount INT) USING DELTA;
INSERT INTO p01_orders VALUES (1,10),(2,20);
-- Grant only after reading existing inherited rights; replace principal safely:
GRANT USE CATALOG ON CATALOG dbx_lab_catalog TO `<test_principal>`;
GRANT USE SCHEMA ON SCHEMA dbx_lab_catalog.dbx_learning TO `<test_principal>`;
GRANT SELECT ON TABLE dbx_lab_catalog.dbx_learning.p01_orders TO `<test_principal>`;
SHOW GRANTS ON TABLE dbx_lab_catalog.dbx_learning.p01_orders;
```

2. **As the authorized test principal** (not as owner), `SELECT SUM(amount)` must return **30**. Attempt `UPDATE ... SET amount=0` on this test table: must be denied for insufficient table write privileges, unless inherited/owner grants make the principal unsuitable—in that case change the test principal, not the governance system.
3. Revoke **only the P01-specific** SELECT grant; check SELECT is denied. Carefully revert only parent USE privileges which were newly assigned for this experiment and are not needed for anything else. Preserve pre-existing grants.
4. **Pass:** observed allow, deny MODIFY, deny SELECT after revoke, observed identity and full permission provenance; table original sum remains 30. **Block:** no separate test identity or privilege-management rights.

## P02 — Protect a sensitive column and rows [SECURITY / CONDITIONAL]
- **Access/time:** Mask/filter features and owner rights if enabled, 70–110 min.
- **Fixture & steps:** Create `p02_people(customer_id,region,email)` with **fake** emails for ON/QC; build a secure view or supported row filter/column mask so a restricted test principal sees only allowed region and masked email. Test with an approved second identity; clearly distinguish **view simulation** from native UC row-filter/column-mask policy.
- **Prove:** privileged and restricted result sets differ as designed; restricted identity cannot query underlying source table directly. Negative: test direct table SELECT is denied; do not simulate security solely with a WHERE clause run as owner.
- **Hands-on check:** Query the same sensitive fixture under two approved identities/roles and save visibly different row/column results, without displaying secrets. **Cleanup:** Remove only P02 grants and objects.


### Hands-on execution playbook for P02

**Synthetic fixture**:

```sql
CREATE OR REPLACE TABLE p02_people (customer_id INT,region STRING,email STRING) USING DELTA;
INSERT INTO p02_people VALUES
(1,'ON','on1@example.invalid'),(2,'ON','on2@example.invalid'),(3,'QC','qc1@example.invalid');
```

1. Obtain **approved** `test_restricted` and `test_privileged` identities (or suitable groups); check inherited table access and which UC row-filter/column-mask or dynamic-view features are enabled. Do not treat running a WHERE filter as a security control.
2. Option A: create a governed **dynamic view** as an authorized owner, permit restricted users to query **the view only** and ensure they cannot query raw `p02_people`. Adapt approved account-group membership to your tenant. Example (placeholders must be replaced before executing):

```sql
CREATE OR REPLACE VIEW dbx_lab_catalog.dbx_learning.p02_visible AS
SELECT customer_id, region,
 CASE WHEN is_account_group_member('<privileged_test_group>')
      THEN email ELSE 'hidden@example.invalid' END AS email
FROM dbx_lab_catalog.dbx_learning.p02_people
WHERE region='ON' OR is_account_group_member('<privileged_test_group>');
GRANT SELECT ON VIEW dbx_lab_catalog.dbx_learning.p02_visible
TO `<approved_restricted_principal>`;
-- Ensure test principal has parent USE rights, but not SELECT on raw p02_people.
```

   Confirm the privileged principal belongs to the configured test group and the restricted principal does not. Verify caller-sensitive policy expressions evaluate as intended in the deployed view; parent grants, inherited access and owner semantics must be inspected rather than assumed.
3. Option B: if owner rights and UC support allow, attach supported **row filter and column mask functions** to P02 table, with an actual second principal. Do not confuse it with a secure view; keep the exact `CREATE FUNCTION`, `ALTER TABLE ... SET ROW FILTER`, `ALTER COLUMN ... SET MASK`, and cleanup syntax from current Microsoft Learn documentation in evidence.
4. **Expected restricted output:** 2 ON rows, email masked for both, zero QC rows. **Privileged output:** all 3 rows, original fake emails. **Required failure:** restricted user tries `SELECT * FROM p02_people` and is denied (view option), or sees only policy-permitted results (native UC policy option). Check also direct column selection cannot bypass rules.
5. **Pass:** real divergent results from separately authenticated principals plus direct-table bypass test, documented ownership and cleanup. If only one identity exists, a demonstration of view SQL is `PARTIAL`, not proof of access control.

## P03 — Inspect and enforce a compute policy [ADMIN / CONDITIONAL]
- **Access/time:** View policy (basic); create policy only if admin-authorized, 60–100 min.
- **Fixture & steps:** Inspect one allowed compute policy and document at least 5 constraints (node families, max workers, runtime, autotermination, tags). If permitted, create `dbx_p03_learning_policy` restricting size/auto-stop and attempt a compliant versus noncompliant compute definition on the **same sandbox**.
- **Prove:** policy configuration and confirmed allowed/blocked settings. Negative: a forbidden cluster config is rejected *before* start; never run an unnecessarily costly test cluster.
- **Hands-on check:** Submit one compliant and one deliberately noncompliant compute configuration against a permitted test policy; capture accepted/rejected validation without starting costly compute. **Cleanup:** Terminate test compute; remove only ticket-owned policy with approval.


### Hands-on execution playbook for P03

1. In Compute → Policies, view an assigned policy and transcribe into `tickets/P03/policy_matrix.md` its **actual** constraints (node type, max workers, runtime, autotermination, tags, other controls). Note which dimensions are hidden or missing; policy permissions differ from UC data privileges.
2. If authorized as policy admin, create **new** `dbx_p03_learning_policy` scoped only to a test group, with a fixed max/auto-stop value. For example, validate supported JSON fields in your workspace UI/API before submission; an illustrative constraint is:

```json
{
  "autotermination_minutes": { "type": "fixed", "value": 30 },
  "num_workers": { "type": "range", "minValue": 0, "maxValue": 1, "defaultValue": 0 }
}
```

3. Attempt to **configure** a compliant 0/1-worker choice and an out-of-policy worker count 10 (do **not** start an expensive cluster). Inspect validation for actual acceptance/denial. Where policy virtual attributes or serverless compute override fields, document the difference rather than manufacturing a rejection.
4. **Pass:** observed accepted and rejected settings, 5 grounded policy constraints, rationale for compute policy vs UC permissions and role needed to use policy. **Block:** if no policy-admin ability, inspecting alone is a useful partial but not full enforcement validation. Remove ticket policy only if it does not affect others.

## P04 — Compare interactive identity with job-run identity
- **Access/time:** Job permissions; service principal conditional, 65–95 min.
- **Fixture & steps:** Create job `dbx_p04_identity` and `p04_results` with only synthetic data. Record notebook interactive effective identity (only non-secret identity type) and job run-as identity from authorized run configuration. If approved test principal available, configure and rerun under it, checking exact access needed for table/volume.
- **Prove:** identity/access matrix and successful permitted run; controlled access denial if allowed. Negative: explicitly reject passing a PAT/key as a notebook parameter or committing it to repo.
- **Hands-on check:** Run the same identity probe interactively and as a Databricks Job; compare `current_user()` and run-as results; use a second approved identity where available. **Cleanup:** Disable/delete P04 job/test grants.


### Hands-on execution playbook for P04

**Notebook `p04_identity`:**

```python
from uuid import uuid4
interactive_user = spark.sql("SELECT current_user() AS user").first()[0]
print("P04 effective SQL principal:", interactive_user)
spark.sql(f"CREATE TABLE IF NOT EXISTS {NS}.p04_results (attempt_id STRING, principal STRING) USING DELTA")
record=spark.createDataFrame([(uuid4().hex,interactive_user)],"attempt_id STRING,principal STRING")
record.write.mode("append").insertInto(f"{NS}.p04_results")
```

1. Execute notebook **interactively**, record current_user and confirmation of 1 added audit row. Register *same notebook* as `dbx_p04_identity` and execute as a Job; record its run-as configuration, effective `current_user()` and run ID.
2. **Conditional**: with an approved service principal configured as `run_as`, repeat and prove the job continues only if that principal has schema/table privileges. If not authorized, document one-identity result and mark multi-identity objective `PARTIAL`.
3. **Fail probe:** inspect a denied attempt **only if** the test identity can safely be denied without changing shared object grants; otherwise review error scenarios and mark not tested. Never display PATs or secrets.
4. **Pass:** actual two execution contexts, correct effective identity and permission matrix, second-run identity difference when authorized; notebook stores only sanitized identity identifier in private evidence.

## P05 — Trace table lineage, tags and audit evidence
- **Access/time:** UC tables and any permitted lineage/system table visibility, 60–90 min.
- **Fixture & steps:** Create `p05_source` with 3 rows and `p05_summary` via a UC-resolved query (`CREATE TABLE AS SELECT category, COUNT(*) ...`). Inspect lineage, add a **non-sensitive** description/tag where authorized, and locate relevant permitted audit/system table record(s), if available.
- **Prove:** source→target lineage and tagged/annotated metadata; distinguish lineage from an audit event and from arbitrary comments. Negative: document lack of system table entitlement honestly rather than inventing audit proof.
- **Hands-on check:** Materialize a source-to-target table transformation, inspect its lineage view and tag/comment metadata where allowed; save observed evidence. **Cleanup:** Only P05 objects, or retain for inspection with inventory.


### Hands-on execution playbook for P05

```sql
CREATE OR REPLACE TABLE p05_source (id INT, category STRING) USING DELTA;
INSERT INTO p05_source VALUES (1,'A'),(2,'A'),(3,'B');
CREATE OR REPLACE TABLE p05_summary USING DELTA AS
SELECT category, COUNT(*) AS n FROM p05_source GROUP BY category;
SELECT * FROM p05_summary ORDER BY category; -- A:2, B:1
COMMENT ON TABLE p05_summary IS 'P05 synthetic category counts, owner-scope only';
-- If allowed under current UC tagging model:
-- ALTER TABLE p05_summary SET TAGS ('lab_ticket'='P05');
```

1. Open Catalog Explorer → the P05 target → **Lineage**. Record source `p05_source` to target `p05_summary` relationship and capture UI timestamp. If lineage isn't available, mark lineage requirement `BLOCKED` rather than inferring it from source SQL.
2. Capture the comment and approved *non-sensitive* tag when tagging is enabled. Where system audit/billing tables are available, locate one relevant event by a bounded time window and record **which source** produced it; do not equate lineage with access logs.
3. **Fail probe:** show that source SQL proves intended derivation but does not independently prove an *observed* lineage event; note any telemetry lag or missing permissions.
4. **Pass:** two results `A=2,B=1`, observed lineage or explicit access blocker, and distinction between tag, lineage and audit evidence.

## P06 — Conduct a mini access and policy review
- **Access/time:** Read-only + optional owner rights, 60–90 min.
- **Fixture & steps:** Create `p06_access_review.md` reviewing your one C/S/V, lab jobs, shared data, code repo, cluster policy and external resource permissions. Create a risk table (asset, principal, privilege, reason, expiry, revocation, evidence), flag excessive rights and draft an access remediation plan. Do **not** revoke others' access.
- **Prove:** at least 12 review entries and 3 concrete findings, each mapped to evidence/owner. Negative: identify an apparent privilege that is actually inherited or only at Azure level; avoid false conclusions.
- **Hands-on check:** Inspect 12 real sandbox access/resource settings, flag three directly observed risks or permission-visibility gaps, and verify any proposed fix is scoped safely. **Cleanup:** None.


### Hands-on execution playbook for P06

1. Copy this header to `tickets/P06/p06_review.csv`:

```csv
asset,principal,scope,privilege_or_setting,grant_source,actual_evidence,business_reason,expiry_or_review_date,risk,remediation_owner,action,status
```

2. Add **≥12 distinct** assets/relationships: C catalog, S schema, `lab_files`, reference table, own user, test principal (if any), owned jobs, job run-as, Git repo, CLI profile, permitted compute, compute policy, external credentials/location (if provisioned), pipeline, workspace folders, billing visibility. **Do not invent** a grant because you could not read it; use `UNKNOWN` explicitly.
3. Obtain read-only actual evidence (`SHOW GRANTS`, job-run page, policy description, repo collaborators or approved IAM view) and map **three real actionable findings or visibility gaps**, each with owner, priority, remediation and validation criteria.
4. **Fail probe:** identify one misleading observation such as `USE SCHEMA` incorrectly interpreted as table SELECT; correct it with object-level evidence. **Pass:** ≥12 real or clearly unverified entries and 3 evidence-grounded risks/gaps, no permission changes made.

---

# Track F — DevOps, scripts, versioning and deployment (6 tickets)

## D01 — Put a Databricks notebook/script under Git control
- **Access/time:** Private Git repo, 45–75 min.
- **Fixture & steps:** In **one shared learning repo**, create branch `lab/d01`, version `src/d01_transform.py` or notebook with deterministic transformation of three fake amounts to tax-adjusted values. Make two commits, inspect diff, open/merge PR if possible, and sync Git folder with workspace.
- **Prove:** two meaningful commits, diff, successful execution and reproducible checkout. Negative: show `.gitignore` excludes `.env`, tokens and temporary data.
- **Hands-on check:** Create and execute a tested script, make two Git commits, inspect their diff, and prove a dummy `.env` is ignored without storing secrets. **Cleanup:** Retain Git history; remove only temporary untracked resources.


### Hands-on execution playbook for D01

In your **single private** learning repository, create `src/d01_transform.py`:

```python
from decimal import Decimal

def apply_tax(amount, rate=Decimal("0.10")):
    return (Decimal(str(amount)) * (Decimal("1") + rate)).quantize(Decimal("0.01"))

if __name__ == "__main__":
    actual = [apply_tax(x) for x in (10,20,30)]
    assert actual == [Decimal("11.00"),Decimal("22.00"),Decimal("33.00")]
    print(actual)
```

1. In the one repo: `git checkout -b lab/d01`, `git add src/d01_transform.py`, `git commit -m "D01 add tax transform"`. Run `python src/d01_transform.py` locally or on approved Databricks notebook/script compute.
2. Make a **meaningful** second commit: add a pure unit test checking an extra fixture (`0 → 0.00`) and rounding behavior. Record both hashes and `git diff <first> <second>`; review and merge into the repo's lab branch using the approved workflow.
3. Add `.gitignore` entries for `.env`, `.databricks/`, `__pycache__/`, `*.pyc`, `.terraform/`, `*.tfstate*`, `*.tfvars` (when they might contain values), and `*.token`. Verify a deliberately local `.env` is ignored with `git check-ignore .env` and **never add credentials to it**.
4. Sync/reopen the same repo's Git folder in the same Databricks workspace. **Pass:** two commits, green deterministic script/test, diff/review evidence, ignored local env and clear explanation that Git history does **not** snapshot table data.

## D02 — Authenticate Databricks CLI and perform read-only discovery
- **Access/time:** CLI install and approved auth, 45–70 min.
- **Fixture & steps:** Install allowed current Databricks CLI in user-controlled dev terminal (or approved environment); authenticate with supported non-secret-pasting flow. List workspaces/jobs/clusters available through your permissions, capture command version and safe exit codes; script a read-only inventory `scripts/d02_inventory.sh`.
- **Prove:** CLI version plus two real successful list/get operations, redacted inventory and a rerunnable script. Negative: run a deliberately invalid resource lookup and map error/exit code; ensure logs reveal no credentials.
- **Hands-on check:** Authenticate with an approved Databricks CLI profile and run read-only workspace/job discovery. Capture a successful command and an intentional safe missing-object error. **Cleanup:** Revoke only temporary tokens if generated; keep safe config.


### Hands-on execution playbook for D02

1. Install approved current Databricks CLI in **your permitted development terminal**, record `databricks version` (or `databricks --version` if your CLI uses it). Authenticate using organizationally approved OAuth/device/interactive flow; use `databricks auth login --host <approved_workspace_url>` where supported. No PAT pasted into script, no token committed.
2. Save `scripts/d02_inventory.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
databricks version
# Set DATABRICKS_CONFIG_PROFILE to a previously authenticated, approved profile.
databricks jobs list --output json > tickets/D02/jobs.redact-before-sharing.json
databricks clusters list --output json > tickets/D02/clusters.redact-before-sharing.json
printf 'Read-only job + cluster inventory complete. Review output for identifiers.\n'
```

3. Run twice: outputs should represent same *types* of resources but need not be byte-identical if the workspace changed. Sanitize names and IDs before forwarding anything to AI or sharing; evidence stays private. Capture one allowed CLI `jobs get <real_owned_job_id>` or comparable read-only lookup for detailed object inspection.
4. **Negative:** `databricks jobs get 0` (a nonexistent ID in ordinary workspaces) should give a nonzero exit/error; if `0` is not rejected in your workspace, use another guaranteed invalid value from current API schema. Report actual HTTP/error category. Do not run create/delete commands.
5. **Pass:** CLI version, two real read/list calls, a rerunnable script, a failure case and explanation that CLI authentication ≠ UC object privileges. If CLI commands/flags differ in your release, consult `databricks <group> <command> --help` and record the compatible invocation.

## D03 — Create and validate a Declarative Automation Bundle
- **Access/time:** CLI + repo + workspace, 60–95 min.
- **Fixture & steps:** In repo `bundles/d03/`, initialize a small **Declarative Automation Bundle** using the current CLI scaffold (name may appear as Databricks Asset Bundle in older tools). Define a notebook task in target `lab` referencing `src/d03_hello.py` with a ticket-specific resource name `dbx_d03_hello`; make root config explicit and non-secret.
- **Prove:** `databricks bundle validate -t lab` succeeds; capture resolved resource summary and current CLI version. Negative: temporarily set an **invalid resource field type or unsupported YAML key** confirmed against the current bundle schema, show `bundle validate` failing, then fix it. A missing notebook file may not be detected during YAML validation; test missing-source behavior separately if desired.
- **Hands-on check:** Create a real `databricks.yml`, run `bundle validate`, deliberately introduce an invalid key/value, observe validation fail, fix and obtain a passing validation. **Cleanup:** No deployment required; keep repo content.


### Hands-on execution playbook for D03

1. In the **single** repo create `bundles/d03/src/hello.py` and `bundles/d03/databricks.yml`. The notebook source must be recognized as a Databricks source notebook:

```python
# Databricks notebook source
n = spark.range(4).count()
assert n == 4
print("D03 hello:", n)
```

**`bundles/d03/databricks.yml`**:

```yaml
bundle:
  name: dbx_d03_lab
variables:
  cluster_id:
    description: Allowed pre-existing single-sandbox compute cluster ID
resources:
  jobs:
    d03_hello:
      name: dbx_d03_hello_${bundle.target}
      max_concurrent_runs: 1
      tasks:
        - task_key: hello
          existing_cluster_id: ${var.cluster_id}
          notebook_task:
            notebook_path: ./src/hello.py
targets:
  lab:
    default: true
    mode: development
    variables:
      cluster_id: "REPLACE_WITH_APPROVED_CLUSTER_ID"
```

2. Replace only non-secret `cluster_id` with an approved existing cluster ID that the **job can use** (or select a permitted job-compute definition after checking the bundle schema). Run from bundle root: `databricks bundle validate -t lab`. Record CLI version, resolved resource name and validation output. A successful validation **does not execute a task**, prove authorization to deploy, or test pipeline data.
3. **Deterministic negative:** in a throwaway copy, change `max_concurrent_runs: 1` to `max_concurrent_runs: invalid-string`; validate and capture schema-type error. Restore integer 1; validate green. If your CLI cannot detect this exact error, choose a field/type documented by installed CLI and record what actually failed.
4. **Pass:** green validated bundle **and** red/gold negative/fix proof, copied source notebook, no job deployment yet. `D04` is the separate actual deployment ticket.

## D04 — Deploy, run, update and destroy a bundle-managed job
- **Access/time:** CLI `bundle deploy`, job creation, 75–120 min.
- **Fixture & steps:** Make self-contained `bundles/d04` defining `dbx_d04_job` in the *same* workspace; code generates four fake rows to `d04_results` or prints `4`. Validate → deploy `-t lab` → run → change parameter in Git → redeploy → run. Track run IDs and resources by namespace.
- **Prove:** first output **4**, change the documented task parameter `record_count` from **4 to 6**, and prove output **6** without modifying source logic, deployment logs and evidence of managed resource ownership. Negative: intentionally fail validation on a local bad config before deploy; **never** use a destroy command without reviewing target resources.
- **Hands-on check:** Deploy a ticket-owned bundle Job, run it, change its configuration, redeploy, inspect resulting state and then perform an authorized ticket-only cleanup. **Cleanup:** `bundle destroy` only for D04-owned target if reviewed; do not destroy shared workspace objects.


### Hands-on execution playbook for D04

Create **independent** bundle `bundles/d04` (do not rely on D03 outputs), with the **complete** configuration below. Choose an existing approved cluster ID or adapt to permitted job compute using the current bundle schema.

```yaml
bundle:
  name: dbx_d04_lab
variables:
  cluster_id:
    description: Approved pre-existing same-sandbox job-capable cluster
targets:
  lab:
    default: true
    mode: development
    variables:
      cluster_id: "REPLACE_WITH_APPROVED_CLUSTER_ID"
resources:
  jobs:
    d04_job:
      name: dbx_d04_job_${bundle.target}
      max_concurrent_runs: 1
      tasks:
        - task_key: count_records
          existing_cluster_id: ${var.cluster_id}
          notebook_task:
            notebook_path: ./src/d04_count.py
            base_parameters:
              record_count: "4"
```

**`src/d04_count.py`**:

```python
# Databricks notebook source
dbutils.widgets.text("record_count", "4")
n = int(dbutils.widgets.get("record_count"))
assert 1 <= n <= 20
actual = spark.range(n).count()
assert actual == n
print("D04 output:", actual)
```

1. Use **approved compute** in the same workspace (`existing_cluster_id`/allowed job compute as in D03). At bundle root: `databricks bundle validate -t lab` → `databricks bundle deploy -t lab` → `databricks bundle run d04_job -t lab`. Record resulting job ID, run ID and output `D04 output: 4`.
2. Edit **only** `base_parameters.record_count: "6"` in versioned YAML, commit the change, validate → deploy → run again. Confirm `D04 output: 6`, a distinct run ID, and the same owned resource binding where the platform supports it. Do **not** edit the notebook source logic to fake the change.
3. **Fail:** modify numeric `max_concurrent_runs` to a string in a disposable copy, see validation fail **before** deployment; restore. Audit the resource inventory and preview the target and owner before any `databricks bundle destroy -t lab`.
4. **Pass:** two real runs 4/6, deployment log/version evidence, reversible change, reviewed cleanup solely of `dbx_d04_lab` target; a local YAML file without actual deployment is not a pass.

## D05 — Implement CI checks before any deployment
- **Access/time:** Git CI runner optional, 65–105 min.
- **Fixture & steps:** In repo create `tests/test_d05_transform.py` for a pure function that doubles a list of synthetic quantities; add static lint/format, unit tests and bundle validation checks. Use available GitHub Actions/Azure DevOps pipeline, or run the **same commands locally** if hosted CI is unavailable (mark hosted verification conditional).
- **Prove:** green test and green validation; introduce deliberately wrong expected value and capture **red** failing gate; fix and return green. Negative: assert CI must stop before deployment when tests fail.
- **Hands-on check:** Run code/schema/config CI checks on a valid commit, introduce a safe failing test, capture failed status, fix and rerun to green. **Cleanup:** Keep CI config/history.


### Hands-on execution playbook for D05

**Source `src/d05_math.py`:**

```python
def double_quantities(values):
    if any(not isinstance(v,int) or v < 0 for v in values):
        raise ValueError("quantities must be nonnegative integers")
    return [2*v for v in values]
```

**Test `tests/test_d05_math.py`:**

```python
import pytest
from src.d05_math import double_quantities

def test_normal():
    assert double_quantities([1,2,3]) == [2,4,6]

def test_empty():
    assert double_quantities([]) == []

def test_invalid():
    with pytest.raises(ValueError):
        double_quantities([1,-1])
```

1. From one repo root, on a permitted Python environment: `python -m pytest -q tests/test_d05_math.py`. Ensure `src/__init__.py` exists (can be empty); use normal `PYTHONPATH`/repo-root context. Add a syntax check `python -m compileall -q src` and CLI bundle validate on your self-contained D05 test bundle (can use a D05-only bundle). Do not reuse/destroy D03/D04 job resources.
2. In your CI tool (Azure DevOps/GitHub Actions as authorized), configure gates in order **syntax → unit tests → bundle validate → manual deployment approval → deployment**. The deployment step is optional for this *testing* ticket; D06 owns promotion.
3. **Red probe:** change expected list in `test_normal` to `[2,4,99]`; assert that local CI or hosted CI **fails**. Restore `[2,4,6]`; assert green and capture both executions with commit IDs.
4. **Pass:** local red→green **and** actual hosted CI if available; otherwise mark hosted aspect conditional. Keep CI logs free of tokens and disable write permissions where unnecessary. Prove a valid YAML bundle alone is insufficient by also running one actual business-output assertion.

## D06 — Model release promotion and approvals in one sandbox [CI / CONDITIONAL]
- **Access/time:** Git CI + deployment rights, 90–140 min.
- **Fixture & steps:** Define `lab_dev` and `lab_verify` as **logically isolated bundle targets within the ONE workspace**, with distinct job prefixes, output tables and tracked targets; **do not claim these equal separate production workspaces**. Deploy/test dev target, require an explicit manual approval checkpoint, promote same commit to verify target using approved Azure DevOps or equivalent pipeline.
- **Prove:** same commit hash, distinct target resource names/paths, approval and test evidence; denied promotion on failing gate. Negative: try configuration pointing both targets at the same output table in validation/dry-run; reject for collision.
- **Hands-on check:** Apply the permitted two-target configuration in the same sandbox, exercise the required review gate and compare actual target-specific bundle resources. **Cleanup:** Remove only D06 bundle targets after reviewed destroy; retain repo.


### Hands-on execution playbook for D06

**This is an intentionally conditional hosted CI/CD lab**. It must not create a second workspace. Choose 2 target names `lab_dev` and `lab_verify`, same approved workspace host, **different job names and different output table namespaces within the same C.S**. Example target structure:

```yaml
bundle:
  name: dbx_d06_promotion
targets:
  lab_dev:
    default: true
    mode: development
    variables:
      result_table: "d06_dev_result"
  lab_verify:
    mode: development
    variables:
      result_table: "d06_verify_result"
variables:
  result_table:
    description: Different table name per target
  cluster_id:
    description: Existing approved same-sandbox cluster ID
    default: REPLACE_WITH_APPROVED_CLUSTER_ID
resources:
  jobs:
    promote:
      name: dbx_d06_${bundle.target}
      max_concurrent_runs: 1
      tasks:
        - task_key: validate_target
          existing_cluster_id: ${var.cluster_id}
          notebook_task:
            notebook_path: ./src/validate_target.py
            base_parameters:
              result_table: ${var.result_table}
```

1. Replace `REPLACE_WITH_APPROVED_CLUSTER_ID` with your permitted existing cluster ID (a non-secret configuration value) and create `bundles/d06/src/validate_target.py` with this source; include universal preflight:

```python
# Databricks notebook source
dbutils.widgets.text("result_table", "")
name=dbutils.widgets.get("result_table")
assert name in {"d06_dev_result", "d06_verify_result"},"Refusing table-name collision"
source=spark.range(3).selectExpr("CAST(id AS INT) AS id")
source.write.format("delta").mode("overwrite").saveAsTable(f"{NS}.{name}")
assert spark.table(f"{NS}.{name}").count()==3
```

   Use one branch/commit with independent target variable values. **A script-based test comparing both parsed YAML target names is mandatory**, because `bundle validate` will not necessarily detect semantic object collisions. Run both target validations before any deploy.
2. In approved hosted CI: run tests and validate both targets; deploy/run **dev**; enforce an actual **manual approval/environment gate**; deploy/run **verify** from the **identical commit SHA**. Record approval by an authorized reviewer without exposing user personal details.
3. **Fail probe:** push a D06-only change violating test assertions or pointing both targets to the same output name; require the validation/test step to stop deployment. `bundle validate` alone may **not** detect logical name collisions, so add an explicit CI script comparing target values.
4. **Pass:** actual hosted CI approval, same commit, two distinct job/output resources in **one workspace**, blocked negative release and reviewed target-specific cleanup. **Block:** no hosted CI/approval capability. Two logical targets do **not** prove real dev/prod isolation.

---

# Track G — Infrastructure, configuration, Lakeflow and cost (4 tickets)

## I01 — Build a compute decision and configuration record
- **Access/time:** Workspace compute inspection, 60–85 min.
- **Fixture & steps:** For three synthetic workload *scenarios* (interactive 100-row exploration, hourly 10k-row ETL, ad hoc BI query) document workload needs and select *allowed* compute type/settings. Configure only a small permitted instance or existing compute; log start/stop and runtime parameters in `config/i01_compute_decisions.md`.
- **Prove:** three justified decisions, actual available runtime/policy observed, shutdown confirmed. Negative: demonstrate using policy preview/validation (not a costly startup) why an overlarge or prohibited config is unacceptable.
- **Hands-on check:** Inspect two permitted compute choices and their idle/scale settings; record observed limits and auto-termination behavior without launching excessive resources. **Cleanup:** Shut down only I01-created compute.


### Hands-on execution playbook for I01

1. Create `tickets/I01/compute_decisions.md` table with workload: (A) interactive **100-row** exploration, (B) hourly **10,000-row** ETL, (C) ad-hoc BI query. Columns: workload, compute choice, data access mode, allowed policy, min/max workers, runtime, auto-stop, likely cost factors, reason rejected alternatives.
2. In the one workspace, inspect allowed SQL warehouse, all-purpose compute, jobs compute/serverless capability **without** creating any unauthorized resource. For one permitted option, run `SELECT COUNT(*) FROM range(100);` or `spark.range(100).count()` and confirm **100**; record observed config, runtime, warehouse size and start-to-stop status.
3. Stop/auto-stop the owned compute; capture terminal/terminated or equivalent idle status and any preexisting shared compute you **did not** stop.
4. **Negative:** in policy preview/configuration (never by purchasing an oversized cluster), demonstrate why a 10-worker node choice or unapproved access mode would be blocked or unsuitable. Do not invent a policy violation if no policy restricts it.
5. **Pass:** 3 justified scenario choices, 1 actual successful 100-row run on permitted compute, observed config and shutdown, cost controls and one genuine constraint/alternative analysis.

## I02 — Understand and inspect Terraform infrastructure changes [AZURE ADMIN / CONDITIONAL]
- **Access/time:** Terraform + permitted Azure test resources, 90–150 min.
- **Fixture & steps:** In shared repo `infra/i02/`, define at least one **ticket-owned** low-risk Azure or Databricks resource scoped to the existing single sandbox/RG (e.g. dedicated tag/named test job or a small ADLS path-associated resource where provider supports it). Run `fmt`, `validate`, `plan`; inspect `+ / ~ / -`. Only `apply` with explicit rights/cost review, never against existing shared workspace/catalog/metastore.
- **Prove:** reviewed, sanitized plan, state boundary and rollback/destroy plan; when authorized, verify resource matches plan. Negative: change desired value in plan and show drift/difference **without** force-applying it.
- **Hands-on check:** Run `terraform fmt`, `init`, `validate` and two different `plan` outputs; only if authorized, apply/read back/destroy a ticket-owned resource. **Cleanup:** Only I02-owned resources after approval; preserve safe example code.


### Hands-on execution playbook for I02

Terraform illustrates **state** and **dependency reconciliation**, not a magic exemption from cloud RBAC. Create `infra/i02/` in the same repo with non-secret Terraform. A guaranteed *no-cloud* primer is:

```hcl
terraform {
  required_version = ">= 1.5.0"
}
variable "ticket_label" {
  type    = string
  default = "I02"
}
resource "terraform_data" "ticket_marker" {
  input = { label = var.ticket_label }
}
output "marker" {
  value = terraform_data.ticket_marker.output
}
```

1. Run `terraform fmt -check` (after `terraform fmt`), `terraform init`, `terraform validate`, `terraform plan -out=i02.tfplan`; read before performing any apply. **Do not add `.tfplan` or state files to Git**; Terraform state can contain confidential metadata.
2. **Plan-only probe:** change `ticket_label` to `I02-REV2`, run `terraform plan`, inspect proposed change, then restore. State whether this demonstrates input drift, desired-state change, or remote infrastructure drift—these are not synonymous.
3. To complete the **cloud IaC** objective, and **only with explicit Azure permissions**, add one ticket-owned low-risk Azure resource in the existing approved learning resource group/storage account (e.g. a separate private storage container `dbx-i02-training` if organizational naming and storage-account policy permit). Use the installed **AzureRM provider documentation for its version**; reference approved account ID via a locally protected variable/identity, *never hardcode credentials*. Review plan → authorized apply → read back cloud resource → reviewed destroy of **only the I02-owned resource**. Protect state using the approved backend or an encrypted private local state, not public Git.
4. **Pass:** no-cloud Terraform format/validate/plan checks; **plus**, for complete I02 status, one real approved create/verify/retire cloud change with plan/state evidence. If cloud changes are prohibited, `PARTIAL/BLOCKED` with working no-cloud IaC learning. Do not manage/modify existing workspace, catalog, RG, or metastore under training state.

## I03 — Implement a two-stage Lakeflow Declarative Pipeline [FEATURE / CONDITIONAL]
- **Access/time:** Pipeline creation + compatible compute/service, 90–130 min.
- **Fixture & steps:** Seed `V/I03/orders.csv` with `(1,2,5),(2,1,8),(3,-1,4)` under `order_id,qty,price`. Define pipeline **`dbx_i03_pipeline`** in the one workspace whose source reads *only I03 fixture*, Bronze preserves 3 raw rows, and Silver enforces `qty>0` under an explicit drop/quarantine/fail rule. Prefer actual supported Lakeflow Declarative Pipeline syntax/expectation semantics for installed version, not an obsolete copied API.
- **Prove:** Bronze **3**, Silver **2**, invalid order id=3 traceable through **a concrete expectation-violation metric or a separate I03 quarantine output** (select which method *before* running); one successful refresh and a recorded failure/expectation decision. Negative: deliberately submit invalid row and verify chosen expectation behavior.
- **Hands-on check:** Run a real declarative pipeline refresh against `I03/orders.csv`, verify Bronze=3, Silver=2, rejects=1, then add a bad row and observe the configured rule. **Cleanup:** Stop/remove only I03 pipeline and I03 tables/folder if desired; inspect charges.


### Hands-on execution playbook for I03

**Prerequisite:** workspace supports Lakeflow Declarative Pipelines and permits creating/running them in the **same C.S**. Seed `I03/orders.csv` inside the shared volume:

```csv
order_id,qty,price
1,2,5
2,1,8
3,-1,4
```

Create **pipeline-only Python source** `src/i03_pipeline.py`. It is interpreted by the Lakeflow Pipelines service, **not** launched as a normal side-effecting notebook job:

```python
from pyspark import pipelines as dp
from pyspark.sql import functions as F

# In the real file, substitute your S00 catalog/schema/volume before deployment.
source_path = "/Volumes/dbx_lab_catalog/dbx_learning/lab_files/I03/orders.csv"

@dp.materialized_view(name="i03_bronze")
def i03_bronze():
    return spark.read.option("header",True) \
        .schema("order_id INT,qty INT,price INT").csv(source_path)

@dp.materialized_view(name="i03_rejected")
def i03_rejected():
    return spark.read.table("i03_bronze").filter("qty IS NULL OR qty <= 0")

@dp.materialized_view(name="i03_silver")
@dp.expect_or_drop("valid_qty", "qty IS NOT NULL AND qty > 0")
def i03_silver():
    return spark.read.table("i03_bronze")
```

1. In Jobs & Pipelines, create **one** `dbx_i03_pipeline` pointing to this source; choose **existing `C.S`** for target (do not auto-provision a new schema), select permitted serverless/compute mode, and disable schedules before run. Record source notebook path and owner.
2. Run/refresh once. Query `C.S.i03_bronze`, `C.S.i03_silver`, and `C.S.i03_rejected`: expected **3,2,1**, with rejected ID 3. Inspect event/quality metrics; metric emission/shape depends on pipeline type and version, so the dedicated rejected dataset is the deterministic reject proof.
3. **Fail:** seed a *second negative record* in I03 source in controlled test copy, refresh and confirm rejected count increases while Silver excludes that event; reset source and refresh back to **3/2/1**. Do not trigger paid compute indefinitely.
4. **Pass:** actual pipeline update successful, dataset graph and test outputs captured, invalid-case handling observed, no shared dataset touched; mark `BLOCKED` if pipeline entitlement missing. Do not put arbitrary side-effect operations inside pipeline dataset definitions.

## I04 — Inspect system usage and set a sandbox cost/operability baseline
- **Access/time:** Workspace job visibility; billing system tables conditional, 60–90 min.
- **Fixture & steps:** Run three I04-owned SQL queries (range(100), range(500), range(1000)) first, then inspect these runs plus compute usage/auto-stop settings; when access permits, query relevant Databricks system billing or job-run tables, filtering to own workspace/time interval and acknowledging lag. Produce `i04_cost_baseline.md` with compute SKU/DBU concepts, estimated running cost (never invent exact price), and a cost-alert escalation rule.
- **Prove:** source/time window for each observed metric, list of **all active recurring** lab resources (target zero when not testing), and three concrete cost-reduction decisions. Negative: compare the three observed runtimes and actual usage information, labeling unavailable or lagged billing values instead of extrapolating an unverified monthly invoice.
- **Hands-on check:** Run three ticket-owned count queries (100, 500, 1000), inspect actual duration/compute/run history and active schedules; record a practical cost-control action. **Cleanup:** Disable forgotten ticket schedules and idle resources only if owned.


### Hands-on execution playbook for I04

1. **Self-seed I04:** in your existing authorized SQL warehouse, run **three I04-owned queries** (`SELECT COUNT(*) FROM range(100)`, `...range(500)`, and `...range(1000)`) and verify counts **100, 500, 1000**. They use no tables or earlier tickets. Capture each query's UTC time, query/run ID, compute type and observed duration from Query History/Profile. A jobs-history lookup can be additional context but is not required to pass I04.
2. Make `tickets/I04/cost_baseline.md` with (a) workspace/region and cost boundary, (b) three **I04-owned** query records, (c) observed auto-termination/auto-stop settings, (d) active recurring jobs/pipelines count, (e) source of DBU/cloud cost estimates and their limitations. Query Profile records should identify duration and records read/output (or supported metrics). Never conflate Databricks DBU units with Azure VM/storage/network invoices.
3. If system tables are enabled and readable, query permitted `system.billing.usage` data filtered to your **workspace** and **bounded period**, recording ingestion lag. Example **shape**, subject to schema/permission checks:

```sql
SELECT usage_date, sku_name, SUM(usage_quantity) AS usage_units
FROM system.billing.usage
WHERE usage_date >= date_sub(current_date(), 14)
  AND workspace_id = '<your_approved_workspace_id>'
GROUP BY usage_date, sku_name
ORDER BY usage_date, sku_name;
-- Replace workspace_id placeholder with the actual permitted workspace ID; check column types and lag first.
```

4. **Fail probe:** compute a hypothetical one-run extrapolation and explicitly reject it as an exact monthly price. Use actual Azure pricing/budget service if you have authorized cost access. Record 3 grounded cost reductions such as turning off idle jobs/warehouses, limiting workers, avoiding unnecessary optimize operations.
5. **Pass:** cost report with provenance/lag, three grounded measures, a **verified no-unused-recurring-jobs** check, and disclosure of missing billing permission when applicable.

---

# Track H — Integrated demonstration (1 ticket)

## C01 — End-to-end production-style mock project in the same sandbox
- **Access/time:** 3–6 hours; use only permissions available in the ONE sandbox.
- **Independent fixture:** In **`/Volumes/C/S/lab_files/C01/incoming/`**, create these 12 mock events in CSV (`event_id,order_id,event_ts,seq,qty,unit_price,status`). Each event ID is unique; event times use UTC `2026-01-01T12:00:00Z` for `e001`–`e010` and `2026-01-01T12:01:00Z` for `e011`–`e012`. Use status `paid` for all except `e012` (`paid` with invalid negative quantity). Ten original orders are:
  `e001: (1,2,10)`, `e002: (2,1,15)`, `e003: (3,3,7)`, `e004: (4,1,8)`, `e005: (5,2,9)`, `e006: (6,1,11)`, `e007: (7,4,5)`, `e008: (8,2,6)`, `e009: (9,1,13)`, `e010: (10,3,4)` where tuples are `(order_id,qty,unit_price)`. `e011` retries order 3 unchanged `(3,3,7)` with `seq=2`; `e012` is invalid order 11 `(11,-1,4)`. Initial records have `seq=1` and `event_ts=12:00` except e011/e012 at 12:01. Create **C01-prefixed** Bronze, Silver, Gold, rejects and audit tables, wholly independent of other tickets.
- **Fixed oracle:** Initial raw event count **12**, **10** valid unique orders after deduplication, invalid events **1**, and Gold total `SUM(qty*unit_price)` **150.00**. Replaying the **same 12 event IDs** must not change Bronze count, Silver count, Gold total, or unique-business-event counts (the attempt/audit count may increase). A new correction `e013` arrives at `2026-01-01T12:02:00Z` for order 3 with `seq=3`, `qty=4`, `unit_price=7`: Bronze **13**, Silver **10**, Gold **157.00**, rejects **1**. Determine latest valid record per order by `(event_ts DESC, seq DESC, event_id DESC)`; reject invalids before selecting the Silver survivor. Never overwrite the original source event; retain the correction in the event history.
- **Build contract as code:** Create SQL table schemas and executable assertions in `tickets/C01/`, matching the following rules. Bronze preserves **all 12 unique source events initially** and **13 after correction**, rather than appending identical replay events. Silver must have **10 valid unique order IDs**, using the explicit ordering rule above; the invalid row is captured in the rejection table. A separate run-attempt audit logs replay attempts without double-counting business events. Gold has an explicitly defined aggregate (e.g. total valid order value). Define unit and SQL acceptance tests for count, uniqueness, valid quantity, schema, permissions and rerun safety.
- **Build:** Implement notebook/Python or supported Declarative Pipeline (record which choice and why), create **`dbx_c01_job`** with parameterized batch and at least two dependent stages, use Git and a self-contained bundle to validate/deploy the job if permitted, add a minimal security grant/check and budget/auto-stop review. If any feature is admin-blocked, document the specific unavailable privilege and keep the full capstone **BLOCKED / PARTIAL**, rather than calling a simplified demonstration production-equivalent.
- **Prove:** Run once, rerun identical data, then deliver one corrected record. Prove Bronze/source audit fidelity (**12 → 12 on replay → 13 after correction**), **Silver stays 10 rows**, Gold changes **150.00 → 150.00 → 157.00**, failed-data records remain traceable, and no unapproved privilege is required. Prove a controlled failure prevents release and show job-run/quality/lineage evidence available to your account.
- **Deliver:** The runnable fixture generator, ingestion/publication source, SQL assertion tests, job/bundle resources, real run IDs, expected-versus-observed output table, one failure/repair log, and minimal scope/cost evidence under `tickets/C01/`. An architecture essay or presentation is **not** required.
- **Hands-on check:** Run baseline, identical replay and one corrected event through the job. Assert Bronze 12→12→13, Silver 10, Gold 150→150→157 and rejects=1; verify failing input cannot silently release. **Cleanup:** Disable job/trigger; retain only explicitly chosen project demo resources within C.S.


### Hands-on execution playbook for C01

**Architecture:** `C01 Volume CSV files` → **C01 Bronze** append-only event identity via idempotent MERGE → **C01 Rejects** quality violations → **C01 Silver** latest valid row per order → **C01 Gold** aggregate → **C01 run audit**. Orchestrate as **two dependent notebook tasks** in `dbx_c01_job`, `max_concurrent_runs=1`, using the one C.S and the shared volume's **C01/** subdirectory. Never depend on tables/jobs produced by V/T/J/D tickets.

### C01-A — Generate baseline and correction *as real files*

Create `src/c01_seed.py` notebook. Include universal preflight, then:

```python
import os,csv
base=f"{VOL}/C01/incoming"
os.makedirs(base, exist_ok=True)
rows=[(1,2,10),(2,1,15),(3,3,7),(4,1,8),(5,2,9),
      (6,1,11),(7,4,5),(8,2,6),(9,1,13),(10,3,4)]
records=[(f"e{i:03d}",oid,"2026-01-01T12:00:00Z",1,qty,price,"paid")
         for i,(oid,qty,price) in enumerate(rows,1)]
records += [
  ("e011",3,"2026-01-01T12:01:00Z",2,3,7,"paid"),
  ("e012",11,"2026-01-01T12:01:00Z",1,-1,4,"paid")]
cols=["event_id","order_id","event_ts","seq","qty","unit_price","status"]
with open(f"{base}/orders_001.csv","w",newline="",encoding="utf-8") as f:
    w=csv.writer(f);w.writerow(cols);w.writerows(records)
assert len(records)==12
# Do NOT seed correction yet; save it for the third run.
```

**For the correction phase only**, later create a distinct C01 file:

```python
with open(f"{base}/orders_002.csv","w",newline="",encoding="utf-8") as f:
    w=csv.writer(f);w.writerow(cols)
    w.writerow(["e013",3,"2026-01-01T12:02:00Z",3,4,7,"paid"])
```

**Safety:** source event IDs unique; never wipe `C01/incoming` without an ownership/inventory review. If rerunning the **entire** capstone from zero, remove only the explicitly owned `c01_*` tables and `C01/` files, then reseed. Never modify S00 resources. Seed phase labels are important: first 12, *replay same 12*, then add e013.

### C01-B — Notebook task `ingest`: idempotent Bronze and attempt audit

Create `src/c01_ingest.py` with universal preflight, then:

```python
from pyspark.sql import functions as F, types as T
from delta.tables import DeltaTable
from uuid import uuid4

cols=T.StructType([
 T.StructField("event_id",T.StringType(),False),
 T.StructField("order_id",T.IntegerType(),False),
 T.StructField("event_ts",T.StringType(),False),
 T.StructField("seq",T.IntegerType(),False),
 T.StructField("qty",T.IntegerType(),True),
 T.StructField("unit_price",T.DecimalType(10,2),True),
 T.StructField("status",T.StringType(),True)])
source=(spark.read.option("header",True).schema(cols)
        .csv(f"{VOL}/C01/incoming/*.csv"))
assert source.count()>0
assert source.where("event_id IS NULL OR order_id IS NULL OR seq IS NULL OR event_ts IS NULL").count()==0
# Same event_id with conflicting fields is a *fatal input defect*, not safe deduplication.
conflicts=source.groupBy("event_id").agg(F.countDistinct(F.struct(
 "order_id","event_ts","seq","qty","unit_price","status")).alias("variants"))
assert conflicts.where("variants>1").count()==0, "Conflicting event_id payloads"
safe=source.dropDuplicates(["event_id"])
spark.sql(f"""CREATE TABLE IF NOT EXISTS {NS}.c01_bronze (
 event_id STRING,order_id INT,event_ts STRING,seq INT,qty INT,
 unit_price DECIMAL(10,2),status STRING) USING DELTA""")
spark.sql(f"""CREATE TABLE IF NOT EXISTS {NS}.c01_attempt_audit (
 attempt_id STRING, observed_input_rows BIGINT, attempt_utc TIMESTAMP) USING DELTA""")
DeltaTable.forName(spark,f"{NS}.c01_bronze").alias("t").merge(
 safe.alias("s"),"t.event_id=s.event_id").whenNotMatchedInsertAll().execute()
spark.createDataFrame([(uuid4().hex,source.count())],
 "attempt_id STRING,observed_input_rows BIGINT").withColumn(
 "attempt_utc",F.current_timestamp()).write.mode("append").insertInto(f"{NS}.c01_attempt_audit")
print("C01 Bronze event count:",spark.table(f"{NS}.c01_bronze").count())
```

**Important:** `max_concurrent_runs=1` prevents overlap of runs of this *specific* job; do not launch another writer to `c01_bronze` in parallel. The Bronze `MERGE` ensures same event IDs are not inserted by **serial** replays; it does not make arbitrary simultaneous writes race-proof. Missing required columns/types must be rejected, not silently inserted.

### C01-C — Notebook task `publish`: reject, Silver, Gold and hard assertions

Create `src/c01_publish.py` with universal preflight:

```python
from pyspark.sql import functions as F
from pyspark.sql.window import Window
from decimal import Decimal
bronze=spark.table(f"{NS}.c01_bronze")
invalid=(F.col("qty").isNull() | (F.col("qty")<=0) |
         F.col("unit_price").isNull() | (F.col("unit_price")<0) |
         F.col("status").isNull() | (F.col("status")!="paid"))
rejects=bronze.where(invalid)
valid=bronze.where(~invalid)
window=Window.partitionBy("order_id").orderBy(
    F.col("event_ts").desc(),F.col("seq").desc(),F.col("event_id").desc())
silver=(valid.withColumn("rn",F.row_number().over(window))
        .where("rn=1").drop("rn"))
# Ticket-owned tables; full snapshot materialization is intentional for this tiny dataset.
rejects.write.format("delta").mode("overwrite").saveAsTable(f"{NS}.c01_rejects")
silver.write.format("delta").mode("overwrite").saveAsTable(f"{NS}.c01_silver")
gold=silver.agg(F.count("*").alias("order_count"),
                  F.sum(F.col("qty")*F.col("unit_price")).alias("gross_amount"))
gold.write.format("delta").mode("overwrite").saveAsTable(f"{NS}.c01_gold")
n_bronze=bronze.count();n_silver=silver.count();n_rejects=rejects.count()
n_orders=silver.select("order_id").distinct().count()
gross=gold.first()["gross_amount"]
expected_bronze = 12 if n_bronze==12 else 13
expected_gold=Decimal("150.00") if expected_bronze==12 else Decimal("157.00")
assert n_bronze in (12,13),n_bronze
assert (n_silver,n_rejects,n_orders)==(10,1,10),(n_silver,n_rejects,n_orders)
assert gross==expected_gold,(gross,expected_gold)
print("C01 accepted:",n_bronze,n_silver,n_rejects,gross)
```

1. Create manual-only job `dbx_c01_job`: task `ingest` → task `publish`, pointing to the two C01 notebook files; choose approved small compute. Set `max_concurrent_runs=1`, **no continuous/scheduled triggers**, explicitly record run-as identity and effective privileges. Use a C01-only Git commit and, where permitted, a **C01-only bundle** with job resource key `c01_job` and two tasks; reuse D03/D04 **pattern**, not D03/D04 jobs/config/state. Bundle `validate` → `deploy` → `run` is a release test, never a substitute for data tests.
2. After **first** seed, run job once and query: Bronze **12**, Silver **10**, Rejects **1**, Gold **150.00**, attempt audit **1**. Capture job run ID.
3. **Replay:** run identical input files again with no new data; Bronze **12**, Silver **10**, Rejects **1**, Gold **150.00**, attempt audit **2**. A duplicate trigger/run affects only attempt telemetry, not business state.
4. Write correction file e013; run job again. Bronze **13**, Silver **10**, Rejects **1**, Gold **157.00**, attempt audit **3**, order 3 must have `seq=3, qty=4,unit_price=7.00`. Record the difference +7.
5. **Controlled failing case:** add a **C01-only** file containing duplicate event `e001` with a different quantity. Rerun; `ingest` must stop at the conflict check and `publish` must be prevented by the dependency. Confirm Gold **remains 157.00** (no corrupt partial overwrite). Remove only the bad file, rerun and verify 13/10/1/157 again. Capture failure/repair evidence.
6. **Security/ops proof:** `SHOW GRANTS` for own C01 objects where authorized; demonstrate that data is fake; check run-as and no privileged secret in code; disable recurring triggers; measure compute duration and note pricing/usage source. Perform the actual replay/correction validation after the Silver/Gold snapshot write; do not claim this tiny batch lab proves production streaming scalability.
7. **Deployment:** version C01 notebooks/tests/job config in your one repo, run a read-only test gate before any bundle deploy, document deployer identity/approval requirements. If bundle deployment or permission proof is unavailable, mark that completion dimension **PARTIAL** rather than a full production-grade capstone.

### C01-D — Run these acceptance queries after *each* phase

```sql
SELECT COUNT(*) AS bronze_events FROM c01_bronze;
SELECT COUNT(*) AS valid_business_orders FROM c01_silver;
SELECT COUNT(*) AS rejects FROM c01_rejects;
SELECT COUNT(*) AS attempts FROM c01_attempt_audit;
SELECT order_count,gross_amount FROM c01_gold;
SELECT order_id,seq,qty,unit_price FROM c01_silver WHERE order_id=3;
SELECT COUNT(*)-COUNT(DISTINCT event_id) AS bronze_duplicate_events FROM c01_bronze;
SELECT COUNT(*)-COUNT(DISTINCT order_id) AS silver_duplicate_orders FROM c01_silver;
```

| Phase | Bronze | Silver | Rejects | Gold | Attempts | Order 3 | Duplicate counts |
|---|---:|---:|---:|---:|---:|---|---|
| First run | 12 | 10 | 1 | 150.00 | 1 | qty=3, seq=2 | both zero |
| Identical replay | 12 | 10 | 1 | 150.00 | 2 | qty=3, seq=2 | both zero |
| Correction e013 | 13 | 10 | 1 | 157.00 | 3 | qty=4, seq=3 | both zero |
| Conflicting e001 (rejected) | 13 | 10 | 1 | 157.00 | 3 | qty=4, seq=3 | both zero |

**Pass:** the real job, outputs and fail-stop checks match table; exact data contract and dataset lineage explained; approved bundle/permissions/cost proof when applicable. The table is an **expected oracle**, not a claim that anyone ran the job. Use run IDs, query results and redacted evidence for the observed side. Disable/retire only C01-owned recurring resources and avoid leaving long-running pipelines/compute.

---

# 3. Progress and assessment — actionable tracker

> One sandbox persists; completion of one ticket never requires deleting, recreating or cloning it. `DONE` means verified **hands-on**, not just a written summary.

| Track | Tickets | Count | Core skill |
|---|---|---:|---|
| A — Foundation | F01 F02 F03 F04 | 4 | architecture, permissions, Spark, design |
| B — Volumes | V01 V02 V03 V04 | 4 | managed/external files and UC access |
| C — Tables | T01 T02 T03 T04 T05 T06 T07 | 7 | Delta lifecycle, reliability, data contracts |
| D — Jobs | J01 J02 J03 J04 J05 J06 | 6 | execution, scheduling, branching, repair, replay |
| E — Policies | P01 P02 P03 P04 P05 P06 | 6 | privileges, filters/masks, compute policy, identity, audit |
| F — DevOps | D01 D02 D03 D04 D05 D06 | 6 | Git, CLI, bundles, deployment, CI/CD and gates |
| G — Infra/config | I01 I02 I03 I04 | 4 | compute, Terraform, declarative pipelines, cost |
| H — Capstone | C01 | 1 | end-to-end integrated demo |
| **TOTAL** | **38 independent tickets** | **38** | **+ S00 setup once** |

**Recommended execution order:** S00 → F01/F02 → V01/V04 → T01–T05 → J01–J03 → D01–D04 → P01/P04 → I01/I03 → remaining tickets → C01. This order is convenient for practice, not a runtime dependency. Independent tickets can be taken in any order when privileges permit. For `ADMIN / CONDITIONAL` items, record blocker early and proceed with unblocked items.

### Ticket acceptance — actual evidence only (10 points)

| Tested item | Points | How to earn full credit |
|---|---:|---|
| Reproducible ticket-owned setup | 2 | Start the ticket without other ticket results, re-seed only its own fixture, preserve shared S00 assets |
| Working Databricks execution | 3 | Actual notebook/SQL/job/bundle/API actions run in the authorized sandbox and create the required result |
| Exact acceptance assertions | 2 | Numeric values, row contents, permissions, errors or state match the listed oracle; real output captured |
| Failure reproduction and repair | 2 | Safe failing case was observed and corrected; results rechecked (or the reason for safely omitting a risky probe is documented) |
| Closeout | 1 | Record actual run/reference, stop recurring compute/triggers, check costs, do not touch shared or other-ticket objects |

**DONE:** at least **9/10**, with full marks on **working execution and exact assertions**, and no missing mandatory hands-on operation. If an authorized permission/feature is unavailable, mark `PARTIAL` or `BLOCKED`, never `DONE`. No book summary, concept quiz, essay or verbal test is required.

### Final live checkout — zero questions, only demonstrations

Use the already required `C01` capstone outputs to verify these **observable actions**, without writing any theory answers:

1. List the real C01 input files in the shared Volume and read at least one with the notebook.
2. Query Bronze, Silver, rejects, and Gold from Catalog Explorer/SQL.
3. Show the unchanged business totals after a replay, with a second actual run ID.
4. Show the correction increasing Gold from **150** to **157**, with Bronze **12 → 13**.
5. Show a real job task graph, failure record and repaired run.
6. Demonstrate the permission check and bundle validation/deployment evidence actually available in the single sandbox; keep unavailable privileged features `BLOCKED`.
7. Stop/disable all C01 schedules/triggers and verify that no unintended recurring jobs or pipelines remain active.

**There is no additional written final exam.**

### Troubleshooting links (optional lookups only; not assigned reading)

- Azure Databricks documentation: <https://learn.microsoft.com/en-us/azure/databricks/>
- Unity Catalog and volumes: <https://learn.microsoft.com/en-us/azure/databricks/volumes/>
- Delta Lake overview: <https://learn.microsoft.com/en-us/azure/databricks/delta/>
- Lakeflow Jobs: <https://learn.microsoft.com/en-us/azure/databricks/jobs/>
- Declarative Automation Bundles: <https://learn.microsoft.com/en-us/azure/databricks/dev-tools/bundles/>
- Azure Databricks security and compliance: <https://learn.microsoft.com/en-us/azure/databricks/security/>
- Unity Catalog volume privilege matrix: <https://learn.microsoft.com/en-us/azure/databricks/volumes/privileges>
- File-arrival trigger behavior: <https://learn.microsoft.com/en-us/azure/databricks/jobs/file-arrival-triggers>
- Declarative Automation Bundle workflow and validation: <https://learn.microsoft.com/en-us/azure/databricks/dev-tools/bundles/work-tasks>
- Bundle configuration keys: <https://learn.microsoft.com/en-us/azure/databricks/dev-tools/bundles/settings>
- Compute-policy administration and use: <https://learn.microsoft.com/en-us/azure/databricks/admin/clusters/policies>

### Iterative completeness audit (design verification, not live Databricks certification)

| Audit pass | What was checked | Closure standard |
|---|---|---|
| 1 — Ticket coverage | All 38 tickets cover the six requested Databricks work areas, plus S00 setup | All requested work areas included, with observed acceptance targets |
| 2 — Sandbox integrity | Exactly one persistent workspace/C/S/shared volume/repository; ticket-prefixed temporary resources; conditional privileged exceptions; safe cleanup | No ticket implicitly asks for a second sandbox or modifies another ticket's objects |
| 3 — Hands-on focus | Ticket fixture, actions, observable acceptance, failure/recovery and DoD for each of 38 tickets | No compulsory reading, essays, definition prompts or theory quizzes; actual runs are required |
| 4 — Deterministic data | Bootstrap, Delta CRUD/CDF/MERGE, malformed rows, job DAG and capstone outcomes recalculated; replay and correction rules defined | Assertions are specific and reproducible; incorrect expected values fixed |
| 5 — Operational realism | Unity Catalog versus Azure RBAC, compute policies versus table grants, supported trigger semantics, run-as identity, bundle validation, Terraform scope, cost and secret handling | Missing permissions are `BLOCKED`; no claims of authorization or platform behavior without actual confirmation |
| 6 — Static document QA | Ticket names/counts, unique IDs, no book reading requirements, code-fence closure, markdown sections, and fixture consistency | Passes local structural checks before delivery |

**Important limit:** These passes verify the *training design, runnable example syntax where statically checkable, and internal consistency*. Actual Databricks ticket completion, account permissions, feature behavior, cost and run outputs remain unverified until you execute each ticket in your own sandbox.

**Program completion means:** 38 verified tickets, plus S00, in **one shared sandbox**. No extra sandbox per ticket, no hidden dependence on previous ticket outputs, and no assumption that a permission-blocked ticket was executed successfully.


### Final readiness and non-claims (version 5 — hands-on only)

The document's static verification consists of several loops: (1) every one of 38 tickets has a complete implementation playbook plus S00; (2) all expected-result examples checked against independent mock data arithmetic; (3) Python code blocks parsed and key YAML structures checked; (4) all reset/create/drop actions restricted to **ticket-owned prefixes**; (5) conditional cloud/security/hosted-CI tasks cannot be marked DONE without observed rights and a real run; and (6) no previous ticket's output is required to start a different ticket. Each execution notebook repeats S00-derived **non-secret** config; no second sandbox is created.

**Document-ready is not workspace-validated.** The exercises, code patterns and oracles are meant to be executed, but cloud service APIs, CLI bundle schemas, exact policies and billing visibility must be checked against your actual Azure Databricks environment. Do not record a ticket as DONE unless its real observed tests pass. Administrative and service-plan gating cannot be removed by adding more written instructions.
