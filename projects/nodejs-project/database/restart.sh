#!/bin/bash
# DevPod Restart Script
# Stops and starts the DevPod workspace

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
    print_header "🔄 Restarting $PROJECT_NAME DevPod Environment"
    
    # Show project info
    show_project_info
    echo ""
    
    # Stop if running
    if workspace_exists; then
        print_info "🛑 Stopping existing workspace..."
        "$SCRIPT_DIR/stop.sh"
        echo ""
        sleep 3
    fi
    
    # Start fresh
    print_info "🚀 Starting workspace..."
    "$SCRIPT_DIR/start.sh"
}

# Run main function
main "$@"