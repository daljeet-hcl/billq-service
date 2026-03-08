#!/bin/bash
# Quick testing script to verify devcontainers work with both Docker and Podman

set -e

CONTAINER_NAME="billq-test"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================"
echo "billq-service Devcontainer Test"
echo "================================"
echo

# Test Docker
echo "[1] Testing with Docker..."
echo "================================"

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Install it from https://docker.com"
else
    echo "✓ Docker found: $(docker --version)"
    
    echo "Building with Docker..."
    docker build -t "$CONTAINER_NAME:docker" "$PROJECT_DIR/.devcontainer"
    
    echo "Testing Docker container..."
    docker run --rm -v "$PROJECT_DIR:/workspace" "$CONTAINER_NAME:docker" \
        bash -c "java -version && mvn --version && echo '✓ Docker test passed'"
fi

echo
echo "[2] Testing with Podman..."
echo "================================"

if ! command -v podman &> /dev/null; then
    echo "❌ Podman not found. Install it from https://podman.io"
else
    echo "✓ Podman found: $(podman --version)"
    
    # Check if podman machine is needed (macOS/Windows)
    if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "msys" ]]; then
        echo "Starting Podman machine..."
        podman machine start 2>/dev/null || true
        sleep 2
    fi
    
    echo "Building with Podman..."
    podman build -t "$CONTAINER_NAME:podman" "$PROJECT_DIR/.devcontainer"
    
    echo "Testing Podman container..."
    podman run --rm -v "$PROJECT_DIR:/workspace" "$CONTAINER_NAME:podman" \
        bash -c "java -version && mvn --version && echo '✓ Podman test passed'"
fi

echo
echo "================================"
echo "✓ Testing complete!"
echo "================================"
echo
echo "Next steps:"
echo "1. For VS Code Dev Containers with Docker (default):"
echo "   - Open folder in VS Code"
echo "   - Ctrl+Shift+P → 'Dev Containers: Reopen in Container'"
echo
echo "2. For VS Code Dev Containers with Podman:"
echo "   - VS Code Settings (Ctrl+,)"
echo "   - Search: 'dev containers docker path'"
echo "   - Set to: 'podman'"
echo "   - Ctrl+Shift+P → 'Dev Containers: Reopen in Container'"
echo
