# Artefact Mapping

Every artefact ARIA produces is stored in Linear. This mapping shows where each artefact type goes and which MCP tool creates it.

## Phase 1 -- Analysis

| Artefact | Linear Entity | MCP Tool | Key Map Entry |
|---|---|---|---|
| Product Brief | Document | `create_document` | `documents.brief` |
| Market Research | Document | `create_document` | `documents.research_market` |
| Domain Research | Document | `create_document` | `documents.research_domain` |
| Technical Research | Document | `create_document` | `documents.research_technical` |
| Brainstorming | Document | `create_document` | `documents.brainstorming` |
| Project Context | Document | `create_document` | `documents.project_context` |

## Phase 2 -- Planning

| Artefact | Linear Entity | MCP Tool | Key Map Entry |
|---|---|---|---|
| PRD | Document | `create_document` | `documents.prd` |
| UX Design | Document | `create_document` | `documents.ux_design` |

## Phase 3 -- Solutioning

| Artefact | Linear Entity | MCP Tool | Key Map Entry |
|---|---|---|---|
| Architecture | Document | `create_document` | `documents.architecture` |
| Epics | Projects | `save_project` | `projects.*` |
| Stories | Issues (in Projects) | `save_issue` | `issues.*` |
| Story Points | Issue estimate | `save_issue` with `estimate` | -- |
| Dependencies | Issue relations | `save_issue` with `blocks`/`blockedBy` | -- |
| Milestones | Milestones | `save_milestone` | `milestones.*` |
| Readiness Report | Document | `create_document` | `documents.readiness` |

## Phase 4 -- Implementation

| Artefact | Linear Entity | MCP Tool | Key Map Entry |
|---|---|---|---|
| Sprint assignments | Issue cycle | `save_issue` with `cycle` | `cycles.*` |
| Dev records | Issue comments | `save_comment` | -- |
| Code review findings | Issue comments | `save_comment` | -- |
| Test summaries | Issue comments | `save_comment` | -- |
| Test reports | Issue attachments | `create_attachment` | -- |
| PR links | Issue links | `save_issue` with `links` | -- |
| Retrospective | Document | `create_document` | `documents.retrospective` |

## Key Map

All created IDs are tracked in `_aria/linear/.linear-key-map.yaml` for cross-referencing between workflows. The key map is auto-populated -- agents look up IDs here instead of re-querying Linear.
