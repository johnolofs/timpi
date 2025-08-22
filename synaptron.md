# 🧠 Timpi Synaptron Node Setup

A clean, click‑by‑click setup for **Timpi Synaptron** nodes on Windows.

> **Latest required version:** `1_1_35`  
> **How to verify your running version:** In Discord, run **`/synaptronchecker`** with your node’s GUID.

---

## Contents
1. [Before you start](#1-before-you-start)
2. [Check if you need an update (Discord)](#2-check-if-you-need-an-update-discord)
3. [Register your node & get the GUID](#3-register-your-node--get-the-guid)
4. [Download & install Synaptron](#4-download--install-synaptron)
5. [First launch & registration (in the app)](#5-first-launch--registration-in-the-app)
6. [Pre‑Install & Install (one‑time prerequisites)](#6-preinstall--install-one-time-prerequisites)
7. [Enable your GPU & connect](#7-enable-your-gpu--connect)
8. [Start Work & verify](#8-start-work--verify)
9. [Post‑install checks](#9-post-install-checks)
10. [(Optional) Auto‑start on login](#10-optional-auto-start-on-login)
11. [Updating (clean reinstall)](#11-updating-clean-reinstall)
12. [Logs & paths](#12-logs--paths)
13. [Troubleshooting (quick fixes)](#13-troubleshooting-quick-fixes)
14. [Support & resources](#14-support--resources)
15. [FAQ (full)](#15-faq-full)


---

## 1) Before you start

**Hardware (minimum)**  
- CPU: 4 cores  
- RAM: 12 GB  
- Disk: 250 GB SSD/NVMe  
- **NVIDIA GPU** with **Compute Capability ≥ 6.1** (GTX 10‑series or newer). See NVIDIA’s list: https://developer.nvidia.com/cuda-gpus

**Windows best practices (uptime & stability)**  
- Disable **Sleep** (Windows 11: *Settings → System → Power & battery → Screen and sleep* → set to **Never**).  
- Use **Balanced** or **High performance** power plan.  
- Install the **latest NVIDIA driver**, then reboot.  
- If using 3rd‑party antivirus/firewall, allow the installer and the app.

> **Dedicated vs. Shared PC**
> - Dedicated: consider pausing Windows Updates during long runs; keep Sleep off; prefer Performance power plan.  
> - Shared: ensure AV/firewall allows Synaptron; keep Sleep off; prefer Performance power plan.

---

## 2) Check if you need an update (Discord)


1) In Discord, type **`/synaptronchecker`**.  
<img width="714" height="145" alt="Skärmavbild 2025-08-22 kl  18 14 09" src="https://github.com/user-attachments/assets/f1bcfd31-e8ef-460f-b210-996a90658d62" />

2) Paste your **full GUID**, then **Submit**.  
<img width="431" height="284" alt="Skärmavbild 2025-08-22 kl  18 14 21" src="https://github.com/user-attachments/assets/8d8d958f-60e5-4a52-8582-386d2d68b8e7" />

3) Read the result. If it says **Update Required**, skip ahead to **[11) Updating (clean reinstall)](#11-updating-clean-reinstall)**.  
<img width="728" height="396" alt="Skärmavbild 2025-08-22 kl  18 15 22" src="https://github.com/user-attachments/assets/aec5c152-80d1-4af4-b258-e811092236f2" />

---

## 3) Register your node & get the GUID

1) https://timpi.com/node/management](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md

---

## 4) Download & install Synaptron

1) **Download**: `synaptron_win_latest.zip` (from Timpi downloads).
2) https://timpi.io/applications/windows/synaptron_win_latest.zip  
3) **Extract** the ZIP (Explorer or WinRAR).
 
<img width="631" height="195" alt="Skärmavbild 2025-08-22 kl  18 27 12" src="https://github.com/user-attachments/assets/257a15ee-58f7-47b6-beb4-b37c941012f5" />

4) Open the folder and **double‑click** `setup_ClickMe.exe`.

<img width="631" height="181" alt="Skärmavbild 2025-08-22 kl  18 27 20" src="https://github.com/user-attachments/assets/b0aa16f1-86c3-4826-8406-8a6c3444577a" />

5) If Windows SmartScreen appears → **More info** → **Run anyway**.  

<img width="444" height="181" alt="Skärmavbild 2025-08-22 kl  18 27 28" src="https://github.com/user-attachments/assets/240e6eb8-1409-43d4-a909-91ee30e75b95" />


<img width="464" height="440" alt="Skärmavbild 2025-08-22 kl  18 27 35" src="https://github.com/user-attachments/assets/e5274b45-8e50-44b1-8ed8-56697ca000e3" />

6) Follow the **Setup wizard** → **Next**.  

<img width="503" height="410" alt="Skärmavbild 2025-08-22 kl  18 27 42" src="https://github.com/user-attachments/assets/5e088291-b18f-47fc-af54-b74140fec430" />

7) Approve the **UAC** prompt.  

<img width="438" height="360" alt="Skärmavbild 2025-08-22 kl  18 27 49" src="https://github.com/user-attachments/assets/bf306fe7-86ca-4b4e-8a5c-c0b9b83e6d0c" />

8) After install, you’ll see **Launch Synaptron** on your desktop.  

<img width="607" height="332" alt="Skärmavbild 2025-08-22 kl  18 27 57" src="https://github.com/user-attachments/assets/888c9190-27ca-4d42-b02e-2b459e886116" />

---

## 5) First launch & registration (in the app)

1) Double‑click **Launch Synaptron**. If you see UAC for the agent, click **Yes**.  

<img width="457" height="343" alt="Skärmavbild 2025-08-22 kl  18 28 03" src="https://github.com/user-attachments/assets/f9d2b140-ba53-4945-8fc2-614b45ec76d0" />

2) In the app, paste your **GUID** and enter a **Friendly Name (≥17 characters)**, then **Complete Registration**.  

<img width="490" height="326" alt="Skärmavbild 2025-08-22 kl  18 28 18" src="https://github.com/user-attachments/assets/225bd471-72a7-4704-ba5a-8c0e3e034706" />

3) You’ll get a **success** confirmation.  

