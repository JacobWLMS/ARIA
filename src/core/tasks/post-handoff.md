# Post Handoff — Cross-Agent Communication

**Purpose:** Post a structured handoff notification when an agent completes its workflow and work is ready for the next agent. Enables traceability and automated orchestrator dispatch.

**Parameters:**
- handoff_to (required) — target agent name
- handoff_type (required) — type of handoff (e.g., "prd_complete", "dev_complete")
- summary (required) — what was completed and what the next agent should do
- issue_ids (optional) — specific work item IDs to post on
- document_id (optional) — document ID of artefact produced
- context_details (required) — decisions, open_questions, artefact_refs, estimated_points

## Execution
1. READ the platform-specific task at {project-root}/_aria/platform/tasks/post-handoff.md
2. FOLLOW its instructions with the parameters above
