# Universal Job Post Template for Resume Creation — ATS Checklist-Aligned 10/10 Version v6

## Purpose

Use this template to convert **any job posting** into a structured, candidate-agnostic **job blueprint** from which a truthful, targeted, parser-friendly, ATS-compatible resume can later be created.

This template does **not** evaluate whether a candidate is a good fit. It captures what the job requires, what the posting implies, what is missing, what screening systems may look for, and what a future resume must prove using verified candidate evidence.

This version is aligned with a full ATS resume submission system: posting extraction, role-dependence, evidence-depth labeling, semantic matching, hard-stop gates, application consistency, public-profile consistency, metric defensibility, and final file/package checks.


## v6 Upgrade Standard

This version adds explicit requirement traceability, machine-usable validation rules, strict field completion states, gap-filling hierarchy, full ATS checklist acceptance testing, a final resume-generation readiness gate, and an enforcement layer that converts the uploaded ATS checklist into direct template obligations. It is intended to work as both:

1. a human-fillable job-post blueprint; and
2. an instruction template for an LLM or resume-generation workflow.

A completed blueprint is not acceptable unless every major ATS checklist requirement is either represented in a field, represented in a gate, or explicitly marked not applicable.

---

# 0. Operating Standard

## 0.1 Candidate-Agnostic Rule

This template describes the **job**, not the candidate.

Do not insert candidate experience, candidate skills, candidate projects, candidate metrics, or candidate claims into the template. Candidate evidence is added only later through a separate fact bank and evidence map.

## 0.2 Required Output Behavior

A completed job blueprint must make it possible to generate a resume that is:

- parser-friendly for classic ATS systems;
- understandable to AI / semantic screening systems;
- credible to recruiters, hiring managers, specialist interviewers, and fraud reviewers;
- targeted to the exact job without looking artificially reverse-engineered;
- consistent with a future candidate fact bank, LinkedIn, GitHub, portfolio, application forms, public profiles, and interview answers;
- free of hidden text, white-text keywords, keyword dumps, visible requirement-mapping sections, or ATS bait;
- honest about missing, partial, inferred, project-only, prototype-only, exposure-only, or unsupported areas.

## 0.3 Source Labels

Every important extracted field must use one of these labels.

| Label | Meaning | Resume-use rule |
|---|---|---|
| Directly Stated | Explicitly appears in the job posting | Can be treated as a real requirement |
| Repeated / Emphasized | Appears multiple times or is central to the posting | Should receive higher resume priority if candidate evidence exists |
| Strongly Implied | Not directly stated, but required by role logic, stack, domain, or responsibility | Can guide positioning, but must not become a false claim |
| Weakly Implied | Plausible but uncertain | Use only as a caution, question, or low-confidence inference |
| Missing | Not provided by the posting | Leave unknown or flag as missing |
| Knockout | Hard requirement: authorization, location, certification, clearance, language, license, travel, schedule, salary constraint, or degree | Must be checked before resume generation |
| Do Not Assume | Risky or unsupported inference | Must not be added unless verified elsewhere |

## 0.4 Priority Labels

| Priority | Meaning |
|---|---|
| Critical / Must-Have | Required for screening or role performance |
| High | Strongly preferred or central to success |
| Medium | Useful but not central |
| Low | Nice-to-have or background context |
| Role-Dependent | Required only if the role, industry, jurisdiction, seniority, or application form makes it relevant |
| Unknown | Posting does not provide enough evidence |

## 0.5 Future Candidate Evidence-Depth Labels

These labels are reserved for the later candidate-matching stage. They must be used consistently across resume, evidence map, skills section, application answers, LinkedIn, GitHub, portfolio, and interview notes.

| Evidence depth | Meaning | Resume treatment |
|---|---|---|
| Paid Production | Used in a real paid role on a live system, product, workflow, client deliverable, or operational process | Can support summary, skills, and experience bullets if accurately scoped |
| Professional Use | Used at work, but not necessarily owned end-to-end or used as a main responsibility | Can be listed and described, but avoid expert or ownership wording |
| Project / Portfolio | Built or used outside paid production | Must be labeled as project evidence |
| Prototype / PoC | Exploratory build, demo, feasibility test, or temporary proof | Must not be presented as production depth |
| Lab / Learning / Exposure | Studied, tested briefly, or used without delivery responsibility | Usually should not support must-have claims |
| Certification / Education | Supported by formal learning or credential | Must not imply work experience unless work evidence exists |
| Not Supported | No verified evidence | Must not be claimed |

## 0.6 Integrity Rules

A future resume generated from this blueprint must not:

- invent experience;
- inflate project work into paid production experience;
- inflate exposure into professional depth;
- convert adjacent experience into direct experience without evidence;
- rewrite job titles into unrelated target titles;
- use hidden text, white text, keyword stuffing, keyword dumps, or visible requirement-mapping sections;
- claim metrics without a source, baseline/context, mechanism, and ownership chain;
- present application answers that are stronger than resume evidence;
- contradict LinkedIn, GitHub, portfolio, application answers, public profiles, prior resume versions, background-check materials, or the candidate fact bank.


---

## 0.7 Mandatory Traceability Rule

Every extracted job requirement must be traceable through this chain:

```text
Raw posting wording
→ normalized requirement
→ priority / role-dependence label
→ future evidence standard
→ permitted resume placement
→ prohibited overstatement boundary
→ validation gate
```

If any link in this chain is missing, the blueprint is incomplete.

## 0.8 Requirement Status Vocabulary

Use these statuses consistently.

| Status | Meaning | Later resume implication |
|---|---|---|
| Covered by future evidence | Candidate fact bank later contains real proof | May be used if wording is accurate |
| Partially covered | Evidence exists but does not fully meet depth, domain, tool, seniority, or scope | Use careful scoped wording or omit from top claims |
| Project-supported | Evidence exists only in project/portfolio work | Label as project evidence; do not imply paid production |
| Education/certification-supported | Evidence comes from formal study or credential | Do not imply work delivery unless work proof exists |
| Not supported | No verified candidate evidence later | Do not claim |
| Unknown until application form | Posting is unclear or application may ask more | Flag for form-answer consistency review |
| Knockout unresolved | Hard requirement is unclear or unverified | Do not generate final resume until resolved |

## 0.9 Machine-Usable Output Requirement

When this template is completed, it must be usable to produce the following internal objects:

- `job_blueprint`: normalized view of the job posting;
- `requirement_register`: all must-have, preferred, knockout, repeated, implied, and risk requirements;
- `keyword_map`: exact terms, variants, acronyms, synonyms, placement rules, and risk labels;
- `evidence_request_map`: what future candidate evidence would be needed for each requirement;
- `gap_register`: missing, unclear, partial, unsupported, and do-not-assume areas;
- `resume_generation_brief`: what a later resume should emphasize, weaken, omit, and validate;
- `submission_validation_plan`: parse checks, metadata checks, public-profile checks, application-answer checks, and interview-defensibility checks.

## 0.10 Non-Negotiable Include List

A 10/10 completed blueprint must include all of the following:

- raw posting text;
- posting metadata;
- must-have requirements;
- preferred requirements;
- knockout criteria;
- logistics constraints;
- repeated terms;
- seniority signals;
- role-dependence decisions;
- technical stack map;
- domain/regulatory map;
- ATS exact keyword map;
- semantic keyword/synonym map;
- keyword placement plan;
- responsibility-to-bullet target map;
- evidence-depth expectations;
- metric integrity rules;
- gap and missing-information register;
- anti-inflation boundaries;
- public-profile and fact-bank consistency requirements;
- application-answer consistency requirements;
- final output package checks;
- hard-stop gate;
- final scoring rubric;
- traceability matrix.

# 1. Job Posting Input Record

## 1.1 Posting Metadata

| Field | Value |
|---|---|
| Source URL | [URL or source] |
| Company | [Company name] |
| Exact job title | [Exact title] |
| Posting date | [Date if available] |
| Date captured | [Date/time copied] |
| Location | [Location] |
| Work model | [Remote / Hybrid / On-site / Unclear] |
| Employment type | [Full-time / Part-time / Contract / Internship / Freelance / Temporary / Unclear] |
| Compensation range | [If available] |
| Application deadline | [If available] |
| Recruiter / contact | [If available] |
| Application method | [ATS / email / recruiter / portal / referral / unknown] |
| File format requested | [PDF / DOCX / plain text / form only / unclear] |

## 1.2 Raw Job Posting Preservation

Paste the full raw job posting here before extraction.

```text
[Paste full job posting exactly as found]
```

## 1.3 Posting Reliability Notes

| Issue | Present? | Notes |
|---|---:|---|
| Posting appears incomplete | [Yes/No] | [Notes] |
| Requirements are vague | [Yes/No] | [Notes] |
| Title and responsibilities conflict | [Yes/No] | [Notes] |
| Seniority is unclear | [Yes/No] | [Notes] |
| Technologies are missing, broad, or outdated | [Yes/No] | [Notes] |
| Location / authorization unclear | [Yes/No] | [Notes] |
| Compensation / seniority mismatch | [Yes/No] | [Notes] |
| Possible repost / stale posting | [Yes/No] | [Notes] |
| Application questions may contain extra requirements | [Yes/No] | [Notes] |

---

# 2. Usage Mode Selection

Select the operating mode before using the blueprint.

| Situation | Mode | Required blueprint sections |
|---|---|---|
| Quick application to a normal role | Fast pass | Sections 1, 3, 4, 5, 10, 14, 18, 19, 22 |
| High-value application | Full pass | Sections 1 through 24 |
| New resume template | Structure pass | Sections 3, 4, 10, 14, 16, 18, 19, 23 |
| Major role pivot | Credibility pass | Sections 4, 5, 6, 8, 9, 11, 13, 17, 18 |
| Multiple tailored resume versions | Consistency pass | Sections 15, 17, 18, 19, 22, 23 |

Do not use the template to force a resume into a role. Use it to decide whether the role fit is strong, partial, project-supported, education-supported, or unsupported.

