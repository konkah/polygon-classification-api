import sys
sys.path.insert(1, '..')

from database.triangle import Triangle
from validations.triangle import set_triangle_type

def test_equilateral():
    triangle = Triangle(
        side1 = 5,
        side2 = 5,
        side3 = 5,
    )

    set_triangle_type(triangle)

    assert triangle.type == "equilateral"


def test_isosceles():
    triangle = Triangle(
        side1 = 5,
        side2 = 10,
        side3 = 5,
    )

    set_triangle_type(triangle)

    assert triangle.type == "isosceles"


def test_scalene():
    triangle = Triangle(
        side1 = 3,
        side2 = 4,
        side3 = 5,
    )

    set_triangle_type(triangle)

    assert triangle.type == "scalene"
