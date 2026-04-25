# 🐧 Timpi Collector — Linux Installation Guide

*Native Ubuntu install with auto-updating systemd services (6-hour cycle).*

This guide installs:

* 🧠 **TimpiCollector** — the worker binary
* 🔄 **CollectorAutoUpdater** — keeps the worker up to date

Both run automatically in the background via **systemd services + timer**, including across reboots.

---

<img width="1024" height="576" alt="Timpi Collector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 Table of Contents

1. [Get your GUID](#1-get-your-guid)
2. [System requirements](#2-system-requirements)
3. [Step 1 — Remove old versions](#3-step-1--remove-old-versions)
4. [Step 2 — Prepare a clean directory](#4-step-2--prepare-a-clean-directory)
5. [Step 3 — Download & extract](#5-step-3--download--extract)
6. [Step 4 — Set permissions](#6-step-4--set-permissions)
7. [Step 5 — Create the Collector service](#7-step-5--create-the-collector-service)
8. [Step 6 — Add the auto-updater service](#8-step-6--add-the-auto-updater-service)
9. [Step 7 — Create and enable the 6-hour timer](#9-step-7--create-and-enable-the-6-hour-timer)
10. [Step 8 — Verify](#10-step-8--verify)
11. [How the auto-updater works](#11-how-the-auto-updater-works)
12. [Manual update / hotfix](#12-manual-update--hotfix)
13. [File summary](#13-file-summary)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. Get your GUID

Register your Collector and copy its GUID at 👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

From the same dashboard you can:

* register additional Collectors
* adjust **Workers** and **Threads** per node
* check **online / offline** status

💡 Recommended starting config: **1 Worker, 5 Threads**.

---

## 2. System requirements

| Resource | Minimum |
| --- | --- |
| OS | Ubuntu 22.04 LTS (64-bit) |
| CPU | 2 cores |
| RAM | 2 GB |
| Storage | 1 GB free (SSD recommended) |
| Network | Stable, no data caps |

---

## 3. Step 1 — Remove old versions

```bash
sudo systemctl stop collector 2>/dev/null || true
sudo systemctl stop collector_ui 2>/dev/null || true
sudo systemctl stop collector-updater.timer 2>/dev/null || true
sudo systemctl stop collector-updater 2>/dev/null || true
sudo rm -f /etc/systemd/system/collector*.service /etc/systemd/system/collector*.timer
sudo systemctl daemon-reload
```

---

## 4. Step 2 — Prepare a clean directory

```bash
sudo rm -rf /opt/timpi
sudo mkdir -p /opt/timpi
sudo chown "$USER:$USER" /opt/timpi
cd /opt/timpi
```

---

## 5. Step 3 — Download & extract

```bash
wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-v2.rar -O TimpiCollectorLinuxLatest-v2.rar
sudo apt install -y unrar
unrar x TimpiCollectorLinuxLatest-v2.rar
rm -rf TimpiCollectorLinuxLatest TimpiCollectorLinuxLatest-v2.rar
```

Expected layout:

```text
/opt/timpi/
├── TimpiCollector
├── CollectorAutoUpdater
├── CollectorSettings.json
└── public_suffix_list.dat
```

---

## 6. Step 4 — Set permissions

```bash
sudo chmod +x /opt/timpi/TimpiCollector
sudo chmod +x /opt/timpi/CollectorAutoUpdater
```

---

## 7. Step 5 — Create the Collector service

```bash
sudo nano /etc/systemd/system/collector.service
```

> ⚠️ **Replace `YOUR-GUID-HERE`** with your actual GUID from [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management) before saving.

```ini
[Unit]
Description=Timpi Collector v2 (Headless)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector YOUR-GUID-HERE
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save with `Ctrl + O`, `Enter`, `Ctrl + X`.

---

## 8. Step 6 — Add the auto-updater service

```bash
sudo nano /etc/systemd/system/collector-updater.service
```

```ini
[Unit]
Description=Timpi Collector Auto-Updater
After=network.target
Wants=collector.service

[Service]
Type=oneshot
User=root
WorkingDirectory=/opt/timpi
ExecStart=/bin/bash -c '\
  echo "[INFO] Stopping collector..."; \
  systemctl stop collector || true; \
  sleep 2; \
  echo "[INFO] Running CollectorAutoUpdater..."; \
  /opt/timpi/CollectorAutoUpdater; \
  echo "[INFO] Restarting collector..."; \
  systemctl start collector || true; \
  echo "[INFO] Update check done."'
```

---

## 9. Step 7 — Create and enable the 6-hour timer

```bash
sudo nano /etc/systemd/system/collector-updater.timer
```

```ini
[Unit]
Description=Run Timpi Collector Auto-Updater every 6 hours (and after boot)

[Timer]
OnBootSec=2min
OnUnitActiveSec=6h
Persistent=true
Unit=collector-updater.service

[Install]
WantedBy=timers.target
```

Then enable and start everything:

```bash
sudo systemctl daemon-reload
sudo systemctl enable collector
sudo systemctl enable collector-updater.timer
sudo systemctl start collector
sudo systemctl start collector-updater.timer
```

---

## 10. Step 8 — Verify

**Service status:**

```bash
sudo systemctl status collector
```

**Live logs:**

```bash
sudo journalctl -u collector -f
sudo journalctl -u collector-updater -f
```

**Timer schedule:**

```bash
systemctl list-timers | grep collector-updater
```

✅ `NEXT` and `LAST` should be roughly 6 hours apart.

---

## 11. How the auto-updater works

| Trigger | Action |
| --- | --- |
| System boot | Wait 2 min → run updater |
| Every 6 hours | Re-runs updater |
| During update | Stops collector → downloads new binary → restarts |
| After update | Collector runs the latest version |

---

## 12. Manual update / hotfix

### 🟢 Force an update now

```bash
sudo systemctl start collector-updater.service
sudo journalctl -u collector-updater -f
```

### 🟡 Manual run (advanced)

```bash
sudo systemctl stop collector
cd /opt/timpi
sudo ./CollectorAutoUpdater
sudo systemctl start collector
```

### 🔵 Reset the timer

```bash
sudo systemctl restart collector-updater.timer
```

### 🧾 Check version & health

```bash
sudo systemctl status collector
sudo journalctl -u collector -n 20
```

Look for:

```text
[INF] Starting Timpi Collector (GUID=xxxx)
[INF] The response was successful: Collector found on ...
```

---

## 13. File summary

| Path | Description |
| --- | --- |
| `/opt/timpi/TimpiCollector` | Main collector binary |
| `/opt/timpi/CollectorAutoUpdater` | Auto-updater binary |
| `/opt/timpi/CollectorSettings.json` | Log level + settings |
| `/etc/systemd/system/collector.service` | Collector systemd service |
| `/etc/systemd/system/collector-updater.service` | Updater service |
| `/etc/systemd/system/collector-updater.timer` | 6-hour timer |

---

## 14. Troubleshooting

**Collector shows "deactivating (stop-sigterm)"** — Normal during an update.

**Timer missing `NEXT`** — Reload and restart:

```bash
sudo systemctl daemon-reload
sudo systemctl restart collector-updater.timer
```

**Collector offline in dashboard** — Verify GUID and check logs:

```bash
sudo journalctl -u collector -n 50
```

**Change log level**

```bash
sudo nano /opt/timpi/CollectorSettings.json
# edit "LogLevel"
sudo systemctl restart collector
```

---

## ✅ Done

Your **Timpi Collector v2 (Linux)** is now:

* Always running via systemd
* Auto-updating every 6 hours
* Restarting after updates
* Managed from [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

For urgent patches:

```bash
sudo systemctl start collector-updater.service
```

---

🆘 **Support:** [Timpi Discord](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
