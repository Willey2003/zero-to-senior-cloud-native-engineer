#!/usr/bin/env bash
# Bash basics in one file. Run: bash 01-basics.sh Alice
set -euo pipefail           # stop on errors, unset variables, and failed pipes

name="${1:-World}"          # first argument, default "World"
echo "Hello, ${name}!"

# if / else
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  echo "You are running: ${PRETTY_NAME}"
else
  echo "Not Linux?"
fi

# loops
for svc in sshd crond; do
  if systemctl is-active --quiet "$svc" 2>/dev/null; then
    echo "$svc is running"
  else
    echo "$svc is NOT running"
  fi
done

# functions and return codes
is_port_open() {            # usage: is_port_open host port
  timeout 2 bash -c "</dev/tcp/$1/$2" 2>/dev/null
}
if is_port_open 127.0.0.1 22; then echo "port 22 open"; else echo "port 22 closed"; fi

# command substitution and arithmetic
files=$(ls /etc | wc -l)
echo "There are $files entries in /etc, doubled that is $(( files * 2 ))"

# while-read loop over a file (the correct way)
while IFS=: read -r user _ uid _; do
  (( uid >= 1000 && uid < 65000 )) && echo "human user: $user"
done < /etc/passwd