---

# 3. Role Identity

| Field | Filled Value | Source Label | Priority | Notes |
|---|---|---|---|---|
| Exact job title | [ ] | [ ] | [ ] | [ ] |
| Normalized role title | [ ] | [ ] | [ ] | [ ] |
| Alternative equivalent titles | [ ] | [ ] | [ ] | [ ] |
| Role family | [Engineering / Product / Data / Design / Sales / Operations / Other] | [ ] | [ ] | [ ] |
| Specialty | [Backend / Full-stack / AI / Platform / QA / PM / BI / Mobile / etc.] | [ ] | [ ] | [ ] |
| Seniority level | [Junior / Intermediate / Senior / Lead / Principal / Manager / Director / Executive / Unknown] | [ ] | [ ] | [ ] |
| Individual contributor or manager | [IC / Manager / Hybrid / Unknown] | [ ] | [ ] | [ ] |
| Company type | [Startup / Scale-up / Enterprise / Agency / Consulting / Public sector / Nonprofit / Unknown] | [ ] | [ ] | [ ] |
| Industry / sector | [ ] | [ ] | [ ] | [ ] |
| Team / department | [ ] | [ ] | [ ] | [ ] |
| Reporting line | [ ] | [ ] | [ ] | [ ] |

---

# 4. Posting Extraction Pass

## 4.1 Must-Have Requirements

Split compound requirements into separate rows. Example: `Python, TypeScript, and AWS` becomes Python, TypeScript, and AWS as separate checks.

| Requirement | Category | Exact posting wording | Source label | Priority | Resume evidence needed later | Risk if unsupported |
|---|---|---|---|---|---|---|
| [Requirement] | [Skill / Tool / Domain / Years / Education / Location / Authorization / Certification / Other] | [Exact wording] | Directly Stated | Critical | [What future resume must prove] | [Low/Medium/High] |

## 4.2 Preferred Requirements

| Requirement | Category | Exact posting wording | Source label | Priority | Resume evidence needed later | Include only if supported? |
|---|---|---|---|---|---|---|
| [Requirement] | [ ] | [ ] | [ ] | [High/Medium/Low] | [ ] | [Yes] |

## 4.3 Knockout Criteria

| Knockout criterion | Exact wording | Candidate-answer dependency later | Resume implication | Status |
|---|---|---|---|---|
| Work authorization | [ ] | Must match application answer | Include only if relevant and exact | [Clear/Unclear/Missing] |
| Location / timezone | [ ] | Must match application answer | Include if materially relevant | [Clear/Unclear/Missing] |
| Relocation / travel | [ ] | Must match application answer | Do not imply if false | [Clear/Unclear/Missing] |
| Clearance / citizenship | [ ] | Must be exact | Do not claim eligibility unless true | [Clear/Unclear/Missing] |
| Degree / certification / license | [ ] | Must be exact | Do not imply equivalent if not accepted | [Clear/Unclear/Missing] |
| Language / schedule / salary constraint | [ ] | Must be exact | Include only if relevant | [Clear/Unclear/Missing] |

## 4.4 Repeated, Emphasized, and Risk Terms

| Term | Frequency / emphasis | Context | Resume priority | Credibility risk |
|---|---:|---|---|---|
| [Term] | [Count or qualitative emphasis] | [Where it appears] | [Critical/High/Medium/Low] | [Low/Medium/High] |

---

# 5. Role-Dependence Pass

Use this section to decide which specialized checks become critical for this role.

| Role or situation | Checks that become Critical | Do not add unless true | Applies? |
|---|---|---|---:|
| AI / ML / LLM role | AI/ML depth, evaluation, data, model, RAG, agent, fine-tuning, deployment, responsible AI if stated | Training, fine-tuning, evaluation, governance, agentic systems | [Yes/No] |
| Cloud / platform role | Platform ownership, internal consumers, governance, standards, reliability, CI/CD, observability | Kubernetes, MLOps, platform engineering, SRE ownership | [Yes/No] |
| Product / PM role | Discovery, prioritization, roadmap, success metrics, tradeoffs, user/customer evidence | GTM, pricing, packaging, revenue, executive strategy | [Yes/No] |
| Regulated role | Real compliance regime, controls, audit evidence, domain-specific standards | Healthcare, defense, finance, clearance, patient safety, SaMD, SOC 2, PCI-DSS | [Yes/No] |
| Client-facing / consulting role | External stakeholder ownership, client interaction type, post-go-live responsibility | SOWs, QBRs, account ownership, pre-sales, expansion strategy | [Yes/No] |
| Frontend / mobile / QA / BI specialist role | Discipline-specific artifacts and recurring practice | Specialist identity from general engineering alone | [Yes/No] |
| U.S., cross-border, clearance, or immigration-sensitive role | Exact work authorization, location, sponsorship, citizenship/clearance wording | Unrestricted authorization, clearance, eligibility, relocation claims | [Yes/No] |

---

# 6. Role Purpose, Business Problem, and Success Definition

## 6.1 Plain-English Role Purpose

**What this role exists to accomplish:**  
[Write 2–4 sentences explaining the actual purpose of the role.]

**Source label:** [Directly Stated / Strongly Implied / Weakly Implied / Missing]

## 6.2 Business Problem Being Solved

| Business / operational problem | Evidence from posting | Source label | Priority |
|---|---|---|---|
| [Problem 1] | [Text or paraphrase] | [ ] | [ ] |
| [Problem 2] | [Text or paraphrase] | [ ] | [ ] |
| [Problem 3] | [Text or paraphrase] | [ ] | [ ] |

## 6.3 Success Definition

| Success signal | Metric or evidence likely expected | Source label | Priority | Resume proof needed later |
|---|---|---|---|---|
| [Delivery speed / reliability / revenue / accuracy / customer success / compliance / etc.] | [Likely evidence] | [ ] | [ ] | [ ] |

---

# 7. Technical, Tool, and Method Requirements

## 7.1 Programming Languages

| Language | Required/preferred | Source label | Expected depth | Resume evidence needed later | Keyword placement priority |
|---|---|---|---|---|---|
| [Language] | [ ] | [ ] | [Basic / hands-on / production / architecture] | [ ] | [Summary / Skills / Experience / Project / Omit] |

## 7.2 Frameworks, Libraries, Platforms, and SaaS

| Tool / framework / platform | Category | Required/preferred | Source label | Expected depth | Resume evidence needed later | Inflation risk |
|---|---|---|---|---|---|---|
| [Tool] | [Framework / SaaS / API / platform / library] | [ ] | [ ] | [ ] | [ ] | [Low/Medium/High] |

## 7.3 Databases, Data, Cloud, Infrastructure, DevOps

| Requirement | Category | Required/preferred | Source label | Expected depth | Resume evidence needed later | Do-not-overstate rule |
|---|---|---|---|---|---|---|
| [Requirement] | [Database / data pipeline / cloud / CI/CD / containers / monitoring / IaC / deployment] | [ ] | [ ] | [ ] | [ ] | [ ] |

## 7.4 AI / ML / Analytics / Automation Requirements

| Requirement | Category | Required/preferred | Source label | Expected depth | Resume evidence needed later | Must not be confused with |
|---|---|---|---|---|---|---|
| [Requirement] | [LLM / RAG / agents / fine-tuning / evaluation / analytics / automation / ML lifecycle] | [ ] | [ ] | [ ] | [ ] | [Adjacent but different term] |

## 7.5 Testing, Quality, Security, Compliance

| Requirement | Category | Required/preferred | Source label | Expected depth | Resume evidence needed later |
|---|---|---|---|---|---|
| [Requirement] | [Testing / QA / security / compliance / privacy / reliability / performance] | [ ] | [ ] | [ ] | [ ] |

---

# 8. Non-Technical Requirements

| Requirement | Category | Source wording | Source label | Priority | Resume evidence needed later |
|---|---|---|---|---|---|
| [Requirement] | [Communication / collaboration / leadership / ownership / problem-solving / business judgment / documentation / presentation] | [ ] | [ ] | [ ] | [ ] |

---

# 9. Seniority, Scope, and Authority Analysis

## 9.1 Seniority Signals

| Signal | Evidence from posting | Implied seniority | Resume proof needed later | Risk if overstated |
|---|---|---|---|---|
| Ownership | [ ] | [ ] | [ ] | [ ] |
| Architecture / design | [ ] | [ ] | [ ] | [ ] |
| Leadership / mentoring | [ ] | [ ] | [ ] | [ ] |
| People management | [ ] | [ ] | [ ] | [ ] |
| Executive / strategic scope | [ ] | [ ] | [ ] | [ ] |
| Scale / complexity | [ ] | [ ] | [ ] | [ ] |
| Stakeholder level | [ ] | [ ] | [ ] | [ ] |

## 9.2 Authority Type Required

| Authority type | Required? | Evidence from posting | Future resume proof standard |
|---|---:|---|---|
| Individual execution | [Yes/No] | [ ] | Concrete delivery evidence |
| Technical ownership | [Yes/No] | [ ] | Decisions, tradeoffs, systems, outcomes |
| Project ownership | [Yes/No] | [ ] | Scope, coordination, delivery, result |
| Mentoring / technical leadership | [Yes/No] | [ ] | Who was guided, how, and outcome |
| People management | [Yes/No] | [ ] | Hiring, reviews, staffing, performance, team development |
| Product decision authority | [Yes/No] | [ ] | Prioritization, roadmap, metrics, discovery |
| Commercial authority | [Yes/No] | [ ] | Revenue, pricing, expansion, account ownership, pipeline |
| Compliance / governance authority | [Yes/No] | [ ] | Controls, audit evidence, standards, approvals |

---

# 10. Domain, Industry, and Regulatory Context

| Domain requirement | Exact wording or inference | Source label | Priority | Resume proof needed later | Do-not-claim boundary |
|---|---|---|---|---|---|
| [Domain] | [ ] | [ ] | [ ] | [ ] | [What must not be inferred] |

