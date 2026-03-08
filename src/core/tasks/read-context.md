# Read Context

**Purpose:** Fetch relevant work items, epics, and documents from the project management platform to build context for an agent.

**Parameters:** context_type (required), scope_id (optional), team (optional)

## Context Types
- `project_overview` — all epics, work items, documents
- `epic_detail` — single epic with all child work items
- `story_detail` — single work item with comments, sub-items, architecture context
- `sprint_status` — active sprint work items + backlog
- `document_artefact` — fetch a specific document by key map ID or title
- `previous_story_learnings` — last 3 completed stories' dev records
- `handoff_context` — parse most recent handoff comment on an issue

## Execution
1. READ the platform-specific task at {project-root}/_aria/platform/tasks/read-context.md
2. FOLLOW its instructions with the parameters above
3. Return the structured context block to the calling workflow
