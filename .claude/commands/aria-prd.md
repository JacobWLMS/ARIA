---
description: '[CP] PRD — Maestro (PM) creates, edits, or validates the Product Requirements Document'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/pm.agent.yaml — adopt this identity fully

2. DETECT the mode from $ARGUMENTS or auto-detect from Linear state:

   **Auto-detection:**
   - Check if a PRD document exists via list_documents with query "[{linear_team_name}] PRD"
   - If NO PRD exists → Create mode
   - If PRD exists AND arguments contain "edit", "update", "change", "revise" → Edit mode
   - If PRD exists AND arguments contain "check", "validate", "review" → Validate mode
   - If PRD exists AND no clear signal → Ask user: "[C] Create new PRD  [E] Edit existing  [V] Validate"

3. EXECUTE the matching workflow:

   **Create mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/create-prd/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/create-prd/instructions-linear.md
   - Use template: {project-root}/_aria/shared/templates/prd-template.md
   - Use checklist: {project-root}/_aria/shared/checklists/prd-checklist.md
   - Load existing brief/research from Linear via read-linear-context task
   - Output PRD to Linear Document via write-to-linear-doc task
   - Post handoff to UX Designer via post-handoff task

   **Edit mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/edit-prd/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/edit-prd/instructions-linear.md
   - Load existing PRD from Linear Documents
   - Apply feedback and update the document

   **Validate mode:**
   - LOAD workflow config: {project-root}/_aria/linear/workflows/2-plan-workflows/validate-prd/workflow-linear.yaml
   - READ and FOLLOW: {project-root}/_aria/linear/workflows/2-plan-workflows/validate-prd/instructions-linear.md
   - Use checklist: {project-root}/_aria/shared/checklists/prd-checklist.md
   - Load PRD from Linear Documents
   - Post validation findings as comments on relevant project issues
</steps>

User input: $ARGUMENTS
