# Create Architecture — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Creates comprehensive architecture decisions through an 8-step collaborative workflow. You are an Architect facilitating collaborative discovery with the user as an architectural peer — you guide, you do not dictate. All output is written to Linear Documents exclusively. After creation, links the architecture to existing Projects (Epics) and posts a handoff.

## Execution Rules

- NEVER generate content without user input — you are a facilitator, not a content generator
- ALWAYS treat this as collaborative discovery between architectural peers
- ABSOLUTELY NO TIME ESTIMATES — AI development speed has fundamentally changed
- ALWAYS speak in {communication_language}
- Show your analysis before taking any action
- At each step boundary, present the A/P/C menu and WAIT for the user's selection before proceeding
- Autonomy: when `autonomy_level` is `yolo`, auto-proceed on obvious steps; when `balanced`, auto-proceed only when unambiguous; when `interactive`, always wait for explicit user input

## A/P/C Menu Protocol (used in steps 2-7)

After generating content in each step, present:
- **[A] Advanced Elicitation** — Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md`, then return to this menu with refined content
- **[P] Party Mode** — Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md`, then return to this menu with enhanced analysis
- **[C] Continue** — Accept the content and proceed to the next step

User accepts/rejects A or P results before proceeding. FORBIDDEN to advance until C is selected.

---

<workflow>

<step n="1" goal="Initialize and load context from Linear">

<action>Communicate in {communication_language} with {user_name}</action>

**1A. Check for existing architecture:**

<action>Call `list_documents` and search for documents with "Architecture" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found your existing Architecture work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

R/C: Read existing document via `get_document`, analyse what sections are complete, jump to next incomplete step. O: List all 8 steps with descriptions, let user choose. X: Confirm with user, then proceed with fresh setup below.

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "prd"` — REQUIRED</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "product_brief"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "ux_design"` (optional)</action>

If no PRD found: "Architecture requires a PRD. Please run the PRD workflow first." Do NOT proceed without PRD.

**1C. Load reference data:**

<action>Load architecture template from `{template}`</action>
<action>Load `{project-root}/_aria/shared/data/project-types-arch.csv`</action>
<action>Load `{project-root}/_aria/shared/data/domain-complexity-arch.csv`</action>

**1D. Report and confirm:**

"Welcome {user_name}! Architecture workspace ready for {project_name}.

**Documents Loaded:**
- PRD: {status}
- Product Brief: {status}
- UX Design: {status}

Do you have any additional context or documents? **[C] Continue** to project context analysis"

**Success:** All artefacts loaded, PRD validated, user confirmed. **Failure:** Proceeding without PRD, not checking for existing architecture.
</step>

<step n="2" goal="Project context analysis — scope, requirements, and constraints">

**2A. Analyse PRD for architectural implications:**

- **Functional Requirements (FRs):** Extract and categorise all FRs. Count them. Identify which have significant architectural implications — data storage, real-time processing, external integrations, complex business logic.
- **Non-Functional Requirements (NFRs):** Performance targets, security requirements, compliance needs (HIPAA, PCI, GDPR), scalability expectations, availability SLAs.
- **Technical constraints:** Existing systems to integrate with, mandated technologies, deployment restrictions, team skill constraints.
- **Dependencies:** External APIs, third-party services, legacy systems, data migration needs.

**2B. Analyse Projects/Epics (if available):**

<action>Call `list_projects` with `team: "{linear_team_name}"` to discover existing ARIA projects</action>

For each Project found:
<action>Call `get_project` with the project ID to load full details</action>
<action>Call `list_issues` with `project: "{project_id}"` to load issues under the project</action>

For each Project: map structure to architectural components, extract acceptance criteria for technical implications, identify cross-cutting concerns spanning multiple projects, note issue complexity.

**2C. Analyse UX Design (if available):**

Extract architectural implications:
- Component complexity (simple forms vs rich interactions vs data visualisations)
- Animation/transition requirements affecting framework choice
- Real-time update needs (live data, collaborative editing, notifications)
- Platform requirements (responsive, mobile-first, desktop)
- Accessibility standards (WCAG compliance level)
- Offline capability requirements
- Performance expectations (load times, interaction responsiveness)

