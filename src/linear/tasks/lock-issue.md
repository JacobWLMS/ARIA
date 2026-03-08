# Lock/Unlock Linear Issue — Reusable Task

**Purpose:** Implement simple agent locking by adding or removing the `aria-active` label on a Linear issue. Prevents multiple agents from working on the same issue simultaneously.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `issue_id` | Yes | Linear issue ID or identifier (e.g., `TEAM-42`) |
| `action` | Yes | `"lock"` or `"unlock"` |
| `agent_name` | No | Name of the agent acquiring/releasing the lock (for comment) |

---

## Execution

<workflow>

<step n="1" goal="Read current issue and check labels">
<action>Call `get_issue` with `id: "{issue_id}"`</action>
<action>Record the current labels array from the response</action>
</step>

<step n="2" goal="Check lock state and act">

**If action is "lock":**
<action>Check if `{lock_label}` is already in the issue's labels</action>
- If already locked --> STOP. Report: "Issue {issue_id} is already locked by another agent. Wait and retry, or check if the lock is stale."
- If not locked --> proceed to add the label

<action>Build updated labels array: current labels + `"{lock_label}"`</action>
<action>Call `save_issue` with:</action>

```
id: "{issue_id}"
labels: [{existing_label_names}, "{lock_label}"]
```

<action>If `agent_name` is provided, call `save_comment` with:</action>

```
issueId: "{issue_id}"
body: "Locked by ARIA agent: {agent_name}"
```

<action>Record the returned comment ID from `save_comment` for later cleanup during unlock</action>

**If action is "unlock":**
<action>Build updated labels array: current labels minus `"{lock_label}"`</action>
<action>Call `save_issue` with:</action>

```
id: "{issue_id}"
labels: [{remaining_label_names}]
```

<action>Clean up stale lock comments: call `list_comments` with `issueId: "{issue_id}"` and scan for comments matching "Locked by ARIA agent". For each matching lock comment, call `delete_comment` with `id: "{comment_id}"` to remove it. This prevents lock/unlock comment noise from accumulating on the issue.</action>
</step>

</workflow>

---

## Stale Lock Detection

A lock is considered stale if the issue has been locked for more than 1 hour without any agent activity (no comments or updates). The orchestrator's state reader checks for stale locks during polling and can force-unlock them.

To check for stale locks:
1. Call `list_issues` with `label: "{lock_label}"` and an `updatedAt` filter for issues not updated in the last hour
2. For any results, force-unlock by removing the label and adding a comment via `save_comment`: "Stale lock cleared by orchestrator"
