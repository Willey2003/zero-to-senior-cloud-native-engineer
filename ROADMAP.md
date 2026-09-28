# The Roadmap: 30 Months, Zero to Senior-Ready

## First, an honest word about the salary goal

A package of **1.8 to 3 crore INR** is a Staff / Principal / Senior-Architect level number in India
(or a senior role at a global product company, often remote for a US/EU employer).
People at that level usually have **8+ years** of real production experience, or an unusually strong
public track record (open-source contributions, talks, deep specialisation in security or platforms).

Certifications alone will not get you there. What gets you there is:

1. **Skill depth** you can prove live in an interview (design a platform, debug a broken cluster).
2. **Production experience** (getting paid to run real systems, being on-call).
3. **Visibility** (GitHub portfolio, blogs, open-source PRs, conference talks).
4. **Specialisation** in a high-paying niche: Kubernetes security, platform engineering, AI infrastructure.

So this plan has three tracks running in parallel:
**Learn → Certify → Get hired early and keep climbing.** Do not wait 30 months to apply for jobs.
Get your first job around month 8 to 10 and keep studying while working.

## Time budget

The plan assumes about **25 hours per week**: 3 hours on weekdays, 5 hours on each weekend day.
If you have less time, stretch each phase; do not skip phases.

## Career ladder you are aiming for

| Stage | When | Typical role | Rough India package (varies widely) |
|---|---|---|---|
| 1 | Month 8-12 | Linux / Cloud Support Engineer, Junior DevOps | 4-8 LPA |
| 2 | Year 2-3 | DevOps / Cloud Engineer | 10-20 LPA |
| 3 | Year 3-5 | Senior DevOps / SRE / Platform Engineer | 25-50 LPA |
| 4 | Year 5-8 | Lead / Staff Platform or Cloud Security Engineer | 50 LPA - 1 Cr |
| 5 | Year 8+ | Principal / Architect / Staff at global product co. | 1-3 Cr+ |

These ranges are indicative only; they depend on company, city, negotiation and skill.
The fastest jumps come from **switching jobs every 2-3 years with a stronger portfolio**.

---

## Phase map

| Phase | Months | Topic | Exam(s) at the end |
|---|---|---|---|
| 0 | 0.5 | Setup, learning habits, Git basics | - |
| 1 | 1-3 | Linux from zero | (LFCS optional, needed for Golden Kubestronaut) |
| 2 | 3-4 | Networking | - |
| 3 | 4-5 | Bash, Git, Python | - |
| 4 | 5-6 | RHEL admin | **RHCSA (EX200)** |
| 5 | 6-7 | Docker basic to advanced, networking and security | - |
| 6 | 7-9 | Cloud (AWS) + Terraform + CI/CD | **AWS Solutions Architect Associate**, Terraform Associate (optional) |
| - | 8-10 | **Start applying for first job** | - |
| 7 | 9-10 | Kubernetes fundamentals | **KCNA** |
| 8 | 10-12 | Kubernetes for developers | **CKAD** |
| 9 | 12-14 | Kubernetes administration and networking | **CKA** |
| 10 | 14-16 | Kubernetes and cloud-native security | **KCSA**, then **CKS** → you are a **Kubestronaut** |
| 11 | 16-17 | Ansible automation | **RHCE (EX294)** |
| 12 | 17-19 | Observability | **PCA**, **OTCA** |
| 13 | 19-21 | GitOps and progressive delivery | **CGOA**, **CAPA** |
| 14 | 21-23 | Service mesh and eBPF networking | **ICA**, **CCA** |
| 15 | 23-25 | Platform engineering and policy | **KCA**, **CBA**, **CNPA**, **CNPE** → **Golden Kubestronaut** (with LFCS) |
| 16 | 25-27 | OpenShift + OpenShift Virtualization | **EX280**, **EX316** |
| 17 | 27-29 | Cloud security | **AWS Security Specialty** |
| 18 | 29-30 | AI, MLOps and AI security | Capstone project |
| 19 | 30+ | RHCA electives, specialisation, open source, talks | Remaining RHCA exams |

