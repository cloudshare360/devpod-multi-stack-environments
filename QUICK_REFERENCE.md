# DevPod CLI Quick Reference Guide

## Installation

```bash
# Make scripts executable
chmod +x install-devpod.sh generate-devcontainer.sh complete-setup.sh

# Install DevPod CLI
./install-devpod.sh

# Complete interactive setup
./complete-setup.sh
```

## Essential Commands

### DevPod Management
```bash
# Check version
devpod version

# List workspaces
devpod workspace list

# Start workspace
devpod up <directory> --id <workspace-name>

# Stop workspace
devpod stop <workspace-name>

# Delete workspace
devpod delete <workspace-name>

# SSH into workspace
devpod ssh <workspace-name>
```

### Provider Management
```bash
# List providers
devpod provider list

# Add Docker provider
devpod provider add docker --use

# Add Kubernetes provider
devpod provider add kubernetes
```

## Quick Project Setup

### 1. Node.js Project
```bash
mkdir my-nodejs-app
cd my-nodejs-app
../generate-devcontainer.sh nodejs my-nodejs-app
devpod up . --id nodejs-workspace
```

### 2. Python Project
```bash
mkdir my-python-app
cd my-python-app
../generate-devcontainer.sh python my-python-app
devpod up . --id python-workspace
```

### 3. Java Project
```bash
mkdir my-java-app
cd my-java-app
../generate-devcontainer.sh java my-java-app
devpod up . --id java-workspace
```

### 4. React Project
```bash
mkdir my-react-app
cd my-react-app
../generate-devcontainer.sh react my-react-app
devpod up . --id react-workspace
```

### 5. Angular Project
```bash
mkdir my-angular-app
cd my-angular-app
../generate-devcontainer.sh angular my-angular-app
devpod up . --id angular-workspace
```

### 6. Full Stack (Angular + Java + PostgreSQL)
```bash
mkdir my-fullstack-app
cd my-fullstack-app
../generate-devcontainer.sh angular-java my-fullstack-app
devpod up . --id fullstack-workspace
```

## Working with Localhost & LAN

### Localhost Development
```bash
# Start with port forwarding
devpod up ./project --forward-ports 3000,8080

# Access via specific IDE
devpod up ./project --ide vscode
devpod up ./project --ide cursor
devpod up ./project --ide openvscode
```

### LAN Development
```bash
# Configure remote Docker provider
devpod provider add docker --option DOCKER_HOST=tcp://192.168.1.100:2376

# Create workspace with exposed ports
devpod up ./project --provider docker --option expose-ports=true

# SSH access over LAN
devpod ssh my-workspace --ssh-host 192.168.1.100
```

## Default Ports by Environment

| Environment | Default Ports | Access URL |
|-------------|---------------|------------|
| Node.js | 3000, 8000 | http://localhost:3000 |
| Python | 8000, 5000 | http://localhost:8000 |
| Java | 8080, 8443 | http://localhost:8080 |
| React | 3000, 3001 | http://localhost:3000 |
| Angular | 4200, 4201 | http://localhost:4200 |
| Full Stack | 4200, 8080, 5432, 8081 | Multiple endpoints |

## Full Stack Application URLs

When using the Angular + Java + PostgreSQL setup:

- **Frontend (Angular)**: http://localhost:4200
- **Backend (Java API)**: http://localhost:8080
- **Database Admin (Adminer)**: http://localhost:8081
- **PostgreSQL**: localhost:5432

### Database Connection Details:
- **Server**: postgres (from containers) or localhost (from host)
- **Username**: devuser
- **Password**: devpass
- **Database**: devdb

## Troubleshooting

### Common Issues

1. **DevPod not found**:
   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Docker permission denied**:
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

3. **Port already in use**:
   ```bash
   devpod up ./project --forward-ports 3001,8081
   ```

4. **Workspace won't start**:
   ```bash
   devpod logs <workspace-name>
   devpod stop <workspace-name>
   devpod delete <workspace-name>
   devpod up ./project --id new-workspace-name
   ```

### Useful Debugging Commands
```bash
# Check workspace status
devpod workspace list

# View workspace logs
devpod logs <workspace-name>

# Restart workspace
devpod stop <workspace-name>
devpod up ./project --id <workspace-name>

# Clean up unused resources
docker system prune -f
```

## File Structure

After running the setup, you'll have:

```
dev-pod-cli-ws/
├── requirements.md              # This documentation
├── install-devpod.sh           # DevPod installation script
├── generate-devcontainer.sh    # DevContainer generator
├── complete-setup.sh           # Interactive setup menu
├── QUICK_REFERENCE.md          # This file
└── <your-projects>/            # Generated project directories
    └── .devcontainer/
        └── devcontainer.json   # DevContainer configuration
```

## Next Steps

1. **Start with installation**: `./install-devpod.sh`
2. **Try the interactive setup**: `./complete-setup.sh`
3. **Create a simple project**: Choose option 1 (Node.js) from the menu
4. **Explore the workspace**: Once created, VS Code will open in the container
5. **Develop normally**: Edit files, run commands, debug as usual

## Resources

- **DevPod Documentation**: https://devpod.sh/docs
- **DevContainer Specification**: https://containers.dev/
- **VS Code DevContainers**: https://code.visualstudio.com/docs/devcontainers/containers