#!/bin/bash

# 🚀 DevPod Interactive Command Helper
# This script provides interactive command execution for the DevPod CLI Guide

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to print section headers
print_header() {
    echo ""
    print_color $CYAN "=================================="
    print_color $CYAN "  $1"
    print_color $CYAN "=================================="
    echo ""
}

# Function to execute command with confirmation
execute_command() {
    local cmd="$1"
    local description="$2"
    
    echo ""
    print_color $YELLOW "Command: $cmd"
    if [ ! -z "$description" ]; then
        print_color $BLUE "Description: $description"
    fi
    echo ""
    
    read -p "Execute this command? (y/n/c for copy only): " choice
    case $choice in
        [Yy]* )
            print_color $GREEN "Executing: $cmd"
            echo ""
            eval "$cmd"
            ;;
        [Cc]* )
            # Copy to clipboard (Linux)
            if command -v xclip &> /dev/null; then
                echo "$cmd" | xclip -selection clipboard
                print_color $GREEN "Command copied to clipboard!"
            elif command -v pbcopy &> /dev/null; then
                echo "$cmd" | pbcopy
                print_color $GREEN "Command copied to clipboard!"
            else
                print_color $RED "Clipboard tool not found. Please install xclip (Linux) or use pbcopy (macOS)"
                echo "Command to copy: $cmd"
            fi
            ;;
        [Nn]* )
            print_color $YELLOW "Skipped command"
            ;;
        * )
            print_color $RED "Invalid choice. Skipping command."
            ;;
    esac
}

# Function to show menu
show_menu() {
    print_header "DevPod Interactive Command Helper"
    
    echo "Choose a category:"
    echo "1) 🛠️  DevPod Installation Commands"
    echo "2) 🚀 Quick Start Commands"
    echo "3) 📋 Basic DevPod Commands"
    echo "4) 🔧 Configuration Commands"
    echo "5) 🐛 Troubleshooting Commands"
    echo "6) 💻 Language-Specific Examples"
    echo "7) 🏗️  Custom Commands (Interactive Input)"
    echo "8) 📊 System Status Check"
    echo "0) Exit"
    echo ""
    read -p "Enter your choice (0-8): " choice
}

# Installation commands
installation_commands() {
    print_header "DevPod Installation Commands"
    
    execute_command "curl -L -o devpod \"https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64\"" "Download DevPod binary"
    execute_command "sudo install -c -m 0755 devpod /usr/local/bin" "Install DevPod to system PATH"
    execute_command "rm devpod" "Clean up downloaded file"
    execute_command "devpod version" "Verify DevPod installation"
}

# Quick start commands
quick_start_commands() {
    print_header "Quick Start Commands"
    
    execute_command "devpod list" "List all existing workspaces"
    execute_command "devpod provider list" "Show available providers"
    execute_command "devpod up --id my-first-workspace ." "Create workspace from current directory"
    execute_command "devpod ide vscode my-first-workspace" "Open workspace in VS Code desktop"
    execute_command "devpod ide openvscode my-first-workspace" "Open workspace in VS Code browser"
}

# Basic commands
basic_commands() {
    print_header "Basic DevPod Commands"
    
    execute_command "devpod list" "List all workspaces"
    execute_command "devpod status \${WORKSPACE_NAME:-my-workspace}" "Check workspace status"
    execute_command "devpod stop \${WORKSPACE_NAME:-my-workspace}" "Stop workspace"
    execute_command "devpod ssh \${WORKSPACE_NAME:-my-workspace}" "SSH into workspace"
    execute_command "devpod logs \${WORKSPACE_NAME:-my-workspace}" "View workspace logs"
}

# Configuration commands
configuration_commands() {
    print_header "Configuration Commands"
    
    execute_command "devpod context list" "List available contexts"
    execute_command "devpod provider list" "List available providers"
    execute_command "devpod context set-options --option IDE=vscode" "Set default IDE to VS Code"
    execute_command "devpod provider set-options docker --option DOCKER_SOCK=/var/run/docker.sock" "Configure Docker provider"
}

# Troubleshooting commands
troubleshooting_commands() {
    print_header "Troubleshooting Commands"
    
    execute_command "devpod version" "Check DevPod version"
    execute_command "docker version" "Check Docker version"
    execute_command "docker ps" "List running containers"
    execute_command "devpod logs-daemon" "View DevPod daemon logs"
    execute_command "docker system info" "Show Docker system information"
    execute_command "docker system prune -f" "Clean up Docker system (removes unused containers, networks, images)"
}

