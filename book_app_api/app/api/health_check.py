from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/health")
async def health_check():
    return JSONResponse(
        content={"status": "OK", "message": "Service is healthy"},
        status_code=200
    )