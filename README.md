# 🧠 Timpi Nodes — Community Documentation

[![Last Commit](https://img.shields.io/github/last-commit/johnolofs/timpi)](https://github.com/johnolofs/timpi/commits/main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Community-maintained installation and operation guides for every node type in the **Timpi** decentralized search network.

> 📘 The official Timpi repository lives at **[Timpi-official/Nodes](https://github.com/Timpi-official/Nodes)**.
> This repo provides longer-form guides, alternative installation paths, and additional troubleshooting based on real operator experience.

---

## 🗂 Node Types

| Node | Role | Install Guide |
| --- | --- | --- |
| 🔄 **Collector** | Crawls and indexes the web | [Collector/](Collector/README.md) |
| 🛡 **Guardian** | Stores and serves index segments (Solr) | [Guardian/](Guardian/README.md) |
| 🧬 **Synaptron** | GPU AI worker (image / text tasks) | [Synaptron/](Synaptron/README.md) |
| 🌍 **GeoCore** | Geo-aware routing to Guardians | [Geocore/](Geocore/README.md) |
| ☁️ **Flux deployment** | Run Collector / GeoCore / Synaptron on Flux | [Flux/](Flux/README.md) |
| 🪙 **Neutaro validator** | Cosmos-SDK chain that powers Timpi governance | [Neutaro/](Neutaro/README.md) |
| 🔎 **Node Checkers** | Discord slash commands for status checks | [NodeChecker/](NodeChecker/README.md) |

---

## 📝 Registration

Every paid node (Synaptron, Guardian, GeoCore, Collector v2) needs a unique **GUID** linked to your Node Access NFT.

👉 **[Node Registration Guide](https://github.com/Timpi-official/Nodes/blob/main/Registration/RegisterNodes.md)** (official)
👉 **Dashboard:** [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)

---

## 📊 Reward Structure

Timpi guarantees minimum reward pools per node type for fixed periods. Rewards beyond the guaranteed period continue but scale with the network.

### 🔄 Collector

| Period | $NTMPI / node / month |
| --- | --- |
| Until Aug 2025 | 375 |
| Sep 2025 – Aug 2026 | 250 |
| Sep 2026 – Aug 2027 | 210 |

### 🛡 Guardian

| Period | $NTMPI / node / month |
| --- | --- |
| Until Aug 2025 | 667 |
| Sep 2025 – Aug 2026 | 500 |
| Sep 2026 – Aug 2027 | 375 |

### 🧬 Synaptron

| Period | Tier 1 | Tier 2 |
| --- | --- | --- |
| Until Dec 2025 | 1,400 | 1,600 |
| Jan 2026 – Dec 2026 | 800 | 1,000 |
| Jan 2027 – Dec 2027 | 500 | 700 |

### 🌍 GeoCore

| Period | $NTMPI / node / month |
| --- | --- |
| Until Aug 2026 | 800 |
| Sep 2026 – Aug 2027 | 400 |
| Sep 2027 – Aug 2028 | 300 |

---

## 🔗 Official Timpi Resources

### 🌐 Web

* **Timpi.io** — main site → [https://timpi.io](https://timpi.io)
* **Timpi Search** — try the engine → [https://timpi.com](https://timpi.com)
* **Whitepaper** → [https://timpi.gitbook.io/timpi-whitepaper](https://timpi.gitbook.io/timpi-whitepaper)

### 🧠 Node management

* **Register & monitor nodes** → [https://timpi.com/node/management](https://timpi.com/node/management)
* **TAPv2 node management** → [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management)
* **Official node instructions** → [Timpi-official/Nodes](https://github.com/Timpi-official/Nodes)

### 🔎 Explorer & tooling

* **Block explorer** → [https://explorer.neutaro.io](https://explorer.neutaro.io)
* **Neutaro chain repo** → [github.com/Neutaro/Neutaro](https://github.com/Neutaro/Neutaro)

### 💰 Exchanges & bridge

| Venue | Link |
| --- | --- |
| MEXC (NTMPI/USDT) | [mexc.com](https://www.mexc.com/exchange/NTMPI_USDT) |
| Osmosis (swap) | [app.osmosis.zone](https://app.osmosis.zone/?from=USDC&to=NTMPI) |
| BitMart (NTMPI/USDT) | [bitmart.com](https://www.bitmart.com/trade/en-US?symbol=NTMPI_USDT&layout=basic) |
| Uniswap (ETH token) | [app.uniswap.org](https://app.uniswap.org/explore/tokens/ethereum/0x53be7be0ce7f92bcbd2138305735160fb799be4f) |
| Bridge (Neutaro ⇄ Ethereum) | [bridge.blockscape.network](https://bridge.blockscape.network) |

### 👛 Wallets

* [Keplr](https://www.keplr.app) — recommended for Cosmos / Neutaro
* [OWallet](https://owallet.dev) — alternative Cosmos wallet
* [MetaMask](https://metamask.io) — for the Ethereum side of the bridge

### 📱 Community & social

| Platform | Link |
| --- | --- |
| 💬 Discord | [discord.gg/wGRm9c7JE2](https://discord.gg/wGRm9c7JE2) |
| ✈️ Telegram | [t.me/TimpiMe](https://t.me/TimpiMe) |
| 𝕏 Twitter | [@timpi_thenewway](https://twitter.com/timpi_thenewway) |
| 🦋 Bluesky | [@timpiofficial.bsky.social](https://timpiofficial.bsky.social) |
| 🐘 Mastodon | [@Timpi_Official](https://mastodon.social/@Timpi_Official) |
| 👽 Reddit | [r/Timpi](https://www.reddit.com/r/Timpi/) |
| 📺 YouTube | [Timpi channel](https://www.youtube.com/channel/UCFxYIB1mroXuZ91V0SC6fNQ) |
| 💼 LinkedIn | [linkedin.com/company/timpi](https://www.linkedin.com/company/timpi/) |
| ✍️ Medium | [@timpi.io](https://medium.com/@timpi.io) |

---

## 🆘 Support

* 💬 **Discord:** [Timpi server](https://discord.com/channels/946982023245992006) — community help in node-specific channels
* 🛠 **Tickets:** [#create-a-support-ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
* 🌐 **Web:** [timpi.com](https://timpi.com)

---

## 🤝 Contributing

Found a typo, broken link, or want to add a setup you've validated? Pull requests welcome.

For larger changes — new platforms, new sections, restructures — please open an issue or drop a note in Discord first so we don't duplicate effort.

---

## 📜 License

[MIT](LICENSE) — use, fork, and share freely.
