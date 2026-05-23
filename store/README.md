# Store

Structured extractions live in `commitments.jsonl` (one JSON object per line).

## Schema

| Field | Required | Description |
| --- | --- | --- |
| `id` | yes | Slug from topic + date, or short uuid |
| `type` | yes | `task`, `commitment`, `follow_up`, `idea`, `expense`, `subscription`, `bug`, `travel`, `research` |
| `text` | yes | Original wording |
| `topic` | yes | Short label for matching `done:` / `snooze:` |
| `time_hint` | no | Free text: `next week`, `Friday`, etc. |
| `urgency` | no | `low`, `medium`, `high` |
| `status` | yes | `open`, `done`, `snoozed` |
| `source` | yes | `whatsapp`, `telegram`, `cli`, `markdown` |
| `created_at` | yes | ISO8601 |
| `last_seen_at` | yes | ISO8601; bump on duplicate topic |
| `snooze_until` | no | ISO8601 when `status` is `snoozed` |
| `completed_at` | no | ISO8601 when `status` is `done` |
| `themes` | no | e.g. `claude_code`, `side_projects` |

## Rules

- Append new lines; do not rewrite the whole file unless deduping one topic.
- Updating an existing topic: rewrite that line only (same `id`) with new `last_seen_at`.
- Never remove lines; mark `done` instead.
