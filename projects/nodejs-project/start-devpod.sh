#!/bin/bash
# Node.js Project DevPod Launcher
# Usage: ./start-devpod.sh

set -e

PROJECT_NAME="nodejs-project"
WORKSPACE_ID="nodejs-devpod-workspace"

echo "🚀 Starting Node.js DevPod Environment"
echo "======================================"

# Check if DevPod is installed
if ! command -v devpod &> /dev/null; then
    echo "❌ DevPod CLI not found. Please install it first."
    echo "Run: ../install-devpod.sh"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker."
    exit 1
fi

echo "📦 Project: $PROJECT_NAME"
echo "🆔 Workspace ID: $WORKSPACE_ID"
echo ""

# Start DevPod workspace
echo "🏗️  Starting DevPod workspace..."
devpod up . --id "$WORKSPACE_ID" --ide vscode

echo ""
echo "✅ Node.js DevPod environment started successfully!"
echo ""
echo "📋 Available endpoints:"
echo "   🌐 Main API: http://localhost:3000"
echo "   ❤️  Health Check: http://localhost:3000/health"
echo "   👥 Users API: http://localhost:3000/api/users"
echo ""
echo "📝 Development commands:"
echo "   npm run dev     - Start development server"
echo "   npm run test    - Run tests"
echo "   npm run lint    - Check code quality"
echo "   npm run format  - Format code"
echo ""
echo "🛠️  To manage workspace:"
echo "   devpod stop $WORKSPACE_ID"
echo "   devpod ssh $WORKSPACE_ID"
echo "   devpod logs $WORKSPACE_ID"