## 10.1 Domain Claim Controls

- Do not turn employer industry into specialized domain expertise unless the work directly supports it.
- Do not bridge strict domains by analogy.
- Do not claim regulated, audit-ready, compliance, governance, healthcare, defense, finance, payments, public-sector, telecom, education, or safety-critical depth unless the posting requires it and the future evidence supports it.

---

# 11. ATS and Semantic Keyword Map

## 11.1 Exact Keywords

| Exact keyword | Requirement category | Priority | Required placement | Evidence needed later |
|---|---|---|---|---|
| [Keyword] | [Tool / method / domain / responsibility / seniority / logistics] | [ ] | [Summary / Skills / Experience / Project / Education / Application answer] | [ ] |

## 11.2 Synonyms, Variants, and Acronyms

| Posting term | Equivalent terms | Use both acronym and full phrase? | Placement rule |
|---|---|---:|---|
| [Term] | [Synonyms] | [Yes/No] | [Natural use only] |

## 11.3 Keyword Risk Classification

| Keyword | Safe if evidence exists? | Risk if unsupported | Notes |
|---|---:|---|---|
| [Keyword] | [Yes/No] | [Low/Medium/High] | [ ] |

## 11.4 Keyword Placement Plan

| Keyword / phrase | Summary | Skills | Experience bullets | Projects | Education / certification | Application form | Use rule |
|---|---:|---:|---:|---:|---:|---:|---|
| [Keyword] | [Yes/No] | [Yes/No] | [Yes/No] | [Yes/No] | [Yes/No] | [Yes/No] | [Only where supported] |

Placement standard: important keywords must appear in context, not only in a skills list. A shorter supported keyword set is better than a larger unsupported keyword list.

---

# 12. Responsibility-to-Resume Mapping

## 12.1 Responsibility Extraction

| Responsibility from posting | Exact wording | Priority | Required proof type | Possible resume section later |
|---|---|---|---|---|
| [Responsibility] | [ ] | [ ] | [System / project / process / stakeholder / metric / deliverable] | [Summary / Experience / Project / Skills] |

## 12.2 Resume Bullet Target Map

| Responsibility | Bullet category | Bullet must show | Evidence depth needed | Unsafe wording to avoid |
|---|---|---|---|---|
| [Responsibility] | [Technical execution / ownership / business impact / collaboration / problem solving / leadership] | [Action + system + tool + scope + outcome] | [Paid Production / Professional Use / Project / etc.] | [Unsupported verbs or claims] |

## 12.3 Bullet Evidence Quality Requirements

A future bullet should be allowed only if it can answer:

- What problem existed?
- What action was taken?
- What tools, methods, systems, or processes were used?
- What was the candidate’s actual contribution?
- What was the scope?
- What changed as a result?
- Can the claim survive interview probing?

---

# 13. Metrics and Outcome Planning

## 13.1 Likely Outcome Categories

| Outcome category | Appears in posting? | Priority | Future metric/evidence type | Notes |
|---|---:|---|---|---|
| Time saved | [Yes/No] | [ ] | [ ] | [ ] |
| Cost reduced | [Yes/No] | [ ] | [ ] | [ ] |
| Revenue influenced | [Yes/No] | [ ] | [ ] | [ ] |
| Performance improved | [Yes/No] | [ ] | [ ] | [ ] |
| Accuracy improved | [Yes/No] | [ ] | [ ] | [ ] |
| Error rate reduced | [Yes/No] | [ ] | [ ] | [ ] |
| Manual work reduced | [Yes/No] | [ ] | [ ] | [ ] |
| Deployment speed increased | [Yes/No] | [ ] | [ ] | [ ] |
| Reliability improved | [Yes/No] | [ ] | [ ] | [ ] |
| User adoption improved | [Yes/No] | [ ] | [ ] | [ ] |
| Compliance risk reduced | [Yes/No] | [ ] | [ ] | [ ] |

## 13.2 Metric Integrity Requirements

A future metric is allowed only if it has:

- source: logs, analytics, business KPI, model evaluation, ticket data, user data, client report, team estimate, or documented baseline;
- baseline/context;
- measurement method;
- plausible ownership chain;
- candidate contribution;
- mechanism explaining why the result happened.

Do not use polished or large metrics such as 99.9% uptime, sub-second latency, 100K+ users, millions of events, 30–50% reductions, or revenue impact unless fully defensible.

---

# 14. Gap and Missing Information Handling

## 14.1 Missing From the Job Posting

| Missing item | Why it matters | How to handle later |
|---|---|---|
| [Unclear seniority / tool / domain / success metric / reporting line / authorization / location / etc.] | [ ] | [Leave unknown / infer weakly / ask recruiter / omit / handle in application answer] |

## 14.2 Gap-Filling Rules

| Gap type | Allowed handling | Not allowed |
|---|---|---|
| Missing technology detail | Infer only if stack logic strongly supports it and label as implied | Present as directly required |
| Missing seniority | Use responsibility and authority signals | Inflate title or scope |
| Missing success metric | Identify likely outcome categories | Invent numbers |
| Missing domain detail | Mark unknown or weakly implied | Claim strict domain expertise |
| Candidate evidence gap later | Mark partial, project-supported, education-supported, or unsupported | Cosmetic patching or unsupported claim |

## 14.3 Prohibited Assumptions

Do not assume:

- a candidate is a strong fit;
- project evidence equals paid production experience;
- learning exposure equals professional use;
- similar technology equals required technology;
- collaboration equals ownership;
- documentation equals architecture;
- internal stakeholder work equals client/account ownership;
- AI-assisted development equals AI engineering;
- LLM application work equals model training or fine-tuning;
- Docker equals Kubernetes or platform ownership;
- cloud usage equals cloud architecture ownership;
- regulated-industry employer equals compliance ownership.

---

# 15. Future Candidate Matching Interface

This section is filled only after the job blueprint is complete and a verified candidate fact bank is available.

## 15.1 Requirement-to-Evidence Map

| Job requirement | Required/preferred/knockout | Candidate proof point | Evidence type | Depth | Risk level | Resume action |
|---|---|---|---|---|---|---|
| [Requirement] | [ ] | [Verified fact-bank item] | [Paid work / project / education / certification / none] | [Paid Production / Professional Use / Project / PoC / Exposure / Not Supported] | [Low/Medium/High] | [Keep / add / weaken / omit / answer carefully in form] |

## 15.2 Resume Action Rules

| Action | When allowed |
|---|---|
| Keep | Current resume already supports the requirement clearly |
| Add | Verified fact bank contains truthful evidence |
| Weaken | Evidence exists but wording overstates depth, ownership, seniority, or scope |
| Omit | Requirement is unsupported or would require cosmetic patching |
| Answer carefully in form | Application asks directly about a partial, project-only, education-only, or unsupported requirement |

---

# 16. Resume Positioning Brief

## 16.1 Top Resume Priorities

| Priority rank | Resume priority | Requirement basis | Evidence needed later | Section placement |
|---:|---|---|---|---|
| 1 | [ ] | [ ] | [ ] | [Top half page one / Experience / Skills / Projects / Education] |
| 2 | [ ] | [ ] | [ ] | [ ] |
| 3 | [ ] | [ ] | [ ] | [ ] |
| 4 | [ ] | [ ] | [ ] | [ ] |
| 5 | [ ] | [ ] | [ ] | [ ] |

## 16.2 Top Half of Page One Requirements

The top half of page one should later show:

- strongest credible match evidence;
- exact target role family;
- must-have keywords supported by evidence;
- strongest system, product, process, domain, or outcome proof;
- no unsupported headline claims;
- no keyword dump.

## 16.3 Summary Direction

| Summary element | Include? | Requirement basis | Required evidence depth | Risk control |
|---|---:|---|---|---|
| Target role identity | [Yes/No] | [ ] | [ ] | Must match work history later |
| Core technical stack | [Yes/No] | [ ] | [ ] | Do not list unsupported tools |
| Domain / industry | [Yes/No] | [ ] | [ ] | Do not infer strict domain expertise |
| Leadership / ownership | [Yes/No] | [ ] | [ ] | Must match authority evidence |
| Business outcome | [Yes/No] | [ ] | [ ] | Must have defensible mechanism |

---

# 17. Credibility and Authenticity Controls

## 17.1 Professional Identity Control

A future resume may change emphasis for the posting, but it must not create a different person.

| Risk | Control |
|---|---|
| Resume looks perfectly matched to every posting | Keep stable identity; change emphasis only |
| Summary contains tools not proven below | Move tools into skills or remove |
| Project section stronger than paid work | Label projects honestly and avoid senior production claims |
| Application answer stronger than resume evidence | Align answer with strongest real evidence |
| LinkedIn/GitHub mismatch | Weaken, clarify, or update public profile truthfully |

## 17.2 Claims That Require Strong Evidence

Use these only when the future evidence supports them:

- led;
- owned;
- architected;
- directed;
- optimized;
- production-grade;
- expert;
- deep expertise;
- platform ownership;
- product ownership;
- client strategy;
- revenue impact;
- compliance ownership;
- model training;
- fine-tuning;
- end-to-end ML lifecycle;
- people management;
- executive decision authority.

---

# 18. Resume Structure Guidance Derived From Job Posting

Recommended future resume sections:

| Section | Required? | Purpose | ATS / credibility rule |
|---|---:|---|---|
| Contact | Yes | Identity and contactability | Plain selectable text; not header/footer/image-only |
| Target headline / title | Usually | Role alignment | Must be supported by work history |
| Summary | Usually | Fast semantic match | No unsupported tools or inflated claims |
| Skills | Usually | Parser-friendly keyword capture | Skills must also appear in context where important |
| Work Experience | Yes | Main evidence | Employer, title, dates, location, bullets attached correctly |
| Projects | Role-dependent | Support non-work evidence | Label project/prototype/lab honestly |
| Education | Yes | Degree / credential evidence | Exact names and dates |
| Certifications | Role-dependent | Formal credential evidence | Current, precise, not overstated |
| Publications / portfolio / GitHub | Role-dependent | Public proof | Must not contradict claimed depth |

