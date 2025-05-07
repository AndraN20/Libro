from http.client import HTTPException
from app.dto.book_dto import BookCoverDto
from app.services.book_service import BookService
from app.dto.book_dto import BookDto
from fastapi import APIRouter, Depends
from app.core.database_config import get_db
from sqlalchemy.orm import Session

router = APIRouter()

def get_book_service(db: Session = Depends(get_db)) -> BookService:
    return BookService(db)

@router.get("/books", response_model=list[BookDto])
def get_books(book_service: BookService = Depends(get_book_service)):
    return book_service.get_all_books()
   
@router.get("/books/covers", response_model = list[BookCoverDto])
def get_book_covers_with_titles(book_service = Depends(get_book_service)):
    return book_service.get_book_covers_with_titles()

@router.get("/books/{book_id}", response_model=BookDto)
def get_book_by_id(book_id: int, book_service: BookService = Depends(get_book_service)):
    book = book_service.get_book_by_id(book_id)
    if book:
        return book
    else:
        raise HTTPException(status_code=404, detail="book not found")
    
