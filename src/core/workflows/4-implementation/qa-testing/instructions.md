# QA Testing — Platform-Tracked Test Generation

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Generates tests for stories that have passed code review. Finds reviewed issues in the platform that lack test coverage, generates API and E2E tests based on acceptance criteria, runs them to verify they pass, and posts a structured test summary as a comment.

---

<workflow>

<step n="1" goal="Find stories needing test coverage">

**Progress: Step 1 of 7** -- Next: Load Details

### Role & Communication

<action>Communicate in {communication_language} with {user_name}</action>

### 1.1 Find Reviewed but Untested Issues

<action>Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `labels: ["aria-reviewed", "aria-review-passed"]`, `states: ["Done"]`, `limit: 10`</action>
<action>Filter results to exclude issues that already have the `aria-tested` label</action>

<action>If user specified an issue identifier, use that instead</action>
<action>If no issues found, report: "No reviewed issues need test coverage. All reviewed issues already have the aria-tested label."</action>

### 1.2 Present Candidates

<action>Present candidates to the user:</action>

| # | ID | Issue | Status |
|---|---|---|---|
| 1 | {identifier} | Story 1.1: User Authentication | Done (reviewed, not tested) |
| 2 | {identifier} | Story 1.2: Account Management | Done (reviewed, not tested) |

<action>
  {if autonomy_level == "interactive"}
    Wait for user selection.
  {else}
    Auto-select the first candidate. Report selection to user.
    {if autonomy_level == "balanced"}
      "Selected {identifier}: {title}. Press Enter to confirm or type a different identifier."
    {end_if}
  {end_if}
</action>

### Success Criteria
- Reviewed, untested issues identified
- Issue selected

</step>

<step n="2" goal="Load story details and lock">

**Progress: Step 2 of 7** -- Next: Load Context

### 2.1 Load Issue Details

<action>Call `get_issue` with `id: "{selected_issue_id}"` to load full issue details including description and labels</action>
<action>Call `list_comments` with `issueId: "{selected_issue_id}"` to load existing comments</action>
<action>Parse the issue description to extract: user story, acceptance criteria, tasks/sub-issues</action>
<action>Parse comments to find the Dev Agent Record (implementation summary, files changed, decisions made)</action>

### 2.2 Lock

<action>Invoke `lock-work-item` task from `{project-root}/_aria/core/tasks/lock-work-item.md` with `issue_id: "{selected_issue_id}"`, `action: "lock"`, `agent_name: "qa"`</action>

### Success Criteria
- Issue details and comments loaded
- Dev Agent Record parsed
- Issue locked

</step>

<step n="3" goal="Load architecture and project context">

**Progress: Step 3 of 7** -- Next: Generate Tests

### 3.1 Load Architecture

<action>Invoke `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document"` and `scope_key: "architecture"` to fetch the Architecture document</action>

### 3.2 Load Project Context

<action>Read the project context file if it exists: `**/project-context.md`</action>
<action>These provide the technical constraints, testing standards, and patterns to follow</action>

### Success Criteria
- Architecture document loaded (if exists)
- Project context loaded (if exists)
- Testing standards identified

</step>

<step n="4" goal="Generate tests">

**Progress: Step 4 of 7** -- Next: Run Tests

<action>Based on the acceptance criteria and dev agent record, generate tests:</action>

**Test Generation Rules:**
- Focus on realistic user scenarios derived from acceptance criteria
- Use standard test framework APIs only (no external utilities)
- Cover happy path + critical edge cases for each AC
- Keep tests simple and maintainable
- Generate API tests for backend endpoints and E2E tests for user-facing flows
- Tests should be self-contained and pass on first run

### Success Criteria
- Tests generated for each acceptance criterion
- Happy path and edge cases covered
- Tests follow project testing standards

</step>

<step n="5" goal="Run tests and verify">

**Progress: Step 5 of 7** -- Next: Post Summary

<action>Run the generated tests to verify they all pass</action>
<action>Never skip running tests -- every generated test must be executed</action>
<action>If any tests fail, fix them until all pass</action>
<action>Record: test count, test files created, coverage areas, any gaps identified</action>

### Success Criteria
- All tests executed
- All tests passing
- Test metrics recorded

### Failure Modes
- Skipping test execution
- Not fixing failing tests

</step>

<step n="6" goal="Post test summary to the platform">

**Progress: Step 6 of 7** -- Next: Unlock and Handoff

### 6.1 Post Test Summary Comment

<action>Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` on the issue:</action>

```
issueId: "{selected_issue_id}"
body: |
  ## QA Test Summary

  ### Agent Model
  {agent_model_name_version}

  ### Tests Generated
  {list_of_test_files_and_what_they_cover}

  ### Coverage
  - **Acceptance Criteria Covered:** {covered_ac_count}/{total_ac_count}
  - **Test Count:** {test_count} tests ({unit_count} unit, {integration_count} integration, {e2e_count} E2E)
  - **All Tests Passing:** Yes

  ### Coverage Areas
  {for_each_ac}
  - AC #{ac_number}: {ac_description} -- {test_files_covering_this_ac}
  {end_for_each}

  ### Gaps Identified
  {gaps_or_none}
```

### 6.2 Attach Test Report

<action>Invoke the `attach-report` task from `{project-root}/_aria/core/tasks/attach-report.md` to attach the test results as a report on the issue</action>

### 6.3 Update Labels

<action>Invoke the platform's work-item update to add test labels:</action>

```
id: "{selected_issue_id}"
labels: ["{existing_labels}", "{agent_label_prefix}qa", "aria-tested"]
```

### Success Criteria
- Test summary posted as comment
- Test report attached
- Labels updated with aria-tested

</step>

<step n="7" goal="Unlock and hand off">

**Progress: Step 7 of 7** -- Final Step

### 7.1 Unlock

<action>Invoke `lock-work-item` task from `{project-root}/_aria/core/tasks/lock-work-item.md` with `issue_id: "{selected_issue_id}"`, `action: "unlock"`, `agent_name: "qa"`</action>

### 7.2 Post Handoff

<action>Invoke `post-handoff` task from `{project-root}/_aria/core/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "testing_complete"
summary: "Tests generated for {issue_identifier}. {test_count} tests passing. Coverage: {covered_ac_count}/{total_ac_count} acceptance criteria."
issue_ids: ["{selected_issue_id}"]
```

### 7.3 Report to User

**QA Testing Complete: {issue_title}**

- **work item:** {selected_issue_identifier}
- **Tests Created:** {test_count} ({unit_count} unit, {integration_count} integration, {e2e_count} E2E)
- **AC Coverage:** {covered_ac_count}/{total_ac_count}
- **Gaps:** {gap_count}

**Next Steps:**
1. Generate tests for another story with [QA]
2. Or check cycle progress with Sprint Status

### 7.4 Help

<action>Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user</action>

### Success Criteria
- Issue unlocked
- Handoff posted
- User informed of test results

### Failure Modes
- Not unlocking the issue (blocks future work)
- Not posting test summary (no audit trail)

</step>

</workflow>