**2D. Project scale assessment:**

Using the domain-complexity reference data, evaluate:
- Real-time features (none / basic / advanced)
- Multi-tenancy (single / basic / full isolation)
- Regulatory compliance (none / standard / strict)
- Integration complexity (standalone / few APIs / complex ecosystem)
- User interaction complexity (CRUD / moderate / rich interactive)
- Data complexity and volume (simple / moderate / big data / streaming)

Using project-types reference data, classify: web_app, mobile_app, api_backend, full_stack, cli_tool, desktop_app.

**2E. Present analysis for validation:**

"I've analysed your project documentation for {project_name}.

{If projects loaded: 'I see {project_count} projects with {issue_count} total issues.'}
{If no projects: 'I found {fr_count} functional requirements in {category_count} categories.'}

**Key architectural aspects:**
- {Core functionality from FRs}
- {Critical NFRs shaping architecture}
- {UX complexity if loaded}
- {Technical challenges or constraints}
- {Compliance requirements}

**Scale indicators:**
- Complexity: {low/medium/high/enterprise}
- Domain: {classification from project-types data}
- Domain complexity: {from domain-complexity data with suggested workflow}
- Cross-cutting concerns: {list}

Does this match your understanding?"

**2F. Generate content:**

```markdown
## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
{analysis of FRs and architectural implications}

**Non-Functional Requirements:**
{NFRs driving architectural decisions}

**Scale & Complexity:**
- Primary domain: {technical_domain}
- Complexity level: {complexity_level}
- Domain classification: {from reference data}
- Estimated architectural components: {count}

### Technical Constraints & Dependencies
{known constraints, mandated technologies, integration requirements}

### Cross-Cutting Concerns Identified
{concerns affecting multiple components: auth, logging, error handling, etc.}
```

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** Documents deeply analysed, complexity assessed, user validated. **Failure:** Skimming documents, missing NFRs, not validating with user.
</step>

<step n="3" goal="Technology selection with data-driven recommendations">

**3A. Check existing technical preferences** from project context, PRD constraints, and user's stated preferences:

"**Existing Technical Preferences:**
- Languages/Frameworks: {from context or 'None specified'}
- Tools & Libraries: {from context or 'None specified'}
- Platform: {from context or 'None specified'}

{Preferences exist: 'Using these as our starting point.' | None: 'Let us establish preferences now.'}"

**3B. Discover user technical preferences:**

"Let's discuss technology preferences for {project_name}:

**Languages & Frameworks:** Preferences between TypeScript/JavaScript, Python, Go, Rust? Framework familiarity (React, Vue, Angular, Next.js)?

**Databases:** Preferences or existing infrastructure (PostgreSQL, MongoDB, MySQL)?

**Development Experience:** Team skill levels? Technologies to learn vs comfortable with?

**Platform & Deployment:** Cloud provider (AWS, Vercel, Railway)? Containers vs serverless?

**Integrations:** Existing systems/APIs? Third-party services (payment, auth, analytics)?"

**3C. Identify primary technology domain** using project-types reference data:

| Domain | Detection Signals | Typical Starters |
|---|---|---|
| Web app | website, browser, frontend, UI | Next.js, Vite, Remix |
| Mobile app | mobile, iOS, Android | React Native, Expo, Flutter |
| API/Backend | API, REST, GraphQL, microservice | NestJS, Express, Fastify |
| Full-stack | frontend+backend | T3 App, RedwoodJS, Blitz |
| CLI tool | CLI, command line, terminal | oclif, Commander |
| Desktop app | desktop, Electron, native | Electron, Tauri |

**3D. Factor in UX requirements** (if loaded):
- Rich animations -> Framer Motion compatible
- Complex forms -> React Hook Form integrated
- Real-time -> WebSocket/Socket.io ready
- Design system -> Storybook-enabled
- Offline -> Service worker / PWA configured

**3E. Evaluate starter options** — for each viable option, analyse:

