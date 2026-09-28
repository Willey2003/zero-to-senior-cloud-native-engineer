# Lab 12: GitOps and Progressive Delivery (Argo CD, Argo Rollouts, Workflows, Events)

## Concepts (OpenGitOps principles, CGOA)
1. **Declarative**: the whole system is described as desired state.
2. **Versioned and immutable**: that state lives in Git.
3. **Pulled automatically**: an agent in the cluster pulls it (no CI pushing with admin creds).
4. **Continuously reconciled**: drift is detected and corrected.
Push-based CI/CD vs pull-based GitOps; Argo CD vs Flux; repo layouts (app repo vs config repo, env folders, Kustomize overlays).

## Part A: Argo CD
```bash
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
kubectl -n argocd port-forward svc/argocd-server 8080:443
kubectl apply -f manifests/argocd-app.yaml
```
Then: change replicas in Git → watch sync. Change them with `kubectl` → watch self-heal revert it.
Learn: sync policies, prune, sync waves and hooks, `ApplicationSet` (one app per env/cluster), App of Apps,
Projects and RBAC, SSO, multi-cluster, Image Updater, notifications.

## Part B: Argo Rollouts (canary and blue-green with automatic analysis)
`manifests/rollout-canary.yaml`: 10% → pause → 50% → full, with an `AnalysisTemplate` that queries Prometheus
error rate and **auto-rolls back** if it is bad. Deploy a bad version (`APP_VERSION=bad` returning 500s) and watch it abort.
```bash
kubectl argo rollouts get rollout api -n shop --watch
kubectl argo rollouts promote api -n shop
```

## Part C: Argo Workflows and Events (CAPA)
- Workflows: DAG of containers (CI jobs, ML pipelines). Write a DAG: test → build → scan.
- Events: a webhook/GitHub event source triggers a workflow via a Sensor.

## Real-world scenarios
1. "Prod differs from Git." Find the drift in the Argo CD UI; decide self-heal vs investigate.
2. "Bad release at 2 AM." Rollouts analysis aborted it automatically. Read why in the AnalysisRun.
3. "We need the same app in 3 clusters with different values." ApplicationSet with a cluster generator.

**Cert mapping:** CGOA, CAPA, CNPA.
