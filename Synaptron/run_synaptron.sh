#!/usr/bin/env bash
set -euo pipefail

###########################################################
# Timpi Synaptron – Auto Installer / Runner (Linux Only)
# Ubuntu 22.04+ with NVIDIA GPU
# Maintainer: johnolofs
#
# This script:
#  - Blocks Snap Docker
#  - Validates Docker & Docker Compose >= 2.23
#  - Checks that your user can talk to the Docker daemon
#  - Detects CUDA version and selects ARCH (t3_cuda24 / t3_cuda28)
#  - Automatically patches docker-compose.yml
#  - Auto-downloads docker-compose.yml if missing
#  - Starts full stack with auto-update (watchtower)
###########################################################

REPO_BASE="https://raw.githubusercontent.com/johnolofs/timpi/main/Synaptron"
YML_FILE="docker-compose.yml"

echo "===== Timpi Synaptron – Linux Installer ====="
echo

###########################################################
# Always run from the folder containing the script
###########################################################
cd "$(dirname "$0")"

###########################################################
# 1) Ensure docker-compose.yml exists (auto-download)
###########################################################
if [[ ! -f "$YML_FILE" ]]; then
  echo "📄 docker-compose.yml not found — downloading latest version..."
  curl -fsS -O "${REPO_BASE}/${YML_FILE}"
fi


###########################################################
# 2) BLOCK SNAP DOCKER
###########################################################
if command -v snap >/dev/null 2>&1 && snap list 2>/dev/null | grep -q "^docker "; then
  echo
  echo "❌ ERROR: Snap Docker detected."
  echo "Snap Docker CANNOT be used with Synaptron (watchtower + GPU will break)."
  echo
  echo "➡ Remove Snap Docker:"
  echo "   sudo snap remove docker"
  echo
  echo "➡ Then install official Docker:"
  echo "   curl -fsSL https://get.docker.com | sudo bash"
  echo
  exit 1
fi


###########################################################
# 3) Validate Docker + Docker Compose version
###########################################################
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ ERROR: Docker is not installed."
  echo "Install it using:"
  echo "  curl -fsSL https://get.docker.com | sudo bash"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "❌ ERROR: 'docker compose' command not found."
  echo "You need Docker Compose v2 (comes with modern Docker)."
  exit 1
fi

COMPOSE_VERSION="$(docker compose version --short)"
REQUIRED_COMPOSE="2.23.0"

version_ge() {
  # returns true if version $2 >= version $1
  [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" == "$1" ]]
}

if ! version_ge "$REQUIRED_COMPOSE" "$COMPOSE_VERSION"; then
  echo "❌ Docker Compose is too old: ${COMPOSE_VERSION}"
  echo "Must be >= ${REQUIRED_COMPOSE}"
  exit 1
fi

echo "✅ Docker Compose OK: ${COMPOSE_VERSION}"


###########################################################
# 3b) Check Docker daemon + permissions
###########################################################
DOCKER_PS_OUTPUT=""
DOCKER_PS_STATUS=0

# Try a simple docker command
if ! DOCKER_PS_OUTPUT="$(docker ps >/dev/null 2>&1)"; then
  DOCKER_PS_STATUS=$?
else
  DOCKER_PS_STATUS=0
fi

if [[ $DOCKER_PS_STATUS -ne 0 ]]; then
  echo
  echo "❌ ERROR: Cannot talk to the Docker daemon as user '$USER'."
  echo

  # Check if user is in 'docker' group
  if id -nG "$USER" | grep -qw docker; then
    echo "It looks like your user IS in the 'docker' group."
    echo "This usually means the Docker daemon is not running."
    echo
    echo "➡ Check Docker service:"
    echo "   sudo systemctl status docker"
    echo
    echo "➡ Start Docker if needed:"
    echo "   sudo systemctl start docker"
    echo
  else
    echo "Your user is NOT in the 'docker' group."
    echo "You must add yourself to the group so you can run Docker without sudo."
    echo
    echo "➡ Add your user to the docker group:"
    echo "   sudo usermod -aG docker $USER"
    echo
    echo "➡ Then log out and back in, OR run:"
    echo "   newgrp docker"
    echo
  fi

  echo "After fixing this, run the installer again:"
  echo "  ./run_synaptron.sh"
  echo
  exit 1
fi

echo "✅ Docker daemon is reachable and permissions look OK."


###########################################################
# 4) Detect Docker API version (for DOCKER_API_VERSION=1.44)
###########################################################
API_VERSION="$(docker version -f '{{.Server.APIVersion}}' 2>/dev/null || echo "unknown")"
echo "ℹ️  Docker API version: ${API_VERSION}"


###########################################################
# 5) Detect CUDA version → Set ARCH (t3_cuda24 / t3_cuda28)
###########################################################
ARCH="t3_cuda24"  # fallback default
CUDA_INFO=""

if command -v nvidia-smi >/dev/null 2>&1; then
  CUDA_LINE="$(nvidia-smi | grep 'CUDA Version' || true)"

  if [[ -n "$CUDA_LINE" ]]; then
    CUDA_INFO="$(echo "$CUDA_LINE" | sed -E 's/.*CUDA Version: ([0-9]+\.[0-9]+).*/\1/')"
    CUDA_MAJOR="${CUDA_INFO%%.*}"
    CUDA_MINOR="${CUDA_INFO#*.}"

    echo "🔎 Detected CUDA version: ${CUDA_INFO}"

    # Selecting ARCH:
    # CUDA 12.8+  => t3_cuda28
    # CUDA 12.0–12.7 => t3_cuda24
    if [[ "$CUDA_MAJOR" -gt 12 ]] || { [[ "$CUDA_MAJOR" -eq 12 ]] && [[ "$CUDA_MINOR" -ge 8 ]]; }; then
      ARCH="t3_cuda28"
    else
      ARCH="t3_cuda24"
    fi
  else
    echo "⚠️  No CUDA version reported by nvidia-smi. Using ARCH=${ARCH}"
  fi
else
  echo "⚠️  NVIDIA driver not detected (nvidia-smi missing)."
  echo "    Using fallback ARCH=${ARCH}"
fi

echo "🏗  Using Synaptron ARCH: ${ARCH}"


###########################################################
# 6) Patch ARCH line inside docker-compose.yml
###########################################################
if grep -q '^  ARCH:' "$YML_FILE"; then
  sed -i "s/^  ARCH:.*/  ARCH: ${ARCH}/" "$YML_FILE"
else
  sed -i "s/ARCH: .*/ARCH: ${ARCH}/" "$YML_FILE" || true
fi


###########################################################
# 7) Start Synaptron (with auto-update)
###########################################################
echo
echo "🚀 Starting / Updating Synaptron stack..."
echo "   (synaptron_universal + neo4j + watchtower)"
echo

docker compose -f "$YML_FILE" up --pull=always -d

echo
echo "========================================="
echo "   ✅ Synaptron stack is now running"
echo "========================================="
echo
echo "📌 Check containers:"
echo "    docker ps"
echo
echo "📌 Follow Synaptron logs:"
echo "    docker logs -f synaptron_universal"
echo
echo "📌 Follow Watchtower logs:"
echo "    docker logs -f watchtower"
echo
echo "📌 To restart manually:"
echo "    ./run_synaptron.sh"
echo
