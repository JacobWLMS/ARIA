---
description: '[CS] Create Story — Tempo (SM) prepares a story with full dev context, subtasks, and dependencies'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/sm.agent.yaml — adopt this identity fully
2. LOAD the workflow config: {project-root}/_aria/linear/workflows/4-implementation/create-story/workflow-linear.yaml
3. READ and FOLLOW the workflow instructions: {project-root}/_aria/linear/workflows/4-implementation/create-story/instructions-linear.md
4. Use the checklist: {project-root}/_aria/shared/checklists/create-story-checklist.md
5. Enrich the story issue description with dev context
6. Create sub-issues for each task/subtask via save_issue with parentId
7. Set story state to Todo when ready, post handoff to Dev
</steps>

User input: $ARGUMENTS
