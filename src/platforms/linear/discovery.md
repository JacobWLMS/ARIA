# Linear Discovery — Workspace Setup

**Purpose:** Discover your Linear workspace configuration -- team, statuses, labels, and users -- and populate module.yaml and the key map. Run this once during initial setup and again if your Linear workspace configuration changes.

---

## Prerequisites

- The Linear MCP server must be connected and authenticated (LINEAR_API_KEY set)
- You need access to at least one Linear team

---

## Discovery Workflow

<workflow>

<step n="0" goal="Present purpose and collect essential questions">
<action>Explain to the user what this workflow will do, then ask the essential setup questions in one pass:</action>

```
## ARIA Setup

This workflow will configure your Linear workspace for ARIA. I need a few things from you, then I'll auto-discover the rest.

**Questions:**

1. **Project name** — What is your project called? (default: {directory_name})
2. **Skill level** — What is your development experience level?
   - Beginner — Explain clearly, confirm all decisions
   - Intermediate — Balance detail with speed
   - Expert — Direct and technical, minimal confirmations
3. **Git integration** — Enable Git/GitHub integration? (default: yes)

Your Linear team will be auto-discovered in the next step.
```

<action>Record `project_name`, `user_skill_level`, and `git_enabled` from answers</action>
<action>Derive `autonomy_level` from `user_skill_level`: beginner→interactive, intermediate→balanced, expert→yolo</action>
</step>

<step n="1" goal="Auto-discover Linear team and user identity">
<action>Call `list_teams` to get all accessible teams</action>
<action>If only one team exists, use it automatically and inform the user</action>
<action>If multiple teams exist, present the list and ask the user to select one:</action>

```
Available teams:
1. {team_name_1} (ID: {team_id_1})
2. {team_name_2} (ID: {team_id_2})

Which team should ARIA use?
```

<action>Record the selected `team_name` and `team_id`</action>
<action>Call `list_users` with `team: "{team_id}"` to discover the current user</action>
<action>Auto-detect the current user from the API key owner, or if unclear, ask the user to confirm their identity from the list</action>
<action>Record `user_name` and set `default_assignee` to the current user</action>

**Update config:** Set `linear_team_name`, `linear_team_id`, `user_name`, and `default_assignee` in module.yaml
</step>

<step n="2" goal="Auto-discover and map team statuses">
<action>Call `list_issue_statuses` with `team: "{team_id}"` to get all workflow states</action>

**Auto-map by matching common names** (case-insensitive):

| ARIA Abstract Status | Common Linear Names |
|---|---|
| `backlog` | "Backlog" |
| `todo` | "Todo", "To Do", "Ready", "Ready for Dev" |
| `in_progress` | "In Progress", "Started", "Working" |
| `in_review` | "In Review", "Review", "QA" |
| `done` | "Done", "Completed", "Closed" |
| `cancelled` | "Cancelled", "Canceled", "Won't Fix" |

<action>If auto-mapping succeeds for all statuses, proceed without asking — just report the mapping</action>
<action>If any ARIA status cannot be auto-mapped, ask the user to select the corresponding state</action>

**Update config:** Set `status_names` in module.yaml with the confirmed mapping

**Key difference from Jira:** Linear uses state names directly (`state: "In Progress"`) instead of numeric transition IDs. No transition discovery is needed -- just the state name mapping.
</step>

<step n="3" goal="Check for existing ARIA labels">
<action>Call `list_issue_labels` with `team: "{team_id}"` and `limit: 100` to get all existing labels</action>
<action>Check which ARIA labels already exist by name matching</action>

**Required ARIA labels:**

| Label Name | Purpose |
|---|---|
| `aria-active` | Lock label -- indicates an agent is working on the issue |
| `aria-agent-analyst` | Agent identity -- Analyst (Cadence) is working |
| `aria-agent-pm` | Agent identity -- PM (Maestro) is working |
| `aria-agent-architect` | Agent identity -- Architect (Opus) is working |
| `aria-agent-ux` | Agent identity -- UX Designer (Lyric) is working |
| `aria-agent-sm` | Agent identity -- SM (Tempo) is working |
| `aria-agent-dev` | Agent identity -- Dev (Riff) is working |
| `aria-agent-qa` | Agent identity -- QA (Pitch) is working |
| `aria-agent-tech-writer` | Agent identity -- Tech Writer (Verse) is working |
| `aria-handoff-analyst` | Handoff signal -- Analyst should pick up next |
| `aria-handoff-pm` | Handoff signal -- PM should pick up next |
| `aria-handoff-architect` | Handoff signal -- Architect should pick up next |
| `aria-handoff-ux` | Handoff signal -- UX Designer should pick up next |
| `aria-handoff-sm` | Handoff signal -- SM should pick up next |
| `aria-handoff-dev` | Handoff signal -- Dev should pick up next |
| `aria-handoff-qa` | Handoff signal -- QA should pick up next |
| `aria-quick` | Quick flow issue -- skips full planning |
| `aria-tested` | QA has verified this issue |
| `aria-review-failed` | Code review failed -- needs rework |

