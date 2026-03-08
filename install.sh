#!/usr/bin/env bash
set -euo pipefail

# ARIA Installer
# Installs the ARIA module into a target project directory
# Supports multiple platforms: Linear, Plane
# Supports multiple AI tools: Claude Code, Cursor, Windsurf, Cline
# Safe for re-installs: preserves module.yaml and data/.key-map.yaml config
#
# Usage:
#   ./install.sh [/path/to/project] [--tool <tool>]
#   curl -fsSL .../install.sh | bash                     (install to current dir)
#   curl -fsSL .../install.sh | bash -s -- /path         (install to specific dir)
#   curl -fsSL .../install.sh | bash -s -- --tool cursor (install for Cursor)
#
# Tools: claude-code (default), cursor, windsurf, cline, all

# Shell compatibility check
if [ -z "${BASH_VERSION:-}" ]; then
  echo ""
  echo "  Error: ARIA requires a bash-compatible shell."
  echo ""
  echo "  You appear to be running this in a different shell."
  echo "  Try one of:"
  echo "    bash install.sh /path/to/project"
  echo "    ./install.sh /path/to/project  (if bash is your default shell)"
  echo ""
  echo "  On Windows, use WSL or Git Bash (https://gitforwindows.org)."
  echo "  PowerShell and CMD are not supported."
  echo ""
  exit 1
fi

REPO_URL="https://github.com/JacobWLMS/ARIA.git"
CLEANUP_TEMP=""
AI_TOOL="claude-code"

# Parse arguments — positional arg is target dir, --tool sets AI tool
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)
      AI_TOOL="${2:-claude-code}"
      shift 2
      ;;
    --tool=*)
      AI_TOOL="${1#*=}"
      shift
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}"

# Validate tool choice
case "$AI_TOOL" in
  claude-code|cursor|windsurf|cline|all) ;;
  *)
    echo "  Error: Unknown tool '$AI_TOOL'. Valid options: claude-code, cursor, windsurf, cline, all"
    exit 1
    ;;
esac

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
if [ ! -d "$SCRIPT_DIR/src/core" ]; then
  echo -e "  ${RED}Error:${RESET} src/core/ not found in $SCRIPT_DIR"
  echo "  Make sure you're running this from the ARIA repository root."
  exit 1
fi

if [ ! -d "$SCRIPT_DIR/src/platforms" ]; then
  echo -e "  ${RED}Error:${RESET} src/platforms/ not found in $SCRIPT_DIR"
  echo "  Make sure you're running this from the ARIA repository root."
  exit 1
fi

# --- Platform selection ---
# Check if an existing install has a platform marker
EXISTING_PLATFORM=""
if [ -f "$TARGET_DIR/_aria/.platform" ]; then
  EXISTING_PLATFORM="$(cat "$TARGET_DIR/_aria/.platform" | tr -d '[:space:]')"
fi

echo -e "  ${BOLD}Select your platform:${RESET}"
echo ""
if [ -n "$EXISTING_PLATFORM" ]; then
  echo -e "  ${DIM}(previously installed: $EXISTING_PLATFORM)${RESET}"
  echo ""
fi
echo "    [1] Plane (recommended)"
echo "    [2] Linear"
echo ""
read -p "  Choice (1-2): " -n 1 -r PLATFORM_CHOICE < /dev/tty
echo ""
echo ""

case "$PLATFORM_CHOICE" in
  1)
    PLATFORM="plane"
    PLATFORM_LABEL="Plane"
    ;;
  2)
    PLATFORM="linear"
    PLATFORM_LABEL="Linear"
    ;;
  *)
    echo -e "  ${RED}Invalid choice.${RESET} Please run the installer again and select 1 or 2."
    exit 1
    ;;
esac

# Validate platform source exists
if [ ! -d "$SCRIPT_DIR/src/platforms/$PLATFORM" ]; then
  echo -e "  ${RED}Error:${RESET} src/platforms/$PLATFORM/ not found in $SCRIPT_DIR"
  exit 1
fi

echo -e "  ${GREEN}Platform:${RESET} $PLATFORM_LABEL"
echo ""

