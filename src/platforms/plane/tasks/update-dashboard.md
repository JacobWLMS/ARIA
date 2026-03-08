# Update Project Dashboard — Plane Implementation

**Purpose:** Create or update a project status dashboard page using Plane MCP tools.

## Execution

<step n="1" goal="Gather project data">
<action>Call `list_work_items` to get all work items with states</action>
<action>Call `list_modules` to get all modules (epics) with statuses</action>
<action>Call `list_cycles` to get sprint/cycle information</action>
<action>Call `list_work_logs` to get time tracking data for velocity</action>
<action>Call `list_states` to map state IDs to names</action>
</step>

<step n="2" goal="Calculate metrics">
<action>Count work items by state (backlog, todo, in_progress, in_review, done)</action>
<action>Calculate completion percentage per module</action>
<action>Summarize cycle progress (planned vs completed points)</action>
<action>Aggregate work log hours for velocity data</action>
</step>

<step n="3" goal="Create or update dashboard page">
<action>Check `.key-map.yaml` for existing dashboard page ID</action>
<action>If exists: update via the write-document task</action>
<action>If not: create via the write-document task with key_map_id "dashboard"</action>
</step>
