from sqlmodel import SQLModel, Field
from pydantic import PositiveInt

class SquareBase(SQLModel):
	side1: PositiveInt
	side2: PositiveInt
	side3: PositiveInt
	side4: PositiveInt


class Square(SquareBase, table=True):
	id: int = Field(primary_key=True)
	type: str
