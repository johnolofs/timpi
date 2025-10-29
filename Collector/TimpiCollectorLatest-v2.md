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
8. [Step 5 — Run Collector Manually (With GUID)](#-step-5--run-collector-manually-with-guid)
9. [Step 6 — Create the Collector Service (Auto-Start)](#-step-6--create-the-collector-service-auto-start)
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

## ▶️ **Step 5 — Run Collector Manually (With GUID)**

> 🟢 You must run this **inside `/opt/timpi`**, or it won’t find the configuration files.

```bash
cd /opt/timpi
sudo ./TimpiCollector PASTE-YOUR-GUID
```

✅ **Expected output**

```
[INF] Currently on version 2.X.X
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

## ⚙️ **Step 6 — Create the Collector Service (Auto-Start)**

Keep the classic name so it’s familiar to existing users.

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
