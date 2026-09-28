# Capstone: "ShopPlatform", a Production-Grade Internal Platform

Build this on your GitHub as the centrepiece of your CV. Interviewers for senior roles will ask you to walk through it.

## Architecture
```
Developer ── Backstage (golden path) ──> GitHub repo ──> GitHub Actions (test, build, Trivy, SBOM, Cosign sign)
                                                              │
                                                    GHCR registry (signed images)
                                                              │
Git config repo ── Argo CD (ApplicationSet: dev/prod) ──> EKS or kubeadm cluster (built with Terraform/Ansible)
                                                              │
   Istio (mTLS STRICT, AuthorizationPolicy, canary) · Kyverno (verify signatures, PSA restricted) · Falco
   Prometheus + Grafana + OTel Collector + Tempo + Loki · Kiali · Argo Rollouts (auto-rollback on SLO)
   Apps: lab-api (Python), frontend, Postgres (Crossplane claim), RAG assistant (Lab 17) behind an AI gateway
```

## Milestones
1. Infra as code: Terraform VPC + EKS (or Ansible + kubeadm on VMs). `terraform destroy` works cleanly.
2. GitOps bootstrap: one command installs Argo CD, which installs everything else (App of Apps).
3. Security baseline: kube-bench report, Kyverno policies, default-deny NetworkPolicies, Falco alerts to Slack.
4. Mesh + progressive delivery: canary with automated analysis; demo an automatic rollback.
5. Observability: SLO dashboard and burn-rate alerts; traces across frontend → api → db.
6. Developer portal: a Backstage template that creates a new service end to end.
7. AI feature: the RAG assistant with tenant isolation and prompt-injection tests in CI.
8. Docs: architecture diagram, threat model (STRIDE), runbooks, cost estimate, a blog post, a 10-minute demo video.
