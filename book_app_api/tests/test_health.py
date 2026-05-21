def test_health_check_returns_200(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_health_check_returns_ok_status(client):
    response = client.get("/health")
    data = response.json()
    assert data["status"] == "OK"


def test_health_check_returns_message(client):
    response = client.get("/health")
    data = response.json()
    assert "message" in data
    assert len(data["message"]) > 0
