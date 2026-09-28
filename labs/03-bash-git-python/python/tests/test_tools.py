import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from fastapi.testclient import TestClient  # noqa: E402

import log_analyzer  # noqa: E402
from app import app  # noqa: E402

SAMPLE = [
    '10.0.0.1 - - [27/Sep/2026:10:00:00 +0530] "GET / HTTP/1.1" 200 512',
    '10.0.0.2 - - [27/Sep/2026:10:00:01 +0530] "GET /api HTTP/1.1" 500 12',
    'garbage line',
]


def test_parse_line():
    rec = log_analyzer.parse_line(SAMPLE[0])
    assert rec["ip"] == "10.0.0.1"
    assert rec["status"] == 200
    assert log_analyzer.parse_line("garbage") is None


def test_analyze_error_rate():
    report = log_analyzer.analyze(SAMPLE)
    assert report["total"] == 2
    assert report["error_rate"] == 50.0
    assert report["top_error_ips"]["10.0.0.2"] == 1


def test_api_roundtrip():
    client = TestClient(app)
    assert client.get("/health").json()["status"] == "ok"
    created = client.post("/items", json={"name": "book"}).json()
    assert client.get(f"/items/{created['id']}").json()["name"] == "book"
    assert client.get("/items/999").status_code == 404
