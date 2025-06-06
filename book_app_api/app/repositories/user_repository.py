from app.dto.user_dto import UserUpdateDto
from sqlalchemy.orm import Session
from app.entities.user import User
from typing import List, Optional

class UserRepository:
    def __init__(self, db: Session):
        self.db = db


    def get_user_by_id(self, user_id: int) -> Optional[User]:
        return self.db.query(User).filter(User.id == user_id).first()
    
    def get_user_by_email(self, email: str) -> Optional[User]:
        return self.db.query(User).filter(User.email == email).first()

    
    def add_user(self, user: User) -> User:
        try:
            self.db.add(user)
            self.db.commit()
            self.db.refresh(user)
            return user
        except Exception as e:
            self.db.rollback()
            raise ValueError(f"user save failed: {e}")
        
    def edit_user(self, user_id: int, user: User) -> User:
        
        self.db.commit()
        self.db.refresh(user)
        return user
     
        
    def delete_user(self, user: User) -> None:
        try:
            self.db.delete(user)
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise ValueError(f"user delete failed: {e}")