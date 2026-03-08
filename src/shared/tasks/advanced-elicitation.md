---
name: advanced-elicitation
description: 'Enhance content iteratively using diverse thinking techniques. Use at template-output checkpoints or standalone on existing documents.'
---

# Task: Advanced Elicitation

**Purpose:** Improve a section of content by applying structured thinking techniques. Can be invoked mid-workflow at template-output checkpoints, or standalone to refine an existing document section.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `content` | Yes | The content section to enhance (text block or document section) |
| `document_id` | No | If standalone: the document ID containing the section to enhance |
| `section_heading` | No | If standalone: the heading of the section to target in the document |

---

## Available Methods

The following thinking techniques can be applied to enhance content. Present 5 at a time, shuffled randomly:

| Method | Description |
|---|---|
| **First Principles** | Break down to fundamental truths, discard assumptions, rebuild from scratch |
| **Socratic Questioning** | Challenge every assumption through probing questions until the core is exposed |
| **SCAMPER** | Substitute, Combine, Adapt, Modify, Put to other use, Eliminate, Reverse |
| **Red Team vs Blue Team** | Attack the content (find flaws) then defend it (strengthen weak points) |
| **Pre-mortem** | Imagine this content led to failure -- work backward to identify why |
| **5 Whys** | Ask "why" repeatedly to dig past surface-level statements to root causes |
| **Reverse Engineering** | Start from the desired outcome and work backward to validate the path |
| **Devil's Advocate** | Argue the opposite position to stress-test every claim |
| **What-If Scenarios** | Explore edge cases, unlikely conditions, and alternative contexts |
| **Feynman Technique** | Explain the content simply enough for a newcomer -- gaps in understanding reveal gaps in the content |

---

## Execution

<workflow>

<step n="1" goal="Present the current content">

**If invoked with `document_id`:**
<action>Load the document using the tracking system's read task (e.g., `get_document` for Linear, `Get Page` for Confluence)</action>
<action>Extract the section under `{section_heading}` (or the full document body if no heading provided)</action>

**If invoked with `content` directly:**
<action>Use the provided content block as-is</action>

<action>Display the current content to the user with a clear header: "Here is the content we will enhance:"</action>
</step>

<step n="2" goal="Present method options">
<action>Randomly select 5 methods from the available methods list</action>
<action>Present them as a numbered menu:</action>

```
## Pick an Enhancement Method

1. **First Principles** -- Break down to fundamentals, rebuild from scratch
2. **Red Team vs Blue Team** -- Attack and defend the content
3. **5 Whys** -- Dig to root causes
4. **Feynman Technique** -- Explain simply to find gaps
5. **SCAMPER** -- Substitute, Combine, Adapt, Modify, Put to other use, Eliminate, Reverse

Type a number to select, or type "shuffle" for 5 different options.
```

<action>Wait for user selection</action>
<action>If user types "shuffle": select 5 different methods and re-present</action>
</step>

<step n="3" goal="Apply the selected method">

Apply the chosen technique to the content:

**First Principles:**
<action>List every assumption in the content. For each: is it a fundamental truth or a convention? Strip conventions and rebuild the content from only the truths.</action>

**Socratic Questioning:**
<action>Generate 5-8 probing questions about the content. Answer each question using only what the content provides. Where answers are weak or missing, strengthen the content.</action>

**SCAMPER:**
<action>Walk through each SCAMPER operation on the content: What could be Substituted? Combined? Adapted? Modified? Put to other use? Eliminated? Reversed? Apply the most valuable transformations.</action>

**Red Team vs Blue Team:**
<action>Red Team: Find 5+ weaknesses, gaps, or attack vectors in the content. Blue Team: For each weakness, propose a concrete fix. Apply all Blue Team fixes.</action>

**Pre-mortem:**
<action>Imagine this content was implemented and failed catastrophically. Write 3-5 plausible failure scenarios. For each: what in the current content allowed it? Strengthen those areas.</action>

**5 Whys:**
<action>For each major claim or decision in the content, ask "why?" 5 times. Where the chain breaks (no good answer), add the missing reasoning to the content.</action>

**Reverse Engineering:**
<action>State the desired outcome of this content. Work backward step by step. At each step, verify the content supports the transition. Fill gaps where it does not.</action>

**Devil's Advocate:**
<action>For each position taken in the content, argue the strongest possible counter-position. Where the counter-position is compelling, revise the content to address it.</action>

**What-If Scenarios:**
<action>Generate 5+ "what if" scenarios (edge cases, scale changes, role changes, timing changes). For each: does the content hold up? Revise where it does not.</action>

**Feynman Technique:**
<action>Rewrite the content as if explaining it to someone with no context. Where the simple explanation reveals gaps or hand-waving in the original, expand those areas in the enhanced version.</action>
</step>

<step n="4" goal="Present enhanced content and get user decision">
<action>Show the enhanced content with changes clearly visible</action>
<action>Briefly note what changed and why (2-3 sentences)</action>
<action>Ask the user:</action>

```
Options:
- "accept" -- Use this enhanced version
- "try another" -- Apply a different method to the original content
- "combine" -- Apply another method on top of this enhanced version
- "revert" -- Go back to the original content
```

<action>If "accept": proceed to step 5</action>
<action>If "try another": return to step 2 with the original content</action>
<action>If "combine": return to step 2 with the enhanced content as the new baseline</action>
<action>If "revert": return the original unmodified content to the calling process</action>
</step>

<step n="5" goal="Return or update">

**If invoked from a workflow (has calling process):**
<action>Return the enhanced content to the calling process for insertion into the template output</action>

**If standalone with `document_id`:**
<action>Load the document using the tracking system's read task to get the current full content</action>
<action>Replace the target section with the enhanced content</action>
<action>Update the document using the tracking system's write/update task</action>
<action>Confirm the update to the user</action>

**If standalone without a document:**
<action>Present the final enhanced content for the user to copy</action>
</step>

</workflow>

---

## Return Value

Returns the enhanced content string. The calling process can use this to replace the original section in its template output.
