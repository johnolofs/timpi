# 📘 Timpi Synaptron — Deployment Guide (FluxEdge • GPU)

Deploy the **Synaptron** (AI/GPU) node on **FluxEdge**, then optionally add **Collector** nodes on the same machine.

> ✅ Requirements  
> • FluxEdge account and credit  
> • GPU machine (per template suggestions)  
> • `GUID` + a descriptive `NAME` (≥ 17 chars)

---

## Table of Contents
- [A. Deploy Synaptron on FluxEdge](#a-deploy-synaptron-on-fluxedge)
  - [1) Sign In & Fund Account](#1-sign-in--fund-account)
  - [2) Choose Synaptron Template](#2-choose-synaptron-template)
  - [3) Set Environment Variables](#3-set-environment-variables)
  - [4) Select Resources & Rent Machine](#4-select-resources--rent-machine)
  - [5) Monitor, Logs & Shell](#5-monitor-logs--shell)
- [B. (Optional) Add Collector(s) on Same Machine](#b-optional-add-collectors-on-same-machine)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## A. Deploy Synaptron on FluxEdge

### 1) Sign In & Fund Account
1. Go to **https://console.fluxedge.ai** → sign in / sign up  
   ![](https://github.com/user-attachments/assets/c48a6647-940d-4b32-b284-bccc24733bdd)
2. Add funds in **Account Overview**:
   - 💳 Stripe / Card
   - 🅿️ PayPal
   - 🔷 Flux (+5% bonus)  
     ![](https://github.com/user-attachments/assets/9e4c56b8-8dbe-4380-8339-0be696dc5bf2)

### 2) Choose Synaptron Template
1. **Deploy App → Explore All Templates**  
2. Search **Timpi Synaptron** and open it  
3. (Optional) Read README → **Builder** or **Continue**  
   ![](https://github.com/user-attachments/assets/418249c4-25fa-422f-87ba-2fa63c7a61ea)

### 3) Set Environment Variables
Add the required variables (exact names as in the template):
- `NAME` — **≥ 17 characters** (e.g., `Synaptron-EU-GPU-Rig-A01`)  
- `GUID` — your registered Synaptron GUID  
  - Get your GUID here: **https://timpi.com/node/register**  
  - Linux how-to: **https://github.com/Timpi-official/Nodes/blob/main/Synaptron/Tutorial/SynaptronLinux.md**

### 4) Select Resources & Rent Machine
1. Adjust **GPU / vCPU / RAM / Disk** as needed or keep defaults  
   ![](https://github.com/user-attachments/assets/6011c5b7-ba7b-4421-8a45-c31219680c26)
2. Click **Rent Machine** and filter by **GPU / RAM / Location**  
   ![](https://github.com/user-attachments/assets/07be5908-f10b-40a8-b7a0-b5227a3fb11e)
3. Pick a machine → **Rent** → confirm  
   ![](https://github.com/user-attachments/assets/e7541468-b19a-4731-9d96-1a64f8e03ca8)

### 5) Monitor, Logs & Shell
After deployment, the Synaptron Dashboard shows:
- **App URL**, runtime, cost
- **Logs**, **Shell**, **Monitoring**  
  ![](https://github.com/user-attachments/assets/59896e32-5d17-47ce-b345-bcff562cbe97)

> Tip: Keep the NAME/region consistent across your fleet (helps ops & support).

---

## B. (Optional) Add Collector(s) on Same Machine
1. On the **same machine row** → `⋮` → **+ New Deployment**  
2. **Explore All Templates** → search **Timpi Collector**  
3. (Optional) Read README → **Builder / Continue**  
4. Adjust minimal resources → **Deploy App**  
5. Once **Running** → open **App URL** → ⚙️ **Settings**:  
   - Enter **Timpi Wallet Address** (must hold **Collector NFT**)  
   - Set **Workers** (1–5) → **Save**  
6. **Collector** tab → ✅ indexing starts

---

## Troubleshooting
- **NAME too short** → use at least **17 characters** (enforced by template).  
- **GUID invalid** → verify the exact registered GUID.  
- **GPU not available** → change region/filters or wait for capacity.  
- **Performance tuning** → scale GPU/RAM up via redeploy.

---

## Support
- 💬 **Timpi Discord** — community help and node channels  
- 🧾 **FluxEdge Support** — machine/rental issues
