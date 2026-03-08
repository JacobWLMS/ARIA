# Prerequisites

Before installing ARIA, ensure you have:

## Required

- **[Claude Code](https://claude.ai/claude-code)** -- ARIA runs as slash commands inside Claude Code
- **A supported platform** -- either [Plane](https://plane.so) (self-hosted or cloud) or [Linear](https://linear.app) with at least one team/project
- **Platform API key** -- see your platform's API settings to generate one
- **Node.js 18+** -- required to run MCP servers via npx (Linear only; Plane uses Claude Code's built-in MCP)

## Recommended

- **Git** -- for optional Git/GitHub integration features
- **[GitHub CLI](https://cli.github.com) (`gh`)** -- for PR creation and review automation

## Platform Permissions

Your API key needs access to:

- Read and write work items, epics, sprints, milestones, and documents
- Read team/project and user information
- Manage labels, comments, and properties