## 18.1 ATS Parsing Requirements for Future Resume

The future resume should:

- use standard headings;
- avoid tables, text boxes, sidebars, icons, graphics, scanned text, or complex columns unless extraction is tested;
- keep contact information as plain selectable text;
- keep dates, titles, employers, and bullets attached correctly after plain-text extraction;
- include exact required keywords in normal text;
- avoid hidden text, white text, keyword dumps, and visible requirement-mapping sections;
- produce clean PDF/DOCX/plain-text extraction;
- have clean filename and metadata.

---

# 19. Application-Side and Cross-Version Consistency

## 19.1 Application-Side Requirements

| Application item | Posting requirement | Future answer must match | Risk |
|---|---|---|---|
| Screening questions | [ ] | Resume and fact bank | [Low/Medium/High] |
| Skill checkboxes | [ ] | Supported evidence only | [Low/Medium/High] |
| Work authorization | [ ] | Exact legal wording | [Low/Medium/High] |
| Location / relocation / travel | [ ] | Resume and actual availability | [Low/Medium/High] |
| Salary / notice / availability | [ ] | Stable application notes | [Low/Medium/High] |

## 19.2 Public-Profile and Fact-Bank Consistency

A future resume must be consistent with:

- master fact bank;
- LinkedIn;
- GitHub;
- portfolio;
- application forms;
- interview answers;
- prior resume versions;
- public profiles;
- background-check materials;
- file metadata.

| Consistency area | Required stability rule | Risk if inconsistent |
|---|---|---|
| Job titles | Fact-stable, not rewritten into unrelated titles | High |
| Dates | Same across versions | High |
| Employers | Same legal or public names | High |
| Education | Exact degree and school wording | High |
| Work authorization | Exact and legally safe | High |
| Tool depth | Same depth labels across versions | High |
| Metrics | Same source and attribution | High |
| Public projects | Must support, not contradict, claimed depth | Medium/High |

---

# 20. Hard-Stop Resume Generation Gate

Do not generate or submit a resume from this blueprint if any of these fail:

- [ ] Every Critical / Must-Have requirement has future evidence, or is honestly marked partial, unsupported, or omitted.
- [ ] Knockout criteria are identified before tailoring.
- [ ] Project-only, PoC-only, exposure-only, or learning evidence is not presented as paid production depth.
- [ ] Summary/headline claims do not outrun evidence.
- [ ] No hidden text, white-text keywords, keyword dumps, ATS bait, or visible requirement-mapping section is planned.
- [ ] Every strong metric has source, baseline/context, method, ownership chain, and mechanism.
- [ ] Application-form answers will not contradict the resume.
- [ ] LinkedIn, GitHub, portfolio, public profiles, prior versions, and fact bank can remain consistent.
- [ ] The resume will sound like a real work history, not a requirements-coverage document.
- [ ] Every strong claim can be defended in an interview.

Stop tailoring and do not submit when a must-have requirement can be covered only by exaggerating, relabeling, or implying unsupported depth.

---

# 21. Internal Scoring Rubric for the Completed Blueprint

Use this score to assess whether the completed job blueprint is ready to drive resume creation.

| Area | Weight | Pass standard |
|---|---:|---|
| Posting extraction completeness | 20% | Must-haves, preferred items, knockouts, repeated terms, risk terms, and logistics are captured |
| Role-dependence accuracy | 10% | Specialized role checks are activated only when relevant |
| ATS / keyword map quality | 15% | Exact terms, variants, placement rules, and risk labels are clear |
| Semantic / evidence planning | 20% | Every major requirement has a future proof standard and evidence-depth expectation |
| Credibility / anti-inflation controls | 15% | Unsupported assumptions and risky claims are explicitly blocked |
| Application / public consistency planning | 10% | Application answers, public profiles, fact bank, and metadata are accounted for |
| Resume-generation usability | 10% | The blueprint clearly tells a later resume generator what to emphasize, weaken, omit, and validate |

## 21.1 Score Interpretation

- **95–100:** Resume-generation ready.
- **90–94:** Strong, but fix the identified gaps before high-value applications.
- **80–89:** Usable only with manual review; likely missing controls.
- **Below 80:** Do not use for resume generation.

Scoring rule: the blueprint cannot score above 89 if any Critical requirement, knockout criterion, or evidence-depth control is missing. It cannot score above 79 if it permits inflated or unverifiable resume claims.

---

# 22. Final Output Package Check for Future Resume

When a resume is later generated from this blueprint, the final package must include:

| Output item | Required? | Standard |
|---|---:|---|
| Final PDF | Yes, unless ATS forbids | Opens correctly, text selectable, clean metadata |
| Final DOCX | Role-dependent | Available when ATS accepts or prefers DOCX |
| Plain-text extraction copy | Yes | Reads in correct order with sections, roles, dates, and bullets attached correctly |
| Evidence map | Internal only | Not submitted; maps every major requirement to proof or gap |
| Fact-bank trace | Internal only | Every claim traces to verified facts |
| Application-answer notes | Role-dependent | Answers match resume and fact bank |
| Clean filename | Yes | Employer-facing; no scores, failed-test notes, experiment labels, old employers, or unrelated target roles |

---

# 23. Final Completed Job Blueprint Summary

## 23.1 Role Summary

[One paragraph summarizing what this job really requires.]

## 23.2 Top 5 Screening Priorities

1. [Priority 1]
2. [Priority 2]
3. [Priority 3]
4. [Priority 4]
5. [Priority 5]

## 23.3 Top Required Technologies / Tools

- [Technology/tool 1]
- [Technology/tool 2]
- [Technology/tool 3]

## 23.4 Top Required Responsibilities

- [Responsibility 1]
- [Responsibility 2]
- [Responsibility 3]

## 23.5 Top Required Outcomes

- [Outcome 1]
- [Outcome 2]
- [Outcome 3]

## 23.6 Highest-Risk Missing or Unclear Areas

- [Missing/risky area 1]
- [Missing/risky area 2]
- [Missing/risky area 3]

## 23.7 Resume Generation Instruction

Create a targeted resume aligned with this role blueprint while using only verified candidate evidence. Do not invent experience, inflate evidence depth, add unsupported keywords, or create inconsistencies with the candidate fact bank, public profiles, application answers, or interview defensibility.


---

# 24. ATS Checklist Requirements Traceability Matrix

Use this matrix to verify that the completed job-post template covers the ATS checklist completely.

| ATS checklist requirement area | Where this template covers it | Required result |
|---|---|---|
| Posting extraction pass | Sections 1, 3, 4, 6, 7, 8, 9, 10 | Must-haves, preferred items, knockouts, logistics, seniority, tools, and domain requirements extracted |
| Role-dependence pass | Section 5 | Role-specific checks are activated only when relevant |
| Evidence-depth definitions | Sections 0.5, 15 | Future candidate evidence must be labeled by depth |
| Hard-stop submission gate | Section 20 | Resume generation stops if credibility, evidence, knockout, or consistency gates fail |
| Fast application checklist | Sections 16, 18, 19, 22 | Top-of-page fit, structure, parsing, application answers, and final package checks are prepared |
| Deep tailoring audit | Sections 11, 12, 13, 14, 17 | Keywords, bullets, metrics, gaps, authenticity, and anti-inflation controls are explicit |
| Evidence-map gate | Section 15 | Every major requirement maps to proof, partial proof, project proof, education proof, or unsupported status |
| Master fact-bank audit | Section 19 | Resume claims must trace to verified facts and remain stable across versions |
| Cross-version / public-profile consistency | Section 19 | LinkedIn, GitHub, portfolio, application forms, public profiles, and metadata must not contradict resume claims |
| Application-side ATS factors | Section 19 | Screening questions, checkboxes, authorization, logistics, and conversational AI answers must match evidence |
| Final authenticity check | Sections 17 and 20 | Resume must remain credible to recruiter, hiring manager, specialist interviewer, and fraud reviewer |
| Red-flag triage | Section 17 | Common trust-loss patterns are identified and blocked |
| Recommended final test sequence | Sections 20, 22, 25 | Parsing, extraction, keyword, semantic, evidence, metadata, application-answer, and interview-defensibility tests are required |
| Internal scoring rubric | Section 21 | Completed blueprint receives a quality score with caps for critical failures |
| Submission decision rule | Section 20 | No final resume should be submitted when hard-stop rules fail |
| Three-minute final decision check | Section 25 | Final completion checklist verifies no major requirement was skipped |
| Final output package check | Section 22 | PDF, DOCX, plain-text extraction, metadata, filename, evidence map, and fact-bank trace are accounted for |

## 24.1 Coverage Verdict

| Coverage question | Required answer before use |
|---|---|
| Does every ATS Critical item have a corresponding extraction field, gate, or validation rule? | Yes |
| Are all role-relevant High items represented? | Yes |
| Are Medium and Role-dependent items included without forcing irrelevant claims? | Yes |
| Does the template prevent unsupported keyword insertion? | Yes |
| Does the template prevent project/exposure inflation? | Yes |
| Does the template prevent summary/headline claims from outrunning evidence? | Yes |
| Does the template preserve application-form and public-profile consistency? | Yes |
| Does the template support both classic ATS parsing and modern semantic screening? | Yes |

---

# 25. Template Completion Checklist


## 25.1 Extraction Completeness

- [ ] Raw posting preserved.
- [ ] Posting metadata captured.
- [ ] Must-have requirements extracted.
- [ ] Preferred requirements extracted.
- [ ] Compound requirements split.
- [ ] Knockout criteria identified.
- [ ] Repeated terms and risk terms identified.
- [ ] Role-dependence pass completed.
- [ ] Seniority, authority, and scope analyzed.
- [ ] Domain, regulatory, and logistics requirements captured.

## 25.2 Resume-Generation Completeness

