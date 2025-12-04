# 🛡️ Timpi Guardian Node – Official Community Guide

Run a Guardian Node to help decentralize the web and power Timpi’s search engine.
Secure. Distributed. Community-powered.

<img width="1509" height="850" alt="Guardian Banner" src="https://github.com/user-attachments/assets/f11e358c-15cc-4618-bca0-cfcdb615a65d" />

---

# 📑 Table of Contents

1. [What Is a Guardian Node?](#1-what-is-a-guardian-node)
2. [Supported Systems & Requirements](#2-supported-systems--requirements)
3. [Installation Paths](#3-installation-paths)
    3.1 [New Install (First-Time Setup)](#31-new-install-first-time-setup)
    3.2 [Upgrade Existing Guardian](#32-upgrade-existing-guardian)
4. [Step 0 – Install Docker & Java](#4-step-0--install-docker--java)
5. [Step 1 – Quick Start (Automatic Script)](#5-step-1--quick-start-automatic-script)
    5.1 [What You’ll See](#51-what-youll-see)
    5.2 [What to Do After the Script](#52-what-to-do-after-the-script)
    5.3 [Verify Guardian Is Running (Expected Output)](#53-verify-guardian-is-running-expected-output)
6. [Manual Setup Guide](#6-manual-setup-guide)
    6.1 [Create Data Folder](#61-create-data-folder)
    6.2 [Run the Guardian Manually](#62-run-the-guardian-manually)
    6.3 [Open Required Ports](#63-open-required-ports)
    6.4 [Basic Log Checks](#64-basic-log-checks)
    6.5 [Deep Checks – Inside Docker Container](#65-deep-checks--inside-docker-container)
7. [Run a Second Guardian Node](#7-run-a-second-guardian-node)
8. [Docker Parameters Explained](#8-docker-parameters-explained)
9. [Support](#9-support)

---

## 1. What is a Guardian Node?

A Guardian Node hosts a portion of Timpi’s decentralized index using Apache Solr.
Guardians:

* Store segments of the Timpi index
* Serve search queries
* Help with redundancy and regional performance
* Strengthen Timpi’s decentralized architecture

---

## 2. Supported Systems & Requirements

| Component | Recommended Minimum                       |
| --------- | ----------------------------------------- |
| OS        | **Ubuntu 22.04.x LTS (native)**           |
| CPU       | 8+ cores                                  |
| RAM       | 12+ GB                                    |
| Storage   | **1 TB free disk space (for Solr index)** |
| Network   | 24/7 stable internet                      |
| Docker    | Required                                  |
| Ports     | Guardian + Solr ports must be open        |

⚠️ **Support notes**

* Official support: **Ubuntu 22.04.x + Docker**
* Other distros may work, but you must self-support
* We do **not** support: Windows, macOS, WSL, Proxmox LXC, router config, port-forwarding, etc.

---

## 3. Installation Paths

You can either:

* Do a **New Install**
* Or **Upgrade** an existing Guardian

---

### 3.1 New Install (First-Time Setup)

Use this if:

* You never ran a Guardian before
* You’re setting up on a new server

➡️ Go to **[4. Step 0 – Install Docker & Java](#4-step-0--install-docker--java)**

---

### 3.2 Upgrade Existing Guardian

If you already have an older Guardian running, clean it up first:

#### 3.2.1 Remove existing Guardian container

```bash
sudo docker rm -f $(sudo docker ps -aq --filter "ancestor=timpiltd/timpi-guardian")
```

#### 3.2.2 Remove existing Guardian image

```bash
sudo docker rmi -f $(sudo docker images timpiltd/timpi-guardian -q)
```

Then continue with either the **Quick Start script** or **Manual Setup**.

---

## 4. Step 0 – Install Docker & Java

Run one command at a time:

```bash
sudo apt update
```

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt update
sudo apt install -y docker-ce default-jre
```

Check Docker:

```bash
sudo systemctl status docker
```

You should see:

```text
Active: active (running)
```

---

## 5. Step 1 – Quick Start (Automatic Script)

> ✅ **Recommended for most users**

The script:

* Asks for ports, GUID, and location
* Creates the correct data folder
* Starts the Guardian Docker container
* Uses the latest image: `timpiltd/timpi-guardian:latest`
* Sets the new required Solr env variables (`SOLR_HOME`, `SOLR_DATA`)

Run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Timpi-official/Nodes/main/Guardian/TimpiGuardianLatest.sh)
```

---

### 5.1 What You’ll See

Example prompts:

```text
➡️ Enter the port for Solr (Default: 8983)
➡️ Enter the port for Guardian (Default: 4005)
➡️ Enter your GUID (Find it in your Timpi dashboard)
📍 Now, let's enter your location details step by step!
🌍 Country (Example: Sweden, Germany, US):
🏙️ City (Example: Norrkoping, Berlin, NewYork):
✅ Location set to: Sweden/Norrkoping

📂 Creating data folder at: /home/<user>/var/solrdocker/data (if needed)...

🚀 Starting Timpi Guardian container (timpiltd/timpi-guardian:latest)...
✅ Guardian started successfully!
   Container ID: <container-id>
   To view logs, run:
   sudo docker logs -f <container-id>
```

---

### 5.2 What to Do After the Script

#### 5.2.1 Open firewall ports (UFW)

```bash
sudo ufw allow 8983/tcp    # Solr
sudo ufw allow 4005/tcp    # Guardian
```

If you chose different ports, use those instead.

#### 5.2.2 Check the Docker container

```bash
sudo docker ps
```

You should see something like:

```text
CONTAINER ID   IMAGE                            COMMAND   STATUS         PORTS
abcd1234...    timpiltd/timpi-guardian:latest   ...      Up X minutes   0.0.0.0:8983->8983/tcp, 0.0.0.0:4005->4005/tcp
```

---

### 5.3 Verify Guardian Is Running (Expected Output)

#### 5.3.1 Check basic HTTP on Guardian port

```bash
curl -I http://localhost:4005
```

Expected:

```text
HTTP/1.1 200 OK
```

or sometimes:

```text
HTTP/1.1 404 Not Found
Server: Kestrel
```

> ✅ Both mean: **Guardian API is listening on port 4005**.
> A 404 just means there is no content on `/` root path, which is fine.

#### 5.3.2 Check Solr UI from browser

Go to:

```text
http://<your-server-ip>:8983/solr/
```

If Solr’s web interface loads → Solr is running and correctly bound.

#### 5.3.3 Check Guardian logs via Docker

```bash
sudo docker logs -n 50 <container-id>
```

Expected lines (examples):

```text
Guardian is running on the main network.
Guardian: Production mode detected.
Guardian: Guardian port = 4005.
INFO: Guardian is up to date (1.0.x).
Starting Guardian API - Listening on http://*:4005.
Starting triangulation process. This takes 15-60 min!!
INFO: Triangulation successful. Region: EMEA, SubRegion: EU ...
Init process finished ... Starting main with the following parameters: Guardian port: 4005, Solr Port: 8983 ...
Solr is already running with the correct Zookeeper string ...
```

If you see:

* “Triangulation successful”
* “Init process finished”
* “Solr is already running”

➡️ then your node is **fully online and connected to TAP**.

---

## 6. Manual Setup Guide

Use this if you prefer not to use the script.

> 🚨 Docker & Java must be installed first (see Step 0).

---

### 6.1 Create Data Folder

Create the persistent data folder:

```bash
sudo mkdir -p ${HOME}/var/solrdocker/data
```

This maps to `/var/solr` inside the container and stores:

* Solr data
* Solr logs
* Guardian logs

Do **not** delete this folder between upgrades.

---

### 6.2 Run the Guardian Manually

Replace:

* `your-guid-here` → your Guardian GUID
* `Country/City` → your location (e.g. `"Sweden/Norrkoping"`)

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
  -e GUID="your-guid-here" \
  -e LOCATION="Country/City" \
  timpiltd/timpi-guardian:latest
```

Then:

```bash
sudo docker ps
```

Check that the container is **Up** and that `8983` and `4005` are mapped.

---

### 6.3 Open Required Ports

If using UFW:

```bash
sudo ufw allow 8983/tcp
sudo ufw allow 4005/tcp
```

---

### 6.4 Basic Log Checks

#### 6.4.1 Check container logs

```bash
sudo docker logs -n 50 <container-id>
```

Look for the same “Init process finished”, “Triangulation successful”, etc, as above.

#### 6.4.2 Check persistent log files

Guardian log folder (host):

```bash
ls -R ${HOME}/var/solrdocker
```

You should see something like:

```text
${HOME}/var/solrdocker:
data  logs  solr-8983.pid

${HOME}/var/solrdocker/logs:
2025_12_04.request.log  guardian-log20251204.txt  solr-8983-console.log  solr_gc.log
```

Follow Guardian log live:

```bash
tail -f ${HOME}/var/solrdocker/logs/guardian-log*.txt
```

(If there are several, use `ls` to pick the latest file.)

---

### 6.5 Deep Checks – Inside Docker Container

If you want to be 100% sure everything is aligned with Joerg’s expectations, you can inspect the container environment.

#### 6.5.1 Enter the container

First, get the container ID:

```bash
sudo docker ps
```

Then:

```bash
sudo docker exec -it <container-id> bash
```

Now you are inside the container, prompt like:

```bash
root@<container-id>:/opt/solr-9.x.x#
```

#### 6.5.2 Check environment variables

```bash
env | grep -E 'SOLR|GUARDIAN|GUID|LOCATION|PORT'
```

Expected values (example):

```text
SOLR_HOME=/var/solr
SOLR_DATA=/var/solr/data
SOLR_PORT=8983
GUARDIAN_PORT=4005
GUID=35116c03-697d-4dc5-b9fe-9cf1dca5a84a
LOCATION=Sweden/Norrkoping
SOLR_LOGS_DIR=/var/solr/logs
```

If you see:

* `SOLR_HOME=/var/solr`
* `SOLR_DATA=/var/solr/data`
* Correct `GUID` and `LOCATION`

➡️ Then the container is correctly configured.

#### 6.5.3 Check `/var/solr` inside the container

```bash
ls -la /var/solr
```

Example expected output:

```text
drwxr-xr-x 4 root root 4096 Dec  4 17:19 .
drwxr-xr-x 1 root root 4096 Sep  2 00:14 ..
drwxr-xr-x 2 root root 4096 Dec  4 17:19 data
drwxr-xr-x 2 root root 4096 Dec  4 17:28 logs
-rw-r--r-- 1 root root    3 Dec  4 17:28 solr-8983.pid
```

That confirms:

* Volume mapping is correct (`${HOME}/var/solrdocker` → `/var/solr`)
* `data/` and `logs/` are present
* Solr PID file exists

Exit the container:

```bash
exit
```

---

## 7. Run a Second Guardian Node

To run a second Guardian on the same machine:

### 7.1 Create a second data folder

```bash
mkdir -p ${HOME}/var/solrdocker2/data
```

### 7.2 Run a second Guardian with different ports + GUID

```bash
sudo docker run -d --pull=always --restart unless-stopped \
  --dns=100.42.180.116 --dns=8.8.8.8 \
  -p 8984:8984 \
  -p 4006:4006 \
  -v ${HOME}/var/solrdocker2:/var/solr \
  -e SOLR_HOME=/var/solr \
  -e SOLR_DATA=/var/solr/data \
  -e SOLR_PORT=8984 \
  -e GUARDIAN_PORT=4006 \
  -e GUID="second-guid-here" \
  -e LOCATION="Germany/Munich" \
  timpiltd/timpi-guardian:latest
```

Open the new ports in UFW:

```bash
sudo ufw allow 8984/tcp
sudo ufw allow 4006/tcp
```

---

## 8. Docker Parameters Explained

| Flag                          | Description                        |
| ----------------------------- | ---------------------------------- |
| `--pull=always`               | Always fetch latest Guardian image |
| `--restart unless-stopped`    | Auto-restart after reboot/crash    |
| `--dns=100.42.180.116`        | Timpi DNS resolver                 |
| `--dns=8.8.8.8`               | Google public DNS (fallback)       |
| `-p HOST:CONTAINER`           | Port mapping                       |
| `-v host:/var/solr`           | Persistent Solr + Guardian data    |
| `-e SOLR_HOME=/var/solr`      | Base Solr directory (required)     |
| `-e SOLR_DATA=/var/solr/data` | Solr index directory               |
| `-e SOLR_PORT`                | Port Solr listens on               |
| `-e GUARDIAN_PORT`            | Port Guardian API listens on       |
| `-e GUID`                     | Your Timpi Guardian identity       |
| `-e LOCATION`                 | `Country/City` for network map     |

---

## 9. Support

💬 **Discord:**
Guardian Operators channel
(Guardian category in the official Timpi Discord)

🐛 **Bug reports / help:**
Guardian support channel in Discord

---

**Built with ❤️ by the Timpi community**
Helping power a free and private internet 🌍

