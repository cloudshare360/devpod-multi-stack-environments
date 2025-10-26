#!/bin/bash
# Project Configuration Template
# Copy this file to your project directory and customize the values

# Project Configuration - CUSTOMIZE THESE VALUES
PROJECT_NAME="example-project"          # Change this to your project name
WORKSPACE_ID="example-devpod-workspace" # Change this to your workspace ID
PROJECT_PORT="8080"                     # Change this to your project's main port
PROJECT_URL="http://localhost:8080"     # Change this to your project's main URL

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../devpod-shared.sh" ]]; then
    source "$SCRIPT_DIR/../devpod-shared.sh"
else
    echo "❌ Error: devpod-shared.sh not found. Please ensure it's in the parent directory."
    exit 1
fi

# Validate configuration
validate_project_config

# Project-specific endpoint information
show_endpoints() {
    echo ""
    print_success "📋 Available endpoints:"
    print_color $GREEN "   🌐 Main API: $PROJECT_URL"
    print_color $GREEN "   ❤️  Health Check: $PROJECT_URL/health"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   (Add your project-specific commands here)"
    echo ""
    print_color $BLUE "🛠️  Workspace management:"
    print_color $BLUE "   ./start.sh    - Start workspace"
    print_color $BLUE "   ./stop.sh     - Stop workspace"
    print_color $BLUE "   ./restart.sh  - Restart workspace"
    print_color $BLUE "   ./status.sh   - Check status"
    print_color $BLUE "   ./logs.sh     - View logs"
    print_color $BLUE "   ./ssh.sh      - SSH into workspace"
    print_color $BLUE "   ./delete.sh   - Delete workspace"
}