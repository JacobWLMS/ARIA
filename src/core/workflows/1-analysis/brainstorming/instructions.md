# Brainstorming — Document Output

<critical>You MUST have already loaded and processed: the workflow.yaml for this workflow</critical>

## Overview

Facilitates a comprehensive interactive brainstorming session using a library of 62 creative techniques across 11 categories. The session targets 50-100+ ideas through structured facilitation, anti-bias protocols, and interactive coaching. Output is written to a document.

**Technique Library:** `{project-root}/_aria/shared/data/brain-methods.csv` — 62 techniques across 11 categories.

**Output Template:** `{project-root}/_aria/shared/templates/brainstorming-template.md`

---

<workflow>

<step n="1" goal="Session setup, continuation detection, and topic discovery">
<action>Communicate in {communication_language} with {user_name}</action>

<action>Greet the user and begin session setup:</action>

"Welcome {user_name}! I'm excited to facilitate your brainstorming session. I'll guide you through proven creativity techniques to generate innovative ideas and breakthrough solutions.

**What topic, problem, or product idea would you like to brainstorm about?**"

<action>Check the platform for existing brainstorming documents:</action>

Invoke the `read-context` task from `{project-root}/_aria/core/tasks/read-context.md` with `context_type: "document_artefact"` and `query: "Brainstorming"` to search for existing brainstorming session documents.

- If existing session(s) found, present the most recent and ask:
  "[1] Continue this session — I'll load existing ideas and pick up where we left off"
  "[2] Start fresh — New session on the same topic"
- If user selects [1], load the existing document content via the `read-context` task and resume from the appropriate step
- If user selects [2] or no existing sessions found, proceed with fresh setup

<action>Clarify the session scope with the user:</action>

1. **Core Topic**: What exactly are we brainstorming about?
2. **Constraints**: Are there any constraints, boundaries, or requirements to keep in mind?
3. **Goals**: What do you hope to achieve — new product ideas, solutions to a problem, feature exploration, something else?
4. **Domains**: Are there specific domains, industries, or perspectives you want to explore?
5. **Time Available**: How much time do you want to invest in this session?

<action>Set `topic`, `constraints`, `goals`, and `domains` from the discussion</action>
<action>Confirm the brainstorming scope with the user and set a target of generating 50-100+ ideas</action>

<autonomy>
In `yolo` mode: After the user states their topic, skip the confirmation of scope. Infer constraints, goals, and domains from context and proceed directly to technique selection.
</autonomy>
</step>

<step n="2" goal="Technique selection — choose how to pick brainstorming methods">
<action>Present the four technique selection approaches:</action>

"**Session setup complete! Now let's choose how to select our brainstorming techniques.**

**[A] User-Selected Techniques** — Browse our library of 62 techniques across 11 categories. You pick what appeals to you.

**[B] AI-Recommended Techniques** — I'll analyze your topic, goals, and constraints to recommend optimal techniques tailored to your session.

**[C] Random Selection** — Serendipitous discovery. I'll randomly select 3-5 techniques from different categories.

**[D] Progressive Flow** — A systematic 4-phase creative journey:
  1. Expansive Exploration (divergent thinking)
  2. Pattern Recognition (analytical thinking)
  3. Idea Development (convergent thinking)
  4. Action Planning (implementation focus)

Which approach appeals to you? (Enter A-D)"

<autonomy>
In `yolo` or `balanced` mode: Auto-select approach B (AI-Recommended) and proceed directly.
</autonomy>

<action>Load the technique library from `{project-root}/_aria/shared/data/brain-methods.csv`</action>
<action>Execute the selected approach (A/B/C/D) following the same technique selection process as the shared brainstorming workflow</action>
<action>Once techniques are confirmed, record the selected techniques and proceed to Step 3</action>
</step>

<step n="3" goal="Interactive technique execution — generate 50-100+ ideas">

### Facilitation Principles (apply throughout ALL technique execution)

**Anti-Bias Domain Pivot Protocol:** Every 10 ideas, consciously pivot to an orthogonal domain.

**Quantity Before Organization:** Aim for 100+ ideas before suggesting organization. Default is KEEP EXPLORING.

**Interactive Coaching, Not Script Delivery:** Build on user ideas. Ask follow-ups. The user is a creative partner.

**Simulated High Creativity:** Take wilder leaps. Push past safe, conventional ideas.

<action>Execute each technique through interactive dialogue, generating ideas in batches of 10-15</action>
<action>After each batch: present numbered ideas, ask user to star favorites, suggest new angles</action>
<action>Energy checkpoint after every 4-5 exchanges</action>
<action>Continue until at least 50 ideas have been produced or user is satisfied</action>
</step>

<step n="4" goal="Deep exploration of starred favorites">
<action>Take the user's starred favorites and explore further with variations, cross-pollinations, ambitious/minimal/weird versions</action>
<action>Generate 20-30 additional ideas based on favorites</action>
<action>Ask the user to flag any new favorites from this round</action>
</step>

<step n="5" goal="Convergence — organize and select the best ideas">
<action>Organize ALL generated ideas by theme or category</action>
<action>Present categorized list with top picks per category</action>
<action>Present summary: total ideas, categories, top 5-10 recommendations</action>
<action>Ask user to select ideas to carry forward</action>
</step>

<step n="6" goal="Save brainstorming session to document">
<action>Compile the brainstorming session document in {document_output_language} using the template at `{project-root}/_aria/shared/templates/brainstorming-template.md`</action>

The content MUST include:
1. **Session Context** — topic, constraints, goals, domains explored
2. **Selected Ideas** — the user's chosen ideas clearly marked with descriptions
3. **All Ideas by Theme** — every idea generated, organized by category, with favorites highlighted
4. **Technique Log** — which techniques were used and how many ideas each produced
5. **Top Recommendations** — the top 5-10 ideas with rationale

<action>Invoke the `write-document` task with:</action>

```
title: "[{team_name}] Brainstorming: {topic}"
content: "{compiled_brainstorming_content}"
key_map_entry: "documents.brainstorming"
```

<action>Update `{key_map_file}` with the new document ID under `documents.brainstorming`</action>
</step>

<step n="7" goal="Handoff and next steps">
<action>Invoke the `post-handoff` task with:</action>

```
handoff_to: "PM"
handoff_type: "brainstorming_complete"
summary: "Brainstorming session complete. {idea_count} ideas generated, {selected_count} selected to carry forward. Published to document."
document_id: "{brainstorming_doc_id}"
```

<action>Report to user:</action>

"**Brainstorming Session Complete**

- **Topic:** {topic}
- **Ideas Generated:** {idea_count}
- **Ideas Selected:** {selected_count}
- **Techniques Used:** {technique_list}
- **document:** {document_title}
- **Handoff:** PM agent notified

**Recommended Next Step:**
Create a product brief to formalize the best ideas: run `/aria-brief`"

<action>Invoke the help task at {project-root}/_aria/core/tasks/help.md</action>
</step>

</workflow>
