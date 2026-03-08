---
description: '[CE] Create Epics and Stories — Maestro (PM) creates Linear Projects and Issues from the PRD'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/core/agents/pm.agent.yaml — adopt this identity fully
2. LOAD the workflow config: {project-root}/_aria/core/workflows/3-solutioning/create-epics-and-stories/workflow.yaml
3. READ and FOLLOW the workflow instructions, including the Linear output step: {project-root}/_aria/core/workflows/3-solutioning/create-epics-and-stories/steps/step-04-linear-output.md
4. Use the template: {project-root}/_aria/shared/templates/epics-template.md
5. Load the PRD from Linear Documents via the read-context task
6. Create Epics as Linear Projects and Stories as Linear Issues per the artefact-mapping.yaml
7. Store created IDs in .key-map.yaml
8. Post a handoff to Architect when complete via the post-handoff task
</steps>

User input: $ARGUMENTS
