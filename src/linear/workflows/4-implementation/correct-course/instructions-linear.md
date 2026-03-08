# Correct Course — Linear Integration

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## Overview

Facilitates mid-cycle course corrections when scope changes, technical blockers, requirement changes, or timeline shifts occur. Assesses impact, proposes Linear updates, and executes approved changes.

---

<workflow>

<step n="1" goal="Assess current state -- cycle progress, blocked issues, velocity">

**Progress: Step 1 of 6** -- Next: Identify Issues

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Load Cycle Status

<action>Invoke the `read-linear-context` task from `{project-root}/_aria/linear/tasks/read-linear-context.md` with `context_type: "sprint_status"` to load current cycle state</action>

### 1.2 Present Current State

<action>Present the current cycle status to the user:</action>

| Metric | Value |
|---|---|
| Cycle | {cycle_name} |
| Issues Total | {total_issues} |
| Done | {done_count} |
| In Progress | {in_progress_count} |
| Todo | {todo_count} |
| Blocked | {blocked_count} |
| Velocity (avg) | {avg_velocity} |

<action>List any blocked issues with their blockers</action>

### Success Criteria
- Current cycle state loaded
- Status presented to user
- Blocked items identified

</step>

<step n="2" goal="Identify issues -- understand what triggered the course correction">

**Progress: Step 2 of 6** -- Next: Impact Analysis

<action>Ask the user what changed or what problem triggered the course correction</action>
<action>Categorize the issue into one or more of:</action>

1. **Scope change** -- new requirements or features added/removed
2. **Technical blocker** -- implementation obstacle, dependency failure, or architectural issue
3. **Requirement change** -- existing requirements modified or clarified
4. **Timeline change** -- deadline moved, resource availability changed

<action>Gather details for each identified issue</action>
<action>Confirm the categorization with the user</action>

### Success Criteria
- Trigger identified and categorized
- User confirmed categorization

</step>

<step n="3" goal="Impact analysis -- determine which projects and issues are affected">

**Progress: Step 3 of 6** -- Next: Propose Changes

### 3.1 Load Affected Items

<action>Based on the identified issues, determine which Projects and Issues are affected</action>
<action>For scope/requirement changes: call `list_issues` with `team: "{linear_team_name}"`, `states: ["Backlog", "Todo", "In Progress", "In Review"]` to load active items</action>
<action>For technical blockers: load the specific blocked issues and their dependencies</action>

### 3.2 Evaluate Impact

<action>Use the checklist at `{checklist}` to evaluate each proposed change:</action>

1. Does this change affect acceptance criteria?
2. Does this change require new issues?
3. Does this change invalidate completed work?
4. Does this change affect other projects or dependencies?
5. What is the effort impact?
6. What is the risk if not addressed?

### 3.3 Present Analysis

<action>Present the impact analysis to the user</action>

### Success Criteria
- Affected items identified
- Each change evaluated against checklist
- Impact analysis presented

</step>

<step n="4" goal="Propose changes -- define specific Linear updates for each affected item">

**Progress: Step 4 of 6** -- Next: Execute Changes

<action>For each affected item, propose one or more of the following actions:</action>

1. **Update issue description/ACs** -- modify the existing issue via `save_issue` to reflect changed requirements
2. **Create new remediation issues** -- use `save_issue` to create new issues under the appropriate Project
3. **Re-prioritize issues** -- adjust issue priority within the cycle or backlog
4. **Adjust cycle scope** -- move issues in or out of the current cycle via `save_issue` with `cycle`
5. **Document blockers** -- note blocking relationships in issue descriptions (Linear MCP does not support formal issue link types, so document dependencies explicitly in descriptions and comments)

<action>Present the full change proposal to the user:</action>

```
## Cycle Change Proposal

### Issues to Update
{list of issues with proposed description/AC changes}

### New Issues to Create
{list of new issues with descriptions and target projects}

### Cycle Scope Changes
{issues to add/remove from cycle}

### Priority Changes
{issues to re-prioritize}
```

<action>Wait for user approval before proceeding</action>

### Success Criteria
- Change proposal clearly defined
- User approved the proposal

</step>

<step n="5" goal="Execute changes -- apply approved Linear updates">

**Progress: Step 5 of 6** -- Next: Confirm and Notify

<action>After user approval, execute each approved change:</action>

### 5.1 Update Existing Issues

<action>For issue updates, call `save_issue` for each issue with modified descriptions or acceptance criteria</action>
<action>Post a "Course Correction" comment on each affected issue via `save_comment`:</action>

```
issueId: "{issue_id}"
body: |
  ## Course Correction Applied ({date})

  **Trigger:** {change_category}
  **Change:** {description_of_change}

  **Previous State:** {previous_description_summary}
  **Updated State:** {new_description_summary}
```

### 5.2 Create New Issues

<action>For new issues, call `save_issue` for each new issue:</action>

```
team: "{linear_team_name}"
title: "{issue_title}"
description: "{issue_description}"
project: "{target_project_name}"
```

### 5.3 Adjust Cycle Scope

<action>For cycle scope changes, call `save_issue` to assign or unassign issues from cycles:</action>

```
id: "{issue_id}"
cycle: "{target_cycle_name}"    # or null to remove from cycle
```

### 5.4 Track Changes

<action>Track all changes made for the confirmation step</action>

### Success Criteria
- All approved changes executed
- Comments posted on affected issues
- Changes tracked for summary

</step>

<step n="6" goal="Confirm and notify -- summarize changes and post handoff">

**Progress: Step 6 of 6** -- Final Step

### 6.1 Compile Summary

<action>Compile a summary of all changes executed:</action>

**Course Correction Summary**

- **Trigger:** {change_category}
- **Issues Updated:** {updated_count}
- **Issues Created:** {created_count}
- **Cycle Scope Changes:** {scope_change_count}
- **Priority Changes:** {priority_change_count}

| Action | Issue | Detail |
|---|---|---|
| Updated | {identifier} | {change_summary} |
| Created | {new_identifier} | {new_issue_summary} |
| Moved | {identifier} | {in/out of cycle} |

### 6.2 Post Handoff

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "course_correction_complete"
summary: "Course correction applied. {updated_count} issues updated, {created_count} new issues created. Trigger: {change_category}."
```

### 6.3 Report to User

**Course Correction Complete**

All approved changes have been applied in Linear. The cycle backlog has been updated to reflect the new priorities and scope.

**Next Steps:**
1. Review updated issues in Linear
2. Resume development with [Dev Story] on the highest-priority item
3. Monitor progress with [Sprint Status]

### 6.4 Help

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md` to present context-aware next-step recommendations to the user</action>

### Success Criteria
- Summary compiled and presented
- Handoff posted
- User informed of next steps

</step>

</workflow>
