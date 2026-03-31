#!/usr/bin/env sh
set -eu

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CRON_TMP=$(mktemp)

(crontab -l 2>/dev/null || true) | awk '
  BEGIN{skip=0}
  /# BEGIN OPENCLAW_FLO_REPLY/{skip=1;next}
  /# END OPENCLAW_FLO_REPLY/{skip=0;next}
  skip==0{print}
' > "$CRON_TMP"

cat >> "$CRON_TMP" <<EOF
# BEGIN OPENCLAW_FLO_REPLY
*/15 * * * * cd $BASE_DIR && /bin/sh ./reply_flo_now.sh >> /tmp/flo_reply.log 2>&1
# END OPENCLAW_FLO_REPLY
EOF

crontab "$CRON_TMP"
rm -f "$CRON_TMP"
echo "FLO_REPLY_CRON_INSTALLED"
