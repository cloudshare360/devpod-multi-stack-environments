# DevPod CLI Tutorial & Development Environment Setup

## Table of Contents
1. [DevPod CLI Installation](#1-devpod-cli-installation)
2. [DevPod CLI Commands](#2-devpod-cli-commands)
3. [DevContainer Configuration](#3-devcontainer-configuration)
4. [Working with DevPod CLI (Localhost & LAN)](#4-working-with-devpod-cli-localhost--lan)
5. [Programming Environment Templates](#5-programming-environment-templates)

---

## 1. DevPod CLI Installation

### 1.1 Prerequisites
- Ubuntu/Debian Linux environment
- Docker installed and running
- Internet connection for downloading packages

### 1.2 Automated Installation Script

Create and run the following installation script:

```bash
#!/bin/bash
# File: install-devpod.sh

set -e

echo "🚀 DevPod CLI Installation Script"
echo "=================================="

# Check if running on Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    echo "❌ This script is designed for Ubuntu/Debian systems"
    exit 1
fi

# Update system packages
echo "📦 Updating system packages..."
sudo apt update

# Install required dependencies
echo "🔧 Installing dependencies..."
sudo apt install -y curl wget gnupg2 software-properties-common

# Download and install DevPod CLI
echo "⬇️  Downloading DevPod CLI..."
DEVPOD_VERSION=$(curl -s https://api.github.com/repos/loft-sh/devpod/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DEVPOD_URL="https://github.com/loft-sh/devpod/releases/download/${DEVPOD_VERSION}/devpod-linux-amd64"

# Download DevPod binary
curl -L "${DEVPOD_URL}" -o devpod
chmod +x devpod

# Move to system path
sudo mv devpod /usr/local/bin/

# Verify installation
echo "✅ Verifying installation..."
if devpod version; then
    echo "🎉 DevPod CLI installed successfully!"
else
    echo "❌ Installation failed"
    exit 1
fi

# Add to PATH if not already present
if ! echo $PATH | grep -q "/usr/local/bin"; then
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    echo "📝 Added /usr/local/bin to PATH in ~/.bashrc"
fi

echo "🔄 Please reload your shell or run: source ~/.bashrc"
echo "📚 Documentation: https://devpod.sh/docs"
```

### 1.3 Manual Installation Steps

1. **Download DevPod CLI:**
   ```bash
   curl -L https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64 -o devpod
   ```

2. **Make executable and install:**
   ```bash
   chmod +x devpod
   sudo mv devpod /usr/local/bin/
   ```

3. **Verify installation:**
   ```bash
   devpod version
   ```

4. **Add to PATH (if needed):**
   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

---

## 2. DevPod CLI Commands

### 2.1 Essential Commands Reference

| Command | Description | Example |
|---------|-------------|---------|
| `devpod version` | Show DevPod version | `devpod version` |
| `devpod provider` | Manage providers | `devpod provider list` |
| `devpod workspace` | Manage workspaces | `devpod workspace list` |
| `devpod up` | Start a workspace | `devpod up ./my-project` |
| `devpod stop` | Stop a workspace | `devpod stop my-workspace` |
| `devpod delete` | Delete a workspace | `devpod delete my-workspace` |
| `devpod ssh` | SSH into workspace | `devpod ssh my-workspace` |
| `devpod logs` | View workspace logs | `devpod logs my-workspace` |

### 2.2 Provider Management

```bash
# List available providers
devpod provider list

# Add Docker provider (default)
devpod provider add docker

# Add Kubernetes provider
devpod provider add kubernetes

# Set default provider
devpod provider use docker
```

### 2.3 Workspace Management

```bash
# Create workspace from local directory
devpod up ./my-project

# Create workspace from Git repository
devpod up https://github.com/username/repo.git

# Create workspace with specific name
devpod up ./project --id my-workspace

# List all workspaces
devpod workspace list

# Stop workspace
devpod stop my-workspace

# Delete workspace
devpod delete my-workspace
```

---

## 3. DevContainer Configuration

### 3.1 DevContainer.json Structure

The `devcontainer.json` file defines your development environment configuration:

```json
{
    "name": "Development Environment",
    "image": "base-image:tag",
    "features": {},
    "customizations": {
        "vscode": {
            "extensions": [],
            "settings": {}
        }
    },
    "forwardPorts": [],
    "postCreateCommand": "",
    "remoteUser": "vscode"
}
```

### 3.2 DevContainer Generator Script

```bash
#!/bin/bash
# File: generate-devcontainer.sh

create_devcontainer() {
    local env_type=$1
    local project_name=$2
    
    mkdir -p .devcontainer
    
    case $env_type in
        "nodejs")
            generate_nodejs_devcontainer "$project_name"
            ;;
        "python")
            generate_python_devcontainer "$project_name"
            ;;
        "java")
            generate_java_devcontainer "$project_name"
            ;;
        "react")
            generate_react_devcontainer "$project_name"
            ;;
        "angular")
            generate_angular_devcontainer "$project_name"
            ;;
        "mean")
            generate_mean_devcontainer "$project_name"
            ;;
        "mern")
            generate_mern_devcontainer "$project_name"
            ;;
        "mevn")
            generate_mevn_devcontainer "$project_name"
            ;;
        "angular-java")
            generate_angular_java_devcontainer "$project_name"
            ;;
        *)
            echo "❌ Unknown environment type: $env_type"
            exit 1
            ;;
    esac
    
    echo "✅ DevContainer configuration created for $env_type environment"
}

# Usage: ./generate-devcontainer.sh <env_type> <project_name>
create_devcontainer "$1" "$2"
```

---

## 4. Working with DevPod CLI (Localhost & LAN)

### 4.1 Localhost Development

1. **Start a local workspace:**
   ```bash
   devpod up ./my-project --provider docker
   ```

2. **Access via VS Code:**
   ```bash
   devpod up ./my-project --ide vscode
   ```

3. **Port forwarding for local access:**
   ```bash
   devpod up ./my-project --forward-ports 3000,8080
   ```

### 4.2 LAN Development Setup

1. **Configure DevPod for LAN access:**
   ```bash
   # Set up remote provider
   devpod provider add docker --option DOCKER_HOST=tcp://192.168.1.100:2376
   ```

2. **Create workspace accessible over LAN:**
   ```bash
   devpod up ./project --provider docker --option expose-ports=true
   ```

3. **SSH access over LAN:**
   ```bash
   devpod ssh my-workspace --ssh-user devpod --ssh-host 192.168.1.100
   ```

---

## 5. Programming Environment Templates

### 5.1 Node.js Environment

#### DevContainer Configuration
```json
{
    "name": "Node.js Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "ms-vscode.vscode-eslint"
            ]
        }
    },
    "forwardPorts": [3000, 8000],
    "postCreateCommand": "npm install"
}
```

#### Setup Script
```bash
#!/bin/bash
# File: setup-nodejs.sh

echo "🟢 Setting up Node.js environment"
mkdir -p nodejs-project/.devcontainer
cd nodejs-project

# Create package.json
cat > package.json << EOF
{
  "name": "nodejs-devpod-project",
  "version": "1.0.0",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0"
  }
}
EOF

# Create basic Express app
cat > index.js << EOF
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.json({ message: 'Hello from DevPod Node.js!' });
});

app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
});
EOF

echo "✅ Node.js project structure created"
devpod up . --id nodejs-workspace
```

### 5.2 Python Environment

#### DevContainer Configuration
```json
{
    "name": "Python Development",
    "image": "mcr.microsoft.com/devcontainers/python:3.11",
    "features": {
        "ghcr.io/devcontainers/features/python:1": {
            "version": "3.11"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-python.pylint",
                "ms-python.black-formatter"
            ]
        }
    },
    "forwardPorts": [8000, 5000],
    "postCreateCommand": "pip install -r requirements.txt"
}
```

### 5.3 Java Environment

#### DevContainer Configuration
```json
{
    "name": "Java Development",
    "image": "mcr.microsoft.com/devcontainers/java:17",
    "features": {
        "ghcr.io/devcontainers/features/java:1": {
            "version": "17"
        },
        "ghcr.io/devcontainers/features/maven:1": {}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "redhat.java",
                "vscjava.vscode-java-pack"
            ]
        }
    },
    "forwardPorts": [8080, 8443]
}
```

### 5.4 React.js Environment

#### DevContainer Configuration
```json
{
    "name": "React Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "bradlc.vscode-tailwindcss"
            ]
        }
    },
    "forwardPorts": [3000, 3001],
    "postCreateCommand": "npm install"
}
```

### 5.5 Angular Environment

#### DevContainer Configuration
```json
{
    "name": "Angular Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
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
    "postCreateCommand": "npm install -g @angular/cli && npm install"
}
```

### 5.6 MEAN Stack Environment

#### DevContainer Configuration
```json
{
    "name": "MEAN Stack Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "ms-vscode.vscode-typescript-next",
                "ms-vscode.vscode-json"
            ]
        }
    },
    "forwardPorts": [3000, 4200, 27017],
    "postCreateCommand": "npm install -g @angular/cli && npm install",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app"
}
```

#### Docker Compose for MEAN
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - .:/workspace:cached
    ports:
      - "3000:3000"
      - "4200:4200"
    depends_on:
      - mongodb
  
  mongodb:
    image: mongo:latest
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
```

### 5.7 MERN Stack Environment

#### DevContainer Configuration
```json
{
    "name": "MERN Stack Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode",
                "bradlc.vscode-tailwindcss"
            ]
        }
    },
    "forwardPorts": [3000, 5000, 27017],
    "postCreateCommand": "npm install",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app"
}
```

### 5.8 MEVN Stack Environment

#### DevContainer Configuration
```json
{
    "name": "MEVN Stack Development",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "18"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "octref.vetur",
                "ms-vscode.vscode-typescript-next",
                "esbenp.prettier-vscode"
            ]
        }
    },
    "forwardPorts": [8080, 3000, 27017],
    "postCreateCommand": "npm install -g @vue/cli && npm install"
}
```

### 5.9 Angular 18 + Java 17 + PostgreSQL + Adminer

#### DevContainer Configuration
```json
{
    "name": "Angular-Java-PostgreSQL Stack",
    "dockerComposeFile": "docker-compose.yml",
    "service": "app",
    "workspaceFolder": "/workspace",
    "customizations": {
        "vscode": {
            "extensions": [
                "Angular.ng-template",
                "redhat.java",
                "ms-vscode.vscode-typescript-next",
                "ms-mssql.mssql"
            ]
        }
    },
    "forwardPorts": [4200, 8080, 5432, 8081],
    "postCreateCommand": "npm install -g @angular/cli"
}
```

#### Docker Compose for Full Stack
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: 
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/workspace:cached
    ports:
      - "4200:4200"
      - "8080:8080"
    depends_on:
      - postgres
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/devdb
      - SPRING_DATASOURCE_USERNAME=devuser
      - SPRING_DATASOURCE_PASSWORD=devpass

  postgres:
    image: postgres:15
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_ROOT_PASSWORD: rootpass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  adminer:
    image: adminer:latest
    ports:
      - "8081:8080"
    depends_on:
      - postgres
    environment:
      ADMINER_DEFAULT_SERVER: postgres

volumes:
  postgres_data:
```

