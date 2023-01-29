import sys
sys.path.insert(1, '..')

from database.triangle import Triangle
from validations.triangle import set_triangle_type, verify_triangle


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


def test_side1_zero():
    triangle = Triangle(
        side1 = 0,
        side2 = 4,
        side3 = 5,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_side2_zero():
    triangle = Triangle(
        side1 = 5,
        side2 = 0,
        side3 = 5,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_side3_zero():
    triangle = Triangle(
        side1 = 4,
        side2 = 4,
        side3 = 0,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_plus_sides_1and2():
    triangle = Triangle(
        side1 = 1,
        side2 = 1,
        side3 = 3,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_plus_sides_1and3():
    triangle = Triangle(
        side1 = 1,
        side2 = 3,
        side3 = 1,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_plus_sides_2and3():
    triangle = Triangle(
        side1 = 3,
        side2 = 1,
        side3 = 1,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == False


def test_successfully_sides():
    triangle = Triangle(
        side1 = 3,
        side2 = 4,
        side3 = 5,
    )

    is_verified = verify_triangle(triangle)

    assert is_verified == True
