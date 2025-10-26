#!/bin/bash
# Complete DevPod Environment Setup Script
# Usage: ./complete-setup.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $CYAN "=================================="
    print_color $CYAN "$1"
    print_color $CYAN "=================================="
    echo ""
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_error() {
    print_color $RED "❌ $1"
}

print_warning() {
    print_color $YELLOW "⚠️  $1"
}

print_info() {
    print_color $BLUE "ℹ️  $1"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check if DevPod is installed
    if ! command -v devpod &> /dev/null; then
        print_error "DevPod CLI not found. Please run install-devpod.sh first"
        exit 1
    fi
    print_success "DevPod CLI found: $(devpod version)"
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker"
        exit 1
    fi
    print_success "Docker is running"
    
    # Check if generate script exists
    if [ ! -f "generate-devcontainer.sh" ]; then
        print_error "generate-devcontainer.sh not found in current directory"
        exit 1
    fi
    print_success "DevContainer generator script found"
}

# Setup functions for different environments
setup_nodejs_environment() {
    local project_name=$1
    print_info "Setting up Node.js environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh nodejs "$project_name"
    
    # Create additional files
    cat > README.md << EOF
# $project_name - Node.js Project

This is a Node.js project configured with DevPod.

## Getting Started

1. The DevContainer is already configured
2. Install dependencies: \`npm install\`
3. Start development server: \`npm run dev\`
4. Visit: http://localhost:3000

## Available Scripts

- \`npm start\` - Start the production server
- \`npm run dev\` - Start development server with nodemon
- \`npm test\` - Run tests

## API Endpoints

- \`GET /\` - Hello world message
- \`GET /health\` - Health check endpoint
EOF

    print_success "Node.js project created: $project_name"
    cd ..
}

setup_python_environment() {
    local project_name=$1
    print_info "Setting up Python environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh python "$project_name"
    
    # Create additional files
    cat > README.md << EOF
# $project_name - Python Project

This is a Python project configured with DevPod using FastAPI.

## Getting Started

1. The DevContainer is already configured
2. Install dependencies: \`pip install -r requirements.txt\`
3. Start server: \`python main.py\`
4. Visit: http://localhost:8000

## Available Commands

- \`python main.py\` - Start the FastAPI server
- \`pytest\` - Run tests
- \`black .\` - Format code
- \`flake8 .\` - Lint code

## API Endpoints

- \`GET /\` - Hello world message
- \`GET /health\` - Health check endpoint
- \`GET /docs\` - Interactive API documentation
EOF

    cat > .gitignore << EOF
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.coverage
htmlcov/
.venv/
env/
ENV/
.env
EOF

    print_success "Python project created: $project_name"
    cd ..
}

setup_java_environment() {
    local project_name=$1
    print_info "Setting up Java environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh java "$project_name"
    
    # Create additional files
    cat > README.md << EOF
# $project_name - Java Spring Boot Project

This is a Java Spring Boot project configured with DevPod.

## Getting Started

1. The DevContainer is already configured
2. Compile: \`mvn clean compile\`
3. Run: \`mvn spring-boot:run\`
4. Visit: http://localhost:8080

## Available Commands

- \`mvn clean compile\` - Compile the project
- \`mvn spring-boot:run\` - Run the application
- \`mvn test\` - Run tests
- \`mvn clean package\` - Build JAR file

## API Endpoints

- \`GET /\` - Hello world message
- \`GET /health\` - Health check endpoint
EOF

    cat > .gitignore << EOF
target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**/target/
!**/src/test/**/target/

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

### Eclipse ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### VS Code ###
.vscode/

### Mac ###
.DS_Store
EOF

    print_success "Java project created: $project_name"
    cd ..
}

setup_react_environment() {
    local project_name=$1
    print_info "Setting up React environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh react "$project_name"
    
    # Create additional files if not created by create-react-app
    if [ ! -f "src/App.js" ]; then
        mkdir -p src public
        
        cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>$project_name</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF

        cat > src/App.tsx << EOF
import React from 'react';

function App() {
  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>🚀 Welcome to $project_name</h1>
      <p>This React app is running in DevPod!</p>
      <p>Edit <code>src/App.tsx</code> and save to reload.</p>
    </div>
  );
}

export default App;
EOF

        cat > src/index.tsx << EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(<App />);
EOF
    fi

    cat > README.md << EOF
# $project_name - React Project

This is a React project configured with DevPod.

## Getting Started

1. The DevContainer is already configured
2. Install dependencies: \`npm install\`
3. Start development server: \`npm start\`
4. Visit: http://localhost:3000

## Available Scripts

- \`npm start\` - Start development server
- \`npm run build\` - Build for production
- \`npm test\` - Run tests
- \`npm run eject\` - Eject from Create React App

## Features

- TypeScript support
- Hot reloading
- ESLint and Prettier configured
- Tailwind CSS support
EOF

    print_success "React project created: $project_name"
    cd ..
}

setup_angular_environment() {
    local project_name=$1
    print_info "Setting up Angular environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh angular "$project_name"
    
    cat > README.md << EOF
# $project_name - Angular Project

This is an Angular 17 project configured with DevPod.

## Getting Started

1. The DevContainer is already configured
2. Install dependencies: \`npm install\`
3. Create Angular project: \`ng new . --routing --style=css\`
4. Start development server: \`npm start\`
5. Visit: http://localhost:4200

## Available Scripts

- \`npm start\` - Start development server
- \`ng build\` - Build for production
- \`ng test\` - Run unit tests
- \`ng e2e\` - Run end-to-end tests
- \`ng generate component <name>\` - Generate new component

## Features

- Angular 17
- TypeScript support
- Hot reloading
- Angular CLI included
EOF

    print_success "Angular project created: $project_name"
    cd ..
}

setup_fullstack_environment() {
    local project_name=$1
    print_info "Setting up Full Stack Angular + Java + PostgreSQL environment"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Generate devcontainer
    bash ../generate-devcontainer.sh angular-java "$project_name"
    
    # Create startup script
    cat > start-services.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting Full Stack Application"
echo "=================================="

# Start PostgreSQL and Adminer via Docker Compose
echo "📦 Starting database services..."
docker-compose up -d postgres adminer

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

# Start Spring Boot backend
echo "☕ Starting Java backend..."
cd backend
mvn spring-boot:run &
BACKEND_PID=$!

# Start Angular frontend
echo "🅰️  Starting Angular frontend..."
cd ../frontend
npm install
npm start &
FRONTEND_PID=$!

echo ""
echo "✅ Services started successfully!"
echo ""
echo "📱 Frontend: http://localhost:4200"
echo "🔧 Backend API: http://localhost:8080"
echo "🗄️  Database Admin: http://localhost:8081"
echo "   - Server: postgres"
echo "   - Username: devuser"
echo "   - Password: devpass"
echo "   - Database: devdb"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for interrupt
trap "echo 'Stopping services...'; kill $BACKEND_PID $FRONTEND_PID; docker-compose down; exit 0" INT
wait
EOF

    chmod +x start-services.sh

    cat > README.md << EOF
# $project_name - Full Stack Application

Angular 17 + Java 17 + PostgreSQL + Adminer

## Architecture

- **Frontend**: Angular 17 (http://localhost:4200)
- **Backend**: Spring Boot with Java 17 (http://localhost:8080)
- **Database**: PostgreSQL 15 (localhost:5432)
- **Admin**: Adminer (http://localhost:8081)

## Getting Started

1. The DevContainer is already configured with Docker Compose
2. Run the startup script: \`./start-services.sh\`
3. Access the applications:
   - Frontend: http://localhost:4200
   - Backend API: http://localhost:8080
   - Database Admin: http://localhost:8081

## Database Connection

- **Host**: postgres (from containers) or localhost (from host)
- **Port**: 5432
- **Database**: devdb
- **Username**: devuser
- **Password**: devpass

## Development Workflow

1. **Frontend Development**: Edit files in \`frontend/\` directory
2. **Backend Development**: Edit files in \`backend/\` directory
3. **Database Management**: Use Adminer at http://localhost:8081

## Useful Commands

\`\`\`bash
# Start all services
./start-services.sh

# Start only database services
docker-compose up -d postgres adminer

# Stop all services
docker-compose down

# View logs
docker-compose logs postgres
docker-compose logs adminer

# Backend only
cd backend && mvn spring-boot:run

# Frontend only
cd frontend && npm start
\`\`\`
EOF

    print_success "Full Stack project created: $project_name"
    cd ..
}

# Interactive menu
show_menu() {
    print_header "DevPod Environment Setup"
    echo "Select the environment you want to create:"
    echo ""
    echo "1. 🟢 Node.js"
    echo "2. 🐍 Python (FastAPI)"
    echo "3. ☕ Java (Spring Boot)"
    echo "4. ⚛️  React.js"
    echo "5. 🅰️  Angular 17"
    echo "6. 🌐 MEAN Stack (MongoDB + Express + Angular + Node)"
    echo "7. 🌐 MERN Stack (MongoDB + Express + React + Node)"
    echo "8. 🌐 MEVN Stack (MongoDB + Express + Vue + Node)"
    echo "9. 🏗️  Full Stack (Angular 17 + Java 17 + PostgreSQL + Adminer)"
    echo "0. 🚪 Exit"
    echo ""
}

# Get project name
get_project_name() {
    while true; do
        read -p "Enter project name (lowercase, no spaces): " project_name
        if [[ $project_name =~ ^[a-z0-9-]+$ ]]; then
            break
        else
            print_error "Invalid project name. Use only lowercase letters, numbers, and hyphens."
        fi
    done
}

# Create workspace with DevPod
create_workspace() {
    local project_name=$1
    print_info "Creating DevPod workspace..."
    
    cd "$project_name"
    devpod up . --id "${project_name}-workspace" --ide vscode
    print_success "DevPod workspace created: ${project_name}-workspace"
    cd ..
}

# Main execution
main() {
    print_header "DevPod Complete Environment Setup"
    
    # Check prerequisites
    check_prerequisites
    
    while true; do
        show_menu
        read -p "Enter your choice (0-9): " choice
        
        case $choice in
            1)
                get_project_name
                setup_nodejs_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            2)
                get_project_name
                setup_python_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            3)
                get_project_name
                setup_java_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            4)
                get_project_name
                setup_react_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            5)
                get_project_name
                setup_angular_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            6)
                print_warning "MEAN Stack setup not implemented yet. Please use individual Node.js and Angular setups."
                ;;
            7)
                print_warning "MERN Stack setup not implemented yet. Please use individual React and Node.js setups."
                ;;
            8)
                print_warning "MEVN Stack setup not implemented yet. Please use individual Vue and Node.js setups."
                ;;
            9)
                get_project_name
                setup_fullstack_environment "$project_name"
                read -p "Create DevPod workspace now? (y/n): " create_ws
                if [[ $create_ws =~ ^[Yy]$ ]]; then
                    create_workspace "$project_name"
                fi
                ;;
            0)
                print_info "Goodbye! 👋"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter a number between 0-9."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
    done
}

# Run main function
main