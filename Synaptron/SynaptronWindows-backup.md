# 🧠 Synaptron — Windows 10/11 Installation & Upgrade Guide

Run a **Synaptron Node** to power Timpi’s AI processing layer.  
GPU-accelerated. Stable. Click-by-click.

<img width="1509" height="850" src="./Skärmavbild 2025-08-22 kl. 18.28.56.png" />

> **Latest Windows build:** `1.3.33`  
> **Verify your running version:** In Discord, run **`/synaptronchecker`** with your node’s GUID.  
> *(If the checker shows underscore formatting like `1_3_33`, that corresponds to `1.3.33`.)*

---

## Contents
0. [Quick upgrade (existing installs only)](#0-quick-upgrade-existing-installs-only)
1. [Before you start](#1-before-you-start)
2. [Check if you need an update (Discord)](#2-check-if-you-need-an-update-discord)
3. [Register your node & get the GUID](#3-register-your-node--get-the-guid)
4. [Download & install Synaptron](#4-download--install-synaptron)
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

**Goal:** remove the old `conda` environment (`synap`) before installing the new build.

1) **Open Terminal (Admin).**  
Right-click Start → **Terminal (Admin)**.  
![Open Windows Terminal (Admin)](./A387CC05-C00C-47E3-BCF8-C4708FC14FE9.png)

2) **Remove the Synaptron conda env.**
```powershell
cd "C:\Program Files\Synaptron"
conda env remove -n synap

Confirm with Y when prompted.

If you see “conda is not recognized”:
Run the full path, e.g.
& "$env:USERPROFILE\Miniconda3\Scripts\conda.exe" env remove -n synap
(Adjust the path if Miniconda is elsewhere.)

	3.	Uninstall the app (Settings → Apps → Installed apps → Synaptron → Uninstall).
This step is also shown later in [11) Updating].
	4.	Install the new version (1.3.33) using the standard flow in sections 4–8.

⸻

1) Before you start

Hardware
	•	CPU: 4 cores
	•	RAM: 12 GB
	•	Disk: 250 GB SSD/NVMe
	•	NVIDIA GPU with Compute Capability ≥ 6.1 (GTX 10-series or newer)

Windows (for uptime)
	•	Disable Sleep (Win11: Settings → System → Power & battery → Screen and sleep → Never)
	•	Use Balanced or High performance power plan
	•	Install the latest NVIDIA driver, then reboot
	•	If using 3rd-party AV/firewall, allow the installer and the app

⸻

2) Check if you need an update (Discord)
	1.	Open Discord and type /synaptronchecker.
![Open command palette for /synaptronchecker](./Skärmavbild 2025-08-22 kl. 18.14.09.png)
	2.	Paste your full GUID, then Submit.
![Checker modal — paste GUID](./Skärmavbild 2025-08-22 kl. 18.14.21.png)
	3.	Read the result card. If it says Update Required, do [0) Quick upgrade] then [4–8].
![Checker result — includes Update Required](./Skärmavbild 2025-08-22 kl. 18.15.22.png)

⸻

3) Register your node & get the GUID
	1.	Go to Timpi Node Management (https://timpi.com/node/management) and connect Keplr.
![Node Management — Connect Keplr Wallet](./Skärmavbild 2025-08-22 kl. 18.28.11.png)
	2.	Select your Synaptron NFT.
![Select your Synaptron NFT](./Skärmavbild 2025-08-22 kl. 18.29.32.png)
	3.	Copy your GUID. You’ll use it in the app in the next steps.

⸻

4) Download & install Synaptron
	1.	Download: synaptron_win_latest.zip (from Timpi downloads)
	2.	Extract the ZIP (Explorer or WinRAR).
![Extract the ZIP](./Skärmavbild 2025-08-22 kl. 18.27.12.png)
	3.	Open the folder and double-click setup_ClickMe.exe.
![Run setup_ClickMe.exe](./Skärmavbild 2025-08-22 kl. 18.27.20.png)
	4.	If Windows SmartScreen appears → More info → Run anyway.
![SmartScreen — More info](./Skärmavbild 2025-08-22 kl. 18.27.28.png)
![SmartScreen — Run anyway](./Skärmavbild 2025-08-22 kl. 18.27.35.png)
	5.	Follow the Setup wizard → Next.
![Setup wizard](./Skärmavbild 2025-08-22 kl. 18.27.42.png)
	6.	Approve the UAC prompt.
![UAC — allow changes](./Skärmavbild 2025-08-22 kl. 18.27.49.png)
	7.	After install, you’ll see Launch Synaptron on your desktop.
![Desktop shortcut — Launch Synaptron](./Skärmavbild 2025-08-22 kl. 18.27.57.png)

⸻

5) First launch & registration (in the app)
	1.	Double-click Launch Synaptron. If you see UAC for the agent, click Yes.
![UAC — SynapAgent](./Skärmavbild 2025-08-22 kl. 18.28.03.png)
	2.	In the app, paste your GUID and enter a Friendly Name (≥17 characters), then Complete Registration.
![Register your node — GUID + Friendly Name ≥17 chars](./Skärmavbild 2025-08-22 kl. 18.28.18.png)
	3.	You’ll get a success confirmation.
![Registration success](./Skärmavbild 2025-08-22 kl. 18.28.24.png)

⸻

6) Pre-Install & Install (one-time prerequisites)
	1.	Run Pre-Install → wait for Completed Successfully.
![Pre-Install / Install overview](./Skärmavbild 2025-08-22 kl. 18.28.32.png)
![Pre-Install — Completed Successfully](./Skärmavbild 2025-08-22 kl. 18.28.41.png)
	2.	Run Install → wait for Completed Successfully.
![Install — Completed Successfully](./Skärmavbild 2025-08-22 kl. 18.28.49.png)

These two steps fetch prerequisites and can take ~15–20 minutes. Do not close the app while they run.

⸻

7) Enable your GPU & connect
	1.	In Configure GPU Card(s), choose your GPU and click Enable.
	2.	Confirm your GPU shows as Enabled and Timpi Connected is visible.
![Enable GPU — Timpi Connected](./Skärmavbild 2025-08-22 kl. 18.28.56.png)

If the GPU doesn’t appear, update NVIDIA drivers, reboot, and re-launch the app.

⸻

8) Start Work & verify
	1.	Click Start Work → Register For Work shows Success.
![Start Work — Register For Work success](./Skärmavbild 2025-08-22 kl. 18.29.15.png)
	2.	Logs will start to scroll; detections appear between “No object detected” (that’s normal).
![Working logs / detections](./Skärmavbild 2025-08-22 kl. 18.29.22.png)
	3.	In Discord, run /synaptronchecker again to confirm your running version, GPU, and status.

⸻

9) Post-install checks
	•	Task Manager should show SynapAgent and related processes running.
![Task Manager — SynapAgent & processes](./Skärmavbild 2025-08-22 kl. 18.29.47.png)
	•	A tray notification may confirm the agent keeps running in the background.
![Tray — SynapAgent running](./Skärmavbild 2025-08-22 kl. 18.29.56.png)

⸻

10) (Optional) Auto-start on login
	1.	Press Win + R, type shell:startup, press Enter.
	2.	Copy the Launch Synaptron shortcut into the Startup folder.

⸻

11) Updating (clean reinstall)

If /synaptronchecker says Update Required:

A. Remove old conda env

# Terminal (Admin)
cd "C:\Program Files\Synaptron"
conda env remove -n synap

B. Uninstall the app
	•	Settings → Apps → Installed apps → Synaptron → Uninstall
![Apps & features — uninstall for clean reinstall](./Skärmavbild 2025-08-22 kl. 18.30.05.png)

C. Install the new version (1.3.33)
	•	Re-download ZIP → extract → run setup_ClickMe.exe → repeat [5–8].
	•	Verify in Discord with /synaptronchecker.

Your GUID stays the same. No need to generate a new one.

⸻

12) Logs & paths
	•	Logs: C:\Users\<You>\AppData\Roaming\Synaptron
	•	GUID & app data: C:\ProgramData\Synaptron
	•	(Optional model cache) C:\Users\<You>\.cache\huggingface\hub or C:\Users\<You>\timpi.cache\huggingface\hub

⸻

13) Troubleshooting (quick fixes)

Installer blocked by Windows
	•	Extract the ZIP first. On SmartScreen choose More info → Run anyway. Approve UAC.

Registration failed
	•	Check GUID is correct and Friendly Name ≥ 17 chars. Try again.

No GPU in drop-down / “No compatible GPU found”
	•	Install latest NVIDIA drivers, reboot, re-launch.
	•	Ensure your card supports Compute Capability ≥ 6.1.
	•	Make sure your monitor cable is plugged into the GPU (not motherboard iGPU).

“Timpi Connected: No”
	•	Internet down / firewall blocked. Allow the app in Windows Firewall/AV and retry.

High VRAM usage / Out-of-memory
	•	Close other GPU apps (games, miners, renderers). Restart Synaptron.

“No object detected” spam
	•	Normal between detections. Let it run.

After update, checker still shows old version
	•	You likely skipped the conda env removal or leftover cleanup. Do [11] fully and verify again.

Conda not recognized
	•	Use the full path:
& "$env:USERPROFILE\Miniconda3\Scripts\conda.exe" env remove -n synap

⸻

14) Support & resources
	•	Discord support: open a ticket in #support
	•	(Direct link for members) https://discord.com/channels/946982023245992006/1179427377844068493
	•	Video walkthrough (Windows 10/11): https://www.youtube.com/watch?v=_SPVbZuCCPQ
	•	Download (Windows): synaptron_win_latest.zip (from Timpi downloads)

⸻

15) FAQ (full)

GPU

Q: If I have multiple GPUs, does VRAM add up, or can I use more than one GPU at once?
A: Not currently. Synaptron recognizes a single GPU per node; the NFT-to-GPU relationship is 1:1.

Q: Can I run several nodes on one GPU / several GPUs on one machine?
A: One node per GPU. To use multiple GPUs on one machine, you’d need virtualization (hypervisor with GPU passthrough) and one NFT per GPU. Advanced; not officially supported.

Q: Which GPUs are supported? NVIDIA only?
A: NVIDIA only for now, with Compute Capability ≥ 6.1. See: https://developer.nvidia.com/cuda-gpus

Q: Does PCIe lane speed matter for GenAI?
A: Yes. More lanes / higher gen improves throughput. Recommended PCIe Gen3 x8 or higher.

Q: Can I split VRAM across VMs?
A: Not supported natively.

Q: How are tiers determined?
A: VRAM and GPU UUID are reported to TAP and used to place nodes:
	•	Tier 1: 4–6 GB VRAM
	•	Tier 2: 8–16 GB VRAM

Q: Do 8 GB and 16 GB nodes earn the same?
A: Tier-based pools differ; Tier 2 targets ~14.3% higher than Tier 1 overall.
Phase 1: equal split within a tier among nodes meeting availability threshold.
Phase 2: transitions to performance-based (more work → more rewards).

⸻

OS Compatibility
	•	Windows 10 & 11: Supported.
	•	Linux containerization: Supported on Ubuntu 22.04.
	•	HiveOS: Not officially supported.
	•	VMs: Will work with proper GPU passthrough (advanced; docs later).
	•	WSL: Not supported.
	•	Ports: No open ports required.

⸻

Networking & Security
	•	Port forwarding / UPnP: Not needed.
	•	Static IP: Not required.
	•	Bandwidth: No strict minimum, but unlimited data is recommended (datasets download frequently).
	•	Data processed: Public domain content; system runs isolated with no open ports.

⸻

Workload & Availability
	•	GPU usage: Expect high/100% utilization under load. Ensure adequate power & cooling.
	•	Disconnections / penalties: TBD; persistent disconnections may be penalized.
	•	Is there always work? Yes. Collectors continuously expand/refresh the index; Synaptron processes text/images.
	•	Task types: Start with image recognition; more tasks will roll out over time. High-VRAM tasks will be Tier-2 only.

