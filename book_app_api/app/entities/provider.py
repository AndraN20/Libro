# from typing import List
# from core.database_config import Base
# from sqlalchemy.orm import Mapped, mapped_column, relationship
# from sqlalchemy import Enum
# from book_app_api.app.entities.enums.storage_type_enum import StorageTypeEnum

# class Provider(Base):
#     __tablename__="provider"
#     id:Mapped[int] = mapped_column(primary_key=True,autoincrement=True)
#     name: Mapped[str] = mapped_column()
#     storage_type: Mapped[StorageTypeEnum] = mapped_column(Enum(StorageTypeEnum),nullable=False,default=StorageTypeEnum.GCS)
#     bucket_name: Mapped[str] = mapped_column(nullable=True)
#     region: Mapped[str] = mapped_column(nullable=True)
    
#     books: Mapped[List["Book"]] = relationship(back_populates="provider")