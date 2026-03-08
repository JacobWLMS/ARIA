# Set Issue State — Reusable Task

**Purpose:** Change the state (status) of a Linear issue. Much simpler than Jira transitions -- Linear uses state names directly, no transition IDs needed. Always verifies the target state exists before applying it.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `issue_id` | Yes | Linear issue ID or identifier (e.g., `TEAM-42`) |
| `target_state` | Yes | Target state name (e.g., `"In Progress"`, `"Done"`) |
| `comment` | No | Optional comment to add explaining the transition |

---

## Execution

<workflow>

<step n="1" goal="Verify target state exists for the team">
<action>Call `get_issue` with `id: "{issue_id}"` to determine which team the issue belongs to</action>
<action>Call `list_issue_statuses` with `team: "{team_id}"` to get all valid states for this team</action>
<action>Check if `{target_state}` exists in the returned statuses (case-insensitive match)</action>

- If found --> proceed to step 2
- If not found --> report warning: "State '{target_state}' is not valid for team '{team_name}'. Available states: {list}. Check status_names in module.yaml."
</step>

<step n="2" goal="Apply the state change">
<action>Call `save_issue` with:</action>

```
id: "{issue_id}"
state: "{target_state}"
```

<action>Verify the update succeeded by checking the response</action>
</step>

<step n="3" goal="Add transition comment (if provided)">
<action>If `comment` is provided, call `save_comment` with:</action>

```
issueId: "{issue_id}"
body: "{comment}"
```
</step>

</workflow>

---

## Error Handling

| Scenario | Action |
|---|---|
| State name not found | List available states, warn user |
| Issue already in target state | Skip silently, return success |
| Permission denied | Report to user -- they may need Linear workspace permissions |
| Network error | Retry once, then report failure |

---

## Key Difference from Jira

Linear uses state names directly (`state: "In Progress"`) instead of numeric transition IDs. There is no need to discover transitions -- just use the state name from `status_names` in module.yaml. The `list_issue_statuses` call is a safety check, not a prerequisite.
