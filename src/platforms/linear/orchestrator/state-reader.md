# Linear State Reader — Compact State Polling

**Purpose:** Poll Linear state in minimal API calls. Returns a compact text summary for the orchestrator dispatch rules.

---

## When to Run

- At the start of every orchestrator cycle
- When a user asks "what's next?" or "show project status"
- After a subagent completes (to determine the next dispatch)

---

## Internal State Model

> This model is internal. The orchestrator receives the **compact text summary** below, not this YAML structure.

```yaml
project_state:
  team_name: str
  artefacts:    { brief: bool, research: bool, prd: bool, ux: bool, arch: bool, readiness: bool }
  projects:     { total: int, by_state: { planned: int, started: int, completed: int } }
  issues:       { total: int, by_status: { backlog: int, todo: int, in_progress: int, in_review: int, done: int } }
  handoffs:     [{ identifier: str, target_agent: str }]
  locks:        [{ identifier: str, title: str }]
  attention:    [{ identifier: str, title: str }]
  review_failed: [str]
  active_cycle: { exists: bool, name: str, issue_count: int }
  git:          { enabled: bool, branch: str, clean: bool, open_prs: int }
```

---

## Polling Sequence (5 calls max)

<workflow>

<step n="1" goal="Read key map (local, no API call)">
<action>Read `{key_map_file}` from disk</action>
<action>Extract the `documents` section to determine which artefacts exist</action>
<action>Map document entries to artefact flags:</action>

| Key map key | Artefact flag |
|---|---|
| `product_brief` | brief |
| `research` | research |
| `prd` | prd |
| `ux_design` | ux |
| `architecture` | arch |
| `readiness_report` | readiness |

<action>If the key map has entries for all 6 artefact types, skip step 2 entirely</action>
<action>If the key map file is missing or empty, all artefact flags default to NO — step 2 will discover them</action>
</step>

<step n="2" goal="Check artefact existence (1 API call, only if key map incomplete)">
<action>Call `list_documents` ONCE — no query filter needed, just fetch team documents</action>
<action>Scan the returned document list for title prefixes matching `[{project_key}]`:</action>

```
"[{project_key}] Product Brief"     → brief
"[{project_key}] Research"          → research
"[{project_key}] PRD"              → prd
"[{project_key}] UX Design"        → ux
"[{project_key}] Architecture"     → arch
"[{project_key}] Readiness"        → readiness
```

<action>Set artefact flags based on matches. Update key map file with any newly discovered doc IDs</action>
</step>

<step n="3" goal="Query projects (1 API call)">
<action>Call `list_projects` with `team: "{linear_team_name}"` and `limit: 50`</action>
<action>Do NOT pass `includeMilestones: true` — it triggers API complexity errors</action>
<action>Count projects by state: planned, started, completed</action>
</step>

<step n="4" goal="Query all issues and scan in-memory (1 API call)">
<action>Call `list_issues` with `team: "{linear_team_name}"` and `limit: 250`</action>
<action>If pagination cursor is returned, make one additional call (rare for most projects)</action>

<action>Scan the SINGLE result set in-memory for ALL of the following:</action>

**Status counts** — map Linear state names to ARIA statuses:

| Linear State | ARIA Status |
|---|---|
| Backlog | backlog |
| Todo | todo |
| In Progress | in_progress |
| In Review | in_review |
| Done | done |

**Handoff labels** — any label matching `aria-handoff-*`. Extract the target agent name from the label suffix (e.g., `aria-handoff-dev` → target agent is `dev`). Record issue identifier and target agent.

**Lock labels** — any issue with the `aria-active` label. Check `updatedAt` — if older than 1 hour, flag as stale.

**Attention labels** — any issue with the `aria-attention` label. Record identifier and title.

**Review-failed labels** — any issue with the `aria-review-failed` label. Record identifiers.

<action>All label scanning happens on the already-fetched issue data — NO additional API calls</action>
</step>

<step n="5" goal="Check active cycle (1 API call)">
<action>Call `list_cycles` with `teamId: "{linear_team_id}"` and `type: "current"`</action>
<action>If a cycle exists, count how many issues from step 4 belong to it (match by cycle ID in issue data)</action>
<action>Record cycle name and issue count</action>
</step>

<step n="6" goal="Check git state (local commands only, if enabled)">
<action>Read `git_enabled` from module.yaml. If not `true`, set git.enabled = false and skip</action>

<action>If git is enabled, run local commands only:</action>
1. `git branch --show-current` → branch name
2. `git status --porcelain` → clean if empty
3. `gh pr list --json number --state open 2>/dev/null | jq length` → open PR count (0 if gh unavailable)
</step>

</workflow>

---

## Output Format

Return this compact text summary to the orchestrator. Do NOT return the full YAML state model.

```
STATE SUMMARY:
  Artefacts: brief=YES prd=YES ux=NO arch=NO research=NO readiness=NO
  Projects: {total} ({started} started, {planned} planned, {completed} completed)
  Issues: {total} ({done} done, {in_review} review, {in_progress} in-progress, {todo} todo, {backlog} backlog)
  Handoffs: {label} on {identifier} [or "none"]
  Locks: {identifier} [or "none"] [append "(STALE)" if stale]
  Attention: {identifier} — {title} [or "none"]
  Review-failed: {identifiers} [or "none"]
  Cycle: {cycle_name} ({issue_count} issues) [or "none"]
  Git: {branch}, {clean|dirty}, {n} open PR(s) [or "disabled"]

RECOMMENDED DISPATCH: evaluate against agent-dispatch-rules.md
```

**API call budget:** 3-5 calls per cycle (key map read is local, git checks are local).
