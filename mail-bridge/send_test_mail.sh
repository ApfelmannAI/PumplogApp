#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "Fehlt: .env (erst cp .env.example .env und SMTP_PASS setzen)"
  exit 1
fi

docker compose run --rm \
  -e MAIL_SUBJECT="[TEST] OpenClaw E-Mail Verbindung" \
  -e MAIL_BODY="Test erfolgreich. Zeit (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')" \
  mailer python /app/scripts/send_mail.py
