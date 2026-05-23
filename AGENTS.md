# Hermes life bot workspace

Personal assistant for memory, follow-ups, and life admin—not trading or market automation.

## Always read first

- `store/commitments.jsonl` — structured open loops
- `inbox/` — raw captures (today's file: `inbox/YYYY-MM-DD.md`)
- `tasks/active.md` — current priorities
- `memory/paths.md` — external TODO markdown paths (read when relevant)

## Capture protocol (WhatsApp, Telegram, CLI)

| Prefix | Action |
| --- | --- |
| `note:` | Append raw text to today's `inbox/YYYY-MM-DD.md`, classify, append/update `store/commitments.jsonl` |
| `done:` | Match topic or id in store; set `status: done`, `completed_at` |
| `snooze:` | Format `snooze: <topic> 7d` — set `status: snoozed`, `snooze_until` |
| `review` | Run evening loose-ends digest (same as `/loose-ends`) |

Paste email snippets, issue URLs, tab lists, or Slack excerpts inside `note:` — no separate integration required.

## Loose-ends review (evening or on-demand)

When running `/loose-ends` or a scheduled review:

1. Load **life-core** and **loose-ends** skill procedures.
2. Read all `status: open` rows in `store/commitments.jsonl` (skip `snoozed` until `snooze_until` passed).
3. Apply heuristics: **stale = 7 days** without update; **recurring = 3+** same `topic` in 14 days; overdue `time_hint`.
4. Emphasize themes: **Claude Code / agent experiments**, **side-project drift** (group if matching).
5. Write `digests/YYYY-MM-DD-evening.md` (full detail).
6. Reply with **3–7 bullets** for WhatsApp — factual, no guilt-tripping. Only cite real store/inbox rows.

## Safety

- Never delete `inbox/`, `store/`, or `memory/` without explicit user approval.
- Do not invent tasks not present in store/inbox/tasks.
- No trading, backtests, or exchange automation unless explicitly asked once.

## Other modes (stubs until built)

- `/digest` — morning context (Phase 2)
- `/ops` — monthly life admin checklist (Phase 3)
- `/radar` — opportunity scan (Phase 4)
