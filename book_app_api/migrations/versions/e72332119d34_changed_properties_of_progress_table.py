"""changed properties of progress table

Revision ID: e72332119d34
Revises: 82d026d81977
Create Date: 2025-06-06 19:24:08.544101

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e72332119d34'
down_revision: Union[str, None] = '82d026d81977'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('progress', sa.Column('epub_cfi', sa.String(length=1024), nullable=True))
    op.add_column('progress', sa.Column('character_position', sa.Integer(), nullable=True))
    op.add_column('progress', sa.Column('last_read_at', sa.DateTime(timezone=True), nullable=True))
    op.drop_column('progress', 'page')
    op.drop_column('progress', 'chapter')
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('progress', sa.Column('chapter', sa.INTEGER(), autoincrement=False, nullable=True))
    op.add_column('progress', sa.Column('page', sa.INTEGER(), autoincrement=False, nullable=True))
    op.drop_column('progress', 'last_read_at')
    op.drop_column('progress', 'character_position')
    op.drop_column('progress', 'epub_cfi')
    # ### end Alembic commands ###
