# CI/CD Pipeline Design — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Designs a comprehensive CI/CD pipeline tailored to the project's technology stack, architecture, and deployment requirements. Assesses existing CI/CD configuration, designs pipeline stages with quality gates, and defines environment strategy. All output is written to Linear Documents exclusively.

## Execution Rules

- NEVER generate content without user input — you are a facilitator, not a content generator
- ALWAYS treat this as collaborative design between DevOps peers
- ABSOLUTELY NO TIME ESTIMATES — AI development speed has fundamentally changed
- ALWAYS speak in {communication_language}
- Show your analysis before taking any action
- At each step boundary, present the A/P/C menu and WAIT for the user's selection before proceeding
- Autonomy: when `autonomy_level` is `yolo`, auto-proceed on obvious steps; when `balanced`, auto-proceed only when unambiguous; when `interactive`, always wait for explicit user input

## A/P/C Menu Protocol (used in steps 2-6)

After generating content in each step, present:
- **[A] Advanced Elicitation** — Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md`, then return to this menu with refined content
- **[P] Party Mode** — Invoke `{project-root}/_aria/shared/workflows/party-mode/instructions.md`, then return to this menu with enhanced analysis
- **[C] Continue** — Accept the content and proceed to the next step

User accepts/rejects A or P results before proceeding. FORBIDDEN to advance until C is selected.

---

<workflow>

<step n="1" goal="Initialize and load project context from Linear">

<action>Communicate in {communication_language} with {user_name}</action>

**1A. Check for existing CI/CD design:**

<action>Call `list_documents` and search for documents with "CI/CD" or "Pipeline" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found existing CI/CD design work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

R/C: Read existing document via `get_document`, analyse what sections are complete, jump to next incomplete step. O: List all 7 steps with descriptions, let user choose. X: Confirm with user, then proceed with fresh setup below.

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "architecture"` — REQUIRED</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "prd"` (if available)</action>

If no architecture document found: "CI/CD design benefits significantly from an architecture document. Proceeding without one — some pipeline decisions may need revisiting later."

**1C. Assess current CI/CD state:**

<action>Check the local repository for existing CI/CD configuration files:</action>

Scan for:
- `.github/workflows/` — GitHub Actions
- `Jenkinsfile` — Jenkins
- `.gitlab-ci.yml` — GitLab CI
- `.circleci/config.yml` — CircleCI
- `Dockerfile`, `docker-compose.yml` — Container definitions
- `Makefile` — Build automation
- `package.json` scripts — npm/yarn scripts
- `.env.example` — Environment configuration patterns
- `terraform/`, `pulumi/`, `cdk/` — Infrastructure as code

**1D. Report and confirm:**

"Welcome {user_name}! CI/CD design workspace ready for {project_name}.

**Context Loaded:**
- Architecture: {status}
- PRD: {status}
- Tech Stack: {identified_stack}

**Existing CI/CD:**
- {found_config_files or 'No existing CI/CD configuration found — starting fresh'}

**Questions:**
- What CI/CD platform do you prefer? (GitHub Actions, GitLab CI, Jenkins, etc.)
- Any existing infrastructure constraints?
- What environments do you need? (dev, staging, production, etc.)"

**Success:** Context loaded, existing CI/CD assessed, platform preference known. **Failure:** Not checking for existing config, not asking platform preference.
</step>

<step n="2" goal="Design pipeline stages — lint, test, build, security scan, deploy">

**2A. Define pipeline trigger strategy:**

Based on the project's branching strategy and workflow:
- **Push triggers** — Which branches trigger which stages?
- **PR triggers** — What runs on pull requests?
- **Manual triggers** — What requires human approval?
- **Scheduled triggers** — Nightly builds, security scans?
- **Tag triggers** — Release tag patterns?

**2B. Design pipeline stages:**

For each stage, define: purpose, tools, success criteria, failure action.

**Stage 1 — Validation:**
- Linting (ESLint, Prettier, ruff, golangci-lint, etc.)
- Type checking (TypeScript, mypy, etc.)
- Formatting verification
- Commit message validation (conventional commits)
- Fail fast — block pipeline on validation failures

**Stage 2 — Testing:**
- Unit tests with coverage thresholds
- Integration tests
- E2E tests (if applicable at this stage)
- Test result reporting and artifact storage
- Parallel test execution strategy

**Stage 3 — Build:**
- Application build / compilation
- Docker image build (if containerised)
- Asset compilation and optimisation
- Build artifact versioning and storage
- Build cache strategy

**Stage 4 — Security:**
- Dependency vulnerability scanning (Snyk, Dependabot, Trivy)
- SAST — static application security testing
- Secret scanning
- Container image scanning (if applicable)
- License compliance checking
- Severity thresholds — what blocks deployment?

**Stage 5 — Deploy:**
- Environment-specific deployment steps
- Database migration execution
- Health check verification
- Smoke test execution
- Deployment notification

**2C. Present pipeline design:**

"Here's the proposed pipeline for {project_name}:

```
{visual pipeline flow using ASCII or description}
trigger → validate → test → build → security → deploy
```

**Stage Details:**
{summary of each stage with tools and criteria}

**Estimated pipeline duration:** {rough estimate based on project size}

Does this pipeline structure work? Any stages to add, remove, or reorder?"

**2D. Generate content:**

```markdown
## Pipeline Architecture

