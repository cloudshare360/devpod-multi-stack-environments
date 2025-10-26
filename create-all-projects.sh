#!/bin/bash
# Quick Project Creator for DevPod
# This script creates multiple project folders with basic structure

set -e

PROJECTS_DIR="/home/sri/Downloads/dev-pod-cli-ws/projects"

create_react_project() {
    local project_dir="$PROJECTS_DIR/react-project"
    mkdir -p "$project_dir"/{.devcontainer,src/components,src/hooks,src/styles,public}
    
    # DevContainer
    cat > "$project_dir/.devcontainer/devcontainer.json" << 'EOF'
{
    "name": "React Development Environment",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {"version": "18"}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "bradlc.vscode-tailwindcss",
                "ms-vscode.vscode-eslint"
            ]
        }
    },
    "forwardPorts": [3000, 3001],
    "postCreateCommand": "npm install",
    "remoteUser": "node"
}
EOF
    
    # Package.json
    cat > "$project_dir/package.json" << 'EOF'
{
  "name": "react-devpod-project",
  "version": "1.0.0",
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0"
  },
  "devDependencies": {
    "react-scripts": "5.0.1",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^4.9.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  }
}
EOF

    # Management script
    cat > "$project_dir/manage-devpod.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME="react-project"
WORKSPACE_ID="react-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting React DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ React environment started!"
        echo "🌐 Frontend: http://localhost:3000"
        ;;
    stop)
        echo "🛑 Stopping React DevPod Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting React Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac
EOF
    chmod +x "$project_dir/manage-devpod.sh"
    
    # Basic README
    cat > "$project_dir/README.md" << 'EOF'
# React DevPod Project

React 18 development environment configured for DevPod.

## Quick Start
```bash
./manage-devpod.sh start
```

## Available Scripts
- `npm start` - Start development server
- `npm build` - Build for production
- `npm test` - Run tests

## Endpoints
- Frontend: http://localhost:3000
EOF
}

create_angular_project() {
    local project_dir="$PROJECTS_DIR/angular-project"
    mkdir -p "$project_dir"/{.devcontainer,src/app/components,src/assets}
    
    # DevContainer
    cat > "$project_dir/.devcontainer/devcontainer.json" << 'EOF'
{
    "name": "Angular Development Environment",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {"version": "18"}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "ms-vscode.vscode-typescript-next",
                "johnpapa.Angular2"
            ]
        }
    },
    "forwardPorts": [4200, 4201],
    "postCreateCommand": "npm install -g @angular/cli@17 && npm install",
    "remoteUser": "node"
}
EOF

    # Package.json
    cat > "$project_dir/package.json" << 'EOF'
{
  "name": "angular-devpod-project",
  "version": "1.0.0",
  "scripts": {
    "ng": "ng",
    "start": "ng serve --host 0.0.0.0",
    "build": "ng build",
    "test": "ng test"
  },
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/router": "^17.0.0",
    "@angular/forms": "^17.0.0"
  },
  "devDependencies": {
    "@angular/cli": "^17.0.0",
    "typescript": "~5.2.0"
  }
}
EOF

    # Management script
    cat > "$project_dir/manage-devpod.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME="angular-project"
WORKSPACE_ID="angular-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting Angular DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ Angular environment started!"
        echo "🌐 Frontend: http://localhost:4200"
        ;;
    stop)
        echo "🛑 Stopping Angular DevPod Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting Angular Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac
EOF
    chmod +x "$project_dir/manage-devpod.sh"
    
    # Basic README
    cat > "$project_dir/README.md" << 'EOF'
# Angular DevPod Project

Angular 17 development environment configured for DevPod.

## Quick Start
```bash
./manage-devpod.sh start
```

## Available Scripts
- `ng serve` - Start development server
- `ng build` - Build for production
- `ng test` - Run tests

## Endpoints
- Frontend: http://localhost:4200
EOF
}

create_mern_fullstack_project() {
    local project_dir="$PROJECTS_DIR/mern-fullstack"
    mkdir -p "$project_dir"/{.devcontainer,frontend/src,backend/src,docker}
    
    # DevContainer with Docker Compose
    cat > "$project_dir/.devcontainer/devcontainer.json" << 'EOF'
{
    "name": "MERN Stack Development",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "frontend",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "ms-vscode.vscode-eslint"
            ]
        }
    },
    "forwardPorts": [3000, 5000, 27017],
    "postCreateCommand": "cd frontend && npm install && cd ../backend && npm install"
}
EOF

    # Docker Compose
    cat > "$project_dir/docker-compose.yml" << 'EOF'
version: '3.8'
services:
  frontend:
    build: ./frontend
    volumes:
      - .:/workspace:cached
    ports:
      - "3000:3000"
    depends_on:
      - backend
    environment:
      - REACT_APP_API_URL=http://localhost:5000

  backend:
    build: ./backend
    volumes:
      - ./backend:/app
    ports:
      - "5000:5000"
    depends_on:
      - mongodb
    environment:
      - MONGODB_URL=mongodb://mongodb:27017/mernapp

  mongodb:
    image: mongo:latest
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
EOF

    # Frontend Dockerfile
    cat > "$project_dir/frontend/Dockerfile" << 'EOF'
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
EOF

    # Backend Dockerfile
    cat > "$project_dir/backend/Dockerfile" << 'EOF'
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm", "run", "dev"]
EOF

    # Management script
    cat > "$project_dir/manage-devpod.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME="mern-fullstack"
