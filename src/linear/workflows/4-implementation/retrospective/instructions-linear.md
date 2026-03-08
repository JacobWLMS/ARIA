# Retrospective — Party Mode Multi-Agent Epic Review (Linear)

<critical>You MUST have already loaded and processed: the workflow-linear.yaml for this workflow</critical>
<critical>Communicate all responses in {communication_language} and language MUST be tailored to {user_skill_level}</critical>
<critical>Generate all documents in {document_output_language}</critical>

<critical>
DOCUMENT OUTPUT: Retrospective analysis published to Linear Document. Concise insights, lessons learned, action items. User skill level ({user_skill_level}) affects conversation style ONLY, not retrospective content.

FACILITATION NOTES:

- Tempo (Scrum Master) facilitates this retrospective
- Psychological safety is paramount — NO BLAME
- Focus on systems, processes, and learning
- Everyone contributes with specific examples preferred
- Action items must be achievable with clear ownership
- Two-part format: (1) Project Review + (2) Next Project Preparation

PARTY MODE PROTOCOL:

- ALL agent dialogue MUST use format: "Name (Role): dialogue"
- Example: Tempo (SM): "Let's begin..."
- Example: {user_name} (Project Lead): [User responds]
- Create natural back-and-forth with user actively participating
- Show disagreements, diverse perspectives, authentic team dynamics

DATA SOURCE:

- All data comes from Linear via Linear MCP tools
- list_issues for project/issue queries
- get_issue for issue details and descriptions
- list_comments for loading issue comments
- save_comment for posting comments
- list_documents / get_document for finding previous retros
- write-to-linear-doc task for creating the retro document
- set-issue-state task for completing the project
- post-handoff task for signaling next agent
</critical>

<workflow>

<step n="1" goal="Project Discovery — Find the Project to Retrospect">

<action>Communicate in {communication_language} with {user_name}</action>

<output>
Tempo (SM): "Welcome to the retrospective, {user_name}. Before we get the whole team together, let me figure out which project we're reviewing today."

Tempo (SM): "Let me pull up the projects for the team..."
</output>

<action>Call `list_projects` with `team: "{linear_team_name}"` to load all projects</action>
<action>Store the list of projects with their names, summaries, and statuses</action>

<action>
{if autonomy_level == "interactive"}
  Present the full Project list to the user with status indicators and wait for selection.
{else}
  Auto-detect the most recently completed Project — the one where all child issues are Done and with the most recent Done completion date.
  Report the selection to the user.
  {if autonomy_level == "balanced"}
    "Selected {project_name}. Press Enter to confirm or type a different name."
  {end_if}
{end_if}
</action>

<output>
Tempo (SM): "Here's what I found for the {linear_team_name} team:"

**Projects:**

| # | Name | Summary | Status |
|---|------|---------|--------|
{{project_table}}

Tempo (SM): "{user_name}, which project are we running the retrospective for today?"
</output>

<action>WAIT for {user_name} to select a project (unless autonomy auto-selected)</action>

<action>Set {{project_name}} = user-selected or auto-detected project name</action>
<action>Call `get_project` with the selected project to load full details</action>
<action>Store {{project_summary}}, {{project_status}}, {{project_description}}</action>

<output>
Tempo (SM): "Got it — we're reviewing '{{project_name}}': '{{project_summary}}'. Let me check the issues under this project."
</output>

<action>Call `list_issues` with `team: "{linear_team_name}"`, `project: "{{project_name}}"` to load all issues</action>
<action>Count total issues, count issues with state = Done</action>
<action>Collect list of pending issue identifiers (state != Done)</action>

<check if="all issues are Done">
  <output>
Tempo (SM): "All {{total_issues}} issues under '{{project_name}}' are Done. We're clear for a full retrospective."
  </output>
</check>

<check if="some issues are NOT Done">
  <output>
Tempo (SM): "Heads up, {user_name} — not all issues are complete yet."

**Project Status:**

- Total Issues: {{total_issues}}
- Completed (Done): {{done_issues}}
- Pending: {{pending_count}}

**Pending Issues:**
{{pending_issue_list}}

Tempo (SM): "We typically run retrospectives after all issues are done. Running it now means we might miss lessons from those in-flight issues."

**Options:**

1. Complete remaining issues first (recommended)
2. Continue with partial retrospective anyway
3. Cancel and come back later
  </output>

<action>WAIT for {user_name} to choose</action>

  <check if="user says stop or option 1 or 3">
    <output>
Tempo (SM): "Smart call. Let's finish those issues first and circle back for a proper retrospective."
    </output>
    <action>HALT</action>
  </check>

  <check if="user says continue or option 2">
    <action>Set {{partial_retrospective}} = true</action>
    <output>
Tempo (SM): "Understood — we'll run a partial retro on the completed issues. I'll note the pending ones in the report so we can revisit them later."
    </output>
  </check>
</check>

</step>

<step n="2" goal="Deep Issue Analysis — Extract Data from Linear Issues and Comments">

<output>
Tempo (SM): "Before I bring the team in, let me dig through all the issue records. The good stuff is always in the comments."
</output>

<action>For each issue under project {{project_name}}:</action>
<action>Call `get_issue` to load the full description, state, assignee, and acceptance criteria</action>
<action>Call `list_comments` with `issueId: "{issue_id}"` to retrieve all comments on the issue</action>

<action>Parse each issue's comments to identify and extract:</action>

**Dev Agent Records:**

- Look for comments containing "Dev Agent Record", "Implementation Notes", "Development Log"
- Extract what was implemented, decisions made, files changed
- Note unexpected complexity, technical gotchas, or rework
- Track where estimates diverged from reality

**Code Review Results:**

- Look for comments containing "Code Review", "Review Results", "CR Results"
- Extract findings: issues flagged, patterns identified, approvals
- Note recurring feedback themes across issues
- Track quality trends (improving, declining, stable)

