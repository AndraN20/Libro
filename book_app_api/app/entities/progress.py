from typing import List
from sqlalchemy import Column, Integer, ForeignKey, Float, UniqueConstraint
from book_app_api.app.core.database import Base
from sqlalchemy.orm import relationship, mapped_column, Mapped


class Progress(Base):
    __tablename__ = "progress" 

    book_id: Mapped[int] = mapped_column(ForeignKey("book.id", ondelete="CASCADE"), primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id", ondelete="CASCADE"), primary_key=True) 
    percentage: Mapped[float] = mapped_column(nullable=False)
    last_page_read: Mapped[int] = mapped_column(nullable=True)
    last_chapter_read: Mapped[int] = mapped_column(nullable=True)

    user: Mapped["User"] = relationship("User", back_populates="progress")
    book: Mapped["Book"] = relationship("Book", back_populates="progress")
    annotations: Mapped[List["Annotation"]] = relationship(back_populates="progress")