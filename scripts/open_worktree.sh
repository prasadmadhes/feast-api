#!/usr/bin/env bash
#
# open_worktree.sh — Open a new terminal window in a feast-api worktree.
#
# Usage:
#   bash scripts/open_worktree.sh <worktree-name>
#
# The worktree must exist as a sibling directory: ../feast-api-<name>/
# Opens a new Terminal.app or iTerm2 window with the venv activated.
#
set -euo pipefail

NAME="${1:?Usage: bash scripts/open_worktree.sh <worktree-name>}"
MAIN_REPO="$(cd "$(dirname "$0")/.." && pwd)"
PARENT_DIR="$(dirname "$MAIN_REPO")"
WORKTREE_PATH="$PARENT_DIR/feast-api-$NAME"

if [[ ! -d "$WORKTREE_PATH" ]]; then
    echo "Error: Worktree not found at $WORKTREE_PATH"
    echo "Create it first with: git worktree add -b $NAME $WORKTREE_PATH"
    exit 1
fi

INIT_CMD="cd '$WORKTREE_PATH' && source .venv/bin/activate; echo '=== feast-api worktree: $NAME ==='"

# Prefer iTerm2, fall back to Terminal.app
if osascript -e 'tell application "System Events" to get name of every process' 2>/dev/null | grep -q "iTerm2"; then
    osascript <<EOF
tell application "iTerm2"
    create window with default profile
    tell current session of current window
        write text "$INIT_CMD"
    end tell
end tell
EOF
else
    osascript <<EOF
tell application "Terminal"
    do script "$INIT_CMD"
    activate
end tell
EOF
fi

echo "Opened new terminal in: $WORKTREE_PATH"
