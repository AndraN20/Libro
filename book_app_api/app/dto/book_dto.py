from pydantic import BaseModel, ConfigDict
from typing import Optional

class BookDto(BaseModel):
    id: int
    title: str
    author: str
    description: Optional[str] = None
    cover_base64: Optional[str] = None
    date: Optional[str] = None
    language: Optional[str] = None
    genre: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class BookCoverDto(BaseModel):
    id: int
    title: str
    author: str
    cover_base64: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)

class BookCreateDto(BaseModel):
    title: str
    author: str
    description: Optional[str] = None
    book_url: Optional[str] = None
    cover_data: Optional[bytes] = None
    date: Optional[str] = None
    language: Optional[str] = None
    genre: Optional[str] = None
    
    model_config = ConfigDict(from_attributes=True)