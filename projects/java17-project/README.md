# Java 21 Spring Boot DevPod Project

A complete Java 21 Spring Boot development environment configured for DevPod with REST API, JPA, and PostgreSQL database using Docker Compose.

## 🚀 Quick Start

### Option 1: Using DevContainer (Recommended)
1. **Open in DevContainer:**
   - VS Code will automatically detect the devcontainer configuration
   - Services (PostgreSQL + pgAdmin) will start automatically
   - Java 21 environment will be ready

### Option 2: Manual Setup
1. **Start the database services:**
   ```bash
   ./database/manage.sh start
   ```

2. **Run the application:**
   ```bash
   mvn spring-boot:run
   ```

## 🗄️ Database Configuration

### PostgreSQL Database
- **Host**: localhost (or `postgres` in Docker Compose)
- **Port**: 5432
- **Database**: devdb
- **Username**: devuser
- **Password**: devpass
- **Data Location**: `database/data/` (persistent)

### pgAdmin (Database UI)
- **URL**: http://localhost:5050
- **Email**: admin@admin.com
- **Password**: admin
- **Config Location**: `database/pgadmin/` (persistent)

### Database Management Commands
```bash
./database/manage.sh start      # Start PostgreSQL and pgAdmin
./database/manage.sh stop       # Stop database services
./database/manage.sh restart    # Restart database services
./database/manage.sh status     # Check service status
./database/manage.sh connect    # Connect to PostgreSQL CLI
./database/manage.sh logs       # View PostgreSQL logs
./database/manage.sh backup     # Create database backup
./database/manage.sh restore    # Restore from backup
./database/manage.sh clean      # Clean all data (DESTRUCTIVE!)
```

## 📁 Project Structure

```
java21-project/
├── .devcontainer/
│   ├── devcontainer.json           # DevContainer configuration
│   ├── Dockerfile                  # Java 21 development image
│   └── setup.sh                    # Post-create setup script
├── database/
│   ├── data/                       # PostgreSQL data (persistent)
│   ├── pgadmin/                    # pgAdmin config (persistent)
│   ├── init/
│   │   └── 01-init.sql            # Database initialization
│   ├── manage.sh                   # Database management script
│   └── README.md                   # Database documentation
├── src/
│   ├── main/
│   │   ├── java/com/devpod/app/
│   │   │   ├── Application.java     # Main Spring Boot application
│   │   │   ├── controller/
│   │   │   │   └── ApiController.java
│   │   │   ├── model/
│   │   │   │   └── User.java
│   │   │   ├── repository/
│   │   │   │   └── UserRepository.java
│   │   │   └── service/
│   │   │       └── UserService.java
│   │   └── resources/
│   │       ├── application.properties        # Default (PostgreSQL)
│   │       ├── application-docker.properties # Docker Compose
│   │       ├── application-postgres.properties
│   │       ├── schema.sql                   # Database schema
│   │       └── data.sql                     # Sample data
│   └── test/
│       └── java/com/devpod/app/
├── docker-compose.yml              # Docker Compose services
├── pom.xml                         # Maven configuration
└── README.md                       # This file
```

## ️ Development Environment

### Pre-installed Extensions
- **Java Extension Pack** - Complete Java development tools
- **Spring Boot Extension Pack** - Spring Boot support
- **Spring Boot Dashboard** - Manage Spring Boot applications
- **Maven for Java** - Maven integration
- **Lombok Annotations Support** - Lombok support
- **PostgreSQL Extension** - PostgreSQL support

### Pre-configured Features
- **Java 21** - Latest LTS version
- **Spring Boot 3.2.12** - Compatible with Java 21
- **Spring Data JPA** - Database abstraction
- **PostgreSQL Database** - Production-ready database
- **Spring Boot Actuator** - Production-ready features
- **Bean Validation** - Input validation
- **Lombok** - Reduce boilerplate code
- **DevTools** - Hot reloading and development tools
- **Docker Compose** - Container orchestration

## 🌐 Port Configuration

- **8080** - Main Spring Boot application
- **5432** - PostgreSQL database
- **5050** - pgAdmin web interface

## 🔧 Available Maven Commands

```bash
mvn spring-boot:run                    # Start with default profile
mvn spring-boot:run -Dspring-boot.run.profiles=docker  # Start with Docker profile
mvn clean compile                      # Compile the project
mvn test                              # Run tests
mvn clean package                     # Build JAR file
mvn clean install                     # Install to local repository
```

