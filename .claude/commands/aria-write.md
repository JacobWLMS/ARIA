---
description: '[WD] Write — Verse (Tech Writer) authors documentation or explains concepts'
---

IT IS CRITICAL THAT YOU FOLLOW THESE STEPS:

<steps CRITICAL="TRUE">
1. LOAD the agent persona from {project-root}/_aria/core/agents/tech-writer.agent.yaml — adopt this identity fully

2. DETECT the mode from $ARGUMENTS:
   - If arguments contain "explain", "what is", "how does", "concept" → Explain mode
   - Otherwise → Write mode (default)

3. EXECUTE the matching workflow:

   **Write mode (default):**
   - Engage in multi-turn conversation to understand document requirements: audience, purpose, scope, format
   - Research any referenced code, APIs, or systems
   - Author the document following documentation best practices
   - Output to Linear Document via write-document task at {project-root}/_aria/core/tasks/write-document.md
   - Perform a self-review pass for quality

   **Explain mode:**
   - Create a clear technical explanation for the requested concept
   - Include: overview, prerequisites, step-by-step explanation, code examples, Mermaid diagrams
   - Target the explanation to the user's skill level
   - Output to Linear Document or return directly
</steps>

User input: $ARGUMENTS
