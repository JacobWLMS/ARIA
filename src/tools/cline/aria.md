# ARIA: Multi-Platform Agentic Development

ARIA (Agentic Reasoning & Implementation Architecture) is an opinionated agentic development method with multi-platform support (Linear, Plane). It follows agile/scrum practices using each platform's native entities for epics, stories, sprints, releases, and documents. All output goes to the selected platform, never to local files.

## How to Use

Tell the agent which workflow to run. Examples:
- "Brainstorm project ideas"
- "Create a PRD"
- "Run dev story"
- "Do a code review"
- "Sprint planning"
- "Threat model this project"
- "Design the data model"

The agent will match your request to a workflow below, load the correct persona, and follow the workflow instructions exactly.

## Agent System

ARIA uses 12 agent personas with an orchestral theme:

| Agent | Persona | Role |
|---|---|---|
| Cadence | Analyst | Research, brainstorming, briefs |
| Maestro | PM | PRD, epics & stories |
| Lyric | UX Designer | UX design specifications |
| Opus | Architect | Architecture, readiness checks |
| Forte | Security | Threat models, audits, reviews |
| Harmony | Data | Data models, pipelines, migrations |
| Tempo | SM | Sprint planning, stories, retros |
| Riff | Dev | Story implementation |
| Pitch | QA | Code review, QA testing |
| Coda | DevOps | Release, CI/CD, deployment |
| Solo | Quick Flow | Quick spec & dev |
| Verse | Tech Writer | Documentation, diagrams |

When a workflow is requested, adopt the specified agent persona and follow its workflow instructions exactly.

## Workflow Index

To execute a workflow: read the agent YAML to adopt the persona, read the workflow config for settings, then read and follow the instructions file step by step.

### Phase 0 -- Quick Flow

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Quick Spec | `_aria/core/agents/quick-flow.agent.yaml` | `_aria/core/workflows/0-quick-flow/quick-spec/workflow.yaml` | `_aria/core/workflows/0-quick-flow/quick-spec/instructions.md` |
| Quick Dev | `_aria/core/agents/quick-flow.agent.yaml` | `_aria/core/workflows/0-quick-flow/quick-dev/workflow.yaml` | `_aria/core/workflows/0-quick-flow/quick-dev/instructions.md` |

### Phase 1 -- Analysis

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Brainstorm | `_aria/core/agents/analyst.agent.yaml` | `_aria/core/workflows/1-analysis/brainstorming/workflow.yaml` | `_aria/core/workflows/1-analysis/brainstorming/instructions.md` |
| Research | `_aria/core/agents/analyst.agent.yaml` | `_aria/core/workflows/1-analysis/research/workflow.yaml` | `_aria/core/workflows/1-analysis/research/instructions.md` |
| Create Brief | `_aria/core/agents/analyst.agent.yaml` | `_aria/core/workflows/1-analysis/create-product-brief/workflow.yaml` | `_aria/core/workflows/1-analysis/create-product-brief/instructions.md` |
| Generate Context | `_aria/core/agents/analyst.agent.yaml` | `_aria/core/workflows/1-analysis/generate-project-context/workflow.yaml` | `_aria/core/workflows/1-analysis/generate-project-context/instructions.md` |
| Document Project | `_aria/core/agents/tech-writer.agent.yaml` | `_aria/core/workflows/1-analysis/document-project/workflow.yaml` | `_aria/core/workflows/1-analysis/document-project/instructions.md` |

### Phase 2 -- Planning

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Create PRD | `_aria/core/agents/pm.agent.yaml` | `_aria/core/workflows/2-plan-workflows/create-prd/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/create-prd/instructions.md` |
| Edit PRD | `_aria/core/agents/pm.agent.yaml` | `_aria/core/workflows/2-plan-workflows/edit-prd/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/edit-prd/instructions.md` |
| Validate PRD | `_aria/core/agents/pm.agent.yaml` | `_aria/core/workflows/2-plan-workflows/validate-prd/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/validate-prd/instructions.md` |
| Create UX Design | `_aria/core/agents/ux-designer.agent.yaml` | `_aria/core/workflows/2-plan-workflows/create-ux-design/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/create-ux-design/instructions.md` |
| Edit UX Design | `_aria/core/agents/ux-designer.agent.yaml` | `_aria/core/workflows/2-plan-workflows/edit-ux-design/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/edit-ux-design/instructions.md` |
| Validate UX Design | `_aria/core/agents/ux-designer.agent.yaml` | `_aria/core/workflows/2-plan-workflows/validate-ux-design/workflow.yaml` | `_aria/core/workflows/2-plan-workflows/validate-ux-design/instructions.md` |

