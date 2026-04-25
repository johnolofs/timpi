# 🔄 Collector on Flux

Two paths:

* **A) FluxCloud** — recommended. Subscribe in the Marketplace, Flux runs your Collector across **3 instances** automatically.
* **B) FluxEdge** — add a Collector to a machine you already rent (e.g. alongside a Synaptron).

> ✅ **Requirements**
> · Timpi wallet that holds a **Collector NFT**
> · Flux account (FluxCloud or FluxEdge)

---

## 📑 Table of Contents

* [A. FluxCloud (recommended)](#a-fluxcloud-recommended)
  * [1. Install the TimpiCollector app](#1-install-the-timpicollector-app)
  * [2. App configuration](#2-app-configuration)
  * [3. Sign & register](#3-sign--register)
  * [4. Configure your Collector](#4-configure-your-collector)
  * [5. Auto-updates & redeploy](#5-auto-updates--redeploy)
  * [6. Renew / extend subscription](#6-renew--extend-subscription)
* [B. FluxEdge — add a Collector to an existing machine](#b-fluxedge--add-a-collector-to-an-existing-machine)
* [Troubleshooting](#troubleshooting)
* [Support](#support)

---

## A. FluxCloud (recommended)

### 1. Install the TimpiCollector app

1. Visit [home.runonflux.com](https://home.runonflux.com).
2. Sign in / create an account with **Apple, Google, Email**, or a **Web3 wallet**.

   ![](https://github.com/user-attachments/assets/27a010ce-74a9-473b-9080-5125ed2991d5)

3. Go to **Applications → Marketplace**, search **TimpiCollector**, and open it.

   ![](https://github.com/user-attachments/assets/025047db-a6ac-4d7b-9830-2baeae5b2480)

### 2. App configuration

1. (Optional) enter your **email** for alerts.
2. Choose **subscription period**.
3. Accept the **Terms of Service**.
4. Click **Start Launching Marketplace Application**.

   ![](https://github.com/user-attachments/assets/f8a48e8b-905e-4b1a-a964-8b188eaedcfd)

> 📌 **Locked hardware:** 2 vCPU · 2000 MB RAM · 1 GB storage. Leave instance count at the default of **3** — extra instances bring no benefit for the Collector.

### 3. Sign & register

1. Click **Next** on the confirmation screen.

   ![](https://github.com/user-attachments/assets/7deace26-5339-499d-aaa3-8ffa9083d26b)

2. **Sign the message** (wallet icon for Web3, or Flux SSO/Email for email login → **Next**).

   ![](https://github.com/user-attachments/assets/70011e19-9687-46ca-b064-fb11c7c60f85)

3. Confirm **Total Price + VAT** → **Register** → wait for ✅ **DONE**.

   ![](https://github.com/user-attachments/assets/6778f235-b45c-4ec4-8551-3c09ff2dbe23)

4. Pick a payment method: **Stripe**, **PayPal**, or **Flux (-5%)**.

   ![](https://github.com/user-attachments/assets/1e9c0ec0-8a80-44ee-9bb1-fb6efe0e4ebd)

5. Click **Done → Yes**. Deployment time: **10–30 minutes**.

### 4. Configure your Collector

1. **Applications → Management → My Active Apps** → **Manage**.

   ![](https://github.com/user-attachments/assets/f5271e09-8ea4-4f85-bd77-06b96349477e)

2. FluxCloud runs **3 instances** per deploy → you can use up to **3 Collectors**.
3. **Running Instances** → click **App** next to any IP.

   ![](https://github.com/user-attachments/assets/65e8943a-31b0-4832-b808-2548eeee975b)

4. In the app:

   * ⚙️ **Settings** → enter your **Timpi Wallet Address** (must hold the Collector NFT)
   * Set **Workers** (1–5) → **Save**

     ![](https://github.com/user-attachments/assets/91e3f515-7e75-47ba-a2d1-c72e510469ac)

5. Open the **Collector** tab → ✅ indexing starts.

   ![](https://github.com/user-attachments/assets/44ca58a4-71af-4579-8e1d-b6d455ab7ef5)

> ℹ️ FluxCloud may rotate IPs on redeploy. If that happens, repeat steps 3–4 for the new IP.

### 5. Auto-updates & redeploy

FluxCloud uses **Watchtower** to auto-update your containers (rollout up to ~10 hours globally). To force an update:

1. [home.runonflux.io](https://home.runonflux.io)
2. **Apps → Global Apps → My Apps**
3. **Manage → Manage App → Global Control → Redeploy**

   * **Soft Redeploy** — keeps data
   * **Hard Redeploy** — wipes container data

### 6. Renew / extend subscription

1. [home.runonflux.com](https://home.runonflux.com)
2. **Applications → Management → My Active Apps** → **Manage**
3. **Update/Renew** tab:

   * Toggle **Extend Subscription** = ON
   * Keep **Update Specifications** = OFF
   * Choose duration → accept ToS → **Compute Update Message**

     ![](https://github.com/user-attachments/assets/dd1c6010-6b0a-4bf5-9b75-4dc539665386)

4. **Sign** → **Update Application**

   ![](https://github.com/user-attachments/assets/74fba599-0207-4d7d-a52b-1fc2f9444351)

5. Pay and finish.

   ![](https://github.com/user-attachments/assets/97613910-a2ba-47a4-8777-3fa7bb5fff21)

---

## B. FluxEdge — add a Collector to an existing machine

If you already run a **Synaptron** (or any machine) on FluxEdge, you can add a Collector to it:

1. On your machine row: `⋮` → **+ New Deployment**
2. **Explore All Templates** → search **Timpi Collector**
3. (Optional) read README → **Builder / Continue**
4. Adjust resources → **Deploy App**
5. Wait for **Running** → open **App URL**
6. In the app:

   * ⚙️ **Settings → Wallet Address** (NFT required)
   * Set **Workers** (1–5) → **Save**

7. **Collector** tab → ✅ indexing starts

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| "Wallet not valid / no NFT" | Confirm the wallet address you entered holds a **Collector NFT** |
| No work after redeploy | Open the current **App URL** again and re-save **Settings** |
| Slow updates | Wait for Watchtower, or trigger a **Soft Redeploy** |

---

## Support

* 💬 [Timpi Discord](https://discord.com/channels/946982023245992006) — community help
* 🧾 [Flux Help Center](https://help.runonflux.io) · [Support portal](https://support.runonflux.io)
