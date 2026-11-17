#!/usr/bin/env bash
# Run Claude Code in a container: project folder only, non-root, no extra
# capabilities, and a network whose only way out is a proxy that allows the model API.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROMPT="${*:-Run the test suite and summarise the result.}"
PROXY="http://agent-egress:8888"
IMAGE="agent-sandbox:2.1.319"

: "${ANTHROPIC_API_KEY:?set ANTHROPIC_API_KEY first}"
"$ROOT/sandbox/ensure-egress.sh"
docker image inspect "$IMAGE" >/dev/null 2>&1 \
  || docker build -q -t "$IMAGE" -f "$ROOT/sandbox/Dockerfile" "$ROOT"

docker run --rm \
  --network agent-internal \
  -e HTTPS_PROXY="$PROXY" -e HTTP_PROXY="$PROXY" \
  --user 1000:1000 \
  --read-only \
  --cap-drop ALL \
  --security-opt no-new-privileges \
  --tmpfs /tmp \
  --tmpfs /home/agent:uid=1000,gid=1000 \
  -e ANTHROPIC_API_KEY \
  -v "$ROOT:/workspace:ro" \
  -w /workspace \
  "$IMAGE" "$PROMPT"
