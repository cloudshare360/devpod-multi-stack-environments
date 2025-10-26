#!/bin/bash
# DevPod Browser Workspace Management Script
# Usage: ./devpod-browser.sh [start|stop|restart|status|logs|ssh]

set -e

PROJECT_NAME="nodejs-project"
WORKSPACE_ID="nodejs-devpod-workspace"
BROWSER_IDE="openvscode"  # VS Code in browser
PROVIDER="docker"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 DevPod Browser Workspace Manager${NC}"
echo -e "${BLUE}=====================================${NC}"

# Function to check if DevPod is installed
check_devpod() {
    if ! command -v devpod &> /dev/null; then
        echo -e "${RED}❌ DevPod CLI not found. Please install it first.${NC}"
        echo "Install: curl -L -o devpod https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64 && sudo install -c -m 0755 devpod /usr/local/bin"
        exit 1
    fi
    echo -e "${GREEN}✅ DevPod CLI found${NC}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker is not running. Please start Docker.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker is running${NC}"
}

# Function to start the workspace
start_workspace() {
    echo -e "${YELLOW}🏗️  Starting DevPod workspace in browser...${NC}"
    echo "📦 Project: $PROJECT_NAME"
    echo "🆔 Workspace ID: $WORKSPACE_ID"
    echo "🌐 IDE: $BROWSER_IDE (VS Code in Browser)"
    echo "🐳 Provider: $PROVIDER"
    echo ""
    
    # Start DevPod workspace with browser IDE
    devpod up . \
        --id "$WORKSPACE_ID" \
        --ide "$BROWSER_IDE" \
        --provider "$PROVIDER" \
        --debug
    
    echo ""
    echo -e "${GREEN}✅ DevPod workspace started successfully!${NC}"
    echo ""
    echo -e "${BLUE}📋 Available endpoints:${NC}"
    echo "   🌐 VS Code Browser: Check DevPod output above for URL"
    echo "   🚀 API Server: http://localhost:3000"
    echo "   ❤️  Health Check: http://localhost:3000/health"
    echo "   👥 Users API: http://localhost:3000/api/users"
    echo ""
    echo -e "${BLUE}📝 Development commands (run inside VS Code terminal):${NC}"
    echo "   npm run dev     - Start development server"
    echo "   npm run test    - Run tests"
    echo "   npm run lint    - Check code quality"
    echo "   npm run format  - Format code"
    echo ""
    echo -e "${BLUE}🛠️  Management commands:${NC}"
    echo "   ./devpod-browser.sh stop    - Stop workspace"
    echo "   ./devpod-browser.sh ssh     - SSH into workspace"
    echo "   ./devpod-browser.sh logs    - View logs"
    echo "   ./devpod-browser.sh status  - Check status"
}

# Function to stop the workspace
stop_workspace() {
    echo -e "${YELLOW}🛑 Stopping DevPod workspace...${NC}"
    devpod stop "$WORKSPACE_ID"
    echo -e "${GREEN}✅ Workspace stopped${NC}"
}

# Function to restart the workspace
restart_workspace() {
    echo -e "${YELLOW}🔄 Restarting DevPod workspace...${NC}"
    stop_workspace
    sleep 2
    start_workspace
}

# Function to show workspace status
show_status() {
    echo -e "${BLUE}📊 Workspace Status:${NC}"
    devpod list
    echo ""
    echo -e "${BLUE}🔍 Workspace Details:${NC}"
    devpod status "$WORKSPACE_ID" || echo "Workspace not found or not running"
}

# Function to show logs
show_logs() {
    echo -e "${BLUE}📜 Workspace Logs:${NC}"
    devpod logs "$WORKSPACE_ID"
}

# Function to SSH into workspace
ssh_workspace() {
    echo -e "${BLUE}🔗 Connecting to workspace...${NC}"
    devpod ssh "$WORKSPACE_ID"
}

# Function to delete workspace
delete_workspace() {
    echo -e "${RED}🗑️  Deleting workspace...${NC}"
    read -p "Are you sure you want to delete the workspace? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        devpod delete "$WORKSPACE_ID"
        echo -e "${GREEN}✅ Workspace deleted${NC}"
    else
        echo "Deletion cancelled"
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     - Start the DevPod workspace in browser"
    echo "  stop      - Stop the workspace"
    echo "  restart   - Restart the workspace"
    echo "  status    - Show workspace status"
    echo "  logs      - Show workspace logs"
    echo "  ssh       - SSH into the workspace"
    echo "  delete    - Delete the workspace"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start workspace in browser"
    echo "  $0 stop     # Stop workspace"
    echo "  $0 ssh      # Connect to workspace via SSH"
}

# Main script logic
case "${1:-start}" in
    "start")
        check_devpod
        check_docker
        start_workspace
        ;;
    "stop")
        check_devpod
        stop_workspace
        ;;
    "restart")
        check_devpod
        check_docker
        restart_workspace
        ;;
    "status")
        check_devpod
        show_status
        ;;
    "logs")
        check_devpod
        show_logs
        ;;
    "ssh")
        check_devpod
        ssh_workspace
        ;;
    "delete")
        check_devpod
        delete_workspace
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac