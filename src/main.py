import time
from typing import Optional
from fastapi import Depends, FastAPI, Request, Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

import sys
import boto3

from database.triangle import Triangle, TriangleBase
sys.path.insert(1, '/src')

from database.base import init_db, get_session


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

    if triangle.side1 == triangle.side2 and triangle.side1 == triangle.side3:
        triangle.type = "equilateral"

    elif triangle.side1 == triangle.side2 or triangle.side1 == triangle.side3 or triangle.side2 == triangle.side3:
        triangle.type = "isosceles"

    else:
        triangle.type = "scalene"

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


async def save_log(message, log_stream):
    logs = boto3.client("logs")
    log_group = "triangle-classification-api-logs"

    timestamp = int(round(time.time() * 1000))

    logs.put_log_events(
        logGroupName = log_group,
        logStreamName = log_stream,
        logEvents = [
            {
                "timestamp":timestamp,
                "message":str(message),
            }
        ]
    )