- **Technology decisions provided:** Language/TS config, styling solution, testing framework, linting, build tooling, project structure
- **Architectural patterns established:** Code organisation, component conventions, API layering, state management, routing, environment config
- **Dev experience:** Hot reload, TS strictness, debugging, testing infrastructure

**3F. Present recommendations** adapted to skill level:
- **Expert:** Concise comparison with key trade-offs, quick decision
- **Intermediate:** Options with explanations, recommendation with reasoning
- **Beginner:** Friendly explanation ("like a prefab house frame"), clear recommendation

**3G. Generate content:**

```markdown
## Technology Selection

### Primary Technology Domain
{identified domain} based on project requirements

### Starter Options Evaluated
{analysis of options with trade-offs}

### Selected Technology Stack: {stack_name}

**Rationale:** {why chosen, aligned to requirements}

**Initialisation Command:**
```bash
{full command with options}
```

**Decisions Provided by Stack:**
- **Language & Runtime:** {language, version, TS config}
- **Styling:** {approach and configuration}
- **Build Tooling:** {tools and optimisation}
- **Testing:** {setup and configuration}
- **Code Organisation:** {structure and patterns}
- **Dev Experience:** {tools and workflow}

**Note:** Project initialisation should be the first implementation story.
```

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Domain identified, options researched, selection documented. **Failure:** Ignoring UX requirements, not documenting starter decisions.
</step>

<step n="4" goal="Core architectural decisions using ADR format">

**4A. Review what is already decided** from technology selection (step 3), user preferences, project context rules, and starter defaults. List these explicitly — do not re-decide them.

**4B. Classify remaining decisions:**
- **Critical** — Must decide before implementation
- **Important** — Shapes architecture significantly
- **Deferrable** — Can decide later

**4C. Facilitate decisions by category:**

**Category 1 — Data Architecture:**
- Database choice (if not from starter)
- Data modelling approach (ORM, query builder, raw SQL)
- Data validation strategy (schema validation, runtime checks)
- Migration approach (tool, versioning strategy)
- Caching strategy (in-memory, Redis, CDN)

**Category 2 — Authentication & Security:**
- Auth method (JWT, sessions, OAuth, Auth0/Clerk)
- Authorisation patterns (RBAC, ABAC, policy-based)
- Security middleware (CORS, CSP, rate limiting)
- Encryption approach (at rest, in transit, field-level)
- API security (API keys, OAuth scopes, mTLS)

**Category 3 — API & Communication:**
- API design (REST, GraphQL, tRPC, gRPC)
- Documentation approach (OpenAPI, GraphQL schema, auto-generated)
- Error handling standards (codes, response format, retry semantics)
- Rate limiting strategy (per-user, per-endpoint, global)
- Service communication (synchronous, event-driven, message queues)

**Category 4 — Frontend Architecture (if applicable):**
- State management (Context, Zustand, Redux, server state)
- Component architecture (atomic, feature-based, domain-driven)
- Routing strategy (file-based, programmatic, nested)
- Performance optimisation (SSR, SSG, ISR, streaming)
- Bundle optimisation (code splitting, lazy loading, tree shaking)

**Category 5 — Infrastructure & Deployment:**
- Hosting (serverless, containers, PaaS, self-hosted)
- CI/CD approach (GitHub Actions, GitLab CI, etc.)
- Environment configuration (env vars, config service, secrets manager)
- Monitoring/logging (structured logging, APM, error tracking)
- Scaling strategy (horizontal, vertical, auto-scaling triggers)

**4D. For each decision, use ADR format:**

- **Context:** What situation requires this decision? What forces are at play?
- **Decision:** What was decided?
- **Rationale:** Why chosen over alternatives? What trade-offs?
- **Consequences:** Positive/negative outcomes? New constraints?

Adapt facilitation to skill level:
- **Expert:** Concise options with trade-offs, ask preference
- **Intermediate:** Options with explanations, recommendation with reasoning
- **Beginner:** Educational context, real-world analogy, friendly pros/cons, clear suggestion

