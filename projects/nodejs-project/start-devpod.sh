#!/bin/bash
# Node.js Project DevPod Management Script
# Usage: ./start-devpod.sh [start|stop|restart|status|logs|ssh|delete|clean-start]

# Project Configuration
PROJECT_NAME="nodejs-project"
WORKSPACE_ID="nodejs-devpod-workspace"
PROJECT_PORT="3000"

# Load enhanced management functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../manage-devpod-template.sh"

# Override the print_endpoints function for Node.js specific endpoints
print_endpoints() {
    echo ""
    print_color $GREEN "📋 Available endpoints:"
    print_color $GREEN "   🌐 Main API: http://localhost:3000"
    print_color $GREEN "   ❤️  Health Check: http://localhost:3000/health"
    print_color $GREEN "   👥 Users API: http://localhost:3000/api/users"
    echo ""
    print_color $BLUE "📝 Development commands:"
    print_color $BLUE "   npm run dev     - Start development server"
    print_color $BLUE "   npm run test    - Run tests"
    print_color $BLUE "   npm run lint    - Check code quality"
    print_color $BLUE "   npm run format  - Format code"
    print_color $BLUE "   npm run setup   - Setup project"
    echo ""
    print_color $BLUE "🛠️  Workspace management:"
    print_color $BLUE "   ./start-devpod.sh stop      - Stop workspace"
    print_color $BLUE "   ./start-devpod.sh restart   - Restart workspace"
    print_color $BLUE "   ./start-devpod.sh ssh       - SSH into workspace"
    print_color $BLUE "   ./start-devpod.sh logs      - View logs"
    print_color $BLUE "   ./start-devpod.sh clean-start - Force clean start"
}