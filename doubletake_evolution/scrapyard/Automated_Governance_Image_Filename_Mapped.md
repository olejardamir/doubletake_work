# Automated Governance
## How Intelligent Systems Turn Proposed Actions into Accountable Outcomes

*Architecture, decision-making, enforcement, evidence, and the boundaries of trust*

**Document version:** October 2026  
**Architectural setting:** An offline Python enterprise reference design, using synthetic information and bounded simulations of external services.

> **About this document and its scope**  
> The sections describe the intended architecture in the present tense so that its parts can be understood as one coherent system. This is an explanation of a target design, **not** evidence that software has been completed, tested, independently accepted, connected to cloud services, or certified for regulated production. The engineering design calls for an offline reference, not a live Azure or Databricks deployment. Where a section describes a successful decision or effect, it describes the behavior that implementation and independent tests must establish.

The sections follow one recurring problem: a piece of automation wants to change a system. Sometimes that change should happen immediately; sometimes it should wait; sometimes it must never happen. The problem becomes more complex when approvals expire, messages repeat, systems crash, and the evidence itself is questioned. Each illustration is planned to clarify the corresponding explanation. The bracketed figure descriptions are instructions for artwork to be created in a later illustrated PDF version, not diagrams that have already been produced.

---

# Part I — Why Governance Must Be More Than a Decision

## 1. The Moment Before an Action

Imagine an ordinary afternoon in an organization that uses software agents to manage data and applications. One agent notices that a development job has stopped. It proposes a restart. A second agent proposes replacing a pipeline that processes sensitive financial records. Both proposals sound reasonable. Both may even be technically correct. Yet the organization should not treat them as equally safe.

The first action could be an expected maintenance operation in an isolated development environment. The second might affect information used by hundreds of people, change a production result, or violate an approval requirement. The important question is therefore not simply *Can the agent do it?* It is *May this particular actor perform this particular action, on this particular resource, in these particular circumstances—and can the organization later establish what actually happened?*

That question is the beginning of **automated governance**.

Governance is sometimes mistaken for a collection of policies, an approval dashboard, or a log of actions. Those are useful components, but none is sufficient by itself. A policy can exist without being enforced. An approval can be issued for the wrong resource. A log can confidently say `DENY` even though the underlying resource was changed. Automated governance becomes meaningful when rules, authority, execution, and evidence form one connected process.

The governing system receives a *proposal*, establishes its true context, evaluates the applicable rules, and either prevents the action or issues tightly limited authority to proceed. If an action does occur, its actual effects become part of a durable history that can be checked independently. The system also needs a disciplined answer when it cannot determine what happened: uncertainty must be recorded as uncertainty, not disguised as success.

There is a deceptively simple principle behind the entire architecture:

**An agent may propose an action, but it cannot award itself the right to perform that action.**

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_22 PM-1.png]

### The difference between an intention, a decision, and an effect

Consider three statements:

> “Restart the development job.”

This is an **intention**. It tells us what someone wants to happen.

> “The action satisfies the applicable policy.”

This is a **decision**. It says the request meets stated conditions at the moment of evaluation.

> “The job restart was committed once, and its outcome was recorded.”

This is an **effect and an observation**. It says something happened and identifies what evidence exists.

These statements must not be collapsed into one another. In a well-governed system, the transition between them is deliberately difficult to bypass. That distinction also explains why an approving answer from an AI model is not itself security enforcement: words are not an independent source of authority, and a model response is not a controlled write boundary.

## 2. The Geography of Trust

Every computing system contains information that can be *claimed* and information that has been *established*. A request can contain a field saying that its author is an administrator. It can include an apparent approval number, a reassuring explanation, or an instruction embedded in a document that says all restrictions are suspended. None of those statements proves anything about the caller's privileges.

A governance architecture therefore draws boundaries between the requesting side and the authoritative side. The request, agent-generated plan, user-supplied text, incoming data, and even an adapter's unverified success message are treated as claims. An independent source must establish identity; a controlled policy source must establish the applicable rules; a separate approval authority must grant sensitive exceptions; and a protected executor must decide whether a proposed change may actually be committed.

This is not a matter of distrusting people by default. It is a matter of keeping responsibilities distinct. The person who submits an expense cannot be the sole authority that certifies and pays it. The same principle applies to software that may work at machine speed.

The central actors can be understood as a small cast:

- **Requester:** the human, service, or agent proposing an operation.
- **Principal:** the identity actually established by a trusted identity source.
- **Policy authority:** the owner of versioned rules about permissible actions.
- **Approver:** an independently authorized person or principal who can grant a bounded approval.
- **Enforcement gateway:** the point at which an action can change protected state.
- **Evidence verifier:** a separate reader that checks history against independently derived expectations.

A **tenant** is an independently scoped customer or organizational boundary. Two tenants may run on the same software while being entitled to entirely different resources, permissions, and historical records. Tenant separation must cover the governance records themselves, not only the underlying business data.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_23 PM-2.png]

### Trust is also limited by where software runs

An offline Python reference can show that its supported APIs and gateways refuse unauthorized calls. It cannot, by itself, prevent every process running under the same operating-system account from opening and editing a writable data file directly. Nor can an ordinary local hash establish what a privileged host administrator did if the administrator can rewrite both the data and the hash.

This distinction matters because a good architectural explanation must name the *boundary of a guarantee*. The reference demonstrates governance **through the declared gateway and synthetic fixture boundary**. Real host separation, independently controlled credentials, protected logs, and privileged-service isolation belong to a future production environment. Accurate security begins by saying what is and is not protected.

## 3. One Authority, Many Responsibilities

Large systems are naturally assembled from components. An agent controller can receive tasks; an identity adapter can resolve the caller; a policy evaluator can examine permissions; an approval service can hold grants; an adapter can interact with a job or a table. Componentization is valuable, but an accidental danger appears when each component starts making its own permission decisions.

Suppose the deployment adapter decides that a request is allowed because the agent supplied `approved: true`, while the central policy evaluator would have denied it. The organization now has two competing sources of authority. A request can succeed by finding the more permissive path. The architecture has ceased to govern consistently.

The solution is **one authoritative governance route**. Supporting modules may translate formats and consult different resources, but normative authorization returns to the same trusted decision machinery. The actual effectful operation must also pass through one protected gateway. A new adapter is never an excuse to invent a parallel approval system or a second unrestricted execution path.

A small, stable kernel or entry boundary helps preserve this structure. It receives and routes a proposed operation but does not become an ever-expanding source of private exemptions. Extensions can grow around it under controlled interfaces; they cannot quietly weaken the rules that protect it.

