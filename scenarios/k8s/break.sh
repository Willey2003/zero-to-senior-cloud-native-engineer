#!/usr/bin/env bash
# Break a kind/kubeadm lab cluster on purpose. Usage: ./break.sh <14|15|16|20|21>
# Needs the 'shop' namespace from labs/07-kubernetes-core/manifests/lab-api.yaml applied first.
set -euo pipefail
case "${1:-}" in
  14) kubectl -n shop create deploy crashy --image=busybox -- sh -c 'echo "DB_URL not set"; exit 1'
      echo "Ticket: 'crashy' keeps restarting. Find why." ;;
  15) kubectl -n shop create deploy greedy --image=nginx
      kubectl -n shop set resources deploy greedy --requests=cpu=64,memory=512Gi
      echo "Ticket: 'greedy' pods never start." ;;
  16) kubectl -n shop patch svc api -p '{"spec":{"selector":{"app":"api-v1"}}}'
      echo "Ticket: 'curl api.shop' hangs but pods are Running." ;;
  20) kubectl -n kube-system scale deploy coredns --replicas=0
      echo "Ticket: 'Nothing in the cluster can resolve names.'" ;;
  21) kubectl -n shop patch deploy api --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/ready"}]'
      echo "Ticket: 'The new rollout has been stuck for 20 minutes.'" ;;
  *)  echo "usage: $0 <14|15|16|20|21>"; exit 1 ;;
esac
