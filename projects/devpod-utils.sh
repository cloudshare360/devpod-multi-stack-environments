#!/bin/bash
# DevPod Workspace Utilities
# Global utility script for managing DevPod workspaces
# Usage: ./devpod-utils.sh [command] [workspace-id]

set -e

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
        print_color $YELLOW "Run: ../install-devpod.sh"
        exit 1
    fi
}

check_docker() {
    if ! docker info &> /dev/null; then
        print_color $RED "❌ Docker is not running. Please start Docker."
        exit 1
    fi
}

list_workspaces() {
    print_header "📋 DevPod Workspaces"
    
    check_devpod
    
    print_color $BLUE "🔍 Listing all DevPod workspaces..."
    echo ""
    
    if devpod workspace list 2>/dev/null | grep -q "NAME"; then
        devpod workspace list
    else
        print_color $YELLOW "⚠️  No workspaces found or DevPod not properly configured."
    fi
    
    echo ""
    print_color $CYAN "💡 Tip: Use 'devpod-utils.sh status <workspace-id>' for detailed status"
}

workspace_status() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 status <workspace-id>"
        exit 1
    fi
    
    print_header "📊 Workspace Status: $workspace_id"
    
    check_devpod
    
    if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
        print_color $GREEN "✅ Workspace '$workspace_id' found"
        echo ""
        devpod workspace list | head -1  # Header
        devpod workspace list | grep "$workspace_id" || true
        echo ""
        
        # Get detailed status
        print_color $BLUE "🔍 Detailed Status:"
        devpod status "$workspace_id" 2>/dev/null || print_color $YELLOW "⚠️  Could not get detailed status"
    else
        print_color $RED "❌ Workspace '$workspace_id' not found"
        echo ""
        print_color $BLUE "📋 Available workspaces:"
        devpod workspace list 2>/dev/null || print_color $YELLOW "No workspaces available"
    fi
}

stop_workspace() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 stop <workspace-id>"
        exit 1
    fi
    
    print_header "🛑 Stopping Workspace: $workspace_id"
    
    check_devpod
    
    if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
        print_color $YELLOW "🛑 Stopping workspace '$workspace_id'..."
        devpod stop "$workspace_id"
        print_color $GREEN "✅ Workspace '$workspace_id' stopped successfully"
    else
        print_color $YELLOW "⚠️  Workspace '$workspace_id' not found or already stopped"
    fi
}

delete_workspace() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 delete <workspace-id>"
        exit 1
    fi
    
    print_header "🗑️  Deleting Workspace: $workspace_id"
    
    check_devpod
    
    if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
        print_color $YELLOW "⚠️  This will permanently delete workspace '$workspace_id'"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_color $YELLOW "🗑️  Deleting workspace '$workspace_id'..."
            devpod delete "$workspace_id" --force
            print_color $GREEN "✅ Workspace '$workspace_id' deleted successfully"
        else
            print_color $BLUE "ℹ️  Operation cancelled"
        fi
    else
        print_color $YELLOW "⚠️  Workspace '$workspace_id' not found"
    fi
}

force_delete_workspace() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 force-delete <workspace-id>"
        exit 1
    fi
    
    print_header "💥 Force Deleting Workspace: $workspace_id"
    
    check_devpod
    
    print_color $RED "⚠️  FORCE DELETE: This will delete '$workspace_id' without confirmation"
    print_color $YELLOW "🗑️  Force deleting workspace '$workspace_id'..."
    
    devpod delete "$workspace_id" --force 2>/dev/null || print_color $YELLOW "⚠️  Workspace may not exist"
    print_color $GREEN "✅ Force delete completed for '$workspace_id'"
}

