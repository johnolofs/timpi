# 🛡️ Timpi Guardian Node – Official Community Guide

Run a Guardian Node to help decentralize the web and power Timpi’s search engine.
Secure. Distributed. Community-powered.

<img width="1509" height="850" alt="Guardian Banner" src="https://github.com/user-attachments/assets/f11e358c-15cc-4618-bca0-cfcdb615a65d" />

---

# 📑 Table of Contents

* [1. What Is a Guardian Node?](#what-is-a-guardian-node)
* [2. Supported Systems & Requirements](#supported-systems-requirements)
* [3. Installation Paths](#installation-paths)

  * [3.1 New Install (First-Time Setup)](#new-install)
  * [3.2 Upgrade Existing Guardian](#upgrade-existing)
* [4. Step 0 – Install Docker & Java](#install-docker)
* [5. Step 0.5 – Create Persistent Storage](#persistent-storage)
* [6. Step 1 – Quick Start (Automatic Script)](#quick-start)

  * [6.1 What the Script Does](#what-script-does)
  * [6.2 Expected Script Output](#expected-script-output)
  * [6.3 Expected Container Logs](#expected-container-logs)
  * [6.4 Expected Persistent Guardian Logs](#expected-guardian-logs)
* [7. Manual Setup Guide](#manual-setup)

  * [7.1 Create Data & Log Folders](#create-folders)
  * [7.2 Run the Guardian Manually](#run-manually)
  * [7.3 Open Required Ports](#open-ports)
  * [7.4 Basic Log Checks](#basic-log-checks)
  * [7.5 Deep Checks – Inside Docker Container](#deep-checks)
* [8. Run a Second Guardian Node](#second-node)
* [9. Verification & Quick Troubleshooting](#troubleshooting)
* [10. Docker Parameters Explained](#docker-parameters)
* [11. Support](#support)

---

<a id="what-is-a-guardian-node"></a>

## 1. What Is a Guardian Node?

A Guardian Node hosts a portion of Timpi’s decentralized index using Apache Solr.

Guardians:

* Store segments of the Timpi index
* Serve search queries
* Improve regional speed
* Strengthen the decentralized architecture

---

<a id="supported-systems-requirements"></a>

## 2. Supported Systems & Requirements

| Component | Recommended Minimum                   |
| --------- | ------------------------------------- |
| OS        | **Ubuntu 22.04.x LTS (native)**       |
| CPU       | 8+ cores                              |
| RAM       | 12+ GB                                |
| Storage   | **1 TB free disk space** (Solr index) |
| Network   | Stable 24/7                           |
| Docker    | Required                              |
| Ports     | Guardian + Solr ports must be open    |

⚠️ **We officially support only:** Ubuntu 22.04.x LTS + Docker
⚠️ Other systems *may* work but are not supported (WSL, macOS, Windows, Proxmox LXC, etc.)

---

<a id="installation-paths"></a>

## 3. Installation Paths

Choose one:

* **New Install** (fresh setup)
* **Upgrade Existing Guardian**

---

<a id="new-install"></a>

### 3.1 New Install (First-Time Setup)

Use this if this is your first Guardian on the machine.

Do:

1. [Step 0 – Install Docker & Java](#install-docker)
2. [Step 0.5 – Create Persistent Storage](#persistent-storage)
3. [Step 1 – Quick Start (Automatic Script)](#quick-start)

---

<a id="upgrade-existing"></a>

### 3.2 Upgrade Existing Guardian

Remove the old container:

```bash
sudo docker rm -f $(sudo docker ps -aq --filter "ancestor=timpiltd/timpi-guardian")
```

Remove the old image:

```bash
sudo docker rmi -f $(sudo docker images timpiltd/timpi-guardian -q)
```

Then follow the Quick Start installation again.

---

<a id="install-docker"></a>

## 4. Step 0 – Install Docker & Java

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt update
sudo apt install -y docker-ce default-jre
```

Check Docker:

```bash
sudo systemctl status docker
```

Expected:

```text
Active: active (running)
```

---

<a id="persistent-storage"></a>

## 5. Step 0.5 – Create Persistent Storage

```bash
mkdir -p ${HOME}/var/solrdocker/data
mkdir -p ${HOME}/var/solrdocker/logs
```

Inside container this becomes:

* `/var/solr/data`
* `/var/solr/logs`

---

<a id="quick-start"></a>

## 6. Step 1 – Quick Start (Automatic Script)

### Run the installer:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/johnolofs/timpi/main/Guardian/TimpiGuardianLatest.sh)
```

---

<a id="what-script-does"></a>

### 6.1 What the Script Does

The script:

* Prompts for Solr port, Guardian port, GUID, location
* Ensures folders exist
* Starts container with:

  * `SOLR_HOME=/var/solr`
  * `SOLR_DATA=/var/solr/data`
  * DNS: 100.42.180.116 + 8.8.8.8
  * Image: `timpiltd/timpi-guardian:latest`

---

<a id="expected-script-output"></a>

### 6.2 Expected Script Output

*(Real output from your functioning node)*

```text
===== Timpi Guardian – Quick Setup =====
➡️ Enter the port for Solr (Default: 8983)
➡️ Enter the port for Guardian (Default: 4005)
➡️ Enter your GUID:
📍 Country: Sweden
🏙️ City: Norrkoping

📂 Creating data folder...

🚀 Starting Timpi Guardian container...
Status: Downloaded newer image for timpiltd/timpi-guardian:latest

✅ Guardian started successfully!
   Container ID: f35a6156b5d5...
```

---

<a id="expected-container-logs"></a>

### 6.3 Expected Container Logs (docker logs)

```text
INFO: Guardian is running on the main network
Guardian: Production mode detected.
Guardian: Checking parameters
Guardian: Guardian port = 4005
INFO: Did not find new Tapcore address!. This is production.

Starting Solr instance...
Java 17 detected.
Started Solr server on port 8983 (pid=98). Happy searching!

info: Application started. Press Ctrl+C to shut down.
```

---

<a id="expected-guardian-logs"></a>

### 6.4 Expected Persistent Guardian Logs

```text
INFO: Triangulation successful. Region: EMEA, SubRegion:EU
INFO: Got the Collection list with 19 entries.
Init process finished...

Solr started, starting Guardian API.
Guardian update sent to CO
```

If you see these → your node is **fully online**.

---

<a id="manual-setup"></a>

## 7. Manual Setup Guide

---

<a id="create-folders"></a>

### 7.1 Create Data & Log Folders

```bash
mkdir -p ${HOME}/var/solrdocker/data
mkdir -p ${HOME}/var/solrdocker/logs
```

---

<a id="run-manually"></a>

### 7.2 Run the Guardian Manually

```bash
sudo docker run -d --pull=always --restart unless-stopped \
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

---

<a id="open-ports"></a>

### 7.3 Open Required Ports

```bash
sudo ufw allow 8983/tcp
sudo ufw allow 4005/tcp
```

---

<a id="basic-log-checks"></a>

### 7.4 Basic Log Checks

```bash
curl -I http://localhost:4005
```

Expected:

```text
HTTP/1.1 200 OK
```

---

<a id="deep-checks"></a>

### 7.5 Deep Checks – Inside Docker Container

```bash
sudo docker exec -it <container-id> bash
env | grep SOLR
ls -la /var/solr
```

---

<a id="second-node"></a>

## 8. Run a Second Guardian Node

```bash
mkdir -p ${HOME}/var/solrdocker2/data
mkdir -p ${HOME}/var/solrdocker2/logs
```

```bash
sudo docker run -d --pull=always --restart unless-stopped \
  --dns=100.42.180.116 --dns=8.8.8.8 \
  -p 8984:8984 \
  -p 4006:4006 \
  -v ${HOME}/var/solrdocker2:/var/solr \
  -e SOLR_PORT=8984 \
  -e GUARDIAN_PORT=4006 \
  -e GUID="second-guid" \
  -e LOCATION="Country/City" \
  timpiltd/timpi-guardian:latest
```

---

<a id="troubleshooting"></a>

## 9. Verification & Quick Troubleshooting

Check Guardian:

```bash
curl -I http://localhost:4005
```

Check Solr:

```text
http://<ip>:8983/solr/
```

Check logs:

```bash
sudo docker logs <container-id>
tail -n 50 ~/var/solrdocker/logs/guardian-log*.txt
```

---

<a id="docker-parameters"></a>

## 10. Docker Parameters Explained

| Param                           | Meaning                |
| ------------------------------- | ---------------------- |
| `--pull=always`                 | Always refresh image   |
| `--restart unless-stopped`      | Auto-restart           |
| `--dns`                         | Use Timpi + Google DNS |
| `-v ~/var/solrdocker:/var/solr` | Persistent data        |
| `SOLR_HOME`                     | Required by Guardian   |
| `GUID`                          | Guardian identity      |
| `LOCATION`                      | Region mapping         |

---

<a id="support"></a>

## 11. Support

💬 **Discord:** Guardian Operators channel
🐛 **Bug Reports:** Guardian Support Channel

---

**Built with ❤️ by the Timpi community**
Helping power a free and private internet 🌍
