# Port Allocation Summary

This document provides a comprehensive overview of port assignments across all DevPod projects to prevent conflicts and ensure each project has unique access ports.

## Port Allocation Strategy

Each project has been assigned a unique set of ports to avoid conflicts when running multiple environments simultaneously. **Note**: Ports 80, 3000, and 3030 are avoided as they may conflict with local development applications.

| Project | Database | pgAdmin | API Port | UI Port | Additional |
|---------|----------|---------|----------|---------|------------|
| **postgresql-devpod-project** | 5432 | 8080 | - | - | 3002, 8000 |
| **java17-project** | 5433 | 8081 | 8090 | - | - |
| **nodejs-project** | 5434 | 8082 | 9000 | - | 3001 |
| **python3-project** | 5435 | 8083 | 8000 | - | 8001, 5000 |
| **react-project** | 5436 | 8084 | - | 3010 | 3011 |
| **angular-project** | 5437 | 8085 | - | 4200 | 4201 |
| **mern-fullstack** | 5438 | 8086 | 5000 | 3020 | 27017 (MongoDB) |
| **angular-java-fullstack** | 5439 | 8087 | 8095 | 4210 | 8096 (Adminer) |

## Key Benefits

✅ **No Port Conflicts**: Each project uses completely unique ports  
✅ **Predictable Pattern**: Sequential numbering makes ports easy to remember  
✅ **Multiple Projects**: Can run all projects simultaneously without conflicts  
✅ **Container Isolation**: Unique container names prevent Docker conflicts  
✅ **Local Compatibility**: Avoids ports 80, 3000, and 3030 commonly used by local applications

## Access URLs by Project

### postgresql-devpod-project
- **PostgreSQL**: `localhost:5432`
- **pgAdmin**: `http://localhost:8080`
- **Development Server**: `http://localhost:3002`

### java17-project
- **Spring Boot API**: `http://localhost:8090`
- **PostgreSQL**: `localhost:5433`
- **pgAdmin**: `http://localhost:8081`

### nodejs-project
- **Node.js API**: `http://localhost:9000`
- **PostgreSQL**: `localhost:5434`
- **pgAdmin**: `http://localhost:8082`

### python3-project
- **FastAPI**: `http://localhost:8000`
- **PostgreSQL**: `localhost:5435`
- **pgAdmin**: `http://localhost:8083`

### react-project
- **React App**: `http://localhost:3010`
- **PostgreSQL**: `localhost:5436`
- **pgAdmin**: `http://localhost:8084`

### angular-project
- **Angular App**: `http://localhost:4200`
- **PostgreSQL**: `localhost:5437`
- **pgAdmin**: `http://localhost:8085`

### mern-fullstack
- **React Frontend**: `http://localhost:3020`
- **Node.js Backend**: `http://localhost:5000`
- **MongoDB**: `localhost:27017`
- **PostgreSQL**: `localhost:5438`
- **pgAdmin**: `http://localhost:8086`

### angular-java-fullstack
- **Angular Frontend**: `http://localhost:4210`
- **Spring Boot Backend**: `http://localhost:8095`
- **PostgreSQL**: `localhost:5439`
- **pgAdmin**: `http://localhost:8087`
- **Adminer**: `http://localhost:8096`

## Configuration Files Updated

### Docker Compose Files
- Updated all `database/docker-compose.yml` files with unique PostgreSQL and pgAdmin ports
- Updated container names to prevent conflicts (e.g., `java17-postgres`, `nodejs-pgadmin`)

### DevContainer Configurations
- Updated all `.devcontainer/devcontainer.json` files with correct port forwarding
- Added proper port attributes with descriptive labels

### Application Configurations
- Updated Java Spring Boot `application.properties` files with new API ports and database URLs
- Updated Node.js application to use port 9000
- Updated main `docker-compose.yml` for angular-java-fullstack project

## Database Credentials (Development Only)

All projects use consistent database credentials for development:

```
Database: devdb
Username: devuser
Password: devpass123
pgAdmin Email: admin@dev.local
pgAdmin Password: admin123
```

**⚠️ Security Note**: These are development-only credentials. Change them for production use.

## Usage Examples

### Running Multiple Projects Simultaneously

You can now run multiple projects at the same time without conflicts:

```bash
# Terminal 1: Start Java project
cd projects/java17-project/database && ./start-db.sh

# Terminal 2: Start Node.js project  
cd projects/nodejs-project/database && ./start-db.sh

# Terminal 3: Start Python project
cd projects/python3-project/database && ./start-db.sh
```

### Accessing Services

```bash
# Java Spring Boot API
curl http://localhost:8090/api/health

# Node.js API
curl http://localhost:9000/api/health

# Python FastAPI
curl http://localhost:8000/docs

# React Frontend
open http://localhost:3010

# Angular Frontend
open http://localhost:4200
```

## Troubleshooting

### Port Already in Use
If you see "port already in use" errors:
1. Check which project is using the port: `lsof -i :PORT_NUMBER`
2. Stop the conflicting service
3. Use the project-specific ports listed above

### Database Connection Issues
1. Verify the database is running: `./status-db.sh`
2. Check the correct port is being used in your application configuration
3. Ensure database URL matches the project's assigned port

### Container Name Conflicts
Each project now uses unique container names:
- `java17-postgres`, `java17-pgadmin`
- `nodejs-postgres`, `nodejs-pgadmin`
- etc.

This prevents Docker container naming conflicts.

---

*Last Updated: October 25, 2025*  
*Port allocation implemented to support simultaneous multi-project development*  
*Updated to avoid conflicts with common local ports (80, 3000, 3030)*