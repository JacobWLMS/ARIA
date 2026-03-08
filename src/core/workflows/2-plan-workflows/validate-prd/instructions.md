# Validate PRD — Document Review

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Validates an existing PRD on the platform through a comprehensive 13-step validation methodology. Each step performs a specific quality check, building a cumulative findings list. After all checks complete, posts a comment on the document with the overall validation verdict and creates a validation report. This is not a casual review — it is a rigorous, systematic validation against ARIA PRD standards.

---

<workflow>

<step n="1" goal="Document discovery — locate and load the PRD from the platform">
<action>Communicate in {communication_language} with {user_name}</action>
<action>Announce: "**Validate Mode: Comprehensive PRD validation against ARIA quality standards.**"</action>

<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document"` and `scope_key: "prd"` to locate the PRD document</action>

<action>If the PRD is not found via key map, search the platform directly:</action>
<action>Invoke the `read-context` task with `context_type: "document_artefact"` and `query: "PRD"` to search for documents with "PRD" or "Product Requirements" in the title</action>

<action>If multiple PRD documents are found, present candidates and ask the user to select one</action>
<action>If no PRD documents are found, ask user to provide the document title or ID</action>
<action>Load the full PRD content via the `read-context` task with the selected document ID</action>

<action>Store the PRD document ID, title, and full body content for use in all subsequent steps</action>

<action>Load the product brief if available:</action>
<action>Invoke `read-context` with `context_type: "document"` and `scope_key: "product_brief"` to load the product brief (may not exist — that is fine)</action>

<action>Load reference data for domain and project type validation:</action>
<action>Read `{project-root}/_aria/shared/data/project-types-prd.csv` — contains project type detection signals, required sections, and skip sections</action>
<action>Read `{project-root}/_aria/shared/data/domain-complexity-prd.csv` — contains domain classifications, complexity levels, and required special sections</action>

<action>Load the PRD checklist from `{checklist}` — the master checklist of PRD quality criteria</action>

<action>Initialize an internal findings list. Each finding will have: section, severity (Critical/Major/Minor), check_name, finding text, and recommendation. This list accumulates across all steps and is posted to the platform at the end.</action>
</step>

