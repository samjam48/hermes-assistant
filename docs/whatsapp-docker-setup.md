# WhatsApp + Docker Hermes

## Home channel (required for outbound)

Hermes needs `WHATSAPP_HOME_CHANNEL` so cron and `send_message` know where to deliver.

In `~/.hermes/.env`:

```bash
WHATSAPP_HOME_CHANNEL=<your-number>@s.whatsapp.net
WHATSAPP_HOME_CHANNEL_NAME=Message yourself
```

Or from the host:

```bash
hermes config set WHATSAPP_HOME_CHANNEL '<your-number>@s.whatsapp.net'
hermes config set WHATSAPP_HOME_CHANNEL_NAME 'Message yourself'
docker restart hermes
```

After a successful inbound message in WhatsApp self-chat, you can also send `/sethome` there (if the gateway registers the command).

## Self-chat inbound

Use **Message yourself** on your phone and send:

```text
note: test
```

If logs show `self_chat_mode_rejects_non_self` for your own number, the bridge in the container may need the self-DM patch (see `scripts/patch-whatsapp-bridge.sh`).

## Terminal inside Docker

Set `terminal.backend: local` in `~/.hermes/config.yaml` when Hermes runs **inside** Docker without mounting `/var/run/docker.sock`. Otherwise `execute_code` fails looking for a nested Docker daemon.

Also set `TERMINAL_ENV=local` in `~/.hermes/.env` (or run `./scripts/setup-docker-gateway.sh`).

## Skills + workspace (required)

Symlinks under `~/.hermes/skills/` point at host paths and **break inside Docker**. Configure skill discovery instead:

```bash
./scripts/setup-docker-gateway.sh
```

This sets:

- `skills.external_dirs`: `/workspace/skills` (+ host path for local CLI)
- `terminal.cwd`: `/workspace` (loads `AGENTS.md` for WhatsApp/Telegram)
- `telegram` / `whatsapp` `channel_prompts` for your home channels
- Cron job `workdir`: `/workspace` (not `/Users/...`)

Verify after restart:

```bash
docker restart hermes
hermes skills list | grep -E 'life-core|loose-ends'
```

## Telegram `/start`

Hermes does not implement Telegram’s `/start` command. Use `note: …` or `/loose-ends` instead.
