from typing import List
from sqlalchemy import String
from book_app_api.app.core.database import Base
from sqlalchemy.orm import mapped_column, Mapped, relationship
class User(Base):
    __tablename__ = "user"

    id: Mapped[int] = mapped_column(primary_key=True,autoincrement=True)
    name: Mapped[str] = mapped_column(String(255))
    email: Mapped[str] = mapped_column(unique=True,nullable=False)
    password: Mapped[str] = mapped_column(nullable=False)
    
    progress: Mapped[List["Progress"]] = relationship(back_populates="user")

