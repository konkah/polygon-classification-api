import sys
sys.path.insert(1, '/src')

from fastapi import Depends, FastAPI, Request, Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from database.triangle import Triangle, TriangleBase
from database.base import init_db, get_session
from logs.aws import save_log
from validations.triangle import set_triangle_type


app = FastAPI()


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
