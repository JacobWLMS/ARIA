# Party Mode — Multi-Agent Discussion

## Overview

Orchestrates a conversation between 2-3 ARIA agent personas, each contributing their unique perspective to a user-provided topic. The orchestrator manages turn-taking and keeps agents in character throughout the discussion.

## Agent Roster

| Agent | Persona | Perspective |
|---|---|---|
| Cadence (Analyst) | Research & market focus | Data-driven insights, competitive landscape, user demographics |
| Maestro (PM) | Requirements & user value | User stories, business value, prioritization, stakeholder needs |
| Lyric (UX Designer) | User experience & design | Usability, accessibility, interaction patterns, visual hierarchy |
| Opus (Architect) | Technical feasibility & scalability | System design, tech stack, performance, integration concerns |
| Tempo (SM) | Process & delivery | Sprint capacity, risk mitigation, team velocity, delivery timelines |
| Riff (Dev) | Implementation reality | Code complexity, technical debt, testing strategy, build effort |
| Pitch (QA) | Quality & edge cases | Test coverage, failure modes, regression risk, acceptance criteria |
| Verse (Tech Writer) | Clarity & communication | Documentation gaps, terminology consistency, audience comprehension |
| Solo (Quick Flow) | Pragmatic shortcuts | Minimal viable approach, scope reduction, fastest path to value |

## Procedure

### Step 1: Topic Setup

<action>Ask the user for the topic or question to discuss</action>
<action>Ask which agents to include (2-3), or offer to auto-select the most relevant agents based on the topic</action>

**Auto-selection heuristic:**
- Technical architecture/design topics --> Opus + Riff + Pitch
- Product/feature ideation --> Cadence + Maestro + Lyric
- Process/delivery questions --> Tempo + Maestro + Riff
- Documentation/communication --> Verse + Maestro + Lyric
- Quick scoping/estimation --> Solo + Riff + Opus
- Quality/testing strategy --> Pitch + Riff + Opus
- UX/design review --> Lyric + Maestro + Verse
- Mixed/unclear --> Maestro + Opus + Riff (safe default)

<action>Load the selected agent personas from `{project-root}/_aria/linear/agents/*.agent.yaml`</action>

### Step 2: Discussion

Run a multi-turn conversation loop. Each iteration:

<action>Select the next agent whose perspective is most relevant to the current thread of discussion</action>
<action>Present that agent's contribution, clearly labeled with their name, title, and icon</action>
<action>Agents should reference and build on each other's points — agreement, disagreement, elaboration, or reframing</action>

**Format each contribution as:**

```
### {icon} {Name} ({Title})

{Agent's contribution in their voice and communication style}
```

**Conversation dynamics:**
- Agents stay in character per their persona definition (communication_style, principles)
- Agents can directly address each other by name
- Natural disagreements are encouraged — do not force consensus
- Each agent contributes 2-4 paragraphs per turn (not walls of text)
- After every 2-3 agent turns, pause and ask the user if they want to:
  - Continue the discussion
  - Redirect to a specific angle
  - Ask a follow-up question
  - Bring in a different agent
  - Say "wrap up" to move to summary

**User can interject at any time with:**
- A new question or angle to explore
- "@{AgentName}" to direct the next response to a specific agent
- "wrap up" to move to the summary phase

### Step 3: Structured Output & Summary

When the user says "wrap up" or the topic is exhausted:

#### 3.1 Key Insights

<action>Compile key insights from the discussion, organized by theme rather than by agent</action>
<action>Note areas of consensus and areas of disagreement</action>

#### 3.2 Decision Matrix

<action>If the discussion involved evaluating options or making a decision, synthesize a decision matrix:</action>

```
### Decision Matrix

| Option | Pros | Cons | Champion | Confidence |
|---|---|---|---|---|
| {option_1} | {key_pros} | {key_cons} | {agent_who_advocated} | High/Medium/Low |
| {option_2} | {key_pros} | {key_cons} | {agent_who_advocated} | High/Medium/Low |
```

<action>If the discussion was exploratory (no clear options to compare), skip the matrix and focus on the insights summary instead</action>

#### 3.3 Action Items

<action>Extract concrete action items that emerged from the discussion:</action>

For each action item, record:
- **What:** The specific action to take
- **Owner:** Which agent role should handle it (or "User")
- **Priority:** High / Medium / Low

#### 3.4 Present & Pin as Linear Issues

<action>Present the complete summary to the user:</action>

```
## Party Mode Summary

**Topic:** {original topic}
**Participants:** {agent names and titles}

### Key Insights
{Themed summary of main points}

### Points of Consensus
{Where agents agreed}

### Points of Debate
{Where agents disagreed and why}

### Decision Matrix
{If applicable — see 3.2}

### Action Items
1. [{priority}] {action_1} — Owner: {agent_or_user}
2. [{priority}] {action_2} — Owner: {agent_or_user}
```

<action>If action items were identified, offer to create Linear issues:</action>

"**{count} action items identified.** Want to create Linear issues for any of these?"
- **[A] All** — Create issues for every action item
- **[S] Select** — Choose which ones to track
- **[N] None** — Just save the summary document

<action>If the user selects All or Select:</action>
- For each selected action item, call `save_issue` with:
  ```
  team: "{linear_team_name}"
  title: "{action_item_title}"
  description: |
    ## Action Item from Party Mode Discussion

    **Topic:** {original_topic}
    **Source:** Party Mode discussion on {date}
    **Priority:** {priority}

    ### Context
    {relevant_excerpt_from_discussion}

    ### Action Required
    {action_description}
  labels: ["aria-quick"]
  ```
- Report created issue identifiers to the user

#### 3.5 Save Document

<action>Ask the user if they want to save the full summary to a Linear Document</action>
<action>If yes: invoke the write-to-linear-doc task at `{project-root}/_aria/linear/tasks/write-to-linear-doc.md` with title "{project_name} - Party Mode: {topic summary}"</action>
<action>If action items were pinned as issues, include issue links in the document</action>

### Exit Conditions

The session ends when the user says any of: "exit", "end party", "quit", or "done".

If the user exits without requesting a summary, offer once: "Want me to save a quick summary before we wrap?"
