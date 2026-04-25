# 🐳 Timpi Collector — Docker (Linux)

Run one or more Collectors as Docker containers on Ubuntu. Ideal for multi-node setups and headless servers.

---

<img width="1024" height="576" alt="TimpiCollector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 Table of Contents

1. [Get your GUID](#1-get-your-guid)
2. [System requirements](#2-system-requirements)
3. [Install Docker (if needed)](#3-install-docker-if-needed)
4. [Quick start (one Collector)](#4-quick-start-one-collector)
5. [Updating the image](#5-updating-the-image)
6. [Running multiple Collectors](#6-running-multiple-collectors)
7. [Useful Docker commands](#7-useful-docker-commands)
8. [Editing settings inside the container](#8-editing-settings-inside-the-container)
9. [Resource limits](#9-resource-limits)

---

## 1. Get your GUID

Register at 👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management) and copy the GUID. You'll pass it as `-e GUID="..."` to Docker.

⚠️ Each Collector container needs a **unique GUID**.

---

## 2. System requirements

| Resource | Minimum |
| --- | --- |
| OS | Ubuntu 22.04 LTS (64-bit) or newer |
| CPU | 2 cores |
| RAM | 2 GB |
| Storage | 1 GB free (SSD recommended) |
| Network | Stable, no data caps |

---

## 3. Install Docker (if needed)

Skip this section if `docker version` already works.

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

Add Docker's GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Add the Docker repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install:

```bash
sudo apt update
sudo apt install -y docker-ce
sudo systemctl status docker
```

`active (running)` → ready.

---

## 4. Quick start (one Collector)

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  -e GUID="PASTE-YOUR-GUID-HERE" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

View logs:

```bash
sudo docker logs -f timpi_collector
```

Healthy startup looks like:

```text
[INF] Currently on version 1.X.X
[INF] Logging level: Info
[INF] Trying to send keep alive…
```

> 💡 The Collector is fully headless — manage **Workers / Threads** at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management). No ports need to be exposed.

---

## 5. Updating the image

The Collector also self-updates internally, but you can refresh the underlying Docker image manually:

```bash
sudo docker pull timpiltd/timpi-collector:latest
sudo docker stop timpi_collector
sudo docker rm timpi_collector
# then re-run the original docker run command
```

---

## 6. Running multiple Collectors

Each container needs a **unique name** and **unique GUID**:

```bash
sudo docker run -d --name timpi_collector   --restart unless-stopped \
  -e GUID="GUID-1" -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest

sudo docker run -d --name timpi_collector_2 --restart unless-stopped \
  -e GUID="GUID-2" -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest

sudo docker run -d --name timpi_collector_3 --restart unless-stopped \
  -e GUID="GUID-3" -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

| Container name | GUID | Notes |
| --- | --- | --- |
| `timpi_collector` | GUID-1 | First node |
| `timpi_collector_2` | GUID-2 | Second node |
| `timpi_collector_3` | GUID-3 | Third node |

All Collectors appear in the dashboard by GUID.

---

## 7. Useful Docker commands

| Action | Command |
| --- | --- |
| Live logs | `sudo docker logs -f timpi_collector` |
| List running | `sudo docker ps` |
| List all (incl. stopped) | `sudo docker ps -a` |
| Restart | `sudo docker restart timpi_collector` |
| Stop | `sudo docker stop timpi_collector` |
| Remove | `sudo docker rm timpi_collector` |
| Inspect config | `sudo docker inspect timpi_collector` |
| Live resource usage | `sudo docker stats timpi_collector` |
| Pull latest image | `sudo docker pull timpiltd/timpi-collector:latest` |

---

## 8. Editing settings inside the container

Install editors (optional):

```bash
sudo docker exec -it timpi_collector /bin/bash -c "apt update && apt install -y vim nano"
```

Open a shell:

```bash
sudo docker exec -it timpi_collector bash
```

Edit log level:

```bash
vim /opt/timpi/CollectorSettings.json
```

Change `"LogLevel": "Error"` to `"LogLevel": "Verbose"`. Save — no restart usually needed.

---

## 9. Resource limits

You can cap CPU and memory if you're running many nodes on one host:

```bash
sudo docker run -d \
  --name timpi_collector \
  --restart unless-stopped \
  --cpus="2" --memory="2g" --memory-swap="4g" \
  -e GUID="PASTE-YOUR-GUID-HERE" \
  -v /etc/localtime:/etc/localtime:ro \
  timpiltd/timpi-collector:latest
```

Verify:

```bash
sudo docker inspect timpi_collector | grep -iE '"NanoCpus"|"Memory"|"MemorySwap"'
```

---

🆘 **Support:** [Timpi Discord](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