The design distinguishes three environments of authority. An **offline enterprise reference** performs deterministic operations against synthetic local data. A separately governed **development-evolution environment** may change software under its own approved processes. A possible **future production environment** would need real infrastructure and independent institutional authorization. Permissions from software experimentation do not automatically become permissions to change enterprise policies or production datasets.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_25 PM-3.png]

### One morning, two requests

Picture a fictional organization whose data systems are maintained by several automated assistants. Shortly after opening time, a monitoring assistant notices that a development job has stalled. It asks for a restart. Minutes later, another assistant detects a mismatch in a production-like reporting pipeline and proposes replacing the deployed artifact.

Both assistants are trying to help. Neither request needs to be treated as suspicious simply because an agent generated it. The important difference lies in the consequences and the authority required. A development restart may already fall within a trusted service account's permission, provided it targets the right tenant and job. The reporting-pipeline replacement might affect sensitive records, so an independent person must approve that exact version of the proposed change.

Without automated governance, the first operation could wait unnecessarily for a human to inspect a routine ticket, while the second could be rushed through because its technical explanation sounds convincing. With governance, the system can distinguish them. It can allow a low-risk action when all standing conditions are satisfied and hold a higher-risk one for a bounded grant. It can refuse either one if the resource, actor, environment or policy does not match.

The distinction is easy to miss: automation is not the opposite of oversight. **Automation is what makes oversight consistent at the speed of the work.** People decide the rules and retain independent authority over designated sensitive acts; the system applies the rules on every occasion. We will return to these two requests as they encounter stale permissions, repeated messages, uncertain outcomes and the problem of proving what really occurred.

---

# Part II — How a Request Earns Permission

## 4. The Request Is a Precise Description, Not a Promise

The organization cannot govern an action it cannot describe precisely. “Update the pipeline” is understandable to a person but insufficiently specific for a secure effect. Which pipeline? In which tenant? In which environment? What new artifact will replace it? Who is asking, and under which policy version?

A governed request therefore has a versioned, strictly parsed structure. It identifies the proposed action and exact resource, the environment, a content fingerprint for any payload or software artifact, a request identifier, and an idempotency key for safe retries. Sensitive identity and authorization facts are resolved separately. An asserted `principal_id` in the request is not evidence that the caller has been authenticated as that principal.

The exact bytes also matter. Two files may share a filename while containing different code. A recorded approval of `pipeline.py` would be dangerously ambiguous; an approval tied to an exact content digest means changing the file invalidates the match. Canonical serialization provides one stable way to represent an operation, so equivalent encodings cannot accidentally create conflicting interpretations. Ambiguous identifiers, duplicate JSON keys, unexpected critical fields, unsafe paths, and malformed or oversized inputs are refused rather than guessed into validity.

A useful way to think about the request is as the **identity card of an operation**. It identifies the intended act, but the card cannot stamp itself “authorized.”

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_26 PM-4.png]

## 5. Policy: The Rules That Make a Decision Explainable

A policy answers who may do what and under which conditions. Roles are one ingredient, but they are not the entire answer. A user may have permission to restart development jobs and no authority to replace production pipelines. A service may be able to read a table but not alter it. A person with a broad technical role may still be forbidden from accessing another tenant's information or a specially classified dataset.

A mature governance evaluation therefore combines trusted identity, tenant, requested action, resource scope, environment, classification, applicable policy revision, and—in sensitive cases—an independent approval. More restrictive rules take priority. **An explicit prohibition is not cancelled by an approval or a general role grant.** Missing or corrupted policy is not interpreted as permission.

For example, imagine a synthetic dataset of customer transactions. A development analyst may have a catalog-level role, but a particular sensitive table may be restricted. An agent acting on the analyst's behalf cannot infer table access simply because its parent catalog is visible. It must establish the privileges required at each relevant level and satisfy any additional enterprise restriction.

The decision has four meaningful outcomes:

**ALLOW** means the known requirements permit the operation to advance toward execution authority. It does **not** itself change a resource. **DENY** means the proposed act must not be performed. **PENDING_APPROVAL** means a trusted external grant is needed before the attempt can advance. **ERROR** means some necessary determination failed, such as missing trustworthy policy data or a corrupted authority store; protected execution is not permitted in that condition.

This is called **fail closed**: when proof is absent, the system does not invent permission. The refusal may still produce an audit entry. “No unauthorized workload effect” and “no storage changed anywhere” are different claims.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_28 PM-5.png]

## 6. Approval as a Change of State

An agent has submitted a replacement for a production-like pipeline. The code artifact is known; the destination is known; the applicable policy is known. Yet the policy requires an authorized independent human decision. The request enters `PENDING_APPROVAL`, and the protected pipeline stays unchanged.

The approval that may arrive later has a narrow meaning. It applies to one stable operation intent, one tenant and environment, the exact artifact, an appropriate policy revision, and a bounded validity period. The approver's identity and authority must be independently established. Neither the requester nor the executor may manufacture the grant or approve its own sensitive operation. Two agents exchanging nominal approvals do not satisfy a policy that requires genuine human independence.

Most importantly, **approval is an event in the lifecycle, not an execution command**. When a trusted grant arrives, the system rechecks the pending request's original intent, current policy, caller, tenant and grant validity. Only then may it advance to `AUTHORIZED`. A separate step issues execution authority, and the gateway still examines the conditions before committing an effect.

What if approval arrives after the request was cancelled? The answer must be refusal. A cancelled or expired attempt is not a sleeping task that can be revived by an old message. What if policy changed while approval was pending? The changed policy must be evaluated; the old grant does not overrule it.

A subtle concurrency question arises when revocation and execution occur nearly simultaneously. The architecture needs an authoritative order. If revocation commits **before** the effect, execution must be blocked. If the properly authorized effect commits **before** revocation, that historical effect remains legitimate. A collection of unrelated file timestamps cannot establish this order reliably; the relevant policy and approval state must participate in a coherent transaction or ordered authority mechanism.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_29 PM-6.png]

## 7. Permission at the Last Possible Moment

An earlier decision can be perfectly correct and still be unsafe to rely upon minutes later. The caller's role may have been disabled. The approval may have been revoked. Another worker may have changed the resource. The artifact proposed at the start may have been replaced. This is the classic *time-of-check/time-of-use* problem: circumstances can change between deciding and acting.

The system addresses it with a **single-use execution permit** and a **protected effect gateway**. The permit is bound to the exact actor, executor, tenant, action, resource, environment, content digest, policy and relevant authority revisions. It expires, and it cannot simply be constructed by writing an object that contains `approved: true`.

