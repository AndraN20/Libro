from typing import List
from fastapi import UploadFile
import fitz  # PyMuPDF library for PDF processing

class ConversionService:
    def __init__(self):
        pass

    def convert(self, file: UploadFile) -> str:
        contents = file.file.read()

        doc = fitz.open(stream=contents, filetype="pdf")

        text_parts: List[str] = []

        for page_num in range(min(3, len(doc))):
            page = doc.load_page(page_num)
            text = page.get_text()
            text_parts.append(text)

        return "\n--- Page Break ---\n".join(text_parts)