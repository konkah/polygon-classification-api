from sqlmodel import SQLModel, Field


class TriangleBase(SQLModel):
	side1: int
	side2: int
	side3: int


class Triangle(TriangleBase, table=True):
	id: int = Field(primary_key=True)
