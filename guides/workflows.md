# Workflow Guide

ARIA follows a structured 5-phase scrum workflow. Each phase builds on the previous one, with agents handing off context through the project management platform.

## Scrum Pipeline

```
Product Brief → PRD → UX Design → Architecture → Epics & Stories
    ↓
Security Review (threat model) → Data Modeling (if needed)
    ↓
Sprint Planning (capacity check) → Backlog Refinement (estimation)
    ↓
Story Prep → Dev → Code Review → QA → Done
    ↓
Sprint Retrospective (velocity tracking) → Next Sprint
    ↓
Release Planning → CI/CD Design → Deployment Strategy
```

---

## Phase 0 -- Setup

Before starting any project work, configure ARIA:

1. **`/aria-setup`** -- Selects your platform (Plane or Linear) and auto-discovers your team, workflow statuses, and labels. Asks 3-4 essential questions and derives everything else.
2. **`/aria-git`** (optional) -- Configures Git/GitHub integration: branch naming, commit format, PR behavior.

Setup only needs to run once per project.

---

## Phase 1 -- Analysis

**Agent:** Cadence (Analyst)

The analysis phase explores the problem space and establishes project direction.

### Brainstorming (`/aria-brainstorm`)

Interactive brainstorming session using a library of 62 techniques across 11 categories. Targets 50-100+ ideas through structured facilitation. Output is a document on the platform.

### Research (`/aria-research`)

Three research modes in one command:

- **Market research** -- competitive landscape, customer needs, market trends
- **Domain research** -- industry deep-dive, terminology, subject matter expertise
- **Technical research** -- feasibility analysis, architecture options, implementation approaches

### Product Brief (`/aria-brief`)

Guided experience to formalize your product idea into an executive brief. Covers problem statement, target users, value proposition, key features, and success metrics.

### Project Context (`/aria-brief context`)

Scans an existing codebase to generate an LLM-optimized context document. Useful for onboarding ARIA to a project that already has code.

---

## Phase 2 -- Planning

**Agents:** Maestro (PM), Lyric (UX Designer)

The planning phase formalizes requirements and design.

### PRD (`/aria-prd`)

Multi-mode command that auto-detects what to do:

- **No PRD exists** → creates a new PRD through guided interview
- **PRD exists + "edit"** → updates the existing PRD based on feedback
- **"validate" or "check"** → reviews PRD quality and completeness

The PRD is created as a document on the platform using the PRD template and checklist.

### UX Design (`/aria-ux`)

Creates a UX design specification covering user flows, wireframe descriptions, interaction patterns, and accessibility considerations. Reads the PRD for context.

### Epics & Stories (`/aria-epics`)

Breaks the PRD into epics and stories:

- Creates epics with descriptions linking back to the PRD
- Creates work items within each epic with acceptance criteria (Given/When/Then)
- Sets story point estimates using Fibonacci scale (1, 2, 3, 5, 8, 13)
- Establishes dependency relations
- Creates milestones for release tracking

---

## Phase 3 -- Solutioning

**Agents:** Opus (Architect), Forte (Security), Harmony (Data), Maestro (PM)

The solutioning phase defines technical architecture, identifies security risks, models data, and validates readiness.

### Architecture (`/aria-arch`)

Guided workflow to document technical decisions:

- Technology selection with trade-off analysis
- System design and component architecture
- API design and data models
- Infrastructure and deployment strategy
- Security and performance considerations

### Security Review (`/aria-threat`, `/aria-audit`, `/aria-secure`)

After architecture is defined, Forte identifies security risks before implementation:

- **Threat modeling** -- STRIDE-based analysis with trust boundaries and attack trees
- **Security audit** -- code and dependency audit mapped to OWASP Top 10
- **Security review** -- architecture-level security assessment with findings and mitigations

### Data Modeling (`/aria-data`, `/aria-pipeline`, `/aria-migrate`)

When the project involves significant data, Harmony works alongside Opus:

- **Data model** -- ERD and schema design with relationships, indexes, and constraints
- **Data pipeline** -- ETL/ELT pipeline design with scheduling and error handling
- **Data migration** -- migration plan with rollback procedures and validation steps

### Implementation Readiness (`/aria-ready`)

Cross-validates all artefacts before implementation begins:

- PRD completeness and consistency
- Architecture alignment with requirements
- Story quality and estimation
- Dependency resolution
- Risk assessment

---

## Phase 4 -- Implementation

**Agents:** Tempo (SM), Riff (Dev), Pitch (QA)

The implementation phase executes the plan through sprints.

