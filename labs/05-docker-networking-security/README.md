# Lab 05: Docker Networking and Security (Basic to Advanced)

## Part A: Networking

### Network drivers
| Driver | What it is | When |
|---|---|---|
| `bridge` (default) | Private network on the host, NAT to outside | Single host apps |
| user-defined bridge | Same, plus **DNS by container name** and isolation | Always prefer over default |
| `host` | Container uses host's network directly | Max performance, no isolation |
| `none` | No network | Batch jobs, security |
| `overlay` | Spans many hosts (Swarm) | Multi-host |
| `macvlan` / `ipvlan` | Container gets its own IP on your LAN | Legacy apps needing L2 presence |

### Hands-on
```bash
docker network create --subnet 172.30.0.0/24 appnet
docker run -d --name db --network appnet redis:7-alpine
docker run --rm --network appnet alpine ping -c2 db            # DNS by name works
docker run --rm alpine ping -c2 db                             # fails on default bridge: why?
docker network inspect appnet
ip link show type bridge ; bridge link                         # the Linux bridge Docker made
sudo iptables -t nat -L DOCKER -n                              # the DNAT rule behind -p 8080:80
sudo iptables -L DOCKER-USER -n                                # where YOU add your own rules
docker run --rm --network none alpine ip addr                  # only loopback
docker run --rm --network host nginx                           # binds host port 80 directly
```
Advanced: `docker network create -d macvlan --subnet 192.168.1.0/24 --gateway 192.168.1.1 -o parent=eth0 lan`,
`docker network connect` a container to two networks, and look at `/etc/resolv.conf` inside a container
(Docker's embedded DNS at `127.0.0.11`).

### Scenario
"The API container cannot reach Postgres, but Postgres is running." They are on different networks. Diagnose with
`docker inspect -f '{{json .NetworkSettings.Networks}}'` and fix with `docker network connect`.

## Part B: Security

### The threat
A container shares the **host kernel**. If an attacker breaks out, they own the host. So we reduce
what a container is allowed to do: least privilege, everywhere.

### Hardening checklist (do each one, see it work, then see it block an attack)
```bash
# 1. Never run as root inside the container
docker run --rm --user 10001:10001 alpine id
# 2. Drop all Linux capabilities, add back only what is needed
docker run --rm --cap-drop ALL --cap-add NET_BIND_SERVICE nginx
# 3. Read-only root filesystem (+ tmpfs for scratch)
docker run --rm --read-only --tmpfs /tmp alpine touch /etc/x      # fails: good
# 4. Block privilege escalation (setuid binaries)
docker run --rm --security-opt no-new-privileges alpine
# 5. Seccomp: default profile blocks ~44 dangerous syscalls; try a custom one
docker run --rm --security-opt seccomp=seccomp-deny-mkdir.json alpine mkdir /tmp/x   # fails
# 6. Limits prevent DoS
docker run --rm --memory 128m --pids-limit 50 --cpus 0.5 alpine
# 7. Never do these in prod (and understand why they are escapes):
#    --privileged     -v /var/run/docker.sock:/var/run/docker.sock     -v /:/host
```
Escape demo (lab VM only!): `docker run --rm -it -v /:/host alpine chroot /host` → you are root on the host.
This is why mounting the host filesystem or the Docker socket is as dangerous as giving root.

### Supply chain security
```bash
trivy image lab-api:v1                               # find CVEs in the image
trivy image --severity HIGH,CRITICAL --exit-code 1 lab-api:v1   # fail CI on bad images
syft lab-api:v1 -o spdx-json > sbom.json             # software bill of materials
cosign generate-key-pair
cosign sign --key cosign.key ghcr.io/<you>/lab-api:v1
cosign verify --key cosign.pub ghcr.io/<you>/lab-api:v1
hadolint Dockerfile                                  # Dockerfile linter
docker scout cves lab-api:v1                         # Docker's own scanner
```
Secrets: never bake secrets into images (`docker history` reveals them). Use build secrets:
`RUN --mount=type=secret,id=token ...` and `docker build --secret id=token,src=token.txt`.

Rootless Docker / Podman: run the whole engine as a normal user, so a breakout is not root on the host.

Run **Docker Bench for Security** (`docker/docker-bench-security`) and fix 5 findings.

## Check yourself
- [ ] Why can containers on a user-defined bridge resolve each other by name but not on the default bridge?
- [ ] Name 5 run flags that harden a container and what attack each prevents.
- [ ] Put Trivy in a CI pipeline that fails on CRITICAL CVEs (Lab 06).

**Cert mapping:** foundation for CKS (supply chain, runtime security, least privilege).
