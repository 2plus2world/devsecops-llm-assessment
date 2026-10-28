
from fastapi import FastAPI, HTTPException

app = FastAPI(title="Catalog Service", version="1.0.0")

ITEMS = [
    {"id": 1, "name": "Laptop", "category": "Electronics"},
    {"id": 2, "name": "Keyboard", "category": "Accessories"},
    {"id": 3, "name": "Monitor", "category": "Electronics"},
]


@app.get("/healthz")
def health():
    return {"status": "healthy"}


@app.get("/items")
def list_items():
    return {"items": ITEMS}


@app.get("/items/{item_id}")
def get_item(item_id: int):
    for item in ITEMS:
        if item["id"] == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item not found")