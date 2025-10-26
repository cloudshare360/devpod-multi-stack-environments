#!/bin/bash
# DevPod Individual Scripts Generator
# Generates individual start, stop, restart, etc. scripts for a project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $CYAN "================================================"
    print_color $CYAN "$1"
    print_color $CYAN "================================================"
    echo ""
}

generate_project_scripts() {
    local project_dir="$1"
    local project_name="$2"
    local workspace_id="$3"
    local project_port="$4"
    local project_url="${5:-http://localhost:$project_port}"
    
    if [[ ! -d "$project_dir" ]]; then
        print_color $RED "❌ Project directory '$project_dir' does not exist"
        return 1
    fi
    
    print_header "🛠️  Generating DevPod Scripts for $project_name"
    
    print_color $BLUE "📁 Project Directory: $project_dir"
    print_color $BLUE "📦 Project Name: $project_name"
    print_color $BLUE "🆔 Workspace ID: $workspace_id"
    print_color $BLUE "🌐 Port: $project_port"
    print_color $BLUE "🔗 URL: $project_url"
    echo ""
    
    # Create project configuration
    print_color $YELLOW "📝 Creating project-config.sh..."
    cat > "$project_dir/project-config.sh" << EOF
#!/bin/bash
# Project Configuration for $project_name
# Generated automatically - customize as needed

# Project Configuration
PROJECT_NAME="$project_name"
WORKSPACE_ID="$workspace_id"
PROJECT_PORT="$project_port"
PROJECT_URL="$project_url"

# Load shared utilities
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "\$SCRIPT_DIR/../devpod-shared.sh" ]]; then
    source "\$SCRIPT_DIR/../devpod-shared.sh"
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
    print_color \$GREEN "   🌐 Main API: \$PROJECT_URL"
EOF

    # Add project-specific endpoints based on project type
    if [[ "$project_name" == *"java"* ]]; then
        cat >> "$project_dir/project-config.sh" << 'EOF'
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
EOF
    elif [[ "$project_name" == *"node"* ]]; then
        cat >> "$project_dir/project-config.sh" << 'EOF'
    print_color $GREEN "   ❤️  Health Check: $PROJECT_URL/health"
    print_color $GREEN "   👥 Users API: $PROJECT_URL/api/users"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   npm run dev     - Start development server"
    print_color $BLUE "   npm run test    - Run tests"
    print_color $BLUE "   npm run lint    - Check code quality"
    print_color $BLUE "   npm run format  - Format code"
    print_color $BLUE "   npm run setup   - Setup project"
EOF
    elif [[ "$project_name" == *"python"* ]]; then
        cat >> "$project_dir/project-config.sh" << 'EOF'
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
EOF
    elif [[ "$project_name" == *"react"* ]]; then
        cat >> "$project_dir/project-config.sh" << 'EOF'
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   npm start       - Start development server"
    print_color $BLUE "   npm run build   - Build for production"
    print_color $BLUE "   npm test        - Run tests"
    print_color $BLUE "   npm run lint    - Check code quality"
EOF
    elif [[ "$project_name" == *"angular"* ]]; then
        cat >> "$project_dir/project-config.sh" << 'EOF'
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   ng serve        - Start development server"
    print_color $BLUE "   ng build        - Build for production"
    print_color $BLUE "   ng test         - Run tests"
    print_color $BLUE "   ng lint         - Check code quality"
    print_color $BLUE "   ng generate component <name> - Generate component"
EOF
    else
        cat >> "$project_dir/project-config.sh" << 'EOF'
    print_color $GREEN "   ❤️  Health Check: $PROJECT_URL/health"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   (Add your project-specific commands here)"
EOF
    fi
    
    cat >> "$project_dir/project-config.sh" << 'EOF'
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
EOF
    
    # Generate individual scripts
    local scripts=("start" "stop" "restart" "status" "logs" "ssh" "delete")
    local template_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    for script in "${scripts[@]}"; do
        print_color $YELLOW "📝 Creating $script.sh..."
        if [[ -f "$template_dir/${script}-template.sh" ]]; then
            cp "$template_dir/${script}-template.sh" "$project_dir/$script.sh"
            chmod +x "$project_dir/$script.sh"
        else
            print_color $RED "❌ Template $template_dir/${script}-template.sh not found"
        fi
    done
    
    print_color $GREEN "✅ Successfully generated all scripts for $project_name"
    echo ""
    print_color $BLUE "📋 Generated scripts:"
    for script in "${scripts[@]}"; do
        print_color $BLUE "   ./$script.sh"
    done
    echo ""
    print_color $CYAN "💡 Quick start:"
    print_color $CYAN "   cd $project_dir"
    print_color $CYAN "   ./start.sh    # Start the workspace"
}

print_help() {
    print_header "DevPod Individual Scripts Generator"
    
    echo "Usage: $0 <project-directory> <project-name> <workspace-id> <port> [url]"
    echo ""
    echo "Parameters:"
    echo "  project-directory  Path to the project directory"
    echo "  project-name      Name of the project"
    echo "  workspace-id      DevPod workspace identifier"
    echo "  port             Main port for the project"
    echo "  url              Main URL (optional, defaults to http://localhost:<port>)"
    echo ""
    echo "Examples:"
    echo "  $0 ./java17-project java17-project java17-devpod-workspace 8080"
    echo "  $0 ./nodejs-project nodejs-project nodejs-devpod-workspace 3000"
    echo "  $0 ./python3-project python3-project python3-devpod-workspace 8000"
    echo ""
    echo "Generated scripts:"
    echo "  start.sh    - Start workspace (handles conflicts automatically)"
    echo "  stop.sh     - Stop workspace"
    echo "  restart.sh  - Restart workspace"
    echo "  status.sh   - Check workspace status"
    echo "  logs.sh     - View workspace logs"
    echo "  ssh.sh      - SSH into workspace"
    echo "  delete.sh   - Delete workspace"
}

# Main execution
if [[ $# -lt 4 ]]; then
    print_help
    exit 1
fi

generate_project_scripts "$1" "$2" "$3" "$4" "$5"