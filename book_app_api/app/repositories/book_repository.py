from sqlalchemy.orm import Session
from app.entities.book import Book
from typing import List, Optional

class BookRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_all_books(self) -> List[Book]:
        return self.db.query(Book).all()
    
    def get_book_by_id(self, book_id: int) -> Optional[Book]:
        return self.db.query(Book).filter(Book.id == book_id).first()
    
    def add_book(self, book: Book) -> Book:
        try:
            self.db.add(book)
            self.db.commit()
            self.db.refresh(book)
            return book
        except Exception as e:
            self.db.rollback()
            raise ValueError(f"book save failed: {e}")
        
    def get_book_by_title_and_author(self, title: str, author: str) -> Optional[Book]:
        return self.db.query(Book)\
            .filter(Book.title == title)\
            .filter(Book.author == author)\
            .first()
    
    def get_books_by_user_id(self, user_id: int) -> List[Book]:
        return self.db.query(Book)\
            .join(Book.progress)\
            .filter(Book.progress.any(user_id=user_id))\
            .all()
    
    def get_books_by_title(self, query: str) -> list[Book]:
        return self.db.query(Book).filter(Book.title.ilike(f"%{query}%")).all()

    def get_books_by_genre(self, genre: str) -> list[Book]:
        return self.db.query(Book).filter(Book.genre.ilike(f"%{genre}%")).all()

    def delete_book(self, book_id: int):
        book = self.db.query(Book).filter(Book.id == book_id).first()
        if not book:
            return None
        self.db.delete(book)
        self.db.commit()