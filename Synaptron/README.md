# 🧬 Timpi Synaptron

<img width="1480" height="862" src="https://github.com/user-attachments/assets/b0749433-3720-4422-a14d-26c4dec067c3" />

The **Synaptron** is Timpi's GPU AI worker. It runs models for image / text understanding tasks fed by the Collector network, and pays out monthly $NTMPI rewards based on availability and (later) performance.

> [!NOTE]
> **Latest Linux images:** `timpiltd/timpi-synaptron-universal:cuda24` (most GPUs) · `:cuda28` (Blackwell).
> **Latest Windows installer:** `SynaptronSetupConda.zip`.
> Verify your running version in Discord with `/synaptronchecker`.

---

## 📥 Pick your install path

| Platform | Guide | Notes |
| --- | --- | --- |
| Linux (auto) | [linux.md](linux.md) | One-line `curl \| bash` installer with auto-detection |
| Linux (manual) | [linux-manual.md](linux-manual.md) | Full step-by-step Docker Compose walkthrough |
| Windows 10 / 11 | [windows.md](windows.md) | Native installer (`setup.exe`), Conda-based |
| FluxEdge (GPU) | [../Flux/synaptron.md](../Flux/synaptron.md) | Rent a GPU machine on Flux |

---

## 🖥 System requirements

| Component | Minimum |
| --- | --- |
| CPU | 4 cores |
| RAM | 12 GB |
| GPU | NVIDIA, **Compute Capability ≥ 6.1** ([list](https://developer.nvidia.com/cuda-gpus)) |
| VRAM | 4 GB+ (Tier 1: 4–6 GB · Tier 2: 8–16 GB) |
| Storage | 250 GB SSD / NVMe |
| OS | Ubuntu 22.04 LTS or Windows 10 / 11 |

> [!IMPORTANT]
> **NVIDIA only** — AMD and Apple Silicon are not supported.
> **One node per GPU** — the NFT-to-GPU mapping is 1:1.

---

## 🆔 Get your GUID

Register your Synaptron NFT and copy its GUID at [https://timpi.com/node/v2/management](https://timpi.com/node/v2/management).

You'll also need a **node NAME** with at least **17 characters** (letters, digits, `_`, `-` only).

---

## 🧠 How tiers work

| Tier | VRAM | Notes |
| --- | --- | --- |
| Tier 1 | 4–6 GB | Most consumer GPUs |
| Tier 2 | 8–16 GB | Higher reward pool (~14.3% more) |
| Tier 3 | RTX 4090 / 5090 | Use the Blackwell / `cuda28` build |

Rewards start with availability-based equal split within a tier, then transition to performance-based (jobs completed). See the [reward tables](../README.md#-reward-structure).

---

## 🛠 Files in this folder

* **`docker-compose.yml`** — canonical Linux compose file (image, env vars, volumes)
* **`scripts/install.sh`** — one-line installer that prompts for NAME / GUID and patches the compose file
* **`scripts/run-synaptron.sh`** — runtime script invoked by `install.sh` (GPU detection, image tag selection, `docker compose up`)
* **`archive/`** — older versions of the guides, kept for reference

---

## 🆘 Support

* [Timpi Discord — #synaptron-support](https://discord.com/channels/946982023245992006)
* [Open a support ticket](https://discord.com/channels/946982023245992006/1179427377844068493)
* [Windows video walkthrough](https://www.youtube.com/watch?v=_SPVbZuCCPQ)
