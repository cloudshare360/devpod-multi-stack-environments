#!/bin/bash
# Java 17 Project DevPod Management Script
# Usage: ./manage-devpod.sh [start|stop|restart|status|logs|ssh|delete|clean-start]

# Project Configuration
PROJECT_NAME="java17-project"
WORKSPACE_ID="java17-devpod-workspace"
PROJECT_PORT="8080"

# Load enhanced management functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../manage-devpod-template.sh"

# Override the print_endpoints function for Java 17 specific endpoints
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
    echo ""
    print_color $BLUE "🛠️  Workspace management:"
    print_color $BLUE "   ./manage-devpod.sh stop      - Stop workspace"
    print_color $BLUE "   ./manage-devpod.sh restart   - Restart workspace"
    print_color $BLUE "   ./manage-devpod.sh ssh       - SSH into workspace"
    print_color $BLUE "   ./manage-devpod.sh logs      - View logs"
    print_color $BLUE "   ./manage-devpod.sh clean-start - Force clean start"
}