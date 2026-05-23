#!/usr/bin/env bash
# Link workspace skills into ~/.hermes/skills/ so /life-core, /loose-ends, etc. work globally.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HERMES_SKILLS="${HERMES_SKILLS:-$HOME/.hermes/skills}"

mkdir -p "$HERMES_SKILLS"

for skill in life-core loose-ends digest ops radar; do
  src="$REPO_ROOT/skills/$skill"
  dest="$HERMES_SKILLS/$skill"
  if [[ ! -d "$src" ]]; then
    echo "Missing $src" >&2
    exit 1
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
done

echo ""
echo "Done. Run: hermes skills list  (or /reload-skills in chat)"
echo "Slash commands: /life-core /loose-ends /digest /ops /radar"
echo "Loose-ends review: preload both with  hermes chat -s life-core,loose-ends"
