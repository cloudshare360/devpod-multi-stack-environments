#!/bin/bash
# DevPod Shared Utilities
# Common functions used by all DevPod management scripts

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

print_info() {
    print_color $BLUE "ℹ️  $1"
}

print_warning() {
    print_color $YELLOW "⚠️  $1"
}

print_error() {
    print_color $RED "❌ $1"
}

print_success() {
    print_color $GREEN "✅ $1"
}

check_devpod() {
    if ! command -v devpod &> /dev/null; then
        print_error "DevPod CLI not found. Please install it first."
        print_warning "Run: ../../install-devpod.sh"
        exit 1
    fi
}

check_docker() {
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker."
        exit 1
    fi
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

kill_port_processes() {
    local port="$1"
    if [[ -z "$port" ]]; then
        print_error "Port number required for kill_port_processes function"
        return 1
    fi
    
    print_info "Checking for processes using port $port..."
    
    if command -v lsof &> /dev/null; then
        local pids
        pids=$(lsof -ti :$port 2>/dev/null || echo "")
        
        if [[ -n "$pids" ]]; then
            print_warning "Found processes using port $port. Killing them..."
            echo "$pids" | while read -r pid; do
                if [[ -n "$pid" ]]; then
                    print_info "Killing process $pid on port $port"
                    kill -9 "$pid" 2>/dev/null || true
                fi
            done
            sleep 2
            print_success "Processes on port $port have been killed"
        else
            print_info "No processes found using port $port"
        fi
    elif command -v netstat &> /dev/null; then
        local pids
        pids=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | grep -v "-" || echo "")
        
        if [[ -n "$pids" ]]; then
            print_warning "Found processes using port $port. Killing them..."
            echo "$pids" | while read -r pid; do
                if [[ -n "$pid" ]]; then
                    print_info "Killing process $pid on port $port"
                    kill -9 "$pid" 2>/dev/null || true
                fi
            done
            sleep 2
            print_success "Processes on port $port have been killed"
        else
            print_info "No processes found using port $port"
        fi
    else
        print_warning "Neither lsof nor netstat available. Cannot check port usage."
    fi
}

stop_all_conflicting_workspaces() {
    print_info "Checking for running workspaces that might conflict..."
    
    # Get list of all running workspaces
    local running_workspaces
    running_workspaces=$(devpod workspace list 2>/dev/null | tail -n +2 | awk '{print $1}' | grep -v "^$" || echo "")
    
    if [[ -n "$running_workspaces" ]]; then
        echo "$running_workspaces" | while read -r workspace; do
            if [[ -n "$workspace" && "$workspace" != "$WORKSPACE_ID" ]]; then
                local ws_status
                ws_status=$(devpod status "$workspace" 2>/dev/null | grep -i "running\|up" || echo "")
                if [[ -n "$ws_status" ]]; then
                    print_warning "Stopping conflicting workspace: $workspace"
                    devpod stop "$workspace" 2>/dev/null || print_warning "Could not stop $workspace"
                fi
            fi
        done
    fi
}

force_delete_workspace() {
    local workspace_id="$1"
    if [[ -z "$workspace_id" ]]; then
        workspace_id="$WORKSPACE_ID"
    fi
    
    if workspace_exists; then
        print_warning "Force deleting existing workspace: $workspace_id"
        devpod delete "$workspace_id" --force 2>/dev/null || true
        sleep 2
        print_success "Workspace $workspace_id deleted"
    else
        print_info "No existing workspace to delete"
    fi
}

open_browser() {
    local url="$1"
    if [[ -z "$url" ]]; then
        return 1
    fi
    
    print_info "Attempting to open browser at: $url"
    
    # Wait a moment for the service to start
    sleep 3
    
    # Try to open browser (works on most Linux desktops)
    if command -v xdg-open &> /dev/null; then
        xdg-open "$url" 2>/dev/null &
    elif command -v gnome-open &> /dev/null; then
        gnome-open "$url" 2>/dev/null &
    elif command -v firefox &> /dev/null; then
        firefox "$url" 2>/dev/null &
    elif command -v google-chrome &> /dev/null; then
        google-chrome "$url" 2>/dev/null &
    elif command -v chromium-browser &> /dev/null; then
        chromium-browser "$url" 2>/dev/null &
    else
        print_warning "Could not auto-open browser. Please manually open: $url"
        return 1
    fi
    
    print_success "Browser opened (or attempted) for: $url"
}

wait_for_service() {
    local port="$1"
    local max_wait="${2:-60}"
    local wait_time=0
    
    print_info "Waiting for service on port $port to be ready..."
    
    while [[ $wait_time -lt $max_wait ]]; do
        if command -v curl &> /dev/null; then
            if curl -s "http://localhost:$port" >/dev/null 2>&1; then
                print_success "Service is ready on port $port!"
                return 0
            fi
        elif command -v wget &> /dev/null; then
            if wget -q --spider "http://localhost:$port" 2>/dev/null; then
                print_success "Service is ready on port $port!"
                return 0
            fi
        elif command -v nc &> /dev/null; then
            if nc -z localhost "$port" 2>/dev/null; then
                print_success "Port $port is listening!"
                return 0
            fi
        fi
        
        sleep 2
        wait_time=$((wait_time + 2))
        echo -n "."
    done
    
    echo ""
    print_warning "Service did not become ready within $max_wait seconds"
    return 1
}

validate_project_config() {
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "PROJECT_NAME not set"
        exit 1
    fi
    
    if [[ -z "$WORKSPACE_ID" ]]; then
        print_error "WORKSPACE_ID not set"
        exit 1
    fi
    
    if [[ -z "$PROJECT_PORT" ]]; then
        print_error "PROJECT_PORT not set"
        exit 1
    fi
}

show_project_info() {
    print_info "Project: $PROJECT_NAME"
    print_info "Workspace ID: $WORKSPACE_ID"
    print_info "Port: $PROJECT_PORT"
    if [[ -n "$PROJECT_URL" ]]; then
        print_info "URL: $PROJECT_URL"
    fi
}