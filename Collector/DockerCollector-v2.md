# 🔄  Timpi Collector Node (Docker, v2 with GUID)

### Timpi Collectors are decentralized “workers” crawling and indexing the web to help power the world’s first community-driven search engine.

---

<img width="1024" height="576" alt="TimpiCollector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 Table of Contents

* [Get Your GUID](#-get-your-guid)
* [Minimum System Requirements](#-minimum-system-requirements)
* [Install Docker (if not installed)](#dont-have-docker-installed-yet)
* [Quick Start (if Docker is already installed)](#quick-start-if-docker-is-already-installed)
* [Important Tips](#important-tips)
* [Updating to a New Version](#-updating-to-a-new-version)
* [Running Multiple Collectors](#-running-multiple-collectors)

  * [Step-by-Step: Run Additional Collectors](#-step-by-step-run-additional-collectors)
  * [Example: 3 Collectors on One Machine](#-example-3-collectors-on-one-machine)
* [Check Status in the Dashboard](#check-status-in-the-dashboard)
* [Most Useful Docker Commands](#most-useful-docker-commands)
* [Inside the Container: Useful Commands](#inside-the-container-useful-commands)
* [Advanced Options (Optional)](#advanced-options-optional)
* [Fun Command: Timpi Monitor](#fun-command-timpi-monitor)

---

## 🆔 Get Your GUID

Before starting, you need your **Collector GUID**.

1. Visit the **Timpi Node Management Dashboard**:
   👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
2. Register your **Collector node** and copy the **GUID** (a unique identifier like `88293b19-b6b2-4ee2-ba1b-ae4bd670e12f`).
3. You’ll pass this into Docker as an environment variable:

   ```bash
   -e GUID="YOUR-GUID-HERE"
   ```

⚠️ Each Collector must use a **different GUID**.

---

## ✅ Minimum System Requirements

| Resource    | Minimum                            |
| ----------- | ---------------------------------- |
| **OS**      | Ubuntu 22.04 LTS (64-bit) or newer |
| **CPU**     | 2 cores                            |
| **RAM**     | 2 GB                               |
| **Storage** | 1 GB free (SSD recommended)        |
| **Network** | Stable and unlimited connection    |

---

## 🐳 Don’t Have Docker Installed Yet?

Run these commands first:

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

**Add Docker’s GPG key:**

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

**Add Docker repository:**

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Install Docker:**

```bash
sudo apt update
sudo apt install docker-ce
```

**Check Docker status:**

```bash
sudo systemctl status docker
```

If it shows `active (running)`, you’re ready.

---

## 🚀 Quick Start (if Docker is already installed)

Run one headless **v2 Collector** with your GUID:

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  -e GUID="PASTE-YOUR-GUID-HERE" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

🔍 **View logs:**

```bash
sudo docker logs -f timpi_collector
```

You should see output like:

```
[INF] Currently on version 1.X.X
[INF] Logging level: Info
[INF] Trying to send keep alive…
```

> The Collector is managed from your **Node Dashboard** — no local web UI is needed.

---

## 💡 Important Tips

* The **GUID is required** — without it, the Collector won’t register.
* The Collector runs completely **headless** (no web interface).
* Management of Workers / Threads happens in your dashboard:
  👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

Optional resource limits can be added:

```bash
--cpus="2" --memory="2g" --memory-swap="4g"
```

Example:

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  --cpus="2" \
  --memory="2g" \
  --memory-swap="4g" \
  -e GUID="PASTE-YOUR-GUID-HERE" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

---

## 🔁 Updating to a New Version

The Collector updates itself automatically, but you can still update the Docker image manually.

### 1️⃣ Pull the latest image

```bash
sudo docker pull timpiltd/timpi-collector:latest
```

### 2️⃣ Stop and remove the old container

```bash
sudo docker stop timpi_collector
sudo docker rm timpi_collector
```

### 3️⃣ Re-run your original command

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  -e GUID="PASTE-YOUR-GUID-HERE" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

---

## 🧱 Running Multiple Collectors

You can run **several collectors** on the same machine — each with:

* its own **container name**
* its own **GUID**

---

### 🧩 Step-by-Step: Run Additional Collectors

First collector:

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  -e GUID="GUID-1" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

Second collector:

```bash
sudo docker run -d \
  --name timpi_collector_2 \
  --restart unless-stopped \
  -e GUID="GUID-2" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

Third collector:

```bash
sudo docker run -d \
  --name timpi_collector_3 \
  --restart unless-stopped \
  -e GUID="GUID-3" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

No ports need to be exposed — all communication is handled through the Timpi network.

---

### 🔐 Best Practices

* Each collector must have a **unique GUID**.
* Use **different container names** (e.g. `timpi_collector_2`, `timpi_collector_3`).
* Always mount your timezone:
  `-v /etc/localtime:/etc/localtime:ro`

---

### 🛠 Example: 3 Collectors on One Machine

| Container Name      | GUID     | Command Flag Example |
| ------------------- | -------- | -------------------- |
| `timpi_collector`   | `GUID-1` | `-e GUID="GUID-1"`   |
| `timpi_collector_2` | `GUID-2` | `-e GUID="GUID-2"`   |
| `timpi_collector_3` | `GUID-3` | `-e GUID="GUID-3"`   |

Monitor all of them in your Node Dashboard:
👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

---

## ✅ Check Status in the Dashboard

Once your container(s) are running:

1. Visit [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
2. You’ll see each Collector listed by its **GUID**, with online/offline status.
3. Adjust **Workers** or **Threads** — changes apply instantly.

---

## 🧰 Most Useful Docker Commands

| Action                              | Command                                            |                      |          |                |
| ----------------------------------- | -------------------------------------------------- | -------------------- | -------- | -------------- |
| View logs live                      | `sudo docker logs -f timpi_collector`              |                      |          |                |
| List running containers             | `sudo docker ps`                                   |                      |          |                |
| List all containers (incl. stopped) | `sudo docker ps -a`                                |                      |          |                |
| Restart container                   | `sudo docker restart timpi_collector`              |                      |          |                |
| Stop container                      | `sudo docker stop timpi_collector`                 |                      |          |                |
| Remove container                    | `sudo docker rm timpi_collector`                   |                      |          |                |
| Inspect settings                    | `sudo docker inspect timpi_collector`              |                      |          |                |
| View resource limits                | `sudo docker inspect timpi_collector               | grep -iE '"NanoCpus" | "Memory" | "MemorySwap"'` |
| Monitor live usage                  | `sudo docker stats timpi_collector`                |                      |          |                |
| Pull latest image                   | `sudo docker pull timpiltd/timpi-collector:latest` |                      |          |                |

---

## 🧾 Inside the Container: Useful Commands

Install text editors (optional):

```bash
sudo docker exec -it timpi_collector /bin/bash -c "apt update && apt install -y vim nano"
```

Enter the container shell:

```bash
sudo docker exec -it timpi_collector bash
```

Edit logging configuration:

```bash
vim /opt/timpi/CollectorSettings.json
```

Change from:

```json
{ "LogLevel": "Error" }
```

to:

```json
{ "LogLevel": "Verbose" }
```

Save and exit. No restart is usually required.

---

## ⚙️ Advanced Options (Optional)

You can extend your configuration with:

* custom resource limits (`--cpus`, `--memory`)
* mounted log directories
* health checks
* custom update intervals (future)

---
