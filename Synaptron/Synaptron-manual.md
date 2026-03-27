# 🧬 Timpi Synaptron – Manual Installation Guide for Users

<img width="1480" height="862" src="https://github.com/user-attachments/assets/b0749433-3720-4422-a14d-26c4dec067c3"/>

---

# Table of Contents

1. [Overview](#1-overview)  
2. [What This Manual Guide Does](#2-what-this-manual-guide-does)  
3. [Minimum Requirements](#3-minimum-requirements)  
4. [Before You Begin](#4-before-you-begin)  
5. [Remove Any Old Synaptron Installation](#5-remove-any-old-synaptron-installation)  
6. [Install Docker](#6-install-docker)  
7. [Add Your User to the Docker Group](#7-add-your-user-to-the-docker-group)  
8. [Make Sure Snap Docker Is Not Installed](#8-make-sure-snap-docker-is-not-installed)  
9. [Install or Verify NVIDIA Driver](#9-install-or-verify-nvidia-driver)  
10. [Install NVIDIA Container Toolkit](#10-install-nvidia-container-toolkit)  
11. [Test GPU Access Inside Docker](#11-test-gpu-access-inside-docker)  
12. [Decide Which Synaptron CUDA Version to Use](#12-decide-which-synaptron-cuda-version-to-use)  
13. [Create the Synaptron Folder](#13-create-the-synaptron-folder)  
14. [Create the docker-compose.yml File](#14-create-the-docker-composeyml-file)  
15. [Edit the File with Your NAME and GUID](#15-edit-the-file-with-your-name-and-guid)  
16. [Start Synaptron](#16-start-synaptron)  
17. [Check That the Containers Are Running](#17-check-that-the-containers-are-running)  
18. [Check Synaptron Logs](#18-check-synaptron-logs)  
19. [Check Neo4j Logs](#19-check-neo4j-logs)  
20. [Stop Synaptron](#20-stop-synaptron)  
21. [Restart Synaptron](#21-restart-synaptron)  
22. [Update Synaptron Manually](#22-update-synaptron-manually)  
23. [Remove Synaptron Manually](#23-remove-synaptron-manually)  
24. [Troubleshooting](#24-troubleshooting)  
25. [What to Send for Support](#25-what-to-send-for-support)  

---

# 1. Overview

This guide explains how to install **Timpi Synaptron manually**, without using the installer scripts.

This is useful if:

- you want full control over each step
- you want to troubleshoot manually
- you do not want to run `curl | bash`
- you want to understand exactly what is being installed

This guide is intended for:

- Ubuntu 22.04 or newer
- Debian-based Linux systems
- Proxmox VMs with NVIDIA GPU passthrough

---

# 2. What This Manual Guide Does

You will manually:

- install Docker
- install Docker Compose
- verify NVIDIA drivers
- install NVIDIA Container Toolkit
- test GPU access inside Docker
- create the `~/Synaptron` folder
- create `docker-compose.yml`
- enter your **NAME**
- enter your **GUID**
- choose the correct CUDA image
- start the Synaptron stack

---

# 3. Minimum Requirements

| Component | Minimum Requirement |
|----------|---------------------|
| CPU | 4 cores |
| RAM | 12 GB |
| GPU | NVIDIA GPU |
| VRAM | 4 GB+ |
| Storage | 250 GB SSD / NVMe |
| OS | Ubuntu 22.04+ |

---

# 4. Before You Begin

You need:

- your Synaptron **GUID**
- a node **NAME** with at least 17 characters
- an NVIDIA GPU with working drivers

Your node name should only contain:

- letters
- numbers
- underscore `_`
- dash `-`

Example:


timpi_synaptron_node01


---

# 5. Remove Any Old Synaptron Installation

If you have installed Synaptron before, remove the old setup first.

Stop and remove old containers:

```bash
sudo docker stop timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true
sudo docker rm timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true
```

Remove old images:

```bash
sudo docker rmi -f timpiltd/timpi-synaptron-universal:latest 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda24 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda28 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron:latest 2>/dev/null || true
```

Remove the old folder:

```bash
rm -rf ~/Synaptron
```

---

# 6. Install Docker

First update the system:

```bash
sudo apt update
```

Install required packages:

```bash
sudo apt install -y ca-certificates curl gnupg lsb-release
```

Create Docker’s keyring folder:

```bash
sudo mkdir -p /etc/apt/keyrings
```

Add Docker’s official GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Add the Docker repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update package lists again:

```bash
sudo apt update
```

Install Docker Engine and Compose plugin:

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Enable and start Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Verify Docker:

```bash
docker version
```

Verify Docker Compose:

```bash
docker compose version
```

---

# 7. Add Your User to the Docker Group

This lets you run Docker without `sudo`.

```bash
sudo usermod -aG docker "$USER"
newgrp docker
```

Now test:

```bash
docker ps
```

If it works without permission errors, you are ready to continue.

---

# 8. Make Sure Snap Docker Is Not Installed

Synaptron should not use the Snap version of Docker.

Check:

```bash
snap list 2>/dev/null | grep '^docker '
```

If Docker appears there, remove it:

```bash
sudo snap remove docker
```

Then make sure you are using Docker CE from Docker’s official repository.

---

# 9. Install or Verify NVIDIA Driver

Check if the NVIDIA driver is working:

```bash
nvidia-smi
```

If it works, you should see:

* your GPU model
* driver version
* CUDA version

If `nvidia-smi` is missing or broken, install or repair the driver.

Example:

```bash
sudo apt remove --purge '^nvidia-.*'
sudo apt remove --purge '^libnvidia-.*'
sudo apt autoremove -y
sudo apt install -y nvidia-driver-550
sudo reboot
```

After reboot, run again:

```bash
nvidia-smi
```

Do not continue until this works correctly.

---

# 10. Install NVIDIA Container Toolkit

This step is required so Docker can use your GPU.

Add the NVIDIA Container Toolkit key:

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
```

Add the NVIDIA Container Toolkit repository:

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null
```

Update packages:

```bash
sudo apt update
```

Install the toolkit:

```bash
sudo apt install -y nvidia-container-toolkit
```

Configure Docker runtime:

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```

Restart Docker:

```bash
sudo systemctl restart docker
```

---

# 11. Test GPU Access Inside Docker

Run this command:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

If the NVIDIA table appears inside the container, Docker GPU support is working.

If it fails, do not continue until this works.

---

# 12. Decide Which Synaptron CUDA Version to Use

Synaptron currently uses two image options:

* `cuda24`
* `cuda28`

Use this rule:

* **Blackwell GPUs** such as RTX 5090, 5080, 5070 → use `cuda28`
* all other supported NVIDIA GPUs → use `cuda24`

You can check your GPU model with:

```bash
nvidia-smi --query-gpu=name --format=csv,noheader
```

Examples:

* RTX 5090 → `cuda28`
* RTX 5080 → `cuda28`
* RTX 5070 → `cuda28`
* RTX 4090 → `cuda24`
* RTX 3090 → `cuda24`
* RTX 2080 → `cuda24`

---

# 13. Create the Synaptron Folder

Create the installation directory:

```bash
mkdir -p ~/Synaptron
cd ~/Synaptron
```

---

# 14. Create the docker-compose.yml File

Create the file:

```bash
vim docker-compose.yml
```

Paste the following content:

```yaml
x-synaptron-vars: &synaptron-vars
  TORCHMIRROR: "http://example.com/torchmirror"
  NAME: YOUR_NODE_NAME_HERE
  GUID: YOUR_GUID_HERE
  ARCH: t3_cuda24

services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    privileged: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 300 --stop-timeout 60s --cleanup synaptron_universal
    environment:
      - DOCKER_API_VERSION=1.44

  neo4j:
    image: neo4j:5-community
    container_name: neo4jtest
    restart: unless-stopped
    ports:
      - "7475:7474"
      - "7688:7687"
    environment:
      - NEO4J_AUTH=neo4j/min8-imfree
    volumes:
      - neo4jtest_data:/data
      - neo4jtest_logs:/logs
      - neo4jtest_plugins:/plugins

  synaptron:
    image: timpiltd/timpi-synaptron-universal:cuda24
    pull_policy: always
    restart: always
    container_name: synaptron_universal
    dns:
      - 100.42.180.29
      - 100.42.180.99
      - 8.8.8.8
      - 1.1.1.1
    ports:
      - "8000:8000"
    environment: *synaptron-vars
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: ["gpu"]
    stdin_open: true
    tty: true
    runtime: nvidia
    command: ./entrypoint.sh

volumes:
  neo4jtest_data:
  neo4jtest_logs:
  neo4jtest_plugins:
```

Save and exit.

---

# 15. Edit the File with Your NAME and GUID

Open the file again:

```bash
vim docker-compose.yml
```

Change these fields:

## Replace NAME

Change:

```yaml
NAME: YOUR_NODE_NAME_HERE
```

to your real node name, for example:

```yaml
NAME: timpi_synaptron_node01
```

## Replace GUID

Change:

```yaml
GUID: YOUR_GUID_HERE
```

to your real GUID.

## Replace ARCH if needed

If your GPU is Blackwell, use:

```yaml
ARCH: t3_cuda28
```

Otherwise use:

```yaml
ARCH: t3_cuda24
```

## Replace image tag if needed

If you use Blackwell, also change:

```yaml
image: timpiltd/timpi-synaptron-universal:cuda24
```

to:

```yaml
image: timpiltd/timpi-synaptron-universal:cuda28
```

For non-Blackwell GPUs, keep `cuda24`.

---

# 16. Start Synaptron

From inside `~/Synaptron`, run:

```bash
docker compose up --pull=always -d
```

This starts the full Synaptron stack in the background.

---

# 17. Check That the Containers Are Running

Run:

```bash
docker compose ps
```

You should see:

* `synaptron_universal`
* `neo4jtest`
* `watchtower`

running or starting.

---

# 18. Check Synaptron Logs

To follow the main Synaptron logs:

```bash
docker logs -f synaptron_universal
```

Healthy startup logs often include lines like:

```text
NAME has been written to .name
GUID has been written to .wilson
Running the initial setup script...
ARCH provided from environment: t3_cuda24
Final ARCH selection in entrypoint: t3_cuda24
```

or:

```text
ARCH provided from environment: t3_cuda28
Final ARCH selection in entrypoint: t3_cuda28
```

---

# 19. Check Neo4j Logs

If needed:

```bash
docker logs -f neo4jtest
```

---

# 20. Stop Synaptron

To stop the stack:

```bash
cd ~/Synaptron
docker compose stop
```

---

# 21. Restart Synaptron

To restart the stack:

```bash
cd ~/Synaptron
docker compose restart
```

---

# 22. Update Synaptron Manually

To pull the latest images and restart:

```bash
cd ~/Synaptron
docker compose pull
docker compose up -d
```

---

# 23. Remove Synaptron Manually

To remove the installation:

```bash
cd ~/Synaptron
docker compose down
rm -rf ~/Synaptron
```

---

# 24. Troubleshooting

## Docker permission problem

If Docker says permission denied:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
```

Then test again:

```bash
docker ps
```

## NVIDIA driver problem

If `nvidia-smi` fails, fix the driver before continuing. Synaptron will not work without a healthy NVIDIA installation.

## Docker cannot use GPU

Run again:

```bash
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Then retest:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

## Synaptron is not starting

Check status:

```bash
cd ~/Synaptron
docker compose ps
```

Check logs:

```bash
docker logs --tail 50 synaptron_universal
docker logs --tail 50 neo4jtest
```

---

# 25. What to Send for Support

If you need help, send:

```bash
nvidia-smi
docker compose version
docker compose ps
docker logs --tail 50 synaptron_universal
docker logs --tail 50 neo4jtest
```

Also include:

* your GPU model
* whether you used `cuda24` or `cuda28`
* your GUID

```

A small improvement I would still recommend in this manual: in section 15, tell users to change both `ARCH` and the `image:` line together, because that is the one place people are most likely to make a mismatch.

I can also format this next as a shorter **GitHub-ready README version** with cleaner spacing and anchor links.
```
