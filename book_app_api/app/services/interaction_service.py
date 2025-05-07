from typing import List, Optional
from app.dto.interaction_dto import InteractionCreateDto, InteractionDto
from app.mappers.interaction_mapper import to_entity
from app.mappers.interaction_mapper import to_dto
from app.repositories.interaction_repository import InteractionRepository
from sqlalchemy.orm import Session


class InteractionService:
    def __init__(self, db: Session):
        self.db = db
        self.interaction_repository = InteractionRepository(db)

    def get_interactions_by_user_and_book(self, user_id: int, book_id: int) -> Optional[List[InteractionDto]]:
        interactions = self.interaction_repository.get_interactions_by_user_and_book(user_id, book_id)
        if not interactions:
            return None
        return [to_dto(interaction) for interaction in interactions]
    
    def get_interactions_by_user_and_book_and_type(self, user_id: int, book_id: int, annotation_type: str) -> Optional[List[InteractionDto]]:
        interactions = self.interaction_repository.get_interactions_by_user_and_book_and_type(user_id, book_id, annotation_type)
        if not interactions:
            return None
        return [to_dto(interaction) for interaction in interactions]
    
    def add_interaction(self, interaction_create_dto: InteractionCreateDto) -> InteractionDto:
        interaction = to_entity(interaction_create_dto)
        saved_interaction = self.interaction_repository.add_interaction(interaction)
        if not saved_interaction:
            raise ValueError("interaction save failed")
        return to_dto(saved_interaction)
    
    def edit_interaction(self, interaction_id: int, interaction_update_dto: InteractionCreateDto) -> InteractionDto:
        interaction_update = interaction_update_dto.dict(exclude_unset=True)
        updated_interaction = self.interaction_repository.edit_interaction(interaction_id, interaction_update)
        if not updated_interaction:
            raise ValueError("interaction update failed")
        return to_dto(updated_interaction)
    
    def delete_interaction(self, interaction_id: int) -> None:
        interaction = self.interaction_repository.get_interaction_by_id(interaction_id)
        if not interaction:
            raise ValueError("interaction not found")
        try:
            self.interaction_repository.delete_interaction(interaction_id)
        except Exception as e:
            raise ValueError(f"interaction delete failed: {e}")