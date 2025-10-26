# Database Integration Guide

This document explains the comprehensive database setup included with all DevPod projects in this repository. Each project comes with a complete PostgreSQL database environment featuring an employee management system that demonstrates all major RDBMS relationship types.

## 🎯 Purpose & Goals

The database setup enables you to:

1. **Practice Full-Stack Development**: Build REST APIs and web applications with real database integration
2. **Learn RDBMS Concepts**: Explore all relationship types (1:1, 1:M, M:M, M:1) with practical examples
3. **Rapid Prototyping**: Get started quickly with a production-ready database schema
4. **Cross-Technology Learning**: Same database works with Java/Spring Boot, Node.js/Express, Python/Django/FastAPI, React, Angular, and full-stack applications

## 🗄️ Database Schema Overview

### Employee Management System

The database implements a comprehensive employee management system with the following entities:

#### Core Entities
- **Departments** - Organizational units
- **Employees** - Staff members with hierarchical relationships
- **Employee Profiles** - Extended employee information
- **Skills** - Technical and soft skills catalog
- **Projects** - Work initiatives and assignments

#### Operational Entities
- **Attendance** - Daily check-in/check-out records
- **Leave Requests** - Vacation, sick leave, personal time
- **Performance Reviews** - Employee evaluations
- **Salary History** - Compensation tracking
- **Audit Logs** - Change tracking

### Relationship Examples

#### One-to-One (1:1)
```sql
-- Employee ↔ Employee Profile
employees.id ← employee_profiles.employee_id

-- Department ↔ Department Head
departments.head_employee_id → employees.id
```

#### One-to-Many (1:M)
```sql
-- Department → Employees
departments.id ← employees.department_id

-- Manager → Direct Reports
employees.id ← employees.manager_id (self-referencing)

-- Employee → Attendance Records
employees.id ← attendance.employee_id
```

#### Many-to-Many (M:M)
```sql
-- Employees ↔ Skills (through employee_skills)
employees.id ← employee_skills.employee_id
skills.id ← employee_skills.skill_id

-- Employees ↔ Projects (through project_assignments)
employees.id ← project_assignments.employee_id
projects.id ← project_assignments.project_id
```

## 📁 Directory Structure

Each project includes a `database/` folder with:

```
project-name/
├── database/
│   ├── docker-compose.yml      # PostgreSQL + pgAdmin containers
│   ├── pgadmin-servers.json   # Auto-configured database connection
│   ├── start-db.sh           # Start database environment
│   ├── stop-db.sh            # Stop database environment  
│   ├── reset-db.sh           # Reset database (delete all data)
│   ├── status-db.sh          # Check database status
│   ├── README.md             # Detailed usage instructions
│   ├── schema/               # Database structure
│   │   ├── 01-init.sql      # Extensions and functions
│   │   ├── 02-tables.sql    # Table definitions
│   │   └── 03-indexes.sql   # Performance indexes
│   ├── seed-data/           # Sample data
│   │   ├── 01-departments.sql
│   │   ├── 02-employees.sql
│   │   ├── 03-employee-profiles.sql
│   │   ├── 04-skills-and-employee-skills.sql
│   │   ├── 05-projects-and-assignments.sql
│   │   └── 06-attendance-and-leaves.sql
│   └── db-data-files/       # Persistent data storage
└── ...
```

## 🚀 Quick Start

### 1. Start Database Environment

```bash
cd your-project/database
./start-db.sh
```

This will:
- Start PostgreSQL and pgAdmin containers
- Apply schema and seed data automatically
- Open pgAdmin web interface

### 2. Access Database

**PostgreSQL Direct Connection:**
- Host: `localhost`
- Port: `5432`
- Database: `devdb`
- Username: `devuser`
- Password: `devpass123`

**pgAdmin Web Interface:**
- URL: http://localhost:8080
- Email: `admin@dev.local`
- Password: `admin123`

### 3. Verify Setup

```sql
-- Check tables
\dt

-- Sample employee query
SELECT e.first_name, e.last_name, d.name as department 
FROM employees e 
JOIN departments d ON e.department_id = d.id 
LIMIT 5;
```

## 🛠️ Technology Integration

### Java/Spring Boot

**Dependencies (add to pom.xml):**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
</dependency>
```

**Configuration (application.properties):**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/devdb
spring.datasource.username=devuser
spring.datasource.password=devpass123
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=validate
```

**Sample Entity:**
```java
@Entity
@Table(name = "employees")
public class Employee {
    @Id
    private UUID id;
    
    @Column(name = "first_name")
    private String firstName;
    
    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;
    
    // ... getters/setters
}
```

### Node.js/Express

**Dependencies:**
```bash
npm install pg sequelize sequelize-cli
```

**Database Configuration:**
```javascript
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize({
    dialect: 'postgres',
    host: 'localhost',
    port: 5432,
    database: 'devdb',
    username: 'devuser',
    password: 'devpass123'
});
```

**Sample Model:**
```javascript
const Employee = sequelize.define('Employee', {
    id: {
        type: DataTypes.UUID,
        primaryKey: true
    },
    firstName: {
        type: DataTypes.STRING,
        field: 'first_name'
    }
}, {
    tableName: 'employees'
});
```

### Python/Django

**Settings:**
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'devdb',
        'USER': 'devuser',
        'PASSWORD': 'devpass123',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

**Sample Model:**
```python
from django.db import models
import uuid

class Employee(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    first_name = models.CharField(max_length=50)
    department = models.ForeignKey('Department', on_delete=models.CASCADE)
    
    class Meta:
        db_table = 'employees'
        managed = False  # Don't let Django manage the table
```

### Python/FastAPI + SQLAlchemy

