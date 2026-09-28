# RHCSA mock exam (2.5 hours, two VMs: node1, node2)

1. On node1, set a static IP 192.168.56.10/24, gateway 192.168.56.1, DNS 1.1.1.1, hostname node1.lab.example.
2. Configure BaseOS and AppStream repositories from http://repo.lab.example/ (or local ISO mount).
3. Create group `sysadmins`; users `harry` and `natasha` (secondary group sysadmins) and `sarah` (no login shell). Password `redhat`.
4. Members of `sysadmins` can run any command with sudo without a password.
5. Create `/common/admin` owned by group sysadmins, rwx for group, no access for others, new files inherit the group.
6. Cron: user natasha runs `logger "EX200 in progress"` every day at 14:23.
7. Configure node1 to sync time from `time.lab.example`.
8. Autofs: mount `nfs.lab.example:/home/guests/<user>` on `/home/guests/<user>` on demand.
9. Find all files owned by user `harry` and copy them to `/root/harry-files/`.
10. Put every line from `/usr/share/dict/words` containing `ich` into `/root/lines.txt`.
11. Create a 1 GiB LV `database` in VG `datastore` (PE size 16 MiB), ext4, mounted persistently on `/mnt/database`.
12. Resize LV `database` to 850 MiB (online, filesystem too).
13. Add a 512 MiB swap partition, persistent.
14. Serve web content on port 82 from `/var/www/html`; SELinux must stay enforcing.
15. Reset the root password of node2 to `trootent`.
16. Run a rootless Podman container `logserver` as user `harry` that starts automatically at boot.
17. Set the recommended `tuned` profile.
18. **Reboot both nodes and verify all of the above.**
