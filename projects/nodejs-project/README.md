# Node.js DevPod Project

A complete Node.js development environment configured for DevPod with Express.js API.

## 🚀 Quick Start

1. **Start the DevPod environment:**
   ```bash
   ./start-devpod.sh
   ```

2. **Or manually start:**
   ```bash
   devpod up . --id nodejs-devpod-workspace
   ```

## 📁 Project Structure

```
nodejs-project/
├── .devcontainer/
│   └── devcontainer.json      # DevContainer configuration
├── src/
│   └── index.js              # Main application file
├── tests/
│   └── api.test.js           # Test files
├── package.json              # Node.js dependencies
├── .env                      # Environment variables
├── .gitignore               # Git ignore rules
├── README.md                # This file
└── start-devpod.sh          # DevPod launcher script
```

## 🔧 Available Scripts

```bash
npm run dev        # Start development server with nodemon
npm start          # Start production server
npm test           # Run tests with Jest
npm run test:watch # Run tests in watch mode
npm run lint       # Check code with ESLint
npm run lint:fix   # Fix ESLint issues
npm run format     # Format code with Prettier
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome message and API info |
| GET | `/health` | Health check and system info |
| GET | `/api/users` | List all users |
| POST | `/api/users` | Create a new user |

### Example API Usage

```bash
# Get welcome message
curl http://localhost:3000/

# Health check
curl http://localhost:3000/health

# Get users
curl http://localhost:3000/api/users

# Create user
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

## 🛠️ Development Environment

### Pre-installed Extensions
- **TypeScript** - Enhanced TypeScript support
- **Prettier** - Code formatting
- **ESLint** - Code linting
- **Auto Rename Tag** - HTML tag renaming
- **Path Intellisense** - File path autocomplete
- **NPM Scripts** - NPM script management

### Pre-configured Features
- **Auto-formatting** on save
- **ESLint** integration
- **TypeScript** support
- **Hot reloading** with nodemon
- **Testing** with Jest
- **CORS** enabled
- **Security** with Helmet
- **Logging** with Morgan

## 🌐 Port Configuration

- **3000** - Main application server
- **3001** - Alternative development port
- **8000** - Additional services port

## 📦 Dependencies

### Production
- **express** - Web application framework
- **cors** - Cross-Origin Resource Sharing
- **helmet** - Security middleware
- **dotenv** - Environment variables
- **morgan** - HTTP request logger

### Development
- **nodemon** - Auto-restart development server
- **eslint** - JavaScript linter
- **prettier** - Code formatter
- **jest** - Testing framework
- **supertest** - HTTP testing

## 🔄 DevPod Commands

```bash
# Start workspace
devpod up . --id nodejs-devpod-workspace

# Stop workspace
devpod stop nodejs-devpod-workspace

# SSH into workspace
devpod ssh nodejs-devpod-workspace

# View logs
devpod logs nodejs-devpod-workspace

# Delete workspace
devpod delete nodejs-devpod-workspace
```

## 🧪 Testing

Run the test suite:
```bash
npm test
```

Run tests in watch mode:
```bash
npm run test:watch
```

## 🔧 Environment Variables

Create a `.env` file in the project root:

```env
NODE_ENV=development
PORT=3000
API_VERSION=1.0.0
```

## 🚀 Deployment

The application is containerized and ready for deployment to:
- Docker containers
- Kubernetes clusters
- Cloud platforms (Heroku, AWS, etc.)

## 📝 Notes

- The development server runs on `0.0.0.0` to allow access from the DevContainer
- Hot reloading is enabled for development
- All code is automatically formatted and linted
- Health check endpoint provides system metrics
- CORS is enabled for frontend integration

## 🆘 Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   # Change port in .env file or:
   PORT=3001 npm run dev
   ```

2. **DevPod won't start:**
   ```bash
   devpod logs nodejs-devpod-workspace
   ```

3. **Dependencies not installing:**
   ```bash
   # Clear npm cache
   npm cache clean --force
   npm install
   ```

### Getting Help

- Check DevPod logs: `devpod logs nodejs-devpod-workspace`
- Restart workspace: `devpod stop nodejs-devpod-workspace && devpod up .`
- View DevPod documentation: https://devpod.sh/docs