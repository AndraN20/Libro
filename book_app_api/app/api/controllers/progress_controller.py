from app.core.security import get_current_user
from app.dto.progress_dto import ProgressCreateDto, ProgressDto, ProgressUpdateDto
from app.services.progress_service import ProgressService
from app.core.database_config import get_db
from app.entities.user import User
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

router = APIRouter(
    dependencies=[Depends(get_current_user)]
)

def get_progress_service(db: Session = Depends(get_db)) -> ProgressService:
    return ProgressService(db)

@router.get("/progress/{book_id}", response_model=ProgressDto)
def get_user_progress_for_book(
    book_id: int,
    current_user: User = Depends(get_current_user),
    progress_service: ProgressService = Depends(get_progress_service),
):
    try:
        return progress_service.get_progress_by_user_and_book(
            user_id=current_user.id,
            book_id=book_id,
        )
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.post("/progress/{book_id}", response_model=ProgressDto)
def add_progress( book_id: int, progressCreateDto:ProgressCreateDto ,progress_service: ProgressService = Depends(get_progress_service), current_user: User = Depends(get_current_user)):
    try:
        print(f"progress percentage: {progressCreateDto.percentage}")
        return progress_service.add_progress(progressCreateDto, book_id, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    
@router.patch("/progress/{book_id}", response_model=ProgressDto)
def edit_progress( book_id: int, progress_update_dto: ProgressUpdateDto, progress_service: ProgressService = Depends(get_progress_service), current_user: User = Depends(get_current_user)):
    try:
        return progress_service.edit_progress(current_user.id, book_id, progress_update_dto)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    
@router.delete("/progress/{book_id}")
def delete_progress( book_id: int, progress_service: ProgressService = Depends(get_progress_service), current_user: User = Depends(get_current_user)):
    try:
        progress_service.delete_progress(current_user.id, book_id)
        return {"message": "progress deleted successfully"}
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    
    