stop_all_workspaces() {
    print_header "🛑 Stopping All Workspaces"
    
    check_devpod
    
    print_color $YELLOW "🛑 Stopping all running DevPod workspaces..."
    
    # Get list of workspace names
    local workspaces
    workspaces=$(devpod workspace list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    
    if [[ -z "$workspaces" ]]; then
        print_color $BLUE "ℹ️  No workspaces found to stop"
        return
    fi
    
    echo "$workspaces" | while read -r workspace; do
        if [[ -n "$workspace" ]]; then
            print_color $YELLOW "🛑 Stopping workspace: $workspace"
            devpod stop "$workspace" 2>/dev/null || print_color $YELLOW "⚠️  Could not stop $workspace"
        fi
    done
    
    print_color $GREEN "✅ All workspaces stop command completed"
}

clean_workspaces() {
    print_header "🧹 Cleaning Up Workspaces"
    
    check_devpod
    
    print_color $YELLOW "⚠️  This will delete ALL DevPod workspaces"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Get list of workspace names
        local workspaces
        workspaces=$(devpod workspace list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
        
        if [[ -z "$workspaces" ]]; then
            print_color $BLUE "ℹ️  No workspaces found to clean"
            return
        fi
        
        echo "$workspaces" | while read -r workspace; do
            if [[ -n "$workspace" ]]; then
                print_color $YELLOW "🗑️  Deleting workspace: $workspace"
                devpod delete "$workspace" --force 2>/dev/null || print_color $YELLOW "⚠️  Could not delete $workspace"
            fi
        done
        
        print_color $GREEN "✅ Workspace cleanup completed"
    else
        print_color $BLUE "ℹ️  Cleanup cancelled"
    fi
}

workspace_logs() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 logs <workspace-id>"
        exit 1
    fi
    
    print_header "📜 Workspace Logs: $workspace_id"
    
    check_devpod
    
    if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
        print_color $BLUE "📜 Showing logs for '$workspace_id'..."
        echo ""
        devpod logs "$workspace_id"
    else
        print_color $RED "❌ Workspace '$workspace_id' not found"
    fi
}

ssh_workspace() {
    local workspace_id="$1"
    
    if [[ -z "$workspace_id" ]]; then
        print_color $RED "❌ Please provide workspace ID"
        print_color $YELLOW "Usage: $0 ssh <workspace-id>"
        exit 1
    fi
    
    print_header "🔗 SSH into Workspace: $workspace_id"
    
    check_devpod
    
    if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
        print_color $BLUE "🔗 Connecting to '$workspace_id'..."
        devpod ssh "$workspace_id"
    else
        print_color $RED "❌ Workspace '$workspace_id' not found"
    fi
}

print_help() {
    print_header "🛠️  DevPod Workspace Utilities"
    
    echo "Usage: $0 [command] [workspace-id]"
    echo ""
    echo "📋 Workspace Management Commands:"
    echo "  list                    List all DevPod workspaces"
    echo "  status <workspace-id>   Show detailed workspace status"
    echo "  stop <workspace-id>     Stop a specific workspace"
    echo "  delete <workspace-id>   Delete a workspace (with confirmation)"
    echo "  force-delete <id>       Force delete workspace (no confirmation)"
    echo "  logs <workspace-id>     Show workspace logs"
    echo "  ssh <workspace-id>      SSH into workspace"
    echo ""
    echo "🧹 Bulk Operations:"
    echo "  stop-all               Stop all running workspaces"
    echo "  clean                  Delete all workspaces (with confirmation)"
    echo ""
    echo "📚 Information:"
    echo "  help                   Show this help message"
    echo ""
    echo "💡 Examples:"
    echo "  $0 list                           # List all workspaces"
    echo "  $0 status java17-devpod-workspace # Check workspace status"
    echo "  $0 stop nodejs-devpod-workspace   # Stop specific workspace"
    echo "  $0 delete old-workspace           # Delete workspace"
    echo "  $0 stop-all                       # Stop all workspaces"
    echo ""
    print_color $CYAN "🔗 Quick workspace access:"
    print_color $CYAN "  For project-specific management, use the manage-devpod.sh scripts in each project directory"
}

# Main execution
case "${1:-help}" in
    list|ls)
        list_workspaces
        ;;
    status|info)
        workspace_status "$2"
        ;;
    stop)
        stop_workspace "$2"
        ;;
    delete|del|rm)
        delete_workspace "$2"
        ;;
    force-delete|force-del|force-rm)
        force_delete_workspace "$2"
        ;;
    stop-all|stopall)
        stop_all_workspaces
        ;;
    clean|cleanup)
        clean_workspaces
        ;;
    logs|log)
        workspace_logs "$2"
        ;;
    ssh|connect)
        ssh_workspace "$2"
        ;;
    help|--help|-h|"")
        print_help
        ;;
    *)
        print_color $RED "❌ Unknown command: $1"
        print_help
        exit 1
        ;;
esac