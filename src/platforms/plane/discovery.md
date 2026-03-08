# Plane Discovery — Setup Workflow

**Purpose:** Auto-discover Plane workspace configuration and set up ARIA workflow states, operational labels, and work item types.

---

## Prerequisites

- Plane MCP server must be configured and accessible
- User must have admin access to the target Plane project

---

## Known Issues

> **Plane MCP serialization bug:** The `list_work_item_properties`, `create_work_item_property`, and related property tools have a serialization bug — the API call succeeds but the MCP response fails with `"None is not of type 'string'"`. Additionally, `update_work_item` has no custom property parameter, making properties unreadable and unwritable via MCP. **ARIA uses labels instead of custom properties on Plane.** This is transparent to agents — the core task dispatchers abstract the mechanism.

> **Parallel MCP call cancellation:** When one MCP call errors, all concurrent calls are cancelled. **Create resources ONE AT A TIME** (sequentially, not in parallel). Always wait for each creation to complete before starting the next.

---

## Procedure

### Step 1 — Discover workspace and project

<action>Call `list_projects` to discover available projects</action>
<action>Present the list to the user and ask them to select the target project</action>
<action>Record `project_id` and `project_name`</action>
<action>Call `get_project_members` with the selected project to discover team members</action>

### Step 2 — Discover and configure workflow states

<action>Call `list_states` to discover existing states in the project</action>

Check if these ARIA workflow states exist:
- **Backlog** (group: backlog)
- **Todo** (group: unstarted)
- **In Progress** (group: started)
- **In Review** (group: started)
- **Done** (group: completed)
- **Cancelled** (group: cancelled)

<action>For each missing state, call `create_state` with:</action>

```
name: "{state_name}"
group: "{group}"
color: "{appropriate_color}"
```

Suggested colors:
- Backlog: #A3A3A3 (gray)
- Todo: #3B82F6 (blue)
- In Progress: #F59E0B (amber)
- In Review: #8B5CF6 (purple)
- Done: #22C55E (green)
- Cancelled: #EF4444 (red)

<action>Record all state IDs in a mapping for module.yaml</action>

### Step 3 — Create ARIA operational labels

ARIA uses labels for agent coordination (locking, attention flags, review status). Labels are fully supported by the Plane MCP and visible on boards.

<action>Call `list_labels` to check for existing ARIA labels</action>

Create these labels ONE AT A TIME if they don't exist via `create_label`:

1. **aria:locked** (color: #EF4444 red)
   - Work item is being worked on by an ARIA agent
   - Agent name is recorded in a lock comment

2. **aria:attention** (color: #F59E0B amber)
   - Orchestrator needs user input on this item

3. **aria:review-pending** (color: #3B82F6 blue)
   - Code review in progress

4. **aria:review-passed** (color: #22C55E green)
   - Code review passed

5. **aria:review-failed** (color: #EF4444 red)
   - Code review failed, needs rework

6. **aria-quick-flow** (color: #8B5CF6 purple)
   - Visual indicator for quick-flow items on boards

<action>Record all label IDs in module.yaml</action>

**Note:** Handoff target and last-agent tracking use structured comments (posted by the `post-handoff` task), not labels. This provides richer context than a label could.

### Step 4 — Enable and create ARIA work item types

> **Prerequisite:** Work item types must be enabled as a project feature before they can be created. This is off by default in new Plane projects.

<action>Call `get_project_features` to check if work item types are enabled</action>
<action>If `is_work_item_type_enabled` is false, call `update_project_features` with `work_item_types: true`</action>

Create types ONE AT A TIME:

<action>Call `list_work_item_types` to check for existing types</action>

Create these types if they don't exist via `create_work_item_type`:

1. **Story** — standard user stories from PRD
2. **Tech Spec** — quick-spec items
3. **Bug** — defects found during QA/code review
4. **Spike** — research/investigation items
5. **Review Finding** — code review sub-issues

<action>Record type IDs in module.yaml</action>

### Step 5 — Update module.yaml

<action>Write the discovered values to module.yaml:</action>

```yaml
project_name: "{project_name}"
team_name: "{project_name}"
team_id: "{project_id}"
platform: "plane"

status_names:
  backlog: "{backlog_state_id}"
  todo: "{todo_state_id}"
  in_progress: "{in_progress_state_id}"
  in_review: "{in_review_state_id}"
  done: "{done_state_id}"
  cancelled: "{cancelled_state_id}"

# Plane operational labels (IDs)
plane_labels:
  aria_locked: "{label_id}"
  aria_attention: "{label_id}"
  aria_review_pending: "{label_id}"
  aria_review_passed: "{label_id}"
  aria_review_failed: "{label_id}"
  aria_quick_flow: "{label_id}"

# Plane work item types (IDs)
plane_work_item_types:
  story: "{type_id}"
  tech_spec: "{type_id}"
  bug: "{type_id}"
  spike: "{type_id}"
  review_finding: "{type_id}"
```

### Step 6 — Update project overview

<action>Call `update_project` with `description` to set the project overview text:</action>

```
description: |
  # {project_name} — ARIA Managed Project

  This project is managed by ARIA (AI-driven development workflow).

  ## Workflow States
  Backlog → Todo → In Progress → In Review → Done (+ Cancelled)

  ## Agent Coordination
  - **Locking:** `aria:locked` label + `[ARIA:LOCK]` comments
  - **Handoffs:** `[ARIA:HANDOFF]` comments with `[ARIA:META]` routing
  - **Reviews:** `aria:review-pending/passed/failed` labels
  - **Attention:** `aria:attention` label for items needing user input

  ## Work Item Types
  Story, Tech Spec, Bug, Spike, Review Finding

  ## Configuration
  See `_aria/platform/platform.yaml` (module.yaml) for IDs and settings.
```

> **Note:** The `description` field updates the project's plain-text description. The rich-text `description_html` (visible in Plane's overview editor) is a separate field that may not be writable via the current MCP tools.

### Step 7 — Display summary

<action>Present a summary to the user:</action>

```
ARIA Plane Setup Complete!

Project: {project_name} ({project_id})
States: Backlog, Todo, In Progress, In Review, Done, Cancelled
Labels: aria:locked, aria:attention, aria:review-pending, aria:review-passed, aria:review-failed, aria-quick-flow
Work Item Types: Story, Tech Spec, Bug, Spike, Review Finding

Project overview updated with ARIA configuration summary.
ARIA uses labels + comments for agent coordination on Plane.
Custom properties are not used due to a Plane MCP serialization bug.

Next steps:
1. Run /aria-git to configure Git/GitHub integration (optional)
2. Run /aria-help to get started
```
