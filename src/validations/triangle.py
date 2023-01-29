from database.triangle import Triangle


def set_triangle_type(triangle:Triangle):
    if triangle.side1 == triangle.side2 and triangle.side1 == triangle.side3:
        triangle.type = "equilateral"

    elif triangle.side1 == triangle.side2 or triangle.side1 == triangle.side3 or triangle.side2 == triangle.side3:
        triangle.type = "isosceles"

    else:
        triangle.type = "scalene"
