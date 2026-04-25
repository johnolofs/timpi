# Synaptron — Windows 10/11 Installation Guide

<img width="1480" height="862" src="https://github.com/user-attachments/assets/b0749433-3720-4422-a14d-26c4dec067c3"/>

A clean, click-by-click setup for **Timpi Synaptron** nodes.

> **Verify your version:** In Discord run **`/synaptronchecker`** with your node’s GUID.
> Build labels may differ by package; always follow the checker + announcements.

---

# 📑 Table of Contents

✅ **NEW:** [Pre-Flight Check (Recommended)](#pre-flight-check-recommended)

0. [Quick upgrade (existing installs only)](#0-quick-upgrade-existing-installs-only)

   * 0.1 [Open Terminal (Admin)](#01-open-terminal-admin)
   * 0.2 [Remove conda environment (`synap`) — only if it exists](#02-remove-conda-environment-synap--only-if-it-exists)
   * 0.3 [Uninstall old app](#03-uninstall-old-app)
   * 0.4 [Delete leftovers (recommended)](#04-delete-leftovers-recommended)
   * 0.5 [Install latest build](#05-install-latest-build)

1. [Begin New Installation](#1-begin-new-installation)

   * 1.1 [Hardware requirements](#11-hardware-requirements)
   * 1.2 [Windows settings for uptime](#12-windows-settings-for-uptime)

2. [Register your node & get the GUID](#2-register-your-node--get-the-guid)

3. [Download & install Synaptron](#3-download--install-synaptron)

   * 3.1 [Extract ZIP & run `setup.exe`](#31-extract-zip--run-setupexe)
   * 3.2 [Approve UAC](#32-approve-uac)
   * 3.3 [SmartScreen → Run anyway](#33-smartscreen--run-anyway)

4. [First launch & registration (in the app)](#4-first-launch--registration-in-the-app)

5. [Pre-Install & Install (one-time prerequisites)](#5-pre-install--install-one-time-prerequisites)

6. [Enable your GPU & connect](#6-enable-your-gpu--connect)

7. [Start Work & verify](#7-start-work--verify)

8. [Post-install checks](#8-post-install-checks)

9. [(Optional) Auto-start on login](#9-optional-auto-start-on-login)

10. [Updating (clean reinstall)](#10-updating-clean-reinstall)

11. [Logs & paths](#11-logs--paths)

12. [Troubleshooting (quick fixes)](#12-troubleshooting-quick-fixes)

13. [Support & resources](#13-support--resources)

14. [FAQ (full)](#14-faq-full)

15. [Revisions](#15-revisions)

---

# Pre-Flight Check (Recommended)

> **Why this matters:** Synaptron installs its own **Miniconda**.
> If your computer already has **Python / Conda**, the Windows installer can conflict and fail.

### Run this in PowerShell (any mode)

```powershell
Write-Host "Conda in PATH:" (Get-Command conda -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Host "Synaptron Miniconda:" (Test-Path "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe")
Write-Host "User Miniconda:" (Test-Path "$env:USERPROFILE\miniconda3\Scripts\conda.exe")
```

### Interpret the result

* **Synaptron Miniconda: True** → continue normally
* **Synaptron Miniconda: False** → do **not** run any `conda` commands; proceed to uninstall + cleanup (Section 0.3 / 0.4)
* **Conda in PATH: 1** (and you see `(base)` in PowerShell) → you have an existing Conda install. If the installer fails, use the **Python/Conda Conflict Fix** in Troubleshooting.

---

## 0) Quick upgrade (existing installs only)

> **Goal:** remove the old app + old environment, then install the latest build.
> **Important:** If the conda step fails, **do not get stuck there**—skip it and continue cleanup.

---

### 0.1 Open Terminal (Admin)

* Click Start → Windows PowerShell → **Run as Administrator**.

<img width="829" height="635" alt="image" src="https://github.com/user-attachments/assets/d13eabc9-454f-4744-ac8f-fd51e9901128" />

---

### 0.2 Remove conda environment (`synap`) — only if it exists

> This step only works if Synaptron Miniconda or User Miniconda exists (see Pre-Flight).

Try the normal command:

```powershell
cd "C:\Program Files\Synaptron"
conda env remove -n synap
```

If `conda` is not recognized, try an explicit path:

```powershell
& "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe" env remove -n synap
# or, if miniconda is under your user profile:
& "$env:USERPROFILE\miniconda3\Scripts\conda.exe" env remove -n synap
```

* Confirm with **Y** when prompted.

#### ✅ If you get errors like:

* `conda is not recognized`
* or `...conda.exe... is not recognized`

➡️ **Skip this step** and go to **0.3**.
This means the conda install is missing/broken and there is nothing to remove.

---

### 0.3 Uninstall old app

* Windows **Settings → Apps → Installed apps** → **Synaptron → Uninstall**

<img width="543" height="447" alt="synaptron remove" src="https://github.com/user-attachments/assets/a385d36e-5142-4c38-9215-40703a85c6fe" />

* If **Python** and/or **Miniconda** from an older Synaptron bundle is listed, uninstall those as well.

<img width="555" height="470" alt="python remove" src="https://github.com/user-attachments/assets/8b747539-4177-490e-ae58-45e6f17a020d" />

---

### 0.4 Delete leftovers (recommended)

> This prevents “half-installed” states that cause the installer to fail repeatedly.

Delete these folders (if they exist):

```powershell
Remove-Item "C:\Program Files\Synaptron" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\ProgramData\Synaptron" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Synaptron" -Recurse -Force -ErrorAction SilentlyContinue
```

Then **reboot Windows**.

---

### 0.5 Install latest build

* Download: [https://timpi.io/applications/windows/SynaptronSetupConda.zip](https://timpi.io/applications/windows/SynaptronSetupConda.zip)
* Continue with **Sections 3–8**.
* Verify with **`/synaptronchecker`** after installation.

---

> **If you followed Quick Upgrade:** You can skip Sections **1–2** (hardware + registration) if already done.

---

## 1) Begin New Installation

### 1.1 Hardware requirements

* CPU: **4 cores**
* RAM: **12 GB**
* Disk: **250 GB** SSD/NVMe
* **NVIDIA GPU**, **Compute Capability ≥ 6.1** (GTX 10-series or newer)

### 1.2 Windows settings for uptime

* Disable Sleep: *Settings → System → Power & battery → Screen and sleep* → **Never**
* Use Balanced or High performance power plan
* Install the **latest NVIDIA driver**, then reboot
* If using 3rd-party AV/firewall, allow Synaptron installer + binaries

---

## 2) Register your node & get the GUID

1. Go to **[https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)** and connect **Keplr**.

<img width="2017" height="357" alt="image" src="https://github.com/user-attachments/assets/73026350-2dc7-49fb-884a-fc762d4bab05" />

2. Select your **Synaptron NFT**
3. Click **Register** (scroll if needed)
4. Copy your **GUID** (save it for later; you will paste it in the app)

---

## 3) Download & install Synaptron

Download: [https://timpi.io/applications/windows/SynaptronSetupConda.zip](https://timpi.io/applications/windows/SynaptronSetupConda.zip)

### 3.1 Extract ZIP & run `setup.exe`

* Right-click ZIP → **Extract All…**

<img width="456" height="423" alt="image" src="https://github.com/user-attachments/assets/4bf6fdbb-eaa1-4433-bdf6-07f1083f23d5" />

* Open extracted folder → right-click `setup.exe` → **Run as administrator**

<img width="613" height="114" alt="Run as administrator" src="https://github.com/user-attachments/assets/f73c89f7-96ab-40e4-93de-a2bccfd872b6" />

* If prompted, allow installation of .NET Desktop components.

<img width="380" height="216" alt="image" src="https://github.com/user-attachments/assets/94c5e9bb-3265-4f4c-9b2c-153df8ce71eb" />

### 3.2 Approve UAC

* When prompted, click **Yes**.

<img width="293" height="219" alt="image" src="https://github.com/user-attachments/assets/b799e2ae-9b89-4b0a-8b19-9c47b2a1f1f3" />

> Note: UAC prompts can appear on another monitor or behind windows.

### 3.3 SmartScreen → Run anyway

* SmartScreen → **More info** → **Run anyway**

<img width="334" height="310" alt="image" src="https://github.com/user-attachments/assets/a2791aa3-5c17-45f1-92b4-bd63443bef85" />
<img width="336" height="314" alt="image" src="https://github.com/user-attachments/assets/d4dcc5c9-fa51-4205-818e-3d6130f8ac24" />

After installation you should see the Synaptron launcher.

<img width="335" height="276" alt="image" src="https://github.com/user-attachments/assets/61f62dcc-c04c-4d37-8e11-56a88c166e26" />

A desktop shortcut **Launch Synaptron** will be created.

<img width="135" height="139" alt="Launch Synaptron Icon" src="https://github.com/user-attachments/assets/e436f7b8-8857-4e56-a936-4248faeb6a05" />

---

## 4) First launch & registration (in the app)

1. Double-click **Launch Synaptron** (approve UAC if asked)
2. Paste your **GUID**
3. Enter a **Friendly Name** (**≥ 17 characters**)
4. Click **Complete Registration**

<img width="483" height="339" alt="image" src="https://github.com/user-attachments/assets/035e1f9e-5e01-4d4c-8976-f326f46f86eb" />

You should see **Registration successful**.

<img width="492" height="465" alt="image" src="https://github.com/user-attachments/assets/eeec72d3-47ee-4dd9-8a56-f6d1be5c8400" />

---

## 5) Pre-Install & Install (one-time prerequisites)

1. Click **Pre-Install** → wait for **Completed Successfully**

<img width="576" height="142" alt="install button" src="https://github.com/user-attachments/assets/8af5f9f8-b8a1-4eb3-9de0-4266d55421fb" />

During Pre-Install you may see **Ollama** install. Allow it to complete.

<img width="420" height="321" alt="ollama installing" src="https://github.com/user-attachments/assets/ccdba406-8a0f-4b6e-8f25-388229660b44" />

2. Confirm success message

<img width="167" height="133" alt="install success" src="https://github.com/user-attachments/assets/e48210d5-5d4f-4f80-b56b-7867190342a3" />

3. Click **Install** → wait for **Completed Successfully**

<img width="565" height="126" alt="install button1" src="https://github.com/user-attachments/assets/91efac36-3ba8-42e4-bb05-1193bd2e659b" />

> This may take **15–20 minutes**. Do not close the app.

---

## 6) Enable your GPU & connect

1. In **Configure GPU Card(s)** select your GPU and click **Enable**
2. Confirm it shows **Enabled** and **Timpi Connected**

<img width="391" height="440" alt="image" src="https://github.com/user-attachments/assets/52750363-5133-44a8-87b7-19d089a0d00b" />

If GPU does not appear:

* Update NVIDIA driver
* Reboot
* Launch Synaptron again

---

## 7) Start Work & verify

1. Click **Start Work**
2. You should see **Register For Work: Success**
3. In Discord run **`/synaptronchecker`** to confirm version/status

---

## 8) Post-install checks

* Task Manager should show Synaptron/SynapAgent processes running
* App may continue in the tray/background

---

## 9) (Optional) Auto-start on login

1. Press **Win + R**
2. Type `shell:startup`
3. Copy **Launch Synaptron** shortcut into the Startup folder

---

## 10) Updating (clean reinstall)

If **`/synaptronchecker`** shows **Update Required**:

1. Follow **Section 0 (Quick upgrade)** completely:

   * uninstall
   * delete leftovers
   * reboot
   * reinstall

> **Important:** If `Synaptron Miniconda: False`, skip conda commands and do full cleanup.

---

## 11) Logs & paths

* Logs: `C:\Users\<You>\AppData\Roaming\Synaptron`
* GUID & app data: `C:\ProgramData\Synaptron`
* Optional model cache:

  * `C:\Users\<You>\.cache\huggingface\hub`
  * or `C:\Users\<You>\timpi.cache\huggingface\hub`

---

## 12) Troubleshooting (quick fixes)

### Installer blocked (SmartScreen/UAC)

Extract ZIP first → SmartScreen: **More info → Run anyway** → approve UAC.

### Registration failed

Confirm GUID + Friendly Name **≥ 17 chars**.

### No GPU in drop-down / “No compatible GPU found”

Install latest NVIDIA driver → reboot → relaunch. Ensure Compute Capability ≥ 6.1.

### “Timpi Connected: No”

Check Internet + firewall/AV allow rules.

### Checker still shows old version after update

You skipped cleanup. Run **Section 0** fully.

---

### ✅ Python / Conda conflict (IMPORTANT)

**Symptoms**

* PowerShell shows `(base)`
* `Conda in PATH: 1`
* Installer fails during **Install**
* Errors about `conda` / missing `miniconda3`

**Fix**

1. Uninstall Synaptron
2. Delete leftovers (Section 0.4)
3. Reboot
4. Reinstall Synaptron (Run `setup.exe` as Administrator)

**If you need Conda for other software**

* Best workaround: install Synaptron under a **separate Windows user account** (fresh profile = no conflicts).

---

## 13) Support & resources

* Discord tickets: [https://discord.com/channels/946982023245992006/1179427377844068493](https://discord.com/channels/946982023245992006/1179427377844068493)
* Windows video: [https://www.youtube.com/watch?v=_SPVbZuCCPQ](https://www.youtube.com/watch?v=_SPVbZuCCPQ)
* Download: [https://timpi.io/applications/windows/SynaptronSetupConda.zip](https://timpi.io/applications/windows/SynaptronSetupConda.zip)

---

## 14) FAQ (full)

### GPU

**Can I add VRAM from multiple GPUs or use more than one GPU at once?**
No. One GPU per node (1:1 with NFT).

**Supported GPUs?**
NVIDIA only, Compute Capability ≥ 6.1: [https://developer.nvidia.com/cuda-gpus](https://developer.nvidia.com/cuda-gpus)

**Tiers**

* Tier 1: 4–6 GB VRAM
* Tier 2: 8–16 GB VRAM

### OS Compatibility

* Windows 10/11 supported
* WSL not supported
* No open ports required

### Networking & Security

* No port forwarding needed
* Unlimited data recommended

---

## 15) Revisions

* **v1.4 — 2026-01-07:** Added Pre-Flight check, safe conda step, cleanup-first logic, and Python/Conda conflict fix based on Windows ticket cases.
* **v1.3 — 2026-01-03:** Rewrite for GitHub; added quick upgrade; consolidated troubleshooting.
* **v1.0:** Initial guide.
