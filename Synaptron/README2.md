# 🧬 **TIMPI SYNAPTRON — OFFICIAL INSTALLATION GUIDE**

### *Simple. Safe. One Command. Works on Ubuntu & Proxmox (VM).*

<img width="1480" height="862" src="https://github.com/user-attachments/assets/b0749433-3720-4422-a14d-26c4dec067c3" />

---

# 📑 **Table of Contents**

1. [Overview](#overview)
2. [Remove Older Synaptron Installations](#remove-older-synaptron-installations)
3. [System Requirements](#system-requirements)
4. [Install Docker](#install-docker)
5. [Install Docker Compose](#install-docker-compose)
6. [Install NVIDIA Drivers (Universal & Safe)](#install-nvidia-drivers-universal--safe)
7. [Install NVIDIA Container Toolkit](#install-nvidia-container-toolkit)
8. [One-Line Synaptron Installation](#one-line-synaptron-installation)
9. [What the Installer Does Automatically](#what-the-installer-does-automatically)
10. [Checking Logs](#checking-logs)
11. [Updating Synaptron](#updating-synaptron)
12. [Uninstall Synaptron](#uninstall-synaptron)
13. [Troubleshooting](#troubleshooting)
14. [Support](#support)

---

# 🧭 **Overview**

This is the **simplest and safest way** to install a Synaptron node on:

* **Ubuntu 22.04 LTS**
* **Proxmox VM with GPU passthrough**
* **Any Debian-based Linux with NVIDIA support**

✔ Fully automated
✔ No manual configuration
✔ No YAML editing
✔ No driver version guessing
✔ No permission errors
✔ Auto-updates via Watchtower

---

# ⚠️ **Remove Older Synaptron Installations**

If you installed Synaptron manually or with an older script, remove old containers first:

### Stop & remove old containers

```bash
docker stop synaptron_universal 2>/dev/null
docker rm synaptron_universal 2>/dev/null
docker stop neo4jtest 2>/dev/null
docker rm neo4jtest 2>/dev/null
docker stop watchtower 2>/dev/null
docker rm watchtower 2>/dev/null
```

### Remove old images

```bash
docker images | grep timpi
docker rmi timpiltd/timpi-synaptron-universal:latest 2>/dev/null
docker rmi timpiltd/timpi-synaptron:latest 2>/dev/null
```

### Check manually so all **old** containers/images are removed

```bash
sudo docker ps
sudo docker ps -a
sudo docker images
```

```bash
sudo docker rm containerID
sudo docker rmi imageID
```

### Remove old folder

```bash
rm -rf ~/Synaptron
```

💡 The new installer automatically fixes permissions **only when needed**.

---

# 🖥 **System Requirements**

| Component | Minimum                              |
| --------- | ------------------------------------ |
| CPU       | 4 cores                              |
| RAM       | 12 GB                                |
| GPU       | NVIDIA GPU (Compute Capability 6.1+) |
| VRAM      | 4 GB+                                |
| Storage   | 250 GB SSD/NVMe                      |
| OS        | Ubuntu 22.04 / Proxmox VM            |

---

# 🐳 **Install Docker**

Test if Docker already works:

```bash
docker version
```

If yes → skip to next section.

Otherwise install Docker CE:

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
```

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker && sudo systemctl start docker
```

---

# 📦 **Install Docker Compose**

Synaptron requires Docker Compose v2.23+

```bash
sudo apt install -y docker-compose-plugin
```

Check version:

```bash
docker compose version
```

---

# 🎮 **Install NVIDIA Drivers (Universal & Safe)**

This guide **does NOT force any specific driver version**
(because different GPUs require different drivers).

---

### ✔ Step 1 — Check if driver is already working

```bash
nvidia-smi
```

If you see your GPU → **Drivers OK. Continue to next step.**

---

### ✔ Step 2 — Driver missing or broken?

If you get:

```
nvidia-smi: command not found
```

or

```
Failed to initialize NVML
```

Download the correct driver for your GPU:

👉 [https://www.nvidia.com/Download/index.aspx](https://www.nvidia.com/Download/index.aspx)

Install, reboot, then test:

```bash
nvidia-smi
```

---

# 🧩 **Install NVIDIA Container Toolkit**

Required for GPU support inside Docker.

If your installer complains about GPU access, run:

```bash
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Test:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

---

# 🚀 **ONE-LINE SYNAPTRON INSTALLATION**

Run as **normal user**, NOT root:

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/install.sh | bash
```

Installer will ask:

### 1️⃣ Node NAME (≥16 characters)

Example:

```
SynaptronNodeProxmox001
```

### 2️⃣ GUID

Paste your Synaptron GUID.

---

# 🤖 **What the Installer Does Automatically**

The installer:

✔ Creates `~/Synaptron/`
✔ Fixes permissions **only if needed**
✔ Downloads fresh `docker-compose.yml`
✔ Downloads `run_synaptron.sh`
✔ Injects NAME + GUID into YAML
✔ Detects your CUDA version
✔ Selects correct image (cuda24/cuda26/cuda28)
✔ Validates:

* Docker
* Docker Compose
* NVIDIA drivers
* Toolkit
* GPU inside Docker

✔ Starts all containers:

* `synaptron_universal`
* `neo4jtest`
* `watchtower`

You will see:

```
Synaptron is now running
```

---

# 📡 **Checking Logs**

To view real-time node output:

```bash
docker logs -f synaptron_universal
```

Initial run will:

* Install PyTorch
* Install CUDA libs
* Download models
* Prepare NLP tools

It’s ready when you see:

```
Connected to Wilson...
Waiting for tasks...
```

---

# 🔄 **Updating Synaptron**

Synaptron updates automatically via Watchtower.

Manual update:

```bash
cd ~/Synaptron
docker compose pull
docker compose up -d
```

---

# ❌ **Uninstall Synaptron**

```bash
cd ~/Synaptron
docker compose down
rm -rf ~/Synaptron
```

---

# 🆘 **Troubleshooting**

The installer detects:

* Missing GPU access
* Broken NVIDIA drivers
* Missing container toolkit
* Snap docker installation
* Permission errors
* Old versions blocking install
* Incorrect CUDA environment

Example fix message:

```
Docker CANNOT access your NVIDIA GPU.
Fix steps:
  sudo apt install nvidia-container-toolkit
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
```
