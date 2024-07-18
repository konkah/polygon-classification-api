import sys
sys.path.insert(1, '/src')

from fastapi import Depends, FastAPI, Request, Response, HTTPException
from fastapi.exception_handlers import http_exception_handler
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from database.square import Square, SquareBase
from database.triangle import Triangle, TriangleBase
from database.base import init_db, get_session
from logs.save_log import save_log
from validations.square import set_square_type, verify_square
from validations.triangle import set_triangle_type, verify_triangle


app = FastAPI()


@app.exception_handler(HTTPException)
async def custom_http_exception_handler(request, exc):
    await save_log(exc.__dict__, "errors")
    return await http_exception_handler(request, exc)


async def catch_exceptions_middleware(request: Request, call_next):
    try:
        return await call_next(request)
    except Exception as exception:
        await save_log(exception, "errors")
        return Response("Internal server error", status_code=500)

app.middleware('http')(catch_exceptions_middleware)


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

    if not verify_triangle(triangle):
        raise HTTPException(status_code=400, detail="It's not a triangle")

    set_triangle_type(triangle)

    session.add(triangle)
    session.commit()
    session.refresh(triangle)

    await save_log(f"It's a Triangle: {triangle.side1}, {triangle.side2}, {triangle.side3}", "succeededs")

    return {"triangle type":triangle.type}


@app.get("/api/triangles")
async def get_triangle(session: AsyncSession = Depends(get_session)):
    # raise Exception("error") - Used to force an error
    result = session.execute(select(Triangle))
    # await save_log("Success") - Used to send logs to AWS

    return result.scalars().all()


@app.post("/api/squares")
async def post_square(square: SquareBase, session: AsyncSession = Depends(get_session)):
    square = Square(
        side1 = square.side1,
        side2 = square.side2,
        side3 = square.side3,
        side4 = square.side4,
    )

    if not verify_square(square):
        raise HTTPException(status_code=400, detail="It's not a square")

    set_square_type(square)

    session.add(square)
    session.commit()
    session.refresh(square)

    await save_log(f"It's a Square: {square.side1}, {square.side2}, {square.side3}", "succeededs")

    return {"square type":square.type}


@app.get("/api/squares")
async def get_square(session: AsyncSession = Depends(get_session)):
    # raise Exception("error") - Used to force an error
    result = session.execute(select(Square))
    # await save_log("Success") - Used to send logs to AWS

    return result.scalars().all()
