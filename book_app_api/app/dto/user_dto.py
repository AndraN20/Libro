from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional

class UserCreateDto(BaseModel):
    username: str
    email: EmailStr
    password: str
    model_config = ConfigDict(from_attributes=True)

class UserUpdateDto(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    profile_picture_base64 : Optional[bytes] = None
    model_config = ConfigDict(from_attributes=True)

class UserDto(BaseModel):
    id: int
    username: str
    email: EmailStr
    profile_picture_base64: Optional[bytes] = None
    model_config = ConfigDict(from_attributes=True)

class UserLoginDto(BaseModel):
    email: EmailStr
    password: str