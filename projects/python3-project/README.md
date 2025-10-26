# Python 3 FastAPI DevPod Project

A complete Python 3.11 FastAPI development environment configured for DevPod with SQLAlchemy, Pydantic, and comprehensive testing.

## 🚀 Quick Start

1. **Start the DevPod environment:**
   ```bash
   ./manage-devpod.sh start
   ```

2. **Other management commands:**
   ```bash
   ./manage-devpod.sh stop      # Stop workspace
   ./manage-devpod.sh restart   # Restart workspace
   ./manage-devpod.sh status    # Check status
   ./manage-devpod.sh logs      # View logs
   ./manage-devpod.sh ssh       # SSH into workspace
   ./manage-devpod.sh test      # Run tests
   ./manage-devpod.sh format    # Format and lint code
   ```

## 📁 Project Structure

```
python3-project/
├── .devcontainer/
│   └── devcontainer.json       # DevContainer configuration
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI application
│   ├── models.py               # Pydantic and SQLAlchemy models
│   ├── database.py             # Database configuration
│   └── crud.py                 # CRUD operations
├── tests/
│   └── test_api.py            # API tests
├── requirements.txt            # Python dependencies
├── README.md                  # This file
└── manage-devpod.sh          # DevPod management script
```

## 🔧 Available Commands

```bash
# Development server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Testing
python -m pytest tests/ -v
python -m pytest tests/ --cov=app

# Code quality
python -m black app/ tests/     # Format code
python -m isort app/ tests/     # Sort imports
python -m flake8 app/ tests/    # Lint code
python -m mypy app/             # Type checking
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome message and API info |
| GET | `/health` | Health check and system metrics |
| GET | `/api/users` | List all users with pagination |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Create a new user |
| PUT | `/api/users/{id}` | Update user by ID |
| DELETE | `/api/users/{id}` | Delete user by ID |
| GET | `/api/users/search/{email}` | Search user by email |

### Interactive API Documentation
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Example API Usage

```bash
# Get welcome message
curl http://localhost:8000/

# Health check
curl http://localhost:8000/health

# Get all users
curl http://localhost:8000/api/users

# Create user
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "bio": "Software Developer"
  }'

# Get user by ID
curl http://localhost:8000/api/users/1

# Update user
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "bio": "Senior Software Developer"
  }'

# Delete user
curl -X DELETE http://localhost:8000/api/users/1

# Search by email
curl http://localhost:8000/api/users/search/john@example.com
```

## 🛠️ Development Environment

### Pre-installed Extensions
- **Python** - Python language support
- **Pylint** - Python linting
- **Black Formatter** - Code formatting
- **Flake8** - Code linting
- **isort** - Import sorting
- **Jupyter** - Jupyter notebook support
- **MyPy** - Type checking
- **Ruff** - Fast Python linter

### Pre-configured Features
- **Python 3.11** - Latest stable version
- **FastAPI** - Modern, fast web framework
- **SQLAlchemy** - Database ORM
- **Pydantic** - Data validation
- **Uvicorn** - ASGI server
- **pytest** - Testing framework
- **Black** - Code formatting
- **isort** - Import sorting
- **Flake8** - Linting
- **MyPy** - Type checking

## 🌐 Port Configuration

- **8000** - Main FastAPI application
- **8001** - Alternative development port
- **5000** - Additional services port

## 🗄️ Database Configuration

### SQLite (Development)
- **File**: `dev.db` (created automatically)
- **URL**: `sqlite:///./dev.db`

### Environment Variables
Create a `.env` file for configuration:
```env
DATABASE_URL=sqlite:///./dev.db
DEBUG=True
ENVIRONMENT=development
```

## 📦 Dependencies

### Production
- **fastapi** - Web framework
- **uvicorn** - ASGI server
- **pydantic** - Data validation
- **sqlalchemy** - Database ORM
- **alembic** - Database migrations
- **psycopg2-binary** - PostgreSQL adapter
- **python-jose** - JWT handling
- **passlib** - Password hashing

### Development
- **pytest** - Testing framework
- **pytest-asyncio** - Async testing
- **httpx** - HTTP client for testing
- **black** - Code formatting
- **flake8** - Linting
- **isort** - Import sorting
- **mypy** - Type checking

## 🔄 DevPod Commands

```bash
# Start workspace
devpod up . --id python3-devpod-workspace

# Stop workspace
devpod stop python3-devpod-workspace

# SSH into workspace
devpod ssh python3-devpod-workspace

# View logs
devpod logs python3-devpod-workspace

# Delete workspace
devpod delete python3-devpod-workspace
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
python -m pytest tests/ -v

# Run tests with coverage
python -m pytest tests/ --cov=app --cov-report=html

# Run specific test
python -m pytest tests/test_api.py::test_create_user -v

# Run tests in watch mode
python -m pytest tests/ --watch
```

## 🔧 Code Quality

### Formatting and Linting
```bash
# Format code with Black
python -m black app/ tests/

# Sort imports with isort
python -m isort app/ tests/

# Lint with Flake8
python -m flake8 app/ tests/

# Type checking with MyPy
python -m mypy app/

# All-in-one formatting
./manage-devpod.sh format
```

### Pre-commit Hooks
Install pre-commit hooks for automatic code quality:
```bash
pre-commit install
```

## 🚀 Production Deployment

### Docker Deployment
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app/ app/
EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Environment Configuration
For production, use environment variables:
```env
DATABASE_URL=postgresql://user:password@localhost/dbname
DEBUG=False
ENVIRONMENT=production
SECRET_KEY=your-secret-key
```

## 📊 Monitoring and Logging

### Health Checks
The `/health` endpoint provides:
- Service status
- System memory usage
- CPU utilization
- Python version
- Timestamp

### Logging
Configure logging in production:
```python
import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
```

## 🆘 Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   uvicorn app.main:app --port 8001
   ```

2. **Database connection issues:**
   ```bash
   # Check database file permissions
   ls -la dev.db
   ```

3. **Import errors:**
   ```bash
   # Reinstall dependencies
   pip install -r requirements.txt
   ```

4. **DevPod won't start:**
   ```bash
   ./manage-devpod.sh logs
   ```

### Getting Help

- Check workspace logs: `./manage-devpod.sh logs`
- Restart workspace: `./manage-devpod.sh restart`
- View FastAPI documentation: https://fastapi.tiangolo.com/
- View DevPod documentation: https://devpod.sh/docs

## 🔧 IDE Configuration

### VS Code Settings
The DevContainer includes optimized settings for Python development:
- Automatic formatting on save
- Import organization
- Type checking
- Linting integration
- Testing support

### Recommended Workflow
1. Start the DevPod workspace
2. Open VS Code (automatically configured)
3. Make changes to code
4. Tests and linting run automatically
5. Use the interactive API docs at `/docs`