- [ ] ATS keyword map completed.
- [ ] Keyword placement plan completed.
- [ ] Responsibility-to-bullet map completed.
- [ ] Evidence-depth expectations assigned.
- [ ] Metrics and outcome plan completed.
- [ ] Gap-handling rules completed.
- [ ] Future candidate matching interface prepared.
- [ ] Top-of-page resume priorities defined.
- [ ] Final resume structure guidance completed.

## 25.3 Integrity Completeness

- [ ] Unsupported assumptions blocked.
- [ ] Project/prototype/exposure inflation blocked.
- [ ] Seniority/title inflation blocked.
- [ ] Domain/compliance inflation blocked.
- [ ] AI/ML terminology inflation blocked.
- [ ] Metric defensibility requirements included.
- [ ] Application-answer consistency included.
- [ ] Public-profile and fact-bank consistency included.
- [ ] Final output package check included.

## 25.4 Final Quality Standard

The completed blueprint is acceptable only if a resume generated from it could satisfy both:

1. a role-calibrated ATS / AI screening system looking for relevant terms and evidence; and
2. a skeptical human reviewer looking for truthful, defensible, role-specific proof without keyword stuffing, hidden tailoring logic, inflated claims, or cross-version inconsistencies.


## 25.5 Final Test Sequence Before Resume Generation

Run these checks in order:

1. Raw posting preserved exactly.
2. Must-have, preferred, knockout, repeated, logistics, and seniority requirements extracted.
3. Compound requirements split into separate rows.
4. Role-dependence pass completed.
5. Exact ATS keywords and semantic variants mapped.
6. Keyword placement plan completed without keyword stuffing.
7. Every major requirement assigned a future evidence standard.
8. Project, PoC, exposure, and education-only evidence boundaries defined.
9. Metrics require source, baseline/context, method, ownership chain, and mechanism.
10. Public-profile, fact-bank, application-answer, and metadata consistency requirements included.
11. Hard-stop gate reviewed.
12. Output package requirements reviewed.
13. Traceability matrix completed.

The template is 10/10 only when all thirteen checks pass.

---

# 26. v6 Finalization Layer — Strict Requirement Coverage Controls

This layer closes the remaining gap between a strong human template and a reliable reusable system. It makes the template usable by a person, an LLM, or a resume-generation pipeline without losing the intent of the ATS checklist.

## 26.1 Field Completion Rules

Every field in a completed blueprint must use one of these completion states.

| Completion state | Meaning | Allowed next action |
|---|---|---|
| Filled from posting | Directly supported by the raw posting | May be used as a job requirement |
| Filled by strong inference | Not stated, but strongly implied by role logic | May guide positioning; must not become a false candidate claim |
| Filled by weak inference | Plausible but uncertain | Use only as a caution or low-priority note |
| Missing from posting | The posting does not provide the information | Leave as missing or flag for application/interview review |
| Not applicable | The field genuinely does not apply to the role | Do not force it into resume planning |
| Candidate-dependent | Cannot be completed until a fact bank is supplied | Reserve for later candidate matching |
| Blocked / do not assume | Too risky to infer | Do not use in resume generation |

No field should be left blank. Blank fields create silent failure. Use `Missing from posting`, `Not applicable`, or `Candidate-dependent` instead.

## 26.2 Gap-Filling Hierarchy

When filling missing data from a job posting, use this hierarchy.

1. Use the exact posting text first.
2. Use repeated posting terms second.
3. Use title, responsibilities, and tool stack to infer role logic third.
4. Use company/industry context only as low-confidence context unless explicitly stated.
5. Use common role expectations only as a weak inference.
6. Never use candidate experience to fill job-post requirements.
7. Never convert inferred job needs into candidate claims.

## 26.3 Requirement Normalization Rules

Every requirement must be normalized into one clean row.

| Raw wording | Normalized requirement | Requirement type | Priority | Source label | Role-dependence | Evidence standard | Resume placement rule | Overstatement boundary |
|---|---|---|---|---|---|---|---|---|
| [Exact wording] | [One requirement only] | [Skill / tool / responsibility / outcome / domain / logistics / seniority / credential / soft skill] | [Critical / High / Medium / Low / Role-dependent / Unknown] | [Directly stated / repeated / implied / missing / knockout / do-not-assume] | [Always / only if role-specific / unknown] | [Paid production / professional use / project acceptable / certification acceptable / not enough] | [Summary / skills / experience / projects / education / application only / omit] | [What must not be claimed] |

Rules:

- Split compound requirements into separate rows.
- Do not merge technologies with responsibilities.
- Do not merge seniority with tool knowledge.
- Do not treat preferred requirements as must-haves unless the posting clearly does.
- Do not treat repeated marketing language as a requirement unless it affects screening or role success.

## 26.4 Evidence Standard by Requirement Type

| Requirement type | Minimum future evidence needed for strong resume use | Weak evidence treatment |
|---|---|---|
| Required technology | Work/project proof showing where and how it was used | Keep out of headline; place only where accurately scoped |
| Required framework/platform | Proof of depth, responsibility, and operating context | Avoid ownership/expert wording |
| Required responsibility | Bullet-level proof of doing that work | Use weaker verbs or omit |
| Required business outcome | Metric, result, stakeholder value, or operational result | Mention responsibility without quantified claim |
| Required seniority | Scope, decisions, ownership, ambiguity, mentoring, leadership, or accountability | Do not use senior/lead language unsupported by facts |
| Required domain | Direct domain work, users, data, workflow, compliance, or business context | Do not bridge by analogy |
| Required compliance/security | Real controls, audits, policies, standards, risk handling, or evidence | Do not use regulated/compliance wording |
| Required AI/ML/LLM depth | Clear distinction among API use, RAG, evaluation, agents, fine-tuning, training, deployment, monitoring | Do not collapse all AI terms into one claim |
| Required client-facing work | Client type, interaction type, ownership level, and outcome | Do not convert internal stakeholder work into client ownership |
| Required authorization/location | Exact legally safe status or location fit | Do not imply eligibility or relocation unless true |

## 26.5 Non-Negotiable Exclusion Rules

A completed blueprint must explicitly block these resume-generation errors.

- Do not add a keyword only because the job posting contains it.
- Do not place any unsupported keyword in the summary or headline.
- Do not use the skills section as the only proof of a must-have requirement.
- Do not use project-only work as the main proof for senior paid-production requirements unless the role clearly accepts project evidence.
- Do not use “equivalent,” “transferable,” “adjacent,” or similar language to force fit.
- Do not turn collaboration into ownership.
- Do not turn exposure into experience.
- Do not turn internal work into client-facing work.
- Do not turn LLM usage into ML engineering, model training, or fine-tuning.
- Do not turn general infrastructure work into platform ownership, SRE, MLOps, or cloud architecture without evidence.
- Do not use metrics that lack source, baseline, method, ownership chain, and explanation.

---

# 27. Machine-Readable Blueprint Contract

A completed version of this template should be convertible into the following structured object. This is not submitted with a resume; it is an internal control format.

```json
{
  "job_blueprint": {
    "posting_metadata": {},
    "raw_posting_preserved": true,
    "role_identity": {},
    "role_purpose": {},
    "requirement_register": [],
    "knockout_register": [],
    "role_dependence_register": [],
    "technical_stack_map": [],
    "domain_regulatory_map": [],
    "seniority_scope_map": [],
    "keyword_map": [],
    "semantic_variant_map": [],
    "responsibility_to_bullet_map": [],
    "evidence_request_map": [],
    "gap_register": [],
    "anti_inflation_boundaries": [],
    "resume_generation_brief": {},
    "submission_validation_plan": {},
    "ats_checklist_coverage_matrix": {},
    "completion_score": null,
    "hard_stop_failures": []
  }
}
```

## 27.1 Required Object Validation

| Object | Required? | Fail condition |
|---|---:|---|
| `posting_metadata` | Yes | Missing source, title, company, location/work model if available |
| `raw_posting_preserved` | Yes | Raw posting not included exactly |
| `requirement_register` | Yes | Major requirements missing or not prioritized |
| `knockout_register` | Yes | Location, authorization, clearance, license, degree, travel, or schedule not checked |
| `keyword_map` | Yes | Exact terms and variants not separated |
| `evidence_request_map` | Yes | Requirements lack future evidence standards |
| `gap_register` | Yes | Missing/unclear/do-not-assume items not recorded |
| `anti_inflation_boundaries` | Yes | No explicit limits on unsupported claims |
| `resume_generation_brief` | Yes | No clear instruction for what to emphasize, weaken, omit, or validate |
| `submission_validation_plan` | Yes | Parsing, metadata, public-profile, application-answer, and interview checks missing |
| `hard_stop_failures` | Yes | Any unresolved hard stop remains |

---

# 28. ATS Checklist Full-Coverage Acceptance Test

Use this table to confirm that the template considers the checklist effectively and does not merely mention it.

