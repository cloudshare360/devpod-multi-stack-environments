# DevPod Java Spring Boot Example

This example demonstrates a Spring Boot application with JPA/Hibernate running in a DevPod environment.

## Features

- **Spring Boot 3.2**: Latest Spring Boot framework with Java 21
- **Spring Data JPA**: Database operations with Hibernate ORM
- **H2 Database**: In-memory database for development
- **REST API**: Complete CRUD operations for products
- **Validation**: Bean validation with Jakarta Validation
- **Actuator**: Production-ready monitoring endpoints
- **DevTools**: Hot reload for rapid development

## Quick Start

1. **Build the Application**:
   ```bash
   cd examples/java
   ./mvnw clean compile
   ```

2. **Run the Application**:
   ```bash
   ./mvnw spring-boot:run
   ```
   
   Or run the JAR directly:
   ```bash
   ./mvnw package
   java -jar target/devpod-java-api-1.0.0.jar
   ```

3. **Access the Application**:
   - API: http://localhost:8080/api
   - H2 Console: http://localhost:8080/h2-console
   - Health Check: http://localhost:8080/actuator/health
   - Metrics: http://localhost:8080/actuator/metrics

## API Endpoints

### Basic Endpoints
- `GET /api/` - Welcome message and API info
- `GET /api/health` - Health check endpoint
- `GET /api/stats` - API usage statistics

### Product Management
- `GET /api/products` - List all products
- `GET /api/products/{id}` - Get specific product
- `POST /api/products` - Create new product
- `PUT /api/products/{id}` - Update existing product
- `DELETE /api/products/{id}` - Delete product

### Search and Filter
- `GET /api/products/search?name={name}` - Search products by name
- `GET /api/products/instock` - Get in-stock products
- `GET /api/products/price-range?minPrice={min}&maxPrice={max}` - Filter by price range
- `GET /api/products/affordable?maxPrice={max}` - Get affordable in-stock products

## Example Usage

### Create a Product
```bash
curl -X POST "http://localhost:8080/api/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "DevPod Workstation",
    "description": "High-end workstation for container development",
    "price": 2199.99,
    "inStock": true
  }'
```

### Get All Products
```bash
curl http://localhost:8080/api/products
```

### Search Products
```bash
curl "http://localhost:8080/api/products/search?name=laptop"
```

### Get Statistics
```bash
curl http://localhost:8080/api/stats
```

## Database Access

The application uses H2 in-memory database. Access the H2 console at:
- URL: http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:devpoddb`
- Username: `sa`
- Password: `password`

## Running Tests

```bash
# Run all tests
./mvnw test

# Run tests with coverage
./mvnw test jacoco:report

# Run specific test class
./mvnw test -Dtest=ProductControllerTest
```

## Data Model

The API uses the following Product entity:

```java
{
  "id": 1,
  "name": "Product Name",
  "description": "Product description",
  "price": 99.99,
  "inStock": true,
  "createdAt": "2024-01-01T12:00:00",
  "updatedAt": "2024-01-01T12:30:00"
}
```

## Development Features

- **Hot Reload**: Spring DevTools enables automatic restart
- **Live Reload**: Browser automatically refreshes on changes
- **Debug Support**: Full debugging support in VS Code
- **SQL Logging**: See generated SQL queries in console
- **JPA Repository**: Custom query methods and JPQL

## Configuration

Key configuration properties in `application.properties`:

```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:h2:mem:devpoddb
spring.jpa.hibernate.ddl-auto=create-drop

# Development
spring.devtools.restart.enabled=true
spring.h2.console.enabled=true
```

## Production Considerations

For production deployment, consider:

1. **External Database**: Replace H2 with PostgreSQL/MySQL
2. **Security**: Add Spring Security for authentication
3. **Caching**: Implement Redis or Ehcache
4. **Monitoring**: Use Micrometer with Prometheus
5. **Profiles**: Use Spring profiles for different environments
6. **Docker**: Containerize with multi-stage builds

## Maven Commands

```bash
# Clean and compile
./mvnw clean compile

# Run tests
./mvnw test

# Create JAR
./mvnw package

# Run application
./mvnw spring-boot:run

# Skip tests
./mvnw package -DskipTests

# Debug mode
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
```

## Learn More

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA Documentation](https://spring.io/projects/spring-data-jpa)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [H2 Database Documentation](https://h2database.com/html/main.html)