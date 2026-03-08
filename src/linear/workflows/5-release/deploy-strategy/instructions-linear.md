# Deployment Strategy — Linear Document Output

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Designs a comprehensive deployment strategy tailored to the project's architecture, infrastructure, and reliability requirements. Evaluates deployment approaches (blue-green, canary, rolling, recreate), defines health checks, rollback procedures, and monitoring requirements. All output is written to Linear Documents exclusively.

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

<step n="1" goal="Initialize and load architecture context from Linear">

<action>Communicate in {communication_language} with {user_name}</action>

**1A. Check for existing deployment strategy:**

<action>Call `list_documents` and search for documents with "Deploy" or "Deployment" in the title</action>

If found, present continuation menu:

"Welcome back {user_name}! I found existing deployment strategy work for {project_name}.
- **[R] Resume** — Continue from where we left off
- **[C] Continue** — Jump to the next logical step
- **[O] Overview** — See all remaining steps
- **[X] Start over** — Begin fresh (creates a new document)"

R/C: Read existing document via `get_document`, analyse what sections are complete, jump to next incomplete step. O: List all 7 steps with descriptions, let user choose. X: Confirm with user, then proceed with fresh setup below.

**1B. Load project context:**

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "project_overview"`</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "architecture"` — REQUIRED</action>
<action>Invoke the `read-linear-context` task with `context_type: "document_artefact"` and `scope_id: "cicd_design"` (if available)</action>

If no architecture document found: "Deployment strategy requires an architecture document to understand deployment targets. Please run the Architecture workflow first." Do NOT proceed without architecture.

**1C. Analyse architecture for deployment implications:**

From the architecture document, extract:
- Deployment targets (cloud provider, container orchestration, serverless, PaaS)
- Service topology (monolith, microservices, serverless functions)
- Database architecture (managed, self-hosted, multi-region)
- External dependencies (third-party APIs, CDNs, message queues)
- Scaling requirements (horizontal, vertical, auto-scaling)
- Availability requirements (SLA, uptime targets)

**1D. Report and confirm:**

"Welcome {user_name}! Deployment strategy workspace ready for {project_name}.

**Context Loaded:**
- Architecture: {status}
- CI/CD Design: {status}

**Deployment Profile:**
- Target: {deployment_target}
- Topology: {service_topology}
- Database: {db_type}
- Availability Target: {sla}

**Questions:**
- What is your downtime tolerance during deployments? (zero, minutes, maintenance window)
- What is your current deployment frequency? (daily, weekly, on-demand)
- Any compliance requirements affecting deployment? (SOC2, HIPAA, PCI)"

**Success:** Architecture loaded, deployment profile understood. **Failure:** Not loading architecture, not understanding deployment targets.
</step>

<step n="2" goal="Assess deployment requirements and constraints">

**2A. Assess downtime tolerance:**

- **Zero downtime required** — Blue-green or canary mandatory
- **Brief downtime acceptable** — Rolling update viable
- **Maintenance window available** — Recreate strategy possible
- **Mixed** — Different strategies for different components

**2B. Assess rollback requirements:**

- How quickly must rollback complete?
- Can database migrations be reversed?
- Are there external state changes that complicate rollback?
- What data consistency guarantees are needed during rollback?

**2C. Assess scale and complexity:**

- Number of services/components to deploy
- Database migration frequency and complexity
- Geographic distribution requirements
- Traffic volume and patterns (steady, bursty, predictable)
- Stateful vs stateless components

**2D. Assess compliance and governance:**

- Change management requirements
- Audit trail needs
- Approval workflows
- Separation of duties requirements
- Data residency constraints

**2E. Present assessment:**

"Based on the architecture and your requirements:

**Deployment Requirements:**
- Downtime tolerance: {assessment}
- Rollback speed: {requirement}
- Service count: {count}
- Traffic pattern: {pattern}
- Compliance: {requirements}

**Key Constraints:**
- {constraint list}

