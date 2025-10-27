import pytest
import httpx
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root_endpoint():
    """Test the root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert "DevPod Python FastAPI Example" in data["message"]
    assert data["framework"] == "FastAPI"

def test_health_check():
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data

def test_create_and_get_item():
    """Test creating and retrieving an item"""
    # Create an item
    item_data = {
        "name": "Test Item",
        "description": "A test item for DevPod",
        "price": 29.99,
        "in_stock": True
    }
    
    response = client.post("/items", json=item_data)
    assert response.status_code == 200
    created_item = response.json()
    assert created_item["name"] == item_data["name"]
    assert created_item["price"] == item_data["price"]
    assert "id" in created_item
    assert "created_at" in created_item
    
    # Get the item
    item_id = created_item["id"]
    response = client.get(f"/items/{item_id}")
    assert response.status_code == 200
    retrieved_item = response.json()
    assert retrieved_item["id"] == item_id
    assert retrieved_item["name"] == item_data["name"]

def test_get_all_items():
    """Test getting all items"""
    response = client.get("/items")
    assert response.status_code == 200
    items = response.json()
    assert isinstance(items, list)

def test_update_item():
    """Test updating an item"""
    # First create an item
    item_data = {
        "name": "Update Test Item",
        "description": "Item to be updated",
        "price": 19.99,
        "in_stock": True
    }
    
    response = client.post("/items", json=item_data)
    created_item = response.json()
    item_id = created_item["id"]
    
    # Update the item
    updated_data = {
        "name": "Updated Item",
        "description": "This item has been updated",
        "price": 39.99,
        "in_stock": False
    }
    
    response = client.put(f"/items/{item_id}", json=updated_data)
    assert response.status_code == 200
    updated_item = response.json()
    assert updated_item["name"] == updated_data["name"]
    assert updated_item["price"] == updated_data["price"]
    assert updated_item["in_stock"] == updated_data["in_stock"]

def test_delete_item():
    """Test deleting an item"""
    # First create an item
    item_data = {
        "name": "Delete Test Item",
        "description": "Item to be deleted",
        "price": 9.99,
        "in_stock": True
    }
    
    response = client.post("/items", json=item_data)
    created_item = response.json()
    item_id = created_item["id"]
    
    # Delete the item
    response = client.delete(f"/items/{item_id}")
    assert response.status_code == 200
    delete_response = response.json()
    assert "deleted successfully" in delete_response["message"]
    
    # Verify item is deleted
    response = client.get(f"/items/{item_id}")
    assert response.status_code == 404

def test_get_stats():
    """Test getting API statistics"""
    response = client.get("/stats")
    assert response.status_code == 200
    stats = response.json()
    assert "total_items" in stats
    assert "in_stock_items" in stats
    assert "total_inventory_value" in stats
    assert isinstance(stats["total_items"], int)

def test_item_not_found():
    """Test getting non-existent item"""
    response = client.get("/items/99999")
    assert response.status_code == 404
    error = response.json()
    assert error["detail"] == "Item not found"