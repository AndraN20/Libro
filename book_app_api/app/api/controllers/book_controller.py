from fastapi import HTTPException
from app.core.security import get_current_user
from app.dto.book_dto import BookCoverDto
from app.entities.user import User
from app.services.book_service import BookService
from app.dto.book_dto import BookDto
from fastapi import APIRouter, Depends
from app.core.database_config import get_db
from sqlalchemy.orm import Session

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)

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
    
@router.get("/books/user/{user_id}", response_model=list[BookDto])
def get_books_by_user_id(user_id: int, book_service: BookService = Depends(get_book_service)):
    books = book_service.get_books_by_user_id(user_id)
    if books:
        return books
    else:
        raise HTTPException(status_code=404, detail="no books found for this user")
    

@router.get("/books/search", response_model=list[BookDto])
def search_books_by_title(query: str, book_service: BookService = Depends(get_book_service)):
    return book_service.search_books_by_title(query)

@router.get("/books/genre/{genre}", response_model=list[BookDto])
def get_books_by_genre(genre: str, book_service: BookService = Depends(get_book_service)):
    return book_service.get_books_by_genre(genre)

@router.get("/books/{book_id}/signed-url")
def get_signed_url(book_id: int, book_service: BookService = Depends(get_book_service)):
    
    signed_url = book_service.generate_signed_url(book_id)
    return {"signed_url": signed_url}

@router.delete("/books/{book_id}")
def delete_book(book_id: int, book_service: BookService = Depends(get_book_service)):
    try:
        deleted_book = book_service.delete_book(book_id)
        return {"message": "Book deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))