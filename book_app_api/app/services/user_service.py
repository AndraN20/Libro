from app.repositories.user_repository import UserRepository
from app.dto.user_dto import UserUpdateDto
from sqlalchemy.orm import Session
from app.mappers.user_mapper import to_entity,to_dto

class UserService:
    def __init__(self,db:Session):
        self.db = db
        self.user_repository = UserRepository(db)

    
    def get_user_by_id(self, user_id: int):
        user = self.user_repository.get_user_by_id(user_id)
        if user:
            return to_dto(user)
        return None
    
    def add_user(self, user_create_dto):
        user = to_entity(user_create_dto)
        try:
            saved_user = self.user_repository.add_user(user)
            return to_dto(saved_user)
        except Exception as e:
            raise ValueError(f"user save failed: {e}")
        
    def edit_user(self, user_id: int, user_update_dto:UserUpdateDto):
        user_update = user_update_dto.dict(exclude_unset=True)
        try:
            updated_user = self.user_repository.edit_user(user_id, user_update)
            return to_dto(updated_user)
        except Exception as e:
            raise ValueError(f"user update failed: {e}")
        
    def delete_user(self, user_id: int):
        user = self.user_repository.get_user_by_id(user_id)
        if not user:
            raise ValueError("User not found")
        try:
            self.user_repository.delete_user(user)
        except Exception as e:
            raise ValueError(f"user delete failed: {e}")