#!/usr/bin/env bash
set -euo pipefail

# ARIA Installer
# Installs the ARIA Linear module into a target project directory
# Safe for re-installs: preserves module.yaml and .linear-key-map.yaml config
#
# Usage:
#   ./install.sh /path/to/project          (from cloned repo)
#   bash <(curl -fsSL .../install.sh) .    (pipe-to-shell — clones repo to temp dir)

REPO_URL="https://github.com/JacobWLMS/ARIA.git"
CLEANUP_TEMP=""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Detect if running from a cloned repo or piped from curl
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  # Piped from curl — need git to clone
  if ! command -v git &>/dev/null; then
    echo -e "\n  ${RED}Error:${RESET} git is required for pipe-to-shell install."
    echo -e "  Install git and try again, or clone the repo manually.\n"
    exit 1
  fi
  SCRIPT_DIR="$(mktemp -d)"
  CLEANUP_TEMP="$SCRIPT_DIR"
  echo ""
  echo -e "  ${DIM}Downloading ARIA...${RESET}"
  git clone --depth 1 --quiet "$REPO_URL" "$SCRIPT_DIR"
fi

# Read version from VERSION file
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  ARIA_VERSION="$(cat "$SCRIPT_DIR/VERSION" | tr -d '[:space:]')"
else
  ARIA_VERSION="dev"
fi

TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Cleanup temp dir on exit if we created one
if [ -n "$CLEANUP_TEMP" ]; then
  trap 'rm -rf "$CLEANUP_TEMP"' EXIT
fi

echo ""
echo -e "  ${BOLD}ARIA Installer${RESET} ${DIM}v${ARIA_VERSION}${RESET}"
echo "  =============="
echo ""
echo -e "  Source:  ${DIM}$SCRIPT_DIR${RESET}"
echo -e "  Target:  ${BOLD}$TARGET_DIR${RESET}"
echo ""

# Check source has what we need
if [ ! -d "$SCRIPT_DIR/src/linear" ]; then
  echo -e "  ${RED}Error:${RESET} src/linear/ not found in $SCRIPT_DIR"
  echo "  Make sure you're running this from the ARIA repository root."
  exit 1
fi

# Detect re-install (check both new and legacy paths)
IS_REINSTALL=false
ARIA_DIR="$TARGET_DIR/_aria/linear"
SHARED_DIR="$TARGET_DIR/_aria/shared"
LEGACY_DIR="$TARGET_DIR/_bmad/linear"

if [ -d "$ARIA_DIR" ]; then
  IS_REINSTALL=true
  echo -e "  ${YELLOW}Detected existing ARIA installation — preserving config files${RESET}"
  echo ""
elif [ -d "$LEGACY_DIR" ]; then
  IS_REINSTALL=true
  echo -e "  ${YELLOW}Detected legacy BMAD installation — migrating to ARIA${RESET}"
  echo ""
  # Migrate config files from legacy location
  mkdir -p "$ARIA_DIR"
  for CONFIG_FILE in module.yaml .linear-key-map.yaml; do
    if [ -f "$LEGACY_DIR/$CONFIG_FILE" ]; then
      cp "$LEGACY_DIR/$CONFIG_FILE" "$ARIA_DIR/$CONFIG_FILE"
      echo -e "  ${GREEN}Migrated:${RESET} _bmad/linear/$CONFIG_FILE -> _aria/linear/$CONFIG_FILE"
    fi
  done
  # Clean up legacy directories
  rm -rf "$TARGET_DIR/_bmad"
  echo -e "  ${GREEN}Removed${RESET} legacy _bmad/ directory"
  # Clean up legacy commands
  rm -f "$TARGET_DIR/.claude/commands/bmad-"*.md
  echo -e "  ${GREEN}Removed${RESET} legacy bmad-* slash commands"
  echo ""
fi

# Back up user config files before overwriting
if [ "$IS_REINSTALL" = true ] && [ -d "$ARIA_DIR" ]; then
  for CONFIG_FILE in module.yaml .linear-key-map.yaml; do
    if [ -f "$ARIA_DIR/$CONFIG_FILE" ]; then
      cp "$ARIA_DIR/$CONFIG_FILE" "$ARIA_DIR/$CONFIG_FILE.bak"
      echo -e "  ${DIM}Backed up: $CONFIG_FILE -> $CONFIG_FILE.bak${RESET}"
    fi
  done
