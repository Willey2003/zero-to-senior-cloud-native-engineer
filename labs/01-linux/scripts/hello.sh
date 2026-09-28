#!/usr/bin/env bash
# A tiny program that writes a timestamp every 10 seconds. Used to learn systemd services.
while true; do
  echo "$(date '+%F %T') hello from my first service"
  sleep 10
done