<step n="2" goal="Format detection — classify PRD structure and determine validation scope">
<action>Extract all Level 2 (##) headers from the PRD content</action>
<action>List them in order — this is the PRD's structural skeleton</action>

<action>Check for the 6 ARIA PRD core sections (accept common variations):</action>

1. **Executive Summary** — also matches: Overview, Introduction, Product Vision
2. **Success Criteria** — also matches: Goals, Objectives, Success Metrics, KPIs
3. **Product Scope** — also matches: Scope, In Scope / Out of Scope, Scope Boundaries
4. **User Journeys** — also matches: User Stories, User Flows, Personas and Journeys
5. **Functional Requirements** — also matches: Features, Capabilities, Requirements
6. **Non-Functional Requirements** — also matches: NFRs, Quality Attributes, System Requirements

<action>Count how many of the 6 core sections are present and classify:</action>

- **ARIA Standard** (5-6 present) — PRD follows ARIA structure closely. Proceed with full validation.
- **ARIA Variant** (3-4 present) — Recognizable as ARIA-style with structural differences. Proceed with full validation, noting missing sections.
- **Non-Standard** (0-2 present) — Does not follow ARIA structure. Ask user whether to proceed with validation as-is or exit.

<action>For Non-Standard PRDs, present the user with options:</action>

- **[A] Parity Check** — Analyze each of the 6 missing core sections, estimate the effort to add them (Minimal / Moderate / Significant per section), and present a gap summary before continuing
- **[B] Validate As-Is** — Proceed with validation using the current structure
- **[C] Exit** — Exit validation and report format findings

<action>For ARIA Standard and Variant, auto-proceed to Step 3 without pausing</action>

<action>Record format findings internally:</action>
- Format classification
- Sections present vs missing
- Count of core sections matched
</step>

<step n="3" goal="Parity check — compare PRD structure against ARIA template for missing or empty sections">
<action>Compare the PRD's actual sections against the full ARIA PRD template structure</action>

<action>For each expected ARIA section, determine:</action>

- **Present and populated** — Section exists and has substantive content (multiple sentences or structured data)
- **Present but shallow** — Section exists but contains only a sentence or two, placeholder text, or generic filler
- **Missing entirely** — Section header not found in the PRD

<action>Check specifically for placeholder indicators:</action>

- Template variables: `{variable}`, `{{variable}}`, `[placeholder]`, `[TBD]`, `TODO`
- Boilerplate phrases: "To be determined", "Will be defined later", "Pending research"
- Empty sections: Section header followed immediately by another header with no content between

<action>Build the parity matrix:</action>

| Section | Status | Notes |
|---------|--------|-------|
| Executive Summary | Present/Shallow/Missing | {specific notes} |
| Success Criteria | Present/Shallow/Missing | {specific notes} |
| Product Scope | Present/Shallow/Missing | {specific notes} |
| User Journeys | Present/Shallow/Missing | {specific notes} |
| Functional Requirements | Present/Shallow/Missing | {specific notes} |
| Non-Functional Requirements | Present/Shallow/Missing | {specific notes} |

<action>Scoring:</action>

- **Pass** — All 6 core sections present and populated
- **Needs Improvement** — 1-2 sections shallow or missing
- **Fail** — 3+ sections shallow or missing, or any section contains only placeholder text

<action>For each missing or shallow section, add a finding:</action>

- Severity: **Critical** if Functional Requirements, Non-Functional Requirements, or Success Criteria are missing; **Major** if Executive Summary, Product Scope, or User Journeys are missing; **Minor** if a section exists but is shallow
- Finding: "[Section] is {missing/contains only placeholder text/has insufficient content}"
- Recommendation: Specific guidance on what content should be added
</step>

<step n="4" goal="Information density validation — scan for filler, wordiness, and anti-patterns">
<action>Scan the entire PRD for information density anti-patterns. Every sentence in a PRD should carry actionable weight.</action>

<action>Scan for **conversational filler** — phrases that add no information:</action>

- "The system will allow users to..." (rewrite as "[Actor] can [capability]")
- "It is important to note that..." (delete — just state the fact)
- "In order to" (replace with "to")
- "For the purpose of" (replace with "for" or "to")
- "With regard to" / "With respect to" (replace with "about" or "for")
- "It should be noted that" (delete)
- "As mentioned previously" / "As discussed above" (delete or use a cross-reference)
- "Please note that" (delete)
- "Basically" / "Essentially" / "Fundamentally" (delete)

<action>Scan for **wordy phrases** — verbose constructions with concise alternatives:</action>

- "Due to the fact that" → "because"
- "In the event of" → "if"
- "At this point in time" / "At the present time" → "now"
- "In a manner that" → use a direct adverb
- "Has the ability to" / "Is able to" → "can"
- "In the near future" → specify a date or milestone
- "A large number of" / "A significant amount of" → use a specific number
- "On a regular basis" → "regularly"
- "In spite of the fact that" → "although"

<action>Scan for **redundant phrases** — words that repeat their own meaning:</action>

- "Future plans" → "plans"
- "Past history" → "history"
- "Absolutely essential" → "essential"
- "Completely finish" → "finish"
- "End result" → "result"
- "Free gift" → "gift"
- "Advance planning" → "planning"
- "Basic fundamentals" → "fundamentals"

<action>Count total violations by category. Determine severity:</action>

- **Fail** (Critical) — More than 10 total violations. PRD is padded with filler and needs rewriting.
- **Needs Improvement** (Major) — 5-10 violations. PRD is usable but would benefit from tightening.
- **Pass** (Minor or none) — Fewer than 5 violations. Good information density.

<action>For sections with the highest violation density, add a finding:</action>

- Severity: **Major** if section has 3+ violations, **Minor** if 1-2
- Finding: "[Section] contains {count} density violations including: {top 3 examples}"
- Recommendation: "Remove filler phrases and rewrite for conciseness. Every sentence should carry actionable information."
</step>

<step n="5" goal="Brief coverage validation — verify PRD covers all product brief content">
<action>Check if a product brief was loaded in Step 1</action>

<action>If NO product brief exists: record "N/A — No Product Brief available" and skip to Step 6</action>

<action>If product brief exists, extract key content from the brief and search the PRD for corresponding coverage:</action>

**Content to extract and trace:**

| Brief Element | Where to Find in PRD | Coverage Classification |
|---------------|---------------------|------------------------|
| Vision statement | Executive Summary | Fully Covered / Partially Covered / Not Found |
| Target users/personas | User Journeys, Executive Summary | Fully Covered / Partially Covered / Not Found |
| Problem statement | Executive Summary, Product Scope | Fully Covered / Partially Covered / Not Found |
| Key features/capabilities | Functional Requirements | Fully Covered / Partially Covered / Not Found |
| Goals/objectives | Success Criteria | Fully Covered / Partially Covered / Not Found |
| Differentiators | Executive Summary, Product Scope | Fully Covered / Partially Covered / Not Found |
| Constraints/limitations | Product Scope, NFRs | Fully Covered / Partially Covered / Not Found |
| Market context | Executive Summary | Fully Covered / Partially Covered / Not Found / Intentionally Excluded |

<action>Coverage classifications:</action>

- **Fully Covered** — Content present and complete in the PRD
- **Partially Covered** — Content present but incomplete or vague
- **Not Found** — Content from the brief is missing in the PRD
- **Intentionally Excluded** — Content explicitly marked as out of scope (valid scoping decision)

<action>Scoring:</action>

- **Fail** — Any core element (vision, problem, key features, goals) is Not Found
- **Needs Improvement** — Core elements are Partially Covered, or 2+ secondary elements are Not Found
- **Pass** — All core elements Fully Covered, secondary elements Fully or Partially Covered

<action>For each gap (Partially Covered or Not Found), add a finding:</action>

- Severity: **Critical** if core element (vision, problem statement, primary features, success criteria) is Not Found; **Major** if core element is Partially Covered or secondary element is Not Found; **Minor** if secondary element is Partially Covered
- Finding: "Product brief's {element} is {not found/only partially covered} in the PRD"
- Recommendation: "Add coverage for {element} in {suggested PRD section}. The brief states: {brief excerpt}"
</step>

<step n="6" goal="Measurability validation — verify all requirements are testable with quantifiable criteria">
<action>Extract all Functional Requirements (FRs) from the PRD</action>
<action>Extract all Non-Functional Requirements (NFRs) from the PRD</action>

<action>**Validate each FR for measurability:**</action>

**Format compliance — check for "[Actor] can [capability]" pattern:**
- Is the actor clearly defined? (e.g., "Admin user", "API consumer", not "the system")
- Is the capability actionable and testable? (something you can write a test for)
- Flag FRs that are vague statements rather than testable requirements

**No subjective adjectives (without metrics):**
- Scan for: easy, fast, simple, intuitive, user-friendly, responsive, quick, efficient, seamless, robust, elegant, modern, clean, lightweight
- These are only violations when used WITHOUT an accompanying metric
- Example violation: "The system should be fast" — no metric
- Example pass: "Response time under 200ms" — has metric

**No vague quantifiers:**
- Scan for: multiple, several, some, many, few, various, numerous, a number of, adequate, sufficient, appropriate
- These must be replaced with specific numbers or ranges

**No implementation details in FRs:**
- Scan for technology names: React, Vue, Angular, PostgreSQL, MongoDB, AWS, Docker, Kubernetes, Redux, Express, Django, etc.
- Exception: Terms that describe capability, not implementation (e.g., "REST API" as a capability is acceptable; "built with Express.js" is not)

<action>**Validate each NFR for measurability:**</action>

**Specific metrics required:**
- Each NFR must have a quantifiable target (e.g., "response time < 200ms", not "fast response")
- Check for measurement method — how would you verify this?

**NFR template compliance — each NFR should include:**
- Criterion: What quality attribute?
- Metric: What specific number or threshold?
- Measurement method: How to measure/test?
- Context: Why does this matter? Who is affected?

<action>Tally violations:</action>

| Category | Count |
|----------|-------|
| FR format violations | {count} |
| Subjective adjectives (no metric) | {count} |
| Vague quantifiers | {count} |
| Implementation details in FRs | {count} |
| NFRs missing metrics | {count} |
| NFRs missing measurement method | {count} |
| **Total violations** | **{sum}** |

<action>Scoring:</action>

- **Fail** — More than 10 total violations. Requirements are not testable.
- **Needs Improvement** — 5-10 violations. Most requirements are measurable but some need refinement.
- **Pass** — Fewer than 5 violations. Requirements are well-specified and testable.

<action>For each violating requirement, add a finding:</action>

- Severity: **Critical** if an FR has no testable criterion at all; **Major** if an FR uses subjective language or an NFR lacks a metric; **Minor** if an FR has a vague quantifier or minor formatting issue
- Finding: "{FR/NFR ID}: {specific violation description}. Current text: '{quoted text}'"
- Recommendation: "Rewrite as: {suggested improvement}"
</step>

<step n="7" goal="Traceability validation — verify the chain from vision to success to journeys to requirements">
<action>Validate the traceability chain is intact across the PRD. Every requirement should trace back to a user need or business objective.</action>

<action>**Chain 1: Executive Summary to Success Criteria**</action>
- Extract the vision, goals, and objectives from the Executive Summary
- For each Success Criterion, verify it supports or measures the stated vision/goals
- Flag success criteria that have no clear connection to the stated vision
- Flag vision elements that have no corresponding success criterion

<action>**Chain 2: Success Criteria to User Journeys**</action>
- For each success criterion, identify which user journey(s) would achieve it
- Flag success criteria that no user journey addresses
- Flag user journeys that don't contribute to any success criterion

<action>**Chain 3: User Journeys to Functional Requirements**</action>
- For each user journey step or flow, identify which FR(s) enable it
- Flag user journey steps that have no supporting FR
- Flag FRs that don't trace to any user journey (orphan FRs)
- Orphan FRs are the most critical traceability issue — a requirement without a traceable source is suspicious

<action>**Chain 4: Product Scope to FR Alignment**</action>
- Verify MVP scope items have corresponding FRs
- Verify out-of-scope items do NOT have FRs (contradiction)
- Flag any scope/FR misalignment

<action>Build the traceability summary:</action>

| Chain | Status | Gaps |
|-------|--------|------|
| Executive Summary to Success Criteria | Intact / Gaps | {gap count} |
| Success Criteria to User Journeys | Intact / Gaps | {gap count} |
| User Journeys to FRs | Intact / Gaps | {gap count} |
| Scope to FR Alignment | Intact / Misaligned | {gap count} |
| **Orphan FRs** | **{count}** | {list} |

<action>Scoring:</action>

- **Fail** — Orphan FRs exist (requirements without traceable source) OR 3+ chains have gaps
- **Needs Improvement** — 1-2 chains have gaps but no orphan FRs
- **Pass** — All chains intact, no orphan FRs

<action>For each traceability issue, add a finding:</action>

- Severity: **Critical** if orphan FR (no traceable source) or scope contradiction; **Major** if chain gap (success criterion without journey, journey without FRs); **Minor** if weak traceability (connection exists but is implicit rather than explicit)
- Finding: "{element} has no traceable connection to {expected source}. It appears orphaned."
- Recommendation: "Either trace {element} to a specific {user journey/success criterion/vision element} or remove it if it is not justified."
</step>

<step n="8" goal="Implementation leakage validation — ensure PRD specifies WHAT, not HOW">
<action>Scan the Functional Requirements and Non-Functional Requirements sections specifically for implementation details. A PRD should specify WHAT the system does, never HOW it is built.</action>

<action>Scan for technology names in FRs and NFRs:</action>

**Frontend frameworks:** React, Vue, Angular, Svelte, Solid, Next.js, Nuxt, Remix, Gatsby
**Backend frameworks:** Express, Django, Rails, Spring, Laravel, FastAPI, Flask, NestJS, ASP.NET
**Databases:** PostgreSQL, MySQL, MongoDB, Redis, DynamoDB, Cassandra, SQLite, Firebase, Supabase
**Cloud platforms:** AWS, GCP, Azure, Cloudflare, Vercel, Netlify, DigitalOcean, Heroku
**Infrastructure:** Docker, Kubernetes, Terraform, Ansible, Jenkins, GitHub Actions
**Libraries:** Redux, Zustand, axios, lodash, jQuery, TailwindCSS, Bootstrap
**Data formats:** JSON, XML, YAML, CSV (unless describing a user-facing capability like "export to CSV")
**Architecture patterns:** MVC, microservices, serverless, monolith (unless these are explicit business requirements)

<action>For each term found, determine if it is capability-relevant or implementation leakage:</action>

- **Capability-relevant (acceptable):** "API consumers can access data via REST endpoints" — REST describes the capability interface
- **Implementation leakage (violation):** "The frontend will use React with Redux for state management" — specifies HOW to build
- **Capability-relevant (acceptable):** "Users can export reports as CSV" — describes user-facing capability
- **Implementation leakage (violation):** "Data stored in PostgreSQL with Redis caching" — specifies implementation

<action>Scoring:</action>

- **Fail** — More than 5 leakage violations. PRD is prescribing architecture.
- **Needs Improvement** — 2-5 violations. Some implementation details need removal.
- **Pass** — 0-1 violations. PRD properly specifies WHAT without HOW.

<action>For each leakage violation, add a finding:</action>

- Severity: **Major** for each implementation leakage instance
- Finding: "Implementation leakage in {section}: '{quoted text}' prescribes HOW (specific technology) rather than WHAT (capability)"
- Recommendation: "Rewrite to describe the capability without naming specific technologies. Example: '{rewritten version}'. Technology decisions belong in the Architecture document."
</step>

<step n="9" goal="Domain compliance validation — verify regulated-industry requirements are documented">
<action>Determine the PRD's domain from context clues in the content (Executive Summary, product description, industry references)</action>
<action>Cross-reference against the domain-complexity-prd.csv data loaded in Step 1</action>

<action>**For low-complexity domains** (general, standard consumer apps, content websites, standard business tools):</action>
- Record "Domain Compliance: N/A — Standard domain, no special regulatory requirements"
- Skip to Step 10

<action>**For high-complexity domains** (Healthcare, Fintech, GovTech, Legaltech, Aerospace, Automotive, Energy, Process Control, Building Automation, Insuretech), validate the required special sections are present:</action>

**Healthcare / Healthtech:**
- Clinical Requirements section (patient workflows, clinical data handling)
- Regulatory Pathway (FDA software classification, HIPAA compliance, HL7/FHIR)
- Safety Measures (patient safety, data integrity for clinical decisions)
- Privacy compliance (HIPAA, patient data handling, consent management)

**Fintech / Financial Services:**
- Compliance Matrix (SOC2, PCI-DSS, GDPR, regional financial regulations)
- Security Architecture requirements (encryption, key management, audit logging)
- Audit Requirements (transaction logging, regulatory reporting)
- Fraud Prevention measures (detection, prevention, dispute handling)

**GovTech / Public Sector:**
- Accessibility Standards (WCAG 2.1 AA minimum, Section 508 compliance)
- Procurement Compliance (FedRAMP, government procurement rules)
- Security requirements (security clearance levels, FISMA)
- Data residency requirements (where data can be stored/processed)

**Aerospace / Automotive:**
- Safety certification requirements (DO-178C, ISO 26262)
- Performance validation methodology
- Simulation accuracy requirements
- Export control compliance (ITAR if applicable)

**Other regulated domains:**
- Check domain-complexity-prd.csv `special_sections` column for required sections
- Validate each required section is present and adequately documented

<action>Scoring:</action>

- **Fail** — Required regulatory/compliance sections are missing entirely for a high-complexity domain
- **Needs Improvement** — Required sections exist but are incomplete or lack specificity
- **Pass** — All required domain-specific sections are present and adequately documented

<action>For each missing or inadequate domain section, add a finding:</action>

- Severity: **Critical** if a regulatory section is missing entirely (e.g., no HIPAA section for a healthcare product); **Major** if a regulatory section exists but lacks specific requirements
- Finding: "{domain} products require a {section} section. This section is {missing/inadequate}."
- Recommendation: "Add a dedicated {section} section covering: {specific items from domain-complexity CSV}"
</step>

<step n="10" goal="Project type validation — verify correct sections for the project type">
<action>Determine the project type from the PRD content and context</action>
<action>Cross-reference against the project-types-prd.csv data loaded in Step 1</action>

<action>Match against known project types by scanning for detection signals from the CSV:</action>

- **api_backend** — signals: API, REST, GraphQL, backend, service, endpoints
- **web_app** — signals: website, webapp, browser, SPA, PWA
- **mobile_app** — signals: iOS, Android, app, mobile
- **saas_b2b** — signals: SaaS, B2B, platform, dashboard, teams, enterprise
- **cli_tool** — signals: CLI, command, terminal, bash, script
- **desktop_app** — signals: desktop, Windows, Mac, Linux, native
- **iot_embedded** — signals: IoT, embedded, device, sensor, hardware
- **developer_tool** — signals: SDK, library, package, npm, pip, framework

<action>Once project type is identified, validate from the CSV data:</action>

**Required sections** (from `required_sections` column) — these MUST be present:
- For each required section: Is it present? Is it adequately documented?

**Skip sections** (from `skip_sections` column) — these should NOT be present:
- For each skip section: Is it absent from the PRD?
- If present, it is a violation (e.g., UX/UI sections in an API-only backend PRD)

<action>Build compliance table:</action>

| Required Section | Status |
|-----------------|--------|
| {section_name} | Present / Missing / Incomplete |

| Should-Skip Section | Status |
|--------------------|--------|
| {section_name} | Absent (correct) / Present (violation) |

<action>Scoring:</action>

- **Fail** — Required sections for the project type are missing
- **Needs Improvement** — Required sections exist but are incomplete, or skip sections are present
- **Pass** — All required sections present, no skip-section violations

<action>For each violation, add a finding:</action>

- Severity: **Major** if a required section is missing; **Minor** if a skip section is present (unnecessary content) or a required section is incomplete
- Finding: "{project_type} projects require {section} — this section is {missing/incomplete}" or "{section} is present but not relevant for {project_type} projects"
- Recommendation: "Add {section} with coverage of: {key_questions from CSV}" or "Consider removing {section} — it is not applicable to {project_type} projects"
</step>

<step n="11" goal="SMART requirements validation — score each FR on Specific, Measurable, Achievable, Relevant, Time-bound">
<action>Extract all Functional Requirements from the PRD (with their IDs if numbered)</action>

<action>Score each FR on the SMART framework using a 1-5 scale:</action>

**Specific (1-5):**
- 5: Clear, unambiguous, single-interpretation. A developer reading this knows exactly what to build.
- 4: Mostly clear with minor ambiguity that context resolves.
- 3: Understandable but could be interpreted multiple ways.
- 2: Vague — different developers would build different things from this.
- 1: Completely ambiguous or undefined.

**Measurable (1-5):**
- 5: Has quantifiable acceptance criteria. You can write a test for this.
- 4: Mostly measurable, minor criteria could be more specific.
- 3: Partially measurable — some aspects testable, others subjective.
- 2: Mostly unmeasurable — relies on subjective judgment.
- 1: Completely unmeasurable — no way to verify this requirement is met.

**Achievable (1-5):**
- 5: Clearly realistic within typical project constraints. Well-understood problem.
- 4: Achievable with known approaches, minor unknowns.
- 3: Probably achievable but has significant unknowns or dependencies.
- 2: Questionable feasibility — may require breakthrough or extensive research.
- 1: Unrealistic given current technology or constraints.

**Relevant (1-5):**
- 5: Directly supports a user journey and success criterion. Clear business justification.
- 4: Supports user needs with minor relevance questions.
- 3: Somewhat relevant but connection to user needs is unclear.
- 2: Tangentially related — "nice to have" presented as core requirement.
- 1: Not relevant to stated goals — orphan requirement.

**Traceable (1-5):**
- 5: Explicitly references the user journey, story, or business objective it serves.
- 4: Traceable with reasonable inference from context.
- 3: Partially traceable — connection exists but is not obvious.
- 2: Weakly traceable — requires significant interpretation.
- 1: Orphan — cannot be traced to any source.

<action>Flag any FR with a score below 3 in ANY category — these need improvement</action>

<action>Calculate summary metrics:</action>

- Percentage of FRs with all scores >= 3 (acceptable quality)
- Percentage of FRs with all scores >= 4 (good quality)
- Overall average score across all FRs and all SMART dimensions
- List the lowest-scoring FRs with specific improvement suggestions

<action>Scoring:</action>

- **Fail** — More than 30% of FRs are flagged (any dimension below 3)
- **Needs Improvement** — 10-30% of FRs are flagged
- **Pass** — Fewer than 10% of FRs are flagged

<action>For each flagged FR, add a finding:</action>

- Severity: **Major** if average score below 3; **Minor** if average score 3+ but one dimension is below 3
- Finding: "{FR ID} scores below acceptable quality: Specific={s}, Measurable={m}, Achievable={a}, Relevant={r}, Traceable={t}. Weakest dimension: {dimension} ({score}/5)"
- Recommendation: "Improve {weakest dimension}: {specific suggestion for that dimension}"
</step>

<step n="12" goal="Holistic quality and completeness — assess PRD as a cohesive document and perform final checklist">
<action>This step combines holistic quality assessment with the final completeness checklist. Evaluate the PRD as a WHOLE document, not just individual components.</action>

<action>**Document Flow and Coherence:**</action>

- Read the PRD end-to-end. Does it tell a cohesive story from vision through requirements?
- Are transitions between sections logical? Does each section build on the previous?
- Is there internal consistency? Do NFRs align with FRs? Does scope match requirements?
- Are there contradictions between sections? (e.g., a feature listed as both in-scope and out-of-scope)
- Is the writing style consistent throughout? (Not mixing formal/informal, different terminology for the same concept)

<action>**Dual Audience Effectiveness:**</action>

For Humans:
- Can an executive read the Executive Summary and understand the product vision in 2 minutes?
- Can a developer read the FRs and know exactly what to build?
- Can a designer read the User Journeys and create wireframes?
- Can a stakeholder make go/no-go decisions from the Success Criteria?

For LLMs (downstream agent consumption):
- Is the structure consistent and machine-parseable? (proper heading hierarchy, consistent formatting)
- Can an Architect agent generate architecture from these requirements?
- Can a UX agent generate designs from these user journeys?
- Can a PM agent break these into epics and stories?

<action>**ARIA Principles Compliance:**</action>

| Principle | Check | Status |
|-----------|-------|--------|
| Information Density | Every sentence carries actionable weight | Met / Partial / Not Met |
| Measurability | All requirements are testable | Met / Partial / Not Met |
| Traceability | All requirements trace to user needs | Met / Partial / Not Met |
| Domain Awareness | Domain-specific concerns addressed | Met / Partial / Not Met |
| Zero Anti-Patterns | No filler, no wordiness | Met / Partial / Not Met |
| Dual Audience | Works for humans and LLMs | Met / Partial / Not Met |
| Structured Format | Proper markdown hierarchy | Met / Partial / Not Met |

<action>**Completeness Checklist** — final gate using `{checklist}`:</action>

Verify each item from the PRD checklist:

Requirements Completeness:
- [ ] Problem statement clearly defined with measurable impact
- [ ] Target users/personas identified with needs documented
- [ ] All functional requirements have acceptance criteria
- [ ] Non-functional requirements specified (performance, scalability, security, accessibility)
- [ ] Success metrics defined with measurable targets
- [ ] Scope boundaries clearly stated (in-scope and out-of-scope)

User Stories:
- [ ] User stories follow proper format
- [ ] Acceptance criteria are testable
- [ ] Edge cases and error scenarios addressed
- [ ] User journey flows documented for critical paths

Dependencies and Risks:
- [ ] External dependencies identified
- [ ] Technical constraints documented
- [ ] Known risks listed with mitigation strategies
- [ ] Assumptions explicitly stated

Alignment:
- [ ] PRD aligns with product brief objectives (if brief exists)
- [ ] Research findings incorporated
- [ ] MVP scope is achievable and delivers core value

Quality:
- [ ] No conflicting requirements
- [ ] No ambiguous language
- [ ] Prioritization clear (must-have vs nice-to-have)

<action>**Template Completeness:**</action>
- Scan for any remaining template variables: `{variable}`, `{{variable}}`, `[TBD]`, `TODO`
- Any remaining template variable is a **Critical** finding

<action>**Overall Quality Rating (1-5):**</action>
- **5/5 Excellent** — Exemplary PRD. Ready for architecture and implementation.
- **4/5 Good** — Strong PRD with minor improvements needed. Can proceed.
- **3/5 Adequate** — Acceptable but needs refinement in specific areas.
- **2/5 Needs Work** — Significant gaps or quality issues. Should be revised before proceeding.
- **1/5 Problematic** — Major flaws throughout. Requires substantial revision.

<action>**Identify the Top 3 Improvements** — the three changes that would have the most impact on PRD quality</action>

<action>Add findings for holistic issues:</action>

- Severity: **Critical** if template variables remain or contradictions exist between sections; **Major** if checklist items fail or document flow is incoherent; **Minor** if writing style is inconsistent or structure could be improved
- Finding: Describe the specific quality issue
- Recommendation: Specific, actionable improvement suggestion
</step>

<step n="13" goal="Compile results, post validation report to the platform, and hand off">
<action>Before posting results, retrieve existing comments to track review history:</action>
<action>Call `list_comments` for the PRD document context to retrieve any previous validation comments</action>
<action>Categorize previous comments: how many are open vs resolved</action>
<action>This review history will be included in the validation report</action>

<action>**Create validation report as a document:**</action>

<action>Invoke the `write-document` task from `{project-root}/_aria/core/tasks/write-document.md` with:</action>

```
title: "[{team_name}] PRD Validation Report"
content: |
  ## PRD Validation Report

  **Reviewer:** ARIA PRD Validation Agent (PM Maestro)
  **Date:** {date}
  **Verdict:** {PASS | PASS WITH NOTES | NEEDS REVISION}

  ### Findings Overview
  - Critical: {critical_count}
  - Major: {major_count}
  - Minor: {minor_count}

  ### Review History
  - Previous reviews: {previous_review_count}
  - New findings this review: {new_finding_count}

  ### Validation Results
  | Check | Result | Notes |
  |---|---|---|
  | Format & Structure | {pass/needs improvement/fail} | {classification}: {core_sections_count}/6 core sections |
  | Section Parity | {pass/needs improvement/fail} | {populated}/{total} sections populated |
  | Content Density | {pass/needs improvement/fail} | {violation_count} anti-pattern violations |
  | Brief Coverage | {pass/needs improvement/fail/N/A} | {coverage_summary} |
  | Measurability | {pass/needs improvement/fail} | {violation_count} violations across {fr_count} FRs and {nfr_count} NFRs |
  | Traceability | {pass/needs improvement/fail} | {orphan_count} orphan FRs, {gap_count} chain gaps |
  | Implementation Leakage | {pass/needs improvement/fail} | {leakage_count} technology references in requirements |
  | Domain Compliance | {pass/needs improvement/fail/N/A} | {domain}: {compliance_summary} |
  | Project Type | {pass/needs improvement/fail} | {project_type}: {required_present}/{required_total} required sections |
  | SMART Quality | {pass/needs improvement/fail} | {acceptable_pct}% FRs at acceptable quality |
  | Holistic Quality | {rating}/5 | {label} |
  | Completeness | {pass/needs improvement/fail} | {checklist_pass}/{checklist_total} checklist items |

  ### Overall Quality Rating
  **{rating}/5 — {label}**

  ### Top 3 Improvements
  1. {improvement_1}
  2. {improvement_2}
  3. {improvement_3}

  ### Verdict Explanation
  {1-3 sentence explanation of why this verdict was reached, referencing the most significant findings}

  ### Detailed Findings
  {all findings with severity, section, finding text, and recommendation}
key_map_entry: "documents.prd_validation_report"
```

<action>**Post summary comment on the PRD document:**</action>
<action>Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` with:</action>

```
issue_id_or_document_context: appropriate context for the PRD
body: |
  **PRD Validation: {verdict}**
  Quality Rating: {rating}/5
  Findings: {total_count} ({critical_count} critical, {major_count} major, {minor_count} minor)
  Full report: {validation_report_document_title}
```

<action>**Determine the overall verdict:**</action>

- **PASS** — No Critical findings AND no more than 2 Major findings. Quality rating >= 4/5. PRD is ready for architecture and design.
- **PASS WITH NOTES** — No Critical findings, but 3+ Major findings OR quality rating 3/5. PRD can proceed but improvements are recommended.
- **NEEDS REVISION** — Any Critical findings exist OR quality rating <= 2/5. PRD must be revised before proceeding.

<action>**Report to user:**</action>

**PRD Validation: {verdict}**

- **document:** {prd_document_title}
- **Quality Rating:** {rating}/5 — {label}
- **Findings:** {total_count} ({critical_count} critical, {major_count} major, {minor_count} minor)
- **Validation Report:** {validation_report_document_title}

{if verdict is PASS}
**Next Steps:**
1. PRD is ready — proceed with [Create Architecture] or [Create UX Design]
{end if}

{if verdict is PASS WITH NOTES}
**Next Steps:**
1. Review the validation report on the platform for improvement suggestions
2. Optionally run [Edit PRD] to address major findings
3. PRD can proceed to architecture/design in parallel
{end if}

{if verdict is NEEDS REVISION}
**Next Steps:**
1. Review the validation report on the platform for critical issues
2. Run [Edit PRD] to address critical and major findings
3. Re-run [Validate PRD] after revisions
{end if}

**Top 3 Improvements:**
1. {improvement_1}
2. {improvement_2}
3. {improvement_3}

<action>Invoke the `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "PM"
handoff_type: "prd_validated"
summary: "PRD validation complete. Verdict: {verdict}. {critical_count} critical, {major_count} major, {minor_count} minor findings. Quality rating: {rating}/5."
document_id: "{prd_document_id}"
```

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>
</step>

</workflow>
