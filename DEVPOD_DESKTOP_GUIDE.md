# DevPod Desktop Application Guide

This guide explains how to use the DevPod Desktop application to browse your multi-stack development projects and start applications with ease.

## 📋 Table of Contents

1. [DevPod Desktop Overview](#devpod-desktop-overview)
2. [Installation & Setup](#installation--setup)
3. [Opening Projects](#opening-projects)
4. [Project Structure Navigation](#project-structure-navigation)
5. [Starting Applications](#starting-applications)
6. [Database Management](#database-management)
7. [Development Workflows](#development-workflows)
8. [Troubleshooting](#troubleshooting)

## 🖥️ DevPod Desktop Overview

DevPod Desktop is a user-friendly GUI application that simplifies container-based development. It provides:

- **Visual Project Management**: Browse and manage multiple development environments
- **One-Click Startup**: Start development containers with a single click
- **Integrated Terminal**: Access containerized environments directly
- **Port Management**: Automatic port forwarding and conflict resolution
- **VS Code Integration**: Seamless integration with Visual Studio Code

## 🚀 Installation & Setup

### 1. Install DevPod Desktop

**Download from Official Website:**
```bash
# Visit https://devpod.sh/
# Download the appropriate version for your OS:
# - Windows: DevPod-Setup.exe
# - macOS: DevPod.dmg
# - Linux: DevPod.AppImage or .deb/.rpm packages
```

**Linux Installation:**
```bash
# For Ubuntu/Debian:
sudo dpkg -i devpod_*.deb

# For AppImage:
chmod +x DevPod.AppImage
./DevPod.AppImage
```

**macOS Installation:**
```bash
# Open the downloaded .dmg file
# Drag DevPod to Applications folder
```

**Windows Installation:**
```bash
# Run the DevPod-Setup.exe installer
# Follow the installation wizard
```

### 2. Initial Configuration

1. **Launch DevPod Desktop**
2. **Configure Provider** (if not already done):
   - Select "Docker" as your provider
   - Ensure Docker is running on your system
3. **Set Workspace Directory**:
   - Point to your `/dev-pod-cli-ws` directory
   - This allows DevPod to discover your projects

## 📁 Opening Projects

### Method 1: Using DevPod Desktop Interface

1. **Launch DevPod Desktop**
2. **Click "Add Workspace"** or the **"+"** button
3. **Choose Source:**
   - **Local Folder**: Browse to your project directory
   - **Git Repository**: Use `https://github.com/cloudshare360/devpod-multi-stack-environments.git`
4. **Select Project:**
   - Navigate to `/dev-pod-cli-ws/projects/`
   - Choose your desired project (e.g., `java17-project`, `nodejs-project`, etc.)

### Method 2: Direct Project Import

1. **File Menu** → **Import Workspace**
2. **Browse to Project:**
   ```
   /your-path/dev-pod-cli-ws/projects/java17-project
   /your-path/dev-pod-cli-ws/projects/nodejs-project
   /your-path/dev-pod-cli-ws/projects/python3-project
   etc.
   ```
3. **Click "Import"**

### Method 3: Command Line Integration

```bash
# From your project directory
cd /path/to/dev-pod-cli-ws/projects/java17-project
devpod up .

# Or specify the workspace name
devpod up java17-workspace
```

## 🗂️ Project Structure Navigation

### Understanding the Project Layout

Each project has a consistent structure:

```
project-name/
├── .devcontainer/          # DevPod configuration
│   ├── devcontainer.json   # Container settings, ports, extensions
│   └── setup.sh           # Post-creation setup script
├── database/               # Database environment
│   ├── docker-compose.yml  # PostgreSQL + pgAdmin
│   ├── start-db.sh         # Database startup script
│   ├── schema/             # Database schema files
│   └── seed-data/          # Sample data
├── src/                    # Application source code
├── README.md               # Project-specific documentation
└── package.json           # Dependencies (Node.js/Python projects)
```

### Browsing in DevPod Desktop

1. **Workspace Panel**: Shows all available workspaces/projects
2. **File Explorer**: Browse project files within the container
3. **Terminal Panel**: Access containerized shell
4. **Port Panel**: View and manage forwarded ports
5. **Extensions Panel**: Manage VS Code extensions

## 🎯 Starting Applications

### 1. Starting a Complete Project

**Via DevPod Desktop:**

1. **Select Project** from workspace list
2. **Click "Start"** or **▶️ Play button**
3. **Wait for Container Build** (first time only)
4. **Access VS Code** when ready

**What Happens:**
- Container is built and started
- Dependencies are installed
- Ports are forwarded
- VS Code opens in container context
- Database can be started separately

### 2. Database Startup

**Method A: Using VS Code Terminal**
```bash
# Open VS Code terminal (Ctrl+`)
cd database
./start-db.sh
```

**Method B: Using DevPod Terminal**
```bash
# In DevPod Desktop terminal
cd /workspaces/project-name/database
./start-db.sh
```

**Method C: Direct Docker Commands**
```bash
# From database directory
docker-compose up -d
```

### 3. Application-Specific Startup

#### Java Spring Boot Projects
```bash
# In VS Code terminal or DevPod terminal
cd /workspaces/java17-project

# Start database first
cd database && ./start-db.sh && cd ..

# Run Spring Boot application
mvn spring-boot:run
# OR
./mvnw spring-boot:run

# Access at: http://localhost:8090
```

#### Node.js Projects
```bash
# In VS Code terminal
cd /workspaces/nodejs-project

# Start database
cd database && ./start-db.sh && cd ..

# Install dependencies (if not done)
npm install

# Start application
npm run dev
# OR
npm start

# Access at: http://localhost:9000
```

#### Python Projects
```bash
# In VS Code terminal
cd /workspaces/python3-project

# Start database
cd database && ./start-db.sh && cd ..

# Activate virtual environment (if used)
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start FastAPI application
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# Access at: http://localhost:8000
```

#### React Projects
```bash
# In VS Code terminal
cd /workspaces/react-project

# Start database (for API integration)
cd database && ./start-db.sh && cd ..

# Install dependencies
npm install

# Start development server
npm start

# Access at: http://localhost:3010
```

#### Angular Projects
```bash
# In VS Code terminal
cd /workspaces/angular-project

# Start database
cd database && ./start-db.sh && cd ..

# Install dependencies
npm install

# Start development server
ng serve --host 0.0.0.0 --port 4200

# Access at: http://localhost:4200
```

## 🗄️ Database Management

### Quick Database Operations

**Start Database:**
```bash
cd database
./start-db.sh
```

**Check Database Status:**
```bash
./status-db.sh
```

**Stop Database:**
```bash
./stop-db.sh
```

**Reset Database (Delete All Data):**
```bash
./reset-db.sh
```

### Accessing Database Interfaces

#### pgAdmin Web Interface
- **URL**: Project-specific (see table below)
- **Email**: `admin@dev.local`
- **Password**: `admin123`

#### Direct PostgreSQL Connection
- **Host**: `localhost`
- **Port**: Project-specific (see table below)
- **Database**: `devdb`
- **Username**: `devuser`
- **Password**: `devpass123`

#### Database Access URLs by Project

| Project | PostgreSQL Port | pgAdmin URL |
|---------|----------------|-------------|
| postgresql-devpod-project | 5432 | http://localhost:8088 |
| java17-project | 5433 | http://localhost:8081 |
| nodejs-project | 5434 | http://localhost:8082 |
| python3-project | 5435 | http://localhost:8083 |
| react-project | 5436 | http://localhost:8084 |
| angular-project | 5437 | http://localhost:8085 |
| mern-fullstack | 5438 | http://localhost:8086 |
| angular-java-fullstack | 5439 | http://localhost:8087 |

## 💻 Development Workflows

### Typical Development Session

1. **Start DevPod Desktop**
2. **Select Project** from workspace list
3. **Click Start** to launch container
4. **Wait for VS Code** to open
5. **Open Terminal** in VS Code (Ctrl+`)
6. **Start Database**:
   ```bash
   cd database && ./start-db.sh
   ```
7. **Start Application** (see application-specific commands above)
8. **Open Browser** to access application
9. **Access pgAdmin** for database management
10. **Begin Development!**

### Multi-Project Development

**Running Multiple Projects Simultaneously:**

1. **Start First Project** (e.g., backend API)
   ```bash
   # Java17 project for API
   cd java17-project && devpod up .
   ```

2. **Start Second Project** (e.g., frontend)
   ```bash
   # React project for frontend
   cd react-project && devpod up .
   ```

3. **Configure Cross-Project Communication**:
   - Frontend connects to backend API
   - Use project-specific ports for APIs
   - Database can be shared or separate per project

### Port Management

**View Active Ports:**
- DevPod Desktop → Port Panel
- Shows all forwarded ports
- Click to open in browser

**Manual Port Forwarding:**
```bash
# If additional ports needed
devpod port-forward <workspace> <local-port>:<remote-port>
```

## 🔧 Troubleshooting

### Common Issues & Solutions

#### 1. Container Won't Start

**Symptoms**: Error during container build or startup

**Solutions**:
```bash
# Check Docker status
docker ps

# Rebuild container
devpod rebuild <workspace-name>

# Check logs
devpod logs <workspace-name>

# Reset workspace
devpod delete <workspace-name>
devpod up <project-directory>
```

#### 2. Port Conflicts

**Symptoms**: "Port already in use" errors

**Solutions**:
```bash
# Check what's using the port
lsof -i :PORT_NUMBER

# Stop conflicting service
sudo systemctl stop service-name

# Use alternative port in configuration
```

#### 3. Database Connection Issues

**Symptoms**: Application can't connect to database

**Solutions**:
```bash
# Verify database is running
cd database && ./status-db.sh

# Check database logs
docker-compose logs postgres

# Restart database
./stop-db.sh && ./start-db.sh

# Verify port forwarding
netstat -tulpn | grep PORT_NUMBER
```

#### 4. VS Code Extensions Not Loading

**Symptoms**: Missing language support or tools

**Solutions**:
1. **Check devcontainer.json** extensions list
2. **Rebuild container** to install extensions
3. **Manual installation** in VS Code
4. **Verify internet connection** for extension downloads

#### 5. Slow Performance

**Symptoms**: Container startup or operation is slow

**Solutions**:
```bash
# Increase Docker resources
# Docker Desktop → Settings → Resources
# Increase CPU, Memory allocation

# Clean up unused containers
docker system prune

# Use volume mounts instead of bind mounts
# (Already configured in projects)
```

### DevPod Desktop Specific Issues

#### Application Won't Launch

1. **Check DevPod Installation**:
   ```bash
   devpod version
   ```

2. **Verify Docker Provider**:
   - DevPod Desktop → Settings → Providers
   - Ensure Docker is selected and working

3. **Reset DevPod Configuration**:
   ```bash
   devpod reset
   ```

#### Workspace Not Detected

1. **Refresh Workspace List**: Click refresh button
2. **Check .devcontainer Directory**: Ensure devcontainer.json exists
3. **Re-import Workspace**: Delete and re-add workspace

## 🚀 Advanced Tips

### 1. Custom Workspace Names

```bash
# Create workspace with custom name
devpod up --id my-custom-name /path/to/project
```

### 2. Environment Variables

```bash
# Set environment variables for workspace
devpod up --env KEY=VALUE /path/to/project
```

### 3. Shared Volumes

```bash
# Mount additional volumes
devpod up --mount source=/host/path,target=/container/path,type=bind
```

### 4. SSH Access

```bash
# SSH into running workspace
devpod ssh <workspace-name>
```

### 5. Backup & Restore

```bash
# Export workspace configuration
devpod config export > workspace-config.yaml

# Import workspace configuration
devpod config import workspace-config.yaml
```

## 📞 Getting Help

### Documentation Resources

- **DevPod Official Docs**: https://devpod.sh/docs/
- **Project README Files**: Each project has specific documentation
- **PORT_ASSIGNMENTS.md**: Port allocation reference
- **DATABASE.md**: Database setup and usage guide

### Community Support

- **GitHub Issues**: https://github.com/loft-sh/devpod/issues
- **Discord**: DevPod Community Discord
- **Stack Overflow**: Tag questions with `devpod`

### Quick Reference Commands

```bash
# List all workspaces
devpod list

# Get workspace info
devpod describe <workspace-name>

# Start workspace
devpod up <workspace-name>

# Stop workspace
devpod stop <workspace-name>

# Delete workspace
devpod delete <workspace-name>

# View logs
devpod logs <workspace-name>

# SSH into workspace
devpod ssh <workspace-name>
```

---

*This guide covers the essential workflows for using DevPod Desktop with the multi-stack development environment. For project-specific details, refer to individual project README files and the comprehensive DATABASE.md guide.*

**Happy Coding! 🎉**