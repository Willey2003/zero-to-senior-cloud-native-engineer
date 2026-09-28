#!/usr/bin/env bash
# Build "container networking" by hand: 2 namespaces + a bridge + NAT. Run with sudo in a lab VM.
# Clean up afterwards with:  sudo ./netns-lab.sh cleanup
set -euo pipefail
if [ "${1:-}" = "cleanup" ]; then
  ip netns del red 2>/dev/null || true; ip netns del blue 2>/dev/null || true
  ip link del br0 2>/dev/null || true
  iptables -t nat -D POSTROUTING -s 10.10.0.0/24 ! -o br0 -j MASQUERADE 2>/dev/null || true
  echo "cleaned"; exit 0
fi

ip netns add red                                   # 1. two isolated network stacks ("containers")
ip netns add blue
ip link add br0 type bridge                        # 2. a virtual switch (like docker0 / cni0)
ip addr add 10.10.0.1/24 dev br0
ip link set br0 up
for ns in red blue; do                             # 3. virtual cables: one end in ns, one on bridge
  ip link add veth-$ns type veth peer name veth-$ns-br
  ip link set veth-$ns netns $ns
  ip link set veth-$ns-br master br0
  ip link set veth-$ns-br up
done
ip -n red  addr add 10.10.0.2/24 dev veth-red      # 4. IP addresses
ip -n blue addr add 10.10.0.3/24 dev veth-blue
for ns in red blue; do
  ip -n $ns link set veth-$ns up
  ip -n $ns link set lo up
  ip -n $ns route add default via 10.10.0.1        # 5. default gateway = the bridge
done
sysctl -w net.ipv4.ip_forward=1 >/dev/null         # 6. let the host route packets
iptables -t nat -A POSTROUTING -s 10.10.0.0/24 ! -o br0 -j MASQUERADE   # 7. NAT to internet

echo "== red -> blue";  ip netns exec red ping -c2 10.10.0.3
echo "== red -> internet"; ip netns exec red ping -c2 8.8.8.8 || echo "(check host firewall / forwarding rules)"
echo "Try: sudo ip netns exec blue python3 -m http.server 80 &  then: sudo ip netns exec red curl 10.10.0.3"
