from pydantic import Field
from datetime import datetime
from app.entities.enums.status_enum import StatusEnum
from pydantic import BaseModel, ConfigDict
from typing import Optional

class ProgressUpdateDto(BaseModel):
    epub_cfi: str | None = None
    last_read_at: datetime = Field(default_factory=datetime.utcnow)
    status: StatusEnum | None = None

    model_config = ConfigDict(from_attributes=True)

class ProgressDto(BaseModel):
    book_id: int
    epub_cfi: str | None = None
    last_read_at: datetime | None = None
    status: StatusEnum

    model_config = ConfigDict(from_attributes=True)


class ProgressCreateDto(BaseModel):
    epub_cfi: str | None = None
    last_read_at: datetime | None = None
    status: StatusEnum

    model_config = ConfigDict(from_attributes=True)