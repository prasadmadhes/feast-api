#!/usr/bin/env bash
#
# setup_worktree.sh — Provision a feast-api git worktree with required untracked files.
#
# Usage:
#   bash scripts/setup_worktree.sh <worktree-path>
#   bash scripts/setup_worktree.sh --copy-env <worktree-path>
#
# What it does:
#   1. Symlinks .env from the main repo (or copies it with --copy-env)
#   2. Symlinks .venv from the main repo
#
set -euo pipefail

COPY_ENV=false

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --copy-env)
            COPY_ENV=true
            shift
            ;;
        *)
            WORKTREE_PATH="$1"
            shift
            ;;
    esac
done

if [[ -z "${WORKTREE_PATH:-}" ]]; then
    echo "Usage: bash scripts/setup_worktree.sh [--copy-env] <worktree-path>"
    exit 1
fi

# Resolve absolute paths
WORKTREE_PATH="$(cd "$WORKTREE_PATH" && pwd)"
MAIN_REPO="$(git -C "$WORKTREE_PATH" worktree list | head -1 | awk '{print $1}')"

echo "=== Feast API Worktree Setup ==="
echo "Main repo:  $MAIN_REPO"
echo "Worktree:   $WORKTREE_PATH"
echo ""

# --- .env ---
if [[ -f "$MAIN_REPO/.env" ]]; then
    if [[ "$COPY_ENV" == true ]]; then
        cp "$MAIN_REPO/.env" "$WORKTREE_PATH/.env"
        echo "[copied]    .env (edit for different DB/secrets)"
    else
        ln -sf "$MAIN_REPO/.env" "$WORKTREE_PATH/.env"
        echo "[symlinked] .env"
    fi
else
    echo "[skipped]   .env (not found in main repo — copy .env.example and configure)"
fi

# --- .venv ---
if [[ -d "$MAIN_REPO/.venv" ]]; then
    ln -sf "$MAIN_REPO/.venv" "$WORKTREE_PATH/.venv"
    echo "[symlinked] .venv"
else
    echo "[skipped]   .venv (not found in main repo — run 'poetry install' in main repo first)"
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "  cd $WORKTREE_PATH"
echo "  source .venv/bin/activate"
echo "  uvicorn main:app --reload --port 8000"
