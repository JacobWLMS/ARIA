# Sprint Planning — sprint Management

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

This workflow manages sprint planning via sprints. It discovers stories from the platform, helps prioritize them for a cycle, and assigns them. sprints are created in the platform UI -- this workflow lists available cycles and assigns issues to them.

---

<workflow>

<step n="1" goal="Read current platform project state">

**Progress: Step 1 of 5** -- Next: Determine Action

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Load Active Cycle

<action>Invoke the platform's cycle listing for `{team_name}` to find all cycles (active, upcoming, completed)</action>
<action>Identify the active cycle (current date falls within its start/end dates) and any upcoming cycles</action>

### 1.2 Load Issues in Active Cycle

<action>If an active cycle exists, invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `cycles: ["{active_cycle_name}"]` to get issues in the cycle</action>

### 1.3 Load Backlog Issues

<action>Invoke the `read-context` task with `context_type: "work_items"`, `team: "{team_name}"`, `states: ["Backlog", "Todo"]` to find unplanned backlog issues not assigned to any cycle</action>

### 1.4 Load Projects (Epics)

<action>Call `list_projects` with `team: "{team_name}"` to get all projects for epic overview</action>

### 1.5 Previous Story Learnings

<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "previous_story_learnings"` to incorporate insights from recently completed stories</action>

### 1.6 Sprint Velocity History

<action>Invoke the `read-context` task with `context_type: "document_artefact"` and `query: "Retrospective"` to find previous retrospective documents</action>
<action>If retrospective documents exist, load the most recent 1-3 to extract velocity data (story points completed per cycle)</action>
<action>Calculate rolling average velocity from available data</action>

<action>If no retrospectives exist yet, check completed issues for estimates:</action>
<action>Invoke the `read-context` task with `context_type: "work_items"`, `team: "{team_name}"`, `states: ["Done"]`, `limit: 20` to count completed story points</action>

<action>Store the velocity data for capacity planning in step 4</action>

### 1.7 Build Inventory

<action>Build a complete inventory of all projects, issues, and their current states from the platform</action>

### Success Criteria
- Active cycle identified (or confirmed none exists)
- Issues in active cycle loaded with status counts
- Backlog issues loaded
- Project overview loaded
- Velocity history calculated (if data available)

</step>

<step n="2" goal="Determine cycle action">

**Progress: Step 2 of 5** -- Next: Select Stories

<action>Present the current state to the user:</action>

**Current Cycle Status:**
- Active Cycle: {cycle_name} ({start_date} to {end_date}) (or "None")
- Issues in Cycle: {count} ({done_count} done, {in_progress_count} in progress)
- Backlog Issues: {backlog_count} (not in any cycle)

**Options:**
1. **[C] Continue** -- Add backlog issues to the current cycle
2. **[N] New Cycle** -- Select stories for the next available cycle
3. **[R] Review Only** -- Just show the status, don't modify anything

<action>
  {if autonomy_level == "interactive"}
    Wait for user selection.
  {else if autonomy_level == "balanced"}
    If an active cycle exists, auto-select [C] (Continue). Otherwise auto-select [N] (New Cycle).
    Report selection to user: "Auto-selected: {option}. Press Enter to confirm or type C/N/R to change."
  {else}
    Auto-select [C] if active cycle exists, otherwise [N]. Report selection and proceed.
  {end_if}
</action>
</step>

<step n="3" goal="Identify target cycle (if selected N)">

**Progress: Step 3 of 5** -- Next: Assign Issues

<action>If user selected [N] or no active cycle exists:</action>

<action>Present available upcoming cycles from the cycle listing results:</action>

| # | Cycle | Start | End | Status |
|---|---|---|---|---|
| 1 | {cycle_name} | {start_date} | {end_date} | Upcoming |

<action>
  {if autonomy_level == "interactive"}
    Ask user to select a cycle, or ask them to create one in the platform UI.
  {else}
    Auto-select the next upcoming cycle. Report to user.
  {end_if}
</action>

<action>If no upcoming cycles exist, inform the user:</action>

```
No upcoming cycles found. Please create a cycle in the platform UI:
1. Go to your team's Cycles view
2. Click "New Cycle"
3. Set the name, start date, and end date
4. Come back and re-run Sprint Planning

