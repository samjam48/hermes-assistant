# Setup scripts

| Script | Purpose |
| --- | --- |
| `install-skills.sh` | Symlink `skills/*` → `~/.hermes/skills/` for `/loose-ends` etc. |
| `configure-external-skills.sh` | Add repo `skills/` to `~/.hermes/config.yaml` `external_dirs` |
| `setup-cron.sh` | Create `loose-ends-evening` job (20:00, WhatsApp, both skills) |

**Note:** This Hermes install has no `hermes bundles` subcommand. Use `/loose-ends` plus cron `--skill life-core --skill loose-ends`, or `hermes chat -s life-core,loose-ends`.

Re-run `setup-cron.sh` after changing schedule or delivery. Set `HERMES_CRON_DELIVER=telegram` if WhatsApp delivery fails.
