# 🐧 Synaptron — Linux Auto-Installer

The fast path: a one-line installer that handles GPU detection, image-tag selection, and `docker compose up` automatically.

> [!NOTE]
> Looking for the full step-by-step Docker Compose walkthrough? Use **[linux-manual.md](linux-manual.md)** instead.

> [!TIP]
> **Already running an older Synaptron?** Skip ahead to **[Section 6 — Updating](#6-updating-synaptron)** to remove the old version cleanly first.

---

## 📑 Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Run the installer](#2-run-the-installer)
3. [Verify and check logs](#3-verify-and-check-logs)
4. [Day-2 operations](#4-day-2-operations)
5. [Uninstall](#5-uninstall)
6. [Updating Synaptron](#6-updating-synaptron)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Prerequisites

The installer assumes Docker, Docker Compose, NVIDIA drivers, and the NVIDIA Container Toolkit are all working. It checks each one and refuses to run if anything's missing.

### Hardware

| Component | Minimum |
| --- | --- |
| CPU | 4 cores |
| RAM | 12 GB |
| GPU | NVIDIA, Compute Capability ≥ 6.1 |
| VRAM | 4 GB+ |
| Storage | 250 GB SSD / NVMe |
| OS | Ubuntu 22.04 LTS or Proxmox VM with GPU passthrough |

### Identity

* **GUID** — register at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
* **Node NAME** — at least 17 characters (letters, digits, `_`, `-` only)

### Software prerequisites — quick check

Run all four commands. If any fails, follow the matching section in **[linux-manual.md](linux-manual.md)** to install / fix that component, then come back here.

```bash
docker version                                                                # → linux-manual.md §5
docker compose version                                                        # → linux-manual.md §5
nvidia-smi                                                                    # → linux-manual.md §8
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi     # → linux-manual.md §9–10
```

> [!WARNING]
> **Do not use Snap Docker** — strict AppArmor confinement breaks GPU access. The installer refuses to run if Snap Docker is detected. Remove it with `sudo snap remove docker` and install Docker CE.

---

## 2. Run the installer

Run as a **normal user** (not root):

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/scripts/install.sh | bash
```

The installer prompts for:

1. **Node NAME** (≥ 16 characters, e.g. `SynaptronNodeProxmox001`)
2. **GUID** from your Timpi dashboard

It then:

* creates `~/Synaptron/`
* downloads `docker-compose.yml` and `run-synaptron.sh`
* injects NAME + GUID into the YAML
* detects your GPU and picks `cuda24` or `cuda28`
* starts `synaptron_universal`, `neo4jtest`, and `watchtower`

Success looks like:

```text
=========================================
   Synaptron is now running
=========================================
```

---

## 3. Verify and check logs

```bash
docker logs -f synaptron_universal
```

The first run installs PyTorch, CUDA libs, and downloads models — this takes a while. Synaptron is ready when you see:

```text
Connected to Wilson...
Waiting for tasks...
```

In Discord, run `/synaptronchecker` with your GUID to confirm version and status.

---

## 4. Day-2 operations

| Action | Command |
| --- | --- |
| Live logs | `docker logs -f synaptron_universal` |
| Container status | `cd ~/Synaptron && docker compose ps` |
| Restart | `cd ~/Synaptron && docker compose restart` |
| Stop | `cd ~/Synaptron && docker compose stop` |
| Start again | `cd ~/Synaptron && docker compose start` |

Watchtower auto-updates the running image every 5 minutes — no manual intervention needed.

---

## 5. Uninstall

```bash
cd ~/Synaptron
docker compose down
rm -rf ~/Synaptron
```

To go further (remove images, free disk space):

```bash
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda24 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda28 2>/dev/null || true
```

---

## 6. Updating Synaptron

Watchtower handles updates automatically. To force one immediately:

```bash
cd ~/Synaptron
docker compose pull
docker compose up -d
```

### Reinstalling from scratch

If the auto-update misbehaves or you need to switch GPU classes (cuda24 ↔ cuda28), do a clean reinstall:

```bash
# Stop and remove containers
sudo docker stop synaptron_universal neo4jtest watchtower 2>/dev/null || true
sudo docker rm   synaptron_universal neo4jtest watchtower 2>/dev/null || true

# Remove old images
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda24 2>/dev/null || true
sudo docker rmi -f timpiltd/timpi-synaptron-universal:cuda28 2>/dev/null || true

# Remove the old folder
rm -rf ~/Synaptron
```

Then re-run the installer from [Section 2](#2-run-the-installer). Your GUID stays the same.

---

## 7. Troubleshooting

The installer detects most common failures and prints fix instructions. Common cases:

| Symptom | Fix |
| --- | --- |
| `nvidia-smi: command not found` | Install NVIDIA driver, reboot — see [linux-manual.md §8](linux-manual.md#8-install-or-verify-nvidia-driver) |
| `Failed to initialize NVML` | Driver mismatch — purge and reinstall the driver |
| `Snap Docker detected` | `sudo snap remove docker`, then install Docker CE |
| `Cannot talk to Docker daemon` | `sudo usermod -aG docker $USER && newgrp docker` |
| Docker can't see GPU | Install / reconfigure `nvidia-container-toolkit` — see [linux-manual.md §9](linux-manual.md#9-install-nvidia-container-toolkit) |
| Permission errors on `~/Synaptron` | The installer fixes ownership automatically — re-run it |

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