---

## Phase details

### Phase 0: Setup (2 weeks) → `labs/00-setup`
- Install a hypervisor (VirtualBox or VMware), or use WSL2 on Windows, and create two Linux VMs.
- Create a GitHub account (you have one: `Willey2003`) and learn: clone, add, commit, push.
- Install VS Code with the Remote-SSH, YAML and Python extensions.
- Habit: 25-minute focus blocks, a weekly journal, one small commit per day.

### Phase 1: Linux (10 weeks) → `labs/01-linux`
Weeks 1-2: What an OS is, the terminal, files and directories, `ls cd pwd cp mv rm mkdir`, editors (`nano`, then `vim`).
Weeks 3-4: Users, groups, permissions (`chmod chown umask`), `sudo`, special permissions.
Weeks 5-6: Processes, `systemd`, services, logs (`journalctl`), scheduling (`cron`, timers).
Weeks 7-8: Disks, partitions, LVM, filesystems, mounting, `/etc/fstab`, swap.
Weeks 9-10: Package management (`dnf`, `apt`), boot process, SELinux basics, troubleshooting.
**Real scenario:** "The web server stopped after a reboot" (service not enabled, disk full, wrong SELinux label).

### Phase 2: Networking (6 weeks) → `labs/02-networking`
OSI and TCP/IP models, IP addressing and subnetting (practice until you can do it on paper), routing,
ARP, DNS, DHCP, TCP vs UDP, ports, HTTP/HTTPS/TLS, NAT, firewalls (`firewalld`, `iptables`, `nftables`),
Linux network namespaces and bridges (this is exactly how containers network), load balancers, VPN basics.
Tools: `ip`, `ss`, `ping`, `traceroute`, `dig`, `curl`, `tcpdump`, Wireshark.
**Real scenario:** "App can reach the database by IP but not by name" (DNS), "Port is open but connection refused".

### Phase 3: Bash, Git, Python (6 weeks) → `labs/03-bash-git-python`
Bash: variables, loops, conditions, functions, exit codes, `grep sed awk`, writing safe scripts.
Git: branches, merge, rebase, pull requests, resolving conflicts.
Python: variables, lists, dicts, functions, files, errors, modules, virtual environments, `requests`,
JSON/YAML, writing CLIs, calling AWS and Kubernetes APIs, unit tests with `pytest`.
**Projects:** log analyser, disk-usage alert script, HTTP health checker, a small Flask/FastAPI API you will containerise later.

### Phase 4: RHCSA (4 weeks) → `labs/10-redhat-ansible` (part 1)
Re-do Linux labs on RHEL 9/10 (free Red Hat Developer subscription). Practise under a 2.5-hour timer.
**Exam: RHCSA (EX200)**. First certification, and the one most Indian recruiters recognise.

### Phase 5: Docker (5 weeks) → `labs/04-docker`, `labs/05-docker-networking-security`
Images vs containers, Dockerfile, layers, volumes, multi-stage builds, Compose, registries.
Advanced: bridge/host/none/overlay/macvlan networks, DNS between containers, iptables rules Docker creates,
rootless containers, capabilities, seccomp, AppArmor/SELinux, read-only filesystems, image scanning (Trivy),
signing (Cosign), SBOMs (Syft), distroless images, Podman.
**Real scenario:** "Container works on my laptop, crashes in prod" (missing env var, wrong user, OOM killed).

