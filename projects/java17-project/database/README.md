# Database Management Guide

This project uses PostgreSQL database with Docker Compose for development. All database data is persisted in the `database/data` folder.

## Quick Start

### Start Database Services
```bash
./database/manage.sh start
```

### Stop Database Services
```bash
./database/manage.sh stop
```

### Check Status
```bash
./database/manage.sh status
```

## Services

### PostgreSQL Database
- **Host**: localhost
- **Port**: 5432
- **Database**: devdb
- **Username**: devuser
- **Password**: devpass
- **Data Location**: `database/data/`

### pgAdmin (Database UI)
- **URL**: http://localhost:5050
- **Email**: admin@admin.com
- **Password**: admin
- **Config Location**: `database/pgadmin/`

## Database Operations

### Connect to Database CLI
```bash
./database/manage.sh connect
```

### View Logs
```bash
./database/manage.sh logs
```

### Create Backup
```bash
./database/manage.sh backup
```

### Restore from Backup
```bash
./database/manage.sh restore <backup-file>
```

### Clean Database (DESTRUCTIVE!)
```bash
./database/manage.sh clean
```

## Spring Boot Configuration

The application is configured to connect to PostgreSQL using different profiles:

### Local Development (Docker Compose)
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=docker
```

### Default Configuration
The default `application.properties` is set to use PostgreSQL on localhost:5432.

## Folder Structure

```
database/
├── data/           # PostgreSQL data files (persistent)
├── pgadmin/        # pgAdmin configuration (persistent)
├── init/           # Database initialization scripts
│   └── 01-init.sql # Initial schema and data
├── backup/         # Database backups
└── manage.sh       # Database management script
```

## Docker Compose Services

### Start All Services (including development container)
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

## Troubleshooting

### Database Connection Issues
1. Check if PostgreSQL is running: `./database/manage.sh status`
2. Check logs: `./database/manage.sh logs`
3. Test connection: `./database/manage.sh connect`

### Permission Issues
```bash
sudo chown -R $USER:$USER database/data/
sudo chown -R $USER:$USER database/pgadmin/
```

### Reset Database
```bash
./database/manage.sh clean
./database/manage.sh start
```

## pgAdmin Setup

1. Open http://localhost:5050
2. Login with admin@admin.com / admin
3. Add New Server:
   - Name: Java21 Dev
   - Host: postgres
   - Port: 5432
   - Database: devdb
   - Username: devuser
   - Password: devpass