# Detect re-install
IS_REINSTALL=false
CORE_DIR="$TARGET_DIR/_aria/core"
PLATFORM_DIR="$TARGET_DIR/_aria/platform"
SHARED_DIR="$TARGET_DIR/_aria/shared"
LEGACY_LINEAR_DIR="$TARGET_DIR/_aria/linear"
LEGACY_BMAD_DIR="$TARGET_DIR/_bmad/linear"

if [ -d "$CORE_DIR" ]; then
  IS_REINSTALL=true
  echo -e "  ${YELLOW}Detected existing ARIA installation -- preserving config files${RESET}"
  echo ""
elif [ -d "$LEGACY_LINEAR_DIR" ]; then
  IS_REINSTALL=true
  echo -e "  ${YELLOW}Detected legacy v1.x installation (_aria/linear/) -- migrating${RESET}"
  echo ""
  # Migrate config files from legacy location
  mkdir -p "$CORE_DIR"
  mkdir -p "$CORE_DIR/data"
  for CONFIG_FILE in module.yaml; do
    if [ -f "$LEGACY_LINEAR_DIR/$CONFIG_FILE" ]; then
      cp "$LEGACY_LINEAR_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE"
      echo -e "  ${GREEN}Migrated:${RESET} _aria/linear/$CONFIG_FILE -> _aria/core/$CONFIG_FILE"
    fi
  done
  if [ -f "$LEGACY_LINEAR_DIR/.linear-key-map.yaml" ]; then
    cp "$LEGACY_LINEAR_DIR/.linear-key-map.yaml" "$CORE_DIR/data/.key-map.yaml"
    echo -e "  ${GREEN}Migrated:${RESET} _aria/linear/.linear-key-map.yaml -> _aria/core/data/.key-map.yaml"
  fi
  # Clean up legacy directory
  rm -rf "$LEGACY_LINEAR_DIR"
  echo -e "  ${GREEN}Removed${RESET} legacy _aria/linear/ directory"
  echo ""
elif [ -d "$LEGACY_BMAD_DIR" ]; then
  IS_REINSTALL=true
  echo -e "  ${YELLOW}Detected legacy BMAD installation -- migrating to ARIA${RESET}"
  echo ""
  # Migrate config files from legacy location
  mkdir -p "$CORE_DIR"
  mkdir -p "$CORE_DIR/data"
  for CONFIG_FILE in module.yaml; do
    if [ -f "$LEGACY_BMAD_DIR/$CONFIG_FILE" ]; then
      cp "$LEGACY_BMAD_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE"
      echo -e "  ${GREEN}Migrated:${RESET} _bmad/linear/$CONFIG_FILE -> _aria/core/$CONFIG_FILE"
    fi
  done
  if [ -f "$LEGACY_BMAD_DIR/.linear-key-map.yaml" ]; then
    cp "$LEGACY_BMAD_DIR/.linear-key-map.yaml" "$CORE_DIR/data/.key-map.yaml"
    echo -e "  ${GREEN}Migrated:${RESET} _bmad/linear/.linear-key-map.yaml -> _aria/core/data/.key-map.yaml"
  fi
  # Clean up legacy directories
  rm -rf "$TARGET_DIR/_bmad"
  echo -e "  ${GREEN}Removed${RESET} legacy _bmad/ directory"
  # Clean up legacy commands
  rm -f "$TARGET_DIR/.claude/commands/bmad-"*.md
  echo -e "  ${GREEN}Removed${RESET} legacy bmad-* slash commands"
  echo ""
fi

# Back up user config files before overwriting
if [ "$IS_REINSTALL" = true ] && [ -d "$CORE_DIR" ]; then
  for CONFIG_FILE in module.yaml data/.key-map.yaml; do
    if [ -f "$CORE_DIR/$CONFIG_FILE" ]; then
      cp "$CORE_DIR/$CONFIG_FILE" "$CORE_DIR/$CONFIG_FILE.bak"
      echo -e "  ${DIM}Backed up: $CONFIG_FILE -> $CONFIG_FILE.bak${RESET}"
    fi
  done
fi

# Clean up legacy _aria/linear/ if it still exists (migration from v1.x on reinstall)
if [ -d "$LEGACY_LINEAR_DIR" ]; then
  rm -rf "$LEGACY_LINEAR_DIR"
  echo -e "  ${GREEN}Removed${RESET} legacy _aria/linear/ directory"
fi

