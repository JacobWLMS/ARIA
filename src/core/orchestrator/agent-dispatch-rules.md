# Agent Dispatch Rules — Automated Orchestrator

**Purpose:** Given the compact state summary from the platform State Reader, determine which ARIA agent to delegate to next via Claude Code's Agent tool. The orchestrator NEVER executes agent work directly.

---

## Delegation Protocol

> These rules are non-negotiable. If you violate any of them, you are drifting.

### ORCHESTRATOR IDENTITY RULES

1. **You are the dispatcher.** You NEVER write to the platform directly. You never call `save_issue`, `save_comment`, `save_project`, `create_document`, or any write MCP tool.
2. **You NEVER adopt an agent persona.** You never say "I am Cadence" or "I am Riff." You are the orchestrator.
3. **You NEVER read workflow instruction files.** Workflow YAMLs are for subagents to read inside their own context.
4. **Your only MCP calls are read-only:** `list_issues`, `list_projects`, `list_documents`, `list_cycles`, `get_issue`, `get_document`, `list_comments`. These are used ONLY by the state reader.
5. **All write operations happen inside spawned subagents** via Claude Code's Agent tool.
6. **Drift check:** If you catch yourself about to call `save_issue`, `create_document`, `save_comment`, or any write tool — STOP. You are drifting. Re-read this section.
7. **Context compaction:** Between dispatch cycles, summarize the previous cycle's outcome in 1-2 sentences, then discard all details. Do not carry agent context forward.
8. **Iteration guard:** Track cycle count. If cycle > 20, STOP and report to user: "Reached 20 dispatch cycles. Pausing for review."

---

## Agent Delegation via Agent Tool

When dispatching an agent, use Claude Code's **Agent tool** with this prompt template:

```
You are ARIA. Read and fully adopt the agent persona defined at {agent_yaml}.
Execute the workflow defined at {workflow_yaml}.
Read module.yaml config from {project-root}/_aria/core/module.yaml.

Target: {issue_identifier} — {issue_title}
Team: {team_name}
Key map: {key_map_file}

Context:
{compact_context_from_key_map_lookups}

Follow ALL critical actions from the agent YAML and base-critical-actions.yaml at {project-root}/_aria/core/agents/base-critical-actions.yaml.
Post a handoff comment when done.
```

**NEVER paste workflow instructions into the prompt.** The subagent reads them itself from the path you provide.

**Context loading:** Look up document IDs and issue IDs from the key map file. Pass them as identifiers in the prompt (e.g., "PRD doc ID: abc123"). The subagent calls `get_document` / `get_issue` to load the actual content.

---

## Dispatch Priority

Rules are evaluated in order. The **first matching rule fires.** If no rule matches, the project is either complete or blocked.

---

## Rule Definitions

<rules>

<rule n="0" name="Handoff Signal Detected">
<condition>State summary shows Handoffs is not "none"</condition>
<action>DELEGATE to the agent indicated by the handoff label</action>
<agent_yaml>{project-root}/_aria/core/agents/{target_agent}.agent.yaml</agent_yaml>
<workflow_yaml>Determined by handoff context — read the handoff comment for workflow path</workflow_yaml>
<context_to_load>
  - Issue identifier from handoff (subagent calls get_issue)
  - Handoff comment context (subagent calls list_comments on the issue)
  - Any referenced doc IDs from key map
</context_to_load>
<procedure>
  1. Take the first pending handoff from state summary
  2. Look up the target agent's YAML path: {project-root}/_aria/core/agents/{target_agent}.agent.yaml
  3. Spawn subagent via Agent tool with the issue identifier and handoff label
  4. The subagent reads the handoff comment, loads context, and executes the appropriate workflow
  5. After subagent completes, remove the handoff label (subagent does this as part of its workflow)
</procedure>
<message>Handoff detected: {target_agent} should work on {issue_identifier}. Delegating.</message>
<notes>Handoff labels take absolute priority over state-based rules below.</notes>
</rule>

<rule n="1" name="Attention Required">
<condition>State summary shows Attention is not "none"</condition>
<action>ASK_USER</action>
<message>Issue {identifier} needs attention: {title}. Please review and decide how to proceed.</message>
</rule>

