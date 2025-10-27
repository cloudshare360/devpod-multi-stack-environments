#!/bin/bash

# 📋 DevPod Command Clipboard Utility
# Quick copy-to-clipboard for common DevPod commands

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to copy to clipboard
copy_to_clipboard() {
    local cmd="$1"
    local description="$2"
    
    if command -v xclip &> /dev/null; then
        echo "$cmd" | xclip -selection clipboard
        echo -e "${GREEN}✅ Copied to clipboard:${NC} $description"
    elif command -v pbcopy &> /dev/null; then
        echo "$cmd" | pbcopy
        echo -e "${GREEN}✅ Copied to clipboard:${NC} $description"
    elif command -v clip &> /dev/null; then
        echo "$cmd" | clip
        echo -e "${GREEN}✅ Copied to clipboard:${NC} $description"
    else
        echo -e "${BLUE}📋 Copy this command:${NC}"
        echo "$cmd"
        echo ""
    fi
    
    echo -e "${CYAN}Command:${NC} $cmd"
    echo ""
}

# Display menu
echo -e "${CYAN}📋 DevPod Quick Copy Utility${NC}"
echo "================================"
echo ""
echo "Select a command to copy:"
echo ""
echo "1)  devpod version"
echo "2)  devpod list"
echo "3)  devpod up --id my-workspace ."
echo "4)  devpod status my-workspace"
echo "5)  devpod ssh my-workspace"
echo "6)  devpod ide vscode my-workspace (Desktop)"
echo "7)  devpod ide openvscode my-workspace (Browser)"
echo "8)  devpod stop my-workspace"
echo "9)  devpod delete my-workspace"
echo "10) devpod logs my-workspace"
echo "11) devpod provider list"
echo "12) docker version"
echo "13) docker ps"
echo ""

read -p "Enter your choice (1-13): " choice

case $choice in
    1)
        copy_to_clipboard "devpod version" "Check DevPod version"
        ;;
    2)
        copy_to_clipboard "devpod list" "List all workspaces"
        ;;
    3)
        copy_to_clipboard "devpod up --id my-workspace ." "Create workspace from current directory"
        ;;
    4)
        copy_to_clipboard "devpod status my-workspace" "Check workspace status"
        ;;
    5)
        copy_to_clipboard "devpod ssh my-workspace" "SSH into workspace"
        ;;
    6)
        copy_to_clipboard "devpod ide vscode my-workspace" "Open workspace in VS Code desktop"
        ;;
    7)
        copy_to_clipboard "devpod ide openvscode my-workspace" "Open workspace in VS Code browser"
        ;;
    8)
        copy_to_clipboard "devpod stop my-workspace" "Stop workspace"
        ;;
    9)
        copy_to_clipboard "devpod delete my-workspace" "Delete workspace"
        ;;
    10)
        copy_to_clipboard "devpod logs my-workspace" "View workspace logs"
        ;;
    11)
        copy_to_clipboard "devpod provider list" "List available providers"
        ;;
    12)
        copy_to_clipboard "docker version" "Check Docker version"
        ;;
    13)
        copy_to_clipboard "docker ps" "List running containers"
        ;;
    *)
        echo "Invalid choice"
        ;;
esac