This profile suggests: {preliminary strategy recommendation}"

**2F. Generate content:**

```markdown
## Deployment Requirements Assessment

### Availability Requirements
- Downtime tolerance: {assessment}
- Target SLA: {sla}
- Rollback time objective: {rto}

### Scale & Complexity
- Services: {count and types}
- Database: {migration complexity}
- Traffic: {volume and patterns}
- Geography: {distribution}

### Compliance & Governance
- Change management: {requirements}
- Audit: {requirements}
- Approvals: {workflow}

### Constraints
{identified constraints affecting strategy choice}
```

**Present A/P/C menu.** On C, hold content and proceed to step 3.

**Success:** All requirements assessed, constraints identified. **Failure:** Assuming requirements, not checking compliance.
</step>

<step n="3" goal="Recommend deployment strategy with rationale">

**3A. Evaluate deployment strategies:**

Present each strategy with pros/cons tailored to the project:

**Blue-Green Deployment:**
- Two identical environments, switch traffic atomically
- Pros: Zero downtime, instant rollback, full testing before switch
- Cons: Double infrastructure cost, database migration complexity
- Best for: {assessment for this project}

**Canary Deployment:**
- Gradual traffic shift to new version (1% → 10% → 50% → 100%)
- Pros: Risk mitigation, real traffic validation, controlled rollout
- Cons: Complex routing, monitoring requirements, longer deployment
- Best for: {assessment for this project}

**Rolling Deployment:**
- Replace instances one at a time
- Pros: No extra infrastructure, gradual rollout, resource efficient
- Cons: Mixed versions during rollout, slower rollback, complex state management
- Best for: {assessment for this project}

**Recreate Deployment:**
- Stop old version, deploy new version
- Pros: Simple, clean state, no version mixing
- Cons: Downtime, no gradual validation
- Best for: {assessment for this project}

**3B. Present recommendation:**

"For {project_name}, I recommend **{strategy}**:

**Why {strategy}:**
- {reason aligned to requirements}
- {reason aligned to constraints}
- {reason aligned to team capacity}

**Trade-offs accepted:**
- {trade-off and mitigation}

**Hybrid approach (if applicable):**
- {e.g., blue-green for production, rolling for staging}

Does this strategy align with your expectations?"

**3C. Generate content:**

```markdown
## Deployment Strategy Selection

### Strategy Evaluation

| Strategy | Downtime | Rollback Speed | Cost | Complexity | Fit |
|---|---|---|---|---|---|
| Blue-Green | None | Instant | High | Medium | {rating} |
| Canary | None | Fast | Medium | High | {rating} |
| Rolling | Minimal | Moderate | Low | Medium | {rating} |
| Recreate | Yes | Moderate | Low | Low | {rating} |

### Recommended Strategy: {strategy}

**Rationale:**
{detailed reasoning}

**Trade-offs:**
{accepted trade-offs with mitigations}

### Strategy by Environment
| Environment | Strategy | Rationale |
|---|---|---|
| Development | {strategy} | {reason} |
| Staging | {strategy} | {reason} |
| Production | {strategy} | {reason} |
```

**Present A/P/C menu.** On C, hold content and proceed to step 4.

**Success:** Strategy selected with clear rationale, trade-offs documented. **Failure:** Recommending without assessing fit, no trade-off analysis.
</step>

<step n="4" goal="Define health checks, readiness probes, and deployment verification">

**4A. Define health check types:**

**Liveness Probes:**
- What: Confirms the application process is running
- Endpoint: `/health` or `/livez`
- Checks: Process alive, not deadlocked
- Interval: 10-30 seconds
- Failure action: Restart container/process

**Readiness Probes:**
- What: Confirms the application can serve traffic
- Endpoint: `/ready` or `/readyz`
- Checks: Database connected, cache warm, dependencies reachable
- Interval: 5-15 seconds
- Failure action: Remove from load balancer

