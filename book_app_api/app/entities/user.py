from typing import List
from sqlalchemy import String
from app.core.database_config import Base
from sqlalchemy.orm import mapped_column, Mapped, relationship

class User(Base):
    __tablename__ = "user"

    id: Mapped[int] = mapped_column(primary_key=True,autoincrement=True)
    username: Mapped[str] = mapped_column(String(255))
    email: Mapped[str] = mapped_column(unique=True,nullable=False)
    password: Mapped[str] = mapped_column(nullable=False)
    profile_picture: Mapped[bytes] = mapped_column(nullable=True)
    
    progress: Mapped[List["Progress"]] = relationship("Progress",back_populates="user",lazy="select")

