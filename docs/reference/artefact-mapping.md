# Artefact Mapping

Every artefact ARIA produces is stored on the platform. This mapping shows where each artefact type goes and which core task creates it.

## Phase 1 -- Analysis

| Artefact | Entity Type | Core Task | Key Map Entry |
|---|---|---|---|
| Product Brief | Document | `write-document` | `documents.brief` |
| Market Research | Document | `write-document` | `documents.research_market` |
| Domain Research | Document | `write-document` | `documents.research_domain` |
| Technical Research | Document | `write-document` | `documents.research_technical` |
| Brainstorming | Document | `write-document` | `documents.brainstorming` |
| Project Context | Document | `write-document` | `documents.project_context` |

## Phase 2 -- Planning

| Artefact | Entity Type | Core Task | Key Map Entry |
|---|---|---|---|
| PRD | Document | `write-document` | `documents.prd` |
| UX Design | Document | `write-document` | `documents.ux_design` |

## Phase 3 -- Solutioning

| Artefact | Entity Type | Core Task | Key Map Entry |
|---|---|---|---|
| Architecture | Document | `write-document` | `documents.architecture` |
| Epics | Epic | `create-epic` | `projects.*` |
| Stories | Work Item | `create-work-item` | `issues.*` |
| Story Points | Work Item estimate | `set-estimate` | -- |
| Dependencies | Work Item relations | `set-relation` | -- |
| Milestones | Milestone | `create-milestone` | `milestones.*` |
| Readiness Report | Document | `write-document` | `documents.readiness` |

## Phase 4 -- Implementation

| Artefact | Entity Type | Core Task | Key Map Entry |
|---|---|---|---|
| Sprint assignments | Work Item cycle | `assign-to-sprint` | `cycles.*` |
| Dev records | Work Item comments | `post-comment` | -- |
| Code review findings | Work Item comments | `post-comment` | -- |
| Test summaries | Work Item comments | `post-comment` | -- |
| Test reports | Work Item attachments | `attach-report` | -- |
| PR links | Work Item links | `link-pr-to-issue` | -- |
| Retrospective | Document | `write-document` | `documents.retrospective` |

## Key Map

All created IDs are tracked in `_aria/core/.key-map.yaml` for cross-referencing between workflows. The key map is auto-populated -- agents look up IDs here instead of re-querying the platform.
