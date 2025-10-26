#!/bin/bash
# DevPod SSH Script
# SSH into the workspace

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
    print_header "🔗 SSH into $PROJECT_NAME DevPod Workspace"
    
    # Check prerequisites
    check_devpod
    
    # Show project info
    show_project_info
    echo ""
    
    if workspace_exists; then
        if workspace_running; then
            print_info "🔗 Connecting to '$WORKSPACE_ID'..."
            devpod ssh "$WORKSPACE_ID" "$@"
        else
            print_warning "⚠️  Workspace '$WORKSPACE_ID' exists but is not running"
            print_info "💡 Use './start.sh' to start the workspace first"
        fi
    else
        print_error "❌ Workspace '$WORKSPACE_ID' not found"
        print_info "💡 Use './start.sh' to create and start the workspace"
    fi
}

# Run main function
main "$@"