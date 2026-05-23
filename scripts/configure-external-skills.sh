#!/usr/bin/env bash
# Add this repo's skills/ to ~/.hermes/config.yaml external_dirs (optional alternative to symlinks).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${HERMES_CONFIG:-$HOME/.hermes/config.yaml}"

if [[ ! -f "$CONFIG" ]]; then
  echo "No config at $CONFIG — run hermes setup first." >&2
  exit 1
fi

if grep -q "$REPO_ROOT/skills" "$CONFIG" 2>/dev/null; then
  echo "Already configured: $REPO_ROOT/skills"
  exit 0
fi

python3 <<PY
import yaml
from pathlib import Path

config_path = Path("$CONFIG")
repo_skills = "$REPO_ROOT/skills"

data = {}
if config_path.exists():
    text = config_path.read_text()
    data = yaml.safe_load(text) or {}

skills = data.setdefault("skills", {})
dirs = skills.setdefault("external_dirs", [])
if not isinstance(dirs, list):
    dirs = []
if repo_skills not in dirs:
    dirs.append(repo_skills)
skills["external_dirs"] = dirs

config_path.write_text(yaml.dump(data, default_flow_style=False, sort_keys=False))
print(f"Added external_dirs: {repo_skills}")
PY

echo "Restart Hermes gateway or run /reload-skills if needed."
