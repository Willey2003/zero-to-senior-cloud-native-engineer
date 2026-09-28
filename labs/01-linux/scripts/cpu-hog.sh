#!/usr/bin/env bash
# SCENARIO: starts a background process that burns CPU with an innocent-looking name.
bash -c 'exec -a "[kworker/fake]" bash -c "while :; do :; done"' &
echo "Ticket: 'Server is slow since 10 minutes.' Find the culprit."
