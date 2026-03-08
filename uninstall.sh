#!/usr/bin/env bash
set -euo pipefail

# ARIA Uninstaller
# Removes ARIA from a target project directory
#
# Usage: ./uninstall.sh /path/to/project

TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "  ${BOLD}ARIA Uninstaller${RESET}"
echo "  ==============="
echo ""
echo "  Target: $TARGET_DIR"
echo ""

# Check if ARIA is installed
if [ ! -d "$TARGET_DIR/_aria" ] && ! ls "$TARGET_DIR/.claude/commands/aria-"*.md &>/dev/null; then
  echo -e "  ${YELLOW}ARIA is not installed in this directory.${RESET}"
  exit 0
fi

# Confirm
echo -e "  ${YELLOW}This will remove:${RESET}"
[ -d "$TARGET_DIR/_aria/core" ] && echo "    - _aria/core/ directory (agents, workflows, config)"
[ -d "$TARGET_DIR/_aria/platform" ] && echo "    - _aria/platform/ directory (platform-specific content)"
[ -f "$TARGET_DIR/_aria/platform" ] && echo "    - _aria/platform marker file"
[ -d "$TARGET_DIR/_aria/shared" ] && echo "    - _aria/shared/ directory (templates, checklists, data)"
[ -d "$TARGET_DIR/_aria/linear" ] && echo "    - _aria/linear/ directory (legacy v1.x)"
[ -d "$TARGET_DIR/_aria" ] && echo "    - _aria/ directory"
ls "$TARGET_DIR/.claude/commands/aria-"*.md &>/dev/null && echo "    - .claude/commands/aria-*.md (slash commands)"
grep -q "# ARIA" "$TARGET_DIR/CLAUDE.md" 2>/dev/null && echo "    - ARIA section from CLAUDE.md"
echo ""
read -p "  Proceed? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  echo -e "  ${YELLOW}Cancelled.${RESET}"
  exit 0
fi

echo ""

# Remove _aria/ directory (covers core/, platform/, shared/, and legacy linear/)
if [ -d "$TARGET_DIR/_aria" ]; then
  rm -rf "$TARGET_DIR/_aria"
  echo -e "  ${GREEN}Removed${RESET} _aria/"
fi

# Remove slash commands
REMOVED_COMMANDS=0
for CMD in "$TARGET_DIR/.claude/commands/aria-"*.md; do
  [ -f "$CMD" ] || continue
  rm -f "$CMD"
  REMOVED_COMMANDS=$((REMOVED_COMMANDS + 1))
done
if [ "$REMOVED_COMMANDS" -gt 0 ]; then
  echo -e "  ${GREEN}Removed${RESET} $REMOVED_COMMANDS slash commands"
fi

# Remove ARIA section from CLAUDE.md
if [ -f "$TARGET_DIR/CLAUDE.md" ] && grep -q "# ARIA" "$TARGET_DIR/CLAUDE.md"; then
  ARIA_LINE=$(grep -n "# ARIA" "$TARGET_DIR/CLAUDE.md" | head -1 | cut -d: -f1)
  if [ "$ARIA_LINE" -gt 1 ]; then
    head -n $((ARIA_LINE - 1)) "$TARGET_DIR/CLAUDE.md" > "$TARGET_DIR/CLAUDE.md.tmp"
    # Trim trailing blank lines
    sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$TARGET_DIR/CLAUDE.md.tmp" > "$TARGET_DIR/CLAUDE.md"
    rm -f "$TARGET_DIR/CLAUDE.md.tmp"
    echo -e "  ${GREEN}Removed${RESET} ARIA section from CLAUDE.md"
  else
    rm -f "$TARGET_DIR/CLAUDE.md"
    echo -e "  ${GREEN}Removed${RESET} CLAUDE.md (was ARIA-only)"
  fi
fi

echo ""
echo -e "  ${GREEN}ARIA has been removed from $TARGET_DIR${RESET}"
echo ""