<img width="526" height="319" alt="Skärmavbild 2025-08-22 kl  18 28 24" src="https://github.com/user-attachments/assets/334f2a9d-6fe3-496e-8631-09183b6eedf6" />

---

## 6) Pre‑Install & Install (one‑time prerequisites)

1) Run **Pre‑Install** → wait for **Completed Successfully**.  

<img width="533" height="316" alt="Skärmavbild 2025-08-22 kl  18 28 32" src="https://github.com/user-attachments/assets/e6b46552-2f04-4d7e-849a-bedf0e9a5195" />

<img width="505" height="256" alt="Skärmavbild 2025-08-22 kl  18 28 41" src="https://github.com/user-attachments/assets/787b0d10-3185-4c17-828d-2b92b50076dc" />

2) Run **Install** → wait for **Completed Successfully**.  

<img width="545" height="341" alt="Skärmavbild 2025-08-22 kl  18 28 49" src="https://github.com/user-attachments/assets/ee097a41-a7f5-44bb-8fd5-0e3858947f2c" />

> These two steps fetch prerequisites and can take **~15–20 minutes**. Do not close the app during this phase.

---

## 7) Enable your GPU & connect

1) In **Configure GPU Card(s)**, choose your **GPU** and click **Enable**.  
2) Confirm your GPU shows as **Enabled** and **Timpi Connected** is visible.  

<img width="552" height="283" alt="Skärmavbild 2025-08-22 kl  18 28 56" src="https://github.com/user-attachments/assets/073e3004-187a-44b1-9fb3-d5dabd56452f" />

