#!/bin/bash
# DevPod Project Launcher
# Universal script to manage all DevPod projects
# Usage: ./launch-project.sh

set -e

PROJECTS_DIR="/home/sri/Downloads/dev-pod-cli-ws/projects"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_projects_menu() {
    print_header "DevPod Project Launcher"
    
    echo "Available Projects:"
    echo ""
    print_color $GREEN "Backend/API Projects:"
    echo "  1. 🟢 Node.js (Express API)"
    echo "  2. ☕ Java 17 (Spring Boot API)"
    echo "  3. 🐍 Python 3 (FastAPI)"
    echo ""
    print_color $BLUE "Frontend Projects:"
    echo "  4. ⚛️  React (TypeScript)"
    echo "  5. 🅰️  Angular 17 (TypeScript)"
    echo ""
    print_color $PURPLE "Full-Stack Projects:"
    echo "  6. 🌐 MERN Stack (MongoDB + Express + React + Node)"
    echo "  7. 🏗️  Angular + Java + PostgreSQL (Full Enterprise Stack)"
    echo ""
    print_color $YELLOW "Management Options:"
    echo "  8. 📋 List all workspaces"
    echo "  9. 🛑 Stop all workspaces"
    echo "  10. 🗑️  Clean up unused resources"
    echo "  0. 🚪 Exit"
    echo ""
}

check_prerequisites() {
    if ! command -v devpod &> /dev/null; then
        print_color $RED "❌ DevPod CLI not found. Please install it first:"
        print_color $YELLOW "   ./install-devpod.sh"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_color $RED "❌ Docker is not running. Please start Docker."
        exit 1
    fi
}

launch_project() {
    local project_name=$1
    local project_dir="$PROJECTS_DIR/$project_name"
    
    if [ ! -d "$project_dir" ]; then
        print_color $RED "❌ Project directory not found: $project_dir"
        exit 1
    fi
    
    print_header "Launching $project_name"
    
    cd "$project_dir"
    
    if [ -f "manage-devpod.sh" ]; then
        print_color $YELLOW "🏗️  Starting project using management script..."
        ./manage-devpod.sh start
    else
        print_color $YELLOW "🏗️  Starting project with default DevPod command..."
        devpod up . --id "${project_name}-workspace" --ide vscode
    fi
    
    print_color $GREEN "✅ Project launched successfully!"
}

show_project_info() {
    local project_name=$1
    
    case $project_name in
        "nodejs-project")
            print_color $GREEN "🟢 Node.js Project"
            print_color $BLUE "   Framework: Express.js"
            print_color $BLUE "   Port: 3000"
            print_color $BLUE "   API: http://localhost:3000"
            print_color $BLUE "   Health: http://localhost:3000/health"
            ;;
        "java17-project")
            print_color $GREEN "☕ Java 17 Project"
            print_color $BLUE "   Framework: Spring Boot"
            print_color $BLUE "   Port: 8080"
            print_color $BLUE "   API: http://localhost:8080"
            print_color $BLUE "   H2 Console: http://localhost:8080/h2-console"
            ;;
        "python3-project")
            print_color $GREEN "🐍 Python 3 Project"
            print_color $BLUE "   Framework: FastAPI"
            print_color $BLUE "   Port: 8000"
            print_color $BLUE "   API: http://localhost:8000"
            print_color $BLUE "   Docs: http://localhost:8000/docs"
            ;;
        "react-project")
            print_color $GREEN "⚛️  React Project"
            print_color $BLUE "   Framework: React 18"
            print_color $BLUE "   Port: 3000"
            print_color $BLUE "   App: http://localhost:3000"
            ;;
        "angular-project")
            print_color $GREEN "🅰️  Angular Project"
            print_color $BLUE "   Framework: Angular 17"
            print_color $BLUE "   Port: 4200"
            print_color $BLUE "   App: http://localhost:4200"
            ;;
        "mern-fullstack")
            print_color $GREEN "🌐 MERN Stack Project"
            print_color $BLUE "   Frontend: http://localhost:3000"
            print_color $BLUE "   Backend: http://localhost:5000"
            print_color $BLUE "   MongoDB: localhost:27017"
            ;;
        "angular-java-fullstack")
            print_color $GREEN "🏗️  Angular-Java-PostgreSQL Stack"
            print_color $BLUE "   Frontend: http://localhost:4200"
            print_color $BLUE "   Backend: http://localhost:8080"
            print_color $BLUE "   Database: localhost:5432"
            print_color $BLUE "   Adminer: http://localhost:8081"
            ;;
    esac
}