### Phase 6: Cloud + Terraform + CI/CD (8 weeks) → `labs/06-cloud-aws-terraform`
AWS: accounts, IAM, VPC (subnets, route tables, NAT, security groups), EC2, S3, RDS, ELB, Auto Scaling,
Route 53, CloudWatch, Lambda, EKS basics. Always set a **billing alarm first**.
Terraform: providers, resources, variables, state, modules, remote state.
CI/CD: GitHub Actions pipeline that tests, builds, scans and pushes an image.
**Exam: AWS Solutions Architect Associate.** Optional: HashiCorp Terraform Associate.
Azure/GCP: learn the equivalent names later (VPC = VNet, IAM roles = Managed Identity, etc.).

### Start job hunting (month 8-10)
By now you have RHCSA + AWS SAA + a GitHub portfolio with Linux, Python, Docker and Terraform projects.
Apply for Linux Admin, Cloud Support, NOC-to-DevOps, Junior DevOps roles. See `career/JOB-HUNT.md`.

### Phase 7: KCNA (4 weeks) → `labs/07-kubernetes-core` (part 1)
Cloud-native landscape, what Kubernetes is, Pods, Deployments, Services, the control plane,
CNCF projects, observability and delivery concepts. **Exam: KCNA** (multiple choice).

### Phase 8: CKAD (6 weeks) → `labs/07-kubernetes-core` (part 2)
Pods, multi-container patterns, ConfigMaps, Secrets, probes, resources, Jobs/CronJobs, Deployments and
rollouts, Services, Ingress, NetworkPolicy basics, Helm, Kustomize, SecurityContext.
Speed with `kubectl` imperative commands and `vim`. **Exam: CKAD** (hands-on, 2 hours).

### Phase 9: CKA (8 weeks) → `labs/07-kubernetes-core` (part 3), `labs/08-kubernetes-networking`
Build clusters with kubeadm, upgrades, etcd backup/restore, scheduling (taints, affinity), storage
(PV, PVC, StorageClass), RBAC, troubleshooting nodes/kubelet/control plane, CNI, CoreDNS, kube-proxy,
Services, Ingress, **Gateway API**, NetworkPolicy. **Exam: CKA** (hands-on).

### Phase 10: KCSA + CKS (8 weeks) → `labs/09-kubernetes-security`
Threat modelling (STRIDE), 4C's of cloud-native security, CIS benchmarks (kube-bench), API server hardening,
RBAC least privilege, ServiceAccounts, Pod Security Admission, NetworkPolicy default-deny, Secrets encryption
at rest, audit logs, AppArmor/seccomp, gVisor/RuntimeClass, image scanning and admission (Trivy, Kyverno),
Falco runtime detection, supply chain (SBOM, Cosign). **Exams: KCSA, then CKS** (CKS needs an active CKA).
You are now a **Kubestronaut** (KCNA + KCSA + CKAD + CKA + CKS).

### Phase 11: RHCE (5 weeks) → `labs/10-redhat-ansible` (part 2)
Ansible inventory, ad-hoc commands, playbooks, variables, facts, loops, conditionals, handlers, templates
(Jinja2), roles, collections, Ansible Vault, automating the RHCSA tasks. **Exam: RHCE (EX294).**

### Phase 12: Observability (6 weeks) → `labs/11-observability`
Metrics, logs, traces. Prometheus data model, PromQL, exporters, alerting rules, Alertmanager, Grafana,
kube-prometheus-stack. OpenTelemetry SDK, Collector pipelines, tracing a Python app, Loki/Tempo.
**Exams: PCA, OTCA.**

### Phase 13: GitOps and delivery (6 weeks) → `labs/12-gitops-delivery`
GitOps principles (OpenGitOps), Argo CD apps and ApplicationSets, sync waves, Argo Rollouts canary and
blue-green with analysis, Argo Workflows, Argo Events, Flux comparison. **Exams: CGOA, CAPA.**

