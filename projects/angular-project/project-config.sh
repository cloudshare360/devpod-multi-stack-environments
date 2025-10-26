#!/bin/bash
# Project Configuration for angular-project
# Generated automatically - customize as needed

# Project Configuration
PROJECT_NAME="angular-project"
WORKSPACE_ID="angular-devpod-workspace"
PROJECT_PORT="4200"
PROJECT_URL="http://localhost:4200"

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
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   ng serve        - Start development server"
    print_color $BLUE "   ng build        - Build for production"
    print_color $BLUE "   ng test         - Run tests"
    print_color $BLUE "   ng lint         - Check code quality"
    print_color $BLUE "   ng generate component <name> - Generate component"
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
