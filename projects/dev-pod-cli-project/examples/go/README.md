# DevPod Go Gin Example

This example demonstrates a Go web API using the Gin framework with GORM for database operations, running in a DevPod environment.

## Features

- **Gin Framework**: Fast HTTP web framework for Go
- **GORM**: Go Object-Relational Mapping library
- **SQLite Database**: Lightweight database for development
- **REST API**: Complete CRUD operations for products
- **JSON Validation**: Request validation with struct tags
- **CORS Support**: Cross-origin resource sharing enabled
- **Testing**: Comprehensive test suite

## Quick Start

1. **Initialize Go Module**:
   ```bash
   cd examples/go
   go mod download
   ```

2. **Run the Application**:
   ```bash
   go run main.go
   ```
   
   Or build and run:
   ```bash
   go build -o devpod-api main.go
   ./devpod-api
   ```

3. **Access the Application**:
   - API: http://localhost:8080/api
   - Health Check: http://localhost:8080/api/health
   - Statistics: http://localhost:8080/api/stats

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
- `GET /api/products/instock` - Get in-stock products only

## Example Usage

### Create a Product
```bash
curl -X POST "http://localhost:8080/api/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "DevPod Go Server",
    "description": "High-performance Go server for microservices",
    "price": 199.99,
    "inStock": true
  }'
```

### Get All Products
```bash
curl http://localhost:8080/api/products
```

### Search Products
```bash
curl "http://localhost:8080/api/products/search?name=server"
```

### Get Statistics
```bash
curl http://localhost:8080/api/stats
```

## Running Tests

```bash
# Run all tests
go test

# Run tests with verbose output
go test -v

# Run tests with coverage
go test -cover

# Run specific test
go test -run TestCreateProduct

# Run tests with race detection
go test -race
```

## Data Model

The API uses the following Product structure:

```go
type Product struct {
    ID          uint      `json:"id"`
    Name        string    `json:"name"`
    Description string    `json:"description"`
    Price       float64   `json:"price"`
    InStock     bool      `json:"inStock"`
    CreatedAt   time.Time `json:"createdAt"`
    UpdatedAt   time.Time `json:"updatedAt"`
}
```

## Development Features

- **Hot Reload**: Use `air` for automatic rebuilding during development
- **Database Migrations**: GORM auto-migration support
- **Structured Logging**: Built-in logging with Gin
- **Validation**: Automatic JSON validation with binding tags
- **Error Handling**: Consistent error response format

## Database

The application uses SQLite for development:
- Database file: `devpod.db` (created automatically)
- Auto-migration: Tables created automatically from structs
- Sample data: Seeded on first run

## Go Commands

```bash
# Download dependencies
go mod download

# Tidy dependencies
go mod tidy

# Build application
go build -o devpod-api main.go

# Run application
go run main.go

# Format code
go fmt ./...

# Vet code
go vet ./...

# Install air for hot reload (optional)
go install github.com/cosmtrek/air@latest
air
```

## Project Structure

```
go/
├── go.mod              # Go module file
├── go.sum              # Dependency checksums
├── main.go             # Main application file
├── main_test.go        # Test file
├── devpod.db           # SQLite database (created at runtime)
└── README.md           # This file
```

## Performance Considerations

- **Connection Pooling**: GORM handles database connections efficiently
- **Middleware**: Lightweight CORS and logging middleware
- **JSON Processing**: Fast JSON marshaling/unmarshaling with Gin
- **Memory Usage**: Efficient struct-based data handling

## Production Considerations

For production deployment, consider:

1. **External Database**: Replace SQLite with PostgreSQL/MySQL
2. **Configuration**: Use environment variables for settings
3. **Logging**: Implement structured logging with logrus/zap
4. **Metrics**: Add Prometheus metrics collection
5. **Security**: Implement authentication and rate limiting
6. **Containerization**: Create optimized Docker image

## Learn More

- [Gin Documentation](https://gin-gonic.com/docs/)
- [GORM Documentation](https://gorm.io/docs/)
- [Go Testing](https://golang.org/pkg/testing/)
- [Go Best Practices](https://golang.org/doc/effective_go.html)