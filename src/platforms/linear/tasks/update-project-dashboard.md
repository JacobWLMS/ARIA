---
name: update-project-dashboard
description: 'Create or update a Linear Document dashboard showing project progress, issue status, cycle status, and recent activity.'
---

# Task: Update Project Dashboard

**Purpose:** Creates or updates a Linear Document dashboard that provides a single-page view of project progress across all ARIA phases. Pulls data from Linear projects, issues, cycles, and documents.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `trigger` | No | What triggered the update (e.g., "post-handoff", "manual", "sprint-complete") |

---

## Execution

<workflow>

<step n="1" goal="Gather Linear document data">
<action>Read `{key_map_file}` to get all known document IDs</action>
<action>For each artefact type, check if a document exists:</action>

| Phase | Artefact | Key Map Path |
|---|---|---|
| Phase 1 | Research | `documents.research` |
| Phase 1 | Product Brief | `documents.brief` |
| Phase 1 | Brainstorming | `documents.brainstorming` |
| Phase 1 | Project Context | `documents.project_context` |
| Phase 2 | PRD | `documents.prd` |
| Phase 2 | UX Design | `documents.ux` |
| Phase 3 | Architecture | `documents.architecture` |
| Phase 3 | Readiness Report | `documents.readiness` |
| Phase 4 | Retrospectives | `documents.retrospective_*` |

<action>For each existing document, call `get_document` with `id: "{doc_id}"` to confirm it still exists and get its title</action>
<action>Build a phase progress summary: which artefacts exist, which are pending</action>
</step>

<step n="2" goal="Gather Linear project and issue data">
<action>Call `list_projects` with `team: "{linear_team_name}"` to get all ARIA projects (epics)</action>

<action>For each project, call `list_issues` with `project: "{project_id}"` and `limit: 50` to get all issues</action>

<action>Build a Project --> Issues tree with status counts per project</action>

<action>Check for active cycle data:</action>
<action>Call `list_cycles` with `teamId: "{linear_team_id}"` and `type: "current"` to find the active cycle</action>
<action>If a current cycle exists, call `list_issues` with `cycle: "{cycle_id}"` and `team: "{linear_team_name}"` to find issues in the active cycle</action>
</step>

<step n="3" goal="Compile dashboard content">
<action>Build the dashboard document content:</action>

```markdown
# {project_name} -- Project Dashboard

**Last Updated:** {timestamp}
**Updated By:** ARIA Dashboard Agent
**Trigger:** {trigger}

---

## Phase Progress

| Phase | Status | Artefacts |
|---|---|---|
| Phase 1: Analysis | {complete/in-progress/not-started} | {list of existing artefacts} |
| Phase 2: Planning | {complete/in-progress/not-started} | {list of existing artefacts} |
| Phase 3: Solutioning | {complete/in-progress/not-started} | {list of existing artefacts} |
| Phase 4: Implementation | {complete/in-progress/not-started} | {list of existing artefacts} |

---

## Project (Epic) & Issue Status

{for_each_project}
### {project_name} -- {project_state}

| Status | Count |
|---|---|
| Done | {done_count} |
| In Progress | {in_progress_count} |
| In Review | {review_count} |
| Todo / Backlog | {backlog_count} |

**Progress:** {done_count}/{total_count} issues complete ({percentage}%)
{end_for_each}

---

## Cycle Status

**Active Cycle:** {cycle_name} ({cycle_state})
**Issues in Cycle:** {cycle_issue_count}
**Cycle Progress:** {cycle_done}/{cycle_total} ({cycle_percentage}%)

---

## Recent Activity

| Date | Event | Details |
|---|---|---|
{last_5_state_changes_or_comments}

---

## Review Findings Summary

| Review Type | Target | Findings | Status |
|---|---|---|---|
{for_each_recent_review}
| {review_type} | {target} | {finding_count} ({critical}/{major}/{minor}) | {open/resolved} |
{end_for_each}
```
</step>

<step n="4" goal="Write dashboard to Linear Document">
<action>Invoke `write-to-linear-doc` task with:</action>

```
title: "{project_name} -- Project Dashboard"
body_content: "{compiled_dashboard_content}"
project_id: ""                   # not tied to a single project
key_map_id: "dashboard"
icon: "chart_with_upwards_trend"
```
</step>

</workflow>

---

## Return Value

Returns the dashboard document ID. Can be called repeatedly -- the write-to-linear-doc task handles idempotent updates.