**Startup Probes:**
- What: Confirms application has fully initialized
- Endpoint: `/health` with extended timeout
- Checks: Migrations complete, initial data loaded
- Timeout: Longer than liveness (allow for slow startup)
- Failure action: Kill and restart

**4B. Define deployment verification:**

**Smoke Tests:**
- Critical path verification (login, core feature, API health)
- Run automatically after deployment
- Failure triggers rollback

**Integration Verification:**
- External service connectivity
- Database accessibility
- Cache connectivity
- Message queue connectivity

**Performance Baseline:**
- Response time p50, p95, p99 within thresholds
- Error rate below threshold
- Throughput within expected range

**4C. Generate content:**

```markdown
## Health Checks & Deployment Verification

### Health Check Configuration

#### Liveness Probe
- Endpoint: {endpoint}
- Interval: {interval}
- Timeout: {timeout}
- Failure threshold: {count}
- Success threshold: {count}

#### Readiness Probe
- Endpoint: {endpoint}
- Interval: {interval}
- Timeout: {timeout}
- Failure threshold: {count}
- Checks: {what is verified}

#### Startup Probe
- Endpoint: {endpoint}
- Initial delay: {delay}
- Timeout: {timeout}
- Failure threshold: {count}

### Deployment Verification

#### Smoke Tests
{critical paths to verify post-deployment}

#### Integration Checks
{external dependency verification}

#### Performance Baseline
| Metric | Threshold | Action on Breach |
|---|---|---|
| Response time p95 | {threshold} | {action} |
| Error rate | {threshold} | {action} |
| Throughput | {threshold} | {action} |
```

**Present A/P/C menu.** On C, hold content and proceed to step 5.

**Success:** All probe types defined, verification covers critical paths. **Failure:** Missing readiness checks, no performance baseline.
</step>

<step n="5" goal="Create rollback procedure and failure recovery">

**5A. Define rollback triggers:**

Automatic rollback when:
- Health checks fail beyond threshold
- Error rate exceeds {threshold}% for {duration}
- Response time p95 exceeds {threshold} for {duration}
- Smoke tests fail
- Critical alert fires

Manual rollback when:
- User reports indicate regression
- Business metric anomaly detected
- Security incident discovered

**5B. Define rollback procedure:**

Step-by-step rollback instructions specific to the chosen deployment strategy:

**For {chosen_strategy}:**
1. {step 1 — e.g., switch traffic back to previous version}
2. {step 2 — e.g., verify previous version health checks}
3. {step 3 — e.g., confirm traffic fully shifted}
4. {step 4 — e.g., investigate failure in new version}
5. {step 5 — e.g., notify team and stakeholders}

**Database Rollback:**
- If migration is reversible: run down migration
- If migration is not reversible: restore from backup
- Data reconciliation procedure if needed
- Timeline for database rollback

**5C. Define failure recovery scenarios:**

| Scenario | Detection | Response | Recovery Time |
|---|---|---|---|
| Deploy fails mid-rollout | Pipeline alert | Auto-rollback | {time} |
| Health checks fail after deploy | Probe failure | Auto-rollback | {time} |
| Performance degradation | Monitoring alert | Manual assessment | {time} |
| Database migration failure | Migration error | Restore backup | {time} |
| External dependency outage | Integration check | Circuit breaker | {time} |

**5D. Generate content:**

```markdown
## Rollback Procedure

### Automatic Rollback Triggers
{trigger conditions with thresholds}

### Manual Rollback Triggers
{conditions requiring human judgment}

### Rollback Steps ({chosen_strategy})
{numbered step-by-step procedure}

### Database Rollback
{migration reversal strategy}

### Failure Recovery Matrix

| Scenario | Detection | Response | Target Recovery |
|---|---|---|---|
{scenario rows}

### Communication During Rollback
{who to notify, status page updates, stakeholder comms}
```

**Present A/P/C menu.** On C, hold content and proceed to step 6.

