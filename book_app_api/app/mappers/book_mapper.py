import base64
from app.dto.book_dto import BookDto
from app.entities.book import Book
from app.dto.book_dto import BookCoverDto
from app.dto.book_dto import BookCreateDto

def to_dto(book:Book) -> BookDto:
   
    return BookDto(
        id = book.id,
        title = book.title,
        author = book.author,
        date = book.date,
        genre = book.genre,
        description = book.description,
        cover_base64 = base64.b64encode(book.cover_data).decode('utf-8') if book.cover_data else None,
        language = book.language,
        book_url = book.book_url,
        user_id = book.user_id
    )

def to_entity(book_dto: BookDto) -> Book:
    return Book(
        id = book_dto.id,
        title = book_dto.title,
        author = book_dto.author,
        date = book_dto.date,
        genre = book_dto.genre,
        description = book_dto.description,
        cover_data = base64.b64decode(book_dto.cover_base64) if book_dto.coperta_base64 else None,
        language = book_dto.language,
        book_url = book_dto.book_url
    )

def to_book_cover_dto(book: Book) -> BookCoverDto:
    return BookCoverDto(
        id = book.id,
        title = book.title,
        author = book.author,
        cover_base64 = base64.b64encode(book.cover_data).decode('utf-8') if book.cover_data else None
    )

def to_entity(book_create_dto: BookCreateDto) -> Book:
    return Book(
        title = book_create_dto.title,
        author = book_create_dto.author,
        book_url = book_create_dto.book_url,
        date = book_create_dto.date,
        genre = book_create_dto.genre,
        description = book_create_dto.description,
        cover_data = book_create_dto.cover_data if book_create_dto.cover_data else None,
        language = book_create_dto.language,
    )