| ATS checklist area | Required template behavior | Pass condition |
|---|---|---|
| Purpose | Treat ATS success as parsing + semantics + credibility + consistency | Blueprint includes all four dimensions |
| Usage modes | Support fast pass, full pass, structure pass, credibility pass, consistency pass | Mode selection appears before extraction decisions |
| Critical path | Extract, map evidence, place top evidence, add supported keywords, remove unsupported claims, test package | Final workflow follows this order |
| Stop rule | Stop when must-haves require exaggeration or unsupported implication | Hard-stop gate blocks generation |
| Role-dependence | Activate only relevant role-specific checks | Role-dependence register completed |
| Evidence depth | Distinguish paid production, professional use, project, PoC, lab, education, unsupported | Evidence labels are mandatory |
| Posting extraction | Split must-have, preferred, repeated, seniority, knockouts, risk terms | Requirement register includes all categories |
| Hard-stop gate | Block parsing, evidence, hidden keyword, consistency, metric, and defensibility failures | No hard stop remains unresolved |
| Fast checklist | Contact, targeting, evidence, work experience, skills, education, logistics, formatting | Resume-generation brief includes these placement and validation needs |
| Deep tailoring | Semantic match, identity, seniority, bullets, metrics, tools, projects, domains, AI/ML, platform, discipline fit | Anti-inflation boundaries cover all risky categories |
| Evidence map | Every requirement maps to proof or gap later | Evidence request map is complete |
| Fact bank | All future claims trace to verified facts | Fact-bank trace requirement included |
| Cross-version consistency | Resume, LinkedIn, GitHub, portfolio, forms, public profiles, metadata do not conflict | Consistency plan included |
| Application-side ATS | Screening answers and checkboxes match evidence | Application-answer plan included |
| Authenticity | Resume survives skeptical recruiter, manager, specialist, and fraud review | Interview-defensibility gate included |
| Red flags | Reverse-engineering, inflated projects, unsupported summary, detached metrics, templated bullets blocked | Red-flag triage included |
| Final tests | Parse, extraction, keywords, semantics, evidence, metadata, application answers, interview defense | Final test sequence included |
| Scoring | Weighted rubric with caps for Critical failures | Scoring caps included |
| Submission decision | Submit only when Critical and role-relevant High checks pass | Submission gate included |
| Output package | PDF/DOCX/plain text/filename/metadata/internal evidence map checked | Output package check included |

## 28.1 Acceptance Rule

The template is accepted only if every row above can be answered with `Pass`. If any row is `Partial`, update the relevant section before using the template to generate a resume.

---

# 29. Resume-Generation Readiness Gate

Before using a completed blueprint to create a resume, answer these questions.

| Question | Required answer |
|---|---|
| Is the raw posting preserved? | Yes |
| Are all must-have requirements extracted and split? | Yes |
| Are all preferred requirements extracted without being promoted incorrectly? | Yes |
| Are knockout criteria identified? | Yes |
| Are exact ATS keywords separated from semantic variants? | Yes |
| Are all role-dependent checks activated or marked not applicable? | Yes |
| Does each requirement have a future evidence standard? | Yes |
| Are unsupported assumptions blocked? | Yes |
| Are project, PoC, exposure, education-only, and unsupported claims bounded? | Yes |
| Are summary/headline limits defined? | Yes |
| Are metric requirements defined? | Yes |
| Are public-profile, fact-bank, application-answer, and metadata checks included? | Yes |
| Is the final resume output package defined? | Yes |
| Does the hard-stop gate have zero unresolved failures? | Yes |

If any answer is not `Yes`, the blueprint is not ready.

---

# 30. Final v6 Quality Verdict Standard

A completed blueprint earns **10/10** only when it meets all of the following:

1. It preserves the job posting exactly.
2. It extracts every meaningful requirement, not only the obvious keywords.
3. It separates facts, inferences, missing data, and prohibited assumptions.
4. It handles role-specific requirements without forcing irrelevant claims.
5. It defines the evidence depth needed for later truthful resume use.
6. It prevents keyword stuffing and visible reverse-engineering.
7. It prevents project/exposure/prototype inflation.
8. It prevents seniority, domain, AI/ML, platform, compliance, client-facing, and metric inflation.
9. It supports both classic ATS parsing and modern semantic screening.
10. It supports consistency across resume, application forms, LinkedIn, GitHub, portfolio, public profiles, prior versions, metadata, and interview explanations.
11. It includes hard-stop rules, final package checks, scoring caps, and a traceability matrix.
12. It can be converted into a machine-usable requirement register, evidence request map, gap register, resume-generation brief, and submission validation plan.

Final standard:

```text
No generated resume should be more complete, more technical, more senior, more domain-specific, more production-grade, or more measurable than the verified evidence can support.
```

---

# 31. v6 Enforcement Layer — Direct ATS Checklist Requirement Integration

This section exists to prevent the template from being merely descriptive. It converts the ATS checklist into direct operating requirements for the job-post blueprint and for any later resume-generation process.

## 31.1 Governing Requirement Set

The uploaded ATS checklist is treated as the governing validation source. A completed job-post blueprint must support the following resume outcomes:

| Governing area | Required blueprint support | Pass / fail rule |
|---|---|---|
| Parser friendliness | Capture required format, section, keyword, and output-package constraints | Fail if the blueprint cannot later produce a selectable, extractable, cleanly ordered resume |
| Semantic screening | Capture evidence-backed role-fit signals, not only keywords | Fail if the blueprint only lists terms without responsibility, scope, or outcome context |
| Recruiter readability | Capture top-half-of-page-one priorities and concise positioning rules | Fail if the strongest role-fit evidence cannot be identified quickly |
| Hiring-manager credibility | Capture proof requirements for tools, responsibilities, seniority, outcomes, and domain | Fail if a future resume could satisfy the template through unsupported keyword matching |
| Specialist interview defensibility | Capture technical depth, ownership, and claim-risk controls | Fail if a future resume could make claims that cannot be explained under questioning |
| Fact-bank consistency | Require all future candidate claims to map to a verified fact bank | Fail if the template permits free-form invention |
| Application consistency | Capture knockout criteria, screening answers, logistics, and application-form risks | Fail if the blueprint does not guide consistent application answers |
| Public-profile consistency | Capture LinkedIn, GitHub, portfolio, metadata, and cross-version risks | Fail if the resume could contradict external/public evidence |

## 31.2 Mandatory Blueprint Sections by ATS Checklist Mode

The job-post template must support each usage mode from the ATS checklist.

| ATS checklist mode | Blueprint sections that must be completed | Minimum acceptance standard |
|---|---|---|
| Fast pass | Sections 1, 3, 4, 5, 11, 15, 16, 20, 22, 23 | Enough to create a quick but truthful targeted resume |
| Full pass | Sections 0 through 30 plus this enforcement layer | Required for high-value applications |
| Structure pass | Sections 0, 11, 18, 21, 22, 23, 24, 25, 27 | Required when creating or validating a resume template |
| Credibility pass | Sections 5, 9, 10, 13, 14, 15, 17, 19, 20, 31 | Required for role pivots or stretch applications |
| Consistency pass | Sections 15, 17, 19, 20, 22, 24, 25, 31 | Required when multiple tailored resume versions exist |

## 31.3 Non-Negotiable Extraction Fields

A filled blueprint is incomplete unless these fields are present or explicitly marked `Missing`, `Unknown`, `Not Applicable`, or `Do Not Assume`.

| Field | Required status options | Why it matters |
|---|---|---|
| Must-have requirements | Directly Stated / Strongly Implied / Missing | Prevents blind tailoring |
| Preferred requirements | Directly Stated / Strongly Implied / Missing | Separates must-have from nice-to-have |
| Knockout criteria | Knockout / Missing / Not Applicable | Prevents wasted applications and contradictions |
| Repeated terms | Repeated / Emphasized / Not Repeated | Controls keyword priority |
| Seniority signals | Directly Stated / Implied / Unknown | Prevents title and scope inflation |
| Role-dependence triggers | Active / Inactive / Unknown | Prevents irrelevant claims |
| Technical depth required | Required / Preferred / Unknown | Prevents shallow keyword inclusion |
| Domain depth required | Required / Preferred / Unknown | Prevents false domain claims |
| Compliance/security requirements | Required / Preferred / Not Stated | Prevents unsupported regulated claims |
| AI/ML/data requirements | Required / Preferred / Not Stated | Prevents AI credibility wallpaper |
| Platform/architecture requirements | Required / Preferred / Not Stated | Prevents false ownership claims |
| Product/client-facing requirements | Required / Preferred / Not Stated | Prevents inflated authority claims |
| Metrics expected | Directly Stated / Implied / Unknown | Controls outcome and metric planning |
| Application-form risks | Present / Missing / Unknown | Aligns resume with screening answers |
| Public-profile risks | Present / Not Apparent / Unknown | Aligns resume with external evidence |
| Final output requirements | PDF / DOCX / Plain text / Unknown | Prevents submission package errors |

## 31.4 Requirement Normalization Contract

Every requirement extracted from a job posting must be normalized into the following contract:

```yaml
requirement_id: REQ-000
raw_text: "Exact phrase from job posting"
normalized_requirement: "Clear requirement in plain language"
requirement_type: must_have | preferred | knockout | responsibility | tool | domain | seniority | logistics | compliance | outcome
source_label: directly_stated | repeated_emphasized | strongly_implied | weakly_implied | missing | do_not_assume
priority: critical | high | medium | low | role_dependent | unknown
role_dependence_trigger: ai_ml | cloud_platform | product_pm | regulated | client_facing | specialist | immigration_logistics | none
required_evidence_depth_later: paid_production | professional_use | project | prototype_poc | lab_learning | certification_education | unknown
resume_use_rule: include_if_verified | include_only_if_direct_evidence | place_in_skills_only | place_in_experience_context | omit_if_unsupported | answer_carefully_in_form
risk_level: low | medium | high | critical
risk_reason: "Why this requirement could create credibility, parsing, or consistency risk"
trace_to_resume_section: summary | skills | work_experience | projects | education | certifications | application_answer | do_not_use
completion_status: complete | partial | missing | unknown | not_applicable
```

A requirement without this normalization is not ready for resume generation.

## 31.5 Resume-Generation Control Rules

When this blueprint is later used to write a resume, the resume generator must obey these rules.

1. Do not write any candidate claim unless it maps to verified candidate evidence.
2. Do not use exact job-post keywords unless the candidate evidence can support the keyword.
3. Do not convert project, prototype, lab, exposure, or learning work into paid production expertise.
4. Do not let the summary claim more than the experience/project sections can prove.
5. Do not promote a tool into the headline unless the evidence depth supports that placement.
6. Do not fill must-have gaps with analogy, transferable wording, or cosmetic similarity.
7. Do not create visible requirement-mapping sections inside the submitted resume.
8. Do not create hidden keyword text, white text, metadata stuffing, or ATS bait.
9. Do not create metrics unless source, baseline/context, method, contribution, and ownership chain are explainable.
10. Do not let application answers become stronger than the resume evidence.
11. Do not let public profiles contradict the tailored resume.
12. Do not submit if any Critical gate fails.

