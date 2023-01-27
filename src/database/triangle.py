from sqlmodel import SQLModel, Field

class Triangle(SQLModel, table=True):
	id: int = Field(primary_key=True)
	side1: int
	side2: int
	side3: int
