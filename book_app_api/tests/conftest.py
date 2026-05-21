import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient

from app.api.health_check import router as health_router


@pytest.fixture
def test_app():
    app = FastAPI()
    app.include_router(health_router)
    return app


@pytest.fixture
def client(test_app):
    with TestClient(test_app) as c:
        yield c
