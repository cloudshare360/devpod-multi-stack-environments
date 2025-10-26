from sqlalchemy.orm import Session
from typing import List, Optional
from .models import UserTable, UserCreate, UserUpdate


class UserCRUD:
    """CRUD operations for User model"""
    
    def get_user(self, db: Session, user_id: int) -> Optional[UserTable]:
        """Get user by ID"""
        return db.query(UserTable).filter(UserTable.id == user_id).first()
    
    def get_user_by_email(self, db: Session, email: str) -> Optional[UserTable]:
        """Get user by email"""
        return db.query(UserTable).filter(UserTable.email == email).first()
    
    def get_users(self, db: Session, skip: int = 0, limit: int = 100) -> List[UserTable]:
        """Get users with pagination"""
        return db.query(UserTable).offset(skip).limit(limit).all()
    
    def create_user(self, db: Session, user: UserCreate) -> UserTable:
        """Create a new user"""
        db_user = UserTable(
            name=user.name,
            email=user.email,
            phone=user.phone,
            bio=user.bio
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user
    
    def update_user(self, db: Session, user_id: int, user: UserUpdate) -> Optional[UserTable]:
        """Update user by ID"""
        db_user = self.get_user(db, user_id)
        if db_user:
            update_data = user.dict(exclude_unset=True)
            for key, value in update_data.items():
                setattr(db_user, key, value)
            db.commit()
            db.refresh(db_user)
        return db_user
    
    def delete_user(self, db: Session, user_id: int) -> bool:
        """Delete user by ID"""
        db_user = self.get_user(db, user_id)
        if db_user:
            db.delete(db_user)
            db.commit()
            return True
        return False
    
    def search_users(self, db: Session, search_term: str) -> List[UserTable]:
        """Search users by name or email"""
        return db.query(UserTable).filter(
            (UserTable.name.contains(search_term)) |
            (UserTable.email.contains(search_term))
        ).all()