### Phase 3 -- Solutioning

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Create Architecture | `_aria/core/agents/architect.agent.yaml` | `_aria/core/workflows/3-solutioning/create-architecture/workflow.yaml` | `_aria/core/workflows/3-solutioning/create-architecture/instructions.md` |
| Create Epics & Stories | `_aria/core/agents/pm.agent.yaml` | `_aria/core/workflows/3-solutioning/create-epics-and-stories/workflow.yaml` | `_aria/core/workflows/3-solutioning/create-epics-and-stories/steps/step-01-validate-prerequisites.md` |
| Implementation Readiness | `_aria/core/agents/architect.agent.yaml` | `_aria/core/workflows/3-solutioning/check-implementation-readiness/workflow.yaml` | `_aria/core/workflows/3-solutioning/check-implementation-readiness/instructions.md` |
| Threat Model | `_aria/core/agents/security.agent.yaml` | `_aria/core/workflows/3-solutioning/threat-model/workflow.yaml` | `_aria/core/workflows/3-solutioning/threat-model/instructions.md` |
| Security Audit | `_aria/core/agents/security.agent.yaml` | `_aria/core/workflows/3-solutioning/security-audit/workflow.yaml` | `_aria/core/workflows/3-solutioning/security-audit/instructions.md` |
| Security Review | `_aria/core/agents/security.agent.yaml` | `_aria/core/workflows/3-solutioning/security-review/workflow.yaml` | `_aria/core/workflows/3-solutioning/security-review/instructions.md` |
| Data Model | `_aria/core/agents/data.agent.yaml` | `_aria/core/workflows/3-solutioning/data-model/workflow.yaml` | `_aria/core/workflows/3-solutioning/data-model/instructions.md` |
| Data Pipeline | `_aria/core/agents/data.agent.yaml` | `_aria/core/workflows/3-solutioning/data-pipeline/workflow.yaml` | `_aria/core/workflows/3-solutioning/data-pipeline/instructions.md` |
| Data Migration | `_aria/core/agents/data.agent.yaml` | `_aria/core/workflows/3-solutioning/data-migration/workflow.yaml` | `_aria/core/workflows/3-solutioning/data-migration/instructions.md` |

### Phase 4 -- Implementation

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Sprint Planning | `_aria/core/agents/sm.agent.yaml` | `_aria/core/workflows/4-implementation/sprint-planning/workflow.yaml` | `_aria/core/workflows/4-implementation/sprint-planning/instructions.md` |
| Sprint Status | `_aria/core/agents/sm.agent.yaml` | `_aria/core/workflows/4-implementation/sprint-status/workflow.yaml` | `_aria/core/workflows/4-implementation/sprint-status/instructions.md` |
| Refine Story | `_aria/core/agents/sm.agent.yaml` | `_aria/core/workflows/4-implementation/create-story/workflow.yaml` | `_aria/core/workflows/4-implementation/create-story/instructions.md` |
| Dev Story | `_aria/core/agents/dev.agent.yaml` | `_aria/core/workflows/4-implementation/dev-story/workflow.yaml` | `_aria/core/workflows/4-implementation/dev-story/instructions.md` |
| Code Review | `_aria/core/agents/qa.agent.yaml` | `_aria/core/workflows/4-implementation/code-review/workflow.yaml` | `_aria/core/workflows/4-implementation/code-review/instructions.md` |
| QA Testing | `_aria/core/agents/qa.agent.yaml` | `_aria/core/workflows/4-implementation/qa-testing/workflow.yaml` | `_aria/core/workflows/4-implementation/qa-testing/instructions.md` |
| Retrospective | `_aria/core/agents/sm.agent.yaml` | `_aria/core/workflows/4-implementation/retrospective/workflow.yaml` | `_aria/core/workflows/4-implementation/retrospective/instructions.md` |
| Course Correction | `_aria/core/agents/sm.agent.yaml` | `_aria/core/workflows/4-implementation/correct-course/workflow.yaml` | `_aria/core/workflows/4-implementation/correct-course/instructions.md` |