### Phase 14: Service mesh and eBPF (8 weeks) → `labs/13-service-mesh`, `labs/08-kubernetes-networking`
Why a mesh, Envoy fundamentals (listeners, routes, clusters, filters), Istio install, sidecar vs ambient mode,
traffic management (VirtualService, DestinationRule, Gateway), retries, timeouts, circuit breaking, fault injection,
mTLS (PeerAuthentication), AuthorizationPolicy, observability with **Kiali**, Jaeger, Prometheus.
Cilium: eBPF basics, Cilium NetworkPolicy (L3-L7), Hubble, ClusterMesh. **Exams: ICA, CCA.**

### Phase 15: Platform engineering (8 weeks) → `labs/14-platform-engineering`, `labs/09-kubernetes-security`
Kyverno policies (validate, mutate, generate, verifyImages). Backstage software catalog, templates, plugins.
Platform engineering: internal developer platforms, golden paths, platform APIs with Crossplane, self-service,
DORA metrics, multi-tenancy. **Exams: KCA, CBA, CNPA, CNPE.**
With LFCS this completes **Golden Kubestronaut** (check the current required list on the CNCF site).

### Phase 16: OpenShift (8 weeks) → `labs/15-openshift`
OpenShift Local (CRC) or Developer Sandbox, `oc` CLI, projects, Routes, SCCs, Operators and OLM,
builds (S2I), image streams, OAuth/identity providers, quotas, monitoring, cluster updates.
OpenShift Virtualization (KubeVirt): VMs as Kubernetes objects, storage, live migration, networking with Multus.
**Exams: EX280 (OpenShift Administration), EX316 (OpenShift Virtualization).**
RHCA: RHCE plus 5 additional expertise exams (e.g. EX280, EX316, EX188/EX288, EX374, EX467). Check the current
Red Hat list before booking, because the RHCA rules and exam codes change.

### Phase 17: Cloud security (6 weeks) → `labs/16-cloud-security`
IAM least privilege, SCPs, KMS, Secrets Manager, CloudTrail, GuardDuty, Security Hub, Config rules, VPC
flow logs, WAF, Shield, EKS security (IRSA/Pod Identity), CSPM with Prowler, policy as code with OPA/Checkov,
incident response in the cloud. **Exam: AWS Security Specialty.**

### Phase 18: AI, MLOps and AI security (8 weeks) → `labs/17-ai-mlops`, `labs/18-ai-security`
AI basics (what a model, training and inference are), calling LLM APIs from Python, RAG with a vector DB,
serving models on Kubernetes (KServe/vLLM), GPUs in Kubernetes, AI gateways.
AI security: OWASP Top 10 for LLM apps, prompt injection, data leakage, model supply chain, guardrails,
MITRE ATLAS, securing the AI platform on Kubernetes.

### Capstone (months 29-30) → `capstone/`
One production-grade platform on your GitHub: Terraform-built EKS (or kubeadm) cluster, Argo CD GitOps,
Istio mesh with mTLS, Kyverno policies, Falco, Prometheus/Grafana/OTel, Backstage portal, a Python microservice
app and an AI (RAG) service, full CI/CD with signed images. Write a blog post and record a 10-minute demo video.

---

## Weekly rhythm

| Day | What |
|---|---|
| Mon-Fri (3h) | 1h theory (course/book), 2h lab |
| Sat (5h) | Real-world scenario from `scenarios/`, then re-do the week's labs from memory |
| Sun (5h) | Mock exam / timed practice, update journal, push to GitHub, write a LinkedIn post about what you learned |

## Recommended learning resources (free first)
- Linux: Red Hat Developer subscription (free RHEL), "The Linux Command Line" (free PDF), Linux Journey.
- Networking: Practical Networking (YouTube), "Computer Networking: A Top-Down Approach".
- Python: "Automate the Boring Stuff with Python" (free online), Python official tutorial.
- Kubernetes: kubernetes.io docs (allowed in the exam), Killercoda scenarios, killer.sh (free with CKA/CKAD/CKS).
- Cloud: AWS Skill Builder free tier, AWS Free Tier account.
- Every CNCF project's official docs.