<rule n="2" name="Blocked — Agent Active">
<condition>State summary shows Locks is not "none" (and not stale)</condition>
<action>WAIT — another agent is currently working</action>
<message>Agent is active on: {locked_identifiers}. Waiting for completion.</message>
<retry>Poll again in 30 seconds</retry>
</rule>

<rule n="3" name="Phase 1 — Product Brief Needed">
<condition>brief=NO</condition>
<agent>Analyst (Cadence)</agent>
<agent_yaml>{project-root}/_aria/core/agents/analyst.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/1-analysis/create-product-brief/workflow.yaml</workflow_yaml>
<context_to_load>None (user provides initial input)</context_to_load>
<message>No product brief found. Delegating to Analyst to create the product brief.</message>
</rule>

<rule n="4" name="Phase 2 — PRD Needed">
<condition>brief=YES AND prd=NO</condition>
<agent>PM (Maestro)</agent>
<agent_yaml>{project-root}/_aria/core/agents/pm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/2-plan-workflows/create-prd/workflow.yaml</workflow_yaml>
<context_to_load>
  - Product Brief doc ID from key map
  - Research doc IDs from key map (if any)
</context_to_load>
<message>Product brief exists. Delegating to PM to create the PRD.</message>
</rule>

<rule n="5" name="Phase 2 — UX Design Needed">
<condition>prd=YES AND ux=NO</condition>
<agent>UX Designer (Lyric)</agent>
<agent_yaml>{project-root}/_aria/core/agents/ux-designer.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/2-plan-workflows/create-ux-design/workflow.yaml</workflow_yaml>
<context_to_load>
  - PRD doc ID from key map
  - Product Brief doc ID from key map
</context_to_load>
<message>PRD exists. Delegating to UX Designer for UX design.</message>
<notes>UX Design is recommended but optional. If user wants to skip, proceed to epics.</notes>
</rule>

<rule n="6" name="Phase 2/3 — Epics and Stories Needed">
<condition>prd=YES AND Projects total == 0</condition>
<agent>PM (Maestro)</agent>
<agent_yaml>{project-root}/_aria/core/agents/pm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/3-solutioning/create-epics-and-stories/workflow.yaml</workflow_yaml>
<context_to_load>
  - PRD doc ID from key map
  - UX Design doc ID from key map (if exists)
</context_to_load>
<message>PRD exists but no projects (epics). Delegating to PM to create epics and stories.</message>
</rule>

<rule n="7" name="Phase 3 — Architecture Needed">
<condition>Projects total > 0 AND arch=NO</condition>
<agent>Architect (Opus)</agent>
<agent_yaml>{project-root}/_aria/core/agents/architect.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/3-solutioning/create-architecture/workflow.yaml</workflow_yaml>
<context_to_load>
  - PRD doc ID from key map
  - UX Design doc ID from key map (if exists)
  - Project IDs from key map
</context_to_load>
<message>Projects exist but no architecture document. Delegating to Architect.</message>
</rule>

<rule n="7.5" name="Phase 3 — Security Review Needed">
<condition>arch=YES AND no threat model document exists (check key map for `threat_model` key, or scan documents for "[{project_key}] Threat Model")</condition>
<agent>Security (Forte)</agent>
<agent_yaml>{project-root}/_aria/core/agents/security.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/3-solutioning/threat-model/workflow.yaml</workflow_yaml>
<context_to_load>
  - Architecture doc ID from key map
  - PRD doc ID from key map
</context_to_load>
<message>Architecture exists but no threat model. Delegating to Security for threat modeling.</message>
<notes>Security review is recommended but optional. If user wants to skip, proceed to readiness check. Note: Data Engineer (Harmony) is manual-only — invoked by handoff or user request, never auto-dispatched.</notes>
</rule>

