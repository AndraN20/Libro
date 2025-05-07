from app.core.database_config import get_db
from app.dto.interaction_dto import InteractionCreateDto, InteractionDto, InteractionUpdateDto
from app.entities.enums.annotation_type import AnnotationType
from app.services.interaction_service import InteractionService
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends


router = APIRouter()

def get_interaction_service(db: Session = Depends(get_db)) -> InteractionService:
    return InteractionService(db)

@router.get("/interactions/{user_id}/{book_id}", response_model=list[InteractionDto])
def get_interactions_by_user_and_book(user_id: int, book_id: int, interaction_service: InteractionService = Depends(get_interaction_service)):
    return interaction_service.get_interactions_by_user_and_book(user_id, book_id)

@router.get("/interactions/{user_id}/{book_id}/{annotation_type}", response_model=list[InteractionDto])
def get_interactions_by_user_and_book_and_type(user_id: int, book_id: int, annotation_type: AnnotationType, interaction_service: InteractionService = Depends(get_interaction_service)):
    return interaction_service.get_interactions_by_user_and_book_and_type(user_id, book_id, annotation_type)

@router.post("/interactions", response_model=InteractionDto)
def add_interaction(interaction_dto: InteractionCreateDto, interaction_service: InteractionService = Depends(get_interaction_service)):
    return interaction_service.add_interaction(interaction_dto)

@router.patch("/interactions/{interaction_id}", response_model=InteractionDto)
def edit_interaction(interaction_id: int, interaction_dto: InteractionUpdateDto, interaction_service: InteractionService = Depends(get_interaction_service)):
    return interaction_service.edit_interaction(interaction_id, interaction_dto)

@router.delete("/interactions/{interaction_id}")
def delete_interaction(interaction_id: int, interaction_service: InteractionService = Depends(get_interaction_service)):
    interaction_service.delete_interaction(interaction_id)
    return {"message": "interaction deleted successfully"}