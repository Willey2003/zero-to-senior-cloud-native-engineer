# Lab 02: Networking From Zero

## Why this matters
90% of "the app is down" tickets are really networking problems: DNS, firewalls, routes, TLS, ports.
Containers and Kubernetes networking is just Linux networking (namespaces, bridges, iptables) automated.

## Module 1: How data travels
- **IP address**: the "house address" of a machine, e.g. `192.168.1.10`.
- **Subnet / CIDR**: a street of houses. `192.168.1.0/24` = 256 addresses (254 usable). `/16` = 65,536.
- **Gateway / router**: the door out of your street to other streets (other networks).
- **MAC address**: the hardware ID of a network card; **ARP** turns IP → MAC on the local network.
- **Port**: a door on the machine for a specific program (22 SSH, 53 DNS, 80 HTTP, 443 HTTPS, 6443 Kubernetes API).
- **TCP** = reliable, ordered (handshake SYN → SYN-ACK → ACK). **UDP** = fast, no guarantee (DNS, video).
- **OSI layers** you will use daily: L2 (Ethernet/MAC), L3 (IP), L4 (TCP/UDP ports), L7 (HTTP, DNS, gRPC).

### Subnetting drill (do 20 per day for 2 weeks)
For `10.20.30.77/27`: block size = 32 → network `10.20.30.64`, broadcast `10.20.30.95`, hosts `.65-.94`.
Practise with `scripts/subnet_quiz.py`.

## Module 2: Linux network tools
```bash
ip -br addr                 # my IP addresses
ip route                    # my routes; "default via" = gateway
ip neigh                    # ARP table
ss -tulnp                   # which programs listen on which ports
ping -c3 8.8.8.8            # can I reach the internet by IP? (L3)
ping -c3 google.com         # ...and by name? (DNS)
dig google.com +short       # DNS lookup
dig @1.1.1.1 example.com MX
traceroute google.com       # path through routers
curl -v https://example.com # full HTTP + TLS conversation
openssl s_client -connect example.com:443 -servername example.com </dev/null | openssl x509 -noout -dates
sudo tcpdump -i any -nn port 53     # watch DNS packets live
nc -zv 10.0.0.5 5432                # is a TCP port open?
```

## Module 3: DNS, DHCP, HTTP, TLS
- DNS resolution order: `/etc/hosts` → resolver in `/etc/resolv.conf`. Record types: A, AAAA, CNAME, MX, TXT, NS, SRV.
- TLS: the server shows a **certificate** signed by a trusted **CA**; the client checks the name and dates.
  Lab: create your own CA and certificate with `scripts/make-certs.sh` and serve HTTPS with nginx.

## Module 4: Firewalls and NAT
```bash
sudo firewall-cmd --list-all
sudo firewall-cmd --add-service=http --permanent && sudo firewall-cmd --reload
sudo nft list ruleset
sudo iptables -t nat -L -n -v
```

## Module 5: Build container networking by hand (the "aha" lab)
Run `scripts/netns-lab.sh`. It creates two "fake containers" (network namespaces), connects them to a
Linux bridge with veth cables, gives them IPs, and adds NAT so they reach the internet.
**This is exactly what Docker and Kubernetes CNI plugins do for you.** Read every line of the script.

## Real-world scenarios
1. **"App cannot reach DB by name."** `/etc/hosts` has a wrong entry; find it with `getent hosts db`.
2. **"Connection refused vs timeout."** Refused = nothing listening (check `ss -tlnp`); timeout = firewall/route drops it.
3. **"HTTPS error: certificate expired / name mismatch."** Diagnose with `openssl s_client`.
4. **"One VM can ping the gateway but not the internet."** Missing default route or NAT; fix with `ip route add default via ...`.

## Check yourself
- [ ] Subnet any /8-/30 on paper in under 60 seconds.
- [ ] Explain what happens when you type `https://google.com` and press Enter (DNS → TCP → TLS → HTTP).
- [ ] Rebuild the netns lab from memory.
