# Quick Spec — One-Off Tech Spec to work item

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

<workflow>

<step n="1" goal="Understand the requirement — analyse the delta between current state and target">

**Progress: Step 1 of 5** — Next: Codebase Investigation

### Role & Communication

- Communicate in {communication_language} with {user_name}
- You are a Quick Flow agent creating focused, implementation-ready tech specs
- Keep the conversation lean — this is Quick Flow, not a planning marathon
- Adapt technical depth to `{user_skill_level}`
- No fluff, just results

### 1.0 Detect Issue Type

<action>Analyze the user's input (if provided with the command) to determine if this is a **bug fix** or a **new feature**:</action>

**Bug indicators:** error messages, "not working", "broken", stack traces, regression language, "used to work", "crash", "500", "exception"
**Feature indicators:** "add", "new", "create", "I want", "implement", enhancement language, "would be nice"

<action>
{if detected_as_bug OR user says "bug"}
  Present: "This looks like a bug fix. Two options:"
  - **[Q] Quick Bug** — Create a minimal work item with repro steps and jump straight to implementation (skip spec). Best for clear, isolated bugs.
  - **[S] Spec It** — Go through the full spec process. Better for complex bugs with unclear root cause.

  {if autonomy_level == "yolo"} Auto-select Quick Bug for clear bugs with repro steps, Spec for ambiguous ones. {end_if}
  {if autonomy_level == "balanced"} Auto-select Quick Bug if error message / stack trace is present, otherwise ask. {end_if}
{else}
  Proceed with normal feature spec flow (Step 1.1 below).
{end_if}
</action>

### Quick Bug Path (if selected)

<action>If Quick Bug was selected:</action>

1. **Gather minimal context** (keep it lean — 3-4 questions max):
   - What's the expected behavior?
   - What's the actual behavior?
   - Steps to reproduce (if not already provided)
   - Error messages / stack traces (if any)

2. **Create work item immediately:**

<action>Invoke the `create-work-item` task from `{project-root}/_aria/core/tasks/create-work-item.md` with:</action>

```
team: "{team_name}"
title: "[Bug] {brief_description}"
description: |
  ## Bug Report

  **Expected:** {expected}
  **Actual:** {actual}

  ### Repro Steps
  {numbered_steps}

  ### Error Output
  {error_or_stack_trace_if_any}

  ---
  *Created via Quick Bug flow*
labels: ["aria-quick"]
state: "In Progress"
```

3. **Hand off to dev immediately:**

<action>Lock the issue via `lock-work-item` task, then invoke the dev-story workflow at `{project-root}/_aria/core/workflows/4-implementation/dev-story/workflow.yaml` to begin implementation. Skip the spec phase entirely.</action>

<action>If Quick Bug was NOT selected, continue with the normal spec flow below.</action>

---

### 1.1 Announce Quick Flow Mode

"**Quick Spec Mode** — Creating a one-off tech spec as a work item. No PRD, no Project, no cycle. Let's scope this and ship it."

### 1.2 Check for Existing Quick-Flow Issues

Search for existing quick-flow issues that might overlap:
- Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "work_items"`, `team: "{team_name}"`, `labels: ["aria-quick"]`, `states: ["Backlog", "Todo", "In Progress", "In Review"]`

If similar issues exist, mention them briefly:
"Found {count} existing quick-flow issues. Check none of these overlap with what you're about to describe:
{list of existing issue titles}"

### 1.3 Gather the Core Problem

"**What are we building/fixing/changing?** Give me the elevator pitch."

Wait for user input.

### 1.4 Deep Problem Understanding

Based on the user's description, probe deeper with focused follow-ups. Don't ask all of these — pick the ones that matter for this specific task:

**For bug fixes:**
- What's the current behaviour vs expected behaviour?
- How reproducible is it? Steps to reproduce?
- What's the blast radius — who/what is affected?
- Is there a workaround in place?

**For new features:**
- What user problem does this solve?
- What does "done" look like from the user's perspective?
- Is there prior art or a pattern to follow in the codebase?
- What's the simplest version that delivers value?

**For refactoring/improvements:**
- What's wrong with the current approach?
- What's the target state?
- What constraints exist (backwards compatibility, API contracts)?
- Is this blocking something else?

**For spikes/prototypes:**
- What question are we trying to answer?
- What's the success/failure criteria for the spike?
- Is this throwaway code or potentially shippable?
- What's the time box?

Push back on vague descriptions. "Fix the thing" is not a spec — get specifics.

### 1.5 Clarify Scope and Constraints

Once the problem is clear, nail down the boundaries:

1. **Expected Outcome** — What does "done" look like? What should the user be able to do when this is complete?
2. **Constraints** — Technology constraints, time limits, backward compatibility requirements?
3. **Out of Scope** — What does this explicitly NOT cover? (Prevents scope creep later)

### 1.6 Define Acceptance Criteria

Collaboratively define 3-5 specific, measurable acceptance criteria using Given/When/Then format:

"Let's define the ACs. Each one should be independently testable. I'll draft them based on what you've told me."

```
AC-{number}: {short_descriptive_title}

