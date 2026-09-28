#!/usr/bin/env bash
# SCENARIO: breaks a working Apache web server in 3 ways. Run ONLY in a lab VM with a snapshot.
set -e
[ "$EUID" -eq 0 ] || { echo "run with sudo"; exit 1; }
dnf install -y httpd policycoreutils-python-utils >/dev/null
mkdir -p /web && echo "It works!" > /web/index.html
sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/web"#' /etc/httpd/conf/httpd.conf
cat >> /etc/httpd/conf/httpd.conf <<'CONF'
<Directory "/web">
    Require all granted
</Directory>
CONF
sed -i 's/^Listen 80$/Listen 8080/' /etc/httpd/conf/httpd.conf   # problem 1: non-standard port (SELinux + firewall)
systemctl disable httpd >/dev/null 2>&1 || true                  # problem 2: not enabled at boot
chcon -t user_home_t /web/index.html                              # problem 3: wrong SELinux label
echo "Broken. Ticket: 'Website at http://<server>:8080 is down after reboot.' Fix it so it survives a reboot."
