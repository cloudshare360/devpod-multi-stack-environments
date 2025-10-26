#!/bin/bash
# Python 3 Project DevPod Management Script
# Usage: ./manage-devpod.sh [start|stop|restart|status|logs|ssh|test|format]

set -e

PROJECT_NAME="python3-project"
WORKSPACE_ID="python3-devpod-workspace"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $BLUE "=================================="
    print_color $BLUE "$1"
    print_color $BLUE "=================================="
    echo ""
}

check_devpod() {
    if ! command -v devpod &> /dev/null; then
        print_color $RED "❌ DevPod CLI not found. Please install it first."
        exit 1
    fi
}

check_docker() {
    if ! docker info &> /dev/null; then
        print_color $RED "❌ Docker is not running. Please start Docker."
        exit 1
    fi
}

start_workspace() {
    print_header "Starting Python 3 DevPod Environment"
    
    check_devpod
    check_docker
    
    print_color $BLUE "📦 Project: $PROJECT_NAME"
    print_color $BLUE "🆔 Workspace ID: $WORKSPACE_ID"
    echo ""
    
    print_color $YELLOW "🏗️  Starting DevPod workspace..."
    devpod up . --id "$WORKSPACE_ID" --ide vscode
    
    echo ""
    print_color $GREEN "✅ Python 3 DevPod environment started successfully!"
    print_endpoints
}

stop_workspace() {
    print_header "Stopping Python 3 DevPod Environment"
    
    check_devpod
    
    print_color $YELLOW "🛑 Stopping DevPod workspace..."
    devpod stop "$WORKSPACE_ID"
    
    print_color $GREEN "✅ Workspace stopped successfully!"
}

restart_workspace() {
    print_header "Restarting Python 3 DevPod Environment"
    
    stop_workspace
    sleep 2
    start_workspace
}

workspace_status() {
    print_header "Python 3 DevPod Workspace Status"
    
    check_devpod
    
    devpod workspace list | grep "$WORKSPACE_ID" || print_color $YELLOW "⚠️  Workspace not found"
}

workspace_logs() {
    print_header "Python 3 DevPod Workspace Logs"
    
    check_devpod
    
    devpod logs "$WORKSPACE_ID"
}

ssh_workspace() {
    print_header "SSH into Python 3 DevPod Workspace"
    
    check_devpod
    
    devpod ssh "$WORKSPACE_ID"
}

run_tests() {
    print_header "Running Python Tests"
    
    check_devpod
    
    print_color $YELLOW "🧪 Running tests..."
    devpod ssh "$WORKSPACE_ID" -- "cd /workspaces/python3-project && python -m pytest tests/ -v"
}

format_code() {
    print_header "Formatting Python Code"
    
    check_devpod
    
    print_color $YELLOW "🎨 Formatting code with Black..."
    devpod ssh "$WORKSPACE_ID" -- "cd /workspaces/python3-project && python -m black app/ tests/"
    
    print_color $YELLOW "📋 Organizing imports with isort..."
    devpod ssh "$WORKSPACE_ID" -- "cd /workspaces/python3-project && python -m isort app/ tests/"
    
    print_color $YELLOW "🔍 Running linter with flake8..."
    devpod ssh "$WORKSPACE_ID" -- "cd /workspaces/python3-project && python -m flake8 app/ tests/"
    
    print_color $GREEN "✅ Code formatting completed!"
}

print_endpoints() {
    echo ""
    print_color $GREEN "📋 Available endpoints:"
    print_color $GREEN "   🌐 Main API: http://localhost:8000"
    print_color $GREEN "   ❤️  Health Check: http://localhost:8000/health"
    print_color $GREEN "   👥 Users API: http://localhost:8000/api/users"
    print_color $GREEN "   📚 API Docs: http://localhost:8000/docs"
    print_color $GREEN "   📖 ReDoc: http://localhost:8000/redoc"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   uvicorn app.main:app --reload  - Start development server"
    print_color $BLUE "   python -m pytest              - Run tests"
    print_color $BLUE "   python -m black .              - Format code"
    print_color $BLUE "   python -m flake8 .             - Lint code"
    print_color $BLUE "   python -m isort .              - Sort imports"
    echo ""
}

print_help() {
    print_header "Python 3 DevPod Management Script"
    
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start the DevPod workspace"
    echo "  stop      Stop the DevPod workspace"
    echo "  restart   Restart the DevPod workspace"
    echo "  status    Show workspace status"
    echo "  logs      Show workspace logs"
    echo "  ssh       SSH into the workspace"
    echo "  test      Run tests"
    echo "  format    Format and lint code"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start the workspace"
    echo "  $0 stop     # Stop the workspace"
    echo "  $0 test     # Run tests"
    echo "  $0 format   # Format code"
}

# Main execution
case "${1:-start}" in
    start)
        start_workspace
        ;;
    stop)
        stop_workspace
        ;;
    restart)
        restart_workspace
        ;;
    status)
        workspace_status
        ;;
    logs)
        workspace_logs
        ;;
    ssh)
        ssh_workspace
        ;;
    test)
        run_tests
        ;;
    format)
        format_code
        ;;
    help|--help|-h)
        print_help
        ;;
    *)
        print_color $RED "❌ Unknown command: $1"
        print_help
        exit 1
        ;;
esac