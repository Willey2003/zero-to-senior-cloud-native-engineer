#!/usr/bin/env bash
# SCENARIO: fills /var with a big log that a process keeps open, then deletes it.
[ "$EUID" -eq 0 ] || { echo "run with sudo"; exit 1; }
mkdir -p /var/log/myapp
fallocate -l 1G /var/log/myapp/debug.log
nohup tail -f /var/log/myapp/debug.log >/dev/null 2>&1 &
rm -f /var/log/myapp/debug.log
fallocate -l 500M /var/tmp/.cache-old
echo "Ticket: 'df -h shows space used but I cannot find the files.' Find and free the space."
