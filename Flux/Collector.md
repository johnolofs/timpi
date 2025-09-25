# 📘 Timpi Collector — Deployment Guide (FluxCloud & FluxEdge)

Run a **Collector** node the easy way on FluxCloud (recommended) or add Collectors to any FluxEdge machine (e.g., alongside a Synaptron).

> ✅ Requirements  
> • Timpi wallet address that holds a valid **Collector NFT**  
> • Flux account (FluxCloud or FluxEdge)

---

## Table of Contents
- [A. FluxCloud (Recommended)](#a-fluxcloud-recommended)
  - [1) Install the TimpiCollector App](#1-install-the-timpicollector-app)
  - [2) App Configuration](#2-app-configuration)
  - [3) Sign & Register](#3-sign--register)
  - [4) Configure Your Collector](#4-configure-your-collector)
  - [5) Auto-Updates & Redeploy](#5-auto-updates--redeploy)
  - [6) Renew / Extend Subscription](#6-renew--extend-subscription)
- [B. FluxEdge (Optional)](#b-fluxedge-optional)
  - [Add a Collector on the same machine](#add-a-collector-on-the-same-machine)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## A. FluxCloud (Recommended)

### 1) Install the TimpiCollector App
1. Visit **home.runonflux.com**  
2. **Sign in / Create account** with Apple, Google, Email, or a Web3 wallet  
   ![](https://github.com/user-attachments/assets/27a010ce-74a9-473b-9080-5125ed2991d5)
3. Go to **Applications → Marketplace**  
   Search **TimpiCollector** and open it.  
   ![](https://github.com/user-attachments/assets/025047db-a6ac-4d7b-9830-2baeae5b2480)

### 2) App Configuration
1. Enter your **email** (optional)  
2. Select **subscription period**  
3. Accept **Terms of Service**  
4. Click **Start Launching Marketplace Application**  
   ![](https://github.com/user-attachments/assets/f8a48e8b-905e-4b1a-a964-8b188eaedcfd)

### 3) Sign & Register
1. Click **Next** on the confirmation screen  
   ![](https://github.com/user-attachments/assets/7deace26-5339-499d-aaa3-8ffa9083d26b)
2. **Sign the message** (Wallet icon for Web3, or Flux SSO/Email for email login → Next)  
   ![](https://github.com/user-attachments/assets/70011e19-9687-46ca-b064-fb11c7c60f85)
3. Confirm **Total Price + VAT** → **Register** → wait for ✅ **DONE**  
   ![](https://github.com/user-attachments/assets/6778f235-b45c-4ec4-8551-3c09ff2dbe23)
4. Choose payment: **Stripe**, **PayPal**, or **Flux (-5% discount)**  
   ![](https://github.com/user-attachments/assets/1e9c0ec0-8a80-44ee-9bb1-fb6efe0e4ebd)
5. Click **Done**, then **Yes**.  
   ⏱️ Deployment time: **10–30 minutes**.

### 4) Configure Your Collector
1. Go to **Applications → Management → My Active Apps** → **Manage**  
   ![](https://github.com/user-attachments/assets/f5271e09-8ea4-4f85-bd77-06b96349477e)
2. FluxCloud runs **3 instances** per deploy → you can use **up to 3 Collectors**.  
3. Open **Running Instances** → click the **App** button next to any IP  
   ![](https://github.com/user-attachments/assets/65e8943a-31b0-4832-b808-2548eeee975b)
4. In the app UI:
   - ⚙️ **Settings** → enter **Timpi Wallet Address** (must hold NFT)  
   - Set **Workers** (1–5)  
   - Click **Save**  
     ![](https://github.com/user-attachments/assets/91e3f515-7e75-47ba-a2d1-c72e510469ac)
5. Go to **Collector** tab → ✅ indexing starts  
   ![](https://github.com/user-attachments/assets/44ca58a4-71af-4579-8e1d-b6d455ab7ef5)

> ℹ️ **Note:** FluxCloud may rotate IPs on redeploy. If that happens, repeat step 3–4 for the new IP.

### 5) Auto-Updates & Redeploy
FluxCloud uses **Watchtower** to auto-update your running container:
- Detects new images
- Restarts with the updated version automatically  
⏳ Global rollout can take **up to ~10 hours**.

If you want faster updates:
1. Log in to **home.runonflux.io**  
2. **Apps → Global Apps → My Apps**  
3. Your app → **Manage → Manage App**  
4. **Global Control** → **Redeploy**:
   - **Soft Redeploy** (keeps data)  
   - **Hard Redeploy** (wipes container data)

### 6) Renew / Extend Subscription
1. Log in to **home.runonflux.com**  
2. **Applications → Management → My Active Apps** → **Manage**  
3. **Update/Renew** tab:
   - Toggle **Extend Subscription** = ON  
   - Keep **Update Specifications** = OFF  
   - Choose duration → accept ToS → **Compute Update Message**  
     ![](https://github.com/user-attachments/assets/dd1c6010-6b0a-4bf5-9b75-4dc539665386)
4. **Sign** and **Update Application**  
   ![](https://github.com/user-attachments/assets/74fba599-0207-4d7d-a52b-1fc2f9444351)
5. Choose payment and finish  
   ![](https://github.com/user-attachments/assets/97613910-a2ba-47a4-8777-3fa7bb5fff21)

---

## B. FluxEdge (Optional)

### Add a Collector on the same machine
If you already run a **Synaptron** (or any machine) on FluxEdge, you can add **Timpi Collector**:

1. On your machine row → `⋮` → **+ New Deployment**  
2. **Explore All Templates** → search **Timpi Collector**  
3. (Optional) Read README → **Builder / Continue**  
4. Adjust resources → **Deploy App**  
5. Wait for **Running** → open **App URL**  
6. In the app:
   - ⚙️ **Settings** → **Wallet Address** (NFT required)  
   - Set **Workers** (1–5) → **Save**  
7. Open **Collector** tab → ✅ indexing starts

---

## Troubleshooting
- **“Wallet not valid / no NFT”** → Ensure the wallet you entered holds a **Collector NFT**.  
- **No work after redeploy** → Open current **App URL** again and re-save **Settings**.  
- **Slow updates** → Wait for Watchtower, or trigger a **Soft Redeploy**.

---

## Support
- 💬 **Timpi Discord:** Ask in the community channels  
- 🧾 **Flux Support:** Use their Help Center & Portal
