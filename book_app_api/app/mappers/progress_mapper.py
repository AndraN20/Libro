
from app.dto.progress_dto import ProgressCreateDto, ProgressDto
from app.entities.progress import Progress
from app.entities.enums.status_enum import StatusEnum
def to_dto(progress: Progress) -> ProgressDto:
    return ProgressDto(
        book_id=progress.book_id,
        epub_cfi=progress.epub_cfi,
        last_read_at=progress.last_read_at,
        status=progress.status,
    )

def to_entity(dto:ProgressCreateDto,book_id:int, user_id:int)->Progress:
    return Progress(
        book_id=book_id,
        user_id=user_id,
        epub_cfi=dto.epub_cfi,
        last_read_at=dto.last_read_at,
        status=dto.status)


    