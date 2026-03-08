# Code Review — Platform Integration

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Runs the code review checklist and posts findings as tracked sub-items on the story. Each finding with severity >= Major becomes an individually trackable issue. A summary comment is posted on the parent issue. If the review passes, sets the issue state to Done. If it fails, findings remain as open sub-issues for the dev to address.

---

<workflow>

<step n="1" goal="Identify the story under review">

**Progress: Step 1 of 6** -- Next: Lock and Review

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Find Issues in Review

<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `states: ["In Review"]`, `limit: 5`</action>

<action>If user specified an issue identifier, use that instead</action>

### 1.2 Select Issue

<action>
  {if autonomy_level == "interactive"}
    Present candidates and wait for user selection.
  {else}
    Auto-select the most recently updated issue in In Review state. Report selection to user.
    {if autonomy_level == "balanced"}
      "Selected {identifier}: {title}. Press Enter to confirm or type a different identifier."
    {end_if}
  {end_if}
</action>

### 1.3 Load Issue Details

<action>Call `get_issue` with `id: "{selected_issue_id}"` to load full issue details including description, comments, parent project, labels, and attachments</action>
<action>Call `list_comments` with `issueId: "{selected_issue_id}"` to load the dev agent record and review history</action>

### 1.3.1 Load Test Report Attachments

<action>Check the issue's `attachments` array from `get_issue`. If any attachments exist with titles containing "test report", "test results", or "coverage":</action>
<action>Call `get_attachment` with `id: "{attachment_id}"` for each matching attachment to load the test report content</action>
<action>Include the test report data in the review context -- this provides QA evidence from the dev agent's implementation pass</action>
<action>If no test report attachments exist, continue without them -- they are optional context</action>

### 1.4 Load PR Diff (if git enabled)

<action>If `git_enabled` is `true` in module.yaml: invoke `git-operations` task from `{project-root}/_aria/shared/tasks/git-operations.md` with operation `get_pr_diff`, passing `issue_key: "{issue_identifier}"`. This retrieves the PR diff (or branch diff against default_branch) for additional review surface. Include the diff output alongside local code review. If the operation fails, continue with local-only review.</action>

### Success Criteria
- Issue in In Review state found and selected
- Full issue details and comments loaded
- PR diff loaded (if git enabled)

</step>

<step n="2" goal="Lock the issue and run code review">

**Progress: Step 2 of 6** -- Next: Create Finding Sub-issues

### 2.1 Lock

<action>Invoke `lock-work-item` task from `{project-root}/_aria/core/tasks/lock-work-item.md` with `issue_id: "{selected_issue_id}"`, `action: "lock"`, `agent_name: "code-review"`</action>

### 2.2 Run Code Review Checklist

<action>Follow the code review checklist at `{checklist}`</action>

Review the implementation across all quality facets:
- Code correctness and completeness against acceptance criteria
- Test coverage and quality
- Architecture alignment
- Security considerations
- Performance implications
- Code style and maintainability

### 2.3 Record Findings

<action>For each finding, record:</action>
- **Severity:** Critical | Major | Minor | Info
- **Title:** Short description of the issue
- **Location:** `{file_path}:{line_number}`
- **Description:** What the issue is and why it matters
- **Recommendation:** How to fix it

### 2.4 Determine Verdict

<action>Determine the review verdict:</action>
- **PASS** -- No Critical or Major findings, 0-2 Minor findings
- **PASS_WITH_NOTES** -- No Critical findings, 0-1 Major findings that are cosmetic/non-blocking
- **FAIL** -- Any Critical findings, or 2+ Major findings

### Success Criteria
- Issue locked
- All quality facets reviewed
- Findings recorded with severity
- Verdict determined

</step>

<step n="3" goal="Create sub-items for findings">

**Progress: Step 3 of 6** -- Next: Post Summary

<action>For each finding with severity Critical or Major, invoke the `create-work-item` task from `{project-root}/_aria/core/tasks/create-work-item.md`:</action>

```
team: "{team_name}"
title: "[{severity}] {finding_title}"
description: |
  ## Code Review Finding

  **Review of:** {selected_issue_identifier} -- {issue_title}
  **Reviewer:** ARIA Code Review Agent
  **Date:** {date}

  ### Details

  - **Severity:** {severity}
  - **Location:** `{file_path}:{line_number}`

  ### Description

  {finding_description}

  ### Recommendation

  {recommendation}
parentId: "{selected_issue_id}"
labels: ["aria-review-finding", "severity-{severity_lowercase}"]
```

<action>Record each created sub-issue identifier for the summary</action>

<action>For Minor and Info findings, collect them for the summary comment only -- do not create sub-issues to avoid clutter</action>

### Success Criteria
- Sub-issues created for Critical and Major findings
- Sub-issue identifiers recorded
- Minor/Info findings collected for comment

</step>

<step n="4" goal="Post summary comment on the issue">

**Progress: Step 4 of 6** -- Next: Transition

