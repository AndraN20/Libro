from http.client import HTTPException
import os
from app.core.database_config import get_db
from app.core.security import get_current_user
from sqlalchemy.orm import Session
from app.services.conversion.pdf_conversion_service import ConversionService
from fastapi import APIRouter, Depends, UploadFile, File
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)

def get_conversion_service(db: Session = Depends(get_db)) -> ConversionService:
    return ConversionService(db)

@router.post("/convert")
async def convert_pdf_to_txt(file: UploadFile = File(...), conversion_service: ConversionService = Depends(get_conversion_service)):
    if file.content_type != "application/pdf":
            raise HTTPException(status_code=400, detail="file must be a PDF")
    
    epub_io = conversion_service.convert(file)

    output_filename = os.path.splitext(file.filename)[0] + ".epub"
    return StreamingResponse(epub_io, media_type="application/epub+zip", headers={
        "Content-Disposition": f"attachment; filename={output_filename}"
    })
