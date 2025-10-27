#!/bin/bash

# 🌐 DevPod VS Code Browser Demo
# Demonstrates how to use VS Code in browser with DevPod

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${CYAN}=================================="
    echo -e "  $1"
    echo -e "==================================${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}📝 Step $1:${NC} $2"
}

print_command() {
    echo -e "${YELLOW}Command:${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_header "DevPod VS Code Browser Demo"

echo "This demo shows you how to:"
echo "1. Create a DevPod workspace"
echo "2. Open it in VS Code browser (no desktop app needed)"
echo "3. Access your development environment from any device"
echo ""

read -p "Press Enter to start the demo..."

print_step "1" "Check DevPod installation"
print_command "devpod version"
devpod version
print_success "DevPod is installed and working"
echo ""

print_step "2" "List existing workspaces"
print_command "devpod list"
devpod list
echo ""

print_step "3" "Create a new workspace (if needed)"
echo "We'll create a sample workspace from the current directory"
print_command "devpod up --id browser-demo ."
read -p "Create workspace? (y/n): " create_choice

if [[ $create_choice =~ ^[Yy]$ ]]; then
    devpod up --id browser-demo .
    print_success "Workspace 'browser-demo' created"
else
    echo "Skipping workspace creation"
fi
echo ""

print_step "4" "Open in VS Code Browser"
echo "This command will open VS Code in your default web browser:"
print_command "devpod ide openvscode browser-demo"
echo ""
echo "Benefits of browser VS Code:"
echo "  🌐 No VS Code installation required"
echo "  📱 Works on tablets and mobile devices"
echo "  🔒 Secure remote access"
echo "  ⚡ Fast startup"
echo "  🔄 Consistent experience across devices"
echo ""

read -p "Open VS Code in browser? (y/n): " open_choice

if [[ $open_choice =~ ^[Yy]$ ]]; then
    echo "Opening VS Code in browser..."
    devpod ide openvscode browser-demo &
    sleep 3
    print_success "VS Code browser should now be open"
    echo ""
    echo "If the browser didn't open automatically, you can:"
    echo "1. Check the terminal output for the URL"
    echo "2. Manually navigate to http://localhost:8080 (or similar)"
    echo "3. Run: devpod status browser-demo (to see connection details)"
else
    echo "Skipped opening browser VS Code"
fi
echo ""

print_step "5" "Alternative: Desktop VS Code"
echo "For comparison, here's how to open in desktop VS Code:"
print_command "devpod ide vscode browser-demo"
echo ""

print_step "6" "Workspace Management"
echo "Useful commands for managing your workspace:"
echo ""
echo "Check status:"
print_command "devpod status browser-demo"
echo ""
echo "SSH access (if you prefer terminal):"
print_command "devpod ssh browser-demo"
echo ""
echo "Stop workspace:"
print_command "devpod stop browser-demo"
echo ""
echo "Delete workspace:"
print_command "devpod delete browser-demo"
echo ""

print_header "Demo Complete!"
echo "You now know how to:"
echo "✅ Create DevPod workspaces"
echo "✅ Open them in VS Code browser"
echo "✅ Access your development environment from anywhere"
echo ""
echo "🌐 Browser VS Code URL is typically: http://localhost:8080"
echo "🔧 Use 'devpod status <workspace>' to see exact URLs"
echo "📚 Check the README.md for more detailed documentation"
echo ""
echo "Happy coding in the browser! 🚀"