from sqlalchemy import ForeignKey, String, Enum, LargeBinary
from app.core.database_config import Base
from sqlalchemy.orm import relationship, mapped_column, Mapped
from typing import List

class Book(Base):
    __tablename__ = "book"
    id: Mapped[int] = mapped_column(primary_key = True, autoincrement=True)
    book_url: Mapped[str] = mapped_column(nullable=False)
   
    genre: Mapped[str] = mapped_column(nullable=True)
    description: Mapped[str] = mapped_column( nullable=True)
    cover_data: Mapped[bytes] = mapped_column(LargeBinary, nullable=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    author: Mapped[str] = mapped_column(String(255), nullable=False)
    date: Mapped[str] = mapped_column(nullable=True)
    language: Mapped[str] = mapped_column(nullable=True)

    progress: Mapped[List["Progress"]] = relationship("Progress",back_populates="book",lazy="select")
    