WORKSPACE_ID="mern-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting MERN Stack DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ MERN Stack environment started!"
        echo "🌐 Frontend: http://localhost:3000"
        echo "🔧 Backend: http://localhost:5000"
        echo "🗄️  MongoDB: localhost:27017"
        ;;
    stop)
        echo "🛑 Stopping MERN Stack Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting MERN Stack Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac
EOF
    chmod +x "$project_dir/manage-devpod.sh"
    
    # README
    cat > "$project_dir/README.md" << 'EOF'
# MERN Stack DevPod Project

MongoDB + Express + React + Node.js full-stack development environment.

## Quick Start
```bash
./manage-devpod.sh start
```

## Services
- Frontend (React): http://localhost:3000
- Backend (Express): http://localhost:5000
- Database (MongoDB): localhost:27017

## Architecture
- Frontend: React 18 with TypeScript
- Backend: Node.js with Express
- Database: MongoDB
- Container: Docker Compose
EOF
}

create_angular_java_fullstack_project() {
    local project_dir="$PROJECTS_DIR/angular-java-fullstack"
    mkdir -p "$project_dir"/{.devcontainer,frontend/src,backend/src/main/java/com/app}
    
    # DevContainer with Docker Compose
    cat > "$project_dir/.devcontainer/devcontainer.json" << 'EOF'
{
    "name": "Angular-Java-PostgreSQL Stack",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "development",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "redhat.java",
                "ms-vscode.vscode-typescript-next",
                "vscjava.vscode-java-pack"
            ]
        }
    },
    "forwardPorts": [4200, 8080, 5432, 8081],
    "postCreateCommand": "cd frontend && npm install -g @angular/cli@17 && npm install"
}
EOF

    # Docker Compose
    cat > "$project_dir/docker-compose.yml" << 'EOF'
version: '3.8'
services:
  development:
    image: mcr.microsoft.com/devcontainers/java:17
    volumes:
      - .:/workspace:cached
    ports:
      - "4200:4200"
      - "8080:8080"
    depends_on:
      - postgres
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/appdb
      - SPRING_DATASOURCE_USERNAME=appuser
      - SPRING_DATASOURCE_PASSWORD=apppass
    command: sleep infinity

  postgres:
    image: postgres:15
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  adminer:
    image: adminer:latest
    ports:
      - "8081:8080"
    depends_on:
      - postgres

volumes:
  postgres_data:
EOF

    # Management script
    cat > "$project_dir/manage-devpod.sh" << 'EOF'
#!/bin/bash
PROJECT_NAME="angular-java-fullstack"
WORKSPACE_ID="angular-java-devpod-workspace"

case "${1:-start}" in
    start)
        echo "🚀 Starting Angular-Java-PostgreSQL DevPod Environment"
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        echo "✅ Full Stack environment started!"
        echo "🌐 Frontend: http://localhost:4200"
        echo "🔧 Backend: http://localhost:8080"
        echo "🗄️  Database: localhost:5432"
        echo "🛠️  Adminer: http://localhost:8081"
        ;;
    stop)
        echo "🛑 Stopping Full Stack Environment"
        devpod stop "$WORKSPACE_ID"
        ;;
    restart)
        echo "🔄 Restarting Full Stack Environment"
        devpod stop "$WORKSPACE_ID"
        sleep 2
        devpod up . --id "$WORKSPACE_ID" --ide vscode
        ;;
    *)
        echo "Usage: $0 [start|stop|restart]"
        ;;
esac
EOF
    chmod +x "$project_dir/manage-devpod.sh"
    
    # README
    cat > "$project_dir/README.md" << 'EOF'
# Angular-Java-PostgreSQL DevPod Project

Full-stack development environment with Angular 17, Java 17, and PostgreSQL.

## Quick Start
```bash
./manage-devpod.sh start
```

## Services
- Frontend (Angular): http://localhost:4200
- Backend (Spring Boot): http://localhost:8080
- Database (PostgreSQL): localhost:5432
- Admin (Adminer): http://localhost:8081

## Technology Stack
- Frontend: Angular 17 with TypeScript
- Backend: Java 17 with Spring Boot
- Database: PostgreSQL 15
- Admin: Adminer for database management
EOF
}

# Create all projects
echo "🏗️  Creating all project folders..."

create_react_project
echo "✅ React project created"

create_angular_project
echo "✅ Angular project created"

create_mern_fullstack_project
echo "✅ MERN fullstack project created"

create_angular_java_fullstack_project
echo "✅ Angular-Java fullstack project created"

echo ""
echo "🎉 All project folders created successfully!"
echo ""
echo "📁 Available projects:"
echo "   - nodejs-project"
echo "   - java17-project"
echo "   - python3-project"
echo "   - react-project"
echo "   - angular-project"
echo "   - mern-fullstack"
echo "   - angular-java-fullstack"