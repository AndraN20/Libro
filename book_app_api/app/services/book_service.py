from app.repositories.book_repository import BookRepository
from app.dto.book_dto import BookDto
from app.mappers.book_mapper import to_book_cover_dto, to_dto, to_entity
from app.dto.book_dto import BookCoverDto
from app.entities.book import Book
from app.dto.book_dto import BookCreateDto
from app.services.gcs.signed_url_service import generate_signed_url_from_full_url
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
    
    def get_books_by_user_id(self, user_id: int) -> List[BookDto]:
        books = self.book_repository.get_books_by_user_id(user_id)
        return [to_dto(book) for book in books]
        
    
    def get_books_by_genre(self, genre: str) -> list[Book]:
        if genre.lower() == "all":
            return self.book_repository.get_all_books()
        books = self.book_repository.get_books_by_genre(genre)
        return [to_dto(book) for book in books]
    
    def generate_signed_url(self, book_id: int) -> str:
        book = self.book_repository.get_book_by_id(book_id)
        if not book:
            raise ValueError("Book not found")
        return generate_signed_url_from_full_url(book.book_url)
    
    def delete_book(self, book_id: int):
        if not self.book_repository.get_book_by_id(book_id):
            raise ValueError("Book not found")
        self.book_repository.delete_book(book_id)

    def get_user_added_books_by_user_id(self, user_id: int) -> List[BookDto]:
        books = self.book_repository.get_user_added_books_by_user_id(user_id)
        return [to_dto(book) for book in books]
    
    def get_books_in_progress_by_user_id(self, user_id: int) -> List[BookDto]:
        books = self.book_repository.get_books_by_user_id(user_id)
        return [to_dto(book) for book in books if book.progress]
    