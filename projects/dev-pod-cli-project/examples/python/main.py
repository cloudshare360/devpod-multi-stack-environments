from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
from datetime import datetime

# Initialize FastAPI app
app = FastAPI(
    title="DevPod Python API",
    description="A sample FastAPI application running in DevPod",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data models
class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    price: float
    in_stock: bool = True
    created_at: Optional[str] = None

class ItemResponse(BaseModel):
    id: int
    name: str
    description: Optional[str]
    price: float
    in_stock: bool
    created_at: str

# In-memory storage (for demo purposes)
items_db = []
next_id = 1

@app.get("/")
async def root():
    """Root endpoint with welcome message"""
    return {
        "message": "Welcome to DevPod Python FastAPI Example!",
        "timestamp": datetime.now().isoformat(),
        "environment": "DevPod Container",
        "framework": "FastAPI",
        "python_version": "3.12"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service": "DevPod Python API"
    }

@app.get("/items", response_model=List[ItemResponse])
async def get_items():
    """Get all items"""
    return items_db

@app.get("/items/{item_id}", response_model=ItemResponse)
async def get_item(item_id: int):
    """Get a specific item by ID"""
    item = next((item for item in items_db if item["id"] == item_id), None)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item

@app.post("/items", response_model=ItemResponse)
async def create_item(item: Item):
    """Create a new item"""
    global next_id
    
    new_item = {
        "id": next_id,
        "name": item.name,
        "description": item.description,
        "price": item.price,
        "in_stock": item.in_stock,
        "created_at": datetime.now().isoformat()
    }
    
    items_db.append(new_item)
    next_id += 1
    
    return new_item

@app.put("/items/{item_id}", response_model=ItemResponse)
async def update_item(item_id: int, item: Item):
    """Update an existing item"""
    existing_item = next((item for item in items_db if item["id"] == item_id), None)
    if not existing_item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    existing_item.update({
        "name": item.name,
        "description": item.description,
        "price": item.price,
        "in_stock": item.in_stock
    })
    
    return existing_item

@app.delete("/items/{item_id}")
async def delete_item(item_id: int):
    """Delete an item"""
    global items_db
    item_index = next((i for i, item in enumerate(items_db) if item["id"] == item_id), None)
    if item_index is None:
        raise HTTPException(status_code=404, detail="Item not found")
    
    deleted_item = items_db.pop(item_index)
    return {"message": f"Item '{deleted_item['name']}' deleted successfully"}

@app.get("/stats")
async def get_stats():
    """Get API statistics"""
    total_items = len(items_db)
    in_stock_items = sum(1 for item in items_db if item["in_stock"])
    total_value = sum(item["price"] for item in items_db)
    
    return {
        "total_items": total_items,
        "in_stock_items": in_stock_items,
        "out_of_stock_items": total_items - in_stock_items,
        "total_inventory_value": round(total_value, 2),
        "average_price": round(total_value / total_items, 2) if total_items > 0 else 0
    }

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )