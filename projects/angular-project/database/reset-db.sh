#!/bin/bash
# Database Reset Script
# Stops containers and removes all data

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

print_warning() {
    print_color $YELLOW "⚠️  $1"
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

confirm_reset() {
    echo ""
    print_warning "⚠️  WARNING: This will PERMANENTLY DELETE all database data!"
    print_warning "⚠️  This action cannot be undone!"
    echo ""
    read -p "Are you sure you want to reset the database? (type 'yes' to confirm): " confirm
    
    if [[ $confirm != "yes" ]]; then
        print_info "Reset cancelled."
        exit 0
    fi
}

main() {
    print_header "🗑️  Resetting Development Database Environment"
    
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Confirm the destructive action
    confirm_reset
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Get compose command
    COMPOSE_CMD=$(get_compose_cmd)
    
    print_info "Stopping and removing containers..."
    $COMPOSE_CMD down -v
    
    print_info "Removing database data files..."
    if [[ -d "db-data-files" ]]; then
        rm -rf db-data-files/*
        print_success "Database data cleared"
    fi
    
    print_info "Removing Docker volumes..."
    docker volume ls | grep -q "master-database" && docker volume ls | grep "master-database" | awk '{print $2}' | xargs docker volume rm 2>/dev/null || true
    
    echo ""
    print_success "✅ Database environment reset successfully!"
    echo ""
    print_info "🔄 Use './start-db.sh' to start a fresh database"
    print_info "📝 Schema and seed data will be automatically applied on next start"
}

main "$@"