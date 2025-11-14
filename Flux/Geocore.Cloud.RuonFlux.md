# 📘 **Timpi GeoCore — Deployment Guide (FluxCloud, 2025 Edition)**

**Using the new FluxCloud UI at [https://cloud.runonflux.com](https://cloud.runonflux.com)**

Run your **Timpi GeoCore** node on FluxCloud directly from the Marketplace.
This guide walks you through configuration → signing → payment → deployment → verification.

> **Requirements**
>
> * A **registered GeoCore GUID**
> * A FluxCloud account
> * (Optional) Email for deployment alerts

---

# 📑 **Table of Contents**

1. [Login to FluxCloud](#1-login-to-fluxcloud)
2. [Find Timpi GeoCore in Marketplace](#2-find-timpi-geocore-in-marketplace)
3. [Step 1 — Config](#3-step-1--config)
4. [Step 2 — Params (Location + GUID)](#4-step-2--params-location--guid)
5. [Step 3 — Deployment Locations](#5-step-3--deployment-locations)
6. [Step 4 — Alerts](#6-step-4--alerts)
7. [Step 5 — Signing](#7-step-5--signing)
8. [Step 6 — Payment](#8-step-6--payment)
9. [Step 7 — Deployment](#9-step-7--deployment)
10. [Verify Running Instances](#10-verify-running-instances)
11. [Updates & Redeploy](#11-updates--redeploy)
12. [Renew Subscription](#12-renew-subscription)
13. [Troubleshooting](#troubleshooting)
14. [Support](#support)

---

# 1) **Login to FluxCloud**

Go to:

👉 **[https://cloud.runonflux.com](https://cloud.runonflux.com)**

You will see the new login screen:

<img width="2378" height="1352" alt="Screenshot 2025-11-14 194303" src="https://github.com/user-attachments/assets/a7981685-a6e7-4e7e-8921-4ace7a816c72" />


Login using:

* Google
* Apple
* Email/Password
* Flux Wallet

---

# 2) **Find Timpi GeoCore in Marketplace**

Navigate:
**Sidebar → Marketplace → Applications**

Search for **Timpi Geocore**.

<img width="2529" height="838" alt="Screenshot 2025-11-14 193445" src="https://github.com/user-attachments/assets/390bca25-aa8d-41e3-afae-97f0845707aa" />


Click **Install**.

---

# 3) **Step 1 — Config**

The configuration window opens with hardware requirements and subscription selection.

<img width="1293" height="900" alt="Screenshot 2025-11-14 193521" src="https://github.com/user-attachments/assets/be50dc81-88c9-4c10-9c10-ad593dfaf3ed" />


### Here you must:

* Select **Subscription Duration** (1 / 3 / 6 / 12 months)
* Choose **Number of Instances** (Flux usually runs 3)
* Accept **Terms of Use**
* Click **Next →**

<img width="1353" height="1151" alt="Screenshot 2025-11-14 193559" src="https://github.com/user-attachments/assets/08a408ed-02f6-4df5-9485-bfe6d7d76d6c" />


> 💡 **Pricing** automatically shows USD + Flux cost (Flux has -5% discount).

---

# 4) **Step 2 — Params (Location + GUID)**

Here you enter your **GeoCore GUID** and confirm your **country selection**.

<img width="1331" height="988" alt="Screenshot 2025-11-14 193620" src="https://github.com/user-attachments/assets/73c2bea3-0e14-4517-a6e3-11b25cb7722a" />


### Requirements:

* **Location** (auto-filled by Flux)
* **GUID** (your Timpi GeoCore registered GUID)

Click **Next →**

---

# 5) **Step 3 — Deployment Locations**

Configure where Flux is allowed to run your GeoCore nodes.

<img width="1332" height="1023" alt="Screenshot 2025-11-14 193735" src="https://github.com/user-attachments/assets/ad795efc-5703-4589-a6e6-ff0ff20d716c" />



Options:

### **Allowed Locations**

* Default: **Global (All Continents)**
  → Best availability

### **Forbidden Locations**

* Leave as **None** unless you want to block specific countries.

Click **Next →**

---

# 6) **Step 4 — Alerts**

Enter your **notification email**.

<img width="1311" height="984" alt="Screenshot 2025-11-14 193807" src="https://github.com/user-attachments/assets/99910263-a5d6-40df-b944-1d5f3717f0ca" />



You will receive:

* Deployment complete notifications
* Instance migration alerts
* Expiration reminders

Click **Next →**

---

# 7) **Step 5 — Signing**

Your application is now ready for secure signing & registration.

<img width="1406" height="1087" alt="Screenshot 2025-11-14 193837" src="https://github.com/user-attachments/assets/ab71c2a5-a2c6-4591-a5f5-424f9cf45ea5" />


Click **Next →**
Flux will automatically:

* Perform Secure Signing
* Register the app on the Flux network

When complete you will see:

**✔️ Signing and Registration Complete**

You will be redirected automatically.

---

# 8) **Step 6 — Payment**

Choose your payment method.

<img width="1334" height="1180" alt="Screenshot 2025-11-14 193907" src="https://github.com/user-attachments/assets/e3c8ad0c-8d83-44f5-83c0-996ad0721cc7" />


### Payment Options:

* **Stripe (Credit Card)**
* **PayPal**
* **Flux (ZelCore)** → **5% Discount**
* **SSP (Self Sovereign Pay)** → **5% Discount**

If Flux is selected, you will see:

* Payment Address
* Payment Message
* A one-click **Open ZelCore** button

After payment, click **Next →**.

---

# 9) **Step 7 — Deployment**

You will now see:

**🚀 Launching Application**
**✔️ Signing and Registration Complete**

![Deployment](attachment:/mnt/data/Screenshot%202025-11-14%20193759.png)

Flux will deploy **3 instances** across the network.

Deployment time: **~10–30 minutes**.

---

# 10) **Verify Running Instances**

Go to:

**Applications → Management → My Active Apps → Manage**

![Manage](attachment:/mnt/data/Screenshot%202025-11-14%20193445.png)

Your GeoCore will show:

* **3 Running Instances**
* A button **App** → opens the Web UI for each instance

![Running Instances](attachment:/mnt/data/Screenshot%202025-11-14%20193445.png)

> 💡 **IP addresses may rotate** on redeploy.
> Always use the **App** button to open the current endpoint.

---

# 11) **Updates & Redeploy**

Flux automatically updates GeoCore using **Watchtower**.

### Update times:

* Global rollout: **up to 10 hours**
* Manual update: **Soft Redeploy**

To force-update:

1. Go to **My Apps**
2. **Manage → Global Control**
3. Choose:

   * **Soft Redeploy** → keeps data
   * **Hard Redeploy** → wipes data

---

# 12) **Renew Subscription**

1. Go to **My Active Apps → Manage**
2. Choose **Update / Renew**
3. Select:

   * **Extend Subscription = ON**
   * **Update Specifications = OFF**
4. Choose duration
5. **Compute Update Message**
6. Sign → Pay → Done

---

# 🛠 Troubleshooting

### ❌ GUID rejected

Make sure the GUID matches **exactly** the one registered in Timpi Dashboard.

### ❌ App won’t open

Use the **App** button under *Running Instances*.
Flux may rotate your instance IP.

### ⏳ Updates delayed

Wait for Watchtower or do a **Soft Redeploy**.

### ❌ Payment not detected

* For Flux payments, ensure the **Message** is included.
* For Stripe/PayPal, reload the payment page after a minute.

---

# 🤝 Support

### **Timpi Community**

💬 Discord: [https://discord.gg/timpi](https://discord.gg/timpi)

### **Flux Support**

🔧 [https://runonflux.zendesk.com](https://runonflux.zendesk.com)
For issues with deployment, billing, or Cloud UI.

---
