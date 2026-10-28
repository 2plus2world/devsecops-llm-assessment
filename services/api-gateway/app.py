
import os

import httpx
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="API Gateway", version="1.0.0")

CATALOG_URL = os.getenv("CATALOG_URL", "http://host.docker.internal:8001")
ASSISTANT_URL = os.getenv("ASSISTANT_URL", "http://host.docker.internal:8002")


class AskRequest(BaseModel):
    question: str
    item_id: int | None = None


@app.get("/healthz")
def health():
    return {"status": "healthy"}


@app.get("/api/v1/items")
async def list_items():
    async with httpx.AsyncClient(timeout=10.0) as client:
        try:
            response = await client.get(f"{CATALOG_URL}/items")
            response.raise_for_status()
            return response.json()
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=502, detail="Catalog service unavailable"
            ) from exc


@app.post("/api/v1/ask")
async def ask(request: AskRequest):
    async with httpx.AsyncClient(timeout=60.0) as client:
        try:
            response = await client.post(
                f"{ASSISTANT_URL}/answer",
                json=request.model_dump(),
            )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPError as exc:
            raise HTTPException(
                status_code=502, detail="Assistant service unavailable"
            ) from exc