list_workspaces() {
    print_header "Active DevPod Workspaces"
    
    if command -v devpod &> /dev/null; then
        devpod workspace list
    else
        print_color $RED "❌ DevPod CLI not found"
    fi
}

stop_all_workspaces() {
    print_header "Stopping All DevPod Workspaces"
    
    if command -v devpod &> /dev/null; then
        print_color $YELLOW "🛑 Stopping all active workspaces..."
        
        # Get list of running workspaces and stop them
        devpod workspace list --output json 2>/dev/null | jq -r '.[].id' 2>/dev/null | while read -r workspace_id; do
            if [ ! -z "$workspace_id" ]; then
                print_color $YELLOW "   Stopping: $workspace_id"
                devpod stop "$workspace_id" || true
            fi
        done || {
            # Fallback if jq is not available
            print_color $YELLOW "   Stopping common workspaces..."
            devpod stop nodejs-devpod-workspace 2>/dev/null || true
            devpod stop java17-devpod-workspace 2>/dev/null || true
            devpod stop python3-devpod-workspace 2>/dev/null || true
            devpod stop react-devpod-workspace 2>/dev/null || true
            devpod stop angular-devpod-workspace 2>/dev/null || true
            devpod stop mern-devpod-workspace 2>/dev/null || true
            devpod stop angular-java-devpod-workspace 2>/dev/null || true
        }
        
        print_color $GREEN "✅ All workspaces stopped"
    else
        print_color $RED "❌ DevPod CLI not found"
    fi
}

cleanup_resources() {
    print_header "Cleaning Up Unused Resources"
    
    print_color $YELLOW "🧹 Cleaning Docker resources..."
    docker system prune -f
    
    print_color $YELLOW "🗑️  Removing unused Docker volumes..."
    docker volume prune -f
    
    print_color $GREEN "✅ Cleanup completed"
}

show_project_status() {
    print_header "Project Status Overview"
    
    local projects=("nodejs-project" "java17-project" "python3-project" "react-project" "angular-project" "mern-fullstack" "angular-java-fullstack")
    
    for project in "${projects[@]}"; do
        local workspace_id="${project}-workspace"
        if devpod workspace list 2>/dev/null | grep -q "$workspace_id"; then
            print_color $GREEN "✅ $project (running)"
        else
            print_color $YELLOW "⏹️  $project (stopped)"
        fi
    done
}

main_menu() {
    while true; do
        print_projects_menu
        read -p "Enter your choice (0-10): " choice
        
        case $choice in
            1)
                show_project_info "nodejs-project"
                read -p "Launch Node.js project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "nodejs-project"
                fi
                ;;
            2)
                show_project_info "java17-project"
                read -p "Launch Java 17 project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "java17-project"
                fi
                ;;
            3)
                show_project_info "python3-project"
                read -p "Launch Python 3 project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "python3-project"
                fi
                ;;
            4)
                show_project_info "react-project"
                read -p "Launch React project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "react-project"
                fi
                ;;
            5)
                show_project_info "angular-project"
                read -p "Launch Angular project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "angular-project"
                fi
                ;;
            6)
                show_project_info "mern-fullstack"
                read -p "Launch MERN Stack project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "mern-fullstack"
                fi
                ;;
            7)
                show_project_info "angular-java-fullstack"
                read -p "Launch Full Stack project? (y/n): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    launch_project "angular-java-fullstack"
                fi
                ;;
            8)
                list_workspaces
                ;;
            9)
                stop_all_workspaces
                ;;
            10)
                cleanup_resources
                ;;
            0)
                print_color $CYAN "👋 Goodbye!"
                exit 0
                ;;
            *)
                print_color $RED "❌ Invalid choice. Please enter a number between 0-10."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
    done
}

# Main execution
print_header "DevPod Project Launcher Initialization"

# Check prerequisites
check_prerequisites

print_color $GREEN "✅ Prerequisites checked"
print_color $BLUE "📁 Projects directory: $PROJECTS_DIR"

# Show project status
show_project_status

# Start main menu
main_menu