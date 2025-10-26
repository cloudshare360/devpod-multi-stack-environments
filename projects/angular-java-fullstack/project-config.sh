#!/bin/bash
# Project Configuration for angular-java-fullstack
# Generated automatically - customize as needed

# Project Configuration
PROJECT_NAME="angular-java-fullstack"
WORKSPACE_ID="angular-java-devpod-workspace"
PROJECT_PORT="8080"
PROJECT_URL="http://localhost:8080"

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
    print_color $GREEN "   ❤️  Health Check: $PROJECT_URL/api/health"
    print_color $GREEN "   👥 Users API: $PROJECT_URL/api/users"
    print_color $GREEN "   🗃️  H2 Console: $PROJECT_URL/h2-console"
    print_color $GREEN "   📊 Actuator: $PROJECT_URL/actuator"
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
    print_color $BLUE "   ./start.sh    - Start workspace"
    print_color $BLUE "   ./stop.sh     - Stop workspace"
    print_color $BLUE "   ./restart.sh  - Restart workspace"
    print_color $BLUE "   ./status.sh   - Check status"
    print_color $BLUE "   ./logs.sh     - View logs"
    print_color $BLUE "   ./ssh.sh      - SSH into workspace"
    print_color $BLUE "   ./delete.sh   - Delete workspace"
}
