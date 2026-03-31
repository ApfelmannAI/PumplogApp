#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "Fehlt: .env"
  exit 1
fi

SUBJECT=${1:-"OpenClaw Update"}
BODY=${2:-"Kein Inhalt übergeben."}

docker compose run --rm \
  -e MAIL_SUBJECT="$SUBJECT" \
  -e MAIL_BODY="$BODY" \
  mailer python /app/scripts/send_mail.py
