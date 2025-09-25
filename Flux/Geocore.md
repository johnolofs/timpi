# 📘 Timpi GeoCore — Deployment Guide (FluxCloud)

Run a **GeoCore** node on FluxCloud via the Marketplace. You’ll need your **registered GUID**.

> ✅ Requirements  
> • Registered **GeoCore GUID**  
> • Flux account (FluxCloud)  
> • (Optional) Email for app notifications

---

## Table of Contents
- [1) Install TimpiGeoCore](#1-install-timpigeocore)
- [2) App Configuration](#2-app-configuration)
- [3) Sign & Register](#3-sign--register)
- [4) Verify & Manage Instances](#4-verify--manage-instances)
- [5) Auto-Updates & Redeploy](#5-auto-updates--redeploy)
- [6) Renew / Extend Subscription](#6-renew--extend-subscription)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

---

## 1) Install TimpiGeoCore
1. Visit **home.runonflux.com**  
2. **Sign in / Create account** with Apple, Google, Email, or Web3  
   ![](https://github.com/user-attachments/assets/27a010ce-74a9-473b-9080-5125ed2991d5)  
3. Go to **Applications → Marketplace**  
   Search **TimpiGeoCore** and open it.  
   ![](https://github.com/user-attachments/assets/025047db-a6ac-4d7b-9830-2baeae5b2480)

## 2) App Configuration
1. Enter **email** (optional)  
2. Choose **subscription period**  
3. Enter your **registered GUID**  
4. Accept **Terms**  
5. **Start Launching Marketplace Application**  
<img width="1435" height="805" alt="Skärmavbild 2025-08-13 kl  13 32 51" src="https://github.com/user-attachments/assets/996585d1-2fd0-4be4-bf83-8f3a3432cf11" />

## 3) Sign & Register
1. Click **Next** on confirmation  
   ![](https://github.com/user-attachments/assets/7deace26-5339-499d-aaa3-8ffa9083d26b)
2. **Sign the message** (Wallet icon or Flux SSO/Email → Next)  
   ![](https://github.com/user-attachments/assets/70011e19-9687-46ca-b064-fb11c7c60f85)
3. Confirm **Total Price + VAT** → **Register** → ✅ **DONE**  
   ![](https://github.com/user-attachments/assets/6778f235-b45c-4ec4-8551-3c09ff2dbe23)
4. Pay with **Stripe / PayPal / Flux (-5%)**  
   ![](https://github.com/user-attachments/assets/1e9c0ec0-8a80-44ee-9bb1-fb6efe0e4ebd)
5. **Done → Yes**. ⏱️ ETA: **10–30 min**.

## 4) Verify & Manage Instances
1. **Applications → Management → My Active Apps** → **Manage**  
   ![](https://github.com/user-attachments/assets/f5271e09-8ea4-4f85-bd77-06b96349477e)
2. FluxCloud usually runs **3 instances**.  
3. **Running Instances** → click **App** next to an IP to open the UI  
   ![](https://github.com/user-attachments/assets/65e8943a-31b0-4832-b808-2548eeee975b)
4. Verify your GeoCore UI is healthy (status/logs as provided in the app).

> ℹ️ **IP rotation** on redeploy can occur. Always use the current **App** button to open the active instance.

## 5) Auto-Updates & Redeploy
- FluxCloud uses **Watchtower** for **automatic container updates**.  
- Global rollout may take **up to ~10 hours**.  
- To force an earlier update, perform a **Soft Redeploy**:
  1. **home.runonflux.io** → **Apps → Global Apps → My Apps**  
  2. **Manage → Manage App → Global Control**  
  3. **Redeploy → Soft** (keeps data) or **Hard** (wipes data)

## 6) Renew / Extend Subscription
1. Log in to **home.runonflux.com**  
2. **Applications → Management → My Active Apps** → **Manage**  
3. **Update/Renew** tab:
   - **Extend Subscription** = ON  
   - **Update Specifications** = OFF  
   - Choose duration → accept ToS → **Compute Update Message**  
     ![](https://github.com/user-attachments/assets/dd1c6010-6b0a-4bf5-9b75-4dc539665386)
4. **Sign** → **Update Application**  
   ![](https://github.com/user-attachments/assets/74fba599-0207-4d7d-a52b-1fc2f9444351)
5. Pay and finish  
   ![](https://github.com/user-attachments/assets/97613910-a2ba-47a4-8777-3fa7bb5fff21)

---

## Troubleshooting
- **GUID rejected** → Make sure you pasted the **exact registered GUID** for your GeoCore.  
- **Can’t open app** → Use the **current App button** under **Running Instances** (IP may have changed).  
- **Update delay** → Wait for Watchtower rollout or do a **Soft Redeploy**.

---

## Support
- 💬 **Timpi Discord** for community help  
- 🧾 **Flux Support** for infrastructure issues
