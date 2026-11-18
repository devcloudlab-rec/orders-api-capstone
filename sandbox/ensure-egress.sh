#!/usr/bin/env bash
# Create the internal agent network and the egress proxy (idempotent).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
EGRESS_NAME="agent-egress"
EGRESS_IMAGE="agent-egress:1"
NET_AGENT="agent-internal"
NET_EGRESS="agent-outbound"

docker network inspect "$NET_AGENT" >/dev/null 2>&1 \
  || docker network create --internal --subnet 10.200.0.0/24 "$NET_AGENT"
docker network inspect "$NET_EGRESS" >/dev/null 2>&1 \
  || docker network create "$NET_EGRESS"

docker image inspect "$EGRESS_IMAGE" >/dev/null 2>&1 \
  || docker build -t "$EGRESS_IMAGE" "$HERE/egress"

if docker container inspect "$EGRESS_NAME" >/dev/null 2>&1; then
  docker start "$EGRESS_NAME" >/dev/null
else
  docker run -d --restart unless-stopped --name "$EGRESS_NAME" \
    --network "$NET_EGRESS" "$EGRESS_IMAGE" >/dev/null
fi
docker network connect "$NET_AGENT" "$EGRESS_NAME" 2>/dev/null || true
