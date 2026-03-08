# Installation

ARIA installs into your project directory as a set of YAML configurations, workflow instructions, and slash commands.

## One-Liner (Pipe to Shell)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JacobWLMS/ARIA/main/install.sh) /path/to/your/project
```

## Clone and Install

```bash
git clone https://github.com/JacobWLMS/ARIA.git
cd ARIA
./install.sh /path/to/your/project
```

## What Gets Installed

| Directory | Contents |
|---|---|
| `_aria/linear/` | Agent definitions, workflows, tasks, orchestrator, configuration |
| `_aria/shared/` | Templates, checklists, data files (brainstorming techniques, complexity matrices) |
| `.claude/commands/` | 27 slash command files (`aria-*.md`) |
| `CLAUDE.md` | Project instructions with command reference and critical rules |

## Re-Installing

The installer is safe for re-runs. It detects existing installations and:

- **Preserves** your `module.yaml` and `.linear-key-map.yaml` configuration
- **Updates** all workflow instructions, templates, and slash commands
- **Cleans up** old commands from previous versions

## Uninstalling

To remove ARIA from a project:

```bash
./uninstall.sh /path/to/your/project
```

This removes the `_aria/` directory, `aria-*` slash commands, and the ARIA section from CLAUDE.md. It asks for confirmation before proceeding.

## Legacy Migration

If you have a previous BMAD installation (`_bmad/` directory), the installer automatically:

1. Migrates config files from `_bmad/linear/` to `_aria/linear/`
2. Removes the legacy `_bmad/` directory
3. Cleans up old `bmad-*` slash commands
