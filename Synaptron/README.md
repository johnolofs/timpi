# 🧬 **Timpi Synaptron – EASY Installation Guide (2025)**

Welcome to the **Synaptron Linux installer** for Ubuntu 22.04+.
This guide is designed for ALL users — beginners, experts, GPU nerds, Proxmox VM users, and home servers.

### ✔ One-line installer

### ✔ Auto-detects your CUDA version

### ✔ Auto-configures everything

### ✔ Auto-updates itself

### ✔ No file editing

### ✔ Works on ANY Ubuntu 22.04+ VM or hardware

> **Windows users:** Synaptron Windows has its own installer (separate guide).

---

# 🚀 **1. Quick Install (Recommended)**

Just run this one command:

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/install.sh | bash
```

That’s it.

The installer will:

* Download everything it needs
* Detect your GPU & CUDA version
* Choose the correct Synaptron architecture
* Check Docker & Docker Compose
* Block snap-installed Docker
* Start Synaptron, Neo4j, Watchtower
* Keep your node constantly updated

💡 **Installation time:** ~ 15–45 seconds.

---

# 🧠 **2. What You Need**

| Requirement | Description                                         |
| ----------- | --------------------------------------------------- |
| **OS**      | Ubuntu 22.04 LTS or newer (VM or bare-metal)        |
| **GPU**     | NVIDIA GPU with CUDA support                        |
| **Drivers** | `nvidia-smi` must work                              |
| **Docker**  | Installed via APT, NOT snap                         |
| **Compose** | Docker Compose v2.23.0 or newer                     |
| **Toolkit** | NVIDIA Container Toolkit (installer checks runtime) |

If something is missing, the installer gives a clear error and tells you what to fix.

---

# 🖥 **3. Supported Environments**

### ✔ Fully supported (works perfectly)

* Ubuntu 22.04 LTS
* Ubuntu 22.04 inside **Proxmox VM** (with GPU passthrough)
* Bare-metal NVIDIA systems
* Cloud VMs with NVIDIA GPU passthrough

### ⚠ Works but not officially supported

* Debian 12
* Pop!_OS / Mint / Zorin OS
* Fedora with NVIDIA toolkit installed

### ❌ Not supported (will not work)

* Proxmox **LXC containers**
* Snap Docker
* macOS
* Windows WSL
* ARM CPUs (Raspberry Pi, Graviton, etc.)

---

# 🏗 **4. What Gets Installed**

The installer launches a complete Docker stack:

| Container               | Purpose                                      |
| ----------------------- | -------------------------------------------- |
| **synaptron_universal** | The actual Synaptron AI node                 |
| **neo4jtest**           | Local graph database used internally         |
| **watchtower**          | Auto-update service (checks every 5 minutes) |

All of this runs automatically in the background.

---

# 🔧 **5. After Installation**

### Check containers:

```bash
docker ps
```

### View Synaptron logs:

```bash
docker logs -f synaptron_universal
```

### View auto-update logs:

```bash
docker logs -f watchtower
```

### Restart Synaptron manually:

```bash
cd ~/Synaptron
./run_synaptron.sh
```

### Stop everything:

```bash
docker compose down
```

---

# 🧩 **6. Troubleshooting**

### ❌ Snap Docker detected

Installer shows:

```
ERROR: Snap Docker detected
```

Fix:

```bash
sudo snap remove docker
curl -fsSL https://get.docker.com | sudo bash
```

### ❌ NVIDIA driver missing

If `nvidia-smi` doesn’t work:

* install drivers
* reboot
* try again

### ❌ Synaptron not updating

Check Watchtower:

```bash
docker logs -f watchtower
```

---

# 🧪 **7. How It Works Under the Hood**

The installer:

### ✔ Auto-detects CUDA:

* CUDA 12.0–12.7 → `t3_cuda24`
* CUDA 12.8+ → `t3_cuda28`

### ✔ Auto-patches docker-compose.yml:

```
ARCH: t3_cuda24
```

or

```
ARCH: t3_cuda28
```

### ✔ Auto-updates via Watchtower:

Runs every **5 minutes**, restarts only Synaptron, cleans old images.

### ✔ Runs everything with:

```bash
docker compose up --pull=always -d
```

---

# 🧬 **8. Files in the Installer**

The installer downloads the latest versions of:

### **install.sh**

* Simple bootstrapper
* Creates `~/Synaptron`
* Downloads launcher + compose
* Runs the main script

### **run_synaptron.sh**

* Smart installer
* Checks drivers, Docker, versions
* Detects CUDA → ARCH
* Patches YAML
* Launches stack

### **docker-compose.yml**

* Defines Synaptron + Neo4j + Watchtower

All stored in:

```
~/Synaptron/
```

---

# 🎉 **9. Installation Complete**
