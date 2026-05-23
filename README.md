# hermes-life-bot

Local workspace for running [Hermes](https://github.com/NousResearch/hermes) on personal life tasks: memory, plans, and day-to-day follow-through—not trading or market automation.

## Run Hermes

Hermes loads the **current working directory** as the workspace. Always start it from this folder:

```bash
cd /Users/samjam/Code/bot-bot-bot/2-hermes-life-bot
hermes
```

Put secrets in `.env` (for example `OPENAI_API_KEY`). That file is gitignored if you re-init version control later.

### Suggested settings

- **max_turns:** 20–40 is enough for focused life tasks (capture a note, update a plan, summarize a week). Use `/config set agent.max_turns 90` only when you need a longer research or refactor session.

## Layout

| Path | Purpose |
| --- | --- |
| `instructions/` | How Hermes should behave in this workspace (tone, priorities, what to read first) |
| `memory/` | Durable notes and context you want the agent to use across sessions |
| `tasks/` | Active plans, checklists, and recurring routines |
| `Plans/` | Human-written project direction (not agent skills) |

Trading backtests, strategies, and market data caches were removed when this repo was forked from the trading bot.
