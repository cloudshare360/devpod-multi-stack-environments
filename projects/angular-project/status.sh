#!/bin/bash
# DevPod Status Script
# Shows detailed workspace status

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
    print_header "📊 $PROJECT_NAME DevPod Workspace Status"
    
    # Check prerequisites
    check_devpod
    
    # Show project info
    show_project_info
    echo ""
    
    if workspace_exists; then
        print_success "✅ Workspace '$WORKSPACE_ID' found"
        echo ""
        
        # Show workspace list entry
        print_info "📋 Workspace Information:"
        devpod workspace list | head -1  # Header
        devpod workspace list | grep "$WORKSPACE_ID" || true
        echo ""
        
        # Get detailed status
        print_info "🔍 Detailed Status:"
        devpod status "$WORKSPACE_ID" 2>/dev/null || print_warning "⚠️  Could not get detailed status"
        echo ""
        
        # Check if workspace is running
        if workspace_running; then
            print_success "🟢 Workspace is RUNNING"
        else
            print_warning "🟡 Workspace is STOPPED"
        fi
        
        # Check port status
        echo ""
        print_info "🌐 Port Status:"
        if command -v lsof &> /dev/null; then
            if lsof -i :$PROJECT_PORT &> /dev/null; then
                print_success "🟢 Port $PROJECT_PORT is in use (service likely running)"
                print_info "Processes using port $PROJECT_PORT:"
                lsof -i :$PROJECT_PORT | head -10
            else
                print_warning "🔴 Port $PROJECT_PORT is not in use"
            fi
        else
            print_warning "Cannot check port status (lsof not available)"
        fi
        
        # Show endpoints if workspace is running
        if workspace_running; then
            if declare -f show_endpoints > /dev/null; then
                show_endpoints
            else
                echo ""
                print_info "🌐 Main URL: $PROJECT_URL"
            fi
        fi
        
    else
        print_error "❌ Workspace '$WORKSPACE_ID' not found"
        echo ""
        print_info "📋 Available workspaces:"
        if devpod workspace list 2>/dev/null | tail -n +2 | grep -q .; then
            devpod workspace list
        else
            print_warning "No workspaces available"
        fi
        echo ""
        print_info "💡 Use './start.sh' to create and start the workspace"
    fi
}

# Run main function
main "$@"