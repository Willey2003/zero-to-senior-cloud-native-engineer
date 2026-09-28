# Build a real cluster with kubeadm (CKA practice)

3 VMs (Ubuntu 22.04/24.04 or Rocky 9): `cp1` (2 CPU, 2 GB), `w1`, `w2`. Run steps 1-4 on **all** nodes.
Replace `v1.xx` with the Kubernetes minor version the current CKA uses (check the exam page).

```bash
# 1. Kernel modules and sysctl
cat <<EOF2 | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF2
sudo modprobe overlay && sudo modprobe br_netfilter
cat <<EOF2 | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF2
sudo sysctl --system
sudo swapoff -a && sudo sed -i '/ swap / s/^/#/' /etc/fstab

# 2. containerd with systemd cgroups
sudo apt-get update && sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd && containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

# 3. kubeadm, kubelet, kubectl (see kubernetes.io "Installing kubeadm" for the repo lines of your version)
sudo apt-get install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl

# 4. (control plane only)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube && sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config
# install a CNI (Calico or Cilium, see Lab 08), then on workers run the printed "kubeadm join ..." command

# etcd backup / restore (practise weekly)
sudo ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd-backup.db
sudo etcdutl snapshot restore /opt/etcd-backup.db --data-dir /var/lib/etcd-restore
# then point the etcd static pod's hostPath volume to /var/lib/etcd-restore
```