#### Dockerfile for Angular-Java Stack
```dockerfile
# Dockerfile
FROM mcr.microsoft.com/devcontainers/java:17

# Install Node.js for Angular
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Angular CLI
RUN npm install -g @angular/cli

# Install Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /workspace
```

---

## Installation and Usage Scripts

### Complete Setup Script

```bash
#!/bin/bash
# File: complete-setup.sh

set -e

echo "🚀 DevPod Complete Environment Setup"
echo "====================================="

# Function to create environment
create_environment() {
    local env_type=$1
    local project_name=$2
    
    echo "🏗️  Creating $env_type environment: $project_name"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Copy appropriate devcontainer configuration
    case $env_type in
        "nodejs"|"react"|"angular"|"mean"|"mern"|"mevn")
            setup_frontend_backend "$env_type"
            ;;
        "java")
            setup_java_environment
            ;;
        "python")
            setup_python_environment
            ;;
        "angular-java")
            setup_fullstack_environment
            ;;
    esac
    
    # Start DevPod workspace
    devpod up . --id "$project_name-workspace"
    
    echo "✅ Environment $project_name created and started"
    cd ..
}

# Menu-driven setup
echo "Select environment to create:"
echo "1. Node.js"
echo "2. Python"
echo "3. Java"
echo "4. React.js"
echo "5. Angular"
echo "6. MEAN Stack"
echo "7. MERN Stack"
echo "8. MEVN Stack"
echo "9. Angular 18 + Java 17 + PostgreSQL"

read -p "Enter choice (1-9): " choice
read -p "Enter project name: " project_name

case $choice in
    1) create_environment "nodejs" "$project_name" ;;
    2) create_environment "python" "$project_name" ;;
    3) create_environment "java" "$project_name" ;;
    4) create_environment "react" "$project_name" ;;
    5) create_environment "angular" "$project_name" ;;
    6) create_environment "mean" "$project_name" ;;
    7) create_environment "mern" "$project_name" ;;
    8) create_environment "mevn" "$project_name" ;;
    9) create_environment "angular-java" "$project_name" ;;
    *) echo "❌ Invalid choice" ;;
esac
```

---

## Quick Reference

### Common Commands
```bash
# Install DevPod
curl -L https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64 -o devpod && chmod +x devpod && sudo mv devpod /usr/local/bin/

# Quick start
devpod up ./my-project

# List workspaces
devpod workspace list

# Stop workspace
devpod stop my-workspace

# SSH into workspace
devpod ssh my-workspace
```

### Troubleshooting

1. **DevPod not found in PATH:**
   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Docker permission issues:**
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

3. **Port conflicts:**
   ```bash
   devpod up ./project --forward-ports 3001,8081
   ```

---

## Resources

- **Official Documentation:** https://devpod.sh/docs
- **GitHub Repository:** https://github.com/loft-sh/devpod
- **Community Support:** https://slack.loft.sh/
