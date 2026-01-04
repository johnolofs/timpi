# Synaptron — Windows 10/11 Installation Guide

<img width="1480" height="862" src="https://github.com/user-attachments/assets/b0749433-3720-4422-a14d-26c4dec067c3"/>

A clean, click-by-click setup for **Timpi Synaptron** nodes.

> **Verify your version:** In Discord run **`/synaptronchecker`** with your node’s GUID.
> (Build labels may differ by package; always follow the checker + announcements.)

---


# 📑 Table of Contents

0. [Quick upgrade (existing installs only)](#0-quick-upgrade-existing-installs-only)
   * 0.1 [Open Terminal (Admin)](#01-open-terminal-admin)
   * 0.2 [Remove conda environment (`synap`)](#02-remove-conda-environment-synap)
   * 0.3 [Uninstall old app](#03-uninstall-old-app)
   * 0.4 [Install latest build](#04-install-latest-build)

1. [Before you start](#1-before-you-start)
   * 1.1 [Hardware requirements](#11-hardware-requirements)
   * 1.2 [Windows settings for uptime](#12-windows-settings-for-uptime)

2. [Check if you need an update (Discord)](#2-check-if-you-need-an-update-discord)

3. [Register your node & get the GUID](#3-register-your-node--get-the-guid)

4. [Download & install Synaptron](#4-download--install-synaptron)
   * 4.1 [Extract ZIP & run `setup_ClickMe.exe`](#41-extract-zip--run-setup_clickmeexe)
   * 4.2 [SmartScreen → Run anyway](#42-smartscreen--run-anyway)
   * 4.3 [Approve UAC](#43-approve-uac)

5. [First launch & registration (in the app)](#5-first-launch--registration-in-the-app)

6. [Pre-Install & Install (one-time prerequisites)](#6-pre-install--install-one-time-prerequisites)

7. [Enable your GPU & connect](#7-enable-your-gpu--connect)

8. [Start Work & verify](#8-start-work--verify)

9. [Post-install checks](#9-post-install-checks)

10. [(Optional) Auto-start on login](#10-optional-auto-start-on-login)

11. [Updating (clean reinstall)](#11-updating-clean-reinstall)

12. [Logs & paths](#12-logs--paths)

13. [Troubleshooting (quick fixes)](#13-troubleshooting-quick-fixes)

14. [Support & resources](#14-support--resources)

15. [FAQ (full)](#15-faq-full)

16. [Revisions](#16-revisions)


---

## 0) Quick upgrade (existing installs only)

> **Goal:** remove the old **conda env** and app, then install the latest package.

### 0.1 Open Terminal (Admin)

* Click Start → Windows PowerShell (Run as Administrator).

<img width="829" height="635" alt="image" src="https://github.com/user-attachments/assets/d13eabc9-454f-4744-ac8f-fd51e9901128" />



### 0.2 Remove conda environment (`synap`)

```powershell
cd "C:\Program Files\Synaptron"
conda env remove -n synap
```

<img width="858" height="292" alt="image" src="https://github.com/user-attachments/assets/1aadd4da-e870-47f2-a5aa-98cf66b7d088" />

* If you see “conda is not recognized”, try one of these explicit paths:


```powershell
& "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe" env remove -n synap
# or, if miniconda is under your user profile:
& "$env:USERPROFILE\miniconda3\Scripts\conda.exe" env remove -n synap
```

* Confirm with **Y** when prompted.

### 0.3 Uninstall old app

* Windows **Settings → Apps → Installed apps** → **Synaptron → Uninstall**.
* If “Python” from the prior bundle is listed, uninstall it as well.

### 0.4 Install latest build

* Download [Synaptronconda.zip](https://timpi.io/applications/windows/SynaptronSetupConda.zip) , then follow sections **4–8** below.
* Verify with **`/synaptronchecker`** after installation.

---

## 1) Before you start

### 1.1 Hardware requirements

* CPU: **4 cores**
* RAM: **12 GB**
* Disk: **250 GB** SSD/NVMe
* **NVIDIA GPU**, **Compute Capability ≥ 6.1** (GTX 10-series or newer)

### 1.2 Windows settings for uptime

* Disable **Sleep**: *Settings → System → Power & battery → Screen and sleep* → **Never**
* Use **Balanced** or **High performance** power plan
* Install **latest NVIDIA driver**, then reboot
* If using 3rd-party AV/firewall, allow the installer and Synaptron binaries

---

## 2) Check if you need an update (Discord)

Open Discord and run the checker.

![Open command palette for /synaptronchecker](https://github.com/user-attachments/assets/f1bcfd31-e8ef-460f-b210-996a90658d62)

![Checker modal — paste GUID](https://github.com/user-attachments/assets/8d8d958f-60e5-4a52-8582-386d2d68b8e7)

![Checker result — includes Update Required](https://github.com/user-attachments/assets/aec5c152-80d1-4af4-b258-e811092236f2)

If it shows **Update Required**, complete **[0) Quick upgrade]** or **[11) Updating]**.

---

## 3) Register your node & get the GUID

1. Go to **https://timpi.com/node/v2/management** and connect **Keplr**.
<img width="2017" height="357" alt="image" src="https://github.com/user-attachments/assets/73026350-2dc7-49fb-884a-fc762d4bab05" />


3. Select your **Synaptron NFT**.
4. Copy your **GUID** (you will paste it in the app during registration).

---

## 4) Download & install Synaptron

https://timpi.io/applications/windows/SynaptronSetupConda.zip

### 4.1 Extract ZIP & run `setup.exe`

* Download **`SynaptronSetupConda.zip`**, right-click → **Extract All…**

<img width="712" height="646" alt="image" src="https://github.com/user-attachments/assets/4bf6fdbb-eaa1-4433-bdf6-07f1083f23d5" />


* Open the extracted folder and **double-click** `setup.exe`.
<img width="335" height="276" alt="image" src="https://github.com/user-attachments/assets/61f62dcc-c04c-4d37-8e11-56a88c166e26" />


### 4.2 SmartScreen → Run anyway
<img width="336" height="314" alt="image" src="https://github.com/user-attachments/assets/d4dcc5c9-fa51-4205-818e-3d6130f8ac24" />


* If Windows SmartScreen appears → **More info** → **Run anyway**.
<img width="334" height="310" alt="image" src="https://github.com/user-attachments/assets/a2791aa3-5c17-45f1-92b4-bd63443bef85" />


### 4.3 Approve UAC

* When prompted by UAC, click **Yes**.
<img width="293" height="219" alt="image" src="https://github.com/user-attachments/assets/b799e2ae-9b89-4b0a-8b19-9c47b2a1f1f3" />


After installation, a desktop shortcut **Launch Synaptron** will be created.

---

## 5) First launch & registration (in the app)

1. Double-click **Launch Synaptron** (approve any UAC prompt for the agent).
<img width="1039" height="393" alt="Screenshot 2026-01-03 202353" src="https://github.com/user-attachments/assets/9f1b218a-5d8f-4f77-883e-4751c9333686" />


3. Paste your **GUID** and enter a **Friendly Name** (**≥17 characters**), then **Complete Registration**.
<img width="483" height="339" alt="image" src="https://github.com/user-attachments/assets/035e1f9e-5e01-4d4c-8976-f326f46f86eb" />

   * If the UI shows a “minimum 16 chars” note, still use **17+** to be safe.

You should receive a **Registration successful** prompt.
<img width="784" height="895" alt="image" src="https://github.com/user-attachments/assets/eeec72d3-47ee-4dd9-8a56-f6d1be5c8400" />


---

## 6) Pre-Install & Install (one-time prerequisites)

1. Click **Pre-Install** → wait for **Completed Successfully**.
2. Click **Install** → wait for **Completed Successfully**.

These steps fetch dependencies and can take **~15–20 minutes**. Do not close the application.

---

## 7) Enable your GPU & connect

1. In **Configure GPU Card(s)**, choose your **GPU** and click **Enable**.
2. Confirm your GPU shows **Enabled** and **Timpi Connected** is visible.
<img width="391" height="440" alt="image" src="https://github.com/user-attachments/assets/52750363-5133-44a8-87b7-19d089a0d00b" />


If the GPU does not appear: update NVIDIA drivers, reboot, re-launch Synaptron.

---

## 8) Start Work & verify

1. Click **Start Work** → you should see **Register For Work: Success**.
2. Logs will begin scrolling; detections will appear intermittently.
3. In Discord, run **`/synaptronchecker`** again to confirm **version**, **GPU**, and **status**.

---

## 9) Post-install checks

* Open **Task Manager** and confirm **SynapAgent** and related processes are running.
* You may see a tray notification indicating the agent continues to run in the background.

---

## 10) (Optional) Auto-start on login

1. Press **Win + R**, type `shell:startup`, press **Enter**.
2. Copy the **Launch Synaptron** shortcut into the **Startup** folder.

---

## 11) Updating (clean reinstall)

If **`/synaptronchecker`** says **Update Required**:

1. **Remove conda env** (Admin Terminal):

   ```powershell
   cd "C:\Program Files\Synaptron"
   conda env remove -n synap
   # If conda isn't in PATH:
   & "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe" env remove -n synap
   ```
2. **Uninstall** Synaptron: *Settings → Apps → Installed apps* → **Synaptron → Uninstall**
   Also uninstall any “Python” from the prior bundle if listed.
3. **Delete leftovers** (show hidden files):

   * `C:\ProgramData\Synaptron`
   * `C:\Users\<You>\AppData\Roaming\Synaptron`
   * *(Optional model cache)*
     `C:\Users\<You>\.cache\huggingface\hub` **or**
     `C:\Users\<You>\timpi.cache\huggingface\hub`
4. **Reboot** → re-download ZIP → extract → run **`setup_ClickMe.exe`** → repeat **5–8**.
5. Verify with **`/synaptronchecker`**.

> Your **GUID remains the same**; do not generate a new one.

---

## 12) Logs & paths

* **Logs:** `C:\Users\<You>\AppData\Roaming\Synaptron`
* **GUID & app data:** `C:\ProgramData\Synaptron`
* *(Optional model cache)* `C:\Users\<You>\.cache\huggingface\hub` or `C:\Users\<You>\timpi.cache\huggingface\hub`

---

## 13) Troubleshooting (quick fixes)

**Installer blocked (SmartScreen/UAC)**

* Extract the ZIP first. In SmartScreen choose **More info → Run anyway**. Approve UAC.

**Registration failed**

* Confirm **GUID** is correct and **Friendly Name ≥ 17 chars**. Try again.

**No GPU in drop-down / “No compatible GPU found”**

* Install latest **NVIDIA drivers**, **reboot**, re-launch Synaptron.
* Ensure card supports **Compute Capability ≥ 6.1**.
* Plug monitor into the **GPU** (not the motherboard iGPU).

**“Timpi Connected: No”**

* Check Internet; allow Synaptron in firewall/AV; retry.

**High VRAM usage / OOM**

* Close other GPU-heavy apps (games, miners, renderers). Restart Synaptron.

**Checker still shows old version after update**

* You likely skipped cleanup. Repeat **[11) Updating]** fully (conda env + uninstall + leftovers).

**Conda not recognized**

* Use the explicit path shown in **[11.1]** to run `conda.exe`.
* If that fails, reinstall using **[0) Quick upgrade]** steps.

**Start Work button missing/disabled**

* Ensure **GPU is Enabled** and **Registration** succeeded.

---

## 14) Support & resources

* **Discord support (tickets):**
  [https://discord.com/channels/946982023245992006/1179427377844068493](https://discord.com/channels/946982023245992006/1179427377844068493)
* **Windows video guide:** [https://www.youtube.com/watch?v=_SPVbZuCCPQ](https://www.youtube.com/watch?v=_SPVbZuCCPQ)
* **Download (Windows):** `SynaptronSetupConda.zip` https://timpi.io/applications/windows/SynaptronSetupConda.zip

---

## 15) FAQ (full)

### GPU

**Can I add VRAM from multiple GPUs or use more than one GPU at once?**
No. Current release recognizes **one GPU per node**; NFT-to-GPU is **1:1**.

**Multiple GPUs / multiple nodes on one machine?**
One node per GPU. To use multiple GPUs on one host, you need virtualization with **GPU passthrough** and one NFT per GPU (advanced; not officially supported).

**Supported GPUs?**
**NVIDIA only**, **Compute Capability ≥ 6.1** (see [https://developer.nvidia.com/cuda-gpus](https://developer.nvidia.com/cuda-gpus)).

**Do PCIe lanes matter?**
Yes. Use **PCIe Gen3 x8** or higher for adequate throughput.

**Split VRAM across VMs?**
Not supported natively.

**How are tiers determined?**
VRAM and GPU UUID reported to TAP determine your tier:

* **Tier 1:** 4–6 GB VRAM
* **Tier 2:** 8–16 GB VRAM

**Do 8 GB and 16 GB nodes earn the same?**
Tier 2 targets ~**14.3%** higher than Tier 1. Initially equal split within a tier (availability-based), later transitions to **performance-based**.

### OS Compatibility

* **Windows 10/11:** Supported
* **Linux containerization:** Supported on **Ubuntu 22.04**
* **HiveOS:** Not officially supported
* **VMs:** Possible with proper GPU passthrough (advanced)
* **WSL:** Not supported
* **Ports:** No open ports required

### Networking & Security

* **Port forwarding / UPnP:** Not needed
* **Static IP:** Not required
* **Bandwidth:** No strict minimum; **unlimited data** recommended (datasets download frequently)
* **Data processed:** Public domain; system runs isolated with **no open ports**

### Workload & Availability

* **GPU usage:** Expect **high/100%** under load; ensure power & cooling
* **Disconnections/penalties:** TBD; persistent disconnections may be penalized
* **Is there always work?** Yes—Collectors feed continuous image/text tasks
* **Tasks:** Start with image recognition; more tasks roll out over time (high-VRAM tasks for Tier 2)

### Rewards (overview)

* Pool model (illustrative):

  * Each active **T1** adds **1,400 NTMPI** / month
  * Each active **T2** adds **1,600 NTMPI** / month
  * Inactive contributions are **redistributed**; Tier 2 ~**14.3%** higher overall
* Phase 1: equal split within tier meeting availability; Phase 2: **performance-based**

---

## 16) Revisions

* **v1.3 — 2026-01-03:** Complete rewrite for GitHub; added **Quick upgrade** (conda removal), consolidated troubleshooting; image links use original user-attachments where available.
* **v1.1:** Added node registration steps; cleanup clarification; video tutorial.
* **v1.0:** Initial guide.

---