When the action reaches the gateway, the gateway verifies the permit and freshly checks the conditions on which it depends. It also checks whether the permit was already spent. The action executes only if the authority is still valid at the effect boundary. A second use of the permit—even from another process—must not create a second protected effect.

Notice where governance is actually proven. A test in which the policy evaluator returns DENY is useful, but it does not prove an adapter cannot still write. Stronger evidence is a denied request sent through the actual effectful entry point, followed by an independent measurement that the protected resource was not changed.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_30 PM-7.png]

### The change that happened between “yes” and “go”

Return to the proposed pipeline replacement. Imagine that the approver reviewed artifact version A and granted permission for that precise content. The agent then prepared the deployment. Before the gateway received the effect request, a developer rebuilt the artifact under the same filename. The path still looks familiar, but its bytes now describe version B.

If authorization were merely a remembered Boolean, the system might carry out version B using permission meant for version A. It could say that the action had been approved without noticing that the approved action no longer existed. This is why the content digest travels with the request and permit. At the gateway, the actual artifact is compared with the authorized digest, and the changed version is refused. The agent can submit a new proposal for version B, but it cannot silently enlarge the old approval.

A similar race occurs when a role is disabled or an approval is revoked while a worker is waiting. Simply checking again is not enough if a different process can change the authoritative approval between that check and the final commit. The system needs an ordered boundary that decides which event happened first. The gateway's task is therefore more precise than asking whether something *was* allowed a moment ago. It must establish whether this **exact effect is authorized at the point where the effect becomes durable**.

This is also why an `ALLOW` message is deliberately less powerful than a permit. A decision explains the result of evaluating rules. A permit is a narrowly scoped authority that can be consumed only under the conditions those rules still require. Neither is a substitute for the final enforcement boundary.

---

# Part III — Preserving Truth When Computers Repeat, Race, or Fail

## 8. The Strange Problem of the Successful Retry

A service submits a restart, the operation succeeds, and the service loses its response. It cannot tell whether the restart happened. Its natural reaction is to retry. Without special protection, the same action might run twice.

**Idempotency** allows the system to recognize the same intended operation across deliveries. The design reserves an idempotency key under a unique combination of *trusted tenant, trusted actor, server-defined operation namespace, and client idempotency key*. The namespace belongs to the server, not to an arbitrary field supplied by the request.

Why not include the action or payload in the unique database key? Because doing so creates a dangerous loophole: someone could reuse the same supposed retry key with a different payload and get a second row. Instead, the stable operation fingerprint is stored **beneath** the reservation and compared whenever the key reappears. Changed action, tenant, resource, environment, payload, artifact, or an explicitly selected immutable policy/approval target produces an `IDEMPOTENCY_CONFLICT` and no new effect.

Not every changing field means a changed operation. A different transport delivery ID is only evidence of another delivery. A policy revision that occurred *after an already committed effect* is part of today's environment, not automatically part of that operation's original intent. The original committed effect remains a historical fact, even when current policy would prohibit making a new one.

There is one more distinction that prevents a particularly subtle data leak. Returning a previous receipt is itself an **information disclosure**. On every retry, the caller must be authenticated **now** and independently authorized **now** to view that historical receipt. A principal disabled since the original operation must not retrieve sensitive old records merely by knowing the original actor ID and idempotency key. Denying the receipt does not invalidate or erase the committed effect; it protects present access to its history.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_31 PM-8.png]

## 9. The Commit: Where an Action Becomes History

In ordinary language, “the operation happened” sounds uncomplicated. For a computer, it is a surprisingly exact claim. Did the resource change? Was the permit consumed? Was the result recorded? Could a crash leave half of those facts committed and the others missing?

For the offline reference, the design uses an **atomic local transaction** when it claims that the operation and its authoritative record cannot be separated. Python's standard-library SQLite support is a suitable local mechanism if no existing integrated store supplies equivalent guarantees.

Inside one durable, appropriately serialized local database transaction, the system checks the current authority and revisions, claims the one-use permit, changes the synthetic workload state, writes the **authoritative effect journal**, and commits. If a required journal write fails before commit, the protected effect does not commit either. If two processes race to use one permit, durable uniqueness and transaction ordering prevent both from spending it.

The word *atomic* applies to the things that participate in **that same transaction**. It does not extend magically to a separate text log, a cloud API, or a second database just because the Python code calls them in sequence. The local transactional fixture state must be inside the same transactional boundary as the journal if the design claims atomic effect-and-journal commitment.

### The primary journal and the readable copy

An organization may also want a JSONL or hash-chain representation of its history for inspection. Such a file is an **audit projection**—a secondary view derived from the authoritative journal. It may be generated after the database commit, and it can temporarily lag behind.

If the projected log becomes unavailable after a successful commit, the correct outcome is not to undo a committed action, nor to execute it again. The journal still tells us the action occurred. The projection must be repaired idempotently, and acceptance must remain blocked until that repair is verified. A meaningful state for this condition is `AUDIT_PROJECTION_PENDING`.

A crash before a local commit and a crash after that commit also mean different things. Before commit, uncommitted workload and effect-journal changes must not survive. After commit, they must recover together even if the client never saw a response. An earlier, separately committed idempotency reservation may survive a pre-commit crash; it needs truthful reconciliation, not a fabricated effect.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_32 PM-9.png]

## 10. When an Outcome Is Truly Unknown

Not every future system can put its effects inside the same local transaction. Consider a hypothetical external service that receives a change request and then loses its connection before returning an acknowledgement. The local governing system may know the request was sent, but it may not know whether the service committed it.

The responsible answer is `OUTCOME_UNKNOWN`. That phrase is not a weakness to hide; it is the most precise statement available.

A nontransactional adapter can be modeled with stages such as `PREPARED`, `DISPATCHED`, `OBSERVED`, `OUTCOME_UNKNOWN`, and `RECONCILED`. A stable external operation identifier and a read-after-failure observation interface may allow the system to discover the truth later. If it cannot observe the outcome safely, the system must not automatically repeat a potentially non-idempotent operation.

This contrasts with the local SQLite case. There, a proven atomic commit boundary can let recovery determine a committed effect from the authoritative journal. Calling that recoverable local effect “unknown” merely because a secondary log was delayed would obscure the real guarantee. Conversely, claiming exactly-once execution at a future cloud service without a suitable external contract would be an overstatement.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 08_59_34 PM-10.png]

## 11. Evidence That Can Be Questioned

If the system is to be accountable, someone other than the action-producing code must be able to examine its claims. Imagine an agent that performs a job and writes `"passed": true` into a report. That is testimony, not independent verification. The report could be mistaken, stale, forged, or merely copied from what the test expected.

