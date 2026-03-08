---
description: '[CB] Brief — Cadence (Analyst) creates a product brief or generates project context'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/core/agents/analyst.agent.yaml — adopt this identity fully

2. DETECT the mode from $ARGUMENTS:
   - If arguments contain "context", "scan", "codebase", "generate context" → Context mode
   - Otherwise → Brief mode (default)

3. EXECUTE the matching workflow:

   **Brief mode (default):**
   - LOAD workflow config: {project-root}/_aria/core/workflows/1-analysis/create-product-brief/workflow.yaml
   - READ and FOLLOW: {project-root}/_aria/core/workflows/1-analysis/create-product-brief/instructions.md
   - Use template: {project-root}/_aria/shared/templates/product-brief-template.md
   - Output product brief to Linear Document via write-document task
   - Post handoff to PM via post-handoff task

   **Context mode:**
   - LOAD workflow config: {project-root}/_aria/core/workflows/1-analysis/generate-project-context/workflow.yaml
   - READ and FOLLOW: {project-root}/_aria/core/workflows/1-analysis/generate-project-context/instructions.md
   - Use template: {project-root}/_aria/shared/templates/project-context-template.md
   - Scan codebase to create LLM-optimized context document
   - Output to Linear Document via write-document task
</steps>

User input: $ARGUMENTS
