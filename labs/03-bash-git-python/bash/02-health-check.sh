#!/usr/bin/env bash
# Server health check. Exit code 0 = healthy, 1 = warning, 2 = critical.
# Usage: ./02-health-check.sh [disk_threshold_percent] ; put it in cron every 5 minutes.
set -euo pipefail
DISK_LIMIT="${1:-80}"
MEM_LIMIT=90
SERVICES=(sshd crond)
status=0
log() { echo "$(date '+%F %T') [$1] $2"; }

while read -r use mount; do
  pct=${use%\%}
  if (( pct >= DISK_LIMIT )); then log CRIT "disk $mount at ${pct}%"; status=2; fi
done < <(df -P --output=pcent,target -x tmpfs -x devtmpfs | tail -n +2)

mem=$(free | awk '/Mem:/ {printf "%d", $3/$2*100}')
if (( mem >= MEM_LIMIT )); then log WARN "memory at ${mem}%"; (( status < 1 )) && status=1; fi

for s in "${SERVICES[@]}"; do
  systemctl is-active --quiet "$s" || { log CRIT "service $s down"; status=2; }
done

(( status == 0 )) && log OK "all checks passed"
exit $status