### Trigger Strategy
{trigger configuration by branch/event}

### Pipeline Stages

#### Stage 1: Validation
{tools, configuration, success/failure criteria}

#### Stage 2: Testing
{test types, coverage thresholds, parallel strategy}

#### Stage 3: Build
{build steps, artifact management, caching}

#### Stage 4: Security Scanning
{scan types, tools, severity thresholds}

#### Stage 5: Deployment
{deployment steps per environment}

### Pipeline Flow Diagram
{visual representation of pipeline}
```

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** All stages defined with tools and criteria, user validated. **Failure:** Generic stages without project-specific tooling.
</step>

<step n="3" goal="Define quality gates at each stage">

**3A. Establish quality gate criteria:**

For each pipeline stage, define pass/fail thresholds:

**Validation Gates:**
- Zero linting errors (warnings configurable)
- Zero type errors
- Formatting compliant

**Testing Gates:**
- Unit test coverage: {threshold}% (recommend 80%+ for new projects)
- All unit tests passing
- Integration test coverage: {threshold}%
- No flaky test tolerance (auto-retry configurable)
- Performance regression thresholds (if applicable)

**Build Gates:**
- Build succeeds with zero errors
- Bundle size within limits (frontend)
- Docker image size within limits (containerised)
- No build warnings in strict mode

**Security Gates:**
- Zero critical vulnerabilities
- Zero high vulnerabilities (or approved exceptions)
- No secrets detected
- License compliance met
- Container scan clean (if applicable)

**Deployment Gates:**
- All previous stages passed
- Manual approval required for production
- Health checks passing within timeout
- Smoke tests passing
- Error rate below threshold

**3B. Define exception handling:**

- How to handle flaky tests
- Security exception approval process
- Emergency deployment bypass procedure
- Rollback triggers at each stage

**3C. Generate content:**

```markdown
## Quality Gates

### Gate Matrix

| Stage | Metric | Threshold | Blocking | Override |
|---|---|---|---|---|
| Validation | Lint errors | 0 | Yes | No |
| Testing | Unit coverage | {threshold}% | Yes | No |
| Testing | All tests pass | 100% | Yes | Retry x3 |
| Security | Critical vulns | 0 | Yes | Exception |
| Security | High vulns | 0 | Configurable | Approval |
| Deploy | Health check | Pass within 60s | Yes | No |

### Exception Handling
{process for overriding gates}

### Emergency Bypass
{procedure for critical hotfixes}
```

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Measurable thresholds for every gate, exception process defined. **Failure:** Vague quality criteria, no exception handling.
</step>

<step n="4" goal="Specify environment strategy">

**4A. Define environments:**

Based on project requirements, define each environment:

**Development:**
- Purpose: Active development and feature testing
- Deployment: Automatic on push to main/develop
- Data: Seed data or anonymised production subset
- Access: All developers
- Configuration: Debug-friendly, verbose logging

**Staging:**
- Purpose: Pre-production validation, QA testing
- Deployment: Automatic on PR merge to main (or manual)
- Data: Production-like dataset
- Access: Team + QA
- Configuration: Production-like with enhanced logging

**Production:**
- Purpose: Live user-facing environment
- Deployment: Manual approval after staging validation
- Data: Live data
- Access: Restricted
- Configuration: Optimised, minimal logging, full monitoring

**4B. Define environment-specific configuration:**

- Environment variable management strategy
- Secrets management (vault, cloud secrets manager, encrypted env files)
- Feature flags strategy (if applicable)
- Database per environment or shared with isolation
- External service mocking strategy (dev/staging vs production)

**4C. Define promotion strategy:**

- How artifacts move between environments
- What validation occurs at each promotion
- Approval requirements
- Rollback procedure per environment

**4D. Generate content:**

```markdown
## Environment Strategy

### Environment Matrix

| Environment | Trigger | Approval | Data | Purpose |
|---|---|---|---|---|
| Development | Push to {branch} | Auto | Seed | Dev testing |
| Staging | Merge to {branch} | Auto | Prod-like | QA validation |
| Production | Release tag | Manual | Live | Users |

### Environment Configuration

