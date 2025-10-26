#!/bin/bash
# Enhanced DevPod Management Script Template
# Usage: ./manage-devpod.sh [start|stop|restart|status|logs|ssh|delete|clean-start]

set -e

# Project Configuration - Override these in each project
PROJECT_NAME="${PROJECT_NAME:-generic-project}"
WORKSPACE_ID="${WORKSPACE_ID:-generic-devpod-workspace}"
PROJECT_PORT="${PROJECT_PORT:-8080}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $CYAN "================================================"
    print_color $CYAN "$1"
    print_color $CYAN "================================================"
    echo ""
}

check_devpod() {
    if ! command -v devpod &> /dev/null; then
        print_color $RED "❌ DevPod CLI not found. Please install it first."
        print_color $YELLOW "Run: ../../install-devpod.sh"
        exit 1
    fi
}

check_docker() {
    if ! docker info &> /dev/null; then
        print_color $RED "❌ Docker is not running. Please start Docker."
        exit 1
    fi
}

check_port_conflict() {
    if command -v lsof &> /dev/null; then
        if lsof -i :$PROJECT_PORT &> /dev/null; then
            print_color $YELLOW "⚠️  Port $PROJECT_PORT is already in use"
            print_color $BLUE "🔍 Processes using port $PROJECT_PORT:"
            lsof -i :$PROJECT_PORT
            echo ""
            print_color $YELLOW "💡 Consider stopping conflicting services or running 'manage-devpod.sh clean-start'"
            return 1
        fi
    fi
    return 0
}

workspace_exists() {
    devpod workspace list 2>/dev/null | grep -q "$WORKSPACE_ID" 2>/dev/null
}

workspace_running() {
    if workspace_exists; then
        local status
        status=$(devpod status "$WORKSPACE_ID" 2>/dev/null | grep -i "running\|up" || echo "")
        [[ -n "$status" ]]
    else
        return 1
    fi
}