<action>Report which labels already exist and which need to be created</action>
</step>

<step n="4" goal="Create missing ARIA labels">
<action>For each missing label from the list above, call `create_issue_label` with:</action>

```
name: "{label_name}"
team: "{team_id}"
```

**Suggested colors** (optional -- Linear auto-assigns if omitted):

| Label Group | Color |
|---|---|
| `aria-active` | Red (#E5484D) |
| `aria-agent-*` | Blue (#3E63DD) |
| `aria-handoff-*` | Orange (#F76B15) |
| `aria-quick` | Purple (#8E4EC6) |
| `aria-tested` | Green (#30A46C) |
| `aria-review-failed` | Red (#E5484D) |

<action>Record each created label's ID in the key map under `labels`</action>

```
Labels created: {count_created}
Labels already existed: {count_existing}
Total ARIA labels: {total_count}
```
</step>

<step n="5" goal="Create ARIA Workspace project">

Linear requires every document to be attached to a project or issue. The **ARIA Workspace** project acts as a container for documents created during early phases (briefs, research, brainstorming) before epic projects exist. Documents can later be reassigned to their specific epic project.

<action>Call `list_projects` with `team: "{team_name}"` and `query: "ARIA Workspace"` to check if it already exists</action>

<action>If the ARIA Workspace project already exists, record its `id` and skip creation</action>

<action>If it does not exist, call `save_project` with:</action>

```
name: "ARIA Workspace"
description: |
  ## ARIA Document Workspace

  Container for ARIA methodology documents that aren't yet associated with a specific epic project.

  Documents created here include:
  - Product briefs (pre-planning phase)
  - Research documents (market, domain, technical)
  - Brainstorming outputs
  - Project context files

  Once epics are created, documents can be reassigned to their specific project via `update_document`.
addTeams: ["{team_name}"]
lead: "{default_assignee}"     # omit if no default_assignee
icon: ":books:"
priority: 4
```

<action>Record the project `id` as `workspace_project_id`</action>

**Update config:** Set `workspace_project_id` and `workspace_project_name` in module.yaml

```
ARIA Workspace project created: {project_url}
This will store documents until they're assigned to specific epic projects.
```
</step>

<step n="6" goal="Populate module.yaml with all discovered values">
<action>Write all discovered and derived values to module.yaml:</action>

- `project_name` — from user answer
- `linear_team_name` — from team discovery
- `user_skill_level` — from user answer
- `git_enabled` — from user answer
- `user_name` — from user identity discovery
- `linear_team_id` — from team discovery
- `status_names` — from status mapping
- `workspace_project_id` — from workspace project creation
- `autonomy_level` — derived from user_skill_level

<action>If autonomy_level is "yolo" or "balanced", update module.yaml directly</action>
<action>If autonomy_level is "interactive", ask user to confirm before writing</action>
</step>

<step n="7" goal="Initialize .linear-key-map.yaml from template">
<action>Read the template from `{project-root}/src/linear/data/.linear-key-map.yaml.template`</action>
<action>Create `{project-root}/_aria/linear/.linear-key-map.yaml` with:</action>

```yaml
team_name: "{discovered_team_name}"
team_id: "{discovered_team_id}"
workspace_project_id: "{workspace_project_id}"
last_updated: "{current_timestamp}"

documents: {}

projects:
  workspace: "{workspace_project_id}"

issues: {}

labels:
{for_each_created_label}
  {label_name}: "{label_id}"
{end_for_each}

pull_requests: {}
```

<action>Ensure the `_aria/linear/` directory exists (create if needed)</action>
</step>

<step n="8" goal="Report what was configured">
<action>Present a summary showing what was asked vs. what was auto-configured:</action>

```
## ARIA Setup Complete

### You provided:
- **Project:** {project_name}
- **Skill Level:** {user_skill_level}
- **Git:** {git_enabled}

### Auto-discovered:
- **Team:** {team_name} ({team_id})
- **User:** {user_name}
- **Autonomy:** {autonomy_level} (derived from {user_skill_level})
- **Statuses Mapped:** {status_count} states
- **Labels:** {labels_created_count} created, {labels_existing_count} already existed
- **ARIA Workspace:** {workspace_project_url}
- **Key Map:** {key_map_path}

### Defaults applied (edit module.yaml to change):
- Communication language: English
- Document language: English
- Project prefix: Epic
- Use cycles: true

### Next Steps

1. Optionally run `/aria-git` to configure Git integration
2. Run `/aria-help` to see what to build next
```
</step>

</workflow>

---

## Troubleshooting

**"No teams found"**: Verify your LINEAR_API_KEY has access to at least one team. Check Linear Settings > API.

**"Permission denied on label creation"**: You may need admin access to the Linear workspace to create labels. Ask a workspace admin to create them, or use Linear Settings > Labels.

**"Status mapping incomplete"**: Your team may use a custom workflow with non-standard state names. Map them manually to the closest ARIA equivalent. The adapter uses these names for `save_issue` state changes.

**"Already ran discovery"**: Safe to re-run. Existing labels will be detected and skipped. The key map will be updated with any new label IDs.
