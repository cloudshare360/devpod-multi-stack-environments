# DevPod Desktop Application Guide

This guide explains how to use the DevPod Desktop application to browse your multi-stack development projects and start applications with ease.

## 📋 Table of Contents

1. [DevPod Desktop Overview](#devpod-desktop-overview)
2. [Installation & Setup](#installation--setup)
3. [Opening Projects](#opening-projects)
4. [Project Structure Navigation](#project-structure-navigation)
5. [Starting Applications](#starting-applications)
6. [Database Management](#database-management)
7. [GitHub Copilot Integration](#github-copilot-integration)
8. [Development Workflows](#development-workflows)
9. [Troubleshooting](#troubleshooting)

## 🖥️ DevPod Desktop Overview

DevPod Desktop is a user-friendly GUI application that simplifies container-based development. It provides:

- **Visual Project Management**: Browse and manage multiple development environments
- **One-Click Startup**: Start development containers with a single click
- **Integrated Terminal**: Access containerized environments directly
- **Port Management**: Automatic port forwarding and conflict resolution
- **VS Code Integration**: Seamless integration with Visual Studio Code
- **AI-Powered Development**: GitHub Copilot integration for enhanced coding assistance
- **Consistent UI**: Automatic menu bar visibility and optimized workspace settings

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

## 🤖 GitHub Copilot Integration

### Overview

The nodejs-project (and soon other projects) includes **GitHub Copilot** and **GitHub Copilot Chat** for AI-powered development assistance. This provides:

- **Intelligent Code Completion**: AI-powered suggestions as you type
- **Chat-Based Assistance**: Ask questions and get code explanations
- **Code Generation**: Generate functions, classes, and entire files
- **Bug Fixes**: Get suggestions for fixing code issues
- **Documentation**: Generate comments and documentation
- **Test Generation**: Create unit tests automatically

### Setup Requirements

#### 1. GitHub Copilot Subscription

**Individual Plan**: $10/month or $100/year
**Business Plan**: $19/user/month (for organizations)
**Student/Teacher**: Free with GitHub Education benefits

**Sign up at**: https://github.com/features/copilot

#### 2. Authentication

**Method A: Through VS Code**
1. Open VS Code in your DevPod workspace
2. Look for **GitHub Copilot** in the status bar
3. Click to **Sign in to GitHub**
4. Follow the authentication process

**Method B: Through GitHub CLI**
```bash
# In VS Code terminal
gh auth login
# Follow the prompts to authenticate
```

#### 3. Extension Verification

The nodejs-project automatically includes:
```json
"extensions": [
    "github.copilot",           // Core Copilot extension
    "github.copilot-chat",      // Chat interface
    // ... other extensions
]
```

### Using GitHub Copilot

#### Code Completion
- **Type naturally**: Copilot suggests completions as you type
- **Accept suggestion**: Press `Tab` to accept
- **Next suggestion**: Press `Alt+]` (or `Option+]` on Mac)
- **Previous suggestion**: Press `Alt+[` (or `Option+[` on Mac)

#### Copilot Chat
- **Open Chat**: `Ctrl+Shift+P` → "GitHub Copilot: Open Chat"
- **Inline Chat**: `Ctrl+I` for inline assistance
- **Explain Code**: Select code → Right-click → "Copilot: Explain This"
- **Generate Tests**: Select function → "Copilot: Generate Tests"

#### Example Chat Commands
```
// Ask general questions
"How do I connect to PostgreSQL in Node.js?"

// Request code generation
"Create a REST API endpoint for user authentication"

// Get explanations
"Explain this function and how it works"

// Request optimizations
"How can I improve the performance of this code?"

// Generate tests
"Create unit tests for this user service class"
```

### AI-Enhanced Development Workflow

#### 1. Project Setup with AI
```bash
# Start nodejs-project
cd nodejs-project && devpod up .

# In VS Code, use Copilot Chat:
"Help me set up a REST API with Express and PostgreSQL"
```

#### 2. Database Integration
```bash
# Ask Copilot Chat:
"Show me how to connect to PostgreSQL using the credentials:
Host: localhost:5434
Database: devdb
User: devuser
Password: devpass123"
```

#### 3. API Development
```javascript
// Type a comment and let Copilot generate code:
// Create an Express route to get all users from PostgreSQL

// Copilot will suggest something like:
app.get('/api/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM employees');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
```

#### 4. Testing with AI
```bash
# Ask Copilot Chat:
"Generate Jest unit tests for my user API endpoints"
```

### Copilot Best Practices

#### 1. Descriptive Comments
```javascript
// Good: Copilot understands intent
// Create a middleware function to validate JWT tokens and check user permissions

// Less effective:
// JWT function
```

#### 2. Context Awareness
- **Open related files** in VS Code tabs for better context
- **Provide examples** in comments for specific patterns
- **Use meaningful variable names** for better suggestions

#### 3. Security Considerations
- **Review all generated code** before committing
- **Don't include sensitive data** in prompts
- **Validate security practices** in generated code
- **Test thoroughly** before deploying

### Troubleshooting Copilot

#### Copilot Not Working
```bash
# Check authentication status
gh auth status

# Re-authenticate if needed
gh auth login

# Check VS Code extension status
# Command Palette → "GitHub Copilot: Check Status"
```

#### No Suggestions Appearing
1. **Check subscription status** at github.com/settings/copilot
2. **Verify extensions** are enabled in VS Code
3. **Restart VS Code** and rebuild container if needed
4. **Check internet connection** for AI service access

#### Chat Not Responding
1. **Verify Copilot Chat extension** is installed
2. **Check GitHub authentication** status
3. **Try refreshing** the chat panel
4. **Restart VS Code** if issues persist

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

#### 6. Menu Bar Not Visible

**Symptoms**: VS Code menu bar (File, Edit, View, etc.) is hidden

**Solutions**:
- **Automatic Fix**: The nodejs-project includes `"window.menuBarVisibility": "classic"` setting
- **Manual Fix**: Press `Alt` key to temporarily show menu, then View → Appearance → Menu Bar
- **Permanent Fix**: Add to devcontainer.json settings:
```json
"settings": {
    "window.menuBarVisibility": "classic",
    "window.enableMenuBarMnemonics": true
}
```

#### 7. GitHub Copilot Issues

**Symptoms**: Copilot not providing suggestions or chat not working

**Solutions**:
```bash
# Verify subscription and authentication
gh auth status

# Check Copilot status in VS Code
# Command Palette → "GitHub Copilot: Check Status"

# Re-authenticate if needed
gh auth logout
gh auth login

# Restart VS Code and rebuild container
devpod rebuild nodejs-project
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