<action>Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` with:</action>

```
issueId: "{selected_issue_id}"
body: |
  ## Code Review Results

  **Reviewer:** ARIA Code Review Agent
  **Date:** {date}
  **Verdict:** {PASS | FAIL | PASS_WITH_NOTES}

  ### Summary

  {review_summary}

  ### Tracked Findings (Sub-issues)

  | ID | Severity | Title |
  |---|---|---|
  {for_each_sub_issue_created}
  | {identifier} | {severity} | {finding_title} |
  {end_for_each}

  ### Minor/Info Findings (Untracked)

  {for_each_minor_finding}
  - **{severity}: {finding_title}** -- {file_path}:{line_number}
    {finding_description}. Fix: {recommendation}
  {end_for_each}

  ### Acceptance Criteria Verification

  {for_each_ac}
  - [x] AC #{ac_number}: {ac_description} -- {verification_status}
  {end_for_each}

  ### Test Coverage

  - Unit Tests: {unit_test_count}
  - Integration Tests: {integration_test_count}
  - Coverage: {coverage_percentage}
```

### Success Criteria
- Review summary comment posted with full details

</step>

<step n="5" goal="Transition based on review outcome">

**Progress: Step 5 of 6** -- Next: Unlock and Handoff

**If review PASSES (PASS or PASS_WITH_NOTES):**

<action>If any review-finding sub-issues were created (PASS_WITH_NOTES case), set them to Done:</action>

```
For each sub_issue created in Step 3:
  Invoke `set-work-item-state` task with:
    issue_id: "{sub_issue_id}"
    target_state: "Done"
    comment: "Non-blocking finding -- story passed review."
```

<action>Invoke `set-work-item-state` task from `{project-root}/_aria/core/tasks/set-work-item-state.md`:</action>

```
issue_id: "{selected_issue_id}"
target_state: "Done"
comment: "Code review passed. Story complete."
```

<action>Invoke the platform's work-item update to add review labels:</action>

```
id: "{selected_issue_id}"
labels: ["{existing_labels}", "aria-reviewed", "aria-review-passed"]
```

<action>If `git_enabled` is `true` and `git_pr_auto_approve` is `true` in module.yaml: invoke `git-operations` task with operation `approve_pr`, passing `issue_key: "{issue_identifier}"`. This submits an approval review on the PR. If the operation fails, log the error and continue.</action>

<action>Check if all issues in the parent Project are now Done:</action>
<action>Invoke the `read-context` task with `context_type: "work_items"`, `project: "{parent_project_name}"`, `states: ["Backlog", "Todo", "In Progress", "In Review"]`</action>
<action>If no results (all done), note this in the handoff summary so SM can run a Retrospective. Do NOT complete the Project here -- Project lifecycle is managed by the Retrospective workflow.</action>

**If review FAILS:**

<action>Invoke the platform's work-item update to add review labels:</action>

```
id: "{selected_issue_id}"
labels: ["{existing_labels}", "aria-reviewed", "aria-review-failed"]
```

<action>If `git_enabled` is `true` in module.yaml: invoke `git-operations` task with operation `request_changes`, passing `issue_key: "{issue_identifier}"` and `findings: "{review_findings_summary}"`. This submits a changes-requested review on the PR. If the operation fails, log the error and continue.</action>

<action>Do NOT change state -- keep in In Review status for the dev agent to address findings</action>
<action>The open sub-issues serve as the dev's punch list -- each finding can be individually tracked and resolved</action>

### Success Criteria
- PASS: Issue set to Done, labels updated, PR approved (if git)
- FAIL: Labels updated, issue remains in In Review, PR changes requested (if git)

</step>

<step n="6" goal="Unlock, hand off, and report">

**Progress: Step 6 of 6** -- Final Step

### 6.1 Unlock

<action>Invoke `lock-work-item` task from `{project-root}/_aria/core/tasks/lock-work-item.md` with `issue_id: "{selected_issue_id}"`, `action: "unlock"`, `agent_name: "code-review"`</action>

### 6.2 Handoff

{if_passed}
<action>Invoke `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "review_complete"
summary: "Code review passed for {issue_identifier}. Issue set to Done. SM should check if next story is ready or if retrospective is needed."
issue_ids: ["{selected_issue_id}"]
```
{end_if}

{if_failed}
<action>Invoke `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "Dev"
handoff_type: "review_failed"
summary: "Code review failed for {issue_identifier}. {sub_issue_count} tracked findings created ({critical_count} critical, {major_count} major). {minor_count} minor findings in review comment. Dev should address sub-issues and re-submit."
issue_ids: ["{selected_issue_id}", "{sub_issue_ids}"]
```
{end_if}

### 6.3 Report to User

**Code Review: {verdict}**

- **Issue:** {selected_issue_identifier} -- {issue_title}
- **Tracked Findings (Sub-issues):** {sub_issue_count} ({critical_count} critical, {major_count} major)
- **Minor Findings (Comment):** {minor_count}
- **AC Verified:** {verified_count}/{total_ac_count}

{if_passed}
Issue set to **Done**.
{if_sub_issues_exist}
Non-blocking findings created as sub-issues (auto-resolved): {sub_issue_ids_list}
{end_if}
{end_if}

{if_failed}
Issue remains in **In Review** with `aria-review-failed` label.

**Dev Punch List (open sub-issues):**
{for_each_open_sub_issue}
- {identifier}: [{severity}] {finding_title}
{end_for_each}

Dev agent will be dispatched to address findings. Each sub-issue should be set to Done as fixed.
{end_if}

### 6.4 Help

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>

### Success Criteria
- Issue unlocked
- Handoff posted (to SM if passed, to Dev if failed)
- User informed of review outcome

### Failure Modes
- Not unlocking the issue (blocks future work)
- Not posting handoff (next agent doesn't know to pick up)

</step>

</workflow>
