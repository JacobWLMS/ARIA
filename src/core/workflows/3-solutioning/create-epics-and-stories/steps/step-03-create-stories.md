# Step 3: Create Stories for Each Epic

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## STEP GOAL

For each approved epic, break down into implementable user stories with acceptance criteria, story point estimates, and dependency information.

---

<workflow>

<step n="3.1" goal="Load approved epic structure from Step 2">
<action>Review the approved epic structure carried forward from Step 2:</action>

- Approved epic list with titles, goals, and FR coverage
- FR coverage map
- All requirements (FRs, NFRs, additional requirements from Architecture/UX)
- Dependency analysis and implementation sequence

<action>Announce: "**Create Epics and Stories — Step 3: Create Stories**"</action>
<action>Explain the approach: "We will work through each epic sequentially, creating stories collaboratively. After each epic's stories are drafted, you will review and approve them before we move to the next epic."</action>
</step>

<step n="3.2" goal="Explain story creation guidelines">
<action>Present the story creation guidelines:</action>

**STORY FORMAT:**

Each story must include:

```
### Story {N}.{M}: {story_title}

As a {user_type},
I want {capability},
So that {value_benefit}.

**Story Points:** {1|2|3|5|8|13}

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}
**And** {additional_criteria}

**Dependencies:** {list of prerequisite stories, or "None"}

**Technical Notes:** {key implementation considerations}
```

**STORY SIZING (relative story points):**
- **1** — Trivial change, configuration, or minor UI tweak
- **2** — Small, well-understood task with minimal complexity
- **3** — Moderate task, straightforward implementation
- **5** — Significant feature, some complexity or unknowns
- **8** — Large feature, multiple components or integration points
- **13** — Very large — consider splitting into smaller stories

**STORY QUALITY RULES:**

1. **Small enough for a single sprint** — if it feels like more than a sprint, split it
2. **Independent where possible** — minimise cross-story dependencies
3. **Testable** — acceptance criteria must be specific and verifiable
4. **User-value focused** — every story should describe what a user can do, not just what the system does internally

**DATABASE/ENTITY CREATION PRINCIPLE:**
Create tables/entities ONLY when needed by the story:
- WRONG: Epic 1 Story 1 creates all 50 database tables
- RIGHT: Each story creates/alters ONLY the tables it needs

**STORY DEPENDENCY PRINCIPLE:**
Stories must be independently completable in sequence:
- WRONG: Story 1.2 requires Story 1.3 to be completed first
- RIGHT: Each story can be completed based only on previous stories
- WRONG: "Wait for Story 1.4 to be implemented before this works"
- RIGHT: "This story works independently and enables future stories"

**ACCEPTANCE CRITERIA GUIDELINES:**
- Use Given/When/Then format
- 3 to 5 acceptance criteria per story
- Each AC should be independently testable
- Include edge cases and error conditions
- Reference specific FRs when applicable

**GOOD STORY EXAMPLES:**

_Epic 1: User Authentication_
- Story 1.1: User Registration with Email
- Story 1.2: User Login with Password
- Story 1.3: Password Reset via Email

_Epic 2: Content Creation_
- Story 2.1: Create New Blog Post
- Story 2.2: Edit Existing Blog Post
- Story 2.3: Publish Blog Post

**BAD STORY EXAMPLES:**
- "Set up database" (no user value)
- "Create all models" (too large, no user value)
- "Build authentication system" (too large, should be multiple stories)
- "Login UI — depends on Story 1.3 API endpoint" (forward dependency)
</step>

<step n="3.3" goal="Process each epic sequentially — generate stories">
<action>For each epic in the approved list, in implementation sequence order, perform steps A through E:</action>

**A. Epic Overview**

Display:
- Epic number and title
- Epic goal statement
- FRs covered by this epic
- Relevant NFRs and additional requirements
- Dependencies on previous epics

**B. Story Breakdown**

Work with the user to break down the epic into stories:
- Identify distinct user capabilities within the epic
- Ensure logical flow within the epic (each story builds on previous ones)
- Size stories appropriately — aim for 2 to 5 story points each
- Check that each story maps to one or more FRs

**C. Generate Each Story**

For each story in the epic, produce:

