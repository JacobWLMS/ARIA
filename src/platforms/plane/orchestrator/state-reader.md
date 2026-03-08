# Plane State Reader — Orchestrator Component

**Purpose:** Read current project state from Plane using activity-driven polling. More efficient than scanning all work items every cycle.

---

## Primary Path — Activity-Driven (Incremental)

Use this path when `last_poll_timestamp` is available from the previous orchestrator cycle.

<step n="1" goal="Fetch recent activities">
<action>Call `list_work_item_activities` to get recent changes</action>
<action>Filter for activities since the last poll timestamp</action>
<action>If no activities found, fall back to the Full Scan path below</action>
</step>

<step n="2" goal="Fetch changed work items">
<action>For each unique work item ID in the activities, call `retrieve_work_item` to get current state</action>
<action>Look up ARIA label IDs from `plane_labels` in module.yaml</action>
<action>Check if `aria:locked` label is present — if so, record as locked</action>
<action>Check if `aria:attention` label is present — if so, record as needing user attention</action>
<action>Check if `aria:review-failed` label is present — if so, record as review-failed</action>
<action>Call `list_work_item_comments` and find most recent `[ARIA:HANDOFF]` comment — parse `[ARIA:META]` line for `to=` field to determine pending handoff target</action>
</step>

<step n="3" goal="Check for pending intakes">
<action>Call `list_intake_work_items` to see if any ideas are awaiting triage</action>
</step>

---

## Fallback Path — Full Scan

Use on first run or when activity-driven path returns no results.

<step n="1" goal="Scan all work items">
<action>Call `list_work_items` to get all work items</action>
<action>Look up ARIA label IDs from `plane_labels` in module.yaml</action>
<action>Scan each work item's labels for:</action>
- Items with `aria:locked` label → locked items (check staleness via updated_at)
- Items with `aria:attention` label → attention needed
- Items with `aria:review-pending` label → reviews in progress
- Items with `aria:review-failed` label → review failures
- Items in each state → state distribution counts

<action>For items with `aria:locked` label, call `list_work_item_comments` and find the most recent `[ARIA:LOCK]` comment to identify which agent holds the lock</action>
<action>For items needing handoff detection, find the most recent `[ARIA:HANDOFF]` comment and parse `[ARIA:META]` for `to=` field</action>
</step>

<step n="2" goal="Scan epics and sprints">
<action>Call `list_modules` to get all modules (epics) and their statuses</action>
<action>Call `list_cycles` to find active cycles and their work item counts</action>
</step>

<step n="3" goal="Check documents">
<action>Read `.key-map.yaml` to determine which artefacts exist (brief, prd, architecture, etc.)</action>
</step>

<step n="4" goal="Check intakes">
<action>Call `list_intake_work_items` for pending triage items</action>
</step>

<step n="5" goal="Check git status (if enabled)">
<action>If `git_enabled` is true in module.yaml, check for uncommitted changes and unpushed branches locally</action>
</step>

---

## Additional Data (Plane-only)

<step goal="Velocity data">
<action>Call `list_work_logs` for the current cycle to aggregate actual hours spent</action>
<action>Calculate: total_hours, hours_per_story_point (if estimates available), projected_velocity</action>
</step>

---

## Output Format

Produce a compact text summary (NOT verbose YAML):

```
=== ARIA State (Plane) ===
Epics: {count} ({completed}/{total} done)
Work Items: {backlog}B / {todo}T / {in_progress}IP / {in_review}IR / {done}D
Active Sprint: {cycle_name or "none"} ({sprint_items_done}/{sprint_items_total})
Artefacts: brief={Y/N} prd={Y/N} arch={Y/N} ux={Y/N}
Velocity: {hours_logged}h this cycle, {avg_points_per_cycle} pts/cycle

Pending Handoffs: {list of "item_id → target_agent"}
Locked Items: {list of "item_id by agent_name (age)"}
Attention Needed: {list of item_ids}
Review Failures: {list of item_ids}
Pending Intakes: {count} ideas awaiting triage
Git: {clean/dirty} {branch_name}
Parallel: {enabled|disabled} — {active_count}/{max} agents active [or omit if disabled]
  - [{category}] {agent_name} on {item_id} ({elapsed_time} ago)
```

> **Note:** The `Parallel` line is populated from the orchestrator's in-memory concurrency tracker, not from API calls. When `parallel_agents` is `false` in module.yaml, omit the Parallel line entirely.
