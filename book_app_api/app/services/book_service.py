from app.repositories.book_repository import BookRepository
from app.dto.book_dto import BookDto
from app.mappers.book_mapper import to_book_cover_dto, to_dto, to_entity
from app.dto.book_dto import BookCoverDto
from app.entities.book import Book
from app.dto.book_dto import BookCreateDto
from sqlalchemy.orm import Session
from typing import List, Optional

class BookService:
    def __init__(self, db: Session):
        self.db = db
        self.book_repository = BookRepository(db)

    def get_all_books(self) -> List[BookDto]:
        books = self.book_repository.get_all_books()
        return [to_dto(book) for book in books]

    def get_book_by_id(self, book_id: int) -> Optional[BookDto]:
        book = self.book_repository.get_book_by_id(book_id)
        if book:
            return to_dto(book)
        return None
    
    def get_book_covers_with_titles(self) -> List[BookCoverDto]:
        books = self.book_repository.get_all_books()
        return [to_book_cover_dto(book) for book in books]
    
    def add_book(self, book_create_dto: BookCreateDto) -> BookDto:
        book = to_entity(book_create_dto)
        try:
            saved_book = self.book_repository.add_book(book)
            return to_dto(saved_book)
        except Exception as e:
            raise ValueError(f"book save failed: {e}")
        
    def get_book_by_title_and_author(self, title: str, author: str) -> Optional[BookDto]:
        book = self.book_repository.get_book_by_title_and_author(title, author)
        if book:
            return to_dto(book)
        return None
        