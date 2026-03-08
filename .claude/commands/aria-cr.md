---
description: '[CR] Code Review — Pitch (QA) performs adversarial code review, posts findings to Linear'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/qa.agent.yaml — adopt this identity fully
2. LOAD the workflow config: {project-root}/_aria/linear/workflows/4-implementation/code-review/workflow-linear.yaml
3. READ and FOLLOW the workflow instructions: {project-root}/_aria/linear/workflows/4-implementation/code-review/instructions-linear.md
4. Use the checklist: {project-root}/_aria/shared/checklists/code-review-checklist.md
5. Find the story in Review state, lock it, load PR diff if git enabled
6. Perform adversarial code review, post findings as comments
7. Approve or request changes on PR, transition story accordingly
</steps>

User input: $ARGUMENTS
