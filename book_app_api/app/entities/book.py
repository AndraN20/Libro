from sqlalchemy import ForeignKey, String, Enum, LargeBinary
from app.core.database_config import Base
from sqlalchemy.orm import relationship, mapped_column, Mapped
from typing import List

class Book(Base):
    __tablename__ = "book"
    id: Mapped[int] = mapped_column(primary_key = True, autoincrement=True)
    book_url: Mapped[str] = mapped_column(nullable=False)
    # provider_id: Mapped[int] = mapped_column(ForeignKey("provider.id", ondelete="CASCADE"), nullable=False)
    genre: Mapped[str] = mapped_column(nullable=True)
    description: Mapped[str] = mapped_column( nullable=True)
    cover_data: Mapped[bytes] = mapped_column(LargeBinary, nullable=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    author: Mapped[str] = mapped_column(String(255), nullable=False)
    date: Mapped[str] = mapped_column(nullable=True)
    language: Mapped[str] = mapped_column(nullable=True)


    # chapters: Mapped[List["Chapter"]] = relationship(back_populates="book")
    progress: Mapped[List["Progress"]] = relationship("Progress",back_populates="book",lazy="select")
    # provider: Mapped["Provider"] = relationship(back_populates="books")