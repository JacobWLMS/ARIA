---
name: editorial-review-prose
description: 'Review document prose for clarity, tone, and communication effectiveness. Posts findings as Linear issue comment.'
---

# Task: Editorial Review -- Prose

**Purpose:** Review a Linear document for prose quality -- clarity, conciseness, tone, and communication effectiveness. Posts a structured table of suggestions as a comment on the associated issue. Does NOT modify the document directly; preserves the author's voice while improving readability.

---

## Parameters

| Parameter | Required | Description |
|---|---|---|
| `target` | Yes | Linear document ID or slug |
| `issue_id` | No | Linear issue ID to post findings on (if not provided, output to console) |

---

## Execution

<workflow>

<step n="1" goal="Load the Linear document content">
<action>Call `get_document` with `id: "{target}"` to load the full document content</action>
<action>Record the document content, ID, and title</action>
<action>If the document content contains embedded images (markdown image syntax or Linear-hosted URLs), call `extract_images` with the document content to view diagrams and screenshots. Include visual context in the review -- images may contain text, labels, or flow descriptions that affect prose quality assessment.</action>
</step>

<step n="2" goal="Review prose across all quality dimensions">

Read the entire document and evaluate each paragraph and sentence against these dimensions:

| Dimension | What to look for |
|---|---|
| **Clarity** | Ambiguous phrasing, unclear referents, sentences requiring re-reading, vague quantifiers ("some," "many," "various") |
| **Conciseness** | Wordy constructions, filler phrases ("in order to," "it should be noted that"), redundant modifiers, sentences that can be halved without losing meaning |
| **Tone Consistency** | Shifts between formal/informal, inconsistent voice (first person vs. third person), jarring register changes |
| **Jargon & Acronyms** | Undefined acronyms on first use, unnecessary jargon where plain language works, inconsistent terminology for the same concept |
| **Readability** | Overly long sentences (30+ words), deeply nested clauses, paragraph walls without breaks, missing transition phrases |
| **Passive Voice** | Unnecessary passive constructions that obscure responsibility or weaken statements |
| **Redundancy** | Points made more than once across sections, repetitive phrasing, circular statements |

For each issue found, record:
- **Location:** Section heading or paragraph identifier (e.g., "Section 3, paragraph 2" or quote the first few words)
- **Issue:** Which dimension is violated and a brief explanation
- **Suggested Fix:** A concrete rewrite or recommendation -- improving the text while preserving the author's voice and intent
</step>

<step n="3" goal="Generate findings table">

Format all findings as a three-column markdown table:

```
## Editorial Review -- Prose

**Document:** {document_title}
**Reviewed:** {timestamp}
**Total Suggestions:** {count}

| Location | Issue | Suggested Fix |
|---|---|---|
| {section/paragraph} | {dimension}: {explanation} | {concrete suggestion} |
| ... | ... | ... |

---

**Overall Assessment:**
{2-3 sentence summary of the document's prose quality, noting strengths as well as patterns to address}

**Key Patterns:**
- {recurring issue 1}
- {recurring issue 2}
```

Order by document flow (top to bottom), not by severity.
</step>

<step n="4" goal="Post findings">

**If `issue_id` is provided:**
<action>Call `save_comment` with `issueId: "{issue_id}"` and `body: "{formatted_findings_table}"`</action>

**If no `issue_id`:**
<action>Print the formatted findings to the console output</action>

<action>Do NOT call `update_document` -- this task produces suggestions only, never modifies the document content</action>
</step>

</workflow>

---

## Return Value

Returns the document ID and the count of suggestions posted. The author reviews the findings and applies fixes at their discretion.
