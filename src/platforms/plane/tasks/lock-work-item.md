# Lock/Unlock Work Item — Plane Implementation

**Purpose:** Implement agent locking using Plane labels and comments.

## Execution

<step n="1" goal="Read current work item">
<action>Call `retrieve_work_item` with `work_item_id: "{work_item_id}"`</action>
<action>Check if the `aria:locked` label is present in the work item's labels</action>
<action>Look up the `aria:locked` label ID from `plane_labels.aria_locked` in module.yaml</action>
</step>

<step n="2" goal="Lock or unlock">

**If action is "lock":**
<action>If `aria:locked` label is already on the work item, call `list_work_item_comments` to find the lock comment and identify which agent holds the lock. Report: "Work item is locked by {agent_name}. Wait and retry."</action>
<action>Call `update_work_item` to add the `aria:locked` label ID to the work item's existing labels list</action>
<action>Call `create_work_item_comment` with:</action>

```
work_item_id: "{work_item_id}"
comment_html: "<p><strong>[ARIA:LOCK]</strong> Locked by agent: {agent_name}</p>"
```

**If action is "unlock":**
<action>Call `update_work_item` to remove the `aria:locked` label ID from the work item's labels list</action>
<action>Call `create_work_item_comment` with:</action>

```
work_item_id: "{work_item_id}"
comment_html: "<p><strong>[ARIA:UNLOCK]</strong> Released by agent: {agent_name}</p>"
```
</step>

## Stale Lock Detection

A lock is stale if the `aria:locked` label is present but the work item hasn't been updated in over 1 hour. The orchestrator can force-clear by removing the label.
