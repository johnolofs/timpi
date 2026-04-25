# 🪟 Timpi Collector — Windows 10 / 11 Installation Guide

The Windows installer ships as a native `.exe` and runs the Collector as a background **Windows service** that starts automatically on boot.

---

<img width="1024" height="576" alt="TimpiCollector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 Table of Contents

1. [Get your GUID](#1-get-your-guid)
2. [Install](#2-install)
3. [What the installer sets up](#3-what-the-installer-sets-up)
4. [View live logs](#4-view-live-logs)
5. [Check for updates](#5-check-for-updates)
6. [Start, stop, restart the service](#6-start-stop-restart-the-service)
7. [Manage workers from the dashboard](#7-manage-workers-from-the-dashboard)
8. [Uninstall](#8-uninstall)
9. [What changed in v2](#9-what-changed-in-v2)

---

## 1. Get your GUID

Register your Collector at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management) and copy the GUID. You'll paste it during the installer's prompt.

If you haven't registered an NFT yet, follow the [Timpi Node Registration Guide](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md) first.

---

## 2. Install

* **Installer:** native `.exe` (Windows program)
* **Download:** [TimpiCollectorWindowsLatest-v2.rar](https://timpi.io/applications/windows/TimpiCollectorWindowsLatest-v2.rar)

### Steps

1. Download the `.rar` and extract it with [7-Zip](https://www.7-zip.org/) or Windows' built-in tool.
2. Inside the extracted folder you'll see `TimpiCollectorWindowsLatest-v2.exe`.

   <img width="709" height="204" alt="extracted folder" src="https://github.com/user-attachments/assets/d8688ced-0e98-4dd9-b47a-b3e310d5b8fc" />

3. **Right-click → Run as administrator** (required).

   <img width="511" height="573" alt="run as administrator" src="https://github.com/user-attachments/assets/3e9b3b87-84a3-4086-9b43-869571bc883e" />

4. When prompted, **paste your GUID**.

   <img width="496" height="391" alt="paste guid" src="https://github.com/user-attachments/assets/46313d5e-923a-4b04-b0a6-f732144d4559" />

5. Wait for the installer to finish (usually under a minute).

> [!WARNING]
> If Windows SmartScreen blocks the installer, click **More info → Run anyway**.

---

## 3. What the installer sets up

* Installs the Collector to `C:\Program Files\Timpi Intl. LTD`
* Creates a **Windows service** that starts on boot and restarts on crash
* Saves your GUID to `C:\Program Files\Timpi Intl. LTD\guid.txt`
* Adds two desktop shortcuts:

| Shortcut | What it does |
| --- | --- |
| **Timpi Collector Logs** | Opens a PowerShell tail of the live log |
| **Timpi Collector – Check for Updates** | Runs the auto-updater on demand |

* Adds the Collector to **Apps & Features** for clean uninstall.

> [!NOTE]
> v2 has **no UI / tray icon** — it runs fully headless and is managed from the web dashboard.

---

## 4. View live logs

### Option 1 — Desktop shortcut (recommended)

Double-click **Timpi Collector Logs** to open a live tail in PowerShell.

<img width="634" height="195" alt="logs shortcut" src="https://github.com/user-attachments/assets/e2b12908-8b92-4ef2-b7c7-45f57bf5e371" />

### Option 2 — PowerShell command

```powershell
Get-Content "C:\Program Files\Timpi Intl. LTD\logs\collector.out.log" -Tail 50 -Wait
```

**Log files:**

```text
C:\Program Files\Timpi Intl. LTD\logs\
 ├── collector.out.log   ← normal activity
 └── collector.err.log   ← errors only
```

Stop tailing with `Ctrl + C`.

---

## 5. Check for updates

The Collector auto-updates on reboot, but you can trigger an update on demand by double-clicking **Timpi Collector – Check for Updates** on the desktop.

Example output:

```text
Killing TimpiCollector (PID: 10784)...
Stopping Windows service: Timpi Collector
Service stopped.
Downloading TimpiCollector from: https://timpi.io/applications/windows/TimpiCollectorWindowsLatestExecutable.zip
Download completed. Extracting...
Extraction completed.
Starting service again...
```

The updater stops the service, downloads the latest build, replaces the executable, and restarts the service.

---

## 6. Start, stop, restart the service

1. Press **Start → search → Services** and open the Services app.
2. Find **Timpi Collector** in the list.

   <img width="1229" height="214" alt="timpi collector service" src="https://github.com/user-attachments/assets/90a37183-0893-4dd4-a934-4867503ec4b3" />

3. Right-click for **Start / Stop / Restart / Pause**.

> [!TIP]
> Use `Verbose` log level for troubleshooting, then revert to `Info` to keep log size down. Edit it in the dashboard or in `CollectorSettings.json`.

---

## 7. Manage workers from the dashboard

Open [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

From here you can:

* Monitor performance and uptime
* Adjust **Workers** and **Threads** (changes apply instantly)
* View per-node statistics

<img width="461" height="653" alt="dashboard" src="https://github.com/user-attachments/assets/9cb31038-1707-4edf-8499-bc686e23a9be" />

---

## 8. Uninstall

### Method 1 — Apps & Features

**Start → Settings → Apps → Installed Apps** → search "Timpi" → **Uninstall**.

### Method 2 — Control Panel

`Win + R` → `control` → **Programs → Uninstall a Program** → right-click **Timpi Collector → Uninstall**.

This removes all installed files, the Windows service, and both desktop shortcuts.

---

## 9. What changed in v2

| Feature | Description |
| --- | --- |
| No UI / Tray | Fully headless — no Timpi Manager or tray icon |
| GUID prompt | Enter or paste your GUID during installation |
| Auto-updater | Runs automatically on reboot, or manually from the desktop shortcut |
| Web dashboard | Manage workers, threads, and performance online |

---

**Support:** [Timpi Discord](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
