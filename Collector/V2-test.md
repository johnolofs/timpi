# 🧭 Timpi Collector v2 — Manual Linux Setup Guide (as a Service)

This version runs **headless** (no UI) and **does not use `timpi.config`**.
You only need these three files:

```
TimpiCollector
CollectorSettings.json
public_suffix_list.dat
```

---

## 🧹 Step 1 — Stop and Remove Old Collector Services

Stop any old collector services that might still be running:

```bash
sudo systemctl stop collector
sudo systemctl stop collector_ui
```

Remove their service files completely:

```bash
sudo rm -f /etc/systemd/system/collector.service
sudo rm -f /etc/systemd/system/collector_ui.service
sudo systemctl daemon-reload
```

✅ This prevents conflicts with the new v2 service.

---

## 🧽 Step 2 — Remove Old Files and Start Fresh

```bash
sudo rm -rf /opt/timpi
sudo mkdir -p /opt/timpi
sudo chown $USER:$USER /opt/timpi
cd /opt/timpi
```

---

## 📦 Step 3 — Download and Extract the New Collector v2

Download the latest official `.rar` package:

```bash
wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-v2.rar -O /opt/timpi/TimpiCollectorLinuxLatest-v2.rar
```

Install `unrar` if needed:

```bash
sudo apt install unrar -y
```

Extract the files (this creates a subfolder):

```bash
sudo unrar x /opt/timpi/TimpiCollectorLinuxLatest-v2.rar /opt/timpi
```

Move everything into `/opt/timpi` and remove the extra folder:

```bash
sudo mv /opt/timpi/TimpiCollectorLinuxLatest/* /opt/timpi/
sudo rm -rf /opt/timpi/TimpiCollectorLinuxLatest
```

Check the files:

```bash
ls -l /opt/timpi
```

Expected:

```
TimpiCollector
CollectorSettings.json
public_suffix_list.dat
```

Make the binary executable:

```bash
sudo chmod +x /opt/timpi/TimpiCollector
```

---

## ▶️ Step 4 — Test Run Manually

Replace `YOUR-GUID` with your actual GUID (from the Node Management page):

```bash
sudo /opt/timpi/TimpiCollector YOUR-GUID
```

Expected output:

```
[INF] Currently on version 1.0.0
[INF] Logging level: Verbose
[INF] Trying to send keep alive…
```

If you see
`Error in sending keep alive... No Coordinator available`
🧠 That’s OK — your region just isn’t active yet.

---

## ⚙️ Step 5 — Create a New Systemd Service (Auto-Start)

```bash
sudo nano /etc/systemd/system/timpi-collector.service
```

Paste (this matches your original layout + GUID):

```ini
[Unit]
Description=Timpi Collector Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector YOUR-GUID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save (**Ctrl + O**, **Enter**, **Ctrl + X**).

---

## 🔄 Step 6 — Enable and Start the New Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable timpi-collector
sudo systemctl start timpi-collector
```

---

## 🔍 Step 7 — Check Logs and Status

Live logs:

```bash
sudo journalctl -u timpi-collector -f
```

Service status:

```bash
sudo systemctl status timpi-collector
```

Restart if needed:

```bash
sudo systemctl restart timpi-collector
```














































