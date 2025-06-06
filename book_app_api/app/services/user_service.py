from app.repositories.user_repository import UserRepository
from app.dto.user_dto import UserLoginDto, UserUpdateDto
from app.utils.jwt_utils import create_access_token
from app.utils.password_utils import hash_password, verify_password
from sqlalchemy.orm import Session
from app.mappers.user_mapper import to_entity,to_dto
import base64


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
        
        
    def delete_user(self, user_id: int):
        user = self.user_repository.get_user_by_id(user_id)
        if not user:
            raise ValueError("User not found")
        try:
            self.user_repository.delete_user(user)
        except Exception as e:
            raise ValueError(f"user delete failed: {e}")
        
    def edit_user(self, user_id: int, user_update_dto: UserUpdateDto):
        user = self.user_repository.get_user_by_id(user_id)
        if not user:
            raise ValueError("User not found")

        if user_update_dto.username:
            user.username = user_update_dto.username

        if user_update_dto.profile_picture_base64:
            try:
                user.profile_picture = base64.b64decode(user_update_dto.profile_picture_base64)
            except Exception as e:
                raise ValueError("Invalid base64 image data") from e

        try:
            updated_user = self.user_repository.edit_user(user_id, user)
            return to_dto(updated_user)
        except Exception as e:
            raise ValueError(f"user update failed: {e}")

    def register_user(self, user_create_dto):
        existing_user = self.user_repository.get_user_by_email(user_create_dto.email)
        if existing_user:
            raise ValueError("Email already registered")
        user_create_dto.password = hash_password(user_create_dto.password)
        return self.add_user(user_create_dto)

    def login_user(self, login_dto: UserLoginDto):
        user = self.user_repository.get_user_by_email(login_dto.email)
        if not user or not verify_password(login_dto.password, user.password):
            raise ValueError("Invalid credentials")
        return create_access_token({"sub": str(user.id)})