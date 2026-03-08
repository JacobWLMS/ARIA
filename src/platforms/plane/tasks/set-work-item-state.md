# Set Work Item State — Plane Implementation

**Purpose:** Transition a work item to a new state using Plane's native state system.

## Execution

<step n="1" goal="Resolve state ID">
<action>Read `status_names` from module.yaml to get the mapping of state names to IDs</action>
<action>Look up `{target_state}` in the mapping to get the state ID</action>
</step>

<step n="2" goal="Update work item state">
<action>Call `update_work_item` with:</action>

```
work_item_id: "{work_item_id}"
state_id: "{resolved_state_id}"
```
</step>
