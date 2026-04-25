# 🔄 Timpi Collector

<img width="1024" height="576" alt="Timpi Collector" src="https://github.com/user-attachments/assets/8dcd810f-fa30-4912-ac11-c63417ec15bc" />

Timpi Collectors are decentralized "workers" that crawl and index the web for the **Timpi Search Engine** — privately, securely, and without ads or tracking.

Collector v2 is **headless** and **dashboard-managed**: you start the binary with your GUID, and configure workers / threads from [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

---

## 📥 Pick your platform

| Platform | Guide | Best for |
| --- | --- | --- |
| Linux (native) | [linux.md](linux.md) | Bare-metal Ubuntu, runs as a systemd service with auto-updater |
| Windows 10 / 11 | [windows.md](windows.md) | Personal PCs, native installer with desktop shortcuts |
| Docker on Linux | [docker.md](docker.md) | Multi-node setups, isolated containers |
| FluxCloud | [../Flux/collector.md](../Flux/collector.md) | No hardware — Flux marketplace deployment |

---

## ✅ System requirements

| Resource | Minimum |
| --- | --- |
| OS | Ubuntu 22.04 LTS (64-bit) or Windows 10 / 11 |
| CPU | 2 cores |
| RAM | 2 GB |
| Storage | 1 GB free (SSD recommended) |
| Network | Stable connection, no data caps |

---

## ⚠️ Support policy

Officially supported:

* Windows 10 / 11
* Ubuntu 22.04 LTS (native)
* Docker on Ubuntu 22.04 LTS

Not officially supported (community help only): macOS, WSL, Proxmox LXC, nested virtualization, other Linux distros.

You're welcome to experiment, but Timpi support tickets cover only the supported platforms.

---

## 🆔 Get your GUID

Before installing, register your Collector and copy its GUID at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

A GUID looks like `88293b19-b6b2-4ee2-ba1b-ae4bd670e12f`. Each Collector node needs a **unique** GUID.

> [!TIP]
> Recommended starting config: **1 Worker, 5 Threads**. Adjust later from the dashboard.

---

## 🆘 Support

* [Timpi Discord](https://discord.com/channels/946982023245992006) — community help
* [Open a support ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
