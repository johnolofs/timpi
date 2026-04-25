# 🌍 GeoCore on FluxCloud

Run a **GeoCore** node on FluxCloud via the Marketplace. Flux deploys 3 instances and keeps them updated automatically.

> ✅ **Requirements**
> · Registered **GeoCore GUID** ([dashboard](https://timpi.com/node/v2/management))
> · Flux account
> · (Optional) email for alerts

---

## 📑 Table of Contents

1. [Log in to FluxCloud](#1-log-in-to-fluxcloud)
2. [Find Timpi GeoCore in the Marketplace](#2-find-timpi-geocore-in-the-marketplace)
3. [Configure your GeoCore app](#3-configure-your-geocore-app)
4. [Add location & GUID](#4-add-location--guid)
5. [Set deployment locations](#5-set-deployment-locations)
6. [Email alerts](#6-email-alerts)
7. [Sign & register](#7-sign--register)
8. [Pay](#8-pay)
9. [Deployment confirmation](#9-deployment-confirmation)
10. [Verify & manage instances](#10-verify--manage-instances)
11. [Auto-updates & redeploy](#11-auto-updates--redeploy)
12. [Renew / extend subscription](#12-renew--extend-subscription)
13. [Troubleshooting](#13-troubleshooting)

---

## 1. Log in to FluxCloud

Go to [https://cloud.runonflux.com](https://cloud.runonflux.com) and log in with **Google, Apple, Email/Password**, or a **Flux Wallet**.

<img width="2378" alt="login" src="https://github.com/user-attachments/assets/a7981685-a6e7-4e7e-8921-4ace7a816c72" />

## 2. Find Timpi GeoCore in the Marketplace

In the left sidebar: **Marketplace → Applications** → search **Timpi Geocore** → **Install**.

<img width="1243" height="622" alt="marketplace" src="https://github.com/user-attachments/assets/13204e6c-bb20-4833-bab3-06735b3c5415" />

## 3. Configure your GeoCore app

<img width="908" height="650" alt="configure" src="https://github.com/user-attachments/assets/911f37a6-9d37-4485-9966-b78f5d4de47f" />

1. Hardware is locked by Timpi: **4 vCPU · 8000 MB RAM · 3 GB storage**.
2. Choose **Subscription Duration** (1 / 3 / 6 / 12 months).
3. Confirm **Instance Count** (Flux deploys 3 by default).
4. Tick **Accept Terms of Use**.

Scroll down → **Next →**.

<img width="932" height="648" alt="config 2" src="https://github.com/user-attachments/assets/d0d68203-746c-4397-a8f7-4e9cf56e4428" />

## 4. Add location & GUID

<img width="948" height="655" alt="location and guid" src="https://github.com/user-attachments/assets/af204712-d8d1-4bb8-bdf6-be4e02974266" />

* **Location** — auto-selected by Flux
* **GeoCore GUID** — paste from your Timpi dashboard

**Next →**.

## 5. Set deployment locations

<img width="919" height="645" alt="locations" src="https://github.com/user-attachments/assets/715ef3ee-f881-4b1b-8871-a2b50af850f3" />

Recommended: **Allowed Locations: Global (All Continents)** for best availability. Skip Forbidden Locations unless you have a reason.

**Next →**.

## 6. Email alerts

<img width="911" height="652" alt="email" src="https://github.com/user-attachments/assets/21ae054b-7028-4e20-92a6-4367ae5b467f" />

Flux emails you when:

* Deployment completes
* Your primary server / instance migrates
* The subscription is close to expiry

**Next →**.

## 7. Sign & register

<img width="917" height="646" alt="sign" src="https://github.com/user-attachments/assets/54b5de58-ad5b-49b6-b8a9-da1f8ff48ae2" />

Wait for **✔️ Signing and Registration Complete** — you'll be redirected to payment.

## 8. Pay

<img width="930" height="657" alt="payment" src="https://github.com/user-attachments/assets/0de2a914-752e-488a-8fd9-79202ad4e3f1" />

| Method | Notes |
| --- | --- |
| Stripe | Credit card |
| PayPal | Standard pricing |
| ZelCore (FLUX) | **5% discount** |
| SSP (FLUX) | **5% discount** |

If paying in FLUX:

1. Copy the **Payment Address**
2. Copy the **Payment Message** (must be included)
3. Click **Open ZelCore** and complete the transaction

After payment confirms, **Next →**.

## 9. Deployment confirmation

Deployment can take up to **45 minutes**. Flux automatically starts **3 instances** across the network.

## 10. Verify & manage instances

1. **Applications → Management → My Active Apps** → **Manage**.
2. **Running Instances** — click **App** next to an IP to open the GeoCore UI.

> 💡 IPs may change on redeploy. Always click the **App** button to open the currently active instance.

For high-level GeoCore management, use [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

## 11. Auto-updates & redeploy

Watchtower auto-updates your containers. Force an update with **Soft Redeploy** at [home.runonflux.io](https://home.runonflux.io) → **Apps → Global Apps → My Apps → Manage → Global Control → Redeploy**.

## 12. Renew / extend subscription

[home.runonflux.com](https://home.runonflux.com) → **Management → My Active Apps → Manage → Update/Renew**:

* **Extend Subscription** = ON
* **Update Specifications** = OFF
* Choose duration → accept ToS → **Compute Update Message** → **Sign** → **Update Application** → pay.

---

## 13. Troubleshooting

| Symptom | Fix |
| --- | --- |
| GUID rejected | Make sure the GUID is exactly the one from your Timpi dashboard (no extra spaces / hidden characters) |
| Can't open app | Use the current **App** button under Running Instances — IPs may have changed |
| Update delay | Wait for Watchtower or trigger a **Soft Redeploy** |

---

## 🆘 Support

* 💬 [Timpi Discord](https://discord.com/channels/946982023245992006) — GUID, node, reward questions
* 🧾 [Flux Support](https://runonflux.zendesk.com) — deployment, billing, infrastructure
