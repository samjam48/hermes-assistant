# Hermes life bot — project plan (draft)

## Intent

Use Hermes as a persistent assistant for **memory**, **task plans**, and **follow-through** on personal goals—not trading, backtests, or exchange APIs.

## Out of scope (removed from trading fork)

- Strategy code, backtests, OHLCV data, trade logs
- Exchange/broker integration and market-specific agent turns

## To decide later

- What belongs in `memory/` vs Hermes skill files
- Task formats (daily review, weekly plan, project templates)
- Integrations (calendar, Notion, reminders) if any
- Default instructions and guardrails in `instructions/`

## Next step when ready

Agree on a small first workflow (for example: “capture + weekly review”), then flesh out `instructions/` and one example under `tasks/`.