#### Development
{configuration details}

#### Staging
{configuration details}

#### Production
{configuration details}

### Secrets Management
{strategy and tools}

### Promotion Strategy
{how artifacts move between environments}
```

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** All environments defined with clear purposes and configs. **Failure:** Missing environments, unclear promotion strategy.
</step>

<step n="5" goal="Define artifact management and monitoring">

**5A. Define artifact management:**

- Build artifact storage (container registry, package registry, S3, etc.)
- Artifact versioning strategy (git SHA, semantic version, build number)
- Artifact retention policy (how long to keep old artifacts)
- Artifact signing and verification (if required)
- Cache management (build cache, dependency cache)

**5B. Define monitoring and observability for CI/CD:**

- Pipeline monitoring (duration trends, failure rates, flaky tests)
- Deployment monitoring (success rate, rollback frequency, MTTR)
- Alerting (pipeline failures, deployment issues, security findings)
- Dashboarding (pipeline health, deployment frequency, lead time)

**5C. Define notification strategy:**

- Pipeline failure notifications (who, how, when)
- Deployment notifications (channels, format)
- Security finding notifications (severity-based routing)
- Success notifications (optional, configurable)

**5D. Generate content:**

```markdown
## Artifact Management

### Storage Strategy
{where artifacts are stored, registry configuration}

### Versioning
{how artifacts are versioned}

### Retention Policy
{how long artifacts are kept}

## CI/CD Observability

### Pipeline Monitoring
{metrics tracked, alerting thresholds}

### Deployment Monitoring
{deployment metrics, DORA metrics}

### Notification Strategy
{who gets notified, when, how}
```

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** Complete artifact lifecycle defined, monitoring covers pipeline health. **Failure:** No retention policy, missing monitoring.
</step>

<step n="6" goal="Generate pipeline configuration and implementation plan">

**6A. Generate pipeline configuration:**

Based on the chosen CI/CD platform, generate the actual configuration file(s):
- GitHub Actions: `.github/workflows/*.yml`
- GitLab CI: `.gitlab-ci.yml`
- Jenkins: `Jenkinsfile`
- Other: platform-specific config

Include comments explaining each section.

**6B. Create implementation plan:**

Prioritised steps to implement the CI/CD pipeline:
1. Basic pipeline (lint + test + build)
2. Add security scanning
3. Set up environments
4. Add deployment stages
5. Configure monitoring
6. Enable quality gates

**6C. Generate content:**

```markdown
## Implementation Plan

### Phase 1: Foundation
{basic pipeline setup steps}

### Phase 2: Security
{security scanning integration}

### Phase 3: Environments
{environment setup and promotion}

### Phase 4: Deployment
{deployment automation}

### Phase 5: Monitoring
{observability setup}

## Pipeline Configuration Reference

### {platform} Configuration
```{language}
{actual pipeline configuration}
```

### Configuration Notes
{explanation of key configuration decisions}
```

**Present A/P/C menu.** On C, hold content and proceed to step 7.

**Success:** Actionable configuration generated, phased implementation plan. **Failure:** Abstract recommendations without concrete config.
</step>

<step n="7" goal="Write CI/CD design to Linear Document and hand off">

**7A. Celebrate completion** — summarise what was designed: pipeline stages, quality gates, environment strategy, monitoring approach.

**7B. Compile the complete CI/CD design:**

<action>Compile all content from steps 2-6 in order:</action>

1. Pipeline Architecture (step 2)
2. Quality Gates (step 3)
3. Environment Strategy (step 4)
4. Artifact Management & Observability (step 5)
5. Implementation Plan & Configuration (step 6)

<action>Generate in {document_output_language}</action>

**7C. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] CI/CD Pipeline Design"
body_content: "{compiled_cicd_content}"
key_map_id: "cicd_design"
```

<action>Update `{key_map_file}` with new document ID under `documents.cicd_design`</action>

**7D. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "Dev"
handoff_type: "cicd_design_complete"
summary: "CI/CD pipeline design created and published to Linear Document. Ready for implementation."
document_id: "{cicd_document_id}"
```

**7E. Report to user:**

**CI/CD Pipeline Design Complete**
- **Linear Document:** {cicd_document_title}
- **Pipeline Stages:** {stage_count} stages defined
- **Quality Gates:** {gate_count} gates configured
- **Environments:** {env_count} environments defined
- **Handoff:** Dev agent notified

**Next Steps:**
1. Review the CI/CD design in Linear Documents
2. Implement pipeline configuration (Phase 1 first)
3. Run [Deploy Strategy] to design the deployment approach
4. Run [Release Plan] for version planning

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, implementation plan clear, Dev notified. **Failure:** Not publishing, abstract recommendations, no handoff.
</step>

</workflow>
