#!/bin/bash
# Project Configuration for python3-project
# Generated automatically - customize as needed

# Project Configuration
PROJECT_NAME="python3-project"
WORKSPACE_ID="python3-devpod-workspace"
PROJECT_PORT="8000"
PROJECT_URL="http://localhost:8000"

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
    print_color $GREEN "   👥 Users API: $PROJECT_URL/users"
    print_color $GREEN "   📚 Interactive Docs: $PROJECT_URL/docs"
    print_color $GREEN "   🔄 ReDoc: $PROJECT_URL/redoc"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
    print_color $BLUE "   pytest              - Run tests"
    print_color $BLUE "   pytest --cov        - Run tests with coverage"
    print_color $BLUE "   pip install -r requirements.txt - Install dependencies"
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
