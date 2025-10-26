#!/bin/bash
# DevPod Delete Script
# Deletes the workspace permanently

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
    print_header "🗑️  Delete $PROJECT_NAME DevPod Workspace"
    
    # Check prerequisites
    check_devpod
    
    # Show project info
    show_project_info
    echo ""
    
    if workspace_exists; then
        print_warning "⚠️  This will permanently delete workspace '$WORKSPACE_ID'"
        print_warning "⚠️  All data in the workspace will be lost!"
        echo ""
        
        # Check if force flag is provided
        if [[ "$1" == "--force" || "$1" == "-f" ]]; then
            REPLY="y"
        else
            read -p "Are you sure you want to delete this workspace? (y/N): " -n 1 -r
            echo ""
        fi
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Stop workspace first if running
            if workspace_running; then
                print_info "🛑 Stopping workspace before deletion..."
                devpod stop "$WORKSPACE_ID" 2>/dev/null || true
                sleep 2
            fi
            
            # Kill any processes using the port
            kill_port_processes "$PROJECT_PORT"
            
            # Delete workspace
            print_warning "🗑️  Deleting workspace '$WORKSPACE_ID'..."
            devpod delete "$WORKSPACE_ID" --force
            print_success "✅ Workspace '$WORKSPACE_ID' deleted successfully"
            
            print_info "💡 Use './start.sh' to create a new workspace"
        else
            print_info "ℹ️  Operation cancelled"
        fi
    else
        print_warning "⚠️  Workspace '$WORKSPACE_ID' not found"
    fi
}

# Run main function
main "$@"