### Phase 5 -- Release

| Workflow | Agent | Workflow Config | Instructions |
|---|---|---|---|
| Release Plan | `_aria/core/agents/devops.agent.yaml` | `_aria/core/workflows/5-release/release-plan/workflow.yaml` | `_aria/core/workflows/5-release/release-plan/instructions.md` |
| CI/CD Design | `_aria/core/agents/devops.agent.yaml` | `_aria/core/workflows/5-release/ci-cd-design/workflow.yaml` | `_aria/core/workflows/5-release/ci-cd-design/instructions.md` |
| Deploy Strategy | `_aria/core/agents/devops.agent.yaml` | `_aria/core/workflows/5-release/deploy-strategy/workflow.yaml` | `_aria/core/workflows/5-release/deploy-strategy/instructions.md` |

### Utility Workflows

| Workflow | Agent | Instructions |
|---|---|---|
| Write Document | `_aria/core/agents/tech-writer.agent.yaml` | `_aria/core/tasks/write-document.md` |
| Mermaid Diagram | `_aria/core/agents/tech-writer.agent.yaml` | (conversational -- no dedicated workflow file) |
| Party Mode | -- | `_aria/core/workflows/party-mode/instructions.md` |
| Critique | -- | See tasks: `_aria/core/tasks/review-adversarial.md`, `_aria/core/tasks/review-edge-cases.md`, `_aria/core/tasks/editorial-review-prose.md`, `_aria/core/tasks/editorial-review-structure.md` |

## Scrum Workflow

```
Product Brief -> PRD -> UX Design -> Architecture -> Epics & Stories
    |
Sprint Planning (capacity check) -> Backlog Refinement (estimation)
    |
Story Prep -> Dev -> Code Review -> QA -> Done
    |
Sprint Retrospective (velocity tracking) -> Next Sprint
```

## Key Files

- **Configuration:** `_aria/core/module.yaml`
- **Agent definitions:** `_aria/core/agents/*.agent.yaml`
- **Base critical actions:** `_aria/core/agents/base-critical-actions.yaml`
- **Base workflow config:** `_aria/core/workflows/base-workflow.yaml`
- **Shared includes:** `_aria/core/workflows/includes/`
- **Artefact mapping:** `_aria/core/artefact-mapping.yaml`
- **Key map:** `_aria/core/data/.key-map.yaml`
- **Reusable tasks (core):** `_aria/core/tasks/`
- **Platform-specific tasks:** `_aria/platform/tasks/`
- **Platform config:** `_aria/platform/platform.yaml`
- **Platform marker:** `_aria/platform` (text file: "linear" or "plane")
- **Shared templates:** `_aria/shared/templates/`
- **Shared checklists:** `_aria/shared/checklists/`

## Critical Rules

1. **All output to platform** -- never write artefacts to local files
2. **Platform detection** -- read `_aria/platform` marker file to determine the active platform (linear or plane) and load the corresponding platform.yaml
3. **Team/workspace required** -- all platform MCP tool calls need the team or workspace name from module.yaml
4. **Lock before work** -- invoke `lock-work-item` task before modifying any issue
5. **State changes** -- use the platform-appropriate method for state transitions (Linear: `save_issue` with `state`; Plane: state update API)
6. **Structured handoffs** -- invoke `post-handoff` task with mandatory `context_details` (decisions, open questions, artefact refs)
7. **Read context first** -- use `read-context` task; use `handoff_context` type to inherit previous agent's decisions
8. **Key map** -- use `_aria/core/data/.key-map.yaml` for all ARIA-to-platform ID lookups
9. **Estimate stories** -- use Fibonacci story points (1, 2, 3, 5, 8, 13)
10. **Track dependencies** -- use platform-appropriate dependency/relation mechanisms
11. **Git is recommended** -- git operations gated on `git_enabled`; git failures never block platform operations
12. **Autonomy levels** -- derived from `user_skill_level` (beginner->interactive, intermediate->balanced, expert->yolo). Course corrections always require approval.
13. **Workflow inheritance** -- all workflow YAMLs inherit from `base-workflow.yaml`; only declare unique fields

## Note on Orchestrator

The automated orchestrator uses Claude Code's Agent tool for subagent spawning and is not available in Cline. Run individual workflows manually instead.
