# DevPod Rust Warp Example

This example demonstrates a Rust web API using the Warp framework with SQLx for database operations, running in a DevPod environment.

## Features

- **Warp Framework**: Fast, composable web framework for Rust
- **SQLx**: Async SQL toolkit with compile-time checked queries
- **SQLite Database**: Lightweight database for development
- **Tokio Runtime**: Async runtime for high-performance applications
- **REST API**: Complete CRUD operations for products
- **JSON Serialization**: Serde-based JSON handling
- **CORS Support**: Cross-origin resource sharing enabled
- **UUID Support**: Type-safe unique identifiers

## Quick Start

1. **Build the Application**:
   ```bash
   cd examples/rust
   cargo build
   ```

2. **Run the Application**:
   ```bash
   cargo run
   ```
   
   Or build and run optimized:
   ```bash
   cargo build --release
   ./target/release/devpod-rust-api
   ```

3. **Access the Application**:
   - API: http://localhost:3030/api
   - Health Check: http://localhost:3030/api/health
   - Statistics: http://localhost:3030/api/stats

## API Endpoints

### Basic Endpoints
- `GET /api/` - Welcome message and API info
- `GET /api/health` - Health check endpoint
- `GET /api/stats` - API usage statistics

### Product Management
- `GET /api/products` - List all products
- `GET /api/products/{id}` - Get specific product by UUID
- `POST /api/products` - Create new product
- `PUT /api/products/{id}` - Update existing product
- `DELETE /api/products/{id}` - Delete product

### Search and Filter
- `GET /api/products/search?name={name}` - Search products by name
- `GET /api/products/instock` - Get in-stock products only

## Example Usage

### Create a Product
```bash
curl -X POST "http://localhost:3030/api/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Zero-Cost Abstraction Laptop",
    "description": "Memory-safe laptop with ownership semantics",
    "price": 1599.99,
    "inStock": true
  }'
```

### Get All Products
```bash
curl http://localhost:3030/api/products
```

### Search Products
```bash
curl "http://localhost:3030/api/products/search?name=laptop"
```

### Get Statistics
```bash
curl http://localhost:3030/api/stats
```

## Running Tests

```bash
# Run all tests
cargo test

# Run tests with output
cargo test -- --nocapture

# Run specific test
cargo test test_create_product

# Run tests with coverage (requires cargo-tarpaulin)
cargo install cargo-tarpaulin
cargo tarpaulin --out Html
```

## Data Model

The API uses the following Product structure:

```rust
#[derive(Serialize, Deserialize)]
pub struct Product {
    pub id: Uuid,
    pub name: String,
    pub description: Option<String>,
    pub price: f64,
    pub in_stock: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: Option<DateTime<Utc>>,
}
```

## Development Features

- **Compile-Time Safety**: Rust's type system prevents many runtime errors
- **Memory Safety**: No garbage collector, no memory leaks
- **Zero-Cost Abstractions**: High-level code with low-level performance
- **Async/Await**: Non-blocking I/O with Tokio
- **Pattern Matching**: Robust error handling with Result types
- **Cargo Integration**: Built-in package manager and build system

## Database

The application uses SQLite with SQLx:
- Database file: `devpod.db` (created automatically)
- Compile-time query verification with `sqlx::query!` macro
- Async database operations
- Connection pooling with SQLitePool

## Cargo Commands

```bash
# Check code without building
cargo check

# Build in debug mode
cargo build

# Build optimized release
cargo build --release

# Run application
cargo run

# Run with environment variables
RUST_LOG=debug cargo run

# Format code
cargo fmt

# Lint code
cargo clippy

# Generate documentation
cargo doc --open

# Update dependencies
cargo update
```

## Project Structure

```
rust/
├── Cargo.toml           # Project manifest and dependencies
├── src/
│   ├── main.rs         # Application entry point and routing
│   ├── models.rs       # Data structures and types
│   ├── handlers.rs     # HTTP request handlers
│   └── database.rs     # Database operations
├── devpod.db           # SQLite database (created at runtime)
└── README.md           # This file
```

## Performance Benefits

- **Zero-Cost Abstractions**: High-level code compiles to efficient machine code
- **Memory Efficiency**: No garbage collection, predictable memory usage
- **Concurrency**: Safe concurrent programming with ownership system
- **Async I/O**: Non-blocking operations with minimal overhead
- **Compile-Time Optimization**: Aggressive optimizations during compilation

## Rust-Specific Features

- **Ownership System**: Prevents data races and memory leaks at compile time
- **Pattern Matching**: Exhaustive matching with `match` expressions
- **Option/Result Types**: Explicit handling of nullable values and errors
- **Traits**: Zero-cost abstractions for shared behavior
- **Macros**: Code generation and compile-time metaprogramming

## Production Considerations

For production deployment, consider:

1. **External Database**: Replace SQLite with PostgreSQL using SQLx
2. **Configuration**: Use environment variables with `dotenv` crate
3. **Logging**: Implement structured logging with `tracing` crate
4. **Metrics**: Add Prometheus metrics with `metrics` crate
5. **Security**: Implement authentication with JWT tokens
6. **Containerization**: Create multi-stage Docker builds for small images
7. **Error Handling**: Use `anyhow` or `thiserror` for better error management

## Learn More

- [Rust Book](https://doc.rust-lang.org/book/)
- [Warp Documentation](https://docs.rs/warp/)
- [SQLx Documentation](https://docs.rs/sqlx/)
- [Tokio Documentation](https://docs.rs/tokio/)
- [Serde Documentation](https://docs.rs/serde/)