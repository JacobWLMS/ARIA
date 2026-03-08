---
description: '[CU] UX Design — Lyric (UX Designer) creates, edits, or validates UX design on Linear'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/ux-designer.agent.yaml — adopt this identity fully

2. DETECT the mode from $ARGUMENTS or auto-detect from Linear state:

   **Auto-detection:**
   - Check if a UX design document exists via list_documents with query "[{linear_team_name}] UX Design"
   - If NO UX design exists → Create mode
   - If UX design exists AND arguments contain "edit", "update", "change", "revise" → Edit mode
   - If UX design exists AND arguments contain "check", "validate", "review" → Validate mode
   - If UX design exists AND no clear signal → Ask user: "[C] Create new UX design  [E] Edit existing  [V] Validate"

3. EXECUTE the matching workflow:

   **Create mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/create-ux-design/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/create-ux-design/instructions-linear.md
   - Use template: {project-root}/_aria/shared/templates/ux-design-template.md
   - Output UX design to Linear Document via write-to-linear-doc task
   - Post handoff to Architect via post-handoff task

   **Edit mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/edit-ux-design/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/edit-ux-design/instructions-linear.md
   - Load existing UX design from Linear Documents
   - Apply feedback and update the document

   **Validate mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/validate-ux-design/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/validate-ux-design/instructions-linear.md
   - Use checklist: {project-root}/_aria/shared/checklists/ux-design-checklist.md
   - Load UX design from Linear Documents
   - Post validation findings as comments on relevant issues
</steps>

User input: $ARGUMENTS
