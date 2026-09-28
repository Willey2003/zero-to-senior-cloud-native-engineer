#!/usr/bin/env bash
# Create a private CA and a server certificate for "web.lab.local". Understand every line.
set -euo pipefail
mkdir -p certs && cd certs
openssl genrsa -out ca.key 4096
openssl req -x509 -new -key ca.key -days 365 -subj "/CN=My Lab CA" -out ca.crt
openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=web.lab.local" -out server.csr
printf "subjectAltName=DNS:web.lab.local,IP:127.0.0.1\n" > san.ext
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 90 -extfile san.ext -out server.crt
openssl x509 -in server.crt -noout -subject -issuer -dates -ext subjectAltName
echo "Test: curl --cacert certs/ca.crt https://web.lab.local  (after configuring nginx and /etc/hosts)"
