# 🌍 Timpi GeoCore

<img width="1509" height="850" src="https://github.com/user-attachments/assets/7b69280a-a77b-46d3-85d0-88b517c097bb" />

A **GeoCore Node** powers Timpi's decentralized network by:

* announcing your physical region (e.g. `Sweden/Stockholm`)
* connecting to the **TAP** (Timpi Access Point)
* routing search traffic to the nearest Guardians
* improving global decentralization and performance

GeoCore is **lightweight**, **Docker-based**, and built for 24/7 operation.

> [!TIP]
> **Already running an older GeoCore?** Skip ahead to **[Section 6 — Upgrading](#6-upgrading)** for a clean stop / pull / re-run.

---

## 📑 Table of Contents

1. [System requirements](#1-system-requirements)
2. [Get your GUID](#2-get-your-guid)
3. [Install Docker](#3-install-docker)
4. [Install GeoCore](#4-install-geocore)
5. [Verify and monitor logs](#5-verify-and-monitor-logs)
6. [Upgrading](#6-upgrading)
7. [Run multiple GeoCores](#7-run-multiple-geocores)
8. [Docker parameter reference](#8-docker-parameter-reference)
9. [Troubleshooting](#9-troubleshooting)
10. [Community & support](#10-community--support)

---

## 1. System requirements

| Component | Recommended minimum |
| --- | --- |
| OS | **Ubuntu 22.04 LTS (native)** |
| CPU | 4 cores |
| RAM | 8 GB |
| Storage | 3 GB |
| Bandwidth | 50 Mbps |
| Uptime | 95%+ |
| Port | **4013/TCP** (default — any free TCP port works) |
| Docker | Required |

### Officially supported

* Ubuntu 22.04 LTS (native)
* Native Docker
* FluxOS Marketplace deployments

### Not supported (community-only)

* Windows, WSL, macOS
* Proxmox LXC
* Other Linux distributions

---

## 2. Get your GUID

Register at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management). Full guide: [Timpi-official/Nodes/Registration](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md).

A GUID looks like `2f7256b8-c275-429b-8077-01519cced572`.

---

## 3. Install Docker

Skip this section if `docker version` already works.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y docker-ce
sudo systemctl status docker
```

Expected: `active (running)`. Then add your user to the docker group:

```bash
sudo usermod -aG docker $USER
```

Log out and back in.

---

## 4. Install GeoCore

You have two options. Pick one.

### Option A — Automatic install (recommended)

The official script asks for the port, GUID, and location, then launches the container:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Timpi-official/Nodes/main/Geocore/GC-AutoInstall.sh)
```

#### Example run

```text
🌐 Timpi GeoCore Setup Script

➡️ Enter the port for GeoCore (Default: 4013)
GeoCore Port: 4013

🆔 Enter your GUID (Found in your Timpi dashboard)
GUID: YOUR-ACTUAL-GUID-HERE

📍 Country (Example: Sweden, Germany, United States): Sweden
🏙️ City (Example: Stockholm, Berlin, New York): Stockholm

✅ Location set to: Sweden/Stockholm
🚀 Launching GeoCore container...
✅ GeoCore is now running on port 4013
```

### Option B — Manual install (any port)

```bash
sudo docker run -d \
  --name geocore \
  --pull=always --restart unless-stopped \
  --dns=100.42.180.29 --dns=100.42.180.99 --dns=1.1.1.1 \
  -p 4013:4013 \
  -v /var/timpi:/var/timpi \
  -e COMPORT=4013 \
  -e GUID="your-guid-here" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

> [!IMPORTANT]
> The two `100.42.180.*` DNS entries are **Timpi's name servers** and are **required** — your GeoCore needs them to talk to TAP and other Timpi services. The `1.1.1.1` entry is a public Cloudflare fallback for general DNS lookups.

### Open the port

```bash
sudo ufw allow 4013/tcp
```

On your router, forward `External:4013 → Internal:4013 (TCP)` to the GeoCore host.

---

## 5. Verify and monitor logs

### Live container logs

If only one GeoCore is running:

```bash
sudo docker logs -f $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

If multiple GeoCores are running, filter by the port:

```bash
sudo docker logs -f $(sudo docker ps --filter "publish=4013" -q)   # GeoCore on port 4013
```

### Persistent log files

```bash
sudo tail -f $(ls -t /var/timpi/GeoCore/logs/GeoCore-log*.txt | head -n 1)
```

Optional alias:

```bash
alias geocorelog='sudo tail -f $(ls -t /var/timpi/GeoCore/logs/GeoCore-log*.txt | head -n 1)'
```

### DataCom logs

```bash
sudo tail -f /var/timpi/Datacom-log*.txt
```

### Healthy GeoCore startup

```text
Environment variable 'GUID' found - <YOUR GUID>
Environment variable 'LOCATION' found - Sweden/Stockholm
GeoCore: ConnectionPort found 4013
INFO: Got version 1.1.xx from core - Own version: 1.1.xx
INFO: GeoCore is running on the main network
GeoCore: Production mode detected.
Now listening on: http://[::]:4013
INFO: Found 78 free Guardians in 11 regions
```

### Healthy DataCom logs

```text
Datacom: Found Version 1.0.2
INFO: Datacom is up to date
INFO: Reading Public Suffix List
Starting master timer.
Starting worker!
```

### Status check (Discord)

In Discord, run `/geocore` with your GUID and port. See [../NodeChecker/README.md](../NodeChecker/README.md).

---

## 6. Upgrading

GeoCore uses `--pull=always`, so updating is a stop / remove / re-run cycle.

### 6.1 Stop and remove the old container

```bash
sudo docker stop $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
sudo docker rm   $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### 6.2 Pull the new version

```bash
sudo docker pull timpiltd/timpi-geocore:latest
```

### 6.3 Re-run with the same parameters

Use the same `docker run` command from [Section 4 Option B](#option-b--manual-install-any-port), or re-run the auto-installer.

### 6.4 Verify

```bash
sudo docker logs -f $(sudo docker ps --filter "publish=4013" -q)
```

Look for `GeoCore is running on the main network` and `Found X free Guardians`.

### 6.5 Deep clean (only if you're switching ports / GUID, or fixing a broken install)

> [!WARNING]
> The commands below remove **all** GeoCore containers, images, and persistent data. Skip this unless you really need a clean slate.

```bash
# Remove ALL GeoCore containers (including randomly-named ones)
sudo docker ps -a --filter "ancestor=timpiltd/timpi-geocore" -q | xargs -r sudo docker rm -f

# Remove ALL GeoCore images
sudo docker rmi -f $(docker images timpiltd/timpi-geocore -q) 2>/dev/null

# Remove persistent data
sudo rm -rf /var/timpi/GeoCore   # GeoCore only
# or
sudo rm -rf /var/timpi           # GeoCore + DataCom

# Optional Docker housekeeping
sudo docker container prune -f
sudo docker image prune -f
sudo docker volume prune -f
```

After cleanup, reinstall with [Section 4](#4-install-geocore).

---

## 7. Run multiple GeoCores

Each node needs a **unique container name, port, volume folder, and GUID**.

```bash
# GeoCore #2
sudo docker run -d \
  --name geocore2 \
  --pull=always --restart unless-stopped \
  --dns=100.42.180.29 --dns=100.42.180.99 --dns=1.1.1.1 \
  -p 4014:4014 \
  -v /var/timpi2:/var/timpi \
  -e COMPORT=4014 \
  -e GUID="your-second-guid" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest

# GeoCore #3 → port 4015, /var/timpi3, third GUID
# GeoCore #4 → port 4016, /var/timpi4, fourth GUID
```

---

## 8. Docker parameter reference

| Parameter | Description |
| --- | --- |
| `--pull=always` | Always fetch the latest image |
| `--restart unless-stopped` | Auto-restart on crash |
| `--dns 100.42.180.29 / .99` | **Required** Timpi name servers — used to reach TAP and Timpi services |
| `--dns 1.1.1.1` | Cloudflare fallback for general DNS lookups |
| `-p PORT:PORT` | GeoCore exposed port |
| `-v /var/timpiX:/var/timpi` | Unique volume per node |
| `-e GUID=` | GeoCore identity |
| `-e COMPORT=` | GeoCore port |
| `-e LOCATION=` | Country/City |

---

## 9. Troubleshooting

### Restart a stopped GeoCore

```bash
sudo docker start $(sudo docker ps -a --filter "ancestor=timpiltd/timpi-geocore:latest" -q)
```

### DNS issues

```bash
sudo docker exec -it geocore cat /etc/resolv.conf
```

### Permission issues

```bash
sudo chmod -R 777 /var/timpi
```

(Tighten as needed for your security posture.)

---

## 10. Community & support

* [Timpi Discord — GeoCore channel](https://discord.com/channels/946982023245992006)
* [Open a support ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
* [Registration guide](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)
