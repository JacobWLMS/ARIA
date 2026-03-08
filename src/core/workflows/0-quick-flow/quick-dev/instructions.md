# Quick Dev — Implement Quick-Spec Issue

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Implements a quick-spec issue directly. Finds issues with the `aria-quick` label, locks the issue, gathers context, implements with TDD discipline, performs adversarial self-review, resolves any findings, posts a Dev Agent Record, and sets state to Done. Quick Flow skips formal code review but compensates with rigorous self-review.

---

<workflow>

<step n="1" goal="Find a quick-flow issue and detect mode (new vs continue)">

**Progress: Step 1 of 6** — Next: Context Gathering

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are Solo — direct, confident, implementation-focused
- Use tech slang naturally (refactor, patch, extract, spike, ship)
- Execute continuously without unnecessary pauses
- Tests are non-negotiable even for quick tasks

### 1.1 Find Quick-Flow Issues

If the user specified an issue identifier, use that directly and skip to 1.3.

Otherwise, search for quick-flow issues not yet completed:
- Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `labels: ["aria-quick"]`, `states: ["Backlog", "Todo", "In Progress"]`

If no issues are found:
"No quick-flow issues found. Run `/aria-quick` first to create one, or give me an issue identifier directly."
**STOP** — do not proceed without an issue.

### 1.2 Present Candidates and Select

If issues are found, present candidates:

| # | ID | Issue | Status |
|---|---|---|---|
| 1 | {identifier} | {title} | {state} |

{if autonomy_level == "interactive"}
  Wait for user selection (auto-select if only one issue exists).
{else}
  Auto-select the first candidate. Report selection to user.
  {if autonomy_level == "balanced"}
    "Selected {identifier}: {title}. Press Enter to confirm or type a different identifier."
  {end_if}
{end_if}

### 1.3 Detect Mode — New Implementation vs Continue

Call `get_issue` with `id: "{selected_issue_id}"` to load full issue details including description and comments.

Call `list_comments` with `issueId: "{selected_issue_id}"` to load existing comments.

**Mode Detection:**

- **Continue Mode** — Issue is "In Progress" and has a previous Dev Agent Record comment:
  - Parse the previous record to understand what was already done
  - Identify remaining tasks (unchecked items in description)
  - Announce: "**Continuing implementation** — picking up where we left off."

- **Fix Mode** — Issue has `aria-review-failed` label:
  - Invoke the `read-context` task with `context_type: "work_items"`, `parentId: "{selected_issue_id}"`, `labels: ["aria-review-finding"]`, `states: ["Backlog", "Todo", "In Progress"]`
  - Load each finding to get severity, location, and description
  - Present the fix punch list:

  | # | ID | Severity | Finding |
  |---|---|---|---|
  | 1 | {identifier} | {severity} | {title} |

  - Announce: "**Fix Mode** — addressing {count} review findings."

- **New Mode** — Issue is in Todo/Backlog with no prior work:
  - Announce: "**New implementation** — starting fresh."

### 1.4 Parse Issue Content

Parse the issue description to extract:
- **Problem Statement** — what we're solving
- **Technical Approach** — how we're solving it
- **Acceptance Criteria** — what "done" looks like (Given/When/Then)
- **Tasks** — ordered implementation checklist
- **Dependencies** — anything we need before starting
- **Testing Strategy** — what tests to write and how
- **Files to Modify/Create** — from the codebase investigation in Quick Spec

If any critical section is missing or unclear, warn the user:
"This spec is missing {section}. I can proceed but the implementation may not match expectations. Want me to continue or should you update the spec first?"

### Success Criteria
- Issue found and selected (or user-specified identifier used)
- Mode correctly detected (new / continue / fix)
- Issue description fully parsed with all sections extracted
- Missing sections flagged before proceeding
- User confirmed selection

### Failure Modes
- Proceeding without an issue (nothing to implement)
- Not detecting continue/fix mode (re-doing completed work)
- Not parsing the full issue description (missing context during implementation)
- Not warning about missing spec sections

</step>

<step n="2" goal="Lock the issue, set state, gather implementation context">

**Progress: Step 2 of 6** — Next: Execute Implementation

### 2.1 Lock the Issue

Invoke `lock-work-item` task with `issue_id: "{selected_issue_id}"`, `action: "lock"`, `agent_name: "dev"`

### 2.2 Set State to In Progress

**New Mode:**
Invoke `set-work-item-state` task:

```
issue_id: "{selected_issue_id}"
target_state: "In Progress"
comment: "Quick Dev agent starting implementation"
```

