# Lab 15: OpenShift and OpenShift Virtualization (EX280, EX316, RHCA path)

## What OpenShift adds to Kubernetes
Red Hat's enterprise Kubernetes: built-in registry, Routes, OAuth login, **SecurityContextConstraints (SCC)**,
Operators everywhere (OLM / OperatorHub), integrated monitoring and logging, S2I builds, over-the-air cluster updates,
RHCOS nodes. Large Indian banks, telcos and government use it, so demand is high.

## Lab environment
- **OpenShift Local (CRC)**: single-node OpenShift on your laptop (needs ~16-32 GB RAM).
- **Developer Sandbox**: free hosted OpenShift for 30 days (no admin rights).
- For admin/virtualization practice: Red Hat's free trials, or an OKD cluster on spare hardware / cloud credits.

## Part A: OpenShift administration (EX280)
```bash
oc login -u kubeadmin https://api.crc.testing:6443
oc new-project shop
oc new-app python~https://github.com/Willey2003/zero-to-senior-cloud-native-engineer --context-dir=labs/03-bash-git-python/python --name api   # S2I
oc expose svc/api ; oc get route
oc adm policy add-role-to-user edit dev1 -n shop
oc create quota shop-quota --hard=pods=10,requests.cpu=2,requests.memory=4Gi
oc get scc ; oc adm policy who-can use scc privileged
```
Topics: identity providers (HTPasswd), users/groups/RBAC, projects and templates, quotas/limits, network policies,
Routes and TLS (edge/passthrough/reencrypt), SCCs, Operators (install from OperatorHub), cluster updates, `oc adm must-gather`,
node troubleshooting with `oc debug node/<n>`.

## Part B: OpenShift Virtualization (EX316)
Runs **virtual machines as Kubernetes objects** (KubeVirt). Key for VMware-to-OpenShift migrations (very high demand).
- Install the OpenShift Virtualization Operator, create `HyperConverged`.
- Create a VM from a template or `manifests/vm-fedora.yaml`; `virtctl start|console|ssh vm`.
- Storage: DataVolumes, PVCs, snapshots, clones. Networking: pod network, **Multus** secondary networks, bridges (NNCP).
- Live migration, node maintenance, VM templates, instance types, Migration Toolkit for Virtualization (MTV) from vSphere.

## Real-world scenarios
1. "Pod won't start: 'unable to validate against any security context constraint'." Fix the image to run as non-root or grant the right SCC to its ServiceAccount (least privilege).
2. "Route returns 503." Service has no endpoints or wrong target port.
3. "Migrate 20 VMs from VMware." Plan with MTV: network and storage mappings, warm migration, cutover window.

## RHCA
RHCA = RHCE + five more expertise exams. Suggested electives for this career path (verify current list first):
EX280 (OpenShift Admin), EX316 (OpenShift Virtualization), EX288 or EX188 (OpenShift/containers developer), EX374 (Ansible Automation Platform), EX467 (managing automation) or an OpenShift security exam.
