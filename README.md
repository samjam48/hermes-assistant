# hermes-life-bot

Local workspace for [Hermes](https://github.com/NousResearch/hermes-agent) — memory, follow-ups, and life admin (not trading).

## Quick start

```bash
cd /Users/samjam/Code/bot-bot-bot/2-hermes-life-bot
./scripts/install-skills.sh
./scripts/setup-cron.sh
hermes gateway status   # start gateway if needed: hermes gateway run
hermes
```

## Slash commands

| Command | Purpose |
| --- | --- |
| `/life-core` | Capture protocol (`note:`, `done:`, `snooze:`) |
| `/loose-ends` | Evening follow-up review |
| `/digest` | Morning context (stub) |
| `/ops` | Life admin checklist (stub) |
| `/radar` | Opportunity scan (stub) |

Preload both capture and review:

```bash
hermes chat -s life-core,loose-ends
```

## Messaging

- **WhatsApp** — primary capture + evening digest (cron).
- **Telegram** — backup capture; same prefixes: `note:`, `done:`, `snooze:`, `review`.

See [AGENTS.md](AGENTS.md) for full rules.

## Layout

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Hermes workspace brain |
| `inbox/` | Raw daily captures |
| `store/commitments.jsonl` | Structured follow-ups |
| `digests/` | Evening/morning written reviews |
| `memory/` | Long-lived context + `paths.md` |
| `tasks/` | Active priorities + `routines/ops.md` |
| `skills/` | Hermes skills (installed via `scripts/install-skills.sh`) |
| `Plans/project-plan.md` | Status and per-mode roadmap |

## Cron

Evening job **loose-ends-evening** runs `0 20 * * *` with workdir set to this repo. Override delivery:

```bash
HERMES_CRON_DELIVER=telegram ./scripts/setup-cron.sh
```

## Secrets

Use `.env` or `~/.hermes/.env` for API keys. Not committed.
