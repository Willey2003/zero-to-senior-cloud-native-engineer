# Lab 00: Build Your Lab Computer

## Why this matters
Every engineer needs a safe place to break things. Your "home lab" is a set of virtual machines (VMs):
pretend computers running inside your real computer. If you destroy one, you delete it and make a new one.

## What you need
- A laptop/PC with **16 GB RAM** (8 GB works, but only 1-2 VMs at a time) and 100 GB free disk.
- Internet connection.

## Concepts (read slowly)
- **Operating system (OS):** the main program that controls the computer (Windows, macOS, Linux).
- **Linux distribution:** a "flavour" of Linux. We use **Rocky Linux / RHEL** (Red Hat family, for RHCSA)
  and **Ubuntu** (very common in cloud).
- **Hypervisor:** software that runs VMs (VirtualBox, VMware Workstation, Hyper-V, or Multipass).
- **Terminal / shell:** a text window where you type commands instead of clicking.

## Hands-on steps

### Option A (easiest, any OS): Multipass (Ubuntu VMs in one command)
```bash
# Install from https://multipass.run then:
multipass launch --name lab1 --cpus 2 --memory 2G --disk 20G
multipass shell lab1        # you are now inside Linux!
```

### Option B (for RHCSA practice): VirtualBox + Rocky Linux or RHEL
1. Install VirtualBox.
2. Get a free Red Hat Developer account at developers.redhat.com and download the RHEL DVD ISO
   (or download Rocky Linux 9 minimal ISO).
3. Create VM: 2 CPU, 2 GB RAM, 20 GB disk, network = "NAT" + a second adapter "Host-only".
4. Install with "Minimal install", set a root password and create user `student` with admin rights.
5. Make **two** VMs: `server1` and `server2`. Many RHCSA/RHCE tasks need two machines.

### Option C (Windows): WSL2
```powershell
wsl --install -d Ubuntu
```
Good for quick practice, but not for RHCSA (no systemd boot/disk labs).

### Install your tools (on your real computer)
- **VS Code** + extensions: Remote-SSH, YAML, Python, Docker, Kubernetes.
- **Git**: https://git-scm.com
- A terminal: Windows Terminal (Windows), iTerm2 (Mac).

### Connect to your VM with SSH
```bash
ssh student@<vm-ip>          # find the IP inside the VM with: ip -4 addr
```

### Your first Git commit (put this repo on your GitHub)
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git clone https://github.com/Willey2003/zero-to-senior-cloud-native-engineer.git
cd zero-to-senior-cloud-native-engineer
echo "# Week 1 - I installed my lab" > journal/week-01.md
git add journal/week-01.md
git commit -m "journal: week 1"
git push
```

## Check yourself
- [ ] I can start, stop, snapshot and delete a VM.
- [ ] I can SSH from my laptop into my VM.
- [ ] I made my first commit and see it on github.com.
- [ ] I took a **snapshot** of a clean VM so I can roll back after breaking it.
