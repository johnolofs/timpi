# 🐧 Synaptron — Linux Auto-Installer

A one-line installer that:

* validates Docker, Docker Compose, NVIDIA drivers, and the container toolkit
* detects your GPU and picks the correct CUDA image (`cuda24` or `cuda28`)
* prompts for **NAME** + **GUID**, patches `docker-compose.yml`, and starts the stack

For a full manual walkthrough, see [linux-manual.md](linux-manual.md) instead.

---

## 📑 Table of Contents

1. [Remove older Synaptron installations](#1-remove-older-synaptron-installations)
2. [System requirements](#2-system-requirements)
3. [Install Docker](#3-install-docker)
4. [Install Docker Compose](#4-install-docker-compose)
5. [Install NVIDIA drivers](#5-install-nvidia-drivers)
6. [Install NVIDIA Container Toolkit](#6-install-nvidia-container-toolkit)
7. [Test GPU inside Docker](#7-test-gpu-inside-docker)
8. [One-line Synaptron install](#8-one-line-synaptron-install)
9. [Checking logs](#9-checking-logs)
10. [Updating Synaptron](#10-updating-synaptron)
11. [Uninstall](#11-uninstall)
12. [Troubleshooting](#12-troubleshooting)

---

## 1. Remove older Synaptron installations

Skip if this is a fresh machine.

### Stop and remove old containers

```bash
sudo docker stop timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true
sudo docker rm   timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true
```

### Remove old images

```bash
sudo docker rmi -f timpiltd/timpi-synaptron-universal:latest 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda24 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda28 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron:latest 2>/dev/null || true
```

### Remove old folder

```bash
rm -rf ~/Synaptron
```

The new installer fixes permissions automatically when needed.

---

## 2. System requirements

| Component | Minimum |
| --- | --- |
| CPU | 4 cores |
| RAM | 12 GB |
| GPU | NVIDIA, Compute Capability ≥ 6.1 |
| VRAM | 4 GB+ |
| Storage | 250 GB SSD / NVMe |
| OS | Ubuntu 22.04 LTS or Proxmox VM with GPU passthrough |

---

## 3. Install Docker

If `docker version` already works, skip ahead.

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker && sudo systemctl start docker
```

Add your user to the docker group so you don't need `sudo`:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker ps   # verify
```

> [!WARNING]
> **Do not use Snap Docker** — strict AppArmor confinement breaks GPU access. The installer will refuse to run if Snap Docker is detected.

---

## 4. Install Docker Compose

Synaptron needs Docker Compose v2.23+:

```bash
sudo apt install -y docker-compose-plugin
docker compose version
```

---

## 5. Install NVIDIA drivers

This guide doesn't force a specific driver version — different GPUs have different recommended drivers.

### Check existing driver

```bash
nvidia-smi
```

If this prints your GPU, you're good. If you see `nvidia-smi: command not found` or `Failed to initialize NVML`, install or repair the driver:

```bash
sudo apt remove --purge '^nvidia-.*'
sudo apt remove --purge '^libnvidia-.*'
sudo apt autoremove -y
sudo apt install -y nvidia-driver-550
sudo reboot
```

After reboot, re-run `nvidia-smi`. Don't continue until it works.

### CUDA compatibility

Synaptron is tested on:

* **CUDA 12.4** — Ada / Ampere / Turing / Pascal (cuda24 image)
* **CUDA 12.8+** — Blackwell GPUs (cuda28 image)

Other CUDA versions usually work but aren't officially tested.

---

## 6. Install NVIDIA Container Toolkit

Required so Docker can use the GPU:

```bash
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 7. Test GPU inside Docker

Pick the command matching your CUDA version:

```bash
# CUDA 12.4
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi

# CUDA 12.8
docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi
```

If the NVIDIA table appears inside the container, GPU access is working.

---

## 8. One-line Synaptron install

Run as a normal user (not root):

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/scripts/install.sh | bash
```

The installer asks for:

1. **Node NAME** (≥ 16 characters, e.g. `SynaptronNodeProxmox001`)
2. **GUID** from your Timpi dashboard

It then:

* creates `~/Synaptron/`
* downloads `docker-compose.yml` and `run-synaptron.sh`
* injects NAME + GUID into the YAML
* detects your GPU and picks `cuda24` or `cuda28`
* validates Docker, Compose, NVIDIA drivers, and toolkit
* starts `synaptron_universal`, `neo4jtest`, and `watchtower`

Success looks like:

```text
=========================================
   Synaptron is now running
=========================================
```

---

## 9. Checking logs

Live node output:

```bash
docker logs -f synaptron_universal
```

The first run will install PyTorch, CUDA libs, and download models — this is slow. It's ready when you see:

```text
Connected to Wilson...
Waiting for tasks...
```

---

## 10. Updating Synaptron

Watchtower auto-updates the running image every 5 minutes. To force an update:

```bash
cd ~/Synaptron
docker compose pull
docker compose up -d
```

---

## 11. Uninstall

```bash
cd ~/Synaptron
docker compose down
rm -rf ~/Synaptron
```

---

## 12. Troubleshooting

The installer detects most common failures and prints fix instructions. Common cases:

| Symptom | Fix |
| --- | --- |
| `nvidia-smi: command not found` | Install NVIDIA driver, reboot |
| `Failed to initialize NVML` | Driver mismatch — reinstall driver |
| `Snap Docker detected` | `sudo snap remove docker` and install Docker CE |
| `Cannot talk to Docker daemon` | `sudo usermod -aG docker $USER && newgrp docker` |
| Docker can't see GPU | Install `nvidia-container-toolkit`, run `nvidia-ctk runtime configure --runtime=docker`, restart Docker |
| Permission errors | The installer fixes ownership of `~/Synaptron` automatically when needed |

For deeper inspection:

```bash
cd ~/Synaptron
docker compose ps
docker logs --tail 50 synaptron_universal
docker logs --tail 50 neo4jtest
```

When opening a support ticket, include:

```bash
nvidia-smi
docker compose version
docker compose ps
docker logs --tail 50 synaptron_universal
```

Plus your GPU model, the image tag (`cuda24` / `cuda28`), and your GUID.

---

**Support:** [Timpi Discord — #synaptron-support](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
