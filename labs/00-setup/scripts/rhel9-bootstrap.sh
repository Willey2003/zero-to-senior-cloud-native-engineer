#!/usr/bin/env bash
# rhel9-bootstrap.sh - prepare a fresh RHEL 9 / Rocky 9 / Alma 9 lab server.
#
# What it does, in order:
#   1. Checks you are root and on a RHEL 9 family system
#   2. Enables extra repos (CodeReady Builder / CRB, and EPEL)
#   3. Updates the whole OS
#   4. Installs the packages used across the labs (Linux, networking, Python, containers)
#   5. Enables and starts the needed services
#   6. Opens firewall ports for the labs
#   7. Sets hostname and timezone (optional) and prints a summary
#
# Usage:
#   sudo ./rhel9-bootstrap.sh                          # everything, default settings
#   sudo ./rhel9-bootstrap.sh --hostname server1.lab.local --timezone Asia/Kolkata
#   sudo ./rhel9-bootstrap.sh --no-update              # skip the full OS update
#   sudo ./rhel9-bootstrap.sh --k8s-ports              # also open Kubernetes ports (for the CKA labs)
#   sudo ./rhel9-bootstrap.sh --dry-run                # show what would run, change nothing
#
# On RHEL (not Rocky/Alma), register first so dnf can download packages:
#   sudo subscription-manager register --username <your-redhat-login>
#
# The script is safe to run again: installed packages, running services and open ports are skipped.

set -euo pipefail

# ---------- settings you can change ----------
HOSTNAME_NEW=""
TIMEZONE=""
DO_UPDATE=1
K8S_PORTS=0
DRY_RUN=0
LOG_FILE="/var/log/rhel9-bootstrap.log"

PACKAGES=(
  # everyday tools
  vim-enhanced nano bash-completion man-pages tar zip unzip wget curl rsync tree less which
  # system admin (RHCSA)
  lvm2 xfsprogs stratisd stratis-cli nfs-utils autofs cronie at chrony tuned sysstat lsof psmisc dnf-utils
  policycoreutils-python-utils setroubleshoot-server audit acl
  # networking
  iproute bind-utils net-tools traceroute tcpdump nmap-ncat telnet NetworkManager-tui firewalld openssl
  # development and automation
  git python3 python3-pip jq
  # containers (Podman is Red Hat's Docker)
  podman buildah skopeo container-tools
  # web console on https://<server-ip>:9090
  cockpit cockpit-podman cockpit-storaged
  # web server used in the Linux labs
  httpd
)

EPEL_PACKAGES=(htop ShellCheck)

SERVICES=(sshd chronyd firewalld crond atd tuned auditd cockpit.socket stratisd)

FIREWALL_SERVICES=(ssh cockpit http https)
FIREWALL_PORTS=(8080/tcp 8000/tcp)                 # lab web apps (Lab 01 scenario, Lab 03 API)
K8S_FIREWALL_PORTS=(6443/tcp 2379-2380/tcp 10250/tcp 10257/tcp 10259/tcp 30000-32767/tcp)
# ---------------------------------------------

log()  { echo "$(date '+%F %T') [INFO]  $*" | tee -a "$LOG_FILE"; }
warn() { echo "$(date '+%F %T') [WARN]  $*" | tee -a "$LOG_FILE" >&2; }
die()  { echo "$(date '+%F %T') [ERROR] $*" | tee -a "$LOG_FILE" >&2; exit 1; }
run()  { if (( DRY_RUN )); then echo "DRY-RUN: $*"; else "$@"; fi; }

usage() { sed -n '2,23p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --hostname)  HOSTNAME_NEW="${2:?--hostname needs a value}"; shift 2 ;;
    --timezone)  TIMEZONE="${2:?--timezone needs a value}"; shift 2 ;;
    --no-update) DO_UPDATE=0; shift ;;
    --k8s-ports) K8S_PORTS=1; shift ;;
    --dry-run)   DRY_RUN=1; shift ;;
    -h|--help)   usage ;;
    *) die "Unknown option: $1 (try --help)" ;;
  esac
done

# ---------- 1. pre-flight checks ----------
[[ $EUID -eq 0 ]] || die "Run as root: sudo $0"
touch "$LOG_FILE" 2>/dev/null || LOG_FILE=/tmp/rhel9-bootstrap.log
[[ -r /etc/os-release ]] || die "/etc/os-release not found; is this Linux?"
# shellcheck disable=SC1091
source /etc/os-release
major="${VERSION_ID%%.*}"
if [[ "$major" != "9" ]] || [[ "$ID" != "rhel" && " ${ID_LIKE:-} " != *" rhel "* ]]; then
  die "This script is for RHEL 9 family (found: ${PRETTY_NAME:-unknown})"
fi
log "Starting bootstrap on ${PRETTY_NAME} ($(hostname))"

