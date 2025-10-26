#!/bin/bash
# DevPod Logs Script
# Shows workspace logs

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
    print_header "📜 $PROJECT_NAME DevPod Workspace Logs"
    
    # Check prerequisites
    check_devpod
    
    # Show project info
    show_project_info
    echo ""
    
    if workspace_exists; then
        print_info "📜 Showing logs for '$WORKSPACE_ID'..."
        echo ""
        devpod logs "$WORKSPACE_ID" "$@"
    else
        print_error "❌ Workspace '$WORKSPACE_ID' not found"
        print_info "💡 Use './start.sh' to create and start the workspace"
    fi
}

# Run main function
main "$@"