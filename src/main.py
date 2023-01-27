from typing import Optional
from fastapi import FastAPI

import sys
sys.path.insert(1, '/src')

from database.base import init_db


app = FastAPI()


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/api/status")
async def status():
    return "Ok"