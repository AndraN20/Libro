
from app.dto.progress_dto import ProgressDto
from app.entities.progress import Progress


def to_dto(progress:Progress) -> ProgressDto:
    return ProgressDto(
        book_id=progress.book_id,
        user_id=progress.user_id,
        percentage=progress.percentage,
        page=progress.page,
        chapter=progress.chapter,
        status=progress.status
    )


    