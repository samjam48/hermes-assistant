#!/usr/bin/env bash
# Create or replace the evening loose-ends cron job.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JOB_NAME="loose-ends-evening"
SCHEDULE="0 20 * * *"
DELIVER="${HERMES_CRON_DELIVER:-whatsapp}"

PROMPT='Run loose-ends evening review per AGENTS.md. Load skills life-core and loose-ends. Read store/commitments.jsonl, inbox/, tasks/active.md, memory/paths.md. Stale=7d. Priority themes: Claude Code experiments, side-project drift. Write digests/YYYY-MM-DD-evening.md (Europe/Lisbon date). Reply with 3-7 bullets for messaging delivery.'

# Remove existing job with same name if present
if hermes cron list 2>/dev/null | grep -q "$JOB_NAME"; then
  echo "Removing existing job: $JOB_NAME"
  hermes cron remove "$JOB_NAME" 2>/dev/null || true
fi

hermes cron create "$SCHEDULE" "$PROMPT" \
  --name "$JOB_NAME" \
  --deliver "$DELIVER" \
  --workdir "$REPO_ROOT" \
  --skill life-core \
  --skill loose-ends

echo ""
echo "Created cron job: $JOB_NAME"
echo "  Schedule: $SCHEDULE (20:00 daily — confirm timezone in hermes config)"
echo "  Workdir:  $REPO_ROOT"
echo "  Deliver:  $DELIVER"
echo ""
echo "If WhatsApp delivery fails, try:"
echo "  HERMES_CRON_DELIVER=telegram hermes cron ..."
echo "  or set --deliver to your platform:chat_id (see: hermes cron create --help)"
echo ""
hermes cron list 2>/dev/null || true
