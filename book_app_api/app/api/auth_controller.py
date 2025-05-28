from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.dto.user_dto import UserCreateDto, UserLoginDto, UserDto
from app.services.user_service import UserService
from app.core.database_config import get_db

router = APIRouter()

def get_user_service(db: Session = Depends(get_db)) -> UserService:
    return UserService(db)

@router.post("/register", response_model=UserDto)
async def register(user_dto: UserCreateDto,user_service: UserService = Depends(get_user_service)):
    try:
        return user_service.register_user(user_dto)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login")
def login(login_dto: UserLoginDto, user_service: UserService = Depends(get_user_service)):
    try:
        token = user_service.login_user(login_dto)
        print(f"Generated token: {token}")  
        return {"access_token": token, "token_type": "bearer"}
        
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))

