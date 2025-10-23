## 🧭 Timpi Collector v2 — Linux Setup Guide (Testing Phase)

Hey everyone 👋
Here are the current instructions for **Linux Collector v2 (testing version)**.
This build is part of the testing phase before the **auto-updater** and **full release package** go live.


### 🧹 Step 1 — Stop the Current Collector Services

Make sure your current Collector installation is **already present**, since we still need a few existing files for this test version.

> Required files:
>
> * `public_suffix_list.dat`
> * `CollectorSettings.json`
> * `TimpiCollector`

Stop the current services before proceeding:

```bash
sudo systemctl stop collector
sudo systemctl stop collector_ui
```

### 🧽 Step 2 — Clean Up the Old Collector Binary

Before downloading the new version, remove any existing `TimpiCollector` binary to avoid version conflicts:

```bash
cd /opt/timpi
sudo rm -r TimpiCollector
```

*(Don’t worry — this only removes the executable, not your settings or data files.)*


### 📦 Step 3 — Download the New Collector Binary

```bash
wget https://timpi.io/applications/linux/TimpiCollector
```

Make it executable:

```bash
sudo chmod +x TimpiCollector
```

### ▶️ Step 4 — Start the Collector with Your GUID

Replace `YOUR-GUID` with your actual **Collector GUID**:

```bash
sudo ./TimpiCollector YOUR-GUID
```

### 🧩 Step 5 — Enable Verbose Logging (Optional)

To see more detailed logs, open the settings file:

```bash
sudo nano CollectorSettings.json
```

And set:

```json
{
  "LogLevel": "Verbose"
}
```

Press **CTRL + O**, **Enter**, then **CTRL + X** to save and exit.

---

### ⚠️ Step 6 — Common Error During Testing

If you see something like this:

```
[18:37:02 INF] Currently on version 1.0.0
[18:37:02 INF] Logging level: Verbose
[18:37:02 INF] Trying to send keep alive to http://tap29.timpi.network:4014
[18:37:02 ERR] Error in sending keep alive to coordinator: The request was canceled due to the configured HttpClient.Timeout of 30 seconds elapsing.
[18:37:02 ERR] Error in sending keep alive to coordinator. No Coordinator available or the information are wrong
```

🧠 Don’t worry — this just means you’re in a region that currently has **no active coordinators**.
Joerg is still activating these region by region.
Your Collector will stay idle until your region becomes active.

---

### 🧱 Step 7 — Important Notes

🚫 We **no longer use** the following with v2:

* `timpi.config` file
* TimpiCollector_ui

Everything now runs **directly from the terminal** using your GUID.

🖥️ A new UI will be available on the Node Management Page soon.

---

### 🧪 Additional Info

* This is a **testing-only version** — no auto-updates yet.
* A full release package with integrated auto-updater and setup script will be available later.
* You only need the files listed above for this phase.
