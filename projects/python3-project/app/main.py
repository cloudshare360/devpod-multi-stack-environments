from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from datetime import datetime
import psutil
import sys
from typing import List, Optional

from .models import User, UserCreate, UserUpdate
from .database import get_db, SessionLocal
from .crud import UserCRUD

# Create FastAPI application
app = FastAPI(
    title="Python 3 DevPod API",
    description="A FastAPI application configured for DevPod development",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize CRUD
user_crud = UserCRUD()


@app.get("/")
async def welcome():
    """Welcome endpoint with API information"""
    return {
        "message": "🚀 Welcome to Python 3 DevPod API!",
        "timestamp": datetime.now().isoformat(),
        "framework": "FastAPI",
        "python_version": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        "version": "1.0.0",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint with system information"""
    memory = psutil.virtual_memory()
    cpu_percent = psutil.cpu_percent(interval=1)
    
    return {
        "status": "OK",
        "service": "Python 3 API",
        "timestamp": datetime.now().isoformat(),
        "system": {
            "python_version": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
            "cpu_percent": cpu_percent,
            "memory": {
                "total": memory.total,
                "available": memory.available,
                "percent": memory.percent,
                "used": memory.used
            }
        }
    }


@app.get("/api/users", response_model=List[User])
async def get_users(skip: int = 0, limit: int = 100, db: SessionLocal = Depends(get_db)):
    """Get all users with pagination"""
    users = user_crud.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/api/users/{user_id}", response_model=User)
async def get_user(user_id: int, db: SessionLocal = Depends(get_db)):
    """Get user by ID"""
    user = user_crud.get_user(db, user_id=user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.post("/api/users", response_model=User, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate, db: SessionLocal = Depends(get_db)):
    """Create a new user"""
    # Check if email already exists
    existing_user = user_crud.get_user_by_email(db, email=user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    new_user = user_crud.create_user(db=db, user=user)
    return new_user


@app.put("/api/users/{user_id}", response_model=User)
async def update_user(user_id: int, user: UserUpdate, db: SessionLocal = Depends(get_db)):
    """Update user by ID"""
    existing_user = user_crud.get_user(db, user_id=user_id)
    if existing_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    updated_user = user_crud.update_user(db=db, user_id=user_id, user=user)
    return updated_user


@app.delete("/api/users/{user_id}")
async def delete_user(user_id: int, db: SessionLocal = Depends(get_db)):
    """Delete user by ID"""
    user = user_crud.get_user(db, user_id=user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    user_crud.delete_user(db=db, user_id=user_id)
    return {"message": "User deleted successfully", "timestamp": datetime.now().isoformat()}


@app.get("/api/users/search/{email}")
async def search_user_by_email(email: str, db: SessionLocal = Depends(get_db)):
    """Search user by email"""
    user = user_crud.get_user_by_email(db, email=email)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user


# Error handlers
@app.exception_handler(404)
async def not_found_handler(request, exc):
    return JSONResponse(
        status_code=404,
        content={
            "error": "Route not found",
            "path": str(request.url.path),
            "method": request.method,
            "timestamp": datetime.now().isoformat()
        }
    )


@app.exception_handler(500)
async def internal_error_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "message": "Something went wrong!",
            "timestamp": datetime.now().isoformat()
        }
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)