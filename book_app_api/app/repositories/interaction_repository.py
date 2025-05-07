from app.entities.enums.annotation_type import AnnotationType
from app.entities.interaction import Interaction
from sqlalchemy.orm import Session
from typing import List, Optional

class InteractionRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_interactions_by_user_and_book(self, user_id: int, book_id: int) -> Optional[List[Interaction]]:
        return self.db.query(Interaction) \
            .filter(Interaction.user_id == user_id, Interaction.book_id == book_id) \
            .all()
    
    def get_interactions_by_user_and_book_and_type(self, user_id: int, book_id: int, annotation_type: AnnotationType) -> Optional[List[Interaction]]:
        return self.db.query(Interaction) \
            .filter(Interaction.user_id == user_id, Interaction.book_id == book_id, Interaction.annotation_type == annotation_type) \
            .all()
    
    def add_interaction(self, interaction: Interaction) -> Interaction:
        self.db.add(interaction)
        self.db.commit()
        self.db.refresh(interaction)
        return interaction
    
    def edit_interaction(self, interaction_id: int, update_date:dict) -> Optional[Interaction]:
        interaction = self.db.query(Interaction).filter(Interaction.id == interaction_id).first()
        if not interaction:
            return None
        for key, value in update_date.items():
            setattr(interaction, key, value)
        self.db.commit()
        self.db.refresh(interaction)
        return interaction        
    
    def delete_interaction(self, interaction_id: int) -> None:
        interaction = self.db.query(Interaction).filter(Interaction.id == interaction_id).first()
        if not interaction:
            return None
        self.db.delete(interaction)
        self.db.commit()
    
