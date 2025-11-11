# 🔄 **Timpi Collector v2 — Linux Installation Guide**

*(Headless + Auto-Updating Systemd Edition — 6 Hour Cycle)*

Timpi Collectors are decentralized “workers” that crawl and index websites for the **Timpi Search Engine** — privately, securely, and without ads or tracking.
This guide installs and configures both:

* 🧠 **TimpiCollector** – main worker
* 🔄 **CollectorAutoUpdater** – auto-updates the worker

Everything runs automatically in the background via **systemd services + timer**, including across reboots.
No scripts. No manual updates.

---

<img width="1024" height="576" alt="Timpi Collector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 **Table of Contents**

1. [Get Your GUID & Manage Workers](#1-get-your-guid--manage-workers)
2. [About Collector v2](#2-about-collector-v2)
3. [System Requirements](#3-system-requirements)
4. [Step 1 — Remove Old Versions](#4-step-1--remove-old-versions)
5. [Step 2 — Prepare a Clean Directory](#5-step-2--prepare-a-clean-directory)
6. [Step 3 — Download & Extract Collector v2](#6-step-3--download--extract-collector-v2)
7. [Step 4 — Set Permissions](#7-step-4--set-permissions)
8. [Step 5 — Create the Collector Service](#8-step-5--create-the-collector-service)
9. [Step 6 — Add the Auto-Updater Service](#9-step-6--add-the-auto-updater-service)
10. [Step 7 — Create and Enable the 6-Hour Timer](#10-step-7--create-and-enable-the-6-hour-timer)
11. [Step 8 — Verify Everything Works](#11-step-8--verify-everything-works)
12. [How the Auto-Updater Works](#12-how-the-auto-updater-works)
13. [Manual Update / Emergency Hotfix](#13-manual-update--emergency-hotfix)
14. [File Summary](#14-file-summary)
15. [Troubleshooting](#15-troubleshooting)

---

## 1️⃣ Get Your GUID & Manage Workers

👉 Visit [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

Here you can register and copy your Collector GUID, adjust Workers/Threads, and verify online status.
💡 Start with **1 Worker & 5 Threads** for stable performance.

---

## 2️⃣ About Collector v2

**Collector v2 for Linux is headless, auto-updating, and dashboard-managed.**

✅ Highlights

* 🚫 No UI or tray icon
* 🔄 Automatic updates through `CollectorAutoUpdater` + systemd timer
* ⚙️ Managed from the Timpi Dashboard
* 🧠 Stable 24/7 operation

---

## 3️⃣ System Requirements

| Resource | Minimum                          |
| :------- | :------------------------------- |
| OS       | Ubuntu 22.04 LTS (64-bit)        |
| CPU      | 2 cores                          |
| RAM      | 2 GB                             |
| Storage  | 1 GB free (SSD recommended)      |
| Network  | Stable connection (no data caps) |

---

## 4️⃣ Step 1 — Remove Old Versions

```bash
sudo systemctl stop collector 2>/dev/null || true
sudo systemctl stop collector-updater.timer 2>/dev/null || true
sudo systemctl stop collector-updater 2>/dev/null || true
sudo rm -f /etc/systemd/system/collector*.service /etc/systemd/system/collector*.timer
sudo systemctl daemon-reload
```

---

## 5️⃣ Step 2 — Prepare a Clean Directory

```bash
sudo rm -rf /opt/timpi
sudo mkdir -p /opt/timpi
sudo chown "$USER:$USER" /opt/timpi
cd /opt/timpi
```

---

## 6️⃣ Step 3 — Download & Extract Collector v2

```bash
wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-v2.rar -O TimpiCollectorLinuxLatest-v2.rar
sudo apt install -y unrar
unrar x TimpiCollectorLinuxLatest-v2.rar
mv TimpiCollectorLinuxLatest/* /opt/timpi/
rm -rf TimpiCollectorLinuxLatest TimpiCollectorLinuxLatest-v2.rar
```

Expected contents:

```
/opt/timpi/
├── TimpiCollector
├── CollectorAutoUpdater
├── CollectorSettings.json
└── public_suffix_list.dat
```

---

## 7️⃣ Step 4 — Set Permissions

```bash
sudo chmod +x /opt/timpi/TimpiCollector
sudo chmod +x /opt/timpi/CollectorAutoUpdater
```

---

## 8️⃣ Step 5 — Create the Collector Service

```bash
sudo nano /etc/systemd/system/collector.service
```

Paste (and replace `YOUR-GUID`):

```ini
[Unit]
Description=Timpi Collector v2 (Headless)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector YOUR-GUID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save → `Ctrl + O`, `Enter`, `Ctrl + X`.

---

## 9️⃣ Step 6 — Add the Auto-Updater Service

```bash
sudo nano /etc/systemd/system/collector-updater.service
```

Paste:

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

## 🔟 Step 7 — Create and Enable the 6-Hour Timer

```bash
sudo nano /etc/systemd/system/collector-updater.timer
```

Paste:

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

Then enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable collector
sudo systemctl enable collector-updater.timer
sudo systemctl start collector
sudo systemctl start collector-updater.timer
```

---

## 1️⃣1️⃣ Step 8 — Verify Everything Works

Check status:

```bash
sudo systemctl status collector
```

Follow logs:

```bash
sudo journalctl -u collector -f
```

Timer schedule:

```bash
systemctl list-timers | grep collector-updater
```

✅ `NEXT` and `LAST` should be ≈6 hours apart.

---

## 1️⃣2️⃣ How the Auto-Updater Works

| Trigger       | Action                                            |
| :------------ | :------------------------------------------------ |
| System boot   | Wait 2 min → runs updater                         |
| Every 6 hours | Re-runs updater                                   |
| During update | Stops collector → downloads new binary → restarts |
| After update  | Collector runs latest version automatically       |

---

## 1️⃣3️⃣ Manual Update / Emergency Hotfix

### 🟢 Force an update immediately

```bash
sudo systemctl start collector-updater.service
```

Monitored with:

```bash
sudo journalctl -u collector-updater -f
```

---

### 🟡 Manual run (advanced)

```bash
sudo systemctl stop collector
cd /opt/timpi
sudo ./CollectorAutoUpdater
sudo systemctl start collector
```

---

### 🔵 Reset timer schedule

```bash
sudo systemctl restart collector-updater.timer
```

---

### 🧾 Check version & health

```bash
sudo systemctl status collector
sudo journalctl -u collector -n 20
```

Look for:

```
[INF] Starting Timpi Collector (GUID=xxxx)
[INF] The response was successful: Collector found on ...
```

---

## 1️⃣4️⃣ File Summary

| Path                                            | Description               |
| :---------------------------------------------- | :------------------------ |
| `/opt/timpi/TimpiCollector`                     | Main collector binary     |
| `/opt/timpi/CollectorAutoUpdater`               | Auto-updater binary       |
| `/etc/systemd/system/collector.service`         | Collector systemd service |
| `/etc/systemd/system/collector-updater.service` | Updater service           |
| `/etc/systemd/system/collector-updater.timer`   | 6-hour timer              |

---

## 1️⃣5️⃣ Troubleshooting

**Collector shows “deactivating (stop-sigterm)”** → Normal while updating.
**Timer missing `NEXT`** → Reload and restart:

```bash
sudo systemctl daemon-reload
sudo systemctl restart collector-updater.timer
```

**Collector offline in dashboard** → Verify GUID and logs:

```bash
sudo journalctl -u collector -n 50
```

**Change log level**

```bash
sudo nano /opt/timpi/CollectorSettings.json
```

Edit `"LogLevel"` then:

```bash
sudo systemctl restart collector
```

---

## ✅ Done!

Your **Timpi Collector v2 (Linux)** is now:

* Always running via systemd
* Auto-updating every 6 hours
* Restarting after updates
* Managed through [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

For urgent patches, simply run:

```bash
sudo systemctl start collector-updater.service
```


















---
# 🔄 **Timpi Collector v2 — Linux Installation Guide**

### Our Collectors are decentralized “workers” crawling the web collecting information about websites and their pages.

This system remains invisible from front-end services, safeguarding the security of our Collectors.

---

<img width="1024" height="576" alt="Timpi Collector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 **Table of Contents**

1. [Get Your GUID & Manage Workers](#-get-your-guid--manage-workers)
2. [About Collector v2](#-about-collector-v2)
3. [Minimum System Requirements](#-minimum-system-requirements)
4. [Step 1 — Remove Old Versions](#-step-1--remove-old-versions)
5. [Step 2 — Prepare a Clean Directory](#-step-2--prepare-a-clean-directory)
6. [Step 3 — Download and Extract Collector v2](#-step-3--download-and-extract-collector-v2)
7. [Step 4 — (Optional) Change Log Level](#-step-4--optional-change-log-level)
8. [Step 5 — Run Collector Manually (With GUID)](#step-5-run-collector-manually-with-guid)  
9. [Step 6 — Create the Collector Service (Auto-Start)](#step-6-create-the-collector-service-auto-start)
10. [Step 7 — Check Logs & Status](#-step-7--check-logs--status)
11. [Step 8 — Verify Online Status & Adjust Workers](#-step-8--verify-online-status--adjust-workers)
12. [File Summary](#-file-summary)

---

## 🧭 **Get Your GUID & Manage Workers**

Visit the **Timpi Node Management Dashboard**:
👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

Here you can:

* 🆔 **Register your Collector** and get your **GUID**
* 👁️ **Check if your Collector is Online/Offline**
* ⚙️ **Change Workers & Threads** to adjust performance

💡 *Start with 1 Worker & 5 Threads. Increase gradually once stable.*

---

## 🧠 **About Collector v2**

Timpi Collector v2 is a **headless**, **auto-updating**, and **fully managed** version built for reliability and simplicity.

### ✅ Key Features

* 🚫 No UI or tray icon
* 🚫 No `timpi.config` file
* ⚙️ Must be run with your **GUID**
* 🔄 **Automatically updates itself** (no manual upgrades needed)
* 🌐 Managed from [Timpi Dashboard](https://timpi.com/node/v2/management)

Once installed, it silently keeps itself updated and reconnects automatically.

---

## ✅ **Minimum System Requirements**

| Resource    | Minimum                   |
| ----------- | ------------------------- |
| **OS**      | Ubuntu 22.04 LTS (64-bit) |
| **CPU**     | 2 cores                   |
| **RAM**     | 2 GB                      |
| **Storage** | 1 GB free (SSD)           |
| **Network** | Stable Unlimited          |

---

## 🧹 **Step 1 — Remove Old Versions**

Stop and remove old collectors:

```bash
sudo systemctl stop collector
sudo systemctl stop collector_ui
sudo rm -f /etc/systemd/system/collector.service
sudo rm -f /etc/systemd/system/collector_ui.service
sudo systemctl daemon-reload
```

✅ This ensures a clean environment before installing v2.

---

## 🧽 **Step 2 — Prepare a Clean Directory**

```bash
sudo rm -rf /opt/timpi
sudo mkdir -p /opt/timpi
sudo chown $USER:$USER /opt/timpi
cd /opt/timpi
```

---

## 📦 **Step 3 — Download and Extract Collector v2**

Download the latest version:

```bash
wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-v2.rar -O /opt/timpi/TimpiCollectorLinuxLatest-v2.rar
```

Install `unrar` if missing:

```bash
sudo apt install -y unrar
```

Extract the package:

```bash
sudo unrar x /opt/timpi/TimpiCollectorLinuxLatest-v2.rar /opt/timpi
```

Move files to main folder:

```bash
sudo mv /opt/timpi/TimpiCollectorLinuxLatest/* /opt/timpi/
sudo rm -rf /opt/timpi/TimpiCollectorLinuxLatest
```

Make executable:

```bash
sudo chmod +x /opt/timpi/TimpiCollector
```

Check files:

```bash
ls -l /opt/timpi
```

Expected:

```
TimpiCollector
CollectorSettings.json
public_suffix_list.dat
```

---

## 🧾 **Step 4 — (Optional) Change Log Level**

You can increase the amount of log detail by editing `CollectorSettings.json`.
By default, it looks like this:

```json
{
  "LogLevel": "Error"
}
```

To see detailed background activity, change it to:

```json
{
  "LogLevel": "Verbose"
}
```

Edit the file:

```bash
sudo nano /opt/timpi/CollectorSettings.json
```

Then save (**Ctrl + O → Enter → Ctrl + X**) and restart the collector later to apply.

🧠 **Tip:**

* `"Error"` → Only critical issues
* `"Info"` → Normal operation logs
* `"Verbose"` → Full activity details (ideal for troubleshooting)

---

<a name="step-5-run-collector-manually-with-guid"></a>
## ▶️ **Step 5 — Run Collector Manually (With GUID)**

> 🟢 You must run this **inside `/opt/timpi`**, or it won’t find the configuration files.

```bash
cd /opt/timpi
sudo ./TimpiCollector PASTE-YOUR-GUID
```

✅ **Expected output**

```
[INF] Currently on version 1.X.X
[INF] Logging level: Verbose
[INF] Trying to send keep alive…
```

❌ **If you forget the GUID**

```
[INF] Getting Collector Object from Coordinator was False, GUID=
[ERR] GeoCore not found!! Please make sure this node is registered.
```

🧠 “Error in sending keep alive... No Coordinator available” = normal if your region isn’t active yet.

---

<a name="step-6-create-the-collector-service-auto-start"></a>
## ⚙️ **Step 6 — Create the Collector Service (Auto-Start)**

Keeping the classic Service name.

```bash
sudo nano /etc/systemd/system/collector.service
```

Paste (replace `YOUR-GUID`):

```ini
[Unit]
Description=Timpi Collector v2 (Headless)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector YOUR-GUID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save (**Ctrl + O → Enter → Ctrl + X**)

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable collector
sudo systemctl start collector
```

---

## 🔍 **Step 7 — Check Logs & Status**

Follow live logs:

```bash
sudo journalctl -u collector -f
```

Check service status:

```bash
sudo systemctl status collector
```

Restart if needed:

```bash
sudo systemctl restart collector
```

---

## 🌐 **Step 8 — Verify Online Status & Adjust Workers**

Once running, open:

👉 **[https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)**

Here you can:

✅ **Confirm Status:**
Your Collector should show as **Online** within a few minutes.

✅ **Adjust Workers / Threads:**

* Modify **Workers** or **Threads** to tune performance.
* Click **Save / Update Settings** — changes apply instantly.
* Higher numbers use more CPU, RAM, and bandwidth.

<img width="461" height="653" alt="Skärmavbild 2025-10-29 kl  19 23 37" src="https://github.com/user-attachments/assets/4660ab7c-6720-41c4-a1f2-42f1bf8b16da" />

💡 Recommended: **1 Worker & 5 Threads** for most systems.

---

## 📄 **File Summary**

| File                     | Purpose                                         |
| ------------------------ | ----------------------------------------------- |
| `TimpiCollector`         | Main executable (auto-updating headless binary) |
| `CollectorSettings.json` | Contains logging level and runtime settings     |
| `public_suffix_list.dat` | Required domain suffix list                     |

---

## 🎯 **Done!**

Your **Timpi Collector v2** is now fully installed and running under
`collector.service`.

It will:

* 🚀 Auto-start on boot
* 🔄 Auto-update automatically
* 🧠 Respect your configured log level (Error, Info, or Verbose)
* 🌐 Appear as **Online** in your dashboard once connected

Manage everything via:
👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
