from book_app_api.app.core.database import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey, Index

class Chapter(Base):
    __tablename__ = "chapter"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True) 
    epub_id: Mapped[str] = mapped_column(String(255), nullable=False) 
    book_id: Mapped[int] = mapped_column(ForeignKey("book.id", ondelete="CASCADE"), nullable=False)
    href: Mapped[str] = mapped_column(nullable=False)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    order: Mapped[int] = mapped_column(nullable=False)
    
    __table_args__ = (Index('uq_chapter_epub_id_book_id', 'epub_id', 'book_id', unique=True),)
    
    book: Mapped["Book"] = relationship(back_populates="chapters")