stop_conflicting_workspaces() {
    print_color $YELLOW "🔍 Checking for running workspaces that might conflict..."
    
    # Get list of all running workspaces
    local running_workspaces
    running_workspaces=$(devpod workspace list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    
    if [[ -n "$running_workspaces" ]]; then
        echo "$running_workspaces" | while read -r workspace; do
            if [[ -n "$workspace" && "$workspace" != "$WORKSPACE_ID" ]]; then
                local ws_status
                ws_status=$(devpod status "$workspace" 2>/dev/null | grep -i "running\|up" || echo "")
                if [[ -n "$ws_status" ]]; then
                    print_color $YELLOW "🛑 Stopping conflicting workspace: $workspace"
                    devpod stop "$workspace" 2>/dev/null || print_color $YELLOW "⚠️  Could not stop $workspace"
                fi
            fi
        done
    fi
}

start_workspace() {
    print_header "🚀 Starting $PROJECT_NAME DevPod Environment"
    
    check_devpod
    check_docker
    
    print_color $BLUE "📦 Project: $PROJECT_NAME"
    print_color $BLUE "🆔 Workspace ID: $WORKSPACE_ID"
    print_color $BLUE "🌐 Port: $PROJECT_PORT"
    echo ""
    
    # Check if workspace already exists and is running
    if workspace_running; then
        print_color $GREEN "✅ Workspace '$WORKSPACE_ID' is already running"
        print_color $BLUE "ℹ️  Use 'restart' to restart or 'stop' to stop it"
        print_endpoints
        return 0
    fi
    
    # Stop conflicting workspaces
    stop_conflicting_workspaces
    
    # Check port conflicts
    if ! check_port_conflict; then
        print_color $YELLOW "⚠️  Port conflict detected. Use 'clean-start' to force cleanup."
        exit 1
    fi
    
    # Stop existing workspace if it exists but not running
    if workspace_exists; then
        print_color $YELLOW "🛑 Stopping existing workspace..."
        devpod stop "$WORKSPACE_ID" 2>/dev/null || true
        sleep 2
    fi
    
    print_color $YELLOW "🏗️  Starting DevPod workspace..."
    devpod up . --id "$WORKSPACE_ID" --ide vscode
    
    echo ""
    print_color $GREEN "✅ $PROJECT_NAME DevPod environment started successfully!"
    print_endpoints
}

stop_workspace() {
    print_header "🛑 Stopping $PROJECT_NAME DevPod Environment"
    
    check_devpod
    
    if workspace_exists; then
        print_color $YELLOW "🛑 Stopping DevPod workspace..."
        devpod stop "$WORKSPACE_ID"
        print_color $GREEN "✅ Workspace stopped successfully!"
    else
        print_color $YELLOW "⚠️  Workspace '$WORKSPACE_ID' not found or already stopped"
    fi
}

restart_workspace() {
    print_header "🔄 Restarting $PROJECT_NAME DevPod Environment"
    
    if workspace_exists; then
        stop_workspace
        sleep 3
    fi
    start_workspace
}

clean_start_workspace() {
    print_header "🧹 Clean Start $PROJECT_NAME DevPod Environment"
    
    check_devpod
    check_docker
    
    print_color $YELLOW "🧹 Performing clean start (stopping all conflicting workspaces)..."
    
    # Stop all running workspaces
    print_color $YELLOW "🛑 Stopping all running DevPod workspaces..."
    local workspaces
    workspaces=$(devpod workspace list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    
    if [[ -n "$workspaces" ]]; then
        echo "$workspaces" | while read -r workspace; do
            if [[ -n "$workspace" ]]; then
                print_color $YELLOW "🛑 Stopping workspace: $workspace"
                devpod stop "$workspace" 2>/dev/null || true
            fi
        done
    fi
    
    # Kill processes on our port if needed
    if command -v lsof &> /dev/null && lsof -i :$PROJECT_PORT &> /dev/null; then
        print_color $YELLOW "🔄 Killing processes on port $PROJECT_PORT..."
        local pids
        pids=$(lsof -ti :$PROJECT_PORT)
        if [[ -n "$pids" ]]; then
            echo "$pids" | xargs kill -9 2>/dev/null || true
        fi
    fi
    
    sleep 2
    
    # Delete existing workspace if it exists
    if workspace_exists; then
        print_color $YELLOW "🗑️  Deleting existing workspace for clean start..."
        devpod delete "$WORKSPACE_ID" --force 2>/dev/null || true
        sleep 2
    fi
    
    # Start fresh
    print_color $YELLOW "🚀 Starting fresh workspace..."
    devpod up . --id "$WORKSPACE_ID" --ide vscode
    
    echo ""
    print_color $GREEN "✅ $PROJECT_NAME clean start completed successfully!"
    print_endpoints
}

workspace_status() {
    print_header "📊 $PROJECT_NAME DevPod Workspace Status"
    
    check_devpod
    
    if workspace_exists; then
        print_color $GREEN "✅ Workspace '$WORKSPACE_ID' found"
        echo ""
        devpod workspace list | head -1  # Header
        devpod workspace list | grep "$WORKSPACE_ID" || true
        echo ""
        
        # Get detailed status
        print_color $BLUE "🔍 Detailed Status:"
        devpod status "$WORKSPACE_ID" 2>/dev/null || print_color $YELLOW "⚠️  Could not get detailed status"
        
        # Check port
        echo ""
        if command -v lsof &> /dev/null; then
            if lsof -i :$PROJECT_PORT &> /dev/null; then
                print_color $GREEN "🌐 Port $PROJECT_PORT is in use (service likely running)"
            else
                print_color $YELLOW "⚠️  Port $PROJECT_PORT is not in use"
            fi
        fi
    else
        print_color $RED "❌ Workspace '$WORKSPACE_ID' not found"
        echo ""
        print_color $BLUE "📋 Available workspaces:"
        devpod workspace list 2>/dev/null || print_color $YELLOW "No workspaces available"
    fi
}

workspace_logs() {
    print_header "📜 $PROJECT_NAME DevPod Workspace Logs"
    
    check_devpod
    
    if workspace_exists; then
        devpod logs "$WORKSPACE_ID"
    else
        print_color $RED "❌ Workspace '$WORKSPACE_ID' not found"
    fi
}

ssh_workspace() {
    print_header "🔗 SSH into $PROJECT_NAME DevPod Workspace"
    
    check_devpod
    
    if workspace_exists; then
        print_color $BLUE "🔗 Connecting to '$WORKSPACE_ID'..."
        devpod ssh "$WORKSPACE_ID"
    else
        print_color $RED "❌ Workspace '$WORKSPACE_ID' not found"
        print_color $YELLOW "💡 Run 'manage-devpod.sh start' first"
    fi
}

delete_workspace() {
    print_header "🗑️  Delete $PROJECT_NAME DevPod Workspace"
    
    check_devpod
    
    if workspace_exists; then
        print_color $YELLOW "⚠️  This will permanently delete workspace '$WORKSPACE_ID'"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_color $YELLOW "🗑️  Deleting workspace '$WORKSPACE_ID'..."
            devpod delete "$WORKSPACE_ID" --force
            print_color $GREEN "✅ Workspace '$WORKSPACE_ID' deleted successfully"
        else
            print_color $BLUE "ℹ️  Operation cancelled"
        fi
    else
        print_color $YELLOW "⚠️  Workspace '$WORKSPACE_ID' not found"
    fi
}

# Override this function in each project's script
print_endpoints() {
    echo ""
    print_color $GREEN "📋 Available endpoints:"
    print_color $GREEN "   🌐 Main API: http://localhost:$PROJECT_PORT"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   (Define project-specific commands here)"
    echo ""
    print_color $BLUE "🛠️  Workspace management:"
    print_color $BLUE "   ./manage-devpod.sh stop    - Stop workspace"
    print_color $BLUE "   ./manage-devpod.sh restart - Restart workspace"
    print_color $BLUE "   ./manage-devpod.sh ssh     - SSH into workspace"
    print_color $BLUE "   ./manage-devpod.sh logs    - View logs"
}

print_help() {
    print_header "$PROJECT_NAME DevPod Management Script"
    
    echo "Usage: $0 [command]"
    echo ""
    echo "📋 Workspace Commands:"
    echo "  start        Start the DevPod workspace (default)"
    echo "  stop         Stop the DevPod workspace"
    echo "  restart      Restart the DevPod workspace"
    echo "  clean-start  Stop all workspaces and start fresh"
    echo "  status       Show workspace status"
    echo "  logs         Show workspace logs"
    echo "  ssh          SSH into the workspace"
    echo "  delete       Delete the workspace"
    echo "  help         Show this help message"
    echo ""
    echo "💡 Examples:"
    echo "  $0 start         # Start the workspace"
    echo "  $0 stop          # Stop the workspace"
    echo "  $0 restart       # Restart the workspace"
    echo "  $0 clean-start   # Force clean start (resolves conflicts)"
    echo "  $0 status        # Check workspace status"
    echo ""
    print_color $CYAN "🔧 Global DevPod Utilities:"
    print_color $CYAN "   ../devpod-utils.sh         # Global workspace management"
    print_color $CYAN "   ../devpod-utils.sh list    # List all workspaces"
    print_color $CYAN "   ../devpod-utils.sh stop-all # Stop all workspaces"
}

# Main execution
case "${1:-start}" in
    start)
        start_workspace
        ;;
    stop)
        stop_workspace
        ;;
    restart)
        restart_workspace
        ;;
    clean-start|cleanstart|clean)
        clean_start_workspace
        ;;
    status)
        workspace_status
        ;;
    logs)
        workspace_logs
        ;;
    ssh)
        ssh_workspace
        ;;
    delete|del)
        delete_workspace
        ;;
    help|--help|-h)
        print_help
        ;;
    *)
        print_color $RED "❌ Unknown command: $1"
        print_help
        exit 1
        ;;
esac