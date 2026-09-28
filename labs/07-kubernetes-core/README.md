# Lab 07: Kubernetes Core (KCNA → CKAD → CKA)

## Why this matters
Kubernetes (K8s) runs containers across many machines, restarts them when they die, scales them, and
gives them stable network addresses. It is the operating system of the cloud, and the centre of your career path.

## Mental model (read twice)
- You write **desired state** in YAML ("I want 3 copies of my API"). You `kubectl apply` it.
- The **API server** stores it in **etcd**. **Controllers** constantly compare desired vs actual and fix the difference.
- The **scheduler** picks a node for each Pod. The **kubelet** on that node starts the containers via the
  container runtime (containerd). **kube-proxy** / the CNI make Services reachable.
- Smallest unit = **Pod** (one or more containers sharing network and storage).

## Your cluster
```bash
# Local, fast (recommended for daily practice):
kind create cluster --config manifests/kind-3node.yaml --name lab
kubectl get nodes -o wide
# For CKA practice, build a real one with kubeadm on 3 VMs: see kubeadm-install.md
```

## Part 1: KCNA level (4 weeks)
```bash
kubectl run web --image=nginx
kubectl get pods -o wide ; kubectl describe pod web ; kubectl logs web
kubectl create deployment api --image=nginx --replicas=3
kubectl expose deployment api --port=80
kubectl scale deployment api --replicas=5
kubectl get all
kubectl explain deployment.spec.strategy          # built-in docs, allowed in exams
kubectl api-resources
```
Also learn the landscape: CNCF projects, what Prometheus, Envoy, Helm, Argo, OpenTelemetry do; cloud-native
architecture (microservices, 12-factor, autoscaling, serverless), and container orchestration basics.

## Part 2: CKAD level (6 weeks)
Apply `manifests/lab-api.yaml` (the Lab 03 API): Deployment with probes, resources, ConfigMap, Secret, Service.
Practise each of these until you can write them in under 2 minutes each:
- Multi-container Pods: init container, sidecar (log shipper), ambassador.
- ConfigMaps and Secrets as env and as files.
- Probes: liveness, readiness, startup. Break one and watch the effect.
- `resources.requests/limits`, LimitRange, ResourceQuota.
- Jobs, CronJobs, `backoffLimit`, `activeDeadlineSeconds`.
- Rolling update and rollback: `kubectl set image`, `kubectl rollout status|history|undo`.
- Blue/green and canary with labels and Services.
- Helm: `helm create`, `helm install`, values, upgrade, rollback. Kustomize overlays (dev/prod).
- SecurityContext: runAsNonRoot, readOnlyRootFilesystem, capabilities.
- ServiceAccounts, NetworkPolicy basics, Ingress.
- Speed kit:
```bash
alias k=kubectl ; export do="--dry-run=client -o yaml" ; export now="--force --grace-period 0"
k create deploy x --image=nginx $do > x.yaml
k create cj backup --image=busybox --schedule="*/5 * * * *" $do -- date
k create secret generic db --from-literal=password=s3cr3t $do
```

## Part 3: CKA level (8 weeks)
- Build a cluster with kubeadm (`kubeadm-install.md`), join workers, install a CNI.
- Upgrade the cluster one minor version (control plane first, then each node with drain/uncordon).
- etcd backup and restore with `etcdctl snapshot save/restore` (**guaranteed exam topic**).
- Scheduling: nodeSelector, affinity/anti-affinity, taints/tolerations, PriorityClass, static Pods, DaemonSets.
- Storage: PV, PVC, StorageClass, access modes, reclaim policy, volume expansion.
- RBAC: Role, ClusterRole, bindings, `kubectl auth can-i --as`.
- Troubleshooting: `crictl ps`, `journalctl -u kubelet`, `/etc/kubernetes/manifests`, certificates (`kubeadm certs check-expiration`).
- Networking: see Lab 08. HPA with metrics-server. CRDs and Operators basics.

## Real-world scenarios (run `scripts` from ../../scenarios)
1. Pod in `CrashLoopBackOff` → `kubectl logs --previous`, wrong command / missing env.
2. Pod `Pending` forever → no node fits requests, taint, or unbound PVC. Read `describe` Events.
3. `ImagePullBackOff` → typo in image, private registry without imagePullSecret.
4. Service has no endpoints → selector labels do not match Pod labels.
5. Node `NotReady` → kubelet stopped / container runtime down / cert expired.
6. API server down after editing its static Pod manifest → fix YAML in `/etc/kubernetes/manifests`.

## Check yourself
- [ ] Explain what happens, component by component, after `kubectl apply -f deploy.yaml`.
- [ ] Back up and restore etcd without looking at notes.
- [ ] Finish a killer.sh simulator above 75%.

**Cert mapping:** KCNA, CKAD, CKA.
