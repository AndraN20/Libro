from app.entities.enums.status_enum import StatusEnum
from pydantic import BaseModel, ConfigDict
from typing import Optional

class ProgressUpdateDto(BaseModel):
    percentage: Optional[float] = None
    page: Optional[int] = None
    chapter: Optional[int] = None
    status: Optional[StatusEnum] = None

    model_config = ConfigDict(from_attributes=True)

class ProgressDto(BaseModel):
    book_id: int
    user_id: int
    percentage: Optional[float] = None
    page:  Optional[int] = None
    chapter: Optional[int] = None
    status: Optional[StatusEnum] = None

    model_config = ConfigDict(from_attributes=True)