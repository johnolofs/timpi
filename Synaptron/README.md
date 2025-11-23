# 🧬 **TIMPI SYNAPTRON – OFFICIAL INSTALLATION GUIDE (LINUX-DOCKER)**

### *Simple. Safe. One command. Works on Ubuntu & Proxmox VM.*

---

# ✅ **1. Before you start**

Make sure you:

### ✔ Are using **a normal Linux user** (NOT root)

### ✔ Have **Docker installed** (Debian-style), NOT Snap Docker

### ✔ Have an **NVIDIA GPU** in a normal machine or Proxmox VM

### ✔ Have your **Synaptron GUID** ready

If unsure — just continue. The installer will tell you if something is missing.

---

# 🚀 **2. One-line installation (run this as your normal user)**

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/install.sh | bash
```

You will be asked:

### 1️⃣ **Node NAME**

* Must be **≥16 characters**
* Letters, numbers, `_` and `-` allowed
* Example:

  ```
  SynaptronNodeProxmox001
  ```

### 2️⃣ **GUID**

Paste your Synaptron GUID (one GUID).

---

# 🧠 **3. What happens automatically**

The installer:

* Creates `~/Synaptron/`
* Downloads the correct `docker-compose.yml`
* Downloads `run_synaptron.sh`
* Embeds your **NAME** and **GUID** into the YAML
* Detects your **CUDA version**
* Chooses the correct **ARCH + image tag**
* Checks:

  * Docker
  * Docker permissions
  * NVIDIA driver
  * GPU visibility in Docker
  * NVIDIA Container Toolkit
* Starts the full stack:

  * Synaptron
  * Neo4j
  * Watchtower

You will see:

```
=========================================
   ✅ Synaptron is now running
=========================================
```

This means **you’re done** 🎉

---

# 📡 **4. Check Synaptron logs**

If you want to see what it’s doing:

```bash
docker logs -f synaptron_universal
```

First run will:

* Install PyTorch
* Install CUDA libs
* Download model files
  (only happens once)

When ready you will see:

```
Connected to Wilson...
Waiting for tasks...
```

---

# 🔁 **5. Updating Synaptron**

Watchtower auto-updates Synaptron.

To force update manually:

```bash
cd ~/Synaptron
docker compose pull
docker compose up -d
```

---

# 🧹 **6. Fix permissions (ONLY if you ran Synaptron with sudo in the past)**

If you used `sudo docker compose up` previously, you may get permission errors.

Fix:

```bash
sudo chown -R $USER:$USER ~/Synaptron
```

Then reinstall:

```bash
curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/install.sh | bash
```

---

# 🆘 **7. If the installer stops with an error**

The new installer now **detects**:

* Broken NVIDIA driver
* Missing NVIDIA toolkit
* Docker permissions
* Snap Docker
* No GPU in container
* Missing CUDA
* Wrong environment

If anything is wrong, it will show a **red error message** that looks like:

```
❌ Docker CANNOT access your NVIDIA GPU.
Fix steps:
  sudo apt install nvidia-container-toolkit
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
```

**Just follow the lines the installer shows.**
Everything is copy-paste.

If you still can’t fix it → open a ticket or ask in Discord.

---

# 🪛 **8. Uninstall Synaptron**

```bash
cd ~/Synaptron
docker compose down
rm -rf ~/Synaptron
```

---

# 🟢 **That’s all folks!**

Forget the complicated NVIDIA driver stuff —
the installer **already checks everything automatically**
and only shows GPU fix commands when necessary.
