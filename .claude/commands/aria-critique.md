---
description: '[RV] Critique — adversarial, edge case, prose, or structure review. Posts findings to Linear.'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/tech-writer.agent.yaml — adopt this identity fully
2. DETECT the review type from $ARGUMENTS or ask the user:

   **Review Types:**
   - **[A] Adversarial** — cynical review looking for flaws, gaps, and weaknesses
   - **[E] Edge Cases** — find unhandled edge cases, boundary conditions, failure scenarios
   - **[P] Prose** — review writing quality, clarity, tone, and readability
   - **[S] Structure** — review organization, logical flow, section structure

   **Auto-detection from arguments:**
   - "adversarial", "attack", "flaws", "weaknesses" → Adversarial
   - "edge", "boundary", "failure", "corner case" → Edge Cases
   - "prose", "clarity", "tone", "writing", "readability" → Prose
   - "structure", "organization", "flow", "sections" → Structure

3. INVOKE the matching task:
   - Adversarial → {project-root}/_aria/linear/tasks/review-adversarial.md
   - Edge Cases → {project-root}/_aria/linear/tasks/review-edge-cases.md
   - Prose → {project-root}/_aria/linear/tasks/editorial-review-prose.md
   - Structure → {project-root}/_aria/linear/tasks/editorial-review-structure.md

4. Load the target document or issue from Linear
5. Perform the review and post findings as comments on relevant Linear issues via save_comment
</steps>

User input: $ARGUMENTS
