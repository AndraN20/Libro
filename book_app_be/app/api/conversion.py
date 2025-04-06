from fastapi import APIRouter
from pdfminer.high_level import extract_text
import os
from fastapi.responses import PlainTextResponse

router = APIRouter()


PDF_PATH = "test.pdf" 

@router.get("/show-pdf-text", response_class=PlainTextResponse)
async def show_pdf_text():
    try:
    
        if not os.path.exists(PDF_PATH):
            return "eroare: cale gresita catre pdf"
        
  
        text = extract_text(PDF_PATH)
        return text
        
    except Exception as e:
        return f"eroare la procesare pdf: {str(e)}"