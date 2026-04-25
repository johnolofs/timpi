# 🍓 Neutaro — Raspberry Pi 4 / 5 (ARM64)

Full setup for running a Neutaro validator on a Raspberry Pi. Optimized for ARM64 hardware with snapshot-based sync.

For x86_64 servers see [validator.md](validator.md) (faster State Sync, more peers).

---

## 📑 Table of Contents

1. [Why run a Neutaro node](#1-why-run-a-neutaro-node)
2. [Hardware requirements](#2-hardware-requirements)
3. [Open firewall & router port](#3-open-firewall--router-port)
4. [Remove old Neutaro installations (optional)](#4-remove-old-neutaro-installations-optional)
5. [Install dependencies](#5-install-dependencies)
6. [Install Go (ARM64)](#6-install-go-arm64)
7. [Download & build Neutaro](#7-download--build-neutaro)
8. [Install Cosmovisor](#8-install-cosmovisor)
9. [Initialize Neutaro](#9-initialize-neutaro)
10. [Configure node settings](#10-configure-node-settings)
11. [Apply snapshot](#11-apply-snapshot)
12. [Fix Cosmovisor upgrade path](#12-fix-cosmovisor-upgrade-path)
13. [Create the systemd service](#13-create-the-systemd-service)
14. [Start the node](#14-start-the-node)
15. [Check sync status](#15-check-sync-status)
16. [Create or recover a wallet](#16-create-or-recover-a-wallet)
17. [Create a validator](#17-create-a-validator)

---

## 1. Why run a Neutaro node

Neutaro works with **Timpi** to power the decentralized search engine. Running a node:

* secures the network
* enables decentralized voting
* lets you become a validator
* helps power Timpi's global search infrastructure

> [!IMPORTANT]
> **Security guide:** [Neutaro Security Guide](https://github.com/Neutaro/Neutaro/blob/main/Security%20Guide.md). Read it before exposing a node.

---

## 2. Hardware requirements

| Component | Requirement |
| --- | --- |
| Raspberry Pi | Pi 4 or Pi 5 — **8 GB RAM model only** |
| OS | Ubuntu Server **22.04 LTS 64-bit ARM** |
| Storage | **500 GB external SSD (USB 3)** — SD cards will fail |
| CPU | 4 cores (built-in) |
| Internet | 20–50 Mbps stable |
| Power | Official Pi power supply |

> [!WARNING]
> **Do not use SD cards for blockchain data — SSD only.** SD cards will wear out and corrupt within weeks.

---

## 3. Open firewall & router port

Neutaro requires **TCP 26656** open.

### Linux UFW

```bash
sudo ufw allow 26656/tcp
sudo ufw reload
```

### Router

Forward **TCP 26656** to the Pi's LAN IP.

---

## 4. Remove old Neutaro installations (optional)

```bash
bash <(wget -qO- https://raw.githubusercontent.com/Neutaro/Neutaro/main/neutaro_remove.sh)
```

---

## 5. Install dependencies

```bash
sudo apt update && sudo apt install -y \
  curl tar wget clang pkg-config libssl-dev jq build-essential \
  bsdmainutils git make ncdu gcc chrony liblz4-tool pv
```

---

## 6. Install Go (ARM64)

```bash
GO_VERSION="1.22.2"
wget "https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-arm64.tar.gz"
rm "go${GO_VERSION}.linux-arm64.tar.gz"
```

Add Go to PATH:

```bash
echo "export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH" | tee -a ~/.bash_profile ~/.bashrc
source ~/.bash_profile
```

Make Go available for `sudo`:

```bash
sudo ln -sf /usr/local/go/bin/go /usr/bin/go
```

Verify:

```bash
go version
sudo go version
```

---

## 7. Download & build Neutaro

```bash
cd $HOME
git clone https://github.com/Neutaro/Neutaro
cd Neutaro
make build
```

Check the build:

```bash
./build/Neutaro version --long
```

---

## 8. Install Cosmovisor

```bash
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

mkdir -p $HOME/.Neutaro/cosmovisor/genesis/bin
cp build/Neutaro $HOME/.Neutaro/cosmovisor/genesis/bin

ln -s $HOME/.Neutaro/cosmovisor/genesis $HOME/.Neutaro/cosmovisor/current
sudo ln -s $HOME/.Neutaro/cosmovisor/current/bin/Neutaro /usr/local/bin/Neutaro
```

---

## 9. Initialize Neutaro

```bash
MONIKER="YourMonikerName"
Neutaro init "$MONIKER" --chain-id Neutaro-1
```

---

## 10. Configure node settings

### Set seeds

```bash
sed -i "s/^seeds *=.*/seeds = \"84ae242b0c4c14af59a61438ba2eca4573b91c95@109.199.106.233:36656\"/" ~/.Neutaro/config/config.toml
```

### Pruning (recommended for Pi)

```bash
sed -i "s/^pruning *=.*/pruning = \"custom\"/"               ~/.Neutaro/config/app.toml
sed -i "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" ~/.Neutaro/config/app.toml
sed -i "s/^pruning-interval *=.*/pruning-interval = \"19\"/" ~/.Neutaro/config/app.toml
```

### Download genesis

```bash
curl -f http://154.26.153.186/genesis.json > ~/.Neutaro/config/genesis.json
```

---

## 11. Apply snapshot

```bash
cd ~/.Neutaro
SNAPSHOT_URL="http://173.212.198.246/snapshot-neutaro/latest.tar.lz4"

wget $SNAPSHOT_URL -O latest.tar.lz4
lz4 -t latest.tar.lz4

if [ $? -eq 0 ]; then
    lz4 -d latest.tar.lz4 | tar -xvf - -C ~/.Neutaro
    rm -f latest.tar.lz4
else
    echo "Snapshot corrupted."
    rm -f latest.tar.lz4
fi
```

---

## 12. Fix Cosmovisor upgrade path

Cosmovisor needs an upgrade path to follow chain upgrades:

```bash
mkdir -p ~/.Neutaro/cosmovisor/upgrades/v2/bin
cp ~/.Neutaro/cosmovisor/genesis/bin/Neutaro ~/.Neutaro/cosmovisor/upgrades/v2/bin/
```

Verify:

```bash
ls ~/.Neutaro/cosmovisor/upgrades/v2/bin
# should print: Neutaro
```

---

## 13. Create the systemd service

Find your username:

```bash
whoami
```

Create the service file (replace `YOUR-USERNAME-HERE` with your actual username):

```bash
sudo tee /etc/systemd/system/Neutaro.service > /dev/null << EOF
[Unit]
Description=Neutaro Node Service
After=network-online.target

[Service]
User=YOUR-USERNAME-HERE
ExecStart=/home/YOUR-USERNAME-HERE/go/bin/cosmovisor run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=/home/YOUR-USERNAME-HERE/.Neutaro"
Environment="DAEMON_NAME=Neutaro"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
```

---

## 14. Start the node

```bash
sudo systemctl daemon-reload
sudo systemctl enable Neutaro
sudo systemctl restart Neutaro
sudo journalctl -fu Neutaro -o cat
```

You should no longer see "missing binary" errors.

---

## 15. Check sync status

```bash
Neutaro status 2>&1 | jq .SyncInfo
```

Wait for `"catching_up": false`.

---

## 16. Create or recover a wallet

```bash
sudo Neutaro keys add WALLET --keyring-backend os --recover
```

---

## 17. Create a validator

> [!IMPORTANT]
> Only after the node is fully synced.

```bash
Neutaro tx staking create-validator \
  --amount=1000000uneutaro \
  --pubkey=$(Neutaro tendermint show-validator) \
  --moniker="YourValidatorName" \
  --chain-id=Neutaro-1 \
  --from=WALLET \
  --keyring-backend=os \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --details="Your validator details"
```

---

**Your Neutaro Pi validator is now live.**

**Support:** [Timpi Discord](https://discord.com/channels/946982023245992006) · [Neutaro repo](https://github.com/Neutaro/Neutaro)
