# Lock/Unlock Work Item — Plane Implementation

**Purpose:** Implement agent locking using Plane's custom Work Item Properties instead of labels.

## Execution

<step n="1" goal="Read current work item">
<action>Call `retrieve_work_item` with `work_item_id: "{work_item_id}"`</action>
<action>Check the `aria_locked_by` property value</action>
</step>

<step n="2" goal="Lock or unlock">

**If action is "lock":**
<action>If `aria_locked_by` is already set (non-empty), STOP. Report: "Work item is locked by {aria_locked_by}. Wait and retry."</action>
<action>Call `update_work_item` with property `aria_locked_by` set to `"{agent_name or 'aria-agent'}"`</action>
<action>Call `create_work_item_comment` with:</action>

```
work_item_id: "{work_item_id}"
comment_html: "<p>Locked by ARIA agent: {agent_name}</p>"
```

**If action is "unlock":**
<action>Call `update_work_item` with property `aria_locked_by` set to `""`</action>
<action>Clean up lock comments: call `list_work_item_comments` and delete comments matching "Locked by ARIA agent" via `delete_work_item_comment`</action>
</step>

## Stale Lock Detection

A lock is stale if `aria_locked_by` is set but the work item hasn't been updated in over 1 hour. The orchestrator can force-clear by setting `aria_locked_by` to empty.