Given {precondition or initial state}
When {action performed by user or system}
Then {expected outcome or result}
```

Cover:
- Happy path (primary success scenario)
- Error/edge cases (at least one)
- Boundary conditions (if applicable)

Present the ACs to the user for validation.

### 1.7 Confirm Understanding

Summarise and confirm with the user:

- **Title:** A clear, concise name for this work
- **Problem Statement:** What problem are we solving?
- **Solution:** High-level approach (1-2 sentences)
- **In Scope:** What's included
- **Out of Scope:** What's explicitly NOT included
- **ACs:** The acceptance criteria defined above

{if autonomy_level == "interactive"}
  Wait for explicit user confirmation of scope and ACs before proceeding.
{else}
  Present scope and ACs, then auto-proceed.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### 1.8 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Deep Investigation (Step 2 of 5)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with current understanding. Process enhanced insights. Ask user if they accept improvements. If yes, update understanding and redisplay menu. If no, keep original and redisplay.
- IF P: Invoke `{project-root}/_aria/shared/tasks/party-mode.md` with current understanding. Process collaborative insights. Ask user if they accept changes. If yes, update and redisplay. If no, keep original and redisplay.
- IF C: Proceed to step 2.

### Success Criteria
- Clear problem statement with specific details (not vague)
- Scope boundaries defined (in scope and out of scope)
- 3-5 measurable acceptance criteria in Given/When/Then format
- User confirms understanding before codebase investigation
- Overlapping existing issues checked

### Failure Modes
- Accepting vague descriptions without pushing for specifics
- Skipping out-of-scope definition (leads to scope creep in Quick Dev)
- ACs that aren't independently testable
- Not checking for overlapping existing quick-flow issues

</step>

<step n="2" goal="Map technical constraints and anchor points in the codebase">

**Progress: Step 2 of 5** — Next: Generate Tech Spec

### Step Goal

Deep investigation of the actual codebase to map the problem statement to specific anchor points — exact files to touch, classes/patterns to extend, and technical constraints identified. This step is what separates a good spec from a guess.

### 2.1 Codebase Discovery

Based on the problem description from step 1, investigate the relevant parts of the codebase:

**Locate affected files:**
- Search for files related to the feature/bug area using glob patterns and grep
- Read key files completely — don't skim
- Identify the entry points, data flow, and exit points for the change

**Understand existing patterns:**
- How is similar functionality implemented elsewhere in the codebase?
- What frameworks, libraries, or abstractions are in use?
- What testing patterns exist? (test framework, mocking approach, fixture patterns)
- What naming conventions are followed?

**Check for project context:**
- Look for `**/project-context.md` or similar project convention files
- If found, load and follow the conventions they specify

**Check the platform for architectural context:**
- Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document_artefact"` to search for architecture or project context documents
- If architectural documents exist, check for relevant patterns or constraints

Ask the user:
"Based on my quick look, I see {files/patterns found}. Are there other files or directories I should investigate deeply?"

### 2.2 Dependency and Impact Analysis

Assess the change's footprint:

- What files need to be modified?
- What files need to be created?
- Are there database/schema changes needed?
- Are there API contract changes?
- What existing tests might be affected?
- Are there downstream consumers of the code being changed?

**If no relevant code exists (clean slate):**
- Identify the target directory where the feature should live
- Scan parent directories for architectural context
- Identify standard project utilities or boilerplate that should be used
- Document this as "Confirmed Clean Slate" — no legacy constraints exist

### 2.3 Identify Technical Risks

Surface anything that could bite during implementation:

- **Complexity traps:** Is this simpler or harder than it looks?
- **Hidden dependencies:** Does this touch shared code or utilities?
- **Test gaps:** Is the area well-tested or a testing desert?
- **Performance concerns:** Could the change affect performance?

### 2.4 Report Investigation Findings

Present a brief summary:

"**Codebase Investigation Complete:**

- **Tech Stack:** {languages, frameworks, libraries}
- **Files to modify:** {list with file paths}
- **Files to create:** {list with file paths}
- **Key patterns found:** {summary of relevant code patterns and conventions}
- **Test patterns:** {test framework, structure, conventions}
- **Potential risks:** {any risks identified}
- **Estimated complexity:** {low / medium / high}"

### 2.5 Menu

"**Select:** [A] Advanced Elicitation [P] Party Mode [C] Continue to Generate Spec (Step 3 of 5)"

- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with current technical context. Process enhanced insights. Ask user if they accept improvements. If yes, update context and redisplay. If no, keep original and redisplay.
- IF P: Invoke `{project-root}/_aria/shared/tasks/party-mode.md` with current context. Process collaborative insights. Ask user if they accept changes. If yes, update and redisplay. If no, keep original and redisplay.
- IF C: Proceed to step 3.

{if autonomy_level == "interactive"}
  Wait for user acknowledgement before generating the spec.
{else}
  Report findings and auto-proceed.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Relevant source files read completely (not guessed at)
- Existing patterns and conventions identified
- Files to modify/create listed with rationale
- Technical risks surfaced before spec generation
- Project context and architecture docs loaded if available

### Failure Modes
- Skipping codebase investigation and guessing at implementation details
- Not reading existing code before proposing changes
- Missing hidden dependencies or shared code impacts
- Not checking for project context or coding conventions

</step>

<step n="3" goal="Generate the implementation-ready tech spec with self-review">

**Progress: Step 3 of 5** — Next: User Review

### Step Goal

Create the implementation plan — specific, actionable tasks with file references, acceptance criteria in Given/When/Then format, and all supporting context. Then perform a critical self-review before presenting. This is documentation only — no implementation yet.

### 3.1 Generate Task Breakdown

Create specific implementation tasks. Each task must be:
- A discrete, completable unit of work
- Ordered logically (dependencies first)
- Specific about which files to modify
- Explicit about what changes to make

Format:
```markdown
- [ ] Task 1: {clear action description}
  - File: `path/to/file.ext`
  - Action: {specific change to make}
  - Notes: {implementation details}
```

Always include a test-writing task and a full-test-suite-run task.

### 3.2 Complete Supporting Context

**Dependencies:**
- External libraries or services needed
- Other tasks or features this depends on
- API or data dependencies
- Or "None" if no dependencies

**Testing Strategy:**
- Unit tests needed (specific test files and what to test)
- Integration tests needed
- Manual testing steps (if applicable)
- Which test patterns from step 2 to follow

**Notes:**
- High-risk items from the investigation
- Known limitations
- Future considerations (out of scope but worth noting)

### 3.3 Compile Complete Tech Spec

Compile all sections into the structured tech spec. Generate in {document_output_language}:

```markdown
## Problem Statement
{concise description of the problem or need — from step 1}

## Proposed Solution
{high-level approach — what will change and why}

## Technical Approach

### Codebase Patterns
{relevant patterns from step 2 that the implementation must follow}

### Files to Modify
| File | Change Description |
|---|---|
| {file_path} | {what changes and why} |

### Files to Create
| File | Purpose |
|---|---|
| {file_path} | {why this file is needed} |

### Technical Decisions
{architectural or implementation decisions made, with rationale}

### Dependencies
{external dependencies — or "None"}

## Acceptance Criteria

AC-1: {title}
Given {precondition}
When {action}
Then {expected outcome}

{all ACs from step 1}

## Tasks

- [ ] Task 1: {specific implementation task}
- [ ] Task 2: {next task}
- [ ] Task N: Write tests
- [ ] Task N+1: Run full test suite and verify all pass

## Testing Strategy
{what tests to write, patterns to follow, edge cases to cover}

## Out of Scope
{from step 1}

## Notes
{risks, limitations, future considerations}
```

### 3.4 Self-Review (Adversarial)

Before presenting to the user, perform a critical self-review:

**Completeness:**
- Does every AC have at least one task that delivers it?
- Are all files from codebase investigation accounted for?
- Is the testing strategy specific enough to execute?
- Are dependencies identified and manageable?

**Feasibility:**
- Can each task be completed independently?
- Are there circular dependencies between tasks?
- Is the task ordering logical?
- Are there any tasks too large? (Split them)

**Clarity:**
- Would a developer unfamiliar with this code understand the spec?
- Are technical decisions justified?
- Are the ACs specific enough to test against?

**Risk:**
- Are there edge cases the ACs don't cover?
- Is there a rollback plan if something goes wrong?
- Are there performance implications not addressed?

Fix any issues found during self-review before presenting.

Auto-proceed to step 4.

### Success Criteria
- Tasks are specific, actionable, and ordered logically with file references
- Every AC maps to at least one task
- All template sections filled — no placeholder text remaining
- Self-review completed with no outstanding issues
- Spec meets the "ready for development" standard

### Failure Modes
- Vague tasks without specific file references
- ACs that are not testable or measurable
- Placeholder text remaining in the spec
- Skipping self-review and presenting a spec with gaps
- Missing testing strategy or task for running tests

</step>

<step n="4" goal="Present spec for user review and finalise">

**Progress: Step 4 of 5** — Next: Create work item

### 4.1 Present Complete Spec

"Here's your complete tech spec. Please review:

{display complete spec content}

