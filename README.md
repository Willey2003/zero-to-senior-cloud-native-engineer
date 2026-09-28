# Zero to Cloud-Native Engineer: Labs and Roadmap

This repository is a complete, hands-on learning path for someone starting with
**no Linux, networking or coding background** who wants to become a senior
Cloud-Native / DevOps / Platform / Security engineer.

Every lab is written so you can follow it with zero prior knowledge. Each one has:

- **Why this matters**: what it is, in plain words, and where you will meet it at work
- **Concepts**: the few ideas you must understand before typing anything
- **Hands-on steps**: exact commands, with what you should see
- **Real-world scenario**: a broken system you must fix, like an on-call ticket
- **Check yourself**: questions and tasks that prove you learned it
- **Cert mapping**: which exam objectives the lab covers

## How to use this repo

1. Read [ROADMAP.md](ROADMAP.md) once, end to end. It is the plan.
2. Read [CERTIFICATIONS.md](CERTIFICATIONS.md) to see every exam, its order and why.
3. Start at [labs/00-setup](labs/00-setup/README.md) and go in number order. Do not skip.
4. Keep a learning journal in `journal/` (one file per week). Write what broke and how you fixed it.
   This journal becomes your interview story bank.
5. Every time you finish a lab, commit your work with Git. Your GitHub history is your proof of work.

## Folder map

| Folder | Topic | Certifications it feeds |
|---|---|---|
| `labs/00-setup` | Your lab computer, VMs, Git, VS Code | - |
| `labs/01-linux` | Linux from absolute zero to admin | LFCS, RHCSA |
| `labs/02-networking` | How the internet works, TCP/IP, DNS, firewalls | Foundation for everything |
| `labs/03-bash-git-python` | Scripting and programming | Foundation, CKAD, automation |
| `labs/04-docker` | Containers basic to advanced | - |
| `labs/05-docker-networking-security` | Docker networks, hardening, image scanning | CKS foundation |
| `labs/06-cloud-aws-terraform` | Cloud, infrastructure as code | AWS SAA, Terraform Associate |
| `labs/07-kubernetes-core` | Kubernetes fundamentals to admin | KCNA, CKAD, CKA |
| `labs/08-kubernetes-networking` | CNI, Services, Ingress, Gateway API, NetworkPolicy, Cilium | CKA, CCA |
| `labs/09-kubernetes-security` | RBAC, Pod Security, supply chain, Falco, Kyverno | KCSA, CKS, KCA |
| `labs/10-redhat-ansible` | RHEL admin and Ansible automation | RHCSA, RHCE |
| `labs/11-observability` | Prometheus, Grafana, OpenTelemetry | PCA, OTCA |
| `labs/12-gitops-delivery` | CI/CD, Argo CD, Argo Rollouts | CGOA, CAPA |
| `labs/13-service-mesh` | Istio, Envoy, Kiali | ICA |
| `labs/14-platform-engineering` | Backstage, platform APIs, golden paths | CBA, CNPA, CNPE |
| `labs/15-openshift` | OpenShift and OpenShift Virtualization | EX280, EX316, RHCA path |
| `labs/16-cloud-security` | IAM, KMS, detection, CSPM, policy as code | AWS Security Specialty |
| `labs/17-ai-mlops` | AI basics, LLM apps, serving models on Kubernetes | - |
| `labs/18-ai-security` | Securing AI and LLM systems | - |
| `scenarios/` | 30 real-time on-call break/fix scenarios | Interview prep |
| `capstone/` | One production-grade platform project combining everything | Portfolio |

## Golden rules

- **Type every command yourself.** Never copy-paste until you have typed it at least once.
- **Break things on purpose.** The fastest way to learn is to fix what you broke.
- **One hour of reading = two hours of lab.** Reading alone does not stick.
- **Explain it out loud.** If you cannot explain it to a friend in simple words, you do not know it yet.
