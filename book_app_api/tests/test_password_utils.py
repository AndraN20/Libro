from app.utils.password_utils import hash_password, verify_password


def test_hash_password_returns_string():
    hashed = hash_password("secret123")
    assert isinstance(hashed, str)


def test_hash_password_does_not_store_plain_text():
    hashed = hash_password("secret123")
    assert hashed != "secret123"


def test_verify_password_correct():
    hashed = hash_password("mypassword")
    assert verify_password("mypassword", hashed) is True


def test_verify_password_wrong():
    hashed = hash_password("mypassword")
    assert verify_password("wrongpassword", hashed) is False


def test_same_password_produces_different_hashes():
    hash1 = hash_password("password")
    hash2 = hash_password("password")
    assert hash1 != hash2