**4E. Check cascading implications** after each major decision: "This choice means we also need to decide: {related decisions}"

**4F. Generate content:**

```markdown
## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
{critical decisions in ADR format}

**Important Decisions (Shape Architecture):**
{important decisions in ADR format}

**Deferred Decisions (Post-MVP):**
{deferred with rationale}

### Data Architecture
{decisions with context/decision/rationale/consequences}

### Authentication & Security
{decisions with context/decision/rationale/consequences}

### API & Communication Patterns
{decisions with context/decision/rationale/consequences}

### Frontend Architecture
{decisions with context/decision/rationale/consequences}

### Infrastructure & Deployment
{decisions with context/decision/rationale/consequences}

### Decision Impact Analysis
**Implementation Sequence:** {ordered list — what must be implemented first}
**Cross-Component Dependencies:** {how decisions affect each other}
```

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** All critical decisions made with ADR format, cascading implications identified. **Failure:** Dictating instead of facilitating, missing cascading implications.
</step>

<step n="5" goal="Implementation patterns — consistency rules preventing implementer conflicts">

Define patterns that prevent conflicts when multiple AI agents or developers implement different parts of the system. Focus on HOW to implement consistently, not WHAT to implement.

**5A. Identify potential conflict points:**

**Naming conflicts:**
- DB table/column naming (users vs Users vs user; user_id vs userId)
- API endpoint naming (/users vs /user, plural vs singular)
- File/directory naming (UserCard.tsx vs user-card.tsx)
- Component/function/variable naming conventions
- Route parameter formats (:id vs {id} vs [id])

**Structural conflicts:**
- Test locations (__tests__/ vs co-located *.test.ts)
- Component organisation (by feature vs by type)
- Shared utility placement
- Config file organisation
- Static asset organisation

**Format conflicts:**
- API response wrapper ({data, error} vs direct response)
- Error structure ({message, code} vs {error: {type, detail}})
- Date/time formats (ISO strings vs timestamps)
- JSON naming (snake_case vs camelCase)
- Status code usage patterns

**Communication conflicts:**
- Event naming (user.created vs UserCreated)
- Event payload structures
- State update patterns (immutable vs mutation)
- Action naming conventions
- Logging formats and levels

**Process conflicts:**
- Loading state handling
- Error recovery / retry approaches
- Auth flow patterns
- Validation timing (client, server, or both)

**5B. Facilitate pattern decisions:**

For each conflict area, present options and trade-offs: "Given {tech_stack}, different implementers might handle {area} differently. For example, one names tables 'users' while another uses 'Users'. Common approaches: {options with pros/cons}. Which fits our project?"

**5C. Define concrete patterns** — for each decided pattern: the rule stated clearly, a "good" example, and an "anti-pattern" example.

**5D. Generate content:**

```markdown
## Implementation Patterns & Consistency Rules

### Naming Patterns

**Database Naming:** {rules with examples — tables, columns, foreign keys, indices}
**API Naming:** {rules with examples — endpoints, parameters, headers}
**Code Naming:** {rules with examples — files, components, functions, variables}

### Structure Patterns

**Project Organisation:** {test locations, component organisation, shared utilities, config}
**File Structure:** {config placement, assets, documentation, env files}

### Format Patterns

**API Response Formats:** {response wrapper with success/error examples}
**Data Exchange:** {JSON naming, date formats, null handling, booleans}

### Communication Patterns

**Event System:** {naming, payload structure, versioning}
**State Management:** {update approach, action naming, selectors}

### Process Patterns

**Error Handling:** {global handling, boundaries, user messages, logging}
**Loading States:** {naming, global vs local, persistence, UI patterns}

### Enforcement Guidelines

**All implementers MUST:**
- {mandatory pattern rules}

**Good Examples:** {correct usage}
**Anti-Patterns:** {what to avoid}
```

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** All conflict points addressed, patterns have concrete examples, enforcement guidelines documented. **Failure:** Missing conflicts, too prescriptive on details vs consistency.
</step>

<step n="6" goal="System structure — component design, boundaries, API contracts, data model">

