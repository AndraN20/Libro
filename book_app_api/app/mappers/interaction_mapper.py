from app.dto.interaction_dto import InteractionCreateDto, InteractionDto
from app.entities.interaction import Interaction


def to_dto(interaction: Interaction) -> InteractionDto:
    return InteractionDto(
        id=interaction.id,
        type=interaction.type,
        page_number=interaction.page_number,
        cfi=interaction.cfi,
        text=interaction.text
    )

def to_entity(interaction_dto: InteractionCreateDto) -> Interaction:
    return Interaction(
        type=interaction_dto.type,
        page_number=interaction_dto.page_number,
        cfi=interaction_dto.cfi,
        text=interaction_dto.text
    )