### Sprint Planning (`/aria-sprint`)

Plans the next sprint cycle:

1. **Velocity history** -- loads previous retrospective data for capacity planning
2. **Backlog refinement** -- invokes `/aria-story` for unestimated issues
3. **Story selection** -- picks stories for the sprint based on priority and capacity
4. **Capacity check** -- compares selected story points against average velocity
5. **Sprint assignment** -- assigns selected work items to a sprint cycle

### Story Preparation (`/aria-story`)

Enriches a story with full development context:

- Detailed task breakdown with sub-issues
- Technical implementation notes
- Fibonacci estimation (1, 2, 3, 5, 8, 13)
- Dependency identification and `blockedBy` relations
- Acceptance criteria validation

### Development (`/aria-dev`)

Implements the next story:

1. Finds the next story in "Todo" or "Ready for Dev" state
2. Locks the issue with `aria-active` label
3. Transitions to "In Progress"
4. Implements code with full test coverage (TDD)
5. Creates branch, commits, and PR (if git enabled)
6. Posts dev agent record as a comment
7. Transitions to "In Review"
8. Posts handoff for code review

### Code Review (`/aria-cr`)

Comprehensive adversarial code review:

- Reads the PR diff (if git enabled) and story requirements
- Reviews against code review checklist
- Posts structured findings as a comment
- Approves or requests changes on PR
- On pass: transitions to Done
- On fail: transitions back to In Progress with findings

### QA Testing (`/aria-test`)

Generates tests for reviewed stories:

- Creates API and E2E tests using standard framework patterns
- Runs tests to verify they pass
- Posts test summary as a comment
- Attaches test reports to issue

### Retrospective (`/aria-retro`)

Sprint retrospective with velocity metrics:

- **Throughput** -- stories completed this cycle
- **Velocity** -- total story points delivered
- **Cycle time** -- average time from Todo to Done
- **Quality** -- review pass/fail ratio
- **Estimation accuracy** -- estimated vs. actual effort
- **Velocity trend** -- comparison across last 3-5 sprints

Output is a document that feeds into future sprint capacity planning.

### Course Correction (`/aria-course`)

Handles mid-implementation changes:

- Scope changes, blockers, or priority shifts
- Always requires user approval regardless of autonomy level
- Updates affected stories, re-estimates, and adjusts sprint plan

---

## Phase 5 -- Release

**Agent:** Coda (DevOps & Release)

The release phase prepares the project for deployment after implementation is complete.

### Release Planning (`/aria-release`)

Creates a release plan covering:

- Versioning strategy (semver)
- Changelog generation from completed stories
- Milestone creation for release tracking
- Go/no-go checklist

### CI/CD Design (`/aria-cicd`)

Designs the continuous integration and deployment pipeline:

- Build, test, and deploy stages
- Quality gates (lint, test, coverage, security scan)
- Environment promotion strategy
- Artifact management

### Deployment Strategy (`/aria-deploy`)

Defines how code reaches production:

- Deployment approach (blue-green, canary, rolling)
- Rollback procedures and criteria
- Health checks and monitoring
- Runbook for incident response

---

## Quick Flow

**Agent:** Solo (Quick Flow)

Quick Flow bypasses the full planning pipeline for small, well-understood tasks.

### Quick Spec (`/aria-quick`)

Creates a single work item with an embedded tech spec. No PRD, architecture, or epic required.

### Quick Dev (`/aria-quick-dev`)

Implements a quick-spec story directly, including tests. Skips code review for speed.

---

## Anytime Workflows

These can be invoked at any point regardless of project phase:

| Command | Purpose |
|---|---|
| `/aria-docs` | Document an existing project |
| `/aria-write` | Write any technical document |
| `/aria-diagram` | Generate Mermaid diagrams |
| `/aria-critique` | Review any artefact (adversarial, edges, prose, structure) |
| `/aria-dash` | Project status dashboard |
| `/aria-party` | Multi-agent discussion |
| `/aria-course` | Mid-implementation course correction |

---

## Story Lifecycle

Work items flow through these states during implementation:

```
Backlog → Todo → In Progress → In Review → Done
                      ↑              |
                      └──── fail ────┘
```

- **Backlog** -- created but not yet planned for a sprint
- **Todo** -- assigned to a sprint cycle, ready to be picked up
- **In Progress** -- dev agent is actively working
- **In Review** -- code review and QA testing
- **Done** -- all checks passed, merged
- **Cancelled** -- removed from scope

The review failure loop sends stories back to In Progress with findings, where the dev agent addresses them and re-submits.
