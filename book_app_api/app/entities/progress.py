
from typing import List
from app.entities.enums.status_enum import StatusEnum
from sqlalchemy import Enum, ForeignKey
from app.core.database_config import Base
from sqlalchemy.orm import relationship, mapped_column, Mapped


class Progress(Base):
    __tablename__ = "progress" 

    book_id: Mapped[int] = mapped_column(ForeignKey("book.id", ondelete="CASCADE"), primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id", ondelete="CASCADE"), primary_key=True) 
    percentage: Mapped[float] = mapped_column(nullable=False)
    page: Mapped[int] = mapped_column(nullable=True)
    chapter: Mapped[int] = mapped_column(nullable=True)
    status: Mapped[StatusEnum] = mapped_column(Enum(StatusEnum), nullable=False, default=StatusEnum.not_started)

    user: Mapped["User"] = relationship("User", back_populates="progress")
    book: Mapped["Book"] = relationship("Book", back_populates="progress")
    interactions: Mapped[List["Interaction"]] = relationship("Interaction",back_populates="progress",lazy="selectin")