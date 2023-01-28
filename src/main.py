from typing import Optional
from fastapi import Depends, FastAPI
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

import sys

from database.triangle import Triangle, TriangleBase
sys.path.insert(1, '/src')

from database.base import init_db, get_session


app = FastAPI()


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/api/status")
async def status():
    return "Ok"


@app.post("/api/triangles")
async def post_triangle(triangle: TriangleBase, session: AsyncSession = Depends(get_session)):
    triangle = Triangle(
        side1 = triangle.side1,
        side2 = triangle.side2,
        side3 = triangle.side3,
    )

    if triangle.side1 == triangle.side2 and triangle.side1 == triangle.side3:
        triangle.type = "equilateral"

    elif triangle.side1 == triangle.side2 or triangle.side1 == triangle.side3 or triangle.side2 == triangle.side3:
        triangle.type = "isosceles"

    else:
        triangle.type = "scalene"

    session.add(triangle)
    session.commit()
    session.refresh(triangle)

    return {"triangle type":triangle.type}


@app.get("/api/triangles")
async def get_triangle(session: AsyncSession = Depends(get_session)):
    result = session.execute(select(Triangle))

    return result.scalars().all()