The governance record therefore binds the request, trusted actor, tenant, policy snapshot, approval, permit, source content, test environment, fixture state, and observed effect. A **read-only independent verifier** reconstructs what should have occurred from persisted decisions and actual state, rather than asking the original decision-producing function to declare itself correct. It checks identity relationships, unique permit use, journal sequence, source and evidence digests, and whether committed operations reproduce the measured synthetic state.

One might think a hash chain solves authenticity. It does not solve it alone. Recomputing hashes can reveal accidental corruption or unsophisticated edits, but someone who can rewrite the entire log and its chain head can create a fresh internally consistent story. The strength of verification depends on what remains beyond the attacker's control.

Four evidence situations should be kept distinct:

1. **Internal consistency only:** the records and their hashes agree with one another, but no independent trusted reference confirms their history.
2. **Authoritative journal–projection match:** a secondary log agrees with an independently controlled, unchanged authoritative journal. This detects projection tampering relative to that journal, without establishing unconditional authenticity of the journal itself.
3. **Independent terminal-anchor match:** a separately trusted observer retained the genuine end-of-run journal head, record count and relevant state digest **before** later tampering. A verifier can compare those retained values against a possibly rewritten suffix.
4. **Unverifiable:** the required independently trusted journal or earlier terminal anchor is absent or untrustworthy. A complete coordinated rewrite may then be impossible to detect from the rewritten evidence alone.

The **time** an anchor was captured matters. A checkpoint calculated from already altered records does not prove those records were genuine. Neither a hash chain nor a separate verification program can create independent trust if the same attacker controls the evidence, verifier, expected answers and anchors.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_45 PM-1.png]

### An auditor arrives after the people have gone home

Imagine that two weeks after a deployment, a reviewer is asked a simple question: “Was that pipeline replacement legitimate?” The original agent is no longer running. The developer remembers submitting a change, but cannot recall the exact build. The approval interface displays a green check. These are clues, not conclusive answers.

The reviewer first identifies the committed effect in the authoritative journal. Its record should connect to the stable operation, actor, tenant, exact artifact digest, policy revision, approval grant and consumed permit. Next, the reviewer checks the actual state that the journal implies. If the recorded operation says a particular version was deployed, a read-only snapshot should corroborate the version observed in the synthetic environment. The reviewer must also ask whether the same permit appears to have authorized two changes, or whether a later policy revision has been mistakenly applied to an earlier commit.

Now imagine that the exported human-readable log has been altered. If the independently controlled primary journal is unchanged, the discrepancy can be found by replaying the projection against that journal. But suppose someone rewrote *both* the journal and the exported log, and recalculated every hash. If no separately retained, trusted end-of-run checkpoint survives, the new records may be internally consistent and still false. The reviewer cannot reconstruct the lost truth by confidence alone.

This is what makes independent verification a distinct activity. It does not mean “ask a second program whether the first program is correct.” It means use separately controlled reference facts, independently derived expectations and the measured effects to decide **which claims the available evidence can actually support**. Sometimes that conclusion is a clear yes, sometimes a clear no, and sometimes an explicit limit on what can be known.

---

# Part IV — Governing a World of Different Systems

## 12. Tenant Boundaries Are Boundaries of Knowledge

Multi-tenant systems share technology without sharing authority. A request associated with Tenant A must not read or change Tenant B's resources. That familiar rule must also protect approvals, permits, stored idempotency keys, audit events, and historical receipts.

A surprising leak can occur even when no business data is returned. An error such as “the idempotency key already exists for Tenant B” reveals another tenant's activity. Likewise, a caller who knows a historical receipt identifier must not gain access merely by supplying it. Tenant identity belongs in trusted identity resolution, policy evaluation, approval scope, permit scope, durable reservation, effect journal and the read authorization used by reconciliation.

The governing system thus protects two kinds of information: the workload itself and the governance metadata that reveals how that workload was handled. They may require different access policies, but neither is public merely because it is “only a log.”

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_46 PM-2.png]

## 13. Learning About Cloud Governance Without Connecting to the Cloud

An architecture can learn from the permission models of major platforms without being connected to them. In the offline reference, Python test doubles reproduce a **limited, declared subset** of selected Azure and Databricks concepts. Their purpose is to exercise local governance contracts and reveal integration mistakes, not to claim that the vendors themselves were tested.

The simulated **Azure role and scope model** distinguishes principal types and represents a hierarchy such as management group, subscription, resource group, and resource. An inherited positive grant on a parent can help authorize a descendant, but it does not necessarily authorize a sibling or defeat a more restrictive local governance policy. Azure-native deny assignments and local governance denials are not the same mechanism; Azure deny assignments are system-managed, not arbitrary user-created grants of “deny.”

The simulated **Databricks data model** distinguishes catalog, schema, and table permissions. Access to a table may require relevant parent usage privileges as well as the table's own privilege. Job permissions are separate: the ability to manage or start a job does not imply the ability to read every dataset it touches. A job may also run with a service identity different from the person who initiated it. Governance must account for both the initiator and the effective execution identity without treating either as a free substitute for the other.

The simulated **deployment model** introduces environment boundaries—development, testing, staging, and production-like—and binds deployment approval to a known artifact digest. It keeps code authorship, approval, execution, and recovery authority separate. A pipeline author cannot change the independent approval rules as part of the same proposed deployment.

All of these are **synthetic local effects**. They require no Azure or Databricks SDK, cloud endpoint, credential, hosted model, external database, Docker environment, or network connection. Unknown behavior returns an explicit unsupported result such as `UNSUPPORTED_IN_SIMULATOR`; the simulator does not invent a permissive approximation. A future live adapter could honor a similar interface—prepare, check permissions, verify preconditions, apply, observe, reconcile, recover—but live behavior would require its own verification.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_47 PM-3.png]

### Why isolation of the reference matters

An offline test must not unexpectedly call a network endpoint or import a cloud SDK while claiming to be self-contained. It should use synthetic organizations, people, accounts and transactions. Resource use, input size, process spawning and logging are bounded. Short-lived local Python child processes may still be needed to test concurrency and crashes; forbidding all child processes would hide the very failure modes the design needs to understand. These permissions are test-harness-controlled, not available as general agent powers.

## 14. Recovery Is an Action That Also Needs Governance

When a change fails, the temptation is to “repair whatever is broken” with broad privileges. That would be a dangerous exception to the entire design. A repair can modify sensitive resources just as effectively as the original operation. It must therefore be proposed, scoped, authorized and measured through governance.

For example, if a synthetic deployment is rolled back to a prior version, the rollback target must be explicit and independently authorized. A successful return code is not enough. The system must compare the restored fixture state against the intended previous state and record the result. If restoration cannot be established, the honest outcome is `RECOVERY_FAILED`.

