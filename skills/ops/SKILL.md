---
name: ops
description: Personal life admin checklist — visa, backups (Phase 3; stub in Phase 1).
version: 0.1.0
metadata:
  hermes:
    tags: [life, admin]
    category: productivity
---

# Personal ops (stub)

**Not fully wired yet.** Target cadence: **monthly** when built.

## Phase 1

1. Ensure `tasks/routines/ops.md` exists (create from template if missing).
2. Tell the user to fill `last_checked` dates for:
   - Visa / passport expiry
   - Machine backup
3. On `/ops`, read that file and list items due or overdue only — no invented dates.

## Template for `tasks/routines/ops.md`

```markdown
# Life ops

| Item | Next due | Last checked | Notes |
| --- | --- | --- | --- |
| Passport expiry | YYYY-MM-DD | | |
| Machine backup | | YYYY-MM-DD | |
```

## Phase 2

Monthly cron + optional `ops: checked backup` chat prefix.