**Dependencies:**
```bash
pip install fastapi sqlalchemy psycopg2-binary
```

**Database Setup:**
```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://devuser:devpass123@localhost:5432/devdb"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
```

## 📊 Sample Queries & Use Cases

### 1. Employee Hierarchy
```sql
-- Get employee with their manager
SELECT 
    e.first_name || ' ' || e.last_name as employee,
    m.first_name || ' ' || m.last_name as manager,
    d.name as department
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id
JOIN departments d ON e.department_id = d.id;
```

### 2. Project Assignments
```sql
-- Current active project assignments
SELECT 
    e.first_name || ' ' || e.last_name as employee,
    p.name as project,
    pa.role,
    pa.hours_allocated
FROM project_assignments pa
JOIN employees e ON pa.employee_id = e.id
JOIN projects p ON pa.project_id = p.id
WHERE pa.is_active = true
ORDER BY p.name, e.last_name;
```

### 3. Skills Matrix
```sql
-- Employee skills proficiency
SELECT 
    e.first_name || ' ' || e.last_name as employee,
    s.name as skill,
    es.proficiency_level,
    es.years_experience,
    es.certified
FROM employee_skills es
JOIN employees e ON es.employee_id = e.id
JOIN skills s ON es.skill_id = s.id
WHERE es.proficiency_level IN ('expert', 'advanced')
ORDER BY e.last_name, s.category;
```

### 4. Attendance Analytics
```sql
-- Monthly attendance summary
SELECT 
    e.first_name || ' ' || e.last_name as employee,
    COUNT(*) as days_present,
    AVG(a.total_hours) as avg_hours_per_day,
    COUNT(CASE WHEN a.status = 'late' THEN 1 END) as late_days
FROM attendance a
JOIN employees e ON a.employee_id = e.id
WHERE a.date >= '2024-10-01' AND a.date < '2024-11-01'
GROUP BY e.id, e.first_name, e.last_name
ORDER BY days_present DESC;
```

## 🔧 Development Workflows

### 1. API Development Workflow
1. Start database: `./start-db.sh`
2. Connect your application to PostgreSQL
3. Use existing schema (no migrations needed)
4. Build REST endpoints for employee management
5. Test with pgAdmin or SQL tools

### 2. Full-Stack Development
1. Backend: Build API using the employee schema
2. Frontend: Create admin interfaces for:
   - Employee management
   - Project assignments
   - Attendance tracking
   - Performance reviews

### 3. Learning RDBMS Concepts
1. Study the schema relationships
2. Practice complex JOIN queries
3. Understand foreign key constraints
4. Explore performance with indexes

## 🧪 Testing & Development

### Sample REST Endpoints

**Employee Management:**
- `GET /api/employees` - List all employees
- `GET /api/employees/{id}` - Get employee details
- `POST /api/employees` - Create new employee
- `PUT /api/employees/{id}` - Update employee
- `DELETE /api/employees/{id}` - Remove employee

**Department Operations:**
- `GET /api/departments` - List departments
- `GET /api/departments/{id}/employees` - Department staff

**Project Management:**
- `GET /api/projects` - Active projects
- `POST /api/projects/{id}/assign` - Assign employee to project

### Development Data

The seed data includes:
- **10 departments** across different business functions
- **20 employees** with realistic hierarchy
- **15 employee profiles** with skills and certifications
- **Multiple projects** with team assignments
- **Attendance records** for the current month
- **Leave requests** in various states

## 🔒 Security & Best Practices

### Development Environment
- Database credentials are simple for development
- pgAdmin runs without SSL
- All ports are exposed locally
- **DO NOT use in production**

### Production Considerations
- Change all default passwords
- Enable SSL/TLS encryption
- Use environment variables for credentials
- Implement proper authentication
- Add connection pooling
- Set up regular backups

## 🚀 Advanced Features

### 1. Full-Text Search
```sql
-- Search employees by name or job title
SELECT * FROM employees 
WHERE to_tsvector('english', first_name || ' ' || last_name || ' ' || job_title) 
@@ plainto_tsquery('english', 'software engineer');
```

### 2. JSON Data Queries
```sql
-- Query employee address data
SELECT first_name, last_name, address->>'city' as city 
FROM employees 
WHERE address->>'state' = 'CA';
```

### 3. Audit Trail
```sql
-- View recent changes
SELECT table_name, action, changed_by, created_at 
FROM audit_logs 
ORDER BY created_at DESC 
LIMIT 10;
```

## 📚 Learning Resources

### RDBMS Concepts Demonstrated
1. **Primary Keys**: UUID-based keys for distributed systems
2. **Foreign Keys**: Referential integrity across tables
3. **Self-Referencing**: Manager-employee hierarchy
4. **Junction Tables**: Many-to-many relationships
5. **Check Constraints**: Data validation rules
6. **Triggers**: Automatic timestamp updates
7. **Indexes**: Performance optimization
8. **JSONB**: Semi-structured data storage

### Practice Exercises
1. Add new relationship types (e.g., employee certifications)
2. Create views for common queries
3. Implement stored procedures
4. Add data validation triggers
5. Design reports with complex aggregations

## 🤝 Contributing

To extend the database schema:
1. Add new tables to `schema/04-new-tables.sql`
2. Create corresponding seed data
3. Update indexes if needed
4. Test with multiple projects
5. Update documentation

## 📞 Support

Each project's `database/README.md` contains detailed setup instructions. For troubleshooting:
1. Check container status: `./status-db.sh`
2. View logs: `docker-compose logs`
3. Reset if needed: `./reset-db.sh`
4. Verify port availability (5432, 8080)

---

This database environment provides a solid foundation for learning full-stack development with real-world complexity while maintaining simplicity for educational purposes.