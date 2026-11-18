#!/usr/bin/env bash
# Trust the mounted project so its .claude/settings.json rules apply, then run the agent once.
set -euo pipefail
printf '{"projects":{"/workspace":{"hasTrustDialogAccepted":true}}}\n' > "$HOME/.claude.json"
exec claude -p "$1" --dangerously-skip-permissions
