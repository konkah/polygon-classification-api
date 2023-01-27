from sqlmodel import SQLModel, Field

class Triangle(SQLModel):
	id: int = Field(primary_key=True)
	side1: int
	side2: int
	side3: int
