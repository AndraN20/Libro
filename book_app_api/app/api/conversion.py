from http.client import HTTPException
from app.services.conversion.pdf_conversion_service import ConversionService
from fastapi import APIRouter, Depends, UploadFile, File
from fastapi.responses import FileResponse, JSONResponse

router = APIRouter()

def get_conversion_service() -> ConversionService:
    return ConversionService()

@router.post("/convert")
def convert_pdf_to_txt(file: UploadFile = File(...), conversion_service: ConversionService = Depends(get_conversion_service)):
    if file.content_type != "application/pdf":
            raise HTTPException(status_code=400, detail="file must be a PDF")
    
    text = conversion_service.convert(file)
    return JSONResponse(content={"text": text[:1000]})

    # epub_path = conversion_service.convert(file)

    # return FileResponse(
    #         path=epub_path,
    #         filename="converted.epub",
    #         media_type="application/epub+zip")

