# 🚀 Timpi Collector — FluxCloud Deployment Guide (2025 Edition)

Deploy and run your **Timpi Collector Node** easily using **FluxCloud** — the decentralized cloud infrastructure powered by Flux.
This guide walks through the full process from selecting the app in the marketplace to confirming deployment via ZelCore.

---

<img width="1024" height="576" alt="TimpiCollector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Step 1 – Find Timpi Collector in Flux Marketplace](#step-1--find-timpi-collector-in-flux-marketplace)
4. [Step 2 – Configure Your App](#step-2--configure-your-app)
5. [Step 3 – Add Your GUID](#step-3--add-your-guid)
6. [Step 4 – Set Deployment Location](#step-4--set-deployment-location)
7. [Step 5 – Email Alerts](#step-5--email-alerts)
8. [Step 6 – Sign and Register](#step-6--sign-and-register)
9. [Step 7 – Payment Options](#step-7--payment-options)
10. [Step 8 – ZelCore Payment Example](#step-8--zelcore-payment-example)
11. [Step 9 – Deployment Confirmation](#step-9--deployment-confirmation)
12. [Step 10 – Verify and Manage Your Collector](#step-10--verify-and-manage-your-collector)
13. [Support](#support)

---

## Overview

Timpi Collectors are decentralized “workers” that crawl and index the web for the **Timpi Search Engine** — privately, securely, and without ads or tracking.
Running one on FluxCloud lets you contribute to the Timpi network without needing your own hardware.

---

## Requirements

✅ A Timpi wallet address with a valid **Collector NFT**  [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

✅ A FluxCloud account — [https://cloud.runonflux.com](https://cloud.runonflux.com)

✅ ZelCore wallet with FLUX for payment (or PayPal / Stripe)

---

## Step 1 – Find Timpi Collector in Flux Marketplace

1. Visit [https://cloud.runonflux.com](https://cloud.runonflux.com)

2. Log in via **FluxID / ZelID / Google / Apple / Email**

3. Go to **Marketplace → Applications**

4. Search for **Timpi Collector**

  <img width="1413" height="621" alt="Skärmavbild 2025-11-17 kl  20 58 04" src="https://github.com/user-attachments/assets/60826442-92fd-4083-a42a-baaca9c6032f" />


5. Click **Install**

---

## Step 2 – Configure Your App

1. Select hardware (locked):

   * **CPU:** 2 cores
   * **Memory:** 2000 MB
   * **Storage:** 1 GB
2. Select **Subscription Duration**
3. Leave this at the default value of 3.
(Changing the number of instances has no benefit for the collector.)
4. Accept Terms of Service

   <img width="924" height="653" alt="Skärmavbild 2025-11-17 kl  20 58 58" src="https://github.com/user-attachments/assets/50073cc4-ad2c-4be5-a220-eedd6bbc94a8" />


---

## Step 3 – Add Your GUID

Paste your **Collector GUID** from the Timpi Dashboard.

Example GUID:

```
f0b8c8c5-d59e-445d-aa68-87d8354b8d81
```

<img width="944" height="648" alt="GUID" src="https://github.com/user-attachments/assets/3dc941d7-fc82-4248-a8b2-816fc4228e93" />

---

## Step 4 – Set Deployment Location

Recommended:

* **Global (All Continents)**

Optional:

* Restrict deployment to specific continents or countries

<img width="937" height="648" alt="Location" src="https://github.com/user-attachments/assets/5d3bb7b0-73ce-4692-be78-297b33f5d0aa" />

---

## Step 5 – Email Alerts

Enter your email for:

* Deployment confirmation
* Node movement notifications
* Subscription expiration alerts

Example: `johnolofs@timpi.com`

<img width="953" height="647" alt="Alerts" src="https://github.com/user-attachments/assets/276dae6a-e696-4aa8-b853-68d3788265df" />

---

## Step 6 – Sign and Register

FluxCloud will now sign and register your application on the network.
Wait for the green checkmark:

**Signing and Registration Complete**

<img width="964" height="643" alt="Sign" src="https://github.com/user-attachments/assets/e9f560e2-fe50-4b9b-8f58-943c479282b0" />

---

## Step 7 – Payment Options

You can pay via:

* **Stripe** (Credit Card)
* **PayPal**
* **ZelCore / SSP** (FLUX — **5% discount**)

<img width="923" height="648" alt="Skärmavbild 2025-11-17 kl  21 00 33" src="https://github.com/user-attachments/assets/6e3e72b5-912c-40f4-bbe5-8473ede5e4ec" />


---

## Step 8 – ZelCore Payment Example

### 1. Open ZelCore

<img width="598" height="315" alt="ZelCore Instructions" src="https://github.com/user-attachments/assets/3b8fd524-ec18-4efb-812d-069d84d42b15" />

### 2. Copy the payment details provided

```
Address: t3NryfAQLGeFs9jEoeqsxmBN2QLRaRKFLUX
Message: bb89b543068ff21ffc890dd21f0c23c2c71dafa590fbe33c43311a8420336db
```

<img width="1352" height="710" alt="ZelCore Send" src="https://github.com/user-attachments/assets/d51d128b-4b34-4513-9c5a-162ccd0886c7" />

### 3. Confirm the amount & message

<img width="1037" height="400" alt="Payment Confirm" src="https://github.com/user-attachments/assets/8a830e05-5ee3-4609-bed6-c76db4f8a69c" />

### 4. Send

<img width="1074" height="520" alt="TX Sent" src="https://github.com/user-attachments/assets/8275bdc9-7181-4176-94a1-7328bc70f671" />

### 5. Wait for confirmation (can take up to 45 minutes)

<img width="980" height="645" alt="Waiting Payment" src="https://github.com/user-attachments/assets/8c55c7af-d744-4519-861a-8551c2bb0d93" />

---

## Step 9 – Deployment Confirmation

Once payment is confirmed, Flux automatically launches all 3 containers.

You will see:

**Payment Confirmed — Application Running**

<img width="1018" height="704" alt="Deployment" src="https://github.com/user-attachments/assets/6c9c13d0-a5f0-44ac-969d-59d923733058" />

---

## Step 10 – Verify and Manage Your Collector

Go to:

**Applications → Management → My Active Apps → Manage**

Check:

* Status: **Running**
* Instances: **3**
* Port: **5015** (legacy but still displayed)
* Container: `timpiltd/timpi-collector:latest`
* GUID matches your Collector NFT

<img width="1219" height="623" alt="Specs 1" src="https://github.com/user-attachments/assets/027f8764-b9a7-4a7b-b993-cc7b67314c4e" />

<img width="1205" height="590" alt="Specs 2" src="https://github.com/user-attachments/assets/dcadaab5-8705-490c-ab38-f286d5d2e0e1" />

To configure or monitor your Collector:

👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

---

## Support

🟦 **Timpi Discord:** [https://discord.gg/timpi](https://discord.gg/timpi)
🟩 **Flux Support:** [https://support.runonflux.io](https://support.runonflux.io)

---
