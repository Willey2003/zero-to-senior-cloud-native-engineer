# Real-Time On-Call Scenarios

Treat each one like a real ticket: set a 30-minute timer, write down your hypothesis before each command,
and write a short post-mortem in your journal afterwards (What happened? How did you find it? How do we prevent it?).
Scripts in `k8s/` break a kind cluster on purpose. Run `k8s/break.sh <number>` and then fix it.

| # | Area | Ticket | Skills |
|---|---|---|---|
| 1 | Linux | Web server down after reboot | systemd, SELinux, firewalld |
| 2 | Linux | Disk full but files not visible | du, lsof, deleted open files |
| 3 | Linux | SSH login refused for one user | permissions on ~/.ssh, sshd_config, journal |
| 4 | Linux | Server extremely slow | top, iostat, vmstat, OOM killer in dmesg |
| 5 | Network | App can't reach DB by name | DNS, /etc/hosts, resolv.conf |
| 6 | Network | Timeout vs connection refused | ss, firewall, routes, tcpdump |
| 7 | Network | TLS certificate expired in prod | openssl, cert renewal, monitoring |
| 8 | Docker | Container restarts every 30 s | OOMKilled, healthcheck, logs |
| 9 | Docker | Containers can't talk to each other | networks, DNS, docker inspect |
| 10 | Docker | Image has 40 critical CVEs | trivy, base image, multi-stage |
| 11 | Cloud | Private EC2 can't reach internet | route tables, NAT gateway |
| 12 | Cloud | Surprise bill | Cost Explorer, budgets, tagging |
| 13 | Cloud | Leaked access key | IR runbook, CloudTrail |
| 14 | K8s | CrashLoopBackOff | logs --previous, env, command |
| 15 | K8s | Pending pods | requests, taints, PVC binding |
| 16 | K8s | Service has no endpoints | selectors, labels, targetPort |
| 17 | K8s | Node NotReady | kubelet, containerd, certificates |
| 18 | K8s | API server down | static pod manifest, crictl, logs |
| 19 | K8s | etcd data loss | snapshot restore |
| 20 | K8s | DNS broken cluster-wide | CoreDNS, NetworkPolicy |
| 21 | K8s | Deployment rollout stuck | readiness probe, maxUnavailable |
| 22 | Security | SA can read all secrets | RBAC audit |
| 23 | Security | Crypto-miner in pod | Falco, audit log, containment |
| 24 | Security | Privileged pod slipped into prod | PSA, Kyverno |
| 25 | Observability | Alert fatigue | SLO burn-rate alerts |
| 26 | GitOps | Prod drifted from Git | Argo CD diff, self-heal |
| 27 | Mesh | 503 NR from Istio | istioctl analyze, DestinationRule subsets |
| 28 | Mesh | mTLS broke legacy client | PeerAuthentication PERMISSIVE |
| 29 | OpenShift | SCC blocks pod | SCC, ServiceAccount |
| 30 | AI | RAG bot leaked tenant data | vector DB filters, authz |

## Post-mortem template
```
Title:
Date / duration / impact:
Timeline (UTC):
Root cause:
How it was detected:
How it was fixed:
What went well / what went badly:
Action items (owner, due date):
```