Alternatively, I can assign stories directly without a cycle.
```

<action>If no cycle is available and user wants to proceed without one, continue to step 4 with cycle assignment skipped</action>
</step>

<step n="3.5" goal="Backlog refinement — ensure issues are estimated">

**Progress: Step 3.5 of 5** -- Next: Select and Assign

### Refine Unestimated Issues

<action>Check the backlog issues loaded in step 1.3 for missing estimates</action>
<action>If any backlog issues lack estimates, invoke the `refine-backlog` task from `{project-root}/_aria/core/tasks/refine-backlog.md` with `team: "{team_name}"`</action>
<action>If all backlog issues already have estimates, skip this step: "All backlog issues are estimated — ready for sprint selection."</action>

### Success Criteria
- All candidate issues have story point estimates
- Estimates enable capacity planning in step 4

</step>

<step n="4" goal="Select and assign issues to cycle">

**Progress: Step 4 of 5** -- Next: Status Summary

### 4.1 Present Candidates

<action>Present the backlog issues to the user as a numbered list (now with estimates):</action>

| # | ID | Issue | Project | Status |
|---|---|---|---|---|
| 1 | {identifier} | Story 1.1: User Authentication | Project 1 | Backlog |
| 2 | {identifier} | Story 1.2: Account Management | Project 1 | Backlog |
| ... | ... | ... | ... | ... |

<action>
  {if autonomy_level == "interactive"}
    Ask user to select issues by number (comma-separated) or "all" for all backlog issues.
  {else if autonomy_level == "balanced"}
    Auto-select all backlog issues from the first unfinished Project. Report selection.
    "Auto-selected {count} issues from Project {project_name}. Press Enter to confirm or type specific numbers."
  {else}
    Auto-select all backlog issues from the first unfinished Project. Report and proceed.
  {end_if}
</action>

### 4.2 Sprint Capacity Check

<action>Sum the `estimate` (story points) for all selected issues</action>
<action>Compare against the velocity data from step 1.6:</action>

```
Sprint Capacity Summary:
- Selected issues: {selected_count}
- Total story points: {total_points}
- Average velocity (last 3 sprints): {avg_velocity} points
- Capacity utilization: {total_points / avg_velocity * 100}%
```

<action>
  {if total_points > avg_velocity * 1.2}
    Warn: "Selected {total_points} points exceeds your average velocity of {avg_velocity} by more than 20%. Consider removing {excess_points} points of work."
    {if autonomy_level != "yolo"} Wait for user to confirm or adjust selection. {end_if}
  {else if total_points < avg_velocity * 0.5}
    Note: "Selected {total_points} points is well below your average velocity of {avg_velocity}. Consider adding more stories."
  {else}
    "Sprint capacity looks good: {total_points} points against {avg_velocity} average velocity."
  {end_if}
</action>

<action>If no velocity data is available, skip the capacity check and note: "No velocity history yet — capacity planning will improve after the first retrospective."</action>

### 4.3 Assign Issues to Cycle

<action>For each selected issue, invoke the platform's work-item update to assign it to the cycle:</action>

```
id: "{issue_id}"
cycle: "{target_cycle_name}"
```

<action>For each selected issue, invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` with a sprint planning note:</action>

```
issueId: "{issue_id}"
body: "**Cycle Planning:** Selected for {cycle_name} by SM agent."
```

<action>For each issue added, if it's the first issue from its Project being worked on:</action>
<action>Check the Project's status -- if it's not yet started, the first issue assignment signals the Project is active. Note this in the planning summary.</action>
</step>

<step n="5" goal="Generate status summary">

**Progress: Step 5 of 5** -- Final Step

<action>Build the cycle status summary:</action>

**Cycle Planning Complete**

- **Cycle:** {cycle_name}
- **Issues Selected:** {selected_count}
- **Total in Cycle:** {total_count}
- **Projects Active:** {active_project_count}

**Platform Board:** View in the platform at your team's Cycles view

**Next Steps:**
1. Use SM's **Create Story** ([CS]) to prepare stories with dev context
2. Issues will transition: Backlog -> Todo -> In Progress -> In Review -> Done
3. Re-run Sprint Planning to refresh status from the platform

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>
</step>

</workflow>

---

## Status Flow Reference

```
Project: Not Started -> Started -> Completed
         (Managed by the platform based on issue progress)

Issue:   Backlog -> Todo -> In Progress -> In Review -> Done
         (Set via the platform's work-item update with state: "Status Name")
```

All state changes use the platform's work-item update with `state: "Status Name"` -- no transition IDs needed in the platform.

## sprint Notes

| Operation | Platform Task |
|---|---|
| List cycles | Platform's cycle listing with team filter |
| Create cycle | Not available via MCP -- create in the platform UI |
| Assign issue to cycle | Platform's work-item update with `cycle: "Cycle Name"` |
| List issues in cycle | `read-context` task with `context_type: "work_items"` and `cycles` filter |
