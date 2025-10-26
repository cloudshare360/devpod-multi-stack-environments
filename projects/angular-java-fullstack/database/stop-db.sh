#!/bin/bash
# Database Stop Script
# Stops PostgreSQL and pgAdmin containers

set -e

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
    print_color $BLUE "=================================================="
    print_color $BLUE "$1"
    print_color $BLUE "=================================================="
    echo ""
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_info() {
    print_color $BLUE "ℹ️  $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_color $RED "❌ Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_color $RED "❌ Docker daemon is not running"
        exit 1
    fi
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_color $RED "❌ Docker Compose is not installed"
        exit 1
    fi
}

# Function to get the correct docker compose command
get_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

main() {
    print_header "🛑 Stopping Development Database Environment"
    
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Get compose command
    COMPOSE_CMD=$(get_compose_cmd)
    
    print_info "Stopping database containers..."
    $COMPOSE_CMD down
    
    echo ""
    print_success "✅ Database environment stopped successfully!"
    echo ""
    print_info "📝 Note: Database data is preserved in ./db-data-files/"
    print_info "🔄 Use './start-db.sh' to start the database again"
    print_info "🗑️  Use './reset-db.sh' to completely reset the database"
}

main "$@"