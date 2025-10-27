# 🚀 DevPod CLI Project - Complete Guide

A comprehensive guide and workspace for learning and working with DevPod CLI. This project provides everything you need to get started with DevPod, from installation to advanced usage, with support for multiple programming languages.

## 📋 Interactive Features

This README includes interactive elements for better usability:

- 📋 **Copy to Clipboard**: Click the copy button next to code blocks to copy commands
- 🖥️ **Execute in Terminal**: Use the terminal button to run commands directly
- 🔗 **Quick Navigation**: Jump to sections with the enhanced table of contents
- 💡 **Pro Tips**: Hover over commands for additional context

> **Note**: Interactive features work best when viewing this README in VS Code or on GitHub with browser extensions.

## 📋 Table of Contents

- [🎯 Project Overview](#-project-overview)
- [🛠️ Installation Guide](#️-installation-guide)
- [🚀 Quick Start](#-quick-start)
- [📚 Documentation](#-documentation)
- [💻 Programming Languages](#-programming-languages)
- [🔧 Configuration](#-configuration)
- [📝 Tutorials](#-tutorials)
- [🎪 Examples](#-examples)
- [🔍 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)

## 🎯 Project Overview

This project serves as a **complete learning environment** for DevPod CLI, featuring:

- ✅ **Complete Installation Guide** - Step-by-step DevPod CLI installation
- ✅ **Multi-Language Support** - Pre-configured for 10+ programming languages
- ✅ **Real-World Examples** - Practical examples and use cases
- ✅ **Best Practices** - Industry-standard configurations and workflows
- ✅ **Troubleshooting Guide** - Solutions to common issues
- ✅ **Interactive Tutorials** - Hands-on learning experiences

## 🛠️ Installation Guide

### 1. Install DevPod CLI

#### Option A: Quick Install (Linux/macOS)
```bash
# Download and install latest version
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
sudo install -c -m 0755 devpod /usr/local/bin
rm devpod

# Verify installation
devpod version
```

<details>
<summary>📋 <strong>Copy individual commands</strong></summary>

```bash
# Step 1: Download DevPod
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
```

```bash
# Step 2: Install DevPod
sudo install -c -m 0755 devpod /usr/local/bin
```

```bash
# Step 3: Clean up
rm devpod
```

```bash
# Step 4: Verify installation
devpod version
```

</details>

#### Option B: Platform-Specific Installation

**Linux (Ubuntu/Debian):**
```bash
# Download the latest release
wget https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64
chmod +x devpod-linux-amd64
sudo mv devpod-linux-amd64 /usr/local/bin/devpod
```

**macOS:**
```bash
# Using Homebrew
brew install devpod

# Or download directly
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-darwin-amd64"
chmod +x devpod
sudo mv devpod /usr/local/bin/
```

**Windows:**
```powershell
# Download from releases page
# https://github.com/loft-sh/devpod/releases/latest/download/devpod-windows-amd64.exe
# Add to PATH
```

### 2. Install Docker (Required)
```bash
# Install Docker Engine
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
docker --version
```

### 3. Verify DevPod Installation
```bash
# Check DevPod version
devpod version

# List available providers
devpod provider list

# Check system status
devpod list
devpod context list
```

## 🚀 Quick Start

### 🎮 Interactive Command Helper

We provide **two ways** to interact with DevPod commands:

#### Option 1: Terminal Interactive Script
```bash
# Navigate to the project directory
cd projects/dev-pod-cli-project

# Run the interactive helper
./devpod-helper.sh

# Or try the VS Code browser demo
./browser-demo.sh
```

#### Option 2: Web-Based Command Helper
```bash
# Open the web helper in your browser
open command-helper.html
# or
firefox command-helper.html
```

#### Option 3: VS Code Snippets
If you're using VS Code, we've included custom snippets for DevPod commands:

1. Open VS Code in this project directory
2. Type `devpod-` and press `Ctrl+Space` to see available snippets
3. Common snippets:
   - `devpod-up` → Create workspace
   - `devpod-list` → List workspaces  
   - `devpod-ssh` → SSH into workspace
   - `devpod-ide` → Open in IDE (VS Code desktop)
   - `devpod-browser` → Open in VS Code browser
   - `devpod-openvscode` → Open in OpenVSCode browser

**Features Available in Both Helpers:**
- 📋 **Copy to Clipboard**: Automatically copy commands to your clipboard
- 🖥️ **Execute Commands**: Run commands directly with confirmation (terminal script)
- 📚 **Categorized Commands**: Organized by installation, configuration, troubleshooting, etc.
- 💡 **Command Descriptions**: Detailed explanations for each command
- 🔍 **System Status Check**: Comprehensive DevPod and Docker status verification
- 🎯 **Language Examples**: Pre-configured commands for different programming languages

#### Quick Commands for Copy-Paste

<details>
<summary>📋 <strong>Essential DevPod Commands (Click to Expand)</strong></summary>

**Installation & Verification:**
```bash
# Download and install DevPod (Linux)
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
sudo install -c -m 0755 devpod /usr/local/bin && rm devpod

# Verify installation
devpod version
```

**Basic Workspace Operations:**
```bash
# Create workspace from current directory
devpod up --id my-workspace .

# Create workspace from Git repository
devpod up --id my-workspace https://github.com/user/repo

# List all workspaces
devpod list

# Check workspace status
devpod status my-workspace

# Open in VS Code
devpod ide vscode my-workspace

# Open in VS Code browser (no desktop app needed)
devpod ide openvscode my-workspace

# SSH into workspace
devpod ssh my-workspace

# Stop workspace
devpod stop my-workspace

# Delete workspace
devpod delete my-workspace
```

**Configuration & Troubleshooting:**
```bash
# Check providers
devpod provider list

# Check contexts
devpod context list

# View workspace logs
devpod logs my-workspace

# View daemon logs
devpod logs-daemon

# Check Docker status
docker version && docker ps
```

**Language-Specific Quick Starts:**
```bash
# Node.js project
devpod up --id nodejs-project . && devpod ssh nodejs-project -- "npm install && npm start"

# Python project  
devpod up --id python-project . && devpod ssh python-project -- "pip install -r requirements.txt && python main.py"

# Java Spring Boot project
devpod up --id java-project . && devpod ssh java-project -- "./mvnw spring-boot:run"

# Go project
devpod up --id go-project . && devpod ssh go-project -- "go run main.go"
```

</details>

<details>
<summary>🎬 <strong>Preview of Interactive Helper</strong></summary>

```
🚀 DevPod Interactive Command Helper
==================================

Choose a category:
1) 🛠️  DevPod Installation Commands
2) 🚀 Quick Start Commands  
3) 📋 Basic DevPod Commands
4) 🔧 Configuration Commands
5) 🐛 Troubleshooting Commands
6) 💻 Language-Specific Examples
7) 🏗️  Custom Commands (Interactive Input)
8) 📊 System Status Check
0) Exit

Enter your choice (0-8): _
```

</details>

### 1. Initialize Your First Workspace

#### Method 1: From Local Directory
```bash
# Navigate to your project directory
cd /path/to/your/project

# Create and start workspace
devpod up --id my-first-workspace .

# Open in VS Code
devpod ide vscode my-first-workspace
```

#### Method 2: From Git Repository
```bash
#### Method 2: From Git Repository
```bash
# Create workspace from GitHub repository
devpod up --id my-git-workspace https://github.com/username/repository

# Open in browser-based IDE
devpod ide openvscode my-git-workspace
```

#### 🌐 VS Code Browser Access Options

DevPod supports multiple ways to access your workspace:

**Option 1: VS Code Desktop Application**
```bash
# Requires VS Code installed locally
devpod ide vscode my-workspace
```

**Option 2: VS Code in Browser (Recommended for Remote Access)**
```bash
# No local VS Code installation needed
# Runs entirely in your web browser
devpod ide openvscode my-workspace

# The browser will automatically open with your workspace
# URL typically: http://localhost:8080 or similar
```

**Benefits of Browser VS Code:**
- 🌐 **No Installation Required**: Works on any device with a web browser
- 🔒 **Secure Remote Access**: Access your development environment from anywhere
- 💻 **Cross-Platform**: Works on tablets, Chromebooks, and any OS
- 🚀 **Fast Startup**: No need to sync extensions or settings locally
- 🔄 **Consistent Environment**: Same experience across all devices

**When to Use Each:**
- **Desktop VS Code**: Best for local development with full extension ecosystem
- **Browser VS Code**: Perfect for remote work, temporary access, or devices without VS Code

**🔧 Complete VS Code Browser Workflow:**

```bash
# 1. Create a workspace from your project
devpod up --id my-project .

# 2. Open in browser VS Code (automatically opens browser)
devpod ide openvscode my-project

# 3. Alternative: Get the browser URL manually
devpod status my-project
# Look for the IDE URL in the output

# 4. Access from any device using the URL
# Example: http://localhost:8080 or similar
```

**🌐 Browser VS Code Features:**
- ✅ **Full VS Code Experience**: Same interface as desktop version
- ✅ **Extension Support**: Install and use most VS Code extensions
- ✅ **Terminal Access**: Built-in terminal for command execution
- ✅ **File Explorer**: Complete file system navigation
- ✅ **Git Integration**: Full version control support
- ✅ **Debugging**: Debug your applications in the browser
- ✅ **Split Panes**: Multiple editors and terminals
- ✅ **Theme Support**: Use your favorite VS Code themes
```

#### Method 3: Using This Project
```bash
# Clone this project
git clone https://github.com/cloudshare360/devpod-multi-stack-environments.git
cd devpod-multi-stack-environments/projects/dev-pod-cli-project

# Create workspace with standardized naming
devpod up --id dev-pod-cli-project-workspace .

# Open in your preferred IDE
devpod ide vscode dev-pod-cli-project-workspace
```

### 2. Basic DevPod Commands

```bash
# List all workspaces
devpod list

# Check workspace status
devpod status my-workspace

# Stop workspace
devpod stop my-workspace

# Delete workspace
devpod delete my-workspace

# SSH into workspace
devpod ssh my-workspace

# Execute command in workspace
devpod ssh my-workspace -- "npm install"
```

<details>
<summary>📋 <strong>Individual Commands - Copy & Execute</strong></summary>

**Workspace Management:**
```bash
devpod list
```
> Lists all existing workspaces with their status

```bash
devpod status my-workspace
```
> Shows detailed status of a specific workspace

```bash
devpod stop my-workspace
```
> Stops a running workspace

```bash
devpod delete my-workspace
```
> Permanently deletes a workspace

**Workspace Access:**
```bash
devpod ssh my-workspace
```
> Opens SSH connection to workspace

```bash
devpod ssh my-workspace -- "npm install"
```
> Executes a command inside the workspace

**Quick Start Templates:**
```bash
devpod up --id nodejs-project .
```
> Creates a Node.js workspace from current directory

```bash
devpod up --id python-project https://github.com/user/repo
```
> Creates a Python workspace from GitHub repository

</details>

## 📚 Documentation

### Core Concepts

#### 1. **Workspace**
A workspace is an isolated development environment that contains:
- Your source code
- Development tools and runtime
- IDE and extensions
- Configuration and settings

#### 2. **Provider**
Providers define where your workspace runs:
- **Docker** (default) - Local containers
- **Kubernetes** - Cluster-based development
- **AWS** - Cloud-based workspaces
- **SSH** - Remote server development

#### 3. **DevContainer**
Configuration file (`.devcontainer/devcontainer.json`) that defines:
- Base image or Dockerfile
- VS Code extensions
- Port forwarding
- Environment variables
- Post-creation commands

### DevContainer Configuration

#### Basic Structure
```json
{
    "name": "My Development Environment",
    "image": "mcr.microsoft.com/devcontainers/universal:2-linux",
    "workspaceFolder": "/workspaces/my-project",
    "features": {
        "ghcr.io/devcontainers/features/node:1": {
            "version": "20"
        }
    },
    "customizations": {
        "vscode": {
            "extensions": ["ms-python.python"],
            "settings": {
                "terminal.integrated.shell.linux": "/bin/bash"
            }
        }
    },
    "forwardPorts": [3000, 8080],
    "postCreateCommand": "npm install"
}
```

#### Key Properties Explained

| Property | Description | Example |
|----------|-------------|---------|
| `name` | Display name for the container | `"My Dev Environment"` |
| `image` | Base Docker image | `"node:18"` |
| `dockerfile` | Path to custom Dockerfile | `"Dockerfile"` |
| `workspaceFolder` | Container workspace path | `"/workspaces/myapp"` |
| `features` | Pre-built development features | `{"node": {"version": "18"}}` |
| `customizations.vscode.extensions` | VS Code extensions to install | `["ms-python.python"]` |
| `forwardPorts` | Ports to forward to host | `[3000, 8080]` |
| `postCreateCommand` | Command to run after creation | `"npm install"` |

## 💻 Programming Languages & Examples

This workspace comes pre-configured with support for 10+ programming languages and includes practical examples for each:

### 🚀 Available Examples

| Language | Framework | Port | Features |
|----------|-----------|------|----------|
| **JavaScript** | Express.js | 3000 | REST API, JSON validation, error handling |
| **Python** | FastAPI | 8000 | Async API, Pydantic models, automatic docs |
| **Java** | Spring Boot | 8080 | JPA/Hibernate, H2 database, Spring Data |
| **Go** | Gin | 8080 | GORM, SQLite, JSON binding, CORS |
| **Rust** | Warp | 3030 | SQLx, async/await, memory safety, UUID |

Each example includes:
- ✅ Complete REST API with CRUD operations
- ✅ Database integration and sample data
- ✅ Comprehensive test suite
- ✅ Development and production setup guides
- ✅ Docker-ready configuration

### 1. **JavaScript/Node.js Example**
```bash
cd examples/javascript
npm install
npm start
# API: http://localhost:3000/api
# Features: Express.js, MongoDB simulation, REST endpoints
```

### 2. **Python FastAPI Example**  
```bash
cd examples/python
pip install -r requirements.txt
python main.py
# API: http://localhost:8000/api
# Interactive docs: http://localhost:8000/docs
# Features: FastAPI, Pydantic models, async operations
```

### 3. **Java Spring Boot Example**
```bash
cd examples/java
./mvnw spring-boot:run
# API: http://localhost:8080/api
# H2 Console: http://localhost:8080/h2-console
# Features: Spring Boot 3.2, JPA/Hibernate, H2 database
```

### 4. **Go Gin Example**
```bash
cd examples/go
go run main.go
# API: http://localhost:8080/api
# Features: Gin framework, GORM, SQLite, JSON validation
```

### 5. **Rust Warp Example**
```bash
cd examples/rust
cargo run
# API: http://localhost:3030/api
# Features: Warp framework, SQLx, async/await, memory safety
```

### Available Language Tools

#### JavaScript/Node.js
```bash
node --version    # v20.x
npm --version     # Latest
yarn --version    # Latest
# Create new project: npx create-react-app my-app
```

#### Python
```bash
python3 --version  # 3.12.x
pip3 --version     # Latest
# Create virtual environment: python3 -m venv myenv

### 3. **Java**
```bash
# Available tools: java, javac, maven, gradle
java --version     # 21.x
mvn --version      # Latest

# Create new Spring Boot project
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app
```

### 4. **Go**
```bash
# Available tools: go
go version         # Latest

# Create new module
go mod init myapp
echo 'package main\nimport "fmt"\nfunc main() { fmt.Println("Hello, DevPod!") }' > main.go
go run main.go
```

### 5. **Rust**
```bash
# Available tools: rustc, cargo
rustc --version    # Latest
cargo --version    # Latest

# Create new project
cargo new myapp
cd myapp && cargo run
```

### 6. **C#/.NET**
```bash
# Available tools: dotnet
dotnet --version   # 8.0.x

# Create new console app
dotnet new console -n MyApp
cd MyApp && dotnet run
```

### 7. **PHP**
```bash
# Available tools: php, composer
php --version      # 8.3.x
composer --version # Latest

# Create new project
composer create-project laravel/laravel my-app
```

### 8. **C/C++**
```bash
# Available tools: gcc, g++, cmake
gcc --version      # Latest
g++ --version      # Latest

# Compile and run
echo '#include <stdio.h>\nint main() { printf("Hello, DevPod!\\n"); return 0; }' > hello.c
gcc hello.c -o hello && ./hello
```

## 🔧 Configuration

### Provider Configuration

#### Set up Docker Provider (Default)
```bash
# Configure Docker provider
devpod provider add docker
devpod provider use docker

# Configure provider options
devpod provider set-options docker \
  --option DOCKER_SOCK=/var/run/docker.sock
```

#### Set up Kubernetes Provider
```bash
# Add Kubernetes provider
devpod provider add kubernetes
devpod provider use kubernetes

# Configure kubeconfig
devpod provider set-options kubernetes \
  --option KUBE_CONFIG=/path/to/kubeconfig
```

### Global Settings
```bash
# Set default IDE
devpod context set-options --option IDE=vscode

# Set default provider
devpod context set-options --option PROVIDER=docker

# Configure proxy settings
devpod context set-options --option HTTP_PROXY=http://proxy:8080
```

### Workspace-Specific Settings
```bash
# Set workspace options
devpod set-options my-workspace \
  --option CPU=4 \
  --option MEMORY=8Gi \
  --option DISK=50Gi

# Override provider for specific workspace
devpod set-options my-workspace --option PROVIDER=kubernetes
```

## 📝 Tutorials

### Tutorial 1: Creating Your First DevContainer

1. **Create Project Structure**
```bash
mkdir my-first-devpod-project
cd my-first-devpod-project
mkdir .devcontainer
```

2. **Create DevContainer Configuration**
```bash
cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "My First DevPod Project",
    "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
    "workspaceFolder": "/workspaces/my-first-devpod-project",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-json",
                "esbenp.prettier-vscode"
            ]
        }
    },
    "forwardPorts": [3000],
    "postCreateCommand": "npm install"
}
EOF
```

3. **Add Package.json**
```bash
cat > package.json << 'EOF'
{
    "name": "my-first-devpod-project",
    "version": "1.0.0",
    "scripts": {
        "start": "node server.js",
        "dev": "node server.js"
    },
    "dependencies": {
        "express": "^4.18.0"
    }
}
EOF
```

4. **Create Simple Server**
```bash
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('<h1>Hello from DevPod! 🚀</h1>');
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
EOF
```

5. **Create and Start Workspace**
```bash
devpod up --id my-first-workspace .
devpod ide vscode my-first-workspace
```

### Tutorial 2: Multi-Language Project

1. **Project Structure**
```bash
mkdir fullstack-devpod-project
cd fullstack-devpod-project
mkdir -p {frontend,backend,database} .devcontainer
```

2. **DevContainer Configuration**
```bash
cat > .devcontainer/devcontainer.json << 'EOF'
{
    "name": "Fullstack Development Environment",
    "dockerComposeFile": "docker-compose.yml",
    "service": "devcontainer",
    "workspaceFolder": "/workspaces/fullstack-project",
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-vscode.vscode-typescript-next",
                "ms-ossdata.vscode-postgresql"
            ]
        }
    },
    "forwardPorts": [3000, 5000, 5432],
    "postCreateCommand": "cd frontend && npm install && cd ../backend && pip install -r requirements.txt"
}
EOF
```

3. **Docker Compose Configuration**
```bash
cat > .devcontainer/docker-compose.yml << 'EOF'
version: '3.8'
services:
  devcontainer:
    image: mcr.microsoft.com/devcontainers/universal:2-linux
    volumes:
      - ..:/workspaces/fullstack-project:cached
    command: sleep infinity
    
  database:
    image: postgres:15
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF
```

### Tutorial 3: Custom Provider Setup

1. **Create SSH Provider**
```bash
# Add custom SSH provider
devpod provider add ssh --url https://github.com/loft-sh/devpod-provider-ssh

# Configure SSH connection
devpod provider set-options ssh \
  --option SSH_HOST=my-server.com \
  --option SSH_USER=developer \
  --option SSH_KEY_PATH=/path/to/private/key
```

2. **Create Workspace on Remote Server**
```bash
devpod up --id remote-workspace --provider ssh /path/to/project
```

## 🎪 Examples

### Example Projects

#### 1. React Frontend
```bash
# Location: examples/javascript/react-app
cd examples/javascript/react-app

# DevContainer features:
# - Node.js 20
# - React dev tools
# - ESLint & Prettier
# - Hot reload support

devpod up --id react-example .
```

#### 2. Python FastAPI Backend
```bash
# Location: examples/python/fastapi-app
cd examples/python/fastapi-app

# DevContainer features:
# - Python 3.12
# - FastAPI & Uvicorn
# - PostgreSQL client
# - Testing tools (pytest)

devpod up --id python-api-example .
```

#### 3. Java Spring Boot
```bash
# Location: examples/java/spring-boot-app
cd examples/java/spring-boot-app

# DevContainer features:
# - Java 21
# - Maven & Gradle
# - Spring Boot tools
# - Database connectivity

devpod up --id java-spring-example .
```

#### 4. Go Microservice
```bash
# Location: examples/go/microservice
cd examples/go/microservice

# DevContainer features:
# - Go latest
# - Go modules support
# - Air for hot reload
# - Docker-in-Docker

devpod up --id go-microservice-example .
```

## 🔍 Troubleshooting

### Common Issues

#### Issue 1: DevPod Command Not Found
```bash
# Problem: devpod: command not found
# Solution: Add to PATH or reinstall
export PATH="/usr/local/bin:$PATH"
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Issue 2: Docker Permission Denied
```bash
# Problem: permission denied while trying to connect to Docker
# Solution: Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
# Or restart your session
```

#### Issue 3: Workspace Creation Fails
```bash
# Problem: Failed to create workspace
# Solution: Check Docker and clean up
docker system info
docker system prune -f

# Check DevPod status
devpod list
devpod provider list
```

#### Issue 4: Port Already in Use
```bash
# Problem: Port 3000 already in use
# Solution: Use different ports in devcontainer.json
"forwardPorts": [3001, 3002, 3003]

# Or kill process using the port
sudo lsof -ti:3000 | xargs kill -9
```

#### Issue 5: IDE Won't Open
```bash
# Problem: IDE fails to open
# Solution: Check IDE installation and configuration
devpod ide list
devpod ide install vscode

# Set default IDE
devpod context set-options --option IDE=vscode
```

### Debug Commands

```bash
# Enable debug logging
export DEVPOD_DEBUG=true
devpod up --debug my-workspace

# Check system status
devpod list
devpod provider list
devpod version

# Inspect workspace
devpod describe my-workspace

# View workspace logs
devpod logs my-workspace

# Connect to workspace shell
devpod ssh my-workspace

# Reset workspace
devpod reset my-workspace
```

### Performance Optimization

#### Speed up Container Builds
```bash
# Use multi-stage Dockerfile
# Cache dependencies in separate layers
# Use .dockerignore file

# Example .dockerignore
cat > .dockerignore << 'EOF'
node_modules
.git
.devcontainer
*.log
.env
EOF
```

#### Optimize DevContainer Configuration
```json
{
    "build": {
        "dockerfile": "Dockerfile",
        "options": ["--platform=linux/amd64"]
    },
    "mounts": [
        "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
    ],
    "runArgs": ["--memory=4g", "--cpus=2"]
}
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 1. Report Issues
- Use the GitHub issue tracker
- Provide detailed reproduction steps
- Include system information and logs

### 2. Submit Examples
- Add new language examples
- Improve existing examples
- Update documentation

### 3. Improve Documentation
- Fix typos and errors
- Add missing information
- Translate to other languages

### 4. Development Setup
```bash
# Fork and clone the repository
git clone https://github.com/your-username/devpod-multi-stack-environments.git
cd devpod-multi-stack-environments/projects/dev-pod-cli-project

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and test
devpod up --id dev-workspace .

# Commit and push
git add .
git commit -m "Add: your feature description"
git push origin feature/your-feature-name

# Create pull request
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

- 📖 **Documentation**: Check this README and the `docs/` directory
- 🐛 **Issues**: Report bugs on GitHub Issues
- 💬 **Discussions**: Join GitHub Discussions for questions
- 📧 **Contact**: [your-email@example.com](mailto:your-email@example.com)

---

**Happy DevPodding! 🚀**

Made with ❤️ by the DevPod Community