#!/usr/bin/env bash
set -euo pipefail

#############################################
# Timpi Synaptron - One-Line Installer
# Usage:
#   curl -s https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron/install.sh | bash
#############################################

REPO_BASE="https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron"
INSTALL_DIR="${HOME}/Synaptron"

echo "===== Timpi Synaptron – Installer ====="
echo
echo "Install directory: ${INSTALL_DIR}"
echo

# 1) Check that curl exists
if ! command -v curl >/dev/null 2>&1; then
  echo "❌ ERROR: 'curl' is not installed."
  echo "Install it with:"
  echo "  sudo apt update && sudo apt install -y curl"
  exit 1
fi

# 2) Create install directory
mkdir -p "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

echo "📂 Using directory: ${INSTALL_DIR}"
echo

# 3) Download run_synaptron.sh
echo "📥 Downloading run_synaptron.sh..."
curl -fsS -o run_synaptron.sh "${REPO_BASE}/run_synaptron.sh"

# 4) Download docker-compose.yml
echo "📥 Downloading docker-compose.yml..."
curl -fsS -o docker-compose.yml "${REPO_BASE}/docker-compose.yml"

# 5) Make launcher executable
chmod +x run_synaptron.sh

echo
echo "🚀 Starting Synaptron setup..."
./run_synaptron.sh

echo
echo "✅ Installation script finished."
echo "   If everything went well, your Synaptron is now running."
echo "   You can return later with:"
echo "     cd ${INSTALL_DIR}"
echo "     ./run_synaptron.sh"
echo
