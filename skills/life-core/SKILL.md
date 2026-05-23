---
name: life-core
description: Capture, classify, and store notes for the Hermes life bot workspace (inbox + commitments store).
version: 1.0.0
metadata:
  hermes:
    tags: [life, capture, memory]
    category: productivity
---

# Life core — capture and store

Shared protocol for all life-bot modes. Read `AGENTS.md` in the workspace root.

## When to use

- User sends `note:`, `done:`, or `snooze:` (any channel)
- User pastes text to capture without a slash command
- Before **loose-ends** review (ensure today's inbox is processed)

## Capture (`note:`)

1. Determine today's date (Europe/Lisbon). Append to `inbox/YYYY-MM-DD.md`:

   ```markdown
   ## HH:MM [whatsapp|telegram|cli]

   <raw text without note: prefix>
   ```

2. Classify `type`: `task`, `commitment`, `follow_up`, `idea`, `expense`, `subscription`, `bug`, `travel`, `research`.

3. Extract: `topic` (short), `time_hint`, `urgency` (`low`|`medium`|`high`).

4. Set `themes` if applicable: `claude_code` (agents, Hermes, Cursor experiments), `side_projects` (side repos, drift).

5. **Dedup:** If `topic` matches an open row in `store/commitments.jsonl`, update that line (`last_seen_at` now, merge `text` if new detail). Else append new JSON line per `store/README.md`.

6. Confirm briefly: topic + type + status.

## Done (`done:`)

1. Parse topic or id after `done:`.
2. Find best match in `store/commitments.jsonl` (open or snoozed).
3. Set `status: done`, `completed_at` (ISO8601), bump `last_seen_at`.
4. If item is a top priority, remove or check off in `tasks/active.md`.
5. Confirm what was closed.

## Snooze (`snooze:`)

Format: `snooze: <topic> 7d` or `snooze: <topic> 14d` (also accept `1w`, `2w`).

1. Match topic in store.
2. Set `status: snoozed`, `snooze_until` = now + duration.
3. Confirm snooze until date.

## Pitfalls

- Do not create duplicate open rows for the same topic.
- Do not hallucinate captures — only write what the user sent.
- JSONL must be valid JSON per line.

## Verification

- New line in today's inbox file.
- Matching row in `commitments.jsonl` with correct `status`.
