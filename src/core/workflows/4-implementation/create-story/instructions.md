# Create Story — Platform Output

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Prepares a story with full development context. The analysis steps follow the create-story checklist. The output step writes to the platform (updating the issue description and adding dev notes as a comment) and sets the issue state to "Todo" (ready for dev).

---

<workflow>

<step n="1" goal="Identify the story to prepare">

**Progress: Step 1 of 7** -- Next: Gather Context

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Find Unprepared Stories

<action>Invoke `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "sprint_status"` to find issues in Backlog status</action>
<action>Invoke the `read-context` task with `context_type: "work_items"`, `team: "{team_name}"`, `states: ["Backlog"]`, `limit: 5` to find unprepared backlog issues</action>

### 1.2 Present Candidates

<action>Present candidates to the user:</action>

| # | ID | Issue | Project |
|---|---|---|---|
| 1 | {identifier} | Story 1.1: User Authentication | Project 1 |
| 2 | {identifier} | Story 1.2: Account Management | Project 1 |

<action>
  {if autonomy_level == "interactive"}
    Wait for user selection.
  {else}
    Auto-select the first unprepared issue. Report selection to user.
    {if autonomy_level == "balanced"}
      "Selected {identifier}: {title}. Press Enter to confirm or type a different identifier."
    {end_if}
  {end_if}
</action>

### 1.3 Load Full Issue Details

<action>Call `get_issue` with `id: "{selected_issue_id}"` to load full issue details including description and labels</action>

### Success Criteria
- Issue identified and selected
- Full issue details loaded

</step>

<step n="2" goal="Gather context from the platform">

**Progress: Step 2 of 7** -- Next: Analyse and Prepare

### 2.1 Story Detail Context

<action>Invoke `read-context` task with `context_type: "story_detail"` and `scope_key: "{selected_issue_id}"` to fetch:</action>
- Full issue description and acceptance criteria
- Parent Project details
- Architecture document from documents (if exists)

### 2.2 Previous Story Learnings

<action>Invoke `read-context` task with `context_type: "previous_story_learnings"` to fetch:</action>
- Completion notes from the last 3 done issues (for incorporating learnings)

### 2.3 Project Context

<action>Read the project context file if it exists: `{project_context}`</action>

### Success Criteria
- Story description and ACs loaded
- Parent project context loaded
- Architecture document loaded (if exists)
- Previous learnings retrieved

</step>

<step n="3" goal="Analyse and prepare story content">

**Progress: Step 3 of 7** -- Next: Write to the platform

<action>Follow the create-story checklist at `{checklist}`:</action>

1. Validate the story has clear acceptance criteria
2. Identify relevant architecture patterns and constraints
3. Map tasks to the project's source tree
4. Determine testing strategy and standards
5. Check for dependencies on other issues — if dependencies exist, set `blockedBy` relationships via the platform's work-item update in step 4 (the platform supports `blocks`/`blockedBy` natively)
6. Identify files and modules that will be touched

<action>Build the enriched story content using the story template at `{template}` as the structure guide</action>

The enriched content includes:
- **User Story** (from issue description)
- **Acceptance Criteria** (from issue, validated for completeness)
- **Tasks / Sub-issues** (decomposed from AC, ordered for implementation)
- **Dev Notes** (architecture patterns, source tree components, testing standards)
- **Project Structure Notes** (alignment with project conventions)
- **References** (source paths, relevant documentation sections)

### Success Criteria
- All checklist items evaluated
- Enriched content built with all required sections
- Dependencies identified and documented

</step>

<step n="3.5" goal="Estimate story points">

**Progress: Step 3.5 of 7** -- Next: Write to the platform

### Story Point Estimation

<action>Estimate story points using the Fibonacci scale based on the analysis from step 3:</action>

| Points | Complexity | Guideline |
|---|---|---|
| 1 | Trivial | Known pattern, config change, < 1 hour |
| 2 | Small | Simple feature, single file, 1-2 hours |
| 3 | Medium | Known approach, 2-3 files, half day |
| 5 | Moderate | Some investigation needed, 3-5 files, 1 day |
| 8 | Complex | Design decisions required, cross-cutting, 2-3 days |
| 13 | Very Complex | Major unknowns, consider splitting into smaller stories |