## 31.6 Direct ATS Checklist Coverage Matrix

| ATS checklist requirement area | Covered by this template | Required evidence in completed blueprint |
|---|---|---|
| Posting extraction pass | Yes | Sections 1, 4, 31.4 |
| Role-dependence pass | Yes | Sections 5, 31.2, 31.3 |
| Hard-stop submission gate | Yes | Sections 20, 29, 31.5 |
| Fast application checklist | Yes | Sections 2, 16, 18, 19, 22, 23 |
| Deep tailoring audit | Yes | Sections 7 through 17 |
| Evidence-map gate | Yes | Section 15 |
| Master fact-bank audit | Yes | Sections 0, 15, 19 |
| Cross-version/public-profile consistency | Yes | Section 19 |
| Application-side ATS factors | Yes | Sections 4.3, 19.1, 22 |
| Final authenticity check | Yes | Sections 17, 20, 31.5 |
| Red-flag triage | Yes | Sections 14, 17, 20, 31.8 |
| Recommended final test sequence | Yes | Sections 25.5, 31.9 |
| Internal scoring rubric | Yes | Section 21 |
| Submission workflow | Yes | Sections 29, 31.10 |
| Submission decision rule | Yes | Sections 20, 29, 31.11 |
| Three-minute final decision check | Yes | Section 31.12 |
| Final output package check | Yes | Section 22 |

## 31.7 Fit-Agnostic Interpretation Rules

This template must not decide that a candidate fits the job. It prepares a structured job blueprint so candidate fit can later be tested.

| Situation | Correct treatment |
|---|---|
| Job requires a skill the future candidate does not have | Keep the requirement in the blueprint; mark candidate evidence later as `Not Supported` |
| Job posting is vague | Mark as `Missing`, `Unknown`, or `Weakly Implied`; do not invent |
| Job uses broad terms such as ownership, platform, AI, strategy, or scale | Decompose into concrete responsibilities and proof requirements |
| Job has contradictory requirements | Preserve the contradiction and flag as risk |
| Job has unrealistic requirements | Preserve the requirements; flag priority and credibility risk |
| Job has no metrics | Infer possible metric categories only; do not invent specific metrics |
| Job has no listed tech stack | Extract workflow, domain, responsibility, and implied systems; mark stack as unknown |

## 31.8 Red-Flag Rejection Layer

A completed blueprint must be revised before use if any of the following are true:

- It contains job requirements without source labels.
- It mixes must-have and preferred requirements.
- It treats vague words as exact evidence requirements without explanation.
- It has no knockout-criteria section.
- It has no role-dependence analysis.
- It has no keyword placement plan.
- It has no evidence-depth requirement for future candidate matching.
- It has no anti-inflation controls for AI/ML, platform, product, seniority, metrics, domain, or compliance claims.
- It does not identify the top 5 screening priorities.
- It cannot explain what must appear in the top half of page one.
- It cannot guide application-form answers.
- It cannot detect contradictions with a future fact bank or public profile.
- It allows resume generation before Critical gaps are resolved or honestly labeled.

## 31.9 Final Validation Sequence for a Completed Job Blueprint

Run these checks before using the blueprint to create a resume.

1. **Raw posting preserved:** The original job posting is retained or summarized with enough exact wording to trace requirements.
2. **Requirement extraction complete:** Must-have, preferred, knockout, repeated, seniority, logistics, domain, and risk terms are extracted.
3. **Requirements normalized:** Every major requirement has a requirement object using the contract in Section 31.4.
4. **Role-dependence complete:** All relevant role-dependent rows are active or inactive with reasons.
5. **Keyword map complete:** Exact terms, synonyms, acronyms, placement rules, and risk terms are mapped.
6. **Evidence-depth expectations defined:** Each requirement states what future evidence depth would be needed.
7. **Gap rules applied:** Missing, unknown, inferred, and do-not-assume items are clearly separated.
8. **Resume positioning defined:** Top 5 screening priorities and top-half-of-page-one evidence targets are clear.
9. **Application risks captured:** Knockout questions, logistics, authorization, location, screening answers, and form risks are captured.
10. **Integrity gates passed:** Anti-inflation, public-profile consistency, fact-bank consistency, metric defensibility, and interview defensibility rules are active.
11. **Output package requirements captured:** PDF/DOCX/plain-text/metadata/filename requirements are noted when available.
12. **Final readiness verdict recorded:** The blueprint is marked `Ready`, `Ready with Known Gaps`, or `Not Ready`.

## 31.10 Blueprint-to-Resume Workflow

Use this workflow after the blueprint is completed.

1. Build the completed job blueprint from the posting.
2. Extract candidate evidence only from the verified fact bank.
3. Map candidate evidence to blueprint requirements.
4. Label each candidate match by depth: paid production, professional use, project, prototype/PoC, lab/learning, certification/education, partial, or not supported.
5. Decide resume action for each requirement: keep, add, weaken, omit, or answer carefully in form.
6. Place the strongest truthful evidence in the top half of page one.
7. Write summary, skills, experience bullets, projects, education, and certifications only from verified evidence.
8. Run hard-stop gate.
9. Run parsing, extraction, metadata, public-profile, application-answer, and interview-defensibility checks.
10. Submit only if all Critical items pass and the resume does not look more complete than the evidence.

## 31.11 Final Submission Readiness Labels

| Label | Meaning | Allowed action |
|---|---|---|
| Ready | All Critical requirements are addressed honestly; all role-relevant High items are addressed or deliberately omitted | Resume can be generated and validated |
| Ready with Known Gaps | Some requirements are unsupported or unknown, but they are not falsely claimed | Resume can be generated only with careful omission or partial framing |
| Not Ready | Any Critical item would require exaggeration, unsupported depth, false equivalence, or contradiction | Do not generate a submitted resume |
| Not Applicable | The posting does not support this requirement area | Leave absent or mark as not applicable |

## 31.12 Three-Minute Blueprint Decision Check

Before generating any resume from this template, verify:

- The job is fully described, not merely keyword-listed.
- Must-have, preferred, knockout, and role-dependent requirements are separated.
- The top 5 screening priorities are obvious.
- Exact ATS keywords are mapped to natural resume sections.
- Required evidence depth is clear for every major requirement.
- Missing and inferred items are clearly labeled.
- No candidate claim has been invented inside the job blueprint.
- No role-fit assumption has been made.
- Anti-inflation controls are active for title, seniority, metrics, domain, AI/ML, platform, compliance, product, and client-facing claims.
- The blueprint can support parser-friendly, semantically credible, human-readable, and interview-defensible resume generation.

---

# 32. Final v6 Acceptance Verdict

A completed version of this template is accepted only when it passes the following standard:

> The blueprint must allow a resume system or human resume writer to transform any job posting into a complete, traceable, candidate-agnostic role blueprint that supports truthful resume generation, ATS parsing, semantic screening, evidence-depth controls, role-dependence controls, hard-stop gates, application-answer consistency, public-profile consistency, final package checks, and anti-inflation safeguards.

If any extracted requirement cannot be traced from raw posting text to normalized requirement, priority, source label, future evidence expectation, resume-use rule, and readiness verdict, the blueprint is incomplete.

Final standard: **10/10 only if the template prevents both under-extraction and over-claiming.**

---

# 33. v6 Final Hardening Layer — Requirement-Complete, Validator-Ready Blueprint Standard

This layer closes the remaining practical gaps for repeated use by humans, LLMs, or automated resume-generation systems. It makes the template stricter in four areas:

1. complete coverage of the ATS checklist as a governing standard;
2. deterministic handling of missing, vague, duplicated, or conflicting job-post information;
3. machine-checkable validation before resume generation;
4. safer conversion from a completed job blueprint into a future resume brief.

A completed blueprint fails v6 if it is merely descriptive. It must be **actionable, traceable, evidence-aware, and validation-ready**.

## 33.1 v6 Rating Standard

Use this rating standard when reviewing a completed job blueprint.

| Score | Meaning | Decision |
|---:|---|---|
| 10.0 | Fully extraction-complete, traceable, ATS-aligned, evidence-aware, contradiction-checked, and resume-generation-ready | Approved |
| 9.5–9.9 | Strong, but one or more validation, traceability, or role-dependence controls need tightening | Revise before system reuse |
| 9.0–9.4 | Usable manually, but insufficiently strict for repeatable LLM or automation use | Revise before high-value applications |
| 8.0–8.9 | Good structure, but incomplete validation or weak anti-inflation controls | Do not automate |
| Below 8.0 | Missing major ATS checklist requirements or creates resume integrity risk | Reject |

A blueprint cannot be rated 10/10 if any item in the v6 hard-stop validator fails.

## 33.2 v6 Hard-Stop Validator

Before generating any resume from this template, answer each item.

| Validator item | Pass / Fail / N/A | Evidence location |
|---|---:|---|
| Full raw posting preserved before extraction |  |  |
| Must-have, preferred, repeated, implied, knockout, and logistics requirements separated |  |  |
| Compound requirements split into atomic checks |  |  |
| Each atomic requirement has raw wording, normalized wording, priority, source label, and role-dependence status |  |  |
| Each requirement has a future evidence standard |  |  |
| Each requirement has a permitted resume location and prohibited overstatement boundary |  |  |
| Every critical or high requirement has an ATS keyword and semantic-screening treatment |  |  |
| Role-specific risks are checked for AI/ML, platform, cloud, product, domain, regulated, client-facing, leadership, and specialized roles where applicable |  |  |
| Missing information is marked as Missing, Unknown, or Do Not Assume rather than silently filled |  |  |
| Inferences are labeled Strongly Implied or Weakly Implied |  |  |
| Candidate fit is not assessed inside the job blueprint |  |  |
| Candidate evidence is not invented or inserted into the job blueprint |  |  |
| Future resume generation requires a separate fact bank and evidence map |  |  |
| Public-profile, application-answer, metadata, and final output package checks are included |  |  |
| Final readiness label is assigned before resume generation |  |  |

