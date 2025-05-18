from typing import List
import uuid
from app.utils.conversion_utils.epub_builder import add_cover
from app.utils.conversion_utils.parser import pdf_to_epub_chapters
from fastapi import UploadFile
from ebooklib import epub
import fitz  
from io import BytesIO

class ConversionService:
    def __init__(self):
        pass

    def convert(self, file: UploadFile) -> str:
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
        has_cover = add_cover(doc,book)
        if has_cover:
            book.spine = ['cover','nav'] + chapters
        book.add_item(epub.EpubNcx())
        book.add_item(epub.EpubNav())

        


        buffer = BytesIO()
        epub.write_epub(buffer, book)
        buffer.seek(0)

        return buffer