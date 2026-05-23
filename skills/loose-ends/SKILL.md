---
name: loose-ends
description: Evening follow-up review — stale commitments, recurring topics, digest for WhatsApp.
version: 1.0.0
metadata:
  hermes:
    tags: [life, follow-up, digest]
    category: productivity
---

# Loose ends — follow-up review

Run **life-core** capture logic first if the message is `note:`, `done:`, or `snooze:`. For `review` or `/loose-ends`, run this review only.

Read `AGENTS.md`. Workspace paths are relative to the Hermes working directory (this repo).

## When to use

- `/loose-ends` or user says `review`
- Scheduled evening job (20:00 Europe/Lisbon)
- User asks what they forgot or what's still open

## Procedure

1. Read `store/commitments.jsonl` — all rows where `status` is `open`, or `snoozed` with `snooze_until` in the past.

2. Read last 7 days of `inbox/*.md` and `tasks/active.md`.

3. Optionally read paths in `memory/paths.md` if user recently captured related topics (Phase 1: do not scan all paths automatically).

4. **Heuristics** (cite evidence from store/inbox only):

   | Signal | Rule |
   | --- | --- |
   | Stale | `last_seen_at` older than **7 days** |
   | Recurring | Same `topic` **3+** times in 14 days (inbox or store) |
   | Overdue hint | `time_hint` sounds past due (best effort) |
   | Theme nudge | `themes` includes `claude_code` or `side_projects` — group under subheading |

5. Write **`digests/YYYY-MM-DD-evening.md`**:

   ```markdown
   # Evening loose ends — YYYY-MM-DD

   ## Summary
   (one paragraph)

   ## Open loops
   - ...

   ## Stale (7d+)
   - ...

   ## Recurring topics
   - ...

   ## Theme: Claude Code / agents
   - ... (if any)

   ## Theme: Side projects
   - ... (if any)
   ```

6. **WhatsApp / chat reply:** 3–7 bullets max, factual tone. Example lines:

   - "You mentioned chasing the VAT invoice but never followed up."
   - "Side project X: last noted 8 days ago."

7. If nothing is open, say so honestly — do not invent items.

## Pitfalls

- Guilt-tripping or coaching tone — mirror only.
- Listing tasks not in store/inbox/tasks.
- Skipping writing the digest file.

## Verification

- `digests/YYYY-MM-DD-evening.md` exists for today.
- Every bullet maps to a store or inbox line.
