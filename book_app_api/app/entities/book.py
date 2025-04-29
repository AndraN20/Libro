from sqlalchemy import ForeignKey, String, Enum
from book_app_api.app.core.database import Base
from book_app_api.app.entities.enums.status_enum import StatusEnum
from sqlalchemy.orm import relationship, mapped_column, Mapped
from typing import List

class Book(Base):
    __tablename__ = "book"
    id: Mapped[int] = mapped_column(primary_key = True, autoincrement=True)
    book_url: Mapped[str] = mapped_column(nullable=False)
    provider_id: Mapped[int] = mapped_column(ForeignKey("provider.id", ondelete="CASCADE"), nullable=False)
    
    description: Mapped[str] = mapped_column( nullable=True)
    cover_url: Mapped[str] = mapped_column(nullable=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    author: Mapped[str] = mapped_column(String(255), nullable=False)
    status: Mapped[StatusEnum] = mapped_column(Enum(StatusEnum), nullable=False, default=StatusEnum.not_started)

    progress: Mapped[List["Progress"]] = relationship(back_populates="book")
    provider: Mapped["Provider"] = relationship(back_populates="books")
    chapters: Mapped[List["Chapter"]] = relationship(back_populates="book", order_by="Chapter.order")
    annotations: Mapped[List["Annotation"]] = relationship(back_populates="book")