Similarly, rebuilding a missing audit projection is not permission to replay the business operation. The primary journal, when trustworthy and intact, tells the recovery process what to export. A repair reconstructs the derived view without changing the committed workload again.

The design also separates **software evolution** from **enterprise operational authority**. An automated developer may diagnose a bug and propose a code correction inside a separately governed development process. It may not silently alter enterprise policy, disable evidence checks, self-approve its fix, and deploy that fix to a protected environment. Governance would be meaningless if its own emergency escape hatch were less governed than an ordinary data write.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_48 PM-4.png]

### A repair should not erase the incident

Suppose the development restart succeeded, and the local transaction committed its new job state together with the authoritative journal. The auxiliary audit export, however, stopped writing at precisely the wrong time. A dashboard now shows an incomplete timeline. Someone might suggest running the restart once more so that a fresh success record appears.

That would confuse the work with the evidence of the work. Repeating a restart could interrupt a job that is already healthy. The correct repair is to examine the committed journal and rebuild the missing projection. The reconstruction should not consume a second execution permit, produce a second restart, or change the original event's meaning. The final reviewer checks that the readable audit view matches the original committed history.

Other repairs truly do change resources. Reverting a faulty synthetic deployment restores a previous artifact, and that restoration is itself a new protected effect. It needs its own authorization, exact target and evidence of the resulting state. A rollback that merely returns “completed” while leaving the wrong artifact in place is not a successful recovery.

The distinction between *repairing a record* and *reversing an effect* is important far beyond software operations. It is the difference between correcting a ledger and undoing a transaction. Governance must know which of those things it is authorizing, because one cannot safely stand in for the other.

---

# Part V — What It Means to Know the System Works

## 15. Eight Safety Properties, Seen as Questions

Security properties are easier to understand when expressed as things the organization insists must remain true. In the architecture, eight such properties serve as **invariants**: constraints expected to hold across ordinary operations, retries, failures, and adversarial attempts. Their formal identifiers are retained because they connect the conceptual explanation to eventual executable evidence.

**EG-I01 — No unauthorized effects.** Can every committed workload effect be connected to a valid authorization for the exact actor, tenant, action, resource, environment, payload and policy at commit time? A denial audit entry may exist without violating this property, because it is governance metadata rather than an unauthorized workload change.

**EG-I02 — No double spending.** Can a single-use permit ever create more than one committed protected effect, including after a crash or across competing processes? It must not.

**EG-I03 — Separation of duties.** Can a requester or executing agent satisfy a required independent human approval through its own identity, an alias, or another agent? It must not.

**EG-I04 — Audit consistency.** For a local atomic effect, is the authoritative decision/effect journal committed together with the workload change? If a downstream projection lags, can it be reconciled without inventing another effect?

**EG-I05 — Evidence binding.** Is every accepted proof tied to the exact source content, policy, fixture and executed tests? A report about one source version must not certify another.

**EG-I06 — Fail closed.** Do unknown schemas, policy corruption, invalid identity, unavailable approvals and storage failures refuse protected work rather than turn into an implicit ALLOW?

**EG-I07 — No cloud effects.** Does the offline reference operate entirely within its local synthetic boundary, without network or live vendor activity?

**EG-I08 — Tenant noninterference.** Can one tenant's caller access another tenant's protected state or governance history by guessing an ID, replaying a key, or claiming an approval? It must not.

Each statement must be challenged by both ordinary and deliberately hostile tests. Passing a test of one attack does not prove every possible attack is blocked. The tests establish measured claims within a named boundary; they are not substitutes for real identity custody, host isolation or institutional security assessment.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_49 PM-5.png]

## 16. Four Stories That Tie the Pieces Together

### A routine restart

A trusted development principal asks to restart a synthetic job. The request is parsed, its tenant and resource are resolved, and the policy recognizes the action as permitted in development. A narrowly scoped permit reaches the gateway, which makes its final checks and commits a single restart along with the authoritative journal. A retry with the same stable intent does not restart the job again; an authorized reader may see the historical receipt. Here the most interesting governance result is almost invisible: ordinary work proceeds without unnecessary human intervention, yet its boundaries remain enforceable.

### A sensitive deployment

An agent proposes a new production-like pipeline artifact. The policy requires an independent grant, so the attempt enters `PENDING_APPROVAL`. No protected resource changes. A trusted approver later grants permission for the exact artifact and environment. The pending attempt advances only after fresh checks, and approval itself does not execute it. If the artifact changes before execution, the final digest check stops the deployment. If a cancellation commits before the grant, the late approval cannot revive the attempt. Here governance makes a sensitive change possible without allowing the proposer to redefine the conditions.

### An attempted cross-tenant lookup

A caller from Tenant A possesses an identifier resembling Tenant B's previous operation. The system does not assume that knowing an ID proves a right to read it. Current authentication, tenant scope and receipt-disclosure policy are checked independently. The response does not expose Tenant B's receipt or even unnecessarily confirm the record's existence. Here governance protects knowledge of operations, not merely the data those operations touched.

### A crash at the worst possible instant

A worker crashes shortly after changing local synthetic state but before a client receives confirmation. Because the effect and journal belong to the same transactional commit, the recovered database tells the verifier whether the commit occurred. The system does not guess or perform the change again. In a different scenario, a hypothetical nontransactional external effect has no such shared commit boundary; the answer remains `OUTCOME_UNKNOWN` until observation can establish the result. Here governance is the discipline of being precise about what is known.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_50 PM-6.png]

## 17. How an Architecture Becomes a Credible Reference

A design becomes credible gradually. The implementation plan behind this architecture describes nine connected stages, conventionally labeled **EG-00, EG-01, EG-02, EG-03, EG-04, EG-05, EG-05A, EG-06 and EG-07**. They are best understood as a progression in *what can legitimately be claimed*, not as a calendar or a list of commands to follow while reading this document.

In **EG-00**, the organization establishes which authorization mechanisms already exist and who is allowed to change them. This is governance applied to the act of building governance: no component should duplicate an existing authority or overwrite protected work merely because it would be convenient.

In **EG-01**, a small complete example demonstrates the essential difference between an authorized local effect and a refused one. This is the first meaningful vertical slice: not just a policy diagram, but an allowed synthetic change, a denied counterpart and verifiable evidence of both.

In **EG-02**, the enterprise profile, trusted fixture identities, policy snapshots and exact scopes make those decisions reliable. In **EG-03**, independent approvals, one-use permits, expiration, idempotency and concurrency control prevent permission from being copied, forged or spent twice. **EG-04** then places three specialized offline simulations behind the same enforcement boundary, demonstrating that a common governing architecture can control different types of resources without turning the simulators into new authorities.

