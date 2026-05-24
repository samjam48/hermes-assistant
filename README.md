# hermes-life-bot

Local workspace for [Hermes](https://github.com/NousResearch/hermes-agent) — memory, follow-ups, and life admin (not trading).

**Production deployment:** Hermes runs in **Docker** and handles WhatsApp, Telegram, and cron. The repo is bind-mounted into the container; edits here affect the live agent immediately.

→ **[Docker deployment guide](docs/docker-deployment.md)** — architecture, first-time setup, coming back after a break, and how to deploy updates that reach WhatsApp/Telegram.

## Quick reference

| Task | Command |
| --- | --- |
| Check gateway is up | `docker ps \| grep hermes` |
| View logs | `docker logs -f hermes` |
| Fix skills/workspace wiring | `./scripts/setup-docker-gateway.sh` |
| List skills | `hermes skills list \| grep life-core` |
| Test locally (not WhatsApp) | `hermes chat -s life-core,loose-ends` |
| Evening cron setup | `./scripts/setup-cron.sh` |

**Talk to the live agent:** WhatsApp (primary) or Telegram — not the host `hermes chat` session.

## Messaging

Send on WhatsApp or Telegram:

| Input | Action |
| --- | --- |
| `note: …` | Capture to inbox + commitments |
| `done: …` | Mark commitment done |
| `snooze: topic 7d` | Snooze a commitment |
| `review` | Run loose-ends digest |
| `/loose-ends` | Same as review |

See [AGENTS.md](AGENTS.md) for full rules.

## Slash commands

| Command | Purpose |
| --- | --- |
| `/life-core` | Capture protocol |
| `/loose-ends` | Evening follow-up review |
| `/digest` | Morning context (stub) |
| `/ops` | Life admin checklist (stub) |
| `/radar` | Opportunity scan (stub) |

## Layout

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Hermes workspace brain |
| `inbox/` | Raw daily captures |
| `store/commitments.jsonl` | Structured follow-ups |
| `digests/` | Evening/morning written reviews |
| `memory/` | Long-lived context + `paths.md` |
| `tasks/` | Active priorities + `routines/ops.md` |
| `skills/` | Hermes skills (`life-core`, `loose-ends`, …) |
| `docs/docker-deployment.md` | **How Docker deployment works** |
| `docs/whatsapp-docker-setup.md` | WhatsApp-specific setup |
| `scripts/` | Setup and maintenance scripts |
| `Plans/project-plan.md` | Status and per-mode roadmap |

## Deploying changes

Most repo edits (`AGENTS.md`, `skills/`, `memory/`, data files) are **live immediately** — the repo is mounted at `/workspace` in the container.

After changing `~/.hermes` config or env:

```bash
./scripts/setup-docker-gateway.sh   # or: docker restart hermes
```

After changing cron schedule or delivery:

```bash
./scripts/setup-cron.sh
```

Full details: [docs/docker-deployment.md](docs/docker-deployment.md#deploying-updates-that-affect-the-live-agent).

## Cron

Evening job **loose-ends-evening** runs at **20:00 Europe/Lisbon**, delivers to WhatsApp, writes `digests/YYYY-MM-DD-evening.md`.

```bash
HERMES_CRON_DELIVER=telegram ./scripts/setup-cron.sh   # override delivery
```

## Secrets

API keys and messaging tokens live in `~/.hermes/.env`. Not committed.
