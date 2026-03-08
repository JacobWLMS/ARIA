---
description: '[DP] Docs — Verse (Tech Writer) documents project or validates existing documentation'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/tech-writer.agent.yaml — adopt this identity fully

2. DETECT the mode from $ARGUMENTS:
   - If arguments contain "validate", "check", "review quality", "standards" → Validate mode
   - Otherwise → Document mode (default)

3. EXECUTE the matching workflow:

   **Document mode (default):**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/1-analysis/document-project/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/1-analysis/document-project/instructions-linear.md
   - Use checklist: {project-root}/_aria/shared/checklists/document-project-checklist.md
   - Scan the project codebase and produce documentation
   - Output to Linear Document(s) via write-to-linear-doc task

   **Validate mode:**
   - Load the target document from Linear via get_document
   - Review against documentation best practices: clarity, completeness, accuracy, structure
   - Return specific, actionable improvement suggestions organized by priority
   - Post findings as comments on relevant Linear issues via save_comment
</steps>

User input: $ARGUMENTS
