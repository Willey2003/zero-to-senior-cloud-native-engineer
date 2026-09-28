# Lab 01: Linux From Absolute Zero

## Why this matters
Almost every server on the internet, every container and every Kubernetes node runs Linux.
If you know Linux well, everything later (Docker, Kubernetes, cloud) is much easier.

---

## Module 1: The terminal and files (week 1-2)

### Concepts
- Everything in Linux is a **file**, organised in one tree starting at `/` (called "root").
- Important folders: `/home` (users' files), `/etc` (settings), `/var/log` (logs), `/tmp` (temporary),
  `/usr/bin` (programs), `/proc` (live info about running programs).
- A command looks like: `command -options arguments`, e.g. `ls -l /etc`.
- **Absolute path** starts with `/` (`/etc/hosts`); **relative path** starts from where you are (`docs/a.txt`).

### Hands-on
```bash
whoami                 # who am I?
pwd                    # where am I?
ls -la                 # list all files, long format
cd /etc && ls          # go to /etc and list
cd ~                   # go home
mkdir -p practice/day1 # make folders
cd practice/day1
touch notes.txt        # create empty file
echo "hello linux" > notes.txt   # write (overwrite)
echo "second line" >> notes.txt  # append
cat notes.txt
cp notes.txt backup.txt
mv backup.txt old.txt
rm old.txt
man ls                 # the manual. Press q to quit. Use this ALWAYS.
ls --help
```
Learn `vim` basics: `vim file` → press `i` to type → `Esc` → `:wq` to save and quit, `:q!` to quit without saving.
Run `vimtutor` once (30 minutes). You will need vim in every hands-on exam.

### Finding things
```bash
find /etc -name "*.conf" -type f
grep -r "PermitRootLogin" /etc/ssh/
which python3
locate passwd          # (after: sudo dnf install mlocate && sudo updatedb)
```

### Pipes and redirection (very important)
```bash
cat /etc/passwd | wc -l                 # count lines
ps aux | grep sshd                      # filter output
ls /nonexistent 2> errors.txt           # save errors only
command > all.txt 2>&1                  # save output and errors
sort names.txt | uniq -c | sort -nr     # count duplicates
```

---

## Module 2: Users, groups and permissions (week 3-4)

### Concepts
- Every file has an **owner**, a **group**, and permissions for **u**ser, **g**roup, **o**thers.
- Permissions: **r**ead (4), **w**rite (2), e**x**ecute (1). `chmod 750 file` = rwx for user, r-x for group, nothing for others.
- `root` is the all-powerful admin. Normal users use `sudo` to run admin commands.

### Hands-on
```bash
sudo useradd alice
sudo passwd alice
sudo groupadd devs
sudo usermod -aG devs alice
id alice
sudo mkdir /srv/project
sudo chown root:devs /srv/project
sudo chmod 2770 /srv/project     # 2 = setgid: new files inherit group "devs"
ls -ld /srv/project
sudo chage -M 90 alice           # password expires every 90 days
sudo visudo                      # safely edit sudo rules
```
Special permissions: SUID (`4xxx`), SGID (`2xxx`), sticky bit (`1xxx`, like on `/tmp`).
ACLs: `setfacl -m u:bob:rx /srv/project` and `getfacl /srv/project`.

---

## Module 3: Processes, services and logs (week 5-6)

```bash
ps aux --sort=-%mem | head       # top memory users
top                              # live view (q to quit); also try htop
kill -15 <PID>                   # ask politely to stop
kill -9 <PID>                    # force kill (last resort)
systemctl status sshd
sudo systemctl enable --now httpd  # start now AND at every boot
sudo systemctl restart httpd
journalctl -u httpd --since "10 min ago"
journalctl -p err -b             # errors since this boot
crontab -e                       # add: */5 * * * * /home/student/backup.sh
```
Write your own service: see `scripts/hello.service` and `scripts/hello.sh`.

---

## Module 4: Storage (week 7-8)

### Concepts
Disk → partitions → (optional LVM: physical volume → volume group → logical volume) → filesystem → mount point.
LVM lets you grow storage without downtime, which is why every real server uses it.

### Hands-on (add a second 5 GB virtual disk to your VM first)
```bash
lsblk
sudo parted /dev/sdb mklabel gpt
sudo parted /dev/sdb mkpart primary 1MiB 100%
sudo pvcreate /dev/sdb1
sudo vgcreate vgdata /dev/sdb1
sudo lvcreate -n lvapp -L 2G vgdata
sudo mkfs.xfs /dev/vgdata/lvapp
sudo mkdir /app
echo "/dev/vgdata/lvapp /app xfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a && df -h /app
sudo lvextend -r -L +1G /dev/vgdata/lvapp   # grow it live, -r resizes the filesystem too
```
Swap: `lvcreate -n lvswap -L 512M vgdata; mkswap ...; swapon ...; add to fstab`.

---

## Module 5: Packages, boot, SELinux, troubleshooting (week 9-10)

```bash
sudo dnf install -y httpd        # RHEL/Rocky; on Ubuntu: sudo apt install apache2
dnf provides */semanage
getenforce                       # SELinux: Enforcing / Permissive / Disabled
ls -Z /var/www/html
sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
sudo restorecon -Rv /web
sudo semanage port -a -t http_port_t -p tcp 8080
sudo ausearch -m avc -ts recent  # why did SELinux block something?
```
Boot: `systemctl get-default`, `systemctl set-default multi-user.target`.
**Reset a forgotten root password** (classic RHCSA task): interrupt GRUB, add `rd.break`, `mount -o remount,rw /sysroot`,
`chroot /sysroot`, `passwd`, `touch /.autorelabel`, exit twice.

---

## Real-world scenarios (do these after the modules)

1. **"Website down after reboot."** Run `scripts/break-web.sh` (in a snapshot VM!). Find and fix 3 problems.
   Hints: `systemctl is-enabled`, `ss -tlnp`, `journalctl`, `ausearch`.
2. **"Server says disk full."** Run `scripts/fill-disk.sh`. Find what is eating space with `du -sh /* | sort -h`,
   and a deleted-but-open log file with `lsof +L1`.
3. **"User cannot write to shared folder."** Fix ownership, setgid bit and ACLs.
4. **"Server slow."** Run `scripts/cpu-hog.sh`, find it with `top`, lower its priority with `renice`, then stop it.

## Check yourself
- [ ] Explain the difference between `>` and `>>`, `2>` and `2>&1`.
- [ ] Explain `chmod 640` in words.
- [ ] Create an LV, format, mount persistently, extend it, reboot and verify.
- [ ] Write a systemd service that starts at boot.
- [ ] Serve a website from a non-default folder with SELinux enforcing.

**Cert mapping:** RHCSA EX200 (almost all objectives), LFCS.