**QA Findings:**

- Look for comments containing "QA Results", "Test Results", "QA Testing"
- Extract bugs found, test coverage notes, regression risks
- Note testing challenges or gaps
- Track which issues had clean QA vs. multiple rounds

**Handoff Comments:**

- Look for comments containing "Handoff", "Ready for"
- Track handoff quality — were issues well-prepared for the next agent?
- Note any blocked or bounced handoffs

<action>For each issue, build a structured analysis record:</action>

```
Issue: {identifier} — {title}
State: {state}
What went well: {extracted_positives}
What was difficult: {extracted_challenges}
Review findings: {extracted_review_notes}
QA results: {extracted_qa_notes}
Technical debt: {extracted_debt_items}
Lessons: {extracted_lessons}
```

<action>Synthesize patterns across ALL issues:</action>

**Common Struggles** — Issues that appeared in 2+ stories
**Recurring Review Feedback** — Themes from code reviews
**Breakthrough Moments** — Key discoveries or innovations
**Quality Patterns** — Testing trends, bug categories
**Collaboration Highlights** — Effective handoffs, agent coordination

<output>
Tempo (SM): "All right, I've reviewed all {{total_issues}} issue records with their comments. Found some interesting patterns we should discuss."

Tempo (SM): "Let me load any previous retrospectives before we start the team discussion."
</output>

</step>

<step n="3" goal="Previous Retro Integration — Search Linear Documents for Continuity">

<action>Call `list_documents` to search for previous retrospective documents (look for titles containing "Retrospective")</action>

<check if="previous retrospective documents found">
  <action>Call `get_document` for the most recent retrospective document</action>
  <action>Extract key elements from the previous retro content:</action>

  - **Action items committed**: What did the team agree to improve?
  - **Lessons learned**: What insights were captured?
  - **Process improvements**: What changes were agreed upon?
  - **Technical debt flagged**: What debt was documented?

  <action>Cross-reference with current project's issue data:</action>

  **Action Item Follow-Through:**
  - For each previous action item, look for evidence in current project's dev records and comments
  - Mark each: COMPLETED, IN PROGRESS, or NOT ADDRESSED

  <output>
Tempo (SM): "I found a previous retrospective document. Let me see what we committed to last time..."

Tempo (SM): "We had {{action_count}} action items. We completed {{completed_count}}, made progress on {{in_progress_count}}, and didn't address {{not_addressed_count}}."

Tempo (SM): "We'll discuss the follow-through during the retro — it's important context."
  </output>
</check>

<check if="no previous retrospectives found">
  <output>
Tempo (SM): "No previous retrospectives found in Linear Documents. This looks like our first one — good time to start the habit."
  </output>
  <action>Set {{first_retrospective}} = true</action>
</check>

</step>

<step n="4" goal="Next Project Preview — Look Ahead for Context">

<action>Call `list_projects` with `team: "{linear_team_name}"` to find projects that are not completed</action>
<action>Exclude {{project_name}} from results if it appears</action>

<check if="next project found">
  <action>Set {{next_project_name}} = first incomplete project</action>
  <action>Call `get_project` to load full details for {{next_project_name}}</action>
  <action>Call `list_issues` with `project: "{{next_project_name}}"` to preview its issues</action>

  <action>Analyze the next project for:</action>
  - Title, objectives, and scope
  - Planned issues and their complexity
  - Dependencies on {{project_name}} work
  - New technical requirements or capabilities needed
  - Potential risks or unknowns

  <output>
Tempo (SM): "I've previewed the next project: '{{next_project_name}}' — '{{next_project_summary}}'. It has {{next_issue_count}} issues planned."

Tempo (SM): "I can see some dependencies on the work we just did. We'll talk about readiness during the discussion."
  </output>
  <action>Set {{next_project_exists}} = true</action>
</check>

<check if="no next project found">
  <output>
Tempo (SM): "No upcoming projects found in the backlog. We might be at the end of the roadmap, or we haven't planned that far. Either way, we'll still do a thorough retro — the lessons carry forward."
  </output>
  <action>Set {{next_project_exists}} = false</action>
</check>

</step>

<step n="5" goal="Initialize Party Mode — Assemble the Team">

<output>
Tempo (SM): "All right, I've got all the data we need. Time to bring the team together."

---

**TEAM RETROSPECTIVE — {{project_name}}: {{project_summary}}**

---

Tempo (SM): "Thanks for joining, everyone. We're here to review '{{project_name}}' and learn from it — what worked, what didn't, and how we get better."

Tempo (SM): "Let me introduce who's at the table today."

**The Team:**

- **Tempo (Scrum Master)** — Facilitator. Keeping us focused, managing the conversation, making sure every voice is heard.
- **Maestro (PM)** — Product and business perspective. User impact, market alignment, requirements clarity.
- **Riff (Dev)** — Technical perspective. Code quality, architecture decisions, implementation realities.
- **Pitch (QA)** — Quality perspective. Testing coverage, regression risks, quality trends.
- **{user_name} (Project Lead)** — Active participant. You've got the broadest visibility across the project, and your perspective is crucial.

Maestro (PM): "Good to be here. I've been reviewing the user feedback on the features we shipped in this project."

Riff (Dev): "Same — I've got some thoughts on how implementation went. Some good, some... less good."

Pitch (QA): "I've been tracking quality metrics across the issues. Interesting patterns."

Tempo (SM): "Ground rules before we start:"

1. **Psychological safety first** — No blame, no judgment. We focus on systems and processes, not individuals.
2. **Specific examples** — Reference actual issue identifiers and data, not vague generalizations.
3. **Respectful disagreement** — Different perspectives make us stronger. Push back with data, not heat.
4. **Everyone contributes** — I'll make sure every voice is heard, including yours, {user_name}.

