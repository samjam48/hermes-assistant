#!/usr/bin/env bash
# Configure ~/.hermes for Hermes running in Docker with the life-bot repo at /workspace.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${HERMES_CONFIG:-$HOME/.hermes/config.yaml}"
ENV_FILE="${HERMES_ENV:-$HOME/.hermes/.env}"
CRON_JOBS="${HERMES_CRON_JOBS:-$HOME/.hermes/cron/jobs.json}"
CONTAINER_NAME="${HERMES_CONTAINER:-hermes}"
WORKSPACE="/workspace"
JOB_ID="${HERMES_CRON_JOB_ID:-a2b0a2f80c6c}"

CHANNEL_PROMPT='You are Hermes life-bot: personal memory, follow-ups, and life admin (not trading). Workspace: /workspace — read AGENTS.md first. Capture: note: (inbox + commitments), done:, snooze:, review (evening loose-ends). Preload life-core and loose-ends skills for reviews. Write digests/YYYY-MM-DD-evening.md; reply concisely on messaging.'

if [[ ! -f "$CONFIG" ]]; then
  echo "No config at $CONFIG — run hermes setup first." >&2
  exit 1
fi

TELEGRAM_HOME="$(grep -E '^TELEGRAM_HOME_CHANNEL=' "$ENV_FILE" 2>/dev/null | cut -d= -f2- | tr -d \"'\" || true)"
WHATSAPP_HOME="$(grep -E '^WHATSAPP_HOME_CHANNEL=' "$ENV_FILE" 2>/dev/null | cut -d= -f2- | tr -d \"'\" || true)"
TELEGRAM_HOME="${TELEGRAM_HOME:-6625761548}"
WHATSAPP_HOME="${WHATSAPP_HOME:-225223873925169@lid}"

patch_config() {
  if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "$CONTAINER_NAME"; then
    docker exec "$CONTAINER_NAME" sh -c "cd /opt/hermes && uv run python -" <<PY
import yaml
from pathlib import Path

config_path = Path("/opt/data/config.yaml")
repo_skills = "$REPO_ROOT/skills"
workspace_skills = "$WORKSPACE/skills"
channel_prompt = """$CHANNEL_PROMPT"""

data = yaml.safe_load(config_path.read_text()) or {}

skills = data.setdefault("skills", {})
dirs = skills.get("external_dirs") or []
if not isinstance(dirs, list):
    dirs = []
for path in (workspace_skills, repo_skills):
    if path not in dirs:
        dirs.append(path)
skills["external_dirs"] = dirs

terminal = data.setdefault("terminal", {})
terminal["backend"] = "local"
terminal["cwd"] = "$WORKSPACE"

data["timezone"] = "Europe/Lisbon"

telegram = data.setdefault("telegram", {})
tg_prompts = telegram.get("channel_prompts") or {}
if not isinstance(tg_prompts, dict):
    tg_prompts = {}
tg_prompts["$TELEGRAM_HOME"] = channel_prompt
telegram["channel_prompts"] = tg_prompts

whatsapp = data.setdefault("whatsapp", {})
wa_prompts = whatsapp.get("channel_prompts") or {}
if not isinstance(wa_prompts, dict):
    wa_prompts = {}
wa_prompts["$WHATSAPP_HOME"] = channel_prompt
whatsapp["channel_prompts"] = wa_prompts

config_path.write_text(yaml.dump(data, default_flow_style=False, sort_keys=False))
print(f"Updated {config_path}")
PY
  else
    echo "Container $CONTAINER_NAME not running — using hermes config set for simple keys."
    command -v hermes >/dev/null || { echo "hermes CLI not found" >&2; exit 1; }
    hermes config set terminal.backend local
    hermes config set terminal.cwd "$WORKSPACE"
    hermes config set timezone Europe/Lisbon
    echo "Start the container and re-run to patch external_dirs and channel_prompts."
  fi
}

patch_config

if [[ -f "$ENV_FILE" ]]; then
  if grep -q '^TERMINAL_ENV=' "$ENV_FILE"; then
    sed -i '' 's/^TERMINAL_ENV=.*/TERMINAL_ENV=local/' "$ENV_FILE"
  else
    echo "TERMINAL_ENV=local" >> "$ENV_FILE"
  fi
  echo "Set TERMINAL_ENV=local in $ENV_FILE"
fi

# Cron workdir: /workspace only exists inside the container — patch jobs.json directly
if [[ -f "$CRON_JOBS" ]] && grep -q 'loose-ends-evening' "$CRON_JOBS"; then
  python3 <<PY
import json
from pathlib import Path

path = Path("$CRON_JOBS")
data = json.loads(path.read_text())
for job in data.get("jobs", []):
    if job.get("name") == "loose-ends-evening":
        job["workdir"] = "$WORKSPACE"
        print(f"Set cron workdir → $WORKSPACE for job {job.get('id')}")
path.write_text(json.dumps(data, indent=2) + "\n")
PY
fi

if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "$CONTAINER_NAME"; then
  echo "Restarting $CONTAINER_NAME..."
  docker restart "$CONTAINER_NAME" >/dev/null
  echo "Restarted. Wait ~10s for gateway to come up."
else
  echo "Container $CONTAINER_NAME not running — config saved; restart when ready."
fi

echo ""
echo "Verify (after gateway is up):"
echo "  hermes skills list | grep -E 'life-core|loose-ends'"
echo "  Send on WhatsApp/Telegram: note: docker skills test"
echo "  Manual cron test: hermes cron run $JOB_ID"
