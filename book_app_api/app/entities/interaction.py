from sqlalchemy import ForeignKey, Enum, ForeignKeyConstraint
from app.core.database_config import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.entities.enums.annotation_type import AnnotationType

class Interaction(Base):
    __tablename__ = "interaction"
    __table_args__ = (
        ForeignKeyConstraint(
            ['user_id', 'book_id'],
            ['progress.user_id', 'progress.book_id'],
            ondelete="CASCADE"
        ),
    )

    id: Mapped[int] = mapped_column(primary_key=True,autoincrement=True)
    
    type: Mapped[AnnotationType] = mapped_column(Enum(AnnotationType),nullable=False)
    page_number: Mapped[int] = mapped_column(nullable=True)

    cfi: Mapped[str] = mapped_column(nullable=True)
    text: Mapped[str] = mapped_column(nullable=True)

    user_id: Mapped[int] = mapped_column()
    book_id: Mapped[int] = mapped_column()

    progress: Mapped["Progress"] = relationship("Progress",back_populates="interactions",lazy="select")
    