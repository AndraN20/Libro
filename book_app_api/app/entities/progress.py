
from datetime import datetime

from typing import List
from app.entities.enums.status_enum import StatusEnum
from sqlalchemy import Enum, ForeignKey, String, DateTime
from app.core.database_config import Base
from sqlalchemy.orm import relationship, mapped_column, Mapped


class Progress(Base):
    __tablename__ = "progress" 

    book_id: Mapped[int] = mapped_column(ForeignKey("book.id", ondelete="CASCADE"), primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id", ondelete="CASCADE"), primary_key=True) 
    percentage: Mapped[float] = mapped_column(nullable=False)
    
    status: Mapped[StatusEnum] = mapped_column(Enum(StatusEnum), nullable=False, default=StatusEnum.not_started)
    epub_cfi: Mapped[str] = mapped_column(String(1024), nullable=True)
    character_position: Mapped[int] = mapped_column(nullable=True)
    last_read_at: Mapped[datetime] = mapped_column(DateTime(timezone=True),nullable=True)

    user: Mapped["User"] = relationship("User", back_populates="progress")
    book: Mapped["Book"] = relationship("Book", back_populates="progress")
    interactions: Mapped[List["Interaction"]] = relationship("Interaction",back_populates="progress",lazy="selectin")