# Refine Backlog — Plane Implementation

**Purpose:** Review and estimate unestimated work items in the Plane backlog.

## Execution

<step n="1" goal="Fetch backlog items">
<action>Call `list_work_items` with state filter for backlog/todo items</action>
<action>Filter for items without estimate values</action>
</step>

<step n="2" goal="Estimate each item">
<action>For each unestimated work item:</action>
- Analyze complexity based on description and acceptance criteria
- Apply Fibonacci estimation (1, 2, 3, 5, 8, 13)
- Call `update_work_item` with estimate value

<action>Identify dependencies between items via `list_work_item_relations`</action>
<action>Flag items needing clarification by adding the `aria:attention` label (look up ID from `plane_labels.aria_attention` in module.yaml)</action>
</step>

<step n="3" goal="Report summary">
<action>Report: "{count} items estimated, {flagged} items need clarification"</action>
</step>