fi

# Create target directories
echo -e "  ${BOLD}[1/6]${RESET} Creating directories..."
mkdir -p "$ARIA_DIR"
mkdir -p "$SHARED_DIR"
mkdir -p "$TARGET_DIR/.claude/commands"

# Copy shared content
echo -e "  ${BOLD}[2/6]${RESET} Installing shared content -> _aria/shared/"
cp -r "$SCRIPT_DIR/src/shared/"* "$SHARED_DIR/"

# Copy Linear module
echo -e "  ${BOLD}[3/6]${RESET} Installing Linear module -> _aria/linear/"
cp -r "$SCRIPT_DIR/src/linear/"* "$ARIA_DIR/"

# Copy VERSION file
echo -e "  ${BOLD}[4/6]${RESET} Writing version file..."
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  cp "$SCRIPT_DIR/VERSION" "$ARIA_DIR/VERSION"
fi

# Restore user config files after copy
if [ "$IS_REINSTALL" = true ] && [ -d "$ARIA_DIR" ]; then
  for CONFIG_FILE in module.yaml .linear-key-map.yaml; do
    if [ -f "$ARIA_DIR/$CONFIG_FILE.bak" ]; then
      mv "$ARIA_DIR/$CONFIG_FILE.bak" "$ARIA_DIR/$CONFIG_FILE"
      echo -e "  ${GREEN}Restored:${RESET} $CONFIG_FILE (user config preserved)"
    fi
  done
fi

# Handle CLAUDE.md — replace ARIA section instead of appending
echo -e "  ${BOLD}[5/6]${RESET} Installing CLAUDE.md..."
ARIA_MARKER="# ARIA"
if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
  if grep -q "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md"; then
    echo -e "         ${DIM}CLAUDE.md already has ARIA section — replacing it${RESET}"
    ARIA_LINE=$(grep -n "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md" | head -1 | cut -d: -f1)
    head -n $((ARIA_LINE - 1)) "$TARGET_DIR/CLAUDE.md" > "$TARGET_DIR/CLAUDE.md.tmp"
    echo "" >> "$TARGET_DIR/CLAUDE.md.tmp"
    cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md.tmp"
    mv "$TARGET_DIR/CLAUDE.md.tmp" "$TARGET_DIR/CLAUDE.md"
  else
    echo -e "         ${DIM}CLAUDE.md exists — appending ARIA section${RESET}"
    echo "" >> "$TARGET_DIR/CLAUDE.md"
    cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md"
  fi
else
  cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
fi

# Copy slash commands (and clean up old commands from previous versions)
echo -e "  ${BOLD}[6/6]${RESET} Installing slash commands -> .claude/commands/"
# Remove commands that were consolidated in Phase 3
for OLD_CMD in aria-attack aria-edges aria-edit-prose aria-edit-struct aria-prd-edit aria-prd-check aria-doc-check aria-explain aria-context aria-review aria-status; do
  rm -f "$TARGET_DIR/.claude/commands/$OLD_CMD.md"
done
cp "$SCRIPT_DIR/.claude/commands/"*.md "$TARGET_DIR/.claude/commands/"

COMMAND_COUNT=$(ls -1 "$TARGET_DIR/.claude/commands/aria-"*.md 2>/dev/null | wc -l)

echo ""
echo -e "  ${GREEN}${BOLD}Installation complete!${RESET} ${DIM}(v${ARIA_VERSION})${RESET}"
echo ""
echo "  Installed:"
echo "    - Shared content in _aria/shared/ (templates, checklists, data)"
echo "    - Linear module in _aria/linear/"
echo "    - CLAUDE.md with ARIA context"
echo "    - $COMMAND_COUNT slash commands in .claude/commands/"
if [ "$IS_REINSTALL" = true ]; then
  echo -e "    - ${GREEN}Config files preserved${RESET} (module.yaml, .linear-key-map.yaml)"
fi
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo "    1. Configure the Linear MCP server in .claude/settings.json"
echo "    2. Run /aria-setup to auto-configure team, statuses, and labels"
echo "    3. Run /aria-git to configure git integration (optional)"
echo "    4. Run /aria-doctor to verify your setup"
echo "    5. Run /aria-help to get started"
echo ""
