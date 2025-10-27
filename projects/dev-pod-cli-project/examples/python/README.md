# DevPod Python FastAPI Example

This example demonstrates a FastAPI application running in a DevPod environment.

## Features

- **FastAPI Web Framework**: Modern, fast Python web framework
- **RESTful API**: Complete CRUD operations for items
- **Automatic Documentation**: Interactive API docs with Swagger UI
- **Data Validation**: Pydantic models for request/response validation
- **Testing**: Comprehensive test suite with pytest
- **CORS Support**: Cross-origin resource sharing enabled

## Quick Start

1. **Install Dependencies**:
   ```bash
   cd examples/python
   pip install -r requirements.txt
   ```

2. **Run the Application**:
   ```bash
   python main.py
   ```
   
   Or using uvicorn directly:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

3. **Access the Application**:
   - API: http://localhost:8000
   - Interactive Docs: http://localhost:8000/docs
   - Alternative Docs: http://localhost:8000/redoc

## API Endpoints

### Basic Endpoints
- `GET /` - Welcome message and API info
- `GET /health` - Health check endpoint
- `GET /stats` - API usage statistics

### Item Management
- `GET /items` - List all items
- `GET /items/{id}` - Get specific item
- `POST /items` - Create new item
- `PUT /items/{id}` - Update existing item
- `DELETE /items/{id}` - Delete item

## Example Usage

### Create an Item
```bash
curl -X POST "http://localhost:8000/items" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "DevPod Laptop",
    "description": "High-performance laptop for development",
    "price": 1299.99,
    "in_stock": true
  }'
```

### Get All Items
```bash
curl http://localhost:8000/items
```

### Get Statistics
```bash
curl http://localhost:8000/stats
```

## Running Tests

```bash
# Install test dependencies (already in requirements.txt)
pip install pytest pytest-asyncio httpx

# Run all tests
pytest

# Run with verbose output
pytest -v

# Run with coverage
pytest --cov=main test_main.py
```

## Data Model

The API uses the following data structure for items:

```python
{
  "id": 1,
  "name": "Product Name",
  "description": "Product description",
  "price": 29.99,
  "in_stock": true,
  "created_at": "2024-01-01T12:00:00"
}
```

## Development Features

- **Auto-reload**: Changes are automatically detected and applied
- **Interactive Debugging**: Use the integrated debugger in VS Code
- **Type Hints**: Full type annotation support
- **Async Support**: Asynchronous request handling
- **Validation**: Automatic request/response validation with Pydantic

## Production Considerations

For production deployment, consider:

1. **Database Integration**: Replace in-memory storage with PostgreSQL/MySQL
2. **Authentication**: Add JWT or OAuth2 authentication
3. **Rate Limiting**: Implement API rate limiting
4. **Logging**: Add structured logging with loguru or structlog
5. **Monitoring**: Add metrics and health checks
6. **Security**: Implement HTTPS and security headers

## Learn More

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [Uvicorn Documentation](https://www.uvicorn.org/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)