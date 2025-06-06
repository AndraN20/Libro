from app.core.security import get_current_user
from app.dto.user_dto import UserCreateDto, UserDto, UserUpdateDto
from app.services.user_service import UserService
from app.core.database_config import get_db
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)

def get_user_service(db: Session = Depends(get_db)) -> UserService:
    return UserService(db)

@router.get("/users/{user_id}", response_model=UserDto)
def get_user_by_id(user_id: int, user_service: UserService = Depends(get_user_service)):
    user = user_service.get_user_by_id(user_id)
    if user:
        return user
    else:
        raise HTTPException(status_code=404, detail="User not found")
    
@router.post("/users", response_model=UserDto)
def add_user(user_create_dto: UserCreateDto, user_service: UserService = Depends(get_user_service)):
    return user_service.add_user(user_create_dto)

@router.patch("/users/{user_id}", response_model=UserDto)
def edit_user(user_id: int, user_update_dto: UserUpdateDto, user_service: UserService = Depends(get_user_service)):
    edited = user_service.edit_user(user_id, user_update_dto)
    return edited

@router.delete("/users/{user_id}")
def delete_user(user_id: int, user_service: UserService = Depends(get_user_service)):
    user_service.delete_user(user_id)
    return {"message": "user deleted successfully"}