**6A. Map requirements to components:**

If Projects (Epics) exist: "Project: {name} -> {module/directory/service}" with issues, cross-project dependencies, shared components.
If no Projects: map FR categories: "FR Category: {name} -> {module/directory/service}" with related FRs, shared functionality, integration points.

**6B. Define complete project directory structure** — specific to this project, not generic:

- **Root config:** Package management, build config, env files (.env.example), CI/CD (.github/workflows/), linting/formatting
- **Source code:** Entry points, core structure, feature/module dirs matching projects, shared utilities, constants, type definitions
- **Tests:** Unit tests matching source structure, integration, e2e, fixtures

**6C. Define architectural boundaries:**

**API Boundaries:** External endpoints, internal service boundaries, auth boundary, data access layer.
**Component Boundaries:** Frontend communication, state management boundaries, service layer, event-driven integration.
**Data Boundaries:** Schema ownership by domain, access patterns (repository vs direct), caching, external data integration.

**6D. Define API contracts** for key surfaces: endpoint patterns, request/response shapes, auth requirements, error formats, pagination.

**6E. Define data model:** Core entities and relationships, key tables/collections, relationship types (1:N, M:N), indexing strategy.

**6F. Generate content:**

```markdown
## System Structure & Component Design

### Complete Project Directory Structure
```
{complete project tree — all files and directories, specific to this project}
```

### Architectural Boundaries

**API Boundaries:** {endpoint groupings, responsibilities}
**Component Boundaries:** {communication patterns, state boundaries}
**Service Boundaries:** {responsibilities, integration patterns}
**Data Boundaries:** {access patterns, schema ownership, caching}

### Requirements to Structure Mapping

**Feature/Project Mapping:** {each project/feature -> specific directories and files}
**Cross-Cutting Concerns:** {shared functionality: auth, logging, errors}

### API Contracts

{key API surfaces with endpoint patterns, request/response shapes}

### Data Model

**Core Entities:** {definitions, relationships, key attributes}
**Schema Design:** {table/collection definitions, indexing strategy}

### Integration Points

**Internal:** {component communication within the system}
**External:** {third-party integration points and patterns}
**Data Flow:** {data flow from input to storage to output}
```

**Present A/P/C menu.** On C, hold content and proceed to step 7.

**Success:** Complete specific project tree, boundaries documented, requirements mapped, API and data model defined. **Failure:** Generic placeholder structure, unmapped requirements, missing boundaries.
</step>

<step n="7" goal="Validation — cross-reference against PRD/UX, gap analysis, readiness assessment">

**7A. Coherence validation:**

- **Decision Compatibility:** All technology choices work together? Versions compatible? Patterns align? No contradictions?
- **Pattern Consistency:** Patterns support decisions? Naming consistent across DB/API/code? Communication patterns coherent end-to-end?
- **Structure Alignment:** Structure supports all decisions? Boundaries respect separation of concerns? Integration points properly structured?

**7B. Requirements coverage validation:**

- **Project/Feature Coverage:** Every project architecturally supported? All issues implementable? Cross-project dependencies handled? Any gaps?
- **FR Coverage:** Every FR category supported? Cross-cutting FRs addressed?
- **NFR Coverage:** Performance addressed (caching, CDN, SSR, indexing)? Security covered (auth, encryption, validation)? Scalability handled (horizontal, auto-scaling)? Compliance supported (data residency, audit logging)?

**7C. Implementation readiness validation:**

- **Decision Completeness:** All critical decisions documented with versions? Patterns prevent conflicts? Examples provided?
- **Structure Completeness:** Project structure specific and complete? Boundaries well-defined?
- **Pattern Completeness:** All conflict points addressed? Naming comprehensive? Process patterns complete?

**7D. Gap analysis:**

- **Critical** (block implementation): Missing decisions, incomplete patterns, missing structure
- **Important** (address now): Areas needing detail, missing examples
- **Nice-to-Have** (later): Additional patterns, tooling recommendations

**7E. Address issues** — for critical/important gaps, facilitate resolution with user:

