from datetime import datetime
from app.entities.enums.status_enum import StatusEnum
from sqlalchemy.orm import Session, selectinload
from app.entities.progress import Progress
from typing import List, Optional

class ProgressRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_progress_by_user_and_book(self, user_id: int, book_id: int) -> Optional[Progress]:
        return self.db.query(Progress) \
            .filter(Progress.user_id == user_id, Progress.book_id == book_id) \
            .first()

    
    def add_progress(self, progress:Progress) -> Progress:
        progress = Progress(book_id=progress.book_id,
                            user_id=progress.user_id,
                            epub_cfi=progress.epub_cfi,
                            last_read_at=datetime.now(),
                            status=StatusEnum.in_progress)
        try:
            self.db.add(progress)
            self.db.commit()
            self.db.refresh(progress)
            return progress
        except Exception as e:
            self.db.rollback()
            raise ValueError(f"progress save failed: {e}")\
            
    def edit_progress(self, user_id:int, book_id:int, update_data: dict) -> Progress:
        progress = self.db.query(Progress) \
            .filter(Progress.book_id == book_id, Progress.user_id == user_id) \
            .first()
        
        if not progress:
            raise ValueError("progress not found")
        
        for key, value in update_data.items():
            setattr(progress, key, value)

        try:
            self.db.commit()
            self.db.refresh(progress)
            return progress
        except Exception as e:
            self.db.rollback()
            raise ValueError(f"progress update failed: {e}")
        
    def delete_progress(self, user_id:int, book_id:int) -> None:
        try:
            progress = self.db.query(Progress) \
                .filter(Progress.book_id == book_id, Progress.user_id == user_id) \
                .first()
            
            if not progress:
                raise ValueError("progress not found")
            
            self.db.delete(progress)
            self.db.commit()
        except Exception as e:  
            self.db.rollback()
            raise ValueError(f"progress delete failed: {e}")

    