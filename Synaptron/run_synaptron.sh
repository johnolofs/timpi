#!/usr/bin/env bash
set -euo pipefail

###########################################################
# Timpi Synaptron – Auto Installer / Runner (Linux Only)
# Ubuntu 22.04+ with NVIDIA GPU
# Maintainer: johnolofs (private pre-release)
#
# This script:
#  - Blocks Snap Docker
#  - Validates Docker & Docker Compose
#  - Checks Docker daemon permissions
#  - Runs NVIDIA diagnostics (driver + NVML)
#  - Detects CUDA version -> ARCH (t3_cuda24 / t3_cuda28)
#  - Selects matching Docker image tag (cuda24 / cuda28)
#  - Verifies GPU access inside Docker
#  - Prompts for NAME (>=16 chars) if needed
#  - Auto-patches docker-compose.yml
#  - Starts Synaptron stack (neo4j + watchtower + synaptron)
###########################################################

REPO_BASE="https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron"
YML_FILE="docker-compose.yml"

echo "===== Timpi Synaptron – Linux Installer ====="
echo

###########################################################
# Move into script directory
###########################################################
cd "$(dirname "$0")"

###########################################################
# Ensure docker-compose.yml exists
###########################################################
if [[ ! -f "$YML_FILE" ]]; then
  echo "📄 No docker-compose.yml found — downloading..."
  curl -fsS -O "${REPO_BASE}/${YML_FILE}"
fi

###########################################################
# BLOCK SNAP DOCKER
###########################################################
if command -v snap >/dev/null 2>&1 && snap list 2>/dev/null | grep -q "^docker "; then
  echo
  echo "❌ ERROR: Snap Docker detected!"
  echo "Snap Docker CANNOT be used with Synaptron (GPU access will fail)."
  echo
  echo "Fix:"
  echo "  sudo snap remove docker"
  echo "  curl -fsSL https://get.docker.com | sudo bash"
  echo
  exit 1
fi

###########################################################
# Validate Docker + Docker Compose
###########################################################
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ ERROR: Docker not installed."
  echo "Install it:"
  echo "  curl -fsSL https://get.docker.com | sudo bash"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "❌ ERROR: docker compose (v2) missing."
  exit 1
fi

COMPOSE_VERSION="$(docker compose version --short)"
REQUIRED_COMPOSE="2.23.0"