**Quick Summary:**
- {task_count} tasks to implement
- {ac_count} acceptance criteria to verify
- {files_count} files to modify/create
- **Estimated complexity:** {low / medium / high}"

### 4.2 Review Menu

"**Select:** [C] Create work item [E] Edit [Q] Questions [A] Advanced Elicitation [P] Party Mode [R] Adversarial Review"

- IF C: Proceed to step 5.
- IF E: Accept user's requested changes. Make the edits. Re-present affected sections. Loop until user is satisfied, then redisplay menu.
- IF Q: Answer questions about the spec. Redisplay menu.
- IF A: Invoke `{project-root}/_aria/shared/tasks/advanced-elicitation.md` with current spec. Process enhanced insights. Ask user if they accept improvements. If yes, update spec and redisplay. If no, keep original and redisplay.
- IF P: Invoke `{project-root}/_aria/shared/tasks/party-mode.md` with current spec. Process collaborative insights. Ask user if they accept changes. If yes, update and redisplay. If no, keep original and redisplay.
- IF R: Execute adversarial review (see below). Then redisplay menu.

**Adversarial Review [R] Process:**

1. Load and follow the review task at `{project-root}/_aria/shared/tasks/review-adversarial.md`, passing the complete spec as content. If task invocation is not available, follow instructions inline.

2. Process findings:
   - If zero findings: HALT — this is suspicious. Re-analyse or request user guidance.
   - Evaluate severity (Critical / High / Medium / Low) and validity (real / noise / undecided)
   - Do NOT exclude findings unless explicitly asked
   - Order by severity, number as F1, F2, F3...
   - Present as table:

   | ID | Severity | Validity | Description |
   |----|----------|----------|-------------|
   | F1 | Critical | real | {description} |

3. Return to review menu.

{if autonomy_level == "interactive"}
  Wait for explicit user selection.
{else}
  Auto-proceed with C after presenting the spec.
  {if autonomy_level == "balanced"}
    Wait briefly for user override.
  {end_if}
{end_if}

### Success Criteria
- Complete spec presented for review with summary statistics
- User changes implemented if requested (edit loop)
- Adversarial review available and findings processed correctly
- User confirms spec is ready before work item creation
- Spec verified against "ready for development" standard

### Failure Modes
- Not presenting the complete spec for review
- Proceeding to the platform issue creation without user confirmation
- Accepting zero adversarial findings without questioning
- Not offering edit option before publishing

</step>

<step n="5" goal="Create work item with the tech spec and report completion">

**Progress: Step 5 of 5** — Final Step

### 5.1 Resolve Assignee

If `{default_assignee}` is configured (non-empty in module.yaml):
- Invoke the platform's user lookup to find the user matching `{default_assignee}` by name or email
- Record the user ID for assignment

### 5.2 Create the work item

<action>Invoke the `create-work-item` task from `{project-root}/_aria/core/tasks/create-work-item.md` with:</action>

```
team: "{team_name}"
title: "{concise_issue_title}"
description: "{compiled_tech_spec_content}"
state: "Todo"
labels: ["aria-quick", "{agent_label_prefix}dev"]
assignee: "{resolved_user_id}"    # omit if no default_assignee
priority: {estimated_priority}    # 1=urgent, 2=high, 3=medium, 4=low
```

**Notes:**
- The `labels` parameter accepts label names — the platform resolves them to IDs
- Ensure required labels exist before applying them (the create-work-item task handles this)

### 5.3 Link Dependencies

If dependencies were identified that reference existing work items:
- Embed issue identifiers directly in the description under the Dependencies section
- Optionally invoke the platform's work-item relation mechanism to create formal dependency links

### 5.4 Report Completion

"**Quick Spec Created**

- **work item:** {issue_identifier} — {issue_title}
- **Labels:** aria-quick, {agent_label_prefix}dev
- **Acceptance Criteria:** {ac_count} defined
- **Tasks:** {task_count} to implement
- **Estimated Complexity:** {low / medium / high}

**Next Steps:**
1. Run `/aria-quick-dev` to implement this issue directly
2. Or assign it manually in the platform for later implementation
3. Run `/aria-cr` after implementation for adversarial review

For best results, implement in a fresh context:
Run `/aria-quick-dev` and select {issue_identifier}"

### 5.5 Help

Invoke the help task at `{project-root}/_aria/core/tasks/help.md` to present context-aware next-step recommendations to the user.

### Success Criteria
- work item created with complete tech spec as description
- Correct labels applied (aria-quick)
- Assignee set if default_assignee is configured
- Dependencies linked or embedded in description
- Clear next-step guidance provided (recommending fresh context for dev)

### Failure Modes
- Missing aria-quick label (Quick Dev won't find the issue)
- Not creating labels before applying them if they don't exist
- Not reporting the issue identifier to the user
- Not recommending fresh context for implementation

</step>

</workflow>
