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
  mailer python /app/scripts/send_flo_funfact.py
