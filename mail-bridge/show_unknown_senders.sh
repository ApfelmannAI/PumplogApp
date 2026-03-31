#!/usr/bin/env sh
set -eu

STATE="/data/workspace/mail-bridge/outbox/flo_reply_state.json"
if [ ! -f "$STATE" ]; then
  echo "Keine Daten vorhanden."
  exit 0
fi

python3 - <<'PY'
import json
p='/data/workspace/mail-bridge/outbox/flo_reply_state.json'
with open(p,'r',encoding='utf-8') as f:
    s=json.load(f)
rows=s.get('unknown_senders',[])
if not rows:
    print('Keine unbekannten Absender.')
else:
    for r in rows[-20:]:
        print(f"{r.get('seen_at_utc')} | {r.get('from')} | {r.get('subject')}")
PY
