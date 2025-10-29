# 🔄 Timpi Collector Node for Windows 10 & 11 (v2)

### The Timpi Collector is a decentralized “worker” that helps power the Timpi search engine by crawling and indexing the web. Each Collector contributes to Timpi’s global data network while remaining completely private and secure.

---

<img width="1024" height="576" alt="TimpiCollector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

### 📑 Table of Contents

* [Installation Guide](#-installation-guide)

  * [1. Download the Installer](#-1-download-the-installer)
  * [2. Run the Installer](#-2-run-the-installer)
  * [3. What the Installer Does Automatically](#-3-what-the-installer-does-automatically)
* [Using Timpi Collector](#-using-timpi-collector)

  * [4. Start the Collector](#-4-start-the-collector)
  * [5. Access the Management Dashboard](#-5-access-the-management-dashboard)
  * [6. Register or Retrieve Your GUID](#-6-register-or-retrieve-your-guid)
* [Uninstallation Guide](#-uninstallation-guide)

  * [Method 1 – Apps & Features](#-method-1--apps--features)
  * [Method 2 – Control Panel](#-method-2--control-panel)

---

**Version:** `2.0.0`

📦 **Installer type:** Native `.exe` (Windows Program)

🔗 **Download:**
[TimpiCollectorSetup-v2.rar](https://timpi.io/applications/windows/TimpiCollectorWindowsLatest-v2.rar)

---

## 📥 Installation Guide

### 🔹 1. Download the Installer

* Click the link above to download the compressed `.rar` file.
* Extract it using [7-Zip](https://www.7-zip.org/) or Windows’ built-in extraction tool.
* Inside the archive, you’ll find the installer:
  👉 `TimpiCollectorWindowsLatest-v2.exe`
  <img width="709" height="204" alt="image" src="https://github.com/user-attachments/assets/d8688ced-0e98-4dd9-b47a-b3e310d5b8fc" />


---

### 🔹 2. Run the Installer

* **Right-click** `TimpiCollectorWindowsLatest-v2.exe`
* Select **“Run as Administrator”** (required for proper installation).
* Follow the installation wizard until completion.
<img width="512" height="614" alt="image" src="https://github.com/user-attachments/assets/a94c163a-2557-47f5-b02c-664e3f58437d" />


---

### 🔹 3. What the Installer Does Automatically

✅ Installs Timpi Collector to:
`C:\Program Files\Timpi Intl. LTD`

<img width="499" height="390" alt="image" src="https://github.com/user-attachments/assets/d0905cce-369e-40d3-899c-58d559f7c07a" />

✅ Registers required runtime components

✅ Creates a **desktop shortcut** named **TimpiCollector**

✅ Adds **Timpi Collector** to Windows “Apps & Features” for easy removal

🧩 *Note:* This version no longer includes the old Timpi Manager or system tray icon.

---

## 🖥 Using Timpi Collector

### 🔹 4. Start the Collector

1. **Double-click** the desktop icon **TimpiCollector**
2. If prompted, choose **“Run as Administrator”**
3. When launched, the program will **ask for your GUID**
<img width="980" height="164" alt="image" src="https://github.com/user-attachments/assets/cfab4b1a-f604-4da1-aa5a-51ef0b992611" />

   * Paste or type your GUID (you can register or retrieve it using the link below)
4. Once entered, the Collector will start automatically and begin operating and can be seen from **management dashboard**

---

### 🔹 5. Access the Management Dashboard

You can now view and control your Collector directly in your browser.
The web-based dashboard lets you:

👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

* Monitor Collector performance
* Adjust worker/thread settings
* Manage multiple nodes

<img width="461" height="653" alt="Skärmavbild 2025-10-29 kl  19 23 37" src="https://github.com/user-attachments/assets/9cb31038-1707-4edf-8499-bc686e23a9be" />


---

### 🔹 6. Register or Retrieve Your GUID

If you haven’t registered yet, follow this simple guide to create your node and receive your GUID:

📘 **Guide:** [Register Your Timpi Node (GUID Setup)](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)

Once registered, your **GUID** appears in your account under the management dashboard.
You’ll need this GUID when you start the Collector.

---

## 🗑 Uninstallation Guide

You can uninstall the Timpi Collector just like any other Windows program.

### 🔹 Method 1 – Apps & Features

1. Open **Start Menu → Settings**
2. Go to **Apps → Installed Apps**
3. Search for `Timpi`
4. Click **Uninstall** on **Timpi Collector**
5. Confirm removal

---

### 🔹 Method 2 – Control Panel

1. Press `Windows + R` → type `control` → press **Enter**
<img width="393" height="203" alt="image" src="https://github.com/user-attachments/assets/8c57851c-cd32-41be-ad3a-85526ee4c491" />

3. Go to **Programs → Uninstall a Program**
<img width="1125" height="440" alt="Screenshot 2025-10-29 172710" src="https://github.com/user-attachments/assets/f190b96e-3f86-4c17-bc28-32bb8ef2ad7c" />

5. Find **Timpi Collector**
<img width="916" height="82" alt="image" src="https://github.com/user-attachments/assets/c54f2944-9e83-458f-a91c-eee4596d35d1" />

7. Right-click → **Uninstall**
<img width="1123" height="246" alt="image" src="https://github.com/user-attachments/assets/f47507c4-20e9-484f-a2ef-e30741482717" />

✅ This removes:

* All installed program files
* The desktop shortcut
* Any system components related to the Collector

---

### 🧠 Summary of Key Changes (v2.0.0)

| Feature                  | Description                                                                                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| 🧩 **No UI / Tray**      | The Collector now runs headless — no Timpi Manager or tray icon                                                                    |
| 🧾 **GUID Prompt**       | You enter or paste your GUID at first startup                                                                                      |
| 💻 **Web Dashboard**     | Manage threads, workers, and performance online                                                                                    |
| 🌐 **GUID Registration** | Register and view your GUID at [RegisterNodes.md](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md) |
