from app.core.security import get_current_user
from app.dto.progress_dto import ProgressDto, ProgressUpdateDto
from app.services.progress_service import ProgressService
from app.core.database_config import get_db
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)

def get_progress_service(db: Session = Depends(get_db)) -> ProgressService:
    return ProgressService(db)

@router.get("/progress/{user_id}/{book_id}", response_model=ProgressDto)
def get_progress_by_user_and_book(user_id: int, book_id: int, progress_service: ProgressService = Depends(get_progress_service)):
    try:
        return progress_service.get_progress_by_user_and_book(user_id, book_id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    
@router.post("/progress/{user_id}/{book_id}", response_model=ProgressDto)
def add_progress(user_id: int, book_id: int, progress_service: ProgressService = Depends(get_progress_service)):
    try:
        return progress_service.add_progress(book_id, user_id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    
@router.patch("/progress/{user_id}/{book_id}", response_model=ProgressDto)
def edit_progress(user_id: int, book_id: int, progress_update_dto: ProgressUpdateDto, progress_service: ProgressService = Depends(get_progress_service)):
    try:
        return progress_service.edit_progress(user_id, book_id, progress_update_dto)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    
@router.delete("/progress/{user_id}/{book_id}")
def delete_progress(user_id: int, book_id: int, progress_service: ProgressService = Depends(get_progress_service)):
    try:
        progress_service.delete_progress(user_id, book_id)
        return {"message": "progress deleted successfully"}
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    
    