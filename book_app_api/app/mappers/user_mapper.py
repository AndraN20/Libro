
import base64
from app.entities.user import User
from app.dto.user_dto import UserCreateDto, UserDto, UserUpdateDto


def to_entity(user_create_dto: UserCreateDto) -> User:
    return User(
        username = user_create_dto.username,
        email = user_create_dto.email,
        password = user_create_dto.password,
        profile_picture = base64.b64decode(user_create_dto.profile_picture_base64) if user_create_dto.profile_picture_base64 else None
    )

def to_dto(user: User) -> UserDto:
    return UserDto(
        id = user.id,
        username = user.username,
        email = user.email,
        password = user.password,
        profile_picture_base64 = base64.b64encode(user.profile_picture).decode('utf-8') if user.profile_picture else None
    )
