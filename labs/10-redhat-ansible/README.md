# Lab 10: Red Hat Enterprise Linux (RHCSA) and Ansible (RHCE)

## Part A: RHCSA exam prep (EX200)
Redo Lab 01 on RHEL (free developer subscription), then drill these under a 2.5-hour timer:
- Boot: reset root password, set default target, fix a broken `/etc/fstab` from the emergency shell.
- Storage: partitions, LVM create/extend, VDO/Stratis (if on current objectives), swap, NFS and autofs mounts.
- Users: users, groups, sudo, password aging.
- Networking: `nmcli` static IP, hostname, `firewalld`.
- SELinux: contexts, booleans (`setsebool -P`), ports.
- Services and scheduling: systemd, `cron`, `at`, `tuned`, `chronyd` (time sync).
- Containers with Podman: run a rootless container as a **systemd user service** that starts at boot
  (`podman generate systemd` or Quadlet files in `~/.config/containers/systemd/`).
- Software: configure repos (`/etc/yum.repos.d/`), `dnf`, modules.
Mock exam: `mock-rhcsa.md`. **Reboot at the end and verify every task.**

## Part B: Ansible for RHCE (EX294)
Setup: one control node + 3-4 managed nodes (VMs). Passwordless SSH + sudo for user `ansible`.
```bash
cd ansible
ansible all -m ping
ansible webservers -m dnf -a "name=httpd state=present" -b      # ad-hoc
ansible-playbook site.yml --check --diff                         # dry run
ansible-playbook site.yml
ansible-vault create group_vars/vault.yml
ansible-doc -l | grep firewall ; ansible-doc ansible.posix.firewalld
```
Learn in order: inventory (static, groups, host_vars), modules, playbooks, variables and facts, `when`, loops,
handlers, `block/rescue`, Jinja2 templates, roles (`ansible-galaxy init`), collections (`ansible.posix`,
`community.general`, RHEL system roles), Vault, `ansible-navigator`.
Exercise: write playbooks that do **every RHCSA task** (users, LVM, firewall, SELinux, cron, Podman service).

## Real-world scenarios
1. Patch 50 servers with a rolling playbook (`serial: 5`), stop if a health check fails.
2. Enforce a hardened SSH config on every host; handler restarts sshd only on change.
3. Rotate a password stored in Vault across all servers.

**Cert mapping:** RHCSA EX200, RHCE EX294 (Ansible), foundation for RHCA and EX374 (Ansible Automation Platform).
