#!/usr/bin/env bash
set -euo pipefail

###########################################################
# Timpi Synaptron – Auto Installer / Runner (Linux Only)
# Ubuntu 22.04+ with NVIDIA GPU
# Maintainer: johnolofs (Private repo pre-release)
#
# This script:
#  - Blocks Snap Docker
#  - Validates Docker & Docker Compose
#  - Checks Docker daemon permissions
#  - Detects CUDA version and selects ARCH (t3_cuda24 / t3_cuda28)
#  - Detects NVIDIA driver/library mismatch
#  - Detects missing/broken toolkit
#  - Detects GPU visibility inside Docker
#  - Chooses matching Docker image tag (cuda24 / cuda28)
#  - Auto-downloads docker-compose.yml
#  - Auto-patches docker-compose.yml
#  - Launches full Synaptron stack (watchtower + neo4j + synaptron)
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

# 1) Does nvidia-smi work at all?
NVIDIA_ERROR=""
if ! NVIDIA_ERROR="$(nvidia-smi 2>&1 | grep -i 'Failed' || true)"; then
  echo ""
fi

if [[ -n "$NVIDIA_ERROR" ]]; then
  echo
  echo "❌ NVIDIA driver is broken!"
  echo "$NVIDIA_ERROR"
  echo
  echo "This means your NVIDIA installation is corrupted or mismatched."
  echo "Synaptron CANNOT run until this is fixed."
  echo
  echo "Fix steps:"
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

# 2) Extract CUDA version
CUDA_LINE="$(nvidia-smi | grep 'CUDA Version' || true)"
CUDA_INFO=""
ARCH="t3_cuda24"
CUDA_TAG="cuda24"

if [[ -n "$CUDA_LINE" ]]; then
  CUDA_INFO="$(echo "$CUDA_LINE" | sed -E 's/.*CUDA Version: ([0-9]+\.[0-9]+).*/\1/')"
  CUDA_MAJOR="${CUDA_INFO%%.*}"
  CUDA_MINOR="${CUDA_INFO#*.}"

  echo "   Detected CUDA: $CUDA_INFO"

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
