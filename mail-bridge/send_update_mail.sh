#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "Fehlt: .env"
  exit 1
fi

SUBJECT=${1:-"OpenClaw Update"}
BODY=${2:-"Kein Inhalt übergeben."}

if command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  DC="docker compose"
fi

$DC run --rm \
  -e MAIL_SUBJECT="$SUBJECT" \
  -e MAIL_BODY="$BODY" \
  mailer python /app/scripts/send_mail.py