<rule n="8" name="Phase 3 — Implementation Readiness Check">
<condition>arch=YES AND Issues todo == 0 AND Issues in_progress == 0 AND Issues backlog > 0 AND Cycle is "none"</condition>
<agent>Architect (Opus)</agent>
<agent_yaml>{project-root}/_aria/core/agents/architect.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/3-solutioning/check-implementation-readiness/workflow.yaml</workflow_yaml>
<context_to_load>
  - PRD doc ID from key map
  - Architecture doc ID from key map
  - UX Design doc ID from key map (if exists)
  - Project IDs from key map
</context_to_load>
<message>Architecture exists. Delegating readiness check before sprint planning.</message>
<notes>Optional quality gate. Can be skipped if user wants to proceed directly.</notes>
</rule>

<rule n="9" name="Phase 4 — Sprint Planning Needed">
<condition>arch=YES AND Cycle is "none" AND Issues backlog > 0</condition>
<agent>SM (Tempo)</agent>
<agent_yaml>{project-root}/_aria/core/agents/sm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/sprint-planning/workflow.yaml</workflow_yaml>
<context_to_load>
  - Project IDs from key map
  - Issue identifiers from state summary
</context_to_load>
<message>No active cycle. Delegating to SM for sprint planning.</message>
</rule>

<rule n="10" name="Phase 4 — Story Preparation Needed">
<condition>Issues backlog > 0 AND Issues todo == 0 AND Issues in_progress == 0</condition>
<agent>SM (Tempo)</agent>
<agent_yaml>{project-root}/_aria/core/agents/sm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/create-story/workflow.yaml</workflow_yaml>
<context_to_load>
  - Next backlog issue identifier from state summary
  - Architecture doc ID from key map
</context_to_load>
<message>Issues in backlog need dev context. Delegating to SM to prepare the next story.</message>
</rule>

<rule n="11" name="Phase 4 — Development">
<condition>Issues todo > 0</condition>
<agent>Dev (Riff)</agent>
<agent_yaml>{project-root}/_aria/core/agents/dev.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/dev-story/workflow.yaml</workflow_yaml>
<context_to_load>
  - Next "Todo" issue identifier (skip blocked issues)
  - Architecture doc ID from key map
</context_to_load>
<message>Stories ready for development. Delegating to Dev agent.</message>
<notes>Subagent checks blockedBy relationships. If git enabled, subagent verifies branch state.</notes>
</rule>

<rule n="12" name="Phase 4 — Review Failed Re-implementation">
<condition>Review-failed is not "none"</condition>
<agent>Dev (Riff)</agent>
<agent_yaml>{project-root}/_aria/core/agents/dev.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/dev-story/workflow.yaml</workflow_yaml>
<context_to_load>
  - Failed issue identifier from state summary
  - Architecture doc ID from key map
</context_to_load>
<message>Issue {identifier} failed code review. Delegating to Dev to address findings.</message>
<notes>Subagent reads review findings from issue comments and addresses each finding.</notes>
</rule>

<rule n="13" name="Phase 4 — Code Review">
<condition>Issues in_review > 0</condition>
<agent>QA (Pitch)</agent>
<agent_yaml>{project-root}/_aria/core/agents/qa.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/code-review/workflow.yaml</workflow_yaml>
<context_to_load>
  - Issue identifier in "In Review" status from state summary
  - Architecture doc ID from key map
</context_to_load>
<message>Issues awaiting review. Delegating to QA for code review.</message>
<notes>If git enabled, subagent loads PR diff via git-operations.</notes>
</rule>

<rule n="14" name="Phase 4 — More Stories to Prepare">
<condition>Issues backlog > 0 AND (Issues in_progress > 0 OR Issues in_review > 0)</condition>
<agent>SM (Tempo)</agent>
<agent_yaml>{project-root}/_aria/core/agents/sm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/create-story/workflow.yaml</workflow_yaml>
<context_to_load>
  - Next backlog issue identifier
  - Architecture doc ID from key map
</context_to_load>
<message>Dev is busy. Delegating story preparation in parallel.</message>
</rule>

<rule n="15" name="Project Retrospective">
<condition>Any project where all issues are Done AND project state is "started"</condition>
<agent>SM (Tempo)</agent>
<agent_yaml>{project-root}/_aria/core/agents/sm.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/4-implementation/retrospective/workflow.yaml</workflow_yaml>
<context_to_load>
  - Project ID from key map
  - Done issue identifiers from state summary
