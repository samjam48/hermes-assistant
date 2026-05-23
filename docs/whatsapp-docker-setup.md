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

## Telegram `/start`

Hermes does not implement Telegram’s `/start` command. Use `note: …` or `/loose-ends` instead.
