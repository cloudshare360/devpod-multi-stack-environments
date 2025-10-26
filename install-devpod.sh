#!/bin/bash
# DevPod CLI Installation Script for Ubuntu/Debian
# Usage: chmod +x install-devpod.sh && ./install-devpod.sh

set -e

echo "🚀 DevPod CLI Installation Script"
echo "=================================="

# Check if running on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ This script is designed for Ubuntu/Debian systems"
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root" 
   exit 1
fi

# Update system packages
echo "📦 Updating system packages..."
sudo apt update

# Install required dependencies
echo "🔧 Installing dependencies..."
sudo apt install -y curl wget gnupg2 software-properties-common jq

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "⚠️  Please log out and log back in for Docker group changes to take effect"
    rm get-docker.sh
else
    echo "✅ Docker is already installed"
fi

# Download and install DevPod CLI
echo "⬇️  Downloading DevPod CLI..."
DEVPOD_VERSION=$(curl -s https://api.github.com/repos/loft-sh/devpod/releases/latest | jq -r '.tag_name')
DEVPOD_URL="https://github.com/loft-sh/devpod/releases/download/${DEVPOD_VERSION}/devpod-linux-amd64"

echo "📥 Downloading DevPod version: $DEVPOD_VERSION"
curl -L "${DEVPOD_URL}" -o devpod
chmod +x devpod

# Move to system path
sudo mv devpod /usr/local/bin/

# Verify installation
echo "✅ Verifying installation..."
if devpod version; then
    echo "🎉 DevPod CLI installed successfully!"
    echo "📌 Version: $(devpod version)"
else
    echo "❌ Installation failed"
    exit 1
fi

# Add to PATH if not already present
if ! echo $PATH | grep -q "/usr/local/bin"; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    echo "📝 Added /usr/local/bin to PATH in ~/.bashrc"
fi

# Initialize DevPod
echo "🔧 Initializing DevPod..."
devpod provider add docker --use

echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "   1. Reload your shell: source ~/.bashrc"
echo "   2. Verify Docker is working: docker --version"
echo "   3. Create your first workspace: devpod up <directory>"
echo ""
echo "📚 Documentation: https://devpod.sh/docs"
echo "🆘 Help: devpod --help"