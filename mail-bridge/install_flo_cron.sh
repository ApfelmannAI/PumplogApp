#!/usr/bin/env sh
set -eu

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_TMP=$(mktemp)

# Keep existing crontab except our managed block
(crontab -l 2>/dev/null || true) | awk '
  BEGIN{skip=0}
  /# BEGIN OPENCLAW_FLO_FUNFACT/{skip=1;next}
  /# END OPENCLAW_FLO_FUNFACT/{skip=0;next}
  skip==0{print}
' > "$CRON_TMP"

cat >> "$CRON_TMP" <<EOF
# BEGIN OPENCLAW_FLO_FUNFACT
# Zwei zufällige Zeitpunkte pro Tag in zwei Zeitfenstern (UTC):
# Fenster 1: 08-13 Uhr + random delay bis 4h
# Fenster 2: 14-20 Uhr + random delay bis 4h
0 8 * * * cd $BASE_DIR && sleep \$(awk 'BEGIN{srand(); print int(rand()*14400)}') && /bin/sh ./send_flo_funfact.sh >> /tmp/flo_funfact.log 2>&1
0 14 * * * cd $BASE_DIR && sleep \$(awk 'BEGIN{srand(); print int(rand()*14400)}') && /bin/sh ./send_flo_funfact.sh >> /tmp/flo_funfact.log 2>&1
# END OPENCLAW_FLO_FUNFACT
EOF

crontab "$CRON_TMP"
rm -f "$CRON_TMP"
echo "FLO_CRON_INSTALLED"
