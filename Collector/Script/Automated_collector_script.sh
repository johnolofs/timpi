#!/bin/bash

INSTALL_DIR="/opt/timpi"

handle_error() {
    echo "❌ An error occurred. Exiting."
    exit 1
}

echo ""
read -p "🧹 Do you want to remove the previous version of Timpi Collector? (y/n) [default: y]: " REMOVE_CHOICE
REMOVE_CHOICE=${REMOVE_CHOICE:-y}

if [[ "$REMOVE_CHOICE" == "y" || "$REMOVE_CHOICE" == "Y" ]]; then
    echo "🧹 Stopping services and removing previous version..."
    sudo systemctl stop collector || true
    sudo systemctl stop collector_ui || true
    sudo rm -rf "$INSTALL_DIR" || true
else
    echo "🔄 Skipping removal of previous version..."
fi

echo "📦 Updating and upgrading the system..."
sudo apt update && sudo apt -y upgrade || handle_error

sudo mkdir -p "$INSTALL_DIR" || handle_error

echo "📦 Installing unrar..."
sudo apt install -y unrar || handle_error

echo "⬇️ Downloading the latest collector version (v0.10.0-A)..."
sudo wget https://timpi.io/applications/linux/TimpiCollectorLinuxLatest-0.10.0-A.rar -O "$INSTALL_DIR/TimpiCollectorLinuxLatest.rar" || handle_error

echo "📂 Extracting collector files..."
cd "$INSTALL_DIR" || handle_error
sudo unrar x -y "$INSTALL_DIR/TimpiCollectorLinuxLatest.rar" || handle_error

if [ -d "$INSTALL_DIR/TimpiCollectorLinuxLatest" ]; then
    sudo mv "$INSTALL_DIR/TimpiCollectorLinuxLatest"/* "$INSTALL_DIR" || handle_error
    sudo rm -rf "$INSTALL_DIR/TimpiCollectorLinuxLatest" || handle_error
fi

echo "🔒 Setting execute permissions..."
sudo chmod 755 "$INSTALL_DIR/TimpiCollector" || handle_error
sudo chmod 755 "$INSTALL_DIR/TimpiUI" || handle_error

TOTAL_MEM_GB=$(awk '/MemTotal/ {printf "%.0f", $2 / 1024 / 1024}' /proc/meminfo)
if [ "$TOTAL_MEM_GB" -lt 2 ]; then
    echo "❌ Your system has less than 2GB RAM. This is below the minimum required."
    exit 1
fi

echo ""
echo "🧠 Total system memory detected: ${TOTAL_MEM_GB} GB"
echo "💡 Set memory limits for the Collector service (like a container)"
echo "   MemoryMax controls how much RAM the Collector uses"
echo "   MemorySwapMax will be automatically set to MemoryMax + 1"
echo "   Press Enter to use default: 2G RAM and 3G Swap"
echo ""

read -p "Enter MemoryMax in GB [default: 2]: " MEMORY_MAX
MEMORY_MAX=${MEMORY_MAX:-2}
MEMORY_SWAP=$((MEMORY_MAX + 1))

echo "💾 MemorySwapMax has been automatically set to: ${MEMORY_SWAP}G"
echo ""

echo "📝 Writing collector.service with MemoryMax=${MEMORY_MAX}G and MemorySwapMax=${MEMORY_SWAP}G..."
sudo bash -c "cat > /etc/systemd/system/collector.service <<EOF
[Unit]
Description=Timpi Collector Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiCollector
Restart=always
MemoryMax=${MEMORY_MAX}G
MemorySwapMax=${MEMORY_SWAP}G

[Install]
WantedBy=multi-user.target
EOF"

if [ ! -f /etc/systemd/system/collector_ui.service ]; then
    echo "📝 Creating collector_ui.service..."
    sudo bash -c 'cat > /etc/systemd/system/collector_ui.service <<EOF
[Unit]
Description=Timpi Collector UI Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/timpi
ExecStart=/opt/timpi/TimpiUI
Restart=always

[Install]
WantedBy=multi-user.target
EOF'
fi

echo "🧹 Cleaning up archive..."
sudo rm -rf "$INSTALL_DIR/TimpiCollectorLinuxLatest.rar" || handle_error

echo "🔄 Reloading and enabling services..."
sudo systemctl daemon-reload || handle_error
sudo systemctl enable collector || handle_error
sudo systemctl enable collector_ui || handle_error

echo "▶️ Starting services..."
sudo systemctl start collector || handle_error
sudo systemctl start collector_ui || handle_error

echo ""
echo "✅ Timpi Collector v0.10.0-A installed and running!"
echo "🌐 Open your browser and visit: http://localhost:5015/collector"
echo "⚠️ If the collector doesn't start, remove the config file:"
echo "   sudo rm -f $INSTALL_DIR/timpi.config && sudo systemctl restart collector"
echo ""
echo "🧪 To check status manually:"
echo "   sudo systemctl status collector"
echo "   sudo systemctl status collector_ui"