## � API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/` | Welcome message and API info |
| GET | `/api/health` | Health check and system metrics |
| GET | `/api/users` | List all users |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Create a new user |
| PUT | `/api/users/{id}` | Update user by ID |
| DELETE | `/api/users/{id}` | Delete user by ID |

### Example API Usage

```bash
# Get welcome message
curl http://localhost:8080/api/

# Health check
curl http://localhost:8080/api/health

# Get all users
curl http://localhost:8080/api/users

# Get user by ID
curl http://localhost:8080/api/users/1

# Create user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "bio": "Software Developer"
  }'

# Update user
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "email": "john.smith@example.com",
    "phone": "+1234567890",
    "bio": "Senior Software Developer"
  }'

# Delete user
curl -X DELETE http://localhost:8080/api/users/1
```

## 🐳 Docker Compose Services

### Start All Services
```bash
docker compose up -d
```

### Start Only Database Services
```bash
docker compose up -d postgres pgadmin
```

### View Service Status
```bash
docker compose ps
```

### View Logs
```bash
docker compose logs postgres
docker compose logs pgadmin
```

### Stop Services
```bash
docker compose down
```

## 📦 Dependencies

### Spring Boot Starters
- **spring-boot-starter-web** - Web MVC framework
- **spring-boot-starter-data-jpa** - JPA data access
- **spring-boot-starter-validation** - Bean validation
- **spring-boot-starter-actuator** - Production features
- **spring-boot-devtools** - Development tools

### Additional Libraries
- **H2 Database** - In-memory database
- **Lombok** - Reduce boilerplate code
- **TestContainers** - Integration testing

## 🔄 DevPod Commands

```bash
# Start workspace
devpod up . --id java17-devpod-workspace

# Stop workspace
devpod stop java17-devpod-workspace

# SSH into workspace
devpod ssh java17-devpod-workspace

# View logs
devpod logs java17-devpod-workspace

# Delete workspace
devpod delete java17-devpod-workspace
```

## 🧪 Testing

The project includes comprehensive testing setup:

```bash
# Run all tests
mvn test

# Run tests with coverage
mvn test jacoco:report

# Run specific test class
mvn test -Dtest=UserServiceTest
```

## 🚀 Production Configuration

For production deployment, consider:

1. **Database**: Replace H2 with PostgreSQL/MySQL
2. **Security**: Add Spring Security
3. **Profiles**: Configure different application-{profile}.properties
4. **Logging**: Configure proper logging levels
5. **Monitoring**: Enable additional Actuator endpoints

### Example Production Profile

Create `application-prod.properties`:
```properties
# PostgreSQL Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/proddb
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

# JPA Configuration
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false

# Logging
logging.level.com.devpod.app=INFO
logging.level.org.springframework.web=WARN
```

## 📊 Monitoring and Health Checks

### Actuator Endpoints
- **Health**: http://localhost:8080/actuator/health
- **Info**: http://localhost:8080/actuator/info
- **Metrics**: http://localhost:8080/actuator/metrics

### Custom Health Indicators
The application includes custom health checks for database connectivity and system resources.

## 🆘 Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   # Change port in application.properties or:
   mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8081
   ```

2. **DevPod won't start:**
   ```bash
   ./manage-devpod.sh logs
   ```

3. **Database connection issues:**
   ```bash
   # Check H2 console at http://localhost:8080/h2-console
   # Verify connection settings in application.properties
   ```

4. **Maven dependency issues:**
   ```bash
   mvn clean install -U
   ```

### Getting Help

- Check workspace logs: `./manage-devpod.sh logs`
- Restart workspace: `./manage-devpod.sh restart`
- View Spring Boot documentation: https://spring.io/projects/spring-boot
- View DevPod documentation: https://devpod.sh/docs

## 🔧 IDE Configuration

### VS Code Settings
The DevContainer includes optimized settings for Java development:
- Automatic imports
- Code formatting with Google Java Style
- Lombok annotation processing
- Spring Boot support
- Maven integration

### Recommended Workflow
1. Start the DevPod workspace
2. Open VS Code (automatically configured)
3. Make changes to code
4. Spring Boot DevTools will automatically restart the application
5. Test your changes via the API endpoints