# Language-specific examples
language_examples() {
    print_header "Language-Specific Examples"
    
    echo "Choose a language:"
    echo "1) Node.js/JavaScript"
    echo "2) Python"
    echo "3) Java"
    echo "4) Go"
    echo "5) Rust"
    echo ""
    read -p "Enter your choice (1-5): " lang_choice
    
    case $lang_choice in
        1)
            execute_command "cd examples/javascript && devpod up --id nodejs-example ." "Create Node.js workspace"
            execute_command "devpod ssh nodejs-example -- \"npm install && npm start\"" "Install dependencies and start server"
            ;;
        2)
            execute_command "cd examples/python && devpod up --id python-example ." "Create Python workspace"
            execute_command "devpod ssh python-example -- \"pip install -r requirements.txt && python main.py\"" "Install dependencies and start server"
            ;;
        3)
            execute_command "cd examples/java && devpod up --id java-example ." "Create Java workspace"
            execute_command "devpod ssh java-example -- \"./mvnw spring-boot:run\"" "Start Spring Boot application"
            ;;
        4)
            execute_command "cd examples/go && devpod up --id go-example ." "Create Go workspace"
            execute_command "devpod ssh go-example -- \"go run main.go\"" "Run Go application"
            ;;
        5)
            execute_command "cd examples/rust && devpod up --id rust-example ." "Create Rust workspace"
            execute_command "devpod ssh rust-example -- \"cargo run\"" "Run Rust application"
            ;;
        *)
            print_color $RED "Invalid choice"
            ;;
    esac
}

# Custom commands with user input
custom_commands() {
    print_header "Custom Commands"
    
    echo "Enter custom DevPod commands (or 'back' to return to menu):"
    while true; do
        read -p "devpod " user_input
        
        if [ "$user_input" = "back" ]; then
            break
        fi
        
        if [ ! -z "$user_input" ]; then
            execute_command "devpod $user_input" "Custom DevPod command"
        fi
    done
}

# System status check
system_status() {
    print_header "System Status Check"
    
    print_color $BLUE "Checking DevPod installation..."
    if command -v devpod &> /dev/null; then
        print_color $GREEN "✅ DevPod installed: $(devpod version)"
    else
        print_color $RED "❌ DevPod not found"
    fi
    
    print_color $BLUE "Checking Docker installation..."
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null 2>&1; then
            print_color $GREEN "✅ Docker running: $(docker version --format '{{.Server.Version}}')"
        else
            print_color $YELLOW "⚠️ Docker installed but not running"
        fi
    else
        print_color $RED "❌ Docker not found"
    fi
    
    print_color $BLUE "DevPod Workspaces:"
    devpod list 2>/dev/null || print_color $YELLOW "No workspaces found or DevPod not configured"
    
    print_color $BLUE "DevPod Providers:"
    devpod provider list 2>/dev/null || print_color $YELLOW "No providers configured"
    
    read -p "Press Enter to continue..."
}

# Main loop
main() {
    while true; do
        show_menu
        
        case $choice in
            1)
                installation_commands
                ;;
            2)
                quick_start_commands
                ;;
            3)
                basic_commands
                ;;
            4)
                configuration_commands
                ;;
            5)
                troubleshooting_commands
                ;;
            6)
                language_examples
                ;;
            7)
                custom_commands
                ;;
            8)
                system_status
                ;;
            0)
                print_color $GREEN "Goodbye! Happy DevPodding! 🚀"
                exit 0
                ;;
            *)
                print_color $RED "Invalid option. Please try again."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to return to main menu..."
    done
}

# Script help
show_help() {
    echo "🚀 DevPod Interactive Command Helper"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show script version"
    echo ""
    echo "This script provides an interactive way to execute DevPod commands"
    echo "with copy-to-clipboard functionality and detailed descriptions."
    echo ""
    echo "Features:"
    echo "  • Interactive command execution"
    echo "  • Copy commands to clipboard"
    echo "  • Categorized command sets"
    echo "  • System status checking"
    echo "  • Custom command input"
}

# Check for command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo "DevPod Interactive Command Helper v1.0.0"
        exit 0
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use -h or --help for usage information"
        exit 1
        ;;
esac