
import os
import httpx
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Assistant Service", version="1.0.0")

CATALOG_URL = os.getenv(
    "CATALOG_URL",
    "http://host.docker.internal:8001"
)

LLM_URL = os.getenv(
    "LLM_URL",
    "http://host.docker.internal:8080"
)


class AnswerRequest(BaseModel):
    question: str
    item_id: int | None = None


@app.get("/healthz")
def health():
    return {"status": "healthy"}


@app.post("/answer")
async def answer(request: AnswerRequest):
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get(f"{CATALOG_URL}/items")
            response.raise_for_status()
            items = response.json()
    except httpx.HTTPError as exc:
        raise HTTPException(
            status_code=502,
            detail="Catalog service unavailable"
        ) from exc

    context = items.get("items", items) if isinstance(items, dict) else items

    prompt = (
        "Answer the user's question using the catalog context below. "
        "If the information is missing, say so.\n\n"
        f"Catalog: {context}\n"
        f"Item ID: {request.item_id}\n"
        f"Question: {request.question}"
    )

    try:
        async with httpx.AsyncClient(timeout=120.0) as client:
            response = await client.post(
                f"{LLM_URL}/api/generate",
                json={
                    "model": os.getenv("LLM_MODEL", "qwen2.5:0.5b"),
                    "prompt": prompt,
                    "stream": False
                }
            )
            response.raise_for_status()
            result = response.json()
    except httpx.HTTPError as exc:
        raise HTTPException(
            status_code=502,
            detail="Local LLM unavailable"
        ) from exc

    return {
        "answer": result.get("response", ""),
        "item_id": request.item_id
    }