Tempo (SM): "Here's a quick snapshot of where we stand:"

**PROJECT '{{project_name}}' SUMMARY:**

- Issues: {{done_issues}}/{{total_issues}} completed ({{completion_percentage}}%)
- Status: {{project_status}}
{{#if partial_retrospective}}- NOTE: Running partial retro — {{pending_count}} issues still in progress{{/if}}

Tempo (SM): "{user_name}, any questions before we dive in?"
</output>

<action>WAIT for {user_name} to respond or indicate readiness</action>

<output>
Tempo (SM): "Great. Let's get into it."
</output>

</step>

<step n="6" goal="Project Review Discussion — The Core Party Mode Conversation">

<!-- ============================================== -->
<!-- SECTION 1: WHAT WENT WELL (~100 lines)         -->
<!-- ============================================== -->

<output>
Tempo (SM): "Let's start with the positive. What went well in this project? Who wants to kick us off?"

Tempo (SM): _creates space, lets the team settle in_

Maestro (PM): "I'll start from the product side. Looking at the issues we delivered..."

Maestro (PM): "The core functionality in the early issues landed cleanly. Users are engaging with it the way we hoped — the acceptance criteria we defined actually matched real usage patterns. That doesn't always happen."

Riff (Dev): "I'll add to that. The implementation for {{first_issue_identifier}} set a solid foundation. The architecture decisions we made early — separating concerns properly, keeping interfaces clean — paid off in the later issues. When I got to {{later_issue_identifier}}, I could build on a stable base instead of fighting the codebase."

Pitch (QA): "From my side, testing was smoother than I expected on most issues. The dev records Riff left in the comments were detailed enough that I could write targeted tests without guessing at intent. That's not always the case."

Riff (Dev): _slight smile_ "I learned my lesson from a previous project where Pitch had to bounce an issue back because my notes were garbage."

Pitch (QA): "I wouldn't say garbage... but yes, the improvement is noticeable."

Maestro (PM): _laughing_ "Growth through pain. A core product development principle."

Tempo (SM): "Good stuff. I noticed the same pattern in the issue records — handoff quality between Dev and QA was noticeably stronger in the second half of the project."
</output>

<action>Tempo (SM) turns to {user_name} — KEY USER INTERACTION</action>

<output>
**WAIT** — Tempo (SM): "{user_name}, you've had visibility across the whole project. What stood out to you as going well?"
</output>

<action>WAIT for {user_name} to respond</action>

<action>After {user_name} responds, have 2-3 team members react naturally to what {user_name} shared — agreeing, building on it, or offering additional context</action>

<output>
Maestro (PM): [Responds naturally to what {user_name} said, connecting it to product outcomes or user impact]

Riff (Dev): [Builds on the discussion with technical details — perhaps connecting {user_name}'s observation to specific implementation decisions]

Pitch (QA): [Adds quality perspective — perhaps noting how {user_name}'s point aligns with test results they observed]

Tempo (SM): "These are important wins to acknowledge. Let me capture those before we move on."
</output>

<!-- ============================================== -->
<!-- SECTION 2: WHAT DIDN'T GO WELL (~150 lines)    -->
<!-- ============================================== -->

<action>Guide the transition to challenges with care — maintain psychological safety</action>

<output>
Tempo (SM): "Okay, we've celebrated some real wins. Now the harder part — where did we struggle? What slowed us down or didn't go as planned?"

Tempo (SM): _adjusts tone, creates safe space_ "Remember, this isn't about pointing fingers. It's about finding the systemic issues we can fix."

Tempo (SM): _pauses, creating space_

Riff (Dev): _takes a breath_ "I'll go first since I'm closest to the code. {{difficult_issue_identifier}} was rough. The requirements looked straightforward, but once I started implementing, I hit complexity that wasn't visible in the issue description. I had to rework the approach twice."

Maestro (PM): _frowning_ "Wait — what complexity? The acceptance criteria were clear."

Riff (Dev): "The ACs were clear on WHAT to build, but the HOW had hidden dependencies. The issue assumed a data model that didn't match what we actually had from {{earlier_issue_identifier}}. I had to bridge that gap at implementation time."

Maestro (PM): _defensive_ "That data model was discussed during planning. I thought we aligned on it."

Riff (Dev): _firm but not hostile_ "We aligned on the conceptual model. But the actual implementation from the earlier issue evolved during development — as it should. The problem is that the issue wasn't updated to reflect those changes."

Pitch (QA): "I can confirm — when I tested {{difficult_issue_identifier}}, I found edge cases that the ACs didn't cover because they were based on the original data model, not the actual one. That cost me an extra testing cycle."

Tempo (SM): _intervening calmly_ "Let's pause here. I'm hearing a real pattern."

Tempo (SM): "Riff, you're saying the issue spec didn't reflect implementation reality. Maestro, you're saying the spec was clear at planning time. Pitch, you're saying QA caught the mismatch late."

Tempo (SM): "This isn't anyone's fault — it's a process gap. When implementation changes the underlying model, how do we propagate that knowledge to downstream issues?"

Maestro (PM): _softening_ "That's fair. I could've checked in on the data model mid-project instead of assuming it stayed frozen."

Riff (Dev): "And I should've flagged the deviation sooner instead of just adapting quietly. A comment on the parent project issue would've been enough."

Tempo (SM): "{user_name}, you have visibility across the whole project. What's your take on this? Have you seen this pattern — specs drifting from reality during implementation?"
</output>

<action>**WAIT** for {user_name} to respond and help navigate the discussion</action>

<action>Use {user_name}'s response to guide the team toward systemic understanding</action>

<output>
Tempo (SM): [Synthesizes {user_name}'s input with team perspectives] "So it sounds like the core issue was {{root_cause_synthesis}} — not any individual failing."

Riff (Dev): "That makes sense. If we'd had {{preventive_measure}}, I could've caught that earlier."

Maestro (PM): "And from my side, I could {{pm_improvement}}. That would've kept the ACs grounded in reality."

Pitch (QA): "I'd add that if dev records in the Linear comments included model changes or deviations from the spec, my test planning would be much more accurate."

Tempo (SM): "Good. We're identifying systemic improvements. Let's keep going."
</output>

<!-- ============================================== -->
<!-- SECTION 3: PATTERNS FROM ISSUE ANALYSIS         -->
<!-- ============================================== -->

<action>Weave in the patterns discovered from the deep issue analysis in Step 2</action>

<output>
Tempo (SM): "Speaking of patterns, I noticed some things when I reviewed all the issue records and comments..."

Tempo (SM): "Pattern one: {{pattern_1_description}} — this showed up in {{pattern_1_count}} out of {{total_issues}} issues."

Pitch (QA): "Seriously? I knew it was a problem, but I didn't realize it was that pervasive."

Riff (Dev): "Now that you mention it, I remember dealing with that in {{example_issue_identifier}}. I thought it was a one-off."

Tempo (SM): "Pattern two: {{pattern_2_description}} — came up in almost every code review."

Riff (Dev): _wincing_ "That's... yeah, that's a habit I need to break. Or maybe it's something we should codify in our development standards."

Maestro (PM): "From a product perspective, these patterns worry me. If {{pattern_1_description}} keeps recurring, it could affect user experience in the next project."

Tempo (SM): "{user_name}, did you notice these patterns during the project? Or is this new information?"
</output>

<action>**WAIT** for {user_name} to share their observations on the patterns</action>

<action>Use {user_name}'s response to deepen the discussion</action>

<!-- ============================================== -->
<!-- SECTION 4: PREVIOUS RETRO FOLLOW-THROUGH       -->
<!-- ============================================== -->

<check if="previous retrospective exists (from Step 3)">
  <output>
Tempo (SM): "Before we move on, I want to circle back to our previous retrospective."

Tempo (SM): "We made commitments last time. Let's see how we followed through."

Tempo (SM): "Action item 1: '{{prev_action_1}}' — Status: {{prev_action_1_status}}"

Maestro (PM): {{#if prev_action_1 completed}}"We actually did that one, and I think it helped. I noticed {{evidence_of_impact}}."{{else}}"We... didn't get to that one. Life happened."{{/if}}

Tempo (SM): "Action item 2: '{{prev_action_2}}' — Status: {{prev_action_2_status}}"

Pitch (QA): {{#if prev_action_2 completed}}"This one made testing noticeably smoother this time around."{{else}}"If we'd done this, I'm pretty sure {{missed_outcome}} wouldn't have happened."{{/if}}

Riff (Dev): "I'll be honest — when retro action items aren't tracked in Linear, they tend to evaporate. Maybe we should create actual Linear issues for retro commitments."

Tempo (SM): "That's a great suggestion. We'll add it to our action items for this retro."

Tempo (SM): "{user_name}, looking at what we committed to last time and what actually happened — what's your reaction?"
  </output>

<action>**WAIT** for {user_name} to respond</action>

<action>Use the follow-through discussion as a learning moment about accountability</action>
</check>

<!-- ============================================== -->
<!-- SECTION 5: PROCESS AND TECH DEBT DISCUSSION    -->
<!-- ============================================== -->

<output>
Tempo (SM): "Let's talk about two things that affect the next project: process improvements and technical debt."

Tempo (SM): "Riff, what technical debt did we accumulate in this project?"

Riff (Dev): "A few things. First, {{tech_debt_item_1}} — we made a pragmatic shortcut in {{debt_issue_identifier}} that needs to be addressed before it becomes load-bearing. Second, {{tech_debt_item_2}} — this one's more subtle but it'll bite us if we add the features planned for the next project."

Pitch (QA): "From a testing perspective, {{testing_debt_item}} is concerning. We don't have adequate coverage for {{coverage_gap_area}}, and the next project builds directly on top of it."

Maestro (PM): "How much of this debt is the 'deal with it eventually' kind versus the 'deal with it now or suffer later' kind?"

Riff (Dev): "{{tech_debt_item_1}} is 'now or suffer.' {{tech_debt_item_2}} is 'eventually, but soon.'"

Maestro (PM): _concerned_ "The 'now or suffer' item — does it affect user-facing behavior, or is it purely internal?"

Riff (Dev): "Right now it's internal. But if we build '{{next_project_name}}'s features on top of it without fixing it, it'll start affecting reliability."

Pitch (QA): "And reliability issues become user-facing issues very quickly."

Tempo (SM): "This is exactly the kind of thing retrospectives are for — catching debt before it compounds."

Tempo (SM): "On process improvements — what would each of you change about how we work?"

Maestro (PM): "I'd like us to do a mid-project checkpoint on the data model and key assumptions. A 15-minute sync after the first few issues are done, just to make sure reality matches the spec."

Riff (Dev): "I'd like clearer escalation paths. When I hit a blocker during implementation, I sometimes spend time trying to solve it solo when a quick question to Maestro or Pitch would unblock me faster."

Pitch (QA): "I need dev records to be more structured. Not just 'here's what I did' but 'here's what changed from the spec and why.' That one change would cut my test planning in half."

Tempo (SM): "{user_name}, from your vantage point — what process change would have the biggest impact?"
</output>

<action>**WAIT** for {user_name} to share their process improvement ideas</action>

<!-- ============================================== -->
<!-- SECTION 6: SUMMARY OF DISCUSSION               -->
<!-- ============================================== -->

<output>
Tempo (SM): "All right, we've covered a lot of ground. Let me summarize what I'm hearing..."

Tempo (SM): "**Successes:**"
{{list_success_themes}}

Tempo (SM): "**Challenges:**"
{{list_challenge_themes}}

Tempo (SM): "**Key Insights:**"
{{list_insight_themes}}

Tempo (SM): "**Technical Debt:**"
{{list_debt_items}}

Tempo (SM): "Does that capture it? Did I miss anything important?"

Riff (Dev): [Potentially adds a technical nuance]

Maestro (PM): [Potentially adds a product perspective]

Pitch (QA): [Potentially adds a quality observation]

Tempo (SM): "Good. Let's move to the next project."
</output>

</step>

<step n="7" goal="Next Project Preparation — Team Readiness Discussion">

<check if="{{next_project_exists}} == false">
  <output>
Tempo (SM): "Normally we'd discuss preparing for the next project, but since there's nothing in the backlog after '{{project_name}}', let's skip ahead to action items."

Maestro (PM): "We should probably plan the next project soon. That could be an action item."

Tempo (SM): "Noted. Let's capture that."
  </output>
  <action>Skip to Step 8</action>
</check>

<output>
Tempo (SM): "Let's shift gears. '{{next_project_name}}' is coming up: '{{next_project_summary}}'"

Tempo (SM): "The question is: are we ready? What do we need before we start?"

Maestro (PM): "From a product standpoint, I've reviewed the issues for '{{next_project_name}}'. The requirements are solid, but there are dependencies on what we just built in '{{project_name}}'."

Maestro (PM): "Specifically, {{dependency_concern_1}}. If that's not stable, Issues 2 and 3 in the next project are going to struggle."

Riff (Dev): _concerned_ "And I'm worried about the technical debt we just discussed. {{tech_debt_item_1}} is directly in the critical path for '{{next_project_name}}'. We can't start building on a shaky foundation."

Pitch (QA): "I need to flag something too — {{testing_infrastructure_need}}. Without that in place, testing for the next project will have the same bottlenecks we saw in {{bottleneck_issue_identifier}}."

Riff (Dev): "There's also a knowledge gap. '{{next_project_name}}' touches {{unfamiliar_area}}, and none of us have deep experience there. Some research or spiking might be warranted."

Tempo (SM): "{user_name}, the team is surfacing some real concerns. What's your sense of our readiness for '{{next_project_name}}'?"
</output>

<action>**WAIT** for {user_name} to share their readiness assessment</action>

<action>Use {user_name}'s input to guide deeper exploration</action>

<output>
Maestro (PM): [Reacts to {user_name}'s assessment] "I agree with {user_name} about {{point_of_agreement}}, but I'm still concerned about {{lingering_concern}}."

Riff (Dev): "Here's what I think we need technically before '{{next_project_name}}' can start:"

Riff (Dev): "1. {{tech_prep_item_1}} — this is the debt resolution that's blocking."
Riff (Dev): "2. {{tech_prep_item_2}} — research spike for the unfamiliar area."
Riff (Dev): "3. {{tech_prep_item_3}} — infrastructure or tooling setup."

Maestro (PM): _frustrated_ "But we have momentum right now. Can we really afford a prep phase? Stakeholders are expecting continuous delivery."

Riff (Dev): "What stakeholders are expecting is features that work. If we skip prep and build on {{tech_debt_item_1}}, we're going to hit walls mid-project and velocity will crater."

Pitch (QA): "Riff's right. I've seen the pattern — we rush into a project, hit a systemic issue in Issue 3, and spend more time debugging than we would've spent on prep."

Tempo (SM): "Let's find a middle ground. Riff, which prep items are absolutely critical versus nice-to-have?"

Riff (Dev): _thinking_ "{{tech_prep_item_1}} is non-negotiable. {{tech_prep_item_2}} is important but could happen in parallel with the first issue. {{tech_prep_item_3}} is nice-to-have."

Maestro (PM): _looking at the next project's issues_ "Actually, Issue 1 in '{{next_project_name}}' is about {{independent_work}} — it doesn't depend on the debt fix. We could start that while Riff resolves the tech debt."

Riff (Dev): "That could work. As long as nobody touches {{affected_area}} until the fix is in."

Pitch (QA): "I can use that time to set up {{testing_infrastructure_need}}."

Tempo (SM): "{user_name}, the team is finding a workable compromise. Does this approach make sense?"
</output>

<action>**WAIT** for {user_name} to validate or adjust the preparation strategy</action>

<output>
Tempo (SM): "Good. Here's the preparation plan we're aligning on:"

**CRITICAL PREPARATION (Before project starts):**
{{list_critical_prep_items_with_owners}}

**PARALLEL PREPARATION (During early issues):**
{{list_parallel_prep_items_with_owners}}

**NICE-TO-HAVE (If time allows):**
{{list_nice_to_have_items}}

Tempo (SM): "Everyone clear on what needs to happen before '{{next_project_name}}' kicks off?"

Riff (Dev): "Clear. I'll get started on the debt resolution as soon as this retro wraps."

Pitch (QA): "Same — test infrastructure is my priority."
</output>

</step>

<step n="8" goal="Action Items + Change Detection — Collaborative SMART Items">

<output>
Tempo (SM): "Let's capture concrete action items from everything we discussed. I want specific, achievable actions with clear owners — not vague aspirations."

Tempo (SM): "Based on our conversation, here's what I'm proposing..."
</output>

<action>Synthesize themes from the retrospective discussion into actionable improvements</action>
<action>Create SMART action items — Specific, Measurable, Achievable, Relevant, Time-bound</action>

<output>
---

**PROJECT '{{project_name}}' — ACTION ITEMS:**

---

**Process Improvements:**

1. {{action_item_1}}
   Owner: {{agent_1}}
   Success criteria: {{criteria_1}}

2. {{action_item_2}}
   Owner: {{agent_2}}
   Success criteria: {{criteria_2}}

3. {{action_item_3}}
   Owner: {{agent_3}}
   Success criteria: {{criteria_3}}

Riff (Dev): "I can own item 1, but I want to be realistic about the scope. Can we define 'done' as {{refined_criteria}}?"

Tempo (SM): "That's more concrete. Updated."

Pitch (QA): "For item 2, can we also {{qa_addition}}? It ties directly to the testing gaps we discussed."

Maestro (PM): "Agreed. And I'll own item 3 — it's a product responsibility."

**Technical Debt Resolution:**

1. {{debt_item_1}}
   Owner: {{debt_owner_1}}
   Priority: {{priority_1}}

2. {{debt_item_2}}
   Owner: {{debt_owner_2}}
   Priority: {{priority_2}}

Pitch (QA): "Can we prioritize debt item 1 as critical? It caused testing issues in three different issues."

Riff (Dev): "I had it as high because {{reasoning}}. But you're right — if it's blocking QA efficiency, it should be critical."

Tempo (SM): "{user_name}, this is a priority call. Testing impact versus {{reasoning}} — what priority should debt item 1 get?"
</output>

<action>**WAIT** for {user_name} to help resolve priority discussions and approve action items</action>

<output>
**Team Agreements (how we work differently going forward):**

- {{agreement_1}}
- {{agreement_2}}
- {{agreement_3}}

Riff (Dev): "I like agreement 2. That would've saved me significant rework on {{difficult_issue_identifier}}."

Maestro (PM): "And agreement 1 addresses the spec-reality drift issue we discussed."

Pitch (QA): "Agreement 3 is the one I care most about. Structured dev records will transform my test planning."

---
</output>

<action>CRITICAL ANALYSIS — Detect if discoveries require updates to existing artefacts</action>

<action>Check if any of the following are true based on retrospective discussion:</action>

- Architectural assumptions from planning proven wrong during {{project_name}}
- Major scope changes or descoping occurred that affects next project
- Technical approach needs fundamental change for {{next_project_name}}
- Dependencies discovered that {{next_project_name}} doesn't account for
- User needs significantly different than originally understood
- Performance or scalability concerns that affect next project design
- Security or compliance issues discovered that change approach
- Technical debt level unsustainable without intervention

<check if="significant discoveries detected">
  <output>
---

**SIGNIFICANT DISCOVERY ALERT**

---

Tempo (SM): "{user_name}, we need to flag something important."

Tempo (SM): "During '{{project_name}}', the team uncovered findings that may require updating the plan for '{{next_project_name}}'."

**Significant Changes Identified:**

1. {{significant_change_1}}
   Impact: {{impact_description_1}}

2. {{significant_change_2}}
   Impact: {{impact_description_2}}

Riff (Dev): "When we discovered {{technical_discovery}}, it changed our understanding of {{affected_area}}. The current issues for '{{next_project_name}}' don't account for that."

Maestro (PM): "From a product perspective, {{product_discovery}} means some of '{{next_project_name}}'s issues may be based on incorrect assumptions."

Pitch (QA): "If we start '{{next_project_name}}' as-is, we're going to hit the same walls — except later and louder."

**RECOMMENDED ACTIONS:**

1. Review and update '{{next_project_name}}' issue descriptions based on new learnings
2. Update architecture or technical specifications in Linear Documents if applicable
3. Hold alignment session before starting '{{next_project_name}}'
4. Consider updating the PRD if user needs have shifted

Tempo (SM): "{user_name}, this is significant. How do you want to handle it?"
  </output>

<action>**WAIT** for {user_name} to decide on how to handle significant changes</action>

  <output>
Maestro (PM): "Better to adjust now than fail mid-project."

Riff (Dev): "This is exactly why retrospectives matter. We caught this before it became a disaster."

Tempo (SM): "Adding to critical path: review '{{next_project_name}}' before kickoff."
  </output>
</check>

<check if="no significant discoveries">
  <output>
Tempo (SM): "Good news — nothing from '{{project_name}}' fundamentally changes our plan for '{{next_project_name}}'. The direction is sound."

Maestro (PM): "We learned a lot, but the roadmap holds."

Riff (Dev): "That's reassuring. The foundation is solid."
  </output>
</check>

<output>
Tempo (SM): "Complete action plan: {{total_action_count}} action items, {{prep_task_count}} preparation tasks."

Tempo (SM): "Everyone clear on what they own?"

Riff (Dev): "Clear."
Pitch (QA): "Clear."
Maestro (PM): "Clear."
</output>

</step>

<step n="9" goal="Critical Readiness — Testing, Deployment, Stakeholder Acceptance">

<output>
Tempo (SM): "Before we close, one more thing. Let's make sure '{{project_name}}' is actually DONE-done."

Tempo (SM): "Issues marked Done in Linear doesn't always mean truly complete. Let's do a readiness check."

Maestro (PM): "What do you mean?"

Tempo (SM): "I mean: is this project production-ready? Have we validated everything? Are there loose ends?"

Tempo (SM): "{user_name}, let's walk through this together."
</output>

<action>Explore testing and quality readiness</action>

<output>
Tempo (SM): "{user_name}, tell me about the testing for '{{project_name}}'. What verification has been done beyond what Pitch flagged in the Linear comments?"
</output>

<action>**WAIT** for {user_name} to describe testing status</action>

<output>
Pitch (QA): [Responds to what {user_name} shared] "I can add to that — {{additional_testing_context}}."

Pitch (QA): "But honestly, {{testing_concern_if_any}}."

Tempo (SM): "{user_name}, are you confident '{{project_name}}' is production-ready from a quality perspective?"
</output>

<action>Explore deployment considerations</action>

<output>
Tempo (SM): "{user_name}, what's the deployment status? Is the work from '{{project_name}}' live, scheduled, or pending?"

Riff (Dev): "This matters because if '{{next_project_name}}' depends on deployed features from '{{project_name}}', we need that in production first."
</output>

<action>Explore stakeholder acceptance</action>

<output>
Tempo (SM): "{user_name}, have stakeholders seen and accepted the '{{project_name}}' deliverables?"

Maestro (PM): "This is important — I've seen 'done' projects get rejected by stakeholders and force rework that derails the next project."

Tempo (SM): "{user_name}, any stakeholder feedback still pending?"
</output>

<action>**WAIT** for {user_name} to address testing, deployment, and stakeholder status</action>

<check if="{user_name} raises concerns">
  <output>
Tempo (SM): "Let's capture those concerns and figure out how they affect our timeline."

Riff (Dev): [Helps quantify the technical work needed]

Pitch (QA): [Helps quantify the testing work needed]

Maestro (PM): [Helps assess stakeholder impact]

Tempo (SM): "Adding these to the critical path. They need to be resolved before we consider '{{project_name}}' truly complete."
  </output>
  <action>Add identified items to the critical path and action items</action>
</check>

<output>
Tempo (SM): "Here's the readiness assessment:"

**PROJECT '{{project_name}}' READINESS:**

- Testing & Quality: {{quality_status}}
- Deployment: {{deployment_status}}
- Stakeholder Acceptance: {{acceptance_status}}
- Technical Stability: {{stability_status}}

Tempo (SM): "{user_name}, does this match your understanding?"
</output>

<action>**WAIT** for {user_name} to confirm or correct the assessment</action>

<output>
Tempo (SM): "Based on this, '{{project_name}}' is {{readiness_conclusion}}."

Riff (Dev): "Better to catch this now than three issues into the next project."
</output>

</step>

<step n="10" goal="Closure — Final Statements and Celebration">

<output>
Tempo (SM): "We've covered a lot of ground today. Let me bring this retrospective to a close."

---

**RETROSPECTIVE COMPLETE — {{project_name}}: {{project_summary}}**

---

Tempo (SM): "Before we officially wrap, I want each person to share one thing — your most important takeaway from this retrospective."

Maestro (PM): "For me, it's {{john_takeaway}}. That insight changes how I'll write requirements for '{{next_project_name}}'."

Riff (Dev): "Mine is {{amelia_takeaway}}. It's a technical discipline issue, and I'm committed to fixing it."

Pitch (QA): "{{quinn_takeaway}}. If we actually follow through on this, testing velocity will improve significantly."

Tempo (SM): "{user_name}, what's your key takeaway?"
</output>

<action>**WAIT** for {user_name} to share their closing reflection</action>

<output>
Tempo (SM): [Acknowledges {user_name}'s takeaway] "That's a good one, {user_name}. Thank you."

Tempo (SM): "Here's what we committed to today:"

- Action Items: {{action_count}}
- Preparation Tasks: {{prep_task_count}}
- Team Agreements: {{agreement_count}}
{{#if significant_discoveries}}- Critical: Review '{{next_project_name}}' before kickoff{{/if}}

Tempo (SM): "I'm going to create actual Linear issues for the key action items so they don't evaporate like last time."

Pitch (QA): "Please do. Accountability matters."

Tempo (SM): "Now — the important part."
</output>

<check if="all issues are Done and project is complete">
  <output>
Tempo (SM): "'{{project_name}}' is COMPLETE. Every issue delivered. This team shipped real work."

---

**PROJECT COMPLETE: {{project_name}} — {{project_summary}}**

Issues Delivered: {{total_issues}}

---

Maestro (PM): "Proud of what we shipped here. The users are going to love it."

Riff (Dev): "It wasn't always pretty, but the end result is solid."

Pitch (QA): "And we learned a lot doing it. That's what counts."

Tempo (SM): "Well done, team. Well done, {user_name}. Take a moment to appreciate this before we charge into '{{next_project_name}}'."
  </output>
</check>

<check if="partial retrospective or project not fully complete">
  <output>
Tempo (SM): "We've reviewed what we can with the completed issues. Once the remaining {{pending_count}} issues wrap up, we may want to do a brief follow-up to capture those lessons too."

Maestro (PM): "The insights from today are still valuable. We can apply them immediately."
  </output>
</check>

<output>
Tempo (SM): "All right, team — great session. We learned from '{{project_name}}', and we're better prepared for what's next."

Maestro (PM): "See you at project planning."

Riff (Dev): "Time to knock out that prep work."

Pitch (QA): "I'll have the test infrastructure ready."

Tempo (SM): "{user_name}, thanks for your active participation. Your perspective made this retro significantly richer."

Tempo (SM): "Meeting adjourned."

---
</output>

</step>

<step n="11" goal="Save — Publish to Linear Document and Update Issues">

### 11.0 Calculate Sprint Velocity Metrics

<action>Calculate velocity and quality metrics from the issue data gathered in step 2:</action>

```
## Sprint Velocity Metrics

### Throughput
- Stories completed: {done_issues}
- Total story points delivered: {sum of estimate fields from done issues}
- Average points per story: {total_points / done_issues}

### Cycle Time
- Average time from Todo → Done: {avg_cycle_time_days} days
- Fastest story: {fastest_identifier} ({fastest_days} days, {fastest_points} points)
- Slowest story: {slowest_identifier} ({slowest_days} days, {slowest_points} points)

### Quality
- Stories passing code review first time: {first_pass_count} / {done_issues} ({first_pass_pct}%)
- Stories requiring re-work (aria-review-failed): {review_failed_count}
- Defect rate: {review_failed_count / done_issues * 100}%

### Estimation Accuracy
- Stories completed at or under estimate: {on_target_count}
- Stories that took significantly longer than estimated: {over_estimate_count}
- Average estimation variance: {avg_variance}%
```

<action>Compare against previous retrospective velocity data (from step 3) to show trends:</action>

```
### Velocity Trend
| Sprint | Points Delivered | Cycle Time (avg) | First-Pass Rate |
|---|---|---|---|
| {previous_sprint_2} | {points} | {days} | {pct}% |
| {previous_sprint_1} | {points} | {days} | {pct}% |
| **This Sprint** | **{points}** | **{days}** | **{pct}%** |
| **Trend** | {up/down/stable} | {up/down/stable} | {up/down/stable} |
```

<action>Include these metrics in the retrospective document — they feed into future sprint planning capacity calculations</action>

### 11.1 Compile Document

<action>Compile the full retrospective content including:</action>

- **Sprint velocity metrics** (from 11.0 above — this section is critical for future sprint planning)
- Project summary and metrics
- Team participants
- Successes and strengths
- Challenges and growth areas
- Key insights and patterns from issue analysis
- Previous retro follow-through analysis (if applicable)
- Technical debt inventory
- Next project preview and dependencies (if applicable)
- Action items with owners and success criteria
- Preparation tasks for next project
- Significant discoveries and recommended changes (if any)
- Readiness assessment
- Team commitments and agreements
- Individual takeaways

<action>Invoke the `write-to-linear-doc` task from `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with:</action>

```
title: "[{linear_team_name}] Retrospective: {{project_summary}} ({date})"
content: "{compiled_retrospective_content}"
key_map_entry: "documents.retrospective_{{project_name}}"
```

<action>Post a summary comment on a representative issue in the Project via `save_comment`:</action>

```
issueId: "{representative_issue_id}"
body: |
  ## Retrospective Complete

  **Date:** {date}
  **Document:** {retrospective_document_title}

  ### Key Takeaways
  {top_3_insights}

  ### Action Items ({action_count})
  {action_items_summary}

  ### Team Agreements
  {agreements_summary}

  {{#if significant_discoveries}}
  ### Significant Discoveries
  {significant_discovery_summary}
  {{/if}}
```

<action>Check if all issues under the project are in Done state</action>

<check if="all issues are Done">
  <action>Mark the project as completed via `save_project`:</action>

  ```
  id: "{project_id}"
  state: "completed"
  ```

  <output>Project '{{project_name}}' marked as Completed.</output>
</check>

<check if="not all issues are Done">
  <output>Project '{{project_name}}' NOT marked complete — {{pending_count}} issues still pending. Project remains in current status.</output>
</check>

<action>Update `{key_map_file}` with the new Document ID under `documents.retrospective_{{project_name}}`</action>

</step>

<step n="12" goal="Final Summary + Handoff">

<output>
**Retrospective Complete**

- **Linear Document:** {retrospective_document_title}
- **Project:** {{project_name}} — {{project_summary}}
- **Issues Reviewed:** {{done_issues}}/{{total_issues}}
- **Project Status:** {{project_status_final}}
- **Action Items:** {{action_count}}
- **Preparation Tasks:** {{prep_task_count}}
- **Team Agreements:** {{agreement_count}}
- **Significant Discoveries:** {{significant_discovery_count}}
{{#if significant_discovery_count > 0}}
- **IMPORTANT:** Review '{{next_project_name}}' issues before starting — discoveries from this retro require plan adjustments
{{/if}}

**Next Steps:**

1. Execute preparation tasks (owners assigned above)
2. Resolve critical path items before '{{next_project_name}}' kickoff
3. Track action items in next standup
{{#if project_update_needed}}4. **Schedule '{{next_project_name}}' planning review session**{{/if}}
</output>

<action>Invoke the `post-handoff` task from `{project-root}/_aria/linear/tasks/post-handoff.md` with:</action>

```
handoff_to: "SM"
handoff_type: "retrospective_complete"
summary: "Retrospective for '{{project_name}}' published to Linear Document. {{project_status_message}}. {{action_count}} action items assigned."
document_title: "{retrospective_document_title}"
next_project: "{{next_project_name}}"
```

<action>Invoke the help task at `{project-root}/_aria/linear/tasks/help.md` to present context-aware next-step recommendations to the user</action>

</step>

</workflow>

<facilitation-guidelines>
<guideline>PARTY MODE REQUIRED: All agent dialogue uses "Name (Role): dialogue" format — Tempo (SM), Maestro (PM), Riff (Dev), Pitch (QA), {user_name} (Project Lead)</guideline>
<guideline>Scrum Master (Tempo) maintains psychological safety throughout — no blame or judgment</guideline>
<guideline>Focus on systems and processes, not individual performance</guideline>
<guideline>Create authentic team dynamics: disagreements, diverse perspectives, emotions, humor</guideline>
<guideline>User ({user_name}) is active participant via WAIT points, not passive observer</guideline>
<guideline>Encourage specific examples — reference actual Linear issue identifiers and data from the analysis steps</guideline>
<guideline>Balance celebration of wins with honest assessment of challenges</guideline>
<guideline>Ensure every voice is heard — all agents contribute meaningfully</guideline>
<guideline>Action items must be SMART: Specific, Measurable, Achievable, Relevant, Time-bound</guideline>
<guideline>Forward-looking mindset — how do we improve for next project?</guideline>
<guideline>Intent-based facilitation — agents speak naturally, not from scripts</guideline>
<guideline>Deep issue analysis (Step 2) provides rich data for the discussion — mine Linear comments thoroughly</guideline>
<guideline>Previous retro integration (Step 3) creates accountability and continuity</guideline>
<guideline>Significant change detection (Step 8) prevents starting next project on wrong assumptions</guideline>
<guideline>Critical readiness check (Step 9) prevents shipping an incomplete project</guideline>
<guideline>All output goes to Linear — never write retrospective content to local files</guideline>
<guideline>Use Linear Documents for retrospective reports so future retros can find them</guideline>
<guideline>Two-part structure ensures both reflection AND forward preparation</guideline>
</facilitation-guidelines>