**Success:** Clear triggers, step-by-step procedure, all failure scenarios covered. **Failure:** Vague rollback steps, missing database rollback, no communication plan.
</step>

<step n="6" goal="Define monitoring and alerting for deployment">

**6A. Define deployment-specific monitoring:**

**Real-Time Deployment Metrics:**
- Deployment progress (instances updated, traffic shifted)
- Error rate comparison (old vs new version)
- Response time comparison (old vs new version)
- Resource utilization (CPU, memory, connections)

**DORA Metrics:**
- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery (MTTR)

**6B. Define alerting strategy:**

**Critical Alerts (page on-call):**
- Deployment failure
- Health check failure post-deploy
- Error rate spike > {threshold}%
- Complete service outage

**Warning Alerts (notification):**
- Deployment duration exceeds baseline
- Resource utilization above threshold
- Minor error rate increase
- Performance degradation below SLA

**Informational (log/dashboard):**
- Deployment started/completed
- Traffic shift progress
- Test results

**6C. Define dashboarding:**

- Deployment status dashboard (current state, history)
- Service health dashboard (per-environment)
- Comparison dashboard (pre vs post deployment metrics)
- DORA metrics dashboard (trends over time)

**6D. Generate content:**

```markdown
## Deployment Monitoring & Alerting

### Real-Time Deployment Metrics
{metrics tracked during deployment}

### DORA Metrics
{four key metrics with measurement approach}

### Alerting Strategy

| Alert | Severity | Condition | Action |
|---|---|---|---|
{alert rows}

### Dashboards
{dashboard descriptions and key visualizations}

### Post-Deployment Observation Period
- Duration: {time period}
- Metrics to watch: {key metrics}
- Success criteria: {when to consider deployment stable}
- Escalation: {what to do if metrics don't stabilize}
```

**Present A/P/C menu.** On C, hold content and proceed to step 7.

**Success:** Comprehensive monitoring covering deployment lifecycle. **Failure:** No DORA metrics, missing alerting, no observation period.
</step>

<step n="7" goal="Write deployment strategy to Linear Document and hand off">

**7A. Celebrate completion** — summarise what was designed: deployment strategy, health checks, rollback procedure, monitoring approach.

**7B. Compile the complete deployment strategy:**

<action>Compile all content from steps 2-6 in order:</action>

1. Deployment Requirements Assessment (step 2)
2. Deployment Strategy Selection (step 3)
3. Health Checks & Deployment Verification (step 4)
4. Rollback Procedure & Failure Recovery (step 5)
5. Deployment Monitoring & Alerting (step 6)

<action>Generate in {document_output_language}</action>

**7C. Write to Linear Document:**

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Deployment Strategy"
body_content: "{compiled_deploy_strategy_content}"
key_map_id: "deploy_strategy"
```

<action>Update `{key_map_file}` with new document ID under `documents.deploy_strategy`</action>

**7D. Post handoff:**

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "Dev"
handoff_type: "deploy_strategy_complete"
summary: "Deployment strategy designed and published to Linear Document. Covers {strategy} deployment, health checks, rollback procedures, and monitoring."
document_id: "{deploy_strategy_document_id}"
```

**7E. Report to user:**

**Deployment Strategy Complete**
- **Linear Document:** {deploy_strategy_document_title}
- **Strategy:** {chosen_strategy}
- **Environments:** {env_count} covered
- **Rollback:** Procedure defined with {trigger_count} automatic triggers
- **Monitoring:** {alert_count} alerts configured
- **Handoff:** Dev agent notified

**Next Steps:**
1. Review the deployment strategy in Linear Documents
2. Implement health check endpoints in application code
3. Run [CI/CD Design] to integrate deployment into the pipeline
4. Run [Release Plan] for version planning

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md`</action>

**Success:** Document published, strategy actionable, Dev notified. **Failure:** Not publishing, abstract strategy, no handoff.
</step>

</workflow>
