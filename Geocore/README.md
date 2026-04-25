# 🌍 Timpi GeoCore

<img width="1509" height="850" src="https://github.com/user-attachments/assets/7b69280a-a77b-46d3-85d0-88b517c097bb" />

A **GeoCore Node** powers Timpi's decentralized network by:

* announcing your physical region (e.g. `Sweden/Stockholm`)
* connecting to the **TAP** (Timpi Access Point)
* routing search traffic to the nearest Guardians
* improving global decentralization and performance

GeoCore is **lightweight**, **Docker-based**, and built for 24/7 operation.

---

## 📑 Table of Contents

1. [System requirements](#1-system-requirements)
2. [Get your GUID](#2-get-your-guid)
3. [Two paths: new install vs. upgrade](#3-two-paths-new-install-vs-upgrade)
4. [Clean slate (optional but recommended)](#4-clean-slate-optional-but-recommended)
5. [New install path](#5-new-install-path)
6. [Upgrade path](#6-upgrade-path)
7. [Monitor logs](#7-monitor-logs)
8. [Expected logs & outputs](#8-expected-logs--outputs)
9. [Run multiple GeoCores](#9-run-multiple-geocores)
10. [Docker parameter reference](#10-docker-parameter-reference)
11. [Troubleshooting](#11-troubleshooting)
12. [Community & support](#12-community--support)

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
| Port | **4014/TCP** (default — any free port works) |
| Docker | Required |

### Officially supported

* ✅ Ubuntu 22.04 LTS (native)
* ✅ Native Docker
* ✅ FluxOS Marketplace deployments

### Not supported (community-only)

* ❌ Windows, WSL, macOS
* ❌ Proxmox LXC
* ❌ Other Linux distributions

---

## 2. Get your GUID

Register at 👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management). Full guide: [Timpi-official/Nodes/Registration](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md).

A GUID looks like `2f7256b8-c275-429b-8077-01519cced572`.

---

## 3. Two paths: new install vs. upgrade

| Path | When to use |
| --- | --- |
| 🟦 **New install** | First GeoCore on this machine — go to [Section 5](#5-new-install-path) |
| 🟩 **Upgrade** | Already running a GeoCore — go to [Section 6](#6-upgrade-path) |

> 🧹 If you're switching ports, changing GUID, or recovering from a broken install, run the [Clean slate](#4-clean-slate-optional-but-recommended) section first.

---

## 4. Clean slate (optional but recommended)

Removes all old GeoCore containers and images, including randomly-named ones like `epic_satoshi`.

### 4.1 Stop and remove all old GeoCore containers

```bash
sudo docker ps
sudo docker ps -a
sudo docker images
```

```bash
sudo docker stop <ContainerID>
sudo docker rm <ContainerID>
```

### 4.2 Remove all old GeoCore images

```bash
sudo docker rmi timpiltd/timpi-geocore:latest 2>/dev/null
sudo docker rmi -f $(docker images timpiltd/timpi-geocore -q) 2>/dev/null
sudo docker rmi -f $(docker images "timpiltd/timpi-geocore:*" -q) 2>/dev/null
```

### 4.3 Remove old GeoCore folders (optional)

```bash
sudo rm -rf /var/timpi/GeoCore         # GeoCore only
# or
sudo rm -rf /var/timpi                 # GeoCore + DataCom
```

### 4.4 Deep Docker cleanup (optional)

```bash
sudo docker container prune -f
sudo docker image prune -f
sudo docker volume prune -f
sudo docker network prune -f
```

---

## 5. New install path

### 5.1 Install Docker

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

### 5.2 Automatic install (script)

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Timpi-official/Nodes/main/Geocore/GC-AutoInstall.sh)
```

The official script asks for the port, GUID, and location, then launches the container.

### 5.3 Manual install (any port)

```bash
sudo docker run -d \
  --name geocore \
  --pull=always --restart unless-stopped \
  --dns=100.42.180.29 --dns=100.42.180.99 --dns=8.8.8.8 \
  -p 4014:4014 \
  -v /var/timpi:/var/timpi \
  -e COMPORT=4014 \
  -e GUID="your-guid-here" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

### 5.4 Open the port

```bash
sudo ufw allow 4014/tcp
```

On your router, forward `External:4014 → Internal:4014 (TCP)` to the GeoCore host.

---

## 6. Upgrade path

GeoCore uses `--pull=always`, so updating is just a stop + remove + re-run:

### 1️⃣ Stop and remove the container

```bash
sudo docker stop $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
sudo docker rm   $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### 2️⃣ Pull the new version

```bash
sudo docker pull timpiltd/timpi-geocore:latest
```

### 3️⃣ Re-run with the same parameters as before

(See [section 5.3](#53-manual-install-any-port).)

### 4️⃣ Verify

If your GeoCore runs on **4014**:

```bash
sudo docker logs -f $(sudo docker ps --filter "publish=4014" -q)
```

Look for:

```text
GeoCore is running on the main network
Found X free Guardians
```

---

## 7. Monitor logs

### Single GeoCore

```bash
sudo docker logs -f $(sudo docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### Multiple GeoCores — filter by port

```bash
sudo docker logs -f $(sudo docker ps --filter "publish=4014" -q)   # GeoCore 1
sudo docker logs -f $(sudo docker ps --filter "publish=4015" -q)   # GeoCore 2
```

### Persistent log file

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

---

## 8. Expected logs & outputs

### Healthy GeoCore startup

```text
Environment variable 'GUID' found - <YOUR GUID>
Environment variable 'LOCATION' found - Sweden/Stockholm
GeoCore: ConnectionPort found 4014
GeoCore: Log folder /var/timpi/GeoCore/logs created.
INFO: Got version 1.1.xx from core - Own version: 1.1.xx
INFO: GeoCore is running on the main network
GeoCore: Production mode detected.
Now listening on: http://[::]:4014
```

### Guardian scan

```text
INFO: Found 78 free Guardians in 11 regions
```

### Healthy DataCom logs

```text
Datacom: Found Version 1.0.2
INFO: Datacom is up to date
INFO: Reading Public Suffix List
INFO: Reading Top10 Million List
Done reading Top10 million file
Starting master timer.
Starting worker!
```

---

## 9. Run multiple GeoCores

Each node needs:

* unique container name
* unique port
* unique volume folder
* unique GUID

```bash
# GeoCore #2
sudo docker run -d \
  --name geocore2 \
  --pull=always --restart unless-stopped \
  --dns=100.42.180.29 --dns=100.42.180.99 --dns=8.8.8.8 \
  -p 4015:4015 \
  -v /var/timpi2:/var/timpi \
  -e COMPORT=4015 \
  -e GUID="your-second-guid" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest

# GeoCore #3 → port 4016, /var/timpi3, third GUID
# GeoCore #4 → port 4017, /var/timpi4, fourth GUID
```

---

## 10. Docker parameter reference

| Parameter | Description |
| --- | --- |
| `--pull=always` | Always fetch the latest image |
| `--restart unless-stopped` | Auto-restart on crash |
| `--dns` | Timpi DNS (with fallback) |
| `-p PORT:PORT` | GeoCore exposed port |
| `-v /var/timpiX:/var/timpi` | Unique volume per node |
| `-e GUID=` | GeoCore identity |
| `-e COMPORT=` | GeoCore port |
| `-e LOCATION=` | Country/City |

---

## 11. Troubleshooting

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

### Status check

In Discord, run `/geocore` with your GUID and port. See [../NodeChecker/README.md](../NodeChecker/README.md).

---

## 12. Community & support

* 💬 [Timpi Discord — GeoCore channel](https://discord.com/channels/946982023245992006)
* 🛠 [Open a support ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
* 📝 [Registration guide](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)
