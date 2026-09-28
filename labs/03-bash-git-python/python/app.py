"""A tiny REST API used throughout the labs (Docker, Kubernetes, Istio, observability).

Run locally:  uvicorn app:app --reload --port 8000
Try:          curl localhost:8000/health ; curl -X POST localhost:8000/items -H 'content-type: application/json' -d '{"name":"book"}'
"""
import os
import socket

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="lab-api")
ITEMS: dict[int, str] = {}
VERSION = os.getenv("APP_VERSION", "v1")


class Item(BaseModel):
    name: str


@app.get("/health")
def health():
    return {"status": "ok", "version": VERSION, "host": socket.gethostname()}


@app.get("/items")
def list_items():
    return [{"id": i, "name": n} for i, n in ITEMS.items()]


@app.post("/items", status_code=201)
def create_item(item: Item):
    new_id = max(ITEMS, default=0) + 1
    ITEMS[new_id] = item.name
    return {"id": new_id, "name": item.name}


@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id not in ITEMS:
        raise HTTPException(status_code=404, detail="not found")
    return {"id": item_id, "name": ITEMS[item_id]}
