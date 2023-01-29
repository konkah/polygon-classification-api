from sqlmodel import SQLModel, Field
from pydantic import PositiveInt

class TriangleBase(SQLModel):
	id: int = 0
	side1: PositiveInt
	side2: PositiveInt
	side3: PositiveInt


class Triangle(TriangleBase, table=True):
	id: int = Field(primary_key=True)
	type: str
