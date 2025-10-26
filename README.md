# 🚀 DevPod Multi-Stack Development Environment

A comprehensive collection of DevPod development environments for multiple technology stacks including Java, Node.js, Python, React, Angular, and full-stack applications.

## 🌟 Features

- **7 Complete Development Environments** - Ready-to-use DevPod configurations
- **Multiple Technology Stacks** - Java 17, Node.js 18, Python 3.11, React 18, Angular 17
- **Full-Stack Projects** - MERN and Angular-Java-PostgreSQL combinations
- **Production-Ready** - Complete with testing, linting, and deployment configurations
- **One-Click Setup** - Automated scripts for instant environment provisioning
- **VS Code Integration** - Pre-configured extensions and settings

## 📋 Available Projects

| Project | Technology Stack | Description |
|---------|------------------|-------------|
| **java17-project** | Java 17 + Spring Boot + Maven + H2 | REST API with JPA, validation, and actuator |
| **nodejs-project** | Node.js 18 + Express.js + Jest | REST API with testing and hot reload |
| **python3-project** | Python 3.11 + FastAPI + SQLAlchemy | Async REST API with automatic docs |
| **react-project** | React 18 + TypeScript + Vite | Modern frontend with hot reload |
| **angular-project** | Angular 17 + TypeScript + CLI | Full-featured SPA framework |
| **mern-fullstack** | MongoDB + Express + React + Node | Complete full-stack JavaScript |
| **angular-java-fullstack** | Angular + Spring Boot + PostgreSQL | Enterprise full-stack solution |

## 🚀 Quick Start

### Prerequisites
- [DevPod](https://devpod.sh/) installed
- Docker running
- VS Code (recommended)

### 1. Clone Repository
```bash
git clone <repository-url>
cd devpod-multi-stack-environments
```

### 2. Choose Your Stack
```bash
cd projects/<project-name>
```

### 3. Start Development Environment
```bash
# For most projects
./manage-devpod.sh start

# For Node.js project specifically
./start-devpod.sh
```

### 4. Universal Launcher (Alternative)
```bash
cd projects
./launch-project.sh
# Follow interactive prompts to select your project
```

## 📁 Project Structure

```
devpod-multi-stack-environments/
├── 📄 README.md                    # This file
├── 📄 requirements.md              # Original requirements document
├── 📄 QUICK_REFERENCE.md          # DevPod quick reference guide
├── 🛠️ install-devpod.sh           # DevPod installation script
├── 🛠️ complete-setup.sh           # Complete environment setup
├── 🛠️ create-all-projects.sh      # Batch project creation
├── 🛠️ generate-devcontainer.sh    # DevContainer generator
└── 📁 projects/                    # All development projects
    ├── 📄 README.md                # Projects overview
    ├── 📄 PROJECT_STATUS_REPORT.md # Current status and troubleshooting
    ├── 🛠️ launch-project.sh        # Universal project launcher
    ├── 📁 java17-project/          # Spring Boot REST API
    ├── 📁 nodejs-project/          # Express.js REST API
    ├── 📁 python3-project/         # FastAPI REST API
    ├── 📁 react-project/           # React 18 frontend
    ├── 📁 angular-project/         # Angular 17 frontend
    ├── 📁 mern-fullstack/          # Full-stack MERN
    └── 📁 angular-java-fullstack/  # Full-stack Angular + Java
```

## 🛠️ Available Scripts

### Global Scripts
- `install-devpod.sh` - Install DevPod CLI tool
- `complete-setup.sh` - Complete environment setup with all dependencies
- `create-all-projects.sh` - Create all project environments at once
- `generate-devcontainer.sh` - Generate custom DevContainer configurations

### Project-Specific Scripts
- `manage-devpod.sh` - Start, stop, restart, and manage DevPod workspaces
- `start-devpod.sh` - Start DevPod workspace (Node.js project)

## 🌐 Default Endpoints

### Java17 Project
- **API**: `http://localhost:8080`
- **Health**: `http://localhost:8080/api/health`
- **Users**: `http://localhost:8080/api/users`
- **H2 Console**: `http://localhost:8080/h2-console`
- **Actuator**: `http://localhost:8080/actuator`

### Node.js Project
- **API**: `http://localhost:3000`
- **Health**: `http://localhost:3000/health`
- **Users**: `http://localhost:3000/api/users`

### Python Project
- **API**: `http://localhost:8000`
- **Health**: `http://localhost:8000/health`
- **Users**: `http://localhost:8000/users`
- **Docs**: `http://localhost:8000/docs`

### React/Angular Projects
- **Frontend**: `http://localhost:3000` (React) / `http://localhost:4200` (Angular)

## 🔧 Troubleshooting

### Common Issues and Solutions

1. **Container Registry Access Denied**
   - All projects use custom Dockerfiles to avoid GitHub Container Registry issues
   - No manual intervention needed

2. **Maven Not Found (Java Projects)**
   - Fixed with custom Dockerfile that installs Maven via apt-get
   - No manual intervention needed

3. **DevPod Workspace Won't Start**
   ```bash
   devpod delete <workspace-name>
   ./manage-devpod.sh start
   ```

4. **Port Already in Use**
   - Check running containers: `docker ps`
   - Stop conflicting services or change ports in project configuration

### Getting Help
- Check `PROJECT_STATUS_REPORT.md` for detailed status information
- Review individual project README files for specific setup instructions
- Ensure Docker is running: `docker ps`

## 📚 Documentation

Each project includes comprehensive documentation:
- **README.md** - Project-specific setup and usage instructions
- **DevContainer Configuration** - Complete development environment setup
- **Sample Code** - Working REST APIs with CRUD operations
- **Testing Examples** - Unit tests and integration tests
- **Development Scripts** - Build, test, and deployment commands

## 🎯 Use Cases

### Learning and Development
- **Multi-Stack Learning**: Experience different technology stacks
- **Best Practices**: Production-ready configurations and code structure
- **DevOps Integration**: Container-based development workflows

### Professional Development
- **Rapid Prototyping**: Quick project bootstrapping
- **Team Standardization**: Consistent development environments
- **Technology Evaluation**: Compare frameworks side-by-side

### Enterprise Projects
- **Microservices Development**: Multiple service templates
- **Full-Stack Applications**: Complete frontend-backend solutions
- **Scalable Architecture**: Production-ready configurations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-stack`
3. Add your project in the `projects/` directory
4. Include DevContainer configuration and management scripts
5. Update documentation
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [DevPod](https://devpod.sh/) - For the amazing container development platform
- [Microsoft DevContainers](https://containers.dev/) - For the development container specifications
- [VS Code](https://code.visualstudio.com/) - For the excellent development experience

---

**🚀 Start building amazing applications with containerized development environments!**

Choose your preferred technology stack and launch into development with zero configuration time.