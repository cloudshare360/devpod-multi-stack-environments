#!/bin/bash
# DevPod Stop Script
# Stops the DevPod workspace

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
    print_header "🛑 Stopping $PROJECT_NAME DevPod Environment"
    
    # Check prerequisites
    check_devpod
    
    # Show project info
    show_project_info
    echo ""
    
    if workspace_exists; then
        print_info "🛑 Stopping DevPod workspace..."
        devpod stop "$WORKSPACE_ID"
        print_success "✅ Workspace stopped successfully!"
        
        # Also kill any lingering processes on the port
        print_info "🔧 Cleaning up any remaining processes on port $PROJECT_PORT..."
        kill_port_processes "$PROJECT_PORT"
    else
        print_warning "⚠️  Workspace '$WORKSPACE_ID' not found or already stopped"
    fi
    
    print_info "💡 Use './start.sh' to start the workspace again"
}

# Run main function
main "$@"