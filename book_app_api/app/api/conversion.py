from app.entities.user import User
from app.services.book_service import BookService
from fastapi import HTTPException
import os
from app.core.database_config import get_db
from app.core.security import get_current_user
from sqlalchemy.orm import Session
from app.services.conversion.pdf_conversion_service import ConversionService
from fastapi import APIRouter, Depends, UploadFile, File
from fastapi.responses import StreamingResponse

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)


def get_conversion_service(db: Session = Depends(get_db)) -> ConversionService:
    book_service = BookService(db)
    return ConversionService(book_service)

@router.post("/books/convert")
async def convert_pdf_to_epub(
    file: UploadFile = File(...),
    user: User = Depends(get_current_user),
    conversion_service: ConversionService = Depends(get_conversion_service),
):
    if file.content_type != "application/pdf":
        raise HTTPException(status_code=400, detail="file must be a PDF")
  
    epub_io, book_id = conversion_service.convert(file, user.id)

    output_filename = f"{book_id}.epub"
    return StreamingResponse(epub_io, media_type="application/epub+zip", headers={
        "Content-Disposition": f"attachment; filename={output_filename}"
    })

