from app.entities.enums.annotation_type import AnnotationType
from pydantic import BaseModel, ConfigDict
from typing import Optional

class InteractionDto(BaseModel):
    id: int
    type: AnnotationType
    page_number: Optional[int] = None
    cfi: Optional[str] = None
    text: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class InteractionCreateDto(BaseModel):
    type: AnnotationType
    page_number: Optional[int] = None
    cfi: Optional[str] = None
    text: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class InteractionUpdateDto(BaseModel):
    
    type: Optional[AnnotationType] = None
    page_number: Optional[int] = None
    cfi: Optional[str] = None
    text: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)