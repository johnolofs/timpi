# 🖥 Neutaro — Linux Validator Guide (x86_64)

Full, clean, working Neutaro node guide using **Cosmovisor + systemd**, with **State Sync** (recommended) or **Snapshot** sync. Safe to re-run from scratch.

> Run everything in the **same terminal session**.

---

## 📑 Table of Contents

1. [System requirements](#1-system-requirements)
2. [Open the required port](#2-open-the-required-port)
3. [Optional: full cleanup (safe reinstall)](#3-optional-full-cleanup-safe-reinstall)
4. [Sanity check](#4-sanity-check)
5. [Install dependencies](#5-install-dependencies)
6. [Install Go (system-wide)](#6-install-go-system-wide)
7. [Build Neutaro](#7-build-neutaro)
8. [Install Cosmovisor](#8-install-cosmovisor)
9. [Cosmovisor layout](#9-cosmovisor-layout)
10. [Init the node](#10-init-the-node)
11. [Sync the node](#11-sync-the-node)
12. [systemd service](#12-systemd-service)
13. [Verify sync](#13-verify-sync)
14. [Disable State Sync after sync](#14-disable-state-sync-after-sync)
15. [Create a validator](#15-create-a-validator)
16. [Quick troubleshooting](#16-quick-troubleshooting)

---

## 1. System requirements

* Ubuntu 22.04 LTS
* 4 CPU cores
* 8 GB RAM
* 250–500 GB SSD

---

## 2. Open the required port

```bash
sudo ufw allow 26656/tcp
sudo ufw reload
```

Router: forward **TCP 26656** to your node's LAN IP.

---

## 3. Optional: full cleanup (safe reinstall)

Run **only** if you're reinstalling or recovering from a broken setup:

```bash
sudo systemctl stop Neutaro 2>/dev/null || true
sudo systemctl disable Neutaro 2>/dev/null || true
sudo rm -f /etc/systemd/system/Neutaro.service
sudo systemctl daemon-reload
sudo systemctl reset-failed

rm -rf ~/.Neutaro ~/Neutaro
sudo rm -f /usr/local/bin/Neutaro /usr/local/bin/cosmovisor
rm -f ~/go/bin/Neutaro ~/go/bin/cosmovisor
rm -rf ~/go
```

---

## 4. Sanity check

```bash
set -euo pipefail
echo "User: $(whoami)"
echo "HOME: $HOME"
```

---

## 5. Install dependencies

```bash
sudo apt update && sudo apt install -y \
  curl wget git make jq build-essential \
  clang pkg-config libssl-dev \
  chrony lz4 pv
```

---

## 6. Install Go (system-wide)

```bash
GO_VERSION="1.22.2"
cd /tmp
wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm -f go${GO_VERSION}.linux-amd64.tar.gz

grep -q '/usr/local/go/bin' ~/.bashrc || \
  echo 'export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH' >> ~/.bashrc

export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH
go version
```

---

## 7. Build Neutaro

```bash
cd "$HOME"
rm -rf Neutaro
git clone https://github.com/Neutaro/Neutaro
cd Neutaro
make build
```

Verify:

```bash
ls -lah ./build/Neutaro
./build/Neutaro version --long
```

❌ If the binary isn't there — STOP and fix the build before continuing.

---

## 8. Install Cosmovisor

```bash
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
sudo ln -sf "$HOME/go/bin/cosmovisor" /usr/local/bin/cosmovisor
```

---

## 9. Cosmovisor layout

```bash
mkdir -p "$HOME/.Neutaro/cosmovisor/genesis/bin"
mkdir -p "$HOME/.Neutaro/data-backup"

cp "$HOME/Neutaro/build/Neutaro" \
   "$HOME/.Neutaro/cosmovisor/genesis/bin/Neutaro"

chmod +x "$HOME/.Neutaro/cosmovisor/genesis/bin/Neutaro"

ln -sfn "$HOME/.Neutaro/cosmovisor/genesis" \
        "$HOME/.Neutaro/cosmovisor/current"

sudo ln -sf "$HOME/.Neutaro/cosmovisor/current/bin/Neutaro" \
            /usr/local/bin/Neutaro
```

---

## 10. Init the node

```bash
MONIKER="YourMoniker"
Neutaro init "$MONIKER" --chain-id Neutaro-1
```

### Genesis file

```bash
curl -fsSL http://154.26.153.186/genesis.json \
  > "$HOME/.Neutaro/config/genesis.json"
```

### Seeds + pruning

```bash
CONFIG="$HOME/.Neutaro/config/config.toml"
APP="$HOME/.Neutaro/config/app.toml"

sed -i 's|^seeds *=.*|seeds = "84ae242b0c4c14af59a61438ba2eca4573b91c95@109.199.106.233:36656"|' "$CONFIG"

sed -i \
  -e 's/^pruning *=.*/pruning = "custom"/' \
  -e 's/^pruning-keep-recent *=.*/pruning-keep-recent = "100"/' \
  -e 's/^pruning-interval *=.*/pruning-interval = "19"/' \
  "$APP"
```

---

## 11. Sync the node

Pick **one**. State Sync is fastest.

### Option A — State Sync (recommended)

```bash
sed -i 's|^persistent_peers *=.*|persistent_peers = "ee64e5d0c3549fe807149f5f29a2913074e08a62@147.93.4.184:26656"|' "$CONFIG"

cat > "$HOME/state_sync.sh" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
CONFIG="$HOME/.Neutaro/config/config.toml"
RPC1="https://rpc2.neutaro.io:443"
RPC2="https://rpc3.neutaro.io:443"
RPC="$RPC1"
curl -fsS "$RPC/status" >/dev/null || RPC="$RPC2"
HEIGHT=$(curl -s "$RPC/block" | jq -r .result.block.header.height)
TRUST_HEIGHT=$((HEIGHT-2000))
TRUST_HASH=$(curl -s "$RPC/block?height=$TRUST_HEIGHT" | jq -r .result.block_id.hash)
sed -i \
  -e 's|^enable *=.*|enable = true|' \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$RPC1,$RPC2\"|" \
  -e "s|^trust_height *=.*|trust_height = $TRUST_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$TRUST_HASH\"|" \
  "$CONFIG"
EOF

chmod +x "$HOME/state_sync.sh"
"$HOME/state_sync.sh"

Neutaro tendermint unsafe-reset-all --home "$HOME/.Neutaro" --keep-addr-book
```

### Option B — Snapshot

Skip this if you ran State Sync.

```bash
cd "$HOME/.Neutaro"
wget -O latest.tar.lz4 http://173.212.198.246/snapshot-neutaro/latest.tar.lz4
lz4 -d latest.tar.lz4 | tar -xvf -
rm -f latest.tar.lz4
```

---

## 12. systemd service

```bash
sudo tee /etc/systemd/system/Neutaro.service > /dev/null << EOF
[Unit]
Description=Neutaro Node Service
After=network-online.target

[Service]
User=$(whoami)
ExecStart=/usr/local/bin/cosmovisor run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment=DAEMON_HOME=$HOME/.Neutaro
Environment=DAEMON_NAME=Neutaro
Environment=DAEMON_DATA_BACKUP_DIR=$HOME/.Neutaro/data-backup
Environment=UNSAFE_SKIP_BACKUP=true

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable Neutaro
sudo systemctl restart Neutaro
sudo journalctl -fu Neutaro -o cat
```

---

## 13. Verify sync

```bash
Neutaro status 2>&1 | jq .SyncInfo
```

Wait for:

```json
"catching_up": false
```

---

## 14. Disable State Sync after sync

Once `catching_up` is `false`, turn off State Sync to avoid replays on restart:

```bash
sed -i \
  -e 's|^enable *=.*|enable = false|' \
  -e 's|^rpc_servers *=.*|rpc_servers = ""|' \
  -e 's|^trust_height *=.*|trust_height = 0|' \
  -e 's|^trust_hash *=.*|trust_hash = ""|' \
  "$HOME/.Neutaro/config/config.toml"

sudo systemctl restart Neutaro
```

---

## 15. Create a validator

> Only run this **after** the node is fully synced.

### Create or recover a wallet

```bash
Neutaro keys add WALLET --keyring-backend os --recover
```

### Create the validator

```bash
Neutaro tx staking create-validator \
  --amount=1000000uneutaro \
  --pubkey=$(Neutaro tendermint show-validator) \
  --moniker="YourMoniker" \
  --chain-id Neutaro-1 \
  --from=WALLET \
  --keyring-backend=os \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --details="Your validator description"
```

---

## 16. Quick troubleshooting

```bash
which Neutaro
which cosmovisor
systemctl status Neutaro --no-pager
ls -lah ~/.Neutaro/config
```

For state-sync that won't complete: re-run `state_sync.sh` to refresh the trust hash, then restart the service.

---

✅ **Done.** Your node should be in sync, running under Cosmovisor, and ready for delegation or validator promotion.

🆘 [Timpi Discord](https://discord.com/channels/946982023245992006) · [Neutaro repo](https://github.com/Neutaro/Neutaro)
