#!/usr/bin/env bash
set -euo pipefail

YML="docker-compose.yml"

echo "===== Synaptron Launcher ====="

# -----------------------------
# 1. Detect snap Docker (not allowed)
# -----------------------------
if command -v snap >/dev/null 2>&1 && snap list | grep -q '^docker '; then
    echo "ERROR: You are running SNAP Docker."
    echo "Snap Docker cannot work with watchtower (no access to docker.sock)."
    echo "Please uninstall snap docker and install real Docker:"
    echo "  sudo snap remove docker"
    echo "  curl -fsSL https://get.docker.com | sudo bash"
    exit 1
fi

# -----------------------------
# 2. Check Docker Compose version
# -----------------------------
if ! command -v docker >/dev/null; then
    echo "ERROR: Docker not installed."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "ERROR: Docker Compose v2 not found."
    exit 1
fi

COMPOSE_VERSION=$(docker compose version --short)
REQUIRED_VERSION="2.23.0"

version_ok() {
    [ "$(printf '%s\n' "$REQUIRED_VERSION" "$COMPOSE_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]
}

if ! version_ok; then
    echo "ERROR: Docker Compose version $COMPOSE_VERSION is too old."
    echo "Need: >= $REQUIRED_VERSION"
    exit 1
fi

echo "Docker Compose version OK: $COMPOSE_VERSION"

# -----------------------------
# 3. Detect Docker API version for DOCKER_API_VERSION
# -----------------------------
API_VERSION=$(docker version -f '{{.Server.APIVersion}}')

echo "Detected Docker API: $API_VERSION"

if [[ "$API_VERSION" != "1.44" ]]; then
    echo "Docker API != 1.44 → leaving DOCKER_API_VERSION unchanged."
else
    echo "Docker API = 1.44 → DOCKER_API_VERSION is required."
fi

# -----------------------------
# 4. Detect CUDA version (for ARCH)
# -----------------------------
ARCH="t3_cuda24"  # default

if command -v nvidia-smi >/dev/null 2>&1; then
    LINE=$(nvidia-smi | grep "CUDA Version" || true)
    if [[ -n "$LINE" ]]; then
        CUDA=$(echo "$LINE" | sed -E 's/.*CUDA Version: ([0-9]+\.[0-9]+).*/\1/')
        CUDA_MAJOR=${CUDA%%.*}

        echo "Detected CUDA: $CUDA"

        # 12.8 or newer → use cuda28
        if (( $(echo "$CUDA >= 12.8" | bc -l) )); then
            ARCH="t3_cuda28"
        else
            ARCH="t3_cuda24"
        fi
    fi
fi

echo "Final ARCH selected: $ARCH"

# -----------------------------
# 5. Patch YAML with ARCH
# -----------------------------
sed -i "s/ARCH: .*/ARCH: ${ARCH}/" "$YML"

# -----------------------------
# 6. Launch Synaptron with auto-pull
# -----------------------------
echo "Launching Synaptron with auto-update enabled (watchtower + pull always)..."
docker compose -f "$YML" up --pull=always -d

echo "Synaptron started successfully!"
