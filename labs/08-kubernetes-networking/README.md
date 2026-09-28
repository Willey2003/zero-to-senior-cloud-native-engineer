# Lab 08: Kubernetes Networking (Basic to Advanced, incl. Cilium)

## The 4 rules of Kubernetes networking
1. Every Pod gets its own IP.
2. Every Pod can reach every other Pod without NAT (the **CNI plugin** makes this true).
3. **Services** give a stable virtual IP + DNS name in front of changing Pods (kube-proxy or eBPF).
4. **Ingress / Gateway API** bring outside traffic in. **NetworkPolicy** restricts who talks to whom.

## Module 1: Pod-to-Pod and CNI
- Create kind with `disableDefaultCNI: true`, see nodes stay `NotReady`, install Calico, see them go `Ready`.
- On a node: `ip addr` (veth pairs, `cali*`/`cni0`), `ip route` (routes to other nodes' Pod CIDRs). Compare with Lab 02 netns.

## Module 2: Services and DNS
```bash
kubectl apply -f manifests/netshoot.yaml
kubectl exec -it netshoot -- bash
  nslookup api.shop.svc.cluster.local   # <svc>.<namespace>.svc.cluster.local
  curl api.shop
  cat /etc/resolv.conf                  # search domains, ndots:5
```
Types: ClusterIP, NodePort, LoadBalancer (MetalLB on kind/bare metal), ExternalName, headless (`clusterIP: None`, for StatefulSets).
Look at kube-proxy's work: `iptables -t nat -L KUBE-SERVICES -n | grep api` on a node, or `ipvsadm -Ln` in IPVS mode.
EndpointSlices: `kubectl get endpointslices -n shop`.

## Module 3: Ingress and Gateway API
- Install ingress-nginx, route `shop.local/` → api Service, add TLS with a cert (cert-manager self-signed issuer).
- Gateway API (the future, now in CKA): `GatewayClass` → `Gateway` → `HTTPRoute`. Do path routing, header routing,
  and traffic splitting 90/10 with `manifests/gateway-httproute.yaml`.

## Module 4: NetworkPolicy
Apply `manifests/netpol-default-deny.yaml` then allow only frontend → api on 8000 and api → DNS.
Test with netshoot from allowed and denied Pods. Remember: policies are **additive allow-lists**; the CNI must support them.

## Module 5: Cilium and eBPF (CCA)
```bash
cilium install ; cilium status ; cilium connectivity test
cilium hubble enable --ui ; cilium hubble ui     # see live flows between pods
```
- Replace kube-proxy with Cilium's eBPF service handling.
- L7 policy: allow only `GET /health` to the API (`CiliumNetworkPolicy` with `rules.http`).
- Hubble: `hubble observe --verdict DROPPED` to debug blocked traffic.
- Concepts for CCA: eBPF, identity-based policy, ClusterMesh, BGP, encryption (WireGuard/IPsec), Tetragon.

## Real-world scenarios
1. "Pods can't resolve any names" → CoreDNS pods crashing or NetworkPolicy blocks UDP/TCP 53 to kube-system.
2. "Service works by Pod IP but not by Service name" → wrong `targetPort` or selector.
3. "Ingress returns 404" → wrong `ingressClassName` or host header.
4. "After default-deny, everything broke" → forgot to allow DNS egress.

**Cert mapping:** CKA (networking 20%), CKAD, CCA, KCNA.
