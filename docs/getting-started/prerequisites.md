# Prerequisites

Before installing ARIA, ensure you have:

## Operating System

ARIA is pure YAML + Markdown read by Claude Code at runtime -- there is no compilation, no native binaries, and no OS-specific dependencies. It runs wherever Claude Code runs.

| OS | Status | Notes |
|---|---|---|
| **macOS** | Fully supported | `bash` and `curl` pre-installed |
| **Linux** | Fully supported | `bash` and `curl` pre-installed on most distros |
| **Windows (WSL)** | Fully supported | Same as Linux -- run everything inside WSL |
| **Windows (native)** | Supported | Use [Git Bash](https://gitforwindows.org) for the installer. Clone-and-install method recommended over pipe-to-shell. |

The installer (`install.sh`) requires a **bash-compatible shell** -- `bash`, `zsh`, or Git Bash. PowerShell and CMD are not supported for installation, but once installed ARIA runs entirely through Claude Code which works on any OS.

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
