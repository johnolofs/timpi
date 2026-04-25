# 🧬 Synaptron on FluxEdge (GPU)

Deploy a **Synaptron** (AI / GPU) node on **FluxEdge** by renting a GPU machine, then optionally add Collector nodes to the same machine.

> [!NOTE]
> **Requirements:** FluxEdge account with credit, a GPU machine (per template suggestions), Synaptron `GUID`, and a descriptive `NAME` (≥ 17 characters).

---

## 📑 Table of Contents

* [A. Deploy Synaptron on FluxEdge](#a-deploy-synaptron-on-fluxedge)
  * [1. Sign in & fund account](#1-sign-in--fund-account)
  * [2. Choose Synaptron template](#2-choose-synaptron-template)
  * [3. Set environment variables](#3-set-environment-variables)
  * [4. Select resources & rent](#4-select-resources--rent)
  * [5. Monitor, logs & shell](#5-monitor-logs--shell)
* [B. (Optional) Add Collector(s) on the same machine](#b-optional-add-collectors-on-the-same-machine)
* [Troubleshooting](#troubleshooting)
* [Support](#support)

---

## A. Deploy Synaptron on FluxEdge

### 1. Sign in & fund account

1. Go to [https://console.fluxedge.ai](https://console.fluxedge.ai) → sign in / sign up.

   ![](https://github.com/user-attachments/assets/c48a6647-940d-4b32-b284-bccc24733bdd)

2. Add funds in **Account Overview**:

   * Stripe / Card
   * PayPal
   * Flux (**+5% bonus**)

   ![](https://github.com/user-attachments/assets/9e4c56b8-8dbe-4380-8339-0be696dc5bf2)

### 2. Choose Synaptron template

1. **Deploy App → Explore All Templates**.
2. Search **Timpi Synaptron** and open it.
3. (Optional) read README → **Builder / Continue**.

   ![](https://github.com/user-attachments/assets/418249c4-25fa-422f-87ba-2fa63c7a61ea)

### 3. Set environment variables

Add the required variables (exact names per template):

| Variable | Value |
| --- | --- |
| `NAME` | **≥ 17 characters** (e.g. `Synaptron-EU-GPU-Rig-A01`) |
| `GUID` | Your registered Synaptron GUID — get it at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management) |

For Linux setup tips outside Flux see [../Synaptron/linux.md](../Synaptron/linux.md).

### 4. Select resources & rent

1. Adjust **GPU / vCPU / RAM / Disk** (or keep defaults).

   ![](https://github.com/user-attachments/assets/6011c5b7-ba7b-4421-8a45-c31219680c26)

2. Click **Rent Machine** and filter by **GPU / RAM / location**.

   ![](https://github.com/user-attachments/assets/07be5908-f10b-40a8-b7a0-b5227a3fb11e)

3. Pick a machine → **Rent** → confirm.

   ![](https://github.com/user-attachments/assets/e7541468-b19a-4731-9d96-1a64f8e03ca8)

### 5. Monitor, logs & shell

After deployment, your Synaptron Dashboard shows:

* **App URL**, runtime, cost
* **Logs**, **Shell**, **Monitoring**

  ![](https://github.com/user-attachments/assets/59896e32-5d17-47ce-b345-bcff562cbe97)

> [!TIP]
> Keep NAME and region consistent across your fleet — easier to triage with support.

---

## B. (Optional) Add Collector(s) on the same machine

1. On the **same machine row**: `⋮` → **+ New Deployment**.
2. **Explore All Templates** → search **Timpi Collector**.
3. (Optional) read README → **Builder / Continue**.
4. Adjust minimal resources → **Deploy App**.
5. Once **Running** → open **App URL**:

   * Open **Settings → Wallet Address** (must hold a **Collector NFT**)
   * Set **Workers** (1–5) → **Save**

6. Open the **Collector** tab — indexing starts.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `NAME` too short | Use **≥ 17 characters** (template enforces this) |
| `GUID` invalid | Verify the exact registered GUID from the Timpi dashboard |
| GPU not available | Change region/filters or wait for capacity |
| Performance tuning | Scale GPU / RAM up by redeploying with new specs |

---

## Support

* [Timpi Discord — #synaptron-support](https://discord.com/channels/946982023245992006)
* [FluxEdge Support](https://support.runonflux.io) — machine / rental issues
