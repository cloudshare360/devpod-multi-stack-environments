#!/bin/bash
# DevPod Start Script
# Automatically handles conflicts and starts fresh workspace

set -e

# Load project configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/project-config.sh" ]]; then
    source "$SCRIPT_DIR/project-config.sh"
else
    echo "❌ Error: project-config.sh not found. Please create it based on project-config-template.sh"
    exit 1
fi

main() {
    print_header "🚀 Starting $PROJECT_NAME DevPod Environment"
    
    # Check prerequisites
    check_devpod
    check_docker
    
    # Show project info
    show_project_info
    echo ""
    
    # Kill any processes using our port
    print_info "🔧 Cleaning up port conflicts..."
    kill_port_processes "$PROJECT_PORT"
    
    # Stop all conflicting workspaces
    print_info "🛑 Stopping conflicting workspaces..."
    stop_all_conflicting_workspaces
    
    # Force delete existing workspace if it exists (for clean start)
    print_info "🗑️  Ensuring clean workspace..."
    force_delete_workspace "$WORKSPACE_ID"
    
    # Start fresh workspace
    print_info "🏗️  Starting fresh DevPod workspace..."
    devpod up . --id "$WORKSPACE_ID" --ide vscode
    
    # Wait for service to be ready
    print_info "⏳ Waiting for service to start..."
    if wait_for_service "$PROJECT_PORT" 90; then
        # Open browser automatically
        open_browser "$PROJECT_URL"
    else
        print_warning "Service may not be fully ready yet, but workspace is started"
    fi
    
    echo ""
    print_success "✅ $PROJECT_NAME DevPod environment started successfully!"
    
    # Show endpoints if function exists
    if declare -f show_endpoints > /dev/null; then
        show_endpoints
    fi
    
    print_info "🌐 Main URL: $PROJECT_URL"
    print_info "💡 Use './stop.sh' to stop the workspace when done"
}

# Run main function
main "$@"