if [[ "$ID" == "rhel" ]] && ! subscription-manager status &>/dev/null; then
  die "RHEL is not registered. Run: subscription-manager register --username <your-redhat-login>"
fi

# ---------- 2. extra repositories ----------
log "Enabling CodeReady Builder / CRB repository"
if [[ "$ID" == "rhel" ]]; then
  run subscription-manager repos --enable "codeready-builder-for-rhel-9-$(uname -m)-rpms" || warn "Could not enable CRB"
else
  run dnf -y install dnf-plugins-core
  run dnf config-manager --set-enabled crb || warn "Could not enable CRB"
fi

if ! rpm -q epel-release &>/dev/null; then
  log "Installing EPEL (extra community packages)"
  run dnf -y install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm" || warn "EPEL install failed; EPEL packages will be skipped"
fi

# ---------- 3. OS update ----------
if (( DO_UPDATE )); then
  log "Updating the operating system (this can take several minutes)"
  run dnf -y upgrade --refresh
else
  log "Skipping OS update (--no-update)"
fi

# ---------- 4. packages ----------
install_list() {
  local missing=()
  for p in "$@"; do rpm -q "$p" &>/dev/null || missing+=("$p"); done
  if (( ${#missing[@]} == 0 )); then log "All requested packages already installed"; return; fi
  log "Installing: ${missing[*]}"
  # --skip-broken lets the rest install if one package is not available on this OS variant
  run dnf -y install --skip-broken "${missing[@]}"
}
install_list "${PACKAGES[@]}"
rpm -q epel-release &>/dev/null && install_list "${EPEL_PACKAGES[@]}"

# ---------- 5. services ----------
for svc in "${SERVICES[@]}"; do
  if [[ -z "$(systemctl list-unit-files "$svc" --no-legend 2>/dev/null)" ]]; then
    warn "Service $svc not found, skipping"; continue
  fi
  if systemctl is-enabled --quiet "$svc" && systemctl is-active --quiet "$svc"; then
    log "Service $svc already enabled and running"
  else
    log "Enabling and starting $svc"
    run systemctl enable --now "$svc" || warn "Could not start $svc (check: journalctl -u $svc)"
  fi
done
run tuned-adm profile virtual-guest || true

# ---------- 6. firewall ----------
if systemctl is-active --quiet firewalld; then
  for s in "${FIREWALL_SERVICES[@]}"; do
    firewall-cmd --permanent --query-service="$s" &>/dev/null || { log "Opening service $s"; run firewall-cmd --permanent --add-service="$s"; }
  done
  ports=("${FIREWALL_PORTS[@]}")
  (( K8S_PORTS )) && ports+=("${K8S_FIREWALL_PORTS[@]}")
  for p in "${ports[@]}"; do
    firewall-cmd --permanent --query-port="$p" &>/dev/null || { log "Opening port $p"; run firewall-cmd --permanent --add-port="$p"; }
  done
  # SELinux must also allow httpd on 8080 (8000 is already an allowed http port type)
  semanage port -l 2>/dev/null | grep -qE '^http_port_t.*\b8080\b' || run semanage port -a -t http_port_t -p tcp 8080 2>/dev/null || true
  run firewall-cmd --reload
else
  warn "firewalld is not running; skipping firewall rules"
fi

# ---------- 7. hostname and timezone ----------
[[ -n "$HOSTNAME_NEW" ]] && { log "Setting hostname to $HOSTNAME_NEW"; run hostnamectl set-hostname "$HOSTNAME_NEW"; }
[[ -n "$TIMEZONE" ]]     && { log "Setting timezone to $TIMEZONE";     run timedatectl set-timezone "$TIMEZONE"; }

# ---------- summary ----------
log "Bootstrap finished. Summary:"
{
  echo "  OS:        ${PRETTY_NAME}   kernel $(uname -r)"
  echo "  Hostname:  $(hostnamectl --static 2>/dev/null || hostname)"
  echo "  IPs:       $(hostname -I 2>/dev/null)"
  echo "  SELinux:   $(getenforce 2>/dev/null || echo unknown)"
  echo "  Services:"
  for svc in "${SERVICES[@]}"; do printf '    %-16s %s\n' "$svc" "$(systemctl is-active "$svc" 2>/dev/null || true)"; done
  echo "  Firewall:  $(firewall-cmd --list-services 2>/dev/null) | ports: $(firewall-cmd --list-ports 2>/dev/null)"
  echo "  Web console: https://$(hostname -I 2>/dev/null | awk '{print $1}'):9090"
} | tee -a "$LOG_FILE"

if [[ -f /var/run/reboot-required ]] || ! needs-restarting -r &>/dev/null; then
  warn "A reboot is recommended (kernel or core libraries were updated): sudo systemctl reboot"
fi
log "Log saved to $LOG_FILE"
