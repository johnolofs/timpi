# ☁️ Timpi on Flux

Deploy Timpi nodes on the **Flux** decentralized cloud — no hardware required.

Flux offers two products:

| Product | Best for | Available Timpi nodes |
| --- | --- | --- |
| 🟢 **FluxCloud** | Marketplace deployments — pay a subscription, Flux runs your container across 3 servers | Collector, GeoCore |
| 🔵 **FluxEdge** | Rent a specific machine (often with a GPU) and run multiple apps on it | Synaptron, Collector |

---

## 📥 Pick your guide

| Node | Platform | Guide |
| --- | --- | --- |
| 🔄 Collector | FluxCloud or FluxEdge | [collector.md](collector.md) |
| 🌍 GeoCore | FluxCloud | [geocore.md](geocore.md) |
| 🧬 Synaptron (GPU) | FluxEdge | [synaptron.md](synaptron.md) |

---

## ✅ Requirements at a glance

| Node | What you need |
| --- | --- |
| Collector | Timpi wallet that holds a **Collector NFT** + Flux account |
| GeoCore | Registered **GeoCore GUID** + Flux account |
| Synaptron | Registered **Synaptron GUID**, descriptive **NAME ≥ 17 chars**, FluxEdge credit |

Get your GUIDs at 👉 [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

---

## 🔄 Updates on FluxCloud

FluxCloud uses **Watchtower** to auto-update your running containers:

* Detects new images
* Restarts with the updated version automatically
* Global rollout can take up to **~10 hours**

To force an earlier update:

1. Log in to [home.runonflux.io](https://home.runonflux.io)
2. **Apps → Global Apps → My Apps**
3. Your app → **Manage → Manage App → Global Control → Redeploy**

   * **Soft Redeploy** — keeps container data
   * **Hard Redeploy** — wipes container data

📖 [Flux Cloud Watchtower docs](https://help.runonflux.io/docs/the-flux-cloud-watchtower/)

---

## 💳 Payment options

| Method | Notes |
| --- | --- |
| 💳 Stripe (credit card) | Standard pricing |
| 🅿️ PayPal | Standard pricing |
| 🔷 Flux (FLUX token) | **5% discount** on FluxCloud, **5% bonus** on FluxEdge funding |
| 🧾 SSP / ZelCore | FLUX-based, same discount as Flux |

---

## 🆘 Support

| Question type | Where |
| --- | --- |
| GUID / NFT / rewards | [Timpi Discord](https://discord.com/channels/946982023245992006) → `#geocore`, `#synaptron-support`, etc. |
| Flux infrastructure / billing | [Flux Help Center](https://help.runonflux.io/) · [Support portal](https://support.runonflux.io) |
| Marketplace deployment issues | [Flux ticket](https://runonflux.zendesk.com) |