# Create target directories
echo -e "  ${BOLD}[1/8]${RESET} Creating directories..."
mkdir -p "$CORE_DIR"
mkdir -p "$PLATFORM_DIR"
mkdir -p "$SHARED_DIR"

# Copy shared content
echo -e "  ${BOLD}[2/8]${RESET} Installing shared content -> _aria/shared/"
cp -r "$SCRIPT_DIR/src/shared/"* "$SHARED_DIR/"

# Copy core module
echo -e "  ${BOLD}[3/8]${RESET} Installing core module -> _aria/core/"
cp -r "$SCRIPT_DIR/src/core/"* "$CORE_DIR/"

# Copy platform-specific content
echo -e "  ${BOLD}[4/8]${RESET} Installing $PLATFORM_LABEL platform -> _aria/platform/"
# Clear previous platform content (may be switching platforms)
rm -rf "$PLATFORM_DIR/"*
cp -r "$SCRIPT_DIR/src/platforms/$PLATFORM/"* "$PLATFORM_DIR/"

# Write platform marker file
echo "$PLATFORM" > "$TARGET_DIR/_aria/.platform"

# Copy VERSION file
echo -e "  ${BOLD}[5/8]${RESET} Writing version file..."
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  cp "$SCRIPT_DIR/VERSION" "$CORE_DIR/VERSION"
fi

# Restore user config files after copy
if [ "$IS_REINSTALL" = true ] && [ -d "$CORE_DIR" ]; then
  for CONFIG_FILE in module.yaml data/.key-map.yaml; do
    if [ -f "$CORE_DIR/$CONFIG_FILE.bak" ]; then
      mv "$CORE_DIR/$CONFIG_FILE.bak" "$CORE_DIR/$CONFIG_FILE"
      echo -e "  ${GREEN}Restored:${RESET} $CONFIG_FILE (user config preserved)"
    fi
  done
fi

# --- AI Tool Config Installation ---

install_claude_code() {
  # Handle CLAUDE.md — replace ARIA section instead of appending
  echo -e "  ${BOLD}[6/8]${RESET} Installing CLAUDE.md..."
  ARIA_MARKER="# ARIA"
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    if grep -q "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md"; then
      echo -e "         ${DIM}CLAUDE.md already has ARIA section -- replacing it${RESET}"
      ARIA_LINE=$(grep -n "$ARIA_MARKER" "$TARGET_DIR/CLAUDE.md" | head -1 | cut -d: -f1)
      head -n $((ARIA_LINE - 1)) "$TARGET_DIR/CLAUDE.md" > "$TARGET_DIR/CLAUDE.md.tmp"
      echo "" >> "$TARGET_DIR/CLAUDE.md.tmp"
      cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md.tmp"
      mv "$TARGET_DIR/CLAUDE.md.tmp" "$TARGET_DIR/CLAUDE.md"
    else
      echo -e "         ${DIM}CLAUDE.md exists -- appending ARIA section${RESET}"
      echo "" >> "$TARGET_DIR/CLAUDE.md"
      cat "$SCRIPT_DIR/CLAUDE.md" >> "$TARGET_DIR/CLAUDE.md"
    fi
  else
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  fi

  # Copy slash commands
  echo -e "  ${BOLD}[7/8]${RESET} Installing slash commands -> .claude/commands/"
  mkdir -p "$TARGET_DIR/.claude/commands"
  for OLD_CMD in aria-attack aria-edges aria-edit-prose aria-edit-struct aria-prd-edit aria-prd-check aria-doc-check aria-explain aria-context aria-review aria-status; do
    rm -f "$TARGET_DIR/.claude/commands/$OLD_CMD.md"
  done
  cp "$SCRIPT_DIR/.claude/commands/"*.md "$TARGET_DIR/.claude/commands/"
  COMMAND_COUNT=$(ls -1 "$TARGET_DIR/.claude/commands/aria-"*.md 2>/dev/null | wc -l)
  echo -e "         ${DIM}$COMMAND_COUNT commands installed${RESET}"
}

install_cursor() {
  echo -e "  ${BOLD}[6/8]${RESET} Installing Cursor rules -> .cursor/rules/"
  mkdir -p "$TARGET_DIR/.cursor/rules"
  if [ -f "$SCRIPT_DIR/src/tools/cursor/aria.mdc" ]; then
    cp "$SCRIPT_DIR/src/tools/cursor/aria.mdc" "$TARGET_DIR/.cursor/rules/aria.mdc"
  else
    echo -e "         ${YELLOW}Warning: Cursor config not found in source${RESET}"
  fi
}

