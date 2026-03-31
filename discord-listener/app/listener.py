import json
import os
from datetime import datetime, timezone

import discord
import requests
from dotenv import load_dotenv

load_dotenv()

TOKEN = os.getenv("DISCORD_BOT_TOKEN", "").strip()
GUILD_ID = int(os.getenv("DISCORD_GUILD_ID", "0") or 0)
BOT_NAME = os.getenv("BOT_NAME", "ApfelsOpenClaw")
MONITOR_ALL = os.getenv("MONITOR_ALL_CHANNELS", "true").lower() in {"1", "true", "yes", "on"}
ALLOWED_CHANNEL_IDS = {
    int(x.strip()) for x in os.getenv("ALLOWED_CHANNEL_IDS", "").split(",") if x.strip().isdigit()
}
COMMAND_PREFIX = os.getenv("COMMAND_PREFIX", f"@{BOT_NAME}")
WEBHOOK = os.getenv("OPENCLAW_EVENT_WEBHOOK", "").strip()
BEARER = os.getenv("OPENCLAW_EVENT_BEARER", "").strip()
INBOX_PATH = os.getenv("INBOX_PATH", "/data/outbox/discord_inbox.jsonl")

if not TOKEN:
    raise SystemExit("Missing DISCORD_BOT_TOKEN")

intents = discord.Intents.default()
intents.guilds = True
intents.messages = True
intents.message_content = True

client = discord.Client(intents=intents)


def allowed_channel(channel_id: int) -> bool:
    if MONITOR_ALL:
        return True
    return channel_id in ALLOWED_CHANNEL_IDS


def append_inbox(event: dict):
    os.makedirs(os.path.dirname(INBOX_PATH), exist_ok=True)
    with open(INBOX_PATH, "a", encoding="utf-8") as f:
        f.write(json.dumps(event, ensure_ascii=False) + "\n")


def forward_webhook(event: dict):
    if not WEBHOOK:
        return
    headers = {"Content-Type": "application/json"}
    if BEARER:
        headers["Authorization"] = f"Bearer {BEARER}"
    try:
        requests.post(WEBHOOK, headers=headers, json=event, timeout=10)
    except Exception:
        pass


@client.event
async def on_ready():
    print(f"LISTENER_READY:{client.user}")


@client.event
async def on_message(message: discord.Message):
    if message.author.bot:
        return
    if GUILD_ID and (not message.guild or message.guild.id != GUILD_ID):
        return
    if not message.guild:
        return
    if not allowed_channel(message.channel.id):
        return

    content = (message.content or "").strip()
    mentioned = client.user in message.mentions if client.user else False

    is_command = mentioned or content.lower().startswith(COMMAND_PREFIX.lower())
    if not is_command:
        return

    event = {
        "type": "discord_mention",
        "at": datetime.now(timezone.utc).isoformat(),
        "guild_id": str(message.guild.id),
        "channel_id": str(message.channel.id),
        "message_id": str(message.id),
        "author": {
            "id": str(message.author.id),
            "name": message.author.display_name,
        },
        "content": content,
    }

    append_inbox(event)
    forward_webhook(event)

    await message.reply("✅ Mention erkannt. Ich habe den Trigger erfasst und weitergegeben.")


client.run(TOKEN)
