#!/usr/bin/env bash
# Apply WhatsApp self-chat inbound patch inside the running Hermes container.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PATCH_FILE="$REPO_ROOT/patches/whatsapp-bridge-selfchat.patch"
CONTAINER="${HERMES_CONTAINER:-hermes}"

if [[ ! -f "$PATCH_FILE" ]]; then
  echo "Missing $PATCH_FILE" >&2
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "Container $CONTAINER is not running." >&2
  exit 1
fi

docker cp "$PATCH_FILE" "$CONTAINER:/tmp/whatsapp-bridge-selfchat.patch"
docker exec "$CONTAINER" bash -lc "cd /opt/hermes && patch -p1 --forward < /tmp/whatsapp-bridge-selfchat.patch"
docker restart "$CONTAINER"
echo "Patch applied in $CONTAINER and container restarted."