The evidence becomes more demanding in **EG-05**, where crashes, audit writes, tampering, rollback and recovery are tested as real boundary conditions. **EG-05A** introduces a separate read-only verifier and independent state-machine oracle; deliberately false green reports and inconsistent records must be rejected. **EG-06** brings the reference together in a reproducible local package so that another person can inspect its behavior without access to external services. Finally, **EG-07** freezes the source identity, performs the planned acceptance tests and leaves the actual acceptance decision to an independently authorized process.

These stages are not complete because their descriptions exist. The decisive question for each is what integrated behavior and independently measured result has been demonstrated. If the canonical enforcement path cannot safely connect to a protected effect, that effect remains blocked rather than being routed around governance. If approval ordering cannot be made atomic, the correct status is a named blocker, not an optimistic approximation. An unrun test is not a passing test.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_51 PM-7.png]

### The role of a deliberately difficult test collection

The reference design calls for **66 mandatory executable scenarios**. Their purpose is not to produce a high number. Each scenario attacks a possible gap between a claim and reality: forged approval, stale policy, direct adapter bypass, duplicate permit use, uncertain crashes, fake reports, cross-tenant leakage, and many other ways a system could appear governed without truly being so.

A passing negative test means the unsafe behavior was actually prevented and the resulting state was independently observed. It does not mean that the rejected business operation succeeded. A scenario requiring successful recovery fails if the recovery remains unresolved. All mandatory scenarios must be executed against the retained source version before the offline reference can be accepted; any skipped, blocked, stale, unverifiable or failed scenario remains an acceptance obstacle. The scenario atlas in the appendix preserves their identifiers and intended observations without interrupting the conceptual narrative.

## 18. The Boundary Between an Offline Reference and a Real Institution

The reference deliberately resembles an enterprise deployment architecture, but resemblance is not equivalence. A local fixture registry is not a real identity provider. A Python gate is not operating-system isolation. An internally consistent hash chain is not an independently protected audit anchor. A simulator of a cloud permission model is not a test of the live provider's behavior.

A genuinely deployed system would additionally need real identity and service accounts, credential and key custody, host and process isolation, protected logging, verified live vendor interfaces, security and resilience assessments, change management, institutional approval, and the relevant licensing and compliance reviews. The offline reference cannot grant itself those assurances.

Even the strongest local acceptance label—`OFFLINE_ENTERPRISE_REFERENCE_ACCEPTED`—would mean only that the defined offline scope had passed its mandatory evidence and independent approval requirements. It would not mean “cloud integrated,” “regulatory compliant,” or “ready for bank production.” The unproven external gates remain explicitly named: `HOST_ISOLATION_UNVERIFIED`, `LIVE_IDENTITY_UNVERIFIED`, `EXTERNAL_EVIDENCE_ANCHOR_UNVERIFIED`, `VENDOR_CONFORMANCE_UNVERIFIED`, and `BANK_APPROVAL_UNVERIFIED`.

[PLACE DIAGRAM HERE: ChatGPT Image Oct 28, 2026, 09_04_52 PM-8.png]

## Epilogue — The Right to Act and the Duty to Explain

Automated governance is often introduced as a way to prevent bad actions. That is only half of its value. It also lets authorized work proceed with less friction, because the terms of permission are explicit and consistently enforced. An ordinary development restart can happen without a committee meeting. A sensitive deployment can wait for exactly the approval it needs. A failed operation can be examined without being repeated blindly. An audit can be challenged rather than merely trusted.

The deeper achievement is a chain of accountability. Every protected effect should have a reason it was allowed, a precise boundary at which that permission was checked, a durable description of what changed, and an honest measure of how much of the history an independent observer can verify.

A system is not governed because it claims to be responsible. It is governed when **the right to act is earned, the act is constrained, and its history can withstand examination**.

---

# Appendix A — A Conceptual Glossary

**Action / effect:** An action is an intended operation; an effect is an actual protected state change. A decision can allow consideration of an action without creating an effect.

**Approval grant:** A trusted, narrow, time-bounded authorization by an independent eligible approver. It is not a substitute for policy checks or an execution permit.

**Atomic transaction:** An all-or-nothing commit within a stated storage and authority boundary. It does not cover arbitrary external services or files.

**Audit projection:** A secondary representation of authoritative journal data, which may be repaired or rebuilt without repeating the workload operation.

**Canonical operation / digest:** A stable, unambiguous encoding and fingerprint of the exact intended act and its content.

**Fail closed:** Refuse protected execution when required identity, policy, approval, integrity or storage conditions cannot be established.

**Fixture:** Deliberately synthetic data and state used in bounded, reproducible local experiments.

**Idempotency:** Recognition of repeated deliveries of one stable operation intent so that an already committed effect is not applied again.

**Independent verifier:** A separately operated, read-only evidence checker that reconstructs facts rather than trusting a producer's own success labels.

**Invariant:** A statement required to remain true for every execution covered by the declared system boundary.

**Journal:** The authoritative, durable operation/effect record. In local transactional cases it is committed alongside the protected workload effect.

**Permit:** Narrow, expiring, single-use execution authority validated at the protected effect gateway.

**Policy snapshot:** A controlled version of the rules applied to an operation, identified by both revision and content digest.

**Reconciliation:** Determining what actually happened after interruption or ambiguous results, without blindly repeating a potentially committed effect.

**Separation of duties:** Distribution of request, approval and execution powers so that a sensitive actor cannot unilaterally authorize its own work.

**Tenant:** A distinct organizational security scope whose resources and governance records must be protected from other tenants.

**Trust anchor:** A reference controlled independently of the data being checked, retained at the appropriate time to make certain forms of tampering detectable.

**Time-of-check/time-of-use:** The risk that facts supporting permission change between initial authorization and actual effect.

---

# Appendix B — The 66-Scenario Evidence Atlas

The scenarios below describe **required future executable checks**, not tests claimed to have run. They form a reference atlas rather than a section-by-section reading assignment. Each row poses a question about the architecture and states the observation that would answer it. Their stable identifiers allow a future reader to connect the concepts in the document to actual reproducible evidence. The main sections explain *why* the safeguards matter; this appendix preserves the harder question of *how one would know they held*.

## Authority, approvals and identity


