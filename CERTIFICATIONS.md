# Certifications: What, Why, and In Which Order

Exam formats, prices and objectives change. **Always confirm on the official page before booking.**
Linux Foundation (LF) exams usually include one free retake and are heavily discounted during sales
(Cyber Monday, KubeCon). Buy bundles (e.g. Kubestronaut bundle) during a sale to save a lot.

## Order and reasoning

| # | Cert | Full name | Issuer | Format | Why here |
|---|---|---|---|---|---|
| 1 | RHCSA (EX200) | Red Hat Certified System Administrator | Red Hat | Hands-on, ~2.5h | Proves Linux admin. Most recognised Linux cert in Indian hiring. |
| 2 | AWS SAA | AWS Solutions Architect Associate | AWS | Multiple choice | Most requested cloud cert in job posts. |
| 3 | Terraform Associate (optional) | HashiCorp Terraform Associate | HashiCorp | Multiple choice | Infrastructure as code proof. |
| 4 | LFCS (optional now, needed later) | Linux Foundation Certified SysAdmin | LF | Hands-on | Required for Golden Kubestronaut. Easy after RHCSA. |
| 5 | KCNA | Kubernetes and Cloud Native Associate | CNCF/LF | Multiple choice, 90 min | Gentle entry into Kubernetes vocabulary. |
| 6 | CKAD | Certified Kubernetes Application Developer | CNCF/LF | Hands-on, 2h | Builds `kubectl` speed; easier than CKA. |
| 7 | CKA | Certified Kubernetes Administrator | CNCF/LF | Hands-on, 2h | The core Kubernetes job cert. |
| 8 | KCSA | Kubernetes and Cloud Native Security Associate | CNCF/LF | Multiple choice, 90 min | Security theory before CKS. |
| 9 | CKS | Certified Kubernetes Security Specialist | CNCF/LF | Hands-on, 2h | Hardest, highest value. Needs an active CKA. |
| - | **Kubestronaut** | KCNA+KCSA+CKAD+CKA+CKS | CNCF | Title | Jacket, discounts, community badge. |
| 10 | RHCE (EX294) | Red Hat Certified Engineer | Red Hat | Hands-on, ~4h | Ansible automation. Needed for RHCA. |
| 11 | PCA | Prometheus Certified Associate | CNCF/LF | Multiple choice | Monitoring, PromQL. |
| 12 | OTCA | OpenTelemetry Certified Associate | CNCF/LF | Multiple choice | Tracing and telemetry. |
| 13 | CGOA | Certified GitOps Associate | CNCF/LF | Multiple choice | GitOps principles. |
| 14 | CAPA | Certified Argo Project Associate | CNCF/LF | Multiple choice | Argo CD, Rollouts, Workflows, Events. |
| 15 | ICA | Istio Certified Associate | CNCF/LF | Hands-on | Service mesh. |
| 16 | CCA | Cilium Certified Associate | CNCF/LF | Multiple choice | eBPF networking and security. |
| 17 | KCA | Kyverno Certified Associate | CNCF/LF | Multiple choice | Policy as code for Kubernetes. |
| 18 | CBA | Certified Backstage Associate | CNCF/LF | Multiple choice | Developer portals. |
| 19 | CNPA | Certified Cloud Native Platform Engineering Associate | CNCF/LF | Multiple choice | Platform engineering concepts. |
| 20 | CNPE | Certified Cloud Native Platform Engineer | CNCF/LF | Hands-on | Advanced platform engineering. |
| - | **Golden Kubestronaut** | All CNCF certs + LFCS | CNCF | Title | Rare, strong signal. Check the current required list. |
| 21 | EX280 | Red Hat Certified OpenShift Administrator | Red Hat | Hands-on | OpenShift admin; RHCA elective. |
| 22 | EX316 | Red Hat Certified Specialist in OpenShift Virtualization | Red Hat | Hands-on | VMs on OpenShift; high demand (VMware migrations). |
| 23 | AWS Security Specialty | AWS Certified Security - Specialty | AWS | Multiple choice | Cloud security specialisation. |
| 24 | RHCA | Red Hat Certified Architect | Red Hat | RHCE + 5 expertise exams | Long-term; pick electives aligned with OpenShift/automation. |

## Exam-day tips for hands-on exams (CKA/CKAD/CKS/ICA/CNPE/Red Hat)
- Set up alias `k=kubectl` and `export do="--dry-run=client -o yaml"` in the first minute.
- Always check which cluster/context you are on before every question (`kubectl config use-context ...`).
- Skip any question worth less than 4% that takes more than 5 minutes; come back later.
- Use imperative commands to generate YAML, then edit: `k run web --image=nginx $do > pod.yaml`.
- Red Hat exams: everything must **survive a reboot**. Reboot and verify before you finish.

## Tracker

Copy this into your journal and tick them off:

```
[ ] RHCSA        [ ] AWS SAA      [ ] Terraform     [ ] LFCS
[ ] KCNA         [ ] CKAD         [ ] CKA           [ ] KCSA        [ ] CKS
[ ] RHCE         [ ] PCA          [ ] OTCA          [ ] CGOA        [ ] CAPA
[ ] ICA          [ ] CCA          [ ] KCA           [ ] CBA         [ ] CNPA     [ ] CNPE
[ ] EX280        [ ] EX316        [ ] AWS Security  [ ] RHCA electives
```
