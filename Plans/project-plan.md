# Hermes life bot — project plan

One workspace, four modes (skills). Phase 1 complete for **loose-ends**; others stubbed.

## Status

| Mode | Command | Phase | Status |
| --- | --- | --- | --- |
| Loose ends | `/loose-ends` | 1 | **Wired** — capture, store, evening cron |
| Context digest | `/digest` | 2 | Stub skill |
| Personal ops | `/ops` | 3 | Stub + `tasks/routines/ops.md` template |
| Opportunity radar | `/radar` | 4 | Stub + `memory/interests.md` |

## Setup (once per machine)

```bash
cd /Users/samjam/Code/bot-bot-bot/2-hermes-life-bot
./scripts/install-skills.sh          # links skills to ~/.hermes/skills/
./scripts/setup-cron.sh              # 20:00 daily loose-ends → WhatsApp
hermes gateway status                # ensure gateway running for messaging
```

Optional: `./scripts/configure-external-skills.sh` instead of symlinks.

Run Hermes from this directory:

```bash
hermes
# or with skills preloaded:
hermes chat -s life-core,loose-ends
```

## Capture (WhatsApp / Telegram / CLI)

| Input | Effect |
| --- | --- |
| `note: …` | `inbox/YYYY-MM-DD.md` + `store/commitments.jsonl` |
| `done: …` | Mark done in store |
| `snooze: … 7d` | Snooze in store |
| `review` or `/loose-ends` | Evening digest + `digests/YYYY-MM-DD-evening.md` |

## Layout

- `AGENTS.md` — workspace rules
- `inbox/` — raw captures
- `store/commitments.jsonl` — structured items
- `digests/` — written reviews
- `memory/paths.md` — external TODO paths you maintain
- `skills/` — version-controlled skills (symlinked to `~/.hermes/skills/`)

## Mode summaries

### Loose ends (operational)

- Stale: 7 days · Recurring: 3+ mentions / 14 days
- Themes: Claude Code experiments, side-project drift
- Cron: 20:00 Europe/Lisbon → WhatsApp (see `scripts/setup-cron.sh`)

### Digest (Phase 2)

Morning 08:00 Lisbon; breadcrumbs: TODO paths, pasted tabs, voice notes.

### Ops (Phase 3)

Monthly; visa/passport + machine backup first.

### Radar (Phase 4)

Max 5 items/day; HN, GitHub trending, Twitter lists; interests in `memory/interests.md`.

## Next steps

1. Send `note: test capture` on WhatsApp; confirm `inbox/` and `store/` update.
2. Run `/loose-ends` in CLI from this workspace.
3. Add real paths to `memory/paths.md` when ready.
4. Flesh out Phase 2 `/digest` in a dedicated implementation plan.
