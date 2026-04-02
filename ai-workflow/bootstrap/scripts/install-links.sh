#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Repo: $REPO_DIR"

mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.claude"

# Codex global
ln -snf "$REPO_DIR/global/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Claude global
ln -snf "$REPO_DIR/global/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "Global links installed."