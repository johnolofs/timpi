## ✍️ Updated Guide (Markdown)

### ⚠️ Important Notice – Resource Usage in Timpi Collector v0.10.0-A

Timpi Collector v0.10.0-A introduces major performance and stability improvements — **but still requires careful tuning** of workers/threads and system resources.

> ⚠️ Too high values may **consume all your CPU, RAM, and bandwidth**, affecting your Guardian, Validator, Synaptron or other services.

🛡️ The installer now includes:

* **Memory limits** (RAM + swap) like a container
* **Self-healing service setup**
* Safe upgrade/removal options

🔁 Start low and test performance:

```
http://localhost:5015/collector
```

Suggested: **1 Worker / 5 Threads**

---

## 🚀 One-Line Installation for Timpi Collector v0.10.0-A

```bash

sudo apt-get install -y dos2unix curl && sudo curl -o Automated_collector_script.sh https://raw.githubusercontent.com/johnolofs/timpi/blob/main/Collector/Script/Automated_collector_script.sh && sudo dos2unix Automated_collector_script.sh && bash Automated_collector_script.sh
```

🧼 **To wipe config and restart:**

```bash
sudo systemctl stop collector; sudo rm -f /opt/timpi/timpi.config; sudo systemctl start collector
```

---

## 🧠 Resource Control (MemoryMax / MemorySwapMax)

🧠 Auto-detected & configurable:

* `MemoryMax`: RAM limit in GB (default 2)
* `MemorySwapMax`: Auto-set to RAM + 1 GB

💡 Example:

```ini
MemoryMax=2G
MemorySwapMax=3G
```

---

## 🔁 Full Manual Installation (Advanced)

### Step 1: Remove Previous Collector

```bash
sudo systemctl stop collector collector_ui || true
sudo systemctl disable collector collector_ui || true
sudo rm -rf /opt/timpi
```

### Step 2: Update System

```bash
sudo apt update && sudo apt -y upgrade
```

### Step 3: Create Installation Folder

```bash
sudo mkdir -p /opt/timpi
```

### Step 4: Install Unrar

```bash
sudo apt install -y unrar
```

### Step 5: Download Collector

```bash
sudo wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-0.10.0-A.rar -O /opt/timpi/TimpiCollectorLinuxLatest-0.10.0-A.rar
```

### Step 6: Extract Files

```bash
cd /opt/timpi
sudo unrar x -y /opt/timpi/TimpiCollectorLinuxLatest-0.10.0-A.rar
```

### Step 7: Move Files (if needed)

```bash
if [ -d "/opt/timpi/TimpiCollectorLinuxLatest-0.10.0-A.rar" ]; then
    sudo mv /opt/timpi/TimpiCollectorLinuxLatest-0.10.0-A.rar/* /opt/timpi
    sudo rm -rf /opt/timpi/TimpiCollectorLinuxLatest-0.10.0-A.rar
fi
```

### Step 8: Set Permissions

```bash
sudo chmod 755 /opt/timpi/TimpiCollector
sudo chmod 755 /opt/timpi/TimpiUI
```

### Step 9: Create systemd Services

Collector service:

```bash
sudo nano /etc/systemd/system/collector.service
```

Paste:

```ini
[Unit]
Description=Timpi Collector Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector
Restart=always
MemoryMax=2G
MemorySwapMax=3G

[Install]
WantedBy=multi-user.target
```

Collector UI:

```bash
sudo nano /etc/systemd/system/collector_ui.service
```

Paste:

```ini
[Unit]
Description=Timpi Collector UI Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiUI
Restart=always

[Install]
WantedBy=multi-user.target
```

### Step 10: Cleanup

```bash
sudo rm -f /opt/timpi/TimpiCollectorLinuxLatest.rar
```

### Step 11: Enable + Start

```bash
sudo systemctl daemon-reload
sudo systemctl enable collector collector_ui
sudo systemctl start collector collector_ui
```

---

## 🔍 Useful Commands

```bash
# Status
sudo systemctl status collector
sudo systemctl status collector_ui

# Restart
sudo systemctl restart collector
sudo systemctl restart collector_ui

# Logs
sudo journalctl -fu collector -o cat
```

---

## ❌ Remove Timpi Collector Completely

```bash
sudo systemctl stop collector collector_ui
sudo systemctl disable collector collector_ui
sudo rm -rf /opt/timpi
sudo rm /etc/systemd/system/collector.service
sudo rm /etc/systemd/system/collector_ui.service
sudo systemctl daemon-reload
```