| Scenario | Question the test must answer | Required observation |
|---|---|---|
| EG-S01 | Permitted development job restart by trusted eligible principal | ALLOW; exactly one fixture effect and valid receipt |
| EG-S02 | Same restart under a principal lacking run privilege | DENY; zero **workload** effect; required refusal/audit receipt allowed |
| EG-S03 | Production pipeline replacement without independent approval | PENDING/DENY; zero effect |
| EG-S04 | Approved production-like change with exact digest and valid independent grant | ALLOW if all gates pass; exactly one effect |
| EG-S05 | Requester self-approves protected change | DENY; zero effect |
| EG-S06 | Executing agent self-approves protected change | DENY; zero effect |
| EG-S07 | Wrong approver role / untrusted approval issuer | DENY; zero effect |
| EG-S08 | Expired, revoked or consumed approval | DENY; zero effect |
| EG-S09 | Same approval for a different artifact, environment or scope | DENY; zero effect |
| EG-S10 | Absent, malformed or unsupported policy version | DENY; zero effect |
| EG-S11 | Policy updated after permit issuance | Recheck; deny stale permit |
| EG-S12 | Role spoofing via request JSON/context | DENY; zero effect |
| EG-S13 | Tenant or environment scope escalation | DENY; zero effect |
| EG-S14 | Attempt to modify policy, trust anchor or audit configuration by agent | DENY; zero effect |
| EG-S15 | Attempt direct adapter effect with no permit | DENY; zero effect |
| EG-S16 | Fake permit / changed request body or digest | DENY; zero effect |


## Replay, evidence and cloud-like boundaries


| Scenario | Question the test must answer | Required observation |
|---|---|---|
| EG-S17 | Reuse permit twice, same process | At most one effect |
| EG-S18 | Competing processes use the same permit | At most one effect |
| EG-S19 | A currently authenticated, receipt-visibility-authorized caller retries the same committed operation intent with the same scoped idempotency key after restart, a new transport request ID and ambient execution-policy drift | Return the *historical* committed receipt; no new permit, fresh **execution** authorization claim or effect; read visibility is independently checked |
| EG-S20 | Nontransactional-adapter simulation: crash after effect but before receipt | `OUTCOME_UNKNOWN` until observation/reconciliation; no blind re-execution |
| EG-S21 | Authoritative transactional audit/effect journal cannot be written before local COMMIT | Transaction aborts; DENY/FAIL; zero committed workload effect, and no permit consumed as a successful effect |
| EG-S22 | Alter one persisted audit/evidence record | Independent verifier rejects tampered/stale record |
| EG-S23 | Coordinately rewrite all attacker-writable journal/projection records and re-chain, without unchanged trusted journal or independent terminal anchor | Return `ANCHOR_ABSENT_UNVERIFIABLE`; do **not** claim to detect an unobservable rewrite. Separately prove that projection-only tamper **is** detected against an unchanged trusted journal |
| EG-S24 | Source/fixture/evidence digest mismatch | No accepted promotion |
| EG-S25 | Fake Azure RBAC: inherit a permitted scope to a named descendant; attempt same operation on sibling or expressly denied descendant | Named permitted descendant may execute once; sibling and explicit-deny target DENY with zero effects |
| EG-S26 | Fake Databricks table access lacks required parent usage | DENY; zero effect |
| EG-S27 | Fake Databricks job initiator can start job but its distinct effective run identity lacks required data access | DENY data access and zero data effect; separate start/run-as permissions demonstrated |
| EG-S28 | Fake pipeline author attempts to alter independent approval control | DENY; zero effect |
| EG-S29 | Authorized rollback of a committed synthetic deployment to an exact prior target | PASS **only** if the previous fixture state is restored, independently measured and journaled; `RECOVERY_FAILED` is a failing test, covered honestly by EG-S39 |
| EG-S30 | Unsupported simulator action | Explicit `UNSUPPORTED_IN_SIMULATOR`; no effect |
| EG-S31 | Offline demo/test attempts socket/cloud/SDK access or unapproved subprocess/shell invocation | Fail test / refuse; no actual external call or unauthorized command; allowlisted local Python test children remain functional offline |
| EG-S32 | Legacy L0 seed and L1 contract proof after changes | No project regression |


## Adversarial behavior and interrupted execution


| Scenario | Question the test must answer | Required observation |
|---|---|---|
| EG-S33 | Malicious prompt content contains alleged override instructions | Treated only as data; no authority granted |
| EG-S34 | Tricky object identifiers, symlink and path traversal | Refuse unsafe path/scope; no unauthorized file mutation |
| EG-S35 | Attempt to swap approved artifact between decision and effect | Detect/reject TOCTOU; zero unintended effect |
| EG-S36 | Cross-process approval issuance/revocation/policy-change/execution race, including separate-file legacy approval state | All live effects serialize with authoritative approval/policy revisions; revoke/change-before-effect-commit blocks, effect-first remains historically authorized; no stale-file or mirror race escalation; otherwise `AUTHORITY_ATOMICITY_BLOCKED` |
| EG-S37 | Denied request through each supported effectful enterprise ingress | Same decision boundary; zero effect, no alternate path |
| EG-S38 | Read-only verifier replays evidence in a separate fresh process | Accurate independently re-derived verdict |
| EG-S39 | Recovery interrupted or state inconsistent | No false success; auditable `RECOVERY_FAILED`/`OUTCOME_UNKNOWN` |
| EG-S40 | Enterprise profile absent or corrupt | DENY protected operations; no permissive fallback |
| EG-S41 | Same key and trusted namespace reused with changed operation intent (payload, action, resource, environment, artifact, explicit policy/approval target), including concurrent and restart cases | `IDEMPOTENCY_CONFLICT`; no second idempotency row/permit/effect. Ambient policy drift or new transport ID alone is **not** an intent conflict (EG-S19) |
| EG-S42 | Unknown/illegal lifecycle state transition, late approval after cancellation/expiry, or second acceptance attempt | Refused; no unauthorized effect/promotion |
| EG-S43 | Kill local worker after prepared writes but **before** local SQLite effect COMMIT; restart | No effect-transaction permit consumption, protected effect or committed effect-journal row survives. A separately committed prior idempotency reservation **may** survive; replay must reconcile its truthful state without duplicate effect, and fresh execution (if needed) must pass current authorization |
| EG-S44 | Kill local worker after COMMIT before client observes outcome | Exactly one committed local effect; journal and replay remain consistent |
| EG-S45 | Attempt stale resource revision/CAS conflict under concurrency | At most one effective write; other request denied/retried only under new authorization |
| EG-S46 | Forge actor/approver by editing untrusted fixture request rather than trusted registry | Refused; authority remains external to request |
| EG-S47 | Mutate a self-reported green evidence summary but not underlying state | Independent verifier rejects mismatch/forged report when bound to known trusted evidence; otherwise returns `UNVERIFIABLE` |
| EG-S48 | Corrupt/truncate durable permit or journal state | Fail closed; no silent grant, unsafe replay or false success |


