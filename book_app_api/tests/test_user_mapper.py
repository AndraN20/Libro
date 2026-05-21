import base64
from unittest.mock import MagicMock

from app.dto.user_dto import UserCreateDto
from app.mappers.user_mapper import to_dto, to_entity


def test_to_entity_maps_all_fields():
    dto = UserCreateDto(username="alice", email="alice@example.com", password="pw")
    entity = to_entity(dto)
    assert entity.username == "alice"
    assert entity.email == "alice@example.com"
    assert entity.password == "pw"


def test_to_entity_sets_profile_picture_none():
    dto = UserCreateDto(username="alice", email="alice@example.com", password="pw")
    entity = to_entity(dto)
    assert entity.profile_picture is None


def test_to_dto_maps_all_fields():
    user = MagicMock()
    user.id = 1
    user.username = "alice"
    user.email = "alice@example.com"
    user.password = "hashedpw"
    user.profile_picture = None

    dto = to_dto(user)
    assert dto.id == 1
    assert dto.username == "alice"
    assert dto.email == "alice@example.com"


def test_to_dto_profile_picture_none_when_no_image():
    user = MagicMock()
    user.id = 1
    user.username = "alice"
    user.email = "alice@example.com"
    user.password = "hashedpw"
    user.profile_picture = None

    dto = to_dto(user)
    assert dto.profile_picture_base64 is None


def test_to_dto_encodes_profile_picture_as_base64():
    user = MagicMock()
    user.id = 2
    user.username = "bob"
    user.email = "bob@example.com"
    user.password = "hashedpw"
    user.profile_picture = b"fake_image_bytes"

    dto = to_dto(user)
    expected = base64.b64encode(b"fake_image_bytes").decode("utf-8")
    assert dto.profile_picture_base64 == expected