**Fix Mode:**
Invoke `set-work-item-state` task:

```
issue_id: "{selected_issue_id}"
target_state: "In Progress"
comment: "Quick Dev agent addressing review findings"
```

**Continue Mode:**
Issue is already In Progress — no state change needed.

### 2.3 Create Feature Branch (if git enabled)

If `git_enabled` is `true` in module.yaml:
- Invoke `git-operations` task with operation `create_branch`, passing `issue_key: "{issue_identifier}"` and `summary: "{issue_title}"`
- This creates or checks out a feature branch named `{branch_prefix}/{kebab-summary}`
- Log the branch name for the dev record
- If the operation fails, log the error and continue — git failures must not block development

### 2.4 Load Implementation Context

**Load architecture context:**
- Invoke `read-context` task with `context_type: "document"` and `scope_key: "architecture"` to fetch the Architecture document (if exists)
- This provides tech stack, patterns, and architectural decisions to follow

**Load project context:**
- Search for `**/project-context.md` or similar project convention files
- If found, load and follow the conventions they specify (naming, testing patterns, code style)

**Load codebase context from spec:**
- Use the "Files to Modify" and "Codebase Patterns" sections from the spec
- Read each file listed in the spec to understand current state
- Verify the spec's assumptions against actual code — flag any discrepancies

### 2.5 Context Summary

"**Context loaded. Ready to implement.**

- **Mode:** {new / continue / fix}
- **Branch:** {branch_name or 'git disabled'}
- **Architecture:** {loaded / not found}
- **Project Context:** {loaded / not found}
- **Tasks:** {total_count} ({completed_count} done, {remaining_count} remaining)"

### Success Criteria
- Issue locked with aria-active label
- Correct state set based on mode
- Feature branch created (if git enabled)
- Architecture and project context loaded
- Spec file references verified against actual codebase
- Context summary reported

### Failure Modes
- Not locking before starting work (concurrent agent conflict)
- Wrong state for the current mode
- Not loading architecture context (violating architectural decisions)
- Not verifying spec assumptions against actual code

</step>

<step n="3" goal="Execute implementation with TDD discipline">

**Progress: Step 3 of 6** — Next: Self-Check

### Step Goal

Implement all tasks from the issue spec with strict TDD discipline. Each task follows: read, understand, implement, test, verify. Execute continuously without pausing until all tasks complete.

### 3.1 Critical Dev Agent Rules

These rules are non-negotiable:

1. **READ the entire issue** BEFORE any implementation
2. **Execute tasks IN ORDER** as written in the issue description
3. **Mark task complete ONLY** when both implementation AND tests pass
4. **Run full test suite** after each task
5. **Execute continuously** without pausing until all tasks complete
6. **NEVER lie** about tests being written or passing
7. **Follow project conventions** from project-context if loaded
8. **Follow architectural decisions** from architecture doc if loaded

### 3.2 Task Execution Loop

For each task in the issue (in order):

**Phase A — Understand:**
- Read the task description completely
- Identify which files need to change
- Understand the expected outcome
- Check if this task depends on a previous task's output

**Phase B — Write Tests First (TDD):**
- Write failing tests that verify the task's expected behaviour
- Cover happy path, error cases, and edge cases from ACs
- Follow existing test patterns in the codebase
- Run the tests — they should FAIL (red phase)

**Phase C — Implement:**
- Write the minimum code needed to make the tests pass
- Follow existing code patterns and conventions
- Keep changes focused — don't refactor unrelated code
- Run the tests — they should PASS (green phase)

**Phase D — Refactor (if needed):**
- Clean up any code smells introduced
- Extract common patterns if they emerged
- Run the full test suite — everything must still pass

**Phase E — Verify and Mark Complete:**
- Run the FULL test suite (not just new tests)
- All tests must pass before marking this task complete
- If tests fail, fix the issue before moving to the next task

### 3.3 Fix Mode Execution

If in Fix Mode, instead of the task list, work through the review finding punch list:

For each open review finding sub-issue:
1. Read the finding description (severity, location, issue)
2. Understand the fix needed
3. Implement the fix
4. Write or update tests to prevent regression
5. Run the full test suite
6. Set the finding sub-issue state to Done via `set-work-item-state`

### 3.4 Continue Mode Execution

If in Continue Mode:
- Skip tasks already marked complete (checked items)
- Resume from the first unchecked task
- Follow the same execution loop as New Mode

### 3.5 Git Commits (if git enabled)

