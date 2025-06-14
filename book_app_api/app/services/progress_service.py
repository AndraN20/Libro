from app.repositories.progress_repository import ProgressRepository
from app.dto.progress_dto import ProgressCreateDto, ProgressUpdateDto
from sqlalchemy.orm import Session
from app.mappers.progress_mapper import to_dto, to_entity

class ProgressService:
    def __init__(self,db:Session):
        self.db = db
        self.progress_repository = ProgressRepository(db)

    def get_progress_by_user_and_book(self, user_id: int, book_id: int):
        progress = self.progress_repository.get_progress_by_user_and_book(user_id, book_id)
        if not progress:
            raise ValueError("progress not found")
        return to_dto(progress)
    
    def add_progress(self,progressCreateDto:ProgressCreateDto, user_id: int, book_id: int):

        progress = self.progress_repository.get_progress_by_user_and_book(user_id, book_id)
        if progress:
            raise ValueError("progress already exists")
        try:
            progress_to_save = to_entity(progressCreateDto, book_id,user_id)
            saved_progress = self.progress_repository.add_progress(progress_to_save)
            return to_dto(saved_progress)
        except Exception as e:
            raise ValueError(f"progress save failed: {e}")

    def edit_progress(self, user_id: int, book_id: int, progress_update_dto:ProgressUpdateDto):
        progress_update = progress_update_dto.dict(exclude_unset=True)
        try:
            updated_progress = self.progress_repository.edit_progress(user_id, book_id, progress_update)
            return to_dto(updated_progress)
        except Exception as e:
            raise ValueError(f"progress update failed: {e}")

    def delete_progress(self, user_id: int, book_id: int):
        progress = self.progress_repository.get_progress_by_user_and_book(user_id, book_id)
        if not progress:
            raise ValueError("progress not found")
        try:
            self.progress_repository.delete_progress(user_id, book_id)
        except Exception as e:
            raise ValueError(f"progress delete failed: {e}")
        