# Contributing to ARIA

Thanks for your interest in contributing to ARIA! This guide will get you up and running.

## Getting Started

1. Fork and clone the repository
2. Install to a test project to verify your setup:
   ```bash
   ./install.sh /path/to/test-project
   ```
3. Ensure you have a Plane or Linear MCP server connected in Claude Code

## Development

ARIA is pure YAML + Markdown — there is no build step.

- **Core agents and workflows:** `src/core/` — platform-agnostic agents, workflows, and task dispatchers
- **Platform implementations:** `src/platforms/{linear,plane}/` — platform-specific task procedures and config
- **Shared content:** `src/shared/` — templates, checklists, and data files used across modules
- **Slash commands:** `.claude/commands/` — Claude Code command definitions (one `.md` file per command)

Changes to `src/` are installed into target projects via `install.sh`.

## Code Style

- **Agents/workflows:** Follow the existing YAML structure in `src/core/agents/*.agent.yaml`
- **Instructions/templates:** Use Markdown; keep files focused on a single concern
- **DRY:** Extract reusable content into `src/core/workflows/includes/` to avoid duplication
- **Naming:** Use kebab-case for files, match existing patterns for new agents or workflows

## Testing

There is no automated test suite. To verify your changes:

1. Install to a test project: `./install.sh /path/to/test-project`
2. Open Claude Code in the test project
3. Run a few slash commands (e.g., `/aria-help`, `/aria-brainstorm`)
4. Verify output goes to your platform (Plane or Linear) — not to local files

## Pull Requests

- Describe what you changed and why
- Reference any related issues
- Keep PRs focused — one feature or fix per PR
- Test your changes with at least one slash command end-to-end

## Note

ARIA extends the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD). Templates and checklists are adapted from the original project.
