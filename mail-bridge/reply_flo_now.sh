#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "Fehlt: .env"
  exit 1
fi

if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  DC="docker compose"
fi

$DC run --rm \
  -e FLO_EMAIL="${FLO_EMAIL:-florian.kunzweiler@dwarftech.de}" \
  -e IMAP_HOST="${IMAP_HOST:-imap.strato.de}" \
  -e IMAP_PORT="${IMAP_PORT:-993}" \
  -e MAX_REPLIES_PER_DAY="${MAX_REPLIES_PER_DAY:-2}" \
  mailer python /app/scripts/poll_and_reply_flo.py