*If the GPU doesn’t appear: update NVIDIA drivers, reboot, and re‑launch the app.*

---

## 8) Start Work & verify

1) Click **Start Work** → **Register For Work** shows **Success**.  

<img width="641" height="669" alt="Skärmavbild 2025-08-22 kl  18 29 15" src="https://github.com/user-attachments/assets/9b67336d-6e85-4cbe-9369-07459278e57d" />

2) Logs will start to scroll; detections appear between “No object detected” (that’s normal).  

<img width="724" height="563" alt="Skärmavbild 2025-08-22 kl  18 29 22" src="https://github.com/user-attachments/assets/5df5f910-edbd-438a-84ba-94d685c7a4c4" />

3) In Discord, run **`/synaptronchecker`** again to confirm your **running version**, **GPU**, and **status**.

---

## 9) Post‑install checks

- **Task Manager** should show **SynapAgent** and related processes running.  

<img width="725" height="323" alt="Skärmavbild 2025-08-22 kl  18 29 47" src="https://github.com/user-attachments/assets/d6d662af-588c-46c1-bfd1-f3470f08a6f3" />

- The tray may confirm the agent is running in the background.  

<img width="371" height="129" alt="Skärmavbild 2025-08-22 kl  18 29 56" src="https://github.com/user-attachments/assets/cb9cb8b7-3603-49ce-912c-3a5bf9e99334" />

---

## 10) (Optional) Auto‑start on login

1) Press **Win + R**, type `shell:startup`, press **Enter**.  
2) Copy the **Launch Synaptron** shortcut into the **Startup** folder.

---

## 11) Updating (clean reinstall)

If **`/synaptronchecker`** says **Update Required**:

1) Open **Settings → Apps → Installed apps** and **uninstall Synaptron** (remove **Python** too if present).  

<img width="516" height="367" alt="Skärmavbild 2025-08-22 kl  18 30 05" src="https://github.com/user-attachments/assets/2182d34e-531d-46cb-a2f6-d61633ed42cb" />

2) Delete leftovers (show hidden files):  
- `C:\ProgramData\Synaptron`  
- `C:\Users\<You>\AppData\Roaming\Synaptron`  
- *(Optional model cache)* `C:\Users\<You>\.cache\huggingface\hub` **or** `C:\Users\<You>\timpi.cache\huggingface\hub`

3) **Reboot** → re‑download ZIP → **extract** → run **`setup_ClickMe.exe`** → repeat sections **5–8**.  
4) Verify in Discord with **`/synaptronchecker`**.

> Your **GUID stays the same.** No need to generate a new one.

---

## 12) Logs & paths

- **Logs:** `C:\Users\<You>\AppData\Roaming\Synaptron`  
- **GUID & app data:** `C:\ProgramData\Synaptron`  
- *(Optional model cache)* `C:\Users\<You>\.cache\huggingface\hub` or `C:\Users\<You>\timpi.cache\huggingface\hub`

---

## 13) Troubleshooting (quick fixes)

**Installer blocked by Windows**  
- Extract the ZIP first. On SmartScreen choose **More info → Run anyway**. Approve UAC.

**Registration failed**  
- Check **GUID** is correct and **Friendly Name ≥ 17 chars**. Try again.

**No GPU in drop‑down / “No compatible GPU found”**  
- Install latest **NVIDIA drivers**, **reboot**, re‑launch.  
- Ensure your card supports **Compute Capability ≥ 6.1**.  
- Make sure your monitor cable is plugged into the **GPU** (not motherboard iGPU).

**“Timpi Connected: No”**  
- Internet down / firewall blocked. Allow the app in Windows Firewall/AV and retry.

**High VRAM usage / Out‑of‑memory**  
- Close other GPU apps (games, miners, renderers). Restart Synaptron.

**“No object detected” spam**  
- Normal between detections. Let it run.

**After update, checker still shows old version**  
- You likely skipped cleanup. Do all steps in **[11) Updating]** and verify again.

