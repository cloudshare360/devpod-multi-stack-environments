import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import get_db, Base

# Test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)


@pytest.fixture(scope="module")
def setup_database():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)


def test_welcome_endpoint(setup_database):
    """Test the welcome endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "Welcome to Python 3 DevPod API" in data["message"]
    assert data["framework"] == "FastAPI"
    assert "version" in data


def test_health_endpoint(setup_database):
    """Test the health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "OK"
    assert data["service"] == "Python 3 API"
    assert "system" in data


def test_create_user(setup_database):
    """Test creating a new user"""
    user_data = {
        "name": "Test User",
        "email": "test@example.com",
        "phone": "+1234567890",
        "bio": "Test user biography"
    }
    response = client.post("/api/users", json=user_data)
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == user_data["name"]
    assert data["email"] == user_data["email"]
    assert "id" in data


def test_get_users(setup_database):
    """Test getting all users"""
    response = client.get("/api/users")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)


def test_get_user_by_id(setup_database):
    """Test getting user by ID"""
    # First create a user
    user_data = {
        "name": "Test User 2",
        "email": "test2@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Then get the user
    response = client.get(f"/api/users/{user_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == user_id
    assert data["name"] == user_data["name"]


def test_update_user(setup_database):
    """Test updating a user"""
    # First create a user
    user_data = {
        "name": "Test User 3",
        "email": "test3@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Update the user
    update_data = {"name": "Updated User 3"}
    response = client.put(f"/api/users/{user_id}", json=update_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Updated User 3"


def test_delete_user(setup_database):
    """Test deleting a user"""
    # First create a user
    user_data = {
        "name": "Test User 4",
        "email": "test4@example.com"
    }
    create_response = client.post("/api/users", json=user_data)
    user_id = create_response.json()["id"]
    
    # Delete the user
    response = client.delete(f"/api/users/{user_id}")
    assert response.status_code == 200
    
    # Verify user is deleted
    get_response = client.get(f"/api/users/{user_id}")
    assert get_response.status_code == 404


def test_create_user_duplicate_email(setup_database):
    """Test creating user with duplicate email"""
    user_data = {
        "name": "Test User 5",
        "email": "test5@example.com"
    }
    # Create first user
    client.post("/api/users", json=user_data)
    
    # Try to create user with same email
    response = client.post("/api/users", json=user_data)
    assert response.status_code == 400
    assert "Email already registered" in response.json()["detail"]


def test_get_nonexistent_user(setup_database):
    """Test getting non-existent user"""
    response = client.get("/api/users/99999")
    assert response.status_code == 404
    assert "User not found" in response.json()["detail"]