**Estimation factors:**
- Number of files/modules to touch (from step 3 analysis)
- Testing complexity (new test infrastructure vs. existing patterns)
- Dependency risk (external APIs, shared code, blocking issues)
- Architectural novelty (established patterns vs. new ground)

<action>If estimate is 13+, recommend splitting the story and explain which sub-stories would result</action>

<action>
  {if autonomy_level == "interactive"}
    Present the estimate with reasoning and wait for user confirmation or adjustment.
  {else}
    Set the estimate and report: "Estimated at {points} points — {brief_reasoning}."
  {end_if}
</action>

### Success Criteria
- Story points estimated using Fibonacci scale
- Estimate based on concrete analysis from step 3
- Stories over 13 points flagged for splitting

</step>

<step n="4" goal="Write enriched story to the platform">

**Progress: Step 4 of 7** -- Next: Create Sub-issues

<action>Invoke the platform's work-item update to update the issue description with the enriched content and estimate:</action>

```
id: "{selected_issue_id}"
description: "{enriched_story_description_in_markdown}"
labels: ["{existing_labels}", "{agent_label_prefix}sm"]
estimate: {story_points_from_step_3_5}
```

<action>Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` to post the dev notes separately (keeps them visible in the comment stream):</action>

```
issueId: "{selected_issue_id}"
body: |
  ## Dev Notes -- Prepared by SM Agent

  ### Architecture Context
  {architecture_patterns_and_constraints}

  ### Source Tree Components
  {files_and_modules_to_touch}

  ### Testing Standards
  {testing_approach}

  ### References
  {cited_sources_with_paths}
```

### 4.3 Set Dependency Relations

<action>If dependencies were identified in step 3, create `blockedBy` relationships:</action>

```
id: "{selected_issue_id}"
blockedBy: ["{blocking_issue_id_1}", "{blocking_issue_id_2}"]
```

<action>Look up blocking issue IDs in `{key_map_file}` under `issues`</action>
<action>This makes dependencies visible in the platform's issue view and prevents the orchestrator from dispatching blocked stories</action>

### Success Criteria
- Issue description updated with enriched content
- Story points set via estimate field
- Dev notes posted as comment
- Dependencies linked via blockedBy (if any)

</step>

<step n="5" goal="Create sub-issues in the platform (if tasks were decomposed)">

**Progress: Step 5 of 7** -- Next: Set State

<action>For each Task/Sub-issue identified in step 3:</action>
<action>Invoke the `create-work-item` task from `{project-root}/_aria/core/tasks/create-work-item.md` with:</action>

```
team: "{team_name}"
title: "{task_description} (AC: #{ac_number})"
description: "{task_details}"
parentId: "{selected_issue_id}"
labels: ["{agent_label_prefix}sm", "aria-task"]
```

### Success Criteria
- Sub-issues created for each decomposed task
- Each sub-issue linked to parent via parentId

</step>

<step n="6" goal="Set issue state to Todo (ready for dev)">

**Progress: Step 6 of 7** -- Next: Hand Off

<action>Invoke `set-work-item-state` task from `{project-root}/_aria/core/tasks/set-work-item-state.md` with:</action>

```
issue_id: "{selected_issue_id}"
target_state: "Todo"
comment: "Story prepared with full dev context by SM agent"
```

### Success Criteria
- Issue state set to Todo

</step>

<step n="7" goal="Hand off and report">

**Progress: Step 7 of 7** -- Final Step

### 7.1 Post Handoff

<action>Invoke `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "Dev"
handoff_type: "story_prepared"
summary: "Issue {selected_issue_identifier} prepared with full dev context and sub-issues. Ready for implementation."
issue_ids: ["{selected_issue_id}"]
```

### 7.2 Report to User

**Story Prepared: {issue_title}**

- **work item:** {selected_issue_identifier}
- **Status:** Todo
- **Sub-issues Created:** {task_count}
- **Dev Notes:** Posted as comment on {selected_issue_identifier}

**Next Steps:**
1. Dev agent can pick up this story with [DS] Dev Story
2. Or prepare the next story with [CS] Create Story

### 7.3 Help

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>

### Success Criteria
- Handoff posted
- User informed of completion
- Help suggestions presented

</step>

</workflow>
