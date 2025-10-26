# Development Database Environment

This folder provides a complete PostgreSQL database environment with pgAdmin web interface for development purposes. It's designed to work seamlessly with all DevPod projects (Java, Node.js, Python, React, Angular, etc.).

## 🚀 Quick Start

```bash
# Start the database environment
./start-db.sh

# Check status
./status-db.sh

# Stop the database
./stop-db.sh

# Reset database (delete all data)
./reset-db.sh
```

## 📊 Connection Information

### PostgreSQL Database
- **Host**: `localhost`
- **Port**: `5432`
- **Database**: `devdb`
- **Username**: `devuser`
- **Password**: `devpass123`

### pgAdmin Web Interface
- **URL**: http://localhost:8080
- **Email**: `admin@dev.local`
- **Password**: `admin123`

## 🗂️ Folder Structure

```
database/
├── docker-compose.yml      # Container orchestration
├── pgadmin-servers.json   # Auto-configure pgAdmin connection
├── start-db.sh           # Start database containers
├── stop-db.sh            # Stop database containers  
├── reset-db.sh           # Reset database (delete all data)
├── status-db.sh          # Check container status
├── README.md             # This documentation
├── schema/               # Database schema files
│   ├── 01-init.sql      # Initial database setup
│   ├── 02-tables.sql    # Table creation scripts
│   └── 03-indexes.sql   # Index creation scripts
├── seed-data/           # Initial data for development
│   ├── 01-users.sql     # Sample user data
│   ├── 02-products.sql  # Sample product data
│   └── 03-orders.sql    # Sample order data
└── db-data-files/       # Persistent database storage
    └── (PostgreSQL data files created automatically)
```

## 🛠️ How to Use

### 1. Starting the Database

```bash
./start-db.sh
```

This will:
- Start PostgreSQL and pgAdmin containers
- Apply schema files from `schema/` folder
- Load seed data from `seed-data/` folder
- Show connection information

### 2. Accessing pgAdmin Web Interface

1. Open http://localhost:8080 in your browser
2. Login with:
   - **Email**: `admin@dev.local`
   - **Password**: `admin123`
3. The PostgreSQL server will be automatically configured

### 3. Connecting from Applications

#### Java/Spring Boot
```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/devdb
spring.datasource.username=devuser
spring.datasource.password=devpass123
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

#### Node.js
```javascript
// Using pg (node-postgres)
const { Pool } = require('pg');

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'devdb',
  user: 'devuser',
  password: 'devpass123'
});
```

#### Python
```python
# Using psycopg2
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port="5432",
    database="devdb",
    user="devuser",
    password="devpass123"
)

# Using SQLAlchemy
DATABASE_URL = "postgresql://devuser:devpass123@localhost:5432/devdb"
```

### 4. Managing Schema and Data

#### Adding New Tables
1. Create SQL files in `schema/` folder (e.g., `04-new-table.sql`)
2. Files are executed in alphabetical order during initialization
3. Reset and restart database to apply changes

#### Adding Seed Data
1. Create SQL files in `seed-data/` folder (e.g., `04-new-data.sql`)
2. Files are executed in alphabetical order after schema
3. Reset and restart database to apply changes

### 5. VS Code Database Extensions

The following extensions are automatically installed in DevPod containers:

- **PostgreSQL** (`ms-ossdata.vscode-postgresql`) - PostgreSQL management
- **Database Client** (`cweijan.vscode-postgresql-client2`) - Universal database client
- **SQL Tools** (`mtxr.sqltools`) - Advanced SQL tools
- **Thunder Client** (`rangav.vscode-thunder-client`) - API testing for REST endpoints

## 🔧 Troubleshooting

### Container Issues

```bash
# Check container status
./status-db.sh

# View container logs
docker logs dev-postgres
docker logs dev-pgadmin

# Restart containers
./stop-db.sh && ./start-db.sh
```

### Connection Issues

1. **Port conflicts**: Ensure ports 5432 and 8080 are not in use
2. **Docker issues**: Restart Docker service
3. **Permission issues**: Check if current user can run Docker

### Data Issues

```bash
# Reset database completely
./reset-db.sh

# Start fresh
./start-db.sh
```

## 🐳 Docker Details

### Services
- **postgres**: PostgreSQL 15 Alpine
- **pgadmin**: pgAdmin4 latest

### Volumes
- `./db-data-files`: PostgreSQL data persistence
- `pgadmin-data`: pgAdmin configuration persistence

### Networks
- `dev-network`: Bridge network for container communication

## 📝 Development Workflow

### 1. Start Development
```bash
./start-db.sh
```

### 2. Develop Your Application
- Use the connection details above
- Database is automatically populated with schema and seed data
- pgAdmin available for database management

### 3. Testing
- Use seed data for consistent testing
- Reset database between test runs if needed

### 4. Stop Development
```bash
./stop-db.sh
```

## 🔒 Security Notes

⚠️ **Important**: This setup is for **development only**
- Default passwords are simple and predictable
- No SSL/TLS encryption configured
- pgAdmin runs in development mode
- Do not use in production environments

## 📚 Useful SQL Commands

### Check Tables
```sql
-- List all tables
\dt

-- Describe table structure
\d table_name

-- Show all databases
\l
```

### Sample Queries
```sql
-- Count users
SELECT COUNT(*) FROM users;

-- Get all products
SELECT * FROM products LIMIT 10;

-- Check database version
SELECT version();
```

## 🤝 Integration with DevPod Projects

This database environment is designed to work with:

- **Java 17 + Spring Boot**: JPA/Hibernate integration
- **Node.js + Express**: Sequelize/TypeORM support
- **Python + Django/Flask**: SQLAlchemy integration
- **React/Angular**: REST API backend support
- **Full-stack applications**: Complete database layer

Each project can use the same database instance, making it easy to develop microservices or practice with different technology stacks using the same data.