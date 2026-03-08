# Sprint Status — sprint Dashboard

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Provides a read-only cycle and project progress dashboard by polling the platform for current cycle state, issue statuses, and velocity metrics. Optionally publishes the status as a document. No state changes or modifications are made.

---

<workflow>

<step n="1" goal="Poll platform state -- load cycle, issues, and project data">

**Progress: Step 1 of 3** -- Next: Build Dashboard

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Load Cycles

<action>Invoke the platform's cycle listing for `{team_name}` to identify the current active cycle</action>

### 1.2 Load Cycle Issues

<action>If an active cycle exists, invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `cycles: ["{active_cycle_name}"]` to load all issues in the cycle</action>
<action>If no active cycle is found, inform the user and offer to show backlog status instead</action>

### 1.3 Load Projects

<action>Invoke the platform's project listing for `{team_name}` to load all Projects</action>
<action>For each Project, invoke the `read-context` task with `context_type: "work_items"`, `project: "{project_name}"` to get status counts per Project</action>

### Success Criteria
- Active cycle identified (or confirmed none exists)
- All cycle issues loaded
- All project issue counts loaded

</step>

<step n="2" goal="Build status dashboard -- cycle progress, project progress, blockers, velocity">

**Progress: Step 2 of 3** -- Next: Present and Publish

<action>Compile the cycle status dashboard:</action>

### Cycle Progress: {cycle_name}

| Status | Count | % |
|---|---|---|
| Done | {done_count} | {done_pct}% |
| In Progress | {in_progress_count} | {in_progress_pct}% |
| In Review | {review_count} | {review_pct}% |
| Todo | {todo_count} | {todo_pct}% |
| **Total** | **{total_count}** | **100%** |

### Project Progress

| Project | Total Issues | Done | In Progress | Todo | % Complete |
|---|---|---|---|---|---|
| {project_name} | {total} | {done} | {in_progress} | {todo} | {pct}% |

### Blocked Items

| Issue | Summary | Blocker |
|---|---|---|
| {identifier} | {issue_title} | {blocker_description} |

### Velocity Metrics

- **Current Cycle:** {issues_completed_so_far} issues completed of {total_issues}
- **Cycle Days Remaining:** {days_remaining}
- **Projected Completion:** {projected_pct}% by cycle end

<action>Identify any risks: issues at risk of not completing, projects falling behind</action>

### Success Criteria
- Dashboard compiled with all sections
- Risks identified

</step>

<step n="3" goal="Present status and optionally publish to document">

**Progress: Step 3 of 3** -- Final Step

### 3.1 Present Dashboard

<action>Present the formatted status dashboard to the user</action>

### 3.2 Offer to Publish

<action>Ask the user if they would like to publish this status as a document</action>

<action>If the user wants to publish, invoke the `write-document` task from `{project-root}/_aria/core/tasks/write-document.md` with:</action>

```
title: "{project_name} -- Cycle Status: {cycle_name} ({date})"
content: "{compiled_status_dashboard}"
key_map_entry: "documents.cycle_status_{cycle_id}"
```

### 3.3 Alternatively Post to Project Comments

<action>Alternatively, if the user prefers, post a summary comment on each active Project's most recent issue:</action>
<action>For each Project with issues in the active cycle, invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` on a representative issue:</action>

```
issueId: "{representative_issue_id}"
body: |
  ## Cycle Status Update ({date})

  **Cycle:** {cycle_name}
  **Project Progress:** {done_count}/{total_count} issues done ({pct}%)

  ### Issues in Cycle
  {list_of_issues_with_status}
```

### 3.4 Report to User

**Cycle Status Complete**

- **Cycle:** {cycle_name}
- **Overall Progress:** {done_count}/{total_count} issues ({overall_pct}%)
- **Blocked Items:** {blocked_count}
- **Days Remaining:** {days_remaining}
{if_published}
- **document:** Published
{end_if}

This is a read-only status check. To make changes, use [Correct Course] or [Sprint Planning].

### Success Criteria
- Dashboard presented to user
- Published as document (if requested)
- User informed of status

</step>

</workflow>
