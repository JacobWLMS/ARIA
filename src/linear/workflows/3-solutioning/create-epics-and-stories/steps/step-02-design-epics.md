# Step 2: Design Epic List

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>

## STEP GOAL

Design and get user approval for the epic structure that will organise all requirements into user-value-focused epics. Epics in Linear are represented as Projects.

---

<workflow>

<step n="2.1" goal="Review extracted requirements from Step 1">
<action>Review all requirements carried forward from Step 1:</action>

- **Functional Requirements:** Count and review all FRs
- **Non-Functional Requirements:** Review NFRs that need to be addressed
- **Additional Requirements:** Review technical requirements from Architecture and UX requirements

<action>Briefly summarise the requirements landscape for the user before beginning epic design</action>
</step>

<step n="2.2" goal="Explain epic design principles">
<action>Present the epic design principles to the user:</action>

**EPIC DESIGN PRINCIPLES:**

1. **User-Value First**: Each epic must enable users to accomplish something meaningful
2. **Requirements Grouping**: Group related FRs that deliver cohesive user outcomes
3. **Incremental Delivery**: Each epic should deliver value independently
4. **Logical Flow**: Natural progression from the user's perspective
5. **Dependency-Free Within Epic**: Stories within an epic must NOT depend on future stories

**CRITICAL PRINCIPLE — organise by USER VALUE, not technical layers:**

**CORRECT epic examples (standalone and enable future epics):**
- Epic 1: User Authentication and Profiles (users can register, login, manage profiles) — **Standalone: Complete auth system**
- Epic 2: Content Creation (users can create, edit, publish content) — **Standalone: Uses auth, creates content**
- Epic 3: Social Interaction (users can follow, comment, like content) — **Standalone: Uses auth + content**
- Epic 4: Search and Discovery (users can find content and other users) — **Standalone: Uses all previous**

**WRONG epic examples (technical layers or forward dependencies):**
- Epic 1: Database Setup (creates all tables upfront) — **No user value**
- Epic 2: API Development (builds all endpoints) — **No user value**
- Epic 3: Frontend Components (creates reusable components) — **No user value**

**DEPENDENCY RULES:**
- Each epic must deliver COMPLETE functionality for its domain
- Epic 2 must not require Epic 3 to function
- Epic 3 can build upon Epic 1 and 2 but must stand alone
</step>

<step n="2.3" goal="Identify user value themes and propose epic structure">
<action>Analyse the functional requirements and identify natural groupings:</action>

**Step A — Identify User Value Themes:**
- Look for natural groupings in the FRs
- Identify user journeys or workflows
- Consider user types and their goals

**Step B — Propose Epic Structure:**

For each proposed epic, present:

1. **Epic Title**: User-centric, value-focused
2. **User Outcome**: What users can accomplish after this epic is delivered
3. **FR Coverage**: Which FR numbers this epic addresses
4. **NFR Considerations**: Any NFRs particularly relevant to this epic
5. **Implementation Notes**: Key technical or UX considerations from Architecture/UX documents

**Step C — Format the epic list:**

```
## Epic List

### Epic 1: [Epic Title]
[Epic goal statement — what users can accomplish]
**FRs covered:** FR1, FR2, FR3, etc.

### Epic 2: [Epic Title]
[Epic goal statement — what users can accomplish]
**FRs covered:** FR4, FR5, FR6, etc.

[Continue for all epics]
```

<action>Present the complete proposed epic structure to the user</action>
</step>

<step n="2.4" goal="Dependency analysis">
<action>Analyse and present dependencies between the proposed epics:</action>

For each epic:
- What it depends on (prerequisites from earlier epics)
- What it enables (future epics that build on it)
- Whether it is truly standalone

<action>Set an implementation sequence based on:
1. **Dependencies** — prerequisite epics must come first
2. **Business priority** — higher-value epics earlier where dependencies allow
3. **Risk reduction** — foundational capabilities early to de-risk later epics
</action>

<action>Present the dependency map and sequence to the user</action>
</step>

<step n="2.5" goal="Create requirements coverage map">
<action>Create a requirements coverage map showing how each FR maps to an epic:</action>

```
### FR Coverage Map

FR1: Epic 1 — [Brief description]
FR2: Epic 1 — [Brief description]
FR3: Epic 2 — [Brief description]
...
```

<action>Verify that ALL FRs are covered — no requirement should be left unmapped</action>
<action>If any FRs are uncovered, flag them and discuss with the user which epic should absorb them</action>
</step>

<step n="2.6" goal="Collaborative refinement with user">
<action>Ask the user:</action>

- "Does this epic structure align with your product vision?"
- "Are all user outcomes properly captured?"
- "Should we adjust any epic groupings — merge, split, or reorder?"
- "Are there natural dependencies we have missed?"
- "Would you like to adjust the implementation sequence?"

<action>If the user wants changes:
- Make the requested adjustments to the epic list
- Update the FR coverage map
- Update the dependency analysis
- Re-present the revised structure
- Repeat until the user is satisfied
</action>
</step>

<step n="2.7" goal="Get explicit approval for the epic structure">
<action>Present the final epic structure with a summary:</action>

| # | Epic Title | FRs Covered | Dependencies |
|---|---|---|---|
| 1 | {title} | {fr_list} | None |
| 2 | {title} | {fr_list} | Epic 1 |
| ... | ... | ... | ... |

**Total Epics:** {count}
**Total FRs Covered:** {covered_count} / {total_count}
**Uncovered FRs:** {none or list}

<action>Ask: "Do you approve this epic structure for proceeding to story creation?"</action>
<action>CRITICAL: Must get explicit user approval before proceeding</action>
</step>

<step n="2.8" goal="Confirm and proceed to story creation">
<action>Display: "**Epic structure approved. Select an option:** [C] Continue to Story Creation"</action>

**Menu handling:**
- IF **C**: Proceed to step-03-create-stories.md — carry the approved epic list, FR coverage map, and all requirements forward in working memory
- IF any other comments or queries: respond to the user, then redisplay the menu option

<action>ALWAYS halt and wait for user input after presenting the menu</action>
<action>ONLY proceed to the next step when user selects C and the epic structure has been approved</action>
</step>

</workflow>

---

## Success Criteria

- Epics designed around user value, not technical layers
- All FRs mapped to specific epics with no gaps
- Epic list created with clear titles, goals, and FR coverage
- Requirements coverage map completed and verified
- Dependency analysis performed and implementation sequence set
- User gives explicit approval for the epic structure

## Failure Conditions

- Epics organised by technical layers instead of user value
- Missing FRs in coverage map
- No user approval obtained before proceeding
- Creating individual stories in this step (FORBIDDEN — that is Step 3)
- Forward dependencies between epics (Epic N requires Epic N+1)
