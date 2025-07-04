"""changed collumns again

Revision ID: 8939b22eb9fb
Revises: 41044cb61e0a
Create Date: 2025-05-06 14:22:27.177124

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8939b22eb9fb'
down_revision: Union[str, None] = '41044cb61e0a'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('progress', sa.Column('page', sa.Integer(), nullable=True))
    op.add_column('progress', sa.Column('chapter', sa.Integer(), nullable=True))
    op.drop_column('progress', 'last_chapter_read')
    op.drop_column('progress', 'last_page_read')
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('progress', sa.Column('last_page_read', sa.INTEGER(), autoincrement=False, nullable=True))
    op.add_column('progress', sa.Column('last_chapter_read', sa.INTEGER(), autoincrement=False, nullable=True))
    op.drop_column('progress', 'chapter')
    op.drop_column('progress', 'page')
    # ### end Alembic commands ###
