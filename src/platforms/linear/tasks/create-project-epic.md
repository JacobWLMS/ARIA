# Create Project (Epic) — Reusable Task

**Purpose:** Create a Linear Project to represent an ARIA Epic. Linear Projects serve as the epic-level container, with issues inside them acting as stories. Optionally creates milestones and assigns a lead.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `epic_name` | Yes | Name for the project/epic (e.g., "Epic 1: User Authentication") |
| `epic_description` | Yes | Description of the epic's goals, scope, and FR coverage |
| `team_name` | Yes | Linear team name to associate with the project |
| `milestones` | No | Array of `{name, targetDate, description}` for project milestones |
| `lead` | No | Username or email of the project lead |

---

## Execution

<workflow>

<step n="1" goal="Resolve lead user (if provided)">
<action>If `lead` is provided, call `list_users` with `query: "{lead}"` to resolve the user</action>
<action>Record the user ID for the `lead` parameter on `save_project`</action>
<action>If no user found, warn and proceed without a lead assignment</action>
</step>

<step n="2" goal="Resolve team">
<action>Call `list_teams` with `query: "{team_name}"` to resolve the team ID</action>
<action>Record the team ID for the `addTeams` parameter</action>
</step>

<step n="3" goal="Create the Linear Project">
<action>Call `save_project` with:</action>

```
name: "{epic_name}"
description: "{epic_description}"
addTeams: ["{team_id}"]
lead: "{lead_user_id}"          # omit if not resolved
state: "planned"
priority: 1                     # default priority; override per workflow
```

<action>Record the returned project ID</action>
</step>

<step n="4" goal="Create milestones (if provided)">
<action>For each milestone in `{milestones}`:</action>

<action>Call `save_milestone` with:</action>

```
project: "{project_id}"
name: "{milestone.name}"
description: "{milestone.description}"     # omit if not provided
targetDate: "{milestone.targetDate}"       # omit if not provided
```

<action>Record the milestone IDs</action>
</step>

<step n="5" goal="Update key map">
<action>Update `{key_map_file}` under `projects.{epic_kebab_name}` with the project ID</action>
<action>Update `last_updated` timestamp</action>
</step>

</workflow>

---

## Key Differences from Jira Epics

- **Jira Epic** = issue type. **Linear Project** = first-class container with its own milestones, resources, and lead.
- Stories are linked to projects via the `project` field on `save_issue`, not via a parent/epic link.
- Projects have their own state machine: `planned`, `started`, `paused`, `completed`, `canceled`.
- Milestones are a native project feature in Linear -- no equivalent in standard Jira.

---

## Return Value

Returns the project ID and any milestone IDs for use by the calling workflow.
