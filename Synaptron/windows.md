# 🪟 Synaptron — Windows 10 / 11 Installation Guide

A clean, click-by-click setup for **Timpi Synaptron** nodes on Windows.

> **Verify your version:** in Discord run `/synaptronchecker` with your node's GUID.
> 📺 [Video walkthrough](https://www.youtube.com/watch?v=_SPVbZuCCPQ)

---

## 📑 Table of Contents

0. [Quick upgrade (existing installs only)](#0-quick-upgrade-existing-installs-only)
1. [Hardware & Windows settings](#1-hardware--windows-settings)
2. [Register your node & get the GUID](#2-register-your-node--get-the-guid)
3. [Download & install Synaptron](#3-download--install-synaptron)
4. [First launch & registration](#4-first-launch--registration)
5. [Pre-Install & Install (one-time prerequisites)](#5-pre-install--install-one-time-prerequisites)
6. [Enable your GPU & connect](#6-enable-your-gpu--connect)
7. [Start Work & verify](#7-start-work--verify)
8. [Post-install checks](#8-post-install-checks)
9. [(Optional) Auto-start on login](#9-optional-auto-start-on-login)
10. [Updating (clean reinstall)](#10-updating-clean-reinstall)
11. [Logs & paths](#11-logs--paths)
12. [Troubleshooting](#12-troubleshooting)
13. [FAQ](#13-faq)

---

## 0. Quick upgrade (existing installs only)

If you already run Synaptron and `/synaptronchecker` says **Update Required**, do this **before** running the new installer.

### 0.1 Open Terminal as Admin

Start → search **PowerShell** → right-click → **Run as administrator**.

<img width="829" height="635" alt="powershell as admin" src="https://github.com/user-attachments/assets/d13eabc9-454f-4744-ac8f-fd51e9901128" />

### 0.2 Remove conda environment (`synap`)

```powershell
cd "C:\Program Files\Synaptron"
conda env remove -n synap
```

If `conda` isn't recognized, use the explicit path:

```powershell
& "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe" env remove -n synap
# or, if miniconda is under your user profile:
& "$env:USERPROFILE\miniconda3\Scripts\conda.exe" env remove -n synap
```

Confirm with **Y** when prompted.

### 0.3 Uninstall the old app

**Settings → Apps → Installed apps → Synaptron → Uninstall.**

If **Python** or **miniconda** from the prior bundle is listed, uninstall those too.

### 0.4 Continue with the latest build

Skip ahead to **[3. Download & install Synaptron](#3-download--install-synaptron)** — your GUID stays the same.

---

## 1. Hardware & Windows settings

### Hardware (minimum)

* CPU: 4 cores
* RAM: 12 GB
* Disk: 250 GB SSD / NVMe
* **NVIDIA GPU**, Compute Capability ≥ 6.1 (GTX 10-series or newer) — see [NVIDIA's list](https://developer.nvidia.com/cuda-gpus)

### Windows uptime tips

* Disable **Sleep**: *Settings → System → Power & battery → Screen and sleep* → **Never**
* Use **Balanced** or **High performance** power plan
* Install the **latest NVIDIA driver**, then reboot
* If you use third-party AV / firewall, allow the installer and Synaptron binaries

> 💡 **Dedicated PC:** consider pausing Windows Update during long runs.
> 💡 **Shared PC:** ensure AV/firewall allows Synaptron; keep Sleep off.

---

## 2. Register your node & get the GUID

1. Visit **[https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)** and connect **Keplr**.

   <img width="2017" height="357" alt="dashboard" src="https://github.com/user-attachments/assets/73026350-2dc7-49fb-884a-fc762d4bab05" />

2. Select your **Synaptron NFT**. (If you have multiple NFTs, scroll to find the registration button.)
3. Once registered, copy your **GUID**. The dashboard remembers it, but keep a local copy too.

For the full registration walkthrough see the [Timpi Node Registration Guide](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md).

---

## 3. Download & install Synaptron

**📥 Download:** [SynaptronSetupConda.zip](https://timpi.io/applications/windows/SynaptronSetupConda.zip)

### 3.1 Extract the ZIP and run `setup.exe`

* Right-click the ZIP → **Extract All…**

  <img width="456" height="423" alt="extract zip" src="https://github.com/user-attachments/assets/4bf6fdbb-eaa1-4433-bdf6-07f1083f23d5" />

* Open the extracted folder, right-click `setup.exe` → **Run as administrator**.

  <img width="613" height="114" alt="run as administrator" src="https://github.com/user-attachments/assets/f73c89f7-96ab-40e4-93de-a2bccfd872b6" />

* On a fresh PC the installer may install **.NET Desktop** components first.

  <img width="380" height="216" alt=".net install" src="https://github.com/user-attachments/assets/94c5e9bb-3265-4f4c-9b2c-153df8ce71eb" />

### 3.2 Approve UAC

Click **Yes**.

<img width="293" height="219" alt="UAC prompt" src="https://github.com/user-attachments/assets/b799e2ae-9b89-4b0a-8b19-9c47b2a1f1f3" />

> 💡 With multiple monitors the UAC prompt may appear elsewhere. With one monitor it can hide behind other windows. You must approve it to continue.

### 3.3 SmartScreen → Run anyway

If Windows SmartScreen appears, click **More info → Run anyway**.

<img width="334" height="310" alt="smartscreen warning" src="https://github.com/user-attachments/assets/a2791aa3-5c17-45f1-92b4-bd63443bef85" />

<img width="336" height="314" alt="smartscreen run anyway" src="https://github.com/user-attachments/assets/d4dcc5c9-fa51-4205-818e-3d6130f8ac24" />

The installer then runs through.

After install, a **Launch Synaptron** desktop shortcut appears.

<img width="135" height="139" alt="launch shortcut" src="https://github.com/user-attachments/assets/e436f7b8-8857-4e56-a936-4248faeb6a05" />

---

## 4. First launch & registration

1. Double-click **Launch Synaptron** (approve any UAC prompt for the agent).
2. Paste your **GUID** and enter a **Friendly Name** (≥ 17 characters), then **Complete Registration**.

   <img width="483" height="339" alt="registration" src="https://github.com/user-attachments/assets/035e1f9e-5e01-4d4c-8976-f326f46f86eb" />

3. You should see **Registration successful**.

   <img width="492" height="465" alt="registration success" src="https://github.com/user-attachments/assets/eeec72d3-47ee-4dd9-8a56-f6d1be5c8400" />

> If the UI shows a "minimum 16 chars" hint, still use **17+** to be safe.

---

## 5. Pre-Install & Install (one-time prerequisites)

1. Click **Pre-Install** → wait for **Completed Successfully**.

   <img width="576" height="142" alt="pre-install button" src="https://github.com/user-attachments/assets/8af5f9f8-b8a1-4eb3-9de0-4266d55421fb" />

   During Pre-Install **Ollama** installs itself — let it finish.

   <img width="420" height="321" alt="ollama installing" src="https://github.com/user-attachments/assets/ccdba406-8a0f-4b6e-8f25-388229660b44" />

2. Click **Install** → wait for **Completed Successfully**.

   <img width="565" height="126" alt="install button" src="https://github.com/user-attachments/assets/91efac36-3ba8-42e4-bb05-1193bd2e659b" />

These two steps fetch dependencies and can take **~15–20 minutes**. Don't close the app.

---

## 6. Enable your GPU & connect

1. In **Configure GPU Card(s)**, choose your GPU and click **Enable**.
2. Confirm the GPU shows **Enabled** and **Timpi Connected**.

<img width="391" height="440" alt="gpu enabled" src="https://github.com/user-attachments/assets/52750363-5133-44a8-87b7-19d089a0d00b" />

If the GPU doesn't appear: update NVIDIA drivers, reboot, and re-launch Synaptron.

---

## 7. Start Work & verify

1. Click **Start Work** → **Register For Work: Success**.
2. Logs scroll; detections appear between routine "No object detected" lines (normal).
3. In Discord, run `/synaptronchecker` to confirm **version**, **GPU**, and **status**.

---

## 8. Post-install checks

* Open **Task Manager** — you should see **SynapAgent** and related processes.
* The system tray may show the agent running in the background.

---

## 9. (Optional) Auto-start on login

1. `Win + R` → `shell:startup` → **Enter**.
2. Copy the **Launch Synaptron** shortcut into the Startup folder.

---

## 10. Updating (clean reinstall)

If `/synaptronchecker` says **Update Required**:

1. **Remove conda env** in an Admin terminal:

   ```powershell
   cd "C:\Program Files\Synaptron"
   conda env remove -n synap
   # if conda isn't in PATH:
   & "C:\Program Files\Synaptron\miniconda3\Scripts\conda.exe" env remove -n synap
   ```

2. **Uninstall** Synaptron from **Settings → Apps → Installed apps**.
   Also remove **Python** / **miniconda** from the prior bundle if listed.

3. **Delete leftovers** (show hidden files):

   * `C:\ProgramData\Synaptron`
   * `C:\Users\<You>\AppData\Roaming\Synaptron`
   * *(optional model cache)* `C:\Users\<You>\.cache\huggingface\hub` or `C:\Users\<You>\timpi.cache\huggingface\hub`

4. **Reboot**, re-download the ZIP, run `setup.exe`, repeat sections **4–7**.

5. Verify with `/synaptronchecker`.

> 💡 Your **GUID stays the same** — don't generate a new one.

---

## 11. Logs & paths

| Path | Contents |
| --- | --- |
| `C:\Users\<You>\AppData\Roaming\Synaptron` | Logs |
| `C:\ProgramData\Synaptron` | GUID and app data |
| `C:\Users\<You>\.cache\huggingface\hub` | Model cache (alt: `timpi.cache\huggingface\hub`) |

---

## 12. Troubleshooting

| Symptom | Fix |
| --- | --- |
| Installer blocked by SmartScreen / UAC | Extract the ZIP first, click **More info → Run anyway**, approve UAC |
| Registration failed | Check GUID is correct, Friendly Name ≥ 17 chars |
| No GPU in dropdown / "No compatible GPU found" | Update NVIDIA drivers, reboot, ensure card has Compute Capability ≥ 6.1, plug monitor into GPU (not motherboard iGPU) |
| "Timpi Connected: No" | Internet down / firewall blocked — allow Synaptron in firewall and AV |
| High VRAM / OOM | Close other GPU-heavy apps (games, miners, renderers), restart Synaptron |
| "No object detected" spam | Normal between detections, let it run |
| Checker shows old version after update | You skipped cleanup — repeat the **conda env remove** + uninstall + leftover cleanup |
| `conda` not recognized | Use the explicit path shown in section 0.2 |
| Start Work button missing | Make sure GPU is **Enabled** and registration succeeded |

---

## 13. FAQ

### GPU

**Multiple GPUs — does VRAM add up?**
No. One GPU per node; the NFT-to-GPU mapping is 1:1.

**Multiple nodes on one machine?**
One node per GPU. To use multiple GPUs you'd need virtualization with GPU passthrough and one NFT per GPU (advanced; not officially supported).

**Which GPUs are supported?**
**NVIDIA only**, Compute Capability ≥ 6.1. See [https://developer.nvidia.com/cuda-gpus](https://developer.nvidia.com/cuda-gpus).

**Do PCIe lanes matter?**
Yes — use **PCIe Gen3 x8 or higher**.

**Tier rules:**

* Tier 1: 4–6 GB VRAM
* Tier 2: 8–16 GB VRAM
* Tier 3: RTX 4090 / 5090 (Blackwell builds)

**Earnings:** Tier 2 targets ~14.3% higher than Tier 1. Phase 1 splits equally within a tier (availability-based); Phase 2 transitions to performance-based.

### OS compatibility

* Windows 10 / 11 — supported
* Linux Ubuntu 22.04 (Docker) — supported
* HiveOS, WSL — not supported
* VMs — possible with proper GPU passthrough (advanced)

### Networking

* Port forwarding / UPnP — not needed
* Static IP — not required
* Bandwidth — no strict minimum, but **unlimited data recommended** (datasets download often)
* Data processed — public domain only, system runs isolated with no open ports

### Workload

* GPU usage: expect **high / 100%** under load — ensure power and cooling
* Always work? Yes — Collectors continuously feed image and text tasks

---

🆘 **Support:** [Timpi Discord — #synaptron-support](https://discord.com/channels/946982023245992006) · [Open a ticket](https://discord.com/channels/946982023245992006/1179427377844068493) · 📺 [Video walkthrough](https://www.youtube.com/watch?v=_SPVbZuCCPQ)