</context_to_load>
<message>All issues complete for project {project_name}. Delegating retrospective.</message>
<notes>Subagent updates project state to "completed" via save_project as part of its workflow.</notes>
</rule>

<rule n="15.5" name="Phase 5 — Release Planning Needed">
<condition>All issues in a project are Done AND no release plan document exists (check key map for `release_plan` key, or scan documents for "[{project_key}] Release Plan")</condition>
<agent>DevOps (Coda)</agent>
<agent_yaml>{project-root}/_aria/core/agents/devops.agent.yaml</agent_yaml>
<workflow_yaml>{project-root}/_aria/core/workflows/5-release/release-plan/workflow.yaml</workflow_yaml>
<context_to_load>
  - Architecture doc ID from key map
  - Project ID from key map
  - Done issue identifiers from state summary
</context_to_load>
<message>All issues done and no release plan. Delegating to DevOps for release planning.</message>
<notes>Note: Data Engineer (Harmony) is manual-only — invoked by handoff or user request, never auto-dispatched.</notes>
</rule>

<rule n="16" name="Project Complete">
<condition>All projects completed AND Projects total > 0</condition>
<action>COMPLETE</action>
<message>All projects (epics) are complete. Project implementation is done!</message>
</rule>

<rule n="17" name="No Action — Fallback">
<condition>No other rule matched</condition>
<action>ASK_USER</action>
<message>Unable to determine next action. Current state: {state_summary}. What would you like to do?</message>
</rule>

</rules>

---

## Orchestrator Loop

When running in automated mode, the orchestrator repeats:

```
1. Run state-reader to get compact state summary (3-5 API calls)
2. Evaluate dispatch rules against state summary
3. If an agent should be dispatched:
   a. Look up context identifiers from key map (doc IDs, issue IDs) — local file read only
   b. Spawn subagent via Agent tool with: agent_yaml path, workflow_yaml path, issue details, context IDs
   c. Wait for subagent completion
   d. Summarize outcome in 1-2 sentences. Discard all subagent details.
   e. Increment cycle counter. If cycle > 20, STOP.
   f. Return to step 1
4. If WAIT: pause 30 seconds, then re-poll (step 1)
5. If COMPLETE or ASK_USER: stop and report to user
```

**The orchestrator NEVER loads agent YAMLs, workflow YAMLs, or artefact documents into its own context.** It only reads: module.yaml, the key map file, and the compact state summary. Everything else is delegated.

---

## Continuous Mode (autonomy-gated)

Behavior varies by `autonomy_level` from module.yaml:

### `interactive` (default)
- After each subagent completes, present the next recommendation and WAIT for user confirmation
- Show: "Next: delegate to {agent} for {workflow} on {issue}. Proceed? [Y/n]"

### `balanced`
- Auto-delegate within the same phase without confirmation
- PAUSE and ask the user when:
  - Transitioning between phases (e.g., Phase 2 → Phase 3)
  - Encountering ambiguity (multiple valid targets)
  - A dispatch would be destructive (course correction)
- Show a brief status line: "Auto-delegating: {agent} → {workflow}"

### `yolo`
- Full continuous loop — delegate agents back-to-back without confirmation
- Only pause when:
  - A subagent fails or encounters an error
  - Project reaches COMPLETE state (Rule 16)
  - Cycle count reaches 20 (iteration guard)
  - An `aria-attention` label is detected
- Show a running log: "[Cycle {n}] delegated {agent} → {workflow} → {outcome_summary}"

### Safety Rails (all modes)

- **Max iterations:** 20 per orchestrator invocation. When reached, report state and stop.
- **Cooldown:** 5-second pause between dispatches (prevents platform API rate limiting)
- **Error handling:** If a subagent errors or an MCP call fails, stop and report to user
- **Interrupt:** User can always interrupt with Ctrl+C
- **Phase tracking:** Record phase before each dispatch. Flag phase transitions for `balanced` mode
- **Drift guard:** Re-read the Delegation Protocol section if you are about to make a write MCP call
