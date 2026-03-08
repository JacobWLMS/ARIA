# Refine Backlog — Reusable Task

<critical>This is a reusable task. It is invoked by sprint-planning before story selection to ensure backlog issues are estimated and prioritized.</critical>

## Purpose

Reviews unestimated and unprioritized backlog issues. For each, prompts for a quick estimate and priority, then updates the issue in Linear. This ensures sprint planning has accurate data for capacity planning.

---

## Required Inputs

| Input | Description |
|---|---|
| `team` | Linear team name |
| `limit` | Maximum issues to refine (default: 10) |

---

## Procedure

### Step 1 — Find unrefined backlog issues

<action>Call `list_issues` with `team: "{team}"`, `states: ["Backlog"]`, `limit: {limit}` to get backlog issues</action>
<action>Filter to issues missing estimates (estimate is null or 0)</action>

### Step 2 — Present for refinement

<action>Present the unrefined issues:</action>

```
Backlog Refinement — {count} issues need estimates:

| # | ID | Story | Project | Current Estimate |
|---|---|---|---|---|
| 1 | {identifier} | {title} | {project_name} | Not estimated |
| 2 | {identifier} | {title} | {project_name} | Not estimated |
```

<action>
  {if autonomy_level == "interactive"}
    For each issue, ask: "Estimate for {identifier} ({title})? [1/2/3/5/8/13/skip]"
  {else}
    Auto-estimate based on issue description complexity:
    - Short description, single AC → 2 points
    - Moderate description, 2-3 ACs → 5 points
    - Long description, 4+ ACs, dependencies noted → 8 points
    - Very complex, architectural implications → 13 points
    Report all estimates and ask for confirmation.
  {end_if}
</action>

### Step 3 — Apply estimates

<action>For each issue with a new estimate, call `save_issue` with:</action>

```
id: "{issue_id}"
estimate: {story_points}
```

### Step 4 — Report

```
Backlog Refinement Complete:
- Issues refined: {refined_count}
- Total backlog points: {total_points}
- Average estimate: {avg_points} points
- Issues still unestimated: {remaining_count}
```
