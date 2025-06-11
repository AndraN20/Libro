import base64
import io
from typing import List
import uuid
from app.utils.conversion_utils.epub_builder import add_cover
from app.utils.conversion_utils.parser import pdf_to_epub_chapters
from app.dto.book_dto import BookCreateDto
from app.services.book_service import BookService
from fastapi import UploadFile
from ebooklib import epub
import fitz  
from io import BytesIO
from PIL import Image

class ConversionService:
    def __init__(self, book_service:BookService):
        self.book_service = book_service
    def convert(self, file: UploadFile,user_id:int) -> tuple[BytesIO, int]:
        contents = file.file.read()

        doc = fitz.open(stream=contents, filetype="pdf")

        book = epub.EpubBook()

        book.set_identifier(str(uuid.uuid4()))
        book.set_title(file.filename or "Unknown Title")
        book.set_language("en")

        chapters, toc = pdf_to_epub_chapters(doc)
        for item in chapters:
            book.add_item(item)

        book.toc = toc
        has_cover,cover_data = add_cover(doc,book)
        if has_cover:
            book.spine = ['cover','nav'] + chapters
        book.add_item(epub.EpubNcx())
        book.add_item(epub.EpubNav())

        book_dto = BookCreateDto(
            title=file.filename or "Unknown Title",
            author="Unknown",
            genre=None,
            description=None,
            cover_data=cover_data,
            date=None,
            language="en",
            book_url=None,  
            user_id=user_id
        )
        book_created = self.book_service.add_book(book_dto)

        buffer = BytesIO()
        epub.write_epub(buffer, book)
        buffer.seek(0)

        return buffer, book_created.id