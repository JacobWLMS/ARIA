# Supported AI Tools

ARIA's agents, workflows, and templates are tool-agnostic. The installer generates the appropriate config for your AI coding tool.

## Compatibility

| Tool | Support | Config Location | How to Trigger |
|---|---|---|---|
| **Claude Code** | Full | `.claude/commands/` + `CLAUDE.md` | Type `/aria-` and autocomplete |
| **Cursor** | Core | `.cursor/rules/aria.mdc` | "Run the brainstorm workflow" |
| **Windsurf** | Core | `.windsurf/rules/aria.md` | "Run the brainstorm workflow" |
| **Cline / Roo Code** | Core | `.clinerules/aria.md` | "Run the brainstorm workflow" |
| **Other** | Manual | `_aria/` directory | Reference workflow index manually |

**Full** = all 38 slash commands, automated orchestrator with subagent spawning. **Core** = all individual agent workflows work; no orchestrator (tell the agent which workflow to run).

## Installing for Your Tool

```bash
./install.sh --tool claude-code    # default
./install.sh --tool cursor
./install.sh --tool windsurf
./install.sh --tool cline
./install.sh --tool all            # install config for every tool
```

Or use the AI agent install — paste this into any tool:

> Read the instructions at https://raw.githubusercontent.com/JacobWLMS/ARIA/main/agent-install.md and follow them to install ARIA into this project.

## Claude Code (Full Support)

Claude Code gets the richest experience:

- **38 slash commands** -- type `/aria-` and use autocomplete
- **Automated orchestrator** -- `/aria-go` dispatches agents autonomously via Claude Code's Agent tool
- **CLAUDE.md** -- project-level instructions loaded automatically into every conversation
- **MCP integration** -- native tool use for Plane and Linear

## Cursor

Cursor uses `.cursor/rules/aria.mdc` (MDC format with YAML frontmatter). The rule is set to `alwaysApply: true`, so ARIA context is available in every conversation.

**How to use:** Describe the workflow you want in natural language. Examples:

- "Brainstorm project ideas using ARIA"
- "Create a PRD for this project"
- "Run the dev story workflow"
- "Do a code review on the latest changes"

The rule file includes a workflow index table that maps each workflow to the correct agent YAML and instruction files.

**Not available in Cursor:** The automated orchestrator (`/aria-go`) uses Claude Code's Agent tool for subagent spawning, which Cursor does not support. Run individual workflows manually instead.

## Windsurf

Windsurf uses `.windsurf/rules/aria.md` (plain markdown). Windsurf has a 6000-character limit for workspace rules, so the ARIA config is condensed.

**How to use:** Same as Cursor -- describe the workflow you want in Cascade.

**Not available in Windsurf:** Orchestrator and subagent spawning.

## Cline / Roo Code

Cline uses `.clinerules/aria.md` (markdown in a rules directory). Full-length content supported.

**How to use:** Same as Cursor -- describe the workflow in the chat.

**Not available in Cline:** Orchestrator and subagent spawning.

## Other Tools

If your AI coding tool isn't listed above, you can still use ARIA:

1. Install with `./install.sh` (installs `_aria/` directory)
2. Point your tool at `_aria/core/agents/*.agent.yaml` for agent personas
3. Point it at the workflow instructions in `_aria/core/workflows/`
4. Use the CLAUDE.md in the ARIA repo as a reference for project instructions

## What's Different Without Claude Code?

| Feature | Claude Code | Other Tools |
|---|---|---|
| Workflow triggering | `/aria-dev` slash command | "Run the dev story workflow" |
| Orchestrator | Autonomous agent dispatch | Not available -- run workflows manually |
| Subagent spawning | Agent tool isolates each persona | Single conversation thread |
| Context loading | `{project-root}` auto-resolved | May need explicit file paths |
| MCP tools | Native integration | Depends on tool's MCP support |

The core value -- structured workflows, agent personas, cross-phase context retrieval, platform-native output -- works in every tool. The orchestrator is the main Claude Code exclusive.
