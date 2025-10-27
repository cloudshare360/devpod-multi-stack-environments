#!/bin/bash

echo "🩺 DevPod Health Check"
echo "======================"
echo ""

# Check DevPod installation
echo "📦 DevPod Installation:"
if command -v devpod &> /dev/null; then
    echo "  ✅ DevPod installed: $(devpod version)"
else
    echo "  ❌ DevPod not found"
    exit 1
fi
echo ""

# Check Docker (main provider)
echo "🐳 Docker Status:"
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        echo "  ✅ Docker running: $(docker version --format '{{.Server.Version}}')"
        echo "  💾 Docker disk usage:"
        docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Size}}\t{{.Reclaimable}}" | head -n 5
    else
        echo "  ❌ Docker not running"
    fi
else
    echo "  ❌ Docker not installed"
fi
echo ""

# Check DevPod contexts
echo "🎯 DevPod Contexts:"
devpod context list
echo ""

# Check providers
echo "🔌 DevPod Providers:"
devpod provider list
echo ""

# Check workspaces
echo "🏠 DevPod Workspaces:"
devpod list
echo ""

# Check for common issues
echo "🔍 Common Issues Check:"

# Check disk space
available_space=$(df / | awk 'NR==2 {print $4}')
if [ "$available_space" -lt 1048576 ]; then  # Less than 1GB
    echo "  ⚠️  Low disk space: $(df -h / | awk 'NR==2 {print $4}') available"
else
    echo "  ✅ Sufficient disk space: $(df -h / | awk 'NR==2 {print $4}') available"
fi

# Check if user is in docker group
if groups $USER | grep -q docker; then
    echo "  ✅ User in docker group"
else
    echo "  ⚠️  User not in docker group (may need sudo for docker)"
fi

echo ""
echo "🎉 Health check complete!"
echo ""
echo "💡 Troubleshooting tips:"
echo "  - For workspace issues: devpod logs <workspace-name>"
echo "  - For system issues: devpod logs-daemon"
echo "  - For Docker issues: docker system info"
echo "  - To restart DevPod: devpod stop <workspace> && devpod up <workspace>"