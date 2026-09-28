# Lab 09: Kubernetes Security (KCSA → CKS, plus Kyverno for KCA)

## Mental model: the 4C's
**Cloud** (IAM, network) → **Cluster** (API server, RBAC, etcd) → **Container** (image, runtime) → **Code** (app, dependencies).
An attacker needs one weak layer. You harden every layer. Think like an attacker first: threat-model with STRIDE
and the Kubernetes threat matrix (Microsoft) / MITRE ATT&CK for Containers.

## Module 1: Cluster setup and hardening
- Run **kube-bench** (CIS benchmark) on control plane and workers; fix 5 FAIL items.
- API server flags: `--anonymous-auth=false`, `--authorization-mode=Node,RBAC`, `--enable-admission-plugins=...,NodeRestriction`,
  `--profiling=false`, audit logging (`audit-policy.yaml` in `manifests/`).
- Protect etcd (TLS, not exposed), **encrypt Secrets at rest** (`manifests/encryption-config.yaml`), verify with `etcdctl get`.
- Restrict access to the cloud metadata endpoint (169.254.169.254) with NetworkPolicy.
- Verify binaries with `sha512sum` against official release checksums.
- Upgrade Kubernetes regularly (known CVEs).

## Module 2: Identity and access
- RBAC least privilege: `manifests/rbac-readonly.yaml`. Test with `kubectl auth can-i --list --as=system:serviceaccount:shop:viewer`.
- Find dangerous permissions: `*` verbs, `secrets` get/list, `pods/exec`, `escalate`, `bind`, `impersonate`, `nodes/proxy`.
- ServiceAccounts: `automountServiceAccountToken: false` by default; short-lived projected tokens.

## Module 3: Workload security
- **Pod Security Admission**: label namespaces `pod-security.kubernetes.io/enforce=restricted`; try to run a privileged Pod and read the rejection.
- SecurityContext (Lab 07 manifest is already hardened: study it).
- AppArmor and seccomp profiles on Pods. **RuntimeClass** with gVisor (`runsc`) for untrusted workloads.
- Secrets hygiene: external secret stores (Vault, External Secrets Operator, Sealed Secrets).
- mTLS between services: Istio (Lab 13) or Cilium.

## Module 4: Supply chain
- Minimal images (distroless), pin by digest, scan with **Trivy** (`trivy image`, `trivy k8s --report summary`).
- Static analysis of manifests: **kubesec**, `trivy config`, **Checkov**.
- SBOM (Syft), signing and verification (**Cosign**), admission control that only allows signed images from your registry.
- **Kyverno** (KCA): `manifests/kyverno-policies.yaml`: disallow `:latest`, require non-root, require labels,
  mutate to add default securityContext, generate default NetworkPolicy for every new namespace, `verifyImages` with Cosign.
  Also learn OPA Gatekeeper basics (ConstraintTemplate + Constraint) for comparison.

## Module 5: Runtime security and detection
- **Falco**: install with Helm, then `kubectl exec` into a Pod and run `cat /etc/shadow`. See the alert.
  Write a custom rule (`manifests/falco-custom-rules.yaml`). Know the rule syntax: condition, output, priority.
- Audit logs: find who deleted a Deployment using the API server audit log.
- Immutable containers: readOnlyRootFilesystem; detect drift.
- Incident response: isolate a compromised Pod (label + deny-all NetworkPolicy), capture evidence, then delete.

## Real-world scenarios
1. "A developer's ServiceAccount can read all Secrets cluster-wide." Find it (`kubectl get clusterrolebindings -o wide`), fix it.
2. "Crypto-miner found in a Pod." Use Falco + audit logs to find the entrypoint (exposed dashboard? privileged Pod?), contain, remediate.
3. "Secrets visible in etcd in plain text." Enable encryption at rest and re-encrypt all existing Secrets.
4. "Unsigned image deployed to prod." Add Kyverno `verifyImages` and prove it blocks.

## Check yourself
- [ ] Harden a fresh kubeadm cluster to pass most kube-bench checks.
- [ ] Write a Falco rule and a Kyverno policy from memory.
- [ ] Explain every field in a restricted-compliant Pod spec.

**Cert mapping:** KCSA, CKS, KCA (Kyverno).
