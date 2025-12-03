# 🌐 **1. Timpi GeoCore Node – Official Community Guide**

Run a **GeoCore Node** to help power Timpi’s decentralized, location-aware routing infrastructure.
Lightweight. Fast. Privacy-focused.

<img width="1509" height="850" src="https://github.com/user-attachments/assets/7b69280a-a77b-46d3-85d0-88b517c097bb" />

---

# 📘 **2. Table of Contents**

1. [Introduction – What Is a GeoCore Node?](#21-introduction--what-is-a-geocore-node)
2. [System Requirements](#22-system-requirements)
3. [Important Support Notice](#23-important-support-notice)
4. [Two Paths: New Install vs Upgrade](#24-two-paths-new-install--upgrade-flow)
5. [Clean Slate (Optional but Recommended)](#24a-clean-slate-optional-but-recommended)
6. [Register Your GUID](#25-register-your-guid)
7. [NEW INSTALL PATH](#3-new-install-path)

   * [3.1 Install Docker](#31-install-docker)
   * [3.2 Automatic GeoCore Installation](#32-automatic-geocore-installation)
   * [3.3 Manual Install (Any Port)](#33-manual-install-any-port)
   * [3.4 Open Your Port](#34-open-your-port)
8. [UPGRADE PATH](#4-upgrade-path)

   * [4.1 Upgrade Steps](#41-upgrade-steps)
   * [4.2 Verify After Upgrade](#42-verify-after-upgrade)
9. [Monitor Logs](#5-monitor-logs)
10. [Expected Logs & Outputs](#6-expected-logs--outputs)
11. [Run Multiple GeoCores](#7-run-multiple-geocores)
12. [Docker Parameter Reference](#8-docker-parameter-reference)
13. [Troubleshooting](#9-troubleshooting)
14. [Upcoming Feature](#10-upcoming-feature)
15. [Community & Support](#11-community--support)

---

# 2.1 **Introduction – What Is a GeoCore Node?**

A **GeoCore Node** powers Timpi’s decentralized network by:

* announcing your physical region (e.g., `Sweden/Stockholm`)
* connecting to the TAP (Timpi Access Point)
* routing search traffic to the nearest Guardians
* improving global decentralization and performance

GeoCore is lightweight, Docker-based, and ideal for 24/7 operation.

---

# 2.2 **System Requirements**

| Component | Recommended Minimum           |
| --------- | ----------------------------- |
| OS        | **Ubuntu 22.04 LTS (native)** |
| CPU       | 4 cores                       |
| RAM       | 8 GB                          |
| Storage   | 3 GB                          |
| Bandwidth | 50 Mbps                       |
| Uptime    | 95%+                          |
| Port      | **4014/TCP (default)**        |
| Docker    | Required                      |

---

# 2.3 **Important Support Notice**

Timpi officially supports:

✔ Ubuntu 22.04 LTS
✔ Native Docker
✔ FluxOS Marketplace deployments

Not supported (community-only):

❌ Windows, WSL, macOS
❌ Proxmox LXC
❌ Other Linux distributions

---

# 2.4 **Two Paths: New Install & Upgrade Flow**

### ✔ Path A – New Install

For brand-new users.

### ✔ Path B – Upgrade

For existing operators who want to update safely.

---

# 2.4A ⚠️ **Clean Slate (Optional but Recommended)**

This section **removes all old GeoCore containers and images**, including randomly-named containers such as `epic_satoshi`.

Use this when:

* switching ports
* changing GUID
* upgrading from older versions
* troubleshooting
* cleaning broken installations

---

## 2.4A.1 **Stop & remove ALL old GeoCore containers**

Check containers, images ID´s:

```bash
sudo docker ps
sudo docker ps -a
sudo docker images
```

Stop/Remove Container:

```bash
sudo docker stop <ContainerID>
sudo docker rm <ContainerID>
```

---

## 2.4A.2 **Remove ALL old GeoCore images**

```bash
sudo docker rmi timpiltd/timpi-geocore:latest 2>/dev/null
sudo docker rmi -f $(docker images timpiltd/timpi-geocore -q) 2>/dev/null
sudo docker rmi -f $(docker images "timpiltd/timpi-geocore:*" -q) 2>/dev/null
```

---

## 2.4A.3 **Confirm everything is gone**

```bash
sudo docker ps
sudo docker ps -a
sudo docker images
```

If any remain:

```bash
sudo docker rm <containerID>
sudo docker rmi <imageID>
```

---

## 2.4A.4 **Remove old GeoCore folders (optional)**

Remove only GeoCore:

```bash
sudo rm -rf /var/timpi/GeoCore
```

Remove everything (GeoCore + DataCom):

```bash
sudo rm -rf /var/timpi
```

---

## 2.4A.5 **Deep Docker cleanup (optional)**

```bash
sudo docker container prune -f
sudo docker image prune -f
sudo docker volume prune -f
sudo docker network prune -f
```

---

## 2.4A.6 **Restart a stopped GeoCore container**

```bash
sudo docker start $(docker ps -a --filter "ancestor=timpiltd/timpi-geocore:latest" -q)
```

*(Works fine even with multiple GeoCores – it starts all of them.)*

---

# 2.5 **Register Your GUID**

👉 [https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)

Example GUID:

```text
2f7256b8-c275-429b-8077-01519cced572
```

---

# 🔵 **3. NEW INSTALL PATH**

---

## 3.1 **Install Docker**

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

Add Docker repo:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list
```

Install Docker:

```bash
sudo apt update
sudo apt install -y docker-ce
sudo systemctl status docker
```

Expected:

```text
active (running)
```

Fix permissions:

```bash
sudo usermod -aG docker $USER
```

Logout/login.

---

## 3.2 **Automatic GeoCore Installation**

```bash
bash <(curl -sSL https://raw.githubusercontent.com/johnolofs/Geocore/main/GC-AutoInstall.sh)
```

**The script:**

* asks for port
* asks for GUID
* asks for location
* launches container
* prints log commands

---

## 3.3 **Manual Install (Any Port)**

GeoCore does not require port 4013 even if it´s default.
You may use any free port — here is a working example using **4013**:

```bash
sudo docker run -d \
  --name geocore \
  --pull=always --restart unless-stopped \
  --dns=100.42.180.29 --dns=100.42.180.99 --dns=8.8.8.8 \
  -p 4013:4013 \
  -v /var/timpi:/var/timpi \
  -e COMPORT=4013 \
  -e GUID="your-guid-here" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

---

## 3.4 **Open Your Port**

```bash
sudo ufw allow 4013/tcp
```

Router:

```text
External:4013 → Internal:4013 (TCP)
```

---

# 🟩 **4. UPGRADE PATH**

Because GeoCore uses `--pull=always`, updating is simple.

---

## 4.1 **Upgrade Steps**

### 1️⃣ Stop container

```bash
sudo docker stop $(docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### 2️⃣ Remove container

```bash
sudo docker rm $(docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### 3️⃣ Pull new version

```bash
sudo docker pull timpiltd/timpi-geocore:latest
```

### 4️⃣ Re-run your GeoCore

(Example using port 4014)

```bash
sudo docker run -d \
  --name geocore \
  --pull=always --restart unless-stopped \
  -p 4013:4013 \
  -v /var/timpi:/var/timpi \
  -e COMPORT=4013 \
  -e GUID="your-guid" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

---

## 4.2 **Verify After Upgrade**

Because `docker logs` only accepts **one container**, and many users run multiple GeoCores, verify logs **per port**:

If your GeoCore runs on **4014**:

```bash
sudo docker logs -f $(docker ps --filter "publish=4013" -q)
```

If it runs on **another port**, e.g. 4015:

```bash
sudo docker logs -f $(docker ps --filter "publish=4014" -q)
```

Look for:

```text
GeoCore is running on main network
Found X free Guardians
```

---

# 🔵 **5. Monitor Logs**

---

## 5.1 **GeoCore Logs (Docker)**

### Single GeoCore (only one running)

If you only run ONE GeoCore, you can still use:

```bash
sudo docker logs -f $(docker ps --filter "ancestor=timpiltd/timpi-geocore" -q)
```

### Multiple GeoCores (recommended method)

Use **port-based filters** so Docker only selects one container:

**GeoCore #1 (example: port 4014)**

```bash
sudo docker logs -f $(docker ps --filter "publish=4014" -q)
```

**GeoCore #2 (example: port 4015)**

```bash
sudo docker logs -f $(docker ps --filter "publish=4015" -q)
```

**GeoCore #N**
Replace `<PORT>`:

```bash
sudo docker logs -f $(docker ps --filter "publish=<PORT>" -q)
```

---

## 5.2 **GeoCore Log Files**

```bash
sudo tail -f $(ls -t /var/timpi/GeoCore/logs/GeoCore-log*.txt | head -n 1)
```

List all:

```bash
ls -l /var/timpi/GeoCore/logs
```

---

## 5.3 **DataCom Logs**

```bash
sudo tail -f /var/timpi/Datacom-log*.txt
```

List:

```bash
ls -l /var/timpi/Datacom-log*.txt
```

---

# 🔵 **6. Expected Logs & Outputs**

---

## 6.1 **GeoCore Healthy Startup**

```text
GUID=YourGUID
Environment variable 'LOCATION' found - Sweden/Stockholm
GeoCore: ConnectionPort found 4013
GeoCore: Log folder /var/timpi/GeoCore/logs created.
INFO: Got version 1.1.xx from core - Own version: 1.1.xx
INFO: GeoCore is running on the main network
INFO: Production mode detected.
Now listening on: http://[::]:4013
```

---

## 6.2 **Guardian Scan**

```text
INFO: Found 78 free Guardians in 11 regions
```

---

## 6.3 **DataCom Healthy Logs**

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

# 🔵 **7. Run Multiple GeoCores**

Each node needs:

✔ Unique folder
✔ Unique container name
✔ Unique port
✔ Unique GUID

---

## 7.1 **Second GeoCore (geocore2)**

```bash
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
```

---

## 7.2 **Third GeoCore (geocore3)**

```bash
sudo docker run -d \
  --name geocore3 \
  --pull=always --restart unless-stopped \
  -p 4016:4016 \
  -v /var/timpi3:/var/timpi \
  -e COMPORT=4016 \
  -e GUID="your-third-guid" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

---

## 7.3 **Fourth GeoCore (geocore4)**

```bash
sudo docker run -d \
  --name geocore4 \
  --pull=always --restart unless-stopped \
  -p 4017:4017 \
  -v /var/timpi4:/var/timpi \
  -e COMPORT=4017 \
  -e GUID="your-fourth-guid" \
  -e LOCATION="Sweden/Stockholm" \
  timpiltd/timpi-geocore:latest
```

---

# 🔵 **8. Docker Parameter Reference**

| Parameter                   | Description                 |
| --------------------------- | --------------------------- |
| `--pull=always`             | Always fetch latest version |
| `--restart unless-stopped`  | Auto-restart                |
| `--dns`                     | Timpi DNS                   |
| `-p PORT:PORT`              | GeoCore exposed port        |
| `-v /var/timpiX:/var/timpi` | Unique volume per node      |
| `-e GUID=`                  | GeoCore GUID                |
| `-e COMPORT=`               | GeoCore port                |
| `-e LOCATION=`              | Country/City                |

---

# 🔵 **9. Troubleshooting**

### Restart a stopped GeoCore

```bash
sudo docker start $(docker ps -a --filter "ancestor=timpiltd/timpi-geocore:latest" -q)
```

### DNS issues

```bash
sudo docker exec -it geocore cat /etc/resolv.conf
```

### Permission issues

```bash
sudo chmod -R 777 /var/timpi
```

---

# 🔵 **10. Upcoming Feature**

**GeoCore Online Checker Tool**
Will show:

* uptime
* version
* routing status
* region
* TAP connectivity

---

# 🔵 **11. Community & Support**

Discord GeoCore Channel
[https://discord.com/channels/946982023245992006](https://discord.com/channels/946982023245992006)

Support Tickets
[https://discord.com/channels/946982023245992006/1179427377844068493](https://discord.com/channels/946982023245992006/1179427377844068493)

Registration Page
[https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)
