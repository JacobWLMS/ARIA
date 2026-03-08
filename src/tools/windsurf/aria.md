# ARIA: Multi-Platform Agentic Development

ARIA is an opinionated agentic development method for Linear and Plane. It follows agile/scrum using each platform's native entities. All output goes to the platform, never to local files.

## How to Use

Tell the agent which workflow to run (e.g., "Create a PRD", "Run dev story", "Sprint planning"). The agent matches your request to a workflow below, loads the persona, and follows the instructions.

## Agents

12 personas in `_aria/core/agents/`. Load the YAML to adopt the persona.

Cadence (Analyst), Maestro (PM), Lyric (UX), Opus (Architect), Forte (Security), Harmony (Data), Tempo (SM), Riff (Dev), Pitch (QA), Coda (DevOps), Solo (Quick Flow), Verse (Tech Writer).

## Workflow Index

Read the agent YAML for the persona, then follow the instructions file. All paths relative to project root.

### Quick Flow

| Workflow | Agent | Instructions |
|---|---|---|
| Quick Spec | Solo | `_aria/core/workflows/0-quick-flow/quick-spec/instructions.md` |
| Quick Dev | Solo | `_aria/core/workflows/0-quick-flow/quick-dev/instructions.md` |

### Analysis

| Workflow | Agent | Instructions |
|---|---|---|
| Brainstorm | Cadence | `_aria/core/workflows/1-analysis/brainstorming/instructions.md` |
| Research | Cadence | `_aria/core/workflows/1-analysis/research/instructions.md` |
| Create Brief | Cadence | `_aria/core/workflows/1-analysis/create-product-brief/instructions.md` |
| Generate Context | Cadence | `_aria/core/workflows/1-analysis/generate-project-context/instructions.md` |
| Document Project | Verse | `_aria/core/workflows/1-analysis/document-project/instructions.md` |

### Planning

| Workflow | Agent | Instructions |
|---|---|---|
| Create PRD | Maestro | `_aria/core/workflows/2-plan-workflows/create-prd/instructions.md` |
| Edit PRD | Maestro | `_aria/core/workflows/2-plan-workflows/edit-prd/instructions.md` |
| Validate PRD | Maestro | `_aria/core/workflows/2-plan-workflows/validate-prd/instructions.md` |
| Create UX Design | Lyric | `_aria/core/workflows/2-plan-workflows/create-ux-design/instructions.md` |
| Edit UX Design | Lyric | `_aria/core/workflows/2-plan-workflows/edit-ux-design/instructions.md` |
| Validate UX Design | Lyric | `_aria/core/workflows/2-plan-workflows/validate-ux-design/instructions.md` |

### Solutioning

| Workflow | Agent | Instructions |
|---|---|---|
| Architecture | Opus | `_aria/core/workflows/3-solutioning/create-architecture/instructions.md` |
| Epics & Stories | Maestro | `_aria/core/workflows/3-solutioning/create-epics-and-stories/steps/step-01-validate-prerequisites.md` |
| Impl. Readiness | Opus | `_aria/core/workflows/3-solutioning/check-implementation-readiness/instructions.md` |
| Threat Model | Forte | `_aria/core/workflows/3-solutioning/threat-model/instructions.md` |
| Security Audit | Forte | `_aria/core/workflows/3-solutioning/security-audit/instructions.md` |
| Security Review | Forte | `_aria/core/workflows/3-solutioning/security-review/instructions.md` |
| Data Model | Harmony | `_aria/core/workflows/3-solutioning/data-model/instructions.md` |
| Data Pipeline | Harmony | `_aria/core/workflows/3-solutioning/data-pipeline/instructions.md` |
| Data Migration | Harmony | `_aria/core/workflows/3-solutioning/data-migration/instructions.md` |

### Implementation

| Workflow | Agent | Instructions |
|---|---|---|
| Sprint Planning | Tempo | `_aria/core/workflows/4-implementation/sprint-planning/instructions.md` |
| Sprint Status | Tempo | `_aria/core/workflows/4-implementation/sprint-status/instructions.md` |
| Refine Story | Tempo | `_aria/core/workflows/4-implementation/create-story/instructions.md` |
| Dev Story | Riff | `_aria/core/workflows/4-implementation/dev-story/instructions.md` |
| Code Review | Pitch | `_aria/core/workflows/4-implementation/code-review/instructions.md` |
| QA Testing | Pitch | `_aria/core/workflows/4-implementation/qa-testing/instructions.md` |
| Retrospective | Tempo | `_aria/core/workflows/4-implementation/retrospective/instructions.md` |
| Course Correction | Tempo | `_aria/core/workflows/4-implementation/correct-course/instructions.md` |

### Release

| Workflow | Agent | Instructions |
|---|---|---|
| Release Plan | Coda | `_aria/core/workflows/5-release/release-plan/instructions.md` |
| CI/CD Design | Coda | `_aria/core/workflows/5-release/ci-cd-design/instructions.md` |
| Deploy Strategy | Coda | `_aria/core/workflows/5-release/deploy-strategy/instructions.md` |

### Utility

| Workflow | Agent | Instructions |
|---|---|---|
| Write Document | Verse | `_aria/core/tasks/write-document.md` |
| Critique | -- | `_aria/core/tasks/review-adversarial.md` and siblings |
| Party Mode | -- | `_aria/core/workflows/party-mode/instructions.md` |

## Key Files

- **Config:** `_aria/core/module.yaml`
- **Artefact mapping:** `_aria/core/artefact-mapping.yaml`
- **Key map:** `_aria/core/data/.key-map.yaml`
- **Core tasks:** `_aria/core/tasks/`
- **Platform tasks/config:** `_aria/platform/`
- **Platform marker:** `_aria/platform` ("linear" or "plane")
- **Templates/checklists:** `_aria/shared/`

## Critical Rules

1. All output to platform -- never write artefacts to local files
2. Read `_aria/platform` marker to determine active platform (linear or plane)
3. All MCP tool calls need team/workspace name from module.yaml
4. Invoke `lock-work-item` task before modifying any issue
5. Invoke `post-handoff` task with `context_details` at workflow completion
6. Use `read-context` task before implementation
7. Use `_aria/core/data/.key-map.yaml` for all ID lookups
8. Fibonacci story points (1, 2, 3, 5, 8, 13)
9. Git gated on `git_enabled`; git failures never block platform ops
10. Autonomy from `user_skill_level`: beginner=interactive, intermediate=balanced, expert=yolo
11. Workflow YAMLs inherit from `base-workflow.yaml`; only declare unique fields

## Note

The orchestrator uses Claude Code's Agent tool and is not available in Windsurf. Run workflows manually.