If `git_enabled` is `true`:
- After each task (or logical group of tasks), invoke `git-operations` task with operation `commit`
- Commit message format: `{git_commit_prefix}: {task_description}`
- If `git_auto_push` is `true`, push after each commit
- Git failures never block development — log and continue

### 3.6 Halt Conditions

**HALT and request guidance if:**
- 3 consecutive failures on the same task
- Tests fail and the fix is not obvious
- Blocking dependency discovered
- Ambiguity that requires a user decision

**Do NOT halt for:**
- Minor issues that can be noted and continued
- Warnings that don't block functionality
- Style preferences (follow existing patterns)

### Success Criteria
- All tasks executed in order
- Tests written BEFORE implementation (TDD)
- Full test suite passes after each task
- No tests skipped or faked
- Review findings resolved (Fix Mode)
- Commits made per task (if git enabled)

### Failure Modes
- Implementing without writing tests first
- Moving to next task while tests are failing
- Lying about test results
- Skipping tasks or executing out of order
- Not resolving all review findings (Fix Mode)
- Refactoring unrelated code (scope creep)

</step>

<step n="4" goal="Self-check — verify all ACs and run comprehensive validation">

**Progress: Step 4 of 6** — Next: Adversarial Self-Review

### Step Goal

After all tasks are complete, verify the implementation against every acceptance criterion and perform comprehensive validation. This is the quality gate before self-review.

### 4.1 Acceptance Criteria Verification

For each AC from the issue:

| AC # | Title | Verified | Evidence |
|---|---|---|---|
| AC-1 | {title} | {Pass/Fail} | {test name or manual verification} |
| AC-2 | {title} | {Pass/Fail} | {test name or manual verification} |

Every AC must map to at least one passing test. If an AC has no test coverage, write the test now.

### 4.2 Comprehensive Test Run

Run the complete test suite one final time:
- All tests must pass
- Record the total test count and pass count
- Note any skipped tests and why

### 4.3 Implementation Completeness Check

Verify against the spec:
- All "Files to Modify" — were they modified?
- All "Files to Create" — were they created?
- All tasks — are they checked off?
- Dependencies — were they satisfied?
- Out of scope — did we stay within boundaries?

If any gaps are found, fix them now before proceeding to self-review.

### 4.4 Report Self-Check Results

"**Self-Check Complete:**
- **ACs:** {passed}/{total} passing
- **Tests:** {test_count} total, all passing
- **Tasks:** {completed}/{total} complete
- **Scope:** {within bounds / scope creep detected}"

### Success Criteria
- Every AC verified with passing test evidence
- Full test suite passes with zero failures
- All files from spec accounted for
- All tasks completed
- Implementation stays within defined scope

### Failure Modes
- ACs without test coverage
- Tests failing at final verification
- Missing files from the spec
- Scope creep (implementing beyond what was specified)

</step>

<step n="5" goal="Adversarial self-review — find issues before someone else does">

**Progress: Step 5 of 6** — Next: Complete and Report

### Step Goal

Perform a ruthless adversarial self-review of your own implementation. Be your own worst critic. Find bugs, security issues, performance problems, and code quality issues BEFORE the code ships. Quick Flow skips formal code review, so this self-review must compensate.

### 5.1 Construct Diff

**If git is available:**
- Run `git diff HEAD~{task_count}` or `git diff` to get all changes
- Include new untracked files as full content additions

**If git is not available:**
- List all files modified and created during implementation
- Show current state of each changed file

Capture all changes as the review input.

### 5.2 Code Quality Review

Review ALL changed/created files for:

**Correctness:**
- Logic errors or off-by-one mistakes
- Unhandled edge cases
- Race conditions or concurrency issues
- Incorrect error handling

**Security (OWASP Top 10):**
- Input validation on all user/external input
- SQL injection, XSS, command injection vectors
- Authentication/authorisation bypasses
- Sensitive data exposure (logging passwords, tokens in URLs)
- Insecure defaults

**Performance:**
- N+1 queries or unnecessary database calls
- Missing indexes on queried fields
- Unbounded loops or memory allocations
- Missing pagination on list endpoints

**Code Quality:**
- Functions doing too much (single responsibility)
- Dead code or unused imports
- Inconsistent naming or style
- Missing error messages or unclear error handling

### 5.3 Test Quality Review

Review ALL test files for:

- Are tests actually testing the right thing? (Not just asserting `true`)
- Are edge cases covered?
- Are error paths tested?
- Are tests independent? (No test ordering dependencies)
- Are mocks appropriate? (Not mocking the thing being tested)

### 5.4 Finding Classification and Resolution