install_windsurf() {
  echo -e "  ${BOLD}[6/8]${RESET} Installing Windsurf rules -> .windsurf/rules/"
  mkdir -p "$TARGET_DIR/.windsurf/rules"
  if [ -f "$SCRIPT_DIR/src/tools/windsurf/aria.md" ]; then
    cp "$SCRIPT_DIR/src/tools/windsurf/aria.md" "$TARGET_DIR/.windsurf/rules/aria.md"
  else
    echo -e "         ${YELLOW}Warning: Windsurf config not found in source${RESET}"
  fi
}

install_cline() {
  echo -e "  ${BOLD}[6/8]${RESET} Installing Cline rules -> .clinerules/"
  mkdir -p "$TARGET_DIR/.clinerules"
  if [ -f "$SCRIPT_DIR/src/tools/cline/aria.md" ]; then
    cp "$SCRIPT_DIR/src/tools/cline/aria.md" "$TARGET_DIR/.clinerules/aria.md"
  else
    echo -e "         ${YELLOW}Warning: Cline config not found in source${RESET}"
  fi
}

# Install tool-specific config
case "$AI_TOOL" in
  claude-code)
    install_claude_code
    ;;
  cursor)
    install_cursor
    ;;
  windsurf)
    install_windsurf
    ;;
  cline)
    install_cline
    ;;
  all)
    install_claude_code
    install_cursor
    install_windsurf
    install_cline
    ;;
esac

# Update .gitignore for tool-specific directories
echo -e "  ${BOLD}[8/8]${RESET} Checking .gitignore..."
if [ -f "$TARGET_DIR/.gitignore" ]; then
  for PATTERN in "_aria/core/module.yaml" "_aria/core/data/.key-map.yaml"; do
    if ! grep -q "$PATTERN" "$TARGET_DIR/.gitignore" 2>/dev/null; then
      echo "$PATTERN" >> "$TARGET_DIR/.gitignore"
    fi
  done
fi

echo ""
echo -e "  ${GREEN}${BOLD}Installation complete!${RESET} ${DIM}(v${ARIA_VERSION})${RESET}"
echo ""
echo "  Installed:"
echo "    - Shared content in _aria/shared/ (templates, checklists, data)"
echo "    - Core module in _aria/core/"
echo "    - $PLATFORM_LABEL platform in _aria/platform/"
echo "    - Platform marker: _aria/.platform ($PLATFORM)"
case "$AI_TOOL" in
  claude-code)
    echo "    - CLAUDE.md with ARIA context"
    echo "    - $COMMAND_COUNT slash commands in .claude/commands/"
    ;;
  cursor)  echo "    - Cursor rules in .cursor/rules/aria.mdc" ;;
  windsurf) echo "    - Windsurf rules in .windsurf/rules/aria.md" ;;
  cline)   echo "    - Cline rules in .clinerules/aria.md" ;;
  all)
    echo "    - CLAUDE.md + $COMMAND_COUNT slash commands (Claude Code)"
    echo "    - Cursor rules in .cursor/rules/aria.mdc"
    echo "    - Windsurf rules in .windsurf/rules/aria.md"
    echo "    - Cline rules in .clinerules/aria.md"
    ;;
esac
if [ "$IS_REINSTALL" = true ]; then
  echo -e "    - ${GREEN}Config files preserved${RESET} (module.yaml, data/.key-map.yaml)"
fi
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
if [ "$PLATFORM" = "linear" ]; then
  echo "    1. Configure the Linear MCP server in your AI tool's settings"
  echo "    2. Run /aria-setup (Claude Code) or say 'Run ARIA setup' to auto-configure"
elif [ "$PLATFORM" = "plane" ]; then
  echo "    1. Configure the Plane MCP server in your AI tool's settings"
  echo "    2. Run /aria-setup (Claude Code) or say 'Run ARIA setup' to auto-configure"
fi
echo "    3. Run /aria-git to configure git integration (optional)"
echo "    4. Run /aria-doctor to verify your setup"
echo "    5. Run /aria-help to get started"
echo ""
