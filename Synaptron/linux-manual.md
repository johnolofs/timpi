# 🐧 Synaptron — Manual Linux Installation

Step-by-step manual installation without `curl | bash`. Use this when you want full control, are auditing each step, or are troubleshooting a failed auto-install.

For the scripted path, see [linux.md](linux.md) instead.

---

## 📑 Table of Contents

1. [What you'll do manually](#1-what-youll-do-manually)
2. [Minimum requirements](#2-minimum-requirements)
3. [Before you begin](#3-before-you-begin)
4. [Remove any old Synaptron installation](#4-remove-any-old-synaptron-installation)
5. [Install Docker](#5-install-docker)
6. [Add your user to the Docker group](#6-add-your-user-to-the-docker-group)
7. [Make sure Snap Docker is not installed](#7-make-sure-snap-docker-is-not-installed)
8. [Install or verify NVIDIA driver](#8-install-or-verify-nvidia-driver)
9. [Install NVIDIA Container Toolkit](#9-install-nvidia-container-toolkit)
10. [Test GPU access inside Docker](#10-test-gpu-access-inside-docker)
11. [Decide cuda24 vs cuda28](#11-decide-cuda24-vs-cuda28)
12. [Create the Synaptron folder](#12-create-the-synaptron-folder)
13. [Create docker-compose.yml](#13-create-docker-composeyml)
14. [Edit NAME, GUID, and ARCH](#14-edit-name-guid-and-arch)
15. [Start Synaptron](#15-start-synaptron)
16. [Verify and check logs](#16-verify-and-check-logs)
17. [Stop, restart, update, remove](#17-stop-restart-update-remove)
18. [Troubleshooting](#18-troubleshooting)

---

## 1. What you'll do manually

* install Docker + Docker Compose
* verify NVIDIA drivers and Container Toolkit
* test GPU access inside Docker
* create `~/Synaptron/docker-compose.yml`
* enter your NAME and GUID
* choose the correct CUDA image
* start the stack

---

## 2. Minimum requirements

| Component | Minimum |
| --- | --- |
| CPU | 4 cores |
| RAM | 12 GB |
| GPU | NVIDIA, Compute Capability ≥ 6.1 |
| VRAM | 4 GB+ |
| Storage | 250 GB SSD / NVMe |
| OS | Ubuntu 22.04 LTS+ |

---

## 3. Before you begin

You need:

* a Synaptron **GUID** from [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
* a node **NAME** with **at least 17 characters** (letters, digits, `_`, `-` only)
* a working NVIDIA GPU

Example name: `timpi_synaptron_node01`

---

## 4. Remove any old Synaptron installation

```bash
sudo docker stop timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true
sudo docker rm   timpi-synaptron synaptron_universal neo4jtest watchtower 2>/dev/null || true

sudo docker rmi -f timpiltd/timpi-synaptron-universal:latest 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda24 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda28 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron:latest 2>/dev/null || true

rm -rf ~/Synaptron
```

---

## 5. Install Docker

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
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
```

Verify:

```bash
docker version
docker compose version
```

---

## 6. Add your user to the Docker group

Lets you run Docker without `sudo`:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker ps    # verify
```

---

## 7. Make sure Snap Docker is not installed

Snap Docker breaks GPU access:

```bash
snap list 2>/dev/null | grep '^docker '
```

If anything appears, remove it:

```bash
sudo snap remove docker
```

Use Docker CE from Docker's official repository (installed in step 5).

---

## 8. Install or verify NVIDIA driver

```bash
nvidia-smi
```

Should print your GPU model, driver version, and CUDA version. If broken or missing:

```bash
sudo apt remove --purge '^nvidia-.*' '^libnvidia-.*'
sudo apt autoremove -y
sudo apt install -y nvidia-driver-550
sudo reboot
```

Don't continue until `nvidia-smi` works.

---

## 9. Install NVIDIA Container Toolkit

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

---

## 10. Test GPU access inside Docker

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

If the NVIDIA table appears inside the container, you're set. Don't continue until this works.

---

## 11. Decide cuda24 vs cuda28

| GPU family | Image |
| --- | --- |
| Blackwell (RTX 5090 / 5080 / 5070) | `cuda28` |
| Ada Lovelace (RTX 4090, 4080, 4070, 4060) | `cuda24` |
| Ampere (RTX 3090, 3080, 3070, 3060) | `cuda24` |
| Turing (RTX 2080, 2070, 2060) | `cuda24` |
| Pascal (GTX 1080, 1070, 1060) | `cuda24` |

Check your model:

```bash
nvidia-smi --query-gpu=name --format=csv,noheader
```

---

## 12. Create the Synaptron folder

```bash
mkdir -p ~/Synaptron
cd ~/Synaptron
```

---

## 13. Create docker-compose.yml

```bash
nano docker-compose.yml
```

Paste:

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

> 💡 You can also download the canonical version directly:
> ```bash
> curl -fsSL -O https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/docker-compose.yml
> ```

---

## 14. Edit NAME, GUID, and ARCH

Open the file again:

```bash
nano docker-compose.yml
```

### Set NAME

Replace `YOUR_NODE_NAME_HERE` with your real node name (≥ 17 characters):

```yaml
NAME: timpi_synaptron_node01
```

### Set GUID

Replace `YOUR_GUID_HERE` with your real GUID.

### Pick the right CUDA image (Blackwell only)

If your GPU is Blackwell (RTX 5090 / 5080 / 5070), change **both**:

```yaml
ARCH: t3_cuda28
image: timpiltd/timpi-synaptron-universal:cuda28
```

For all other GPUs, leave them as `t3_cuda24` and `:cuda24`.

⚠️ **Both `ARCH` and the `image:` tag must match.** Mismatch is the most common manual-install bug.

---

## 15. Start Synaptron

```bash
cd ~/Synaptron
docker compose up --pull=always -d
```

---

## 16. Verify and check logs

Container status:

```bash
docker compose ps
```

You should see `synaptron_universal`, `neo4jtest`, and `watchtower` running.

Live Synaptron logs:

```bash
docker logs -f synaptron_universal
```

Healthy startup looks like:

```text
NAME has been written to .name
GUID has been written to .wilson
Running the initial setup script...
ARCH provided from environment: t3_cuda24
Final ARCH selection in entrypoint: t3_cuda24
```

(or `t3_cuda28` for Blackwell.)

Neo4j logs (if needed):

```bash
docker logs -f neo4jtest
```

---

## 17. Stop, restart, update, remove

| Action | Command |
| --- | --- |
| Stop | `cd ~/Synaptron && docker compose stop` |
| Restart | `cd ~/Synaptron && docker compose restart` |
| Update | `cd ~/Synaptron && docker compose pull && docker compose up -d` |
| Remove | `cd ~/Synaptron && docker compose down && rm -rf ~/Synaptron` |

---

## 18. Troubleshooting

### Docker permission denied

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker ps
```

### NVIDIA driver problem

If `nvidia-smi` fails, fix the driver before continuing — Synaptron will not work without a healthy NVIDIA installation.

### Docker can't see GPU

```bash
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

### Synaptron isn't starting

```bash
cd ~/Synaptron
docker compose ps
docker logs --tail 50 synaptron_universal
docker logs --tail 50 neo4jtest
```

### Opening a support ticket

Include:

```bash
nvidia-smi
docker compose version
docker compose ps
docker logs --tail 50 synaptron_universal
docker logs --tail 50 neo4jtest
```

Plus your GPU model, image tag (`cuda24` / `cuda28`), and GUID.

---

🆘 **Support:** [Timpi Discord — #synaptron-support](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