Classify each finding by severity:

**Critical:** Must fix before shipping — security vulnerabilities, data loss risks, crashes
**Major:** Should fix — significant code quality issues, missing error handling, logic errors
**Minor:** Nice to fix — style issues, minor improvements, documentation gaps

Present findings:

| # | Severity | Category | Description |
|---|---|---|---|
| F1 | Critical | Security | {description} |
| F2 | Major | Correctness | {description} |

**Critical and Major findings:** Fix immediately. This is non-negotiable.
- Implement the fix
- Update or add tests
- Run the full test suite

**Minor findings:** Fix if quick (< 5 minutes each). Otherwise note in the dev record.

### 5.5 Report Self-Review Results

"**Self-Review Complete:**
- **Findings:** {critical_count} critical, {major_count} major, {minor_count} minor
- **Fixed:** {fixed_count}
- **Deferred:** {deferred_count} (minor only)
- **Final Test Run:** {test_count} tests, all passing"

### Success Criteria
- All changed files reviewed for correctness, security, performance, quality
- All test files reviewed for test quality
- All critical and major findings fixed
- Full test suite passes after fixes
- Deferred findings documented

### Failure Modes
- Rubber-stamping your own code (not being genuinely critical)
- Deferring critical or major findings
- Not re-running tests after fixes
- Missing security vulnerabilities in the review

</step>

<step n="6" goal="Post Dev Agent Record, set state to Done, and report">

**Progress: Step 6 of 6** — Final Step

### 6.1 Post Dev Agent Record

Invoke the `post-comment` task from `{project-root}/_aria/core/tasks/post-comment.md` on the issue:

```
issueId: "{selected_issue_id}"
body: |
  ## Dev Agent Record

  ### Agent Model
  {agent_model_name_version}

  ### Mode
  {new / continue / fix}

  ### Implementation Summary
  {what_was_implemented}

  ### Tests Created
  {list_of_test_files_and_what_they_cover}

  ### Self-Review Summary
  - Critical findings: {count} (all fixed)
  - Major findings: {count} (all fixed)
  - Minor findings: {count} ({fixed_count} fixed, {deferred_count} deferred)

  ### Decisions Made
  {any_implementation_decisions_or_deviations_from_spec}

  ### Files Changed
  {complete_list_of_changed_files}

  ### All Tests Passing
  All tests pass ({test_count} tests)

  ### Branch
  {branch_name or 'git disabled'}
```

### 6.2 Set State to Done

Quick-flow issues skip formal code review — transition directly to Done.

Invoke `set-work-item-state` task:

```
issue_id: "{selected_issue_id}"
target_state: "Done"
comment: "Quick Dev implementation complete. Self-review passed."
```

### 6.3 Git — Final Push and PR (if git enabled)

If `git_enabled` is `true`:
- Invoke `git-operations` task with operation `push` to ensure all commits are on remote
- If `git_auto_pr` is `true`:
  - Invoke `git-operations` task with operation `create_pr`
  - PR title: `{issue_identifier}: {issue_title}`
  - PR body: implementation summary from dev record
  - If `git_pr_draft` is `true`, create as draft PR

### 6.4 Unlock the Issue

Invoke `lock-work-item` task with `issue_id: "{selected_issue_id}"`, `action: "unlock"`, `agent_name: "dev"`

### 6.5 Report Completion

"**Quick Dev Complete: {issue_title}**

- **work item:** {issue_identifier}
- **Status:** Done
- **Mode:** {new / continue / fix}
- **Files Changed:** {file_count}
- **Tests:** {test_count} passing
- **Self-Review:** {finding_count} findings, all critical/major fixed
- **Branch:** {branch_name or 'git disabled'}
- **PR:** {pr_url or 'N/A'}

**Implementation Summary:**
{brief_summary_of_what_was_built}

**Next Steps:**
1. Verify the implementation manually if needed
2. Run `/aria-cr` for formal adversarial review
3. Run `/aria-quick` for another quick task
4. Or return to full workflow with `/aria-dev`"

### 6.6 Help

Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user.

### Success Criteria
- Dev Agent Record posted as platform comment with all sections
- Issue state set to Done
- Git pushed and PR created if enabled
- Issue unlocked
- User informed of completion with next steps

### Failure Modes
- Not posting the Dev Agent Record (no implementation audit trail)
- Not unlocking the issue (blocks future work)
- Not setting state to Done (issue appears still in progress)
- Git operations blocking platform completion (git failures should never block)
- Not suggesting code review as next step

</step>

</workflow>
