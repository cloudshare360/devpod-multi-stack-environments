#!/bin/bash
# Java 17 Project DevPod Management Script
# Usage: ./manage-devpod.sh [start|stop|restart|status|logs|ssh]

set -e

PROJECT_NAME="java17-project"
WORKSPACE_ID="java17-devpod-workspace"

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
    print_header "Starting Java 17 DevPod Environment"
    
    check_devpod
    check_docker
    
    print_color $BLUE "📦 Project: $PROJECT_NAME"
    print_color $BLUE "🆔 Workspace ID: $WORKSPACE_ID"
    echo ""
    
    print_color $YELLOW "🏗️  Starting DevPod workspace..."
    devpod up . --id "$WORKSPACE_ID" --ide vscode
    
    echo ""
    print_color $GREEN "✅ Java 17 DevPod environment started successfully!"
    print_endpoints
}

stop_workspace() {
    print_header "Stopping Java 17 DevPod Environment"
    
    check_devpod
    
    print_color $YELLOW "🛑 Stopping DevPod workspace..."
    devpod stop "$WORKSPACE_ID"
    
    print_color $GREEN "✅ Workspace stopped successfully!"
}

restart_workspace() {
    print_header "Restarting Java 17 DevPod Environment"
    
    stop_workspace
    sleep 2
    start_workspace
}

workspace_status() {
    print_header "Java 17 DevPod Workspace Status"
    
    check_devpod
    
    devpod workspace list | grep "$WORKSPACE_ID" || print_color $YELLOW "⚠️  Workspace not found"
}

workspace_logs() {
    print_header "Java 17 DevPod Workspace Logs"
    
    check_devpod
    
    devpod logs "$WORKSPACE_ID"
}

ssh_workspace() {
    print_header "SSH into Java 17 DevPod Workspace"
    
    check_devpod
    
    devpod ssh "$WORKSPACE_ID"
}

print_endpoints() {
    echo ""
    print_color $GREEN "📋 Available endpoints:"
    print_color $GREEN "   🌐 Main API: http://localhost:8080"
    print_color $GREEN "   ❤️  Health Check: http://localhost:8080/api/health"
    print_color $GREEN "   👥 Users API: http://localhost:8080/api/users"
    print_color $GREEN "   🗃️  H2 Console: http://localhost:8080/h2-console"
    print_color $GREEN "   📊 Actuator: http://localhost:8080/actuator"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   mvn spring-boot:run  - Start development server"
    print_color $BLUE "   mvn test            - Run tests"
    print_color $BLUE "   mvn clean package   - Build JAR file"
    print_color $BLUE "   mvn clean compile   - Compile project"
    echo ""
    print_color $BLUE "🛠️  Database info (H2):"
    print_color $BLUE "   URL: jdbc:h2:mem:devdb"
    print_color $BLUE "   Username: sa"
    print_color $BLUE "   Password: (empty)"
}

print_help() {
    print_header "Java 17 DevPod Management Script"
    
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start the DevPod workspace"
    echo "  stop      Stop the DevPod workspace"
    echo "  restart   Restart the DevPod workspace"
    echo "  status    Show workspace status"
    echo "  logs      Show workspace logs"
    echo "  ssh       SSH into the workspace"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start the workspace"
    echo "  $0 stop     # Stop the workspace"
    echo "  $0 restart  # Restart the workspace"
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
    help|--help|-h)
        print_help
        ;;
    *)
        print_color $RED "❌ Unknown command: $1"
        print_help
        exit 1
        ;;
esac