**Hard-stop rule:** if any non-N/A item fails, do not generate a resume from the blueprint.

## 33.3 Atomic Requirement Register — Required Format

Every requirement must be decomposed into atomic units. Do not leave grouped requirements as a single item.

| Requirement ID | Raw wording | Atomic normalized requirement | Type | Priority | Source label | Role-dependent? | Evidence depth needed later | Resume placement allowed | Overstatement boundary | Validation gate |
|---|---|---|---|---|---|---:|---|---|---|---|
| REQ-001 | [Exact phrase] | [One requirement only] | Must-have / Preferred / Knockout / Logistics / Domain / Tool / Responsibility / Seniority | Critical / High / Medium / Low / Unknown | Directly Stated / Repeated / Strongly Implied / Weakly Implied / Missing / Do Not Assume | Yes / No / Unknown | Paid Production / Professional Use / Project / Education / Certification / Exposure / Unknown | Summary / Skills / Experience / Projects / Education / Application answer / Omit | [What must not be implied] | [How to verify before resume use] |

### Atomic Requirement Rules

- One technology = one requirement.
- One certification = one requirement.
- One logistics constraint = one requirement.
- One seniority signal = one requirement.
- One domain/regulatory condition = one requirement.
- One responsibility cluster may be kept together only if it cannot be separated without losing meaning.
- Compound phrases such as `Python, TypeScript, and AWS` must become three separate requirements.
- Vague phrases such as `modern engineering practices` must be translated into possible components and marked as inferred unless the posting defines them.

## 33.4 Include / Exclude / Conditional Include Contract

This table controls what the future resume may do with each extracted item.

| Item type | Include in future resume when | Exclude when | Conditional treatment |
|---|---|---|---|
| Exact required keyword | Verified candidate evidence exists | No evidence exists | Use in skills only if context exists elsewhere |
| Preferred keyword | Evidence exists and does not distract from must-haves | It creates weak or scattered identity | Place lower than must-have evidence |
| Repeated term | It reflects central role fit | It is unsupported | Use as a priority signal, not as a forced keyword |
| Strongly implied requirement | Evidence exists and inference is reasonable | Inference could misrepresent role or candidate | Use careful wording and mark inference internally |
| Weakly implied requirement | It helps identify a question or risk | It would become a claim | Keep in notes only |
| Knockout requirement | Candidate can answer consistently and truthfully later | It is unresolved or contradicted | Stop before final resume generation |
| Project-supported skill | Project evidence is relevant and labeled | It is needed as paid production proof | Use project section only |
| Exposure-only skill | Role does not depend heavily on it | It is a must-have or senior-depth requirement | Usually omit or label as exposure outside top claims |
| Metric / outcome | Source, baseline, mechanism, and ownership can be explained | Attribution is unclear | Use qualitative outcome instead |

## 33.5 Ambiguity and Conflict Resolution Rules

When the posting is unclear, incomplete, contradictory, or inflated, apply this hierarchy.

1. **Use direct posting wording first.**
2. **Use repeated or emphasized wording second.**
3. **Use role logic third, but label it as implied.**
4. **Use industry/domain norms only as weak inference.**
5. **Do not use candidate background to fill job-post gaps inside this blueprint.**
6. **Do not convert uncertainty into resume claims.**
7. **If title, seniority, and responsibilities conflict, preserve the conflict in the blueprint instead of resolving it silently.**
8. **If application-form questions add requirements later, update the blueprint before generating or submitting the resume.**

## 33.6 Role-Specific Coverage Expansion

Use this table to avoid missing role-dependent ATS checks.

| Role family detected | Additional blueprint fields required | Inflation risks to block |
|---|---|---|
| AI / ML / LLM | Model type, data context, RAG, agents, evaluation, deployment, governance, fine-tuning/training distinction | Presenting LLM app work as model training; calling every workflow agentic; using AI terms as wallpaper |
| Backend / Full-stack | APIs, services, databases, integrations, reliability, testing, deployment, system ownership | Listing stack without work context; overstating architecture ownership |
| Cloud / Platform / DevOps | Cloud services, CI/CD, IaC, observability, reliability, internal consumers, governance | Treating Docker as Kubernetes; treating CI usage as platform ownership |
| Product / PM | Discovery, prioritization, roadmap, metrics, users, tradeoffs, launch, stakeholders | Turning engineering collaboration into product ownership |
| Data / BI / Analytics | Data sources, pipelines, metrics, dashboards, lineage, decision impact, governance | Listing dashboards as data strategy; claiming statistical depth without methods |
| QA / Test | Test strategy, automation, frameworks, defect workflow, validation depth, release gates | Treating ordinary testing as dedicated QA ownership |
| Frontend / Mobile | UI delivery, accessibility, performance, design systems, device/platform constraints | Treating generic web work as specialist depth |
| Regulated / Compliance | Regime, controls, audit evidence, formal process, security/privacy duties | Using compliance language from employer industry without direct work |
| Client-facing / Consulting | Client type, interaction model, deliverables, ownership, post-go-live support | Reframing internal stakeholder work as account ownership or consulting strategy |
| Leadership / Management | Mentoring, technical leadership, project ownership, people management, hiring/performance authority | Blurring mentoring, lead work, and people management |

## 33.7 ATS Checklist Coverage Matrix — Strict Acceptance Version

A v6 blueprint must explicitly support each checklist area below. Mark every row Pass, N/A, or Fail.

| ATS checklist area | Required blueprint support | Pass / N/A / Fail |
|---|---|---:|
| Posting extraction | Must-have, preferred, repeated, seniority, knockout, logistics, risk terms extracted |  |
| Role-dependence | Role-specific checks activated only when relevant |  |
| Hard-stop gate | Resume generation blocked on unresolved critical failures |  |
| Fast application pass | Top requirements, contact/logistics, parsing, consistency prepared for later resume |  |
| Deep tailoring audit | Keywords, evidence, identity, seniority, bullets, metrics, stack, AI, platform, domain, product, specialized claims controlled |  |
| Evidence map | Requirement-to-proof interface prepared without inserting candidate evidence |  |
| Fact-bank audit | Future resume must draw only from verified facts |  |
| Public-profile consistency | LinkedIn, GitHub, portfolio, application forms, and background-check consistency included |  |
| Application-side ATS factors | Form answers and knockout questions checked against resume evidence |  |
| Authenticity check | Recruiter, hiring manager, specialist interviewer, and fraud-review risks considered |  |
| Red-flag triage | Reverse-engineering, project-overweighting, metrics, keyword stuffing, and contradiction risks controlled |  |
| Final test sequence | Parse, extraction, keyword, semantic match, evidence, metadata, application-answer, interview-defensibility checks included |  |
| Scoring rubric | Scoring caps prevent high score when Critical items or major claims fail |  |
| Final output package | PDF/DOCX/plain-text extraction, filename, metadata, and saved evidence map handled |  |

## 33.8 Blueprint Completeness Scorecard

Use this score to rate the completed job blueprint itself, not the future resume.

| Area | Weight | 10/10 standard |
|---|---:|---|
| Raw posting preservation and metadata | 10% | Full source, posting metadata, capture date, and reliability notes preserved |
| Requirement extraction and normalization | 20% | All requirements decomposed into atomic units with priority, source, and role-dependence labels |
| ATS keyword and semantic-screening map | 15% | Exact keywords, variants, acronyms, synonyms, risk labels, and placement rules captured |
| Role-specific risk coverage | 15% | Relevant AI/ML, platform, product, domain, compliance, seniority, and specialized-role controls activated |
| Evidence request and anti-inflation controls | 20% | Every requirement has future evidence standard, permitted placement, and prohibited overstatement boundary |
| Resume-generation readiness and validation | 20% | Hard-stop gate, final test sequence, output package checks, and readiness label included |

### Score Caps

- Maximum score is **89** if any critical requirement is missing from the atomic requirement register.
- Maximum score is **89** if knockout criteria are unresolved.
- Maximum score is **85** if source labels are missing.
- Maximum score is **85** if implied requirements are not separated from directly stated requirements.
- Maximum score is **79** if the blueprint mixes job requirements with candidate experience.
- Maximum score is **79** if future resume generation could create unsupported claims.
- Maximum score is **69** if raw posting text is missing.

## 33.9 Final Resume-Generation Readiness Labels

Assign exactly one label after completing the blueprint.

| Label | Meaning | Resume generation allowed? |
|---|---|---:|
| Ready — Full | Blueprint is complete, critical fields are resolved, and validation passes | Yes |
| Ready — Partial | Blueprint is usable but has clearly marked non-critical unknowns | Yes, with caution |
| Hold — Knockout Unresolved | Authorization, location, clearance, license, schedule, travel, or legal/logistics issue is unresolved | No |
| Hold — Requirement Ambiguity | Major must-have or seniority requirement is unclear | No for final resume; yes for draft analysis only |
| Hold — Evidence Risk | Future resume would likely need unsupported claims to look aligned | No |
| Reject — Template Incomplete | Raw posting, requirement register, keyword map, or validation gate is missing | No |

## 33.10 Final v6 Acceptance Rule

A job blueprint created with this template is accepted only when all statements below are true:

- the raw job posting is preserved;
- all posting requirements are extracted or marked missing;
- compound requirements are split into atomic requirements;
- directly stated, repeated, implied, missing, knockout, and do-not-assume items are separated;
- every requirement has priority, source, role-dependence, future evidence standard, allowed resume placement, and overstatement boundary;
- ATS keyword and semantic-screening needs are mapped without keyword stuffing;
- role-specific risks are activated only when relevant;
- candidate experience is not inserted into the job blueprint;
- future resume generation requires a separate fact bank and evidence map;
- public-profile, application-answer, metadata, parsing, and final output package checks are included;
- all hard-stop validator items pass;
- the readiness label is Ready — Full or Ready — Partial.

If any statement is false, update the blueprint before using it to generate a resume.
