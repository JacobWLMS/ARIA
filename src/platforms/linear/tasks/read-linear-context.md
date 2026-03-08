# Read Linear Context — Reusable Task

**Purpose:** Fetch relevant Linear issues, projects, and documents to build context for an agent. Returns only what the agent needs for its current task, keeping the context window narrow.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `context_type` | Yes | Type of context needed (see context types below) |
| `scope_id` | No | Specific project ID, issue ID, or document query to scope the fetch |
| `team` | No | Linear team name or ID (defaults to `{linear_team_name}` from module.yaml) |

---

## Context Types

### `project_overview`

**Used by:** Orchestrator, PM (initial PRD creation)

<action>Call `list_projects` with `team: "{team}"` to get all ARIA-managed projects</action>
<action>Call `list_issues` with `team: "{team}"` and `parentId: null` (top-level issues only) and `limit: 20` to get a summary of all issues</action>
<action>Call `list_documents` with `query: "aria"` to find ARIA documents</action>

**Returns:** List of projects (epics) with statuses, document titles, issue summary counts by state

---

### `epic_detail`

**Used by:** SM (create-story), Architect (architecture decisions)

<action>Call `get_project` with `query: "{scope_id}"` and `includeMilestones: true` and `includeMembers: true` and `includeResources: true`</action>
<action>Call `list_issues` with `project: "{scope_id}"` and `limit: 50` to get all issues under this project</action>

**Note:** `includeMilestones: true` is safe here because `get_project` fetches a single project. Do NOT use `includeMilestones: true` on `list_projects` (bulk) — it triggers an API complexity error (15880 > 10000 limit). If you need milestones across multiple projects, call `get_project` per-project instead.

**Returns:** Project details with milestones, members, resources, and all issues with their statuses

---

### `story_detail`

**Used by:** Dev (dev-story), SM (create-story enrichment), QA (qa-testing, code-review)

<action>Call `get_issue` with `id: "{scope_id}"` to load full issue details</action>
<action>Call `list_comments` with `issueId: "{scope_id}"` to load all comments (dev records, handoffs, etc.)</action>
<action>Call `list_issues` with `parentId: "{scope_id}"` to load sub-issues and their completion status</action>
<action>If an architecture document exists in key map, call `get_document` with `id: "{architecture_doc_id}"` to fetch architecture context</action>

**Returns:** Full issue details with comments, sub-issue completion status, parent project summary, architecture excerpts

---

### `sprint_status`

**Used by:** SM (sprint planning), Orchestrator

<action>Call `list_cycles` with `teamId: "{team_id}"` and `type: "current"` to identify the active cycle</action>
<action>Call `list_issues` with `cycle: "{current_cycle_id}"` and `team: "{team}"` to load all issues in the current cycle</action>
<action>Call `list_issues` with `team: "{team}"` and `state: "Backlog"` and `limit: 20` to find unplanned issues</action>

**Returns:** Active cycle issues with statuses, backlog issues not yet in a cycle

---

### `document_artefact`

**Used by:** Any agent needing a specific Linear document

<action>Look up `{scope_id}` in `.key-map.yaml` under `documents`</action>
<action>If found, call `get_document` with `id: "{document_id}"`</action>
<action>If not found, call `list_documents` with `query: "{scope_id}"` to search by title</action>
<action>If a match is found, call `get_document` with `id: "{matched_document_id}"` to load content</action>

**Returns:** Document content in markdown format

---

### `previous_story_learnings`

**Used by:** SM (create-story, to incorporate learnings from previous stories)

<action>Call `list_issues` with `team: "{team}"` and `state: "Done"` and `limit: 3` and `orderBy: "updatedAt"`</action>
<action>For each returned issue, call `list_comments` with `issueId: "{issue_id}"` to extract completion notes</action>

**Returns:** Summary of last 3 completed stories' dev agent records and completion notes

---

### `handoff_context`

**Used by:** Any agent receiving a handoff from a previous agent

<action>Call `list_comments` with `issueId: "{scope_id}"` to load all comments on the issue</action>
<action>Find the most recent comment containing "## Agent Handoff:" in its body</action>
<action>Parse the handoff comment to extract:</action>

- **Completed:** The handoff type (what was finished)
- **Summary:** What the previous agent accomplished
- **Key Decisions:** List of decisions made by the previous agent
- **Open Questions:** Unresolved items the current agent should address
- **Referenced Artefacts:** Document IDs and issue IDs to pre-load

<action>For each referenced artefact:</action>
- If it's a document ID, call `get_document` with `id: "{doc_id}"` to load content
- If it's an issue ID, call `get_issue` with `id: "{issue_id}"` to load details

**Returns:** Parsed handoff context with decisions, questions, and pre-loaded artefact content. This eliminates the need for the receiving agent to re-discover context from scratch.

---

## Output Format

The task returns a structured context block that the calling workflow injects into the agent's prompt:

```markdown
## Linear Context for {agent_name}

### {context_section_1_title}
{content}

### {context_section_2_title}
{content}
```

This replaces the file-system pattern of reading local markdown files. The agent receives the same information but sourced from Linear.
