# Plane Discovery — Setup Workflow

**Purpose:** Auto-discover Plane workspace configuration and set up ARIA workflow states, custom properties, work item types, and labels.

---

## Prerequisites

- Plane MCP server must be configured and accessible
- User must have admin access to the target Plane project

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

### Step 3 — Create ARIA custom properties

<action>Call `list_work_item_properties` to check for existing ARIA properties</action>

Create these properties if they don't exist via `create_work_item_property`:

1. **aria_locked_by** (type: text)
   - Description: "ARIA agent lock — name of the agent currently working on this item"
   - Default: "" (empty = unlocked)

2. **aria_handoff_target** (type: select)
   - Description: "ARIA handoff target — which agent should work on this item next"
   - Options: analyst, pm, architect, ux, sm, dev, qa, security, devops, data, tech-writer
   - Default: "" (empty = no handoff pending)

3. **aria_last_agent** (type: select)
   - Description: "ARIA audit trail — which agent last modified this item"
   - Options: analyst, pm, architect, ux, sm, dev, qa, security, devops, data, tech-writer
   - Default: ""

4. **aria_review_status** (type: select)
   - Description: "ARIA review status"
   - Options: pending, passed, failed
   - Default: ""

5. **aria_attention** (type: checkbox)
   - Description: "ARIA attention flag — set when orchestrator needs user input"
   - Default: false

<action>Record all property IDs in module.yaml</action>

### Step 4 — Create ARIA work item types

<action>Call `list_work_item_types` to check for existing types</action>

Create these types if they don't exist via `create_work_item_type`:

1. **Story** — standard user stories from PRD
2. **Tech Spec** — quick-spec items (replaces aria-quick-flow label)
3. **Bug** — defects found during QA/code review
4. **Spike** — research/investigation items
5. **Review Finding** — code review sub-issues

<action>Record type IDs in module.yaml</action>

### Step 5 — Create minimal labels

Only labels that still serve as board-level visual filters (not replaced by properties):

<action>Call `create_label` for:</action>
- `aria-quick-flow` (color: #8B5CF6 purple) — visual indicator for quick-flow items on boards

### Step 6 — Update module.yaml

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

# Plane custom properties (IDs)
plane_properties:
  aria_locked_by: "{property_id}"
  aria_handoff_target: "{property_id}"
  aria_last_agent: "{property_id}"
  aria_review_status: "{property_id}"
  aria_attention: "{property_id}"

# Plane work item types (IDs)
plane_work_item_types:
  story: "{type_id}"
  tech_spec: "{type_id}"
  bug: "{type_id}"
  spike: "{type_id}"
  review_finding: "{type_id}"
```

### Step 7 — Display summary

<action>Present a summary to the user:</action>

```
ARIA Plane Setup Complete!

Project: {project_name} ({project_id})
States: Backlog, Todo, In Progress, In Review, Done, Cancelled
Properties: aria_locked_by, aria_handoff_target, aria_last_agent, aria_review_status, aria_attention
Work Item Types: Story, Tech Spec, Bug, Spike, Review Finding
Labels: aria-quick-flow

Next steps:
1. Run /aria-git to configure Git/GitHub integration (optional)
2. Run /aria-help to get started
```
