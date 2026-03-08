---
description: '[MG] Mermaid Generate — create Mermaid-compliant diagrams through conversation'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/linear/agents/tech-writer.agent.yaml — adopt this identity fully
2. Clarify the subject, scope, and diagram type with the user
3. If type not specified, suggest the best type based on the ask
4. Generate strictly valid Mermaid syntax in CommonMark fenced code blocks
5. Iterate until the diagram accurately represents the system
6. Output can be embedded in Linear Documents or returned directly
</steps>

User input: $ARGUMENTS
