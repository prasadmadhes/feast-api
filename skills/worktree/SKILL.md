---
name: worktree
description: Create and manage git worktrees for parallel Claude Code sessions. Provisions worktrees with .env symlinks and Poetry virtualenv via scripts/setup_worktree.sh.
---

# Worktree Management

## Overview

Create and manage git worktrees for parallel Claude Code sessions on the Feast API backend. Automatically provisions worktrees with required untracked files (`.env`, Poetry virtualenv) using `scripts/setup_worktree.sh`.

## When to use

- User wants to work on multiple features/fixes in parallel
- User asks to "create a worktree", "set up a worktree", or "start a parallel session"
- A new Claude Code session needs an isolated branch with full dev/test capability

## Steps

### Creating a new worktree

1. **Get the worktree name** from the user. Use kebab-case (e.g., `add-auth`, `fix-orders`, `menu-crud`). If not provided, ask for it.

2. **Create the worktree and run setup:**

   Worktrees are created as sibling directories next to the main repo (e.g., `feast-api-add-auth/`).

   ```bash
   MAIN_REPO="$PWD"
   PARENT_DIR="$(dirname "$MAIN_REPO")"
   NAME="<worktree-name>"
   WORKTREE_PATH="$PARENT_DIR/feast-api-$NAME"

   git worktree add -b "$NAME" "$WORKTREE_PATH"
   bash "$MAIN_REPO/scripts/setup_worktree.sh" "$WORKTREE_PATH"
   ```

   If the user needs **per-worktree environment config** (different database, API keys), add the copy flag:

   ```bash
   bash "$MAIN_REPO/scripts/setup_worktree.sh" --copy-env "$WORKTREE_PATH"
   ```

3. **Verify** the setup:

   ```bash
   ls -la "$WORKTREE_PATH/.env"
   ls -d "$WORKTREE_PATH/.venv"
   ```

4. **Open a new terminal in the worktree:**

   ```bash
   bash "$MAIN_REPO/scripts/open_worktree.sh" "$NAME"
   ```

   This opens a new Terminal/iTerm2 window (macOS only) with the virtualenv activated.

5. **Report to user:**
   - Print the worktree path
   - Confirm that a new terminal window was opened
   - Note whether `.env` was symlinked or copied

### Listing worktrees

```bash
git worktree list
```

### Removing a worktree

```bash
git worktree remove <worktree_path>

# If there are uncommitted changes:
git worktree remove --force <worktree_path>
```

To also delete the branch:
```bash
git branch -d <branch-name>
```

## Rules

- Always use **absolute paths** for symlinks
- `.env` is **symlinked by default** — use `--copy-env` only when the user needs different database/secrets per worktree
- `.venv/` is created **per-worktree** via `poetry install` (not symlinked — each worktree gets its own virtualenv for isolation)
- Worktrees go in the **parent directory** as `feast-api-<name>/` (sibling to main repo)
- Install new packages from the **main repo** first, then run `poetry install` in active worktrees to sync
- **Never** commit `.env` or `.venv/` — they are gitignored
- Each worktree gets its own `__pycache__/`, `.pytest_cache/` — these are ephemeral and not shared
