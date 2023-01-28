from typing import Optional
from fastapi import Depends, FastAPI
from sqlalchemy.ext.asyncio import AsyncSession

import sys

from database.triangle import Triangle
sys.path.insert(1, '/src')

from database.base import init_db, get_session


app = FastAPI()


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/api/status")
async def status():
    return "Ok"


@app.get("/api/triangle")
async def post_triangle(side1:int, side2:int, side3:int, session: AsyncSession = Depends(get_session)):
    triangle = Triangle()
    triangle.side1 = side1
    triangle.side2 = side2
    triangle.side3 = side3
    session.add(triangle)
    session.commit()
    session.refresh(triangle)

    if side1 == side2 and side1 == side3:
        triangle_type = "equilateral"

    elif side1 == side2 or side1 == side3 or side2 == side3:
        triangle_type = "isosceles"

    else:
        triangle_type = "scalene"

    return {"triangle type":triangle_type}