"I found issues to address:
- {Critical}: Could cause implementation problems. How to resolve?
- {Important}: Not blocking, but improves implementation. Address these?
- {Nice-to-have}: Optional refinements."

Iterate until critical/important gaps are resolved.

**7F. Generate content:**

```markdown
## Architecture Validation Results

### Coherence Validation
**Decision Compatibility:** {assessment}
**Pattern Consistency:** {assessment}
**Structure Alignment:** {assessment}

### Requirements Coverage
**Project/Feature Coverage:** {verification}
**Functional Requirements:** {verification}
**Non-Functional Requirements:** {verification}

### Implementation Readiness
**Decision Completeness:** {assessment}
**Structure Completeness:** {assessment}
**Pattern Completeness:** {assessment}

### Gap Analysis
{findings with priority levels and resolutions}

### Architecture Completeness Checklist

**Requirements Analysis:**
- [x] Project context analysed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**Architectural Decisions:**
- [x] Critical decisions documented with versions
- [x] Technology stack fully specified
- [x] Integration patterns defined
- [x] Performance considerations addressed

**Implementation Patterns:**
- [x] Naming conventions established
- [x] Structure patterns defined
- [x] Communication patterns specified
- [x] Process patterns documented

**System Structure:**
- [x] Directory structure defined
- [x] Component boundaries established
- [x] Integration points mapped
- [x] Requirements-to-structure mapping complete

### Readiness Assessment

**Overall Status:** {READY FOR IMPLEMENTATION / NEEDS ATTENTION}
**Confidence Level:** {high/medium/low}
**Key Strengths:** {list}
**Future Enhancement Areas:** {list}

### Implementation Handoff Notes

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently across all components
- Respect project structure and boundaries
- Refer to this document for all architectural questions

**First Implementation Priority:** {starter command or first step}
```

**Present A/P/C menu.** On C, hold content and proceed to step 8.

**Success:** Coherence confirmed, coverage complete, gaps addressed. **Failure:** Skipping compatibility checks, missing coverage gaps, not resolving issues.
</step>

<step n="8" goal="Write architecture to Linear Document, link to Projects, and hand off">

**8A. Celebrate completion** — summarise what was accomplished: key decisions, scope covered, how the architecture serves the project.

**8B. Compile the complete architecture document:**

<action>Compile using template at `{template}`, incorporating all content from steps 2-7 in order:</action>

1. Project Context Analysis (step 2)
2. Technology Selection (step 3)
3. Core Architectural Decisions (step 4)
4. Implementation Patterns & Consistency Rules (step 5)
5. System Structure & Component Design (step 6)
6. Architecture Validation Results (step 7)

<action>Generate in {document_output_language}</action>

**8C. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Architecture Design: {project_name}"
body_content: "{compiled_architecture_content}"
key_map_id: "architecture"
```

<action>Update `{key_map_file}` with new document ID under `documents.architecture`</action>

**8D. Link architecture to Projects (Epics):**

<action>Call `list_projects` with `team: "{linear_team_name}"` to find all ARIA projects</action>
<action>For each Project, call `get_project` to load details, then call `save_project` to update the description with an Architecture link:</action>

```
id: "{project_id}"
description: |
  {existing_project_description}

  ---
  ## Related Documents
  - Architecture Design: {architecture_document_id}
```

**8E. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "architecture_complete"
summary: "Architecture design created and published to Linear Document. Ready for epic and story creation."
document_id: "{architecture_document_id}"
```

**8F. Report to user:**

**Architecture Design Complete**
- **Linear Document:** {architecture_document_title}
- **Status:** Published
- **ADRs Documented:** {adr_count}
- **Project Links:** {linked_project_count} projects updated
- **Handoff:** SM agent notified

**Next Steps:**
1. Review the architecture in Linear Documents
2. SM can create Epics and Stories with [Create Epics and Stories]
3. Run [Check Implementation Readiness] to validate completeness

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, Projects linked, SM notified, next steps provided. **Failure:** Not publishing, missing links, no handoff.
</step>

</workflow>
