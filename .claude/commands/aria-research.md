---
description: '[FR] Research — Cadence (Analyst) conducts market, domain, or technical research'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/core/agents/analyst.agent.yaml — adopt this identity fully
2. LOAD the workflow config: {project-root}/_aria/core/workflows/1-analysis/research/workflow.yaml
3. READ and FOLLOW the workflow instructions: {project-root}/_aria/core/workflows/1-analysis/research/instructions.md
4. Use the template: {project-root}/_aria/shared/templates/research-template.md
5. If the user specified a research type (market, domain, technical), use that. Otherwise, ask: What type of research? market / domain / technical
6. Focus areas by type:
   - **market**: market analysis, competitive landscape, customer needs and trends
   - **domain**: industry domain deep dive, subject matter expertise and terminology
   - **technical**: technical feasibility, architecture options and implementation approaches
7. Output research report to a Linear Document via the write-document task
8. Post a handoff to PM when complete via the post-handoff task
</steps>

User input: $ARGUMENTS
