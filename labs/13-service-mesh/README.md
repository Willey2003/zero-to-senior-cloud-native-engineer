# Lab 13: Service Mesh (Istio, Envoy, Kiali)

## Why a mesh
With 50 microservices, every team needs retries, timeouts, mTLS encryption, access control, and tracing.
A mesh does this **outside your code**: a proxy (Envoy) sits next to or in front of every workload and a
control plane (istiod) programs all proxies.

## Part A: Envoy fundamentals
Run Envoy alone with `manifests/envoy-standalone.yaml` (Docker): **listener** (port it accepts on) → **filter chain**
(HTTP connection manager) → **route** (match path/header) → **cluster** (group of upstream endpoints).
Use the admin page `:9901/config_dump`, `/clusters`, `/stats`. Every Istio problem ends up being read here.

## Part B: Istio
```bash
istioctl install --set profile=demo -y
kubectl label ns shop istio-injection=enabled && kubectl rollout restart deploy -n shop   # sidecar mode
# or ambient mode (no sidecars): istioctl install --set profile=ambient ; kubectl label ns shop istio.io/dataplane-mode=ambient
kubectl apply -f samples/addons   # from the Istio release: prometheus, grafana, jaeger, kiali
istioctl dashboard kiali
```
Traffic management (`manifests/istio-traffic.yaml`):
- Gateway + VirtualService to expose the app. DestinationRule subsets v1/v2.
- Canary 90/10, header-based routing, mirroring, retries, timeouts, fault injection (delay/abort),
  circuit breaking (outlierDetection, connectionPool).
Security (`manifests/istio-security.yaml`):
- `PeerAuthentication` STRICT mTLS mesh-wide; verify with `istioctl x describe pod` and Kiali lock icons.
- `AuthorizationPolicy`: only `frontend` ServiceAccount may call `GET /items` on api. Deny-by-default.
- `RequestAuthentication` with JWT for end users.
Troubleshooting: `istioctl analyze`, `istioctl proxy-status`, `istioctl proxy-config routes|clusters|listeners <pod>`,
Envoy access logs, `503 UF/NR/UH` response flags.

## Part C: Kiali
Service graph (who calls whom, error rates, mTLS status), validations of your Istio config, traffic animation,
wizards to create routing rules, and integrated traces. Use it to find the broken service in scenario 2 below.

## Real-world scenarios
1. "After enabling STRICT mTLS, a legacy VM service fails." Use PERMISSIVE for that workload, plan migration.
2. "Checkout is slow." Kiali graph shows red edge; Jaeger trace shows a 3 s call; a VirtualService has a fault injection left on.
3. "503 NR errors." A VirtualService refers to a subset missing in the DestinationRule; `istioctl analyze` finds it.

**Cert mapping:** ICA (Istio Certified Associate). Envoy knowledge also helps with Gateway API and Cilium.