1. **Story Title**: Clear, action-oriented
2. **User Story**: Complete the "As a / I want / So that" format
3. **Story Points**: Relative estimate (1, 2, 3, 5, 8, 13)
4. **Acceptance Criteria**: 3 to 5 criteria in Given/When/Then format
5. **Dependencies**: List prerequisite stories (within the same epic or from previous epics), or "None"
6. **Technical Notes**: Key implementation considerations from Architecture/UX documents

**D. Present Each Story for Review**

After drafting each story:
- Present the full story to the user
- Ask: "Does this story capture the requirement correctly?"
- Ask: "Is the scope appropriate for a single sprint?"
- Ask: "Are the acceptance criteria complete and testable?"
- Ask: "Is the story point estimate reasonable?"

Allow the user to modify the story before finalising it.

**E. Epic Completion Check**

After all stories for an epic are finalised:
- Display an epic summary showing all stories, total story points, and FR coverage
- Verify all FRs assigned to this epic are covered by at least one story
- If any FRs are uncovered, create additional stories or adjust existing ones
- Get user confirmation to proceed to the next epic

<action>**WAIT POINT:** After each epic's stories are approved, ask: "Stories for Epic {N} are complete. [C] Continue to next epic, or discuss changes?"</action>
<action>ONLY proceed to the next epic when the user confirms</action>
</step>

<step n="3.4" goal="Repeat for all epics">
<action>Continue the process in step 3.3 for each epic in the approved list, processing them in implementation sequence order (Epic 1, Epic 2, etc.)</action>
<action>Maintain a running count of total stories and story points across all epics</action>
</step>

<step n="3.5" goal="Cross-epic dependency validation">
<action>After all epics have been processed, perform a cross-epic dependency check:</action>

- Verify no story depends on a future story (within the same epic or across epics)
- Verify the implementation sequence is achievable given the story dependencies
- Check that stories referencing other epics only depend on stories in EARLIER epics
- Flag any circular or forward dependencies for resolution

<action>If issues are found, work with the user to resolve them by reordering, splitting, or adjusting stories</action>
</step>

<step n="3.6" goal="Present complete structure and confirm">
<action>Present the complete epics and stories structure to the user:</action>

**Summary:**

| Epic | Title | Stories | Story Points | FRs Covered |
|---|---|---|---|---|
| 1 | {title} | {count} | {points} | {fr_list} |
| 2 | {title} | {count} | {points} | {fr_list} |
| ... | ... | ... | ... | ... |
| **Total** | | **{total_stories}** | **{total_points}** | **{total_frs}** |

**FR Coverage:** {covered_count} / {total_count} FRs covered
**Cross-Epic Dependencies:** {count} identified, all valid (no forward dependencies)

<action>Ask: "The complete epic and story structure is ready. Review the summary above. [C] Continue to the platform output, or discuss changes?"</action>
</step>

<step n="3.7" goal="Confirm and proceed to the platform output">
<action>Display: "**All epics and stories are approved. Select an option:** [C] Continue to write to the platform"</action>

**Menu handling:**
- IF **C**: Proceed to step-04-platform-output.md — carry the complete epics/stories structure forward in working memory for platform creation
- IF any other comments or queries: respond to the user, then redisplay the menu option

<action>ALWAYS halt and wait for user input after presenting the menu</action>
<action>ONLY proceed to the next step when user selects C and all stories have been approved</action>
</step>

</workflow>

---

## Success Criteria

- All epics processed in implementation sequence order
- Stories created for each epic with complete user story format
- Each story has 3 to 5 acceptance criteria in Given/When/Then format
- Story point estimates assigned to every story (1, 2, 3, 5, 8, 13)
- Dependencies documented for each story
- Technical notes included where relevant
- All FRs covered by at least one story
- Stories appropriately sized (completable in a single sprint)
- No forward dependencies (within or across epics)
- User approved each epic's stories before proceeding
- Complete structure approved and ready for platform output

## Failure Conditions

- Missing epics or stories
- Stories without acceptance criteria
- Stories too large (should be split) or too vague
- Forward dependencies between stories
- FRs not covered by any story
- Proceeding without user approval for each epic
- Not following the Given/When/Then format for acceptance criteria
