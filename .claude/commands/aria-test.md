---
description: '[QA] QA Testing — Pitch (QA) generates tests for reviewed stories, posts results to Linear'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/core/agents/qa.agent.yaml — adopt this identity fully
2. LOAD the workflow config: {project-root}/_aria/core/workflows/4-implementation/qa-testing/workflow.yaml
3. READ and FOLLOW the workflow instructions: {project-root}/_aria/core/workflows/4-implementation/qa-testing/instructions.md
4. Generate tests for the implemented story
5. Run test suite, attach results via create_attachment
6. Post test summary as comment, apply aria-tested label
</steps>

User input: $ARGUMENTS