## Isolation, hostile inputs and trustworthy acceptance


| Scenario | Question the test must answer | Required observation |
|---|---|---|
| EG-S49 | Disposable-fixture negative control demonstrates same-user direct-file access can bypass Python gateway when OS permissions allow | Document `HOST_ISOLATION_UNVERIFIED`, distinguish API enforcement from host isolation; no bank-grade bypass claim |
| EG-S50 | Attempt to substitute a mock for a live provider and claim enterprise integration | Explicitly refused; no cloud readiness/promotion |
| EG-S51 | Refuse unknown schema fields, duplicate JSON keys, type confusion and noncanonical identity | No permit; zero protected effect |
| EG-S52 | Forge claimed human approval by supplying same fixture-controller identity/issuer in an untrusted request | Refuse invented human identity; mark fixture-trusted identity only, never production authentication |
| EG-S53 | Exfiltration attempt through output, logs, filename, or test exception | Synthetic-only data, bounded redaction and safe errors; no network |
| EG-S54 | Corrupt policy or fixture between authorization and execution | Final revalidation refuses; no unauthorized effect |
| EG-S55 | Test malicious report with fake run commands, fake SHA, and copied expected results | Reject mismatched source/measurements; claimed execution lacking independently trusted harness capture is `UNVERIFIABLE`, not proven executed |
| EG-S56 | Denied request has an auditable refusal but does not alter protected workload | Zero workload effect; expected governance metadata record present; both measured separately |
| EG-S57 | Crash after SQLite COMMIT before append-only audit projection | Authoritative committed journal survives; projection rebuild is idempotent; no duplicate logical effect |
| EG-S58 | Tenant A attempts reading/using tenant B permit, approval, idempotency record, **historical receipt**, journal or resource | DENY; no tenant-B information disclosed or mutation; no cross-tenant replay |
| EG-S59 | Oversized/nested/malformed payload and terminal/control-character log injection | Bounded fail-closed refusal; no workload effect; safe structured audit record |
| EG-S60 | Revoke and execute with opposite commit order, including crash/retry | Revoke-first blocks; effect-first remains historically valid; journal ordering verified |
| EG-S61 | Deterministic seeded model-based sequence with retries, policy drift and crashes | PASS **only** if the independent state-machine oracle agrees with persisted effects for every executed seed; a discrepancy is FAIL, with a durable minimized counterexample |
| EG-S62 | Verifier loses source identity or lacks **both** an unchanged independently trusted journal and an independently held terminal anchor | No forged ACCEPT; explicit `UNVERIFIABLE`/`STALE`. Missing a terminal anchor alone does **not** forbid detecting projection mismatch against an unchanged trusted journal |
| EG-S63 | Downstream JSONL/audit projection becomes unavailable **after** a successful local SQLite COMMIT | Protected effect remains committed exactly once with authoritative journal; `AUDIT_PROJECTION_PENDING` blocks final acceptance until idempotent repair; no double execution |
| EG-S64 | Trusted observer captures terminal journal/chain head and record count **before** attacker rewrites both authoritative journal and projection; attacker edits suffix and re-chains all writable evidence | Independent verifier compares against separately retained pre-tamper terminal anchor and rejects; without a surviving independent trusted reference returns `UNVERIFIABLE`, never forged success |
| EG-S65 | Previously authorized principal has since been disabled or lost historical-receipt read permission; it knows the correct original key, actor ID and payload, and retries an old committed operation | Deny or strictly redact receipt disclosure under independently evaluated **current caller** authentication/read policy; original committed effect and journal remain intact; no permit/effect replay, no sensitive metadata leak |
| EG-S66 | A pending independent approval is issued for exactly the reserved operation intent, then competes with cancellation/expiry and a changed policy | Only an authenticated, independently granted, still-valid pending request can transition to `AUTHORIZED` after fresh policy checks; approval alone makes no workload effect; cancel/expire-first and policy-invalid cases refuse, no revival or duplicate execution |


These scenarios test the *declared offline enforcement boundary*. For each executed scenario, the eventual evidence must separately capture its expected result and independently measured result, before/after workload effects, governance-metadata changes, retained source and fixture digests, verifier identity, test execution provenance, and any uncertainty or blocker. A denied operation counts as a successful **safety test** only when denial and lack of unauthorized protected effect are measured. An `UNVERIFIABLE` negative control may demonstrate an honest evidence limitation; it does not authenticate the disputed history.

---

# Appendix C — Diagram Register for the Illustrated PDF

The eighteen inline `[PLACE DIAGRAM HERE: ...]` passages are production briefs for illustrations that do not yet exist. Their numbering follows the document sequence: **Figures 1–3** establish purpose and trust; **4–7** explain requests, policies, approvals and permits; **8–11** explain retries, transactions, uncertainty and evidence; **12–14** illustrate tenants, simulations and recovery; **15–18** explain safety properties, worked stories, progressive verification and the external readiness boundary.

For the illustrated PDF, use one consistent visual language. Render a **solid arrow** for a proposed or permitted action, a **dashed arrow** for audit or evidence flow, a **thick boundary** where independent authority or an atomic transaction begins, and a **stop symbol** where protected execution is refused. Give every figure a short caption naming the lesson rather than repeating all its labels. Use legible contrasts and descriptive labels; never rely on green or red alone to imply that software has actually passed a test.

Trust boundaries and transactional boundaries must remain visible even in simplified illustrations. If a figure depicts synthetic infrastructure, label it **OFFLINE SIMULATION** and do not use real provider logos in a way that would imply an actual integration. Human-approval symbols in this reference should communicate *separate trusted identities*, not cryptographic signatures or live identity verification. A useful illustration answers the same four questions the sections ask: *what was proposed, what was permitted, what changed, and how do we know?*

---

# Appendix D — Source Alignment and Evidence Status

The architecture and proof obligations described in this document follow the supplied **Enterprise Governance Offline Python Evolution Master v7.0** design: a single authoritative governance path; strict identity, policy, approval and permit contracts; an offline Python enforcement boundary; eight safety invariants; nine work stages including EG-05A; and 66 mandatory acceptance scenarios. The text converts those requirements into an explanatory learning narrative rather than presenting repository-specific instructions or claiming completed work.

The scope remains an **offline, synthetic enterprise reference**. This document does not provide new engineering authorization, evidence that a code path ran, evidence of a genuine human approval, verification of Azure or Databricks behavior, or an institutional production acceptance. The scenario outcomes are expected behaviors, never reported results.
