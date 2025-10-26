#!/bin/bash
# Database Status Script
# Shows the status of database containers

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
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running"
        return 1
    fi
    return 0
}

# Function to get the correct docker compose command
get_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

check_container_status() {
    local container_name=$1
    local service_name=$2
    
    if docker ps --format "table {{.Names}}" | grep -q "^${container_name}$"; then
        print_success "$service_name is running"
        return 0
    elif docker ps -a --format "table {{.Names}}" | grep -q "^${container_name}$"; then
        print_warning "$service_name container exists but is not running"
        return 1
    else
        print_error "$service_name container not found"
        return 1
    fi
}

test_database_connection() {
    print_info "Testing database connection..."
    if docker exec dev-postgres pg_isready -U devuser -d devdb &> /dev/null; then
        print_success "Database is accepting connections"
        
        # Get database info
        local db_version=$(docker exec dev-postgres psql -U devuser -d devdb -t -c "SELECT version();" 2>/dev/null | head -1 | xargs)
        local table_count=$(docker exec dev-postgres psql -U devuser -d devdb -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | xargs)
        
        print_info "PostgreSQL Version: ${db_version}"
        print_info "Tables in database: ${table_count}"
    else
        print_warning "Database is not ready or not accepting connections"
    fi
}

main() {
    print_header "📊 Database Environment Status"
    
    # Check Docker
    if ! check_docker; then
        exit 1
    fi
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    echo ""
    print_info "Container Status:"
    echo ""
    
    # Check PostgreSQL container
    check_container_status "dev-postgres" "PostgreSQL Database"
    postgres_running=$?
    
    # Check pgAdmin container
    check_container_status "dev-pgadmin" "pgAdmin Web UI"
    pgadmin_running=$?
    
    echo ""
    
    # Test database connection if PostgreSQL is running
    if [ $postgres_running -eq 0 ]; then
        test_database_connection
    fi
    
    echo ""
    print_info "📊 Connection Information:"
    print_color $GREEN "   PostgreSQL: localhost:5432"
    print_color $GREEN "   Database: devdb"
    print_color $GREEN "   Username: devuser"
    print_color $GREEN "   Password: devpass123"
    echo ""
    print_color $GREEN "   pgAdmin: http://localhost:8080"
    print_color $GREEN "   Email: admin@dev.local"
    print_color $GREEN "   Password: admin123"
    
    echo ""
    print_info "🛠️  Management Commands:"
    print_color $BLUE "   ./start-db.sh    - Start database"
    print_color $BLUE "   ./stop-db.sh     - Stop database"
    print_color $BLUE "   ./reset-db.sh    - Reset database"
    print_color $BLUE "   ./status-db.sh   - Check status"
    
    # Show compose status
    COMPOSE_CMD=$(get_compose_cmd)
    echo ""
    print_info "📋 Docker Compose Status:"
    echo ""
    $COMPOSE_CMD ps 2>/dev/null || print_warning "No compose services found or compose file not accessible"
}

main "$@"