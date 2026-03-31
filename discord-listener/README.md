# Discord Listener (Docker)

Fängt Mentions zuverlässig ab und löst einen Trigger aus.

## 1) Setup

```bash
cd /data/workspace/discord-listener
cp .env.example .env
nano .env
```

Pflicht:
- `DISCORD_BOT_TOKEN`

Optional:
- `DISCORD_GUILD_ID` (auf deinen Server begrenzen)
- `MONITOR_ALL_CHANNELS=true`
- `OPENCLAW_EVENT_WEBHOOK` (falls Trigger an externen Endpoint gewünscht)

## 2) Start

```bash
docker compose up -d
```

## 3) Logs

```bash
docker compose logs -f --tail=100
```

## 4) Test
Im Discord-Server schreiben:

`@ApfelsOpenClaw ping`

Der Listener antwortet mit:

`✅ Mention erkannt. Ich habe den Trigger erfasst und weitergegeben.`

## Persistenz
Erkannte Mentions werden gespeichert in:
- `outbox/discord_inbox.jsonl`
