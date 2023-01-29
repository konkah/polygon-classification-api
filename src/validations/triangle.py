from database.triangle import Triangle


def set_triangle_type(triangle:Triangle):
    if triangle.side1 == triangle.side2 and triangle.side1 == triangle.side3:
        triangle.type = "equilateral"

    elif triangle.side1 == triangle.side2 or triangle.side1 == triangle.side3 or triangle.side2 == triangle.side3:
        triangle.type = "isosceles"

    else:
        triangle.type = "scalene"


def verify_triangle(triangle:Triangle):
    if not triangle.side1:
        return False

    elif not triangle.side2:
        return False

    elif not triangle.side3:
        return False

    elif triangle.side1 + triangle.side2 <= triangle.side3:
        return False

    elif triangle.side1 + triangle.side3 <= triangle.side2:
        return False

    elif triangle.side2 + triangle.side3 <= triangle.side1:
        return False

    else:
        return True
