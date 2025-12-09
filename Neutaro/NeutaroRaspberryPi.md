🌐 Neutaro Validator Guide – Raspberry Pi 4 & 5 (ARM64 Edition)

Fully updated, fully working, and optimized for ARM64 hardware.

⸻

📘 1. Why Run a Neutaro Node?

Neutaro works with Timpi to power the decentralized search engine. Running a node:
	•	Secures the network
	•	Enables decentralized voting
	•	Allows you to become a validator
	•	Helps power Timpi’s global decentralized search infrastructure

🔐 Security Guide:
https://github.com/Neutaro/Neutaro/blob/main/Security%20Guide.md

⸻

🧰 2. Raspberry Pi 4 Requirements

Component	Requirement
Raspberry Pi	Pi 4 or Pi 5 — 8 GB RAM only
OS	Ubuntu Server 22.04 LTS 64-bit ARM
Storage	500 GB external SSD (USB 3) – SD cards will fail
CPU	4 cores – OK
Internet	20–50 Mbps stable
Power	Official Pi power supply

⚠️ DO NOT use SD cards for blockchain data. SSD only.

⸻

🔓 3. Open Firewall & Router Port

Neutaro requires TCP 26656 open.

Linux UFW:

sudo ufw allow 26656/tcp
sudo ufw reload

Router:

Forward TCP 26656 to your Pi’s LAN IP.

⸻

🧹 4. Remove Old Neutaro Installations (Optional)

bash <(wget -qO- https://raw.githubusercontent.com/Neutaro/Neutaro/main/neutaro_remove.sh)


⸻

🛠️ 5. Install Dependencies

sudo apt update && sudo apt install -y \
    curl tar wget clang pkg-config libssl-dev jq build-essential \
    bsdmainutils git make ncdu gcc chrony liblz4-tool pv


⸻

🚀 6. Install Go (ARM64 version for Raspberry Pi)

GO_VERSION="1.22.2"
wget "https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-arm64.tar.gz"
rm "go${GO_VERSION}.linux-arm64.tar.gz"

Add Go to PATH:

echo "export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH" | tee -a ~/.bash_profile ~/.bashrc
source ~/.bash_profile

Fix sudo go path:

sudo ln -sf /usr/local/go/bin/go /usr/bin/go

Verify:

go version
sudo go version


⸻

📦 7. Download & Build Neutaro (ARM64)

cd $HOME
git clone https://github.com/Neutaro/Neutaro
cd Neutaro
make build

Check version:

./build/Neutaro version --long


⸻

⚙️ 8. Install Cosmovisor

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

mkdir -p $HOME/.Neutaro/cosmovisor/genesis/bin
cp build/Neutaro $HOME/.Neutaro/cosmovisor/genesis/bin

ln -s $HOME/.Neutaro/cosmovisor/genesis $HOME/.Neutaro/cosmovisor/current
sudo ln -s $HOME/.Neutaro/cosmovisor/current/bin/Neutaro /usr/local/bin/Neutaro


⸻

🆔 9. Initialize Neutaro

MONIKER="YourMonikerName"
Neutaro init $MONIKER --chain-id Neutaro-1


⸻

🧩 10. Configure Node Settings

Set seeds:

sed -i "s/^seeds *=.*/seeds = \"84ae242b0c4c14af59a61438ba2eca4573b91c95@109.199.106.233:36656\"/" ~/.Neutaro/config/config.toml

Set pruning (recommended for Pi):

sed -i "s/^pruning *=.*/pruning = \"custom\"/" ~/.Neutaro/config/app.toml
sed -i "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" ~/.Neutaro/config/app.toml
sed -i "s/^pruning-interval *=.*/pruning-interval = \"19\"/" ~/.Neutaro/config/app.toml

Download genesis:

curl -f http://154.26.153.186/genesis.json > ~/.Neutaro/config/genesis.json


⸻

📥 11. Apply Snapshot

cd ~/.Neutaro
SNAPSHOT_URL="http://173.212.198.246/snapshot-neutaro/latest.tar.lz4"

wget $SNAPSHOT_URL -O latest.tar.lz4
lz4 -t latest.tar.lz4

if [ $? -eq 0 ]; then
    lz4 -d latest.tar.lz4 | tar -xvf - -C ~/.Neutaro
    rm -f latest.tar.lz4
else
    echo "❌ Snapshot corrupted."
    rm -f latest.tar.lz4
fi


⸻

🛡️ 12. Fix Cosmovisor Upgrade Requirement (IMPORTANT)

Cosmovisor requires an upgrade path:

mkdir -p ~/.Neutaro/cosmovisor/upgrades/v2/bin
cp ~/.Neutaro/cosmovisor/genesis/bin/Neutaro ~/.Neutaro/cosmovisor/upgrades/v2/bin/

Verify:

ls ~/.Neutaro/cosmovisor/upgrades/v2/bin

You should see:

Neutaro


⸻

🧾 13. Create systemd Service

Find your username:

whoami

Create the file:

sudo tee /etc/systemd/system/Neutaro.service > /dev/null << EOF
[Unit]
Description=Neutaro Node Service
After=network-online.target

[Service]
User=johnolofs
ExecStart=/home/johnolofs/go/bin/cosmovisor run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=/home/johnolofs/.Neutaro"
Environment="DAEMON_NAME=Neutaro"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

(Change username if needed.)

⸻

▶️ 14. Start the Node

sudo systemctl daemon-reload
sudo systemctl enable Neutaro
sudo systemctl restart Neutaro

Check logs:

sudo journalctl -fu Neutaro -o cat

Expected: no more “missing binary” errors.

⸻

🔍 15. Check Sync Status

Neutaro status 2>&1 | jq .SyncInfo


⸻

👛 16. Create or Recover Wallet

sudo Neutaro keys add WALLET --keyring-backend os --recover


⸻

🏅 17. Create Validator (after full sync)

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


⸻

🎉 Your Neutaro Raspberry Pi Validator Is Now Live!