version_ge() {
  [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" == "$1" ]]
}

if ! version_ge "$REQUIRED_COMPOSE" "$COMPOSE_VERSION"; then
  echo "❌ Docker Compose version too old: ${COMPOSE_VERSION}"
  echo "Please update to ${REQUIRED_COMPOSE}+"
  exit 1
fi

echo "✅ Docker Compose OK: $COMPOSE_VERSION"

###########################################################
# Docker permissions check
###########################################################
if ! docker ps >/dev/null 2>&1; then
  echo
  echo "❌ ERROR: Cannot talk to Docker daemon as user '$USER'."
  echo

  if ! id -nG "$USER" | grep -qw docker; then
    echo "Fix:"
    echo "  sudo usermod -aG docker $USER"
    echo "  newgrp docker"
    echo
  else
    echo "Docker daemon may not be running:"
    echo "  sudo systemctl start docker"
    echo
  fi

  exit 1
fi

echo "✅ Docker daemon is reachable."

###########################################################
# NVIDIA DRIVER DIAGNOSTICS
###########################################################
echo
echo "🔍 Running NVIDIA diagnostics..."

# 1) Check that nvidia-smi exists at all
if ! command -v nvidia-smi >/dev/null 2>&1; then
  echo "❌ nvidia-smi not found — NVIDIA driver not installed correctly or GPU not detected."
  echo
  echo "Install / fix driver (recommended 550+), then reboot, for example:"
  echo "  sudo apt install -y nvidia-driver-550"
  echo "  sudo reboot"
  echo
  exit 1
fi

# 2) Check for NVML / driver mismatch errors
NVIDIA_ERROR="$(nvidia-smi 2>&1 | grep -i 'Failed' || true)"

if [[ -n "$NVIDIA_ERROR" ]]; then
  echo
  echo "❌ NVIDIA driver is broken!"
  echo "$NVIDIA_ERROR"
  echo
  echo "This means your NVIDIA installation is corrupted or mismatched."
  echo "Synaptron CANNOT run until this is fixed."
  echo
  echo "Suggested fix:"
  echo "  sudo apt remove --purge '^nvidia-.*'"
  echo "  sudo apt remove --purge '^libnvidia-.*'"
  echo "  sudo apt autoremove -y"
  echo "  sudo apt install -y nvidia-driver-550"
  echo "  sudo reboot"
  echo
  echo "After reboot:"
  echo "  sudo apt install -y nvidia-container-toolkit"
  echo "  sudo nvidia-ctk runtime configure --runtime=docker"
  echo "  sudo systemctl restart docker"
  echo
  exit 1
fi

echo "✅ NVIDIA driver appears present."

###########################################################
# CUDA detection -> ARCH + image tag
###########################################################
CUDA_LINE="$(nvidia-smi | grep 'CUDA Version' || true)"
CUDA_INFO=""
ARCH="t3_cuda24"
CUDA_TAG="cuda24"

if [[ -n "$CUDA_LINE" ]]; then
  CUDA_INFO="$(echo "$CUDA_LINE" | sed -E 's/.*CUDA Version: ([0-9]+\.[0-9]+).*/\1/')"
  CUDA_MAJOR="${CUDA_INFO%%.*}"
  CUDA_MINOR="${CUDA_INFO#*.}"

  echo "   Detected CUDA: $CUDA_INFO"

  # CUDA 12.8+ => t3_cuda28 + cuda28
  # CUDA 12.0–12.7 => t3_cuda24 + cuda24
  if [[ "$CUDA_MAJOR" -gt 12 ]] || { [[ "$CUDA_MAJOR" -eq 12 ]] && [[ "$CUDA_MINOR" -ge 8 ]]; }; then
    ARCH="t3_cuda28"
    CUDA_TAG="cuda28"
  fi
else
  echo "⚠ No CUDA version found — assuming ARCH=$ARCH"
fi

echo "🏗 Using ARCH: $ARCH"
echo "🏗 Using image tag: $CUDA_TAG"

###########################################################
# Check GPU visibility inside Docker
###########################################################
echo
echo "🔍 Checking GPU access inside Docker..."

if ! docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi >/dev/null 2>&1; then
  echo
  echo "❌ Docker CANNOT access your NVIDIA GPU."
  echo
  echo "Fix steps:"
  echo "  sudo apt install -y nvidia-container-toolkit"
  echo "  sudo nvidia-ctk runtime configure --runtime=docker"
  echo "  sudo systemctl restart docker"
  echo
  exit 1
fi

echo "✅ GPU is accessible from inside Docker."

###########################################################
# Prompt for NAME (>=16 characters) if needed
###########################################################
echo
echo "🧾 Checking Synaptron node NAME..."

CURRENT_NAME_LINE="$(grep -E '^\s*NAME:' "$YML_FILE" | head -n1 || true)"
CURRENT_NAME=""

if [[ -n "$CURRENT_NAME_LINE" ]]; then
  CURRENT_NAME="${CURRENT_NAME_LINE#*:}"
  CURRENT_NAME="${CURRENT_NAME#" "}"
  CURRENT_NAME="${CURRENT_NAME%\"}"
  CURRENT_NAME="${CURRENT_NAME#\"}"
fi

if [[ -z "$CURRENT_NAME" || "$CURRENT_NAME" == "<YOUR NODE NAME>" || ${#CURRENT_NAME} -lt 16 ]]; then
  echo "Your Synaptron node needs a NAME of at least 16 characters."
  echo "This will be visible in Timpi tools / logs."
  while true; do
    read -r -p "Enter Synaptron node name (>=16 chars, you can paste it here): " NODE_NAME
    NODE_NAME="${NODE_NAME#" "}"
    NODE_NAME="${NODE_NAME%" "}"
    if [[ ${#NODE_NAME} -lt 16 ]]; then
      echo "❌ Name too short (${#NODE_NAME} chars). Please enter at least 16 characters."
      continue
    fi
    break
  done
  echo "✅ Using node name: $NODE_NAME"
  # Update NAME line in YAML (keep two-space indent)
  sed -i "s#^\s*NAME:.*#  NAME: \"${NODE_NAME}\"#" "$YML_FILE"
else
  echo "✅ Existing node name detected: $CURRENT_NAME"
fi

###########################################################
# Patch ARCH + image tag in YAML
###########################################################
sed -i "s/^  ARCH:.*/  ARCH: ${ARCH}/" "$YML_FILE" || true
sed -i "s#timpiltd/timpi-synaptron-universal:cuda[0-9]\+#timpiltd/timpi-synaptron-universal:${CUDA_TAG}#g" "$YML_FILE"

###########################################################
# Start Synaptron
###########################################################
echo
echo "🚀 Starting Synaptron..."
docker compose -f "$YML_FILE" up --pull=always -d

echo
echo "========================================="
echo "   ✅ Synaptron is now running"
echo "========================================="
echo
echo "Logs:"
echo "  docker logs -f synaptron_universal"
echo