**Start Work button doesn’t appear**  
- Make sure **GPU is Enabled** and **registration succeeded**.

---

## 14) Support & resources

- **Discord support:** open a ticket in **#support**  
  - (Direct channel link for members) https://discord.com/channels/946982023245992006/1179427377844068493
- **Video walkthrough (Windows 10/11):** https://www.youtube.com/watch?v=_SPVbZuCCPQ  
- **Download (Windows):** `synaptron_win_latest.zip` (from Timpi downloads)

---

## 15) FAQ (full)

### GPU
**Q: If I have multiple GPUs, does VRAM add up, or can I use more than one GPU at once?**  
A: Not currently. Synaptron recognizes a single GPU per node; the NFT‑to‑GPU relationship is **1:1**.

**Q: Can I run several nodes on one GPU / several GPUs on one machine?**  
A: One node per GPU. To use multiple GPUs on one machine, you’d need virtualization (hypervisor with **GPU passthrough**) **and** one NFT per GPU. Advanced; not officially supported.

**Q: Which GPUs are supported? NVIDIA only?**  
A: **NVIDIA only** for now, with **Compute Capability ≥ 6.1**. See: https://developer.nvidia.com/cuda-gpus

**Q: Does PCIe lane speed matter for GenAI?**  
A: Yes. More lanes / higher gen improves throughput. Recommended **PCIe Gen3 x8 or higher**.

**Q: Can I split VRAM across VMs?**  
A: Not supported natively.

**Q: How are tiers determined?**  
A: VRAM and GPU UUID are reported to TAP and used to place nodes:  
- **Tier 1:** 4–6 GB VRAM  
- **Tier 2:** 8–16 GB VRAM

**Q: Do 8 GB and 16 GB nodes earn the same?**  
A: Tier‑based pools differ; Tier 2 earns **~14.3% more** than Tier 1. Initially equal split within a tier based on availability; later transitions to **performance‑based** (jobs completed).

---

### OS Compatibility
- **Windows 10 & 11:** Supported.  
- **Linux containerization:** Supported on **Ubuntu 22.04**.  
- **HiveOS:** Not officially supported.  
- **VMs:** Works with proper GPU passthrough (advanced; docs later).  
- **WSL:** Not supported.  
- **Ports:** No open ports required.

---

### Networking & Security
- **Port forwarding / UPnP:** Not needed.  
- **Static IP:** Not required.  
- **Bandwidth:** No strict minimum, but **unlimited data** is recommended (datasets download frequently).  
- **Data processed:** Public domain content; system runs isolated with **no open ports**.

---

### Workload & Availability
- **GPU usage:** Expect **high/100%** utilization under load. Ensure adequate power & cooling.  
- **Disconnections / penalties:** TBD; persistent disconnections may be penalized.  
- **Is there always work?** Yes. Collectors continuously expand/refresh the index; Synaptron processes text/images.  
- **Task types:** Start with image recognition; more tasks roll out over time. High‑VRAM tasks will be Tier‑2 only.

---

### Rewards (overview)
- **Pool model:**  
  - Each active **Tier 1** node adds **1,400 NTMPI** to the monthly pool.  
  - Each active **Tier 2** node adds **1,600 NTMPI** to the monthly pool.  
  - Inactive contributions are **redistributed**; Tier 2 targets ~**14.3%** higher than Tier 1 overall.
- **Distribution:**  
  - Phase 1: equal split within a tier among nodes meeting **availability** threshold.  
  - Phase 2: transitions to **performance‑based** (more work → more rewards).  
- **Example:** If 10 T1 and 5 T2 nodes are active:  
  - T1 pool ≈ 18,667 NTMPI → **~1,867** per T1 node  
  - T2 pool ≈ 10,667 NTMPI → **~2,133** per T2 node

> *Note:* Pools/thresholds may evolve; watch announcements for updates.


