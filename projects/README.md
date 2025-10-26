# DevPod Projects Collection

A comprehensive collection of development environments configured for DevPod, covering multiple programming languages, frameworks, and full-stack architectures.

## 📁 Project Structure

```
projects/
├── nodejs-project/           # Node.js + Express API
├── java17-project/          # Java 17 + Spring Boot API
├── python3-project/         # Python 3.11 + FastAPI
├── react-project/           # React 18 + TypeScript
├── angular-project/         # Angular 17 + TypeScript
├── mern-fullstack/          # MongoDB + Express + React + Node
├── angular-java-fullstack/  # Angular + Java + PostgreSQL
└── launch-project.sh        # Universal project launcher
```

## 🚀 Quick Start

### Universal Launcher
```bash
# Launch the interactive project menu
./launch-project.sh
```

### Individual Project Launch
```bash
# Navigate to any project and run
cd <project-name>
./manage-devpod.sh start
```

## 📋 Available Projects

### Backend/API Projects

#### 1. 🟢 Node.js Project
- **Framework**: Express.js
- **Port**: 3000
- **Features**: REST API, CORS, Helmet security, Morgan logging
- **Database**: In-memory (development)
- **Testing**: Jest + Supertest

**Quick Start:**
```bash
cd nodejs-project
./manage-devpod.sh start
# Access: http://localhost:3000
```

#### 2. ☕ Java 17 Project
- **Framework**: Spring Boot 3.1.5
- **Port**: 8080
- **Features**: REST API, JPA, H2 Database, Actuator, Lombok
- **Database**: H2 (development)
- **Testing**: JUnit 5 + TestContainers

**Quick Start:**
```bash
cd java17-project
./manage-devpod.sh start
# Access: http://localhost:8080
# H2 Console: http://localhost:8080/h2-console
```

#### 3. 🐍 Python 3 Project
- **Framework**: FastAPI
- **Port**: 8000
- **Features**: Async API, Pydantic validation, SQLAlchemy ORM
- **Database**: SQLite (development)
- **Testing**: pytest + httpx

**Quick Start:**
```bash
cd python3-project
./manage-devpod.sh start
# Access: http://localhost:8000
# Docs: http://localhost:8000/docs
```

### Frontend Projects

#### 4. ⚛️ React Project
- **Framework**: React 18 + TypeScript
- **Port**: 3000
- **Features**: Modern React with hooks, React Router
- **Styling**: CSS Modules, Tailwind CSS ready
- **Testing**: React Testing Library

**Quick Start:**
```bash
cd react-project
./manage-devpod.sh start
# Access: http://localhost:3000
```

#### 5. 🅰️ Angular Project
- **Framework**: Angular 17 + TypeScript
- **Port**: 4200
- **Features**: Latest Angular features, Angular CLI
- **Styling**: Angular Material ready
- **Testing**: Jasmine + Karma

**Quick Start:**
```bash
cd angular-project
./manage-devpod.sh start
# Access: http://localhost:4200
```

### Full-Stack Projects

#### 6. 🌐 MERN Stack
- **Frontend**: React 18 + TypeScript
- **Backend**: Node.js + Express
- **Database**: MongoDB
- **Ports**: 3000 (frontend), 5000 (backend), 27017 (database)

**Services:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- MongoDB: localhost:27017

**Quick Start:**
```bash
cd mern-fullstack
./manage-devpod.sh start
```

#### 7. 🏗️ Angular-Java-PostgreSQL Stack
- **Frontend**: Angular 17 + TypeScript
- **Backend**: Java 17 + Spring Boot
- **Database**: PostgreSQL 15
- **Admin**: Adminer
- **Ports**: 4200 (frontend), 8080 (backend), 5432 (database), 8081 (admin)

**Services:**
- Frontend: http://localhost:4200
- Backend API: http://localhost:8080
- PostgreSQL: localhost:5432
- Adminer: http://localhost:8081

**Quick Start:**
```bash
cd angular-java-fullstack
./manage-devpod.sh start
```

## 🛠️ Management Commands

Each project includes a `manage-devpod.sh` script with the following commands:

```bash
./manage-devpod.sh start     # Start the DevPod workspace
./manage-devpod.sh stop      # Stop the DevPod workspace
./manage-devpod.sh restart   # Restart the DevPod workspace
./manage-devpod.sh status    # Show workspace status
./manage-devpod.sh logs      # View workspace logs
./manage-devpod.sh ssh       # SSH into the workspace
```

Additional commands for specific projects:
```bash
# Python project
./manage-devpod.sh test      # Run tests
./manage-devpod.sh format    # Format and lint code
```

## 🔧 DevContainer Features

All projects include optimized DevContainer configurations with:

### Common Features
- **Git** - Version control
- **GitHub CLI** - GitHub integration
- **VS Code Extensions** - Language-specific extensions
- **Port Forwarding** - Automatic port mapping
- **Hot Reloading** - Development server auto-restart

