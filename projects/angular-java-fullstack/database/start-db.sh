#!/bin/bash
# Database Start Script
# Starts PostgreSQL and pgAdmin containers

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

print_error() {
    print_color $RED "❌ $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running"
        exit 1
    fi
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not installed"
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

wait_for_database() {
    print_info "Waiting for PostgreSQL to be ready..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker exec dev-postgres pg_isready -U devuser -d devdb &> /dev/null; then
            print_success "PostgreSQL is ready!"
            return 0
        fi
        
        printf "."
        sleep 2
        ((attempt++))
    done
    
    print_warning "PostgreSQL might not be fully ready yet, but containers are running"
    return 1
}

main() {
    print_header "🚀 Starting Development Database Environment"
    
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Get compose command
    COMPOSE_CMD=$(get_compose_cmd)
    
    # Create db-data-files directory if it doesn't exist
    mkdir -p db-data-files
    
    print_info "Starting database containers..."
    $COMPOSE_CMD up -d
    
    # Wait for database to be ready
    wait_for_database
    
    echo ""
    print_success "✅ Database environment started successfully!"
    echo ""
    print_info "📊 Database Connection Details:"
    print_color $GREEN "   Host: localhost"
    print_color $GREEN "   Port: 5432"
    print_color $GREEN "   Database: devdb"
    print_color $GREEN "   Username: devuser"
    print_color $GREEN "   Password: devpass123"
    echo ""
    print_info "🌐 pgAdmin Web Interface:"
    print_color $GREEN "   URL: http://localhost:8080"
    print_color $GREEN "   Email: admin@dev.local"
    print_color $GREEN "   Password: admin123"
    echo ""
    print_info "🛠️  Management Commands:"
    print_color $BLUE "   ./start-db.sh    - Start database"
    print_color $BLUE "   ./stop-db.sh     - Stop database"
    print_color $BLUE "   ./reset-db.sh    - Reset database (clears all data)"
    print_color $BLUE "   ./status-db.sh   - Check database status"
    echo ""
    print_info "📝 The database server will be automatically configured with schema and seed data"
    print_warning "Note: First startup may take a few minutes to download images and initialize database"
}

main "$@"