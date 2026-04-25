# 🛡 Timpi Guardian

<img width="1509" height="850" alt="Guardian" src="https://github.com/user-attachments/assets/f11e358c-15cc-4618-bca0-cfcdb615a65d" />

A Guardian Node hosts a portion of Timpi's decentralized search index using **Apache Solr**. Guardians:

* Store segments of the Timpi index
* Serve search queries
* Improve regional latency
* Strengthen decentralization

---

## 📑 Table of Contents

1. [Supported systems & requirements](#1-supported-systems--requirements)
2. [Get your GUID](#2-get-your-guid)
3. [Install paths](#3-install-paths)
4. [Step 0 — Install Docker & Java](#4-step-0--install-docker--java)
5. [Step 0.5 — Create persistent storage](#5-step-05--create-persistent-storage)
6. [Step 1 — Quick start (automatic script)](#6-step-1--quick-start-automatic-script)
7. [Manual setup](#7-manual-setup)
8. [Run multiple Guardians](#8-run-multiple-guardians)
9. [Verification & troubleshooting](#9-verification--troubleshooting)
10. [Docker parameter reference](#10-docker-parameter-reference)
11. [Support](#11-support)

---

## 1. Supported systems & requirements

| Component | Recommended minimum |
| --- | --- |
| OS | **Ubuntu 22.04 LTS (native)** |
| CPU | 8+ cores |
| RAM | 12+ GB |
| Storage | **1 TB free** (Solr index grows over time) |
| Network | Stable 24/7 connection |
| Docker | Required |
| Ports | Solr + Guardian ports must be open |

> [!IMPORTANT]
> Officially supported: **Ubuntu 22.04 LTS + Docker**. Other environments (WSL, macOS, Windows, Proxmox LXC, etc.) may work but are unsupported.

---

## 2. Get your GUID

Register your Guardian NFT and copy the GUID at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management). Full registration guide: [Timpi-official/Nodes/Registration](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md).

---

## 3. Install paths

| Path | When to use |
| --- | --- |
| **New install** | First Guardian on this machine — go to [Step 0](#4-step-0--install-docker--java) |
| **Upgrade existing** | Already running a Guardian — see [Upgrade](#upgrade-an-existing-guardian) |

### Upgrade an existing Guardian

Remove the old container and image, then re-run the quick start:

```bash
sudo docker rm -f $(sudo docker ps -aq --filter "ancestor=timpiltd/timpi-guardian")
sudo docker rmi -f $(sudo docker images timpiltd/timpi-guardian -q)
```

Then jump to [Step 1 — Quick start](#6-step-1--quick-start-automatic-script).

---

## 4. Step 0 — Install Docker & Java

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce default-jre
sudo systemctl status docker
```

Expected: `Active: active (running)`.

### Add your user to the Docker group

Avoids `permission denied /var/run/docker.sock`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 5. Step 0.5 — Create persistent storage

```bash
mkdir -p ${HOME}/var/solrdocker/data
mkdir -p ${HOME}/var/solrdocker/logs
```

Inside the container these map to:

* `/var/solr/data`
* `/var/solr/logs`

---

## 6. Step 1 — Quick start (automatic script)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/johnolofs/timpi/main/Guardian/scripts/install.sh)
```

The script:

* Prompts for Solr port, Guardian port, GUID, country/city
* Creates persistent folders
* Starts the Guardian container with the right DNS, ports, and environment

### Expected script output

```text
===== Timpi Guardian – Quick Setup =====
➡️ Solr Port: 8983
➡️ Guardian Port: 4005
➡️ GUID: xxxx
📍 Country: Sweden
🏙️ City: Stockholm

📂 Creating data folder...
🚀 Starting Timpi Guardian container...
Status: Downloaded newer image...
✅ Guardian started successfully!
```

### Expected container logs

```text
INFO: Guardian is running on the main network
Guardian: Production mode detected.
Guardian port = 4005
Starting Solr instance...
Started Solr on port 8983. Happy searching!
```

### Expected persistent logs

```text
INFO: Triangulation successful. Region: EMEA
INFO: Got the Collection list with 19 entries.
Solr started, starting Guardian API.
Guardian update sent to CO.
```

If you see these, your Guardian is **fully online**.

---

## 7. Manual setup

### 7.1 Create data and log folders

```bash
mkdir -p ${HOME}/var/solrdocker/data
mkdir -p ${HOME}/var/solrdocker/logs
```

### 7.2 Run the Guardian manually

```bash
sudo docker run -d --pull=always --restart unless-stopped \
  --name guardian1 \
  --dns=100.42.180.116 --dns=8.8.8.8 \
  -p 8983:8983 \
  -p 4005:4005 \
  -v ${HOME}/var/solrdocker:/var/solr \
  -e SOLR_HOME=/var/solr \
  -e SOLR_DATA=/var/solr/data \
  -e SOLR_PORT=8983 \
  -e GUARDIAN_PORT=4005 \
  -e GUID="your-guid" \
  -e LOCATION="Country/City" \
  timpiltd/timpi-guardian:latest
```

### 7.3 Open required ports

```bash
sudo ufw allow 8983/tcp
sudo ufw allow 4005/tcp
```

Forward the same ports on your router to the Guardian's LAN IP.

### 7.4 Deep checks inside the container

```bash
sudo docker exec -it guardian1 bash
env | grep SOLR
ls -la /var/solr
```

---

## 8. Run multiple Guardians

Each Guardian needs **unique ports**, **unique folders**, and a **unique GUID**:

```bash
mkdir -p ${HOME}/var/solrdocker2/data
mkdir -p ${HOME}/var/solrdocker2/logs

sudo docker run -d --pull=always --restart unless-stopped \
  --name guardian2 \
  --dns=100.42.180.116 --dns=8.8.8.8 \
  -p 8984:8984 \
  -p 4006:4006 \
  -v ${HOME}/var/solrdocker2:/var/solr \
  -e SOLR_HOME=/var/solr \
  -e SOLR_DATA=/var/solr/data \
  -e SOLR_PORT=8984 \
  -e GUARDIAN_PORT=4006 \
  -e GUID="second-guid" \
  -e LOCATION="Country/City" \
  timpiltd/timpi-guardian:latest
```

> [!TIP]
> You can run unlimited Guardians on one host as long as the **ports**, **folders**, and **GUIDs** are unique.

---

## 9. Verification & troubleshooting

### Guardian API check

```bash
curl -I http://localhost:4005   # or 4006 etc.
```

### Solr UI

```text
http://<your-ip>:8983/solr/
http://<your-ip>:8984/solr/
```

### Container logs

Find the Guardian container name:

```bash
sudo docker ps --filter "ancestor=timpiltd/timpi-guardian"
```

Then:

```bash
sudo docker logs <container_name>
```

### Persistent log files

```bash
tail -n 50 ${HOME}/var/solrdocker/logs/guardian-log*.txt
tail -n 50 ${HOME}/var/solrdocker2/logs/guardian-log*.txt
```

### Status checker

In Discord, run `/guardianchecker` with your GUID and port. See [../NodeChecker/README.md](../NodeChecker/README.md).

---

## 10. Docker parameter reference

| Parameter | Meaning |
| --- | --- |
| `--pull=always` | Always refresh image |
| `--restart unless-stopped` | Auto-restart on crash |
| `--dns=` | Timpi DNS + Google DNS |
| `-v ~/var/solrdocker:/var/solr` | Persistent Solr storage |
| `SOLR_HOME` | Solr root folder |
| `SOLR_DATA` | Solr index folder |
| `GUID` | Guardian identity |
| `LOCATION` | Region mapping for routing |

---

## 11. Support

* [Timpi Discord — #guardian-operators](https://discord.com/channels/946982023245992006)
* [Open a support ticket](https://discord.com/channels/946982023245992006/1179427377844068493)

---

Built by the Timpi community.