### Language-Specific Extensions

**Node.js/React/Angular:**
- TypeScript support
- ESLint integration
- Prettier formatting
- Tailwind CSS support

**Java:**
- Java Extension Pack
- Spring Boot support
- Maven integration
- Lombok support

**Python:**
- Python language server
- Black formatting
- Flake8 linting
- pytest integration

## 📊 Port Reference

| Project | Primary Port | Additional Ports | Access URL |
|---------|-------------|------------------|------------|
| Node.js | 3000 | 3001, 8000 | http://localhost:3000 |
| Java 17 | 8080 | 8081, 8443 | http://localhost:8080 |
| Python 3 | 8000 | 8001, 5000 | http://localhost:8000 |
| React | 3000 | 3001 | http://localhost:3000 |
| Angular | 4200 | 4201 | http://localhost:4200 |
| MERN | 3000, 5000 | 27017 | Multiple endpoints |
| Angular-Java | 4200, 8080 | 5432, 8081 | Multiple endpoints |

## 🧪 Testing

Each project includes comprehensive testing setups:

**Node.js:** Jest + Supertest for API testing
**Java:** JUnit 5 + TestContainers for integration testing
**Python:** pytest + httpx for async API testing
**React:** React Testing Library + Jest
**Angular:** Jasmine + Karma

Run tests for any project:
```bash
cd <project-name>
./manage-devpod.sh test  # If available
# Or use project-specific commands
```

## 🗄️ Database Configurations

### Development Databases
- **Node.js**: In-memory storage
- **Java**: H2 in-memory database
- **Python**: SQLite file database
- **MERN**: MongoDB container
- **Angular-Java**: PostgreSQL container

### Database Access
- **H2 Console**: http://localhost:8080/h2-console
- **Adminer**: http://localhost:8081 (full-stack projects)
- **MongoDB**: Direct connection on port 27017

## 🔄 DevPod Workspace Management

### Global Commands
```bash
# List all workspaces
devpod workspace list

# Stop all workspaces
./launch-project.sh  # Choose option 9

# Clean up resources
./launch-project.sh  # Choose option 10
```

### Individual Workspace Commands
```bash
# Start specific workspace
devpod up ./project-name --id project-workspace

# Stop specific workspace
devpod stop project-workspace

# SSH into workspace
devpod ssh project-workspace

# View logs
devpod logs project-workspace

# Delete workspace
devpod delete project-workspace
```

## 📚 Documentation

Each project includes comprehensive documentation:
- **README.md** - Project-specific setup and usage
- **API Documentation** - Available endpoints and examples
- **Architecture Overview** - Technology stack and structure
- **Troubleshooting Guide** - Common issues and solutions

## 🚀 Getting Started Workflow

1. **Install DevPod CLI** (if not already installed):
   ```bash
   ../install-devpod.sh
   ```

2. **Launch the project menu**:
   ```bash
   ./launch-project.sh
   ```

3. **Choose your project** from the interactive menu

4. **Start developing** - VS Code will open with the configured environment

## 🆘 Troubleshooting

### Common Issues

1. **DevPod not found**:
   ```bash
   # Install DevPod CLI
   ../install-devpod.sh
   ```

2. **Docker not running**:
   ```bash
   # Start Docker service
   sudo systemctl start docker
   ```

3. **Port conflicts**:
   ```bash
   # Check which ports are in use
   netstat -tulpn | grep :PORT_NUMBER
   
   # Stop conflicting services or use different ports
   ```

4. **Workspace won't start**:
   ```bash
   # Check logs
   devpod logs workspace-name
   
   # Clean up and restart
   devpod delete workspace-name
   devpod up ./project-dir --id new-workspace-name
   ```

### Resource Cleanup
```bash
# Stop all workspaces
./launch-project.sh  # Option 9

# Clean Docker resources
./launch-project.sh  # Option 10

# Or manually
docker system prune -f
docker volume prune -f
```

## 🔧 Customization

### Adding New Projects
1. Create project directory in `/projects/`
2. Add `.devcontainer/devcontainer.json`
3. Create `manage-devpod.sh` script
4. Add documentation (`README.md`)
5. Update `launch-project.sh` menu

### Modifying Existing Projects
- Edit `.devcontainer/devcontainer.json` for container configuration
- Modify `manage-devpod.sh` for custom commands
- Update documentation as needed

## 📈 Next Steps

- **Explore the projects** using the launcher
- **Customize configurations** for your specific needs
- **Add new project types** following the established patterns
- **Integrate with CI/CD** for automated deployments
- **Scale to production** using the provided configurations

## 🤝 Contributing

To add new project types or improve existing ones:
1. Follow the established directory structure
2. Include comprehensive documentation
3. Add management scripts for common operations
4. Test the DevContainer configuration
5. Update this overview documentation

---

**Happy coding with DevPod! 🚀**